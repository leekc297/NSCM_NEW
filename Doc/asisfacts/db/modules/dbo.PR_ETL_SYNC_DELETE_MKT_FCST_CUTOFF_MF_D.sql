
-- PR_ETL_SYNC_DELETE_MKT_FCST_CUTOFF_MF_D.sql
/* ============================================================
   MKT_FCST_CUTOFF_MF_D — 40 / 81 계열 / 82 공통 프로시저

   - 구조 공통화만 완료. 사업부 분기는 40_MF_D 원형 유지.
   - 구간 DELETE 단순화 안전성은 pending (확정되지 않음):
     * DM_PLN_SALES_PLAN 전량 구간 DELETE 안전성
     * DM_PLN_MKT_FCST / DM_PLN_CFM_MKT_DEMAND_PLAN 의
       RTF Exception / FINAL ITEM / RMA 예외 보존 여부
     * 이관 INSERT가 삭제 범위(DIVISION_ID + YYYYMMDD + MEASURE)를
       완전히 재생성하는지
   - 단순화 로직/예외조건은 이번 공통화에서 변경하지 않는다.
   - VMI_DIO: DM_PLN_CFM_MKT_DEMAND_PLAN 에 대해 사업부 무관 구간 DELETE
     (YYYYMMDD >= @V_PLAN_START_YYYYMMDD) 추가.
     Oracle SCP 원본의 40 전용 GT_PRDM2_RESULTS 선택 로직은 미복원 (pending).
   - BALANCE: DM_PLN_MKT_FCST 에 대해 사업부 무관 구간 DELETE
     (YYYYMMDD >= @V_PLAN_START_YYYYMMDD) 추가.
     추가로 40 전용으로 DM_PLN_CFM_MKT_DEMAND_PLAN 의 BALANCE 도 동일 구간 DELETE.
     Oracle SCP 원본의 GT_PRDM2_RESULTS / GT_PRDM2_TEMPX 선택 로직은 미복원 (pending).

   [DELETE 사전 백업 — 제거됨]
   - 이 프로시저는 백업 없이 DELETE 만 수행한다.
   - 백업(OUTPUT deleted.* INTO bak.BK_*) 포함 버전은
     동일 로직의 dbo.PR_ETL_SYNC_DELETE_MKT_FCST_CUTOFF_MF_D_BK 를 사용한다.
   ============================================================ */

CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_MKT_FCST_CUTOFF_MF_D
(
      @P_DIVISION_ID VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @V_PLAN_START_YYYYMMDD  CHAR(8);
    DECLARE @V_MONTH_START_YYYYMMDD CHAR(8);
    DECLARE @V_TODAY_YYYYMMDD       CHAR(8);

    SET @V_PLAN_START_YYYYMMDD =
        CONVERT(CHAR(8), DATEADD(DAY, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112);

    SET @V_MONTH_START_YYYYMMDD = CONVERT(CHAR(6), GETDATE(), 112) + '01';
    SET @V_TODAY_YYYYMMDD       = CONVERT(CHAR(8), GETDATE(), 112);

    BEGIN TRY
        BEGIN TRAN;

        /* DELETE_SEQ 1 : DM_PLN_SALES_PLAN 전량 구간 */
        DELETE
        FROM dbo.DM_PLN_SALES_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD;

        /* DELETE_SEQ 2 : DM_PLN_SALES_ETC_PLAN Catch_Up / ETC */
        DELETE
        FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND
          (
                MEASURE IN
                ('SalesAmt_KRW_Catch_Up','SalesAmt_LOC_Catch_Up','SalesAmt_USD_Catch_Up')
             OR (MEASURE IN ('SalesAmt_KRW','SalesAmt_USD') AND FCST_TYPE = 'ETC')
          );

        IF @P_DIVISION_ID = '40'
        BEGIN
            /* DELETE_SEQ 3 : DM_PLN_SALES_PLAN_RESULT 환율 재계산 범위 (40 전용) */
            DELETE
            FROM dbo.DM_PLN_SALES_PLAN_RESULT
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND MEASURE IN ('SalesAmt_KRW','MKT_AMT_KRW')
              AND YYYYMMDD >= @V_MONTH_START_YYYYMMDD
              AND YYYYMMDD <  @V_TODAY_YYYYMMDD;
        END;

        /* DELETE_SEQ 4 : DM_PLN_MKT_FCST RTF 계열 7종 */
        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN
          ('RTF_SYS_RP','RTF_SCP','RTF','VMI_In_Plan','AS_In_Plan','RTF_PR','VMI_Inv');

        /* DELETE_SEQ 5 : DM_PLN_CFM_MKT_DEMAND_PLAN RTF 계열 7종 */
        DELETE
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN
          ('RTF_SYS_RP','RTF_SCP','RTF','VMI_In_Plan','AS_In_Plan','RTF_PR','VMI_Inv');

        /* ------------------------------------------------------------
           VMI_DIO — 사업부 무관 구간 DELETE (DM_PLN_CFM_MKT_DEMAND_PLAN)

           Oracle SCP 원본은 40 전용 GT_PRDM2_RESULTS 기반 선택 DELETE
           (동일명 8키 + CELL_PROD_SITE_ID = TO_SITE_ID,
            ATTRIBUTE2 = FROM_SITE_ID, GT_PRDM2_RESULTS.VMI_YN = 'Y')였으나,
           여기서는 사업부 분기 없이 YYYYMMDD >= @V_PLAN_START_YYYYMMDD
           구간 전량 삭제로 처리한다.
           선택 로직(GT_PRDM2_RESULTS)은 복원하지 않음 — 이관 INSERT가
           해당 DIVISION_ID + YYYYMMDD + VMI_DIO 범위를 전량 재생성한다는 전제.
           (DELETE_SEQ 6)
           ------------------------------------------------------------ */

        DELETE
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE = 'VMI_DIO';

        /* ------------------------------------------------------------
           BALANCE — 사업부 무관 구간 DELETE (DM_PLN_MKT_FCST)
           (DELETE_SEQ 7)
           ------------------------------------------------------------ */

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE = 'BALANCE';

        /* ------------------------------------------------------------
           BALANCE — 40 전용 구간 DELETE (DM_PLN_CFM_MKT_DEMAND_PLAN)
           (DELETE_SEQ 8)
           ------------------------------------------------------------ */

        IF @P_DIVISION_ID = '40'
        BEGIN
            DELETE
            FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE = 'BALANCE';
        END;

        IF @P_DIVISION_ID LIKE '81%'
        BEGIN
            /* DELETE_SEQ 9 : DM_PLN_MKT_FCST SS_LVL / SS_GAP (81 계열 전용) */
            DELETE
            FROM dbo.DM_PLN_MKT_FCST
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE IN ('SS_LVL','SS_GAP');

            /* DELETE_SEQ 10 : DM_PLN_CFM_MKT_DEMAND_PLAN SS_LVL / SS_GAP (81 계열 전용) */
            DELETE
            FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
            WHERE DIVISION_ID = @P_DIVISION_ID
              AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
              AND MEASURE IN ('SS_LVL','SS_GAP');
        END;

        /* SIMPLE_DELETE_PATCH_20261007 BEGIN: 기존 삭제문·변수 유지, 하위 조회가 끝난 뒤 추가 */
        /* ADD12 / DELETE_SEQ 11: PR_DM_DNM_CREATE_WS_RTF L152; PR_DM_DNM_CREATE_WS_RTF L159.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82')
        BEGIN
        DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND CREATED_BY = 'SYSTEM_WS'
          AND MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');
        END;

        /* ADD13 / DELETE_SEQ 12: PR_DM_DNM_CREATE_WS_RTF L132; PR_DM_DNM_CREATE_WS_RTF L139.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC', '82')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND CREATED_BY = 'SYSTEM_WS'
          AND MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');
        END;

        /* ADD14 / DELETE_SEQ 13: PR_DM_PLN_CFM_TO_MKT_FCST_ALL L52.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');
        END;

        /* ADD15 / DELETE_SEQ 14: PR_DM_PLN_MKT_FCST_LASTEST_MEASURE L74.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('82')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('MKT_FCST_LATEST', 'CUST_FCST_LATEST');
        END;

        /* ADD16 / DELETE_SEQ 15: PR_DM_PLN_CFM_TO_MKT_FCST_ALL L72.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40')
        BEGIN
        DELETE FROM dbo.SCM_MST_FUTURE_PRICE
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD;
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