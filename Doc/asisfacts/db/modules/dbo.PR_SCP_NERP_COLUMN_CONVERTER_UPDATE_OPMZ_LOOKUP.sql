
-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_OPMZ_LOOKUP
-- Author:       김준규
-- Create date:  2025-08-27
-- Description:  NERP) 최적화 Master Lookup 관련 코드 생성
-- ==========================================================================================
/*
-- 20250831     김준규       NERP) 신규 생성
-- 20250912     김준규       NERP) REPLACE처리 보완
-- 20250926     김준규       NERP) 김춘동 책임님 요청으로 최적화는 모든 VALID_YN 무시하고 모두 작업
*/
-- ==========================================================================================
/*
    EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_OPMZ_LOOKUP @P_LOOKUP_TYPE ='SCP_OPT_MASTER_CAPA_TEMP',@P_ROLLIN = '3RD';    
    EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_OPMZ_LOOKUP @P_LOOKUP_TYPE ='SCP_OPT_ENG_CONST_BOD_BLOCKING',@P_ROLLIN = '3RD';
--------------------------------------------------------------------
    select dev_detail, status, MAPPING_START, MAPPING_END, MAPPING_TIME, mapping_column
    from ZNERP_DEV_ITEM_SCHEDULE
    where  dev_type = 'Batch_LOOKUP'
    and mapping_use = 'Y'
    --  and ISNULL(status,'') != 'FINISH'
    order by program_id,  dev_detail


*/
-- =============================================
CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_OPMZ_LOOKUP]

 @P_LOOKUP_TYPE nvarchar(100)
,@P_ROLLIN      nvarchar(30) --1ST 2ND 3RD 4TH

AS
BEGIN

    SET NOCOUNT ON

    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

--################################################################################################################
--DECLARE
--################################################################################################################
DECLARE @TABLE_NAME NVARCHAR(400);
DECLARE @LOOKUP_TYPE NVARCHAR(400);
DECLARE @SOURCE_COLUMN NVARCHAR(400);
DECLARE @MAPPING_COLUMN NVARCHAR(400);
DECLARE @MAPPING_USE NVARCHAR(400);
DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;

DECLARE @CNT BIGINT;
DECLARE @WORK_SECOND BIGINT;
DECLARE @MAPPING_RESULT NVARCHAR(2);
DECLARE @BATCH_RUN_TIME BIGINT;
DECLARE @BATCH_START_TIME DATETIME;
DECLARE @BATCH_END_TIME DATETIME;
DECLARE @RUN_TIME BIGINT;
DECLARE @START_TIME DATETIME;
DECLARE @END_TIME DATETIME;
DECLARE @DUMMY NVARCHAR(MAX);

SET @CNT = 0;
SET @RUN_TIME = 0;
SET @MAPPING_COLUMN = '';

DECLARE @C_MAPPING_USE NVARCHAR(2);
DECLARE @C_TABLE_NAME  NVARCHAR(128);
DECLARE @C_DUMMY_TBL_NM NVARCHAR(128);
DECLARE @C_DISP_TBL_NM NVARCHAR(128);
DECLARE @C_COPYED_TBL_NM NVARCHAR(128) = '';
DECLARE @C_PRINT_YN    BIT = 0; -- 1 Y, 0 N
DECLARE @C_RTYPE       NVARCHAR(128);
DECLARE @V2            BIT = 0; -- 1 Y, 0 N
DECLARE @C_RNUM        NVARCHAR(128);
DECLARE @C_SORT_SEQ    INT;
DECLARE @C_LOOKUP_TYPE NVARCHAR(128);
DECLARE @C_CODE_LOOKUP_TYPE NVARCHAR(128);
DECLARE @C_DUMMY_LK_TYPE NVARCHAR(128);
DECLARE @C_CAL_LIKE    NVARCHAR(128);
DECLARE @C_R_N_R       NVARCHAR(128);
DECLARE @C_CUTOFF_COL  NVARCHAR(128);
DECLARE @C_CUT_COL1    NVARCHAR(128);
DECLARE @C_CUT_COL2    NVARCHAR(128);
DECLARE @C_CUT_COL3    NVARCHAR(128);
DECLARE @C_CUT_COL4    NVARCHAR(128);
DECLARE @C_C_FROM      NVARCHAR(128);
DECLARE @C_C_TO        NVARCHAR(128);
DECLARE @C_C_DIVISION  NVARCHAR(128);
DECLARE @C_C_PLAN_TYPE NVARCHAR(128);
DECLARE @C_L1          NVARCHAR(128);--BEFORE
DECLARE @C_L2          NVARCHAR(128);
DECLARE @C_L3          NVARCHAR(128);
DECLARE @C_L4          NVARCHAR(128);
DECLARE @C_L5          NVARCHAR(128);
DECLARE @C_L6          NVARCHAR(128);
DECLARE @C_L7          NVARCHAR(128);
DECLARE @C_L8          NVARCHAR(128);
DECLARE @C_L9          NVARCHAR(128);
DECLARE @C_L10         NVARCHAR(128);
DECLARE @C_L11         NVARCHAR(128);
DECLARE @C_L12         NVARCHAR(128);
DECLARE @C_B1          NVARCHAR(128);--BEFORE
DECLARE @C_B2          NVARCHAR(128);
DECLARE @C_B3          NVARCHAR(128);
DECLARE @C_B4          NVARCHAR(128);
DECLARE @C_B5          NVARCHAR(128);
DECLARE @C_B6          NVARCHAR(128);
DECLARE @C_B7          NVARCHAR(128);
DECLARE @C_B8          NVARCHAR(128);
DECLARE @C_B9          NVARCHAR(128);
DECLARE @C_B10         NVARCHAR(128);
DECLARE @C_B11         NVARCHAR(128);
DECLARE @C_B12         NVARCHAR(128);
DECLARE @C_SEL_B1      NVARCHAR(128);--BEFORE
DECLARE @C_SEL_B2      NVARCHAR(128);
DECLARE @C_SEL_B3      NVARCHAR(128);
DECLARE @C_SEL_B4      NVARCHAR(128);
DECLARE @C_SEL_B5      NVARCHAR(128);
DECLARE @C_SEL_B6      NVARCHAR(128);
DECLARE @C_SEL_B7      NVARCHAR(128);
DECLARE @C_SEL_B8      NVARCHAR(128);
DECLARE @C_SEL_B9      NVARCHAR(128);
DECLARE @C_SEL_B10     NVARCHAR(128);
DECLARE @C_SEL_B11     NVARCHAR(128);
DECLARE @C_SEL_B12     NVARCHAR(128);
DECLARE @C_A1          NVARCHAR(128);--AFTER
DECLARE @C_A2          NVARCHAR(128);
DECLARE @C_A3          NVARCHAR(128);
DECLARE @C_A4          NVARCHAR(128);
DECLARE @C_A5          NVARCHAR(128);
DECLARE @C_A6          NVARCHAR(128);
DECLARE @C_A7          NVARCHAR(128);
DECLARE @C_A8          NVARCHAR(128);
DECLARE @C_A9          NVARCHAR(128);
DECLARE @C_A10         NVARCHAR(128);
DECLARE @C_A11         NVARCHAR(128);
DECLARE @C_A12         NVARCHAR(128);
DECLARE @C_V1          INT;--AFTER
DECLARE @C_V2          INT;
DECLARE @C_V3          INT;
DECLARE @C_V4          INT;
DECLARE @C_V5          INT;
DECLARE @C_V6          INT;
DECLARE @C_V7          INT;
DECLARE @C_V8          INT;
DECLARE @C_V9          INT;
DECLARE @C_V10         INT;
DECLARE @C_V11         INT;
DECLARE @C_V12         INT;
DECLARE @C_SEL_A1      NVARCHAR(128);--AFTER
DECLARE @C_SEL_A2      NVARCHAR(128);
DECLARE @C_SEL_A3      NVARCHAR(128);
DECLARE @C_SEL_A4      NVARCHAR(128);
DECLARE @C_SEL_A5      NVARCHAR(128);
DECLARE @C_SEL_A6      NVARCHAR(128);
DECLARE @C_SEL_A7      NVARCHAR(128);
DECLARE @C_SEL_A8      NVARCHAR(128);
DECLARE @C_SEL_A9      NVARCHAR(128);
DECLARE @C_SEL_A10     NVARCHAR(128);
DECLARE @C_SEL_A11     NVARCHAR(128);
DECLARE @C_SEL_A12     NVARCHAR(128);
DECLARE @C_X1          BIT;--AFTER
DECLARE @C_X2          BIT;
DECLARE @C_X3          BIT;
DECLARE @C_X4          BIT;
DECLARE @C_X5          BIT;
DECLARE @C_X6          BIT;
DECLARE @C_X7          BIT;
DECLARE @C_X8          BIT;
DECLARE @C_X9          BIT;
DECLARE @C_X10         BIT;
DECLARE @C_X11         BIT;
DECLARE @C_X12         BIT;
DECLARE @C_RN          INT;
DECLARE @SQL_STMT      NVARCHAR(MAX);
DECLARE @SQL_SA        NVARCHAR(MAX)='';
DECLARE @SQL_SM        NVARCHAR(MAX)='';
DECLARE @SQL_SW        NVARCHAR(MAX)='';
DECLARE @SQL_ISNOTNULL NVARCHAR(MAX)='';
DECLARE @ExecutionRST  NVARCHAR(MAX);
--DECLARE @DUMMY         NVARCHAR(MAX);
DECLARE @crlf          CHAR(2) = CHAR(13) + CHAR(10);
DECLARE @pos           INT;
DECLARE @C_CUTOFF_COLUMN NVARCHAR(128);
DECLARE @C_DATE_TYPE_YN NVARCHAR(1);
DECLARE @V_CUTOFF_COLUMN NVARCHAR(MAX)='';
DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN=@P_ROLLIN ORDER BY RTYPE_NUM DESC);
DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN=@P_ROLLIN ORDER BY RTYPE_NUM DESC);


--###########################################################################################################
-- LOG 용 변수 설정
--###########################################################################################################
DECLARE @v_batch_user NVARCHAR(150) = 'NERP_SCP_BATCH';
DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_OPMZ_LOOKUP';
DECLARE @v_log_type     NVARCHAR(30) = 'LOOKUP';
DECLARE @n_log_count    INTEGER = 0;
DECLARE @v_log_message  NVARCHAR(1000);
DECLARE @v_description  NVARCHAR(max);
DECLARE @d_event_date   DATETIME;
DECLARE @v_ifseqno      NVARCHAR(30);
DECLARE @n_history_seq  BIGINT;


BEGIN TRY

        --###############################################################################################
        -- START
        --###############################################################################################
        -- 시작 LOG
        SET @v_log_type = 'START';
        SET @v_log_message = '########## Start of procedure ##########';
        SET @v_description = '@P_LOOKUP_TYPE:'+@P_LOOKUP_TYPE+',@P_ROLLIN:'+@P_ROLLIN+',TABLE : SCP_OPMZ_LOOKUP_MASTER_DETAIL';
        SET @d_event_date = SYSDATETIME();
        SET @BATCH_START_TIME = SYSDATETIME();
        SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;


        --------------------------------------------------
        --STEP 0. TARGET TABLE BACKUP
        --------------------------------------------------
        BEGIN
            IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BACKUP_SCP_OPMZ_LOOKUP_MASTER_DETAIL]') AND type in (N'U'))
            BEGIN
                DROP TABLE [dbo].[BACKUP_SCP_OPMZ_LOOKUP_MASTER_DETAIL];
            END

            SELECT *
            INTO [dbo].[BACKUP_SCP_OPMZ_LOOKUP_MASTER_DETAIL]
            FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL;
        END

        --LOOKUP은 NERP 신규코드를 추가한다.
        --그리고 나서 구코드는 DESC에 구)코드라고 표시한다.(수작업?)


        --################################################################
        -- 작업 초기화
        --################################################################
        IF OBJECT_ID('tempdb..#TMP_COMPANY') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_COMPANY
        END

        IF OBJECT_ID('tempdb..#TMP_PLANT') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_PLANT
        END


        IF OBJECT_ID('tempdb..#TMP_VENDOR') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_VENDOR
        END


        IF OBJECT_ID('tempdb..#TMP_CUSTOMER') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_CUSTOMER
        END

        IF OBJECT_ID('tempdb..#TMP_SCM_SITE_ID') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_SCM_SITE_ID
        END

        IF OBJECT_ID('tempdb..#TMP_STORAGE') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_STORAGE
        END

        IF OBJECT_ID('tempdb..#TMP_STORAGE_RANK') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_STORAGE_RANK
        END


        --#################################################################################
        -- TEMP MAPPING TABLE
        --#################################################################################
        -- 3
        SELECT OLD_VALUE1 AS ASIS_COMPANY, NEW_VALUE1 AS TOBE_COMPANY
        INTO #TMP_COMPANY
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'COMPANY_ID'
        AND ATTRIBUTE5 = @P_ROLLIN


        ----------------------------------------------------------------------
        -- 17
        SELECT OLD_VALUE1 AS ASIS_PLANT, NEW_VALUE1 AS TOBE_PLANT
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
        INTO #TMP_PLANT
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'PLANT_ID'
        AND ATTRIBUTE5 = @P_ROLLIN

        ----------------------------------------------------------------------
        -- 53599
        SELECT OLD_VALUE1 AS ASIS_VENDOR
             , NEW_VALUE1 AS TOBE_VENDOR
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
        INTO #TMP_VENDOR
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'VENDOR_ID'
        AND ATTRIBUTE5 = @P_ROLLIN



        ----------------------------------------------------------------------
        -- 17873  37873
        SELECT OLD_VALUE1 AS ASIS_CUSTOMER
             , NEW_VALUE1 AS TOBE_CUSTOMER
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
        INTO #TMP_CUSTOMER
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'END_CUSTOMER_ID'
        AND ATTRIBUTE5 = @P_ROLLIN
        --AND ROLL02 = ''
        --AND NEW_VALUE1 != N'삭제'


        ----------------------------------------------------------------------
     --  SELECT OLD_VALUE1
        --    , OLD_VALUE_BODY  AS ASIS_VALUE_BODY
        --    , NEW_VALUE1      AS TOBE_SCM_SITE_ID
        --INTO #TMP_SCM_SITE_ID
        -- FROM NERP_CONV_SCP_SCM_SITE_ID
     --   WHERE MAPPING_COLUMN = 'SCM_SITE_ID'
        --AND MAPPING_USE = 'Y'

        --select OLD_VALUE2 AS ASIS_SITE
        --      ,OLD_VALUE1 AS ASIS_SITE_BODY
        --      ,NEW_VALUE1 AS TOBE_SITE
        --from NERP_CONV_MASTER_CFM_V
        --where codetype = 'SITE_ID'
        --and ATTRIBUTE5 = @P_ROLLIN


        -- 103
        select OLD_VALUE1 AS ASIS_SCM_SITE_ID
              ,OLD_VALUE2 AS ASIS_SCM_SITE_ID_BODY
              ,NEW_VALUE1 AS TOBE_SCM_SITE_ID
        INTO #TMP_SCM_SITE_ID
        from NERP_CONV_MASTER_CFM_V
        where codetype = 'SCP_SITE_ID'
        and ATTRIBUTE5 = @P_ROLLIN


        ----------------------------------------------------------------------
        -- 627
        SELECT OLD_VALUE1 AS ASIS_PLANT
             , OLD_VALUE2 AS ASIS_STORAGE
             , NEW_VALUE1 AS TOBE_PLANT
             , NEW_VALUE2 AS TOBE_STORAGE
             , DESC1 AS DESC01
             , DESC2 AS DESC02
             , DESC3 AS DESC03
             , COMMENT1 AS ETC1
             , COMMENT2 AS ETC2
        INTO #TMP_STORAGE
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'STORAGE_ID'
        AND ELEMENT1 = 'WERKS_D'
        AND ELEMENT2 = 'LGORT_D'
        AND ATTRIBUTE5 = @P_ROLLIN
        AND NEW_VALUE2 != ''
        AND NEW_VALUE2 != N'삭제'


        ----------------------------------------------------------------------
        -- 627
        SELECT ASIS_PLANT, ASIS_STORAGE
             , TOBE_PLANT, TOBE_STORAGE
             , DESC01, DESC02, DESC03
             , ETC1, ETC2
             , RANK () OVER (PARTITION BY TOBE_PLANT, TOBE_STORAGE  ORDER BY ASIS_PLANT, ASIS_STORAGE ) AS RANK_STORAGE
        INTO #TMP_STORAGE_RANK
        FROM #TMP_STORAGE


        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END


        --################################################################
        -- CURSOR_MAPPING
        --################################################################
        DECLARE CURSOR_MAPPING CURSOR FOR

        select DISTINCT 'SCP_OPMZ_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
             --, program_id AS TABLE_NAME
             --, dev_detail AS LOOKUP_TYPE
             , program_id AS LOOKUP_TYPE
          from ZNERP_DEV_ITEM_SCHEDULE
         where  dev_type in ( 'Batch_OPMZ_LOOKUP')
           and mapping_use = 'OM'
           --and ISNULL(status,'') != 'FINISH'
           --and dev_remark IN ('SCP', 'COMMON')
           and dev_detail != 'INCOTERMS' --> DM에서 조치 협의
           and (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR program_id = @P_LOOKUP_TYPE)
         order by program_id


        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END

        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @C_TABLE_NAME, @C_LOOKUP_TYPE

        WHILE @@FETCH_STATUS = 0
        BEGIN

            PRINT '------------------------------------------------------------------------------------------------------------------------------------------';
            SET @P_LOOKUP_TYPE = @C_LOOKUP_TYPE;
            SET @C_DISP_TBL_NM = @C_LOOKUP_TYPE;
            SET @C_RTYPE = 'OPMZ_LOOKUP';
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @C_LOOKUP_TYPE, 0, '0', '', @START_TIME;
            SET @v_description = 'START->'+concat(
            '@CNT = ' , @CNT
            , ' , @C_LOOKUP_TYPE = ', @C_LOOKUP_TYPE
            , ' , @START_TIME = ' , @START_TIME
            );

            PRINT @v_description


            SET @MAPPING_USE = 'N';

        DECLARE @TableName              NVARCHAR(128) = @C_TABLE_NAME;   -- 대상 테이블
        DECLARE @UpdateColumnNamesString NVARCHAR(MAX) = N'C,B,D,A';        -- ★ 콤마 구분 컬럼 목록
        SELECT @UpdateColumnNamesString = STRING_AGG(SEL_COL,',')
        FROM (
            SELECT SEL_COL
            FROM (
               SELECT DISTINCT PROGRAM_ID AS LOOKUP_TYPE
                   , DEV_DETAIL   AS SEL_COL
               FROM ZNERP_DEV_ITEM_SCHEDULE AS TID WITH (NOLOCK)
               where 1=1
               --and CONVERSION_FLAG <> '-'
               AND PROGRAM_ID = @C_LOOKUP_TYPE
               AND DEV_TYPE in ( 'Batch_OPMZ_LOOKUP') and mapping_use = 'OM'
            ) X
            GROUP BY SEL_COL
        ) X
        ORDER BY 1;

        DECLARE @JoinCondition     NVARCHAR(MAX) = N'';
        DECLARE @UpdateSetClause   NVARCHAR(MAX) = N'';
        DECLARE @WRawSelectColumns NVARCHAR(MAX) = N'';
        DECLARE @RowCount          INT = 0;

        DECLARE @UpdateCols TABLE (ColumnName NVARCHAR(128) PRIMARY KEY,RPL_COL BIT DEFAULT 0, Sequence INT);
        DECLARE @AllCols    TABLE (ColumnName NVARCHAR(128), IsPrimaryKey BIT, ColumnId INT, max_length SMALLINT);
        --초기화;
        DELETE 
        FROM @UpdateCols;
        DELETE 
        FROM @AllCols;

        -----------------------------------------------------------------------
        -- 2. 입력 문자열 → @UpdateCols (순서 보존)
        -----------------------------------------------------------------------
        DECLARE @SplitXML XML =
            CAST('<x>' + REPLACE(@UpdateColumnNamesString, ',', '</x><x>') + '</x>' AS XML);

        ;WITH cte AS (
            SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))               AS Sequence,
                   LTRIM(RTRIM(v.value('.', 'nvarchar(128)')))           AS ColumnName
            FROM   @SplitXML.nodes('/x') AS t(v)
        )
        , W_RPL AS (
              SELECT DISTINCT PROGRAM_ID AS LOOKUP_TYPE
                   , DEV_DETAIL   AS SEL_COL
                   , IIF(TID.MAPPING_COMMENT LIKE '%REP%' OR TID.MAPPING_COMMENT LIKE '%RPL%',1,0) AS RPL_COL
               FROM ZNERP_DEV_ITEM_SCHEDULE AS TID WITH (NOLOCK)
               where 1=1
               --and CONVERSION_FLAG <> '-'
               AND PROGRAM_ID = @C_LOOKUP_TYPE
               AND DEV_TYPE in ( 'Batch_OPMZ_LOOKUP') and mapping_use = 'OM'
        )
        
        INSERT INTO @UpdateCols (ColumnName, RPL_COL, Sequence)
        SELECT ColumnName,RPL_COL,Sequence
        FROM   cte
        JOIN   W_RPL AS WR ON cte.ColumnName = WR.SEL_COL;

        INSERT INTO @AllCols (ColumnName, IsPrimaryKey, ColumnId, max_length)
        SELECT
            DISTINCT c.name,
            CASE WHEN i.is_primary_key = 1 AND ic.column_id IS NOT NULL THEN 1 ELSE 0 END,
            c.column_id,
            c.max_length
        FROM sys.columns        AS c
        LEFT JOIN sys.index_columns AS ic ON c.object_id = ic.object_id AND c.column_id = ic.column_id
        LEFT JOIN sys.indexes       AS i  ON ic.object_id = i.object_id AND ic.index_id  = i.index_id
        WHERE c.object_id = OBJECT_ID(@TableName)
        ORDER BY c.column_id;

        DECLARE @Counter INT = 1, @CurCol NVARCHAR(128);
        WHILE EXISTS (SELECT 1 FROM @UpdateCols WHERE Sequence = @Counter)
        BEGIN
            SELECT @CurCol = ColumnName FROM @UpdateCols WHERE Sequence = @Counter;

            SET @UpdateSetClause   += N'A.' + QUOTENAME(@CurCol) +
                                      N' = ISNULL(WR.A' + CONVERT(VARCHAR(10),@Counter) +
                                      N', A.' + QUOTENAME(@CurCol) + N'), ';
            SET @Counter += 1;
        END
        SET @UpdateSetClause   = LEFT(@UpdateSetClause,   LEN(@UpdateSetClause)-1);

        SET @UpdateSetClause += ', ' + 'A.LAST_UPDATE_DATE' + ' = GETDATE()';
        SET @UpdateSetClause += ', ' + 'A.LAST_UPDATED_BY' + ' = '''+ @CREATED_BY +'''';

        DECLARE @ColumnsToSelect NVARCHAR(MAX)='';
        DECLARE @ColumnsToSelect_ORIG NVARCHAR(MAX)='';
        DECLARE @ColumnsToSelect_UPD NVARCHAR(MAX)='';
        DECLARE @ColumnsToSelect_OLD NVARCHAR(MAX)='';
        DECLARE @PrimaryKeyCols    TABLE (ColumnName NVARCHAR(128) PRIMARY KEY, Sequence INT);

        -- 2. PK 컬럼
        --기존 데이터 삭제.
        DELETE FROM @PrimaryKeyCols;
        --데이터 입력.
        INSERT INTO @PrimaryKeyCols(ColumnName,Sequence)
        SELECT c.name,ic.key_ordinal
        FROM sys.tables t
        INNER JOIN sys.indexes i ON t.object_id = i.object_id
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.is_primary_key = 1
        AND t.name = @TableName
        AND SCHEMA_NAME(t.schema_id) = 'dbo';

        DECLARE @CompositeCols NVARCHAR(MAX) ='';
        SET @CompositeCols = 
            (SELECT STRING_AGG(QUOTENAME(a.ColumnName), ', ') WITHIN GROUP (ORDER BY Sequence) FROM @PrimaryKeyCols a JOIN @AllCols b ON a.ColumnName = b.ColumnName WHERE b.max_length <> -1 );

        --2025-09-03 모든 컬럼으로 변경, merge 문장때문
        --SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(ColumnName), ', ') WITHIN GROUP (ORDER BY Sequence)
        --FROM @PrimaryKeyCols;
        --SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(ColumnName), ', ') WITHIN GROUP (ORDER BY ColumnId)
        --FROM @AllCols;
        --SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(UC.ColumnName), ', ') WITHIN GROUP (ORDER BY UC.ColumnId)
        --FROM @AllCols AS AC
        --LEFT JOIN @UpdateCols AS UC ON UC.ColumnName = AC.ColumnName;
        --2025-09-12 REPLACE 반영.  --> REPLACE(A.SEGMENT1,B1.OLD_VALUE1, B1.NEW_VALUE1) AS A1
        --변경전 ISNULL(B1.NEW_VALUE1, A.[SEGMENT1]) AS SEGMENT1
        --변경후 ISNULL(REPLACE(A.SEGMENT1,B1.OLD_VALUE1, B1.NEW_VALUE1), A.[SEGMENT1]) AS SEGMENT1
        --'ISNULL('+'B'+TRY_CONVERT(NVARCHAR(3),UC.Sequence)+'.NEW_VALUE1, A.' + QUOTENAME(AC.ColumnName)+') AS '+UC.ColumnName
        --'ISNULL(REPLACE(A.'+QUOTENAME(AC.ColumnName)+', B'+TRY_CONVERT(NVARCHAR(3),UC.Sequence)+'.OLD_VALUE1, A.'+', B'+TRY_CONVERT(NVARCHAR(3),UC.Sequence)+'.NEW_VALUE1), A.' + QUOTENAME(AC.ColumnName)+') AS '+UC.ColumnName

                  --,A.[LOOKUP_TYPE], ISNULL(REPLACE(A.[SEGMENT1], B1.OLD_VALUE1, A., B1.NEW_VALUE1), A.[SEGMENT1]) AS SEGMENT1, A.[SEGMENT2], A.[SEGMENT3], ISNULL(REPLACE(A.[SEGMENT4], B2.OLD_VALUE1, A., B2.NEW_VALUE1), A.[SEGMENT4]) AS SEGMENT4, A.[SEGMENT5], A.[SEGMENT6], A.[SEGMENT7], A.[SEGMENT8], A.[SEGMENT9], A.[SEGMENT10], A.[DISPLAY_SEQ], A.[VALID_YN], A.[DESCRIPTION], A.[CREATED_BY], A.[CREATION_DATE], A.[LAST_UPDATED_BY], A.[LAST_UPDATE_DATE], A.[ATTRIBUTE1], A.[ATTRIBUTE2], A.[ATTRIBUTE3], A.[ATTRIBUTE4], A.[ATTRIBUTE5], A.[ATTRIBUTE6], A.[ATTRIBUTE7], A.[ATTRIBUTE8], A.[ATTRIBUTE9], A.[ATTRIBUTE10], A.[ATTRIBUTE11], A.[ATTRIBUTE12], A.[ATTRIBUTE13], A.[ATTRIBUTE14], A.[ATTRIBUTE15]

        SELECT @ColumnsToSelect = STRING_AGG((CASE WHEN UC.ColumnName IS NOT NULL THEN (CASE WHEN UC.RPL_COL = 1 THEN 'ISNULL(REPLACE(A.'+QUOTENAME(AC.ColumnName)+', B'+TRY_CONVERT(NVARCHAR(3),UC.Sequence)+'.OLD_VALUE1, B'+TRY_CONVERT(NVARCHAR(3),UC.Sequence)+'.NEW_VALUE1), A.' + QUOTENAME(AC.ColumnName)+') AS '+UC.ColumnName ELSE 'ISNULL('+'B'+TRY_CONVERT(NVARCHAR(3),UC.Sequence)+'.NEW_VALUE1, A.' + QUOTENAME(AC.ColumnName)+') AS '+UC.ColumnName END) ELSE 'A.' + QUOTENAME(AC.ColumnName) END), ', ') WITHIN GROUP (ORDER BY AC.ColumnId)
        FROM @AllCols AS AC
        LEFT JOIN @UpdateCols AS UC ON UC.ColumnName = AC.ColumnName;

        SELECT @ColumnsToSelect_ORIG = STRING_AGG('A.' + QUOTENAME(ColumnName), ', ') WITHIN GROUP (ORDER BY ColumnId)
        FROM @AllCols;
        
        SELECT @ColumnsToSelect_UPD = STRING_AGG( CASE WHEN ColumnName = 'LAST_UPDATED_BY'  THEN ''''+@CREATED_BY+''''
                                                       WHEN ColumnName = 'LAST_UPDATE_DATE' THEN 'GETDATE()'
                                                      ELSE 'A.' + QUOTENAME(ColumnName) END , ', ') WITHIN GROUP (ORDER BY ColumnId) 
        FROM @AllCols;

        SELECT @ColumnsToSelect_OLD = STRING_AGG('A.' + QUOTENAME(ColumnName)+' AS OLD_'+ColumnName, ', ') WITHIN GROUP (ORDER BY Sequence)
        FROM @PrimaryKeyCols;

        --@UpdateCols

        --DECLARE @JoinCondition     NVARCHAR(MAX) = N'';
        IF (SELECT count(*) FROM @PrimaryKeyCols ) > 0
        BEGIN
            SELECT @JoinCondition =
                   STRING_AGG(N'A.' + QUOTENAME(ColumnName) + N' = WR.' + QUOTENAME(ColumnName), N' AND ') WITHIN GROUP (ORDER  BY Sequence)
            FROM   @PrimaryKeyCols;
        END;

        --PRINT '@ColumnsToSelect:'+@ColumnsToSelect;

        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'cur') >= 0
        BEGIN
            CLOSE cur;
            DEALLOCATE cur;
        END;
        DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
            WITH W_CONV_CODETYPE AS (
                SELECT TRIM('SITE_ID             ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('SCM_SITE_ID         ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('PSI_VALUE           ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('PACKER_CODE         ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('WERKS_D             ') AS FR, TRIM('PLANT_ID            ') AS TOO UNION
                SELECT TRIM('LGORT_D             ') AS FR, TRIM('STORAGE_ID          ') AS TOO UNION
                SELECT TRIM('LIFNR               ') AS FR, TRIM('VENDOR_ID           ') AS TOO UNION
                SELECT TRIM('KUNNR               ') AS FR, TRIM('END_CUSTOMER_ID     ') AS TOO UNION
                SELECT TRIM('CUSTOMER            ') AS FR, TRIM('END_CUSTOMER_ID     ') AS TOO UNION
                SELECT TRIM('STORAGE_NAME        ') AS FR, TRIM('STORAGE_ID          ') AS TOO UNION
                SELECT TRIM('SCM_SITE_DESCRIPTION') AS FR, TRIM('SCP_SITE_DESCRIPTION') AS TOO UNION
                SELECT TRIM('PLANT_DESCRIPTION   ') AS FR, TRIM('SCP_SITE_DESCRIPTION') AS TOO
            )
            , W_RAW AS (
                SELECT TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , STRING_AGG(MAP_COL, ', ') WITHIN GROUP (ORDER BY SEL_COL ASC) AS MAP_COL
                     , CAL_LIKE --LIKE 연산자 --2025-08-31 김준규 실제는 사용하지 않음
                     , ROW_NUMBER()OVER(PARTITION BY TABLE_NAME,LOOKUP_TYPE ORDER BY TABLE_NAME, SEL_COL) RNUM
                FROM (
                    SELECT
                        'SCP_OPMZ_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
                       , LID.PROGRAM_ID AS LOOKUP_TYPE
                       , LID.DEV_DETAIL AS SEL_COL
                       --대체이름 설정
                       , ISNULL(WCO.TOO,LID.MAPPING_COLUMN) AS MAP_COL
                       , IIF(LID.MAPPING_COMMENT LIKE '%REP%' OR LID.MAPPING_COMMENT LIKE '%RPL%','Y','N') AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_DEV_ITEM_SCHEDULE LID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   LID.MAPPING_COLUMN = WCO.FR AND LID.DEV_TYPE in ( 'Batch_OPMZ_LOOKUP') and mapping_use = 'OM'
                    WHERE 1=1
                    AND  LID.DEV_TYPE in ( 'Batch_OPMZ_LOOKUP') 
                    AND  mapping_use = 'OM'
                    AND  LID.MAPPING_COLUMN <> 'INCOTERMS_ID'
                    AND  'SCP_OPMZ_LOOKUP_MASTER_DETAIL' = @C_TABLE_NAME
                    AND  LID.PROGRAM_ID = @C_LOOKUP_TYPE
                 ) X
                 GROUP BY TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , CAL_LIKE
                 UNION ALL 
                SELECT TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , STRING_AGG(MAP_COL, ', ') WITHIN GROUP (ORDER BY SEL_COL ASC) AS MAP_COL
                     , CAL_LIKE --LIKE 연산자 --2025-08-31 김준규 실제는 사용하지 않음
                     , ROW_NUMBER()OVER(PARTITION BY TABLE_NAME,LOOKUP_TYPE ORDER BY TABLE_NAME, SEL_COL) RNUM
                FROM (
                    SELECT
                        'SCP_OPMZ_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
                       , LID.PROGRAM_ID AS LOOKUP_TYPE
                       , LID.DEV_DETAIL AS SEL_COL
                       --대체이름 설정
                       , ISNULL(WCO.TOO,LID.MAPPING_COLUMN) AS MAP_COL
                       , IIF(LID.MAPPING_COMMENT LIKE '%REP%' OR LID.MAPPING_COMMENT LIKE '%RPL%','Y','N') AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_DEV_ITEM_SCHEDULE LID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   LID.MAPPING_COLUMN = WCO.FR AND LID.DEV_TYPE in ( 'Batch_OPMZ_LOOKUP') and mapping_use = 'OM'
                    WHERE 1=1
                    AND  LID.DEV_TYPE in ( 'Batch_OPMZ_LOOKUP') 
                    AND  mapping_use = 'OM'
                    AND  LID.MAPPING_COLUMN <> 'INCOTERMS_ID'
                    AND  'SCP_OPMZ_LOOKUP_MASTER_DETAIL' = @C_TABLE_NAME
                    AND  LID.PROGRAM_ID = @C_LOOKUP_TYPE
                    --2025-09-12 REPLACE 2번해야 되서 한번더 UNION ALL 해서 처리
                    AND  LID.PROGRAM_ID = 'SCP_OPT_MASTER_CAPA_TEMP'  
                 ) X
                 GROUP BY TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , CAL_LIKE
            )
            SELECT WR.TABLE_NAME
                  ,WR.LOOKUP_TYPE
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L1  --BEFORE
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L12
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN WR.SEL_COL END) B1  --BEFORE
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN WR.SEL_COL END) B2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN WR.SEL_COL END) B3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN WR.SEL_COL END) B4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN WR.SEL_COL END) B5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN WR.SEL_COL END) B6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN WR.SEL_COL END) B7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN WR.SEL_COL END) B8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN WR.SEL_COL END) B9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN WR.SEL_COL END) B10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN WR.SEL_COL END) B11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN WR.SEL_COL END) B12
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN WR.MAP_COL END) A1  --AFTER
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN WR.MAP_COL END) A2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN WR.MAP_COL END) A3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN WR.MAP_COL END) A4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN WR.MAP_COL END) A5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN WR.MAP_COL END) A6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN WR.MAP_COL END) A7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN WR.MAP_COL END) A8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN WR.MAP_COL END) A9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN WR.MAP_COL END) A10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN WR.MAP_COL END) A11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN WR.MAP_COL END) A12
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 1  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V1  --AFTER
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 2  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V2
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 3  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V3
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 4  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V4
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 5  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V5
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 6  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V6
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 7  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V7
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 8  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V8
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 9  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V9
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 10 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V10
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 11 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V11
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 12 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V12
                  ,MAX(CASE WHEN WR.RNUM = 1  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X1 --LIKE아니고 =(EQUAL) 조인 위함
                  ,MAX(CASE WHEN WR.RNUM = 2  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X2
                  ,MAX(CASE WHEN WR.RNUM = 3  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X3
                  ,MAX(CASE WHEN WR.RNUM = 4  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X4
                  ,MAX(CASE WHEN WR.RNUM = 5  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X5
                  ,MAX(CASE WHEN WR.RNUM = 6  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X6
                  ,MAX(CASE WHEN WR.RNUM = 7  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X7
                  ,MAX(CASE WHEN WR.RNUM = 8  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X8
                  ,MAX(CASE WHEN WR.RNUM = 9  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X9
                  ,MAX(CASE WHEN WR.RNUM = 10 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X10
                  ,MAX(CASE WHEN WR.RNUM = 11 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X11
                  ,MAX(CASE WHEN WR.RNUM = 12 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X12
                  ,MAX(WR.RNUM) RN
            FROM   W_RAW AS WR
            WHERE  1=1
            --2025-04-10 김준규 VALUATION_CLASS RULL BASE가 아닌 HARD CORDING 되어 있어서 비교프로그램에서 제외 처리함.
            AND    NOT EXISTS (SELECT 1
                               WHERE  WR.TABLE_NAME IN ('SCP_ANL_LONG_TERM_STOCK')
                               AND    WR.SEL_COL = 'VALUATION_CLASS'
                               )
            GROUP  BY WR.TABLE_NAME
                  ,WR.LOOKUP_TYPE
            UNION ALL
            SELECT WR.TABLE_NAME
                  ,WR.LOOKUP_TYPE
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L1  --BEFORE
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L12
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN WR.SEL_COL END) B1  --BEFORE
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN WR.SEL_COL END) B2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN WR.SEL_COL END) B3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN WR.SEL_COL END) B4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN WR.SEL_COL END) B5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN WR.SEL_COL END) B6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN WR.SEL_COL END) B7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN WR.SEL_COL END) B8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN WR.SEL_COL END) B9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN WR.SEL_COL END) B10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN WR.SEL_COL END) B11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN WR.SEL_COL END) B12
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN WR.MAP_COL END) A1  --AFTER
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN WR.MAP_COL END) A2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN WR.MAP_COL END) A3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN WR.MAP_COL END) A4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN WR.MAP_COL END) A5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN WR.MAP_COL END) A6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN WR.MAP_COL END) A7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN WR.MAP_COL END) A8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN WR.MAP_COL END) A9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN WR.MAP_COL END) A10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN WR.MAP_COL END) A11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN WR.MAP_COL END) A12
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 1  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V1  --AFTER
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 2  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V2
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 3  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V3
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 4  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V4
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 5  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V5
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 6  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V6
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 7  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V7
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 8  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V8
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 9  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V9
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 10 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V10
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 11 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V11
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 12 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V12
                  ,MAX(CASE WHEN WR.RNUM = 1  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X1 --LIKE아니고 =(EQUAL) 조인 위함
                  ,MAX(CASE WHEN WR.RNUM = 2  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X2
                  ,MAX(CASE WHEN WR.RNUM = 3  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X3
                  ,MAX(CASE WHEN WR.RNUM = 4  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X4
                  ,MAX(CASE WHEN WR.RNUM = 5  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X5
                  ,MAX(CASE WHEN WR.RNUM = 6  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X6
                  ,MAX(CASE WHEN WR.RNUM = 7  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X7
                  ,MAX(CASE WHEN WR.RNUM = 8  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X8
                  ,MAX(CASE WHEN WR.RNUM = 9  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X9
                  ,MAX(CASE WHEN WR.RNUM = 10 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X10
                  ,MAX(CASE WHEN WR.RNUM = 11 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X11
                  ,MAX(CASE WHEN WR.RNUM = 12 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X12
                  ,MAX(WR.RNUM) RN
            FROM   W_RAW AS WR
            WHERE  1=1
            -- 9025-09-12 PLANT_ID로 한번더 변경되어야 해서 강제로 추가함
            AND    WR.LOOKUP_TYPE = 'SCP_OPT_MASTER_CAPA_TEMP'
            AND    WR.LOOKUP_TYPE = @C_LOOKUP_TYPE
            --2025-04-10 김준규 VALUATION_CLASS RULL BASE가 아닌 HARD CORDING 되어 있어서 비교프로그램에서 제외 처리함.
            AND    NOT EXISTS (SELECT 1
                               WHERE  WR.TABLE_NAME IN ('SCP_ANL_LONG_TERM_STOCK')
                               AND    WR.SEL_COL = 'VALUATION_CLASS'
                               )
            GROUP  BY WR.TABLE_NAME
                  ,WR.LOOKUP_TYPE
            ORDER BY 1,2,rn;

        OPEN cur;

        FETCH NEXT FROM cur INTO @C_DUMMY_TBL_NM, @C_DUMMY_LK_TYPE
            ,@C_L1,@C_L2,@C_L3,@C_L4,@C_L5,@C_L6,@C_L7,@C_L8,@C_L9,@C_L10,@C_L11,@C_L12
            ,@C_B1,@C_B2,@C_B3,@C_B4,@C_B5,@C_B6,@C_B7,@C_B8,@C_B9,@C_B10,@C_B11,@C_B12
            ,@C_A1,@C_A2,@C_A3,@C_A4,@C_A5,@C_A6,@C_A7,@C_A8,@C_A9,@C_A10,@C_A11,@C_A12
            ,@C_V1,@C_V2,@C_V3,@C_V4,@C_V5,@C_V6,@C_V7,@C_V8,@C_V9,@C_V10,@C_V11,@C_V12
            ,@C_X1,@C_X2,@C_X3,@C_X4,@C_X5,@C_X6,@C_X7,@C_X8,@C_X9,@C_X10,@C_X11,@C_X12,@C_RN;

        WHILE @@FETCH_STATUS = 0 BEGIN

        PRINT '@C_TABLE_NAME  :'+ISNULL(@C_TABLE_NAME ,'NULL');
        PRINT '@C_DISP_TBL_NM :'+ISNULL(@C_DISP_TBL_NM,'NULL');
        PRINT '@C_LOOKUP_TYPE :'+ISNULL(@C_LOOKUP_TYPE,'NULL');
        PRINT '@C_RTYPE       :'+ISNULL(@C_RTYPE      ,'NULL');
        PRINT '@C_CAL_LIKE    :'+ISNULL(@C_CAL_LIKE   ,'NULL');
        PRINT '@C_RN          :'+ISNULL(CONVERT(NVARCHAR,@C_RN)   ,'NULL');

        IF @C_DISP_TBL_NM <> @C_COPYED_TBL_NM
            BEGIN
                SET @C_COPYED_TBL_NM = @C_DISP_TBL_NM;
                SET @C_PRINT_YN = 1;
            END;
        ELSE
            BEGIN
                SET @C_PRINT_YN = 0;
            END;
        --SELECT 컬럼
        SET @C_SEL_B1  = CASE WHEN @C_B1  IS NOT NULL THEN ' A.'+@C_B1 +' AS B1 ' ELSE '' END;
        SET @C_SEL_B2  = CASE WHEN @C_B2  IS NOT NULL THEN ',A.'+@C_B2 +' AS B2 ' ELSE '' END;
        SET @C_SEL_B3  = CASE WHEN @C_B3  IS NOT NULL THEN ',A.'+@C_B3 +' AS B3 ' ELSE '' END;
        SET @C_SEL_B4  = CASE WHEN @C_B4  IS NOT NULL THEN ',A.'+@C_B4 +' AS B4 ' ELSE '' END;
        SET @C_SEL_B5  = CASE WHEN @C_B5  IS NOT NULL THEN ',A.'+@C_B5 +' AS B5 ' ELSE '' END;
        SET @C_SEL_B6  = CASE WHEN @C_B6  IS NOT NULL THEN ',A.'+@C_B6 +' AS B6 ' ELSE '' END;
        SET @C_SEL_B7  = CASE WHEN @C_B7  IS NOT NULL THEN ',A.'+@C_B7 +' AS B7 ' ELSE '' END;
        SET @C_SEL_B8  = CASE WHEN @C_B8  IS NOT NULL THEN ',A.'+@C_B8 +' AS B8 ' ELSE '' END;
        SET @C_SEL_B9  = CASE WHEN @C_B9  IS NOT NULL THEN ',A.'+@C_B9 +' AS B9 ' ELSE '' END;
        SET @C_SEL_B10 = CASE WHEN @C_B10 IS NOT NULL THEN ',A.'+@C_B10+' AS B10' ELSE '' END;
        SET @C_SEL_B11 = CASE WHEN @C_B11 IS NOT NULL THEN ',A.'+@C_B11+' AS B11' ELSE '' END;
        SET @C_SEL_B12 = CASE WHEN @C_B12 IS NOT NULL THEN ',A.'+@C_B12+' AS B12' ELSE '' END;
        SET @SQL_SA = @C_SEL_B1+@C_SEL_B2+@C_SEL_B3+@C_SEL_B4+@C_SEL_B5+@C_SEL_B6+@C_SEL_B7+@C_SEL_B8+@C_SEL_B9+@C_SEL_B10+@C_SEL_B11+@C_SEL_B12;
        -- CONVERSION 교체컬럼
        SET @C_SEL_A1  = CASE WHEN @C_A1  IS NOT NULL THEN IIF(@C_L1 =0,IIF(@C_V1 =0,' B1.NEW_VALUE1  AS A1  ',' B1.NEW_VALUE2  AS A1 '),' REPLACE(A.'+@C_B1 +',B1.OLD_VALUE1, B1.NEW_VALUE1)  AS A1 ') ELSE '' END;
        SET @C_SEL_A2  = CASE WHEN @C_A2  IS NOT NULL THEN IIF(@C_L2 =0,IIF(@C_V2 =0,',B2.NEW_VALUE1  AS A2  ',',B2.NEW_VALUE2  AS A2 '),',REPLACE(A.'+@C_B2 +',B2.OLD_VALUE1, B2.NEW_VALUE1)  AS A2 ') ELSE '' END;
        SET @C_SEL_A3  = CASE WHEN @C_A3  IS NOT NULL THEN IIF(@C_L3 =0,IIF(@C_V3 =0,',B3.NEW_VALUE1  AS A3  ',',B3.NEW_VALUE2  AS A3 '),',REPLACE(A.'+@C_B3 +',B3.OLD_VALUE1, B3.NEW_VALUE1)  AS A3 ') ELSE '' END;
        SET @C_SEL_A4  = CASE WHEN @C_A4  IS NOT NULL THEN IIF(@C_L4 =0,IIF(@C_V4 =0,',B4.NEW_VALUE1  AS A4  ',',B4.NEW_VALUE2  AS A4 '),',REPLACE(A.'+@C_B4 +',B4.OLD_VALUE1, B4.NEW_VALUE1)  AS A4 ') ELSE '' END;
        SET @C_SEL_A5  = CASE WHEN @C_A5  IS NOT NULL THEN IIF(@C_L5 =0,IIF(@C_V5 =0,',B5.NEW_VALUE1  AS A5  ',',B5.NEW_VALUE2  AS A5 '),',REPLACE(A.'+@C_B5 +',B5.OLD_VALUE1, B5.NEW_VALUE1)  AS A5 ') ELSE '' END;
        SET @C_SEL_A6  = CASE WHEN @C_A6  IS NOT NULL THEN IIF(@C_L6 =0,IIF(@C_V6 =0,',B6.NEW_VALUE1  AS A6  ',',B6.NEW_VALUE2  AS A6 '),',REPLACE(A.'+@C_B6 +',B6.OLD_VALUE1, B6.NEW_VALUE1)  AS A6 ') ELSE '' END;
        SET @C_SEL_A7  = CASE WHEN @C_A7  IS NOT NULL THEN IIF(@C_L7 =0,IIF(@C_V7 =0,',B7.NEW_VALUE1  AS A7  ',',B7.NEW_VALUE2  AS A7 '),',REPLACE(A.'+@C_B7 +',B7.OLD_VALUE1, B7.NEW_VALUE1)  AS A7 ') ELSE '' END;
        SET @C_SEL_A8  = CASE WHEN @C_A8  IS NOT NULL THEN IIF(@C_L8 =0,IIF(@C_V8 =0,',B8.NEW_VALUE1  AS A8  ',',B8.NEW_VALUE2  AS A8 '),',REPLACE(A.'+@C_B8 +',B8.OLD_VALUE1, B8.NEW_VALUE1)  AS A8 ') ELSE '' END;
        SET @C_SEL_A9  = CASE WHEN @C_A9  IS NOT NULL THEN IIF(@C_L9 =0,IIF(@C_V9 =0,',B9.NEW_VALUE1  AS A9  ',',B9.NEW_VALUE2  AS A9 '),',REPLACE(A.'+@C_B9 +',B9.OLD_VALUE1, B9.NEW_VALUE1)  AS A9 ') ELSE '' END;
        SET @C_SEL_A10 = CASE WHEN @C_A10 IS NOT NULL THEN IIF(@C_L10=0,IIF(@C_V10=0,',B10.NEW_VALUE1 AS A10 ',',B10.NEW_VALUE2 AS A10'),',REPLACE(A.'+@C_B10+',B10.OLD_VALUE1,B10.NEW_VALUE1) AS A10') ELSE '' END;
        SET @C_SEL_A11 = CASE WHEN @C_A11 IS NOT NULL THEN IIF(@C_L11=0,IIF(@C_V11=0,',B11.NEW_VALUE1 AS A11 ',',B11.NEW_VALUE2 AS A11'),',REPLACE(A.'+@C_B11+',B11.OLD_VALUE1,B11.NEW_VALUE1) AS A11') ELSE '' END;
        SET @C_SEL_A12 = CASE WHEN @C_A12 IS NOT NULL THEN IIF(@C_L12=0,IIF(@C_V12=0,',B12.NEW_VALUE1 AS A12 ',',B12.NEW_VALUE2 AS A12'),',REPLACE(A.'+@C_B12+',B12.OLD_VALUE1,B12.NEW_VALUE1) AS A12') ELSE '' END;

        --SET @C_SEL_A1  = CASE WHEN @C_A1  IS NOT NULL THEN IIF(@C_V1 =0,' B1.NEW_VALUE1  AS A1 ',' B1.NEW_VALUE2  AS A1 ') ELSE '' END;
        --SET @C_SEL_A2  = CASE WHEN @C_A2  IS NOT NULL THEN IIF(@C_V2 =0,',B2.NEW_VALUE1  AS A2 ',',B2.NEW_VALUE2  AS A2 ') ELSE '' END;
        --SET @C_SEL_A3  = CASE WHEN @C_A3  IS NOT NULL THEN IIF(@C_V3 =0,',B3.NEW_VALUE1  AS A3 ',',B3.NEW_VALUE2  AS A3 ') ELSE '' END;
        --SET @C_SEL_A4  = CASE WHEN @C_A4  IS NOT NULL THEN IIF(@C_V4 =0,',B4.NEW_VALUE1  AS A4 ',',B4.NEW_VALUE2  AS A4 ') ELSE '' END;
        --SET @C_SEL_A5  = CASE WHEN @C_A5  IS NOT NULL THEN IIF(@C_V5 =0,',B5.NEW_VALUE1  AS A5 ',',B5.NEW_VALUE2  AS A5 ') ELSE '' END;
        --SET @C_SEL_A6  = CASE WHEN @C_A6  IS NOT NULL THEN IIF(@C_V6 =0,',B6.NEW_VALUE1  AS A6 ',',B6.NEW_VALUE2  AS A6 ') ELSE '' END;
        --SET @C_SEL_A7  = CASE WHEN @C_A7  IS NOT NULL THEN IIF(@C_V7 =0,',B7.NEW_VALUE1  AS A7 ',',B7.NEW_VALUE2  AS A7 ') ELSE '' END;
        --SET @C_SEL_A8  = CASE WHEN @C_A8  IS NOT NULL THEN IIF(@C_V8 =0,',B8.NEW_VALUE1  AS A8 ',',B8.NEW_VALUE2  AS A8 ') ELSE '' END;
        --SET @C_SEL_A9  = CASE WHEN @C_A9  IS NOT NULL THEN IIF(@C_V9 =0,',B9.NEW_VALUE1  AS A9 ',',B9.NEW_VALUE2  AS A9 ') ELSE '' END;
        --SET @C_SEL_A10 = CASE WHEN @C_A10 IS NOT NULL THEN IIF(@C_V10=0,',B10.NEW_VALUE1 AS A10',',B10.NEW_VALUE2 AS A10') ELSE '' END;
        --SET @C_SEL_A11 = CASE WHEN @C_A11 IS NOT NULL THEN IIF(@C_V11=0,',B11.NEW_VALUE1 AS A11',',B11.NEW_VALUE2 AS A11') ELSE '' END;
        --SET @C_SEL_A12 = CASE WHEN @C_A12 IS NOT NULL THEN IIF(@C_V12=0,',B12.NEW_VALUE1 AS A12',',B12.NEW_VALUE2 AS A12') ELSE '' END;
        SET @SQL_SM = @C_SEL_A1+@C_SEL_A2+@C_SEL_A3+@C_SEL_A4+@C_SEL_A5+@C_SEL_A6+@C_SEL_A7+@C_SEL_A8+@C_SEL_A9+@C_SEL_A10+@C_SEL_A11+@C_SEL_A12;

        --참고 INFO 컬럼,SELECT 컬럼에 MAPPING을 무엇으로 하는가를 보여주는 것임.
        SET @SQL_SW =         CASE WHEN @C_B1  IS NOT NULL THEN QUOTENAME(@C_B1 )+'='+@C_A1  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B2  IS NOT NULL THEN QUOTENAME(@C_B2 )+'='+@C_A2  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B3  IS NOT NULL THEN QUOTENAME(@C_B3 )+'='+@C_A3  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B4  IS NOT NULL THEN QUOTENAME(@C_B4 )+'='+@C_A4  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B5  IS NOT NULL THEN QUOTENAME(@C_B5 )+'='+@C_A5  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B6  IS NOT NULL THEN QUOTENAME(@C_B6 )+'='+@C_A6  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B7  IS NOT NULL THEN QUOTENAME(@C_B7 )+'='+@C_A7  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B8  IS NOT NULL THEN QUOTENAME(@C_B8 )+'='+@C_A8  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B9  IS NOT NULL THEN QUOTENAME(@C_B9 )+'='+@C_A9  ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B10 IS NOT NULL THEN QUOTENAME(@C_B10)+'='+@C_A10 ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B11 IS NOT NULL THEN QUOTENAME(@C_B11)+'='+@C_A11 ELSE '' END;
        SET @SQL_SW = @SQL_SW+CASE WHEN @C_B12 IS NOT NULL THEN QUOTENAME(@C_B12)+'='+@C_A12 ELSE '' END;

        SET @SQL_STMT = N'';

        SET @SQL_STMT = N'
            SELECT DISTINCT '''+@C_DISP_TBL_NM/*@C_LOOKUP_TYPE @C_TABLE_NAME*/+N''' AS TABLE_NAME, '+@SQL_SA+N','+@SQL_SM+N'
            --SELECT TOP 2 '''+@C_DISP_TBL_NM/*@C_LOOKUP_TYPE @C_TABLE_NAME*/+N''' AS TABLE_NAME, '+@SQL_SA+N','+@SQL_SM+N'
                  ,'+@ColumnsToSelect+ CHAR(13) + CHAR(10) + N', '+@ColumnsToSelect_OLD+N'
                  --,LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT6, SEGMENT7, SEGMENT8, SEGMENT9, SEGMENT10
            /*FROM   DBO.' + QUOTENAME(@C_TABLE_NAME) + N' A WITH (NOLOCK)*/
            /*FROM [DBO].' + QUOTENAME(@C_TABLE_NAME) + N' A WITH (NOLOCK)*/
            FROM '+QUOTENAME(@C_TABLE_NAME) + N' A WITH (NOLOCK)';

        DECLARE @V_PLANT_ID NVARCHAR(128);
        SET @V_PLANT_ID = NULL;
        IF (@C_V1 + @C_V2 + @C_V3 + @C_V4 + @C_V5 + @C_V6 + @C_V7 + @C_V8 + @C_V9 + @C_V10 + @C_V11 + @C_V12) >= 1 BEGIN
            SELECT TOP 1 @V_PLANT_ID = DIS.DEV_DETAIL
            FROM   ZNERP_DEV_ITEM_SCHEDULE AS DIS WITH(NOLOCK)
            WHERE  1=1
            AND    DIS.PROGRAM_ID = @C_TABLE_NAME
            AND    MAPPING_COLUMN = N'PLANT_ID'
            ORDER BY CASE WHEN DEV_DETAIL  = 'STORAGE_PLANT_ID' THEN 1
                          WHEN DEV_DETAIL  = 'PLANT_ID' THEN 2
                          WHEN DEV_DETAIL  = 'PLANT_CD' THEN 3
                          WHEN DEV_DETAIL LIKE '%SITE_ID%' THEN 9
                        ELSE 8 END
            END;
        ELSE BEGIN
            SET @V_PLANT_ID = 'PLANT_ID';
            END;

        IF @C_RN >= 1 BEGIN
          IF @C_L1 = 0 BEGIN
            IF @C_V1 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B1  ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V1 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B1  ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B1.OLD_VALUE1';
            END
          END
          ELSE IF @C_L1 = 1 BEGIN
            IF @C_V1 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B1  ON A.' + QUOTENAME(@C_B1 ) + (CASE WHEN @C_X1 = 0 THEN ' LIKE '+'''%''+B1.OLD_VALUE1+''%''' ELSE ' = B1.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V1 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B1  ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B1.OLD_VALUE1';
            END
          END          
        END;
        IF @C_RN >= 2 BEGIN
          IF @C_L2 = 0 BEGIN
            IF @C_V2 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B2  ON A.' + QUOTENAME(@C_B2 ) + ' = B2.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V2 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B2  ON A.' + QUOTENAME(@C_B2 ) + ' = B2.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B2.OLD_VALUE1';
            END
          END
          ELSE IF @C_L2 = 1 BEGIN
            IF @C_V2 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B2 ON A.' + QUOTENAME(@C_B2) + (CASE WHEN @C_X2 = 0 THEN ' LIKE '+'''%''+B2.OLD_VALUE1+''%''' ELSE ' = B2.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V2 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B2 ON A.' + QUOTENAME(@C_B2) + ' = B2.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B2.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 3 BEGIN
          IF @C_L3 = 0 BEGIN
            IF @C_V3 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B3  ON A.' + QUOTENAME(@C_B3 ) + ' = B3.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V3 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B3  ON A.' + QUOTENAME(@C_B3 ) + ' = B3.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B3.OLD_VALUE1';
            END
          END
          ELSE IF @C_L3 = 1 BEGIN
            IF @C_V3 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B3 ON A.' + QUOTENAME(@C_B3) + (CASE WHEN @C_X3 = 0 THEN ' LIKE '+'''%''+B3.OLD_VALUE1+''%''' ELSE ' = B3.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V3 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B3 ON A.' + QUOTENAME(@C_B3) + ' = B3.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B3.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 4 BEGIN
          IF @C_L4 = 0 BEGIN
            IF @C_V4 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B4  ON A.' + QUOTENAME(@C_B4 ) + ' = B4.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V4 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B4  ON A.' + QUOTENAME(@C_B4 ) + ' = B4.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B4.OLD_VALUE1';
            END
          END
          ELSE IF @C_L4 = 1 BEGIN
            IF @C_V4 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B4 ON A.' + QUOTENAME(@C_B4) + (CASE WHEN @C_X4 = 0 THEN ' LIKE '+'''%''+B4.OLD_VALUE1+''%''' ELSE ' = B4.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V4 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B4 ON A.' + QUOTENAME(@C_B4) + ' = B4.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B4.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 5 BEGIN
          IF @C_L5 = 0 BEGIN
            IF @C_V5 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B5  ON A.' + QUOTENAME(@C_B5 ) + ' = B5.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V5 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B5  ON A.' + QUOTENAME(@C_B5 ) + ' = B5.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B5.OLD_VALUE1';
            END
          END
          ELSE IF @C_L5 = 1 BEGIN
            IF @C_V5 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B5 ON A.' + QUOTENAME(@C_B5) + (CASE WHEN @C_X5 = 0 THEN ' LIKE '+'''%''+B5.OLD_VALUE1+''%''' ELSE ' = B5.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V5 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B5 ON A.' + QUOTENAME(@C_B5) + ' = B5.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B5.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 6 BEGIN
          IF @C_L6 = 0 BEGIN
            IF @C_V6 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B6  ON A.' + QUOTENAME(@C_B6 ) + ' = B6.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V6 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B6  ON A.' + QUOTENAME(@C_B6 ) + ' = B6.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B6.OLD_VALUE1';
            END
          END
          ELSE IF @C_L6 = 1 BEGIN
            IF @C_V6 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B6 ON A.' + QUOTENAME(@C_B6) + (CASE WHEN @C_X6 = 0 THEN ' LIKE '+'''%''+B6.OLD_VALUE1+''%''' ELSE ' = B6.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V6 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B6 ON A.' + QUOTENAME(@C_B6) + ' = B6.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B6.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 7 BEGIN
          IF @C_L7 = 0 BEGIN
            IF @C_V7 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B7  ON A.' + QUOTENAME(@C_B7 ) + ' = B7.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V7 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B7  ON A.' + QUOTENAME(@C_B7 ) + ' = B7.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B7.OLD_VALUE1';
            END
          END
          ELSE IF @C_L7 = 1 BEGIN
            IF @C_V7 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B7 ON A.' + QUOTENAME(@C_B7) + (CASE WHEN @C_X7 = 0 THEN ' LIKE '+'''%''+B7.OLD_VALUE1+''%''' ELSE ' = B7.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V7 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B7 ON A.' + QUOTENAME(@C_B7) + ' = B7.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B7.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 8 BEGIN
          IF @C_L8 = 0 BEGIN
            IF @C_V8 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B8  ON A.' + QUOTENAME(@C_B8 ) + ' = B8.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V8 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B8  ON A.' + QUOTENAME(@C_B8 ) + ' = B8.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B8.OLD_VALUE1';
            END
          END
          ELSE IF @C_L8 = 1 BEGIN
            IF @C_V8 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B8 ON A.' + QUOTENAME(@C_B8) + (CASE WHEN @C_X8 = 0 THEN ' LIKE '+'''%''+B8.OLD_VALUE1+''%''' ELSE ' = B8.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V8 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B8 ON A.' + QUOTENAME(@C_B8) + ' = B8.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B8.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 9 BEGIN
          IF @C_L9 = 0 BEGIN
            IF @C_V9 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B9  ON A.' + QUOTENAME(@C_B9 ) + ' = B9.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V9 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B9  ON A.' + QUOTENAME(@C_B9 ) + ' = B9.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B9.OLD_VALUE1';
            END
          END
          ELSE IF @C_L9 = 1 BEGIN
            IF @C_V9 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B9 ON A.' + QUOTENAME(@C_B9) + (CASE WHEN @C_X9 = 0 THEN ' LIKE '+'''%''+B9.OLD_VALUE1+''%''' ELSE ' = B9.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V9 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B9 ON A.' + QUOTENAME(@C_B9) + ' = B9.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B9.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 10 BEGIN
          IF @C_L10 = 0 BEGIN
            IF @C_V10 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B10 ON A.' + QUOTENAME(@C_B10) + ' = B10.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V10 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B10 ON A.' + QUOTENAME(@C_B10) + ' = B10.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B10.OLD_VALUE1';
            END
        END;
          END
          ELSE IF @C_L10 = 1 BEGIN
            IF @C_V10 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B10 ON A.' + QUOTENAME(@C_B10) + (CASE WHEN @C_X10 = 0 THEN ' LIKE '+'''%''+B10.OLD_VALUE1+''%''' ELSE ' = B10.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V10 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B10 ON A.' + QUOTENAME(@C_B10) + ' = B10.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B10.OLD_VALUE1';
            END
          END
        IF @C_RN >= 11 BEGIN
          IF @C_L11 = 0 BEGIN
            IF @C_V11 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B11 ON A.' + QUOTENAME(@C_B11) + ' = B11.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V11 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B11 ON A.' + QUOTENAME(@C_B11) + ' = B11.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B11.OLD_VALUE1';
            END
          END
          ELSE IF @C_L11 = 1 BEGIN
            IF @C_V11 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B11 ON A.' + QUOTENAME(@C_B11) + (CASE WHEN @C_X11 = 0 THEN ' LIKE '+'''%''+B11.OLD_VALUE1+''%''' ELSE ' = B11.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V11 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B11 ON A.' + QUOTENAME(@C_B11) + ' = B11.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B11.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 12 BEGIN
          IF @C_L12 = 0 BEGIN
            IF @C_V12 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B12 ON A.' + QUOTENAME(@C_B12) + ' = B12.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V12 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B12 ON A.' + QUOTENAME(@C_B12) + ' = B12.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B12.OLD_VALUE1';
            END
          END
          ELSE IF @C_L12 = 1 BEGIN
            IF @C_V12 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B12 ON A.' + QUOTENAME(@C_B12) + (CASE WHEN @C_X12 = 0 THEN ' LIKE '+'''%''+B12.OLD_VALUE1+''%''' ELSE ' = B12.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V12 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B12 ON A.' + QUOTENAME(@C_B12) + ' = B12.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B12.OLD_VALUE1';
            END
          END
        END;
    
        SET @SQL_ISNOTNULL = N'';
        IF @C_RN = 1 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 2 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 3 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 4 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 5 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 6 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 7 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 8 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 9 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 10 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                  OR  B10.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 11 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                  OR  B10.OLD_VALUE1 IS NOT NULL
                  OR  B11.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 12 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                  OR  B10.OLD_VALUE1 IS NOT NULL
                  OR  B11.OLD_VALUE1 IS NOT NULL
                  OR  B12.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;

        --PRINT '1 @SQL_STMT :'+@SQL_STMT;

            IF @C_RTYPE = 'LOOKUP' BEGIN
                SET @SQL_STMT += N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE') + ' = '''+@C_LOOKUP_TYPE+'''
            AND   A.VALID_YN = ''Y'' ' + @SQL_ISNOTNULL;
            END;
            --2025-09-26 최적화는 모든 VALID_YN 무시하고 모두 작업
            ELSE IF @C_RTYPE = 'OPMZ_LOOKUP' BEGIN
                SET @SQL_STMT += N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE') + ' = '''+@C_LOOKUP_TYPE+'''
            --AND   A.VALID_YN = ''Y'' '' + @SQL_ISNOTNULL;''
            '+ @SQL_ISNOTNULL;
            END;
            ELSE IF @C_RTYPE = 'CODE_LOOKUP' BEGIN
                SET @SQL_STMT += N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE_CODE') + ' = '''+@C_LOOKUP_TYPE+'''
            AND   A.ACTIVE_FLAG = ''Y'' ' + @SQL_ISNOTNULL;
            END;
            ELSE BEGIN
                --IF @C_DATE_TYPE_YN = 'Y'
                --BEGIN
                --    SET @V_CUTOFF_COLUMN = N'
                --        AND ' + @C_CUTOFF_COLUMN + ' >= ' + CONVERT(DATE, '' + @V_FR_YYYYMMDD +'', 112) + '
                --        AND ' + @C_CUTOFF_COLUMN + ' <  ' + CONVERT(DATE, '' + @V_TO_YYYYMMDD +'', 112);
                --END;
                --ELSE-- @C_DATE_TYPE_YN = 'N'
                IF @C_CUTOFF_COLUMN IS NOT NULL
                BEGIN
                    SET @V_CUTOFF_COLUMN = N'
                        AND ' + @C_CUTOFF_COLUMN + ' >= ' + ' '''+@V_FR_YYYYMMDD +'''
                        AND ' + @C_CUTOFF_COLUMN + ' <  ' + ' '''+@V_TO_YYYYMMDD +'''';
                END;
                ELSE
                BEGIN
                    SET @V_CUTOFF_COLUMN = N'';
                END

                SET @SQL_STMT += N'
            WHERE 1=1 ' + @V_CUTOFF_COLUMN + @SQL_ISNOTNULL;
            END;

        --PRINT '2 @SQL_STMT :'+@SQL_STMT;

            --SET @SQL_STMT = N'
            --BEGIN TRAN;
            --;WITH W_RAW AS ('+@SQL_STMT+N'
            --)
            --UPDATE A
            --SET ' + @UpdateSetClause + N'
            --FROM ' + QUOTENAME(@TableName) + N' A
            --JOIN W_RAW WR ON ' + @JoinCondition + N';
            --SET @RowCount = @@ROWCOUNT;
            --COMMIT TRAN;';

            SET @SQL_STMT = N'
            DROP TABLE IF EXISTS #UPDATE_TEMP_TABLE;
            --BEGIN TRAN;
            DECLARE @ROWCNT INT =0;
            DECLARE @MSG NVARCHAR(MAX)=N'''';
            SET @MSG = ''0 @ROWCNT:''+CONVERT(NVARCHAR(30),@ROWCNT);
            RAISERROR(@MSG, 0, 1) WITH NOWAIT;
            PRINT ''0-1 @ROWCNT:''+CONVERT(NVARCHAR(30),@ROWCNT);

--INSERT INTO DROP_PLOG(PGM_NM,MSG)VALUES( '''+@v_program_name+N''',ISNULL(@MSG,''NULL'') );
--SELECT * FROM DROP_PLOG WHERE LOGTIME > GETDATE()-0.5 ORDER BY LOGID DESC;


            /* 1. 임시 테이블 */
            ;WITH W_RAW AS ('+@SQL_STMT+N'
            )
            SELECT 
                   *
            INTO #UPDATE_TEMP_TABLE
            FROM (
                SELECT ROW_NUMBER() OVER (PARTITION BY LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, SEGMENT6, SEGMENT7, SEGMENT8, SEGMENT9, SEGMENT10 ORDER BY VALID_YN DESC) AS __UniqueID,
                       *,
                       CAST(NULL AS BIT) AS __ProcessedFlag
                FROM W_RAW
            ) X
            WHERE __UniqueID = 1;            

            SET @ROWCNT = @@ROWCOUNT;
            
            PRINT ''1 @ROWCNT:''+CONVERT(NVARCHAR(30),@ROWCNT);

            /* 2. 복합 인덱스 */
            BEGIN TRY
                CREATE INDEX IX_TEMP_JOIN ON #UPDATE_TEMP_TABLE(' + @CompositeCols + N');
            END TRY
            BEGIN CATCH
                PRINT N''Index IX_TEMP_JOIN creation failed: '' + ERROR_MESSAGE();
            END CATCH;
            BEGIN TRY
                CREATE INDEX IX_TEMP_JOIN_UniqueID ON #UPDATE_TEMP_TABLE([__UniqueID],[__ProcessedFlag]);
            END TRY
            BEGIN CATCH
                PRINT N''Index IX_TEMP_JOIN_UniqueID creation failed: '' + ERROR_MESSAGE();
            END CATCH;

            --/* 3. 배치 UPDATE */
            --DECLARE @BatchCtr INT = 0;

            PRINT ''2 @ROWCNT:''+CONVERT(NVARCHAR(30),@ROWCNT);

            --;WITH W_RAW AS (
            --    SELECT TOP (@BatchSize) *
            --    FROM #UPDATE_TEMP_TABLE WITH(INDEX(IX_TEMP_JOIN_UniqueID))
            --    WHERE __ProcessedFlag IS NULL
            --    ORDER BY __UniqueID
            --)
            --UPDATE A
            --SET ' + @UpdateSetClause + N'
            ----SELECT *
            --FROM ' + QUOTENAME(@TableName) + N' A
            --JOIN W_RAW AS WR ON ' + @JoinCondition + N';

            /* 3. MERGE */
            MERGE ' + QUOTENAME(@TableName) + N' A
            USING #UPDATE_TEMP_TABLE AS WR
            ON A.LOOKUP_TYPE = WR.LOOKUP_TYPE
            AND A.[SEGMENT1] = WR.[SEGMENT1]
            AND A.[SEGMENT2] = WR.[SEGMENT2]
            AND A.[SEGMENT3] = WR.[SEGMENT3]
            AND A.[SEGMENT4] = WR.[SEGMENT4]
            AND A.[SEGMENT5] = WR.[SEGMENT5]
            AND A.[SEGMENT6] = WR.[SEGMENT6]
            AND A.[SEGMENT7] = WR.[SEGMENT7]
            AND A.[SEGMENT8] = WR.[SEGMENT8]
            AND A.[SEGMENT9] = WR.[SEGMENT9]
            AND A.[SEGMENT10] = WR.[SEGMENT10]
            WHEN MATCHED THEN
                UPDATE SET ' + @UpdateSetClause + N'
            WHEN NOT MATCHED BY TARGET THEN
                INSERT ('+REPLACE(@ColumnsToSelect_ORIG,N'A.',N'')+N')
                VALUES ('+REPLACE(@ColumnsToSelect_UPD,N'A.',N'WR.')+N')
                ;
            SET @RowCount = @@ROWCOUNT;

            PRINT ''3 @ROWCNT:''+CONVERT(NVARCHAR(30),@ROWCNT);

            --UPDATE OLD VALUE
            UPDATE A
            SET    VALID_YN = ''N''
                  ,LAST_UPDATE_DATE = GETDATE()
                  ,LAST_UPDATED_BY = '''+@CREATED_BY+N'''
            FROM   ' + QUOTENAME(@TableName) + N' A
            JOIN   #UPDATE_TEMP_TABLE AS WR
            ON  A.LOOKUP_TYPE = WR.OLD_LOOKUP_TYPE
            AND A.[SEGMENT1] = WR.[OLD_SEGMENT1]
            AND A.[SEGMENT2] = WR.[OLD_SEGMENT2]
            AND A.[SEGMENT3] = WR.[OLD_SEGMENT3]
            AND A.[SEGMENT4] = WR.[OLD_SEGMENT4]
            AND A.[SEGMENT5] = WR.[OLD_SEGMENT5]
            AND A.[SEGMENT6] = WR.[OLD_SEGMENT6]
            AND A.[SEGMENT7] = WR.[OLD_SEGMENT7]
            AND A.[SEGMENT8] = WR.[OLD_SEGMENT8]
            AND A.[SEGMENT9] = WR.[OLD_SEGMENT9]
            AND A.[SEGMENT10] = WR.[OLD_SEGMENT10];

            SET @RowCount = @RowCount + @@ROWCOUNT;

            PRINT ''4 @ROWCNT:''+CONVERT(NVARCHAR(30),@ROWCNT);

            /* 4. 정리 */
            DROP TABLE IF EXISTS #UPDATE_TEMP_TABLE;
            --COMMIT TRAN;';

        -----------------------------------------------------------------------
        -- 6. 실행 또는 출력
        -----------------------------------------------------------------------
        DECLARE @Params NVARCHAR(400) = N'@BatchSize INT = 1000000, @RowCount INT OUTPUT';
        DECLARE @DebugMode              BIT = 0;                            -- 1=SQL 출력, 0=실행

        IF @DebugMode = 1
        BEGIN
            PRINT '/* ===== Generated SQL ===== */';
            SET @DUMMY = @SQL_STMT;
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
            PRINT '/* ===== End Generated SQL ===== */';
        END
        ELSE
        BEGIN
            BEGIN TRY
                SET @DUMMY = @SQL_STMT;
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
                EXEC sp_executesql @SQL_STMT, @Params, @BatchSize = 1000000, @RowCount = @RowCount OUTPUT;

                DECLARE @StartTime         DATETIME2 = SYSDATETIME();
                PRINT 'Update completed.';
                PRINT 'Rows affected: ' + CAST(@RowCount AS NVARCHAR(20));
                PRINT 'Elapsed: ' +
                      CAST(DATEDIFF(MINUTE, @StartTime, SYSDATETIME()) AS NVARCHAR(20)) + ' mins';
            END TRY
            BEGIN CATCH
                PRINT 'Error executing dynamic SQL: ' + ERROR_MESSAGE();
                --IF XACT_STATE() <> 0 ROLLBACK TRAN;
                SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error executing dynamic SQL: ' + ERROR_MESSAGE();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
                --에러나도 계속 다음 단계 수행
                --RETURN;
            END CATCH
        END






            FETCH NEXT FROM cur INTO @C_DUMMY_TBL_NM, @C_DUMMY_LK_TYPE
                ,@C_L1,@C_L2,@C_L3,@C_L4,@C_L5,@C_L6,@C_L7,@C_L8,@C_L9,@C_L10,@C_L11,@C_L12
                ,@C_B1,@C_B2,@C_B3,@C_B4,@C_B5,@C_B6,@C_B7,@C_B8,@C_B9,@C_B10,@C_B11,@C_B12
                ,@C_A1,@C_A2,@C_A3,@C_A4,@C_A5,@C_A6,@C_A7,@C_A8,@C_A9,@C_A10,@C_A11,@C_A12
                ,@C_V1,@C_V2,@C_V3,@C_V4,@C_V5,@C_V6,@C_V7,@C_V8,@C_V9,@C_V10,@C_V11,@C_V12
                ,@C_X1,@C_X2,@C_X3,@C_X4,@C_X5,@C_X6,@C_X7,@C_X8,@C_X9,@C_X10,@C_X11,@C_X12,@C_RN;

        END;

        CLOSE cur;
        DEALLOCATE cur
        ;

        --################################################################
        -- Log
        --################################################################
            SET @END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            SET @RUN_TIME = DATEDIFF(SECOND, @START_TIME, @END_TIME)
            SET @DUMMY = N'END -->> '+concat(

            N'     @CNT = ' , @CNT
            , N' , @C_LOOKUP_TYPE = ', @C_LOOKUP_TYPE
            , N' , @START_TIME = ' , @START_TIME
            , N' , @END_TIME = '   , @END_TIME
            , N' , @RUN_TIME = '   , @RUN_TIME
            );

            PRINT @DUMMY
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @RUN_TIME, @C_LOOKUP_TYPE,  @v_description, @d_event_date;



        --################################################################
        -- 결과 업데이트
        --################################################################
        IF  @MAPPING_USE = 'Y'
        BEGIN
          print @C_LOOKUP_TYPE
          UPDATE ZNERP_DEV_ITEM_SCHEDULE
          SET status = 'FINISH'
             , MAPPING_START = @START_TIME
             , MAPPING_END = @END_TIME
             , MAPPING_TIME = @RUN_TIME
             , MAPPING_COLUMN = @MAPPING_COLUMN
             where  dev_type = 'Batch_LOOKUP'
               and mapping_use = 'Y'
               and DEV_DETAIL = @C_LOOKUP_TYPE
        END


        --COMMIT TRANSACTION;
    --END TRY
    --BEGIN CATCH
    --    IF @@TRANCOUNT > 0
    --        ROLLBACK TRANSACTION;
    --        SET @CNT = @@ROWCOUNT;
    --        SET @WORK_SECOND = ERROR_NUMBER();
    --        SET @DUMMY = @DUMMY+','+ERROR_MESSAGE();
    --        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
    --        PRINT 'ERROR'
    --        PRINT ERROR_MESSAGE();
    --END CATCH


        FETCH NEXT FROM CURSOR_MAPPING
        INTO @C_TABLE_NAME, @C_LOOKUP_TYPE ;

        END
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;



        --###############################################################################################
        -- FINISH
        --###############################################################################################
        SET @CNT = @@ROWCOUNT;
        SET @BATCH_END_TIME = SYSDATETIME();
        SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
        PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
        SET @DUMMY = 'END,'+@v_description+', RUN_TIME ';
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  @DUMMY, @BATCH_END_TIME;

END TRY
BEGIN CATCH
        print ERROR_MESSAGE()
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;


        SET @CNT = @@ROWCOUNT;
        SET @RUN_TIME = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        PRINT @v_description;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @RUN_TIME, @v_description, @d_event_date;
END CATCH

END
