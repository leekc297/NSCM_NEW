

/*
 * Program ID   : SCM0017_GET_VALIDATION_BOM
 * Description  : BOD Validation
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/06/06   byunghunjung	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/06/11   byunghunjung	mkr fcst date, validation type 컬럼 추가
 * 2018/07/16   byunghunjung	40 사업부 추가
 * 2018/11/05	hwyoon			조회 시 마케팅 수요가 있는 아이템만 조회(BOM NOT ASSIGN)
 * 2018/11/09	hwyoon			vmi에 따른 measure 분기 + 현 FCST 기준으로 assign 조회
 * 2018/11/22	hwyoon			BOM NOT ASSIGN - SALES SITE 별 출력
 * 2019/04/25	hwyoon			[CSR ID:3984484] Validation BOM 검출 로직 변경의 건 - BOM 하위 아이템 포함하여 조회 - SCM_MST_BOM_EFFECTIVE_SN 사용
 * 2019/04/29	hwyoon			[CSR ID:3984484] Validation BOM 검출 로직 변경의 건 - BOM NOT ASSIGN과 BOM NOT EXISTS 분리
 * 2019/11/26	hwyoon			전극관련수정 - BOM NOT ASSIGN에 전극모델도 포함
 * 2021/10/05	khj79			[PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
 * 2022/11/07   jahn1501		PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
 * 
 */

CREATE PROCEDURE [dbo].[SCM0017_GET_VALIDATION_BOM]
  
  @p_division_id     NVARCHAR(MAX),
  @p_project_code    NVARCHAR(MAX),
  @p_item_id		 NVARCHAR(MAX)
  
AS

BEGIN

	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
	SET NOCOUNT ON; 

	/********************************************************************************
	* 임시테이블만들기 
	********************************************************************************/	
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCM0017_FCST') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCM0017_FCST

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCM0017_ASSIGN') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCM0017_ASSIGN


	SELECT a.division_id ,project_code ,a.scm_site_id ,item_id ,dom_exp ,fcst_type ,incoterms ,measure ,plant_site_id ,yyyymmdd ,qty 
	INTO #TblDynamicPivot_SCM0017_FCST
    FROM DM_PLN_MKT_FCST a WITH(NOLOCK)
	--2021/10/05 : W/S AS
    --LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID AND s.SCM_SITE_ID=a.SCM_SITE_ID AND s.VMI_YN='Y'
	LEFT JOIN scm_mst_site s ON s.DIVISION_ID=a.DIVISION_ID 
							AND s.SCM_SITE_ID=a.SCM_SITE_ID 
							AND (s.VMI_YN='Y' OR ( SITE_TYPE = 'SALES' AND operation_group = 'W'))
    WHERE 1=1
	--2021/10/05 : W/S AS
    --AND a.MEASURE = IIF( ISNULL(s.vmi_yn, 'N') = 'Y', 'VMI_In_Req',  'MKT_FCST')
    --2022/11/07 변경
	--AND A.MEASURE = IIF(ISNULL(S.OPERATION_GROUP, '') = 'W', 'AS_In_Req', IIF(S.vmi_yn = 'Y', 'VMI_In_Req',  'MKT_FCST'))
    AND A.MEASURE = CASE WHEN ISNULL(S.OPERATION_GROUP, '') = 'W' THEN 'AS_In_Req' WHEN S.vmi_yn = 'Y' THEN 'VMI_In_Req' WHEN ISNULL(a.attribute10, '') = '' THEN 'MKT_FCST' END
    AND a.yyyymmdd != '' and a.yyyymmdd is not null
    AND a.yyyymmdd >= CONVERT(VARCHAR,GETDATE(),112)
    AND a.qty      >  0	
	;

	
	SELECT t.*
	INTO #TblDynamicPivot_SCM0017_ASSIGN
	FROM (-- FCST 있는 모델
		  SELECT A.* 
		  FROM #TblDynamicPivot_SCM0017_FCST A
          UNION ALL
          -- FCST 있는 모델의 하위 Cell
          SELECt DISTINCT b.division_id, b.project_code, b.scm_site_id, a.parent_item_id, b.dom_exp 
                        , b.fcst_type, b.incoterms, b.measure, b.plant_site_id, b.yyyymmdd, b.qty 
		  -- 2021.03.30 대체 BOM 모델링
		  --FROM   SCM_MST_BOM_EFFECTIVE_SN a WITH(NOLOCK)
          FROM   SCM_MST_BOM_EFFECTIVE_SN_V a WITH(NOLOCK)
               ,(
					SELECT A.* 
					FROM #TblDynamicPivot_SCM0017_FCST A
                ) b
               , scm_mst_final_item_v c WITH(NOLOCK)
          WHERE  a.division_id    = b.division_id
          AND    a.model_id       = b.item_id
          AND    a.division_id    = c.division_id
          AND    a.parent_item_id = c.item_id
          AND    c.OPERATION_GROUP_ID IN ('A', 'E') --전극관련수정 - BOM NOT ASSIGN에 전극모델도 포함
       ) t 
	;

	/********************************************************************************
	* 데이타조회
	********************************************************************************/

	SELECT 
		  x.division_id
		 ,x.item_id
		 ,dbo.FN_GET_ITEM_NICKNAME( x.division_id, x.item_id ) AS nick_name	
		 ,x.plant_id
		 ,x.sales_site_id
		 ,x.project_code
		 ,CONVERT(DATETIME, x.yyyymmdd,112) AS mkt_fcst_date
		 ,x.validation_type
	FROM (
	   
	    --  BOM NOT ASSIGN : Project Route 에 등록되어있으나 SCM_MST_BOM_ENG_SN 테이블에 없는 모델
		SELECT   a.division_id 
		       , a.item_id 
			   , a.plant_id 
			   , a.sales_site_id 
			   , a.project_code
			   , a.yyyymmdd
			   , 'BOM NOT ASSIGN' AS validation_type
			FROM (  -- 81 : Pack / Cell
					SELECT b.division_id
						  ,b.item_id
						  ,dbo.FN_SCM_SPLIT(b.plant_site_id,1,'-') AS plant_id
						  --,MAX(b.sales_site_id) AS sales_site_id
						  ,b.sales_site_id
						  ,MAX(b.project_code) AS project_code
						  ,MIN(c.yyyymmdd) AS yyyymmdd
					  FROM scm_mst_site_item_priority  b WITH(NOLOCK)
					  INNER JOIN scm_mst_site s WITH(NOLOCK) ON b.division_id      = s.division_id 
															AND b.plant_site_id    = s.scm_site_id 
															AND s.valid_yn         = 'Y'
															AND s.operation_group IN ('P',  'A')
					  INNER JOIN #TblDynamicPivot_SCM0017_ASSIGN c ON b.division_id = c.division_id 
																AND b.sales_site_id = c.scm_site_id 
																AND b.project_code = c.project_code 
																AND b.item_id = c.item_id 
					 WHERE 1=1
					   AND b.division_id = '81'
					   AND b.to_yyyymmdd >= CONVERT(VARCHAR,GETDATE(),112)
					   AND LEN(DBO.FN_SCM_SPLIT(b.plant_site_id,1,'-') ) = 4
					   AND b.valid_yn = 'Y'
					 GROUP BY b.division_id, b.item_id, DBO.FN_SCM_SPLIT(b.plant_site_id,1,'-'),b.sales_site_id

					-- 전극관련수정 - BOM NOT ASSIGN에 전극모델도 포함
					-- 81 : 전극
					 union all
					SELECT b.division_id
						  ,b.item_id
						  ,dbo.FN_SCM_SPLIT(b.plant_site_id,1,'-') AS plant_id
						  ,'-' as sales_site_id
						  ,MAX(b.project_code) AS project_code
						  ,MIN(c.yyyymmdd) AS yyyymmdd
					  FROM scm_mst_site_item_priority  b WITH(NOLOCK)
					  INNER JOIN scm_mst_site s WITH(NOLOCK) ON b.division_id      = s.division_id 
															AND b.plant_site_id    = s.scm_site_id 
															AND s.valid_yn         = 'Y'
															AND s.operation_group IN ('E')
					  INNER JOIN #TblDynamicPivot_SCM0017_ASSIGN c ON b.division_id = c.division_id 
																AND b.item_id = c.item_id 
					 WHERE 1=1
					   AND b.division_id = '81'
					   AND b.to_yyyymmdd >= CONVERT(VARCHAR,GETDATE(),112)
					   AND LEN(DBO.FN_SCM_SPLIT(b.plant_site_id,1,'-') ) = 4
					   AND b.valid_yn = 'Y'
					 GROUP BY b.division_id, b.item_id, DBO.FN_SCM_SPLIT(b.plant_site_id,1,'-')

					 -- 40/82 : Pack/ Cell/ 전극
					 union all
					 SELECT b.division_id
						  ,b.item_id
						  ,dbo.FN_SCM_SPLIT(b.plant_site_id,1,'-') AS plant_id
						  ,'-' as sales_site_id
						  ,MAX(b.project_code) AS project_code
						  ,MIN(c.yyyymmdd) AS yyyymmdd
					  FROM scm_mst_site_item_priority  b WITH(NOLOCK)
					  INNER JOIN #TblDynamicPivot_SCM0017_ASSIGN c ON b.division_id = c.division_id 
																AND b.item_id = c.item_id 
					 WHERE 1=1
					   AND b.division_id in ('40','82')
					   AND b.to_yyyymmdd >= CONVERT(VARCHAR,GETDATE(),112)
					   AND LEN(DBO.FN_SCM_SPLIT(b.plant_site_id,1,'-') ) = 4
					   AND b.valid_yn = 'Y'
					 GROUP BY b.division_id, b.item_id, DBO.FN_SCM_SPLIT(b.plant_site_id,1,'-')
					) A
					JOIN scp_mst_final_item B (NOLOCK) ON a.division_id = B.division_id and a.item_id = B.item_id and B.fcst_yn = upper('Y')
			WHERE 1=1 
			AND NOT EXISTS 
			 (   SELECT 'X'
				   FROM SCM_MST_BOM_ENG_SN c WITH(NOLOCK)
				  WHERE c.division_id = a.division_id
					AND c.plant_id    = a.plant_id
					AND c.parent_item_id = a.item_id
					AND c.eff_start_date <= GETDATE()
					AND c.eff_end_date > GETDATE()
			  )
			AND ( ( @p_division_id   IS NULL OR  @p_division_id  ='' ) OR a.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
			AND ( ( @p_project_code  IS NULL OR  @p_project_code ='' ) OR a.project_code IN (SELECT token FROM dbo.String_Split(@p_project_code,',')) )
			AND ( ( @p_item_id       IS NULL OR  @p_item_id      ='' ) OR a.item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	
			UNION 

			-- BOM Not Exists : Project Route 화면에서 표시된 81사업부 모델
			SELECT  DISTINCT t.division_id 
					, t.item_id 
					, '-' AS plant_id 
					, t.scm_site_id AS sales_site_id 
					, t.project_code
					, t.yyyymmdd
					, 'BOM NOT EXISTS' AS validation_type		
				FROM ( SELECT a.division_id ,a.project_code ,a.scm_site_id ,a.item_id ,MIN(yyyymmdd) AS yyyymmdd
						 FROM #TblDynamicPivot_SCM0017_FCST a 
						 JOIN scm_mst_item_sn b ON a.division_id = b.division_id and a.item_id= b.item_id
						WHERE 1=1 
						  AND a.division_id ='81'
						  AND b.scp_operation_group_id <> 'E'
						  GROUP BY a.division_id ,a.project_code ,a.scm_site_id ,a.item_id
					 ) t  
				LEFT OUTER JOIN  (SELECT division_id ,model_id	,scm_site_id ,project_code,tot_cnt
								  FROM (
										SELECT division_id ,model_id ,scm_site_id ,project_code ,COUNT(*) OVER(PARTITION BY division_id,SCM_SITE_ID,project_code,model_id) AS tot_cnt
										FROM (
												SELECT b.division_id ,b.model_id ,a.scm_site_id ,a.project_code												 
												FROM #TblDynamicPivot_SCM0017_FCST a 
												-- 2021.03.30 대체 BOM 모델링
												--JOIN scm_mst_bom_sn b    ON a.division_id = b.division_id and a.item_id = b.model_id 	
												JOIN SCM_MST_BOM_SN_V b    ON a.division_id = b.division_id and a.item_id = b.model_id 	
												JOIN scm_mst_item_sn c   ON b.company_id = c.company_id and b.division_id = c.division_id and b.site_id = c.site_id and b.child_item_id = c.item_id
												JOIN scm_mst_final_item_v d  ON b.division_id = d.division_id  and b.child_item_id = d.item_id
												WHERE 1=1
												AND c.item_type	   <> 'r'
												AND	b.alt_priority  = 'Y'
												AND a.division_id   = '81'
												AND d.operation_group_id <> 'E'
												AND EXISTS (SELECT 'X'
															FROM SCM_MST_BOM_ENG_SN WITH(NOLOCK)
															WHERE division_id = '81'
															AND parent_item_id= b.child_item_id )
												) m
										) n
								 GROUP BY division_id, scm_site_id, project_code, model_id, tot_cnt
							) u  ON t.division_id  = u.division_id
								AND t.scm_site_id  = u.scm_site_id
								AND t.project_code = u.project_code
								AND t.item_id      = u.model_id
				JOIN  (SELECT division_id ,item_id ,nick_name ,item_type 
						     ,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) nums
					   FROM SCM_MST_ITEM_SN ) i  ON t.division_id  = i.division_id AND t.item_id = i.item_id AND i.nums =1
				JOIN  SCM_MST_SITE e ON t.division_id = e.division_id	AND t.scm_site_id = e.scm_site_id
				WHERE 1=1
				  AND i.item_type NOT IN ('Q','R')	
				  AND t.division_id  = '81'
				  AND u.tot_cnt is null
				  AND e.SITE_TYPE    = 'SALES'
				  AND e.VALID_YN     = 'Y'

			UNION 

			-- BOM Not Exists : Project Route 화면에서 표시된 40,82사업부 모델
			SELECT  DISTINCT t.division_id 
					, t.item_id 
					, '-' AS plant_id 
					, '-' AS sales_site_id 
					, '-' AS project_code
					, t.yyyymmdd
					, 'BOM NOT EXISTS' AS validation_type
				FROM ( SELECT a.division_id ,a.item_id ,MIN(yyyymmdd) AS yyyymmdd
						 FROM #TblDynamicPivot_SCM0017_FCST a 
						 JOIN scm_mst_item_sn b ON a.division_id = b.division_id and a.item_id= b.item_id
						WHERE 1=1 
						  AND a.division_id in ('40','82')
						  AND b.scp_operation_group_id <> 'E'
						  GROUP BY a.division_id  ,a.item_id
					 ) t  
				LEFT OUTER JOIN  (SELECT division_id ,model_id	,'-' AS scm_site_id ,'-' AS project_code ,tot_cnt
								  FROM (
										SELECT division_id ,model_id ,COUNT(*) OVER(PARTITION BY division_id,model_id) AS tot_cnt
										FROM (
												SELECT b.division_id ,b.model_id
												FROM #TblDynamicPivot_SCM0017_FCST a 
												-- 2021.03.30 대체 BOM 모델링
												--JOIN scm_mst_bom_sn b    ON a.division_id = b.division_id and a.item_id = b.model_id 	
												JOIN SCM_MST_BOM_SN_V b    ON a.division_id = b.division_id and a.item_id = b.model_id 	
												JOIN scm_mst_item_sn c   ON b.company_id = c.company_id and b.division_id = c.division_id and b.site_id = c.site_id and b.child_item_id = c.item_id
												JOIN scm_mst_final_item_v d  ON b.division_id = d.division_id  and b.child_item_id = d.item_id
												WHERE 1=1
												AND c.item_type	   <> 'r'
												AND	b.alt_priority  = 'Y'
												AND a.division_id  in ('40','82')
												AND d.operation_group_id <> 'E'
												AND EXISTS (SELECT 'X'
															FROM SCM_MST_BOM_ENG_SN WITH(NOLOCK)
															WHERE division_id in ('40','82')
																AND parent_item_id= b.child_item_id )
												) m
										) n
								  GROUP BY division_id, model_id, tot_cnt
				                ) u  ON t.division_id = u.division_id	AND t.item_id = u.model_id
				JOIN  (SELECT division_id ,item_id ,nick_name ,item_type 
							  ,ROW_NUMBER() OVER ( PARTITION BY division_id, item_id ORDER BY  CASE item_type WHEN 'P' THEN 999 WHEN 'H' THEN 888 WHEN 'R' THEN 777  WHEN 'Q' THEN 666 ELSE 0 END  DESC ) nums
					  FROM SCM_MST_ITEM_SN ) i  ON t.division_id  = i.division_id AND t.item_id = i.item_id AND i.nums =1
				WHERE 1=1
				  AND i.item_type NOT IN ('Q','R')	
				  AND t.division_id  in ('40','82')
				  AND u.tot_cnt is null
	) X
	WHERE 1=1 
	AND ( ( @p_division_id   IS NULL OR  @p_division_id  ='' ) OR x.division_id  IN (SELECT token FROM dbo.String_Split(@p_division_id,',')) )
	AND ( ( @p_project_code  IS NULL OR  @p_project_code ='' ) OR x.project_code IN (SELECT token FROM dbo.String_Split(@p_project_code,',')) )
	AND ( ( @p_item_id       IS NULL OR  @p_item_id      ='' ) OR x.item_id      IN (SELECT token FROM dbo.String_Split(@p_item_id,',')) )
	ORDER BY division_id, plant_id, item_id, sales_site_id, project_code

	--임시테이블 삭제
	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCM0017_FCST') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCM0017_FCST

	IF OBJECT_ID('tempdb..#TblDynamicPivot_SCM0017_ASSIGN') IS NOT NULL	
		   DROP TABLE #TblDynamicPivot_SCM0017_ASSIGN

END


