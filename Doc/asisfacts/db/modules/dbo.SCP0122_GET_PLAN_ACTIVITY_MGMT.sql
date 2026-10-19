


/*
 * Program ID   : SCP0122_GET_PLAN_ACTIVITY_MGMT
 * Description  : Plan Activity Mgmt 정보조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/04/29   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */

CREATE PROCEDURE [dbo].[SCP0122_GET_PLAN_ACTIVITY_MGMT]
	@p_division_id			NVARCHAR(MAX)
	, @p_plan_group_id		NVARCHAR(MAX)
	, @p_prs_cd				NVARCHAR(MAX)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

    SELECT b.DIVISION_ID
		, a.OPMZ_PRS_CD
		, d.SEGMENT2 AS OPMZ_PRS_NAME
		, a.OPMZ_PLAN_GR_ID
		, b.OPMZ_PLAN_GR_NAME
		, a.OPMZ_ACTV_SEQ
		, a.OPMZ_ACTV_CD
		, a.OPMZ_ACTV_CD AS OPMZ_ACTV_NAME
		, c.ATTRIBUTE4 AS LINK_UI_TYPE
		, c.ATTRIBUTE5 AS PROGRAM_NAME
		, c.ATTRIBUTE6 AS CONFIRM_YN
		, c.ATTRIBUTE7 AS AUTO_YN
		, c.ATTRIBUTE8 AS OPTION_YN
		, a.OPMZ_ACTV_CD AS PRE_OPMZ_ACTV_CD
		, a.OPMZ_ACTV_SEQ AS PRE_OPMZ_ACTV_SEQ
	FROM SCP_OPMZ_PLAN_GR_ACTV_M a
	INNER JOIN SCP_OPMZ_PLAN_GR_M b ON b.OPMZ_PLAN_GR_ID = a.OPMZ_PLAN_GR_ID
	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL c WITH(NOLOCK) ON c.LOOKUP_TYPE = 'OPMZ_ACTV_CD'  AND c.SEGMENT1 = a.OPMZ_ACTV_CD
	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL d WITH(NOLOCK) ON d.LOOKUP_TYPE = 'OPMZ_PRS_CD'  AND d.SEGMENT1 = a.OPMZ_PRS_CD
	WHERE b.DIVISION_ID = @p_division_id
	AND a.OPMZ_PLAN_GR_ID = @p_plan_group_id
	AND a.OPMZ_PRS_CD = @p_prs_cd
	ORDER BY a.OPMZ_ACTV_SEQ
  
END

