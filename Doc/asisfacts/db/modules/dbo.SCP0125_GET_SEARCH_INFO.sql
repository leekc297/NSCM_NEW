


/*
 * Program ID   : SCP0125_GET_SEARCH_INFO
 * Description  : Workbench 조회조건 및 콤보박스 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/06/25   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/07/14   mrchois			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - 소형 Project code 정보 추가
 * 2025/09/17   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 재고(Elec.) 탭 추가
 * 2025/10/29   mrchois			PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Stock(2nd OCV) 탭 추가
 *
 */

CREATE PROCEDURE [dbo].[SCP0125_GET_SEARCH_INFO]
  
	
AS
BEGIN
	
    SET NOCOUNT ON; 
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED


	--1. MKT FCST Version 정보(60일전 버전까지 )
	SELECT  VERSION_NO AS CODE
		    , VERSION_NO AS NAME
			, DIVISION_ID
			, YYYYMMDD
		FROM DM_MST_VERSION WITH(NOLOCK)
	WHERE 1=1
	--AND VERSION_NO like 'MF_%'
	AND VERSION_TYPE IN ('MF_W', 'SF_W')
	AND YYYYMMDD LIKE '%' + CAST(YEAR(GETDATE()) AS NVARCHAR) + '%' 
	ORDER BY VERSION_NO DESC

	--2. Sale Site
	SELECT DISTINCT A.DIVISION_ID
		, SCM_SITE_ID AS CODE 
		, SCM_SITE_ID AS NAME
	FROM   SCM_MST_SITE A WITH(NOLOCK) 
	WHERE  1 = 1
	AND A.SITE_TYPE = 'SALES'	
	AND A.DIVISION_ID != '40'
	AND A.VALID_YN = 'Y'	
	UNION ALL
	SELECT DISTINCT A.DIVISION_ID
		, A.SCM_SITE_ID AS CODE 
		, A.SCM_SITE_ID AS NAME
	FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
	LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
		ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
	WHERE  1 = 1
	AND A.SITE_TYPE = 'SALES'
	AND  A.DIVISION_ID = '40'
	AND A.VALID_YN = 'Y'
	ORDER BY A.DIVISION_ID

	--3. Plant Site
	SELECT DISTINCT A.DIVISION_ID
		, SCM_SITE_ID AS CODE 
		, SCM_SITE_ID AS NAME
		, PLANT_ID
	FROM   [dbo].[SCM_MST_SITE] A
	WHERE  1 = 1
	AND    A.SITE_TYPE = 'PLANT'
	AND    A.VALID_YN = 'Y'			--[PJ20257329] Stock(2nd OCV) 탭 추가 (2025-10-29)

	--4. 재고 SCM SITE ID 
	SELECT DISTINCT A.DIVISION_ID
		, SCM_SITE_ID AS CODE 
		, SCM_SITE_ID AS NAME
	FROM   SCM_MST_SITE A WITH(NOLOCK) 
	WHERE  1 = 1
	AND A.SITE_TYPE = 'SALES'	
	AND A.DIVISION_ID != '40'
	AND A.VALID_YN = 'Y'	
	UNION ALL
	SELECT DISTINCT A.DIVISION_ID
		, A.SCM_SITE_ID AS CODE 
		, A.SCM_SITE_ID AS NAME
	FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
	LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
		ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
	WHERE  1 = 1
	AND A.SITE_TYPE = 'SALES'
	AND  A.DIVISION_ID = '40'
	AND A.VALID_YN = 'Y'
	UNION ALL
	SELECT DISTINCT A.DIVISION_ID
		, SCM_SITE_ID AS CODE 
		, SCM_SITE_ID AS NAME
	FROM   [dbo].[SCM_MST_SITE] A
	WHERE  1 = 1
	AND    A.SITE_TYPE = 'PLANT'
	ORDER BY A.DIVISION_ID


	--5.Item 정보(Validation 체크용)
	SELECT DISTINCT DIVISION_ID, ITEM_ID
	FROM SCM_MST_ITEM_SN WITH(NOLOCK)

	--6.Project code 정보(Validation 체크용)
	SELECT distinct  DIVISION_ID, PROJECT_CODE
	FROM SCM_MST_PROJECT WITH(NOLOCK)

	--7.소형 Project code 정보(Validation 체크용)		--소형 Project code 정보(2025-07-14)
	SELECT DISTINCT A.PROJECT_CODE AS CODE
		, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
	FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)
	INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID
	INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID
	LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)
		ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'
	WHERE B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )  
	AND B.DEPT_ID = C.DEPT_ID
	AND A.DIVISION_ID = '40'
	AND A.VALID_YN = 'Y'
	UNION
	SELECT SEGMENT2 AS CODE , SEGMENT3 AS NAME
	FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
	WHERE  LOOKUP_TYPE = 'END_CUSTOMER'
	AND SEGMENT2 <> '-'
	AND VALID_YN = 'Y'
	AND SEGMENT1 = '40'
	ORDER BY CODE

	--[PJ20257329] 재고(Elec.) 탭 추가 (2025-09-17) STRAT
	--8.Location Code 정보(combo용)
	SELECT SEGMENT1		AS CODE
		 , SEGMENT2		AS NAME
		 , SEGMENT3		AS ELEC_YN
	FROM SCM_ADM_LOOKUP_MASTER_DETAIL
	WHERE  LOOKUP_TYPE = 'OPMZ_LOCATION_CODE'
	AND SEGMENT3 = 'Y'
	AND VALID_YN = 'Y'
	ORDER BY DISPLAY_SEQ

	--9.Line 정보(combo용)
	select l.division_id
		,l.plant_id
		,l.operation_id
		,l.line_id		as CODE
		,l.line_id		as NAME
		,max(l.line_name) as line_name 
	from scm_mst_line_sn l with(nolock)
    inner join scm_mst_factory_sn f with(nolock)
	   on f.company_id = l.company_id and f.factory_id = l.factory_id 
	where 1=1
	  and exists (select *
					from scm_adm_lookup_master_detail  op with(nolock)
					where 1=1
					  and op.lookup_type = 'SCP_PLAN_OPERATION'
					  and op.valid_yn = 'Y'
					  and op.segment1 = l.operation_id
					  and op.segment4 like concat('%', l.division_id, '%')) 
	  and l.active_flag =  'Y'
	group by l.division_id
			,l.plant_id
			,l.operation_id
			,l.line_id
		;
	--[PJ20257329] 재고(Elec.) 탭 추가 (2025-09-17) END

END

