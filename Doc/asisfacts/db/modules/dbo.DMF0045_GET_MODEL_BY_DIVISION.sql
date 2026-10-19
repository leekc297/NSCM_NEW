---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

/*
 * Program ID   : DMF0045_GET_MODEL_BY_DIVISION
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/18  SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE PROCEDURE [dbo].[DMF0045_GET_MODEL_BY_DIVISION]
  @p_division_id		NVARCHAR(MAX)
  , @p_operation_group	NVARCHAR(MAX)
AS
BEGIN
	SELECT DISTINCT ITEM_ID
	  FROM SCM_MST_ITEM_SN WITH (NOLOCK)
	 WHERE ACTIVE_FLAG = 'Y'
		AND DIVISION_ID = @p_division_id
	    AND SCP_OPERATION_GROUP = @p_operation_group;

END


