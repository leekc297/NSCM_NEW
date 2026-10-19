

/* =============================================================================  
프로그램ID : UP_FX_GetCommonDataList_FP  
업  무  명 : 공통 코드성 조회  
프로그램명 : 공통 코드성 조회  
최초작성일 : 2018.07.05  
최종작성일 : 2018.07.05  
개  발  자 : ygkim  
입  력  값 :   
출  력  값 :   
================================================================================  
   Date       In Charge      Description  
================================================================================  
 2018/07/05   ygkim         Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트  
============================================================================= */  
  
CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList_FP]  
   @Code NVARCHAR(100)  
 , @Param1 NVARCHAR(100)  
 , @Param2 NVARCHAR(100)  
 , @Param3 NVARCHAR(MAX)  --split 사용 변수
 , @Param4 NVARCHAR(MAX)  --split 사용 변수
 , @Param5 NVARCHAR(MAX)  --split 사용 변수
 , @Param6 NVARCHAR(MAX)=NULL  --split 사용 변수
 , @TimeZone NVARCHAR(MAX) = 'AS054'  

AS  
  
BEGIN  
 SET NOCOUNT ON;  
 SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;  
      
 /*===============================================  
 용   도:  DIVISION  조회  
 사 용 화 면:  Plan 결과 조회화면  - 조회조건  
 변       수:  Param1 = GroupID, Param2 = UserID  
 최 초 작 성:  2018. 07. 05  
 개  발  자 :  정병훈  
 최 종 작 성:  2018. 07. 05  
 수  정  자 :  정병훈  
 수 정 사 항:    
 ===============================================*/  
  
 IF (@Code = 'MyDivisionInEE' )  
	 BEGIN  
		  SELECT DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME   
			FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)  
		   WHERE DIVISION_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')  
		   GROUP BY DIVISION_ID   
		   ORDER BY DIVISION_ID  
	 END   
  
 /*===============================================  
 용   도:  PSI From Site 조회  
 사 용 화 면:  Plan 결과 조회화면  - 조회조건  
 변       수:  Param1 = DIVISION_ID , Param2 = OPERATION_GROUP  
 최 초 작 성:  2018. 07. 05  
 개  발  자 :  김용현  
 최 종 작 성:  2018. 07. 05  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'FromSite_PSI' )  
	 BEGIN  
			SELECT  
				A.FROM_SITE AS CODE ,  
				CASE WHEN B.SITE_DESCRIPTION IS NULL  THEN A.FROM_SITE   
				WHEN B.SITE_DESCRIPTION IS NOT NULL THEN B.SITE_DESCRIPTION   
				END AS NAME  
			FROM (  
				SELECT distinct SEGMENT3 FROM_SITE
				FROM SCM_ADM_LOOKUP_MASTER_DETAIL
				WHERE LOOKUP_TYPE = 'EE_PSI_PRODUCTION'
					AND SEGMENT1 = 'SCP'
					AND SEGMENT2 = @PARAM2
					AND VALID_YN = 'Y'
			)  A  
			LEFT OUTER JOIN SCM_MST_SITE B ON A.FROM_SITE = B.SCM_SITE_ID   
			ORDER BY CODE  
	 END   

/*===============================================
	용		 도:  SSP16LocBodTotal
	사 용 화 면:  SSP0016 - Shipment Request(Small)에서 사용
	변       수:  @PARAM1 = division_id, @PARAM2 = from_site
	최 초 작 성:  2019. 03. 13
	개  발  자 :  YWHOON
	최 종 작 성:  2019. 03. 13
	수  정  자 :  
	수 정 사 항:  
	===============================================*/
ELSE IF @Code = 'SSP16LocBodTotal'
	BEGIN	
		SELECT TRANSPORT_MODE+':'+BOD_ID+':'+convert(nvarchar,ROUTE_ID)+':'+convert(nvarchar,LT_TOTAL) AS CODE
				, TRANSPORT_MODE NAME
		FROM   SCP_MST_BOD_V
		WHERE  DIVISION_ID = @Param1
		AND    FROM_SITE   = @Param2
	END

/*===============================================  
 용   도:  Instance 조회  
 사 용 화 면:  Plan 결과 조회화면  - 조회조건  
 변       수:  Param1 = USER_ID
 최 초 작 성:  2019. 03. 20  
 개  발  자 :  yschoi  
 최 종 작 성:  2019. 03. 20  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'INSTANCE' )  
	 BEGIN  
			SELECT 	A.INSTANCE_ID AS CODE, B.SEGMENT2 AS NAME, B.SORT_ORDER										
			FROM 	(										
							SELECT 	C.INSTANCE_ID										
							FROM   	TH_UIS_USER_FACTORY_RELATE_SN A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE_SN B WITH(NOLOCK), FP_INSTANCE_FACTORY_M_SN C WITH(NOLOCK)
							WHERE 	A.USER_ID		= @Param1								
							AND    	A	.ROLE_ID		= B.ROLE_ID										
							AND    	B.FACTORY_ID	= C.FACTORY_ID										
							AND    	A.USE_AT_FLAG	= 'Y'										
							AND    	B.USE_AT_FLAG	= 'Y'										
							AND    	C.ACTIVE_FLAG	= 'Y'										
							GROUP BY C.INSTANCE_ID										
	 					) A
	 					, SCM_SYS_LOOKUP_VALUE_SN B WITH(NOLOCK)										
			WHERE 	A.INSTANCE_ID = B.SEGMENT1										
			AND   	B.LOOKUP_TYPE_CODE = 'INSTANCE_ID'										
			ORDER BY B.SORT_ORDER
	 END  

/*===============================================  
 용   도:  Plan Id 조회  
 사 용 화 면:  
 변       수:  Param1 = Instance_Id  Param2 = Plan_Date  Param3 = Plan_Type  Param4 = USER_ID
 최 초 작 성:  2019. 03. 20  
 개  발  자 :  yschoi  
 최 종 작 성:  2019. 03. 20  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'PLAN_ID' )  
	 BEGIN  
			SELECT	A.PLAN_ID AS CODE, PLAN_ID AS NAME										
						,A.PLAN_ID										
						,A.PLAN_TYPE										
						,A.PLAN_START_TIME										
						,A.PLAN_HORIZON										
						,A.PLAN_HORIZON_UOM										
						,A.DEMAND_HORIZON										
						,A.DEMAND_HORIZON_UOM										
						,A.CONFIG_SET_ID										
						,A.BASIS_PLAN_ID										
						,A.DEMAND_PLAN_ID										
						,A.SCP_PLAN_ID										
						,A.PLAN_WEEK										
						,CONVERT(VARCHAR(8), A.PLAN_START_TIME, 112) AS PLAN_START_DATE										
						,CONVERT(VARCHAR(8), DATEADD(DAY, A.PLAN_HORIZON-1, A.PLAN_START_TIME), 112) AS PLAN_END_DATE										
						,A.INSTANCE_ID										
			FROM	SCM_FP_PLAN_H_SN A WITH(NOLOCK)										
					, (										
							SELECT C.INSTANCE_ID										
							FROM   TH_UIS_USER_FACTORY_RELATE_SN A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE_SN B WITH(NOLOCK), FP_INSTANCE_FACTORY_M_SN C WITH(NOLOCK)									
							WHERE  A.USER_ID = @Param4									
							AND    A.ROLE_ID = B.ROLE_ID										
							AND    B.FACTORY_ID = C.FACTORY_ID										
							AND    A.USE_AT_FLAG = 'Y'										
							AND    B.USE_AT_FLAG = 'Y'										
							AND    C.ACTIVE_FLAG = 'Y'										
							GROUP BY C.INSTANCE_ID										
					) B										
			WHERE  A.INSTANCE_ID = B.INSTANCE_ID										
			AND    A.INSTANCE_ID = @Param1									
			AND    A.PLAN_TYPE   = @Param3							
			AND    CONVERT(VARCHAR(8), PLAN_START_TIME, 112) = @Param2									
			ORDER BY CONVERT(VARCHAR,A.PLAN_START_TIME,112) DESC, A.PLAN_ID DESC
	 END  



/*===============================================  
 용   도:  Factory 조회  
 사 용 화 면:  
 변       수:  Param1 = Instance_Id  Param2 = Division_List  Param3 = Plant_List Param4 = USER_ID
 최 초 작 성:  2019. 03. 20  
 개  발  자 :  yschoi  
 최 종 작 성:  2019. 03. 20  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'FACTORY' )  
	 BEGIN  
				SELECT A.FACTORY_ID AS CODE, '(' + A.FACTORY_ID + ')' + ISNULL(A.FACTORY_NAME, A.FACTORY_ID) AS NAME										
				FROM SCM_FACTORY_M_SN A WITH(NOLOCK)										
						, (										
							SELECT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID										
							FROM   TH_UIS_USER_FACTORY_RELATE_SN A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE_SN B WITH(NOLOCK)										
							WHERE  A.USER_ID = @Param4									
							AND    A.ROLE_ID = B.ROLE_ID										
							AND    A.USE_AT_FLAG = 'Y'										
							AND    B.USE_AT_FLAG = 'Y'										
							GROUP BY B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID										
						) AA										
				WHERE A.COMPANY_ID=AA.COMPANY_ID										
				AND   A.DIVISION_ID=AA.DIVISION_ID										
				AND   A.SITE_ID=AA.SITE_ID										
				AND   A.PLANT_ID=AA.PLANT_ID										
				AND   A.FACTORY_ID=AA.FACTORY_ID										
				AND	 A.ACTIVE_FLAG = 'Y'										
				AND EXISTS (										
									SELECT 1 FROM (										
															SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID										
															FROM   SCM_FACTORY_M_SN A WITH(NOLOCK)										
															INNER JOIN FP_INSTANCE_FACTORY_M_SN B WITH(NOLOCK)										
															ON    A.FACTORY_ID=B.FACTORY_ID										
															AND	B.ACTIVE_FLAG = 'Y'								
															WHERE 1=1										
															AND	A.ACTIVE_FLAG = 'Y'								
															AND	B.INSTANCE_ID = @Param1						
									) C										
									WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID										
								)
				AND	( ( @Param2 IS NULL OR @Param2 = '' ) OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param2,',') ) )
				AND	( ( @Param3 IS NULL OR @Param3 = '' ) OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param3,',') ) )								
				GROUP BY A.FACTORY_ID, A.FACTORY_NAME										
				ORDER BY A.FACTORY_ID	
	 END


/*===============================================  
 용   도:  Operation 조회  
 사 용 화 면:  
 변       수:  Param1 = Instance_Id  Param2 = Division_List  Param3 = Plant_List Param4 = Factory_List Param5 = USER_ID
 최 초 작 성:  2019. 03. 20  
 개  발  자 :  yschoi  
 최 종 작 성:  2019. 03. 20  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'OPERATION' )  
	 BEGIN  
				SELECT OPERATION_ID AS CODE, '('+OPERATION_ID+')'+ISNULL(OPERATION_NAME, OPERATION_ID) AS NAME										
				FROM SCM_OPERATION_M_SN A WITH(NOLOCK)
						, (										
							SELECT B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID										
							FROM TH_UIS_USER_FACTORY_RELATE_SN A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE_SN B WITH(NOLOCK)							
							WHERE A.USER_ID = @Param5						
							AND   A.ROLE_ID = B.ROLE_ID							
							AND   A.USE_AT_FLAG = 'Y'							
							AND   B.USE_AT_FLAG = 'Y'							
							GROUP BY B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID							
						) AA							
				WHERE (
							(										
								EXISTS (	
											SELECT 1 
											FROM SCM_MMD_OPERATION_GROUP_M_SN B WITH(NOLOCK) 
											WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE='P'
										)										
										AND MES_ERP_INTERFACE_FLAG='Y'										
							) OR										
							(										
								NOT EXISTS (
													SELECT 1 FROM SCM_MMD_OPERATION_GROUP_M_SN B WITH(NOLOCK) 
													WHERE B.OPERATION_GROUP_ID=A.OPERATION_GROUP_ID AND B.ROUTE_TYPE='P'
												)										
							)
						)										
				AND EXISTS (
									SELECT 1 FROM SCM_LINE_M_SN C WITH(NOLOCK)										
									WHERE C.COMPANY_ID=A.COMPANY_ID 										
									AND   C.DIVISION_ID=A.DIVISION_ID 										
									AND   C.SITE_ID=A.SITE_ID 										
									AND   C.OPERATION_ID=A.OPERATION_ID
									AND	( ( @Param2 IS NULL OR @Param2 = '' ) OR C.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param2,',') ) )
									AND	( ( @Param3 IS NULL OR @Param3 = '' ) OR C.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param3,',') ) ) 										
									AND	( ( @Param4 IS NULL OR @Param4 = '' ) OR C.FACTORY_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',') ) )
								)										
				AND A.COMPANY_ID=AA.COMPANY_ID										
				AND A.DIVISION_ID=AA.DIVISION_ID										
				AND A.SITE_ID=AA.SITE_ID										
				AND EXISTS (
									SELECT 1 FROM (
															SELECT DISTINCT B.INSTANCE_TYPE										
                  											FROM SCM_FACTORY_M_SN A WITH(NOLOCK)			
                  											INNER JOIN FP_INSTANCE_FACTORY_M_SN B WITH(NOLOCK)			
                  											ON  A.FACTORY_ID=B.FACTORY_ID			
                  											AND B.ACTIVE_FLAG = 'Y'			
                  											WHERE 1=1			
                  											AND   A.ACTIVE_FLAG = 'Y'			
                  											AND   B.INSTANCE_ID = @Param1
                  										) C			
      								 WHERE C.INSTANCE_TYPE=A.INSTANCE_TYPE 
								)							
				AND  A.ACTIVE_FLAG = 'Y'										
				AND	( ( @Param2 IS NULL OR @Param2 = '' ) OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param2,',') ) )
				GROUP BY A.OPERATION_ID, A.OPERATION_NAME										
				ORDER BY A.OPERATION_ID		
	 END

/*===============================================  
 용   도:  Line 조회  
 사 용 화 면:  
 변       수:  Param1 = Instance_Id  Param2 = Division_List  Param3 = Plant_List Param4 = Factory_List Param5 = USER_ID
 최 초 작 성:  2019. 03. 20  
 개  발  자 :  yschoi  
 최 종 작 성:  2019. 03. 20  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'LINE' )  
	 BEGIN  
				SELECT A.LINE_ID AS CODE										
						, '(' + A.LINE_ID + ')' + CASE WHEN A.LINE_NAME = '' OR A.LINE_NAME IS NULL THEN A.LINE_ID ELSE A.LINE_NAME END AS NAME										
				FROM   SCM_LINE_M_SN A WITH(NOLOCK)
						, (										
								SELECT B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID,B.PLANT_ID,B.FACTORY_ID										
								FROM TH_UIS_USER_FACTORY_RELATE_SN A WITH(NOLOCK), TH_UIS_ROLE_FACTORY_RELATE_SN B WITH(NOLOCK)					
								WHERE A.USER_ID = @Param6					
								AND   A.ROLE_ID = B.ROLE_ID					
								AND   A.USE_AT_FLAG = 'Y'					
								AND   B.USE_AT_FLAG = 'Y'					
								GROUP BY B.COMPANY_ID,B.DIVISION_ID,B.SITE_ID,B.PLANT_ID,B.FACTORY_ID					
						) AA					
				WHERE A.COMPANY_ID=AA.COMPANY_ID										
				AND   A.DIVISION_ID=AA.DIVISION_ID										
				AND   A.SITE_ID=AA.SITE_ID										
				AND   A.PLANT_ID=AA.PLANT_ID									
				AND   A.FACTORY_ID=AA.FACTORY_ID									
				AND   A.ACTIVE_FLAG = 'Y'									
				AND   EXISTS (										
									SELECT 1 FROM (										
														SELECT DISTINCT A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID										
														FROM SCM_FACTORY_M_SN A WITH(NOLOCK)										
														INNER JOIN FP_INSTANCE_FACTORY_M_SN B WITH(NOLOCK)										
														ON	A.FACTORY_ID=B.FACTORY_ID										
														AND	B.ACTIVE_FLAG = 'Y'										
														WHERE 1=1										
														AND	A.ACTIVE_FLAG = 'Y'								
														AND	B.INSTANCE_ID = @Param1								
									) C										
									WHERE C.COMPANY_ID=A.COMPANY_ID AND C.DIVISION_ID=A.DIVISION_ID AND C.SITE_ID=A.SITE_ID AND C.PLANT_ID=A.PLANT_ID AND C.FACTORY_ID=A.FACTORY_ID										
								)	
				AND	( ( @Param2 IS NULL OR @Param2 = '' ) OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param2,',') ) )
				AND	( ( @Param3 IS NULL OR @Param3 = '' ) OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param3,',') ) ) 										
				AND	( ( @Param4 IS NULL OR @Param4 = '' ) OR A.FACTORY_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',') ) )									
				AND	( ( @Param5 IS NULL OR @Param5 = '' ) OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param5,',') ) )									
				AND EXISTS ( 
									SELECT  1 										
									FROM    SCM_SYS_LOOKUP_VALUE_SN LV1 WITH(NOLOCK)										
									WHERE   LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'						
									AND     LV1.SEGMENT1         = @Param1
									AND     LV1.ACTIVE_FLAG      = 'Y'								
									AND     LV1.ATTRIBUTE1       = 'BUILDING'								
									UNION ALL								
									SELECT  1 								
									FROM    SCM_SYS_LOOKUP_VALUE_SN LV1 WITH(NOLOCK),										
									SCM_SYS_LOOKUP_VALUE_SN LV2 WITH(NOLOCK)								
									WHERE   LV1.LOOKUP_TYPE_CODE = 'INSTANCE_ID'								
									AND 	   LV2.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'							
									AND     LV1.SEGMENT1         = LV2.SEGMENT1								
									AND     LV1.SEGMENT1         = @Param1								
									AND     LV1.ACTIVE_FLAG      = 'Y'								
									AND     LV1.ATTRIBUTE1       = 'PLAN GROUP'								
									AND     LV2.SEGMENT2         = ISNULL(A.MODEL_TYPE,LV2.SEGMENT2) 
								)								
				GROUP BY A.LINE_ID, A.LINE_NAME										
				ORDER BY A.LINE_ID										
	 END


/*===============================================  
 용   도:  Line 조회  
 사 용 화 면:  
 변       수:  Param1 = Instance_Id  Param2 = Division_List  Param3 = Plant_List Param4 = Factory_List Param5 = USER_ID
 최 초 작 성:  2019. 03. 20  
 개  발  자 :  yschoi  
 최 종 작 성:  2019. 03. 20  
 수  정  자 :  -  
 수 정 사 항:    
 ===============================================*/  
 ELSE IF (@Code = 'CURRENT_DATE' )  
	 BEGIN  
				SELECT --SUBSTRING(CONVERT(VARCHAR,GETDATE(), 120),1,10) AS CUR_DATE				
							CONVERT(VARCHAR,GETDATE(), 112) AS CUR_DATE										
	 END

 ELSE  
  return;   
  
 --------------  
END

