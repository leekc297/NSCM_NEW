---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY_TERM
 * Description  : RTF 준수율 Weekly 조회
 * Program History
 *===================================================================================================
 *  Date        In Charge           Description
*===================================================================================================
* 2022.08.11    chaan       V1.0.1  Inititialize
* 2022/08/24    chaan		V1.0.2  W01 조회시 전년주 마지막주 Target 없으면 전년주 마지막 전전주로 조회
* 2022/10/24    chaan		V1.1.12 소형        - opertaion_group 에 따른 로직 변경
                                                  ~ Cell 일 때, Pack RTF 항목들(RTF, RESULT, RESULT_WITH_RTF , RATE) 0 처리
                                                  ~ Pack 일 때, 대상 데이터를 Shipment Plan FG 기준으로 변경
**************************************************************************************************
*/
 
--CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY_TERM]
CREATE PROCEDURE [dbo].[SCP0092_GET_RTF_ARCHEIVEMENT_RATE_SUMMARY_TERM]
       @p_division_id              NVARCHAR(30)
     , @p_year                     NVARCHAR(4)
	 , @p_from_yyyymmdd            NVARCHAR(8) OUTPUT
	 , @p_to_yyyymmdd              NVARCHAR(8) OUTPUT
     , @V_PRE_YYYYMM               NVARCHAR(6) OUTPUT
     , @V_POST_YYYYMM              NVARCHAR(6) OUTPUT
	 , @V_THIS_MONDAY              NVARCHAR(8) OUTPUT
	 , @V_LAST_SUNDAY              NVARCHAR(8) OUTPUT
     , @V_PRE_FROM_YYYYMMDD        NVARCHAR(8) OUTPUT
 AS  
BEGIN
    SET NOCOUNT ON;
    SET ANSI_NULLS ON
    SET ANSI_WARNINGS ON; 


   --DECLARE @p_division_id              NVARCHAR(30)       = N'82';  
   --DECLARE @p_year                     NVARCHAR(4)        = N'2022';
   --DECLARE @p_from_yyyymmdd            NVARCHAR(8)        = N'';
   --DECLARE @p_to_yyyymmdd              NVARCHAR(8)        = N'';
   --DECLARE @V_PRE_YYYYMM               NVARCHAR(6)        = N'';
   --DECLARE @V_POST_YYYYMM              NVARCHAR(6)        = N'';
   --DECLARE @V_THIS_MONDAY              NVARCHAR(8)        = N'';
   --DECLARE @V_LAST_SUNDAY              NVARCHAR(8)        = N'';
   --DECLARE @V_PRE_FROM_YYYYMMDD        NVARCHAR(8)        = N'';

    SET @p_from_yyyymmdd            = '';
    SET @p_to_yyyymmdd              = '';
    SET @V_PRE_YYYYMM               = @p_year + '01';
    SET @V_POST_YYYYMM              = @p_year + '12';

    
    SELECT    @p_from_yyyymmdd  = MIN(C.BASIS_START_DATE)
            , @p_to_yyyymmdd    = MAX(C.BASIS_END_DATE)
    FROM    SCM_SYS_CALENDAR_M C
    WHERE   1=1
            AND SUBSTRING(C.ISO_YYYYWW, 1, 4) = @p_year;

    SET @V_THIS_MONDAY              = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112);
    SET @V_LAST_SUNDAY              = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'SUN')), 112);

    SET @p_to_yyyymmdd    = IIF(@p_to_yyyymmdd >= @V_THIS_MONDAY, @V_LAST_SUNDAY, @p_to_yyyymmdd); -- 기간이 올해까지이더라도 전주까지만 조회



--set @p_from_yyyymmdd    = N'20220110'; --test
--set @p_to_yyyymmdd      = N'20220116'; --test

--    SET @V_PRE_FROM_YYYYMMDD                 = CONVERT(CHAR(8), DATEADD(DD, -14, dbo.FN_NEXT_DAY(@p_from_yyyymmdd, 'MON')), 112); -- RTF 를위해 지정한 기간 전주까지 기간에 포함
    SET @V_PRE_FROM_YYYYMMDD                 = CONVERT(CHAR(8), DATEADD(DD, -21, dbo.FN_NEXT_DAY(@p_from_yyyymmdd, 'MON')), 112); -- RTF 를위해 지정한 기간 전주까지 기간에 포함
--print @V_PRE_FROM_YYYYMMDD;return;


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
        , DM_RTF_YN                     NVARCHAR(1)
        , FG_SEQ_P                      BIGINT  --FG
        , FG_SEQ_R                      BIGINT  --FG
    )

    DECLARE @V_CURR_ISO_YYYYWW          NVARCHAR(6) = N''
    DECLARE @V_CURR_THIS_ISO_YYYYWW     NVARCHAR(6) = N''
    DECLARE @V_CURR_THIS_FROM_YYYYMMDD  NVARCHAR(8) = N''
    DECLARE @V_CURR_THIS_TO_YYYYMMDD    NVARCHAR(8) = N''
    DECLARE @V_CURR_PRE_ISO_YYYYWW      NVARCHAR(6) = N''
    DECLARE @V_CURR_PRE_FROM_YYYYMMDD   NVARCHAR(8) = N''
    DECLARE @V_CURR_PRE_TO_YYYYMMDD     NVARCHAR(8) = N''
    DECLARE @V_CURR_DM_RTF_YN           NVARCHAR(1) = N''
    DECLARE @V_CURR_FG_SEQ_P            BIGINT
    DECLARE @V_CURR_FG_SEQ_R            BIGINT


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
----시작일자 제한이 없어야 전주에 데이터가 없어도 이전까지 거슬러 찾음                    AND PLAN_START_YYYYMMDD >= @V_PRE_FROM_YYYYMMDD
--	    AND PLAN_START_YYYYMMDD <= @p_to_yyyymmdd
--    ORDER BY PLAN_START_YYYYMMDD DESC
    SELECT    C.ISO_YYYYWW
            , ''
            , ''
            , ''
            , ''
            , ''
            , ''
            , ISNULL(A.DM_RTF_YN, 'Y') AS DM_RTF_YN
            , 1
            , 1
    FROM	(
                SELECT    ISO_YYYYWW
                        , BASIS_YYYYMMDD
                FROM    SCM_SYS_CALENDAR_M
                WHERE   DAYOFWEEK = 'MON'
                    AND BASIS_YYYYMMDD >= @V_PRE_FROM_YYYYMMDD
	                AND BASIS_YYYYMMDD <= @p_to_yyyymmdd
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

print '@p_to_yyyymmdd : ' + @p_to_yyyymmdd;

--select * from #T_WEEKS_ALL order by ISO_YYYYWW;return;

    IF OBJECT_ID (N'tempdb..#T_WEEKS_Y', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_Y

    SELECT  A.ISO_YYYYWW
    INTO    #T_WEEKS_Y
    FROM	#T_WEEKS_ALL A
    WHERE   1=1
        AND DM_RTF_YN = 'Y'

--FG 데이터용 SEQ begin
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
        , @V_CURR_DM_RTF_YN
        , @V_CURR_FG_SEQ_P
        , @V_CURR_FG_SEQ_R

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

        SELECT    @V_CURR_PRE_FROM_YYYYMMDD = MIN(BASIS_YYYYMMDD)
                , @V_CURR_PRE_TO_YYYYMMDD   = MAX(BASIS_YYYYMMDD)
        FROM    SCM_SYS_CALENDAR_M
        WHERE   ISO_YYYYWW = @V_CURR_PRE_ISO_YYYYWW

        SELECT  @V_CURR_FG_SEQ_P = MAX(PLAN_SEQ)
        FROM    #TEMP_SEQ
        WHERE   1=1
	        AND PLAN_TYPE           = 'FN'
	        AND PLAN_START_YYYYMMDD = @V_CURR_PRE_FROM_YYYYMMDD

        SELECT  @V_CURR_FG_SEQ_R = MIN(PLAN_SEQ)
        FROM    #TEMP_SEQ
        WHERE   1=1
	        AND PLAN_TYPE           = 'PR'
	        AND PLAN_START_YYYYMMDD = @V_CURR_THIS_FROM_YYYYMMDD



        UPDATE #T_WEEKS_ALL
        SET
            THIS_ISO_YYYYWW     = ISNULL(@V_CURR_THIS_ISO_YYYYWW, ''),
            THIS_FROM_YYYYMMDD  = ISNULL(@V_CURR_THIS_FROM_YYYYMMDD, ''),
            THIS_TO_YYYYMMDD    = ISNULL(@V_CURR_THIS_TO_YYYYMMDD, ''),
            PRE_ISO_YYYYWW      = ISNULL(@V_CURR_PRE_ISO_YYYYWW, ''),
            PRE_FROM_YYYYMMDD   = ISNULL(@V_CURR_PRE_FROM_YYYYMMDD, ''),
            PRE_TO_YYYYMMDD     = ISNULL(@V_CURR_PRE_TO_YYYYMMDD, ''),
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
        , @V_CURR_DM_RTF_YN
        , @V_CURR_FG_SEQ_P
        , @V_CURR_FG_SEQ_R
    END;

    CLOSE CUR_D;
    DEALLOCATE CUR_D;

    SELECT    ISO_YYYYWW
            , THIS_ISO_YYYYWW
            , THIS_FROM_YYYYMMDD
            , THIS_TO_YYYYMMDD
            , PRE_ISO_YYYYWW
            , PRE_FROM_YYYYMMDD
            , PRE_TO_YYYYMMDD
            , DM_RTF_YN
            , FG_SEQ_P
            , FG_SEQ_R
    FROM	#T_WEEKS_ALL
    ORDER BY ISO_YYYYWW DESC

PRINT '@p_division_id : ' + @p_division_id;
PRINT '@p_year : ' + @p_year;
PRINT '@p_from_yyyymmdd : ' + @p_from_yyyymmdd;
PRINT '@p_to_yyyymmdd : ' + @p_to_yyyymmdd;
PRINT '@V_THIS_MONDAY : ' + @V_THIS_MONDAY;
PRINT '@V_LAST_SUNDAY : ' + @V_LAST_SUNDAY;
PRINT '@V_PRE_FROM_YYYYMMDD : ' + @V_PRE_FROM_YYYYMMDD;


    IF OBJECT_ID (N'tempdb..#T_WEEKS_ALL', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_ALL

    IF OBJECT_ID (N'tempdb..#T_WEEKS_Y', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_Y


END
