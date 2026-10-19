CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_SALES_ACT_01
(
    @P_DIVISION_ID VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    /* ============================================================
       날짜 변수
       ============================================================ */

    DECLARE @V_START_YYYYMM            CHAR(6);
    DECLARE @V_START_YYYYMMDD          CHAR(8);
    DECLARE @V_START_YYYYMMDD_EXCHANGE CHAR(8);
    DECLARE @V_END_YYYYMM              CHAR(6);
    DECLARE @V_END_YYYYMMDD            CHAR(8);


    /* 매월 1일이면 전전월, 그 외에는 전월 */
    SET @V_START_YYYYMM =
        CONVERT(
            CHAR(6),
            DATEADD
            (
                MONTH,
                CASE
                    WHEN DAY(GETDATE()) = 1 THEN -2
                    ELSE -1
                END,
                GETDATE()
            ),
            112
        );


    SET @V_START_YYYYMMDD =
        @V_START_YYYYMM + '01';


    /* 당월 1일 */
    SET @V_START_YYYYMMDD_EXCHANGE =
        CONVERT(CHAR(6), GETDATE(), 112) + '01';


    SET @V_END_YYYYMM =
        CONVERT(CHAR(6), GETDATE(), 112);


    SET @V_END_YYYYMMDD =
        CONVERT(CHAR(8), GETDATE(), 112);


    BEGIN TRY
        BEGIN TRAN;


        /* ============================================================
           STEP 1.
           RESULT 기간 산출

           RESULT_YYYYMM 변경 대응
           RESULT_YYYYMM_FROM / RESULT_YYYYMM_TO
           ============================================================ */

        IF OBJECT_ID('tempdb..#RESULT_PERIOD') IS NOT NULL
            DROP TABLE #RESULT_PERIOD;


        SELECT
              X.IFSEQNO
            , MIN(X.RESULT_YYYYMM) + '01' AS RESULT_YYYYMM_FROM
            , MAX(X.RESULT_YYYYMM)   + '31' AS RESULT_YYYYMM_TO
        INTO #RESULT_PERIOD
        FROM dbo.XIF_ERP_SALES_RESULT_R_SN X
        WHERE X.SALES_POSTING_DATE >= @V_START_YYYYMMDD
          AND X.TRANSFER_FLAG = 'P'
        GROUP BY X.IFSEQNO;


        /* ============================================================
           STEP 2.
           DM_DNM_SALES_RESULT_IF
           ============================================================ */

        DELETE T
        FROM dbo.DM_DNM_SALES_RESULT_IF T
        WHERE T.SALES_POSTING_DATE >= @V_START_YYYYMMDD
          AND EXISTS
          (
              SELECT 1
              FROM #RESULT_PERIOD P
              WHERE T.SALES_POSTING_DATE
                    BETWEEN P.RESULT_YYYYMM_FROM
                        AND P.RESULT_YYYYMM_TO
          );


        /* ============================================================
           STEP 3.
           삭제 대상 DIVISION 생성 (#TARGET_DIVISION)

           Oracle GT_MFSRM_I_DIVISION 대체
           원본: RESULT_MAPPING_SCHEDULE 기준 산출
           이관: @P_DIVISION_ID 파라미터 사용 (아래 상세 주석 참고)
           ============================================================ */

        IF OBJECT_ID('tempdb..#TARGET_DIVISION') IS NOT NULL
            DROP TABLE #TARGET_DIVISION;


        CREATE TABLE #TARGET_DIVISION
        (
            DIVISION_ID VARCHAR(20) NOT NULL PRIMARY KEY
        );


        /* ------------------------------------------------------------
           이관 대응:
           원본은 SCM_ADM_LOOKUP_MASTER_DETAIL(LOOKUP_TYPE =
           'RESULT_MAPPING_SCHEDULE') 에서 대상 DIVISION 을 산출했으나,
           해당 테이블은 이관 대상이 아니므로 새 환경에서 비어 있어
           #TARGET_DIVISION 이 empty 가 되고 STEP 4~10 삭제가
           전혀 수행되지 않는다.

           => 파라미터로 전달받은 @P_DIVISION_ID 를 삭제 대상으로 사용.
              (다른 이관 프로시저의 WHERE DIVISION_ID = @P_DIVISION_ID 방식과 일관)

           원본 로직은 아래에 주석으로 보존. 향후 SCM_ADM_LOOKUP_MASTER_DETAIL
           이 이관되면 이 INSERT 를 제거하고 아래 주석을 복원하면 된다.
           ------------------------------------------------------------ */

        INSERT INTO #TARGET_DIVISION
        (
            DIVISION_ID
        )
        VALUES
        (
            @P_DIVISION_ID
        );


        /* -- 원본 로직 (이관 보류: SCM_ADM_LOOKUP_MASTER_DETAIL 미이관) --
        INSERT INTO #TARGET_DIVISION
        (
            DIVISION_ID
        )
        SELECT DISTINCT
            M.SEGMENT1
        FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL M
        WHERE M.LOOKUP_TYPE = 'RESULT_MAPPING_SCHEDULE'

          AND
          (
              M.SEGMENT2 = 'ALL'

              OR M.SEGMENT2 IN
              (
                  SELECT C.DAYOFWEEK
                  FROM dbo.SCM_SYS_CALENDAR_M C
                  WHERE C.BASIS_YYYYMMDD =
                        CONVERT(CHAR(8), GETDATE(), 112)
              )
          )

          AND
          (
              CASE
                  WHEN M.ATTRIBUTE1 IS NOT NULL
                       AND M.ATTRIBUTE1 IN
                       (
                           SELECT C.DAYOFWEEK
                           FROM dbo.SCM_SYS_CALENDAR_M C
                           WHERE C.BASIS_YYYYMMDD =
                                 CONVERT(CHAR(8), GETDATE(), 112)
                       )
                  THEN M.SEGMENT1

                  ELSE '1'
              END
          ) = '1'

          AND LEFT(M.SEGMENT3, 2)
              BETWEEN
                  RIGHT
                  (
                      '0' +
                      CONVERT
                      (
                          VARCHAR(2),
                          DATEPART
                          (
                              HOUR,
                              DATEADD(HOUR, -1, GETDATE())
                          )
                      ),
                      2
                  )

              AND

                  RIGHT
                  (
                      '0' +
                      CONVERT
                      (
                          VARCHAR(2),
                          DATEPART(HOUR, GETDATE())
                      ),
                      2
                  )

          AND M.VALID_YN = 'Y'
          AND M.SEGMENT4 = 'RESULT';
        */



        /* ============================================================
           STEP 4.
           DM_PLN_MKT_FCST_RESULT - RTF
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_MKT_FCST_RESULT T
        WHERE T.MEASURE = 'RTF'
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        /* ============================================================
           STEP 5.
           DM_PLN_SALES_PLAN_RESULT
           매출실적 / MKT 금액
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN_RESULT T
        WHERE T.MEASURE IN
        (
              'RTF'
            , 'SalesAmt_LOC'
            , 'SalesAmt_KRW'
            , 'MKT_AMT_LOC'
            , 'MKT_AMT_KRW'
            , 'SalesAmt_KRW_ERP'
            , 'MKT_AMT_KRW_ERP'
        )
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        /* ============================================================
           STEP 6.
           40 사업부 환율 재계산 범위

           원본 로직 그대로 유지
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN_RESULT T
        WHERE T.MEASURE IN
        (
            'SalesAmt_KRW',
            'MKT_AMT_KRW'
        )
          AND T.YYYYMMDD >= @V_START_YYYYMMDD_EXCHANGE
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND T.DIVISION_ID = '40'
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        /* ============================================================
           STEP 7.
           RTF_SYS_RP
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_MKT_FCST_RESULT T
        WHERE T.MEASURE = 'RTF_SYS_RP'
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN_RESULT T
        WHERE T.MEASURE = 'RTF_SYS_RP'
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        /* ============================================================
           STEP 8.
           AS 결과 (40 / 81 / 82 공통)
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_MKT_FCST_RESULT T
        WHERE T.MEASURE IN
        (
            'AS_Inv',
            'AS_In_Plan',
            'AS_In_Req'
        )
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        /* ============================================================
           STEP 9.
           VMI 결과 - 40 / 82
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_MKT_FCST_RESULT T
        WHERE T.MEASURE IN
        (
            'VMI_Inv',
            'VMI_In_Plan',
            'VMI_In_Req'
        )
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND T.DIVISION_ID IN ('40', '82')
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN_RESULT T
        WHERE T.MEASURE IN
        (
            'VMI_Inv',
            'VMI_In_Plan',
            'VMI_In_Req'
        )
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND T.DIVISION_ID IN ('40', '82')
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        /* ============================================================
           STEP 10.
           81 계열 VMI 결과

           Oracle:
           DIVISION_ID LIKE '81%'
           ============================================================ */

        DELETE T
        FROM dbo.DM_PLN_MKT_FCST_RESULT T
        WHERE T.MEASURE IN
        (
            'VMI_In_Plan',
            'VMI_In_Req'
        )
          AND T.YYYYMMDD >= @V_START_YYYYMMDD
          AND T.YYYYMMDD <  @V_END_YYYYMMDD
          AND T.DIVISION_ID LIKE '81%'
          AND EXISTS
          (
              SELECT 1
              FROM #TARGET_DIVISION D
              WHERE D.DIVISION_ID = T.DIVISION_ID
          );


        COMMIT TRAN;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;

    END CATCH

END;

