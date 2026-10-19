CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_CF_W
(
      @P_DIVISION_ID VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    /* 2026-10-06: 40/81 계열/82 통합. 이 SQL은 배포 후보이며 DB 실행하지 않음.
       Oracle 당주 전체 재생성 + 사업부별 과거 정리를 이관 사업부 단위로 적용.
       CUSTOMER_FCST는 같은 사업부의 당주 최종 결과 전체를 재적재해야 함. */
    IF @P_DIVISION_ID IS NULL OR @P_DIVISION_ID NOT IN
       ('40','81','81_HM','81_ST','81_HG','81_UC','81_HD','82')
        THROW 50010, N'CF_W 지원 사업부가 아닙니다.', 1;
    DECLARE @V_AS_OF DATETIME = GETDATE();
    -- Oracle SYSDATE와 동일한 업무 기준일로 실행. 자정/월초를 넘긴 재이관은 별도 기준일 정합 확인.
    DECLARE @V_START_YYYYMMDD CHAR(8) = LEFT(CONVERT(CHAR(8), @V_AS_OF, 112), 6) + '01';
    DECLARE @V_END_YYYYMMDD CHAR(8) = CONVERT(CHAR(8), @V_AS_OF, 112);
    DECLARE @V_CALENDAR_COUNT INT;
    DECLARE @V_PLAN_WEEK             VARCHAR(20) = NULL;
    DECLARE @V_PREV_WEEK_YYYYMMDD    CHAR(8);
    DECLARE @V_TWO_WEEK_AGO_YYYYMMDD CHAR(8);


    /* 금주 월요일 - 7 */
    SET @V_PREV_WEEK_YYYYMMDD =
        CONVERT(
            CHAR(8),
            DATEADD(
                DAY,
                -7,
                dbo.FN_NEXT_DAY(@V_AS_OF, 'MON')
            ),
            112
        );


    /* 금주 월요일 - 14 */
    SET @V_TWO_WEEK_AGO_YYYYMMDD =
        CONVERT(
            CHAR(8),
            DATEADD(
                DAY,
                -14,
                dbo.FN_NEXT_DAY(@V_AS_OF, 'MON')
            ),
            112
        );


    BEGIN TRY
        BEGIN TRAN;


        /* 공통 CUSTOMER_FCST: 과거 주차 정리 + 당주 재적재 전 삭제.
           Oracle L88~90/L239~244/L400~403의 합집합을 호출 사업부로 분할.
           미래 주차, NULL 주차, 다른 사업부는 삭제하지 않는다. */
        SELECT @V_PLAN_WEEK = MIN(ISO_YYYYWW),
               @V_CALENDAR_COUNT = COUNT(*)
        FROM dbo.SCM_SYS_CALENDAR_M
        WHERE BASIS_YYYYMMDD = CONVERT(CHAR(8), @V_AS_OF, 112);

        IF @V_CALENDAR_COUNT <> 1 OR @V_PLAN_WEEK IS NULL
            THROW 50011, N'기준일 달력이 없거나 중복되거나 PLAN_WEEK가 없습니다.', 1;

        /* DELETE_SEQ 1 : DM_MST_CUSTOMER_FCST - 호출 사업부의 당주/과거 PLAN_WEEK */
        DELETE
        FROM dbo.DM_MST_CUSTOMER_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND PLAN_WEEK <= @V_PLAN_WEEK;


        IF @P_DIVISION_ID = '40'
        BEGIN
        /* DELETE_SEQ 6 : DM_PLN_MKT_FCST - MKT_FCST/SCM_FCST/VMI_IN_REQ, 금주 월요일 이후 */
        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');
        END;

        /* ============================================================
           공통 (40 / 81 / 82)
           2. DM_PLN_MKT_FCST
              2주 전 이후 QTY = 0
           ============================================================ */

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND QTY = 0;


        IF @P_DIVISION_ID = '40'
        BEGIN
        /* DELETE_SEQ 7 : SCM_MST_FUTURE_PRICE - 금주 월요일 이후 (40 전용) */
        DELETE
        FROM dbo.SCM_MST_FUTURE_PRICE
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD;
        END;

        /* ============================================================
           공통 (40 / 81 / 82)
           3. DM_PLN_CFM_MKT_DEMAND_PLAN
              2주 전 이후 QTY = 0
           ============================================================ */

        DELETE
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND QTY = 0;


        /* ============================================================
           공통 (40 / 81 / 82)
           4. DM_PLN_MKT_FCST_RESULT
              전전주 ~ 전주
           ============================================================ */

        DELETE
        FROM dbo.DM_PLN_MKT_FCST_RESULT
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD <  @V_PREV_WEEK_YYYYMMDD
          AND YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND MEASURE NOT IN
          (
              'RTF',
              'BALANCE',
              'VMI_In_Plan',
              'VMI_In_Req',
              'VMI_Inv'
          );


        /* ============================================================
           공통 (40 / 81 / 82)
           5. DM_PLN_SALES_PLAN_RESULT
              전전주 ~ 전주
           ============================================================ */

        DELETE L
        FROM dbo.DM_PLN_SALES_PLAN_RESULT L
        WHERE L.DIVISION_ID LIKE @P_DIVISION_ID + '%'  -- 2026-09-09: 선행 '%' 제거 (비-SARGABLE 스캔 유발 + 81 계열 과다삭제 방지)
          AND L.YYYYMMDD <  @V_PREV_WEEK_YYYYMMDD
          AND L.YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND L.MEASURE IN
          (
              'MKT_FCST',
              'CUST_FCST',
              'RTF_SYS_RP',
              'TMM_FCST'
          );


        /* DELETE_SEQ 8 : DM_PLN_SALES_PLAN_RESULT - 40 당월 금액 2종 재생성
           Oracle PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW L64~65/L722~747.
           재계산 정상 완료 후 같은 범위의 최종 결과 전량을 이관해야 한다. */
        IF @P_DIVISION_ID = '40'
        BEGIN
        DELETE L
        FROM dbo.DM_PLN_SALES_PLAN_RESULT L
        WHERE L.DIVISION_ID = @P_DIVISION_ID
          AND L.MEASURE IN ('SalesAmt_KRW', 'MKT_AMT_KRW')
          AND L.YYYYMMDD >= @V_START_YYYYMMDD
          AND L.YYYYMMDD <  @V_END_YYYYMMDD;
        END;

        /* SIMPLE_DELETE_PATCH_20261007 BEGIN: 기존 삭제문·변수 유지, 하위 조회가 끝난 뒤 추가 */
        /* ADD02 / DELETE_SEQ 9: PR_DM_DNM_CREATE_WS_RTF L152; PR_DM_DNM_CREATE_WS_RTF L159.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81', '81_HM', '81_ST', '81_UC', '82')
        BEGIN
        DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND CREATED_BY = 'SYSTEM_WS'
          AND MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');
        END;

        /* ADD03 / DELETE_SEQ 10: PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE L1814.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('82')
        BEGIN
        DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE = 'RTF' AND FCST_TYPE <> 'RMA';
        END;

        /* ADD04 / DELETE_SEQ 11: PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE L1843.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('81', '81_HM', '81_ST', '81_UC')
        BEGIN
        DELETE FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE IN ('SS_LVL', 'SS_GAP');
        END;

        /* ADD05 / DELETE_SEQ 12: PR_DM_DNM_CREATE_WS_RTF L132; PR_DM_DNM_CREATE_WS_RTF L139.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81', '81_HM', '81_ST', '81_UC', '82')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND CREATED_BY = 'SYSTEM_WS'
          AND MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');
        END;

        /* ADD06 / DELETE_SEQ 13: PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE L1754.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('82')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE = 'RTF' AND FCST_TYPE <> 'RMA';
        END;

        /* ADD07 / DELETE_SEQ 14: PR_DM_PLN_MKT_FCST_QTY_BALANCE_CREATE L1782.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('81', '81_HM', '81_ST', '81_UC')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE IN ('SS_LVL', 'SS_GAP');
        END;

        /* ADD08 / DELETE_SEQ 15: PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW L572.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81', '81_HM', '81_ST', '81_UC', '82')
        BEGIN
        DELETE FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE IN ('SalesAmt_KRW', 'SalesAmt_USD')
          AND FCST_TYPE = 'ETC';
        END;

        /* ADD09 / DELETE_SEQ 16: PR_DM_ANL_SALES_PLAN_AMT_CREATE_LOCAL_KRW L532.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('40', '81', '81_HM', '81_ST', '81_UC', '82')
        BEGIN
        DELETE FROM dbo.DM_PLN_SALES_ETC_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PREV_WEEK_YYYYMMDD
          AND MEASURE IN ('SalesAmt_KRW_Catch_Up', 'SalesAmt_LOC_Catch_Up', 'SalesAmt_USD_Catch_Up');
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