
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
/*
 * Program ID   : FN_SCP0104_GET_SPREAD_TITLE
 * Description  : CAPA NEW 날짜 타이틀 리턴 (SCP0104, SCP0105, SCP0106, SCP0107, SCP0108 공통)
 * Program History
 *================================================================================================================================================
 * Date         In Charge                          Description
 *================================================================================================================================================
 * 2023/10/12   chaan        V1.1.1                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Initial Release
 * 2024/07/11   chaan        V1.1.3                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - 3차 Update
 * 2024/07/22   chaan        V1.1.7                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Priority 포함 - 1.1.4 에서 배포 누락되어 1.1.7로 재배포
 * 2024/12/09   chaan        V1.1.8                PJ20230692  SCM 역량 강화 위한 SCP 개선과제 이행 Phase2     - Pre 버전 예외처리
 * 2025/02/09   mrchois      V1.1.8                PJ20249346  LGES SCP 개선과제 이행	 - (scp0106 Loss Plan UI 수정) Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정
*/

--CREATE FUNCTION [dbo].[FN_SCP0104_GET_SPREAD_TITLE]
CREATE FUNCTION [dbo].[FN_SCP0104_GET_SPREAD_TITLE]
(
	  @p_from_yyyymm		NVARCHAR(6)
	, @p_program_id			NVARCHAR(100)
	, @p_sheet_name			NVARCHAR(100)
)
RETURNS @TBL_RES TABLE
--DECLARE @TBL_RES TABLE
(
	  COLUMN_NAME				NVARCHAR(30)
	, COLUMN_LABEL_NAME			NVARCHAR(30)
	, SMALL_CLASS_LABEL_NAME	NVARCHAR(30)
	, LARGE_CLASS_LABEL_NAME	NVARCHAR(30)
	, DAY_CODE					NVARCHAR(30)
	, SORT_ORDER_NO				NVARCHAR(30)
)
BEGIN   
	--DECLARE @p_from_yyyymm			NVARCHAR(6)			= N'202411';
	--DECLARE @p_program_id			NVARCHAR(100)		= N'SCP0104';
	--DECLARE @p_sheet_name			NVARCHAR(100)		= N'';
	----DECLARE @p_from_yyyymm			NVARCHAR(6)			= N'202404';
	----DECLARE @p_program_id			NVARCHAR(100)		= N'SCP0105';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'ELTR';
	----DECLARE @p_program_id			NVARCHAR(100)		= N'SCP0106';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'CURRENT_ASSEMBLY';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'CUTOFF_MODEL';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'1ST_CUTOFF_LINE';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'2ND_CUTOFF_LINE';
	----DECLARE @p_program_id			NVARCHAR(100)		= N'SCP0107';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'ASSEMBLY';
	----DECLARE @p_program_id			NVARCHAR(100)		= N'SCP0108';
	----DECLARE @p_sheet_name			NVARCHAR(100)		= N'MAIN';



    SET @p_sheet_name = REPLACE(REPLACE(@p_sheet_name, '_ASSEMBLY', ''), '_ELTR', '');


	DECLARE @v_from_yyyy			NVARCHAR(4)		    = SUBSTRING(@p_from_yyyymm, 1, 4);
	DECLARE @v_to_yyyy_SCP0106		NVARCHAR(4)			= CONVERT(NVARCHAR(4), CONVERT(INT, @v_from_yyyy) + 1);		        -- SCP0106_GET_CAPA_LOSS_PLAN 은 앞에 2개년도를 월별로 추가
	DECLARE @v_to_yyyy_Monthly		NVARCHAR(4)			= CONVERT(NVARCHAR(4), CONVERT(INT, @v_from_yyyy) + 2);		        -- 처음 3년은 월별
	DECLARE @v_from_yyyy_Year		NVARCHAR(4)			= CONVERT(NVARCHAR(4), CONVERT(INT, @v_to_yyyy_Monthly) + 1);		-- 4~6년까지는 연도별'
	DECLARE @v_to_yyyy_Year			NVARCHAR(4)			= CONVERT(NVARCHAR(4), CONVERT(INT, @v_from_yyyy_Year) + 2);	    -- 4~6년까지는 연도별

	--PRINT CONCAT('@p_program_id : ', @p_program_id);
	--PRINT CONCAT('@p_sheet_name : ', @p_sheet_name);
	--PRINT CONCAT('@p_from_yyyymm : ', @p_from_yyyymm);
	--PRINT CONCAT('@v_from_yyyy : ', @v_from_yyyy);
	--PRINT CONCAT('@v_to_yyyy_SCP0106 : ', @v_to_yyyy_SCP0106);
	--PRINT CONCAT('@v_to_yyyy_Monthly : ', @v_to_yyyy_Monthly);
	--PRINT CONCAT('@v_from_yyyy_Year : ', @v_from_yyyy_Year);
	--PRINT CONCAT('@v_to_yyyy_Year : ', @v_to_yyyy_Year);
	--return;


    DECLARE @TBL_1 TABLE
    (
	      COLUMN_NAME				NVARCHAR(30)
	    , COLUMN_LABEL_NAME			NVARCHAR(30)
	    , SMALL_CLASS_LABEL_NAME	NVARCHAR(30)
	    , LARGE_CLASS_LABEL_NAME	NVARCHAR(30)
	    , DAY_CODE					NVARCHAR(30)
	    , SORT_ORDER_NO				NVARCHAR(30)
    )

    DECLARE @TBL_RPT_CODE TABLE
    (
	      PROGRAM_ID		        NVARCHAR(100)
	    , SHEET_NAME		        NVARCHAR(100)
	    , RPT_CODE_CD				NVARCHAR(100)
	    , RPT_CODE_NM				NVARCHAR(100)
	    , RPT_CODE_NM_KO			NVARCHAR(100)
    )

    INSERT INTO @TBL_RPT_CODE
    SELECT    A.SEGMENT1        AS PROGRAM_ID
            , A.SEGMENT2        AS SHEET_NAME
            , A.SEGMENT3        AS RPT_CODE_CD
            , A.SEGMENT4        AS RPT_CODE_NM
            , A.SEGMENT5        AS RPT_CODE_NM_KO
    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL A WITH(NOLOCK)
    WHERE   1=1
        AND A.LOOKUP_TYPE  = 'SCP_CAPA_RPT_CODE'
        AND A.VALID_YN     = 'Y'
        AND A.SEGMENT1     = @p_program_id
        AND A.SEGMENT2     = @p_sheet_name;

--TESTING : NOK
--select * from @TBL_RPT_CODE;return;

	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) START
	--IF (@p_program_id = 'SCP0106' AND @p_sheet_name = 'CURRENT') OR
 --      (@p_program_id = 'SCP0106' AND @p_sheet_name = 'CUTOFF_MODEL') -- SCP0106_GET_CAPA_LOSS_PLAN - Current, Model 은 앞에 2개년도를 월별로 추가
	--BEGIN
	--	INSERT INTO @TBL_1
	--	SELECT	  'M_00' + A.BASIS_YYYYMM	                                    AS COLUMN_NAME -- 동일 기간과 중복되므로 00/01 로 구분
	--			, A.MONTH_NAME				                                    AS COLUMN_LABEL_NAME
	--			, A.CALENDAR_YYYY				                                AS SMALL_CLASS_LABEL_NAME
	--			--, L.RPT_CODE_NM_KO 			                                    AS LARGE_CLASS_LABEL_NAME
	--			, L.RPT_CODE_NM 			                                    AS LARGE_CLASS_LABEL_NAME
	--			, ''	    			                                        AS DAY_CODE
	--			, CONCAT('00', MIN(A.BASIS_START_DATE), CONVERT(CHAR(2), '01')) AS SORT_ORDER_NO
	--	FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
 --               LEFT JOIN (
 --                           SELECT    TOP 1
 --                                     A.SHEET_NAME
 --                                   , A.RPT_CODE_CD
 --                                   , A.RPT_CODE_NM
 --                                   , A.RPT_CODE_NM_KO
 --                           FROM    @TBL_RPT_CODE A
 --                           WHERE   1=1
 --                               AND A.RPT_CODE_CD  = 'LOSS'
 --                         ) L ON 1=1
	--	WHERE	1=1
	--		AND A.CALENDAR_YYYY BETWEEN @v_from_yyyy AND @v_to_yyyy_SCP0106
	--	GROUP BY	  A.CALENDAR_YYYY
	--				, A.MONTH_NAME
 --                   , A.BASIS_YYYYMM
 --                   --, L.RPT_CODE_NM_KO
 --                   , L.RPT_CODE_NM
 --       ORDER BY	SORT_ORDER_NO;
	--END
	-- Improvement Rate 입력 영역을 제거하고 Operation Plan 에 Goal 직접 입력 형태로 수정(2025-02-06 mrchois) END

--TESTING : NOK
--select * from @TBL_1;return;

    IF @p_program_id IN ('SCP0104', 'SCP0105', 'SCP0106')
    BEGIN
	    INSERT INTO @TBL_1
	    SELECT	  'M_01' + A.BASIS_YYYYMM	                                        AS COLUMN_NAME  -- 동일 기간과 중복되므로 00/01 로 구분
			    , A.MONTH_NAME				                                        AS COLUMN_LABEL_NAME
			    , A.CALENDAR_YYYY				                                    AS SMALL_CLASS_LABEL_NAME
			    --, IIF(@p_program_id = 'SCP0106', L.RPT_CODE_NM_KO, 'ETC')		    AS LARGE_CLASS_LABEL_NAME
			    , L.RPT_CODE_NM                                                     AS LARGE_CLASS_LABEL_NAME
			    , ''	    			                                            AS DAY_CODE
			    , CONCAT('01', MIN(A.BASIS_START_DATE), CONVERT(CHAR(2), '01'))     AS SORT_ORDER_NO
	    FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                LEFT JOIN (
                            SELECT    A.SHEET_NAME
                                    , A.RPT_CODE_CD
                                    , A.RPT_CODE_NM
                                    , A.RPT_CODE_NM_KO
                            FROM    @TBL_RPT_CODE A
                            WHERE   1=1
                                AND A.RPT_CODE_CD  = 'PLAN'
                         ) L ON 1=1
	    WHERE	1=1
		    AND A.CALENDAR_YYYY BETWEEN @v_from_yyyy AND @v_to_yyyy_Monthly
	    GROUP BY	  CALENDAR_YYYY
                    , A.BASIS_YYYYMM
				    , A.MONTH_NAME
                    --, L.RPT_CODE_NM_KO
                    , L.RPT_CODE_NM
	    ORDER BY	  A.BASIS_YYYYMM
				    , A.MONTH_NAME;
    END
    ELSE IF @p_program_id IN ('SCP0107', 'SCP0108') --TEEP, LOB
    BEGIN
	    INSERT INTO @TBL_1
	    SELECT	  'M_01' + A.BASIS_YYYYMM	                                        AS COLUMN_NAME  -- 동일 기간과 중복되므로 00/01 로 구분
			    , A.MONTH_NAME				                                        AS COLUMN_LABEL_NAME
			    , A.CALENDAR_YYYY				                                    AS SMALL_CLASS_LABEL_NAME
			    --, IIF(@p_program_id = 'SCP0106', L.RPT_CODE_NM_KO, 'ETC')		    AS LARGE_CLASS_LABEL_NAME
			    , L.RPT_CODE_NM                                                     AS LARGE_CLASS_LABEL_NAME
			    , ''	    			                                            AS DAY_CODE
			    , CONCAT('01', MIN(A.BASIS_START_DATE), CONVERT(CHAR(2), '01'))     AS SORT_ORDER_NO
	    FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                LEFT JOIN (
                            SELECT    A.SHEET_NAME
                                    , A.RPT_CODE_CD
                                    , A.RPT_CODE_NM
                                    , A.RPT_CODE_NM_KO
                            FROM    @TBL_RPT_CODE A
                            WHERE   1=1
                                AND A.RPT_CODE_CD  = 'ETC'
                         ) L ON 1=1
	    WHERE	1=1
		    AND A.CALENDAR_YYYY BETWEEN @v_from_yyyy AND @v_to_yyyy_Monthly
	    GROUP BY	  CALENDAR_YYYY
                    , A.BASIS_YYYYMM
				    , A.MONTH_NAME
                    --, L.RPT_CODE_NM_KO
                    , L.RPT_CODE_NM
	    ORDER BY	  A.BASIS_YYYYMM
				    , A.MONTH_NAME;
    END


--TESTING : NOK
--select * from @TBL_1 ORDER BY COLUMN_NAME;return;

    IF @p_program_id = 'SCP0106'
    BEGIN
	    INSERT INTO @TBL_1
	    SELECT	  'Y_' + A.CALENDAR_YYYY	                                    AS COLUMN_NAME
			    , A.CALENDAR_YYYY			                                    AS COLUMN_LABEL_NAME
			    , A.CALENDAR_YYYY			                                    AS SMALL_CLASS_LABEL_NAME
			    --, IIF(@p_program_id = 'SCP0106', L.RPT_CODE_NM_KO, 'ETC')		AS LARGE_CLASS_LABEL_NAME
			    , L.RPT_CODE_NM                                                 AS LARGE_CLASS_LABEL_NAME
			    , ''	    			                                        AS DAY_CODE
			    , CONCAT('01', MIN(A.BASIS_START_DATE), CONVERT(CHAR(2), '01')) AS SORT_ORDER_NO
	    FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                LEFT JOIN (
                            SELECT    A.SHEET_NAME
                                    , A.RPT_CODE_CD
                                    , A.RPT_CODE_NM
                                    , A.RPT_CODE_NM_KO
                            FROM    @TBL_RPT_CODE A
                            WHERE   1=1
                                AND A.RPT_CODE_CD  = 'PLAN'
                            ) L ON 1=1
	    WHERE	1=1
		    AND A.CALENDAR_YYYY BETWEEN @v_from_yyyy_Year AND @v_to_yyyy_Year
	    GROUP BY	  A.CALENDAR_YYYY
                    --, L.RPT_CODE_NM_KO
                    , L.RPT_CODE_NM
        ORDER BY      A.CALENDAR_YYYY;
    END
    ELSE
    BEGIN
	    INSERT INTO @TBL_1
	    SELECT	  'Y_' + A.CALENDAR_YYYY	                                    AS COLUMN_NAME
			    , A.CALENDAR_YYYY			                                    AS COLUMN_LABEL_NAME
			    , A.CALENDAR_YYYY			                                    AS SMALL_CLASS_LABEL_NAME
			    --, IIF(@p_program_id = 'SCP0106', L.RPT_CODE_NM_KO, 'ETC')		AS LARGE_CLASS_LABEL_NAME
			    , L.RPT_CODE_NM                                                 AS LARGE_CLASS_LABEL_NAME
			    , ''	    			                                        AS DAY_CODE
			    , CONCAT('01', MIN(A.BASIS_START_DATE), CONVERT(CHAR(2), '01')) AS SORT_ORDER_NO
	    FROM	[dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
                LEFT JOIN (
                            SELECT    A.SHEET_NAME
                                    , A.RPT_CODE_CD
                                    , A.RPT_CODE_NM
                                    , A.RPT_CODE_NM_KO
                            FROM    @TBL_RPT_CODE A
                            WHERE   1=1
                                AND A.RPT_CODE_CD  = 'ETC'
                            ) L ON 1=1
	    WHERE	1=1
		    AND A.CALENDAR_YYYY BETWEEN @v_from_yyyy_Year AND @v_to_yyyy_Year
	    GROUP BY	  A.CALENDAR_YYYY
                    --, L.RPT_CODE_NM_KO
                    , L.RPT_CODE_NM
        ORDER BY      A.CALENDAR_YYYY;
    END
--TESTING : NOK
--select * from @TBL_1 ORDER BY COLUMN_NAME;return;

    
    -- M_00 으로 시작하는 월은 SCP106 같이 중복년월 컬럼이 있을경우 M_00, M01 로구분
    DECLARE @v_pre_year_cnt INT = 0;

    SELECT  @v_pre_year_cnt = COUNT(*)
    FROM    @TBL_1
    WHERE  1=1
        AND SUBSTRING(COLUMN_NAME, 1, 4) = 'M_00';

--print CONCAT('@v_pre_year_cnt : ', @v_pre_year_cnt);

    DELETE @TBL_1
    WHERE  1=1
       --AND SUBSTRING(COLUMN_NAME, 1, 4) = 'M_00'
        AND SUBSTRING(COLUMN_NAME, 5, 6) < @p_from_yyyymm;


    --우선순위 컬럼 추가
    BEGIN
        IF @p_program_id IN ('SCP0105', 'SCP0106')
        BEGIN
            INSERT INTO @TBL_1
            SELECT    COLUMN_NAME + '_ASSIGN_PRIORITY'  AS COLUMN_NAME
	                , COLUMN_LABEL_NAME
	                , SMALL_CLASS_LABEL_NAME
	                , LARGE_CLASS_LABEL_NAME
	                , DAY_CODE
	                , '99' + SUBSTRING(SORT_ORDER_NO, 3, LEN(SORT_ORDER_NO)- 2)
            FROM    @TBL_1
        END
    END



--TESTING : NOK
--select * from @TBL_1 ORDER BY COLUMN_NAME;return;

	INSERT INTO @TBL_RES
	SELECT	*
	FROM	@TBL_1

--TESTING : NOK
--select * from @TBL_RES order by SORT_ORDER_NO;

    RETURN;
END
