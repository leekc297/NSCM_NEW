

-- =============================================
-- Author:       P.C.I
-- Create date:  2024-03-29
-- Description:  table info data converter(PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_SSP Copy)
-- =============================================
/*
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2025-05-02   김준규      NERP) ROLLIN 차수 PARAMETER화
 * 2025-05-11   김준규      NERP) @mDisQueryDel에서 `중복되면 목록에서 삭제` 항목 제외처리
 * 2025-05-21   김준규      NERP) DM_MAT_DOC_STORAGE_ID OPEN법인 추가필요, PR_SCM_DNM_MAT_DOCUMENT : 자재 입/출고 정보 I/F 사용.(현재 사용하는 것만 등록됨)
 * 2025-06-29   김준규      NERP) INCOTERMS는 손 대면 안됨. 


EXEC PR_SCP_NERP_COLUMN_CONVERTER_INSERT_FROM_PROD_LOOKUP_AND_MASTER_DM 'LOOKUP'

EXEC [dbo].[PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE ='DM_EXCEPT_SALES_SITE_MAPPING'
  , @P_ROLLIN = '3RD'


EXEC [dbo].[PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE ='DM_MAT_DOC_STORAGE_ID'
  , @P_ROLLIN = '2ND'

EXEC [dbo].[PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE =''
  , @P_ROLLIN = '2ND'
*/
CREATE PROCEDURE [dbo].[PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE NVARCHAR(150)
  , @P_ROLLIN  nvarchar(30) --1ST 2ND 3RD 4TH
AS
BEGIN

    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

    --------------------------------------------------------------------------------------------
    BEGIN TRY
    --------------------------------------------------------------------------------------------
    --BEGIN TRANSACTION;
    --------------------------------------------------------------------------------------------


    DECLARE @LOOKUP_TYPE   NVARCHAR(150) = N'';
    DECLARE @TABLE_NAME   NVARCHAR(150) = N'';
    DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N'';
    DECLARE @COL_INFO   NVARCHAR(150) = N'';
    DECLARE @TABLE_COL   NVARCHAR(150) = N'';
    DECLARE @TABLE_COL2   NVARCHAR(150) = N'';
    DECLARE @TABLE_COL3   NVARCHAR(150) = N'';
    DECLARE @PLANT_COL1   NVARCHAR(150) = N'';
    DECLARE @MASTER_CODETYPE   NVARCHAR(150) = N'';
    DECLARE @MASTER_CODETYPE2   NVARCHAR(150) = N'';
    DECLARE @MASTER_CODETYPE3   NVARCHAR(150) = N'';
    DECLARE @RNUM NVARCHAR(150);
    DECLARE @CNT INT;
    DECLARE @SELECT_COL NVARCHAR(MAX);
    DECLARE @mEXEC NVARCHAR(MAX);
    DECLARE @BACKUP_START_TIME  NVARCHAR(50) = N'';
    DECLARE @BACKUP_END_TIME  NVARCHAR(50) = N'';
    DECLARE @UPDATE_START_TIME  NVARCHAR(50) = N'';
    DECLARE @UPDATE_END_TIME  NVARCHAR(50) = N'';
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_DM_'+@P_ROLLIN;


    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_DM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    --@@ROWCOUNT
    DECLARE @UPDATE_CNT_INCOTERMS INT;
    DECLARE @UPDATE_CNT_PLANT INT;
    SET @UPDATE_CNT_INCOTERMS = 0;
    SET @UPDATE_CNT_PLANT = 0;
    --------------------------------------------------
    --STEP 0. TARGET TABLE BACKUP
    --------------------------------------------------
    BEGIN
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL]') AND type in (N'U'))
        BEGIN
            DROP TABLE [dbo].[BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL];
        END

        SELECT *
        INTO [dbo].[BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL]
        FROM SCM_ADM_LOOKUP_MASTER_DETAIL;
    END

    ------------------------------------------------------
    --STEP 1. DUPLICATE COLUMNS HANDLE
    ------------------------------------------------------
    IF CURSOR_STATUS('global', 'LOOKUP_CURSOR_B') >= 0
    BEGIN
        CLOSE LOOKUP_CURSOR_B;
        DEALLOCATE LOOKUP_CURSOR_B;
    END
    DECLARE LOOKUP_CURSOR_B CURSOR FOR
        --룩업 타입에서 컬럼당 CONV_MASTER가 한개, 또는 2개~3개를 순서적으로 CONVERSION할때,
        --각각 컬럼당 CONV_MASTER가 1회만 만 가능하여 여러번 하게 됨.
        SELECT DISTINCT LOOKUP_TYPE,RNUM
        FROM (
            SELECT LOOKUP_TYPE,TABLE_COL, MASTER_CODETYPE
                  ,ROW_NUMBER()OVER(PARTITION BY LOOKUP_TYPE,TABLE_COL ORDER BY MASTER_CODETYPE ) RNUM
            FROM   ZNERP_LOOKUP_INFO_DM
            WHERE  1=1
            --AND    CONVERSION_FLAG = 'N'
            AND    MASTER_CODETYPE <> 'INCOTERMS_ID'
            AND    LOOKUP_VALID_YN = 'Y'
            AND    (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR @P_LOOKUP_TYPE ='ALL' OR LOOKUP_TYPE = @P_LOOKUP_TYPE)
        ) X
        ORDER BY LOOKUP_TYPE,RNUM ASC

    OPEN LOOKUP_CURSOR_B;
    FETCH NEXT FROM LOOKUP_CURSOR_B
    INTO @LOOKUP_TYPE,@RNUM

    WHILE @@FETCH_STATUS = 0
    BEGIN

    ------------------------------------------------------
    --STEP 2. TARGET TABLE UPDATE
    ------------------------------------------------------
    BEGIN
        declare @p nvarchar(max) = '';
        DECLARE @WORK_AVALIABLE TABLE (TABLE_COL NVARCHAR(150), MASTER_CODETYPE NVARCHAR(150));

        DECLARE LOOKUP_CURSOR CURSOR FOR
        SELECT DISTINCT LOOKUP_TYPE
        FROM   ZNERP_LOOKUP_INFO_DM WITH(NOLOCK)
        WHERE  1=1
        --AND    CONVERSION_FLAG = 'N'
        AND    LOOKUP_TYPE = @LOOKUP_TYPE
        AND    MASTER_CODETYPE <> 'INCOTERMS_ID'
        AND    LOOKUP_VALID_YN = 'Y'
        ;

        OPEN LOOKUP_CURSOR;
        FETCH NEXT FROM LOOKUP_CURSOR
        INTO @LOOKUP_TYPE

        WHILE @@FETCH_STATUS = 0
        BEGIN
            DELETE 
            FROM @WORK_AVALIABLE;

            SET @mEXEC = N'';
            SET @mEXEC = @mEXEC + N'
            --룩업 타입에서 컬럼당 CONV_MASTER가 한개, 또는 2개~3개를 순서적으로 CONVERSION할때,
            --각각 컬럼당 CONV_MASTER가 1회만 만 가능하여 여러번 하게 됨.
            --MASTER_CODETYPE 가 ''SITE_ID'' 일 경우 ''SCP_SITE_ID'' 값으로 대체하여 처리
            SELECT TABLE_COL, MASTER_CODETYPE
            FROM (
                SELECT TABLE_COL, MASTER_CODETYPE= IIF(MASTER_CODETYPE = ''SITE_ID'',''SCP_SITE_ID'',MASTER_CODETYPE)
                      ,ROW_NUMBER()OVER(PARTITION BY TABLE_COL ORDER BY CASE WHEN MASTER_CODETYPE IN ( ''END_CUSTOMER_ID'',''VENDOR_ID'') THEN 1
                            WHEN MASTER_CODETYPE = ''SCP_SITE_ID'' THEN 2
                            WHEN MASTER_CODETYPE = ''PLANT_ID'' THEN 3
                            WHEN MASTER_CODETYPE = ''COMPANY_ID'' THEN 4
                           ELSE 99 END) RNUM
            FROM   ZNERP_LOOKUP_INFO_DM
                WHERE  1=1
                AND    LOOKUP_TYPE = ''' + @LOOKUP_TYPE + '''
                AND    MASTER_CODETYPE <> ''INCOTERMS_ID''
                AND    LOOKUP_VALID_YN = ''Y''
            ) X
            WHERE RNUM = '''+@RNUM+''' ';
            PRINT @mEXEC;
            INSERT @WORK_AVALIABLE EXEC SP_EXECUTESQL @mEXEC ;
            -----------------------------------------------
            -- STEP 2-1. DISTINCT COLUMN STRING MAKE
            -- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
            -----------------------------------------------
            BEGIN
                DECLARE  @mDisQuery NVARCHAR(MAX) = '';
                DECLARE  @mDisQueryDel NVARCHAR(MAX) = '';
                DECLARE  @mSubQuery NVARCHAR(MAX) = '';
                DECLARE  @mUpdateQuery NVARCHAR(MAX) = '';
                DECLARE  @mInsertQuery NVARCHAR(MAX) = '';
                DECLARE  @mInsertQuerySegment1 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQuerySegment2 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQuerySegment3 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQuerySegment4 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQuerySegment5 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQueryAttribute1 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQueryAttribute2 NVARCHAR(MAX) = '';
                DECLARE  @mInsertQueryAttribute3 NVARCHAR(MAX) = '';
                DECLARE  @mUpdateWhereQuery NVARCHAR(MAX) = '';
                DECLARE  @mInsertWhereQuery NVARCHAR(MAX) = '';
                DECLARE  @mTableQuery NVARCHAR(MAX) = '';
                DECLARE  @mPartitionBy NVARCHAR(MAX) = '';
                DECLARE  @mPartitionBySegment1 NVARCHAR(MAX) = '';
                DECLARE  @mPartitionBySegment2 NVARCHAR(MAX) = '';
                DECLARE  @mPartitionBySegment3 NVARCHAR(MAX) = '';
                DECLARE  @mPartitionBySegment4 NVARCHAR(MAX) = '';
                DECLARE  @mPartitionBySegment5 NVARCHAR(MAX) = '';

                SET @mDisQuery = '';
                SET @mDisQueryDel = '';
                SET @mSubQuery = '';
                SET @mUpdateQuery = '';
                SET @mInsertQuery = '';
                SET @mInsertQuerySegment1 = ', A.SEGMENT1';
                SET @mInsertQuerySegment2 = ', A.SEGMENT2';
                SET @mInsertQuerySegment3 = ', A.SEGMENT3';
                SET @mInsertQuerySegment4 = ', A.SEGMENT4';
                SET @mInsertQuerySegment5 = ', A.SEGMENT5';
                SET @mInsertQueryAttribute1 = ', A.ATTRIBUTE1';
                SET @mInsertQueryAttribute2 = ', A.ATTRIBUTE2';
                SET @mInsertQueryAttribute3 = ', A.ATTRIBUTE3';
                SET @mUpdateWhereQuery = '';
                SET @mInsertWhereQuery = '';
                SET @mTableQuery = '';
                SET @mPartitionBy = '';
                SET @mPartitionBySegment1 = ', A.SEGMENT1';
                SET @mPartitionBySegment2 = ', A.SEGMENT2';
                SET @mPartitionBySegment3 = ', A.SEGMENT3';
                SET @mPartitionBySegment4 = ', A.SEGMENT4';
                SET @mPartitionBySegment5 = ', A.SEGMENT5';
                DECLARE @PRIFIX NVARCHAR(30);

                DECLARE LOOKUP_CURSOR2 CURSOR FOR SELECT TABLE_COL, MASTER_CODETYPE FROM @WORK_AVALIABLE ORDER BY TABLE_COL
                SET @CNT = 1;

                OPEN LOOKUP_CURSOR2;
                FETCH NEXT FROM LOOKUP_CURSOR2
                INTO  @TABLE_COL3, @MASTER_CODETYPE3;

                PRINT @TABLE_NAME + '1. ' +CONVERT(CHAR(23), GETDATE(), 21);

                WHILE @@FETCH_STATUS = 0
                BEGIN

                    --@@ROWCOUNT
                    DECLARE @UPDATE_CNT INT;
                    SET @UPDATE_CNT = 0;
                    -----------------------------------------------
                    -- STEP 2-1. DISTINCT COLUMN STRING MAKE
                    -- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
                    -----------------------------------------------
                    BEGIN
                        IF @mDisQuery = '' AND @mDisQueryDel = ''

                        BEGIN  --처음인경우
                            IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                            BEGIN
                                SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            END
                            ELSE
                            BEGIN
                                SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            END

                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL ' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL )' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            -- 아래는 컨버전 데이터가 중복되면 목록에서 삭제
                            -- INSERT가 중복되지 않게 하기 때문에 아래 막음(기존 이미 입력이 되어 있고, 아직 컨버전 되어야 할 대상이 남아 있음 그래서 막음)
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' OR ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IN ( SELECT DISTINCT ' + @TABLE_COL3 + ' FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''' + @LOOKUP_TYPE + ''' AND VALID_YN = ''Y'')) ' -- 컨버전 데이터가 중복되면 목록에서 삭제

                        END
                        ELSE
                        BEGIN --두번째인경우
                            IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                            BEGIN
                                SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            END
                            ELSE
                            BEGIN
                                SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            END
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL ' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL )' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            -- 아래는 컨버전 데이터가 중복되면 목록에서 삭제
                            -- INSERT가 중복되지 않게 하기 때문에 아래 막음(기존 이미 입력이 되어 있고, 아직 컨버전 되어야 할 대상이 남아 있음 그래서 막음)
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' OR ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IN ( SELECT DISTINCT ' + @TABLE_COL3 + ' FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) WHERE LOOKUP_TYPE = ''' + @LOOKUP_TYPE + ''' AND VALID_YN = ''Y'')) ' -- 컨버전 데이터가 중복되면 목록에서 삭제

                        END
                    END

                    -----------------------------------------------
                    -- STEP 2-2. DISTINCT COLUMN STRING MAKE
                    -- LEFT JOIN NERP_CONV_MASTER_CFM_V B1
                    -- ON A.COMPANY_ID = B1.FROM_COMPANY_ID
                    -- AND B1.CODETYPE = 'COMPANY_ID'
                    -----------------------------------------------
                    BEGIN
                        IF @MASTER_CODETYPE3 LIKE '%COMPANY%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%END_CUSTOMER%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                        END

                        IF @MASTER_CODETYPE3 LIKE '%VENDOR%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                        END

                        IF @MASTER_CODETYPE3 LIKE '%SITE%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%DISTRIBUTE_CHANNERL%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                        END

                        IF @MASTER_CODETYPE3 LIKE '%SALES_GROUP%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                        END

                        IF @MASTER_CODETYPE3 LIKE '%MOVEMENT_TYPE%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                        END

                        IF @MASTER_CODETYPE3 LIKE '%BIZ_AREA%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF EXISTS (SELECT 1 FROM @WORK_AVALIABLE WHERE MASTER_CODETYPE = N'STORAGE_ID' )
                        BEGIN
                            IF @MASTER_CODETYPE3 LIKE '%STORAGE_ID%'
                            BEGIN
                                SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)

                                SELECT @PLANT_COL1 = TABLE_COL
                                FROM @WORK_AVALIABLE
                                WHERE MASTER_CODETYPE = N'PLANT_ID';

                                IF @PLANT_COL1 = ''
                                BEGIN
                                    SET @mSubQuery = @mSubQuery + '';
                                END
                                ELSE
                                BEGIN
                                    SET @mSubQuery = @mSubQuery + 'AND A.'+ @PLANT_COL1 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                                END

                            END
                            IF @MASTER_CODETYPE3 LIKE '%PLANT%'
                            BEGIN
                                SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                            END
                        END

                        ELSE
                        BEGIN
                            IF @MASTER_CODETYPE3 LIKE '%PLANT%'
                            BEGIN
                                SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE IN ( ' + '''' +@MASTER_CODETYPE3+'''' + ', ''SCP_SITE_ID'' )'+CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10); --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                            END
                        END

                    END

                    -----------------------------------------------
                    -- STEP 2-3. UPDATE QUERY MAKE
                    -- UPDATE TABLE_NAME SET
                    --  COMPANY_ID = C.COMPANY_ID_B1
                    -- , PLANT_ID = C.PLANT_ID_B2
                    -- , TO_PLANT_ID = C.PLANT_ID_B3
                    -----------------------------------------------
                    BEGIN
                        IF @mUpdateQuery = ''
                        BEGIN
                            SET @mUpdateQuery = @mUpdateQuery + @TABLE_COL3 + ' = ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END
                        ELSE
                        BEGIN
                            SET @mUpdateQuery = @mUpdateQuery + ', ' + @TABLE_COL3 + ' = ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END

                    END


                    -----------------------------------------------
                    -- STEP 2-3. INSERT QUERY MAKE
                    -- INSERT INTO TABLE_NAME
                    --  , ISNULL(C.COMPANY_ID_B1, COMPANY_ID)
                    -- , PLANT_ID = C.PLANT_ID_B2
                    -- , TO_PLANT_ID = C.PLANT_ID_B3
                    -----------------------------------------------
                    BEGIN

                        IF @TABLE_COL3 = 'SEGMENT1'
                        BEGIN
                            SET @mInsertQuerySegment1 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') SEGMENT1'
                            SET @mPartitionBySegment1 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END
                        ELSE IF @TABLE_COL3 = 'SEGMENT2'
                        BEGIN
                            SET @mInsertQuerySegment2 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') SEGMENT2'
                            SET @mPartitionBySegment2 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END
                        ELSE IF @TABLE_COL3 = 'SEGMENT3'
                        BEGIN
                            SET @mInsertQuerySegment3 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') SEGMENT3'
                            SET @mPartitionBySegment3 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END
                        ELSE IF @TABLE_COL3 = 'SEGMENT4'
                        BEGIN
                            SET @mInsertQuerySegment4 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') SEGMENT4'
                            SET @mPartitionBySegment4 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END
                        ELSE IF @TABLE_COL3 = 'SEGMENT5'
                        BEGIN
                            SET @mInsertQuerySegment5 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') SEGMENT5'
                            SET @mPartitionBySegment5 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ')'
                        END
                        ELSE IF @TABLE_COL3 = 'ATTRIBUTE1'
                        BEGIN
                            SET @mInsertQueryAttribute1 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') ATTRIBUTE1'
                        END
                        ELSE IF @TABLE_COL3 = 'ATTRIBUTE2'
                        BEGIN
                            SET @mInsertQueryAttribute2 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') ATTRIBUTE2'
                        END
                        ELSE IF @TABLE_COL3 = 'ATTRIBUTE3'
                        BEGIN
                            SET @mInsertQueryAttribute3 = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') ATTRIBUTE3'
                        END

                    END


                    -----------------------------------------------
                    -- STEP 2-4. UPDATE QUERY MAKE
                    -- WHERE 1=1
                    -- AND COMPANY_ID = C.COMPANY_ID
                    -- AND PLANT_ID = C.PLANT_ID
                    -- AND TO_PLANT_ID = C.TO_PLANT_ID
                    -----------------------------------------------
                    BEGIN
                        SET @mUpdateWhereQuery = @mUpdateWhereQuery + ' AND A.' + @TABLE_COL3 + ' = C.' + @TABLE_COL3 + '';
                        SET @mInsertWhereQuery = @mInsertWhereQuery + ' AND A.' + @TABLE_COL3 + ' = C.' + @TABLE_COL3 + '';
                    END

                    -----------------------------------------------
                    -- STEP 2-4. DYNAMIC TABLE QUERY MAKE
                    -- COMPANY_ID NVARCHAR(100),
                    -----------------------------------------------
                    BEGIN
                        IF @mTableQuery = ''
                        BEGIN
                            SET @mTableQuery = @mTableQuery + @TABLE_COL3 + ' NVARCHAR(100), ' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ' NVARCHAR(100) '
                        END
                        ELSE
                        BEGIN
                            SET @mTableQuery = @mTableQuery + ', '+ @TABLE_COL3 + ' NVARCHAR(100), ' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ' NVARCHAR(100) '
                        END
                    END


                    SET @CNT = @CNT + 1;

                    FETCH NEXT FROM LOOKUP_CURSOR2
                    INTO @TABLE_COL3, @MASTER_CODETYPE3 ;

                END


                ---------------------------------------------------------
                -- MEMORY TABLE CREATE

                --PRINT @mTableQuery;

                IF OBJECT_ID('ZNERP_LOOKUP_HIST_DM') IS NOT NULL
                    DROP TABLE ZNERP_LOOKUP_HIST_DM

                DECLARE @SQL NVARCHAR(MAX);
                SET @SQL = 'CREATE TABLE DBO.ZNERP_LOOKUP_HIST_DM(';
                SELECT @SQL = @SQL + @mTableQuery;
                SELECT @SQL = @SQL + ')'

                PRINT @SQL;

                EXEC(@SQL);



                DECLARE @mEXECSelInto NVARCHAR(MAX);
                SET @mEXECSelInto = '';
                SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO ZNERP_LOOKUP_HIST_DM' +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + 'SELECT ' + @mDisQuery  +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + 'FROM ' + 'SCM_ADM_LOOKUP_MASTER_DETAIL' + ' A'  +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + @mSubQuery;
                SET @mEXECSelInto = @mEXECSelInto + ' WHERE  LOOKUP_TYPE = ''' + @LOOKUP_TYPE + '''';
                SET @mEXECSelInto = @mEXECSelInto + ' AND  A.VALID_YN = ''Y'' ';


                PRINT @mEXECSelInto;
                EXEC SP_EXECUTESQL @mEXECSelInto ;


                -- 컨버전 데이터가 모두 없으면 목록에서 삭제(중복방지)
                DECLARE @mEXECSelIntoDel NVARCHAR(MAX);
                SET @mEXECSelIntoDel = '';
                SET @mEXECSelIntoDel = @mEXECSelIntoDel + 'DELETE FROM  ZNERP_LOOKUP_HIST_DM' +CHAR(10);
                SET @mEXECSelIntoDel = @mEXECSelIntoDel + 'WHERE 1=1 '  +CHAR(10);
                SET @mEXECSelIntoDel = @mEXECSelIntoDel + @mDisQueryDel;


                PRINT @mEXECSelIntoDel;
                EXEC SP_EXECUTESQL @mEXECSelIntoDel ;



                PRINT @TABLE_NAME + '2. ' +CONVERT(CHAR(23), GETDATE(), 21);
                SET @UPDATE_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

                SET @mInsertQuery = @mInsertQuerySegment1 + @mInsertQuerySegment2 + @mInsertQuerySegment3 + @mInsertQuerySegment4
                SET @mInsertQuery = @mInsertQuery + ', A.SEGMENT5, A.DISPLAY_SEQ, A.VALID_YN, A.DESCRIPTION'
                SET @mInsertQuery = @mInsertQuery + ', A.CREATED_BY, A.CREATION_DATE, '''+@CREATED_BY+''' AS LAST_UPDATED_BY, getdate() AS LAST_UPDATE_DATE'
                SET @mInsertQuery = @mInsertQuery + @mInsertQueryAttribute1 + @mInsertQueryAttribute2 + @mInsertQueryAttribute3 + ', A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8'
                SET @mInsertQuery = @mInsertQuery + ', A.ATTRIBUTE9, A.ATTRIBUTE10, A.ATTRIBUTE11, A.ATTRIBUTE12, A.ATTRIBUTE13, A.ATTRIBUTE14, A.ATTRIBUTE15'


                --INSERT 문
                SET @mPartitionBy = @mPartitionBySegment1 + @mPartitionBySegment2 + @mPartitionBySegment3 + @mPartitionBySegment4 + @mPartitionBySegment5;
                DECLARE @mEXEC_INSERT NVARCHAR(MAX);
                SET @mEXEC_INSERT = '';
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'INSERT INTO '+ 'SCM_ADM_LOOKUP_MASTER_DETAIL' + ' SELECT LOOKUP_TYPE ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ',SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,DISPLAY_SEQ,VALID_YN,DESCRIPTION,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ',ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15 ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'FROM ( SELECT DISTINCT LOOKUP_TYPE ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + @mInsertQuery  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ',RNUM = ROW_NUMBER() OVER (PARTITION BY LOOKUP_TYPE'+@mPartitionBy +' ORDER BY LOOKUP_TYPE' +@mPartitionBy +')'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'FROM ' + 'SCM_ADM_LOOKUP_MASTER_DETAIL' + ' A,  ZNERP_LOOKUP_HIST_DM C'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'WHERE 1=1'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + @mInsertWhereQuery +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'AND 1=1'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'AND LOOKUP_TYPE = ''' + @LOOKUP_TYPE + '''';
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'AND A.VALID_YN = ''Y'' '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' ) X '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' WHERE RNUM = 1 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' AND NOT EXISTS ( SELECT 1 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  FROM   SCM_ADM_LOOKUP_MASTER_DETAIL AS D'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  WHERE  D.LOOKUP_TYPE = X.LOOKUP_TYPE '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  AND    D.SEGMENT1 = X.SEGMENT1 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  AND    D.SEGMENT2 = X.SEGMENT2 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  AND    D.SEGMENT3 = X.SEGMENT3 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  AND    D.SEGMENT4 = X.SEGMENT4 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  AND    D.SEGMENT5 = X.SEGMENT5 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                 ) '  +CHAR(10);

                DECLARE @INSERT_CNT INT;
                PRINT @mEXEC_INSERT;
                EXEC SP_EXECUTESQL @mEXEC_INSERT ;


                SET @UPDATE_CNT = @UPDATE_CNT +  @@ROWCOUNT;


                SET @UPDATE_END_TIME = CONVERT(CHAR(23), GETDATE(), 21);

                -- 추가하는 NEW_VALUE에 대하여  기존 코드 OLD_VALUE는 ACTIVE_FLAG = N 처리한다.
                PRINT @TABLE_NAME + '2.5 ' +CONVERT(CHAR(23), GETDATE(), 21);
                DECLARE @mEXECUpdateActiveFlag NVARCHAR(MAX);
                SET @mEXECUpdateActiveFlag = '';
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'UPDATE A ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'SET A.VALID_YN = ''N'' ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + '   ,A.LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + '   ,A.LAST_UPDATE_DATE = GETDATE() ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'FROM ' + 'SCM_ADM_LOOKUP_MASTER_DETAIL' + ' A,  ZNERP_LOOKUP_HIST_DM C'  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'WHERE 1=1'  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + @mInsertWhereQuery + CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'AND 1=1'  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'AND LOOKUP_TYPE = ''' + @LOOKUP_TYPE + ''''  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'AND VALID_YN = ''Y'' '  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + ';'  +CHAR(10);

                PRINT @mEXECUpdateActiveFlag;
                EXEC SP_EXECUTESQL @mEXECUpdateActiveFlag ;

                PRINT @TABLE_NAME + '3. ' +CONVERT(CHAR(23), GETDATE(), 21);

                --2025-05-21 김준규 DM_MAT_DOC_STORAGE_ID OPEN법인 추가필요, PR_SCM_DNM_MAT_DOCUMENT : 자재 입/출고 정보 I/F 사용.(현재 사용하는 것만 등록됨)
                --SELECT  *
                --FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                --WHERE lookup_type = 'DM_MAT_DOC_STORAGE_ID'
                --;
                IF @LOOKUP_TYPE = 'DM_MAT_DOC_STORAGE_ID' 
                BEGIN
                    DECLARE @SPECIFIC_SQL NVARCHAR(MAX)='';
                    SET @SPECIFIC_SQL = N'
                    --SELECT  *
                    --FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                    --WHERE lookup_type = ''DM_MAT_DOC_STORAGE_ID'';
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL (
                        LOOKUP_TYPE
                        ,SEGMENT1
                        ,SEGMENT2
                        ,SEGMENT3
                        ,SEGMENT4
                        ,SEGMENT5
                        ,DISPLAY_SEQ
                        ,VALID_YN
                        ,DESCRIPTION
                        ,CREATED_BY
                        ,CREATION_DATE
                        ,LAST_UPDATED_BY
                        ,LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                    )
                    SELECT LOOKUP_TYPE 
                          ,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5
                          ,1000+ROW_NUMBER() OVER (ORDER BY ATTRIBUTE1 ,SEGMENT1) AS DISPLAY_SEQ, ''Y'' AS VALID_YN,'''' AS DESCRIPTION
                          ,'''+@CREATED_BY+''' AS CREATED_BY, getdate() AS CREATION_DATE
                          ,'''+@CREATED_BY+''' AS LAST_UPDATED_BY, getdate() AS LAST_UPDATE_DATE
                          ,ATTRIBUTE1
                    FROM ( SELECT '''+@LOOKUP_TYPE+'''  AS LOOKUP_TYPE  
                                 ,SEGMENT1,''-'' AS SEGMENT2,''-'' AS SEGMENT3,''-'' AS SEGMENT4,''-'' AS SEGMENT5,ATTRIBUTE1
                                 --,RNUM = ROW_NUMBER() OVER (ORDER BY ATTRIBUTE1 ,SEGMENT1)
                                 ,RNUM = ROW_NUMBER() OVER (PARTITION BY SEGMENT1 ORDER BY ATTRIBUTE1 ,SEGMENT1)
                           FROM  (SELECT DISTINCT mcv.NEW_VALUE1 AS ATTRIBUTE1,mcv.NEW_VALUE2 AS SEGMENT1
                                  FROM   NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
                                  WHERE  MCV.CODETYPE = ''STORAGE_ID''
                                  AND    MCV.ATTRIBUTE5 = '''+@P_ROLLIN+''' ) AS stid
                     ) X 
                     WHERE 1=1
                     AND RNUM = 1
                     AND NOT EXISTS ( SELECT 1 
                                      FROM   SCM_ADM_LOOKUP_MASTER_DETAIL AS D
                                      WHERE  D.LOOKUP_TYPE = X.LOOKUP_TYPE 
                                      AND    D.SEGMENT1 = X.SEGMENT1 
                                      AND    D.SEGMENT2 = X.SEGMENT2 
                                      AND    D.SEGMENT3 = X.SEGMENT3 
                                      AND    D.SEGMENT4 = X.SEGMENT4 
                                      AND    D.SEGMENT5 = X.SEGMENT5 
                                     );';
                PRINT @SPECIFIC_SQL;
                EXEC sys.sp_executesql @SPECIFIC_SQL;
                END;

                UPDATE  ZNERP_LOOKUP_INFO_DM
                SET CONVERSION_FLAG = 'Y',
                    MODIFY_USER_ID = @CREATED_BY,
                    MODIFY_DATE = getDate()
                WHERE LOOKUP_TYPE = @LOOKUP_TYPE
                 --AND  CONVERSION_FLAG = 'N'
                 AND  MASTER_CODETYPE <> 'INCOTERMS_ID'
                 AND  LOOKUP_VALID_YN = 'Y'
                 ;


                -- STEP
                SET @v_log_type = 'STEP';
                SET @v_log_message = '';
                SET @n_log_count = @UPDATE_CNT ;
                SET @v_description = @LOOKUP_TYPE + '/@UPDATE_CNT : ' + CAST(@UPDATE_CNT AS NVARCHAR(1000)) ;
                SET @d_event_date = SYSDATETIME();
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



                CLOSE LOOKUP_CURSOR2;
                DEALLOCATE LOOKUP_CURSOR2;
            END


            -----------------------------------------------
            --STEP 2-2. JOIN QUERY AUTO MAKE
            -----------------------------------------------
            FETCH NEXT FROM LOOKUP_CURSOR
            INTO @LOOKUP_TYPE ;
            END


        END
        CLOSE LOOKUP_CURSOR;
        DEALLOCATE LOOKUP_CURSOR;


        --2025-06-29 김준규 INCOTERMS는 손 대면 안됨.
        ----2.1.2) INCOTERMS 사용 안하는 대상 Valid 'N' 처리
        --update SCM_ADM_LOOKUP_MASTER_DETAIL
        --set    valid_yn = 'N'
        --     , last_updated_by = @CREATED_BY
        --     , last_update_date = getdate()
        --from  SCM_ADM_LOOKUP_MASTER_DETAIL m with(nolock)
        --where  m.lookup_type = 'INCOTERMS'
        --and    m.segment1 in ( select distinct OLD_VALUE1
        --                      from   NERP_CONV_MASTER_CFM_V with(nolock)
        --                      where  CODETYPE = 'INCOTERMS_ID' )

        --SET @UPDATE_CNT =  @@ROWCOUNT;

        ---- STEP
        --SET @v_log_type = 'STEP';
        --SET @v_log_message = '';
        --SET @n_log_count = @UPDATE_CNT ;
        --SET @v_description = 'INCOTERMS' + '/@UPDATE_CNT : ' + CAST(@UPDATE_CNT AS NVARCHAR(1000)) ;
        --SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        ----2.1.3) BP_INCOTERMS 사용 안하는 대상 Valid 'N' 처리
        --update SCM_ADM_LOOKUP_MASTER_DETAIL
        --set    valid_yn = 'N'
        --     , last_updated_by = @CREATED_BY
        --     , last_update_date = getdate()
        --from  SCM_ADM_LOOKUP_MASTER_DETAIL m with(nolock)
        --where  m.lookup_type = 'BP_INCOTERMS'
        --and    m.segment2 in ( select distinct OLD_VALUE1
        --                      from   NERP_CONV_MASTER_CFM_V with(nolock)
        --                      where  CODETYPE = 'INCOTERMS_ID' )

        --SET @UPDATE_CNT =  @@ROWCOUNT;

        ---- STEP
        --SET @v_log_type = 'STEP';
        --SET @v_log_message = '';
        --SET @n_log_count = @UPDATE_CNT ;
        --SET @v_description = 'BP_INCOTERMS' + '/@UPDATE_CNT : ' + CAST(@UPDATE_CNT AS NVARCHAR(1000)) ;
        --SET @d_event_date = SYSDATETIME();
        --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        FETCH NEXT FROM LOOKUP_CURSOR_B
        INTO @LOOKUP_TYPE,@RNUM

    END--LOOKUP_CURSOR_B WHILE

    CLOSE LOOKUP_CURSOR_B;
    DEALLOCATE LOOKUP_CURSOR_B;


    --COMMIT;
    PRINT 'Transaction succeed!';

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count = 0;
    SET @v_description = '';
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

    --------------------------------------------------------------------------------------------
    END TRY
    --------------------------------------------------------------------------------------------


    --------------------------------------------------------------
    BEGIN CATCH
    --------------------------------------------------------------
        --ROLLBACK;
        PRINT 'Transaction is cancels cause of error';

        -- ERROR LOG
        SET @v_log_type = 'ERROR';
        SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
        SET @n_log_count = 0;
        SET @v_description = 'ERROR_LINE : ' + STR(ERROR_LINE());
        SET @d_event_date = SYSDATETIME();
        SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
        PRINT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'LOOKUP_CURSOR')   
        BEGIN       
            CLOSE LOOKUP_CURSOR       
            DEALLOCATE LOOKUP_CURSOR   
        END

        IF EXISTS (SELECT 1 FROM SYS.SYSCURSORS WHERE CURSOR_NAME = 'LOOKUP_CURSOR2')   
        BEGIN       
            CLOSE LOOKUP_CURSOR2       
            DEALLOCATE LOOKUP_CURSOR2   
        END

    --------------------------------------------------------------
    END CATCH;
    --------------------------------------------------------------

END
