


/*
 * Program ID   : SCP0126_GET_YLD_ELEC
 * Description  : CAPA - Yield(Elec) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/08/26   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/12/17   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회 정렬 변경
 *
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_YLD_ELEC]
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
		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, ITEM_ID, DATE) AS OPMZ_PLAN_GR_NAME
			 , STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, ITEM_ID, DATE) AS OPMZ_PLAN_GR_ID
			 , PLANT_ID, ITEM_ID, DATE
		  FROM (

				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					 , x.PLANT_ID, la.ITEM_ID, CAL.BASIS_YYYYMM AS DATE
				  FROM SCP_OPMZ_PLAN_GR_LINE_M x with(nolock)
				 INNER JOIN SCM_MST_ITEM_LINE_ASSIGN_SN la with(nolock) --월별 Line assign 정보 조인
					on x.PLANT_ID = la.PLANT_ID
				   AND x.LINE_ID = la.LINE_ID
				   AND x.OPERATION_ID = la.OPERATION_ID
				   --AND x.ITEM_ID = la.ITEM_ID
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
				   AND CONVERT(DATE, CAL.BASIS_YYYYMMDD, 120) <  CONVERT(DATE, SOP.DATE, 120)
				  LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				 WHERE 1 = 1
				   AND x.ITEM_ID = '-'
				   AND RB.LOOKUP_TYPE IS NULL
				 GROUP BY x.PLANT_ID, x.LINE_ID, la.ITEM_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, CAL.BASIS_YYYYMM

				UNION

				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					 , x.PLANT_ID, x.ITEM_ID, CAL.BASIS_YYYYMM AS DATE
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
				 GROUP BY x.PLANT_ID, x.LINE_ID, x.ITEM_ID, OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, CAL.BASIS_YYYYMM

	) A
		 WHERE 1 = 1
		 --GROUP BY PLANT_ID, LINE_ID, ITEM_ID, DATE
		 GROUP BY PLANT_ID, ITEM_ID, DATE
	)
	SELECT a.DIVISION_ID
		 , b.OPMZ_PLAN_GR_NAME
		 , a.PLANT_ID
		 , c.NICK_NAME
		 , a.ITEM_ID
		 , SUBSTRING(a.YYYYMM, 1, 4) + '-' + SUBSTRING(a.YYYYMM, 5, 2)	AS YYYYMM
		 , a.ELEC_POST
		 , a.ASSY
		 , a.VALID_YN
		 , a.LAST_UPDATED_BY
		 , a.LAST_UPDATE_DATE
		 , a.DIVISION_ID + '|' + a.PLANT_ID + '|' + a.ITEM_ID + '|' + a.YYYYMM AS PRE_KEY_VALUES
	 FROM SCP_OPMZ_YLD_ELEC a WITH(NOLOCK)
	  LEFT JOIN plan_group_line b with(nolock)
		ON b.PLANT_ID = a.PLANT_ID AND a.ITEM_ID = b.ITEM_ID AND a.YYYYMM = b.date
	  LEFT JOIN (
			SELECT ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
			FROM SCM_MST_ITEM_SN WITH(NOLOCK)
			GROUP BY  ITEM_ID
		 ) c
		ON c.ITEM_ID = a.ITEM_ID
	 WHERE 1=1 
	   AND a.DIVISION_ID = @p_division_id
	   AND a.YYYYMM BETWEEN @p_from_yyyymm AND @p_to_yyyymm
	   AND ( ( @p_plan_gr_id IS NULL OR  @p_plan_gr_id = '' ) OR  b.OPMZ_PLAN_GR_ID like '%'+ @p_plan_gr_id +'%' )
	   AND ( ( @p_plant_id IS NULL OR  @p_plant_id = '' ) OR a.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	   AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
	   AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
	 ORDER BY (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END), OPMZ_PLAN_GR_NAME, a.PLANT_ID, a.ITEM_ID, a.YYYYMM		--[PJ20257329] 조회 정렬 변경 (2025-12-17)

  
END

