
-- PR_ETL_SYNC_DELETE_SCP_FINAL.sql
/* ============================================================
   SCP_FINAL — 40 / 81 계열 / 82 공통 프로시저

   - 구조 공통화 구현 완료.
   - FINAL ITEM / RTF Exception 보호조건 복원 완료 (Oracle SCP 원본 키 대조 완료)
       * SCM_MST_FINAL_ITEM_V NOT EXISTS  (공통 RTF 계열 DELETE, 두 테이블)
           조인: F.DIVISION_ID = T.DIVISION_ID, F.ITEM_ID = T.ITEM_ID
           필터: F.OPERATION_GROUP_ID = 'E', F.DIVISION_ID LIKE '40%'
           (PROJECT_CODE / SCM_SITE_ID 는 조인키 아님)
       * #RTF_EXCEPTION_ITEM NOT EXISTS  (공통 RTF 계열 DELETE + 40 RMA DELETE)
           DM_PLN_MKT_FCST            : 9키 (DIVISION_ID~PLANT_SITE_ID), CELL_PROD_SITE_ID 매칭 없음
           DM_PLN_CFM_MKT_DEMAND_PLAN : 9키 + CASE(WHEN T.DIVISION_ID='40' THEN ISNULL(T.CELL_PROD_SITE_ID,'-') ELSE '-') = ISNULL(E.CELL_PROD_SITE_ID,'-')
       * #RTF_EXCEPTION_ITEM 은 @V_SP_CUTOFF_FLAG = 'Y' 일 때만 채운다.
   - GT_PRDM2_RESULTS / GT_PRDM2_TEMPX 기반 VMI_Inv / VMI_DIO / BALANCE 등의
     구간 DELETE 단순화 안전성은 pending. 원본 선택 로직은 복원하지 않았다.

   [DELETE 사전 백업 — 제거됨]
   - 이 프로시저는 백업 없이 DELETE 만 수행한다.
   - 백업(OUTPUT deleted.* INTO bak.BK_*) 포함 버전은
     동일 로직의 dbo.PR_ETL_SYNC_DELETE_SCP_FINAL_BK 를 사용한다.
   ============================================================ */

CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_SCP_FINAL
(
      @P_DIVISION_ID VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @V_PLAN_START_YYYYMMDD CHAR(8);
    DECLARE @V_SP_CUTOFF_FLAG      CHAR(1);

    SET @V_PLAN_START_YYYYMMDD =
        CONVERT(CHAR(8), DATEADD(DAY, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

    /* ---- CUTOFF FLAG 내부 계산 ---- */
    IF @P_DIVISION_ID = '40' OR @P_DIVISION_ID LIKE '81%'
    BEGIN
        IF EXISTS
        (
            SELECT 1
            FROM dbo.DM_MST_VERSION
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND VERSION_TYPE = 'SP_W'
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
        )
            SET @V_SP_CUTOFF_FLAG = 'Y';
        ELSE
            SET @V_SP_CUTOFF_FLAG = 'N';
    END
    ELSE
    BEGIN
        SET @V_SP_CUTOFF_FLAG = 'N';   /* 82 */
    END;

    BEGIN TRY
        BEGIN TRAN;

        /* ============================================================
           1. RTF Exception 임시테이블
              @V_SP_CUTOFF_FLAG = 'Y' 일 때만 채운다. (82는 'N' 고정 → 미실행)
              40   : DM_PLN_CFM_MKT_DEMAND_PLAN 소스, CELL_PROD_SITE_ID 실제 값
              40 외: DM_PLN_MKT_FCST 소스, CELL_PROD_SITE_ID = '-' 고정
                     (DM_PLN_MKT_FCST 에 CELL_PROD_SITE_ID 컬럼 없음)
              RTF_PR 추가 INSERT 도 동일한 사업부별 소스 분기를 따른다.
           ============================================================ */

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

        IF @V_SP_CUTOFF_FLAG = 'Y'
        BEGIN
            IF @P_DIVISION_ID = '40'
            BEGIN
                /* 40: DM_PLN_CFM_MKT_DEMAND_PLAN 기준, CELL_PROD_SITE_ID 실제 값 */
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
                WHERE A.DIVISION_ID = @P_DIVISION_ID
                  AND A.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                  AND CONVERT(CHAR(8), A.LAST_UPDATE_DATE, 112) >= @V_PLAN_START_YYYYMMDD
                  AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
                  AND A.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
                GROUP BY
                      A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                      A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                      A.PLANT_SITE_ID, A.CELL_PROD_SITE_ID;

                /* RTF_PR : 기존 Exception 과 조인하여 추가 (40: CFM 소스) */
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
            END
            ELSE
            BEGIN
                /* 40 외: DM_PLN_MKT_FCST 기준, CELL_PROD_SITE_ID = '-' 고정
                   (DM_PLN_MKT_FCST 에는 CELL_PROD_SITE_ID 컬럼이 없어 실제 컬럼 참조 금지) */
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
                    , '-' AS CELL_PROD_SITE_ID
                FROM dbo.DM_PLN_MKT_FCST A
                WHERE A.DIVISION_ID = @P_DIVISION_ID
                  AND A.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
                  AND CONVERT(CHAR(8), A.LAST_UPDATE_DATE, 112) >= @V_PLAN_START_YYYYMMDD
                  AND A.MEASURE IN ('RTF_SYS_RP','RTF','RTF_SCP')
                  AND A.LAST_UPDATED_BY NOT IN ('SYSTEM','CUTOFF')
                GROUP BY
                      A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                      A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                      A.PLANT_SITE_ID;

                /* RTF_PR : 기존 Exception 과 조인하여 추가 (40 외: MKT_FCST 소스, '-' 고정) */
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
                    , '-' AS CELL_PROD_SITE_ID
                FROM dbo.DM_PLN_MKT_FCST A
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
                        AND B.CELL_PROD_SITE_ID = '-'
                  )
                GROUP BY
                      A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID,
                      A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE,
                      A.PLANT_SITE_ID;
            END
        END;

        /* ============================================================
           2. 완전 공통 — RTF 계열 DELETE (FCST_TYPE <> 'RMA')
              FINAL ITEM / RTF Exception 보호조건 적용
              대상: DM_PLN_MKT_FCST / DM_PLN_CFM_MKT_DEMAND_PLAN
           ============================================================ */

        /* DELETE_SEQ 1 : DM_PLN_MKT_FCST 공통 RTF 계열 non-RMA + 보호조건 */
        DELETE T
        FROM dbo.DM_PLN_MKT_FCST T
        WHERE T.DIVISION_ID = @P_DIVISION_ID
          AND T.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND T.FCST_TYPE <> 'RMA'
          AND T.MEASURE IN
          ('RTF_SYS_RP','RTF_SCP','RTF','VMI_In_Plan','AS_In_Plan','RTF_PR')
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.SCM_MST_FINAL_ITEM_V F
              WHERE F.DIVISION_ID          = T.DIVISION_ID
                AND F.ITEM_ID              = T.ITEM_ID
                AND F.OPERATION_GROUP_ID   = 'E'
                AND F.DIVISION_ID LIKE '40%'
          )
          AND NOT EXISTS
          (
              SELECT 1
              FROM #RTF_EXCEPTION_ITEM E
              WHERE E.DIVISION_ID       = T.DIVISION_ID
                AND E.PROJECT_CODE      = T.PROJECT_CODE
                AND E.SCM_SITE_ID       = T.SCM_SITE_ID
                AND E.ITEM_ID           = T.ITEM_ID
                AND E.DOM_EXP           = T.DOM_EXP
                AND E.FCST_TYPE         = T.FCST_TYPE
                AND E.INCOTERMS         = T.INCOTERMS
                AND E.MEASURE           = T.MEASURE
                AND E.PLANT_SITE_ID     = T.PLANT_SITE_ID
          );

        /* DELETE_SEQ 2 : DM_PLN_CFM_MKT_DEMAND_PLAN 공통 RTF 계열 non-RMA + 보호조건 */
        DELETE T
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN T
        WHERE T.DIVISION_ID = @P_DIVISION_ID
          AND T.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND T.FCST_TYPE <> 'RMA'
          AND T.MEASURE IN
          ('RTF_SYS_RP','RTF_SCP','RTF','VMI_In_Plan','AS_In_Plan','RTF_PR')
          AND NOT EXISTS
          (
              SELECT 1
              FROM dbo.SCM_MST_FINAL_ITEM_V F
              WHERE F.DIVISION_ID          = T.DIVISION_ID
                AND F.ITEM_ID              = T.ITEM_ID
                AND F.OPERATION_GROUP_ID   = 'E'
                AND F.DIVISION_ID LIKE '40%'
          )
          AND NOT EXISTS
          (
              SELECT 1
              FROM #RTF_EXCEPTION_ITEM E
              WHERE E.DIVISION_ID       = T.DIVISION_ID
                AND E.PROJECT_CODE      = T.PROJECT_CODE
                AND E.SCM_SITE_ID       = T.SCM_SITE_ID
                AND E.ITEM_ID           = T.ITEM_ID
                AND E.DOM_EXP           = T.DOM_EXP
                AND E.FCST_TYPE         = T.FCST_TYPE
                AND E.INCOTERMS         = T.INCOTERMS
                AND E.MEASURE           = T.MEASURE
                AND E.PLANT_SITE_ID     = T.PLANT_SITE_ID
                AND CASE
                        WHEN T.DIVISION_ID = '40'
                        THEN ISNULL(T.CELL_PROD_SITE_ID, '-')
                        ELSE '-'
                    END = ISNULL(E.CELL_PROD_SITE_ID, '-')
          );

        /* ============================================================
           3. 40 전용 — RMA DELETE
              SCM_MST_FINAL_ITEM_V 조건 없음 (#RTF_EXCEPTION_ITEM 만)
           ============================================================ */

        IF @P_DIVISION_ID = '40'
        BEGIN
            /* DELETE_SEQ 3 : DM_PLN_MKT_FCST 40 RMA */
            DELETE T
            FROM dbo.DM_PLN_MKT_FCST T
            WHERE T.DIVISION_ID = '40'
              AND T.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND T.FCST_TYPE = 'RMA'
              AND T.MEASURE IN ('RTF_SYS_RP','RTF_SCP','RTF_PR')
              AND NOT EXISTS
              (
                  SELECT 1
                  FROM #RTF_EXCEPTION_ITEM E
                  WHERE E.DIVISION_ID       = T.DIVISION_ID
                    AND E.PROJECT_CODE      = T.PROJECT_CODE
                    AND E.SCM_SITE_ID       = T.SCM_SITE_ID
                    AND E.ITEM_ID           = T.ITEM_ID
                    AND E.DOM_EXP           = T.DOM_EXP
                    AND E.FCST_TYPE         = T.FCST_TYPE
                    AND E.INCOTERMS         = T.INCOTERMS
                    AND E.MEASURE           = T.MEASURE
                    AND E.PLANT_SITE_ID     = T.PLANT_SITE_ID
              );

            /* DELETE_SEQ 4 : DM_PLN_CFM_MKT_DEMAND_PLAN 40 RMA */
            DELETE T
            FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN T
            WHERE T.DIVISION_ID = '40'
              AND T.YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND T.FCST_TYPE = 'RMA'
              AND T.MEASURE IN ('RTF_SYS_RP','RTF_SCP','RTF_PR')
              AND NOT EXISTS
              (
                  SELECT 1
                  FROM #RTF_EXCEPTION_ITEM E
                  WHERE E.DIVISION_ID       = T.DIVISION_ID
                    AND E.PROJECT_CODE      = T.PROJECT_CODE
                    AND E.SCM_SITE_ID       = T.SCM_SITE_ID
                    AND E.ITEM_ID           = T.ITEM_ID
                    AND E.DOM_EXP           = T.DOM_EXP
                    AND E.FCST_TYPE         = T.FCST_TYPE
                    AND E.INCOTERMS         = T.INCOTERMS
                    AND E.MEASURE           = T.MEASURE
                    AND E.PLANT_SITE_ID     = T.PLANT_SITE_ID
                    AND CASE
                            WHEN T.DIVISION_ID = '40'
                            THEN ISNULL(T.CELL_PROD_SITE_ID, '-')
                            ELSE '-'
                        END = ISNULL(E.CELL_PROD_SITE_ID, '-')
              );
        END;

        /* ============================================================
           4. 82 전용 — RTF DELETE
           ============================================================ */

        IF @P_DIVISION_ID = '82'
        BEGIN
            /* DELETE_SEQ 5 : DM_PLN_MKT_FCST 82 RTF */
            DELETE
            FROM dbo.DM_PLN_MKT_FCST
            WHERE DIVISION_ID = '82'
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE = 'RTF'
              AND FCST_TYPE <> 'RMA';

            /* DELETE_SEQ 6 : DM_PLN_CFM_MKT_DEMAND_PLAN 82 RTF */
            DELETE
            FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
            WHERE DIVISION_ID = '82'
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE = 'RTF'
              AND FCST_TYPE <> 'RMA';
        END;

        /* ============================================================
           5. 81 계열 전용 — SS_LVL / SS_GAP DELETE
           ============================================================ */

        IF @P_DIVISION_ID LIKE '81%'
        BEGIN
            /* DELETE_SEQ 7 : DM_PLN_MKT_FCST SS_LVL / SS_GAP */
            DELETE
            FROM dbo.DM_PLN_MKT_FCST
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE IN ('SS_LVL','SS_GAP');

            /* DELETE_SEQ 8 : DM_PLN_CFM_MKT_DEMAND_PLAN SS_LVL / SS_GAP */
            DELETE
            FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE IN ('SS_LVL','SS_GAP');
        END;

        /* ============================================================
           6. GT_PRDM2_RESULTS / GT_PRDM2_TEMPX 계열 — 단순화 pending
              VMI_Inv / VMI_DIO / BALANCE / AS_SHIP_PLAN / AS_Inv
              원본 선택 로직(GT_PRDM2_RESULTS / GT_PRDM2_TEMPX)은 복원하지 않음.
              현행 구간 DELETE 유지. 단순화 안전성 확정되지 않음(pending).
           ============================================================ */

        /* DELETE_SEQ 9 : DM_PLN_MKT_FCST GT_PRDM2 계열 구간 */
        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('VMI_Inv','AS_SHIP_PLAN','AS_Inv','BALANCE');

        /* DELETE_SEQ 10 : DM_PLN_CFM_MKT_DEMAND_PLAN GT_PRDM2 계열 구간 */
        DELETE
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('VMI_Inv','AS_SHIP_PLAN','AS_Inv','VMI_DIO');

        /* SIMPLE_DELETE_PATCH_20261007 BEGIN: 기존 삭제문·변수 유지, 하위 조회가 끝난 뒤 추가 */
        /* ADD17 / DELETE_SEQ 11: PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW L572.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81')
        BEGIN
        DELETE FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('SalesAmt_KRW', 'SalesAmt_USD')
          AND FCST_TYPE = 'ETC';
        END;

        /* ADD18 / DELETE_SEQ 12: PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW L532.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81')
        BEGIN
        DELETE FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up');
        END;

        /* ADD19 / DELETE_SEQ 13: PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW L717.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40')
        BEGIN
        DELETE FROM dbo.DM_PLN_SALES_PLAN_RESULT
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= CONVERT(CHAR(6),GETDATE(),112)+'01'
          AND YYYYMMDD < CONVERT(CHAR(8),GETDATE(),112)
          AND MEASURE IN ('SalesAmt_KRW', 'MKT_AMT_KRW');
        END;
        /* SIMPLE_DELETE_PATCH_20261007 END */

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END;