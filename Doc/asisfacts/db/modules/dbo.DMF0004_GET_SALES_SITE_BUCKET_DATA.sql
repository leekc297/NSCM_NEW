/****************************************************************************************************/
/* Program ID  : DMF0004_GET_SALES_SITE_BUCKET_DATA                                                  */
/* Description : Procedure 작성 가이드                                                               */
/* Usage       : Procedure 작성 시 참조하세요!                                                       */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/30  DWPARK       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   */
/* 2018/05/30  JYE			복수 팀 권한 관련  수정													*/								
/* 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리											*/
/* 20221024		rosia27		[C20221024-000510]DM UI 소스 정리 요청									*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0004_GET_SALES_SITE_BUCKET_DATA]
	@p_division_id	NVARCHAR(30),
	@p_scm_site_id  NVARCHAR(50),
	@p_created_by	NVARCHAR(100),
	@p_userinfo		NVARCHAR(100)
AS  
  
BEGIN
  SET NOCOUNT ON;

	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	---------------------------------------------------------------------------------
	IF ISNULL((
				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
					where LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
						AND VALID_YN = 'Y'
						AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
						AND SEGMENT1 = @p_userinfo
			  ),0) > 0
		BEGIN
			SET @v_group_id = 'ADMIN'
		END
	---------------------------------------------------------------------------------
	--            20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	---------------------------------------------------------------------------------

	SELECT 
		MA.DIVISION_ID 
		, MA.SCM_SITE_ID
		, MA.INCOTERMS
		, MA.D_MON
		, MA.D_TUE
		, MA.D_WED
		, MA.D_THU
		, MA.D_FRI
		, MA.D_SAT
		, MA.D_SUN
		, MA.LAST_UPDATE_DATE
		, MA.LAST_UPDATED_BY
		--, CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
		--	THEN 'Y' ELSE 'N' END AS EDIT_FLAG
		, CASE WHEN MA.DIVISION_ID <> '40' AND (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN')  THEN 'Y'
	            WHEN MA.DIVISION_ID = '40' AND(([dbo].[FN_GET_DEPT_LIST2](@p_created_by, ST.SCM_SITE_ID) = 'Y') OR @v_group_id ='ADMIN'
				OR @p_created_by = MA.LAST_UPDATED_BY)  THEN 'Y' ELSE 'N' END AS EDIT_FLAG
	FROM (
		SELECT B.DIVISION_ID
			 , B.SCM_SITE_ID
			 , B.INCOTERMS
			 , MAX(CASE WHEN B.YYYYMMDD = 'MON' THEN B.BUCKET_PER ELSE '' END) AS D_MON
			 , MAX(CASE WHEN B.YYYYMMDD = 'TUE' THEN B.BUCKET_PER ELSE '' END) AS D_TUE
			 , MAX(CASE WHEN B.YYYYMMDD = 'WED' THEN B.BUCKET_PER ELSE '' END) AS D_WED
			 , MAX(CASE WHEN B.YYYYMMDD = 'THU' THEN B.BUCKET_PER ELSE '' END) AS D_THU
			 , MAX(CASE WHEN B.YYYYMMDD = 'FRI' THEN B.BUCKET_PER ELSE '' END) AS D_FRI
			 , MAX(CASE WHEN B.YYYYMMDD = 'SAT' THEN B.BUCKET_PER ELSE '' END) AS D_SAT
			 , MAX(CASE WHEN B.YYYYMMDD = 'SUN' THEN B.BUCKET_PER ELSE '' END) AS D_SUN
			 , MAX(B.LAST_UPDATE_DATE) AS LAST_UPDATE_DATE
			 , MAX(B.LAST_UPDATED_BY)  AS LAST_UPDATED_BY
		FROM   DM_MST_BUCKET_CONVERSION B  WITH(NOLOCK)
		WHERE  1 = 1
		AND    B.CONVERSION_TYPE = 'WTOD'
		AND    B.DIVISION_ID     = @p_division_id
		AND    B.SCM_SITE_ID     = @p_scm_site_id
		GROUP BY B.DIVISION_ID
			   , B.SCM_SITE_ID
			   , B.INCOTERMS
	) AS MA
	INNER JOIN [dbo].[SCM_MST_SITE] AS ST WITH(NOLOCK)
		ON ST.DIVISION_ID = MA.DIVISION_ID and ST.SCM_SITE_ID = MA.SCM_SITE_ID
    ;
								  
END
