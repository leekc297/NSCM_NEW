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
/* 2018/05/30  JYE			복수 팀 권한 관련  수정  */
/****************************************************************************************************/
CREATE PROCEDURE [dbo].[DM0004_GET_SALES_SITE_CUSTOMER_DATA]
    @p_division_id	NVARCHAR(30),
    @p_scm_site_id    NVARCHAR(50),	--FCST Type
    @p_active_flag    NVARCHAR(10),
	@p_created_by	NVARCHAR(MAX), 
	@p_userinfo		NVARCHAR(MAX)
AS  
  
BEGIN
    SET NOCOUNT ON;

	DECLARE @v_group_id nvarchar(max)='';

	IF @p_userinfo = 'ADMIN' OR @p_userinfo = 'DM ADMIN'
		SET @v_group_id = 'ADMIN'

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
		   , CASE WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, ST.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
			THEN 'Y' ELSE 'N' END AS EDIT_FLAG
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

