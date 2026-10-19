



-- =============================================
-- Author:       P.C.I
-- Create date:  2024-03-25
-- Description:  Big(Cutoff) table info data converter(PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_SSP3 Copy)
-- =============================================
/*
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2025-04-27   김준규      NERP) ROLLIN 차수 PARAMETER화
 * 2025-04-29   김준규      NERP) NERP_CONV_MASTER_CFM_V 뷰테이블로 변경 및 모두 ROLLIN 컬럼 추가
 * 2025-06-08   김준규      NERP) 한개컬럼에 2개 CODETYPE 작업하도록 변경
 * 2025-06-12   김준규      NERP) DM_PLN_MKT_FCST_RESULT_C SCM_SITE_ID 관련하여 MASTER_CODETYPE IN ( ''SCP_SITE_ID'',''SCM_SITE_ID'',''SITE_ID'' ) 순서변경
 * 2025-09-13   김준규      NERP) CURRENCY_ID 를 OR로 추가 
 * 2025-09-17   김준규      NERP) 테이블 시작위치로 옮김 SET @d_event_date = SYSDATETIME();
 * 2025-09-24   김준규      NERP) HINT 추가 DM_PLN_MKT_FCST_C A (INDEX(PK_DM_PLN_MKT_FCST_C_PART),NOLOCK),DM_PLN_MKT_FCST_RESULT_C (INDEX(IDX_DM_PLN_MKT_FCST_RESULT_C_SUPPLY_VERSION),NOLOCK)
                                          ,DM_PLN_SALES_PLAN_C A (INDEX(PK_dm_pln_sales_plan_c_part),NOLOCK), DM_PLN_SALES_PLAN_REPORT_C A (INDEX(PK_DM_PLN_SALES_PLAN_REPORT_C),NOLOCK)
 * 2025-10-14   김준규      NERP) 작업분배 방식 사용, 사용기간 선택 추가.
 * 2025-10-16   김준규      NERP) ZNERP_TARGET_HIST_DM 테이블을 그룹으로 사용시는 동일 테이블을 사용할 수 없어서 @HIST_DM_TableName 변수로 만들어서 사용해야 함

EXEC [dbo].[PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG]
    @P_TABLE ='DM_PLN_SALES_ETC_PLAN_C'
  , @P_ROLLIN = '3RD'

*/
CREATE PROCEDURE [dbo].[PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG]
   @P_TABLE NVARCHAR(150)=NULL
 , @P_GROUP nvarchar(4)=NULL --사용되지 않는 값 SCP랑 같은 구조로 만듦.
 , @P_ROLLIN  nvarchar(30) --1ST 2ND 3RD 4TH
 , @P_GROUP_NUM INT --그룹카운트 중 몇번째 것
 , @P_GROUP_COUNT INT
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

    DECLARE @TABLE_NAME   NVARCHAR(150) = @P_TABLE;
    DECLARE @SAVED_TABLE_NAME NVARCHAR(150) ='';
    DECLARE @DUMMY_TABLE_NAME NVARCHAR(150) ='';

    DECLARE @CUTOFF_START nvarchar(100)
    DECLARE @CUTOFF_FROM nvarchar(100)
    DECLARE @CUTOFF_TO nvarchar(100)
    DECLARE @DIVISION nvarchar(100)
    DECLARE @PLAN_TYPE nvarchar(100)
    DECLARE @SEQ nvarchar(100)
    DECLARE @RNO INT

    DECLARE @COL_INFO   NVARCHAR(150) = N'';
    DECLARE @TABLE_COL   NVARCHAR(150) = N'';
    DECLARE @TABLE_COL2   NVARCHAR(150) = N'';
    DECLARE @TABLE_COL3   NVARCHAR(150) = N'';
    DECLARE @WH_TBL_COL1  NVARCHAR(150) = N'';
    DECLARE @WH_TBL_COL2  NVARCHAR(150) = N'';
    DECLARE @WH_TBL_COL3  NVARCHAR(150) = N'';
    DECLARE @WH_TBL_COL4  NVARCHAR(150) = N'';
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

    DECLARE @SQL_VAR NVARCHAR(MAX) ='';
    DECLARE @BACKUP_VALID NVARCHAR(500) = NULL;

    DECLARE  @mADDUpdateWhereQuery NVARCHAR(MAX) = '';
    DECLARE  @mADDSubQuery NVARCHAR(MAX) = '';
    DECLARE  @mSavedQuery NVARCHAR(MAX) = '';
    DECLARE  @CNT_LOOP INT=0;

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM_BIG';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500) = '@P_TABLE='+@P_TABLE+',@P_GROUP='+@P_GROUP+',@P_ROLLIN='+@P_ROLLIN+',@P_GROUP_NUM='+CONVERT(CHAR(23),@P_GROUP_NUM)+',@P_GROUP_COUNT='+CONVERT(CHAR(23),@P_GROUP_COUNT);
    DECLARE @d_event_date   DATETIME;

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @d_event_date = SYSDATETIME();
    EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


    ------------------------------------------------------
    --STEP 0. TARGET TABLE HANDLE
    ------------------------------------------------------
    DECLARE @WORK_AVALIABLE TABLE (TABLE_COL NVARCHAR(150), MASTER_CODETYPE NVARCHAR(150));

    IF CURSOR_STATUS('global', 'LOOKUP_CURSOR_B') >= 0
    BEGIN
        CLOSE LOOKUP_CURSOR_B;
        DEALLOCATE LOOKUP_CURSOR_B;
    END
    DECLARE LOOKUP_CURSOR_B CURSOR FOR
        --TABLE_NAME에서 컬럼당 CONV_MASTER가 한개, 또는 2개~3개를 순서적으로 CONVERSION할때,
        --각각 컬럼당 CONV_MASTER가 1회만 만 가능하여 여러번 하게 됨.
        SELECT DISTINCT TABLE_NAME,RNUM
        FROM (
            SELECT TID.TABLE_NAME,TABLE_COL, MASTER_CODETYPE=IIF(MASTER_CODETYPE = 'SITE_ID','SCP_SITE_ID',MASTER_CODETYPE)
                  ,ROW_NUMBER()OVER(PARTITION BY TID.TABLE_NAME,TABLE_COL ORDER BY CASE WHEN MASTER_CODETYPE IN ( 'END_CUSTOMER_ID','VENDOR_ID') THEN 1
                        WHEN MASTER_CODETYPE IN ( 'SCP_SITE_ID','SCM_SITE_ID','SITE_ID' ) THEN 2
                        WHEN MASTER_CODETYPE = 'PLANT_ID' THEN 3
                        WHEN MASTER_CODETYPE = 'COMPANY_ID' THEN 4
                       ELSE 99 END) RNUM
            FROM ZNERP_TARGET_INFO_DM AS TID WITH(NOLOCK)
            JOIN NERP_CONV_DM_CUTOFF_MASTER AS DCM WITH (NOLOCK)
            ON   DCM.TABLE_NAME = TID.TABLE_NAME AND ISNULL(DCM.MAPPING_USE,'Y') = 'Y'
            JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON DCM.TABLE_NAME = CTM.TABLE_NAME
            WHERE ISNULL(DCM.MAPPING_USE,'Y') = 'Y'
              AND CTM.RTYPE = 'DM'
              AND CTM.GROUP_NUM = @P_GROUP_NUM
              AND CTM.GROUP_COUNT = @P_GROUP_COUNT
            --AND  CONVERSION_FLAG = 'N'
            --AND TABLE_NAME = ISNULL(@P_TABLE, TABLE_NAME)
            AND   (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR TID.TABLE_NAME = @P_TABLE)
        ) X
        ORDER BY TABLE_NAME,RNUM ASC

    OPEN LOOKUP_CURSOR_B;
    FETCH NEXT FROM LOOKUP_CURSOR_B
    INTO @TABLE_NAME,@RNUM

    WHILE @@FETCH_STATUS = 0
    BEGIN

    SET @CNT_LOOP = @CNT_LOOP +1;
    PRINT '@CNT,@TABLE_NAME:'+CONVERT(NVARCHAR(10),@CNT_LOOP)+','+@TABLE_NAME;
    --아래에서 여기로 옮김 2025-09-17
    IF @RNUM = 1  BEGIN
        SET @d_event_date = SYSDATETIME();
    END;

------------------------------------------------------
--STEP 2. TARGET TABLE UPDATE
------------------------------------------------------
        DELETE 
        FROM @WORK_AVALIABLE;

        SET @mEXEC = N'';
        SET @mEXEC = @mEXEC + N'
        SELECT DISTINCT TABLE_COL
             , MASTER_CODETYPE
        FROM   ZNERP_TARGET_INFO_DM WITH(NOLOCK)
        WHERE  TABLE_NAME = '''+ @TABLE_NAME + '''
        --AND    BIG_CONVERSION_FLAG = ''N''
        ';

        SET @mEXEC = N'';
        SET @mEXEC = @mEXEC + N'
        --TABLE_NAME에서 컬럼당 CONV_MASTER가 한개, 또는 2개~3개를 순서적으로 CONVERSION할때,
        --각각 컬럼당 CONV_MASTER가 1회만 만 가능하여 여러번 하게 됨.
        --MASTER_CODETYPE 가 ''SITE_ID'' 일 경우 ''SCP_SITE_ID'' 값으로 대체하여 처리
        SELECT TABLE_COL, MASTER_CODETYPE
        FROM (
            SELECT TABLE_COL, MASTER_CODETYPE= IIF(MASTER_CODETYPE = ''SITE_ID'',''SCP_SITE_ID'',MASTER_CODETYPE)
                  ,ROW_NUMBER()OVER(PARTITION BY TABLE_COL ORDER BY CASE WHEN MASTER_CODETYPE IN ( ''END_CUSTOMER_ID'',''VENDOR_ID'') THEN 1
                        WHEN MASTER_CODETYPE IN ( ''SCP_SITE_ID'',''SCM_SITE_ID'',''SITE_ID'' ) THEN 2
                        WHEN MASTER_CODETYPE = ''PLANT_ID'' THEN 3
                        WHEN MASTER_CODETYPE = ''COMPANY_ID'' THEN 4
                       ELSE 99 END) RNUM
            FROM   ZNERP_TARGET_INFO_DM
            WHERE  1=1
            AND    TABLE_NAME = ''' + @TABLE_NAME + '''
            --AND    BIG_CONVERSION_FLAG = ''N''
            --AND    CONVERSION_FLAG <> ''-''
        ) X
        WHERE RNUM = '''+@RNUM+''' ';
        PRINT @mEXEC;
        INSERT @WORK_AVALIABLE EXEC SP_EXECUTESQL @mEXEC ;

        --DEBUG용
        DECLARE @D_TABLE_COL NVARCHAR(254);
        DECLARE @D_MASTER_CODETYPE NVARCHAR(254);


        DECLARE cur_DBUG1 CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
            SELECT TABLE_COL, MASTER_CODETYPE
            FROM @WORK_AVALIABLE

        OPEN cur_DBUG1

        FETCH NEXT FROM cur_DBUG1 INTO @D_TABLE_COL,@D_MASTER_CODETYPE

        WHILE @@FETCH_STATUS = 0 BEGIN

            PRINT '1 @RNUM:'+@RNUM;
            PRINT '1 @D_TABLE_COL:'+@D_TABLE_COL;
            PRINT '1 @D_MASTER_CODETYPE:'+@D_MASTER_CODETYPE;

            FETCH NEXT FROM cur_DBUG1 INTO @D_TABLE_COL,@D_MASTER_CODETYPE

        END

        CLOSE cur_DBUG1
        DEALLOCATE cur_DBUG1


        SELECT TOP 1
                @WH_TBL_COL1 = CDC.CUTOFF_COLUMN1
                ,@WH_TBL_COL2 = CDC.CUTOFF_COLUMN2
                ,@WH_TBL_COL3 = CDC.CUTOFF_COLUMN3
                ,@WH_TBL_COL4 = CDC.CUTOFF_COLUMN4
        FROM   NERP_CONV_DM_CUTOFF CDC WITH(NOLOCK)
        WHERE  CDC.TABLE_NAME = @TABLE_NAME;

        PRINT '@WH_TBL_COL1:'+ISNULL(@WH_TBL_COL1,'NULL');
        PRINT '@WH_TBL_COL2:'+ISNULL(@WH_TBL_COL2,'NULL');
        PRINT '@WH_TBL_COL3:'+ISNULL(@WH_TBL_COL3,'NULL');
        PRINT '@WH_TBL_COL4:'+ISNULL(@WH_TBL_COL4,'NULL');

        IF CURSOR_STATUS('global', 'LOOKUP_CURSOR') >= 0
        BEGIN
            CLOSE LOOKUP_CURSOR;
            DEALLOCATE LOOKUP_CURSOR;
        END
        DECLARE LOOKUP_CURSOR CURSOR FOR
            -- Data List
            SELECT D.TABLE_NAME
                 , D.CUTOFF_FROM as CUTOFF_FROM
                 , D.CUTOFF_TO as CUTOFF_TO
                 , D.CUTOFF_DIVISION AS DIVISION
                 , D.CUTOFF_PLAN_TYPE AS PLAN_TYPE
                 , D.cutoff_sort as rno
                 , D.CUTOFF_START
                 --, M.PRIORITY_GROUP
             FROM NERP_CONV_DM_CUTOFF D WITH (NOLOCK)
        LEFT JOIN NERP_CONV_DM_CUTOFF_MASTER M WITH (NOLOCK) ON D.TABLE_NAME = M.TABLE_NAME
             JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON D.TABLE_NAME = CTM.TABLE_NAME
            where D.MAPPING_USE = 'Y'
              AND CTM.RTYPE = 'DM'
              AND CTM.GROUP_NUM = @P_GROUP_NUM
              AND CTM.GROUP_COUNT = @P_GROUP_COUNT
            AND   D.TABLE_NAME = @TABLE_NAME
            order by D.TABLE_NAME ASC, D.CUTOFF_FROM DESC

        OPEN LOOKUP_CURSOR;
        FETCH NEXT FROM LOOKUP_CURSOR
        INTO @DUMMY_TABLE_NAME, @CUTOFF_FROM, @CUTOFF_TO, @DIVISION, @PLAN_TYPE, @RNO, @CUTOFF_START

        WHILE @@FETCH_STATUS = 0
        BEGIN

        PRINT '--###########################################################--'

        PRINT '@DUMMY_TABLE_NAME:'+@DUMMY_TABLE_NAME;
        PRINT '@CUTOFF_FROM  :'+@CUTOFF_FROM ;
        PRINT '@CUTOFF_TO    :'+@CUTOFF_TO   ;
        PRINT '@DIVISION     :'+@DIVISION    ;
        PRINT '@PLAN_TYPE    :'+@PLAN_TYPE   ;
        --PRINT '@RNO          :'+@RNO         ;
        PRINT '@CUTOFF_START :'+@CUTOFF_START;
        PRINT '---------------------------------';

            --Big 테이블 조건
            --초기화
            SET @mADDUpdateWhereQuery ='';
            SET @mADDSubQuery = '';

            IF @WH_TBL_COL1 <> '-' BEGIN
            SET @mADDUpdateWhereQuery = @mADDUpdateWhereQuery + CHAR(10) + ' AND '+@WH_TBL_COL1+' = ''' + @CUTOFF_FROM + ''''+ CHAR(10);
            END;
            IF @WH_TBL_COL2 <> '-' BEGIN
            SET @mADDUpdateWhereQuery = @mADDUpdateWhereQuery + ' AND '+@WH_TBL_COL2+' = ''' + @CUTOFF_TO + ''''+ CHAR(10);
            END;
            IF @WH_TBL_COL3 <> '-' BEGIN
            SET @mADDUpdateWhereQuery = @mADDUpdateWhereQuery + ' AND '+@WH_TBL_COL3+' = ''' + @DIVISION + ''''+ CHAR(10);
            END;
            IF @WH_TBL_COL4 <> '-' BEGIN
            SET @mADDUpdateWhereQuery = @mADDUpdateWhereQuery + ' AND '+@WH_TBL_COL4+' = ''' + @PLAN_TYPE + ''''+ CHAR(10);
            END;

            IF @WH_TBL_COL1 <> '-' BEGIN
            SET @mADDSubQuery = @mADDSubQuery + 'WHERE  '+@WH_TBL_COL1+' = ''' + @CUTOFF_FROM + ''''+ CHAR(10);
            END;
            IF @WH_TBL_COL2 <> '-' BEGIN
            SET @mADDSubQuery = @mADDSubQuery + 'AND    '+@WH_TBL_COL2+' = ''' + @CUTOFF_TO + ''''+ CHAR(10);
            END;
            IF @WH_TBL_COL3 <> '-' BEGIN
            SET @mADDSubQuery = @mADDSubQuery + 'AND    '+@WH_TBL_COL3+' = ''' + @DIVISION + ''''+ CHAR(10);
            END;
            IF @WH_TBL_COL4 <> '-' BEGIN
            SET @mADDSubQuery = @mADDSubQuery + 'AND    '+@WH_TBL_COL4+' = ''' + @PLAN_TYPE + ''''+ CHAR(10);
            END;

        --PRINT '@mADDUpdateWhereQuery:'+@mADDUpdateWhereQuery;
        --PRINT '@mADDSubQuery:'+@mADDSubQuery;

        -----------------------------------------------
        -- STEP 2-1. DISTINCT COLUMN STRING MAKE
        -- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
        -----------------------------------------------
        --테이블 이름이 바뀔때 1회만 한다.
        --동일 테이블에 RNUM 2 일때도 실행되야한다.
        IF NOT (@TABLE_NAME = @SAVED_TABLE_NAME AND @RNUM = '1')
        BEGIN
            SET @SAVED_TABLE_NAME = @TABLE_NAME;
            DECLARE  @mDisQuery NVARCHAR(MAX) = '';
            DECLARE  @mSubQuery NVARCHAR(MAX) = '';
            DECLARE  @mSavedSubQuery NVARCHAR(MAX) = '';
            DECLARE  @mUpdateQuery NVARCHAR(MAX) = '';
            DECLARE  @mUpdateWhereQuery NVARCHAR(MAX) = '';
            DECLARE  @mSavedUpdateWhereQuery NVARCHAR(MAX) = '';
            DECLARE  @mTableQuery NVARCHAR(MAX) = '';

            SET @mDisQuery = '';
            SET @mSubQuery = '';
            SET @mUpdateQuery = '';
            SET @mUpdateWhereQuery = '';
            SET @mTableQuery = '';
            DECLARE @PRIFIX NVARCHAR(30);

            DECLARE @V_START_DATETIME   DATETIME = GETDATE() ;


        ----DEBUG용
        --DECLARE @D_TABLE_COL NVARCHAR(254);
        --DECLARE @D_MASTER_CODETYPE NVARCHAR(254);


        DECLARE cur_DBUG2 CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
            SELECT TABLE_COL, MASTER_CODETYPE
            FROM @WORK_AVALIABLE

        OPEN cur_DBUG2

        FETCH NEXT FROM cur_DBUG2 INTO @D_TABLE_COL,@D_MASTER_CODETYPE

        WHILE @@FETCH_STATUS = 0 BEGIN

            PRINT '2 @RNUM:'+@RNUM;
            PRINT '2 @D_TABLE_COL:'+@D_TABLE_COL;
            PRINT '2 @D_MASTER_CODETYPE:'+@D_MASTER_CODETYPE;

            FETCH NEXT FROM cur_DBUG2 INTO @D_TABLE_COL,@D_MASTER_CODETYPE

        END

        CLOSE cur_DBUG2
        DEALLOCATE cur_DBUG2


            IF CURSOR_STATUS('global', 'LOOKUP_CURSOR2') >= 0
            BEGIN
                CLOSE LOOKUP_CURSOR2;
                DEALLOCATE LOOKUP_CURSOR2;
            END
            DECLARE LOOKUP_CURSOR2 CURSOR FOR SELECT TABLE_COL, MASTER_CODETYPE FROM @WORK_AVALIABLE ORDER BY TABLE_COL
            SET @CNT = 1;

            OPEN LOOKUP_CURSOR2;
            FETCH NEXT FROM LOOKUP_CURSOR2
            INTO  @TABLE_COL3, @MASTER_CODETYPE3;

            PRINT @TABLE_NAME + '1. ' +CONVERT(CHAR(23), GETDATE(), 21);

            PRINT '@TABLE_COL3:' + @TABLE_COL3;
            PRINT '@MASTER_CODETYPE3:' + @MASTER_CODETYPE3;


        ----DEBUG용
        --DECLARE @D_TABLE_COL NVARCHAR(254);
        --DECLARE @D_MASTER_CODETYPE NVARCHAR(254);



            WHILE @@FETCH_STATUS = 0
            BEGIN



        DECLARE cur_DBUG3 CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
            SELECT TABLE_COL, MASTER_CODETYPE
            FROM @WORK_AVALIABLE

        OPEN cur_DBUG3

        FETCH NEXT FROM cur_DBUG3 INTO @D_TABLE_COL,@D_MASTER_CODETYPE

        WHILE @@FETCH_STATUS = 0 BEGIN

            PRINT '3 @RNUM:'+@RNUM;
            PRINT '3 @D_TABLE_COL:'+@D_TABLE_COL;
            PRINT '3 @D_MASTER_CODETYPE:'+@D_MASTER_CODETYPE;

            FETCH NEXT FROM cur_DBUG3 INTO @D_TABLE_COL,@D_MASTER_CODETYPE

        END

        CLOSE cur_DBUG3
        DEALLOCATE cur_DBUG3

                -----------------------------------------------
                -- STEP 2-1. DISTINCT COLUMN STRING MAKE
                -- DISTINCT A.COMPANY_ID, B1.TO_COMPANY_ID AS COMPANY_ID_B1, A.PLANT_ID, B2.TO_PLANT_ID AS PLANT_ID_B2, A.TO_PLANT_ID, B3.TO_PLANT_ID AS PLANT_ID_B3
                -----------------------------------------------
                BEGIN
                    IF @mDisQuery = ''
                    BEGIN  --처음인경우
                        IF @MASTER_CODETYPE3 = 'STORAGE_ID' OR @MASTER_CODETYPE3 = 'VAT_CODE_ID' OR @MASTER_CODETYPE3 = 'PROFIT_CENTER_ID'
                        BEGIN
                            SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        END
                        ELSE
                        BEGIN
                            SET @mDisQuery = @mDisQuery + 'DISTINCT A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        END
                    END
                    ELSE
                    BEGIN --두번째인경우
                        IF @MASTER_CODETYPE3 = 'STORAGE_ID' OR @MASTER_CODETYPE3 = 'VAT_CODE_ID' OR @MASTER_CODETYPE3 = 'PROFIT_CENTER_ID'
                        BEGIN
                            SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE2' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        END
                        ELSE
                        BEGIN
                            SET @mDisQuery = @mDisQuery + ', A.' + @TABLE_COL3 + ', B'  + CONVERT(VARCHAR, @CNT) + '.NEW_VALUE1' + ' AS ' + @MASTER_CODETYPE3 + '_B'  + CONVERT(VARCHAR, @CNT)
                        END

                    END
                END
                --PRINT CONCAT('@SAVED_TABLE_NAME:',@SAVED_TABLE_NAME ,'@TABLE_NAME:', @TABLE_NAME);
                --PRINT '@mDisQuery:'+@mDisQuery;
                -----------------------------------------------
                -- STEP 2-2. DISTINCT COLUMN STRING MAKE
                -- LEFT JOIN NERP_CONV_MASTER_CFM_V B1
                -- ON A.COMPANY_ID = B1.FROM_COMPANY_ID
                -- AND B1.CODETYPE = 'COMPANY_ID'
                -----------------------------------------------
                -- 2025-09-13 CURRENCY_ID OR로 추가 
                IF @MASTER_CODETYPE3 LIKE '%COMPANY%' OR  @MASTER_CODETYPE3 LIKE '%CURRENCY%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
--                          SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.FROM_' + @MASTER_CODETYPE3 +'' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3 +'''' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%END_CUSTOMER%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    --SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3 +'''' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' '+CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%VENDOR%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%SITE%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    --SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE IN ( ' + '''' +@MASTER_CODETYPE3+'''' + ', ''PLANT_ID'', ''SCP_SITE_ID'' )'+CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%DISTRIBUTE_CHANNERL%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%SALES_GROUP%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%MOVEMENT_TYPE%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%BIZ_AREA%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%DOCUMENT_TYPE%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%PROFIT_CENTER%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END

                IF @MASTER_CODETYPE3 LIKE '%VAT_CODE%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE3 = ''KR'''+CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                END
                /*
                IF @MASTER_CODETYPE3 LIKE '%INCOTERMS%'
                BEGIN
                    SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);

                    IF @TABLE_NAME = 'DM_DNM_SALES_RESULT_IF'
                    BEGIN
                        SET @mSubQuery = @mSubQuery + 'AND IIF(ISNULL(A.COMPANY_ID, '''') IN ( ''C100'',''HQ00''), ''D'', ''E'')  = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                    END
                    ELSE
                    BEGIN
                        SET @mSubQuery = @mSubQuery + 'AND IIF(ISNULL(A.DOM_EXP, '''') = '''', ''E'', A.DOM_EXP)  = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                    END


                END
                */
                IF EXISTS (SELECT 1 FROM @WORK_AVALIABLE WHERE MASTER_CODETYPE = N'STORAGE_ID' )
                BEGIN
                    IF @MASTER_CODETYPE3 LIKE '%STORAGE_ID%'
                    BEGIN
                        SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE2' + '' +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ''' +@MASTER_CODETYPE3 +''' ' +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)

                        SELECT @PLANT_COL1 = TABLE_COL
                        FROM @WORK_AVALIABLE
                        WHERE MASTER_CODETYPE = N'PLANT_ID';

                        SET @mSubQuery = @mSubQuery + 'AND A.'+ @PLANT_COL1 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                    END
                    IF @MASTER_CODETYPE3 LIKE '%PLANT%'
                    BEGIN
                        SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                        --SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE = ' + '''' +@MASTER_CODETYPE3+'''' +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE IN ( ' + '''' +@MASTER_CODETYPE3+'''' + ', ''SCP_SITE_ID'' )'+CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 IN ( '''+@P_ROLLIN+''' ) '+CHAR(10);  --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                    END
                END

                ELSE
                BEGIN
                    IF @MASTER_CODETYPE3 LIKE '%PLANT%'
                    BEGIN
                        SET @mSubQuery = @mSubQuery + 'LEFT JOIN NERP_CONV_MASTER_CFM_V B' + CONVERT(VARCHAR, @CNT) +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'ON A.'+ @TABLE_COL3 + ' = B' + CONVERT(VARCHAR, @CNT) + '.OLD_VALUE1' + '' +CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.CODETYPE IN ( ' + '''' +@MASTER_CODETYPE3+'''' + ', ''SCP_SITE_ID'' )'+CHAR(10);
                        SET @mSubQuery = @mSubQuery + 'AND B' + CONVERT(VARCHAR, @CNT) + '.ATTRIBUTE5 = '''+@P_ROLLIN+''' '+CHAR(10);   --1ST,2ND,3RD (1차 오픈, 2차 오픈, 3차 오픈 대상 구분)
                    END
                END

            --PRINT '@mSubQuery:'+@mSubQuery;
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
            -- STEP 2-4. UPDATE QUERY MAKE
            -- WHERE 1=1
            -- AND COMPANY_ID = C.COMPANY_ID
            -- AND PLANT_ID = C.PLANT_ID
            -- AND TO_PLANT_ID = C.TO_PLANT_ID
            -----------------------------------------------
            BEGIN
                SET @mUpdateWhereQuery = @mUpdateWhereQuery + ' AND ISNULL(A.' + @TABLE_COL3 + ', '''') = ISNULL(C.' + @TABLE_COL3 + ', '''')';
            END

            -----------------------------------------------
            -- STEP 2-4. DYNAMIC TABLE QUERY MAKE 컬럼 우측 나열
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
            INTO  @TABLE_COL3, @MASTER_CODETYPE3;

            END; --LOOKUP_CURSOR2 WHILE

            CLOSE LOOKUP_CURSOR2;
            DEALLOCATE LOOKUP_CURSOR2;

            SET @mSavedUpdateWhereQuery = @mUpdateWhereQuery;
            SET @mSavedSubQuery = @mSubQuery;
            --PRINT '@mSavedUpdateWhereQuery:'+@mSavedUpdateWhereQuery;
            --PRINT '@mSavedSubQuery:'+@mSavedSubQuery;
        END;--IF @TABLE_NAME <> @SAVED_TABLE_NAME 테이블이 변경될때 1회에 한해 한다.

        --Big 테이블 조건(상단에서 만들어 놓은 쿼리 KEY 값 조합)
        SET @mUpdateWhereQuery = @mSavedUpdateWhereQuery + @mADDUpdateWhereQuery + CHAR(10);
        SET @mSubQuery = @mSavedSubQuery + @mADDSubQuery + CHAR(10);

        --PRINT '@@mUpdateWhereQuery:'+@mUpdateWhereQuery;
        --PRINT '@@mSubQuery:'+@mSubQuery;

            --2025-10-16 김준규 ZNERP_TARGET_HIST_DM 테이블을 그룹으로 사용시는 동일 테이블을 사용할 수 없어서 변수로 만들어서 사용해야 함
            DECLARE @HIST_DM_TableName NVARCHAR(128);
            DECLARE @SQL_STMT NVARCHAR(MAX);
            -- ZNERP_TARGET_HIST_DM 테이블 삭제
            --아래 table앞에 dbo 붙이면 에러가 난다.
            SET @HIST_DM_TableName = N'dbo.ZNERP_TARGET_HIST_DM'+CONVERT(NVARCHAR(30),@P_GROUP_NUM) ; -- N 접두사는 유니코드 문자열을 의미
            --아래 table앞에 dbo 안붙이니 에러가 나지 않는다.
            SET @HIST_DM_TableName = N'ZNERP_TARGET_HIST_DM'+CONVERT(NVARCHAR(30),@P_GROUP_NUM) ; -- N 접두사는 유니코드 문자열을 의미
            SET @SQL_STMT = N'DROP TABLE IF EXISTS ' + QUOTENAME(@HIST_DM_TableName) + ';'; 
            EXEC sp_executesql @SQL_STMT;

            --IF OBJECT_ID('DBO.ZNERP_TARGET_HIST_DM') IS NOT NULL
            --    DROP TABLE DBO.ZNERP_TARGET_HIST_DM

            DECLARE @SQL NVARCHAR(MAX);
            --2025-10-16 김준규 ZNERP_TARGET_HIST_DM 테이블을 그룹으로 사용시는 동일 테이블을 사용할 수 없어서 변수로 만들어서 사용해야 함
            --SET @SQL = 'CREATE TABLE DBO.ZNERP_TARGET_HIST_DM(';
            SET @SQL = 'CREATE TABLE '+@HIST_DM_TableName+'(';
            --SELECT @SQL = @SQL + @mTableQuery;
            --SELECT @SQL = @SQL + ')'
            SET @SQL = @SQL + @mTableQuery;
            SET @SQL = @SQL + ')'

            PRINT @SQL;

            EXEC(@SQL);

            DECLARE @mEXECSelInto NVARCHAR(MAX);
            SET @mEXECSelInto = '';
            --2025-10-16 김준규 ZNERP_TARGET_HIST_DM 테이블을 그룹으로 사용시는 동일 테이블을 사용할 수 없어서 변수로 만들어서 사용해야 함
            --SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO DBO.ZNERP_TARGET_HIST_DM' +CHAR(10);
            SET @mEXECSelInto = @mEXECSelInto + 'INSERT INTO '+@HIST_DM_TableName + CHAR(10);
            SET @mEXECSelInto = @mEXECSelInto + 'SELECT ' + @mDisQuery  +CHAR(10);
            SET @mEXECSelInto = @mEXECSelInto + 'FROM ' + @TABLE_NAME + (CASE WHEN @TABLE_NAME='DM_PLN_MKT_FCST_C' THEN ' A WITH (INDEX(PK_DM_PLN_MKT_FCST_C_PART))' --PK_DM_PLN_MKT_FCST_C_PART IDX_DM_PLN_MKT_FCST_C_SUPPLY_VERSION
                                                                             WHEN @TABLE_NAME='DM_PLN_MKT_FCST_RESULT_C' THEN ' A WITH (INDEX(IDX_DM_PLN_MKT_FCST_RESULT_C_SUPPLY_VERSION))' 
                                                                             WHEN @TABLE_NAME='DM_PLN_SALES_PLAN_C' THEN ' A WITH (INDEX(PK_dm_pln_sales_plan_c_part))' 
                                                                             WHEN @TABLE_NAME='DM_PLN_SALES_PLAN_REPORT_C' THEN ' A WITH (INDEX(PK_DM_PLN_SALES_PLAN_REPORT_C))' 
                                                                             --WHEN @TABLE_NAME='DM_PLN_SALES_PLAN_RESULT_C' THEN ' A WITH (INDEX(IX_YYYYMMDD_SALES_PLAN_RESULT_C))' --시간더걸려서 막음
                                                                             --WHEN @TABLE_NAME='DM_PLN_CFM_SELLING_PRICE_C' THEN ' A WITH (INDEX(PK_DM_PLN_CFM_SELLING_PRICE_C_PART))' --시간더걸려서 막음
                                                                             ELSE ' A' END) +CHAR(10);
            SET @mEXECSelInto = @mEXECSelInto + @mSubQuery;


            PRINT @mEXECSelInto;
            EXEC SP_EXECUTESQL @mEXECSelInto ;

            PRINT @TABLE_NAME + '2. ' +CONVERT(CHAR(23), GETDATE(), 21);
            SET @UPDATE_START_TIME = CONVERT(CHAR(23), GETDATE(), 21);

            DECLARE @mEXEC_UPDATE NVARCHAR(MAX);
            SET @mEXEC_UPDATE = '';
            SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'UPDATE '+ @TABLE_NAME + ' SET '  +CHAR(10);
            SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateQuery  +CHAR(10);
            SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'FROM ' + @TABLE_NAME + (CASE WHEN @TABLE_NAME='DM_PLN_MKT_FCST_C' THEN ' A WITH (INDEX(PK_DM_PLN_MKT_FCST_C_PART)), ' 
                                                                             WHEN @TABLE_NAME='DM_PLN_MKT_FCST_RESULT_C' THEN ' A WITH (INDEX(IDX_DM_PLN_MKT_FCST_RESULT_C_SUPPLY_VERSION)), ' 
                                                                             WHEN @TABLE_NAME='DM_PLN_SALES_PLAN_C' THEN ' A WITH (INDEX(PK_dm_pln_sales_plan_c_part)), ' 
                                                                             WHEN @TABLE_NAME='DM_PLN_SALES_PLAN_REPORT_C' THEN ' A WITH (INDEX(PK_DM_PLN_SALES_PLAN_REPORT_C)), ' 
                                                                             --WHEN @TABLE_NAME='DM_PLN_SALES_PLAN_RESULT_C' THEN ' A WITH (INDEX(IX_YYYYMMDD_SALES_PLAN_RESULT_C)), '  --시간더걸려서 막음
                                                                             --WHEN @TABLE_NAME='DM_PLN_CFM_SELLING_PRICE_C' THEN ' A WITH (INDEX(PK_DM_PLN_CFM_SELLING_PRICE_C_PART)), ' --시간더걸려서 막음
            --2025-10-16 김준규 ZNERP_TARGET_HIST_DM 테이블을 그룹으로 사용시는 동일 테이블을 사용할 수 없어서 변수로 만들어서 사용해야 함
                                                                             --ELSE ' A, ' END) + '  DBO.ZNERP_TARGET_HIST_DM C'  +CHAR(10);
                                                                             ELSE ' A, ' END) + @HIST_DM_TableName+' C'  +CHAR(10);
            SET @mEXEC_UPDATE = @mEXEC_UPDATE + 'WHERE 1=1'  +CHAR(10);
            SET @mEXEC_UPDATE = @mEXEC_UPDATE + @mUpdateWhereQuery;

            DECLARE @UPDATE_CNT INT;
            PRINT @mEXEC_UPDATE;
            EXEC SP_EXECUTESQL @mEXEC_UPDATE ;

            SELECT @UPDATE_CNT = @@ROWCOUNT;

            SET @UPDATE_END_TIME = CONVERT(CHAR(23), GETDATE(), 21);

            PRINT @TABLE_NAME + '3. ' +CONVERT(CHAR(23), GETDATE(), 21);

            UPDATE  ZNERP_XLS_CHANGE_MASTER_CODE_DM
            SET UPDATE_QUERY = @mEXEC_UPDATE,
            CHECK_QUERY = @mEXECSelInto,
            UPDATE_CNT = UPDATE_CNT + @UPDATE_CNT,
            --UPDATE_START_TIME = @UPDATE_START_TIME,
            UPDATE_END_TIME = @UPDATE_END_TIME
            WHERE PROCESS_TYPE = @TABLE_NAME;


            -- STEP
            SET @v_log_type = 'STEP';
            SET @n_log_count = @UPDATE_CNT;
            SET @v_log_message = 'EXEC Time : ' +  cast(datediff(ss, @V_START_DATETIME, SYSDATETIME()) as  nvarchar(4000)) + ', Event: ' + cast(datediff(ss, @d_event_date, SYSDATETIME()) as  nvarchar(4000)) ;
            SET @v_description = @TABLE_NAME + '/@mEXECSelInto : ' + @mEXECSelInto + '/@mEXEC_UPDATE : ' + @mEXEC_UPDATE  ;
            --위로 옮김 2025-09-17
            --SET @d_event_date = SYSDATETIME();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            FETCH NEXT FROM LOOKUP_CURSOR
            INTO @DUMMY_TABLE_NAME, @CUTOFF_FROM, @CUTOFF_TO, @DIVISION, @PLAN_TYPE, @RNO, @CUTOFF_START

        END--LOOKUP_CURSOR WHILE

        CLOSE LOOKUP_CURSOR;
        DEALLOCATE LOOKUP_CURSOR;

        FETCH NEXT FROM LOOKUP_CURSOR_B
        INTO @TABLE_NAME,@RNUM

    END--LOOKUP_CURSOR_B WHILE

    CLOSE LOOKUP_CURSOR_B;
    DEALLOCATE LOOKUP_CURSOR_B;

    --COMMIT;
    PRINT 'Transaction succeed!';

    -- 종료 LOG
    SET @v_log_type = 'END';
    SET @v_log_message = '########## END of procedure ##########';
    SET @n_log_count = 0;
    SET @v_description = @P_TABLE;
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
        PRINT @v_log_message;
        SET @n_log_count = 0;
        SET @v_description = @TABLE_NAME + '/ERROR_LINE : ' + STR(ERROR_LINE());
        PRINT @v_description;
        SET @d_event_date = SYSDATETIME();
        SELECT '[' + Convert(NVARCHAR(10), ERROR_NUMBER()) + ']' + ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;


        DECLARE @fileCursorStatus INT;

        SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'LOOKUP_CURSOR_B');

        IF (@fileCursorStatus >= 0)
        BEGIN
            PRINT 'Closing fileCursor LOOKUP_CURSOR_B';
            CLOSE LOOKUP_CURSOR_B;
            DEALLOCATE LOOKUP_CURSOR_B;
        END

        SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'LOOKUP_CURSOR');

        IF (@fileCursorStatus >= 0)
        BEGIN
            PRINT 'Closing fileCursor LOOKUP_CURSOR';
            CLOSE LOOKUP_CURSOR;
            DEALLOCATE LOOKUP_CURSOR;
        END

        SET @fileCursorStatus = CURSOR_STATUS('GLOBAL', 'LOOKUP_CURSOR2');

        IF (@fileCursorStatus >= 0)
        BEGIN
            PRINT 'Closing fileCursor LOOKUP_CURSOR2';
            CLOSE LOOKUP_CURSOR2;
            DEALLOCATE LOOKUP_CURSOR2;
        END
    --------------------------------------------------------------
    END CATCH;
    --------------------------------------------------------------
END
