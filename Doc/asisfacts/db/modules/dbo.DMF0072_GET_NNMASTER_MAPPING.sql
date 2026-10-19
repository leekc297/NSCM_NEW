
/*=====================================================================================================================================================
* Program ID  : [DMF0072_GET_NNMASTER_MAPPING]                                                           
* Description : Procedure 작성 가이드                                                              
* Usage       : Procedure 작성 시 참조하세요!                                                      
* Parameter   :                                                                                    
*=====================================================================================================================================================
*	 Date     In Charge		Description                                                             
*=====================================================================================================================================================
* 2024.04.02	KJJ			Initial Release  
* 2024.08.14	KJJ			[PJ2024-50461] Team Mapping
* 2024.12.10	dsiol		[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 
* 2025.01.21	dsiol		[PJ2024-50647]자동차사업부 고객 수요 분석 기능 개선 * 2차배포 
* 2025.09.16	JSSBAE		[E20250910-000974]_NN Mapping Master 컬럼 추가 요청

-- EXEC DMF0072_GET_NNMASTER_MAPPING          @p_data_type_code='ALL', @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code='', @p_item_id=''
-- EXEC DMF0072_GET_NNMASTER_MAPPING_20241210 @p_division_id='81', @p_dept_id='ALL', @p_end_customer='ALL', @p_scm_site_id='ALL', @p_project_code='', @p_item_id=''
*===================================================================================================================================================*/

CREATE PROCEDURE [dbo].[DMF0072_GET_NNMASTER_MAPPING]
	  @p_data_type_code		NVARCHAR(10)
	, @p_division_id		NVARCHAR(30)
	, @p_dept_id			NVARCHAR(4000)	--Department
	, @p_end_customer		NVARCHAR(4000)	--Endcustomer
	, @p_scm_site_id		NVARCHAR(30)
	, @p_project_code		NVARCHAR(50)
	, @p_item_id			NVARCHAR(50)
AS  

BEGIN
	SET NOCOUNT ON;

	SELECT DATA_TYPE_CODE, DIVISION_ID, COMPANY_ID, END_CUSTOMER, UNLOADING_POINT
		 , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, PROJECT_CODE
		 , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
		 , MAPPING_ITEM_ID, MAPPING_ITEM_ID AS MAPPING_ITEM_ID_ORIGINAL, VALID_START_DATE, VALID_END_DATE, ACTIVE_YN 
		 , LAST_UPDATE_DATE, LAST_UPDATED_BY
		 , DC_LEVEL --[E20250910-000974]_DC_LEVEL 추가
	FROM ( SELECT M.DATA_TYPE_CODE, M.DIVISION_ID, M.COMPANY_ID, M.END_CUSTOMER, M.UNLOADING_POINT
		 		, M.CUSTOMER_PLANT, M.SOLDTO_CODE, M.SHIPTO_CODE, M.SCM_SITE_ID, M.PROJECT_CODE
				, M.FCST_TYPE, M.INCOTERMS, M.DOM_EXP, M.CUSTOMER_ITEM_ID, M.ITEM_ID
				, M.MAPPING_ITEM_ID, M.VALID_START_DATE, M.VALID_END_DATE, M.ACTIVE_YN
				, M.LAST_UPDATE_DATE, M.LAST_UPDATED_BY, ISNULL(M.DC_LEVEL,'') AS DC_LEVEL --[E20250910-000974]_DC_LEVEL 추가
			 FROM DM_CUST_MODEL_MAPPING_M M WITH(NOLOCK)
			INNER JOIN ( SELECT * FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y') C 
					ON M.DIVISION_ID = C.DIVISION_ID AND M.SCM_SITE_ID = C.SCM_SITE_ID AND C.SITE_TYPE = 'SALES'
			 LEFT OUTER JOIN ( SELECT * FROM SCM_MST_SITE_ITEM WITH(NOLOCK)) SITE_ITEM
						  ON M.DIVISION_ID	= SITE_ITEM.DIVISION_ID
						 AND M.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
						 AND M.SCM_SITE_ID	= SITE_ITEM.SCM_SITE_ID
						 AND M.ITEM_ID		= SITE_ITEM.ITEM_ID
			 LEFT JOIN ( SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO, C.UPPER_DEPT_ID 
						   FROM SCM_MST_SSO_USER_INFO B WITH(NOLOCK)
						  INNER JOIN SCM_MST_SSO_DEPT_INFO C WITH(NOLOCK)
								  ON B.DEPT_ID = C.DEPT_ID ) TEAM
					ON TEAM.USER_ID IN (SELECT TOP 1 token FROM [dbo].[String_Split](SITE_ITEM.OWNER, ','))
			 WHERE M.DATA_TYPE_CODE = CASE WHEN @P_DATA_TYPE_CODE = 'ALL' THEN M.DATA_TYPE_CODE ELSE @P_DATA_TYPE_CODE END
			   AND M.DIVISION_ID    = @P_DIVISION_ID
			   AND CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END IN ( SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_dept_id,',') AS P 
																					  WHERE ( CASE WHEN @p_dept_id = 'ALL' THEN 'ALL' ELSE TEAM.DEPT_ID END) = P.DATA )
			   AND CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE ISNULL(M.END_CUSTOMER,'') END IN ( SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_end_customer,',') AS P 
																										WHERE ( CASE WHEN @p_end_customer = 'ALL' THEN 'ALL' ELSE ISNULL(M.END_CUSTOMER,'') END) = P.DATA )					  
			   AND CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE M.SCM_SITE_ID END IN ( SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_scm_site_id,',') AS P 
																						   WHERE ( CASE WHEN @p_scm_site_id = 'ALL' THEN 'ALL' ELSE M.SCM_SITE_ID END) = P.DATA )
			   AND CASE WHEN @p_project_code = '' THEN '' ELSE M.PROJECT_CODE END IN ( SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_project_code,',') AS P 
																					   WHERE ( CASE WHEN @p_project_code = '' THEN '' ELSE M.PROJECT_CODE END) = P.DATA )
			   AND CASE WHEN @p_item_id = '' THEN '' ELSE M.ITEM_ID	END IN ( SELECT * FROM dbo.UF_FX_String_SplitForIN (@p_item_id,',') AS P 
																			 WHERE ( CASE WHEN @p_item_id = '' THEN '' ELSE M.ITEM_ID END) = P.DATA )
		 ) A
	GROUP BY DIVISION_ID, COMPANY_ID, DATA_TYPE_CODE, END_CUSTOMER, UNLOADING_POINT
		   , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, PROJECT_CODE, SCM_SITE_ID
		   , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
		   , MAPPING_ITEM_ID, ACTIVE_YN, VALID_START_DATE, VALID_END_DATE
		   , LAST_UPDATE_DATE, LAST_UPDATED_BY, DC_LEVEL  --[E20250910-000974]_DC_LEVEL 추가
	ORDER BY DIVISION_ID, DATA_TYPE_CODE, COMPANY_ID, END_CUSTOMER, UNLOADING_POINT
		   , CUSTOMER_PLANT, SOLDTO_CODE, SHIPTO_CODE, SCM_SITE_ID, PROJECT_CODE
		   , FCST_TYPE, INCOTERMS, DOM_EXP, CUSTOMER_ITEM_ID, ITEM_ID
END

