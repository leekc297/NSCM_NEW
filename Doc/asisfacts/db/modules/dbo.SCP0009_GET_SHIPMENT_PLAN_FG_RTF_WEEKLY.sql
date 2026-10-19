

/*
 * Program ID   : SCP0009_GET_SHIPMENT_PLAN_FG_RTF_WEEKLY
 * Description  : Shipment Plan 조회
 * Program History
 
 *===================================================================================================
 *   Date       In Charge		        Description
 *===================================================================================================
 * 2022/11/11   chaan       	V1.0.0  Initial Release
 * 2023.01.02   lwy             PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - 조회기준 변경(main / hist) - 당주,전주(main) / 당주,전주 이전(hist) 
 * 2023.04.10   LWY				PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - DIVISION_ID 공통화 작업(div_commonization)
 * 2024.06.27   ksg             E20240612-001030 Shipment plan FG 실적조회 시 confirm_id 참조하는 데이터 변경 (from_site, item_id →from_site only)
 *                                           선적계획 실적구간 조회 시 confirm_id 를 [SSP_ANL_SHIP_CONFIRM]에 조인하여 from_site_ID와 item_id 를 업데이트해서 적용하는데,
 *                                           조인해서 가져오는 값을 from_site_id 만 가져오고, item_id 는 기존에 있는 값을 사용하여 출하실적으로 적용
 */

--CREATE PROCEDURE [dbo].[SCP0009_GET_SHIPMENT_PLAN_FG_RTF_WEEKLY]
CREATE PROCEDURE [dbo].[SCP0009_GET_SHIPMENT_PLAN_FG_RTF_WEEKLY]
      @p_is_plan				NVARCHAR(1)			= N'T'
    , @p_division_id			NVARCHAR(30)
    , @p_from_yyyymmdd		    NVARCHAR(8)
    , @p_to_yyyymmdd			NVARCHAR(8)
    , @p_program_id			    NVARCHAR(10)        = 'SCP0009'
    , @p_sheet_name			    NVARCHAR(30)        = 'Shipment Plan FG'
    , @p_user_id				NVARCHAR(30)
    , @debug_mode               NVARCHAR(1)         ='F'
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	--DECLARE @p_is_plan				NVARCHAR(1)			= N'T';
	--DECLARE @p_division_id			NVARCHAR(30)		= N'40';
	--DECLARE @p_from_yyyymmdd		NVARCHAR(8)			= N'20221017';
	--DECLARE @p_to_yyyymmdd			NVARCHAR(8)			= N'20221023';
	--DECLARE @p_program_id			NVARCHAR(10)		= 'SCP0009';
	--DECLARE @p_sheet_name			NVARCHAR(30)		= 'Shipment Plan FG';
	--DECLARE @p_user_id				NVARCHAR(30)		= N'iamarock';
	--DECLARE @debug_mode             NVARCHAR(1)			='F';



	DECLARE @p_biz_type				NVARCHAR(30)		= N'P';

	DECLARE @p_plan_start_yyyymmdd  NVARCHAR(8)			= N'';
	DECLARE @p_seq					NVARCHAR(10)		= N'';
	DECLARE @p_plan_type			NVARCHAR(10)		= IIF(@p_is_plan = 'T', 'FN', 'PR');
	DECLARE @p_year       			NVARCHAR(4)		    = SUBSTRING(@p_from_yyyymmdd, 1, 4);
	DECLARE @V_PRE_YYYYMM           NVARCHAR(6)			= N'';
	DECLARE @V_POST_YYYYMM          NVARCHAR(8)			= N'';
	DECLARE @V_THIS_MONDAY          NVARCHAR(8)			= N'';
	DECLARE @V_LAST_SUNDAY          NVARCHAR(8)			= N'';
	DECLARE @V_PRE_FROM_YYYYMMDD    NVARCHAR(8)			= N'';


    IF OBJECT_ID (N'tempdb..#T_SCP0009_TERMS', N'U') IS NOT NULL 
		DROP TABLE #T_SCP0009_TERMS

	--CREATE TABLE #T_SCP0009_TERMS
 --   (
 --         ISO_YYYYWW                    NVARCHAR(6)
 --       , THIS_ISO_YYYYWW               NVARCHAR(6)
 --       , THIS_FROM_YYYYMMDD            NVARCHAR(8)
 --       , THIS_TO_YYYYMMDD              NVARCHAR(8)
 --       , PRE_ISO_YYYYWW                NVARCHAR(6)
 --       , PRE_FROM_YYYYMMDD             NVARCHAR(8)
 --       , PRE_TO_YYYYMMDD               NVARCHAR(8)
 --       , POST_ISO_YYYYWW               NVARCHAR(6)
 --       , POST_FROM_YYYYMMDD            NVARCHAR(8)
 --       , POST_TO_YYYYMMDD              NVARCHAR(8)
 --       , DM_RTF_YN                     NVARCHAR(1)
 --       , FG_SEQ_P                      BIGINT
 --       , FG_SEQ_R                      BIGINT
 --       , WHOLE_FROM_YYYYMMDD           NVARCHAR(8)
 --       , WHOLE_TO_YYYYMMDD             NVARCHAR(8)
 --       , WHOLE_PRE_FROM_YYYYMMDD       NVARCHAR(8)
 --       , WHOLE_THIS_MONDAY             NVARCHAR(8)
 --       , WHOLE_LAST_SUNDAY             NVARCHAR(8)
 --       , WHOLE_PRE_YYYYMM              NVARCHAR(6)
 --       , WHOLE_POST_YYYYMM             NVARCHAR(6)
 --   )
 BEGIN--SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM begin------------------------------------------------------------------------
      --INSERT INTO EXEC 중복으로 호출불가하여 SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM 내용을 그대로 이곳으로 복사함

   --DECLARE @p_division_id              NVARCHAR(30)       = N'40';  
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

--select * from #T_WEEKS_ALL order by ISO_YYYYWW;return;

    IF OBJECT_ID (N'tempdb..#T_WEEKS_Y', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_Y

    SELECT  A.ISO_YYYYWW
    INTO    #T_WEEKS_Y
    FROM	#T_WEEKS_ALL A
    WHERE   1=1
        AND DM_RTF_YN = 'Y'

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


    DECLARE CUR_T_WEEKS_ALL CURSOR FOR
    SELECT    *
    FROM    #T_WEEKS_ALL
    ORDER BY ISO_YYYYWW DESC;

    OPEN CUR_T_WEEKS_ALL;

    FETCH NEXT FROM CUR_T_WEEKS_ALL INTO
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

        FETCH NEXT FROM CUR_T_WEEKS_ALL INTO
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

    CLOSE CUR_T_WEEKS_ALL;
    DEALLOCATE CUR_T_WEEKS_ALL;

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
        INTO #T_SCP0009_TERMS         
        FROM	#T_WEEKS_ALL
        ORDER BY ISO_YYYYWW DESC;

PRINT '@p_division_id : ' + @p_division_id;
PRINT '@p_year : ' + @p_year;
PRINT '@V_WHOLE_FROM_YYYYMMDD : ' + @V_WHOLE_FROM_YYYYMMDD;
PRINT '@V_WHOLE_TO_YYYYMMDD : ' + @V_WHOLE_TO_YYYYMMDD;
PRINT '@V_WHOLE_THIS_MONDAY : ' + @V_WHOLE_THIS_MONDAY;
PRINT '@V_WHOLE_LAST_SUNDAY : ' + @V_WHOLE_LAST_SUNDAY;
PRINT '@V_WHOLE_PRE_FROM_YYYYMMDD : ' + @V_WHOLE_PRE_FROM_YYYYMMDD;

--TESTING : OK
--select * from #T_SCP0009_TERMS order by ISO_YYYYWW desc;return;

    IF OBJECT_ID (N'tempdb..#T_WEEKS_ALL', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_ALL

    IF OBJECT_ID (N'tempdb..#T_WEEKS_Y', N'U') IS NOT NULL
		DROP TABLE #T_WEEKS_Y
END--SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM end------------------------------------------------------------------------

	--INSERT INTO #T_SCP0009_TERMS 
 --   (
 --         ISO_YYYYWW
 --       , THIS_ISO_YYYYWW
 --       , THIS_FROM_YYYYMMDD
 --       , THIS_TO_YYYYMMDD
 --       , PRE_ISO_YYYYWW
 --       , PRE_FROM_YYYYMMDD
 --       , PRE_TO_YYYYMMDD
 --       , POST_ISO_YYYYWW
 --       , POST_FROM_YYYYMMDD
 --       , POST_TO_YYYYMMDD
 --       , DM_RTF_YN
 --       , FG_SEQ_P
 --       , FG_SEQ_R
 --       , WHOLE_FROM_YYYYMMDD
 --       , WHOLE_TO_YYYYMMDD
 --       , WHOLE_PRE_FROM_YYYYMMDD
 --       , WHOLE_THIS_MONDAY
 --       , WHOLE_LAST_SUNDAY
 --       , WHOLE_PRE_YYYYMM
 --       , WHOLE_POST_YYYYMM
 --   )
 --       EXEC SCP0092_GET_RTF_ARCHEIVEMENT_RATE_TERM
 --              @p_division_id
 --            , @p_year;

--select * from #T_SCP0009_TERMS; return;

    
    DECLARE @V_LAST_MONDAY          NVARCHAR(8)         = '';
    DECLARE @V_NEXT_MONDAY          NVARCHAR(8)         = '';

--TESTING : NOK
--    SELECT    *
--    FROM    #T_SCP0009_TERMS
--    WHERE   THIS_FROM_YYYYMMDD = @p_from_yyyymmdd;
--return;

    SELECT    @p_plan_start_yyyymmdd    = IIF(@p_is_plan = 'T', PRE_FROM_YYYYMMDD, POST_FROM_YYYYMMDD)
            , @V_LAST_MONDAY            = PRE_FROM_YYYYMMDD
            , @V_NEXT_MONDAY            = POST_FROM_YYYYMMDD
            , @p_seq                    = IIF(@p_is_plan = 'T', FG_SEQ_P, FG_SEQ_R)
    FROM    #T_SCP0009_TERMS
    WHERE   THIS_FROM_YYYYMMDD = @p_from_yyyymmdd


	declare @v_data_cnt nvarchar(8);
	set @v_data_cnt =0;

	DECLARE @v_cnt_usr_measure	nvarchar =0;
	DECLARE @v_from_yyyymmdd     AS NVARCHAR(8);
	DECLARE @v_to_yyyymmdd       AS NVARCHAR(8);
	DECLARE @v_from_result       AS NVARCHAR(8);
	DECLARE @v_to_result         AS NVARCHAR(8);
	DECLARE @v_min_yyyymmdd      AS NVARCHAR(8);   -- 2021/07/21	
	DECLARE @v_RSLT_FLAG AS NVARCHAR(1) = 'Y';   -- 2021/07/21

	SET @v_cnt_usr_measure = (
								SELECT COUNT(*)
								FROM scm_mst_titleset_user
								WHERE 1=1
								 AND program_id  =  @p_program_id
								 AND sheet_name  =  @p_sheet_name
								 AND user_id     =  @p_user_id
							  )    

	SET @v_from_yyyymmdd = '';
	SET @v_to_yyyymmdd   = '';
	SET @v_from_result   = '';
	SET @v_to_result     = '';

	  SELECT @v_from_yyyymmdd = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_plan_start_yyyymmdd

	  SELECT @v_from_result = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_from_yyyymmdd;

	  SELECT @v_to_result = C.BASIS_START_DATE
	  FROM   [dbo].[SCM_SYS_CALENDAR_M]      C
	  WHERE  1 = 1
	  AND    C.BASIS_YYYYMMDD = @p_to_yyyymmdd;

	  IF @v_from_yyyymmdd > @v_from_result
		  BEGIN -- 실적 보여줌		  
		  SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		  SET @v_to_result     = @v_from_yyyymmdd;
		  END;
	  ELSE IF @v_from_yyyymmdd <= @v_from_result
		  BEGIN -- 실적 없음
		  
		  SET @v_RSLT_FLAG = 'N';  -- 2021/07/21 // 계획만 조회
		  
		  SET @v_to_yyyymmdd   = @p_to_yyyymmdd;
		  SET @v_from_result = CONVERT(CHAR(8), DATEADD(MM, 6, convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_to_result = CONVERT(CHAR(8), DATEADD(MM, -6, convert(datetime,@p_plan_start_yyyymmdd)), 112)
		  END;
	  ELSE IF @v_from_yyyymmdd > @v_to_result
		  BEGIN
		  SET @v_from_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_to_yyyymmdd = CONVERT(CHAR(8), DATEADD(MM, -6,  convert(datetime,@p_plan_start_yyyymmdd)), 112);
		  SET @v_from_result = @p_from_yyyymmdd;
		  SET @v_to_result = @p_to_yyyymmdd;
		  END;
	  ELSE IF @v_from_yyyymmdd = @v_to_result
		  BEGIN
		  SET @v_to_yyyymmdd = @v_from_yyyymmdd
		  SET @v_from_result = @p_from_yyyymmdd;
		  SET @v_to_result = @p_to_yyyymmdd;
		  END;

print '@p_division_id : ' + @p_division_id;
print '@p_biz_type : ' + @p_biz_type;
print '@p_plan_type : ' + @p_plan_type;
print '@p_seq : ' + @p_seq;
print '@p_plan_start_yyyymmdd : ' + @p_plan_start_yyyymmdd;
PRINT '@v_from_yyyymmdd : ' + @v_from_yyyymmdd;
PRINT '@v_to_yyyymmdd : ' + @v_to_yyyymmdd;
PRINT '@v_from_result : ' + @v_from_result;
PRINT '@v_to_result : ' + @v_to_result	;
--return;

	DECLARE @mEXEC NVARCHAR(MAX);

	-- 2021.11.24 : 체크 시 bucket='daily' 조회

	/********************************************************************************
	* 임시테이블만들기 - Header 부분
	********************************************************************************/

	-- ##############################################################################
	-- MEASURE 정보 생성
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_MEASURE') IS NOT NULL
		DROP TABLE #TMP_SCP0009_MEASURE
	
	SELECT M.COLUMN_NAME
		 , M.COLUMN_LABEL_NAME
		 , ISNULL(T.SORT_ORDER_NO, M.SORT_ORDER_NO ) MEASURE_ORDER_NO
	  INTO #TMP_SCP0009_MEASURE
	  FROM SCM_MST_SHEET_MEASURE M
      LEFT JOIN ( SELECT *
				    FROM SCM_MST_TITLESET_USER
				   WHERE PROGRAM_ID = @p_program_id
					 AND SHEET_NAME	= @p_sheet_name
					 AND USER_ID	= @p_user_id
				) T
		ON M.PROGRAM_ID		= T.PROGRAM_ID
	   AND M.SHEET_NAME		= T.SHEET_NAME
	   AND M.COLUMN_NAME	= T.COLUMN_NAME
 
	 WHERE M.PROGRAM_ID = @p_program_id
	   AND M.SHEET_NAME = @p_sheet_name
	   AND M.VALID_YN	= 'Y'
	   AND (@v_cnt_usr_measure  = 0 OR T.column_name IS NOT NULL)
	   
	   PRINT '1. Make Measure Info End. '+CONVERT(CHAR(23), GETDATE(), 21);


	-- ##############################################################################
	-- 기준 정보 생성
	-- 0 값 포함 조회 한다.
	-- ##############################################################################   
	IF OBJECT_ID('tempdb..#TMP_SCP0009_STD') IS NOT NULL
		DROP TABLE #TMP_SCP0009_STD

	CREATE TABLE #TMP_SCP0009_STD (
		 DIVISION_ID				NVARCHAR(128)
		,BIZ_TYPE					NVARCHAR(128)
		,PROJECT_CODE				NVARCHAR(128)
		,ITEM_ID					NVARCHAR(128)
		,TO_SITE					NVARCHAR(128)
		,FROM_SITE					NVARCHAR(128)
		,INCOTERMS					NVARCHAR(128)
		,BOD_ID						NVARCHAR(128)
		,MEASURE					NVARCHAR(128)
		,MEASURE_LABEL				NVARCHAR(128)
		,MEASURE_ORDER_NO			NVARCHAR(128)
		,TRANSPORT_MODE				NVARCHAR(128)
		,LT_DAY						NVARCHAR(128)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(30)
		,ELECTRODE_TYPE				NVARCHAR(30)		
		,PLAN_START_YYYYMMDD		NVARCHAR(128)
		,PLAN_TYPE					NVARCHAR(128)		
		,SEQ						NVARCHAR(128)
	)

	-- 2023.01.02
	--SELECT @v_min_yyyymmdd = MIN_YYYYMMDD FROM [dbo].[FN_GET_SCP_PLAN_MIN_DATE](@p_program_id, @p_division_id, @p_plan_type, @p_biz_type, @p_seq);
	SELECT @v_min_yyyymmdd = replace(convert(char(10),dateadd(d,datepart(dw,GETDATE()) * -1 - 5,GETDATE()),120),'-',''); -- previous monday

print '@v_min_yyyymmdd : ' + @v_min_yyyymmdd;--return;

	-- Dynamic Query 로 변경해 보았으나 속도 문제로 IF/ELSE 로 분기
	IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_STD
		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.BIZ_TYPE
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , A.FROM_SITE
			 , A.INCOTERMS
			 , A.BOD_ID
			 , A.MEASURE
			 , B.COLUMN_LABEL_NAME				AS MEASURE_LABEL
			 , B.MEASURE_ORDER_NO				AS MEASURE_ORDER_NO
			 , C.TRANSPORT_MODE
			 , C.LT_TOTAL AS LT_DAY
			 , ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID,''),'-')		AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID,''),'-')		AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')				AS ELECTRODE_TYPE
			 , @p_plan_start_yyyymmdd			AS PLAN_START_YYYYMMDD
			 , @p_plan_type						AS PLAN_TYPE
			 , @p_seq							AS SEQ
		  
		  FROM ( SELECT DISTINCT
						A.DIVISION_ID
					  , A.BIZ_TYPE
					  , A.PROJECT_CODE
					  , A.ITEM_ID
					  , A.TO_SITE
					  , A.FROM_SITE
					  , A.INCOTERMS
					  , A.BOD_ID
					  , A.MEASURE	
					  , A.ORIGIN_FROM_DIVISION_ID
					  , A.ORIGIN_TO_DIVISION_ID
					 , A.ELECTRODE_TYPE
				   FROM SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK INDEX(PK_SCP_ANL_SHIPMENT_PLAN_FG))
				  WHERE 1=1
					-- BOD 2단계 개발 : FROM , TO 로 변경
					--AND A.YYYYMMDD				= @p_plan_start_yyyymmdd
					AND A.YYYYMMDD				>= @v_from_yyyymmdd
					AND A.YYYYMMDD				<= @v_to_yyyymmdd
					AND A.DIVISION_ID			= @p_division_id
					AND A.BIZ_TYPE				= @p_biz_type
					AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
					AND A.PLAN_TYPE				= @p_plan_type
					AND A.SEQ					= @p_seq
				) A
		 INNER JOIN #TMP_SCP0009_MEASURE B
			ON A.MEASURE = B.COLUMN_NAME

		-- BOD 2단계 개발 : VIEW 수정
/*		LEFT JOIN SCP_MST_BOD_N_V C 
			  ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END )= C.DIVISION_ID 
			  AND  A.BOD_ID = C.BOD_ID 
			  AND A.FROM_SITE = C.FROM_SITE*/
		LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			   ON A.DIVISION_ID = C.DIVISION_ID 
			  AND A.BOD_ID     = C.BOD_ID 
			  AND A.FROM_SITE  = C.FROM_SITE
			  AND C.PLAN_SEQ   = @p_seq
			  AND C.PLAN_TYPE  = @p_plan_type
			  AND C.PLAN_NAME  = @p_plan_start_yyyymmdd			
		;
	END
	ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_STD
		SELECT DISTINCT
			   A.DIVISION_ID
			 , A.BIZ_TYPE
			 , A.PROJECT_CODE
			 , A.ITEM_ID
			 , A.TO_SITE
			 , A.FROM_SITE
			 , A.INCOTERMS
			 , A.BOD_ID
			 , A.MEASURE
			 , B.COLUMN_LABEL_NAME				AS MEASURE_LABEL
			 , B.MEASURE_ORDER_NO				AS MEASURE_ORDER_NO
			 , C.TRANSPORT_MODE
			 , C.LT_TOTAL AS LT_DAY
			 , ISNULL(NULLIF(A.ORIGIN_FROM_DIVISION_ID,''),'-')		AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(A.ORIGIN_TO_DIVISION_ID,''),'-')		AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(A.ELECTRODE_TYPE,''),'-')				AS ELECTRODE_TYPE
			 , @p_plan_start_yyyymmdd			AS PLAN_START_YYYYMMDD
			 , @p_plan_type						AS PLAN_TYPE
			 , @p_seq							AS SEQ
		  
		  FROM ( SELECT DISTINCT
						A.DIVISION_ID
					  , A.BIZ_TYPE
					  , A.PROJECT_CODE
					  , A.ITEM_ID
					  , A.TO_SITE
					  , A.FROM_SITE
					  , A.INCOTERMS
					  , A.BOD_ID
					  , A.MEASURE	
					  , A.ORIGIN_FROM_DIVISION_ID
					  , A.ORIGIN_TO_DIVISION_ID
					  , A.ELECTRODE_TYPE
				   FROM HIST_SCP_ANL_SHIPMENT_PLAN_FG A WITH(NOLOCK INDEX(PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG))
				  WHERE 1=1
					AND A.YYYYMMDD				= @p_plan_start_yyyymmdd
					AND A.DIVISION_ID			= @p_division_id
					AND A.BIZ_TYPE				= @p_biz_type
					AND A.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
					AND A.PLAN_TYPE				= @p_plan_type
					AND A.SEQ					= @p_seq
				) A
		 INNER JOIN #TMP_SCP0009_MEASURE B
			ON A.MEASURE = B.COLUMN_NAME
    
		-- BOD 2단계 개발 : VIEW 수정
/*		LEFT JOIN SCP_MST_BOD_N_V C 
			  ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END )= C.DIVISION_ID 
			  AND  A.BOD_ID = C.BOD_ID 
			  AND A.FROM_SITE = C.FROM_SITE*/
		LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			   ON  A.DIVISION_ID = C.DIVISION_ID 
			  AND A.BOD_ID    = C.BOD_ID 
			  AND A.FROM_SITE = C.FROM_SITE
		      AND C.PLAN_SEQ  = @p_seq
		      AND C.PLAN_TYPE = @p_plan_type
		      AND C.PLAN_NAME = @p_plan_start_yyyymmdd			
		;
	END



	PRINT '2. Make Std Info End. '+CONVERT(CHAR(23), GETDATE(), 21);

-- ##############################################################################
-- 기준 정보를 기준으로 계획 구간 정보 조회
-- 0 값 포함하지 않는다.
-- ##############################################################################

	IF OBJECT_ID('tempdb..#TMP_SCP0009_FG_VALUE') IS NOT NULL
		DROP TABLE #TMP_SCP0009_FG_VALUE

	CREATE TABLE #TMP_SCP0009_FG_VALUE (
		 YYYYMMDD					NVARCHAR(8)
		,DIVISION_ID				NVARCHAR(128)
		,BIZ_TYPE					NVARCHAR(128)
		,PROJECT_CODE				NVARCHAR(128)
		,ITEM_ID					NVARCHAR(128)
		,TO_SITE					NVARCHAR(128)
		,FROM_SITE					NVARCHAR(128)
		,INCOTERMS					NVARCHAR(128)
		,BOD_ID						NVARCHAR(128)
		,MEASURE					NVARCHAR(128)
		,ORIGIN_FROM_DIVISION_ID	NVARCHAR(30)
		,ORIGIN_TO_DIVISION_ID		NVARCHAR(30)
		,ELECTRODE_TYPE				NVARCHAR(30)
		,TRANSPORT_MODE				NVARCHAR(128)
		,ITEM_VALUE					NUMERIC(20,10)
	)

	IF @p_plan_start_yyyymmdd >= @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_FG_VALUE
		SELECT F.YYYYMMDD
			 , X.DIVISION_ID
			 , X.BIZ_TYPE
			 , X.PROJECT_CODE
			 , X.ITEM_ID
			 , X.TO_SITE
			 , X.FROM_SITE
			 , X.INCOTERMS
			 , X.BOD_ID
			 , X.MEASURE
			 , ISNULL(NULLIF(F.ORIGIN_FROM_DIVISION_ID,''),'-') AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(F.ORIGIN_TO_DIVISION_ID,''),'-')	AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(F.ELECTRODE_TYPE,''),'-')			AS ELECTRODE_TYPE
			 , X.TRANSPORT_MODE
			 , F.QTY AS ITEM_VALUE
		  
		  FROM #TMP_SCP0009_STD X
  
		  --JOIN SCP_ANL_SHIPMENT_PLAN_FG F WITH(NOLOCK INDEX(PK_SCP_ANL_SHIPMENT_PLAN_FG))
		  INNER MERGE JOIN SCP_ANL_SHIPMENT_PLAN_FG F WITH(NOLOCK INDEX(PK_SCP_ANL_SHIPMENT_PLAN_FG))

		     -- BOD 2단계 개발 : VIEW 수정
/*		  LEFT JOIN SCP_MST_BOD_N_V C
			ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN F.ORIGIN_FROM_DIVISION_ID ELSE F.DIVISION_ID END )= C.DIVISION_ID 
		   AND F.BOD_ID		= C.BOD_ID 
		   AND F.FROM_SITE	= C.FROM_SITE*/
		  LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			ON F.DIVISION_ID = C.DIVISION_ID 
		   AND F.BOD_ID		 = C.BOD_ID
		   AND F.FROM_SITE	 = C.FROM_SITE
		   AND C.PLAN_SEQ    = @p_seq
		   AND C.PLAN_TYPE   = @p_plan_type
		   AND C.PLAN_NAME   = @p_plan_start_yyyymmdd
		   
			ON X.DIVISION_ID			= F.DIVISION_ID
		   AND X.PLAN_START_YYYYMMDD	= F.PLAN_START_YYYYMMDD
		   AND X.PLAN_TYPE				= F.PLAN_TYPE
		   AND X.SEQ					= F.SEQ
		   AND X.BIZ_TYPE				= F.BIZ_TYPE
		   AND X.ITEM_ID				= F.ITEM_ID
		   AND X.PROJECT_CODE			= F.PROJECT_CODE
		   AND X.TO_SITE				= F.TO_SITE
		   AND X.INCOTERMS				= F.INCOTERMS
		   AND X.FROM_SITE				= F.FROM_SITE
		   AND X.BOD_ID					= F.BOD_ID
		   AND X.MEASURE				= F.MEASURE
		   AND ISNULL(X.TRANSPORT_MODE,'-') = ISNULL(C.TRANSPORT_MODE,'-')

		 WHERE F.YYYYMMDD				>= @p_from_yyyymmdd
		   AND F.YYYYMMDD				<= @p_to_yyyymmdd
		   AND F.DIVISION_ID			= @p_division_id
		   AND F.BIZ_TYPE				= @p_biz_type
		   AND F.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
		   AND F.PLAN_TYPE				= @p_plan_type
		   AND F.SEQ					= @p_seq
		   AND F.QTY					<> 0 
		;
	END
	ELSE IF @p_plan_start_yyyymmdd < @v_min_yyyymmdd
	BEGIN
		INSERT #TMP_SCP0009_FG_VALUE
		SELECT F.YYYYMMDD
			 , X.DIVISION_ID
			 , X.BIZ_TYPE
			 , X.PROJECT_CODE
			 , X.ITEM_ID
			 , X.TO_SITE
			 , X.FROM_SITE
			 , X.INCOTERMS
			 , X.BOD_ID
			 , X.MEASURE
			 , ISNULL(NULLIF(F.ORIGIN_FROM_DIVISION_ID,''),'-') AS ORIGIN_FROM_DIVISION_ID
			 , ISNULL(NULLIF(F.ORIGIN_TO_DIVISION_ID,''),'-')	AS ORIGIN_TO_DIVISION_ID
			 , ISNULL(NULLIF(F.ELECTRODE_TYPE,''),'-')			AS ELECTRODE_TYPE
			 , X.TRANSPORT_MODE
			 , F.QTY AS ITEM_VALUE
		  
		  FROM #TMP_SCP0009_STD X
  
		  JOIN HIST_SCP_ANL_SHIPMENT_PLAN_FG F WITH(NOLOCK INDEX(PK_HIST_SCP_ANL_SHIPMENT_PLAN_FG))

		  -- BOD 2단계 개발 : VIEW 수정
/*		  LEFT JOIN SCP_MST_BOD_N_V C 
			ON ( CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN F.ORIGIN_FROM_DIVISION_ID ELSE F.DIVISION_ID END )= C.DIVISION_ID 
		   AND F.BOD_ID		= C.BOD_ID 
		   AND F.FROM_SITE	= C.FROM_SITE*/
		  LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H C WITH(NOLOCK)
			ON F.DIVISION_ID = C.DIVISION_ID 
		   AND F.BOD_ID		= C.BOD_ID 
		   AND F.FROM_SITE	= C.FROM_SITE
		   AND C.PLAN_SEQ   = @p_seq
		   AND C.PLAN_TYPE  = @p_plan_type
		   AND C.PLAN_NAME  = @p_plan_start_yyyymmdd
		   
			ON X.DIVISION_ID			= F.DIVISION_ID
		   AND X.PLAN_START_YYYYMMDD	= F.PLAN_START_YYYYMMDD
		   AND X.PLAN_TYPE				= F.PLAN_TYPE
		   AND X.SEQ					= F.SEQ
		   AND X.BIZ_TYPE				= F.BIZ_TYPE
		   AND X.ITEM_ID				= F.ITEM_ID
		   AND X.PROJECT_CODE			= F.PROJECT_CODE
		   AND X.TO_SITE				= F.TO_SITE
		   AND X.INCOTERMS				= F.INCOTERMS
		   AND X.FROM_SITE				= F.FROM_SITE
		   AND X.BOD_ID					= F.BOD_ID
		   AND X.MEASURE				= F.MEASURE
		   AND ISNULL(X.TRANSPORT_MODE,'-') = ISNULL(C.TRANSPORT_MODE,'-')

		 WHERE F.YYYYMMDD				>= @p_from_yyyymmdd
		   AND F.YYYYMMDD				<= @p_to_yyyymmdd
		   AND F.DIVISION_ID			= @p_division_id
		   AND F.BIZ_TYPE				= @p_biz_type
		   AND F.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
		   AND F.PLAN_TYPE				= @p_plan_type
		   AND F.SEQ					= @p_seq
		   AND F.QTY					<> 0 
		;

	END



	PRINT '3. Make Plan_1 End. '+CONVERT(CHAR(23), GETDATE(), 21);

	-- ##############################################################################
	-- 0값 데이터로 누락된 MEASURE 를 생성한다.
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_ADD_MEASURE') IS NOT NULL
			DROP TABLE #TMP_SCP0009_ADD_MEASURE ;

	SELECT ISNULL(X.YYYYMMDD,@v_from_yyyymmdd) AS YYYYMMDD
		, T.DIVISION_ID
		, T.BIZ_TYPE
		, T.PROJECT_CODE
		, T.ITEM_ID
		, T.FROM_SITE
		, T.TO_SITE
		, T.INCOTERMS
		, T.MEASURE
		, T.ORIGIN_FROM_DIVISION_ID
		, T.ORIGIN_TO_DIVISION_ID
		, T.ELECTRODE_TYPE
		, T.BOD_ID
		, T.LT_DAY
		, T.TRANSPORT_MODE
		, T.MEASURE_LABEL
		, T.MEASURE_ORDER_NO
		, ISNULL(X.ITEM_VALUE,0) AS ITEM_VALUE
	 INTO #TMP_SCP0009_ADD_MEASURE
	 FROM (
			SELECT A.DIVISION_ID
				 , A.BIZ_TYPE
				 , A.PROJECT_CODE
				 , A.ITEM_ID
				 , A.TO_SITE
				 , A.FROM_SITE
				 , A.INCOTERMS
				 , A.BOD_ID
				 , M.COLUMN_NAME AS MEASURE
				 , A.ORIGIN_FROM_DIVISION_ID
				 , A.ORIGIN_TO_DIVISION_ID
				 , A.ELECTRODE_TYPE
				 , A.TRANSPORT_MODE
				 , A.LT_DAY
				 , A.MEASURE_LABEL
				 , A.MEASURE_ORDER_NO
			  FROM #TMP_SCP0009_STD A
			   LEFT JOIN ( SELECT COLUMN_NAME
							 FROM #TMP_SCP0009_MEASURE
						) M
				ON M.COLUMN_NAME = A.MEASURE
			) T
	 LEFT JOIN #TMP_SCP0009_FG_VALUE X
	   ON T.DIVISION_ID		= X.DIVISION_ID
	  AND T.PROJECT_CODE	= X.PROJECT_CODE
	  AND T.ITEM_ID			= X.ITEM_ID
	  AND T.FROM_SITE		= X.FROM_SITE
	  AND T.TO_SITE			= X.TO_SITE
	  AND T.MEASURE			= X.MEASURE
	  AND T.ORIGIN_FROM_DIVISION_ID		= X.ORIGIN_FROM_DIVISION_ID
	  AND T.ORIGIN_TO_DIVISION_ID		= X.ORIGIN_TO_DIVISION_ID
	  AND T.ELECTRODE_TYPE				= X.ELECTRODE_TYPE
	  AND ISNULL(T.INCOTERMS,'-')		= ISNULL(X.INCOTERMS,'-')
	  AND ISNULL(T.TRANSPORT_MODE,'-')	= ISNULL(X.TRANSPORT_MODE,'-')
	  AND ISNULL(T.BOD_ID,'-')			= ISNULL(X.BOD_ID,'-') -- BOD 2단계 개발 : 조건 추가
	;

	PRINT '4. Make Plan_2 End. '+CONVERT(CHAR(23), GETDATE(), 21);

--TESTING : OK
--select * from #TMP_SCP0009_STD;return;

--TESTING : OK
--select * from #TMP_SCP0009_ADD_MEASURE;return;

	-- ##############################################################################
	-- 최종 Plan Data 생성
	-- ##############################################################################
	IF OBJECT_ID('tempdb..#TMP_SCP0009_PLAN') IS NOT NULL
		DROP TABLE #TMP_SCP0009_PLAN ;

	SELECT (A.DIVISION_ID + A.BIZ_TYPE + A.PROJECT_CODE  + A.ITEM_ID + A.TO_SITE + A.INCOTERMS ) as key_idx
		 , A.DIVISION_ID
		 , A.BIZ_TYPE
		 , A.PROJECT_CODE
		 , A.ITEM_ID
		 , A.FROM_SITE
		 , A.TO_SITE
		 , CASE WHEN RIGHT(A.TO_SITE,2) = '-S' THEN LEFT(A.TO_SITE , LEN(A.TO_SITE) - 2) ELSE A.TO_SITE END TO_SITE2
		 , A.INCOTERMS
		 , A.MEASURE
		 , A.ORIGIN_FROM_DIVISION_ID
		 , A.ORIGIN_TO_DIVISION_ID
		 , A.ELECTRODE_TYPE
		 , A.ITEM_VALUE					AS QTY
		 , A.BOD_ID
		 , ISNULL(B.FROM_YYYYMMDD,'-')	AS BOD_FROM_YYYYMMDD
		 , ISNULL(B.TO_YYYYMMDD,'-')	AS BOD_TO_YYYYMMDD
		 , A.LT_DAY
		 , A.TRANSPORT_MODE
		 , A.MEASURE_LABEL
		 , A.MEASURE_ORDER_NO
		 , @p_from_yyyymmdd				AS FROM_YYYYMMDD
		 , @p_to_yyyymmdd				AS TO_YYYYMMDD
		 , @p_plan_start_yyyymmdd		AS PLAN_START_YYYYMMDD
		 , @p_plan_type					AS PLAN_TYPE
		 , @p_seq						AS SEQ
		 , 'D_'+A.yyyymmdd				AS YYYYMMDD
		 , C.basis_yyyymm				AS YYYYMM
		 , RIGHT(C.BASIS_YYYYMM, 4) + C.iso_week	AS ISO_WEEK
	  INTO #TMP_SCP0009_PLAN
	  FROM #TMP_SCP0009_ADD_MEASURE A
	  
	 INNER JOIN SCM_SYS_CALENDAR_M C 
	    ON A.YYYYMMDD = C.BASIS_YYYYMMDD

/*	  LEFT JOIN SCP_MST_BOD_N_V B WITH(NOLOCK)
	    ON A.BOD_ID		= B.BOD_ID*/
	  LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H B WITH(NOLOCK)
	    ON A.DIVISION_ID = B.DIVISION_ID
	   AND A.BOD_ID		 = B.BOD_ID
	   AND B.PLAN_SEQ 	 = @p_seq
	   AND B.PLAN_TYPE 	 = @p_plan_type
	   AND B.PLAN_NAME   = @p_plan_start_yyyymmdd   
	;

	PRINT '5. Make Plan_3 End. '+CONVERT(CHAR(23), GETDATE(), 21);

    
--TESTING : OK
--select * from #TMP_SCP0009_PLAN;return;


	PRINT '======================== Result Start ==============================='
print '@p_from_yyyymmdd : ' + @p_from_yyyymmdd;
print '@p_to_yyyymmdd : ' + @p_to_yyyymmdd;
print '@V_FROM_RESULT : ' + @V_FROM_RESULT;
print '@V_TO_RESULT : ' + @V_TO_RESULT;

	-- 실적 포함 시
    set @v_RSLT_FLAG = 'Y'
    IF(@v_RSLT_FLAG = 'Y')
	BEGIN

		-- ##############################################################################
		-- Shipment Plan (Auto & Ess) 기준 실적 가져온다. by 고C, 장C
		-- ##############################################################################

		IF OBJECT_ID('tempdb..#TMP_SCP0009_RSLT_TMP') IS NOT NULL
			DROP TABLE #TMP_SCP0009_RSLT_TMP;

		WITH RESULT_ERP_C_EXIST AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       E.CONFIRM_ID              AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       E.PROJECT_CODE            AS PROJECT_CODE
			,       SUM(E.EXFACTORY_QTY )     AS RESULT_QTY

			,       E.TO_SCM_SITE_ID AS TO_SITE -- 20220316 수정
			,       E.ITEM_ID        AS ITEM_ID -- 20240627 E20240612-001030 실제 Item ID 로 조회
			 
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
					ON L.LOOKUP_TYPE = 'ERP_SSP_TYPE' -- LOOKUP에 등록된 공정만 
				AND L.VALID_YN = 'Y'
				AND L.SEGMENT1    = E.SSP_TYPE

				JOIN scm_mst_site ms WITH(NOLOCK)
				   ON E.DIVISION_ID = ms.DIVISION_ID
				AND E.FROM_SCM_SITE_ID = ms.SCM_SITE_ID
				AND ms.OSP_YN = 'N'

			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   E.CONFIRM_ID LIKE 'C%'
			AND E.EXFACTORY_DATE	 >= convert(datetime, @V_FROM_RESULT)
			AND E.EXFACTORY_DATE	 < convert(datetime, @V_TO_RESULT )
				
			GROUP BY E.DIVISION_ID 
			,        E.CONFIRM_ID
			,        E.ORDER_NO
			,        E.EXFACTORY_DATE
			, E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,        E.PROJECT_CODE
			,        E.TO_SCM_SITE_ID  -- 20220316 수정
			,        E.ITEM_ID         -- 20240627 E20240612-001030 실제 Item ID 로 조회

			-- 2022.06.09
			UNION ALL

			-- SCS (외주) 실적
			/*--------------------------------------------------------------------------
			 1. PR_SSP_XIF_SCS_SHIP_RSLT_SUM_R  // SCM_DNM_SCS_SHIP_RESULT  i/f 테이블			 
			   , ATTR_05		AS CNFM_ID   -- confirm_id
				, MAX(ATTR_04)  AS SHIP_TO
				, MAX(ATTR_08)  AS TRANS_MODE
				, MAX(ATTR_09)  AS INCOTERMS
			---------------------------------------------------------------------------*/
			SELECT      E.DIVISION_ID             AS DIVISION_ID
				,       ISNULL(E.ATTRIBUTE5,'-')  AS CONFIRM_ID
				,       '-' 				      AS ERP_SO_NO 
				,       E.SHIP_DATE               AS YYYYMMDD
				,       ISNULL(C.TRANSPORT_MODE,'-')  AS TRANSPORT_MODE
				,       ISNULL(C.INCOTERMS,'-')   AS INCOTERMS
				,		C.ETA_DATE				  AS ETA_DATE
				,		C.ETD_DATE 				  AS ETD_DATE
				,       ISNULL(C.PROJECT_CODE,'-')   AS PROJECT_CODE
				,       SUM(E.SHIP_QTY )          AS RESULT_QTY
				,       E.TO_SITE                 AS TO_SITE
			    ,       E.ITEM_ID                 AS ITEM_ID -- 20240627 E20240612-001030 실제 Item ID 로 조회
				  
			FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
				JOIN SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON   F.ITEM_ID = E.ITEM_ID 
				AND  F.DIVISION_ID = E.DIVISION_ID
		
				JOIN SCM_MST_SITE FS WITH(NOLOCK)
				ON   FS.SCM_SITE_ID = E.SCM_SITE_ID 
				AND  FS.DIVISION_ID = E.DIVISION_ID
				AND  FS.OSP_YN = 'Y'

				--JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)  --2022-08-19
				LEFT JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				ON   E.DIVISION_ID	   = C.DIVISION_ID
				AND  E.PACK_MODEL_CODE = C.ITEM_ID 
				AND  E.SCM_SITE_ID     = C.FROM_SITE
				AND  E.TO_SITE         = C.TO_SITE
				AND  E.ATTRIBUTE5      = C.CONFIRM_ID


			WHERE 1=1
				AND E.ATTRIBUTE5 LIKE 'C%'  -- confirm_id
				AND E.SHIP_DATE  >= convert(datetime, @V_FROM_RESULT)
				AND E.SHIP_DATE	< convert(datetime, @V_TO_RESULT )

			GROUP BY 
						E.DIVISION_ID
			,        E.ATTRIBUTE5
			,        E.SHIP_DATE
			,        E.TO_SITE
			,        C.TRANSPORT_MODE
			,        C.INCOTERMS
			,        C.PROJECT_CODE
			,        C.ETA_DATE
			,        C.ETD_DATE
			,        E.ITEM_ID    -- 20240627 E20240612-001030 실제 Item ID 로 조회

		)
		, RESULT_ERP_C_NON AS 
		(
			-- ERP 출하실적에서 CONFIRM_ID 없는 실적 
			SELECT  E.DIVISION_ID             AS DIVISION_ID
			,       '-'                       AS CONFIRM_ID
			,       E.ORDER_NO				  AS ERP_SO_NO 
			,       E.FROM_SCM_SITE_ID        AS FROM_SITE                                                                    
			,       ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID)     AS TO_SITE   
			,       E.ITEM_ID                 AS ITEM_ID
			,       E.EXFACTORY_DATE          AS YYYYMMDD
			,       E.TRANSPORT_MODE		  AS TRANSPORT_MODE
			,       E.INCOTERMS				  AS INCOTERMS
			,		E.ETA_DATE				  AS ETA_DATE
			,		E.ETD_DATE				  AS ETD_DATE
			,       E.PROJECT_CODE            AS PROJECT_CODE
			,       SUM(E.EXFACTORY_QTY )     AS QTY  
			FROM [DBO].[SCM_DNM_EXFACTORY_RESULT] E WITH(NOLOCK)
				JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON F.ITEM_ID = E.ITEM_ID 
				AND F.DIVISION_ID = E.DIVISION_ID
				JOIN   SCM_MST_SITE FS WITH(NOLOCK)
					ON FS.SCM_SITE_ID = E.FROM_SCM_SITE_ID 
				   AND FS.DIVISION_ID = E.DIVISION_ID
				   AND FS.OSP_YN = 'N'
				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L3 WITH(NOLOCK)
						ON L3.LOOKUP_TYPE = 'SHIP_RESULT_TO_SITE_MAPPING' --SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE 
					AND L3.SEGMENT1    = E.DIVISION_ID 
					AND L3.SEGMENT2    = E.SOLDTO_CODE
					AND L3.SEGMENT3    = E.SHIPTO_CODE					    
			WHERE 1=1
			AND   ISNULL(E.EXFACTORY_STATUS,'D90') NOT IN ('D90' ,'D10') -- D90: DO삭제 , D10:DO생성 
			AND   ISNULL(E.CONFIRM_ID,'') NOT LIKE 'C%'
			AND   E.EXFACTORY_DATE BETWEEN  @p_from_yyyymmdd  AND @p_to_yyyymmdd
			AND   E.STORAGE_ID NOT IN ('6000' ,'799A') --상품창고제외
			AND   E.STORAGE_ID NOT IN (SELECT SEGMENT1 
										 FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
										WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
										  AND VALID_YN = 'Y'
									  )	-- 사외 창고 제외 LOOKUP 관리
			AND E.ORDER_TYPE_CODE NOT IN (SELECT SEGMENT1 
									FROM SCM_ADM_LOOKUP_MASTER_DETAIL 
									WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE'
										AND VALID_YN = 'Y'
									)	-- ERP오더타입 제외 LOOKUP 관리

			-- 추가
			AND E.EXFACTORY_DATE	 >= convert(datetime, @V_FROM_RESULT)
			AND E.EXFACTORY_DATE	 < convert(datetime, @V_TO_RESULT )

			GROUP BY E.DIVISION_ID
			,        E.ORDER_NO
			,        E.FROM_SCM_SITE_ID                                                                           
			,        ISNULL(L3.SEGMENT4, E.TO_SCM_SITE_ID) 
			,        E.ITEM_ID
			,        E.EXFACTORY_DATE
			,        E.TRANSPORT_MODE
			,        E.INCOTERMS		
			,		 E.ETA_DATE		
			,		 E.ETD_DATE
			,        E.PROJECT_CODE

			-- 2022.06.09
			UNION ALL

			SELECT      E.DIVISION_ID             AS DIVISION_ID
				,       '-'                       AS CONFIRM_ID
				,       '-' 				      AS ERP_SO_NO
				,       E.SCM_SITE_ID             AS FROM_SITE
				,       E.TO_SITE                 AS TO_SITE
				,       E.ITEM_ID                 AS ITEM_ID
				,       E.SHIP_DATE               AS YYYYMMDD
				,       ISNULL(C.TRANSPORT_MODE,'-')  AS TRANSPORT_MODE
				,       ISNULL(C.INCOTERMS,'-')   AS INCOTERMS
				,		C.ETA_DATE 				  AS ETA_DATE
				,		C.ETD_DATE 				  AS ETD_DATE
				,       ISNULL(C.PROJECT_CODE,'-')   AS PROJECT_CODE				
				,       SUM(E.SHIP_QTY )          AS QTY
				  
			FROM SCM_DNM_SCS_SHIP_RESULT E WITH(NOLOCK)
				JOIN  SCP_MST_FINAL_ITEM F WITH(NOLOCK) -- SCP 대상 ITEM만 
				ON F.ITEM_ID = E.ITEM_ID 
				AND F.DIVISION_ID = E.DIVISION_ID
		
				JOIN   SCM_MST_SITE FS WITH(NOLOCK)
				ON FS.SCM_SITE_ID = E.SCM_SITE_ID 
				AND FS.DIVISION_ID = E.DIVISION_ID
				AND FS.OSP_YN = 'Y'					
				
				--JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)  --2022-08-19
				LEFT JOIN SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK)
				ON   E.DIVISION_ID	   = C.DIVISION_ID
				AND  E.PACK_MODEL_CODE = C.ITEM_ID 
				AND  E.SCM_SITE_ID     = C.FROM_SITE
				AND  E.TO_SITE         = C.TO_SITE
				AND  E.ATTRIBUTE5      = C.CONFIRM_ID

			WHERE 1=1
				AND E.ATTRIBUTE5 NOT LIKE 'C%'  -- confirm_id
				AND E.SHIP_DATE  >= convert(datetime, @V_FROM_RESULT)
				AND E.SHIP_DATE	< convert(datetime, @V_TO_RESULT )

			GROUP BY 
						E.DIVISION_ID
			,        E.SCM_SITE_ID
			,        E.TO_SITE
			,        E.ITEM_ID
			,        E.SHIP_DATE
			,        C.TRANSPORT_MODE
			,        C.INCOTERMS
			,        C.PROJECT_CODE
			,        C.ETA_DATE
			,        C.ETD_DATE

		)
		 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
		, PLAN_SSP AS  
		(   -- SSP출하계획 ( confirm된 계획) 
			SELECT C.DIVISION_ID    AS DIVISION_ID
			,      C.ERP_SO_NO      AS ERP_SO_NO
			,      C.CONFIRM_ID     AS CONFIRM_ID 
			 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
			 --, c.item_id
            ,		CASE WHEN ISNULL(fi.packer_plan_item_id, '') = '' THEN C.ITEM_ID
						ELSE fi.packer_plan_item_id
					END item_id
			,      C.FROM_SITE      AS FROM_SITE 
			,      C.TO_SITE        AS TO_SITE 
			,      CASE WHEN C.DIVISION_ID= '4O' THEN ISNULL(SI.PROJECT_CODE,'-')    
						ELSE ISNULL(TS.END_CUSTOMER,'-')  END         AS END_CUSTOMER  
			,      C.QTY            AS QTY 
			,      C.YYYYMMDD       AS YYYYMMDD 
			,      C.TRANSPORT_MODE AS TRANSPORT_MODE
			,      C.INCOTERMS      AS INCOTERMS
			,      C.ETD_DATE       AS ETD_DATE
			,      C.ETA_DATE       AS ETA_DATE
			,	   NULL				AS SHIP_TYPE
			FROM [DBO].[SSP_ANL_SHIP_CONFIRM] C WITH(NOLOCK)	--SSP_ANL_SHIP_CONFIRM C WITH(NOLOCK) 
				 LEFT OUTER JOIN [dbo].[SCM_MST_SITE_ITEM] SI WITH(NOLOCK)	--SCM_MST_SITE_ITEM SI WITH(NOLOCK) 
							  ON SI.DIVISION_ID = C.DIVISION_ID
							 AND SI.ITEM_ID     = C.ITEM_ID 
							 AND SI.SCM_SITE_ID = C.TO_SITE
							 AND SI.PROJECT_CODE = C.PROJECT_CODE 
 				 LEFT OUTER JOIN [dbo].[SCM_MST_SITE] TS WITH(NOLOCK)	--SCM_MST_SITE TS WITH(NOLOCK) 
							  ON TS.DIVISION_ID = C.DIVISION_ID
							 AND TS.SCM_SITE_ID = C.TO_SITE
							 
				 -- 20220106 PJ20209643 소형 OSP Pack Item 처리
                 LEFT JOIN scp_mst_final_item fi WITH(NOLOCK) --2018.06.29
                      ON   C.division_id = fi.division_id
                      AND  C.item_id     = fi.item_id 
                      AND  fi.division_id = '40' 
			WHERE CHANGE_TYPE = 'C'
			--AND   QTY > 0  -- 2022-08-11
			AND C.BIZ_TYPE = @p_biz_type 
			AND C.DIVISION_ID = @p_division_id
			--AND C.YYYYMMDD >=	@V_FROM_RESULT
			--AND C.YYYYMMDD <	@V_TO_RESULT

		)	

		SELECT X.DIVISION_ID
		,      MS.COMPANY_ID AS COMPANY_ID
		,      L.SEGMENT2  AS TYPE 
		,	   X.ERP_SO_NO
		,      X.CONFIRM_ID 
		,      X.ITEM_ID 
		,      DBO.FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
		
		--* 2021.11.02   LWY
		--,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.FROM_SITE),X.FROM_SITE)   AS FROM_SITE 
		--,      ISNULL(dbo.FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID,X.TO_SITE),X.TO_SITE)       AS TO_SITE
		,      X.FROM_SITE  AS FROM_SITE 
		,      X.TO_SITE    AS TO_SITE
		
		 
		,      X.END_CUSTOMER  
		,      X.QTY 
		--,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.YYYYMMDD,112), 23) AS YYYYMMDD 
		,      X.YYYYMMDD  AS YYYYMMDD 
		,      X.TRANSPORT_MODE
		,      X.INCOTERMS
		,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETD_DATE,112), 23) AS ETD_DATE
		,      CONVERT(VARCHAR(10),   CONVERT(DATETIME, X.ETA_DATE,112), 23) AS ETA_DATE
		,	   X.SHIP_TYPE
		,      X.PROJECT_CODE

		INTO #TMP_SCP0009_RSLT_TMP

		FROM (
			--CONFIRM_ID ,날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 
			SELECT P.DIVISION_ID     AS DIVISION_ID
			,     'E'				 AS TYPE 
			,      R.ERP_SO_NO       AS ERP_SO_NO
			,      R.CONFIRM_ID      AS CONFIRM_ID 
			-- 20240627 E20240612-001030 실제 Item ID 로 조회
			,      R.ITEM_ID         AS ITEM_ID
			--,      P.ITEM_ID         AS ITEM_ID
			,      P.FROM_SITE       AS FROM_SITE 
	  	  
		  --,      P.TO_SITE         AS TO_SITE
			,      R.TO_SITE         AS TO_SITE  -- 20220316 수정

			,      NULL              AS END_CUSTOMER
			,      SUM(R.RESULT_QTY) AS QTY 
			,      R.YYYYMMDD        AS YYYYMMDD
			,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      R.INCOTERMS       AS INCOTERMS
			,      R.ETD_DATE        AS ETD_DATE
			,      R.ETA_DATE        AS ETA_DATE
			,      NULL				 AS SHIP_TYPE
			,      R.PROJECT_CODE    AS PROJECT_CODE
			FROM  PLAN_SSP P 
					JOIN RESULT_ERP_C_EXIST R 
					ON R.DIVISION_ID = P.DIVISION_ID 
					AND R.CONFIRM_ID = P.CONFIRM_ID 
					AND R.YYYYMMDD = P.YYYYMMDD 

			GROUP BY P.DIVISION_ID
			,		 R.ERP_SO_NO
			,        P.FROM_SITE                                                                           
		    --,        P.TO_SITE 
		    ,        R.TO_SITE   -- 20220316 수정
			-- 20240627 E20240612-001030 실제 Item ID 로 조회
			,        R.ITEM_ID
			--,        P.ITEM_ID
			,		 R.TRANSPORT_MODE			   
			,		 R.INCOTERMS
			,		 R.ETD_DATE
			,		 R.ETA_DATE		   
			,        R.YYYYMMDD 
			,        R.CONFIRM_ID
			,        R.PROJECT_CODE

		UNION ALL 

			--CONFIRM_ID ,기준으로 날짜가 다른 계획정보의 FROM, TO SITE기준으로 실적 집계
			SELECT P.DIVISION_ID     AS DIVISION_ID
			,     'E'                AS TYPE 
			,      R.ERP_SO_NO       AS ERP_SO_NO
			,      R.CONFIRM_ID      AS CONFIRM_ID 
			-- 20240627 E20240612-001030 실제 Item ID 로 조회
			,      R.ITEM_ID         AS ITEM_ID
			--,      P.ITEM_ID         AS ITEM_ID 
			,      P.FROM_SITE       AS FROM_SITE 
		  --,      P.TO_SITE         AS TO_SITE
			,      R.TO_SITE         AS TO_SITE  -- 20220316 수정
			,      NULL              AS END_CUSTOMER
			,      SUM(R.RESULT_QTY) AS QTY 
			,      R.YYYYMMDD        AS YYYYMMDD 
			,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      R.INCOTERMS       AS INCOTERMS
			,      R.ETD_DATE        AS ETD_DATE
			,      R.ETA_DATE        AS ETA_DATE
			,      NULL				 AS SHIP_TYPE
			,      R.PROJECT_CODE    AS PROJECT_CODE
			FROM  PLAN_SSP P 
					JOIN RESULT_ERP_C_EXIST R 
					ON R.DIVISION_ID = P.DIVISION_ID 
					AND R.CONFIRM_ID = P.CONFIRM_ID 
					AND R.YYYYMMDD <> P.YYYYMMDD 
			GROUP BY P.DIVISION_ID
			,	     R.ERP_SO_NO
			,        P.FROM_SITE                                                                   
		  --,        P.TO_SITE 
		    ,        R.TO_SITE   -- 20220316 수정 
			-- 20240627 E20240612-001030 실제 Item ID 로 조회
			,        R.ITEM_ID
			--,        P.ITEM_ID 
			,		 R.TRANSPORT_MODE			   
			,		 R.INCOTERMS
			,		 R.ETD_DATE
			,		 R.ETA_DATE			  
			,        R.YYYYMMDD 
			,        R.CONFIRM_ID
			,        R.PROJECT_CODE

		UNION ALL 

			--CONFIRM_ID 없는 실적 
			SELECT R.DIVISION_ID     AS DIVISION_ID
			,     'E'                AS TYPE 
			,      R.ERP_SO_NO       AS ERP_SO_NO
			,      NULL              AS CONFIRM_ID 
			,      R.ITEM_ID         AS ITEM_ID 
			,      R.FROM_SITE       AS FROM_SITE 
			,      R.TO_SITE         AS TO_SITE 
			,      NULL              AS END_CUSTOMER
			,      R.QTY             AS QTY 
			,      R.YYYYMMDD        AS YYYYMMDD 
			,      R.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      R.INCOTERMS       AS INCOTERMS
			,      R.ETD_DATE        AS ETD_DATE
			,      R.ETA_DATE        AS ETA_DATE
			,      NULL              AS SHIP_TYPE
			,      R.PROJECT_CODE    AS PROJECT_CODE
			FROM  RESULT_ERP_C_NON R 

		UNION ALL
  
			SELECT P.DIVISION_ID     AS DIVISION_ID
			,     'P'                AS TYPE 
			,      P.ERP_SO_NO       AS ERP_SO_NO
			,      P.CONFIRM_ID      AS CONFIRM_ID 
			,      P.ITEM_ID         AS ITEM_ID 
			,      P.FROM_SITE       AS FROM_SITE 
			,      P.TO_SITE         AS TO_SITE 
			,      P.END_CUSTOMER    AS END_CUSTOMER
			,      P.QTY             AS QTY 
			,      P.YYYYMMDD        AS YYYYMMDD 
			,      P.TRANSPORT_MODE  AS TRANSPORT_MODE
			,      P.INCOTERMS       AS INCOTERMS
			,      P.ETD_DATE        AS ETD_DATE
			,      P.ETA_DATE        AS ETA_DATE
			,      NULL              AS SHIP_TYPE
			,      NULL              AS PROJECT_CODE
			FROM  PLAN_SSP P 
			WHERE 1 = 1
			  AND P.YYYYMMDD >= convert(datetime, @V_FROM_RESULT)
			  AND P.YYYYMMDD  < convert(datetime, @V_TO_RESULT )

		) X
			JOIN SCM_MST_SITE MS WITH(NOLOCK) 
			  ON MS.DIVISION_ID = X.DIVISION_ID 
			 AND MS.SCM_SITE_ID = X.FROM_SITE  
			 AND MS.OPERATION_GROUP <> 'E'
			JOIN SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)
   			  ON L.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE' -- LOOKUP에 등록된 공정만 
			 AND L.SEGMENT1 = X.TYPE 
			 AND L.VALID_YN = 'Y'
			LEFT OUTER JOIN SSP_MST_MODEL_USER M WITH(NOLOCK) 
						ON  M.DIVISION_ID = X.DIVISION_ID 
						and M.FROM_SITE = X.FROM_SITE 
						and M.ITEM_ID = X.ITEM_ID 
						and M.VALID_YN = 'Y'
		WHERE 1=1
		AND   X.DIVISION_ID = @p_division_id
		AND   X.TYPE = 'E'  -- Result(ERP)
		;
	
--TESTING - OK
--select * from #TMP_SCP0009_RSLT_TMP;return;

		PRINT '6. Make Rslt Temp End. '+CONVERT(CHAR(23), GETDATE(), 21);

		-- ##############################################################################
		-- Final 실적정보 생성
		-- ##############################################################################

		IF OBJECT_ID('tempdb..#TMP_SCP0009_RSLT') IS NOT NULL
			DROP TABLE #TMP_SCP0009_RSLT;

	
		-- Final Result
		SELECT   (R.DIVISION_ID + @p_biz_type + ISNULL(R.PROJECT_CODE,'-')  + ISNULL(R.ITEM_ID,'-') + ISNULL(R.TO_SITE,'-') + ISNULL(R.INCOTERMS,'-') ) as key_idx
		    
				, R.DIVISION_ID
				, R.BIZ_TYPE
				, R.PROJECT_CODE
				, R.ITEM_ID
				
				, R.FROM_SITE AS FROM_SITE
				, R.TO_SITE   AS TO_SITE
				, CASE WHEN RIGHT(R.TO_SITE,2) = '-S' THEN LEFT(R.TO_SITE , LEN(R.TO_SITE) - 2) ELSE R.TO_SITE END TO_SITE2

				, R.INCOTERMS
				, R.MEASURE
				, R.DIVISION_ID	AS ORIGIN_FROM_DIVISION_ID
				, R.DIVISION_ID	AS ORIGIN_TO_DIVISION_ID
				, ISNULL(NULLIF(B.ELECTRODE_TYPE,''),'-')	AS ELECTRODE_TYPE
				, R.QTY
				, ISNULL(NULLIF(R.BOD_ID,''),'-')			AS BOD_ID
				, ISNULL(R.BOD_FROM_YYYYMMDD,'-')			AS BOD_FROM_YYYYMMDD
				, ISNULL(R.BOD_TO_YYYYMMDD,'-')				AS BOD_TO_YYYYMMDD
				, ISNULL(NULLIF(B.LT_DAY,''),'-')			AS LT_DAY
				, R.TRANSPORT_MODE
				, R.MEASURE_LABEL
				, ISNULL(NULLIF(M.MEASURE_ORDER_NO,''),'-')	AS MEASURE_ORDER_NO
				, @p_from_yyyymmdd							AS FROM_YYYYMMDD
				, @p_to_yyyymmdd							AS TO_YYYYMMDD
				, @p_plan_start_yyyymmdd					AS PLAN_START_YYYYMMDD
				, @p_plan_type								AS PLAN_TYPE
				, @p_seq									AS SEQ
				, 'D_'+R.EXFACTORY_DATE						AS YYYYMMDD
				, C.basis_yyyymm							AS YYYYMM
				, RIGHT(C.BASIS_YYYYMM, 4) + C.iso_week		AS ISO_WEEK

		  INTO #TMP_SCP0009_RSLT
	  
		  FROM (	
				SELECT    
						  R.DIVISION_ID
						, @p_biz_type AS BIZ_TYPE
						, R.PROJECT_CODE
						, R.ITEM_ID
						, R.FROM_SITE
						, R.TO_SITE
						, R.INCOTERMS
						, 'SHIP_PLAN_AMEND' AS MEASURE                     -- SHIP_PLAN_AMEND 가   SHIP_PLAN 보다 문자열 길어서 TEMP INSERT 시 오류 때문에 순서바꿈 
						, R.DIVISION_ID		AS ORIGIN_FROM_DIVISION_ID
						, R.DIVISION_ID		AS ORIGIN_TO_DIVISION_ID
						, R.TRANSPORT_MODE
						, 'Ship Plan Amend'	AS MEASURE_LABEL
						, R.YYYYMMDD		AS EXFACTORY_DATE	-- EXFACTORY_DATE
						, B.BOD_ID			AS BOD_ID		
						, B.FROM_YYYYMMDD	AS BOD_FROM_YYYYMMDD
						, B.TO_YYYYMMDD		AS BOD_TO_YYYYMMDD
						, SUM(R.QTY)		AS QTY				-- EXFACTORY_QTY

				 FROM #TMP_SCP0009_RSLT_TMP R
				 
				 -- BOD 2단계 개발 : VIEW 수정 및 FROM , TO 조건 추가
				 --LEFT JOIN SCP_MST_BOD_N_V B
				    LEFT JOIN SCP_ANL_BOD_N_V_PLAN_H B WITH(NOLOCK)
					  --ON R.DIVISION_ID	= (CASE WHEN @P_DIVISION_ID IN ('EE','EE_UC') THEN B.ORG_DIVISION_ID ELSE B.DIVISION_ID END )
					  ON R.DIVISION_ID	= (CASE WHEN @P_DIVISION_ID IN (SELECT DIVISION_ID FROM dbo.FN_GET_DIVISION_DIV('EE')) THEN B.ORG_DIVISION_ID ELSE B.DIVISION_ID END ) --div_commonization
					 AND R.FROM_SITE		= B.FROM_SITE
					 AND R.TO_SITE			= B.TO_SITE
					 AND R.TRANSPORT_MODE   = B.TRANSPORT_MODE
					 AND R.INCOTERMS        = B.INCOTERMS
					 AND R.YYYYMMDD			>= B.FROM_YYYYMMDD
					 AND R.YYYYMMDD			<= B.TO_YYYYMMDD
					 AND B.DIVISION_ID      = @P_DIVISION_ID
					 AND B.PLAN_TYPE        = @P_PLAN_TYPE
					 AND B.PLAN_SEQ         = @P_SEQ
	   				 AND B.PLAN_NAME        = @p_plan_start_yyyymmdd
	   				 
				GROUP BY  R.DIVISION_ID		
						, R.PROJECT_CODE
						, R.ITEM_ID
						, R.FROM_SITE
						, R.TO_SITE
						, R.INCOTERMS
						, R.TRANSPORT_MODE
						, R.YYYYMMDD
						, B.BOD_ID
						, B.FROM_YYYYMMDD
						, B.TO_YYYYMMDD
				) R

				INNER JOIN #TMP_SCP0009_MEASURE M
				ON R.MEASURE = M.COLUMN_NAME
				JOIN scm_sys_calendar_m C 
				on convert(nvarchar(8), R.EXFACTORY_DATE, 112)  = C.basis_yyyymmdd
				--JOIN SCM_MST_FINAL_ITEM_V D 
				--ON  R.DIVISION_ID = D.DIVISION_ID 
				--AND R.ITEM_ID = D.ITEM_ID 
				--AND D.OPERATION_GROUP_ID IN (SELECT TOKEN FROM DBO.STRING_SPLIT(@V_OPERATION_GROUP_ID, ','))
				LEFT JOIN #TMP_SCP0009_STD B 
				 on 1 = 1
				AND R.BOD_ID       = B.BOD_ID
				AND R.item_id	   = B.item_id
				AND R.PROJECT_CODE = B.PROJECT_CODE
				--AND 'SHIP_PLAN' = B.MEASURE

				-- 2021.12.02   LWY
				AND R.MEASURE = B.MEASURE
			;
		
		PRINT '7. Make Rslt End. '+CONVERT(CHAR(23), GETDATE(), 21);

--TESTING - OK
--select * from #TMP_SCP0009_RSLT;return;
--select * from #TMP_SCP0009_RSLT where MEASURE = 'SHIP_PLAN_AMEND';return;

		-- ##############################################################################
		-- SHIP_PLAN_AMEND -> SHIP_PLAN  Copy.......
		-- ##############################################################################

		 INSERT INTO #TMP_SCP0009_RSLT
		 SELECT 
			  key_idx
			, DIVISION_ID
			, BIZ_TYPE
			, PROJECT_CODE
			, ITEM_ID
			, FROM_SITE
			, TO_SITE
			, TO_SITE2
			, INCOTERMS
			, 'SHIP_PLAN'			 -- MEASURE
			, ORIGIN_FROM_DIVISION_ID
			, ORIGIN_TO_DIVISION_ID
			, ELECTRODE_TYPE
			, QTY
			, BOD_ID
			, BOD_FROM_YYYYMMDD		-- BOD 2단계
			, BOD_TO_YYYYMMDD		-- BOD 2단계
			, LT_DAY
			, TRANSPORT_MODE
			, 'Ship Plan'			 -- MEASURE LABEL
			, M.MEASURE_ORDER_NO
			, FROM_YYYYMMDD
			, TO_YYYYMMDD
			, PLAN_START_YYYYMMDD
			, PLAN_TYPE
			, SEQ
			, YYYYMMDD
			, YYYYMM
			, ISO_WEEK
	   
		   FROM #TMP_SCP0009_RSLT R
		   CROSS APPLY(SELECT MEASURE_ORDER_NO     -- 1건
						 FROM #TMP_SCP0009_MEASURE
						 WHERE COLUMN_NAME = 'SHIP_PLAN') M
		 ;

		 PRINT '8. Copy Rslt SHIP_PLAN -> SHIP_PLAN_AMEND '+CONVERT(CHAR(23), GETDATE(), 21);	 


	END  -- IF(@v_RSLT_FLAG = 'Y')

--TESTING : OK
--select * from #TMP_SCP0009_RSLT where MEASURE = 'SHIP_PLAN_AMEND';return;
--select * from #TMP_SCP0009_PLAN where MEASURE = 'SHIP_PLAN_AMEND';return;
--select * from #TMP_SCP0009_PLAN;return;
	
	PRINT '======================== Result END   ==============================='

	IF OBJECT_ID('tempdb..#TMP_SCP0009_FNL_RSLT_PLAN') IS NOT NULL
		DROP TABLE #TMP_SCP0009_FNL_RSLT_PLAN ;

    IF (@p_is_plan = 'T') --계획
    BEGIN
        SELECT    ''                            AS VERSION_NO
                , A.PLAN_START_YYYYMMDD         AS CUTOFF_YYYYMMDD
                , A.DIVISION_ID
                , A.PROJECT_CODE
                , A.TO_SITE                     AS SCM_SITE_ID
                , A.FROM_SITE                   AS PLANT_SITE_ID
                , A.ITEM_ID
                , A.INCOTERMS
                , ''                            AS DOM_EXP
                , 'MPS'                         AS FCST_TYPE
                , 'RTF_SYS_RP'                  AS MEASURE
                , SUBSTRING(A.YYYYMMDD, 3, 8)   AS YYYYMMDD     -- 'D_yyyymmdd' 형태
                , A.QTY                         AS QTY
                , A.QTY                         AS CELL_QTY
                , 'Y'                           AS VALID_YN
                ,'P'                            AS PLAN_RESULT
                , 3                             AS GUBUN
                , ''                            AS CATEGORY_CODE
                , ''                            AS CATEGORY_NAME
                , ''                            AS CELL_TYPE
	    FROM    #TMP_SCP0009_PLAN A
        WHERE   MEASURE = 'SHIP_PLAN_AMEND'
            AND SUBSTRING(A.YYYYMMDD, 3, 8) >= @p_from_yyyymmdd
            AND SUBSTRING(A.YYYYMMDD, 3, 8) <= @p_to_yyyymmdd;
    END
    ELSE            --실적
    BEGIN
        SELECT    'CURRENT'                     AS VERSION_NO
                , @p_from_yyyymmdd              AS CUTOFF_YYYYMMDD
                , A.DIVISION_ID
                , A.PROJECT_CODE
                , A.TO_SITE                     AS SCM_SITE_ID
                , A.FROM_SITE                   AS PLANT_SITE_ID
                , A.ITEM_ID
                , A.INCOTERMS
                , ''                            AS DOM_EXP
                , 'MPS'                         AS FCST_TYPE
                , 'RTF_SYS_RP'                  AS MEASURE
                , SUBSTRING(A.YYYYMMDD, 3, 8)   AS YYYYMMDD     -- #TEMP_SCP0092_RESULT_FG_FIN.YYYYMMDD 는 'D_yyyymmdd' 형태. (바로 저장하면 '문자열이나 이진 데이터는 잘립니다' 에러 발생)
                , A.QTY                         AS QTY
                , A.QTY                         AS CELL_QTY
                , ''                            AS VALID_YN
                ,'R'                            AS PLAN_RESULT
                , 2                             AS GUBUN
                , ''                            AS CATEGORY_CODE
                , ''                            AS CATEGORY_NAME
                , ''                            AS CELL_TYPE
	    FROM    #TMP_SCP0009_RSLT A
        WHERE   MEASURE = 'SHIP_PLAN_AMEND'
            AND SUBSTRING(A.YYYYMMDD, 3, 8) >= @p_from_yyyymmdd
            AND SUBSTRING(A.YYYYMMDD, 3, 8) <= @p_to_yyyymmdd;
    END
END
