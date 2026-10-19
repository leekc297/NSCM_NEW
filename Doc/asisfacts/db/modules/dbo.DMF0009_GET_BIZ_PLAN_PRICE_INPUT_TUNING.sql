

/*
 * Program ID   : DMF0009_GET_BIZ_PLAN_PRICE_INPUT_TUNING
 * Description  : DMF0009_BizPlanPrice_Input(메탈 판가 기준등록 화면)의 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2023/07/14	ilovu1			Initial Release 사업계획 프로젝트
 * 2023/09/04   ilovu1          CELL_PROD_SITE 컬럼 추가
 * 2023/09/18   ilovu1		    METAL_LINK_START_MONTH 컬럼 추가
 * 2023/09/21   ilovu1		    Compile
 */
--EXEC DMF0009_GET_BIZ_PLAN_PRICE_INPUT_TUNING '81', 'ALL', 'ALL', 'ALL', '', '', 'ALL', 'chano0612', 'ADMIN', '', 'ICH', 'N'
CREATE PROCEDURE [dbo].[DMF0009_GET_BIZ_PLAN_PRICE_INPUT_TUNING]
	  @p_division_id		NVARCHAR(50)	--Division
	, @p_dept_id			NVARCHAR(4000)	--Department
	, @p_end_customer		NVARCHAR(4000)	--End Customer
	, @p_scm_site_id		NVARCHAR(4000)	--
	, @p_project_code		NVARCHAR(4000)
	, @p_item_id			NVARCHAR(4000)
	, @p_valid_yn			NVARCHAR(4000)
	, @p_created_by			NVARCHAR(50)
	, @p_userinfo			NVARCHAR(50)
	, @p_owner				NVARCHAR(4000)
	, @p_user_dept_id		NVARCHAR(50)   -- JV Planner 일때 USER 부서정보로 SALES SITE ID 정보를 얻기 위해추가 
	, @p_end_cust_report_yn NVARCHAR(1)
AS
BEGIN
	SET NOCOUNT ON;

	---------------------------------------------------------------------------------
    --      20200311 KHSONG C20200103-000586 권한그룹을 LOOKUP관리 (BEGIN)
    ---------------------------------------------------------------------------------
    DECLARE @v_group_id NVARCHAR(50)='';
    IF EXISTS (SELECT 1
    			 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK) 
    			WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP' 
    			  AND VALID_YN    = 'Y'
    			  AND SEGMENT2    = 'ALL'  -- 'ALL'인경우 DM Planner (W/S) 제외 / 주석처리인경우 DM Planner (W/S) 포함 
    			  AND SEGMENT1    = @p_userinfo
              )
    BEGIN
    	set @v_group_id = 'ADMIN';
    END

	IF @p_division_id = '40'		--소형
	BEGIN
		SELECT *				
			 , CASE 
					WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
					THEN 'Y' 
					ELSE 'N' 
			   END AS EDIT_FLAG		
			 , CASE 
					WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, DEPT_ID) = 'Y') AND (@p_userinfo ='DM Planner')) 
					THEN 'Y' 
					ELSE 'N' 
			   END AS EDIT_FLAG3
		  INTO #SOURCE3
		  FROM (SELECT SITE_PROJECT.DIVISION_ID
					 , TEAM.DEPT_ID
					 , TEAM.DEPT_ID           AS DEPT_ID2
					 , TEAM.DEPT_NAME_KO      AS TEAM_NAME_KO
					 , SITE_ITEM.PROJECT_CODE AS END_CUSTOMER
					 , SITE_ITEM.PROJECT_CODE AS END_CUSTOMER40
					 , SITE_CUST.SOLDTO_CODE
	     			 , CUST.SOLDTO_DESCRIPTION
					 , SITE_CUST.SHIPTO_CODE
					 , CUST.SHIPTO_DESCRIPTION
					 , SITE_PROJECT.SCM_SITE_ID
					 , SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40
					 , SITE_PROJECT.PROJECT_CODE
					 , PJT.PROJECT_NAME
					 , PJT.PROJECT_STATUS
					 , PJT.PROJECT_OWNER
					 , SITE_PROJECT.owner		AS USER_ID
					 , SITE_ITEM.SALES_PLAN_ADJUST_YN
					 , SITE_ITEM.ITEM_TYPE
					 , SITE_ITEM.ITEM_CLASS_NAME
					 , SITE_ITEM.ITEM_ID
					 , SITE_ITEM.ITEM_NAME
					 , SITE_ITEM.CELL_PER_CAR
					 , SITE_ITEM.CELL_PER_MODULE
					 , SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE AS MODULE_PER_CAR

					 , CUST_ITEM.CUSTOMER_MODEL
					 , SITE_ITEM.NICK_NAME
					 , SITE_ITEM.SALES_COMPANY
					 , SITE_ITEM.SALES_PLANT

					 , SITE_ITEM.BPMS_EXIST
					 , SITE_ITEM.LIABILITY_PERIOD
					 --, SITE_ITEM.CURRENCY	--ilovu1: 메탈 단가 기준(DM_MST_METAL_PRICE_RULE)의 CURRENCY와 충돌함.
					 , CASE 
							WHEN SITE_ITEM.ITEM_ID IS NULL 
							THEN ISNULL(SITE_PROJECT.VALID_YN, SITE_ITEM.VALID_YN) 
							ELSE SITE_ITEM.VALID_YN 
					   END AS VALID_YN
				 
					 , SITE_ITEM.LAST_UPDATE_DATE
					 , SITE_ITEM.LAST_UPDATED_BY
						
					 , SITE_ITEM.CUST_GROUP
					 , SITE_ITEM.CUST_GROUP_DTL
						
					 , dbo.FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') AS OWNER
					 , SITE_ITEM.APPLICATION
					 , SITE_ITEM.ROUTE 
				 	   
					 , SITE_ITEM.EDI		
					 , SITE_ITEM.EDI_LT	
				 
					 , SITE_ITEM.ATTRIBUTE1
					 , SITE_ITEM.ATTRIBUTE2
					 , SITE_ITEM.ATTRIBUTE4  
					 , SITE_ITEM.ATTRIBUTE5  
					 , SITE_ITEM.ATTRIBUTE9  AS PRODUCTION_PROCESS
					 --------------------------------
					 , SITE.SOLDTO_CUSTOMER
					 
					 , REPORT_GROUP1
					 , REPORT_GROUP2
					 , REPORT_GROUP3
					 , REPORT_GROUP4
					 
					 , REPORT_GROUP6
					 , REPORT_GROUP7
					 , REPORT_GROUP8
					 , SITE_ITEM.CELL_TYPE
					 , ISNULL(SITE_PROJECT.VMI_LT,0) AS VMI_LT
		     ---------------------------------------------------------------------------------
			 -- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
			 ---------------------------------------------------------------------------------
--			 , M.CELL_PROD_SITE						   --Cell 생산지
--			 , M.BASE_PRICE                            --기준단가
--			 , M.METAL_LINK_YN                         --메탈링크여부
--			 , M.CURRENCY                              --통화코드
--			 , M.METAL_LINK_PERIOD                     --메탈링크범위
--			 , M.METAL_LINK_MTD                        --메탈링크방법
--			 , CONVERT(DATETIME, M.START_YM + '01') START_YM--시작연월
--			 , CONVERT(DATETIME, M.END_YM + '01') END_YM    --종료연월
--			 , M.AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
--			 , M.CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
--			 , M.MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
--			 , M.NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
--			 , M.CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
--			 , M.LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
--			 , M.LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
--			 , M.AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
--			 , M.CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
--			 , M.MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
--			 , M.NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
--			 , M.CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
--			 , M.LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
--			 , M.LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
--			 , M.CNTRC_EXCHANGE_PRICE                  --계약시 환율
--			 , M.AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
--			 , M.CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
--			 , M.MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
--			 , M.NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
--			 , M.CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
--			 , M.LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
--			 , M.LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
--			 --, M.AL_STND_MARKET                        --기준시장Al
--			 --, M.CU_STND_MARKET                        --기준시장Cu
--			 --, M.MN_STND_MARKET                        --기준시장Mn
--			 --, M.NI_STND_MARKET                        --기준시장Ni
--			 --, M.CO_STND_MARKET                        --기준시장Co
--			 --, M.LI2CO3_STND_MARKET                    --기준시장Li2Co3
--			 --, M.LIOH_STND_MARKET                      --기준시장LiOH
			 ---------------------------------------------------------------------------------
				  FROM 
								   (SELECT DISTINCT
										   A.DIVISION_ID
										 , SCM_SITE_ID
										 , PROJECT_CODE
										 , ISNULL(MAX(VALID_YN),'Y') AS VALID_YN
										 , '' owner
										 , '' ITEM_ID
										 , REPORT_GROUP1
										 , REPORT_GROUP2
										 , REPORT_GROUP3
										 , REPORT_GROUP4
										 --,REPORT_GROUP5
										 , REPORT_GROUP6
										 , REPORT_GROUP7
										 , REPORT_GROUP8
										 , MAX(A.SCP_VMI_LT) AS VMI_LT
									  FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
										 , SCM_MST_ITEM_SN   B WITH (NOLOCK)
									   /* ilovu1, 2023.07.07
										  SCM_MST_SITE_ITEM[사이트품목기본]
											#DIVISION_ID	(사업부ID)
											#PROJECT_CODE	(프로젝트코드)
											#SCM_SITE_ID	(SCM사이트ID)
											#ITEM_ID		(품목ID)	   
									   */
									  /* ilovu1, 2023.07.07
										 SCM_MST_ITEM_SN = [LGCE_FP_TR_QA].[DBO].[SCM_ITEM_M][품목기본]
											#COMPANY_ID		(회사코드)
											#DIVISION_ID	(사업부코드)
											#SITE_ID		(지역코드)
											#ITEM_ID		(제품코드)
									  */
								   --WHERE ISNULL(VALID_YN,'Y')	='Y'
									 WHERE A.ITEM_ID      = B.ITEM_ID 
									   AND A.division_id <> '40'
									GROUP BY 
										  A.DIVISION_ID
										, SCM_SITE_ID
										, PROJECT_CODE
										, A.ATTRIBUTE1
										, A.ATTRIBUTE2
										-- 20190402
										, REPORT_GROUP1
										, REPORT_GROUP2
										, REPORT_GROUP3
										, REPORT_GROUP4
										--,REPORT_GROUP5
										, REPORT_GROUP6
										, REPORT_GROUP7
										, REPORT_GROUP8
									UNION
								   SELECT DISTINCT
										  A.DIVISION_ID
										, SCM_SITE_ID
										, PROJECT_CODE
										, VALID_YN
										, a.owner
										, ITEM_ID
										-- 20190402
										, REPORT_GROUP1
										, REPORT_GROUP2
										, REPORT_GROUP3
										, REPORT_GROUP4
										--,REPORT_GROUP5
										, REPORT_GROUP6
										, REPORT_GROUP7
										, REPORT_GROUP8
										, A.SCP_VMI_LT
									 FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
									   /* ilovu1, 2023.07.07
										  SCM_MST_SITE_ITEM[사이트품목기본]
											#DIVISION_ID	(사업부ID)
											#PROJECT_CODE	(프로젝트코드)
											#SCM_SITE_ID	(SCM사이트ID)
											#ITEM_ID		(품목ID)	   
									   */
								--	WHERE ISNULL(VALID_YN,'Y')	='Y'
									WHERE A.division_id = '40'
								   ) AS SITE_PROJECT
					   LEFT JOIN SCM_MST_PROJECT AS PJT  WITH (NOLOCK)
							  ON SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
							 AND SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID
							   /* ilovu1, 2023.07.07
								  SCM_MST_PROJECT[프로젝트기본]
									#DIVISION_ID		(사업부ID)
									#PROJECT_CODE		(프로젝트코드)
									#PROJECT_VER_SEQ	(프로젝트버전순번)

									SELECT DIVISION_ID				--(사업부ID)
										 , PROJECT_CODE				--(프로젝트코드)
										 , count(*) cnt
									  FROM SCM_MST_PROJECT
									 GROUP BY
										   DIVISION_ID				--(사업부ID)
										 , PROJECT_CODE				--(프로젝트코드)
									 having count(*) > 1
										 ;--O rows returned
							   */
					   LEFT JOIN SCM_MST_SITE AS SITE  WITH (NOLOCK)
							  ON SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID  
							 AND SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
							 AND SITE.SITE_TYPE  = 'SALES'  
							/* ilovu1, 2023.07.07
								SCM_MST_SITE[SCM사이트기본]
									#DIVISION_ID		(사업부ID)
									#SCM_SITE_ID		(SCM사이트ID)
							*/
					   LEFT JOIN (SELECT
	               						 B.USER_ID
									   , B.USER_NAME
									   , B.USER_NAME_EN
									   , B.DEPT_ID
									   , C.DEPT_NAME_KO 
	               					FROM [SCM_MST_SSO_USER_INFO] AS B
	               						 INNER JOIN SCM_MST_SSO_DEPT_INFO AS C
	               								 ON B.DEPT_ID = C.DEPT_ID
								 ) AS TEAM
							  ON TEAM.USER_ID IN (SELECT top 1 token FROM [dbo].[String_Split](SITE_PROJECT.owner, ','))
					   LEFT JOIN (SELECT T1.DIVISION_ID
									   , T1.SCM_SITE_ID
									   , T1.PROJECT_CODE
									   , T1.ITEM_ID
									   , T1.CELL_PER_CAR
									   , T1.CELL_PER_MODULE
									   , T2.ITEM_NAME
									   , T2.ITEM_TYPE
									   , T2.ITEM_CLASS_NAME
									   , T1.SALES_PLAN_ADJUST_YN
									   , T2.NICK_NAME
									   , T1.BPMS_EXIST
									   , T1.LIABILITY_PERIOD
									   , T1.CURRENCY
									   , T1.VALID_YN
									   , T1.LAST_UPDATE_DATE
									   , T1.LAST_UPDATED_BY	
									   
									   , T1.CUST_GROUP
									   , T1.CUST_GROUP_DTL
									   , T1.OWNER
									   , T1.APPLICATION
									   , T1.ROUTE 
									   , T1.ATTRIBUTE6 AS EDI
									   , T1.EDI_LT				
									   , T1.ATTRIBUTE1
									   , T1.ATTRIBUTE2
									   , T1.ATTRIBUTE5	
									   
									   , CO.COUNTRY_NAME AS ATTRIBUTE4
									   , T1.ATTRIBUTE9    
									   , (SELECT LMD.SEGMENT2  AS NAME 
							       			FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] LMD WITH (NOLOCK)
							       		   WHERE LOOKUP_TYPE = 'CELL_TYPE' AND T2.CELL_TYPE = LMD.SEGMENT1 
										 ) AS CELL_TYPE
									   , T1.SALES_COMPANY
									   , T1.SALES_PLANT	
									FROM 	         SCM_MST_SITE_ITEM		T1  WITH (NOLOCK)
										 INNER JOIN DM_MST_ITEM_SINGLE_V	T2  WITH (NOLOCK)
										         ON T1.DIVISION_ID = T2.DIVISION_ID
										        AND T1.ITEM_ID     = T2.ITEM_ID
										   /* ilovu1, 2023.07.07
											  SCM_MST_SITE_ITEM[사이트품목기본]
												#DIVISION_ID	(사업부ID)
												#PROJECT_CODE	(프로젝트코드)
												#SCM_SITE_ID	(SCM사이트ID)
												#ITEM_ID		(품목ID)	 
									
											  DM_MST_ITEM_SINGLE_V
												FROM
													SCM_MST_ITEM_SN T1 
													INNER JOIN 
															   (SCM_MST_ITEM_SN GROUP BY DIVISION_ID, LEFT(ITEM_ID, 12)) T2 
															ON T1.DIVISION_ID				= T2.DIVISION_ID
														   AND SUBSTRING(T1.ITEM_ID,1,12)	= T2.ITEM_ID
												GROUP BY 
													  T1.DIVISION_ID
													, T1.ITEM_ID
									
										   */										 
										 INNER JOIN	SCM_MST_SITE	   T3  WITH (NOLOCK)
												 ON	T1.DIVISION_ID = T3.DIVISION_ID
												AND	T1.SCM_SITE_ID = T3.SCM_SITE_ID							  
										 LEFT  JOIN SCM_MST_COUNTRY AS CO  WITH (NOLOCK)
												 ON T3.COUNTRY = CO.COUNTRY
							-- 소형인 경우에는 상품도 하나의 Grid에 다 보여야 함.
								   WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'H' END 
									  OR  T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'P' END
										 )
								 ) AS SITE_ITEM
							  ON SITE_PROJECT.DIVISION_ID  = SITE_ITEM.DIVISION_ID
							 AND SITE_PROJECT.SCM_SITE_ID  = SITE_ITEM.SCM_SITE_ID
							 AND SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
							 AND CASE 
										WHEN SITE_PROJECT.DIVISION_ID = '40' 
										THEN SITE_PROJECT.ITEM_ID 
										ELSE  SITE_ITEM.ITEM_ID 
								 END = SITE_ITEM.ITEM_ID
					   ---------------------------------------------------------------------------------
					   -- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
					   ---------------------------------------------------------------------------------
--					   LEFT  JOIN dbo.DM_MST_METAL_PRICE_RULE M WITH (NOLOCK)
--					  		   ON SITE_PROJECT.DIVISION_ID  = M.DIVISION_ID
--					  		  AND SITE_PROJECT.PROJECT_CODE = M.PROJECT_CODE
--					  		  AND SITE_PROJECT.SCM_SITE_ID  = M.SCM_SITE_ID
--					  		  AND SITE_ITEM.ITEM_ID	        = M.ITEM_ID
					   ---------------------------------------------------------------------------------
					   LEFT  JOIN SCM_MST_SITE_CUSTOMER AS SITE_CUST  WITH (NOLOCK)
							   ON SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
							  AND SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
							  AND SITE_CUST.REP_YN		  = 'Y'
							  /*  ilovu1, 2023.07.07
								  SCM_MST_SITE_CUSTOMER[사이트고객기본]; 아래는 고유 인덱스
										(UQ)*DIVISION_ID	(사업부ID)
										(UQ)*SCM_SITE_ID	(SCM사이트ID)
										(UQ)*SOLDTO_CODE	(판매처코드)
										(UQ)*SHIPTO_CODE	(인도처코드)

									SELECT SCM_SITE_ID
										 , DIVISION_ID
										 , count(*) cnt 
									  FROM SCM_MST_SITE_CUSTOMER
									 WHERE REP_YN = 'Y'
									 GROUP BY
										   SCM_SITE_ID
										 , DIVISION_ID
									having count(*) > 1;--0 rows returned
							  */
					   LEFT  JOIN SCM_MST_CUSTOMER AS CUST  WITH (NOLOCK)
							   ON SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
							  AND SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
							  AND SITE_CUST.DIVISION_ID = CUST.DIVISION_ID  
							/* SCM_MST_CUSTOMER[고객기본]
									#DIVISION_ID	(사업부ID)
									#SOLDTO_CODE	(판매처코드)
									#SHIPTO_CODE	(인도처코드)
							*/
					   LEFT  JOIN (SELECT DIVISION_ID
							    		, MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
							    		, SCM_SITE_ID
							    		, PROJECT_CODE
							    		, ITEM_ID
									 FROM DM_MST_CUSTOMER_MODEL  WITH (NOLOCK)
									WHERE VALID_YN = 'Y'
									GROUP BY 
										  DIVISION_ID
										, SCM_SITE_ID
										, PROJECT_CODE
										, ITEM_ID			
								  ) AS CUST_ITEM
							   ON SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
							  AND SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
							  AND SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
							  AND SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID	
							/* DM_MST_CUSTOMER_MODEL[고객모델기본]
									#DIVISION_ID			(사업부ID)
									#CUSTOMER_PROJECT_CODE	(고객프로젝트코드)
									#CUSTOMER_MODEL			(고객모델명)
									#SCM_SITE_ID			(SCM사이트ID)
							*/
		-------------------------- Model/Item --------2018/07/30  Son Young Suk------------------------
					   INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',')) b
							   ON CASE 
										WHEN @p_item_id = '' 
										THEN @p_item_id			
		           						ELSE SITE_ITEM.ITEM_ID  
								  END LIKE  b.tst 
							   OR CASE 
										WHEN @p_item_id = '' 
										THEN @p_item_id			
		           						ELSE SITE_ITEM.NICK_NAME  
								  END LIKE  b.tst 
		-----------------------------------------------------------------------------------------------
		------------  20180806  -------------------------------------------------------------------			
					   INNER JOIN (SELECT DISTINCT
										  X.OWNER
									 FROM SCM_MST_SITE_ITEM AS X
										  LEFT  JOIN SCM_MST_SSO_USER_INFO AS UI
												  ON X.PROJECT_CODE = UI.USER_ID
										   /* ilovu1, 2023.07.07
											  SCM_MST_SITE_ITEM[사이트품목기본]
												#DIVISION_ID	(사업부ID)
												#PROJECT_CODE	(프로젝트코드)
												#SCM_SITE_ID	(SCM사이트ID)
												#ITEM_ID		(품목ID)	   
										   */						             
										  INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) c
												  ON (CASE 
															WHEN @p_owner = '' 
															THEN @p_owner
															ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') 
													  END LIKE  c.tst 
												  OR  CASE 
															WHEN @p_owner = '' 
															THEN @p_owner
															ELSE X.OWNER 
													  END LIKE  c.tst 
												  OR  CASE 
															WHEN @p_owner = ''
															THEN @p_owner			
															ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') 
													  END LIKE  c.tst 
													 )
									WHERE X.DIVISION_ID = @p_division_id
									  AND @p_owner <> ''
									UNION ALL
								   SELECT '11'
									WHERE @p_owner = ''
								  ) X
							   ON ISNULL(SITE_ITEM.OWNER, 'xxxx') = CASE WHEN @p_owner = '' THEN ISNULL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner END	
		-----------------------------------------------------------------------------------------------
				 WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
				   AND CASE 
							WHEN @p_division_id = 'ALL' 
							THEN @p_division_id			
							ELSE SITE_PROJECT.DIVISION_ID
 					   END IN ( SELECT token FROM dbo.String_Split(@p_division_id,',') )
				   AND CASE 
							WHEN @p_dept_id = 'ALL' 
							THEN @p_dept_id			
							ELSE TEAM.DEPT_ID
 					   END IN ( SELECT token FROM dbo.String_Split(@p_dept_id,',') )		
				   AND CASE 
							WHEN @p_end_customer = 'ALL' 
							THEN @p_end_customer			
							ELSE SITE_ITEM.PROJECT_CODE
 					   END IN ( SELECT token FROM dbo.String_Split(@p_end_customer,',') )
				   AND CASE 
							WHEN @p_scm_site_id = 'ALL' 
							THEN @p_scm_site_id			
							ELSE SITE_ITEM.SCM_SITE_ID
 					   END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				   AND CASE 
							WHEN @p_project_code = '' 
							THEN @p_project_code			
							ELSE SITE_PROJECT.PROJECT_CODE
 					   END IN ( SELECT token FROM dbo.String_Split(@p_project_code,',') )
				   AND    SITE.SITE_TYPE <> 'PLANT'
			   ) T1
		 WHERE 1 = 1
		   AND CASE 
					WHEN @p_valid_yn = 'ALL' 
					THEN @p_valid_yn			
					ELSE T1.VALID_YN
 			   END  IN ( SELECT token FROM dbo.String_Split(@p_valid_yn,',') )
		   AND	(( 
					ISNULL(T1.ATTRIBUTE2,'') not IN (SELECT SEGMENT1
													  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
													 WHERE LOOKUP_TYPE= 'END_CUST_REPORT'
													   AND VALID_YN = 'Y' 
													) 
					AND @p_end_cust_report_yn =  'Y' 
				 )  
				 OR 
				 ( 
					1=1 AND @p_end_cust_report_yn = 'N'
				 )
				)
		 ORDER BY
			   DIVISION_ID
			 , TEAM_NAME_KO
			 , END_CUSTOMER
			 , END_CUSTOMER40
			 , SOLDTO_CODE 			   
			 , SHIPTO_CODE				   
			 , SCM_SITE_ID
			 , SCM_SITE_ID40
			 , PROJECT_CODE
			 , PROJECT_NAME
			 , PROJECT_STATUS
			 , PROJECT_OWNER
			 , SALES_PLAN_ADJUST_YN
			 , ITEM_TYPE
			 , ITEM_CLASS_NAME
			 , ITEM_ID
			 , ITEM_NAME
			 , CUSTOMER_MODEL
			 , SALES_COMPANY
			 , SALES_PLANT
			 , NICK_NAME
			 , BPMS_EXIST
			 , LIABILITY_PERIOD
			 --, CURRENCY
			 , REPORT_GROUP1
			 , REPORT_GROUP2
			 , REPORT_GROUP3
			 , REPORT_GROUP4
			 , REPORT_GROUP6
			 , REPORT_GROUP7
			 , REPORT_GROUP8;
	    SELECT S.*
			 , R.CELL_PROD_SITE						   --Cell 생산지
			 , M.BASE_PRICE                            --기준단가
			 , M.METAL_LINK_YN                         --메탈링크여부
			 , M.CURRENCY                              --통화코드
			 , M.METAL_LINK_PERIOD                     --메탈링크범위
			 , M.METAL_LINK_START_MONTH				   --동일값(Metal Index(Cur)) 기간 시작연월
			 , M.METAL_LINK_MTD                        --메탈링크방법
			 , CONVERT(DATETIME, M.START_YM + '01') START_YM--시작연월
			 , CONVERT(DATETIME, M.END_YM + '01') END_YM    --종료연월
			 , M.AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
			 , M.CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
			 , M.MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
			 , M.NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
			 , M.CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
			 , M.LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
			 , M.LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
			 , M.AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
			 , M.CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
			 , M.MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
			 , M.NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
			 , M.CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
			 , M.LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
			 , M.LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
			 , M.CNTRC_EXCHANGE_PRICE                  --계약시 환율
			 , M.AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
			 , M.CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
			 , M.MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
			 , M.NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
			 , M.CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
			 , M.LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
			 , M.LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
			 --, M.AL_STND_MARKET                        --기준시장Al
			 --, M.CU_STND_MARKET                        --기준시장Cu
			 --, M.MN_STND_MARKET                        --기준시장Mn
			 --, M.NI_STND_MARKET                        --기준시장Ni
			 --, M.CO_STND_MARKET                        --기준시장Co
			 --, M.LI2CO3_STND_MARKET                    --기준시장Li2Co3
			 --, M.LIOH_STND_MARKET                      --기준시장LiOH		     
		  FROM #SOURCE3 S
		       CROSS JOIN (
							SELECT SEGMENT1 CELL_PROD_SITE, ATTRIBUTE1 CELL_PROD_SITE_NM, DISPLAY_SEQ
							  FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL
							 WHERE LOOKUP_TYPE =   'DM_CELL_PROD_SITE'
							   AND SEGMENT1    IN ('A01', 'A02', 'Z01')
							 --order by
							 --	   DISPLAY_SEQ
						  ) R
			   LEFT  JOIN dbo.DM_MST_METAL_PRICE_RULE M WITH (NOLOCK)
					   ON S.DIVISION_ID    = M.DIVISION_ID
					  AND S.PROJECT_CODE   = M.PROJECT_CODE
					  AND S.SCM_SITE_ID    = M.SCM_SITE_ID
					  AND S.ITEM_ID	       = M.ITEM_ID
					  AND R.CELL_PROD_SITE = M.CELL_PROD_SITE
		 ORDER BY
			   S.DIVISION_ID
			 , S.TEAM_NAME_KO
			 , S.END_CUSTOMER
			 , S.END_CUSTOMER40
			 , S.SOLDTO_CODE 			   
			 , S.SHIPTO_CODE				   
			 , S.SCM_SITE_ID
			 , S.SCM_SITE_ID40
			 , S.PROJECT_CODE
			 , S.PROJECT_NAME
			 , S.PROJECT_STATUS
			 , S.PROJECT_OWNER
			 , S.SALES_PLAN_ADJUST_YN
			 , S.ITEM_TYPE
			 , S.ITEM_CLASS_NAME
			 , S.ITEM_ID
			 , S.ITEM_NAME
			 , S.CUSTOMER_MODEL
			 , S.SALES_COMPANY
			 , S.SALES_PLANT
			 , S.NICK_NAME
			 , S.BPMS_EXIST
			 , S.LIABILITY_PERIOD
			 --, M.CURRENCY
			 , S.REPORT_GROUP1
			 , S.REPORT_GROUP2
			 , S.REPORT_GROUP3
			 , S.REPORT_GROUP4
			 , S.REPORT_GROUP6
			 , S.REPORT_GROUP7
			 , S.REPORT_GROUP8
			 , R.DISPLAY_SEQ;
	END
	ELSE IF @p_division_id = '82'	--ESS
		SELECT *
			 , CASE 
					WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
					THEN 'Y' 
					ELSE 'N' 
			   END AS EDIT_FLAG
		  FROM (SELECT SITE_PROJECT.DIVISION_ID
				 		--DEPT.DEPT_ID,
						--DEPT.DEPT_NAME_KO,
					 , TEAM.DEPT_ID
					 , TEAM.DEPT_ID AS DEPT_ID2
					 , TEAM.DEPT_NAME_KO AS TEAM_NAME_KO
					 , SITE.END_CUSTOMER
					 , SITE.END_CUSTOMER AS END_CUSTOMER40
					 , SITE_CUST.SOLDTO_CODE
	     			 , CUST.SOLDTO_DESCRIPTION
					 , SITE_CUST.SHIPTO_CODE
					 , CUST.SHIPTO_DESCRIPTION
					 , SITE_PROJECT.SCM_SITE_ID
					 , SITE_PROJECT.SCM_SITE_ID AS SCM_SITE_ID40
					 , SITE_PROJECT.PROJECT_CODE
					 , PJT.PROJECT_NAME
					 , PJT.PROJECT_STATUS
					 , PJT.PROJECT_OWNER
					 , SITE_ITEM.OWNER AS USER_ID
					 , SITE_ITEM.SALES_PLAN_ADJUST_YN
					 , SITE_ITEM.ITEM_TYPE
					 , SITE_ITEM.ITEM_CLASS_NAME
					 , SITE_ITEM.ITEM_ID
					 , SITE_ITEM.ITEM_NAME
					 , SITE_ITEM.ATTRIBUTE10 AS CELL_TYPE_81
					 , SITE_ITEM.ATTRIBUTE10 AS CELL_TYPE_82
					 , SITE_ITEM.ATTRIBUTE8  AS KWH
					 , SITE_ITEM.CELL_PER_CAR
					 , SITE_ITEM.CELL_PER_MODULE
					 , SITE_ITEM.CELL_PER_CAR / SITE_ITEM.CELL_PER_MODULE AS MODULE_PER_CAR

					 , CUST_ITEM.CUSTOMER_MODEL
						   
					 
					 , SITE_ITEM.SALES_COMPANY
					 , SITE_ITEM.SALES_PLANT
				 
					 , SITE_ITEM.NICK_NAME
					 , SITE_ITEM.BPMS_EXIST
					 , SITE_ITEM.LIABILITY_PERIOD
					 --, SITE_ITEM.CURRENCY		--ilovu1: ESS 메탈 단가 기준(DM_MST_ESS_METAL_PRICE_RULE)의 CURRENCY와 충돌함.
					 , CASE 
							WHEN SITE_ITEM.ITEM_ID is null
							THEN ISNULL(SITE_PROJECT.VALID_YN,SITE_ITEM.VALID_YN) 
							ELSE SITE_ITEM.VALID_YN 
					   END AS VALID_YN
				 
					 , SITE_ITEM.LAST_UPDATE_DATE
					 , SITE_ITEM.LAST_UPDATED_BY
					 , SITE_ITEM.CUST_GROUP
					 , SITE_ITEM.CUST_GROUP_DTL
					 , dbo.FN_GET_MULTI_OWNER_NAME (SITE_ITEM.OWNER, ',', '1') AS OWNER
					 , SITE_ITEM.APPLICATION
					 , SITE_ITEM.ROUTE 
					 , SITE_ITEM.ATTRIBUTE6 AS EDI
					 , SITE_ITEM.EDI_LT  
					 , ISNULL(SITE_ITEM.VMI_LT, 0) AS VMI_LT
					 , SITE_ITEM.CELL_NAME 
					 , SITE_ITEM.PARTIAL_PLAN_YN 
					 , SITE_ITEM.ATTRIBUTE1  -- 양극재
					 , SITE_ITEM.ATTRIBUTE2 AS MODULE_VARIANT

					 ---------------------------------------------------------------------------------
					 -- ilovu1; 2023.08.10 ESS 메탈 단가 기준(DM_MST_ESS_METAL_PRICE_RULE) 추가함
					 ---------------------------------------------------------------------------------
					 , M.BASE_PRICE_PER_EA        --기준단가(/EA)
					 , M.METAL_LINK_YN            --메탈링크여부
					 , M.CURRENCY                 --통화코드
					 , M.METAL_LINK_PERIOD        --메탈링크범위
					 , M.METAL_LINK_START_MONTH	  --동일값(Metal Index(Cur)) 기간 시작연월
					 , M.METAL_LINK_MTD           --메탈링크방법
					 , M.CELL_NICK                --Cell Nick
					 , M.CELL_QTY                 --Cell Qty(/Biz Type)
					 , M.CAP_PCT                  --Cap Percentage                          
					 , CONVERT(DATETIME, M.START_YM + '01') START_YM--시작연월
					 , CONVERT(DATETIME, M.END_YM + '01') END_YM    --종료연월
					 , M.AL_USD_PER_KG            --메탈인덱스Al(USD/KG)
					 , M.CU_USD_PER_KG            --메탈인덱스Cu(USD/KG)
					 , M.MN_USD_PER_KG            --메탈인덱스Mn(USD/KG)
					 , M.NI_USD_PER_KG            --메탈인덱스Ni(USD/KG)
					 , M.CO_USD_PER_KG            --메탈인덱스Co(USD/KG)
					 , M.LI2CO3_USD_PER_KG        --메탈인덱스Li2Co3(USD/KG)
					 , M.LIOH_USD_PER_KG          --메탈인덱스LiOH(USD/KG)
					 , M.CNTRC_EXCHANGE_PRICE     --계약시 환율  
				  FROM (SELECT DISTINCT
							   A.DIVISION_ID
							 , SCM_SITE_ID
							 , PROJECT_CODE
							 , ISNULL(MAX(VALID_YN), 'Y') AS VALID_YN
						  FROM SCM_MST_SITE_ITEM A WITH (NOLOCK)
							   INNER JOIN SCM_MST_ITEM_SN B WITH (NOLOCK)
									   ON A.ITEM_ID = B.ITEM_ID 
							   LEFT  JOIN (SELECT SEGMENT1 AS SITE_ID , '1' AS NUM 
											 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)  
											WHERE LOOKUP_TYPE = 'GM_JV_SITE' 
											  AND VALID_YN	  = 'Y'
											UNION ALL 
											SELECT SCM_SITE_ID AS SITE_ID , '1' AS NUM 
											  FROM SCM_MST_SITE WITH (NOLOCK)  
											 WHERE DEPT_ID = @p_user_dept_id
										  ) AS C 
									   ON A.SCM_SITE_ID = C.SITE_ID
						 WHERE ISNULL(C.NUM,'') = CASE WHEN '81' = @p_division_id AND @p_userinfo = 'JV Planner' THEN 1 ELSE ISNULL(C.NUM,'') END
						   AND A.DIVISION_ID = @p_division_id
						 GROUP BY 
							   A.DIVISION_ID
							 , SCM_SITE_ID
							 , PROJECT_CODE	
					   ) AS SITE_PROJECT
					   LEFT  JOIN SCM_MST_PROJECT AS PJT  WITH (NOLOCK)
							   ON SITE_PROJECT.PROJECT_CODE = PJT.PROJECT_CODE
							  AND SITE_PROJECT.DIVISION_ID  = PJT.DIVISION_ID

					   LEFT  JOIN SCM_MST_SITE AS SITE  WITH (NOLOCK)
							   ON SITE_PROJECT.DIVISION_ID = SITE.DIVISION_ID  
							  AND SITE_PROJECT.SCM_SITE_ID = SITE.SCM_SITE_ID
					   LEFT  JOIN SCM_MST_SSO_DEPT_INFO AS TEAM WITH (NOLOCK)	       
							   ON SITE.DEPT_ID = TEAM.DEPT_ID
					   LEFT  JOIN (SELECT T1.DIVISION_ID
									    , T1.SCM_SITE_ID
									    , T1.PROJECT_CODE
									    , T1.ITEM_ID
									    , T1.CELL_PER_CAR
									    , T1.CELL_PER_MODULE
									    , T2.ITEM_NAME
									    , T2.ITEM_TYPE
									    , T2.ITEM_CLASS_NAME
									    , T1.SALES_PLAN_ADJUST_YN
									    , T2.NICK_NAME
									    , T1.BPMS_EXIST    
									    , T1.LIABILITY_PERIOD
									    , T1.CURRENCY
									    , T1.VALID_YN
									    , T1.LAST_UPDATE_DATE
									    , T1.LAST_UPDATED_BY	
										, T1.CUST_GROUP
										, T1.CUST_GROUP_DTL
										, T1.OWNER
										, T1.APPLICATION
										, T1.ROUTE 
										, T1.ATTRIBUTE6		
										, T1.EDI_LT		
										, T1.SCP_VMI_LT AS VMI_LT
										, T1.ATTRIBUTE9 AS CELL_NAME 							
										
										, T1.SALES_COMPANY
										, T1.SALES_PLANT
										, T1.PARTIAL_PLAN_YN 
										, T1.ATTRIBUTE10		
										, T1.ATTRIBUTE8		
										
										, ISNULL(T1.ATTRIBUTE1,'')  ATTRIBUTE1 -- 양극재
										, ISNULL(T1.ATTRIBUTE2,'')  ATTRIBUTE2
									FROM            SCM_MST_SITE_ITEM		T1  WITH (NOLOCK)
										 INNER JOIN DM_MST_ITEM_SINGLE_V	T2  WITH (NOLOCK)
										         ON T1.DIVISION_ID = T2.DIVISION_ID
										        AND T1.ITEM_ID     = T2.ITEM_ID
								  -- 20200422 KHSONG C20200422-000123 소형사업부와과 같이 상품도 하나의 Grid에 다 보이도록함
								   WHERE (T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'H' END
									  OR  T2.ITEM_TYPE = CASE WHEN T1.DIVISION_ID = '82' THEN T2.ITEM_TYPE ELSE 'P' END
										 )
								 ) AS SITE_ITEM
							  ON SITE_PROJECT.DIVISION_ID  = SITE_ITEM.DIVISION_ID
							 AND SITE_PROJECT.SCM_SITE_ID  = SITE_ITEM.SCM_SITE_ID
							 AND SITE_PROJECT.PROJECT_CODE = SITE_ITEM.PROJECT_CODE
					 ---------------------------------------------------------------------------------
					 -- ilovu1; 2023.08.10 ESS 메탈 단가 기준(DM_MST_ESS_METAL_PRICE_RULE) 추가함
					 ---------------------------------------------------------------------------------
					 LEFT  JOIN dbo.DM_MST_ESS_METAL_PRICE_RULE M WITH (NOLOCK)
							 ON SITE_PROJECT.DIVISION_ID    = M.DIVISION_ID
							AND SITE_PROJECT.PROJECT_CODE   = M.PROJECT_CODE
							AND SITE_PROJECT.SCM_SITE_ID    = M.SCM_SITE_ID
							AND SITE_ITEM.ITEM_ID			= M.ITEM_ID
					 ---------------------------------------------------------------------------------
					  LEFT  JOIN SCM_MST_SITE_CUSTOMER AS SITE_CUST  WITH (NOLOCK)
							  ON SITE_PROJECT.SCM_SITE_ID = SITE_CUST.SCM_SITE_ID
							 AND SITE_PROJECT.DIVISION_ID = SITE_CUST.DIVISION_ID
							 AND SITE_CUST.REP_YN      = 'Y'
					  LEFT  JOIN SCM_MST_CUSTOMER	   AS CUST  WITH (NOLOCK)
							  ON SITE_CUST.SOLDTO_CODE = CUST.SOLDTO_CODE
							 AND SITE_CUST.SHIPTO_CODE = CUST.SHIPTO_CODE
							 AND SITE_CUST.DIVISION_ID = CUST.DIVISION_ID
   
					  LEFT  JOIN (SELECT DIVISION_ID
									   , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
									   , SCM_SITE_ID
									   , PROJECT_CODE
									   , ITEM_ID
									FROM DM_MST_CUSTOMER_MODEL WITH (NOLOCK)
								   WHERE VALID_YN = 'Y'
								   GROUP BY 
								   		 DIVISION_ID
									   , SCM_SITE_ID
									   , PROJECT_CODE
									   , ITEM_ID			
								 ) AS CUST_ITEM
							  ON SITE_ITEM.ITEM_ID      = CUST_ITEM.ITEM_ID
							 AND SITE_ITEM.PROJECT_CODE = CUST_ITEM.PROJECT_CODE
							 AND SITE_ITEM.DIVISION_ID  = CUST_ITEM.DIVISION_ID
							 AND SITE_ITEM.SCM_SITE_ID  = CUST_ITEM.SCM_SITE_ID
	
					  LEFT  JOIN SCM_MST_SSO_USER_INFO SU			
							  ON SITE_ITEM.owner = SU.USER_ID
			
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
					  INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) b
							  ON CASE 
										WHEN @p_item_id = '' 
										THEN @p_item_id			
										ELSE SITE_ITEM.ITEM_ID  
								 END LIKE b.tst 
							  OR CASE 
										WHEN @p_item_id = '' 
										THEN @p_item_id			
										ELSE SITE_ITEM.NICK_NAME  
								 END LIKE b.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Project ---------------2018/07/30  Son Young Suk--------------------
					  INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
							  ON CASE
										WHEN @p_project_code = '' 
										THEN @p_project_code			
										ELSE PJT.PROJECT_CODE  
								 END LIKE b1.tst 
							  OR CASE 
										WHEN @p_project_code = '' 
										THEN @p_project_code			
										ELSE PJT.PROJECT_NAME  
								 END LIKE b1.tst 
				-----------------------------------------------------------------------------------------------
				------------  20180806  -------------------------------------------------------------------			
					  INNER JOIN (SELECT DISTINCT
										 X.OWNER
									FROM SCM_MST_SITE_ITEM AS X
										 LEFT  JOIN SCM_MST_SSO_USER_INFO AS UI
												 ON X.PROJECT_CODE = UI.USER_ID
										 INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) c
												 ON (CASE
															WHEN @p_owner = '' 
															THEN @p_owner			
															ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') 
													 END LIKE c.tst 
												 OR  CASE
															WHEN @p_owner = '' 
															THEN @p_owner			
															ELSE X.OWNER 
													 END LIKE c.tst 
												 OR  CASE
															WHEN @p_owner = '' 
															THEN @p_owner			
															ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') 
													 END LIKE c.tst 
													)
								   WHERE X.DIVISION_ID = @p_division_id
									 AND @p_owner <> ''
								   UNION ALL
								  SELECT '11'
								   WHERE @p_owner = ''
								 ) X
							  ON ISNULL(SITE_ITEM.OWNER,'xxxx') = CASE WHEN @p_owner = '' THEN ISNULL(SITE_ITEM.OWNER,'xxxx') ELSE X.owner END
				-----------------------------------------------------------------------------------------------
				 WHERE  1 = 1 -- R- RAW MATERIAL, H- HALF PRODUCT,  P- PRODUCT 제품만 조회함(RHP 모두 제품임).
				   AND CASE 
							WHEN @p_division_id = 'ALL'
							THEN @p_division_id			
							ELSE SITE_PROJECT.DIVISION_ID
 					   END IN (SELECT token FROM dbo.String_Split(@p_division_id,',') )
				   AND CASE 
							WHEN @p_dept_id = 'ALL' 
							THEN @p_dept_id			
							ELSE TEAM.DEPT_ID
 					   END IN (SELECT token FROM dbo.String_Split(@p_dept_id,',') )
				   AND CASE
							WHEN @p_end_customer = 'ALL' 
							THEN @p_end_customer			
							ELSE SITE.END_CUSTOMER
 					   END IN (SELECT token FROM dbo.String_Split(@p_end_customer,',') )
				   AND CASE
							WHEN @p_scm_site_id = 'ALL' 
							THEN @p_scm_site_id	
							ELSE SITE_PROJECT.SCM_SITE_ID
 					   END  IN (SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
				   AND SITE.SITE_TYPE <> 'PLANT'
			   ) T1
		 WHERE 1 = 1
		   AND CASE
					WHEN @p_valid_yn = 'ALL' 
					THEN @p_valid_yn			
					ELSE T1.VALID_YN
 			   END IN (SELECT token FROM dbo.String_Split(@p_valid_yn,',') )
		 ORDER BY 
			   DIVISION_ID
			 , TEAM_NAME_KO
			 , END_CUSTOMER
			 , END_CUSTOMER40
			 , SOLDTO_CODE			   
			 , SHIPTO_CODE			   
			 , SCM_SITE_ID
			 , SCM_SITE_ID40
			 , PROJECT_CODE
			 , PROJECT_NAME
			 , PROJECT_STATUS
			 , PROJECT_OWNER
			 , SALES_PLAN_ADJUST_YN
			 , ITEM_TYPE
			 , ITEM_CLASS_NAME
			 , ITEM_ID
			 , ITEM_NAME
			 , CELL_TYPE_81
			 , CELL_TYPE_82
			 , KWH				-- 셀용량 및 팩 당 용량 추가
			 , CUSTOMER_MODEL
			 , SALES_COMPANY
			 , SALES_PLANT
			 , NICK_NAME
			 , BPMS_EXIST
			 , LIABILITY_PERIOD
			 , CURRENCY;
	ELSE
	BEGIN
		CREATE TABLE #T_SINGLE (
			  DIVISION_ID		NVARCHAR(30) 
			, ITEM_ID			NVARCHAR(150) 
			, ITEM_NAME			NVARCHAR(150)
			, ITEM_TYPE			VARCHAR(1)
			, ITEM_CLASS_NAME	NVARCHAR(300)
			, NICK_NAME			NVARCHAR(50)
			);

		---------------------------------------------------------------------------------
		--      20230328 heesan91 속도개선
		---------------------------------------------------------------------------------
		CREATE TABLE #SCM_MST_SITE_ITEM (
			  DIVISION_ID		NVARCHAR(30)
			, SCM_SITE_ID		NVARCHAR(150)
			, PROJECT_CODE		NVARCHAR(150)
			, CNT				VARCHAR(5)			
			);

		INSERT 
		  INTO #T_SINGLE 
			 ( DIVISION_ID
			 , ITEM_ID
			 , ITEM_NAME
			 , ITEM_TYPE
			 , ITEM_CLASS_NAME
			 , NICK_NAME 
			 )
		SELECT T1.DIVISION_ID
			 , T1.ITEM_ID
			 , MAX(T1.ITEM_NAME)			AS ITEM_NAME
			 , CASE  MIN( CASE 
							  WHEN T1.item_type = 'P' THEN 1	
							  WHEN T1.item_type = 'H' THEN 2	
							  WHEN T1.item_type = 'Q' THEN 3
							  ELSE 4 
						  END
						)  
					WHEN 1 THEN 'P' 
					WHEN 2 THEN 'H'
					WHEN 3 THEN 'Q'
					ELSE 'R' 
			   END							AS ITEM_TYPE
			 , MAX(T1.ITEM_CLASS_NAME)		AS ITEM_CLASS_NAME
			 , MAX(T1.NICK_NAME)			AS NICK_NAME
		  FROM SCM_MST_ITEM_SN T1 WITH (NOLOCK)
		  /* ilovu1, 2023.07.07
			 SCM_MST_ITEM_SN = [LGCE_FP_TR_QA].[DBO].[SCM_ITEM_M][품목기본]
				#COMPANY_ID		(회사코드)
				#DIVISION_ID	(사업부코드)
				#SITE_ID		(지역코드)
				#ITEM_ID		(제품코드)
		  */
		 WHERE 1=1
		   AND T1.DIVISION_ID = @P_DIVISION_ID
		   AND T1.ITEM_TYPE IN ( 'H', 'P' )
		 GROUP BY 
			   T1.DIVISION_ID
			 , T1.ITEM_ID;

		INSERT 
		  INTO #SCM_MST_SITE_ITEM 
			 ( DIVISION_ID
			 , SCM_SITE_ID
			 , PROJECT_CODE
			 , CNT
			 )
		SELECT 
			   A.DIVISION_ID
			 , A.SCM_SITE_ID
			 , A.PROJECT_CODE
			 , sum(CASE 
						WHEN B.ITEM_TYPE IN ( 'H', 'P' ) 
						THEN 1 
						ELSE 0 
				   END 
				  )
		  FROM SCM_MST_SITE_ITEM A
			   LEFT JOIN #T_SINGLE B 
					  ON A.DIVISION_ID = B.DIVISION_ID 
					 AND A.ITEM_ID     = B.ITEM_ID
			   /* ilovu1, 2023.07.07
				  SCM_MST_SITE_ITEM[사이트품목기본]
					#DIVISION_ID	(사업부ID)
					#PROJECT_CODE	(프로젝트코드)
					#SCM_SITE_ID	(SCM사이트ID)
					#ITEM_ID		(품목ID)	   
			   */
		 WHERE A.DIVISION_ID = @P_DIVISION_ID
		 GROUP BY 
			   A.DIVISION_ID
			 , A.SCM_SITE_ID
			 , A.PROJECT_CODE;

		SELECT A.DIVISION_ID							--Div*
			 , B.DEPT_ID								--Team
			 , B.DEPT_ID		AS DEPT_ID2				--Team
			 , C.DEPT_NAME_KO	AS TEAM_NAME_KO
			 , B.END_CUSTOMER							--End Customer
			 , B.END_CUSTOMER	AS END_CUSTOMER40		--End Customer
			 , D.SOLDTO_CODE							--Sold-To
			 , E.SOLDTO_DESCRIPTION						--Sold-To
			 , D.SHIPTO_CODE							--Rep Ship-To
			 , E.SHIPTO_DESCRIPTION						--Rep Ship-To
			 , A.SCM_SITE_ID							--Sales Site*
			 , A.SCM_SITE_ID	AS SCM_SITE_ID40		--Sales Site*
			 , A.PROJECT_CODE							--Project Code*
			 , F.PROJECT_NAME							--Project
			 , F.PROJECT_STATUS							--Project Status
			 , F.PROJECT_OWNER
			 , A.OWNER			AS USER_ID
			 , A.SALES_PLAN_ADJUST_YN
			 , G.ITEM_TYPE								--Item Type
			 , G.ITEM_CLASS_NAME						--Model Type
			 , A.ITEM_ID								--Model
			 , G.ITEM_NAME								--Model Name
			 , A.ATTRIBUTE10	AS CELL_TYPE_81
			 , A.ATTRIBUTE10	AS CELL_TYPE_82
			 , A.ATTRIBUTE8		AS KWH
			 , A.CELL_PER_CAR
			 , A.CELL_PER_MODULE
			 , CASE	--ilovu1:2023.07.17 A.CELL_PER_MODULE = 0 예외처리
				   WHEN A.CELL_PER_MODULE = 0 
				   THEN null
				   ELSE A.CELL_PER_CAR / A.CELL_PER_MODULE 
			   END AS MODULE_PER_CAR
			 , H.CUSTOMER_MODEL
			 , A.SALES_COMPANY
			 , A.SALES_PLANT							--Sales Plant*
			 , G.NICK_NAME								--Nick Name
			 , A.BPMS_EXIST
			 , A.LIABILITY_PERIOD
			 --, A.CURRENCY								--ilovu1 주석처리
			 , A.VALID_YN
			 , A.LAST_UPDATE_DATE
			 , A.LAST_UPDATED_BY
			 , A.CUST_GROUP
			 , A.CUST_GROUP_DTL
			 , dbo.FN_GET_MULTI_OWNER_NAME (A.OWNER, ',', '1') AS OWNER
			 , A.APPLICATION
			 , A.ROUTE
			 , A.ATTRIBUTE6 AS EDI
			 , A.EDI_LT
			 , ISNULL(A.SCP_VMI_LT, 0) AS VMI_LT
			 , A.ATTRIBUTE9 AS CELL_NAME
			 , A.PARTIAL_PLAN_YN
			 , A.ATTRIBUTE1 AS CATHODE_MATERIALS
			 , A.ATTRIBUTE2 AS MODULE_VARIANT
			 , CASE 
					WHEN (([dbo].[FN_GET_DEPT_LIST](@p_created_by, B.DEPT_ID) = 'Y') OR @v_group_id ='ADMIN') 
		 			THEN 'Y' 
					ELSE 'N' 
			   END AS EDIT_FLAG

		     ---------------------------------------------------------------------------------
			 -- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
			 ---------------------------------------------------------------------------------
			 , M.BASE_PRICE                            --기준단가
			 , M.METAL_LINK_YN                         --메탈링크여부
			 , M.CURRENCY                              --통화코드
			 , M.METAL_LINK_PERIOD                     --메탈링크범위
			 , M.METAL_LINK_START_MONTH				   --동일값(Metal Index(Cur)) 기간 시작연월
			 , M.METAL_LINK_MTD                        --메탈링크방법
			 , CONVERT(DATETIME, M.START_YM + '01') START_YM--시작연월
			 , CONVERT(DATETIME, M.END_YM + '01') END_YM    --종료연월
			 , M.AL_KG_PER_BIZ_TYPE                    --메탈인덱스Al(KG/BizType)
			 , M.CU_KG_PER_BIZ_TYPE                    --메탈인덱스Cu(KG/BizType)
			 , M.MN_KG_PER_BIZ_TYPE                    --메탈인덱스Mn(KG/BizType)
			 , M.NI_KG_PER_BIZ_TYPE                    --메탈인덱스Ni(KG/BizType)
			 , M.CO_KG_PER_BIZ_TYPE                    --메탈인덱스Co(KG/BizType)
			 , M.LI2CO3_KG_PER_BIZ_TYPE                --메탈인덱스Li2Co3(KG/BizType)
			 , M.LIOH_KG_PER_BIZ_TYPE                  --메탈인덱스LiOH(KG/BizType)
			 , M.AL_USD_PER_KG                         --메탈인덱스Al(USD/KG)
			 , M.CU_USD_PER_KG                         --메탈인덱스Cu(USD/KG)
			 , M.MN_USD_PER_KG                         --메탈인덱스Mn(USD/KG)
			 , M.NI_USD_PER_KG                         --메탈인덱스Ni(USD/KG)
			 , M.CO_USD_PER_KG                         --메탈인덱스Co(USD/KG)
			 , M.LI2CO3_USD_PER_KG                     --메탈인덱스Li2Co3(USD/KG)
			 , M.LIOH_USD_PER_KG                       --메탈인덱스LiOH(USD/KG)
			 , M.CNTRC_EXCHANGE_PRICE                  --계약시 환율
			 , M.AL_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Al
			 , M.CU_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Cu
			 , M.MN_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Mn
			 , M.NI_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Ni
			 , M.CO_MIX_METAL_LINK_PERIOD              --MIX메탈링크범위Co
			 , M.LI2CO3_MIX_METAL_LINK_PERIOD          --MIX메탈링크범위Li2Co3
			 , M.LIOH_MIX_METAL_LINK_PERIOD            --MIX메탈링크범위LiOH
			 --, M.AL_STND_MARKET                        --기준시장Al
			 --, M.CU_STND_MARKET                        --기준시장Cu
			 --, M.MN_STND_MARKET                        --기준시장Mn
			 --, M.NI_STND_MARKET                        --기준시장Ni
			 --, M.CO_STND_MARKET                        --기준시장Co
			 --, M.LI2CO3_STND_MARKET                    --기준시장Li2Co3
			 --, M.LIOH_STND_MARKET                      --기준시장LiOH
			 ---------------------------------------------------------------------------------
		FROM	        SCM_MST_SITE_ITEM A WITH (NOLOCK)
		     ---------------------------------------------------------------------------------
			 -- ilovu1; 2023.07.17 메탈 단가 기준(DM_MST_METAL_PRICE_RULE) 추가함
			 ---------------------------------------------------------------------------------
		     LEFT  JOIN dbo.DM_MST_METAL_PRICE_RULE M WITH (NOLOCK)
			         ON A.DIVISION_ID  = M.DIVISION_ID
					AND A.PROJECT_CODE = M.PROJECT_CODE
					AND A.SCM_SITE_ID  = M.SCM_SITE_ID
					AND A.ITEM_ID	   = M.ITEM_ID
			 ---------------------------------------------------------------------------------
			 INNER JOIN SCM_MST_SITE B WITH (NOLOCK) 
			         ON A.DIVISION_ID = B.DIVISION_ID 
			        AND A.SCM_SITE_ID = B.SCM_SITE_ID
			 INNER JOIN #SCM_MST_SITE_ITEM B2 
			         ON A.DIVISION_ID  = B2.DIVISION_ID 
			        AND A.SCM_SITE_ID	 = B2.SCM_SITE_ID 
			        AND A.PROJECT_CODE = B2.PROJECT_CODE --20230328 속도개선
			 LEFT  JOIN SCM_MST_SSO_DEPT_INFO C WITH (NOLOCK) 
					 ON B.DEPT_ID = C.DEPT_ID
			 LEFT  JOIN SCM_MST_SITE_CUSTOMER D WITH (NOLOCK)
					 ON B.DIVISION_ID = D.DIVISION_ID 
					AND B.SCM_SITE_ID = D.SCM_SITE_ID 
					AND D.REP_YN      = 'Y'
				/*  ilovu1, 2023.07.07
					SCM_MST_SITE_CUSTOMER[사이트고객기본]; 아래는 고유 인덱스
						(UQ)*DIVISION_ID	(사업부ID)
						(UQ)*SCM_SITE_ID	(SCM사이트ID)
						(UQ)*SOLDTO_CODE	(판매처코드)
						(UQ)*SHIPTO_CODE	(인도처코드)

					SELECT SCM_SITE_ID
						 , DIVISION_ID
						 , count(*) cnt 
					  FROM SCM_MST_SITE_CUSTOMER
					 WHERE REP_YN = 'Y'
					 GROUP BY
					 	   SCM_SITE_ID
					 	 , DIVISION_ID
					having count(*) > 1;--0 rows returned
				*/
			 LEFT  JOIN SCM_MST_CUSTOMER E WITH (NOLOCK)
					 ON D.DIVISION_ID = E.DIVISION_ID 
					AND D.SOLDTO_CODE = E.SOLDTO_CODE 
					AND D.SHIPTO_CODE = E.SHIPTO_CODE 
				/* SCM_MST_CUSTOMER[고객기본]
						#DIVISION_ID	(사업부ID)
						#SOLDTO_CODE	(판매처코드)
						#SHIPTO_CODE	(인도처코드)
				*/
			 LEFT  JOIN SCM_MST_PROJECT F WITH (NOLOCK)
					 ON A.DIVISION_ID  = F.DIVISION_ID 
					AND A.PROJECT_CODE = F.PROJECT_CODE
				/* ilovu1, 2023.07.07
					SCM_MST_PROJECT[프로젝트기본]
					#DIVISION_ID		(사업부ID)
					#PROJECT_CODE		(프로젝트코드)
					#PROJECT_VER_SEQ	(프로젝트버전순번)

					SELECT DIVISION_ID				--(사업부ID)
					  	 , PROJECT_CODE				--(프로젝트코드)
					  	 , count(*) cnt
					  FROM SCM_MST_PROJECT
					 GROUP BY
					  	   DIVISION_ID				--(사업부ID)
					  	 , PROJECT_CODE				--(프로젝트코드)
					having count(*) > 1
					;--O rows returned
				*/
			 LEFT  JOIN #T_SINGLE G WITH (NOLOCK)
					 ON A.DIVISION_ID = G.DIVISION_ID 
					AND A.ITEM_ID     = G.ITEM_ID
			 LEFT  JOIN (SELECT DIVISION_ID
							  , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
							  , SCM_SITE_ID
							  , PROJECT_CODE
							  , ITEM_ID
						   FROM DM_MST_CUSTOMER_MODEL  WITH (NOLOCK)
						  WHERE VALID_YN = 'Y'
						    AND DIVISION_ID = @P_DIVISION_ID
						  GROUP BY 
						  	    DIVISION_ID 
						  	  , SCM_SITE_ID
						  	  , PROJECT_CODE
						  	  , ITEM_ID			
						) AS H
					 ON A.ITEM_ID      = H.ITEM_ID
					AND A.PROJECT_CODE = H.PROJECT_CODE
					AND A.DIVISION_ID  = H.DIVISION_ID
					AND A.SCM_SITE_ID  = H.SCM_SITE_ID
				-------------------------- Model/Item -------------2018/07/30  Son Young Suk-------------------
			 INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_item_id,',') ) X1
					 ON CASE 
							WHEN @p_item_id = '' 
							THEN @p_item_id			
							ELSE A.ITEM_ID  
						END LIKE X1.tst 
					 OR CASE 
							WHEN @p_item_id = '' 
							THEN @p_item_id			
							ELSE ISNULL(G.NICK_NAME,'')  
						END LIKE X1.tst 
				-----------------------------------------------------------------------------------------------
				-------------------------- Project ---------------2018/07/30  Son Young Suk--------------------
			 INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_project_code,',') ) b1
					 ON CASE 
							WHEN @p_project_code = '' 
							THEN @p_project_code			
							ELSE A.PROJECT_CODE 
						END LIKE b1.tst 
					 OR CASE 
							WHEN @p_project_code = '' 
							THEN @p_project_code			
							ELSE ISNULL(F.PROJECT_NAME, '')  
						END LIKE b1.tst 
				-----------------------------------------------------------------------------------------------
			 INNER JOIN (SELECT DISTINCT 
								X.OWNER			        
							FROM SCM_MST_SITE_ITEM AS X
								 LEFT  JOIN SCM_MST_SSO_USER_INFO AS UI
										 ON X.PROJECT_CODE = UI.USER_ID
								 INNER JOIN (SELECT '%'+token+'%' tst FROM dbo.String_Split(@p_owner,',') ) c
										 ON (CASE 
													WHEN @p_owner = '' 
													THEN @p_owner												
													ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](x.OWNER, ',', '1') 
											 END LIKE c.tst 
										 OR
											 CASE 
													WHEN @p_owner = '' 
													THEN @p_owner			
													ELSE X.OWNER 
											 END LIKE c.tst 
										 OR
											 CASE 
													WHEN @p_owner = '' 
													THEN @p_owner			
													ELSE [dbo].[FN_GET_MULTI_OWNER_NAME](X.OWNER, ',', '2') 
											 END LIKE c.tst 
										)
							 WHERE X.DIVISION_ID = @p_division_id
							   AND @p_owner <> ''
							 UNION ALL
							SELECT '11'
							 WHERE @p_owner = ''
						) X
					 ON ISNULL(A.OWNER,'xxxx') = CASE WHEN @p_owner = '' THEN  ISNULL(A.OWNER,'xxxx') ELSE X.owner END			
		WHERE A.DIVISION_ID = @P_DIVISION_ID
		  -- H,P 가 없는 프로젝트도 한 줄은 나오도록 한다.
		  AND ( G.ITEM_TYPE IN ( 'H', 'P' ) OR B2.CNT = 0 )		
		  AND CASE 
					WHEN @p_division_id = 'ALL' 
					THEN @p_division_id			
					ELSE A.DIVISION_ID
 			  END IN ( SELECT token FROM dbo.String_Split(@p_division_id,',') )
		  AND CASE 
					WHEN @p_dept_id = 'ALL' 
					THEN @p_dept_id			
					ELSE B.DEPT_ID
 			  END IN ( SELECT token FROM dbo.String_Split(@p_dept_id,',') )
		  AND CASE 
					WHEN @p_end_customer = 'ALL' 
					THEN @p_end_customer			
					ELSE B.END_CUSTOMER
 			  END IN ( SELECT token FROM dbo.String_Split(@p_end_customer,',') )
		  AND CASE 
					WHEN @p_scm_site_id = 'ALL' 
					THEN @p_scm_site_id			
					ELSE A.SCM_SITE_ID
 			  END IN ( SELECT token FROM dbo.String_Split(@p_scm_site_id,',') )
		  AND B.SITE_TYPE <> 'PLANT'
		  AND CASE 
					WHEN @p_valid_yn = 'ALL' 
					THEN @p_valid_yn			
					ELSE A.VALID_YN
 			  END IN ( SELECT token FROM dbo.String_Split(@p_valid_yn,',') )
		ORDER BY 
			  DIVISION_ID
			, TEAM_NAME_KO
			, END_CUSTOMER
			, END_CUSTOMER40
			, SOLDTO_CODE    			   
			, SHIPTO_CODE			   
			, SCM_SITE_ID
			, SCM_SITE_ID40
			, PROJECT_CODE
			, PROJECT_NAME
			, PROJECT_STATUS
			, PROJECT_OWNER 
			, SALES_PLAN_ADJUST_YN
			, ITEM_TYPE
			, ITEM_CLASS_NAME
			, ITEM_ID
			, ITEM_NAME
			, CELL_TYPE_81	
			, CELL_TYPE_82	
			, KWH
			, CUSTOMER_MODEL
			, SALES_COMPANY
			, SALES_PLANT
			, NICK_NAME
			, BPMS_EXIST
			, LIABILITY_PERIOD
			, CURRENCY;
	END
END;
