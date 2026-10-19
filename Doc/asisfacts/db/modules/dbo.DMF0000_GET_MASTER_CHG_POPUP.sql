/****************************************************************************************************/
/* Program ID  : SCM0002_MKTFCSTAdjstPopup                                                             */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2018/05/17  JYE	Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
** 2018/05/30  JYE	복수 팀 권한 관련  수정
** 20180725	ytchoi	added 속도문제로 추가
** 20180807	KHSONG	ADD 월요일 이후 데이터만 대상으로 추출
** 20180813	KHSONG	ADD qty <> 0 
** 20200311 KHSONG  C20200103-000586 권한그룹을 LOOKUP관리 
                    & Planner 인경우 타팀의 데이터가 수정이 되는 문제가 발견되어 
					ADMIN인경우 기존과 같이 모든 팀리스트업하고 ADMIN이외는 본인팀만 리스트업 되도록 수정
/****************************************************************************************************/
*/
CREATE PROCEDURE [dbo].[DMF0000_GET_MASTER_CHG_POPUP]
	@p_division_id		NVARCHAR(50),
	@p_team_id			NVARCHAR(4000),
	@p_customer			NVARCHAR(4000),
	@p_scm_site_id		NVARCHAR(4000),
	@p_project_code		NVARCHAR(4000),
	@p_created_by		NVARCHAR(50),
	@p_user_group		NVARCHAR(50)
AS  
  
BEGIN
    SET NOCOUNT ON;

	DECLARE @v_dept_id NVARCHAR(MAX);

	-- 자기 부서. 수정 여부
	SET @v_dept_id = '';
	DECLARE @v_group_id nvarchar(max)='';

	--IF @p_user_group = 'ADMIN' OR @p_user_group = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_user_group
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT @v_dept_id = isnull( (	 
									SELECT TOP 1 SEGMENT3
										FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)
											WHERE LOOKUP_TYPE	= 'PM_TEAM_MAPPING'
											AND SEGMENT1		=  U.DEPT_ID AND VALID_YN = 'Y'
								) , U.DEPT_ID 
							  )
	FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)
	WHERE  U.UserID = @p_created_by

	IF (@p_division_id <> '40')
	-----------------------------------
	--  DIV : 81,82 조회조건 (BEGIN)
	-----------------------------------
	BEGIN
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
			, ITEM.NICK_NAME
			--, CASE WHEN @v_dept_id = 'ALL' OR @v_dept_id = TEAM.DEPT_ID THEN 'Y' ELSE 'N' END EDIT_FLAG
			, CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, TEAM.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') THEN 'Y' ELSE 'N' END AS EDIT_FLAG
		FROM [dbo].[DM_PLN_MKT_FCST] AS MKT WITH(NOLOCK)--,INDEX (PK_DM_PLN_MKT_FCST))

			LEFT JOIN [dbo].[SCM_MST_PROJECT] AS PJT WITH(NOLOCK)--,INDEX (PK_SCM_MST_PROJECT))
				ON	MKT.PROJECT_CODE	=	PJT.PROJECT_CODE
				AND MKT.DIVISION_ID		=	PJT.DIVISION_ID

			LEFT JOIN (SELECT * FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK) WHERE VALID_YN = 'Y') DIV
				ON	PJT.DROP_YN			=	'N'
				AND	PJT.DIVISION_ID		=	DIV.DIVISION_ID

			LEFT JOIN [dbo].[SCM_MST_SITE] AS SIT WITH(NOLOCK) 
				ON	MKT.SCM_SITE_ID		=	SIT.SCM_SITE_ID
				AND	MKT.DIVISION_ID		=	SIT.DIVISION_ID

			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] AS TEAM  WITH(NOLOCK)
				ON	SIT.DEPT_ID			=	TEAM.DEPT_ID
				AND	TEAM.VALID_YN		=	'Y'

			LEFT JOIN [dbo].[DM_MST_ITEM_SINGLE_V] AS ITEM WITH(NOLOCK)
				ON	MKT.ITEM_ID			=	ITEM.ITEM_ID
				AND	MKT.DIVISION_ID		=	ITEM.DIVISION_ID

		WHERE 1 = 1
			--AND TEAM.DEPT_ID IS NOT NULL		
			AND ISNULL(TEAM.DEPT_ID, 'XXX') <> CASE WHEN @p_division_id <> '40' THEN 'XXX'  ELSE 'YYY' END
			AND CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   				ELSE MKT.DIVISION_ID			
				END IN (
							SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_division_id,',') AS P WHERE 
							(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE MKT.DIVISION_ID END) = P.DATA
						)
			/*
			AND CASE WHEN @p_team_id = 'ALL' THEN 'ALL'
		   				ELSE TEAM.DEPT_ID			
				END IN (
							SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_team_id,',') AS P WHERE 
							(CASE WHEN @p_team_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.DATA
						)
			AND TEAM.DEPT_ID	=	CASE WHEN @v_group_id ='ADMIN' THEN TEAM.DEPT_ID ELSE @v_dept_id END  --20200311 KHSONG  권한에 따른 팀리스트 조회조건 추가*/
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
			AND MKT.qty <> 0 -- 20180813 KHSONG ADD
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
			, ITEM.NICK_NAME
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
	END
	-----------------------------------
	--  DIV : 81,82 조회조건 (END)
	-----------------------------------
	ELSE

	-----------------------------------
	--  DIV : 40 조회조건 (BEGIN)
	-- 소형은 Planner 인경우 해당팀 코드만 넘어옴
	-----------------------------------
	BEGIN
		SELECT 
			DIVISION_ID
			, DEPT_ID
			, SCM_SITE_ID
			, END_CUSTOMER
			, MODEL
			, MODEL_NAME
			, FCST_TYPE
			, FCST_TYPE_NAME
			, INCOTERMS
			, DOM_EXP
			, NICK_NAME
			, EDIT_FLAG
		FROM (
			SELECT 
				MKT.DIVISION_ID
				, TEAM.DEPT_ID AS DEPT_ID2
				, TEAM.DEPT_NAME_KO AS DEPT_ID
				, MKT.SCM_SITE_ID
				, SITE_ITEM.PROJECT_CODE AS END_CUSTOMER
				, MKT.ITEM_ID AS MODEL
				, ITEM.ITEM_NAME AS MODEL_NAME
				, MKT.FCST_TYPE
				, (SELECT SEGMENT2 FROM [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) WHERE LOOKUP_TYPE = 'SALES_TYPE_CODE' AND SEGMENT1 = MKT.FCST_TYPE) AS FCST_TYPE_NAME
				, MKT.INCOTERMS
				, MKT.DOM_EXP
				, ITEM.NICK_NAME
				, CASE WHEN @v_group_id = 'ADMIN' OR @v_dept_id = TEAM.DEPT_ID THEN 'Y' ELSE 'N' END EDIT_FLAG
			FROM (
				SELECT
					DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
				FROM [dbo].[DM_PLN_MKT_FCST] WITH(NOLOCK) 
				--20180725 ytchoi added (S)
				WHERE CASE WHEN @p_division_id = 'ALL' THEN 'ALL'
		   					ELSE DIVISION_ID			
					END IN (
								SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_division_id,',') AS P WHERE 
								(CASE WHEN @p_division_id = 'ALL' THEN 'ALL' ELSE DIVISION_ID END) = P.DATA
							)	

				AND YYYYMMDD >= CONVERT(CHAR(8), DATEADD(DD, -7, dbo.FN_NEXT_DAY(GETDATE(), 'MON')), 112)		-- 20180807 ADD
				AND MEASURE = 'MKT_FCST'
				AND qty <> 0 -- 20180813 KHSONG ADD

				GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID
			) AS MKT
			INNER JOIN [dbo].[SCM_MST_SITE_ITEM] AS SITE_ITEM WITH(NOLOCK) 
				ON	MKT.SCM_SITE_ID			=	SITE_ITEM.SCM_SITE_ID
				AND MKT.ITEM_ID				=	SITE_ITEM.ITEM_ID
				AND SITE_ITEM.PROJECT_CODE	=	mkt.PROJECT_CODE
				AND SITE_ITEM.DIVISION_ID	=	mkt.DIVISION_ID  -- 20180807 ADD

			LEFT JOIN [dbo].[SCM_MST_SSO_USER_INFO] AS USER_INFO  WITH(NOLOCK)
				ON SITE_ITEM.OWNER		=	USER_INFO.USER_ID

			LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] AS TEAM  WITH(NOLOCK)
				ON	USER_INFO.DEPT_ID	=	TEAM.DEPT_ID
				AND	TEAM.VALID_YN = 'Y'	

			LEFT JOIN [dbo].[DM_MST_ITEM_SINGLE_V] AS ITEM WITH(NOLOCK)
				ON	MKT.ITEM_ID			=	ITEM.ITEM_ID
				AND	MKT.DIVISION_ID = ITEM.DIVISION_ID
	
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
							Select * from dbo.UF_FX_String_SplitForIN (@p_team_id,',') as P Where 
							             (CASE WHEN @p_team_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.data
						   )
				AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL'
		   					ELSE MKT.SCM_SITE_ID			
					END IN (
								SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') AS P WHERE 
								(CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE MKT.SCM_SITE_ID END) = P.DATA
							)
					AND (
						EXISTS (SELECT * FROM dbo.UF_FX_String_Split (@p_project_code,',') AS P WHERE SITE_ITEM.PROJECT_CODE LIKE P.token +'%')
						)


		) MA 
		GROUP BY 
			DIVISION_ID
			, DEPT_ID2
			, DEPT_ID
			, SCM_SITE_ID
			, END_CUSTOMER
			, MODEL
			, MODEL_NAME
			, FCST_TYPE
			, FCST_TYPE_NAME
			, INCOTERMS
			, DOM_EXP
			, NICK_NAME
			, EDIT_FLAG
		ORDER BY 
			DIVISION_ID
			, DEPT_ID2
			, SCM_SITE_ID
			, END_CUSTOMER
			, MODEL
			, MODEL_NAME
			, FCST_TYPE
			, FCST_TYPE_NAME
			, INCOTERMS
			, DOM_EXP
	END
	-----------------------------------
	--  DIV : 40 조회조건 (END)
	-----------------------------------

	SET NOCOUNT OFF;
END

-- USE [LGCE_SCMDEV]
