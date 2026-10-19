


/*
 * Program ID   : SCP0048_GET_PROJECTROUTE_WARRANTY
 * Description  : Project Route Plant Site(WARRANTY) 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2020-03-03   KIMYONGHO	신규추가 [C20200303-000208]Warranty Service 제품의 출하 계획 가시성 확보 및 실행 연계
 */
CREATE PROCEDURE [dbo].[SCP0048_GET_PROJECTROUTE_WARRANTY]
  @p_division_id    NVARCHAR(MAX),
  @p_plant_site     NVARCHAR(MAX),
  @p_operation_group NVARCHAR(MAX),
  @p_item_id		NVARCHAR(200),
  @p_from_yyyymm    NVARCHAR(200)='',
  @p_to_yyyymm		NVARCHAR(200)='',
  @p_valid_flag		NVARCHAR(200)
AS  
  
BEGIN
  SET NOCOUNT ON; 
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;	

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
			--,A.OPERATION_GROUP_NAME
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
			,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.from_yyyymmdd),121) AS from_yyyymmdd 
			,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.to_yyyymmdd)  ,121) AS to_yyyymmdd 
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
			--, B.SEGMENT2 OPERATION_GROUP_NAME
			, '-' ACTION_FLAG_DIV
			, 0 ROW_COLOR_INDEX
			, 1 SORT_ORDER
			, ISNULL((
				SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_TACT_TIME c
											JOIN SCM_MST_LINE_SN LS ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=C.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID
																		AND LS.OPERATION_ID=C.OPERATION_ID AND LS.LINE_ID=C.LINE_ID AND LS.ACTIVE_FLAG='Y'
						 WHERE 1=1
						   AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR c.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
						  -- AND c.DIVISION_ID = @p_division_id
						   AND c.ITEM_ID = t.item_id
						   AND c.VALID_YN='Y' 		
						   AND c.PLANT_SITE_ID = s.scm_site_id
						 GROUP BY c.ITEM_ID , c.PLANT_SITE_ID
			 ),0) TACT_CNT
			 ,ISNULL((
				SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_OUTSOURCING_CAPA  c
						 WHERE 1=1
						   AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR c.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
						    --and c.DIVISION_ID = @p_division_id
						   AND c.ITEM_ID = t.item_id
						   AND c.VALID_YN ='Y'
						   AND c.PLANT_SITE_ID = s.scm_site_id
						 GROUP BY c.PLANT_SITE_ID, c.item_id
			 ),0) OUT_CAPA_CNT
			 , s.SITE_DESCRIPTION
			 --ESS 외주 Pakcer Line 생산 Target 적용
			 ,ISNULL((
				SELECT COUNT(c.PLANT_SITE_ID) FROM SCP_MST_TACT_TIME_OSP  c
						JOIN SCM_MST_LINE_OSP LS ON LS.DIVISION_ID=C.DIVISION_ID AND LS.SCM_SITE_ID=C.PLANT_SITE_ID AND LS.LINE_ID=C.LINE_ID AND LS.VALID_YN='Y'
						 WHERE 1=1
						   AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR c.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
						    --and c.DIVISION_ID = @p_division_id
						   AND c.ITEM_ID = t.item_id
						   AND c.VALID_YN ='Y'
						   AND c.PLANT_SITE_ID = s.scm_site_id
						 GROUP BY c.PLANT_SITE_ID, c.item_id
			 ),0) OUT_TACT_CNT
			 , ISNULL(S.OSP_YN,'N') AS OSP_YN
			 , ISNULL(S.ATTRIBUTE1,'N') AS ATTRIBUTE1
		FROM scm_mst_site_item_priority t (NOLOCK)
		JOIN scm_mst_site s (NOLOCK) ON ( (t.division_id = s.division_id and s.OPERATION_GROUP!='W') OR (s.OPERATION_GROUP='W') )
									and t.PLANT_SITE_ID = s.scm_site_id					
		WHERE s.site_type     = 'PLANT'
			AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR T.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
			AND ( ( @p_plant_site   IS NULL OR  @p_plant_site = ''   ) OR T.PLANT_SITE_ID      IN (SELECT token FROM dbo.String_Split(@p_plant_site  ,',')) )
			AND ( ( @p_item_id		 IS NULL OR  @p_item_id = ''    ) OR t.item_id  LIKE '%' + @p_item_id + '%' )
			AND ( ( @p_valid_flag		 IS NULL OR  @p_valid_flag = ''    ) OR t.valid_yn = @p_valid_flag )
	) A
	WHERE EXISTS (SELECT * 
				FROM scm_mst_site_item_priority Z
				JOIN scm_mst_site X (NOLOCK) 
					ON Z.division_id = X.division_id 
					And Z.PLANT_SITE_ID = X.scm_site_id 
					AND X.OPERATION_GROUP='W'
					ANd Z.ITEM_ID = A.ITEM_ID
					AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR Z.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
					)
	ORDER BY division_id, item_id DESC
	
	;

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
	   ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.from_yyyymmdd),121) AS from_yyyymmdd 
	   ,CONVERT(NVARCHAR(10),dbo.fn_char_to_date(t.to_yyyymmdd)  ,121) AS to_yyyymmdd 
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
	JOIN scm_mst_site s (NOLOCK) ON ( (t.division_id = s.division_id and s.OPERATION_GROUP!='W') OR (s.OPERATION_GROUP='W') )
								and t.PLANT_SITE_ID = s.scm_site_id
   WHERE s.site_type     = 'PLANT'
	 AND ( ( @p_division_id   IS NULL OR  @p_division_id = ''   ) OR t.division_id      IN (SELECT token FROM dbo.String_Split(@p_division_id  ,',')) )
	 and t.valid_yn = 'Y'
	ORDER BY t.division_id, t.item_id, t.from_yyyymmdd  ,t.priority,t.valid_yn desc,t.to_yyyymmdd
	;

	--아이템 조회용
	SELECT  I.ITEM_ID	 
		 , T.NICK_NAME
	  FROM SCM_MST_SITE_ITEM			I WITH(NOLOCK)	     
	  JOIN SCM_MST_DIVISION			D WITH(NOLOCK) ON I.DIVISION_ID  = D.DIVISION_ID
	  JOIN SCM_MST_SITE				S WITH(NOLOCK) ON I.DIVISION_ID  = S.DIVISION_ID AND I.SCM_SITE_ID  = S.SCM_SITE_ID	
	  JOIN SCM_MST_ITEM_SN			T WITH(NOLOCK) ON I.DIVISION_ID  = T.DIVISION_ID AND I.ITEM_ID      = T.ITEM_ID  
	  LEFT OUTER JOIN [SCM_MST_PROJECT] P WITH(NOLOCK) ON I.DIVISION_ID  = P.DIVISION_ID AND I.PROJECT_CODE = P.PROJECT_CODE
	  WHERE 1=1
	  GROUP BY  I.ITEM_ID, T.ITEM_NAME, T.ITEM_TYPE, T.NICK_NAME, T.ITEM_CLASS_NAME	;						  
END
