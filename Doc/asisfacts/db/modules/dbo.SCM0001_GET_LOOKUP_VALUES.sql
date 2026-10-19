
/*
 * Program ID   : SCM0001_GET_LOOKUP_VALUES
 * Description  :
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/11/30   SongDH         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 *
 */

CREATE procedure [dbo].[SCM0001_GET_LOOKUP_VALUES]
  @p_lookup_type NVARCHAR(100)
AS
BEGIN
	
  SET NOCOUNT ON;
  
  SELECT L.SEGMENT1  AS CODE
       , L.SEGMENT2  AS NAME
  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)
  WHERE  1 = 1
  AND    L.LOOKUP_TYPE = @p_lookup_type
  AND    L.VALID_YN    = 'Y'
  ORDER BY L.DISPLAY_SEQ
  ;

END


