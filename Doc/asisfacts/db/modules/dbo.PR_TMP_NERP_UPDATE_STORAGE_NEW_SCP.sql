



-- ==========================================================================================
-- Program:        PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP
-- Author:         김준규
-- Create date:    2025-11-03
-- Description:    NERP) EG법인이 G690 PLANT가 EG00 EG01 PLANT로 나누어져서 기존 RULL과 맞지 않아서 먼저 처리토록 하고 이후는 동일
-- How to Execute: EXEC PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP @P_TABLE='SCM_DNM_STOCK',@P_ROLLIN='4N5',@P_TYPE='CUTOFF'; 'GENERAL' 또는 'CUTOFF' 둘중하나.
-- How to Execute: EXEC PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP @P_TABLE='SCM_MST_LOCATION',@P_ROLLIN='4N5',@P_TYPE='GENERAL'; 'GENERAL';  --pk없음

--SCM_MST_LOCATION -
--SCM_DNM_STOCK -6

----STORAGE 가진 테이블 테스트 처리순서
----1.운영에서 데이터 적재
----일반
--EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_SCP @P_TABLE ='SCM_MST_LOCATION',@P_RTYPE='';
----CUTOFF
--DECLARE @V_GROUP_NUM INT=0,@V_GROUP_COUNT INT=0;
--SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT FROM dbo.NERP_CONV_CUTOFF_TAKES_MIN 
--WHERE RTYPE =N'SCP' AND TABLE_NAME = 'SCM_DNM_STOCK'
--EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP @P_TABLE = 'SCM_DNM_STOCK',@P_ROLLIN='4N5',@P_DEL_TYPE='TRUNC',@P_RTYPE_NUM=99999,@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT;

----2.STORAGE PLANT ID 변경(EG01로 PLANT변경되는 것은 G691로 변경처리)
----일반
--EXEC PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP @P_TABLE = 'SCM_MST_LOCATION',@P_ROLLIN='4N5',@P_TYPE='GENERAL';
----CUTOFF
--EXEC PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP @P_TABLE = 'SCM_DNM_STOCK',@P_ROLLIN='4N5',@P_TYPE='GENERAL';
----점검사항
----1).BACKUP 되었나 RULL BACKUP_TABLE_NAME_YYYYMMDD_1 예:) BACKUP_SCM_MST_LOCATION_20251104_1
----2).PLANT_ID 컬럼에 G691 변경되어 있나 확인

----3.변경전 검증 실행
----일반
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='SCM_MST_LOCATION',@P_RTYPE='',@P_ROLLIN='4N5';
----CUTOFF
--DECLARE @V_GROUP_NUM INT=0,@V_GROUP_COUNT INT=0;
--SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT FROM dbo.NERP_CONV_CUTOFF_TAKES_MIN 
--WHERE RTYPE =N'SCP' AND TABLE_NAME = 'SCM_DNM_STOCK'
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_CUTOFF @P_TABLE='SCM_DNM_STOCK',@P_ROLLIN='4N5',@P_RTYPE_NUM=99999,@P_Matched='N',@P_UseProd='N',@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT,@P_GR_BATCH_ID=NULL;

----4.실제 테이블 변경 실행
----SELECT * FROM NERP_CONV_SCP_TBL_NM_V WITH(NOLOCK) WHERE TABLE_NAME IN ('SCM_MST_LOCATION','SCM_DNM_STOCK')
----일반
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER @P_TABLE='SCM_MST_LOCATION',@P_ROLLIN='4N5';
----CUTOFF
--DECLARE @V_GROUP_NUM INT=0,@V_GROUP_COUNT INT=0;
--SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT FROM dbo.NERP_CONV_CUTOFF_TAKES_MIN 
--WHERE RTYPE =N'SCP' AND TABLE_NAME = 'SCM_DNM_STOCK'
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER  @P_TABLE='SCM_DNM_STOCK',@P_GROUP='',@P_ROLLIN='4N5',@P_RTYPE_NUM=99999,@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT;
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF @P_TABLE='SCM_DNM_STOCK',@P_GROUP='',@P_ROLLIN='4N5',@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT;

----5.변경후 검증 실행
----일반
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_AFTER_ROWCNT_MASTER @P_TABLE='SCM_MST_LOCATION',@P_RTYPE='',@P_ROLLIN='4N5';
----CUTOFF
--DECLARE @V_GROUP_NUM INT=0,@V_GROUP_COUNT INT=0;
--SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT FROM dbo.NERP_CONV_CUTOFF_TAKES_MIN 
--WHERE RTYPE =N'SCP' AND TABLE_NAME = 'SCM_DNM_STOCK'
--EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_AFTER_ROWCNT_CUTOFF @P_TABLE='SCM_DNM_STOCK',@P_ROLLIN='4N5',@P_RTYPE_NUM=99999,@P_Matched='N',@P_UseProd='N',@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT,@P_GR_BATCH_ID=NULL;

-- ==========================================================================================
-- 2025-11-03       김준규       NERP) PR_TMP_NERP_COLUMN_CONVERTER_UPDATE_DM에서 쿼리문장 차용

--
--EG 플렌트 저장소 신규 프로세스.(STORAGE의해 분리되는 PLANT) --5차 또는 4N5에 한한여 처리한다.
--> MAPPING CODETYPE 저장소(STORAGE_ID) 있는 것에 한하여 처리한다.
--> DM의 BIG또는 SCP의 CUTOFF는 기간한정하여 작업한다.(백업포함 기간테이블 이용하여 처리)
--1.저장소 있는 테이블은 BACKUP한다. RULE(BACKUP_TABLE_NAME_YYYYMMDD_1 ~2 ~3)
--2.EG01가야할 대상의 TABLE의 PLANT(MAPPING CODETYPE=PLANT_ID)를 G690 --> G691로 변경한다. PLANT만 변경.
--3.MAPPING VIEW 테이블(NERP_CONV_MASTER_CFM_V)에서 EG01을 가진 STORAGE_ID는 OLD의 PLANT_ID G690을 G691로 변경(추가아님)(VIEW에서 변경)
--4.상기 먼저 처리 후 이후는 기존과 동일하게 프로세서를 흘리면 된다.

----DM의 BIG또는 SCP의 CUTOFF는 기간한정하여 작업한다.
----DM 룩업 --신규프로세서 작업대상 제외(코드만 변경함)
--SELECT *
--FROM   ZNERP_LOOKUP_INFO_DM LID WITH(NOLOCK)
--WHERE  1=1
--AND    LID.MASTER_CODETYPE = 'STORAGE_ID'
--AND    LID.LOOKUP_TYPE IN (SELECT TABLE_NAME
--                          FROM   NERP_CONV_DM_TBL_NM_V TNV WITH(NOLOCK)
--                          --WHERE  TNV.SORT_SEQ = 6
--                          )

----
----SCP CODE LOOKUP --신규프로세서 작업대상 제외(코드만 변경함)
--SELECT *
--FROM   ZNERP_LOOKUP_CODE_INFO_DM CID  WITH(NOLOCK)
--WHERE  1=1
--AND    CID.MASTER_CODETYPE = 'STORAGE_ID'
--AND    CID.LOOKUP_TYPE IN (SELECT TABLE_NAME
--                           FROM   NERP_CONV_DM_TBL_NM_V TNV WITH(NOLOCK)
--                           --WHERE  TNV.SORT_SEQ = 6
--                           )
--SELECT DISTINCT DIS.PROGRAM_ID
--FROM   ZNERP_DEV_ITEM_SCHEDULE DIS WITH(NOLOCK)
--WHERE  1=1
--AND    DIS.MAPPING_COLUMN = 'STORAGE_ID'
--AND    DIS.PROGRAM_ID IN (SELECT TABLE_NAME
--                          FROM   NERP_CONV_SCP_TBL_NM_V TNV WITH(NOLOCK)
--                          --WHERE  TNV.SORT_SEQ = 6
--                          )


---------------------------------------------------------------------------------------------
create PROCEDURE [dbo].[PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP]
   @P_TABLE          nvarchar(128)
 , @P_ROLLIN         nvarchar(30) = '5TH' --5차 또는 4N5차에 한한여 처리한다.
 , @P_TYPE           nvarchar(30) = 'GENERAL' --'GENERAL','CUTOFF'
AS
BEGIN

    IF @P_ROLLIN NOT IN ('5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN , Stop Procedure!!.');
        RETURN 0; -- 처리할 것이 없어서 성공 코드를 반환하며 프로시저 종료
    END
    IF @P_TYPE NOT IN ('GENERAL','CUTOFF')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_TYPE: '''+ISNULL(@P_TYPE,'Value is null ')+''' Please, Input Defined P_TYPE : GENERAL OR CUTOFF, Stop Procedure!!.');
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
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;

    SET @CNT = 0;
    SET @RUN_TIME = 0;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_UPDATE_STORAGE_NEW_SCP';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500) = '@P_TABLE:'+@P_TABLE+',@P_ROLLIN:'+@P_ROLLIN+',@P_TYPE:'+@P_TYPE;
    DECLARE @d_event_date   DATETIME;


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @d_event_date = SYSDATETIME();
    EXEC  PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

BEGIN TRY

    DECLARE @P_RTYPE_NUM   INT = 99999;
    DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @C_TABLE_NAME  NVARCHAR(128);
    DECLARE @C_TABLE_COL  NVARCHAR(128);
    DECLARE @C_CUTOFF_COL  NVARCHAR(128);
    DECLARE @C_CUT_COL1    NVARCHAR(128);
    DECLARE @C_CUT_COL2    NVARCHAR(128);
    DECLARE @C_CUT_COL3    NVARCHAR(128);
    DECLARE @C_CUT_COL4    NVARCHAR(128);
    DECLARE @C_C_FROM      NVARCHAR(128);
    DECLARE @C_C_TO        NVARCHAR(128);
    DECLARE @C_C_DIVISION  NVARCHAR(128);
    DECLARE @C_C_PLAN_TYPE NVARCHAR(128);
    DECLARE @SQL_STMT      NVARCHAR(MAX);
    DECLARE @DUMMY         NVARCHAR(MAX);
    DECLARE @crlf          CHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @pos           INT;
    DECLARE @StartTime     DATETIME2 = SYSDATETIME();
    DECLARE @RowCount      INT = 0;

    ---------------------
    --BACKUP PROCESS
    ---------------------

    DECLARE @BaseTableName NVARCHAR(254) = NULL; -- 기본 테이블 이름
    DECLARE @DatePart NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)
    DECLARE @NewTableName NVARCHAR(254);
    DECLARE @Counter INT = 1;
    DECLARE @SQL_TBL NVARCHAR(MAX);
    DECLARE @DropDateThreshold NVARCHAR(8);
    
    -- 커서가 이미 열려 있는지 확인
    IF CURSOR_STATUS('local', 'cur') >= 0
    BEGIN
        CLOSE cur;
        DEALLOCATE cur;
    END;
    DECLARE cur CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
        SELECT DISTINCT DIS.PROGRAM_ID AS TABLE_NAME--,TABLE_COL
        FROM   ZNERP_DEV_ITEM_SCHEDULE DIS WITH(NOLOCK)
        WHERE  1=1
        AND    DIS.MAPPING_COLUMN = 'PLANT_ID'
        AND    DIS.PROGRAM_ID IN (
            SELECT DISTINCT DIS.PROGRAM_ID
            FROM   ZNERP_DEV_ITEM_SCHEDULE DIS WITH(NOLOCK)
            WHERE  1=1
            AND    DIS.MAPPING_COLUMN = 'STORAGE_ID'
            AND    DIS.PROGRAM_ID IN (SELECT TABLE_NAME--,TNV.*
                                      FROM   NERP_CONV_SCP_TBL_NM_V TNV WITH(NOLOCK)
                                      --WHERE  TNV.SORT_SEQ = 6 CUTOFF_MASTER (SCP)
                                      WHERE  1=1
                                      AND 
                                      (
                                          (@P_TYPE = 'CUTOFF'  AND TNV.SORT_SEQ = 6)
                                          OR
                                          (@P_TYPE <> 'CUTOFF' AND TNV.SORT_SEQ <> 6)
                                      )                                      
                                      AND    TNV.TABLE_NAME = IIF(ISNULL(@P_TABLE,'')='',TNV.TABLE_NAME,@P_TABLE)
                                      )
        )
        ORDER BY 1
    
    OPEN cur
    
    FETCH NEXT FROM cur INTO @C_TABLE_NAME
    
    WHILE @@FETCH_STATUS = 0 BEGIN
    
    	SET @BaseTableName = @C_TABLE_NAME; -- 기본 테이블 이름
        SET @Counter = 1;
        
        SET @C_CUTOFF_COL = NULL;
        IF @P_TYPE = 'CUTOFF' BEGIN
            SELECT @C_CUTOFF_COL = SCM.CUTOFF_COLUMN1
            FROM   NERP_CONV_SCP_CUTOFF_MASTER SCM WITH(NOLOCK)
            WHERE  SCM.TABLE_NAME = @C_TABLE_NAME;
        END;
        ------------------------------------------------------------------------------------
        -- 테이블 백업 및 2개월 이상 백업 테이블 삭제
        ------------------------------------------------------------------------------------
        -- 2개월 전 날짜 계산
        SET @DropDateThreshold = FORMAT(DATEADD(month, -2, GETDATE()), 'yyyyMMdd');

        -- 테이블이 존재하는지 확인하고, 존재하면 숫자를 증가시켜 새로운 테이블 이름 생성
        WHILE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'BACKUP_' + @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR))
        BEGIN
            SET @Counter = @Counter + 1;
        END
        
        -- 최종 새로운 테이블 이름 설정
        SET @NewTableName = 'BACKUP_' + @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR);
        
        -- SELECT INTO 구문을 동적으로 생성
        IF @P_TYPE = 'CUTOFF' BEGIN
            IF @C_TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R' BEGIN
            SET @SQL_TBL = N'
            SELECT *,GETDATE() AS CUR_TIME INTO ' + @NewTableName + ' FROM ' + @BaseTableName + '
            WHERE  ' + QUOTENAME(@C_CUTOFF_COL) + ' >= FORMAT(DATEADD(MONTH,-6,ISNULL(CONVERT(DATE,'''+@V_FR_YYYYMMDD+'''),''20250326'')),''yyyyMM'')
            AND    ' + QUOTENAME(@C_CUTOFF_COL) + ' < FORMAT(ISNULL(CONVERT(DATE,'''+@V_TO_YYYYMMDD+'''),''20250326''),''yyyyMM'');';             
            END
            ELSE BEGIN
            SET @SQL_TBL = N'
            SELECT *,GETDATE() AS CUR_TIME INTO ' + @NewTableName + ' FROM ' + @BaseTableName + '
            WHERE ' + QUOTENAME(@C_CUTOFF_COL) + ' >= ''' + ISNULL(@V_FR_YYYYMMDD,'20250326') + '''
            AND   ' + QUOTENAME(@C_CUTOFF_COL) + ' < ''' + ISNULL(@V_TO_YYYYMMDD,'20250326') + ''';';
            END
        END
        ELSE BEGIN
        SET @SQL_TBL = 'SELECT *,GETDATE() AS CUR_TIME INTO ' + @NewTableName + ' FROM ' + @BaseTableName + ';';
        END
        
        PRINT N'SELECT INTO 백업 '+@SQL_TBL;
        -- 동적 SQL 실행
        EXEC sp_executesql @SQL_TBL;
        
        ------------------------------------------------------------------------------------
        -- 2개월 이전 테이블 DROP 로직
        ------------------------------------------------------------------------------------
        DECLARE @DropTableName NVARCHAR(254);
        DECLARE @DropSQL NVARCHAR(MAX);

        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('local', 'TableCursor') >= 0
        BEGIN
            CLOSE TableCursor;
            DEALLOCATE TableCursor;
        END;
        DECLARE TableCursor CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
        SELECT TABLE_NAME
        FROM   INFORMATION_SCHEMA.TABLES
        WHERE  TABLE_NAME LIKE @BaseTableName + '_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_%' -- 날짜 패턴 포함
        AND    SUBSTRING(TABLE_NAME, LEN(@BaseTableName) + 2, 8) < @DropDateThreshold;

        OPEN TableCursor;

        FETCH NEXT FROM TableCursor INTO @DropTableName;

        WHILE @@FETCH_STATUS = 0
        BEGIN
            SET @DropSQL = 'DROP TABLE ' + @DropTableName + ';';
            BEGIN TRY
                EXEC sp_executesql @DropSQL;
                PRINT N'테이블 삭제됨: ' + @DropTableName;
            END TRY
            BEGIN CATCH
                PRINT N'테이블 삭제 실패: ' + @DropTableName;
                PRINT ERROR_MESSAGE();
            END CATCH;

            FETCH NEXT FROM TableCursor INTO @DropTableName;
        END;

        CLOSE TableCursor;
        DEALLOCATE TableCursor;

    	FETCH NEXT FROM cur INTO @C_TABLE_NAME
    
    END
    
    CLOSE cur
    DEALLOCATE cur


    -- 커서가 이미 열려 있는지 확인
    IF CURSOR_STATUS('local', 'cur_PLANT_COL') >= 0
    BEGIN
        CLOSE cur_PLANT_COL;
        DEALLOCATE cur_PLANT_COL;
    END;
    DECLARE cur_PLANT_COL CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
        SELECT DISTINCT DIS.PROGRAM_ID AS TABLE_NAME,DIS.DEV_DETAIL AS TABLE_COL, SCM.CUTOFF_COLUMN1
        FROM   ZNERP_DEV_ITEM_SCHEDULE DIS WITH(NOLOCK)
        LEFT JOIN NERP_CONV_SCP_CUTOFF_MASTER AS SCM WITH (NOLOCK) ON SCM.TABLE_NAME = DIS.PROGRAM_ID
        WHERE  1=1
        AND    DIS.MAPPING_COLUMN = 'PLANT_ID'
        AND    DIS.PROGRAM_ID IN (
            SELECT DISTINCT DIS.PROGRAM_ID
            FROM   ZNERP_DEV_ITEM_SCHEDULE DIS WITH(NOLOCK)
            WHERE  1=1
            AND    DIS.MAPPING_COLUMN = 'STORAGE_ID'
            AND    DIS.PROGRAM_ID IN (SELECT TABLE_NAME--,TNV.*
                                      FROM   NERP_CONV_SCP_TBL_NM_V TNV WITH(NOLOCK)
                                      --WHERE  TNV.SORT_SEQ = 6 CUTOFF_MASTER (SCP)
                                      WHERE  1=1
                                      AND 
                                      (
                                          (@P_TYPE = 'CUTOFF'  AND TNV.SORT_SEQ = 6)
                                          OR
                                          (@P_TYPE <> 'CUTOFF' AND TNV.SORT_SEQ <> 6)
                                      )                                      
                                      AND    TNV.TABLE_NAME = IIF(ISNULL(@P_TABLE,'')='',TNV.TABLE_NAME,@P_TABLE)
                                      )
        )
        ORDER BY 1

    OPEN cur_PLANT_COL;

    FETCH NEXT FROM cur_PLANT_COL INTO @C_TABLE_NAME, @C_TABLE_COL, @C_CUTOFF_COL;

    WHILE @@FETCH_STATUS = 0 BEGIN

            PRINT '------------------------------------------------------------------------------------------------------------------------------------------';
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @C_DISP_TBL_NM, 0, '0', '', @START_TIME;
            SET @DUMMY = 'RUN -->> '+concat(
            '     @CNT = ' , @CNT
            , ' , @C_TABLE_NAME = ', @C_TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            , ' , @P_ROLLIN = ' , @P_ROLLIN
            );

            PRINT @DUMMY;

            DECLARE @C_STORAGE_ID NVARCHAR(254)
            
            -- 커서가 이미 열려 있는지 확인
            IF CURSOR_STATUS('local', 'cur_STORAGE') >= 0
            BEGIN
                CLOSE cur_STORAGE;
                DEALLOCATE cur_STORAGE;
            END;
            DECLARE cur_STORAGE CURSOR FAST_FORWARD READ_ONLY LOCAL FOR
                SELECT DIS.DEV_DETAIL AS STORAGE_ID
                FROM   ZNERP_DEV_ITEM_SCHEDULE DIS WITH(NOLOCK)
                WHERE  1=1
                AND    DIS.MAPPING_COLUMN = 'STORAGE_ID'
                AND    DIS.PROGRAM_ID = @C_TABLE_NAME
            
            
            OPEN cur_STORAGE
            
            FETCH NEXT FROM cur_STORAGE INTO @C_STORAGE_ID
            
            WHILE @@FETCH_STATUS = 0 BEGIN
            
                SET @SQL_STMT = N'
                UPDATE U 
                SET    '+@C_TABLE_COL+' = ''G691''
                FROM   '+QUOTENAME(@C_TABLE_NAME) + N' AS U
                JOIN   NERP_CONV_MASTER_CFM_V MCV WITH(NOLOCK) 
                ON     MCV.OLD_VALUE1 = U.'+@C_TABLE_COL+N' AND MCV.OLD_VALUE2 = U.'+@C_STORAGE_ID+N' --> STORAGE 컬럼이 달라짐
                WHERE  1=1
                AND    U.'+@C_TABLE_COL+' = ''G690''
                AND    MCV.CODETYPE   = ''STORAGE_ID'' 
                AND    MCV.NEW_VALUE1 = ''EG01''
                AND    MCV.ATTRIBUTE5 = '''+@P_ROLLIN+''' ';            	
                IF @P_TYPE = 'CUTOFF' BEGIN
                    IF @C_TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R' BEGIN
                    SET @SQL_TBL = N'
                AND    U.' + QUOTENAME(@C_CUTOFF_COL) + ' >= FORMAT(DATEADD(MONTH,-6,ISNULL(CONVERT(DATE,'''+@V_FR_YYYYMMDD+'''),''20250326'')),''yyyyMM'')
                AND    U.' + QUOTENAME(@C_CUTOFF_COL) + ' < FORMAT(ISNULL(CONVERT(DATE,'''+@V_TO_YYYYMMDD+'''),''20250326''),''yyyyMM'');';             
                    END
                    ELSE BEGIN
                    SET @SQL_STMT += N'
                AND    U.' + QUOTENAME(@C_CUTOFF_COL) + ' >= ''' + ISNULL(@V_FR_YYYYMMDD,'20250326') + '''
                AND    U.' + QUOTENAME(@C_CUTOFF_COL) + ' < ''' + ISNULL(@V_TO_YYYYMMDD,'20250326') + ''';';
                    END
                END;
                SET @SQL_STMT += N'
                SET @RowCount = @@ROWCOUNT;
                ';
            
                -----------------------------------------------------------------------
                -- 6. 실행 또는 출력
                -----------------------------------------------------------------------
                DECLARE @Params NVARCHAR(400) = N'@BatchSize INT = 1000000, @RowCount INT OUTPUT';
                
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
                        --UPDATE 수량 기록
                        INSERT INTO NERP_CONV_CMP_SCP(BATCH_ID,RTYPE,TABLE_NAME,CNT_ACT_CHG_Y,A_COL1,A_COL2)
                        VALUES (-1,'EG01',@C_TABLE_NAME,@RowCount,@C_TABLE_COL,@C_STORAGE_ID);
                        --
                        PRINT 'Update completed.';
                        PRINT 'Rows affected: ' + CAST(@RowCount AS NVARCHAR(20));
                        PRINT 'Elapsed: ' +
                              CAST(DATEDIFF(MILLISECOND, @StartTime, SYSDATETIME()) AS NVARCHAR(20)) + ' ms';
                    END TRY
                    BEGIN CATCH
                        PRINT 'Error executing dynamic SQL: ' + ERROR_MESSAGE();
                        --IF XACT_STATE() <> 0 ROLLBACK TRAN;
                        SET @DUMMY = @C_TABLE_NAME+','+@v_description+','+'Error executing dynamic SQL: ' + ERROR_MESSAGE();
                        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
                        --에러 나도 계속 실생되어야 한다.
                        --RETURN;
                    END CATCH
                END

            	FETCH NEXT FROM cur_STORAGE INTO @C_STORAGE_ID
            
            END
            
            CLOSE cur_STORAGE
            DEALLOCATE cur_STORAGE

        FETCH NEXT FROM cur_PLANT_COL INTO @C_TABLE_NAME, @C_TABLE_COL, @C_CUTOFF_COL;

    END

    CLOSE cur_PLANT_COL
    DEALLOCATE cur_PLANT_COL

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
