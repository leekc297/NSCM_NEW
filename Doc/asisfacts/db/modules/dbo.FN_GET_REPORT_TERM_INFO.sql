
/*
 * Program ID   : FN_GET_REPORT_TERM_INFO
 * Description  : 계획일자, 기간시작일자, 기간종료일자에 해당하는 계획, 실적 기간정보 생성
 * Program History
 *================================================================================================================================================
 *   Date       In Charge                           Description
 *================================================================================================================================================
 * 2023/01/24   chaan         V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 *================================================================================================================================================
 */
--CREATE FUNCTION [dbo].[FN_GET_REPORT_TERM_INFO]
CREATE FUNCTION [dbo].[FN_GET_REPORT_TERM_INFO]
(
      @p_plan_start_yyyymmdd    NVARCHAR(8)
    , @p_from_yyyymmdd          NVARCHAR(8)
    , @p_to_yyyymmdd            NVARCHAR(8)
)
 RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
	  PLAN_FROM_YYYYMMDD       NVARCHAR(8)
	, PLAN_TO_YYYYMMDD         NVARCHAR(8)
	, PLAN_FROM_YYYYMM         NVARCHAR(8)
	, PLAN_TO_YYYYMM           NVARCHAR(8)
	, RESULT_FROM_YYYYMMDD     NVARCHAR(8)
	, RESULT_TO_YYYYMMDD       NVARCHAR(8)
	, PLAN_PARTIAL_FROM_WW     NVARCHAR(8)
	, PLAN_PARTIAL_TO_WW       NVARCHAR(8)
	, PLAN_ISO_FROM_WW         NVARCHAR(8)
	, PLAN_ISOL_TO_WW          NVARCHAR(8)
)
--AS
BEGIN
    --DECLARE @p_plan_start_yyyymmdd      NVARCHAR(8)     = N'20231127';
    --DECLARE @p_from_yyyymmdd            NVARCHAR(8)     = N'20230101';
    --DECLARE @p_to_yyyymmdd              NVARCHAR(8)     = N'20231231';


    DECLARE @v_plan_from_yyyymmdd       NVARCHAR(8)		= '';
    DECLARE @v_plan_to_yyyymmdd         NVARCHAR(8)     = '';
    DECLARE @v_plan_from_yyyymm         NVARCHAR(8)     = '';
    DECLARE @v_plan_to_yyyymm           NVARCHAR(8)     = '';
    DECLARE @v_result_from_yyyymmdd     NVARCHAR(8)     = '';
    DECLARE @v_result_to_yyyymmdd       NVARCHAR(8)     = '';
    DECLARE @v_plan_from_partial_ww     NVARCHAR(8)		= '';
    DECLARE @v_plan_to_partial_ww       NVARCHAR(8)		= '';
    DECLARE @v_plan_from_iso_ww         NVARCHAR(8)		= '';
    DECLARE @v_plan_to_iso_ww           NVARCHAR(8)		= '';


    SELECT  @v_plan_from_yyyymmdd = C.BASIS_START_DATE
    FROM    [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)
    WHERE   1=1
        AND C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd;

    SELECT  @v_result_from_yyyymmdd = C.BASIS_START_DATE
    FROM    [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)
    WHERE   1=1
        AND C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

    SELECT  @v_result_to_yyyymmdd = C.BASIS_START_DATE
    FROM    [dbo].[SCM_SYS_CALENDAR_M] C WITH(NOLOCK)
    WHERE   1=1
        AND C.BASIS_YYYYMMDD = @p_to_yyyymmdd;


    IF @v_plan_from_yyyymmdd > @v_result_from_yyyymmdd
    BEGIN -- 실적 보여줌
        SET @v_plan_to_yyyymmdd     = @p_to_yyyymmdd;
        SET @v_result_to_yyyymmdd   = @v_plan_from_yyyymmdd;
    END
    ELSE IF @v_plan_from_yyyymmdd <= @v_result_from_yyyymmdd
    BEGIN -- 실적 없음
        SET @v_plan_to_yyyymmdd     = @p_to_yyyymmdd;
        SET @v_result_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime,@p_plan_start_yyyymmdd)), 112);
        SET @v_result_to_yyyymmdd   = CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd)), 112)
    END
    ELSE IF @v_plan_from_yyyymmdd > @v_result_to_yyyymmdd
    BEGIN
        SET @v_plan_from_yyyymmdd   = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
        SET @v_plan_to_yyyymmdd     = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
        SET @v_result_from_yyyymmdd = @p_from_yyyymmdd;
        SET @v_result_to_yyyymmdd   = @p_to_yyyymmdd;
    END
    ELSE IF @v_plan_from_yyyymmdd = @v_result_to_yyyymmdd
    BEGIN
        SET @v_plan_to_yyyymmdd     = @v_plan_from_yyyymmdd
        SET @v_result_from_yyyymmdd = @p_from_yyyymmdd;
        SET @v_result_to_yyyymmdd   = @p_to_yyyymmdd;
    END;

    SET @v_plan_from_yyyymm = SUBSTRING(@p_from_yyyymmdd, 1, 6);
    SET @v_plan_to_yyyymm   = SUBSTRING(@p_to_yyyymmdd, 1, 6);

    SELECT    @v_plan_from_partial_ww   = MIN(WW)
            , @v_plan_to_partial_ww     = MAX(WW)
    FROM
    (
        SELECT  CONCAT(SUBSTRING(ISO_YYYYWW, 1, 4), SUBSTRING(PARTIAL_WEEK_NAME, 2, 3)) AS WW
        FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
        WHERE   1=1
            AND A.BASIS_YYYYMMDD >= @p_from_yyyymmdd
            AND A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
        GROUP BY CONCAT(SUBSTRING(ISO_YYYYWW, 1, 4), SUBSTRING(PARTIAL_WEEK_NAME, 2, 3))
    ) A;

    SELECT    @v_plan_from_iso_ww   = MIN(ISO_YYYYWW)
            , @v_plan_to_iso_ww     = MAX(ISO_YYYYWW)
    FROM
    (
        SELECT  ISO_YYYYWW
        FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
        WHERE   1=1
            AND A.BASIS_YYYYMMDD >= @p_from_yyyymmdd
            AND A.BASIS_YYYYMMDD <= @p_to_yyyymmdd
        GROUP BY ISO_YYYYWW
    ) A;


	INSERT INTO	@TBL_RES
	SELECT	  @v_plan_from_yyyymmdd
			, @v_plan_to_yyyymmdd
			, @v_plan_from_yyyymm
			, @v_plan_to_yyyymm
			, @v_result_from_yyyymmdd
			, @v_result_to_yyyymmdd
			, @v_plan_from_partial_ww
			, @v_plan_to_partial_ww
			, @v_plan_from_iso_ww
			, @v_plan_to_iso_ww;

--TESTING : NOK
--select * from @TBL_RES;return;

	RETURN;
END
