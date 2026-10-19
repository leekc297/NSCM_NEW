
/*
 * Program ID   : SCP0069_GET_SPREAD_TITLE   
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/08/12   LWY            LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2) - GlobalPSI_ESS (전극) 신규
 *
 */
create PROCEDURE [dbo].[SCP0069_GET_SPREAD_TITLE]  
   @p_start_yyyymmdd	NVARCHAR(8)  
  ,@p_end_yyyymmdd		NVARCHAR(8)
  
AS
BEGIN
  
    
	  ------------------------------------------
	  -- ★★★ Patial Week --------------------
	  ------------------------------------------
   
	SET NOCOUNT ON;
    
	-- SPREAD HEADER SETTING..
	BEGIN
		SELECT 'W_' + BASIS_YYYYMM + ISO_WEEK	AS COLUMN_NAME
			 , PARTIAL_WEEK_NAME				AS COLUMN_LABEL
			 , SUBSTRING(CONVERT(VARCHAR , CONVERT(DATE,MIN(A.BASIS_START_DATE)),  102), 6,10)
						+ '~' +  SUBSTRING(CONVERT(VARCHAR , CONVERT(DATE,MAX(A.BASIS_END_DATE)),  102), 6,10) AS SMALL_LABEL_NAME
			 , COUNT(1)		AS DAY_CNT
			 , CAL_ORDER_NUM
		  FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
		  JOIN ( SELECT ISO_YYYYWW , ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW) AS CAL_ORDER_NUM
				   FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
				  WHERE A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
					AND A.BASIS_YYYYMMDD <= @p_end_yyyymmdd
				  GROUP BY ISO_YYYYWW) B
			ON A.ISO_YYYYWW = B.ISO_YYYYWW
		 WHERE A.BASIS_YYYYMMDD >= @p_start_yyyymmdd
		   AND A.BASIS_YYYYMMDD <= @p_end_yyyymmdd
		 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK , PARTIAL_WEEK_NAME, CAL_ORDER_NUM
		 --ORDER BY A.BASIS_YYYYMM, A.ISO_WEEK
		 ORDER BY A.BASIS_YYYYMM, CAL_ORDER_NUM
	END

	-- SAVE SETTING..
	BEGIN
		SELECT   WEEK_NAME
				,'QTY' + RIGHT( '000' + CONVERT(VARCHAR(3), RN  )  , 3)  AS DAY_NAME
		 FROM (
				SELECT 'D_'+A.BASIS_YYYYMMDD   AS YYYYMMDD
						, A.BASIS_YYYYMMDD + CONVERT(CHAR(2), 31) AS SORT_ORDER_NO
						, A.BASIS_YYYYMM + ISO_WEEK  AS YYYYMMDD_WEEK
						, ROW_NUMBER() OVER(ORDER BY A.BASIS_YYYYMMDD) RN
						,WEEK_NAME
					FROM [DBO].[SCM_SYS_CALENDAR_M] A
					WHERE A.BASIS_YYYYMMDD  BETWEEN  @p_start_yyyymmdd AND @p_end_yyyymmdd
			 ) T
	END

END
