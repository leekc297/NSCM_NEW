
/*
 * Program ID   : DMF0014_GET_SPREAD_TITLE   
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/22  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2022/10/26  KDW2819		  [C20221024-000507]CUST FCST Upload 오류 수정
 *
 */
CREATE PROCEDURE [dbo].[DMF0014_GET_SPREAD_TITLE]
  @p_start_yyyymmdd  NVARCHAR(8),
  @p_end_yyyymmdd    NVARCHAR(8),
  @p_bucket_type     NVARCHAR(10)
AS
BEGIN
  
    SET NOCOUNT ON;
    
	IF @p_bucket_type = 'DAILY' 
	    BEGIN
        SELECT 'D_' + BASIS_YYYYMMDD  AS COLUMN_NAME
              , BASIS_YYYYMMDD        AS COLUMN_LABEL
              , A.DAYOFWEEK           AS SMALL_LABEL_NAME
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
		END;
	ELSE IF @p_bucket_type = 'WEEKLY' 
	    BEGIN
		SELECT 'D_' + MIN(A.BASIS_START_DATE)  AS COLUMN_NAME
              , MIN(A.BASIS_START_DATE)        AS COLUMN_LABEL
              , A.WEEK_NAME                    AS SMALL_LABEL_NAME  
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
        GROUP BY A.ISO_YYYYWW, A.WEEK_NAME 
		ORDER BY COLUMN_LABEL;
	    END;
    ELSE IF @p_bucket_type = 'MONTHLY' 
	    BEGIN
		SELECT 'D_' + MIN(A.BASIS_YYYYMM) + '01'  AS COLUMN_NAME
              , MIN(A.BASIS_YYYYMM) + '01'        AS COLUMN_LABEL
              , A.MONTH_NAME                      AS SMALL_LABEL_NAME  
        FROM   [DBO].[SCM_SYS_CALENDAR_M] A WITH(NOLOCK)	
        WHERE  A.BASIS_YYYYMMDD >= @p_start_yyyymmdd --CONVERT(CHAR(8), CURRENT_TIMESTAMP, 112)
        AND    A.BASIS_YYYYMMDD <= @p_end_yyyymmdd   --CONVERT(CHAR(8), DATEADD(MM, 6, CURRENT_TIMESTAMP), 112)
        GROUP BY A.MONTH_NAME ;
		END;
	

END

