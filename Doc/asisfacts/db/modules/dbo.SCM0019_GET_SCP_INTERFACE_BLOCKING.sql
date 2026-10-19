

/*
 * Program ID   : SCM0019_GET_SCP_INTERFACE_BLOCKING
 * Description  : Plan 타겟 설정 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2019/01/25	hwyoon			Initial Release [PS02199094B] GSCM(DM/SCP) SM운영/유지보수
 */

CREATE PROCEDURE [dbo].[SCM0019_GET_SCP_INTERFACE_BLOCKING]
   @p_division_id		 NVARCHAR(MAX)
  ,@p_from_yyyymmdd		 NVARCHAR(8)
  ,@p_to_yyyymmdd        NVARCHAR(8)
AS
BEGIN

	SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ COMMITTED;

	SELECT DIVISION_ID
			, PLAN_START_YYYYMMDD
			, FP_TARGET_YN
			, MRP_TARGET_YN
			, DM_RTF_YN
	  FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)
	WHERE PLAN_START_YYYYMMDD >= [dbo].[FN_GET_BUCKET_YYYYMMDD](0)
	   AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@p_division_id,','))
	   AND PLAN_START_YYYYMMDD >=@p_from_yyyymmdd
	   AND PLAN_START_YYYYMMDD <=@p_to_yyyymmdd
	ORDER BY DIVISION_ID,PLAN_START_YYYYMMDD

END

