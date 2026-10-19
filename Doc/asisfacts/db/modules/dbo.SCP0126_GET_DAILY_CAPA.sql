


/*
 * Program ID   : SCP0126_GET_DAILY_CAPA
 * Description  : CAPA - Daily Capa 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/08/05   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/09/10   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 전극쪽에 Div는 Capa컬럼도 표시하고 Operation에 따라 수정가능/불가 처리
 * 2025/12/17   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회 정렬 변경
 *
 */

CREATE PROCEDURE [dbo].[SCP0126_GET_DAILY_CAPA]
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

	;WITH division_info as (
		select d.division_id
			 , r.division_id	as org_division_id 
			 , d.attribute3		as division_dv
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
	), line_master as ( 
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
	), plan_gr_line AS (
		SELECT STRING_AGG(OPMZ_PLAN_GR_NAME, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, ITEM_ID) AS OPMZ_PLAN_GR_NAME
			, STRING_AGG(OPMZ_PLAN_GR_ID, ', ') WITHIN GROUP (ORDER BY PLANT_ID, LINE_ID, ITEM_ID) AS OPMZ_PLAN_GR_ID
			, PLANT_ID, LINE_ID, a.ITEM_ID
		 FROM (
				SELECT distinct  pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
					, PLANT_ID, LINE_ID, ITEM_ID 
				FROM SCP_OPMZ_PLAN_GR_LINE_M x with(nolock)
				LEFT JOIN SCP_OPMZ_PLAN_GR_M pg with(nolock)
					on pg.OPMZ_PLAN_GR_ID = x.OPMZ_PLAN_GR_ID
				WHERE 1 = 1
				AND pg.VALID_YN = 'Y'		--[PJ20257329] 조회 정렬 변경 (2025-12-17)
				GROUP BY PLANT_ID, LINE_ID, ITEM_ID, pg.OPMZ_PLAN_GR_NAME, pg.OPMZ_PLAN_GR_ID
			 ) A
		 WHERE 1 = 1
		 GROUP BY PLANT_ID, LINE_ID, a.ITEM_ID
	)
	SELECT d.DIVISION_ID
		 , b.OPMZ_PLAN_GR_NAME
		 , a.PLANT_ID
		 , a.LINE_ID
		 , l.LINE_NAME
		 , a.OPERATION_ID
		 , c.NICK_NAME
		 , a.ITEM_ID
		 , SUBSTRING(a.MONTH, 1, 4) + '-' + SUBSTRING(a.MONTH, 5, 2)	AS YYYYMM
		 --[PJ20257329]전극쪽에 Div는 Capa컬럼도 표시하고 Operation에 따라 수정가능/불가 처리 (2025-09-10) START
		 , CASE WHEN d.DIVISION_ID = 'EE_UC' AND a.OPERATION_ID = 'E2000' THEN NULL ELSE ca.CAPA END AS CAPA
		 , CASE WHEN d.DIVISION_ID = 'EE_UC' AND a.OPERATION_ID != 'E2000' THEN NULL ELSE ca.M_MIN END AS M_MIN
		 , CASE WHEN d.DIVISION_ID = 'EE_UC' AND a.OPERATION_ID != 'E2000' THEN NULL ELSE ca.LANE END AS LANE
		 , CASE WHEN d.DIVISION_ID = 'EE_UC' AND a.OPERATION_ID != 'E2000' THEN NULL ELSE ca.WIDE_YN END AS WIDE_YN
		 --[PJ20257329]전극쪽에 Div는 Capa컬럼도 표시하고 Operation에 따라 수정가능/불가 처리 (2025-09-10) START
		 , ca.PRDN_OPER_RT
		 , ca.VALID_YN
		 , ca.LAST_UPDATED_BY
		 , ca.LAST_UPDATE_DATE
		 , ISNULL(ca.DIVISION_ID, '') + '|' + ISNULL(ca.PLANT_ID, '') + '|' + ISNULL(ca.LINE_ID, '') + '|' + ISNULL(ca.OPERATION_ID, '') + '|' + ISNULL(ca.ITEM_ID, '') + '|' + ISNULL(ca.YYYYMM, '') AS PRE_KEY_VALUES
	  FROM scm_mst_item_line_assign_sn a WITH(NOLOCK)
	  LEFT JOIN scm_adm_lookup_master_detail ld WITH(NOLOCK)
	    ON ld.LOOKUP_TYPE = 'OPMZ_PLAN_OPERATION' AND ld.valid_yn = 'Y' AND ld.SEGMENT1 = @p_division_id
	 INNER JOIN division_info d 
		on a.DIVISION_ID = d.org_division_id
	   --AND a.OPERATION_ID = case when d.division_dv  = 'EE' then 'E2000' else a.OPERATION_ID end 
	   --AND a.OPERATION_ID != case when d.division_dv = 'EE' then 'Z' else 'E2000' end 
	   AND a.OPERATION_ID = ld.SEGMENT2	--사업부별 표시할 Operation 지정
	  LEFT JOIN plan_gr_line b WITH(NOLOCK)
		ON b.PLANT_ID = a.PLANT_ID AND b.LINE_ID = a.LINE_ID AND a.ITEM_ID = CASE WHEN b.ITEM_ID = '-' THEN a.ITEM_ID ELSE b.ITEM_ID END
	  LEFT JOIN (
			SELECT DIVISION_ID, ITEM_ID, MAX(NICK_NAME) AS NICK_NAME
			FROM SCM_MST_ITEM_SN WITH(NOLOCK)
			GROUP BY  DIVISION_ID, ITEM_ID
		 ) c
		ON c.DIVISION_ID = a.DIVISION_ID AND c.ITEM_ID = a.ITEM_ID
	  LEFT JOIN line_master l WITH(NOLOCK)
		ON l.DIVISION_ID = a.DIVISION_ID AND l.PLANT_ID = a.PLANT_ID AND l.LINE_ID = a.LINE_ID AND l.OPERATION_ID = a.OPERATION_ID
	  LEFT JOIN SCP_OPMZ_DDLY_CAPA ca WITH(NOLOCK)
		ON ca.DIVISION_ID = d.DIVISION_ID AND ca.PLANT_ID = a.PLANT_ID AND ca.LINE_ID = a.LINE_ID AND ca.OPERATION_ID = a.OPERATION_ID AND ca.ITEM_ID = a.ITEM_ID AND ca.YYYYMM = a.MONTH
	 WHERE 1=1
	   AND a.PRIORITY <> 9
	   AND a.ACTIVE_FLAG = 'Y'
	   AND d.DIVISION_ID = @p_division_id
	   AND a.MONTH BETWEEN @p_from_yyyymm AND @p_to_yyyymm
	   AND ( ( @p_plan_gr_id IS NULL OR  @p_plan_gr_id = '' ) OR b.OPMZ_PLAN_GR_ID like '%'+ @p_plan_gr_id +'%' )
	   AND ( ( @p_plant_id IS NULL OR  @p_plant_id = '' ) OR a.PLANT_ID IN (SELECT token FROM dbo.String_Split(@p_plant_id  ,',')) )
	   AND ( ( @p_line_id IS NULL OR  @p_line_id = '' ) OR a.LINE_ID IN (SELECT token FROM dbo.String_Split(@p_line_id  ,',')) )
	   AND ( ( @p_item_id IS NULL OR  @p_item_id = '' ) OR a.ITEM_ID LIKE '%' + @p_item_id + '%' ) 
	   AND ( ( @p_nick_name IS NULL OR  @p_nick_name = '' ) OR c.NICK_NAME LIKE '%' + @p_nick_name + '%' ) 
	 ORDER BY (CASE WHEN ISNULL(OPMZ_PLAN_GR_NAME,'') = '' THEN 1 ELSE 0 END), OPMZ_PLAN_GR_NAME, a.PLANT_ID, a.LINE_ID, a.OPERATION_ID, a.ITEM_ID, a.MONTH		--[PJ20257329] 조회 정렬 변경 (2025-12-17)

  
END

