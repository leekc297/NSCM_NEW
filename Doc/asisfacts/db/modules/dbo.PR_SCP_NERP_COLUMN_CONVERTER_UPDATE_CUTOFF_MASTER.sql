

-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER
-- Author:       vadabi5
-- Create date:  2025-01-02
-- Description:  NERP) BIG Table  Convert CUTOFF READY
-- How to Execute: EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER @P_TABLE='',@P_GROUP='',@V_FR_YYYYMMDD='20241021',@V_TO_YYYYMMDD='20241125',@P_ROLLIN='1ST'
--                  @V_FR_YYYYMMDD 가져오는 시작일자 포함됨
--                  @V_TO_YYYYMMDD 입력되어 지는 값보다 작은것,이전일짜까지 포함됨.가져오는 끝나는일자 포함되지 않음
-- ==========================================================================================
-- 2025-01-02       vadabi5     NERP) Big Table Conver 위한 준비 작업
-- 2025-03-13       김준규       튜닝
-- 2025-03-17       김준규       이전 24년11월25일까지 Migration 한것 이후 작업(1달 단위 처리)
-- 2025-04-09       김준규       테이블에 데이터 적재시 4개 구분 순서 대로 넣어야 되나 이렇게 안되어 있어서 수정 'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
-- 2025-04-09       김준규       3TBL을 3개에서 5개 BIG 으로 재구성
-- 2025-04-18       김준규       운영에서 1ST 실행시 모든 것 실행하기 위하여 @P_TABLE = 'ALL' 추가
-- 2025-04-26       김준규       운영에서 1ST 실행시 SCM_MST_MODEL_BOM_EFFECTIVE -> 1차 롤인 한 법인에 대하여 추가 작업을 하지 않아도 됨
-- 2025-08-27       김준규       운영에서 현재의 NERP_ROLLIN_STAGE 상태를 확인하고 SCM_MST_MODEL_BOM_EFFECTIVE 는 동일 또는 이하 ROLLIN STAGE인 경우에 대하여 추가 작업을 하지 않아도 됨
-- 2025-09-08       김준규       작업분배 방식 사용, 사용기간 선택 추가.
-- 2025-10-14       김준규       NERP_CONV_CUTOFF_TAKES_MIN 테이블에 RTYPE=SCP 추가.
---------------------------------------------------------------------------------------------
/*
TRUNCATE TABLE NERP_CONV_SCP_CUTOFF
exec PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER '', ''
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER @P_TABLE='',@P_GROUP='',@V_FR_YYYYMMDD='20241021',@V_TO_YYYYMMDD='20241125',@P_ROLLIN='1ST'
/* 시작일자는 포함이고 종료일자는 끝자리보다 작은 날자임*/
DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE ROLLIN='3RD' ORDER BY RTYPE_NUM DESC);
DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE ROLLIN='3RD' ORDER BY RTYPE_NUM DESC);
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER @P_TABLE='ALL',@P_GROUP='',@V_FR_YYYYMMDD=@V_FR_YYYYMMDD,@V_TO_YYYYMMDD=@V_TO_YYYYMMDD,@P_ROLLIN='3RD'
DECLARE @V_GROUP_NUM INT;
DECLARE @V_GROUP_COUNT INT;
SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT
FROM   NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) 
WHERE  CTM.TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C';
PRINT '@P_GROUP_NUM  :'+CONVERT(NVARCHAR(MAX),@V_GROUP_NUM  );
PRINT '@P_GROUP_COUNT:'+CONVERT(NVARCHAR(MAX),@V_GROUP_COUNT);
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER @P_TABLE='ALL',@P_GROUP='SCP_ANL_SHIPMENT_PLAN_SEMI_C',@P_ROLLIN='3RD',@P_RTYPE_NUM=10,@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT;
*/
---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER]
   @P_TABLE nvarchar(100)
 , @P_GROUP nvarchar(4)
 , @P_ROLLIN    nvarchar(30) --1ST 2ND 3RD 4TH
 , @P_RTYPE_NUM INT = 99999
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
    DECLARE @CNT BIGINT=0;
    DECLARE @WORK_SECOND BIGINT;
    DECLARE @MAPPING_RESULT NVARCHAR(2);
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @RUN_TIME BIGINT;
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;
    DECLARE @YYYYMM nvarchar(10) = '';
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;
    DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);


    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER';
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
    SET @v_description = '@P_TABLE='+@P_TABLE+',@P_GROUP='+@P_GROUP+',@P_ROLLIN='+@P_ROLLIN+',@V_FR_YYYYMMDD='+@V_FR_YYYYMMDD+',@V_TO_YYYYMMDD='+@V_TO_YYYYMMDD+',@P_RTYPE_NUM='+CONVERT(CHAR(23),@P_RTYPE_NUM)+',@P_GROUP_NUM='+CONVERT(CHAR(23),@P_GROUP_NUM)+',@P_GROUP_COUNT='+CONVERT(CHAR(23),@P_GROUP_COUNT);
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, @v_log_message, @v_description, @START_TIME;


BEGIN TRY

    --###########################################################################################################
    -- CURSOR_MAPPING
    --###########################################################################################################
        DECLARE @TOTAL_CUTOFF_USE nvarchar(100) = 'Y'
        DECLARE @TOTAL_CUTOFF_START nvarchar(100)   = @V_FR_YYYYMMDD--'20241101'
        DECLARE @TOTAL_CUTOFF_END nvarchar(100)     = @V_TO_YYYYMMDD--'20241125'

        DECLARE @CUTOFF_START nvarchar(100)
        DECLARE @CUTOFF_END nvarchar(100);
        DECLARE @CUTOFF_WEEK_START nvarchar(100)    = '2025-W01'--'2024-W43'
        SELECT @CUTOFF_WEEK_START= LEFT(CM.ISO_YYYYMM,4)+'-'+CM.WEEK_NAME FROM DBO.SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
        WHERE  CM.BASIS_YYYYMMDD = FORMAT(DATEADD(DAY,-7,CONVERT(DATE,@V_FR_YYYYMMDD)),'yyyyMMdd');
        DECLARE @CUTOFF_WEEK_END   nvarchar(100)    = '2025-W14'--'2024-W47'
        SELECT @CUTOFF_WEEK_END= LEFT(CM.ISO_YYYYMM,4)+'-'+CM.WEEK_NAME FROM DBO.SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
        WHERE  CM.BASIS_YYYYMMDD = FORMAT(DATEADD(DAY,-7,CONVERT(DATE,@V_TO_YYYYMMDD)),'yyyyMMdd');
        DECLARE @CUTOFF_WEEK_1_START nvarchar(100)  = '202501'--'202443'
        SELECT @CUTOFF_WEEK_1_START= CM.ISO_YYYYWW FROM DBO.SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
        WHERE  CM.BASIS_YYYYMMDD = FORMAT(DATEADD(DAY,-7,CONVERT(DATE,@V_FR_YYYYMMDD)),'yyyyMMdd');
        DECLARE @CUTOFF_WEEK_1_END   nvarchar(100)  = '202514'--'202447'
        SELECT @CUTOFF_WEEK_1_END= CM.ISO_YYYYWW FROM DBO.SCM_SYS_CALENDAR_M CM WITH(NOLOCK)
        WHERE  CM.BASIS_YYYYMMDD = FORMAT(DATEADD(DAY,-7,CONVERT(DATE,@V_TO_YYYYMMDD)),'yyyyMMdd');
        DECLARE @CUTOFF_MONTH_START nvarchar(100)   = '202412'--'202410'
        SET @CUTOFF_MONTH_START = FORMAT(DATEADD(MONTH,-6,CONVERT(DATE,@V_FR_YYYYMMDD)),'yyyyMM');
        DECLARE @CUTOFF_MONTH_END   nvarchar(100)   = '202503'--'202411'
        SET @CUTOFF_MONTH_END = FORMAT(DATEADD(MONTH,0,CONVERT(DATE,@V_TO_YYYYMMDD)),'yyyyMM');

        --1차법인 이고 운영일경우 이미 작업을 완료 했기 때문에 제외되어야 한다.
        DECLARE @NERP_PROD NVARCHAR(128);
        SET @NERP_PROD = 'LGCE_'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXPFROCDYB','2,5,6,8,10,11,13');--에스시엠피알오디
        DECLARE @NERP_FIRST_STAGE NVARCHAR(128);
        SET @NERP_FIRST_STAGE = '1'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDTE','2,4');--에스티
        --PRINT @NERP_PROD
        --PRINT @NERP_STAGE
        ------------------------------------------------------------------------
        -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
        ------------------------------------------------------------------------
        DECLARE @V_NERP_ROLLIN_STAGE NVARCHAR(30);
        DECLARE @V_NERV_FR_YYYYMMDD NVARCHAR(8);
        
        SELECT TOP 1 @V_NERP_ROLLIN_STAGE = LMD.SEGMENT1
              ,@V_NERV_FR_YYYYMMDD = LMD.SEGMENT2
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL lmd WITH(NOLOCK)
        JOIN   SCM_ADM_LOOKUP_MASTER alm WITH(NOLOCK)
        ON     ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
        AND    ALM.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE'
        WHERE  ALM.VALID_YN = 'Y'
        AND    LMD.VALID_YN = 'Y';
        --PRINT @V_NERP_ROLLIN_STAGE;
        --PRINT @V_NERV_FR_YYYYMMDD;    
    ------------------------------------------------------------------------
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End
    ------------------------------------------------------------------------
        DECLARE @CUTOFF_BOM_START nvarchar(100)     = '20241201'--'202410'
        SET @CUTOFF_BOM_START = @V_FR_YYYYMMDD;
        DECLARE @CUTOFF_BOM_END   nvarchar(100) = '20250301'--'202411'
        SET @CUTOFF_BOM_END = '99991231';

        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END
        DECLARE CURSOR_MAPPING CURSOR FOR
            WITH W_RAW AS (
               SELECT SCM.TABLE_NAME
                     , CUTOFF_START
                     , CUTOFF_END
                     , PRIORITY_GROUP ,PRIORITY_SORT
                 FROM NERP_CONV_SCP_CUTOFF_MASTER SCM WITH (NOLOCK)
                 JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
                WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
                  AND CTM.RTYPE = 'SCP'
                  AND CTM.GROUP_NUM = @P_GROUP_NUM
                  AND CTM.GROUP_COUNT = @P_GROUP_COUNT
                --and table_name NOT in ('SCP_ANL_SHIPMENT_PLAN_FG_C')
                and (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR SCM.TABLE_NAME = @P_TABLE)
                and (@P_GROUP IS NULL OR @P_GROUP ='' OR PRIORITY_GROUP = @P_GROUP)
                AND NOT EXISTS ( SELECT 1
                                 FROM  (SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                                        SELECT 'SCP_ANL_SHIPMENT_PLAN_SEMI'    AS TBL_NM UNION
                                        --SELECT 'HIST_SCP_ANL_SHIPMENT_PLAN_FG' AS TBL_NM UNION
                                        --SELECT 'SCP_PLN_PLANT_ONHAND'          AS TBL_NM UNION
                                        SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM  ) X
                                 WHERE  1=1
                                 AND    X.TBL_NM =  SCM.TABLE_NAME
                                 --AND    (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' )
                                 --2025-04-18 김준규 ALL일때 제외가 동작하지 않게 모두 다 나오게 해야 해서 ALL을 제거함
                                 AND    (@P_TABLE IS NULL OR @P_TABLE ='' )
                                 )
                AND  ISNULL(@P_TABLE,'') <> '3TBL'
                UNION
                SELECT SCM.TABLE_NAME
                     , CUTOFF_START
                     , CUTOFF_END
                     , PRIORITY_GROUP ,PRIORITY_SORT
                FROM NERP_CONV_SCP_CUTOFF_MASTER AS SCM WITH (NOLOCK)
                 JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON SCM.TABLE_NAME = CTM.TABLE_NAME
                WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
                  AND CTM.RTYPE = 'SCP'
                  AND CTM.GROUP_NUM = @P_GROUP_NUM
                  AND CTM.GROUP_COUNT = @P_GROUP_COUNT
             --   and (@P_TABLE IS NULL OR @P_TABLE ='' OR TABLE_NAME = @P_TABLE)
                --and (@P_GROUP IS NULL OR @P_GROUP ='' OR PRIORITY_GROUP = @P_GROUP)
                AND  ISNULL(@P_TABLE,'') = '3TBL'
                AND  SCM.TABLE_NAME IN (SELECT 'SCP_ANL_SHIPMENT_PLAN_FG'      AS TBL_NM UNION
                                        SELECT 'SCP_ANL_SHIPMENT_PLAN_SEMI'    AS TBL_NM UNION
                                        --SELECT 'HIST_SCP_ANL_SHIPMENT_PLAN_FG' AS TBL_NM UNION
                                        --SELECT 'SCP_PLN_PLANT_ONHAND'          AS TBL_NM UNION
                                        SELECT 'SCP_ANL_PRODUCTION_PLAN'       AS TBL_NM )
            )
            SELECT TABLE_NAME
                 , CUTOFF_START
                 , CUTOFF_END
            FROM   W_RAW
            WHERE  1=1
            --2025-04-26 1차 롤인 한 법인에 대하여 추가 작업을 하지 않아도 됨
            --2025-08-27 운영에서 현재의 NERP_ROLLIN_STAGE 상태를 확인하고 SCM_MST_MODEL_BOM_EFFECTIVE 는 동일 또는 이하 ROLLIN STAGE인 경우에 대하여 추가 작업을 하지 않아도 됨
            AND NOT EXISTS ( SELECT 1
                             WHERE  W_RAW.TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                             AND    DB_NAME() = @NERP_PROD
                             --2025-08-27 @NERP_FIRST_STAGE를 @V_NERP_ROLLIN_STAG로 변경하면서 =을 <=로 변경 
                             --AND    @P_ROLLIN = @NERP_FIRST_STAGE
                             AND    @P_ROLLIN <= @V_NERP_ROLLIN_STAGE
                           )
          order by PRIORITY_GROUP ,PRIORITY_SORT, TABLE_NAME



        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME, @CUTOFF_START, @CUTOFF_END

        WHILE @@FETCH_STATUS = 0
        BEGIN

            --########################################
            SET @TABLE_NAME = ''+@TABLE_NAME;
            --########################################
    BEGIN TRY
        --BEGIN TRANSACTION;
        -----------------------------------------------------------------------------
        --  실제로는 테이블별로 기간 하드코딩 셋팅되어 있음
        --  실제로는 전체 테이블 아닌 테이블별로 일부 Conversion 할 것으로 예상 되며
        --  필요한 테이블에 필요한 기간 셋팅 하여 작업 할 것으로 예상 됨
        -----------------------------------------------------------------------------
            IF @TOTAL_CUTOFF_USE = 'Y'
            begin

                SET @CUTOFF_START       = @TOTAL_CUTOFF_START
                SET @CUTOFF_END         = @TOTAL_CUTOFF_END


                IF @TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R'
                    begin
                    SET @CUTOFF_START       = @CUTOFF_MONTH_START
                    SET @CUTOFF_END         = @CUTOFF_MONTH_END
                    end
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP_SNAPSHOT'
                    begin
                    SET @CUTOFF_START       = @CUTOFF_WEEK_START
                    SET @CUTOFF_END         = @CUTOFF_WEEK_END
                    end
                ELSE IF @TABLE_NAME = 'SCP_BI_FP_RESULT'
                    begin
                    SET @CUTOFF_START       = @CUTOFF_WEEK_1_START
                    SET @CUTOFF_END         = @CUTOFF_WEEK_1_END
                    end
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                    begin
                    SET @CUTOFF_START       = @CUTOFF_BOM_START
                    SET @CUTOFF_END         = @CUTOFF_BOM_END
                    end
            end



            set @v_log_message =  concat('CURSOR_MAPPING = ', @TABLE_NAME, ', ',@CUTOFF_START, ', ',@CUTOFF_END)
            PRINT @v_log_message
            SET @MAPPING_RESULT = 'N';
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            --아래로 옮김(이동)
            --EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @@ROWCOUNT, @v_description, @v_log_message, @START_TIME;

                -- 2025-03-26 테이블 단위 데이터 삭제 처리
                DELETE FROM NERP_CONV_SCP_CUTOFF
                WHERE 1=1
                AND   TABLE_NAME = @TABLE_NAME;

                -- PLAN_START_YYYYMMDD
                IF @TABLE_NAME = 'SCP_ANL_PSI_GLOBAL_ESS'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_PSI_GLOBAL_ESS'
                          ,'PLAN_START_YYYYMMDD','-','-','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', '-', PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM dbo.SCP_ANL_PSI_GLOBAL_ESS A with (nolock)
                    where A.DIVISION_ID         >= '0' --PK
                      AND PLAN_START_YYYYMMDD >= @CUTOFF_START
                      AND PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD,PLAN_TYPE

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                --PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_GLOBAL'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_PSI_GLOBAL'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PSI_GLOBAL A   WITH (INDEX (PK_SCP_ANL_PSI_GLOBAL))
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                      AND PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID,PLAN_TYPE


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_RPT_ELEC_PSI'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_RPT_ELEC_PSI'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_RPT_ELEC_PSI A with (index(IX01_SCP_RPT_ELEC_PSI), nolock)
                    where ISNULL(A.DIVISION_ID,'') >= '' --PK 아님
                      AND PLAN_START_YYYYMMDD >= @CUTOFF_START
                      AND PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID,PLAN_TYPE


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_FG_C'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )

                    -- 오픈 시 PLAN_START_YYYYMMDD 로 기간 설정 되어
                    -- CUTOFF로 변경
                    -- 아래에 CUTOFF_TO 입력 하는 것 있음
                    SELECT
                         'SCP_ANL_SHIPMENT_PLAN_FG_C'
                          ,'CUTOFF_DATE','-', '-'
                          , convert(nvarchar(8), CUTOFF_DATE,112), '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by convert(nvarchar(8), CUTOFF_DATE,112) desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_SHIPMENT_PLAN_FG_C A  with (index (IX02_SCP_ANL_SHIPMENT_PLAN_FG_C), nolock)
                    where CUTOFF_DATE >= @CUTOFF_START
                    AND CUTOFF_DATE < @CUTOFF_END
                    group by convert(nvarchar(8), CUTOFF_DATE,112)





                        SET @n_log_count = @@rowCount;
                        ---------------------------------------------------------------------------------------------
                        IF OBJECT_ID('tempdb..#tmp_cutoff_value5') IS NOT NULL
                        BEGIN   
                        DROP TABLE #tmp_cutoff_value5
                        END

                        select table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt
                            , case
                              when cutoff_sort = 1 then @CUTOFF_END
                              else (select max(cutoff_FROM)
                                      from NERP_CONV_SCP_CUTOFF
                                     where table_name = a.table_name
                                     and cutoff_start = @CUTOFF_START
                                     and table_name = a.table_name
                                     and cutoff_sort = (SELECT max(cutoff_sort)
                                                           from NERP_CONV_SCP_CUTOFF
                                                          where table_name = a.table_name
                                                           and cutoff_sort < a.cutoff_sort
                                                           and cutoff_start = @CUTOFF_START
                                                           )
                                )
                              end as v2
                        into #tmp_cutoff_value5
                        from NERP_CONV_SCP_CUTOFF a
                        where table_name = 'SCP_ANL_SHIPMENT_PLAN_FG_C'
                        and cutoff_start = @CUTOFF_START
                        order by table_name ,cutoff_sort, cutoff_value1


                        ---------------------------------------------------------------------------------------------
                        UPDATE NERP_CONV_SCP_CUTOFF
                        SET NERP_CONV_SCP_CUTOFF.CUTOFF_TO  = B.v2
                        FROM .NERP_CONV_SCP_CUTOFF AS A,
                        (SELECT table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt, v2 FROM #tmp_cutoff_value5) AS B
                        WHERE   A.table_name    = B.table_name
                        and a.cutoff_start =  @CUTOFF_START
                        and a.cutoff_sort = b.cutoff_sort
                        and a.cutoff_FROM = b.cutoff_from
                        and a.cutoff_to = '-'
                        and a.table_name = 'SCP_ANL_SHIPMENT_PLAN_FG_C'



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- CUTOFF_DATE
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCM_DNM_STOCK'
                          ,'CUTOFF_DATE', '-','DIVISION_ID'
                          , CUTOFF_DATE, '-', DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_DATE desc) as rno
                          , @CUTOFF_START
                    FROM SCM_DNM_STOCK A WITH (INDEX(IDX02_SCM_DNM_STOCK), nolock)
                    where CUTOFF_DATE >= @CUTOFF_START
                      and CUTOFF_DATE <  @CUTOFF_END
                    group by CUTOFF_DATE, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- SCP_PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_MAT_SUPPLY'
                    BEGIN


                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_MAT_SUPPLY'
                          ,'SCP_PLAN_START_YYYYMMDD', '-','DIVISION_ID'
                          , SCP_PLAN_START_YYYYMMDD, '-', DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by SCP_PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_MAT_SUPPLY A with (index (PK_SCP_ANL_MAT_SUPPLY), nolock)
                    where SCP_PLAN_START_YYYYMMDD >= @CUTOFF_START
                      AND SCP_PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by SCP_PLAN_START_YYYYMMDD, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_GLOBAL_SMALL'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_PSI_GLOBAL_SMALL'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PSI_GLOBAL_SMALL A with (index (PK_SCP_ANL_PSI_GLOBAL_SMALL), nolock)
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                      AND PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCP_ANL_BOD_N_V_PLAN_H'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_BOD_N_V_PLAN_H'
                          ,'PLAN_NAME','-', '-'
                          , PLAN_NAME, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_NAME desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_BOD_N_V_PLAN_H A  with (index (IX01_SCP_ANL_BOD_N_V_PLAN_H), nolock)
                    where DIVISION_ID >= '' --PK
                    AND PLAN_NAME >= @CUTOFF_START
                      AND PLAN_NAME < @CUTOFF_END
                    group by PLAN_NAME

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- RESULT_DATE
                ELSE IF @TABLE_NAME = 'SCM_DNM_INTRANSIT_C'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    --2025-03-25 아래부분 CUTOFF_TO UPDATE 있음
                    SELECT
                         'SCM_DNM_INTRANSIT_C'
                          ,'RESULT_DATE','-', '-'
                          , RESULT_DATE, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by RESULT_DATE desc) as rno
                          , @CUTOFF_START
                    FROM SCM_DNM_INTRANSIT_C A  with (index (IDX04_SCM_DNM_INTRANSIT_C), nolock)
                    where RESULT_DATE >= @CUTOFF_START
                      AND RESULT_DATE < @CUTOFF_END
                    group by RESULT_DATE


                    SET @n_log_count = @@rowCount;
                        ---------------------------------------------------------------------------------------------
                        IF OBJECT_ID('tempdb..#tmp_cutoff_value3') IS NOT NULL
                        BEGIN   
                        DROP TABLE #tmp_cutoff_value3
                        END

                        select table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt
                            , case
                              when cutoff_sort = 1 then @CUTOFF_END
                              else (select max(cutoff_FROM)
                                      from NERP_CONV_SCP_CUTOFF
                                     where table_name = a.table_name
                                     and cutoff_start = @CUTOFF_START
                                     and table_name = a.table_name
                                     and cutoff_sort = (SELECT max(cutoff_sort)
                                                           from NERP_CONV_SCP_CUTOFF
                                                          where table_name = a.table_name
                                                           and cutoff_sort < a.cutoff_sort
                                                           and cutoff_start = @CUTOFF_START
                                                           )
                                )
                              end as v2
                        into #tmp_cutoff_value3
                        from NERP_CONV_SCP_CUTOFF a
                        where table_name = 'SCM_DNM_INTRANSIT_C'
                        and cutoff_start = @CUTOFF_START
                        order by table_name ,cutoff_sort, cutoff_value1


                        ---------------------------------------------------------------------------------------------
                        UPDATE NERP_CONV_SCP_CUTOFF
                        SET NERP_CONV_SCP_CUTOFF.CUTOFF_TO  = B.v2
                        FROM .NERP_CONV_SCP_CUTOFF AS A,
                        (SELECT table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt, v2 FROM #tmp_cutoff_value3) AS B
                        WHERE   A.table_name    = B.table_name
                        and a.cutoff_start =  @CUTOFF_START
                        and a.cutoff_sort = b.cutoff_sort
                        and a.cutoff_FROM = b.cutoff_from
                        and a.cutoff_to = '-'
                        and a.table_name = 'SCM_DNM_INTRANSIT_C'



                    SET @MAPPING_RESULT = 'Y';
                    END

                -- SNAPSHOT_WEEK
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP_SNAPSHOT'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCM_DNM_MPP_SNAPSHOT'
                          ,'SNAPSHOT_WEEK','-', '-'
                          , SNAPSHOT_WEEK, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by SNAPSHOT_WEEK desc) as rno
                          , @CUTOFF_START
                    FROM SCM_DNM_MPP_SNAPSHOT A  with (index (PK_SCM_DNM_MPP_SNAPSHOT), nolock)
                    where SNAPSHOT_WEEK >= @CUTOFF_START
                      and SNAPSHOT_WEEK <  @CUTOFF_END
                    group by SNAPSHOT_WEEK

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- YYYYMM
                ELSE IF @TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_MONTH_END_STOCK_R'
                          ,'YYYYMM','-', 'DIVISION_ID'
                          , YYYYMM, '-', ISNULL(DIVISION_ID,'-'), '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by YYYYMM desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_MONTH_END_STOCK_R A  with (index (IX01_SCP_ANL_MONTH_END_STOCK_R), nolock)
                    where YYYYMM >= @CUTOFF_START
                      AND YYYYMM <= @CUTOFF_END
                    group by YYYYMM,DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                -- EFF_START_DATE
                -- @CUTOFF_TO 필요
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCM_MST_MODEL_BOM_EFFECTIVE'
                          ,'EFF_END_DATE','-', 'DIVISION_ID'
                          , CONVERT(NVARCHAR(10), EFF_END_DATE, 112), '-', DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CONVERT(NVARCHAR(10), EFF_END_DATE, 112) desc) as rno
                          , @CUTOFF_START
                     FROM SCM_MST_MODEL_BOM_EFFECTIVE A  with (index (PK_SCM_MST_MODEL_BOM_EFFECTIVE), nolock)
                    where COMPANY_ID         >= '' --PK 컬럼
                      AND DIVISION_ID        >= ''
                      AND SITE_ID            >= ''
                      AND PLANT_ID           >= ''
                      AND MODEL_ID           >= ''
                      AND CONCATENATE_ITEM   >= ''
                      AND EFF_END_DATE >= @CUTOFF_START
                      --2025-03-26 BOM의 경우 MAX가 9999-12-31이기에 작거나 같은 것으로 변경
                      and EFF_END_DATE <= @CUTOFF_END
                    group by CONVERT(NVARCHAR(10), EFF_END_DATE, 112),DIVISION_ID


                    SET @n_log_count = @@rowCount;
                        ---------------------------------------------------------------------------------------------
                    --2025-03-26 컷오프 엔드 데이터 잘 못 나오고 사용할 시 더 늦어 질 것 같아서 막음.

                        --IF OBJECT_ID('tempdb..#tmp_cutoff_value4') IS NOT NULL
                        --BEGIN   
                        --DROP TABLE #tmp_cutoff_value4
                        --END

                        --select table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt
                        --  , case
                        --    when cutoff_sort = 1 then @CUTOFF_END
                        --    else (select max(cutoff_FROM)
                        --            from NERP_CONV_SCP_CUTOFF
                        --           where table_name = a.table_name
                        --           and cutoff_start = @CUTOFF_START
                        --           and table_name = a.table_name
                        --           and cutoff_sort = (SELECT max(cutoff_sort)
                        --                                 from NERP_CONV_SCP_CUTOFF
                        --                                where table_name = a.table_name
                        --                                 and cutoff_sort < a.cutoff_sort
                        --                                 and cutoff_start = @CUTOFF_START
                        --                                 )
                        --      )
                        --    end as v2
                        --into #tmp_cutoff_value4
                        --from NERP_CONV_SCP_CUTOFF a
                        --where table_name = 'SCM_MST_MODEL_BOM_EFFECTIVE'
                        --and cutoff_start = @CUTOFF_START
                        --order by table_name ,cutoff_sort, cutoff_value1


                        -----------------------------------------------------------------------------------------------
                        --UPDATE NERP_CONV_SCP_CUTOFF
                        --SET NERP_CONV_SCP_CUTOFF.CUTOFF_TO    = B.v2
                        --FROM .NERP_CONV_SCP_CUTOFF AS A,
                        --(SELECT * FROM #tmp_cutoff_value4) AS B
                        --WHERE   A.table_name  = B.table_name
                        --and a.cutoff_start =  @CUTOFF_START
                        --and a.cutoff_sort = b.cutoff_sort
                        --and a.cutoff_FROM = b.cutoff_from
                        --and a.cutoff_to = '-'
                        --and a.table_name = 'SCM_MST_MODEL_BOM_EFFECTIVE'




                    SET @MAPPING_RESULT = 'Y';
                    END



                -- CUTOFF_DATE
                -- @CUTOFF_TO 필요
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    --2025-03-25 아래 CUTOFF_TO 입력 있음
                    SELECT
                         'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                          ,'CUTOFF_DATE','-', '-'
                          , CONVERT(nvarchar(10), CUTOFF_DATE,112) , '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CONVERT(nvarchar(10), CUTOFF_DATE,112) desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_SHIPMENT_PLAN_SEMI_C A  with (index(IX01_SCP_ANL_SHIPMENT_PLAN_SEMI_C))
                    where CUTOFF_DATE >= @CUTOFF_START
                      and CUTOFF_DATE < @CUTOFF_END
                    group by CONVERT(nvarchar(10), CUTOFF_DATE,112)

                    SET @n_log_count = @@rowCount;
                        ---------------------------------------------------------------------------------------------
                        IF OBJECT_ID('tempdb..#tmp_cutoff_value6') IS NOT NULL
                        BEGIN   
                        DROP TABLE #tmp_cutoff_value6
                        END

                        select table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt
                            , case
                              when cutoff_sort = 1 then @CUTOFF_END
                              else (select max(cutoff_FROM)
                                      from NERP_CONV_SCP_CUTOFF
                                     where table_name = a.table_name
                                     and cutoff_start = @CUTOFF_START
                                     and table_name = a.table_name
                                     and cutoff_sort = (SELECT max(cutoff_sort)
                                                           from NERP_CONV_SCP_CUTOFF
                                                          where table_name = a.table_name
                                                           and cutoff_sort < a.cutoff_sort
                                                           and cutoff_start = @CUTOFF_START
                                                           )
                                )
                              end as v2
                        into #tmp_cutoff_value6
                        from NERP_CONV_SCP_CUTOFF a
                        where table_name = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C'
                        and cutoff_start = @CUTOFF_START
                        order by table_name ,cutoff_sort, cutoff_value1


                        ---------------------------------------------------------------------------------------------
                        UPDATE NERP_CONV_SCP_CUTOFF
                        SET NERP_CONV_SCP_CUTOFF.CUTOFF_TO  = B.v2
                        FROM .NERP_CONV_SCP_CUTOFF AS A,
                        (SELECT table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt, v2 FROM #tmp_cutoff_value6) AS B
                        WHERE   A.table_name    = B.table_name
                        and a.cutoff_start =  @CUTOFF_START
                        and a.cutoff_sort = b.cutoff_sort
                        and a.cutoff_FROM = b.cutoff_from
                        and a.cutoff_to = '-'
                        and a.table_name = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C'


                    SET @MAPPING_RESULT = 'Y';
                    END

                -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_SEMI'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_SHIPMENT_PLAN_SEMI'
                          ,'PLAN_START_YYYYMMDD','-', '-'
                          , PLAN_START_YYYYMMDD , '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_SHIPMENT_PLAN_SEMI A  with (index (PK_SCP_ANL_SHIPMENT_PLAN_SEMI))
                    where DIVISION_ID >= '' --PK
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                      and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                -- BASIS_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCM_KPI_SUMMARY'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCM_KPI_SUMMARY'
                          ,'BASIS_YYYYMMDD','-', '-'
                          , BASIS_YYYYMMDD, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by BASIS_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCM_KPI_SUMMARY A  with (index (IX01_SCM_KPI_SUMMARY), nolock)
                    where BASIS_YYYYMMDD >= @CUTOFF_START
                      and BASIS_YYYYMMDD < @CUTOFF_END
                    --where BASIS_YYYYMMDD >= '20240909'
                    --  and BASIS_YYYYMMDD < '20241031'
                    group by BASIS_YYYYMMDD

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                -- PLAN_WEEK
                ELSE IF @TABLE_NAME = 'SCP_BI_FP_RESULT'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_BI_FP_RESULT'
                          ,'PLAN_WEEK','-', '-'
                          , PLAN_WEEK, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_WEEK desc) as rno
                          , @CUTOFF_START
                    FROM SCP_BI_FP_RESULT A
                    where PLAN_WEEK >= @CUTOFF_START
                      and PLAN_WEEK <  @CUTOFF_END
                      and PLAN_WEEK != '999952'
                    group by PLAN_WEEK

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- CUTOFF_DATE
                -- @CUTOFF_TO 필요
                ELSE IF @TABLE_NAME = 'SCP_ANL_PRODUCTION_PLAN_C'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    --아래 CUTOFF_TO 있음
                    SELECT
                         'SCP_ANL_PRODUCTION_PLAN_C'
                          ,'CUTOFF_DATE','-', '-'
                          , CONVERT(nvarchar(10), CUTOFF_DATE,112) , '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CONVERT(nvarchar(10), CUTOFF_DATE,112) desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PRODUCTION_PLAN_C A  with (index (IX02_SCP_ANL_PRODUCTION_PLAN_C), nolock)
                    where CUTOFF_DATE >= @CUTOFF_START
                       and CUTOFF_DATE < @CUTOFF_END
                    group by CONVERT(nvarchar(10), CUTOFF_DATE,112)


                    SET @n_log_count = @@rowCount;
                        ---------------------------------------------------------------------------------------------
                        IF OBJECT_ID('tempdb..#tmp_cutoff_value7') IS NOT NULL
                        BEGIN   
                        DROP TABLE #tmp_cutoff_value7
                        END

                        select table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt
                            , case
                              when cutoff_sort = 1 then @CUTOFF_END
                              else (select max(cutoff_FROM)
                                      from NERP_CONV_SCP_CUTOFF
                                     where table_name = a.table_name
                                     and cutoff_start = @CUTOFF_START
                                     and table_name = a.table_name
                                     and cutoff_sort = (SELECT max(cutoff_sort)
                                                           from NERP_CONV_SCP_CUTOFF
                                                          where table_name = a.table_name
                                                           and cutoff_sort < a.cutoff_sort
                                                           and cutoff_start = @CUTOFF_START
                                                           )
                                )
                              end as v2
                        into #tmp_cutoff_value7
                        from NERP_CONV_SCP_CUTOFF a
                        where table_name = 'SCP_ANL_PRODUCTION_PLAN_C'
                        and cutoff_start = @CUTOFF_START
                        order by table_name ,cutoff_sort, cutoff_value1


                        ---------------------------------------------------------------------------------------------
                        UPDATE NERP_CONV_SCP_CUTOFF
                        SET NERP_CONV_SCP_CUTOFF.CUTOFF_TO  = B.v2
                        FROM .NERP_CONV_SCP_CUTOFF AS A,
                        (SELECT table_name, cutoff_FROM , cutoff_TO, cutoff_DIVISION, CUTOFF_VALUE1, cutoff_sort, rowcnt, v2 FROM #tmp_cutoff_value7) AS B
                        WHERE   A.table_name    = B.table_name
                        and a.cutoff_start =  @CUTOFF_START
                        and a.cutoff_sort = b.cutoff_sort
                        and a.cutoff_FROM = b.cutoff_from
                        and a.cutoff_to = '-'
                        and a.table_name = 'SCP_ANL_PRODUCTION_PLAN_C'


                    SET @MAPPING_RESULT = 'Y';
                    END


                -- CUTOFF_DATE
                ELSE IF @TABLE_NAME = 'SCP_ANL_MONTH_END_STOCK_R_D'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_MONTH_END_STOCK_R_D'
                          ,'CUTOFF_DATE','-', '-'
                          , convert(nvarchar(8), CUTOFF_DATE,112), '-', YYYYMM, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by convert(nvarchar(8), CUTOFF_DATE,112) desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_MONTH_END_STOCK_R_D A  with (index(IX01_SCP_ANL_MONTH_END_STOCK_R_D))
                    where CUTOFF_DATE >= @CUTOFF_START
                     AND CUTOFF_DATE <  @CUTOFF_END
                    group by CUTOFF_DATE, YYYYMM



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_PRODUCTION_PLAN'
                    BEGIN


                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_PRODUCTION_PLAN'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID,PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PRODUCTION_PLAN A  with (index(PK_SCP_ANL_PRODUCTION_PLAN/*IX01_SCP_ANL_PRODUCTION_PLAN*/))
                    where DIVISION_ID >= ''
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_FG'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_SHIPMENT_PLAN_FG'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_SHIPMENT_PLAN_FG A  with (index(PK_SCP_ANL_SHIPMENT_PLAN_FG))
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, PLAN_TYPE, DIVISION_ID




                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                    -- PLAN_START_YYYYMMDD
                ELSE IF @TABLE_NAME = 'SCP_PLN_PLANT_ONHAND'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )

                    SELECT 'SCP_PLN_PLANT_ONHAND'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_PLN_PLANT_ONHAND A WITH (INDEX(PK_SCP_PLN_PLANT_ONHAND))
                    where DIVISION_ID >= '' --PK
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCP_PLN_SALES_ONHAND'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )

                    SELECT 'SCP_PLN_SALES_ONHAND'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_PLN_SALES_ONHAND A WITH (INDEX(IX01_SCP_PLN_SALES_ONHAND))
                    where DIVISION_ID >= '' --PK
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'SCM_KPI_DETAIL'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCM_KPI_DETAIL'
                          ,'PLAN_START_YYYYMMDD','-', '-'
                          , PLAN_START_YYYYMMDD, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCM_KPI_DETAIL A  with (index(IX02_SCM_KPI_DETAIL))
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCP_ANL_PROBLEM_REPORT_PEGGING'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_PROBLEM_REPORT_PEGGING'
                          ,'PLAN_START_YYYYMMDD','-','DIVISION_ID'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PROBLEM_REPORT_PEGGING A  with (index(UK01_SCP_ANL_PROBLEM_REPORT_PEGGING))
                    where DIVISION_ID >= '' --NO NULLABLE
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCP_PLN_SHIPMENT_PLAN'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_PLN_SHIPMENT_PLAN'
                          ,'PLAN_START_YYYYMMDD', '-','-', 'PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', '-', PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_PLN_SHIPMENT_PLAN A WITH (INDEX(IX05_SCP_PLN_SHIPMENT_PLAN))
                    where PLAN_TYPE >= '' --PK
                    AND PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, PLAN_TYPE


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                ELSE IF @TABLE_NAME = 'SCP_ANL_PROBLEM_REPORT_DEMAND'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCP_ANL_PROBLEM_REPORT_DEMAND'
                          ,'PLAN_START_YYYYMMDD','-', '-'
                          , PLAN_START_YYYYMMDD, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    -- 2025-03-26 DIVISION_ID에서 PLAN_TYPE로 변경
                    FROM SCP_ANL_PROBLEM_REPORT_DEMAND A  with (index(IX01_SCP_ANL_PROBLEM_REPORT_DEMAND))
                    where PLAN_TYPE >= '' --NOT NULL
                    --FROM SCP_ANL_PROBLEM_REPORT_DEMAND A  with (index(PK_SCP_ANL_PROBLEM_REPORT_DEMAND))
                    --where DIVISION_ID >= '' --PK
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END




                ELSE IF @TABLE_NAME = 'SCP_PLN_PRODUCTION_PLAN'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_PLN_PRODUCTION_PLAN'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_PLN_PRODUCTION_PLAN A with (index (IX01_SCP_PLN_PRODUCTION_PLAN), nolock)
                    where PLAN_TYPE >= '' --PK
                    AND PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID,PLAN_TYPE



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                ELSE IF @TABLE_NAME = 'SCP_ANL_TACT_TIME'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    --2025-03-26 컬럼명을 CUTOFF_DATE를 YYYYMMDD로 변경, 컬럼명 DIVISION_ID 제외처리
                    SELECT 'SCP_ANL_TACT_TIME'
                          ,'YYYYMMDD','-', '-'
                          , YYYYMMDD, '-', '-', '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_TACT_TIME A WITH (INDEX(IX01_SCP_ANL_TACT_TIME))
                    where DIVISION_ID >= ''
                      and YYYYMMDD >= @CUTOFF_START
                    and YYYYMMDD < @CUTOFF_END
                    group by YYYYMMDD

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_PRODUCTION'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_PSI_PRODUCTION'
                          ,'PLAN_START_YYYYMMDD', 'SEQ','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, SEQ, DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PSI_PRODUCTION A WITH (INDEX(PK_SCP_ANL_PSI_PRODUCTION),nolock)
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE, SEQ



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                ELSE IF @TABLE_NAME = 'HIST_SCP_ANL_PRODUCTION_PLAN'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'HIST_SCP_ANL_PRODUCTION_PLAN'
                          ,'PLAN_START_YYYYMMDD', 'SEQ','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, SEQ, DIVISION_ID, PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM HIST_SCP_ANL_PRODUCTION_PLAN A WITH (INDEX(PK_HIST_SCP_ANL_PRODUCTION_PLAN),nolock)
                    where DIVISION_ID >= '' --PK
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, SEQ, DIVISION_ID, PLAN_TYPE

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'HIST_SCP_ANL_SHIPMENT_PLAN_SEMI'
                          ,'PLAN_START_YYYYMMDD', '-','-', 'PLAN_TYPE'
                          , PLAN_START_YYYYMMDD,'-' ,'-', PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM HIST_SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (INDEX(PK_HIST_SCP_ANL_SHIPMENT_PLAN_SEMI),nolock)
                    where DIVISION_ID >= '' --PK
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, PLAN_TYPE

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'HIST_SCP_ANL_SHIPMENT_PLAN_FG'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'HIST_SCP_ANL_SHIPMENT_PLAN_FG'
                          ,'PLAN_START_YYYYMMDD', 'SEQ','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, SEQ, DIVISION_ID,  PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG A WITH (INDEX(PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG),nolock)
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END



                ELSE IF @TABLE_NAME = 'SCP_ANL_PSI_ELECTRODE'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_PSI_ELECTRODE'
                          ,'PLAN_START_YYYYMMDD', '-','-', 'PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', '-',  PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    --FROM SCP_ANL_PSI_ELECTRODE A WITH (INDEX(PK_SCP_ANL_PSI_ELECTRODE),nolock)
                    --where DIVISION_ID >= '' --PK
                    --INDEX 및 WHERE 조건에 DIVISION_ID -> PLAN_TYPE로 변경
                    FROM SCP_ANL_PSI_ELECTRODE A WITH (INDEX(IX02_SCP_ANL_PSI_ELECTRODE),nolock)
                    where PLAN_TYPE >= '' --NOT NULL
                      and PLAN_START_YYYYMMDD >= @CUTOFF_START
                      and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD,  PLAN_TYPE



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END






                ELSE IF @TABLE_NAME = 'SCP_RPT_GLOBAL_PSI_MD_WW'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )

                    SELECT 'SCP_RPT_GLOBAL_PSI_MD_WW'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID', '-'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID,  '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_RPT_GLOBAL_PSI_MD_WW A WITH (INDEX(SCP_RPT_GLOBAL_PSI_MD_WW_PK),nolock)
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCP_RPT_GLOBAL_PSI_MD_MM'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_RPT_GLOBAL_PSI_MD_MM'
                          ,'PLAN_START_YYYYMMDD', '-', 'DIVISION_ID', '-'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID,  '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_RPT_GLOBAL_PSI_MD_MM A WITH (INDEX(SCP_RPT_GLOBAL_PSI_MD_MM_PK),nolock)
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                -- HISTORY_SEQ, RESULT_DATE
                ELSE IF @TABLE_NAME = 'SCM_DNM_INTRANSIT_C_H'
                    BEGIN
                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCM_DNM_INTRANSIT_C_H'
                          ,'RESULT_DATE','-', 'HISTORY_SEQ'
                          , RESULT_DATE, '-', HISTORY_SEQ, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by RESULT_DATE desc) as rno
                          , @CUTOFF_START
                    FROM SCM_DNM_INTRANSIT_C_H A  with (index (PK_SCM_DNM_INTRANSIT_C_H_1), nolock)
                    where HISTORY_SEQ > 0  --PK
                    AND RESULT_DATE >= @CUTOFF_START
                    and RESULT_DATE < @CUTOFF_END
                    group by HISTORY_SEQ,RESULT_DATE


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END


                ELSE IF @TABLE_NAME = 'SCP_ANL_PRODUCTION_PLAN_H'
                    BEGIN

                    INSERT INTO NERP_CONV_SCP_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'SCP_ANL_PRODUCTION_PLAN_H'
                          ,'PLAN_START_YYYYMMDD', '-','DIVISION_ID','PLAN_TYPE'
                          , PLAN_START_YYYYMMDD, '-', DIVISION_ID,  PLAN_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by PLAN_START_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM SCP_ANL_PRODUCTION_PLAN_H A with (index(PK_SCP_ANL_PRODUCTION_PLAN_H), nolock)
                    where PLAN_START_YYYYMMDD >= @CUTOFF_START
                    and PLAN_START_YYYYMMDD < @CUTOFF_END
                    group by PLAN_START_YYYYMMDD, DIVISION_ID, PLAN_TYPE


                    SET @n_log_count = @@rowCount;
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



           UPDATE NERP_CONV_SCP_CUTOFF_MASTER
              SET MAPPING_START             = @START_TIME
                , MAPPING_END               = @END_TIME
                , MAPPING_TIME              = @RUN_TIME
                , mapping_RESULT            = 'FINISH'
                , CONVERT_ROW               = @n_log_count
            where TABLE_NAME                = @TABLE_NAME



        END

        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @@ROWCOUNT, @v_description, @v_log_message, @START_TIME;

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
        INTO @TABLE_NAME, @CUTOFF_START, @CUTOFF_END

        END
        CLOSE CURSOR_MAPPING;
        DEALLOCATE CURSOR_MAPPING;


        SET @BATCH_END_TIME = SYSDATETIME();
        SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
        PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
        SET @v_log_message = '########## END of procedure ##########';
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'END', @BATCH_RUN_TIME, @v_log_message,  'END, RUN_TIME ', @BATCH_END_TIME;



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
