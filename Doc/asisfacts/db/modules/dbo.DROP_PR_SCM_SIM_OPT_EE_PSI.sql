



-- ==========================================================================================
-- Program:      DROP_PR_SCM_SIM_OPT_EE_PSI
-- Author:       김준규
-- Create date:  2025-11-19
-- Description:  SCM_SIM_DYN_COLS 테이블의 데이터를 조회하여 RETURN한다.
-- How to Execute: EXEC DROP_PR_SCM_SIM_OPT_EE_PSI @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_DETAIL',@P_MAX_COLS_NUM='190';
--    EXEC DROP_PR_SCM_SIM_OPT_EE_PSI @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_RECENT_PLAN',@P_MAX_COLS_NUM='10';
/*

DECLARE @V_RETVAL INT ;
DECLARE @V_STATUS INT ;
DECLARE @V_MSG    NVARCHAR(MAX);    
EXEC @V_RETVAL = [DROP_PR_SCM_SIM_OPT_EE_PSI] 
     @P_USER_ID='TEST_simulator'
    ,@P_SNAP_YYYYMMDD='20251201'
    ,@P_REPORT_TITLE='DROP_PR_SCM_SIM_OPT_EE_PSI_PSI_DETAL'
    ,@P_PLANT_ID='NB01'--NA00 NB01
    ,@P_DIVISION_ID = 'EE'
    ,@P_PLAN_TYPE = 'PR'
    ,@P_PLAN_SEQ = '1'
    ,@P_ITEM_IDS='APCAN2829A,APCCA2947A,APCAN1310A'
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
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DROP_PR_SCM_SIM_OPT_EE_PSI]
    @P_USER_ID       nvarchar(30) = ''
   ,@P_SNAP_YYYYMMDD nvarchar(8) = ''
   ,@P_REPORT_TITLE  nvarchar(254) = ''
   ,@P_MAX_COLS_NUM  INT = 800
   ,@P_PLANT_ID      nvarchar(30) = ''
   ,@P_COMPANY_ID    nvarchar(30) = ''
   ,@P_DIVISION_ID   nvarchar(30) = ''
   --,@P_PLAN_START_YYYYMMDD   nvarchar(8) = ''
   ,@P_PLAN_TYPE     nvarchar(30) = ''
   ,@P_PLAN_SEQ      INT
   --,@P_OPT_PLAN_ID   nvarchar(MAX) = ''
   ,@P_ITEM_IDS      nvarchar(MAX) = ''
   ,@P_UseProd       nvarchar(30) ='N'-- N: 현재 DEV DB사용, Y: LINKED_SERVER 운영환경 사용
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
    SET @DBPrefix = CASE WHEN ISNULL(@P_UseProd, 'N') = 'Y' THEN '[10.34.220.88,7433].[LGCE_SCMPROD].[DBO].' ELSE '[DBO].' END; -- Y: LINKED_SERVER 운영DB 사용, N: 현재 QA DB사용
    SET @DBOPTPrefix = CASE WHEN ISNULL(@P_UseProd, 'N') = 'Y' THEN '[10.34.220.88,7433].[OPTENG_SCP].[DBO].' ELSE '[OPTENG_SCP].[DBO].' END; -- Y: LINKED_SERVER 운영DB 사용, N: 현재 QA DB사용
    SET @DBFPPrefix = CASE WHEN ISNULL(@P_UseProd, 'N') = 'Y' THEN '[10.34.220.88,7433].[LGCE_FP_TR].[DBO].' ELSE (CASE WHEN DB_NAME()='LGCE_SCMPROD' THEN '[LGCE_FP_TR].[DBO].' ELSE '[LGCE_FPDEV_TR].[DBO].' END) END; -- Y: LINKED_SERVER 운영DB 사용, N: 현재 QA DB사용

    SET @CNT = 0;
    SET @RUN_TIME = 0;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_online_user NVARCHAR(150) = IIF(ISNULL(@P_USER_ID,'')='','simulator',@P_USER_ID);
    DECLARE @v_program_name NVARCHAR(150) = @P_REPORT_TITLE;
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_COMPANY_ID:'+@P_COMPANY_ID+',@P_DIVISION_ID:'+@P_DIVISION_ID+',@P_ITEM_IDS:'+ @P_ITEM_IDS;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

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
    IF @P_UseProd = 'Y' BEGIN
    SELECT @QUERY_END_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY, 0, p.horizon_end_date),112)
    FROM   dbo.scm_mst_plan p WITH(NOLOCK)
    WHERE  p.division_id = @p_division_id
    AND    p.plan_id     = (SELECT max(plan_id) FROM [10.34.220.88,7433].[LGCE_SCMPROD].[DBO].scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
    AND    p.plan_cycle  = 'WEEKLY'; END;
    ELSE BEGIN-- IF @P_UseProd = 'Y' BEGIN
    SELECT @QUERY_END_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DAY, 0, p.horizon_end_date),112)
    FROM   dbo.scm_mst_plan p WITH(NOLOCK)
    WHERE  p.division_id = @p_division_id
    AND    p.plan_id     = (SELECT max(plan_id) FROM dbo.scm_mst_plan p WITH(NOLOCK) WHERE division_id = @p_division_id and plan_id < 9999)
    AND    p.plan_cycle  = 'WEEKLY'; END;

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
        AND    ISNULL(COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
        AND    ISNULL(DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
        AND    CREATED_BY = @v_online_user
        ;
        SET @i = @i + 1;
    END;

    PRINT '@P_SNAP_YYYYMMDD:'+ISNULL(@P_SNAP_YYYYMMDD,'NULL');
    PRINT '@P_REPORT_TITLE:'+ISNULL(@P_REPORT_TITLE,'NULL');
    PRINT '@P_PLANT_ID:'+ISNULL(@P_PLANT_ID,'NULL');
    PRINT '@P_COMPANY_ID:'+ISNULL(@P_COMPANY_ID,'NULL');
    PRINT '@P_DIVISION_ID:'+ISNULL(@P_DIVISION_ID,'NULL');
    PRINT '@P_PLAN_TYPE:'+ISNULL(@P_PLAN_TYPE,'NULL');
    PRINT '@P_PLAN_SEQ:'+ISNULL(CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ),'NULL');
    PRINT '@P_ITEM_IDS:'+ISNULL(@P_ITEM_IDS,'NULL');
    PRINT '@P_UseProd:'+ISNULL(@P_UseProd,'NULL');
    
    PRINT CONCAT('@P_SNAP_YYYYMMDD:',ISNULL(@P_SNAP_YYYYMMDD,'NULL')
                ,',@P_REPORT_TITLE:',ISNULL(@P_REPORT_TITLE,'NULL')
                ,',@P_PLANT_ID:',ISNULL(@P_PLANT_ID,'NULL')
                ,',@P_COMPANY_ID:',ISNULL(@P_COMPANY_ID,'NULL')
                ,',@P_DIVISION_ID:',ISNULL(@P_DIVISION_ID,'NULL')
                ,',@P_PLAN_TYPE:',ISNULL(@P_PLAN_TYPE,'NULL')
                ,',@P_PLAN_SEQ:',ISNULL(CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ),'NULL')
                ,',@P_UseProd:',ISNULL(@P_UseProd,'NULL')
                ,',@P_ITEM_IDS:',ISNULL(@P_ITEM_IDS,'NULL'));
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
    SELECT --TOP 17 
           CM.BASIS_YYYYMMDD
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
    --AND    CM.DAYOFWEEK = 'MON'
    AND    CM.BASIS_START_DATE>=@QUERY_START_YYYYMMDD --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
    AND    CM.BASIS_YYYYMMDD <= @QUERY_END_YYYYMMDD--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일

    --SELECT * FROM #TMP_CALENDAR ORDER BY BASIS_START_DATE;

    -- PIVOT IN 절에 사용할 컬럼 리스트 생성
    SELECT @PIVOT_COLS = STRING_AGG(QUOTENAME(CONVERT(VARCHAR(8), BASIS_START_DATE, 112)), ',')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC
    --GROUP BY BASIS_START_DATE
    --ORDER BY BASIS_START_DATE;

    -- PIVOT SELECT 절에 사용할 컬럼 생성
    SELECT @PIVOT_COLS_WITH_ALIAS = STRING_AGG(
        QUOTENAME(CONVERT(VARCHAR(8), BASIS_START_DATE, 112)) +
        ' AS [' + 'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112) + ']',
        ', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    --  SCM_SIM_DYN_COLS 테이블에 PIVOT INSERT 할 컬럼 생성
    SELECT @INSERT_SELECT_COLS = STRING_AGG(
        'CONVERT(VARCHAR(MAX),'+QUOTENAME('P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112))+')' +
        ' AS [' + 'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112) + ']',
        ', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    
    --  4 BOH에 ZERO INSERT 할 컬럼 생성
    SELECT @INSERT_NULL_SELECT_COLS = STRING_AGG(
        'CONVERT(VARCHAR(MAX), NULL )' +
        ' AS [' + 'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 112) + ']',
        ', ')
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
            SET @INSCOL = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INSCOL = @INSCOL + ', C' + CAST(@i AS NVARCHAR(10));

        SET @i = @i + 1;
    END
    --PRINT '@INSCOL:'+@INSCOL;

    --######################################################
    --LABEL1 LABEL1 LABEL2 LABEL2 동시에 사용
    --######################################################
    DROP TABLE IF EXISTS #TMP_WEEK_NAME_LABEL;
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
            AND    CM.BASIS_START_DATE>=@QUERY_START_YYYYMMDD --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
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
       ,COMPANY_ID
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
       ,'''+@P_COMPANY_ID+'''
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
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INS_LABEL2 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
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
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INS_LABEL3 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
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
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INS_LABEL4 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
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
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INS_LABEL5 +'
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
       ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
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
    DROP TABLE IF EXISTS ##TMP_W_PIV_RST_WEEK_RESULT;

    DROP TABLE IF EXISTS #TMP_W_DAILY_SUM;

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
    );


    SET @SQL = N'
    ;WITH W_ITEM AS (
        SELECT nr AS rnum, token AS ITEM_ID
        FROM   STRING_SPLIT ('''+@P_ITEM_IDS+N''',N'',N'')
    )
    --SELECT * FROM W_ITEM;
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
        AND    CM.BASIS_START_DATE>='''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
        AND    CM.BASIS_YYYYMMDD <= WED.HORIZON_END_DATE-- CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_CALENDAR;
    , W_LINE AS (
        SELECT LINE_ID
              ,FACTORY_ID
        FROM (
             SELECT COMPANY_ID
                   ,DIVISION_ID
                   ,SITE_ID
                   ,PLANT_ID
                   ,FACTORY_ID
                   ,OPERATION_ID
                   ,LINE_ID
                   ,ELECTRODE_TYPE
                   ,LINE_NAME
                   ,VALID_YN
                   ,RNUM = ROW_NUMBER()OVER(PARTITION BY LINE_ID ORDER BY FACTORY_ID)
             from   '+@DBPrefix+N'SCM_MST_LINE_V --LINE_ID
             WHERE  1=1
             AND    VALID_YN = ''Y''
             -- EE 가 아니고 81 등에 있음, 아래 DIVISION_ID 막아야됨
             /* AND    DIVISION_ID = '''+@P_DIVISION_ID+''' */
             AND    PLANT_ID = '''+@P_PLANT_ID+'''
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
    --SELECT * FROM W_PLAN_INFO
    ------------------
    , W_OPT_PLAN_ID AS (
        SELECT  max(plan_id) AS OPT_PLAN_ID   
        FROM    '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER  M WITH(NOLOCK)
        INNER  JOIN ( SELECT DISTINCT CONCAT(GM.PLANT_ID, ''-E'') AS SCM_SITE_ID, GR_NM AS PLAN_GROUP
                        FROM (
                            SELECT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID, GM.OPMZ_PLAN_GR_NAME GR_NM, GL.PLANT_ID, GL.LINE_ID 
                              FROM '+@DBPrefix+N'SCP_OPMZ_PLAN_GR_M GM  WITH(NOLOCK)
                                 , '+@DBPrefix+N'SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK)
                                 , '+@DBPrefix+N'SCM_MST_SITE SMS WITH(NOLOCK)
                            WHERE GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
                              AND GM.VALID_YN = ''Y''
                              AND GL.VALID_YN = ''Y''
                              AND GL.ITEM_ID = ''-''
                              AND GM.DIVISION_ID = ''EE'' '
                              IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                              SET @SQL += N'
                              AND GL.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
                              SET @SQL += N'
                              AND CONCAT(GL.PLANT_ID, ''-E'') = SMS.SCM_SITE_ID --@PLANT
                            ) GM
                            ,(
                            SELECT DISTINCT PLANT_ID, LINE_ID, LA.ITEM_ID
                              FROM '+@DBFPPrefix+N'SCM_ITEM_LINE_ASSIGN_M LA WITH(NOLOCK)
                                   JOIN W_ITEM AS WI
                                   ON  LA.ITEM_ID                  = WI.ITEM_ID
 
                             WHERE 1=1
                               AND ACTIVE_FLAG = ''Y''  '
                              IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                              SET @SQL += N'
                              AND LA.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
                              SET @SQL += N'
                               /* 미래구간에 Assign 된 Item 만 조회 */
                               --향후에 입력 일자등을 고려하여 PARAMETER로 변경 필요
                               AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE()), GETDATE()), 112), 1, 6)
                                          --   AND SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE())+363, GETDATE()), 112), 1, 6)
                               AND OPERATION_ID = ''E2000'' 
                            ) LM
                        WHERE GM.LINE_ID = LM.LINE_ID
                         AND  LM.ITEM_ID NOT IN (''APCAN2735A'',''APCCA2842A'')
                         --AND  LM.ITEM_ID IN (SELECT TOKEN 
                         --                    FROM STRING_SPLIT(@ITEM_LIST, '','')
                         --                    WHERE TOKEN NOT IN (''APCAN2735A'',''APCCA2842A'')
                         --                    )
        
                            ) B
        ON 1=1
        and M.attribute2=b.plan_group
        --WHERE   M.ATTRIBUTE1 = ''EE'' AND M.PLAN_ID = ''20251117_EE_ESNB_004''
        
        and (m.plan_id not like ''%C'' and m.plan_id not like ''%A'' and m.plan_id  like ''20%'') 
        group by attribute1, attribute2
    )
    --SELECT * FROM W_OPT_PLAN_ID;

    -------------------
    ----------------------
    , W_TACT_TIME_RAW AS (
        SELECT DISTINCT ATTRIBUTE1 AS SCM_SITE_ID,ATTRIBUTE15 AS LINE, ATTRIBUTE2 AS ITEM_ID, ''Production'' AS PSI_TYPE , ''Tact Time'' AS MEASURE
             , ATTRIBUTE14 AS YYYYMM, LOAD_PER AS TACT_TIME --1미터당 초
        FROM   '+@DBOPTPrefix+N'SCP_OPT_ENG_ROUTING_RESOURCE ERR WITH(nolock)
        JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = ERR.PLAN_ID
        --JOIN   #TMP_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = ERR.PLAN_ID

             JOIN W_ITEM AS WI
             ON  ERR.ATTRIBUTE2                  = WI.ITEM_ID
 
             JOIN W_END_D WED ON ERR.ATTRIBUTE14 BETWEEN FORMAT(GETDATE(),''yyyyMM'')  AND SUBSTRING(WED.horizon_end_date,1,6)

        WHERE  1=1  '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND LEFT(ERR.ATTRIBUTE1,4) = '''+@P_PLANT_ID+''' ' ; END;
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
             , YYYYMM, TACT_TIME --1미터당 초
        FROM   W_TACT_TIME_RAW WTR
        JOIN   W_CALENDAR AS WC ON WC.BASIS_YYYYMM = WTR.YYYYMM
    )
    --SELECT * FROM W_TACT_TIME;
    
    ------------------------
    ------------------------

    , W_ELEC_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, PLANT_ID, ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Elec Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD 
        FROM (
            SELECT PLANT_ID, OYE.ITEM_ID, YYYYMM, AVG(CONVERT(NUMERIC(20,10), ELEC_POST)) AS YIELD 
            FROM   '+@DBPrefix+N'SCP_OPMZ_YLD_ELEC OYE WITH(NOLOCK)
            
                    JOIN W_ITEM AS WI
                    ON  OYE.ITEM_ID                  = WI.ITEM_ID
                    JOIN W_END_D WED ON OYE.YYYYMM BETWEEN FORMAT(GETDATE(),''yyyyMM'')  AND SUBSTRING(WED.horizon_end_date,1,6)
            
            WHERE  1=1  '
            IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
            SET @SQL += N'
            AND OYE.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
            SET @SQL += N'
            AND    VALID_YN=''Y''
            GROUP BY PLANT_ID,OYE.ITEM_ID, YYYYMM
        ) EY            
                JOIN W_CALENDAR AS WC
                ON  EY.YYYYMM                  = WC.BASIS_YYYYMM
    )
    --SELECT * FROM W_ELEC_YIELD;
    , W_ASSY_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, PLANT_ID, ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Assy Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD  
        FROM (
            SELECT PLANT_ID,A.ITEM_ID, A.YYYYMM, AVG(CONVERT(NUMERIC(20,10), A.ASSY)) AS YIELD 
            FROM   '+@DBPrefix+N'SCP_OPMZ_YLD_ELEC A WITH(NOLOCK)
            
                    JOIN W_ITEM AS WI
                    ON  A.ITEM_ID                  = WI.ITEM_ID
                    JOIN W_END_D WED ON A.YYYYMM BETWEEN FORMAT(GETDATE(),''yyyyMM'')  AND SUBSTRING(WED.horizon_end_date,1,6)
            
              LEFT OUTER JOIN '+@DBPrefix+N'SCP_MST_BOM_ELEC  B WITH(NOLOCK)
                       ON   A.ITEM_ID = B.CHILD_ITEM_ID
                       AND  B.SCP_YN = ''Y''
            WHERE 1=1  '
            IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
            SET @SQL += N'
            AND A.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
            SET @SQL += N'
            AND VALID_YN=''Y''
            and A.ASSY <>''''
            GROUP BY PLANT_ID,A.ITEM_ID, YYYYMM
        ) AY            
                JOIN W_CALENDAR AS WC
                ON  AY.YYYYMM                  = WC.BASIS_YYYYMM
    )
    --SELECT * FROM W_ASSY_YIELD;
    , W_HOLD_REL_SITE_ITEM AS (
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

        JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID

        JOIN W_ITEM AS WI
        ON   bom.child_item_id                  = WI.ITEM_ID
        --AND    bom.child_item_id IN
        --       (SELECT token
        --         FROM   string_split(@item_list, '',''))


        WHERE  1 = 1
        --AND    a.plan_id = @plan_id
    )
    --SELECT * FROM W_HOLD_REL_SITE_ITEM;
    , W_HOLD_REL_RAW AS (
        SELECT WSI.aplant AS SCM_SITE_ID, WSI.PLANT_ID, attribute2 AS ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Hold Release'' AS MEASURE
             , effective_date AS YYYYMMDD, SUM(quantity) AS Hold_Release_QTY 
        FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock a WITH(nolock)
        INNER  JOIN W_HOLD_REL_SITE_ITEM AS WSI
        ON     WSI.child_item_id = a.attribute2
        AND    WSI.aplant = a.attribute1

        JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID '

        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND WSI.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'
        WHERE  1 = 1
        --AND    plan_id = @plan_id
        --AND    effective_date >= LEFT(@plan_id, 8) 
        AND    effective_date >= LEFT(WPI.OPT_PLAN_ID, 8) 
        --AND attribute2 IN (SELECT token
        --                   FROM   string_split(@item_list, '','')) 
        AND    TYPE = ''WH_HOLD''
        GROUP  BY WSI.aplant, WSI.PLANT_ID, attribute2
             , effective_date
        --ORDER  BY 1, 2
    )
    --SELECT * FROM W_HOLD_REL_RAW; ';
    SET @SQL += N'
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

                JOIN W_ITEM AS WI
                ON   A.attribute2                  = WI.ITEM_ID

                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE ''%E''
                AND    TYPE = ''WH''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''Assy_Site'', attribute1, attribute2, SUM(quantity)
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN W_ITEM AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE ''%A''
                AND    attribute1 LIKE LEFT  ('''+@P_PLANT_ID+''', 2) + ''%'' 
                AND    TYPE = ''WH''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''Intransit'', attribute1, attribute2, SUM(quantity)
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE LEFT  ('''+@P_PLANT_ID+''', 2) + ''%'' 
                AND    TYPE = ''INT''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''HD'', attribute1, attribute2, SUM(quantity)
                FROM   '+@DBOPTPrefix+N'scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN W_ITEM AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    TYPE = ''WH_HOLD''
                GROUP  BY attribute1, attribute2) inv  ';
    SET @SQL += N'
        LEFT   OUTER JOIN (SELECT child_item_id
                                ,MAX(convert(FLOAT, usage)) AS accumulated_child_qty
                          FROM   '+@DBOPTPrefix+N'scp_opt_eng_bom_elec n WITH(nolock)
                          --JOIN W_ITEM AS WI
                          --ON   N.child_item_id                  = WI.ITEM_ID
                          JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = N.PLAN_ID 
                          WHERE  1=1
                          --AND    plan_id = @plan_id
                          AND    scp_yn = ''Y''
                          AND    child_item_id IN
                                 (SELECT DISTINCT A.item_id
                                   FROM   '+@DBOPTPrefix+N'scp_opt_eng_model_list_n A WITH(nolock)
                                   --JOIN W_ITEM AS WI
                                   --ON   A.item_id                  = WI.ITEM_ID
                                   JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                                   WHERE  1=1
                                   --AND    plan_id = @plan_id
                                   AND    (A.item_id LIKE ''APCC%'' OR
                                         A.item_id LIKE ''APCA%''))
                          AND    parent_item_id IN
                                 (SELECT DISTINCT A.item_id a
                                   FROM   '+@DBOPTPrefix+N'scp_opt_eng_model_list_n A WITH(nolock)
                                   --JOIN W_ITEM AS WI
                                   --ON   A.item_id                  = WI.ITEM_ID
                                   JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                                   WHERE  1=1
                                   --AND    plan_id = @plan_id
                                   AND    (A.item_id LIKE ''EA%'' OR
                                         A.item_id LIKE ''AA%'' OR
                                         A.item_id LIKE ''MA%''))
                          GROUP  BY child_item_id) cv
        ON     inv.item_id = cv.child_item_id
    )  
    --SELECT * FROM W_BOH_RAW; ';
    SET @SQL += N'
    , W_BOH_PIVOT AS (
        
        SELECT /*scm_site_id AS SCM_SITE_ID, LEFT(scm_site_id,4) AS PLANT_ID,*/ ITEM_ID AS ITEM_ID, ''Inventory'' AS PSI_TYPE , ''INVENTORY_TOTAL'' AS MEASURE
             , Elec_Site AS Elec_Site_QTY, Assy_Site AS Assy_Site_QTY , Intransit AS Intransit_QTY , HD AS HD_QTY  
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
    --SELECT * FROM W_BOH_PIVOT;
    , SEMI_PLAN AS
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

                JOIN W_PLAN_INFO AS WPI
                ON  SP.DIVISION_ID              = WPI.DIVISION_ID
                AND SP.PLAN_START_YYYYMMDD      = WPI.PLAN_NAME
                AND SP.PLAN_TYPE                = WPI.PLAN_TYPE
                AND SP.SEQ                      = WPI.PLAN_SEQ
                --AND SP.YYYYMMDD                   = WPI.PLAN_NAME

                JOIN W_ITEM AS WI
                ON  SP.ITEM_ID                  = WI.ITEM_ID

                --LEFT JOIN W_CALENDAR AS WC
                --ON  SP.YYYYMMDD                 = WC.BASIS_YYYYMMDD

        WHERE   SP.DIVISION_ID          = ''EE''
        AND     SP.OPERATION_GROUP      = ''E''
        AND     SP.MEASURE              IN (''SHIP_PLAN_AMEND'')
        AND     SP.QTY                  <> 0  '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND LEFT(SP.FROM_SITE,4) = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'

    )
    --SELECT * FROM SEMI_PLAN;
    , W_ITEM_ASSY AS (
        --SELECT DISTINCT A.* ,B.CHILD_ITEM_ID, C.ITEM_ID_ASSY--(셀)
        SELECT DISTINCT A.DIVISION_ID,A.FROM_DIVISION_ID,A.ITEM_ID,A.LINE,A.FROM_SITE,C.ITEM_ID_ASSY--(셀)
        FROM SEMI_PLAN AS A
            JOIN '+@DBPrefix+N'SCP_MST_BOM_ELEC AS B
            ON  A.FROM_DIVISION_ID      = B.DIVISION_ID
            AND A.ITEM_ID               = B.CHILD_ITEM_ID
            JOIN '+@DBPrefix+N'SCP_MST_CELL_PROD_ASSY_MAP AS C
            ON  A.FROM_DIVISION_ID      = C.DIVISION_ID
            AND A.FROM_SITE             = C.PLANT_ID + ''-E''
            AND B.PARENT_ITEM_ID        = C.ITEM_ID_ASSY
    )
    --SELECT * FROM W_ITEM_ASSY;
    , W_PKG_PLAN_RAW AS (
        SELECT
              PP.DIVISION_ID
            , PP.ORIGIN_DIVISION_ID
            , PP.ITEM_ID
            , WPI.PLAN_NAME
            , WPI.PLAN_START_YYYYMMDD
            , WPI.PLAN_TYPE
            , WPI.PLAN_SEQ
            , PP.YYYYMMDD
            , SUM(PP.QTY)                   AS QTY
        FROM '+@DBPrefix+N'SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)
            JOIN W_PLAN_INFO AS WPI -- 입력한 전극 DIVISION의 SCP CELL 계획 
            ON  PP.DIVISION_ID              = WPI.DIVISION_ID
            AND PP.PLAN_START_YYYYMMDD      = WPI.PLAN_NAME
            AND PP.PLAN_TYPE                = WPI.PLAN_TYPE
            AND PP.SEQ                      = WPI.PLAN_SEQ
            --AND PP.YYYYMMDD                   = WPI.PLAN_NAME
            WHERE 1 = 1
            AND PP.OPERATION_GROUP      = ''A''
            AND PP.MEASURE              = ''PROD_PLAN_AMEND''
            AND PP.QTY                  <> 0  '
            IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
            SET @SQL += N'
            AND LEFT(PP.SCM_SITE_ID,4) = '''+@P_PLANT_ID+''' ' ; END;
            SET @SQL += N'
        GROUP BY PP.DIVISION_ID
            , PP.ORIGIN_DIVISION_ID
            , PP.ITEM_ID
            , WPI.PLAN_NAME
            , WPI.PLAN_START_YYYYMMDD
            , WPI.PLAN_TYPE
            , WPI.PLAN_SEQ
            , PP.YYYYMMDD
        HAVING SUM(PP.QTY) <> 0
    )
    --SELECT *fROM W_PKG_PLAN_RAW;
    , PKG_PROD_PLAN AS
    (
        SELECT
            PP.*
            --, WC.PARTIAL_WEEK_NAME
            --, WC.BASIS_START_DATE
            --, WC.BASIS_END_DATE
        FROM
        (
            SELECT
                  SEMI_ASSY.DIVISION_ID
                , SEMI_ASSY.FROM_DIVISION_ID
                , SEMI_ASSY.ITEM_ID --(전극)
                , SEMI_ASSY.LINE
                , ''PKG_PLAN''                    AS MEASURE
                , SEMI_ASSY.FROM_SITE
                , WPR.PLAN_NAME
                , WPR.PLAN_START_YYYYMMDD
                , WPR.PLAN_TYPE
                , WPR.PLAN_SEQ
                , WPR.YYYYMMDD
                , SUM(WPR.QTY)                  AS QTY
            FROM W_PKG_PLAN_RAW WPR
                JOIN W_ITEM_ASSY AS SEMI_ASSY
                ON  1=1
                --AND WPR.DIVISION_ID             = SEMI_ASSY.FROM_DIVISION_ID
                AND WPR.ORIGIN_DIVISION_ID      = SEMI_ASSY.FROM_DIVISION_ID
                AND WPR.ITEM_ID                 = SEMI_ASSY.ITEM_ID_ASSY
            GROUP BY SEMI_ASSY.DIVISION_ID, SEMI_ASSY.FROM_DIVISION_ID,  SEMI_ASSY.ITEM_ID , SEMI_ASSY.LINE, SEMI_ASSY.FROM_SITE 
                , WPR.PLAN_NAME
                , WPR.PLAN_START_YYYYMMDD
                , WPR.PLAN_TYPE
                , WPR.PLAN_SEQ
                , WPR.YYYYMMDD
        ) AS PP
            --LEFT JOIN W_CALENDAR AS WC
            --ON  PP.YYYYMMDD   = WC.BASIS_YYYYMMDD
    )
    --SELECT * FROM PKG_PROD_PLAN;'
    SET @SQL += N'
    --, PKG_PROD_PLAN AS
    --(
    --  SELECT
    --      PP.*
    --      --, WC.PARTIAL_WEEK_NAME
    --      --, WC.BASIS_START_DATE
    --      --, WC.BASIS_END_DATE
    --  FROM
    --  (
    --      SELECT
    --            SEMI_ASSY.DIVISION_ID
    --          , SEMI_ASSY.FROM_DIVISION_ID
    --          , SEMI_ASSY.ITEM_ID --(전극)
    --          , SEMI_ASSY.LINE
    --          , ''PKG_PLAN''                    AS MEASURE
    --          , SEMI_ASSY.FROM_SITE
    --          , PP.YYYYMMDD
    --          , SUM(PP.QTY)                   AS QTY
    --      FROM SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)
    --          JOIN W_PLAN_INFO AS WPI
    --          ON  PP.DIVISION_ID              = WPI.DIVISION_ID
    --          AND PP.PLAN_START_YYYYMMDD      = WPI.PLAN_NAME
    --          AND PP.PLAN_TYPE                = WPI.PLAN_TYPE
    --          AND PP.SEQ                      = WPI.PLAN_SEQ
    --          --AND PP.YYYYMMDD                   = WPI.PLAN_NAME

    --          JOIN W_ITEM_ASSY AS SEMI_ASSY
    --          --(
    --          --  SELECT DISTINCT A.* ,B.CHILD_ITEM_ID, C.ITEM_ID_ASSY--(셀)
    --          --  FROM SEMI_PLAN AS A
    --          --      JOIN SCP_MST_BOM_ELEC AS B
    --          --      ON  A.FROM_DIVISION_ID      = B.DIVISION_ID
    --          --      AND A.ITEM_ID               = B.CHILD_ITEM_ID
    --          --      JOIN SCP_MST_CELL_PROD_ASSY_MAP AS C
    --          --      ON  A.FROM_DIVISION_ID      = C.DIVISION_ID
    --          --      AND A.FROM_SITE             = C.PLANT_ID + ''-E''
    --          --      AND B.PARENT_ITEM_ID        = C.ITEM_ID_ASSY
    --          --) AS SEMI_ASSY
    --          ON  PP.DIVISION_ID  = SEMI_ASSY.FROM_DIVISION_ID
    --          AND PP.ITEM_ID      = SEMI_ASSY.ITEM_ID_ASSY
    --      WHERE   1 = 1
    --      AND     PP.OPERATION_GROUP      = ''A''
    --      AND     PP.MEASURE              = ''PROD_PLAN_AMEND''
    --      GROUP BY SEMI_ASSY.DIVISION_ID, SEMI_ASSY.FROM_DIVISION_ID,  SEMI_ASSY.ITEM_ID , SEMI_ASSY.LINE, PP.MEASURE, SEMI_ASSY.FROM_SITE , PP.YYYYMMDD
    --  ) AS PP
    --      LEFT JOIN W_CALENDAR AS WC
    --      ON  PP.YYYYMMDD = WC.BASIS_YYYYMMDD
    --)
 --   SELECT * FROM PKG_PROD_PLAN;'
    SET @SQL += N'
    , PROD_PLAN AS
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

                JOIN W_ITEM AS WI
                ON  PP.ITEM_ID                  = WI.ITEM_ID

                --LEFT JOIN W_CALENDAR AS WC
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
    --SELECT * FROM PROD_PLAN;
    -- SELECT * FROM SEMI_PLAN
    -- SELECT * FROM PROD_PLAN WHERE ITEM_ID = ''APCAN2829A''
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
            FROM SEMI_PLAN AS A

            UNION ALL
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
            FROM PKG_PROD_PLAN AS A '
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
            FROM PROD_PLAN AS A
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
    --AND    YYYYMMDD<=''20251229''
    ORDER BY ITEM_ID , MEASURE;
    --SELECT * FROM #TMP_W_DAILY_SUM; '+CHAR(12)+CHAR(10);
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

    PRINT '2:'+CONVERT(NVARCHAR(MAX),SYSDATETIME());

    --SELECT TOP 2 'TOP 2 #TMP_W_DAILY_SUM',* FROM #TMP_W_DAILY_SUM;


    SET @SQL = N'
    ;WITH W_ITEM AS (
        SELECT nr AS rnum, token AS ITEM_ID
        FROM   STRING_SPLIT ('''+@P_ITEM_IDS+N''',N'',N'')
    )
    --SELECT * FROM W_ITEM;
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
        AND    CM.BASIS_START_DATE>='''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
        AND    CM.BASIS_YYYYMMDD <= WED.HORIZON_END_DATE-- CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_CALENDAR;
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
        SELECT  max(plan_id) AS OPT_PLAN_ID   
        FROM    '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER  M WITH(NOLOCK)
        INNER  JOIN ( SELECT DISTINCT CONCAT(GM.PLANT_ID, ''-E'') AS SCM_SITE_ID, GR_NM AS PLAN_GROUP
                        FROM (
                            SELECT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID, GM.OPMZ_PLAN_GR_NAME GR_NM, GL.PLANT_ID, GL.LINE_ID 
                              FROM '+@DBPrefix+N'SCP_OPMZ_PLAN_GR_M GM  WITH(NOLOCK)
                                 , '+@DBPrefix+N'SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK)
                                 , '+@DBPrefix+N'SCM_MST_SITE SMS WITH(NOLOCK)
                            WHERE GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
                              AND GM.VALID_YN = ''Y''
                              AND GL.VALID_YN = ''Y''
                              AND GL.ITEM_ID = ''-''
                              AND GM.DIVISION_ID = ''EE'' '
                              IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                              SET @SQL += N'
                              AND GL.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
                              SET @SQL += N'
                              AND CONCAT(GL.PLANT_ID, ''-E'') = SMS.SCM_SITE_ID --@PLANT
                            ) GM
                            ,(
                            SELECT DISTINCT PLANT_ID, LINE_ID, LA.ITEM_ID
                              FROM '+@DBFPPrefix+N'SCM_ITEM_LINE_ASSIGN_M LA WITH(NOLOCK)
                                   JOIN W_ITEM AS WI
                                   ON  LA.ITEM_ID                  = WI.ITEM_ID
 
                             WHERE 1=1
                               AND ACTIVE_FLAG = ''Y''  '
                              IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                              SET @SQL += N'
                              AND LA.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
                              SET @SQL += N'
                               /* 미래구간에 Assign 된 Item 만 조회 */
                               --향후에 입력 일자등을 고려하여 PARAMETER로 변경 필요
                               AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE()), GETDATE()), 112), 1, 6)
                                          --   AND SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE())+363, GETDATE()), 112), 1, 6)
                               AND OPERATION_ID = ''E2000'' 
                            ) LM
                        WHERE GM.LINE_ID = LM.LINE_ID
                         AND  LM.ITEM_ID NOT IN (''APCAN2735A'',''APCCA2842A'')
                         --AND  LM.ITEM_ID IN (SELECT TOKEN 
                         --                    FROM STRING_SPLIT(@ITEM_LIST, '','')
                         --                    WHERE TOKEN NOT IN (''APCAN2735A'',''APCCA2842A'')
                         --                    )
        
                            ) B
        ON 1=1
        and M.attribute2=b.plan_group
        --WHERE   M.ATTRIBUTE1 = ''EE'' AND M.PLAN_ID = ''20251117_EE_ESNB_004''
        
        and (m.plan_id not like ''%C'' and m.plan_id not like ''%A'' and m.plan_id  like ''20%'') 
        group by attribute1, attribute2
    )
    --SELECT * FROM W_OPT_PLAN_ID;

    -------------------
    ----------------------
    , W_TACT_TIME_RAW AS (
        SELECT DISTINCT ATTRIBUTE1 AS SCM_SITE_ID,ATTRIBUTE15 AS LINE, ATTRIBUTE2 AS ITEM_ID, ''Production'' AS PSI_TYPE , ''Tact Time'' AS MEASURE
             , ATTRIBUTE14 AS YYYYMM, LOAD_PER AS TACT_TIME --1미터당 초
        FROM   '+@DBOPTPrefix+N'SCP_OPT_ENG_ROUTING_RESOURCE ERR WITH(nolock)
        JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = ERR.PLAN_ID
        --JOIN   #TMP_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = ERR.PLAN_ID
 
             JOIN W_ITEM AS WI
             ON  ERR.ATTRIBUTE2                  = WI.ITEM_ID
 
             JOIN W_END_D WED ON ERR.ATTRIBUTE14 BETWEEN FORMAT(GETDATE(),''yyyyMM'')  AND SUBSTRING(WED.horizon_end_date,1,6)
 
        WHERE  1=1  '
        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND LEFT(ERR.ATTRIBUTE1,4) = '''+@P_PLANT_ID+''' ' ; END;
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
             , YYYYMM, TACT_TIME --1미터당 초
        FROM   W_TACT_TIME_RAW WTR
        JOIN   W_CALENDAR AS WC ON WC.BASIS_YYYYMM = WTR.YYYYMM
    )
    --SELECT * FROM W_TACT_TIME;
    
    ------------------------
    ------------------------

    , W_ELEC_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, PLANT_ID, ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Elec Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD 
        FROM (
            SELECT PLANT_ID, OYE.ITEM_ID, YYYYMM, AVG(CONVERT(NUMERIC(20,10), ELEC_POST)) AS YIELD 
            FROM   '+@DBPrefix+N'SCP_OPMZ_YLD_ELEC OYE WITH(NOLOCK)
            
                    JOIN W_ITEM AS WI
                    ON  OYE.ITEM_ID                  = WI.ITEM_ID
                    JOIN W_END_D WED ON OYE.YYYYMM BETWEEN FORMAT(GETDATE(),''yyyyMM'')  AND SUBSTRING(WED.horizon_end_date,1,6)
            
            WHERE  1=1  '
            IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
            SET @SQL += N'
            AND OYE.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
            SET @SQL += N'
            AND    VALID_YN=''Y''
            GROUP BY PLANT_ID,OYE.ITEM_ID, YYYYMM
        ) EY            
                JOIN W_CALENDAR AS WC
                ON  EY.YYYYMM                  = WC.BASIS_YYYYMM
    )
    --SELECT * FROM W_ELEC_YIELD;
    , W_ASSY_YIELD AS (
        SELECT PLANT_ID+''-E'' AS SCM_SITE_ID, PLANT_ID, ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Assy Yield'' AS MEASURE
             , WC.BASIS_YYYYMMDD AS YYYYMMDD, CONVERT(NUMERIC(20,10),YIELD) AS YIELD 
        FROM (
            SELECT PLANT_ID,A.ITEM_ID, A.YYYYMM, AVG(CONVERT(NUMERIC(20,10), A.ASSY)) AS YIELD 
            FROM   '+@DBPrefix+N'SCP_OPMZ_YLD_ELEC A WITH(NOLOCK)
            
                    JOIN W_ITEM AS WI
                    ON  A.ITEM_ID                  = WI.ITEM_ID
                    JOIN W_END_D WED ON A.YYYYMM BETWEEN FORMAT(GETDATE(),''yyyyMM'')  AND SUBSTRING(WED.horizon_end_date,1,6)
            
              LEFT OUTER JOIN '+@DBPrefix+N'SCP_MST_BOM_ELEC  B WITH(NOLOCK)
                       ON   A.ITEM_ID = B.CHILD_ITEM_ID
                       AND  B.SCP_YN = ''Y''
            WHERE 1=1  '
            IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
            SET @SQL += N'
            AND A.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
            SET @SQL += N'
            AND VALID_YN=''Y''
            and A.ASSY <>''''
            GROUP BY PLANT_ID,A.ITEM_ID, YYYYMM
        ) AY            
                JOIN W_CALENDAR AS WC
                ON  AY.YYYYMM                  = WC.BASIS_YYYYMM
    )
    --SELECT * FROM W_ASSY_YIELD;
    , W_HOLD_REL_SITE_ITEM AS (
        SELECT DISTINCT a.scm_site_id AS aplant
                       ,p.plant_id
                        --,SEGMENT3 AS ITEM_ID
                       ,child_item_id
        FROM   dbo.scp_opt_eng_model_list_n_sn a WITH(nolock)
        INNER  JOIN scm_plant_m_sn p WITH(nolock)
        ON     (p.plant_id + ''-A'' = a.scm_site_id OR
               p.plant_id + ''-E'' = a.scm_site_id)
        INNER  JOIN scm_mst_model_final_item_bom_v bom WITH(nolock)
        ON     bom.operation_group_id = ''E''
        AND    (bom.model_id = a.item_id OR bom.child_item_id = a.item_id)
        AND    (bom.model_id LIKE ''AA%'' OR bom.model_id LIKE ''EA%'' OR
              bom.model_id LIKE ''MA%'')

        JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID

        JOIN W_ITEM AS WI
        ON   bom.child_item_id                  = WI.ITEM_ID
        --AND    bom.child_item_id IN
        --       (SELECT token
        --         FROM   string_split(@item_list, '',''))


        WHERE  1 = 1
        --AND    a.plan_id = @plan_id
    )
    --SELECT * FROM W_HOLD_REL_SITE_ITEM;
    , W_HOLD_REL_RAW AS (
        SELECT WSI.aplant AS SCM_SITE_ID, WSI.PLANT_ID, attribute2 AS ITEM_ID, ''Inventory'' AS PSI_TYPE , ''Hold Release'' AS MEASURE
             , effective_date AS YYYYMMDD, SUM(quantity) AS Hold_Release_QTY 
        FROM   opteng_scp.dbo.scp_opt_eng_incoming_stock a WITH(nolock)
        INNER  JOIN W_HOLD_REL_SITE_ITEM AS WSI
        ON     WSI.child_item_id = a.attribute2
        AND    WSI.aplant = a.attribute1

        JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID '

        IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
        SET @SQL += N'
        AND WSI.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
        SET @SQL += N'
        WHERE  1 = 1
        --AND    plan_id = @plan_id
        --AND    effective_date >= LEFT(@plan_id, 8) 
        AND    effective_date >= LEFT(WPI.OPT_PLAN_ID, 8) 
        --AND attribute2 IN (SELECT token
        --                   FROM   string_split(@item_list, '','')) 
        AND    TYPE = ''WH_HOLD''
        GROUP  BY WSI.aplant, WSI.PLANT_ID, attribute2
             , effective_date
        --ORDER  BY 1, 2
    )
    --SELECT * FROM W_HOLD_REL_RAW; ';
    SET @SQL += N'
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
                FROM   opteng_scp.dbo.scp_opt_eng_incoming_stock A WITH(nolock)

                JOIN W_ITEM AS WI
                ON   A.attribute2                  = WI.ITEM_ID

                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE ''%E''
                AND    TYPE = ''WH''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''Assy_Site'', attribute1, attribute2, SUM(quantity)
                FROM   opteng_scp.dbo.scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN W_ITEM AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE ''%A''
                AND    attribute1 LIKE LEFT  ('''+@P_PLANT_ID+''', 2) + ''%'' 
                AND    TYPE = ''WH''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''Intransit'', attribute1, attribute2, SUM(quantity)
                FROM   opteng_scp.dbo.scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    attribute1 LIKE LEFT  ('''+@P_PLANT_ID+''', 2) + ''%'' 
                AND    TYPE = ''INT''
                GROUP  BY attribute1, attribute2
                UNION ALL
                SELECT ''HD'', attribute1, attribute2, SUM(quantity)
                FROM   opteng_scp.dbo.scp_opt_eng_incoming_stock A WITH(nolock)
                JOIN W_ITEM AS WI
                ON   A.attribute2                  = WI.ITEM_ID
                JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                WHERE  1=1
                --AND    plan_id = @plan_id
                AND    effective_date = LEFT(WPI.OPT_PLAN_ID, 8) --@effective_date
                AND    TYPE = ''WH_HOLD''
                GROUP  BY attribute1, attribute2) inv  ';
    SET @SQL += N'
        LEFT   OUTER JOIN (SELECT child_item_id
                                ,MAX(convert(FLOAT, usage)) AS accumulated_child_qty
                          FROM   scp_opt_eng_bom_elec_sn n WITH(nolock)
                          --JOIN W_ITEM AS WI
                          --ON   N.child_item_id                  = WI.ITEM_ID
                          JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = N.PLAN_ID 
                          WHERE  1=1
                          --AND    plan_id = @plan_id
                          AND    scp_yn = ''Y''
                          AND    child_item_id IN
                                 (SELECT DISTINCT A.item_id
                                   FROM   dbo.scp_opt_eng_model_list_n_sn A WITH(nolock)
                                   --JOIN W_ITEM AS WI
                                   --ON   A.item_id                  = WI.ITEM_ID
                                   JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                                   WHERE  1=1
                                   --AND    plan_id = @plan_id
                                   AND    (A.item_id LIKE ''APCC%'' OR
                                         A.item_id LIKE ''APCA%''))
                          AND    parent_item_id IN
                                 (SELECT DISTINCT A.item_id a
                                   FROM   dbo.scp_opt_eng_model_list_n_sn A WITH(nolock)
                                   --JOIN W_ITEM AS WI
                                   --ON   A.item_id                  = WI.ITEM_ID
                                   JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = A.PLAN_ID 
                                   WHERE  1=1
                                   --AND    plan_id = @plan_id
                                   AND    (A.item_id LIKE ''EA%'' OR
                                         A.item_id LIKE ''AA%'' OR
                                         A.item_id LIKE ''MA%''))
                          GROUP  BY child_item_id) cv
        ON     inv.item_id = cv.child_item_id
    )  
    --SELECT * FROM W_BOH_RAW; ';
    SET @SQL += N'
    , W_BOH_PIVOT AS (
        
        SELECT /*scm_site_id AS SCM_SITE_ID, LEFT(scm_site_id,4) AS PLANT_ID,*/ ITEM_ID AS ITEM_ID, ''Inventory'' AS PSI_TYPE , ''INVENTORY_TOTAL'' AS MEASURE
             , CONVERT(NUMERIC(20,10),Elec_Site) AS Elec_Site_QTY, CONVERT(NUMERIC(20,10),Assy_Site) AS Assy_Site_QTY , CONVERT(NUMERIC(20,10),Intransit) AS Intransit_QTY , CONVERT(NUMERIC(20,10),HD) AS HD_QTY  
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
    --SELECT * FROM W_BOH_PIVOT; ';
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
        FROM  #TMP_W_DAILY_SUM WDS
        JOIN  W_TACT_TIME WTT 
        --JOIN  #TMP_TACT_TIME WTT 
        ON    WTT.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WTT.LINE = WDS.LINE_ID
        AND   WTT.ITEM_ID = WDS.ITEM_ID
        --날짜는 TACT TIME 기준으로 달력전체가 나와야 한다
        /*AND   WTT.YYYYMMDD = WDS.YYYYMMDD*/
        AND   WDS.MEASURE = ''PROD_PLAN_AMEND''
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
        FROM  #TMP_W_DAILY_SUM WDS
        JOIN  W_ASSY_YIELD WAY 
        ON    WAY.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WAY.ITEM_ID = WDS.ITEM_ID
        --날짜는 ASSY YIELD 기준으로 달력전체가 나와야 한다
        /*AND   WAY.YYYYMMDD = WDS.YYYYMMDD*/
        AND   WDS.MEASURE = ''PROD_PLAN_AMEND''
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
        FROM  #TMP_W_DAILY_SUM WDS
        JOIN  W_ELEC_YIELD WEY 
        ON    WEY.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WEY.ITEM_ID = WDS.ITEM_ID
        --날짜는 ELEC YIELD 기준으로 달력전체가 나와야 한다
        /*AND   WEY.YYYYMMDD = WDS.YYYYMMDD*/
        AND   WDS.MEASURE = ''PROD_PLAN_AMEND''
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
            , WHR.Hold_Release_QTY AS QTY
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_DAILY_SUM WDS
        JOIN  W_HOLD_REL_RAW WHR 
        ON    WHR.SCM_SITE_ID = WDS.SCM_SITE_ID
        AND   WHR.ITEM_ID = WDS.ITEM_ID
        --날짜는 HOLD Release 기준으로 가진 것 전체가 나와야 한다
        /*AND   WHR.YYYYMMDD = WDS.YYYYMMDD*/
        AND   WDS.MEASURE = ''PROD_PLAN_AMEND''
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
            , PARTIAL_WEEK_NAME
            , BASIS_START_DATE
            , BASIS_END_DATE
            --, YYYYMMDD
            , QTY=CASE WHEN ( PSI_TYPE IN ( ''Inventory'',''Inventory'' ) OR MEASURE IN (''Tact Time'') ) THEN MAX(QTY) ELSE SUM(QTY) END
        FROM  W_CALENDAR AS WC
        LEFT JOIN  W_ALL_DSUM WDS ON WDS.YYYYMMDD = WC.BASIS_YYYYMMDD        
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
            , PARTIAL_WEEK_NAME
            , BASIS_START_DATE
            , BASIS_END_DATE
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
        WHERE  MEASURE IS NOT NULL
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
            , '+@INSERT_NULL_SELECT_COLS+'
        --FROM  W_DAILY_SUM WDS
        FROM  #TMP_W_DAILY_SUM WDS
        JOIN  W_BOH_PIVOT WBP
        ON    WBP.ITEM_ID = WDS.ITEM_ID    
        --날짜는 재고가 두줄이 나와서 한줄 처리 한다
        /*AND   WTT.YYYYMMDD = WDS.YYYYMMDD*/
        AND   WDS.MEASURE = ''PROD_PLAN_AMEND''
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
        SELECT TRIM(''Hold Release   '') AS MEAS, TRIM(''Hold Release     '') AS MALIAS, 37 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_DIO  '') AS MEAS, TRIM(''INVENTORY_DIO    '') AS MALIAS, 38 SORT_SEQ
    )
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,COMPANY_ID
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
       ,'''+@P_COMPANY_ID+N'''
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
    LEFT JOIN W_MEAS AS WM ON WM.MEAS = WRW.MEASURE;'+CHAR(12)+CHAR(10);
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

    --SELECT * FROM ##TMP_W_PIV_RST_WEEK_RESULT ORDER BY 1,2,3,4;
    PRINT N'3 AFTER PIVOT :'+CONVERT(NVARCHAR(MAX),SYSDATETIME());

    --#################################################
    --Coating Speed 메저 추가하기
    -- 2025-11-30 김준규 Coating Speed에 PROD_PLAN_AMEND의 FACTORY와 PROD LINE을 동일한 이름 갯수 만큼 추가
    --#################################################

    INSERT INTO SCM_SIM_DYN_COLS
    (
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,COMPANY_ID
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
       ,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT SNAP_YYYYMMDD
          ,REPORT_TITLE
          ,PLANT_ID
          ,COMPANY_ID
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
          ,SORT_SEQ1= 100000+100*ROW_NUMBER() OVER (ORDER BY SDC.SORT_SEQ1)
          ,@v_online_user AS CREATED_BY
          ,@v_online_user AS LAST_UPDATED_BY
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    CROSS JOIN (SELECT 'Coating Speed' AS X) X
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    LEN(C12) > 4
    AND    C14 = 'PROD_PLAN_AMEND'
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);

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
        SELECT TRIM(''PROD_PLAN_AMEND'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_AMEND1 '') AS MALIAS, 10 REQ_REC, 04 SORT_SEQ UNION ALL
        SELECT TRIM(''Coating Speed  '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Coating Speed1   '') AS MALIAS, 10 REQ_REC, 05 SORT_SEQ UNION ALL
        SELECT TRIM(''Tact Time      '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Tact Time1       '') AS MALIAS, 10 REQ_REC, 06 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_TOTAL'') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_TOTAL  '') AS MALIAS, 01 REQ_REC, 07 SORT_SEQ UNION ALL
        SELECT TRIM(''Assy Yield     '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Assy Yield       '') AS MALIAS, 01 REQ_REC, 08 SORT_SEQ UNION ALL
        SELECT TRIM(''Elec Yield     '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Elec Yield       '') AS MALIAS, 01 REQ_REC, 09 SORT_SEQ UNION ALL
        SELECT TRIM(''Hold Release   '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Hold Release     '') AS MALIAS, 01 REQ_REC, 10 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_DIO  '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_DIO    '') AS MALIAS, 01 REQ_REC, 11 SORT_SEQ
    )  ';
    SET @SQL += N'
    , W_CURRENTCOUNT AS (
        -- 각 그룹별 현재 레코드 수 계산
        SELECT C8 /* ITEM_ID              */
              ,C14 /* MEASURE              */
              ,COUNT(*) AS ExistingCount
              ,MAX(SDC.C1 ) AS C1   /* DIVISION_ID          */
              ,MAX(SDC.C2 ) AS C2   /* PLAN_START_YYYYMMDD  */
              ,MAX(SDC.C5 ) AS C5   /* SCM_SITE_ID          */
              ,MAX(SDC.C6 ) AS C6   /* SITE_DESCRIPTION     */
              ,MAX(SDC.C7 ) AS C7   /* NICK_NAME            */
              ,MAX(SDC.C9 ) AS C9   /* ELECTRODE_TYPE       */
              ,MAX(SDC.C10) AS C10  /* CELL_CF              */
        FROM   SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
        WHERE  SDC.SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    SDC.REPORT_TITLE= '''+@V_REPORT_TITLE_PSI_DETAIL+N'''--@P_REPORT_TITLE
        AND    ISNULL(SDC.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(SDC.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    SDC.SORT_SEQ1 > 100000
        GROUP BY C8 /* ITEM_ID              */, C14 /* MEASURE              */
    )   ';
    --SELECT * FROM W_CURRENTCOUNT;
    SET @SQL += N'
    , W_ALL_NEED AS (
        -- 모든 ITEM과 CATEGORY의 조합 생성
        SELECT DISTINCT
            WT.C8,
            WM.MEAS,
            WM.REQ_REC,
            WM.SORT_SEQ
        FROM W_CURRENTCOUNT WT
        CROSS JOIN W_MEAS WM
    )
    --SELECT *fROM W_ALL_NEED;
    , W_NUMBERS AS (
        SELECT 1 AS Num UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
        UNION ALL SELECT 6  UNION ALL SELECT 7  UNION ALL SELECT 8  UNION ALL SELECT 9  UNION ALL SELECT 10
        --UNION ALL SELECT 11 UNION ALL SELECT 12 UNION ALL SELECT 13 UNION ALL SELECT 14 UNION ALL SELECT 15
        --UNION ALL SELECT 16 UNION ALL SELECT 17 UNION ALL SELECT 18 UNION ALL SELECT 19 UNION ALL SELECT 20
        --UNION ALL SELECT 21 UNION ALL SELECT 22 UNION ALL SELECT 23 UNION ALL SELECT 24 UNION ALL SELECT 25
        --UNION ALL SELECT 26 UNION ALL SELECT 27 UNION ALL SELECT 28 UNION ALL SELECT 29 UNION ALL SELECT 30
    )
    , W_NEED_ITEM_MEAS AS (
        -- 없거나 부족한 것 찾기
        SELECT 
            arc.C8,
            arc.MEAS,
            arc.REQ_REC,
            arc.SORT_SEQ,
            ISNULL(cd.ExistingCount, 0) AS ExistingCount,
            arc.REQ_REC - ISNULL(cd.ExistingCount, 0) AS NeedToAdd--,
            ,CD.C1,CD.C2,CD.C5,CD.C6,CD.C7,CD.C9,CD.C10,CD.C14
        FROM W_ALL_NEED arc
        LEFT JOIN W_CURRENTCOUNT cd ON arc.C8 = cd.C8 AND arc.MEAS = cd.C14
        WHERE arc.REQ_REC > ISNULL(cd.ExistingCount, 0)
    )
    --SELECT * FROM W_NEED_ITEM_MEAS;
   
    , W_ITEM_DEFAULT AS (
        -- 각 그룹별 현재 레코드 수 계산
        SELECT C8 /* ITEM_ID              */
              ,MAX(WR.C1 ) AS C1   /* DIVISION_ID          */
              ,MAX(WR.C2 ) AS C2   /* PLAN_START_YYYYMMDD  */
              ,MAX(WR.C5 ) AS C5   /* SCM_SITE_ID          */
              ,MAX(WR.C6 ) AS C6   /* SITE_DESCRIPTION     */
              ,MAX(WR.C7 ) AS C7   /* NICK_NAME            */
              ,MAX(WR.C9 ) AS C9   /* ELECTRODE_TYPE       */
              ,MAX(WR.C10) AS C10  /* CELL_CF              */
        FROM   W_CURRENTCOUNT WR
        GROUP BY C8
    )   
    --SELECT * FROM W_ITEM_DEFAULT; '
    SET @SQL += N'
    , W_ADD_ITEM_MEAS AS (
    SELECT X.C8
          ,X.MEAS AS C14
          ,CASE WHEN X.C1  IS NULL THEN WID.C1  ELSE X.C1  END AS C1
          ,CASE WHEN X.C2  IS NULL THEN WID.C2  ELSE X.C2  END AS C2
          ,CASE WHEN X.C5  IS NULL THEN WID.C5  ELSE X.C5  END AS C5
          ,CASE WHEN X.C6  IS NULL THEN WID.C6  ELSE X.C6  END AS C6
          ,CASE WHEN X.C7  IS NULL THEN WID.C7  ELSE X.C7  END AS C7
          ,CASE WHEN X.C9  IS NULL THEN WID.C9  ELSE X.C9  END AS C9
          ,CASE WHEN X.C10 IS NULL THEN WID.C10 ELSE X.C10 END AS C10
    FROM  (
        SELECT 
            arc.C8,
            arc.MEAS
            ,ARC.C1,ARC.C2,ARC.C5,ARC.C6,ARC.C7,ARC.C9,ARC.C10,ARC.C14
        FROM W_NEED_ITEM_MEAS arc
        CROSS JOIN W_NUMBERS n
        WHERE n.Num <= ARC.NeedToAdd
    ) X
    LEFT JOIN W_ITEM_DEFAULT WID ON WID.C8 = X.C8
    )
    --SELECT * FROM W_ADD_ITEM_MEAS;
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,COMPANY_ID
       ,DIVISION_ID
       ,C1,C2,C5,C6,C7,C8,C9,C10,C14
       --,SORT_SEQ1
       ,CREATED_BY
       ,LAST_UPDATED_BY
    )
    SELECT '''+@P_SNAP_YYYYMMDD+N'''
          ,'''+@V_REPORT_TITLE_PSI_DETAIL+N'''
          ,'''+@P_PLANT_ID+'''
          ,'''+@P_COMPANY_ID+'''
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
    FROM W_ADD_ITEM_MEAS T ; '+CHAR(12)+CHAR(10);
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

    PRINT N'4 AFTER ADD 10 LINE:'+CONVERT(NVARCHAR(MAX),SYSDATETIME());


    --SELECT 'FIRST C6,C7,C8,C9,C10,C14,C12',* 
    --FROM   SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
    --WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    --AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    --AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    --AND    ISNULL(SDC.COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
    --AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    --ORDER BY C6,C7,C8,C9,C10,C14,C12
    
       -- ic.DIVISION_ID         /* C1  */
       --,ic.PLAN_START_YYYYMMDD /* C2  */
       --,ic.SCM_SITE_ID         /* C5  */
       --,ic.SITE_DESCRIPTION    /* C6  */
       --,ic.NICK_NAME           /* C7  */
       --,ic.ITEM_ID             /* C8  */ C14 --> DEV1 MEAS1,2,3 DEV2 : SALSE,INV,PROD, DEV3: MEAS1,2,3 대응 번호
       --,ic.ELECTRODE_TYPE      /* C9  */
       --,ic.CELL_CF             /* C10 */ --C12 PROD_LINE,C14 MEASEURE
       --     ,RNum = ROW_NUMBER() OVER (ORDER BY ic.SITE_DESCRIPTION,ic.NICK_NAME,ic.ITEM_ID,ic.ELECTRODE_TYPE,ic.CELL_CF,MM.SORT_SEQ)

    --############################
    --순서 재정렬
    --############################
    --임시 테이블 생성
    DROP TABLE IF EXISTS #TMP_SCM_SIM_DYN_COLS;
    SELECT * INTO #TMP_SCM_SIM_DYN_COLS FROM SCM_SIM_DYN_COLS WITH(NOLOCK) WHERE 1=0;
    CREATE CLUSTERED INDEX IX01_TMP_SCM_SIM_DYN_COLS ON #TMP_SCM_SIM_DYN_COLS(SNAP_YYYYMMDD, REPORT_TITLE, PLANT_ID, COMPANY_ID, DIVISION_ID);

    INSERT INTO #TMP_SCM_SIM_DYN_COLS
    SELECT *
    FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);
    
    SET @DUMMY = CONVERT(NVARCHAR(MAX),@@rowcount);
    PRINT N' INSERT ROWCOUNT:'+ISNULL(@DUMMY,'NULL');

    DELETE SDC
    FROM   SCM_SIM_DYN_COLS SDC
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL);
    
    SET @DUMMY = CONVERT(NVARCHAR(MAX),@@rowcount);
    PRINT N' DELETE ROWCOUNT:'+ISNULL(@DUMMY,'NULL');

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
                                  WHEN @COLUMN_NAME = '[LAST_UPDATED_BY]' THEN ''''+@v_online_user+''' AS [LAST_UPDATED_BY]' ELSE @COLUMN_NAME END) +CHAR(12)+CHAR(10);
    
    	FETCH NEXT FROM cur INTO @COLUMN_NAME
    
    END
    
    CLOSE cur
    DEALLOCATE cur

        --SET @SQL_SEL +=N' FROM   W_RAW AS WR ORDER BY RNUM;';

    --SET @DUMMY = @SQL_SEL;
    --PRINT RIGHT(@DUMMY, 4000);
    --SET @DUMMY = RIGHT(@SQL_SEL, 4000);
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

    SET @SQL = N'
    --2 SORT SEQ 재정리
    ;WITH W_MEAS AS (
        SELECT TRIM(''PKG_PLAN       '') AS MEAS, TRIM(''Sale      '') AS MType, TRIM(''PKG_PLAN         '') AS MALIAS, 01 REQ_REC, 01 SORT_SEQ UNION ALL
        SELECT TRIM(''SHIP_PLAN_TOTAL'') AS MEAS, TRIM(''Sale      '') AS MType, TRIM(''SHIP_PLAN_TOTAL  '') AS MALIAS, 01 REQ_REC, 02 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_TOTAL'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_TOTAL  '') AS MALIAS, 01 REQ_REC, 03 SORT_SEQ UNION ALL
        SELECT TRIM(''PROD_PLAN_AMEND'') AS MEAS, TRIM(''Production'') AS MType, TRIM(''PROD_PLAN_AMEND1 '') AS MALIAS, 10 REQ_REC, 04 SORT_SEQ UNION ALL
        SELECT TRIM(''Coating Speed  '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Coating Speed1   '') AS MALIAS, 10 REQ_REC, 05 SORT_SEQ UNION ALL
        SELECT TRIM(''Tact Time      '') AS MEAS, TRIM(''Production'') AS MType, TRIM(''Tact Time1       '') AS MALIAS, 10 REQ_REC, 06 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_TOTAL'') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_TOTAL  '') AS MALIAS, 01 REQ_REC, 07 SORT_SEQ UNION ALL
        SELECT TRIM(''Assy Yield     '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Assy Yield       '') AS MALIAS, 01 REQ_REC, 08 SORT_SEQ UNION ALL
        SELECT TRIM(''Elec Yield     '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Elec Yield       '') AS MALIAS, 01 REQ_REC, 09 SORT_SEQ UNION ALL
        SELECT TRIM(''Hold Release   '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''Hold Release     '') AS MALIAS, 01 REQ_REC, 10 SORT_SEQ UNION ALL
        SELECT TRIM(''INVENTORY_DIO  '') AS MEAS, TRIM(''Inventory '') AS MType, TRIM(''INVENTORY_DIO    '') AS MALIAS, 01 REQ_REC, 11 SORT_SEQ
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
        AND    ISNULL(SDC.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(SDC.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    (SDC.SORT_SEQ1 > 100000 OR SDC.SORT_SEQ1 IS NULL)
    )';
    SET @SQL += N''+@SQL_SEL+'
    FROM   W_RAW AS WR
    ORDER BY RNUM;'+CHAR(12)+CHAR(10)
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --SELECT * 
    --FROM   W_RAW AS WR
    --ORDER BY RNUM;

    ----  프린트 및 실행
    --SET @DUMMY = @sql;
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
    INSERT INTO SCM_SIM_DYN_COLS
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;

    PRINT N'5 AFTER SORT_SEQ 재정렬:'+CONVERT(NVARCHAR(MAX),@n_log_count)+','+CONVERT(NVARCHAR(MAX),SYSDATETIME());

    --##############################################################
    --UNIT을 CELL로 처리
    --##############################################################
    UPDATE SDC
    SET    C20 = 'CELL'
    FROM   SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
    WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_PSI_DETAIL
    AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    AND    ISNULL(SDC.COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
    AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    AND    SDC.SORT_SEQ1 > 100000;
    
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
       ,COMPANY_ID
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
       ,'''+@P_COMPANY_ID+'''
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
       ,COMPANY_ID
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
       ,'''+@P_COMPANY_ID+'''
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
        SELECT nr AS rnum, token AS ITEM_ID
        FROM   STRING_SPLIT ('''+@P_ITEM_IDS+N''',N'',N'')
    )
    --SELECT * FROM W_ITEM;
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
        AND    CM.BASIS_START_DATE>='''+@QUERY_START_YYYYMMDD+''' --CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)
        AND    CM.BASIS_YYYYMMDD <= WED.HORIZON_END_DATE-- CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_CALENDAR;
    , W_LINE AS (
         SELECT DISTINCT LINE_ID, LINE_NAME
         from   '+@DBPrefix+N'SCM_MST_LINE_V
    )
    , W_OPT_PLAN_ID AS (
        SELECT  max(plan_id) AS OPT_PLAN_ID   
        FROM    '+@DBOPTPrefix+N'SCP_OPT_ENG_PLAN_MASTER  M WITH(NOLOCK)
        INNER  JOIN ( SELECT DISTINCT CONCAT(GM.PLANT_ID, ''-E'') AS SCM_SITE_ID, GR_NM AS PLAN_GROUP
                        FROM (
                            SELECT GM.DIVISION_ID, GL.OPMZ_PLAN_GR_ID AS GR_ID, GM.OPMZ_PLAN_GR_NAME GR_NM, GL.PLANT_ID, GL.LINE_ID 
                              FROM '+@DBPrefix+N'SCP_OPMZ_PLAN_GR_M GM  WITH(NOLOCK)
                                 , '+@DBPrefix+N'SCP_OPMZ_PLAN_GR_LINE_M GL WITH(NOLOCK)
                                 , '+@DBPrefix+N'SCM_MST_SITE SMS WITH(NOLOCK)
                            WHERE GM.OPMZ_PLAN_GR_ID = GL.OPMZ_PLAN_GR_ID
                              AND GM.VALID_YN = ''Y''
                              AND GL.VALID_YN = ''Y''
                              AND GL.ITEM_ID = ''-''
                              AND GM.DIVISION_ID = ''EE'' '
                              IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                              SET @SQL += N'
                              AND GL.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
                              SET @SQL += N'
                              AND CONCAT(GL.PLANT_ID, ''-E'') = SMS.SCM_SITE_ID --@PLANT
                            ) GM
                            ,(
                            SELECT DISTINCT PLANT_ID, LINE_ID, LA.ITEM_ID
                              FROM '+@DBFPPrefix+N'SCM_ITEM_LINE_ASSIGN_M LA WITH(NOLOCK)
                                   JOIN W_ITEM AS WI
                                   ON  LA.ITEM_ID                  = WI.ITEM_ID
 
                             WHERE 1=1
                               AND ACTIVE_FLAG = ''Y''  '
                              IF ISNULL(@P_PLANT_ID,'') <> '' BEGIN
                              SET @SQL += N'
                              AND LA.PLANT_ID = '''+@P_PLANT_ID+''' ' ; END;
                              SET @SQL += N'
                               /* 미래구간에 Assign 된 Item 만 조회 */
                               --향후에 입력 일자등을 고려하여 PARAMETER로 변경 필요
                               AND MONTH >= SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE()), GETDATE()), 112), 1, 6)
                                          --   AND SUBSTRING(CONVERT(VARCHAR(8), DATEADD(DAY,1-DATEPART(WEEKDAY, GETDATE())+363, GETDATE()), 112), 1, 6)
                               AND OPERATION_ID = ''E2000'' 
                            ) LM
                        WHERE GM.LINE_ID = LM.LINE_ID
                         AND  LM.ITEM_ID NOT IN (''APCAN2735A'',''APCCA2842A'')
                         --AND  LM.ITEM_ID IN (SELECT TOKEN 
                         --                    FROM STRING_SPLIT(@ITEM_LIST, '','')
                         --                    WHERE TOKEN NOT IN (''APCAN2735A'',''APCCA2842A'')
                         --                    )
        
                            ) B
        ON 1=1
        and M.attribute2=b.plan_group
        WHERE   M.ATTRIBUTE1 = ''EE''

        AND  m.plan_id <> ''20251120_EE_ESNB_MY001''
        AND  m.plan_id <> ''20251120_EE_ESNB_MY002''
        
        and (m.plan_id not like ''%C'' and m.plan_id not like ''%A'' and m.plan_id  like ''20%'') 
        group by attribute1, attribute2
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
    SET @SQL += N'FROM   [SCM_SIM_DYN_COLS] AS SDC WITH(NOLOCK)'  + CHAR(12) + CHAR(10);
    SET @SQL += N'WHERE  SNAP_YYYYMMDD = '''+ (CASE WHEN ISNULL(@P_SNAP_YYYYMMDD,'')='' THEN CONVERT(NVARCHAR(8),GETDATE(),112) ELSE @P_SNAP_YYYYMMDD END) +''''+ CHAR(12) + CHAR(10) ;
    SET @SQL += N'--''아래 리포트 이름은 RESOURCE가 아닌 PSI DETAIL 임 주의 필요'''+ CHAR(12) + CHAR(10);
    SET @SQL += N'AND    REPORT_TITLE = '''+ @V_REPORT_TITLE_PSI_DETAIL +''''+ CHAR(12) + CHAR(10);
    IF ISNULL(@P_PLANT_ID,'')<>'' BEGIN
    SET @SQL += N'AND    PLANT_ID = '''+ @P_PLANT_ID +''''+ CHAR(12) + CHAR(10); END;
    IF ISNULL(@P_COMPANY_ID,'')<>'' BEGIN
    SET @SQL += N'AND    COMPANY_ID = '''+ @P_COMPANY_ID +''''+ CHAR(12) + CHAR(10); END;
    IF ISNULL(@P_DIVISION_ID,'')<>'' BEGIN
    SET @SQL += N'AND    DIVISION_ID = '''+ @P_DIVISION_ID +''''+ CHAR(12) + CHAR(10); END;
    SET @SQL += N'AND    C14 = ''PROD_PLAN_AMEND'''+ CHAR(12) + CHAR(10);
    SET @SQL += N'AND    LEN(C12)>1'+ CHAR(12) + CHAR(10);
    SET @SQL += N'AND    SORT_SEQ1 > 100'+ CHAR(12) + CHAR(10);
    SET @SQL += N'
    )
    , W_CAPA_RAW AS (
        SELECT  SUBSTRING(C2, ((LEN('''+ @P_PLANT_ID +N''') +4)+ 1),  LEN(C2) - (LEN('''+ @P_PLANT_ID +N''') +4)) AS LINE_ID
              , DATE AS YYYYMMDD, CASE WHEN ISNUMERIC(QTY) = 1 THEN TRY_CONVERT(FLOAT,QTY) END AS QTY, CM.BASIS_START_DATE
        FROM    OPTENG_SCP.DBO.SCP_OPT_ENG_OUT_PLAN_RESULT OPR WITH(NOLOCK)
            JOIN   W_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = OPR.PLAN_ID
            --JOIN   #TMP_OPT_PLAN_ID WPI ON WPI.OPT_PLAN_ID = OPR.PLAN_ID

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
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL with(nolock)
          WHERE LOOKUP_TYPE = N''SCP_OPT_ENG_CONST_SETUP''
          AND SEGMENT3 = '''+ @P_PLANT_ID +N'-E''
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
       ,COMPANY_ID
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
       ,'''+@P_COMPANY_ID+'''
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
           ,'''+@P_COMPANY_ID+N''' AS COMPANY_ID
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
           ,'''+@P_COMPANY_ID+'''
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
    LEFT JOIN W_LINE_ID_CHG_TIME AS WCT ON WCT.LINE = X.LINE_ID AND X.RTYPE = ''CHG_HOUR''; '+CHAR(12)+CHAR(10);
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


    --SELECT 'Resource C19,C20',* 
    --FROM   SCM_SIM_DYN_COLS SDC --WITH(NOLOCK)
    --WHERE  SDC.SNAP_YYYYMMDD = @P_SNAP_YYYYMMDD
    --AND    SDC.REPORT_TITLE= @V_REPORT_TITLE_RESOURCE
    --AND    ISNULL(SDC.PLANT_ID   ,'') = ISNULL(@P_PLANT_ID   ,'')
    --AND    ISNULL(SDC.COMPANY_ID ,'') = ISNULL(@P_COMPANY_ID ,'')
    --AND    ISNULL(SDC.DIVISION_ID,'') = ISNULL(@P_DIVISION_ID,'')
    --ORDER BY C19,C20

    --종료 LOG (START)
    SET @v_log_type = 'END';
    SET @v_log_message = '##### END of procedure #####';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_COMPANY_ID:'+@P_COMPANY_ID+',@P_DIVISION_ID:'+@P_DIVISION_ID;
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
        SELECT
            ERROR_NUMBER() AS ErrorNumber,
            ERROR_SEVERITY() AS ErrorSeverity,
            ERROR_STATE() AS ErrorState,
            ERROR_PROCEDURE() AS ErrorProcedure,
            ERROR_LINE() AS ErrorLine, -- 에러 발생 라인
            ERROR_MESSAGE() AS ErrorMessage;

    SET @X_STATUS = ERROR_NUMBER()
    SET @X_MSG = ERROR_MESSAGE()
    RETURN -1

END CATCH

END

