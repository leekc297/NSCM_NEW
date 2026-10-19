-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DMF0002_GET_MTOW_SPREAD_TITLE]
	@p_from_month          NVARCHAR(6)
   ,@p_to_month            NVARCHAR(6)
AS
BEGIN
  -- SET NOCOUNT ON added to prevent extra result sets from
  -- interfering with SELECT statements.
  SET NOCOUNT ON;

  SELECT 'W_' + a.BASIS_START_DATE + '_' + CASE WHEN a.BASIS_START_DATE > CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112) 
                                              THEN 'UNLOCK_' + CONVERT(CHAR(1), ROW_NUMBER() OVER(PARTITION BY a.month_name  ORDER BY a.month_name ASC))
		  							          ELSE 'LOCK_' + CONVERT(CHAR(1), ROW_NUMBER() OVER(PARTITION BY month_name  ORDER BY month_name ASC))
			  							 END   AS column_name     
       , a.week_name                           AS column_label
       , a.month_name                          AS small_label_name 
       , a.BASIS_START_DATE
       , a.BASIS_END_DATE
  FROM   [dbo].[SCM_SYS_CALENDAR_M] a WITH(NOLOCK)	
  WHERE  a.basis_yyyymm >= @p_from_month --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
  AND    a.basis_yyyymm <= @p_to_month   --CONVERT(CHAR(6), DATEADD(YYYY, 1, CURRENT_TIMESTAMP), 112)
  GROUP BY a.BASIS_START_DATE
         , a.BASIS_END_DATE
         , a.week_name
         , a.month_name                                  
         --, a.start_yyyymmdd
         --, a.end_yyyymmdd
  ;

END
