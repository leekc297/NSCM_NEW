
/*
 * Program ID  : PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE
 * Description  : Batch Conversion One Table STORAGE
 * Execute      :
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2024-08-13   vadabi5     NERP) Batch Conversion Loop Table Default
 * 2025-04-21   김준규      NERP) CURSOR_CONVERT CURSOR에 and (@P_TABLE IS NULL OR @P_TABLE ='' OR program_id = @P_TABLE) 추가
 ----------------------------------------------------------------------------------------------------
 exec  PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE 'SCM_MST_VMI_INT_SLOC'
 exec  PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE 'SCM_DNM_MAT_IMPORT_BL'
 exec  PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE 'SCM_DNM_MONTH_CLOSE_INVENTORY'
 exec  PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE ''
------------------------------------------------------------------------------
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE  @P_TABLE='SCM_DNM_MAT_PO_RECEIPT',@P_ROLLIN='2ND'
------------------------------------------------------------------------------
    SELECT *
    FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
    where DEV_TYPE = 'Batch_Conversion'
    and mapping_use IN ( 'UP', 'CA')
    and ISNULL(MAPPING_COMMENT,'') != 'FINISH'
    and program_id = 'SCM_MST_VMI_INT_SLOC'

------------------------------------------------------------------------------
    select *
    from SCM_SYS_LOG_BATCH
    where PROGRAM_NAME = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE'
    and event_date > '2024-10-04'
    order by event_date

------------------------------------------------------------------------------
INSERT INTO NERP_CONV_SCP_DATA
 (TABLE_NAME, COLUMN_NAME1, COLUMN_NAME2,COLUMN_NAME3, OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2)
 select
 'SCM_MST_VMI_INT_SLOC' , 'CONV_STORAGE', 'PLANT_ID', 'STORAGE_ID'
 ,PLANT_ID, STORAGE_ID
 ,MAX(P.NEW_VALUE1) AS TOBE_PLANT_ID
 ,MAX(B.NEW_VALUE2) AS TOBE_STORAGE_ID
 FROM SCM_MST_VMI_INT_SLOC A with (nolock)
 LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) P ON A.PLANT_ID = P.OLD_VALUE1
 LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V where CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN) B
 ON A.PLANT_ID = B.OLD_VALUE1
 AND A.STORAGE_ID = B.OLD_VALUE2
 group by PLANT_ID, STORAGE_ID

 ------------------------------------------------------------------------------
 UPDATE.SCM_MST_VMI_INT_SLOC
    SET.SCM_MST_VMI_INT_SLOC.PLANT_ID = ISNULL(B.TOBE_PLANT,   A.PLANT_ID)
       ,SCM_MST_VMI_INT_SLOC.STORAGE_ID = ISNULL(B.TOBE_STORAGE, A.STORAGE_ID)
  FROM .SCM_MST_VMI_INT_SLOC AS A,
(
    select distinct A.old_value1
         , A.old_value2
         , B.new_value1 AS TOBE_PLANT
         , ISNULL(A.new_value2, A.OLD_VALUE2) AS TOBE_STORAGE
         from NERP_CONV_SCP_DATA   A
         left join (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) B
         on A.old_value1 = B.OLD_VALUE1
         where column_name1 = 'CONV_STORAGE'
         and isnull(B.new_value1,'') != ''
        and table_name = 'SCM_MST_VMI_INT_SLOC'
) AS B
 WHERE A.STORAGE_ID = B.OLD_VALUE2
 AND  A.PLANT_ID = B.OLD_VALUE1




 */
CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE]

 @P_TABLE   nvarchar(100)
,@P_ROLLIN  nvarchar(30) --1ST 2ND 3RD 4TH

AS
BEGIN
    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

    DECLARE @TABLE_NAME   NVARCHAR(150) = N'';
    SET @TABLE_NAME = @P_TABLE
    DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N'';
    DECLARE @COL_INFO   NVARCHAR(150) = N'';

    DECLARE @CNT INT;
    DECLARE @ACT_CNT INT;
    DECLARE @WORK_SECOND INT;

    DECLARE @SELECT_COL NVARCHAR(MAX);
    DECLARE @mEXEC NVARCHAR(MAX);
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @BACKUP_START_TIME  NVARCHAR(50) = N'';
    DECLARE @BACKUP_END_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_START_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_END_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_TIME  BIGINT = 0;
    DECLARE @COLUMN_NAME  NVARCHAR(50) = N'';
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;
    DECLARE @DUMMY NVARCHAR(MAX);


    DECLARE @MAPPING_COLUMN  NVARCHAR(50) = N'';

    DECLARE  @mDisQuery NVARCHAR(MAX) = '';
    DECLARE  @mSubQuery NVARCHAR(MAX) = '';
    DECLARE  @mUpdateQuery NVARCHAR(MAX) = '';
    DECLARE  @mUpdateWhereQuery NVARCHAR(MAX) = '';
    DECLARE  @mTableQuery NVARCHAR(MAX) = '';
    DECLARE  @message NVARCHAR(MAX) = '';

    DECLARE @USE_BACKUP  NVARCHAR(50) = 'N';
    DECLARE @USE_MAPPING  NVARCHAR(50) = 'Y';
    DECLARE @USE_MAPPING_TEST  NVARCHAR(50) = 'Y';

    DECLARE @TABLE_NAME_BACKUP   NVARCHAR(150) = N'';
    DECLARE @MAPPING_TYPE   NVARCHAR(150) = 'up';
    DECLARE @QUERY NVARCHAR(MAX) = '';
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;
    DECLARE @TIME_DIFF BIGINT

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_STORAGE';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    --declare @mSubQuery NVARCHAR(max)
    --DECLARE @TABLE_NAME NVARCHAR(100)
    --DECLARE @P_TABLE NVARCHAR(100) = 'SCM_MST_VMI_INT_SLOC'
    DECLARE @COLUMN_PLANT NVARCHAR(100) = 'PLANT_ID'


    -- 시작 LOG
    SET @v_log_type = @P_TABLE;
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_log_message = 'ALL';
    SET @v_description = '@P_TABLE:'+@P_TABLE+',@P_ROLLIN:'+@P_ROLLIN;;
    SET @d_event_date = SYSDATETIME();
    set @BATCH_START_TIME = getdate();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, @v_log_message,  @v_description, @d_event_date;
    PRINT CONCAT( 'START = ', @BATCH_START_TIME)

BEGIN TRY



--########################################################################################################
-- 1, CURSOR STORAGE 정보 수집
--########################################################################################################
-- 커서가 이미 열려 있는지 확인
IF CURSOR_STATUS('global', 'CURSOR_BACKUP') >= 0
BEGIN
    CLOSE CURSOR_BACKUP;
    DEALLOCATE CURSOR_BACKUP;
END
DECLARE CURSOR_BACKUP CURSOR FOR

            --####################################################
            -- Storage Table Only
            --####################################################
              SELECT program_id AS TABLE_NAME
                   , dev_detail as COLUMN_NAME
                   , MAPPING_COLUMN as MAPPING_COLUMN
                FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
                where DEV_TYPE = 'Batch_Conversion'
                and mapping_use IN ( 'UP', 'CA')
                and MAPPING_COLUMN = 'STORAGE_ID'
                --and ISNULL(MAPPING_COMMENT,'') != 'FINISH'
                --and mapping_use IN ( 'UP', 'CA', 'BG') -> BG는 BG에서 처리
                --and program_id NOT IN (SELECT table_name from NERP_CONV_SCP_DATA WITH (NOLOCK) where COLUMN_NAME1 = 'CONV_STORAGE' )
                --and PROD_TABLE_CNT < 3592377
                --and program_id != 'SCP_ANL_MONTH_END_STOCK_R_D'
                and (@P_TABLE IS NULL OR @P_TABLE ='' OR program_id = @P_TABLE)
                order by PROD_TABLE_CNT




OPEN CURSOR_BACKUP;
FETCH NEXT FROM CURSOR_BACKUP
INTO @TABLE_NAME,@COLUMN_NAME,@MAPPING_COLUMN
WHILE @@FETCH_STATUS = 0
BEGIN

                print '####################################################################'
                print concat(@TABLE_NAME, ' , ', @COLUMN_NAME, ' , ', @MAPPING_COLUMN)
                print '####################################################################'

                set @v_log_message =  concat(@TABLE_NAME, ', ',@COLUMN_NAME, ', ',@MAPPING_COLUMN)
                PRINT @v_log_message
                SET @CNT = @CNT+1;
                SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'STORAGE 수집', 0, @TABLE_NAME, @v_log_message, @START_TIME;


                SET @COLUMN_PLANT = 'PLANT_ID'
                if @TABLE_NAME= 'SCP_MST_DIO_MAT_MAP'
                begin
                SET @COLUMN_PLANT = 'PLNT_CD'
                end


                --------------------------------------------------------------------------------------------------------------------------------------------
                DELETE
                FROM NERP_CONV_SCP_DATA
                WHERE COLUMN_NAME1 = 'CONV_STORAGE'
                and TABLE_NAME = ISNULL(@TABLE_NAME,'')

                --------------------------------------------------------------------------------------------------------------------------------------------
                SET @mSubQuery = ''
                SET @mSubQuery = @mSubQuery + ' INSERT INTO NERP_CONV_SCP_DATA                                                         ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (TABLE_NAME, COLUMN_NAME1, COLUMN_NAME2,COLUMN_NAME3, OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2)' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' select '''+ @TABLE_NAME +''' , ''CONV_STORAGE'', '''+@COLUMN_PLANT+''', '''+ @COLUMN_NAME +'''                                  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ,'+@COLUMN_PLANT+', '+ @COLUMN_NAME +'                                                                  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ,MAX(P.NEW_VALUE1) AS TOBE_PLANT_ID' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ,MAX(B.NEW_VALUE2) AS TOBE_STORAGE_ID' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' FROM '+ @TABLE_NAME +' A with (nolock)' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') P ON A.'+@COLUMN_PLANT+' = P.OLD_VALUE1  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V where CODETYPE = ''STORAGE_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B      ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ON A.'+@COLUMN_PLANT+' = B.OLD_VALUE1       ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' AND A.'+ @COLUMN_NAME +' = B.OLD_VALUE2     ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' group by '+@COLUMN_PLANT+', '+ @COLUMN_NAME +'      ' +CHAR(10);

                print @mSubQuery
                exec (@mSubQuery);




FETCH NEXT FROM CURSOR_BACKUP
INTO @TABLE_NAME,@COLUMN_NAME,@MAPPING_COLUMN;
END

CLOSE CURSOR_BACKUP;
DEALLOCATE CURSOR_BACKUP;



SET @MAPPING_TIME = datediff(second, @BATCH_START_TIME, getdate() );
SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'STORAGE 수집 END', @MAPPING_TIME, '0', '', @START_TIME;


PRINT 'BATCH STORAGE CONVERT Start'
SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'STORAGE CONVERT START', @MAPPING_TIME, '0', '', @START_TIME;

--########################################################################################################
-- CURSOR CONVERT
--########################################################################################################
--declare @mSubQuery NVARCHAR(max)
--DECLARE @TABLE_NAME NVARCHAR(100)
--DECLARE @P_TABLE NVARCHAR(100) = 'SCM_MST_VMI_INT_SLOC'
-- 커서가 이미 열려 있는지 확인
IF CURSOR_STATUS('global', 'CURSOR_CONVERT') >= 0
BEGIN
    CLOSE CURSOR_CONVERT;
    DEALLOCATE CURSOR_CONVERT;
END
DECLARE CURSOR_CONVERT CURSOR FOR


            --####################################################
            -- Storage Table Only
            --####################################################
              SELECT program_id AS TABLE_NAME
                   , dev_detail as COLUMN_NAME
                   , MAPPING_COLUMN as MAPPING_COLUMN
                FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
                where DEV_TYPE = 'Batch_Conversion'
                and mapping_use IN ( 'UP', 'CA')
                and MAPPING_COLUMN = 'STORAGE_ID'
                --and ISNULL(MAPPING_COMMENT,'') != 'FINISH'
                --and mapping_use IN ( 'UP', 'CA', 'BG') -> BG는 BG에서 처리
                --and program_id NOT IN (SELECT table_name from NERP_CONV_SCP_DATA WITH (NOLOCK) where COLUMN_NAME1 = 'CONV_STORAGE' )
                --and PROD_TABLE_CNT < 3592377
                --and program_id != 'SCP_ANL_MONTH_END_STOCK_R_D'
                and (@P_TABLE IS NULL OR @P_TABLE ='' OR program_id = @P_TABLE)
                order by PROD_TABLE_CNT



OPEN CURSOR_CONVERT;
FETCH NEXT FROM CURSOR_CONVERT
INTO @TABLE_NAME,@COLUMN_NAME,@MAPPING_COLUMN
WHILE @@FETCH_STATUS = 0
BEGIN



                print '####################################################################'
                print concat(@TABLE_NAME, ' , ', @COLUMN_NAME, ' , ', @MAPPING_COLUMN)
                print '####################################################################'

                set @v_log_message =  concat(N'STORAGE Convert = ', @TABLE_NAME, ', ',@COLUMN_NAME, ', ',@MAPPING_COLUMN)
                PRINT @v_log_message
                SET @CNT = @CNT+1;
                SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'STORAGE CONVERT', 0, @TABLE_NAME, @v_log_message, @START_TIME;



            SET @COLUMN_PLANT = 'PLANT_ID'
            if @TABLE_NAME= 'SCP_MST_DIO_MAT_MAP'
            begin
            SET @COLUMN_PLANT = 'PLNT_CD'
            end


            SET @mSubQuery = ''
            IF @MAPPING_COLUMN = 'STORAGE_ID'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_PLANT + ' = ISNULL(B.TOBE_PLANT,   A.' + @COLUMN_PLANT + ') ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + @COLUMN_NAME +  ' = ISNULL(B.TOBE_STORAGE, A.' + @COLUMN_NAME +  ') ' +CHAR(10);
                IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '( ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' select distinct A.old_value1                                    ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' , A.old_value2                                                  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' , B.new_value1 AS TOBE_PLANT                                    ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' , ISNULL(A.new_value2, A.OLD_VALUE2) AS TOBE_STORAGE            ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' from NERP_CONV_SCP_DATA    A                                       ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' left join (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B                                              ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' on A.old_value1 = B.OLD_VALUE1                                  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' where column_name1 = ''CONV_STORAGE''                           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' and isnull(B.new_value1,'''') != ''''                           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + 'and table_name = '''+ @TABLE_NAME + '''                          ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ') AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE2  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' AND  A.'+ @COLUMN_PLANT + ' = B.OLD_VALUE1  ' +CHAR(10);

            END

            print @mSubQuery
            if ISNULL(@mSubQuery,'') != ''
            begin
            --exec (@mSubQuery)
            --2025-04-03 김준규 변경
                BEGIN TRY
                    --BEGIN TRANSACTION;
                        EXEC sp_executesql @mSubQuery;
                    --COMMIT TRANSACTION;
                END TRY
                BEGIN CATCH
                    IF @@TRANCOUNT > 0
                        --ROLLBACK TRANSACTION;
                    SET @DUMMY = N''+@P_ROLLIN+','+ concat(@TABLE_NAME, ' , ', @COLUMN_NAME, ' , ', @MAPPING_COLUMN) + ERROR_MESSAGE()
                    print @DUMMY
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, '0', @DUMMY, @d_event_date;
                END CATCH
            END


            --####################################################
            -- Result Storage
            --####################################################
                SET @MAPPING_TIME = datediff(second, @START_TIME, getdate() );

                UPDATE ZNERP_DEV_ITEM_SCHEDULE
                SET MAPPING_START = @START_TIME
                    , MAPPING_END = getdate()
                    , MAPPING_TIME = @MAPPING_TIME
                    , mapping_query = @mSubQuery
                    , check_query = @@trancount
                    , mapping_comment = 'FINISH'
                WHERE program_id = @TABLE_NAME
                and dev_detail = @COLUMN_NAME
                and mapping_column in ( @MAPPING_COLUMN , @COLUMN_PLANT)

                print concat(@@trancount, ' , ', @@trancount)
                SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'Update Result', @MAPPING_TIME, @TABLE_NAME, @v_log_message, @START_TIME;





FETCH NEXT FROM CURSOR_CONVERT
INTO @TABLE_NAME,@COLUMN_NAME,@MAPPING_COLUMN;
END

CLOSE CURSOR_CONVERT;
DEALLOCATE CURSOR_CONVERT;




    PRINT 'END'
    SET @BATCH_END_TIME = SYSDATETIME();
    SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
    PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
    SET @DUMMY = 'END,'+@v_description+', RUN_TIME ';
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  @DUMMY, @BATCH_END_TIME;


END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;

        print  ERROR_MESSAGE();
END CATCH

END
