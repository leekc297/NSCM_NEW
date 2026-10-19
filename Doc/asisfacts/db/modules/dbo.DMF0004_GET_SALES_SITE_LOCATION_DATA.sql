
/*============================================================================================================================
 * Program ID  : DMF0004_GET_SALES_SITE_LOCATION_DATA                                                
 * Description : Procedure 작성 가이드                                                               
 * Usage       : Procedure 작성 시 참조하세요!                                                       
 * Parameter   :                                                                                   
 *                                                                                                  
 *============================================================================================================================
 * Date			In Charge	Description                                                             
 *============================================================================================================================
 * 2017/11/30	DWPARK		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트   
 * 2018/05/30	JYE			복수 팀 권한 관련  수정															
 * 2020/03/11	KHSONG		C20200103-000586 권한그룹을 LOOKUP관리											
 * 2022/10/24	rosia27		[C20221024-000510]DM UI 소스 정리 요청											
============================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0004_GET_SALES_SITE_LOCATION_DATA]
  @p_division_id	NVARCHAR(30)
, @p_scm_site_id	NVARCHAR(50)
, @p_active_flag	NVARCHAR(10)
, @p_created_by		NVARCHAR(100)
, @p_userinfo		NVARCHAR(100)
AS  
  
BEGIN
    SET NOCOUNT ON;
	DECLARE @v_group_id nvarchar(50)='';

	--IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
	--	SET @v_group_id = 'ADMIN'

	--============================================================================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
	--============================================================================================================================
	IF ISNULL(( SELECT COUNT(1) 
				  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 
				 WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
				   AND VALID_YN = 'Y'
				   AND SEGMENT2 = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
				   AND SEGMENT1 = @p_userinfo ), 0) > 0
	BEGIN
		SET @v_group_id = 'ADMIN'
	END
	--============================================================================================================================
	-- 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (END)
	--============================================================================================================================

	SELECT L.LOCATION_SEQ, L.DIVISION_ID, D.DIVISION_NAME, L.SCM_SITE_ID, L.LOCATION_CODE
		  --, L.LOCATION_DESCRIPTION
		 , ( SELECT MAX(STORAGE_DESCRIPTION) 
			   FROM SCM_MST_SLOC SLOC WITH(NOLOCK)
			  WHERE SLOC.DIVISION_ID	= L.DIVISION_ID 
			    AND SLOC.STORAGE_ID		= L.STORAGE_ID 
				AND SLOC.PLANT_ID		= L.PLANT_ID ) AS LOCATION_DESCRIPTION -- 20180704 임시처리. 저장 처리 후 복구 
		 , L.STORAGE_ID, L.PLANT_ID, L.VALID_YN, L.LAST_UPDATED_BY, L.LAST_UPDATE_DATE
		  -- , CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
		  --THEN 'Y' ELSE 'N' END AS EDIT_FLAG
		 , CASE WHEN L.DIVISION_ID <> '40' AND (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN')  THEN 'Y'
	            WHEN L.DIVISION_ID	= '40' AND(([dbo].[FN_GET_DEPT_LIST2](@p_created_by, ST.SCM_SITE_ID) = 'Y') OR @v_group_id ='ADMIN' OR @p_created_by = L.LAST_UPDATED_BY) THEN 'Y' 
				ELSE 'N' 
		    END AS EDIT_FLAG
	  FROM [dbo].[SCM_MST_LOCATION] L WITH(NOLOCK)	
	 INNER JOIN [dbo].[SCM_MST_DIVISION] D WITH(NOLOCK)	
			 ON L.DIVISION_ID = D.DIVISION_ID
	 INNER JOIN [dbo].[SCM_MST_SITE] AS ST WITH(NOLOCK)	
			 ON ST.DIVISION_ID = L.DIVISION_ID 
			AND ST.SCM_SITE_ID = L.SCM_SITE_ID
	 WHERE L.DIVISION_ID = @p_division_id
	   AND L.SCM_SITE_ID = @p_scm_site_id
	   AND CASE WHEN @p_active_flag = 'ALL' OR @p_active_flag = '' THEN @p_active_flag ELSE L.VALID_YN END = @p_active_flag		
	;								  
END