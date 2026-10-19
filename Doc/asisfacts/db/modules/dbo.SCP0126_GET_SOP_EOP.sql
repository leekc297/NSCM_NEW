


/*
 * Program ID   : SCP0126_GET_SOP_EOP
 * Description  : CAPA - SOP/EOP 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/08/11   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/09/08   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Insert 할 때 OSP 라인들 표시 필요
 * 2025/11/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정, Line Type 추가
 * 2025/12/17   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회 정렬 변경
 *
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_SOP_EOP]
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
		select ''				as company_id
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
		--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05) START
		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, ITEM_ID) AS OPMZ_PLAN_GR_NAME
			, STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, ITEM_ID) AS OPMZ_PLAN_GR_ID
			, PLANT_ID, LINE_ID, a.ITEM_ID, DIVISION_ID
		 FROM (
				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					, PLANT_ID, LINE_ID, ITEM_ID , pg.DIVISION_ID
				FROM SCP_OPMZ_PLAN_GR_LINE_M x with(nolock)
				LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				WHERE 1 = 1
				AND pg.VALID_YN = 'Y'		--[PJ20257329] 조회 정렬 변경 (2025-12-17)
				GROUP BY PLANT_ID, LINE_ID, ITEM_ID, pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID, pg.DIVISION_ID
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, a.ITEM_ID, DIVISION_ID
		--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05) END
	)
	SELECT a.DIVISION_ID
		 , b.OPMZ_PLAN_GR_NAME
		 , a.PLANT_ID
		 , a.LINE_ID
		 , l.LINE_NAME
		 , a.OPERATION_ID
		 , a.LINE_TYPE				--[PJ20257329] Line Type 추가 (2025-11-05)
		 , c.NICK_NAME
		 , a.ITEM_ID
		 , a.TYPE
		 , CONVERT(date, a.DATE, 112) AS DATE
		 , a.[DESC]
		 , a.VALID_YN
		 , a.LAST_UPDATED_BY
		 , a.LAST_UPDATE_DATE
		 , a.DIVISION_ID + '|' + a.PLANT_ID + '|' + a.LINE_ID + '|' + a.OPERATION_ID + '|' + a.LINE_TYPE + '|' + a.ITEM_ID + '|' + a.TYPE  + '|' + a.DATE AS PRE_KEY_VALUES
	 FROM SCP_OPMZ_SOP_EOP a WITH(NOLOCK)
	  LEFT JOIN plan_group_line b with(nolock)
		ON b.PLANT_ID = a.PLANT_ID AND b.LINE_ID = a.LINE_ID AND a.ITEM_ID = CASE WHEN b.ITEM_ID = '-' THEN a.ITEM_ID ELSE b.ITEM_ID END AND a.DIVISION_ID = b.DIVISION_ID	--[PJ20257329] Plan Group 표시할때 Div내에서 Plan Group 찾아서 표시하도록 수정 (2025-11-05)
	  LEFT JOIN (
			SELECT ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
			FROM SCM_MST_ITEM_SN WITH(NOLOCK)
			GROUP BY  ITEM_ID
		 ) c
		ON c.ITEM_ID = a.ITEM_ID
	  LEFT JOIN line_master l with(nolock)
		ON l.PLANT_ID = a.PLANT_ID AND l.LINE_ID = a.LINE_ID AND l.operation_id = a.operation_id
	 WHERE 1=1 
	   AND a.DIVISION_ID = @p_division_id
	   AND SUBSTRING(a.DATE,1,6) BETWEEN @p_from_yyyymm AND @p_to_yyyymm 
	   AND ( ( @p_plan_gr_id IS NULL OR  @p_plan_gr_id = '' ) OR  b.OPMZ_PLAN_GR_ID like '%'+ @p_plan_gr_id +'%' )
	   AND ( ( @p_plant_id IS NULL OR  @p_plant_id = '' ) OR l.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	   AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR l.LINE_ID IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	   AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
	   AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
	 ORDER BY (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END), OPMZ_PLAN_GR_NAME, a.PLANT_ID, a.LINE_ID, a.OPERATION_ID, a.ITEM_ID, a.TYPE desc, a.DATE		--[PJ20257329] 조회 정렬 변경 (2025-12-17)

  
END

