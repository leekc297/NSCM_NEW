


/*
 * Program ID   : SCP0126_GET_NO_WORK_WEEK
 * Description  : CAPA - No Work 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/12/04   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2026/06/29	ymh				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 * 2026/10/08	ymh				E20260929-000580 비조업 로직 수정 요청의 건(OPT CAPA - No Work)
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_NO_WORK_WEEK]
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
	), plan_group_line as (
		/* #######################################################################################	*/
		/* ALL로 지정한 라인은 Plan Group 마스터만 보고												*/
		/* 아이템을 지정한 라인은 해당 아이템의 line assign 정보 및 생산 제외 구간을 참고해서 보여줄 것	*/
		/* Plan Group이 2개 이상 지정된 라인에 무조건 Plan Group이 N개로 보이는게 아니라					*/
		/* Line assign 정보 및 제외 정보를 감안하여 보여주려는 목적										*/
		/* #######################################################################################	*/
		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE, DIVISION_ID) AS OPMZ_PLAN_GR_NAME
			, STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE, DIVISION_ID) AS OPMZ_PLAN_GR_ID
			, PLANT_ID, LINE_ID, DATE, DIVISION_ID
		 FROM (
				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					, PLANT_ID, LINE_ID, '-' AS DATE, pg.DIVISION_ID
				FROM SCP_OPMZ_PLAN_GR_LINE_M x with(nolock)
				LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				WHERE 1 = 1
				AND x.ITEM_ID = '-'
				GROUP BY PLANT_ID, LINE_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, pg.DIVISION_ID
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, DATE, DIVISION_ID

		UNION ALL

		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE, DIVISION_ID) AS OPMZ_PLAN_GR_NAME
			 , STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, DATE, DIVISION_ID) AS OPMZ_PLAN_GR_ID
			 , PLANT_ID, LINE_ID, DATE, DIVISION_ID
		  FROM (
				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					 , x.PLANT_ID, x.LINE_ID, CAL.BASIS_YYYYMMDD AS DATE, pg.DIVISION_ID
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
				 GROUP BY x.PLANT_ID, x.LINE_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, CAL.BASIS_YYYYMMDD, pg.DIVISION_ID
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, DATE, DIVISION_ID
	)
	SELECT DIVISION_ID
		, OPMZ_PLAN_GR_NAME
		, PLANT_ID
		, LINE_ID
		, LINE_NAME
		, OPERATION_ID
		, LINE_TYPE	
		, WEEK_NAME
		, FORMAT(SUM(OFF_TIME_DAYS), '0.##########')	AS OFF_TIME
		-- E20260929-000580 기존 로직 주석처리
		-- , MAX(NO_WORK_TYPE)		AS NO_WORK_TYPE		
		-- E20260929-000580 신규로직
		, NO_WORK_TYPE			AS NO_WORK_TYPE		
		, MAX([DESC])			AS [DESC]
		, MAX(LAST_UPDATED_BY)	AS LAST_UPDATED_BY
		, MAX(LAST_UPDATE_DATE)	AS LAST_UPDATE_DATE
		, DIVISION_ID + '|' + PLANT_ID + '|' + LINE_ID + '|' + OPERATION_ID + '|' + LINE_TYPE + '|' + WEEK_NAME 
		   + '|' + NO_WORK_TYPE AS PRE_KEY_VALUES		--[PJ20257329] Line Type 추가 (2025-11-05) -- E20260929-000580 TYPE(NO_WORK_TYPE) 추가.
	FROM (
		SELECT   a.DIVISION_ID
			 , b.OPMZ_PLAN_GR_NAME
			 , a.PLANT_ID
			 , a.LINE_ID
			 , l.LINE_NAME
			 , a.OPERATION_ID
			 , a.LINE_TYPE
			 , SUBSTRING(q.ISO_YYYYWW, 1, 4) + '-' + q.WEEK_NAME AS WEEK_NAME
			 , CONVERT(NUMERIC(20,10) , a.OFF_TIME / 86400.0000000000) AS OFF_TIME_DAYS
			 , a.TYPE AS NO_WORK_TYPE  -- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) -- E20260929-000580 ATTRIBUTER3 -> TYPE 변경
			 , a.[DESC] AS [DESC]
			 , a.LAST_UPDATED_BY
			 , a.LAST_UPDATE_DATE
		 FROM SCP_OPMZ_NO_WORK a WITH(NOLOCK)
		  LEFT JOIN plan_group_line b with(nolock)
			ON b.PLANT_ID = a.PLANT_ID AND b.LINE_ID = a.LINE_ID AND a.NO_WORK_DATE = CASE WHEN b.DATE = '-' THEN a.NO_WORK_DATE ELSE b.DATE END AND a.DIVISION_ID = b.DIVISION_ID
		  LEFT JOIN line_master l with(nolock)
			ON l.PLANT_ID = a.PLANT_ID AND l.LINE_ID = a.LINE_ID AND l.operation_id = a.operation_id
		  LEFT JOIN SCM_SYS_CALENDAR_M cm with(nolock)
			ON cm.BASIS_YYYYMMDD = a.NO_WORK_DATE
		  LEFT JOIN scm_sys_calendar_m q with(nolock)
			ON q.BASIS_YYYYMMDD = a.NO_WORK_DATE
		 WHERE 1=1 
		   AND a.DIVISION_ID = @p_division_id
		   AND SUBSTRING(a.NO_WORK_DATE,1,6) BETWEEN @p_from_yyyymm AND @p_to_yyyymm
		   AND ( ( @p_plan_gr_id IS NULL OR  @p_plan_gr_id = '' ) OR  b.OPMZ_PLAN_GR_ID like '%'+ @p_plan_gr_id +'%' )
		   AND ( ( @p_plant_id IS NULL OR  @p_plant_id = '' ) OR l.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
		   AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR l.LINE_ID IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
		 ) A
	GROUP BY DIVISION_ID
		, OPMZ_PLAN_GR_NAME
		, PLANT_ID
		, LINE_ID
		, LINE_NAME
		, OPERATION_ID
		, LINE_TYPE
		, WEEK_NAME
		, A.NO_WORK_TYPE -- E20260929-000580
	ORDER BY (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END), OPMZ_PLAN_GR_NAME, PLANT_ID, LINE_ID, OPERATION_ID, WEEK_NAME

  
END

