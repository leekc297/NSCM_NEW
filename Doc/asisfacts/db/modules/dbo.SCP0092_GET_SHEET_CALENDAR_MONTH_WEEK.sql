
/****************************************************************************************************
* Program ID    : SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK
* Description   : SCP 칼렌더 생성위한 프로시저
* Usage         : exec SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK
* Parameter     : @p_year='2022'
*--------------------------------------------------------------------------------------------------
* Date          In Charge   Description
*--------------------------------------------------------------------------------------------------
* 2022/04/29    chaan		Initial Release
* 2022/06/14    chaan		최종기간을 당월로 제한
* 2022/06/15    chaan		월컬럼을 주마지막 다음으로 이동
* 2022/06/17    chaan		ISOYYYYMM 기준으로 주 로직 변경
* ex)
* EXEC SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK @p_year ='2022'
****************************************************************************************************/

--CREATE PROCEDURE [dbo].[SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK]
CREATE PROCEDURE [dbo].[SCP0092_GET_SHEET_CALENDAR_MONTH_WEEK]
  	  @p_year             NVARCHAR(4)
--DECLARE  	  @p_year             NVARCHAR(4) = '2022';
AS
BEGIN
    DECLARE     @V_PRE_YYYYMM       NVARCHAR(6)         = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH, -1, @p_year + '0101'), 112), 1, 6);
    DECLARE     @V_POST_YYYYMM      NVARCHAR(6)         = SUBSTRING(CONVERT(CHAR(8), DATEADD(MONTH,  1, @p_year + '1201'), 112), 1, 6);
    
    DECLARE     @V_THIS_MONDAY      NVARCHAR(8)         = CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY( GETDATE(), 'MON')), 112);

    DECLARE     @V_THIS_YYYYMM      NVARCHAR(6)         = SUBSTRING(@V_THIS_MONDAY, 1, 6)

    --IF @V_POST_YYYYMM > @V_THIS_YYYYMM
    --BEGIN
    --    SET @V_POST_YYYYMM = @V_THIS_YYYYMM
    --END

    
    --PRINT @V_PRE_YYYYMM;
    --PRINT @V_POST_YYYYMM;
    --RETURN;

    SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON;

    IF OBJECT_ID('tempdb..#TBL_SCP0092_WEEK_MONTH_INFO') IS NOT NULL
        DROP TABLE #TBL_SCP0092_WEEK_MONTH_INFO;

    SELECT    X.*
            , @p_year + '-' + X.MM AS MONTH_NAME
    INTO    #TBL_SCP0092_WEEK_MONTH_INFO
    FROM
            (
                SELECT    SUBSTRING(A.ISO_YYYYMM, 1, 4)  AS YYYY
                        , SUBSTRING(A.ISO_YYYYMM, 5, 2)  AS MM
                        , WEEK_NAME
                        , MIN(A.BASIS_START_DATE) AS BASIS_START_DATE
                        , MAX(A.BASIS_END_DATE) AS BASIS_END_DATE
	            FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	            WHERE       A.ISO_YYYYMM >= @V_PRE_YYYYMM
                        AND A.ISO_YYYYMM <= @V_POST_YYYYMM
                GROUP BY  SUBSTRING(A.ISO_YYYYMM, 1, 4)
                        , SUBSTRING(A.ISO_YYYYMM, 5, 2)
                        , WEEK_NAME
            ) X
    WHERE   X.YYYY = @p_year -- 전년도에 걸쳐있으면 전년도에 합산되므로 제외
    ORDER BY X.MM, X.WEEK_NAME;

    --SELECT *FROM #TBL_SCP0092_WEEK_MONTH_INFO; RETURN;

	SELECT	  'W_' + @p_year + A.MM + RIGHT(WEEK_NAME, 2)       AS COLUMN_NAME
			, A.WEEK_NAME									    AS COLUMN_LABEL_NAME
			, A.WEEK_NAME									    AS SMALL_CLASS_LABEL_NAME
			, A.MONTH_NAME						                AS LARGE_CLASS_LABEL_NAME
			, 'W'											    AS DAY_CODE
			, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), 21)    AS SORT_ORDER_NO
	FROM    #TBL_SCP0092_WEEK_MONTH_INFO A WITH(NOLOCK)
    GROUP BY A.MM, A.MONTH_NAME, A.WEEK_NAME
	UNION ALL
	SELECT    'M_' + @p_year + A.MM   							AS COLUMN_NAME
			, A.MONTH_NAME									    AS COLUMN_LABEL_NAME
			, A.MONTH_NAME									    AS SMALL_CLASS_LABEL_NAME
			, A.MONTH_NAME									    AS LARGE_CLASS_LABEL_NAME
			, 'M'												AS DAY_CODE
			--, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01')  AS SORT_ORDER_NO
			, MAX(A.BASIS_END_DATE) + CONVERT(CHAR(2), '01')  AS SORT_ORDER_NO --월컬럼을 주마지막 다음으로 이동
	FROM	#TBL_SCP0092_WEEK_MONTH_INFO A WITH(NOLOCK)
    GROUP BY A.MM, A.MONTH_NAME
	ORDER BY SORT_ORDER_NO;
END


