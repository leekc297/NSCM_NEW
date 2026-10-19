
/*
 * Program ID   : SCP0067_GET_SPREAD_TITLE   
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/08/09   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.2)
 *
 */
 
CREATE PROCEDURE [dbo].[SCP0067_GET_SPREAD_TITLE]
  --@p_start_yyyymmdd  NVARCHAR(8),
  --@p_end_yyyymmdd    NVARCHAR(8)
  --@p_bucket_type     NVARCHAR(10)
AS
BEGIN
  
    SET NOCOUNT ON;

	DECLARE @v_plan_start_yyyymmdd	NVARCHAR(8) = ''
	DECLARE @v_start_yyyymmdd		NVARCHAR(8) = '';
	DECLARE @v_end_yyyymmdd			NVARCHAR(8) = '';


	 SELECT  DISTINCT 
	          @v_plan_start_yyyymmdd = PLAN_START_YYYYMMDD
		     ,@v_end_yyyymmdd = CREATE_TO_YYYYMMDD
	   FROM DBO.SCP_XLS_PSI_GLOBAL WITH (NOLOCK)

	SET @v_start_yyyymmdd = @v_plan_start_yyyymmdd;
    
	SELECT 'W_' + BASIS_YYYYMM + ISO_WEEK	AS COLUMN_NAME
		 , PARTIAL_WEEK_NAME				AS COLUMN_LABEL
		 , SUBSTRING(CONVERT(VARCHAR , CONVERT(DATE,MIN(A.BASIS_START_DATE)),  102), 6,10)
					+ '~' +  SUBSTRING(CONVERT(VARCHAR , CONVERT(DATE,MAX(A.BASIS_END_DATE)),  102), 6,10) AS SMALL_LABEL_NAME
		 , COUNT(1)		AS DAY_CNT
		 , CAL_ORDER_NUM
	  FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
	  JOIN ( SELECT ISO_YYYYWW , ROW_NUMBER() OVER(ORDER BY ISO_YYYYWW) AS CAL_ORDER_NUM
			   FROM [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)
			  WHERE A.BASIS_YYYYMMDD >= @v_start_yyyymmdd
				AND A.BASIS_YYYYMMDD <= @v_end_yyyymmdd
			  GROUP BY ISO_YYYYWW) B
		ON A.ISO_YYYYWW = B.ISO_YYYYWW
	 WHERE A.BASIS_YYYYMMDD >= @v_start_yyyymmdd
	   AND A.BASIS_YYYYMMDD <= @v_end_yyyymmdd
	 GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK , PARTIAL_WEEK_NAME, CAL_ORDER_NUM
	 ORDER BY A.BASIS_YYYYMM, A.ISO_WEEK
END

