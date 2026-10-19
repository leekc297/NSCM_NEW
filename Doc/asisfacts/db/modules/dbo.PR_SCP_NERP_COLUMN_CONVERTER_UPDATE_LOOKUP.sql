



-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP
-- Author:       vadabi5
-- Create date:  2024-04-29
-- Description:  NERP) Master Lookup 관련 코드 생성
-- ==========================================================================================
/*
-- 20240429     vadabi5     NERP) 신규 생성
-- 20240917     vadabi5     NERP) 통합테스트 3차 위한 준비
-- 20241001     vadabi5     NERP) NERP_ROLLIN_PLANT
-- 20241031     vadabi5     NERP) EE_PRODUCTION_PLAN
--                                EE_SHIPMENT_PLAN_FG
--                                EE_PSI_PRODUCTION
--                                EE_PROBLEM_REPORT_DEMAND
--                                EE_SHIPMENT_PLAN
-- 20241204     vadabi5     NERP) 실전테스트 전
--                                COMPANY_DESC
--                                ELECTRODE_SHIP_SITE
--                                NERP_ROLLIN_PLANT
-- 20241219     vadabi5     NERP) 이슈 SLOC_ADD_INFO
-- 20241219     vadabi5     NERP) Group Common
                                  -------------------------------------------------
                                  COMPANY_DESC
                                  EXFACTORY_INTRANSIT_TARGET
                                    LOGISTICS_VISIBILITY_TRANS_MODE
                                  PACKER_SCS
                                  SALES_PLANT
                                    SCM_ITEM_TYPE_FOR_PLAN
                                  VMI_SCM_SITE
-- 20250308     김준규       NERP) 중복 입력 에러 방지처리
-- 20250416     김준규       NERP) 룩업추가 EE_ASSY_PLANT_MAPPING,ESST_DIV_SITE_CHANGE,SCP_OPT_ENG_MODEL_TEMP
-- 20250418     김준규       NERP) INTRANSIT_TO_SITE 오류 수정
-- 20250515     김준규       NERP) LOOKUP 4개(SCM_ITEM_TYPE_FOR_PLAN,ELECTRODE_SHIP_SITE,JV_PLANT,ERP_POSTING_STOCK_SETUP) 에 대하여는 VALID_YN에 과거 값은 N처리
--                                ERP_POSTING_STOCK_SETUP 의 경우 PLANT_ID 중복 시 Division이 EE 로 시작하는 정보 N 처리
-- 20250515     김준규       NERP) EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
-- 20250516     김준규       NERP) ERP_POSTING_STOCK_SETUP RFC당길때 SEGMENT5는 G:GERP,N:NERP 되도록 되어 있어서 추가함
-- 20250605     김준규       NERP) LOOKUP_TYPE = 'INVENTORY_SITE' 사용하는 프로그램을 확인하니 PLANT_ID로 사용중이므로 변경(기존 VENDOR_ID)
-- 20250613     김준규       NERP) LOOKUP_TYPE = 'ELECTRODE_LINE_WIDE_RATE' 이 PLANT_ID로 되어 있는 것을 SCP_SITE_ID로 변경(오류)
-- 20250718     김준규       NERP) LOOKUP_TYPE = 'SHIPMENT_REPORT_LOOKUP' 부분 CONCAT(NV1.TOBE_VENDOR,SEGMENT2_TAIL) --> IIF(NV1.TOBE_VENDOR IS NULL,SEGMENT2, CONCAT(NV1.TOBE_VENDOR,SEGMENT2_TAIL)) 수정
-- 20250804     김준규       NERP) LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE' SEGMENT1=SCP_SITE_ID 추가
-- 20250804     김준규       NERP) LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE' SEGMENT4=COMPANY_ID 추가
-- 20250828     김준규       NERP) LOOKUP_TYPE = 'INVENTORY_SITE' SEGMENT1 NB00 이미 N되어 있어서 추가가 안되었고 N되어 있어서 강제로 Y처리
-- 20251029     김준규       NERP) LOOKUP_TYPE = 'SALES_PLANT' and SEGMENT2 in (SELECT OLD_V 로 되어있던 것 오류 SEGMENT1로 변경.
*/
-- ==========================================================================================
/*
    EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP @P_LOOKUP_TYPE ='SHIPMENT_REPORT_LOOKUP',@P_ROLLIN = '3RD'
--------------------------------------------------------------------
    select dev_detail, status, MAPPING_START, MAPPING_END, MAPPING_TIME, mapping_column
    from ZNERP_DEV_ITEM_SCHEDULE
    where  dev_type = 'Batch_LOOKUP'
    and mapping_use = 'Y'
    --  and ISNULL(status,'') != 'FINISH'
    order by program_id,  dev_detail

--------------------------------------------------------------------
    update ZNERP_DEV_ITEM_SCHEDULE
    SET status = null
    , MAPPING_START = null
    , MAPPING_END = null
    , MAPPING_TIME = null
    , mapping_column = ''
    where  dev_type = 'Batch_LOOKUP'
    and mapping_use = 'Y'
    and dev_detail = 'INCOTERMS'
---------------------------------------------------------------------

    select *
    from LGCE_INF.dbo.ZNERP_TOBE_CODE_INFO
    where CODE_OLD_01 in ('A010','G673')
---------------------------------------------------------------------
    select count(*) from SCM_ADM_LOOKUP_MASTER_DETAIL -- 15067
    select count(*) from SCM_ADM_LOOKUP_MASTER_DETAIL -- 4225
    where lookup_type in (SELECT lookup_type from  SCM_ADM_LOOKUP_MASTER where lookup_group = 'SCP')
    select count(*) from SCM_ADM_LOOKUP_MASTER_DETAIL where CREATED_BY = @CREATED_BY -- 811

    COMPANY_DESC
    select count(*) from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'COMPANY_DESC'

    delete from SCM_ADM_LOOKUP_MASTER_DETAIL where CREATED_BY = @CREATED_BY

    select lookup_type, count(*)
    from SCM_ADM_LOOKUP_MASTER_DETAIL
    where CREATED_BY = @CREATED_BY
    group by lookup_type
    order by lookup_type

    delete from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'ADD_LINE_CAPA_ROUTE' and segment2 = 'HQ05'
    delete from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'EE_PROBLEM_REPORT_DEMAND' and segment2 like 'HQ%'
    delete from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'EE_PROBLEM_REPORT_DEMAND' and segment2 like 'WA%'

    -------------------------------------------------------------------------------------------------------------------
    INSERT INTO ZNERP_DEV_ITEM_SCHEDULE
    (DEV_TYPE, DEV_ID, PROGRAM_ID, DEV_DETAIL, DEV_REMARK, MAPPING_COLUMN, mapping_query, mapping_use)
    SELECT 'Batch_LOOKUP', 'GSCM.SCP-0004', 'SCM_ADM_LOOKUP_MASTER_DETAIL', 'NERP_ROLLIN_PLANT', 'SCP', 'SEGMENT1=PLANT_ID', 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP', 'Y'


*/
-- =============================================
CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP]

 @P_LOOKUP_TYPE nvarchar(100)
,@P_ROLLIN      nvarchar(30) --1ST 2ND 3RD 4TH

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
DECLARE @TABLE_NAME NVARCHAR(400);
DECLARE @LOOKUP_TYPE NVARCHAR(400);
DECLARE @SOURCE_COLUMN NVARCHAR(400);
DECLARE @MAPPING_COLUMN NVARCHAR(400);
DECLARE @MAPPING_USE NVARCHAR(400);
DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;

DECLARE @CNT BIGINT;
DECLARE @WORK_SECOND BIGINT;
DECLARE @MAPPING_RESULT NVARCHAR(2);
DECLARE @BATCH_RUN_TIME BIGINT;
DECLARE @BATCH_START_TIME DATETIME;
DECLARE @BATCH_END_TIME DATETIME;
DECLARE @RUN_TIME BIGINT;
DECLARE @START_TIME DATETIME;
DECLARE @END_TIME DATETIME;
DECLARE @DUMMY VARCHAR(MAX);

SET @CNT = 0;
SET @RUN_TIME = 0;
SET @MAPPING_COLUMN = '';



--###########################################################################################################
-- LOG 용 변수 설정
--###########################################################################################################
DECLARE @v_batch_user NVARCHAR(150) = 'NERP_SCP_BATCH';
DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_LOOKUP';
DECLARE @v_log_type     NVARCHAR(30) = 'LOOKUP';
DECLARE @n_log_count    INTEGER = 0;
DECLARE @v_log_message  NVARCHAR(1000);
DECLARE @v_description  NVARCHAR(max);
DECLARE @d_event_date   DATETIME;
DECLARE @v_ifseqno      NVARCHAR(30);
DECLARE @n_history_seq  BIGINT;


BEGIN TRY

        --###############################################################################################
        -- START
        --###############################################################################################
        -- 시작 LOG
        SET @v_log_type = 'START';
        SET @v_log_message = '########## Start of procedure ##########';
        SET @v_description = '@P_LOOKUP_TYPE:'+@P_LOOKUP_TYPE+',@P_ROLLIN:'+@P_ROLLIN+',TABLE : SCM_ADM_LOOKUP_MASTER_DETAIL';
        SET @d_event_date = SYSDATETIME();
        SET @BATCH_START_TIME = SYSDATETIME();
        SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;


        --LOOKUP은 NERP 신규코드를 추가한다.
        --그리고 나서 구코드는 DESC에 구)코드라고 표시한다.(수작업?)


        --################################################################
        -- 작업 초기화
        --################################################################
        IF OBJECT_ID('tempdb..#TMP_COMPANY') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_COMPANY
        END

        IF OBJECT_ID('tempdb..#TMP_PLANT') IS NOT NULL
        BEGIN
        DROP TABLE #TMP_PLANT
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


        --#################################################################################
        -- TEMP MAPPING TABLE
        --#################################################################################
        -- 3
        SELECT OLD_VALUE1 AS ASIS_COMPANY, NEW_VALUE1 AS TOBE_COMPANY
        INTO #TMP_COMPANY
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'COMPANY_ID'
        AND ATTRIBUTE5 = @P_ROLLIN


        ----------------------------------------------------------------------
        -- 17
        SELECT OLD_VALUE1 AS ASIS_PLANT, NEW_VALUE1 AS TOBE_PLANT
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
        INTO #TMP_PLANT
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'PLANT_ID'
        AND ATTRIBUTE5 = @P_ROLLIN

        ----------------------------------------------------------------------
        -- 53599
        SELECT OLD_VALUE1 AS ASIS_VENDOR
             , NEW_VALUE1 AS TOBE_VENDOR
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
        INTO #TMP_VENDOR
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'VENDOR_ID'
        AND ATTRIBUTE5 = @P_ROLLIN



        ----------------------------------------------------------------------
        -- 17873  37873
        SELECT OLD_VALUE1 AS ASIS_CUSTOMER
             , NEW_VALUE1 AS TOBE_CUSTOMER
             , DESC1 AS DESC01
             , COMMENT1 AS ETC1
        INTO #TMP_CUSTOMER
        FROM NERP_CONV_MASTER_CFM_V
        WHERE CODETYPE = 'END_CUSTOMER_ID'
        AND ATTRIBUTE5 = @P_ROLLIN
        --AND ROLL02 = ''
        --AND NEW_VALUE1 != N'삭제'


        ----------------------------------------------------------------------
     --  SELECT OLD_VALUE1
        --    , OLD_VALUE_BODY  AS ASIS_VALUE_BODY
        --    , NEW_VALUE1      AS TOBE_SCM_SITE_ID
        --INTO #TMP_SCM_SITE_ID
        -- FROM NERP_CONV_SCP_SCM_SITE_ID
     --   WHERE MAPPING_COLUMN = 'SCM_SITE_ID'
        --AND MAPPING_USE = 'Y'

        --select OLD_VALUE2 AS ASIS_SITE
        --      ,OLD_VALUE1 AS ASIS_SITE_BODY
        --      ,NEW_VALUE1 AS TOBE_SITE
        --from NERP_CONV_MASTER_CFM_V
        --where codetype = 'SITE_ID'
        --and ATTRIBUTE5 = @P_ROLLIN


        -- 103
        select OLD_VALUE1 AS ASIS_SCM_SITE_ID
              ,OLD_VALUE2 AS ASIS_SCM_SITE_ID_BODY
              ,NEW_VALUE1 AS TOBE_SCM_SITE_ID
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


        ----------------------------------------------------------------------
        -- 627
        SELECT ASIS_PLANT, ASIS_STORAGE
             , TOBE_PLANT, TOBE_STORAGE
             , DESC01, DESC02, DESC03
             , ETC1, ETC2
             , RANK () OVER (PARTITION BY TOBE_PLANT, TOBE_STORAGE  ORDER BY ASIS_PLANT, ASIS_STORAGE ) AS RANK_STORAGE
        INTO #TMP_STORAGE_RANK
        FROM #TMP_STORAGE


        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END


        --################################################################
        -- CURSOR_MAPPING
        --################################################################
        DECLARE CURSOR_MAPPING CURSOR FOR

        -- Batch_LOOKUP         = 23개
        -- Batch_LOOKUP_COMMON  = 7개
        select program_id AS TABLE_NAME
             , dev_detail AS LOOKUP_TYPE
          from ZNERP_DEV_ITEM_SCHEDULE
         where  dev_type in ( 'Batch_LOOKUP')
           and mapping_use = 'Y'
          -- and ISNULL(status,'') != 'FINISH'
           and dev_remark IN ('SCP', 'COMMON')
           and dev_detail != 'INCOTERMS' --> DM에서 조치 협의
           and (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR dev_detail = @P_LOOKUP_TYPE)
         order by dev_remark desc, program_id,  dev_detail

        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END

        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME, @LOOKUP_TYPE

        WHILE @@FETCH_STATUS = 0
        BEGIN

    BEGIN TRY
        --BEGIN TRANSACTION;

            PRINT '------------------------------------------------------------------------------------------------------------------------------------------';
            SET @P_LOOKUP_TYPE = @LOOKUP_TYPE;
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @LOOKUP_TYPE, 0, '0', '', @START_TIME;
            SET @v_description = 'START -->> '+concat(
            '     @CNT = ' , @CNT
            , ' , @LOOKUP_TYPE = ', @LOOKUP_TYPE
            , ' , @START_TIME = ' , @START_TIME
            );

            PRINT @v_description


            SET @MAPPING_USE = 'N';
        --################################################################
        -- 작업
        --################################################################
                -- DIVISION_ID
                -- SITE_ID
                -- PLANT_ID
                -- SCP_ROUTE_ID
                IF @P_LOOKUP_TYPE = 'ADD_LINE_CAPA_ROUTE'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT2=PLANT_ID,SEGMENT3=PLANT_ID';
                    --1 2025-03-08 중복입력 방지처리
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                , isnull(NP1.TOBE_PLANT, SEGMENT2) as SEGMENT2
                                , isnull(NP2.TOBE_PLANT, SEGMENT3) as SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE

                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                                FROM
                                (
                                    --2025-03-08 중복에러 제거 방지
                                    select *
                                    from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                    where lookup_type = 'ADD_LINE_CAPA_ROUTE'
                                    and valid_yn = 'Y'

                                ) list
                                LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT2 = NP1.ASIS_PLANT
                                LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP2 ON list.SEGMENT3 = NP2.ASIS_PLANT
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5


                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT2=PLANT_ID,SEGMENT3=PLANT_ID';


                    --14 -> 16
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,replace(SEGMENT2,SEGMENT2_BODY,'' ) )
                                      ELSE SEGMENT2
                                      END AS SEGMENT2
                                --,NMV.NEW_VALUE1
                                --,SEGMENT3
                                --,SEGMENT3_BODY
                                --,replace(SEGMENT3,SEGMENT3_BODY,'' ) AS SEGMENT3_TAIL
                                ,CASE WHEN NP2.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP2.TOBE_PLANT,replace(SEGMENT3,SEGMENT3_BODY,'' ) )
                                      ELSE SEGMENT3
                                      END AS SEGMENT3
                                --,NMX.NEW_VALUE1
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT2) > 0 AND charindex( '_', SEGMENT2) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT2,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT2) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'-')
                                    WHEN charindex( '_', SEGMENT2) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'_')
                                    ELSE SEGMENT2
                                    END SEGMENT2_BODY

                              ,CASE WHEN charindex( '-', SEGMENT3) > 0 AND charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT3,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'-')
                                    WHEN charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'_')
                                    ELSE SEGMENT3
                                    END SEGMENT3_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_PROBLEM_REPORT_DEMAND'
                            and valid_yn = 'Y'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT2_BODY = NP1.ASIS_PLANT
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP2 ON list.SEGMENT3_BODY = NP2.ASIS_PLANT
                        where NP1.TOBE_PLANT != SEGMENT2_BODY OR NP2.TOBE_PLANT != SEGMENT3_BODY
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5


                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where CODETYPE = 'SCP_SITE_ID'
                        --    AND ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_PROBLEM_REPORT_DEMAND'
                        --and SEGMENT1 = 'SCP'
                        ----2025-05-14 김준규 SEGMENT3을 SEGMENT2로 변경(3으로 하면 N되는게 없음)
                        --and A.SEGMENT2  = B.OLD_VALUE1
                        --and CREATED_BY != @CREATED_BY



                    --  select * from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'EE_PROBLEM_REPORT_DEMAND' and segment2 like 'HQ%'
                    --  select * from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'EE_PROBLEM_REPORT_DEMAND' and segment2 like 'WA%'

                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT3=PLANT_ID';

                    --83
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                --,SEGMENT3 AS SEGMENT3_OLD
                                --,SEGMENT3_BODY
                                --,replace(SEGMENT3,SEGMENT3_BODY,'' ) AS SEGMENT3_TAIL
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT ,replace(SEGMENT3,SEGMENT3_BODY,'' ) )
                                      ELSE SEGMENT3
                                      END AS SEGMENT3
                                --,NMX.NEW_VALUE1
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT3) > 0 AND charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT3,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'-')
                                    WHEN charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'_')
                                    ELSE SEGMENT3
                                    END SEGMENT3_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_PRODUCTION_PLAN'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT3_BODY = NP1.ASIS_PLANT
                            WHERE NP1.TOBE_PLANT != SEGMENT3_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='SCP_SITE_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    AND ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_PRODUCTION_PLAN'
                        --and SEGMENT1 = 'SCP'
                        --and A.SEGMENT3  = B.OLD_VALUE1
                        --AND CREATED_BY != @CREATED_BY




                    --  select * from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'EE_PROBLEM_REPORT_DEMAND' and segment3 like 'HQ%'
                    --  select * from SCM_ADM_LOOKUP_MASTER_DETAIL where lookup_type = 'EE_PROBLEM_REPORT_DEMAND' and segment3 like 'WA%'
                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT3=PLANT_ID';

                    --16
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                --,SEGMENT3 AS SEGMENT3_OLD
                                --,SEGMENT3_BODY
                                --,replace(SEGMENT3,SEGMENT3_BODY,'' ) AS SEGMENT3_TAIL
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,replace(SEGMENT3,SEGMENT3_BODY,'' ) )
                                      ELSE SEGMENT3
                                      END AS SEGMENT3
                                --,NMX.NEW_VALUE1
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT3) > 0 AND charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT3,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'-')
                                    WHEN charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'_')
                                    ELSE SEGMENT3
                                    END SEGMENT3_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_PSI_PRODUCTION'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT3_BODY = NP1.ASIS_PLANT
                            WHERE NP1.TOBE_PLANT != SEGMENT3_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5


                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='SCP_SITE_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    AND ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
                        --and SEGMENT1 = 'SCP'
                        --and A.SEGMENT3  = B.OLD_VALUE1
                        --and CREATED_BY != @CREATED_BY




                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=PLANT_ID';

                    --14
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,replace(SEGMENT1,SEGMENT1_BODY,'' ) )
                                      ELSE SEGMENT1
                                      END AS SEGMENT1

                                ,CASE WHEN NP2.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP2.TOBE_PLANT,replace(SEGMENT2,SEGMENT2_BODY,'' ) )
                                      ELSE SEGMENT2
                                      END AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *

                              ,CASE WHEN charindex( '-', SEGMENT1) > 0 AND charindex( '_', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT1,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT1,0,'-')
                                    WHEN charindex( '_', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT1,0,'_')
                                    ELSE SEGMENT1
                                    END SEGMENT1_BODY
                              ,CASE WHEN charindex( '-', SEGMENT2) > 0 AND charindex( '_', SEGMENT2) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT2,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT2) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'-')
                                    WHEN charindex( '_', SEGMENT2) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'_')
                                    ELSE SEGMENT2
                                    END SEGMENT2_BODY

                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_SHIPMENT_PLAN'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT1_BODY = NP1.ASIS_PLANT
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP2 ON list.SEGMENT2_BODY = NP2.ASIS_PLANT
                        where NP1.TOBE_PLANT != SEGMENT1_BODY OR NP2.TOBE_PLANT != SEGMENT2_BODY
                        --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                        --###################################################################################
                        --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                        --###################################################################################
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='SCP_SITE_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    AND ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_SHIPMENT_PLAN'
                        --and SEGMENT1 = 'SCP'
                        --and A.SEGMENT2  = B.OLD_VALUE1
                        --AND CREATED_BY != @CREATED_BY


                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT3=PLANT_ID';

                    -- 18
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,replace(SEGMENT3,SEGMENT3_BODY,'' ) )
                                      ELSE SEGMENT3
                                      END AS SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT3) > 0 AND charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT3,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'-')
                                    WHEN charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'_')
                                    ELSE SEGMENT3
                                    END SEGMENT3_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_SHIPMENT_PLAN_FG'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT3_BODY = NP1.ASIS_PLANT
                            WHERE NP1.TOBE_PLANT != SEGMENT3_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='SCP_SITE_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    AND ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
                        --and SEGMENT1 = 'SCP'
                        --and A.SEGMENT3  = B.OLD_VALUE1
                        --AND CREATED_BY != @CREATED_BY





                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT3=PLANT_ID';

                    -- 8
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT   LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,replace(SEGMENT3,SEGMENT3_BODY,'' ) )
                                      ELSE SEGMENT3
                                      END AS SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT3) > 0 AND charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT3,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'-')
                                    WHEN charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'_')
                                    ELSE SEGMENT3
                                    END SEGMENT3_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_SHIPMENT_PLAN_SEMI'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT3_BODY = NP1.ASIS_PLANT
                            WHERE NP1.TOBE_PLANT != SEGMENT3_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                        --###################################################################################
                        --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                        --###################################################################################
                        --2025-05-14 김준규 없는 것 추가함.
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='SCP_SITE_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    AND ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_SEMI'
                        --and SEGMENT1 = 'SCP'
                        --AND A.SEGMENT3  = B.OLD_VALUE1
                        --AND CREATED_BY != @CREATED_BY





                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'ELECTRODE_LINE_WIDE_RATE'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=PLANT_NAME';
                    --2025-06-13 김준규 잘 못된 정보 가져옴(G383-E)
                    SET @MAPPING_COLUMN = 'SEGMENT1=SCP_SITE_ID,SEGMENT2=SCP_SITE_DESCRIPTION';

                    -- 45
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                --2025-06-13 김준규 잘 못된 정보 가져옴(G383-E)
                                --,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                --      THEN CONCAT(NP1.TOBE_PLANT,replace(SEGMENT3,SEGMENT1_BODY,'' ) )
                                --      ELSE SEGMENT1
                                --      END AS SEGMENT1
                                --,REPLACE(SEGMENT2,SEGMENT1_BODY, NP1.TOBE_PLANT) AS SEGMENT2
                                ,ISNULL(NS1.NEW_VALUE1,LIST.SEGMENT1) AS SEGMENT1
                                ,ISNULL(NS2.NEW_VALUE1,LIST.SEGMENT2) AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT1) > 0 AND charindex( '_', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT1,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT1,0,'-')
                                    WHEN charindex( '_', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT1,0,'_')
                                    ELSE SEGMENT1
                                    END SEGMENT1_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'ELECTRODE_LINE_WIDE_RATE'
                        ) list
                        --2025-06-13 김준규 잘 못된 정보 가져옴(G383-E)
                        --LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT1_BODY = NP1.ASIS_PLANT
                        --    WHERE NP1.TOBE_PLANT != SEGMENT1_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                        LEFT JOIN ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN) NS1
                                      ON list.SEGMENT1 = NS1.OLD_VALUE1
                        LEFT JOIN ( SELECT old_value1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_DESCRIPTION' and ATTRIBUTE5 = @P_ROLLIN) NS2
                                      ON list.SEGMENT2 = NS2.OLD_VALUE1
                        WHERE ISNULL(NS1.NEW_VALUE1,'') != '' OR ISNULL(NS2.NEW_VALUE1,'') != ''


                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'ELECTRODE_SLOC'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT1=WERKS_D,SEGMENT2=LGORT_D,SEGMENT3=STORAGE_NAME';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=STORAGE_ID,SEGMENT3=STORAGE_NAME';

                    -- 27 -> 30
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                               ,ISNULL(NS1.TOBE_SCM_SITE_ID, SEGMENT1) AS SEGMENT1
                               ,ISNULL(NST1.TOBE_STORAGE   , SEGMENT2) AS SEGMENT2
                               ,ISNULL(NST1.ETC1           , SEGMENT3) AS SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,CASE WHEN NST1.TOBE_STORAGE = N'삭제'
                                      THEN 'N'
                                      ELSE VALID_YN
                                      END AS VALID_YN
                                ,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1
                                ,ATTRIBUTE2
                                ,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15

                        FROM
                        (
                            select LD.*
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                           where LOOKUP_TYPE = 'ELECTRODE_SLOC'
                        ) list
                        LEFT JOIN ( SELECT ASIS_SCM_SITE_ID
                                        , dbo.FN_SCM_SPLIT(ASIS_SCM_SITE_ID, 1,'-') AS ASIS_SCM_SITE_ID_BODY
                                        , TOBE_SCM_SITE_ID
                                     from #TMP_SCM_SITE_ID) NS1
                                       ON list.SEGMENT1 = NS1.ASIS_SCM_SITE_ID
                        LEFT JOIN ( SELECT ASIS_PLANT, ASIS_STORAGE
                                         , TOBE_PLANT, TOBE_STORAGE
                                         , DESC01, DESC02, DESC03
                                         , ETC1, ETC2
                                      from #TMP_STORAGE
                                      ) NST1
                                      ON NS1.ASIS_SCM_SITE_ID_BODY = NST1.ASIS_PLANT
                                     AND LIST.SEGMENT2 = NST1.ASIS_STORAGE
                            WHERE NST1.TOBE_PLANT !=ASIS_SCM_SITE_ID_BODY OR SEGMENT2 != NST1.TOBE_STORAGE
                            AND TOBE_STORAGE IS NOT NULL
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5




                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'ERP_POSTING_STOCK_SETUP'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT3=PLANT_ID,ATTRIBUTE4=BUKRS';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT3=PLANT_ID,ATTRIBUTE4=COMPANY_ID';

                    -- 12 -> 11
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                ,ISNULL(TOBE_PLANT,SEGMENT3) AS SEGMENT3
                                ,SEGMENT4
                                --2025-05-16 김준규 SEGMENT5는 G:GERP,N:NERP 표시
                                ,'N' AS SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3
                                ,ISNULL(TOBE_COMPANY,ATTRIBUTE4) AS ATTRIBUTE4
                                ,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,@CREATED_BY AS ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select LD.*
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'ERP_POSTING_STOCK_SETUP'
                            and LD.SEGMENT3 NOT IN ('F031')
                        )  list
                       LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT3 = NP1.ASIS_PLANT
                       LEFT JOIN (SELECT ASIS_COMPANY, TOBE_COMPANY FROM #TMP_COMPANY ) NC1 ON list.ATTRIBUTE4 = NC1.ASIS_COMPANY
                       WHERE  list.SEGMENT3 != NP1.TOBE_PLANT
                       --ORDER BY SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5;
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    ----------------------------------------------------------------------------

                     ---- 기존 데이터 = ATTRIBUTE15
                     --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                     --   SET SCM_ADM_LOOKUP_MASTER_DETAIL.ATTRIBUTE15 = B.NEW_VALUE1
                     --      ,LAST_UPDATED_BY = @CREATED_BY
                     --      ,LAST_UPDATE_DATE = GETDATE()
                     -- FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A
                     --  , (SELECT OLD_VALUE1, NEW_VALUE1
                     --      FROM NERP_CONV_MASTER_CFM_V  with (nolock)
                     --     WHERE CODETYPE = 'PLANT_ID'
                     --       AND ATTRIBUTE5 = @P_ROLLIN
                     --   ) AS B
                     --   WHERE A.ATTRIBUTE4  = B.OLD_VALUE1
                     --   and A.SEGMENT3 NOT IN ('F031')
                     --   and lookup_type = 'ERP_POSTING_STOCK_SETUP'
                     --   AND CREATED_BY != @CREATED_BY

                    --2025-05-15 VALID_YN = 'N' 처리
                    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                       SET ATTRIBUTE14 = @CREATED_BY
                         , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                         , VALID_YN = 'N'
                         , LAST_UPDATED_BY = @CREATED_BY
                         , LAST_UPDATE_DATE = GETDATE()
                    WHERE LOOKUP_TYPE  = 'ERP_POSTING_STOCK_SETUP'
                      and isnull(ATTRIBUTE14,'') != @CREATED_BY
                      AND VALID_YN    = 'Y'
                      AND SEGMENT3 NOT IN ('F031')
                      and ATTRIBUTE4 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)

                    --2025-05-15
                    --ERP_POSTING_STOCK_SETUP 의 경우 PLANT_ID 중복 시 Division이 EE 로 시작하는 정보 N 처리
                    --SEGMENT3 : PLANT_ID, SEGMENT2 : DIVISION_ID
                    ;WITH W_RAW AS (
                        SELECT LMD.*
                              --DESC로 정렬
                              ,RNUM = ROW_NUMBER()OVER(PARTITION BY SEGMENT3 ORDER BY (CASE WHEN LMD.SEGMENT2 LIKE 'EE%' THEN ' ' ELSE LMD.SEGMENT2 END) DESC)
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
                        WHERE  LOOKUP_TYPE  = 'ERP_POSTING_STOCK_SETUP'
                        AND    VALID_YN    = 'Y'
                        AND    ATTRIBUTE4 in (SELECT NEW_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)
                    )
                    UPDATE LMD
                       SET ATTRIBUTE14 = @CREATED_BY
                         , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                         , VALID_YN = 'N'
                         , LAST_UPDATED_BY = @CREATED_BY
                         , LAST_UPDATE_DATE = GETDATE()
                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL AS LMD WITH(NOLOCK)
                    JOIN   W_RAW AS WR
                    ON     WR.LOOKUP_TYPE = LMD.LOOKUP_TYPE
                    AND    WR.SEGMENT1    = LMD.SEGMENT1
                    AND    WR.SEGMENT2    = LMD.SEGMENT2
                    AND    WR.SEGMENT3    = LMD.SEGMENT3
                    AND    WR.SEGMENT4    = LMD.SEGMENT4
                    AND    WR.SEGMENT5    = LMD.SEGMENT5
                    WHERE  WR.LOOKUP_TYPE= 'ERP_POSTING_STOCK_SETUP'
                    AND    WR.RNUM       >     1


                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'ERP_POSTING_STOCK_STORAGE'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=LGORT_D,SEGMENT4=STORAGE_NAME';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=STORAGE_ID,SEGMENT4=STORAGE_NAME';

                    -- 2
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,ISNULL(TOBE_STORAGE, SEGMENT1)  AS SEGMENT1
                                ,SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                --,ISNULL(NST1.DESC02,SEGMENT4)   AS SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,REPLACE(DESCRIPTION, PLANT,TOBE_PLANT ) AS DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select LD.*
                                 , LEFT(DESCRIPTION,4) AS PLANT
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                           where LOOKUP_TYPE = 'ERP_POSTING_STOCK_STORAGE'
                          --   and SEGMENT1 NOT IN ('9200')
                        ) list
                        LEFT JOIN ( SELECT ASIS_PLANT, ASIS_STORAGE
                                         , TOBE_PLANT, TOBE_STORAGE
                                         , DESC01, DESC02, DESC03
                                         , ETC1, ETC2
                                      from #TMP_STORAGE
                                      ) NST1
                                      ON LIST.PLANT = NST1.ASIS_PLANT
                                     AND LIST.SEGMENT1 = NST1.ASIS_STORAGE
                            WHERE NST1.TOBE_PLANT != list.PLANT  OR SEGMENT1 != TOBE_STORAGE
                            --AND TOBE_STORAGE IS NOT NULL
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5


                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'ESS_SHIP_PLAN_SITE'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=LIFNR';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=VENDOR_ID';

                    -- 2 2025-03-08 중복입력 방지처리
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,CASE WHEN NV1.TOBE_VENDOR IS NOT NULL
                                      THEN CONCAT(NV1.TOBE_VENDOR,replace(SEGMENT1,SEGMENT1_BODY,'' ) )
                                      ELSE SEGMENT1
                                      END AS SEGMENT1
                                ,SEGMENT2
                                --,NMX.COMMENT
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT1) > 0 AND charindex( '_', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT1,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT1,0,'-')
                                    WHEN charindex( '_', SEGMENT1) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT1,0,'_')
                                    ELSE SEGMENT1
                                    END SEGMENT1_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'ESS_SHIP_PLAN_SITE'
                        ) list
                        LEFT JOIN (SELECT ASIS_VENDOR, TOBE_VENDOR AS TOBE_VENDOR FROM #TMP_VENDOR) NV1 ON list.SEGMENT1_BODY = NV1.ASIS_VENDOR
                            WHERE NV1.TOBE_VENDOR != SEGMENT1_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    SET @MAPPING_USE = 'Y';
                    END

                -- DM 에 협조요청
                ELSE IF @P_LOOKUP_TYPE = 'INCOTERMS'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=INCO1 NEW,SEGMENT2=INCO1 OLD,VALID_YN=COUNT';

                    -- 2
                    SELECT 'INCOTERMS TODO'

                        -- 16
                        --select *
                        --from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                        --where lookup_type = 'INCOTERMS'


                        --SELECT CODE_OLD_01, CODE_OLD_02, CODE_NEW_01, CODE_NEW_02, DESC01
                        --            FROM NERP_CONV_SCP_CODE WITH (NOLOCK)
                        --          WHERE ROLL01 = 'INCO1'
                        --          AND ROLL02 = 'VTWEG'
                        --          AND CODE_OLD_01 LIKE 'Z%'

                    SET @MAPPING_USE = 'N';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'INTRANSIT_TO_SITE'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=KUNNR,SEGMENT3=WERKS_D';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=END_CUSTOMER_ID,SEGMENT3=PLANT_ID';

                    -- 5 -> 0
                    -- 20240927) G380 -> MI00 2ND
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        -- G380 롤인대상 아니어 0건
                        SELECT  LOOKUP_TYPE
                                ,ISNULL( NC1.TOBE_CUSTOMER, SEGMENT1 ) AS SEGMENT1
                                ,SEGMENT2
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN REPLACE(SEGMENT3, SEGMENT3_BODY, NP1.TOBE_PLANT)
                                      ELSE SEGMENT3
                                      END AS SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,NC1.COMMENT
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                              ,CASE WHEN charindex( '-', SEGMENT3) > 0 AND charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(dbo.FN_SCM_SPLIT(SEGMENT3,0,'-'),0,'_')
                                    WHEN charindex( '-', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'-')
                                    WHEN charindex( '_', SEGMENT3) > 0
                                    THEN dbo.FN_SCM_SPLIT(SEGMENT3,0,'_')
                                    ELSE SEGMENT3
                                    END SEGMENT3_BODY
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'INTRANSIT_TO_SITE'
                        ) list
                        --2024-04-18 김준규 JOIN 조건 오류 수정
                        LEFT JOIN (SELECT ASIS_CUSTOMER, TOBE_CUSTOMER, DESC01, ETC1 AS COMMENT FROM #TMP_CUSTOMER) NC1 ON list.SEGMENT1 = NC1.ASIS_CUSTOMER
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT3_BODY = NP1.ASIS_PLANT
                        WHERE NC1.TOBE_CUSTOMER != SEGMENT1 OR NP1.TOBE_PLANT != SEGMENT3_BODY
                        --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    SET @MAPPING_USE = 'Y';
                    END


                ELSE IF @P_LOOKUP_TYPE = 'INVENTORY_SITE'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=LIFNR';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=VENDOR_ID';
                    -- 2025-06-05 김준규 사용하는 프로그램을 확인하니 PLANT_ID로 사용중이므로 변경
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID';
                    -- 1 -> 0
                    --20240927 2ND) G384    MI Troy
                    --20240927 2ND) G630    NB Common
                    -- 2025-03-08 중복입력 방지처리
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        -- 롤인대상 없어 0건
                        SELECT  LOOKUP_TYPE
                                ,NP1.TOBE_PLANT AS SEGMENT1
                                ,SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                --,DESCRIPTION
                                ,NP1.DESC01 AS DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'INVENTORY_SITE'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT, DESC01, ETC1 AS COMMENT FROM #TMP_PLANT) NP1 ON list.SEGMENT1 = NP1.ASIS_PLANT
                            WHERE NP1.ASIS_PLANT != SEGMENT1
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --2025-08-28 수정
                    --
                    IF @P_ROLLIN = '3RD' 
                    BEGIN
                        UPDATE LD
                        SET    LD.VALID_YN = CASE WHEN LD.SEGMENT1 = 'G630' AND LD.VALID_YN = 'Y' THEN 'N'
                                                  WHEN LD.SEGMENT1 = 'NB00' AND LD.VALID_YN = 'N' THEN 'Y'
                                                ELSE LD.VALID_YN END
                              ,LAST_UPDATED_BY = @CREATED_BY
                              ,LAST_UPDATE_DATE = GETDATE()
                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                        WHERE  lookup_type = 'INVENTORY_SITE'
                        AND    LD.SEGMENT1 IN ('G630','NB00');
                    END;

                    SET @MAPPING_USE = 'Y';
                    END

                --20240927 2ND) G741 등
                ELSE IF @P_LOOKUP_TYPE = 'JV_PLANT'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT2=WERKS_D, SEGMENT3=BUKRS';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT2=PLANT_ID, SEGMENT3=COMPANY_ID';

                    -- 10 -> 0
                    --20240927 2ND) G741 등
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        -- 1차 롤인 대상 없어 0건
                        SELECT   LOOKUP_TYPE
                                ,SEGMENT1

                                , NP1.TOBE_PLANT AS SEGMENT2
                                , NC1.TOBE_COMPANY AS SEGMENT3
                                --,ISNULL(NP1.TOBE_PLANT,SEGMENT2)
                                --,ISNULL(NC1.TOBE_COMPANY,SEGMENT3)
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,@CREATED_BY AS ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'JV_PLANT'
                        ) list
                        LEFT JOIN (SELECT ASIS_COMPANY, TOBE_COMPANY FROM #TMP_COMPANY ) NC1 ON list.SEGMENT3 = NC1.ASIS_COMPANY
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT2 = NP1.ASIS_PLANT
                            WHERE NC1.TOBE_COMPANY != SEGMENT3 OR NP1.TOBE_PLANT != SEGMENT2
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --2025-05-15 VALID_YN = 'N' 처리
                    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                       SET ATTRIBUTE14 = @CREATED_BY
                         , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                         , VALID_YN = 'N'
                         , LAST_UPDATED_BY = @CREATED_BY
                         , LAST_UPDATE_DATE = GETDATE()
                    WHERE LOOKUP_TYPE  = 'JV_PLANT'
                      and isnull(ATTRIBUTE14,'') != @CREATED_BY
                      --and SEGMENT3 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)
                      and SEGMENT3 in (SELECT ASIS_COMPANY from #TMP_COMPANY )



                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT2=WERKS_D, DESCRIPTION=WERKS_D';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT2=PLANT_ID, DESCRIPTION=PLANT_ID';

                    --1
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,CONCAT(NP1.TOBE_PLANT,SEGMENT2_TAIL) AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,REPLACE(DESCRIPTION, SEGMENT2_BODY, NP1.TOBE_PLANT) AS DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                                 ,dbo.FN_SCM_SPLIT(segment2,0,'-') AS SEGMENT2_BODY
                                 ,REPLACE(segment2, dbo.FN_SCM_SPLIT(segment2,0,'-'),'') AS SEGMENT2_TAIL
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'SCP_SIMULATOR_SHIP_FIXED_TERM'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT   FROM #TMP_PLANT) NP1 ON list.SEGMENT2_BODY = NP1.ASIS_PLANT

                            WHERE NP1.TOBE_PLANT != SEGMENT2_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'SCS_ASSY_PACKER'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT2=LIFNR, DESCRIPTION=LIFNR_DESC1';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT2=VENDOR_ID, DESCRIPTION=VENDOR_DESC1';

                    --5 2025-03-08 중복입력 방지처리
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                          SELECT    LOOKUP_TYPE
                                    ,SEGMENT1
                                    ,CONCAT(NV1.TOBE_VENDOR,SEGMENT2_TAIL) AS SEGMENT2
                                    ,SEGMENT3
                                    ,SEGMENT4
                                    ,SEGMENT5
                                    ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                    ,VALID_YN
                                    , NV1.DESC01
                                    ,@CREATED_BY as CREATED_BY
                                    , GETDATE() AS CREATION_DATE
                                    ,@CREATED_BY as LAST_UPDATED_BY
                                    , GETDATE() AS LAST_UPDATE_DATE
                                    ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                    ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                    ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                            FROM
                            (
                                select *
                                     ,dbo.FN_SCM_SPLIT(segment2,0,'_') AS SEGMENT2_BODY
                                     ,REPLACE(segment2, dbo.FN_SCM_SPLIT(segment2,0,'_'),'') AS SEGMENT2_TAIL
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'SCS_ASSY_PACKER'
                            ) list
                            LEFT JOIN (SELECT ASIS_VENDOR, TOBE_VENDOR AS TOBE_VENDOR , DESC01, ETC1 FROM #TMP_VENDOR) NV1 ON list.SEGMENT2_BODY = NV1.ASIS_VENDOR

                                WHERE NV1.TOBE_VENDOR != SEGMENT2_BODY
                                --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                        ) X
                        WHERE 1=1
                        AND NOT EXISTS (SELECT 1
                                        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                        WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                        AND    MD.SEGMENT1     = X.SEGMENT1
                                        AND    MD.SEGMENT2     = X.SEGMENT2
                                        AND    MD.SEGMENT3     = X.SEGMENT3
                                        AND    MD.SEGMENT4     = X.SEGMENT4
                                        AND    MD.SEGMENT5     = X.SEGMENT5
                                        )
                        ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    SET @MAPPING_USE = 'Y';
                    END


                ELSE IF @P_LOOKUP_TYPE = 'SHIPMENT_REPORT_LOOKUP'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=WERKS_D,SEGMENT2=LIFNR';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=VENDOR_ID';

                    --72
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,SEGMENT1_TAIL)
                                      ELSE SEGMENT1
                                      END AS SEGMENT1
                                ,IIF(NV1.TOBE_VENDOR IS NULL,SEGMENT2, CONCAT(NV1.TOBE_VENDOR,SEGMENT2_TAIL)) AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,DESCRIPTION
                                --,NMX.COMMENT
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                                 ,dbo.FN_SCM_SPLIT(segment1,0,'-') AS SEGMENT1_BODY
                                 ,REPLACE(segment1, dbo.FN_SCM_SPLIT(segment1,0,'-'),'') AS SEGMENT1_TAIL

                                 ,dbo.FN_SCM_SPLIT(segment2,0,'_') AS SEGMENT2_BODY
                                 ,REPLACE(segment2, dbo.FN_SCM_SPLIT(segment2,0,'_'),'') AS SEGMENT2_TAIL
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'SHIPMENT_REPORT_LOOKUP'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT) NP1 ON list.SEGMENT1_BODY = NP1.ASIS_PLANT
                        LEFT JOIN (SELECT ASIS_VENDOR, TOBE_VENDOR AS TOBE_VENDOR FROM #TMP_VENDOR) NV1 ON list.SEGMENT2_BODY = NV1.ASIS_VENDOR

                            WHERE NV1.TOBE_VENDOR != SEGMENT2_BODY OR NP1.TOBE_PLANT != SEGMENT1_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    SET @MAPPING_USE = 'Y';
                    END


                ELSE IF @P_LOOKUP_TYPE = 'SITE_MAPPING'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=WERKS_D,SEGMENT2=WERKS_D';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=PLANT_ID';

                    --4
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,CASE WHEN NP1.TOBE_PLANT IS NOT NULL
                                      THEN CONCAT(NP1.TOBE_PLANT,SEGMENT1_TAIL)
                                      ELSE SEGMENT1
                                      END AS SEGMENT1
                                ,CONCAT( NP2.TOBE_PLANT,SEGMENT2_TAIL) AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                                 ,dbo.FN_SCM_SPLIT(segment1,0,'-') AS SEGMENT1_BODY
                                 ,REPLACE(segment1, dbo.FN_SCM_SPLIT(segment1,0,'-'),'') AS SEGMENT1_TAIL

                                 ,dbo.FN_SCM_SPLIT(segment2,0,'-') AS SEGMENT2_BODY
                                 ,REPLACE(segment2, dbo.FN_SCM_SPLIT(segment2,0,'-'),'') AS SEGMENT2_TAIL

                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'SITE_MAPPING'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT1_BODY = NP1.ASIS_PLANT
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP2 ON list.SEGMENT2_BODY = NP2.ASIS_PLANT
                            WHERE NP1.TOBE_PLANT != SEGMENT1_BODY OR NP2.TOBE_PLANT != SEGMENT2_BODY
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    SET @MAPPING_USE = 'Y';
                    END


                ELSE IF @P_LOOKUP_TYPE = 'SLOC_ADD_INFO'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=WERKS_D,SEGMENT2=LGORT_D, ATTRIBUTE2 = LGORT_ETC';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=STORAGE_ID, ATTRIBUTE2 = LGORT_ETC';

                    --413 -> 489
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                               , ISNULL(TOBE_PLANT,SEGMENT1) AS SEGMENT1
                               , ISNULL(TOBE_STORAGE,SEGMENT2) AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1
                                ,isnull(etc1,ATTRIBUTE2) AS ATTRIBUTE2
                                ,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                                --, NS.DESC01, nS.DESC02, ns.ETC1
                        FROM
                        (
                            --1394
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'SLOC_ADD_INFO'
                        ) list
                        LEFT JOIN ( SELECT ASIS_PLANT, ASIS_STORAGE
                                         , TOBE_PLANT, TOBE_STORAGE
                                         , DESC01, DESC02, DESC03
                                         , ETC1, ETC2
                                      from #TMP_STORAGE_RANK
                                      WHERE RANK_STORAGE = 1
                                      ) NST1
                                      ON list.SEGMENT1 = NST1.ASIS_PLANT
                                     AND list.SEGMENT2 = NST1.ASIS_STORAGE
                            WHERE NST1.TOBE_PLANT != SEGMENT1 OR NST1.TOBE_STORAGE != SEGMENT2
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = '@CREATED_BY'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT4=WERKS_D,SEGMENT3=LGORT_D';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT4=PLANT_ID,SEGMENT3=STORAGE_ID';

                    --24
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                               ,SEGMENT1
                               ,SEGMENT2
                               ,ISNULL(TOBE_STORAGE, SEGMENT3) AS SEGMENT3
                               ,ISNULL(TOBE_PLANT, SEGMENT4)  AS SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,DESCRIPTION
                                --,NMX.COMMENT
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            -- 77
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'WIP_MES_MAP_SLOC'
                        ) list
                        LEFT JOIN ( SELECT ASIS_PLANT, ASIS_STORAGE
                                         , TOBE_PLANT, TOBE_STORAGE
                                         , DESC01, DESC02, DESC03
                                         , ETC1, ETC2
                                      from #TMP_STORAGE_RANK
                                      WHERE RANK_STORAGE = 1
                                      ) NST1
                                      ON list.SEGMENT4 = NST1.ASIS_PLANT
                                     AND list.SEGMENT3 = NST1.ASIS_STORAGE

                            WHERE NST1.TOBE_PLANT != SEGMENT4 OR NST1.TOBE_STORAGE != SEGMENT3
                            --ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                    SET @MAPPING_USE = 'Y';
                    END
--
                ELSE IF @P_LOOKUP_TYPE = 'ELECTRODE_SHIP_SITE'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT1=WERKS_D,SEGMENT2=SITE';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID,SEGMENT2=SCP_SITE_ID';

                    --3
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                               , NP.NEW_VALUE1 AS SEGMENT1
                               , NS.NEW_VALUE1 AS SEGMENT2
                               ,SEGMENT3
                               ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN
                                ,DESCRIPTION
                                ,CREATED_BY
                                ,CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,@CREATED_BY AS ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'ELECTRODE_SHIP_SITE'
                            AND    valid_yn    = 'Y'
                            AND    segment3    = '*'
                        ) list
                        LEFT JOIN ( SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) NP
                                      ON list.SEGMENT1 = NP.OLD_VALUE1
                        LEFT JOIN ( SELECT old_value1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN and isnull(old_value1,'') !=isnull(NEW_value1,'') ) NS
                                      ON list.SEGMENT2 = NS.OLD_VALUE1
                        WHERE ISNULL(NP.NEW_VALUE1,'') != ''
                          --2025-03-08 NULL 발생하여 제외처리
                          AND ISNULL(NS.NEW_VALUE1,'') != ''
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --2025-05-15 VALID_YN = 'N' 처리
                    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                       SET ATTRIBUTE14 = @CREATED_BY
                         , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                         , VALID_YN = 'N'
                         , LAST_UPDATED_BY = @CREATED_BY
                         , LAST_UPDATE_DATE = GETDATE()
                    WHERE LOOKUP_TYPE  = 'ELECTRODE_SHIP_SITE'
                      and isnull(ATTRIBUTE14,'') != @CREATED_BY
                      AND VALID_YN    = 'Y'
                      AND SEGMENT3    = '*'
                      and SEGMENT1 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)

                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'NERP_ROLLIN_PLANT'
                    BEGIN

                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=PLANT_ID';

                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    (
                    LOOKUP_TYPE, SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5, DISPLAY_SEQ, VALID_YN
                   ,CREATED_BY, CREATION_DATE,LAST_UPDATED_BY,LAST_UPDATE_DATE
                    )
                    SELECT *
                    FROM (
                        -- 17건
                        SELECT  'NERP_ROLLIN_PLANT' AS LOOKUP_TYPE
                               ,NEW_VALUE1 AS SEGMENT1
                               ,OLD_VALUE1 AS SEGMENT2
                               ,'-' AS SEGMENT3
                               ,'-' AS SEGMENT4
                                ,'-' AS SEGMENT5
                                ,1 AS DISPLAY_SEQ
                                ,'Y' AS VALID_YN
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                        FROM NERP_CONV_MASTER_CFM_V
                         WHERE CODETYPE =  'PLANT_ID'
                         and ATTRIBUTE5 = @P_ROLLIN
                         --ORDER BY OLD_VALUE1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                     SET @MAPPING_USE = 'Y';
                END


                --## Group = Common ###############################################################################
                ELSE IF @P_LOOKUP_TYPE = 'COMPANY_DESC'
                    BEGIN


                    SET @MAPPING_COLUMN = 'SEGMENT4=WERKS_D,SEGMENT3=LGORT_D';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=COMPANY_ID';

                    --2
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,isnull(NP1.TOBE_COMPANY, SEGMENT1) AS SEGMENT1
                            , REPLACE(SEGMENT2, N'구) ','') AS SEGMENT2
                            , REPLACE(SEGMENT3, N'BEFORE) ','') AS SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,VALID_YN,DESCRIPTION
                            ,@CREATED_BY as CREATED_BY
                            , GETDATE() AS CREATION_DATE
                            ,@CREATED_BY as LAST_UPDATED_BY
                            , GETDATE() AS LAST_UPDATE_DATE

                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                            FROM
                            (
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'COMPANY_DESC'
                                and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)
                                and valid_yn = 'Y'
                            ) list
                            LEFT JOIN (SELECT ASIS_COMPANY, TOBE_COMPANY FROM #TMP_COMPANY ) NP1 ON list.SEGMENT1 = NP1.ASIS_COMPANY
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    -- 2
                    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                       SET SEGMENT2 = CONCAT(N'구) ',SEGMENT2 )
                          ,SEGMENT3 = CONCAT(N'BEFORE) ',SEGMENT3 )
                         , LAST_UPDATED_BY = @CREATED_BY
                         , LAST_UPDATE_DATE = getdate()
                       --, VALID_YN = 'N'   -- TODO 구코드 사용여부 다시 체크 할 것
                    WHERE LOOKUP_TYPE  = 'COMPANY_DESC'
                      and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    SET @MAPPING_USE = 'Y';
                    END


                -- VALID_YN = Y 1건도 없음
                -- 일단 Conv 진행
                ELSE IF @P_LOOKUP_TYPE = 'EXFACTORY_INTRANSIT_TARGET'
                    BEGIN



                    SET @MAPPING_COLUMN = 'SEGMENT1=WERKS_D';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=COMPANY_ID';

                    --2
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,isnull(NP1.TOBE_COMPANY, SEGMENT1) AS SEGMENT1
                            , REPLACE(SEGMENT2, N'구) ','') AS SEGMENT2
                            , REPLACE(SEGMENT3, N'BEFORE) ','') AS SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,VALID_YN,DESCRIPTION
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE

                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13
                            ,@CREATED_BY AS ATTRIBUTE14
                            ,CONVERT(nvarchar(10), GETDATE(), 112) AS ATTRIBUTE15
                            FROM
                            (
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'EXFACTORY_INTRANSIT_TARGET'
                                and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)
                            ) list
                            LEFT JOIN (SELECT ASIS_COMPANY, TOBE_COMPANY FROM #TMP_COMPANY ) NP1 ON list.SEGMENT1 = NP1.ASIS_COMPANY
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    -- 1
                    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                       SET ATTRIBUTE14 = 'NERP_SCP_UPDATE'
                         , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                       --, VALID_YN = 'N'   -- TODO 구코드 사용여부 다시 체크 할 것
                          --,SEGMENT2 = CONCAT(N'구) ',SEGMENT2 )
                          --,SEGMENT3 = CONCAT(N'BEFORE) ',SEGMENT3 )
                         ,LAST_UPDATED_BY = @CREATED_BY
                         ,LAST_UPDATE_DATE = GETDATE()
                    WHERE LOOKUP_TYPE  = 'EXFACTORY_INTRANSIT_TARGET'
                      and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'LOGISTICS_VISIBILITY_TRANS_MODE'
                    BEGIN



                    SET @MAPPING_COLUMN = 'SEGMENT2=SCP_SITE_ID';

                    --2
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,SEGMENT1
                            ,isnull(NP1.NEW_VALUE1, SEGMENT2) AS SEGMENT2
                            , SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,VALID_YN,DESCRIPTION
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE

                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13
                            ,@CREATED_BY AS ATTRIBUTE14
                            ,CONVERT(nvarchar(10), GETDATE(), 112) AS ATTRIBUTE15
                            FROM
                            (
                                -- 20
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'LOGISTICS_VISIBILITY_TRANS_MODE'
                                and SEGMENT2 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN)
                                and valid_yn = 'Y'
                            ) list
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP1 ON list.SEGMENT2 = NP1.OLD_VALUE1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5


                        -- 신코드 있는 구코드 valid = N 처리
                        -- 20
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                           SET ATTRIBUTE14 = 'NERP_SCP_UPDATE'
                             , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                             , VALID_YN = 'N'   -- TODO 구코드 사용여부 다시 체크 할 것
                             ,LAST_UPDATED_BY = @CREATED_BY
                             ,LAST_UPDATE_DATE = GETDATE()
                        WHERE LOOKUP_TYPE  = 'LOGISTICS_VISIBILITY_TRANS_MODE'
                          and isnull(ATTRIBUTE14,'') != @CREATED_BY
                          and SEGMENT2 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    SET @MAPPING_USE = 'Y';
                    END


                -- valid = Y 0건
                -- 우선 conv 진행
                ELSE IF @P_LOOKUP_TYPE = 'PACKER_SCS'
                    BEGIN

                    SET @MAPPING_COLUMN = 'SEGMENT2_BODY=VENDOR_ID';

                    IF OBJECT_ID('tempdb..#TMP_PACKER_SCS') IS NOT NULL
                    BEGIN
                    DROP TABLE #TMP_PACKER_SCS
                    END


                    select *
                         , CASE WHEN charindex( '-', SEGMENT2) > 0 AND charindex( '_', SEGMENT2) > 0 and charindex( '-', SEGMENT2) > charindex( '_', SEGMENT2) THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'_')
                            WHEN charindex( '-', SEGMENT2) > 0 AND charindex( '_', SEGMENT2) > 0 and charindex( '-', SEGMENT2) < charindex( '_', SEGMENT2) THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'-')
                            WHEN charindex( '-', SEGMENT2) > 0 THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'-')
                            WHEN charindex( '_', SEGMENT2) > 0 THEN dbo.FN_SCM_SPLIT(SEGMENT2,0,'_')
                            ELSE SEGMENT2
                            END as SEGMENT2_BODY
                        INTO #TMP_PACKER_SCS
                    from SCM_ADM_LOOKUP_MASTER_DETAIL
                    where LOOKUP_TYPE = 'PACKER_SCS'


                    --5
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,SEGMENT1
                            ,replace(SEGMENT2, SEGMENT2_BODY, NP1.NEW_VALUE1) AS SEGMENT2
                            , SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,  VALID_YN,DESCRIPTION
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE

                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12
                            ,segment2 AS ATTRIBUTE13
                            ,@CREATED_BY AS ATTRIBUTE14
                            ,CONVERT(nvarchar(10), GETDATE(), 112) AS ATTRIBUTE15
                            FROM
                            (
                                    -- 5건
                                    SELECT *
                                    FROM #TMP_PACKER_SCS
                                    where SEGMENT2_BODY in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = @P_ROLLIN)

                            ) list
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'VENDOR_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP1 ON list.SEGMENT2_BODY = NP1.OLD_VALUE1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5


                        -- 신코드 있는 구코드 valid = N 처리
                        -- 5
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                           SET ATTRIBUTE14 = 'NERP_SCP_UPDATE'
                             , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                             , VALID_YN = 'N'   -- TODO 구코드 사용여부 다시 체크 할 것
                             ,LAST_UPDATED_BY = @CREATED_BY
                             ,LAST_UPDATE_DATE = GETDATE()
                        WHERE LOOKUP_TYPE  = 'PACKER_SCS'
                          and isnull(ATTRIBUTE14,'') != @CREATED_BY
                          and SEGMENT2 in (SELECT SEGMENT2 from #TMP_PACKER_SCS)

                    SET @MAPPING_USE = 'Y';
                    END


                -- 3건 conv 대상 없음 0건?
                ELSE IF @P_LOOKUP_TYPE = 'SALES_PLANT'
                    BEGIN


                    SET @MAPPING_COLUMN = 'SEGMENT1=COMPANY_ID';

                    --0
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,ISNULL(NP1.new_value1, SEGMENT1) AS SEGMENT1
                            ,SEGMENT2
                            , SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,VALID_YN,DESCRIPTION
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE

                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13
                            ,@CREATED_BY AS ATTRIBUTE14
                            ,CONVERT(nvarchar(10), GETDATE(), 112) AS ATTRIBUTE15
                            FROM
                            (
                                -- 20 G260, G540, G690 Conv 대상 아님
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'SALES_PLANT'
                                and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)
                                and valid_yn = 'Y'
                            ) list
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP1 ON list.SEGMENT1 = NP1.OLD_VALUE1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5



                        -- 신코드 있는 구코드 valid = N 처리
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                           SET ATTRIBUTE14 = 'NERP_SCP_UPDATE'
                             , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                             , VALID_YN = 'N'   -- TODO 구코드 사용여부 다시 체크 할 것
                             ,LAST_UPDATED_BY = @CREATED_BY
                             ,LAST_UPDATE_DATE = GETDATE()
                        WHERE LOOKUP_TYPE  = 'SALES_PLANT'
                          and isnull(ATTRIBUTE14,'') != @CREATED_BY
                          and SEGMENT1 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    SET @MAPPING_USE = 'Y';
                    END


                -- 2건 conv 대상 없음 0건?
                ELSE IF @P_LOOKUP_TYPE = 'SCM_ITEM_TYPE_FOR_PLAN'
                    BEGIN


                    SET @MAPPING_COLUMN = 'SEGMENT1=COMPANY_ID,SEGMENT3=PLANT_ID';

                    --0
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,ISNULL(NP1.new_value1, SEGMENT1) AS SEGMENT1
                            ,SEGMENT2
                            ,ISNULL(NP2.new_value1, SEGMENT3) AS SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,VALID_YN,DESCRIPTION
                             , CREATED_BY
                             , CREATION_DATE
                             , @CREATED_BY AS LAST_UPDATED_BY
                             , GETDATE() AS LAST_UPDATE_DATE
                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13
                            ,@CREATED_BY AS ATTRIBUTE14
                            ,CONVERT(nvarchar(10), GETDATE(), 112) AS ATTRIBUTE15
                            FROM
                            (
                                -- 20  G820, G870 Conv 대상 아님
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'SCM_ITEM_TYPE_FOR_PLAN'
                                and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)
                                and valid_yn = 'Y'
                                union
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'SCM_ITEM_TYPE_FOR_PLAN'
                                and SEGMENT3 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN)
                                and valid_yn = 'Y'
                            ) list
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP1 ON list.SEGMENT1 = NP1.OLD_VALUE1
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP2 ON list.SEGMENT3 = NP1.OLD_VALUE1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --2025-05-15 VALID_YN = 'N' 처리
                    -- TODO CONV 대상 없음 추후 작업 진행
                    UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                       SET ATTRIBUTE14 = @CREATED_BY
                         , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                         , VALID_YN = 'N'
                         , LAST_UPDATED_BY = @CREATED_BY
                         , LAST_UPDATE_DATE = GETDATE()
                    WHERE LOOKUP_TYPE  = 'SCM_ITEM_TYPE_FOR_PLAN'
                      and isnull(ATTRIBUTE14,'') != @CREATED_BY
                      and SEGMENT1 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    SET @MAPPING_USE = 'Y';
                    END

                ELSE IF @P_LOOKUP_TYPE = 'VMI_SCM_SITE'
                    BEGIN



                    SET @MAPPING_COLUMN = 'SEGMENT1=CUSTOMER';
                    -- 2025-04-02 김준규
                    SET @MAPPING_COLUMN = 'SEGMENT1=END_CUSTOMER_ID';

                    --2
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        select
                             LOOKUP_TYPE
                            ,isnull(NP1.NEW_VALUE1, SEGMENT1) AS SEGMENT1
                            ,SEGMENT2
                            , SEGMENT3
                            , SEGMENT4
                            , SEGMENT5
                            , DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                            ,VALID_YN,DESCRIPTION
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE

                            ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                            ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                            ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13
                            ,@CREATED_BY AS ATTRIBUTE14
                            ,CONVERT(nvarchar(10), GETDATE(), 112) AS ATTRIBUTE15
                            FROM
                            (
                                -- 9
                                select *
                                from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                                where lookup_type = 'VMI_SCM_SITE'
                                and SEGMENT1 in (SELECT OLD_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'END_CUSTOMER_ID' and ATTRIBUTE5 = @P_ROLLIN)
                                and valid_yn = 'Y'
                            ) list
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'END_CUSTOMER_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP1 ON list.SEGMENT1 = NP1.OLD_VALUE1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5




                        -- END_CUSTOMER_ID 는 구코드/신코드 모두 필요
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --   SET ATTRIBUTE14 = 'NERP_SCP_UPDATE'
                        --   , ATTRIBUTE15 =  CONVERT(nvarchar(10), GETDATE(), 112)
                        --    , VALID_YN = 'N'   -- TODO 구코드 사용여부 다시 체크 할 것
                           --,LAST_UPDATED_BY = @CREATED_BY
                           --,LAST_UPDATE_DATE = GETDATE()
                        --WHERE LOOKUP_TYPE  = 'VMI_SCM_SITE'
                        --  and isnull(ATTRIBUTE14,'') != @CREATED_BY
                        --  and SEGMENT2 in (SELECT OLD_VALUE1 from NERP_CONV_MASTER_CFM_V where codetype = 'SCP_SITE_ID' and ATTRIBUTE5 = @P_ROLLIN)


                    SET @MAPPING_USE = 'Y';
                    END

                --2025-04-16 신규 3개 추가.
                ELSE IF @P_LOOKUP_TYPE = 'EE_ASSY_PLANT_MAPPING'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT2=PLANT_ID,SEGMENT4=PLANT_ID';

                    -- 18
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,isnull(NP1.TOBE_PLANT, SEGMENT2) AS SEGMENT2
                                ,SEGMENT3
                                ,isnull(NP2.TOBE_PLANT, SEGMENT4) AS SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'EE_ASSY_PLANT_MAPPING'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT2 = NP1.ASIS_PLANT
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP2 ON list.SEGMENT4 = NP2.ASIS_PLANT
                        WHERE NP1.TOBE_PLANT != list.SEGMENT2  OR NP2.TOBE_PLANT != list.SEGMENT4
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                    --2025-05-15 김준규 EE_***  Lookup 은 신규 추가만 수행, 기존 정보는 유지(전극 Plan 결과 조회 조건용 정보 설정임, 과정 정보 Conversion 완료 후 N 처리)
                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='PLANT_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    and ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
                        --and SEGMENT1 = 'SCP'
                        --and A.SEGMENT2  = B.OLD_VALUE1
                        --AND CREATED_BY != @CREATED_BY;

                        --UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        --SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                        --   ,LAST_UPDATED_BY = @CREATED_BY
                        --   ,LAST_UPDATE_DATE = GETDATE()
                        --FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        --(   select OLD_VALUE1, NEW_VALUE1
                        --    from NERP_CONV_MASTER_CFM_V
                        --    where codetype='PLANT_ID'
                        --    and OLD_VALUE1 != NEW_VALUE1
                        --    and ATTRIBUTE5 = @P_ROLLIN
                        --) AS B
                        --WHERE   1 =1
                        --and LOOKUP_TYPE = 'EE_SHIPMENT_PLAN_FG'
                        --and SEGMENT1 = 'SCP'
                        --and A.SEGMENT4  = B.OLD_VALUE1
                        --AND CREATED_BY != @CREATED_BY

                    SET @MAPPING_USE = 'Y';
                    END

                --2025-04-16 신규 3개 추가.
                ELSE IF @P_LOOKUP_TYPE = 'ESST_DIV_SITE_CHANGE'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT4=PLANT_ID';

                    -- 18
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                ,SEGMENT3
                                ,isnull(NP1.TOBE_PLANT, SEGMENT4) AS SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'ESST_DIV_SITE_CHANGE'
                        ) list
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP1 ON list.SEGMENT4 = NP1.ASIS_PLANT
                        WHERE NP1.TOBE_PLANT != list.SEGMENT4
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                        FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        (   select OLD_VALUE1, NEW_VALUE1
                            from NERP_CONV_MASTER_CFM_V
                            where codetype='PLANT_ID'
                            and OLD_VALUE1 != NEW_VALUE1
                            and ATTRIBUTE5 = @P_ROLLIN
                        ) AS B
                        WHERE   1 =1
                        and LOOKUP_TYPE = 'ESST_DIV_SITE_CHANGE'
                        and A.SEGMENT4  = B.OLD_VALUE1
                        AND CREATED_BY != @CREATED_BY;

                    SET @MAPPING_USE = 'Y';
                    END

                --2025-04-16 신규 3개 추가.
                ELSE IF @P_LOOKUP_TYPE = 'SCP_OPT_ENG_MODEL_TEMP'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT2=SCP_SITE_ID,ATTRIBUTE2=PLANT_ID';

                    -- 18
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,isnull(NP1.TOBE_SCM_SITE_ID, SEGMENT2) AS SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,isnull(NP2.TOBE_PLANT, ATTRIBUTE2) AS ATTRIBUTE2
                                ,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'SCP_OPT_ENG_MODEL_TEMP'
                        ) list
                        LEFT JOIN (SELECT ASIS_SCM_SITE_ID, TOBE_SCM_SITE_ID FROM #TMP_SCM_SITE_ID ) NP1 ON list.SEGMENT2 = NP1.ASIS_SCM_SITE_ID
                        LEFT JOIN (SELECT ASIS_PLANT, TOBE_PLANT FROM #TMP_PLANT ) NP2 ON list.ATTRIBUTE2 = NP2.ASIS_PLANT
                        WHERE NP1.TOBE_SCM_SITE_ID != list.SEGMENT2  OR NP2.TOBE_PLANT != list.ATTRIBUTE2
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                        FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        (   select OLD_VALUE1, NEW_VALUE1
                            from NERP_CONV_MASTER_CFM_V
                            where codetype='SCP_SITE_ID'
                            and OLD_VALUE1 != NEW_VALUE1
                            and ATTRIBUTE5 = @P_ROLLIN
                        ) AS B
                        WHERE   1 =1
                        and LOOKUP_TYPE = 'SCP_OPT_ENG_MODEL_TEMP'
                        and A.SEGMENT2  = B.OLD_VALUE1
                        AND CREATED_BY != @CREATED_BY;

                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                        FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        (   select OLD_VALUE1, NEW_VALUE1
                            from NERP_CONV_MASTER_CFM_V
                            where codetype='PLANT_ID'
                            and OLD_VALUE1 != NEW_VALUE1
                            and ATTRIBUTE5 = @P_ROLLIN
                        ) AS B
                        WHERE   1 =1
                        and LOOKUP_TYPE = 'SCP_OPT_ENG_MODEL_TEMP'
                        and A.ATTRIBUTE2  = B.OLD_VALUE1
                        AND CREATED_BY != @CREATED_BY

                    SET @MAPPING_USE = 'Y';
                    END

                --2025-08-04 신규 2개 추가.
                ELSE IF @P_LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT1=SCP_SITE_ID';

                    -- 18
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,isnull(NP1.TOBE_SCM_SITE_ID, SEGMENT1) AS SEGMENT1
                                ,SEGMENT2
                                ,SEGMENT3
                                ,SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            from SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'CELL_TRAY_SIMULATION_SITE'
                            and   valid_yn = 'Y'
                        ) list
                        LEFT JOIN (SELECT ASIS_SCM_SITE_ID, TOBE_SCM_SITE_ID FROM #TMP_SCM_SITE_ID ) NP1 ON list.SEGMENT1 = NP1.ASIS_SCM_SITE_ID
                        WHERE NP1.TOBE_SCM_SITE_ID != list.SEGMENT1
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                        FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        (   select OLD_VALUE1, NEW_VALUE1
                            from NERP_CONV_MASTER_CFM_V
                            where codetype='SCP_SITE_ID'
                            and OLD_VALUE1 != NEW_VALUE1
                            and ATTRIBUTE5 = @P_ROLLIN
                        ) AS B
                        WHERE   1 =1
                        and LOOKUP_TYPE = 'CELL_TRAY_SIMULATION_SITE'
                        and A.SEGMENT1  = B.OLD_VALUE1
			            and A.valid_yn = 'Y'
                        AND CREATED_BY != @CREATED_BY;

                    SET @MAPPING_USE = 'Y';
                    END

                --2025-08-04 신규 2개 추가.
                ELSE IF @P_LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE'
                    BEGIN
                    SET @MAPPING_COLUMN = 'SEGMENT4=COMPANY_ID';

                    -- 18
                    INSERT INTO SCM_ADM_LOOKUP_MASTER_DETAIL
                    SELECT *
                    FROM (
                        SELECT  LOOKUP_TYPE
                                ,SEGMENT1
                                ,SEGMENT2
                                ,SEGMENT3
                                ,isnull(NP1.NEW_VALUE1, SEGMENT4) AS SEGMENT4
                                ,SEGMENT5
                                ,DISPLAY_SEQ + 1000 AS DISPLAY_SEQ
                                ,VALID_YN,DESCRIPTION
                                ,@CREATED_BY as CREATED_BY
                                , GETDATE() AS CREATION_DATE
                                ,@CREATED_BY as LAST_UPDATED_BY
                                , GETDATE() AS LAST_UPDATE_DATE
                                ,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5
                                ,ATTRIBUTE6,ATTRIBUTE7,ATTRIBUTE8,ATTRIBUTE9,ATTRIBUTE10
                                ,ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                        FROM
                        (
                            select *
                            FROM  SCM_ADM_LOOKUP_MASTER_DETAIL LD WITH (NOLOCK)
                            where lookup_type = 'SCM_LGTM_INV_COMPANY_RELOCATE'
                            and   valid_yn = 'Y'
                        ) list
                            LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1  from NERP_CONV_MASTER_CFM_V where codetype = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN ) NP1 
			    ON list.SEGMENT4 = NP1.OLD_VALUE1
			    WHERE list.SEGMENT4 <> isnull(NP1.NEW_VALUE1, SEGMENT4)
                    ) X
                    WHERE 1=1
                    AND NOT EXISTS (SELECT 1
                                    FROM   SCM_ADM_LOOKUP_MASTER_DETAIL MD  WITH (NOLOCK)
                                    WHERE  MD.LOOKUP_TYPE  = X.LOOKUP_TYPE
                                    AND    MD.SEGMENT1     = X.SEGMENT1
                                    AND    MD.SEGMENT2     = X.SEGMENT2
                                    AND    MD.SEGMENT3     = X.SEGMENT3
                                    AND    MD.SEGMENT4     = X.SEGMENT4
                                    AND    MD.SEGMENT5     = X.SEGMENT5
                                    )
                    ORDER BY SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4, SEGMENT5

                    --###########################################################################
                    --20241031 신코드 입력 후 구코드 삭제 or valid = N 처리 필요
                    --###########################################################################
                        UPDATE SCM_ADM_LOOKUP_MASTER_DETAIL
                        SET SCM_ADM_LOOKUP_MASTER_DETAIL.VALID_YN  = 'N'
                           ,LAST_UPDATED_BY = @CREATED_BY
                           ,LAST_UPDATE_DATE = GETDATE()
                        FROM .SCM_ADM_LOOKUP_MASTER_DETAIL AS A,
                        (   select OLD_VALUE1, NEW_VALUE1
                            from NERP_CONV_MASTER_CFM_V
                            where codetype='COMPANY_ID'
                            and OLD_VALUE1 != NEW_VALUE1
                            and ATTRIBUTE5 = @P_ROLLIN
                        ) AS B
                        WHERE   1 =1
                        and LOOKUP_TYPE = 'SCM_LGTM_INV_COMPANY_RELOCATE'
                        and A.SEGMENT4  = B.OLD_VALUE1
			            and A.valid_yn = 'Y'
                        AND CREATED_BY != @CREATED_BY;

                    SET @MAPPING_USE = 'Y';
                    END



        --################################################################
        -- Log
        --################################################################
            SET @END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            SET @RUN_TIME = DATEDIFF(SECOND, @START_TIME, @END_TIME)
            SET @DUMMY = N'END -->> '+concat(

            N'     @CNT = ' , @CNT
            , N' , @LOOKUP_TYPE = ', @LOOKUP_TYPE
            , N' , @START_TIME = ' , @START_TIME
            , N' , @END_TIME = '   , @END_TIME
            , N' , @RUN_TIME = '   , @RUN_TIME
            );

            PRINT @DUMMY
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @RUN_TIME, @LOOKUP_TYPE,  @v_description, @d_event_date;



        --################################################################
        -- 결과 업데이트
        --################################################################
        IF  @MAPPING_USE = 'Y'
        BEGIN
          print @LOOKUP_TYPE
          UPDATE ZNERP_DEV_ITEM_SCHEDULE
          SET status = 'FINISH'
             , MAPPING_START = @START_TIME
             , MAPPING_END = @END_TIME
             , MAPPING_TIME = @RUN_TIME
             , MAPPING_COLUMN = @MAPPING_COLUMN
             where  dev_type = 'Batch_LOOKUP'
               and mapping_use = 'Y'
               and DEV_DETAIL = @LOOKUP_TYPE
        END


        --COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            --ROLLBACK TRANSACTION;
            SET @CNT = @@ROWCOUNT;
            SET @WORK_SECOND = ERROR_NUMBER();
            SET @DUMMY = @DUMMY+','+ERROR_MESSAGE();
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY, @d_event_date;
            PRINT 'ERROR'
            PRINT ERROR_MESSAGE();
    END CATCH


        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME, @LOOKUP_TYPE ;

        END
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;



        --###############################################################################################
        -- FINISH
        --###############################################################################################
        SET @CNT = @@ROWCOUNT;
        SET @BATCH_END_TIME = SYSDATETIME();
        SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
        PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
        SET @DUMMY = 'END,'+@v_description+', RUN_TIME ';
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, 'RUN_TIME',  @DUMMY, @BATCH_END_TIME;

END TRY
BEGIN CATCH
        print ERROR_MESSAGE()
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;


        SET @CNT = @@ROWCOUNT;
        SET @RUN_TIME = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        PRINT @v_description;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @RUN_TIME, @v_description, @d_event_date;
END CATCH

END
