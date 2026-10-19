CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_40_CF_W
(
    @P_DIVISION_ID VARCHAR(20)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @V_PLAN_START_YYYYMMDD CHAR(8);
    DECLARE @V_PREV_WEEK_YYYYMMDD  CHAR(8);
    DECLARE @V_TWO_WEEK_AGO_YYYYMMDD CHAR(8);

    SET @V_PLAN_START_YYYYMMDD =
        CONVERT(
            CHAR(8),
            DATEADD(DAY, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')),
            112
        );

    SET @V_PREV_WEEK_YYYYMMDD =
        CONVERT(
            CHAR(8),
            DATEADD(DAY, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')),
            112
        );

    SET @V_TWO_WEEK_AGO_YYYYMMDD =
        CONVERT(
            CHAR(8),
            DATEADD(DAY, -14, dbo.FN_NEXT_DAY(GETDATE(), 'MON')),
            112
        );

    BEGIN TRY
        BEGIN TRAN;

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD
          AND MEASURE IN ('MKT_FCST', 'SCM_FCST', 'VMI_IN_REQ');

        DELETE
        FROM dbo.DM_PLN_MKT_FCST
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND QTY = 0;

        DELETE
        FROM dbo.SCM_MST_FUTURE_PRICE
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_PLAN_START_YYYYMMDD;

        DELETE
        FROM dbo.DM_PLN_CFM_MKT_DEMAND_PLAN
        WHERE DIVISION_ID = @P_DIVISION_ID
          AND YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND QTY = 0;

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

        DELETE L
        FROM dbo.DM_PLN_SALES_PLAN_RESULT L
        WHERE L.DIVISION_ID LIKE @P_DIVISION_ID + '%'
          AND L.YYYYMMDD <  @V_PREV_WEEK_YYYYMMDD
          AND L.YYYYMMDD >= @V_TWO_WEEK_AGO_YYYYMMDD
          AND L.MEASURE IN
          (
              'MKT_FCST',
              'CUST_FCST',
              'RTF_SYS_RP',
              'TMM_FCST'
          );

        COMMIT TRAN;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRAN;
        THROW;
    END CATCH
END;

