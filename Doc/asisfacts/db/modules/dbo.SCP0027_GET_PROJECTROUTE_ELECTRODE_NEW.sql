
/*
 * Program ID   : SCP0027_GET_PROJECTROUTE_ELECTRODE
 * Description  : Project Route Plant Site(Electrode) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2018/06/26   yhw				Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/08/08   byunghunjung	82 사업부 전극 모델 리스트에서 제외
 * 2018/08/09	yhw				아이템 별 tact time, outsourcing capa PLANT SITE 등록여부 조회 추가
 * 2018/08/28   ygkim			@p_division_id 멀티로 변경
 * 2018/09/19   hwyoon			validation용 조회항목 추가(plant_site_id_b)
 * 2018/09/21	hwyoon			item 조회조건 입력 시 신규입력건 조회 제거
 * 2018/12/21	hwyoon			T/T 등록여부 체크 시 해당 라인 활성화 여부 포함하여 체크
 * 2019/12/17	hwyoon			Tact Time 등록여부 조회컬럼 추가
 * 2020/02/10	hwyoon			ESS 외주 Pakcer Line 생산 Target 적용
 */
CREATE PROCEDURE [dbo].[SCP0027_GET_PROJECTROUTE_ELECTRODE_NEW]
 @p_division_id     NVARCHAR(MAX),
 @p_plant_site      NVARCHAR(MAX),
 @p_operation_group NVARCHAR(MAX),
 @p_item_id			NVARCHAR(200),
 @p_from_yyyymm     NVARCHAR(200)='',
 @p_to_yyyymm		NVARCHAR(200)='',
 @p_valid_flag		NVARCHAR(200)
AS  

BEGIN

  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

  --  Cell계획기준 전극미등록 모델 리스트 추가
	SELECT DISTINCT 
		  '' AS priority_seq
		  ,B.DIVISION_ID
		  ,'-' AS  project_code
		  ,B.CHILD_ITEM_ID as ITEM_ID
		  ,'-' AS scm_site_id
		  ,'' AS PLANT_SITE_ID_B
		  ,'' AS PLANT_SITE_ID 
		  ,'' AS TACT_TIME_FLAG
		  ,'' AS priority
		  ,'Y' AS valid_yn
		  ,'Y' AS org_valid_yn
		  ,'' AS from_yyyymmdd 
		  ,'' AS to_yyyymmdd 
		  ,'' AS created_by
		  ,NULL AS creation_date
		  ,'' AS last_updated_by
		  ,NULL AS last_update_date
		  ,B.OPERATION_GROUP_ID as OPERATION_GROUP
		  ,'' AS org_from_yyyymmdd
		  ,'' AS org_to_yyyymmdd
		  ,'' AS merge_date
		  ,'' as is_pass_n1
		  ,'' as is_pass_n2
		  ,'' as is_pass_n3
		  ,'' as is_pass_n4
		  ,'' as is_pass_n5
		  ,'' as is_pass_n6
		  ,'' as is_pass_n7
		  ,dbo.FN_GET_ITEM_NICKNAME (B.DIVISION_ID, B.CHILD_ITEM_ID) AS nick_name
		  ,D.SEGMENT2 OPERATION_GROUP_NAME
		  ,'-' ACTION_FLAG_DIV
		  ,0 ROW_COLOR_INDEX
		  ,0 SORT_ORDER
	FROM 
	(SELECT DISTINCT DIVISION_ID,ITEM_ID
	  FROM SCP_ANL_PRODUCTION_PLAN WITH(NOLOCK)
	WHERE DIVISION_ID IN (SELECT DIVISION_ID from scm_mst_division WITH(NOLOCK) WHERE attribute3 <> 'EE' AND division_id <> '82') --IN ('81','40') -- 82사업부 제외
	--WHERE DIVISION_ID IN ('81','40') -- 82사업부 제외
	   AND PLAN_START_YYYYMMDD >=[dbo].[FN_GET_BUCKET_YYYYMMDD](-1)
	   AND OPERATION_GROUP='A'
	   AND MEASURE ='PROD_PLAN_AMEND'
	) A, SCM_MST_MODEL_FINAL_ITEM_BOM_V B WITH(NOLOCK)
		JOIN SCM_ADM_LOOKUP_MASTER C ON C.LOOKUP_TYPE='OPERATION_GROUP' AND C.VALID_YN='Y'
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
		  ON D.LOOKUP_TYPE=C.LOOKUP_TYPE 
		 AND D.VALID_YN='Y' 
		 AND D.SEGMENT1='E' -- B.OPERATION_GROUP_ID
	WHERE 1=1
	  AND A.DIVISION_ID = B.DIVISION_ID
	  AND A.ITEM_ID = B.MODEL_ID
	  AND B.OPERATION_GROUP_ID ='E'
	  AND ( ( @p_operation_group   IS NULL OR  @p_operation_group = ''   ) OR B.OPERATION_GROUP_ID  IN (SELECT token FROM dbo.String_Split(@p_operation_group  ,',')) )
	  AND NOT EXISTS ( SELECT '*'
						 FROM SCM_MST_SITE_ITEM_PRIORITY T WITH(NOLOCK)
						WHERE T.DIVISION_ID = B.DIVISION_ID
						  AND T.ITEM_ID     = B.CHILD_ITEM_ID
						  AND T.VALID_YN ='Y' )
	  AND ( ( @p_item_id		 IS NULL OR  @p_item_id = ''    ) OR B.CHILD_ITEM_ID  LIKE '%' + @p_item_id + '%' )

	UNION ALL

	SELECT A.priority_seq
			,A.division_id
			,A.project_code
			,A.item_id
			,A.scm_site_id
			,A.PLANT_SITE_ID AS PLANT_SITE_ID_B
			--ESS 외주 Pakcer Line 생산 Target 적용
			,A.DIVISION_ID + '   ' + A.PLANT_SITE_ID + '   ' + A.SITE_DESCRIPTION + (CASE WHEN (TACT_CNT>0 AND OSP_YN='N') OR (OUT_CAPA_CNT>0 AND ATTRIBUTE1 IN ('','N')) OR (OUT_TACT_CNT>0 AND ATTRIBUTE1='Y') THEN ' Y' ELSE ' N' END) AS PLANT_SITE_ID
			--ESS 외주 Pakcer Line 생산 Target 적용
			--,(CASE WHEN TACT_CNT>0 OR OUT_CAPA_CNT>0 THEN ' Y' ELSE ' N' END) AS TACT_TIME_FLAG
			,(CASE WHEN (TACT_CNT>0 AND OSP_YN='N') OR (OUT_CAPA_CNT>0 AND ATTRIBUTE1 IN ('','N')) OR (OUT_TACT_CNT>0 AND ATTRIBUTE1='Y') THEN ' Y' ELSE ' N' END) AS TACT_TIME_FLAG
			,A.priority
			,A.valid_yn
			,A.org_valid_yn
			,A.from_yyyymmdd 
			,A.to_yyyymmdd 
			,A.created_by
			,A.creation_date
			,A.last_updated_by
			,A.last_update_date
			,A.OPERATION_GROUP
			,A.org_from_yyyymmdd
			,A.org_to_yyyymmdd
			,A.merge_date
			,A.is_pass_n1
			,A.is_pass_n2
			,A.is_pass_n3
			,A.is_pass_n4
			,A.is_pass_n5
			,A.is_pass_n6
			,A.is_pass_n7
			,A.nick_name
			,A.OPERATION_GROUP_NAME
			,A.ACTION_FLAG_DIV
			,A.ROW_COLOR_INDEX
			,A.SORT_ORDER
			--,A.DIVISION_ID + '   ' + A.PLANT_SITE_ID + '   ' + A.SITE_DESCRIPTION + (CASE WHEN TACT_CNT>0 OR OUT_CAPA_CNT>0 THEN ' Y' ELSE ' N' END) AS PLANT_SITE_NAME
	FROM (
		SELECT 
			CONVERT(NVARCHAR(MAX), t.priority_seq) AS priority_seq
			,t.division_id
			,ISNULL(NULLIF(t.project_code,''),'-') project_code
			,t.item_id
			,ISNULL(NULLIF(t.SALES_SITE_ID,''),'-') AS scm_site_id
			,T.PLANT_SITE_ID 
			,t.priority
			,t.valid_yn
			,t.valid_yn as org_valid_yn
			,CONVERT(NVARCHAR(10),CONVERT(DATETIME,t.from_yyyymmdd,112),121) AS from_yyyymmdd 
			,CONVERT(NVARCHAR(10),CONVERT(DATETIME,t.to_yyyymmdd,112)  ,121) AS to_yyyymmdd 
			--,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.from_yyyymmdd),121) AS from_yyyymmdd 
			--,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.to_yyyymmdd)  ,121) AS to_yyyymmdd 
			,t.created_by
			,t.creation_date
			,t.last_updated_by
			,t.last_update_date
			,s.OPERATION_GROUP
			,t.from_yyyymmdd AS org_from_yyyymmdd
			,t.to_yyyymmdd AS org_to_yyyymmdd
			,t.from_yyyymmdd + t.to_yyyymmdd AS merge_date
			,'' as is_pass_n1
			,'' as is_pass_n2
			,'' as is_pass_n3
			,'' as is_pass_n4
			,'' as is_pass_n5
			,'' as is_pass_n6
			,'' as is_pass_n7
			, dbo.FN_GET_ITEM_NICKNAME (t.division_id, t.item_id ) AS nick_name
			, B.SEGMENT2 OPERATION_GROUP_NAME
			, '-' ACTION_FLAG_DIV
			, 0 ROW_COLOR_INDEX
			, 1 SORT_ORDER
			, ISNULL((
				SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_TACT_TIME c WITH(NOLOCK)
						JOIN SCM_MST_LINE_SN LS WITH(NOLOCK) ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=C.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
													AND LS.OPERATION_ID=C.OPERATION_ID AND LS.LINE_ID=C.LINE_ID AND LS.ACTIVE_FLAG='Y'
				WHERE 1=1
				AND ( ( @p_division_id IS NULL OR  @p_division_id = '') OR c.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
				-- AND c.DIVISION_ID = @p_division_id
				AND c.ITEM_ID = t.item_id
				AND c.VALID_YN='Y' 		
				AND c.PLANT_SITE_ID = s.scm_site_id
				GROUP BY c.ITEM_ID, c.PLANT_SITE_ID
			 ),0) TACT_CNT
			 ,ISNULL((
				SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_OUTSOURCING_CAPA c WITH(NOLOCK)
				WHERE 1=1
				AND ( ( @p_division_id IS NULL OR  @p_division_id = '') OR c.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
				--and c.DIVISION_ID = @p_division_id
				AND c.ITEM_ID = t.item_id
				AND c.VALID_YN ='Y'
				AND c.PLANT_SITE_ID = s.scm_site_id
				GROUP BY c.PLANT_SITE_ID, c.item_id
			 ),0) OUT_CAPA_CNT
			 , s.SITE_DESCRIPTION
			 --ESS 외주 Pakcer Line 생산 Target 적용
			 ,ISNULL((
				SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_TACT_TIME_OSP c WITH(NOLOCK)
						JOIN SCM_MST_LINE_OSP LS WITH(NOLOCK) ON LS.DIVISION_ID=C.DIVISION_ID AND LS.SCM_SITE_ID=C.PLANT_SITE_ID AND LS.LINE_ID=C.LINE_ID AND LS.VALID_YN='Y'
						 WHERE 1=1
						   AND ( ( @p_division_id IS NULL OR  @p_division_id = '') OR c.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
						    --and c.DIVISION_ID = @p_division_id
						   AND c.ITEM_ID = t.item_id
						   AND c.VALID_YN ='Y'
						   AND c.PLANT_SITE_ID = s.scm_site_id
						 GROUP BY c.PLANT_SITE_ID, c.item_id
			 ),0) OUT_TACT_CNT
			 , ISNULL(S.OSP_YN,'N') AS OSP_YN
			 , ISNULL(S.ATTRIBUTE1,'N') AS ATTRIBUTE1
		FROM scm_mst_site_item_priority t (NOLOCK)
		--JOIN scm_mst_site s (NOLOCK) ON t.division_id = s.division_id and t.PLANT_SITE_ID = s.scm_site_id
		JOIN scm_mst_site s (NOLOCK) ON ( (t.division_id = s.division_id and s.OPERATION_GROUP!='E') OR (s.OPERATION_GROUP='E') )
									and t.PLANT_SITE_ID = s.scm_site_id
		JOIN SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK) ON A.LOOKUP_TYPE='OPERATION_GROUP' AND A.VALID_YN='Y'
		JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) 
			ON B.LOOKUP_TYPE=A.LOOKUP_TYPE 
			AND B.VALID_YN='Y' 
			AND B.SEGMENT1=s.OPERATION_GROUP-- 198
		WHERE s.site_type     = 'PLANT'
			AND ( ( @p_division_id IS NULL OR  @p_division_id = '') OR T.division_id IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
			AND ( ( @p_plant_site IS NULL OR  @p_plant_site = '') OR T.PLANT_SITE_ID IN (SELECT token FROM dbo.String_Split(@p_plant_site  ,',')) )
			AND ( ( @p_item_id IS NULL OR  @p_item_id = '') OR t.item_id  LIKE '%' + @p_item_id + '%' )
			AND ( ( @p_operation_group IS NULL OR  @p_operation_group = ''   ) OR s.OPERATION_GROUP  IN (SELECT token FROM dbo.String_Split(@p_operation_group  ,',')) )
			AND ( ( @p_valid_flag IS NULL OR  @p_valid_flag = ''    ) OR t.valid_yn = @p_valid_flag )
			--ORDER BY SORT_ORDER, division_id, item_id, from_yyyymmdd ,priority, valid_yn desc, to_yyyymmdd
	) A
		ORDER BY SORT_ORDER, division_id, item_id, from_yyyymmdd ,priority, valid_yn desc, to_yyyymmdd

	--전체조회
	SELECT 
		CONVERT(NVARCHAR(MAX), t.priority_seq) AS priority_seq
	   ,t.division_id
       ,ISNULL(t.project_code,'-') project_code
	   ,t.item_id
	   ,ISNULL(t.SALES_SITE_ID,'-') AS scm_site_id
	   ,T.PLANT_SITE_ID 
	   ,t.priority
	   ,t.valid_yn
	   ,t.valid_yn as org_valid_yn
	   ,CONVERT(NVARCHAR(10),CONVERT(DATETIME,t.from_yyyymmdd,112),121) AS from_yyyymmdd 
	   ,CONVERT(NVARCHAR(10),CONVERT(DATETIME,t.to_yyyymmdd,112)  ,121) AS to_yyyymmdd 
	   --,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.from_yyyymmdd),121) AS from_yyyymmdd 
	   --,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.to_yyyymmdd)  ,121) AS to_yyyymmdd 
	   ,t.created_by
	   ,t.creation_date
	   ,t.last_updated_by
	   ,t.last_update_date
	   ,s.OPERATION_GROUP
	   ,t.from_yyyymmdd AS org_from_yyyymmdd
	   ,t.to_yyyymmdd AS org_to_yyyymmdd
	   ,t.from_yyyymmdd + t.to_yyyymmdd AS merge_date
	   ,'' as is_pass_n1
	   ,'' as is_pass_n2
	   ,'' as is_pass_n3
	   ,'' as is_pass_n4
	   ,'' as is_pass_n5
	   ,'' as is_pass_n6
	   ,'' as is_pass_n7
	   , '-' ACTION_FLAG_DIV
	   , 0 ROW_COLOR_INDEX
	FROM scm_mst_site_item_priority t (NOLOCK)
	--JOIN scm_mst_site s (NOLOCK) ON t.division_id = s.division_id and t.PLANT_SITE_ID = s.scm_site_id
	JOIN scm_mst_site s (NOLOCK) ON ( (t.division_id = s.division_id and s.OPERATION_GROUP!='E') OR (s.OPERATION_GROUP='E') )
								and t.PLANT_SITE_ID = s.scm_site_id
   WHERE s.site_type     = 'PLANT'
	 --AND t.division_id   = @p_division_id   -- '40'
	 AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR t.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	 and t.valid_yn = 'Y'
	ORDER BY t.division_id, t.item_id, t.from_yyyymmdd  ,t.priority,t.valid_yn desc,t.to_yyyymmdd

	--아이템 조회용
	SELECT A.ITEM_ID, A.NICK_NAME
	FROM (
	select A.ITEM_ID, A.NICK_NAME, ROW_NUMBER() OVER ( PARTITION BY ITEM_ID, NICK_NAME ORDER BY NICK_NAME ASC ) NUMS
		from SCP_MST_FINAL_ITEM a WITH(NOLOCK)
		WHERE A.OPERATION_GROUP = 'E'
		GROUP BY A.ITEM_ID,A.NICK_NAME
	) A WHERE A.NUMS=1
	;
								  
END

