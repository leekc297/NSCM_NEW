


 /*
 * Program ID  : [PR_SCP_ANL_LONG_TERM_STOCK_REPORT]
 * Description  :  장기진부화재고 조회용 데이터 수집
 * Execute       :
 * Program History
 *===================================================================================================
 *   Date       In Charge   Description
 *===================================================================================================
 * 2021/11/02   HJ.LEE      Initial Release  [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 * 2021/12/22   HJ.LEE      장기진부화 재고에 있는 월과 환율월을 동기화함.
 * 2023/01/13   vdabi3      [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - DIV 매핑
 * 2023/03/09   vdabi3      PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - ERP_POSTING_STOCK_PRCTR_LONG 적용 / PRCTR 로 JOIN
 * 2023/04/20   vdabi3      PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - 장기진부화재고  QTY,AMT,UNIT_PRICE (소수점) 정책 기준 적용
 * 2023/05/08   vdabi3      PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - Amount 적용 개선
 * 2023/05/09   vdabi3      PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - 현지퐈 표시
 * 2023/09/13   vdabi3      PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제  - 환율 - 기말재고와 동기화
 * 2025/02/28   kimcd       PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 * 2025/04/03   oij         -            인터페이스 데이터 중복에 의한 마지막 버전을 활용하도록 변경
 * 2025.06.19   김준규      [IT20250117A] NERP 오펀차수별 Mapping Code적용 
 * 2025.07.03   김준규      [IT20250117A] 실행시점 1개월전 1일포함 큰것 대상으로  현시점 롤인 상태로 컨버전 수행
 * 2025.11.07   park.choyi  [E20250310-000014] 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기')
 * 2025.11.25   park.choyi  [E20250423-000916] 단가 기준 변경. LNETP(Unit cost of ledger) -> CNETP(Unit cost of Total by ledger) 
 ----------------------------------------------------------------------------------------------------
EXEC [dbo].[PR_SCP_ANL_LONG_TERM_STOCK_REPORT]

SCP_ANL_LONG_TERM_STOCK WITH(NOLOCK)
SCP_MST_EXCHANGE_RATE WITH(NOLOCK)
 */

CREATE PROCEDURE [dbo].[PR_SCP_ANL_LONG_TERM_STOCK_REPORT]
AS
BEGIN

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
    SET NOCOUNT ON;

    DECLARE @DEBUG_MODE AS NVARCHAR(8) = 'F';

    DECLARE @RETURN  AS NVARCHAR(10) = '0';
    DECLARE @V_COUNT  INTEGER = 0; -- 기존데이터가 있는지 확인
    DECLARE @V_COUNT_CURR  INTEGER = 0; -- 기존환율데이터가 있는지 확인
    DECLARE @MAX_SPMON INTEGER = 0;
    --DECLARE @IFSEQNO_CURR INTEGER = 0; -- 환율I/F SEQ 사용안함
    DECLARE @IFMAXDT_CURR NVARCHAR(8) = ''; -- 환율I/F MAX DATE

    -- LOG 용 변수 설정
    DECLARE @v_program_name NVARCHAR(150) = 'PR_SCP_ANL_LONG_TERM_STOCK_REPORT'; --Proc별 이름 설정
    DECLARE @v_log_type     NVARCHAR(30); -- START/END/ERROR/...
    DECLARE @n_log_count    INTEGER = 0;
    DECLARE @v_log_message  NVARCHAR(1000);
    DECLARE @v_description  NVARCHAR(500);
    DECLARE @d_event_date   DATETIME;
    DECLARE @v_batch_user   NVARCHAR(150) = N'scp_batch';

    -- 임시 실행시간 확인용
    DECLARE @v_start_time   DATETIME   = SYSDATETIME();
    DECLARE @v_exec_time    NVARCHAR(10) = ''--'[00:00]';

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
    ------------------------------------------------------------------------
    -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End
    ------------------------------------------------------------------------

    -- 시작 LOG  (START)
    SET @v_log_type = 'START';
    SET @v_log_message = '########## Start of procedure ##########'; --[E20250423-000916] Log 양식에 맞춤
    SET @v_description = '' ;
    SET @d_event_date = SYSDATETIME();
    EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;
    SET @v_log_message = NULL      /*-- < - 변수 재사용을 위하여 초기화해야함 --*/

    -- 시작 LOG

    BEGIN
        PRINT '----------------------------------';
        PRINT 'START';
        PRINT '----------------------------------';
    END;

    BEGIN TRY
        BEGIN
        ---------------------------------------------------------------------------------------------------------
        --  기본 데이터 생성
        ---------------------------------------------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#XIF') IS NOT NULL
            DROP TABLE #XIF;

        IF OBJECT_ID('tempdb..#XIF2') IS NOT NULL
            DROP TABLE #XIF2;

        IF OBJECT_ID('tempdb..#XIF3') IS NOT NULL
            DROP TABLE #XIF3;

        IF OBJECT_ID('tempdb..#SEQ_NO') IS NOT NULL
            DROP TABLE #SEQ_NO;

        IF OBJECT_ID('tempdb..#CURR') IS NOT NULL
            DROP TABLE #CURR;

        IF OBJECT_ID('tempdb..#MST_ITEM') IS NOT NULL
            DROP TABLE #MST_ITEM;

        IF OBJECT_ID('tempdb..#X_ITEM_CLASS') IS NOT NULL
            DROP TABLE #X_ITEM_CLASS;

        IF OBJECT_ID('tempdb..#tmp_XIF_ERP_EXCRATE_R_SN') IS NOT NULL
            DROP TABLE #tmp_XIF_ERP_EXCRATE_R_SN;

        -- [E20250310-000014] LONG_TERM_TYPE 임시테이블 삭제
        IF OBJECT_ID('tempdb..#TMP_LONG_TERM_TYPE') IS NOT NULL
            DROP TABLE #TMP_LONG_TERM_TYPE;

        DECLARE @NOW_DATE  AS NVARCHAR(20);
        DECLARE @NOW_TIME  AS NVARCHAR(20);
        select @NOW_DATE = convert(char(8), getdate(), 112)
        select @NOW_TIME = CONCAT(FORMAT(GETDATE(), 'HH'),FORMAT(GETDATE(), 'mm'))


        -- [E20250310-000014] LONG_TERM_TYPE 임시테이블 데이터 생성
        SELECT LMD.SEGMENT1 AS LONG_TERM_TYPE_CODE
             , LMD.SEGMENT2 AS LONG_TERM_TYPE
             , LMD.SEGMENT3 AS GRM_MM_FROM
             , LMD.SEGMENT4 AS GRM_MM_TO
        INTO   #TMP_LONG_TERM_TYPE
        FROM   SCM_ADM_LOOKUP_MASTER_DETAIL LMD WITH(NOLOCK)
        JOIN   SCM_ADM_LOOKUP_MASTER ALM WITH(NOLOCK)
        ON     ALM.LOOKUP_TYPE = LMD.LOOKUP_TYPE
        AND    ALM.LOOKUP_TYPE = 'SCM_LGTM_TYPE'
        WHERE  ALM.VALID_YN = 'Y'
        AND    LMD.VALID_YN = 'Y';
    
	
    -------------------------------------------------------------------------
    -- 1. 환율정보 변경전
    -------------------------------------------------------------------------
    -- 적용 사유 있을 수 있으므로 백업 및 작동은 유지
    -------------------------------------------------------------------------
        UPDATE XIF_ERP_EXCRATE_R_SN
           SET TRANSFER_FLAG = 'P'
               ,UPDATE_DATE  = @NOW_DATE
               ,UPDATE_TIME  = @NOW_TIME
               ,UPDATE_USER_ID  = @v_batch_user
         WHERE TRANSFER_FLAG = 'N'

        -- 환율정보 가져오기  : MAX (IFSEQNO)가 부정확 해서 MAX(EX_DT) 로 가져옴
        SELECT @IFMAXDT_CURR = MAX(EX_DT)
          FROM XIF_ERP_EXCRATE_R_SN WITH(NOLOCK)
         WHERE TRANSFER_FLAG = 'P'

        --20250403
        SELECT EX_FROM_CURR_CD, EX_TO_CURR_CD, EX_TO_BAMT
          INTO #CURR
          FROM XIF_ERP_EXCRATE_R_SN WITH(NOLOCK)
         WHERE EX_DT = @IFMAXDT_CURR
           AND TRANSFER_FLAG = 'P'
           AND IFSEQNO = (SELECT MAX(IFSEQNO)
                            FROM XIF_ERP_EXCRATE_R_SN
                           WHERE 1=1
                            AND EX_DT = @IFMAXDT_CURR
                            AND TRANSFER_FLAG = 'P')


         SELECT @V_COUNT_CURR = COUNT(*)
            FROM #CURR

         IF @V_COUNT_CURR > 0            --해당 월의 기존 데이터는 삭제(환율)
         BEGIN
             BEGIN TRAN
             WHILE (1=1)
             BEGIN
                    DELETE TOP(40000) FROM SCP_MST_EXCHANGE_RATE
                     WHERE YYYYMM = SUBSTRING(@IFMAXDT_CURR,1,6)

                    IF @@ROWCOUNT = 0 BREAK;
             END
             COMMIT
         END

         IF @V_COUNT_CURR > 0
         BEGIN
             BEGIN TRAN
             BEGIN
             INSERT INTO SCP_MST_EXCHANGE_RATE(YYYYMM, FROM_CURR_CD, TO_CURR_CD, TO_BAMT
                                             , CREATED_BY, CREATION_DATE
                                              )
                     SELECT SUBSTRING(@IFMAXDT_CURR,1,6) , EX_FROM_CURR_CD, EX_TO_CURR_CD, EX_TO_BAMT
                          , @v_batch_user, GETDATE()
                        FROM #CURR
             END

             UPDATE XIF_ERP_EXCRATE_R_SN
                   SET TRANSFER_FLAG = 'Y'
              WHERE TRANSFER_FLAG = 'P'

             COMMIT;
         END


        SET     @v_log_type = 'ING'; --[E20250423-000916] Log 추가
        SELECT  @v_description = @IFMAXDT_CURR;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, N'변경전 환율 적용 기준일', @v_description, @d_event_date;

    -------------------------------------------------------------------------
    -- 1. 기말재고 환율정보 적용
    -------------------------------------------------------------------------
    -- 2022.05.17
    -- 1) 변경전 = 배치일 이전 Last Day (5월3일 실행 시 5월  2일 환율적용)  FORMAT(GETDATE(), 'yyyyMMdd')
    -- 2) 변경후 = 이전월 마감 환율     (5월3일 실행 시 4월 30일 환율적용)
    -- 3) 위안화 RMB -> CNY (하드코딩으로 변경 필요)
    -------------------------------------------------------------------------
        ;WITH sub AS
        (
         --SELECT CASE
            --  WHEN EX_FROM_CURR_CD = 'CNY' THEN 'RMB'
            --  ELSE EX_FROM_CURR_CD
            --  END AS EX_FROM_CURR_CD
         SELECT EX_FROM_CURR_CD AS EX_FROM_CURR_CD
               ,EX_TO_CURR_CD
               ,EX_TO_BAMT
               ,EX_DT
               ,TRANSFER_FLAG
               ,ROW_NUMBER() OVER (PARTITION BY EX_FROM_CURR_CD, EX_TO_CURR_CD ORDER BY EX_DT DESC) RN
         FROM dbo.XIF_ERP_EXCRATE_R_SN WITH(NOLOCK)
         WHERE 1 = 1
         AND TRANSFER_FLAG = 'Y'
         AND EX_TO_CURR_CD = 'KRW'
         AND EX_DT <=  CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0, GETDATE()) ,0), 112)

         union

         SELECT 'RMB' AS EX_FROM_CURR_CD
               ,EX_TO_CURR_CD
               ,EX_TO_BAMT
               ,EX_DT
               ,TRANSFER_FLAG
               ,ROW_NUMBER() OVER (PARTITION BY EX_FROM_CURR_CD, EX_TO_CURR_CD ORDER BY EX_DT DESC) RN
         FROM dbo.XIF_ERP_EXCRATE_R_SN WITH(NOLOCK)
         WHERE 1 = 1
         AND TRANSFER_FLAG = 'Y'
         AND EX_TO_CURR_CD = 'KRW'
         AND EX_FROM_CURR_CD = 'CNY'
         AND EX_DT <=  CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0, GETDATE()) ,0), 112)
        )
        SELECT EX_FROM_CURR_CD
              , EX_TO_CURR_CD
              , EX_DT
              , EX_TO_BAMT
        INTO   #tmp_XIF_ERP_EXCRATE_R_SN
        FROM   sub
        WHERE  RN = 1;

        SELECT  @v_description = EX_DT FROM #tmp_XIF_ERP_EXCRATE_R_SN;
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, N'환율 적용 기준일', @v_description, @d_event_date;

    -----------------------------------------------------------------------------------------------------------
    -- 0. 2025.07.03 김준규 [IT20250117A] 실행시점 1개월전 1일포함 큰것 대상으로  현시점 롤인 상태로 컨버전 수행 시작
    -----------------------------------------------------------------------------------------------------------
	    DECLARE @PRE_YYYYMM NVARCHAR(6) = FORMAT(DATEADD(MONTH, -1, GETDATE()),'yyyyMM');
        DECLARE @CNT_DUP_PLANTBY_SPMON INT=0;
    
        --UPDATE 수행.
        WITH W_RAW AS (
            SELECT   SPMON
                    ,WERKS,PRCTR,WAERS,MATKL,BKLAS
                    ,N1.new_value1 AS TOBE_PLANT
                    ,N2.NEW_VALUE2 AS TOBE_PRCTR
                    ,N3.NEW_VALUE1 AS TOBE_WAERS
                    , CASE
                      WHEN A.BKLAS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE01'   THEN '3001'
                      WHEN A.BKLAS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE02'   THEN '3002'
                      WHEN A.BKLAS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA01'   THEN '3003'
                      WHEN A.BKLAS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA02'   THEN '3004'
                      WHEN A.BKLAS = '3000' AND isnull(E.NEW_VALUE2,A.MATKL) like 'RP%' THEN '3005'
                      WHEN A.BKLAS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RE02'   THEN '3002'
                      WHEN A.BKLAS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA01'   THEN '3003'
                      WHEN A.BKLAS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) = 'RA02'   THEN '3004'
                      WHEN A.BKLAS = '3001' AND isnull(E.NEW_VALUE2,A.MATKL) like 'RP%' THEN '3005'
                      WHEN A.BKLAS = '3001' THEN '3000'
                      ELSE NULL
                       END AS TOBE_VALUATION_CLASS
                --into #TMP_SCP_ANL_LONG_TERM_STOCK
                --from SCP_ANL_LONG_TERM_STOCK A with (nolock)
                FROM XIF_ERP_LONG_TERM_STOCK_R_SN AS A WITH(NOLOCK)
           LEFT JOIN (select old_value1, new_value1 from NERP_CONV_MASTER_CFM_V where codetype = 'PLANT_ID' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE) N1 ON A.WERKS = N1.old_value1
           LEFT JOIN (SELECT OLD_VALUE1, NEW_VALUE1 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'WAERS' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE) N3 ON A.WAERS = N3.OLD_VALUE1
           LEFT JOIN (SELECT NEW_VALUE1, NEW_VALUE2 FROM NERP_CONV_MASTER_CFM_V WHERE CODETYPE = 'MATKL' AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE) E  ON A.MATNR = E.NEW_VALUE1
           LEFT JOIN (SELECT OLD_VALUE1, OLD_VALUE2, NEW_VALUE1,  new_value2
                           , REPLICATE('0',10 - LEN(OLD_VALUE2)) + OLD_VALUE2 AS ASIS_CODE
                        FROM NERP_CONV_MASTER_CFM_V
                       WHERE CODETYPE = 'PROFIT_CENTER_ID'
                         AND ATTRIBUTE5 = @V_NERP_ROLLIN_STAGE
                       ) N2 ON A.PRCTR  = N2.ASIS_CODE
               WHERE 1=1
               AND   A.SPMON >= @PRE_YYYYMM
               AND   A.TRANSFER_FLAG = 'N'
               AND  ( N1.new_value1 IS NOT NULL OR N2.new_value2 IS NOT NULL OR N3.new_value1 IS NOT NULL OR E.NEW_VALUE1 IS NOT NULL )
        )
        --SELECT * FROM W_RAW;
        UPDATE SRS
           SET SRS.WERKS          = ISNULL(WR.TOBE_PLANT, SRS.WERKS)
              ,SRS.PRCTR          = ISNULL(WR.TOBE_PRCTR, SRS.PRCTR)
              ,SRS.WAERS          = ISNULL(WR.TOBE_WAERS, SRS.WAERS)
              ,SRS.BKLAS          = ISNULL(WR.TOBE_VALUATION_CLASS, SRS.BKLAS)
              ,SRS.ATTRIBUTE10    = 'NERP_BATCH_UPDATE'
              ,SRS.UPDATE_USER_ID = @v_batch_user
              ,SRS.UPDATE_DATE    = @NOW_DATE
              ,SRS.UPDATE_TIME    = @NOW_TIME
        --SELECT  'A' XX
        --       ,NEW_WERKS = ISNULL(WR.TOBE_PLANT, SRS.WERKS)
        --       ,NEW_PRCTR = ISNULL(WR.TOBE_PRCTR, SRS.PRCTR)
        --       ,NEW_WAERS = ISNULL(WR.TOBE_WAERS, SRS.WAERS)
        --       ,NEW_BKLAS = ISNULL(WR.TOBE_VALUATION_CLASS, SRS.BKLAS)
        --       ,WR_WERKS  = WR.WERKS
        --       ,WR_PRCTR  = WR.PRCTR
        --       ,WR_WAERS  = WR.WAERS
        --       ,WR_BKLAS  = WR.BKLAS
        --       ,SRS.*
        FROM  .XIF_ERP_LONG_TERM_STOCK_R_SN AS SRS
        LEFT  JOIN W_RAW AS WR ON 
              SRS.SPMON = WR.SPMON
        AND   SRS.WERKS = WR.WERKS
        AND   SRS.PRCTR = WR.PRCTR
        AND   SRS.WAERS = WR.WAERS
        AND   SRS.MATKL = WR.MATKL
        AND   SRS.BKLAS = WR.BKLAS
        WHERE SRS.SPMON >= @PRE_YYYYMM
        AND   SRS.TRANSFER_FLAG = 'N';
    
        SELECT TOP 1 @CNT_DUP_PLANTBY_SPMON = COUNT(*)
        FROM (
            SELECT DISTINCT SPMON,WERKS,IFFROM=CASE WHEN LEN(IFSEQNO) <15 THEN 'GERP' ELSE 'NERP' END
            FROM   XIF_ERP_LONG_TERM_STOCK_R_SN
            WHERE  SPMON >= @PRE_YYYYMM
            AND    TRANSFER_FLAG = 'N'
        ) X
        GROUP BY SPMON,WERKS
        HAVING COUNT(*) > 1;

        --PRINT @CNT_DUP_PLANTBY_SPMON;
        --GERP,NERP 중복으로 입력되었을 경우 중단하고 에러 발생
        IF @CNT_DUP_PLANTBY_SPMON > 0 BEGIN

            SET @v_log_type = N'ERROR';
            SET @v_log_message = N'GERP 와 NERP 동일 PLANT 발생, 발생월:'+@PRE_YYYYMM;
            EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;

            RETURN; --종료 끝내기.
        END;

    -----------------------------------------------------------------------------------------------------------
    -- 0. 2025.07.03 김준규 [IT20250117A] 실행시점 1개월전 1일포함 큰것 대상으로  현시점 롤인 상태로 컨버전 수행 종료
    -----------------------------------------------------------------------------------------------------------

    -------------------------------------------------------------------------
    -- 1. 월령재고 배치 시작
    -------------------------------------------------------------------------
        UPDATE XIF_ERP_LONG_TERM_STOCK_R_SN
           SET TRANSFER_FLAG = 'P'
               ,UPDATE_DATE  = @NOW_DATE
               ,UPDATE_TIME  = @NOW_TIME
               ,UPDATE_USER_ID  = @v_batch_user
         WHERE TRANSFER_FLAG = 'N'
         -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 Start
         -- OLD 코드는 반영이 되지 않게 처리
         AND    NOT EXISTS ( SELECT 1
                             FROM   NERP_CONV_MASTER ncm WITH(NOLOCK)
                             WHERE  NCM.CODETYPE = 'PLANT_ID'
                             AND    NCM.OLD_VALUE1 = XIF_ERP_LONG_TERM_STOCK_R_SN.WERKS
                             AND    NCM.ATTRIBUTE5 <= @V_NERP_ROLLIN_STAGE
                           );
         -- 2025.06.19 김준규 [IT20250117A] NERP 오펀차수별 Mapping Code적용 End

        SELECT @MAX_SPMON= MAX(SPMON)
          FROM XIF_ERP_LONG_TERM_STOCK_R_SN WITH(NOLOCK)
         WHERE TRANSFER_FLAG = 'P'

        SELECT WERKS, MAX(IFSEQNO) SEQ_NO
          INTO #SEQ_NO
          FROM XIF_ERP_LONG_TERM_STOCK_R_SN
         WHERE TRANSFER_FLAG = 'P'
           AND SPMON = @MAX_SPMON
      GROUP BY WERKS

       SELECT @V_COUNT = COUNT(*)
         FROM #SEQ_NO

         
        --[E20250423-000916] Log 추가
        SET @n_log_count    = @V_COUNT; 
	    SET @v_log_message	= N'@MAX_SPMON';
        SET @v_description  = @MAX_SPMON;
	    SET @d_event_date	= SYSDATETIME();
        EXEC PR_SCM_SYS_LOG_BATCH @v_program_name, @v_log_type, @n_log_count, @v_log_message, @v_description, @d_event_date;



         IF @V_COUNT > 0
         --해당 월의 기존 데이터는 삭제
         BEGIN
             BEGIN TRAN
             WHILE (1=1)
             BEGIN
                    DELETE FROM SCP_ANL_LONG_TERM_STOCK
                     WHERE YYYYMM = @MAX_SPMON

                    IF @@ROWCOUNT = 0 BREAK;
             END
             COMMIT
         END

         IF @V_COUNT > 0
         BEGIN
                ----------------------------------------------------------------------------------------------------------------------------------------------------------------
                ;WITH sub9 AS
                (
                    SELECT SEGMENT1 center
                        ,SEGMENT3 DIVISION_ID
                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
                    WHERE LOOKUP_TYPE = 'ERP_POSTING_STOCK_PRCTR_LONG'
                    AND VALID_YN = 'Y'
                ),
                sub10 AS
                (
                    SELECT SEGMENT3 PLANT_ID
                        , ATTRIBUTE5 DIVISION_ID
                    FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)
                    WHERE LOOKUP_TYPE = 'ERP_POSTING_STOCK_SETUP'
                    AND ATTRIBUTE5 <> '-'
                    AND VALID_YN = 'Y'
                )
                       SELECT IFSEQNO, DIVISION_ID, YYYYMM, BUKRS, PLANT_ID, ITEM_ID
                            , ISNULL(CHARG,'-') AS CHARG, SPEMK,  PRCTR, PRODH, MATKL, BWTAR, VALUATION_CLASS
                            , WAERS, CURRENCY
                            , UNIT_PRICE_ORG, UNIT_PRICE
                            , LPEIN
                            , SNETP
                            , SPEIN
                            , SMENG
                            , CREATE_DATE,   CREATE_TIME,   CREATE_USER_ID
                            , UPDATE_DATE,   UPDATE_TIME,   UPDATE_USER_ID
                            , TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID, TRANSFER_FLAG
                            , ATTRIBUTE1,  ATTRIBUTE2,  ATTRIBUTE3,  ATTRIBUTE4,  ATTRIBUTE5
                            , ATTRIBUTE6,  ATTRIBUTE7,  ATTRIBUTE8,  ATTRIBUTE9,  ATTRIBUTE10
                            , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                            , GRM01 ,GRM02  ,GRM03  ,GRM04  ,GRM05  ,GRM06  ,GRM07  ,GRM08  ,GRM09  ,GRM10
                            , GRM11 ,GRM12  ,GRM13  ,GRM14  ,GRM15  ,GRM16  ,GRM17  ,GRM18  ,GRM19  ,GRM20
                            , GRM21 ,GRM22  ,GRM23  ,GRM24  ,GRM25  ,GRM26  ,GRM27  ,GRM28  ,GRM29  ,GRM30
                            , GRM31 ,GRM32  ,GRM33  ,GRM34  ,GRM35  ,GRM36  ,GRM37  ,GRM38  ,GRM39  ,GRM40
                            , GRM41 ,GRM42  ,GRM43  ,GRM44  ,GRM45  ,GRM46  ,GRM47  ,GRM48  ,GRM49  ,GRM50
                            , GRM51 ,GRM52  ,GRM53  ,GRM54  ,GRM55  ,GRM56  ,GRM57  ,GRM58  ,GRM59  ,GRM60
                            , GRM61
                        INTO #XIF
                        FROM
                            (
                                  SELECT  IFSEQNO
                                        , ISNULL(ISNULL(D.DIVISION_ID, E.DIVISION_ID),SPART)  AS DIVISION_ID
                                        , SPMON AS YYYYMM, BUKRS, A.WERKS AS PLANT_ID, MATNR AS ITEM_ID
                                        , CHARG, SPEMK, MEINS, PRCTR, PRODH, MATKL, BWTAR, BKLAS AS VALUATION_CLASS
                                        , WAERS
                                        , WAERS AS CURRENCY
                                        -- [E20250423-000916] 단가 기준 변경. LNETP(Unit cost of ledger) -> CNETP(Unit cost of Total by ledger) Start
                                        -- GERP 에서는 CNETP 컬럼이 추가되지 않아서 CNETP 이 NULL로 생성 됨. CNETP이 NULL 경우에 기존 LNETP 사용
                                        , IIF(CNETP IS NULL, LNETP, CNETP) AS UNIT_PRICE_ORG 
                                        , CASE
                                          WHEN CAST(LPEIN AS NUMERIC) <> 0
                                          THEN ROUND(IIF(CNETP IS NULL, CAST(LNETP AS NUMERIC), CAST(CNETP AS NUMERIC))  / CAST(LPEIN AS NUMERIC),2)
                                           END AS UNIT_PRICE
                                        --, LNETP AS UNIT_PRICE_ORG
                                        --, CASE
                                        --  WHEN CAST(LPEIN AS NUMERIC) <> 0
                                        --  THEN ROUND(CAST(LNETP AS NUMERIC) / CAST(LPEIN AS NUMERIC),2)
                                        --   END AS UNIT_PRICE
                                        -- [E20250423-000916] 단가 기준 변경. LNETP(Unit cost of ledger) -> CNETP(Unit cost of Total by ledger) End
                                        , LPEIN
                                        , SNETP, SPEIN, SMENG
                                        , CREATE_DATE,   CREATE_TIME,   CREATE_USER_ID
                                        , UPDATE_DATE,   UPDATE_TIME,   UPDATE_USER_ID
                                        , TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID, TRANSFER_FLAG
                                        , ATTRIBUTE1,  ATTRIBUTE2,  ATTRIBUTE3,  ATTRIBUTE4,  ATTRIBUTE5
                                        , ATTRIBUTE6,  ATTRIBUTE7,  ATTRIBUTE8,  ATTRIBUTE9,  ATTRIBUTE10
                                        , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14,  ATTRIBUTE15
                                        , GRM01 ,GRM02  ,GRM03  ,GRM04  ,GRM05  ,GRM06  ,GRM07  ,GRM08  ,GRM09  ,GRM10
                                        , GRM11 ,GRM12  ,GRM13  ,GRM14  ,GRM15  ,GRM16  ,GRM17  ,GRM18  ,GRM19  ,GRM20
                                        , GRM21 ,GRM22  ,GRM23  ,GRM24  ,GRM25  ,GRM26  ,GRM27  ,GRM28  ,GRM29  ,GRM30
                                        , GRM31 ,GRM32  ,GRM33  ,GRM34  ,GRM35  ,GRM36  ,GRM37  ,GRM38  ,GRM39  ,GRM40
                                        , GRM41 ,GRM42  ,GRM43  ,GRM44  ,GRM45  ,GRM46  ,GRM47  ,GRM48  ,GRM49  ,GRM50
                                        , GRM51 ,GRM52  ,GRM53  ,GRM54  ,GRM55  ,GRM56  ,GRM57  ,GRM58  ,GRM59  ,GRM60
                                        , GRM61
                                     FROM XIF_ERP_LONG_TERM_STOCK_R_SN A
                               INNER JOIN #SEQ_NO B
                                       ON A.WERKS = B.WERKS
                                      AND A.IFSEQNO = B.SEQ_NO
                                LEFT JOIN sub10 D ON A.WERKS = D.PLANT_ID
                                LEFT JOIN sub9 E ON A.PRCTR = E.center
                                    WHERE SPMON = @MAX_SPMON
                                      --AND SPART IS NOT NULL
                                      --AND SPART <> ''
                                      --AND SPART IN  (SELECT DISTINCT DIVISION_ID FROM SCM_PLANT_M_SN) ---(40,81,82)
                                      AND BKLAS NOT IN  -- LOOKUP TYPE : ERP_LONGTERM_EXCEPT_VALCALSS.  제외 대상 CODE : SEGMENT1
                                                                 ( SELECT SEGMENT1
                                                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                                    WHERE LOOKUP_TYPE ='ERP_LONGTERM_EXCEPT_VALCALSS'
                                                                      AND VALID_YN = 'Y'
                                                                 )
                            ) A
                    WHERE 1 =1
                    and  DIVISION_ID IN  (SELECT DISTINCT DIVISION_ID FROM SCM_PLANT_M_SN) ---(40,81,82)
                    ----------------------------------------------------------------------------------------------------------------------------------------------------------------



                    ---Process Group, Process Detail정보
                         SELECT DISTINCT
                                B.ITEM_ID
                               ,MAX(A.ITEM_TYPE) AS ITEM_TYPE
                               ,MAX(A.PROCESS_GROUP) AS PROCESS_GROUP
                               ,MAX(A.PROCESS_DETAIL) AS PROCESS_DETAIL
                               ,MAX(A.LEVEL_1_NAME) AS LEVEL_1_NAME
                               ,MAX(A.LEVEL_2_NAME) AS LEVEL_2_NAME
                               ,MAX(A.LEVEL_3_NAME) AS LEVEL_3_NAME
                               ,MAX(A.LEVEL_4_NAME) AS LEVEL_4_NAME
                       INTO #X_ITEM_CLASS
                       FROM SCM_MST_ITEM_CLASS_M A WITH(NOLOCK)
                       LEFT JOIN
                             (
                                SELECT S.ITEM_CLASS AS CLASS_ID , S.ITEM_ID
                                  FROM SCM_MST_ITEM_SN S WITH(NOLOCK)
                                  INNER JOIN #XIF R WITH(NOLOCK)
                                  ON S.ITEM_ID = R.ITEM_ID
                              ) B
                            ON A.CLASS_ID = B.CLASS_ID
                            GROUP BY B.ITEM_ID


                       SELECT DISTINCT
                              MAX(B.FORECAST_INFO_CELL_MODEL) AS FORECAST_INFO_CELL_MODEL
                             ,MAX(B.NICK_NAME) AS NICK_NAME
                             ,MAX(B.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                             ,MAX(B.SITE_ID) AS SITE_ID
                             ,MAX(B.ITEM_NAME) AS ITEM_NAME
                             ,MAX(B.ITEM_UOM) AS  ITEM_UOM,
                              A.ITEM_ID
                              --A.IFSEQNO ,  A.DIVISION_ID ,  A.YYYYMM ,  A.BUKRS ,  A.PLANT_ID ,  A.ITEM_ID ,
                              --A.CHARG ,  A.SPEMK ,  A.PRCTR ,  A.PRODH ,  A.MATKL ,  A.BWTAR ,  A.VALUATION_CLASS
                              --,  A.WAERS, A.CURRENCY
                              --,  A.UNIT_PRICE_ORG, A.UNIT_PRICE
                              --,  A.LPEIN ,  A.SNETP ,  A.SPEIN ,  A.SMENG
                              --,  A.CREATE_DATE,  A.CREATE_TIME,   A.CREATE_USER_ID
                              --,  A.UPDATE_DATE,  A.UPDATE_TIME,   A.UPDATE_USER_ID
                              --,  A.TRANSFER_DATE,A.TRANSFER_TIME, A.TRANSFER_USER_ID, A.TRANSFER_FLAG
                              --,  A.ATTRIBUTE1 ,  A.ATTRIBUTE2 ,  A.ATTRIBUTE3 ,  A.ATTRIBUTE4 ,  A.ATTRIBUTE5
                              --,  A.ATTRIBUTE6 ,  A.ATTRIBUTE7 ,  A.ATTRIBUTE8 ,  A.ATTRIBUTE9 ,  A.ATTRIBUTE10
                              --,  A.ATTRIBUTE11,  A.ATTRIBUTE12,  A.ATTRIBUTE13,  A.ATTRIBUTE14,  A.ATTRIBUTE15
                              --,  A.GRM01   ,  A.GRM02  ,  A.GRM03  ,  A.GRM04  ,  A.GRM05  ,  A.GRM06  ,  A.GRM07  ,  A.GRM08  ,  A.GRM09  ,  A.GRM10
                              --,  A.GRM11   ,  A.GRM12  ,  A.GRM13  ,  A.GRM14  ,  A.GRM15  ,  A.GRM16  ,  A.GRM17  ,  A.GRM18  ,  A.GRM19  ,  A.GRM20
                              --,  A.GRM21   ,  A.GRM22  ,  A.GRM23  ,  A.GRM24  ,  A.GRM25  ,  A.GRM26  ,  A.GRM27  ,  A.GRM28  ,  A.GRM29  ,  A.GRM30
                              --,  A.GRM31   ,  A.GRM32  ,  A.GRM33  ,  A.GRM34  ,  A.GRM35  ,  A.GRM36  ,  A.GRM37  ,  A.GRM38  ,  A.GRM39  ,  A.GRM40
                              --,  A.GRM41   ,  A.GRM42  ,  A.GRM43  ,  A.GRM44  ,  A.GRM45  ,  A.GRM46  ,  A.GRM47  ,  A.GRM48  ,  A.GRM49  ,  A.GRM50
                              --,  A.GRM51   ,  A.GRM52  ,  A.GRM53  ,  A.GRM54  ,  A.GRM55  ,  A.GRM56  ,  A.GRM57  ,  A.GRM58  ,  A.GRM59  ,  A.GRM60
                              --,  A.GRM61
                         INTO #MST_ITEM
                         FROM #XIF A
                    LEFT JOIN SCM_MST_ITEM_SN B
                           ON A.ITEM_ID = B.ITEM_ID
                     GROUP BY    A.ITEM_ID
                        --         A.IFSEQNO ,  A.DIVISION_ID ,  A.YYYYMM ,  A.BUKRS ,  A.PLANT_ID ,  A.ITEM_ID
                     --         ,  A.CHARG ,  A.SPEMK ,  A.PRCTR ,  A.PRODH ,  A.MATKL ,  A.BWTAR ,  A.VALUATION_CLASS
                              --,  A.WAERS, A.CURRENCY
                              --,  A.UNIT_PRICE_ORG, A.UNIT_PRICE
                              --,  A.LPEIN ,  A.SNETP ,  A.SPEIN ,  A.SMENG
                              --,  A.CREATE_DATE , A.CREATE_TIME ,  A.CREATE_USER_ID
                              --,  A.UPDATE_DATE , A.UPDATE_TIME ,  A.UPDATE_USER_ID
                              --,  A.TRANSFER_DATE,A.TRANSFER_TIME, A.TRANSFER_USER_ID, A.TRANSFER_FLAG
                              --,  A.ATTRIBUTE1 ,  A.ATTRIBUTE2 ,  A.ATTRIBUTE3 ,  A.ATTRIBUTE4 ,  A.ATTRIBUTE5
                              --,  A.ATTRIBUTE6 ,  A.ATTRIBUTE7 ,  A.ATTRIBUTE8 ,  A.ATTRIBUTE9 ,  A.ATTRIBUTE10
                              --,  A.ATTRIBUTE11,  A.ATTRIBUTE12,  A.ATTRIBUTE13,  A.ATTRIBUTE14,  A.ATTRIBUTE15
                              --,  A.GRM01   ,  A.GRM02  ,  A.GRM03  ,  A.GRM04  ,  A.GRM05  ,  A.GRM06  ,  A.GRM07  ,  A.GRM08  ,  A.GRM09  ,  A.GRM10
                              --,  A.GRM11   ,  A.GRM12  ,  A.GRM13  ,  A.GRM14  ,  A.GRM15  ,  A.GRM16  ,  A.GRM17  ,  A.GRM18  ,  A.GRM19  ,  A.GRM20
                              --,  A.GRM21   ,  A.GRM22  ,  A.GRM23  ,  A.GRM24  ,  A.GRM25  ,  A.GRM26  ,  A.GRM27  ,  A.GRM28  ,  A.GRM29  ,  A.GRM30
                              --,  A.GRM31   ,  A.GRM32  ,  A.GRM33  ,  A.GRM34  ,  A.GRM35  ,  A.GRM36  ,  A.GRM37  ,  A.GRM38  ,  A.GRM39  ,  A.GRM40
                              --,  A.GRM41   ,  A.GRM42  ,  A.GRM43  ,  A.GRM44  ,  A.GRM45  ,  A.GRM46  ,  A.GRM47  ,  A.GRM48  ,  A.GRM49  ,  A.GRM50
                              --,  A.GRM51   ,  A.GRM52  ,  A.GRM53  ,  A.GRM54  ,  A.GRM55  ,  A.GRM56  ,  A.GRM57  ,  A.GRM58  ,  A.GRM59  ,  A.GRM60
                              --,  A.GRM61

                          SELECT DISTINCT
                                 A.*
                                ,B.PROCESS_GROUP
                                ,B.PROCESS_DETAIL
                                ,C.ITEM_NAME, C.ITEM_UOM
                                ,C.FORECAST_INFO_CELL_MODEL
                                ,C.NICK_NAME
                                ,C.FORECAST_INFO_CELL_PACK_COUNT
                            INTO #XIF2
                            FROM #XIF A WITH(NOLOCK)
                       LEFT JOIN #X_ITEM_CLASS  B WITH(NOLOCK)
                              ON A.ITEM_ID = B.ITEM_ID
                       LEFT JOIN #MST_ITEM  C WITH(NOLOCK)
                              ON A.ITEM_ID = C.ITEM_ID

                    -- GRM01 ~ GRM61값을 UNPIVOT함
                       SELECT IFSEQNO,DIVISION_ID, YYYYMM, BUKRS, PLANT_ID, ITEM_ID, CHARG, SPEMK,  PRCTR, PRODH, MATKL, BWTAR, VALUATION_CLASS
                            , WAERS, CURRENCY
                            , UNIT_PRICE_ORG, UNIT_PRICE
                            , LPEIN, SNETP, SPEIN, SMENG, DEVALUATION_AGE
                            , CAST(REPLACE(DEVALUATION_AGE,'GRM','' ) AS INT) - 1 AS LONG_TERM_TYPE
                            , LONG_TERM_STOCK_QTY
                            ,   CASE
                                WHEN CAST(LPEIN AS NUMERIC) <> 0
                                THEN  LONG_TERM_STOCK_QTY * Convert(numeric(20,5), UNIT_PRICE_ORG) / CAST(LPEIN AS NUMERIC)
                                END AS LONG_TERM_STOCK_AMOUNT
                            , PROCESS_GROUP, PROCESS_DETAIL, ITEM_NAME, ITEM_UOM , FORECAST_INFO_CELL_MODEL ,NICK_NAME ,FORECAST_INFO_CELL_PACK_COUNT
                            , CREATE_DATE,   CREATE_TIME,   CREATE_USER_ID
                            , UPDATE_DATE,   UPDATE_TIME,   UPDATE_USER_ID
                            , TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID, TRANSFER_FLAG
                            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                            , ATTRIBUTE11,ATTRIBUTE12,ATTRIBUTE13,ATTRIBUTE14,ATTRIBUTE15
                       INTO #XIF3
                       FROM #XIF2
                      UNPIVOT( LONG_TERM_STOCK_QTY
                             FOR DEVALUATION_AGE
                             IN (
                                 GRM01  ,GRM02  ,GRM03  ,GRM04  ,GRM05  ,GRM06  ,GRM07  ,GRM08  ,GRM09  ,GRM10
                                ,GRM11  ,GRM12  ,GRM13  ,GRM14  ,GRM15  ,GRM16  ,GRM17  ,GRM18  ,GRM19  ,GRM20
                                ,GRM21  ,GRM22  ,GRM23  ,GRM24  ,GRM25  ,GRM26  ,GRM27  ,GRM28  ,GRM29  ,GRM30
                                ,GRM31  ,GRM32  ,GRM33  ,GRM34  ,GRM35  ,GRM36  ,GRM37  ,GRM38  ,GRM39  ,GRM40
                                ,GRM41  ,GRM42  ,GRM43  ,GRM44  ,GRM45  ,GRM46  ,GRM47  ,GRM48  ,GRM49  ,GRM50
                                ,GRM51  ,GRM52  ,GRM53  ,GRM54  ,GRM55  ,GRM56  ,GRM57  ,GRM58  ,GRM59  ,GRM60
                                ,GRM61
                                )) AS XIF_UNPVT
                             WHERE CONVERT(FLOAT, LONG_TERM_STOCK_QTY) > 0  -- 2025/02/28   kimcd NUMERIC에서 FLOAT로 변경

                    INSERT INTO SCP_ANL_LONG_TERM_STOCK
                            (
                              DIVISION_ID, YYYYMM, BUKRS, PLANT_ID, ITEM_ID, CHARG, SPEMK,  PRCTR, PRODH, MATKL, BWTAR, VALUATION_CLASS
                            , WAERS, CURRENCY
                            , UNIT_PRICE_ORG, UNIT_PRICE, UNIT_PRICE_KRW
                            , LPEIN, SNETP, SPEIN, SMENG
                            , DEVALUATION_AGE, LONG_TERM_TYPE, LONG_TERM_TYPE_CODE
                            , EX_TO_BAMT
                            , LONG_TERM_STOCK_QTY
                            , LONG_TERM_STOCK_AMOUNT
                            , AMOUNT
                            , AMOUNT_KRW
                            , PROCESS_GROUP, PROCESS_DETAIL, ITEM_NAME, ITEM_UOM, GPLM_CELL_MODEL, MDM_NICK_NAME,GPLM_CELL_CONVERSION_FACTOR
                            , CREATE_DATE,   CREATE_TIME,   CREATE_USER_ID
                            , UPDATE_DATE,   UPDATE_TIME,   UPDATE_USER_ID
                            , TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID, TRANSFER_FLAG
                            , ATTRIBUTE1,  ATTRIBUTE2,  ATTRIBUTE3,  ATTRIBUTE4,  ATTRIBUTE5
                            , ATTRIBUTE6,  ATTRIBUTE7,  ATTRIBUTE8,  ATTRIBUTE9,  ATTRIBUTE10
                            , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15
                            )
                            SELECT
                                  DIVISION_ID
                                , A.YYYYMM
                                , BUKRS, PLANT_ID, ITEM_ID, CHARG, SPEMK,  PRCTR, PRODH, MATKL, BWTAR, VALUATION_CLASS
                                , WAERS, CURRENCY
                                , UNIT_PRICE_ORG, UNIT_PRICE
                                , IIF(A.WAERS=N'KRW' OR B.EX_TO_BAMT=0, A.UNIT_PRICE, ISNULL(B.EX_TO_BAMT, 1) * UNIT_PRICE) AS UNIT_PRICE_KRW
                              --, IIF(A.WAERS=N'KRW' OR A.EX_TO_BAMT=0, A.UNIT_PRICE, ROUND(A.UNIT_PRICE,2,1) * A.EX_TO_BAMT) AS UNIT_PRICE
                                , LPEIN, SNETP, SPEIN, SMENG
                              , CASE WHEN A.LONG_TERM_TYPE > 9
                                     THEN  'GRM' + CAST(A.LONG_TERM_TYPE AS VARCHAR)
                                     ELSE  'GRM0' + CAST(A.LONG_TERM_TYPE AS VARCHAR)
                                      END AS DEVALUATION_AGE
                                -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 변경. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') Start
                                , C.LONG_TERM_TYPE
                                , C.LONG_TERM_TYPE_CODE
                                /*CASE WHEN LONG_TERM_TYPE >= 0 AND LONG_TERM_TYPE <= 2  THEN N'비대상'
                                     WHEN LONG_TERM_TYPE >= 3 AND LONG_TERM_TYPE <= 5  THEN N'부실 징후'
                                     WHEN LONG_TERM_TYPE >= 6 THEN N'부실'
                                      END AS LONG_TERM_TYPE,
                                CASE WHEN LONG_TERM_TYPE >= 0 AND LONG_TERM_TYPE <= 2  THEN 'CODE_2'
                                     WHEN LONG_TERM_TYPE >= 3 AND LONG_TERM_TYPE <= 5  THEN 'CODE_5'
                                     WHEN LONG_TERM_TYPE >= 6 THEN  'CODE_6'
                                      END AS LONG_TERM_TYPE_CODE*/
                                -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 변경. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') End
                                 , ISNULL(B.EX_TO_BAMT,0) AS EX_TO_BAMT
                                 , LONG_TERM_STOCK_QTY
                                 , LONG_TERM_STOCK_AMOUNT AS LONG_TERM_STOCK_AMOUNT
                                 , LONG_TERM_STOCK_AMOUNT AS AMOUNT

                                 , IIF(A.WAERS=N'KRW' OR B.EX_TO_BAMT=0, A.LONG_TERM_STOCK_AMOUNT, B.EX_TO_BAMT*A.LONG_TERM_STOCK_AMOUNT) AS AMOUNT_KRW
                                 , PROCESS_GROUP, PROCESS_DETAIL
                                 , ITEM_NAME
                                 , ITEM_UOM
                                 , FORECAST_INFO_CELL_MODEL
                                 , NICK_NAME
                                 , FORECAST_INFO_CELL_PACK_COUNT
                                 , CREATE_DATE,   CREATE_TIME,   CREATE_USER_ID
                                 , UPDATE_DATE,   UPDATE_TIME,   UPDATE_USER_ID
                                 , TRANSFER_DATE, TRANSFER_TIME, TRANSFER_USER_ID, TRANSFER_FLAG
                                 , DEVALUATION_AGE AS ATTRIBUTE1 ,  A.ATTRIBUTE2,  A.ATTRIBUTE3,  A.ATTRIBUTE4,  A.ATTRIBUTE5
                                 , A.ATTRIBUTE6,                    A.ATTRIBUTE7,  A.ATTRIBUTE8,  A.ATTRIBUTE9,  A.ATTRIBUTE10
                                 , A.ATTRIBUTE11,                   A.ATTRIBUTE12, A.ATTRIBUTE13, A.ATTRIBUTE14, A.ATTRIBUTE15
                              FROM #XIF3 A
                          LEFT JOIN #tmp_XIF_ERP_EXCRATE_R_SN B
                                 ON A.WAERS = B.EX_FROM_CURR_CD
                               -- AND B.YYYYMM = @MAX_SPMON
                          -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 변경. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') Start
                          LEFT JOIN #TMP_LONG_TERM_TYPE C 
                                 ON A.LONG_TERM_TYPE >= C.GRM_MM_FROM AND A.LONG_TERM_TYPE <= C.GRM_MM_TO
                          -- [E20250310-000014] #TMP_LONG_TERM_TYPE 룩업 변경. 업무 용어 변경에 따른 시스템내 표기 수정 요청 ('부실' -> '장기') End

                         UPDATE  XIF_ERP_LONG_TERM_STOCK_R_SN
                            SET  TRANSFER_FLAG = 'Y'
                          WHERE  TRANSFER_FLAG = 'P'
                          
        END;
        ---------------------------------------------------------------------------------------------------------
        --  데이터 생성 끝
        ---------------------------------------------------------------------------------------------------------

        ---------------------------------------------------------------------------------------------------------
        -- 임시 테이블 삭제
        ---------------------------------------------------------------------------------------------------------
        IF OBJECT_ID('tempdb..#XIF') IS NOT NULL
            DROP TABLE #XIF;

        IF OBJECT_ID('tempdb..#XIF2') IS NOT NULL
            DROP TABLE #XIF2;

        IF OBJECT_ID('tempdb..#XIF3') IS NOT NULL
            DROP TABLE #XIF3;

        IF OBJECT_ID('tempdb..#SEQ_NO') IS NOT NULL
            DROP TABLE #SEQ_NO;

        IF OBJECT_ID('tempdb..#CURR') IS NOT NULL
            DROP TABLE #CURR;

        IF OBJECT_ID('tempdb..#X_ITEM') IS NOT NULL
            DROP TABLE #MST_ITEM;

        IF OBJECT_ID('tempdb..#X_ITEM_CLASS') IS NOT NULL
            DROP TABLE #X_ITEM_CLASS;
            
        -- [E20250310-000014] LONG_TERM_TYPE 임시테이블 삭제
        IF OBJECT_ID('tempdb..#TMP_LONG_TERM_TYPE') IS NOT NULL
            DROP TABLE #TMP_LONG_TERM_TYPE;

        END;
     END TRY

     BEGIN CATCH
    --  IF @@TRANCOUNT > 0
    --    BEGIN
    --      ROLLBACK
    --END;

      -- ERROR LOG
      SET @v_log_type = N'ERROR';
      SET @v_log_message = CAST(ERROR_MESSAGE() AS NVARCHAR(1000));
      SET @v_description = N'ERROR_LINE : ' + STR(ERROR_LINE());
      SET @d_event_date = SYSDATETIME();
      EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                                ,@p_log_type      =@v_log_type
                                ,@p_log_count     =@n_log_count
                                ,@p_log_message   =@v_log_message
                                ,@p_description   =@v_description
                                ,@p_event_date    =@d_event_date
                                ,@p_user_id       =@v_batch_user
                                ;
       --      PRINT @@ERROR
       PRINT @v_log_message + ' : ' + @v_description;

      return -1
    END CATCH;

    -- 종료 LOG
    SET @v_log_type = N'END';
    SET @v_log_message = '########## END of procedure ##########'; --[E20250423-000916] Log 양식에 맞춤
    SET @v_description = N'['  + @v_exec_time + ']';
    SET @d_event_date = SYSDATETIME()  ;
    EXEC PR_SCP_SYS_LOG_BATCH  @p_program_name  =@v_program_name
                              ,@p_log_type      =@v_log_type
                              ,@p_log_count     =@n_log_count
                              ,@p_log_message   =@v_log_message
                              ,@p_description   =@v_description
                              ,@p_event_date    =@d_event_date
                              ,@p_user_id       =@v_batch_user
                              ;
    return 1

    _RETURN_ERR_CODE:
        BEGIN
             RETURN -1
    END;

END
