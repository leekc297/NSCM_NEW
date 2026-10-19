


/*
 * Program ID   : SCP0123_GET_PLAN_CONTROL
 * Description  : Plan Control 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/05/07   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/09   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상 추가
 * 2025/08/20   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan ID 표시할 때 ATTRIBUTE1 = 'A' 인 정보 제외
 *
 */

CREATE PROCEDURE [dbo].[SCP0123_GET_PLAN_CONTROL]
	@p_division_id				NVARCHAR(50)
	, @p_plan_group_id			NVARCHAR(50)
	, @p_plan_start_yyyymmdd	NVARCHAR(50)
	, @p_actv_cd				NVARCHAR(50) = null
	, @p_plan_id				NVARCHAR(50) = null

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF(ISNULL(@p_plan_id, '') = '')
	BEGIN

		if object_id('tempdb..#temp_plan_control') is not null drop table #temp_plan_control;

		-- Plan Controls 메인정보 : Table[0]
		;with opmz_process as (
			select segment1		as OPMZ_PRS_CD
				  ,attribute1	as OPMZ_PRS_NAME
			from scm_adm_lookup_master_detail with(nolock)
			where 1=1
			  and lookup_type = 'OPMZ_PRS_CD'
			  and valid_yn = 'Y'
		), opmz_activity as (
			select segment1							as OPMZ_ACTV_CD
				  ,attribute1						as OPMZ_ACTV_NAME
				  ,attribute3						as OPMZ_PLAN_ID_INDP_YN		-- plan id 독립적 수행 activity 여부
				  ,attribute6						as CONFIRM_YN				-- CONFIRM_YN
				  ,attribute8						as OPTION_YN				-- OPTION_YN
				  ,attribute9						as LINK_NAME				-- Link 표시명
				  ,attribute10						as LINK_ADDRESS				-- Link 화면 Program ID
				  ,attribute11						as ACTION_NAME				-- Action button명 
			from scm_adm_lookup_master_detail with(nolock)
			where 1=1
			  and lookup_type = 'OPMZ_ACTV_CD'
			  and valid_yn = 'Y'
		), opmz_activity_type as (
			select segment1							as OPMZ_ACTV_TP_CD
				  ,attribute1						as OPMZ_ACTV_TP_NAME
			from scm_adm_lookup_master_detail with(nolock)
			where 1=1
			  and lookup_type = 'OPMZ_ACTV_TP_CD'
			  and valid_yn = 'Y'
		), opmz_activity_run_status as (
			select segment1							as OPMZ_ACTV_RUN_STAT_CD
				  ,attribute1						as OPMZ_ACTV_RUN_STAT_NAME
			from scm_adm_lookup_master_detail with(nolock)
			where 1=1
			  and lookup_type = 'OPMZ_ACTV_RUN_STAT_CD'  
			  and valid_yn = 'Y'
		 )
		select rm.plan_start_yyyymmdd
			  ,rm.opmz_prs_cd
			  --,op.OPMZ_PRS_NAME
			  ,pg.division_id
			  ,rm.opmz_plan_gr_id
			  ,pg.opmz_plan_gr_name 
			  ,pg.OPMZ_TGT_DIVS_CD
			  ,rm.opmz_actv_cd
			  ,oa.opmz_actv_name
			  ,oa.OPMZ_PLAN_ID_INDP_YN	 -- plan id에 독립적으로 수행 여부  
			  ,oa.CONFIRM_YN
			  ,oa.OPTION_YN
			  ,oa.LINK_NAME				AS LINK	-- Link 표시명
			  ,oa.LINK_ADDRESS			-- Link 화면 Program ID
			  ,oa.ACTION_NAME			-- Action button명 
			  ,rm.opmz_actv_seq
			  ,rd.opmz_plan_id
			  ,rd.opmz_actv_run_stat_cd		--- activity 운행  상태  
			  ,rs.opmz_actv_run_stat_name   --- activity 운행  상태  
			  ,rd.last_update_date		
			  ,rd.last_updated_by
		into #temp_plan_control
		from SCP_OPMZ_PLAN_CTRL_ACTV_M  rm  with(nolock)	
		inner join SCP_OPMZ_PLAN_GR_M pg with(nolock)   
			on pg.opmz_plan_gr_id = rm.opmz_plan_gr_id 
		inner join opmz_process op with(nolock)
			on op.opmz_prs_cd = rm.opmz_prs_cd 
		inner join opmz_activity oa with(nolock)
			on oa.opmz_actv_cd = rm.opmz_actv_cd 
		left  join SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M rd with(nolock)
			on rd.plan_start_yyyymmdd = rm.plan_start_yyyymmdd
			and rd.opmz_prs_cd			= rm.opmz_prs_cd
			and rd.opmz_plan_gr_id		= rm.opmz_plan_gr_id
			and rd.opmz_actv_cd			= rm.opmz_actv_cd
			and rd.opmz_plan_id			= case when oa.OPMZ_PLAN_ID_INDP_YN = 'Y'		then '-'
												else rm.LTST_RUN_OPMZ_PLAN_ID  -- 최종 수행  
											end 
		    and ISNULL(rd.ATTRIBUTE1, '') != 'M'	--수동으로 엔진 돌릴경우는 화면표시 대상제외
			and ISNULL(rd.ATTRIBUTE1, '') != 'A'	--[PJ20257329] Plan ID 표시할 때 ATTRIBUTE1 = 'A' 인 정보 제외(2025-08-20)
		left  join opmz_activity_run_status rs with(nolock)
			on rs.OPMZ_ACTV_RUN_STAT_CD = rd.OPMZ_ACTV_RUN_STAT_CD
		where 1=1
		  AND pg.DIVISION_ID = @p_division_id
		  AND rm.opmz_plan_gr_id = @p_plan_group_id
		  AND rm.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		ORDER BY rm.opmz_actv_seq, rm.opmz_actv_cd

		--A004항목 Activity 분리 실행으로 UPDATE 할 필요없음 (2025-06-11 요청)
		----A004 항목에 가장 최근 Engine Run 실행 완료된 정보로 갱신
		--UPDATE #temp_plan_control
		--SET #temp_plan_control.opmz_plan_id				= B.opmz_plan_id
		--  , #temp_plan_control.opmz_actv_run_stat_cd	= B.opmz_actv_run_stat_cd
		--  , #temp_plan_control.opmz_actv_run_stat_name	= 'Completed'
		--  , #temp_plan_control.last_update_date			= B.last_update_date
		--  , #temp_plan_control.last_updated_by			= B.last_updated_by
		--FROM #temp_plan_control as A, 
		--	(
		--		--가장 최근 Engine Run 실행 완료된 정보
		--		SELECT TOP 1 opmz_plan_id
		--			  , opmz_actv_run_stat_cd		
		--			  , last_update_date		
		--			  , last_updated_by
		--			  , 'A004' AS OPMZ_ACTV_CD
		--		FROM SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M
		--		where PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		--		AND OPMZ_PLAN_GR_ID = @p_plan_group_id
		--		AND OPMZ_ACTV_CD = 'A003'
		--		AND OPMZ_ACTV_RUN_STAT_CD = 'C'
		--		ORDER BY LAST_UPDATE_DATE DESC
		--	) as B
		--	WHERE A.OPMZ_ACTV_CD = B.OPMZ_ACTV_CD

		SELECT *
		FROM #temp_plan_control
		ORDER BY opmz_actv_seq

	END
	ELSE
	BEGIN

		;with opmz_activity_run_status as (
			select segment1							as OPMZ_ACTV_RUN_STAT_CD
				  ,attribute1						as OPMZ_ACTV_RUN_STAT_NAME
			from scm_adm_lookup_master_detail with(nolock)
			where 1=1
			  and lookup_type = 'OPMZ_ACTV_RUN_STAT_CD'  
			  and valid_yn = 'Y'
		 )
		select rd.opmz_actv_run_stat_cd		--- activity 운행  상태  
			  ,rs.opmz_actv_run_stat_name   --- activity 운행  상태  
			  ,rd.last_update_date		
			  ,rd.last_updated_by
		from SCP_OPMZ_PLAN_CTRL_ACTV_M  rm  with(nolock)	
		inner join SCP_OPMZ_PLAN_GR_M pg with(nolock)   
			on pg.opmz_plan_gr_id = rm.opmz_plan_gr_id 
		left  join SCP_OPMZ_PLAN_CTRL_ACTV_RUN_M rd with(nolock)
			on rd.plan_start_yyyymmdd = rm.plan_start_yyyymmdd
			and rd.opmz_prs_cd			= rm.opmz_prs_cd
			and rd.opmz_plan_gr_id		= rm.opmz_plan_gr_id
			and rd.opmz_actv_cd			= rm.opmz_actv_cd
			and rd.opmz_plan_id			= @p_plan_id
		left  join opmz_activity_run_status rs with(nolock)
			on rs.OPMZ_ACTV_RUN_STAT_CD = rd.OPMZ_ACTV_RUN_STAT_CD
		where 1=1
		  AND pg.DIVISION_ID = @p_division_id
		  AND rm.opmz_plan_gr_id = @p_plan_group_id
		  AND rm.PLAN_START_YYYYMMDD = @p_plan_start_yyyymmdd
		  and ( ( @p_Actv_cd IS NULL OR  @p_Actv_cd='' ) OR rm.opmz_actv_cd = @p_Actv_cd )

	END
  
END

