CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_82_VMI_REFRESH
(
    @P_DIVISION_ID VARCHAR(10)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @V_MONDAY CHAR(8);

    /* 금주 월요일 */
    SET @V_MONDAY =
        CONVERT
        (
            CHAR(8),
            DATEADD
            (
                DAY,
                -7,
                dbo.FN_NEXT_DAY(GETDATE(), 'MON')
            ),
            112
        );

    BEGIN TRY
        BEGIN TRAN;

        /* ============================================
           82 / VMI_REFRESH
           금주 월요일 이후 VMI_In_Req 전체 삭제
           ============================================ */

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND MEASURE = 'VMI_In_Req'
          AND YYYYMMDD >= @V_MONDAY;

        COMMIT TRAN;

    END TRY
    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;

        THROW;

    END CATCH;
END;
