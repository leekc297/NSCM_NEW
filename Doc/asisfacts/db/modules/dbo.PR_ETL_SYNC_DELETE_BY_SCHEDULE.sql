CREATE   PROCEDURE dbo.PR_ETL_SYNC_DELETE_BY_SCHEDULE
(
      @P_DIVISION_ID VARCHAR(10)
    , @P_JOB_CODE    VARCHAR(50)
)
AS
BEGIN
    SET NOCOUNT ON;


    /* ==========================================
        40 사업부
    ========================================== */
    IF @P_DIVISION_ID = '40'
    BEGIN

        IF @P_JOB_CODE = 'CF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_40_CF_W
                @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'SALES_ACT_01_MF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_SALES_ACT_01
                @P_DIVISION_ID = @P_DIVISION_ID;
        END

        /* MF_W */
        ELSE IF @P_JOB_CODE = 'MKT_FCST_CUTOFF_MF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
                @P_DIVISION_ID = @P_DIVISION_ID
                , @P_VER_TYPE    = 'MF_W';
        END

        /* SF_W */
        ELSE IF @P_JOB_CODE = 'SCM_FCST_CUTOFF_SF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
                @P_DIVISION_ID = @P_DIVISION_ID
                , @P_VER_TYPE    = 'SF_W';
        END

        /* MF_D */
        ELSE IF @P_JOB_CODE = 'MKT_FCST_CUTOFF_MF_D'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_MKT_FCST_CUTOFF_MF_D
                @P_DIVISION_ID = @P_DIVISION_ID;
        END

        /* SCP */
        ELSE IF @P_JOB_CODE = 'SCP_FINAL'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_SCP_FINAL
                @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE
        BEGIN
            THROW 50001, '40 사업부에 정의되지 않은 JOB_CODE입니다.', 1;
        END

    END


    /* ==========================================
       82 사업부
       ========================================== */
    ELSE IF @P_DIVISION_ID = '82'
    BEGIN

        IF @P_JOB_CODE = 'CF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_CF_W
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'VMI_REFRESH'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_82_VMI_REFRESH
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'SALES_ACT_01'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_SALES_ACT_01
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'MKT_FCST_CUTOFF_MF_D'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_MKT_FCST_CUTOFF_MF_D
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'SCP_FINAL'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_SCP_FINAL
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'MKT_FCST_CUTOFF_MF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
                 @P_DIVISION_ID = @P_DIVISION_ID
                 , @P_VER_TYPE    = 'MF_W';
        END

        ELSE IF @P_JOB_CODE = 'SCM_FCST_CUTOFF_SF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
                 @P_DIVISION_ID = @P_DIVISION_ID
                 , @P_VER_TYPE    = 'SF_W';
        END

        ELSE
        BEGIN
            THROW 50002, '82 사업부에 정의되지 않은 JOB_CODE입니다.', 1;
        END

    END


    /* ==========================================
       81 계열 사업부
       81 / 81_HM / 81_ST / 81_HG / 81_UC / 81_HD
       ========================================== */
    ELSE IF @P_DIVISION_ID IN
    (
          '81'
        , '81_HM'
        , '81_ST'
        , '81_HG'
        , '81_UC'
        , '81_HD'
    )
    BEGIN

        IF @P_JOB_CODE = 'CF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_CF_W
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'EDI_ROLLOFF'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_81_EDI_ROLLOFF
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'SALES_ACT_01'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_SALES_ACT_01
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'MKT_FCST_CUTOFF_MF_D'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_MKT_FCST_CUTOFF_MF_D
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE IF @P_JOB_CODE = 'MKT_FCST_CUTOFF_MF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
                 @P_DIVISION_ID = @P_DIVISION_ID
                 , @P_VER_TYPE    = 'MF_W';
        END

        ELSE IF @P_JOB_CODE = 'SCM_FCST_CUTOFF_SF_W'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_FCST_CUTOFF
                 @P_DIVISION_ID = @P_DIVISION_ID
                 , @P_VER_TYPE    = 'SF_W';
        END

        ELSE IF @P_JOB_CODE = 'SCP_FINAL'
        BEGIN
            EXEC dbo.PR_ETL_SYNC_DELETE_SCP_FINAL
                 @P_DIVISION_ID = @P_DIVISION_ID;
        END

        ELSE
        BEGIN
            THROW 50003, '81 계열 사업부에 정의되지 않은 JOB_CODE입니다.', 1;
        END

    END


    ELSE
    BEGIN
        THROW 50010, '정의되지 않은 DIVISION_ID입니다.', 1;
    END

END;
