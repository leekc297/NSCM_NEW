
-- ==========================================================================================
-- Program:      PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_DM
-- Author:       김준규
-- Create date:  2025-03-30
-- Description:  LOOKUP 및 MASTER Table  데이터 가져오기
-- How to Execute: EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_DM @P_TABLE='PR_SCP_PLN_SSP_SHIP_REQ',@P_RTYPE='CODE_LOOKUP'
-- EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_DM @P_TABLE='SCM_LGTM_INV_PSI_DETAIL_GODS',@P_RTYPE='';
-- EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_DM @P_TABLE='DM_DNM_FULFILL',@P_RTYPE='';

-- ==========================================================================================
-- 2025-04-28       김준규       NERP) PR_SCP_NERP_COLUMN_CONVERTER_INSERT_FROM_PROD_LOOKUP_AND_MASTER 카피
-- 2025-06-08       김준규       NERP) 에러 발생시 DROP_NERP_CONV_INS_FR_PROD_PROG 테이블에도 기록
-- 2025-06-17       김준규       NERP) Parameter @P_TABLE 추가
-- 2025-09-09       김준규       NERP) ZNERP_TARGET_INFO_CURRENCY_DM TABLE 추가
-- 2025-09-11       김준규       NERP) ZNERP_TARGET_INFO_CURRENCY_DM TABLE 추가 제외 --> 기존 테이블에 MAPPING 추가하여 대체함

---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_DM]
   @P_TABLE nvarchar(128)=''
 , @P_RTYPE nvarchar(128)
AS
BEGIN

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
    DECLARE @V_ROWS_INSERTED BIGINT;
    DECLARE @LinkedServerName NVARCHAR(254) = '10.34.220.85,7433';
    DECLARE @DBPrefix NVARCHAR(254) = '[LGCE_SCMPROD].[DBO].';-- LINKED_SERVER 운영DB 사용

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_TMP_NERP_INSERT_FROM_PROD_BY_ENTIRE_TBL_REC_DM';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;
    DECLARE @DUMMY          NVARCHAR(MAX);


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_TABLE:'+@P_TABLE+',@P_RTYPE:'+@P_RTYPE;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

IF (@P_TABLE IS NULL OR @P_TABLE ='' OR EXISTS ( SELECT 1 FROM NERP_CONV_DM_TBL_NM_V WHERE TABLE_NAME = @P_TABLE AND RTYPE LIKE 'LOOKUP%' )  )
AND (@P_RTYPE IS NULL OR @P_RTYPE ='' OR 'LOOKUP' = @P_RTYPE)
BEGIN

    --################################################
    --LOOKUP 항목 삭제 후 INSERT --> 타 모듈 사용자도 사용
    --################################################
        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
            'SCM_ADM_LOOKUP_MASTER_DETAIL'
            ,'ALL'
            ,'ALL'
            ,FORMAT(GETDATE(),'yyyyMMdd')
        );
        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

        BEGIN TRY
            -- 트랜잭션 시작
            BEGIN TRANSACTION

            DELETE FROM LMD
            --SELECT *
            FROM   LGCE_SCMDEV.DBO.SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
            WHERE  1=1
            AND    EXISTS ( SELECT 1
                            FROM   ZNERP_LOOKUP_INFO_DM AS TID WITH(NOLOCK)
                            WHERE  1=1
                            AND    TID.LOOKUP_TYPE = LMD.LOOKUP_TYPE
                            AND    TID.LOOKUP_TYPE = IIF(ISNULL(@P_TABLE,'')='',TID.LOOKUP_TYPE,@P_TABLE)
                            )
            ;

            INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
            SELECT *
            FROM   [10.34.220.88,7433].[LGCE_SCMPROD].dbo.SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
            WHERE  1=1
            AND    EXISTS ( SELECT 1
                            FROM   ZNERP_LOOKUP_INFO_DM AS TID WITH(NOLOCK)
                            WHERE  1=1
                            AND    TID.LOOKUP_TYPE = LMD.LOOKUP_TYPE
                            AND    TID.LOOKUP_TYPE = IIF(ISNULL(@P_TABLE,'')='',TID.LOOKUP_TYPE,@P_TABLE)
                            )
            ;
            SET @V_ROWS_INSERTED = @@rowcount;
            UPDATE FPP
            SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                  ,LAST_UPDATE_DATE = GETDATE()
            FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
            WHERE  ID = @V_SCOPE_ID;

            -- 트랜잭션 커밋
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            PRINT 'Error processing table: ' + 'SCM_ADM_LOOKUP_MASTER_DETAIL'
            ROLLBACK TRANSACTION
            UPDATE FPP
            SET    TABLE_NAME = 'Err-->'+N'SCM_ADM_LOOKUP_MASTER_DETAIL'
                  ,SQL_STMT = @v_description
                  ,LAST_UPDATE_DATE = GETDATE()
            FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
            WHERE  ID = @V_SCOPE_ID;
            SET @v_description = N'Error processing table: ' + N'SCM_ADM_LOOKUP_MASTER_DETAIL' + ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;

            CHECKPOINT
            WAITFOR DELAY '00:00:00.1'

        END CATCH
    END

    --################################################
    --CODE_LOOKUP 항목 삭제 후 INSERT --> 타 모듈 사용자도 사용
    --################################################
IF (@P_TABLE IS NULL OR @P_TABLE ='' OR EXISTS ( SELECT 1 FROM NERP_CONV_DM_TBL_NM_V WHERE TABLE_NAME = @P_TABLE AND RTYPE LIKE 'CODE_LOOKUP%' )  )
AND (@P_RTYPE IS NULL OR @P_RTYPE ='' OR 'CODE_LOOKUP' = @P_RTYPE)
BEGIN
        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
            'SCM_CODE_LOOKUP_VALUE'
            ,'ALL'
            ,'ALL'
            ,FORMAT(GETDATE(),'yyyyMMdd')
        );

        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

        BEGIN TRY
            -- 트랜잭션 시작
            BEGIN TRANSACTION

            DELETE FROM LMD
            --SELECT *
            FROM   LGCE_SCMDEV.DBO.SCM_CODE_LOOKUP_VALUE AS LMD WITH(NOLOCK)
            WHERE  1=1
            AND    EXISTS ( SELECT 1
                            FROM   ZNERP_LOOKUP_CODE_INFO_DM AS TID WITH(NOLOCK)
                            WHERE  1=1
                            AND    TID.LOOKUP_TYPE = LMD.LOOKUP_TYPE_CODE
                            AND    TID.LOOKUP_VALID_YN = 'Y'
                            AND    TID.LOOKUP_TYPE = IIF(ISNULL(@P_TABLE,'')='',TID.LOOKUP_TYPE,@P_TABLE)
                            )
            ;

            INSERT INTO SCM_CODE_LOOKUP_VALUE
            SELECT *
            FROM   [10.34.220.88,7433].[LGCE_SCMPROD].dbo.SCM_CODE_LOOKUP_VALUE AS LMD WITH(NOLOCK)
            WHERE  1=1
            AND    EXISTS ( SELECT 1
                            FROM   ZNERP_LOOKUP_CODE_INFO_DM AS TID WITH(NOLOCK)
                            WHERE  1=1
                            AND    TID.LOOKUP_TYPE = LMD.LOOKUP_TYPE_CODE
                            AND    TID.LOOKUP_VALID_YN = 'Y'
                            AND    TID.LOOKUP_TYPE = IIF(ISNULL(@P_TABLE,'')='',TID.LOOKUP_TYPE,@P_TABLE)
                            )
            ;
            SET @V_ROWS_INSERTED = @@rowcount;
            UPDATE FPP
            SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                  ,LAST_UPDATE_DATE = GETDATE()
            FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
            WHERE  ID = @V_SCOPE_ID;

            -- 트랜잭션 커밋
            COMMIT TRANSACTION
        END TRY
        BEGIN CATCH
            PRINT 'Error processing table: ' + 'SCM_CODE_LOOKUP_VALUE'
            ROLLBACK TRANSACTION
            UPDATE FPP
            SET    TABLE_NAME = 'Err-->'+N'SCM_CODE_LOOKUP_VALUE'
                  ,SQL_STMT = @v_description
                  ,LAST_UPDATE_DATE = GETDATE()
            FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
            WHERE  ID = @V_SCOPE_ID;
            SET @v_description = N'Error processing table: ' + N'SCM_CODE_LOOKUP_VALUE' + ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        END CATCH
    END

    --##########################
    --아래 TABLE 34개(2025-04-29)
    --##########################
    -- 테이블 이름
    DECLARE @C_RTYPE NVARCHAR(30)
    DECLARE @C_TABLE_NAME NVARCHAR(128)
    DECLARE @C_COLUMNLIST NVARCHAR(MAX)
    DECLARE @C_IS_IDENTITY_YN NVARCHAR(1)
    DECLARE @C_IS_TBL_COLS_YN NVARCHAR(1)
    DECLARE @SQL NVARCHAR(MAX)=''
    -- 기존 mig_cursor가 있다면 제거
    IF CURSOR_STATUS('global', 'mig_cursor') >= 0
    BEGIN
        CLOSE mig_cursor
        DEALLOCATE mig_cursor
    END
    DECLARE mig_cursor CURSOR FOR
        --2025-03-30 김준규 아래 쿼리 수정시 반듯이 데이터 확인 필요. 아래에 TABLE TRUNCATE 있음
        WITH W_RAW_TBL AS (
            SELECT DISTINCT 'DM' RTYPE, TABLE_NAME AS TABLE_NAME ,1 AS SORT_SEQ
            FROM   ZNERP_TARGET_INFO_DM WITH(NOLOCK)
            WHERE  CONVERSION_FLAG <> '-'
            --UNION
            ---- 2025-09-09 김준규 NERP) ZNERP_TARGET_INFO_CURRENCY_DM TABLE 추가
            --SELECT DISTINCT 'DM' RTYPE, TABLE_NAME AS TABLE_NAME ,1 AS SORT_SEQ
            --FROM   ZNERP_TARGET_INFO_CURRENCY_DM WITH(NOLOCK)
            --WHERE  VALID_YN = 'Y'
        )
        SELECT TNV.RTYPE,TNV.TABLE_NAME,IIF(IDE.TBL_NM IS NOT NULL, 'Y','N') IS_IDENTITY_YN
              ,'N' IS_TBL_COLS_YN
        FROM   W_RAW_TBL TNV WITH(NOLOCK)
        LEFT JOIN ( SELECT t.name AS TBL_NM,max(c.name) AS colnumn_name
                    FROM   sys.tables t WITH(NOLOCK)
                    JOIN   sys.columns c WITH(NOLOCK) ON t.object_id = c.object_id
                    WHERE  c.is_identity = 1
                    GROUP BY t.name
                  ) AS IDE
        ON TNV.TABLE_NAME = IDE.TBL_NM
        WHERE  1=1
        AND    TNV.RTYPE NOT IN ('LOOKUP','LOOKUP_TYPE','STORAGE','IDENTITY','CUTOFF_MASTER','BIG')
        AND    (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR TNV.TABLE_NAME = @P_TABLE)
        AND    (@P_RTYPE IS NULL OR @P_RTYPE ='' OR TNV.RTYPE = @P_RTYPE)
        ORDER BY TNV.SORT_SEQ,TNV.RTYPE,TNV.TABLE_NAME

    OPEN mig_cursor

    -- MIG_TBL 커서에서 테이블 이름과 컬럼 이름 가져오기
    FETCH NEXT FROM mig_cursor INTO @C_RTYPE, @C_TABLE_NAME, @C_IS_IDENTITY_YN, @C_IS_TBL_COLS_YN

    WHILE @@FETCH_STATUS = 0
    BEGIN
        -- 동적 SQL 생성 및 실행

        INSERT INTO DROP_NERP_CONV_INS_FR_PROD_PROG (
            TABLE_NAME
            ,START_YYYYMMDD
            ,END_YYYYMMDD
            ,CURR_DATE
        ) VALUES(
             SUBSTRING(@C_TABLE_NAME+'|'+@C_RTYPE+'|'+@C_IS_IDENTITY_YN+'|'+@C_IS_TBL_COLS_YN,1,254)
            ,'ALL'
            ,'ALL'
            ,FORMAT(GETDATE(),'yyyyMMdd')
        );

        SELECT @V_SCOPE_ID = SCOPE_IDENTITY();

        --IDENTITY 아닌 테이블
        IF @C_IS_IDENTITY_YN = 'N' AND @C_IS_TBL_COLS_YN = 'N' BEGIN
            SET @SQL = N'
            TRUNCATE TABLE [LGCE_SCMDEV].DBO.' + QUOTENAME(@C_TABLE_NAME) + ';
            INSERT INTO ' + QUOTENAME(@C_TABLE_NAME) + '
            SELECT * FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
            ''SELECT * 
            FROM '+ @DBPrefix + QUOTENAME(@C_TABLE_NAME) + ' WITH(NOLOCK) '');
            SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;';
        END
        --@C_IS_IDENTITY_YN = 'Y'
        ELSE IF @C_IS_IDENTITY_YN = 'N' AND @C_IS_TBL_COLS_YN = 'Y' BEGIN
            -- 테이블의 전체 컬럼 목록 가져오기
            SELECT @C_COLUMNLIST = STRING_AGG(QUOTENAME(c.name), ', ')
            FROM sys.columns c WITH(NOLOCK)
            WHERE c.object_id = OBJECT_ID(@C_TABLE_NAME)
            --2025-04-22 컬럼 2개 제외 처리
            AND   c.name NOT IN ('IPRV_GOL_DIVS_CD', 'IPRV_GOL_RT')

            -- 컬럼 정보 출력
            PRINT 'Processing table: ' + @C_TABLE_NAME
            PRINT 'Columns: ' + @C_COLUMNLIST

            -- IDENTITY_INSERT ON과 INSERT를 하나의 sp_executesql로 실행
            SET @SQL = '
                TRUNCATE TABLE [LGCE_SCMDEV].DBO.' + QUOTENAME(@C_TABLE_NAME) + ';
                INSERT INTO ' + QUOTENAME(@C_TABLE_NAME) + ' (' + @C_COLUMNLIST + ') 
                SELECT ' + @C_COLUMNLIST + ' FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
                ''SELECT ' + @C_COLUMNLIST + ' 
                FROM '+ @DBPrefix + QUOTENAME(@C_TABLE_NAME) + ' WITH(NOLOCK) '');
                SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;';
        END
        --@C_IS_IDENTITY_YN = 'Y'
        ELSE BEGIN
            -- 테이블의 전체 컬럼 목록 가져오기
            SELECT @C_COLUMNLIST = STRING_AGG(QUOTENAME(c.name), ', ')
            FROM sys.columns c WITH(NOLOCK)
            WHERE c.object_id = OBJECT_ID(@C_TABLE_NAME)

            -- 컬럼 정보 출력
            PRINT 'Processing table: ' + @C_TABLE_NAME
            PRINT 'Columns: ' + @C_COLUMNLIST

            -- IDENTITY_INSERT ON과 INSERT를 하나의 sp_executesql로 실행
            SET @SQL = '
                SET IDENTITY_INSERT ' + QUOTENAME(@C_TABLE_NAME) + ' ON;
                TRUNCATE TABLE [LGCE_SCMDEV].DBO.' + QUOTENAME(@C_TABLE_NAME) + ';
                INSERT INTO ' + QUOTENAME(@C_TABLE_NAME) + ' (' + @C_COLUMNLIST + ') 
                SELECT ' + @C_COLUMNLIST + ' FROM OPENQUERY(' + QUOTENAME(@LinkedServerName) + N', 
                ''SELECT ' + @C_COLUMNLIST + ' 
                FROM '+ @DBPrefix + QUOTENAME(@C_TABLE_NAME) + ' WITH(NOLOCK) '');
                SET @V_ROWS_AFFECTED_OUT = @@ROWCOUNT;
                SET IDENTITY_INSERT ' + QUOTENAME(@C_TABLE_NAME) + ' OFF;';
        END

        PRINT @SQL  -- 디버깅용 출력

        BEGIN TRY
            BEGIN TRANSACTION;
                EXEC sp_executesql @SQL,
                     N'@V_ROWS_AFFECTED_OUT BIGINT OUTPUT',
                     @V_ROWS_AFFECTED_OUT = @V_ROWS_INSERTED OUTPUT;

                UPDATE FPP
                SET    INSERTED_ROWCNT = @V_ROWS_INSERTED
                      ,SQL_STMT = @SQL
                      ,LAST_UPDATE_DATE = GETDATE()
                FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID;
    
                CHECKPOINT
                WAITFOR DELAY '00:00:00.1'
    
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            IF @@TRANCOUNT > 0
                ROLLBACK TRANSACTION;
                    SET @v_description = 'Error executing SQL: ' + QUOTENAME(@C_TABLE_NAME) + '|' + @C_RTYPE + '|' + @C_IS_IDENTITY_YN + ''' ' + @SQL + ',' + ERROR_MESSAGE();
                    UPDATE FPP
                    SET    TABLE_NAME = 'Err-->'+TABLE_NAME
                          ,SQL_STMT = @v_description+','+@SQL
                          ,LAST_UPDATE_DATE = GETDATE()
                    FROM   DROP_NERP_CONV_INS_FR_PROD_PROG AS FPP WITH(NOLOCK)
                    WHERE  ID = @V_SCOPE_ID;
                    PRINT @v_description;
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;

                    CHECKPOINT
                    WAITFOR DELAY '00:00:00.1'

        END CATCH

        -- 다음 MIG_TBL 데이터 가져오기
        FETCH NEXT FROM mig_cursor INTO @C_RTYPE, @C_TABLE_NAME, @C_IS_IDENTITY_YN, @C_IS_TBL_COLS_YN
    END

    -- MIG_TBL 커서 닫기 및 해제
    CLOSE mig_cursor
    DEALLOCATE mig_cursor


    SET @BATCH_END_TIME = SYSDATETIME();
    SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
    PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  'END, RUN_TIME ', @BATCH_END_TIME;


END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();


END CATCH

END
