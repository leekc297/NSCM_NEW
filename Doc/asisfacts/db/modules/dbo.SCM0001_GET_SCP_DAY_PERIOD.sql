
/*
 * Program ID   : SCM0001_GET_SCP_DAY_PERIOD
 * Description  : PERIOD 일자별 기간조회 
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2018/04/19   ygkim		   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트

 ex)
 EXEC SCM0001_GET_SCP_PERIOD @p_from_date='20180417', @p_offset_month='12',@p_timezone='AM073'
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_SCP_DAY_PERIOD]
	 @p_from_date    NVARCHAR(30) 
	,@p_offset_day   INT
	,@p_timezone     NVARCHAR(200) 
AS

BEGIN
	IF ISNULL(@p_from_date,'')='' 
		SET @p_from_date = convert(varchar(8), [dbo].[FN_MULTY_TIME](@p_timezone),112);
		
	IF ISNULL(@p_offset_day,'')='' 
		SET @p_offset_day = '6'
	
	IF CHARINDEX('-',@p_offset_day) = 1
		BEGIN
			SELECT
				MIN(BASIS_YYYYMMDD) + ':' + MAX(BASIS_YYYYMMDD)
			FROM SCM_SYS_CALENDAR_M A
			WHERE A.BASIS_YYYYMMDD <= @p_from_date
			 AND A.BASIS_YYYYMMDD >= CONVERT(varchar(8) , DATEADD(DAY, @p_offset_day, @p_from_date), 112)
		END
	ELSE
		BEGIN
			SELECT
				MIN(BASIS_YYYYMMDD) + ':' + MAX(BASIS_YYYYMMDD)
			FROM SCM_SYS_CALENDAR_M A
			WHERE A.BASIS_YYYYMMDD >= @p_from_date
			 AND A.BASIS_YYYYMMDD <= CONVERT(varchar(8) , DATEADD(DAY, @p_offset_day, @p_from_date), 112)
		END

END

