/*
 * Program ID   : DMF0020_GET_WEEKDATA     
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2019/04/15  JYE         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 
 */
create PROCEDURE [dbo].[DMF0020_GET_WEEKDATA]
	@p_yyyymmdd           VARCHAR(10)
AS
BEGIN
	
    SET NOCOUNT ON;
		
	SELECT TOP 7 BASIS_START_DATE, BASIS_YYYYMMDD
	FROM [dbo].[SCM_SYS_CALENDAR_M]
	WHERE
	BASIS_YYYYMMDD <= @p_yyyymmdd
	ORDER BY BASIS_YYYYMMDD DESC
   
END
