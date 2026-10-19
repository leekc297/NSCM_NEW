


/*
 * Program ID   : SCP0123_GET_PLAN_ENGINE_RUN
 * Description  : Engine Run Status 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/05/14   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/11   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Engine Run Waiting Count 수정
 *
 */

CREATE PROCEDURE [dbo].[SCP0123_GET_PLAN_ENGINE_RUN]
	@p_division_id				NVARCHAR(50)
	, @p_plan_group_id			NVARCHAR(50)
	, @p_plan_start_yyyymmdd	NVARCHAR(50)
	, @p_actv_cd				NVARCHAR(50)
	, @p_plan_id				NVARCHAR(50)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @v_last_update_date	DATETIME;
	DECLARE @v_waiting_cnt		INT;
	DECLARE @v_waitint_desc		NVARCHAR(200);

	SET @v_last_update_date = ''
	SET @v_waiting_cnt = 0

	select distinct @v_last_update_date = ISNULL(a.LAST_UPDATE_DATE, null)
	from SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M a with(nolock)
	inner join SCP_OPMZ_PLAN_GR_M pg with(nolock) 
		on pg.opmz_plan_gr_id = a.opmz_plan_gr_id 
	where 1=1
	AND pg.DIVISION_ID			= @p_division_id
	AND a.PLAN_START_YYYYMMDD	= @p_plan_start_yyyymmdd
	AND a.OPMZ_PLAN_GR_ID		= @p_plan_group_id
	AND a.OPMZ_ACTV_CD			= @p_actv_cd
	AND a.OPMZ_ACTV_RUN_STAT_CD = 'W'	--Wait인 것만 카운트 하도록
	AND a.OPMZ_PLAN_ID			= @p_plan_id


	IF (ISNULL(@v_last_update_date, '') <> '')
	BEGIN
		
		select @v_waiting_cnt = COUNT(*)
		from SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M rm  with(nolock)
		inner join SCP_OPMZ_PLAN_GR_M pg with(nolock) 
			on pg.opmz_plan_gr_id = rm.opmz_plan_gr_id 
		where 1=1
		AND pg.DIVISION_ID				= @p_division_id
		AND rm.PLAN_START_YYYYMMDD		= @p_plan_start_yyyymmdd
		--AND rm.OPMZ_PLAN_GR_ID			= @p_plan_group_id		--사업부 내에서 카운트 하도록 수정 plan_group_id 제외
		AND rm.OPMZ_ACTV_CD				= @p_actv_cd
		AND rm.OPMZ_ACTV_RUN_STAT_CD	= 'W'	--Wait인 것만 카운트 하도록
		AND rm.LAST_UPDATE_DATE			<= @v_last_update_date

		SET @v_waitint_desc = ' Wating for engine. Your position is ' + CONVERT(NVARCHAR(20), @v_waiting_cnt)

	END
	ELSE
	BEGIN
		SET @v_waitint_desc = ''
	END

	SELECT ISNULL(b.PLAN_ID, @p_plan_id) PLAN_ID
		,  a.segment2		AS PROGRESS_CODE
		,  a.attribute1		AS PROGRESS_TEXT
		 , b.STATUS_CODE	AS STATUS
		 , CONVERT(NVARCHAR, b.START_DATE, 121) AS START_DATE
		 , CONVERT(NVARCHAR, b.END_DATE, 121) AS END_DATE
		 , CASE WHEN a.segment2 = 'STEP01' THEN ISNULL(b.MESSAGE_TEXT, '') + @v_waitint_desc ELSE b.MESSAGE_TEXT END	AS DETAILS
	FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL a with(nolock)
	LEFT JOIN SCP_OPT_ENG_ENGINE_RUN_STATUS_DETAIL_SN b
		ON a.segment2 = b.PROGRESS_CODE AND b.PLAN_ID = @p_plan_id
	where 1=1
		and lookup_type = 'SCP_OPT_ENG_RUN_STATUS'
		and valid_yn = 'Y'
  
END

