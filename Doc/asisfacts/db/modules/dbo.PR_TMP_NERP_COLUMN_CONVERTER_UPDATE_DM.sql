
-- ==========================================================================================
-- Program:        PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM
-- Author:         김준규
-- Create date:    2025-07-16
-- Description:    NERP) PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_CUTOFF 참고하여 전면 개정(데이터 량이 많을 경우 답없음)
-- How to Execute: EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM @P_TABLE='DM_PLN_MKT_FCST',@P_ROLLIN='3RD';  --pk존재
-- How to Execute: EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM @P_TABLE='DM_DNM_SALES_RESULT_IF',@P_ROLLIN='3RD';  --pk없음
--                 EXEC PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM @P_TABLE='',@P_ROLLIN='3RD';  --전부
--                 EXEC PR_SCP_NERP_COLUMN_CONVERTER_INSERT_FROM_PROD_LOOKUP_AND_MASTER_DM @P_TABLE='DM_PLN_MKT_FCST',@P_RTYPE='';  --운영에서 데이터 가져오기

-- ==========================================================================================
-- 2025-07-16       김준규       NERP) PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_CUTOFF에서 쿼리문장 차용
-- 2025-09-13       김준규       NERP) 에러가 나면 STOP 하는 것을 계속 다음단계 실행하도록 변경
-- 2025-09-13       김준규       NERP) CURRENCY_ID 추가 작업
-- 2025-10-15       김준규       NERP) RMB TO CNY 변경은 ROLLIN 3차만 적용 AND NOT EXISTS (SELECT 1 WHERE @P_ROLLIN <> '3RD' AND B.MASTER_CODETYPE = 'CURRENCY_ID')
-- 2025-10-31       김준규       NERP) SCM_DNM_STOCK_SALES 테이블이 4차(5TH OR 4N5) 26년1월 에서 Storage 중복에러발생,중복 키 값은 (20201109, EG00, 40, EG00, S01A, EAPJ00226AA, EAPJ00226AA)입니다.
---------------------------------------------------------------------------------------------
CREATE PROCEDURE [dbo].[PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM]
   @P_TABLE          nvarchar(128)
 , @P_ROLLIN         nvarchar(30) --1ST 2ND 3RD 4TH
AS
BEGIN

    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

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
    DECLARE @V_SCOPE_ID BIGINT;
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_DM_'+@P_ROLLIN;

    SET @CNT = 0;
    SET @RUN_TIME = 0;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500) = '@P_TABLE:'+@P_TABLE+',@P_ROLLIN:'+@P_ROLLIN;;
    DECLARE @d_event_date   DATETIME;


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @d_event_date = SYSDATETIME();
    EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY

    DECLARE @C_MAPPING_USE NVARCHAR(2);
    DECLARE @C_TABLE_NAME  NVARCHAR(128);
    DECLARE @C_DUMMY_TBL_NM NVARCHAR(128);
    DECLARE @C_DISP_TBL_NM NVARCHAR(128);
    DECLARE @C_COPYED_TBL_NM NVARCHAR(128) = '';
    DECLARE @C_PRINT_YN    BIT = 0; -- 1 Y, 0 N
    DECLARE @C_RTYPE       NVARCHAR(128);
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
    DECLARE @C_L13         NVARCHAR(128);
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
    DECLARE @C_B13         NVARCHAR(128);
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
    DECLARE @C_SEL_B13     NVARCHAR(128);
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
    DECLARE @C_A13         NVARCHAR(128);
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
    DECLARE @C_V13         INT;
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
    DECLARE @C_SEL_A13     NVARCHAR(128);
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
    DECLARE @C_X13         BIT;
    DECLARE @C_RN          INT;
    DECLARE @SQL_STMT      NVARCHAR(MAX);
    DECLARE @SQL_SA        NVARCHAR(MAX)='';
    DECLARE @SQL_SM        NVARCHAR(MAX)='';
    DECLARE @SQL_SW        NVARCHAR(MAX)='';
    DECLARE @SQL_ISNOTNULL NVARCHAR(MAX)='';
    DECLARE @ExecutionRST  NVARCHAR(MAX);
    DECLARE @DUMMY         NVARCHAR(MAX);
    DECLARE @crlf          CHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @pos           INT;

    -- 커서가 이미 열려 있는지 확인
    IF CURSOR_STATUS('global', 'cur_CUTOFF_COL') >= 0
    BEGIN
        CLOSE cur_CUTOFF_COL;
        DEALLOCATE cur_CUTOFF_COL;
    END;
    DECLARE cur_CUTOFF_COL CURSOR FAST_FORWARD READ_ONLY FOR
        SELECT distinct TABLE_NAME AS TABLE_NAME
             , ''         AS LOOKUP_TYPE
             , ''         AS R_N_R
             , 'TABLES'   AS RTYPE
             , DENSE_RANK()OVER(ORDER BY TABLE_NAME) RNUM
             , 3          AS SORT_SEQ
          FROM ZNERP_TARGET_INFO_DM AS B WITH (NOLOCK)
         where 1=1
           AND CONVERSION_FLAG <> '-'
           AND NOT EXISTS (SELECT 1 WHERE @P_ROLLIN <> '3RD' AND B.MASTER_CODETYPE = 'CURRENCY_ID')
           and (@P_TABLE IS NULL OR @P_TABLE = '' OR B.TABLE_NAME = @P_TABLE)
        ORDER BY SORT_SEQ,RNUM,1,2,3;

    OPEN cur_CUTOFF_COL;

    FETCH NEXT FROM cur_CUTOFF_COL INTO @C_TABLE_NAME, @C_LOOKUP_TYPE, @C_R_N_R, @C_RTYPE, @C_RNUM, @C_SORT_SEQ;

    WHILE @@FETCH_STATUS = 0 BEGIN

        SET @C_DISP_TBL_NM = CASE WHEN @C_RTYPE IN ( 'LOOKUP','CODE_LOOKUP') THEN @C_LOOKUP_TYPE ELSE @C_TABLE_NAME END;
        SET @C_CODE_LOOKUP_TYPE = CASE WHEN @C_RTYPE = 'CODE_LOOKUP' THEN @C_LOOKUP_TYPE ELSE '' END;
        SET @SQL_SW     = NULL;

            PRINT '------------------------------------------------------------------------------------------------------------------------------------------';
            SET @C_DISP_TBL_NM = @C_DISP_TBL_NM;
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @C_DISP_TBL_NM, 0, '0', '', @START_TIME;
            SET @DUMMY = 'RUN -->> '+concat(
            '     @CNT = ' , @CNT
            , ' , @C_DISP_TBL_NM = ', @C_DISP_TBL_NM
            , ' , @START_TIME = ' , @START_TIME
            , ' , @P_ROLLIN = ' , @P_ROLLIN
            );

            PRINT @DUMMY;

        --PRINT '@C_TABLE_NAME  :'+ISNULL(@C_TABLE_NAME ,'NULL');
        --PRINT '@C_DISP_TBL_NM :'+ISNULL(@C_DISP_TBL_NM,'NULL');
        --PRINT '@C_LOOKUP_TYPE :'+ISNULL(@C_LOOKUP_TYPE,'NULL');
        --PRINT '@C_RTYPE       :'+ISNULL(@C_RTYPE      ,'NULL');

        --######################################
        -- SELECT 컬럼 사용.
        --######################################
        DECLARE @ColumnsToSelect NVARCHAR(MAX)='';

        -- 2. PK 컬럼 확인
        SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(c.name), ', ') WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.tables t
        INNER JOIN sys.indexes i ON t.object_id = i.object_id
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.is_primary_key = 1
        AND t.name = @C_TABLE_NAME
        AND SCHEMA_NAME(t.schema_id) = 'dbo';

--INSERT INTO DROP_PLOG(PGM_NM,MSG)VALUES( @v_program_name,'PK:'+@C_TABLE_NAME+','+ISNULL(@ColumnsToSelect,'NULL') );
--SELECT * FROM DROP_PLOG WHERE LOGTIME > GETDATE()-0.5 ORDER BY LOGID DESC;

        -- 3. PK가 없으면 전체 컬럼 사용
        IF @ColumnsToSelect IS NULL
        BEGIN
            --SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(c.name), ', ') WITHIN GROUP (ORDER BY c.column_id)
            --FROM sys.columns c
            --JOIN sys.tables t ON c.object_id = t.object_id
            --WHERE t.name = @C_TABLE_NAME
            --AND SCHEMA_NAME(t.schema_id) = 'dbo';

            SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(SEL_COL),', ') WITHIN GROUP (ORDER BY SEL_COL)
            FROM (
                SELECT SEL_COL
                FROM (
                   SELECT DISTINCT TABLE_NAME AS TABLE_NAME
                       , TABLE_COL   AS SEL_COL
                   FROM ZNERP_TARGET_INFO_DM AS TID WITH (NOLOCK)
                   where 1=1
                   and CONVERSION_FLAG <> '-'
                   AND NOT EXISTS (SELECT 1 WHERE @P_ROLLIN <> '3RD' AND TID.MASTER_CODETYPE = 'CURRENCY_ID')
                   AND TABLE_NAME = @C_TABLE_NAME
                   AND 'TABLES'   = @C_RTYPE
                ) X
                GROUP BY SEL_COL
            ) X
            ORDER BY 1;
        END

        --PK 중복으로 컬럼값 합치기
        IF @C_TABLE_NAME = 'SCM_DNM_STOCK_SALES' BEGIN SET @ColumnsToSelect = @ColumnsToSelect + N', QTY, HOLD_QTY'; END

        -----------------------------------------------------------------------
        -- 0. 파라미터 선언 및 유효성 검사
        -----------------------------------------------------------------------
        /* =====================================================================
           동적 UPDATE 스크립트 (최적화 버전)
           - 일반 문자열(콤마 구분) 컬럼 입력 → 순서 보존
           - PK 유무에 따라 전략 분기
           - NULL 비교 최적화(ISNULL)
           - 복합 인덱스 사용
           - 배치·트랜잭션·에러 처리 강화
           - 성능 모니터링 및 디버그 모드
           ===================================================================== */

        SET NOCOUNT ON;
        SET XACT_ABORT ON;   -- 오류 시 자동 롤백

        -----------------------------------------------------------------------
        -- 0. 파라미터 선언
        -----------------------------------------------------------------------
        DECLARE @TableName              NVARCHAR(128) = @C_TABLE_NAME;   -- 대상 테이블
        DECLARE @UpdateColumnNamesString NVARCHAR(MAX) = N'C,B,D,A';        -- ★ 콤마 구분 컬럼 목록
        SELECT @UpdateColumnNamesString = STRING_AGG(SEL_COL,',')
        FROM (
            SELECT SEL_COL
            FROM (
               SELECT DISTINCT TABLE_NAME AS TABLE_NAME
                   , TABLE_COL   AS SEL_COL
               FROM ZNERP_TARGET_INFO_DM AS TID WITH (NOLOCK)
               where 1=1
               and CONVERSION_FLAG <> '-'
               AND NOT EXISTS (SELECT 1 WHERE @P_ROLLIN <> '3RD' AND TID.MASTER_CODETYPE = 'CURRENCY_ID')
               AND TABLE_NAME = @C_TABLE_NAME
               AND 'TABLES'   = @C_RTYPE
            ) X
            GROUP BY SEL_COL
        ) X
        ORDER BY 1;
        DECLARE @WhereFilter            NVARCHAR(MAX) = N'';                -- (선택) 추가 WHERE
        DECLARE @SharedUpdateSetClause NVARCHAR(MAX) = N'';    -- UPDATE SET 절 (사용자 지정 순서 및 ISNULL 처리)
        DECLARE @SharedFromJoinOnClause NVARCHAR(MAX) = N'';    -- UPDATE SET 절 (사용자 지정 순서 및 ISNULL 처리)
        DECLARE @NullToken              NVARCHAR(32) = N'__NULL__';         -- NULL 비교용 토큰
        DECLARE @BatchSize              INT = 5000;                         -- 배치 크기
        DECLARE @DebugMode              BIT = 0;                            -- 1=SQL 출력, 0=실행

        -- 테이블 존재 여부 확인
        IF OBJECT_ID(@TableName) IS NULL
        BEGIN
            RAISERROR('Error: Table "%s" does not exist', 16, 1, @TableName);
            SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error: Table "%s" does not exist';
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            RETURN;
        END

        -- 컬럼 문자열 유효성 검사
        IF ISNULL(LTRIM(RTRIM(@UpdateColumnNamesString)), '') = ''
        BEGIN
            RAISERROR('Error: Update column string is empty', 16, 1);
            SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error: Update column string is empty';
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            RETURN;
        END

        -----------------------------------------------------------------------
        -- 1. 내부 변수/테이블
        -----------------------------------------------------------------------
        DECLARE @SQL               NVARCHAR(MAX) = N'';
        DECLARE @JoinCondition     NVARCHAR(MAX) = N'';
        DECLARE @UpdateSetClause   NVARCHAR(MAX) = N'';
        DECLARE @WRawSelectColumns NVARCHAR(MAX) = N'';
        DECLARE @HasPrimaryKey     BIT = 0;
        DECLARE @StartTime         DATETIME2 = SYSDATETIME();
        DECLARE @RowCount          INT = 0;

        DECLARE @UpdateCols TABLE (ColumnName NVARCHAR(128) PRIMARY KEY, Sequence INT);
        DECLARE @AllCols    TABLE (ColumnName NVARCHAR(128), IsPrimaryKey BIT, ColumnId INT, max_length SMALLINT);
        --초기화;
        DELETE
        FROM @UpdateCols;
        DELETE
        FROM @AllCols;
        -----------------------------------------------------------------------
        -- 2. 입력 문자열 → @UpdateCols (순서 보존)
        -----------------------------------------------------------------------
        BEGIN TRY
            DECLARE @SplitXML XML =
                CAST('<x>' + REPLACE(@UpdateColumnNamesString, ',', '</x><x>') + '</x>' AS XML);

            ;WITH cte AS (
                SELECT ROW_NUMBER() OVER (ORDER BY (SELECT 1))               AS Sequence,
                       LTRIM(RTRIM(v.value('.', 'nvarchar(128)')))           AS ColumnName
                FROM   @SplitXML.nodes('/x') AS t(v)
            )
            INSERT INTO @UpdateCols (ColumnName, Sequence)
            SELECT ColumnName, Sequence
            FROM   cte;

            IF NOT EXISTS (SELECT 1 FROM @UpdateCols)
            BEGIN
                RAISERROR('Error: No columns specified for update', 16, 1);
                SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error: No columns specified for update';
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
                RETURN;
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error parsing column string: ' + ERROR_MESSAGE();
            SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error parsing column string: ' + ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            RETURN;
        END CATCH

        -----------------------------------------------------------------------
        -- 3. 메타 데이터 조회 및 검증
        -----------------------------------------------------------------------
        BEGIN TRY
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

            -- 테이블에 없는 컬럼 존재 여부 체크
            DECLARE @MissingCols NVARCHAR(MAX) =
                (SELECT STRING_AGG(QUOTENAME(uc.ColumnName), ', ')
                 FROM @UpdateCols uc
                 WHERE NOT EXISTS (
                     SELECT 1 FROM @AllCols ac WHERE ac.ColumnName = uc.ColumnName ));

            IF ISNULL(@MissingCols,'') <> ''
            BEGIN
                RAISERROR('Error: Columns not found in table: %s', 16, 1, @MissingCols);
                SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error: Columns not found in table: %s';
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
                RETURN;
            END

            SET @HasPrimaryKey = CASE WHEN EXISTS (SELECT 1 FROM @AllCols WHERE IsPrimaryKey = 1) THEN 1 ELSE 0 END;
        END TRY
        BEGIN CATCH
            PRINT 'Error retrieving metadata: ' + ERROR_MESSAGE();
            SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error retrieving metadata: ' + ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            RETURN;
        END CATCH

        -----------------------------------------------------------------------
        -- 4. JOIN 조건 · SELECT · SET 절 구성
        -----------------------------------------------------------------------
        BEGIN TRY
            /* 4‑1. JOIN 조건 */
            IF @HasPrimaryKey = 1
            BEGIN
                SELECT @JoinCondition =
                       STRING_AGG(N'A.' + QUOTENAME(ColumnName) + N' = WR.' + QUOTENAME(ColumnName), N' AND ')
                FROM   @AllCols
                WHERE  IsPrimaryKey = 1;
            END
            ELSE
            BEGIN
                SELECT @JoinCondition =
                       STRING_AGG(N'ISNULL(A.' + QUOTENAME(uc.ColumnName) + N', ''' + @NullToken + N''') = ' +
                                  N'ISNULL(WR.'   + QUOTENAME(uc.ColumnName) + N', ''' + @NullToken + N''')',
                                  N' AND ') WITHIN GROUP (ORDER  BY uc.Sequence)
                FROM   @UpdateCols uc;
            END

            /* 4‑2. W_RAW SELECT 및 UPDATE SET */
            IF @HasPrimaryKey = 1
            BEGIN
                SELECT @WRawSelectColumns = @WRawSelectColumns + QUOTENAME(ColumnName) + N', '
                FROM   @AllCols
                WHERE  IsPrimaryKey = 1
                ORDER  BY ColumnId;
            END

            DECLARE @Counter INT = 1, @CurCol NVARCHAR(128);
            WHILE EXISTS (SELECT 1 FROM @UpdateCols WHERE Sequence = @Counter)
            BEGIN
                SELECT @CurCol = ColumnName FROM @UpdateCols WHERE Sequence = @Counter;

                SET @WRawSelectColumns += QUOTENAME(@CurCol) + N' AS A' + CONVERT(VARCHAR(30),@Counter) + N', ';
                SET @UpdateSetClause   += N'A.' + QUOTENAME(@CurCol) +
                                          N' = ISNULL(WR.A' + CONVERT(VARCHAR(10),@Counter) +
                                          N', A.' + QUOTENAME(@CurCol) + N'), ';
                SET @Counter += 1;
            END
            SET @WRawSelectColumns = LEFT(@WRawSelectColumns, LEN(@WRawSelectColumns)-2);
            --SET @UpdateSetClause   = LEFT(@UpdateSetClause,   LEN(@UpdateSetClause)-2);
            SET @UpdateSetClause   = LEFT(@UpdateSetClause,   LEN(@UpdateSetClause)-1);
        END TRY
        BEGIN CATCH
            PRINT 'Error building SQL parts: ' + ERROR_MESSAGE();
            SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error building SQL parts: ' + ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            RETURN;
        END CATCH

        -- 아래로 이동
        -------------------------------------------------------------------------
        ---- 5. 동적 SQL 조립
        -------------------------------------------------------------------------
        --BEGIN TRY
        --    IF @HasPrimaryKey = 1
        --    BEGIN
        --        /* ───────── PK가 있는 경우 ───────── */
        --        SET @SQL = N'
        --        BEGIN TRAN;
        --        ;WITH W_RAW AS (
        --            SELECT ' + @WRawSelectColumns + N'
        --            FROM ' + QUOTENAME(@TableName) + N' ' + @WhereFilter + N'
        --        )
        --        UPDATE A WITH (UPDLOCK, SERIALIZABLE)
        --        SET ' + @UpdateSetClause + N'
        --        FROM ' + QUOTENAME(@TableName) + N' A
        --        JOIN W_RAW WR ON ' + @JoinCondition + N';
        --        SET @RowCount = @@ROWCOUNT;
        --        COMMIT TRAN;';
        --    END
        --    ELSE
        --    BEGIN
        --        /* ───────── PK가 없는 경우 ───────── */
        --        DECLARE @CompositeCols NVARCHAR(MAX) =
        --            (SELECT STRING_AGG(QUOTENAME(ColumnName), ', ') WITHIN GROUP (ORDER BY Sequence) FROM @UpdateCols );

        --        SET @SQL = N'
        --        BEGIN TRAN;

        --        /* 1. 임시 테이블 */
        --        ;WITH W_RAW AS (
        --            SELECT ' + @WRawSelectColumns + N'
        --            FROM ' + QUOTENAME(@TableName) + N' ' + @WhereFilter + N'
        --        )
        --        SELECT *, CAST(NULL AS BIT) AS __ProcessedFlag
        --        INTO #UPDATE_TEMP_TABLE
        --        FROM W_RAW;

        --        /* 2. 복합 인덱스 */
        --        BEGIN TRY
        --            CREATE INDEX IX_TEMP_JOIN ON #UPDATE_TEMP_TABLE(' + @CompositeCols + N');
        --        END TRY
        --        BEGIN CATCH
        --            PRINT N''Index creation failed: '' + ERROR_MESSAGE();
        --        END CATCH;

        --        /* 3. 배치 UPDATE */
        --        DECLARE @BatchCtr INT = 0;

        --        WHILE 1=1
        --        BEGIN
        --            ;WITH T AS (
        --                SELECT TOP (@BatchSize) *
        --                FROM #UPDATE_TEMP_TABLE
        --                WHERE __ProcessedFlag IS NULL
        --            )
        --            UPDATE A WITH (UPDLOCK, SERIALIZABLE)
        --            SET ' + @UpdateSetClause + N'
        --            FROM ' + QUOTENAME(@TableName) + N' A
        --            JOIN T TMP ON ' + @JoinCondition + N';

        --            IF @@ROWCOUNT = 0 BREAK;

        --            UPDATE T SET __ProcessedFlag = 1;
        --            SET @BatchCtr += @@ROWCOUNT;
        --        END;

        --        SET @RowCount = @BatchCtr;

        --        /* 4. 정리 */
        --        DROP TABLE IF EXISTS #UPDATE_TEMP_TABLE;
        --        COMMIT TRAN;';
        --    END
        --END TRY
        --BEGIN CATCH
        --    PRINT 'Error assembling dynamic SQL: ' + ERROR_MESSAGE();
        --    RETURN;
        --END CATCH

        -------------------------------------------------------------------------
        ---- 6. 실행 또는 출력
        -------------------------------------------------------------------------
        --DECLARE @Params NVARCHAR(400) = N'@RowCount INT OUTPUT';

        --IF @DebugMode = 1
        --BEGIN
        --    PRINT '/* ===== Generated SQL ===== */';
        --    PRINT @SQL;
        --    PRINT '/* ===== End Generated SQL ===== */';
        --END
        --ELSE
        --BEGIN
        --    BEGIN TRY
        --        EXEC sp_executesql @SQL, @Params, @RowCount = @RowCount OUTPUT;

        --        PRINT 'Update completed.';
        --        PRINT 'Rows affected: ' + CAST(@RowCount AS NVARCHAR(20));
        --        PRINT 'Elapsed: ' +
        --              CAST(DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME()) AS NVARCHAR(20)) + ' ms';
        --    END TRY
        --    BEGIN CATCH
        --        PRINT 'Error executing dynamic SQL: ' + ERROR_MESSAGE();
        --        IF XACT_STATE() <> 0 ROLLBACK TRAN;
        --        RETURN;
        --    END CATCH
        --END


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
            , W_CONV_LIKE_TBL AS (
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_PROBLEM_REPORT_DEMAND') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_PRODUCTION_PLAN      ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_PSI_PRODUCTION       ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_SHIPMENT_PLAN        ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_SHIPMENT_PLAN_FG     ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_SHIPMENT_PLAN_SEMI   ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('ELECTRODE_LINE_WIDE_RATE') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('ELECTRODE_SLOC          ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('ESS_SHIP_PLAN_SITE      ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('INTRANSIT_TO_SITE       ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SCP_SIMULATOR_SHIP_FIXED_TERM') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SCS_ASSY_PACKER         ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SHIPMENT_REPORT_LOOKUP  ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SITE_MAPPING            ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP'      AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('PACKER_SCS              ') AS LOOKUP_TYPE UNION
                SELECT 'DUPLICATION' AS RTYPE, TRIM('SCM_DNM_MAT_PO        ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_OSP_SLOC      ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCP_MST_BOD           ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_CUSTOMER      ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_VENDOR        ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_SLOC          ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_SITE_CUSTOMER ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_SITE_ENG      ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_SITE_ITEM_ENG ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE UNION
                SELECT 'MASTER'      AS RTYPE, TRIM('SCM_MST_SITE_ITEM     ') AS TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE
            )
            , W_RAW AS (
                SELECT TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , STRING_AGG(MAP_COL, ', ') WITHIN GROUP (ORDER BY SEL_COL ASC) AS MAP_COL
                     , CAL_LIKE --LIKE 연산자
                     , ROW_NUMBER()OVER(ORDER BY TABLE_NAME, SEL_COL) RNUM
                FROM (
                    SELECT
                        'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
                       , LID.LOOKUP_TYPE AS LOOKUP_TYPE
                       , LID.TABLE_COL AS SEL_COL
                       --대체이름 설정
                       , ISNULL(WCO.TOO,LID.MASTER_CODETYPE) AS MAP_COL
                       , IIF(WLT.TABLE_NAME IS NOT NULL,'Y','N') AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_LOOKUP_INFO_DM LID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   LID.TABLE_COL = WCO.FR
                    LEFT OUTER JOIN W_CONV_LIKE_TBL AS WLT
                    ON   'SCM_ADM_LOOKUP_MASTER_DETAIL' = WLT.TABLE_NAME AND LID.LOOKUP_TYPE = WLT.LOOKUP_TYPE AND WLT.RTYPE = 'LOOKUP'
                    WHERE 1=1
                    AND  MASTER_CODETYPE <> 'INCOTERMS_ID'
                    AND  LOOKUP_VALID_YN = 'Y'
                    AND  'SCM_ADM_LOOKUP_MASTER_DETAIL' = @C_TABLE_NAME
                    AND  LID.LOOKUP_TYPE = @C_LOOKUP_TYPE
                    AND  'LOOKUP'   = @C_RTYPE
                    --2025-06-05 SCP_SITE_ID 추가, 실제 UPDATE 프로그램은 MASTER_CODETYPE이 PLANT_ID일경우 SCP_SITE_ID 값으로도 동시에 UPDATE 한다(2가지 다 함)
                    UNION
                    SELECT
                        'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
                       , LID.LOOKUP_TYPE AS LOOKUP_TYPE
                       , LID.TABLE_COL AS SEL_COL
                       --대체이름 설정
                       , 'SCP_SITE_ID' AS MAP_COL
                       , IIF(WLT.TABLE_NAME IS NOT NULL,'Y','N') AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_LOOKUP_INFO_DM LID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   LID.TABLE_COL = WCO.FR
                    LEFT OUTER JOIN W_CONV_LIKE_TBL AS WLT
                    ON   'SCM_ADM_LOOKUP_MASTER_DETAIL' = WLT.TABLE_NAME AND LID.LOOKUP_TYPE = WLT.LOOKUP_TYPE AND WLT.RTYPE = 'LOOKUP'
                    WHERE 1=1
                    AND  MASTER_CODETYPE <> 'INCOTERMS_ID'
                    AND  LOOKUP_VALID_YN = 'Y'
                    AND  'SCM_ADM_LOOKUP_MASTER_DETAIL' = @C_TABLE_NAME
                    AND  LID.LOOKUP_TYPE = @C_LOOKUP_TYPE
                    AND  'LOOKUP'   = @C_RTYPE
                    AND  MASTER_CODETYPE = 'PLANT_ID'
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
                     , CAL_LIKE --LIKE 연산자
                     , ROW_NUMBER()OVER(ORDER BY TABLE_NAME, SEL_COL) RNUM
                FROM (
                    SELECT
                        'SCM_CODE_LOOKUP_VALUE' AS TABLE_NAME
                       , LID.LOOKUP_TYPE AS LOOKUP_TYPE
                       , LID.TABLE_COL AS SEL_COL
                       --대체이름 설정
                       , ISNULL(WCO.TOO,LID.MASTER_CODETYPE) AS MAP_COL
                       , IIF(WLT.TABLE_NAME IS NOT NULL,'Y','N') AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_LOOKUP_CODE_INFO_DM LID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   LID.TABLE_COL = WCO.FR
                    LEFT OUTER JOIN W_CONV_LIKE_TBL AS WLT
                    ON   'SCM_CODE_LOOKUP_VALUE' = WLT.TABLE_NAME AND LID.LOOKUP_TYPE = WLT.LOOKUP_TYPE AND WLT.RTYPE = 'CODE_LOOKUP'
                    WHERE 1=1
                    AND  MASTER_CODETYPE <> 'INCOTERMS_ID'
                    AND  LOOKUP_VALID_YN = 'Y'
                    AND  'SCM_CODE_LOOKUP_VALUE' = @C_TABLE_NAME
                    AND  LID.LOOKUP_TYPE = @C_CODE_LOOKUP_TYPE
                    AND  'CODE_LOOKUP'   = @C_RTYPE
                    --2025-06-05 SCP_SITE_ID 추가, 실제 UPDATE 프로그램은 MASTER_CODETYPE이 PLANT_ID일경우 SCP_SITE_ID 값으로도 동시에 UPDATE 한다(2가지 다 함)
                    UNION
                    SELECT
                        'SCM_CODE_LOOKUP_VALUE' AS TABLE_NAME
                       , LID.LOOKUP_TYPE AS LOOKUP_TYPE
                       , LID.TABLE_COL AS SEL_COL
                       --대체이름 설정
                       , 'SCP_SITE_ID' AS MAP_COL
                       , IIF(WLT.TABLE_NAME IS NOT NULL,'Y','N') AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_LOOKUP_CODE_INFO_DM LID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   LID.TABLE_COL = WCO.FR
                    LEFT OUTER JOIN W_CONV_LIKE_TBL AS WLT
                    ON   'SCM_CODE_LOOKUP_VALUE' = WLT.TABLE_NAME AND LID.LOOKUP_TYPE = WLT.LOOKUP_TYPE AND WLT.RTYPE = 'CODE_LOOKUP'
                    WHERE 1=1
                    AND  MASTER_CODETYPE <> 'INCOTERMS_ID'
                    AND  LOOKUP_VALID_YN = 'Y'
                    AND  'SCM_CODE_LOOKUP_VALUE' = @C_TABLE_NAME
                    AND  LID.LOOKUP_TYPE = @C_CODE_LOOKUP_TYPE
                    AND  'CODE_LOOKUP'   = @C_RTYPE
                    AND  MASTER_CODETYPE = 'PLANT_ID'
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
                     , CAL_LIKE --LIKE 연산자
                     , ROW_NUMBER()OVER(ORDER BY TABLE_NAME, SEL_COL) RNUM
                FROM (
                    SELECT TABLE_NAME AS TABLE_NAME
                        , ''          AS LOOKUP_TYPE
                        , TABLE_COL   AS SEL_COL
                        , ISNULL(WCO.TOO,MASTER_CODETYPE) AS MAP_COL
                        , 'N'         AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_TARGET_INFO_DM AS TID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   TID.MASTER_CODETYPE = WCO.FR
                    where 1=1
                    and CONVERSION_FLAG <> '-'
                    AND NOT EXISTS (SELECT 1 WHERE @P_ROLLIN <> '3RD' AND TID.MASTER_CODETYPE = 'CURRENCY_ID')
                    AND TABLE_NAME = @C_TABLE_NAME
                    AND 'TABLES'   = @C_RTYPE
                    --2025-06-05 SCP_SITE_ID 추가, 실제 UPDATE 프로그램은 MASTER_CODETYPE이 PLANT_ID일경우 SCP_SITE_ID 값으로도 동시에 UPDATE 한다(2가지 다 함)
                    UNION
                    SELECT TABLE_NAME AS TABLE_NAME
                        , ''          AS LOOKUP_TYPE
                        , TABLE_COL   AS SEL_COL
                        , 'SCP_SITE_ID' AS MAP_COL
                        , 'N'         AS CAL_LIKE --LIKE 연산자
                    FROM ZNERP_TARGET_INFO_DM AS TID WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   TID.MASTER_CODETYPE = WCO.FR
                    where 1=1
                    and CONVERSION_FLAG <> '-'
                    AND TABLE_NAME = @C_TABLE_NAME
                    AND 'TABLES'   = @C_RTYPE
                    AND MASTER_CODETYPE = 'PLANT_ID'
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
                  ,MAX(CASE WHEN WR.RNUM = 13 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L13
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
                  ,MAX(CASE WHEN WR.RNUM = 13 THEN WR.SEL_COL END) B13
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
                  ,MAX(CASE WHEN WR.RNUM = 13 THEN WR.MAP_COL END) A13
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
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 13 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V13
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
                  ,MAX(CASE WHEN WR.RNUM = 13 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X13
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
            ORDER BY 1,2,rn;

        OPEN cur;

        FETCH NEXT FROM cur INTO @C_DUMMY_TBL_NM, @C_DUMMY_LK_TYPE
            ,@C_L1,@C_L2,@C_L3,@C_L4,@C_L5,@C_L6,@C_L7,@C_L8,@C_L9,@C_L10,@C_L11,@C_L12,@C_L13
            ,@C_B1,@C_B2,@C_B3,@C_B4,@C_B5,@C_B6,@C_B7,@C_B8,@C_B9,@C_B10,@C_B11,@C_B12,@C_B13
            ,@C_A1,@C_A2,@C_A3,@C_A4,@C_A5,@C_A6,@C_A7,@C_A8,@C_A9,@C_A10,@C_A11,@C_A12,@C_A13
            ,@C_V1,@C_V2,@C_V3,@C_V4,@C_V5,@C_V6,@C_V7,@C_V8,@C_V9,@C_V10,@C_V11,@C_V12,@C_V13
            ,@C_X1,@C_X2,@C_X3,@C_X4,@C_X5,@C_X6,@C_X7,@C_X8,@C_X9,@C_X10,@C_X11,@C_X12,@C_X13,@C_RN;

        WHILE @@FETCH_STATUS = 0 BEGIN

        PRINT '@C_TABLE_NAME  :'+ISNULL(@C_TABLE_NAME ,'NULL');
        PRINT '@C_DISP_TBL_NM :'+ISNULL(@C_DISP_TBL_NM,'NULL');
        PRINT '@C_LOOKUP_TYPE :'+ISNULL(@C_LOOKUP_TYPE,'NULL');
        PRINT '@C_RTYPE       :'+ISNULL(@C_RTYPE      ,'NULL');
        PRINT '@C_CAL_LIKE    :'+ISNULL(@C_CAL_LIKE   ,'NULL');
        PRINT '@C_RN          :'+ISNULL(CONVERT(NVARCHAR,@C_RN)   ,'NULL');
        --2025-09-14 초기화 처리
        SET @SQL = N'';

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
            SET @C_SEL_B1  = CASE WHEN @C_B1  IS NOT NULL THEN ' A.'+@C_B1 +' AS B1 ' ELSE ' NULL AS B1 ' END;
            SET @C_SEL_B2  = CASE WHEN @C_B2  IS NOT NULL THEN ',A.'+@C_B2 +' AS B2 ' ELSE ',NULL AS B2 ' END;
            SET @C_SEL_B3  = CASE WHEN @C_B3  IS NOT NULL THEN ',A.'+@C_B3 +' AS B3 ' ELSE ',NULL AS B3 ' END;
            SET @C_SEL_B4  = CASE WHEN @C_B4  IS NOT NULL THEN ',A.'+@C_B4 +' AS B4 ' ELSE ',NULL AS B4 ' END;
            SET @C_SEL_B5  = CASE WHEN @C_B5  IS NOT NULL THEN ',A.'+@C_B5 +' AS B5 ' ELSE ',NULL AS B5 ' END;
            SET @C_SEL_B6  = CASE WHEN @C_B6  IS NOT NULL THEN ',A.'+@C_B6 +' AS B6 ' ELSE ',NULL AS B6 ' END;
            SET @C_SEL_B7  = CASE WHEN @C_B7  IS NOT NULL THEN ',A.'+@C_B7 +' AS B7 ' ELSE ',NULL AS B7 ' END;
            SET @C_SEL_B8  = CASE WHEN @C_B8  IS NOT NULL THEN ',A.'+@C_B8 +' AS B8 ' ELSE ',NULL AS B8 ' END;
            SET @C_SEL_B9  = CASE WHEN @C_B9  IS NOT NULL THEN ',A.'+@C_B9 +' AS B9 ' ELSE ',NULL AS B9 ' END;
            SET @C_SEL_B10 = CASE WHEN @C_B10 IS NOT NULL THEN ',A.'+@C_B10+' AS B10' ELSE ',NULL AS B10' END;
            SET @C_SEL_B11 = CASE WHEN @C_B11 IS NOT NULL THEN ',A.'+@C_B11+' AS B11' ELSE ',NULL AS B11' END;
            SET @C_SEL_B12 = CASE WHEN @C_B12 IS NOT NULL THEN ',A.'+@C_B12+' AS B12' ELSE ',NULL AS B12' END;
            SET @C_SEL_B13 = CASE WHEN @C_B13 IS NOT NULL THEN ',A.'+@C_B13+' AS B13' ELSE ',NULL AS B13' END;
            SET @SQL_SA = @C_SEL_B1+@C_SEL_B2+@C_SEL_B3+@C_SEL_B4+@C_SEL_B5+@C_SEL_B6+@C_SEL_B7+@C_SEL_B8+@C_SEL_B9+@C_SEL_B10+@C_SEL_B11+@C_SEL_B12+@C_SEL_B13;
            -- CONVERSION 교체컬럼
            SET @C_SEL_A1  = CASE WHEN @C_A1  IS NOT NULL THEN IIF(@C_L1 =0,IIF(@C_V1 =0,' B1.NEW_VALUE1  AS A1  ',' B1.NEW_VALUE2  AS A1 '),' REPLACE(A.'+@C_B1 +',B1.OLD_VALUE1, B1.NEW_VALUE1)  AS A1 ') ELSE ' NULL AS A1 ' END;
            SET @C_SEL_A2  = CASE WHEN @C_A2  IS NOT NULL THEN IIF(@C_L2 =0,IIF(@C_V2 =0,',B2.NEW_VALUE1  AS A2  ',',B2.NEW_VALUE2  AS A2 '),',REPLACE(A.'+@C_B2 +',B2.OLD_VALUE1, B2.NEW_VALUE1)  AS A2 ') ELSE ',NULL AS A2 ' END;
            SET @C_SEL_A3  = CASE WHEN @C_A3  IS NOT NULL THEN IIF(@C_L3 =0,IIF(@C_V3 =0,',B3.NEW_VALUE1  AS A3  ',',B3.NEW_VALUE2  AS A3 '),',REPLACE(A.'+@C_B3 +',B3.OLD_VALUE1, B3.NEW_VALUE1)  AS A3 ') ELSE ',NULL AS A3 ' END;
            SET @C_SEL_A4  = CASE WHEN @C_A4  IS NOT NULL THEN IIF(@C_L4 =0,IIF(@C_V4 =0,',B4.NEW_VALUE1  AS A4  ',',B4.NEW_VALUE2  AS A4 '),',REPLACE(A.'+@C_B4 +',B4.OLD_VALUE1, B4.NEW_VALUE1)  AS A4 ') ELSE ',NULL AS A4 ' END;
            SET @C_SEL_A5  = CASE WHEN @C_A5  IS NOT NULL THEN IIF(@C_L5 =0,IIF(@C_V5 =0,',B5.NEW_VALUE1  AS A5  ',',B5.NEW_VALUE2  AS A5 '),',REPLACE(A.'+@C_B5 +',B5.OLD_VALUE1, B5.NEW_VALUE1)  AS A5 ') ELSE ',NULL AS A5 ' END;
            SET @C_SEL_A6  = CASE WHEN @C_A6  IS NOT NULL THEN IIF(@C_L6 =0,IIF(@C_V6 =0,',B6.NEW_VALUE1  AS A6  ',',B6.NEW_VALUE2  AS A6 '),',REPLACE(A.'+@C_B6 +',B6.OLD_VALUE1, B6.NEW_VALUE1)  AS A6 ') ELSE ',NULL AS A6 ' END;
            SET @C_SEL_A7  = CASE WHEN @C_A7  IS NOT NULL THEN IIF(@C_L7 =0,IIF(@C_V7 =0,',B7.NEW_VALUE1  AS A7  ',',B7.NEW_VALUE2  AS A7 '),',REPLACE(A.'+@C_B7 +',B7.OLD_VALUE1, B7.NEW_VALUE1)  AS A7 ') ELSE ',NULL AS A7 ' END;
            SET @C_SEL_A8  = CASE WHEN @C_A8  IS NOT NULL THEN IIF(@C_L8 =0,IIF(@C_V8 =0,',B8.NEW_VALUE1  AS A8  ',',B8.NEW_VALUE2  AS A8 '),',REPLACE(A.'+@C_B8 +',B8.OLD_VALUE1, B8.NEW_VALUE1)  AS A8 ') ELSE ',NULL AS A8 ' END;
            SET @C_SEL_A9  = CASE WHEN @C_A9  IS NOT NULL THEN IIF(@C_L9 =0,IIF(@C_V9 =0,',B9.NEW_VALUE1  AS A9  ',',B9.NEW_VALUE2  AS A9 '),',REPLACE(A.'+@C_B9 +',B9.OLD_VALUE1, B9.NEW_VALUE1)  AS A9 ') ELSE ',NULL AS A9 ' END;
            SET @C_SEL_A10 = CASE WHEN @C_A10 IS NOT NULL THEN IIF(@C_L10=0,IIF(@C_V10=0,',B10.NEW_VALUE1 AS A10 ',',B10.NEW_VALUE2 AS A10'),',REPLACE(A.'+@C_B10+',B10.OLD_VALUE1,B10.NEW_VALUE1) AS A10') ELSE ',NULL AS A10' END;
            SET @C_SEL_A11 = CASE WHEN @C_A11 IS NOT NULL THEN IIF(@C_L11=0,IIF(@C_V11=0,',B11.NEW_VALUE1 AS A11 ',',B11.NEW_VALUE2 AS A11'),',REPLACE(A.'+@C_B11+',B11.OLD_VALUE1,B11.NEW_VALUE1) AS A11') ELSE ',NULL AS A11' END;
            SET @C_SEL_A12 = CASE WHEN @C_A12 IS NOT NULL THEN IIF(@C_L12=0,IIF(@C_V12=0,',B12.NEW_VALUE1 AS A12 ',',B12.NEW_VALUE2 AS A12'),',REPLACE(A.'+@C_B12+',B12.OLD_VALUE1,B12.NEW_VALUE1) AS A12') ELSE ',NULL AS A12' END;
            SET @C_SEL_A13 = CASE WHEN @C_A13 IS NOT NULL THEN IIF(@C_L13=0,IIF(@C_V13=0,',B13.NEW_VALUE1 AS A13 ',',B13.NEW_VALUE2 AS A13'),',REPLACE(A.'+@C_B13+',B13.OLD_VALUE1,B13.NEW_VALUE1) AS A13') ELSE ',NULL AS A13' END;

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
            SET @SQL_SM = @C_SEL_A1+@C_SEL_A2+@C_SEL_A3+@C_SEL_A4+@C_SEL_A5+@C_SEL_A6+@C_SEL_A7+@C_SEL_A8+@C_SEL_A9+@C_SEL_A10+@C_SEL_A11+@C_SEL_A12+@C_SEL_A13;

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
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B13 IS NOT NULL THEN QUOTENAME(@C_B13)+'='+@C_A13 ELSE '' END;

            SET @SQL_STMT = '
                SELECT DISTINCT '''+@C_DISP_TBL_NM/*@C_LOOKUP_TYPE @C_TABLE_NAME*/+''' AS TABLE_NAME, '+@SQL_SA+','+@SQL_SM+'
                --SELECT TOP 2 '''+@C_DISP_TBL_NM/*@C_LOOKUP_TYPE @C_TABLE_NAME*/+''' AS TABLE_NAME, '+@SQL_SA+','+@SQL_SM+'
                      ,'+@ColumnsToSelect+'
                /*FROM   DBO.' + QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)*/
                /*FROM [DBO].' + QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)*/
                FROM '+QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)';

            DECLARE @V_PLANT_ID NVARCHAR(128);
            SET @V_PLANT_ID = NULL;
            IF (@C_V1 + @C_V2 + @C_V3 + @C_V4 + @C_V5 + @C_V6 + @C_V7 + @C_V8 + @C_V9 + @C_V10 + @C_V11 + @C_V12 + @C_V13) >= 1 BEGIN
                IF @C_RTYPE IN ( 'CODE_LOOKUP', 'LOOKUP' ) BEGIN
                    SET @V_PLANT_ID = 'PLANT_ID';
                    END
                ELSE IF @C_RTYPE = 'TABLES' BEGIN
                    SELECT TOP 1 @V_PLANT_ID = TID.TABLE_COL
                    FROM   ZNERP_TARGET_INFO_DM AS TID WITH(NOLOCK)
                    WHERE  1=1
                    AND    TID.TABLE_NAME = @C_TABLE_NAME
                    AND    TID.MASTER_CODETYPE = N'PLANT_ID'
                    ORDER BY CASE WHEN TABLE_COL  = 'STORAGE_PLANT_ID' THEN 1
                                  WHEN TABLE_COL  = 'PLANT_ID' THEN 2
                                  WHEN TABLE_COL  = 'PLANT_CD' THEN 3
                                  WHEN TABLE_COL LIKE '%SITE_ID%' THEN 9
                                ELSE 8 END;
                    SET @V_PLANT_ID = ISNULL(@V_PLANT_ID,'');
                    END;
                END;
            ELSE BEGIN
                SET @V_PLANT_ID = 'PLANT_ID';
            END;

        IF @C_RN >= 1 BEGIN
          IF @C_L1 = 0 BEGIN
            IF @C_V1 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B1 ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V1 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B1  ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B1.OLD_VALUE1';
            END
          END



          ELSE IF @C_L1 = 1 BEGIN
            IF @C_V1 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B1 ON A.' + QUOTENAME(@C_B1 ) + (CASE WHEN @C_X1 = 0 THEN ' LIKE '+'''%''+B1.OLD_VALUE1+''%''' ELSE ' = B1.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B2 ON A.' + QUOTENAME(@C_B2 ) + ' = B2.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B3 ON A.' + QUOTENAME(@C_B3 ) + ' = B3.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B4 ON A.' + QUOTENAME(@C_B4 ) + ' = B4.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B5 ON A.' + QUOTENAME(@C_B5 ) + ' = B5.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B6 ON A.' + QUOTENAME(@C_B6 ) + ' = B6.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B7 ON A.' + QUOTENAME(@C_B7 ) + ' = B7.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B8 ON A.' + QUOTENAME(@C_B8 ) + ' = B8.OLD_VALUE1';
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
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B9 ON A.' + QUOTENAME(@C_B9 ) + ' = B9.OLD_VALUE1';
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
        END;
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
        IF @C_RN >= 13 BEGIN
          IF @C_L13 = 0 BEGIN
            IF @C_V13 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A13)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B13 ON A.' + QUOTENAME(@C_B13) + ' = B13.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V13 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A13)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B13 ON A.' + QUOTENAME(@C_B13) + ' = B13.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B13.OLD_VALUE1';
            END
          END
          ELSE IF @C_L13 = 1 BEGIN
            IF @C_V13 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A13)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B13 ON A.' + QUOTENAME(@C_B13) + (CASE WHEN @C_X13 = 0 THEN ' LIKE '+'''%''+B13.OLD_VALUE1+''%''' ELSE ' = B13.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V13 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A13)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B13 ON A.' + QUOTENAME(@C_B13) + ' = B13.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B13.OLD_VALUE1';
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
        ELSE IF @C_RN = 13 BEGIN
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
                  OR  B13.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;

        SET @SQL_ISNOTNULL = ISNULL(@SQL_ISNOTNULL,N'');

            IF @C_RTYPE = 'LOOKUP' BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE') + ' = '''+@C_LOOKUP_TYPE+'''
            AND   A.VALID_YN = ''Y'' ' + @SQL_ISNOTNULL;
            END;
            ELSE IF @C_RTYPE = 'CODE_LOOKUP' BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE_CODE') + ' = '''+@C_LOOKUP_TYPE+'''
            AND   A.ACTIVE_FLAG = ''Y'' ' + @SQL_ISNOTNULL;
            END;
            ELSE BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1 ' + @SQL_ISNOTNULL;
            END;

         --   SET @SQL_STMT = '            ;WITH W_RAW AS ('+@SQL_STMT;
         --   SET @SQL_STMT = @SQL_STMT+'
         --   )
         --   /* '+@SharedUpdateSetClause+' */
         --   --SELECT * FROM W_RAW
         --   /* SELECT *
         --   '+@SharedFromJoinOnClause+'
            --ORDER BY 2,3,4,5,6,7,8,9,10; */
         --   ';
            --SET @SQL_STMT +=@SharedUpdateSetClause+@SharedFromJoinOnClause+';';

            --SET @DUMMY = @SQL_STMT;
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

            --BEGIN TRY
            --    EXEC sp_executesql @SQL_STMT;
            --    SET @ExecutionRST = 'Success';
            --END TRY
            --BEGIN CATCH
            --    SET @ExecutionRST = ERROR_MESSAGE();
            --    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
            --END CATCH;

            --PRINT @ExecutionRST;



        -----------------------------------------------------------------------
        -- 5. 동적 SQL 조립
        -----------------------------------------------------------------------
        BEGIN TRY
            --IF @HasPrimaryKey = 1
            IF @P_ROLLIN IN ('5TH','4N5') AND @TableName = 'SCM_DNM_STOCK_SALES'
            BEGIN
                DROP TABLE IF EXISTS #UPDATE_TEMP_TABLE;
                DECLARE @CompositeCols NVARCHAR(MAX) =
                    (SELECT STRING_AGG(QUOTENAME(a.ColumnName), ', ') WITHIN GROUP (ORDER BY Sequence) FROM @UpdateCols a JOIN @AllCols b ON a.ColumnName = b.ColumnName WHERE b.max_length <> -1 );

                SET @SQL_STMT = N'
                --BEGIN TRAN;
                /* 1. 임시 테이블 */
                ;WITH W_RAW AS ('+@SQL_STMT+N'
                )
                SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS __UniqueID,
                       --HARD CODING
                       ROW_NUMBER() OVER (PARTITION BY [RESULT_DATE], ISNULL(A1, [COMPANY_ID]), [DIVISION_ID], ISNULL(A2, [PLANT_ID]), ISNULL(A3, [STORAGE_ID]), [ITEM_ID], [ORIGIN_ITEM_ID] ORDER BY [STORAGE_ID]) AS __Dup_ID,
                       SUM(QTY) OVER (PARTITION BY [RESULT_DATE], ISNULL(A1, [COMPANY_ID]), [DIVISION_ID], ISNULL(A2, [PLANT_ID]), ISNULL(A3, [STORAGE_ID]), [ITEM_ID], [ORIGIN_ITEM_ID] ) AS __SUM_QTY,
                       SUM(HOLD_QTY) OVER (PARTITION BY [RESULT_DATE], ISNULL(A1, [COMPANY_ID]), [DIVISION_ID], ISNULL(A2, [PLANT_ID]), ISNULL(A3, [STORAGE_ID]), [ITEM_ID], [ORIGIN_ITEM_ID] ) AS __SUM_HOLD_QTY,
                       *,
                       CAST(NULL AS BIT) AS __ProcessedFlag
                INTO #UPDATE_TEMP_TABLE
                FROM W_RAW;

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

                /* 3. 배치 UPDATE */
                DECLARE @BatchCtr INT = 0;
                DECLARE @DUMMY NVARCHAR(MAX);

                SET @DUMMY = (SELECT COUNT(*) FROM #UPDATE_TEMP_TABLE WHERE __Dup_ID = 1);
                PRINT ''__Dup_ID = 1 :''+@DUMMY;
                SET @DUMMY = (SELECT COUNT(*) FROM #UPDATE_TEMP_TABLE WHERE __Dup_ID > 1);
                PRINT ''__Dup_ID > 1 :''+@DUMMY;

                WHILE 1=1
                BEGIN
                    ;WITH W_RAW AS (
                        SELECT TOP (@BatchSize) *
                        FROM #UPDATE_TEMP_TABLE
                        --중복일경우 1개 만
                        WHERE __ProcessedFlag IS NULL AND __Dup_ID = 1
                        ORDER BY __UniqueID
                    )
                    --UPDATE A WITH (UPDLOCK, SERIALIZABLE)
                    UPDATE A
                    SET ' + @UpdateSetClause + N'
                         --값이 BLANK인 것이 있어서 BLANK일 경우 과거값 지속한다.
                         , A.STORAGE_DESCRIPTION = (CASE WHEN ISNULL(NRV.DESC2,'''') = '''' THEN A.STORAGE_DESCRIPTION ELSE NRV.DESC2 END)
                         , A.QTY = __SUM_QTY --수량 합친것으로 UPDATE
                         , A.HOLD_QTY = __SUM_HOLD_QTY --수량 합친것으로 UPDATE
                         , A.LAST_UPDATED_BY = '''+ @CREATED_BY +N'''
                         , A.LAST_UPDATE_DATE = GETDATE()
                         , A.ATTRIBUTE7= A.[PLANT_ID]
                         , A.ATTRIBUTE8= ISNULL(WR.A2, A.[PLANT_ID])
                         , A.ATTRIBUTE9= A.[STORAGE_ID]
                         , A.ATTRIBUTE10= ISNULL(WR.A3, A.[STORAGE_ID])
                    --SELECT *
                    FROM ' + QUOTENAME(@TableName) + N' A
                    JOIN W_RAW AS WR ON ' + @JoinCondition + N'
                    LEFT JOIN NERP_CONV_OLD_NEW_REF_V AS NRV ON NRV.CODETYPE = ''STORAGE_ID'' AND ISNULL(WR.A2, A.[PLANT_ID]) = NRV.NEW_VALUE1 AND ISNULL(WR.A3, A.[STORAGE_ID]) = NRV.NEW_VALUE2;

                    IF @@ROWCOUNT = 0 BREAK;

                    ;WITH W_RAW AS (
                        SELECT TOP (@BatchSize) *
                        FROM   #UPDATE_TEMP_TABLE
                        WHERE  __ProcessedFlag IS NULL AND __Dup_ID = 1
                        ORDER BY __UniqueID
                    )
                    UPDATE UTT
                    SET    UTT.__ProcessedFlag = 1
                    FROM   #UPDATE_TEMP_TABLE AS UTT
                    JOIN   W_RAW AS WR ON WR.__UniqueID = UTT.__UniqueID
                    WHERE  UTT.__ProcessedFlag IS NULL;
                    SET @BatchCtr += @@ROWCOUNT;
                END;

                --중복 데이터 삭제 __Dup_ID > 1 큰것
                ;WITH W_RAW AS (
                    SELECT TOP (@BatchSize) *
                    FROM #UPDATE_TEMP_TABLE
                    --중복일경우 1개 만
                    WHERE __ProcessedFlag IS NULL AND __Dup_ID > 1
                    ORDER BY __UniqueID
                )
                --UPDATE A WITH (UPDLOCK, SERIALIZABLE)
                DELETE A
                --SELECT *
                FROM ' + QUOTENAME(@TableName) + N' A
                JOIN W_RAW AS WR ON ' + @JoinCondition + N';

                SET @DUMMY = (SELECT COUNT(*) FROM ' + QUOTENAME(@TableName) + N' A
                                              JOIN #UPDATE_TEMP_TABLE AS WR ON ' + @JoinCondition + N');
                PRINT ''Final Alive Join Count :''+@DUMMY;

                SET @DUMMY = (SELECT COUNT(*) FROM ' + QUOTENAME(@TableName) + N');
                PRINT ''Final Alive Full Count :''+@DUMMY;

                SET @RowCount = @BatchCtr;

                /* 4. 정리 */
                DROP TABLE IF EXISTS #UPDATE_TEMP_TABLE;
                --COMMIT TRAN;';

            END
            ELSE BEGIN
                IF @HasPrimaryKey = 1
                BEGIN
                    /* ───────── PK가 있는 경우 ───────── */

                    --SET @SQL_STMT = '            ;WITH W_RAW AS ('+@SQL_STMT;
                    --SET @SQL_STMT = @SQL_STMT+'
                    --)
                    /* '+@SharedUpdateSetClause+' */
                    --SELECT * FROM W_RAW
                    /* SELECT *
                    '+@SharedFromJoinOnClause+'
                    ORDER BY 2,3,4,5,6,7,8,9,10; */
                    --';


                    SET @SQL_STMT = N'
                    --BEGIN TRAN;
                    ;WITH W_RAW AS ('+@SQL_STMT+N'
                    )
                    UPDATE A WITH (UPDLOCK, SERIALIZABLE)
                    SET ' + @UpdateSetClause + N'
                    FROM ' + QUOTENAME(@TableName) + N' A
                    JOIN W_RAW WR ON ' + @JoinCondition + N';
                    SET @RowCount = @@ROWCOUNT;
                    --COMMIT TRAN;';

                --INSERT INTO DROP_PLOG(PGM_NM,MSG)VALUES( @v_program_name,'PK:'+@C_TABLE_NAME+','+ISNULL(@SQL_STMT,'NULL') );
                --SELECT * FROM DROP_PLOG WHERE LOGTIME > GETDATE()-0.5 ORDER BY LOGID DESC;

                END
                ELSE
                BEGIN
                    /* ───────── PK가 없는 경우 ───────── */
                    SET  @CompositeCols =
                        (SELECT STRING_AGG(QUOTENAME(a.ColumnName), ', ') WITHIN GROUP (ORDER BY Sequence) FROM @UpdateCols a JOIN @AllCols b ON a.ColumnName = b.ColumnName WHERE b.max_length <> -1 );

                    SET @SQL_STMT = N'
                    --BEGIN TRAN;
                    /* 1. 임시 테이블 */
                    ;WITH W_RAW AS ('+@SQL_STMT+N'
                    )
                    SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS __UniqueID,
                           *,
                           CAST(NULL AS BIT) AS __ProcessedFlag
                    INTO #UPDATE_TEMP_TABLE
                    FROM W_RAW;

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

                    /* 3. 배치 UPDATE */
                    DECLARE @BatchCtr INT = 0;

                    WHILE 1=1
                    BEGIN
                        ;WITH W_RAW AS (
                            SELECT TOP (@BatchSize) *
                            FROM #UPDATE_TEMP_TABLE
                            WHERE __ProcessedFlag IS NULL
                            ORDER BY __UniqueID
                        )
                        --UPDATE A WITH (UPDLOCK, SERIALIZABLE)
                        UPDATE A
                        SET ' + @UpdateSetClause + N'
                        --SELECT *
                        FROM ' + QUOTENAME(@TableName) + N' A
                        JOIN W_RAW AS WR ON ' + @JoinCondition + N';

                        IF @@ROWCOUNT = 0 BREAK;

                        ;WITH W_RAW AS (
                            SELECT TOP (@BatchSize) *
                            FROM   #UPDATE_TEMP_TABLE
                            WHERE  __ProcessedFlag IS NULL
                            ORDER BY __UniqueID
                        )
                        UPDATE UTT
                        SET    UTT.__ProcessedFlag = 1
                        FROM   #UPDATE_TEMP_TABLE AS UTT
                        JOIN   W_RAW AS WR ON WR.__UniqueID = UTT.__UniqueID
                        WHERE  UTT.__ProcessedFlag IS NULL;
                        SET @BatchCtr += @@ROWCOUNT;
                    END;

                    SET @RowCount = @BatchCtr;

                    /* 4. 정리 */
                    DROP TABLE IF EXISTS #UPDATE_TEMP_TABLE;
                    --COMMIT TRAN;';

                --INSERT INTO DROP_PLOG(PGM_NM,MSG)VALUES( @v_program_name,'NonPK:'+@C_TABLE_NAME+','+ISNULL(@SQL_STMT,'NULL') );
                --SELECT * FROM DROP_PLOG WHERE LOGTIME > GETDATE()-0.5 ORDER BY LOGID DESC;

                END
            END
        END TRY
        BEGIN CATCH
            PRINT 'Error assembling dynamic SQL: ' + ERROR_MESSAGE();
            SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error assembling dynamic SQL: ' + ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            RETURN;
        END CATCH


        -----------------------------------------------------------------------
        -- 6. 실행 또는 출력
        -----------------------------------------------------------------------
        DECLARE @Params NVARCHAR(400) = N'@BatchSize INT = 1000000, @RowCount INT OUTPUT';

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

                PRINT 'Update completed.';
                PRINT 'Rows affected: ' + CAST(@RowCount AS NVARCHAR(20));
                PRINT 'Elapsed: ' +
                      CAST(DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME()) AS NVARCHAR(20)) + ' ms';
            END TRY
            BEGIN CATCH
                PRINT 'Error executing dynamic SQL: ' + ERROR_MESSAGE();
                --IF XACT_STATE() <> 0 ROLLBACK TRAN;
                SET @DUMMY = @C_DISP_TBL_NM+','+@v_description+','+'Error executing dynamic SQL: ' + ERROR_MESSAGE();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
                --에러 나도 계속 실생되어야 한다.
                --RETURN;
            END CATCH
        END






            FETCH NEXT FROM cur INTO @C_DUMMY_TBL_NM, @C_DUMMY_LK_TYPE
                ,@C_L1,@C_L2,@C_L3,@C_L4,@C_L5,@C_L6,@C_L7,@C_L8,@C_L9,@C_L10,@C_L11,@C_L12,@C_L13
                ,@C_B1,@C_B2,@C_B3,@C_B4,@C_B5,@C_B6,@C_B7,@C_B8,@C_B9,@C_B10,@C_B11,@C_B12,@C_B13
                ,@C_A1,@C_A2,@C_A3,@C_A4,@C_A5,@C_A6,@C_A7,@C_A8,@C_A9,@C_A10,@C_A11,@C_A12,@C_A13
                ,@C_V1,@C_V2,@C_V3,@C_V4,@C_V5,@C_V6,@C_V7,@C_V8,@C_V9,@C_V10,@C_V11,@C_V12,@C_V13
                ,@C_X1,@C_X2,@C_X3,@C_X4,@C_X5,@C_X6,@C_X7,@C_X8,@C_X9,@C_X10,@C_X11,@C_X12,@C_X13,@C_RN;

        END;

        CLOSE cur;
        DEALLOCATE cur
        ;

        --################################################################
        -- Log
        --################################################################
            SET @END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            SET @RUN_TIME = DATEDIFF(SECOND, @START_TIME, @END_TIME);
            SET @DUMMY = 'END -->> '+concat(

            '     @CNT = ' , @CNT
            , ' , @C_DISP_TBL_NM = ', @C_DISP_TBL_NM
            , ' , @P_ROLLIN = ' , @P_ROLLIN
            , ' , @START_TIME = ' , @START_TIME
            , ' , @END_TIME = '   , @END_TIME
            , ' , @RUN_TIME = '   , @RUN_TIME
            );

            --처음 1회만 테이블이 바뀔때 처리
            IF @C_PRINT_YN = 1
            BEGIN
                PRINT @DUMMY;
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'RUN', @RUN_TIME, @C_DISP_TBL_NM,  @DUMMY, @d_event_date;
            END;

        FETCH NEXT FROM cur_CUTOFF_COL INTO @C_TABLE_NAME, @C_LOOKUP_TYPE, @C_R_N_R, @C_RTYPE, @C_RNUM, @C_SORT_SEQ;

    END;

    CLOSE cur_CUTOFF_COL;
    DEALLOCATE cur_CUTOFF_COL;

    SET @BATCH_END_TIME = SYSDATETIME();
    SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME);
    PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME);
    SET @DUMMY = 'END,'+@v_description+', RUN_TIME ';
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  @DUMMY, @BATCH_END_TIME;

END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR';
        PRINT ERROR_MESSAGE();


END CATCH;

END;
