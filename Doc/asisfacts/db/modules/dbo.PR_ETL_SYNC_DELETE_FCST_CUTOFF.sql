
-- PR_ETL_SYNC_DELETE_FCST_CUTOFF.sql
CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
(
      @P_DIVISION_ID VARCHAR(20)
    , @P_VER_TYPE    VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF @P_VER_TYPE NOT IN ('MF_W', 'SF_W')
        THROW 50001, 'P_VER_TYPE은 MF_W 또는 SF_W만 가능합니다.', 1;




    DECLARE @V_CUR_MONDAY          CHAR(8);
    DECLARE @V_START_YYYYMMDD      CHAR(8);
    DECLARE @V_END_YYYYMMDD        CHAR(8);
    DECLARE @V_CUTOFF_FLAG         CHAR(1);

    SET @V_CUR_MONDAY =
        CONVERT(CHAR(8), DATEADD(DAY, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

    SET @V_START_YYYYMMDD = CONVERT(CHAR(6), GETDATE(), 112) + '01';
    SET @V_END_YYYYMMDD   = CONVERT(CHAR(8), GETDATE(), 112);

    /* CUTOFF FLAG: 호출 파라미터가 아니라 DM_MST_VERSION 기반 내부 계산 */
    IF @P_DIVISION_ID = '40'
       OR @P_DIVISION_ID LIKE '81%'
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM dbo.DM_MST_VERSION
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND VERSION_TYPE = 'SP_W'
              AND YYYYMMDD >= @V_CUR_MONDAY
        )
            SET @V_CUTOFF_FLAG = 'Y';
        ELSE
            SET @V_CUTOFF_FLAG = 'N';
    END
    ELSE
    BEGIN
        SET @V_CUTOFF_FLAG = 'N';
    END;

    BEGIN TRY
        BEGIN TRAN;

        /* CFM MKT_FCST 추가 삭제 전에 후속 SALES_PLAN DELETE_SEQ 7의 계산 원천을 보존한다. */
        IF OBJECT_ID('tempdb..#CFM_MKT_BEFORE_DELETE') IS NOT NULL
            DROP TABLE #CFM_MKT_BEFORE_DELETE;
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
               A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD,
               A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.ATTRIBUTE2 AS FROM_SITE_ID, A.QTY
        INTO #CFM_MKT_BEFORE_DELETE
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE @P_DIVISION_ID = '40' AND @P_VER_TYPE = 'MF_W'
          AND A.DIVISION_ID = @P_DIVISION_ID
          AND A.YYYYMMDD >= @V_CUR_MONDAY
          AND A.MEASURE = 'MKT_FCST'
          AND EXISTS (SELECT 1 FROM dbo.SCM_MST_ITEM_SN I WHERE I.ITEM_ID = A.ITEM_ID);

        /* 40 / 81 계열 MF_W: SCM_FCST 재생성 범위 정리 + 사용자 요청 MKT_FCST 동일 구간 정리.
           Oracle는 SCM_FCST만 재생성한다. MKT_FCST 추가 삭제는 이관 전용 규칙이며 두 MEASURE 전량 재적재 필요. */
        IF (@P_DIVISION_ID = '40' OR @P_DIVISION_ID LIKE '81%') AND @P_VER_TYPE = 'MF_W'
        BEGIN
            /* DELETE_SEQ 1 : DM_PLN_MKT_FCST MKT_FCST / SCM_FCST (40 / 81 계열 MF_W) */
            DELETE FROM dbo.DM_PLN_MKT_FCST
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_CUR_MONDAY
              AND MEASURE IN ('MKT_FCST', 'SCM_FCST');
        END;

        /* CFM 테이블은 40 MF_W만: SCM_FCST와 사용자 요청 MKT_FCST 동일 구간 정리. */
        IF @P_DIVISION_ID = '40' AND @P_VER_TYPE = 'MF_W'
        BEGIN
            /* DELETE_SEQ 2 : DM_PLN_CFM_MKT_DEMAND_PLAN MKT_FCST / SCM_FCST (40 MF_W 전용) */
            DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_CUR_MONDAY
              AND MEASURE IN ('MKT_FCST', 'SCM_FCST');
        END;

        /* DELETE_SEQ 3/4 폐기: 82 RTF 삭제는 주간 MF_W/SF_W 호출 경로에 없음.
           Oracle 2026-09-29 재조회 근거. 82 LATEST는 DELETE_SEQ 11에서 처리한다.
           나머지 DELETE_SEQ는 기존 백업 이력과의 대응을 위해 유지한다. */

        IF OBJECT_ID('tempdb..#T2_MKT_FCST') IS NOT NULL
            DROP TABLE #T2_MKT_FCST;

        SELECT
              A.DIVISION_ID
            , A.PROJECT_CODE
            , A.SCM_SITE_ID
            , A.ITEM_ID
            , A.DOM_EXP
            , A.FCST_TYPE
            , A.INCOTERMS
            , A.MEASURE
            , A.YYYYMMDD
            , A.PLANT_SITE_ID
            , A.CELL_PROD_SITE_ID
            , A.ATTRIBUTE2 AS FROM_SITE_ID
            , A.QTY
        INTO #T2_MKT_FCST
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN A
        WHERE A.DIVISION_ID = @P_DIVISION_ID
          AND A.YYYYMMDD >= @V_CUR_MONDAY
          AND A.MEASURE IN ('MKT_FCST','RTF','RTF_SYS_RP','SCM_FCST','RTF_PR')
          AND EXISTS
          (
              SELECT 1 FROM dbo.SCM_MST_ITEM_SN I
              WHERE I.ITEM_ID = A.ITEM_ID
          )
        UNION
        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
               DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD,
               PLANT_SITE_ID, CELL_PROD_SITE_ID, FROM_SITE_ID, QTY
        FROM #CFM_MKT_BEFORE_DELETE
        UNION
        SELECT
              A.DIVISION_ID
            , A.PROJECT_CODE
            , A.SCM_SITE_ID
            , A.ITEM_ID
            , A.DOM_EXP
            , A.FCST_TYPE
            , A.INCOTERMS
            , A.MEASURE
            , A.YYYYMMDD
            , A.PLANT_SITE_ID
            , '-' AS CELL_PROD_SITE_ID
            , '-' AS FROM_SITE_ID
            , A.QTY
        FROM dbo.DM_PLN_MKT_FCST A
        WHERE A.DIVISION_ID = @P_DIVISION_ID
          AND A.YYYYMMDD >= @V_CUR_MONDAY
          AND A.MEASURE IN ('CUST_FCST','TMM_FCST')
          AND EXISTS
          (
              SELECT 1 FROM dbo.SCM_MST_ITEM_SN I
              WHERE I.ITEM_ID = A.ITEM_ID
          );

        IF OBJECT_ID('tempdb..#RTF_EXCEPTION_ITEM') IS NOT NULL
            DROP TABLE #RTF_EXCEPTION_ITEM;

        CREATE TABLE #RTF_EXCEPTION_ITEM
        (
              DIVISION_ID        VARCHAR(20)
            , PROJECT_CODE       VARCHAR(100)
            , SCM_SITE_ID        VARCHAR(100)
            , ITEM_ID            VARCHAR(100)
            , DOM_EXP            VARCHAR(100)
            , FCST_TYPE          VARCHAR(100)
            , INCOTERMS          VARCHAR(100)
            , MEASURE            VARCHAR(100)
            , PLANT_SITE_ID      VARCHAR(100)
            , CELL_PROD_SITE_ID  VARCHAR(100)
        );

        IF @V_CUTOFF_FLAG = 'Y'
        BEGIN
            INSERT INTO #RTF_EXCEPTION_ITEM
            SELECT
                  A.DIVISION_ID
                , A.PROJECT_CODE
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.DOM_EXP
                , A.FCST_TYPE
                , A.INCOTERMS
                , A.MEASURE
                , A.PLANT_SITE_ID
                , A.CELL_PROD_SITE_ID
            FROM dbo.DM_PLN_SALES_PLAN A
            WHERE A.DIVISION_ID = @P_DIVISION_ID
              AND A.YYYYMMDD >= @V_CUR_MONDAY
              AND CONVERT(CHAR(8), A.LAST_UPDATE_DATE, 112) >= @V_CUR_MONDAY
              AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
              AND A.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
            GROUP BY
                  A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                  A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                  A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID;

            INSERT INTO #RTF_EXCEPTION_ITEM
            SELECT
                  A.DIVISION_ID
                , A.PROJECT_CODE
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.DOM_EXP
                , A.FCST_TYPE
                , A.INCOTERMS
                , A.MEASURE
                , A.PLANT_SITE_ID
                , A.CELL_PROD_SITE_ID
            FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN A
            WHERE A.MEASURE = 'RTF_PR'
              AND EXISTS
              (
                  SELECT 1
                  FROM #RTF_EXCEPTION_ITEM B
                  WHERE B.DIVISION_ID       = A.DIVISION_ID
                    AND B.PROJECT_CODE      = A.PROJECT_CODE
                    AND B.SCM_SITE_ID       = A.SCM_SITE_ID
                    AND B.ITEM_ID           = A.ITEM_ID
                    AND B.DOM_EXP           = A.DOM_EXP
                    AND B.FCST_TYPE         = A.FCST_TYPE
                    AND B.INCOTERMS         = A.INCOTERMS
                    AND B.PLANT_SITE_ID     = A.PLANT_SITE_ID
                    AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
              )
            GROUP BY
                  A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                  A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                  A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID;
        END;

        /* DELETE_SEQ 5 : DM_PLN_SALES_PLAN — SN 아이템 + SITE_ITEM 보존 + RTF Exception 보존 + CATCH_UP 제외 */
        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN T
        WHERE T.YYYYMMDD >= @V_CUR_MONDAY
          AND T.DIVISION_ID = @P_DIVISION_ID
          AND EXISTS
          (
              SELECT 1 FROM dbo.SCM_MST_ITEM_SN I
              WHERE I.ITEM_ID = T.ITEM_ID
          )
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.SCM_MST_SITE_ITEM A
              INNER JOIN dbo.DM_PLN_SALES_PLAN B
                  ON  B.ITEM_ID      = A.ITEM_ID
                  AND B.DIVISION_ID  = A.DIVISION_ID
                  AND B.PROJECT_CODE = A.PROJECT_CODE
                  AND B.SCM_SITE_ID  = A.SCM_SITE_ID
              WHERE A.SALES_PLAN_ADJUST_YN = 'N'
                AND B.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
                AND B.YYYYMMDD >= @V_CUR_MONDAY
                AND A.DIVISION_ID  = T.DIVISION_ID
                AND A.PROJECT_CODE = T.PROJECT_CODE
                AND A.SCM_SITE_ID  = T.SCM_SITE_ID
                AND A.ITEM_ID      = T.ITEM_ID
          )
          AND NOT EXISTS
          (
              SELECT 1
              FROM #RTF_EXCEPTION_ITEM A
              WHERE A.DIVISION_ID       = T.DIVISION_ID
                AND A.PROJECT_CODE      = T.PROJECT_CODE
                AND A.SCM_SITE_ID       = T.SCM_SITE_ID
                AND A.ITEM_ID           = T.ITEM_ID
                AND A.DOM_EXP           = T.DOM_EXP
                AND A.FCST_TYPE         = T.FCST_TYPE
                AND A.INCOTERMS         = T.INCOTERMS
                AND A.MEASURE           = T.MEASURE
                AND A.PLANT_SITE_ID     = T.PLANT_SITE_ID
                AND A.CELL_PROD_SITE_ID = T.CELL_PROD_SITE_ID
          )
          AND T.MEASURE NOT IN
          (
              'CATCH_UP','LOC_Catch_Up','SalesAmt_KRW_Catch_Up',
              'SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up'
          );

        /* DELETE_SEQ 6 : DM_PLN_SALES_PLAN — RTF Exception 보존 + MEASURE 계열 한정 */
        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN T
        WHERE T.YYYYMMDD >= @V_CUR_MONDAY
          AND T.DIVISION_ID = @P_DIVISION_ID
          AND EXISTS
          (
              SELECT 1 FROM dbo.SCM_MST_ITEM_SN I
              WHERE I.ITEM_ID = T.ITEM_ID
          )
          AND NOT EXISTS
          (
              SELECT 1
              FROM #RTF_EXCEPTION_ITEM A
              WHERE A.DIVISION_ID   = T.DIVISION_ID
                AND A.PROJECT_CODE  = T.PROJECT_CODE
                AND A.SCM_SITE_ID   = T.SCM_SITE_ID
                AND A.ITEM_ID       = T.ITEM_ID
                AND A.DOM_EXP       = T.DOM_EXP
                AND A.FCST_TYPE     = T.FCST_TYPE
                AND A.INCOTERMS     = T.INCOTERMS
                AND A.MEASURE       = T.MEASURE
                AND A.PLANT_SITE_ID = T.PLANT_SITE_ID
          )
          AND T.MEASURE IN
          ('MKT_FCST','CUST_FCST','RTF','RTF_SYS_RP','TMM_FCST','SCM_FCST','RTF_PR');

        IF OBJECT_ID('tempdb..#SALES_PLAN_TEMP_LOC') IS NOT NULL
            DROP TABLE #SALES_PLAN_TEMP_LOC;

        CREATE TABLE #SALES_PLAN_TEMP_LOC
        (
              DIVISION_ID        VARCHAR(20)
            , PROJECT_CODE       VARCHAR(100)
            , SCM_SITE_ID        VARCHAR(100)
            , ITEM_ID            VARCHAR(100)
            , DOM_EXP            VARCHAR(100)
            , FCST_TYPE          VARCHAR(100)
            , INCOTERMS          VARCHAR(100)
            , MEASURE            VARCHAR(100)
            , PLANT_SITE_ID      VARCHAR(100)
            , CELL_PROD_SITE_ID  VARCHAR(100)
            , YYYYMMDD           CHAR(8)
        );

        /* SALES_PLAN_TEMP_LOC: 40 / 81 계열 공통 */
        IF @P_DIVISION_ID = '40'
           OR @P_DIVISION_ID LIKE '81%'
        BEGIN
            INSERT INTO #SALES_PLAN_TEMP_LOC
            SELECT
                  A.DIVISION_ID
                , A.PROJECT_CODE
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.DOM_EXP
                , A.FCST_TYPE
                , A.INCOTERMS
                , 'RTF_SYS_RP'
                , A.PLANT_SITE_ID
                , A.CELL_PROD_SITE_ID
                , A.YYYYMMDD
            FROM #T2_MKT_FCST A
            WHERE A.MEASURE IN ('RTF_SYS_RP','MKT_FCST')
              AND NOT EXISTS
              (
                  SELECT 1
                  FROM #T2_MKT_FCST B
                  WHERE B.MEASURE = 'RTF_SYS_RP'
                    AND B.DIVISION_ID       = A.DIVISION_ID
                    AND B.PROJECT_CODE      = A.PROJECT_CODE
                    AND B.SCM_SITE_ID       = A.SCM_SITE_ID
                    AND B.ITEM_ID           = A.ITEM_ID
                    AND B.DOM_EXP           = A.DOM_EXP
                    AND B.FCST_TYPE         = A.FCST_TYPE
                    AND B.INCOTERMS         = A.INCOTERMS
                    AND B.PLANT_SITE_ID     = A.PLANT_SITE_ID
                    AND B.CELL_PROD_SITE_ID = A.CELL_PROD_SITE_ID
                    AND B.YYYYMMDD          = A.YYYYMMDD
              )
            GROUP BY
                  A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                  A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS,
                  A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID, A.YYYYMMDD
            HAVING SUM(CASE WHEN A.MEASURE = 'MKT_FCST' THEN A.QTY ELSE 0 END) <> 0;
        END;

        /* DELETE_SEQ 7 : DM_PLN_SALES_PLAN — #SALES_PLAN_TEMP_LOC 기반 */
        DELETE T
        FROM dbo.DM_PLN_SALES_PLAN T
        WHERE EXISTS
        (
            SELECT 1
            FROM #SALES_PLAN_TEMP_LOC B
            WHERE B.DIVISION_ID       = T.DIVISION_ID
              AND B.PROJECT_CODE      = T.PROJECT_CODE
              AND B.SCM_SITE_ID       = T.SCM_SITE_ID
              AND B.ITEM_ID           = T.ITEM_ID
              AND B.DOM_EXP           = T.DOM_EXP
              AND B.FCST_TYPE         = T.FCST_TYPE
              AND B.INCOTERMS         = T.INCOTERMS
              AND B.MEASURE           = T.MEASURE
              AND B.PLANT_SITE_ID     = T.PLANT_SITE_ID
              AND B.CELL_PROD_SITE_ID = T.CELL_PROD_SITE_ID
              AND B.YYYYMMDD          = T.YYYYMMDD
        );

        /* DELETE_SEQ 8 : DM_PLN_SALES_ETC_PLAN — Catch_Up 3종 */
        DELETE
        FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_CUR_MONDAY
          AND MEASURE IN
          ('SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up');

        /* DELETE_SEQ 9 : DM_PLN_SALES_ETC_PLAN — KRW/USD + FCST_TYPE = ETC */
        DELETE
        FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_CUR_MONDAY
          AND MEASURE IN ('SalesAmt_KRW','SalesAmt_USD')
          AND FCST_TYPE = 'ETC';

        /* 40 전용: SALES_PLAN_RESULT 환율 재계산 범위 */
        IF @P_DIVISION_ID = '40'
        BEGIN
            /* DELETE_SEQ 10 : DM_PLN_SALES_PLAN_RESULT 환율 재계산 (40 전용) */
            DELETE
            FROM dbo.DM_PLN_SALES_PLAN_RESULT
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND MEASURE IN ('SalesAmt_KRW','MKT_AMT_KRW')
              AND YYYYMMDD >= @V_START_YYYYMMDD
              AND YYYYMMDD <  @V_END_YYYYMMDD;
        END;

        /* LATEST Measure DELETE: 40 / 81 계열 / 82 MF_W·SF_W 공통 */
        IF (@P_DIVISION_ID IN ('40','82') OR @P_DIVISION_ID LIKE '81%')
           AND @P_VER_TYPE IN ('MF_W','SF_W')
        BEGIN
            /* DELETE_SEQ 11 : DM_PLN_MKT_FCST LATEST measures (40/81 계열/82 공통) */
            DELETE
            FROM dbo.DM_PLN_MKT_FCST
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND MEASURE IN ('MKT_FCST_LATEST','CUST_FCST_LATEST')
              AND YYYYMMDD >= @V_CUR_MONDAY;
        END;



        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END;