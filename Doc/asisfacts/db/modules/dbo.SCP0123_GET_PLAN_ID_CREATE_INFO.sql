


/*
 * Program ID   : SCP0123_GET_PLAN_ID_CREATE_INFO
 * Description  : Plan Control 정보 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/05/09   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/06/09   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Target 대상 추가
 * 2025/06/19   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - SCP Code값 변경
 * 2025/07/02   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - SCP PLAN ID 정렬순서 수정, EE(전극)의 Frozen을 가져오기 위해 division 조건 제외
 * 2025/07/08   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - No Frozen 체크 추가
 * 2025/08/26   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 특정 사업부의 Plan Horizon-End Date 변경가능하도록 룩업연동
 * 2025/09/01   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 일단위 Plan date 운영(81_UC, EE_UC)
 * 2025/09/30   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 전극사업부 선택시 FP Cutoff일자 표시하도록 수정
 * 2025/10/13   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Horizon End 일자 변경 가능하도록 수정
 * 2026/09/04	ymh				E20260812-000909 [ESS] Supply > OPT Plan > Plan Control 의 Create Plan ID 팝업 변경 요청드립니다.
 */

CREATE PROCEDURE [dbo].[SCP0123_GET_PLAN_ID_CREATE_INFO]
	@p_division_id				NVARCHAR(50)
	, @p_plan_group_id			NVARCHAR(50)
	, @p_plan_start_yyyymmdd	NVARCHAR(8)
	, @p_plan_id				NVARCHAR(50)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	DECLARE @horizon_start_date NVARCHAR(MAX) = '';
	DECLARE @horizon_end_date NVARCHAR(MAX) = '';
	DECLARE @version_no NVARCHAR(MAX) = '';
	DECLARE @prod_frozen_date NVARCHAR(MAX) = '';
	DECLARE @ship_frozen_date NVARCHAR(MAX) = '';

	--[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) START
	DECLARE @monday_date nvarchar(8) = '';
	DECLARE @sunday_date nvarchar(8) = '';

	-- 주의 시작 요일이 월요일로 설정
	SET DATEFIRST 1
	SET @monday_date = CONVERT(char(8), DATEADD(day, 1 - DATEPART(weekday, CONVERT(datetime, @p_plan_start_yyyymmdd)), CONVERT(datetime, @p_plan_start_yyyymmdd)), 112);
	SET @sunday_date = CONVERT(char(8), DATEADD(day, 7 - DATEPART(weekday, CONVERT(datetime, @p_plan_start_yyyymmdd)), CONVERT(datetime, @p_plan_start_yyyymmdd)), 112);
	--[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01) END

	--[PJ20257329]특정 사업부의 Plan Horizon-End Date 변경가능하도록 룩업연동(2025-08-26) START
	DECLARE @plan_days NVARCHAR(20)	= ''
	DECLARE @CNT INT = 0

	SELECT @CNT = COUNT(*)
	FROM scm_adm_lookup_master_detail WITH(NOLOCK)
	WHERE 1=1
	AND LOOKUP_TYPE = 'OPMZ_PLAN_END_DATE'
	AND SEGMENT1 = @p_division_id
	AND VALID_YN = 'Y'

	IF (@CNT > 0)
	BEGIN
		SELECT @plan_days = SEGMENT2
		FROM scm_adm_lookup_master_detail WITH(NOLOCK)
		WHERE 1=1
		AND LOOKUP_TYPE = 'OPMZ_PLAN_END_DATE'
		AND SEGMENT1 = @p_division_id
		AND VALID_YN = 'Y'

		SELECT @horizon_end_date = CONVERT(char(10), dateadd(day, CONVERT(INT, @plan_days), CONVERT(datetime, @p_plan_start_yyyymmdd)), 23)
	END
	ELSE
	BEGIN

		select @horizon_end_date = CONVERT(char(10), CONVERT(datetime, horizon_end_date), 23)
		from scm_mst_plan with(nolock)
		where 1=1
		  and division_id = @p_division_id
		  and plan_cycle = 'WEEKLY'
		  --and plan_name = @p_plan_start_yyyymmdd
		  and plan_name BETWEEN @monday_date AND @sunday_date	--[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01)
	END
	--[PJ20257329]특정 사업부의 Plan Horizon-End Date 변경가능하도록 룩업연동(2025-08-26) END


	--select distinct @version_no = version_no
	select @version_no = MAX(version_no)
	from DM_PLN_NET_DEMAND with(nolock) 
	where 1=1
	  and division_id = @p_division_id
	  --and cutoff_yyyymmdd = (select max(cutoff_yyyymmdd) from DM_PLN_NET_DEMAND with(nolock) )  
	  --and cutoff_yyyymmdd = @p_plan_start_yyyymmdd
	  and cutoff_yyyymmdd BETWEEN @monday_date AND @sunday_date	--[PJ20257329]일단위 Plan date 운영(81_UC, EE_UC)(2025-09-01)

	-- Table[0]
	select @horizon_end_date, @version_no;

	-- Table[1]
	select operation_group
		,  CONVERT(char(10), dateadd(day, max(prod_frozen) - 1, CONVERT(datetime, @p_plan_start_yyyymmdd)), 23)	as prod_frozen
		,  CONVERT(char(10), dateadd(day, max(ship_frozen) - 1, CONVERT(datetime, @p_plan_start_yyyymmdd)), 23) as ship_frozen
	from SCM_MST_SITE with(nolock)​
	where site_type = 'PLANT'​
	  --and division_id = @p_division_id	EE(전극)의 Frozen을 가져오기 위해 division 조건 제외 (2025-07-02)
	  and plant_id in (
						SELECT distinct PLANT_ID
						FROM SCP_OPMZ_PLAN_GR_LINE_M WITH(NOLOCK)
						WHERE OPMZ_PLAN_GR_ID = @p_plan_group_id
						AND VALID_YN = 'Y'
						)​
	and operation_group in ('A','E','P')​
	group by operation_group​

	--[PJ20257329] 전극사업부 선택시 FP Cutoff일자 표시하도록 수정 (2025-09-30) START
	IF object_id('tempdb..#division_info') IS NOT NULL DROP TABLE #division_info;

	select d.division_id
		 , r.division_id	as org_division_id 
		 , d.attribute3		as division_dv
	INTO #division_info
	from scm_mst_division d with(nolock)
		  inner join scm_mst_division r with(nolock)
				  on d.attribute4 = r.attribute4
				 and ( (d.attribute3 != 'EE' and d.division_id = r.division_id)
					  or
					   (d.attribute3 = 'EE'  and r.attribute3 != 'EE') 
					 ) 
	where 1=1
	  and d.valid_yn = 'Y'
	  and r.valid_yn = 'Y'
	;
	
	-- Table[2]
	SELECT *
	FROM (
			select top 1 YYYYMMDD		AS CODE
				, YYYYMMDD + ' Cut off'	AS NAME
				, 'FP'					AS PLAN_TYPE
			from scm_dnm_fp_release_prod_plan_c c with(nolock)
			inner join #division_info d 
				on c.division_id = d.org_division_id
				and c.operation_id = case when d.division_dv  = 'EE'
											then 'E2000'
											else c.operation_id
										end 
				and c.operation_id != case when d.division_dv = 'EE'
											then 'Z'
											else 'E2000'
										end 
			where d.division_id = @p_division_id
			and yyyymmdd <= @p_plan_start_yyyymmdd
			GROUP BY	c.DIVISION_ID
						, YYYYMMDD
			order by yyyymmdd desc
	) A
	--[PJ20257329] 전극사업부 선택시 FP Cutoff일자 표시하도록 수정 (2025-09-30) END
	UNION ALL
	SELECT 'Latest FP Plan'	AS CODE
		,  'Latest FP Plan'	AS NAME
		,  'FP'					AS PLAN_TYPE
	UNION ALL
	select 'Current'	AS CODE
		,  'Current'	AS NAME
		,  'SSP'		AS PLAN_TYPE

	-- SCP 당주 포함 W-2 구간의 SCP 계획(PR, MA, FN 전부 표시)​
	declare @date_1   nvarchar(8) = '';
	declare @date_2   nvarchar(8) = '';

	select @date_1 = MAX(plan_start_yyyymmdd)
	from SCP_PLAN_VERSION_V WITH(NOLOCK)
	where  plan_start_yyyymmdd <= @p_plan_start_yyyymmdd

	set @date_2 = CONVERT(char(8), dateadd(day, -7, CONVERT(datetime, @date_1)), 112)
	--SELECT @date_1, @date_2

	-- Table[3]
	--SELECT plan_start_yyyymmdd + '_' + division_id + '_' + plan_type + '_' +  CONVERT(NVARCHAR, MAX(PLAN_SEQ)) as CODE
	--SCP PLAN ID 정렬순서 수정(2025-07-04)
	SELECT MAX(plan_version_id) as CODE	-- SCP Code값 변경(2025-06-19)
		,  plan_start_yyyymmdd + '_' + division_id + '_' + plan_type + '_' + CONVERT(NVARCHAR, MAX(PLAN_SEQ)) as NAME
		, 'SCP' AS PLAN_TYPE
		, PLAN_TYPE_ORDER
	FROM SCP_PLAN_VERSION_V WITH(NOLOCK)
	WHERE division_id = @p_division_id
	AND plan_start_yyyymmdd in (@date_1, @date_2)
	GROUP BY plan_start_yyyymmdd, division_id, plan_type, PLAN_TYPE_ORDER
	ORDER BY PLAN_START_YYYYMMDD desc, PLAN_TYPE_ORDER desc, DIVISION_ID	-- 내림차순으로 정렬(2025-07-08)

	-- Table[4]
	SELECT OPMZ_PLAN_ID
		, OPMZ_PRAM_TP_CD
		, OPMZ_PLAN_DESC
		, PROD_REF_SYS_DIVS_CD
		, PROD_REF_SYS_PLAN_ID
		, PLAN_END_YYYYMMDD		--[PJ20257329] Horizon End 일자 변경 가능하도록 수정 (2025-10-13)
		, PMDU_PROD_FRZ_START_YYYYMMDD
		, PMDU_PROD_FRZ_END_YYYYMMDD
		, CELL_PROD_FRZ_START_YYYYMMDD
		, CELL_PROD_FRZ_END_YYYYMMDD
		, SHIP_REF_SYS_DIVS_CD
		, SHIP_REF_SYS_PLAN_ID
		, SHIP_FRZ_START_YYYYMMDD
		, SHIP_FRZ_END_YYYYMMDD
		, ATTRIBUTE1 AS PROD_NO_FROZEN_YN		-- E20260812-000909 기존컬럼 팩/모듈 생산 프로즌YN 같이 사용
		, ATTRIBUTE2 AS CELL_NO_FROZEN_YN		-- E20260812-000909 기존컬럼 셀 프로즌YN 같이 사용
		, ATTRIBUTE3 AS SHIP_NO_FROZEN_YN		
		, ATTRIBUTE4 AS LINK_PROD_NO_FROZEN_YN	-- E20260812-000909 추가	링크 생산 프로즌YN
		, ATTRIBUTE5 AS LINK_SHIP_NO_FROZEN_YN	-- E20260812-000909 추가	링크 생산 프로즌YN
		, ATTRIBUTE6 AS PMDU_SHIP_NO_FROZEN_YN	-- E20260812-000909 추가	팩/모듈 생산 프로즌YN
		, ATTRIBUTE7 AS CELL_SHIP_NO_FROZEN_YN	-- E20260812-000909 추가	셀 생산 프로즌YN
		, LINK_PROD_FRZ_START_YYYYMMDD			-- E20260812-000909 추가	링크 생산 프로즌 시작일자
		, LINK_PROD_FRZ_END_YYYYMMDD			-- E20260812-000909 추가	링크 생산 프로즌 종료일자
		, LINK_SHIP_FRZ_START_YYYYMMDD			-- E20260812-000909 추가	링크 출하 프로즌 시작일자
		, PMDU_SHIP_FRZ_START_YYYYMMDD			-- E20260812-000909 추가	팩/모듈 출하 프로즌 시작일자
		, CELL_SHIP_FRZ_START_YYYYMMDD			-- E20260812-000909 추가	셀 출하 프로즌 시작일자
		, LINK_SHIP_FRZ_END_YYYYMMDD			-- E20260812-000909 추가	링크 출하 프로즌 종료일자
		, PMDU_SHIP_FRZ_END_YYYYMMDD			-- E20260812-000909 추가	팩/모듈 출하 프로즌 종료일자
		, CELL_SHIP_FRZ_END_YYYYMMDD			-- E20260812-000909 추가	셀 출하 프로즌 종료일자

	FROM SCP_OPMZ_PLAN_M WITH(NOLOCK)
	WHERE OPMZ_PLAN_ID = @p_plan_id

	-- TABLE[5] -- E20260812-000909 추가.
	SELECT  
			  B.SEGMENT3	AS CODE
			, B.ATTRIBUTE1	AS NAME
			, B.SEGMENT1	AS DIVISION_ID
			, B.SEGMENT2	AS PLAN_GROUP
	FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	WHERE A.LOOKUP_TYPE = 'OPMZ_PRAM_TP_CD'
		AND A.VALID_YN = 'Y'
	ORDER BY B.DISPLAY_SEQ


  
END

