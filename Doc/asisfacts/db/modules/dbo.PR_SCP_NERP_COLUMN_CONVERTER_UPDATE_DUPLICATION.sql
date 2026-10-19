

-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION
-- Author:       vadabi5
-- Create date:  2024-11-15
-- Description:  NERP) BIG Table  Convert CUTOFF
-- ==========================================================================================
-- 2024-12-09       vadabi5     NERP) 신규 생성 - 이슈 DUPLICATION
-- 2024-12-09       vadabi5     NERP) SCP_MST_NO_USE_3M ADD PK COLUMN PLANT_REF
-- 2024-12-17       vadabi5     NERP) SCP_ANL_PSI_INTEGRATION 등
-- 2024-12-17       vadabi5     NERP) LGTM
-- 2024-12-21       vadabi5     NERP) SCM_DNM_MONTH_CLOSE_INVENTORY - STORAGE
-- 2025-04-17       김준규      NERP) SCP_MST_WORKING_TIME,SCP_ANL_WORKING_TIME 중복발생 하였으나,
--                             로직정리 위해 추가해 놓음(실제는 NERP_CONV_MASTER를 에서 VENDOR_ID,END_CUSTOMER_ID를 이전차수는 제외 순수 신규만 대상으로 처리)
-- 2025-06-07       김준규      NERP) SCP_ANL_PSI_INTEGRATION TOBE_TO_SITE에서 PLANT_ID가 누락되어서 추가함  ISNULL(E.NEW_VALUE1,F.NEW_VALUE1) AS TOBE_TO_SITE
-- 2025-08-05       김준규      NERP) SCP_ANL_PSI_INTEGRATION WHERE [COMPANY_ID]= 'G183' -- 1월 초 오류 정보로 보입니다. 삭제하시지요
-- 2025-10-30       김준규      NERP) END TRY BEGIN CATCH 가 없어서 루핑과정에 에러 종료가 되어서 계속 실행되도록 함.
-- 2025-10-30       김준규      NERP) 추가 DROP TABLE IF EXISTS #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_UPDATE;
-- 2025-10-30       김준규      NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL 테이블 1차만 되도록 코딩되어 있어서 모든 차수에 되도록 변경
-- 2025-10-30       김준규      NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가

--------------------------------------------------------------------------------------
/*
DROP TABLE SCP_ANL_PSI_INTEGRATION_DUP;
DROP TABLE SCP_MST_CAPA_ELTR_LINE_DUP;
DROP TABLE SCP_MST_CAPA_LINE_DUP;
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION @P_TABLE='',@P_ROLLIN='2ND'
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION @P_TABLE='SCP_ANL_PSI_INTEGRATION',@P_ROLLIN='3RD'


begin tran

sp_help SCP_MST_NO_USE_3M



ALTER TABLE dbo.SCP_MST_NO_USE_3M ADD  PLANT_REF NVARCHAR(60) not null default 'PLANT_ID'
ALTER TABLE dbo.SCP_MST_NO_USE_3M DROP CONSTRAINT PK_SCP_MST_NO_USE_3M
ALTER TABLE dbo.SCP_MST_NO_USE_3M ADD CONSTRAINT PK_SCP_MST_NO_USE_3M PRIMARY KEY (COMPANY_ID, PLANT_ID, PLANT_REF, ITEM_ID)

rollback

select count(*) from SCP_MST_NO_USE_3M
select count(*) from SCP_MST_PIC_INFO


insert into SCP_MST_PIC_INFO
select * from LGCE_SCMPROD.dbo.SCP_MST_PIC_INFO
*/



-- ==========================================================================================
/*
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION 'SCP_ANL_LONG_TERM_STOCK'
*/
-- =============================================

CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION]
   @P_TABLE   nvarchar(100)
  ,@P_ROLLIN  nvarchar(30) --1ST 2ND 3RD 4TH
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
    DECLARE @TABLE_NAME   NVARCHAR(150) = N'';
    DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N'';
    DECLARE @COL_INFO   NVARCHAR(150) = N'';

    DECLARE @CNT BIGINT;
    DECLARE @ACT_CNT BIGINT;
    DECLARE @WORK_SECOND BIGINT;

    DECLARE @SELECT_COL NVARCHAR(MAX);
    DECLARE @mEXEC NVARCHAR(MAX);
    DECLARE @BACKUP_START_TIME  NVARCHAR(50) = N'';
    DECLARE @BACKUP_END_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_START_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_END_TIME  NVARCHAR(50) = N'';
    DECLARE @COLUMN_NAME  NVARCHAR(50) = N'';
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;

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


    DECLARE @SOURCE_COLUMN NVARCHAR(400);
    DECLARE @MAPPING_USE NVARCHAR(2);
    DECLARE @MAPPING_RESULT NVARCHAR(2);

    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;


    DECLARE @RUN_TIME BIGINT;
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;

    SET @BATCH_RUN_TIME = 0;
    SET @CNT = 0;
    SET @RUN_TIME = 0;
    SET @MAPPING_COLUMN = '';

    DECLARE @YYYYMM nvarchar(10) = '';
    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_DUPLICATION';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;


    -- 시작 LOG
    SET @v_log_type = @P_TABLE;
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_log_message = '';
    SET @v_description = '@P_TABLE:'+@P_TABLE+',@P_ROLLIN:'+@P_ROLLIN;;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, @v_log_message,  @v_description, @d_event_date;
    PRINT CONCAT( 'START = ', @BATCH_START_TIME)


BEGIN TRY

    -- 2025-08-05 김준규 NERP) SCP_ANL_PSI_INTEGRATION WHERE [COMPANY_ID]= 'G183' -- 1월 초 오류 정보로 보입니다. 삭제하시지요
    DECLARE @NERP_THIRD_STAGE NVARCHAR(128);
    SET @NERP_THIRD_STAGE = '3'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASRXDTE','3,5');--알디 에스티
    --
    IF @P_ROLLIN = @NERP_THIRD_STAGE
    BEGIN
        DELETE API
        --SELECT * 
        FROM   SCP_ANL_PSI_INTEGRATION AS API WITH(NOLOCK)
        WHERE  [COMPANY_ID]= 'G183'
        ;
    END;



--###########################################################################################################
--  중복 Plant 처리
--###########################################################################################################

        IF OBJECT_ID('tempdb..#TMP_PLANT_DUPLICATION') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_PLANT_DUPLICATION;
        END

                select new_value1,rnum=ROW_NUMBER()OVER(ORDER BY new_value1)
                into #TMP_PLANT_DUP
                from NERP_CONV_MASTER_CFM_V WITH(NOLOCK)
                where codetype = 'PLANT_ID'
                and ATTRIBUTE5 = @P_ROLLIN
                group by new_value1
                having count(*) > 1


                select MCV.old_value1
                     , MCV.new_value1
                     , TPD.rnum
                into #TMP_PLANT_DUP_DETAIL
                from NERP_CONV_MASTER_CFM_V AS MCV WITH(NOLOCK)
                JOIN #TMP_PLANT_DUP AS TPD ON TPD.NEW_VALUE1 = MCV.NEW_VALUE1
                where codetype = 'PLANT_ID'
                and ATTRIBUTE5 = @P_ROLLIN
                --and new_value1 in (select new_value1 from #TMP_PLANT_DUP)


                select new_value1
                   , min(old_value1) as PLANT
                   , max(old_value1) as PLANT_ELEC
                INTO #TMP_PLANT_DUPLICATION
                from #TMP_PLANT_DUP_DETAIL
                group by new_value1


    --###########################################################################################################
    -- CURSOR_MAPPING
    --###########################################################################################################
        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END
        DECLARE CURSOR_MAPPING CURSOR FOR


         --  SELECT distinct program_id AS TABLE_NAME
            -- FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
            --where DEV_TYPE = 'Batch_Conversion'
            --and MAPPING_USE IN ( 'DP')
            --and isnull(status, '') != 'FINISH'
            ----and program_id = 'SCP_ANL_LONG_TERM_STOCK'
            --and program_id in (@P_TABLE)
            --order by program_id

                SELECT DISTINCT PROGRAM_ID AS TABLE_NAME
                 FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
                where DEV_TYPE = 'Batch_Conversion'
                and MAPPING_USE IN ( 'DP')
                --and isnull(status, '') != 'FINISH'
                --and program_id = 'SCP_ANL_PSI_INTEGRATION' SCP_ANL_WORKING_TIME
                --and (@P_TABLE IS NULL OR PROGRAM_ID = @P_TABLE)
                and (@P_TABLE IS NULL OR @P_TABLE ='' OR program_id = @P_TABLE)
                order by program_id




        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME

        WHILE @@FETCH_STATUS = 0
        BEGIN

            BEGIN TRY

                print '####################################################################################'
                print @TABLE_NAME
                print '####################################################################################'

                set @v_log_message =  concat('CONV DUPLICATION = ', @TABLE_NAME,'@P_ROLLIN:',@P_ROLLIN)
                PRINT @v_log_message
                SET @MAPPING_RESULT = 'N';
                SET @CNT = @CNT+1;
                SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, N'CONV DUPLICATION', @@ROWCOUNT, @TABLE_NAME, @v_log_message, @START_TIME;

                -- 2025-04-17 김준규 로직정리 위해 추가해 놓음(실제는 NERP_CONV_MASTER를 에서 VENDOR_ID,END_CUSTOMER_ID를 이전차수는 제외 순수 신규만 대상으로 처리)
                IF @TABLE_NAME = 'SCP_MST_WORKING_TIME'
                BEGIN

                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_MST_WORKING_TIME';

                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                        , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                        )
                        SELECT
                               'SCP_MST_WORKING_TIME'
                             , 'DIVISION_ID', 'PLANT_SITE_ID', 'FACTORY_ID', 'OPERATION_ID', 'LINE_ID','YYYYMMDD'
                             , DIVISION_ID, PLANT_SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, YYYYMMDD
                             ,TOBE_PLANT_SITE, TOBE_OPERATION, RNO --> 2이상은 자체 중복값
                         FROM
                         (
                             SELECT  A.DIVISION_ID
                                    ,A.PLANT_SITE_ID
                                    ,A.FACTORY_ID
                                    ,A.OPERATION_ID
                                    ,A.LINE_ID
                                    ,A.YYYYMMDD
                                    ,A.WORKING_TIME
                                    ,A.CREATED_BY
                                    ,A.CREATION_DATE
                                    ,A.LAST_UPDATED_BY
                                    ,A.LAST_UPDATE_DATE
                                    ,A.ATTRIBUTE1
                                    ,A.ATTRIBUTE2
                                    ,A.ATTRIBUTE3
                                    ,A.ATTRIBUTE4
                                    ,A.ATTRIBUTE5
                                    ,A.ATTRIBUTE6
                                    ,A.ATTRIBUTE7
                                    ,A.ATTRIBUTE8
                                    ,A.ATTRIBUTE9
                                    ,A.ATTRIBUTE10
                                    ,ISNULL(B.new_value1,A.PLANT_SITE_ID) AS TOBE_PLANT_SITE
                                    ,ISNULL(C.new_value1,A.OPERATION_ID) AS TOBE_OPERATION
                                    -- 2025-04-17 김준규 변경했을때 기준으로 partition by 처리
                                    ,ROW_NUMBER() over (partition by DIVISION_ID, ISNULL(B.new_value1,A.PLANT_SITE_ID), FACTORY_ID, ISNULL(C.new_value1,A.OPERATION_ID), LINE_ID, YYYYMMDD order by PLANT_SITE_ID) as rno
                                from SCP_MST_WORKING_TIME A
                                LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = '2ND') B ON A.PLANT_SITE_ID = B.old_value1
                                LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = '2ND') C ON A.OPERATION_ID = C.old_value1
                                -- 2025-04-17 김준규 변경대상만 적재
                                WHERE A.PLANT_SITE_ID <> B.new_value1 OR OPERATION_ID <> C.new_value1
                         ) LIST
                         WHERE 1=1
                         AND   NOT EXISTS (SELECT 1
                                           FROM   SCP_MST_WORKING_TIME A
                                           WHERE  A.DIVISION_ID = LIST.DIVISION_ID
                                           AND    A.PLANT_SITE_ID = LIST.TOBE_PLANT_SITE
                                           AND    A.FACTORY_ID = LIST.FACTORY_ID
                                           AND    A.OPERATION_ID = LIST.TOBE_OPERATION
                                           AND    A.LINE_ID = LIST.LINE_ID
                                           AND    A.YYYYMMDD = LIST.YYYYMMDD
                                           );

                    -----------------------------------------------------
                    --RNO --> 2이상 자체 중복값은 삭제 처리 필요,
                    --여기서 삭제 대상은 신규코드 KEY값 기준 중복 중 기존 코드: PLANT_SITE_ID 값이 큰것.
                    --MASTER의 경우는 삭제, 트랜잭션 데이터는 실적 합계 필요.
                    -----------------------------------------------------
                    DELETE A
                     FROM .SCP_MST_WORKING_TIME AS A WITH(NOLOCK),
                   (SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                         , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                      from NERP_CONV_SCP_DATA WITH(NOLOCK) where table_name = 'SCP_MST_WORKING_TIME') AS B
                     WHERE A.DIVISION_ID     = B.OLD_VALUE1
                       AND A.PLANT_SITE_ID   = B.OLD_VALUE2
                       AND A.FACTORY_ID      = B.OLD_VALUE3
                       AND A.OPERATION_ID    = B.OLD_VALUE4
                       AND A.LINE_ID         = B.OLD_VALUE5
                       AND A.YYYYMMDD        = B.OLD_VALUE6
                       AND B.NEW_VALUE3      > '1';

                    -----------------------------------------------------
                    --RNO --> 1만 UPDATE 자체 중복값은 상단에서 삭제 처리
                    -----------------------------------------------------
                    UPDATE A
                       SET A.PLANT_SITE_ID = B.NEW_VALUE1
                          ,A.OPERATION_ID = B.NEW_VALUE2
                          ,A.LAST_UPDATED_BY = @CREATED_BY
                          ,A.LAST_UPDATE_DATE = GETDATE()
                     FROM .SCP_MST_WORKING_TIME AS A WITH(NOLOCK),
                   (SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                         , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                      from NERP_CONV_SCP_DATA WITH(NOLOCK) where table_name = 'SCP_MST_WORKING_TIME') AS B
                     WHERE A.DIVISION_ID     = B.OLD_VALUE1
                       AND A.PLANT_SITE_ID   = B.OLD_VALUE2
                       AND A.FACTORY_ID      = B.OLD_VALUE3
                       AND A.OPERATION_ID    = B.OLD_VALUE4
                       AND A.LINE_ID         = B.OLD_VALUE5
                       AND A.YYYYMMDD        = B.OLD_VALUE6
                       AND B.NEW_VALUE3      = '1';

                      SET @MAPPING_RESULT = 'Y';
                END


                -- 2025-04-17 김준규 로직정리 위해 추가해 놓음(실제는 NERP_CONV_MASTER를 에서 VENDOR_ID,END_CUSTOMER_ID를 이전차수는 제외 순수 신규만 대상으로 처리)
                ELSE IF @TABLE_NAME = 'SCP_ANL_WORKING_TIME'
                BEGIN

                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_ANL_WORKING_TIME';

                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5,OLD_VALUE6
                        , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                        )
                        SELECT
                               'SCP_ANL_WORKING_TIME'
                             , 'DIVISION_ID', 'SCM_SITE_ID','OPERATION_ID', 'LINE_ID','YYYYMMDD','-'
                             , DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, YYYYMMDD,'-'
                             , TOBE_SCM_SITE, TOBE_OPERATION, RNO --> 2이상은 자체 중복값
                         FROM
                         (
                             SELECT  A.DIVISION_ID
                                    ,A.SCM_SITE_ID
                                    ,A.OPERATION_ID
                                    ,A.LINE_ID
                                    ,A.YYYYMMDD
                                    ,A.WORKING_TIME
                                    ,A.CREATED_BY
                                    ,A.CREATION_DATE
                                    ,A.LAST_UPDATED_BY
                                    ,A.LAST_UPDATE_DATE
                                    ,A.ATTRIBUTE1
                                    ,A.ATTRIBUTE2
                                    ,A.ATTRIBUTE3
                                    ,A.ATTRIBUTE4
                                    ,A.ATTRIBUTE5
                                    ,A.ATTRIBUTE6
                                    ,A.ATTRIBUTE7
                                    ,A.ATTRIBUTE8
                                    ,A.ATTRIBUTE9
                                    ,A.ATTRIBUTE10
                                    ,ISNULL(B.new_value1,A.SCM_SITE_ID) AS TOBE_SCM_SITE
                                    ,ISNULL(C.new_value1,A.OPERATION_ID) AS TOBE_OPERATION
                                    -- 2025-04-17 김준규 변경했을때 기준으로 partition by 처리
                                    ,ROW_NUMBER() over (partition by DIVISION_ID, ISNULL(B.new_value1,A.SCM_SITE_ID), ISNULL(C.new_value1,A.OPERATION_ID), LINE_ID, YYYYMMDD order by SCM_SITE_ID) as rno
                                from SCP_ANL_WORKING_TIME A
                                LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = '2ND') B ON A.SCM_SITE_ID = B.old_value1
                                LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = '2ND') C ON A.OPERATION_ID = C.old_value1
                                -- 2025-04-17 김준규 변경대상만 적재
                                WHERE A.SCM_SITE_ID <> B.new_value1 OR OPERATION_ID <> C.new_value1
                         ) LIST
                         WHERE 1=1
                         AND   NOT EXISTS (SELECT 1
                                           FROM   SCP_ANL_WORKING_TIME A
                                           WHERE  A.DIVISION_ID = LIST.DIVISION_ID
                                           AND    A.SCM_SITE_ID = LIST.TOBE_SCM_SITE
                                           AND    A.OPERATION_ID = LIST.TOBE_OPERATION
                                           AND    A.LINE_ID = LIST.LINE_ID
                                           AND    A.YYYYMMDD = LIST.YYYYMMDD
                                           );

                    -----------------------------------------------------
                    --RNO --> 2이상 자체 중복값은 삭제 처리 필요,
                    --여기서 삭제 대상은 신규코드 KEY값 기준 중복 중 기존 코드: SCM_SITE_ID 값이 큰것.
                    --MASTER의 경우는 삭제, 트랜잭션 데이터는 실적 합계 필요.
                    -----------------------------------------------------
                    DELETE A
                     FROM .SCP_ANL_WORKING_TIME AS A WITH(NOLOCK),
                   (SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                         , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                      from NERP_CONV_SCP_DATA WITH(NOLOCK) where table_name = 'SCP_ANL_WORKING_TIME') AS B
                     WHERE A.DIVISION_ID     = B.OLD_VALUE1
                       AND A.SCM_SITE_ID     = B.OLD_VALUE2
                       AND A.OPERATION_ID    = B.OLD_VALUE3
                       AND A.LINE_ID         = B.OLD_VALUE4
                       AND A.YYYYMMDD        = B.OLD_VALUE5
                       AND B.NEW_VALUE3      > '1';

                    -----------------------------------------------------
                    --RNO --> 1만 UPDATE 자체 중복값은 상단에서 삭제 처리
                    -----------------------------------------------------
                    UPDATE A
                       SET A.SCM_SITE_ID = B.NEW_VALUE1
                          ,A.OPERATION_ID = B.NEW_VALUE2
                          ,A.LAST_UPDATED_BY = @CREATED_BY
                          ,A.LAST_UPDATE_DATE = GETDATE()
                     FROM .SCP_ANL_WORKING_TIME AS A WITH(NOLOCK),
                   (SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                         , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                      from NERP_CONV_SCP_DATA WITH(NOLOCK) where table_name = 'SCP_ANL_WORKING_TIME') AS B
                     WHERE A.DIVISION_ID     = B.OLD_VALUE1
                       AND A.SCM_SITE_ID     = B.OLD_VALUE2
                       AND A.OPERATION_ID    = B.OLD_VALUE3
                       AND A.LINE_ID         = B.OLD_VALUE4
                       AND A.YYYYMMDD        = B.OLD_VALUE5
                       AND B.NEW_VALUE3      = '1';

                      SET @MAPPING_RESULT = 'Y';
                END


                -- 20241007 CASE 조건문 처음에 체크 필요
                -- 변환 시 중복 문제 발생
                ELSE IF @TABLE_NAME = 'SCP_MST_PIC_INFO'
                BEGIN

                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_MST_PIC_INFO';

                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                        , NEW_VALUE1,NEW_VALUE2
                        )
                        SELECT
                               'SCP_MST_PIC_INFO'
                               , 'PLANT_ID', 'ITEM_ID' , 'PIC_NO', 'PIC_NM', 'ATTRIBUTE5','CREEATION_DATE'
                              ,PLANT_ID, ITEM_ID , PIC_NO, PIC_NM,ATTRIBUTE5,CREATION_DATE
                             , TOBE_PLANT
                             , rank() over (partition by TOBE_PLANT, ITEM_ID, PIC_NO order by PLANT_ID) as rno
                         FROM
                         (
                             SELECT  PLANT_ID
                                    ,ITEM_ID
                                    ,PIC_NO
                                    ,PIC_NM
                                    ,ATTRIBUTE1
                                    ,ATTRIBUTE2
                                    ,ATTRIBUTE3
                                    ,ATTRIBUTE4
                                    ,ATTRIBUTE5
                                    ,CREATED_BY
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                    , B.new_value1 AS TOBE_PLANT
                                from SCP_MST_PIC_INFO A
                                LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) B ON A.PLANT_ID = B.old_value1
                         ) LIST

                     -----------------------------------------------------

                     truncate table SCP_MST_PIC_INFO
                      -----------------------------------------------------

                    INSERT INTO SCP_MST_PIC_INFO
                     -- 11838
                     select ISNULL(new_value1, OLD_VALUE1) AS PLANT_ID
                          , OLD_VALUE2 AS ITEM_ID
                          , OLD_VALUE3 AS PIC_NO
                          , OLD_VALUE4 AS PIC_NM
                          , NULL       AS ATTRIBUTE1
                          , NULL       AS ATTRIBUTE2
                          , NULL       AS ATTRIBUTE3
                          , NULL       AS ATTRIBUTE4
                          , OLD_VALUE5 AS ATTRIBUTE5
                          , 'scm_batch' AS  CREATED_BY
                          , CONVERT(DATE,OLD_VALUE6) AS CREATION_DATE
                          , @CREATED_BY AS   LAST_UPDATED_BY
                          , CONVERT(DATE,OLD_VALUE6) AS LAST_UPDATE_DATE

                     from NERP_CONV_SCP_DATA
                     where table_name = 'SCP_MST_PIC_INFO'
                     and new_value2 = '1'
                     order by ATTRIBUTE5


                     SET @MAPPING_RESULT = 'Y';
                END


                /*
                20241209
                COMPANY_ID   COMPANY_ID
                PLANT_ID     PLANT_ID
                */
                ELSE IF @TABLE_NAME = 'SCP_MST_NO_USE_3M'
                BEGIN

                        -------------------------------------------------------------------------------
                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_MST_NO_USE_3M';

                        -------------------------------------------------------------------------------
                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                        , NEW_VALUE1,NEW_VALUE2
                        )
                        SELECT
                               'SCP_MST_NO_USE_3M'
                               , 'PLAN_START_YYYYMMDD', 'PLANT_ID', 'ITEM_ID' , 'PIC_NO','LAST_UPDATE_DATE', N'TOBE_USE'
                              ,COMPANY_ID, PLANT_ID, ITEM_ID, PIC_NO, LAST_UPDATE_DATE, TOBE_USE
                             , TOBE_COMPANY
                             , TOBE_PLANT
                         FROM
                         (
                             SELECT
                                     COMPANY_ID
                                    ,PLANT_ID
                                    ,ITEM_ID
                                    ,PIC_NO
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                    ,B.PLANT
                                    ,C.PLANT_ELEC
                                    , CASE WHEN ISNULL(B.PLANT,'')    != '' THEN 'Y'
                                           WHEN ISNULL(C.PLANT_ELEC,'') != ''THEN 'N'
                                           ELSE NULL
                                           END TOBE_USE
                                    , D.NEW_VALUE1 as TOBE_COMPANY
                                    , E.NEW_VALUE1 as TOBE_PLANT
                                from SCP_MST_NO_USE_3M A
                                left join ( SELECT PLANT FROM #TMP_PLANT_DUPLICATION) B ON A.PLANT_ID = B.PLANT
                                left join ( SELECT PLANT_ELEC FROM #TMP_PLANT_DUPLICATION) C ON A.PLANT_ID = C.PLANT_ELEC
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.COMPANY_ID = D.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E ON A.PLANT_ID = E.OLD_VALUE1
                         ) LIST

                     -----------------------------------------------------

                if NOT EXISTS (
                    select *
                    from
                    (
                    select COMPANY_ID, PLANT_ID, ITEM_ID
                        , E.new_value1 as tobe_plant
                        , rank() over ( partition by COMPANY_ID, E.new_value1, ITEM_ID order by PLANT_ID) as rno
                    from SCP_MST_NO_USE_3M A
                    left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E ON A.PLANT_ID = E.OLD_VALUE1
                    where plant_id in (SELECT old_value1 FROM #TMP_PLANT_DUP_DETAIL )
                    ) list
                    where rno  >  1
                   )
                       begin

                        UPDATE SCP_MST_NO_USE_3M
                           SET SCP_MST_NO_USE_3M.COMPANY_ID = ISNULL(B.NEW_VALUE1, COMPANY_ID)
                              ,SCP_MST_NO_USE_3M.PLANT_ID   = ISNULL(B.NEW_VALUE2, PLANT_ID)
                              ,SCP_MST_NO_USE_3M.LAST_UPDATED_BY = @CREATED_BY
                              ,SCP_MST_NO_USE_3M.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCP_MST_NO_USE_3M AS A,
                        (SELECT OLD_VALUE1, OLD_VALUE2,NEW_VALUE1, NEW_VALUE2, old_value6 from NERP_CONV_SCP_DATA where table_name = 'SCP_MST_NO_USE_3M') AS B
                        WHERE   A.COMPANY_ID                = B.OLD_VALUE1
                          AND   A.PLANT_ID                  = B.OLD_VALUE2

                          /*
                          select *
                          from SCP_MST_NO_USE_3M
                          where plant_id != plant_ref
                          and plant_ref in (SELECT * FROM #TMP_PLANT_DUPLICATION)
                          */
                          SET @MAPPING_RESULT = 'Y';
                       end
                   else
                       begin
                       print N'DUPLICATION CASE'
                       EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'DUPLICATION CASE', @RUN_TIME, @TABLE_NAME, @mSubQuery, @d_event_date;
                       end



                END
                ELSE IF @TABLE_NAME = 'SCP_MST_NO_USE_3M_DUP'
                BEGIN

                        DECLARE @PROD2 nvarchar(2)  = 'N';
                        -- 운영에서 해당 컬럼 추가 안되었을 시 추가하는 작업 필요
                        IF @PROD2 = 'Y'
                            BEGIN
                            ALTER TABLE dbo.SCP_MST_NO_USE_3M ADD  PLANT_REF NVARCHAR(60) not null default 'NERP'
                            ALTER TABLE dbo.SCP_MST_NO_USE_3M DROP CONSTRAINT PK_SCP_MST_NO_USE_3M
                            ALTER TABLE dbo.SCP_MST_NO_USE_3M ADD CONSTRAINT PK_SCP_MST_NO_USE_3M PRIMARY KEY (COMPANY_ID, PLANT_ID, PLANT_REF, ITEM_ID)

                            -- 중복 case  있을 시 실행
                            --UPDATE SCP_MST_NO_USE_3M SET PLANT_REF = PLANT_ID
                            END






                            -------------------------------------------------------------------------------
                            -- Total    780
                            -- USE      328
                            -- NOT USE  105
                            -- 결과     SELECT 780 - 105 = 675


                        -------------------------------------------------------------------------------
                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_MST_NO_USE_3M';

                        -------------------------------------------------------------------------------
                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6
                        , NEW_VALUE1,NEW_VALUE2
                        )
                        SELECT
                               'SCP_MST_NO_USE_3M'
                               , 'PLAN_START_YYYYMMDD', 'PLANT_ID', 'ITEM_ID' , 'PIC_NO','LAST_UPDATE_DATE', N'TOBE_USE'
                              ,COMPANY_ID, PLANT_ID, ITEM_ID, PIC_NO, LAST_UPDATE_DATE, TOBE_USE
                             , TOBE_COMPANY
                             , TOBE_PLANT
                         FROM
                         (
                             SELECT
                                     COMPANY_ID
                                    ,PLANT_ID
                                    ,ITEM_ID
                                    ,PIC_NO
                                    ,CREATION_DATE
                                    ,LAST_UPDATED_BY
                                    ,LAST_UPDATE_DATE
                                    ,B.PLANT
                                    ,C.PLANT_ELEC
                                    , CASE WHEN ISNULL(B.PLANT,'')    != '' THEN 'Y'
                                           WHEN ISNULL(C.PLANT_ELEC,'') != ''THEN 'N'
                                           ELSE NULL
                                           END TOBE_USE
                                    , D.NEW_VALUE1 as TOBE_COMPANY
                                    , E.NEW_VALUE1 as TOBE_PLANT
                                from SCP_MST_NO_USE_3M A
                                left join ( SELECT PLANT FROM #TMP_PLANT_DUPLICATION) B ON A.PLANT_ID = B.PLANT
                                left join ( SELECT PLANT_ELEC FROM #TMP_PLANT_DUPLICATION) C ON A.PLANT_ID = C.PLANT_ELEC
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.COMPANY_ID = D.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E ON A.PLANT_ID = E.OLD_VALUE1
                         ) LIST

                     -----------------------------------------------------

                    UPDATE SCP_MST_NO_USE_3M
                       SET SCP_MST_NO_USE_3M.COMPANY_ID = ISNULL(B.NEW_VALUE1, COMPANY_ID)
                          ,SCP_MST_NO_USE_3M.PLANT_ID   = ISNULL(B.NEW_VALUE2, PLANT_ID)
                          ,SCP_MST_NO_USE_3M.LAST_UPDATED_BY = @CREATED_BY
                          ,SCP_MST_NO_USE_3M.LAST_UPDATE_DATE = GETDATE()
                      FROM .SCP_MST_NO_USE_3M AS A,
                    (SELECT OLD_VALUE1, OLD_VALUE2,NEW_VALUE1, NEW_VALUE2, old_value6 from NERP_CONV_SCP_DATA where table_name = 'SCP_MST_NO_USE_3M') AS B
                    WHERE   A.COMPANY_ID                = B.OLD_VALUE1
                      AND   A.PLANT_ID                  = B.OLD_VALUE2

                      /*
                      select *
                      from SCP_MST_NO_USE_3M
                      where plant_id != plant_ref
                      and plant_ref in (SELECT * FROM #TMP_PLANT_DUPLICATION)
                      */
                      SET @MAPPING_RESULT = 'Y';
                END

                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_LONG_TERM_STOCK'
                BEGIN

                    DECLARE @PROD nvarchar(2)  = 'N';
                    -- 운영에서 해당 컬럼 추가 안되었을 시 추가하는 작업 필요
                    IF @PROD = 'Y'
                        BEGIN
                        ALTER TABLE SCP_ANL_LONG_TERM_STOCK ADD NOID bigint IDENTITY(1,1) NOT NULL
                        ALTER TABLE dbo.SCP_ANL_LONG_TERM_STOCK DROP CONSTRAINT PK_SCP_ANL_LONG_TERM_STOCK
                        ALTER TABLE dbo.SCP_ANL_LONG_TERM_STOCK ADD CONSTRAINT PK_SCP_ANL_LONG_TERM_STOCK PRIMARY KEY (YYYYMM, PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE, NOID)
                        END


                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    delete from NERP_CONV_SCP_DATA 
                    where table_name = 'SCP_ANL_LONG_TERM_STOCK';
                    --drop table #TMP_SCP_ANL_LONG_TERM_STOCK

                    --################################################################
                    -- NOID 있을 때 버전
                    --################################################################
                     SELECT   NOID
                            , PLANT_ID, PRCTR,WAERS,MATKL,VALUATION_CLASS
                                    ,N1.new_value1 AS TOBE_PLANT
                                    ,N2.NEW_VALUE2 AS TOBE_PRCTR
                                    ,N3.NEW_VALUE1 AS TOBE_WAERS
                                    , CASE
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE01'   THEN '3001'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE02'   THEN '3002'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA01'   THEN '3003'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA02'   THEN '3004'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) like 'RP%' THEN '3005'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE02'   THEN '3002'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA01'   THEN '3003'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA02'   THEN '3004'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) like 'RP%' THEN '3005'
                                      WHEN A.VALUATION_CLASS = '3001' THEN '3000'
                                      ELSE NULL
                                       END AS TOBE_VALUATION_CLASS
                         into #TMP_SCP_ANL_LONG_TERM_STOCK
                         from SCP_ANL_LONG_TERM_STOCK A with (nolock)
                    LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) N1 ON A.PLANT_ID = N1.old_value1
                    LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'WAERS' AND ATTRIBUTE5 = @P_ROLLIN) N3 ON A.WAERS = N3.OLD_VALUE1
                    LEFT JOIN (SELECT NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'MATKL' AND ATTRIBUTE5 = @P_ROLLIN) E  ON A.ITEM_ID    = E.NEW_VALUE1
                    LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1,  new_value2
                                    , REPLICATE('0',10 - LEN(OLD_VALUE2)) + OLD_VALUE2 AS ASIS_CODE
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE CODETYPE = 'PROFIT_CENTER_ID'
                                  AND ATTRIBUTE5 = @P_ROLLIN
                                ) N2 ON A.PRCTR  = N2.ASIS_CODE



                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                        , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5,OLD_VALUE6
                        , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3,NEW_VALUE4
                        , NEW_VALUE10
                        )

                        SELECT 'SCP_ANL_LONG_TERM_STOCK'
                             , 'NOID','PLANT_ID','PRCTR','WAERS','MATKL','VALUATION_CLASS'
                             , NOID, PLANT_ID, PRCTR,WAERS,MATKL,VALUATION_CLASS
                             , TOBE_PLANT
                             , TOBE_PRCTR
                             , TOBE_WAERS
                             , TOBE_VALUATION_CLASS
                            , CASE WHEN ISNULL(TOBE_PLANT,'') != '' THEN 'Y'
                                    WHEN ISNULL(TOBE_PRCTR,'') != '' THEN 'Y'
                                    WHEN ISNULL(TOBE_WAERS,'') != '' THEN 'Y'
                                    WHEN ISNULL(TOBE_VALUATION_CLASS,'') != '' THEN 'Y'
                                    ELSE NULL
                                    END CHANGE_YN
                        FROM #TMP_SCP_ANL_LONG_TERM_STOCK


                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                      UPDATE SCP_ANL_LONG_TERM_STOCK
                         SET SCP_ANL_LONG_TERM_STOCK.PLANT_ID           = ISNULL(B.new_value1, A.PLANT_ID)
                            ,SCP_ANL_LONG_TERM_STOCK.PRCTR              = ISNULL(B.new_value2, A.PRCTR)
                            ,SCP_ANL_LONG_TERM_STOCK.WAERS              = ISNULL(B.new_value3, A.WAERS)
                            ,SCP_ANL_LONG_TERM_STOCK.VALUATION_CLASS    = ISNULL(B.new_value4, A.VALUATION_CLASS)
                            ,SCP_ANL_LONG_TERM_STOCK.ATTRIBUTE10        = 'NERP_BATCH_UPDATE'
                            ,SCP_ANL_LONG_TERM_STOCK.UPDATE_USER_ID     = @CREATED_BY
                            ,SCP_ANL_LONG_TERM_STOCK.UPDATE_DATE        = FORMAT(GETDATE(),'yyyyMMdd')
                            ,SCP_ANL_LONG_TERM_STOCK.UPDATE_TIME        = FORMAT(GETDATE(),'HHmmss')
                       FROM .SCP_ANL_LONG_TERM_STOCK AS A,
                    (
                           SELECT *
                            FROM NERP_CONV_SCP_DATA
                            where table_name = 'SCP_ANL_LONG_TERM_STOCK'
                            and new_value10 = 'Y'

                       ) AS B
                      WHERE 1 = 1
                        AND A.NOID          = B.OLD_VALUE1




                    /*
                    select count(*) from SCP_ANL_LONG_TERM_STOCK where PLANT_ID in (select old_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    --################################################################
                    -- NOID 없을 때 버전
                    --################################################################
                     SELECT   YYYYMM
                            , n1.new_value1 as TOBE_PLANT
                            , PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE
                            , PRCTR,WAERS,MATKL,VALUATION_CLASS
                            , rank() over (partition by YYYYMM, n1.new_value1, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE order by PLANT_ID) as rno
                         into #TMP_SCP_ANL_LONG_TERM_STOCK
                         from SCP_ANL_LONG_TERM_STOCK A with (nolock)
                    LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) N1 ON A.PLANT_ID = N1.old_value1
                    order by  YYYYMM, n1.new_value1, PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE


                    -- INSERT 대상 확인
                    --select *
                    --FROM #TMP_SCP_ANL_LONG_TERM_STOCK
                    --where PLANT_ID  in (SELECT OLD_VALUE1 FROM #TMP_PLANT_DUP_DETAIL )
                    --and  rno > 1

                        -- SELECT 9초
                        -- INSERT 3초
                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                        , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7,COLUMN_NAME8,COLUMN_NAME9,COLUMN_NAME10
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6, OLD_VALUE7,OLD_VALUE8, OLD_VALUE9, OLD_VALUE10
                        , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3,NEW_VALUE4
                        , NEW_VALUE7, NEW_VALUE8, NEW_VALUE9,NEW_VALUE10
                        )
                        SELECT
                               'SCP_ANL_LONG_TERM_STOCK'
                               , 'YYYYMM', 'PLANT_ID' , 'DIVISION_ID', 'ITEM_ID', 'CHARG','DEVALUATION_AGE'
                               , 'PRCTR' , 'WAERS', 'MATKL', 'VALUATION_CLASS'
                              ,YYYYMM, PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE
                             , PRCTR,WAERS,MATKL,VALUATION_CLASS
                             ,TOBE_PLANT,TOBE_PRCTR,TOBE_WAERS,TOBE_VALUATION_CLASS
                             , rno
                            , PLANT_ELEC
                            , CASE WHEN PLANT_ELEC IS NOT NULL and rno > 1 then 'DP'
                                   else 'NO'
                                   end AS DP
                            , CASE WHEN ISNULL(TOBE_PLANT,'') != '' THEN 'Y'
                                    WHEN ISNULL(TOBE_PRCTR,'') != '' THEN 'Y'
                                    WHEN ISNULL(TOBE_WAERS,'') != '' THEN 'Y'
                                    WHEN ISNULL(TOBE_VALUATION_CLASS,'') != '' THEN 'Y'
                                    ELSE NULL
                                    END CHANGE_YN
                         FROM
                         (
                             SELECT   YYYYMM, PLANT_ID, DIVISION_ID, ITEM_ID, CHARG, DEVALUATION_AGE
                                    , PRCTR,WAERS,MATKL,VALUATION_CLASS, rno
                                    ,N1.new_value1 AS TOBE_PLANT
                                    ,N2.NEW_VALUE2 AS TOBE_PRCTR
                                    ,N3.NEW_VALUE1 AS TOBE_WAERS
                                    , CASE
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE01'   THEN '3001'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE02'   THEN '3002'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA01'   THEN '3003'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA02'   THEN '3004'
                                      WHEN A.VALUATION_CLASS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) like 'RP%' THEN '3005'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE02'   THEN '3002'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA01'   THEN '3003'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA02'   THEN '3004'
                                      WHEN A.VALUATION_CLASS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) like 'RP%' THEN '3005'
                                      WHEN A.VALUATION_CLASS = '3001' THEN '3000'
                                      ELSE NULL
                                       END AS TOBE_VALUATION_CLASS
                                    ,ND.PLANT_ELEC AS PLANT_ELEC
                                from #TMP_SCP_ANL_LONG_TERM_STOCK A --with (index(PK_SCP_ANL_LONG_TERM_STOCK) nolock)
                                LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) N1
                                            ON A.PLANT_ID = N1 .old_value1
                                LEFT JOIN (select PLANT_ELEC from #TMP_PLANT_DUPLICATION) ND
                                            ON A.PLANT_ID = ND.PLANT_ELEC
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'WAERS' AND ATTRIBUTE5 = @P_ROLLIN) N3
                                            ON A.WAERS = N3.OLD_VALUE1
                                LEFT JOIN (SELECT NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'MATKL' AND ATTRIBUTE5 = @P_ROLLIN) E
                                            ON A.ITEM_ID    = E.NEW_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1,  new_value2
                                                , REPLICATE('0',10 - LEN(OLD_VALUE2)) + OLD_VALUE2 AS ASIS_CODE
                                             FROM NERP_CONV_MASTER_CFM_V
                                            WHERE CODETYPE = 'PROFIT_CENTER_ID'
                                            AND ATTRIBUTE5 = @P_ROLLIN) N2
                                            ON A.PRCTR  = N2.ASIS_CODE

                         ) LIST
                        -- where rno > 1
                         --and isnull(PLANT_ELEC,'') != ''

                        -- 2997
                        /*
                        select * from NERP_CONV_SCP_DATA
                        where table_name = 'SCP_ANL_LONG_TERM_STOCK'
                        and new_value9 != 'DP'
                        */

            --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      UPDATE SCP_ANL_LONG_TERM_STOCK
                         SET SCP_ANL_LONG_TERM_STOCK.PLANT_ID           = ISNULL(B.new_value1, A.PLANT_ID)
                            ,SCP_ANL_LONG_TERM_STOCK.PRCTR              = ISNULL(B.new_value2, A.PRCTR)
                            ,SCP_ANL_LONG_TERM_STOCK.WAERS              = ISNULL(B.new_value2, A.WAERS)
                            ,SCP_ANL_LONG_TERM_STOCK.MATKL              = ISNULL(B.new_value2, A.MATKL)
                            ,SCP_ANL_LONG_TERM_STOCK.VALUATION_CLASS    = ISNULL(B.new_value2, A.VALUATION_CLASS)
                            ,SCP_ANL_LONG_TERM_STOCK.ATTRIBUTE10        = 'NERP_BATCH_UPDATE'
                       FROM .SCP_ANL_LONG_TERM_STOCK AS A,
                    (
                       SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6, OLD_VALUE7,OLD_VALUE8, OLD_VALUE9, OLD_VALUE10
                            , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3,NEW_VALUE4
                            , NEW_VALUE7, NEW_VALUE8, NEW_VALUE9,NEW_VALUE10
                       FROM NERP_CONV_SCP_DATA with (nolock)
                       where table_name = 'SCP_ANL_LONG_TERM_STOCK'
                        and new_value9 != 'DP'
                       ) AS B
                      WHERE 1 = 1
                        AND A.YYYYMM            = B.OLD_VALUE1
                        AND A.PLANT_ID          = B.OLD_VALUE2
                        AND A.DIVISION_ID       = B.OLD_VALUE2
                        AND A.ITEM_ID           = B.OLD_VALUE2
                        AND A.CHARG             = B.OLD_VALUE2
                        AND A.DEVALUATION_AGE   = B.OLD_VALUE2

                    */


                    SET @MAPPING_RESULT = 'Y';

                    END


                /*
                 PK
                  PLAN_START_YYYYMMDD
                , SEQ
                , OPERATION_GROUP
                , COMPANY_ID
                , PLANT_ID
                , DIVISION_ID
                , FROM_SITE
                , CELL_ITEM_ID
                , ITEM_ID
                , MEASURE
                , VALUE_TYPE
                , TO_PRODUCT
                , LINE_ID
                , TO_SITE
                , INCOTERMS
                , YYYYMM


                ---------------------------------------------
                COMPANY_ID
                PLANT_ID
                FROM_SITE
                TO_SITE
                INCOTERMS


                -- 전극 외 Plant 데이터 유지
                */
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_INTEGRATION'
                BEGIN

                        -- 작업전 1666560 -> 작업후 1665278
                        -- 삭제가 일어나므로 백업 준비
                        /*
                        SELECT *
                        INTO SCP_ANL_PSI_INTEGRATION_CONV
                        FROM SCP_ANL_PSI_INTEGRATION
                        */

                        --########################################################

                        SELECT *
                             ,  CASE WHEN ISNULL(TOBE_COMPANY,'')  != ''  THEN 'Y'
                                     WHEN ISNULL(TOBE_PLANT,'')  != ''  THEN 'Y'
                                     WHEN ISNULL(TOBE_FROM_SITE,'')  != ''  THEN 'Y'
                                     WHEN ISNULL(TOBE_TO_SITE,'')  != ''  THEN 'Y'
                                     ELSE 'N'
                                     END AS  CHAnGE_YN

                        INTO #TMP_SCP_ANL_PSI_INTEGRATION
                        FROM
                        (
                        SELECT  PLAN_START_YYYYMMDD
                                , SEQ
                                , OPERATION_GROUP
                                , COMPANY_ID
                                , PLANT_ID
                                , DIVISION_ID
                                , FROM_SITE
                                , CELL_ITEM_ID
                                , ITEM_ID
                                , MEASURE
                                , VALUE_TYPE
                                , TO_PRODUCT
                                , LINE_ID
                                , TO_SITE
                                , INCOTERMS
                                , YYYYMM
                                ---------------------------------------------------------------------------------------------
                                , QTY
                                , BOH_QTY
                                ---------------------------------------------------------------------------------------------
                                , B.NEW_VALUE1 AS TOBE_COMPANY
                                , C.NEW_VALUE1 AS TOBE_PLANT
                                , D.NEW_VALUE1 AS TOBE_FROM_SITE
                                --20250607 TOBE_TO_SITE에서 PLANT_ID가 누락되어서 추가함
                                , ISNULL(E.NEW_VALUE1,F.NEW_VALUE1) AS TOBE_TO_SITE
                        FROM SCP_ANL_PSI_INTEGRATION A with (NOLOCK)
                        LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) B ON A.COMPANY_ID = B.OLD_VALUE1
                        LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)   C ON A.PLANT_ID = C.OLD_VALUE1
                        LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.FROM_SITE = D.OLD_VALUE1
                        LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) E ON A.TO_SITE = E.OLD_VALUE1
                        LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)   F ON A.TO_SITE = F.OLD_VALUE1
                        ) LIST

                        --##########################################################################################################
                        SELECT *
                        INTO #TMP_SCP_ANL_PSI_INTEGRATION_DUP
                        FROM
                        (
                        SELECT PLAN_START_YYYYMMDD
                              , SEQ
                              , OPERATION_GROUP
                              , COMPANY_ID
                              , PLANT_ID
                              , DIVISION_ID
                              , FROM_SITE
                              , CELL_ITEM_ID
                              , ITEM_ID
                              , MEASURE
                              , VALUE_TYPE
                              , TO_PRODUCT
                              , LINE_ID
                              , TO_SITE
                              , INCOTERMS
                              , YYYYMM
                              , QTY
                              , BOH_QTY
                            , TOBE_COMPANY
                            , TOBE_PLANT
                            , TOBE_FROM_SITE
                            , TOBE_TO_SITE
                              , rank() over(partition by PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP
                                                       , ISNULL(TOBE_COMPANY, COMPANY_ID)
                                                       , ISNULL(TOBE_PLANT, PLANT_ID)
                                                       , DIVISION_ID
                                                       , ISNULL(TOBE_FROM_SITE, FROM_SITE)
                                                       , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID
                                                       , ISNULL(TOBE_TO_SITE, TO_SITE)
                                                       , YYYYMM
                                                       order by PLANT_ID ,FROM_SITE, TO_SITE, INCOTERMS) as rno

                        FROM #TMP_SCP_ANL_PSI_INTEGRATION
                        ) LIST
                        where rno > 1


                        /*
                        -- 1594994
                        select count(*) from #TMP_SCP_ANL_PSI_INTEGRATION
                        -- 1321
                        select count(*) from #TMP_SCP_ANL_PSI_INTEGRATION_DUP
                        -- 1593673
                        select 1594994 - 1321
                        */

                        --##########################################################################################################
                        DELETE SCP_ANL_PSI_INTEGRATION
                          FROM SCP_ANL_PSI_INTEGRATION A
                          JOIN #TMP_SCP_ANL_PSI_INTEGRATION_DUP B
                             on A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD
                            AND A.SEQ                   = B.SEQ
                            AND A.OPERATION_GROUP       = B.OPERATION_GROUP
                            AND A.COMPANY_ID            = B.COMPANY_ID
                            AND A.PLANT_ID              = B.PLANT_ID
                            AND A.DIVISION_ID           = B.DIVISION_ID
                            AND A.FROM_SITE             = B.FROM_SITE
                            AND A.CELL_ITEM_ID          = B.CELL_ITEM_ID
                            AND A.ITEM_ID               = B.ITEM_ID
                            AND A.MEASURE               = B.MEASURE
                            AND A.VALUE_TYPE            = B.VALUE_TYPE
                            AND A.TO_PRODUCT            = B.TO_PRODUCT
                            AND A.LINE_ID               = B.LINE_ID
                            AND A.TO_SITE               = B.TO_SITE
                            AND A.YYYYMM                = B.YYYYMM
                            AND B.rno > 1

                        --##########################################################################################################
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET SCP_ANL_PSI_INTEGRATION.COMPANY_ID    = ISNULL(TOBE_COMPANY, A.COMPANY_ID)
                              ,SCP_ANL_PSI_INTEGRATION.PLANT_ID      = ISNULL(TOBE_PLANT, A.PLANT_ID)
                              ,SCP_ANL_PSI_INTEGRATION.FROM_SITE     = ISNULL(TOBE_FROM_SITE, A.FROM_SITE)
                              ,SCP_ANL_PSI_INTEGRATION.TO_SITE       = ISNULL(TOBE_TO_SITE, A.TO_SITE)
                              ,SCP_ANL_PSI_INTEGRATION.LAST_UPDATED_BY = @CREATED_BY
                              ,SCP_ANL_PSI_INTEGRATION.LAST_UPDATE_DATE = GETDATE()

                          FROM .SCP_ANL_PSI_INTEGRATION AS A,
                        (
                         --1593673
                         SELECT *
                          FROM  #TMP_SCP_ANL_PSI_INTEGRATION
                         where change_yn = 'Y'
                          ) AS B
                         WHERE  A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD
                            AND A.SEQ                   = B.SEQ
                            AND A.OPERATION_GROUP       = B.OPERATION_GROUP
                            AND A.COMPANY_ID            = B.COMPANY_ID
                            AND A.PLANT_ID              = B.PLANT_ID
                            AND A.DIVISION_ID           = B.DIVISION_ID
                            AND A.FROM_SITE             = B.FROM_SITE
                            AND A.CELL_ITEM_ID          = B.CELL_ITEM_ID
                            AND A.ITEM_ID               = B.ITEM_ID
                            AND A.MEASURE               = B.MEASURE
                            AND A.VALUE_TYPE            = B.VALUE_TYPE
                            AND A.TO_PRODUCT            = B.TO_PRODUCT
                            AND A.LINE_ID               = B.LINE_ID
                            AND A.TO_SITE               = B.TO_SITE
                            AND A.INCOTERMS             = B.INCOTERMS
                            AND A.YYYYMM                = B.YYYYMM


                        --##########################################################################################################
                        -- 61초
                        -- 1346
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET SCP_ANL_PSI_INTEGRATION.BOH_QTY   = ISNULL(A.BOH_QTY,0) + ISNULL(B.BOH_QTY,0)
                              ,SCP_ANL_PSI_INTEGRATION.QTY       = ISNULL(A.QTY,0) + ISNULL(B.QTY,0)
                              ,ATTRIBUTE10 = 'SUM QTY,BOH_QTY'
                              ,SCP_ANL_PSI_INTEGRATION.LAST_UPDATED_BY = @CREATED_BY
                              ,SCP_ANL_PSI_INTEGRATION.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCP_ANL_PSI_INTEGRATION AS A,
                        (
                         --1321
                         SELECT *
                          FROM  #TMP_SCP_ANL_PSI_INTEGRATION_DUP
                          WHERE rno > 1

                          ) AS B
                         WHERE  A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD
                            AND A.SEQ                   = B.SEQ
                            AND A.OPERATION_GROUP       = B.OPERATION_GROUP
                            AND A.COMPANY_ID            = ISNULL(B.TOBE_COMPANY,A.COMPANY_ID)
                            AND A.PLANT_ID              = ISNULL(B.TOBE_PLANT,A.PLANT_ID)
                            AND A.DIVISION_ID           = B.DIVISION_ID
                            AND A.FROM_SITE             = ISNULL(B.TOBE_FROM_SITE,A.FROM_SITE)
                            AND A.CELL_ITEM_ID          = B.CELL_ITEM_ID
                            AND A.ITEM_ID               = B.ITEM_ID
                            AND A.MEASURE               = B.MEASURE
                            AND A.VALUE_TYPE            = B.VALUE_TYPE
                            AND A.TO_PRODUCT            = B.TO_PRODUCT
                            AND A.LINE_ID               = B.LINE_ID
                            AND A.TO_SITE               = ISNULL(B.TOBE_TO_SITE,A.TO_SITE)
                            -- 2025-03-11 B.TOBE_INCOTERMS 컬럼 없음 막음
                            -- AND A.INCOTERMS              = ISNULL(B.TOBE_INCOTERMS,A.INCOTERMS)
                            AND A.YYYYMM                = B.YYYYMM




                        --##########################################################################################################
--> 작업시 테이블 드랍하고 시작해야 한다.
--DROP TABLE SCP_ANL_PSI_INTEGRATION_DUP;
                        --SELECT *
                        --INTO SCP_ANL_PSI_INTEGRATION_DUP
                        --FROM #TMP_SCP_ANL_PSI_INTEGRATION_DUP


                        --##########################################################################################################
                         drop table #TMP_SCP_ANL_PSI_INTEGRATION
                         drop table #TMP_SCP_ANL_PSI_INTEGRATION_DUP





                /*
                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_ANL_PSI_INTEGRATION';

                -- 1495375
                select count(*) from SCP_ANL_PSI_INTEGRATION

                                SELECT
                                  PLAN_START_YYYYMMDD
                                , SEQ
                                , OPERATION_GROUP
                                , COMPANY_ID
                                , PLANT_ID
                                , DIVISION_ID
                                , FROM_SITE
                                , CELL_ITEM_ID
                                , ITEM_ID
                                , MEASURE
                                , VALUE_TYPE
                                , TO_PRODUCT
                                , LINE_ID
                                , TO_SITE
                                , INCOTERMS
                                , YYYYMM
                                INTO #TMP_SCP_ANL_PSI_INTEGRATION
                               FROM SCP_ANL_PSI_INTEGRATION A
                               group by
                                  PLAN_START_YYYYMMDD
                                , SEQ
                                , OPERATION_GROUP
                                , COMPANY_ID
                                , PLANT_ID
                                , DIVISION_ID
                                , FROM_SITE
                                , CELL_ITEM_ID
                                , ITEM_ID
                                , MEASURE
                                , VALUE_TYPE
                                , TO_PRODUCT
                                , LINE_ID
                                , TO_SITE
                                , INCOTERMS
                                , YYYYMM


                                SELECT
                                      PLAN_START_YYYYMMDD
                                    , SEQ
                                    , OPERATION_GROUP
                                    , COMPANY_ID
                                    , PLANT_ID
                                    , DIVISION_ID
                                    , FROM_SITE
                                    , CELL_ITEM_ID
                                    , ITEM_ID
                                    , MEASURE
                                    , VALUE_TYPE
                                    , TO_PRODUCT
                                    , LINE_ID
                                    , TO_SITE
                                    , INCOTERMS
                                    , YYYYMM
                                    , D.NEW_VALUE1 as TOBE_COMPANY
                                    , E.NEW_VALUE1 as TOBE_PLANT
                                    , F.NEW_VALUE1 as TOBE_FROM_SITE
                                    , G.NEW_VALUE1 as TOBE_TO_SITE
                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'') != '' THEN 'Y'
                                           WHEN ISNULL(E.NEW_VALUE1,'') != '' THEN 'Y'
                                           WHEN ISNULL(F.NEW_VALUE1,'') != '' THEN 'Y'
                                           WHEN ISNULL(G.NEW_VALUE1,'') != '' THEN 'Y'
                                           ELSE NULL
                                           END TOBE_USE
                                INTO #TMP_SCP_ANL_PSI_INTEGRATION_CONV
                                FROM #TMP_SCP_ANL_PSI_INTEGRATION A
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D  ON A.COMPANY_ID = D.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E   ON A.PLANT_ID   = E.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) F ON A.FROM_SITE  = F.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) G ON A.TO_SITE    = G.OLD_VALUE1

                                select *
                                from #TMP_SCP_ANL_PSI_INTEGRATION_CONV
                                where ISNULL(TOBE_USE,'') = 'Y'







                        -------------------------------------------------------------------------------
                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                        , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7,COLUMN_NAME8,COLUMN_NAME9,COLUMN_NAME10
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6, OLD_VALUE7, OLD_VALUE8,OLD_VALUE9, OLD_VALUE10
                        , NEW_VALUE1,NEW_VALUE2,NEW_VALUE3,NEW_VALUE4
                        , NEW_VALUE9, NEW_VALUE10
                        )
                        SELECT
                               'SCP_ANL_PSI_INTEGRATION'
                              , 'COMPANY_ID', 'PLANT_ID', 'DIVISION_ID', 'FROM_SITE', 'ITEM_ID'
                              , 'MEASURE'   , 'LINE_ID' ,'TO_SITE'     ,'INCOTERMS' , 'YYYYMM'
                              ,COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, ITEM_ID
                              , MEASURE, LINE_ID, TO_SITE, INCOTERMS, YYYYMM
                             , TOBE_COMPANY
                             , TOBE_PLANT
                             , TOBE_FROM_SITE
                             , TOBE_TO_SITE
                             , PLANT_TYPE
                             , TOBE_USE
                         FROM
                         (

                             SELECT
                                     COMPANY_ID, PLANT_ID, DIVISION_ID, FROM_SITE, ITEM_ID
                                   , MEASURE, LINE_ID, TO_SITE, INCOTERMS, YYYYMM

                                    , D.NEW_VALUE1 as TOBE_COMPANY
                                    , E.NEW_VALUE1 as TOBE_PLANT
                                    , F.NEW_VALUE1 as TOBE_FROM_SITE
                                    , G.NEW_VALUE1 as TOBE_TO_SITE

                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'')    != '' AND PLANT_ID IN ('A011','A041','G482','F031') THEN 'DELETE'
                                           WHEN ISNULL(E.NEW_VALUE1,'')    != '' AND PLANT_ID IN ('A011','A041','G482','F031') THEN 'DELETE'
                                           ELSE 'SAVE'
                                           END PLANT_TYPE
                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'')    != '' THEN 'Y'
                                           WHEN ISNULL(E.NEW_VALUE1,'') != ''THEN 'Y'
                                           ELSE NULL
                                           END TOBE_USE
                                from SCP_ANL_PSI_INTEGRATION A
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D  ON A.COMPANY_ID = D.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E   ON A.PLANT_ID = E.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) F ON A.FROM_SITE = F.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) G ON A.TO_SITE = G.OLD_VALUE1



                        ) LIST
                     -----------------------------------------------------

                    UPDATE SCP_ANL_PSI_INTEGRATION
                       SET SCP_ANL_PSI_INTEGRATION.COMPANY_ID   = ISNULL(B.NEW_VALUE1, COMPANY_ID)
                          ,SCP_ANL_PSI_INTEGRATION.PLANT_ID = ISNULL(B.NEW_VALUE2, PLANT_ID)
                     FROM .SCP_ANL_PSI_INTEGRATION AS A,
                    (SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                           ,NEW_VALUE1, NEW_VALUE2
                           ,NEW_VALUE9, NEW_VALUE10
                       from NERP_CONV_SCP_DATA
                      where table_name = 'SCP_ANL_PSI_INTEGRATION'
                      and NEW_VALUE10 = 'Y'
                      and NEW_VALUE9 = 'SAVE'
                      ) AS B
                    WHERE   A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7



                    DELETE SCP_ANL_PSI_INTEGRATION
                      FROM SCP_ANL_PSI_INTEGRATION a
                      JOIN (
                              SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                                   ,NEW_VALUE1, NEW_VALUE2
                                   ,NEW_VALUE9, NEW_VALUE10
                               from NERP_CONV_SCP_DATA
                              where table_name = 'SCP_ANL_PSI_INTEGRATION'
                              and NEW_VALUE10 = 'Y'
                              and NEW_VALUE9 = 'DELETE'
                           )  b
                        on  A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7

                      */
                      SET @MAPPING_RESULT = 'Y';
                END

                /*
                -- PK
                DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
                COMPANY_ID, PLANT_ID

                -- 전극 Plant 데이터 유지
                */
                ELSE IF @TABLE_NAME = 'SCP_MST_CAPA_ELTR_LINE'
                BEGIN
                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_MST_CAPA_ELTR_LINE';

                        -------------------------------------------------------------------------------
                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6, OLD_VALUE7
                        , NEW_VALUE1,NEW_VALUE2
                        , NEW_VALUE9, NEW_VALUE10
                        )
                        SELECT
                               'SCP_MST_CAPA_ELTR_LINE'
                              ,'DIVISION_ID', 'COMPANY_ID', 'SITE_ID', 'PLANT_ID', 'FACTORY_ID', 'LINE_ID', 'OPERATION_ID'
                              ,DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
                             , TOBE_COMPANY
                             , TOBE_PLANT
                             , PLANT_TYPE
                             , TOBE_USE
                         FROM
                         (
                             SELECT
                                     DIVISION_ID
                                    ,COMPANY_ID
                                    ,SITE_ID
                                    ,PLANT_ID
                                    ,FACTORY_ID
                                    ,LINE_ID
                                    ,OPERATION_ID
                                    , D.NEW_VALUE1 as TOBE_COMPANY
                                    , E.NEW_VALUE1 as TOBE_PLANT
                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'')    != '' AND PLANT_ID IN ('A010','A040','G481','F030') THEN 'DELETE'
                                           WHEN ISNULL(E.NEW_VALUE1,'')    != '' AND PLANT_ID IN ('A010','A040','G481','F030') THEN 'DELETE'
                                           ELSE 'SAVE'
                                           END PLANT_TYPE
                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'')    != '' THEN 'Y'
                                           WHEN ISNULL(E.NEW_VALUE1,'') != '' THEN 'Y'
                                           ELSE NULL
                                           END TOBE_USE
                                from SCP_MST_CAPA_ELTR_LINE A
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.COMPANY_ID = D.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E ON A.PLANT_ID = E.OLD_VALUE1
                         ) LIST
                     -----------------------------------------------------

                        --##########################################################################################################
--> 작업시 테이블 드랍하고 시작해야 한다.
--DROP TABLE SCP_MST_CAPA_ELTR_LINE_DUP;
--UPDATE시 중복 발생 데이터 처리용 저장한다.

        IF OBJECT_ID('DBO.SCP_MST_CAPA_ELTR_LINE_DUP') IS NOT NULL
        BEGIN
        DROP TABLE DBO.SCP_MST_CAPA_ELTR_LINE_DUP;
        END


                        --##########################################################################################################
                    --2025-03-12 중복제거용 데이터 저장
                     SELECT  KEY_DIVISION_ID = A.DIVISION_ID
                            ,KEY_COMPANY_ID  = ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                            ,KEY_SITE_ID     = A.SITE_ID
                            ,KEY_PLANT_ID    = ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                            ,KEY_FACTORY_ID  = A.FACTORY_ID
                            ,KEY_LINE_ID     = A.LINE_ID
                            ,KEY_OPERATION_ID= A.OPERATION_ID
                            ,KEY_RNUM        = ROW_NUMBER()OVER(PARTITION BY A.DIVISION_ID
                                ,ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                                ,A.SITE_ID
                                ,ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                                ,A.FACTORY_ID
                                ,A.LINE_ID
                                ,A.OPERATION_ID ORDER BY A.DIVISION_ID
                                ,ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                                ,A.SITE_ID
                                ,ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                                ,A.FACTORY_ID
                                ,A.LINE_ID
                                ,A.OPERATION_ID)
                            ,X1='---CAPA_ELTR_LINE---->'
                            ,CAPA_ELTR_LINE_DIVISION_ID=A.DIVISION_ID
                            ,CAPA_ELTR_LINE_COMPANY_ID=A.COMPANY_ID
                            ,CAPA_ELTR_LINE_SITE_ID=A.SITE_ID
                            ,CAPA_ELTR_LINE_PLANT_ID=A.PLANT_ID
                            ,CAPA_ELTR_LINE_FACTORY_ID=A.FACTORY_ID
                            ,CAPA_ELTR_LINE_LINE_ID=A.LINE_ID
                            ,CAPA_ELTR_LINE_OPERATION_ID=A.OPERATION_ID
                            ,CAPA_ELTR_LINE_ELTR_LN_TP_CD=A.ELTR_LN_TP_CD
                            ,CAPA_ELTR_LINE_SITE_NAME=A.SITE_NAME
                            ,CAPA_ELTR_LINE_PLANT_NAME=A.PLANT_NAME
                            ,CAPA_ELTR_LINE_FACTORY_NAME=A.FACTORY_NAME
                            ,CAPA_ELTR_LINE_LINE_NAME=A.LINE_NAME
                            ,CAPA_ELTR_LINE_VALID_YN=A.VALID_YN
                            ,CAPA_ELTR_LINE_ATTRIBUTE1=A.ATTRIBUTE1
                            ,CAPA_ELTR_LINE_ATTRIBUTE2=A.ATTRIBUTE2
                            ,CAPA_ELTR_LINE_ATTRIBUTE3=A.ATTRIBUTE3
                            ,CAPA_ELTR_LINE_ATTRIBUTE4=A.ATTRIBUTE4
                            ,CAPA_ELTR_LINE_ATTRIBUTE5=A.ATTRIBUTE5
                            ,CAPA_ELTR_LINE_ATTRIBUTE6=A.ATTRIBUTE6
                            ,CAPA_ELTR_LINE_ATTRIBUTE7=A.ATTRIBUTE7
                            ,CAPA_ELTR_LINE_ATTRIBUTE8=A.ATTRIBUTE8
                            ,CAPA_ELTR_LINE_ATTRIBUTE9=A.ATTRIBUTE9
                            ,CAPA_ELTR_LINE_ATTRIBUTE10=A.ATTRIBUTE10
                            ,CAPA_ELTR_LINE_CREATED_BY=A.CREATED_BY
                            ,CAPA_ELTR_LINE_CREATION_DATE=A.CREATION_DATE
                            ,CAPA_ELTR_LINE_LAST_UPDATED_BY=A.LAST_UPDATED_BY
                            ,CAPA_ELTR_LINE_LAST_UPDATE_DATE=A.LAST_UPDATE_DATE
                            ,CAPA_ELTR_LINE_COMPANY_NAME=A.COMPANY_NAME
                            ,X2='---CONV_SCP_DATA---->'
                            ,CONV_SCP_DATA_OLD_VALUE1=B.OLD_VALUE1
                            ,CONV_SCP_DATA_OLD_VALUE2=B.OLD_VALUE2
                            ,CONV_SCP_DATA_OLD_VALUE3=B.OLD_VALUE3
                            ,CONV_SCP_DATA_OLD_VALUE4=B.OLD_VALUE4
                            ,CONV_SCP_DATA_OLD_VALUE5=B.OLD_VALUE5
                            ,CONV_SCP_DATA_OLD_VALUE6=B.OLD_VALUE6
                            ,CONV_SCP_DATA_OLD_VALUE7=B.OLD_VALUE7
                            ,CONV_SCP_DATA_NEW_VALUE1=B.NEW_VALUE1
                            ,CONV_SCP_DATA_NEW_VALUE2=B.NEW_VALUE2
                            ,CONV_SCP_DATA_NEW_VALUE9=B.NEW_VALUE9
                            ,CONV_SCP_DATA_NEW_VALUE10=B.NEW_VALUE10
                     INTO  dbo.SCP_MST_CAPA_ELTR_LINE_DUP
                     FROM .SCP_MST_CAPA_ELTR_LINE AS A WITH(NOLOCK),
                    (SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                           ,NEW_VALUE1, NEW_VALUE2
                           ,NEW_VALUE9, NEW_VALUE10
                       from NERP_CONV_SCP_DATA WITH(NOLOCK)
                      where table_name = 'SCP_MST_CAPA_ELTR_LINE'
                      and NEW_VALUE10 = 'Y'
                      and NEW_VALUE9 = 'SAVE'
                      ) AS B
                    WHERE   A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7
                    ;

                    --2025-03-12 중복발생예정인 RNUM이 1보다 큰 것 삭제
                    DELETE A
                     FROM  SCP_MST_CAPA_ELTR_LINE AS A WITH(NOLOCK)
                     JOIN  SCP_MST_CAPA_ELTR_LINE_DUP AS B WITH(NOLOCK)
                      ON   1=1
                      AND   A.DIVISION_ID   = B.CONV_SCP_DATA_OLD_VALUE1
                      AND   A.COMPANY_ID    = B.CONV_SCP_DATA_OLD_VALUE2
                      AND   A.SITE_ID       = B.CONV_SCP_DATA_OLD_VALUE3
                      AND   A.PLANT_ID      = B.CONV_SCP_DATA_OLD_VALUE4
                      AND   A.FACTORY_ID    = B.CONV_SCP_DATA_OLD_VALUE5
                      AND   A.LINE_ID       = B.CONV_SCP_DATA_OLD_VALUE6
                      AND   A.OPERATION_ID  = B.CONV_SCP_DATA_OLD_VALUE7
                    WHERE   B.KEY_RNUM > 1;


                    UPDATE SCP_MST_CAPA_ELTR_LINE
                       SET SCP_MST_CAPA_ELTR_LINE.COMPANY_ID    = ISNULL(B.NEW_VALUE1, COMPANY_ID)
                          ,SCP_MST_CAPA_ELTR_LINE.PLANT_ID  = ISNULL(B.NEW_VALUE2, PLANT_ID)
                          ,SCP_MST_CAPA_ELTR_LINE.LAST_UPDATED_BY = @CREATED_BY
                          ,SCP_MST_CAPA_ELTR_LINE.LAST_UPDATE_DATE = GETDATE()
                     FROM .SCP_MST_CAPA_ELTR_LINE AS A,
                    (SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                           ,NEW_VALUE1, NEW_VALUE2
                           ,NEW_VALUE9, NEW_VALUE10
                       from NERP_CONV_SCP_DATA
                      where table_name = 'SCP_MST_CAPA_ELTR_LINE'
                      and NEW_VALUE10 = 'Y'
                      and NEW_VALUE9 = 'SAVE'
                      ) AS B
                    WHERE   A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7

                    DELETE SCP_MST_CAPA_ELTR_LINE
                      FROM SCP_MST_CAPA_ELTR_LINE a
                      JOIN (
                              SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                                   ,NEW_VALUE1, NEW_VALUE2
                                   ,NEW_VALUE9, NEW_VALUE10
                               from NERP_CONV_SCP_DATA
                              where table_name = 'SCP_MST_CAPA_ELTR_LINE'
                              and NEW_VALUE10 = 'Y'
                              and NEW_VALUE9 = 'DELETE'
                           )  b
                        on  A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7


                      SET @MAPPING_RESULT = 'Y';
                END



                /*
                -- PK
                SCP_MST_CAPA_LINE

                DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
                COMPANY_ID, PLANT_ID

                -- 전극 아닌 Plant 데이터 유지
                */
                ELSE IF @TABLE_NAME = 'SCP_MST_CAPA_LINE'
                BEGIN
                        delete from NERP_CONV_SCP_DATA 
                        where table_name = 'SCP_MST_CAPA_LINE';

                        -------------------------------------------------------------------------------
                        INSERT INTO NERP_CONV_SCP_DATA
                        (
                          TABLE_NAME
                          ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7
                        , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6, OLD_VALUE7
                        , NEW_VALUE1,NEW_VALUE2
                        , NEW_VALUE9, NEW_VALUE10
                        )
                        SELECT
                               'SCP_MST_CAPA_LINE'
                              ,'DIVISION_ID', 'COMPANY_ID', 'SITE_ID', 'PLANT_ID', 'FACTORY_ID', 'LINE_ID', 'OPERATION_ID'
                              ,DIVISION_ID, COMPANY_ID, SITE_ID, PLANT_ID, FACTORY_ID, LINE_ID, OPERATION_ID
                             , TOBE_COMPANY
                             , TOBE_PLANT
                             , PLANT_TYPE
                             , TOBE_USE
                         FROM
                         (
                             SELECT
                                     DIVISION_ID
                                    ,COMPANY_ID
                                    ,SITE_ID
                                    ,PLANT_ID
                                    ,FACTORY_ID
                                    ,LINE_ID
                                    ,OPERATION_ID
                                    , D.NEW_VALUE1 as TOBE_COMPANY
                                    , E.NEW_VALUE1 as TOBE_PLANT
                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'')    != '' AND PLANT_ID IN ('A011','A041','G482','F031') THEN 'DELETE'
                                           WHEN ISNULL(E.NEW_VALUE1,'')    != '' AND PLANT_ID IN ('A011','A041','G482','F031') THEN 'DELETE'
                                           ELSE 'SAVE'
                                           END PLANT_TYPE
                                    , CASE WHEN ISNULL(D.NEW_VALUE1,'')    != '' THEN 'Y'
                                           WHEN ISNULL(E.NEW_VALUE1,'') != ''THEN 'Y'
                                           ELSE NULL
                                           END TOBE_USE
                                from SCP_MST_CAPA_LINE A
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.COMPANY_ID = D.OLD_VALUE1
                                left join ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)  E ON A.PLANT_ID = E.OLD_VALUE1
                         ) LIST
                     -----------------------------------------------------

                        --##########################################################################################################
--> 작업시 테이블 드랍하고 시작해야 한다.
--DROP TABLE SCP_MST_CAPA_LINE_DUP;
--UPDATE시 중복 발생 데이터 처리용 저장한다.

        IF OBJECT_ID('DBO.SCP_MST_CAPA_LINE_DUP') IS NOT NULL
        BEGIN
        DROP TABLE DBO.SCP_MST_CAPA_LINE_DUP;
        END
                        --##########################################################################################################
                    --2025-03-12 중복제거용 데이터 저장
                     SELECT  KEY_DIVISION_ID = A.DIVISION_ID
                            ,KEY_COMPANY_ID  = ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                            ,KEY_SITE_ID     = A.SITE_ID
                            ,KEY_PLANT_ID    = ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                            ,KEY_FACTORY_ID  = A.FACTORY_ID
                            ,KEY_LINE_ID     = A.LINE_ID
                            ,KEY_OPERATION_ID= A.OPERATION_ID
                            ,KEY_RNUM        = ROW_NUMBER()OVER(PARTITION BY A.DIVISION_ID
                                ,ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                                ,A.SITE_ID
                                ,ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                                ,A.FACTORY_ID
                                ,A.LINE_ID
                                ,A.OPERATION_ID ORDER BY A.DIVISION_ID
                                ,ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                                ,A.SITE_ID
                                ,ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                                ,A.FACTORY_ID
                                ,A.LINE_ID
                                ,A.OPERATION_ID)
                            ,X1='---CAPA_LINE---->'
                            ,CAPA_LINE_DIVISION_ID=A.DIVISION_ID
                            ,CAPA_LINE_COMPANY_ID=A.COMPANY_ID
                            ,CAPA_LINE_SITE_ID=A.SITE_ID
                            ,CAPA_LINE_PLANT_ID=A.PLANT_ID
                            ,CAPA_LINE_FACTORY_ID=A.FACTORY_ID
                            ,CAPA_LINE_LINE_ID=A.LINE_ID
                            ,CAPA_LINE_OPERATION_ID=A.OPERATION_ID
                            ,CAPA_LINE_ELTR_LN_TP_CD=A.ELTR_LN_TP_CD
                            ,CAPA_LINE_SITE_NAME=A.SITE_NAME
                            ,CAPA_LINE_PLANT_NAME=A.PLANT_NAME
                            ,CAPA_LINE_FACTORY_NAME=A.FACTORY_NAME
                            ,CAPA_LINE_LINE_NAME=A.LINE_NAME
                            ,CAPA_LINE_VALID_YN=A.VALID_YN
                            ,CAPA_LINE_ATTRIBUTE1=A.ATTRIBUTE1
                            ,CAPA_LINE_ATTRIBUTE2=A.ATTRIBUTE2
                            ,CAPA_LINE_ATTRIBUTE3=A.ATTRIBUTE3
                            ,CAPA_LINE_ATTRIBUTE4=A.ATTRIBUTE4
                            ,CAPA_LINE_ATTRIBUTE5=A.ATTRIBUTE5
                            ,CAPA_LINE_ATTRIBUTE6=A.ATTRIBUTE6
                            ,CAPA_LINE_ATTRIBUTE7=A.ATTRIBUTE7
                            ,CAPA_LINE_ATTRIBUTE8=A.ATTRIBUTE8
                            ,CAPA_LINE_ATTRIBUTE9=A.ATTRIBUTE9
                            ,CAPA_LINE_ATTRIBUTE10=A.ATTRIBUTE10
                            ,CAPA_LINE_CREATED_BY=A.CREATED_BY
                            ,CAPA_LINE_CREATION_DATE=A.CREATION_DATE
                            ,CAPA_LINE_LAST_UPDATED_BY=A.LAST_UPDATED_BY
                            ,CAPA_LINE_LAST_UPDATE_DATE=A.LAST_UPDATE_DATE
                            ,CAPA_LINE_COMPANY_NAME=A.COMPANY_NAME
                            ,X2='---CONV_SCP_DATA---->'
                            ,CONV_SCP_DATA_OLD_VALUE1=B.OLD_VALUE1
                            ,CONV_SCP_DATA_OLD_VALUE2=B.OLD_VALUE2
                            ,CONV_SCP_DATA_OLD_VALUE3=B.OLD_VALUE3
                            ,CONV_SCP_DATA_OLD_VALUE4=B.OLD_VALUE4
                            ,CONV_SCP_DATA_OLD_VALUE5=B.OLD_VALUE5
                            ,CONV_SCP_DATA_OLD_VALUE6=B.OLD_VALUE6
                            ,CONV_SCP_DATA_OLD_VALUE7=B.OLD_VALUE7
                            ,CONV_SCP_DATA_NEW_VALUE1=B.NEW_VALUE1
                            ,CONV_SCP_DATA_NEW_VALUE2=B.NEW_VALUE2
                            ,CONV_SCP_DATA_NEW_VALUE9=B.NEW_VALUE9
                            ,CONV_SCP_DATA_NEW_VALUE10=B.NEW_VALUE10
                     INTO  dbo.SCP_MST_CAPA_LINE_DUP
                     FROM .SCP_MST_CAPA_LINE AS A WITH(NOLOCK),
                    (SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                           ,NEW_VALUE1, NEW_VALUE2
                           ,NEW_VALUE9, NEW_VALUE10
                       from NERP_CONV_SCP_DATA WITH(NOLOCK)
                      where table_name = 'SCP_MST_CAPA_LINE'
                      and NEW_VALUE10 = 'Y'
                      and NEW_VALUE9 = 'SAVE'
                      ) AS B
                    WHERE   A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7
                    ;

                    --2025-03-12 중복발생예정인 RNUM이 1보다 큰 것 삭제
                    DELETE A
                     FROM  SCP_MST_CAPA_LINE AS A WITH(NOLOCK)
                     JOIN  SCP_MST_CAPA_LINE_DUP AS B WITH(NOLOCK)
                      ON   1=1
                      AND   A.DIVISION_ID   = B.CONV_SCP_DATA_OLD_VALUE1
                      AND   A.COMPANY_ID    = B.CONV_SCP_DATA_OLD_VALUE2
                      AND   A.SITE_ID       = B.CONV_SCP_DATA_OLD_VALUE3
                      AND   A.PLANT_ID      = B.CONV_SCP_DATA_OLD_VALUE4
                      AND   A.FACTORY_ID    = B.CONV_SCP_DATA_OLD_VALUE5
                      AND   A.LINE_ID       = B.CONV_SCP_DATA_OLD_VALUE6
                      AND   A.OPERATION_ID  = B.CONV_SCP_DATA_OLD_VALUE7
                    WHERE   B.KEY_RNUM > 1;


                    UPDATE SCP_MST_CAPA_LINE
                       SET SCP_MST_CAPA_LINE.COMPANY_ID = ISNULL(B.NEW_VALUE1, COMPANY_ID)
                          ,SCP_MST_CAPA_LINE.PLANT_ID   = ISNULL(B.NEW_VALUE2, PLANT_ID)
                          ,SCP_MST_CAPA_LINE.LAST_UPDATED_BY = @CREATED_BY
                          ,SCP_MST_CAPA_LINE.LAST_UPDATE_DATE = GETDATE()
                     FROM .SCP_MST_CAPA_LINE AS A,
                    (SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                           ,NEW_VALUE1, NEW_VALUE2
                           ,NEW_VALUE9, NEW_VALUE10
                       from NERP_CONV_SCP_DATA
                      where table_name = 'SCP_MST_CAPA_LINE'
                      and NEW_VALUE10 = 'Y'
                      and NEW_VALUE9 = 'SAVE'
                      ) AS B
                    WHERE   A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7



                    DELETE SCP_MST_CAPA_LINE
                      FROM SCP_MST_CAPA_LINE a
                      JOIN (
                              SELECT OLD_VALUE1, OLD_VALUE2,OLD_VALUE3, OLD_VALUE4,OLD_VALUE5, OLD_VALUE6,OLD_VALUE7
                                   ,NEW_VALUE1, NEW_VALUE2
                                   ,NEW_VALUE9, NEW_VALUE10
                               from NERP_CONV_SCP_DATA
                              where table_name = 'SCP_MST_CAPA_LINE'
                              and NEW_VALUE10 = 'Y'
                              and NEW_VALUE9 = 'DELETE'
                           )  b
                        on  A.DIVISION_ID               = B.OLD_VALUE1
                      AND   A.COMPANY_ID                = B.OLD_VALUE2
                      AND   A.SITE_ID                   = B.OLD_VALUE3
                      AND   A.PLANT_ID                  = B.OLD_VALUE4
                      AND   A.FACTORY_ID                = B.OLD_VALUE5
                      AND   A.LINE_ID                   = B.OLD_VALUE6
                      AND   A.OPERATION_ID              = B.OLD_VALUE7


                      SET @MAPPING_RESULT = 'Y';
                END

                /*
                OPERATION_ID        VENDOR_ID
                PLANT_ID            PLANT_ID
                SCM_SITE_ID         SCM_SITE_ID
                -- KEY로 GROUP BY, SUM(QTY), 나머지는 MAX

                - PK PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, PLANT_ID, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, REASON_CD
                */
                -- 741320
                ELSE IF @TABLE_NAME = 'SCM_LGTM_INV_PSI_DETAIL_RMTL'
                BEGIN
                        --select * from #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN_CONV
                        --drop table #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL
                        --drop table #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL_CONV

                        --###############################################################################################################
                        SELECT LIST.*
                        INTO #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL
                        FROM
                        (
                                SELECT PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, PLANT_ID, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, REASON_CD
                                     , B.NEW_VALUE1 AS PLANT_TOBE
                                     , CASE WHEN C.NEW_VALUE1 in ('HQ06') THEN 1
                                            WHEN C.NEW_VALUE1 in ('HQ07') THEN 2
                                            WHEN C.NEW_VALUE1 in ('HQ10') THEN 3
                                            WHEN C.NEW_VALUE1 in ('WA00') THEN 4
                                            ELSE NULL
                                            END AS PLANT_DUP
                                     , rank() over (partition by PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, REASON_CD, B.NEW_VALUE1 order by PLANT_ID) as rno
                                     , QTY
                                     , DECREASE_QTY
                                     , REMAIN_QTY
                                FROM SCM_LGTM_INV_PSI_DETAIL_RMTL A
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) B ON A.PLANT_ID = B.OLD_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM #TMP_PLANT_DUP_DETAIL) C ON A.PLANT_ID = C.OLD_VALUE1
                        ) LIST
                        where ISNULL(PLANT_DUP,'') != ''


                        --###############################################################################################################
                        -- 408
                        ;with list as
                        (
                            select *
                            from #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL
                            where rno > 1
                        )
                        select A.*
                             , B.QTY AS QTY_DUP
                             , B.DECREASE_QTY AS DECREASE_QTY_DUP
                             , B.REMAIN_QTY as REMAIN_QTY_DUP
                        INTO #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL_CONV
                        from #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL A
                        INNER JOIN list B
                             ON A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            --AND A.PLANT_ID     = B.PLANT_ID
                            AND A.GROUP_CODE1 = B.GROUP_CODE1
                            AND A.ITEM_ID = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            AND A.REASON_CD = B.REASON_CD
                            AND A.PLANT_TOBE = B.PLANT_TOBE



                        --###############################################################################################################
                        /*
                        -- total 741320
                        -- mapping 대상 432911 -> 985
                        -- SELECT 432911 - 204 - 204 = 432503
                        -- 총 1초
                        SELECT count(*)
                         FROM SCM_LGTM_INV_PSI_DETAIL_RMTL A
                         inner join (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) AS B
                         on  A.PLANT_ID = B.OLD_VALUE1

                        SELECT count(*)
                         FROM SCM_LGTM_INV_PSI_DETAIL_RMTL A
                         inner join (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) AS B
                         on  A.PLANT_ID = B.OLD_VALUE1

                        */


                        DELETE SCM_LGTM_INV_PSI_DETAIL_RMTL
                          FROM SCM_LGTM_INV_PSI_DETAIL_RMTL A
                          JOIN #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL_CONV B
                            on A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.PLANT_ID     = B.PLANT_ID
                            AND A.GROUP_CODE1 = B.GROUP_CODE1
                            AND A.ITEM_ID = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            AND A.REASON_CD = B.REASON_CD
                            AND A.PLANT_ID    = B.PLANT_ID
                            AND B.rno > 1


                        --###############################################################################################################

                        UPDATE SCM_LGTM_INV_PSI_DETAIL_RMTL
                           SET SCM_LGTM_INV_PSI_DETAIL_RMTL.PLANT_ID        = B.PLANT_TOBE
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.QTY             = B.QTY + B.QTY_DUP
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.DECREASE_QTY    = B.DECREASE_QTY + B.DECREASE_QTY_DUP
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.REMAIN_QTY      = B.REMAIN_QTY + B.REMAIN_QTY_DUP
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.LAST_UPDATED_BY = @CREATED_BY
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.LAST_UPDATE_DATE = GETDATE()
                         FROM .SCM_LGTM_INV_PSI_DETAIL_RMTL AS A,
                        (SELECT PLAN_TP_CD
                              , PLAN_START_YYYYMMDD
                              , DATA_TP_CD
                              , SRCE_TP_CD
                              , DIVISION_ID
                              , PLANT_ID
                              , GROUP_CODE1
                              , ITEM_ID
                              , ORIGIN_ITEM_ID
                              , SRCE_YYYYMM
                              , PLAN_YYYYMM
                              , REASON_CD
                              , PLANT_TOBE
                              , ISNULL(QTY,0) AS QTY
                              , ISNULL(DECREASE_QTY,0) AS DECREASE_QTY
                              , ISNULL(REMAIN_QTY,0) AS REMAIN_QTY
                              , ISNULL(QTY_DUP,0) AS QTY_DUP
                              , ISNULL(DECREASE_QTY_DUP,0) AS DECREASE_QTY_DUP
                              , ISNULL(REMAIN_QTY_DUP,0) AS REMAIN_QTY_DUP
                          FROM #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL_CONV
                          ) AS B
                         WHERE  A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.PLANT_ID     = B.PLANT_ID
                            AND A.GROUP_CODE1 = B.GROUP_CODE1
                            AND A.ITEM_ID = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            AND A.REASON_CD = B.REASON_CD


                        --###############################################################################################################
                        UPDATE SCM_LGTM_INV_PSI_DETAIL_RMTL
                           SET SCM_LGTM_INV_PSI_DETAIL_RMTL.PLANT_ID    = B.NEW_VALUE1
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.LAST_UPDATED_BY = @CREATED_BY
                              ,SCM_LGTM_INV_PSI_DETAIL_RMTL.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCM_LGTM_INV_PSI_DETAIL_RMTL AS A,
                        (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) AS B
                         WHERE  A.PLANT_ID  = B.OLD_VALUE1








                    /* 검증

                         select *
                         from SCM_LGTM_INV_PSI_DETAIL_RMTL
                         where PLAN_START_YYYYMMDD = '20240902'
                         and ITEM_ID = 'ERCA00067AA'
                         and PLAN_YYYYMM = '202412'
                         and SRCE_YYYYMM = '202407'
                    */

                SET @MAPPING_RESULT = 'Y';
                END


                /*
                PK = PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, PLANT_ID, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM
                ----------------------------------------------
                OPERATION_ID        VENDOR_ID
                PLANT_ID            PLANT_ID
                SCM_SITE_ID         SCM_SITE_ID
                -- KEY로 GROUP BY, SUM(QTY), 가중평균단가, SUM(AMT), 나머지는 MAX
                QTY
                STANDARD_COST
                AMT
                */
                -- 2041897
                ELSE IF @TABLE_NAME = 'SCM_LGTM_INV_PSI_SUMMARY_RMTL'
                BEGIN

                        --select top 10 * from SCM_LGTM_INV_PSI_SUMMARY_RMTL where OPERATION_ID is not null
                        --select top 10 * from SCM_LGTM_INV_PSI_SUMMARY_RMTL where SCM_SITE_ID is not null
                        --drop table #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL
                        --drop table #TMP_SCM_LGTM_INV_PSI_DETAIL_RMTL_CONV
                        --sp_help SCM_LGTM_INV_PSI_SUMMARY_RMTL



                        --###############################################################################################################
                        -- 17초 1036231
                        SELECT LIST.*
                        INTO #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL
                        FROM
                        (
                                SELECT PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, PLANT_ID, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, COMPANY_ID
                                     , B.NEW_VALUE1 AS PLANT_TOBE
                                     , C.NEW_VALUE1 AS OPERATION_ID_TOBE
                                     , D.NEW_VALUE1 AS SCM_SITE_ID_TOBE
                                     , CASE WHEN E.NEW_VALUE1 in ('HQ06') THEN 1
                                            WHEN E.NEW_VALUE1 in ('HQ07') THEN 2
                                            WHEN E.NEW_VALUE1 in ('HQ10') THEN 3
                                            WHEN E.NEW_VALUE1 in ('WA00') THEN 4
                                            -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL 테이블 1차만 되도록 코딩되어 있어서 모든 차수에 되도록 변경
                                            WHEN ISNULL(E.NEW_VALUE1,'') <> '' THEN 5
                                            ELSE NULL
                                            END AS PLANT_DUP
                                     , ISNULL(F.NEW_VALUE1,A.COMPANY_ID) AS COMPANY_ID_TOBE
                                     , rank() over (partition by PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, B.NEW_VALUE1, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM  order by PLANT_ID) as rno
                                     , QTY
                                     , STANDARD_COST
                                     , AMT
                                FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL A
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) B ON A.PLANT_ID     = B.OLD_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = @P_ROLLIN) C ON A.OPERATION_ID = C.OLD_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.SCM_SITE_ID  = D.OLD_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM #TMP_PLANT_DUP_DETAIL) E ON A.PLANT_ID = E.OLD_VALUE1
                                -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) F ON A.COMPANY_ID  = F.OLD_VALUE1
                        ) LIST
                        where ISNULL(PLANT_DUP,'') != ''

            --###############################################################################################################

                        --2400 2초
                        ;with list as
                        (
                        -- 1036231
                            select *
                            from #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL
                            where rno > 1
                        )
                        select A.*
                             , B.QTY AS DUP_QTY
                             , B.STANDARD_COST AS DUP_STANDARD_COST
                             , B.AMT as DUP_AMT
                        INTO #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_CONV
                        from #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL A
                        INNER JOIN list B
                             ON A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            --AND A.PLANT_ID     = B.PLANT_ID
                            AND A.PLANT_TOBE = B.PLANT_TOBE
                            AND A.GROUP_CODE1 = B.GROUP_CODE1
                            AND A.ITEM_ID = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                            AND A.COMPANY_ID = B.COMPANY_ID








    --###############################################################################################################

                        -- 1200 삭제 A041

                        DELETE SCM_LGTM_INV_PSI_SUMMARY_RMTL
                          FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL A
                          JOIN #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_CONV B
                             on A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.PLANT_ID     = B.PLANT_ID
                            AND A.GROUP_CODE1 = B.GROUP_CODE1
                            AND A.ITEM_ID = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                            AND A.COMPANY_ID = B.COMPANY_ID
                            AND B.rno > 1





        --###############################################################################################################


                        UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
                           SET SCM_LGTM_INV_PSI_SUMMARY_RMTL.PLANT_ID           = ISNULL(B.PLANT_TOBE         ,A.PLANT_ID       )
                             , SCM_LGTM_INV_PSI_SUMMARY_RMTL.OPERATION_ID       = ISNULL(B.OPERATION_ID_TOBE  ,A.OPERATION_ID   )
                             , SCM_LGTM_INV_PSI_SUMMARY_RMTL.SCM_SITE_ID        = ISNULL(B.SCM_SITE_ID_TOBE   ,A.SCM_SITE_ID    )
                             -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                             , SCM_LGTM_INV_PSI_SUMMARY_RMTL.COMPANY_ID         = ISNULL(B.COMPANY_ID         ,A.COMPANY_ID    )
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.QTY                = B.QTY
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.STANDARD_COST      = B.STANDARD_COST
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.AMT                = B.AMT
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.LAST_UPDATED_BY    = @CREATED_BY
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.LAST_UPDATE_DATE   = GETDATE()
                         FROM .SCM_LGTM_INV_PSI_SUMMARY_RMTL AS A,
                        (SELECT PLAN_TP_CD
                              , PLAN_START_YYYYMMDD
                              , DATA_TP_CD
                              , SRCE_TP_CD
                              , DIVISION_ID
                              , MIN(PLANT_ID) AS PLANT_ID
                              , GROUP_CODE1
                              , ITEM_ID
                              , ORIGIN_ITEM_ID
                              , SRCE_YYYYMM
                              , PLAN_YYYYMM
                              -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                              , COMPANY_ID
                              , SUM(ISNULL(QTY,0)) AS QTY
                              , CASE WHEN sum(QTY) != 0
                                     THEN sum(QTY * STANDARD_COST)  / sum(QTY)
                                     ELSE 0
                                     END AS  STANDARD_COST

                              , sum(QTY * STANDARD_COST) AS  AMT
                              , MAX(PLANT_TOBE) AS PLANT_TOBE
                              , MAX(OPERATION_ID_TOBE) AS OPERATION_ID_TOBE
                              , MAX(SCM_SITE_ID_TOBE) AS SCM_SITE_ID_TOBE
                          FROM #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_CONV
                          group by PLAN_TP_CD
                              , PLAN_TP_CD
                              , PLAN_START_YYYYMMDD
                              , DATA_TP_CD
                              , SRCE_TP_CD
                              , DIVISION_ID
                              , PLANT_TOBE
                              , GROUP_CODE1
                              , ITEM_ID
                              , ORIGIN_ITEM_ID
                              , SRCE_YYYYMM
                              , PLAN_YYYYMM
                              -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                              , COMPANY_ID
                          ) AS B
                         WHERE  A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.PLANT_ID     = B.PLANT_ID
                            AND A.GROUP_CODE1 = B.GROUP_CODE1
                            AND A.ITEM_ID = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                            AND A.COMPANY_ID = B.COMPANY_ID

                        ----------------------------------------------------------------------------------------------------------------------------
                            drop table  #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL
                            drop table  #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_CONV

                            DROP TABLE IF EXISTS #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_UPDATE;

                            -- 2038941 -> 1197168
                            SELECT *
                            INTO #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_UPDATE
                            FROM
                            (

                               SELECT PLAN_TP_CD, PLAN_START_YYYYMMDD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, PLANT_ID, GROUP_CODE1, ITEM_ID, ORIGIN_ITEM_ID, SRCE_YYYYMM, PLAN_YYYYMM, COMPANY_ID
                                    , B.NEW_VALUE1 AS PLANT_TOBE
                                    , C.NEW_VALUE1 AS OPERATION_ID_TOBE
                                    , D.NEW_VALUE1 AS SCM_SITE_ID_TOBE
                                  ,  case when isnull(B.NEW_VALUE1,'') != ''            then 'Y'
                                          when isnull(C.NEW_VALUE1,'') != ''    then 'Y'
                                          when isnull(D.NEW_VALUE1,'') != ''    then 'Y'
                                          when isnull(F.NEW_VALUE1,'') != ''    then 'Y'
                                          else 'N'
                                          end as change_yn
                            FROM SCM_LGTM_INV_PSI_SUMMARY_RMTL A
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) B ON A.PLANT_ID     = B.OLD_VALUE1
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = @P_ROLLIN) C ON A.OPERATION_ID = C.OLD_VALUE1
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.SCM_SITE_ID  = D.OLD_VALUE1
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM #TMP_PLANT_DUP_DETAIL) E ON A.PLANT_ID = E.OLD_VALUE1
                            -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) F ON A.COMPANY_ID  = F.OLD_VALUE1
                            ) list
                            where change_yn = 'Y'





                        UPDATE SCM_LGTM_INV_PSI_SUMMARY_RMTL
                           SET SCM_LGTM_INV_PSI_SUMMARY_RMTL.PLANT_ID           = ISNULL(B.PLANT_TOBE         ,A.PLANT_ID       )
                             , SCM_LGTM_INV_PSI_SUMMARY_RMTL.OPERATION_ID       = ISNULL(B.OPERATION_ID_TOBE  ,A.OPERATION_ID   )
                             , SCM_LGTM_INV_PSI_SUMMARY_RMTL.SCM_SITE_ID        = ISNULL(B.SCM_SITE_ID_TOBE   ,A.SCM_SITE_ID    )
                             -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                             , SCM_LGTM_INV_PSI_SUMMARY_RMTL.COMPANY_ID         = ISNULL(B.COMPANY_ID         ,A.COMPANY_ID    )
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.LAST_UPDATED_BY    = @CREATED_BY
                              ,SCM_LGTM_INV_PSI_SUMMARY_RMTL.LAST_UPDATE_DATE   = GETDATE()
                         FROM .SCM_LGTM_INV_PSI_SUMMARY_RMTL AS A,
                        (SELECT *
                          FROM #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_UPDATE
                          ) AS B
                         WHERE  A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.DATA_TP_CD        = B.DATA_TP_CD
                            AND A.SRCE_TP_CD        = B.SRCE_TP_CD
                            AND A.DIVISION_ID       = B.DIVISION_ID
                            AND A.PLANT_ID          = B.PLANT_ID
                            AND A.GROUP_CODE1       = B.GROUP_CODE1
                            AND A.ITEM_ID           = B.ITEM_ID
                            AND A.ORIGIN_ITEM_ID    = B.ORIGIN_ITEM_ID
                            AND A.SRCE_YYYYMM       = B.SRCE_YYYYMM
                            AND A.PLAN_YYYYMM       = B.PLAN_YYYYMM
                            -- 2025-10-30 김준규 NERP) SCM_LGTM_INV_PSI_SUMMARY_RMTL PK컬럼 COMPANY_ID 추가
                            AND A.COMPANY_ID = B.COMPANY_ID






                            drop table #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_UPDATE

                            /*
                            --select count(*) from SCM_LGTM_INV_PSI_SUMMARY_RMTL where plant_id in  (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)
                            --select count(*) from SCM_LGTM_INV_PSI_SUMMARY_RMTL where OPERATION_ID in  (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = @P_ROLLIN)
                            --select count(*) from SCM_LGTM_INV_PSI_SUMMARY_RMTL where SCM_SITE_ID in  (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN)


                        select *
                        from SCM_LGTM_INV_PSI_SUMMARY_RMTL
                        where item_id = 'EMFL00017AA'
                        and PLAN_START_YYYYMMDD = '20240902'
                        and PLAN_YYYYMM = '202401'
                        and SRCE_YYYYMM = '202312'
                        order by plant_id


                            select * from #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL
                            select * from #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_CONV

                            drop table #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL
                            drop table #TMP_SCM_LGTM_INV_PSI_SUMMARY_RMTL_CONV
                            -- 11초
                            --select * into SCM_LGTM_INV_PSI_SUMMARY_RMTL_20241220 from SCM_LGTM_INV_PSI_SUMMARY_RMTL
                            */



                SET @MAPPING_RESULT = 'Y';
                END

                /*
                PLANT_ID    PLANT_ID
                -- KEY로 GROUP BY , SUM(qTY) 나머지는 MAX
                -- PK PLAN_START_YYYYMMDD, PLAN_TP_CD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, PLANT_ID, ITEM_ID, PLAN_YYYYMM
                */
                -- 4934
                ELSE IF @TABLE_NAME = 'SCP_ANL_LGTM_INV_MGMT_PLAN'
                BEGIN
                        --select * from #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN_CONV
                        --drop table #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN
                        --drop table #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN_CONV

                        --###############################################################################################################
                        SELECT LIST.*
                        INTO #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN
                        FROM
                        (
                                SELECT PLAN_START_YYYYMMDD, PLAN_TP_CD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID,PLANT_ID, ITEM_ID, PLAN_YYYYMM, COMPANY_ID
                                     , ISNULL(B.NEW_VALUE1,A.PLANT_ID) AS PLANT_TOBE
                                     , ISNULL(D.NEW_VALUE1,A.COMPANY_ID) AS COMPANY_TOBE
                                     --, CASE WHEN C.NEW_VALUE1 in ('HQ06') THEN 1
                                     --       WHEN C.NEW_VALUE1 in ('HQ07') THEN 2
                                     --       WHEN C.NEW_VALUE1 in ('HQ10') THEN 3
                                     --       WHEN C.NEW_VALUE1 in ('WA00') THEN 4
                                     --       ELSE NULL
                                     --       END AS PLANT_DUP
                                     , C.RNUM AS PLANT_DUP
                                     , rank() over (partition by PLAN_START_YYYYMMDD, PLAN_TP_CD, DATA_TP_CD, SRCE_TP_CD, DIVISION_ID, B.NEW_VALUE1, ITEM_ID, PLAN_YYYYMM, D.NEW_VALUE1 order by PLANT_ID) as rno
                                     , QTY
                                FROM SCP_ANL_LGTM_INV_MGMT_PLAN A
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) B ON A.PLANT_ID = B.OLD_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1, RNUM FROM #TMP_PLANT_DUP_DETAIL) C ON A.PLANT_ID = C.OLD_VALUE1
                                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) D ON A.COMPANY_ID = D.OLD_VALUE1
                        ) LIST
                        where ISNULL(PLANT_DUP,'') != '' OR COMPANY_TOBE IS NOT NULL

                        --###############################################################################################################
                        ;with list as
                        (
                            select *
                            from #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN
                            where rno > 1
                        )
                        select A.*, B.QTY AS QTY_DUP
                        INTO #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN_CONV
                        from #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN A
                        INNER JOIN list B
                             ON A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.ITEM_ID     = B.ITEM_ID
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            AND A.PLANT_TOBE  = B.PLANT_TOBE
                            AND A.COMPANY_TOBE = B.COMPANY_TOBE




                        --###############################################################################################################
                        /*
                        -- total 4934
                        -- mapping 대상 995 -> 985
                        -- SELECT 10 + 975
                        -- 총 1초
                        SELECT *
                         FROM .SCP_ANL_LGTM_INV_MGMT_PLAN AS A,
                        (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) AS B
                         WHERE  A.PLANT_ID  = B.OLD_VALUE1
                        */


                        DELETE SCP_ANL_LGTM_INV_MGMT_PLAN
                          FROM SCP_ANL_LGTM_INV_MGMT_PLAN A
                          JOIN #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN_CONV B
                             on A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.ITEM_ID     = B.ITEM_ID
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            AND A.PLANT_ID    = B.PLANT_ID
                            AND A.COMPANY_ID  = B.COMPANY_ID
                            AND B.rno > 1

                        --###############################################################################################################

                        UPDATE SCP_ANL_LGTM_INV_MGMT_PLAN
                           SET SCP_ANL_LGTM_INV_MGMT_PLAN.PLANT_ID  = B.PLANT_TOBE
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.COMPANY_ID  = B.COMPANY_TOBE
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.QTY   = B.QTY + B.QTY_DUP
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.LAST_UPDATED_BY  = @CREATED_BY
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCP_ANL_LGTM_INV_MGMT_PLAN AS A,
                        (SELECT PLAN_START_YYYYMMDD
                              , PLAN_TP_CD
                              , DATA_TP_CD
                              , SRCE_TP_CD
                              , DIVISION_ID
                              , PLANT_ID
                              , ITEM_ID
                              , PLAN_YYYYMM
                              , COMPANY_ID
                              , PLANT_TOBE
                              , COMPANY_TOBE
                              , ISNULL(QTY,0) AS QTY
                              , ISNULL(QTY_DUP,0) AS QTY_DUP
                          FROM #TMP_SCP_ANL_LGTM_INV_MGMT_PLAN_CONV
                          ) AS B
                         WHERE  A.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD
                            AND A.PLAN_TP_CD = B.PLAN_TP_CD
                            AND A.DATA_TP_CD = B.DATA_TP_CD
                            AND A.SRCE_TP_CD = B.SRCE_TP_CD
                            AND A.DIVISION_ID = B.DIVISION_ID
                            AND A.ITEM_ID     = B.ITEM_ID
                            AND A.PLAN_YYYYMM = B.PLAN_YYYYMM
                            AND A.PLANT_ID    = B.PLANT_ID
                            AND A.COMPANY_ID  = B.COMPANY_ID


                        --###############################################################################################################
                        UPDATE SCP_ANL_LGTM_INV_MGMT_PLAN
                           SET SCP_ANL_LGTM_INV_MGMT_PLAN.PLANT_ID  = B.NEW_VALUE1
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.LAST_UPDATED_BY  = @CREATED_BY
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCP_ANL_LGTM_INV_MGMT_PLAN AS A,
                        (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) AS B
                         WHERE  A.PLANT_ID  = B.OLD_VALUE1;
                        --2025-06-07 COMPANY_ID UPDATE 보완
                        UPDATE SCP_ANL_LGTM_INV_MGMT_PLAN
                           SET SCP_ANL_LGTM_INV_MGMT_PLAN.COMPANY_ID  = B.NEW_VALUE1
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.LAST_UPDATED_BY  = @CREATED_BY
                              ,SCP_ANL_LGTM_INV_MGMT_PLAN.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCP_ANL_LGTM_INV_MGMT_PLAN AS A,
                        (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @P_ROLLIN) AS B
                         WHERE  A.COMPANY_ID  = B.OLD_VALUE1;


                    /* 검증
                        SELECT *
                         FROM .SCP_ANL_LGTM_INV_MGMT_PLAN
                        where item_id = 'ERCA00068AA'
                        and PLAN_YYYYMM = '202412'
                        and plant_id = 'HQ07'
                        and PLAN_START_YYYYMMDD = '20241104'
                    */


                SET @MAPPING_RESULT = 'Y';
                END

                /*

                ---------------------------------------------------------
                -- PK = plant_id in ('A011','A041','F031','G482') 없음
                -- PK = STORAGE 가 중복 되면서 조치 필요
                ---------------------------------------------------------
                PK + BASE_YYYYMM, DIVISION_ID, ITEM_ID, PLANT_ID, STORAGE
                ---------------------------------------------------------
                PLANT_ID            PLANT_ID
                STORAGE             STORAGE_ID
                APPRAISAL_CLASS     STORAGE_ID
                ---------------------------------------------------------
                ,AVAILABLE_QTY
                ,HOLD_QTY
                ,TRANSPORT_QTY
                ,TOTAL_QTY
                ,INSPECT_QTY
                ,HOLD_RETURN_QTY


                */
                ELSE IF @TABLE_NAME = 'SCM_DNM_MONTH_CLOSE_INVENTORY'
                BEGIN
                PRINT @TABLE_NAME


                --######################################################################
                -- Total 30086
                --######################################################################
                SELECT  BASE_YYYYMM, DIVISION_ID, ITEM_ID, PLANT_ID, STORAGE, APPRAISAL_CLASS
                       , CASE WHEN ISNULL(TOBE_PLANT_ID,'')  != '' then TOBE_PLANT_ID
                              WHEN ISNULL(TOBE_PLANT_ID_ST,'')  != '' then TOBE_PLANT_ID_ST
                              when ISNULL(TOBE_PLANT_ID,TOBE_PLANT_ID_ST) != '' THEN ISNULL(TOBE_PLANT_ID,TOBE_PLANT_ID_ST)
                              else PLANT_ID
                              end AS TOBE_PLANT_ID


                       , CASE WHEN TOBE_STORAGE is null then STORAGE
                              WHEN TOBE_STORAGE = '' then STORAGE
                              WHEN TOBE_STORAGE = ' ' then STORAGE
                              else TOBE_STORAGE
                              end AS TOBE_STORAGE
                       , CASE WHEN TOBE_APPRAISAL_CLASS is null then STORAGE
                              WHEN TOBE_APPRAISAL_CLASS = '' then STORAGE
                              WHEN TOBE_APPRAISAL_CLASS = ' ' then STORAGE
                              else TOBE_APPRAISAL_CLASS
                              end AS TOBE_APPRAISAL_CLASS
                 , CASE WHEN ISNULL(TOBE_PLANT_ID,'')        != '' THEN 'Y'
                        WHEN ISNULL(TOBE_PLANT_ID_ST,'' )    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_STORAGE,'')         != '' THEN 'Y'
                        WHEN ISNULL(TOBE_APPRAISAL_CLASS,'') != '' THEN 'Y'
                        ELSE 'N'
                        END CHANGE_YN
                INTO #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY
                FROM
                (
                SELECT BASE_YYYYMM, DIVISION_ID, ITEM_ID, PLANT_ID, STORAGE, APPRAISAL_CLASS

                       , C.NEW_VALUE1 AS TOBE_PLANT_ID
                       , D.NEW_VALUE1 AS TOBE_PLANT_ID_ST
                       , D.NEW_VALUE2 AS TOBE_STORAGE
                       , D.NEW_VALUE1 AS TOBE_PLANT_ID_AP
                       , D.NEW_VALUE2 AS TOBE_APPRAISAL_CLASS

                FROM SCM_DNM_MONTH_CLOSE_INVENTORY A with (nolock)
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) C ON A.PLANT_ID = C.OLD_VALUE1
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1,OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN) D
                           ON A.PLANT_ID    = D.OLD_VALUE1
                           AND A.STORAGE = D.OLD_VALUE2
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1,OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN) E
                           ON A.PLANT_ID    = D.OLD_VALUE1
                           AND A.APPRAISAL_CLASS = D.OLD_VALUE2
                ) LIST


                --######################################################################
                -- 중복 491
                --######################################################################
                -- 481
                SELECT *
                INTO #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP
                FROM
                (
                SELECT BASE_YYYYMM, DIVISION_ID, ITEM_ID, PLANT_ID, STORAGE, APPRAISAL_CLASS
                       ,TOBE_PLANT_ID
                       ,TOBE_STORAGE
                       ,TOBE_APPRAISAL_CLASS
                       ,CHANGE_YN
                       , rank() over ( partition by  BASE_YYYYMM, DIVISION_ID, ITEM_ID, ISNULL(TOBE_PLANT_ID, PLANT_ID), ISNULL(TOBE_STORAGE, STORAGE)
                                       order by PLANT_ID, STORAGE
                                       ) as rno
                FROM #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY
                ) LIST
                WHERE RNO > 1




                --######################################################################
                -- 중복 제외 대상 리시트
                --######################################################################
                -- 29605
                SELECT *
                INTO #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_NODUP
                FROM
                (
                SELECT BASE_YYYYMM, DIVISION_ID, ITEM_ID, PLANT_ID, STORAGE, APPRAISAL_CLASS
                       ,TOBE_PLANT_ID
                       ,TOBE_STORAGE
                       ,TOBE_APPRAISAL_CLASS
                       ,CHANGE_YN
                       , rank() over ( partition by  BASE_YYYYMM, DIVISION_ID, ITEM_ID, ISNULL(TOBE_PLANT_ID, PLANT_ID), ISNULL(TOBE_STORAGE, STORAGE)
                                       order by PLANT_ID, STORAGE
                                       ) as rno
                FROM #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY
                ) LIST
                WHERE RNO = 1



                --######################################################################
                -- 중복 작업 대상 962 -- 체크
                --######################################################################
                /*
                SELECT A.BASE_YYYYMM, A.DIVISION_ID, A.ITEM_ID
                    , A.TOBE_PLANT_ID,A.PLANT_ID
                    , A.TOBE_STORAGE AS TOBE_STORAGE
                    , A.STORAGE
                FROM #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY A
                INNER JOIN #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP B
                on A.BASE_YYYYMM        = B.BASE_YYYYMM
                and A.DIVISION_ID       = B.DIVISION_ID
                and A.ITEM_ID           = B.ITEM_ID
                and A.TOBE_PLANT_ID     = B.TOBE_PLANT_ID
                and A.TOBE_STORAGE      = B.TOBE_STORAGE
                order by
                      A.BASE_YYYYMM
                    , A.DIVISION_ID
                    , A.ITEM_ID
                    , A.TOBE_PLANT_ID
                    , A.PLANT_ID
                    , A.TOBE_STORAGE
                    , A.STORAGE
                */



                --######################################################################
                -- 업데이트 중복 있는 대상
                --######################################################################

                SELECT A.BASE_YYYYMM, A.DIVISION_ID, A.ITEM_ID, A.STORAGE, A.APPRAISAL_CLASS
                        , A.TOBE_PLANT_ID,A.PLANT_ID
                        , A.TOBE_STORAGE
                        , A.TOBE_APPRAISAL_CLASS
                INTO #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST
                FROM #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY A
                INNER JOIN #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP B
                on A.BASE_YYYYMM        = B.BASE_YYYYMM
                and A.DIVISION_ID       = B.DIVISION_ID
                and A.ITEM_ID           = B.ITEM_ID
                and A.TOBE_PLANT_ID     = B.TOBE_PLANT_ID
                and A.TOBE_STORAGE      = B.TOBE_STORAGE
                order by
                          A.BASE_YYYYMM
                        , A.DIVISION_ID
                        , A.ITEM_ID
                        , A.TOBE_PLANT_ID
                        , A.PLANT_ID
                        , A.TOBE_STORAGE
                        , A.STORAGE


                --######################################################################
                -- #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST_QTY
                -- 중복 대상 Summary
                --######################################################################
                select BASE_YYYYMM, DIVISION_ID, ITEM_ID, TOBE_PLANT_ID, TOBE_STORAGE
                     , sum(AVAILABLE_QTY)  as AVAILABLE_QTY
                     , sum(HOLD_QTY)  as HOLD_QTY
                     , sum(TRANSPORT_QTY)  as TRANSPORT_QTY
                     , sum(TOTAL_QTY)  as TOTAL_QTY
                     , sum(INSPECT_QTY)  as INSPECT_QTY
                     , sum(HOLD_RETURN_QTY)  as  HOLD_RETURN_QTY
                    into #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST_QTY
                from
                (
                  select A.BASE_YYYYMM, A.DIVISION_ID, A.ITEM_ID, A.PLANT_ID, A.STORAGE
                        ,AVAILABLE_QTY
                        ,HOLD_QTY
                        ,TRANSPORT_QTY
                        ,TOTAL_QTY
                        ,INSPECT_QTY
                        , HOLD_RETURN_QTY
                        , B.TOBE_PLANT_ID
                        , B.TOBE_STORAGE
                        , B.TOBE_APPRAISAL_CLASS
                from SCM_DNM_MONTH_CLOSE_INVENTORY A with (nolock)
                inner join #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST B
                on  A.BASE_YYYYMM       = B.BASE_YYYYMM
                and A.DIVISION_ID       = B.DIVISION_ID
                and A.ITEM_ID           = B.ITEM_ID
                and A.PLANT_ID          = B.PLANT_ID
                and A.STORAGE           = B.STORAGE
                ) list
                group by BASE_YYYYMM, DIVISION_ID, ITEM_ID, TOBE_PLANT_ID, TOBE_STORAGE

                --######################################################################
                -- 업데이트 중복 없는 대상
                --######################################################################

                        UPDATE SCM_DNM_MONTH_CLOSE_INVENTORY
                           SET SCM_DNM_MONTH_CLOSE_INVENTORY.PLANT_ID           = ISNULL(TOBE_PLANT_ID, A.PLANT_ID)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.STORAGE            = ISNULL(TOBE_STORAGE, A.STORAGE)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.APPRAISAL_CLASS    = ISNULL(TOBE_APPRAISAL_CLASS, A.APPRAISAL_CLASS)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.LAST_UPDATED_BY  = @CREATED_BY
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCM_DNM_MONTH_CLOSE_INVENTORY AS A,
                        (
                         --22576
                         SELECT *
                          FROM  #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_NODUP
                         where change_yn = 'Y'


                          ) AS B
                         WHERE  A.BASE_YYYYMM       = B.BASE_YYYYMM
                            AND A.DIVISION_ID       = B.DIVISION_ID
                            AND A.ITEM_ID           = B.ITEM_ID
                            AND A.PLANT_ID          = B.PLANT_ID
                            AND A.STORAGE           = B.STORAGE

                --######################################################################
                -- 업데이트 중복 있는 대상 SUM QTY
                /*
                    AVAILABLE_QTY
                    HOLD_QTY
                    TRANSPORT_QTY
                    TOTAL_QTY
                    INSPECT_QTY
                    HOLD_RETURN_QTY
                */
                --######################################################################

                        -- 481
                        UPDATE SCM_DNM_MONTH_CLOSE_INVENTORY
                           SET SCM_DNM_MONTH_CLOSE_INVENTORY.AVAILABLE_QTY      = ISNULL(B.AVAILABLE_QTY, 0)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.HOLD_QTY           = ISNULL(B.HOLD_QTY, 0)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.TRANSPORT_QTY      = ISNULL(B.TRANSPORT_QTY, 0)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.TOTAL_QTY          = ISNULL(B.TOTAL_QTY, 0)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.INSPECT_QTY        = ISNULL(B.INSPECT_QTY, 0)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.HOLD_RETURN_QTY    = ISNULL(B.HOLD_RETURN_QTY, 0)
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.LAST_UPDATED_BY  = @CREATED_BY
                              ,SCM_DNM_MONTH_CLOSE_INVENTORY.LAST_UPDATE_DATE = GETDATE()
                          FROM .SCM_DNM_MONTH_CLOSE_INVENTORY AS A,
                        (
                         --22576
                         SELECT *
                          FROM  #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST_QTY


                          ) AS B
                         WHERE  A.BASE_YYYYMM       = B.BASE_YYYYMM
                            AND A.DIVISION_ID       = B.DIVISION_ID
                            AND A.ITEM_ID           = B.ITEM_ID
                            AND A.PLANT_ID          = B.TOBE_PLANT_ID
                            AND A.STORAGE           = B.TOBE_STORAGE


                            /* 검증
                            --  select *
                            --from #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST_QTY
                            --where item_id = 'MCCE121501A3-GD' and base_yyyymm='202101' and division_id = '40'
                            --and tobe_storage = '5010'

                            select *
                            from SCM_DNM_MONTH_CLOSE_INVENTORY
                            where item_id = 'MCCE121501A3-GD' and base_yyyymm='202101' and division_id = '40'
                            and storage = '5010'
                            */



                --######################################################################
                -- 중복 데이터 삭제 -- 481
                --######################################################################
                        --begin tran
                        DELETE SCM_DNM_MONTH_CLOSE_INVENTORY
                          FROM SCM_DNM_MONTH_CLOSE_INVENTORY A
                          JOIN #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP B
                             on  A.BASE_YYYYMM      = B.BASE_YYYYMM
                            AND A.DIVISION_ID       = B.DIVISION_ID
                            AND A.ITEM_ID           = B.ITEM_ID
                            AND A.PLANT_ID          = B.PLANT_ID
                            AND A.STORAGE           = B.STORAGE
                            AND B.rno > 1

                            /* 검증
                            select *
                            from SCM_DNM_MONTH_CLOSE_INVENTORY
                            where item_id = 'MCCE121501A3-GD' and base_yyyymm='202101' and division_id = '40'
                            and storage = '5010'
                            */
                            --rollback



                    drop table #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY
                    drop table #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP
                    drop table #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_NODUP
                    drop table #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST
                    drop table #TMP_SCM_DNM_MONTH_CLOSE_INVENTORY_DUP_LIST_QTY

                SET @MAPPING_RESULT = 'Y';
                END


                -- 20241223 Conv 시간 Long
                /*


                COMPANY_ID                  COMPANY_ID
                PLANT_ID                    PLANT_ID
                STORAGE_ID                  STORAGE_ID

                FROM_SCM_SITE_ID            SCM_SITE_ID
                TO_SCM_SITE_ID              SCM_SITE_ID
                SHIPTO_CODE                 COMPANY_ID
                SHIPTO_CODE                 END_CUSTOMER_ID
                SOLDTO_CODE                 COMPANY_ID
                SOLDTO_CODE                 END_CUSTOMER_ID

                INCOTERMS                   INCOTERMS

                */
                ELSE IF @TABLE_NAME = 'SCM_DNM_EXFACTORY_RESULT'
                BEGIN

                --34 752731

                SELECT DISTINCT COMPANY_ID
                       ,DIVISION_ID
                       ,SITE_ID
                       ,PLANT_ID
                       ,STORAGE_ID
                       ,FROM_SCM_SITE_ID
                       ,TO_SCM_SITE_ID
                       ,SHIPTO_CODE
                       ,SOLDTO_CODE
                       ,INCOTERMS

                       ,TOBE_COMPANY_ID
                       ,ISNULL(TOBE_PLANT_ID,TOBE_PLANT_ID_ST) AS TOBE_PLANT_ID
                       ,TOBE_STORAGE_ID
                       ,TOBE_FROM_SCM_SITE_ID
                       ,TOBE_TO_SCM_SITE_ID
                       ,ISNULL(TOBE_SHIPTO_CODE1,TOBE_SHIPTO_CODE2) AS TOBE_SHIPTO_CODE
                       ,ISNULL(TOBE_SOLDTO_CODE1,TOBE_SOLDTO_CODE2) AS TOBE_SOLDTO_CODE
                     --  ,COUNTRY
                    --,  CASE WHEN INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04')  THEN 'DAP'
                    --      WHEN INCOTERMS IN ('A02', 'S32', 'S33')                 THEN 'EXW'
                    --      WHEN INCOTERMS IN ('DAT')                                       THEN 'DPU'
                    --      WHEN COUNTRY = 'KR' AND INCOTERMS IN ('Z01')                    THEN 'EXW'
                    --      WHEN COUNTRY = 'KR' AND INCOTERMS IN ('Z02')                    THEN 'DAP'
                    --      WHEN COUNTRY != 'KR' AND INCOTERMS IN ('Z01')                   THEN 'DAP'
                    --      WHEN COUNTRY != 'KR' AND INCOTERMS IN ('Z02')                   THEN 'EXW'
                    --      WHEN (FROM_SCM_SITE_ID LIKE 'A%' OR FROM_SCM_SITE_ID LIKE 'F%') AND INCOTERMS IN ('Z01') THEN 'EXW'
                    --      WHEN (FROM_SCM_SITE_ID LIKE 'A%' OR FROM_SCM_SITE_ID LIKE 'F%') AND INCOTERMS IN ('Z02') THEN 'DAP'
                    --      WHEN (FROM_SCM_SITE_ID NOT LIKE 'A%' AND FROM_SCM_SITE_ID NOT LIKE 'F%') AND INCOTERMS IN ('Z01') THEN 'DAP'
                    --      WHEN (FROM_SCM_SITE_ID NOT LIKE 'A%' AND FROM_SCM_SITE_ID NOT LIKE 'F%') AND INCOTERMS IN ('Z02') THEN 'EXW'
                        --  WHEN INCOTERMS IN ('Z01') THEN 'DAP'
                    --      WHEN INCOTERMS IN ('Z02') THEN 'EXW'
                    --      ELSE NULL
                    --  END  TOBE_INCOTERMS
                INTO #TMP_SCM_DNM_EXFACTORY_RESULT
                FROM
                (
                 SELECT COMPANY_ID
                       ,DIVISION_ID
                       ,SITE_ID
                       ,PLANT_ID
                       ,STORAGE_ID
                       ,FROM_SCM_SITE_ID
                       ,TO_SCM_SITE_ID
                       ,SHIPTO_CODE
                       ,SOLDTO_CODE
                       ,INCOTERMS

                       , B.NEW_VALUE1 AS TOBE_COMPANY_ID
                       , C.NEW_VALUE1 AS TOBE_PLANT_ID
                       , D.NEW_VALUE1 AS TOBE_PLANT_ID_ST
                       , D.NEW_VALUE2 AS TOBE_STORAGE_ID

                       , S2.NEW_VALUE1 AS TOBE_FROM_SCM_SITE_ID
                       , S3.NEW_VALUE1 AS TOBE_TO_SCM_SITE_ID

                       , S4.NEW_VALUE1 AS TOBE_SHIPTO_CODE1
                       , S5.NEW_VALUE1 AS TOBE_SHIPTO_CODE2

                       , S6.NEW_VALUE1 AS TOBE_SOLDTO_CODE1
                       , S7.NEW_VALUE1 AS TOBE_SOLDTO_CODE2

                       --, IC.COUNTRY
                FROM SCM_DNM_EXFACTORY_RESULT A with (index = PK_SCM_DNM_EXFACTORY_RESULT, nolock)
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @P_ROLLIN) B ON A.COMPANY_ID = B.OLD_VALUE1
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN) C ON A.PLANT_ID = C.OLD_VALUE1
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1,OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN) D
                           ON A.PLANT_ID    = D.OLD_VALUE1
                           AND A.STORAGE_ID = D.OLD_VALUE2
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'SCP_SITE_ID' AND ATTRIBUTE5 = @P_ROLLIN) S2 ON A.FROM_SCM_SITE_ID = S2.OLD_VALUE1
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'SCP_SITE_ID' AND ATTRIBUTE5 = @P_ROLLIN) S3 ON A.TO_SCM_SITE_ID = S3.OLD_VALUE1

                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @P_ROLLIN) S4 ON A.SHIPTO_CODE = S4.OLD_VALUE1
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'END_CUSTOMER_ID' AND ATTRIBUTE5 = @P_ROLLIN) S5 ON A.SHIPTO_CODE = S5.OLD_VALUE1

                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @P_ROLLIN) S6 ON A.SOLDTO_CODE = S6.OLD_VALUE1
                LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'END_CUSTOMER_ID' AND ATTRIBUTE5 = @P_ROLLIN) S7 ON A.SOLDTO_CODE = S7.OLD_VALUE1

                --LEFT JOIN ( SELECT OLD_VALUE1 as scm_site_id, OLD_VALUE2 as country from NERP_CONV_MASTER_CFM_V  WHERE CODETYPE = 'SCP_INCOTERMS' AND ATTRIBUTE5 = @P_ROLLIN) IC ON A.FROM_SCM_SITE_ID = IC.scm_site_id
                ) LIST



                SELECT *
                 , CASE WHEN ISNULL(TOBE_COMPANY_ID,'')    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_PLANT_ID,'')    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_STORAGE_ID,'')    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_FROM_SCM_SITE_ID,'')    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_TO_SCM_SITE_ID,'')    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_SHIPTO_CODE,'')    != '' THEN 'Y'
                        WHEN ISNULL(TOBE_SOLDTO_CODE,'')    != '' THEN 'Y'
                        --WHEN ISNULL(TOBE_INCOTERMS,'')    != '' THEN 'Y'
                        ELSE 'N'
                        END CHANGE_YN
                INTO #TMP_SCM_DNM_EXFACTORY_RESULT_CONV
                FROM #TMP_SCM_DNM_EXFACTORY_RESULT



                CREATE INDEX idx_TMP_SCM_DNM_EXFACTORY_RESULT_CONV ON #TMP_SCM_DNM_EXFACTORY_RESULT_CONV
                                                                    (COMPANY_ID
                                                                    ,DIVISION_ID
                                                                    ,SITE_ID
                                                                    ,PLANT_ID
                                                                    ,STORAGE_ID
                                                                    ,FROM_SCM_SITE_ID
                                                                    ,TO_SCM_SITE_ID
                                                                    ,SHIPTO_CODE
                                                                    ,SOLDTO_CODE
                                                                    ,INCOTERMS)


                    --##############################################################################################
                    -- 전체로 작업 시 시간 Long / 나누어서 업데이트
                    -- Plant 중복 IN
                    --##############################################################################################

                    UPDATE SCM_DNM_EXFACTORY_RESULT
                       SET SCM_DNM_EXFACTORY_RESULT.COMPANY_ID          = ISNULL(B.TOBE_COMPANY_ID      , A.COMPANY_ID      )
                          ,SCM_DNM_EXFACTORY_RESULT.PLANT_ID            = ISNULL(B.TOBE_PLANT_ID        , A.PLANT_ID        )
                          ,SCM_DNM_EXFACTORY_RESULT.STORAGE_ID          = ISNULL(B.TOBE_STORAGE_ID      , A.STORAGE_ID      )
                          ,SCM_DNM_EXFACTORY_RESULT.FROM_SCM_SITE_ID    = ISNULL(B.TOBE_FROM_SCM_SITE_ID, A.FROM_SCM_SITE_ID)
                          ,SCM_DNM_EXFACTORY_RESULT.TO_SCM_SITE_ID      = ISNULL(B.TOBE_TO_SCM_SITE_ID  , A.TO_SCM_SITE_ID  )
                          ,SCM_DNM_EXFACTORY_RESULT.SHIPTO_CODE         = ISNULL(B.TOBE_SHIPTO_CODE     , A.SHIPTO_CODE     )
                          ,SCM_DNM_EXFACTORY_RESULT.SOLDTO_CODE         = ISNULL(B.TOBE_SOLDTO_CODE     , A.SOLDTO_CODE     )
                          --,SCM_DNM_EXFACTORY_RESULT.INCOTERMS         = ISNULL(B.TOBE_INCOTERMS       , A.INCOTERMS       )
                          ,SCM_DNM_EXFACTORY_RESULT.LAST_UPDATED_BY  = @CREATED_BY
                          ,SCM_DNM_EXFACTORY_RESULT.LAST_UPDATE_DATE = GETDATE()
                     FROM .SCM_DNM_EXFACTORY_RESULT AS A,
                    (
                    -- IN       38592
                    -- NOT IN   85632
                    select *
                    from #TMP_SCM_DNM_EXFACTORY_RESULT_CONV
                    where change_yn = 'Y'
                    and plant_id  in (SELECT OLD_VALUE1 FROM #TMP_PLANT_DUP_DETAIL)
                    ) AS B
                    WHERE   A.COMPANY_ID                    = B.COMPANY_ID
                      AND   A.DIVISION_ID                   = B.DIVISION_ID
                      AND   A.SITE_ID                       = B.SITE_ID
                      AND   A.PLANT_ID                      = B.PLANT_ID
                      AND   ISNULL(A.STORAGE_ID ,'')        = ISNULL(B.STORAGE_ID,'')
                      AND   ISNULL(A.FROM_SCM_SITE_ID ,'')  = ISNULL(B.FROM_SCM_SITE_ID ,'')
                      AND   ISNULL(A.TO_SCM_SITE_ID ,'')    = ISNULL(B.TO_SCM_SITE_ID   ,'')
                      AND   ISNULL(A.SHIPTO_CODE    ,'')                    = ISNULL(B.SHIPTO_CODE  ,'')
                      AND   ISNULL(A.SOLDTO_CODE    ,'')                    = ISNULL(B.SOLDTO_CODE  ,'')
                      AND   ISNULL(A.INCOTERMS  ,'')                        = ISNULL(B.INCOTERMS    ,'')



                    --##############################################################################################
                    -- Plant 중복 NOT IN
                    --##############################################################################################
                    UPDATE SCM_DNM_EXFACTORY_RESULT
                       SET SCM_DNM_EXFACTORY_RESULT.COMPANY_ID          = ISNULL(B.TOBE_COMPANY_ID      , A.COMPANY_ID      )
                          ,SCM_DNM_EXFACTORY_RESULT.PLANT_ID            = ISNULL(B.TOBE_PLANT_ID        , A.PLANT_ID        )
                          ,SCM_DNM_EXFACTORY_RESULT.STORAGE_ID          = ISNULL(B.TOBE_STORAGE_ID      , A.STORAGE_ID      )
                          ,SCM_DNM_EXFACTORY_RESULT.FROM_SCM_SITE_ID    = ISNULL(B.TOBE_FROM_SCM_SITE_ID, A.FROM_SCM_SITE_ID)
                          ,SCM_DNM_EXFACTORY_RESULT.TO_SCM_SITE_ID      = ISNULL(B.TOBE_TO_SCM_SITE_ID  , A.TO_SCM_SITE_ID  )
                          ,SCM_DNM_EXFACTORY_RESULT.SHIPTO_CODE         = ISNULL(B.TOBE_SHIPTO_CODE     , A.SHIPTO_CODE     )
                          ,SCM_DNM_EXFACTORY_RESULT.SOLDTO_CODE         = ISNULL(B.TOBE_SOLDTO_CODE     , A.SOLDTO_CODE     )
                          --,SCM_DNM_EXFACTORY_RESULT.INCOTERMS         = ISNULL(B.TOBE_INCOTERMS       , A.INCOTERMS       )
                          ,SCM_DNM_EXFACTORY_RESULT.LAST_UPDATED_BY  = @CREATED_BY
                          ,SCM_DNM_EXFACTORY_RESULT.LAST_UPDATE_DATE = GETDATE()
                     FROM .SCM_DNM_EXFACTORY_RESULT AS A,
                    (
                    -- IN       38592
                    -- NOT IN   85632
                    select *
                    from #TMP_SCM_DNM_EXFACTORY_RESULT_CONV
                    where change_yn = 'Y'
                    and plant_id  NOT in (SELECT OLD_VALUE1 FROM #TMP_PLANT_DUP_DETAIL)
                    ) AS B
                    WHERE   A.COMPANY_ID                    = B.COMPANY_ID
                      AND   A.DIVISION_ID                   = B.DIVISION_ID
                      AND   A.SITE_ID                       = B.SITE_ID
                      AND   A.PLANT_ID                      = B.PLANT_ID
                      AND   ISNULL(A.STORAGE_ID ,'')        = ISNULL(B.STORAGE_ID,'')
                      AND   ISNULL(A.FROM_SCM_SITE_ID ,'')  = ISNULL(B.FROM_SCM_SITE_ID ,'')
                      AND   ISNULL(A.TO_SCM_SITE_ID ,'')    = ISNULL(B.TO_SCM_SITE_ID   ,'')
                      AND   ISNULL(A.SHIPTO_CODE    ,'')                    = ISNULL(B.SHIPTO_CODE  ,'')
                      AND   ISNULL(A.SOLDTO_CODE    ,'')                    = ISNULL(B.SOLDTO_CODE  ,'')
                      AND   ISNULL(A.INCOTERMS  ,'')                        = ISNULL(B.INCOTERMS    ,'')

                drop INDEX idx_TMP_SCM_DNM_EXFACTORY_RESULT_CONV on #TMP_SCM_DNM_EXFACTORY_RESULT_CONV
                drop table #TMP_SCM_DNM_EXFACTORY_RESULT_CONV
                drop table #TMP_SCM_DNM_EXFACTORY_RESULT

                SET @MAPPING_RESULT = 'Y';
                END



        --################################################################
        -- Log
        --################################################################

        IF @MAPPING_RESULT = 'Y'
        BEGIN
            SET @END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            SET @RUN_TIME = DATEDIFF(SECOND, @START_TIME, @END_TIME)
            SET @v_description = concat(

            '     @CNT = ' , @CNT
            , ' , @TABLE_NAME = ', @TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            , ' , @END_TIME = '   , @END_TIME
            , ' , @RUN_TIME = '   , @RUN_TIME
            );



           UPDATE ZNERP_DEV_ITEM_SCHEDULE
              SET MAPPING_START             = @START_TIME
                , MAPPING_END               = @END_TIME
                , MAPPING_TIME              = @RUN_TIME
                , STATUS                    = 'FINISH'
                , UPDATE_USER               = 'NERP_SCP_BATCH'
                , UPDATE_DATE               = GETDATE()
            where PROGRAM_ID                = @TABLE_NAME
              and mapping_use = 'DP'

            print concat(@@trancount, ' , ', @@trancount)
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'Update Result', @RUN_TIME, @TABLE_NAME, @mSubQuery, @d_event_date;


        END

            END TRY
            BEGIN CATCH
                    SET @CNT = @@ROWCOUNT;
                    SET @WORK_SECOND = ERROR_NUMBER();
                    SET @v_description = ERROR_MESSAGE();
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
                    PRINT 'ERROR'
                    PRINT ERROR_MESSAGE();
            END CATCH

        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME

        END
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;


        SET @BATCH_END_TIME = SYSDATETIME();
        SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
        PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
        DECLARE @DUMMY NVARCHAR(MAX) = 'END,'+@v_description+', RUN_TIME ';
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  @DUMMY, @BATCH_END_TIME;

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
