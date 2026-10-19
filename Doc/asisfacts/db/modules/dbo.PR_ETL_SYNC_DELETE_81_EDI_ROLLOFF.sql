CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_81_EDI_ROLLOFF
(
      @P_DIVISION_ID VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;


    DECLARE @V_TODAY        CHAR(8);
    DECLARE @V_WEEK_MONDAY  CHAR(8);

    /* 오늘 */
    SET @V_TODAY =
        CONVERT(CHAR(8), GETDATE(), 112);

    /* 금주 월요일 */
    SET @V_WEEK_MONDAY =
        CONVERT(
            CHAR(8),
            DATEADD(
                DAY,
                -7,
                dbo.FN_NEXT_DAY(GETDATE(), 'MON')
            ),
            112
        );


    BEGIN TRY
        BEGIN TRAN;


        /* ============================================================
           1. 일반 EDI
              오늘 이후 재이관 대상 삭제
           ============================================================ */

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_TODAY
          AND MEASURE IN
          (
              'CUST_FCST_EDI',
              'Immediate',
              'Planning_Forecast',
              'Commercial_Agreement',
              'Firm_Temp',
              'Manufacturing_Material_Temp',
              'Material_Temp',
              'Backorder'
          );


        /* ============================================================
           2. EDI ORG
              금주 월요일 이후 재이관 대상 삭제

              기존 Oracle의 GT_DDECM_EDI_MKT_FCST_ORG
              EXISTS / MIN(BASIS_YYYYMMDD) 조건은 제거
           ============================================================ */

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_WEEK_MONDAY
          AND MEASURE IN
          (
              'CUST_FCST_EDI_ORG',
              'Immediate[Org.]',
              'Planning_Forecast[Org.]',
              'Commercial_Agreement[Org.]',
              'Firm_Temp[Org.]',
              'Manufacturing_Material_Temp[Org.]',
              'Material_Temp[Org.]',
              'Backorder[Org.]'
          );


        /* SIMPLE_DELETE_PATCH_20261007 BEGIN: 기존 삭제문·변수 유지, 하위 조회가 끝난 뒤 추가 */
        /* ADD01 / DELETE_SEQ 3: PR_DM_PLN_MKT_FCST_MAKE_CUST_FCST L104.
           같은 업무 기준일, Oracle 처리 완료 후 해당 구간 최종 잔존 행 전량 LUD 추출 필요. */
        IF @P_DIVISION_ID IN ('81', '81_HD', '81_HG', '81_HM', '81_ST', '81_UC')
        BEGIN
        DELETE FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_WEEK_MONDAY
          AND MEASURE = 'CUST_FCST';
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