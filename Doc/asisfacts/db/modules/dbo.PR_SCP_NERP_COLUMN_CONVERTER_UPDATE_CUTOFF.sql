

-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF
-- Author:       vadabi5
-- Create date:  2024-11-15
-- Description:  NERP) BIG Table  Convert CUTOFF
-- ==========================================================================================
-- 2024-11-15       vadabi5     NERP) 신규 생성
-- 2024-11-01       vadabi5     NERP) QA DB 1차 테스트 위한 개선
-- 2024-12-02       vadabi5     NERP) PARAMETER GROUP 추가
-- 2024-12-05       vadabi5     NERP) 한글관련 이슈 조치 COLLATE Latin1_General_CI_AS
---------------------------------------------------------------------------------------------------------
-- 2024-12-10       vadabi5     NERP) ATTRIBUTE10 체크
-- 2024-12-10       vadabi5     NERP) 테스트 결과 - 개선필요 리스트
-- 2025-01-14       vadabi5     NERP) VALUATION_CLASS (SCP_ANL_MONTH_END_STOCK_R, SCP_ANL_MONTH_END_STOCK_R_D)
-- 2025-04-09       김준규       3TBL을 3개에서 5개 BIG 으로 재구성
-- 2025-04-18       김준규       운영에서 1ST 실행시 모든 것 실행하기 위하여 @P_TABLE = 'ALL' 추가
-- 2025-04-26       김준규       SCP_ANL_SHIPMENT_PLAN_FG_C 운영에서 1ST 실행시 변경안됨 발생, 우측으로 수정 (CUTOFF_DATE < @CUTOFF_FROM --> AND CUTOFF_DATE >= @CUTOFF_FROM AND CUTOFF_DATE < @CUTOFF_TO
-- 2025-05-15       김준규       테이블당 PR_SCM_SYS_LOG_BATCH 1회만 처리
-- 2025-06-08       김준규       SCP_ANL_SHIPMENT_PLAN_FG_C 에서 CODETYPE = 'SCP_SITE_DESCRIPTION' 가 DESC1, DESC2 --> OLD_VALUE1, NEW_VALUE1로 변경 다른 테이블도 변경
-- 2025-07-18       김준규       SCM_MST_MODEL_BOM_EFFECTIVE 에서 TOBE기준 중복발생으로 중복은 G182,G183중 G182삭제하고 작업하도록 변경
-- 2025-08-04       김준규       SCP_ANL_MONTH_END_STOCK_R_D 에서 VALUATION_CLASS BKLAS 처리로직 막음, MATKL 값을 사용하는데 tobe 코드가 안들어옴.
-- 2025-08-27       김준규       운영에서 현재의 NERP_ROLLIN_STAGE 상태를 확인하고 SCM_MST_MODEL_BOM_EFFECTIVE 는 동일 또는 이하 ROLLIN STAGE인 경우에 대하여 추가 작업을 하지 않아도 됨
-- 2025-09-08       김준규       작업분배 방식 사용, 사용기간 선택 추가.
-- 2025-10-03       김준규       SCP GLOBAL PSI MOBILE IT 화면에서 사용하는 컬럼이라서 UPDATE 하면 안되서어 막음. --,SCP_ANL_PSI_GLOBAL_SMALL.ATTRIBUTE10   = @CREATED_BY
-- 2025-10-14       김준규       NERP_CONV_CUTOFF_TAKES_MIN 테이블에 RTYPE=SCP 추가.                            

/*
                                -----------------------------------
                                SCP_ANL_TACT_TIME           7883
                                SCP_PLN_SHIPMENT_PLAN       3036
                                SCP_ANL_PRODUCTION_PLAN     3063
                                SCP_PLN_PLANT_ONHAND        2750
                                -----------------------------------
                                Normal -> Big 전환
                                SCM_DNM_EXFACTORY_RESULT    1492
                                SCP_PLN_PRODUCTION_PLAN     1855
                                SCM_MST_MODEL_BOM           1942
                                -----------------------------------
                                개선
                                SCP_RPT_DIO_TREND_MM
                                SCP_PLN_PRODUCTION_PLAN_PEGGING
                                SCP_ANL_LONG_TERM_STOCK

------------------------------------------------------------------------------
--2025-07-18
SCM_MST_MODEL_BOM_EFFECTIVE
PK_SCM_MST_MODEL_BOM_EFFECTIVE 위반
중복 키를 삽입할 수 없습니다
COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE
중복 키 값은 (NJ00, 40, A002, NJ01, APCAN0514A, APCAN0514A, 01  1 1990 12:00AM)

*/
-- ==========================================================================================
/*
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF 'SCP_ANL_SHIPMENT_PLAN_SEMI_C', 'A'
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF  @P_TABLE='',@P_GROUP='',@P_ROLLIN='1ST'
EXEC PR_TMP_NERP_INSERT_FROM_PROD_BY_ROLLIN_SCP @P_TABLE = 'SCP_ANL_MONTH_END_STOCK_R', @P_ROLLIN='3RD',@P_DEL_TYPE='TRUNC';
DECLARE @V_GROUP_NUM INT;
DECLARE @V_GROUP_COUNT INT;
SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT
FROM   NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) 
WHERE  CTM.TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R';
PRINT '@P_GROUP_NUM  :'+CONVERT(NVARCHAR(MAX),@V_GROUP_NUM  );
PRINT '@P_GROUP_COUNT:'+CONVERT(NVARCHAR(MAX),@V_GROUP_COUNT);
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF  @P_TABLE='SCP_ANL_MONTH_END_STOCK_R',@P_GROUP='',@P_ROLLIN='3RD',@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT;

SELECT * FROM NERP_CONV_CUTOFF_TAKES_MIN WITH(NOLOCK);

TRUNCATE TABLE NERP_CONV_SCP_DATA_BIG

                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @DIVISION
*/
-- =============================================
CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF]
   @P_TABLE nvarchar(100)
 , @P_GROUP nvarchar(4)
 , @P_ROLLIN nvarchar(30) --1ST 2ND 3RD 4TH
 , @P_GROUP_NUM INT --그룹카운트 중 몇번째 것
 , @P_GROUP_COUNT INT
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
    DECLARE @C_COPYED_TBL_NM NVARCHAR(128) = N'';
    DECLARE @C_PRINT_YN    BIT = 0; -- 1 Y, 0 N
    DECLARE @COL_INFO   NVARCHAR(150) = N'';

    DECLARE @CNT BIGINT;
    DECLARE @CNT_TBL BIGINT;
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
    SET @CNT_TBL = 0;
    SET @RUN_TIME = 0;
    SET @MAPPING_COLUMN = '';

    DECLARE @YYYYMM nvarchar(10) = '';
    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;
    DECLARE @DUMMY          NVARCHAR(MAX);
    DECLARE @DEL_BOM_DUP_YN NVARCHAR(1)='N';


    -- 시작 LOG
    SET @v_log_type = @P_TABLE;
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@P_TABLE='+@P_TABLE+',@P_GROUP='+@P_GROUP+',@P_ROLLIN='+@P_ROLLIN+',@P_GROUP_NUM='+CONVERT(CHAR(23),@P_GROUP_NUM)+',@P_GROUP_COUNT='+CONVERT(CHAR(23),@P_GROUP_COUNT);
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0', @v_description, @START_TIME;


BEGIN TRY
        --DECLARE @YYYYMM                   nvarchar(10) = '202407'
        --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240923'
        --DECLARE @BASIS_YYYYMMDD           nvarchar(10) = '20240901'
        --DECLARE @CUTOFF_DATE          nvarchar(10) = '2024-09-01'
        --DECLARE @division_id          nvarchar(10) = '40'
        --DECLARE @plan_week nvarchar(10) = '202430'


    --###########################################################################################################
    -- CURSOR_MAPPING
    --###########################################################################################################
        --DECLARE @TABLE_NAME nvarchar(100)
        --DECLARE @MAPPING_RESULT nvarchar(100)
        --DECLARE @START_TIME DATETIME;
        --DECLARE @END_TIME DATETIME;
        --DECLARE @CNT INT
        DECLARE @CUTOFF_START nvarchar(100)
        DECLARE @CUTOFF_FROM nvarchar(100)
        DECLARE @CUTOFF_TO nvarchar(100)
        DECLARE @DIVISION nvarchar(100)
        DECLARE @PLAN_TYPE nvarchar(100)
        DECLARE @SEQ nvarchar(100)
        DECLARE @RNO INT
        DECLARE @TMP_CONV_SCP_DATA_BIG TABLE (
             TABLE_NAME  NVARCHAR(100)
            ,OLD_VALUE1  NVARCHAR(400)
            ,OLD_VALUE2  NVARCHAR(400)
            ,OLD_VALUE3  NVARCHAR(400)
            ,OLD_VALUE4  NVARCHAR(400)
            ,OLD_VALUE5  NVARCHAR(400)
            ,OLD_VALUE6  NVARCHAR(400)
            ,OLD_VALUE7  NVARCHAR(400)
            ,OLD_VALUE8  NVARCHAR(400)
            ,OLD_VALUE9  NVARCHAR(400)
            ,OLD_VALUE10 NVARCHAR(400)
            ,NEW_VALUE1  NVARCHAR(400)
            ,NEW_VALUE2  NVARCHAR(400)
            ,NEW_VALUE3  NVARCHAR(400)
            ,NEW_VALUE4  NVARCHAR(400)
            ,NEW_VALUE5  NVARCHAR(400)
            ,NEW_VALUE6  NVARCHAR(400)
            ,NEW_VALUE7  NVARCHAR(400)
            ,NEW_VALUE8  NVARCHAR(400)
            ,NEW_VALUE9  NVARCHAR(400)
            ,NEW_VALUE10 NVARCHAR(400)
            ,NEW_VALUE11 NVARCHAR(800));


        --#######################################################################################
        --NERP_CONV_MASTER_CFM_V 를 DROP가 아닌 NERP_CONV_MASTER_CFM_V로 작업한다, 1차 작업한 것 결과 확인
        --#######################################################################################

        --TRUNCATE TABLE NERP_CONV_SCP_DATA_BIG;

        --1차법인 이고 운영일경우 이미 작업을 완료 했기 때문에 제외되어야 한다.
        DECLARE @NERP_PROD NVARCHAR(128);
        SET @NERP_PROD = 'LGCE_'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXPFROCDYB','2,5,6,8,10,11,13');--에스시엠피알오디
        DECLARE @NERP_FIRST_STAGE NVARCHAR(128);
        SET @NERP_FIRST_STAGE = '1'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDTE','2,4');--에스티
        --PRINT @NERP_PROD
        --PRINT @NERP_STAGE

        --2025-08-07 TOBE 코드 임시테이블로 사용
        DROP TABLE IF EXISTS #TMP_COMPANY_ID;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 INTO #TMP_COMPANY_ID FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @P_ROLLIN;
        DROP TABLE IF EXISTS #TMP_PLANT_ID;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 INTO #TMP_PLANT_ID FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN;
        DROP TABLE IF EXISTS #TMP_SCP_SITE_ID;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 INTO #TMP_SCP_SITE_ID FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' AND ATTRIBUTE5 = @P_ROLLIN;
        DROP TABLE IF EXISTS #TMP_SCP_SITE_DESCRIPTION;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 INTO #TMP_SCP_SITE_DESCRIPTION FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_DESCRIPTION' AND ATTRIBUTE5 = @P_ROLLIN;
        DROP TABLE IF EXISTS #TMP_STORAGE_ID;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 INTO #TMP_STORAGE_ID FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN;
        DROP TABLE IF EXISTS #TMP_VENDOR_ID;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 INTO #TMP_VENDOR_ID FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'VENDOR_ID' AND ATTRIBUTE5 = @P_ROLLIN;
        DROP TABLE IF EXISTS #TMP_END_CUSTOMER_ID;
        SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 INTO #TMP_END_CUSTOMER_ID FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'END_CUSTOMER_ID' and ATTRIBUTE5 = @P_ROLLIN;

        ------------------------------------------------------------------------
        -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
        ------------------------------------------------------------------------
        DECLARE @V_NERP_ROLLIN_STAGE NVARCHAR(30);
        DECLARE @V_NERP_START_YYYYMMDD NVARCHAR(8);

        SELECT TOP 1 @V_NERP_ROLLIN_STAGE = LMD.SEGMENT1
              ,@V_NERP_START_YYYYMMDD = LMD.SEGMENT2
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL lmd WITH(NOLOCK)
        JOIN   SCM_ADM_LOOKUP_MASTER alm WITH(NOLOCK)
        ON     ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
        AND    ALM.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE'
        WHERE  ALM.VALID_YN = 'Y'
        AND    LMD.VALID_YN = 'Y';
        --PRINT @V_NERP_ROLLIN_STAGE;
        --PRINT @V_NERP_START_YYYYMMDD;
    ------------------------------------------------------------------------
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End
    ------------------------------------------------------------------------

        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END
        DECLARE CURSOR_MAPPING CURSOR FOR


           --DECLARE @P_TABLE       nvarchar(100) = ''
           --DECLARE @P_GROUP       nvarchar(100) = ''

            -- Data List
           SELECT D.TABLE_NAME
                , D.CUTOFF_FROM as CUTOFF_FROM
                , D.CUTOFF_TO as CUTOFF_TO
                , D.CUTOFF_DIVISION AS DIVISION
                , D.CUTOFF_PLAN_TYPE AS PLAN_TYPE
                , D.cutoff_sort as rno
                , D.CUTOFF_START
                --, M.PRIORITY_GROUP
             FROM NERP_CONV_SCP_CUTOFF D WITH (NOLOCK)
        LEFT JOIN NERP_CONV_SCP_CUTOFF_MASTER M WITH (NOLOCK) ON D.TABLE_NAME = ''+M.TABLE_NAME
             JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON D.TABLE_NAME = ''+CTM.TABLE_NAME
            where D.MAPPING_USE = 'Y'
              AND CTM.RTYPE = 'SCP'
              AND CTM.GROUP_NUM = @P_GROUP_NUM
              AND CTM.GROUP_COUNT = @P_GROUP_COUNT
            --and ISNULL(mapping_result,'') != 'FINISH'
            --and  D.TABLE_NAME = 'SCM_DNM_STOCK'
            -- and D.CUTOFF_FROM >= '20241125'
            and (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR M.TABLE_NAME = @P_TABLE)
            and (@P_GROUP IS NULL OR @P_GROUP ='' OR M.PRIORITY_GROUP = @P_GROUP)
            AND NOT EXISTS ( SELECT 1
                             FROM  (SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                                    SELECT 'SCP_ANL_SHIPMENT_PLAN_SEMI'    AS TBL_NM UNION
                                    --SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM UNION
                                    --SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                                    SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM ) X
                             WHERE  1=1
                             AND    X.TBL_NM =  D.TABLE_NAME
                             --AND    (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' )
                             --2025-04-18 김준규 ALL일때 제외가 동작하지 않게 모두 다 나오게 해야 해서 ALL을 제거함
                             AND    (@P_TABLE IS NULL OR @P_TABLE ='' )
                             )
            AND  ISNULL(@P_TABLE,'') <> '3TBL'
            --2025-04-26 1차 롤인 한 법인에 대하여 추가 작업을 하지 않아도 됨
            --2025-08-27 운영에서 현재의 NERP_ROLLIN_STAGE 상태를 확인하고 SCM_MST_MODEL_BOM_EFFECTIVE 는 동일 또는 이하 ROLLIN STAGE인 경우에 대하여 추가 작업을 하지 않아도 됨
            AND NOT EXISTS ( SELECT 1
                             WHERE  D.TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                             AND    DB_NAME() = @NERP_PROD
                             --2025-08-27 @NERP_FIRST_STAGE를 @V_NERP_ROLLIN_STAG로 변경하면서 =을 <=로 변경
                             --AND    @P_ROLLIN = @NERP_FIRST_STAGE
                             AND    @P_ROLLIN <= @V_NERP_ROLLIN_STAGE
                           )
           UNION
           SELECT D.TABLE_NAME
                , D.CUTOFF_FROM as CUTOFF_FROM
                , D.CUTOFF_TO as CUTOFF_TO
                , D.CUTOFF_DIVISION AS DIVISION
                , D.CUTOFF_PLAN_TYPE AS PLAN_TYPE
                , D.cutoff_sort as rno
                , D.CUTOFF_START
                --, M.PRIORITY_GROUPㄿ
             FROM NERP_CONV_SCP_CUTOFF D WITH (NOLOCK)
        LEFT JOIN NERP_CONV_SCP_CUTOFF_MASTER M WITH (NOLOCK) ON D.TABLE_NAME = ''+M.TABLE_NAME
             JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON D.TABLE_NAME = ''+CTM.TABLE_NAME
            where D.MAPPING_USE = 'Y'
              AND CTM.RTYPE = 'SCP'
              AND CTM.GROUP_NUM = @P_GROUP_NUM
              AND CTM.GROUP_COUNT = @P_GROUP_COUNT
            --and ISNULL(mapping_result,'') != 'FINISH'
            --and  D.TABLE_NAME = 'SCM_DNM_STOCK'
            -- and D.CUTOFF_FROM >= '20241125'
            --and (@P_TABLE IS NULL OR @P_TABLE ='' OR M.TABLE_NAME = @P_TABLE)
            --and (@P_GROUP IS NULL OR @P_GROUP ='' OR M.PRIORITY_GROUP = @P_GROUP)
            AND  ISNULL(@P_TABLE,'') = '3TBL'
            AND  D.TABLE_NAME IN (SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                                  SELECT 'SCP_ANL_SHIPMENT_PLAN_SEMI'    AS TBL_NM UNION
                                  --SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM UNION
                                  --SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                                  SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM )
            --2025-04-26 1차 롤인 한 법인에 대하여 추가 작업을 하지 않아도 됨
            --2025-08-27 운영에서 현재의 NERP_ROLLIN_STAGE 상태를 확인하고 SCM_MST_MODEL_BOM_EFFECTIVE 는 동일 또는 이하 ROLLIN STAGE인 경우에 대하여 추가 작업을 하지 않아도 됨
            AND NOT EXISTS ( SELECT 1
                             WHERE  D.TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                             AND    DB_NAME() = @NERP_PROD
                             --2025-08-27 @NERP_FIRST_STAGE를 @V_NERP_ROLLIN_STAG로 변경하면서 =을 <=로 변경
                             --AND    @P_ROLLIN = @NERP_FIRST_STAGE
                             AND    @P_ROLLIN <= @V_NERP_ROLLIN_STAGE
                           )
         order by D.TABLE_NAME ASC, D.CUTOFF_FROM DESC



        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME, @CUTOFF_FROM, @CUTOFF_TO, @DIVISION, @PLAN_TYPE, @RNO, @CUTOFF_START

        WHILE @@FETCH_STATUS = 0
        BEGIN

            ----########################################
            --SET @TABLE_NAME = ''+@TABLE_NAME;
            ----########################################

            IF @TABLE_NAME <> @C_COPYED_TBL_NM
                BEGIN
                    SET @C_COPYED_TBL_NM = @TABLE_NAME;
                    SET @C_PRINT_YN = 1;
                    SET @CNT_TBL = @CNT_TBL +1;
                END
            ELSE
                BEGIN
                    SET @C_PRINT_YN = 0;
                END

    BEGIN TRY
        --BEGIN TRANSACTION;
        ----------------------------------------------------------------
        -- CUTOFF_TO
        ----------------------------------------------------------------
            --IF @RNO = 1
            --  BEGIN
            --  SELECT @CUTOFF_TO = CONVERT(NVARCHAR(8), GETDATE() , 112)
            --  END
         --   ELSE
            --  BEGIN
            --  SELECT @CUTOFF_TO = CUTOFF_VALUE1
            --  FROM NERP_CONV_SCP_CUTOFF
            --    WHERE TABLE_NAME = @TABLE_NAME
            --   AND CUTOFF_SORT = @RNO - 1
            --  END

        ----------------------------------------------------------------
        -- @CUTOFF_START
        ----------------------------------------------------------------
            IF @CUTOFF_START = ''
            begin
            SELECT @CUTOFF_START = CONVERT(NVARCHAR(8), '19000101' , 112)
            end

            set @v_log_message =  concat('CURSOR_MAPPING = ', @TABLE_NAME, ', ',@CUTOFF_FROM, ', ',@CUTOFF_TO, ', ', @DIVISION, ', ' + @PLAN_TYPE, ', ', @RNO)
            PRINT @v_log_message
            SET @MAPPING_RESULT = 'N';
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            --SET @v_log_message = concat('[MAPPING_TIME] = ', DATEDIFF(SECOND, @MAPPING_START_TIME, @MAPPING_END_TIME));
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @@ROWCOUNT, @v_description, @v_log_message, @START_TIME;
            SET @DUMMY = 'RUN -->> '+concat(
            ' @CNT = ' , @CNT
            , ' , @TABLE_NAME = ', @TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            );

            PRINT @DUMMY


            --DELETE from NERP_CONV_SCP_DATA_BIG where table_name = @TABLE_NAME
            WHILE 1 = 1
            BEGIN
                DELETE TOP (100000)
                FROM dbo.NERP_CONV_SCP_DATA_BIG WITH (TABLOCK)
                WHERE TABLE_NAME = @TABLE_NAME;

                -- 더 이상 삭제할 게 없으면 종료
                IF @@ROWCOUNT = 0
                    BREAK;

                -- 트랜잭션 로그를 너무 쌓지 않도록 약간의 쉬는 시간 (옵션)
                --WAITFOR DELAY '00:00:01'; -- 1초 쉬기
            END


                -- PLAN_START_YYYYMMDD  + Only EE
                -- 20241201 PLAN_START_YYYYMMDD, division_id - > PLAN_START_YYYYMMDD, plan_type
                IF @TABLE_NAME = 'SCP_ANL_PSI_GLOBAL_ESS'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @plan_type

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_ANL_PSI_GLOBAL_ESS
                      FROM SCP_ANL_PSI_GLOBAL_ESS A  with (INDEX(IX01_SCP_ANL_PSI_GLOBAL_ESS) , nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and plan_type = @plan_type
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_PSI_GLOBAL_ESS_CONV
                        FROM #TMP_SCP_ANL_PSI_GLOBAL_ESS A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_GLOBAL_ESS


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          @TABLE_NAME
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@plan_type
                    FROM #TMP_SCP_ANL_PSI_GLOBAL_ESS_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_GLOBAL_ESS_CONV



                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @PLAN_TYPE;


                      UPDATE SCP_ANL_PSI_GLOBAL_ESS
                         SET SCP_ANL_PSI_GLOBAL_ESS.FROM_SITE   = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_ANL_PSI_GLOBAL_ESS.TO_SITE     = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_ANL_PSI_GLOBAL_ESS.ATTRIBUTE10 = @CREATED_BY
                       FROM .SCP_ANL_PSI_GLOBAL_ESS AS A  with (INDEX(IX01_SCP_ANL_PSI_GLOBAL_ESS)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = @TABLE_NAME and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 = @CUTOFF_FROM
                    --    AND NEW_VALUE10 = @plan_type
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.plan_type = @plan_type


                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_GLOBAL'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE8 = @CUTOFF_FROM
                            AND NEW_VALUE9 = @DIVISION
                            AND NEW_VALUE10 = @PLAN_TYPE

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE ,ATTRIBUTE9, count(*) AS CNT
                      INTO #TMP_SCP_ANL_PSI_GLOBAL
                      FROM SCP_ANL_PSI_GLOBAL A WITH (INDEX (PK_SCP_ANL_PSI_GLOBAL))
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and division_id = @DIVISION
                      and PLAN_TYPE = @PLAN_TYPE
                  group by FROM_SITE, TO_SITE ,ATTRIBUTE9



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_PSI_GLOBAL_CONV
                        FROM #TMP_SCP_ANL_PSI_GLOBAL A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_GLOBAL


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          @TABLE_NAME
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@DIVISION
                        ,@PLAN_TYPE
                    FROM #TMP_SCP_ANL_PSI_GLOBAL_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_GLOBAL_CONV



                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      UPDATE A
                         SET A.FROM_SITE   = ISNULL(B.new_value1, A.FROM_SITE)
                            ,A.TO_SITE     = ISNULL(B.new_value2, A.TO_SITE)
                            ,A.ATTRIBUTE10 = @CREATED_BY
                       FROM SCP_ANL_PSI_GLOBAL AS A WITH (INDEX (PK_SCP_ANL_PSI_GLOBAL)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --  where table_name = @TABLE_NAME and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE8 = @CUTOFF_FROM
                    --    AND NEW_VALUE9 = @DIVISION
                    --    AND NEW_VALUE10 = @PLAN_TYPE
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.DIVISION_ID = @DIVISION
                        AND A.PLAN_TYPE   = @PLAN_TYPE

                    SET @MAPPING_RESULT = 'Y';
                    END

                -- PLAN_START_YYYYMMDD + Only 82
                -- 20241201 CUTOFF_FROM  DIVISION PLAN_TYPE
                ELSE IF @TABLE_NAME = 'SCP_RPT_ELEC_PSI'
                    BEGIN
                    /*
                    SCP_RPT_ELEC_PSI    COMPANY_ID  COMPANY_ID
                    SCP_RPT_ELEC_PSI    PLANT_ID    PLANT_ID
                    SCP_RPT_ELEC_PSI    FROM_SITE   SCM_SITE_ID
                    SCP_RPT_ELEC_PSI    TO_SITE     SCM_SITE_ID
                    */
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = @TABLE_NAME
                    AND NEW_VALUE8 = @CUTOFF_FROM
                    AND NEW_VALUE9 = @DIVISION
                    AND NEW_VALUE10 = @PLAN_TYPE


                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240922'
                    --------------------------------------------------------------------------------------
                    -- 58 2초
                    SELECT COMPANY_ID, PLANT_ID, FROM_SITE, TO_SITE, count(*) AS CNT
                      INTO #TMP_SCP_RPT_ELEC_PSI
                      FROM SCP_RPT_ELEC_PSI A with (index(IX01_SCP_RPT_ELEC_PSI), nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and division_id = @DIVISION
                      and PLAN_TYPE = @PLAN_TYPE
                    group by COMPANY_ID, PLANT_ID, FROM_SITE, TO_SITE


                    --------------------------------------------------------------------------------------
                    -- 58 2초
                      SELECT COMPANY_ID, PLANT_ID, FROM_SITE, TO_SITE, CNT
                            ,B.NEW_VALUE1 AS TOBE_COMPANY_ID
                            ,C.NEW_VALUE1 AS TOBE_PLANT_ID
                            ,D.NEW_VALUE1 AS TOBE_FROM_SITE
                            ,E.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_RPT_ELEC_PSI_CONV
                        FROM #TMP_SCP_RPT_ELEC_PSI A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID B     ON A.COMPANY_ID  = B.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID C       ON A.PLANT_ID    = C.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID D    ON A.FROM_SITE   = D.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID E    ON A.TO_SITE     = E.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_RPT_ELEC_PSI

                    --------------------------------------------------------------------------------------
                    -- 58 2초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                     ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           @TABLE_NAME
                         ,'COMPANY_ID' , 'PLANT_ID', 'FROM_SITE', 'TO_SITE'
                         , COMPANY_ID, PLANT_ID, FROM_SITE, TO_SITE
                         , TOBE_COMPANY_ID
                         , TOBE_PLANT_ID
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         ,@CUTOFF_FROM
                         ,@DIVISION
                         ,@PLAN_TYPE
                    FROM #TMP_SCP_RPT_ELEC_PSI_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_RPT_ELEC_PSI_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3=ISNULL(B.OLD_VALUE3,'')
                          ,OLD_VALUE4=ISNULL(B.OLD_VALUE4,'')
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                    /*
                    40  0  초
                    81  0  초
                    82  0  초
                    EE  0  초
                    */

                    -- 358264 17초
                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240922'
                      UPDATE SCP_RPT_ELEC_PSI
                         SET SCP_RPT_ELEC_PSI.COMPANY_ID    = ISNULL(B.NEW_VALUE1, A.COMPANY_ID)
                            ,SCP_RPT_ELEC_PSI.PLANT_ID      = ISNULL(B.NEW_VALUE2, A.PLANT_ID)
                            ,SCP_RPT_ELEC_PSI.FROM_SITE     = ISNULL(B.NEW_VALUE3, A.FROM_SITE)
                            ,SCP_RPT_ELEC_PSI.TO_SITE       = ISNULL(B.NEW_VALUE4, A.TO_SITE)
                            ,SCP_RPT_ELEC_PSI.ATTRIBUTE10          = @CREATED_BY
                       FROM .SCP_RPT_ELEC_PSI AS A with (index(IX01_SCP_RPT_ELEC_PSI)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,NEW_VALUE1
                    --        ,NEW_VALUE2
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE4
                    -- FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    -- where table_name = @TABLE_NAME
                    -- and CHANGE_YN = 'Y'
                    -- AND NEW_VALUE8 = @CUTOFF_FROM
                    -- AND NEW_VALUE9 = @DIVISION
                    -- AND NEW_VALUE10 = @PLAN_TYPE
                    -- ) AS B
                      WHERE 1 = 1
                        AND A.COMPANY_ID                    = B.OLD_VALUE1
                        AND A.PLANT_ID                      = B.OLD_VALUE2
                        --AND ISNULL(A.FROM_SITE,'')          = ISNULL(B.OLD_VALUE3,'')
                        --AND ISNULL(A.TO_SITE  ,'')          = ISNULL(B.OLD_VALUE4,'')
                        AND ISNULL(A.FROM_SITE,'')          = B.OLD_VALUE3
                        AND ISNULL(A.TO_SITE  ,'')          = B.OLD_VALUE4
                        AND A.PLAN_START_YYYYMMDD           = @CUTOFF_FROM
                        AND A.DIVISION_ID = @DIVISION
                        AND A.PLAN_TYPE = @PLAN_TYPE

                    SET @MAPPING_RESULT = 'Y';
                    END

                -- PLAN_START_YYYYMMDD  + DIVISION_ID
                -- CUTOFF_DATE 가 인덱스가 있어 훨씬 빠름 변경처리
                -- 20241201 CUTOFF_DATE
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_FG_C'
                    BEGIN

                    --################################################################
                    /*-- NERP_CONV_SCP_DATA_BIG 에 입력
                    SCP_ANL_SHIPMENT_PLAN_FG_C  FROM_SITE       SCM_SITE_ID
                    SCP_ANL_SHIPMENT_PLAN_FG_C  FROM_SITE_NAME  SCM_SITE_DESCRIPTION
                    SCP_ANL_SHIPMENT_PLAN_FG_C  TO_SITE         SCM_SITE_ID
                    SCP_ANL_SHIPMENT_PLAN_FG_C  TO_SITE_NAME    SCM_SITE_DESCRIPTION
                    */
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = @TABLE_NAME
                    AND NEW_VALUE10 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    -- 3248 51초
                    SELECT DIVISION_ID, VERSION_NO, FROM_SITE, FROM_SITE_NAME,TO_SITE,TO_SITE_NAME,count(*) AS CNT
                      INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG_C
                      FROM SCP_ANL_SHIPMENT_PLAN_FG_C A with (index (IX02_SCP_ANL_SHIPMENT_PLAN_FG_C), nolock)
                    where CUTOFF_DATE  >=  @CUTOFF_FROM
                      and CUTOFF_DATE  <  @CUTOFF_TO
                  group by DIVISION_ID, VERSION_NO, CUTOFF_DATE, FROM_SITE, FROM_SITE_NAME,TO_SITE,TO_SITE_NAME


                    --------------------------------------------------------------------------------------
                    -- 3248 51초
                     SELECT DIVISION_ID, VERSION_NO, FROM_SITE, FROM_SITE_NAME,TO_SITE,TO_SITE_NAME, CNT
                           ,B.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,C.NEW_VALUE1 AS TOBE_TO_SITE
                           ,D.NEW_VALUE1 AS TOBE_FROM_SITE_NAME
                           ,E.NEW_VALUE1 AS TOBE_TO_SITE_NAME
                      INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG_C_CONV
                        FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG_C A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID B ON A.FROM_SITE = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.TO_SITE = C.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_DESCRIPTION D ON A.FROM_SITE_NAME = D.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_DESCRIPTION E ON A.TO_SITE_NAME = E.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG_C

                    --------------------------------------------------------------------------------------
                    -- 3248 51초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                           @TABLE_NAME
                         ,'DIVISION_ID', 'VERSION_NO', 'FROM_SITE', 'FROM_SITE_NAME', 'TO_SITE', 'TO_SITE_NAME'
                         , DIVISION_ID, VERSION_NO, FROM_SITE, FROM_SITE_NAME, TO_SITE, TO_SITE_NAME
                         , TOBE_FROM_SITE
                         , TOBE_FROM_SITE_NAME
                         , TOBE_TO_SITE
                         , TOBE_TO_SITE_NAME
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                --WHEN ISNULL(TOBE_FROM_SITE_NAME,'') != '' THEN 'Y'
                                --WHEN ISNULL(TOBE_TO_SITE_NAME,'') != '' THEN 'Y'
                                ELSE 'N'
                                END CHANGE_YN
                         ,@CUTOFF_FROM
                    FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG_C_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG_C_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,OLD_VALUE6
                          ,OLD_VALUE7
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,OLD_VALUE6
                          ,OLD_VALUE7
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM;

                    /*
                    -----------------------------------------------------------------------
                    40      196196  121초
                    81      47320   47초
                    81_HM   0       7초
                    81_ST   0
                    81_UC   0
                    82      175812  52초 / 85176   35초 추가 실행
                    EE      232960  76초 / 231504 116초 추가 실행
                    EE_HM   0
                    EE_UC   0
                    -----------------------------------------------------------------------
                    DIVISION_ID, VERSION_NO, CUTOFF_DATE, BIZ_TYPE, PROJECT_CODE, ITEM_ID, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE, YYYYMMDD
                    중복 키 값은
                    (81, SP_W_20240923, 09 25 2024 12:59PM, A, A17HC7001, ACLF1015I-B1, LGESOC Cell HQ07, Z02, HQ07-A, -, WH_IN, 20240923)
                    */

                      UPDATE SCP_ANL_SHIPMENT_PLAN_FG_C
                         SET SCP_ANL_SHIPMENT_PLAN_FG_C.FROM_SITE       = ISNULL(B.NEW_VALUE1, A.FROM_SITE)
                            ,SCP_ANL_SHIPMENT_PLAN_FG_C.FROM_SITE_NAME  = ISNULL(B.NEW_VALUE2, A.FROM_SITE_NAME)
                            ,SCP_ANL_SHIPMENT_PLAN_FG_C.TO_SITE         = ISNULL(B.NEW_VALUE3, A.TO_SITE)
                            ,SCP_ANL_SHIPMENT_PLAN_FG_C.TO_SITE_NAME    = ISNULL(B.NEW_VALUE4, A.TO_SITE_NAME)
                            ,SCP_ANL_SHIPMENT_PLAN_FG_C.ATTRIBUTE10     = @CREATED_BY
                       FROM .SCP_ANL_SHIPMENT_PLAN_FG_C AS A with (index (IX02_SCP_ANL_SHIPMENT_PLAN_FG_C)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,OLD_VALUE5
                    --        ,OLD_VALUE6
                    --        ,OLD_VALUE7
                    --        ,NEW_VALUE1
                    --        ,NEW_VALUE2
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE4
                    -- FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    -- where table_name = @TABLE_NAME
                    --  and CHANGE_YN = 'Y'
                    --  AND NEW_VALUE10 = @CUTOFF_FROM
                    -- ) AS B
                      WHERE 1 = 1
                        AND A.DIVISION_ID   = B.OLD_VALUE1
                        AND A.VERSION_NO    = B.OLD_VALUE2
                        AND A.FROM_SITE     = B.OLD_VALUE3
                        AND A.TO_SITE       = B.OLD_VALUE5
                        AND CUTOFF_DATE >= @CUTOFF_FROM
                        AND CUTOFF_DATE < @CUTOFF_TO

                        --2025-03-14 막음
                        --select count(*)
                        --from SCP_ANL_SHIPMENT_PLAN_FG_C  with (nolock)
                        --where CUTOFF_DATE >= @CUTOFF_FROM
                        -- AND CUTOFF_DATE < @@CUTOFF_TO
                        --and from_SITE in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' AND ATTRIBUTE5 = @P_ROLLIN )


                    SET @MAPPING_RESULT = 'Y';
                    END

                -- CUTOFF_DATE
                -- NO INDEX => 소요시간 매우 김
                -- CUTOFF_DATE + DIV 보다는 DIV 업는 편이 바람직해 보임
                -- 1시간 30분 이상 소요
                -- INDEX 생성 고려 할 것
                -- 20241201 적용
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK'
                    BEGIN

                    /*
                    SCM_DNM_STOCK   COMPANY_ID      COMPANY_ID
                    SCM_DNM_STOCK   PLANT_ID        PLANT_ID
                    SCM_DNM_STOCK   SCM_SITE_ID     SCM_SITE_ID
                    SCM_DNM_STOCK   STORAGE_ID      STORAGE_ID
                    SCM_DNM_STOCK   FROM_SLOC_ID    STORAGE_ID
                    SCM_DNM_STOCK   MES_MAP_SLOC    STORAGE_ID
                    */
                    Print CONCAT(@TABLE_NAME, ', ' + @cutoff_from, ', ' + @cutoff_to, ', ' + @DIVISION, ', ' + @PLAN_TYPE)

                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = @TABLE_NAME
                    AND NEW_VALUE9 = @CUTOFF_FROM
                    AND NEW_VALUE10 = @DIVISION
                    --------------------------------------------------------------------------------------
                    -- 3248 51초
                    SELECT COMPANY_ID, PLANT_ID, SCM_SITE_ID, STORAGE_ID,FROM_SLOC_ID,MES_MAP_SLOC,count(*) AS CNT
                      INTO #TMP_SCM_DNM_STOCK
                      FROM SCM_DNM_STOCK A WITH (INDEX(IDX02_SCM_DNM_STOCK), nolock)
                    where CUTOFF_DATE = @CUTOFF_FROM
                      and division_id = @DIVISION
                  GROUP BY COMPANY_ID, PLANT_ID, SCM_SITE_ID, STORAGE_ID,FROM_SLOC_ID,MES_MAP_SLOC


                    --------------------------------------------------------------------------------------
                    -- 3248 51초
                     SELECT COMPANY_ID, PLANT_ID, SCM_SITE_ID, STORAGE_ID,FROM_SLOC_ID,MES_MAP_SLOC, CNT
                           ,B.NEW_VALUE1 AS TOBE_COMPANY_ID
                           ,isnull(C.NEW_VALUE1, c2.NEW_VALUE1) AS TOBE_PLANT_ID -- 20241231
                           ,D.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                           ,E.NEW_VALUE2 AS TOBE_STORAGE_ID
                           ,F.NEW_VALUE2 AS TOBE_FROM_SLOC_ID
                           ,G.NEW_VALUE2 AS TOBE_MES_MAP_SLOC
                      INTO #TMP_SCM_DNM_STOCK_CONV
                        FROM #TMP_SCM_DNM_STOCK A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID  B ON A.COMPANY_ID = B.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID    C ON A.PLANT_ID = C.OLD_VALUE1
                        LEFT JOIN #TMP_VENDOR_ID   C2 ON A.PLANT_ID = C2.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID D ON A.SCM_SITE_ID = D.OLD_VALUE1
                        LEFT JOIN #TMP_STORAGE_ID E ON A.PLANT_ID = E.OLD_VALUE1 AND A.STORAGE_ID   = E.OLD_VALUE2
                        LEFT JOIN #TMP_STORAGE_ID F ON A.PLANT_ID = F.OLD_VALUE1 AND A.FROM_SLOC_ID = F.OLD_VALUE2
                        LEFT JOIN #TMP_STORAGE_ID G ON A.PLANT_ID = G.OLD_VALUE1 AND A.MES_MAP_SLOC = G.OLD_VALUE2


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_DNM_STOCK



                    --------------------------------------------------------------------------------------
                    -- 3248 51초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           @TABLE_NAME
                         ,'COMPANY_ID', 'PLANT_ID', 'SCM_SITE_ID', 'STORAGE_ID', 'FROM_SLOC_ID', 'MES_MAP_SLOC'
                         , COMPANY_ID, PLANT_ID, SCM_SITE_ID, STORAGE_ID,FROM_SLOC_ID,MES_MAP_SLOC
                         , TOBE_COMPANY_ID
                         , TOBE_PLANT_ID
                         , TOBE_SCM_SITE_ID
                         , TOBE_STORAGE_ID
                         , TOBE_FROM_SLOC_ID
                         , TOBE_MES_MAP_SLOC
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY_ID,'')   != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PLANT_ID,'')     != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_ID,'')  != '' THEN 'Y'
                                WHEN ISNULL(TOBE_STORAGE_ID,'')   != '' THEN 'Y'
                                WHEN ISNULL(TOBE_FROM_SLOC_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_MES_MAP_SLOC,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         ,@CUTOFF_FROM, @DIVISION
                    FROM #TMP_SCM_DNM_STOCK_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_DNM_STOCK_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,OLD_VALUE6
                          ,OLD_VALUE7
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE6
                    )
                    SELECT OLD_VALUE1=ISNULL(B.OLD_VALUE1,'')
                          ,OLD_VALUE2=ISNULL(B.OLD_VALUE2,'')
                          ,OLD_VALUE3=ISNULL(B.OLD_VALUE3,'')
                          ,OLD_VALUE4=ISNULL(B.OLD_VALUE4,'')
                          ,OLD_VALUE5=ISNULL(B.OLD_VALUE5,'')
                          ,OLD_VALUE6=ISNULL(B.OLD_VALUE6,'')
                          ,OLD_VALUE7
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE6
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @DIVISION;

                      UPDATE SCM_DNM_STOCK
                         SET SCM_DNM_STOCK.COMPANY_ID   = ISNULL(B.NEW_VALUE1, A.COMPANY_ID   )
                            ,SCM_DNM_STOCK.PLANT_ID     = ISNULL(B.NEW_VALUE2, A.PLANT_ID     )
                            ,SCM_DNM_STOCK.SCM_SITE_ID  = ISNULL(B.NEW_VALUE3, A.SCM_SITE_ID  )
                            ,SCM_DNM_STOCK.STORAGE_ID   = ISNULL(B.NEW_VALUE4, A.STORAGE_ID   )
                            ,SCM_DNM_STOCK.FROM_SLOC_ID = ISNULL(B.NEW_VALUE5, A.FROM_SLOC_ID )
                            ,SCM_DNM_STOCK.MES_MAP_SLOC = ISNULL(B.NEW_VALUE6, A.MES_MAP_SLOC )
                            ,SCM_DNM_STOCK.ATTRIBUTE10  = @CREATED_BY
                       FROM .SCM_DNM_STOCK AS A  WITH (INDEX(IDX02_SCM_DNM_STOCK)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,OLD_VALUE5
                    --        ,OLD_VALUE6
                    --        ,OLD_VALUE7
                    --        ,NEW_VALUE1
                    --        ,NEW_VALUE2
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE4
                    --        ,NEW_VALUE5
                    --        ,NEW_VALUE6
                    -- FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    -- where table_name = @TABLE_NAME
                    --  and CHANGE_YN = 'Y'
                    --  AND NEW_VALUE9 = @CUTOFF_FROM
                    --  AND NEW_VALUE10 = @DIVISION
                    -- ) AS B
                      WHERE 1 = 1
                        --AND ISNULL(A.COMPANY_ID     ,'')        = ISNULL(B.OLD_VALUE1,'')
                        --AND ISNULL(A.PLANT_ID       ,'')        = ISNULL(B.OLD_VALUE2,'')
                        --AND ISNULL(A.SCM_SITE_ID    ,'')        = ISNULL(B.OLD_VALUE3,'')
                        --AND ISNULL(A.STORAGE_ID     ,'')        = ISNULL(B.OLD_VALUE4,'')
                        --AND ISNULL(A.FROM_SLOC_ID   ,'')        = ISNULL(B.OLD_VALUE5,'')
                        --AND ISNULL(A.MES_MAP_SLOC   ,'')        = ISNULL(B.OLD_VALUE6,'')
                        AND ISNULL(A.COMPANY_ID     ,'')        = B.OLD_VALUE1
                        AND ISNULL(A.PLANT_ID       ,'')        = B.OLD_VALUE2
                        AND ISNULL(A.SCM_SITE_ID    ,'')        = B.OLD_VALUE3
                        AND ISNULL(A.STORAGE_ID     ,'')        = B.OLD_VALUE4
                        AND ISNULL(A.FROM_SLOC_ID   ,'')        = B.OLD_VALUE5
                        AND ISNULL(A.MES_MAP_SLOC   ,'')        = B.OLD_VALUE6
                        AND A.CUTOFF_DATE = @CUTOFF_FROM
                        and A.division_id = @DIVISION


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- 20241201 SCP_PLAN_START_YYYYMMDD + Division_ID
                ELSE IF @TABLE_NAME = 'SCP_ANL_MAT_SUPPLY'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @DIVISION

                    --------------------------------------------------------------------------------------
                    SELECT DIVISION_ID, COMPANY, PLANT_ID , count(*) AS CNT
                      INTO #TMP_SCP_ANL_MAT_SUPPLY
                      FROM SCP_ANL_MAT_SUPPLY A with (index (PK_SCP_ANL_MAT_SUPPLY), nolock)
                    where SCP_PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and division_id = @DIVISION
                    --and PLAN_START_YYYYMMDD >= @CUTOFF_START
                  group by DIVISION_ID, COMPANY, PLANT_ID



                    --------------------------------------------------------------------------------------
                     SELECT DIVISION_ID, COMPANY, PLANT_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_COMPANY
                           ,NS2.NEW_VALUE1 AS TOBE_PLANT_ID
                        INTO #TMP_SCP_ANL_MAT_SUPPLY_CONV
                        FROM #TMP_SCP_ANL_MAT_SUPPLY A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID NS1 ON A.COMPANY = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID NS2 ON A.PLANT_ID = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_MAT_SUPPLY


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          @TABLE_NAME
                         ,'DIVISION_ID', 'COMPANY', 'PLANT_ID'
                         , DIVISION_ID, COMPANY, PLANT_ID
                         , TOBE_COMPANY
                         , TOBE_PLANT_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@DIVISION
                    FROM #TMP_SCP_ANL_MAT_SUPPLY_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_MAT_SUPPLY_CONV

                    --SELECT OLD_VALUE1,OLD_VALUE2,OLD_VALUE3, new_value1, new_value2
                    --  FROM NERP_CONV_SCP_DATA_BIG with (nolock) where table_name = 'SCP_ANL_MAT_SUPPLY' and CHANGE_YN = 'Y'
                    --   AND NEW_VALUE9 = @CUTOFF_FROM
                    --   AND NEW_VALUE10 = @DIVISION




                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1=ISNULL(B.OLD_VALUE1,'')
                          ,OLD_VALUE2=ISNULL(B.OLD_VALUE2,'')
                          ,OLD_VALUE3=ISNULL(B.OLD_VALUE3,'')
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9=ISNULL(B.NEW_VALUE9,'')
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @DIVISION;

                      UPDATE SCP_ANL_MAT_SUPPLY
                         SET SCP_ANL_MAT_SUPPLY.COMPANY = ISNULL(B.new_value1, A.COMPANY)
                            ,SCP_ANL_MAT_SUPPLY.PLANT_ID= ISNULL(B.new_value2, A.PLANT_ID)
                            ,SCP_ANL_MAT_SUPPLY.ATTRIBUTE10 = @CREATED_BY
                       FROM .SCP_ANL_MAT_SUPPLY AS A with (index (PK_SCP_ANL_MAT_SUPPLY)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2,OLD_VALUE3, new_value1, new_value2, new_value9, new_value10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock) where table_name = 'SCP_ANL_MAT_SUPPLY' and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 = @CUTOFF_FROM
                    --    AND NEW_VALUE10 = @DIVISION
                    --   ) AS B
                      WHERE 1 = 1
                        --AND ISNULL(A.DIVISION_ID,'')                    = ISNULL(B.OLD_VALUE1,'')
                        --AND ISNULL(A.COMPANY    ,'')                    = ISNULL(B.OLD_VALUE2,'')
                        --and ISNULL(A.PLANT_ID   ,'')                    = ISNULL(B.OLD_VALUE3,'')
                        --and ISNULL(A.SCP_PLAN_START_YYYYMMDD    ,'')    = ISNULL(B.NEW_VALUE9,'')
                        AND ISNULL(A.DIVISION_ID,'')                    = B.OLD_VALUE1
                        AND ISNULL(A.COMPANY    ,'')                    = B.OLD_VALUE2
                        and ISNULL(A.PLANT_ID   ,'')                    = B.OLD_VALUE3
                        and ISNULL(A.SCP_PLAN_START_YYYYMMDD    ,'')    = B.NEW_VALUE9
                        AND A.SCP_PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.DIVISION_ID = @DIVISION

                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241201 SCP_PLAN_START_YYYYMMDD + Division_ID
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_GLOBAL_SMALL'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE8 = @CUTOFF_FROM
                            AND NEW_VALUE9 = @DIVISION
                            AND NEW_VALUE10 = @PLAN_TYPE

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE , Attribute9,  count(*) AS CNT
                      INTO #TMP_SCP_ANL_PSI_GLOBAL_SMALL
                      FROM SCP_ANL_PSI_GLOBAL_SMALL A with (index (PK_SCP_ANL_PSI_GLOBAL_SMALL), nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and division_id = @DIVISION
                      and PLAN_TYPE = @PLAN_TYPE
                  group by FROM_SITE, TO_SITE ,Attribute9



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, Attribute9, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                           ,NS3.NEW_VALUE1 AS TOBE_Attribute9
                        INTO #TMP_SCP_ANL_PSI_GLOBAL_SMALL_CONV
                        FROM #TMP_SCP_ANL_PSI_GLOBAL_SMALL A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_VENDOR_ID NS3 ON A.Attribute9 = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_GLOBAL_SMALL


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_PSI_GLOBAL_SMALL'
                         ,'FROM_SITE', 'TO_SITE', 'ATTRIBUTE9'
                         , FROM_SITE, TO_SITE, ATTRIBUTE9
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , TOBE_ATTRIBUTE9
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_ATTRIBUTE9,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@DIVISION
                        ,@PLAN_TYPE
                    FROM #TMP_SCP_ANL_PSI_GLOBAL_SMALL_CONV C with (nolock)



                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_GLOBAL_SMALL_CONV


                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      UPDATE SCP_ANL_PSI_GLOBAL_SMALL
                         SET SCP_ANL_PSI_GLOBAL_SMALL.FROM_SITE     = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_ANL_PSI_GLOBAL_SMALL.TO_SITE       = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_ANL_PSI_GLOBAL_SMALL.ATTRIBUTE9    = ISNULL(B.new_value3, A.ATTRIBUTE9)
                            --2025-10-03 SCP 화면에서 사용하는 컬럼이라서 UPDATE 하면 안되서어 막음.
                            --,SCP_ANL_PSI_GLOBAL_SMALL.ATTRIBUTE10   = @CREATED_BY
                       FROM .SCP_ANL_PSI_GLOBAL_SMALL AS A with (index (PK_SCP_ANL_PSI_GLOBAL_SMALL)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(

                    --SELECT OLD_VALUE1,OLD_VALUE2,OLD_VALUE3, new_value1, new_value2, new_value3, NEW_VALUE9, NEW_VALUE10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --  where table_name = @TABLE_NAME
                    --    and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE8 = @CUTOFF_FROM
                    --    AND NEW_VALUE9 = @DIVISION
                    --    AND NEW_VALUE10 = @PLAN_TYPE
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.DIVISION_ID         = @DIVISION
                        AND A.PLAN_TYPE           = @PLAN_TYPE



                    SET @MAPPING_RESULT = 'Y';
                    END


                -- PLAN_NAME without div
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_BOD_N_V_PLAN_H'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @CUTOFF_TO

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_ANL_BOD_N_V_PLAN_H
                      FROM SCP_ANL_BOD_N_V_PLAN_H A with (index (IX01_SCP_ANL_BOD_N_V_PLAN_H), nolock)
                    where PLAN_NAME =  @CUTOFF_FROM
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_BOD_N_V_PLAN_H_CONV
                        FROM #TMP_SCP_ANL_BOD_N_V_PLAN_H A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_BOD_N_V_PLAN_H


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_BOD_N_V_PLAN_H'
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@CUTOFF_TO
                    FROM #TMP_SCP_ANL_BOD_N_V_PLAN_H_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_BOD_N_V_PLAN_H_CONV


                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @CUTOFF_TO;


                      UPDATE SCP_ANL_BOD_N_V_PLAN_H
                         SET SCP_ANL_BOD_N_V_PLAN_H.FROM_SITE   = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_ANL_BOD_N_V_PLAN_H.TO_SITE     = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_ANL_BOD_N_V_PLAN_H.ATTRIBUTE10 = @CREATED_BY
                       FROM .SCP_ANL_BOD_N_V_PLAN_H AS A with (index (IX01_SCP_ANL_BOD_N_V_PLAN_H)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, NEW_VALUE9, NEW_VALUE10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --  where table_name = @TABLE_NAME
                    --    and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 = @CUTOFF_FROM
                    --    AND NEW_VALUE10 = @CUTOFF_TO
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        and A.PLAN_NAME     = B.NEW_VALUE9
                        AND A.PLAN_NAME     = @CUTOFF_FROM

                    SET @MAPPING_RESULT = 'Y';
                    END


                -- RESULT_dATE without div
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCM_DNM_INTRANSIT_C'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE10 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    SELECT COMPANY_ID, PLANT_ID, CUSTOMER_CODE, FINAL_SOLDTO_CODE, SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID,  count(*) AS CNT
                      INTO #TMP_SCM_DNM_INTRANSIT_C
                      FROM SCM_DNM_INTRANSIT_C A with (index (IDX04_SCM_DNM_INTRANSIT_C), nolock)
                      where RESULT_DATE >=  @CUTOFF_FROM
                        and RESULT_DATE <  @CUTOFF_TO
                   group by COMPANY_ID, PLANT_ID, CUSTOMER_CODE, FINAL_SOLDTO_CODE, SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID





                    --------------------------------------------------------------------------------------
                    SELECT COMPANY_ID, PLANT_ID, CUSTOMER_CODE, FINAL_SOLDTO_CODE, SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID, CNT

                           ,NC1.NEW_VALUE1 AS TOBE_COMPANY_ID
                           ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                           ,NCU1.NEW_VALUE1 AS TOBE_CUSTOMER_CODE
                           ,NCU2.NEW_VALUE1 AS TOBE_FINAL_SOLDTO_CODE
                           ,NCU3.NEW_VALUE1 AS TOBE_SHIPTO_CODE
                           ,NSCM1.NEW_VALUE1 AS TOBE_FROM_SCM_SITE_ID
                           ,NSCM2.NEW_VALUE1 AS TOBE_TO_SCM_SITE_ID

                        INTO #TMP_SCM_DNM_INTRANSIT_C_CONV
                        FROM #TMP_SCM_DNM_INTRANSIT_C A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID NC1 ON A.COMPANY_ID = NC1.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID NP1 ON A.PLANT_ID = NP1.OLD_VALUE1
                        LEFT JOIN #TMP_END_CUSTOMER_ID NCU1 ON A.CUSTOMER_CODE      = NCU1.OLD_VALUE1
                        LEFT JOIN #TMP_END_CUSTOMER_ID NCU2 ON A.FINAL_SOLDTO_CODE  = NCU2.OLD_VALUE1
                        LEFT JOIN #TMP_END_CUSTOMER_ID NCU3 ON A.SHIPTO_CODE        = NCU3.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NSCM1 ON A.FROM_SCM_SITE_ID = NSCM1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NSCM2 ON A.TO_SCM_SITE_ID   = NSCM2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_DNM_INTRANSIT_C


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                    , COLUMN_NAME1,COLUMN_NAME2 ,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6, OLD_VALUE7
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6, NEW_VALUE7
                    , CNT_ASIS
                    , CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                           'SCM_DNM_INTRANSIT_C'
                         , 'COMPANY_ID' , 'PLANT_ID', 'CUSTOMER_CODE' , 'FINAL_SOLDTO_CODE', 'SHIPTO_CODE', 'FROM_SCM_SITE_ID' , 'TO_SCM_SITE_ID'
                         ,  COMPANY_ID, PLANT_ID, CUSTOMER_CODE, FINAL_SOLDTO_CODE, SHIPTO_CODE, FROM_SCM_SITE_ID, TO_SCM_SITE_ID
                         , TOBE_COMPANY_ID
                         , TOBE_PLANT_ID
                         , TOBE_CUSTOMER_CODE
                         , TOBE_FINAL_SOLDTO_CODE
                         , TOBE_SHIPTO_CODE
                         , TOBE_FROM_SCM_SITE_ID
                         , TOBE_TO_SCM_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_CUSTOMER_CODE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_FINAL_SOLDTO_CODE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SHIPTO_CODE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_FROM_SCM_SITE_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SCM_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                          , @CUTOFF_FROM
                    FROM #TMP_SCM_DNM_INTRANSIT_C_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_DNM_INTRANSIT_C_CONV


                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                         , OLD_VALUE2
                         , OLD_VALUE3
                         , OLD_VALUE4
                         , OLD_VALUE5
                         , OLD_VALUE6
                         , OLD_VALUE7
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE3
                         , NEW_VALUE4
                         , NEW_VALUE5
                         , NEW_VALUE6
                         , NEW_VALUE7
                         , NEW_VALUE9
                         , NEW_VALUE10
                    )
                    SELECT OLD_VALUE1 = ISNULL(B.OLD_VALUE1, '')
                         , OLD_VALUE2 = ISNULL(B.OLD_VALUE2, '')
                         , OLD_VALUE3 = ISNULL(B.OLD_VALUE3, '')
                         , OLD_VALUE4 = ISNULL(B.OLD_VALUE4, '')
                         , OLD_VALUE5 = ISNULL(B.OLD_VALUE5, '')
                         , OLD_VALUE6 = ISNULL(B.OLD_VALUE6, '')
                         , OLD_VALUE7 = ISNULL(B.OLD_VALUE7, '')
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE3
                         , NEW_VALUE4
                         , NEW_VALUE5
                         , NEW_VALUE6
                         , NEW_VALUE7
                         , NEW_VALUE9
                         , NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM;

                      UPDATE SCM_DNM_INTRANSIT_C
                         SET SCM_DNM_INTRANSIT_C.COMPANY_ID         = ISNULL(B.new_value1, A.COMPANY_ID)
                            ,SCM_DNM_INTRANSIT_C.PLANT_ID           = ISNULL(B.new_value2, A.PLANT_ID)
                            ,SCM_DNM_INTRANSIT_C.CUSTOMER_CODE      = ISNULL(B.new_value3, A.CUSTOMER_CODE)
                            ,SCM_DNM_INTRANSIT_C.FINAL_SOLDTO_CODE  = ISNULL(B.new_value4, A.FINAL_SOLDTO_CODE)
                            ,SCM_DNM_INTRANSIT_C.SHIPTO_CODE        = ISNULL(B.new_value5, A.SHIPTO_CODE)
                            ,SCM_DNM_INTRANSIT_C.FROM_SCM_SITE_ID   = ISNULL(B.new_value6, A.FROM_SCM_SITE_ID)
                            ,SCM_DNM_INTRANSIT_C.TO_SCM_SITE_ID     = ISNULL(B.new_value7, A.TO_SCM_SITE_ID)
                            ,SCM_DNM_INTRANSIT_C.ATTRIBUTE10        = @CREATED_BY
                       FROM .SCM_DNM_INTRANSIT_C AS A with (index (IDX04_SCM_DNM_INTRANSIT_C)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(  SELECT OLD_VALUE1
                    --        , OLD_VALUE2
                    --        , OLD_VALUE3
                    --        , OLD_VALUE4
                    --        , OLD_VALUE5
                    --        , OLD_VALUE6
                    --        , OLD_VALUE7
                    --        , NEW_VALUE1
                    --        , NEW_VALUE2
                    --        , NEW_VALUE3
                    --        , NEW_VALUE4
                    --        , NEW_VALUE5
                    --        , NEW_VALUE6
                    --        , NEW_VALUE7
                    --        , NEW_VALUE9
                    --        , NEW_VALUE10
                    --FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --where table_name = 'SCM_DNM_INTRANSIT_C'
                    --and CHANGE_YN = 'Y'
                    --and NEW_VALUE10 = @CUTOFF_FROM
                    --) AS B
                      WHERE 1=1
                        --AND ISNULL(A.COMPANY_ID, '')        = ISNULL(B.OLD_VALUE1, '')
                        --AND ISNULL(A.PLANT_ID, '')          = ISNULL(B.OLD_VALUE2, '')
                        --AND ISNULL(A.CUSTOMER_CODE, '')     = ISNULL(B.OLD_VALUE3, '')
                        --AND ISNULL(A.FINAL_SOLDTO_CODE, '') = ISNULL(B.OLD_VALUE4, '')
                        --AND ISNULL(A.SHIPTO_CODE, '')       = ISNULL(B.OLD_VALUE5, '')
                        --AND ISNULL(A.FROM_SCM_SITE_ID, '')  = ISNULL(B.OLD_VALUE6, '')
                        --AND ISNULL(A.TO_SCM_SITE_ID, '')    = ISNULL(B.OLD_VALUE7, '')
                        AND ISNULL(A.COMPANY_ID, '')        = B.OLD_VALUE1
                        AND ISNULL(A.PLANT_ID, '')          = B.OLD_VALUE2
                        AND ISNULL(A.CUSTOMER_CODE, '')     = B.OLD_VALUE3
                        AND ISNULL(A.FINAL_SOLDTO_CODE, '') = B.OLD_VALUE4
                        AND ISNULL(A.SHIPTO_CODE, '')       = B.OLD_VALUE5
                        AND ISNULL(A.FROM_SCM_SITE_ID, '')  = B.OLD_VALUE6
                        AND ISNULL(A.TO_SCM_SITE_ID, '')    = B.OLD_VALUE7
                        AND A.RESULT_DATE       >= @CUTOFF_FROM
                        AND A.RESULT_DATE       < @CUTOFF_TO


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- SNAPSHOT_WEEK without div
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP_SNAPSHOT'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################

                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @CUTOFF_TO




                    -- 20 19초
                    SELECT PLANT_ID,count(*) AS CNT
                      INTO #TMP_SCM_DNM_MPP_SNAPSHOT
                      FROM SCM_DNM_MPP_SNAPSHOT A with (index (PK_SCM_DNM_MPP_SNAPSHOT), nolock)
                    where SNAPSHOT_WEEK =  @CUTOFF_FROM
                  group by PLANT_ID



                    --------------------------------------------------------------------------------------
                        -- 13 1초
                     SELECT PLANT_ID, CNT
                           ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                        INTO #TMP_SCM_DNM_MPP_SNAPSHOT_CONV
                        FROM #TMP_SCM_DNM_MPP_SNAPSHOT A WITH (NOLOCK)
                        LEFT JOIN #TMP_PLANT_ID NP1 ON A.PLANT_ID = NP1.OLD_VALUE1




                    --------------------------------------------------------------------------------------
                    -- 794 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1
                    , OLD_VALUE1
                    , NEW_VALUE1
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10

                    )
                    SELECT
                          'SCM_DNM_MPP_SNAPSHOT'
                         ,'PLANT_ID'
                         , PLANT_ID
                         , TOBE_PLANT_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        , @CUTOFF_FROM, @CUTOFF_TO
                    FROM #TMP_SCM_DNM_MPP_SNAPSHOT_CONV C with (nolock)
                    --------------------------------------------------------------------------------------
                    dROP TABLE #TMP_SCM_DNM_MPP_SNAPSHOT
                    dROP TABLE #TMP_SCM_DNM_MPP_SNAPSHOT_CONV


                    print 5

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                print @CUTOFF_FROM

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,NEW_VALUE1
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,NEW_VALUE1
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    1=1;

                      UPDATE SCM_DNM_MPP_SNAPSHOT
                         SET SCM_DNM_MPP_SNAPSHOT.PLANT_ID  = ISNULL(B.new_value1, A.PLANT_ID)
                       FROM .SCM_DNM_MPP_SNAPSHOT AS A  with (index (PK_SCM_DNM_MPP_SNAPSHOT)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,new_value1, NEW_VALUE9, NEW_VALUE10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --  where table_name = 'SCM_DNM_MPP_SNAPSHOT' and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.PLANT_ID          = B.OLD_VALUE1
                        AND A.SNAPSHOT_WEEK     = B.NEW_VALUE9
                        AND A.SNAPSHOT_WEEK     = @CUTOFF_FROM



                    SET @MAPPING_RESULT = 'Y';
                    END



                -- YYYYMM without div
                -- 20241201
                -- VALUATION_CLASS  BKLAS
                ELSE IF @TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @CUTOFF_TO


                    -- 20 19초
                    SELECT YYYYMM, COMPANY_ID, PLANT_ID,STORAGE_LOCATION, SUPPLIER_CODE,count(*) AS CNT
                      INTO #TMP_SCP_ANL_MONTH_END_STOCK_R
                      FROM SCP_ANL_MONTH_END_STOCK_R A  with (index (IX01_SCP_ANL_MONTH_END_STOCK_R), nolock)
                    where YYYYMM =  @CUTOFF_FROM
                  group by YYYYMM, COMPANY_ID, PLANT_ID,STORAGE_LOCATION, SUPPLIER_CODE


                    --------------------------------------------------------------------------------------
                        -- 13 1초
                      SELECT YYYYMM, COMPANY_ID, PLANT_ID, STORAGE_LOCATION, SUPPLIER_CODE
                           , NC.NEW_VALUE1 AS TOBE_COMPANY
                           , NP.NEW_VALUE1 AS TOBE_PLANT
                           , NST.NEW_VALUE1 AS TOBE_STORAGE_PLANT
                           , NST.NEW_VALUE2 AS TOBE_STORAGE
                           , NV.NEW_VALUE1 AS TOBE_SUPPLIER
                           , CNT
                    INTO #TMP_SCP_ANL_MONTH_END_STOCK_R_CONV
                    FROM #TMP_SCP_ANL_MONTH_END_STOCK_R
                    LEFT JOIN #TMP_COMPANY_ID AS NC ON NC.OLD_VALUE1 = COMPANY_ID
                    LEFT JOIN #TMP_PLANT_ID AS NP ON NP.OLD_VALUE1 = PLANT_ID
                    LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN
                                and OLD_VALUE1 IN (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN)
                                ) AS NST ON NST.OLD_VALUE1 = PLANT_ID
                                        AND NST.OLD_VALUE2 = STORAGE_LOCATION
                    LEFT JOIN #TMP_VENDOR_ID AS NV ON NV.OLD_VALUE1 = SUPPLIER_CODE
                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_MONTH_END_STOCK_R


                    --------------------------------------------------------------------------------------
                    -- 794 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5
                    , NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_MONTH_END_STOCK_R'
                         ,'YYYYMM' , 'COMPANY_ID', 'PLANT_ID', 'STORAGE_LOCATION' , 'SUPPLIER_CODE'
                         , YYYYMM , COMPANY_ID, PLANT_ID, STORAGE_LOCATION , SUPPLIER_CODE
                         , TOBE_COMPANY
                         , TOBE_PLANT
                         , TOBE_STORAGE
                         , TOBE_SUPPLIER
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PLANT,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_STORAGE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SUPPLIER,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        , @CUTOFF_FROM, @CUTOFF_TO
                    FROM #TMP_SCP_ANL_MONTH_END_STOCK_R_CONV C with (nolock)
                    --------------------------------------------------------------------------------------





                    DROP TABLE #TMP_SCP_ANL_MONTH_END_STOCK_R_CONV
                    print @CUTOFF_FROM

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2 = ISNULL(OLD_VALUE2,'')
                          ,OLD_VALUE3 = ISNULL(OLD_VALUE3,'')
                          ,OLD_VALUE4 = ISNULL(OLD_VALUE4,'')
                          ,OLD_VALUE5 = ISNULL(OLD_VALUE5,'')
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE9 = ISNULL(NEW_VALUE9,'')
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    1=1;

                     UPDATE SCP_ANL_MONTH_END_STOCK_R
                         SET SCP_ANL_MONTH_END_STOCK_R.COMPANY_ID       = ISNULL(B.NEW_VALUE2, A.COMPANY_ID)
                            ,SCP_ANL_MONTH_END_STOCK_R.PLANT_ID         = ISNULL(B.NEW_VALUE3, A.PLANT_ID)
                            ,SCP_ANL_MONTH_END_STOCK_R.STORAGE_LOCATION = ISNULL(B.NEW_VALUE4, A.STORAGE_LOCATION)
                            ,SCP_ANL_MONTH_END_STOCK_R.SUPPLIER_CODE    = ISNULL(B.NEW_VALUE5, A.SUPPLIER_CODE)
                            ,SCP_ANL_MONTH_END_STOCK_R.ATTRIBUTE15      = @CREATED_BY
                       FROM .SCP_ANL_MONTH_END_STOCK_R AS A  with (index (IX01_SCP_ANL_MONTH_END_STOCK_R)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,OLD_VALUE5
                    --        ,NEW_VALUE2
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE4
                    --        ,NEW_VALUE5
                    --        ,NEW_VALUE9
                    --FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --where table_name = 'SCP_ANL_MONTH_END_STOCK_R'
                    --and change_yn = 'Y'
                    --) AS B
                      WHERE 1 = 1
                        --AND A.COMPANY_ID                = B.OLD_VALUE2
                        --AND A.PLANT_ID                  = B.OLD_VALUE3
                        --AND A.STORAGE_LOCATION          = B.OLD_VALUE4
                        --AND A.SUPPLIER_CODE             = B.OLD_VALUE5
                        --AND A.YYYYMM                    = B.NEW_VALUE9
                        AND ISNULL(A.COMPANY_ID       ,'') = B.OLD_VALUE2
                        AND ISNULL(A.PLANT_ID         ,'') = B.OLD_VALUE3
                        AND ISNULL(A.STORAGE_LOCATION ,'') = B.OLD_VALUE4
                        AND ISNULL(A.SUPPLIER_CODE    ,'') = B.OLD_VALUE5
                        AND ISNULL(A.YYYYMM           ,'') = B.NEW_VALUE9
                        AND A.YYYYMM                       = @CUTOFF_FROM

                    --###############################################################################################################
                    -- #TEMP VALUATION_CLASSS
                    --###############################################################################################################
                    IF OBJECT_ID('tempdb..#TMPV_SCP_ANL_MONTH_END_STOCK_R') IS NOT NULL
                    BEGIN   
                    DROP TABLE #TMPV_SCP_ANL_MONTH_END_STOCK_R
                    END


                    select  YYYYMM
                          , VALUATION_CLASS
                          , CASE
                            WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RE01'   THEN '3001'
                            WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RE02'   THEN '3002'
                            WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RA01'   THEN '3003'
                            WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RA02'   THEN '3004'
                            WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') like 'RP%' THEN '3005'
                            WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') = 'RE02'   THEN '3002'
                            WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') = 'RA01'   THEN '3003'
                            WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') = 'RA02'   THEN '3004'
                            WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') like 'RP%' THEN '3005'
                            WHEN A.VALUATION_CLASS = '3001' THEN '3000'
                            ELSE NULL
                            END AS TOBE_VALUATION_CLASS
                            , MATKL, ITEM_ID
                    INTO #TMPV_SCP_ANL_MONTH_END_STOCK_R
                    from
                    (
                        select YYYYMM
                             , ITEM_ID
                             , isnull(tobe_MATKL,'') as MATKL
                             , VALUATION_CLASS
                        from SCP_ANL_MONTH_END_STOCK_R R with(nolock)
                        LEFT JOIN (SELECT NEW_VALUE1 as item
                                        , NEW_VALUE2 as tobe_MATKL
                                     FROM NERP_CONV_MASTER_CFM_V
                                    WHERE CODETYPE = 'MATKL'
                                      AND ATTRIBUTE5 = @P_ROLLIN
                                    ) E  ON R.ITEM_ID   = E.item
                        where YYYYMM =  @CUTOFF_FROM
                        and VALUATION_CLASS in ('3000','3001')
                        and isnull(tobe_MATKL,'') like 'R%'
                        group by YYYYMM, ITEM_ID, isnull(tobe_MATKL,''), VALUATION_CLASS
                    ) A
                    order by  YYYYMM, VALUATION_CLASS, MATKL, ITEM_ID


                    --###############################################################################################################
                    -- UPDATE VALUATION_CLASSS
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    --사용하지 않음
                    --DELETE
                    --FROM @TMP_CONV_SCP_DATA_BIG;
                    --INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                    --       OLD_VALUE1
                    --      ,OLD_VALUE2
                    --      ,OLD_VALUE3
                    --      ,OLD_VALUE4
                    --      ,OLD_VALUE5
                    --      ,OLD_VALUE6
                    --      ,NEW_VALUE3
                    --      ,NEW_VALUE4
                    --      ,NEW_VALUE5
                    --      ,NEW_VALUE6
                    --      ,NEW_VALUE9
                    --      ,NEW_VALUE10
                    --)
                    --SELECT OLD_VALUE1
                    --      ,OLD_VALUE2
                    --      ,OLD_VALUE3
                    --      ,OLD_VALUE4
                    --      ,OLD_VALUE5 = ISNULL(OLD_VALUE5,'')
                    --      ,OLD_VALUE6 = ISNULL(OLD_VALUE6,'')
                    --      ,NEW_VALUE3
                    --      ,NEW_VALUE4
                    --      ,NEW_VALUE5
                    --      ,NEW_VALUE6
                    --      ,NEW_VALUE9
                    --      ,NEW_VALUE10
                    --FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    --WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    --AND    NEW_VALUE9 = @CUTOFF_FROM
                    --AND    NEW_VALUE10 = @plan_type;


                      UPDATE SCP_ANL_MONTH_END_STOCK_R
                         SET SCP_ANL_MONTH_END_STOCK_R.VALUATION_CLASS  = ISNULL(B.TOBE_VALUATION_CLASS, A.VALUATION_CLASS)
                       FROM .SCP_ANL_MONTH_END_STOCK_R AS A,
                       (
                           SELECT *
                            FROM #TMPV_SCP_ANL_MONTH_END_STOCK_R
                            where isnull(TOBE_VALUATION_CLASS,'') != ''

                       ) AS B
                      WHERE 1 = 1
                        AND A.YYYYMM =  @CUTOFF_FROM
                        and A.item_id = B.item_id
                        and A.VALUATION_CLASS = B.VALUATION_CLASS
                        and A.VALUATION_CLASS in ('3000','3001')



                    SET @MAPPING_RESULT = 'Y';
                    END



                -- EFF_END_DATE
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE
                    from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCM_MST_MODEL_BOM_EFFECTIVE' and NEW_VALUE9 = @CUTOFF_FROM

                    --################################################################
                    -- 중복데이터 삭제 후 처리
                    --################################################################
                    IF @P_ROLLIN = '3RD' AND @DEL_BOM_DUP_YN = 'N'
                    --3차의 경우는 PLANT_ID DESC 이 중요하다. 큰것 남기고 작은 것 삭제. 3차는 작은것 삭제
                    BEGIN
                          --삭제하는 것 저장
                          ;WITH W_RAW AS (
                             SELECT ISNULL(NC1.NEW_VALUE1,COMPANY_ID) AS N_COMPANY_ID
                                  , DIVISION_ID AS N_DIVISION_ID
                                  , SITE_ID     AS N_SITE_ID
                                  , ISNULL(NP1.NEW_VALUE1,PLANT_ID)   AS N_PLANT_ID
                                  , MODEL_ID AS N_MODEL_ID
                                  , CONCATENATE_ITEM AS N_CONCATENATE_ITEM
                                  , EFF_START_DATE AS N_EFF_START_DATE
                                  , A.*
                                   ,NC1.NEW_VALUE1 AS TOBE_COMPANY_ID
                                   ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                                   ,ROW_NUMBER()OVER(PARTITION BY ISNULL(NC1.NEW_VALUE1,COMPANY_ID), DIVISION_ID, SITE_ID, ISNULL(NP1.NEW_VALUE1,PLANT_ID), MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE
                                                     ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID DESC, MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE) AS RNUM
                                FROM SCM_MST_MODEL_BOM_EFFECTIVE A WITH (NOLOCK)
                                LEFT JOIN #TMP_COMPANY_ID NC1 ON A.COMPANY_ID = NC1.OLD_VALUE1
                                LEFT JOIN #TMP_PLANT_ID NP1 ON A.PLANT_ID = NP1.OLD_VALUE1
                                WHERE 1=1
                                AND   (NC1.NEW_VALUE1 IS NOT NULL OR NP1.NEW_VALUE1 IS NOT NULL)
                          )
                          INSERT INTO NERP_CONV_SCP_DATA_BIG
                          (
                            TABLE_NAME
                          , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7
                          , OLD_VALUE1,OLD_VALUE2,OLD_VALUE3,OLD_VALUE4,OLD_VALUE5,OLD_VALUE6,OLD_VALUE7
                          , NEW_VALUE1,NEW_VALUE2,NEW_VALUE3,NEW_VALUE4,NEW_VALUE5,NEW_VALUE6,NEW_VALUE7
                          , CNT_TOBE
                          , CHANGE_YN
                          , NEW_VALUE9, NEW_VALUE10
                          )
                          SELECT
                                 'SCM_MST_MODEL_BOM_EFFECTIVE'
                               , 'COMPANY_ID','DIVISION_ID','SITE_ID','PLANT_ID','MODEL_ID','CONCATENATE_ITEM','EFF_START_DAT'
                               , COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE
                               , N_COMPANY_ID, N_DIVISION_ID, N_SITE_ID, N_PLANT_ID, N_MODEL_ID, N_CONCATENATE_ITEM, N_EFF_START_DATE
                               , RNUM
                               , 'X' AS CHANGE_YN
                              , @CUTOFF_FROM, @CUTOFF_TO
                          FROM   W_RAW AS WR
                          WHERE  RNUM >1;
                          --#############################
                          --변경되면 중복되는 것 사전 삭제
                          --#############################
                          ;WITH W_RAW AS (
                             SELECT ISNULL(NC1.NEW_VALUE1,COMPANY_ID) AS N_COMPANY_ID
                                  , DIVISION_ID AS N_DIVISION_ID
                                  , SITE_ID     AS N_SITE_ID
                                  , ISNULL(NP1.NEW_VALUE1,PLANT_ID)   AS N_PLANT_ID
                                  , MODEL_ID AS N_MODEL_ID
                                  , CONCATENATE_ITEM AS N_CONCATENATE_ITEM
                                  , EFF_START_DATE AS N_EFF_START_DATE
                                  , A.*
                                   ,NC1.NEW_VALUE1 AS TOBE_COMPANY_ID
                                   ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                                   ,ROW_NUMBER()OVER(PARTITION BY ISNULL(NC1.NEW_VALUE1,COMPANY_ID), DIVISION_ID, SITE_ID, ISNULL(NP1.NEW_VALUE1,PLANT_ID), MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE
                                                     ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID DESC, MODEL_ID, CONCATENATE_ITEM, EFF_START_DATE) AS RNUM
                                FROM SCM_MST_MODEL_BOM_EFFECTIVE A WITH (NOLOCK)
                                LEFT JOIN #TMP_COMPANY_ID NC1 ON A.COMPANY_ID = NC1.OLD_VALUE1
                                LEFT JOIN #TMP_PLANT_ID NP1 ON A.PLANT_ID = NP1.OLD_VALUE1
                                WHERE 1=1
                                AND   (NC1.NEW_VALUE1 IS NOT NULL OR NP1.NEW_VALUE1 IS NOT NULL)
                          )
                          DELETE MBE
                          FROM   W_RAW AS WR
                          JOIN   SCM_MST_MODEL_BOM_EFFECTIVE AS MBE with(nolock)
                          ON     WR.RNUM >1
                          AND    MBE.COMPANY_ID       = WR.COMPANY_ID
                          AND    MBE.DIVISION_ID      = WR.DIVISION_ID
                          AND    MBE.SITE_ID          = WR.SITE_ID
                          AND    MBE.PLANT_ID         = WR.PLANT_ID
                          AND    MBE.MODEL_ID         = WR.MODEL_ID
                          AND    MBE.CONCATENATE_ITEM = WR.CONCATENATE_ITEM
                          AND    MBE.EFF_START_DATE   = WR.EFF_START_DATE
                          ;

                        SET @DEL_BOM_DUP_YN = 'Y';
                    END;

                    --------------------------------------------------------------------------------------
                    --DECLARE @CUTOFF_DATE nvarchar(10) = '2024-09-01'

                    -- 48 3초
                    SELECT COMPANY_ID, PLANT_ID, CHILD_COMPANY_ID, CHILD_PLANT_ID, count(*) AS CNT
                      INTO #TMP_SCM_MST_MODEL_BOM_EFFECTIVE
                      FROM SCM_MST_MODEL_BOM_EFFECTIVE A with (index (PK_SCM_MST_MODEL_BOM_EFFECTIVE),nolock)
                      where EFF_END_DATE =  @CUTOFF_FROM
                       --and  EFF_END_DATE <  @CUTOFF_TO
                  group by COMPANY_ID, PLANT_ID, CHILD_COMPANY_ID, CHILD_PLANT_ID



                    --------------------------------------------------------------------------------------
                    -- 48 2초
                     SELECT COMPANY_ID, PLANT_ID, CHILD_COMPANY_ID, CHILD_PLANT_ID, CNT
                           ,NC1.NEW_VALUE1 AS TOBE_COMPANY_ID
                           ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                           ,NC2.NEW_VALUE1 AS TOBE_CHILD_COMPANY_ID
                           ,NP2.NEW_VALUE1 AS TOBE_CHILD_PLANT_ID
                        INTO #TMP_SCM_MST_MODEL_BOM_EFFECTIVE_CONV
                        FROM #TMP_SCM_MST_MODEL_BOM_EFFECTIVE A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID NC1 ON A.COMPANY_ID = NC1.OLD_VALUE1
                        LEFT JOIN #TMP_COMPANY_ID NC2 ON A.CHILD_COMPANY_ID = NC2.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID NP1 ON A.PLANT_ID = NP1.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID NP2 ON A.CHILD_PLANT_ID = NP2.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_MST_MODEL_BOM_EFFECTIVE

                    --------------------------------------------------------------------------------------
                    -- 49 4초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                    , COLUMN_NAME1,COLUMN_NAME2 ,COLUMN_NAME3,COLUMN_NAME4
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4
                    , CNT_ASIS
                    , CHANGE_YN
                    ,NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           'SCM_MST_MODEL_BOM_EFFECTIVE'
                         , 'COMPANY_ID' , 'PLANT_ID', 'CHILD_COMPANY_ID' , 'CHILD_PLANT_ID'
                         ,  COMPANY_ID, PLANT_ID,  CHILD_COMPANY_ID, CHILD_PLANT_ID
                         , TOBE_COMPANY_ID
                         , TOBE_PLANT_ID
                         , TOBE_CHILD_COMPANY_ID
                         , TOBE_CHILD_PLANT_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_CHILD_COMPANY_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_CHILD_PLANT_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        , @CUTOFF_FROM, @CUTOFF_TO
                    FROM #TMP_SCM_MST_MODEL_BOM_EFFECTIVE_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_MST_MODEL_BOM_EFFECTIVE_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                         , OLD_VALUE2
                         , OLD_VALUE3
                         , OLD_VALUE4
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE3
                         , NEW_VALUE4
                         , NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                         , OLD_VALUE2
                         , OLD_VALUE3
                         , OLD_VALUE4
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE3
                         , NEW_VALUE4
                         , NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    1=1;

                     --DECLARE @CUTOFF_DATE nvarchar(10) = '20240901'
                     -- 145492 16초
                      UPDATE A
                         SET A.COMPANY_ID         = ISNULL(B.new_value1, A.COMPANY_ID)
                            ,A.PLANT_ID           = ISNULL(B.new_value2, A.PLANT_ID)
                            ,A.CHILD_COMPANY_ID   = ISNULL(B.new_value3, A.CHILD_COMPANY_ID)
                            ,A.CHILD_PLANT_ID     = ISNULL(B.new_value4, A.CHILD_PLANT_ID)
                            ,A.ATTRIBUTE10        = @CREATED_BY
                       FROM .SCM_MST_MODEL_BOM_EFFECTIVE AS A with (index (PK_SCM_MST_MODEL_BOM_EFFECTIVE)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(  SELECT OLD_VALUE1
                    --        , OLD_VALUE2
                    --        , OLD_VALUE3
                    --        , OLD_VALUE4
                    --        , NEW_VALUE1
                    --        , NEW_VALUE2
                    --        , NEW_VALUE3
                    --        , NEW_VALUE4
                    --        , NEW_VALUE9
                    --FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --where table_name = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                    --and CHANGE_YN = 'Y'
                    --) AS B
                      WHERE A.COMPANY_ID            = B.OLD_VALUE1
                        AND A.PLANT_ID              = B.OLD_VALUE2
                        AND A.CHILD_COMPANY_ID      = B.OLD_VALUE3
                        AND A.CHILD_PLANT_ID        = B.OLD_VALUE4
                        AND A.EFF_END_DATE          = @CUTOFF_FROM
                        --AND A.EFF_END_DATE        <  @CUTOFF_TO

                    SET @MAPPING_RESULT = 'Y';
                    END



                -- 20241201 PLNA_START_YYYYMMDD -> CUToff
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                    BEGIN

                    --################################################################
                    /*-- NERP_CONV_SCP_DATA_BIG 에 입력
                    SCP_ANL_SHIPMENT_PLAN_SEMI_C    FROM_SITE       SCM_SITE_ID
                    SCP_ANL_SHIPMENT_PLAN_SEMI_C    FROM_SITE_NAME  SCM_SITE_DESCRIPTION
                    SCP_ANL_SHIPMENT_PLAN_SEMI_C    TO_SITE         SCM_SITE_ID
                    SCP_ANL_SHIPMENT_PLAN_SEMI_C    TO_SITE_NAME    SCM_SITE_DESCRIPTION
                    */
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                    AND NEW_VALUE10 = @CUTOFF_FROM
                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240921'
                    --------------------------------------------------------------------------------------
                    -- 343 27초
                    SELECT division_id, FROM_SITE, FROM_SITE_NAME,TO_SITE,TO_SITE_NAME,count(*) AS CNT
                      INTO #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_C
                      FROM SCP_ANL_SHIPMENT_PLAN_SEMI_C A with (index(IX01_SCP_ANL_SHIPMENT_PLAN_SEMI_C), nolock)
                    WHERE CUTOFF_DATE >= @CUTOFF_FROM
                      and CUTOFF_DATE < @CUTOFF_TO

                  group by division_id, FROM_SITE, FROM_SITE_NAME,TO_SITE,TO_SITE_NAME


                    --------------------------------------------------------------------------------------
                    -- 343 1초
                     SELECT division_id, FROM_SITE, FROM_SITE_NAME,TO_SITE,TO_SITE_NAME, CNT
                           ,B.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,C.NEW_VALUE1 AS TOBE_TO_SITE
                           ,D.NEW_VALUE1 AS TOBE_FROM_SITE_NAME
                           ,E.NEW_VALUE1 AS TOBE_TO_SITE_NAME
                      INTO #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_C_CONV
                        FROM #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_C A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID B ON A.FROM_SITE = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.TO_SITE = C.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_DESCRIPTION D ON A.FROM_SITE_NAME = D.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_DESCRIPTION E ON A.TO_SITE_NAME = E.OLD_VALUE1



                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_C

                    --------------------------------------------------------------------------------------
                    -- 343 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5
                    , NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                           'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                         ,'DIVISION_ID', 'FROM_SITE', 'TO_SITE', 'FROM_SITE_NAME', 'TO_SITE_NAME'
                         , DIVISION_ID, FROM_SITE, TO_SITE, FROM_SITE_NAME, TO_SITE_NAME
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , TOBE_FROM_SITE_NAME
                         , TOBE_TO_SITE_NAME
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_FROM_SITE_NAME,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE_NAME,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        , @CUTOFF_FROM
                    FROM #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_C_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_C_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM;

                    /*
                    -- Division 별로 Loop 예정
                    -------------------------------------------
                    select distinct OPERATION_ID, scm_site_id
                    from HIST_SCP_ANL_PRODUCTION_PLAN
                    where PLAN_START_YYYYMMDD = '20240923'
                    and DIVISION_ID = 'EE'
                    and ATTRIBUTE10 = @CREATED_BY
                    order by scm_site_id, OPERATION_ID

                    */

                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240921'
                    --DECLARE @P_DIVISION_ID nvarchar(10) = '81'
                     -- 366548 68초
                      UPDATE SCP_ANL_SHIPMENT_PLAN_SEMI_C
                         SET SCP_ANL_SHIPMENT_PLAN_SEMI_C.FROM_SITE         = ISNULL(B.NEW_VALUE2, A.FROM_SITE)
                            ,SCP_ANL_SHIPMENT_PLAN_SEMI_C.TO_SITE           = ISNULL(B.NEW_VALUE3, A.TO_SITE)
                            ,SCP_ANL_SHIPMENT_PLAN_SEMI_C.FROM_SITE_NAME    = ISNULL(B.NEW_VALUE4, A.FROM_SITE_NAME)
                            ,SCP_ANL_SHIPMENT_PLAN_SEMI_C.TO_SITE_NAME      = ISNULL(B.NEW_VALUE5, A.TO_SITE_NAME)
                            ,SCP_ANL_SHIPMENT_PLAN_SEMI_C.ATTRIBUTE10       = @CREATED_BY
                       FROM .SCP_ANL_SHIPMENT_PLAN_SEMI_C AS A with (index(IX01_SCP_ANL_SHIPMENT_PLAN_SEMI_C)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,OLD_VALUE5
                    --        ,NEW_VALUE2
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE4
                    --        ,NEW_VALUE5
                    --        ,NEW_VALUE9
                    -- FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    -- where table_name = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                    -- and CHANGE_YN = 'Y'
                    -- and NEW_VALUE10 = @CUTOFF_FROM

                    -- ) AS B
                      WHERE 1 = 1
                        AND A.DIVISION_ID           = B.OLD_VALUE1
                        AND A.FROM_SITE             = B.OLD_VALUE2
                        AND A.TO_SITE               = B.OLD_VALUE3
                        AND A.CUTOFF_DATE >= @CUTOFF_FROM
                        and A.CUTOFF_DATE < @CUTOFF_TO



                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241201 PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                    and new_value10 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 133 20초
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI
                      FROM SCP_ANL_SHIPMENT_PLAN_SEMI A with (index (PK_SCP_ANL_SHIPMENT_PLAN_SEMI),nolock)
                    where PLAN_START_YYYYMMDD = @CUTOFF_FROM
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                    -- 133 5초
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_CONV
                        FROM #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI

                    --------------------------------------------------------------------------------------
                    -- 133 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_SHIPMENT_PLAN_SEMI'
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM
                    FROM #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_SEMI_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    1=1;


                      -- 7분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40     279188 21초
                      -- 81     309033 48초
                      -- 82     100464 15초
                      -- EE     876512 2분 16초
                      UPDATE A
                         SET A.FROM_SITE   = ISNULL(B.new_value1, A.FROM_SITE)
                            ,A.TO_SITE     = ISNULL(B.new_value2, A.TO_SITE)
                            ,A.ATTRIBUTE10 = @CREATED_BY
                       FROM SCP_ANL_SHIPMENT_PLAN_SEMI AS A with (index (PK_SCP_ANL_SHIPMENT_PLAN_SEMI)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, new_value9,new_value10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                    --   and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD  =  @CUTOFF_FROM
                        --AND A.division_id = 'EE'


                    SET @MAPPING_RESULT = 'Y';
                    END



                -- BASIS_YYYYMMDD
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCM_KPI_SUMMARY'
                    BEGIN



                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################

                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCM_KPI_SUMMARY'
                    and new_value9 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    --DECLARE @BASIS_YYYYMMDD nvarchar(10) = '20240901'
                    -- 820 1초
                    SELECT BASIS_YYYYMMDD, DIVISION_ID, KPI_TYPE, SALES_SITE_ID,count(*) AS CNT
                      INTO #TMP_SCM_KPI_SUMMARY
                      FROM SCM_KPI_SUMMARY A with (index=IX01_SCM_KPI_SUMMARY, nolock)
                    where BASIS_YYYYMMDD =  @CUTOFF_FROM
                      --AND BASIS_YYYYMMDD <  @CUTOFF_TO
                  group by BASIS_YYYYMMDD, DIVISION_ID, KPI_TYPE, SALES_SITE_ID
                  order by BASIS_YYYYMMDD, DIVISION_ID, KPI_TYPE, SALES_SITE_ID

                    --------------------------------------------------------------------------------------
                    -- 820 1초
                     SELECT BASIS_YYYYMMDD, DIVISION_ID, KPI_TYPE, SALES_SITE_ID, CNT
                           ,B.NEW_VALUE1 AS TOBE_SALES_SITE_ID
                        INTO #TMP_SCM_KPI_SUMMARY_CONV
                        FROM #TMP_SCM_KPI_SUMMARY A
                        LEFT JOIN #TMP_SCP_SITE_ID B ON A.SALES_SITE_ID = B.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_KPI_SUMMARY

                    --------------------------------------------------------------------------------------
                    -- 794 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4
                    , NEW_VALUE3
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCM_KPI_SUMMARY'
                         ,'BASIS_YYYYMMDD' , 'DIVISION_ID', 'KPI_TYPE', 'SALES_SITE_ID'
                         , BASIS_YYYYMMDD, DIVISION_ID, KPI_TYPE, SALES_SITE_ID
                         , TOBE_SALES_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_SALES_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @CUTOFF_TO
                    FROM #TMP_SCM_KPI_SUMMARY_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_KPI_SUMMARY_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,NEW_VALUE3
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,NEW_VALUE3
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    1=1;

                      --DECLARE @BASIS_YYYYMMDD  nvarchar(10) = '20240901'
                      --DECLARE @division_id nvarchar(10) = 'EE_UC'
                      UPDATE SCM_KPI_SUMMARY
                         SET SCM_KPI_SUMMARY.SALES_SITE_ID  = ISNULL(B.new_value3, A.SALES_SITE_ID)
                            ,SCM_KPI_SUMMARY.ATTRIBUTE10    = @CREATED_BY
                       FROM .SCM_KPI_SUMMARY AS A with (index (IX01_SCM_KPI_SUMMARY)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,new_value3
                    --        ,new_value9
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCM_KPI_SUMMARY'
                    --   and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.DIVISION_ID       = B.OLD_VALUE2
                        AND A.KPI_TYPE          = B.OLD_VALUE3
                        AND A.SALES_SITE_ID     = B.OLD_VALUE4
                      --AND A.BASIS_YYYYMMDD    = B.new_value9
                        AND A.BASIS_YYYYMMDD    = @CUTOFF_FROM
                      --AND A.DIVISION_ID       = @division_id


                    SET @MAPPING_RESULT = 'Y';
                    END



                -- plan_week
                -- 20241201 NO INDEX
                ELSE IF @TABLE_NAME = 'SCP_BI_FP_RESULT'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_BI_FP_RESULT'
                     and new_value9 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    --DECLARE @plan_week nvarchar(10) = '202430'
                    -- 20 19초
                    SELECT COMPANY_ID, OPERATION_ID , count(*) AS CNT
                      INTO #TMP_SCP_BI_FP_RESULT
                      FROM SCP_BI_FP_RESULT A with (nolock)
                    where plan_week =  @CUTOFF_FROM
                      --AND plan_week <  @CUTOFF_TO
                  group by COMPANY_ID, OPERATION_ID


                    --------------------------------------------------------------------------------------
                    -- 13 1초
                     SELECT COMPANY_ID, OPERATION_ID, CNT
                           ,NC.NEW_VALUE1 AS TOBE_COMPANY_ID
                           ,NV.NEW_VALUE1 AS TOBE_OPERATION_ID
                        INTO #TMP_SCP_BI_FP_RESULT_CONV
                        FROM #TMP_SCP_BI_FP_RESULT A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID NC ON A.COMPANY_ID = NC.OLD_VALUE1
                        LEFT JOIN #TMP_VENDOR_ID NV ON A.OPERATION_ID = NV.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_BI_FP_RESULT

                    --------------------------------------------------------------------------------------
                    -- 794 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_BI_FP_RESULT'
                         ,'COMPANY_ID', 'OPERATION_ID'
                         , COMPANY_ID, OPERATION_ID
                         , TOBE_COMPANY_ID
                         , TOBE_OPERATION_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_COMPANY_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_OPERATION_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @CUTOFF_TO
                    FROM #TMP_SCP_BI_FP_RESULT_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_BI_FP_RESULT_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @plan_type;

                      --DECLARE @plan_week nvarchar(10) = '202430'

                      -- 223181 21초
                      UPDATE SCP_BI_FP_RESULT
                         SET SCP_BI_FP_RESULT.COMPANY_ID    = ISNULL(B.new_value1, A.COMPANY_ID)
                            ,SCP_BI_FP_RESULT.OPERATION_ID  = ISNULL(B.new_value2, A.OPERATION_ID)
                            ,SCP_BI_FP_RESULT.ATTRIBUTE10   = @CREATED_BY
                       FROM .SCP_BI_FP_RESULT AS A,
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, new_value9
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_BI_FP_RESULT'
                    --   and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.COMPANY_ID        = B.OLD_VALUE1
                        AND A.OPERATION_ID      = B.OLD_VALUE2
                        AND A.plan_week         = B.NEW_VALUE9
                        AND A.plan_week         = @CUTOFF_FROM


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- CUTOFF_DATE
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_PRODUCTION_PLAN_C'
                    BEGIN
                    /*
                    SCP_ANL_PRODUCTION_PLAN_C   OPERATION_ID            VENDOR_ID
                    SCP_ANL_PRODUCTION_PLAN_C   SCM_SITE_DESCRIPTION    SCM_SITE_DESCRIPTION
                    SCP_ANL_PRODUCTION_PLAN_C   SCM_SITE_ID             SCM_SITE_ID
                    */
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_PRODUCTION_PLAN_C'
                    and new_value10 = @CUTOFF_FROM

                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240922'
                    --------------------------------------------------------------------------------------
                    -- 186 21초
                    SELECT OPERATION_ID, SCM_SITE_ID, SCM_SITE_DESCRIPTION, count(*) AS CNT
                      INTO #TMP_SCP_ANL_PRODUCTION_PLAN_C
                      FROM SCP_ANL_PRODUCTION_PLAN_C A with (index (IX02_SCP_ANL_PRODUCTION_PLAN_C), nolock)
                    WHERE CUTOFF_DATE >= @CUTOFF_FROM
                      and CUTOFF_DATE < @CUTOFF_TO
                  group by OPERATION_ID, SCM_SITE_ID, SCM_SITE_DESCRIPTION


                    --------------------------------------------------------------------------------------
                    -- 186  1초
                      SELECT OPERATION_ID, SCM_SITE_ID, SCM_SITE_DESCRIPTION, CNT
                            ,B.NEW_VALUE1 AS TOBE_OPERATION_ID
                            ,C.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                            ,D.NEW_VALUE1 AS TOBE_SCM_SITE_DESCRIPTION
                        INTO #TMP_SCP_ANL_PRODUCTION_PLAN_C_CONV
                        FROM #TMP_SCP_ANL_PRODUCTION_PLAN_C A WITH (NOLOCK)
                        LEFT JOIN #TMP_VENDOR_ID B       ON A.OPERATION_ID         = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C       ON A.SCM_SITE_ID          = C.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_DESCRIPTION D       ON A.SCM_SITE_DESCRIPTION = D.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PRODUCTION_PLAN_C

                    --------------------------------------------------------------------------------------
                    -- 485 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                           'SCP_ANL_PRODUCTION_PLAN_C'
                         ,'OPERATION_ID' , 'SCM_SITE_ID', 'SCM_SITE_DESCRIPTION'
                         , OPERATION_ID, SCM_SITE_ID, SCM_SITE_DESCRIPTION
                         , TOBE_OPERATION_ID
                         , TOBE_SCM_SITE_ID
                         , TOBE_SCM_SITE_DESCRIPTION
                         , CNT
                         , CASE WHEN ISNULL(TOBE_OPERATION_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_DESCRIPTION,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        , @CUTOFF_FROM
                    FROM #TMP_SCP_ANL_PRODUCTION_PLAN_C_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PRODUCTION_PLAN_C_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3 = ISNULL(B.OLD_VALUE3,'')
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM;


                    /*
                    40  208071 23초
                    81  540004 104초
                    82  102340 41초
                    EE  348089 92초

                    */
                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240922'
                    --DECLARE @P_DIVISION_ID nvarchar(10) = 'EE'
                      UPDATE SCP_ANL_PRODUCTION_PLAN_C
                         SET SCP_ANL_PRODUCTION_PLAN_C.OPERATION_ID        = ISNULL(B.NEW_VALUE1, A.OPERATION_ID)
                            ,SCP_ANL_PRODUCTION_PLAN_C.SCM_SITE_ID         = ISNULL(B.NEW_VALUE2, A.SCM_SITE_ID)
                            ,SCP_ANL_PRODUCTION_PLAN_C.SCM_SITE_DESCRIPTION= ISNULL(B.NEW_VALUE3, A.SCM_SITE_DESCRIPTION)
                            ,SCP_ANL_PRODUCTION_PLAN_C.ATTRIBUTE10         = @CREATED_BY
                       FROM .SCP_ANL_PRODUCTION_PLAN_C AS A with (index (IX02_SCP_ANL_PRODUCTION_PLAN_C)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,NEW_VALUE1
                    --        ,NEW_VALUE2
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE9
                    -- FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    -- where table_name = 'SCP_ANL_PRODUCTION_PLAN_C' and CHANGE_YN = 'Y'
                    --   and NEW_VALUE10 = @CUTOFF_FROM

                    -- ) AS B
                      WHERE 1 = 1
                        AND A.OPERATION_ID                      = B.OLD_VALUE1
                        AND A.SCM_SITE_ID                       = B.OLD_VALUE2
                        --AND ISNULL(A.SCM_SITE_DESCRIPTION,'')   = ISNULL(B.OLD_VALUE3,'')
                        AND ISNULL(A.SCM_SITE_DESCRIPTION,'')   = B.OLD_VALUE3
                        AND A.CUTOFF_DATE >= @CUTOFF_FROM
                        and A.CUTOFF_DATE < @CUTOFF_TO



                    SET @MAPPING_RESULT = 'Y';
                    END


                -- CUTOFF_DATE -> CUTOFF_DATE, YYYYMM
                -- 20241201
                -- VALUATION_CLASS      BKLAS
                ELSE IF @TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R_D'
                    BEGIN


                    SET @YYYYMM = @DIVISION;
                    PRINT @YYYYMM
                    PRINT @CUTOFF_FROM
                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_MONTH_END_STOCK_R_D'
                    and new_value9 = @CUTOFF_FROM
                    and new_value10= @YYYYMM
                    --------------------------------------------------------------------------------------
                    -- 46122 21
                    -- 52298 6
                    -- 810 1초
                    SELECT CUTOFF_DATE, YYYYMM, COMPANY_ID, PLANT_ID,STORAGE_LOCATION, SUPPLIER_CODE, count(*) cnt
                    INTO #TMP_SCP_ANL_MONTH_END_STOCK_R_D
                    from SCP_ANL_MONTH_END_STOCK_R_D with (index(IX01_SCP_ANL_MONTH_END_STOCK_R_D), NOLOCK)
                    where 1 =1
                    and CUTOFF_DATE = @CUTOFF_FROM
                    and YYYYMM = @YYYYMM
                    group by CUTOFF_DATE, YYYYMM, COMPANY_ID, PLANT_ID,STORAGE_LOCATION, SUPPLIER_CODE

                    --------------------------------------------------------------------------------------
                    -- 52298
                    -- 810 1초
                    SELECT CUTOFF_DATE, YYYYMM, COMPANY_ID, PLANT_ID, STORAGE_LOCATION, SUPPLIER_CODE
                           , NC.NEW_VALUE1 AS TOBE_COMPANY
                           , NP.NEW_VALUE1 AS TOBE_PLANT
                           , NST.NEW_VALUE1 AS TOBE_STORAGE_PLANT
                           , NST.NEW_VALUE2 AS TOBE_STORAGE
                           , NV.NEW_VALUE1 AS TOBE_SUPPLIER
                           , cnt
                           , CASE WHEN ISNULL(NC.NEW_VALUE1,'') != '' THEN 'Y'
                                  WHEN ISNULL(NP.NEW_VALUE1,'') != '' THEN 'Y'
                                  WHEN ISNULL(NST.NEW_VALUE1,'') != '' THEN 'Y'
                                  WHEN ISNULL(NST.NEW_VALUE2,'') != '' THEN 'Y'
                                  WHEN ISNULL(NV.NEW_VALUE1,'') != '' THEN 'Y'
                                  ELSE NULL
                                  END CHANGE_YN
                    INTO #TMP_CONV_SCP_ANL_MONTH_END_STOCK_R_D
                    FROM #TMP_SCP_ANL_MONTH_END_STOCK_R_D
                    LEFT JOIN #TMP_COMPANY_ID AS NC ON NC.OLD_VALUE1 = COMPANY_ID
                    LEFT JOIN #TMP_PLANT_ID AS NP ON NP.OLD_VALUE1 = PLANT_ID
                    LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1, NEW_VALUE2
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE CODETYPE = 'STORAGE_ID' AND ATTRIBUTE5 = @P_ROLLIN
                                and OLD_VALUE1 IN (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN)
                                ) AS NST ON NST.OLD_VALUE1 = PLANT_ID
                                        AND NST.OLD_VALUE2 = STORAGE_LOCATION
                    LEFT JOIN #TMP_VENDOR_ID AS NV ON NV.OLD_VALUE1 = SUPPLIER_CODE


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_MONTH_END_STOCK_R_D

                    --------------------------------------------------------------------------------------
                    -- 197661
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6
                    , NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           'SCP_ANL_MONTH_END_STOCK_R_D'
                           , 'CUTOFF_DATE', 'YYYYMM' , 'COMPANY_ID', 'PLANT_ID', 'STORAGE_LOCATION' , 'SUPPLIER_CODE'
                          ,CUTOFF_DATE, YYYYMM , COMPANY_ID, PLANT_ID, STORAGE_LOCATION , SUPPLIER_CODE
                         , TOBE_COMPANY
                         , TOBE_PLANT
                         , TOBE_STORAGE
                         , TOBE_SUPPLIER
                         , CNT
                         , CHANGE_YN
                         , @CUTOFF_FROM, @YYYYMM
                    FROM #TMP_CONV_SCP_ANL_MONTH_END_STOCK_R_D C with (nolock)


                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                            --DECLARE @YYYYMM               nvarchar(10) = '202405'
                            --DECLARE @CUTOFF_DATE_FROM nvarchar(10) = '20241001'
                            --DECLARE @CUTOFF_DATE_TO       nvarchar(10) = '20241002'

                            --2025-03-13 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,OLD_VALUE6
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE6
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1 = ISNULL(OLD_VALUE1,'')
                          ,OLD_VALUE2 = ISNULL(OLD_VALUE2,'')
                          ,OLD_VALUE3 = ISNULL(OLD_VALUE3,'')
                          ,OLD_VALUE4 = ISNULL(OLD_VALUE4,'')
                          ,OLD_VALUE5 = ISNULL(OLD_VALUE5,'')
                          ,OLD_VALUE6 = ISNULL(OLD_VALUE6,'')
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE6
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @YYYYMM;

                    -- 126781  4부14초   3일
                    -- 242172  6분35초   7일
                    -- 601428 12분24초 15일
                    -- 21분 41초 1782049
                    UPDATE SCP_ANL_MONTH_END_STOCK_R_D
                       SET SCP_ANL_MONTH_END_STOCK_R_D.COMPANY_ID       = ISNULL(B.NEW_VALUE3, A.COMPANY_ID)
                          ,SCP_ANL_MONTH_END_STOCK_R_D.PLANT_ID         = ISNULL(B.NEW_VALUE4, A.PLANT_ID)
                          ,SCP_ANL_MONTH_END_STOCK_R_D.STORAGE_LOCATION = ISNULL(B.NEW_VALUE5, A.STORAGE_LOCATION)
                          ,SCP_ANL_MONTH_END_STOCK_R_D.SUPPLIER_CODE    = ISNULL(B.NEW_VALUE6, A.SUPPLIER_CODE)
                          ,SCP_ANL_MONTH_END_STOCK_R_D.ATTRIBUTE15      = @CREATED_BY
                      FROM .SCP_ANL_MONTH_END_STOCK_R_D AS A with (index(IX01_SCP_ANL_MONTH_END_STOCK_R_D)),
                          @TMP_CONV_SCP_DATA_BIG AS B
                    --2025-03-13 시간이 500~600초 걸리는게 있어 변경. 변경후 개당 3초정도
                    --(SELECT  OLD_VALUE1
                    --      ,OLD_VALUE2
                    --      ,OLD_VALUE3
                    --      ,OLD_VALUE4
                    --      ,OLD_VALUE5
                    --      ,OLD_VALUE6
                    --      ,NEW_VALUE3
                    --      ,NEW_VALUE4
                    --      ,NEW_VALUE5
                    --      ,NEW_VALUE6
                    --      ,NEW_VALUE9
                    --      ,NEW_VALUE10
                    --FROM NERP_CONV_SCP_DATA_BIG  with (nolock)
                    --WHERE TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R_D' AND CHANGE_YN = 'Y'
                    -- and NEW_VALUE10 = @YYYYMM
                    -- and NEW_VALUE9 = @CUTOFF_FROM
                    --) AS B
                    WHERE   1=1
                        AND ISNULL(A.CUTOFF_DATE  ,'')  = B.OLD_VALUE1
                        AND ISNULL(A.YYYYMM       ,'')  = B.OLD_VALUE2
                        AND ISNULL(A.COMPANY_ID   ,'')  = B.OLD_VALUE3
                        AND ISNULL(A.PLANT_ID     ,'')  = B.OLD_VALUE4
                        --AND ISNULL(A.STORAGE_LOCATION,'')= ISNULL(B.OLD_VALUE5,'')
                        --AND ISNULL(A.SUPPLIER_CODE,'')    = ISNULL(B.OLD_VALUE6,'')
                        AND ISNULL(A.STORAGE_LOCATION,'')= B.OLD_VALUE5
                        AND ISNULL(A.SUPPLIER_CODE,'')  = B.OLD_VALUE6
                        and A.CUTOFF_DATE               = @CUTOFF_FROM
                        and A.YYYYMM                    = @YYYYMM
                        --AND A.DIVISION_ID = @P_DIVISION_ID

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_CONV_SCP_ANL_MONTH_END_STOCK_R_D
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;



                    -- 2025-08-04 김준규 SCP_ANL_MONTH_END_STOCK_R_D 에서 VALUATION_CLASS BKLAS 처리로직 막음, MATKL 값을 사용하는데 tobe 코드가 안들어옴.
                    ----################################################################
                    ---- #SCP_ANL_MONTH_END_STOCK_R_D - 22초
                    ----###############################################################################################################
                    --IF OBJECT_ID('tempdb..#SCP_ANL_MONTH_END_STOCK_R_D') IS NOT NULL
                    --BEGIN   
                    --DROP TABLE #SCP_ANL_MONTH_END_STOCK_R_D
                    --END

                    --select  YYYYMM
                    --      , VALUATION_CLASS
                    --      , CASE
                    --        WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RE01'   THEN '3001'
                    --        WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RE02'   THEN '3002'
                    --        WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RA01'   THEN '3003'
                    --        WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') = 'RA02'   THEN '3004'
                    --        WHEN A.VALUATION_CLASS = '3000' AND isnull(MATKL,'') like 'RP%' THEN '3005'
                    --        WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') = 'RE02'   THEN '3002'
                    --        WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') = 'RA01'   THEN '3003'
                    --        WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') = 'RA02'   THEN '3004'
                    --        WHEN A.VALUATION_CLASS = '3001' AND isnull(MATKL,'') like 'RP%' THEN '3005'
                    --        WHEN A.VALUATION_CLASS = '3001' THEN '3000'
                    --        ELSE NULL
                    --        END AS TOBE_VALUATION_CLASS
                    --        , MATKL, ITEM_ID
                    --INTO #SCP_ANL_MONTH_END_STOCK_R_D
                    --from
                    --(
                    --    select YYYYMM
                    --         , ITEM_ID
                    --         , isnull(tobe_MATKL,'') as MATKL
                    --         , VALUATION_CLASS
                    --    from SCP_ANL_MONTH_END_STOCK_R_D A
                    --    LEFT JOIN (SELECT NEW_VALUE1 as item
                    --                    , NEW_VALUE2 as tobe_MATKL
                    --                 FROM NERP_CONV_MASTER_CFM_V
                    --                WHERE CODETYPE = 'MATKL'
                    --                  AND ATTRIBUTE5 = @P_ROLLIN
                    --                ) E  ON A.ITEM_ID   = E.item
                    --    where A.CUTOFF_DATE             = @CUTOFF_FROM
                    --      and A.YYYYMM                  = @YYYYMM
                    --      and VALUATION_CLASS in ('3000','3001')
                    --      and isnull(tobe_MATKL,'') like 'R%'
                    -- group by YYYYMM, ITEM_ID, isnull(tobe_MATKL,''), VALUATION_CLASS
                    --) A
                    --order by  YYYYMM, VALUATION_CLASS, MATKL, ITEM_ID


                    ----###############################################################################################################
                    ---- UPDATE VALUATION_CLASSS
                    ----###############################################################################################################

                    ----2025-03-14 쿼리변경
                    ----사용하지 않음
                    ----DELETE
                    ----FROM @TMP_CONV_SCP_DATA_BIG;
                    ----INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                    ----       OLD_VALUE1
                    ----      ,OLD_VALUE2
                    ----      ,OLD_VALUE3
                    ----      ,OLD_VALUE4
                    ----      ,OLD_VALUE5
                    ----      ,OLD_VALUE6
                    ----      ,NEW_VALUE3
                    ----      ,NEW_VALUE4
                    ----      ,NEW_VALUE5
                    ----      ,NEW_VALUE6
                    ----      ,NEW_VALUE9
                    ----      ,NEW_VALUE10
                    ----)
                    ----SELECT OLD_VALUE1
                    ----      ,OLD_VALUE2
                    ----      ,OLD_VALUE3
                    ----      ,OLD_VALUE4
                    ----      ,OLD_VALUE5 = ISNULL(OLD_VALUE5,'')
                    ----      ,OLD_VALUE6 = ISNULL(OLD_VALUE6,'')
                    ----      ,NEW_VALUE3
                    ----      ,NEW_VALUE4
                    ----      ,NEW_VALUE5
                    ----      ,NEW_VALUE6
                    ----      ,NEW_VALUE9
                    ----      ,NEW_VALUE10
                    ----FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    ----WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    ----AND    NEW_VALUE9 = @CUTOFF_FROM
                    ----AND    NEW_VALUE10 = @plan_type;


                    --  UPDATE SCP_ANL_MONTH_END_STOCK_R_D
                    --     SET SCP_ANL_MONTH_END_STOCK_R_D.VALUATION_CLASS    = ISNULL(B.TOBE_VALUATION_CLASS, A.VALUATION_CLASS)
                    --   FROM .SCP_ANL_MONTH_END_STOCK_R_D AS A,
                    --(
                    --       SELECT *
                    --        FROM #SCP_ANL_MONTH_END_STOCK_R_D
                    --        where isnull(TOBE_VALUATION_CLASS,'') != ''
                    --   ) AS B
                    --  WHERE 1 = 1
                    --    and A.YYYYMM = B.YYYYMM
                    --    and A.item_id = B.item_id
                    --    and A.VALUATION_CLASS = B.VALUATION_CLASS
                    --    and A.CUTOFF_DATE       = @CUTOFF_FROM
                    --    and A.YYYYMM            = @YYYYMM
                    --    and A.VALUATION_CLASS in ('3000','3001')


                    SET @MAPPING_RESULT = 'Y';
                    END



                -- PLAN_START_YYYYMMDD, division_id => PLAN_START_YYYYMMDD, division_id, PLAN_TYPE
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_PRODUCTION_PLAN'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_PRODUCTION_PLAN'
                    and new_value8 = @CUTOFF_FROM
                    and new_value9 = @DIVISION
                    and new_value10 = @PLAN_TYPE

                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240901'

                    -- 367 4분10초
                    SELECT OPERATION_ID, SCM_SITE_ID
                         , count(*) AS CNT
                      INTO #TMP_SCP_ANL_PRODUCTION_PLAN
                      FROM SCP_ANL_PRODUCTION_PLAN A with (index(PK_SCP_ANL_PRODUCTION_PLAN/*IX01_SCP_ANL_PRODUCTION_PLAN*/), NOLOCK)
                      where 1 = 1
                       AND DIVISION_ID = @DIVISION
                       AND PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                       AND PLAN_TYPE = @PLAN_TYPE
                  group by OPERATION_ID, SCM_SITE_ID

                    --------------------------------------------------------------------------------------
                    -- 367 21초
                     SELECT OPERATION_ID, SCM_SITE_ID, CNT
                           ,B.NEW_VALUE1 AS TOBE_OPERATION_ID
                           ,C.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                        INTO #TMP_SCP_ANL_PRODUCTION_PLAN_CONV
                        FROM #TMP_SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                        LEFT JOIN #TMP_VENDOR_ID B ON A.OPERATION_ID = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.SCM_SITE_ID = C.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PRODUCTION_PLAN

                    --------------------------------------------------------------------------------------
                    -- 367 4초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                    , COLUMN_NAME1,COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS
                    , CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           'SCP_ANL_PRODUCTION_PLAN'
                         , 'OPERATION_ID' , 'SCM_SITE_ID'
                         , OPERATION_ID, SCM_SITE_ID
                         , TOBE_OPERATION_ID
                         , TOBE_SCM_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_OPERATION_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE
                    FROM #TMP_SCP_ANL_PRODUCTION_PLAN_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PRODUCTION_PLAN_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                         , OLD_VALUE2
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE9
                         , NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                         , OLD_VALUE2
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE9
                         , NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;


                      --108 1초
                        /*
                        40      1034919     1분 53초
                        81      2345015     3분 42초
                        81_HM   0
                        81_ST   0
                        81_UC   0
                        82      511345      57
                        EE      1386132     2분35초
                        EE_HM   0
                        EE_UC   0
                        */
                     --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240901'
                     --DECLARE @division_id nvarchar(10) = '40'
                      UPDATE A
                         SET A.OPERATION_ID   = ISNULL(B.new_value1, A.OPERATION_ID)
                            ,A.SCM_SITE_ID    = ISNULL(B.new_value2, A.SCM_SITE_ID)
                            ,A.ATTRIBUTE10    = @CREATED_BY
                       FROM SCP_ANL_PRODUCTION_PLAN AS A with (index(PK_SCP_ANL_PRODUCTION_PLAN/*IX01_SCP_ANL_PRODUCTION_PLAN*/)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(  SELECT OLD_VALUE1
                    --        , OLD_VALUE2
                    --        , NEW_VALUE1
                    --        , NEW_VALUE2
                    --        , NEW_VALUE9
                    --        , NEW_VALUE10
                    --    FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --    where table_name = 'SCP_ANL_PRODUCTION_PLAN'
                    --    and CHANGE_YN = 'Y'
                    --    and NEW_VALUE8 = @CUTOFF_FROM
                    --    and NEW_VALUE9 = @DIVISION
                    --    and NEW_VALUE10 = @PLAN_TYPE
                    --) AS B
                      WHERE A.OPERATION_ID  = B.OLD_VALUE1
                        AND A.SCM_SITE_ID   = B.OLD_VALUE2
                        AND A.DIVISION_ID = @DIVISION
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.PLAN_TYPE = @PLAN_TYPE


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- 20241201 PLAN_START_YYYYMMDD DIVISION_ID PLAN_TYPE
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_FG'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_SHIPMENT_PLAN_FG'
                    and new_value8  = @CUTOFF_FROM
                    and new_value9 = @DIVISION
                    and new_value10 =  @PLAN_TYPE





                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG
                      FROM SCP_ANL_SHIPMENT_PLAN_FG A with (index(PK_SCP_ANL_SHIPMENT_PLAN_FG),NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID =  @DIVISION
                      and PLAN_TYPE   = @PLAN_TYPE
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_SHIPMENT_PLAN_FG_CONV
                        FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_SHIPMENT_PLAN_FG'
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE
                    FROM #TMP_SCP_ANL_SHIPMENT_PLAN_FG_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_SHIPMENT_PLAN_FG_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE8
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE8
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE A
                         SET A.FROM_SITE     = ISNULL(B.new_value1, A.FROM_SITE)
                            ,A.TO_SITE       = ISNULL(B.new_value2, A.TO_SITE)
                            ,A.ATTRIBUTE10   = @CREATED_BY
                       FROM SCP_ANL_SHIPMENT_PLAN_FG AS A with (index(PK_SCP_ANL_SHIPMENT_PLAN_FG)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, new_value8, new_value9, new_value10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_ANL_SHIPMENT_PLAN_FG'
                    --   and CHANGE_YN = 'Y'
                    --   and new_value8 = @CUTOFF_FROM
                    --   and new_value9 = @DIVISION
                    --   and new_value10 = @PLAN_TYPE
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD   = @CUTOFF_FROM
                        AND A.DIVISION_ID           = @DIVISION
                        AND A.PLAN_TYPE             = @PLAN_TYPE




                    SET @MAPPING_RESULT = 'Y';
                    END

                /*
                SITE_ID
                PLAN_START_YYYYMMDD
                */
                -- 20241201 PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_PLN_PLANT_ONHAND'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_PLN_PLANT_ONHAND'
                    and new_value8 = @CUTOFF_FROM
                    and new_value9 = @DIVISION
                    and new_value10 = @PLAN_TYPE

                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT SITE_ID , count(*) AS CNT
                      INTO #TMP_SCP_PLN_PLANT_ONHAND
                      FROM SCP_PLN_PLANT_ONHAND A WITH (INDEX(PK_SCP_PLN_PLANT_ONHAND), NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID =  @DIVISION
                      and PLAN_TYPE =  @PLAN_TYPE
                  group by SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT SITE_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_SITE_ID
                        INTO #TMP_SCP_PLN_PLANT_ONHAND_CONV
                        FROM #TMP_SCP_PLN_PLANT_ONHAND A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.SITE_ID = NS1.OLD_VALUE1


                    --------------------------------------------------------------------------------------


                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1
                    , OLD_VALUE1
                    , NEW_VALUE1
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_PLN_PLANT_ONHAND'
                         ,'SITE_ID'
                         , SITE_ID
                         , TOBE_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE
                    FROM #TMP_SCP_PLN_PLANT_ONHAND_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_PLANT_ONHAND
                    DROP TABLE #TMP_SCP_PLN_PLANT_ONHAND_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,NEW_VALUE1
                    )
                    SELECT OLD_VALUE1
                          ,NEW_VALUE1
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_PLN_PLANT_ONHAND
                         SET SCP_PLN_PLANT_ONHAND.SITE_ID       = ISNULL(B.new_value1, A.SITE_ID)
                            ,SCP_PLN_PLANT_ONHAND.ATTRIBUTE10   = @CREATED_BY
                       FROM .SCP_PLN_PLANT_ONHAND AS A WITH (INDEX(PK_SCP_PLN_PLANT_ONHAND)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT *
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_PLN_PLANT_ONHAND'
                    --   and  NEW_VALUE8  =  @CUTOFF_FROM
                    --   and  NEW_VALUE9  =  @DIVISION
                    --   and  NEW_VALUE10 =  @PLAN_TYPE
                    --   and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.SITE_ID                   = B.OLD_VALUE1
                        AND A.PLAN_START_YYYYMMDD       = @CUTOFF_FROM
                        AND A.DIVISION_ID               = @DIVISION
                        AND A.PLAN_TYPE                 = @PLAN_TYPE




                    SET @MAPPING_RESULT = 'Y';
                    END

                -- CUTOFF 에서 직접 개발
                -- 20241201 SCP_PLN_SALES_ONHAND -> PLAN_START_YYYYMMDD, DIVISION_ID
                ELSE IF @TABLE_NAME = 'SCP_PLN_SALES_ONHAND'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_PLN_SALES_ONHAND'
                    and new_value9 = @CUTOFF_FROM
                    and new_value10 = @DIVISIOn
                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT SITE_ID , count(*) AS CNT
                      INTO #TMP_SCP_PLN_SALES_ONHAND
                      FROM SCP_PLN_SALES_ONHAND A WITH (INDEX(IX01_SCP_PLN_SALES_ONHAND), NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID = @DIVISIOn
                  group by SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT SITE_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_SITE_ID
                        INTO #TMP_SCP_PLN_SALES_ONHAND_CONV
                        FROM #TMP_SCP_PLN_SALES_ONHAND A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.SITE_ID = NS1.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_SALES_ONHAND

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1
                    , OLD_VALUE1
                    , NEW_VALUE1
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_PLN_SALES_ONHAND'
                         ,'SITE_ID'
                         , SITE_ID
                         , TOBE_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION
                    FROM #TMP_SCP_PLN_SALES_ONHAND_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_SALES_ONHAND_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @DIVISION;

                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_PLN_SALES_ONHAND
                         SET SCP_PLN_SALES_ONHAND.SITE_ID       = ISNULL(B.new_value1, A.SITE_ID)
                            ,SCP_PLN_SALES_ONHAND.ATTRIBUTE10   = @CREATED_BY
                       FROM .SCP_PLN_SALES_ONHAND AS A WITH (INDEX(IX01_SCP_PLN_SALES_ONHAND)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_PLN_SALES_ONHAND' and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 = @CUTOFF_FROM
                    --    AND NEW_VALUE10 = @DIVISION
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.SITE_ID               = B.OLD_VALUE1
                        AND A.PLAN_START_YYYYMMDD   = @CUTOFF_FROM
                        AND A.DIVISION_ID           = @DIVISION



                    SET @MAPPING_RESULT = 'Y';
                    END

                /*
                SALES_SITE_ID (PLANT_ID, SCM_SITE_ID)
                PLAN_START_YYYYMMDD
                */
                -- 20241201 PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCM_KPI_DETAIL'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCM_KPI_DETAIL'
                    and new_value9 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT SALES_SITE_ID , count(*) AS CNT
                      INTO #TMP_SCM_KPI_DETAIL
                      FROM SCM_KPI_DETAIL A with (index(IX02_SCM_KPI_DETAIL), NOLOCK)
                     where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      --and PLAN_START_YYYYMMDD <  @CUTOFF_TO
                     group by SALES_SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT SALES_SITE_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_SITE_ID
                           ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                        INTO #TMP_SCM_KPI_DETAIL_CONV
                        FROM #TMP_SCM_KPI_DETAIL A WITH (NOLOCK)
                        -- 2025-04-10 김준규 SCM_KPI_DETAIL 오류 수정 (NP1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1 --> NP1로 변경)
                        -- 1) LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1
                        --    LEFT JOIN #TMP_PLANT_ID NP1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1
                        -- 2) SITE_ID를 PLANT_ID를 먼저넣고, SITE_ID하는 것을 SITE_ID 먼저로 변경
                        --     SET SCM_KPI_DETAIL.SALES_SITE_ID       = ISNULL(ISNULL(B.new_value1, B.new_value2), A.SALES_SITE_ID) --
                        --     SET SCM_KPI_DETAIL.SALES_SITE_ID       = ISNULL(ISNULL(B.new_value2, B.new_value1), A.SALES_SITE_ID) --
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID NP1 ON A.SALES_SITE_ID = NP1.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_KPI_DETAIL

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1
                    , OLD_VALUE1
                    , NEW_VALUE1 , NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCM_KPI_DETAIL'
                         ,'SALES_SITE_ID'
                         , SALES_SITE_ID
                         , TOBE_PLANT_ID, TOBE_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION
                    FROM #TMP_SCM_KPI_DETAIL_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_KPI_DETAIL_CONV

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @plan_type;

                     -- 2025-04-10 김준규 SCM_KPI_DETAIL 오류 수정 (NP1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1 --> NP1로 변경)
                     -- 1) LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1
                     --    LEFT JOIN #TMP_PLANT_ID NP1 ON A.SALES_SITE_ID = NS1.OLD_VALUE1
                     -- 2) SITE_ID를 PLANT_ID를 먼저넣고, SITE_ID하는 것을 SITE_ID 먼저로 변경
                     --     SET SCM_KPI_DETAIL.SALES_SITE_ID       = ISNULL(ISNULL(B.new_value1, B.new_value2), A.SALES_SITE_ID) --
                     --     SET SCM_KPI_DETAIL.SALES_SITE_ID       = ISNULL(ISNULL(B.new_value2, B.new_value1), A.SALES_SITE_ID) --
                      UPDATE SCM_KPI_DETAIL
                         SET SCM_KPI_DETAIL.SALES_SITE_ID       = ISNULL(ISNULL(B.new_value2, B.new_value1), A.SALES_SITE_ID)
                            ,SCM_KPI_DETAIL.ATTRIBUTE10 = @CREATED_BY
                       FROM .SCM_KPI_DETAIL AS A with (index(IX02_SCM_KPI_DETAIL)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, new_value9
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock) where table_name = 'SCM_KPI_DETAIL' and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.SALES_SITE_ID          = B.OLD_VALUE1
                        AND A.PLAN_START_YYYYMMDD    = @CUTOFF_FROM
                      --AND A.DIVISION_ID   = @DIVISION

                    SET @MAPPING_RESULT = 'Y';
                    END

                /*
                FROM_SITE   SCM_SITE_ID
                TO_SITE     SCM_SITE_ID
                PLAN_START_YYYYMMDD
                */
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_PROBLEM_REPORT_PEGGING'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_PROBLEM_REPORT_PEGGING'
                    and new_value9 = @CUTOFF_FROM
                    and new_value10 = @DIVISION
                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_ANL_PROBLEM_REPORT_PEGGING
                      FROM SCP_ANL_PROBLEM_REPORT_PEGGING A with (index(UK01_SCP_ANL_PROBLEM_REPORT_PEGGING), NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID =  @DIVISION
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_PROBLEM_REPORT_PEGGING_CONV
                        FROM #TMP_SCP_ANL_PROBLEM_REPORT_PEGGING A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PROBLEM_REPORT_PEGGING

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_PROBLEM_REPORT_PEGGING'
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION
                    FROM #TMP_SCP_ANL_PROBLEM_REPORT_PEGGING_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PROBLEM_REPORT_PEGGING_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @DIVISION;

                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_ANL_PROBLEM_REPORT_PEGGING
                         SET SCP_ANL_PROBLEM_REPORT_PEGGING.FROM_SITE   = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_ANL_PROBLEM_REPORT_PEGGING.TO_SITE     = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_ANL_PROBLEM_REPORT_PEGGING.ATTRIBUTE10 = @CREATED_BY
                       FROM .SCP_ANL_PROBLEM_REPORT_PEGGING AS A with (index(UK01_SCP_ANL_PROBLEM_REPORT_PEGGING)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_ANL_PROBLEM_REPORT_PEGGING'
                    --   and CHANGE_YN = 'Y'
                    --   and new_value9 = @CUTOFF_FROM
                    --   and new_value10 = @DIVISION
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE                 = B.OLD_VALUE1
                        AND A.TO_SITE                   = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD       = @CUTOFF_FROM
                        AND A.DIVISION_ID               = @DIVISION

                    SET @MAPPING_RESULT = 'Y';
                    END

                /*
                FROM_SITE   SCM_SITE_ID
                TO_SITE     SCM_SITE_ID
                PLAN_START_YYYYMMDD
                */
                -- 20241201 PLAN_START_YYYYMMDD -> PLAN_START_YYYYMMDD, PLAN_TYPE
                ELSE IF @TABLE_NAME = 'SCP_PLN_SHIPMENT_PLAN'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_PLN_SHIPMENT_PLAN'
                    and new_value9 = @CUTOFF_FROM
                    AND NEW_VALUE10 = @PLAN_TYPE

                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_PLN_SHIPMENT_PLAN
                      FROM SCP_PLN_SHIPMENT_PLAN A WITH (INDEX(IX05_SCP_PLN_SHIPMENT_PLAN),NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      AND PLAN_TYPE = @PLAN_TYPE
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_PLN_SHIPMENT_PLAN_CONV
                        FROM #TMP_SCP_PLN_SHIPMENT_PLAN A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_SHIPMENT_PLAN

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_PLN_SHIPMENT_PLAN'
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @PLAN_TYPE
                    FROM #TMP_SCP_PLN_SHIPMENT_PLAN_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_SHIPMENT_PLAN_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_PLN_SHIPMENT_PLAN
                         SET SCP_PLN_SHIPMENT_PLAN.FROM_SITE    = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_PLN_SHIPMENT_PLAN.TO_SITE      = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_PLN_SHIPMENT_PLAN.ATTRIBUTE10  = @CREATED_BY
                       FROM .SCP_PLN_SHIPMENT_PLAN AS A WITH (INDEX(IX05_SCP_PLN_SHIPMENT_PLAN)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_PLN_SHIPMENT_PLAN'
                    --   and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 =  @CUTOFF_FROM
                    --    AND NEW_VALUE10 =  @PLAN_TYPE
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE                 = B.OLD_VALUE1
                        AND A.TO_SITE                   = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD       = @CUTOFF_FROM
                        AND A.PLAN_TYPE                 = @PLAN_TYPE

                    SET @MAPPING_RESULT = 'Y';
                    END


                /*
                PLANT_SITE_ID   SCM_SITE_ID
                SALES_SITE_ID   SCM_SITE_ID
                PLAN_START_YYYYMMDD
                */
                -- 20241201
                ELSE IF @TABLE_NAME = 'SCP_ANL_PROBLEM_REPORT_DEMAND'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_PROBLEM_REPORT_DEMAND'
                    and new_value10 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT PLANT_SITE_ID, SALES_SITE_ID , count(*) AS CNT
                      INTO #TMP_SCP_ANL_PROBLEM_REPORT_DEMAND
                      FROM SCP_ANL_PROBLEM_REPORT_DEMAND A with (index(IX01_SCP_ANL_PROBLEM_REPORT_DEMAND), NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                  group by PLANT_SITE_ID, SALES_SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT PLANT_SITE_ID, SALES_SITE_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_PLANT_SITE_ID
                           ,NS2.NEW_VALUE1 AS TOBE_SALES_SITE_ID
                        INTO #TMP_SCP_ANL_PROBLEM_REPORT_DEMAND_CONV
                        FROM #TMP_SCP_ANL_PROBLEM_REPORT_DEMAND A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.PLANT_SITE_ID = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.SALES_SITE_ID = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PROBLEM_REPORT_DEMAND

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_PROBLEM_REPORT_DEMAND'
                         ,'PLANT_SITE_ID', 'SALES_SITE_ID'
                         , PLANT_SITE_ID, SALES_SITE_ID
                         , TOBE_PLANT_SITE_ID
                         , TOBE_SALES_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_PLANT_SITE_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SALES_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM
                    FROM #TMP_SCP_ANL_PROBLEM_REPORT_DEMAND_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PROBLEM_REPORT_DEMAND_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM;


                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_ANL_PROBLEM_REPORT_DEMAND
                         SET SCP_ANL_PROBLEM_REPORT_DEMAND.PLANT_SITE_ID    = ISNULL(B.new_value1, A.PLANT_SITE_ID)
                            ,SCP_ANL_PROBLEM_REPORT_DEMAND.SALES_SITE_ID    = ISNULL(B.new_value2, A.SALES_SITE_ID)
                            ,SCP_ANL_PROBLEM_REPORT_DEMAND.ATTRIBUTE10  = @CREATED_BY
                       FROM .SCP_ANL_PROBLEM_REPORT_DEMAND AS A with (index(IX01_SCP_ANL_PROBLEM_REPORT_DEMAND)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, new_value9
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_ANL_PROBLEM_REPORT_DEMAND'
                    --   and CHANGE_YN = 'Y'
                    --   AND NEW_VALUE10 = @CUTOFF_FROM
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.PLANT_SITE_ID                 = B.OLD_VALUE1
                        AND A.SALES_SITE_ID                 = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD       = @CUTOFF_FROM


                    SET @MAPPING_RESULT = 'Y';
                    END




                -- CUTOFF 에서 직접 개발
                -- 20241201 PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE
                ELSE IF @TABLE_NAME = 'SCP_PLN_PRODUCTION_PLAN'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_PLN_PRODUCTION_PLAN'
                    and new_value8 = @CUTOFF_FROM
                    and new_value9 = @DIVISION
                    and new_value10 = @PLAN_TYPE


                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240922'
                    -- 1164 6분53초
                    SELECT OPERATION_ID, SITE_ID , count(*) AS CNT
                      INTO #TMP_SCP_PLN_PRODUCTION_PLAN
                      FROM SCP_PLN_PRODUCTION_PLAN A WITH (INDEX(IX01_SCP_PLN_PRODUCTION_PLAN), NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID = @DIVISION
                      and PLAN_TYPE   =  @PLAN_TYPE
                  group by OPERATION_ID, SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 1164 2초
                     SELECT OPERATION_ID, SITE_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_VENDOR_ID
                           ,NS2.NEW_VALUE1 AS TOBE_SITE_ID
                        INTO #TMP_SCP_PLN_PRODUCTION_PLAN_CONV
                        FROM #TMP_SCP_PLN_PRODUCTION_PLAN A WITH (NOLOCK)
                        LEFT JOIN #TMP_VENDOR_ID NS1 ON A.OPERATION_ID = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.SITE_ID = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_PRODUCTION_PLAN

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_PLN_PRODUCTION_PLAN'
                         ,'OPERATION_ID', 'SITE_ID'
                         , OPERATION_ID, SITE_ID
                         , TOBE_VENDOR_ID
                         , TOBE_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_VENDOR_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE
                    FROM #TMP_SCP_PLN_PRODUCTION_PLAN_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_PLN_PRODUCTION_PLAN_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_PLN_PRODUCTION_PLAN
                         SET SCP_PLN_PRODUCTION_PLAN.OPERATION_ID   = ISNULL(B.new_value1, A.OPERATION_ID)
                            ,SCP_PLN_PRODUCTION_PLAN.SITE_ID        = ISNULL(B.new_value2, A.SITE_ID)
                            ,SCP_PLN_PRODUCTION_PLAN.ATTRIBUTE10    = @CREATED_BY
                       FROM .SCP_PLN_PRODUCTION_PLAN AS A WITH (INDEX(IX01_SCP_PLN_PRODUCTION_PLAN)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_PLN_PRODUCTION_PLAN'
                    --   and CHANGE_YN = 'Y'
                    --   AND NEW_VALUE8 = @CUTOFF_FROM
                    --   AND NEW_VALUE9 = @DIVISION
                    --   AND NEW_VALUE10 = @PLAN_TYPE
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.OPERATION_ID              = B.OLD_VALUE1
                        AND A.SITE_ID                   = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD       = @CUTOFF_FROM
                        AND A.DIVISION_ID               = @DIVISION
                        AND A.PLAN_TYPE                 = @PLAN_TYPE

                    SET @MAPPING_RESULT = 'Y';
                    END


                /*
                OPERATION_ID    VENDOR_ID
                SCM_SITE_ID     SCM_SITE_ID
                YYYYMMDD
                */
                -- 20241201 YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_TACT_TIME'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_TACT_TIME'
                    and new_value9 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    SELECT OPERATION_ID, SCM_SITE_ID , count(*) AS CNT
                      INTO #TMP_SCP_ANL_TACT_TIME
                      FROM SCP_ANL_TACT_TIME A WITH (INDEX(IX01_SCP_ANL_TACT_TIME), NOLOCK)
                    where YYYYMMDD =  @CUTOFF_FROM
                  group by OPERATION_ID, SCM_SITE_ID



                    --------------------------------------------------------------------------------------

                     SELECT OPERATION_ID, SCM_SITE_ID, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_VENDOR_ID
                           ,NS2.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                        INTO #TMP_SCP_ANL_TACT_TIME_CONV
                        FROM #TMP_SCP_ANL_TACT_TIME A WITH (NOLOCK)
                        LEFT JOIN #TMP_VENDOR_ID NS1 ON A.OPERATION_ID = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.SCM_SITE_ID = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_TACT_TIME

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_TACT_TIME'
                         ,'OPERATION_ID', 'SITE_ID'
                         , OPERATION_ID, SCM_SITE_ID
                         , TOBE_VENDOR_ID
                         , TOBE_SCM_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_VENDOR_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION
                    FROM #TMP_SCP_ANL_TACT_TIME_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_TACT_TIME_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################
                      ----DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240921'

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @plan_type;


                      -- 25분 넘어서 중단
                      -- DIV 별로 업데이트 하도록 변경
                      -- 40 1031938 13분
                      -- 81 1790510 6분27초
                      -- 82 878696 7분 3초
                      -- EE 933660 8분 13초
                      UPDATE SCP_ANL_TACT_TIME
                         SET SCP_ANL_TACT_TIME.OPERATION_ID = ISNULL(B.new_value1, A.OPERATION_ID)
                            ,SCP_ANL_TACT_TIME.SCM_SITE_ID  = ISNULL(B.new_value2, A.SCM_SITE_ID)
                            ,SCP_ANL_TACT_TIME.ATTRIBUTE10  = @CREATED_BY
                       FROM .SCP_ANL_TACT_TIME AS A WITH (INDEX(IX01_SCP_ANL_TACT_TIME)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, new_value9
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock) where table_name = 'SCP_ANL_TACT_TIME' and CHANGE_YN = 'Y'
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.OPERATION_ID              = B.OLD_VALUE1
                        AND A.SCM_SITE_ID               = B.OLD_VALUE2
                        AND A.YYYYMMDD                  = @CUTOFF_FROM
                      --AND A.DIVISION_ID               = @DIVISION

                    SET @MAPPING_RESULT = 'Y';
                    END


                /*
                FROM_SITE   SCM_SITE_ID
                TO_SITE     SCM_SITE_ID
                PSI_VALUE   PSI_VALUE
                */
                -- 20241202
                -- PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE, SEQ
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_PRODUCTION'
                    BEGIN

                    --DECLARE @SEQ  nvarchar(10)
                    SET @SEQ = @CUTOFF_TO
                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_PSI_PRODUCTION'
                    and new_value7 = @CUTOFF_FROM
                    and new_value8  = @DIVISION
                    and new_value9  = @PLAN_TYPE
                    and new_value10  = @SEQ

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE ,PSI_VALUE, count(*) AS CNT
                      INTO #TMP_SCP_ANL_PSI_PRODUCTION
                      FROM SCP_ANL_PSI_PRODUCTION A WITH (INDEX(PK_SCP_ANL_PSI_PRODUCTION), NOLOCK)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID  = @DIVISION
                      and PLAN_TYPE  = @PLAN_TYPE
                      and SEQ  = @SEQ
                  group by FROM_SITE, TO_SITE ,PSI_VALUE



                    --------------------------------------------------------------------------------------

                     SELECT FROM_SITE, TO_SITE ,PSI_VALUE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                           ,NS3.NEW_VALUE1 AS TOBE_PSI_VALUE
                        INTO #TMP_SCP_ANL_PSI_PRODUCTION_CONV
                        FROM #TMP_SCP_ANL_PSI_PRODUCTION A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE   = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS3 ON A.PSI_VALUE = NS3.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_PRODUCTION

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                     ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE7, NEW_VALUE8 , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_PSI_PRODUCTION'
                         ,'FROM_SITE', 'TO_SITE', 'PSI_VALUE'
                         , FROM_SITE, TO_SITE, PSI_VALUE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , TOBE_PSI_VALUE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PSI_VALUE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE,    @SEQ
                    FROM #TMP_SCP_ANL_PSI_PRODUCTION_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_PRODUCTION_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE7
                          ,NEW_VALUE8
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2 = ISNULL(OLD_VALUE2,'')
                          ,OLD_VALUE3
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE7
                          ,NEW_VALUE8
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE7 = @CUTOFF_FROM
                    AND    NEW_VALUE8 = @DIVISION
                    AND    NEW_VALUE9 = @PLAN_TYPE
                    AND    NEW_VALUE10 = @SEQ;

                      UPDATE SCP_ANL_PSI_PRODUCTION
                         SET SCP_ANL_PSI_PRODUCTION.FROM_SITE   = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_ANL_PSI_PRODUCTION.TO_SITE     = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_ANL_PSI_PRODUCTION.PSI_VALUE   = ISNULL(B.new_value3, A.PSI_VALUE)
                          --,SCP_ANL_PSI_PRODUCTION.ATTRIBUTE10 = @CREATED_BY
                       FROM .SCP_ANL_PSI_PRODUCTION AS A WITH (INDEX(PK_SCP_ANL_PSI_PRODUCTION)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, new_value1, new_value2, new_value3
                    --       , new_value7, new_value8, new_value9, new_value10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_ANL_PSI_PRODUCTION' and CHANGE_YN = 'Y'
                    --    and new_value7 = @CUTOFF_FROM
                    --    and new_value8 = @DIVISION
                    --    and new_value9 = @PLAN_TYPE
                    --    and new_value10 = @SEQ
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE             = B.OLD_VALUE1
                        AND ISNULL(A.TO_SITE,'')    = B.OLD_VALUE2
                        AND A.PSI_VALUE             = B.OLD_VALUE3
                        AND A.PLAN_START_YYYYMMDD   = @CUTOFF_FROM
                        AND A.DIVISION_ID           = @DIVISION
                        AND A.PLAN_TYPE             = @PLAN_TYPE
                        AND A.SEQ                   = @SEQ

                    SET @MAPPING_RESULT = 'Y';
                    END

                /*
                OPERATION_ID    VENDOR_ID   BG
                SCM_SITE_ID     SCM_SITE_ID BG
                */
                -- 20241202
                ELSE IF @TABLE_NAME = 'HIST_SCP_ANL_PRODUCTION_PLAN'
                    BEGIN


                    SET @SEQ = @CUTOFF_TO
                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'HIST_SCP_ANL_PRODUCTION_PLAN'
                    and new_value7 = @CUTOFF_FROM
                    and new_value8 = @DIVISION
                    and new_value9 = @PLAN_TYPE
                    and new_value10 = @SEQ
                    --------------------------------------------------------------------------------------
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240901'

                    -- 367 4분10초
                    SELECT OPERATION_ID, SCM_SITE_ID
                         , count(*) AS CNT
                     INTO #TMP_HIST_SCP_ANL_PRODUCTION_PLAN
                      FROM HIST_SCP_ANL_PRODUCTION_PLAN A with (index(PK_HIST_SCP_ANL_PRODUCTION_PLAN), NOLOCK)
                      where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                       AND DIVISION_ID = @DIVISION
                       AND PLAN_TYPE = @PLAN_TYPE
                       and SEQ = @SEQ
                  group by OPERATION_ID, SCM_SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 367 21초
                     SELECT OPERATION_ID, SCM_SITE_ID, CNT
                           ,B.NEW_VALUE1 AS TOBE_OPERATION_ID
                           ,C.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                        INTO #TMP_HIST_SCP_ANL_PRODUCTION_PLAN_CONV
                        FROM #TMP_HIST_SCP_ANL_PRODUCTION_PLAN A WITH (NOLOCK)
                        LEFT JOIN #TMP_VENDOR_ID B ON A.OPERATION_ID = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.SCM_SITE_ID = C.OLD_VALUE1

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_HIST_SCP_ANL_PRODUCTION_PLAN

                    --------------------------------------------------------------------------------------
                    -- 367 4초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS
                    , CHANGE_YN
                    , NEW_VALUE7, NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           'HIST_SCP_ANL_PRODUCTION_PLAN'
                         , 'OPERATION_ID' , 'SCM_SITE_ID'
                         , OPERATION_ID, SCM_SITE_ID
                         , TOBE_OPERATION_ID
                         , TOBE_SCM_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_OPERATION_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE, @SEQ
                    FROM #TMP_HIST_SCP_ANL_PRODUCTION_PLAN_CONV C with (nolock)



                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_HIST_SCP_ANL_PRODUCTION_PLAN_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                         , OLD_VALUE2
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE7
                         , NEW_VALUE8
                         , NEW_VALUE9
                         , NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                         , OLD_VALUE2
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE7
                         , NEW_VALUE8
                         , NEW_VALUE9
                         , NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE7 = @CUTOFF_FROM
                    AND    NEW_VALUE8 = @DIVISION
                    AND    NEW_VALUE9 = @PLAN_TYPE
                    AND    NEW_VALUE10 = @CUTOFF_TO;


                      UPDATE HIST_SCP_ANL_PRODUCTION_PLAN
                         SET HIST_SCP_ANL_PRODUCTION_PLAN.OPERATION_ID  = ISNULL(B.new_value1, A.OPERATION_ID)
                            ,HIST_SCP_ANL_PRODUCTION_PLAN.SCM_SITE_ID   = ISNULL(B.new_value2, A.SCM_SITE_ID)
                            ,HIST_SCP_ANL_PRODUCTION_PLAN.ATTRIBUTE10   = @CREATED_BY
                       FROM .HIST_SCP_ANL_PRODUCTION_PLAN AS A with (index(PK_HIST_SCP_ANL_PRODUCTION_PLAN)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(  SELECT OLD_VALUE1
                    --        , OLD_VALUE2
                    --        , NEW_VALUE1
                    --        , NEW_VALUE2
                    --        , NEW_VALUE7
                    --        , NEW_VALUE8
                    --        , NEW_VALUE9
                    --        , NEW_VALUE10
                    --    FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --    where table_name = 'HIST_SCP_ANL_PRODUCTION_PLAN'
                    --    and CHANGE_YN = 'Y'
                    --    and NEW_VALUE7 = @CUTOFF_FROM
                    --    and NEW_VALUE8 = @DIVISION
                    --    and NEW_VALUE9 = @PLAN_TYPE
                    --    and NEW_VALUE10 = @CUTOFF_TO

                    --) AS B
                    --아래 IX02 추가 검토 DIVISION_ID,PLAN_START_YYYYMMDD,PLAN_TYPE,SEQ,OPERATION_ID,SCM_SITE_ID
                        --PK DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, OPERATION_GROUP, SCM_SITE_ID, ITEM_ID, LINE_ID, OPERATION_ID, MEASURE, YYYYMMDD
                      WHERE A.DIVISION_ID = @DIVISION
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.PLAN_TYPE = @PLAN_TYPE
                        AND A.SEQ = @SEQ
                        AND A.OPERATION_ID  = B.OLD_VALUE1
                        AND A.SCM_SITE_ID   = B.OLD_VALUE2

                    SET @MAPPING_RESULT = 'Y';
                    END

                /*
                FROM_SITE
                TO_SITE
                */
                -- 20241202
                ELSE IF @TABLE_NAME = 'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI'
                    BEGIN

                    print @TABLE_NAME
                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI'
                    and NEW_VALUE10 = @CUTOFF_FROM
                    and NEW_VALUE9 = @PLAN_TYPE


                    --------------------------------------------------------------------------------------
                    --DROP TABLE IX01_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI
                    --DROP TABLE IX02_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI
                    --DROP TABLE PK_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI

                    --일반 TABLE IX03_SCP_ANL_SHIPMENT_PLAN_SEMI
                    --일반 TABLE IX04_SCP_ANL_SHIPMENT_PLAN_SEMI
                    --일반 TABLE PK_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI

                    --아래 IX04는 없음, DROP은 IX02 운영은 04임
                    --DECLARE @PLAN_START_YYYYMMDD nvarchar(10) = '20240923'
                    -- 79 10초
                    SELECT FROM_SITE, TO_SITE,count(*) AS CNT
                      INTO #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI
                      FROM HIST_SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (INDEX(IX04_SCP_ANL_SHIPMENT_PLAN_SEMI),nolock)
                      where PLAN_START_YYYYMMDD = @CUTOFF_FROM
                       and PLAN_TYPE = @PLAN_TYPE
                  group by FROM_SITE, TO_SITE


                    --------------------------------------------------------------------------------------
                    -- 79 1초
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,B.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,C.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI_CONV
                        FROM #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID B ON A.FROM_SITE = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.TO_SITE = C.OLD_VALUE1
                        ORDER BY FROM_SITE, TO_SITE


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI

                    --------------------------------------------------------------------------------------
                    -- 79 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2
                    , OLD_VALUE1,OLD_VALUE2
                    , NEW_VALUE3, NEW_VALUE4
                    , CNT_ASIS,CHANGE_YN
                    , new_value9, new_value10
                    )
                    SELECT
                          'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI'
                         , 'FROM_SITE', 'TO_SITE'
                         ,  FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @PLAN_TYPE, @CUTOFF_FROM
                    FROM #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1 = ISNULL(B.OLD_VALUE1,'')
                          ,OLD_VALUE2 = ISNULL(B.OLD_VALUE2,'')
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @PLAN_TYPE
                    AND    NEW_VALUE10 = @CUTOFF_FROM;

                      UPDATE HIST_SCP_ANL_SHIPMENT_PLAN_SEMI
                         SET HIST_SCP_ANL_SHIPMENT_PLAN_SEMI.FROM_SITE      = ISNULL(B.NEW_VALUE3, A.FROM_SITE)
                            ,HIST_SCP_ANL_SHIPMENT_PLAN_SEMI.TO_SITE        = ISNULL(B.NEW_VALUE4, A.TO_SITE)
                            ,HIST_SCP_ANL_SHIPMENT_PLAN_SEMI.ATTRIBUTE10    = @CREATED_BY
                       FROM .HIST_SCP_ANL_SHIPMENT_PLAN_SEMI AS A WITH (INDEX(IX04_SCP_ANL_SHIPMENT_PLAN_SEMI)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1
                    --        ,OLD_VALUE2
                    --        ,OLD_VALUE3
                    --        ,OLD_VALUE4
                    --        ,NEW_VALUE3
                    --        ,NEW_VALUE4
                    --        ,new_value9
                    --        ,new_value10
                    --FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --where table_name = 'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI'
                    --and CHANGE_YN = 'Y'
                    --and new_value10 = @cutoff_from
                    --and new_value9 = @plan_type
                    --) AS B
                      WHERE 1 = 1
                        --AND ISNULL(A.FROM_SITE,'')  = ISNULL(B.OLD_VALUE1,'')
                        --AND ISNULL(A.TO_SITE,'')    = ISNULL(B.OLD_VALUE2,'')
                        AND ISNULL(A.FROM_SITE,'')  = B.OLD_VALUE1
                        AND ISNULL(A.TO_SITE,'')    = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD   = @cutoff_from
                        AND A.plan_type             = @plan_type


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- 20241202
                /*
                INCOTERMS       INCOTERMS
                FROM_SITE       SCM_SITE_ID
                TO_SITE         SCM_SITE_ID

                PK = PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID, YYYYMMDD, BIZ_TYPE, ITEM_ID, PROJECT_CODE, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, MEASURE
                index = PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG
                */
                ELSE IF @TABLE_NAME = 'HIST_SCP_ANL_SHIPMENT_PLAN_FG'
                    BEGIN

                    SET @SEQ = @CUTOFF_TO
                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'HIST_SCP_ANL_SHIPMENT_PLAN_FG'
                    and new_value7 = @SEQ
                    and new_value8 = @PLAN_TYPE
                    and new_value9 = @DIVISION
                    and new_value10 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    --31초
                    -- total 1097096
                    -- groupby 426
                    SELECT FROM_SITE, TO_SITE,INCOTERMS
                         , count(*) AS CNT
                      INTO #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_FG
                      FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG A with (index(PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG), NOLOCK)
                     where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                       AND PLAN_TYPE = @PLAN_TYPE
                       and SEQ = @CUTOFF_TO
                       AND DIVISION_ID = @DIVISION
                  group by FROM_SITE, TO_SITE,INCOTERMS



                    --------------------------------------------------------------------------------------
                    -- 426 2초
                    select FROM_SITE, TO_SITE, INCOTERMS, CNT
                          , TOBE_FROM_SITE, TOBE_TO_SITE
                          , COUNTRY
                          , CASE WHEN INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04')   THEN 'DAP'
                                 WHEN INCOTERMS IN ('A02', 'S32', 'S33')                    THEN 'EXW'
                                 WHEN INCOTERMS IN ('DAT')                                      THEN 'DPU'
                                 WHEN COUNTRY = 'KR' AND INCOTERMS IN ('Z01')                   THEN 'EXW'
                                 WHEN COUNTRY = 'KR' AND INCOTERMS IN ('Z02')                   THEN 'DAP'
                                 WHEN COUNTRY != 'KR' AND INCOTERMS IN ('Z01')                  THEN 'DAP'
                                 WHEN COUNTRY != 'KR' AND INCOTERMS IN ('Z02')                  THEN 'EXW'
                                 WHEN (FROM_SITE LIKE 'A%' OR FROM_SITE LIKE 'F%') AND INCOTERMS IN ('Z01') THEN 'EXW'
                                 WHEN (FROM_SITE LIKE 'A%' OR FROM_SITE LIKE 'F%') AND INCOTERMS IN ('Z02') THEN 'DAP'
                                 WHEN (FROM_SITE NOT LIKE 'A%' AND FROM_SITE NOT LIKE 'F%') AND INCOTERMS IN ('Z01') THEN 'DAP'
                                 WHEN (FROM_SITE NOT LIKE 'A%' AND FROM_SITE NOT LIKE 'F%') AND INCOTERMS IN ('Z02') THEN 'EXW'
                                 WHEN INCOTERMS IN ('Z01') THEN 'DAP'
                                 WHEN INCOTERMS IN ('Z02') THEN 'EXW'
                                 ELSE NULL
                                 END  TOBE_INCOTERMS
                    INTO #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_FG_CONV
                    FROM
                    (
                     SELECT FROM_SITE, TO_SITE, INCOTERMS, CNT
                           ,B.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,C.NEW_VALUE1 AS TOBE_TO_SITE
                           ,D.COUNTRY AS COUNTRY
                        FROM #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_FG A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID B ON A.FROM_SITE = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.TO_SITE   = C.OLD_VALUE1
                        LEFT JOIN (select scm_site_id, country from SCM_MST_SITE ) D ON A.FROM_SITE = D.scm_site_id
                    ) LIST


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_FG
                    --------------------------------------------------------------------------------------
                    -- 367 4초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3
                    , CNT_ASIS
                    , CHANGE_YN
                    , NEW_VALUE7, NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           'HIST_SCP_ANL_SHIPMENT_PLAN_FG'
                         , 'FROM_SITE' , 'TO_SITE', 'INCOTERMS'
                         , FROM_SITE, TO_SITE, INCOTERMS
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , TOBE_INCOTERMS
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_INCOTERMS,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @SEQ, @PLAN_TYPE, @DIVISION, @CUTOFF_FROM
                    FROM #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_FG_CONV C with (nolock)

                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_HIST_SCP_ANL_SHIPMENT_PLAN_FG_CONV
                    --------------------------------------------------------------------------------------

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                         , OLD_VALUE2
                         , OLD_VALUE3
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE3
                         , NEW_VALUE7
                         , NEW_VALUE8
                         , NEW_VALUE9
                         , NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                         , OLD_VALUE2
                         , OLD_VALUE3
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE3
                         , NEW_VALUE7
                         , NEW_VALUE8
                         , NEW_VALUE9
                         , NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE8 = @PLAN_TYPE
                    AND    NEW_VALUE7 = @SEQ;

                      UPDATE HIST_SCP_ANL_SHIPMENT_PLAN_FG
                         SET HIST_SCP_ANL_SHIPMENT_PLAN_FG.FROM_SITE    = ISNULL(B.new_value1, A.FROM_SITE)
                            ,HIST_SCP_ANL_SHIPMENT_PLAN_FG.TO_SITE      = ISNULL(B.new_value2, A.TO_SITE)
                          --,HIST_SCP_ANL_SHIPMENT_PLAN_FG.INCOTERMS    = ISNULL(B.new_value3, A.INCOTERMS)  -> 완료 후 BATCH DUPLICATION
                            ,HIST_SCP_ANL_SHIPMENT_PLAN_FG.ATTRIBUTE10  = @CREATED_BY
                       FROM .HIST_SCP_ANL_SHIPMENT_PLAN_FG AS A with (index(PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(  SELECT OLD_VALUE1
                    --        , OLD_VALUE2
                    --        , OLD_VALUE3
                    --        , NEW_VALUE1
                    --        , NEW_VALUE2
                    --        , NEW_VALUE3
                    --        , NEW_VALUE7
                    --        , NEW_VALUE8
                    --        , NEW_VALUE9
                    --        , NEW_VALUE10
                    --    FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --    where table_name = 'HIST_SCP_ANL_SHIPMENT_PLAN_FG'
                    --    and CHANGE_YN = 'Y'
                    --    and NEW_VALUE10 = @CUTOFF_FROM
                    --    and NEW_VALUE9 = @DIVISION
                    --    and NEW_VALUE8 = @PLAN_TYPE
                    --    and NEW_VALUE7 = @SEQ
                    --) AS B
                      WHERE A.FROM_SITE = B.OLD_VALUE1
                        AND A.TO_SITE   = B.OLD_VALUE2
                        AND A.INCOTERMS = B.OLD_VALUE3
                        AND A.PLAN_START_YYYYMMDD   = @CUTOFF_FROM
                        AND A.DIVISION_ID           = @DIVISION
                        AND A.PLAN_TYPE             = @PLAN_TYPE
                        AND A.SEQ                   = @SEQ


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- 20241202 PLAN_START_YYYYMMDD,  PLAN_TYPE
                /*
                FROM_SITE   SCM_SITE_ID
                TO_SITE     SCM_SITE_ID
                */
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_ELECTRODE'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @PLAN_TYPE

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_ANL_PSI_ELECTRODE
                      FROM SCP_ANL_PSI_ELECTRODE A with (index (PK_SCP_ANL_PSI_ELECTRODE), nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and PLAN_TYPE = @PLAN_TYPE
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_ANL_PSI_ELECTRODE_CONV
                        FROM #TMP_SCP_ANL_PSI_ELECTRODE A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_ELECTRODE


                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_PSI_ELECTRODE'
                         ,'FROM_SITE', 'TO_SITE'
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@PLAN_TYPE
                    FROM #TMP_SCP_ANL_PSI_ELECTRODE_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PSI_ELECTRODE_CONV


                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                      UPDATE A
                         SET A.FROM_SITE    = ISNULL(B.new_value1, A.FROM_SITE)
                            ,A.TO_SITE      = ISNULL(B.new_value2, A.TO_SITE)
                            ,A.ATTRIBUTE10  = @CREATED_BY
                       FROM SCP_ANL_PSI_ELECTRODE AS A with (index (PK_SCP_ANL_PSI_ELECTRODE)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2, NEW_VALUE9, NEW_VALUE10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --  where table_name = @TABLE_NAME
                    --    and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 = @CUTOFF_FROM
                    --    AND NEW_VALUE10 = @PLAN_TYPE
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE     = B.OLD_VALUE1
                        AND A.TO_SITE       = B.OLD_VALUE2
                        --and A.PLAN_START_YYYYMMDD = B.NEW_VALUE9
                        --AND A.PLAN_TYPE               = B.NEW_VALUE10
                        AND A.PLAN_START_YYYYMMDD   = @CUTOFF_FROM
                        AND A.PLAN_TYPE             = @PLAN_TYPE


                    SET @MAPPING_RESULT = 'Y';
                    END





                -- 20241202
                ELSE IF @TABLE_NAME = 'SCP_RPT_GLOBAL_PSI_MD_WW'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @DIVISION

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_RPT_GLOBAL_PSI_MD_WW
                      FROM SCP_RPT_GLOBAL_PSI_MD_WW A  with (INDEX(SCP_RPT_GLOBAL_PSI_MD_WW_PK) , nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID = @DIVISION
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_RPT_GLOBAL_PSI_MD_WW_CONV
                        FROM #TMP_SCP_RPT_GLOBAL_PSI_MD_WW A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_RPT_GLOBAL_PSI_MD_WW



                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3
                    --, OLD_VALUE1, OLD_VALUE2, OLD_VALUE2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          @TABLE_NAME
                         ,'FROM_SITE', 'TO_SITE','INCOTERMS'
                         --, FROM_SITE, TO_SITE, INCOTERMS
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@DIVISION
                    FROM #TMP_SCP_RPT_GLOBAL_PSI_MD_WW_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_RPT_GLOBAL_PSI_MD_WW_CONV



                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @DIVISION;

                      UPDATE SCP_RPT_GLOBAL_PSI_MD_WW
                         SET SCP_RPT_GLOBAL_PSI_MD_WW.FROM_SITE     = ISNULL(B.new_value1, A.FROM_SITE)
                            ,SCP_RPT_GLOBAL_PSI_MD_WW.TO_SITE       = ISNULL(B.new_value2, A.TO_SITE)
                            ,SCP_RPT_GLOBAL_PSI_MD_WW.ATTRIBUTE10   = @CREATED_BY
                       FROM .SCP_RPT_GLOBAL_PSI_MD_WW AS A  with (INDEX(SCP_RPT_GLOBAL_PSI_MD_WW_PK)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = @TABLE_NAME and CHANGE_YN = 'Y'
                    --    AND NEW_VALUE9 = @CUTOFF_FROM
                    --    AND NEW_VALUE10 = @DIVISION
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.FROM_SITE           = B.OLD_VALUE1
                        AND A.TO_SITE             = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.DIVISION_ID         = @DIVISION


                    SET @MAPPING_RESULT = 'Y';
                    END



                -- YYYYMM
                -- 20241202
                /*
                PLANT_ID                    PLANT_ID
                PRCTR                       PROFIT_CENTER_ID
                WAERS                       WAERS
                MATKL + VALUATION_CLASS     BKLAS
                */
                ELSE IF @TABLE_NAME = 'SCP_ANL_LONG_TERM_STOCK'
                    BEGIN

                    /*
                    select distinct PRCTR
                    from SCP_ANL_LONG_TERM_STOCK A
                    where A.PRCTR   in (SELECT OLD_VALUE2  FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PROFIT_CENTER_ID' AND ATTRIBUTE5 = @P_ROLLIN)
                    and yyyymm >='202410'
                    */
                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCP_ANL_LONG_TERM_STOCK'
                    and new_value10 = @CUTOFF_FROM

                    --------------------------------------------------------------------------------------
                    SELECT PLANT_ID, ITEM_ID, PRCTR, WAERS, MATKL, VALUATION_CLASS, count(*) AS CNT
                      INTO #TMP_SCP_ANL_LONG_TERM_STOCK
                      FROM SCP_ANL_LONG_TERM_STOCK A WITH (INDEX(PK_SCP_ANL_LONG_TERM_STOCK), NOLOCK)
                    where YYYYMM =  @CUTOFF_FROM
                  group by PLANT_ID, ITEM_ID, PRCTR, WAERS, MATKL, VALUATION_CLASS



                    --------------------------------------------------------------------------------------
                     SELECT PLANT_ID, ITEM_ID, PRCTR, WAERS, MATKL, VALUATION_CLASS, CNT
                           ,N1.NEW_VALUE1 AS TOBE_PLANT_ID
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

                        INTO #TMP_SCP_ANL_LONG_TERM_STOCK_CONV
                        FROM #TMP_SCP_ANL_LONG_TERM_STOCK A WITH (NOLOCK)
                        LEFT JOIN #TMP_PLANT_ID N1
                        ON A.PLANT_ID = N1.OLD_VALUE1
                        LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1,  new_value2, REPLICATE('0',10 - LEN(OLD_VALUE2)) + OLD_VALUE2 AS ASIS_CODE FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PROFIT_CENTER_ID' AND ATTRIBUTE5 = @P_ROLLIN) N2
                        ON A.PRCTR  = N2.ASIS_CODE
                        LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'WAERS' AND ATTRIBUTE5 = @P_ROLLIN) N3 ON A.WAERS = N3.OLD_VALUE1
                        LEFT JOIN (SELECT NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'MATKL' AND ATTRIBUTE5 = @P_ROLLIN) E
                        ON A.ITEM_ID    = E.NEW_VALUE1



                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK

                    --------------------------------------------------------------------------------------
                    -- 1164 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                     ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3,COLUMN_NAME4, COLUMN_NAME5
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10
                    )
                    SELECT
                          'SCP_ANL_LONG_TERM_STOCK'
                         , 'PLANT_ID', 'PRCTR', 'WAERS', 'VALUATION_CLASS', 'ITEM_ID'
                         , PLANT_ID, PRCTR, WAERS, VALUATION_CLASS, ITEM_ID
                         , TOBE_PLANT_ID
                         , TOBE_PRCTR
                         , TOBE_WAERS
                         , TOBE_VALUATION_CLASS
                         , CNT
                         , CASE WHEN ISNULL(TOBE_PLANT_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_PRCTR,'') != ''    THEN 'Y'
                                WHEN ISNULL(TOBE_WAERS,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_VALUATION_CLASS,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM
                    FROM #TMP_SCP_ANL_LONG_TERM_STOCK_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_LONG_TERM_STOCK_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE7
                          ,NEW_VALUE8
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE7
                          ,NEW_VALUE8
                          ,NEW_VALUE9
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM;


                      UPDATE SCP_ANL_LONG_TERM_STOCK
                         SET SCP_ANL_LONG_TERM_STOCK.PLANT_ID       = ISNULL(B.new_value1, A.PLANT_ID)
                            ,SCP_ANL_LONG_TERM_STOCK.PRCTR          = ISNULL(B.new_value2, A.PRCTR)
                            ,SCP_ANL_LONG_TERM_STOCK.WAERS          = ISNULL(B.new_value3, A.WAERS)
                            ,SCP_ANL_LONG_TERM_STOCK.VALUATION_CLASS= ISNULL(B.new_value4, A.VALUATION_CLASS)
                            ,SCP_ANL_LONG_TERM_STOCK.ATTRIBUTE10    = @CREATED_BY
                       FROM .SCP_ANL_LONG_TERM_STOCK AS A WITH (INDEX(PK_SCP_ANL_LONG_TERM_STOCK)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5
                    --       , new_value1, new_value2, new_value3, new_value4
                    --       , new_value7, new_value8, new_value9, new_value10
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCP_ANL_LONG_TERM_STOCK' and CHANGE_YN = 'Y'
                    --    and new_value10= @CUTOFF_FROM
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.PLANT_ID              = B.OLD_VALUE1
                        AND A.PRCTR                 = B.OLD_VALUE2
                        AND A.WAERS                 = B.OLD_VALUE3
                        AND A.VALUATION_CLASS       = B.OLD_VALUE4
                        AND A.YYYYMM                = @CUTOFF_FROM
                        and A.PLANT_ID NOT IN ('A011','A041','F031','G482')

                        /*
                        -- TODO : A011, A041, F031, G482
                        INSERT INTO SCP_ANL_LONG_TERM_STOCK
                        ()
                        SELECT
                        from SCP_ANL_LONG_TERM_STOCK
                        where 1 = 1
                        AND A.YYYYMM                = @CUTOFF_FROM
                        and A.PLANT_ID IN ('A011','A041','F031','G482')
                        */


                    SET @MAPPING_RESULT = 'Y';
                    END




                -- 20241202 -> 20241205
                ELSE IF @TABLE_NAME = 'SCP_RPT_GLOBAL_PSI_MD_MM'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                          where table_name = @TABLE_NAME
                            AND NEW_VALUE9 = @CUTOFF_FROM
                            AND NEW_VALUE10 = @DIVISION

                    --------------------------------------------------------------------------------------
                    SELECT FROM_SITE, TO_SITE , count(*) AS CNT
                      INTO #TMP_SCP_RPT_GLOBAL_PSI_MD_MM
                      FROM SCP_RPT_GLOBAL_PSI_MD_MM A  with (INDEX(SCP_RPT_GLOBAL_PSI_MD_MM_PK) , nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and DIVISION_ID = @DIVISION
                  group by FROM_SITE, TO_SITE



                    --------------------------------------------------------------------------------------
                     SELECT FROM_SITE, TO_SITE, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                           ,NS2.NEW_VALUE1 AS TOBE_TO_SITE
                        INTO #TMP_SCP_RPT_GLOBAL_PSI_MD_MM_CONV
                        FROM #TMP_SCP_RPT_GLOBAL_PSI_MD_MM A WITH (NOLOCK)
                        LEFT JOIN #TMP_SCP_SITE_ID NS1 ON A.FROM_SITE = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS2 ON A.TO_SITE = NS2.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_RPT_GLOBAL_PSI_MD_MM



                    --------------------------------------------------------------------------------------
                    -- 49 1초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3
                    --, OLD_VALUE1, OLD_VALUE2, OLD_VALUE3
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                          @TABLE_NAME
                         ,'FROM_SITE', 'TO_SITE','INCOTERMS'
                         --, FROM_SITE, TO_SITE, INCOTERMS
                         , FROM_SITE, TO_SITE
                         , TOBE_FROM_SITE
                         , TOBE_TO_SITE
                         , CNT
                         , CASE WHEN ISNULL(TOBE_FROM_SITE,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_TO_SITE,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                        ,@CUTOFF_FROM
                        ,@DIVISION
                    FROM #TMP_SCP_RPT_GLOBAL_PSI_MD_MM_CONV C with (nolock)


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_RPT_GLOBAL_PSI_MD_MM_CONV



                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE9 = @CUTOFF_FROM
                    AND    NEW_VALUE10 = @DIVISION;


                   UPDATE SCP_RPT_GLOBAL_PSI_MD_MM
                      SET SCP_RPT_GLOBAL_PSI_MD_MM.FROM_SITE     = ISNULL(B.new_value1, A.FROM_SITE)
                         ,SCP_RPT_GLOBAL_PSI_MD_MM.TO_SITE       = ISNULL(B.new_value2, A.TO_SITE)
                         ,SCP_RPT_GLOBAL_PSI_MD_MM.ATTRIBUTE10   = @CREATED_BY
                    FROM .SCP_RPT_GLOBAL_PSI_MD_MM AS A  with (INDEX(SCP_RPT_GLOBAL_PSI_MD_MM_PK)),
                        @TMP_CONV_SCP_DATA_BIG AS B
                --( SELECT OLD_VALUE1,OLD_VALUE2, new_value1, new_value2
                --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                --   where table_name = @TABLE_NAME and CHANGE_YN = 'Y'
                --    AND NEW_VALUE9 = @CUTOFF_FROM
                --    AND NEW_VALUE10 = @DIVISION
                --   ) AS B
                    WHERE 1 = 1
                    AND A.FROM_SITE           = B.OLD_VALUE1
                    AND A.TO_SITE             = B.OLD_VALUE2
                    AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                    AND A.DIVISION_ID         = @DIVISION


                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241203
                /*
                @CUTOFF_FROM = HISTORY_SEQ

                SCM_DNM_INTRANSIT_C_H   INCOTERMS   DOM_EXP
                -------------------------------------------------------------------------------------
                COMPANY_ID
                PLANT_ID
                INCOTERMS
                CUSTOMER_CODE
                SHIPTO_CODE
                FROM_SCM_SITE_ID
                TO_SCM_SITE_ID
                FINAL_SOLDTO_CODE
                FINAL_SOLDTO_NAME
                FINAL_INCOTERMS

                    ALTER TABLE NERP_CONV_SCP_DATA_BIG ADD new_value11 NVARCHAR(800)
                */
                ELSE IF @TABLE_NAME = 'SCM_DNM_INTRANSIT_C_H'
                    BEGIN


                    --################################################################
                    -- NERP_CONV_SCP_DATA_BIG 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = 'SCM_DNM_INTRANSIT_C_H'
                    and new_value10 = @CUTOFF_FROM
                    and new_value11 = @DIVISION -- HISTORY_SEQ

                    --------------------------------------------------------------------------------------
                    SELECT COMPANY_ID,PLANT_ID,INCOTERMS,CUSTOMER_CODE,SHIPTO_CODE,FROM_SCM_SITE_ID,TO_SCM_SITE_ID,FINAL_SOLDTO_CODE,FINAL_INCOTERMS , count(*) AS CNT
                      INTO #TMP_SCM_DNM_INTRANSIT_C_H
                      FROM SCM_DNM_INTRANSIT_C_H A  with (INDEX(PK_SCM_DNM_INTRANSIT_C_H_1) , nolock)
                    where HISTORY_SEQ = @DIVISION
                    and result_date = @CUTOFF_FROM
                  group by COMPANY_ID,PLANT_ID,INCOTERMS,CUSTOMER_CODE,SHIPTO_CODE,FROM_SCM_SITE_ID,TO_SCM_SITE_ID,FINAL_SOLDTO_CODE,FINAL_INCOTERMS



                    --------------------------------------------------------------------------------------
                     SELECT COMPANY_ID,PLANT_ID,INCOTERMS,CUSTOMER_CODE,SHIPTO_CODE,FROM_SCM_SITE_ID,TO_SCM_SITE_ID,FINAL_SOLDTO_CODE,FINAL_INCOTERMS, CNT
                           ,NS1.NEW_VALUE1 AS TOBE_COMPANY_ID
                           ,NS2.NEW_VALUE1 AS TOBE_PLANT_ID
                           ,CASE WHEN (INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04')) THEN 'DAP'
                                WHEN (INCOTERMS IN ('A02', 'S32', 'S33'))               THEN 'EXW'
                                WHEN (INCOTERMS IN ('DAT'))              THEN 'DPU'
                                WHEN ((COMPANY_ID LIKE 'C%' OR COMPANY_ID LIKE 'HQ%') AND (INCOTERMS IN ('Z01'))) THEN 'EXW'
                                WHEN ((COMPANY_ID LIKE 'C%' OR COMPANY_ID LIKE 'HQ%') AND (INCOTERMS IN ('Z02'))) THEN 'DAP'
                                WHEN ((COMPANY_ID NOT LIKE 'C%' AND COMPANY_ID NOT LIKE 'HQ%') AND (INCOTERMS IN ('Z01'))) THEN 'DAP'
                                WHEN ((COMPANY_ID NOT LIKE 'C%' AND COMPANY_ID NOT LIKE 'HQ%') AND (INCOTERMS IN ('Z02'))) THEN 'EXW'
                                ELSE NULL
                            END TOBE_INCOTERMS

                           ,NS3.NEW_VALUE1 AS TOBE_CUSTOMER_CODE
                           ,NS4.NEW_VALUE1 AS TOBE_SHIPTO_CODE
                           ,NS5.NEW_VALUE1 AS TOBE_FROM_SCM_SITE_ID
                           ,NS6.NEW_VALUE1 AS TOBE_TO_SCM_SITE_ID
                           ,NS7.NEW_VALUE1 AS TOBE_FINAL_SOLDTO_CODE
                           ,CASE WHEN (FINAL_INCOTERMS IN ('A01', 'DDU', 'FAC', 'ZS3', 'Z03', 'Z04'))   THEN 'DAP'
                                WHEN (FINAL_INCOTERMS IN ('A02', 'S32', 'S33'))             THEN 'EXW'
                                WHEN (FINAL_INCOTERMS IN ('DAT'))                THEN 'DPU'
                                WHEN ((COMPANY_ID LIKE 'C%' OR COMPANY_ID LIKE 'HQ%') AND (FINAL_INCOTERMS IN ('Z01'))) THEN 'EXW'
                                WHEN ((COMPANY_ID LIKE 'C%' OR COMPANY_ID LIKE 'HQ%') AND (FINAL_INCOTERMS IN ('Z02'))) THEN 'DAP'
                                WHEN ((COMPANY_ID NOT LIKE 'C%' AND COMPANY_ID NOT LIKE 'HQ%') AND (FINAL_INCOTERMS IN ('Z01'))) THEN 'DAP'
                                WHEN ((COMPANY_ID NOT LIKE 'C%' AND COMPANY_ID NOT LIKE 'HQ%') AND (FINAL_INCOTERMS IN ('Z02'))) THEN 'EXW'
                                ELSE NULL
                            END TOBE_FINAL_INCOTERMS

                        INTO #TMP_SCM_DNM_INTRANSIT_C_H_CONV
                        FROM #TMP_SCM_DNM_INTRANSIT_C_H A WITH (NOLOCK)
                        LEFT JOIN #TMP_COMPANY_ID NS1 ON A.COMPANY_ID = NS1.OLD_VALUE1
                        LEFT JOIN #TMP_PLANT_ID NS2 ON A.PLANT_ID = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_END_CUSTOMER_ID NS3 ON A.CUSTOMER_CODE = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_END_CUSTOMER_ID NS4 ON A.SHIPTO_CODE = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS5 ON A.FROM_SCM_SITE_ID = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID NS6 ON A.TO_SCM_SITE_ID = NS2.OLD_VALUE1
                        LEFT JOIN #TMP_END_CUSTOMER_ID NS7 ON A.FINAL_SOLDTO_CODE = NS2.OLD_VALUE1



                --------------------------------------------------------------------------------------
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1, COLUMN_NAME2, COLUMN_NAME3,COLUMN_NAME4, COLUMN_NAME5, COLUMN_NAME6,COLUMN_NAME7, COLUMN_NAME8, COLUMN_NAME9
                    , OLD_VALUE1, OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6, OLD_VALUE7, OLD_VALUE8, OLD_VALUE9
                    , NEW_VALUE1, NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6, NEW_VALUE7, NEW_VALUE8, NEW_VALUE9
                    , CNT_ASIS, CHANGE_YN
                    , NEW_VALUE10, NEW_VALUE11
                    )
                    SELECT
                          'SCM_DNM_INTRANSIT_C_H'
                         ,'COMPANY_ID', 'PLANT_ID','INCOTERMS','CUSTOMER_CODE', 'SHIPTO_CODE','FROM_SCM_SITE_ID'
                         ,'TO_SCM_SITE_ID', 'FINAL_SOLDTO_CODE','FINAL_INCOTERMS'

                         , COMPANY_ID
                         ,PLANT_ID
                         ,INCOTERMS
                         ,CUSTOMER_CODE
                         ,SHIPTO_CODE
                         ,FROM_SCM_SITE_ID,TO_SCM_SITE_ID,FINAL_SOLDTO_CODE,FINAL_INCOTERMS
                         , TOBE_COMPANY_ID
                         , TOBE_PLANT_ID
                         , TOBE_INCOTERMS
                         , TOBE_CUSTOMER_CODE
                         , TOBE_SHIPTO_CODE
                         , TOBE_FROM_SCM_SITE_ID
                         , TOBE_TO_SCM_SITE_ID
                         , TOBE_FINAL_SOLDTO_CODE
                         , TOBE_FINAL_INCOTERMS

                         , CNT
                         , CASE WHEN ISNULL( TOBE_COMPANY_ID,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_PLANT_ID,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_INCOTERMS,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_CUSTOMER_CODE,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_SHIPTO_CODE,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_FROM_SCM_SITE_ID,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_TO_SCM_SITE_ID,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_FINAL_SOLDTO_CODE,'') != '' THEN 'Y'
                            WHEN ISNULL( TOBE_FINAL_INCOTERMS,'') != '' THEN 'Y'
                            ELSE NULL
                            END CHANGE_YN

                        ,@CUTOFF_FROM
                        ,@DIVISION
                    FROM #TMP_SCM_DNM_INTRANSIT_C_H_CONV C with (nolock)


                --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCM_DNM_INTRANSIT_C_H
                    DROP TABLE #TMP_SCM_DNM_INTRANSIT_C_H_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,OLD_VALUE6
                          ,OLD_VALUE7
                          ,OLD_VALUE8
                          ,OLD_VALUE9
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE6
                          ,NEW_VALUE7
                          ,NEW_VALUE8
                          ,NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                          ,OLD_VALUE2
                          ,OLD_VALUE3
                          ,OLD_VALUE4
                          ,OLD_VALUE5
                          ,OLD_VALUE6
                          ,OLD_VALUE7
                          ,OLD_VALUE8
                          ,OLD_VALUE9
                          ,NEW_VALUE1
                          ,NEW_VALUE2
                          ,NEW_VALUE3
                          ,NEW_VALUE4
                          ,NEW_VALUE5
                          ,NEW_VALUE6
                          ,NEW_VALUE7
                          ,NEW_VALUE8
                          ,NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE10 = @CUTOFF_FROM
                    AND    NEW_VALUE11 = @DIVISION;

                      UPDATE SCM_DNM_INTRANSIT_C_H
                         SET SCM_DNM_INTRANSIT_C_H.COMPANY_ID           = ISNULL(B.new_value1,  A.COMPANY_ID)
                            ,SCM_DNM_INTRANSIT_C_H.PLANT_ID             = ISNULL(B.new_value2,  A.PLANT_ID)
                            ,SCM_DNM_INTRANSIT_C_H.INCOTERMS            = ISNULL(B.new_value3,  A.INCOTERMS)
                            ,SCM_DNM_INTRANSIT_C_H.CUSTOMER_CODE        = ISNULL(B.new_value4,  A.CUSTOMER_CODE)
                            ,SCM_DNM_INTRANSIT_C_H.SHIPTO_CODE          = ISNULL(B.new_value5,  A.SHIPTO_CODE)
                            ,SCM_DNM_INTRANSIT_C_H.FROM_SCM_SITE_ID     = ISNULL(B.new_value6,  A.FROM_SCM_SITE_ID)
                            ,SCM_DNM_INTRANSIT_C_H.TO_SCM_SITE_ID       = ISNULL(B.new_value7,  A.TO_SCM_SITE_ID)
                            ,SCM_DNM_INTRANSIT_C_H.FINAL_SOLDTO_CODE    = ISNULL(B.new_value8,  A.FINAL_SOLDTO_CODE)
                            ,SCM_DNM_INTRANSIT_C_H.FINAL_INCOTERMS      = ISNULL(B.new_value10, A.FINAL_INCOTERMS)
                            ,SCM_DNM_INTRANSIT_C_H.ATTRIBUTE10          = @CREATED_BY
                       FROM .SCM_DNM_INTRANSIT_C_H AS A WITH (INDEX(PK_SCM_DNM_INTRANSIT_C_H_1)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --( SELECT *
                    --   FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --   where table_name = 'SCM_DNM_INTRANSIT_C_H'
                    --   and CHANGE_YN = 'Y'
                    --   and new_value10= @cutoff_from
                    --   and new_value11= @DIVISION
                    --   ) AS B
                      WHERE 1 = 1
                        AND A.COMPANY_ID                    = B.OLD_VALUE1
                        AND A.PLANT_ID                      = B.OLD_VALUE2
                        AND A.INCOTERMS                     = B.OLD_VALUE3
                        AND A.CUSTOMER_CODE                 = B.OLD_VALUE4
                        AND A.SHIPTO_CODE                   = B.OLD_VALUE5
                        AND A.FROM_SCM_SITE_ID              = B.OLD_VALUE6
                        AND A.TO_SCM_SITE_ID                = B.OLD_VALUE7
                        AND A.FINAL_SOLDTO_CODE             = B.OLD_VALUE8
                        AND A.FINAL_INCOTERMS               = B.OLD_VALUE9
                        AND A.HISTORY_SEQ                   =  @DIVISION
                        AND A.RESULT_DATE                   =  @cutoff_from


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- 20241202 대상컬럼 없음
                /*
                ELSE IF @TABLE_NAME = 'SCP_RPT_DIO_TREND_MM'
                    BEGIN
                    Print @TABLE_NAME
                    END
                */


                -- 20241202 대상컬럼 없음
                /*
                ELSE IF @TABLE_NAME = 'SCP_PLN_PRODUCTION_PLAN_PEGGING'
                    BEGIN
                    Print @TABLE_NAME
                    END
                */

                -- 20241209 추가 됨
                /*
                SCM_SITE_ID
                */
                ELSE IF @TABLE_NAME = 'SCP_ANL_PRODUCTION_PLAN_H'
                    BEGIN
                    /*
                    SCP_ANL_PRODUCTION_PLAN_H   SCM_SITE_ID SCM_SITE_ID
                    */
                    DELETE from NERP_CONV_SCP_DATA_BIG
                    where table_name = @TABLE_NAME
                    AND NEW_VALUE8 = @CUTOFF_FROM
                    AND NEW_VALUE9 = @DIVISION
                    AND NEW_VALUE10 = @PLAN_TYPE




                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240922'
                    --------------------------------------------------------------------------------------
                    -- 58 2초
                    SELECT OPERATION_ID, SCM_SITE_ID, count(*) AS CNT
                      INTO #TMP_SCP_ANL_PRODUCTION_PLAN_H
                      FROM SCP_ANL_PRODUCTION_PLAN_H A with (index(PK_SCP_ANL_PRODUCTION_PLAN_H), nolock)
                    where PLAN_START_YYYYMMDD =  @CUTOFF_FROM
                      and division_id = @DIVISION
                      and PLAN_TYPE = @PLAN_TYPE
                  group by OPERATION_ID, SCM_SITE_ID



                    --------------------------------------------------------------------------------------
                    -- 58 2초
                     SELECT OPERATION_ID, SCM_SITE_ID, CNT
                           ,B.NEW_VALUE1 AS TOBE_OPERATION_ID
                           ,C.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                        INTO #TMP_SCP_ANL_PRODUCTION_PLAN_H_CONV
                        FROM #TMP_SCP_ANL_PRODUCTION_PLAN_H A WITH (NOLOCK)
                        LEFT JOIN #TMP_VENDOR_ID B ON A.OPERATION_ID = B.OLD_VALUE1
                        LEFT JOIN #TMP_SCP_SITE_ID C ON A.SCM_SITE_ID = C.OLD_VALUE1


                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PRODUCTION_PLAN_H

                    --------------------------------------------------------------------------------------
                    -- 58 2초
                    INSERT INTO NERP_CONV_SCP_DATA_BIG
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2
                    , OLD_VALUE1, OLD_VALUE2
                    , NEW_VALUE1, NEW_VALUE2
                    , CNT_ASIS
                    , CHANGE_YN
                    , NEW_VALUE8, NEW_VALUE9, NEW_VALUE10
                    )
                    SELECT
                           'SCP_ANL_PRODUCTION_PLAN_H'
                         , 'OPERATION_ID' , 'SCM_SITE_ID'
                         , OPERATION_ID, SCM_SITE_ID
                         , TOBE_OPERATION_ID
                         , TOBE_SCM_SITE_ID
                         , CNT
                         , CASE WHEN ISNULL(TOBE_OPERATION_ID,'') != '' THEN 'Y'
                                WHEN ISNULL(TOBE_SCM_SITE_ID,'') != '' THEN 'Y'
                                ELSE NULL
                                END CHANGE_YN
                         , @CUTOFF_FROM, @DIVISION, @PLAN_TYPE
                    FROM #TMP_SCP_ANL_PRODUCTION_PLAN_H_CONV C with (nolock)



                    --------------------------------------------------------------------------------------
                    DROP TABLE #TMP_SCP_ANL_PRODUCTION_PLAN_H_CONV

                    --###############################################################################################################
                    -- UPDATE  LOOP
                    --###############################################################################################################

                    --2025-03-14 쿼리변경
                    DELETE
                    FROM @TMP_CONV_SCP_DATA_BIG;
                    INSERT INTO @TMP_CONV_SCP_DATA_BIG(
                           OLD_VALUE1
                         , OLD_VALUE2
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE9
                         , NEW_VALUE10
                    )
                    SELECT OLD_VALUE1
                         , OLD_VALUE2
                         , NEW_VALUE1
                         , NEW_VALUE2
                         , NEW_VALUE9
                         , NEW_VALUE10
                    FROM   NERP_CONV_SCP_DATA_BIG  AS B with (nolock)
                    WHERE  TABLE_NAME = @TABLE_NAME AND CHANGE_YN = 'Y'
                    AND    NEW_VALUE8 = @CUTOFF_FROM
                    AND    NEW_VALUE9 = @DIVISION
                    AND    NEW_VALUE10 = @PLAN_TYPE;

                    /*
                    40  0  초
                    81  0  초
                    82  0  초
                    EE  0  초
                    */

                    -- 358264 17초
                    --DECLARE @PLAN_START_YYYYMMDD  nvarchar(10) = '20240922'
                      UPDATE A
                         SET A.OPERATION_ID = ISNULL(B.new_value1, A.OPERATION_ID)
                            ,A.SCM_SITE_ID  = ISNULL(B.new_value2, A.SCM_SITE_ID)
                            ,A.ATTRIBUTE10  = @CREATED_BY
                       FROM SCP_ANL_PRODUCTION_PLAN_H AS A with (index(PK_SCP_ANL_PRODUCTION_PLAN_H)),
                            @TMP_CONV_SCP_DATA_BIG AS B
                    --(  SELECT OLD_VALUE1
                    --        , OLD_VALUE2
                    --        , NEW_VALUE1
                    --        , NEW_VALUE2
                    --        , NEW_VALUE9
                    --        , NEW_VALUE10
                    --    FROM NERP_CONV_SCP_DATA_BIG with (nolock)
                    --    where table_name = @TABLE_NAME
                    --    and CHANGE_YN = 'Y'
                    --    and NEW_VALUE8 = @CUTOFF_FROM
                    --    and NEW_VALUE9 = @DIVISION
                    --    and NEW_VALUE10 = @PLAN_TYPE
                    --) AS B
                      WHERE A.OPERATION_ID  = B.OLD_VALUE1
                        AND A.SCM_SITE_ID   = B.OLD_VALUE2
                        AND A.PLAN_START_YYYYMMDD = @CUTOFF_FROM
                        AND A.DIVISION_ID         = @DIVISION
                        AND A.PLAN_TYPE           = @PLAN_TYPE

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
            '@CNT = ' , @CNT
            , ' , @LOOKUP_TYPE = ', @TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            , ' , @END_TIME = '   , @END_TIME
            , ' , @RUN_TIME = '   , @RUN_TIME
            );



           UPDATE NERP_CONV_SCP_CUTOFF
              SET MAPPING_START             = @START_TIME
                , MAPPING_END               = @END_TIME
                , MAPPING_TIME              = @RUN_TIME
                , mapping_RESULT            = 'FINISH'
                , UPDATE_USER               = 'NERP_SCP_BATCH'
                , UPDATE_DATE               = GETDATE()
            where TABLE_NAME                = @TABLE_NAME
            and CUTOFF_FROM                 = @CUTOFF_FROM
            and CUTOFF_TO                   = @CUTOFF_TO
            and CUTOFF_DIVISION             = @DIVISION
            and ISNULL(CUTOFF_plan_type,'') = ISNULL(@PLAN_TYPE,'')
            AND CUTOFF_SORT                 = @RNO



        END


        --################################################################
        -- Log
        --################################################################
            --SET @END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            --SET @RUN_TIME = DATEDIFF(SECOND, @START_TIME, @END_TIME)
            SET @DUMMY = 'END->'+' '+CONVERT(NVARCHAR(30),@CNT_TBL)+concat(
            ' @CNT = ' , @CNT
            , ' , @TABLE_NAME = ', @TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            , ' , @P_GROUP_NUM = ', CONVERT(NVARCHAR(30),@P_GROUP_NUM)
            , ' , @P_GROUP_COUNT = ', CONVERT(NVARCHAR(30),@P_GROUP_COUNT)
            );

            --2025-05-18 테이블당 1회만 처리
            --PRINT @DUMMY
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'RUN', @RUN_TIME, @TABLE_NAME,  @DUMMY, @d_event_date;
            --처음 1회만 테이블이 바뀔때 처리
            --IF @C_PRINT_YN = 1
            BEGIN
                PRINT @DUMMY
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'RUN', @RUN_TIME, @TABLE_NAME,  @DUMMY, @d_event_date;
            END

        --COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        --IF @@TRANCOUNT > 0
        --    ROLLBACK TRANSACTION;
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @DUMMY = @v_description+','+ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();
    END CATCH

        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME, @CUTOFF_FROM, @CUTOFF_TO, @DIVISION, @PLAN_TYPE, @RNO, @CUTOFF_START

        END
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;

        DROP TABLE IF EXISTS #TMP_COMPANY_ID;
        DROP TABLE IF EXISTS #TMP_PLANT_ID;
        DROP TABLE IF EXISTS #TMP_SCP_SITE_ID;
        DROP TABLE IF EXISTS #TMP_SCP_SITE_DESCRIPTION;
        DROP TABLE IF EXISTS #TMP_STORAGE_ID;
        DROP TABLE IF EXISTS #TMP_VENDOR_ID;
        DROP TABLE IF EXISTS #TMP_END_CUSTOMER_ID;

        SET @BATCH_END_TIME = SYSDATETIME();
        SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
        PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  @v_description, @BATCH_END_TIME;



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
