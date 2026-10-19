---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
* Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM_CURR
* Description  : RTF 준수율 Weekly Summary By Current Date
* Program History
*===================================================================================================
*  Date        In Charge    Version   Description
*===================================================================================================
* 2022.12.13	chaan       V1.0.0    Inititialize
* 2023.02.01	chaan       V1.0.1    집계 기간을 파라미터 날짜가 속한 주차기준에서 변경(전월 1일 속한 주차 ~ 현재일자 - 전주차)
**************************************************************************************************
*/

--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM_CURR]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM_CURR]
      @p_division_id              NVARCHAR(30)      = ''    -- 빈 값이면 전체 사업부 대상
    , @p_yyyymmdd                 NVARCHAR(8)       = ''    -- 빈 값이면 현재 날짜 기준 (ex.. 전체 사업부 대상 & 현재 날짜 기준이면 파라미터 없이 호출 -> 'exec SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM_CURR'
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON;


    --DECLARE @p_division_id              NVARCHAR(30)        = '81';
    --DECLARE @p_yyyymmdd                 NVARCHAR(8)         = '20230131';


    IF (@p_yyyymmdd = '') OR (@p_yyyymmdd IS NULL) -- 날짜 파라미터가 널이면 현재 날짜 기준
    BEGIN
        SET @p_yyyymmdd = CONVERT(NVARCHAR(8), GETDATE(), 112);
    END

    DECLARE @V_FROM_YYYYMMDD            NVARCHAR(8)         = '';
    DECLARE @V_TO_YYYYMMDD              NVARCHAR(8)         = '';
    DECLARE @V_CURR_YYYYWW              NVARCHAR(6)         = '';

    SET @V_FROM_YYYYMMDD = SUBSTRING(CONVERT(NVARCHAR(8), DATEADD(MONTH, -1, CONVERT(DATE, @p_yyyymmdd)), 112), 1, 6) + '01'
    SET @V_TO_YYYYMMDD   = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(CONVERT(DATE, @p_yyyymmdd), 'SUN')), 112);

    SELECT  @V_CURR_YYYYWW = C.ISO_YYYYWW
    FROM    SCM_SYS_CALENDAR_M C WITH(NOLOCK)
    WHERE   C.BASIS_YYYYMMDD = @p_yyyymmdd


    print N'현재 날짜';
    print '  @p_yyyymmdd : ' + @p_yyyymmdd;
    print N'현재 주차';
    print '  @V_CURR_YYYYWW : ' + @V_CURR_YYYYWW;

    print N'현재 날짜 기준, 전월 1일이 속한 주차부터';
    print '  @V_FROM_YYYYMMDD : ' + @V_FROM_YYYYMMDD;
    print N'현재 날짜 기준, 전주차까지';
    print '  @V_TO_YYYYMMDD : ' + @V_TO_YYYYMMDD;

    DECLARE @V_YYYYWW                   NVARCHAR(6)     = '';
    DECLARE @V_YYYY                     NVARCHAR(4)     = '';
    DECLARE @V_WW                       NVARCHAR(2)     = '';

    IF OBJECT_ID (N'tempdb..#T_WEEKS', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS

    SELECT DISTINCT
            C.ISO_YYYYWW
    INTO    #T_WEEKS
    FROM    SCM_SYS_CALENDAR_M C WITH(NOLOCK)
    WHERE   C.BASIS_YYYYMMDD >= @V_FROM_YYYYMMDD
        AND C.BASIS_YYYYMMDD <= @V_TO_YYYYMMDD
    ORDER BY C.ISO_YYYYWW


    DECLARE CUR_WEEKS CURSOR FOR
    SELECT    *
    FROM    #T_WEEKS

    OPEN CUR_WEEKS;

    FETCH NEXT FROM CUR_WEEKS INTO
          @V_YYYYWW

    print N'********************기간내 주차별 집계 begin****************************************************************************************************';
    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @V_YYYY     = SUBSTRING(@V_YYYYWW, 1, 4)
        SET @V_WW       = SUBSTRING(@V_YYYYWW, 5, 2)

        print '@V_YYYYWW : ' + @V_YYYYWW;

        IF (@p_division_id = '') OR (@p_division_id IS NULL)
        BEGIN
            exec SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM '82', @V_YYYY, @V_WW;
            exec SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM '81', @V_YYYY, @V_WW;
            exec SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM '40', @V_YYYY, @V_WW;
        END
        ELSE
        BEGIN
            exec SCP0092_GET_RTF_ARCHEIVEMENT_RATE_WEEKLY_SUM @p_division_id, @V_YYYY, @V_WW;
        END

        FETCH NEXT FROM CUR_WEEKS INTO
          @V_YYYYWW
    END;

    CLOSE CUR_WEEKS;
    DEALLOCATE CUR_WEEKS;
    print N'********************기간내 주차별 집계 end****************************************************************************************************';


    IF OBJECT_ID (N'tempdb..#T_WEEKS', N'U') IS NOT NULL
	    DROP TABLE #T_WEEKS
END
