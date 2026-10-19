/****************************************************************************************************
* Program ID  : SCP0070_GET_SHEET_CALENDAR_3SPAN     => SCP0100_GET_SHEET_CALENDAR_3SPAN                                                 
* Description : SCP 칼렌더 생성위한 프로시저                                                       
* Usage       : exec SCP0100_GET_SHEET_CALENDAR_3SPAN													
* Parameter   : @p_start_yyyymmdd='2017-12-25'                                                     
*               @p_end_yyyymmdd='20180130'                                                         
*--------------------------------------------------------------------------------------------------
* Date        In Charge    Description                                                             
*--------------------------------------------------------------------------------------------------
* 2023/10/17  vadabi3			Initial Release  
* ex)
* EXEC SCP0100_GET_SHEET_CALENDAR_3SPAN @p_start_yyyymmdd ='20230101' , @p_end_yyyymmdd='20231231'
****************************************************************************************************/

CREATE PROCEDURE [dbo].[SCP0100_GET_SHEET_CALENDAR_3SPAN]
	@p_start_yyyymmdd  NVARCHAR(8),
    @p_end_yyyymmdd    NVARCHAR(8)
AS
BEGIN
	SET NOCOUNT ON;
	/*
--------------------------------------------------------------------------------------------
-- DEFAULT
    SELECT 'W_' + A.BASIS_YYYYMM + A.ISO_WEEK   AS COLUMN_NAME
        , A.PARTIAL_WEEK_NAME          AS COLUMN_LABEL_NAME   
        , A.PARTIAL_WEEK_NAME          AS SMALL_CLASS_LABEL_NAME
        , A.MONTH_NAME         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
	    , A.BASIS_START_DATE + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.ISO_WEEK 
            , A.PARTIAL_WEEK_NAME
            , A.MONTH_NAME        
            , A.BASIS_START_DATE
--------------------------------------------------------------------------------------------
-- 1차 적용
	SELECT 'W_' + (A.ISO_YYYYWW+REPLACE(A.PARTIAL_WEEK_NAME,'W',''))   AS COLUMN_NAME
		 , (REPLACE(MAX(A.PARTIAL_WEEK_NAME),'W',''))           AS COLUMN_LABEL_NAME   
		 ,  'W_' +(REPLACE(MAX(A.PARTIAL_WEEK_NAME),'W',''))           AS SMALL_CLASS_LABEL_NAME   
		 , MAX(A.MONTH_NAME)         AS LARGE_CLASS_LABEL_NAME 
		 , ''                   AS DAY_CODE
		 , MAX(A.ISO_YYYYWW) + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
	WHERE  A.BASIS_YYYYMMDD >= '20230101' 
	AND    A.BASIS_YYYYMMDD <= '20231231' 
	GROUP BY (A.ISO_YYYYWW +REPLACE(A.PARTIAL_WEEK_NAME,'W','')) 

	-- 2차 적용
	SELECT 'W_' + (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1))		AS COLUMN_NAME
		 , (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1))            AS COLUMN_LABEL_NAME   
		 ,  'W_' + (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1))    AS SMALL_CLASS_LABEL_NAME   
		 , MAX(A.MONTH_NAME)         AS LARGE_CLASS_LABEL_NAME 
		 , ''                        AS DAY_CODE
		 , MAX(A.ISO_YYYYWW) + CONVERT(CHAR(2), 21) AS SORT_ORDER_NO
	FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	GROUP BY (A.ISO_YYYYWW + SUBSTRING(PARTIAL_WEEK_NAME,4,1)) 
		
--------------------------------------------------------------------------------------------
-- 2차 적용		
	SELECT  'W_' + WEEK_NAME  AS COLUMN_NAME
		 , WEEK_NAME   AS COLUMN_LABEL_NAME   
		 ,  'W_' + MAX(PARTIAL_WEEK_NAME)  AS SMALL_CLASS_LABEL_NAME   
		 , MAX(MONTH_NAME)  AS LARGE_CLASS_LABEL_NAME 
		 , ''               AS DAY_CODE
		 , MAX(SORT_ORDER_NO) AS SORT_ORDER_NO
	FROM
	(

		SELECT ISO_YYYYWW
			 , REPLACE(PARTIAL_WEEK_NAME, 'W','') AS PARTIAL_WEEK_NAME
			 , MONTH_NAME
			 ,CONCAT(BASIS_YYYYMM, SUBSTRING(PARTIAL_WEEK_NAME,2,2),SUBSTRING(PARTIAL_WEEK_NAME,4,1) ) AS WEEK_NAME
			 ,CONCAT(ISO_YYYYWW, PARTIAL_WEEK_NAME) AS SORT_ORDER_NO
		FROM SCM_SYS_CALENDAR_M A WITH(NOLOCK)
		WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
		AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
	) DATA
	GROUP BY WEEK_NAME	
--------------------------------------------------------------------------------------------
-- 3차 적용		
    SELECT 'W_' + concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))   AS COLUMN_NAME
        , concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))        AS COLUMN_LABEL_NAME   
        , 'W_' + SUBSTRING(concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3)) ,3,8)       AS SMALL_CLASS_LABEL_NAME
        , max(MONTH_NAME)         AS LARGE_CLASS_LABEL_NAME 
        , ''                   AS DAY_CODE
		    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '21') AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))	
	
	
		
	*/


    SELECT 'W_' + concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))   AS COLUMN_NAME
        , concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))			AS COLUMN_LABEL_NAME   
        , CASE WHEN MAX( SUBSTRING(PARTIAL_WEEK_NAME,4,1)) != ''
		       THEN MAX(  concat(SUBSTRING(PARTIAL_WEEK_NAME,1,3) ,'_', SUBSTRING(PARTIAL_WEEK_NAME,4,1))  ) 
			   ELSE MAX(PARTIAL_WEEK_NAME)
			   END AS SMALL_CLASS_LABEL_NAME
        , max(MONTH_NAME)									AS LARGE_CLASS_LABEL_NAME 
        , MIN(A.BASIS_START_DATE)							AS DAY_CODE
		, MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '21')	AS SORT_ORDER_NO
    FROM   [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY concat(SUBSTRING(ISO_YYYYWW,1,4) ,SUBSTRING(PARTIAL_WEEK_NAME,2,3))


    UNION ALL

    SELECT 'M_' + A.BASIS_YYYYMM			AS COLUMN_NAME
            , A.MONTH_NAME					AS COLUMN_LABEL_NAME
		    , A.MONTH_NAME					AS SMALL_CLASS_LABEL_NAME
		    , A.MONTH_NAME					AS LARGE_CLASS_LABEL_NAME
		    , MIN(A.BASIS_START_DATE)       AS DAY_CODE
		    , MIN(A.BASIS_START_DATE) + CONVERT(CHAR(2), '02') AS SORT_ORDER_NO
    FROM    [dbo].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
    WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd 
    AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd 
    GROUP BY A.BASIS_YYYYMM
            , A.MONTH_NAME	

	ORDER BY sort_order_no

END
