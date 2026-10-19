
/*
 * Program ID  : PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES
 * Description  : Batch Conversion One Table Case
 * Execute      :
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2024-08-13   vadabi5     NERP) Batch Conversion Loop Table Default
 * 20241007     vadabi5     NERP) SCM_DNM_MAT_DOCUMENT       : DM
                                  SCM_DNM_STOCK_SALES        : DM
                                  SCM_MST_SITE               : SALES ? DM / PLANT - SCP
                                  SCM_MST_SITE_CUSTOMER      : DM
                                  SCM_MST_SITE_ENG           : SCP
                                  SCM_MST_SITE_ITEM          : SALES ? DM / PLANT - SCP
                                  SCM_MST_SITE_ITEM_PRIORITY : SCP
 * 20241108     vadabi5     NERP) WAERS 추가
 * 20241108     vadabi5     NERP) PRCTR = PROFIT_CENTER_ID 추가
 * 20241111     vadabi5     NERP) MATKL, BKLAS 추가
 * 20241209     vadabi5     NERP) SCP_MST_PIC_INFO 제외
 * 20250417     김준규      NERP) SCP_MST_WORKING_TIME,SCP_ANL_WORKING_TIME 중복발생
                                 NERP_CONV_MASTER에서 VENDOR_ID, END_CUSTOMER_ID를 이전차수 제외토록 처리(순수 이전차수 이후 신규생성만 처리토록함)
 * 20250421     김준규      NERP) SCM_MST_SITE_ITEM_ENG 테이블 ENG_SCM_SITE_ID 가 LIKE 처리가 되어야 해서 아래 추가 작업하도록 처리 IF @TABLE_NAME = 'SCM_MST_SITE_ITEM_ENG'
 * 20250606     김준규      NERP) SCP_SITE_DESCRIPTION 의 DESC2 사용하는 것을 OLD_VALUE1 TO NEW_VALUE1로 사용하도록 변경
 * 20250607     김준규      NERP) SCM_MST_BOD_ENG 테이블 ENG_TO_SITE,ENG_FROM_SITE 가 LIKE 처리가 되어야 해서 아래 추가 작업하도록 처리 IF @TABLE_NAME = 'SCM_MST_BOD_ENG'
 * 20250607     김준규      NERP) SCP_PLN_ALLOCATION 테이블 FROM_SITE 가 LIKE 처리가 되어야 해서 아래 추가 작업하도록 처리 IF @TABLE_NAME = 'SCP_PLN_ALLOCATION'
 * 20250612     김준규      NERP) SCP_SITE_ID 가상법인 및 INCOTERMS 포함하는 것 생성보완 로직 막음
 * 20250718     김준규      NERP) SCM_MST_MODEL_BOM 에서 TOBE기준 중복발생으로 중복은 G182,G183중 G182삭제하고 작업하도록 변경
 * 20250805     김준규      NERP) SCP_MST_BOD WHERE FROM_SITE ='G184-E' 삭제 부탁드립니다
 * 20250831     김준규      NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임.
 * 20250916     김준규      NERP) 실제 CONVERSION에서 SCP_SITE_ID 가 누락됨.(추출쿼리는 되도록 변경되어 짐)
 * 20250924     김준규      NERP) PR_SCP_MST_CHAR_CAPA 프로시저 자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제

 ----------------------------------------------------------------------------------------------------
 EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES @P_TABLE='SCP_ANL_LONG_TERM_STOCK',@P_ROLLIN='3RD';
 EXEC PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES @P_TABLE='',@P_ROLLIN='3RD'; 최적화 보완 재실행
------------------------------------------------------------------------------
select *
from SCM_SYS_LOG_BATCH with (nolock)
where PROGRAM_NAME = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES'
and event_date > '2024-12-10'
order by event_date
------------------------------------------------------------------------------
SCP_MST_PIC_INFO
PK_SCP_MST_PIC_INFO 위반
중복 키를 삽입할 수 없습니다.
중복 키 값은 (HQ06, EMFL00259AA, 00217715)
------------------------------------------------------------------------------
--2025-04-17
SCP_MST_WORKING_TIME
PK_SCP_MST_WORKING_TIME 위반
중복 키를 삽입할 수 없습니다.
DIVISION_ID, PLANT_SITE_ID, FACTORY_ID, OPERATION_ID, LINE_ID, YYYYMMDD
중복 키 값은 (40, VN00188600_40-P, -, VN00188600, -, 20250101)
------------------------------------------------------------------------------
--2025-04-17
SCP_ANL_WORKING_TIME
PK_SCP_ANL_WORKING_TIME 위반
중복 키를 삽입할 수 없습니다.
DIVISION_ID, SCM_SITE_ID, OPERATION_ID, LINE_ID, YYYYMMDD
중복 키 값은 (40, VN00188600_40-P, VN00188600, -, 20250101)
------------------------------------------------------------------------------
--2025-07-18
SCM_MST_MODEL_BOM
PK_SCM_MST_MODEL_BOM 위반
중복 키를 삽입할 수 없습니다.
COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, MODEL_ID, CONCATENATE_ITEM
중복 키 값은 (NJ00, 40, A002, NJ01, APCAN0514A, APCAN0514A)
------------------------------------------------------------------------------


(40, VN00188600_40-P, -, VN00188600, -, 20250101)???.
(40, VN00188600_40-P, VN00188600, -, 20250101)???.


1, STORAGE_ID
2, BIGTable
3, CA
 */
CREATE PROCEDURE [dbo].[PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES]

 @P_TABLE nvarchar(100)
,@P_ROLLIN  nvarchar(30) --1ST 2ND 3RD 4TH

AS
BEGIN
    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','4N5')
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END

    DECLARE @NERP_THIRD_STAGE NVARCHAR(128);
    SET @NERP_THIRD_STAGE = '3'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASRXDTE','3,5');--알디 에스티
    --
    IF @P_ROLLIN = @NERP_THIRD_STAGE
    BEGIN
        UPDATE SCM_LGTM_MRP_P_RESULT
        SET  COMPANY_ID = 'NB00'
        ,[SUPPLIER_ID] = 'KR002150'
        WHERE [SUPPLIER_ID]= 'G180,KR002150';
    END;

    DECLARE @TABLE_NAME   NVARCHAR(150) = N'';
    SET @TABLE_NAME = @P_TABLE
    DECLARE @TABLE_NAME_NEW   NVARCHAR(150) = N'';
    DECLARE @COL_INFO   NVARCHAR(150) = N'';
    DECLARE @V_UPD_YN_SCM_MST_SITE_ITEM_ENG NVARCHAR(1)=N'N';
    DECLARE @V_UPD_YN_SCM_MST_BOD_ENG NVARCHAR(1)=N'N';
    DECLARE @V_UPD_YN_SCP_PLN_ALLOCATION NVARCHAR(1)=N'N';
    DECLARE @DEL_BOM_DUP_YN NVARCHAR(1)='N';

    DECLARE @CNT INT;
    DECLARE @ACT_CNT INT;
    DECLARE @WORK_SECOND INT;

    DECLARE @SELECT_COL NVARCHAR(MAX);
    DECLARE @mEXEC NVARCHAR(MAX);
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @BACKUP_END_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_START_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_END_TIME  NVARCHAR(50) = N'';
    DECLARE @MAPPING_TIME  BIGINT = 0;
    DECLARE @COLUMN_NAME  NVARCHAR(50) = N'';
    DECLARE @CREATED_BY NVARCHAR(300)= 'NERP_SCP_'+@P_ROLLIN;
    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저 자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';  


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
    DECLARE @DUMMY1 VARCHAR(254);


    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    --DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_NERP_COLUMN_CONVERTER_UPDATE_TABLES';
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
    SET @v_log_message = 'ALL';
    SET @v_description = '@P_TABLE:'+@P_TABLE+',@P_ROLLIN:'+@P_ROLLIN;;
    SET @d_event_date = SYSDATETIME();
    set @BATCH_START_TIME = getdate();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'START', 0, @v_log_message,  @v_description, @d_event_date;
    PRINT CONCAT( 'START = ', @BATCH_START_TIME)


BEGIN TRY


--################################################################################################################
--STEP 2. Mapping
--################################################################################################################
SET @BATCH_START_TIME = getdate();
DECLARE @QUERY NVARCHAR(MAX) = '';
DECLARE @START_TIME DATETIME;
DECLARE @END_TIME DATETIME;
DECLARE @TIME_DIFF BIGINT


--################################################################################################################
--#TMP_CUSTOMER_PLANT_COMPANY
--################################################################################################################
        -- 37889
        -- 중복 B100',C100,G480
        SELECT distinct asis_cd, tobe_cd
        INTO #TMP_CUSTOMER_PLANT_COMPANY
        from
        (
            SELECT ASIS_CD
                  ,TOBE_CD
                  ,GUBUN
                  , rank () over (partition by ASIS_CD order by GUBUN) AS RNO
            FROM
            (
                    SELECT 2 AS GUBUN
                         , OLD_VALUE1 AS ASIS_CD
                         , NEW_VALUE1 AS TOBE_CD
                    FROM NERP_CONV_MASTER_CFM_V
                    WHERE CODETYPE = 'PLANT_ID'
                    AND ATTRIBUTE5 = @P_ROLLIN
                    UNION
                    SELECT 1 AS GUBUN
                         , OLD_VALUE1 AS ASIS_CD
                         , NEW_VALUE1 AS TOBE_CD
                    FROM NERP_CONV_MASTER_CFM_V
                    WHERE CODETYPE = 'END_CUSTOMER_ID'
                    AND ATTRIBUTE5 = @P_ROLLIN
            ) list
        ) list2
        where rno = 1
         and isnull(asis_cd,'') != ''
       --and asis_cd in ('B100','C100','G480')
       order by asis_Cd



--################################################################################################################
--##TMP_VENDOR_PLANT_COMPANY
--################################################################################################################
        -- 53616
        -- 중복 B100',C100,G480
        SELECT distinct asis_cd, tobe_cd
        INTO #TMP_VENDOR_PLANT_COMPANY
        from
        (
            SELECT ASIS_CD
                  ,TOBE_CD
                  ,GUBUN
                  , rank () over (partition by ASIS_CD order by GUBUN) AS RNO
            FROM
            (       SELECT 3 AS GUBUN
                         , OLD_VALUE1 AS ASIS_CD
                         , NEW_VALUE1 AS TOBE_CD
                    FROM NERP_CONV_MASTER_CFM_V
                    WHERE CODETYPE = 'COMPANY_ID'
                    AND ATTRIBUTE5 = @P_ROLLIN

                    UNION
                    SELECT 2 AS GUBUN
                         , OLD_VALUE1 AS ASIS_CD
                         , NEW_VALUE1 AS TOBE_CD
                    FROM NERP_CONV_MASTER_CFM_V
                    WHERE CODETYPE = 'PLANT_ID'
                    AND ATTRIBUTE5 = @P_ROLLIN

                    UNION
                    SELECT 1 AS GUBUN
                         , OLD_VALUE1 AS ASIS_CD
                         , NEW_VALUE1 AS TOBE_CD
                    FROM NERP_CONV_MASTER_CFM_V
                    WHERE CODETYPE = 'VENDOR_ID'
                    AND ATTRIBUTE5 = @P_ROLLIN
            ) list
        ) list2
        where rno = 1
         and isnull(asis_cd,'') != ''
       --and asis_cd in ('B100','C100','G480')
       order by asis_Cd


--########################################################################################################
-- OPEN CURSOR_BACKUP
--########################################################################################################
-- 커서가 이미 열려 있는지 확인
IF CURSOR_STATUS('global', 'CURSOR_BACKUP') >= 0
BEGIN
    CLOSE CURSOR_BACKUP;
    DEALLOCATE CURSOR_BACKUP;
END
DECLARE CURSOR_BACKUP CURSOR FOR


            --####################################################
            -- Loop List
            --####################################################
               --DECLARE @P_TABLE NVARCHAR(100) = 'SCM_MST_BOD_ENG';

               SELECT program_id AS TABLE_NAME
                   , dev_detail as COLUMN_NAME
                   , MAPPING_COLUMN as MAPPING_COLUMN
                    --,mapping_use
                    --,PROD_TABLE_CNT
                    ,ROW_NUMBER()OVER(PARTITION BY program_id,dev_detail ORDER BY CASE WHEN MAPPING_COLUMN IN ( 'END_CUSTOMER_ID','VENDOR_ID') THEN 1
                            WHEN MAPPING_COLUMN IN ( 'SCP_SITE_ID','SCM_SITE_ID', 'SCM_SITE_DESCRIPTION', 'PACKER_CODE', 'PSI_VALUE') THEN 2
                            WHEN MAPPING_COLUMN IN ( 'PLANT_ID', 'PLANT_VENDOR','PLANT_DESCRIPTION') THEN 3
                            WHEN MAPPING_COLUMN = 'COMPANY_ID' THEN 4
                           ELSE 99 END) RNUM
                 FROM ZNERP_DEV_ITEM_SCHEDULE WITH (NOLOCK)
                where DEV_TYPE = 'Batch_Conversion'
                --and mapping_use IN ( 'UP', 'CA','IC','BG', 'IN', 'LK')
                --and mapping_use IN ( 'UP', 'CA', 'BG')
                and mapping_use IN ( 'UP' ,'CA', 'OZ') -- 20250831 김준규 NERP) 최적화 18개 테이블 추가 MAPPING_USE : OZ 임.
                --and ISNULL(MAPPING_COMMENT,'') != 'FINISH'
                --and mapping_column  in ('COMPANY_ID','PLANT_ID','END_CUSTOMER_ID','VENDOR_ID','SCM_SITE_ID', 'SCM_SITE_DESCRIPTION', 'PACKER_CODE', 'PSI_VALUE','STORAGE_ID')
                and mapping_column  in ('COMPANY_ID','PLANT_ID','END_CUSTOMER_ID','VENDOR_ID','SCM_SITE_ID','SCP_SITE_ID', 'SCM_SITE_DESCRIPTION', 'PACKER_CODE', 'PSI_VALUE', 'PLANT_VENDOR','PLANT_DESCRIPTION', 'WAERS','PRCTR')  -- STORAGE 별도 처리
                and dev_detail != 'INCOTERMS'
                --and program_id != 'SCP_MST_NO_USE_3M'
                --and program_id = 'SCP_ANL_PSI_INTEGRATION_ESS'
                --and program_id = @P_TABLE  --SCP_ANL_PSI_INTEGRATION
                --and PROD_TABLE_CNT < 220000
                --and PROD_TABLE_CNT < 1000000
                --and program_id ='SCP_MST_PIC_INFO'
                --and program_id ='SCP_ANL_SUPPLY_PSI_REPORT_ESS'
                --and mapping_column = 'SCM_SITE_ID'
                and (@P_TABLE IS NULL OR @P_TABLE ='' OR program_id = @P_TABLE)
                order by PROD_TABLE_CNT,TABLE_NAME,RNUM




OPEN CURSOR_BACKUP;
FETCH NEXT FROM CURSOR_BACKUP
INTO @TABLE_NAME,@COLUMN_NAME,@MAPPING_COLUMN,@DUMMY1;
WHILE @@FETCH_STATUS = 0
BEGIN

                SET @START_TIME = getdate();

                print '####################################################################'
                print concat(@TABLE_NAME, ' , ', @COLUMN_NAME, ' , ', @MAPPING_COLUMN)
                print '####################################################################'

                    --################################################################
                    -- 중복데이터 삭제 후 처리
                    --################################################################
                    --2025-07-18 SCM_MST_MODEL_BOM 중복에러 발생
                    IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' AND @P_ROLLIN = '3RD' AND @DEL_BOM_DUP_YN = 'N'
                    --3차의 경우는 PLANT_ID DESC 이 중요하다. 큰것 남기고 작은 것 삭제. 3차는 작은것 삭제
                    BEGIN
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
                                  , A.*
                                   ,NC1.NEW_VALUE1 AS TOBE_COMPANY_ID
                                   ,NP1.NEW_VALUE1 AS TOBE_PLANT_ID
                                   ,ROW_NUMBER()OVER(PARTITION BY ISNULL(NC1.NEW_VALUE1,COMPANY_ID), DIVISION_ID, SITE_ID, ISNULL(NP1.NEW_VALUE1,PLANT_ID), MODEL_ID, CONCATENATE_ITEM
                                                     ORDER BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID DESC, MODEL_ID, CONCATENATE_ITEM) AS RNUM
                                FROM SCM_MST_MODEL_BOM A WITH (NOLOCK)
                                LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'COMPANY_ID' and ATTRIBUTE5 = @P_ROLLIN) NC1 ON A.COMPANY_ID = NC1.OLD_VALUE1
                                LEFT JOIN (SELECT DISTINCT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'PLANT_ID' and ATTRIBUTE5 = @P_ROLLIN) NP1 ON A.PLANT_ID = NP1.OLD_VALUE1
                                WHERE 1=1
                                AND   (NC1.NEW_VALUE1 IS NOT NULL OR NP1.NEW_VALUE1 IS NOT NULL)
                          ) 
                          DELETE MBE
                          FROM   W_RAW AS WR
                          JOIN   SCM_MST_MODEL_BOM AS MBE
                          ON     WR.RNUM >1
                          AND    MBE.COMPANY_ID       = WR.COMPANY_ID
                          AND    MBE.DIVISION_ID      = WR.DIVISION_ID     
                          AND    MBE.SITE_ID          = WR.SITE_ID         
                          AND    MBE.PLANT_ID         = WR.PLANT_ID        
                          AND    MBE.MODEL_ID         = WR.MODEL_ID        
                          AND    MBE.CONCATENATE_ITEM = WR.CONCATENATE_ITEM
                          ;
                        
                        PRINT @TABLE_NAME+' Duplecate Deleted :'+CONVERT(NVARCHAR(30),@@ROWCOUNT);

                        SET @DEL_BOM_DUP_YN = 'Y';
                    END;

            SET @mSubQuery = '';

            IF @MAPPING_COLUMN = 'COMPANY_ID'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = ''COMPANY_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' ) AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END

            ELSE IF @MAPPING_COLUMN = 'PLANT_ID'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);

                -- plant 에osp = vendor 값이 있는 테이블이 잇음
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = ''VENDOR_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);


            END

            ELSE IF @MAPPING_COLUMN = 'END_CUSTOMER_ID'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.TOBE_CD ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE1 AS ASIS_CD, NEW_VALUE1 AS TOBE_CD FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = ''END_CUSTOMER_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.ASIS_CD  ' +CHAR(10);
            END

            ELSE IF @MAPPING_COLUMN = 'VENDOR_ID' OR @MAPPING_COLUMN = 'PLANT_VENDOR'
            BEGIN
                -- SUPPLIER_CODE = B100_STHQ05
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.TOBE_CD ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
              --SET @mSubQuery = @mSubQuery + ' (SELECT ASIS_CD, TOBE_CD FROM #TMP_CUSTOMER_PLANT_COMPANY ) AS B ' +CHAR(10);
              --2025-06-07 PLANT_ID 추가
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE1 AS ASIS_CD, NEW_VALUE1 AS TOBE_CD FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE IN ( ''PLANT_ID'',''VENDOR_ID'' ) AND ATTRIBUTE5='''+@P_ROLLIN+''' ) AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.ASIS_CD  ' +CHAR(10);
            END


            --[NERP_CONV_MASTER_CFM_V SCP_SITE_ID] or [NERP_CONV_SCP_SCM_SITE_ID.PSI_VALUE]
            ELSE IF @MAPPING_COLUMN = 'SCM_SITE_ID'
                 OR @MAPPING_COLUMN = 'SCP_SITE_ID'
                 OR @MAPPING_COLUMN = 'PSI_VALUE'
                 OR @MAPPING_COLUMN = 'PACKER_CODE'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + '    SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + '  FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ( ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' select distinct                             ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '        OLD_VALUE1                           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '      , NEW_VALUE1                           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' from NERP_CONV_MASTER_CFM_V with (nolock)           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' where codetype = ''SCP_SITE_ID''            ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' and ATTRIBUTE5 = '''+@P_ROLLIN+'''                    ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ) B                                         ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END



            -- NERP_CONV_SCP_SCM_SITE_ID.SCM_SITE_DESCRIPTION -> NERP_CONV_MASTER_CFM_V.SCP_SITE_DESCRIPTION
            -- desc1, desc2
            -- OLD_VALUE1 = 40글자만 가능 = 짤림
            ELSE IF @MAPPING_COLUMN = 'SCM_SITE_DESCRIPTION'
                 or @MAPPING_COLUMN = 'PLANT_DESCRIPTION'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + '    SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + '  FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ( ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' select distinct                             ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '        OLD_VALUE1                           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '      , NEW_VALUE1                           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' from NERP_CONV_MASTER_CFM_V with (nolock)           ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' where codetype = ''SCP_SITE_DESCRIPTION''            ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' and ATTRIBUTE5 = '''+@P_ROLLIN+'''                    ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' ) B                                         ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END

            ELSE IF @MAPPING_COLUMN = 'PLANT_DESCRIPTION'
            BEGIN
                PRINT 'no use PLANT_DESCRIPTION'
                --SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                --SET @mSubQuery = @mSubQuery + '    SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '  FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' ( ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' select distinct                               ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '        OLD_VALUE1                         ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '      , NEW_VALUE1                         ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' from NERP_CONV_SCP_SCM_SITE_ID with (nolock) ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' where mapping_column = ''PLANT_DESCRIPTION''      ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' and isnull(new_value1,'''') != ''''           ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' and old_value1 != isnull(new_value1,'''') ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' ) B                                           ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END

            -- 사용안함 -> SCM_SITE_ID 단, 사용코드가 적어 속도는 유리
            ELSE IF @MAPPING_COLUMN = 'PSI_VALUE'
            BEGIN
                PRINT 'NO USE PSI_VALUE'
                --SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                --SET @mSubQuery = @mSubQuery + '    SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '  FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' ( ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' select distinct                               ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '        OLD_VALUE1                         ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '      , NEW_VALUE1                         ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' from NERP_CONV_SCP_SCM_SITE_ID with (nolock) ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' where mapping_column = ''PSI_VALUE''      ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' and isnull(new_value1,'''') != ''''           ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' and old_value1 != isnull(new_value1,'''') ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' ) B                                           ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END

            -- 사용안함 -> SCM_SITE_ID 단, 사용코드가 적어 속도는 유리
            ELSE IF @MAPPING_COLUMN = 'PACKER_CODE'
            BEGIN
                print 'NO USE PACKER_CODE'
                --SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                --SET @mSubQuery = @mSubQuery + '    SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '  FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' ( ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' select distinct                               ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '        OLD_VALUE1                         ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + '      , NEW_VALUE1                         ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' from NERP_CONV_SCP_SCM_SITE_ID with (nolock)' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' where mapping_column = ''PACKER_CODE''        ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' and isnull(new_value1,'''') != ''''           ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' and old_value1 != isnull(new_value1,'''') ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' ) B                                           ' +CHAR(10);
                --SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END

            ELSE IF @MAPPING_COLUMN = 'WAERS'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE1 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = ''WAERS'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' ) AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE1  ' +CHAR(10);
            END

            ELSE IF @MAPPING_COLUMN = 'PROFIT_CENTER_ID'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE2 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT OLD_VALUE2, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = ''PROFIT_CENTER_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' ) AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.'+ @COLUMN_NAME + ' = B.OLD_VALUE2  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' AND PLANT_ID IN (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') ' +CHAR(10);
            END

            -- ITEM_ID, MATKL
            ELSE IF @MAPPING_COLUMN = 'MATKL'
            BEGIN
                SET @mSubQuery = @mSubQuery + ' UPDATE.'+ @TABLE_NAME + CHAR(10);
                SET @mSubQuery = @mSubQuery + ' SET.'+ @TABLE_NAME + '.' + @COLUMN_NAME + ' = B.NEW_VALUE2 ' +CHAR(10);
                IF @TABLE_NAME IN ('SCP_ANL_PRODUCTION_PLAN_TARGET','SCP_ANL_SUPPLY_PSI_REPORT_ESS') BEGIN
                    --UPDATE 컬럼이 존재하지 않음
                    SET @TIME_DIFF = 0
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_MPP' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_by = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'up_dttm = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_DNM_STOCK_PUR' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_ALTER_BOM_MODEL' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_MST_MODEL_BOM' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_ID = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDATE_TIME = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCM_SHIP_ALLO_REPORT' BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDUSER = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'UPDDTTM = GETDATE()  ' +CHAR(10);
                    END
                ELSE IF @TABLE_NAME = 'SCP_MST_CHAR_CAPA' BEGIN
                    --2025-09-24 김준규 PR_SCP_MST_CHAR_CAPA 프로시저   자동생성된 SCP_MST_CHAR_CAPA 데이터 삭제  자동생성된 데이터 삭제: created_by, last_updated_by 가 'scp_batch' 인 데이터만 삭제
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@v_batch_user+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                ELSE BEGIN
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATED_BY = '''+@CREATED_BY+''' ' +CHAR(10);
                    SET @mSubQuery = @mSubQuery + '    ,'+ @TABLE_NAME + '.' + 'LAST_UPDATE_DATE = GETDATE()  ' +CHAR(10);
                    END
                SET @mSubQuery = @mSubQuery + ' FROM .'+ @TABLE_NAME + ' AS A, ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' (SELECT NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = ''MATKL'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''' ) AS B ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + ' WHERE A.ITEM_ID = B.NEW_VALUE1  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '   AND ISNULL(B.NEW_VALUE2,'') != ''  ' +CHAR(10);
                SET @mSubQuery = @mSubQuery + '   AND PLANT_ID IN (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = ''PLANT_ID'' AND ATTRIBUTE5 = '''+@P_ROLLIN+''') ' +CHAR(10);

            END

            -- valuation_class SCP_ANL_LONG_TERM_STOCK ONLY
            ELSE IF @MAPPING_COLUMN = 'BKLAS'
            BEGIN

            --drop table #TMP_SCP_ANL_LONG_TERM_STOCK
            --drop table #TMP_SCP_ANL_LONG_TERM_STOCK_BKLAS

                        -- 322596 29초
                        -- 851905
                        select YYYYMM,  PLANT_ID, DIVISION_ID, item_id, A.matkl, VALUATION_CLASS
                        INTO #TMP_SCP_ANL_LONG_TERM_STOCK
                        from SCP_ANL_LONG_TERM_STOCK A

                        select YYYYMM,  PLANT_ID, DIVISION_ID, item_id, A.matkl, VALUATION_CLASS
                             ,CASE
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RE01' THEN '3001'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RE02' THEN '3002'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RA01' THEN '3003'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RA02' THEN '3004'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl like 'RP%' THEN '3005'

                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl = 'RE02' THEN '3002'
                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl = 'RA01' THEN '3003'
                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl = 'RA02' THEN '3004'
                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl like 'RP%' THEN '3005'
                               WHEN A.VALUATION_CLASS = '3001' THEN '3000'
                               ELSE A.VALUATION_CLASS
                               END AS BKLAS

                              ,CASE
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RE01' THEN 'Y1'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RE02' THEN 'Y2'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RA01' THEN 'Y3'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl = 'RA02' THEN 'Y4'
                               WHEN A.VALUATION_CLASS = '3000' AND A.matkl like 'RP%' THEN 'Y5'

                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl = 'RE02' THEN 'Y6'
                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl = 'RA01' THEN 'Y7'
                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl = 'RA02' THEN 'Y8'
                               WHEN A.VALUATION_CLASS = '3001' AND A.matkl like 'RP%' THEN 'Y9'
                               WHEN A.VALUATION_CLASS = '3001' THEN 'Y10'
                               ELSE 'N'
                               END AS BKLAS_CHANGE
                        INTO #TMP_SCP_ANL_LONG_TERM_STOCK_BKLAS
                        from #TMP_SCP_ANL_LONG_TERM_STOCK A
                        LEFT JOIN (
                                SELECT OLD_VALUE1, NEW_VALUE1
                                FROM NERP_CONV_MASTER_CFM_V
                                WHERE CODETYPE = 'BKLAS' AND ATTRIBUTE5 = @P_ROLLIN AND OLD_VALUE1 !=NEW_VALUE1
                        ) B
                        ON A.VALUATION_CLASS = B.OLD_VALUE1
                        WHERE  VALUATION_CLASS IN (SELECT OLD_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'BKLAS' AND ATTRIBUTE5 = @P_ROLLIN AND OLD_VALUE1 !=NEW_VALUE1 )
                        and MATKL LIKE 'R%'
                        AND PLANT_ID IN (SELECT NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V with (nolock) WHERE CODETYPE = 'PLANT_ID' AND ATTRIBUTE5 = @P_ROLLIN)



                        update SCP_ANL_LONG_TERM_STOCK
                        SET .SCP_ANL_LONG_TERM_STOCK.VALUATION_CLASS = B.BKLAS
                           ,.SCP_ANL_LONG_TERM_STOCK.LAST_UPDATED_BY = @CREATED_BY
                           ,.SCP_ANL_LONG_TERM_STOCK.LAST_UPDATE_DATE = GETDATE()
                        FROM .SCP_ANL_LONG_TERM_STOCK AS A,
                        (SELECT YYYYMM,PLANT_ID,DIVISION_ID,item_id,matkl,VALUATION_CLASS,BKLAS,BKLAS_CHANGE FROM #TMP_SCP_ANL_LONG_TERM_STOCK_BKLAS WHERE BKLAS_CHANGE LIKE 'Y%') AS B
                        WHERE    A.YYYYMM = B.YYYYMM
                            AND  A.PLANT_ID = B.PLANT_ID
                            AND  A.DIVISION_ID = B.DIVISION_ID
                            AND  A.item_id = B.item_id
                            AND  A.matkl = B.matkl
                            AND  A.VALUATION_CLASS = B.VALUATION_CLASS


                            -- 202409
                            --select max(YYYYMM) from SCP_ANL_LONG_TERM_STOCK


            END


            -- AFFILIATE_CODE -> VENDOR_ID
            -- SALES_ORG 실질 변경 대상 데이터 없음
            -- VENDOR_CUSTOMER 사용 없음
            -- COMPANY_ID_NAME SCP_MST_NO_USE_3M 사실상 대상 제외 계속 판단은 필요
            -- PLANT_VENDOR VENDOR 로 변경
            -- COMPANY_PLANT_VENDOR_CUSTOMER 사용 안함
            -- ANLKL VENDOR_ID 로 적용
            ELSE IF @MAPPING_COLUMN = 'AFFILIATE_CODE'
                  OR @MAPPING_COLUMN = 'SALES_ORG'
                  OR @MAPPING_COLUMN = 'VENDOR_CUSTOMER'
                  OR @MAPPING_COLUMN = 'COMPANY_ID_NAME'
                  OR @MAPPING_COLUMN = 'PLANT_VENDOR'
                  OR @MAPPING_COLUMN = 'COMPANY_PLANT_VENDOR_CUSTOMER'
                  OR @MAPPING_COLUMN = 'ANLKL'
            BEGIN
                SET @mSubQuery = @mSubQuery + '' + CHAR(10);
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
                    --ROLLBACK TRANSACTION;
                    --SET @DUMMY1 = N''+@P_ROLLIN+','+ concat(@TABLE_NAME, ' , ', @COLUMN_NAME, ' , ', @MAPPING_COLUMN) + ERROR_MESSAGE()
                    SET @DUMMY1 = SUBSTRING( N''+N'ERROR1,'+ISNULL(@P_ROLLIN,'')+','+ ISNULL(@TABLE_NAME,'')+ ' , '+ ISNULL(@COLUMN_NAME,'')+ ' , '+ ISNULL(@MAPPING_COLUMN,'') + ERROR_MESSAGE(),1,500)
                    print @DUMMY1
                    SET @CNT = ISNULL(@CNT,0);
                    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, '0', @DUMMY1, @d_event_date;
                END CATCH
            END

            --2025-06-12 SCP_SITE_ID 가상법인 및 INCOTERMS 포함하는 것 생성보완 아래 막음
            --2025-04-21 ENG_SCM_SITE_ID 가 LIKE 처리가 되어야 해서 아래 추가 작업하도록 처리
            --IF @TABLE_NAME = 'SCM_MST_SITE_ITEM_ENG' AND @V_UPD_YN_SCM_MST_SITE_ITEM_ENG = 'N'
            --BEGIN
            --    DECLARE @SQL NVARCHAR(MAX) = N'
            --    UPDATE SIE
            --    SET    SIE.ENG_SCM_SITE_ID = REPLACE(SIE.ENG_SCM_SITE_ID,MCV.OLD_VALUE1,MCV.NEW_VALUE1)
            --    FROM   SCM_MST_SITE_ITEM_ENG SIE WITH(NOLOCK)
            --    LEFT  JOIN  NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
            --    ON    MCV.CODETYPE = ''SCP_SITE_ID'' AND MCV.ATTRIBUTE5 = '''+@P_ROLLIN+''' AND SIE.ENG_SCM_SITE_ID LIKE ''%''+MCV.OLD_VALUE1+''%''
            --    WHERE LEN(MCV.NEW_VALUE1)>6;';
            --    BEGIN TRY
            --        BEGIN TRANSACTION;
            --            PRINT @SQL;
            --            EXEC sp_executesql @SQL;
            --        COMMIT TRANSACTION;
            --        SET @V_UPD_YN_SCM_MST_SITE_ITEM_ENG = N'Y';
            --    END TRY
            --    BEGIN CATCH
            --        IF @@TRANCOUNT > 0
            --            ROLLBACK TRANSACTION;
            --        SET @DUMMY1 = N''+@P_ROLLIN+','+ @SQL + ERROR_MESSAGE()
            --        print @DUMMY1
            --        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, '0', @DUMMY1, @d_event_date;
            --    END CATCH
            --END
            ----2025-04-21 ENG_SCM_SITE_ID 가 LIKE 처리가 되어야 해서 아래 추가 작업하도록 처리
            --IF @TABLE_NAME = 'SCM_MST_BOD_ENG' AND @V_UPD_YN_SCM_MST_BOD_ENG = 'N'
            --BEGIN
            --    --DECLARE @SQL NVARCHAR(MAX) = N'
            --    SET @SQL = N'
            --    UPDATE SIE
            --    SET    SIE.ENG_TO_SITE = REPLACE(SIE.ENG_TO_SITE,MCV.OLD_VALUE1,MCV.NEW_VALUE1)
            --    FROM   SCM_MST_BOD_ENG SIE WITH(NOLOCK)
            --    LEFT  JOIN  NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
            --    ON    MCV.CODETYPE = ''SCP_SITE_ID'' AND MCV.ATTRIBUTE5 = '''+@P_ROLLIN+''' AND SIE.ENG_TO_SITE LIKE ''%''+MCV.OLD_VALUE1+''%''
            --    WHERE LEN(MCV.NEW_VALUE1)>6;
            --    UPDATE SIE
            --    SET    SIE.ENG_FROM_SITE = REPLACE(SIE.ENG_FROM_SITE,MCV.OLD_VALUE1,MCV.NEW_VALUE1)
            --    FROM   SCM_MST_BOD_ENG SIE WITH(NOLOCK)
            --    LEFT  JOIN  NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
            --    ON    MCV.CODETYPE = ''SCP_SITE_ID'' AND MCV.ATTRIBUTE5 = '''+@P_ROLLIN+''' AND SIE.ENG_FROM_SITE LIKE ''%''+MCV.OLD_VALUE1+''%''
            --    WHERE LEN(MCV.NEW_VALUE1)>6;';
            --    BEGIN TRY
            --        BEGIN TRANSACTION;
            --            PRINT @SQL;
            --            EXEC sp_executesql @SQL;
            --        COMMIT TRANSACTION;
            --        SET @V_UPD_YN_SCM_MST_BOD_ENG = N'Y';
            --    END TRY
            --    BEGIN CATCH
            --        IF @@TRANCOUNT > 0
            --            ROLLBACK TRANSACTION;
            --        SET @DUMMY1 = N''+@P_ROLLIN+','+ @SQL + ERROR_MESSAGE()
            --        print @DUMMY1
            --        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, '0', @DUMMY1, @d_event_date;
            --    END CATCH
            --END

            ----2025-04-21 ENG_SCM_SITE_ID 가 LIKE 처리가 되어야 해서 아래 추가 작업하도록 처리
            --IF @TABLE_NAME = 'SCP_PLN_ALLOCATION' AND @V_UPD_YN_SCP_PLN_ALLOCATION = 'N'
            --BEGIN
            --    --DECLARE @SQL NVARCHAR(MAX) = N'
            --    SET @SQL = N'
            --    UPDATE SIE
            --    SET    SIE.FROM_SITE = REPLACE(SIE.FROM_SITE,MCV.OLD_VALUE1,MCV.NEW_VALUE1)
            --    FROM   SCP_PLN_ALLOCATION SIE WITH(NOLOCK)
            --    LEFT  JOIN  NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
            --    ON    MCV.CODETYPE = ''SCP_SITE_ID'' AND MCV.ATTRIBUTE5 = '''+@P_ROLLIN+''' AND SIE.FROM_SITE LIKE ''%''+MCV.OLD_VALUE1+''%''
            --    WHERE LEN(MCV.NEW_VALUE1)>6;';
            --    BEGIN TRY
            --        BEGIN TRANSACTION;
            --            PRINT @SQL;
            --            EXEC sp_executesql @SQL;
            --        COMMIT TRANSACTION;
            --        SET @V_UPD_YN_SCP_PLN_ALLOCATION = N'Y';
            --    END TRY
            --    BEGIN CATCH
            --        IF @@TRANCOUNT > 0
            --            ROLLBACK TRANSACTION;
            --        SET @DUMMY1 = N''+@P_ROLLIN+','+ @SQL + ERROR_MESSAGE()
            --        print @DUMMY1
            --        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, '0', @DUMMY1, @d_event_date;
            --    END CATCH
            --END

            --####################################################
            -- Result
            --####################################################
                SET @MAPPING_TIME = DATEDIFF(SECOND, @START_TIME, GETDATE() );

                UPDATE ZNERP_DEV_ITEM_SCHEDULE
                SET MAPPING_START = @START_TIME
                    , MAPPING_END = GETDATE()
                    , MAPPING_TIME = @MAPPING_TIME
                    , MAPPING_QUERY = @MSUBQUERY
                    , CHECK_QUERY = @@TRANCOUNT
                    , MAPPING_COMMENT = 'FINISH'
                WHERE PROGRAM_ID = @TABLE_NAME
                AND DEV_DETAIL = @COLUMN_NAME
                AND MAPPING_COLUMN = @MAPPING_COLUMN

                PRINT CONCAT(@@TRANCOUNT, ' , ', @@TRANCOUNT)
                EXEC PR_SCM_SYS_LOG_BATCH @V_PROGRAM_NAME, @TABLE_NAME, @MAPPING_TIME, @COLUMN_NAME, @MSUBQUERY, @D_EVENT_DATE;



FETCH NEXT FROM CURSOR_BACKUP
INTO @TABLE_NAME,@COLUMN_NAME,@MAPPING_COLUMN,@DUMMY1;
END

CLOSE CURSOR_BACKUP;
DEALLOCATE CURSOR_BACKUP;


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
        print @v_description
        SET @DUMMY1 = SUBSTRING( N''+N'ERROR2,'+ISNULL(@P_ROLLIN,'')+','+ ISNULL(@TABLE_NAME,'')+ ' , '+ ISNULL(@COLUMN_NAME,'')+ ' , '+ ISNULL(@MAPPING_COLUMN,'') + ERROR_MESSAGE(),1,500)
        print @DUMMY1
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, 'ERROR', @CNT, @WORK_SECOND, @DUMMY1, @d_event_date;
END CATCH

END
