
-- ==========================================================================================
-- Program:      DROP_PR_SCM_SIM_OPT_EE_UPDATE
-- Author:       김준규
-- Create date:  2025-12-12
-- Description:  SCM_SIM_OPT_EE_UPDATE 테이블에 데이터를 저장하고 호출한다
-- How to Execute: 

/*

DECLARE @V_RETVAL INT ;
DECLARE @V_STATUS INT ;
DECLARE @V_MSG    NVARCHAR(MAX);  
EXEC @V_RETVAL = [dbo].[DROP_PR_SCM_SIM_OPT_EE_UPDATE] @P_USER='jungyu9.kim'
   ,@P_SNAP_YYYYMMDD='20251217'
   ,@P_REPORT_TITLE='PR_SCM_SIM_OPT_EE_PSI_PSI_DETAL'
   ,@P_PLANT_ID='HQ06'
   ,@P_COMPANY_ID=''
   ,@P_DIVISION_ID='EE'
   ,@P_PLAN_TYPE='PR'
   ,@P_PLAN_SEQ='2'
   ,@P_MEASURE='PROD_PLAN_AMEND'
   ,@P_SORT_SEQ='144000'
   ,@P_YYYYMMDD='20260112' 
   ,@P_ITEM_ID='APCAN0901A'
   ,@P_QTY='777'      
   ,@P_DAY_COUNT='7'
   ,@X_STATUS = @V_STATUS OUTPUT
   ,@X_MSG = @V_MSG OUTPUT;

PRINT '@V_RETVAL:'+TRY_CONVERT(NVARCHAR(MAX),@V_RETVAL);
PRINT '@V_STATUS:'+TRY_CONVERT(NVARCHAR(MAX),@V_STATUS);
PRINT '@V_MSG:'+TRY_CONVERT(NVARCHAR(MAX),@V_MSG);

*/
-- ==========================================================================================
-- 2025-12-12       김준규       최초 릴리즈 후보
-- 2025-12-17       김준규       마지막 일자에 입력받은 숫자에 일자로 나눈 것 나머지가 입력되도록 수정
-- 2025-12-18       김준규       SCP계획 숫자가 없는 것도 입력할 수 있기 때문에 SCP계획 숫자 없는 것도 포함되도록 수정 
-- 2026-01-08       김준규       입력변수 ITEM_ID 추가하여 WEEK숫자를 일자로 변환시 아래로직으로 처리한다.
--                                기존 : CELL 수량 /7일 입력시 전극환산계수로 나누어서 소숫점까지 저장 6일까지, 나머지를 마지막일자에 저장
--                                변경 : CELL수량을 전극환산계수로 나눈다(전극수:소숫점 존재), FLOOR(전극수/7일) 하여 정수만 취한다. 그리고 나머지를 마지막일자에 저장
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[DROP_PR_SCM_SIM_OPT_EE_UPDATE]
    @P_USER          nvarchar(254) = ''
   ,@P_SNAP_YYYYMMDD nvarchar(8) = ''
   ,@P_REPORT_TITLE  nvarchar(254) = ''
   ,@P_PLANT_ID      nvarchar(30) = ''
   ,@P_COMPANY_ID    nvarchar(30) = ''
   ,@P_DIVISION_ID   nvarchar(30) = ''
   --,@P_PLAN_START_YYYYMMDD   nvarchar(8) = ''
   ,@P_PLAN_TYPE     nvarchar(30) = ''
   ,@P_PLAN_SEQ      INT
   --,@P_OPT_PLAN_ID   nvarchar(MAX) = ''
   ,@P_MEASURE       nvarchar(254) = 'PROD_PLAN_AMEND'
   ,@P_SORT_SEQ      INT
   ,@P_YYYYMMDD      nvarchar(8) = ''
   ,@P_ITEM_ID       nvarchar(50) = ''
   ,@P_QTY           numeric(20,10)
   ,@P_DAY_COUNT     INT
   ,@X_STATUS        INT OUTPUT           -- OUTPUT
   ,@X_MSG           NVARCHAR(200) OUTPUT -- OUTPUT
AS
BEGIN
	SET XACT_ABORT ON;
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
    DECLARE @v_program_name NVARCHAR(150) = 'DROP_PR_SCM_SIM_OPT_EE_UPDATE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_COMPANY_ID:'+@P_COMPANY_ID+',@P_DIVISION_ID:'+@P_DIVISION_ID+',@P_DAY_COUNT:'+CONVERT(NVARCHAR(MAX),@P_DAY_COUNT);
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY
    BEGIN TRANSACTION
    --------------------------------------------------------
    -- 1.
    --------------------------------------------------------
    DECLARE @V_DAY_COUNT INT = 1;
    SET @V_DAY_COUNT = (CASE WHEN (ISNULL(@P_DAY_COUNT,'') = '' OR @P_DAY_COUNT <= 1 ) THEN 1
                            WHEN @P_DAY_COUNT >= 7 THEN 7
                            ELSE @P_DAY_COUNT END);

    PRINT '@V_DAY_COUNT:'+ISNULL(CONVERT(VARCHAR(MAX),@V_DAY_COUNT),'NULL');

    DECLARE @CountOutput INT;
    DECLARE @BAL_ACCUM_QTY NUMERIC(20,10) = @P_QTY; --2025-12-17 김준규 마지막 일자에 입력받은 숫자에 일자로 나눈 것 나머지가 입력되도록 수정

    -----------------------------
    --CELL 수량을 전극수량으로 환산
    -----------------------------
    DECLARE @V_CONVERT_QTY_CELL NUMERIC(20,10);
    SET @V_CONVERT_QTY_CELL = ( SELECT ISNULL( MIN(Y.CONVERT_QTY_CELL),1.0)
                                  FROM SCP_MST_FINAL_ITEM Y WITH (NOLOCK)
                                 WHERE Y.ITEM_ID    = @P_ITEM_ID -- ITEM_ID
                                   AND Y.CONVERT_QTY_CELL IS NOT NULL );
    
    --2026-01-08 전극으로 환산된 숫자로 사용하도록 변경 : 전체수량 코트롤
    SET @BAL_ACCUM_QTY = ISNULL(@P_QTY,0.00) / @V_CONVERT_QTY_CELL; 
    
    --2026-01-08 입력받은 CELL 수량을 전극수량으로 환산. 
    DECLARE @V_QTY NUMERIC(20,10) =ISNULL(@P_QTY,0.00) / @V_CONVERT_QTY_CELL; 

    DECLARE @SELCOL NVARCHAR(MAX) = '';
    DECLARE @SQL NVARCHAR(MAX) = N'';

    SET @SELCOL = (SELECT CONC_YYYYMMDD=STRING_AGG(CM.BASIS_YYYYMMDD,',')
                   FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
                   WHERE  CM.BASIS_YYYYMMDD >= @P_YYYYMMDD
                   AND    CM.BASIS_YYYYMMDD < CONVERT(NVARCHAR(8),DATEADD(DD,@V_DAY_COUNT,@P_YYYYMMDD),112) );

    PRINT '@SELCOL:'+ISNULL(@SELCOL,'NULL');


    --#####################################################
    --SCM_SIM_OPT_EE_UPDATE 처리할 데이터 Insert 처리
    --#####################################################

    SELECT @DUMMY=COUNT(*) FROM  SCM_SIM_OPT_EE_UPDATE WITH(NOLOCK);
    PRINT '1 SCM_SIM_OPT_EE_UPDATE Count:'+@DUMMY;

    DECLARE @I INT = 0;
    DECLARE @V_YYYYMMDD NVARCHAR(8) = @P_YYYYMMDD;
    WHILE @I < @V_DAY_COUNT --@V_DAY_COUNT 7일경우 7회 루프 실행
    BEGIN
        SET @I = @I + 1;
        IF @I > 1
        BEGIN
            SET @V_YYYYMMDD = CONVERT(NVARCHAR(8),DATEADD(DD,1,@V_YYYYMMDD),112);
        END;
        --입력할 값에 대하여 먼저 삭제 하고 INSERT 한다.
        SET @SQL = N'
        --입력할 값에 대하여 먼저 삭제를 하기 때문에 HIST에 먼저 INSERT 한다.
        INSERT INTO DBO.SCM_SIM_OPT_EE_UPDATE_H
        (
            HISTORY_SEQ
           ,SNAP_YYYYMMDD
           ,REPORT_TITLE
           ,PLANT_ID
           ,COMPANY_ID
           ,DIVISION_ID
           ,PLAN_TYPE
           ,PLAN_SEQ
           ,MEASURE
           ,SORT_SEQ
           ,YYYYMMDD
           ,QTY
           ,CELL_QTY
           ,S_DIVISION_ID
           ,S_PLAN_START_YYYYMMDD
           ,S_PLAN_TYPE
           ,S_SEQ
           ,S_OPERATION_GROUP
           ,S_SCM_SITE_ID
           ,S_ITEM_ID
           ,S_LINE_ID
           ,S_OPERATION_ID
           ,S_MEASURE
           ,S_YYYYMMDD
           ,S_QTY
           ,S_ORIGIN_DIVISION_ID
           ,S_ELECTRODE_TYPE
           ,S_CELL_QTY
           ,CREATED_BY
           ,CREATION_DATE
           ,LAST_UPDATED_BY
           ,LAST_UPDATE_DATE
           ,ATTRIBUTE1
           ,ATTRIBUTE2
           ,ATTRIBUTE3
           ,ATTRIBUTE4
           ,ATTRIBUTE5
           ,HISTORY_CREATION_DATE
        )
        SELECT NEXT VALUE FOR SEQ1_SCM_SIM_OPT_EE_UPDATE_H AS HISTORY_SEQ
              ,SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CELL_QTY
              ,S_DIVISION_ID
              ,S_PLAN_START_YYYYMMDD
              ,S_PLAN_TYPE
              ,S_SEQ
              ,S_OPERATION_GROUP
              ,S_SCM_SITE_ID
              ,S_ITEM_ID
              ,S_LINE_ID
              ,S_OPERATION_ID
              ,S_MEASURE
              ,S_YYYYMMDD
              ,S_QTY
              ,S_ORIGIN_DIVISION_ID
              ,S_ELECTRODE_TYPE
              ,S_CELL_QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
              ,GETDATE() AS HISTORY_CREATION_DATE 
        FROM   DBO.SCM_SIM_OPT_EE_UPDATE WITH(NOLOCK)
        WHERE 1=1
        AND   SNAP_YYYYMMDD = '''+ @P_SNAP_YYYYMMDD + N'''
        AND   REPORT_TITLE  = '''+ @P_REPORT_TITLE  + N'''
        AND   ISNULL(PLANT_ID   ,'''')  = '''+ ISNULL(@P_PLANT_ID   ,'') + N'''
        AND   ISNULL(COMPANY_ID ,'''')  = '''+ ISNULL(@P_COMPANY_ID ,'') + N'''
        AND   ISNULL(DIVISION_ID,'''')  = '''+ ISNULL(@P_DIVISION_ID,'') + N'''
        AND   ISNULL(PLAN_TYPE  ,'''')  = '''+ ISNULL(@P_PLAN_TYPE  ,'') + N'''
        AND   PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND   MEASURE       = '''+ @P_MEASURE       + N'''
        AND   SORT_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        AND   YYYYMMDD      = '''+ @V_YYYYMMDD      + N'''; 
        --
        --입력할 값에 대하여 먼저 삭제 하고 INSERT 한다.
        DELETE DBO.SCM_SIM_OPT_EE_UPDATE
        WHERE 1=1
        AND   SNAP_YYYYMMDD = '''+ @P_SNAP_YYYYMMDD + N'''
        AND   REPORT_TITLE  = '''+ @P_REPORT_TITLE  + N'''
        AND   ISNULL(PLANT_ID   ,'''')  = '''+ ISNULL(@P_PLANT_ID   ,'') + N'''
        AND   ISNULL(COMPANY_ID ,'''')  = '''+ ISNULL(@P_COMPANY_ID ,'') + N'''
        AND   ISNULL(DIVISION_ID,'''')  = '''+ ISNULL(@P_DIVISION_ID,'') + N'''
        AND   ISNULL(PLAN_TYPE  ,'''')  = '''+ ISNULL(@P_PLAN_TYPE  ,'') + N'''
        AND   PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND   MEASURE       = '''+ @P_MEASURE       + N'''
        AND   SORT_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        AND   YYYYMMDD      = '''+ @V_YYYYMMDD      + N''' '+@crlf;
        SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

        --  프린트 및 실행
        SET @DUMMY = @sql;
        WHILE LEN(@DUMMY) > 0 AND ( @i = 1 OR @i = @P_DAY_COUNT)
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
        PRINT '-----------------------';
        PRINT 'Delete from SCM_SIM_OPT_EE_UPDATE @i:'+CONVERT(NVARCHAR(MAX),@I)+',@CountOutput:'+CONVERT(NVARCHAR(MAX),@n_log_count);


        --입력할 날짜컬럼과 수량컬럼을 조회한다.
        --시작일 구한다.
        DECLARE @QUERY_START_YYYYMMDD NVARCHAR(8);
        SELECT  @QUERY_START_YYYYMMDD = BASIS_YYYYMMDD FROM   dbo.SCM_SYS_CALENDAR_M AS CM WITH(NOLOCK)
        WHERE  1=1
        AND    CM.DAYOFWEEK = 'MON'
        AND    @P_SNAP_YYYYMMDD BETWEEN CM.BASIS_START_DATE AND CM.BASIS_END_DATE;
        
        --PRINT '@QUERY_START_YYYYMMDD:'+@QUERY_START_YYYYMMDD;
        DECLARE @C_WEEK_QTY NVARCHAR(MAX);
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
                --AND    CM.BASIS_YYYYMMDD <= @QUERY_END_YYYYMMDD--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일
                AND    CM.BASIS_YYYYMMDD <= @V_YYYYMMDD--CONVERT(CHAR(8), DATEADD(YEAR, 2 ,GETDATE()+7), 112) --2년 후 + 7일
            ) X
            GROUP BY BASIS_START_DATE
        )
        , W_CAL_RST AS (
            SELECT BASIS_START_DATE_GR,WEEK_NAME,PARTIAL_WEEK_NAME,ISO_YYYYWW,BASIS_START_DATE,BASIS_END_DATE,BASIS_START_END_DATE,DAY_PER_WEEK
            FROM   W_CAL
        )
        --SELECT *FROM W_CAL_RST;
        , W_CWEEK AS (
            SELECT RNUM = ROW_NUMBER() OVER (ORDER BY BASIS_START_DATE DESC)
                  ,C_WEEK='C'+CONVERT(NVARCHAR(30), 20+ROW_NUMBER() OVER (ORDER BY BASIS_START_DATE DESC))
                  ,BASIS_WQTY_WEEK='WQTY'+CONVERT(NVARCHAR(MAX),DENSE_RANK() OVER (ORDER BY ISO_YYYYWW))+CASE WHEN ISNULL(SUBSTRING(PARTIAL_WEEK_NAME,4,1),'') <> '' THEN '_'+SUBSTRING(PARTIAL_WEEK_NAME,4,1) ELSE '' END
                  ,BASIS_START_END_DATE=SUBSTRING(BASIS_START_DATE,5,2)+'.'+SUBSTRING(BASIS_START_DATE,7,2)+'~'+SUBSTRING(BASIS_END_DATE,5,2)+'.'+SUBSTRING(BASIS_END_DATE,7,2)
                  ,PARTIAL_WEEK_NAME
                  ,DAY_PER_WEEK
                  ,BASIS_START_DATE
                  ,FILL_VAL_BLANK=''
            --INTO   #TMP_WEEK_NAME_LABEL
            FROM   W_CAL_RST
        )
        SELECT @C_WEEK_QTY = 'C'+CONVERT(NVARCHAR(30),COUNT(C_WEEK)+20)
        FROM   W_CWEEK AS WC
        ;

        --##################################################
        --UPLOAD 와 저장된 데이터와 조인하여 Insert 한다.
        --##################################################
        ----2025-12-17 김준규 마지막 일자에 입력받은 숫자에 일자로 나눈 것 나머지가 입력되도록 수정
        ----2026-01-08 김준규 WEEK숫자를 일자로 변환시 아래로직으로 처리한다.
        ----                   기존 : CELL 수량 /7일 입력시 전극환산계수로 나누어서 소숫점까지 저장 6일까지, 나머지를 마지막일자에 저장
        ----                   변경 : CELL수량을 전극환산계수로 나눈다(전극수:소숫점 존재), FLOOR(전극수/7일) 하여 정수만 취한다. 그리고 나머지를 마지막일자에 저장
        IF @I <> @V_DAY_COUNT BEGIN
            SET @BAL_ACCUM_QTY = @BAL_ACCUM_QTY - FLOOR(@V_QTY/@V_DAY_COUNT)
        END;

        SET @SQL  = N'WITH W_UP_RAW AS ('+@crlf
        SET @SQL += N'SELECT'+@crlf
        SET @SQL += N' ''' + @P_SNAP_YYYYMMDD + N''' AS SNAP_YYYYMMDD'+@crlf
        SET @SQL += N',''' + @P_REPORT_TITLE  + N''' AS REPORT_TITLE'+@crlf
        SET @SQL += N',''' + ISNULL(@P_PLANT_ID   ,'')  + N''' AS PLANT_ID'+@crlf
        SET @SQL += N',''' + ISNULL(@P_COMPANY_ID ,'')  + N''' AS COMPANY_ID'+@crlf
        SET @SQL += N',''' + ISNULL(@P_DIVISION_ID,'')  + N''' AS DIVISION_ID'+@crlf
        SET @SQL += N',''' + @P_PLAN_TYPE     + N''' AS PLAN_TYPE'+@crlf
        SET @SQL += N',''' + CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N''' AS PLAN_SEQ'+@crlf
        SET @SQL += N',''' + @P_MEASURE       + N''' AS MEASURE'+@crlf
        SET @SQL += N',''' + CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N''' AS SORT_SEQ'+@crlf
        SET @SQL += N',''' + @V_YYYYMMDD      + N''' AS YYYYMMDD'+@crlf
        ----2025-12-17 김준규 마지막 일자에 입력받은 숫자에 일자로 나눈 것 나머지가 입력되도록 수정
        ----2026-01-08 김준규 WEEK숫자를 일자로 변환시 아래로직으로 처리한다.
        ----                   기존 : CELL 수량 /7일 입력시 전극환산계수로 나누어서 소숫점까지 저장 6일까지, 나머지를 마지막일자에 저장
        ----                   변경 : CELL수량을 전극환산계수로 나눈다(전극수:소숫점 존재), FLOOR(전극수/7일) 하여 정수만 취한다. 그리고 나머지를 마지막일자에 저장
        --아래는 전극수량임 이미 CELL을 전극으로 바꿈.
        --마지막 일자제외는 정수입력 마지막 일자는 소숫점 포함 될 수 있음.
        SET @SQL += N',''' + (CASE WHEN @i = @V_DAY_COUNT THEN CONVERT(NVARCHAR(MAX),@BAL_ACCUM_QTY) ELSE CONVERT(NVARCHAR(MAX),FLOOR(@V_QTY/@V_DAY_COUNT)) END) + N''' AS QTY'+@crlf
        SET @SQL += N',''' + @P_USER          + N''' AS CREATED_BY'+@crlf
        SET @SQL += N',''' + @P_USER          + N''' AS LAST_UPDATED_BY'+@crlf
        SET @SQL += N')'+@crlf
        SET @SQL += N'
    , W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CONVERT(VARCHAR(19), GETDATE(), 120) AS CREATION_DATE
              ,LAST_UPDATED_BY
              ,CONVERT(VARCHAR(19), GETDATE(), 120) AS LAST_UPDATE_DATE
        FROM   W_UP_RAW WUR WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(WUR.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(WUR.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(WUR.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    WUR.PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    WUR.PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    WUR.MEASURE       = '''+ @P_MEASURE       + N'''
        AND    WUR.SORT_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        AND    WUR.YYYYMMDD      = '''+ @V_YYYYMMDD      + N'''
        AND    WUR.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT WSR.SNAP_YYYYMMDD
              ,WSR.REPORT_TITLE
              ,WSR.PLANT_ID
              ,WSR.COMPANY_ID
              ,WSR.DIVISION_ID
              ,WSR.PLAN_TYPE
              ,WSR.PLAN_SEQ
              ,WSR.MEASURE
              ,WSR.SORT_SEQ
              ,WSR.YYYYMMDD
              --,WSR.QTY
              --이미 전극수량으로 환산되어 있음
              ,ISNULL(WSR.qty,0.00) AS QTY 
              --2026-01-08 이미 전극수량을 CELL로 변환, 전극수량으로 이미 해 놓았기에
              ,ISNULL(WSR.QTY,0.00) * '+CONVERT(NVARCHAR(MAX),@V_CONVERT_QTY_CELL)+' AS CELL_QTY
              ,SDC.C1 AS S_DIVISION_ID
              ,SDC.C2 AS S_PLAN_START_YYYYMMDD
              ,SDC.C3 AS S_PLAN_TYPE
              ,SDC.C4 AS S_SEQ
              ,SDC.C372 AS S_OPERATION_GROUP
              ,SDC.C5 AS S_SCM_SITE_ID
              ,SDC.C8 AS S_ITEM_ID
              ,SDC.C12 AS S_LINE_ID
              ,SDC.C373 AS S_OPERATION_ID
              ,SDC.C14 AS S_MEASURE
              ,'''+@V_YYYYMMDD+N''' AS S_YYYYMMDD
              ,SDC.'+@C_WEEK_QTY+N' AS S_QTY
              ,SDC.C371 AS S_ORIGIN_DIVISION_ID
              ,SDC.C9 AS S_ELECTRODE_TYPE
              ,SDC.C374 AS S_CELL_QTY
              --미래에  사용할 수 있으나 지금은 하지않음.
              --,SDC.C11 AS S_FACTORY_ID 
              --,FMS.FACTORY_NAME AS S_FACTORY_NAME
              ,WSR.CREATED_BY
              ,WSR.CREATION_DATE
              ,WSR.LAST_UPDATED_BY
              ,WSR.LAST_UPDATE_DATE
              ,NULL AS ATTRIBUTE1
              ,NULL AS ATTRIBUTE2
              ,NULL AS ATTRIBUTE3
              ,NULL AS ATTRIBUTE4
              ,NULL AS ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = SDC.C14
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
        LEFT JOIN [dbo].[SCM_FACTORY_M_SN] FMS WITH(NOLOCK)
        ON     FMS.PLANT_ID      = SDC.PLANT_ID
        AND    FMS.FACTORY_ID    = SDC.C12
    )
    --SELECT * FROM W_RPT_RAW;
    SELECT WRR.*--,APP.*
    FROM   SCP_ANL_PRODUCTION_PLAN APP
    JOIN   W_RPT_RAW AS WRR
    ON     1=1
    AND    WRR.S_DIVISION_ID          = APP.DIVISION_ID
    AND    WRR.S_PLAN_START_YYYYMMDD  = APP.PLAN_START_YYYYMMDD
    AND    WRR.S_PLAN_TYPE            = APP.PLAN_TYPE
    AND    WRR.S_SEQ                  = APP.SEQ
    AND    WRR.S_OPERATION_GROUP      = APP.OPERATION_GROUP
    AND    WRR.S_SCM_SITE_ID          = APP.SCM_SITE_ID
    AND    WRR.S_ITEM_ID              = APP.ITEM_ID
    AND    WRR.S_LINE_ID              = APP.LINE_ID
    AND    WRR.S_OPERATION_ID         = APP.OPERATION_ID
    AND    WRR.S_MEASURE              = APP.MEASURE
    -- 2025-12-18 김준규 SCP계획 숫자가 없는 것도 입력할 수 있기 때문에 SCP계획 숫자 없는 것도 포함되도록 수정
    /*AND    WRR.S_QTY                  IS NOT NULL --매칭이 안될 경우 NULL 값이 나온다.*/
    AND    WRR.S_YYYYMMDD             = APP.YYYYMMDD;'+CHAR(12)+CHAR(10);
    SET @SQL += N'SET @CountOutput= @@ROWCOUNT';

        --  프린트 및 실행
        SET @DUMMY = @sql;
        WHILE LEN(@DUMMY) > 0 AND ( @i = 1 OR @i = @P_DAY_COUNT)
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
        INSERT INTO DBO.SCM_SIM_OPT_EE_UPDATE
        (
            SNAP_YYYYMMDD
           ,REPORT_TITLE
           ,PLANT_ID
           ,COMPANY_ID
           ,DIVISION_ID
           ,PLAN_TYPE
           ,PLAN_SEQ
           ,MEASURE
           ,SORT_SEQ
           ,YYYYMMDD
           ,QTY
           ,CELL_QTY
           ,S_DIVISION_ID
           ,S_PLAN_START_YYYYMMDD
           ,S_PLAN_TYPE
           ,S_SEQ
           ,S_OPERATION_GROUP
           ,S_SCM_SITE_ID
           ,S_ITEM_ID
           ,S_LINE_ID
           ,S_OPERATION_ID
           ,S_MEASURE
           ,S_YYYYMMDD
           ,S_QTY
           ,S_ORIGIN_DIVISION_ID
           ,S_ELECTRODE_TYPE
           ,S_CELL_QTY
           ,CREATED_BY
           ,CREATION_DATE
           ,LAST_UPDATED_BY
           ,LAST_UPDATE_DATE
           ,ATTRIBUTE1
           ,ATTRIBUTE2
           ,ATTRIBUTE3
           ,ATTRIBUTE4
           ,ATTRIBUTE5
        )
        EXEC sp_executesql
            @sql,
            N'@CountOutput INT OUTPUT',  -- 파라미터 정의
            @CountOutput = @n_log_count OUTPUT;
        PRINT 'Insert into SCM_SIM_OPT_EE_UPDATE  @i:'+CONVERT(NVARCHAR(MAX),@I)+',@CountOutput:'+CONVERT(NVARCHAR(MAX),@n_log_count);
        
    END

    SELECT @DUMMY=COUNT(*) FROM  SCM_SIM_OPT_EE_UPDATE WITH(NOLOCK);
    PRINT '2 SCM_SIM_OPT_EE_UPDATE Count:'+@DUMMY;

    --#####################################################
    --SCP_ANL_PRODUCTION_PLAN update 처리
    --#####################################################
    SET @SQL = N'
    WITH W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
        FROM   SCM_SIM_OPT_EE_UPDATE OEU WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(OEU.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(OEU.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(OEU.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    MEASURE  = '''+@P_MEASURE +N'''
        AND    SORT_SEQ  = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        --AND    YYYYMMDD  = '''+@P_YYYYMMDD +N'''
        AND    OEU.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT SDC.C1 AS DIVISION_ID
              ,SDC.C2 AS PLAN_START_YYYYMMDD
              ,SDC.C3 AS PLAN_TYPE
              ,SDC.C4 AS PLAN_SEQ
              ,SDC.C372 AS OPERATION_GROUP
              ,SDC.C5 AS SCM_SITE_ID
              ,SDC.C8 AS ITEM_ID
              ,SDC.C12 AS LINE_ID
              ,SDC.C373 AS OPERATION_ID
              ,SDC.C14 AS MEASURE
              ,WSR.YYYYMMDD
              --,WSR.QTY
              --2025-12-18 김준규 CELL 수량을 전극수량으로한 것은 업데이트용 테이블에 이미 환산되어 있다
              ,ISNULL(WSR.qty,0.00) AS QTY
              ,SDC.C371 AS ORIGIN_DIVISION_ID
              ,SDC.C9 AS ELECTRODE_TYPE
              ,WSR.CREATED_BY
              ,WSR.CREATION_DATE
              ,WSR.LAST_UPDATED_BY
              ,WSR.LAST_UPDATE_DATE
              ,WSR.ATTRIBUTE1
              ,WSR.ATTRIBUTE2
              ,WSR.ATTRIBUTE3
              ,WSR.ATTRIBUTE4
              ,WSR.ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = '''+@P_MEASURE +N'''
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
    )
    --SELECT * FROM W_RPT_RAW;
    UPDATE APP
    SET    APP.QTY = WRR.QTY
          ,APP.LAST_UPDATED_BY = LEFT(APP.LAST_UPDATED_BY+''^''+WRR.LAST_UPDATED_BY,150)
          ,APP.LAST_UPDATE_DATE = WRR.LAST_UPDATE_DATE
    --SELECT WRR.*,APP.*
    FROM   SCP_ANL_PRODUCTION_PLAN APP
    JOIN   W_RPT_RAW AS WRR
    ON     1=1
    AND    WRR.DIVISION_ID          = APP.DIVISION_ID
    AND    WRR.PLAN_START_YYYYMMDD  = APP.PLAN_START_YYYYMMDD
    AND    WRR.PLAN_TYPE            = APP.PLAN_TYPE
    AND    WRR.PLAN_SEQ             = APP.SEQ
    AND    WRR.OPERATION_GROUP      = APP.OPERATION_GROUP
    AND    WRR.SCM_SITE_ID          = APP.SCM_SITE_ID
    AND    WRR.ITEM_ID              = APP.ITEM_ID
    AND    WRR.LINE_ID              = APP.LINE_ID
    AND    WRR.OPERATION_ID         = APP.OPERATION_ID
    AND    WRR.MEASURE              = APP.MEASURE
    AND    WRR.YYYYMMDD             = APP.YYYYMMDD;'+CHAR(12)+CHAR(10);
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
    PRINT 'UPDATE SCP_ANL_PRODUCTION_PLAN @CountOutput :'+CONVERT(NVARCHAR(MAX),@n_log_count);

    --#####################################################
    --SCP_ANL_PRODUCTION_PLAN_H Insert 처리
    --#####################################################
    SET @SQL = N'
    WITH W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
        FROM   SCM_SIM_OPT_EE_UPDATE OEU WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(OEU.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(OEU.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(OEU.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    MEASURE  = '''+@P_MEASURE +N'''
        AND    SORT_SEQ  = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        --AND    YYYYMMDD  = '''+@P_YYYYMMDD +N'''
        AND    OEU.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT SDC.C1 AS DIVISION_ID
              ,SDC.C2 AS PLAN_START_YYYYMMDD
              ,SDC.C3 AS PLAN_TYPE
              ,SDC.C4 AS PLAN_SEQ
              ,SDC.C372 AS OPERATION_GROUP
              ,SDC.C5 AS SCM_SITE_ID
              ,SDC.C8 AS ITEM_ID
              ,SDC.C12 AS LINE_ID
              ,SDC.C373 AS OPERATION_ID
              ,SDC.C14 AS MEASURE
              ,WSR.YYYYMMDD
              --,WSR.QTY
              --CELL 수량을 전극수량으로 환산
              --2025-12-18 김준규 CELL 수량을 전극수량으로한 것은 업데이트용 테이블에 이미 환산되어 있다
              ,ISNULL(WSR.qty,0.00) AS QTY
              ,SDC.C371 AS ORIGIN_DIVISION_ID
              ,SDC.C9 AS ELECTRODE_TYPE
              ,WSR.CREATED_BY
              ,WSR.CREATION_DATE
              ,WSR.LAST_UPDATED_BY
              ,WSR.LAST_UPDATE_DATE
              ,WSR.ATTRIBUTE1
              ,WSR.ATTRIBUTE2
              ,WSR.ATTRIBUTE3
              ,WSR.ATTRIBUTE4
              ,WSR.ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = '''+@P_MEASURE +N'''
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
    )
    --SELECT * FROM W_RPT_RAW;
    --UPDATE APP
    --SET    QTY = WRR.QTY
    --      ,LAST_UPDATED_BY = WRR.LAST_UPDATED_BY
    --      ,LAST_UPDATE_DATE = WRR.LAST_UPDATE_DATE
    --SELECT WRR.*,APP.*
    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_H AS HISTORY_SEQ
          ,APP.DIVISION_ID
          ,APP.PLAN_START_YYYYMMDD
          ,APP.PLAN_TYPE
          ,APP.SEQ
          ,APP.OPERATION_GROUP
          ,APP.SCM_SITE_ID
          ,APP.ITEM_ID
          ,APP.LINE_ID
          ,APP.OPERATION_ID
          ,APP.MEASURE
          ,APP.YYYYMMDD
          ,WRR.QTY AS QTY
          ,APP.ORIGIN_DIVISION_ID
          ,APP.ELECTRODE_TYPE
          ,APP.CREATED_BY
          ,APP.CREATION_DATE
          ,WRR.LAST_UPDATED_BY
          ,WRR.LAST_UPDATE_DATE
          ,APP.ATTRIBUTE1
          ,APP.ATTRIBUTE2
          ,APP.ATTRIBUTE3
          ,APP.ATTRIBUTE4
          ,APP.ATTRIBUTE5
          ,APP.ATTRIBUTE6
          ,APP.ATTRIBUTE7
          ,APP.ATTRIBUTE8
          ,APP.ATTRIBUTE9
          ,APP.ATTRIBUTE10
          ,GETDATE() AS HISTORY_CREATION_DATE
    FROM   SCP_ANL_PRODUCTION_PLAN APP
    JOIN   W_RPT_RAW AS WRR
    ON     1=1
    AND    WRR.DIVISION_ID          = APP.DIVISION_ID
    AND    WRR.PLAN_START_YYYYMMDD  = APP.PLAN_START_YYYYMMDD
    AND    WRR.PLAN_TYPE            = APP.PLAN_TYPE
    AND    WRR.PLAN_SEQ             = APP.SEQ
    AND    WRR.OPERATION_GROUP      = APP.OPERATION_GROUP
    AND    WRR.SCM_SITE_ID          = APP.SCM_SITE_ID
    AND    WRR.ITEM_ID              = APP.ITEM_ID
    AND    WRR.LINE_ID              = APP.LINE_ID
    AND    WRR.OPERATION_ID         = APP.OPERATION_ID
    AND    WRR.MEASURE              = APP.MEASURE
    AND    WRR.YYYYMMDD             = APP.YYYYMMDD;'+CHAR(12)+CHAR(10);
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
    INSERT INTO dbo.SCP_ANL_PRODUCTION_PLAN_H
    (
      HISTORY_SEQ
      ,DIVISION_ID
      ,PLAN_START_YYYYMMDD
      ,PLAN_TYPE
      ,SEQ
      ,OPERATION_GROUP
      ,SCM_SITE_ID
      ,ITEM_ID
      ,LINE_ID
      ,OPERATION_ID
      ,MEASURE
      ,YYYYMMDD
      ,QTY
      ,ORIGIN_DIVISION_ID
      ,ELECTRODE_TYPE
      ,CREATED_BY
      ,CREATION_DATE
      ,LAST_UPDATED_BY
      ,LAST_UPDATE_DATE
      ,ATTRIBUTE1
      ,ATTRIBUTE2
      ,ATTRIBUTE3
      ,ATTRIBUTE4
      ,ATTRIBUTE5
      ,ATTRIBUTE6
      ,ATTRIBUTE7
      ,ATTRIBUTE8
      ,ATTRIBUTE9
      ,ATTRIBUTE10
      ,HISTORY_CREATION_DATE
    )
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT 'Insert into SCP_ANL_PRODUCTION_PLAN_H @CountOutput :'+CONVERT(NVARCHAR(MAX),@n_log_count);


    --#####################################################
    --SCP_ANL_PRODUCTION_PLAN_FIX update 처리 --있으면 update 됨
    --#####################################################
    SET @SQL = N'
    WITH W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
        FROM   SCM_SIM_OPT_EE_UPDATE OEU WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(OEU.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(OEU.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(OEU.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    MEASURE  = '''+@P_MEASURE +N'''
        AND    SORT_SEQ  = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        --AND    YYYYMMDD  = '''+@P_YYYYMMDD +N'''
        AND    OEU.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT SDC.C1 AS DIVISION_ID
              ,SDC.C2 AS PLAN_START_YYYYMMDD
              ,SDC.C3 AS PLAN_TYPE
              ,SDC.C4 AS PLAN_SEQ
              ,SDC.C372 AS OPERATION_GROUP
              ,SDC.C5 AS SCM_SITE_ID
              ,SDC.C8 AS ITEM_ID
              ,SDC.C12 AS LINE_ID
              ,SDC.C373 AS OPERATION_ID
              ,SDC.C14 AS MEASURE
              ,WSR.YYYYMMDD
              --,WSR.QTY
              --CELL 수량을 전극수량으로 환산
              --2025-12-18 김준규 CELL 수량을 전극수량으로한 것은 업데이트용 테이블에 이미 환산되어 있다
              ,ISNULL(WSR.qty,0.00) AS QTY
              ,SDC.C371 AS ORIGIN_DIVISION_ID
              ,SDC.C9 AS ELECTRODE_TYPE
              ,WSR.CREATED_BY
              ,WSR.CREATION_DATE
              ,WSR.LAST_UPDATED_BY
              ,WSR.LAST_UPDATE_DATE
              ,WSR.ATTRIBUTE1
              ,WSR.ATTRIBUTE2
              ,WSR.ATTRIBUTE3
              ,WSR.ATTRIBUTE4
              ,WSR.ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = '''+@P_MEASURE +N'''
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
    )
    --SELECT * FROM W_RPT_RAW;
    UPDATE APP
    SET    APP.QTY = WRR.QTY
          --,APP.ATTRIBUTE1      =''Y'' --존재 하는 경우 업데이트 됨
          ,APP.LAST_UPDATED_BY = LEFT(APP.LAST_UPDATED_BY+''^''+WRR.LAST_UPDATED_BY,150)
          ,APP.LAST_UPDATE_DATE = WRR.LAST_UPDATE_DATE
    --SELECT WRR.*,APP.*
    FROM   SCP_ANL_PRODUCTION_PLAN_FIX APP
    JOIN   W_RPT_RAW AS WRR
    ON     1=1
    AND    WRR.DIVISION_ID          = APP.DIVISION_ID
    --AND    WRR.PLAN_START_YYYYMMDD  = APP.PLAN_START_YYYYMMDD
    --AND    WRR.PLAN_TYPE            = APP.PLAN_TYPE
    --AND    WRR.SEQ                  = APP.SEQ
    AND    WRR.OPERATION_GROUP      = APP.OPERATION_GROUP
    AND    WRR.SCM_SITE_ID          = APP.SCM_SITE_ID
    AND    WRR.ITEM_ID              = APP.ITEM_ID
    AND    WRR.LINE_ID              = APP.LINE_ID
    --기존소스에 막혀있어서 여기 막음
    --AND    WRR.OPERATION_ID         = APP.OPERATION_ID
    --AND    WRR.MEASURE              = APP.MEASURE
    AND    WRR.YYYYMMDD             = APP.YYYYMMDD;'+CHAR(12)+CHAR(10);
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
    PRINT 'UPDATE SCP_ANL_PRODUCTION_PLAN_FIX @CountOutput :'+CONVERT(NVARCHAR(MAX),@n_log_count);


    --#####################################################
    --SCP_ANL_PRODUCTION_PLAN_FIX_H : FIX History 입력 --있으면 update 한 것 Insert
    --#####################################################
    SET @SQL = N'
    WITH W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
        FROM   SCM_SIM_OPT_EE_UPDATE OEU WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(OEU.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(OEU.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(OEU.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    MEASURE  = '''+@P_MEASURE +N'''
        AND    SORT_SEQ  = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        --AND    YYYYMMDD  = '''+@P_YYYYMMDD +N'''
        AND    OEU.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT SDC.C1 AS DIVISION_ID
              ,SDC.C2 AS PLAN_START_YYYYMMDD
              ,SDC.C3 AS PLAN_TYPE
              ,SDC.C4 AS PLAN_SEQ
              ,SDC.C372 AS OPERATION_GROUP
              ,SDC.C5 AS SCM_SITE_ID
              ,SDC.C8 AS ITEM_ID
              ,SDC.C12 AS LINE_ID
              ,SDC.C373 AS OPERATION_ID
              ,SDC.C14 AS MEASURE
              ,WSR.YYYYMMDD
              --,WSR.QTY
              --CELL 수량을 전극수량으로 환산
              --2025-12-18 김준규 CELL 수량을 전극수량으로한 것은 업데이트용 테이블에 이미 환산되어 있다
              ,ISNULL(WSR.qty,0.00) AS QTY
              ,SDC.C371 AS ORIGIN_DIVISION_ID
              ,SDC.C9 AS ELECTRODE_TYPE
              ,WSR.CREATED_BY
              ,WSR.CREATION_DATE
              ,WSR.LAST_UPDATED_BY
              ,WSR.LAST_UPDATE_DATE
              ,WSR.ATTRIBUTE1
              ,WSR.ATTRIBUTE2
              ,WSR.ATTRIBUTE3
              ,WSR.ATTRIBUTE4
              ,WSR.ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = '''+@P_MEASURE +N'''
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
    )
    --SELECT * FROM W_RPT_RAW;
    SELECT NEXT VALUE FOR SEQ1_SCP_ANL_PRODUCTION_PLAN_FIX_H
          ,APP.FIX_ID
          ,APP.DIVISION_ID
          ,APP.OPERATION_GROUP
          ,APP.SCM_SITE_ID
          ,APP.ITEM_ID
          ,APP.LINE_ID
          ,APP.OPERATION_ID
          ,APP.YYYYMMDD
          ,WRR.QTY --APP.QTY
          ,APP.FIX_REASON
          ,APP.ORIGIN_DIVISION_ID
          ,APP.ELECTRODE_TYPE
          ,APP.CREATED_BY
          ,APP.CREATION_DATE
          ,WRR.LAST_UPDATED_BY
          ,WRR.LAST_UPDATE_DATE
          --,ATTRIBUTE1
          --,ATTRIBUTE2
          --,ATTRIBUTE3
          --,ATTRIBUTE4
          --,ATTRIBUTE5
          --,ATTRIBUTE6
          --,ATTRIBUTE7
          --,ATTRIBUTE8
          --,ATTRIBUTE9
          --,ATTRIBUTE10
          ,GETDATE()    AS HISTORY_CREATION_DATE
    --SELECT WRR.*,APP.*
    FROM   SCP_ANL_PRODUCTION_PLAN_FIX APP
    JOIN   W_RPT_RAW AS WRR
    ON     1=1
    AND    WRR.DIVISION_ID          = APP.DIVISION_ID
    --AND    WRR.PLAN_START_YYYYMMDD  = APP.PLAN_START_YYYYMMDD
    --AND    WRR.PLAN_TYPE            = APP.PLAN_TYPE
    --AND    WRR.SEQ                  = APP.SEQ
    AND    WRR.OPERATION_GROUP      = APP.OPERATION_GROUP
    AND    WRR.SCM_SITE_ID          = APP.SCM_SITE_ID
    AND    WRR.ITEM_ID              = APP.ITEM_ID
    AND    WRR.LINE_ID              = APP.LINE_ID
    --기존소스에 막혀있어서 여기 막음
    --AND    WRR.OPERATION_ID         = APP.OPERATION_ID
    --AND    WRR.MEASURE              = APP.MEASURE
    AND    WRR.YYYYMMDD             = APP.YYYYMMDD;'+CHAR(12)+CHAR(10);
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
    INSERT INTO dbo.SCP_ANL_PRODUCTION_PLAN_FIX_H
    (
        HISTORY_SEQ
        ,FIX_ID
        ,DIVISION_ID
        ,OPERATION_GROUP
        ,SCM_SITE_ID
        ,ITEM_ID
        ,LINE_ID
        ,OPERATION_ID
        ,YYYYMMDD
        ,QTY
        ,FIX_REASON
        ,ORIGIN_DIVISION_ID
        ,ELECTRODE_TYPE
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
        --,ATTRIBUTE1
        --,ATTRIBUTE2
        --,ATTRIBUTE3
        --,ATTRIBUTE4
        --,ATTRIBUTE5
        --,ATTRIBUTE6
        --,ATTRIBUTE7
        --,ATTRIBUTE8
        --,ATTRIBUTE9
        --,ATTRIBUTE10
        ,HISTORY_CREATION_DATE
    )
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT 'Insert into SCP_ANL_PRODUCTION_PLAN_FIX_H @CountOutput :'+CONVERT(NVARCHAR(MAX),@n_log_count);


    -------------------------------------------------------------------------------------------------------------
    -- PROD_PLAN_AMEND  저장시 SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE='EE_PRODUCTION_PLAN' 저장로직 추가
    -- HISTORY 테이블에도 입력되어야 해서, NOT EXISTS때문에 HISTORY를 먼저 호출한다. 
    -- SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE 에러나도 HISTORY의 데이터를 ROLLBACK없이 그냥둔다.
    -------------------------------------------------------------------------------------------------------------
    -- HISTORY 테이블 SCM_ADM_LOOKUP_MASTER_DETAIL_H 먼저한다.
    SET @SQL = N'
    WITH W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
        FROM   SCM_SIM_OPT_EE_UPDATE OEU WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(OEU.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(OEU.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(OEU.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    MEASURE  = '''+@P_MEASURE +N'''
        AND    SORT_SEQ  = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        --AND    YYYYMMDD  = '''+@P_YYYYMMDD +N'''
        AND    OEU.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT DISTINCT
               SDC.C1 AS DIVISION_ID
              --,SDC.C2 AS PLAN_START_YYYYMMDD
              --,SDC.C3 AS PLAN_TYPE
              --,SDC.C4 AS SEQ
              ,SDC.C372 AS OPERATION_GROUP
              ,SDC.C5 AS SCM_SITE_ID
              --,SDC.C8 AS ITEM_ID
              ,SDC.C12 AS LINE_ID
              ,SDC.C373 AS OPERATION_ID
              --,SDC.C14 AS MEASURE
              --,WSR.YYYYMMDD
              --,WSR.QTY
              --CELL 수량을 전극수량으로 환산
              --2025-12-18 김준규 CELL 수량을 전극수량으로한 것은 업데이트용 테이블에 이미 환산되어 있다
              --,ISNULL(WSR.qty,0.00) AS QTY
              ,SDC.C371 AS ORIGIN_DIVISION_ID
              --,SDC.C9 AS ELECTRODE_TYPE
              --,WSR.CREATED_BY
              --,WSR.CREATION_DATE
              --,WSR.LAST_UPDATED_BY
              --,WSR.LAST_UPDATE_DATE
              --,WSR.ATTRIBUTE1
              --,WSR.ATTRIBUTE2
              --,WSR.ATTRIBUTE3
              --,WSR.ATTRIBUTE4
              --,WSR.ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = '''+@P_MEASURE +N'''
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
    )
    --SELECT * FROM W_RPT_RAW;
    , W_INS_RAW AS (
        SELECT ''EE_PRODUCTION_PLAN''                                              AS LOOKUP_TYPE
               ,''SCP''                                                            AS SEGMENT1
               ,CONVERT(NVARCHAR(100),OPERATION_GROUP)                           AS SEGMENT2
               ,CONVERT(NVARCHAR(100),SCM_SITE_ID)                               AS SEGMENT3
               ,CONVERT(NVARCHAR(100),LINE_ID)                                   AS SEGMENT4
               ,CONVERT(NVARCHAR(100),OPERATION_ID)                              AS SEGMENT5
               ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) AS DISPLAY_SEQ
               ,ORIGIN_DIVISION_ID                                               AS ATTRIBUTE1
               ,NULL /*@v_batch_division_id */                                   AS ATTRIBUTE2                           -- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
        FROM W_RPT_RAW WRR
        WHERE NOT EXISTS(SELECT 1
                         FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
                         WHERE  B.LOOKUP_TYPE = ''EE_PRODUCTION_PLAN''
                         AND    B.SEGMENT1    = ''SCP''
                         AND    B.SEGMENT2    = WRR.OPERATION_GROUP
                         AND    B.SEGMENT3    = WRR.SCM_SITE_ID
                         AND    B.SEGMENT4    = WRR.LINE_ID
                         AND    B.SEGMENT5    = WRR.OPERATION_ID
                         )
    )
    SELECT NEXT VALUE FOR [dbo].[SEQ1_SCM_ADM_LOOKUP_MASTER_DETAIL_H]
          ,LOOKUP_TYPE 
          ,SEGMENT1
          ,SEGMENT2
          ,SEGMENT3
          ,SEGMENT4
          ,SEGMENT5
          ,DISPLAY_SEQ
          ,ATTRIBUTE1
          ,ATTRIBUTE2 
          ,''Y''            AS VALID_YN
          ,LOOKUP_TYPE      AS DESCRIPTION
          ,'''+@v_batch_user+N''' AS CREATED_BY
          ,SYSDATETIME()    AS CREATION_DATE
          ,'''+@v_batch_user+N''' AS LAST_UPDATED_BY
          ,SYSDATETIME()    AS LAST_UPDATE_DATE
          ,SYSDATETIME()    AS HISTORY_CREATION_DATE
    FROM   W_INS_RAW
    --ORDER BY 에러나서 막음 NEXT VALUE FOR function cannot be used directly in a statement that contains an ORDER BY clause unless the OVER clause is specified.
    --ORDER BY ATTRIBUTE2, SEGMENT2, SEGMENT3, ATTRIBUTE1, SEGMENT4,SEGMENT5
    ;'+CHAR(12)+CHAR(10);
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
    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL_H
        (HISTORY_SEQ
        ,LOOKUP_TYPE
        ,SEGMENT1
        ,SEGMENT2
        ,SEGMENT3
        ,SEGMENT4
        ,SEGMENT5
        ,DISPLAY_SEQ
        ,ATTRIBUTE1
        ,ATTRIBUTE2     -- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
        ,VALID_YN
        ,DESCRIPTION
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
        ,HISTORY_CREATION_DATE
        )
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT 'Insert into SCM_ADM_LOOKUP_MASTER_DETAIL_H @CountOutput :'+CONVERT(NVARCHAR(MAX),@n_log_count);

    --##################################################
    -- 이제는 SCM_ADM_LOOKUP_MASTER_DETAIL 테이블 작업한다.
    --##################################################
    SET @SQL = N'
    WITH W_SAVE_RAW AS(
        SELECT SNAP_YYYYMMDD
              ,REPORT_TITLE
              ,PLANT_ID
              ,COMPANY_ID
              ,DIVISION_ID
              ,PLAN_TYPE
              ,PLAN_SEQ
              ,MEASURE
              ,SORT_SEQ
              ,YYYYMMDD
              ,QTY
              ,CREATED_BY
              ,CREATION_DATE
              ,LAST_UPDATED_BY
              ,LAST_UPDATE_DATE
              ,ATTRIBUTE1
              ,ATTRIBUTE2
              ,ATTRIBUTE3
              ,ATTRIBUTE4
              ,ATTRIBUTE5
        FROM   SCM_SIM_OPT_EE_UPDATE OEU WITH(NOLOCK)
        WHERE  SNAP_YYYYMMDD = '''+@P_SNAP_YYYYMMDD+N'''
        AND    REPORT_TITLE  = '''+@P_REPORT_TITLE +N'''
        AND    ISNULL(OEU.PLANT_ID   ,'''') = ISNULL('''+@P_PLANT_ID   +N''','''')
        AND    ISNULL(OEU.COMPANY_ID ,'''') = ISNULL('''+@P_COMPANY_ID +N''','''')
        AND    ISNULL(OEU.DIVISION_ID,'''') = ISNULL('''+@P_DIVISION_ID+N''','''')
        AND    PLAN_TYPE     = '''+ @P_PLAN_TYPE     + N'''
        AND    PLAN_SEQ      = '''+ CONVERT(NVARCHAR(MAX),@P_PLAN_SEQ) + N'''
        AND    MEASURE  = '''+@P_MEASURE +N'''
        AND    SORT_SEQ  = '''+ CONVERT(NVARCHAR(MAX),@P_SORT_SEQ) + N'''
        --AND    YYYYMMDD  = '''+@P_YYYYMMDD +N'''
        AND    OEU.YYYYMMDD IN ('+ DBO.FN_GET_NERP_IN_VALUES(@SELCOL) +N')
    )
    , W_RPT_RAW AS (
        SELECT DISTINCT
               SDC.C1 AS DIVISION_ID
              --,SDC.C2 AS PLAN_START_YYYYMMDD
              --,SDC.C3 AS PLAN_TYPE
              --,SDC.C4 AS SEQ
              ,SDC.C372 AS OPERATION_GROUP
              ,SDC.C5 AS SCM_SITE_ID
              --,SDC.C8 AS ITEM_ID
              ,SDC.C12 AS LINE_ID
              ,SDC.C373 AS OPERATION_ID
              --,SDC.C14 AS MEASURE
              --,WSR.YYYYMMDD
              --,WSR.QTY
              --CELL 수량을 전극수량으로 환산
              --2025-12-18 김준규 CELL 수량을 전극수량으로한 것은 업데이트용 테이블에 이미 환산되어 있다
              --,ISNULL(WSR.qty,0.00) AS QTY
              ,SDC.C371 AS ORIGIN_DIVISION_ID
              --,SDC.C9 AS ELECTRODE_TYPE
              --,WSR.CREATED_BY
              --,WSR.CREATION_DATE
              --,WSR.LAST_UPDATED_BY
              --,WSR.LAST_UPDATE_DATE
              --,WSR.ATTRIBUTE1
              --,WSR.ATTRIBUTE2
              --,WSR.ATTRIBUTE3
              --,WSR.ATTRIBUTE4
              --,WSR.ATTRIBUTE5
        FROM   SCM_SIM_DYN_COLS SDC WITH(NOLOCK)
        JOIN   W_SAVE_RAW AS WSR
        ON     WSR.SNAP_YYYYMMDD = SDC.SNAP_YYYYMMDD
        AND    WSR.REPORT_TITLE  = SDC.REPORT_TITLE
        AND    WSR.PLANT_ID      = SDC.PLANT_ID
        AND    WSR.COMPANY_ID    = SDC.COMPANY_ID
        AND    WSR.DIVISION_ID   = SDC.DIVISION_ID
        AND    WSR.PLAN_TYPE     = SDC.C3
        AND    WSR.PLAN_SEQ      = SDC.C4
        AND    WSR.MEASURE       = '''+@P_MEASURE +N'''
        AND    WSR.SORT_SEQ      = SDC.SORT_SEQ1
    )
    --SELECT * FROM W_RPT_RAW;
    , W_INS_RAW AS (
        SELECT ''EE_PRODUCTION_PLAN''                                              AS LOOKUP_TYPE
               ,''SCP''                                                            AS SEGMENT1
               ,CONVERT(NVARCHAR(100),OPERATION_GROUP)                           AS SEGMENT2
               ,CONVERT(NVARCHAR(100),SCM_SITE_ID)                               AS SEGMENT3
               ,CONVERT(NVARCHAR(100),LINE_ID)                                   AS SEGMENT4
               ,CONVERT(NVARCHAR(100),OPERATION_ID)                              AS SEGMENT5
               ,ROW_NUMBER() OVER(PARTITION BY DIVISION_ID ORDER BY DIVISION_ID) AS DISPLAY_SEQ
               ,ORIGIN_DIVISION_ID                                               AS ATTRIBUTE1
               ,NULL /*@v_batch_division_id */                                   AS ATTRIBUTE2                           -- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
        FROM W_RPT_RAW WRR
        WHERE NOT EXISTS(SELECT 1
                         FROM   SCM_ADM_LOOKUP_MASTER_DETAIL B WITH (NOLOCK)
                         WHERE  B.LOOKUP_TYPE = ''EE_PRODUCTION_PLAN''
                         AND    B.SEGMENT1    = ''SCP''
                         AND    B.SEGMENT2    = WRR.OPERATION_GROUP
                         AND    B.SEGMENT3    = WRR.SCM_SITE_ID
                         AND    B.SEGMENT4    = WRR.LINE_ID
                         AND    B.SEGMENT5    = WRR.OPERATION_ID
                         )
    )
    SELECT LOOKUP_TYPE 
          ,SEGMENT1
          ,SEGMENT2
          ,SEGMENT3
          ,SEGMENT4
          ,SEGMENT5
          ,DISPLAY_SEQ
          ,ATTRIBUTE1
          ,ATTRIBUTE2 
          ,''Y''            AS VALID_YN
          ,LOOKUP_TYPE      AS DESCRIPTION
          ,'''+@v_batch_user+N''' AS CREATED_BY
          ,SYSDATETIME()    AS CREATION_DATE
          ,'''+@v_batch_user+N''' AS LAST_UPDATED_BY
          ,SYSDATETIME()    AS LAST_UPDATE_DATE
    FROM   W_INS_RAW
    ORDER BY ATTRIBUTE2, SEGMENT2, SEGMENT3, ATTRIBUTE1, SEGMENT4,SEGMENT5;'+CHAR(12)+CHAR(10);
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
    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
        (LOOKUP_TYPE
        ,SEGMENT1
        ,SEGMENT2
        ,SEGMENT3
        ,SEGMENT4
        ,SEGMENT5
        ,DISPLAY_SEQ
        ,ATTRIBUTE1
        ,ATTRIBUTE2     -- 2022.09.22 KSW PR_SCP_ANL_UI_EE_SEARCH_DATA_CREATE 오류발지를 위한 처리추가
        ,VALID_YN
        ,DESCRIPTION
        ,CREATED_BY
        ,CREATION_DATE
        ,LAST_UPDATED_BY
        ,LAST_UPDATE_DATE
    )
    EXEC sp_executesql
        @sql,
        N'@CountOutput INT OUTPUT',  -- 파라미터 정의
        @CountOutput = @n_log_count OUTPUT;
    PRINT 'Insert into SCM_ADM_LOOKUP_MASTER_DETAIL @CountOutput :'+CONVERT(NVARCHAR(MAX),@n_log_count);

    -------------------------------------------------------------------------------------------------------------
    -- PROD_PLAN_AMEND  저장시 SCM_ADM_LOOKUP_MASTER_DETAIL.LOOKUP_TYPE='EE_PRODUCTION_PLAN' 저장로직 추가 BEGIN
    -------------------------------------------------------------------------------------------------------------

    --종료 LOG (START)
    SET @v_log_type = 'END';
    SET @v_log_message = '##### END of procedure #####';
    SET @v_description = '@P_SNAP_YYYYMMDD:'+@P_SNAP_YYYYMMDD+',@P_REPORT_TITLE:'+@P_REPORT_TITLE+',@P_PLANT_ID:'+@P_PLANT_ID+',@P_COMPANY_ID:'+@P_COMPANY_ID+',@P_DIVISION_ID:'+@P_DIVISION_ID+',@P_DAY_COUNT:'+CONVERT(NVARCHAR(MAX),@P_DAY_COUNT);
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    COMMIT TRANSACTION

    SET @X_STATUS = 0
    SET @X_MSG = 'Update completed successfully'
    RETURN 0

END TRY
BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION

        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        --END 실시간 화면 처리이기 때문에 실제 ERROR이더라도 END 종료 되도록 변경함.
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
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

