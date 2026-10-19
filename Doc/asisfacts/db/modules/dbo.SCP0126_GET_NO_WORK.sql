


/*
 * Program ID   : SCP0126_GET_NO_WORK
 * Description  : CAPA - No Work 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/15   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/08/21   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - EE 사업부 Line Name 표시 안됨
 * 2025/08/27   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - SOP/EOP 테이블 추가에 따른 변경
 * 2025/10/13   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 비조업 일괄입력 기능 추가
 * 2025/11/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정, Line Type 추가
 * 2025/12/04   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Week 단위 조회 및 입력 방식 추가
 * 2026/06/29	ymh				E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29)
 * 2026/10/08	ymh				E20260929-000580 비조업 로직 수정 요청의 건(OPT CAPA - No Work)
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_NO_WORK]
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
		--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05) START
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
		--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05) END
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
				  --[PJ20257329] SOP/EOP 테이블 추가에 따른 변경 (2025-08-27) START
				 -- LEFT JOIN (
					--		SELECT LOOKUP_TYPE, SEGMENT2, SEGMENT3, SEGMENT4, MAX(ATTRIBUTE2) ATTRIBUTE2 
					--		  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL with(nolock) 
					--		 WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_SOP_EOP' AND VALID_YN='Y' AND SEGMENT5='SOP' 
					--		 GROUP BY LOOKUP_TYPE, SEGMENT2, SEGMENT3, SEGMENT4) SOP --SOP 이전 구간 식별(SOP/EOP 테이블 변경 시 변경 필요)
					--on la.LINE_ID = SOP.SEGMENT3
				 --  AND la.ITEM_ID = SOP.SEGMENT4
				 --  AND CONVERT(DATE, CAL.BASIS_YYYYMMDD, 120) <  CONVERT(DATE, SOP.ATTRIBUTE2, 120)
				 -- LEFT JOIN (
					--		SELECT LOOKUP_TYPE, SEGMENT2, SEGMENT3, SEGMENT4, MIN(ATTRIBUTE2) ATTRIBUTE2 
					--		  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL with(nolock) 
					--		 WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_SOP_EOP' AND VALID_YN='Y' AND SEGMENT5='EOP' 
					--		 GROUP BY LOOKUP_TYPE, SEGMENT2, SEGMENT3, SEGMENT4) EOP --EOP 이후 구간 식별(SOP/EOP 테이블 변경 시 변경 필요)
					--on la.LINE_ID = EOP.SEGMENT3
				 --  AND la.ITEM_ID = EOP.SEGMENT4
				 --  AND CONVERT(DATE, CAL.BASIS_YYYYMMDD, 120) > CONVERT(DATE, EOP.ATTRIBUTE2, 120)
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
				   --[PJ20257329] SOP/EOP 테이블 추가에 따른 변경 (2025-08-27) END
				  LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				 WHERE 1 = 1
				   AND x.ITEM_ID != '-'
				   AND RB.LOOKUP_TYPE IS NULL
				   --AND SOP.LOOKUP_TYPE IS NULL		[PJ20257329] SOP/EOP 테이블 추가에 따른 변경 (2025-08-27)
				   --AND EOP.LOOKUP_TYPE IS NULL
				 GROUP BY x.PLANT_ID, x.LINE_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, CAL.BASIS_YYYYMMDD, pg.DIVISION_ID		--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05)
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, DATE, DIVISION_ID																			--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05)
	)
	SELECT --distinct a.DIVISION_ID
		   a.DIVISION_ID
		 , b.OPMZ_PLAN_GR_NAME
		 , a.PLANT_ID
		 , a.LINE_ID
		 , l.LINE_NAME
		 , a.OPERATION_ID
		 , a.LINE_TYPE				--[PJ20257329] Line Type 추가 (2025-11-05)
		 , CONVERT(date, a.NO_WORK_DATE, 112)	AS NO_WORK_DATE
		 , ISNULL(cm.DAYOFWEEK, '')				AS DAY_OF_WEEK
		 , SUBSTRING(cm.ISO_YYYYWW, 1, 4) + '-' + cm.WEEK_NAME AS WEEK_NAME									--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
		 , FORMAT(CONVERT(NUMERIC(20,10) , a.OFF_TIME / 86400.0000000000), '0.##########') AS OFF_TIME		--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)
		 , a.[TYPE] AS NO_WORK_TYPE																		-- E20260624-000826 OPT CAPA → No Work UI 컬럼 추가 요청 (2026-06-29) -- E20260929-000580 ATTRIBUTE2 -> TYPE 으로 변경
		 , a.[DESC]
		 , a.VALID_YN
		 , a.ATTRIBUTE1	AS FIX		--[PJ20257329] 비조업 일괄입력 기능 추가 (2025-10-13)
		 , a.CREATED_BY
		 , a.CREATION_DATE
		 , a.LAST_UPDATED_BY
		 , a.LAST_UPDATE_DATE
		 , a.DIVISION_ID + '|' + a.PLANT_ID + '|' + a.LINE_ID + '|' + a.OPERATION_ID + '|' + a.LINE_TYPE + '|' + a.NO_WORK_DATE 
		   + '|' + a.[TYPE] AS PRE_KEY_VALUES		--[PJ20257329] Line Type 추가 (2025-11-05) -- E20260929-000580 TYPE(NO_WORK_TYPE) 추가.
	 FROM SCP_OPMZ_NO_WORK a WITH(NOLOCK)
	  LEFT JOIN plan_group_line b with(nolock)
		ON b.PLANT_ID = a.PLANT_ID AND b.LINE_ID = a.LINE_ID AND a.NO_WORK_DATE = CASE WHEN b.DATE = '-' THEN a.NO_WORK_DATE ELSE b.DATE END AND a.DIVISION_ID = b.DIVISION_ID	--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05)
	  LEFT JOIN line_master l with(nolock)
		--ON l.DIVISION_ID = a.DIVISION_ID AND l.PLANT_ID = a.PLANT_ID AND l.LINE_ID = a.LINE_ID AND l.operation_id = a.operation_id
		ON l.PLANT_ID = a.PLANT_ID AND l.LINE_ID = a.LINE_ID AND l.operation_id = a.operation_id	--[PJ20257329] EE 사업부 Line Name 표시 안됨(2025-08-21)
	  LEFT JOIN SCM_SYS_CALENDAR_M cm with(nolock)
	    ON cm.BASIS_YYYYMMDD = a.NO_WORK_DATE
	 WHERE 1=1 
	   AND a.DIVISION_ID = @p_division_id
	   AND SUBSTRING(a.NO_WORK_DATE,1,6) BETWEEN @p_from_yyyymm AND @p_to_yyyymm 
	   AND ( ( @p_plan_gr_id IS NULL OR  @p_plan_gr_id = '' ) OR  b.OPMZ_PLAN_GR_ID like '%'+ @p_plan_gr_id +'%' )
	   AND ( ( @p_plant_id IS NULL OR  @p_plant_id = '' ) OR l.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	   AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR l.LINE_ID IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	 ORDER BY (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END), OPMZ_PLAN_GR_NAME, a.PLANT_ID, a.LINE_ID, a.OPERATION_ID, a.NO_WORK_DATE	--[PJ20257329] Week 단위 조회 및 입력 방식 추가 (2025-12-04)

  
END

