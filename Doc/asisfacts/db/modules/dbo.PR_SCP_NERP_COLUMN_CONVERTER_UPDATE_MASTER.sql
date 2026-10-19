
-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER
-- Author:       vadabi5
-- Create date:  2024-04-29
-- Description:  NERP) Master  관련 코드 생성
-- ==========================================================================================
/*

2025-06-12 SCM_MST_SITE_ENG 신규추가만 있음
2025-06-12 SCM_MST_SITE_ITEM 신규추가 올드 삭제


-- 20240429     vadabi5     NERP) 신규 생성
-- 20240510     vadabi5     NERP) SCM_MST_SITE_CUSTOMER 신규 입력 시 구코드 REP_YN = N 처리
-- 20240612     vadabi5     NERP) SCM_MST_SITE_CUSTOMER, Vendor 전채 신규코드 적용 방식
-- 20240613     vadabi5     NERP) SCM_MST_SITE_CUSTOMER, Vendor ASIS 남기고 TOBE 추가하는 방식으로 변경
-- 20240614     vadabi5     NERP) SCM_MST_SITE_CUSTOMER, Vendor ASIS 남기고 TOBE 추가방식 완료 및 백업
-- 20240819     vadabi5     NERP) SCM_MST_SITE_CUSTOMER, Vendor -> End_customer 적용
-- 20240820     vadabi5     NERP) SCM_MST_CUSTOMER,         Vendor -> End_customer 적용
-- 20240911     vadabi5     NERP) SCM_MST_SITE_ITEM,    SALES_COMPANY,  SALES_PLANT 대상에 포함
-- 20240911     vadabi5     NERP) SCM_MST_VENDOR,       AFFILIATE_CODE, NVARCHAR(10) -> 30
-- 20240917     vadabi5     NERP) 통합테스트 3차 위한 준비
-- 20240927     vadabi5     NERP) NERP_CONV_MASTER_CFM_V 기준 적용
-- 20240928     vadabi5     NERP) SCM_MST_CUSTOMER, SCM_MST_LOCATION (신규생성, ASIS 처리 방식)
-- 20241007     vadabi5     NERP) SCM_DNM_MAT_DOCUMENT       : DM
                                  SCM_DNM_STOCK_SALES        : DM
                                  SCM_MST_SITE              : SALES ? DM / PLANT - SCP
                                  SCM_MST_SITE_CUSTOMER         : DM
                                  SCM_MST_SITE_ENG          : SCP
                                  SCM_MST_SITE_ITEM             : SALES ? DM / PLANT - SCP
                                  SCM_MST_SITE_ITEM_PRIORITY : SCP

-- 20241106     vadabi5     NERP)   SCM_MST_LOCATION 20241106 오류 발생
                             -- SCM_SITE_ID 등록된 코드와 비교할 것
                             -- 현재는 SCM_SITE_ID 를 생성해서 사용하고 있어 오류가 발생
                             -- SCM_SITE_ID = Vendor, Customer 알 수 없어 복잡한 로직이 되어 오류 유발
                             -- SCM_SITE_ID = Vendor 결론
-- 20241212     vadabi5     NERP)   SCP_SITE_DESCRIPTION 미적용 관련 재적용 안전장치 추가
-- 20241223     vadabi5     NERP)   SCM_MST_SITE_ITEM 컬럼추가
                                    PRJ_OWNR_ID
                                    CRGE_ORG_NM
                                    CUST_ENG_NM
-- 20250310     김준규      NERP)   BOD 인컴텀즈 제외, 라우트 사용부분 반영(20241230 변경적용 된 사항)
-- 20250407     김준규      NERP)   SCM_MST_SITE_CUSTOMER, SCM_SITE_ID,SOLDTO,SHIPTO 기준 변경적용이후 SCM_SITE_ID 만 UPDATE시 중복에러 발생 수정
--                                  SCM_SITE_ID 만 UPDATE도 중복제거 로직 추가.     
-- 20250421     김준규      NERP)   ZNERP_DEV_ITEM_SCHEDULE테이블에 SCM_MST_SITE_CUSTOMER 컬럼 중복 1개 추가	
                                   기존 : dev_detail:SCM_SITE_ID,mapping_column:SCM_SITE_ID
                                   추가 : dev_detail:SCM_SITE_ID,mapping_column:PLANT_ID
-- 20250421     김준규      NERP)   ZNERP_DEV_ITEM_SCHEDULE테이블에 SCM_MST_SITE_ITEM 컬럼 중복 1개 추가	
                                   기존 : dev_detail:SCM_SITE_ID,mapping_column:SCM_SITE_ID
                                   추가 : dev_detail:SCM_SITE_ID,mapping_column:PLANT_ID
-- 20250422     김준규      NERP)   ZNERP_DEV_ITEM_SCHEDULE테이블에 SCM_MST_CUSTOMER 컬럼 중복 1개 추가	
                                   기존 : dev_detail:SHIPTO_CODE,mapping_column:COMPANY_ID
                                   기존 : dev_detail:SHIPTO_CODE,mapping_column:END_CUSTOMER_ID
                                   추가 : dev_detail:SHIPTO_CODE,mapping_column:PLANT_ID
                                   기존 : dev_detail:SOLDTO_CODE,mapping_column:COMPANY_ID
                                   기존 : dev_detail:SOLDTO_CODE,mapping_column:END_CUSTOMER_ID
                                   추가 : dev_detail:SOLDTO_CODE,mapping_column:PLANT_ID
-- 20250515     김준규      NERP)   SCM_MST_LOCATION은 VALID_YN에 과거 값은 N처리하는 것 재 검토 부탁드립니다.(현재 OLD값 살아 있음)
                                   신규 추가 처리 후 중복 발생 시 하나만 N 처리, 과거 정보 N 처리(4개를 변경하는데 4개 전부 과거일경우 N처리)
                                   아래2개는 처리 보류 대상이 너무 많음.
                                   Operation_ID 기준 Key : DIVISON_ID, SCM_SITE_ID, PLANT_ID, FACTOTY_ID, OPERATION_ID 
                                   Storage_ID 기준 Key : DIVISON_ID, SCM_SITE_ID, PLANT_ID, Storage _ID
-- 20250518     김준규      NERP)   SCM_MST_LOCATION 적용한 것 취소(운영에 이관후 점검작업시 처리)
                                   --2025-05-18 아래에 의거 2025-05-16 적용 작업한 것 막음
                                   --2025-05-16 (금) 오전 11:51
                                   --김춘동(choondong kim)[kimcd] <kimcd@lgespartner.com>
                                   --RE: LOOKUP 및 Master성 Table 의 Valid_YN 관련 공유
-- 20250522     김준규      NERP)   SCM_MST_SITE_CUSTOMER의 경우는 SCM_SITE_ID 만 OLD TO NEW Conversion 하기로 함(김춘동 책임님 의견 합당함)
-- 20250612     김준규      NERP)   SCM_MST_SITE의 SCM_SITE_ID SCP_SITE_ID에 COMPANY_ID 추가하여 보완
-- 20250612     김준규      NERP)   SCM_MST_SITE_ENG의 ENG_SCM_SITE_ID는 SCP_SITE_ID에 그대로 매칭하여 보완
-- 20250612     김준규      NERP)   SCM_MST_SITE_ITEM의 SCM_SITE_ID는 SCP_SITE_ID에 그대로 매칭하여 보완
-- 20250629     김준규      NERP)   SCM_MST_SITE의 ATTRIBUTE5 추가를 ATTRIBUTE2로 변경
-- 20250722     김준규      NERP)   SCM_MST_SITE_ENG의 SCM_SITE_ID 변경오류 수정
-- 20250805     김준규      NERP)   SCP_MST_BOD AS SMD WHERE  FROM_SITE= 'G184-E', SCM_MST_SITE_ITEM WHERE  SCM_SITE_ID IN ( 'G631','G451','G183') 삭제처리
-- 20250929		유명훈		NERP)	SCP_MST_BOD BOD 인코텀즈에서 SCP_MST_BOD.ATTRIBUTE10 활용으로 현 프로시저에 SCP_MST_BOD.ATTRIBUTE10 로직 제거

*/
-- ==========================================================================================
/*
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER @P_TABLE='',@P_ROLLIN='1ST'
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER @P_TABLE='',@P_ROLLIN='2ND'


-- EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER 'SCM_MST_SITE_CUSTOMER','2ND'
-- select * from SCM_SYS_LOG_BATCH where program_name = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INSERT' and log_type = 'SCM_MST_CUSTOMER' order by event_date

-- ALTER TABLE SCM_MST_VENDOR
-- alter column AFFILIATE_CODE NVARCHAR(30)
-- NVARCHAR(10) -> 30
-- ALTER TABLE SCM_MST_VENDOR alter column AFFILIATE_CODE NVARCHAR(30)

-- drop procedure PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_INSERT

INSERT INTO SCM_MST_CUSTOMER        SELECT * FROM SCM_MST_CUSTOMER      ;
INSERT INTO SCM_MST_LOCATION        SELECT * FROM SCM_MST_LOCATION      ;
INSERT INTO SCM_MST_OSP_SLOC        SELECT * FROM SCM_MST_OSP_SLOC      ;
INSERT INTO SCM_MST_SITE            SELECT * FROM SCM_MST_SITE          ;
INSERT INTO SCM_MST_SITE_CUSTOMER   SELECT * FROM SCM_MST_SITE_CUSTOMER ;
INSERT INTO SCM_MST_SITE_ENG        SELECT * FROM SCM_MST_SITE_ENG      ;
INSERT INTO SCM_MST_SITE_ITEM       SELECT * FROM SCM_MST_SITE_ITEM     ;
INSERT INTO SCM_MST_SLOC            SELECT * FROM SCM_MST_SLOC          ;
INSERT INTO SCM_MST_VENDOR          SELECT * FROM SCM_MST_VENDOR        ;
INSERT INTO SCP_MST_BOD             SELECT * FROM SCP_MST_BOD           ;


exec PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER @P_TABLE = 'SCM_MST_SITE_ITEM', @P_ROLLIN = '3RD'
*/
-- =============================================


CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER]

 @P_TABLE   nvarchar(100)
,@P_ROLLIN  nvarchar(30) --1ST 2ND 3RD 4TH

AS
BEGIN

    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

    -- 2025-08-05 김준규 NERP) SCP_ANL_PSI_INTEGRATION WHERE [COMPANY_ID]= 'G183' -- 1월 초 오류 정보로 보입니다. 삭제하시지요
    DECLARE @NERP_THIRD_STAGE NVARCHAR(128);
    SET @NERP_THIRD_STAGE = '3'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASRXDTE','3,5');--알디 에스티
    --
    IF @P_ROLLIN = @NERP_THIRD_STAGE
    BEGIN
        DELETE SMD
        --SELECT * 
        FROM   SCP_MST_BOD AS SMD WITH(NOLOCK)
        WHERE  FROM_SITE= 'G184-E'
        ;
        DELETE MSI
        --SELECT * 
        FROM   SCM_MST_SITE_ITEM  AS MSI WITH(NOLOCK)
        WHERE  SCM_SITE_ID IN ( 'G631','G451','G183')
        ;
    END;


--################################################################################################################
--DECLARE
--################################################################################################################
    DECLARE @TABLE_NAME   NVARCHAR(150) = N'';
    SET @TABLE_NAME = @P_TABLE
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


    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_MASTER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;

    -- 시작 LOG
    SET @v_log_type = @P_TABLE;
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_log_message = '';
    SET @v_description = '@P_TABLE:'+@P_TABLE+',@P_ROLLIN:'+@P_ROLLIN;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();


    PRINT '------------------------------------------------------------------------------------------------------------------------------------------';
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', @n_log_count, @v_log_message,  @v_description, @d_event_date;
    PRINT CONCAT( 'START = ', @BATCH_START_TIME)





BEGIN TRY

        --################################################################
        -- Temp Table Create
        --################################################################
        BEGIN -- TEMP TABLE
        IF OBJECT_ID('tempdb..#TMP_COMPANY') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_COMPANY
        END

        IF OBJECT_ID('tempdb..#TMP_PLANT') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_PLANT
        END

        IF OBJECT_ID('tempdb..#TMP_PLANT_RANK') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_PLANT_RANK
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


        IF OBJECT_ID('tempdb..##TMP_VENDOR_CUSTOMER') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_VENDOR_CUSTOMER
        END

        IF OBJECT_ID('tempdb..#TMP_PLANT_RANK') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_PLANT_RANK
        END


        IF OBJECT_ID('tempdb..#TMP_CUSTOMER_RANK') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_CUSTOMER_RANK
        END



        IF OBJECT_ID('tempdb..#TMP_VENDOR_CUSTOMER') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_VENDOR_CUSTOMER
        END


        IF OBJECT_ID('tempdb..#TMP_CUSTOMER_VENDOR_PLANT_COMPANY') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_CUSTOMER_VENDOR_PLANT_COMPANY
        END

        IF OBJECT_ID('tempdb..#TMP_CUSTOMER_VENDOR_PLANT_COMPANY_RANK') IS NOT NULL
        BEGIN
        DROP TABLE  #TMP_CUSTOMER_VENDOR_PLANT_COMPANY_RANK
        END


        IF OBJECT_ID('tempdb..#TMP_SCM_MST_SITE_ENG') IS NOT NULL
        BEGIN
        DROP TABLE  #TMP_SCM_MST_SITE_ENG
        END


        --#################################################################################
        -- TEMP MAPPING TABLE
        --#################################################################################
        -- 3
        SELECT OLD_VALUE1 AS ASIS_COMPANY, NEW_VALUE1 AS TOBE_COMPANY , DESC1 AS DESC01
        INTO #TMP_COMPANY
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'COMPANY_ID'
        AND ATTRIBUTE5 = @P_ROLLIN


        ----------------------------------------------------------------------
        -- 17
        SELECT OLD_VALUE1 AS ASIS_PLANT, NEW_VALUE1 AS TOBE_PLANT , DESC1 AS DESC01
             , rank () over (partition by NEW_VALUE1 order by OLD_VALUE1) AS RNO
        INTO #TMP_PLANT
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'PLANT_ID'
        AND ATTRIBUTE5 = @P_ROLLIN

        ----------------------------------------------------------------------
        -- 13
        --[A010, A011] 등 중복되는 경우 제외
        SELECT ASIS_PLANT
             , TOBE_PLANT
             , DESC01
        INTO #TMP_PLANT_RANK
        FROM #TMP_PLANT
        WHERE RNO = 1


        ----------------------------------------------------------------------
        -- 53599 -> 53599
        SELECT OLD_VALUE1 AS ASIS_VENDOR
             , NEW_VALUE1 AS TOBE_VENDOR
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
             , rank () over (partition by NEW_VALUE1 order by OLD_VALUE1) AS RNO
        INTO #TMP_VENDOR
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'VENDOR_ID'
        AND ATTRIBUTE5 = @P_ROLLIN
        AND NEW_VALUE1 != N'삭제'
        AND NEW_VALUE1 NOT LIKE  N'%미정%'



        ----------------------------------------------------------------------
        -- 37873 -> 37869 -> 37867
        SELECT OLD_VALUE1 AS ASIS_CUSTOMER
             , NEW_VALUE1 AS TOBE_CUSTOMER
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
             , rank () over (partition by NEW_VALUE1 order by OLD_VALUE1) AS RNO
        INTO #TMP_CUSTOMER
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'END_CUSTOMER_ID'
        AND ATTRIBUTE5 = @P_ROLLIN
        AND NEW_VALUE1 != N'삭제'
        AND NEW_VALUE1 NOT LIKE  N'%미정%'

        ----------------------------------------------------------------------
        -- #TMP_CUSTOMER_PLANT_COMPANY
        -- 37885 -> 37883 -> 37879
        SELECT *
        INTO #TMP_CUSTOMER_PLANT_COMPANY
        from
        (
            SELECT ASIS_CD
                  ,TOBE_CD
                  ,GUBUN
                  , rank () over (partition by ASIS_CD order by GUBUN) AS RNO
            FROM
            (
                    SELECT 3 AS GUBUN , ASIS_COMPANY AS ASIS_CD     , TOBE_COMPANY AS TOBE_CD   FROM #TMP_COMPANY
                    UNION
                    SELECT 2 AS GUBUN , ASIS_PLANT AS ASIS_CD       , TOBE_PLANT AS TOBE_CD     FROM #TMP_PLANT_RANK
                    UNION
                    SELECT 1 AS GUBUN , ASIS_CUSTOMER AS ASIS_CD    , TOBE_CUSTOMER AS TOBE_CD  FROM #TMP_CUSTOMER

            ) list
        ) list2
        where rno = 1
         and isnull(asis_cd,'') != ''

        ----------------------------------------------------------------------
        -- ##TMP_VENDOR_PLANT_COMPANY
        -- 53615 -> 53612
        SELECT *
        INTO #TMP_VENDOR_PLANT_COMPANY
        from
        (
            SELECT ASIS_CD
                  ,TOBE_CD
                  ,GUBUN
                  , rank () over (partition by ASIS_CD order by GUBUN) AS RNO
            --INTO #TMP_VENDOR_PLANT_COMPANY
            FROM
            (
                    SELECT 3 AS GUBUN , ASIS_COMPANY AS ASIS_CD     , TOBE_COMPANY AS TOBE_CD   FROM #TMP_COMPANY
                    UNION
                    SELECT 2 AS GUBUN , ASIS_PLANT AS ASIS_CD       , TOBE_PLANT AS TOBE_CD     FROM #TMP_PLANT_RANK
                    UNION
                    SELECT 1 AS GUBUN , ASIS_VENDOR AS ASIS_CD      , TOBE_VENDOR AS TOBE_CD    FROM #TMP_VENDOR

            ) list
        ) list2
        where rno = 1
         and isnull(asis_cd,'') != ''


        ----------------------------------------------------------------------
        -- 103 -> 124
        select OLD_VALUE2 AS ASIS_SCM_SITE_ID
              ,OLD_VALUE1 AS ASIS_SCM_SITE_ID_BODY
              ,NEW_VALUE2 AS TOBE_SCM_SITE_ID
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
        AND isnull(OLD_VALUE1,'')  != ''

        ----------------------------------------------------------------------
        -- 627
        SELECT ASIS_PLANT, ASIS_STORAGE
             , TOBE_PLANT, TOBE_STORAGE
             , DESC01, DESC02, DESC03
             , ETC1, ETC2
             , RANK () OVER (PARTITION BY TOBE_PLANT, TOBE_STORAGE  ORDER BY ASIS_PLANT, ASIS_STORAGE ) AS RNO
        INTO #TMP_STORAGE_RANK
        FROM #TMP_STORAGE


        END

        --################################################################
        -- 작업 초기화
        --################################################################

        DECLARE @RE_WORK nvarchar(2) = 'N'

        if @RE_WORK = 'Y'
        begin
            print @RE_WORK
            --delete from SCM_MST_CUSTOMER         where created_by = @CREATED_BY
            --delete from SCM_MST_LOCATION         where created_by = @CREATED_BY
            --delete from SCM_MST_OSP_SLOC         where created_by = @CREATED_BY
            --delete from SCM_MST_SITE             where created_by = @CREATED_BY
            --delete from SCM_MST_SITE_CUSTOMER    where created_by = @CREATED_BY
            --delete from SCM_MST_SITE_ENG         where created_by = @CREATED_BY
            --delete from SCM_MST_SITE_ITEM        where created_by = @CREATED_BY
            --delete from SCM_MST_SLOC             where created_by = @CREATED_BY
            --delete from SCM_MST_VENDOR           where created_by = @CREATED_BY
            --delete from SCP_MST_BOD              where created_by = @CREATED_BY
        end



    --###########################################################################################################
    -- CURSOR_MAPPING
    --###########################################################################################################

        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END

        DECLARE CURSOR_MAPPING CURSOR FOR

            -- Data List
           SELECT distinct program_id AS TABLE_NAME
               --, dev_detail as COLUMN_NAME
               --, MAPPING_COLUMN as MAPPING_COLUMN
             FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
            where DEV_TYPE = 'Batch_Conversion'
            and mapping_use IN ( 'IN')
            --and program_id = 'SCM_MST_LOCATION'
            --and program_id != 'SCM_MST_CUSTOMER'
            --and program_id in ('SCM_MST_OSP_SLOC','SCM_MST_SITE','SCM_MST_SITE_ENG','SCP_MST_BOD')
            --and (@P_TABLE IS NULL OR program_id = @P_TABLE)
            --and dev_detail in (@P_COLUMN)
            and (@P_TABLE IS NULL OR @P_TABLE ='' OR program_id = @P_TABLE)
            order by TABLE_NAME--program_id

            --PK 컬럼
             /*SELECT
                 t.name AS TableName,
                 c.name AS ColumnName
             FROM
                 sys.tables t
             INNER JOIN
                 sys.indexes i ON t.object_id = i.object_id
             INNER JOIN
                 sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
             INNER JOIN
                 sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
             WHERE
                 i.is_primary_key = 1
                 AND t.name IN ('SCM_MST_CUSTOMER'
             ,'SCM_MST_LOCATION'
             ,'SCM_MST_OSP_SLOC'
             ,'SCM_MST_SITE'
             ,'SCM_MST_SITE_CUSTOMER'
             ,'SCM_MST_SITE_ENG'
             ,'SCM_MST_SITE_ITEM'
             ,'SCM_MST_SLOC'
             ,'SCM_MST_VENDOR'
             ,'SCP_MST_BOD');*/


        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME

        WHILE @@FETCH_STATUS = 0
        BEGIN

    BEGIN TRY
        --BEGIN TRANSACTION;

            print concat('CURSOR_MAPPING = ', @TABLE_NAME)
            SET @MAPPING_RESULT = 'N';
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);



            IF NOT EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @TABLE_NAME)
            begin
                    --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @n_log_count, @COLUMN_NAME,  'NO EXISTS TABLE OR COLUMN', @d_event_date;
                    PRINT CONCAT('TABLE EXIST None = ', @TABLE_NAME)
                    RETURN;
            end

            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @n_log_count, @COLUMN_NAME,  'BATCH Start', @d_event_date;


        --################################################################
        -- 작업
        --################################################################
                -- 1, Key 변경 된 경우                               = Insert
                -- 2, Key 변경 된 Asis Data는 아무                    = Update 없음
                -- 3, Key 변경 안 된 Asis Data의 Key가 아닌 경우  = 업데이트 처리
                IF @TABLE_NAME = 'SCM_MST_CUSTOMER'
                    BEGIN

                    --################################################################
                    -- NERP_CONV_SCP_DATA 에 입력
                    --################################################################
                    DELETE from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_CUSTOMER';
                    --------------------------------------------------------------------------------------
                    --TableName ColumnName
                    --SCM_MST_CUSTOMER  DIVISION_ID
                    --SCM_MST_CUSTOMER  SOLDTO_CODE
                    --SCM_MST_CUSTOMER  SHIPTO_CODE

                    -- 10133 -> 9672
                    -- 20241211 9936
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                    )
                    SELECT *
                    FROM (
                        SELECT
                               'SCM_MST_CUSTOMER' AS TABLE_NAME
                               , 'DIVISION_ID' AS COLUMN_NAME1, 'SOLDTO_CODE' AS COLUMN_NAME2, 'SHIPTO_CODE' AS COLUMN_NAME3
                              ,DIVISION_ID, SOLDTO_CODE , SHIPTO_CODE
                             , DIVISION_ID AS NEW_VALUE1
                             , NV1.TOBE_CD AS NEW_VALUE2
                             , NV2.TOBE_CD AS NEW_VALUE3
                        FROM SCM_MST_CUSTOMER C with (nolock)
                        LEFT JOIN (select ASIS_CD,TOBE_CD,GUBUN,RNO from #TMP_CUSTOMER_PLANT_COMPANY) NV1 ON NV1.ASIS_CD = SOLDTO_CODE
                        LEFT JOIN (select ASIS_CD,TOBE_CD,GUBUN,RNO from #TMP_CUSTOMER_PLANT_COMPANY) NV2 ON NV2.ASIS_CD = SHIPTO_CODE
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   NERP_CONV_SCP_DATA MD  WITH (NOLOCK)
                                    WHERE  MD.TABLE_NAME    = X.TABLE_NAME
                                    AND    MD.COLUMN_NAME1  = X.COLUMN_NAME1
                                    AND    MD.COLUMN_NAME2  = X.COLUMN_NAME2
                                    AND    MD.COLUMN_NAME3  = X.COLUMN_NAME3
                                    );

                    --################################################################
                    -- #tmp_customer_tobe
                    --################################################################
                        -- 8606 -> 8601 -> 8140
                        SELECT old_value1, old_value2, old_value3
                              , TOBE_SOLD, TOBE_SHIP
                              , rank () over (partition by old_value1, TOBE_SOLD, TOBE_SHIP order by old_value1,old_value2, old_value3 ) as rno
                        into #tmp_customer_tobe
                        from
                        (
                            select old_value1, old_value2, old_value3
                                  , ISNULL(new_value2,old_value2)  AS TOBE_SOLD
                                  , ISNULL(new_value3,old_value3)   AS TOBE_SHIP

                            from NERP_CONV_SCP_DATA
                            where table_name = 'SCM_MST_CUSTOMER'
                            and (isnull(new_value2,'') !='' or isnull(new_value3,'') !='')
                        ) list

                    --################################################################
                    -- 신규코드 입력
                    --################################################################
                        --8571 -> 8117 -> 8250
                    --SCM_MST_CUSTOMER  DIVISION_ID
                    --SCM_MST_CUSTOMER  SOLDTO_CODE
                    --SCM_MST_CUSTOMER  SHIPTO_CODE
                        insert into SCM_MST_CUSTOMER
                        SELECT *
                        FROM (
                            select
                             DIVISION_ID
                            ,ISNULL(TOBE_SOLD, SOLDTO_CODE) AS SOLDTO_CODE
                            ,ISNULL(TOBE_SHIP, SHIPTO_CODE) AS SHIPTO_CODE
                            ,SOLDTO_DESCRIPTION
                            ,SOLDTO_ADDRESS
                            ,SOLDTO_COUNTRY
                            ,SOLDTO_REGION
                            ,SOLDTO_REGION_NAME
                            ,SOLDTO_CITY_NAME
                            ,SHIPTO_DESCRIPTION
                            ,SHIPTO_ADDRESS
                            ,SHIPTO_COUNTRY
                            ,SHIPTO_REGION
                            ,SHIPTO_REGION_NAME
                            ,SHIPTO_CITY_NAME
                            ,VALID_YN
                            ,CREATED_BY,CREATION_DATE
                            --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                            --,CREATED_BY as CREATED_BY
                            --,CREATION_DATE AS CREATION_DATE
                            ,@CREATED_BY as LAST_UPDATED_BY
                            , GETDATE() AS LAST_UPDATE_DATE
                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,CONCAT('NERP_TOBE_CODE','-',RNO) AS ATTRIBUTE10
                            ,CITY
                            ,SHIPTO_CITY
                            from SCM_MST_CUSTOMER C with (nolock)
                            inner join (select old_value1,old_value2,old_value3,TOBE_SOLD,TOBE_SHIP,rno from #tmp_customer_tobe) B
                            ON C.division_id = B.old_value1
                            and C.soldto_code = B.old_value2
                            and C.shipto_code = B.old_value3
                            where B.rno = 1
                        ) X
                        WHERE 1=1
                        AND NOT EXISTS (SELECT 1
                                        FROM   SCM_MST_CUSTOMER MD  WITH (NOLOCK)
                                        WHERE  MD.DIVISION_ID  = X.DIVISION_ID
                                        AND    MD.SOLDTO_CODE  = X.SOLDTO_CODE
                                        AND    MD.SHIPTO_CODE  = X.SHIPTO_CODE
                                        );

                    --################################################################
                    -- 신규코드 생성 된 ASIS 데이터 삭제
                    --################################################################
                        -- 20240813 신규생성 데이터의 ASIS는 Valid = N 처리 해 준다
                        -- TODO : 20240928 신규생성 데이터의 ASIS는 삭제한다 - 운영적용 시 다시 한 번 확인 필요

                        -- 20241211 : Customer 신코드 있는 경우의 구코드도 그대로 유지
                        DECLARE @v_SCM_MST_CUSTOMER_asis nvarchar(10) = 'DELETE'
                        /*
                        if @v_SCM_MST_CUSTOMER_asis = 'UPDATE'
                        begin
                         --select VALID_YN from SCM_MST_CUSTOMER where DIVISION_ID = '40' and SOLDTO_CODE = 'BE000044' and SHIPTO_CODE = 'BE000044'

                         UPDATE SCM_MST_CUSTOMER
                            SET SCM_MST_CUSTOMER.VALID_YN  = 'N'
                          FROM .SCM_MST_CUSTOMER AS A,
                            (select old_value1, old_value2, old_value3 from #tmp_customer_tobe where rno = 1) AS B
                            WHERE A.DIVISION_ID                 = B.OLD_VALUE1
                              AND A.SOLDTO_CODE                 = B.OLD_VALUE2
                              AND A.SHIPTO_CODE                 = B.OLD_VALUE3

                             --select VALID_YN from SCM_MST_CUSTOMER where DIVISION_ID = '40' and SOLDTO_CODE = 'BE000044' and SHIPTO_CODE = 'BE000044'
                        end

                        else
                        begin
                            --select count(*) from SCM_MST_CUSTOMER

                            DELETE SCM_MST_CUSTOMER
                              FROM SCM_MST_CUSTOMER a
                              JOIN #tmp_customer_tobe b
                                on A.DIVISION_ID= B.OLD_VALUE1
                               AND A.SOLDTO_CODE                    = B.OLD_VALUE2
                               AND A.SHIPTO_CODE                    = B.OLD_VALUE3

                            -- 9649
                            --select count(*) from SCM_MST_CUSTOMER
                        end
                        */

                    --################################################################
                    -- 남은 ASIS 데이터 업데이트 0건
                    -- 변경 필요한 것은 모두 처리한 상태
                    --################################################################


                    SET @MAPPING_RESULT = 'Y';
                    END

                 -- 20241106 오류 발생
                 -- SCM_SITE_ID 등록된 코드와 비교할 것
                 -- 현재는 SCM_SITE_ID 를 생성해서 사용하고 있어 오류가 발생
                ELSE IF @TABLE_NAME = 'SCM_MST_LOCATION'
                --SCM_MST_LOCATION  LOCATION_SEQ
                    BEGIN


                    delete from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_LOCATION';
                    update SCM_MST_LOCATION set attribute9 = 'ASIS DATA'


                    --select *
                    --from SCM_MST_LOCATION
                    --where  attribute9 != 'ASIS DATA'

                    --------------------------------------------------------------------------------------
                    -- LOCATION_SEQ
                    -- 967 -> 1012
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                        TABLE_NAME
                      , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5
                      , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5
                      , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5
                    )
                    SELECT
                           'SCM_MST_LOCATION'
                           , 'LOCATION_SEQ', 'PLANT_ID' , 'SCM_SITE_ID', 'STORAGE_ID', 'ATTRIBUTE2'
                         , LOCATION_SEQ, PLANT_ID , SCM_SITE_ID, STORAGE_ID, C.ATTRIBUTE2
                         , LOCATION_SEQ
                         , NP1.NEW_VALUE1 as  TOBE_PLANT
                         , NS1.NEW_VALUE1 as  TOBE_SCM_SITE_ID
                         , NST1.TOBE_STORAGE
                         , NST2.TOBE_STORAGE

                    from
                    (
                        SELECT
                            LOCATION_SEQ, PLANT_ID , SCM_SITE_ID, STORAGE_ID, ATTRIBUTE2
                        from SCM_MST_LOCATION C with (nolock)
                    ) C
                    LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID'    AND ATTRIBUTE5 = @P_ROLLIN) NP1  ON NP1.OLD_VALUE1 = C.PLANT_ID
                    LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' AND ATTRIBUTE5 = @P_ROLLIN) NS1  ON NS1.OLD_VALUE1 = C.SCM_SITE_ID
                    LEFT JOIN (SELECT ASIS_PLANT,ASIS_STORAGE,TOBE_PLANT,TOBE_STORAGE,DESC01,DESC02,DESC03,ETC1,ETC2,RNO FROM #TMP_STORAGE_RANK ) NST1 ON NST1.ASIS_PLANT = C.PLANT_ID AND NST1.ASIS_STORAGE = C.STORAGE_ID
                    LEFT JOIN (SELECT ASIS_PLANT,ASIS_STORAGE,TOBE_PLANT,TOBE_STORAGE,DESC01,DESC02,DESC03,ETC1,ETC2,RNO FROM #TMP_STORAGE_RANK ) NST2 ON NST2.ASIS_PLANT = C.PLANT_ID AND NST2.ASIS_STORAGE = C.ATTRIBUTE2


                    --------------------------------------------------------------------------------------
                    -- ASIS 삭제 버전
                    --------------------------------------------------------------------------------------
                     -- 967

                    --------------------------------------------------------------------------------------
                    -- ASIS 남기고 TOBE 추가 버전
                    --------------------------------------------------------------------------------------
                   --select * from SCM_MST_LOCATION where attribute10 like 'NERP%'
                    --select count(*) from SCM_MST_LOCATION
                    -- 399 -> 460

                    INSERT INTO SCM_MST_LOCATION
                    SELECT *
                    FROM (
                        SELECT
                         LOCATION_SEQ + 1400 AS LOCATION_SEQ
                        ,DIVISION_ID
                        ,LOCATION_CODE
                        ,LOCATION_DESCRIPTION
                        ,SCM_SITE_ID = case when isnull(New_value3,'') = '' THEN SCM_SITE_ID ELSE New_value3 END
                        ,PLANT_ID = case when isnull(New_value2,'') = '' THEN PLANT_ID ELSE New_value2 END
                        ,FACTORY_ID
                        ,OPERATION_ID
                        ,STORAGE_ID = case when isnull(New_value4,'') = '' THEN STORAGE_ID ELSE New_value4 END
                        ,ELECTRODE_TYPE
                        ,VALID_YN
                        ,CREATED_BY
                        ,CREATION_DATE
                        --,LAST_UPDATED_BY
                        --,LAST_UPDATE_DATE
                        --,@CREATED_BY as CREATED_BY
                        --, GETDATE() AS CREATION_DATE
                        ,@CREATED_BY as LAST_UPDATED_BY
                        , GETDATE() AS LAST_UPDATE_DATE
                        ,ATTRIBUTE1
                        --20250629     김준규      NERP)   SCM_MST_SITE의 ATTRIBUTE5 추가를 ATTRIBUTE2로 변경
                        ,ATTRIBUTE2 = case when isnull(New_value5,'') = '' THEN ATTRIBUTE2 ELSE New_value5 END
                        ,ATTRIBUTE3
                        ,ATTRIBUTE4
                        ,ATTRIBUTE5 
                        ,ATTRIBUTE6
                        ,ATTRIBUTE7
                        ,ATTRIBUTE8
                        ,'NERP_TOBE_CODE' AS ATTRIBUTE9
                        ,ATTRIBUTE10

                        FROM SCM_MST_LOCATION L with (nolock)
                        LEFT JOIN (
                            -- 460
                            select old_value1,  old_value2,  old_value3,  old_value4,  old_value5
                                 , new_value1,  new_value2,  new_value3,  new_value4,  new_value5
                                 , 'Y' AS MAPPING
                            from NERP_CONV_SCP_DATA
                            where table_name = 'SCM_MST_LOCATION'
                            and ( isnull(new_value2,'') != ''
                                 or isnull(new_value3,'') != ''
                                 or isnull(new_value4,'') != ''
                                 or isnull(new_value5,'') != ''
                                 )
                        ) B
                        ON L.LOCATION_SEQ = B.old_value1
                        WHERE ISNULL(B.MAPPING,'') = 'Y'
                        ) X
                        WHERE 1=1
                        AND NOT EXISTS (SELECT 1
                                        FROM   SCM_MST_LOCATION MD  WITH (NOLOCK)
                                        WHERE  MD.LOCATION_SEQ = X.LOCATION_SEQ
                                        );


                    -- 1012 + 460 = 1472
                    --select count(*) from SCM_MST_LOCATION

                    -- 2025-05-18 아래에 의거 2025-05-16 적용 작업한 것 막음
                    --2025-05-16 (금) 오전 11:51
                    --김춘동(choondong kim)[kimcd] <kimcd@lgespartner.com>
                    --RE: LOOKUP 및 Master성 Table 의 Valid_YN 관련 공유

                    --안녕하십니까?

                    --김춘동 책임입니다

                    --김준규 부장님..

                    --아래 scm_mst_location 갱신하는 작업은 data 일괄 전환 script에 넣지 마시고,
                    --별도 검증 단계에서 갱신하지요..

                    --첨부는 3월에 sales site의 location_code 갱신했던 문장입니다.
                    --이 문장 포함해서 정보 검증 단계에서 갱신하시지요..

                    --•   롤인이 완료된 OLD PLANT_ID 에 대한 정보는 VALID_YN = ‘N’ 처리

                    --위 작업까지 해서 총 4개의 scm_mst_location 갱신 문장이 필요합니다.
                    --1차 Open했던 법인 비활성화도 2차 Open 전환하면서 같이 진행하시지요..                    

                    ----2025-05-16 적용
                    ----SCM_MST_LOCATION은 VALID_YN에 과거 값은 N처리하는 것 재 검토 부탁드립니다.(현재 OLD값 살아 있음)
                    ----신규 추가 처리 후 중복 발생 시 하나만 N 처리, 과거 정보 N 처리(4개를 변경하는데 4개 전부 과거일경우 N처리)
                    ----Operation_ID 기준 Key : DIVISION_ID, SCM_SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID 
                    ----Storage_ID 기준 Key : DIVISON_ID, SCM_SITE_ID, PLANT_ID, Storage _ID
                    ----
                    ----Operation_ID 기준 Key : LOCATION_CODE KEY에 추가했으나 많음.(적용보류)
                    --WITH W_RAW AS (
                    --    SELECT SML.*
                    --          ,RNUM = ROW_NUMBER()OVER(PARTITION BY DIVISION_ID, LOCATION_CODE, SCM_SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID 
                    --                               ORDER BY SML.LOCATION_SEQ)
                    --    FROM   SCM_MST_LOCATION AS SML WITH(NOLOCK)
                    --    WHERE  SML.VALID_YN = 'Y'
                    --    AND    ISNULL(OPERATION_ID, '') NOT IN ( '', '***')
                    --)
                    --UPDATE SML
                    --SET    VALID_YN = 'N'
                    --      ,LAST_UPDATED_BY = @CREATED_BY
                    --      ,LAST_UPDATE_DATE = GETDATE()
                    --FROM   SCM_MST_LOCATION AS SML WITH(NOLOCK)
                    --JOIN   W_RAW AS WR ON WR.LOCATION_SEQ = SML.LOCATION_SEQ
                    --WHERE  SML.VALID_YN = 'Y'
                    --AND    RNUM > 1
                    --;

                    ----2025-05-16 적용
                    ----SCM_MST_LOCATION은 VALID_YN에 과거 값은 N처리하는 것 재 검토 부탁드립니다.(현재 OLD값 살아 있음)
                    ----신규 추가 처리 후 중복 발생 시 하나만 N 처리, 과거 정보 N 처리(4개를 변경하는데 4개 전부 과거일경우 N처리)
                    ----Operation_ID 기준 Key : DIVISION_ID, SCM_SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID 
                    ----Storage_ID 기준 Key : DIVISON_ID, SCM_SITE_ID, PLANT_ID, Storage _ID
                    ----
                    ----Storage_ID 기준 Key : 너무 많음(적용보류)
                    --WITH W_RAW AS (
                    --    SELECT SML.*
                    --          ,RNUM = ROW_NUMBER()OVER(PARTITION BY DIVISION_ID, SCM_SITE_ID, PLANT_ID, SML.STORAGE_ID
                    --                               ORDER BY SML.LOCATION_SEQ)
                    --    FROM   SCM_MST_LOCATION AS SML WITH(NOLOCK)
                    --    WHERE  SML.VALID_YN = 'Y'
                    --    AND    ISNULL(STORAGE_ID, '') <> ''
                    --)
                    --UPDATE SML
                    --SET    VALID_YN = 'N'
                    --      ,LAST_UPDATED_BY = @CREATED_BY
                    --      ,LAST_UPDATE_DATE = GETDATE()
                    --FROM   SCM_MST_LOCATION AS SML WITH(NOLOCK)
                    --JOIN   W_RAW AS WR ON WR.LOCATION_SEQ = SML.LOCATION_SEQ
                    --WHERE  SML.VALID_YN = 'Y'
                    --AND    RNUM > 1
                    --;

                    ---- 2025-05-15 적용
                    ---- 4개 변경한 코드가 변경전 값이면 VALID_YN 값을 N 처리한다
                    --UPDATE SML
                    --SET    SML.VALID_YN = 'N'
                    --      ,LAST_UPDATED_BY = @CREATED_BY
                    --      ,LAST_UPDATE_DATE = GETDATE()
                    --FROM   SCM_MST_LOCATION sml WITH(NOLOCK)
                    --WHERE  1=1
                    --AND    VALID_YN = 'Y'
                    --AND    EXISTS (SELECT 1
                    --               FROM   NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
                    --               WHERE  MCV.CODETYPE = 'SCP_SITE_ID'
                    --               AND    MCV.OLD_VALUE1 = sml.SCM_SITE_ID)
                    --AND    EXISTS (SELECT 1
                    --               FROM   NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
                    --               WHERE  MCV.CODETYPE = 'PLANT_ID'
                    --               AND    MCV.OLD_VALUE1 = sml.PLANT_ID)
                    --AND    EXISTS (SELECT 1
                    --               FROM   NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
                    --               WHERE  MCV.CODETYPE = 'STORAGE_ID'
                    --               AND    MCV.OLD_VALUE1 = sml.PLANT_ID
                    --               AND    MCV.OLD_VALUE2 = sml.STORAGE_ID)
                    --AND    EXISTS (SELECT 1
                    --               FROM   NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
                    --               WHERE  MCV.CODETYPE = 'STORAGE_ID'
                    --               AND    MCV.OLD_VALUE1 = sml.PLANT_ID
                    --               AND    MCV.OLD_VALUE2 = sml.ATTRIBUTE2);


                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCM_MST_OSP_SLOC'
                 BEGIN

                    --SCM_MST_OSP_SLOC  DIVISION_ID
                    --SCM_MST_OSP_SLOC  PLANT_ID
                    --SCM_MST_OSP_SLOC  STORAGE_ID
                    --SCM_MST_OSP_SLOC  SCM_SITE_ID

                    update SCM_MST_OSP_SLOC set attribute10 = @CREATED_BY;
                    DELETE from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_OSP_SLOC';
                    --------------------------------------------------------------------------------------
                    -- 20
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                        TABLE_NAME
                      , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4
                      , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4
                      , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3, NEW_VALUE4
                    )

                    SELECT 'SCM_MST_OSP_SLOC'
                          , 'DIVISION_ID' , 'PLANT_ID', 'SCM_SITE_ID' , 'STORAGE_ID'
                          ,DIVISION_ID, PLANT_ID, SCM_SITE_ID , STORAGE_ID
                         , DIVISION_ID
                         , NP1.TOBE_PLANT
                         --, NS1.NEW_VALUE1
                         , replace(SCM_SITE_ID,  SCM_SITE_ID_BODY, NV1.TOBE_VENDOR) AS TOBE_SITE
                         , NST1.TOBE_STORAGE
                    from
                    (
                        SELECT
                           DIVISION_ID, PLANT_ID, SCM_SITE_ID , STORAGE_ID
                           ,CASE WHEN charindex( '-', SCM_SITE_ID) > 0 AND charindex( '_', SCM_SITE_ID) > 0
                                 THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'-'),0,'_')
                                 WHEN charindex( '-', SCM_SITE_ID) > 0
                                 THEN dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'-')
                                 WHEN charindex( '_', SCM_SITE_ID) > 0
                                 THEN dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'_')
                                 ELSE SCM_SITE_ID
                                 END SCM_SITE_ID_BODY


                        from SCM_MST_OSP_SLOC C with (nolock)
                    ) C
                    LEFT JOIN (          SELECT ASIS_PLANT,TOBE_PLANT,DESC01 FROM #TMP_PLANT_RANK ) NP1  ON NP1.ASIS_PLANT = C.PLANT_ID
                    LEFT JOIN (          SELECT ASIS_VENDOR, TOBE_VENDOR FROM #TMP_VENDOR     ) NV1 ON NV1.ASIS_VENDOR = C.SCM_SITE_ID_BODY
                    LEFT JOIN (          SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                         FROM NERP_CONV_MASTER_CFM_V
                                         WHERE CODETYPE IN ( 'SCP_SITE_ID' , 'ENG_SCM_SITE_ID')
                                         and NEW_VALUE1 IS NOT NULL
                                         and ATTRIBUTE5 = @P_ROLLIN
                    ) NS1  ON NS1.OLD_VALUE1 = C.SCM_SITE_ID
                    LEFT JOIN (SELECT ASIS_PLANT,ASIS_STORAGE,TOBE_PLANT,TOBE_STORAGE,DESC01,DESC02,DESC03,ETC1,ETC2,RNO FROM #TMP_STORAGE_RANK ) NST1 ON NST1.ASIS_PLANT = C.PLANT_ID AND NST1.ASIS_STORAGE = C.STORAGE_ID


                    --------------------------------------------------------------------------------------
                    -- ASIS 삭제 버전
                    --------------------------------------------------------------------------------------
                     ---- 20
                    --------------------------------------------------------------------------------------
                    -- ASIS 남기고 TOBE 추가 버전
                    --------------------------------------------------------------------------------------


                    -- 20

                    INSERT INTO SCM_MST_OSP_SLOC
                    SELECT *
                    FROM (
                        SELECT
                          DIVISION_ID
                        , PLANT_ID = case when isnull(New_value2,'') = '' THEN PLANT_ID ELSE New_value2 END
                        , STORAGE_ID = case when isnull(New_value4,'') = '' THEN STORAGE_ID ELSE New_value4 END
                        , SCM_SITE_ID = case when isnull(New_value3,'') = '' THEN SCM_SITE_ID ELSE New_value3 END
                        , DESCRIPTION
                        , VALID_YN
                            ,CREATED_BY,CREATION_DATE
                            --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                            --,@CREATED_BY as CREATED_BY
                            --, GETDATE() AS CREATION_DATE
                            ,@CREATED_BY as LAST_UPDATED_BY
                            , GETDATE() AS LAST_UPDATE_DATE
                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
                            ,'NERP_TOBE_DATA' AS ATTRIBUTE10
                        FROM SCM_MST_OSP_SLOC L with (nolock)
                        LEFT JOIN (
                            select old_value1,  old_value2,  old_value3,  old_value4
                                 , new_value1,  new_value2,  new_value3,  new_value4
                                 , 'Y' AS MAPPING
                            from NERP_CONV_SCP_DATA
                            where table_name = 'SCM_MST_OSP_SLOC'
                            and ( isnull(new_value1,'') != '' or isnull(new_value2,'') != '' or isnull(new_value3,'') != ''  or isnull(new_value4,'') != '')
                        ) B
                        ON L.DIVISION_ID = B.old_value1
                        AND L.PLANT_ID = B.old_value2
                        AND L.STORAGE_ID = B.old_value4
                        AND L.SCM_SITE_ID = B.old_value3
                        WHERE ISNULL(B.MAPPING,'') = 'Y'
                        and case when isnull(New_value2,'') = '' THEN PLANT_ID ELSE New_value2 END  != 'G182'
                        --order by 1,2,3,4,5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_MST_OSP_SLOC MD  WITH (NOLOCK)
                                    WHERE  MD.DIVISION_ID  = X.DIVISION_ID
                                    AND    MD.PLANT_ID     = X.PLANT_ID
                                    AND    MD.STORAGE_ID   = X.STORAGE_ID
                                    AND    MD.SCM_SITE_ID  = X.SCM_SITE_ID
                                    )
                    ORDER BY 1,2,3,4,5

                    -- 20 + 20 = 40
                    -- SELECT count(*) from SCM_MST_OSP_SLOC

                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241007 : SALES ? DM / PLANT - SCP 처리하도록 변경
                ELSE IF @TABLE_NAME = 'SCM_MST_SITE'
                 BEGIN

                    --SCM_MST_SITE  DIVISION_ID
                    --SCM_MST_SITE  SCM_SITE_ID
                    update SCM_MST_SITE set attribute10 = @CREATED_BY;
                    DELETE from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_SITE';
                    --------------------------------------------------------------------------------------
                    -- 2460 / 2542
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                        TABLE_NAME
                      , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_COMMENT
                      , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6, OLD_COMMENT
                      , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6, NEW_COMMENT
                    )
                    -- 2460 -> 2540
                    SELECT
                           'SCM_MST_SITE'
                         , 'DIVISION_ID'  , 'COMPANY_ID' , 'HQ_VENDOR_CODE', 'LOGISTIC_PLANT_ID' , 'PLANT_ID', 'SCM_SITE_ID', 'SITE_DESCRIPTION'
                         , DIVISION_ID
                         , ISNULL(COMPANY_ID,'')
                         , HQ_VENDOR_CODE, LOGISTIC_PLANT_ID, PLANT_ID, SCM_SITE_ID, SITE_DESCRIPTION
                         ----------------------------------------------------------------------------------
                         , DIVISION_ID
                         , ISNULL(NC1.TOBE_COMPANY,'')
                         , CASE WHEN HQ_VENDOR_CODE = 'KR002881,KR010334'
                                THEN 'KR02092100,KR02095700'
                                ELSE NS2.TOBE_CD
                                END AS TOBE_HQ_VENDOR_CODE
                         , NP1.TOBE_PLANT AS TOBE_LOGISTIC_PLANT_ID
                         ,  CASE WHEN OSP_YN = 'Y'  THEN NP3.TOBE_CD
                                 WHEN OSP_YN = 'N' THEN NP2.TOBE_PLANT
                                 ELSE NULL
                                 END AS TOBE_PLANT_ID
                         , ISNULL(NS1.NEW_VALUE1,NC2.NEW_VALUE1)
                         , NULL AS COMMENT

                    from SCM_MST_SITE C with (nolock)
                    LEFT JOIN (SELECT ASIS_COMPANY,TOBE_COMPANY,DESC01 FROM #TMP_COMPANY ) NC1  ON NC1.ASIS_COMPANY = C.COMPANY_ID
                    LEFT JOIN (SELECT ASIS_PLANT,TOBE_PLANT,DESC01,RNO FROM #TMP_PLANT   ) NP1  ON NP1.ASIS_PLANT = C.LOGISTIC_PLANT_ID
                    LEFT JOIN (SELECT ASIS_PLANT,TOBE_PLANT,DESC01,RNO FROM #TMP_PLANT   ) NP2  ON NP2.ASIS_PLANT = C.PLANT_ID
                    LEFT JOIN (SELECT ASIS_CD,TOBE_CD,GUBUN,RNO FROM #TMP_VENDOR_PLANT_COMPANY) NS2  ON NS2.ASIS_CD = C.HQ_VENDOR_CODE
                    LEFT JOIN (SELECT ASIS_CD,TOBE_CD,GUBUN,RNO FROM #TMP_VENDOR_PLANT_COMPANY) NP3  ON NP3.ASIS_CD = C.PLANT_ID
                    LEFT JOIN (          SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                         FROM NERP_CONV_MASTER_CFM_V
                                         WHERE CODETYPE IN ( 'SCP_SITE_ID' , 'ENG_SCM_SITE_ID')
                                         and NEW_VALUE1 IS NOT NULL
                                         and ATTRIBUTE5 = @P_ROLLIN
                    ) NS1  ON NS1.OLD_VALUE1 = C.SCM_SITE_ID
                    --2025-06-12 COMPANY_ID 보완
                    LEFT JOIN (          SELECT OLD_VALUE1, NEW_VALUE1
                                         FROM NERP_CONV_MASTER_CFM_V
                                         WHERE CODETYPE = 'COMPANY_ID'
                                         and NEW_VALUE1 IS NOT NULL
                                         and ATTRIBUTE5 = @P_ROLLIN
                    ) NC2  ON NC2.OLD_VALUE1 = C.SCM_SITE_ID


                        --#################################################################################
                        -- 신규입력 데이터
                        --#TMP_INPUT_SCM_SITE_ID
                        -- 4922 3708   -- 2540 중 1911 변환
                        --#################################################################################
                        SELECT
                           DIVISION_ID
                        , old_value6 AS SCM_SITE_ID_ASIS
                        , case when isnull(new_value6,'') = '' THEN old_value6 ELSE new_value6 END AS SCM_SITE_ID
                        , case when isnull(new_value5,'') = '' THEN old_value5 ELSE new_value5 END AS PLANT_ID
                        ,OPERATION_GROUP
                        ,SITE_DESCRIPTION
                        ,SITE_TYPE
                        ,CITY
                        ,COUNTRY
                        ,DEPT_ID
                        ,VMI_YN
                        ,VALID_YN
                        ,NEW_YN
                        ,SITE_HRCY_ID
                        ,OSP_YN
                        ,SHIP_FROZEN
                        ,PROD_FROZEN
                        ,END_CUSTOMER
                        ,SOLDTO_CUSTOMER
                        ,FP_PLAN_PERIOD
                        ,BUILD_AHEAD
                        , case when isnull(New_value4,'') = '' THEN old_value4 ELSE New_value4 END AS LOGISTIC_PLANT_ID
                        ,PACKER_ITEM_ID_SUFFIX
                        , case when isnull(new_value3,'') = '' THEN old_value3 ELSE new_value3 END AS HQ_VENDOR_CODE
                        , case when isnull(New_value2,'') = '' THEN old_value2 ELSE New_value2 END AS COMPANY_ID
                        ,SITE_ID
                        ,CREATED_BY,CREATION_DATE
                        --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --,@CREATED_BY as CREATED_BY
                        --, GETDATE() AS CREATION_DATE
                        ,@CREATED_BY as LAST_UPDATED_BY
                        , GETDATE() AS LAST_UPDATE_DATE
                        ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                        ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
                        ,'NERP_TOBE_DATA' AS ATTRIBUTE10
                        INTO #TMP_INPUT_SCM_SITE_ID
                            FROM SCM_MST_SITE S with (nolock)
                            LEFT JOIN (
                                    -- 1864
                                    --DIVISION_ID   COMPANY_ID  HQ_VENDOR_CODE  LOGISTIC_PLANT_ID   PLANT_ID    SCM_SITE_ID
                                    SELECT result.*
                                    from
                                    (
                                        SELECT list.*
                                            , rank () over (partition by old_value1, isnull(new_value6, old_value6) order by old_value1, old_value6, old_value2, gubun) AS rno
                                        from
                                        (
                                            -- 2540 중 1913 변경
                                            select A.*
                                                 , CASE WHEN ISNULL(A.OLD_COMMENT,'') !=  ISNULL(B.NEW_VALUE1 ,'')  THEN B.NEW_VALUE1
                                                        ELSE NULL
                                                        END AS TOBE_COMMENT
                                                 ,  'Y' AS  MAPPING
                                                 , 1 AS gubun
                                            from NERP_CONV_SCP_DATA  A
                                        left join (
                                                    SELECT DISTINCT OLD_VALUE1, NEW_VALUE1
                                                     FROM NERP_CONV_MASTER_CFM_V
                                                     WHERE CODETYPE IN (  'SCP_SITE_DESCRIPTION')
                                                     and isnull(OLD_VALUE1,'') != isnull(NEW_VALUE1,'')
                                                     AND ATTRIBUTE5 = @P_ROLLIN
                                        ) B
                                                on A.OLD_COMMENT = B.OLD_VALUE1

                                            where A.table_name = 'SCM_MST_SITE'
                                            and ( isnull(A.new_value2, '') != ''
                                               or isnull(A.new_value3, '') != ''
                                               or isnull(A.new_value4, '') != ''
                                               or isnull(A.new_value5, '') != ''
                                               or isnull(A.new_value6, '') != ''
                                               )
                                        ) list
                                    ) result
                                    where rno = 1


                                    ) AS B ON S.DIVISION_ID = B.old_value1
                                       AND S.SCM_SITE_ID = B.old_value6
                                where MAPPING = 'Y'
                                and rno = 1
                                order by new_value6






                        --#################################################################################
                        --#TMP_INPUT_SCM_SITE_ID
                        -- 4922 3708   -- 2540 중 1911 변환
                        --#################################################################################

                    -- 1911 신규코드 발생한 ASIS 데이터 삭제
                    DELETE SCM_MST_SITE
                      FROM SCM_MST_SITE a
                      JOIN #TMP_INPUT_SCM_SITE_ID b
                        on A.DIVISION_ID= B.DIVISION_ID
                       AND A.SCM_SITE_ID= B.SCM_SITE_ID_ASIS

                    -- 1911 신규코드 입력
                    INSERT INTO SCM_MST_SITE
                    SELECT
                     DIVISION_ID
                    ,SCM_SITE_ID
                    ,PLANT_ID
                    ,OPERATION_GROUP
                    ,SITE_DESCRIPTION
                    ,SITE_TYPE,CITY,COUNTRY,DEPT_ID
                    ,VMI_YN,VALID_YN,NEW_YN,SITE_HRCY_ID,OSP_YN
                    ,SHIP_FROZEN,PROD_FROZEN
                    ,END_CUSTOMER
                    ,SOLDTO_CUSTOMER
                    ,FP_PLAN_PERIOD,BUILD_AHEAD,LOGISTIC_PLANT_ID,PACKER_ITEM_ID_SUFFIX
                    ,HQ_VENDOR_CODE,COMPANY_ID,SITE_ID
                    ,CREATED_BY,CREATION_DATE
                    --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                    --,@CREATED_BY as CREATED_BY
                    --, GETDATE() AS CREATION_DATE
                    ,@CREATED_BY as LAST_UPDATED_BY
                    , GETDATE() AS LAST_UPDATE_DATE
                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                    FROM #TMP_INPUT_SCM_SITE_ID X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_MST_SITE MD  WITH (NOLOCK)
                                    WHERE  MD.DIVISION_ID  = X.DIVISION_ID
                                    AND    MD.SCM_SITE_ID  = X.SCM_SITE_ID
                                    )
                    ORDER BY 1,2,3,4,5


                        --#################################################################################
                        -- 신규코드 입력 되면서 구desc 로 적용 됨 -> 적용순서 변경
                        -- 20241212 SCP_SITE_DESCRIPTION 미적용 관련 재적용 안전장치 추가
                        --#################################################################################

                            UPDATE SCM_MST_SITE
                            SET SCM_MST_SITE.site_description  = B.NEW_VALUE1
                               ,LAST_UPDATED_BY = @CREATED_BY
                               ,LAST_UPDATE_DATE = GETDATE()
                            FROM .SCM_MST_SITE AS A,
                            (
                            select old_value1,new_value1
                            from NERP_CONV_MASTER_CFM_V
                            where codetype = 'SCP_SITE_DESCRIPTION'
                            and ATTRIBUTE5 = @P_ROLLIN
                            and old_value1 != new_value1
                            ) AS B
                            WHERE   A.site_description                  = B.OLD_VALUE1


                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCM_MST_SITE_ENG'
                 BEGIN

                    --SCM_MST_SITE_ENG  MODELING_ID
                    --SCM_MST_SITE_ENG  PLAN_ID
                    --SCM_MST_SITE_ENG  PLAN_TYPE
                    --SCM_MST_SITE_ENG  PLAN_SEQ
                    --SCM_MST_SITE_ENG  DIVISION_ID
                    --SCM_MST_SITE_ENG  SCM_SITE_ID
                    --SCM_MST_SITE_ENG  ENG_SCM_SITE_ID
                    -- 12465
                    update SCM_MST_SITE_ENG set attribute10 = @CREATED_BY;
                    DELETE FROM NERP_CONV_SCP_DATA 
                    WHERE TABLE_NAME = 'SCM_MST_SITE_ENG';

                    --------------------------------------------------------------------------------------
                    -- 2460 / 12465
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                        TABLE_NAME
                      , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7,COLUMN_NAME8,COLUMN_NAME9,COLUMN_NAME10,COLUMN_COMMENT
                      , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6, OLD_VALUE7, OLD_VALUE8, OLD_VALUE9, OLD_VALUE10, OLD_COMMENT
                      , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6, NEW_VALUE7, NEW_VALUE8, NEW_VALUE9, NEW_VALUE10, NEW_COMMENT
                    )
                    -- 11575 / 12465
                    SELECT
                           'SCM_MST_SITE_ENG'
                         , 'MODELING_ID', 'PLAN_ID'  , 'PLAN_TYPE' , 'PLAN_SEQ', 'DIVISION_ID' , 'SCM_SITE_ID', 'ENG_SCM_SITE_ID', 'COMPANY_ID', 'LOGISTIC_PLANT_ID', 'PLANT_ID', 'SITE_DESCRIPTION'
                         , MODELING_ID, PLAN_ID, PLAN_TYPE, PLAN_SEQ, DIVISION_ID
                         , SCM_SITE_ID, ENG_SCM_SITE_ID, COMPANY_ID, LOGISTIC_PLANT_ID, PLANT_ID
                         , SITE_DESCRIPTION

                         , MODELING_ID, PLAN_ID, PLAN_TYPE, PLAN_SEQ, DIVISION_ID
                         , NS1.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                         --2025-06-12 컬럼 매핑으로 변경
                         --, CASE WHEN ISNULL(NS1.NEW_VALUE1,'') != ''
                         --       THEN REPLACE(ENG_SCM_SITE_ID, SCM_SITE_ID, NS1.NEW_VALUE1)
                         --       ELSE  NULL
                         --       END AS TOBE_ENG_SCM_SITE_ID
                         , NS2.NEW_VALUE1 AS TOBE_ENG_SCM_SITE_ID
                         , NC1.TOBE_COMPANY AS TOBE_COMPANY
                         , NP1.TOBE_PLANT AS TOBE_LOGISTIC_PLANT
                         , NP2.TOBE_PLANT AS TOBE_PLANT
                         , NC10.NEW_VALUE1  AS COMMENT
                    from SCM_MST_SITE_ENG C with (nolock)
                    LEFT JOIN (SELECT ASIS_COMPANY,TOBE_COMPANY,DESC01 FROM #TMP_COMPANY ) NC1  ON NC1.ASIS_COMPANY = C.COMPANY_ID
                    LEFT JOIN (SELECT ASIS_PLANT,TOBE_PLANT,DESC01 FROM #TMP_PLANT_RANK  ) NP1  ON NP1.ASIS_PLANT = C.LOGISTIC_PLANT_ID
                    LEFT JOIN (SELECT ASIS_PLANT,TOBE_PLANT,DESC01,RNO FROM #TMP_PLANT   ) NP2  ON NP2.ASIS_PLANT = C.PLANT_ID
                    LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE codetype = 'SCP_SITE_ID'
                                  and NEW_VALUE1 IS NOT NULL
                                  and ATTRIBUTE5 = @P_ROLLIN
                    ) NS1  ON NS1.OLD_VALUE1 = C.SCM_SITE_ID
                    LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE codetype = 'SCP_SITE_ID'
                                  and NEW_VALUE1 IS NOT NULL
                                  and ATTRIBUTE5 = @P_ROLLIN
                    ) NS2  ON NS2.OLD_VALUE1 = C.ENG_SCM_SITE_ID

                    LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE codetype = 'SCP_SITE_DESCRIPTION'
                                  and ISNULL(NEW_VALUE1,'') != ''
                                  and ISNULL(NEW_VALUE1,'') != ISNULL(OLD_VALUE1,'')
                                  and ATTRIBUTE5 = @P_ROLLIN
                    ) NC10  ON NC10.OLD_VALUE1 = C.SITE_DESCRIPTION
                    ORDER BY COMPANY_ID, LOGISTIC_PLANT_ID, PLANT_ID, SCM_SITE_ID



                    --##############################################################
                    -- 신규코드 입력
                    --##############################################################
                    -- 1402
                    INSERT INTO SCM_MST_SITE_ENG
                    SELECT *
                    FROM (
                        select
                            NEW_VALUE1   AS MODELING_ID
                          , NEW_VALUE2   AS PLAN_ID
                          , NEW_VALUE3   AS PLAN_TYPE
                          , NEW_VALUE4   AS PLAN_SEQ
                          , NEW_VALUE5   AS DIVISION_ID
                          , NEW_VALUE6   AS SCM_SITE_ID
                          , NEW_VALUE7   AS ENG_SCM_SITE_ID
                          --2025-07-22 ISNULL(NEW_VALUE8,PLANT_ID) --> ISNULL(NEW_VALUE10,PLANT_ID) 변경
                          , ISNULL(NEW_VALUE10,PLANT_ID)      AS PLANT_ID
                        ,OPERATION_GROUP
                        , ISNULL(NEW_COMMENT,SITE_DESCRIPTION) AS SITE_DESCRIPTION
                        ,SITE_TYPE
                        ,CITY
                        ,COUNTRY
                        ,DEPT_ID
                        ,VMI_YN
                        ,VALID_YN
                        ,NEW_YN
                        ,SITE_HRCY_ID
                        ,OSP_YN
                        ,SHIP_FROZEN
                        ,PROD_FROZEN
                        ,END_CUSTOMER
                        ,SOLDTO_CUSTOMER
                        ,FP_PLAN_PERIOD
                        ,BUILD_AHEAD
                        , ISNULL(NEW_VALUE9,LOGISTIC_PLANT_ID) AS LOGISTIC_PLANT_ID
                        , ISNULL(NEW_VALUE8,COMPANY_ID) AS COMPANY_ID
                        ,SITE_ID
                        ,CREATED_BY,CREATION_DATE
                        --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --,@CREATED_BY as CREATED_BY
                        --, GETDATE() AS CREATION_DATE
                        ,@CREATED_BY as LAST_UPDATED_BY
                        , GETDATE() AS LAST_UPDATE_DATE
                        ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
                        ,'NERP_TOBE_DATA' AS ATTRIBUTE10
                        from NERP_CONV_SCP_DATA A
                        LEFT JOIN SCM_MST_SITE_ENG  B  ON A.OLD_VALUE1 = B.MODELING_ID
                                                    AND A.OLD_VALUE2 = B.PLAN_ID
                                                    AND A.OLD_VALUE3 = B.PLAN_TYPE
                                                    AND A.OLD_VALUE4 = B.PLAN_SEQ
                                                    AND A.OLD_VALUE5 = B.DIVISION_ID
                                                    AND A.OLD_VALUE6 = B.SCM_SITE_ID
                                                    AND A.OLD_VALUE7 = B.ENG_SCM_SITE_ID
                        where table_name = 'SCM_MST_SITE_ENG'
                        --2025-07-22 OR isnull(NEW_VALUE7,'') != '' 추가
                        and (isnull(NEW_VALUE6,'') != '' OR isnull(NEW_VALUE7,'') != '' )
                        --2025-07-22 OR isnull(NEW_VALUE7,'') != '' 추가
                        and (OLD_VALUE6 != isnull(NEW_VALUE6,'') OR OLD_VALUE7 != isnull(NEW_VALUE7,''))
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_MST_SITE_ENG MD  WITH (NOLOCK)
                                    WHERE  MD.MODELING_ID     = X.MODELING_ID
                                    AND    MD.PLAN_ID         = X.PLAN_ID
                                    AND    MD.PLAN_TYPE       = X.PLAN_TYPE
                                    AND    MD.PLAN_SEQ        = X.PLAN_SEQ
                                    AND    MD.DIVISION_ID     = X.DIVISION_ID
                                    --2025-07-22 ISNULL(X.SCM_SITE_ID    ,''), ISNULL(X.ENG_SCM_SITE_ID,'') 추가
                                    AND    MD.SCM_SITE_ID     = ISNULL(X.SCM_SITE_ID    ,'')
                                    AND    MD.ENG_SCM_SITE_ID = ISNULL(X.ENG_SCM_SITE_ID,'')
                                    )


                    --##############################################################
                    -- PK 변경없이 데이터 변경 된 경우
                    --##############################################################

                     -- 12442 -> 8761
                     UPDATE SCM_MST_SITE_ENG
                        SET SCM_MST_SITE_ENG.COMPANY_ID            = ISNULL(NEW_VALUE8, OLD_VALUE8)
                          --2025-07-22 아래 ISNULL(NEW_VALUE8, OLD_VALUE8) --> ISNULL(NEW_VALUE9, OLD_VALUE9 로 변경
                          , SCM_MST_SITE_ENG.LOGISTIC_PLANT_ID = ISNULL(NEW_VALUE9, OLD_VALUE9)
                          , SCM_MST_SITE_ENG.PLANT_ID          = ISNULL(NEW_VALUE10, OLD_VALUE10)
                          , SCM_MST_SITE_ENG.SITE_DESCRIPTION  = ISNULL(NEW_COMMENT, OLD_COMMENT)
                           , SCM_MST_SITE_ENG.ATTRIBUTE10 = 'NERP_SCP_UPDATE'
                           , SCM_MST_SITE_ENG.LAST_UPDATED_BY = @CREATED_BY
                           , SCM_MST_SITE_ENG.LAST_UPDATE_DATE = getdate()
                      FROM .SCM_MST_SITE_ENG AS A,
                        (
                                --8761
                                SELECT   OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6, OLD_VALUE7, OLD_VALUE8, OLD_VALUE9, OLD_VALUE10, OLD_COMMENT
                                   , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3, NEW_VALUE4, NEW_VALUE5, NEW_VALUE6, NEW_VALUE7, NEW_VALUE8, NEW_VALUE9, NEW_VALUE10, NEW_COMMENT
                                from NERP_CONV_SCP_DATA
                                where table_name = 'SCM_MST_SITE_ENG'
                                and (  isnull(NEW_VALUE8,'')  != ''
                                    or isnull(NEW_VALUE9,'')  != ''
                                    or isnull(NEW_VALUE10,'')  != ''
                                    or isnull(NEW_COMMENT,'')  != ''
                                    )

                        ) AS B
                        WHERE A.MODELING_ID                 = B.OLD_VALUE1
                          AND A.PLAN_ID                     = B.OLD_VALUE2
                          AND A.PLAN_TYPE                   = B.OLD_VALUE3
                          AND A.PLAN_SEQ                    = B.OLD_VALUE4
                          AND A.DIVISION_ID                 = B.OLD_VALUE5
                          AND A.SCM_SITE_ID                 = B.OLD_VALUE6
                          AND A.ENG_SCM_SITE_ID             = B.OLD_VALUE7

                    /*

                    NERP_SCP_UPDATE 8761
                    NERP_TOBE_DATA  1402
                    ASIS_DATA       3704
                    ---------------------
                                    13867

                    select attribute10 , count(*)
                    from SCM_MST_SITE_ENG
                    group by attribute10
                    */


                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCM_MST_SLOC'
                 BEGIN

                    --SCM_MST_SLOC  DIVISION_ID
                    --SCM_MST_SLOC  STORAGE_ID
                    --SCM_MST_SLOC  PLANT_ID

                    update SCM_MST_SLOC set attribute10 = @CREATED_BY;
                    DELETE from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_SLOC';
                    --------------------------------------------------------------------------------------
                    --DIVISION_ID, STORAGE_ID, PLANT_ID
                    -- 3470 -> 3477
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                        TABLE_NAME
                      , COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3
                      , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3
                      , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3,NEW_VALUE4
                    )
                    SELECT
                           'SCM_MST_SLOC'
                          , 'DIVISION_ID' , 'STORAGE_ID', 'PLANT_ID'
                          ,DIVISION_ID, STORAGE_ID, PLANT_ID
                         , DIVISION_ID
                         , NST1.TOBE_STORAGE
                         , NP1.TOBE_PLANT
                         , rank () over (partition by DIVISION_ID
                                             , ISNULL(NP1.TOBE_PLANT,PLANT_ID)
                                             , ISNULL(NST1.TOBE_STORAGE,STORAGE_ID)
                                             order by PLANT_ID,STORAGE_ID ) AS RNO
                    from SCM_MST_SLOC C with (nolock)
                    LEFT JOIN (SELECT ASIS_PLANT,TOBE_PLANT,DESC01,RNO FROM #TMP_PLANT                 ) NP1  ON NP1.ASIS_PLANT = C.PLANT_ID
                    LEFT JOIN (SELECT ASIS_PLANT,ASIS_STORAGE,TOBE_PLANT,TOBE_STORAGE,DESC01,DESC02,DESC03,ETC1,ETC2 FROM #TMP_STORAGE               ) NST1 ON NST1.ASIS_PLANT = C.PLANT_ID AND NST1.ASIS_STORAGE = C.STORAGE_ID



                    --------------------------------------------------------------------------------------
                    -- ASIS 삭제 버전
                    --------------------------------------------------------------------------------------
                     ---- 3449

                    --------------------------------------------------------------------------------------
                    -- ASIS 남기고 TOBE 추가 버전
                    --------------------------------------------------------------------------------------
                    -- DIVISION_ID, STORAGE_ID, PLANT_ID
                    -- 20 ->1364 -> 1226 (=> rno=1)
                    -- 4703 = 3477 + 1226
                    INSERT INTO SCM_MST_SLOC
                    SELECT *
                    FROM (
                        SELECT
                         DIVISION_ID
                        , case when isnull(New_value2,'') = '' THEN STORAGE_ID ELSE New_value2 END STORAGE_ID
                        , case when isnull(New_value3,'') = '' THEN PLANT_ID ELSE New_value3 END  PLANT_ID
                        ,STORAGE_DESCRIPTION
                        ,LINE_CODE
                        ,OWNER_YN
                        ,VALID_YN
                        ,CREATED_BY,CREATION_DATE
                        --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                        --,@CREATED_BY as CREATED_BY
                        --, GETDATE() AS CREATION_DATE
                        ,@CREATED_BY as LAST_UPDATED_BY
                        , GETDATE() AS LAST_UPDATE_DATE
                        ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                        ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
                        ,'NERP_TOBE_DATA' AS ATTRIBUTE10
                        FROM SCM_MST_SLOC L with (nolock)
                        LEFT JOIN (
                            -- 1364
                            select old_value1,  old_value2,  old_value3
                                 , new_value1,  new_value2,  new_value3
                                 , 'Y' AS MAPPING
                                 ,rANK () over(partition by isnull(New_value1, old_value1),  isnull(New_value2, old_value2), isnull(New_value3, old_value3)
                                                   order by old_value1,  old_value2,  old_value3
                                               ) as rno
                            from NERP_CONV_SCP_DATA
                            where table_name = 'SCM_MST_SLOC'
                            and
                            (
                               isnull(new_value2,'') != '' and isnull(old_value2,'') != isnull(new_value2,'')
                               or
                               isnull(new_value3,'') != '' and isnull(old_value3,'') != isnull(new_value3,'')
                            )
                        ) B
                        ON  L.DIVISION_ID = B.old_value1
                        AND L.PLANT_ID   = B.old_value3
                        AND L.STORAGE_ID = B.old_value2
                        WHERE ISNULL(B.MAPPING,'') = 'Y'
                        and rno = 1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_MST_SLOC MD  WITH (NOLOCK)
                                    WHERE  MD.DIVISION_ID = X.DIVISION_ID
                                    AND    MD.STORAGE_ID  = X.STORAGE_ID
                                    AND    MD.PLANT_ID    = X.PLANT_ID
                                    )

                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241021 - AFFLICATE_CODE : Vendor or Custome와 더 많이 매핑 됨
                ELSE IF @TABLE_NAME = 'SCM_MST_VENDOR'
                 BEGIN

                    --SCM_MST_VENDOR    COMPANY_ID
                    --SCM_MST_VENDOR    VENDOR_CODE

                    -- 197984
                    update SCM_MST_VENDOR set attribute10 = @CREATED_BY;
                    delete from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_VENDOR';

                    --------------------------------------------------------------------------------------
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3
                    , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                    )
                    -- 197984
                    SELECT
                           'SCM_MST_VENDOR'
                           , 'COMPANY_ID', 'VENDOR_CODE' , 'AFFILIATE_CODE'
                          ,COMPANY_ID, VENDOR_CODE , AFFILIATE_CODE
                         , NC1.TOBE_COMPANY
                         , NV1.TOBE_VENDOR
                         , NVC1.TOBE_CD
                    FROM SCM_MST_VENDOR C with (nolock)
                    LEFT JOIN (SELECT ASIS_COMPANY,TOBE_COMPANY,DESC01 FROM #TMP_COMPANY) NC1 ON NC1.ASIS_COMPANY = COMPANY_ID
                    LEFT JOIN (SELECT ASIS_VENDOR,TOBE_VENDOR,DESC01,ETC1,RNO FROM #TMP_VENDOR) NV1 ON NV1.ASIS_VENDOR = VENDOR_CODE
                    LEFT JOIN (SELECT ASIS_CD, TOBE_CD FROM #TMP_VENDOR_PLANT_COMPANY) NVC1 ON NVC1.ASIS_CD = AFFILIATE_CODE




                    -------------------------------------------------------------------------------------
                     -- ALTER TABLE SCM_MST_VENDOR alter column AFFILIATE_CODE NVARCHAR(30)  -- NVARCHAR(10) -> 30
                     -------------------------------------------------------------------------------------


                    --------------------------------------------------------------------------------------
                    -- ASIS 삭제 버전
                    --------------------------------------------------------------------------------------
                     -- 195957
                    --------------------------------------------------------------------------------------
                    -- ASIS 남기고 TOBE 추가 버전
                    --------------------------------------------------------------------------------------

                         SELECT old_value1, old_value2, old_value3
                              , TOBE_COMPANY
                              , TOBE_VENDOR
                              , TOBE_AFFILIATE
                              , rank () over (partition by TOBE_COMPANY, TOBE_VENDOR order by old_value1, old_value2 ) as rno
                        into #tmp_vendor_tobe
                        from
                        (
                            -- 195988
                            -- 112088
                            -- 197984 -> 113026
                            select old_value1, old_value2, old_value3
                                  , ISNULL(new_value1,old_value1)   AS TOBE_COMPANY
                                  , ISNULL(new_value2,old_value2)   AS TOBE_VENDOR
                                  , ISNULL(new_value3,old_value3)   AS TOBE_AFFILIATE
                            from NERP_CONV_SCP_DATA
                            where table_name = 'SCM_MST_VENDOR'
                            and
                            (
                               isnull(new_value1,'') != '' and isnull(old_value1,'') != isnull(new_value1,'')
                               or
                               isnull(new_value2,'') != '' and isnull(old_value2,'') != isnull(new_value2,'')
                               --2차오펀 MI법인이 컨버전 되지 않아서 추가로 보완함
                               or
                               isnull(new_value3,'') != '' and isnull(old_value3,'') != isnull(new_value3,'')
                            )

                        ) list


                        -- 112079 -> 113026
                        --select * from #tmp_vendor_tobe where rno = 1

                        -- 113026
                        INSERT INTO SCM_MST_VENDOR
                        SELECT *
                        FROM (
                            select
                            COMPANY_ID = ISNULL(TOBE_COMPANY, COMPANY_ID)
                            ,VENDOR_CODE = ISNULL(TOBE_VENDOR, VENDOR_CODE)
                            ,VENDOR_NAME
                            ,COUNTRY
                            ,REPRESENTATIVE
                            ,VENDOR_ADDRESS
                            ,ACCOUNT_GROUP_CODE
                            ,ACCOUNT_GROUP_NAME
                            ,AFFILIATE_CODE = ISNULL(TOBE_AFFILIATE, AFFILIATE_CODE)
                            ,PACKER_YN
                            ,VALID_YN
                            ,CREATED_BY,CREATION_DATE
                            --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                            --,@CREATED_BY as CREATED_BY
                            --, GETDATE() AS CREATION_DATE
                            ,@CREATED_BY as LAST_UPDATED_BY
                            , GETDATE() AS LAST_UPDATE_DATE
                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
                            ,'NERP_TOBE_DATA' as ATTRIBUTE10
                            from SCM_MST_VENDOR C with (nolock)
                            left join (select old_value1, old_value2, old_value3, TOBE_COMPANY, TOBE_VENDOR, TOBE_AFFILIATE, rno from #tmp_vendor_tobe) B
                            ON C.COMPANY_ID = B.old_value1
                            and C.VENDOR_CODE = B.old_value2
                            where B.rno = 1
                        ) X
                        WHERE 1=1
                        AND NOT EXISTS (SELECT 1
                                        FROM   SCM_MST_VENDOR MD  WITH (NOLOCK)
                                        WHERE  MD.COMPANY_ID  = X.COMPANY_ID
                                        AND    MD.VENDOR_CODE = X.VENDOR_CODE
                                        )



                    --------------------------------------------------------------------------------------
                    -- ASIS_DATA 증 pk 아닌 AFFILIATE_CODE 변경 된 경우
                    --------------------------------------------------------------------------------------
                        select old_value1, old_value2, old_value3
                             , ISNULL(new_value3,old_value3) AS TOBE_AFFILIATE
                            into #tmp_SCM_MST_VENDOR_AFFILIATE
                            from NERP_CONV_SCP_DATA
                            where table_name = 'SCM_MST_VENDOR'
                            AND isnull(new_value3,'') != '' and isnull(old_value3,'') != isnull(new_value3,'')


                     --23 -> 34
                     /*
                    Customer 과 더 많이 매핑 됨
                    C100
                    G100
                    G500
                     */
                    UPDATE SCM_MST_VENDOR
                        SET SCM_MST_VENDOR.AFFILIATE_CODE  = B.TOBE_AFFILIATE
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                      FROM .SCM_MST_VENDOR AS A,
                        (
                        select old_value1, old_value2, old_value3
                             , TOBE_AFFILIATE
                            from #tmp_SCM_MST_VENDOR_AFFILIATE
                        ) AS B
                        WHERE a.COMPANY_ID = B.old_value1
                          AND a.VENDOR_CODE = B.old_value2
                          AND a.AFFILIATE_CODE = B.old_value3
                          AND A.attribute10 = @CREATED_BY



                    --------------------------------------------------------------------------------------
                    -- ASIS_DATA 중 신규생성된 경우 VALID = N ?
                    --------------------------------------------------------------------------------------




                    SET @MAPPING_RESULT = 'Y';
                    END

                 -- 20241007 : 해당 Table DM에서 처리하도록 변경
                 -- 20241206 : 로직 상 SCM_MST_SITE_CUSTOMER 테이블에 있는 데이터는 SCM_MST_CUSTOMER 에 존재해야합니다. -- ex) US000319
                 -- 20250421 : ZNERP_DEV_ITEM_SCHEDULE테이블에 SCM_MST_SITE_CUSTOMER 컬럼 중복 2개 추가	
                 --            기존 : dev_detail:SCM_SITE_ID,mapping_column:SCM_SITE_ID
                 --            추가 : dev_detail:SCM_SITE_ID,mapping_column:COMPANY_ID
                 --            추가 : dev_detail:SCM_SITE_ID,mapping_column:PLANT_ID
                ELSE IF @TABLE_NAME = 'SCM_MST_SITE_CUSTOMER'
                --테이블에 키값은 없는데 key를 아래로 하는게 맞음
                --DIVISION_ID
                --SCM_SITE_ID
                --SOLDTO_CODE
                --SHIPTO_CODE

                 BEGIN

                --2025-05-22 김준규(김춘동 책임님 의견 합당함)
                --기존 SOLDTO_CODE,SHIPTO_CODE 신규 코드 입력 후, old code rep_yn을 n처리 이후 SCM_SITE_ID 도 동일한 방법으로 처리
                --변경 SCM_SITE_ID 를 OLD TO NEW로 그냥 변경함.

                     UPDATE MSC
                     SET    MSC.SCM_SITE_ID = MCV.NEW_VALUE1
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                     --SELECT SCM_SITE_ID=MCV.NEW_VALUE1,mcv.CODETYPE , MSC.SCM_SITE_ID,*
                     FROM   SCM_MST_SITE_CUSTOMER AS MSC WITH(NOLOCK)
                     LEFT JOIN NERP_CONV_MASTER_CFM_V AS mcv WITH(NOLOCK)
                     ON     mcv.CODETYPE IN ('SCP_SITE_ID','PLANT_ID')
                     AND    mcv.OLD_VALUE1 = MSC.SCM_SITE_ID
                     WHERE  mcv.OLD_VALUE1 IS NOT NULL
                     AND    mcv.ATTRIBUTE5 = @P_ROLLIN;


        --        --테이블에 키값은 없는데 key를 아래로 하는게 맞음
        --        --DIVISION_ID
        --        --SCM_SITE_ID
        --        --SOLDTO_CODE
        --        --SHIPTO_CODE

        --         BEGIN
        --            -- 20240816 : SOLDTO_CODE / SHIPTO_CODE 에 END_CUSTOMER_ID 가 맞는데 VENDOR_ID 입력된 경우가 있다는 문의
        --            -- 20250407 : SCM_MST_SITE_CUSTOMER, SCM_SITE_ID,SOLDTO,SHIPTO 기준 변경적용이후 SCM_SITE_ID 만 UPDATE시 중복에러 발생 수정
        --             --           SCM_SITE_ID 만 UPDATE도 중복제거 로직 추가. 
        --            --------------------------------------------------------------------------------------
        --            --######################################################
        --            --첫번째 처리 : attribute10 = @CREATED_BY+'_CUST' 함.
        --            --######################################################
        --            delete from NERP_CONV_SCP_DATA 
        --            where table_name = 'SCM_MST_SITE_CUSTOMER';
        --            update SCM_MST_SITE_CUSTOMER set attribute10 = @CREATED_BY+'_CUST';


        --            --3137 3179 / 3212
        --            INSERT INTO NERP_CONV_SCP_DATA
        --            (
        --              TABLE_NAME
        --              ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
        --            , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3,OLD_VALUE4,OLD_VALUE5
        --            , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3,NEW_VALUE4,NEW_VALUE5,NEW_VALUE6
        --            )

        --            SELECT   'SCM_MST_SITE_CUSTOMER'
        --                   , 'DIVISION_ID', 'SCM_SITE_ID' , 'SOLDTO_CODE' , 'SHIPTO_CODE' , 'REP_YN', 'RNO'

        --                , DIVISION_ID, SCM_SITE_ID , SOLDTO_CODE, SHIPTO_CODE, REP_YN
        --                , DIVISION_ID
        --                , CASE WHEN ISNULL(NS1.TOBE_CD,'') != ''
        --                       THEN REPLACE(SCM_SITE_ID, SCM_SITE_ID_BODY, NS1.TOBE_CD)
        --                       ELSE NULL
        --                       END
        --                 ,NP1.TOBE_CD AS TOBE_SOLDTO
        --                 ,NP2.TOBE_CD AS TOBE_SHIPTO
        --                 ,REP_YN
        --                 ,NULL
        --            FROM
        --            (
        --                    -- 3133 / 3212
        --                    SELECT
        --                           DIVISION_ID, SCM_SITE_ID , SOLDTO_CODE, SHIPTO_CODE,rep_yn
        --                          ,CASE WHEN charindex( '-', SCM_SITE_ID) > 0 AND charindex( '_', SCM_SITE_ID) > 0
        --                                 THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'-'),0,'_')
        --                                 WHEN charindex( '-', SCM_SITE_ID) > 0
        --                                 THEN dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'-')
        --                                 WHEN charindex( '_', SCM_SITE_ID) > 0
        --                                 THEN dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'_')
        --                                 ELSE SCM_SITE_ID
        --                                 END SCM_SITE_ID_BODY
        --                    FROM SCM_MST_SITE_CUSTOMER C with (nolock)
        --            ) list
        --            LEFT JOIN (select ASIS_CD, TOBE_CD FROM #TMP_CUSTOMER_PLANT_COMPANY ) NS1 ON NS1.ASIS_CD = SCM_SITE_ID_BODY
        --            LEFT JOIN (SELECT ASIS_CD, TOBE_CD FROM #TMP_CUSTOMER_PLANT_COMPANY ) NP1 ON NP1.ASIS_CD = SOLDTO_CODE
        --            LEFT JOIN (SELECT ASIS_CD, TOBE_CD FROM #TMP_CUSTOMER_PLANT_COMPANY ) NP2 ON NP2.ASIS_CD = SHIPTO_CODE




        --            --------------------------------------------------------------------------------------
        --            -- ASIS 삭제 버전
        --            --------------------------------------------------------------------------------------
        --             -- 3136


        --            --------------------------------------------------------------------------------------
        --            -- #TMP_SCM_MST_SITE_CUSTOMER_INSERT
        --            --------------------------------------------------------------------------------------
        --IF OBJECT_ID('tempdb..#TMP_SCM_MST_SITE_CUSTOMER_INSERT') IS NOT NULL
        --BEGIN
        --DROP TABLE  #TMP_SCM_MST_SITE_CUSTOMER_INSERT
        --END

        --                       --3139 2535 2522 5050 2537 / 2812
        --                       SELECT OLD_VALUE1,OLD_VALUE2,OLD_VALUE3,OLD_VALUE4
        --                            , ISNULL(NEW_VALUE2,  OLD_VALUE2) AS NEW_VALUE2
        --                            , ISNULL(NEW_VALUE3,  OLD_VALUE3) AS NEW_VALUE3
        --                            , ISNULL(NEW_VALUE4,  OLD_VALUE4) AS NEW_VALUE4
        --                            ,OLD_VALUE5
        --                            , 'Y' AS MAPPING
        --                            --2025-04-07 김준규 RANK를 ROW_NUMBER로 변경
        --                            , ROW_NUMBER() /*rank ()*/ over (partition by NEW_VALUE1
        --                                                       , ISNULL(NEW_VALUE2,  OLD_VALUE2)
        --                                                       , ISNULL(NEW_VALUE3,  OLD_VALUE3)
        --                                                       , ISNULL(NEW_VALUE4,  OLD_VALUE4)
        --                                                       order by OLD_VALUE1,OLD_VALUE2,OLD_VALUE3,OLD_VALUE4) AS rno
        --                         INTO #TMP_SCM_MST_SITE_CUSTOMER_INSERT
        --                         FROM NERP_CONV_SCP_DATA
        --                        where table_name = 'SCM_MST_SITE_CUSTOMER'
        --                         and ( ISNULL(NEW_VALUE2,'') !=''  or  ISNULL(NEW_VALUE3,'') !='' or  ISNULL(NEW_VALUE4,'') !='')



        --            --------------------------------------------------------------------------------------
        --            -- 신규코드
        --            --------------------------------------------------------------------------------------
        --            -- 2537 / 2812
        --            INSERT INTO SCM_MST_SITE_CUSTOMER
        --            SELECT *
        --            FROM (
        --                SELECT
        --                     DIVISION_ID
        --                    ,SCM_SITE_ID = ISNULL(NEW_VALUE2,  SCM_SITE_ID)
        --                    ,SOLDTO_CODE = ISNULL(NEW_VALUE3,  SOLDTO_CODE)
        --                    ,SHIPTO_CODE = ISNULL(NEW_VALUE4,  SHIPTO_CODE)
        --                    ,REP_YN
        --                    ,VALID_YN
        --                    --,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
        --                    ,@CREATED_BY as CREATED_BY
        --                    , GETDATE() AS CREATION_DATE
        --                    ,@CREATED_BY as LAST_UPDATED_BY
        --                    , GETDATE() AS LAST_UPDATE_DATE
        --                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
        --                    ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
        --                    ,'NERP_TOBE_DATA'+'_'+@P_ROLLIN AS ATTRIBUTE10
        --                FROM SCM_MST_SITE_CUSTOMER C with (nolock)
        --                LEFT JOIN (SELECT * FROM #TMP_SCM_MST_SITE_CUSTOMER_INSERT WHERE MAPPING = 'Y' AND rno = 1) NM
        --                        ON C.DIVISION_ID = NM.OLD_VALUE1
        --                       AND C.SCM_SITE_ID = NM.OLD_VALUE2
        --                       AND C.SOLDTO_CODE = NM.OLD_VALUE3
        --                       AND C.SHIPTO_CODE = NM.OLD_VALUE4
        --                WHERE NM.MAPPING = 'Y'
        --                and NM.rno = 1
        --            ) X
        --            WHERE 1=1
        --            AND NOT EXISTS (SELECT 1
        --                            FROM   SCM_MST_SITE_CUSTOMER MD  WITH (NOLOCK)
        --                            WHERE  MD.DIVISION_ID = X.DIVISION_ID--KEY DIVISION_ID, SCM_SITE_ID, SOLDTO_CODE, SHIPTO_CODE
        --                            AND    MD.SCM_SITE_ID = X.SCM_SITE_ID
        --                            AND    MD.SOLDTO_CODE = X.SOLDTO_CODE
        --                            AND    MD.SHIPTO_CODE = X.SHIPTO_CODE
        --                            )


        --            --------------------------------------------------------------------------------------
        --            -- 신규코드 생성된 ASIS 의 REP_YN   = 'N'
        --            --------------------------------------------------------------------------------------
        --            --2025-03-10 막음 아래는 점검용 테이터?
        --            --select distinct OLD_VALUE2, new_value2
        --            --from NERP_CONV_SCP_DATA
        --            --where TABLE_NAME = 'SCM_MST_SITE_CUSTOMER'
        --            --and new_value2 is not null
        --            --order by OLD_VALUE2


        --            --------------------------------------------------------------------------------------
        --            -- 신규코드 생성된 ASIS 의 REP_YN   = 'N'
        --            --------------------------------------------------------------------------------------
        --            -- 1507 / 1662

        --             UPDATE SCM_MST_SITE_CUSTOMER
        --                SET SCM_MST_SITE_CUSTOMER.REP_YN   = 'N'
        --                   ,LAST_UPDATED_BY = @CREATED_BY
        --                   ,LAST_UPDATE_DATE = GETDATE()
        --               FROM SCM_MST_SITE_CUSTOMER AS A,
        --                    ( SELECT *
        --                        FROM #TMP_SCM_MST_SITE_CUSTOMER_INSERT
        --                        WHERE MAPPING = 'Y'
        --                        AND rno = 1
        --                        and old_value5 = 'Y'
        --                    ) AS B
        --                WHERE  A.DIVISION_ID = B.OLD_VALUE1
        --                   AND A.SCM_SITE_ID = B.OLD_VALUE2
        --                   AND A.SOLDTO_CODE = B.OLD_VALUE3
        --                   AND A.SHIPTO_CODE = B.OLD_VALUE4
        --                   AND A.ATTRIBUTE10 = @CREATED_BY+'_CUST'


        --            --------------------------------------------------------------------------------------
        --            -- STHQ05
        --            /*
        --              select *
        --             from SCM_MST_SITE_CUSTOMER
        --             where CREATED_BY = 'B Project C100'
        --             and attribute10 = 'NERP_TOBE_DATA'
        --            */
        --            --------------------------------------------------------------------------------------
        --            update SCM_MST_SITE_CUSTOMER
        --            set soldto_code = 'STHQ05'
        --            where soldto_code = 'HQ00' and CREATED_BY = 'B Project C100'

        --            update SCM_MST_SITE_CUSTOMER
        --            set SHIPTO_code = 'STHQ05'
        --            where SHIPTO_code = 'HQ00' and CREATED_BY = 'B Project C100'



        --            --------------------------------------------------------------------------------------
        --            -- 20250102 SCM_SITE_ID 경우 구코드 사용 안함 -> 전부 신코드로 사용 할 것
        --            --------------------------------------------------------------------------------------
        --            -- 20250407 : SCM_MST_SITE_CUSTOMER, SCM_SITE_ID,SOLDTO,SHIPTO 기준 변경적용이후 SCM_SITE_ID 만 UPDATE시 중복에러 발생 수정
        --            --           SCM_SITE_ID 만 UPDATE도 중복제거 로직 추가. 
        --            -- 20250407 아래 막음
        --            --UPDATE SCM_MST_SITE_customer
        --            --   SET SCM_MST_SITE_customer.SCM_SITE_ID   = B.NEW_VALUE1
        --            --      ,LAST_UPDATED_BY = @CREATED_BY
        --            --      ,LAST_UPDATE_DATE = GETDATE()
        --            --  FROM .SCM_MST_SITE_customer AS A,
        --            --  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN
        --            --  ) AS B
        --            --WHERE   A.SCM_SITE_ID                   = B.OLD_VALUE1



        --            --SET @MAPPING_RESULT = 'Y';
        --            --END


        --            --#######################
        --            --두번째 처리 : attribute10 = @CREATED_BY+'_CUST' 함.
        --            --#######################
        --            delete from NERP_CONV_SCP_DATA 
        --            where table_name = 'SCM_MST_SITE_CUSTOMER';
        --            update SCM_MST_SITE_CUSTOMER set attribute10 = @CREATED_BY+'_SITE';


        --            --3137 3179 / 3212
        --            INSERT INTO NERP_CONV_SCP_DATA
        --            (
        --              TABLE_NAME
        --              ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
        --            , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3,OLD_VALUE4,OLD_VALUE5
        --            , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3,NEW_VALUE4,NEW_VALUE5,NEW_VALUE6
        --            )

        --            SELECT   'SCM_MST_SITE_CUSTOMER'
        --                   , 'DIVISION_ID', 'SCM_SITE_ID' , 'SOLDTO_CODE' , 'SHIPTO_CODE' , 'REP_YN', 'RNO'

        --                , DIVISION_ID, SCM_SITE_ID , SOLDTO_CODE, SHIPTO_CODE, REP_YN
        --                , DIVISION_ID
        --                , CASE WHEN ISNULL(NS1.TOBE_CD,'') != ''
        --                       THEN NS1.TOBE_CD
        --                       ELSE NULL
        --                       END    AS TOBE_SCM_SITE_ID
        --                 ,NP1.TOBE_CD AS TOBE_SOLDTO
        --                 ,NP2.TOBE_CD AS TOBE_SHIPTO
        --                 ,REP_YN
        --                 ,NULL
        --            FROM
        --            (
        --                    -- 3133 / 3212
        --                    SELECT
        --                           DIVISION_ID, SCM_SITE_ID , SOLDTO_CODE, SHIPTO_CODE,rep_yn
        --                          ,SCM_SITE_ID AS SCM_SITE_ID_BODY
        --                    FROM SCM_MST_SITE_CUSTOMER C with (nolock)
        --            ) list
        --            LEFT JOIN (SELECT OLD_VALUE1 ASIS_CD, NEW_VALUE1 TOBE_CD 
        --                       FROM   NERP_CONV_MASTER_CFM_V  with (nolock) 
        --                       WHERE  CODETYPE = 'SCP_SITE_ID' 
        --                       and ATTRIBUTE5 = @P_ROLLIN )                               NS1 ON NS1.ASIS_CD = SCM_SITE_ID_BODY
        --            LEFT JOIN (SELECT ASIS_CD, TOBE_CD FROM #TMP_CUSTOMER_PLANT_COMPANY ) NP1 ON NP1.ASIS_CD = SOLDTO_CODE
        --            LEFT JOIN (SELECT ASIS_CD, TOBE_CD FROM #TMP_CUSTOMER_PLANT_COMPANY ) NP2 ON NP2.ASIS_CD = SHIPTO_CODE




        --            --------------------------------------------------------------------------------------
        --            -- ASIS 삭제 버전
        --            --------------------------------------------------------------------------------------
        --             -- 3136


        --            --------------------------------------------------------------------------------------
        --            -- #TMP_SCM_MST_SITE_CUST_SITE_INSERT
        --            --------------------------------------------------------------------------------------
        --IF OBJECT_ID('tempdb..#TMP_SCM_MST_SITE_CUST_SITE_INSERT') IS NOT NULL
        --BEGIN
        --DROP TABLE  #TMP_SCM_MST_SITE_CUST_SITE_INSERT
        --END

        --                       --3139 2535 2522 5050 2537 / 2812
        --                       SELECT OLD_VALUE1,OLD_VALUE2,OLD_VALUE3,OLD_VALUE4
        --                            , ISNULL(NEW_VALUE2,  OLD_VALUE2) AS NEW_VALUE2
        --                            , ISNULL(NEW_VALUE3,  OLD_VALUE3) AS NEW_VALUE3
        --                            , ISNULL(NEW_VALUE4,  OLD_VALUE4) AS NEW_VALUE4
        --                            ,OLD_VALUE5
        --                            , 'Y' AS MAPPING
        --                            --2025-04-07 김준규 RANK를 ROW_NUMBER로 변경
        --                            , ROW_NUMBER() /*rank ()*/ over (partition by NEW_VALUE1
        --                                                       , ISNULL(NEW_VALUE2,  OLD_VALUE2)
        --                                                       , ISNULL(NEW_VALUE3,  OLD_VALUE3)
        --                                                       , ISNULL(NEW_VALUE4,  OLD_VALUE4)
        --                                                       order by OLD_VALUE1,OLD_VALUE2,OLD_VALUE3,OLD_VALUE4) AS rno
        --                         INTO #TMP_SCM_MST_SITE_CUST_SITE_INSERT
        --                         FROM NERP_CONV_SCP_DATA
        --                        where table_name = 'SCM_MST_SITE_CUSTOMER'
        --                         and ( ISNULL(NEW_VALUE2,'') !=''  or  ISNULL(NEW_VALUE3,'') !='' or  ISNULL(NEW_VALUE4,'') !='')



        --            --------------------------------------------------------------------------------------
        --            -- 신규코드
        --            --------------------------------------------------------------------------------------
        --            -- 2537 / 2812
        --            INSERT INTO SCM_MST_SITE_CUSTOMER
        --            SELECT *
        --            FROM (
        --                SELECT
        --                     DIVISION_ID
        --                    ,SCM_SITE_ID = ISNULL(NEW_VALUE2,  SCM_SITE_ID)
        --                    ,SOLDTO_CODE = ISNULL(NEW_VALUE3,  SOLDTO_CODE)
        --                    ,SHIPTO_CODE = ISNULL(NEW_VALUE4,  SHIPTO_CODE)
        --                    ,REP_YN
        --                    ,VALID_YN
        --                    --,CREATED_BY,CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
        --                    ,@CREATED_BY as CREATED_BY
        --                    , GETDATE() AS CREATION_DATE
        --                    ,@CREATED_BY as LAST_UPDATED_BY
        --                    , GETDATE() AS LAST_UPDATE_DATE
        --                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
        --                    ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9
        --                    ,'NERP_TOBE_DATA'+'_'+@P_ROLLIN AS ATTRIBUTE10
        --                FROM SCM_MST_SITE_CUSTOMER C with (nolock)
        --                LEFT JOIN (SELECT * FROM #TMP_SCM_MST_SITE_CUST_SITE_INSERT WHERE MAPPING = 'Y' AND rno = 1) NM
        --                        ON C.DIVISION_ID = NM.OLD_VALUE1
        --                       AND C.SCM_SITE_ID = NM.OLD_VALUE2
        --                       AND C.SOLDTO_CODE = NM.OLD_VALUE3
        --                       AND C.SHIPTO_CODE = NM.OLD_VALUE4
        --                WHERE NM.MAPPING = 'Y'
        --                and NM.rno = 1
        --            ) X
        --            WHERE 1=1
        --            AND NOT EXISTS (SELECT 1
        --                            FROM   SCM_MST_SITE_CUSTOMER MD  WITH (NOLOCK)
        --                            WHERE  MD.DIVISION_ID = X.DIVISION_ID--KEY DIVISION_ID, SCM_SITE_ID, SOLDTO_CODE, SHIPTO_CODE
        --                            AND    MD.SCM_SITE_ID = X.SCM_SITE_ID
        --                            AND    MD.SOLDTO_CODE = X.SOLDTO_CODE
        --                            AND    MD.SHIPTO_CODE = X.SHIPTO_CODE
        --                            )


        --            --------------------------------------------------------------------------------------
        --            -- 신규코드 생성된 ASIS 의 REP_YN   = 'N'
        --            --------------------------------------------------------------------------------------
        --            --2025-03-10 막음 아래는 점검용 테이터?
        --            --select distinct OLD_VALUE2, new_value2
        --            --from NERP_CONV_SCP_DATA
        --            --where TABLE_NAME = 'SCM_MST_SITE_CUSTOMER'
        --            --and new_value2 is not null
        --            --order by OLD_VALUE2


        --            --------------------------------------------------------------------------------------
        --            -- 신규코드 생성된 ASIS 의 REP_YN   = 'N'
        --            --------------------------------------------------------------------------------------
        --            -- 1507 / 1662

        --             UPDATE SCM_MST_SITE_CUSTOMER
        --                SET SCM_MST_SITE_CUSTOMER.REP_YN   = 'N'
        --                   ,LAST_UPDATED_BY = @CREATED_BY
        --                   ,LAST_UPDATE_DATE = GETDATE()
        --               FROM SCM_MST_SITE_CUSTOMER AS A,
        --                    ( SELECT *
        --                        FROM #TMP_SCM_MST_SITE_CUST_SITE_INSERT
        --                        WHERE MAPPING = 'Y'
        --                        AND rno = 1
        --                        and old_value5 = 'Y'
        --                    ) AS B
        --                WHERE  A.DIVISION_ID = B.OLD_VALUE1
        --                   AND A.SCM_SITE_ID = B.OLD_VALUE2
        --                   AND A.SOLDTO_CODE = B.OLD_VALUE3
        --                   AND A.SHIPTO_CODE = B.OLD_VALUE4
        --                   AND A.ATTRIBUTE10 = @CREATED_BY+'_SITE'


        --            --------------------------------------------------------------------------------------
        --            -- STHQ05
        --            /*
        --              select *
        --             from SCM_MST_SITE_CUSTOMER
        --             where CREATED_BY = 'B Project C100'
        --             and attribute10 = 'NERP_TOBE_DATA'
        --            */
        --            --------------------------------------------------------------------------------------
        --            update SCM_MST_SITE_CUSTOMER
        --            set soldto_code = 'STHQ05'
        --            where soldto_code = 'HQ00' and CREATED_BY = 'B Project C100'

        --            update SCM_MST_SITE_CUSTOMER
        --            set SHIPTO_code = 'STHQ05'
        --            where SHIPTO_code = 'HQ00' and CREATED_BY = 'B Project C100'



        --            --------------------------------------------------------------------------------------
        --            -- 20250102 SCM_SITE_ID 경우 구코드 사용 안함 -> 전부 신코드로 사용 할 것
        --            --------------------------------------------------------------------------------------
        --            -- 20250407 : SCM_MST_SITE_CUSTOMER, SCM_SITE_ID,SOLDTO,SHIPTO 기준 변경적용이후 SCM_SITE_ID 만 UPDATE시 중복에러 발생 수정
        --            --           SCM_SITE_ID 만 UPDATE도 중복제거 로직 추가. 
        --            -- 20250407 아래 막음
        --            --UPDATE SCM_MST_SITE_customer
        --            --   SET SCM_MST_SITE_customer.SCM_SITE_ID   = B.NEW_VALUE1
        --            --      ,LAST_UPDATED_BY = @CREATED_BY
        --            --      ,LAST_UPDATE_DATE = GETDATE()
        --            --  FROM .SCM_MST_SITE_customer AS A,
        --            --  (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V  with (nolock) WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN
        --            --  ) AS B
        --            --WHERE   A.SCM_SITE_ID                   = B.OLD_VALUE1



                    SET @MAPPING_RESULT = 'Y';
                    END



                ELSE IF @TABLE_NAME = 'SCP_MST_BOD'
                 BEGIN

                    --SCP_MST_BOD   BOD_ID

                    --##################################################################################
                    /*
                    -- ASIS 남기고 TOBE 추가 버전
                    -- 업데이트 하는 방식으로 변경 필요
                    -- BOD_ID로 조인하므로
                    -- 20240813 이슈 = Insert 시 BOD_ID 에 10만씩 더해서 입력
                                  => BOD ID가 변경되어 조인시 문제가 됨
                                  => BOD_ID 유지 해서 UPDATE
                    -- 20241224 변경전 중복 시 Max BOD_ID 를 Y
                    -- 20241224 변경후 중복 시 기존의 BOD_ID를 Y로 유지
                    --------------------------------------------------------------------------------------
                    -- 12371 / 13156 중 없데이트 8596
                    --select * from SCP_MST_BOD where ATTRIBUTE10 = 'NERP_SCP_UPDATE'
                    */
                    --###################################################################################

                    -- 13156
                    -- 13660
                    -- update SCP_MST_BOD set attribute10 = @CREATED_BY; -- 20250929 YMH ATTRIBUTE10 BOD인코텀즈에서 활용.
					

                    DELETE from NERP_CONV_SCP_DATA 
                    where table_name = 'SCP_MST_BOD';
                    --------------------------------------------------------------------------------------
                    -- 12371
                    -- 12384
                    -- 13156
                    -- 13660
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6,COLUMN_NAME7,COLUMN_NAME8,COLUMN_NAME9
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6, OLD_VALUE7, OLD_VALUE8, OLD_VALUE9
                    , NEW_VALUE1,NEW_VALUE2, NEW_VALUE3
                    , NEW_VALUE10
                    )
                    SELECT
                             'SCP_MST_BOD'
                           , 'BOD_ID', 'FROM_SITE' , 'TO_SITE' , 'INCOTERMS', 'ATTRIBUTE1', 'COUNTRY', 'division_id', 'ROUTE_ID',  'valid_yn'
                           , BOD_ID, FROM_SITE , TO_SITE, INCOTERMS, ATTRIBUTE1, COUNTRY, division_id,ROUTE_ID,valid_yn
                           , TOBE_BOD_ID, TOBE_FROM_SITE, TOBE_TO_SITE
                           , CASE WHEN ISNULL(TOBE_FROM_SITE, '') != ''THEN 'Y'
                                  WHEN ISNULL(TOBE_TO_SITE, '') != ''THEN 'Y'
                                  ELSE 'N'
                                  END AS CHANGE_YN
                    FROM
                    (
                        SELECT
                              BOD_ID, FROM_SITE , TO_SITE, INCOTERMS, ATTRIBUTE1
                            , division_id,ROUTE_ID,valid_yn
                            ,B.COUNTRY AS COUNTRY
                            , BOD_ID as TOBE_BOD_ID
                            , NS1.NEW_VALUE1 AS TOBE_FROM_SITE
                            ,NS2.NEW_VALUE1 AS TOBE_TO_SITE



                        FROM SCP_MST_BOD C with (nolock)
                        LEFT JOIN ( select scm_site_id, country from SCM_MST_SITE ) B ON C.FROM_SITE = B.scm_site_id
                        LEFT JOIN ( SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                     FROM NERP_CONV_MASTER_CFM_V
                                    WHERE codetype = 'SCP_SITE_ID'
                                      and NEW_VALUE1 IS NOT NULL
                                      and ATTRIBUTE5 = @P_ROLLIN

                        ) NS1  ON NS1.OLD_VALUE1 = C.FROM_SITE
                        LEFT JOIN ( SELECT OLD_VALUE1, OLD_VALUE2 AS OLD_VALUE_BODY, NEW_VALUE1
                                     FROM NERP_CONV_MASTER_CFM_V
                                    WHERE codetype = 'SCP_SITE_ID'
                                      and NEW_VALUE1 IS NOT NULL
                                      and ATTRIBUTE5 = @P_ROLLIN
                        ) NS2  ON NS2.OLD_VALUE1 = C.TO_SITE
                    ) LIST


                    --##################################################################################
                    -- 이슈 없는 경우 우선 업데이트
                    -- 1, VALID = N
                    -- 2, INCOTERMS 변경없음 + plant 중복 없음
                    --###################################################################################

                     UPDATE SCP_MST_BOD
                        SET SCP_MST_BOD.FROM_SITE  = ISNULL(NEW_VALUE2,FROM_SITE)
                          , SCP_MST_BOD.TO_SITE    = ISNULL(NEW_VALUE3,TO_SITE)
                          , SCP_MST_BOD.ATTRIBUTE8 = 'NERP VALID = N'  -- 변경전 정보 보관 필요
                          , SCP_MST_BOD.ATTRIBUTE9 = INCOTERMS  -- 변경전 정보 보관 필요
                          --, SCP_MST_BOD.ATTRIBUTE10 = 'NERP_SCP_UPDATE' -- 20250929 YMH 주석처리 BOD인코텀즈에서 활용
                          , SCP_MST_BOD.LAST_UPDATED_BY = @CREATED_BY
                          , SCP_MST_BOD.LAST_UPDATE_DATE = GETDATE()
                         FROM .SCP_MST_BOD AS A,
                        (
                            -- 206
                            SELECT *
                            FROM NERP_CONV_SCP_DATA
                            WHERE TABLE_NAME = 'SCP_MST_BOD'
                            AND NEW_VALUE10 = 'Y'            -- CHANGE_YN
                            AND ISNULL(OLD_VALUE9,'')  = 'N' -- valid_yn

                        ) AS B
                        WHERE A.BOD_ID                  = B.OLD_VALUE1


                    --##################################################################################
                    -- 이슈 없는 경우 우선 업데이트
                    -- 2, INCOTERMS 변경없음 + plant 중복 없음
                    --###################################################################################
                        /*
                        UPDATE SCP_MST_BOD
                        SET SCP_MST_BOD.FROM_SITE  = ISNULL(NEW_VALUE2,FROM_SITE)
                          , SCP_MST_BOD.TO_SITE        = ISNULL(NEW_VALUE3,TO_SITE)
                         , SCP_MST_BOD.INCOTERMS   = ISNULL(NEW_VALUE4,INCOTERMS)
                          , SCP_MST_BOD.ATTRIBUTE1 = ISNULL(NEW_VALUE5,ATTRIBUTE1)
                          , SCP_MST_BOD.ATTRIBUTE8 = 'NERP NO CHANGE INCOTERMS + NO PLANT DUP'  -- 변경전 정보 보관 필요
                          , SCP_MST_BOD.ATTRIBUTE9 = INCOTERMS  -- 변경전 정보 보관 필요
                          , SCP_MST_BOD.ATTRIBUTE10 = 'NERP_SCP_UPDATE'
                         FROM .SCP_MST_BOD AS A,
                        (
                            -- 4437
                            -- 4257
                            SELECT *
                            FROM NERP_CONV_SCP_DATA
                            WHERE TABLE_NAME = 'SCP_MST_BOD'
                            AND NEW_VALUE10 = 'Y'       -- CHANGE_YN
                            and OLD_VALUE9 = 'Y'        -- valid_yn
                            AND ISNULL(NEW_VALUE4,'')  = ''
                            and OLD_VALUE2 NOT like 'A010%'
                            and OLD_VALUE2 NOT like 'A011%'
                            and OLD_VALUE2 NOT like 'A040%'
                            and OLD_VALUE2 NOT like 'A041%'
                            and OLD_VALUE2 NOT like 'F030%'
                            and OLD_VALUE2 NOT like 'F031%'
                            and OLD_VALUE2 NOT like 'G481%'
                            and OLD_VALUE2 NOT like 'G482%'

                        ) AS B
                        WHERE A.BOD_ID                  = B.OLD_VALUE1
                        */


                    --##################################################################################
                    -- 이슈 있는 경우
                    -- INCOTERMS 변경 있지만 Valid = Y
                    -- 기존에 있다면 valid=N 으로 처리해 업데이트 할 것
                    --###################################################################################
                        DECLARE @BOD_CNT INT = 0;
                        DECLARE @BOD_ID nvarchar(100);
                        DECLARE @division_id nvarchar(100);
                        DECLARE @to_site nvarchar(100);
                        DECLARE @from_site nvarchar(100);
                        DECLARE @incoterms nvarchar(100);
                        DECLARE @ATTRIBUTE1 nvarchar(100);
                        DECLARE @valid_yn nvarchar(100);
                        DECLARE @transport_mode nvarchar(100);

                        DECLARE @ROUTE_ID int;

                        DECLARE @TOBE_VALID nvarchar(100);
                        DECLARE @COMMENT    nvarchar(100);
                        -- 커서가 이미 열려 있는지 확인
                        IF CURSOR_STATUS('global', 'CURSOR_BOD') >= 0
                        BEGIN
                            CLOSE CURSOR_BOD;
                            DEALLOCATE CURSOR_BOD;
                        END
                        DECLARE CURSOR_BOD CURSOR FOR

                        --8700
                        -- division_id, from_site, to_site, incoterms, b.valid_yn, ROUTE_ID
                        SELECT  OLD_VALUE1 AS BOD_ID
                              , OLD_VALUE7 AS DIVISION_ID
                              , ISNULL( NEW_VALUE2, OLD_VALUE2) AS from_site
                               ,ISNULL( NEW_VALUE3, OLD_VALUE3) AS to_site
                              , OLD_VALUE8 as ROUTE_ID
                              , OLD_VALUE9 as valid_yn
                              , r.transport_mode as transport_mode

                        FROM NERP_CONV_SCP_DATA  a
                    leFt join SCP_MST_BOD b with (nolock) ON a.OLD_VALUE1 = B.BOD_ID
                    leFt join scp_mst_distribution_route r with (nolock) on b.ROUTE_ID = r.ROUTE_ID
                        WHERE TABLE_NAME = 'SCP_MST_BOD'
                        AND OLD_VALUE9 = 'Y'
                        AND NEW_VALUE10 = 'Y'
                        ORDER BY OLD_VALUE7
                              ,ISNULL( NEW_VALUE2, OLD_VALUE2)
                              ,ISNULL( NEW_VALUE3, OLD_VALUE3)
                              ,OLD_VALUE8
                              ,b.PRIORITY



                        OPEN CURSOR_BOD;
                        FETCH NEXT FROM CURSOR_BOD
                        INTO @BOD_ID,@division_id, @from_site,@to_site,@ROUTE_ID, @valid_yn,@transport_mode
                        WHILE @@FETCH_STATUS = 0
                        BEGIN
                            SET @BOD_CNT = @BOD_CNT  +1
                            print concat(@BOD_CNT, ' = ', @BOD_ID, ',' , @division_id, ',' , @from_site, ',' , @to_site, ',' , @incoterms, ',' , @valid_yn, ',' , @ROUTE_ID, ',' , @valid_yn, ',',@transport_mode)



                            if(@valid_yn != 'Y')
                            begin
                                PRINT 'NO ISSUE'
                                SET @TOBE_VALID = 'N'
                                SET @COMMENT     = N'valid_yn = N'
                            END
                            else if exists (


                                --select division_id,from_site, to_site,incoterms, b.valid_yn, r.transport_mode
                                --from SCP_MST_BOD b with (nolock)
                                --inner join scp_mst_distribution_route r with (nolock) on b.ROUTE_ID = r.ROUTE_ID
                                --where b.valid_yn = 'Y'
                                --and  division_id = @division_id
                                --and from_site =  @from_site
                                --and to_site =  @to_site
                                --and incoterms =@incoterms
                                --and transport_mode = @transport_mode
                                --group by division_id,from_site, to_site,incoterms, b.valid_yn, r.transport_mode

                                select TOP 1 *
                                from SCP_MST_BOD_n_v with(nolock)
                                where @division_id + ':'+ @from_site + ':'+ @to_site + ':'+ @incoterms + ':'+ @transport_mode
                                 in (

                                    select division_id + ':'+ from_site + ':'+ to_site + ':'+ incoterms + ':'+ transport_mode
                                    from SCP_MST_BOD_n_v with(nolock)
                                    where bod_valid_yn = 'Y'
                                    group by division_id, from_site, to_site, incoterms, transport_mode
                                    having count(*) > 1
                                )


                                )
                                begin
                                PRINT 'ISSUE'
                                SET @TOBE_VALID = 'N'
                                SET @COMMENT     = N'INCOTERMS 중복 Valid = N 처리'
                                end

                            else
                                begin
                                PRINT 'ISSUE OK'
                                SET @TOBE_VALID = 'Y'
                                SET @COMMENT     = N'INCOTERMS 이슈 없음'
                                end



                         UPDATE SCP_MST_BOD
                            SET FROM_SITE   = ISNULL(@from_site,FROM_SITE)
                              , TO_SITE     = ISNULL(@to_site,TO_SITE)
                              , INCOTERMS   = ISNULL(@incoterms,INCOTERMS)
                              , ATTRIBUTE1  = ISNULL(@ATTRIBUTE1,ATTRIBUTE1)
                              , VALID_YN    = @TOBE_VALID
                              , ATTRIBUTE8 = @COMMENT
                              , ATTRIBUTE9 = INCOTERMS  -- 변경전 정보 보관 필요
                              --, ATTRIBUTE10 = 'NERP_SCP_UPDATE' -- 20250929 YMH 주석처리 BOD인코텀즈에서 활용
                              , LAST_UPDATED_BY = @CREATED_BY
                              , LAST_UPDATE_DATE = GETDATE()
                         WHERE  BOD_ID      = @BOD_ID



                        FETCH NEXT FROM CURSOR_BOD
                        INTO @BOD_ID,@division_id, @from_site,@to_site,@ROUTE_ID, @valid_yn,@transport_mode
                        END
                        CLOSE CURSOR_BOD;
                        DEALLOCATE CURSOR_BOD;

                        ---############################################################################
                        -- plan 중복이슈 체크
                        ---###########################################################################
                        /*
                        select division_id, from_site, to_site, incoterms, transport_mode, from_yyyymmdd, to_yyyymmdd, route_id, *
                        from SCP_MST_BOD_n_v with(nolock)
                        where division_id + ':'+ from_site + ':'+ to_site + ':'+ incoterms + ':'+ transport_mode
                         in (

                        select division_id + ':'+ from_site + ':'+ to_site + ':'+ incoterms + ':'+ transport_mode
                        from SCP_MST_BOD_n_v with(nolock)
                        where bod_valid_yn = 'Y'
                        group by division_id, from_site, to_site, incoterms, transport_mode
                        having count(*) > 1
                        )
                        order by 1,2,3,4,5


                        select division_id,from_site, to_site,incoterms, b.valid_yn, r.transport_mode,b.ROUTE_ID
                            , max(b.attribute3) as attribute3
                            , max(b.attribute2) as attribute2
                            , max(bod_id) as bod_id
                            ,  count(*) AS CNT

                        from SCP_MST_BOD b with (nolock)
                        inner join scp_mst_distribution_route r with (nolock) on b.ROUTE_ID = r.ROUTE_ID
                        where b.valid_yn = 'Y'
                        group by division_id,from_site, to_site,incoterms, b.valid_yn, r.transport_mode,b.ROUTE_ID
                        having count(*) > 1
                        */



                    SET @MAPPING_RESULT = 'Y';
                    END

                -- 20241007 : SALES ? DM / PLANT - SCP 처리하도록 변경
                ELSE IF @TABLE_NAME = 'SCM_MST_SITE_ITEM'
                 BEGIN

                    --SCM_MST_SITE_ITEM DIVISION_ID
                    --SCM_MST_SITE_ITEM PROJECT_CODE
                    --SCM_MST_SITE_ITEM SCM_SITE_ID
                    --SCM_MST_SITE_ITEM ITEM_ID

                    -- 20241003 항목추가 SALES_COMPANY,SALES_PLANT

                    -- 96035
                    -- attribute11 추가?
                    -- update SCM_MST_SITE_ITEM set attribute10 = @CREATED_BY;

                    /*
                    select attribute10, count(*)
                    from SCM_MST_SITE_ITEM
                    group by attribute10
                    */

                    -- 92707 / 96035  103326
                    DELETE from NERP_CONV_SCP_DATA 
                    where table_name = 'SCM_MST_SITE_ITEM';
                    --------------------------------------------------------------------------------------
                    INSERT INTO NERP_CONV_SCP_DATA
                    (
                      TABLE_NAME
                      ,COLUMN_NAME1,COLUMN_NAME2,COLUMN_NAME3,COLUMN_NAME4,COLUMN_NAME5,COLUMN_NAME6
                    , OLD_VALUE1,OLD_VALUE2, OLD_VALUE3, OLD_VALUE4, OLD_VALUE5, OLD_VALUE6
                    , NEW_VALUE3, NEW_VALUE5, NEW_VALUE6
                    )
                    SELECT   'SCM_MST_SITE_ITEM' AS C1
                           , 'DIVISION_ID'       AS C2
                           , 'PROJECT_CODE'      AS C3
                           , 'SCM_SITE_ID'       AS C4
                           ,  'ITEM_ID'          AS C5
                           ,  'SALES_COMPANY'    AS C6
                           ,  'SALES_PLANT'      AS C7
                           , DIVISION_ID, PROJECT_CODE , SCM_SITE_ID, ITEM_ID, SALES_COMPANY, SALES_PLANT
                           --2025-06-12 코드 매핑 그대로 사용
                           --, CASE WHEN ISNULL(NV1.TOBE_CD,'') != ''
                           --       THEN REPLACE( SCM_SITE_ID, SCM_SITE_ID_BODY, NV1.TOBE_CD)
                           --       END AS TOBE_SCM_SITE_ID
                           , NS1.NEW_VALUE1 AS TOBE_SCM_SITE_ID
                           , NC1.TOBE_COMPANY AS TOBE_SALES_COMPANY
                           , NP1.TOBE_PLANT AS TOBE_SALES_PLANT
                    --INTO #TMP_A
                    FROM
                    (
                        SELECT

                               DIVISION_ID, PROJECT_CODE , SCM_SITE_ID, ITEM_ID, SALES_COMPANY, SALES_PLANT
                               ,CASE WHEN charindex( '-', SCM_SITE_ID) > 0 AND charindex( '_', SCM_SITE_ID) > 0
                                     THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'-'),0,'_')
                                     WHEN charindex( '-', SCM_SITE_ID) > 0
                                     THEN dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'-')
                                     WHEN charindex( '_', SCM_SITE_ID) > 0
                                     THEN dbo.FN_SCM_SPLIT(SCM_SITE_ID,0,'_')
                                     ELSE SCM_SITE_ID
                                     END SCM_SITE_ID_BODY
                        FROM SCM_MST_SITE_ITEM C with (nolock)
                    ) list
                    LEFT JOIN (select ASIS_CD,TOBE_CD,GUBUN,RNO from #TMP_VENDOR_PLANT_COMPANY) NV1 ON NV1.ASIS_CD = SCM_SITE_ID_BODY
                    LEFT JOIN (select ASIS_COMPANY,TOBE_COMPANY,DESC01 from #TMP_COMPANY) NC1 ON NC1.ASIS_COMPANY = SALES_COMPANY
                    LEFT JOIN (select ASIS_PLANT,TOBE_PLANT,DESC01,RNO from #TMP_PLANT) NP1 ON NP1.ASIS_PLANT = SALES_PLANT
                    LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1
                                 FROM NERP_CONV_MASTER_CFM_V
                                WHERE codetype = 'SCP_SITE_ID'
                                  and NEW_VALUE1 IS NOT NULL
                                  and ATTRIBUTE5 = @P_ROLLIN
                    ) NS1  ON NS1.OLD_VALUE1 = SCM_SITE_ID

                    --------------------------------------------------------------------------------------
                    -- ASIS 남기고 TOBE 추가 버전
                    -- 20240911 SALES_COMPANY, SALES_PLANT 도 Converter 해 주어야 한다
                    --------------------------------------------------------------------------------------
                    -- 96035 중 7291 신규생성
                    -- Vendor로 매핑
                    -- Customer 로 매핑 필요?
                    -- 20241014 PROJECT_S_OP_REPORT 추가
                    INSERT INTO SCM_MST_SITE_ITEM
                    SELECT *
                    FROM (
                        SELECT
                             DIVISION_ID
                            ,PROJECT_CODE
                            , case when isnull(New_value3,'') != ''
                                  THEN B.New_value3
                                  ELSE SCM_SITE_ID
                                  END  SCM_SITE_ID
                            ,ITEM_ID
                            ,CURRENCY
                            ,CELL_PER_CAR
                            ,CELL_PER_MODULE
                            ,LIABILITY_PERIOD
                            ,SALES_PLAN_ADJUST_YN
                            ,ITEM_HRCY_ID
                            ,VALID_YN
                            ,BPMS_EXIST
                            ,CUST_GROUP
                            ,CUST_GROUP_DTL
                            ,OWNER
                            ,APPLICATION
                            ,ROUTE
                            ,CREATED_BY,CREATION_DATE
                            --,LAST_UPDATED_BY,LAST_UPDATE_DATE
                            --,@CREATED_BY as CREATED_BY
                            --, GETDATE() AS CREATION_DATE
                            ,@CREATED_BY as LAST_UPDATED_BY
                            , GETDATE() AS LAST_UPDATE_DATE
                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,REPORT_GROUP1
                            ,REPORT_GROUP2
                            ,REPORT_GROUP3
                            ,REPORT_GROUP4
                            ,REPORT_GROUP5
                            ,REPORT_GROUP6
                            ,REPORT_GROUP7
                            ,REPORT_GROUP8
                            ,EDI_LT
                            ,SCP_VMI_LT
                            ,B.new_value5 AS SALES_COMPANY
                            ,B.new_value6 AS SALES_PLANT
                            ,PARTIAL_PLAN_YN
                            ,CONSENSUS_MKT
                            ,CONSENSUS_ESS
                            ,CONSENSUS_SCM
                            ,INVENTORY_DAY
                            ,CHANGE_REASON
                            ,ALT_SIM_YN
                            ,DESCRIPTION
                            ,PROJECT_INFO
                            ,PROJECT_S_OP_REPORT
                            ,CELL_S_OP_REPORT -- 20241204 컬럼추가 적용
                            ,PRJ_OWNR_ID -- 20241223 컬럼추가 적용
                            ,CRGE_ORG_NM -- 20241223 컬럼추가 적용
                            ,CUST_ENG_NM -- 20241223 컬럼추가 적용
                        FROM SCM_MST_SITE_ITEM L with (nolock)
                        LEFT JOIN (
                                -- 92707 8851  / 96035 중 7291
                                -- PK = DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                                select old_value1,  old_value2,  old_value3,  old_value4
                                     , new_value3,  new_value5, new_value6
                                     , 'Y' AS MAPPING
                                from NERP_CONV_SCP_DATA
                                where table_name = 'SCM_MST_SITE_ITEM'
                                and ( isnull(new_value3,'') != '')
                                --and ( isnull(new_value3,'') != '' or isnull(new_value5,'') != '' or isnull(new_value6,'') != '')
                        ) B
                         ON L.DIVISION_ID  = B.old_value1
                        AND L.PROJECT_CODE = B.old_value2
                        AND L.SCM_SITE_ID  = B.old_value3
                        AND L.ITEM_ID      = B.old_value4
                        WHERE ISNULL(B.MAPPING,'') = 'Y'
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_MST_SITE_ITEM MD  WITH (NOLOCK)
                                    WHERE  MD.DIVISION_ID  = X.DIVISION_ID
                                    AND    MD.PROJECT_CODE = X.PROJECT_CODE
                                    AND    MD.SCM_SITE_ID  = X.SCM_SITE_ID
                                    AND    MD.ITEM_ID      = X.ITEM_ID
                                    )


                    --------------------------------------------------------------------------------------
                    -- 신규생성 된  asis 데이터 7291 건은 삭제
                    --------------------------------------------------------------------------------------
                    DELETE SCM_MST_SITE_ITEM
                      FROM SCM_MST_SITE_ITEM a
                      JOIN ( SELECT *
                               from NERP_CONV_SCP_DATA
                              where table_name = 'SCM_MST_SITE_ITEM'
                              and ( isnull(new_value3,'') != '')
                            ) b
                        on A.DIVISION_ID            = B.OLD_VALUE1
                       AND A.PROJECT_CODE           = B.OLD_VALUE2
                       AND A.SCM_SITE_ID            = B.OLD_VALUE3
                       AND A.ITEM_ID                = B.OLD_VALUE4


                    --select 103326 - 7291 = 96035
                    -- select distinct  SCM_SITE_ID from SCM_MST_SITE_ITEM order by SCM_SITE_ID

-->>>>#################################
--중요
-->>>>#################################
                    --------------------------------------------------------------------------------------
                    -- 20241004 확인 이슈 - 조치 필요
                    --A011  HQ06
                    --A041  HQ07
                    --F031  HQ10
                    --G482  WA00
                    --------------------------------------------------------------------------------------
                    -- 1334
                    update SCM_MST_SITE_ITEM
                    set scm_site_id = replace(scm_site_id,'A011','HQ06')
                    where scm_site_id like 'A011%'

                    -- 261
                    update SCM_MST_SITE_ITEM
                    set scm_site_id = replace(scm_site_id,'A041','HQ07')
                    where scm_site_id like 'A041%'

                    -- 8
                    update SCM_MST_SITE_ITEM
                    set scm_site_id = replace(scm_site_id,'F031','HQ10')
                    where scm_site_id like 'F031%'

                    -- 222
                    update SCM_MST_SITE_ITEM
                    set scm_site_id = replace(scm_site_id,'G482','WA00')
                    where scm_site_id like 'G482%'


                    ------------------------------------------------------------------------
                    -- 20240911 SALES_COMPANY, SALES_PLANT 도 Converter 해 주어야 한다
                    ------------------------------------------------------------------------

                    -- 60891
                    UPDATE.SCM_MST_SITE_ITEM
                    SET.SCM_MST_SITE_ITEM.SALES_COMPANY = B.NEW_VALUE1
                    FROM .SCM_MST_SITE_ITEM AS A,
                    (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' AND ATTRIBUTE5 = @P_ROLLIN ) AS B
                    WHERE A.SALES_COMPANY = B.OLD_VALUE1



                    -- 60907
                     UPDATE.SCM_MST_SITE_ITEM
                     SET.SCM_MST_SITE_ITEM.SALES_PLANT = B.NEW_VALUE1
                     FROM .SCM_MST_SITE_ITEM AS A,
                     (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN ) AS B
                     WHERE A.SALES_PLANT = B.OLD_VALUE1




                        /*
                        20241004 : ASIS DATA SALES_COMPANY, SALES_PLANT 도 TOBE 코드를 사용하도록 유지
                        ------------------------------------------------------------------------------------------------------------
                        */

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
            , ' , @LOOKUP_TYPE = ', @TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            , ' , @END_TIME = '   , @END_TIME
            , ' , @RUN_TIME = '   , @RUN_TIME
            );


                    UPDATE  ZNERP_DEV_ITEM_SCHEDULE
                    SET MAPPING_START = @START_TIME,
                        MAPPING_END   = @END_TIME,
                        MAPPING_TIME  = @RUN_TIME
                      , mapping_comment = N'FINISH'
                      , mapping_query   = 'NERP_CONV_SCP_MASTER '
                      , STATUS          = 'FINISH'
                      , UPDATE_USER     = @CREATED_BY
                    where DEV_TYPE = 'Batch_Conversion'
                    and mapping_use IN ( 'IN')
                    and program_id = @TABLE_NAME



            SET @v_log_message = concat('[MAPPING_TIME] = ', DATEDIFF(SECOND, @MAPPING_START_TIME, @MAPPING_END_TIME));
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @@ROWCOUNT, 'FINISH', @v_log_message, @d_event_date;

        END

        --COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            --ROLLBACK TRANSACTION;
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();
    END CATCH


        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME ;

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
