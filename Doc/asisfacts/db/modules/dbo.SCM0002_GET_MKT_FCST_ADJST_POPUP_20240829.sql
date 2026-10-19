/****************************************************************************************************/
/* Program ID  : SCM0002_MKTFCSTAdjstPopup                                                          */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/05/17  JYE       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트    
** 2018/05/30  JYE		 복수 팀 권한 관련  수정  
** 20200311    KHSONG    C20200103-000586 권한그룹을 LOOKUP관리
*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[SCM0002_GET_MKT_FCST_ADJST_POPUP_20240829]
	@p_division_id		NVARCHAR(4000),
	@p_team_id			NVARCHAR(4000),
	@p_customer			NVARCHAR(4000),
	@p_scm_site_id		NVARCHAR(4000),
	@p_project_code		NVARCHAR(4000),
	@p_created_by		NVARCHAR(50),
	@p_user_group		NVARCHAR(50)
AS  
  
BEGIN
    SET NOCOUNT ON;

	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_user_group = 'ADMIN' OR @p_user_group = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 기본값(특정화면에서 추가된 그룹을 제외)
						AND SEGMENT1 = @p_user_group
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT 
		MKT.DIVISION_ID
		--, TEAM.DEPT_ID
		, TEAM.DEPT_NAME_KO AS DEPT_ID
		--, SIT.END_CUSTOMER
		, MKT.SCM_SITE_ID
		, MKT.PROJECT_CODE
		, PJT.PROJECT_NAME
		--, PJT.PROJECT_OWNER
		, MKT.ITEM_ID AS MODEL
		, ITEM.ITEM_NAME AS MODEL_NAME
		, MKT.FCST_TYPE
		, (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND SEGMENT1 = MKT.FCST_TYPE) AS FCST_TYPE_NAME
		, MKT.INCOTERMS
		, MKT.PLANT_SITE_ID
		, MKT.DOM_EXP
		, CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, TEAM.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS EDIT_FLAG

	FROM [dbo].[DM_PLN_MKT_FCST] AS MKT WITH(NOLOCK)--,INDEX (PK_DM_PLN_MKT_FCST))
		LEFT JOIN [dbo].[SCM_MST_PROJECT] AS PJT WITH(NOLOCK)--,INDEX (PK_SCM_MST_PROJECT))
			ON MKT.PROJECT_CODE = PJT.PROJECT_CODE 
			AND MKT.DIVISION_ID = PJT.DIVISION_ID
		LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN = 'Y') DIV
			ON PJT.DROP_YN = 'N' 
			AND PJT.DIVISION_ID = DIV.DIVISION_ID
		LEFT JOIN [dbo].[SCM_MST_SITE] AS SIT WITH(NOLOCK) 
			ON MKT.SCM_SITE_ID = SIT.SCM_SITE_ID 
			AND MKT.DIVISION_ID = SIT.DIVISION_ID
		LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] AS TEAM  WITH(NOLOCK)
			ON SIT.DEPT_ID = TEAM.DEPT_ID 
			AND TEAM.VALID_YN = 'Y'
		LEFT JOIN [dbo].[DM_MST_ITEM_SINGLE_V] AS ITEM WITH(NOLOCK)
			ON MKT.ITEM_ID = ITEM.ITEM_ID 
			AND MKT.DIVISION_ID = ITEM.DIVISION_ID
	WHERE 1 = 1
		AND TEAM.DEPT_ID IS NOT NULL
		AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   			ELSE MKT.DIVISION_ID			
			END IN (
						SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_division_id,',') AS P WHERE 
						(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE MKT.DIVISION_ID END) = P.DATA
					)
		AND CASE WHEN @p_team_id = 'ALL' THEN 'ALL'
		   			ELSE TEAM.DEPT_ID			
			END IN (
						SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_team_id,',') AS P WHERE 
						(CASE WHEN @p_team_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.DATA
					)
		AND CASE WHEN @p_customer = 'ALL' THEN 'ALL'
		   			ELSE isnull(SIT.END_CUSTOMER,'')			
			END IN (
						SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_customer,',') AS P WHERE 
						(CASE WHEN @p_customer = 'ALL' THEN 'ALL' ELSE isnull(SIT.END_CUSTOMER,'') END) = P.DATA
					)
		AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   			ELSE MKT.SCM_SITE_ID			
			END IN (
						SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') AS P WHERE 
						(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT.SCM_SITE_ID END) = P.DATA
					)
			AND (
				EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_project_code,',') AS P WHERE MKT.PROJECT_CODE LIKE P.token +'%')
				OR
				EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_project_code,',') AS P WHERE PJT.PROJECT_NAME LIKE P.token +'%')
				)
		AND MKT.YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)
		AND MKT.MEASURE = 'MKT_FCST'
		AND MKT.QTY <> 0
	GROUP BY 
		MKT.DIVISION_ID
		, TEAM.DEPT_ID
		, TEAM.DEPT_NAME_KO
		, MKT.SCM_SITE_ID
		, MKT.PROJECT_CODE
		, PJT.PROJECT_NAME
		, MKT.ITEM_ID
		, ITEM.ITEM_NAME
		, MKT.FCST_TYPE
		, MKT.INCOTERMS
		, MKT.PLANT_SITE_ID
		, MKT.DOM_EXP

	ORDER BY MKT.DIVISION_ID
		, TEAM.DEPT_ID
		, TEAM.DEPT_NAME_KO
		, MKT.SCM_SITE_ID
		, MKT.PROJECT_CODE
		, PJT.PROJECT_NAME
		, MKT.ITEM_ID
		, ITEM.ITEM_NAME
		, MKT.FCST_TYPE
		, MKT.INCOTERMS
		, MKT.PLANT_SITE_ID
		, MKT.DOM_EXP

	SET NOCOUNT OFF;
END
