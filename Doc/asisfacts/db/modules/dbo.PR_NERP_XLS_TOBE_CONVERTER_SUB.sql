







-- =============================================
-- Author:       P.C.I
-- Create date:  2024-06-13
-- Description: XLS to DEV db conversion table - PR_NERP_XLS_TO_CONVERTER_SUB 참조수정(ZNERP_TOBE_CODE_INFO)
-- EXEC PR_SCM_SYS_RFC_CALL_NERP 'ZCMCM_AS_TOBE_CODE_INFO'--,'HQ00'
-- EXEC PR_NERP_XLS_TOBE_CONVERTER @p_rollin='3RD',@p_sys_type='ALL'
-- *===================================================================================================
-- *   Date       In Charge      Description
-- *===================================================================================================
-- * 2025.04.08   김준규          SCP용 추가 work_site, work_site_desc, work_cost_center, ROLLIN 차수 재정의
-- * 2025.04.08   김준규          LOG 추가 시작
-- * 2025.04.17   김준규          입력 변수로 ROLLIN 차수 입력받음(VENDOR_ID, END_CUSTOMER_ID는 이전차수 제외 하고 처리)
-- * 2025.05.26   김준규          ATTRIBUTE5가 JOIN KEY로 들어가야 중복에러 발생하지 않음, 수정함.
-- * 2025.05.26   김준규          ATTRIBUTE5가 입력 @p_rollin 보다 같거나 큰 것 기준으로 처리 되도록 변경
-- * 2025.05.26   김준규          삭제후 입력은 SCM_MST_SITE 값이 변경후에 DESC는 과거 값을 가져올 수가 없어서 최초 생성후 백업한것 다시 넣기
-- * 2025.06.02   김준규          END_CUSTOMER_ID의 1차 Open 기준 OLD_VALUE1 값의 길이가 4개 인 것 중
--                                COMPANY_ID에 있는 Open차수를 아는 것만 해당 Open 차 수 별로 추가하는 것으로 하겠습니다
-- * 2025.06.03   김준규          [SCM_MST_SITE] 테이블을 BACKUP_SCM_MST_SITE_PROD 테이블로 백업 받아 놓고 SCP_SITE_ID 생성시 사용
-- * 2025.06.06   김준규          [SCM_MST_SITE] 가상 DIVISION 추가, 백업 테이블 추가 BACKUP_SCM_MST_DIVISION_PROD, BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD
-- * 2025.06.12   김준규          [SCM_MST_SITE] 테이블을 BACKUP_SCM_MST_SITE_ENG_PROD 테이블로 백업 받아 놓고 SCP_SITE_ID 생성시 사용
-- * 2025.06.12   김준규          [SCM_MST_SITE] 영업 INCOTERMS 포함해서 나오도록 SCP_SITE_ID 생성(BACKUP_SCM_MST_SITE_ENG_PROD 활용)
-- * 2025.06.29   김준규          DB명 있는 것 제거(시노님사용) 그리고 디비링크를 텍스트 쿼리에서 나오지 않게 변경
-- * 2025.07.10   김준규          3차 OPEN에 맞게 BACKUP 데이터 재생성 실행
-- * 2025.07.21   김준규          2025.07.01일자에 2차 ROLLIN 시 북미법인 오펀시 추가한 로직 : COMPANY_ID를 SCP_SITE_ID에 없을 경우 추가한다.
-- * 2025.10.14   김준규          3차 오펀시 백업데이터는 QA 및 운영에 통일 테이블 명(BACKUP_NERP_CONV_MASTER_PROD_251010)으로
--                               동일하게 데이터 존재해서 프로그램 수정함(운영이관시 즉시 변경없이 사용가능)
-- * 2025.10.14   김준규          기존 4TH를 2025-12-04 먼저 오펀하는 AZ,AE법인을 4TH로 하고 그외는 5TH로 변경함
-- * 2025.10.20   김준규          @P_ROLLIN의 차수 "4N5"는 여기서는 입력 하면 안됨,교체식 제외처리 값으로 X4N5X@ 추가
-- * 2025.11.12   김준규          G690이 EG00과 EG01로 1:N으로 변경됨에 따라 HARD CORDING 함
-- * 2025.11.17   김준규          4TH 백업하고 BACKUP_NERP_CONV_MASTER_4TH_251117을 5TH에 사용(NERP QA에서만 사용해야 됨,운영없음)
-- * 2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
-- * 2025.12.11   김준규          4TH BACKUP_NERP_CONV_MASTER_PROD_251204을 5TH에 사용

/*
                                  SELECT *
                                  FROM   BACKUP_SCM_MST_SITE_PROD;
                                  SELECT *
                                  FROM   BACKUP_SCM_MST_SITE_ENG_PROD;
                                  SELECT *
                                  FROM   BACKUP_SCM_MST_DIVISION_PROD;
                                  SELECT *
                                  FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD;
                                  --2차 오펀시 백업데이터는 QA 및 운영에 동일 테이블 명
                                  SELECT *
                                  FROM   BACKUP_NERP_CONV_MASTER_PROD_251010;
*/
-- *===================================================================================================
CREATE PROCEDURE [dbo].[PR_NERP_XLS_TOBE_CONVERTER_SUB]
    @p_rollin NVARCHAR(30), --1ST 2ND 3RD 4TH
    @p_sys_gubun NVARCHAR(max)='MERGE',
    @p_sys_works NVARCHAR(max)='',
    @codetype NVARCHAR(max)=''

AS
BEGIN
    --2025.04.17 김준규 롤인차수 추가 시작
    IF @P_ROLLIN NOT IN ('1ST','2ND','3RD','4TH','5TH','X4N5X@')  --교체식 제외처리 값으로 X4N5X@ 추가
    BEGIN
        PRINT CONVERT(NVARCHAR(MAX), N'@P_ROLLIN: '''+ISNULL(@P_ROLLIN,'Value is null ')+''' Please, Input Defined ROLLIN, Stop Procedure!!.');
        RETURN 1; -- 오류 코드를 반환하며 프로시저 종료
    END
    --2025.04.17 김준규 롤인차수 추가 종료
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    --###########################################################################################################
    -- LOG 용 변수 설정
    --###########################################################################################################
    DECLARE @v_batch_user NVARCHAR(150) = 'NERP';
    DECLARE @v_program_name NVARCHAR(150) = 'PR_NERP_XLS_TOBE_CONVERTER_SUB';
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_ifseqno      NVARCHAR(30);
    DECLARE @n_history_seq  BIGINT;
    DECLARE @LOOP integer = 0;
    DECLARE @DUMMY         NVARCHAR(MAX);
    --
    DECLARE @BATCH_RUN_TIME BIGINT;
    DECLARE @BATCH_START_TIME DATETIME;
    DECLARE @BATCH_END_TIME DATETIME;
    DECLARE @RUN_TIME BIGINT;
    DECLARE @START_TIME DATETIME;
    DECLARE @END_TIME DATETIME;
    DECLARE @CNT BIGINT;
    DECLARE @WORK_SECOND BIGINT;
    SET @BATCH_RUN_TIME = 0;
    SET @CNT = 0;
    SET @RUN_TIME = 0;

    -- 시작 LOG
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########';
    SET @v_description = '@p_rollin='+@p_rollin+',@p_sys_gubun='+@p_sys_gubun+',@p_sys_works='+@p_sys_works+',@codetype='+@codetype;
    SET @d_event_date = SYSDATETIME();
    SET @BATCH_START_TIME = SYSDATETIME();
    SET @START_TIME = CONVERT(CHAR(23), GETDATE(), 21);
    PRINT @v_description;
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, 0, '0', @v_description, @START_TIME;
    --2025.04.08 김준규 LOG 추가 종료

BEGIN TRY

    print @p_sys_gubun
    print @p_sys_works + '/' + 'PR_NERP_XLS_TOBE_CONVERTER_SUB'

    DECLARE @element1 nvarchar(10) = ''
    DECLARE @element2 nvarchar(10) = ''
    DECLARE @element3 nvarchar(10) = ''
    DECLARE @element4 nvarchar(10) = ''


    DECLARE @maxIfseqno nvarchar(30) = ''

    set @maxIfseqno = (select max(ifseqno) from DBO.ZNERP_TOBE_CODE_INFO_SN with(nolock) )
    print @maxIfseqno

    UPDATE CIS
    SET    CODE_OLD_01 = 'G691'
          ,ETC1 = SUBSTRING((ISNULL(ETC1,'')+'UPDATE G690 TO G691'),1,100)
    --SELECT *
    FROM   DBO.ZNERP_TOBE_CODE_INFO_SN AS CIS
    WHERE  1=1
    AND    CIS.ifseqno = @maxIfseqno
    AND    CIS.ROLL01  = 'WERKS_D'
    AND    CIS.ROLL02  = ''
    AND    CIS.CODE_OLD_01 = 'G690'
    AND    CIS.CODE_NEW_01 = 'EG01';
    --

    --DECLARE @COMPANY TABLE
 --   (
 --     COMP VARCHAR(50) PRIMARY KEY,
 --     STEP VARCHAR(50)
 --   )
 --   INSERT INTO @COMPANY
    --SELECT 'HQ' AS COMP, '1ST' AS STEP UNION
 --   SELECT 'WA' AS COMP, '1ST' AS STEP UNION
 --   --
 --   SELECT 'MI' AS COMP, '2ND' AS STEP UNION
 --   SELECT 'ST' AS COMP, '2ND' AS STEP UNION
 --   SELECT 'HD' AS COMP, '2ND' AS STEP UNION
 --   SELECT 'HG' AS COMP, '2ND' AS STEP UNION
 --   SELECT 'VT' AS COMP, '2ND' AS STEP UNION
 --   --
 --   SELECT 'NJ' AS COMP, '3RD' AS STEP UNION
 --   SELECT 'NA' AS COMP, '3RD' AS STEP UNION
 --   SELECT 'NB' AS COMP, '3RD' AS STEP UNION
 --   SELECT 'CH' AS COMP, '3RD' AS STEP UNION
 --   --
 --   SELECT 'AZ' AS COMP, '4TH' AS STEP UNION
 --   SELECT 'AE' AS COMP, '4TH' AS STEP UNION
 --   SELECT 'GM' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'GH' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'HM' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'EG' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'TW' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'AU' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'IL' AS COMP, '5TH' AS STEP UNION
 --   SELECT 'JP' AS COMP, '5TH' AS STEP;

    --SELECT *FROM @COMPANY;
    --아래는 수작업으로 입력하는 것임.
/*    INSERT INTO DROP_NERP_CONV_MASTER
    SELECT * FROM NERP_CONV_MASTER WHERE CODETYPE = 'SCP_SITE_ID';*/

    --2개 컬럼으로 구성되는 것 처리
    if @p_sys_gubun = 'MERGE'
    begin
        if (@p_sys_works = 'UMSKZ' or @p_sys_works = 'LGORT_D' or @p_sys_works = 'PRCTR' or @p_sys_works = 'INCO1' OR @p_sys_works = 'BKLAS' /*or @p_sys_works = 'MWSKZ'  or @p_sys_works = 'VTWEG'*/)
        begin

            print '--MERGE/ELEMENT2'

            if @p_sys_works = 'UMSKZ'
            begin
                set @element1 = 'KOART'
            end
            if @p_sys_works = 'LGORT_D'
            begin
                set @element1 = 'WERKS_D'
            end
            if @p_sys_works = 'PRCTR'
            begin
                set @element1 = 'KOKRS'
            end
            /*if @p_sys_works = 'MWSKZ'
            begin
                set @element1 = 'KALSM_D'
            end */

            set @element2 = @p_sys_works;

            if @p_sys_works = 'INCO1'
            begin
                set @element1 = 'INCO1'
                set @element2 = 'VTWEG'
            end
            --2025.04.08 김준규 SCP용 추가 시작
            if @p_sys_works = 'BKLAS'
            begin
                set @element1 = 'BKLAS'
                set @element2 = ''
            end
            --2025.04.08 김준규 SCP용 추가 종료

            print '@p_sys_works :'+@p_sys_works;
            print '@element1    :'+@element1   ;
            print '@element2    :'+@element2   ;

            merge into  [NERP_CONV_MASTER] A
            using
                (
                select x.KEYID
                      ,x.IFSEQNO
                      ,x.SERVER
                      ,x.CODEMAPID
                      ,x.MODULE_CODE
                      ,x.ROLL01
                      ,x.ROLL02
                      ,x.ROLL03
                      ,x.ROLL04
                      ,x.CODE_OLD_01
                      ,x.CODE_OLD_02
                      ,x.CODE_OLD_03
                      ,x.CODE_OLD_04
                      ,x.CODE_NEW_01
                      ,x.CODE_NEW_02
                      ,x.CODE_NEW_03
                      ,x.CODE_NEW_04
                      ,x.DESC01
                      ,x.DESC02
                      ,x.DESC03
                      ,x.DESC04
                      ,x.ETC1
                      ,x.ETC2
                      ,x.ETC3
                      ,x.ETC4
                      ,x.ETC5
                      ,x.ETC6
                      ,x.ERDAT
                      ,x.ERNAM
                      ,x.AEDAT
                      ,x.AENAM
                      ,x.CREATE_DATE
                      ,x.CREATION_BY
                      ,x.TRANSFER_DATE
                      ,x.TRANSACTION_FLAG
                      ,X.ATTRIBUTE5
                FROM (
                    select x.KEYID
                          ,x.IFSEQNO
                          ,x.SERVER
                          ,x.CODEMAPID
                          ,x.MODULE_CODE
                          ,x.ROLL01
                          ,x.ROLL02
                          ,x.ROLL03
                          ,x.ROLL04
                          ,x.CODE_OLD_01
                          ,x.CODE_OLD_02
                          ,x.CODE_OLD_03
                          ,x.CODE_OLD_04
                          ,x.CODE_NEW_01
                          ,x.CODE_NEW_02
                          ,x.CODE_NEW_03
                          ,x.CODE_NEW_04
                          ,x.DESC01
                          ,x.DESC02
                          ,x.DESC03
                          ,x.DESC04
                          ,x.ETC1
                          ,x.ETC2
                          ,x.ETC3
                          ,x.ETC4
                          ,x.ETC5
                          ,x.ETC6
                          ,x.ERDAT
                          ,x.ERNAM
                          ,x.AEDAT
                          ,x.AENAM
                          ,x.CREATE_DATE
                          ,x.CREATION_BY
                          ,x.TRANSFER_DATE
                          ,x.TRANSACTION_FLAG
                          ,X.ATTRIBUTE5
                          ,ROW_NUMBER()OVER(PARTITION BY X.ATTRIBUTE5,CODE_OLD_01,CODE_OLD_02 ORDER BY X.KEYID DESC) RNUM
                    from (SELECT X.*
                               ,ATTRIBUTE5 =  CASE WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D','LIFNR' )
                                                 AND ( CODE_NEW_01 like 'HQ%'
                                                   OR  CODE_NEW_01 like 'WA%' ) THEN '1ST'
                                                --WHEN ROLL01 IN ('LIFNR') AND  LEN(CODE_NEW_01)  > 4  THEN '1ST'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('C100', 'G480') THEN '1ST'
                                                WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('KR', 'PL') THEN '1ST'
                                                --WHEN ROLL01 IN ('VTWEG', 'BLART', 'KUNNR', 'EKGRP', 'VKGRP', 'AUART', 'LIFNR', 'INCO1')  THEN '1ST' -- 전체 Conversion 대상
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                --2025.04.08 김준규 ROLLIN 차수 서증 시작
                                                 AND ( CODE_NEW_01 like 'MI%'
                                                   OR  CODE_NEW_01 like 'ST%'
                                                   OR  CODE_NEW_01 like 'HD%'
                                                   OR  CODE_NEW_01 like 'HG%'
                                                   OR  CODE_NEW_01 like 'VT%' )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '2ND'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G380','G810','G820','G870','G880') THEN '2ND'
                                                --미국기준 2차는 KALSM_D에 CODE_NEW_03이 없음
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AU', 'AZ', 'EG', 'IL', 'MI', 'NA', 'NB', 'NJ', 'TW', 'VT', 'CN') THEN '2ND'
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'NJ%'
                                                   OR  CODE_NEW_01 like 'NA%'
                                                   OR  CODE_NEW_01 like 'NB%'
                                                   OR  CODE_NEW_01 like 'CH%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '3RD'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G990', 'G450', 'G630', 'G180') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'AZ%'
                                                   OR  CODE_NEW_01 like 'AE%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '4TH'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G940','G830') THEN '4TH'
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'GM%'
                                                   OR  CODE_NEW_01 like 'GH%'
                                                   OR  CODE_NEW_01 like 'HM%'
                                                   OR  CODE_NEW_01 like 'EG%'
                                                   OR  CODE_NEW_01 like 'AU%'
                                                   OR  CODE_NEW_01 like 'IL%'
                                                   OR  CODE_NEW_01 like 'JP%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '5TH'
                                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G540','G690','G960','G670','G740','G890','G950') THEN '5TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'TW%'
                                                   OR  CODE_NEW_01 like 'TW%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '9TH'
                                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G680','G680') THEN '9TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                ELSE @p_rollin --'2ND'
                                                --2025.04.08 김준규 ROLLIN 차수 서증 종료
                                            END
                         FROM   DBO.ZNERP_TOBE_CODE_INFO_SN x with(nolock)
                         ) X
                    where 1=1
                    AND IFSEQNO = @maxIfseqno
                    AND ROLL01 = @element1 AND ROLL02 = @element2
                    AND CODE_OLD_01 <> ''
                    AND ( ETC2 NOT like N'%삭제%' AND ETC1 NOT LIKE N'%Delete%' AND ETC4 NOT like N'%삭제%' AND CODE_NEW_01 NOT like N'%삭제%' AND CODE_NEW_02 NOT like N'%삭제%' AND CODE_OLD_01 NOT like N'%신규%')
                    --2025.04.08 김준규 SCP용 BKLAS 추가 시작
                    AND CODE_OLD_02 =  (CASE WHEN ROLL01 IN ('INCO1','BKLAS') THEN  '' ELSE CODE_OLD_02 END )
                    --2025.04.08 김준규 SCP용 BKLAS 추가 종료
                    --AND CODE_OLD_01 <> CODE_NEW_01
                    AND 1 = ( CASE WHEN ROLL01 = 'KALSM_D' AND CODE_OLD_02 <> CODE_NEW_02 AND CODE_NEW_02 <> '' THEN 1
                                   WHEN ROLL01 <> 'KALSM_D' THEN 1 ELSE 0 END)
                    AND 1 = ( CASE WHEN ROLL01 = 'INCO1' AND CODE_OLD_01 <> CODE_NEW_01 THEN 1
                                   WHEN ROLL01 <> 'INCO1' THEN 1 ELSE 0 END)
                    /*AND (ISNULL(ETC6,'') IN ( N'매핑확정', N'1차 완료')
                      OR ISNULL(ETC6,'') LIKE N'%1차확정%' )*/ -- OR이므로 matching_option이 0이 아닐 때만 '매핑확정' 조건이 적용된다
                --2025.04.08 김준규 중복시 에러 방지 추가 시작
                ) x
                WHERE RNUM = 1
                AND   x.ATTRIBUTE5 >= @p_rollin
                --2025.04.08 김준규 중복시 에러 방지 추가 종료
            ) B
            ON 1=1 AND A.CODETYPE = @codetype AND A.ATTRIBUTE5 = B.ATTRIBUTE5
            AND A.OLD_VALUE1 = B.CODE_OLD_01
            AND A.OLD_VALUE2 = B.CODE_OLD_02

            when matched then
                --begin matched
                UPDATE Set A.NEW_VALUE1 = B.CODE_NEW_01
                         , A.NEW_VALUE2 = (CASE WHEN ROLL01 =  'INCO1' THEN IIF(B.SERVER='O', 'E', B.SERVER)  ELSE B.CODE_NEW_02 END )
                         , A.ATTRIBUTE5 = B.ATTRIBUTE5
                         , A.UPDATE_DATE = GETDATE()
                --end matched
            when not matched then
                --Begin not matched
                INSERT ([CODETYPE]
                       ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                       ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                       ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                       ,[DESC1],[DESC2],[DESC3],[DESC4]
                       ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                       ,[ACTIVE_FLAG]
                       ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                       ,[INSERT_ID]
                       ,[INSERT_DATE]
                       ,[UPDATE_ID]
                       ,[UPDATE_DATE])
                VALUES
                       (@codetype
                       ,B.CODE_OLD_01
                       , (CASE WHEN ROLL01 =  'INCO1' THEN IIF(B.SERVER='O', 'E', B.SERVER)  ELSE B.CODE_OLD_02 END )
                       , B.CODE_OLD_03, B.CODE_OLD_04
                       ,B.CODE_NEW_01
                       , (CASE WHEN ROLL01 =  'INCO1' THEN IIF(B.SERVER='O', 'E', B.SERVER)  ELSE B.CODE_NEW_02 END )
                       , B.CODE_NEW_03, B.CODE_NEW_04
                       ,B.ROLL01 ,B.ROLL02 ,B.ROLL03 ,B.ROLL04
                       --2025.04.08 김준규 DESC 값 업력 시작
                       ,B.DESC01,B.DESC02,B.DESC03,B.DESC04
                       --2025.04.08 김준규 DESC 값 업력 종료
                       ,B.ETC1,B.ETC2,B.ETC3,B.ETC4,B.ETC5,B.ETC6
                       ,'Customer Number'
                       ,'Y' --AS [ACTIVE_FLAG]
                       ,'-' ,'-','-','-'
                       , B.ATTRIBUTE5

                       ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
                       );



        end
        --3개 컬럼으로 구성되는 것 처리(MWSKZ:부가세코드)
        else if(@p_sys_works = 'MWSKZ' )
        begin

            print '--MERGE/ELEMENT3'

            if @p_sys_works = 'MWSKZ'
            begin
                set @element1 = 'KALSM_D'
            end

            set @element2 = @p_sys_works;

            print '@p_sys_works :'+@p_sys_works;
            print '@element1    :'+@element1   ;
            print '@element2    :'+@element2   ;

            merge into  [NERP_CONV_MASTER] A
            using
                (
                select x.KEYID
                      ,x.IFSEQNO
                      ,x.SERVER
                      ,x.CODEMAPID
                      ,x.MODULE_CODE
                      ,x.ROLL01
                      ,x.ROLL02
                      ,x.ROLL03
                      ,x.ROLL04
                      ,x.CODE_OLD_01
                      ,x.CODE_OLD_02
                      ,x.CODE_OLD_03
                      ,x.CODE_OLD_04
                      ,x.CODE_NEW_01
                      ,x.CODE_NEW_02
                      ,x.CODE_NEW_03
                      ,x.CODE_NEW_04
                      ,x.DESC01
                      ,x.DESC02
                      ,x.DESC03
                      ,x.DESC04
                      ,x.ETC1
                      ,x.ETC2
                      ,x.ETC3
                      ,x.ETC4
                      ,x.ETC5
                      ,x.ETC6
                      ,x.ERDAT
                      ,x.ERNAM
                      ,x.AEDAT
                      ,x.AENAM
                      ,x.CREATE_DATE
                      ,x.CREATION_BY
                      ,x.TRANSFER_DATE
                      ,x.TRANSACTION_FLAG
                      ,X.ATTRIBUTE5
                FROM (
                    select x.KEYID
                          ,x.IFSEQNO
                          ,x.SERVER
                          ,x.CODEMAPID
                          ,x.MODULE_CODE
                          ,x.ROLL01
                          ,x.ROLL02
                          ,x.ROLL03
                          ,x.ROLL04
                          ,x.CODE_OLD_01
                          ,x.CODE_OLD_02
                          ,x.CODE_OLD_03
                          ,x.CODE_OLD_04
                          ,x.CODE_NEW_01
                          ,x.CODE_NEW_02
                          ,x.CODE_NEW_03
                          ,x.CODE_NEW_04
                          ,x.DESC01
                          ,x.DESC02
                          ,x.DESC03
                          ,x.DESC04
                          ,x.ETC1
                          ,x.ETC2
                          ,x.ETC3
                          ,x.ETC4
                          ,x.ETC5
                          ,x.ETC6
                          ,x.ERDAT
                          ,x.ERNAM
                          ,x.AEDAT
                          ,x.AENAM
                          ,x.CREATE_DATE
                          ,x.CREATION_BY
                          ,x.TRANSFER_DATE
                          ,x.TRANSACTION_FLAG
                          ,X.ATTRIBUTE5
                          ,ROW_NUMBER()OVER(PARTITION BY X.ATTRIBUTE5,CODE_OLD_01,CODE_OLD_02,CODE_OLD_03 ORDER BY X.KEYID DESC) RNUM
                    from (SELECT X.*
                               ,ATTRIBUTE5 =  CASE WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D','LIFNR' )
                                                 AND ( CODE_NEW_01 like 'HQ%'
                                                   OR  CODE_NEW_01 like 'WA%' ) THEN '1ST'
                                                --WHEN ROLL01 IN ('LIFNR') AND  LEN(CODE_NEW_01)  > 4  THEN '1ST'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('C100', 'G480') THEN '1ST'
                                                WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('KR', 'PL') THEN '1ST'
                                                --WHEN ROLL01 IN ('VTWEG', 'BLART', 'KUNNR', 'EKGRP', 'VKGRP', 'AUART', 'LIFNR', 'INCO1')  THEN '1ST' -- 전체 Conversion 대상
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                --2025.04.08 김준규 ROLLIN 차수 서증 시작
                                                 AND ( CODE_NEW_01 like 'MI%'
                                                   OR  CODE_NEW_01 like 'ST%'
                                                   OR  CODE_NEW_01 like 'HD%'
                                                   OR  CODE_NEW_01 like 'HG%'
                                                   OR  CODE_NEW_01 like 'VT%' )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '2ND'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G380','G810','G820','G870','G880') THEN '2ND'
                                                --미국기준 2차는 KALSM_D에 CODE_NEW_03이 없음
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AU', 'AZ', 'EG', 'IL', 'MI', 'NA', 'NB', 'NJ', 'TW', 'VT', 'CN') THEN '2ND'
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'NJ%'
                                                   OR  CODE_NEW_01 like 'NA%'
                                                   OR  CODE_NEW_01 like 'NB%'
                                                   OR  CODE_NEW_01 like 'CH%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '3RD'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G990', 'G450', 'G630', 'G180') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'AZ%'
                                                   OR  CODE_NEW_01 like 'AE%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '4TH'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G940','G830') THEN '4TH'
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'GM%'
                                                   OR  CODE_NEW_01 like 'GH%'
                                                   OR  CODE_NEW_01 like 'HM%'
                                                   OR  CODE_NEW_01 like 'EG%'
                                                   OR  CODE_NEW_01 like 'AU%'
                                                   OR  CODE_NEW_01 like 'IL%'
                                                   OR  CODE_NEW_01 like 'JP%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '5TH'
                                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G540','G690','G960','G670','G740','G890','G950') THEN '5TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'TW%'
                                                   OR  CODE_NEW_01 like 'TW%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '9TH'
                                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G680','G680') THEN '9TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                ELSE @p_rollin --'2ND'
                                                --2025.04.08 김준규 ROLLIN 차수 서증 종료
                                            END
                         FROM   DBO.ZNERP_TOBE_CODE_INFO_SN x with(nolock)
                         ) X
                    where 1=1
                    AND IFSEQNO = @maxIfseqno
                    AND ROLL01 = @element1 AND ROLL02 = @element2
                    AND CODE_OLD_01 <> ''
                    AND ( ETC2 NOT like N'%삭제%' AND ETC1 NOT LIKE N'%Delete%' AND ETC4 NOT like N'%삭제%' AND CODE_NEW_01 NOT like N'%삭제%' AND CODE_NEW_02 NOT like N'%삭제%' AND CODE_OLD_01 NOT like N'%신규%' )
                    /*AND (ISNULL(ETC6,'') IN ( N'매핑확정', N'1차 완료')
                      OR ISNULL(ETC6,'') LIKE N'%1차확정%' )*/ -- OR이므로 matching_option이 0이 아닐 때만 '매핑확정' 조건이 적용된다
                --2025.04.08 김준규 중복시 에러 방지 추가 시작
                ) x
                WHERE RNUM = 1
                AND   x.ATTRIBUTE5 >= @p_rollin
                --2025.04.08 김준규 중복시 에러 방지 추가 종료
            ) B
            ON 1=1 AND A.CODETYPE = @codetype AND A.ATTRIBUTE5 = B.ATTRIBUTE5
            AND A.OLD_VALUE1 = B.CODE_OLD_01
            AND A.OLD_VALUE2 = B.CODE_OLD_02
            AND A.OLD_VALUE3 = B.CODE_OLD_03

            when matched then
                --begin matched
                UPDATE Set A.NEW_VALUE1 = B.CODE_NEW_01
                         , A.NEW_VALUE2 = B.CODE_NEW_02
                         , A.NEW_VALUE3 = B.CODE_NEW_03
                         , A.ATTRIBUTE5 = B.ATTRIBUTE5
                         , A.UPDATE_DATE = GETDATE()
                --end matched
            when not matched then
                --Begin not matched
                INSERT ([CODETYPE]
                       ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                       ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                       ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                       ,[DESC1],[DESC2],[DESC3],[DESC4]
                       ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                       ,[ACTIVE_FLAG]
                       ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                       ,[INSERT_ID]
                       ,[INSERT_DATE]
                       ,[UPDATE_ID]
                       ,[UPDATE_DATE])
                VALUES
                       (@codetype
                       ,B.CODE_OLD_01, B.CODE_OLD_02, B.CODE_OLD_03, B.CODE_OLD_04
                       ,B.CODE_NEW_01, B.CODE_NEW_02, B.CODE_NEW_03, B.CODE_NEW_04
                       ,B.ROLL01 ,B.ROLL02 ,B.ROLL03 ,B.ROLL04
                       --2025.04.08 김준규 DESC 값 업력 시작
                       ,B.DESC01,B.DESC02,B.DESC03,B.DESC04
                       --2025.04.08 김준규 DESC 값 업력 종료
                       ,B.ETC1,B.ETC2,B.ETC3,B.ETC4,B.ETC5,B.ETC6
                       ,'Customer Number'
                       ,'Y' --AS [ACTIVE_FLAG]
                       ,'-' ,'-','-','-'
                       ,B.ATTRIBUTE5
                       ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
                       );



        end
        --2025.04.08 김준규 SCP용 추가 시작
        --1개 컬럼으로 구성되는 것 처리
        else if(@p_sys_works = 'SCP_SITE_ID' )
        begin

            print '--MERGE/ELEMENT1 SCP_SITE_ID'

            set @element1 = @p_sys_works

            print '@p_sys_works :'+@p_sys_works;
            print '@element1    :'+@element1   ;

            --2025-05-26 삭제후 입력은 SCM_MST_SITE 값이 변경후에 SCP_SITE_ID는 과거 값을 가져올 수가 없어서 최초 생성후 백업한것 다시 넣기
            --운영에서는 테이블 만들어서 사용해야 된다. BACKUP_SCM_MST_SITE_PROD_250417
            --SELECT dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXDFFECVYB','2,5,6,8,11,13') 에스시엠디이브이
            DECLARE @NERP_PROD NVARCHAR(128);
            SET @NERP_PROD = 'LGCE_'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXDFFECVYB','2,5,6,8,11,13');--에스시엠디이브이
            IF DB_NAME()= @NERP_PROD BEGIN
                DECLARE @NERP_PROD_STAGE NVARCHAR(30);
                DECLARE @sqlX nvarchar(max) = 'SELECT @STAGEOUT = SEGMENT1 FROM [DBO].SCM_ADM_LOOKUP_MASTER_DETAIL lmd WHERE LMD.LOOKUP_TYPE = ''NERP_ROLLIN_STAGE'' ';
                --PRINT @sqlX
                EXEC sp_executesql
                     @sqlX,
                     N'@STAGEOUT NVARCHAR(30) OUTPUT',
                     @STAGEOUT = @NERP_PROD_STAGE OUTPUT
                     ;
                     PRINT '1 @NERP_PROD_STAGE:'+@NERP_PROD_STAGE;
                DECLARE @DE_V_STAGE NVARCHAR(128);
                SELECT TOP 1  @DE_V_STAGE = SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL lmd WHERE LMD.LOOKUP_TYPE = 'NERP_ROLLIN_STAGE';
                PRINT '1 @DE_V_STAGE:'+@DE_V_STAGE;
            END;

            PRINT '2 @NERP_PROD_STAGE:'+@NERP_PROD_STAGE;
            PRINT '2 @DE_V_STAGE:'+@DE_V_STAGE;
            DECLARE @sql nvarchar(max) = '';
            --엘지씨이 에스씨엠피알오디 : 운영 -- 운영일경우 아무것도 하지 않음 뒤가 7자리
            IF DB_NAME()='LGCE_'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXPFFRCOYD','2,5,6,8,11,13,15') AND ISNULL(@DE_V_STAGE,'X') = ISNULL(@NERP_PROD_STAGE,'Y') BEGIN
                SET @SQL = '';
                PRINT 'CHECK1 @SQL:'+@SQL;
                PRINT 'CHECK1 @NERP_PROD_STAGE:'+@NERP_PROD_STAGE;
                PRINT 'CHECK1 @DE_V_STAGE:'+@DE_V_STAGE;
            END
            --엘지씨이 에스씨엠디이브이 : QA서버/DEV서버 -- 에스씨엠디이브이 일 경우 아래나열된 작업 실행 뒤가 6자리
            ELSE IF DB_NAME()='LGCE_'+dbo.FN_GET_NERP_DECODE_BY_INDEXES('ASDDCMXDFFECVYB','2,5,6,8,11,13') AND ISNULL(@DE_V_STAGE,'X') <> ISNULL(@NERP_PROD_STAGE,'Y')
            BEGIN

                PRINT 'CHECK2 @NERP_PROD_STAGE:'+@NERP_PROD_STAGE;
                PRINT 'CHECK2 @DE_V_STAGE:'+@DE_V_STAGE;

                PRINT N' 백업로직 BACKUP에 LOST DATA 추가';
                --##############################################################
                -- 1) BACKUP_SCM_MST_SITE_PROD NERP_CONV_MASTER 작업용 운영에서 백업
                --##############################################################
                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_MST_SITE_PROD
                FROM   [DBO].[SCM_MST_SITE] WITH(NOLOCK);
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;
                --
                -- 2025-06-17 운영에 추가된 것 반영, 운영에 삭제 된것 제거, 기존것 먼저 보관.
                --
                --##############################################################
                -- 1) BACKUP_SCM_MST_SITE_PROD 백업 테이블 보관 및 2개월 이상 DROP
                --##############################################################
                BEGIN
                    DECLARE @BaseTableName NVARCHAR(254) = 'BACKUP_SCM_MST_SITE_PROD'; -- 기본 테이블 이름
                    DECLARE @DatePart NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)
                    DECLARE @NewTableName NVARCHAR(254);
                    DECLARE @Counter INT = 1;
                    DECLARE @SQL_TBL NVARCHAR(MAX);
                    DECLARE @DropDateThreshold NVARCHAR(8);

                    ------------------------------------------------------------------------------------
                    -- 테이블 백업
                    ------------------------------------------------------------------------------------
                    -- 2개월 전 날짜 계산
                    SET @DropDateThreshold = FORMAT(DATEADD(month, -2, GETDATE()), 'yyyyMMdd');

                    -- 테이블이 존재하는지 확인하고, 존재하면 숫자를 증가시켜 새로운 테이블 이름 생성
                    WHILE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR))
                    BEGIN
                        SET @Counter = @Counter + 1;
                    END

                    -- 최종 새로운 테이블 이름 설정
                    SET @NewTableName = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR);

                    -- SELECT INTO 구문을 동적으로 생성
                    SET @SQL_TBL = 'SELECT * INTO ' + @NewTableName + ' FROM ' + @BaseTableName + ';';

                    -- 동적 SQL 실행
                    EXEC sp_executesql @SQL_TBL;

                    ------------------------------------------------------------------------------------
                    -- 2개월 이전 테이블 DROP 로직
                    ------------------------------------------------------------------------------------
                    DECLARE @DropTableName NVARCHAR(254);
                    DECLARE @DropSQL NVARCHAR(MAX);

                    DECLARE TableCursor CURSOR FOR
                    SELECT TABLE_NAME
                    FROM   INFORMATION_SCHEMA.TABLES
                    WHERE  TABLE_NAME LIKE @BaseTableName + '_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_%' -- 날짜 패턴 포함
                    AND    SUBSTRING(TABLE_NAME, LEN(@BaseTableName) + 2, 8) < @DropDateThreshold;

                    OPEN TableCursor;

                    FETCH NEXT FROM TableCursor INTO @DropTableName;

                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @DropSQL = 'DROP TABLE ' + @DropTableName + ';';
                        BEGIN TRY
                            EXEC sp_executesql @DropSQL;
                            PRINT N'테이블 삭제됨: ' + @DropTableName;
                        END TRY
                        BEGIN CATCH
                            PRINT N'테이블 삭제 실패: ' + @DropTableName;
                            PRINT ERROR_MESSAGE();
                        END CATCH;

                        FETCH NEXT FROM TableCursor INTO @DropTableName;
                    END;

                    CLOSE TableCursor;
                    DEALLOCATE TableCursor;

                END;

                --#####################
                --1) 운영에 추가된 것 반영
                --#####################
                SET @sql = N'
                SELECT *,GETDATE() AS CREATION_TIME
                FROM   [DBO].[SCM_MST_SITE] AS SMS WITH(NOLOCK)
                WHERE  1=1
                AND    NOT EXISTS (SELECT 1
                                   FROM   BACKUP_SCM_MST_SITE_PROD MSP
                                   WHERE  MSP.DIVISION_ID = SMS.DIVISION_ID
                                   AND    MSP.SCM_SITE_ID = SMS.SCM_SITE_ID
                                   );';
                INSERT INTO BACKUP_SCM_MST_SITE_PROD
                EXEC sp_executesql @sql;

                --#####################
                --1) 운영에 삭제 된것 제거
                --#####################
                SET @sql = N'
                DELETE MSP
                FROM   BACKUP_SCM_MST_SITE_PROD AS MSP
                WHERE  1=1
                AND    NOT EXISTS (SELECT 1
                                   FROM   [DBO].[SCM_MST_SITE] AS SMS WITH(NOLOCK)
                                   WHERE  MSP.DIVISION_ID = SMS.DIVISION_ID
                                   AND    MSP.SCM_SITE_ID = SMS.SCM_SITE_ID
                                   );';
                EXEC sp_executesql @sql;


                --##############################################################
                --2) BACKUP_SCM_MST_SITE_ENG_PROD NERP_CONV_MASTER 작업용 운영에서 백업
                --##############################################################
                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_MST_SITE_ENG_PROD
                FROM   [DBO].[SCM_MST_SITE_ENG] WITH(NOLOCK);
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

                --
                -- 2025-06-17 운영에 추가된 것 반영, 운영에 삭제 된것 제거, 기존것 먼저 보관.
                --
                --##############################################################
                --2) BACKUP_SCM_MST_SITE_ENG_PROD 백업 테이블 보관 및 2개월 이상 DROP
                --##############################################################
                BEGIN
                    --DECLARE @BaseTableName NVARCHAR(254) = 'BACKUP_SCM_MST_SITE_ENG_PROD'; -- 기본 테이블 이름
                    --DECLARE @DatePart NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)
                    --DECLARE @NewTableName NVARCHAR(254);
                    --DECLARE @Counter INT = 1;
                    --DECLARE @SQL_TBL NVARCHAR(MAX);
                    --DECLARE @DropDateThreshold NVARCHAR(8);
                    SET @BaseTableName = 'BACKUP_SCM_MST_SITE_ENG_PROD'; -- 기본 테이블 이름
                    SET @DatePart = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)

                    ------------------------------------------------------------------------------------
                    -- 테이블 백업
                    ------------------------------------------------------------------------------------
                    -- 2개월 전 날짜 계산
                    SET @DropDateThreshold = FORMAT(DATEADD(month, -2, GETDATE()), 'yyyyMMdd');

                    -- 테이블이 존재하는지 확인하고, 존재하면 숫자를 증가시켜 새로운 테이블 이름 생성
                    WHILE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR))
                    BEGIN
                        SET @Counter = @Counter + 1;
                    END

                    -- 최종 새로운 테이블 이름 설정
                    SET @NewTableName = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR);

                    -- SELECT INTO 구문을 동적으로 생성
                    SET @SQL_TBL = 'SELECT * INTO ' + @NewTableName + ' FROM ' + @BaseTableName + ';';

                    -- 동적 SQL 실행
                    EXEC sp_executesql @SQL_TBL;

                    ------------------------------------------------------------------------------------
                    -- 2개월 이전 테이블 DROP 로직
                    ------------------------------------------------------------------------------------
                    --DECLARE @DropTableName NVARCHAR(254);
                    --DECLARE @DropSQL NVARCHAR(MAX);

                    DECLARE TableCursor CURSOR FOR
                    SELECT TABLE_NAME
                    FROM   INFORMATION_SCHEMA.TABLES
                    WHERE  TABLE_NAME LIKE @BaseTableName + '_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_%' -- 날짜 패턴 포함
                    AND    SUBSTRING(TABLE_NAME, LEN(@BaseTableName) + 2, 8) < @DropDateThreshold;

                    OPEN TableCursor;

                    FETCH NEXT FROM TableCursor INTO @DropTableName;

                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @DropSQL = 'DROP TABLE ' + @DropTableName + ';';
                        BEGIN TRY
                            EXEC sp_executesql @DropSQL;
                            PRINT N'테이블 삭제됨: ' + @DropTableName;
                        END TRY
                        BEGIN CATCH
                            PRINT N'테이블 삭제 실패: ' + @DropTableName;
                            PRINT ERROR_MESSAGE();
                        END CATCH;

                        FETCH NEXT FROM TableCursor INTO @DropTableName;
                    END;

                    CLOSE TableCursor;
                    DEALLOCATE TableCursor;

                END;

                --#####################
                --2) 운영에 추가된 것 반영
                --#####################
                SET @sql = N'
                SELECT *,GETDATE() AS CREATION_TIME
                FROM   [DBO].[SCM_MST_SITE_ENG] AS SMS WITH(NOLOCK)
                WHERE  1=1
                AND    NOT EXISTS (SELECT 1
                                   FROM   BACKUP_SCM_MST_SITE_ENG_PROD MSP
                                   WHERE  MSP.MODELING_ID = SMS.MODELING_ID
                                   AND    MSP.PLAN_ID = SMS.PLAN_ID
                                   AND    MSP.PLAN_TYPE = SMS.PLAN_TYPE
                                   AND    MSP.PLAN_SEQ = SMS.PLAN_SEQ
                                   AND    MSP.DIVISION_ID = SMS.DIVISION_ID
                                   AND    MSP.SCM_SITE_ID = SMS.SCM_SITE_ID
                                   AND    MSP.ENG_SCM_SITE_ID = SMS.ENG_SCM_SITE_ID
                                   );';
                INSERT INTO BACKUP_SCM_MST_SITE_ENG_PROD
                EXEC sp_executesql @sql;

                --#####################
                --2) 운영에 삭제 된것 제거
                --#####################
                SET @sql = N'
                DELETE MSP
                FROM   BACKUP_SCM_MST_SITE_ENG_PROD AS MSP
                WHERE  1=1
                AND    NOT EXISTS (SELECT 1
                                   FROM   [DBO].[SCM_MST_SITE_ENG] AS SMS WITH(NOLOCK)
                                   WHERE  MSP.MODELING_ID = SMS.MODELING_ID
                                   AND    MSP.PLAN_ID = SMS.PLAN_ID
                                   AND    MSP.PLAN_TYPE = SMS.PLAN_TYPE
                                   AND    MSP.PLAN_SEQ = SMS.PLAN_SEQ
                                   AND    MSP.DIVISION_ID = SMS.DIVISION_ID
                                   AND    MSP.SCM_SITE_ID = SMS.SCM_SITE_ID
                                   AND    MSP.ENG_SCM_SITE_ID = SMS.ENG_SCM_SITE_ID
                                   );';
                EXEC sp_executesql @sql;


                --##############################################################
                --3) BACKUP_SCM_MST_DIVISION_PROD NERP_CONV_MASTER 작업용 운영에서 백업
                --##############################################################
                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_MST_DIVISION_PROD
                FROM   [DBO].[SCM_MST_DIVISION] WITH(NOLOCK);
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

                --
                -- 2025-06-17 운영에 추가된 것 반영, 운영에 삭제 된것 제거, 기존것 먼저 보관.
                --
                --##############################################################
                --3) BACKUP_SCM_MST_DIVISION_PROD 백업 테이블 보관 및 2개월 이상 DROP
                --##############################################################
                BEGIN
                    --DECLARE @BaseTableName NVARCHAR(254) = 'BACKUP_SCM_MST_DIVISION_PROD'; -- 기본 테이블 이름
                    --DECLARE @DatePart NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)
                    --DECLARE @NewTableName NVARCHAR(254);
                    --DECLARE @Counter INT = 1;
                    --DECLARE @SQL_TBL NVARCHAR(MAX);
                    --DECLARE @DropDateThreshold NVARCHAR(8);
                    SET @BaseTableName = 'BACKUP_SCM_MST_DIVISION_PROD'; -- 기본 테이블 이름
                    SET @DatePart = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)

                    ------------------------------------------------------------------------------------
                    -- 테이블 백업
                    ------------------------------------------------------------------------------------
                    -- 2개월 전 날짜 계산
                    SET @DropDateThreshold = FORMAT(DATEADD(month, -2, GETDATE()), 'yyyyMMdd');

                    -- 테이블이 존재하는지 확인하고, 존재하면 숫자를 증가시켜 새로운 테이블 이름 생성
                    WHILE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR))
                    BEGIN
                        SET @Counter = @Counter + 1;
                    END

                    -- 최종 새로운 테이블 이름 설정
                    SET @NewTableName = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR);

                    -- SELECT INTO 구문을 동적으로 생성
                    SET @SQL_TBL = 'SELECT * INTO ' + @NewTableName + ' FROM ' + @BaseTableName + ';';

                    -- 동적 SQL 실행
                    EXEC sp_executesql @SQL_TBL;

                    ------------------------------------------------------------------------------------
                    -- 2개월 이전 테이블 DROP 로직
                    ------------------------------------------------------------------------------------
                    --DECLARE @DropTableName NVARCHAR(254);
                    --DECLARE @DropSQL NVARCHAR(MAX);

                    DECLARE TableCursor CURSOR FOR
                    SELECT TABLE_NAME
                    FROM   INFORMATION_SCHEMA.TABLES
                    WHERE  TABLE_NAME LIKE @BaseTableName + '_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_%' -- 날짜 패턴 포함
                    AND    SUBSTRING(TABLE_NAME, LEN(@BaseTableName) + 2, 8) < @DropDateThreshold;

                    OPEN TableCursor;

                    FETCH NEXT FROM TableCursor INTO @DropTableName;

                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @DropSQL = 'DROP TABLE ' + @DropTableName + ';';
                        BEGIN TRY
                            EXEC sp_executesql @DropSQL;
                            PRINT N'테이블 삭제됨: ' + @DropTableName;
                        END TRY
                        BEGIN CATCH
                            PRINT N'테이블 삭제 실패: ' + @DropTableName;
                            PRINT ERROR_MESSAGE();
                        END CATCH;

                        FETCH NEXT FROM TableCursor INTO @DropTableName;
                    END;

                    CLOSE TableCursor;
                    DEALLOCATE TableCursor;

                END;

                --#####################
                --3) 운영에 추가된 것 반영
                --#####################
                SET @sql = N'
                SELECT *,GETDATE() AS CREATION_TIME
                FROM   [DBO].[SCM_MST_DIVISION] AS SMS WITH(NOLOCK)
                WHERE  1=1
                AND    NOT EXISTS (SELECT 1
                                   FROM   BACKUP_SCM_MST_DIVISION_PROD MSP
                                   WHERE  MSP.DIVISION_ID = SMS.DIVISION_ID
                                   );';
                INSERT INTO BACKUP_SCM_MST_DIVISION_PROD
                EXEC sp_executesql @sql;

                --#####################
                --3) 운영에 삭제 된것 제거
                --#####################
                SET @sql = N'
                DELETE MSP
                FROM   BACKUP_SCM_MST_DIVISION_PROD AS MSP
                WHERE  1=1
                AND    NOT EXISTS (SELECT 1
                                   FROM   [DBO].[SCM_MST_DIVISION] AS SMS WITH(NOLOCK)
                                   WHERE  MSP.DIVISION_ID = SMS.DIVISION_ID
                                   );';
                EXEC sp_executesql @sql;


                --##############################################################
                --4) BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD NERP_CONV_MASTER 작업용 운영에서 백업
                --##############################################################
                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD
                FROM   [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
                WHERE  lookup_type = ''PACKER_SCS'';
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

               --
                -- 2025-06-17 운영에 추가된 것 반영, 운영에 삭제 된것 제거, 기존것 먼저 보관.
                --
                --##############################################################
                --4) BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PROD 백업 테이블 보관 및 2개월 이상 DROP
                --##############################################################
                BEGIN
                    --DECLARE @BaseTableName NVARCHAR(254) = 'BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD'; -- 기본 테이블 이름
                    --DECLARE @DatePart NVARCHAR(8) = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)
                    --DECLARE @NewTableName NVARCHAR(254);
                    --DECLARE @Counter INT = 1;
                    --DECLARE @SQL_TBL NVARCHAR(MAX);
                    --DECLARE @DropDateThreshold NVARCHAR(8);
                    SET @BaseTableName = 'BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD'; -- 기본 테이블 이름
                    SET @DatePart = FORMAT(GETDATE(), 'yyyyMMdd'); -- 오늘 날짜 (예: 20250513)

                    ------------------------------------------------------------------------------------
                    -- 테이블 백업
                    ------------------------------------------------------------------------------------
                    -- 2개월 전 날짜 계산
                    SET @DropDateThreshold = FORMAT(DATEADD(month, -2, GETDATE()), 'yyyyMMdd');

                    -- 테이블이 존재하는지 확인하고, 존재하면 숫자를 증가시켜 새로운 테이블 이름 생성
                    WHILE EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR))
                    BEGIN
                        SET @Counter = @Counter + 1;
                    END

                    -- 최종 새로운 테이블 이름 설정
                    SET @NewTableName = @BaseTableName + '_' + @DatePart + '_' + CAST(@Counter AS NVARCHAR);

                    -- SELECT INTO 구문을 동적으로 생성
                    SET @SQL_TBL = 'SELECT * INTO ' + @NewTableName + ' FROM ' + @BaseTableName + ';';

                    -- 동적 SQL 실행
                    EXEC sp_executesql @SQL_TBL;

                    ------------------------------------------------------------------------------------
                    -- 2개월 이전 테이블 DROP 로직
                    ------------------------------------------------------------------------------------
                    --DECLARE @DropTableName NVARCHAR(254);
                    --DECLARE @DropSQL NVARCHAR(MAX);

                    DECLARE TableCursor CURSOR FOR
                    SELECT TABLE_NAME
                    FROM   INFORMATION_SCHEMA.TABLES
                    WHERE  TABLE_NAME LIKE @BaseTableName + '_[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]_%' -- 날짜 패턴 포함
                    AND    SUBSTRING(TABLE_NAME, LEN(@BaseTableName) + 2, 8) < @DropDateThreshold;

                    OPEN TableCursor;

                    FETCH NEXT FROM TableCursor INTO @DropTableName;

                    WHILE @@FETCH_STATUS = 0
                    BEGIN
                        SET @DropSQL = 'DROP TABLE ' + @DropTableName + ';';
                        BEGIN TRY
                            EXEC sp_executesql @DropSQL;
                            PRINT N'테이블 삭제됨: ' + @DropTableName;
                        END TRY
                        BEGIN CATCH
                            PRINT N'테이블 삭제 실패: ' + @DropTableName;
                            PRINT ERROR_MESSAGE();
                        END CATCH;

                        FETCH NEXT FROM TableCursor INTO @DropTableName;
                    END;

                    CLOSE TableCursor;
                    DEALLOCATE TableCursor;

                END;

                --#####################
                --4) 운영에 추가된 것 반영
                --#####################
                SET @sql = N'
                SELECT *,GETDATE() AS CREATION_TIME
                FROM   [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] AS SMS WITH(NOLOCK)
                WHERE  1=1
                AND    LOOKUP_TYPE = ''PACKER_SCS''
                AND    NOT EXISTS (SELECT 1
                                   FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD MSP
                                   WHERE  MSP.LOOKUP_TYPE = SMS.LOOKUP_TYPE
                                   AND    MSP.SEGMENT1 = SMS.SEGMENT1
                                   AND    MSP.SEGMENT2 = SMS.SEGMENT2
                                   AND    MSP.SEGMENT3 = SMS.SEGMENT3
                                   AND    MSP.SEGMENT4 = SMS.SEGMENT4
                                   AND    MSP.SEGMENT5 = SMS.SEGMENT5
                                   );';
                INSERT INTO BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD
                EXEC sp_executesql @sql;

                --#####################
                --4) 운영에 삭제 된것 제거
                --#####################
                SET @sql = N'
                DELETE MSP
                FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD AS MSP
                WHERE  1=1
                AND    LOOKUP_TYPE = ''PACKER_SCS''
                AND    NOT EXISTS (SELECT 1
                                   FROM   [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] AS SMS WITH(NOLOCK)
                                   WHERE  MSP.LOOKUP_TYPE = SMS.LOOKUP_TYPE
                                   AND    MSP.SEGMENT1 = SMS.SEGMENT1
                                   AND    MSP.SEGMENT2 = SMS.SEGMENT2
                                   AND    MSP.SEGMENT3 = SMS.SEGMENT3
                                   AND    MSP.SEGMENT4 = SMS.SEGMENT4
                                   AND    MSP.SEGMENT5 = SMS.SEGMENT5
                                   );';
                EXEC sp_executesql @sql;

            END
            ELSE--에스시엠피알오디 아니고 에스시엠디이브이도 아닐경우 백업받는다.
            BEGIN

                PRINT 'CHECK3 @NERP_PROD_STAGE:'+@NERP_PROD_STAGE;
                PRINT 'CHECK3 @DE_V_STAGE:'+@DE_V_STAGE;

                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_MST_SITE_PROD
                FROM   [DBO].[SCM_MST_SITE] WITH(NOLOCK);
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_MST_SITE_ENG_PROD
                FROM   [DBO].[SCM_MST_SITE_ENG] WITH(NOLOCK);
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_MST_DIVISION_PROD
                FROM   [DBO].[SCM_MST_DIVISION] WITH(NOLOCK);
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

                SET @sql = N'
                BEGIN TRY
                SELECT *,GETDATE() AS CREATION_TIME
                INTO   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD
                FROM   [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
                WHERE  lookup_type = ''PACKER_SCS'';
                END TRY
                BEGIN CATCH
                END CATCH;';
                EXEC sp_executesql @sql;

            END;

            merge into  [NERP_CONV_MASTER] A
            using
                (

              SELECT 'SCP_SITE_ID'   AS CODETYPE
                    ,[OLD_VALUE1]    AS [OLD_VALUE1],''[OLD_VALUE2],''[OLD_VALUE3],''[OLD_VALUE4]
                    ,[NEW_VALUE1]    AS [NEW_VALUE1],''[NEW_VALUE2],''[NEW_VALUE3],''[NEW_VALUE4]
                    ,MAX([ELEMENT1]) AS [ELEMENT1]
                    ,MAX([ELEMENT2]) AS [ELEMENT2],''[ELEMENT3],''[ELEMENT4]
                    ,MAX([DESC1])    AS [DESC1]
                    ,MAX([DESC2])    AS [DESC2]
                    ,MAX([COMMENT6]) AS [COMMENT6]
                    ,MAX([COMMENT7]) AS [COMMENT7]
                    ,MAX([ACTIVE_FLAG]) AS [ACTIVE_FLAG]
                    ,MAX([ATTRIBUTE5]) AS [ATTRIBUTE5]
                    ,'SCP_CONV_MASTER' AS INSERT_ID
                    ,GETDATE()         AS INSERT_DATE
                    ,'SCP_CONV_MASTER' AS UPDATE_ID
                    ,GETDATE()         AS UPDATE_DATE
              FROM  (     SELECT 'SCP_SITE_ID' AS CODETYPE
                                ,[CODE_OLD_01] AS [OLD_VALUE1]
                                ,[CODE_NEW_01] AS [NEW_VALUE1]
                                ,'2'           AS [ELEMENT1]
                                ,[ROLL01]      AS [ELEMENT2]
                                ,CASE WHEN 1=2 THEN  '' END AS [DESC1]
                                ,CASE WHEN 1=2 THEN  '' END AS [DESC2]
                                ,[ETC6]        AS [COMMENT6]
                                ,[MAPPING_KEY] AS [COMMENT7]
                                ,'Y'           AS [ACTIVE_FLAG]
                                ,[ATTRIBUTE5]
                          FROM   ( SELECT M.[IFSEQNO]
                                         ,M.[ROLL01]
                                         ,M.[CODE_OLD_01]  AS [MAPPING_KEY]
                                         ,P.SCM_SITE_ID    AS [CODE_OLD_01]
                                         ,REPLACE(SCM_SITE_ID, M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                         ,M.[ETC6]
                                         ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                               --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                   FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                        --백업받은 테이블로 대체
                                        --INNER HASH JOIN ( SELECT scm_site_id FROM [SCM_MST_SITE] P WITH(NOLOCK)
                                        INNER HASH JOIN ( SELECT scm_site_id FROM [BACKUP_SCM_MST_SITE_PROD] P WITH(NOLOCK)
                                               -- 가상 추가 시작
                                               UNION
                                               SELECT CASE WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '-S'
                                                            ELSE scm_site_id
                                                       END AS scm_site_id
                                                FROM  ( SELECT a.*
                                                             , di.attribute3 AS division_group
                                                             , di.attribute4 AS division_comp
                                                        --백업받은 테이블로 대체
                                                        --FROM   scm_mst_site      a WITH (NOLOCK)
                                                        --     , scm_mst_division di WITH(NOLOCK)
                                                        FROM   BACKUP_SCM_MST_SITE_PROD      a WITH (NOLOCK)
                                                             , BACKUP_SCM_MST_DIVISION_PROD di WITH(NOLOCK)
                                                        WHERE  a.division_id = di.division_id
                                                        AND    di.valid_yn   = 'Y'
                                                      ) a
                                                       LEFT OUTER JOIN (
                                                                        SELECT segment1 -- division_id
                                                                             , segment2 -- scm_site_id
                                                                        --백업받은 테이블로 대체
                                                                        --FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                        FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD WITH(NOLOCK)
                                                                        WHERE  lookup_type = 'PACKER_SCS'
                                                                        AND    valid_yn    = 'Y'
                                                                       ) p
                                                       ON  a.division_id = p.segment1
                                                       AND a.scm_site_id = p.segment2
                                                    ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
                                                WHERE  a.site_type   = 'PLANT'
                                                AND    a.valid_yn    = 'Y'
                                                AND     ( operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2 )
                                                UNION
                                                SELECT CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'E' AND b.gubun = 2 THEN  scm_site_id + '~002'
                                                            WHEN operation_group = 'E' AND b.gubun = 3 THEN  scm_site_id + '~003'
                                                            WHEN operation_group = 'A' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '-S~EXW'
                                                       END AS eng_scm_site_id
                                                FROM  ( SELECT a.*
                                                             , di.attribute3 AS division_group
                                                             , di.attribute4 AS division_comp
                                                        --백업받은 테이블로 대체
                                                        --FROM   scm_mst_site      a WITH (NOLOCK)
                                                        --     , scm_mst_division di WITH(NOLOCK)
                                                        FROM   BACKUP_SCM_MST_SITE_PROD      a WITH (NOLOCK)
                                                             , BACKUP_SCM_MST_DIVISION_PROD di WITH(NOLOCK)
                                                        WHERE  a.division_id = di.division_id
                                                        AND    di.valid_yn   = 'Y'
                                                      ) a
                                                       LEFT OUTER JOIN (
                                                                        SELECT segment1 -- division_id
                                                                             , segment2 -- scm_site_id
                                                                        --백업받은 테이블로 대체
                                                                        --FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                        FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD WITH(NOLOCK)
                                                                        WHERE  lookup_type = 'PACKER_SCS'
                                                                        AND    valid_yn    = 'Y'
                                                                       ) p
                                                       ON  a.division_id = p.segment1
                                                       AND a.scm_site_id = p.segment2
                                                    ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
                                                WHERE  a.site_type   = 'PLANT'
                                                AND    a.valid_yn    = 'Y'
                                                AND    (
                                                        ( operation_group = 'E' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 3 ) -- 20181001 추가 => AND ISNULL(a.osp_yn, 'N') = 'N'
                                                        OR
                                                        ( operation_group = 'E' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1 ) -- 20181001 추가 외주셀 ***만 생성
                                                        OR
                                                        ( operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2 ) -- 20180807 수정 (변경전 : ( operation_group = 'A' AND b.gubun <= 2)  )
                                                       )
                                                UNION
                                                SELECT CASE WHEN operation_group = 'A' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '~001'
                                                            WHEN operation_group = 'A' AND b.gubun = 3 THEN  scm_site_id + '~002'
                                                            WHEN operation_group = 'A' AND b.gubun = 4 THEN  scm_site_id + '~003'
                                                            WHEN operation_group = 'P' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'P' AND b.gubun = 2 THEN  scm_site_id + '~003'
                                                       END AS eng_scm_site_id
                                                --백업받은 테이블로 대체
                                                --FROM   scm_mst_site      a WITH (NOLOCK)
                                                FROM   BACKUP_SCM_MST_SITE_PROD      a WITH (NOLOCK)
                                                       LEFT OUTER JOIN (
                                                                        SELECT segment1 -- division_id
                                                                             , segment2 -- scm_site_id
                                                                        --백업받은 테이블로 대체
                                                                        --FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                        FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD WITH(NOLOCK)
                                                                        WHERE  lookup_type = 'PACKER_SCS'
                                                                        AND    valid_yn    = 'Y'
                                                                       ) p
                                                       ON  a.division_id = p.segment1
                                                       AND a.scm_site_id = p.segment2
                                                    ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
                                                WHERE  site_type   = 'PLANT'
                                                AND    valid_yn    = 'Y'
                                                AND    (( a.operation_group = 'E' AND b.gubun <= 3 )
                                                        OR
                                                        ( a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 4)
                                                        OR
                                                        ( a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1) --20180822 추가 외주셀 ***만 생성
                                                        OR
                                                        ( a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2)
                                                        OR
                                                        ( a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1) --20180822 추가 외주팩 ***만 생성
                                                       )
                                                AND    operation_group <> 'E'
                                                UNION
                                                --백업받은 테이블로 대체
                                                --SELECT ENG_SCM_SITE_ID FROM scm_mst_site_eng WITH(NOLOCK)
                                                SELECT ENG_SCM_SITE_ID FROM BACKUP_SCM_MST_SITE_ENG_PROD WITH(NOLOCK)
                                                GROUP BY ENG_SCM_SITE_ID
                                               -- 가상 추가 끝
                                               ) P
                                            ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                   WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                   AND   M.ROLL01 = 'WERKS_D'
                                   AND   M.ROLL02 = ''
                                   /*AND   M.ETC6 = N'매핑확정'*/ ) P
                          WHERE  ATTRIBUTE5 IS NOT NULL
                          UNION
                          SELECT 'SCP_SITE_ID' AS CODETYPE
                                ,[CODE_OLD_01] AS [OLD_VALUE1]
                                ,[CODE_NEW_01] AS [NEW_VALUE1]
                                ,'1'           AS [ELEMENT1]
                                ,[ROLL01]      AS [ELEMENT2]
                                ,NULL          AS [DESC1]
                                ,NULL          AS [DESC2]
                                ,[ETC6]        AS [COMMENT6]
                                ,[MAPPING_KEY] AS [COMMENT7]
                                ,'Y'           AS [ACTIVE_FLAG]
                                ,[ATTRIBUTE5]
                          FROM   ( SELECT M.[IFSEQNO]
                                         ,M.[ROLL01]
                                         ,M.[CODE_OLD_01]  AS [MAPPING_KEY]
                                         ,P.SCM_SITE_ID    AS [CODE_OLD_01]
                                         ,REPLACE(SCM_SITE_ID, M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                         ,M.[ETC6]
                                         ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                               --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                   FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                        --백업받은 테이블로 대체
                                        --INNER HASH JOIN ( SELECT P.SCM_SITE_ID FROM [SCM_MST_SITE] P WITH(NOLOCK)
                                        INNER HASH JOIN ( SELECT P.SCM_SITE_ID FROM [BACKUP_SCM_MST_SITE_PROD] P WITH(NOLOCK)
                                               -- 가상 추가 시작
                                               UNION
                                               SELECT CASE WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '-S'
                                                            ELSE scm_site_id
                                                       END AS scm_site_id
                                                FROM  ( SELECT a.*
                                                             , di.attribute3 AS division_group
                                                             , di.attribute4 AS division_comp
                                                        --백업받은 테이블로 대체
                                                        --FROM   scm_mst_site      a WITH (NOLOCK)
                                                        --     , scm_mst_division di WITH(NOLOCK)
                                                        FROM   BACKUP_SCM_MST_SITE_PROD      a WITH (NOLOCK)
                                                             , BACKUP_SCM_MST_DIVISION_PROD di WITH(NOLOCK)
                                                        WHERE  a.division_id = di.division_id
                                                        AND    di.valid_yn   = 'Y'
                                                      ) a
                                                       LEFT OUTER JOIN (
                                                                        SELECT segment1 -- division_id
                                                                             , segment2 -- scm_site_id
                                                                        --백업받은 테이블로 대체
                                                                        --FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                        FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD WITH(NOLOCK)
                                                                        WHERE  lookup_type = 'PACKER_SCS'
                                                                        AND    valid_yn    = 'Y'
                                                                       ) p
                                                       ON  a.division_id = p.segment1
                                                       AND a.scm_site_id = p.segment2
                                                    ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
                                                WHERE  a.site_type   = 'PLANT'
                                                AND    a.valid_yn    = 'Y'
                                                AND     ( operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2 )
                                                UNION
                                                SELECT CASE WHEN operation_group = 'E' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'E' AND b.gubun = 2 THEN  scm_site_id + '~002'
                                                            WHEN operation_group = 'E' AND b.gubun = 3 THEN  scm_site_id + '~003'
                                                            WHEN operation_group = 'A' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '-S~EXW'
                                                       END AS eng_scm_site_id
                                                FROM  ( SELECT a.*
                                                             , di.attribute3 AS division_group
                                                             , di.attribute4 AS division_comp
                                                        --백업받은 테이블로 대체
                                                        --FROM   scm_mst_site      a WITH (NOLOCK)
                                                        --     , scm_mst_division di WITH(NOLOCK)
                                                        FROM   BACKUP_SCM_MST_SITE_PROD      a WITH (NOLOCK)
                                                             , BACKUP_SCM_MST_DIVISION_PROD di WITH(NOLOCK)
                                                        WHERE  a.division_id = di.division_id
                                                        AND    di.valid_yn   = 'Y'
                                                      ) a
                                                       LEFT OUTER JOIN (
                                                                        SELECT segment1 -- division_id
                                                                             , segment2 -- scm_site_id
                                                                        --백업받은 테이블로 대체
                                                                        --FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                        FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD WITH(NOLOCK)
                                                                        WHERE  lookup_type = 'PACKER_SCS'
                                                                        AND    valid_yn    = 'Y'
                                                                       ) p
                                                       ON  a.division_id = p.segment1
                                                       AND a.scm_site_id = p.segment2
                                                    ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
                                                WHERE  a.site_type   = 'PLANT'
                                                AND    a.valid_yn    = 'Y'
                                                AND    (
                                                        ( operation_group = 'E' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 3 ) -- 20181001 추가 => AND ISNULL(a.osp_yn, 'N') = 'N'
                                                        OR
                                                        ( operation_group = 'E' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1 ) -- 20181001 추가 외주셀 ***만 생성
                                                        OR
                                                        ( operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2 ) -- 20180807 수정 (변경전 : ( operation_group = 'A' AND b.gubun <= 2)  )
                                                       )
                                                UNION
                                                SELECT CASE WHEN operation_group = 'A' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'A' AND b.gubun = 2 THEN  scm_site_id + '~001'
                                                            WHEN operation_group = 'A' AND b.gubun = 3 THEN  scm_site_id + '~002'
                                                            WHEN operation_group = 'A' AND b.gubun = 4 THEN  scm_site_id + '~003'
                                                            WHEN operation_group = 'P' AND b.gubun = 1 THEN  scm_site_id + '~***'
                                                            WHEN operation_group = 'P' AND b.gubun = 2 THEN  scm_site_id + '~003'
                                                       END AS eng_scm_site_id
                                                --백업받은 테이블로 대체
                                                --FROM   scm_mst_site      a WITH (NOLOCK)
                                                FROM   BACKUP_SCM_MST_SITE_PROD      a WITH (NOLOCK)
                                                       LEFT OUTER JOIN (
                                                                        SELECT segment1 -- division_id
                                                                             , segment2 -- scm_site_id
                                                                        --백업받은 테이블로 대체
                                                                        --FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                        FROM   BACKUP_SCM_ADM_LOOKUP_MASTER_DETAIL_PACKER_SCS_PROD WITH(NOLOCK)
                                                                        WHERE  lookup_type = 'PACKER_SCS'
                                                                        AND    valid_yn    = 'Y'
                                                                       ) p
                                                       ON  a.division_id = p.segment1
                                                       AND a.scm_site_id = p.segment2
                                                    ,  ( SELECT 1 gubun UNION ALL SELECT 2 gubun UNION ALL SELECT 3 gubun UNION ALL SELECT 4 gubun) b
                                                WHERE  site_type   = 'PLANT'
                                                AND    valid_yn    = 'Y'
                                                AND    (( a.operation_group = 'E' AND b.gubun <= 3 )
                                                        OR
                                                        ( a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 4)
                                                        OR
                                                        ( a.operation_group = 'A' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1) --20180822 추가 외주셀 ***만 생성
                                                        OR
                                                        ( a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'N' AND b.gubun <= 2)
                                                        OR
                                                        ( a.operation_group = 'P' AND ISNULL(a.osp_yn, 'N') = 'Y' AND b.gubun <= 1) --20180822 추가 외주팩 ***만 생성
                                                       )
                                                AND    operation_group <> 'E'
                                                UNION
                                                --백업받은 테이블로 대체
                                                --SELECT ENG_SCM_SITE_ID FROM scm_mst_site_eng WITH(NOLOCK)
                                                SELECT ENG_SCM_SITE_ID FROM BACKUP_SCM_MST_SITE_ENG_PROD WITH(NOLOCK)
                                                GROUP BY ENG_SCM_SITE_ID
                                               -- 가상 추가 끝
                                               ) P
                                            ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                   WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                   AND   M.ROLL01 = 'WERKS_D'
                                   AND   M.ROLL02 = ''
                                   /*AND   M.ETC6 = N'매핑확정'*/ ) P
                          WHERE  ATTRIBUTE5 IS NOT NULL ) P
                GROUP BY [OLD_VALUE1], [NEW_VALUE1]


              ) B
            ON 1=1 AND A.CODETYPE = @codetype AND A.ATTRIBUTE5 = B.ATTRIBUTE5
            AND A.OLD_VALUE1 = B.OLD_VALUE1

            when matched then
                --begin matched
                UPDATE Set A.NEW_VALUE1 = B.[NEW_VALUE1]
                         , A.NEW_VALUE2 = B.[NEW_VALUE2]
                         , A.ATTRIBUTE5 = B.[ATTRIBUTE5]
                         , A.UPDATE_DATE = GETDATE()
                --end matched
            when not matched then
                --Begin not matched
                INSERT ([CODETYPE]
                       ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                       ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                       ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                       ,[DESC1],[DESC2],[DESC3],[DESC4]
                       ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                       ,[ACTIVE_FLAG]
                       ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                       ,[INSERT_ID]
                       ,[INSERT_DATE]
                       ,[UPDATE_ID]
                       ,[UPDATE_DATE])
                VALUES
                       (@codetype
                       ,B.[OLD_VALUE1],B.[OLD_VALUE2],B.[OLD_VALUE3],B.[OLD_VALUE4]
                       ,B.[NEW_VALUE1],B.[NEW_VALUE2],B.[NEW_VALUE3],B.[NEW_VALUE4]
                       ,B.[ELEMENT1],B.[ELEMENT2],B.[ELEMENT3],B.[ELEMENT4]
                       ,B.[DESC1],B.[DESC2],'',''
                       ,'','','','','',B.[COMMENT6]
                       ,'SCP SITE ID'
                       ,'Y' --AS [ACTIVE_FLAG]
                       ,'-' ,'-','-','-'
                       , B.[ATTRIBUTE5]
                       ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
                       );

            --#################################################################################################
            -- 2025-07-01 2차ROLLIN 시 북미법인 오펀시 추가한 로직 : COMPANY_ID를 SCP_SITE_ID에 없을 경우 추가한다.
            --#################################################################################################
            INSERT INTO NERP_CONV_MASTER (
                   CODETYPE
                  ,OLD_VALUE1
                  ,OLD_VALUE2
                  ,OLD_VALUE3
                  ,OLD_VALUE4
                  ,NEW_VALUE1
                  ,NEW_VALUE2
                  ,NEW_VALUE3
                  ,NEW_VALUE4
                  ,ELEMENT1
                  ,ELEMENT2
                  ,ELEMENT3
                  ,ELEMENT4
                  ,DESC1
                  ,DESC2
                  ,DESC3
                  ,DESC4
                  ,COMMENT1
                  ,COMMENT2
                  ,COMMENT3
                  ,COMMENT4
                  ,COMMENT5
                  ,COMMENT6
                  ,COMMENT7
                  ,ACTIVE_FLAG
                  ,ATTRIBUTE1
                  ,ATTRIBUTE2
                  ,ATTRIBUTE3
                  ,ATTRIBUTE4
                  ,ATTRIBUTE5
                  ,INSERT_ID
                  ,INSERT_DATE
                  ,UPDATE_ID
                  ,UPDATE_DATE
            )
            SELECT x.*
            FROM (
                SELECT
                      -- CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN 'SCP_SITE_ID' ELSE  mcv.CODETYPE END AS NCODETYPE
                      --,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN '11'          ELSE  mcv.ELEMENT1 END AS NELEMENT1
                      --,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN 'BUKRS'       ELSE  mcv.ELEMENT2 END AS NELEMENT2
                      --,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN NULL          ELSE  mcv.DESC1    END AS NDESC1
                      --,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN NULL          ELSE  mcv.DESC2    END AS NDESC2
                      --,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN 'SCP SITE ID' ELSE  mcv.COMMENT7 END AS NCOMMENT7
                      --,mcv.CODETYPE
                      --,
                       CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN 'SCP_SITE_ID' ELSE  mcv.CODETYPE END AS NCODETYPE
                      ,mcv.OLD_VALUE1
                      ,mcv.OLD_VALUE2
                      ,mcv.OLD_VALUE3
                      ,mcv.OLD_VALUE4
                      ,mcv.NEW_VALUE1
                      ,mcv.NEW_VALUE2
                      ,mcv.NEW_VALUE3
                      ,mcv.NEW_VALUE4
                      --,mcv.ELEMENT1
                      ,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN '11'          ELSE  mcv.ELEMENT1 END AS NELEMENT1
                      --,mcv.ELEMENT2
                      ,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN 'BUKRS'       ELSE  mcv.ELEMENT2 END AS NELEMENT2
                      ,mcv.ELEMENT3
                      ,mcv.ELEMENT4
                      --,mcv.DESC1
                      ,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN NULL          ELSE  mcv.DESC1    END AS NDESC1
                      --,mcv.DESC2
                      ,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN NULL          ELSE  mcv.DESC2    END AS NDESC2
                      ,mcv.DESC3
                      ,mcv.DESC4
                      ,mcv.COMMENT1
                      ,mcv.COMMENT2
                      ,mcv.COMMENT3
                      ,mcv.COMMENT4
                      ,mcv.COMMENT5
                      ,mcv.COMMENT6
                      --,mcv.COMMENT7
                      ,CASE WHEN mcv.CODETYPE = 'COMPANY_ID' THEN 'SCP SITE ID' ELSE  mcv.COMMENT7 END AS NCOMMENT7
                      ,mcv.ACTIVE_FLAG
                      ,mcv.ATTRIBUTE1
                      ,mcv.ATTRIBUTE2
                      ,mcv.ATTRIBUTE3
                      ,mcv.ATTRIBUTE4
                      ,mcv.ATTRIBUTE5
                      ,mcv.INSERT_ID
                      ,GETDATE() INSERT_DATE
                      ,mcv.UPDATE_ID
                      ,GETDATE() UPDATE_DATE
                FROM   NERP_CONV_MASTER_CFM_V mcv WITH(NOLOCK)
                WHERE  1=1
                --AND    mcv.CODETYPE IN ( 'COMPANY_ID','SCP_SITE_ID')
                AND    mcv.CODETYPE = 'COMPANY_ID'
                AND    mcv.ATTRIBUTE5 = @p_rollin
            ) x
            WHERE 1=1
            AND   NOT EXISTS (SELECT 1
                              FROM   NERP_CONV_MASTER_CFM_V dmcv WITH(NOLOCK)
                              WHERE  dmcv.CODETYPE = N'SCP_SITE_ID'
                              AND    dmcv.OLD_VALUE1 = x.OLD_VALUE1
                              AND    dmcv.OLD_VALUE2 = x.OLD_VALUE2
                              AND    dmcv.NEW_VALUE1 = x.NEW_VALUE1
                              AND    dmcv.NEW_VALUE2 = x.NEW_VALUE2
                              )
            ORDER BY 1,2;


        end
        --1개 컬럼으로 구성되는 것 처리
        else if(@p_sys_works = 'SCP_SITE_DESCRIPTION' )
        begin

            print '--MERGE/ELEMENT1 SCP_SITE_DESCRIPTION'

            set @element1 = @p_sys_works

            print '@p_sys_works :'+@p_sys_works;
            print '@element1    :'+@element1   ;
            print '@element2    :'+@element2   ;

            --2025-05-26 삭제후 입력은 SCM_MST_SITE 값이 변경후에 DESC는 과거 값을 가져올 수가 없어서 백업한것 사용하기
            --운영에서는 테이블 만들어서 사용해야 된다.(최초 생성시의 값만 존재한다.)
            --운영 백업받아 놓은 것으로 사용한다 [BACKUP_SCM_MST_SITE_PROD]

            merge into  [NERP_CONV_MASTER] A
            using
                (

              SELECT 'SCP_SITE_DESCRIPTION'   AS CODETYPE
                    ,[OLD_VALUE1]    AS [OLD_VALUE1],''[OLD_VALUE2],''[OLD_VALUE3],''[OLD_VALUE4]
                    ,[NEW_VALUE1]    AS [NEW_VALUE1],''[NEW_VALUE2],''[NEW_VALUE3],''[NEW_VALUE4]
                    ,MAX([ELEMENT1]) AS [ELEMENT1]
                    ,MAX([ELEMENT2]) AS [ELEMENT2],''[ELEMENT3],''[ELEMENT4]
                    ,MAX([DESC1])    AS [DESC1]
                    ,MAX([DESC2])    AS [DESC2]
                    ,MAX([COMMENT6]) AS [COMMENT6]
                    ,MAX([COMMENT7]) AS [COMMENT7]
                    ,MAX([ACTIVE_FLAG]) AS [ACTIVE_FLAG]
                    ,MAX([ATTRIBUTE5]) AS [ATTRIBUTE5]
                    ,'SCP_CONV_MASTER' AS INSERT_ID
                    ,GETDATE()         AS INSERT_DATE
                    ,'SCP_CONV_MASTER' AS UPDATE_ID
                    ,GETDATE()         AS UPDATE_DATE
              FROM  (     SELECT [CODE_OLD_01] AS [OLD_VALUE1]
                                ,[CODE_NEW_01] AS [NEW_VALUE1]
                                ,'2'           AS [ELEMENT1]
                                ,[ROLL01]      AS [ELEMENT2]
                                ,CASE WHEN 1=2 THEN  '' END AS [DESC1]
                                ,CASE WHEN 1=2 THEN  '' END AS [DESC2]
                                ,[ETC6]        AS [COMMENT6]
                                ,[MAPPING_KEY] AS [COMMENT7]
                                ,'Y'           AS [ACTIVE_FLAG]
                                ,[ATTRIBUTE5]
                          FROM   ( SELECT M.[IFSEQNO]
                                         ,M.[ROLL01]
                                         ,M.[CODE_OLD_01]      AS [MAPPING_KEY]
                                         ,P.[SITE_DESCRIPTION] AS [CODE_OLD_01]
                                         ,REPLACE(P.[SITE_DESCRIPTION], M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                         ,M.[ETC6]
                                         ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                               --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                   FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                        --백업받은 테이블로 대체
                                        --JOIN [SCM_MST_SITE]     P WITH(NOLOCK)
                                        JOIN [BACKUP_SCM_MST_SITE_PROD]     P WITH(NOLOCK)
                                            ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                            AND P.SITE_DESCRIPTION LIKE '%'+ SUBSTRING( P.SCM_SITE_ID, 1,4) + '%'
                                   WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                   AND   M.ROLL01 = 'WERKS_D'
                                   AND   M.ROLL02 = ''
                                   /*AND   M.ETC6 = N'매핑확정'*/ ) P
                          WHERE  ATTRIBUTE5 IS NOT NULL
                          UNION
                          SELECT [CODE_OLD_01] AS [OLD_VALUE1]
                                ,[CODE_NEW_01] AS [NEW_VALUE1]
                                ,'1'           AS [ELEMENT1]
                                ,[ROLL01]      AS [ELEMENT2]
                                ,NULL          AS [DESC1]
                                ,NULL          AS [DESC2]
                                ,[ETC6]        AS [COMMENT6]
                                ,[MAPPING_KEY] AS [COMMENT7]
                                ,'Y'           AS [ACTIVE_FLAG]
                                ,[ATTRIBUTE5]
                          FROM   ( SELECT M.[IFSEQNO]
                                         ,M.[ROLL01]
                                         ,M.[CODE_OLD_01]  AS [MAPPING_KEY]
                                         ,P.[SITE_DESCRIPTION] AS [CODE_OLD_01]
                                         ,REPLACE(P.[SITE_DESCRIPTION], M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                         ,M.[ETC6]
                                         ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                               --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                               WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                   FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                        --백업받은 테이블로 대체
                                        --JOIN [SCM_MST_SITE]     P WITH(NOLOCK)
                                        JOIN [BACKUP_SCM_MST_SITE_PROD]     P WITH(NOLOCK)
                                            ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                            AND P.SITE_DESCRIPTION LIKE '%'+ SUBSTRING( P.SCM_SITE_ID, 1,4) + '%'
                                   WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                   AND   M.ROLL01 = 'BUKRS'
                                   AND   M.ROLL02 = ''
                                   /*AND   M.ETC6 = N'매핑확정'*/ ) P
                          WHERE  ATTRIBUTE5 IS NOT NULL ) P
                GROUP BY [OLD_VALUE1], [NEW_VALUE1]
              ) B
            ON 1=1 AND A.CODETYPE = @codetype AND A.ATTRIBUTE5 = B.ATTRIBUTE5
            AND A.OLD_VALUE1 = B.OLD_VALUE1

            when matched then
                --begin matched
                UPDATE Set A.NEW_VALUE1 = B.[NEW_VALUE1]
                         , A.NEW_VALUE2 = B.[NEW_VALUE2]
                         , A.ATTRIBUTE5 = B.[ATTRIBUTE5]
                         , A.UPDATE_DATE = GETDATE()
                --end matched
            when not matched then
                --Begin not matched
                INSERT ([CODETYPE]
                       ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                       ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                       ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                       ,[DESC1],[DESC2],[DESC3],[DESC4]
                       ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                       ,[ACTIVE_FLAG]
                       ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                       ,[INSERT_ID]
                       ,[INSERT_DATE]
                       ,[UPDATE_ID]
                       ,[UPDATE_DATE])
                VALUES
                       (@codetype
                       ,B.[OLD_VALUE1],B.[OLD_VALUE2],B.[OLD_VALUE3],B.[OLD_VALUE4]
                       ,B.[NEW_VALUE1],B.[NEW_VALUE2],B.[NEW_VALUE3],B.[NEW_VALUE4]
                       ,B.[ELEMENT1],B.[ELEMENT2],B.[ELEMENT3],B.[ELEMENT4]
                       ,B.[DESC1],B.[DESC2],'',''
                       ,'','','','','',B.[COMMENT6]
                       ,'SCP SITE DESCRIPTION'
                       ,'Y' --AS [ACTIVE_FLAG]
                       ,'-' ,'-','-','-'
                       , B.[ATTRIBUTE5]
                       ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
                       );

        end
        --2025.04.08 김준규 SCP용 추가 종료
        --1개 컬럼으로 구성되는 것 처리
        else
        begin

            print '--MERGE/ELEMENT1 OTHERS'

            set @element1 = @p_sys_works

            print '@p_sys_works :'+@p_sys_works;
            print '@element1    :'+@element1   ;
            print '@element2    :'+@element2   ;

            merge into  [NERP_CONV_MASTER] A
            using
                (
                select x.KEYID
                      ,x.IFSEQNO
                      ,x.SERVER
                      ,x.CODEMAPID
                      ,x.MODULE_CODE
                      ,x.ROLL01
                      ,x.ROLL02
                      ,x.ROLL03
                      ,x.ROLL04
                      ,x.CODE_OLD_01
                      ,x.CODE_OLD_02
                      ,x.CODE_OLD_03
                      ,x.CODE_OLD_04
                      ,x.CODE_NEW_01
                      ,x.CODE_NEW_02
                      ,x.CODE_NEW_03
                      ,x.CODE_NEW_04
                      ,x.DESC01
                      ,x.DESC02
                      ,x.DESC03
                      ,x.DESC04
                      ,x.ETC1
                      ,x.ETC2
                      ,x.ETC3
                      ,x.ETC4
                      ,x.ETC5
                      ,x.ETC6
                      ,x.ERDAT
                      ,x.ERNAM
                      ,x.AEDAT
                      ,x.AENAM
                      ,x.CREATE_DATE
                      ,x.CREATION_BY
                      ,x.TRANSFER_DATE
                      ,x.TRANSACTION_FLAG
                      ,X.ATTRIBUTE5
                FROM (
                    select x.KEYID
                          ,x.IFSEQNO
                          ,x.SERVER
                          ,x.CODEMAPID
                          ,x.MODULE_CODE
                          ,x.ROLL01
                          ,x.ROLL02
                          ,x.ROLL03
                          ,x.ROLL04
                          ,x.CODE_OLD_01
                          ,x.CODE_OLD_02
                          ,x.CODE_OLD_03
                          ,x.CODE_OLD_04
                          ,x.CODE_NEW_01
                          ,x.CODE_NEW_02
                          ,x.CODE_NEW_03
                          ,x.CODE_NEW_04
                          ,x.DESC01
                          ,x.DESC02
                          ,x.DESC03
                          ,x.DESC04
                          ,x.ETC1
                          ,x.ETC2
                          ,x.ETC3
                          ,x.ETC4
                          ,x.ETC5
                          ,x.ETC6
                          ,x.ERDAT
                          ,x.ERNAM
                          ,x.AEDAT
                          ,x.AENAM
                          ,x.CREATE_DATE
                          ,x.CREATION_BY
                          ,x.TRANSFER_DATE
                          ,x.TRANSACTION_FLAG
                          ,X.ATTRIBUTE5
                          ,ROW_NUMBER()OVER(PARTITION BY X.ATTRIBUTE5,CODE_OLD_01 ORDER BY X.KEYID DESC) RNUM
                    from (SELECT X.*
                               ,ATTRIBUTE5 =  CASE WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D','LIFNR' )
                                                 AND ( CODE_NEW_01 like 'HQ%'
                                                   OR  CODE_NEW_01 like 'WA%' ) THEN '1ST'
                                                --WHEN ROLL01 IN ('LIFNR') AND  LEN(CODE_NEW_01)  > 4  THEN '1ST'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('C100', 'G480') THEN '1ST'
                                                WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('KR', 'PL') THEN '1ST'
                                                --WHEN ROLL01 IN ('VTWEG', 'BLART', 'KUNNR', 'EKGRP', 'VKGRP', 'AUART', 'LIFNR', 'INCO1')  THEN '1ST' -- 전체 Conversion 대상
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                --2025.04.08 김준규 ROLLIN 차수 서증 시작
                                                 AND ( CODE_NEW_01 like 'MI%'
                                                   OR  CODE_NEW_01 like 'ST%'
                                                   OR  CODE_NEW_01 like 'HD%'
                                                   OR  CODE_NEW_01 like 'HG%'
                                                   OR  CODE_NEW_01 like 'VT%' )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '2ND'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G380','G810','G820','G870','G880') THEN '2ND'
                                                --미국기준 2차는 KALSM_D에 CODE_NEW_03이 없음
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AU', 'AZ', 'EG', 'IL', 'MI', 'NA', 'NB', 'NJ', 'TW', 'VT', 'CN') THEN '2ND'
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'NJ%'
                                                   OR  CODE_NEW_01 like 'NA%'
                                                   OR  CODE_NEW_01 like 'NB%'
                                                   OR  CODE_NEW_01 like 'CH%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '3RD'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G990', 'G450', 'G630', 'G180') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'AZ%'
                                                   OR  CODE_NEW_01 like 'AE%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '4TH'
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G940','G830') THEN '4TH'
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'GM%'
                                                   OR  CODE_NEW_01 like 'GH%'
                                                   OR  CODE_NEW_01 like 'HM%'
                                                   OR  CODE_NEW_01 like 'EG%'
                                                   OR  CODE_NEW_01 like 'AU%'
                                                   OR  CODE_NEW_01 like 'IL%'
                                                   OR  CODE_NEW_01 like 'JP%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '5TH'
                                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G540','G690','G960','G670','G740','G890','G950') THEN '5TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                                 AND ( CODE_NEW_01 like 'TW%'
                                                   OR  CODE_NEW_01 like 'TW%'
                                                   )
                                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '9TH'
                                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G680','G680') THEN '9TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                                ELSE @p_rollin --'2ND'
                                                --2025.04.08 김준규 ROLLIN 차수 서증 종료
                                            END
                         FROM   DBO.ZNERP_TOBE_CODE_INFO_SN x with(nolock)
                         ) X
                    where 1=1
                    AND IFSEQNO = @maxIfseqno
                    AND ROLL01 = @element1 AND ISNULL(ROLL02, '') = ''
                    AND CODE_OLD_01 <> ''
                    AND CODE_OLD_01 <> CODE_NEW_01
                    AND ( ETC2 NOT like N'%삭제%' AND ETC1 NOT LIKE N'%Delete%' AND ETC4 NOT like N'%삭제%' AND CODE_NEW_01 NOT like N'%삭제%' AND CODE_NEW_02 NOT like N'%삭제%' AND CODE_OLD_01 NOT like N'%신규%' )
                    /*AND (ISNULL(ETC6,'') IN ( N'매핑확정', N'1차 완료')
                      OR ISNULL(ETC6,'') LIKE N'%1차확정%' )*/ -- OR이므로 matching_option이 0이 아닐 때만 '매핑확정' 조건이 적용된다
                --2025.04.08 김준규 중복시 에러 방지 추가 시작
                ) X
                WHERE RNUM = 1
                AND   x.ATTRIBUTE5 >= @p_rollin
                --2025.04.08 김준규 중복시 에러 방지 추가 종료
            ) B
            ON 1=1 AND A.CODETYPE = @codetype AND A.ATTRIBUTE5 = B.ATTRIBUTE5
            AND A.OLD_VALUE1 = B.CODE_OLD_01

            when matched then
                --begin matched
                UPDATE Set A.NEW_VALUE1 = B.CODE_NEW_01
                         , A.NEW_VALUE2 = B.CODE_NEW_02
                         , A.ATTRIBUTE5 = B.ATTRIBUTE5
                         , A.UPDATE_DATE = GETDATE()
                --end matched
            when not matched then
                --Begin not matched
                INSERT ([CODETYPE]
                       ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                       ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                       ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                       ,[DESC1],[DESC2],[DESC3],[DESC4]
                       ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                       ,[ACTIVE_FLAG]
                       ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                       ,[INSERT_ID]
                       ,[INSERT_DATE]
                       ,[UPDATE_ID]
                       ,[UPDATE_DATE])
                VALUES
                       (@codetype
                       ,B.CODE_OLD_01, B.CODE_OLD_02, B.CODE_OLD_03, B.CODE_OLD_04
                       ,B.CODE_NEW_01, B.CODE_NEW_02, B.CODE_NEW_03, B.CODE_NEW_04
                       ,B.ROLL01 ,B.ROLL02 ,B.ROLL03 ,B.ROLL04
                       --2025.04.08 김준규 DESC 값 업력 시작
                       ,B.DESC01,B.DESC02,B.DESC03,B.DESC04
                       --2025.04.08 김준규 DESC 값 업력 종료
                       ,B.ETC1,B.ETC2,B.ETC3,B.ETC4,B.ETC5,B.ETC6
                       ,'Customer Number'
                       ,'Y' --AS [ACTIVE_FLAG]
                       ,'-' ,'-','-','-'
                       ,B.ATTRIBUTE5
                       ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
                       );
        end


    end

    if @p_sys_gubun = 'INSERT'
    begin
        print @p_sys_gubun

        print '--INSERT/ELEMENT2'

        if (@p_sys_works = 'UMSKZ' or @p_sys_works = 'LGORT_D' or @p_sys_works = 'PRCTR' or @p_sys_works = 'MWSKZ' or @p_sys_works = 'INCO1' /*or @p_sys_works = 'VTWEG'*/)
        begin
            if @p_sys_works = 'UMSKZ'
            begin
                set @element1 = 'KOART'
            end
            if @p_sys_works = 'LGORT_D'
            begin
                set @element1 = 'WERKS_D'
            end
            if @p_sys_works = 'PRCTR'
            begin
                set @element1 = 'KOKRS'
            end
            if @p_sys_works = 'MWSKZ'
            begin
                set @element1 = 'KALSM_D'
            end

            set @element2 = @p_sys_works;

            if @p_sys_works = 'INCO1'
            begin
                set @element1 = 'INCO1'
                set @element2 = 'VTWEG'
            end


            INSERT INTO [NERP_CONV_MASTER] (
                    [CODETYPE]
                    ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                    ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                    ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                    ,[DESC1],[DESC2],[DESC3],[DESC4]
                    ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                    ,[ACTIVE_FLAG]
                    ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                    ,[INSERT_ID]
                    ,[INSERT_DATE]
                    ,[UPDATE_ID]
                    ,[UPDATE_DATE])
            SELECT
                    @codetype
                    ,CODE_OLD_01
                    , (CASE WHEN ROLL01 =  'INCO1' THEN IIF(SERVER='O', 'E', SERVER)  ELSE CODE_OLD_02 END )
                    , CODE_OLD_03, CODE_OLD_04
                    ,CODE_NEW_01
                    , (CASE WHEN ROLL01 =  'INCO1' THEN IIF(SERVER='O', 'E', SERVER)  ELSE CODE_NEW_02 END )
                    , CODE_NEW_03, CODE_NEW_04
                    ,ROLL01 ,ROLL02 ,ROLL03 ,ROLL04
                    --2025.04.08 김준규 DESC 값 업력 시작
                    ,DESC01,DESC02,DESC03,DESC04
                    --2025.04.08 김준규 DESC 값 업력 종료
                    ,ETC1,ETC2,ETC3,ETC4,ETC5,ETC6
                    ,'Customer Number'
                    ,'Y' --AS [ACTIVE_FLAG]
                    ,'-' ,'-','-','-'
                        , CASE WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                 AND ( CODE_NEW_01 like 'HQ%'
                                   OR  CODE_NEW_01 like 'WA%' ) THEN '1ST'
                                --WHEN ROLL01 IN ('LIFNR') AND  LEN(CODE_NEW_01)  > 4  THEN '1ST'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('C100', 'G480') THEN '1ST'
                                WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('KR', 'PL') THEN '1ST'
                                --WHEN ROLL01 IN ('VTWEG', 'BLART', 'KUNNR', 'EKGRP', 'VKGRP', 'AUART', 'LIFNR', 'INCO1')  THEN '1ST' -- 전체 Conversion 대상
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                    --2025.04.08 김준규 ROLLIN 차수 서증 시작
                                    AND ( CODE_NEW_01 like 'MI%'
                                    OR  CODE_NEW_01 like 'ST%'
                                    OR  CODE_NEW_01 like 'HD%'
                                    OR  CODE_NEW_01 like 'HG%'
                                    OR  CODE_NEW_01 like 'VT%' )
                                    AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '2ND'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G380','G810','G820','G870','G880') THEN '2ND'
                                --미국기준 2차는 KALSM_D에 CODE_NEW_03이 없음
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AU', 'AZ', 'EG', 'IL', 'MI', 'NA', 'NB', 'NJ', 'TW', 'VT', 'CN') THEN '2ND'
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                    AND ( CODE_NEW_01 like 'NJ%'
                                    OR  CODE_NEW_01 like 'NA%'
                                    OR  CODE_NEW_01 like 'NB%'
                                    OR  CODE_NEW_01 like 'CH%'
                                    )
                                    AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '3RD'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G990', 'G450', 'G630', 'G180') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                    AND ( CODE_NEW_01 like 'AZ%'
                                    OR  CODE_NEW_01 like 'AE%'
                                   )
                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '4TH'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G940','G830') THEN '4TH'
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                 AND ( CODE_NEW_01 like 'GM%'
                                   OR  CODE_NEW_01 like 'GH%'
                                   OR  CODE_NEW_01 like 'HM%'
                                   OR  CODE_NEW_01 like 'EG%'
                                   OR  CODE_NEW_01 like 'AU%'
                                   OR  CODE_NEW_01 like 'IL%'
                                   OR  CODE_NEW_01 like 'JP%'
                                   )
                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '5TH'
                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G540','G690','G960','G670','G740','G890','G950') THEN '5TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                 AND ( CODE_NEW_01 like 'TW%'
                                   OR  CODE_NEW_01 like 'TW%'
                                   )
                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '9TH'
                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G680','G680') THEN '9TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                ELSE @p_rollin --'2ND'
                                --2025.04.08 김준규 ROLLIN 차수 서증 종료
                            END

                    ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
            FROM ZNERP_TOBE_CODE_INFO_SN x with(nolock)
            where 1=1
            AND IFSEQNO = @maxIfseqno
            AND ROLL01 = @element1 AND ROLL02 = @element2
            AND CODE_OLD_01 <> ''
            AND ( ETC2 NOT like N'%삭제%' AND ETC1 NOT LIKE N'%Delete%' AND ETC4 NOT like N'%삭제%' AND CODE_NEW_01 NOT like N'%삭제%' AND CODE_NEW_02 NOT like N'%삭제%' AND CODE_OLD_01 NOT like N'%신규%' )
            AND CODE_OLD_02 =  (CASE WHEN ROLL01 =  'INCO1' THEN  '' ELSE CODE_OLD_02 END )
            --AND CODE_OLD_01 <> CODE_NEW_01
            AND 1 = ( CASE WHEN ROLL01 = 'KALSM_D' AND CODE_OLD_02 <> CODE_NEW_02 AND CODE_NEW_02 <> '' THEN 1
                            WHEN ROLL01 <> 'KALSM_D' THEN 1 ELSE 0 END)
            AND 1 = ( CASE WHEN ROLL01 = 'INCO1' AND CODE_OLD_01 <> CODE_NEW_01 THEN 1
                            WHEN ROLL01 <> 'INCO1' THEN 1 ELSE 0 END)
            /*AND (ISNULL(ETC6,'') IN ( N'매핑확정', N'1차 완료')
              OR ISNULL(ETC6,'') LIKE N'%1차확정%' ) */-- OR이므로 matching_option이 0이 아닐 때만 '매핑확정' 조건이 적용된다

        end

        --2025.04.08 김준규 SCP용 추가 시작
        else if(@p_sys_works = 'SCP_SITE_ID' )
        begin

            print '--MERGE/ELEMENT1'

            set @element1 = @p_sys_works

            INSERT INTO [NERP_CONV_MASTER] (
                    [CODETYPE]
                    ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                    ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                    ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                    ,[DESC1],[DESC2]--,[DESC3],[DESC4]
                    /*,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5]*/,[COMMENT6],[COMMENT7]
                    ,[ACTIVE_FLAG]
                    /*,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4]*/,[ATTRIBUTE5]
                    ,[INSERT_ID]
                    ,[INSERT_DATE]
                    ,[UPDATE_ID]
                    ,[UPDATE_DATE])
            SELECT 'SCP_SITE_ID'   AS CODETYPE
                ,[OLD_VALUE1]    AS [OLD_VALUE1],''[OLD_VALUE2],''[OLD_VALUE3],''[OLD_VALUE4]
                ,[NEW_VALUE1]    AS [NEW_VALUE1],''[NEW_VALUE2],''[NEW_VALUE3],''[NEW_VALUE4]
                ,MAX([ELEMENT1]) AS [ELEMENT1]
                ,MAX([ELEMENT2]) AS [ELEMENT2],''[ELEMENT3],''[ELEMENT4]
                ,MAX([DESC1])    AS [DESC1]
                ,MAX([DESC2])    AS [DESC2]
                ,MAX([COMMENT6]) AS [COMMENT6]
                ,MAX([COMMENT7]) AS [COMMENT7]
                ,MAX([ACTIVE_FLAG]) AS [ACTIVE_FLAG]
                ,MAX([ATTRIBUTE5]) AS [ATTRIBUTE5]
                ,'SCP_CONV_MASTER' AS INSERT_ID
                ,GETDATE()         AS INSERT_DATE
                ,'SCP_CONV_MASTER' AS UPDATE_ID
                ,GETDATE()         AS UPDATE_DATE
            FROM  (     SELECT 'SCP_SITE_ID' AS CODETYPE
                            ,[CODE_OLD_01] AS [OLD_VALUE1]
                            ,[CODE_NEW_01] AS [NEW_VALUE1]
                            ,'2'           AS [ELEMENT1]
                            ,[ROLL01]      AS [ELEMENT2]
                            ,CASE WHEN 1=2 THEN  '' END AS [DESC1]
                            ,CASE WHEN 1=2 THEN  '' END AS [DESC2]
                            ,[ETC6]        AS [COMMENT6]
                            ,[MAPPING_KEY] AS [COMMENT7]
                            ,'Y'           AS [ACTIVE_FLAG]
                            ,[ATTRIBUTE5]
                        FROM   ( SELECT M.[IFSEQNO]
                                        ,M.[ROLL01]
                                        ,M.[CODE_OLD_01]  AS [MAPPING_KEY]
                                        ,P.SCM_SITE_ID    AS [CODE_OLD_01]
                                        ,REPLACE(SCM_SITE_ID, M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                        ,M.[ETC6]
                                        ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                              --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                    JOIN [SCM_MST_SITE]     P WITH(NOLOCK)
                                        ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                AND   M.ROLL01 = 'WERKS_D'
                                AND   M.ROLL02 = ''
                                /*AND   M.ETC6 = N'매핑확정'*/ ) P
                        WHERE  ATTRIBUTE5 IS NOT NULL
                        UNION
                        SELECT 'SCP_SITE_ID' AS CODETYPE
                            ,[CODE_OLD_01] AS [OLD_VALUE1]
                            ,[CODE_NEW_01] AS [NEW_VALUE1]
                            ,'1'           AS [ELEMENT1]
                            ,[ROLL01]      AS [ELEMENT2]
                            ,NULL          AS [DESC1]
                            ,NULL          AS [DESC2]
                            ,[ETC6]        AS [COMMENT6]
                            ,[MAPPING_KEY] AS [COMMENT7]
                            ,'Y'           AS [ACTIVE_FLAG]
                            ,[ATTRIBUTE5]
                        FROM   ( SELECT M.[IFSEQNO]
                                        ,M.[ROLL01]
                                        ,M.[CODE_OLD_01]  AS [MAPPING_KEY]
                                        ,P.SCM_SITE_ID    AS [CODE_OLD_01]
                                        ,REPLACE(SCM_SITE_ID, M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                        ,M.[ETC6]
                                        ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                              --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                              WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                    JOIN [SCM_MST_SITE]     P WITH(NOLOCK)
                                        ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                AND   M.ROLL01 = 'BUKRS'
                                AND   M.ROLL02 = ''
                                /*AND   M.ETC6 = N'매핑확정'*/ ) P
                        WHERE  ATTRIBUTE5 IS NOT NULL ) P
            GROUP BY [OLD_VALUE1], [NEW_VALUE1]
            ;
        end

        else if(@p_sys_works = 'SCP_SITE_DESCRIPTION' )
        begin

            print '--MERGE/ELEMENT1'

            set @element1 = @p_sys_works

            INSERT INTO [NERP_CONV_MASTER] (
                    [CODETYPE]
                    ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                    ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                    ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                    ,[DESC1],[DESC2]--,[DESC3],[DESC4]
                    /*,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5]*/,[COMMENT6],[COMMENT7]
                    ,[ACTIVE_FLAG]
                    /*,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4]*/,[ATTRIBUTE5]
                    ,[INSERT_ID]
                    ,[INSERT_DATE]
                    ,[UPDATE_ID]
                    ,[UPDATE_DATE])
            SELECT 'SCP_SITE_DESCRIPTION'   AS CODETYPE
                  ,[OLD_VALUE1]    AS [OLD_VALUE1],''[OLD_VALUE2],''[OLD_VALUE3],''[OLD_VALUE4]
                  ,[NEW_VALUE1]    AS [NEW_VALUE1],''[NEW_VALUE2],''[NEW_VALUE3],''[NEW_VALUE4]
                  ,MAX([ELEMENT1]) AS [ELEMENT1]
                  ,MAX([ELEMENT2]) AS [ELEMENT2],''[ELEMENT3],''[ELEMENT4]
                  ,MAX([DESC1])    AS [DESC1]
                  ,MAX([DESC2])    AS [DESC2]
                  ,MAX([COMMENT6]) AS [COMMENT6]
                  ,MAX([COMMENT7]) AS [COMMENT7]
                  ,MAX([ACTIVE_FLAG]) AS [ACTIVE_FLAG]
                  ,MAX([ATTRIBUTE5]) AS [ATTRIBUTE5]
                  ,'SCP_CONV_MASTER' AS INSERT_ID
                  ,GETDATE()         AS INSERT_DATE
                  ,'SCP_CONV_MASTER' AS UPDATE_ID
                  ,GETDATE()         AS UPDATE_DATE
            FROM  (     SELECT [CODE_OLD_01] AS [OLD_VALUE1]
                              ,[CODE_NEW_01] AS [NEW_VALUE1]
                              ,'2'           AS [ELEMENT1]
                              ,[ROLL01]      AS [ELEMENT2]
                              ,CASE WHEN 1=2 THEN  '' END AS [DESC1]
                              ,CASE WHEN 1=2 THEN  '' END AS [DESC2]
                              ,[ETC6]        AS [COMMENT6]
                              ,[MAPPING_KEY] AS [COMMENT7]
                              ,'Y'           AS [ACTIVE_FLAG]
                              ,[ATTRIBUTE5]
                        FROM   ( SELECT M.[IFSEQNO]
                                       ,M.[ROLL01]
                                       ,M.[CODE_OLD_01]      AS [MAPPING_KEY]
                                       ,P.[SITE_DESCRIPTION] AS [CODE_OLD_01]
                                       ,REPLACE(P.[SITE_DESCRIPTION], M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                       ,M.[ETC6]
                                       ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                             --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                 FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                      JOIN [SCM_MST_SITE]     P WITH(NOLOCK)
                                          ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                          AND P.SITE_DESCRIPTION LIKE '%'+ SUBSTRING( P.SCM_SITE_ID, 1,4) + '%'
                                 WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                 AND   M.ROLL01 = 'WERKS_D'
                                 AND   M.ROLL02 = ''
                                 /*AND   M.ETC6 = N'매핑확정'*/ ) P
                        WHERE  ATTRIBUTE5 IS NOT NULL
                        UNION
                        SELECT [CODE_OLD_01] AS [OLD_VALUE1]
                              ,[CODE_NEW_01] AS [NEW_VALUE1]
                              ,'1'           AS [ELEMENT1]
                              ,[ROLL01]      AS [ELEMENT2]
                              ,NULL          AS [DESC1]
                              ,NULL          AS [DESC2]
                              ,[ETC6]        AS [COMMENT6]
                              ,[MAPPING_KEY] AS [COMMENT7]
                              ,'Y'           AS [ACTIVE_FLAG]
                              ,[ATTRIBUTE5]
                        FROM   ( SELECT M.[IFSEQNO]
                                       ,M.[ROLL01]
                                       ,M.[CODE_OLD_01]  AS [MAPPING_KEY]
                                       ,P.[SITE_DESCRIPTION] AS [CODE_OLD_01]
                                       ,REPLACE(P.[SITE_DESCRIPTION], M.[CODE_OLD_01], M.[CODE_NEW_01])  AS [CODE_NEW_01]
                                       ,M.[ETC6]
                                       ,CASE WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('HQ', 'WA') THEN '1ST'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('MI', 'ST', 'HD', 'HG', 'VT') THEN '2ND'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('NJ', 'NA', 'NB', 'CH') THEN '3RD'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('AZ', 'AE') THEN '4TH'
                                             --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('GM', 'GH', 'HM', 'EG','AU','IL','JP') THEN '5TH'
                                             WHEN SUBSTRING( M.CODE_NEW_01,1,2) IN  ('TW','TW') THEN '9TH' END   AS ATTRIBUTE5
                                 FROM ZNERP_TOBE_CODE_INFO_SN  M WITH(NOLOCK)
                                      JOIN [SCM_MST_SITE]     P WITH(NOLOCK)
                                          ON  M.CODE_OLD_01 = SUBSTRING( P.SCM_SITE_ID, 1,4)
                                          AND P.SITE_DESCRIPTION LIKE '%'+ SUBSTRING( P.SCM_SITE_ID, 1,4) + '%'
                                 WHERE M.IFSEQNO = @maxIfseqno --'202503131321533304'  -- 수정 필요
                                 AND   M.ROLL01 = 'BUKRS'
                                 AND   M.ROLL02 = ''
                                 /*AND   M.ETC6 = N'매핑확정'*/ ) P
                        WHERE  ATTRIBUTE5 IS NOT NULL ) P
            GROUP BY [OLD_VALUE1], [NEW_VALUE1]
            ;
            --2025.04.08 김준규 SCP용 추가 종료
        end

        else
        begin
            print @p_sys_gubun
            PRINT @codetype

            print '--INSERT/ELEMENT1'

            set @element1 = @p_sys_works
            PRINT @codetype + '/' + @element1

            INSERT INTO [NERP_CONV_MASTER] (
                    [CODETYPE]
                    ,[OLD_VALUE1],[OLD_VALUE2],[OLD_VALUE3],[OLD_VALUE4]
                    ,[NEW_VALUE1],[NEW_VALUE2],[NEW_VALUE3],[NEW_VALUE4]
                    ,[ELEMENT1],[ELEMENT2],[ELEMENT3],[ELEMENT4]
                    ,[DESC1],[DESC2],[DESC3],[DESC4]
                    ,[COMMENT1],[COMMENT2],[COMMENT3],[COMMENT4],[COMMENT5],[COMMENT6],[COMMENT7]
                    ,[ACTIVE_FLAG]
                    ,[ATTRIBUTE1],[ATTRIBUTE2],[ATTRIBUTE3],[ATTRIBUTE4],[ATTRIBUTE5]
                    ,[INSERT_ID]
                    ,[INSERT_DATE]
                    ,[UPDATE_ID]
                    ,[UPDATE_DATE])
            SELECT
                    @codetype
                    ,CODE_OLD_01, CODE_OLD_02, CODE_OLD_03, CODE_OLD_04
                    ,CODE_NEW_01, CODE_NEW_02, CODE_NEW_03, CODE_NEW_04
                    ,ROLL01 ,ROLL02 ,ROLL03 ,ROLL04
                    ,'-','-','-','-'
                    ,ETC1,ETC2,ETC3,ETC4,ETC5,ETC6
                    ,'Customer Number'
                    ,'Y' --AS [ACTIVE_FLAG]
                    ,'-' ,'-','-','-'
                        , CASE WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                 AND ( CODE_NEW_01 like 'HQ%'
                                   OR  CODE_NEW_01 like 'WA%' ) THEN '1ST'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('C100', 'G480') THEN '1ST'
                                WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('KR', 'PL') THEN '1ST'
                                --WHEN ROLL01 IN ('VTWEG', 'BLART', 'KUNNR', 'EKGRP', 'VKGRP', 'AUART', 'LIFNR', 'INCO1')  THEN '1ST' -- 전체 Conversion 대상
                                --WHEN ROLL01 IN ('KUNNR') THEN '1ST'
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                    --2025.04.08 김준규 ROLLIN 차수 서증 시작
                                    AND ( CODE_NEW_01 like 'MI%'
                                    OR  CODE_NEW_01 like 'ST%'
                                    OR  CODE_NEW_01 like 'HD%'
                                    OR  CODE_NEW_01 like 'HG%'
                                    OR  CODE_NEW_01 like 'VT%' )
                                    AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '2ND'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G380','G810','G820','G870','G880') THEN '2ND'
                                --미국기준 2차는 KALSM_D에 CODE_NEW_03이 없음
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AU', 'AZ', 'EG', 'IL', 'MI', 'NA', 'NB', 'NJ', 'TW', 'VT', 'CN') THEN '2ND'
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                    AND ( CODE_NEW_01 like 'NJ%'
                                    OR  CODE_NEW_01 like 'NA%'
                                    OR  CODE_NEW_01 like 'NB%'
                                    OR  CODE_NEW_01 like 'CH%'
                                    )
                                    AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '3RD'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G990', 'G450', 'G630', 'G180') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                    AND ( CODE_NEW_01 like 'AZ%'
                                    OR  CODE_NEW_01 like 'AE%'
                                                   )
                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '4TH'
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G940','G830') THEN '4TH'
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                 AND ( CODE_NEW_01 like 'GM%'
                                   OR  CODE_NEW_01 like 'GH%'
                                   OR  CODE_NEW_01 like 'HM%'
                                   OR  CODE_NEW_01 like 'EG%'
                                   OR  CODE_NEW_01 like 'AU%'
                                   OR  CODE_NEW_01 like 'IL%'
                                   OR  CODE_NEW_01 like 'JP%'
                                   )
                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '5TH'
                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G540','G690','G960','G670','G740','G890','G950') THEN '5TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                WHEN ROLL01 IN ('GSBER', 'BUKRS', 'WERKS_D'/*,'LIFNR'*/ )
                                 AND ( CODE_NEW_01 like 'TW%'
                                   OR  CODE_NEW_01 like 'TW%'
                                   )
                                 AND CODE_NEW_02 NOT IN ( N'삭제')/*( N'삭제','')*/ THEN '9TH'
                                --2025.12.11   김준규          G680:TW00는 5TH에서 제외 처리되어야 하나, 컨버전 TOBE코드로 제공받아서 9TH 강제로 제외처리 함
                                WHEN ROLL01 IN ('KOKRS') AND  CODE_OLD_01 IN ('G680','G680') THEN '9TH' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                --WHEN ROLL01 IN ('KALSM_D') AND CODE_NEW_03 IN ('AE', 'GM', 'HD', 'HM', 'ST', 'HG', 'JP', 'GH', 'DE') THEN '3RD' --G880, G950, G960 추가 오픈차수 확인필요 ! (2024.12.26)
                                ELSE @p_rollin --'2ND'
                                --2025.04.08 김준규 ROLLIN 차수 서증 종료
                            END

                    ,'TOBE_CONVERTER', GETDATE(), 'TOBE_CONVERTER',GETDATE()
            FROM ZNERP_TOBE_CODE_INFO_SN x with(nolock)
            where 1=1
            AND IFSEQNO = @maxIfseqno
            AND ROLL01 = @element1 AND ISNULL(ROLL02, '') = ''
            AND CODE_OLD_01 <> ''
            AND CODE_OLD_01 <> CODE_NEW_01
            AND ( ETC2 NOT like N'%삭제%' AND ETC1 NOT LIKE N'%Delete%' AND ETC4 NOT like N'%삭제%' AND CODE_NEW_01 NOT like N'%삭제%' AND CODE_NEW_02 NOT like N'%삭제%' AND CODE_OLD_01 NOT like N'%신규%' )
            /*AND (ISNULL(ETC6,'') IN ( N'매핑확정', N'1차 완료')
              OR ISNULL(ETC6,'') LIKE N'%1차확정%' ) */-- OR이므로 matching_option이 0이 아닐 때만 '매핑확정' 조건이 적용된다


        END


    END

        --2025.04.17 김준규 롤인차수 추가 시작
        --롤인 차수 이전 값으로 생성된 END_CUSTOMER_ID VENDOR_ID 데이터는 당 차수에서 삭제
        --개발이나 운영이나 동일하게 생성되어야 한다.
        IF @p_sys_works IN ('KUNNR','LIFNR') --'KUNNR'-->'END_CUSTOMER_ID', 'LIFNR'-->'VENDOR_ID'
        BEGIN
            --DECLARE @sql nvarchar(max) = '' --상단에 선언함
            SET @sql = N'
            begin
            DELETE ncm
            FROM   NERP_CONV_MASTER ncm
            WHERE  ncm.CODETYPE IN (''VENDOR_ID'',''END_CUSTOMER_ID'')
            AND    ncm.ATTRIBUTE5 = '''+@p_rollin+'''
            AND    EXISTS ( SELECT 1
                            /* FROM   [DBO].NERP_CONV_MASTER ncmd WITH(NOLOCK) */
                            FROM   BACKUP_NERP_CONV_MASTER_PROD_251204 AS ncmd WITH(NOLOCK)
                            WHERE  ncmd.CODETYPE IN (''VENDOR_ID'',''END_CUSTOMER_ID'')
                            AND    ncmd.ATTRIBUTE5 < '''+@p_rollin+'''
                            AND    ncmd.CODETYPE = ncm.CODETYPE
                            AND    ncmd.OLD_VALUE1 = ncm.OLD_VALUE1
                            );
            end;';


            EXEC sp_executesql @sql;

            --개발이나 운영이나 동일하게 생성되어야 한다.
            --2025-06-02 김준규 END_CUSTOMER_ID의 1차 Open 기준 OLD_VALUE1 값의 길이가 4개 인 것 중
            --           COMPANY_ID에 있는 Open차수를 아는 것만 해당 Open 차 수 별로 추가하는 것으로 하겠습니다
            INSERT INTO NERP_CONV_MASTER (
                CODETYPE
                ,OLD_VALUE1
                ,OLD_VALUE2
                ,OLD_VALUE3
                ,OLD_VALUE4
                ,NEW_VALUE1
                ,NEW_VALUE2
                ,NEW_VALUE3
                ,NEW_VALUE4
                ,ELEMENT1
                ,ELEMENT2
                ,ELEMENT3
                ,ELEMENT4
                ,DESC1
                ,DESC2
                ,DESC3
                ,DESC4
                ,COMMENT1
                ,COMMENT2
                ,COMMENT3
                ,COMMENT4
                ,COMMENT5
                ,COMMENT6
                ,COMMENT7
                ,ACTIVE_FLAG
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5
                ,INSERT_ID
                ,INSERT_DATE
                ,UPDATE_ID
                ,UPDATE_DATE
            )
            SELECT CODETYPE
                  ,OLD_VALUE1
                  ,OLD_VALUE2
                  ,OLD_VALUE3
                  ,OLD_VALUE4
                  ,NEW_VALUE1
                  ,NEW_VALUE2
                  ,NEW_VALUE3
                  ,NEW_VALUE4
                  ,ELEMENT1
                  ,ELEMENT2
                  ,ELEMENT3
                  ,ELEMENT4
                  ,DESC1
                  ,DESC2
                  ,DESC3
                  ,DESC4
                  ,COMMENT1
                  ,COMMENT2
                  ,COMMENT3
                  ,COMMENT4
                  ,COMMENT5
                  ,COMMENT6
                  ,COMMENT7
                  ,ACTIVE_FLAG
                  ,ATTRIBUTE1
                  ,ATTRIBUTE2
                  ,ATTRIBUTE3
                  ,ATTRIBUTE4
                  ,ATTRIBUTE5
                  ,INSERT_ID
                  ,INSERT_DATE
                  ,UPDATE_ID
                  ,UPDATE_DATE
            FROM (
                SELECT NCM.CODETYPE
                      ,dncm.OLD_VALUE1
                      ,dncm.OLD_VALUE2
                      ,dncm.OLD_VALUE3
                      ,dncm.OLD_VALUE4
                      ,dncm.NEW_VALUE1
                      ,dncm.NEW_VALUE2
                      ,dncm.NEW_VALUE3
                      ,dncm.NEW_VALUE4
                      ,dncm.ELEMENT1
                      ,dncm.ELEMENT2
                      ,dncm.ELEMENT3
                      ,dncm.ELEMENT4
                      ,dncm.DESC1
                      ,dncm.DESC2
                      ,dncm.DESC3
                      ,dncm.DESC4
                      ,dncm.COMMENT1
                      ,dncm.COMMENT2
                      ,dncm.COMMENT3
                      ,dncm.COMMENT4
                      ,dncm.COMMENT5
                      ,dncm.COMMENT6
                      ,dncm.COMMENT7
                      ,dncm.ACTIVE_FLAG
                      ,dncm.ATTRIBUTE1
                      ,dncm.ATTRIBUTE2
                      ,dncm.ATTRIBUTE3
                      ,dncm.ATTRIBUTE4
                      ,dncm.ATTRIBUTE5
                      ,dncm.INSERT_ID
                      ,dncm.INSERT_DATE
                      ,NCM.CODETYPE AS UPDATE_ID
                      ,GETDATE() AS UPDATE_DATE
                --아래 BACKUP 테이블은 2차 오펀 후 바뀌어야한다. 현재는 1차 것이 보관되어 있음.
                FROM   BACKUP_NERP_CONV_MASTER_PROD_251204 ncm WITH(NOLOCK)
                JOIN   NERP_CONV_MASTER dncm WITH(NOLOCK)
                ON     NCM.CODETYPE IN ('VENDOR_ID','END_CUSTOMER_ID')
                AND    NCM.ATTRIBUTE5 = '1ST' --> 고정값 (변경하면 안됨)
                AND    LEN(NCM.OLD_VALUE1 ) = 4
                AND    DNCM.CODETYPE = 'COMPANY_ID'
                AND    DNCM.OLD_VALUE1 = NCM.OLD_VALUE1
                AND    DNCM.OLD_VALUE2 = NCM.OLD_VALUE2
                WHERE  1=1
            ) X
            WHERE 1=1
            AND NOT EXISTS (SELECT 1
                            FROM   NERP_CONV_MASTER dncm WITH(NOLOCK)
                            WHERE  dncm.CODETYPE   = X.CODETYPE
                            AND    dncm.OLD_VALUE1 = X.OLD_VALUE1
                            AND    dncm.OLD_VALUE2 = X.OLD_VALUE2
                            AND    dncm.ATTRIBUTE5 >= X.ATTRIBUTE5
                           )
            ;


        END;
        --2025.04.17 김준규 롤인차수 추가 종료

        --2025.04.08 김준규 BEGIN TRY CATCH 추가 시작
        SET @BATCH_END_TIME = SYSDATETIME();
        SET @BATCH_RUN_TIME = DATEDIFF(second, @BATCH_START_TIME, @BATCH_END_TIME)
        SET @v_log_type = 'END';
        PRINT CONCAT( '[END, RUN_TIME] ', @BATCH_END_TIME, ', ', @BATCH_RUN_TIME)
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @BATCH_RUN_TIME, 'RUN_TIME',  @v_description, @BATCH_END_TIME;



END TRY
BEGIN CATCH
        SET @CNT = @@ROWCOUNT;
        SET @WORK_SECOND = ERROR_NUMBER();
        SET @v_description = ERROR_MESSAGE();
        SET @v_log_type = 'ERROR';
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @CNT, @WORK_SECOND, @v_description, @d_event_date;
        PRINT 'ERROR'
        PRINT ERROR_MESSAGE();
        --2025.04.08 김준규 BEGIN TRY CATCH 종료 시작

END CATCH

END
