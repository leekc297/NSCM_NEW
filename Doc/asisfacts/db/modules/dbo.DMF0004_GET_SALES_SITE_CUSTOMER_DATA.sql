/****************************************************************************************************/
/* Program ID  : DM0004_GET_SALES_SITE_CUSTOMER_DATA                                                         */
/* Description : Procedure 작성 가이드                                                              */
/* Usage       : Procedure 작성 시 참조하세요!                                                      */
/* Parameter   :                                                                                    */
/*                                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2017/11/30  DWPARK       Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트 */
/* 2018/05/30  JYE			복수 팀 권한 관련  수정  
** 20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리
*/
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DMF0004_GET_SALES_SITE_CUSTOMER_DATA]
    @p_division_id		NVARCHAR(30),
    @p_scm_site_id		NVARCHAR(50),	--FCST Type
    @p_active_flag		NVARCHAR(10),
	@p_created_by		NVARCHAR(50), 
	@p_userinfo			NVARCHAR(50)
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
	
	SELECT S.DIVISION_ID,
           S.SCM_SITE_ID,
		   S.SOLDTO_CODE,
		   C.SOLDTO_DESCRIPTION,
		   S.SHIPTO_CODE,
		   C.SHIPTO_DESCRIPTION,
		   C.SHIPTO_REGION_NAME,
		   C.SHIPTO_CITY_NAME,
		   S.REP_YN,
		   S.VALID_YN,
		   S.LAST_UPDATE_DATE,
		   S.LAST_UPDATED_BY
		-- Modified by ytchoi 180627
		--   , CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
		--	THEN 'Y' ELSE 'N' END AS EDIT_FLAG
		 , CASE WHEN S.DIVISION_ID <> '40' AND (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN')  THEN 'Y'
	            WHEN S.DIVISION_ID = '40' AND(([dbo].[FN_GET_DEPT_LIST2](@p_created_by, ST.SCM_SITE_ID) = 'Y') OR @v_group_id ='ADMIN'
				OR @p_created_by = S.LAST_UPDATED_BY)  THEN 'Y' ELSE 'N' END AS EDIT_FLAG

	FROM   [dbo].[SCM_MST_SITE_CUSTOMER]  S WITH(NOLOCK) 
		   LEFT JOIN SCM_MST_CUSTOMER     C WITH(NOLOCK) 
		   ON (    S.DIVISION_ID = C.DIVISION_ID
		       AND S.SOLDTO_CODE = C.SOLDTO_CODE
		       AND S.SHIPTO_CODE = C.SHIPTO_CODE
			 )
			 INNER JOIN SCM_MST_SITE AS ST WITH(NOLOCK) 
			ON ST.DIVISION_ID = S.DIVISION_ID and ST.SCM_SITE_ID = S.SCM_SITE_ID
    WHERE  S.DIVISION_ID = @p_division_id
	AND    S.SCM_SITE_ID = @p_scm_site_id
	AND    CASE WHEN @p_active_flag = 'ALL' OR @p_active_flag = '' THEN @p_active_flag			
                ELSE S.VALID_YN
 	       END  =  @p_active_flag
								  
END

