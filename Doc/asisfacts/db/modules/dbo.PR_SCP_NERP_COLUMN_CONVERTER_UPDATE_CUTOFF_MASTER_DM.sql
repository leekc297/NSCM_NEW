


-- ==========================================================================================
-- Program:      PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM
-- Author:       vadabi5
-- Create date:  2025-01-02
-- Description:  NERP) BIG Table  Convert CUTOFF READY
-- How to Execute: EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM @P_TABLE='',@P_GROUP='',@V_FR_YYYYMMDD='20241021',@V_TO_YYYYMMDD='20241125',@P_ROLLIN='1ST'
--                  @V_FR_YYYYMMDD 가져오는 시작일자 포함됨
--                  @V_TO_YYYYMMDD 입력되어 지는 값보다 작은것,이전일짜까지 포함됨.가져오는 끝나는일자 포함되지 않음
-- ==========================================================================================
-- 2025-04-25       김준규       NERP) PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER 카피사용
-- 2025-09-24       김준규       NERP) HINT 추가 DM_PLN_MKT_FCST_C A (INDEX(IX03_DM_PLN_MKT_FCST_C),NOLOCK),DM_PLN_MKT_FCST_RESULT_C (INDEX(PK_DM_PLN_MKT_FCST_RESULT_C_PART),NOLOCK)
--                                             ,DM_PLN_SALES_PLAN_C A (INDEX(PK_dm_pln_sales_plan_c_part),NOLOCK), DM_PLN_SALES_PLAN_REPORT_C A (INDEX(PK_DM_PLN_SALES_PLAN_REPORT_C),NOLOCK)
--                                             ,DM_PLN_BP_FCST_C A WITH(INDEX(PK_DM_PLN_BP_FCST_C),NOLOCK)
-- 2025-10-14       김준규       작업분배 방식 사용, 사용기간 선택 추가.
---------------------------------------------------------------------------------------------
/*
TRUNCATE TABLE NERP_CONV_DM_CUTOFF
exec PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM '', ''
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM @P_TABLE='',@P_GROUP='',@V_FR_YYYYMMDD='20241021',@V_TO_YYYYMMDD='20241125',@P_ROLLIN='1ST'
/* 시작일자는 포함이고 종료일자는 끝자리보다 작은 날자임*/
DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN='3RD' ORDER BY RTYPE_NUM DESC);
DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='DM' AND ROLLIN='3RD' ORDER BY RTYPE_NUM DESC);
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM @P_TABLE='DM_PLN_BP_FCST_C',@P_GROUP='',@V_FR_YYYYMMDD=@V_FR_YYYYMMDD,@V_TO_YYYYMMDD=@V_TO_YYYYMMDD,@P_ROLLIN='3RD';
DECLARE @V_GROUP_NUM INT;
DECLARE @V_GROUP_COUNT INT;
SELECT @V_GROUP_NUM=GROUP_NUM,@V_GROUP_COUNT=GROUP_COUNT
FROM   NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) 
WHERE  CTM.RTYPE = 'DM'
AND    CTM.TABLE_NAME = 'SCP_ANL_SHIPMENT_PLAN_SEMI_C';
PRINT '@P_GROUP_NUM  :'+CONVERT(NVARCHAR(MAX),@V_GROUP_NUM  );
PRINT '@P_GROUP_COUNT:'+CONVERT(NVARCHAR(MAX),@V_GROUP_COUNT);
EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER @P_TABLE='ALL',@P_GROUP='SCP_ANL_SHIPMENT_PLAN_SEMI_C',@P_ROLLIN='3RD',@P_RTYPE_NUM=10,@P_GROUP_NUM=@V_GROUP_NUM,@P_GROUP_COUNT=@V_GROUP_COUNT;
*/
---------------------------------------------------------------------------------------------

CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM]
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
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_DM_'+@P_ROLLIN;
    DECLARE @V_FR_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 FR_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);
    DECLARE @V_TO_YYYYMMDD NVARCHAR(8)=(SELECT TOP 1 TO_YYYYMMDD FROM NERP_CONV_SCP_RUN_DT_RANGE WITH(NOLOCK) WHERE MODULE='SCP' AND ROLLIN=@P_ROLLIN AND RTYPE_NUM = @P_RTYPE_NUM ORDER BY RTYPE_NUM DESC);


    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_CUTOFF_MASTER_DM';
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

        ----최초 DM 관리용 데이터 입력
        --INSERT INTO NERP_CONV_DM_CUTOFF_MASTER
        --( TABLE_NAME,MAPPING_USE,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER )
        --SELECT DISTINCT TIM.TABLE_NAME,'Y' AS MAPPING_USE,GETDATE() AS CREATE_DATE,@CREATED_BY AS CREATE_USER
        --      ,GETDATE() AS UPDATE_DATE,@CREATED_BY AS UPDATE_USER
        --FROM   ZNERP_TARGET_INFO_DM TIM WITH(NOLOCK)
        --WHERE  1=1
        --AND    BIG_CONVERSION_FLAG != '-'
        --AND    NOT EXISTS (SELECT 1
        --                   FROM   NERP_CONV_DM_CUTOFF_MASTER DCM WITH(NOLOCK)
        --                   WHERE  DCM.TABLE_NAME = TIM.TABLE_NAME
        --                   )
        --ORDER BY 1;

        IF CURSOR_STATUS('global', 'CURSOR_MAPPING') >= 0
        BEGIN
            CLOSE CURSOR_MAPPING;
            DEALLOCATE CURSOR_MAPPING;
        END
        DECLARE CURSOR_MAPPING CURSOR FOR
            WITH W_RAW AS (
               SELECT DCM.TABLE_NAME
                     , CUTOFF_START
                     , CUTOFF_END
                     , PRIORITY_GROUP ,PRIORITY_SORT
                 FROM NERP_CONV_DM_CUTOFF_MASTER DCM WITH (NOLOCK)
                 JOIN NERP_CONV_CUTOFF_TAKES_MIN CTM WITH(NOLOCK) ON DCM.TABLE_NAME = CTM.TABLE_NAME
                WHERE ISNULL(MAPPING_USE,'Y') = 'Y'
                  AND CTM.RTYPE = 'DM'
                  AND CTM.GROUP_NUM = @P_GROUP_NUM
                  AND CTM.GROUP_COUNT = @P_GROUP_COUNT
                --and table_name NOT in ('SCP_ANL_SHIPMENT_PLAN_FG_C')
                and (@P_TABLE IS NULL OR @P_TABLE ='' OR @P_TABLE ='ALL' OR DCM.TABLE_NAME = @P_TABLE)
                and (@P_GROUP IS NULL OR @P_GROUP ='' OR PRIORITY_GROUP = @P_GROUP)
            )
            SELECT TABLE_NAME
                 , CUTOFF_START
                 , CUTOFF_END
            FROM   W_RAW
          --order by PRIORITY_GROUP ,PRIORITY_SORT, TABLE_NAME
          order by TABLE_NAME



        OPEN CURSOR_MAPPING;
        FETCH NEXT FROM CURSOR_MAPPING
        INTO @TABLE_NAME, @CUTOFF_START, @CUTOFF_END

        WHILE @@FETCH_STATUS = 0
        BEGIN

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

            end

            set @v_log_message =  concat('', @TABLE_NAME, ', ',@CUTOFF_START, ', ',@CUTOFF_END)
            PRINT @v_log_message
            SET @MAPPING_RESULT = 'N';
            SET @CNT = @CNT+1;
            SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @TABLE_NAME, @@ROWCOUNT, @v_description, @v_log_message, @START_TIME;

                -- 2025-03-26 테이블 단위 데이터 삭제 처리
                DELETE FROM NERP_CONV_DM_CUTOFF
                WHERE 1=1
                AND   TABLE_NAME = @TABLE_NAME;

                IF @TABLE_NAME = 'DM_PLN_BP_FCST_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'DM_PLN_BP_FCST_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM dbo.DM_PLN_BP_FCST_C A WITH(INDEX(PK_DM_PLN_BP_FCST_C),NOLOCK)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD,DIVISION_ID,VERSION_NO

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_BP_FCST_REPORT_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'DM_PLN_BP_FCST_REPORT_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM  dbo.DM_PLN_BP_FCST_REPORT_C A   with (nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_CFM_MKT_DEMAND_PLAN_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'DM_PLN_CFM_MKT_DEMAND_PLAN_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A with (nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_CFM_SELLING_PRICE_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )

                    -- 오픈 시 PLAN_START_YYYYMMDD 로 기간 설정 되어
                    -- CUTOFF로 변경
                    -- 아래에 CUTOFF_TO 입력 하는 것 있음
                    SELECT
                         'DM_PLN_CFM_SELLING_PRICE_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_CFM_SELLING_PRICE_C A  with (nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID



                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_MKT_FCST_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'DM_PLN_MKT_FCST_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_MKT_FCST_C A WITH(INDEX(IX03_DM_PLN_MKT_FCST_C),nolock)
                    where CUTOFF_YYYYMMDD >= @CUTOFF_START --PK없음
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_MKT_FCST_RESULT_C'
                    BEGIN


                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'DM_PLN_MKT_FCST_RESULT_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_MKT_FCST_RESULT_C A WITH(INDEX(PK_DM_PLN_MKT_FCST_RESULT_C_PART),nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND A.CUTOFF_TYPE   >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID


                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_SALES_ETC_PLAN_C'
                    BEGIN
                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT 'DM_PLN_SALES_ETC_PLAN_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_SALES_ETC_PLAN_C A with (nolock)
                    where CUTOFF_YYYYMMDD >= @CUTOFF_START --PK 없음
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_SALES_ETC_REPORT_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'DM_PLN_SALES_ETC_REPORT_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_SALES_ETC_REPORT_C A  with (nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_SALES_PLAN_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'DM_PLN_SALES_PLAN_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_SALES_PLAN_C A  WITH (INDEX(PK_dm_pln_sales_plan_c_part),NOLOCK)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID

                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_SALES_PLAN_REPORT_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'DM_PLN_SALES_PLAN_REPORT_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_SALES_PLAN_REPORT_C A  WITH (INDEX(PK_DM_PLN_SALES_PLAN_REPORT_C),NOLOCK)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'DM_PLN_SALES_PLAN_RESULT_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'DM_PLN_SALES_PLAN_RESULT_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','-'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, '-'
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                    FROM DM_PLN_SALES_PLAN_RESULT_C A  with (nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID

                    SET @n_log_count = @@rowCount;
                    SET @MAPPING_RESULT = 'Y';
                    END

                ELSE IF @TABLE_NAME = 'SCM_MST_FUTURE_PRICE_C'
                    BEGIN

                    INSERT INTO NERP_CONV_DM_CUTOFF
                    (
                     TABLE_NAME
                    ,CUTOFF_COLUMN1,CUTOFF_COLUMN2,CUTOFF_COLUMN3,CUTOFF_COLUMN4
                    ,CUTOFF_FROM, CUTOFF_TO, CUTOFF_DIVISION, CUTOFF_PLAN_TYPE
                    ,ROWCNT,mapping_use
                    ,CREATE_DATE,CREATE_USER,UPDATE_DATE,UPDATE_USER
                    ,CUTOFF_SORT,CUTOFF_START
                    )
                    SELECT
                         'SCM_MST_FUTURE_PRICE_C'
                          ,'CUTOFF_YYYYMMDD','VERSION_NO','DIVISION_ID','CUTOFF_TYPE'
                          , CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, CUTOFF_TYPE
                          , count(*),'Y'
                          , getdate(), @CREATED_BY, getdate(), @CREATED_BY
                          , rank () over ( partition by 1 order by CUTOFF_YYYYMMDD desc) as rno
                          , @CUTOFF_START
                     FROM SCM_MST_FUTURE_PRICE_C A  with (nolock)
                    where A.DIVISION_ID   >= '0' --PK
                      AND A.VERSION_NO    >= '0' --PK
                      AND A.CUTOFF_TYPE   >= '0' --PK
                      AND CUTOFF_YYYYMMDD >= @CUTOFF_START
                      AND CUTOFF_YYYYMMDD < @CUTOFF_END
                    group by CUTOFF_YYYYMMDD, VERSION_NO, DIVISION_ID, CUTOFF_TYPE


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

            '@CNT = ' , @CNT
            , ' , @LOOKUP_TYPE = ', @TABLE_NAME
            , ' , @START_TIME = ' , @START_TIME
            , ' , @END_TIME = '   , @END_TIME
            , ' , @RUN_TIME = '   , @RUN_TIME
            );



           UPDATE NERP_CONV_DM_CUTOFF_MASTER
              SET MAPPING_START             = @START_TIME
                , MAPPING_END               = @END_TIME
                , MAPPING_TIME              = @RUN_TIME
                , mapping_RESULT            = 'FINISH'
                , CONVERT_ROW               = @n_log_count
            where TABLE_NAME                = @TABLE_NAME



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
