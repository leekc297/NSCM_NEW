


/*
 * Program ID   : SCP0126_GET_CAPA_SEARCH_INFO
 * Description  : CAPA화면 조회 및 콤보박스 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/25   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/09/03   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - OSP Plant 및 라인도 표시
 * 2025/09/11   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Insert 할 때 OSP 라인들 표시 필요, 탭별 사업부 표시제외 추가(임시)
 * 2025/11/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Line Type 추가
 * 2026/06/08	YMH				E20260424-001741 OPT CAPA화면 Yield(Elec.) 탭에서 신규 데이터 Insert 시 NB02 Plant 조회 안되는건
 * 2026/07/03	YMH				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_CAPA_SEARCH_INFO]
  
	
AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	IF object_id('tempdb..#division_info') IS NOT NULL DROP TABLE #division_info;
	IF object_id('tempdb..#line_master') IS NOT NULL DROP TABLE #line_master;

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

	select l.company_id
		,l.division_id
		,l.site_id
		,l.plant_id
		,l.factory_id
		,f.factory_name
		,l.operation_id
		,l.line_id
		,max(l.line_name) as line_name 
	INTO #line_master
	from scm_mst_line_sn l with(nolock)
		inner join scm_mst_factory_sn f with(nolock)
				on f.company_id = l.company_id
				and f.factory_id = l.factory_id 
	where 1=1
	and exists (select *
					from scm_adm_lookup_master_detail  op with(nolock)
					where 1=1
					  and op.lookup_type = 'SCP_PLAN_OPERATION'
					  and op.valid_yn = 'Y'
					  and op.segment1 = l.operation_id
					  and op.segment4 like concat('%', l.division_id, '%')) 
	and l.active_flag =  'Y'
	group by l.company_id
			,l.division_id
			,l.site_id
			,l.plant_id
			,l.factory_id
			,f.factory_name
			,l.operation_id
			,l.line_id
		;

	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시(2025-09-03) START
	IF object_id('tempdb..#osp_plant_info') IS NOT NULL DROP TABLE #osp_plant_info;

	select site.plant_id, V.VENDOR_NAME AS plant_name, osp.*
	  into #osp_plant_info
	  from SCM_MST_LINE_OSP osp with(nolock)
      join scm_mst_site site with(nolock)
        on osp.division_id = site.division_id
       and osp.scm_site_id = site.scm_site_id
	  LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) 
	    ON V.VENDOR_CODE = site.plant_id AND site.COMPANY_ID = V.COMPANY_ID
     where osp.valid_yn = 'Y' and site.valid_yn = 'Y'

	--1. Plant id 정보
	select distinct l.plant_id				AS CODE
		, l.plant_id + ' ' + p.PLANT_NAME	AS NAME
		, d.division_id
		, d.org_division_id 
		, 1 AS SEQ
	from #line_master l with(nolock)
	inner join #division_info d 
		on l.division_id = d.org_division_id
		-- E20260424-001741 OPT CAPA화면 Yield(Elec.) 탭에서 신규 데이터 Insert 시 NB02 Plant 조회 안되는건 수정을 위해 주석처리 시작
		/*
		and l.operation_id = case when d.division_dv  = 'EE'
									then 'E2000'
									else l.operation_id
								end 
		*/
		-- E20260424-001741 OPT CAPA화면 Yield(Elec.) 탭에서 신규 데이터 Insert 시 NB02 Plant 조회 안되는건 수정을 위해 주석처리 끝
		-- E20260424-001741 OPT CAPA화면 Yield(Elec.) 탭에서 신규 데이터 Insert 시 NB02 Plant 조회 안되는건 수정을 위해 신규로직 시작
		and 
		(		
			(d.division_dv = 'EE' AND l.operation_id IN ('E2000','A9000'))
			OR
			(d.division_dv != 'EE') 
		)
		-- E20260424-001741 OPT CAPA화면 Yield(Elec.) 탭에서 신규 데이터 Insert 시 NB02 Plant 조회 안되는건 수정을 위해 신규로직 끝
		

		and l.operation_id != case when d.division_dv = 'EE'
									then 'Z'
									else 'E2000'
								end 
	LEFT JOIN (
				select distinct PLANT_ID, PLANT_NAME
				from SCP_MST_CAPA_LINE
				) P
		ON p.PLANT_ID = l.plant_id
	where 1=1

	UNION
	select plant_id						as CODE
		, plant_id + ' ' + plant_name	as NAME
		, division_id
		, division_id					as org_division_id 
		, 2 AS SEQ
	from #osp_plant_info
	ORDER BY SEQ, division_id, CODE
	;


	--2. Line id 정보
	SELECT CODE, NAME, division_id, org_division_id, operation_id, plant_id, factory_id, LINE_NAME
		, 1 AS SEQ
	FROM (
	select distinct l.LINE_ID				AS CODE
		, l.LINE_ID + '   ' + l.LINE_NAME	AS NAME
		, d.division_id
		, d.org_division_id 
		, l.operation_id
		, l.plant_id
		, l.factory_id
		, l.LINE_NAME
	from #line_master l with(nolock)
	inner join #division_info d 
		on l.division_id = d.org_division_id
		and l.operation_id = case when d.division_dv  = 'EE'
									then 'E2000'
									else l.operation_id
								end 
		and l.operation_id != case when d.division_dv = 'EE'
									then 'Z'
									else 'E2000'
								end 
	where 1=1
	) a
	JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK)
	  ON ld.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION' AND ld.valid_yn = 'Y' AND ld.SEGMENT1 = a.DIVISION_ID AND ld.SEGMENT2 = a.OPERATION_ID

	UNION
	select LINE_ID						as CODE
		, LINE_ID + ' ' + LINE_NAME		as NAME
		, division_id
		, division_id					as org_division_id 
		, operation_id
		, plant_id
		, '-' AS factory_id
		, LINE_NAME
		, 2 AS SEQ
	from #osp_plant_info
	ORDER BY SEQ, division_id, CODE
	;

	--[PJ20257329] Insert 할 때 OSP 라인들 표시 필요 (2025-09-08) START
	--3. 사업부별 Operation 정보
	SELECT DISTINCT B.SEGMENT2	AS CODE
		 , B.SEGMENT2			AS NAME
		 , B.SEGMENT1			AS DIVISION_ID
		, 1 AS SEQ
	  FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	  LEFT JOIN SCM_OPERATION_M_SN op WITH(NOLOCK)
		ON B.SEGMENT2 = op.OPERATION_ID AND op.ACTIVE_FLAG = 'Y'
	 WHERE A.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION'
	   AND A.VALID_YN = 'Y'

	UNION
	select OPERATION_ID			as CODE
		, OPERATION_ID			as NAME
		, division_id
		, 2 AS SEQ
	from #osp_plant_info
	ORDER BY SEQ, division_id, CODE
	--[PJ20257329]Insert 할 때 OSP 라인들 표시 필요 (2025-09-08) END

	--[PJ20257329] 탭별 사업부 표시제외 추가(임시) (2025-09-11) START
	--4. 탭별 사업부 표시제외 정보
	SELECT DISTINCT B.SEGMENT2	AS SHEET_NAME
		 , B.SEGMENT3			AS DIVISION_ID
	  FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	 WHERE A.LOOKUP_TYPE = 'OPMZ_OPT_CAPA_EXPT_DIV'
	   AND A.VALID_YN = 'Y'
	--[PJ20257329] 탭별 사업부 표시제외 추가(임시) (2025-09-11) END
	--[PJ20257329] 사업부별 Operation 룩업으로부터 Operation 및 라인 표시, OSP Plant 및 라인도 표시(2025-09-03) END

	--[PJ20257329] Line Type 추가 (2025-11-05) START
	--5. Line Type 정보
	SELECT B.SEGMENT2	AS CODE
		 , B.SEGMENT2	AS NAME
		 , B.SEGMENT1	AS OPERATION_ID
	  FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
		ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	 WHERE A.LOOKUP_TYPE = 'OPMZ_LINE_TYPE'
	   AND A.VALID_YN = 'Y'
	 ORDER BY DISPLAY_SEQ
	--[PJ20257329] Line Type 추가 (2025-11-05) END

	-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 TYPE 컬럼 추가 시작
	--6 . 
	SELECT B.SEGMENT1	AS CODE
		 , B.SEGMENT2	AS NAME
	  FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)
	 INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
		ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'
	 WHERE A.LOOKUP_TYPE = 'NO_WORK_TYPE'
	   AND A.VALID_YN = 'Y'
	 ORDER BY DISPLAY_SEQ
	-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 TYPE 컬럼 추가 끝

  
END

