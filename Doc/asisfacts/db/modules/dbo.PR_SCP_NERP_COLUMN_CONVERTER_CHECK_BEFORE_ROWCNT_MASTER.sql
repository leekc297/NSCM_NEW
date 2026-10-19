
-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER
-- Author:       김준규
-- Create date:  2025-03-17
-- Description:  NERP) 컨버전 이전 변경대상 컬럼 레코드 수량 확인
-- How to Execute: EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='',@P_ROLLIN='1ST',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='LOOKUP',@P_ROLLIN='1ST',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='LOOKUP',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='EE_ASSY_PLANT_MAPPING',@P_RTYPE='',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='MASTER',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='SCP_ANL_LONG_TERM_STOCK',@P_RTYPE='',@P_ROLLIN='3RD',@P_Matched='N',@P_UseProd='N'; --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='TABLES',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='STORAGE',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='DUPLICATION',@P_ROLLIN='2ND',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
--    EXEC PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER @P_TABLE='',@P_RTYPE='OPMZ_LOOKUP',@P_ROLLIN='3RD',@P_Matched='N',@P_UseProd='Y' --P_Matched N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회 @P_UseProd N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
-- 처리된 것은 NERP_CONV_CMP_SCP 테이블에 누적 저장됨
-- ==========================================================================================
-- 2025-03-24       김준규       NERP) 컨버전 이전 변경대상 컬럼 레코드 수량 확인
-- 2025-04-09       김준규       NERP) IDENTITY_ID 가져오는 부분 MAX에서 SCOPE_IDENTITY()로 변경
-- 2025-04-14       김준규       NERP) 합쳐지는(MERGE) PLANT 코드를 CTE로 만들어 LIKE로 처리
-- 2025-04-15       김준규       NERP) NERP_CONV_LOOKUP_COMPARE 테이블 변경
-- 2025-04-16       김준규       NERP) 코드 합쳐지는 것 중 실제 합쳐지는 CODETYPE만 적용(속도개선:VENDOR_ID,CUSTOEMR_ID)
-- 2025-04-18       김준규       VALUATION_CLASS RULL BASE가 아닌 HARD CORDING 되어 있어서 비교프로그램에서 제외 처리함.
-- 2025-04-21       김준규       NERP) ZNERP_DEV_ITEM_SCHEDULE테이블에 SCM_MST_SITE_ITEM 컬럼 중복 1개 추가
--                                    기존 : dev_detail:SCM_SITE_ID,mapping_column:SCM_SITE_ID
--                                    추가 : dev_detail:SCM_SITE_ID,mapping_column:PLANT_ID
-- 2025-04-21       김준규       NERP) SCM_MST_SITE_ENG,SCM_MST_SITE_ITEM_ENG 테이블 LIKE 처리 추가
-- 2025-04-21       김준규       NERP) ZNERP_DEV_ITEM_SCHEDULE테이블에 SCM_MST_VENDOR 컬럼 중복 1개 추가
--                                    기존 : dev_detail:AFFILIATE_CODE,mapping_column:VENDOR_ID
--                                    추가 : dev_detail:AFFILIATE_CODE,mapping_column:COMPANY_ID
--                                    추가 : dev_detail:AFFILIATE_CODE,mapping_column:PLANT_ID
-- 2025-04-21       김준규       NERP) STORAGE_ID 체크 보완(PLANT_ID가 사용가능한 것 추가) STORAGE_ID생성 시 PLANT_ID OK, 현재 NOT OK
-- 2025-04-22       김준규       NERP) SCM_MST 테이블 차이나는 것 LIKE 처리 추가()
-- 2025-04-22       김준규       NERP) WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') 인경우 LIKE아닌 =(EQUAL) 조인처리
-- 2025-04-23       김준규       NERP) 컬럼11개까지 정의해 놓아서 MAPPING_COLUMN != 'INCOTERMS' 제외처리함
-- 2025-05-12       김준규       NERP) sys.columns c 테이블에 c.name = 'VALID_YN' 을 가지고 있으면 VALID_YN = Y 인 것만 대상으로 처리
-- 2025-05-14       김준규       NERP) 속도 문제로 NERP_CONV_LOOKUP_COMPARE -> NERP_CONV_CMP_SCP 테이블 변경(콰거 4월 14일자로 재작업)
-- 2025-05-14       김준규       NERP) NERP_CONV_MASTER_CFM_V 테이블로 변경
-- 2025-05-17       김준규       NERP) PERFORMANCE 속도개선위해 변경되는 것만 그리고 토탈만 카운트 및 계산 대폭변경
-- 2025-06-03       김준규       NERP) @P_TABLE 추가(테이블 명 또는 룩업타입 입력)
-- 2025-06-03       김준규       NERP) @P_Matched  N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회
-- 2025-06-03       김준규       NERP) @P_UseProd  N: 현재 DB사용, Y: LINKED_SERVER 운영환경 사용
-- 2025-06-05       김준규       NERP) 컬럼하나에 MASTER_CODETYPE 2개이상인 것 STRING_AGG로 IN 으로 변경
-- 2025-06-05       김준규       NERP) LIKE 처리하는 것 HARD CORDING을 TABLE로 변경 (NERP_CONV_SCP_TBL_NM_V)
-- 2025-08-31       김준규       NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임.
-- 2025-09-12       김준규       NERP) 최적화 룩업 SCP_OPMZ_LOOKUP_MASTER_DETAIL 추가
-- 2025-09-17       김준규       NERP) VALUATION_CLASS RULL BASE가 아닌 HARD CORDING 되어 있어서 비교프로그램에서 제외 처리함. 오류로 보완
-- 2025-09-18       김준규       NERP) @P_UseProd 운영에 DIRECT로 붙여서 작업시 10..34..220..85,,7433로 하면 Could not locate statistics '_WA_Sys_0000001D_7118BB8A' in the system catalogs. 오류로 10..34..220..88,7433 변경
-- 2025-09-26       김준규       NERP) 김춘동 책임님 요청으로 최적화는 모든 VALID_YN 무시하고 모두 작업
---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER]
    @P_TABLE     nvarchar(128) = ''
   ,@P_RTYPE     nvarchar(30)
   ,@P_ROLLIN    nvarchar(30) --1ST 2ND 3RD 4TH
   ,@P_Matched   nvarchar(30) ='N'-- N: 조인되지 않은 값도 포함, Y: 조인된 값만 조회
   ,@P_UseProd   nvarchar(30) ='N'-- N: 현재 QA DB사용, Y: LINKED_SERVER 운영환경 사용
AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;

    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
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
    DECLARE @V_ROWCOUNT BIGINT;
    DECLARE @OnlyMatched BIT;
    DECLARE @DBPrefix NVARCHAR(254);
    SET @OnlyMatched = CASE WHEN ISNULL(@P_Matched, 'N') = 'Y' THEN 1 ELSE 0 END; -- 0: 조인되지 않은 값도 포함, 1: 조인된 값만 조회
    SET @DBPrefix = CASE WHEN ISNULL(@P_UseProd, 'N') = 'Y' THEN '[DBO].' ELSE '[DBO].' END; -- Y: LINKED_SERVER 운영DB 사용, N: 현재 QA DB사용

    SET @CNT = 0;
    SET @RUN_TIME = 0;


    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_CHECK_BEFORE_ROWCNT_MASTER';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;


    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    DECLARE @BATCH_ID BIGINT;
    SET @BATCH_ID = NEXT VALUE FOR [dbo].[SEQ1_NERP_CONV_ALL_TABLE];
    SET @v_description = '@P_RTYPE:'+@P_RTYPE+',@P_ROLLIN:'+@P_ROLLIN+',@BATCH_ID:'+CONVERT(NVARCHAR(MAX),@BATCH_ID)+',@P_Matched:'+@P_Matched+',@P_UseProd:'+@P_UseProd;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, '0',@v_description, @START_TIME;

BEGIN TRY

    DECLARE @C_MAPPING_USE NVARCHAR(2)
    DECLARE @C_TABLE_NAME  NVARCHAR(128)
    DECLARE @C_DUMMY_TBL_NM NVARCHAR(128)
    DECLARE @C_DISP_TBL_NM NVARCHAR(128)
    DECLARE @C_COPYED_TBL_NM NVARCHAR(128) = '';
    DECLARE @C_PRINT_YN    BIT = 0; -- 1 Y, 0 N
    DECLARE @C_RTYPE       NVARCHAR(128)
    DECLARE @C_RNUM        NVARCHAR(128)
    DECLARE @C_SORT_SEQ    INT
    DECLARE @C_LOOKUP_TYPE NVARCHAR(128)
    DECLARE @C_DUMMY_LK_TYPE NVARCHAR(128)
    DECLARE @C_VALID_YN    NVARCHAR(1);
    DECLARE @C_CAL_LIKE    NVARCHAR(128)
    DECLARE @C_R_N_R       NVARCHAR(128)
    DECLARE @C_CUTOFF_COL  NVARCHAR(128)
    DECLARE @C_CUT_COL1    NVARCHAR(128)
    DECLARE @C_CUT_COL2    NVARCHAR(128)
    DECLARE @C_CUT_COL3    NVARCHAR(128)
    DECLARE @C_CUT_COL4    NVARCHAR(128)
    DECLARE @C_C_FROM      NVARCHAR(128)
    DECLARE @C_C_TO        NVARCHAR(128)
    DECLARE @C_C_DIVISION  NVARCHAR(128)
    DECLARE @C_C_PLAN_TYPE NVARCHAR(128)
    DECLARE @C_L1          NVARCHAR(128);--BEFORE
    DECLARE @C_L2          NVARCHAR(128);
    DECLARE @C_L3          NVARCHAR(128);
    DECLARE @C_L4          NVARCHAR(128);
    DECLARE @C_L5          NVARCHAR(128);
    DECLARE @C_L6          NVARCHAR(128);
    DECLARE @C_L7          NVARCHAR(128);
    DECLARE @C_L8          NVARCHAR(128);
    DECLARE @C_L9          NVARCHAR(128);
    DECLARE @C_L10         NVARCHAR(128);
    DECLARE @C_L11         NVARCHAR(128);
    DECLARE @C_L12         NVARCHAR(128);
    DECLARE @C_B1          NVARCHAR(128)--BEFORE
    DECLARE @C_B2          NVARCHAR(128)
    DECLARE @C_B3          NVARCHAR(128)
    DECLARE @C_B4          NVARCHAR(128)
    DECLARE @C_B5          NVARCHAR(128)
    DECLARE @C_B6          NVARCHAR(128)
    DECLARE @C_B7          NVARCHAR(128)
    DECLARE @C_B8          NVARCHAR(128)
    DECLARE @C_B9          NVARCHAR(128)
    DECLARE @C_B10         NVARCHAR(128)
    DECLARE @C_B11         NVARCHAR(128)
    DECLARE @C_B12         NVARCHAR(128);
    DECLARE @C_SEL_B1      NVARCHAR(128)--BEFORE
    DECLARE @C_SEL_B2      NVARCHAR(128)
    DECLARE @C_SEL_B3      NVARCHAR(128)
    DECLARE @C_SEL_B4      NVARCHAR(128)
    DECLARE @C_SEL_B5      NVARCHAR(128)
    DECLARE @C_SEL_B6      NVARCHAR(128)
    DECLARE @C_SEL_B7      NVARCHAR(128)
    DECLARE @C_SEL_B8      NVARCHAR(128)
    DECLARE @C_SEL_B9      NVARCHAR(128)
    DECLARE @C_SEL_B10     NVARCHAR(128)
    DECLARE @C_SEL_B11     NVARCHAR(128)
    DECLARE @C_SEL_B12     NVARCHAR(128);
    DECLARE @C_A1          NVARCHAR(128)--AFTER
    DECLARE @C_A2          NVARCHAR(128)
    DECLARE @C_A3          NVARCHAR(128)
    DECLARE @C_A4          NVARCHAR(128)
    DECLARE @C_A5          NVARCHAR(128)
    DECLARE @C_A6          NVARCHAR(128)
    DECLARE @C_A7          NVARCHAR(128)
    DECLARE @C_A8          NVARCHAR(128)
    DECLARE @C_A9          NVARCHAR(128)
    DECLARE @C_A10         NVARCHAR(128)
    DECLARE @C_A11         NVARCHAR(128)
    DECLARE @C_A12         NVARCHAR(128);
    DECLARE @C_V1          INT;--AFTER
    DECLARE @C_V2          INT;
    DECLARE @C_V3          INT;
    DECLARE @C_V4          INT;
    DECLARE @C_V5          INT;
    DECLARE @C_V6          INT;
    DECLARE @C_V7          INT;
    DECLARE @C_V8          INT;
    DECLARE @C_V9          INT;
    DECLARE @C_V10         INT;
    DECLARE @C_V11         INT;
    DECLARE @C_V12         INT;
    DECLARE @C_SEL_A1      NVARCHAR(128)--AFTER
    DECLARE @C_SEL_A2      NVARCHAR(128)
    DECLARE @C_SEL_A3      NVARCHAR(128)
    DECLARE @C_SEL_A4      NVARCHAR(128)
    DECLARE @C_SEL_A5      NVARCHAR(128)
    DECLARE @C_SEL_A6      NVARCHAR(128)
    DECLARE @C_SEL_A7      NVARCHAR(128)
    DECLARE @C_SEL_A8      NVARCHAR(128)
    DECLARE @C_SEL_A9      NVARCHAR(128)
    DECLARE @C_SEL_A10     NVARCHAR(128)
    DECLARE @C_SEL_A11     NVARCHAR(128)
    DECLARE @C_SEL_A12     NVARCHAR(128);
    DECLARE @C_X1          BIT;--AFTER
    DECLARE @C_X2          BIT;
    DECLARE @C_X3          BIT;
    DECLARE @C_X4          BIT;
    DECLARE @C_X5          BIT;
    DECLARE @C_X6          BIT;
    DECLARE @C_X7          BIT;
    DECLARE @C_X8          BIT;
    DECLARE @C_X9          BIT;
    DECLARE @C_X10         BIT;
    DECLARE @C_X11         BIT;
    DECLARE @C_X12         BIT;
    DECLARE @C_RN          INT;
    DECLARE @SQL_STMT      NVARCHAR(MAX);
    DECLARE @SQL_SA        NVARCHAR(MAX)='';
    DECLARE @SQL_SM        NVARCHAR(MAX)='';
    DECLARE @SQL_SW        NVARCHAR(MAX)='';
    DECLARE @SQL_ISNOTNULL NVARCHAR(MAX)='';
    DECLARE @ExecutionRST  NVARCHAR(MAX);
    DECLARE @DUMMY         NVARCHAR(MAX);
    DECLARE @crlf          CHAR(2) = CHAR(13) + CHAR(10);
    DECLARE @pos           INT;

    -- 커서가 이미 열려 있는지 확인
    IF CURSOR_STATUS('global', 'cur_CUTOFF_COL') >= 0
    BEGIN
        CLOSE cur_CUTOFF_COL;
        DEALLOCATE cur_CUTOFF_COL;
    END
    DECLARE cur_CUTOFF_COL CURSOR FAST_FORWARD READ_ONLY FOR
        select TABLE_NAME AS TABLE_NAME
             , LOOKUP_TYPE AS LOOKUP_TYPE
             , 'SCP' AS R_N_R
             , 'OPMZ_LOOKUP'   AS RTYPE
             , ROW_NUMBER()OVER(ORDER BY TABLE_NAME desc, LOOKUP_TYPE) RNUM
             , 0          AS SORT_SEQ
          from (
            select DISTINCT 'SCP_OPMZ_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
                 --, program_id AS TABLE_NAME
                 --, dev_detail AS LOOKUP_TYPE
                 , program_id AS LOOKUP_TYPE
              from ZNERP_DEV_ITEM_SCHEDULE
             where  dev_type in ( 'Batch_OPMZ_LOOKUP')
               and mapping_use = 'OM'
               --and ISNULL(status,'') != 'FINISH'
               --and dev_remark IN ('SCP', 'COMMON')
               and dev_detail != 'INCOTERMS' --> DM에서 조치 협의
               --and (@P_LOOKUP_TYPE IS NULL OR @P_LOOKUP_TYPE ='' OR program_id = @P_LOOKUP_TYPE)
               and (@P_TABLE IS NULL OR @P_TABLE = '' OR (CASE WHEN @P_TABLE = 'SCP_OPMZ_LOOKUP_MASTER_DETAIL' THEN @P_TABLE ELSE program_id END) = @P_TABLE)
               and (@P_RTYPE IS NULL OR @P_RTYPE = '' OR 'OPMZ_LOOKUP' = @P_RTYPE)
          ) DIS
        UNION ALL
        select program_id AS TABLE_NAME
             , dev_detail AS LOOKUP_TYPE
             , dev_remark AS R_N_R
             , 'LOOKUP'   AS RTYPE
             , ROW_NUMBER()OVER(ORDER BY dev_remark desc, program_id,  dev_detail) RNUM
             , 1          AS SORT_SEQ
          from ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
         where dev_type in ( 'Batch_LOOKUP')
           and mapping_use = 'Y'
          -- and ISNULL(status,'') != 'FINISH'
           and dev_remark IN ('SCP', 'COMMON')
           and dev_detail != 'INCOTERMS' --> DM에서 조치 협의
           AND MAPPING_COLUMN != 'INCOTERMS'
           and (@P_TABLE IS NULL OR @P_TABLE = '' OR (CASE WHEN @P_TABLE = 'SCM_ADM_LOOKUP_MASTER_DETAIL' THEN @P_TABLE ELSE dev_detail END) = @P_TABLE)
           and (@P_RTYPE IS NULL OR @P_RTYPE = '' OR 'LOOKUP' = @P_RTYPE)
        UNION ALL
        SELECT distinct program_id AS TABLE_NAME
             , ''         AS LOOKUP_TYPE
             , ''         AS R_N_R
             , 'MASTER'   AS RTYPE
             , DENSE_RANK()OVER(ORDER BY program_id) RNUM
             , 2          AS SORT_SEQ
          FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
         where DEV_TYPE = 'Batch_Conversion'
           AND mapping_use IN ( 'IN')
           AND MAPPING_COLUMN != 'INCOTERMS'
           AND (@P_TABLE IS NULL OR @P_TABLE = '' OR program_id = @P_TABLE)
           AND (@P_RTYPE IS NULL OR @P_RTYPE = '' OR 'MASTER' = @P_RTYPE)
        UNION ALL
        SELECT distinct program_id AS TABLE_NAME
             , ''         AS LOOKUP_TYPE
             , ''         AS R_N_R
             , 'STORAGE'  AS RTYPE
             , DENSE_RANK()OVER(ORDER BY PROD_TABLE_CNT) RNUM
             , 3          AS SORT_SEQ
        FROM   ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
        WHERE  DEV_TYPE = 'Batch_Conversion'
        AND    mapping_use IN ( 'UP', 'CA', 'OZ') --2025.08.31 김준규 NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임
        AND    MAPPING_COLUMN = 'STORAGE_ID'
        AND   (@P_TABLE IS NULL OR @P_TABLE = '' OR program_id = @P_TABLE)
        AND   (@P_RTYPE IS NULL OR @P_RTYPE = '' OR 'STORAGE' = @P_RTYPE)
        UNION ALL
        SELECT distinct program_id AS TABLE_NAME
             , ''         AS LOOKUP_TYPE
             , ''         AS R_N_R
             , 'TABLES'   AS RTYPE
             , DENSE_RANK()OVER(ORDER BY PROD_TABLE_CNT) RNUM
             , 4          AS SORT_SEQ
         FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
        where DEV_TYPE = 'Batch_Conversion'
        and mapping_use IN ( 'UP' ,'CA', 'OZ') --2025.08.31 김준규 NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임
        and mapping_column  in ('COMPANY_ID','PLANT_ID','END_CUSTOMER_ID','VENDOR_ID','SCM_SITE_ID','SCP_SITE_ID', 'SCM_SITE_DESCRIPTION', 'PACKER_CODE', 'PSI_VALUE', 'PLANT_VENDOR','PLANT_DESCRIPTION', 'WAERS','PRCTR')  -- STORAGE 별도 처리
        and dev_detail != 'INCOTERMS'
        AND MAPPING_COLUMN != 'INCOTERMS'
        AND (@P_TABLE IS NULL OR @P_TABLE = '' OR program_id = @P_TABLE)
        AND (@P_RTYPE IS NULL OR @P_RTYPE = '' OR 'TABLES' = @P_RTYPE)
        UNION ALL
        SELECT distinct program_id AS TABLE_NAME
             , ''         AS LOOKUP_TYPE
             , ''         AS R_N_R
             , 'DUPLICATION' AS RTYPE
             , DENSE_RANK()OVER(ORDER BY program_id) RNUM
             , 5          AS SORT_SEQ
         FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
        where DEV_TYPE = 'Batch_Conversion'
        AND   MAPPING_USE IN ( 'DP')
        AND   MAPPING_COLUMN != 'INCOTERMS'
        AND   (@P_TABLE IS NULL OR @P_TABLE = '' OR program_id = @P_TABLE)
        AND   (@P_RTYPE IS NULL OR @P_RTYPE = '' OR 'DUPLICATION' = @P_RTYPE)
        ORDER BY SORT_SEQ,RNUM,1,2,3

    OPEN cur_CUTOFF_COL

    FETCH NEXT FROM cur_CUTOFF_COL INTO @C_TABLE_NAME, @C_LOOKUP_TYPE, @C_R_N_R, @C_RTYPE, @C_RNUM, @C_SORT_SEQ;

    WHILE @@FETCH_STATUS = 0 BEGIN

        SET @C_DISP_TBL_NM = CASE WHEN @C_RTYPE IN ( 'LOOKUP','OPMZ_LOOKUP' ) THEN @C_LOOKUP_TYPE ELSE @C_TABLE_NAME END;
        SET @SQL_SW     = NULL;

            PRINT '------------------------------------------------------------------------------------------------------------------------------------------';
            SET @C_DISP_TBL_NM = @C_DISP_TBL_NM;
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @C_DISP_TBL_NM, 0, '0', '', @START_TIME;
            SET @DUMMY = 'RUN -->> '+concat(
            '     @CNT = ' , @CNT
            , ' , @C_DISP_TBL_NM = ', @C_DISP_TBL_NM
            , ' , @C_VALID_YN = ' , @C_VALID_YN
            , ' , @START_TIME = ' , @START_TIME
            , ' , @P_RTYPE = ' , @P_RTYPE
            , ' , @P_ROLLIN = ' , @P_ROLLIN
            , ' , @BATCH_ID = ' , @BATCH_ID
            );

            PRINT @DUMMY

        --PRINT '@C_TABLE_NAME  :'+ISNULL(@C_TABLE_NAME ,'NULL');
        --PRINT '@C_DISP_TBL_NM :'+ISNULL(@C_DISP_TBL_NM,'NULL');
        --PRINT '@C_LOOKUP_TYPE :'+ISNULL(@C_LOOKUP_TYPE,'NULL');
        --PRINT '@C_RTYPE       :'+ISNULL(@C_RTYPE      ,'NULL');

        --######################################
        -- SELECT 컬럼 사용.
        --######################################
        DECLARE @ColumnsToSelect NVARCHAR(MAX)='';

        -- 2. PK 컬럼 확인
        SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(c.name), ', ') WITHIN GROUP (ORDER BY ic.key_ordinal)
        FROM sys.tables t
        INNER JOIN sys.indexes i ON t.object_id = i.object_id
        INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
        INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
        WHERE i.is_primary_key = 1
        AND t.name = @C_TABLE_NAME
        AND SCHEMA_NAME(t.schema_id) = 'dbo';

        -- 3. PK가 없으면 전체 컬럼 사용
        IF @ColumnsToSelect IS NULL
        BEGIN
            SELECT @ColumnsToSelect = STRING_AGG('A.' + QUOTENAME(c.name), ', ') WITHIN GROUP (ORDER BY c.column_id)
            FROM sys.columns c
            JOIN sys.tables t ON c.object_id = t.object_id
            WHERE t.name = @C_TABLE_NAME
            AND SCHEMA_NAME(t.schema_id) = 'dbo';
        END

        -- 커서가 이미 열려 있는지 확인
        IF CURSOR_STATUS('global', 'cur') >= 0
        BEGIN
            CLOSE cur;
            DEALLOCATE cur;
        END
        DECLARE cur CURSOR FAST_FORWARD READ_ONLY FOR
            WITH SplitData AS (
                SELECT
                    program_id AS TABLE_NAME
                   ,dev_detail AS LOOKUP_TYPE
                   ,x.MAPPING_COLUMN
                   ,token AS Segment
                   ,ROW_NUMBER() OVER (PARTITION BY program_id,dev_detail,MAPPING_COLUMN ORDER BY (SELECT NULL)) AS rn
                FROM ZNERP_DEV_ITEM_SCHEDULE x WITH(NOLOCK)
                     CROSS APPLY STRING_SPLIT(MAPPING_COLUMN, ',')
               where dev_type in ( 'Batch_LOOKUP')
                 and mapping_use = 'Y'
                -- and ISNULL(status,'') != 'FINISH'
                 and dev_remark IN ('SCP', 'COMMON')
                 and dev_detail != 'INCOTERMS'
                 AND MAPPING_COLUMN != 'INCOTERMS'
                 AND program_id = @C_TABLE_NAME
                 AND dev_detail = @C_LOOKUP_TYPE
                 --AND 'LOOKUP'   = @C_RTYPE
            )
            --SELECT * FROM SplitData;
            ,
            KeyValueData AS (
                SELECT
                    TABLE_NAME,
                    LOOKUP_TYPE,
                    MAPPING_COLUMN,
                    TRIM(LEFT(Segment, CHARINDEX('=', Segment) - 1)) AS KeyPart,
                    TRIM(SUBSTRING(Segment, CHARINDEX('=', Segment) + 1, LEN(Segment))) AS ValuePart,
                    rn
                FROM
                    SplitData
            )
            --SELECT * FROM KeyValueData;
            , W_CONV_CODETYPE AS (
                SELECT TRIM('SCM_SITE_ID         ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('PSI_VALUE           ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('PACKER_CODE         ') AS FR, TRIM('SCP_SITE_ID         ') AS TOO UNION
                SELECT TRIM('WERKS_D             ') AS FR, TRIM('PLANT_ID            ') AS TOO UNION
                SELECT TRIM('PLANT_VENDOR        ') AS FR, TRIM('PLANT_ID            ') AS TOO UNION
                SELECT TRIM('LGORT_D             ') AS FR, TRIM('STORAGE_ID          ') AS TOO UNION
                SELECT TRIM('LIFNR               ') AS FR, TRIM('VENDOR_ID           ') AS TOO UNION
                SELECT TRIM('KUNNR               ') AS FR, TRIM('END_CUSTOMER_ID     ') AS TOO UNION
                SELECT TRIM('CUSTOMER            ') AS FR, TRIM('END_CUSTOMER_ID     ') AS TOO UNION
                SELECT TRIM('STORAGE_NAME        ') AS FR, TRIM('STORAGE_ID          ') AS TOO UNION
                SELECT TRIM('SCM_SITE_DESCRIPTION') AS FR, TRIM('SCP_SITE_DESCRIPTION') AS TOO UNION
                SELECT TRIM('PLANT_DESCRIPTION   ') AS FR, TRIM('SCP_SITE_DESCRIPTION') AS TOO
            )
            , W_CONV_LIKE_TBL AS (
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_PROBLEM_REPORT_DEMAND') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_PRODUCTION_PLAN      ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_PSI_PRODUCTION       ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_SHIPMENT_PLAN        ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_SHIPMENT_PLAN_FG     ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('EE_SHIPMENT_PLAN_SEMI   ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('ELECTRODE_LINE_WIDE_RATE') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('ELECTRODE_SLOC          ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('ESS_SHIP_PLAN_SITE      ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('INTRANSIT_TO_SITE       ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SCP_SIMULATOR_SHIP_FIXED_TERM') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SCS_ASSY_PACKER         ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SHIPMENT_REPORT_LOOKUP  ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('SITE_MAPPING            ') AS LOOKUP_TYPE UNION
                SELECT 'LOOKUP' AS RTYPE, 'SCM_ADM_LOOKUP_MASTER_DETAIL' AS TABLE_NAME,TRIM('PACKER_SCS              ') AS LOOKUP_TYPE
                UNION
                SELECT  RTYPE,TABLE_NAME,TRIM('                        ') AS LOOKUP_TYPE
                FROM    NERP_CONV_SCP_TBL_NM_V tnv WITH(NOLOCK)
                WHERE   TNV.TABLE_NAME IN (
                                            TRIM('SCM_DNM_MAT_PO        ')
                                            ,TRIM('SCM_MST_OSP_SLOC      ')
                                            ,TRIM('SCP_MST_BOD           ')
                                            ,TRIM('SCP_MST_BOD_ENG       ')
                                            ,TRIM('SCP_PLN_ALLOCATION    ')
                                            ,TRIM('SCM_MST_CUSTOMER      ')
                                            ,TRIM('SCM_MST_VENDOR        ')
                                            ,TRIM('SCM_MST_SLOC          ')
                                            ,TRIM('SCM_MST_SITE_CUSTOMER ')
                                            ,TRIM('SCM_MST_SITE_ENG      ')
                                            ,TRIM('SCM_MST_SITE_ITEM_ENG ')
                                            ,TRIM('SCM_MST_SITE_ITEM     ')
                                            )
                AND    RTYPE <> 'STORAGE'
            )
            , W_RAW AS (
                SELECT TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , STRING_AGG(MAP_COL, ', ') WITHIN GROUP (ORDER BY SEL_COL ASC) AS MAP_COL
                     , CAL_LIKE --LIKE 연산자
                     , ROW_NUMBER()OVER(PARTITION BY TABLE_NAME ORDER BY SEL_COL) RNUM
                FROM (
                    SELECT
                        KVD.TABLE_NAME,
                        KVD.LOOKUP_TYPE,
                        CASE WHEN KVD.LOOKUP_TYPE = 'PACKER_SCS' AND KeyPart = 'SEGMENT2_BODY' THEN 'SEGMENT2' ELSE KeyPart END AS SEL_COL,
                        --대체이름 설정
                        ISNULL(WCO.TOO,ValuePart) AS MAP_COL,
                        IIF(WLT.TABLE_NAME IS NOT NULL,'Y','N') AS CAL_LIKE, --LIKE 연산자
                        rn AS RNUM
                    FROM
                        KeyValueData AS KVD
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   KVD.ValuePart = WCO.FR
                    LEFT OUTER JOIN W_CONV_LIKE_TBL AS WLT
                    ON   KVD.TABLE_NAME = WLT.TABLE_NAME AND KVD.LOOKUP_TYPE = WLT.LOOKUP_TYPE AND WLT.RTYPE = 'LOOKUP'
                    WHERE 1=1
                    AND  'LOOKUP'   = @C_RTYPE
                    UNION ALL
                    select TABLE_NAME AS TABLE_NAME
                        , LOOKUP_TYPE AS LOOKUP_TYPE
                        , SEL_COL
                        , STRING_AGG(MAP_COL, ', ') WITHIN GROUP (ORDER BY SEL_COL ASC) AS MAP_COL
                        , CAL_LIKE AS CAL_LIKE --LIKE 연산자
                        , ROW_NUMBER()OVER(ORDER BY TABLE_NAME desc, LOOKUP_TYPE) RNUM
                    from (
                      select DISTINCT 'SCP_OPMZ_LOOKUP_MASTER_DETAIL' AS TABLE_NAME
                           , program_id AS LOOKUP_TYPE
                           , DEV_DETAIL AS SEL_COL
                           , MAPPING_COLUMN AS MAP_COL
			               , IIF(MAPPING_COMMENT LIKE '%REP%' OR MAPPING_COMMENT LIKE '%RPL%','Y','N') AS CAL_LIKE --LIKE 연산자
                        from ZNERP_DEV_ITEM_SCHEDULE DIS
                       where  dev_type in ( 'Batch_OPMZ_LOOKUP')
                         and mapping_use = 'OM'
                         --and ISNULL(status,'') != 'FINISH'
                         --and dev_remark IN ('SCP', 'COMMON')
                         and dev_detail != 'INCOTERMS' --> DM에서 조치 협의
                         AND 'SCP_OPMZ_LOOKUP_MASTER_DETAIL' = @C_TABLE_NAME
                         AND program_id = @C_LOOKUP_TYPE
                         AND 'OPMZ_LOOKUP'  = @C_RTYPE                         
                    ) DIS
                    GROUP BY TABLE_NAME
                       , LOOKUP_TYPE
                       , SEL_COL
		               , CAL_LIKE
                    UNION ALL
                    SELECT program_id AS TABLE_NAME
                        , ''          AS LOOKUP_TYPE
                        , dev_detail  AS SEL_COL
                        , ISNULL(WCO.TOO,MAPPING_COLUMN) AS MAP_COL
                        , IIF(WLT.TABLE_NAME IS NOT NULL,'Y','N') AS CAL_LIKE --LIKE 연산자
                        , ROW_NUMBER()OVER(ORDER BY program_id, dev_detail, MAPPING_COLUMN) RNUM
                    FROM ZNERP_DEV_ITEM_SCHEDULE AS DIS WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   DIS.MAPPING_COLUMN = WCO.FR
                    LEFT OUTER JOIN W_CONV_LIKE_TBL AS WLT
                    ON   DIS.program_id = WLT.TABLE_NAME AND WLT.RTYPE = 'MASTER'
                    where DEV_TYPE = 'Batch_Conversion'
                    and mapping_use IN ( 'IN')
                    AND MAPPING_COLUMN != 'INCOTERMS'
                    AND program_id = @C_TABLE_NAME
                    AND 'MASTER'   = @C_RTYPE
                    UNION ALL
                    SELECT program_id AS TABLE_NAME
                        , ''          AS LOOKUP_TYPE
                        , dev_detail  AS SEL_COL
                        , ISNULL(WCO.TOO,MAPPING_COLUMN) AS MAP_COL
                        , 'N'         AS CAL_LIKE --LIKE 연산자
                        , ROW_NUMBER()OVER(ORDER BY program_id, dev_detail, MAPPING_COLUMN) RNUM
                    FROM ZNERP_DEV_ITEM_SCHEDULE AS DIS WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   DIS.MAPPING_COLUMN = WCO.FR
                    where DEV_TYPE = 'Batch_Conversion'
                    and mapping_use IN ( 'UP', 'CA', 'OZ') --2025.08.31 김준규 NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임
                    and MAPPING_COLUMN = 'STORAGE_ID'
                    AND program_id = @C_TABLE_NAME
                    AND 'STORAGE'  = @C_RTYPE
                    UNION ALL
                    SELECT program_id AS TABLE_NAME
                        , ''          AS LOOKUP_TYPE
                        , dev_detail  AS SEL_COL
                        , ISNULL(WCO.TOO,MAPPING_COLUMN) AS MAP_COL
                        , 'N'         AS CAL_LIKE --LIKE 연산자
                        , ROW_NUMBER()OVER(ORDER BY program_id, dev_detail, MAPPING_COLUMN) RNUM
                    FROM ZNERP_DEV_ITEM_SCHEDULE AS DIS WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   DIS.MAPPING_COLUMN = WCO.FR
                    where DEV_TYPE = 'Batch_Conversion'
                    and mapping_use IN ( 'UP', 'CA', 'OZ') --2025.08.31 김준규 NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임
                    and mapping_column  in ('COMPANY_ID','PLANT_ID','END_CUSTOMER_ID','VENDOR_ID','SCM_SITE_ID','SCP_SITE_ID', 'SCM_SITE_DESCRIPTION', 'PACKER_CODE', 'PSI_VALUE', 'PLANT_VENDOR','PLANT_DESCRIPTION', 'WAERS','PRCTR')  -- STORAGE 별도 처리
                    and dev_detail != 'INCOTERMS'
                    AND MAPPING_COLUMN != 'INCOTERMS'
                    AND program_id = @C_TABLE_NAME
                    AND 'TABLES'   = @C_RTYPE
                    UNION ALL
                    SELECT program_id AS TABLE_NAME
                        , ''          AS LOOKUP_TYPE
                        , dev_detail  AS SEL_COL
                        , ISNULL(WCO.TOO,MAPPING_COLUMN) AS MAP_COL
                        , 'N'         AS CAL_LIKE --LIKE 연산자
                        , ROW_NUMBER()OVER(ORDER BY program_id, dev_detail, MAPPING_COLUMN) RNUM
                    FROM ZNERP_DEV_ITEM_SCHEDULE AS DIS WITH (NOLOCK)
                    LEFT OUTER JOIN W_CONV_CODETYPE AS WCO
                    ON   DIS.MAPPING_COLUMN = WCO.FR
                    where DEV_TYPE = 'Batch_Conversion'
                    and MAPPING_USE IN ( 'DP')
                    AND MAPPING_COLUMN != 'INCOTERMS'
                    AND program_id = @C_TABLE_NAME
                    AND 'DUPLICATION' = @C_RTYPE
                ) X
                --2025-09-17 김준규 VALUATION_CLASS RULL BASE가 아닌 HARD CORDING 되어 있어서 비교프로그램에서 제외 처리함.
                WHERE 1=1
                AND    NOT EXISTS (SELECT 1
                                   WHERE  X.TABLE_NAME IN ('SCP_ANL_LONG_TERM_STOCK')
                                   AND    X.SEL_COL = 'VALUATION_CLASS'
                                   )
                GROUP BY TABLE_NAME
                     , LOOKUP_TYPE
                     , SEL_COL
                     , CAL_LIKE

            )
            SELECT WR.TABLE_NAME
                  ,WR.LOOKUP_TYPE
                  ,MAX(CASE WHEN VALID_YN.TableName IS NOT NULL THEN 'Y' ELSE 'N' END) AS VALID_YN
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L1  --BEFORE
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN (CASE WHEN WR.CAL_LIKE = 'Y' THEN 1 ELSE 0 END) END) L12
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN WR.SEL_COL END) B1  --BEFORE
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN WR.SEL_COL END) B2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN WR.SEL_COL END) B3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN WR.SEL_COL END) B4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN WR.SEL_COL END) B5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN WR.SEL_COL END) B6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN WR.SEL_COL END) B7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN WR.SEL_COL END) B8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN WR.SEL_COL END) B9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN WR.SEL_COL END) B10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN WR.SEL_COL END) B11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN WR.SEL_COL END) B12
                  ,MAX(CASE WHEN WR.RNUM = 1  THEN WR.MAP_COL END) A1  --AFTER
                  ,MAX(CASE WHEN WR.RNUM = 2  THEN WR.MAP_COL END) A2
                  ,MAX(CASE WHEN WR.RNUM = 3  THEN WR.MAP_COL END) A3
                  ,MAX(CASE WHEN WR.RNUM = 4  THEN WR.MAP_COL END) A4
                  ,MAX(CASE WHEN WR.RNUM = 5  THEN WR.MAP_COL END) A5
                  ,MAX(CASE WHEN WR.RNUM = 6  THEN WR.MAP_COL END) A6
                  ,MAX(CASE WHEN WR.RNUM = 7  THEN WR.MAP_COL END) A7
                  ,MAX(CASE WHEN WR.RNUM = 8  THEN WR.MAP_COL END) A8
                  ,MAX(CASE WHEN WR.RNUM = 9  THEN WR.MAP_COL END) A9
                  ,MAX(CASE WHEN WR.RNUM = 10 THEN WR.MAP_COL END) A10
                  ,MAX(CASE WHEN WR.RNUM = 11 THEN WR.MAP_COL END) A11
                  ,MAX(CASE WHEN WR.RNUM = 12 THEN WR.MAP_COL END) A12
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 1  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V1  --AFTER
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 2  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V2
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 3  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V3
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 4  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V4
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 5  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V5
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 6  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V6
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 7  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V7
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 8  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V8
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 9  THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V9
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 10 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V10
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 11 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V11
                  ,CASE WHEN (MAX(CASE WHEN WR.RNUM = 12 THEN WR.MAP_COL END)) IN ('STORAGE_ID','PROFIT_CENTER_ID') THEN 1 ELSE 0 END AS V12
                  ,MAX(CASE WHEN WR.RNUM = 1  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X1 --LIKE아니고 =(EQUAL) 조인 위함
                  ,MAX(CASE WHEN WR.RNUM = 2  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X2
                  ,MAX(CASE WHEN WR.RNUM = 3  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X3
                  ,MAX(CASE WHEN WR.RNUM = 4  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X4
                  ,MAX(CASE WHEN WR.RNUM = 5  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X5
                  ,MAX(CASE WHEN WR.RNUM = 6  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X6
                  ,MAX(CASE WHEN WR.RNUM = 7  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X7
                  ,MAX(CASE WHEN WR.RNUM = 8  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X8
                  ,MAX(CASE WHEN WR.RNUM = 9  AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X9
                  ,MAX(CASE WHEN WR.RNUM = 10 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X10
                  ,MAX(CASE WHEN WR.RNUM = 11 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X11
                  ,MAX(CASE WHEN WR.RNUM = 12 AND WR.MAP_COL IN ('VENDOR_ID','END_CUSTOMER_ID') THEN 1 ELSE 0 END) X12
                  ,MAX(WR.RNUM) RN
            FROM   W_RAW WR
            LEFT JOIN ( SELECT
                            t.name AS TableName,
                            c.name AS ColumnName
                        FROM
                            sys.tables t
                        INNER JOIN
                            sys.columns c ON t.object_id = c.object_id
                        WHERE 1=1
                        AND c.name = 'VALID_YN'
                      ) AS VALID_YN ON VALID_YN.TableName = WR.TABLE_NAME
            WHERE  1=1
            --2025-04-10 김준규 VALUATION_CLASS RULL BASE가 아닌 HARD CORDING 되어 있어서 비교프로그램에서 제외 처리함.
            AND    NOT EXISTS (SELECT 1
                               WHERE  WR.TABLE_NAME IN ('SCP_ANL_LONG_TERM_STOCK')
                               AND    WR.SEL_COL = 'VALUATION_CLASS'
                               )
            GROUP  BY WR.TABLE_NAME
                  ,WR.LOOKUP_TYPE
            ORDER BY 1,2,rn

        OPEN cur

        FETCH NEXT FROM cur INTO @C_DUMMY_TBL_NM, @C_DUMMY_LK_TYPE, @C_VALID_YN
            ,@C_L1,@C_L2,@C_L3,@C_L4,@C_L5,@C_L6,@C_L7,@C_L8,@C_L9,@C_L10,@C_L11,@C_L12
            ,@C_B1,@C_B2,@C_B3,@C_B4,@C_B5,@C_B6,@C_B7,@C_B8,@C_B9,@C_B10,@C_B11,@C_B12
            ,@C_A1,@C_A2,@C_A3,@C_A4,@C_A5,@C_A6,@C_A7,@C_A8,@C_A9,@C_A10,@C_A11,@C_A12
            ,@C_V1,@C_V2,@C_V3,@C_V4,@C_V5,@C_V6,@C_V7,@C_V8,@C_V9,@C_V10,@C_V11,@C_V12
            ,@C_X1,@C_X2,@C_X3,@C_X4,@C_X5,@C_X6,@C_X7,@C_X8,@C_X9,@C_X10,@C_X11,@C_X12,@C_RN;

        WHILE @@FETCH_STATUS = 0 BEGIN

        PRINT '@C_TABLE_NAME  :'+ISNULL(@C_TABLE_NAME ,'NULL');
        PRINT '@C_DISP_TBL_NM :'+ISNULL(@C_DISP_TBL_NM,'NULL');
        PRINT '@C_VALID_YN    :'+ISNULL(@C_VALID_YN   ,'NULL');
        PRINT '@C_LOOKUP_TYPE :'+ISNULL(@C_LOOKUP_TYPE,'NULL');
        PRINT '@C_RTYPE       :'+ISNULL(@C_RTYPE      ,'NULL');
        PRINT '@C_CAL_LIKE    :'+ISNULL(@C_CAL_LIKE   ,'NULL');
        PRINT '@C_RN          :'+ISNULL(CONVERT(NVARCHAR,@C_RN)   ,'NULL');

            IF @C_DISP_TBL_NM <> @C_COPYED_TBL_NM
                BEGIN
                    SET @C_COPYED_TBL_NM = @C_DISP_TBL_NM;
                    SET @C_PRINT_YN = 1
                END
            ELSE
                BEGIN
                    SET @C_PRINT_YN = 0
                END
            --SELECT 컬럼
            SET @C_SEL_B1  = CASE WHEN @C_B1  IS NOT NULL THEN ' A.'+@C_B1 +' AS B1 ' ELSE ' NULL AS B1 ' END;
            SET @C_SEL_B2  = CASE WHEN @C_B2  IS NOT NULL THEN ',A.'+@C_B2 +' AS B2 ' ELSE ',NULL AS B2 ' END;
            SET @C_SEL_B3  = CASE WHEN @C_B3  IS NOT NULL THEN ',A.'+@C_B3 +' AS B3 ' ELSE ',NULL AS B3 ' END;
            SET @C_SEL_B4  = CASE WHEN @C_B4  IS NOT NULL THEN ',A.'+@C_B4 +' AS B4 ' ELSE ',NULL AS B4 ' END;
            SET @C_SEL_B5  = CASE WHEN @C_B5  IS NOT NULL THEN ',A.'+@C_B5 +' AS B5 ' ELSE ',NULL AS B5 ' END;
            SET @C_SEL_B6  = CASE WHEN @C_B6  IS NOT NULL THEN ',A.'+@C_B6 +' AS B6 ' ELSE ',NULL AS B6 ' END;
            SET @C_SEL_B7  = CASE WHEN @C_B7  IS NOT NULL THEN ',A.'+@C_B7 +' AS B7 ' ELSE ',NULL AS B7 ' END;
            SET @C_SEL_B8  = CASE WHEN @C_B8  IS NOT NULL THEN ',A.'+@C_B8 +' AS B8 ' ELSE ',NULL AS B8 ' END;
            SET @C_SEL_B9  = CASE WHEN @C_B9  IS NOT NULL THEN ',A.'+@C_B9 +' AS B9 ' ELSE ',NULL AS B9 ' END;
            SET @C_SEL_B10 = CASE WHEN @C_B10 IS NOT NULL THEN ',A.'+@C_B10+' AS B10' ELSE ',NULL AS B10' END;
            SET @C_SEL_B11 = CASE WHEN @C_B11 IS NOT NULL THEN ',A.'+@C_B11+' AS B11' ELSE ',NULL AS B11' END;
            SET @C_SEL_B12 = CASE WHEN @C_B12 IS NOT NULL THEN ',A.'+@C_B12+' AS B12' ELSE ',NULL AS B12' END;
            SET @SQL_SA = @C_SEL_B1+@C_SEL_B2+@C_SEL_B3+@C_SEL_B4+@C_SEL_B5+@C_SEL_B6+@C_SEL_B7+@C_SEL_B8+@C_SEL_B9+@C_SEL_B10+@C_SEL_B11+@C_SEL_B12;
            -- CONVERSION 교체컬럼
            SET @C_SEL_A1  = CASE WHEN @C_A1  IS NOT NULL THEN IIF(@C_L1 =0,IIF(@C_V1 =0,' B1.NEW_VALUE1  AS A1  ',' B1.NEW_VALUE2  AS A1 '),' REPLACE(A.'+@C_B1 +',B1.OLD_VALUE1, B1.NEW_VALUE1)  AS A1 ') ELSE ' NULL AS A1 ' END;
            SET @C_SEL_A2  = CASE WHEN @C_A2  IS NOT NULL THEN IIF(@C_L2 =0,IIF(@C_V2 =0,',B2.NEW_VALUE1  AS A2  ',',B2.NEW_VALUE2  AS A2 '),',REPLACE(A.'+@C_B2 +',B2.OLD_VALUE1, B2.NEW_VALUE1)  AS A2 ') ELSE ',NULL AS A2 ' END;
            SET @C_SEL_A3  = CASE WHEN @C_A3  IS NOT NULL THEN IIF(@C_L3 =0,IIF(@C_V3 =0,',B3.NEW_VALUE1  AS A3  ',',B3.NEW_VALUE2  AS A3 '),',REPLACE(A.'+@C_B3 +',B3.OLD_VALUE1, B3.NEW_VALUE1)  AS A3 ') ELSE ',NULL AS A3 ' END;
            SET @C_SEL_A4  = CASE WHEN @C_A4  IS NOT NULL THEN IIF(@C_L4 =0,IIF(@C_V4 =0,',B4.NEW_VALUE1  AS A4  ',',B4.NEW_VALUE2  AS A4 '),',REPLACE(A.'+@C_B4 +',B4.OLD_VALUE1, B4.NEW_VALUE1)  AS A4 ') ELSE ',NULL AS A4 ' END;
            SET @C_SEL_A5  = CASE WHEN @C_A5  IS NOT NULL THEN IIF(@C_L5 =0,IIF(@C_V5 =0,',B5.NEW_VALUE1  AS A5  ',',B5.NEW_VALUE2  AS A5 '),',REPLACE(A.'+@C_B5 +',B5.OLD_VALUE1, B5.NEW_VALUE1)  AS A5 ') ELSE ',NULL AS A5 ' END;
            SET @C_SEL_A6  = CASE WHEN @C_A6  IS NOT NULL THEN IIF(@C_L6 =0,IIF(@C_V6 =0,',B6.NEW_VALUE1  AS A6  ',',B6.NEW_VALUE2  AS A6 '),',REPLACE(A.'+@C_B6 +',B6.OLD_VALUE1, B6.NEW_VALUE1)  AS A6 ') ELSE ',NULL AS A6 ' END;
            SET @C_SEL_A7  = CASE WHEN @C_A7  IS NOT NULL THEN IIF(@C_L7 =0,IIF(@C_V7 =0,',B7.NEW_VALUE1  AS A7  ',',B7.NEW_VALUE2  AS A7 '),',REPLACE(A.'+@C_B7 +',B7.OLD_VALUE1, B7.NEW_VALUE1)  AS A7 ') ELSE ',NULL AS A7 ' END;
            SET @C_SEL_A8  = CASE WHEN @C_A8  IS NOT NULL THEN IIF(@C_L8 =0,IIF(@C_V8 =0,',B8.NEW_VALUE1  AS A8  ',',B8.NEW_VALUE2  AS A8 '),',REPLACE(A.'+@C_B8 +',B8.OLD_VALUE1, B8.NEW_VALUE1)  AS A8 ') ELSE ',NULL AS A8 ' END;
            SET @C_SEL_A9  = CASE WHEN @C_A9  IS NOT NULL THEN IIF(@C_L9 =0,IIF(@C_V9 =0,',B9.NEW_VALUE1  AS A9  ',',B9.NEW_VALUE2  AS A9 '),',REPLACE(A.'+@C_B9 +',B9.OLD_VALUE1, B9.NEW_VALUE1)  AS A9 ') ELSE ',NULL AS A9 ' END;
            SET @C_SEL_A10 = CASE WHEN @C_A10 IS NOT NULL THEN IIF(@C_L10=0,IIF(@C_V10=0,',B10.NEW_VALUE1 AS A10 ',',B10.NEW_VALUE2 AS A10'),',REPLACE(A.'+@C_B10+',B10.OLD_VALUE1,B10.NEW_VALUE1) AS A10') ELSE ',NULL AS A10' END;
            -- 2025-09-26 김준규 NERP) 김춘동 책임님 요청으로 최적화는 모든 VALID_YN 무시하고 모두 작업 : 아래는 검증을 위함
            IF @C_RTYPE = 'OPMZ_LOOKUP' BEGIN
                SET @C_SEL_A11 = ',A.VALID_YN AS A11 ';
            END
            ELSE BEGIN
                SET @C_SEL_A11 = CASE WHEN @C_A11 IS NOT NULL THEN IIF(@C_L11=0,IIF(@C_V11=0,',B11.NEW_VALUE1 AS A11 ',',B11.NEW_VALUE2 AS A11'),',REPLACE(A.'+@C_B11+',B11.OLD_VALUE1,B11.NEW_VALUE1) AS A11') ELSE ',NULL AS A11' END;
            END
            SET @C_SEL_A12 = CASE WHEN @C_A12 IS NOT NULL THEN IIF(@C_L12=0,IIF(@C_V12=0,',B12.NEW_VALUE1 AS A12 ',',B12.NEW_VALUE2 AS A12'),',REPLACE(A.'+@C_B12+',B12.OLD_VALUE1,B12.NEW_VALUE1) AS A12') ELSE ',NULL AS A12' END;
            
            --SET @C_SEL_A1  = CASE WHEN @C_A1  IS NOT NULL THEN IIF(@C_V1 =0,' B1.NEW_VALUE1  AS A1 ',' B1.NEW_VALUE2  AS A1 ') ELSE '' END;
            --SET @C_SEL_A2  = CASE WHEN @C_A2  IS NOT NULL THEN IIF(@C_V2 =0,',B2.NEW_VALUE1  AS A2 ',',B2.NEW_VALUE2  AS A2 ') ELSE '' END;
            --SET @C_SEL_A3  = CASE WHEN @C_A3  IS NOT NULL THEN IIF(@C_V3 =0,',B3.NEW_VALUE1  AS A3 ',',B3.NEW_VALUE2  AS A3 ') ELSE '' END;
            --SET @C_SEL_A4  = CASE WHEN @C_A4  IS NOT NULL THEN IIF(@C_V4 =0,',B4.NEW_VALUE1  AS A4 ',',B4.NEW_VALUE2  AS A4 ') ELSE '' END;
            --SET @C_SEL_A5  = CASE WHEN @C_A5  IS NOT NULL THEN IIF(@C_V5 =0,',B5.NEW_VALUE1  AS A5 ',',B5.NEW_VALUE2  AS A5 ') ELSE '' END;
            --SET @C_SEL_A6  = CASE WHEN @C_A6  IS NOT NULL THEN IIF(@C_V6 =0,',B6.NEW_VALUE1  AS A6 ',',B6.NEW_VALUE2  AS A6 ') ELSE '' END;
            --SET @C_SEL_A7  = CASE WHEN @C_A7  IS NOT NULL THEN IIF(@C_V7 =0,',B7.NEW_VALUE1  AS A7 ',',B7.NEW_VALUE2  AS A7 ') ELSE '' END;
            --SET @C_SEL_A8  = CASE WHEN @C_A8  IS NOT NULL THEN IIF(@C_V8 =0,',B8.NEW_VALUE1  AS A8 ',',B8.NEW_VALUE2  AS A8 ') ELSE '' END;
            --SET @C_SEL_A9  = CASE WHEN @C_A9  IS NOT NULL THEN IIF(@C_V9 =0,',B9.NEW_VALUE1  AS A9 ',',B9.NEW_VALUE2  AS A9 ') ELSE '' END;
            --SET @C_SEL_A10 = CASE WHEN @C_A10 IS NOT NULL THEN IIF(@C_V10=0,',B10.NEW_VALUE1 AS A10',',B10.NEW_VALUE2 AS A10') ELSE '' END;
            --SET @C_SEL_A11 = CASE WHEN @C_A11 IS NOT NULL THEN IIF(@C_V11=0,',B11.NEW_VALUE1 AS A11',',B11.NEW_VALUE2 AS A11') ELSE '' END;
            --SET @C_SEL_A12 = CASE WHEN @C_A12 IS NOT NULL THEN IIF(@C_V12=0,',B12.NEW_VALUE1 AS A12',',B12.NEW_VALUE2 AS A12') ELSE '' END;
            SET @SQL_SM = @C_SEL_A1+@C_SEL_A2+@C_SEL_A3+@C_SEL_A4+@C_SEL_A5+@C_SEL_A6+@C_SEL_A7+@C_SEL_A8+@C_SEL_A9+@C_SEL_A10+@C_SEL_A11+@C_SEL_A12;
            
            --참고 INFO 컬럼,SELECT 컬럼에 MAPPING을 무엇으로 하는가를 보여주는 것임.
            SET @SQL_SW =         CASE WHEN @C_B1  IS NOT NULL THEN QUOTENAME(@C_B1 )+'='+@C_A1  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B2  IS NOT NULL THEN QUOTENAME(@C_B2 )+'='+@C_A2  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B3  IS NOT NULL THEN QUOTENAME(@C_B3 )+'='+@C_A3  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B4  IS NOT NULL THEN QUOTENAME(@C_B4 )+'='+@C_A4  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B5  IS NOT NULL THEN QUOTENAME(@C_B5 )+'='+@C_A5  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B6  IS NOT NULL THEN QUOTENAME(@C_B6 )+'='+@C_A6  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B7  IS NOT NULL THEN QUOTENAME(@C_B7 )+'='+@C_A7  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B8  IS NOT NULL THEN QUOTENAME(@C_B8 )+'='+@C_A8  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B9  IS NOT NULL THEN QUOTENAME(@C_B9 )+'='+@C_A9  ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B10 IS NOT NULL THEN QUOTENAME(@C_B10)+'='+@C_A10 ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B11 IS NOT NULL THEN QUOTENAME(@C_B11)+'='+@C_A11 ELSE '' END;
            SET @SQL_SW = @SQL_SW+CASE WHEN @C_B12 IS NOT NULL THEN QUOTENAME(@C_B12)+'='+@C_A12 ELSE '' END;

            SET @SQL_STMT = '
                SELECT DISTINCT '''+@C_DISP_TBL_NM/*@C_LOOKUP_TYPE @C_TABLE_NAME*/+''' AS TABLE_NAME, '+@SQL_SA+','+@SQL_SM+'
                      ,'+@ColumnsToSelect+'
                /*FROM   DBO.' + QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)*/
                /*FROM [DBO].' + QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)*/
                FROM '+@DBPrefix+QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)';

            DECLARE @V_PLANT_ID NVARCHAR(128);
            SET @V_PLANT_ID = NULL;
            IF (@C_V1 + @C_V2 + @C_V3 + @C_V4 + @C_V5 + @C_V6 + @C_V7 + @C_V8 + @C_V9 + @C_V10 + @C_V11 + @C_V12) >= 1 BEGIN
                SELECT TOP 1 @V_PLANT_ID = DIS.DEV_DETAIL
                FROM   ZNERP_DEV_ITEM_SCHEDULE AS DIS WITH(NOLOCK)
                WHERE  1=1
                AND    DIS.PROGRAM_ID = @C_TABLE_NAME
                AND    MAPPING_COLUMN = N'PLANT_ID'
                ORDER BY CASE WHEN DEV_DETAIL  = 'STORAGE_PLANT_ID' THEN 1
                              WHEN DEV_DETAIL  = 'PLANT_ID' THEN 2
                              WHEN DEV_DETAIL  = 'PLANT_CD' THEN 3
                              WHEN DEV_DETAIL LIKE '%SITE_ID%' THEN 9
                            ELSE 8 END
                END;
            ELSE BEGIN
                SET @V_PLANT_ID = 'PLANT_ID';
                END;

        IF @C_RN >= 1 BEGIN
          IF @C_L1 = 0 BEGIN
            IF @C_V1 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B1 ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V1 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B1  ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B1.OLD_VALUE1';
            END
          END
          ELSE IF @C_L1 = 1 BEGIN
            IF @C_V1 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B1 ON A.' + QUOTENAME(@C_B1 ) + (CASE WHEN @C_X1 = 0 THEN ' LIKE '+'''%''+B1.OLD_VALUE1+''%''' ELSE ' = B1.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V1 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A1)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B1  ON A.' + QUOTENAME(@C_B1 ) + ' = B1.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B1.OLD_VALUE1';
            END
          END          
        END;
        IF @C_RN >= 2 BEGIN
          IF @C_L2 = 0 BEGIN
            IF @C_V2 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B2 ON A.' + QUOTENAME(@C_B2 ) + ' = B2.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V2 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B2  ON A.' + QUOTENAME(@C_B2 ) + ' = B2.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B2.OLD_VALUE1';
            END
          END
          ELSE IF @C_L2 = 1 BEGIN
            IF @C_V2 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B2 ON A.' + QUOTENAME(@C_B2) + (CASE WHEN @C_X2 = 0 THEN ' LIKE '+'''%''+B2.OLD_VALUE1+''%''' ELSE ' = B2.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V2 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A2)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B2 ON A.' + QUOTENAME(@C_B2) + ' = B2.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B2.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 3 BEGIN
          IF @C_L3 = 0 BEGIN
            IF @C_V3 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B3 ON A.' + QUOTENAME(@C_B3 ) + ' = B3.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V3 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B3  ON A.' + QUOTENAME(@C_B3 ) + ' = B3.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B3.OLD_VALUE1';
            END
          END
          ELSE IF @C_L3 = 1 BEGIN
            IF @C_V3 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B3 ON A.' + QUOTENAME(@C_B3) + (CASE WHEN @C_X3 = 0 THEN ' LIKE '+'''%''+B3.OLD_VALUE1+''%''' ELSE ' = B3.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V3 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A3)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B3 ON A.' + QUOTENAME(@C_B3) + ' = B3.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B3.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 4 BEGIN
          IF @C_L4 = 0 BEGIN
            IF @C_V4 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B4 ON A.' + QUOTENAME(@C_B4 ) + ' = B4.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V4 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B4  ON A.' + QUOTENAME(@C_B4 ) + ' = B4.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B4.OLD_VALUE1';
            END
          END
          ELSE IF @C_L4 = 1 BEGIN
            IF @C_V4 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B4 ON A.' + QUOTENAME(@C_B4) + (CASE WHEN @C_X4 = 0 THEN ' LIKE '+'''%''+B4.OLD_VALUE1+''%''' ELSE ' = B4.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V4 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A4)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B4 ON A.' + QUOTENAME(@C_B4) + ' = B4.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B4.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 5 BEGIN
          IF @C_L5 = 0 BEGIN
            IF @C_V5 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B5 ON A.' + QUOTENAME(@C_B5 ) + ' = B5.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V5 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B5  ON A.' + QUOTENAME(@C_B5 ) + ' = B5.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B5.OLD_VALUE1';
            END
          END
          ELSE IF @C_L5 = 1 BEGIN
            IF @C_V5 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B5 ON A.' + QUOTENAME(@C_B5) + (CASE WHEN @C_X5 = 0 THEN ' LIKE '+'''%''+B5.OLD_VALUE1+''%''' ELSE ' = B5.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V5 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A5)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B5 ON A.' + QUOTENAME(@C_B5) + ' = B5.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B5.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 6 BEGIN
          IF @C_L6 = 0 BEGIN
            IF @C_V6 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B6 ON A.' + QUOTENAME(@C_B6 ) + ' = B6.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V6 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B6  ON A.' + QUOTENAME(@C_B6 ) + ' = B6.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B6.OLD_VALUE1';
            END
          END
          ELSE IF @C_L6 = 1 BEGIN
            IF @C_V6 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B6 ON A.' + QUOTENAME(@C_B6) + (CASE WHEN @C_X6 = 0 THEN ' LIKE '+'''%''+B6.OLD_VALUE1+''%''' ELSE ' = B6.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V6 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A6)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B6 ON A.' + QUOTENAME(@C_B6) + ' = B6.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B6.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 7 BEGIN
          IF @C_L7 = 0 BEGIN
            IF @C_V7 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B7 ON A.' + QUOTENAME(@C_B7 ) + ' = B7.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V7 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B7  ON A.' + QUOTENAME(@C_B7 ) + ' = B7.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B7.OLD_VALUE1';
            END
          END
          ELSE IF @C_L7 = 1 BEGIN
            IF @C_V7 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B7 ON A.' + QUOTENAME(@C_B7) + (CASE WHEN @C_X7 = 0 THEN ' LIKE '+'''%''+B7.OLD_VALUE1+''%''' ELSE ' = B7.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V7 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A7)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B7 ON A.' + QUOTENAME(@C_B7) + ' = B7.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B7.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 8 BEGIN
          IF @C_L8 = 0 BEGIN
            IF @C_V8 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B8 ON A.' + QUOTENAME(@C_B8 ) + ' = B8.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V8 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B8  ON A.' + QUOTENAME(@C_B8 ) + ' = B8.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B8.OLD_VALUE1';
            END
          END
          ELSE IF @C_L8 = 1 BEGIN
            IF @C_V8 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B8 ON A.' + QUOTENAME(@C_B8) + (CASE WHEN @C_X8 = 0 THEN ' LIKE '+'''%''+B8.OLD_VALUE1+''%''' ELSE ' = B8.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V8 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A8)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B8 ON A.' + QUOTENAME(@C_B8) + ' = B8.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B8.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 9 BEGIN
          IF @C_L9 = 0 BEGIN
            IF @C_V9 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B9 ON A.' + QUOTENAME(@C_B9 ) + ' = B9.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V9 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B9  ON A.' + QUOTENAME(@C_B9 ) + ' = B9.OLD_VALUE2    AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B9.OLD_VALUE1';
            END
          END
          ELSE IF @C_L9 = 1 BEGIN
            IF @C_V9 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B9 ON A.' + QUOTENAME(@C_B9) + (CASE WHEN @C_X9 = 0 THEN ' LIKE '+'''%''+B9.OLD_VALUE1+''%''' ELSE ' = B9.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V9 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A9)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B9 ON A.' + QUOTENAME(@C_B9) + ' = B9.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B9.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 10 BEGIN
          IF @C_L10 = 0 BEGIN
            IF @C_V10 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B10 ON A.' + QUOTENAME(@C_B10) + ' = B10.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V10 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B10 ON A.' + QUOTENAME(@C_B10) + ' = B10.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B10.OLD_VALUE1';
            END
        END;
          END
          ELSE IF @C_L10 = 1 BEGIN
            IF @C_V10 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B10 ON A.' + QUOTENAME(@C_B10) + (CASE WHEN @C_X10 = 0 THEN ' LIKE '+'''%''+B10.OLD_VALUE1+''%''' ELSE ' = B10.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V10 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A10)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B10 ON A.' + QUOTENAME(@C_B10) + ' = B10.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B10.OLD_VALUE1';
            END
          END
        IF @C_RN >= 11 BEGIN
          IF @C_L11 = 0 BEGIN
            IF @C_V11 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B11 ON A.' + QUOTENAME(@C_B11) + ' = B11.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V11 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B11 ON A.' + QUOTENAME(@C_B11) + ' = B11.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B11.OLD_VALUE1';
            END
          END
          ELSE IF @C_L11 = 1 BEGIN
            IF @C_V11 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B11 ON A.' + QUOTENAME(@C_B11) + (CASE WHEN @C_X11 = 0 THEN ' LIKE '+'''%''+B11.OLD_VALUE1+''%''' ELSE ' = B11.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V11 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A11)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B11 ON A.' + QUOTENAME(@C_B11) + ' = B11.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B11.OLD_VALUE1';
            END
          END
        END;
        IF @C_RN >= 12 BEGIN
          IF @C_L12 = 0 BEGIN
            IF @C_V12 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B12 ON A.' + QUOTENAME(@C_B12) + ' = B12.OLD_VALUE1';
            END
            ELSE BEGIN --IF @C_V12 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B12 ON A.' + QUOTENAME(@C_B12) + ' = B12.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B12.OLD_VALUE1';
            END
          END
          ELSE IF @C_L12 = 1 BEGIN
            IF @C_V12 = 0 BEGIN
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''') B12 ON A.' + QUOTENAME(@C_B12) + (CASE WHEN @C_X12 = 0 THEN ' LIKE '+'''%''+B12.OLD_VALUE1+''%''' ELSE ' = B12.OLD_VALUE1 ' END);SET @SQL_STMT = @SQL_STMT+'';
            END
            ELSE BEGIN --IF @C_V12 = 1
            SET @SQL_STMT += N'
            LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1, OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V N WITH(NOLOCK) WHERE CODETYPE IN ('+dbo.FN_GET_NERP_IN_VALUES(@C_A12)+') AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND EXISTS (SELECT 1 FROM NERP_CONV_MASTER_CFM_V X WITH (NOLOCK) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' AND X.OLD_VALUE1 = N.OLD_VALUE1 )) B12 ON A.' + QUOTENAME(@C_B12) + ' = B12.OLD_VALUE2   AND A.' + QUOTENAME(@V_PLANT_ID) + ' = B12.OLD_VALUE1';
            END
          END
        END;

        SET @SQL_ISNOTNULL = N'';
        IF @C_RN = 1 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 2 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 3 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 4 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 5 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 6 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 7 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 8 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 9 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 10 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                  OR  B10.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 11 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,@OnlyMatched)+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                  OR  B10.OLD_VALUE1 IS NOT NULL
                  OR  B11.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;
        ELSE IF @C_RN = 12 BEGIN
            SET @SQL_ISNOTNULL = @SQL_ISNOTNULL+'
            AND ('''+TRY_CONVERT(VARCHAR,'X')+''' = ''0''
                OR (
                      B1.OLD_VALUE1 IS NOT NULL
                  OR  B2.OLD_VALUE1 IS NOT NULL
                  OR  B3.OLD_VALUE1 IS NOT NULL
                  OR  B4.OLD_VALUE1 IS NOT NULL
                  OR  B5.OLD_VALUE1 IS NOT NULL
                  OR  B6.OLD_VALUE1 IS NOT NULL
                  OR  B7.OLD_VALUE1 IS NOT NULL
                  OR  B8.OLD_VALUE1 IS NOT NULL
                  OR  B9.OLD_VALUE1 IS NOT NULL
                  OR  B10.OLD_VALUE1 IS NOT NULL
                  OR  B11.OLD_VALUE1 IS NOT NULL
                  OR  B12.OLD_VALUE1 IS NOT NULL
                )
            )';
        END;

            IF @C_RTYPE = 'LOOKUP'  BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE') + ' = '''+@C_LOOKUP_TYPE+'''
            AND   A.VALID_YN = ''Y'' ' + @SQL_ISNOTNULL;
            END;
            --2025-09-26 최적화는 모든 VALID_YN 무시하고 모두 작업
            ELSE IF @C_RTYPE = 'OPMZ_LOOKUP' BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1
            AND   A.' + QUOTENAME('LOOKUP_TYPE') + ' = '''+@C_LOOKUP_TYPE+'''
            --AND   A.VALID_YN = ''Y'' '' + @SQL_ISNOTNULL;''
            '+ @SQL_ISNOTNULL;
            END;
            ELSE IF @C_VALID_YN = 'Y' BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1
            AND   A.VALID_YN = ''Y'' ' + @SQL_ISNOTNULL;
            END;
            ELSE BEGIN
                SET @SQL_STMT = @SQL_STMT+N'
            WHERE 1=1 ' + @SQL_ISNOTNULL;
            END

            SET @SQL_STMT = '            WITH W_RAW AS ('+@SQL_STMT;
            SET @SQL_STMT = @SQL_STMT+'
            )
            --SELECT * FROM W_RAW;
            , W_CHK_RAW AS (
                SELECT TABLE_NAME,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11, ISNULL(A1,B1) A1,ISNULL(A2,B2) A2,ISNULL(A3,B3) A3,ISNULL(A4,B4) A4,ISNULL(A5,B5) A5,ISNULL(A6,B6) A6,ISNULL(A7,B7) A7,ISNULL(A8,B8) A8,ISNULL(A9,B9) A9,ISNULL(A10,B10) A10,ISNULL(A11,B11) A11
                      ,(CASE WHEN ISNULL(A1 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A2 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A3 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A4 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A5 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A6 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A7 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A8 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A9 ,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A10,'''') != '''' THEN ''Y''
                             WHEN ISNULL(A11,'''') != '''' AND '''+@C_RTYPE+''' != ''OPMZ_LOOKUP'' THEN ''Y''
                         ELSE ''N''
                         END) AS ACTUAL_CHG_YN
                FROM W_RAW
            )
            --SELECT * FROM W_CHK_RAW;
            , W_CHK_SUM AS (
                SELECT TABLE_NAME,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
                      ,BEFORE_CNT=COUNT(*),CHANGE_YN=MAX(ACTUAL_CHG_YN),CNT_ACT_CHG_Y=SUM(CASE WHEN ACTUAL_CHG_YN = ''Y'' THEN 1 ELSE 0 END)
                FROM  W_CHK_RAW
                GROUP BY TABLE_NAME,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
                HAVING COUNT(*) > 0
            )
            --SELECT *FROM W_CHK_SUM;
            , W_GET_TTL AS (
                SELECT TTL_CNT = COUNT(*)
                /*FROM   DBO.' + QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)*/
                /*FROM [DBO].' + QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)*/
                FROM '+@DBPrefix+QUOTENAME(@C_TABLE_NAME) + ' A WITH (NOLOCK)';
                IF @C_RTYPE IN ( 'LOOKUP','OPMZ_LOOKUP') BEGIN
                    SET @SQL_STMT = @SQL_STMT+N'
                WHERE 1=1
                AND   A.' + QUOTENAME('LOOKUP_TYPE') + ' = '''+@C_LOOKUP_TYPE+'''
                AND   A.VALID_YN = ''Y'' ';
                END;
                ELSE IF @C_VALID_YN = 'Y' BEGIN
                    SET @SQL_STMT = @SQL_STMT+N'
                WHERE 1=1
                AND   A.VALID_YN = ''Y'' ';
                END;
                ELSE BEGIN
                    SET @SQL_STMT = @SQL_STMT+N'
                WHERE 1=1 ';
                END;
            SET @SQL_STMT = @SQL_STMT+'
            )
            --SELECT *FROM W_GET_TTL;
            , W_CHK_TTL AS (
                SELECT TABLE_NAME,BEFORE_CNT_A = MAX(TTL_CNT)/*SUM(BEFORE_CNT)*/,CNT_ACT_CHG_Y=SUM(CNT_ACT_CHG_Y)
                FROM  W_CHK_SUM ,W_GET_TTL
                GROUP BY TABLE_NAME
            )
            --SELECT *FROM W_CHK_TTL;
            --, W_A_SUM AS (
            --    SELECT TABLE_NAME,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11,AFTER_CNT=SUM(BEFORE_CNT)
            --          ,CHANGE_YN = MAX(CHANGE_YN)
            --    FROM  W_CHK_SUM
            --    GROUP BY TABLE_NAME,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
            --    HAVING COUNT(*) > 0
            --)
            ----SELECT *FROM W_A_SUM;
            --, W_A_TTL AS (
            --    SELECT TABLE_NAME,AFTER_CNT_A = SUM(AFTER_CNT),CNT_DISP_CHG_Y=SUM(CASE WHEN CHANGE_YN = ''Y'' THEN AFTER_CNT ELSE 0 END)
            --    FROM  W_A_SUM
            --    GROUP BY TABLE_NAME
            --)
            ----SELECT *FROM W_A_TTL;
            INSERT INTO NERP_CONV_CMP_SCP(
                BATCH_ID,RTYPE,TABLE_NAME,B_COL1,B_COL2,B_COL3,B_COL4,B_COL5,B_COL6,B_COL7,B_COL8,B_COL9,B_COL10,B_COL11
                ,A_COL1,A_COL2,A_COL3,A_COL4,A_COL5,A_COL6,A_COL7,A_COL8,A_COL9,A_COL10,A_COL11
                ,BEFORE_CNT,CHANGE_YN,CNT_ACT_CHG_Y,CNT_DISP_AFTER_CHG_Y,BEFORE_CNT_A,AFTER_CNT_A
            )
            SELECT BATCH_ID,RTYPE,TABLE_NAME,B1,B2,B3,B4,B5,B6,B7,B8,B9,B10,B11,A1,A2,A3,A4,A5,A6,A7,A8,A9,A10,A11
                  ,BEFORE_CNT,CHANGE_YN,CNT_ACT_CHG_Y,CNT_DISP_AFTER_CHG_Y,BEFORE_CNT_A,AFTER_CNT_A
            FROM (
                SELECT '+CONVERT(NVARCHAR(30),@BATCH_ID)+' AS BATCH_ID,''Rollin: '+@P_ROLLIN+' BeforeBase '+@C_RTYPE+' Before/After'' AS RTYPE
                     , WB.*
                     , CNT_DISP_AFTER_CHG_Y=0--ISNULL(WS.AFTER_CNT,0)
                     , 0 BEFORE_CNT_A--WBT.BEFORE_CNT_A
                     , 0 AFTER_CNT_A--WAT.AFTER_CNT_A
                FROM   W_CHK_SUM AS WB
                --LEFT OUTER JOIN W_A_SUM AS WS
                --ON     WB.TABLE_NAME = WS.TABLE_NAME
                --AND    ISNULL(WB.A1 ,'''') = ISNULL(WS.A1 ,'''')
                --AND    ISNULL(WB.A2 ,'''') = ISNULL(WS.A2 ,'''')
                --AND    ISNULL(WB.A3 ,'''') = ISNULL(WS.A3 ,'''')
                --AND    ISNULL(WB.A4 ,'''') = ISNULL(WS.A4 ,'''')
                --AND    ISNULL(WB.A5 ,'''') = ISNULL(WS.A5 ,'''')
                --AND    ISNULL(WB.A6 ,'''') = ISNULL(WS.A6 ,'''')
                --AND    ISNULL(WB.A7 ,'''') = ISNULL(WS.A7 ,'''')
                --AND    ISNULL(WB.A8 ,'''') = ISNULL(WS.A8 ,'''')
                --AND    ISNULL(WB.A9 ,'''') = ISNULL(WS.A9 ,'''')
                --AND    ISNULL(WB.A10,'''') = ISNULL(WS.A10,'''')
                --AND    ISNULL(WB.A11,'''') = ISNULL(WS.A11,'''')
                --AND    WB.CHANGE_YN = WS.CHANGE_YN
                --AND    WS.CHANGE_YN = ''Y''
                --JOIN W_CHK_TTL AS WBT
                --ON     WB.TABLE_NAME=WBT.TABLE_NAME
                --JOIN W_A_TTL AS WAT
                --ON     WB.TABLE_NAME=WAT.TABLE_NAME
                WHERE  1=1--WS.CHANGE_YN = ''Y''
                UNION ALL
                SELECT '+CONVERT(NVARCHAR(30),@BATCH_ID)+' AS BATCH_ID,''Rollin: '+@P_ROLLIN+' BeforeBase '+@C_RTYPE+' TTL''    AS RTYPE,
                    G1.TABLE_NAME,NULL B1,NULL B2,NULL B3,NULL B4,NULL B5,NULL B6,NULL B7,NULL B8,NULL B9,NULL B10,NULL B11,
                    NULL A1,NULL A2,NULL A3,NULL A4,NULL A5,NULL A6,NULL A7,NULL A8,NULL A9,NULL A10,NULL A11,NULL BEFORE_CNT,NULL CHANGE_YN,
                    COALESCE(G1.CNT_ACT_CHG_Y, 0) AS CNT_ACT_CHG_Y,0 AS Total_DISP_CHG_Y,
                    COALESCE(G1.BEFORE_CNT_A, 0) AS Total_BEFORE,
                    0 AS Total_AFTER
                FROM (SELECT TOP 1 TABLE_NAME,BEFORE_CNT_A, CNT_ACT_CHG_Y AS CNT_ACT_CHG_Y FROM W_CHK_TTL) G1
                --FULL OUTER JOIN (SELECT TOP 1 TABLE_NAME,AFTER_CNT_A,CNT_DISP_CHG_Y FROM W_A_TTL) G2
                --ON G1.TABLE_NAME = G2.TABLE_NAME
            ) X
            --ORDER BY CASE WHEN RTYPE = ''Rollin: '+@P_ROLLIN+' BeforeBase '+@C_RTYPE+' Before/After'' THEN ''1''
            --              WHEN RTYPE = ''Rollin: '+@P_ROLLIN+' BeforeBase '+@C_RTYPE+' TTL''          THEN ''3'' ELSE ''4'' END
            ORDER BY 2,3,4,5,6,7,8,9,10;
            SELECT @V_ROWCOUNT = @@ROWCOUNT;
            SELECT @V_SCOPE_ID = SCOPE_IDENTITY();';
            --PRINT @SQL_STMT;
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


            BEGIN TRY
                EXEC sp_executesql @SQL_STMT,
                   N'@V_SCOPE_ID BIGINT OUTPUT,@V_ROWCOUNT BIGINT OUTPUT',
                   @V_SCOPE_ID OUTPUT,
                   @V_ROWCOUNT OUTPUT;
                SET @ExecutionRST = 'Success';
                IF @V_SCOPE_ID > 0 BEGIN
                UPDATE NCC
                SET    SQL_STMT = @SQL_STMT
                      ,INFO1 = ISNULL(@C_CUT_COL1,'')+':'+ISNULL(@C_C_FROM,'')+' '+ISNULL(@C_CUT_COL2,'')+':'+ISNULL(@C_C_TO,'')+' '+ISNULL(@C_CUT_COL3,'')+':'+ISNULL(@C_C_DIVISION,'')+' '+ISNULL(@C_CUT_COL4,'')+':'+ISNULL(@C_C_PLAN_TYPE,'')
                      ,INFO2 = @SQL_SA
                      ,INFO3 = @SQL_SW+'|'+@SQL_SM
                FROM   NERP_CONV_CMP_SCP AS NCC WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID
                END
                ELSE BEGIN
                    DECLARE @BEFORE_CNT_A BIGINT;
                    IF @C_RTYPE IN ( 'LOOKUP','OPMZ_LOOKUP') BEGIN
                    DECLARE @SQL NVARCHAR(MAX);
                    SET @SQL = N'SELECT @Count = COUNT(*) FROM ' + QUOTENAME(@C_TABLE_NAME)+' WITH(NOLOCK) WHERE LOOKUP_TYPE = '''+ @C_LOOKUP_TYPE+''' ';
                    EXEC sp_executesql @SQL,
                         N'@Count INT OUTPUT',
                         @Count = @BEFORE_CNT_A OUTPUT;
                    END
                    ELSE BEGIN
                    DECLARE @OBJECT_ID INT = OBJECT_ID(@C_DISP_TBL_NM);
                    SELECT @BEFORE_CNT_A = SUM(ps.row_count)
                    FROM sys.dm_db_partition_stats ps
                    WHERE ps.object_id = @OBJECT_ID
                    AND ps.index_id IN (0, 1);
                    END
                    IF @BEFORE_CNT_A <> 0 BEGIN
                INSERT INTO NERP_CONV_CMP_SCP(
                BATCH_ID,RTYPE,TABLE_NAME,CNT_ACT_CHG_Y,CNT_DISP_AFTER_CHG_Y,BEFORE_CNT_A,AFTER_CNT_A,SQL_STMT,INFO1,INFO2,INFO3
                )
                SELECT @BATCH_ID AS BATCH_ID,'Rollin: '+@P_ROLLIN+' BeforeBase '+@C_RTYPE+' TTL' AS RTYPE,
                    @C_DISP_TBL_NM,0 AS CNT_ACT_CHG_Y,0 AS Total_DISP_CHG_Y,@BEFORE_CNT_A AS Total_BEFORE,0 AS Total_AFTER,@SQL_STMT
                    ,INFO1 = ISNULL(@C_CUT_COL1,'')+':'+ISNULL(@C_C_FROM,'')+' '+ISNULL(@C_CUT_COL2,'')+':'+ISNULL(@C_C_TO,'')+' '+ISNULL(@C_CUT_COL3,'')+':'+ISNULL(@C_C_DIVISION,'')+' '+ISNULL(@C_CUT_COL4,'')+':'+ISNULL(@C_C_PLAN_TYPE,'')
                    ,INFO2 = @SQL_SA, INFO3 = @SQL_SW+'|'+@SQL_SM;
                    END;
                END;
            END TRY
            BEGIN CATCH
                SET @ExecutionRST = ERROR_MESSAGE();
                INSERT INTO NERP_CONV_CMP_SCP(
                BATCH_ID,RTYPE,TABLE_NAME,ERROR_MSG
                )
                SELECT @BATCH_ID           AS BATCH_ID,
                    'Rollin: '+@P_ROLLIN+' BeforeBase '+@C_RTYPE+' TTL' AS RTYPE,
                    'Error->'+@C_DISP_TBL_NM/*@C_LOOKUP_TYPE @C_TABLE_NAME*/ AS TABLE_NAME,
                    @ExecutionRST          AS ERROR_MSG;
                SELECT @V_SCOPE_ID = SCOPE_IDENTITY();
                UPDATE NCC
                SET    SQL_STMT = @SQL_STMT
                FROM   NERP_CONV_CMP_SCP AS NCC WITH(NOLOCK)
                WHERE  ID = @V_SCOPE_ID
            END CATCH;

            PRINT @ExecutionRST;

            FETCH NEXT FROM cur INTO @C_DUMMY_TBL_NM, @C_DUMMY_LK_TYPE, @C_VALID_YN
                ,@C_L1,@C_L2,@C_L3,@C_L4,@C_L5,@C_L6,@C_L7,@C_L8,@C_L9,@C_L10,@C_L11,@C_L12
                ,@C_B1,@C_B2,@C_B3,@C_B4,@C_B5,@C_B6,@C_B7,@C_B8,@C_B9,@C_B10,@C_B11,@C_B12
                ,@C_A1,@C_A2,@C_A3,@C_A4,@C_A5,@C_A6,@C_A7,@C_A8,@C_A9,@C_A10,@C_A11,@C_A12
                ,@C_V1,@C_V2,@C_V3,@C_V4,@C_V5,@C_V6,@C_V7,@C_V8,@C_V9,@C_V10,@C_V11,@C_V12
                ,@C_X1,@C_X2,@C_X3,@C_X4,@C_X5,@C_X6,@C_X7,@C_X8,@C_X9,@C_X10,@C_X11,@C_X12,@C_RN;

        END

        CLOSE cur
        DEALLOCATE cur
        ;

        --################################################################
        -- Log
        --################################################################
            SET @END_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            SET @RUN_TIME = DATEDIFF(SECOND, @START_TIME, @END_TIME)
            SET @DUMMY = 'END->'+concat(

            '@CNT = ' , @CNT
            , ' , @C_DISP_TBL_NM = ', @C_DISP_TBL_NM
            , ' , @P_RTYPE = ' , @P_RTYPE
            , ' , @P_ROLLIN = ' , @P_ROLLIN
            , ' , @BATCH_ID = ' , @BATCH_ID
            , ' , @START_TIME = ' , @START_TIME
            , ' , @END_TIME = '   , @END_TIME
            , ' , @RUN_TIME = '   , @RUN_TIME
            );

            --처음 1회만 테이블이 바뀔때 처리
            IF @C_PRINT_YN = 1
            BEGIN
                PRINT @DUMMY
                EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'RUN', @V_ROWCOUNT, @C_DISP_TBL_NM,  @DUMMY, @d_event_date;
            END

        FETCH NEXT FROM cur_CUTOFF_COL INTO @C_TABLE_NAME, @C_LOOKUP_TYPE, @C_R_N_R, @C_RTYPE, @C_RNUM, @C_SORT_SEQ;

    END

    CLOSE cur_CUTOFF_COL
    DEALLOCATE cur_CUTOFF_COL

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
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();


END CATCH

    SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

END
