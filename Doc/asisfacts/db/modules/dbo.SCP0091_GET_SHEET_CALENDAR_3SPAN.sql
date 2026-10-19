
/*
 * Program ID   : [SCP0091_GET_SHEET_CALENDAR_3SPAN]
 * Description  : 운송중재고 Report
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2022/03/04   vadabi3	Initial 최조생성 (참조 : [SCP0091_GET_SHEET_CALENDAR_3SPAN )
 */

CREATE PROCEDURE [dbo].[SCP0091_GET_SHEET_CALENDAR_3SPAN]
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS

BEGIN
SET NOCOUNT ON;
----------------------------------------------------------------------------
 SELECT   A.BASIS_YYYYMMDD   AS COLUMN_NAME
        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
        , A.DAYOFWEEK               AS DAY_CODE
	    , A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.basis_yyyymmdd <= @p_end_yyyymmdd 
----------------------------------------------------------------------------
    UNION ALL
    SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
        , A.WEEK_NAME          AS COLUMN_LABEL_NAME   
        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
	    , A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.ISO_WEEK 
            , A.WEEK_NAME
            , A.MONTH_NAME        
            , A.BASIS_START_DATE
----------------------------------------------------------------------------
    UNION ALL
    SELECT 'M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
            , A.MONTH_NAME          AS COLUMN_LABEL_NAME
		    , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		    , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		    , ''                    AS DAY_CODE
		    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
    FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.MONTH_NAME		
    ORDER BY sort_order_no
END

