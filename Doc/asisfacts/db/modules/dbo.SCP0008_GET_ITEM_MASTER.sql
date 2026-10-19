

/*
 * Program ID   : SCP0008_GET_ITEM_MASTER
 * Description  : Item Master 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2017/12/20   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
 * 2018/05/16   ygkim		    FN_GET_ITEM_OPERATION_GROUP 함수 제거	
 * 2018/05/18   byunghunjung    Operation Group lookup코드 변경
 * 2018/10/11   byunghunjung    Cell Item Id, Convert Qty Cell 컬럼 추가
 * 2018/10/12   hwyoon			item_name 조회조건 변경
 * 2019/10/18	hwyoon			scm_mst_site 조인 추가
 * 2021/02/18   khj79			[PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - SALES SITE 나오는 오류 수정
 */

CREATE PROCEDURE [dbo].[SCP0008_GET_ITEM_MASTER]
  @p_division_id		NVARCHAR(MAX),
  @p_class1				NVARCHAR(MAX),
  @p_class2				NVARCHAR(MAX),
  @p_material_type		NVARCHAR(MAX),
  @p_site_id			NVARCHAR(MAX),
  @p_scm_site_id		NVARCHAR(MAX),
  @p_item_class			NVARCHAR(MAX),
  @p_item_name			NVARCHAR(MAX)

AS 
BEGIN
	
    SET NOCOUNT ON;
	
	SELECT *
	FROM(
		SELECT     
			 A.COMPANY_ID
			,A.DIVISION_ID
			,A.SITE_ID
			--20191018 변경
			--,C.SCM_SITE_ID
			,X.SCM_SITE_ID  -- 2021/02/18 : SALES SITE 가 안나오도록 수정
			,A.ITEM_ID
			,A.ITEM_NAME
			,E.SEGMENT2 AS OPERATION_GROUP 
			,(CASE WHEN A.SCP_OPERATION_GROUP  = 'E' THEN [dbo].[FN_GET_ELEC_CELL_PER_METER](A.DIVISION_ID,null,A.ITEM_ID)
				   WHEN A.SCP_OPERATION_GROUP <> 'E' THEN NULL END) AS CELL_M
			,ISNULL(D.CELL_ITEM_ID,'-')  AS CELL_ITEM_ID
			,D.CONVERT_QTY_CELL
			,ISNULL(A.NICK_NAME, '-')    AS FP_PJT_CODE
			,ISNULL(X.PROJECT_CODE, '-') AS SCM_PJT_CODE  -- 2021/02/18 : SALES SITE 가 안나오도록 수정
			,(CASE WHEN A.ITEM_TYPE IS NULL THEN '-'  
				   WHEN ISNULL(LTRIM(RTRIM(A.ITEM_TYPE)),'') = '' THEN '-' ELSE A.ITEM_TYPE END ) AS ITEM_TYPE
			,B.LEVEL_1_CODE, B.LEVEL_1_ID, B.LEVEL_1_NAME AS ITEM_CLASS_LEVEL_1
			,B.LEVEL_2_CODE, B.LEVEL_2_ID, B.LEVEL_2_NAME AS ITEM_CLASS_LEVEL_2
			,B.LEVEL_3_CODE, B.LEVEL_3_ID, B.LEVEL_3_NAME AS ITEM_CLASS_LEVEL_3
			,B.LEVEL_4_CODE, B.LEVEL_4_ID, B.LEVEL_4_NAME AS ITEM_CLASS_LEVEL_4
			,A.ITEM_CLASS				,A.ITEM_CLASS_NAME			,A.MATERIAL_CLASS
			,A.MATERIAL_CLASS_NAME		,A.ELECTRODE_TYPE			,A.SIDE_TYPE
			,A.ITEM_GROUP_ID			,A.SETUP_GROUP_ID_1			,A.SETUP_GROUP_ID_2
			,A.SETUP_GROUP_ID_3			,A.FLOW_ID					,A.ERP_EOL
			,A.SCP_EOL					,A.ITEM_UOM					,A.SPEC
			,A.DEMAND_LOT_SIZE			,A.ITEM_ATTRIBUTE			,A.SETUP_ATTRIBUTE
			,A.OUTSOURCING_FACTORY		,A.FINITE_TERM				,A.FINITE_TERM_UOM
			,A.DESCRIPTION				,A.ACTIVE_FLAG				,A.BATCH_RATIO_ID
			,A.MAKE_AND_BUY
		FROM SCM_MST_ITEM_SN A (NOLOCK) 
		INNER JOIN SCM_MST_ITEM_CLASS_SN B   (NOLOCK)  ON A.ITEM_CLASS = B.CLASS_ID
		-- 수정전
		--LEFT OUTER JOIN SCM_MST_SITE_ITEM C  (NOLOCK)  ON A.DIVISION_ID = C.DIVISION_ID AND A.ITEM_ID = C.ITEM_ID
		--20191018 추가
		--LEFT OUTER JOIN SCM_MST_SITE s  (NOLOCK)  ON A.DIVISION_ID = s.DIVISION_ID AND c.SCM_SITE_ID = s.SCM_SITE_ID AND a.COMPANY_ID = s.COMPANY_ID and s.site_type = 'PLANT'
		-- 2021/02/18 : SALES SITE 가 안나오도록 수정
		LEFT JOIN (SELECT DISTINCT S.DIVISION_ID , S.SCM_SITE_ID , C.ITEM_ID , S.COMPANY_ID , C.PROJECT_CODE
					 FROM SCM_MST_SITE S WITH(NOLOCK)
					INNER JOIN SCM_MST_SITE_ITEM C WITH(NOLOCK)
					   ON S.DIVISION_ID = C.DIVISION_ID
					  AND S.SCM_SITE_ID = C.SCM_SITE_ID
					  AND S.SITE_TYPE	= 'PLANT'
				) X
			 ON A.DIVISION_ID	= X.DIVISION_ID
			AND A.ITEM_ID		= X.ITEM_ID
			AND A.COMPANY_ID	= X.COMPANY_ID
		-- 2021/02/18 : 수정 끝
		LEFT OUTER JOIN SCP_MST_FINAL_ITEM D (NOLOCK)  ON A.DIVISION_ID = D.DIVISION_ID AND A.ITEM_ID = D.ITEM_ID
		LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL E (NOLOCK) ON E.LOOKUP_TYPE = 'OPERATION_GROUP_WHOLE' AND E.segment1 = A.SCP_OPERATION_GROUP
		WHERE B.USE_FLAG = 'Y'
		AND   A.ACTIVE_FLAG='Y'
		AND  ( @p_site_id IS NULL OR A.SITE_ID LIKE '%' + @p_site_id + '%' ) 
		AND  ( @p_scm_site_id IS NULL OR X.SCM_SITE_ID LIKE '%' + @p_scm_site_id + '%' )   -- 2021/02/18 : SALES SITE 가 안나오도록 수정
		AND  ( @p_item_class  IS NULL OR A.ITEM_CLASS  LIKE '%' + @p_item_class  + '%' ) 
		--AND  ( @p_item_name   IS NULL OR (A.ITEM_NAME   LIKE '%' + @p_item_name   + '%' ) OR (A.ITEM_ID   LIKE '%' + @p_item_name   + '%' ) )
		AND (   (@p_item_name IS NULL OR @p_item_name ='') 
				OR A.ITEM_ID     IN (SELECT token FROM dbo.String_Split(@p_item_name,',')) 
				OR Exists (Select * from dbo.UF_FX_String_Split (@p_item_name,',') as P Where A.ITEM_ID LIKE P.token +'%')
				OR A.ITEM_NAME     IN (SELECT token FROM dbo.String_Split(@p_item_name,',')) 
				OR Exists (Select * from dbo.UF_FX_String_Split (@p_item_name,',') as P Where A.ITEM_NAME LIKE P.token +'%') )
		AND  A.DIVISION_ID = @p_division_id
		AND  ( @p_class1 IS NULL OR B.LEVEL_1_NAME IN  ( SELECT token FROM dbo.String_Split(@p_class1,',') ) )
		AND  ( @p_class2 IS NULL OR B.LEVEL_2_NAME IN  ( SELECT token FROM dbo.String_Split(@p_class2,',') ) )
	) A
	WHERE  ( @p_material_type IS NULL OR A.ITEM_TYPE IN ( SELECT token FROM dbo.String_Split(@p_material_type,',') )) 
	ORDER BY A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.ITEM_NAME, A.FP_PJT_CODE
		
	;				
  
END


