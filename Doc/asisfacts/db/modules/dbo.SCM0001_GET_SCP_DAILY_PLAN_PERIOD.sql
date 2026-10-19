
/*
 * Program ID   : SCM0001_GET_SCP_DAILY_PLAN_PERIOD
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2021/06/15   khj79          [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - 최초작성
 *
 */

CREATE PROCEDURE [dbo].[SCM0001_GET_SCP_DAILY_PLAN_PERIOD]
   @p_division_id    NVARCHAR(30) 
AS
BEGIN
	
    SET NOCOUNT ON;

	SELECT DAILY_PLAN_PERIOD
	FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)	
	WHERE DIVISION_ID = @p_division_id
	;

END

