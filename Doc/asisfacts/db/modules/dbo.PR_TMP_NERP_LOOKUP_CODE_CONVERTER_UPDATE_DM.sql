
-- =============================================
-- Author:       김준규
-- Create date:  2024-04-27
-- Description:  table info data converter(PR_TMP_NERP_LOOKUP_CONVERTER_UPDATE_DM Copy)
-- =============================================
/*
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2025-04-27   김준규      NERP) ROLLIN 차수 PARAMETER화
 * 2025-05-11   김준규      NERP) @mDisQueryDel에서 `중복되면 목록에서 삭제` 항목 제외처리
 * 2025-06-13   김준규      NERP) LOOKUP_TYPE_CODE = PR_SCP_PLN_SSP_SHIP_REQ 인경우 특이 케이스로 처리
 * 2025-06-13   김준규      NERP) PR_SCM_MST_SLOC외 PR_SCP_BI_FP_RESULT 형태의 5개 LOOKUP 10개 레코드 2ND에서 강제로 삭제요청
 * 2025-06-17   김준규      NERP) LOOKUP_TYPE_CODE = PR_SCP_PLN_SSP_SHIP_REQ ATTRIBUTE3추가
 * 2025-08-05   김준규      NERP) PR_SCP_ANL_PSI_INTEGRATION_ESS외 PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only 2개 LOOKUP 3개 레코드 3RD에서 강제로 삭제처리
 * 2025-08-12   김준규      NERP) PR_SCP_ANL_PSI_INTEGRATION_ESS ATTRIBUTE값이 NULL이라서 누락되어서 ISNULL로 보완
 * 2025-09-09   김준규      NERP) 작업이 한번 일어난 것은 쿼리되지 않게 한다 AND    MODIFY_USER_ID <> ''' + @CREATED_BY + '''


EXEC PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM @P_LOOKUP_TYPE='PR_SCP_ANL_PSI_INTEGRATION_ESS',@P_ROLLIN = '3RD';

EXEC [dbo].[PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE ='PR_SCP_ANL_PSI_INTEGRATION_ESS'
  , @P_ROLLIN = '3RD'
EXEC [dbo].[PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE ='PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only'
  , @P_ROLLIN = '3RD'
EXEC [dbo].[PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE ='PR_SCP_ANL_PSI_INTEGRATION_Small'
  , @P_ROLLIN = '3RD'

EXEC [dbo].[PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE ='PLANT_DESC '
  , @P_ROLLIN = '2ND'

EXEC [dbo].[PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM]
    @P_LOOKUP_TYPE =''
  , @P_ROLLIN = '2ND'

  COMMIT;

*/
CREATE PROCEDURE [dbo].[PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM]
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
    DECLARE @SEARCH_CONDITION   NVARCHAR(150) = N'';
    DECLARE @VALUE_DESC_CHG   NVARCHAR(150) = N'';
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
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_LOOKUP_CODE_CONVERTER_UPDATE_DM';
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
        IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[BACKUP_SCM_CODE_LOOKUP_VALUE]') AND type in (N'U'))
        BEGIN
            DROP TABLE [dbo].[BACKUP_SCM_CODE_LOOKUP_VALUE];
        END

        SELECT *
        INTO [dbo].[BACKUP_SCM_CODE_LOOKUP_VALUE]
        FROM SCM_CODE_LOOKUP_VALUE;
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
            SELECT LOOKUP_TYPE,TABLE_COL, MASTER_CODETYPE, SEARCH_CONDITION
                  ,ROW_NUMBER()OVER(PARTITION BY LOOKUP_TYPE,TABLE_COL ORDER BY MASTER_CODETYPE ) RNUM
            FROM   ZNERP_LOOKUP_CODE_INFO_DM
            WHERE  1=1
            --AND    CONVERSION_FLAG = 'N'
            AND    LOOKUP_VALID_YN = 'Y'
            --2025-06-13 PR_SCP_PLN_SSP_SHIP_REQ 가장하단 별도 처리(특수 케이스)
            AND    LOOKUP_TYPE <> 'PR_SCP_PLN_SSP_SHIP_REQ'
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
        declare @p nvarchar(max) = '';
        DECLARE @WORK_AVALIABLE TABLE (
            TABLE_COL NVARCHAR(150)
            , MASTER_CODETYPE NVARCHAR(150)
            , SEARCH_CONDITION NVARCHAR(150)
            , VALUE_DESC_CHG NVARCHAR(150));

        DECLARE LOOKUP_CURSOR CURSOR FOR
        SELECT DISTINCT LOOKUP_TYPE
        FROM   ZNERP_LOOKUP_CODE_INFO_DM WITH(NOLOCK)
        WHERE  1=1
        AND    LOOKUP_TYPE = @LOOKUP_TYPE
        AND    LOOKUP_VALID_YN = 'Y'
        --AND    CONVERSION_FLAG = 'N'
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
            SELECT TABLE_COL, MASTER_CODETYPE, SEARCH_CONDITION, VALUE_DESC_CHG
            FROM (
                SELECT TABLE_COL, MASTER_CODETYPE, SEARCH_CONDITION, VALUE_DESC_CHG
                      ,ROW_NUMBER()OVER(PARTITION BY TABLE_COL ORDER BY CASE WHEN MASTER_CODETYPE IN ( ''END_CUSTOMER_ID'',''VENDOR_ID'') THEN 1
                            WHEN MASTER_CODETYPE = ''SCP_SITE_ID'' THEN 2
                            WHEN MASTER_CODETYPE = ''PLANT_ID'' THEN 3
                            WHEN MASTER_CODETYPE = ''COMPANY_ID'' THEN 4
                           ELSE 99 END) RNUM
                FROM   ZNERP_LOOKUP_CODE_INFO_DM
                WHERE  1=1
                AND    LOOKUP_TYPE = ''' + @LOOKUP_TYPE + N'''
                AND    LOOKUP_VALID_YN = ''Y''
                --2025-09-09 작업이 한번 일어난 것은 쿼리되지 않게 한다
                --아래는 빼야 되는게 맞음
                --AND    MODIFY_USER_ID <> (CASE WHEN '''+@RNUM+'''> 1 THEN ''' + @CREATED_BY + N''' ELSE ''X@X@XX@XXX@X'' END)
            ) X
            WHERE RNUM = '''+@RNUM+N''' ';
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
                DECLARE  @mInsertQueryValueDescription NVARCHAR(MAX) = '';
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
                SET @mInsertQueryValueDescription = ', A.VALUE_DESCRIPTION';
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

                DECLARE LOOKUP_CURSOR2 CURSOR FOR SELECT TABLE_COL, MASTER_CODETYPE, SEARCH_CONDITION, VALUE_DESC_CHG FROM @WORK_AVALIABLE ORDER BY TABLE_COL
                SET @CNT = 1;

                OPEN LOOKUP_CURSOR2;
                FETCH NEXT FROM LOOKUP_CURSOR2
                INTO  @TABLE_COL3, @MASTER_CODETYPE3, @SEARCH_CONDITION, @VALUE_DESC_CHG;

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

                        --BEGIN  --처음인경우
                        --    IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                        --    BEGIN
                        --        IF @SEARCH_CONDITION = '=' BEGIN
                        --        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --        ELSE BEGIN
                        --        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --    END
                        --    ELSE
                        --    BEGIN
                        --        IF @SEARCH_CONDITION = '=' BEGIN
                        --        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --        ELSE BEGIN
                        --        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --    END

                        --    SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL ' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                        --    SET @mDisQueryDel = @mDisQueryDel + ' OR ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IN ( SELECT DISTINCT ' + @TABLE_COL3 + ' FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''' AND ACTIVE_FLAG = ''Y'')) ' -- 컨버전 데이터가 중복되면 목록에서 삭제

                        --END
                        --ELSE
                        --BEGIN --두번째인경우
                        --    IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                        --    BEGIN
                        --        IF @SEARCH_CONDITION = '=' BEGIN
                        --        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --        ELSE BEGIN
                        --        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --    END
                        --    ELSE
                        --    BEGIN
                        --        IF @SEARCH_CONDITION = '=' BEGIN
                        --        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --        ELSE BEGIN
                        --        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        --        END
                        --    END

                        --    SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL ' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                        --    SET @mDisQueryDel = @mDisQueryDel + ' OR ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IN ( SELECT DISTINCT ' + @TABLE_COL3 + ' FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''' AND ACTIVE_FLAG = ''Y'')) ' -- 컨버전 데이터가 중복되면 목록에서 삭제

                        --END

                        BEGIN  --처음인경우
                            IF @TABLE_COL3 <> 'VALUE_DESCRIPTION'
                            BEGIN
                                IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                                BEGIN
                                    IF @SEARCH_CONDITION = '=' BEGIN
                                    SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                    ELSE BEGIN
                                    SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                END
                                ELSE
                                BEGIN
                                    IF @SEARCH_CONDITION = '=' BEGIN
                                    SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                    ELSE BEGIN
                                    SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                END
                            END
                            ELSE --IF @TABLE_COL3 = 'VALUE_DESCRIPTION'
                            BEGIN
                                IF @VALUE_DESC_CHG = 'REPLACE'
                                BEGIN
                                    IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                    ELSE
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                END
                                ELSE -- IF @VALUE_DESC_CHG <> 'REPLACE' (FROM -> TO)
                                BEGIN
                                    IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        --변경관련 보관용
                                        --SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', A.' + @TABLE_COL3 + '+ '' -> '' + REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 + '' -> '' + B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                    ELSE
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        --변경관련 보관용
                                        --SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', A.' + @TABLE_COL3 + '+ '' -> '' + REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + '' -> '' + B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                END
                            END
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL ' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL )' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            -- INSERT가 중복되지 않게 하기 때문에 아래 막음(기존 이미 입력이 되어 있고, 아직 컨버전 되어야 할 대상이 남아 있음 그래서 막음)
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' OR ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IN ( SELECT DISTINCT ' + @TABLE_COL3 + ' FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''' AND ACTIVE_FLAG = ''Y'')) ' -- 컨버전 데이터가 중복되면 목록에서 삭제
                        END
                        ELSE
                        BEGIN --두번째인경우
                            IF @TABLE_COL3 <> 'VALUE_DESCRIPTION'
                            BEGIN
                                IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                                BEGIN
                                    IF @SEARCH_CONDITION = '=' BEGIN
                                    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                    ELSE BEGIN
                                    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                END
                                ELSE
                                BEGIN
                                    IF @SEARCH_CONDITION = '=' BEGIN
                                    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                    ELSE BEGIN
                                    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                    END
                                END
                            END
                            ELSE --IF @TABLE_COL3 = 'VALUE_DESCRIPTION'
                            BEGIN
                                IF @VALUE_DESC_CHG = 'REPLACE'
                                BEGIN
                                    IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                    ELSE
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                END
                                ELSE -- IF @VALUE_DESC_CHG <> 'REPLACE' (FROM -> TO)
                                BEGIN
                                    IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        --변경관련 보관용
                                        --SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', A.' + @TABLE_COL3 + '+ '' -> '' + REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 + '' -> '' + B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                    ELSE
                                    BEGIN
                                        IF @SEARCH_CONDITION = '=' BEGIN
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                        ELSE BEGIN
                                        --변경관련 보관용
                                        --SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', A.' + @TABLE_COL3 + '+ '' -> '' + REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + '' -> '' + B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                                        END
                                    END
                                END
                            END
                            --IF @MASTER_CODETYPE3 = 'STORAGE_ID'
                            --BEGIN
                            --    IF @SEARCH_CONDITION = '=' BEGIN
                            --    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            --    END
                            --    ELSE BEGIN
                            --    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            --    END
                            --END
                            --ELSE
                            --BEGIN
                            --    IF @SEARCH_CONDITION = '=' BEGIN
                            --    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            --    END
                            --    ELSE BEGIN
                            --    SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', REPLACE(A.' + @TABLE_COL3 + ' ,B'  + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 ,B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1)' +' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                            --    END
                            --END
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL ' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            SET @mDisQueryDel = @mDisQueryDel + ' AND ( ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IS NULL )' -- 컨버전 데이터가 모두 없으면 목록에서 삭제
                            -- 아래는 컨버전 데이터가 중복되면 목록에서 삭제
                            -- INSERT가 중복되지 않게 하기 때문에 아래 막음(기존 이미 입력이 되어 있고, 아직 컨버전 되어야 할 대상이 남아 있음 그래서 막음)
                            --2025-05-11 막음
                            --SET @mDisQueryDel = @mDisQueryDel + ' OR ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT) + ' IN ( SELECT DISTINCT ' + @TABLE_COL3 + ' FROM SCM_CODE_LOOKUP_VALUE WITH(NOLOCK) WHERE LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''' AND ACTIVE_FLAG = ''Y'')) ' -- 컨버전 데이터가 중복되면 목록에서 삭제
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
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);--''%''+B1.OLD_VALUE1+''%''
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%END_CUSTOMER%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%VENDOR%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%SITE%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%DISTRIBUTE_CHANNERL%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%SALES_GROUP%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%MOVEMENT_TYPE%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF @MASTER_CODETYPE3 LIKE '%BIZ_AREA%'
                        BEGIN
                            SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                            IF @SEARCH_CONDITION = '=' BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                            END
                            ELSE BEGIN
                            SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                            END
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                            SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                        END

                        IF EXISTS (SELECT 1 FROM @WORK_AVALIABLE WHERE MASTER_CODETYPE = N'STORAGE_ID' )
                        BEGIN
                                IF @MASTER_CODETYPE3 LIKE '%STORAGE_ID%'
                                BEGIN
                                SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                                IF @SEARCH_CONDITION = '=' BEGIN
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                                END
                                ELSE BEGIN
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2%''' + '' +CHAR(10);
                                END
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)

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
                                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                                END

                            END
                            IF @MASTER_CODETYPE3 LIKE '%PLANT%'
                            BEGIN
                                SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                                IF @SEARCH_CONDITION = '=' BEGIN
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                                END
                                ELSE BEGIN
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                                END
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                            END
                        END

                        ELSE
                        BEGIN
                            IF @MASTER_CODETYPE3 LIKE '%PLANT%'
                            BEGIN
                                SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                                IF @SEARCH_CONDITION = '=' BEGIN
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                                END
                                ELSE BEGIN
                                SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' LIKE ''%'' + B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1 + ''%''' + '' +CHAR(10);
                                END
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE IN ( ' + '''' +@MASTER_CODETYPE3+'''' + ', ''SCP_SITE_ID'' )'+CHAR(10);
                                SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
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
                        ELSE IF @TABLE_COL3 = 'VALUE_DESCRIPTION'
                        BEGIN
                            SET @mInsertQueryValueDescription = ' ,ISNULL(C.' + @MASTER_CODETYPE3 + '_B' + CONVERT(VARCHAR, @CNT) + ', A.' + @TABLE_COL3 + ') VALUE_DESCRIPTION'
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
                        SET @mUpdateWhereQuery = @mUpdateWhereQuery + ' AND ISNULL(A.' + @TABLE_COL3 + ','''') = ISNULL(C.' + @TABLE_COL3 + ','''')';
                        SET @mInsertWhereQuery = @mInsertWhereQuery + ' AND ISNULL(A.' + @TABLE_COL3 + ','''') = ISNULL(C.' + @TABLE_COL3 + ','''')';
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
                    INTO  @TABLE_COL3, @MASTER_CODETYPE3, @SEARCH_CONDITION, @VALUE_DESC_CHG;

                END


                ---------------------------------------------------------
                -- MEMORY TABLE CREATE

                --PRINT @mTableQuery;

                IF OBJECT_ID('ZNERP_LOOKUP_CODE_HIST_DM') IS NOT NULL
                    DROP TABLE ZNERP_LOOKUP_CODE_HIST_DM

                DECLARE @SQL NVARCHAR(MAX);
                SET @SQL = 'CREATE TABLE DBO.ZNERP_LOOKUP_CODE_HIST_DM(';
                SELECT @SQL = @SQL + @mTableQuery;
                SELECT @SQL = @SQL + ')'

                PRINT @SQL;

                EXEC(@SQL);



                DECLARE @mEXECSelInto NVARCHAR(MAX);
                SET @mEXECSelInto = '';
                SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO ZNERP_LOOKUP_CODE_HIST_DM' +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + 'SELECT ' + @mDisQuery  +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + 'FROM ' + 'SCM_CODE_LOOKUP_VALUE' + ' A'  +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + @mSubQuery;
                SET @mEXECSelInto = @mEXECSelInto + ' WHERE  LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''''  +CHAR(10);
                SET @mEXECSelInto = @mEXECSelInto + ' AND  A.ACTIVE_FLAG = ''Y'' '  +CHAR(10);
                --2025-09-09 작업이 한번 일어난 것은 쿼리되지 않게 한다
                --AND    MODIFY_USER_ID <> (CASE WHEN '''+@RNUM+'''> 1 THEN ''' + @CREATED_BY + N''' ELSE ''X@X@XX@XXX@X'' END)
                SET @mEXECSelInto = @mEXECSelInto + ' AND  ISNULL(A.MODIFY_USER_ID,''XXX'') <> (CASE WHEN '''+@RNUM+'''> ''1'' THEN ''' + @CREATED_BY + N''' ELSE ''X@X@XX@XXX@X'' END) '  +CHAR(10);


                PRINT @mEXECSelInto;
                EXEC SP_EXECUTESQL @mEXECSelInto ;


                -- 컨버전 데이터가 모두 없으면 목록에서 삭제(중복방지)
                DECLARE @mEXECSelIntoDel NVARCHAR(MAX);
                SET @mEXECSelIntoDel = '';
                SET @mEXECSelIntoDel = @mEXECSelIntoDel + 'DELETE FROM  ZNERP_LOOKUP_CODE_HIST_DM' +CHAR(10);
                SET @mEXECSelIntoDel = @mEXECSelIntoDel + 'WHERE 1=1 '  +CHAR(10);
                SET @mEXECSelIntoDel = @mEXECSelIntoDel + @mDisQueryDel;


                PRINT @mEXECSelIntoDel;
                EXEC SP_EXECUTESQL @mEXECSelIntoDel ;

                PRINT @TABLE_NAME + '2. ' +CONVERT(CHAR(23), GETDATE(), 21);
                SET @UPDATE_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

                SET @mInsertQuery = @mInsertQuerySegment1 + @mInsertQuerySegment2 + @mInsertQuerySegment3 + @mInsertQuerySegment4 + @mInsertQuerySegment5
                SET @mInsertQuery = @mInsertQuery + ', A.SORT_ORDER, A.ACTIVE_FLAG' + @mInsertQueryValueDescription
                SET @mInsertQuery = @mInsertQuery + ', A.CREATE_USER_ID, A.CREATE_DATE, '''+@CREATED_BY+''' AS MODIFY_USER_ID, getdate() AS MODIFY_DATE'
                SET @mInsertQuery = @mInsertQuery + @mInsertQueryAttribute1 + @mInsertQueryAttribute2 + @mInsertQueryAttribute3 + ', A.ATTRIBUTE4, A.ATTRIBUTE5, A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8'
                SET @mInsertQuery = @mInsertQuery + ', A.ATTRIBUTE9, A.ATTRIBUTE10, A.ATTRIBUTE11, A.ATTRIBUTE12, A.ATTRIBUTE13, A.ATTRIBUTE14, A.ATTRIBUTE15, A.PLANT_ID'


                --INSERT 문
                SET @mPartitionBy = @mPartitionBySegment1 + @mPartitionBySegment2 + @mPartitionBySegment3 + @mPartitionBySegment4 + @mPartitionBySegment5;
                DECLARE @mEXEC_INSERT NVARCHAR(MAX);
                SET @mEXEC_INSERT = '';
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'INSERT INTO '+ 'SCM_CODE_LOOKUP_VALUE' + ' SELECT ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'LOOKUP_TYPE_CODE,SEGMENT1,SEGMENT2,SEGMENT3,SEGMENT4,SEGMENT5,SORT_ORDER,ACTIVE_FLAG,VALUE_DESCRIPTION,CREATE_USER_ID,CREATE_DATE,MODIFY_USER_ID,MODIFY_DATE ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ',ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15,PLANT_ID ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'FROM ( SELECT DISTINCT LOOKUP_TYPE_CODE ' +   +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + @mInsertQuery  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ',RNUM = ROW_NUMBER() OVER (PARTITION BY LOOKUP_TYPE_CODE'+@mPartitionBy +' ORDER BY LOOKUP_TYPE_CODE' +@mPartitionBy +')'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'FROM ' + 'SCM_CODE_LOOKUP_VALUE' + ' A,  ZNERP_LOOKUP_CODE_HIST_DM C'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + 'WHERE 1=1'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + @mInsertWhereQuery;
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' AND 1=1'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' AND LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''''  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' AND A.ACTIVE_FLAG = ''Y'' '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' ) X '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' WHERE RNUM = 1 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + ' AND NOT EXISTS ( SELECT 1 '  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  FROM   SCM_CODE_LOOKUP_VALUE AS D'  +CHAR(10);
                SET @mEXEC_INSERT = @mEXEC_INSERT + '                  WHERE  D.LOOKUP_TYPE_CODE = X.LOOKUP_TYPE_CODE '  +CHAR(10);
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
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'SET A.ACTIVE_FLAG = ''N'' ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + '   ,A.MODIFY_USER_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + '   ,A.MODIFY_DATE = GETDATE() ' +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'FROM ' + 'SCM_CODE_LOOKUP_VALUE' + ' A,  ZNERP_LOOKUP_CODE_HIST_DM C'  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'WHERE 1=1'  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + @mInsertWhereQuery + CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'AND 1=1'  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + 'AND LOOKUP_TYPE_CODE = ''' + @LOOKUP_TYPE + ''''  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + ' AND  ACTIVE_FLAG = ''Y'' '  +CHAR(10);
                SET @mEXECUpdateActiveFlag = @mEXECUpdateActiveFlag + ';'  +CHAR(10);

                PRINT @mEXECUpdateActiveFlag;
                EXEC SP_EXECUTESQL @mEXECUpdateActiveFlag ;

                PRINT @TABLE_NAME + '3. ' +CONVERT(CHAR(23), GETDATE(), 21);


                UPDATE  ZNERP_LOOKUP_CODE_INFO_DM
                SET CONVERSION_FLAG = 'Y',
                    MODIFY_USER_ID = @CREATED_BY,
                    MODIFY_DATE = getDate()
                WHERE LOOKUP_TYPE = @LOOKUP_TYPE
                 AND  CONVERSION_FLAG = 'N'
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
        CLOSE LOOKUP_CURSOR;
        DEALLOCATE LOOKUP_CURSOR;


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

    --2025-06-13 상단 LOOP 안에 있는 것 아래로 내림
    --2025-06-13 PR_SCP_PLN_SSP_SHIP_REQ 가장하단 별도 처리(특수 케이스)
    --LOOKUP_TYPE <> 'PR_SCP_PLN_SSP_SHIP_REQ'
    --2025-06-13 PR_SCP_PLN_SSP_SHIP_REQ 가장하단 별도 처리(특수 케이스)

    --LOOKUP_TYPE <> 'PR_SCP_PLN_SSP_SHIP_REQ' SEGMENT2만 사용.
    --TABLE PK : LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
    -- 분리 → 변환 → 재결합 전체 프로세스
    --2023-06-17
    -- SEGMENT2,ATTRIBUTE3 2개가 변경되어야 한다
    WITH SplitData AS (
        SELECT
            LOOKUP_TYPE_CODE, CLV.SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
            CLV.SEGMENT2 AS OriginalValue,
            token AS SplitValue,
            ROW_NUMBER() OVER (PARTITION BY CLV.SEGMENT1 ORDER BY (SELECT NULL)) AS PartNum
        FROM SCM_CODE_LOOKUP_VALUE CLV  WITH(NOLOCK)
        CROSS APPLY STRING_SPLIT(CLV.SEGMENT2, ':') S
        WHERE CLV.SEGMENT2 LIKE '%:%'
        AND   CLV.LOOKUP_TYPE_CODE = 'PR_SCP_PLN_SSP_SHIP_REQ'
        AND   (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR @P_LOOKUP_TYPE ='ALL' OR LOOKUP_TYPE_CODE = @P_LOOKUP_TYPE)
    ),
    ConvertedData AS (
        SELECT
            s.LOOKUP_TYPE_CODE, s.SEGMENT1, s.SEGMENT2, s.SEGMENT3, s.SEGMENT4, s.SEGMENT5,
            s.OriginalValue,
            s.PartNum,
            ISNULL(MCV.NEW_VALUE1, s.SplitValue) AS ConvertedValue
        FROM SplitData s
        LEFT JOIN NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK) ON s.SplitValue = MCV.OLD_VALUE1 AND MCV.ATTRIBUTE5 = @P_ROLLIN
    )
    ,W_NERP AS (
        SELECT
            LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
            OriginalValue AS ORIG_VAL,
            STRING_AGG(ConvertedValue, ':') WITHIN GROUP (ORDER BY PartNum) AS NERP_CONV_VAL
        FROM ConvertedData
        GROUP BY LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, OriginalValue
    )
    --실제 PR_SCP_PLN_SSP_SHIP_REQ 프로시저에서 사용하는 것은 SEGMENT2만임
    UPDATE CLV
    SET    SEGMENT2 = NERP_CONV_VAL
    --SELECT ORIG_VAL,NERP_CONV_VAL,*
    FROM   SCM_CODE_LOOKUP_VALUE CLV
    JOIN   W_NERP AS WN
    ON     WN.LOOKUP_TYPE_CODE = CLV.LOOKUP_TYPE_CODE
    AND    WN.SEGMENT1         = CLV.SEGMENT1
    AND    WN.SEGMENT2         = CLV.SEGMENT2
    AND    WN.SEGMENT3         = CLV.SEGMENT3
    AND    WN.SEGMENT4         = CLV.SEGMENT4
    AND    WN.SEGMENT5         = CLV.SEGMENT5;

    --2023-06-17 ATTRIBUTE3 추가
    -- SEGMENT2,ATTRIBUTE3 2개가 변경되어야 한다
    WITH SplitData AS (
        SELECT
            LOOKUP_TYPE_CODE, CLV.SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
            CLV.ATTRIBUTE3 AS OriginalValue,
            token AS SplitValue,
            ROW_NUMBER() OVER (PARTITION BY CLV.SEGMENT1 ORDER BY (SELECT NULL)) AS PartNum
        FROM SCM_CODE_LOOKUP_VALUE CLV  WITH(NOLOCK)
        CROSS APPLY STRING_SPLIT(CLV.ATTRIBUTE3, ':') S
        WHERE CLV.ATTRIBUTE3 LIKE '%:%'
        AND   CLV.LOOKUP_TYPE_CODE = 'PR_SCP_PLN_SSP_SHIP_REQ'
        AND   (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR @P_LOOKUP_TYPE ='ALL' OR LOOKUP_TYPE_CODE = @P_LOOKUP_TYPE)
    ),
    ConvertedData AS (
        SELECT
            s.LOOKUP_TYPE_CODE, s.SEGMENT1, s.SEGMENT2, s.SEGMENT3, s.SEGMENT4, s.SEGMENT5,
            s.OriginalValue,
            s.PartNum,
            ISNULL(MCV.NEW_VALUE1, s.SplitValue) AS ConvertedValue
        FROM SplitData s
        LEFT JOIN NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK) ON s.SplitValue = MCV.OLD_VALUE1 AND MCV.ATTRIBUTE5 = @P_ROLLIN
    )
    ,W_NERP AS (
        SELECT
            LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5,
            OriginalValue AS ORIG_VAL,
            STRING_AGG(ConvertedValue, ':') WITHIN GROUP (ORDER BY PartNum) AS NERP_CONV_VAL
        FROM ConvertedData
        GROUP BY LOOKUP_TYPE_CODE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, OriginalValue
    )
    --실제 PR_SCP_PLN_SSP_SHIP_REQ 프로시저에서 사용하는 것은 SEGMENT2만임
    UPDATE CLV
    SET    ATTRIBUTE3 = NERP_CONV_VAL
    --SELECT ORIG_VAL,NERP_CONV_VAL,*
    FROM   SCM_CODE_LOOKUP_VALUE CLV
    JOIN   W_NERP AS WN
    ON     WN.LOOKUP_TYPE_CODE = CLV.LOOKUP_TYPE_CODE
    AND    WN.SEGMENT1         = CLV.SEGMENT1
    AND    WN.SEGMENT2         = CLV.SEGMENT2
    AND    WN.SEGMENT3         = CLV.SEGMENT3
    AND    WN.SEGMENT4         = CLV.SEGMENT4
    AND    WN.SEGMENT5         = CLV.SEGMENT5;

    --2025-06-13 PR_SCM_MST_SLOC외 PR_SCP_BI_FP_RESULT 형태의 5개 LOOKUP 10개 레코드 2ND에서 강제로 삭제요청
    WITH W_RAW AS (
        SELECT TRIM('PR_SCM_MST_SLOC                 ') AS LOOKUP_TYPE_CODE, TRIM('PLANT_ID') AS SEGMENT1, 'G389' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT             ') AS LOOKUP_TYPE_CODE, TRIM('ESMI    ') AS SEGMENT1, 'G380' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT             ') AS LOOKUP_TYPE_CODE, TRIM('HZP     ') AS SEGMENT1, 'G388' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_999952      ') AS LOOKUP_TYPE_CODE, TRIM('ESMI    ') AS SEGMENT1, 'G380' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_999952      ') AS LOOKUP_TYPE_CODE, TRIM('HZP     ') AS SEGMENT1, 'G388' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_DAILY       ') AS LOOKUP_TYPE_CODE, TRIM('ESMI    ') AS SEGMENT1, 'G380' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_DAILY       ') AS LOOKUP_TYPE_CODE, TRIM('HZP     ') AS SEGMENT1, 'G388' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_P5200       ') AS LOOKUP_TYPE_CODE, TRIM('ESMI    ') AS SEGMENT1, 'G380' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_P5200       ') AS LOOKUP_TYPE_CODE, TRIM('HZP     ') AS SEGMENT1, 'G388' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_P5200_999952') AS LOOKUP_TYPE_CODE, TRIM('ESMI    ') AS SEGMENT1, 'G380' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_BI_FP_RESULT_P5200_999952') AS LOOKUP_TYPE_CODE, TRIM('HZP     ') AS SEGMENT1, 'G388' AS SEGMENT2
    )
    DELETE CLV
    --SELECT *
    FROM   SCM_CODE_LOOKUP_VALUE CLV
    JOIN   W_RAW AS WR
    ON     WR.LOOKUP_TYPE_CODE = CLV.LOOKUP_TYPE_CODE
    AND    WR.SEGMENT1         = CLV.SEGMENT1
    AND    WR.SEGMENT2         = CLV.SEGMENT2
    AND   (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR @P_LOOKUP_TYPE ='ALL' OR CLV.LOOKUP_TYPE_CODE = @P_LOOKUP_TYPE)
    --2차일때 삭제
    AND    '2ND'               = @P_ROLLIN;

    --2025-08-05 PR_SCP_ANL_PSI_INTEGRATION_ESS외 PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only 2개 LOOKUP 3개 레코드 3RD에서 강제로 삭제처리
    WITH W_RAW AS (
        SELECT TRIM('PR_SCP_ANL_PSI_INTEGRATION_ESS          ') AS LOOKUP_TYPE_CODE, TRIM('ESNJ    ') AS SEGMENT1, 'G180'   AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_ANL_PSI_INTEGRATION_ESS          ') AS LOOKUP_TYPE_CODE, TRIM('ESNJ3   ') AS SEGMENT1, 'G183'   AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_ANL_PSI_INTEGRATION_ESS          ') AS LOOKUP_TYPE_CODE, TRIM('NB02    ') AS SEGMENT1, 'G634-A' AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_ANL_PSI_INTEGRATION_Small        ') AS LOOKUP_TYPE_CODE, TRIM('NJ_PLANT') AS SEGMENT1, 'G182'   AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only') AS LOOKUP_TYPE_CODE, TRIM('ESNJ    ') AS SEGMENT1, 'G180'   AS SEGMENT2 UNION
        SELECT TRIM('PR_SCP_ANL_PSI_INTEGRATION_ESS_Elec_only') AS LOOKUP_TYPE_CODE, TRIM('ESNJ3   ') AS SEGMENT1, 'G183'   AS SEGMENT2
    )
    DELETE CLV
    --SELECT *
    FROM   SCM_CODE_LOOKUP_VALUE CLV
    JOIN   W_RAW AS WR
    ON     WR.LOOKUP_TYPE_CODE = CLV.LOOKUP_TYPE_CODE
    AND    WR.SEGMENT1         = CLV.SEGMENT1
    AND    WR.SEGMENT2         = CLV.SEGMENT2
    AND   (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR @P_LOOKUP_TYPE ='ALL' OR CLV.LOOKUP_TYPE_CODE = @P_LOOKUP_TYPE)
    --2차일때 삭제
    AND    '3RD'               = @P_ROLLIN;

    ----2.1.2) INCOTERMS 사용 안하는 대상 Valid 'N' 처리
    --update SCM_CODE_LOOKUP_VALUE
    --set    active_flag = 'N'
    --        , modify_user_id = @CREATED_BY
    --        , modify_date = getdate()
    --from  SCM_CODE_LOOKUP_VALUE m with(nolock)
    --where  m.lookup_type_code = 'INCOTERMS'
    --and    m.segment1 in ( select distinct OLD_VALUE1
    --                        from   NERP_CONV_MASTER_CFM_V with(nolock)
    --                        where  CODETYPE = 'INCOTERMS_ID' )

    SET @UPDATE_CNT =  @@ROWCOUNT;

    -- STEP
    SET @v_log_type = 'STEP';
    SET @v_log_message = '';
    SET @n_log_count = @UPDATE_CNT ;
    SET @v_description = '/@UPDATE_CNT : ' + CAST(@UPDATE_CNT AS NVARCHAR(1000)) ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


    --2.1.3) BP_INCOTERMS 사용 안하는 대상 Valid 'N' 처리
    --update SCM_CODE_LOOKUP_VALUE
    --set    active_flag = 'N'
    --        , modify_user_id = @CREATED_BY
    --        , modify_date = getdate()
    --from  SCM_CODE_LOOKUP_VALUE m with(nolock)
    --where  m.lookup_type_code = 'BP_INCOTERMS'
    --and    m.segment2 in ( select distinct OLD_VALUE1
    --                        from   NERP_CONV_MASTER_CFM_V with(nolock)
    --                        where  CODETYPE = 'INCOTERMS_ID' )


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
