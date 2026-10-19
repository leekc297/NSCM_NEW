

-- ==========================================================================================
-- Program:      PR_SCM_SIM_OPT_EE
-- Author:       김준규
-- Create date:  2025-11-19
-- Description:  SCM_SIM_DYN_COLS 테이블의 데이터를 조회하여 RETURN한다.
-- How to Execute: EXEC PR_SCM_SIM_OPT_EE_YMH @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_DETAIL',@P_MAX_COLS_NUM='190';
--    EXEC PR_SCM_SIM_OPT_EE_YMH @P_SNAP_YYYYMMDD='20251117',@P_REPORT_TITLE='PSI_RECENT_PLAN',@P_MAX_COLS_NUM='10';
-- ==========================================================================================
-- 2025-11-17       김준규       최초 릴리즈 후보
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_SCM_SIM_OPT_EE_YMH]
    @P_SNAP_YYYYMMDD nvarchar(8) 
   ,@P_REPORT_TITLE  nvarchar(254) = ''
   ,@P_MAX_COLS_NUM  INT = 800
   ,@P_PLANT_ID      nvarchar(30) = ''
   ,@P_COMPANY_ID    nvarchar(30) = ''
   ,@P_DIVISION_ID   nvarchar(30) = ''
   ,@P_ITEM_IDS      nvarchar(MAX) = ''
AS
BEGIN
    SET NOCOUNT ON;

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

    SET @CNT = 0;
    SET @RUN_TIME = 0;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'simulator';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCM_SIM_OPT_EE';
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

    DELETE SCM_SIM_DYN_COLS
    WHERE SNAP_YYYYMMDD  = @P_SNAP_YYYYMMDD
    AND   REPORT_TITLE   = @P_REPORT_TITLE
    AND   PLANT_ID       = @P_PLANT_ID
    AND   COMPANY_ID     = @P_COMPANY_ID
    AND   DIVISION_ID    = @P_DIVISION_ID
    ;
    --------------------------------------------------------
    -- 1. 고정 컬럼 정의 (@ColumnCount 값에 따라)
    --------------------------------------------------------
    DECLARE @SELECT_COLS INT = 800;
    SET @SELECT_COLS = (CASE WHEN (ISNULL(@P_MAX_COLS_NUM,'') = '' OR @P_MAX_COLS_NUM >= 800) THEN 800 ELSE @P_MAX_COLS_NUM END)

    DECLARE @CountOutput INT;
    DECLARE @SELCOL NVARCHAR(MAX) = '';
    DECLARE @INSCOL NVARCHAR(MAX) = '';
    DECLARE @SQL NVARCHAR(MAX) = '';
    DECLARE @i INT = 1;
    
    -- WEEK 표시 구간
    DECLARE @PIVOT_COLS NVARCHAR(MAX) = '';
    DECLARE @PIVOT_COLS_WITH_ALIAS NVARCHAR(MAX) = '';
    DECLARE @INSERT_SELECT_COLS NVARCHAR(MAX) = '';

    DROP TABLE IF EXISTS #TMP_CALENDAR; 
    SELECT --TOP 17 
           CM.BASIS_YYYYMMDD
          ,CM.WEEK_NAME
          ,CM.PARTIAL_WEEK_NAME
          ,CM.PARTIAL_YN
          ,CM.BASIS_START_DATE
          ,CM.BASIS_END_DATE
    INTO   #TMP_CALENDAR
    FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK) 
    WHERE  1=1
    --AND    CM.DAYOFWEEK = 'MON' 
    AND    CM.BASIS_YYYYMMDD >= CONVERT(CHAR(8), GETDATE()-7, 112) --(오늘-7)
    AND    CM.BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일
    
    --SELECT * FROM #TMP_CALENDAR ORDER BY BASIS_START_DATE;

    -- PIVOT IN 절에 사용할 컬럼 리스트 생성
    SELECT @PIVOT_COLS = STRING_AGG(QUOTENAME(CONVERT(VARCHAR(8), BASIS_START_DATE, 23)), ',')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC
    --GROUP BY BASIS_START_DATE
    --ORDER BY BASIS_START_DATE;

    SELECT @PIVOT_COLS_WITH_ALIAS = STRING_AGG(
        QUOTENAME(CONVERT(VARCHAR(8), BASIS_START_DATE, 23)) + 
        ' AS [' + 'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 23) + ']', 
        ', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    SELECT @INSERT_SELECT_COLS = STRING_AGG(
        QUOTENAME('P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 23)) + 
        ' AS [' + 'P'+CONVERT(VARCHAR(8), BASIS_START_DATE, 23) + ']', 
        ', ')
    FROM   ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) TC

    PRINT '@PIVOT_COLS:'+@PIVOT_COLS;
    PRINT '@PIVOT_COLS_WITH_ALIAS:'+@PIVOT_COLS;

    --값이 아닌 것 입력되어야 하는 컬럼 갯수
    DECLARE @INS_COL_NUM INT = 8;
    --
    SELECT @SELECT_COLS = COUNT(*) FROM ( SELECT DISTINCT BASIS_START_DATE FROM #TMP_CALENDAR ) X;
    PRINT '@SELECT_COLS:'+CONVERT(NVARCHAR(MAX),@SELECT_COLS);
    -- C1 부터 C(@SELECT_COLS) 까지 컬럼명 동적 생성
    WHILE @i <= @SELECT_COLS+@INS_COL_NUM
    BEGIN
        IF @i = 1
            SET @INSCOL = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INSCOL = @INSCOL + ', C' + CAST(@i AS NVARCHAR(10));
        
        SET @i = @i + 1;
    END
    PRINT '@INSCOL:'+@INSCOL;

    --######################################################
    DECLARE @INS_LABEL1 NVARCHAR(MAX) = '';
    SET @i =1;
    WHILE @i <= 184
    BEGIN
        IF @i = 1
            SET @INS_LABEL1 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL1 = @INS_LABEL1 + ', C' + CAST(@i AS NVARCHAR(10));
        
        SET @i = @i + 1;
    END
    PRINT '@INS_LABEL1:'+@INS_LABEL1;

    DECLARE @SQL_LEVEL1 NVARCHAR(MAX) = '';
    SET @SQL_LEVEL1 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INS_LABEL1 +'  
       ,SORT_SEQ1
    )
    SELECT '''+@P_SNAP_YYYYMMDD+'''
       ,'''+@P_REPORT_TITLE+'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
       ,'''+@P_DIVISION_ID+'''
       ,''DIVISION'' AS C1,''PLAN START YYYYMMDD'' AS C2,''PLAN TYPE'' AS C3,''SEQ'' AS C4,''SUPPLY SITE'' AS C5,''SUPPLY SITE DESC'' AS C6,''NICK NAME'' AS C7,''ITEM ID'' AS C8,''ELECTRODE TYPE'' AS C9,''CONVERT QTY CELL'' AS C10,''FACTORY'' AS C11,''PROD LINE'' AS C12,''PSI TYPE'' AS C13,''GRO STD DIO'' AS C14,''MIN STD DIO'' AS C15,''MEASURE'' AS C16,''MEASURE LABEL'' AS C17,''MEASURE VALUE1'' AS C18,''VALUE1 LABEL'' AS C19,''MEASURE VALUE2'' AS C20,''VALUE2 LABEL'' AS C21,''CELL ITEM ID'' AS C22,''BOH1'' AS C23,''BOH2'' AS C24,''BOH'' AS C25,''BOH4'' AS C26,''BOH5'' AS C27,''UNIT'' AS C28,''XLS_KEY1'' AS C29,''XLS_KEY_ATTRIBUTE1'' AS C30,''SORT_ORDER_NO'' AS C31,''WQTY01'' AS C32,''WQTY02'' AS C33,''WQTY03'' AS C34,''WQTY04'' AS C35,''WQTY05'' AS C36,''WQTY06'' AS C37,''WQTY07_A'' AS C38,''WQTY07_B'' AS C39,''WQTY08'' AS C40,''WQTY09'' AS C41,''WQTY10'' AS C42,''WQTY11_A'' AS C43,''WQTY11_B'' AS C44,''WQTY12'' AS C45,''WQTY13'' AS C46,''WQTY14'' AS C47,''WQTY15_A'' AS C48,''WQTY15_B'' AS C49,''WQTY16'' AS C50,''WQTY17'' AS C51,''WQTY18'' AS C52,''WQTY19'' AS C53,''WQTY20_A'' AS C54,''WQTY20_B'' AS C55,''WQTY21'' AS C56,''WQTY22'' AS C57,''WQTY23'' AS C58,''WQTY24_A'' AS C59,''WQTY24_B'' AS C60,''WQTY25'' AS C61,''WQTY26'' AS C62,''WQTY27'' AS C63,''WQTY28'' AS C64,''WQTY29'' AS C65,''WQTY30'' AS C66,''WQTY31'' AS C67,''WQTY32'' AS C68,''WQTY33_A'' AS C69,''WQTY33_B'' AS C70,''WQTY34'' AS C71,''WQTY35'' AS C72,''WQTY36'' AS C73,''WQTY37_A'' AS C74,''WQTY37_B'' AS C75,''WQTY38'' AS C76,''WQTY39'' AS C77,''WQTY40'' AS C78,''WQTY41'' AS C79,''WQTY42_A'' AS C80,''WQTY42_B'' AS C81,''WQTY43'' AS C82,''WQTY44'' AS C83,''WQTY45'' AS C84,''WQTY46_A'' AS C85,''WQTY46_B'' AS C86,''WQTY47'' AS C87,''WQTY48'' AS C88,''WQTY49'' AS C89,''WQTY50_A'' AS C90,''WQTY50_B'' AS C91,''WQTY51'' AS C92,''WQTY52'' AS C93,''WQTY53'' AS C94,''WQTY54'' AS C95,''WQTY55_A'' AS C96,''WQTY55_B'' AS C97,''WQTY56'' AS C98,''WQTY57'' AS C99,''WQTY58'' AS C100
       ,''WQTY59_A'' AS C101,''WQTY59_B'' AS C102,''WQTY60'' AS C103,''WQTY61'' AS C104,''WQTY62'' AS C105,''WQTY63'' AS C106,''WQTY64'' AS C107,''WQTY65'' AS C108,''WQTY66'' AS C109,''WQTY67'' AS C110,''WQTY68'' AS C111,''WQTY69'' AS C112,''WQTY70'' AS C113,''WQTY71'' AS C114,''WQTY72_A'' AS C115,''WQTY72_B'' AS C116,''WQTY73'' AS C117,''WQTY74'' AS C118,''WQTY75'' AS C119,''WQTY76_A'' AS C120,''WQTY76_B'' AS C121,''WQTY77'' AS C122,''WQTY78'' AS C123,''WQTY79'' AS C124,''WQTY80'' AS C125,''WQTY81_A'' AS C126,''WQTY81_B'' AS C127,''WQTY82'' AS C128,''WQTY83'' AS C129,''WQTY84'' AS C130,''WQTY85_A'' AS C131,''WQTY85_B'' AS C132,''WQTY86'' AS C133,''WQTY87'' AS C134,''WQTY88'' AS C135,''WQTY89_A'' AS C136,''WQTY89_B'' AS C137,''WQTY90'' AS C138,''WQTY91'' AS C139,''WQTY92'' AS C140,''WQTY93'' AS C141,''WQTY94_A'' AS C142,''WQTY94_B'' AS C143,''WQTY95'' AS C144,''WQTY96'' AS C145,''WQTY97'' AS C146,''WQTY98_A'' AS C147,''WQTY98_B'' AS C148,''WQTY99'' AS C149,''WQTY100'' AS C150,''WQTY101'' AS C151,''WQTY102'' AS C152,''WQTY103'' AS C153,''WQTY104'' AS C154,''WQTY07'' AS C155,''WQTY11'' AS C156,''WQTY15'' AS C157,''WQTY20'' AS C158,''WQTY24'' AS C159,''WQTY33'' AS C160,''WQTY37'' AS C161,''WQTY42'' AS C162,''WQTY46'' AS C163,''WQTY50'' AS C164,''WQTY55'' AS C165,''WQTY59'' AS C166,''WQTY72'' AS C167,''WQTY76'' AS C168,''WQTY81'' AS C169,''WQTY85'' AS C170,''WQTY89'' AS C171,''WQTY94'' AS C172,''WQTY98'' AS C173,''CREATE_BY'' AS C174,''CREATION_DATE'' AS C175,''LAST_UPDATED_BY'' AS C176,''LAST_UPDATE_DATE'' AS C177,''ATTRIBUTE1'' AS C178,''ATTRIBUTE3'' AS C179,''ATTRIBUTE8'' AS C180,''ATTRIBUTE9'' AS C181,''CELL_TYPE_GROUP_CODE'' AS C182,''TO_SITE_ID'' AS C183,''TO_SITE_DESCRIPTION'' AS C184
       , 10 AS SORT_SEQ1';

    --#########################################
    DECLARE @INS_LABEL2 NVARCHAR(MAX) = '';
    --C32부터 184개 넣어야 한다.
    SET @i =32;
    WHILE @i <= (184+32)
    BEGIN
        IF @i = 32
            SET @INS_LABEL2 = 'C' + CAST(@i AS NVARCHAR(10));
        ELSE
            SET @INS_LABEL2 = @INS_LABEL2 + ', C' + CAST(@i AS NVARCHAR(10));
        
        SET @i = @i + 1;
    END
    PRINT '@INS_LABEL2:'+@INS_LABEL2;


    DECLARE @SQL_LEVEL2 NVARCHAR(MAX) = '';
    SET @SQL_LEVEL2 = N'
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INS_LABEL2 +'  
       ,SORT_SEQ1
    )
    SELECT '''+@P_SNAP_YYYYMMDD+'''
       ,'''+@P_REPORT_TITLE+'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
       ,'''+@P_DIVISION_ID+'''
       ,''DIVISION'' AS C1,''PLAN START YYYYMMDD'' AS C2,''PLAN TYPE'' AS C3,''SEQ'' AS C4,''SUPPLY SITE'' AS C5,''SUPPLY SITE DESC'' AS C6,''NICK NAME'' AS C7,''ITEM ID'' AS C8,''ELECTRODE TYPE'' AS C9,''CONVERT QTY CELL'' AS C10,''FACTORY'' AS C11,''PROD LINE'' AS C12,''PSI TYPE'' AS C13,''GRO STD DIO'' AS C14,''MIN STD DIO'' AS C15,''MEASURE'' AS C16,''MEASURE LABEL'' AS C17,''MEASURE VALUE1'' AS C18,''VALUE1 LABEL'' AS C19,''MEASURE VALUE2'' AS C20,''VALUE2 LABEL'' AS C21,''CELL ITEM ID'' AS C22,''BOH1'' AS C23,''BOH2'' AS C24,''BOH'' AS C25,''BOH4'' AS C26,''BOH5'' AS C27,''UNIT'' AS C28,''XLS_KEY1'' AS C29,''XLS_KEY_ATTRIBUTE1'' AS C30,''SORT_ORDER_NO'' AS C31,''WQTY01'' AS C32,''WQTY02'' AS C33,''WQTY03'' AS C34,''WQTY04'' AS C35,''WQTY05'' AS C36,''WQTY06'' AS C37,''WQTY07_A'' AS C38,''WQTY07_B'' AS C39,''WQTY08'' AS C40,''WQTY09'' AS C41,''WQTY10'' AS C42,''WQTY11_A'' AS C43,''WQTY11_B'' AS C44,''WQTY12'' AS C45,''WQTY13'' AS C46,''WQTY14'' AS C47,''WQTY15_A'' AS C48,''WQTY15_B'' AS C49,''WQTY16'' AS C50,''WQTY17'' AS C51,''WQTY18'' AS C52,''WQTY19'' AS C53,''WQTY20_A'' AS C54,''WQTY20_B'' AS C55,''WQTY21'' AS C56,''WQTY22'' AS C57,''WQTY23'' AS C58,''WQTY24_A'' AS C59,''WQTY24_B'' AS C60,''WQTY25'' AS C61,''WQTY26'' AS C62,''WQTY27'' AS C63,''WQTY28'' AS C64,''WQTY29'' AS C65,''WQTY30'' AS C66,''WQTY31'' AS C67,''WQTY32'' AS C68,''WQTY33_A'' AS C69,''WQTY33_B'' AS C70,''WQTY34'' AS C71,''WQTY35'' AS C72,''WQTY36'' AS C73,''WQTY37_A'' AS C74,''WQTY37_B'' AS C75,''WQTY38'' AS C76,''WQTY39'' AS C77,''WQTY40'' AS C78,''WQTY41'' AS C79,''WQTY42_A'' AS C80,''WQTY42_B'' AS C81,''WQTY43'' AS C82,''WQTY44'' AS C83,''WQTY45'' AS C84,''WQTY46_A'' AS C85,''WQTY46_B'' AS C86,''WQTY47'' AS C87,''WQTY48'' AS C88,''WQTY49'' AS C89,''WQTY50_A'' AS C90,''WQTY50_B'' AS C91,''WQTY51'' AS C92,''WQTY52'' AS C93,''WQTY53'' AS C94,''WQTY54'' AS C95,''WQTY55_A'' AS C96,''WQTY55_B'' AS C97,''WQTY56'' AS C98,''WQTY57'' AS C99,''WQTY58'' AS C100
       ,''WQTY59_A'' AS C101,''WQTY59_B'' AS C102,''WQTY60'' AS C103,''WQTY61'' AS C104,''WQTY62'' AS C105,''WQTY63'' AS C106,''WQTY64'' AS C107,''WQTY65'' AS C108,''WQTY66'' AS C109,''WQTY67'' AS C110,''WQTY68'' AS C111,''WQTY69'' AS C112,''WQTY70'' AS C113,''WQTY71'' AS C114,''WQTY72_A'' AS C115,''WQTY72_B'' AS C116,''WQTY73'' AS C117,''WQTY74'' AS C118,''WQTY75'' AS C119,''WQTY76_A'' AS C120,''WQTY76_B'' AS C121,''WQTY77'' AS C122,''WQTY78'' AS C123,''WQTY79'' AS C124,''WQTY80'' AS C125,''WQTY81_A'' AS C126,''WQTY81_B'' AS C127,''WQTY82'' AS C128,''WQTY83'' AS C129,''WQTY84'' AS C130,''WQTY85_A'' AS C131,''WQTY85_B'' AS C132,''WQTY86'' AS C133,''WQTY87'' AS C134,''WQTY88'' AS C135,''WQTY89_A'' AS C136,''WQTY89_B'' AS C137,''WQTY90'' AS C138,''WQTY91'' AS C139,''WQTY92'' AS C140,''WQTY93'' AS C141,''WQTY94_A'' AS C142,''WQTY94_B'' AS C143,''WQTY95'' AS C144,''WQTY96'' AS C145,''WQTY97'' AS C146,''WQTY98_A'' AS C147,''WQTY98_B'' AS C148,''WQTY99'' AS C149,''WQTY100'' AS C150,''WQTY101'' AS C151,''WQTY102'' AS C152,''WQTY103'' AS C153,''WQTY104'' AS C154,''WQTY07'' AS C155,''WQTY11'' AS C156,''WQTY15'' AS C157,''WQTY20'' AS C158,''WQTY24'' AS C159,''WQTY33'' AS C160,''WQTY37'' AS C161,''WQTY42'' AS C162,''WQTY46'' AS C163,''WQTY50'' AS C164,''WQTY55'' AS C165,''WQTY59'' AS C166,''WQTY72'' AS C167,''WQTY76'' AS C168,''WQTY81'' AS C169,''WQTY85'' AS C170,''WQTY89'' AS C171,''WQTY94'' AS C172,''WQTY98'' AS C173,''CREATE_BY'' AS C174,''CREATION_DATE'' AS C175,''LAST_UPDATED_BY'' AS C176,''LAST_UPDATE_DATE'' AS C177,''ATTRIBUTE1'' AS C178,''ATTRIBUTE3'' AS C179,''ATTRIBUTE8'' AS C180,''ATTRIBUTE9'' AS C181,''CELL_TYPE_GROUP_CODE'' AS C182,''TO_SITE_ID'' AS C183,''TO_SITE_DESCRIPTION'' AS C184
       , 10 AS SORT_SEQ1';

    --PRINT @sql;
    --  프린트 및 실행
    SET @DUMMY = @SQL_LEVEL1;
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
    EXEC sp_executesql @SQL_LEVEL1;

    DROP TABLE IF EXISTS ##TMP_W_PIV_RST_WEEK_RESULT; 

    SET @SQL = N'
    ;WITH W_ITEM AS (
        SELECT nr AS rnum, token AS ITEM_ID
        FROM   STRING_SPLIT ('''+@P_ITEM_IDS+''','','')
    )
    --SELECT * FROM W_ITEM;
    , W_CALENDAR AS (
        SELECT --TOP 17
               CM.BASIS_YYYYMMDD
              ,CM.WEEK_NAME
              ,CM.PARTIAL_WEEK_NAME
              ,CM.PARTIAL_YN
              ,CM.BASIS_START_DATE
              ,CM.BASIS_END_DATE
              --,CM.*
        FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
        WHERE  1=1
        --AND    CM.DAYOFWEEK = ''MON''
        AND    CM.BASIS_YYYYMMDD >= CONVERT(CHAR(8), GETDATE()-7, 112) --(오늘-7)
        AND    CM.BASIS_YYYYMMDD <= CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112)
    )
    --SELECT * FROM W_CALENDAR;
    , PLAN_INFO AS
    (
        SELECT
              DIVISION_ID
            , PLAN_NAME
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
            FROM    SCM_MST_PLAN PLM WITH(NOLOCK)
            INNER JOIN SCM_MST_PLAN_DETAIL PLD WITH(NOLOCK)
                ON  PLM.DIVISION_ID = PLD.DIVISION_ID
                AND PLM.PLAN_ID     = PLD.PLAN_ID
            WHERE   1=1
            AND     PLM.PLAN_NAME       = CONVERT(CHAR(8), DATEADD(dd, 2 - DATEPART(dw, GETDATE()), GETDATE()), 112)--CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), ''MON'')), 112) -- 당주월요일
            AND     PLM.PLAN_CYCLE      = ''WEEKLY''
            AND     PLD.PLAN_STATUS     = ''1''
        ) AS PLAN_LIST
        WHERE ROW_NUM = 1
    )
    --SELECT * FROM PLAN_INFO
    ,  SEMI_PLAN AS
    (
        SELECT
              SP.ORIGIN_FROM_DIVISION_ID    AS FROM_DIVISION_ID
            , SP.ORIGIN_TO_DIVISION_ID      AS TO_DIVISION_ID
            , SP.DIVISION_ID                AS DIVISION_ID
            , SP.FROM_SITE
            , SP.TO_SITE
            , SP.ITEM_ID
            , '''' AS LINE
            , ''SHIP_PLAN_TOTAL''			AS MEASURE
            , WC.PARTIAL_WEEK_NAME
            , WC.BASIS_START_DATE
            , WC.BASIS_END_DATE
            , SP.YYYYMMDD
            , SP.QTY
        FROM [dbo].[SCP_ANL_SHIPMENT_PLAN_SEMI] AS SP WITH(NOLOCK)

                JOIN PLAN_INFO AS PI
                ON  SP.DIVISION_ID              = PI.DIVISION_ID
                AND SP.PLAN_START_YYYYMMDD      = PI.PLAN_NAME
                AND SP.PLAN_TYPE                = PI.PLAN_TYPE
                AND SP.SEQ                      = PI.PLAN_SEQ
                --AND SP.YYYYMMDD                   = PI.PLAN_NAME

                JOIN W_ITEM AS WI
                ON  SP.ITEM_ID                  = WI.ITEM_ID

                LEFT JOIN W_CALENDAR AS WC
                ON  SP.YYYYMMDD                 = WC.BASIS_YYYYMMDD

        WHERE   SP.DIVISION_ID          = ''EE''
        AND     SP.OPERATION_GROUP      = ''E''
        AND     SP.MEASURE              IN (''SHIP_PLAN_AMEND'')
    )
	, PKG_PROD_PLAN AS 
	(
		SELECT 
			PP.* 
			, WC.PARTIAL_WEEK_NAME
			, WC.BASIS_START_DATE
			, WC.BASIS_END_DATE
		FROM 
		(
			SELECT 
				  SEMI_ASSY.DIVISION_ID
				, SEMI_ASSY.FROM_DIVISION_ID
				, SEMI_ASSY.ITEM_ID 
				, SEMI_ASSY.LINE
				, ''PKG_PLAN''					AS MEASURE
				, SEMI_ASSY.FROM_SITE
				, PP.YYYYMMDD
				, SUM(PP.QTY)					AS QTY
			FROM SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)
				JOIN PLAN_INFO AS PI
				ON	PP.DIVISION_ID				= PI.DIVISION_ID
				AND PP.PLAN_START_YYYYMMDD		= PI.PLAN_NAME
				AND PP.PLAN_TYPE				= PI.PLAN_TYPE
				AND PP.SEQ						= PI.PLAN_SEQ	
				AND PP.YYYYMMDD					= PI.PLAN_NAME

				JOIN 
				(
					SELECT DISTINCT A.* , C.ITEM_ID_ASSY
					FROM SEMI_PLAN AS A
						JOIN SCP_MST_BOM_ELEC AS B
						ON	A.FROM_DIVISION_ID		= B.DIVISION_ID
						AND A.ITEM_ID				= B.CHILD_ITEM_ID
						JOIN SCP_MST_CELL_PROD_ASSY_MAP AS C
						ON	A.FROM_DIVISION_ID		= C.DIVISION_ID
						AND A.FROM_SITE				= C.PLANT_ID + ''-E''
						AND B.PARENT_ITEM_ID		= C.ITEM_ID_ASSY
				) AS SEMI_ASSY
				ON	PP.DIVISION_ID				= SEMI_ASSY.FROM_DIVISION_ID
				AND	PP.ITEM_ID					= SEMI_ASSY.ITEM_ID_ASSY



			WHERE	1 = 1
			AND		PP.OPERATION_GROUP		= ''A''
			AND		PP.MEASURE				IN (''PROD_PLAN_AMEND'')
			GROUP BY SEMI_ASSY.DIVISION_ID, SEMI_ASSY.FROM_DIVISION_ID,  SEMI_ASSY.ITEM_ID , SEMI_ASSY.LINE, PP.MEASURE, SEMI_ASSY.FROM_SITE , PP.YYYYMMDD	
		) AS PP
			LEFT JOIN W_CALENDAR AS WC
			ON  PP.YYYYMMDD	= WC.BASIS_YYYYMMDD
	)
    , PROD_PLAN AS
    (
        SELECT
              PP.DIVISION_ID
            , ORIGIN_DIVISION_ID        AS FROM_DIVISION_ID
            , PP.ITEM_ID
            , PP.LINE_ID
            , ''PROD_PLAN_AMEND''		AS MEASURE
            , PP.SCM_SITE_ID
            , PP.ELECTRODE_TYPE
            , WC.PARTIAL_WEEK_NAME
            , WC.BASIS_START_DATE
            , WC.BASIS_END_DATE
            , PP.YYYYMMDD
            , PP.QTY
        FROM SCP_ANL_PRODUCTION_PLAN AS PP WITH(NOLOCK)
                JOIN PLAN_INFO AS PI
                ON  PP.DIVISION_ID              = PI.DIVISION_ID
                AND PP.PLAN_START_YYYYMMDD      = PI.PLAN_NAME
                AND PP.PLAN_TYPE                = PI.PLAN_TYPE
                AND PP.SEQ                      = PI.PLAN_SEQ
                --AND PP.YYYYMMDD                   = PI.PLAN_NAME

                JOIN W_ITEM AS WI
                ON  PP.ITEM_ID                  = WI.ITEM_ID

                LEFT JOIN W_CALENDAR AS WC
                ON  PP.YYYYMMDD                 = WC.BASIS_YYYYMMDD

        WHERE   1                       = 1
        AND     PP.DIVISION_ID          = ''EE''
        AND     PP.OPERATION_GROUP      = ''E''
        AND     PP.MEASURE              IN (''PROD_PLAN_AMEND'')
    )
    --SELECT * FROM PROD_PLAN
    -- SELECT * FROM SEMI_PLAN
    -- SELECT * FROM PROD_PLAN WHERE ITEM_ID = ''APCAN2829A''
    , W_DAILY_SUM AS (
        SELECT
              MST_SITE.SITE_DESCRIPTION
            , FI.NICK_NAME
            , LIST.ITEM_ID
            , FI.ELECTRODE_TYPE
            , FI.CELL_CF
            , LIST.FACTORY_ID
            , LIST.LINE_ID
            , LIST.MEASURE
            , LIST.PARTIAL_WEEK_NAME
            , LIST.BASIS_START_DATE
            , LIST.BASIS_END_DATE
            , LIST.YYYYMMDD
            , LIST.QTY
        FROM
        (
            SELECT
                  DIVISION_ID               AS DIVISION_ID
                , FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID
                , FROM_SITE                 AS FROM_SITE_ID
                , ''-'' AS LINE_ID
                , ''-'' AS FACTORY_ID
                , ITEM_ID
                , ''S'' AS PSI_TYPE
                , MEASURE
                , PARTIAL_WEEK_NAME
                , BASIS_START_DATE
                , BASIS_END_DATE
                , YYYYMMDD
                , QTY
            FROM SEMI_PLAN AS A

			UNION ALL 
			SELECT 
				  DIVISION_ID				AS DIVISION_ID 
				, FROM_DIVISION_ID			AS ORIGIN_FROM_DIVISION_ID
				, FROM_SITE					AS FROM_SITE_ID
				, ''-'' AS LINE_ID
				, ''-'' AS FACTORY_ID
				, ITEM_ID   
				, ''S'' AS PSI_TYPE
				, MEASURE
                , PARTIAL_WEEK_NAME
                , BASIS_START_DATE
                , BASIS_END_DATE
                , YYYYMMDD
                , QTY
			FROM PKG_PROD_PLAN AS A

            UNION ALL
            SELECT
                  A.DIVISION_ID
                , FROM_DIVISION_ID          AS ORIGIN_FROM_DIVISION_ID -- MST_SITE.SITE_DESCRIPTION
                , SCM_SITE_ID
                , A.LINE_ID
                , LN.FACTORY_ID
                , A.ITEM_ID
                , ''P'' AS PSI_TYPE
                , MEASURE
                , PARTIAL_WEEK_NAME
                , BASIS_START_DATE
                , BASIS_END_DATE
                , YYYYMMDD
                , QTY
            FROM PROD_PLAN AS A
                JOIN dbo.SCM_LINE_M_SN LN WITH (NOLOCK)
                ON  A.SCM_SITE_ID                   = LN.PLANT_ID + ''-E''
                AND A.LINE_ID                       = LN.LINE_ID
                AND A.ELECTRODE_TYPE                = LN.ELECTRODE_TYPE
                AND LN.OPERATION_ID                 = ''E2000'' --E20251106-001431 공정코드 추가
        ) AS LIST

            JOIN SCM_MST_SITE AS MST_SITE WITH(NOLOCK)
            ON  LIST.ORIGIN_FROM_DIVISION_ID    = MST_SITE.DIVISION_ID
            AND LIST.FROM_SITE_ID               = MST_SITE.SCM_SITE_ID
            AND MST_SITE.SITE_TYPE              = ''PLANT''

            JOIN [dbo].[SCP_MST_FINAL_ITEM] AS FI WITH(NOLOCK)
            ON  LIST.ORIGIN_FROM_DIVISION_ID    = FI.DIVISION_ID
            AND LIST.ITEM_ID                    = FI.ITEM_ID
    )
    --SELECT *
    --FROM   W_DAILY_SUM
    --WHERE  1=1
    --AND    BASIS_START_DATE<=''20251229''
    --ORDER BY ITEM_ID , MEASURE;
    --
    , W_WEEKLY_SUM AS (
        SELECT
              SITE_DESCRIPTION
            , NICK_NAME
            , ITEM_ID
            , ELECTRODE_TYPE
            , CELL_CF
            , FACTORY_ID
            , LINE_ID
            , MEASURE
            , PARTIAL_WEEK_NAME
            , BASIS_START_DATE
            , BASIS_END_DATE
            --, YYYYMMDD
            , QTY=SUM(QTY)
        FROM W_DAILY_SUM WDS
        GROUP BY SITE_DESCRIPTION
            , NICK_NAME
            , ITEM_ID
            , ELECTRODE_TYPE
            , CELL_CF
            , FACTORY_ID
            , LINE_ID
            , MEASURE
            , PARTIAL_WEEK_NAME
            , BASIS_START_DATE
            , BASIS_END_DATE
    )
    --SELECT *
    --FROM   W_WEEKLY_SUM
    ----WHERE LIST.ITEM_ID IN (''APCAN2829A'',''APCCA2947A'',''APCAN1310A'')
    --ORDER BY ITEM_ID , MEASURE
    , W_PIV_SRC AS (
        SELECT SITE_DESCRIPTION
              ,NICK_NAME
              ,ITEM_ID
              ,ELECTRODE_TYPE
              ,CELL_CF
              ,FACTORY_ID
              ,LINE_ID
              ,MEASURE
              ,BASIS_START_DATE
              ,QTY
        FROM   W_WEEKLY_SUM WWS
    )
    --SELECT *
    --FROM W_PIV_SRC
    --WHERE  1=1
    --AND    BASIS_START_DATE<=''20251229''
    --;
    , W_PIV_RST_WEEK AS (
        SELECT
            SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, MEASURE
            ,'+@PIVOT_COLS_WITH_ALIAS+'
        FROM W_PIV_SRC WPS
        PIVOT
            (
                SUM(QTY)
                FOR BASIS_START_DATE IN ('+@PIVOT_COLS+')
            ) AS W_PIV_SRC
    )
    INSERT INTO SCM_SIM_DYN_COLS(
        SNAP_YYYYMMDD
       ,REPORT_TITLE
       ,PLANT_ID
       ,COMPANY_ID
       ,DIVISION_ID
       ,'+@INSCOL +'  
       ,SORT_SEQ1
    )
    SELECT '''+@P_SNAP_YYYYMMDD+'''
       ,'''+@P_REPORT_TITLE+'''
       ,'''+@P_PLANT_ID+'''
       ,'''+@P_COMPANY_ID+'''
       ,'''+@P_DIVISION_ID+'''
       , SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, MEASURE
       ,'+@INSERT_SELECT_COLS+'
       , 1000+ROW_NUMBER()OVER(ORDER BY SITE_DESCRIPTION, NICK_NAME, ITEM_ID, ELECTRODE_TYPE, CELL_CF, FACTORY_ID, LINE_ID, MEASURE)
    --INTO   ##TMP_W_PIV_RST_WEEK_RESULT
    FROM   W_PIV_RST_WEEK;'
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

    --SELECT * FROM SCM_SIM_DYN_COLS 

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
 
    --SELECT * FROM ##TMP_W_PIV_RST_WEEK_RESULT ORDER BY 1,2,3,4;

    --종료 LOG (START)
    SET @v_log_type = 'END';
    SET @v_log_message = '##### END of procedure #####';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_MAX_COLS_NUM:'+CONVERT(NVARCHAR(MAX),@P_MAX_COLS_NUM)+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_COMPANY_ID:'+@P_COMPANY_ID+',@P_DIVISION_ID:'+@P_DIVISION_ID;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
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


END CATCH

END

