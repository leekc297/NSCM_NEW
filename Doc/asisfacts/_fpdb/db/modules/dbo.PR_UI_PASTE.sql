CREATE PROCEDURE [dbo].[PR_UI_PASTE]
  @p_sys_type			nvarchar(MAX)='',  
  @p_sys_flag			nvarchar(MAX)='',
  @p_sys_gubun			nvarchar(MAX)='',  
  @p_xxxx			nvarchar(MAX)='',
  @ooooo_uuuuu nvarchar(MAX)='',
  @in_row nvarchar(MAX)='',
  @opt_none nvarchar(5) = 'N'
WITH EXEC AS CALLER
AS


BEGIN
  SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
  SET NOCOUNT ON; 
  SET XACT_ABORT ON;
  
  BEGIN
	SELECT '3333' AS SUCCESS

	--Receipt(Plan+Intransit) query cell simulation(Assy) ui 에서 발췌
	/*
		 SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.ETA_DATE AS PLAN_DATE, 0 AS COATER_QTY, 0 AS POST_QTY 
                        , 0 AS ASSY_QTY, 0 AS SHIP_QTY, ISNULL(A.QTY,0) AS SHIP_IN_QTY, 0 AS BOH_QTY 
                        , NULL AS PLANT_ID, NULL AS TOP_ITEM_ID, NULL AS NPC_ITEM_ID                 
                    FROM (        
                          SELECT  A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.ETA_DATE,112) AS ETA_DATE, SUM(A.QTY) AS QTY 
                          FROM  ( 
                          SELECT 'PL_CELL' AS INSTANCE_ID 
                              ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID 
                              ,CASE WHEN ISNULL(A.ETA_DATE,'') < '20230209' THEN '20230209' ELSE ISNULL(A.ETA_DATE,'') END AS ETA_DATE 
                              ,A.INTRANSIT_QTY AS QTY              
                          FROM 	FP_MRP_INTRANSIT_H A WITH(NOLOCK)  
                          INNER HASH JOIN FP_INSTANCE_PANCAKE_V V WITH(NOLOCK) 
                          ON 1=1 
                          AND	V.INSTANCE_ID  = (SELECT TO_INSTANCE_ID FROM #PANCAKE_INSTANCE) 
                          AND	V.GUBUN        = 'RECEIPT'   
                          AND	V.ACTIVE_FLAG  = 'Y'         
                          AND	A.COMPANY_ID   = V.COMPANY_ID  
                          AND	A.DIVISION_ID  = V.DIVISION_ID 
                          AND   A.SITE_ID	   = V.SITE_ID     
                          WHERE 1=1                            
                          AND   A.ITEM_ID LIKE 'APC%'        
                          UNION ALL                            
                          --= Shipment_In List: ??? ????
                          SELECT 'PL_CELL' AS INSTANCE_ID, V.COMPANY_ID, V.DIVISION_ID, A.TO_SITE_ID AS SITE_ID, V.PLANT_ID 
                               , A.ITEM_ID, A.RECEIVE_YYYYMMDD AS ETA_DATE, A.SHIP_QTY AS QTY 
                          FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) 
                          INNER JOIN #INS_PLANT V                   
                          ON  1=1                                  
                          AND A.TO_SITE_ID  = V.SITE_ID            
                          AND A.TO_PLANT_ID = V.ASSY_PLANT_ID      
                          INNER JOIN #SHIPMENT_INFO  C              
                          ON  1=1                                  
                          AND  A.DIVISION_ID   = C.DIVISION_ID     
                          AND  A.SITE_ID        = C.SITE_ID        
                          AND  A.PLANT_ID       = C.PLANT_ID       
                          AND  A.SHOP_GROUP_ID  = C.SHOP_GROUP_ID  
                          AND  A.SCP_PLAN_ID    = C.SCP_PLAN_ID    
                          WHERE	1=1                                
                          AND  A.PLANT_ID <> A.TO_PLANT_ID	-- ??? to ? ??? ?? ??? ????. 
                          AND  A.SHIP_QTY > 0        
                          AND  A.RECEIVE_YYYYMMDD >= '20230209'   ---+ ??? ????? ????. 
                          UNION ALL                              
                          -- SCP INTRANSIT ?? ??... 20200722 
                          SELECT 'PL_CELL' AS INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, V.PLANT_ID, A.ITEM_ID 
                              , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, '20230209',112) THEN CONVERT(VARCHAR, '20230209',112) ELSE A.ETA_DATE END ETA_DATE --+ ?? ????? ??? ????? ???? 
                              , DELIVERY_QTY AS QTY                 
                          FROM   FP_SCM_IN_TRANSIT_H A WITH(NOLOCK) 
                               , SCM_ITEM_M B WITH(NOLOCK)          
                               , SCM_ITEM_CLASS_M C WITH(NOLOCK)    
                               , #INS_PLANT V                        
                          WHERE  A.DELIVERY_QTY > 0                 
                          AND    A.RESULT_DATE  = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, '20230209') ),112)  --> D-1?? ???? ?. 
                          AND    A.COMPANY_ID   = B.COMPANY_ID    
                          AND    A.DIVISION_ID  = B.DIVISION_ID   
                          AND    A.SITE_ID      = B.SITE_ID       
                          AND    A.ITEM_ID      = B.ITEM_ID       
                          AND    B.ACTIVE_FLAG  = 'Y'           
                          AND    B.ITEM_CLASS   = C.CLASS_ID      
                          AND    C.LEVEL_2_NAME = 'Pancake'     
                          AND    A.COMPANY_ID   = V.COMPANY_ID    
                          AND    A.SITE_ID      = V.SITE_ID       
                          AND    A.PLANT_ID     = V.ASSY_PLANT_ID 
                       ) A                                        
                    WHERE 1=1                                     
                    GROUP BY A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, CONVERT(VARCHAR,A.ETA_DATE,112) 

	*/

	--Receipt(Plan+Intransit) query cell simulation(Pack) ui 에서 발췌
	/*
			WITH ASSY_PLAN AS (																																									
	        			SELECT	A.*                  
	        			FROM	(                      
	        						SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID='-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE                       
										 , RELEASE_PLAN_ID, INSERT_TIME                      
										 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID='-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)             
	                													 ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM     
	        						FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)         
	        						WHERE  A.INSTANCE_DATE <= '20230210'                
	        					) A 
	        			WHERE A.ROW_NUM = 1         
	        			AND   A.INSTANCE_ID = 'KR_PACK'                      
	    				AND   A.RELEASE_VALUE IN (                           
	    												SELECT DISTINCT (CASE WHEN A.ATTRIBUTE1 = 'BUILDING' THEN B.FACTORY_ID  
	    																		WHEN A.ATTRIBUTE1 = 'PLAN GROUP' THEN C.PLAN_GROUP_ID                     
	    																		ELSE B.FACTORY_ID END) AS RELEASE_VALUE             
	    												FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)   
	    												LEFT OUTER HASH JOIN (                       
	    													SELECT A.INSTANCE_ID, FACTORY_ID         
	    													FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)                           
	    													WHERE  A.ACTIVE_FLAG = 'Y'             
	    												) B             
	    												ON  A.SEGMENT1 = B.INSTANCE_ID               
	    												LEFT OUTER HASH JOIN (                       
	    													SELECT A.SEGMENT1 AS INSTANCE_ID, A.SEGMENT2 AS PLAN_GROUP_ID         
	    													FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                            
	    													WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_PLANNING_GROUP'               
	    													AND    A.ACTIVE_FLAG = 'Y'             
	    												) C             
	    												ON    A.SEGMENT1 = C.INSTANCE_ID             
	    												WHERE A.LOOKUP_TYPE_CODE = 'INSTANCE_ID'   
	    												AND   A.ACTIVE_FLAG = 'Y'                  
	    												AND   A.SEGMENT1    = 'KR_PACK'          
	    										)                       
	        			AND   1=1                    
						UNION ALL       
						SELECT 'KR_PACK' AS INSTANCE_ID, '-' AS RELEASE_VALUE, '' AS RELEASE_PLAN_ID, NULL AS INSERT_TIME, 1 AS ROW_NM      
						WHERE   1=0                    
	      )         
	     -- INSERT INTO #TEMP_TABLE_01  
	      SELECT *  
	      FROM (    
				  SELECT  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID, 'INHOUSE' AS CATEGORY_ID, '' AS FROM_INSTANCE, A.PLAN_DATE, SUM(QTY) AS RECEIPT_QTY            
				  FROM    (                     
	    					  SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID                
	    							   , A.DIVISION_ID AS REF_DIVISION_ID, A.SITE_ID AS REF_SITE_ID, A.PLANT_ID AS REF_PLANT_ID   
	    							   , ISNULL(LV.GROUP_ITEM_ID , A.ITEM_ID ) AS ITEM_ID                 
	    							   , CONVERT(VARCHAR,A.PLAN_DATE,112) AS PLAN_DATE, A.QTY AS QTY      
	    							   , 'FORM' AS PLAN_TYPE               
	    							   , A.STORAGE_ID                        
	    					  FROM	  FP_CELL_INHOUSE_PLAN_H A WITH(NOLOCK)  
	    							  LEFT OUTER JOIN (                      
	    												  SELECT SEGMENT1 AS SITE_ID , SEGMENT2 AS DIVISION_ID , SEGMENT3 AS GROUP_ITEM_ID , SEGMENT4 AS ITEM_ID                            
	    												  FROM   SCM_SYS_LOOKUP_VALUE LV WITH(NOLOCK)     
	    												  WHERE  LV.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'                      
	    												  AND    LV.ACTIVE_FLAG      = 'Y'              
	    							  ) LV      
	    							  ON   1=1  
	    								  AND   A.SITE_ID     = LV.SITE_ID   
	    								  AND   A.DIVISION_ID = LV.DIVISION_ID                            
	    								  AND   A.ITEM_ID     = LV.ITEM_ID   
	    					  WHERE A.CATEGORY    = 'MOVING'               
							  AND A.INSTANCE_ID = N'KR_FORM_A' 
	    					  AND   CONVERT(VARCHAR,A.PLAN_DATE,112) >= CONVERT(VARCHAR, DATEADD(DAY, -1, CONVERT(DATE, '20230210') ), 112)       
	    					  AND 	EXISTS (    
	    									  SELECT 1                       
	    									  FROM (                         
	    											 SELECT INSTANCE_ID, MAX(PLAN_ID) AS PLAN_ID          
	    											 FROM   SCM_FP_IN_HOUSE_PLAN_H A WITH(NOLOCK)         
	    											 WHERE  CONFIRM_FLAG = 'Y'                          
	    											 GROUP BY INSTANCE_ID    
	    					              			)  AA                    
	    									  WHERE AA.INSTANCE_ID = A.INSTANCE_ID                        
	    									  AND  AA.PLAN_ID      = A.CONFIRM_ID                         
	    		          					)   
						) A   
	    	  			INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)                
						ON     A.COMPANY_ID  = B.COMPANY_ID                    
						AND    A.DIVISION_ID = B.DIVISION_ID                   
						AND    A.SITE_ID     = B.SITE_ID                       
						AND    A.ITEM_ID     = B.ITEM_ID                       
						AND    B.ACTIVE_FLAG  = 'Y'               
	    				INNER HASH JOIN (       
	      							SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.CELL_ITEM_ID    
	      							FROM   FP_AMEND_SIM_CELL_PACK_H A WITH(NOLOCK)           
	      							INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)    
	      							ON     A.COMPANY_ID   = C.COMPANY_ID         
	      							AND    A.DIVISION_ID  = C.DIVISION_ID        
	      							AND    A.SITE_ID      = C.SITE_ID            
	      							AND    A.MODEL_CODE   = C.ITEM_ID            
	      							AND    C.ACTIVE_FLAG  = 'Y'               
	      							WHERE  1=1      
	      							AND    EXISTS ( 
	        								SELECT 1 FROM ASSY_PLAN KK           
	        								WHERE KK.INSTANCE_ID     = A.INSTANCE_ID                          
	        								AND   KK.RELEASE_PLAN_ID = A.FP_PLAN_ID                           
	      							)               
	      							AND    A.CELL_QTY > 0                        
	      							AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '20230210' AND '20230217'                     


						) C                     
						ON  A.COMPANY_ID  = C.COMPANY_ID                           
						AND A.DIVISION_ID = C.DIVISION_ID                          
						AND A.SITE_ID     = C.SITE_ID 
						AND A.ITEM_ID     = C.CELL_ITEM_ID                         
				WHERE  1=1                  
				AND    A.PLAN_DATE BETWEEN '20230210' AND '20230217' 
				AND    A.QTY > 0            
				GROUP BY  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID , A.PLAN_DATE                     
				UNION ALL                     
				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID, A.CELL_CODE AS ITEM_ID, A.FROM_SITE AS CATEGORY_ID, M2.INSTANCE_ID AS FROM_INSTANCE, A.PLAN_DATE, SUM(QTY) AS RECEIPT_QTY	
				FROM   (                      
							SELECT A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , A.ITEM_ID AS CELL_CODE                 
	    	    						, B.SITE_ID        AS FROM_SITE         
	    	    						, B.PLANT_ID       AS FROM_PLANT_ID     
	    	    						, CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, '20230210',112) THEN CONVERT(VARCHAR, '20230210',112) ELSE CONVERT(VARCHAR,A.ETA_DATE,112) END PLAN_DATE 	
	    	    						, A.INTRANSIT_QTY  AS QTY               
	    	    						, B.COMPANY_ID     AS FROM_COMPANY_ID   
							FROM   FP_MRP_INTRANSIT_H A WITH(NOLOCK)         
									INNER JOIN (   
	      								SELECT DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID                       
	      								FROM   SCM_PLANT_M A WITH(NOLOCK)            
									) B                 
									ON  A.VENDOR_CODE = B.COMPANY_ID                 
							WHERE 1=1           
							AND   A.INTRANSIT_QTY > 0                        
	    	    			AND   EXISTS (      
	    	    							SELECT 1                         
	    	    							FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)                      
	    	    							WHERE  V.INSTANCE_ID = 'KR_PACK'                          
	    	    							AND    A.COMPANY_ID  = V.COMPANY_ID                           
	    	    							AND    A.DIVISION_ID = V.DIVISION_ID                          
	    	    							AND    A.SITE_ID     = V.SITE_ID 
	    	    							AND    A.PLANT_ID    = V.PLANT_ID
	    	    						)                   
	        			UNION ALL           
	        			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID AS CELL_CODE                     
	    		             , B.SITE_ID    AS FROM_SITE                 
	    		             , B.PLANT_ID   AS FROM_PLANT_ID             
	    		             , CASE WHEN A.ETA_DATE < CONVERT(VARCHAR, '20230210',112) THEN CONVERT(VARCHAR, '20230210',112) ELSE A.ETA_DATE END PLAN_DATE    
	    		             , A.DELIVERY_QTY AS QTY                     
	    		             , B.COMPANY_ID AS FROM_COMPANY_ID           
	        			FROM   FP_SCM_IN_TRANSIT_H A WITH(NOLOCK)      
	        			INNER JOIN (          
	      		        	SELECT DISTINCT A.COMPANY_ID, A.SITE_ID, A.PLANT_ID                       
	      		        	FROM   SCM_PLANT_M A WITH(NOLOCK)            
	        			) B                 
	        			ON  A.FROM_PLANT_ID = B.PLANT_ID                 
	        			WHERE 1=1           
	        			AND   A.RESULT_DATE  = CONVERT(VARCHAR, DATEADD(DD, -1, CONVERT(DATE, '20230210') ),112)             
	        			AND   A.DELIVERY_QTY > 0                         
	        			AND    EXISTS (     
	      		        	SELECT 1        
	      		        	FROM   FP_INSTANCE_INFO_V V WITH(NOLOCK)     
	      		        	WHERE  V.INSTANCE_ID = 'KR_PACK'         
	      		        	AND    A.COMPANY_ID  = V.COMPANY_ID          
	      		        	AND    A.DIVISION_ID = V.DIVISION_ID         
	      		        	AND    A.SITE_ID     = V.SITE_ID             
	      		        	AND    A.PLANT_ID    = V.PLANT_ID            
	        			)                   
	        			UNION ALL           
	    				SELECT 	A.CUSTOMER_ID AS COMPANY_ID              
	    		  				 , A.DIVISION_ID                         
	    		  				 , A.TO_SITE_ID  AS SITE_ID              
	    		  				 , A.TO_PLANT_ID AS PLANT_ID             
	    		  				 , A.ITEM_ID AS CELL_CODE                
	    		  				 , A.SITE_ID AS FROM_SITE_ID             
	    		  				 , A.PLANT_ID AS FROM_PLANT_ID           
	    		  				 , A.RECEIVE_YYYYMMDD  AS PLAN_DATE      
	    		  				 , A.SHIP_QTY     AS  QTY                
	    		  				 , A.COMPANY_ID  AS FROM_COMPANY_ID      
	    				FROM   FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK)
	    				WHERE  1=1          

	    				AND   EXISTS (      
	    			      				SELECT 1                         
	    			      				FROM (                           
	    			        					SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID            
	    			        					FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)           
	    				        					INNER HASH JOIN SCM_FACTORY_M B WITH(NOLOCK)      
	    				        					ON     A.FACTORY_ID  = B.FACTORY_ID               
	    			        					WHERE  A.INSTANCE_ID = 'KR_PACK'                  
	    			        					AND    A.ACTIVE_FLAG = 'Y'                          
	    			        					AND    B.ACTIVE_FLAG = 'Y'                          
	    			      				) AA
	    			      				WHERE A.CUSTOMER_ID = AA.COMPANY_ID                           
	    			      				AND   A.DIVISION_ID = AA.DIVISION_ID                          
	    			      				AND   A.TO_SITE_ID  = AA.SITE_ID 
	    			      				AND   A.TO_PLANT_ID = AA.PLANT_ID
	    	    					)       
	    				AND    A.SHOP_GROUP_ID = 'A'                   
	    				AND    A.SCP_PLAN_ID = (                         
	    	    									 SELECT MAX(SCP_PLAN_ID)                          
	    	    									 FROM  FP_WEEKLY_DEMAND_SHIPMENT_H A WITH(NOLOCK) 
	    	    									 		INNER HASH JOIN (                         
	    			        										SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID                     
	    			        										FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK)               
	    			        										INNER HASH JOIN SCM_FACTORY_M B WITH(NOLOCK)              
	    			        										ON     A.FACTORY_ID  = B.FACTORY_ID                       
	    			        										WHERE  A.INSTANCE_ID = 'KR_PACK'                      
	    			        										AND    A.ACTIVE_FLAG = 'Y'      
	    			        										AND    B.ACTIVE_FLAG = 'Y'      
	    			    									 ) B         
	    			    									 ON    A.CUSTOMER_ID = B.COMPANY_ID       
	    			    									 AND   A.DIVISION_ID = B.DIVISION_ID      
	    			    									 AND   A.TO_SITE_ID  = B.SITE_ID          
	    			    									 AND   A.TO_PLANT_ID = B.PLANT_ID         
	    	    									 WHERE A.SHOP_GROUP_ID = 'A'      

	    	    								)                        
	      			) A                     
	      			LEFT OUTER JOIN (				
	    								SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID
	    										, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID               
	    								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                    
	    								WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'   
	    								AND    A.ACTIVE_FLAG = 'Y'     
	    								AND	   A.SEGMENT4 = 'DU'       
	    		    ) D                     
	    				ON  A.DIVISION_ID  	= D.REF_DIVISION_ID          
	    				AND A.SITE_ID      	= D.REF_SITE_ID              
	    				AND A.PLANT_ID     	= D.REF_PLANT_ID             
	      			INNER JOIN (       
	    							SELECT DISTINCT INSTANCE_ID , COMPANY_ID, DIVISION_ID , SITE_ID, PLANT_ID                 
	    							FROM   FP_INSTANCE_INFO_V            
	    							WHERE  INSTANCE_ID  LIKE '%FORM%'  
	    			  ) M2                  
	    				ON 1=1              
	    				AND  A.DIVISION_ID  = M2.DIVISION_ID             
	    				AND  A.FROM_SITE  =  M2.SITE_ID                  
	    				AND  A.FROM_PLANT_ID = M2.PLANT_ID               
	    	  		INNER HASH JOIN SCM_ITEM_M B WITH(NOLOCK)            
	  		  		ON     A.COMPANY_ID  = B.COMPANY_ID                  
	  		  		AND    A.DIVISION_ID = B.DIVISION_ID                 
	  		  		AND    A.SITE_ID     = B.SITE_ID                     
	  		  		AND    A.CELL_CODE   = B.ITEM_ID                     
	  		  		AND		 B.ACTIVE_FLAG = 'Y'                       
	      			INNER HASH JOIN (       
	        					SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.CELL_ITEM_ID
	        					FROM   FP_AMEND_SIM_CELL_PACK_H A WITH(NOLOCK)       
	        					INNER HASH JOIN SCM_ITEM_M C WITH(NOLOCK)
	        					ON     A.COMPANY_ID   = C.COMPANY_ID     
	        					AND    A.DIVISION_ID  = C.DIVISION_ID    
	        					AND    A.SITE_ID      = C.SITE_ID        
	        					AND    A.MODEL_CODE   = C.ITEM_ID        
	      						AND    C.ACTIVE_FLAG  = 'Y'               
	        					WHERE  1=1  
	        					AND    EXISTS (                          
	          						SELECT 1 FROM ASSY_PLAN KK           
	          						WHERE KK.INSTANCE_ID     = A.INSTANCE_ID                          
	          						AND   KK.RELEASE_PLAN_ID = A.FP_PLAN_ID                           
	        					)           
	        					AND    A.CELL_QTY > 0                    
	        					AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN '20230210' AND '20230217'                 


	      			) C                     
	            ON  A.COMPANY_ID  = C.COMPANY_ID                         
	            AND A.DIVISION_ID = C.DIVISION_ID                        
	            AND A.SITE_ID     = C.SITE_ID                            
	            AND A.CELL_CODE   = C.CELL_ITEM_ID                       
	        		WHERE  1=1              
	        		AND    A.PLAN_DATE BETWEEN '20230210' AND '20230217'                          
	        		AND		 A.QTY > 0      
	        		GROUP BY  A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , ISNULL(D.PLANT_ID, A.PLANT_ID) , A.CELL_CODE , A.FROM_SITE , M2.INSTANCE_ID , A.PLAN_DATE                      
	      ) A       

	*/

--	ACEN1078I-A1-C03

--ACEN1078I-A1-C12

--ACEN1078I-A1-C13

--ACEN1078I-A1-000

--ACEN1078I-A1-100

--ACEN1078I-A1-010

--ACEN1078I-A1-310

--ACEN1078I-A1-210

--ACEN1078I-A1-110

--ACEN1078I-A1-C04

--ACEN1078I-A1-C05

--ACEN1078I-A1-200

--ACEN1078I-A1-C09

	--https://mobileappcommunicator.auth.microsoft.com/activate/658257426/KRS

--	case 1) EB -> ED 동으로 가는 Moving plan
--  EB동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// ED동에서 moving plan(in) 만큼 EOH(P/C)에 더함


--case2) ED -> EB동으로 가는 moving plan
--  ED동에서 moving plan(out) 만큼 EOH(P/C)에서 차감 /// EB동에서 moving plan(in) 만큼 EOH(P/C)에 차감하지 않음, 전극 창고를 통하지 않고 즉시 ass(P/C)로 입고됨


--Case1은 coating – R/P – S/L (EB)   à Rewinder(ED ) à 조립 이동
--case2는 coating – R/P – S/L – Rewinder(EB) à 조립 이동

--	UC 인원 관련해서 권한 신청 제한은...

 

--SELECT US.[USER_ID]
--    ,PD.COMPANY_ID
--   FROM [LGCE_FP_TR].[dbo].[TH_UIS_USER_DETAIL] US (NOLOCK)
--   LEFT OUTER JOIN ( SELECT COMPANY_ID
--                     FROM   [dbo].[SCM_PSEUDO_DIVISION_M] PD (NOLOCK)  
--      GROUP BY COMPANY_ID ) PD
--   ON US.COMPANY = PD.COMPANY_ID
--   ORDER BY 2 DESC

--사용자 정보에서 JV 가상 Division 조직의 사용자 여부를 조회합니다.

--가상 Division으로 company가 조회되면..

 

 /*
	WITH 	ITEM_LINE_VERSION AS			
		(		
		SELECT 	  A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID	
				, A.LINE_ID, B.LINE_NAME, A.ELECTRODE_TYPE
				, C.MODEL_ID, C.PJT_CODE , C.VERSION_TYPE, C.VERSION, A.OPERATION_ID
				, A.ITEM_ID, D.NICK_NAME, B.PROD_VERSION_TYPE, C.MAX_VER_FLAG  
		FROM 	SCM_ITEM_LINE_ASSIGN_M A,	
				SCM_LINE_M B,
				SCM_ITEM_CONV_CALC_M C,
				SCM_ITEM_M D
		WHERE 	1=1	
		AND 		A.DIVISION_ID = '81'
		AND 		A.SITE_ID = 'A004'
		AND 		A.OPERATION_ID = 'E2000'
		AND 		A.ACTIVE_FLAG = 'Y'
		AND 		A.MONTH >= '202211'
		AND 		A.COMPANY_ID = B.COMPANY_ID 
		AND 		A.DIVISION_ID = B.DIVISION_ID 
		AND 		A.SITE_ID = B.SITE_ID
		AND 		A.OPERATION_ID = B.OPERATION_ID 
		AND 		A.FACTORY_ID = B.FACTORY_ID 
		AND 		A.LINE_ID = B.LINE_ID 
		AND 		A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 
		AND 		B.ACTIVE_FLAG = 'Y'
		AND 		A.COMPANY_ID = C.COMPANY_ID 
		AND 		A.DIVISION_ID = C.DIVISION_ID 
		AND 		A.SITE_ID = C.SITE_ID
		AND 		A.OPERATION_ID = C.OPERATION
		AND 		A.FACTORY_ID = C.FACTORY_ID 
		AND 		B.PROD_VERSION_TYPE = C.PROD_VERSION_TYPE
		AND 		A.COMPANY_ID = D.COMPANY_ID 
		AND 		A.DIVISION_ID = D.DIVISION_ID 
		AND 		A.SITE_ID = D.SITE_ID
		AND 		A.ITEM_ID = D.ITEM_ID
		GROUP BY 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID	
				, A.LINE_ID, B.LINE_NAME, A.ELECTRODE_TYPE
				, C.MODEL_ID, C.PJT_CODE , C.VERSION_TYPE, C.VERSION, A.OPERATION_ID
				, A.ITEM_ID, D.NICK_NAME, B.PROD_VERSION_TYPE, C.MAX_VER_FLAG  
		)		
SELECT 	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID			
		, A.LINE_ID, A.LINE_NAME, A.ELECTRODE_TYPE		
		, A.MODEL_ID, A.PJT_CODE, A.VERSION_TYPE, A.VERSION, A.OPERATION_ID		
		, A.ITEM_ID, A.NICK_NAME		
		, CASE WHEN A.MAX_VER_FLAG = 'Y' THEN ISNULL(B.ACTIVE_FLAG, 'Y') ELSE ISNULL(B.ACTIVE_FLAG, 'N') END AS ACTIVE_FLAG		
		, A.PROD_VERSION_TYPE, A.MAX_VER_FLAG		
		, B.DESCRIPTION		
		, B.UPDATE_ID, ISNULL(B.UPDATE_TIME, GETDATE()) AS UPDATE_TIME		
FROM 	ITEM_LINE_VERSION A			
		LEFT OUTER JOIN SCM_ITEM_CONV_CALC_USE_M B		
		ON 	1=1	
		AND 	A.COMPANY_ID = B.COMPANY_ID 	
		AND 	A.DIVISION_ID = B.DIVISION_ID 	
		AND 	A.SITE_ID = B.SITE_ID 	
		AND 	A.PLANT_ID = B.PLANT_ID 	
		AND 	A.FACTORY_ID = B.FACTORY_ID 	
		AND 	A.MODEL_ID = B.MODEL_ID	
		AND 	A.ITEM_ID = B.ITEM_ID	
		AND 	A.LINE_ID = B.LINE_ID	
		AND 	A.ELECTRODE_TYPE = B.ELECTRODE_TYPE 	
		AND 	A.VERSION = B.VERSION	
WHERE 	1=1			
#NAME?		A.ITEM_ID = 'APCAN1218A'		
ORDER BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID				
		, A.LINE_ID, A.ELECTRODE_TYPE		
		, A.MODEL_ID, A.VERSION_TYPE, A.VERSION		
		, A.ITEM_ID, A.PROD_VERSION_TYPE, A.MAX_VER_FLAG		


 */


--SELECT [ROLE_ID]
--       ,[INSTANCE_ID]
--       ,[COMPANY_ID]
--  FROM [LGCE_FP_TR].[dbo].[TH_UIS_ROLE_INSTANCE_RELATE]
-- WHERE  COMPANY_ID = 'G670'

--권한 신청 가능 목록을 해당 Company로 제한합니다.

 -- BOH 쿼리 입니다.
	
 SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID, A.ITEM_ID         
	    , ISNULL(SUM(GOOD_QTY),0) AS GOOD_QTY              
	    , ISNULL(SUM(HOLD_QTY),0) AS HOLD_QTY              
	    , ISNULL(SUM(INTRANSIT_QTY),0) AS INTRANSIT_QTY    
	    , ISNULL(SUM(GOOD_CELL_QTY),0) AS GOOD_CELL_QTY    
	    , ISNULL(SUM(HOLD_CELL_QTY),0) AS HOLD_CELL_QTY    
	    , ISNULL(SUM(UNINSPEC_CELL_QTY),0) AS UNINSPEC_CELL_QTY    
	    , ISNULL(SUM(BOX_PACKING_CELL_QTY),0) AS BOX_PACKING_CELL_QTY    
	    , ISNULL(SUM(LONG_TERM_CELL_QTY),0) AS LONG_TERM_CELL_QTY    
FROM (                     
		    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  
		      	, ISNULL(ISNULL(MAX(GOOD_MODIFY_QTY), SUM(A.GOOD_QTY)),0) AS GOOD_QTY                         
		      	, ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                         
		      	, 0 AS INTRANSIT_QTY                     
		      	, 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY 
		      	, 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY 
		    FROM (           
			        --- P1000 대기재고 ---              
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(C.SEGMENT3, FP_APPLY_ITEM_ID)  AS ITEM_ID           
								, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> 'Y' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS GOOD_QTY   
								, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN < > 'Y' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS GOOD_MODIFY_QTY                 
								, CASE WHEN WIPHOLD_YN = 'Y' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY    
								, CASE WHEN WIPHOLD_YN = 'Y' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                   
						FROM   SCM_STOCK_H A WITH(NOLOCK)   
								LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)        
								ON    C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'            
								AND   A.SITE_ID = C.SEGMENT1        
								AND   A.ITEM_ID = C.SEGMENT4        
						WHERE A.CUTOFF_DATE  = CONVERT(DATE,'20220929')   --->  ???? ?? INSTANCE DATE     
						AND   A.OPERATION_ID =  'P1000'   
						AND   A.STORAGE_ID   =  'MES'     
						AND   A.STOCK_STATUS =  'WAIT'         --+ 10/17추가      
						AND   EXISTS (                      
										SELECT 1            
										FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)
										WHERE  FF.FACTORY_ID  = A.FACTORY_ID        
										AND    FF.INSTANCE_ID = 'PL_PACK'       
										AND    FF.ACTIVE_FLAG = 'Y'               
									  )                      
					) A  
			WHERE	1=1
			AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  
			UNION ALL          
			--- STORAGE_ID 1000번대 재고. factory_id가 없음. ---                    
			SELECT A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID, ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID) AS ITEM_ID                     
					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND ISNULL(WIPHOLD_YN,'N') <> 'Y' THEN  A.QTY2  ELSE NULL END AS GOOD_QTY             
					, CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y'  THEN  A.QTY2 ELSE NULL END AS HOLD_QTY            
					, 0 AS INTRANSIT_QTY                       
					, 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY   
		      		, 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY 
			FROM   SCM_STOCK_H A WITH(NOLOCK)               
					LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)                    
					ON    C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.      
					AND   A.SITE_ID = C.SEGMENT1                    
					AND   A.ITEM_ID = C.SEGMENT4                    
			WHERE A.CUTOFF_DATE  = CONVERT(DATE,'20220929')   --->  ???? ?? INSTANCE DATE                 
			AND   SUBSTRING (A.STORAGE_ID, 1, 1)  = '1'   
			AND   EXISTS (     
							SELECT 1                        
							FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK), SCM_FACTORY_M F2 WITH(NOLOCK)          
							WHERE  FF.FACTORY_ID  = F2.FACTORY_ID                   
							AND    F2.SITE_ID     = A.SITE_ID                       
							AND    FF.INSTANCE_ID = 'PL_PACK' ---> INSTANCE ??
							AND    FF.ACTIVE_FLAG = 'Y'   
						)    
			AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
			UNION ALL          
			--- DW 이동재고 ---
			-- SSP 테이블 기준으로 변경.... 20210105        
			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(C.SEGMENT3, ITEM_ID) AS ITEM_ID      
				, 0 AS GOOD_QTY, 0 AS HOLD_QTY                 
				, ISNULL(A.PACK_MOVE_QTY ,0) AS INTRANSIT_QTY  
				, 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY       
		      		, 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY 
			FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)       
					LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)                      
					ON     C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.       
					AND    A.SITE_ID = C.SEGMENT1                     
					AND    A.ITEM_ID = C.SEGMENT4                     
			WHERE  1=1           
			AND    A.CUTOFF_DATE = CONVERT(DATETIME,'20220929')                      
			AND    A.PACK_MOVE_QTY > 0                        
			AND   EXISTS (       
	              		SELECT 1                            
	              		FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK), SCM_FACTORY_M F2 WITH(NOLOCK)              
	              		WHERE  FF.FACTORY_ID  = F2.FACTORY_ID                       
	              		AND    F2.SITE_ID     = A.SITE_ID   
	              		AND    FF.INSTANCE_ID = 'PL_PACK' ---> INSTANCE ??    
	              		AND    FF.ACTIVE_FLAG = 'Y'       
			)     
			AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
			UNION ALL          
			/**** BOH(CELL) 재고 ****/                      
			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID    
					, 0 AS GOOD_QTY, 0 AS HOLD_QTY, 0 AS INTRANSIT_QTY                 
					, SUM(A.BOH_QTY)  AS GOOD_CELL_QTY		                      
					, SUM(A.HOLD_QTY) AS HOLD_CELL_QTYAS			              
					, SUM(A.UNINSPEC_BOH_QTY) AS UNINSPEC_CELL_QTY	              
					, SUM(A.BOX_PACKING_BOH_QTY) AS BOX_PACKING_CELL_QTY         
					, SUM(A.LONG_TERM_BOH_QTY) AS LONG_TERM_CELL_QTY         
			FROM   (           
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                      
	            				, ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID          
	            				, A.WIPHOLD_YN                         
	            				, CASE WHEN A.LOT_PACKING_TYPE <> 'UI' AND  A.QLTY_NO_INSP_FLAG != 'Y' AND CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112)	AND WIPHOLD_YN <> 'Y' AND A.LONG_TERM_FLAG = 'N' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY        
	            				, CASE WHEN A.LOT_PACKING_TYPE = 'UI' AND  A.QLTY_NO_INSP_FLAG <> 'Y' AND CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112)	AND WIPHOLD_YN <> 'Y' AND A.LONG_TERM_FLAG =  'N'  THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOX_PACKING_BOH_QTY        
	            				, CASE WHEN WIPHOLD_YN = 'Y' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY        
	            				, CASE WHEN A.QLTY_NO_INSP_FLAG = 'Y' AND WIPHOLD_YN = 'N' 	AND A.LONG_TERM_FLAG =  'N' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS UNINSPEC_BOH_QTY         
	            				, CASE WHEN ISNULL(A.LONG_TERM_FLAG, 'N') = 'Y' AND WIPHOLD_YN = 'N' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS LONG_TERM_BOH_QTY        
	            				, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN < > 'Y' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY                    
	            				, CASE WHEN WIPHOLD_YN = 'Y' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                     
						FROM   SCM_STOCK_H A WITH(NOLOCK)       
	            				LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)             
	            				ON  C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.
	            				AND A.SITE_ID          = C.SEGMENT1     
	            				AND A.ITEM_ID          = C.SEGMENT4     
						WHERE EXISTS (                          
	            						SELECT 1                            
	            						FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)                
	            						WHERE  FF.FACTORY_ID  = A.FACTORY_ID
										AND FF.INSTANCE_ID = N'PL_FORM_A' 
	            						AND    FF.ACTIVE_FLAG = 'Y'       
	            					)          
						AND 0=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 stock 쪽은 비활성화
								SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_SSP      
								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  
								WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'       
								AND    A.ACTIVE_FLAG = 'Y'        
								AND    A.SEGMENT1 = 'PL_PACK' ) 
						AND   A.CUTOFF_DATE  = CONVERT(DATE,'20220929') --->  ???? ?? INSTANCE DATE           
						AND   A.STOCK_TYPE  = 'WIP'  --- 재고 검색조건                 
						AND   ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 
						AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
						UNION ALL      
						-- SSP 재고 정보                            
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.WIPHOLD_YN 
	              				, 0 AS BOX_PACKING_BOH_QTY            
	              				, 0 AS UNINSPEC_BOH_QTY            
	              				, 0 AS LONG_TERM_BOH_QTY            
	              				, SUM(A.BOH_QTY) AS BOH_QTY            
	              				, SUM(A.HOLD_QTY) AS HOLD_QTY          
	              				, SUM(A.BOH_MODIFY_QTY) AS BOH_MODIFY_QTY                      
	              				, SUM(A.HOLD_MODIFY_QTY) AS HOLD_MODIFY_QTY                    
						FROM (         
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, ISNULL(C.SEGMENT3, ITEM_ID) AS ITEM_ID           
	                    						, A.HOLD AS WIPHOLD_YN         
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN A.QTY ELSE 0 END AS BOH_QTY                            
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN 0 ELSE A.QTY END AS HOLD_QTY                           
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN A.QTY ELSE 0 END AS BOH_MODIFY_QTY                     
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN 0 ELSE A.QTY END AS HOLD_MODIFY_QTY                    
									FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                     
											LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)               
											ON    C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.
											AND   A.SITE_ID          = C.SEGMENT1     
											AND   A.ITEM_ID          = C.SEGMENT4     
									WHERE EXISTS (                          
	            									SELECT 1                            
	            									FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)                
	            									WHERE  FF.FACTORY_ID  = A.FACTORY_ID
													AND FF.INSTANCE_ID = N'PL_FORM_A' 
	            									AND    FF.ACTIVE_FLAG = 'Y'       
												)          
									AND 1=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 SSP 쪽 활성화  
	                      					SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_SSP  
	                      					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              
	                      					WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'   
	                      					AND    A.ACTIVE_FLAG = 'Y'    
	                      					AND    A.SEGMENT1 = 'PL_PACK' )                     
									AND   A.CUTOFF_DATE = CONVERT(DATETIME,'20220929')             
									AND   A.QTY > 0     
									AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
							) A              
						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.WIPHOLD_YN 
					) A                
				WHERE 1=1          
				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  
		) A                    
		LEFT OUTER JOIN (														-- Hazel Park Plant mapping 시켜줌                            
							SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                            
									, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID              
							FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              
							WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'                          
							AND    A.ACTIVE_FLAG = 'Y'    
							AND	   A.SEGMENT4 = 'DU'      
		) D                    
			ON  A.DIVISION_ID  	= D.REF_DIVISION_ID         
			AND A.SITE_ID      	= D.REF_SITE_ID             
			AND A.PLANT_ID     	= D.REF_PLANT_ID            
WHERE 1=1  
--AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID), A.ITEM_ID 
;

 
/*
 * FORM BOH
 */

SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID									
			, ISNULL(SUM(QTY),0) AS BOH_QTY		
			, ISNULL(SUM(GOOD_QTY),0) AS GOOD_QTY		
			, ISNULL(SUM(HOLD_QTY),0) AS HOLD_QTY		
			, ISNULL(SUM(UNINSPEC_BOH_QTY),0) AS UNINSPEC_BOH_QTY		
			, ISNULL(SUM(LONG_TERM_BOH_QTY),0) AS LONG_TERM_BOH_QTY		
			, ISNULL(SUM(INTRANSIT_QTY),0) AS INTRANSIT_QTY		
--	INTO #T_STOCK_FORM                                                 
	FROM   (                                                           
	    	/* ?? ERP BOH ?? ?? */                                       
	    	SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FP_APPLY_OPERATION_ID, A.QTY2 AS QTY                               
	    			, ISNULL(WIPHOLD_YN,'N') AS WIPHOLD_YN                 
					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND  ISNULL(WIPHOLD_YN,'N') < > 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN A.QTY2 ELSE NULL END AS GOOD_QTY    	   
					, CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND A.PACK_MOVE_FLAG != 'Y' THEN A.QTY2 ELSE NULL END AS HOLD_QTY                      																				   
					, CASE WHEN A.QLTY_NO_INSP_FLAG = 'Y' AND WIPHOLD_YN = 'N' 	AND A.LONG_TERM_FLAG =  'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN  A.QTY2  ELSE NULL END AS UNINSPEC_BOH_QTY      							   
					, CASE WHEN ISNULL(A.LONG_TERM_FLAG, 'N') = 'Y' AND WIPHOLD_YN = 'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN  A.QTY2  ELSE NULL END AS LONG_TERM_BOH_QTY					 								   
					, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, 'N') = 'Y' THEN A.QTY2 ELSE NULL END  AS INTRANSIT_QTY										 																				   
	    			, A.FP_APPLY_ITEM_ID AS ITEM_ID                          
	    			, IM.FLOW_ID , IM.LEVEL_1_CODE, IM.LEVEL_2_CODE, IM.LEVEL_2_NAME, IM.LEVEL_3_CODE, IM.LEVEL_3_NAME         
	    	FROM   SCM_STOCK_H A WITH(NOLOCK)                            
	    			INNER HASH JOIN                                          
	    					(                                                    
							SELECT *                                               
							FROM	#T_ITEM                                          
							WHERE	1=1                                              
							AND		SHOP_FLAG = 'CELL'                             
	    			) IM                                                     
	    			ON   IM.COMPANY_ID  = A.COMPANY_ID                       
	    			AND  IM.DIVISION_ID = A.DIVISION_ID                      
	    			AND  IM.SITE_ID     = A.SITE_ID                          
	    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                 
	    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       
	    					SELECT B.LOOKUP_TYPE_CODE                            
	    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      
	    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                                  
	    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   
	    					WHERE  A.ACTIVE_FLAG = 'Y'                         
	    					AND    B.ACTIVE_FLAG = 'Y'                         
	    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       
	    					AND    A.LOOKUP_TYPE_CODE = 'SIMULATION_BOH'       
	    					AND    B.SEGMENT1         = 'CELL_SIMULATION'      
	    					AND    B.SEGMENT2         = 'A004'            
	    			) V                                                      
	    			ON   A.DIVISION_ID           = V.DIVISION_ID             
	    			AND  A.SITE_ID               = V.SITE_ID                 
	    			AND  A.PLANT_ID              = V.PLANT_ID                
	    			AND  A.STOCK_TYPE            = V.STOCK_TYPE              
	    			AND  A.STORAGE_ID            = V.STOCK_POINT             
	    			AND  V.CELL_BOH              = 'Y'         --- ??BOH ?? ??                                            
	    	WHERE 1=1                                                    
			AND	 A.CUTOFF_DATE ='20221011'---> instance date             
			AND  A.SITE_ID = 'A004'                                      
	    	AND  A.STOCK_TYPE  = 'INVENTORY'  ---  ERP ??              
	    	AND  A.QTY2 > 0         
	    	AND 		A.ITEM_ID = 'ACEN4069I-A1-D06'
	    	--AND EXISTS (                                               
	     -- 					SELECT 1                                         
	     -- 					FROM   FP_INSTANCE_INFO_V VV WITH(NOLOCK)        
	     -- 					WHERE  VV.INSTANCE_ID ='PL_FORM_A'             
	     -- 					AND    A.COMPANY_ID   = VV.COMPANY_ID            
	     -- 					AND    A.DIVISION_ID  = VV.DIVISION_ID           
	     -- 					AND    A.SITE_ID      = VV.SITE_ID               
	    	--			)                                                    
	    	UNION ALL                                                    
	    	/* ?? MES BOH ??                                             
	    	** ????: P5000 ?????? CELL??? ???? ?????.  */                
	    	SELECT	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,		A.OPERATION_ID AS OPERATION_ID                                        
	    			, (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN FP_APPLY_WIPQTY * BB.BOM_RATE ELSE FP_APPLY_WIPQTY END) AS QTY                                                           
	    			, ISNULL(WIPHOLD_YN,'N') AS WIPHOLD_YN                 
					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND  ISNULL(WIPHOLD_YN,'N') < > 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  
					    	THEN  CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN FP_APPLY_WIPQTY * BB.BOM_RATE ELSE FP_APPLY_WIPQTY END                                                       
					    	ELSE NULL END AS GOOD_QTY                            																										   
					, CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'           																		   
					        THEN (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN FP_APPLY_WIPQTY * BB.BOM_RATE ELSE FP_APPLY_WIPQTY END)                                                      
					        ELSE NULL END AS HOLD_QTY                        																											   
					, CASE WHEN A.QLTY_NO_INSP_FLAG = 'Y' AND WIPHOLD_YN = 'N' 	AND A.LONG_TERM_FLAG =  'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'									   
								THEN  (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN A.FP_APPLY_WIPQTY * BB.BOM_RATE ELSE A.FP_APPLY_WIPQTY END)   										   
								ELSE NULL END AS UNINSPEC_BOH_QTY                                                                                										   
					, CASE WHEN ISNULL(A.LONG_TERM_FLAG, 'N') = 'Y' AND WIPHOLD_YN = 'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'                                 						   
								THEN  (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN A.FP_APPLY_WIPQTY * BB.BOM_RATE ELSE A.FP_APPLY_WIPQTY END)   										   
								ELSE NULL END AS LONG_TERM_BOH_QTY                                                                               										   
					, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, 'N') = 'Y' THEN A.QTY2 ELSE NULL END  AS INTRANSIT_QTY	                                                                
	    			, ISNULL(BB.CHILD_ITEM_ID, A.FP_APPLY_ITEM_ID) AS ITEM_ID                                               
	    			, IM.FLOW_ID , IM.LEVEL_1_CODE, IM.LEVEL_2_CODE, IM.LEVEL_2_NAME, IM.LEVEL_3_CODE, IM.LEVEL_3_NAME         
	    	FROM   SCM_STOCK_H A WITH(NOLOCK)                            
	    			INNER HASH JOIN                                          
	    					( --<IM: ITEM CODE ??? >--                           
	    					SELECT  I.COMPANY_ID , I.DIVISION_ID, I.SITE_ID , I.ITEM_ID , I.ITEM_CLASS , RIGHT(I.FLOW_ID,5) AS FLOW_ID , S.CLASS_NAME , S.LEVEL                                 
	    							, S.LEVEL_1_CODE , S.LEVEL_1_NAME , S.LEVEL_1_ID                                                
	    							, S.LEVEL_2_CODE , S.LEVEL_2_NAME , S.LEVEL_2_ID                                                
	    							, S.LEVEL_3_CODE , S.LEVEL_3_NAME , S.LEVEL_3_ID                                                
	    							, S.LEVEL_4_CODE , S.LEVEL_4_NAME , S.LEVEL_4_ID                                                
	    							, S.LEVEL_5_CODE , S.LEVEL_5_NAME , S.LEVEL_5_ID                                                
	    					FROM    SCM_ITEM_M I WITH(NOLOCK), SCM_ITEM_CLASS_M S WITH(NOLOCK)                                  
	    					WHERE  1=1                                           
							AND	   I.SITE_ID = 'A004'                            
							AND    I.ITEM_CLASS   = S.CLASS_ID                     
	    					AND    I.ACTIVE_FLAG  = 'Y'                        
	    					AND    S.USE_FLAG     = 'Y'                        
	    					AND    S.LEVEL_3_NAME IN ( 'Cell' , 'Module Automotive Assembly' )                              
	    					AND    RIGHT(I.FLOW_ID,5) IN ( 'A9000','A3000','P5000' )                                      
	    			) IM                                                     
	    			ON   1=1                                                 
	    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                 
	    			AND  IM.COMPANY_ID  = A.COMPANY_ID                       
	    			AND  IM.DIVISION_ID = A.DIVISION_ID                      
	    			AND  IM.SITE_ID     = A.SITE_ID                          
	    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       
	    					SELECT B.LOOKUP_TYPE_CODE                            
	    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      
	    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                                                 
	    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   
	    					WHERE  A.ACTIVE_FLAG = 'Y'                         
	    					AND    B.ACTIVE_FLAG = 'Y'                         
	    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       
	    					AND    A.LOOKUP_TYPE_CODE = 'SIMULATION_BOH'       
	    					AND    B.SEGMENT1         = 'CELL_SIMULATION'      
	    					AND    B.SEGMENT2         = 'A004'            
	    			) V                                                      
	    			ON   A.SITE_ID               = V.SITE_ID                 
	    			AND  A.DIVISION_ID           = V.DIVISION_ID             
	    			AND  A.PLANT_ID              = V.PLANT_ID                
	    			AND  A.STOCK_TYPE            = V.STOCK_TYPE              
	    			AND  A.OPERATION_ID			 = V.STOCK_POINT             
	    			AND  V.CELL_BOH              = 'Y'         --->  BOH??? ??? ?? ????? ?.       
	    			AND 	A.STOCK_STATUS		    = CASE WHEN V.STOCK_STATUS IS NULL THEN A.STOCK_STATUS ELSE V.STOCK_STATUS END                        
	    			LEFT OUTER HASH JOIN ( --<BB: P5000 ITEM? CELL??? ??: ALT_PRIORITY1??? ????. >--                        
	    					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.PARENT_ITEM_ID , A.CHILD_ITEM_ID , A.ALT_PRIORITY                                                     
	    							, A.CHILD_QTY/A.PARENT_QTY AS BOM_RATE           
	    					FROM	SCM_BOM_M A WITH(NOLOCK)                       
	    							INNER HASH JOIN  ( --: ???? CELL ?? ??           
											SELECT *                                       
											FROM	#T_ITEM                                  
											WHERE	1=1                                      
											AND		SHOP_FLAG = 'CELL'                     
	    									--SELECT CC.COMPANY_ID , CC.DIVISION_ID , CC.SITE_ID, CC.ITEM_ID , CC.ITEM_CLASS , DD.LEVEL_3_CODE, DD.LEVEL_3_NAME, CC.FLOW_ID                             
	    									--FROM   SCM_ITEM_M CC WITH(NOLOCK), SCM_ITEM_CLASS_M DD WITH(NOLOCK)                       
	    									--WHERE 1=1                                  
	    									--AND  CC.ITEM_CLASS    = DD.CLASS_ID        
	    									--AND  CC.ACTIVE_FLAG   = 'Y'              
	    									--AND  DD.USE_FLAG      = 'Y'              
	    									--AND  DD.LEVEL_3_NAME  = 'Cell'           
	    									--AND  RIGHT(ISNULL(CC.FLOW_ID,'Z'),5)  IN ('A9000', 'A3000' )                        
	    							) EE                                             
	    							ON   1=1                                         
	    							AND  A.COMPANY_ID  = EE.COMPANY_ID               
	    							AND  A.DIVISION_ID = EE.DIVISION_ID              
	    							AND  A.SITE_ID     = EE.SITE_ID                  
	    							AND  A.CHILD_ITEM_ID = EE.ITEM_ID                
	    					WHERE 1=1                                            
							AND	  A.SITE_ID = 'A004'                             
	    					AND   CONVERT(NVARCHAR(8),A.EFF_END_DATE,112)   >'20221011'                                       
	    					AND   CONVERT(NVARCHAR(8),A.EFF_START_DATE,112) <='20221011'                                      
	    					AND   ISNULL(A.ALT_PRIORITY,1) = 1                   
	    			) BB                                                     
	    			ON  1=1                                                  
	    			AND  A.SITE_ID          = BB.SITE_ID                     
	    			AND  A.DIVISION_ID      = BB.DIVISION_ID                 
	    			AND  A.PLANT_ID         = BB.PLANT_ID                    
	    			AND  A.FP_APPLY_ITEM_ID = BB.PARENT_ITEM_ID              
	    	WHERE 1=1                                                    
			AND	 A.CUTOFF_DATE = '20221011'                              
			AND  A.SITE_ID = 'A004'                                      
	    	AND  A.STORAGE_ID   = 'MES'                                
	    	AND  A.STOCK_TYPE   = 'WIP'     --- MES ??                 
	    	--AND EXISTS (                                               
	    	--	SELECT 1                                                 
	    	--	FROM   FP_INSTANCE_INFO_V VV WITH(NOLOCK)                
	    	--	WHERE  VV.INSTANCE_ID ='PL_FORM_A'                     
	    	--	AND    A.COMPANY_ID   = VV.COMPANY_ID                    
	    	--	AND    A.DIVISION_ID  = VV.DIVISION_ID                   
	    	--	AND    A.SITE_ID      = VV.SITE_ID                       
	    	--)                                                          
	    	AND  A.FP_APPLY_WIPQTY > 0      
--	    	AND 		A.ITEM_ID = 'ACEN4069I-A1-D06'
--	    	AND 		BB.CHILD_ITEM_ID = 'ACEN4069I-A1-D06'
	    	AND 		ISNULL(BB.CHILD_ITEM_ID, A.FP_APPLY_ITEM_ID) = 'ACEN4069I-A1-D06'
			UNION ALL                                                                                   									
			SELECT	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , IM.FLOW_ID AS OPERATION_ID                    
					, 0 AS QTY                                                                                            
					, 'N' AS WIPHOLD_YN                                                                                   
					, 0 AS GOOD_QTY		                                                                                    
					, 0 AS HOLD_QTY                                                                                       
					, 0 AS UNINSPEC_BOH_QTY                                                                               
			      	, 0 AS LONG_TERM_BOH_QTY                                                                              
					, ISNULL(A.PACK_MOVE_QTY ,0) AS INTRANSIT_QTY                                                         
					, A.ITEM_ID AS ITEM_ID                                                                                
					, IM.FLOW_ID , IM.LEVEL_1_CODE, IM.LEVEL_2_CODE, IM.LEVEL_2_NAME, IM.LEVEL_3_CODE, IM.LEVEL_3_NAME    
	    	FROM   SCM_STOCK_H A WITH(NOLOCK)                            
	    			INNER HASH JOIN                                          
	    					(                                                    
							SELECT *                                               
							FROM	#T_ITEM                                          
							WHERE	1=1                                              
							AND		SHOP_FLAG = 'CELL'                             
	    			) IM                                                     
	    			ON   IM.COMPANY_ID  = A.COMPANY_ID                       
	    			AND  IM.DIVISION_ID = A.DIVISION_ID                      
	    			AND  IM.SITE_ID     = A.SITE_ID                          
	    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                 
	    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       
	    					SELECT B.LOOKUP_TYPE_CODE                            
	    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      
	    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                                  
	    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   
	    					WHERE  A.ACTIVE_FLAG = 'Y'                         
	    					AND    B.ACTIVE_FLAG = 'Y'                         
	    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       
	    					AND    A.LOOKUP_TYPE_CODE = 'SIMULATION_BOH'       
	    					AND    B.SEGMENT1         = 'CELL_SIMULATION'      
	    					AND    B.SEGMENT2         = 'A004'            
	    			) V                                                      
	    			ON   A.DIVISION_ID           = V.DIVISION_ID             
	    			AND  A.SITE_ID               = V.SITE_ID                 
	    			AND  A.PLANT_ID              = V.PLANT_ID                
	    			AND  A.STOCK_TYPE            = V.STOCK_TYPE              
	    			AND  A.STORAGE_ID            = V.STOCK_POINT             
	    			AND  V.CELL_BOH              = 'Y'         --- ??BOH ?? ??                                            
	    	WHERE 1=1                                                    
			AND	 A.CUTOFF_DATE ='20221011'---> instance date             
			AND  A.SITE_ID = 'A004'                                      
	    	AND  A.STORAGE_ID  = 'MES'              
	    	AND  A.STOCK_TYPE  = 'WIP'              
	    	AND  A.PACK_MOVE_QTY > 0                
	    	AND 		A.ITEM_ID = 'ACEN4069I-A1-D06'
	) A                                                                
	WHERE 1=1                                                          
	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID 
	;

--CELL SIMULATION (PACK) BOH 산출

SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID) AS PLANT_ID, A.ITEM_ID         
	    , ISNULL(SUM(GOOD_QTY),0) AS GOOD_QTY              
	    , ISNULL(SUM(HOLD_QTY),0) AS HOLD_QTY              
	    , ISNULL(SUM(INTRANSIT_QTY),0) AS INTRANSIT_QTY    
	    , ISNULL(SUM(GOOD_CELL_QTY),0) AS GOOD_CELL_QTY    
	    , ISNULL(SUM(HOLD_CELL_QTY),0) AS HOLD_CELL_QTY    
	    , ISNULL(SUM(UNINSPEC_CELL_QTY),0) AS UNINSPEC_CELL_QTY    
	    , ISNULL(SUM(BOX_PACKING_CELL_QTY),0) AS BOX_PACKING_CELL_QTY    
	    , ISNULL(SUM(LONG_TERM_CELL_QTY),0) AS LONG_TERM_CELL_QTY    
FROM (                     
		    SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  
		      	, ISNULL(ISNULL(MAX(GOOD_MODIFY_QTY), SUM(A.GOOD_QTY)),0) AS GOOD_QTY                         
		      	, ISNULL(ISNULL(MAX(HOLD_MODIFY_QTY), SUM(A.HOLD_QTY)),0) AS HOLD_QTY                         
		      	, 0 AS INTRANSIT_QTY                     
		      	, 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY 
		      	, 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY 
		    FROM (           
			        --- P1000 대기재고 ---              
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(C.SEGMENT3, FP_APPLY_ITEM_ID)  AS ITEM_ID           
								, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN <> 'Y' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS GOOD_QTY   
								, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN < > 'Y' THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS GOOD_MODIFY_QTY                 
								, CASE WHEN WIPHOLD_YN = 'Y' THEN  A.FP_APPLY_WIPQTY ELSE NULL END AS HOLD_QTY    
								, CASE WHEN WIPHOLD_YN = 'Y' THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                   
						FROM   SCM_STOCK_H A WITH(NOLOCK)   
								LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)        
								ON    C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'            
								AND   A.SITE_ID = C.SEGMENT1        
								AND   A.ITEM_ID = C.SEGMENT4        
						WHERE A.CUTOFF_DATE  = CONVERT(DATE,'20221011')   --->  ???? ?? INSTANCE DATE     
						AND   A.OPERATION_ID =  'P1000'   
						AND   A.STORAGE_ID   =  'MES'     
						AND   A.STOCK_STATUS =  'WAIT'         --+ 10/17추가      
						AND   EXISTS (                      
										SELECT 1            
										FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)
										WHERE  FF.FACTORY_ID  = A.FACTORY_ID        
										AND    FF.INSTANCE_ID = 'PL_PACK'       
										AND    FF.ACTIVE_FLAG = 'Y'               
									  )                      
					) A  
			WHERE	1=1
			AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
			GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  
			UNION ALL          
			--- STORAGE_ID 1000번대 재고. factory_id가 없음. ---                    
			SELECT A.COMPANY_ID , A.DIVISION_ID, A.SITE_ID , A.PLANT_ID, ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID) AS ITEM_ID                     
					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND ISNULL(WIPHOLD_YN,'N') <> 'Y' THEN  A.QTY2  ELSE NULL END AS GOOD_QTY             
					, CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y'  THEN  A.QTY2 ELSE NULL END AS HOLD_QTY            
					, 0 AS INTRANSIT_QTY                       
					, 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY   
		      		, 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY 
			FROM   SCM_STOCK_H A WITH(NOLOCK)               
					LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)                    
					ON    C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.      
					AND   A.SITE_ID = C.SEGMENT1                    
					AND   A.ITEM_ID = C.SEGMENT4                    
			WHERE A.CUTOFF_DATE  = CONVERT(DATE,'20221011')   --->  ???? ?? INSTANCE DATE                 
			AND   SUBSTRING (A.STORAGE_ID, 1, 1)  = '1'   
			AND   EXISTS (     
							SELECT 1                        
							FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK), SCM_FACTORY_M F2 WITH(NOLOCK)          
							WHERE  FF.FACTORY_ID  = F2.FACTORY_ID                   
							AND    F2.SITE_ID     = A.SITE_ID                       
							AND    FF.INSTANCE_ID = 'PL_PACK' ---> INSTANCE ??
							AND    FF.ACTIVE_FLAG = 'Y'   
						)    
			AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
			UNION ALL          
			/*
			--- DW 이동재고 ---
			-- SSP 테이블 기준으로 변경.... 20210105        
			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, ISNULL(C.SEGMENT3, ITEM_ID) AS ITEM_ID      
				, 0 AS GOOD_QTY, 0 AS HOLD_QTY                 
				, ISNULL(A.PACK_MOVE_QTY ,0) AS INTRANSIT_QTY  
				, 0 AS GOOD_CELL_QTY, 0 AS HOLD_CELL_QTY       
		      		, 0 AS UNINSPEC_CELL_QTY, 0 AS BOX_PACKING_CELL_QTY, 0 AS LONG_TERM_CELL_QTY 
			FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)       
					LEFT OUTER JOIN  SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)                      
					ON     C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.       
					AND    A.SITE_ID = C.SEGMENT1                     
					AND    A.ITEM_ID = C.SEGMENT4                     
			WHERE  1=1           
			AND    A.CUTOFF_DATE = CONVERT(DATETIME,'20221011')                      
			AND    A.PACK_MOVE_QTY > 0                        
			AND   EXISTS (       
	              		SELECT 1                            
	              		FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK), SCM_FACTORY_M F2 WITH(NOLOCK)              
	              		WHERE  FF.FACTORY_ID  = F2.FACTORY_ID                       
	              		AND    F2.SITE_ID     = A.SITE_ID   
	              		AND    FF.INSTANCE_ID = 'PL_PACK' ---> INSTANCE ??    
	              		AND    FF.ACTIVE_FLAG = 'Y'       
			)     
			AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
			UNION ALL          
						*/
			/**** BOH(CELL) 재고 ****/                      
			SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID    
					, 0 AS GOOD_QTY, 0 AS HOLD_QTY
					, SUM(A.INTRANSIT_QTY)  AS INTRANSIT_QTY                 
					, SUM(A.BOH_QTY)  AS GOOD_CELL_QTY		                      
					, SUM(A.HOLD_QTY) AS HOLD_CELL_QTYAS			              
					, SUM(A.UNINSPEC_BOH_QTY) AS UNINSPEC_CELL_QTY	              
					, SUM(A.BOX_PACKING_BOH_QTY) AS BOX_PACKING_CELL_QTY         
					, SUM(A.LONG_TERM_BOH_QTY) AS LONG_TERM_CELL_QTY         
			FROM   (           
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID                      
	            				, ISNULL(C.SEGMENT3 , FP_APPLY_ITEM_ID)  AS ITEM_ID          
	            				, A.WIPHOLD_YN      
	            				, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, 'N') = 'Y' THEN A.FP_APPLY_WIPQTY  ELSE NULL END AS INTRANSIT_QTY  
	            				, CASE WHEN A.LOT_PACKING_TYPE <> 'UI' AND  A.QLTY_NO_INSP_FLAG != 'Y' AND CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112)	AND WIPHOLD_YN <> 'Y' AND A.LONG_TERM_FLAG = 'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOH_QTY        
	            				, CASE WHEN A.LOT_PACKING_TYPE = 'UI' AND  A.QLTY_NO_INSP_FLAG <> 'Y' AND CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112)	AND WIPHOLD_YN <> 'Y' AND A.LONG_TERM_FLAG =  'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS BOX_PACKING_BOH_QTY        
	            				, CASE WHEN WIPHOLD_YN = 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS HOLD_QTY        
	            				, CASE WHEN A.QLTY_NO_INSP_FLAG = 'Y' AND WIPHOLD_YN = 'N' 	AND A.LONG_TERM_FLAG =  'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS UNINSPEC_BOH_QTY         
	            				, CASE WHEN ISNULL(A.LONG_TERM_FLAG, 'N') = 'Y' AND WIPHOLD_YN = 'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  THEN  A.FP_APPLY_WIPQTY  ELSE NULL END AS LONG_TERM_BOH_QTY        
	            				, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND WIPHOLD_YN < > 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  THEN  A.MODIFY_FP_APPLY_WIPQTY  ELSE NULL END AS BOH_MODIFY_QTY                    
	            				, CASE WHEN WIPHOLD_YN = 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  THEN  A.MODIFY_FP_APPLY_WIPQTY ELSE NULL END AS HOLD_MODIFY_QTY                     
						FROM   SCM_STOCK_H A WITH(NOLOCK)       
	            				LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)             
	            				ON  C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.
	            				AND A.SITE_ID          = C.SEGMENT1     
	            				AND A.ITEM_ID          = C.SEGMENT4     
						WHERE EXISTS (                          
	            						SELECT 1                            
	            						FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)                
	            						WHERE  FF.FACTORY_ID  = A.FACTORY_ID
										AND FF.INSTANCE_ID = N'PL_FORM_A' 
	            						AND    FF.ACTIVE_FLAG = 'Y'       
	            					)          
						AND 0=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 stock 쪽은 비활성화
								SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_SSP      
								FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)                  
								WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'       
								AND    A.ACTIVE_FLAG = 'Y'        
								AND    A.SEGMENT1 = 'PL_PACK' ) 
						AND   A.CUTOFF_DATE  = CONVERT(DATE,'20221011') --->  ???? ?? INSTANCE DATE           
						AND   A.STOCK_TYPE  = 'WIP'  --- 재고 검색조건                 
						AND   ISNULL(A.FP_APPLY_WIPQTY, 0) >= 0 
						AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
						UNION ALL      
						-- SSP 재고 정보                            
						SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.WIPHOLD_YN 
							, 0 AS INTRANSIT_QTY    
	              				, 0 AS BOX_PACKING_BOH_QTY            
	              				, 0 AS UNINSPEC_BOH_QTY            
	              				, 0 AS LONG_TERM_BOH_QTY            
	              				, SUM(A.BOH_QTY) AS BOH_QTY            
	              				, SUM(A.HOLD_QTY) AS HOLD_QTY          
	              				, SUM(A.BOH_MODIFY_QTY) AS BOH_MODIFY_QTY                      
	              				, SUM(A.HOLD_MODIFY_QTY) AS HOLD_MODIFY_QTY                    
						FROM (         
									SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, ISNULL(C.SEGMENT3, ITEM_ID) AS ITEM_ID           
	                    						, A.HOLD AS WIPHOLD_YN         
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN A.QTY ELSE 0 END AS BOH_QTY                            
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN 0 ELSE A.QTY END AS HOLD_QTY                           
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN A.QTY ELSE 0 END AS BOH_MODIFY_QTY                     
	                    						, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) <= CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND HOLD <> 'Y' THEN 0 ELSE A.QTY END AS HOLD_MODIFY_QTY                    
									FROM   FP_SSP_STOCK_BACKUP_H A WITH(NOLOCK)                     
											LEFT OUTER JOIN SCM_SYS_LOOKUP_VALUE C WITH(NOLOCK)               
											ON    C.LOOKUP_TYPE_CODE = 'MODULE_CELL_GROUP'   ---> 대치품은 cell_group으로 item_id 삼는다.
											AND   A.SITE_ID          = C.SEGMENT1     
											AND   A.ITEM_ID          = C.SEGMENT4     
									WHERE EXISTS (                          
	            									SELECT 1                            
	            									FROM   FP_INSTANCE_FACTORY_M FF WITH(NOLOCK)                
	            									WHERE  FF.FACTORY_ID  = A.FACTORY_ID
													AND FF.INSTANCE_ID = N'PL_FORM_A' 
	            									AND    FF.ACTIVE_FLAG = 'Y'       
												)          
									AND 1=( -- 인스턴스별 SSP 재고 사용여부 : SSP 이면 SSP 쪽 활성화  
	                      					SELECT ISNULL(MAX(CASE WHEN A.ATTRIBUTE1 = 'SSP' THEN 1 ELSE 0 END), 1) AS IS_SSP  
	                      					FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              
	                      					WHERE  A.LOOKUP_TYPE_CODE = 'INSTANCE_STOCK_SOURCE'   
	                      					AND    A.ACTIVE_FLAG = 'Y'    
	                      					AND    A.SEGMENT1 = 'PL_PACK' )                     
									AND   A.CUTOFF_DATE = CONVERT(DATETIME,'20221011')             
									AND   A.QTY > 0     
									AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
							) A              
						GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.ITEM_ID, A.WIPHOLD_YN 
					) A                
				WHERE 1=1          
				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID  
		) A                    
		LEFT OUTER JOIN (														-- Hazel Park Plant mapping 시켜줌                            
							SELECT  A.ATTRIBUTE1 AS SITE_ID, A.ATTRIBUTE2 AS DIVISION_ID, A.ATTRIBUTE3 AS PLANT_ID                            
									, A.ATTRIBUTE4 AS REF_SITE_ID, A.ATTRIBUTE5 AS REF_DIVISION_ID, A.ATTRIBUTE6 AS REF_PLANT_ID              
							FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)              
							WHERE  A.LOOKUP_TYPE_CODE = 'FORMATION_PACK_INSTANCE_MAP'                          
							AND    A.ACTIVE_FLAG = 'Y'    
							AND	   A.SEGMENT4 = 'DU'      
		) D                    
			ON  A.DIVISION_ID  	= D.REF_DIVISION_ID         
			AND A.SITE_ID      	= D.REF_SITE_ID             
			AND A.PLANT_ID     	= D.REF_PLANT_ID            
WHERE 1=1  
AND   A.ITEM_ID = 'ACEN4069I-A1-D06'
GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, ISNULL(D.PLANT_ID, A.PLANT_ID), A.ITEM_ID 
;

--통합 PSI BOH

SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID									
			, ISNULL(SUM(QTY),0) AS BOH_QTY		
			, ISNULL(SUM(GOOD_QTY),0) AS GOOD_QTY		
			, ISNULL(SUM(HOLD_QTY),0) AS HOLD_QTY		
			, ISNULL(SUM(UNINSPEC_BOH_QTY),0) AS UNINSPEC_BOH_QTY		
			, ISNULL(SUM(LONG_TERM_BOH_QTY),0) AS LONG_TERM_BOH_QTY		
			, ISNULL(SUM(INTRANSIT_QTY),0) AS INTRANSIT_QTY		
--	INTO #T_STOCK_FORM                                                 
	FROM   (                                                           
	    	/* ?? ERP BOH ?? ?? */                                       
	    	SELECT	A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FP_APPLY_OPERATION_ID, A.QTY2 AS QTY                               
	    			, ISNULL(WIPHOLD_YN,'N') AS WIPHOLD_YN                 
					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND  ISNULL(WIPHOLD_YN,'N') < > 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN A.QTY2 ELSE NULL END AS GOOD_QTY    	   
					, CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND A.PACK_MOVE_FLAG != 'Y' THEN A.QTY2 ELSE NULL END AS HOLD_QTY                      																				   
					, CASE WHEN A.QLTY_NO_INSP_FLAG = 'Y' AND WIPHOLD_YN = 'N' 	AND A.LONG_TERM_FLAG =  'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN  A.QTY2  ELSE NULL END AS UNINSPEC_BOH_QTY      							   
					, CASE WHEN ISNULL(A.LONG_TERM_FLAG, 'N') = 'Y' AND WIPHOLD_YN = 'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y' THEN  A.QTY2  ELSE NULL END AS LONG_TERM_BOH_QTY					 								   
					, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, 'N') = 'Y' THEN A.QTY2 ELSE NULL END  AS INTRANSIT_QTY										 																				   
	    			, A.FP_APPLY_ITEM_ID AS ITEM_ID                          
	    			, IM.FLOW_ID , IM.LEVEL_1_CODE, IM.LEVEL_2_CODE, IM.LEVEL_2_NAME, IM.LEVEL_3_CODE, IM.LEVEL_3_NAME         
	    	FROM   SCM_STOCK_H A WITH(NOLOCK)                            
	    			INNER HASH JOIN                                          
	    					(                                                    
							SELECT *                                               
							FROM	#T_ITEM                                          
							WHERE	1=1                                              
							AND		SHOP_FLAG = 'CELL'                             
	    			) IM                                                     
	    			ON   IM.COMPANY_ID  = A.COMPANY_ID                       
	    			AND  IM.DIVISION_ID = A.DIVISION_ID                      
	    			AND  IM.SITE_ID     = A.SITE_ID                          
	    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                 
	    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       
	    					SELECT B.LOOKUP_TYPE_CODE                            
	    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      
	    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                                  
	    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   
	    					WHERE  A.ACTIVE_FLAG = 'Y'                         
	    					AND    B.ACTIVE_FLAG = 'Y'                         
	    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       
	    					AND    A.LOOKUP_TYPE_CODE = 'SIMULATION_BOH'       
	    					AND    B.SEGMENT1         = 'CELL_SIMULATION'      
	    					AND    B.SEGMENT2         = 'A004'            
	    			) V                                                      
	    			ON   A.DIVISION_ID           = V.DIVISION_ID             
	    			AND  A.SITE_ID               = V.SITE_ID                 
	    			AND  A.PLANT_ID              = V.PLANT_ID                
	    			AND  A.STOCK_TYPE            = V.STOCK_TYPE              
	    			AND  A.STORAGE_ID            = V.STOCK_POINT             
	    			AND  V.CELL_BOH              = 'Y'         --- ??BOH ?? ??                                            
	    	WHERE 1=1                                                    
			AND	 A.CUTOFF_DATE ='20221011'---> instance date             
			AND  A.SITE_ID = 'A004'                                      
	    	AND  A.STOCK_TYPE  = 'INVENTORY'  ---  ERP ??              
	    	AND  A.QTY2 > 0         
	    	AND 		A.ITEM_ID = 'ACEN4069I-A1-D06'
	    	--AND EXISTS (                                               
	     -- 					SELECT 1                                         
	     -- 					FROM   FP_INSTANCE_INFO_V VV WITH(NOLOCK)        
	     -- 					WHERE  VV.INSTANCE_ID ='PL_FORM_A'             
	     -- 					AND    A.COMPANY_ID   = VV.COMPANY_ID            
	     -- 					AND    A.DIVISION_ID  = VV.DIVISION_ID           
	     -- 					AND    A.SITE_ID      = VV.SITE_ID               
	    	--			)                                                    
	    	UNION ALL                                                    
	    	/* ?? MES BOH ??                                             
	    	** ????: P5000 ?????? CELL??? ???? ?????.  */                
	    	SELECT	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID ,		A.OPERATION_ID AS OPERATION_ID                                        
	    			, (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN FP_APPLY_WIPQTY * BB.BOM_RATE ELSE FP_APPLY_WIPQTY END) AS QTY                                                           
	    			, ISNULL(WIPHOLD_YN,'N') AS WIPHOLD_YN                 
					, CASE WHEN CONVERT(VARCHAR,A.AVAILABLE_DATE,112) < = CONVERT(VARCHAR,A.CUTOFF_DATE,112) AND  ISNULL(WIPHOLD_YN,'N') < > 'Y' 
						       AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'  AND  A.QLTY_NO_INSP_FLAG != 'Y' AND A.LONG_TERM_FLAG !=  'Y'
					    	THEN  CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN FP_APPLY_WIPQTY * BB.BOM_RATE ELSE FP_APPLY_WIPQTY END                                                       
					    	ELSE NULL END AS GOOD_QTY                            																										   
					, CASE WHEN ISNULL(WIPHOLD_YN,'N') = 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'           																		   
					        THEN (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN FP_APPLY_WIPQTY * BB.BOM_RATE ELSE FP_APPLY_WIPQTY END)                                                      
					        ELSE NULL END AS HOLD_QTY                        																											   
					, CASE WHEN A.QLTY_NO_INSP_FLAG = 'Y' AND WIPHOLD_YN != 'Y' AND A.LONG_TERM_FLAG != 'Y' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'									   
								THEN  (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN A.FP_APPLY_WIPQTY * BB.BOM_RATE ELSE A.FP_APPLY_WIPQTY END)   										   
								ELSE NULL END AS UNINSPEC_BOH_QTY                                                                                										   
					, CASE WHEN ISNULL(A.LONG_TERM_FLAG, 'N') = 'Y' AND WIPHOLD_YN = 'N' AND ISNULL(A.PACK_MOVE_FLAG, 'N') != 'Y'                                 						   
								THEN  (CASE WHEN BB.CHILD_ITEM_ID IS NOT NULL THEN A.FP_APPLY_WIPQTY * BB.BOM_RATE ELSE A.FP_APPLY_WIPQTY END)   										   
								ELSE NULL END AS LONG_TERM_BOH_QTY                                                                               										   
					, CASE WHEN ISNULL(A.PACK_MOVE_FLAG, 'N') = 'Y' THEN A.QTY2 ELSE NULL END  AS INTRANSIT_QTY	                                                                
	    			, ISNULL(BB.CHILD_ITEM_ID, A.FP_APPLY_ITEM_ID) AS ITEM_ID                                               
	    			, IM.FLOW_ID , IM.LEVEL_1_CODE, IM.LEVEL_2_CODE, IM.LEVEL_2_NAME, IM.LEVEL_3_CODE, IM.LEVEL_3_NAME         
	    	FROM   SCM_STOCK_H A WITH(NOLOCK)                            
	    			INNER HASH JOIN                                          
	    					( --<IM: ITEM CODE ??? >--                           
	    					SELECT  I.COMPANY_ID , I.DIVISION_ID, I.SITE_ID , I.ITEM_ID , I.ITEM_CLASS , RIGHT(I.FLOW_ID,5) AS FLOW_ID , S.CLASS_NAME , S.LEVEL                                 
	    							, S.LEVEL_1_CODE , S.LEVEL_1_NAME , S.LEVEL_1_ID                                                
	    							, S.LEVEL_2_CODE , S.LEVEL_2_NAME , S.LEVEL_2_ID                                                
	    							, S.LEVEL_3_CODE , S.LEVEL_3_NAME , S.LEVEL_3_ID                                                
	    							, S.LEVEL_4_CODE , S.LEVEL_4_NAME , S.LEVEL_4_ID                                                
	    							, S.LEVEL_5_CODE , S.LEVEL_5_NAME , S.LEVEL_5_ID                                                
	    					FROM    SCM_ITEM_M I WITH(NOLOCK), SCM_ITEM_CLASS_M S WITH(NOLOCK)                                  
	    					WHERE  1=1                                           
							AND	   I.SITE_ID = 'A004'                            
							AND    I.ITEM_CLASS   = S.CLASS_ID                     
	    					AND    I.ACTIVE_FLAG  = 'Y'                        
	    					AND    S.USE_FLAG     = 'Y'                        
	    					AND    S.LEVEL_3_NAME IN ( 'Cell' , 'Module Automotive Assembly' )                              
	    					AND    RIGHT(I.FLOW_ID,5) IN ( 'A9000','A3000','P5000' )                                      
	    			) IM                                                     
	    			ON   1=1                                                 
	    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                 
	    			AND  IM.COMPANY_ID  = A.COMPANY_ID                       
	    			AND  IM.DIVISION_ID = A.DIVISION_ID                      
	    			AND  IM.SITE_ID     = A.SITE_ID                          
	    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       
	    					SELECT B.LOOKUP_TYPE_CODE                            
	    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      
	    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH, B.ATTRIBUTE5 AS STOCK_STATUS                                                 
	    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   
	    					WHERE  A.ACTIVE_FLAG = 'Y'                         
	    					AND    B.ACTIVE_FLAG = 'Y'                         
	    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       
	    					AND    A.LOOKUP_TYPE_CODE = 'SIMULATION_BOH'       
	    					AND    B.SEGMENT1         = 'CELL_SIMULATION'      
	    					AND    B.SEGMENT2         = 'A004'            
	    			) V                                                      
	    			ON   A.SITE_ID               = V.SITE_ID                 
	    			AND  A.DIVISION_ID           = V.DIVISION_ID             
	    			AND  A.PLANT_ID              = V.PLANT_ID                
	    			AND  A.STOCK_TYPE            = V.STOCK_TYPE              
	    			AND  A.OPERATION_ID			 = V.STOCK_POINT             
	    			AND  V.CELL_BOH              = 'Y'         --->  BOH??? ??? ?? ????? ?.       
	    			AND 	A.STOCK_STATUS		    = CASE WHEN V.STOCK_STATUS IS NULL THEN A.STOCK_STATUS ELSE V.STOCK_STATUS END                        
	    			LEFT OUTER HASH JOIN ( --<BB: P5000 ITEM? CELL??? ??: ALT_PRIORITY1??? ????. >--                        
	    					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID , A.PARENT_ITEM_ID , A.CHILD_ITEM_ID , A.ALT_PRIORITY                                                     
	    							, A.CHILD_QTY/A.PARENT_QTY AS BOM_RATE           
	    					FROM	SCM_BOM_M A WITH(NOLOCK)                       
	    							INNER HASH JOIN  ( --: ???? CELL ?? ??           
											SELECT *                                       
											FROM	#T_ITEM                                  
											WHERE	1=1                                      
											AND		SHOP_FLAG = 'CELL'                     
	    									--SELECT CC.COMPANY_ID , CC.DIVISION_ID , CC.SITE_ID, CC.ITEM_ID , CC.ITEM_CLASS , DD.LEVEL_3_CODE, DD.LEVEL_3_NAME, CC.FLOW_ID                             
	    									--FROM   SCM_ITEM_M CC WITH(NOLOCK), SCM_ITEM_CLASS_M DD WITH(NOLOCK)                       
	    									--WHERE 1=1                                  
	    									--AND  CC.ITEM_CLASS    = DD.CLASS_ID        
	    									--AND  CC.ACTIVE_FLAG   = 'Y'              
	    									--AND  DD.USE_FLAG      = 'Y'              
	    									--AND  DD.LEVEL_3_NAME  = 'Cell'           
	    									--AND  RIGHT(ISNULL(CC.FLOW_ID,'Z'),5)  IN ('A9000', 'A3000' )                        
	    							) EE                                             
	    							ON   1=1                                         
	    							AND  A.COMPANY_ID  = EE.COMPANY_ID               
	    							AND  A.DIVISION_ID = EE.DIVISION_ID              
	    							AND  A.SITE_ID     = EE.SITE_ID                  
	    							AND  A.CHILD_ITEM_ID = EE.ITEM_ID                
	    					WHERE 1=1                                            
							AND	  A.SITE_ID = 'A004'                             
	    					AND   CONVERT(NVARCHAR(8),A.EFF_END_DATE,112)   >'20221011'                                       
	    					AND   CONVERT(NVARCHAR(8),A.EFF_START_DATE,112) <='20221011'                                      
	    					AND   ISNULL(A.ALT_PRIORITY,1) = 1                   
	    			) BB                                                     
	    			ON  1=1                                                  
	    			AND  A.SITE_ID          = BB.SITE_ID                     
	    			AND  A.DIVISION_ID      = BB.DIVISION_ID                 
	    			AND  A.PLANT_ID         = BB.PLANT_ID                    
	    			AND  A.FP_APPLY_ITEM_ID = BB.PARENT_ITEM_ID              
	    	WHERE 1=1                                                    
			AND	 A.CUTOFF_DATE = '20221011'                              
			AND  A.SITE_ID = 'A004'                                      
	    	AND  A.STORAGE_ID   = 'MES'                                
	    	AND  A.STOCK_TYPE   = 'WIP'     --- MES ??                 
	    	--AND EXISTS (                                               
	    	--	SELECT 1                                                 
	    	--	FROM   FP_INSTANCE_INFO_V VV WITH(NOLOCK)                
	    	--	WHERE  VV.INSTANCE_ID ='PL_FORM_A'                     
	    	--	AND    A.COMPANY_ID   = VV.COMPANY_ID                    
	    	--	AND    A.DIVISION_ID  = VV.DIVISION_ID                   
	    	--	AND    A.SITE_ID      = VV.SITE_ID                       
	    	--)                                                          
	    	AND  A.FP_APPLY_WIPQTY > 0      
--	    	AND 		A.ITEM_ID = 'ACEN4069I-A1-D06'
--	    	AND 		BB.CHILD_ITEM_ID = 'ACEN4069I-A1-D06'
	    	AND 		ISNULL(BB.CHILD_ITEM_ID, A.FP_APPLY_ITEM_ID) = 'ACEN4069I-A1-D06'
			UNION ALL                                                                                   									
			SELECT	A.COMPANY_ID , A.DIVISION_ID , A.SITE_ID , A.PLANT_ID , IM.FLOW_ID AS OPERATION_ID                    
					, 0 AS QTY                                                                                            
					, 'N' AS WIPHOLD_YN                                                                                   
					, 0 AS GOOD_QTY		                                                                                    
					, 0 AS HOLD_QTY                                                                                       
					, 0 AS UNINSPEC_BOH_QTY                                                                               
			      	, 0 AS LONG_TERM_BOH_QTY                                                                              
					, ISNULL(A.PACK_MOVE_QTY ,0) AS INTRANSIT_QTY                                                         
					, A.ITEM_ID AS ITEM_ID                                                                                
					, IM.FLOW_ID , IM.LEVEL_1_CODE, IM.LEVEL_2_CODE, IM.LEVEL_2_NAME, IM.LEVEL_3_CODE, IM.LEVEL_3_NAME    
	    	FROM   SCM_STOCK_H A WITH(NOLOCK)                            
	    			INNER HASH JOIN                                          
	    					(                                                    
							SELECT *                                               
							FROM	#T_ITEM                                          
							WHERE	1=1                                              
							AND		SHOP_FLAG = 'CELL'                             
	    			) IM                                                     
	    			ON   IM.COMPANY_ID  = A.COMPANY_ID                       
	    			AND  IM.DIVISION_ID = A.DIVISION_ID                      
	    			AND  IM.SITE_ID     = A.SITE_ID                          
	    			AND  IM.ITEM_ID     = A.FP_APPLY_ITEM_ID                 
	    			INNER HASH JOIN ( --<V: LOOKUP? STOCK POINT ?? >--       
	    					SELECT B.LOOKUP_TYPE_CODE                            
	    								, B.SEGMENT1 AS SIMULATION_NAME , B.SEGMENT2 AS SITE_ID , B.SEGMENT3 AS DIVISION_ID , B.SEGMENT4 AS PLANT_ID , B.SEGMENT5 AS STOCK_POINT                      
	    								, B.ATTRIBUTE1 AS STOCK_TYPE , B.ATTRIBUTE2 AS ASSY_BOH , B.ATTRIBUTE3 AS CELL_BOH, B.ATTRIBUTE4 AS PACK_BOH                                                  
	    					FROM   SCM_SYS_LOOKUP_TYPE_M A WITH(NOLOCK), SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)                   
	    					WHERE  A.ACTIVE_FLAG = 'Y'                         
	    					AND    B.ACTIVE_FLAG = 'Y'                         
	    					AND    A.LOOKUP_TYPE_CODE = B.LOOKUP_TYPE_CODE       
	    					AND    A.LOOKUP_TYPE_CODE = 'SIMULATION_BOH'       
	    					AND    B.SEGMENT1         = 'CELL_SIMULATION'      
	    					AND    B.SEGMENT2         = 'A004'            
	    			) V                                                      
	    			ON   A.DIVISION_ID           = V.DIVISION_ID             
	    			AND  A.SITE_ID               = V.SITE_ID                 
	    			AND  A.PLANT_ID              = V.PLANT_ID                
	    			AND  A.STOCK_TYPE            = V.STOCK_TYPE              
	    			AND  A.STORAGE_ID            = V.STOCK_POINT             
	    			AND  V.CELL_BOH              = 'Y'         --- ??BOH ?? ??                                            
	    	WHERE 1=1                                                    
			AND	 A.CUTOFF_DATE ='20221011'---> instance date             
			AND  A.SITE_ID = 'A004'                                      
	    	AND  A.STORAGE_ID  = 'MES'              
	    	AND  A.STOCK_TYPE  = 'WIP'              
	    	AND  A.PACK_MOVE_QTY > 0                
	    	AND 		A.ITEM_ID = 'ACEN4069I-A1-D06'
	) A                                                                
	WHERE 1=1                                                          
	GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.ITEM_ID 

  END

  
END
