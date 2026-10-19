


/*
 * Program ID   : SCP0126_GET_UTIL_RT
 * Description  : CAPA - Utilization Rate 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/08/22   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/09/08   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Insert 할 때 OSP 라인들 표시 필요
 * 2025/10/20   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회조건의 구간이 From/to 구간에 일부라도 포함되면 조회되도록
 * 2025/12/17   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회 정렬 변경
 *
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_UTIL_RT]
	@p_division_id				NVARCHAR(50)
	, @p_plan_gr_id				NVARCHAR(50)
	, @p_from_yyyymm			NVARCHAR(6)
	, @p_to_yyyymm				NVARCHAR(6)
	, @p_plant_id				NVARCHAR(MAX)
	, @p_line_id				NVARCHAR(MAX)
	, @p_nick_name				NVARCHAR(200)
	, @p_item_id				NVARCHAR(200)

AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	;WITH line_master as ( 
		select l.company_id
			  ,l.division_id
			  ,l.site_id
			  ,l.plant_id
			  ,l.factory_id
			  ,f.factory_name
			  ,l.operation_id
			  ,l.line_id
			  ,max(l.line_name) as line_name 
		 from scm_mst_line_sn l with(nolock)
		inner join scm_mst_factory_sn f with(nolock)
		   on f.company_id = l.company_id
		  and f.factory_id = l.factory_id 
		where 1=1
		  and l.active_flag =  'Y'
		group by l.company_id
				,l.division_id
				,l.site_id
				,l.plant_id
				,l.factory_id
				,f.factory_name
				,l.operation_id
				,l.line_id

		--[PJ20257329] Insert 할 때 OSP 라인들 표시 필요 (2025-09-08) START
		UNION
		select site.COMPANY_ID				as company_id
			  ,osp.division_id
			  ,osp.scm_site_id	as site_id
			  ,site.plant_id
			  ,'-'				as factory_id
			  ,'-'				as factory_name
			  ,osp.operation_id
			  ,osp.line_id
			  ,osp.line_name 
		  from SCM_MST_LINE_OSP osp with(nolock)
		  join scm_mst_site site with(nolock)
			on osp.division_id = site.division_id
		   and osp.scm_site_id = site.scm_site_id
		  LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) 
			ON V.VENDOR_CODE = site.plant_id AND site.COMPANY_ID = V.COMPANY_ID
		 where osp.valid_yn = 'Y' and site.valid_yn = 'Y'
		 --[PJ20257329] Insert 할 때 OSP 라인들 표시 필요 (2025-09-08) END
	), plan_group_line as (
		/* #######################################################################################	*/
		/* ALL로 지정한 라인은 Plan Group 마스터만 보고												*/
		/* 아이템을 지정한 라인은 해당 아이템의 line assign 정보 및 생산 제외 구간을 참고해서 보여줄 것	*/
		/* Plan Group이 2개 이상 지정된 라인에 무조건 Plan Group이 N개로 보이는게 아니라					*/
		/* Line assign 정보 및 제외 정보를 감안하여 보여주려는 목적										*/
		/* #######################################################################################	*/
		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE) AS OPMZ_PLAN_GR_NAME
			, STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE) AS OPMZ_PLAN_GR_ID
			, PLANT_ID, LINE_ID, DATE
		 FROM (
				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					, PLANT_ID, LINE_ID, '-' AS DATE
				FROM SCP_OPMZ_PLAN_GR_LINE_M x with(nolock)
				LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				WHERE 1 = 1
				AND x.ITEM_ID = '-'
				GROUP BY PLANT_ID, LINE_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, DATE

		UNION ALL

		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE) AS OPMZ_PLAN_GR_NAME
			 , STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE) AS OPMZ_PLAN_GR_ID
			 , PLANT_ID, LINE_ID, DATE
		  FROM (
				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					 , x.PLANT_ID, x.LINE_ID, CAL.BASIS_YYYYMMDD AS DATE
				  FROM SCP_OPMZ_PLAN_GR_LINE_M x with(nolock)
				 INNER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN la with(nolock) --월별 Line assign 정보 조인
					on x.PLANT_ID = la.PLANT_ID
				   AND x.LINE_ID = la.LINE_ID
				   AND x.OPERATION_ID = la.OPERATION_ID
				   AND x.ITEM_ID = la.ITEM_ID
				   AND la.PRIORITY <> 9
				   AND la.ACTIVE_FLAG = 'Y'
				 INNER JOIN SCM_SYS_CALENDAR_M CAL with(nolock) -- 월을 일자로 변환
					on la.MONTH = CAL.BASIS_YYYYMM
				  LEFT JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL RB with(nolock) -- 라우팅 제외 구간 식별
					on RB.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_ROUTING_BLOCKING'
				   AND RB.VALID_YN = 'Y'
				   AND la.LINE_ID = RB.SEGMENT6
				   AND la.ITEM_ID = RB.SEGMENT5
				   AND CONVERT(DATE, CAL.BASIS_YYYYMMDD, 120) BETWEEN CONVERT(DATE, RB.ATTRIBUTE1, 120) AND CONVERT(DATE, RB.ATTRIBUTE2, 120)
				 LEFT JOIN (
							SELECT DIVISION_ID, LINE_ID, ITEM_ID, MAX(DATE) DATE 
							  FROM SCP_OPMZ_SOP_EOP with(nolock) 
							 WHERE  VALID_YN = 'Y' AND TYPE = 'SOP' 
							 GROUP BY  DIVISION_ID, LINE_ID, ITEM_ID) SOP --SOP 이전 구간 식별
					on la.LINE_ID = SOP.LINE_ID
				   AND la.ITEM_ID = SOP.ITEM_ID
				   AND CONVERT(DATE, CAL.BASIS_YYYYMMDD, 120) <  CONVERT(DATE, SOP.DATE, 120)
				 LEFT JOIN (
							SELECT DIVISION_ID, LINE_ID, ITEM_ID, MAX(DATE) DATE 
							  FROM SCP_OPMZ_SOP_EOP with(nolock) 
							 WHERE  VALID_YN = 'Y' AND TYPE = 'EOP' 
							 GROUP BY  DIVISION_ID, LINE_ID, ITEM_ID) EOP --EOP 이후 구간 식별
					on la.LINE_ID = EOP.LINE_ID
				   AND la.ITEM_ID = EOP.ITEM_ID
				   AND CONVERT(DATE, CAL.BASIS_YYYYMMDD, 120) > CONVERT(DATE, EOP.DATE, 120)
				  LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				 WHERE 1 = 1
				   AND x.ITEM_ID != '-'
				   AND RB.LOOKUP_TYPE IS NULL
				 GROUP BY x.PLANT_ID, x.LINE_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, CAL.BASIS_YYYYMMDD
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, DATE
	)
	SELECT DISTINCT a.DIVISION_ID
		 , b.OPMZ_PLAN_GR_NAME
		 , (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END) AS OPMZ_PLAN_GR_NAME_SEQ
		 , a.PLANT_ID
		 , a.LINE_ID
		 , l.LINE_NAME
		 , a.OPERATION_ID
		 , CONVERT(date, a.FROM_DATE, 112)	AS FROM_DATE
		 , CONVERT(date, a.TO_DATE, 112)	AS TO_DATE
		 , a.UTIL_RT
		 , a.VALID_YN
		 , a.CREATED_BY
		 , a.CREATION_DATE
		 , a.LAST_UPDATED_BY
		 , a.LAST_UPDATE_DATE
		 , a.DIVISION_ID + '|' + a.PLANT_ID + '|' + a.LINE_ID + '|' + a.OPERATION_ID + '|' + a.FROM_DATE + '|' + a.TO_DATE AS PRE_KEY_VALUES
	 FROM SCP_OPMZ_UTIL_RT a WITH(NOLOCK)
	  LEFT JOIN plan_group_line b with(nolock)
		ON b.PLANT_ID = a.PLANT_ID AND b.LINE_ID = a.LINE_ID AND (a.FROM_DATE <= CASE WHEN b.DATE = '-' THEN a.FROM_DATE ELSE b.DATE END OR a.TO_DATE >= CASE WHEN b.DATE = '-' THEN a.TO_DATE ELSE b.DATE END)
	  LEFT JOIN line_master l with(nolock)
		ON l.PLANT_ID = a.PLANT_ID AND l.LINE_ID = a.LINE_ID AND l.operation_id = a.operation_id
	 WHERE 1=1 
	   AND a.DIVISION_ID = @p_division_id
	   --[PJ20257329] 조회조건의 구간이 From/to 구간에 일부라도 포함되면 조회되도록 (2025-10-20) START
	   AND ( (SUBSTRING(a.FROM_DATE,1,6) BETWEEN @p_from_yyyymm AND @p_to_yyyymm)
			OR (SUBSTRING(a.TO_DATE,1,6) BETWEEN @p_from_yyyymm AND @p_to_yyyymm)
			OR (@p_from_yyyymm BETWEEN SUBSTRING(a.FROM_DATE,1,6) AND SUBSTRING(a.TO_DATE,1,6))
			OR (@p_to_yyyymm BETWEEN SUBSTRING(a.FROM_DATE,1,6) AND SUBSTRING(a.TO_DATE,1,6))
			)
	   --[PJ20257329] 조회조건의 구간이 From/to 구간에 일부라도 포함되면 조회되도록 (2025-10-20) END
	   AND ( ( @p_plan_gr_id IS NULL OR  @p_plan_gr_id = '' ) OR  b.OPMZ_PLAN_GR_ID like '%'+ @p_plan_gr_id +'%' )
	   AND ( ( @p_plant_id IS NULL OR  @p_plant_id = '' ) OR l.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	   AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR l.LINE_ID IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	 ORDER BY (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END), OPMZ_PLAN_GR_NAME, a.PLANT_ID, a.LINE_ID, a.OPERATION_ID, CONVERT(date, a.FROM_DATE, 112), CONVERT(date, a.TO_DATE, 112)		--[PJ20257329] 조회 정렬 변경 (2025-12-17)

  
END

