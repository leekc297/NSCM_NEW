/****************************************************************************************************
* Program ID  : SSP0022_GET_SHEET_CALENDAR_3SPAN                                                       
* Description : SSP 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SSP0022_GET_SHEET_CALENDAR_3SPAN													
* Parameter   : @p_start_yyyymmdd='2017-12-25'                                                     
*               @p_end_yyyymmdd='20180130'                                                         
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2020/04/30  KIMYONGHO	  Initial Release  
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SSP0022_GET_SHEET_CALENDAR_3SPAN]
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
    SELECT 'Z_D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
        , A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
        , A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
        , A.DAYOFWEEK               AS DAY_CODE
	    , 'Z_' + A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.basis_yyyymmdd <= @p_end_yyyymmdd 
    UNION ALL
    SELECT 'Z_W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
        , A.WEEK_NAME          AS COLUMN_LABEL_NAME   
        , A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
	    , 'Z_' + A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.ISO_WEEK 
            , A.WEEK_NAME
            , A.MONTH_NAME        
            , A.BASIS_START_DATE
    UNION ALL
    SELECT 'Z_M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
            , A.MONTH_NAME          AS COLUMN_LABEL_NAME
		    , A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		    , A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		    , ''                    AS DAY_CODE
		    , 'Z_' + MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
    FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.MONTH_NAME	
		  
	UNION ALL 

	SELECT 'X_D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
		, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
		, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
		, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
		, A.DAYOFWEEK               AS DAY_CODE
		, 'X_'+A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
	AND    A.basis_yyyymmdd <= @p_end_yyyymmdd 
	UNION ALL
	SELECT 'X_W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
		, A.WEEK_NAME          AS COLUMN_LABEL_NAME   
		, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
		, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
		, ''                   AS DAY_CODE
		, 'X_'+A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
	AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	GROUP BY A.BASIS_YYYYMM
		, A.ISO_WEEK 
		, A.WEEK_NAME
		, A.MONTH_NAME        
		, A.BASIS_START_DATE
	UNION ALL
	SELECT 'X_M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
		, A.MONTH_NAME          AS COLUMN_LABEL_NAME
		, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		, ''                    AS DAY_CODE
		, 'X_'+ MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
	FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
	AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	GROUP BY A.BASIS_YYYYMM
		, A.MONTH_NAME	
    

    	UNION ALL 

	SELECT 'Y_D_' + A.BASIS_YYYYMMDD   AS COLUMN_NAME
		, A.CALENDAR_DAY            AS COLUMN_LABEL_NAME   
		, A.WEEK_NAME               AS SMALL_CLASS_LABEL_NAME
		, A.MONTH_NAME              AS LARGE_CLASS_LABEL_NAME 
		, A.DAYOFWEEK               AS DAY_CODE
		, 'Y_'+A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
	AND    A.basis_yyyymmdd <= @p_end_yyyymmdd 
	UNION ALL
	SELECT 'Y_W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
		, A.WEEK_NAME          AS COLUMN_LABEL_NAME   
		, A.WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
		, A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
		, ''                   AS DAY_CODE
		, 'Y_'+A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
	AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	GROUP BY A.BASIS_YYYYMM
		, A.ISO_WEEK 
		, A.WEEK_NAME
		, A.MONTH_NAME        
		, A.BASIS_START_DATE
	UNION ALL
	SELECT 'Y_M_' + A.BASIS_YYYYMM  AS COLUMN_NAME
		, A.MONTH_NAME          AS COLUMN_LABEL_NAME
		, A.MONTH_NAME          AS SMALL_CLASS_LABEL_NAME
		, A.MONTH_NAME          AS LARGE_CLASS_LABEL_NAME
		, ''                    AS DAY_CODE
		, 'Y_'+ MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '01') AS SORT_ORDER_NO
	FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
	AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	GROUP BY A.BASIS_YYYYMM
		, A.MONTH_NAME	
    ORDER BY sort_order_no

END
