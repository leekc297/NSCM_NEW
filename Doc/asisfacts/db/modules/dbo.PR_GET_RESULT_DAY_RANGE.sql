
/*
 * Program ID   : PR_GET_RESULT_DAY_RANGE     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/03/13  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */
CREATE PROCEDURE [dbo].[PR_GET_RESULT_DAY_RANGE]    
    @p_created_by	   NVARCHAR(30),
	@p_month           INT
AS
BEGIN
	
    SET NOCOUNT ON;
		
    DECLARE @v_start_yyyymmdd AS NVARCHAR(8);
    DECLARE @v_end_yyyymmdd   AS NVARCHAR(8);
    DECLARE @v_bucket_type    AS NVARCHAR(10);
	DECLARE @v_user_col_cnt   AS INT;
	DECLARE @v_user_time_zone AS NVARCHAR(10);
	DECLARE @v_user_time      AS NVARCHAR(8);
	
		
    SET @v_start_yyyymmdd = '';
    SET @v_end_yyyymmdd = '';
	SET @v_user_time_zone = '';
	SET @v_user_col_cnt = @p_month;
	

	BEGIN
	    SELECT @v_user_time_zone = U.TIMEZONE
		FROM   [dbo].[TB_FX_User] U
		WHERE  U.UserID = @p_created_by;
	END
	
    BEGIN
	    SELECT MIN(C.BASIS_YYYYMMDD) + ':' + MAX(C.BASIS_YYYYMMDD) 
        FROM   [dbo].[SCM_SYS_CALENDAR_M] C  WITH(NOLOCK) 
        WHERE  1 = 1
	    AND    C.CALENDAR_YYYY = CONVERT(CHAR(4), dbo.FN_MULTY_TIME(@v_user_time_zone), 112)
		AND    C.BASIS_YYYYMMDD <= CONVERT(CHAR(8), dbo.FN_MULTY_TIME(@v_user_time_zone), 112)
    END
	
   
END

