---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM
 * Description  : RTF 준수율 Weekly 조회
 * Program History
 *===================================================================================================
 *  Date        In Charge           Description
*===================================================================================================
* 2022.11.15    chaan       V1.0.1  Inititialize
* 2023.01.19    chaan       V1.0.2  그해 마지막주의 THIS_ISO_YYYYWW 산출시 전주로 조회되는 오류 수정
**************************************************************************************************
*/
 
--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM]
(
      @p_division_id              NVARCHAR(30)
    , @p_year                     NVARCHAR(4)
)
AS
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON; 


   --DECLARE @p_division_id              NVARCHAR(30)       = N'82';  
   --DECLARE @p_year                     NVARCHAR(4)        = N'2022';


   DECLARE @V_WHOLE_FROM_YYYYMMDD            NVARCHAR(8)        = N'';
   DECLARE @V_WHOLE_TO_YYYYMMDD              NVARCHAR(8)        = N'';
   DECLARE @V_WHOLE_PRE_YYYYMM               NVARCHAR(6)        = N'';
   DECLARE @V_WHOLE_POST_YYYYMM              NVARCHAR(6)        = N'';
   DECLARE @V_WHOLE_THIS_MONDAY              NVARCHAR(8)        = N'';
   DECLARE @V_WHOLE_NEXT_MONDAY              NVARCHAR(8)        = N'';
   DECLARE @V_WHOLE_LAST_SUNDAY              NVARCHAR(8)        = N'';
   DECLARE @V_WHOLE_NEXT_SUNDAY              NVARCHAR(8)        = N'';
   DECLARE @V_WHOLE_PRE_FROM_YYYYMMDD        NVARCHAR(8)        = N'';

    SET @V_WHOLE_FROM_YYYYMMDD            = '';
    SET @V_WHOLE_TO_YYYYMMDD              = '';
    SET @V_WHOLE_PRE_YYYYMM               = @p_year + '01';
    SET @V_WHOLE_POST_YYYYMM              = @p_year + '12';

    
    SELECT    @V_WHOLE_FROM_YYYYMMDD  = MIN(C.BASIS_START_DATE)
            , @V_WHOLE_TO_YYYYMMDD    = MAX(C.BASIS_END_DATE)
    FROM    SCM_SYS_CALENDAR_M C
    WHERE   1=1
            AND SUBSTRING(C.ISO_YYYYWW, 1, 4) = @p_year;

    SET @V_WHOLE_THIS_MONDAY     = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112);
    SET @V_WHOLE_NEXT_MONDAY     = CONVERT(CHAR(8), DATEADD(DD,  1, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112);
    SET @V_WHOLE_LAST_SUNDAY     = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112);
    SET @V_WHOLE_NEXT_SUNDAY     = CONVERT(CHAR(8), DATEADD(DD,  7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112);--Pack FG 실적때문에 차주까지 조회

--Pack FG 실적때문에 차주까지 조회    SET @V_WHOLE_TO_YYYYMMDD    = IIF(@V_WHOLE_TO_YYYYMMDD >= @V_WHOLE_THIS_MONDAY, @V_WHOLE_LAST_SUNDAY, @V_WHOLE_TO_YYYYMMDD); -- 기간이 올해까지이더라도 전주까지만 조회
    SET @V_WHOLE_TO_YYYYMMDD    = IIF(@V_WHOLE_TO_YYYYMMDD >= @V_WHOLE_THIS_MONDAY, @V_WHOLE_NEXT_SUNDAY, @V_WHOLE_TO_YYYYMMDD); -- 기간이 올해까지이더라도 전주까지만 조회


PRINT '@V_WHOLE_THIS_MONDAY : ' + @V_WHOLE_THIS_MONDAY;
PRINT '@V_WHOLE_NEXT_MONDAY : ' + @V_WHOLE_NEXT_MONDAY;
--PRINT '@V_WHOLE_NEXT_SUNDAY : ' + @V_WHOLE_NEXT_SUNDAY;return;
--PRINT '@V_WHOLE_TO_YYYYMMDD : ' + @V_WHOLE_TO_YYYYMMDD;return ;

--set @V_WHOLE_FROM_YYYYMMDD    = N'20220110'; --test
--set @V_WHOLE_TO_YYYYMMDD      = N'20220116'; --test

--    SET @V_WHOLE_PRE_FROM_YYYYMMDD                 = CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(@V_WHOLE_FROM_YYYYMMDD, 'MON')), 112); -- RTF 를위해 지정한 기간 전주까지 기간에 포함
    SET @V_WHOLE_PRE_FROM_YYYYMMDD                 = CONVERT(CHAR(8), DATEADD(DD, -21, dbo.FN_NEXT_DAY(@V_WHOLE_FROM_YYYYMMDD, 'MON')), 112); -- RTF 를위해 지정한 기간 전주까지 기간에 포함
--print @V_WHOLE_PRE_FROM_YYYYMMDD;return;


    IF OBJECT_ID (N'tempdb..#T_WEEKS_ALL', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_ALL

    CREATE TABLE #T_WEEKS_ALL
    (
          ISO_YYYYWW                    NVARCHAR(6)
        , THIS_ISO_YYYYWW               NVARCHAR(6)
        , THIS_FROM_YYYYMMDD            NVARCHAR(8)
        , THIS_TO_YYYYMMDD              NVARCHAR(8)
        , PRE_ISO_YYYYWW                NVARCHAR(6)
        , PRE_FROM_YYYYMMDD             NVARCHAR(8)
        , PRE_TO_YYYYMMDD               NVARCHAR(8)
        , POST_ISO_YYYYWW               NVARCHAR(6)
        , POST_FROM_YYYYMMDD            NVARCHAR(8)
        , POST_TO_YYYYMMDD              NVARCHAR(8)
        , DM_RTF_YN                     NVARCHAR(1)
        , FG_SEQ_P                      BIGINT
        , FG_SEQ_R                      BIGINT
        , WHOLE_FROM_YYYYMMDD           NVARCHAR(8)
        , WHOLE_TO_YYYYMMDD             NVARCHAR(8)
        , WHOLE_PRE_FROM_YYYYMMDD       NVARCHAR(8)
        , WHOLE_THIS_MONDAY             NVARCHAR(8)
        , WHOLE_LAST_SUNDAY             NVARCHAR(8)
        , WHOLE_PRE_YYYYMM              NVARCHAR(6)
        , WHOLE_POST_YYYYMM             NVARCHAR(6)
    );

    DECLARE @V_CURR_ISO_YYYYWW                      NVARCHAR(6) = N''
    DECLARE @V_CURR_THIS_ISO_YYYYWW                 NVARCHAR(6) = N''
    DECLARE @V_CURR_THIS_FROM_YYYYMMDD              NVARCHAR(8) = N''
    DECLARE @V_CURR_THIS_TO_YYYYMMDD                NVARCHAR(8) = N''
    DECLARE @V_CURR_PRE_ISO_YYYYWW                  NVARCHAR(6) = N''
    DECLARE @V_CURR_PRE_FROM_YYYYMMDD               NVARCHAR(8) = N''
    DECLARE @V_CURR_PRE_TO_YYYYMMDD                 NVARCHAR(8) = N''
    DECLARE @V_CURR_POST_ISO_YYYYWW                 NVARCHAR(6) = N''
    DECLARE @V_CURR_POST_FROM_YYYYMMDD              NVARCHAR(8) = N''
    DECLARE @V_CURR_POST_TO_YYYYMMDD                NVARCHAR(8) = N''
    DECLARE @V_CURR_DM_RTF_YN                       NVARCHAR(1) = N''
    DECLARE @V_CURR_FG_SEQ_P                        BIGINT
    DECLARE @V_CURR_FG_SEQ_R                        BIGINT
    DECLARE @V_CURR_WHOLE_FROM_YYYYMMDD             NVARCHAR(8) = N''
    DECLARE @V_CURR_WHOLE_TO_YYYYMMDD               NVARCHAR(8) = N''
    DECLARE @V_CURR_WHOLE_PRE_FROM_YYYYMMDD         NVARCHAR(8) = N''
    DECLARE @V_CURR_WHOLE_THIS_MONDAY               NVARCHAR(8) = N''
    DECLARE @V_CURR_WHOLE_LAST_SUNDAY               NVARCHAR(8) = N''
    DECLARE @V_CURR_WHOLE_PRE_YYYYMM                NVARCHAR(6) = N''
    DECLARE @V_CURR_WHOLE_POST_YYYYMM               NVARCHAR(6) = N''


    INSERT INTO #T_WEEKS_ALL
--    SELECT    C.ISO_YYYYWW
--            , ''
--            , ''
--            , ''
--            , ''
--            , ''
--            , ''
--            , A.DM_RTF_YN
--    FROM	[dbo].[SCP_PLN_INTERFACE_YN] A WITH(NOLOCK)
--            JOIN
--                (
--                    SELECT    ISO_YYYYWW
--                            , BASIS_YYYYMMDD
--                    FROM    SCM_SYS_CALENDAR_M
--                    WHERE   DAYOFWEEK = 'MON'
--                ) C ON
--                    A.PLAN_START_YYYYMMDD = C.BASIS_YYYYMMDD
--    WHERE	1=1
--	    AND DIVISION_ID = @p_division_id
--	    --AND DM_RTF_YN = 'Y'
----시작일자 제한이 없어야 전주에 데이터가 없어도 이전까지 거슬러 찾음                    AND PLAN_START_YYYYMMDD >= @V_WHOLE_PRE_FROM_YYYYMMDD
--	    AND PLAN_START_YYYYMMDD <= @V_WHOLE_TO_YYYYMMDD
--    ORDER BY PLAN_START_YYYYMMDD DESC
    SELECT    C.ISO_YYYYWW
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ISNULL(A.DM_RTF_YN, 'Y') AS DM_RTF_YN
            , 1
            , 1
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
    FROM	(
                SELECT    ISO_YYYYWW
                        , BASIS_YYYYMMDD
                FROM    SCM_SYS_CALENDAR_M
                WHERE   DAYOFWEEK = 'MON'
                    AND BASIS_YYYYMMDD >= @V_WHOLE_PRE_FROM_YYYYMMDD
	                AND BASIS_YYYYMMDD <= @V_WHOLE_TO_YYYYMMDD
            ) C 
            LEFT JOIN 
                (   
                    SELECT    DIVISION_ID
                            , PLAN_START_YYYYMMDD
                            , DM_RTF_YN
                    FROM    [dbo].[SCP_PLN_INTERFACE_YN] A WITH(NOLOCK)
                    WHERE	1=1
	                    AND A.DIVISION_ID = @p_division_id
                ) A ON
                    C.BASIS_YYYYMMDD = A.PLAN_START_YYYYMMDD
    WHERE	1=1
	    --AND DM_RTF_YN = 'Y'
    ORDER BY A.PLAN_START_YYYYMMDD DESC

print '@V_WHOLE_TO_YYYYMMDD : ' + @V_WHOLE_TO_YYYYMMDD;

--TESTING : OK
--select * from #T_WEEKS_ALL order by ISO_YYYYWW DESC;return;

    IF OBJECT_ID (N'tempdb..#T_WEEKS_Y', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_Y

    SELECT  A.ISO_YYYYWW
    INTO    #T_WEEKS_Y
    FROM	#T_WEEKS_ALL A
    WHERE   1=1
--집계없어도 목록에는 포함해야 전전주로 거슬러 올라가는것을 방지하여 잘못된 수치를 가져오지 않도록 함        AND DM_RTF_YN = 'Y'

--TESTING : OK
--select * from #T_WEEKS_Y order by ISO_YYYYWW DESC;return;

--FG 데이터용 SEQ begin
    IF OBJECT_ID (N'tempdb..#TEMP_SEQ', N'U') IS NOT NULL
		DROP TABLE #TEMP_SEQ

    SELECT	  PLAN_SEQ
            , PLAN_TYPE
            , PLAN_START_YYYYMMDD
    INTO    #TEMP_SEQ
    FROM	SCP_PLAN_VERSION_V A WITH(NOLOCK)
    WHERE	1=1
	    AND ((@p_division_id IS NULL OR @p_division_id = '') OR A.DIVISION_ID = @p_division_id)
    GROUP BY PLAN_SEQ, PLAN_TYPE, PLAN_START_YYYYMMDD
--FG 데이터용 SEQ end


    DECLARE CUR_D CURSOR FOR
    SELECT    *
    FROM    #T_WEEKS_ALL
    ORDER BY ISO_YYYYWW DESC;

    OPEN CUR_D;

    FETCH NEXT FROM CUR_D INTO
          @V_CURR_ISO_YYYYWW
        , @V_CURR_THIS_ISO_YYYYWW
        , @V_CURR_THIS_FROM_YYYYMMDD
        , @V_CURR_THIS_TO_YYYYMMDD
        , @V_CURR_PRE_ISO_YYYYWW
        , @V_CURR_PRE_FROM_YYYYMMDD
        , @V_CURR_PRE_TO_YYYYMMDD
        , @V_CURR_POST_ISO_YYYYWW
        , @V_CURR_POST_FROM_YYYYMMDD
        , @V_CURR_POST_TO_YYYYMMDD
        , @V_CURR_DM_RTF_YN
        , @V_CURR_FG_SEQ_P
        , @V_CURR_FG_SEQ_R
        , @V_CURR_WHOLE_FROM_YYYYMMDD
        , @V_CURR_WHOLE_TO_YYYYMMDD
        , @V_CURR_WHOLE_PRE_FROM_YYYYMMDD
        , @V_CURR_WHOLE_THIS_MONDAY
        , @V_CURR_WHOLE_LAST_SUNDAY
        , @V_CURR_WHOLE_PRE_YYYYMM
        , @V_CURR_WHOLE_POST_YYYYMM


    WHILE @@FETCH_STATUS = 0
    BEGIN
        SELECT  @V_CURR_THIS_ISO_YYYYWW = MAX(ISO_YYYYWW)
        FROM    #T_WEEKS_Y
        WHERE   ISO_YYYYWW <= @V_CURR_ISO_YYYYWW

        SELECT    @V_CURR_THIS_FROM_YYYYMMDD = MIN(BASIS_YYYYMMDD)
                , @V_CURR_THIS_TO_YYYYMMDD   = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M
        WHERE   ISO_YYYYWW = @V_CURR_THIS_ISO_YYYYWW

        SELECT  @V_CURR_PRE_ISO_YYYYWW = MAX(ISO_YYYYWW)
        FROM    #T_WEEKS_Y
        WHERE   ISO_YYYYWW < @V_CURR_ISO_YYYYWW

        SELECT  @V_CURR_POST_ISO_YYYYWW = MIN(ISO_YYYYWW)
        FROM    #T_WEEKS_Y
        WHERE   ISO_YYYYWW > @V_CURR_ISO_YYYYWW

        SELECT    @V_CURR_PRE_FROM_YYYYMMDD = MIN(BASIS_YYYYMMDD)
                , @V_CURR_PRE_TO_YYYYMMDD   = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M
        WHERE   ISO_YYYYWW = @V_CURR_PRE_ISO_YYYYWW

        SELECT    @V_CURR_POST_FROM_YYYYMMDD = MIN(BASIS_YYYYMMDD)
                , @V_CURR_POST_TO_YYYYMMDD   = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M
        WHERE   ISO_YYYYWW = @V_CURR_POST_ISO_YYYYWW

        SELECT  @V_CURR_FG_SEQ_P = MAX(PLAN_SEQ)
        FROM    #TEMP_SEQ
        WHERE   1=1
	        AND PLAN_TYPE           = 'FN'
	        AND PLAN_START_YYYYMMDD = @V_CURR_PRE_FROM_YYYYMMDD

        SELECT  @V_CURR_FG_SEQ_R = MIN(PLAN_SEQ)
        FROM    #TEMP_SEQ
        WHERE   1=1
	        AND PLAN_TYPE           = 'PR'
	        AND PLAN_START_YYYYMMDD = @V_CURR_POST_FROM_YYYYMMDD



        UPDATE #T_WEEKS_ALL
        SET
            THIS_ISO_YYYYWW     = ISNULL(@V_CURR_THIS_ISO_YYYYWW, ''),
            THIS_FROM_YYYYMMDD  = ISNULL(@V_CURR_THIS_FROM_YYYYMMDD, ''),
            THIS_TO_YYYYMMDD    = ISNULL(@V_CURR_THIS_TO_YYYYMMDD, ''),
            PRE_ISO_YYYYWW      = ISNULL(@V_CURR_PRE_ISO_YYYYWW, ''),
            PRE_FROM_YYYYMMDD   = ISNULL(@V_CURR_PRE_FROM_YYYYMMDD, ''),
            PRE_TO_YYYYMMDD     = ISNULL(@V_CURR_PRE_TO_YYYYMMDD, ''),
            POST_ISO_YYYYWW     = ISNULL(@V_CURR_POST_ISO_YYYYWW, ''),
            POST_FROM_YYYYMMDD  = ISNULL(@V_CURR_POST_FROM_YYYYMMDD, ''),
            POST_TO_YYYYMMDD    = ISNULL(@V_CURR_POST_TO_YYYYMMDD, ''),
            FG_SEQ_P            = ISNULL(@V_CURR_FG_SEQ_P, 1),
            FG_SEQ_R            = ISNULL(@V_CURR_FG_SEQ_R, 1)
        WHERE   ISO_YYYYWW = @V_CURR_ISO_YYYYWW

        FETCH NEXT FROM CUR_D INTO
          @V_CURR_ISO_YYYYWW
        , @V_CURR_THIS_ISO_YYYYWW
        , @V_CURR_THIS_FROM_YYYYMMDD
        , @V_CURR_THIS_TO_YYYYMMDD
        , @V_CURR_PRE_ISO_YYYYWW
        , @V_CURR_PRE_FROM_YYYYMMDD
        , @V_CURR_PRE_TO_YYYYMMDD
        , @V_CURR_POST_ISO_YYYYWW
        , @V_CURR_POST_FROM_YYYYMMDD
        , @V_CURR_POST_TO_YYYYMMDD
        , @V_CURR_DM_RTF_YN
        , @V_CURR_FG_SEQ_P
        , @V_CURR_FG_SEQ_R
        , @V_CURR_WHOLE_FROM_YYYYMMDD
        , @V_CURR_WHOLE_TO_YYYYMMDD
        , @V_CURR_WHOLE_PRE_FROM_YYYYMMDD
        , @V_CURR_WHOLE_THIS_MONDAY
        , @V_CURR_WHOLE_LAST_SUNDAY
        , @V_CURR_WHOLE_PRE_YYYYMM
        , @V_CURR_WHOLE_POST_YYYYMM
    END;

    CLOSE CUR_D;
    DEALLOCATE CUR_D;

    UPDATE #T_WEEKS_ALL
    SET
        WHOLE_FROM_YYYYMMDD          = ISNULL(@V_WHOLE_FROM_YYYYMMDD, ''),
        WHOLE_TO_YYYYMMDD            = IIF(@V_WHOLE_TO_YYYYMMDD >= @V_WHOLE_THIS_MONDAY, @V_WHOLE_LAST_SUNDAY, @V_WHOLE_TO_YYYYMMDD),       -- 기간이 올해까지이더라도 전주까지만 조회
        WHOLE_PRE_FROM_YYYYMMDD      = CONVERT(CHAR(8), DATEADD(DD, -21, dbo.FN_NEXT_DAY(@V_WHOLE_FROM_YYYYMMDD, 'MON')), 112), -- RTF 를위해 지정한 기간 전주까지 기간에 포함
        WHOLE_PRE_YYYYMM             = @p_year + '01',
        WHOLE_POST_YYYYMM            = @p_year + '12',
        WHOLE_THIS_MONDAY            = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112),
        WHOLE_LAST_SUNDAY            = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112);
    

        SELECT    ISO_YYYYWW
                , THIS_ISO_YYYYWW
                , THIS_FROM_YYYYMMDD
                , THIS_TO_YYYYMMDD
                , PRE_ISO_YYYYWW
                , PRE_FROM_YYYYMMDD
                , PRE_TO_YYYYMMDD
                , POST_ISO_YYYYWW
                , POST_FROM_YYYYMMDD
                , POST_TO_YYYYMMDD
                , DM_RTF_YN
                , FG_SEQ_P
                , FG_SEQ_R
                , WHOLE_FROM_YYYYMMDD
                , WHOLE_TO_YYYYMMDD
                , WHOLE_PRE_FROM_YYYYMMDD
                , WHOLE_THIS_MONDAY
                , WHOLE_LAST_SUNDAY
                , WHOLE_PRE_YYYYMM
                , WHOLE_POST_YYYYMM
        FROM	#T_WEEKS_ALL
        ORDER BY ISO_YYYYWW DESC;

PRINT '@p_division_id : ' + @p_division_id;
PRINT '@p_year : ' + @p_year;
PRINT '@V_WHOLE_FROM_YYYYMMDD : ' + @V_WHOLE_FROM_YYYYMMDD;
PRINT '@V_WHOLE_TO_YYYYMMDD : ' + @V_WHOLE_TO_YYYYMMDD;
PRINT '@V_WHOLE_THIS_MONDAY : ' + @V_WHOLE_THIS_MONDAY;
PRINT '@V_WHOLE_LAST_SUNDAY : ' + @V_WHOLE_LAST_SUNDAY;
PRINT '@V_WHOLE_PRE_FROM_YYYYMMDD : ' + @V_WHOLE_PRE_FROM_YYYYMMDD;


    IF OBJECT_ID (N'tempdb..#T_WEEKS_ALL', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_ALL

    IF OBJECT_ID (N'tempdb..#T_WEEKS_Y', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_Y
END
