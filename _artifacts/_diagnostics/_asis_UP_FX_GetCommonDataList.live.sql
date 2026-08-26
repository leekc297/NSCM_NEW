

                                                                                                                                                             

                                

                   

                 

                  

                   

                 

         

         

                                                                                                                                                          

                                        

                                                                                                                                                          

                                                                                              

                                                                                                        

                                                     

                                                                         

                                                   

                                               

                                                        

                                              

                                                

                                               

                                                    

                                                                   

                                                                            

                                                         

                                                                              

                                                                               

                                                                         

                                                                                                            

                                                 

                                                              

                                                                        

                                                      

                                                  

                                                           

                                                                      

                                                                  

                                                                                                 

                                                                          

                                                                                                                              

                                                              

                                                                       

                                                                                                    

                                                        

                                                         

                                                        

                                                                           

                                                                                

                                                                                       

                                                                          

                                                    

                                                                                                                 

                                                                      

                                                                                 

                                                           

                                                       

                                                                

                                                         

                                                                                          

                                                       

                                                                              

                                                                                               

                                                             

                                                        

                                                                 

                                                                  

                                                       

                                                                                                                              

                                                         

                                                                 

                                                                    

                                                              

                                                                              

                                                                                                              

                                                                                                               

                                                                                                          

                                                     

                                                             

                                                                             

                                                                                                                     

                                                 

                                                                                                                               

                                                                                         

                                                                                                                      

                                                                                           

                                                                                      

                                                                   

                                                                           

                                                    

                                                                                  

                                                                                       

                                                                               

                                                                                    

                                                                                                                         

                                                                                                               

                                                               

                                                                                                

                                                                                                                                  

                                                                            

                                                                                                                          

                                                                                              

                                                                                                       

                                                                                                             

                                                                                                                                 

                                                                                                                   

                                                                                                                     

                                                         

                                                                                                                    

                                                                                                                    

                                                                                                                                          

                                                                                                                          

                                                                                                                

                                                                                            

                                                                                               

                                                                                          

                                                                 

                                                       

                                                                                            

                                                                                             

                                                                                      

                                                                                                                              

                                                                                                     

                                                                                            

                                                                               

                                                                                  

                                                                                                           

                                                                         

                                                                                                       

                                                                  

                                                        

                                                                  

                                                    

                                                                      

                                                     

                                                                

                                                                                                                        

                                                                                                            

                                                                                                            

                                                                                                             

                                                                                                            

                                                                                                                                  

                                                                                                                                        

                                                                                                                               

                                                                                                                          

                                                                                                                                  

                                           

                                                                            

                                                           

                                                                                          

                                                                                                                         

                                                                                                                           

                                                                        

                                                                       

                                                            

                                                                         

                                                                                    

                                                                    

                                                                    

                                                                                 

                                                                            

                                                                            

                                                                                                       

                                                                                                                                                             



                                                                                 



                                       





         

                                                   

                              

                                                         

                                                         

                                

                        

                  

                        

                  

                                     

                                                   





*********************************************************************************/





        

            

                                                  

CREATE PROCEDURE [dbo].[UP_FX_GetCommonDataList]

	  @Code	NVARCHAR(100)

	, @Param1 NVARCHAR(MAX)

	, @Param2 NVARCHAR(MAX)

	, @Param3 NVARCHAR(MAX)

	, @Param4 NVARCHAR(MAX)

	, @Param5 NVARCHAR(MAX)

	, @TimeZone NVARCHAR(MAX) = 'AS054'

AS

BEGIN

		SET NOCOUNT ON;



    DECLARE @v_dept_id nvarchar(50)='';

	DECLARE @v_group_id nvarchar(50)='';



	DECLARE @exception_company TABLE ( company_id nvarchar(100) );	                                        



	                

	                

	                               

	                             

	                           



	                                                                                              

	                                                                      

	                                                                                              



										                                                      

										                                                              

										                                             

										                                                                          

										                                          

										                           





	SET @v_dept_id = (SELECT TOP 1 isnull(DEPT_ID,'')

								FROM

									(

									SELECT DEPT_ID FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

										WHERE  U.UserID = @Param4



									UNION ALL



									                            

									SELECT isnull( (

													select TOP 1 SEGMENT3

														from  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

														where LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

														and SEGMENT1         =   U.DEPT_ID AND VALID_YN = 'Y'

													) , U.DEPT_ID

												)

									FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

										WHERE  U.UserID = @Param4

									) A

						)



			;



	                                                                                              

	                                                                    

	                                                                                              



	                                                                        

	                            

	                                                                                 

	                                                                     

	                                                                                 

	IF ISNULL((

				SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

					where LOOKUP_TYPE = 'GET_ADMIN_GROUP'

						AND VALID_YN = 'Y'

						                                                          

						AND SEGMENT2 in ('ALL','DMF0003')                                      

						AND SEGMENT1 = @Param3

			  ),0) > 0

		BEGIN

			SET @v_group_id = 'ADMIN'

		END

	                                                                                 

	                                                                   

	                                                                                 



		                                                 

                      

                                         



                                                                                          

                        

           

                        

                    

                       

                                                   

		IF @Code = 'Division'



			BEGIN

				                                                                                        

				                                                                                                                                

				                      

				                      

				SELECT DIVISION_ID AS CODE, DIVISION_ID AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)

				WHERE (@Param1 IS NULL OR DIVISION_ID LIKE '%' + @Param1 + '%') OR (@Param1 IS NULL OR DIVISION_NAME LIKE '%' + @Param1 + '%')

				GROUP BY DIVISION_ID

				ORDER BY DIVISION_ID

			END





		        

		                       

		IF @Code = 'Plant'



			BEGIN

				SELECT distinct S.PLANT_ID      AS CODE

					, MAX((CASE

					   WHEN A.PLANT_NAME IS NULL

					    THEN V.VENDOR_NAME

					   ELSE A.PLANT_NAME

					   END ))		   AS NAME

				FROM  SCM_MST_SITE S WITH(NOLOCK)

				LEFT OUTER JOIN  SCM_MST_PLANT_SN A  WITH(NOLOCK) ON A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.PLANT_ID                                           

				LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID

				WHERE (@Param1 IS NULL OR S.DIVISION_ID = @Param1)

					  AND

					  (

						(@Param2 IS NULL OR S.PLANT_ID LIKE '%' + @Param2 + '%') OR (@Param2 IS NULL OR PLANT_NAME LIKE '%' + @Param2 + '%')

					  )

				AND  S.VALID_YN ='Y'

				GROUP BY S.PLANT_ID

				ORDER BY S.PLANT_ID

			END



		           

		                       

		IF @Code = 'Customer'



			BEGIN

				SELECT SOLDTO_CODE AS CODE, SOLDTO_DESCRIPTION AS NAME FROM SCM_MST_CUSTOMER

				WHERE (@Param1 IS NULL OR DIVISION_ID = @Param1)

					  AND

					  (

						(@Param2 IS NULL OR SOLDTO_CODE LIKE '%' + @Param2 + '%') OR (@Param2 IS NULL OR SOLDTO_DESCRIPTION LIKE '%' + @Param2 + '%')

					  )

				group by SOLDTO_CODE,	SOLDTO_DESCRIPTION

				ORDER BY SOLDTO_DESCRIPTION



			END





		                   

		                                    

		IF @Code = 'MyDivision'



			BEGIN

				        

				                                                    

				      

				                                        

				       

				                 

				                                                                                                                                    

				          

				              

				                      



				Declare @AuthTypePara varchar(100) = 'D'

				if(@Param1 = 'JV Planner') SET @AuthTypePara = 'J';



	SELECT

		DIVISION_ID AS CODE, DIVISION_ID + ' ' + MIN([DIVISION_NAME]) AS NAME

		                                          

    FROM

		[dbo].[SCM_MST_DIVISION] A WITH(NOLOCK)

    WHERE

	    A.ATTRIBUTE3 <> 'EE'

		AND DIVISION_ID IN

		(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = @AuthTypePara)

		                                                                                                                                    

		                                       

		AND VALID_YN = 'Y'

				GROUP BY

					DIVISION_ID, ATTRIBUTE1

				                      

				ORDER BY ATTRIBUTE1

			END



		                          

		                                                          

		IF @Code = 'Auth_Plant'



			BEGIN

				SELECT

					 s.plant_id         AS CODE

					,s.site_description AS NAME

				FROM  SCM_MST_SITE S

				WHERE  1 = 1

				AND S.SITE_TYPE ='PLANT'

				AND S.PLANT_ID IS NOT NULL

				AND S.VALID_YN ='Y'

				AND

					S.DIVISION_ID IN

					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')

				AND

					S.PLANT_ID IN

					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					                                                             

					                                                                                        

					                                  

					   WHERE PrntCode IN ( SELECT token FROM dbo.String_Split(@Param3,',') )

					   AND GroupID = @Param1

					   AND UserID = @Param2

					   AND AuthType = 'P')

				ORDER BY S.PLANT_ID

			END



		                             

		                                                          

		IF @Code = 'Auth_Customer'



			BEGIN

				SELECT

					SOLDTO_CODE AS CODE, SOLDTO_DESCRIPTION AS NAME FROM SCM_MST_CUSTOMER WITH(NOLOCK)

				WHERE

					DIVISION_ID = @Param3

					AND

					SOLDTO_CODE IN

					(SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE PrntCode = @Param3 AND GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'C')

				ORDER BY SOLDTO_CODE

			END



		           

		IF @Code = 'Language'



			BEGIN

				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

				WHERE LOOKUP_TYPE = 'LANGUAGE'

				  AND VALID_YN = 'Y'

				ORDER BY DISPLAY_SEQ

			END



		           

		IF @Code = 'TimeZone'



			BEGIN

				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

				WHERE LOOKUP_TYPE = 'TIME_ZONE'

				  AND VALID_YN = 'Y'

				ORDER BY DISPLAY_SEQ

			END



		           

		IF @Code = 'BodType'



			BEGIN

				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

				WHERE LOOKUP_TYPE = 'BOD_TYPE_CODE'

				ORDER BY DISPLAY_SEQ

			END



		                 

		IF @Code = 'TransportMode'



			BEGIN

				                                                      

				                                                                                          

				                                           

				                      



				SELECT L.SEGMENT1  AS CODE

					 , L.SEGMENT1  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'

				ORDER BY L.DISPLAY_SEQ			END



		              

		IF @Code = 'PeriodType'



			BEGIN

				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

				WHERE LOOKUP_TYPE = 'PERIOD_TYPE'

				ORDER BY DISPLAY_SEQ

			END



		                 



		                      



		        

		                                                                              

		                                       

		                        

		      



		                   

		                           



		        

		                                                                              

		                                        

		                        

		      



		               

		                         



		        

		                                                 

		                                           

		                                                                                    

		                                          

		                          

		      



		              

		                       



		        

		                                                                              

		                                         

		                        

		      



		                      

		                              



		        

		                                                                              

		                                           

		                        

		      



		                   

		                            



		        

		                                                                              

		                                        

		                        

		      



		                 

		                          



		        

		                                                                              

		                                      

		                        

		      



		                   

		                            



		        

		                                                                              

		                                        

		                        

		      



		          

		IF @Code = 'GroupID'



			BEGIN

				SELECT GroupID AS CODE, GrpName AS NAME FROM TB_FX_GROUPINFO  WITH(NOLOCK)

				ORDER BY GroupID

			END



		             

		IF @Code = 'MyGroupID'



			BEGIN

				SELECT G.GroupID AS CODE, G.GrpName AS NAME FROM TB_FX_GroupInfo G WITH(NOLOCK) , TB_FX_UserGroupinfo U  WITH(NOLOCK)

				WHERE G.UseYN = 'Y' AND U.UseYN = 'Y' AND G.GroupID = U.GroupID AND U.UserID = U.UserID AND U.UserID = @Param1

				  AND G.GroupID != 'Guest'

				ORDER BY G.GroupID

			END



		                 

		IF @Code = 'MyGroupIDALL'



			BEGIN

				SELECT G.GroupID AS CODE, G.GrpName AS NAME FROM TB_FX_GroupInfo G WITH(NOLOCK) , TB_FX_UserGroupInfo U  WITH(NOLOCK)

				WHERE U.UseYN = 'Y' AND G.GroupID = U.GroupID AND U.UserID = U.UserID AND U.UserID = @Param1

				ORDER BY G.GroupID

			END



		       

		IF @Code = 'Dept'



		BEGIN

			SELECT DEPT_ID AS CODE,

				NAME =

				CASE @Param1

					WHEN 'KO' THEN DEPT_NAME_KO

					WHEN 'EN' THEN DEPT_NAME_EN

					WHEN 'CN' THEN DEPT_NAME_CN

				END

				FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK)

				WHERE (@Param2 IS NULL OR DEPT_ID LIKE '%' + @Param2 + '%')

				OR (@Param2 IS NULL OR DEPT_NAME_KO LIKE '%' + @Param2 + '%')

				OR (@Param2 IS NULL OR DEPT_NAME_EN LIKE '%' + @Param2 + '%')

				OR (@Param2 IS NULL OR DEPT_NAME_CN LIKE '%' + @Param2 + '%')

				ORDER BY CODE

		END



		                                                 

                              

                                                        

                                                  

                                                                     

          

          

                        

                  

                     

                                                   

		IF @Code = 'FromSiteByDivision'



		BEGIN

			Declare @AuthTypeParaDivision varchar(100) = 'D'

			if(@Param2 = 'JV Planner') SET @AuthTypeParaDivision = 'J';



			SELECT	SCM_SITE_ID        AS CODE

				,	SCM_SITE_ID		   AS NAME

				                                                 

			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)

			WHERE SITE_TYPE = 'PLANT'

			AND    A.VALID_YN  = 'Y'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1

					 ELSE A.DIVISION_ID

				END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')



				                                                      

                                                                                                                                                  

                                         				                   

						)



			AND    A.DIVISION_ID IN (SELECT CODE							                   

		    FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			 WHERE  GroupID LIKE '%'+ @Param2 + '%'

							    	 AND    UserID  LIKE '%'+ @Param3 + '%'

								     AND    AuthType = @AuthTypeParaDivision)

		END



		                                                 

                              

                                                        

                                                  

                                                                     

          

           

                        

                  

                     

                                                   

		IF @Code = 'ToSiteByDivision'



		BEGIN

			SELECT	 SCM_SITE_ID			AS	CODE

					,SCM_SITE_ID			AS	NAME

					            

						                                                

			FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)

			WHERE   A.VALID_YN  = 'Y'

			AND			CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1

						ELSE A.DIVISION_ID

				   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

								                                             

                                                                                             

                                         		                   

						 )

			AND    A.DIVISION_ID IN (SELECT CODE							                   

		                 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			 WHERE  GroupID LIKE '%'+ @Param2 + '%'

							    	 AND    UserID  LIKE '%'+ @Param3 + '%'

								     AND    AuthType = 'D')

		END



		                        

		                           

		IF @Code = 'SaleSiteByDivision'



		BEGIN

			SELECT A.SCM_SITE_ID AS CODE

				, A.SITE_DESCRIPTION AS NAME

			 FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)

			WHERE  1 = 1

			  AND    A.SITE_TYPE = 'SALES'

			  AND    A.VALID_YN  = 'Y'

			  AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

						                                              

							                                                                                       

							                                 

							)

		END



		                         

		                           

		IF @Code = 'PlantSiteByDivision'



		BEGIN

			 SELECT A.SCM_SITE_ID AS CODE

				   , A.SITE_DESCRIPTION AS NAME

			  FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)

			  WHERE  1 = 1

			    AND    A.SITE_TYPE = 'PLANT'

				AND    A.VALID_YN  = 'Y'

			    AND    A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

							                                            

							                                                                                         

							                                   

							   )

		END



		                             

		                           

		IF @Code = 'PlantSiteByDivisionOSP'			

		

		BEGIN

			 SELECT A.SCM_SITE_ID AS CODE

				   , A.SITE_DESCRIPTION AS NAME

			  FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)

			  WHERE  1 = 1

			  AND    A.SITE_TYPE = 'PLANT'

			  AND    A.VALID_YN  = 'Y'

			  AND    A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')

								                                          

								                                                                                       

								                                 

							   )

			  AND A.OSP_YN ='Y'	

			                        

		END		



		                    

		                           

		IF @Code = 'PlantByDivision'



		BEGIN

		   SELECT A.PLANT_ID      AS CODE

				, A.PLANT_NAME    AS NAME

			FROM  [dbo].[SCM_MST_PLANT_SN] A WITH(NOLOCK)

			WHERE  1 = 1

			AND    A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')

						                                              

							                                                                                       

							                                 

							)

		END



		                    

		                        

		IF @Code = 'BuildingByPlant'



		BEGIN

			SELECT

			  DISTINCT

				   A.FACTORY_ID    AS CODE

				  , A.FACTORY_NAME  AS NAME

			 FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)

			 WHERE 1=1

			AND ((@Param1 IS NULL or @Param1='') OR A.PLANT_ID IN

						( SELECT token FROM dbo.String_Split(@Param1,',')

						                                         

						                                                                                      

						                                

						)

				)

		END





		                       

		                           

		IF @Code = 'BuildingByDivision'



		BEGIN

			SELECT

			  DISTINCT

					A.FACTORY_ID    AS CODE

				  , A.FACTORY_NAME  AS NAME

			 FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)

			 WHERE 1=1

				AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )

				AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )

		END

		                        

		  

                            

                              

                           

    

		IF @Code = 'OperationByBuilding'



		BEGIN



		 SELECT

		 DISTINCT

				A.OPERATION_ID    AS CODE

			  , (A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID

		 FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK)

		 JOIN [dbo].SCM_MST_OPERATION_SN B  WITH(NOLOCK) ON  A.OPERATION_ID = B.OPERATION_ID

		 WHERE 1=1

		 AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                      

					                                

					)

			)



		AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID IN

					( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),',')

					                                         

					                                                                                                     

					                                

					)

			)



		 AND ( (@Param3 IS NULL or @Param3='') OR A.FACTORY_ID IN

					( SELECT token FROM dbo.String_Split(@Param3,',')

					                                         

					                                                                                      

					                                

					)

			)

			ORDER BY A.OPERATION_ID

		END



		IF @Code = 'LocationGroupByCapa'

		BEGIN

			SELECT SEGMENT4 as code, d.OPERATION_NAME as name

			FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)

			    join  SCM_MST_OPERATION_SN d  WITH(NOLOCK) on b.SEGMENT4 =  d.OPERATION_ID

			WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'

			AND    b.valid_yn = 'Y'

			AND    b.segment3 = 'Y'

			AND    (@Param1 IS NULL OR @Param1='' OR @Param1 IN (SELECT TOKEN FROM dbo.String_Split(b.segment5,',')))

			GROUP BY SEGMENT4,d.OPERATION_NAME

			ORDER BY OPERATION_NAME

		END



		            

		  



    

		IF @Code = 'Incoterms'





			BEGIN

				SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

				WHERE LOOKUP_TYPE = 'INCOTERMS'

				AND   VALID_YN = 'Y'                                            

				ORDER BY DISPLAY_SEQ

			END





		                                                 

                                         

                                                         

                                                         

                                                                                          

          

           

                        

                  

                        

                                                                                      

                                                   



		IF @Code = 'EndCustomerByDivisionDept'



			BEGIN

				SELECT DISTINCT

						A.END_CUSTOMER AS CODE

						, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME

				FROM   SCM_MST_SITE A WITH(NOLOCK)

				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)

					ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'

				WHERE  1 = 1

				AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1                  

							ELSE A.DIVISION_ID

						END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@Param1,',')

								                                         

                                                                                                                                       

                                                          

								)

				AND    CASE WHEN @Param2 = 'ALL'  OR  @Param2 ='' THEN @Param2                  

							ELSE A.DEPT_ID

						END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@Param2,',')

								                                         

                                                                                                                                       

                                                          

				)

				AND    A.DIVISION_ID IN (SELECT CODE

									FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK)

					    					WHERE  GROUPID LIKE '%'+ @Param3 + '%'

											AND    USERID  LIKE '%'+ @Param4 + '%'

											AND    AUTHTYPE = 'D')

				AND    END_CUSTOMER IS NOT NULL

				ORDER BY A.END_CUSTOMER



		END





		                                                 

                                  

                                                         

                                                         

                                                                                                            

          

           

                        

                  

                        

                                                   



	IF @Code = 'SiteByEndCustomer'



		BEGIN

			Declare @AuthTypeParaSite varchar(100) = 'D'

			if(@Param3 = 'JV Planner') SET @AuthTypeParaSite = 'J';

			IF (@Param1 <> '40')

			BEGIN

				SELECT DISTINCT

					   SCM_SITE_ID AS CODE

					 , SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE A WITH(NOLOCK)

					                               

					INNER JOIN ( SELECT token FROM dbo.String_Split(@Param2,',') )AS C

					ON A.END_CUSTOMER = CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN A.END_CUSTOMER ELSE C.token END

					                             

				WHERE  1 = 1

				AND    A.SITE_TYPE = 'SALES'

				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			                 

						 ELSE A.DIVISION_ID

 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

                                                

				                                                                                

				                        

 			                                                                 

				                                               

				                                                                                                                                     

				                                                             

				      

	                                          

				AND    A.DIVISION_ID IN (SELECT CODE

										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		 AND    UserID  LIKE '%'+ @Param4 + '%'

										 AND    AuthType = @AuthTypeParaSite)

				AND A.VALID_YN = 'Y'	              

				ORDER BY SCM_SITE_ID ASC;

			END

			ELSE

			BEGIN

				                 

				SELECT DISTINCT

					   A.SCM_SITE_ID AS CODE

					 , A.SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE AS A WITH(NOLOCK)

					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)

					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID

					                               

					INNER JOIN ( SELECT token FROM dbo.String_Split(@Param2,',') )AS C

					ON B.PROJECT_CODE = CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN B.PROJECT_CODE ELSE C.token END

					                             

				WHERE  1 = 1

				AND    A.SITE_TYPE = 'SALES'

				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

						 ELSE A.DIVISION_ID

 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

                                                

				                                                            

				                         

 			                                                                   

				      

				                              

				AND    A.DIVISION_ID IN (SELECT CODE

										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		 AND    UserID  LIKE '%'+ @Param4 + '%'

										 AND    AuthType = @AuthTypeParaSite)

				AND A.VALID_YN = 'Y'

				ORDER BY A.SCM_SITE_ID ASC;

			END

		END





		                                                 

                                  

                                                         

                                                         

                                                                                                            

          

           

                        

                

                                   

                                                   



	IF @Code = 'SiteByEndCustomerSold'



		BEGIN



			IF (@Param1 <> '40')

			BEGIN

				SELECT DISTINCT

					   SCM_SITE_ID AS CODE

					 , SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE A WITH(NOLOCK)

				WHERE  1 = 1

				AND    A.SITE_TYPE = 'SALES'

				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			                 

						 ELSE A.DIVISION_ID

 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

				AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			                 

						 ELSE A.END_CUSTOMER

 					END  IN ( SELECT token FROM dbo.String_Split(@Param2,','))

				AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			                 

						 ELSE A.END_CUSTOMER

 					END  IN ( SELECT token FROM dbo.String_Split(@Param2,','))

				                                                                                    

				                               

 			                                                                  

				AND    A.DIVISION_ID IN (SELECT CODE

										 FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		 AND    UserID  LIKE '%'+ @Param4 + '%'

										 AND    AuthType = 'D')

				AND A.VALID_YN = 'Y'	              

				ORDER BY SCM_SITE_ID ASC;

			END

			ELSE

			BEGIN

				                 

				SELECT DISTINCT

					   A.SCM_SITE_ID AS CODE

					 , A.SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE AS A WITH(NOLOCK)

					LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)

					ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID

				WHERE  1 = 1

				AND    A.SITE_TYPE = 'SALES'

				AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

						 ELSE A.DIVISION_ID

 					END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

				AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

						 ELSE B.PROJECT_CODE

 					END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

							)

				AND CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5			                 

						 ELSE A.SOLDTO_CUSTOMER

 					END  IN ( SELECT token FROM dbo.String_Split(@Param5,','))

				AND    A.DIVISION_ID IN (SELECT CODE

										 FROM  TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		 AND    UserID  LIKE '%'+ @Param4 + '%'

										 AND    AuthType = 'D')

				AND A.VALID_YN = 'Y'

				ORDER BY A.SCM_SITE_ID ASC;

			END

		END







		                                                 

                                     

                                                         

                                                         

            

          

           

                        

                

          

                                                   



	IF @Code = 'SiteByEndCustomer40'

		BEGIN

			SELECT DISTINCT A.SCM_SITE_ID AS CODE, A.SCM_SITE_ID AS NAME

			FROM SCM_MST_SITE A WITH(NOLOCK)

			LEFT JOIN SCM_MST_SITE_ITEM B  WITH(NOLOCK)

			ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID

			LEFT JOIN (

						SELECT DISTINCT A.USER_ID, A.DEPT_ID

						FROM SCM_MST_SSO_USER_INFO A WITH(NOLOCK) , SCM_MST_SSO_DEPT_INFO B  WITH(NOLOCK)

						WHERE A.DEPT_ID = B.DEPT_ID

						AND B.DEPT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))	           

					) C ON B.OWNER = C.USER_ID

			WHERE  1 = 1

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

						ELSE A.DIVISION_ID

 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

						ELSE C.DEPT_ID

 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

						)

			AND CASE WHEN @Param3 = 'ALL' OR @Param3 = '' THEN @Param3

						ELSE B.PROJECT_CODE

 				END  IN ( SELECT token FROM dbo.String_Split(@Param3,',')

						)

			AND    A.DIVISION_ID IN (SELECT CODE

										FROM  TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				WHERE  GroupID LIKE '%'+ @Param4 + '%'

										AND    UserID  LIKE '%'+ @Param5 + '%'

										AND AuthType = 'D')

			AND A.VALID_YN = 'Y'

			ORDER BY A.SCM_SITE_ID ASC;

		END



		                                                 

                                  

                                                         

                                                         

                                                                                                            

          

           

                        

                 

                        

                                                   

		IF @Code = 'SiteByEndCustomerEx'



		BEGIN

			SELECT DISTINCT

			       SCM_SITE_ID AS CODE

			     , SCM_SITE_ID AS NAME

			FROM   SCM_MST_SITE A WITH(NOLOCK)

			WHERE  1 = 1

			AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

                        ELSE A.DIVISION_ID

	               END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')

	                       )

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

                     ELSE A.END_CUSTOMER

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

	                    )

            AND    A.DIVISION_ID IN (SELECT CODE

		                             FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    	 AND    UserID  LIKE '%'+ @Param4 + '%'

								     AND    AuthType = 'D')

			AND A.VALID_YN = 'Y'	              

			ORDER BY SCM_SITE_ID ASC;

		END







		                        

		  

                            

                          

    

		IF @Code = 'BuildingByPlantSite'



		BEGIN

			SELECT

			      DISTINCT

				  A.FACTORY_ID    AS CODE

				, A.FACTORY_NAME  AS NAME

			FROM  [dbo].[SCM_MST_FACTORY_SN] A WITH(NOLOCK)

			WHERE 1=1

			AND (@Param1 IS NULL OR A.PLANT_ID IN

					(  SELECT token FROM dbo.String_Split(SUBSTRING(@Param1,1,4),',')

					                                          

					                                                                                                      

					                                 

					)

			)

			AND (@Param2 IS NULL OR A.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param2,',')

					                                          

					                                                                                       

					                                 

					)

			)

		END



		                    

		  

                          

                            

                         

                           

                        

    

		IF @Code = 'LineByOperation'



		BEGIN

			  SELECT

				DISTINCT

					 A.LINE_ID						  AS CODE

					,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME

					,A.OPERATION_ID

					,B.SCM_SITE_ID

				FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK)

				JOIN [dbo].SCM_MST_SITE B  WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID

				INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1

								FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)

								WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'

								AND    b.valid_yn    = 'Y'

								AND    b.segment3    = 'Y'                 

							) f ON a.operation_id = f.segment4                                                                                    

				WHERE 1=1

				AND A.ACTIVE_FLAG ='Y'

				AND ( (@Param1 IS NULL OR @Param1 ='') OR A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )

				AND ( (@Param2 IS NULL OR @Param2 ='') OR A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(SUBSTRING(@Param2,1,4),','))   )

				AND ( (@Param3 IS NULL OR @Param3 ='') OR A.FACTORY_ID IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )

				AND ( (@Param4 IS NULL OR @Param4 ='') OR A.OPERATION_ID IN ( SELECT token FROM dbo.String_Split(@Param4,','))   )

				AND ( (@Param5 IS NULL OR @Param5 ='') OR B.SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@Param5,','))   )

				UNION

				SELECT

					'-'  AS CODE

					,'-'  AS NAME

					,'-'  AS OPERATION_ID

					,'-'  AS SCM_SITE_ID

				ORDER BY NAME

		END



		                         

		  

                                               

                                              

       

		IF @Code = 'LocationByPlantSite'



		BEGIN

			SELECT distinct

					 L.LOCATION_CODE AS CODE

				   , L.LOCATION_DESCRIPTION AS NAME

			  FROM   [dbo].[SCM_MST_LOCATION] L WITH(NOLOCK)

			  WHERE 1=1

			  AND    L.LOCATION_CODE = L.LOCATION_CODE

			  AND    L.STORAGE_ID IS NOT NULL

			  AND    (@Param1 IS NULL OR L.DIVISION_ID IN

							( SELECT token FROM dbo.String_Split(@Param1,',')

							                                         

							                                                                                      

							                                

							)

					 )

			  AND    (@Param2 IS NULL OR L.SCM_SITE_ID IN

							( SELECT token FROM dbo.String_Split(@Param2,',')

							                                         

							                                                                                      

							                                

							)

					 )

			  ORDER BY L.LOCATION_CODE

		END



		                     

		IF @Code = 'ITEM_MASTER_CLASS1'



		BEGIN

			SELECT

				 DISTINCT

				 B.LEVEL_1_NAME AS CODE

				,B.LEVEL_1_NAME AS NAME

			FROM SCM_MST_ITEM_SN A(NOLOCK)

			INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON A.ITEM_CLASS = B.CLASS_ID

			ORDER BY B.LEVEL_1_NAME

		END



		                     

		                        

		IF @Code = 'ITEM_MASTER_CLASS2'



		BEGIN

			SELECT

				 DISTINCT

				 B.LEVEL_2_NAME AS CODE

				,B.LEVEL_2_NAME AS NAME

			FROM SCM_MST_ITEM_SN A(NOLOCK)

			INNER HASH JOIN SCM_MST_ITEM_CLASS_SN B(NOLOCK) ON A.ITEM_CLASS = B.CLASS_ID

			WHERE

				(@Param1 IS NULL  OR  B.LEVEL_1_NAME IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                      

					                                

					)

				  )



			ORDER BY B.LEVEL_2_NAME

		END



		                     

		                        



		                        

		IF @Code = 'ITEM_MASTER_ITEM_TYPE'



		BEGIN

			SELECT *

			FROM(

			SELECT DISTINCT

				 CASE WHEN ISNULL(LTRIM(RTRIM(A.ITEM_TYPE)),'') = '' THEN '-'

					WHEN A.ITEM_TYPE IS NULL THEN '-' ELSE A.ITEM_TYPE END AS CODE

				,CASE WHEN ISNULL(LTRIM(RTRIM(A.ITEM_TYPE)),'') = '' THEN '-'

					WHEN A.ITEM_TYPE IS NULL THEN '-' ELSE A.ITEM_TYPE END AS NAME

			FROM SCM_MST_ITEM_SN A(NOLOCK)

						                                                                              

			) A ORDER BY CODE

		END



		                        

		IF @Code = 'SETUP_MATRIX_CATEGORY'



		BEGIN

			SELECT DISTINCT

			 T.SETUP_CATEGORY_ID AS CODE

			,T.SETUP_CATEGORY_ID AS NAME

			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)

			ORDER BY T.SETUP_CATEGORY_ID

		END



		                     

		                                                          

		IF @Code = 'SETUP_MATRIX_PLANT'



		BEGIN

			SELECT

			   DISTINCT

			   T.PLANT_ID AS CODE

			  ,P.FACTORY_NAME AS NAME

			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)

			JOIN SCM_MST_FACTORY_SN P  WITH(NOLOCK) ON T.COMPANY_ID = P.COMPANY_ID AND T.DIVISION_ID = P.DIVISION_ID AND T.SITE_ID = P.SITE_ID AND T.PLANT_ID = P.PLANT_ID

			WHERE (@Param1 IS NULL OR T.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                      

					                                

					)

				  )

			  AND T.PLANT_ID IN (SELECT CODE FROM TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK) WHERE GroupID = @Param2 AND UserID = @Param3 AND AuthType = 'P' AND

				 (@Param1 IS NULL OR PrntCode IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                      

					                                

					)

				  )

				                        

			  )

			ORDER BY T.PLANT_ID



		END



		                         

		                                          

		IF @Code = 'SETUP_MATRIX_OPERATION'



		BEGIN

			SELECT

				 DISTINCT

				 T.OPERATION_ID AS CODE

				,O.OPERATION_NAME AS NAME

			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)

			JOIN SCM_MST_OPERATION_SN O  WITH(NOLOCK) ON T.COMPANY_ID = O.COMPANY_ID AND T.DIVISION_ID = O.DIVISION_ID AND T.SITE_ID = O.SITE_ID AND T.OPERATION_ID = O.OPERATION_ID

			WHERE



				(@Param1 = '' OR T.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param2 = '' OR T.PLANT_ID IN

					( SELECT token FROM dbo.String_Split(@Param2,',')

					                                         

					                                                                                       

					                                 

					)

				)



			ORDER BY T.OPERATION_ID

		END





		                                        

		                                                                 

		IF @Code = 'SETUP_MATRIX_FROM_ITEM_SETUP_GROUP_ID'



		BEGIN

			SELECT

			     DISTINCT

				 T.FROM_ITEM_SETUP_GROUP_ID AS CODE

				,T.FROM_ITEM_SETUP_GROUP_ID AS NAME

			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)

			WHERE



				(@Param1 = '' OR T.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param2 = '' OR T.PLANT_ID IN

					( SELECT token FROM dbo.String_Split(@Param2,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param3 = '' OR T.OPERATION_ID IN

					( SELECT token FROM dbo.String_Split(@Param3,',')

					                                         

					                                                                                       

					                                 

					)

				)

			ORDER BY T.FROM_ITEM_SETUP_GROUP_ID

		END



		                                      

		                                                                 

		IF @Code = 'SETUP_MATRIX_TO_ITEM_SETUP_GROUP_ID'



		BEGIN

			SELECT

				DISTINCT

				T.TO_ITEM_SETUP_GROUP_ID AS CODE

			   ,T.TO_ITEM_SETUP_GROUP_ID AS NAME

			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)

			WHERE



				(@Param1 = '' OR T.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param2 = '' OR T.PLANT_ID IN

					(SELECT token FROM dbo.String_Split(@Param2,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param3 = '' OR T.OPERATION_ID IN

					( SELECT token FROM dbo.String_Split(@Param3,',')

					                                         

					                                                                                       

					                                 

					)

				)

			ORDER BY T.TO_ITEM_SETUP_GROUP_ID

		END



		                               

		                                                                                                                                     

		IF @Code = 'SETUP_MATRIX_SETUP_CONDITION'



		BEGIN

			SELECT

				 DISTINCT

				 T.SETUP_CONDITION_ID AS CODE

				,T.SETUP_CONDITION_ID AS NAME

			FROM SCM_MST_SETUP_MATRIX_SN T WITH(NOLOCK)

			WHERE



				(@Param1 = '' OR T.DIVISION_ID IN

					(SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param2 = '' OR T.PLANT_ID IN

					( SELECT token FROM dbo.String_Split(@Param2,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param3 = '' OR T.OPERATION_ID IN

					( SELECT token FROM dbo.String_Split(@Param3,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param4 = '' OR T.FROM_ITEM_SETUP_GROUP_ID IN

					( SELECT token FROM dbo.String_Split(@Param4,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param5 = '' OR T.TO_ITEM_SETUP_GROUP_ID IN

					( SELECT token FROM dbo.String_Split(@Param5,',')

					                                         

					                                                                                       

					                                 

					)

				)

		   ORDER BY T.SETUP_CONDITION_ID

		END





		               

		IF @Code = 'CalendarDay'

		BEGIN

				SELECT

					 q.BASIS_YYYYMMDD as code, q.date_full_name name

				FROM scm_sys_calendar_m q with(nolock)

				WHERE 1=1

				AND q.basis_yyyymmdd >= @Param1

				AND q.basis_yyyymmdd <= @Param2

		END





		                

		IF @Code = 'CalendarWeek'



		BEGIN

				SELECT

					 q.CALENDAR_MONTH + '/'+ q.CALENDAR_DAY +'('+ DAYOFWEEK +')' as CODE

					,q.week_name +'|'+ q.basis_yyyymmdd as NAME

				FROM scm_sys_calendar_m q with(nolock)

				WHERE 1=1

				AND q.basis_yyyymmdd >= @Param1

				AND q.basis_yyyymmdd <= @Param2



		END



		                 

		IF @Code = 'CalendarMonth'



		BEGIN

				SELECT distinct q.basis_yyyymm as code

					  ,convert( varchar(7), q.basis_date ,120) as name

				FROM scm_sys_calendar_m q with(nolock)

				WHERE 1=1

				AND q.basis_yyyymm >= @Param1

				AND q.basis_yyyymm <= @Param2

				order by code, name

		END



		                           

		IF @Code = 'PERIOD_DEFAULT'



		BEGIN

			        

			   

			                                                       

			                                                                                         

			                                                                                                             

			                 

			   

			   

			                                                       

			                                                                                                   

			                                                                                                                      

			               

			SELECT

			(

				SELECT MIN(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]

				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@TimeZone), 112), 0, 7) AND ISO_WEEK IN

				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone), 112) )

			) AS FROM_VALUE

			,

			(

				SELECT MAX(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]

				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@TimeZone) + (7 * 3), 112), 0, 7) AND ISO_WEEK IN

				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR,  dbo.FN_MULTY_TIME(@TimeZone) + (7 * 3), 112))

			) AS TO_VALUE

		END



		                   

		IF @Code = 'PERIOD_YESTERDAY'



		BEGIN

			                                                                                                    

			SELECT CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) - 1 , 112) FROM_VALUE, CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone), 112) TO_VALUE

		END



		                  

		IF @Code = 'PERIOD_TOMORROW'



		BEGIN

			                                                                                                   

			SELECT CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone), 112) FROM_VALUE, CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) + 1, 112) TO_VALUE

		END



		                  

		IF @Code = 'PERIOD_LASTWEEK'



		BEGIN

			                                                                                               

			                                                                                            

			                                                  

			                                                              

			   



			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)

			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) - 7, 112), 0, 7) AND ISO_WEEK IN

			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)

				WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) - 7, 112)

			)

		END



		                  

		IF @Code = 'PERIOD_NEXTWEEK'



		BEGIN

			                                                                                               

			                                                                                            

			                                                  

			                                                              

			   

			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)

			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) + 7, 112), 0, 7) AND ISO_WEEK IN

			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)

				WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, dbo.FN_MULTY_TIME(@TimeZone) + 7, 112)

			)

		END



		                   

		IF @Code = 'PERIOD_LASTMONTH'



		BEGIN

			                                                                                                                                                                                  

			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,dbo.FN_MULTY_TIME(@TimeZone)) - 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(MS,-3,DATEADD(MM, DATEDIFF(MM,0,dbo.FN_MULTY_TIME(@TimeZone)  ), 0)), 112) TO_VALUE

		END



		                   

		IF @Code = 'PERIOD_NEXTMONTH'



		BEGIN

			                                                                                                                                                                                  

			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,dbo.FN_MULTY_TIME(@TimeZone)) + 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,dbo.FN_MULTY_TIME(@TimeZone)) + 2,0)) , 112) TO_VALUE

		END





	                                

		IF @Code = 'PERIOD2_DEFAULT'



		BEGIN

			SELECT

			(

				SELECT MIN(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)

				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1), 112), 0, 7) AND ISO_WEEK IN

				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1), 112) )

			) AS FROM_VALUE

			,

			(

				SELECT MAX(BASIS_YYYYMMDD) FROM [SCM_SYS_CALENDAR_M]

				WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1) + (7 * 3), 112), 0, 7) AND ISO_WEEK IN

				(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M]  WITH(NOLOCK) WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1) + (7 * 3), 112))

			) AS TO_VALUE

		END



		                    

		IF @Code = 'PERIOD2_YESTERDAY'



		BEGIN

			SELECT CONVERT(VARCHAR, convert(datetime,@Param1) - 1 , 112) FROM_VALUE, CONVERT(VARCHAR, convert(datetime,@Param1), 112) TO_VALUE

		END



		                   

		IF @Code = 'PERIOD2_TOMORROW'



		BEGIN

			SELECT CONVERT(VARCHAR, convert(datetime,@Param1), 112) FROM_VALUE, CONVERT(VARCHAR, convert(datetime,@Param1) + 1, 112) TO_VALUE

		END



		                   

		IF @Code = 'PERIOD2_LASTWEEK'



		BEGIN

			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)

			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1) - 7, 112), 0, 7) AND ISO_WEEK IN

			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)

			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1) - 7, 112)

			)

		END



		                   

		IF @Code = 'PERIOD2_NEXTWEEK'



		BEGIN

			SELECT MIN(BASIS_YYYYMMDD) FROM_VALUE, MAX(BASIS_YYYYMMDD) TO_VALUE FROM [SCM_SYS_CALENDAR_M] WITH(NOLOCK)

			WHERE BASIS_YYYYMM = SUBSTRING(CONVERT(VARCHAR, convert(datetime,@Param1) + 7, 112), 0, 7) AND ISO_WEEK IN

			(SELECT ISO_WEEK FROM [DBO].[SCM_SYS_CALENDAR_M] WITH(NOLOCK)

			WHERE BASIS_YYYYMMDD = CONVERT(VARCHAR, convert(datetime,@Param1) + 7, 112)

			)

		END



		                    

		IF @Code = 'PERIOD2_LASTMONTH'



		BEGIN

			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,convert(datetime,@Param1)) - 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(MS,-3,DATEADD(MM, DATEDIFF(MM,0,convert(datetime,@Param1)  ), 0)), 112) TO_VALUE

		END



		                    

		IF @Code = 'PERIOD2_NEXTMONTH'



		BEGIN

			SELECT CONVERT(VARCHAR, DATEADD(MM, DATEDIFF(MM,0,convert(datetime,@Param1)) + 1, 0), 112) FROM_VALUE, CONVERT(VARCHAR, DATEADD(S,-1,DATEADD(MM, DATEDIFF(M,0,convert(datetime,@Param1)) + 2,0)) , 112) TO_VALUE

		END





	                                                                    

	if @Code = 'DATA_SORT_METHOD'

	begin

		SELECT

			SEGMENT1 AS CODE,

			SEGMENT2 AS NAME

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'DATA_SORT_METHOD'

		ORDER BY DISPLAY_SEQ

	end

	                                                                      

	if @Code = 'DEFAULT_FLAG'

	begin

		SELECT

			SEGMENT1 as code ,

			SEGMENT2 as name

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'DEFAULT_FLAG'

		ORDER BY DISPLAY_SEQ

	end



	IF @Code = 'CELL_CONTROL_OBJECT_TYPE_CODE'

	BEGIN

		SELECT

			SEGMENT1 as code ,

			SEGMENT2 as name

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'CELL_CONTROL_OBJECT_TYPE_CODE'

		ORDER BY DISPLAY_SEQ

	END



	IF @Code = 'HORIZONTAL_ALIGN_CODE'

	BEGIN

		SELECT

			SEGMENT1 as code ,

			SEGMENT2 as name

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'HORIZONTAL_ALIGN_CODE'

		ORDER BY DISPLAY_SEQ

	END



		                                                 

                     

                      

               

                        

                  

                        

                  

                           

                                                   





	if @Code = 'BIZ_TYPE'

	begin

		select

			SEGMENT1 as code ,

			SEGMENT2 as name

		from SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		where LOOKUP_TYPE ='BIZ_TYPE_BPMS'

		order by DISPLAY_SEQ

	end





	if @Code = 'PortBySite'

	begin

		SELECT SEGMENT1 AS CODE,

				SEGMENT2 AS NAME

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		where LOOKUP_TYPE ='PORT_CODE'

		order by DISPLAY_SEQ

	end



	if @Code = 'ItemBySite'

	begin

		select

			ITEM_ID as code ,

			ITEM_ID as name

		from SCM_MST_SITE_ITEM t

		where  1=1

		and			(@Param1 = '' OR T.DIVISION_ID IN

					( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

					                                                                                       

					                                 

					)

				)

				AND (@Param2 = '' OR T.scm_site_id IN

					( SELECT token FROM dbo.String_Split(@Param2,',')

					                                         

					                                                                                       

					                                 

					)

				)



	end



	if @Code = 'BucketType'

	begin

		    SELECT L.SEGMENT1  AS CODE

			     , L.SEGMENT2  AS NAME

			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

			WHERE  1 = 1

			AND    L.LOOKUP_TYPE = 'BUCKET_TYPE_CODE'

			ORDER BY L.DISPLAY_SEQ

	end



	if @Code = 'UploadUOM'

	begin

		SELECT

				SEGMENT1 AS CODE,

				SEGMENT2 AS NAME

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		where LOOKUP_TYPE ='UPLOAD_UOM_TYPE_CODE'

		order by DISPLAY_SEQ

	end







   if @Code = 'SpreadTitle'

	begin

		select

			*

		from SCM_MST_SHEET_COLUMNS T1  WITH(NOLOCK)





		where  1=1

		AND T1.PROGRAM_ID =@PARAM1

		AND T1.SHEET_NAME = @PARAM2

		order by SORT_ORDER_NO



		





	end



	IF @CODE = 'StorageID'

	BEGIN

		SELECT distinct STORAGE_ID CODE

		  ,(STORAGE_ID + '  ' + STORAGE_DESCRIPTION) NAME

		FROM SCM_MST_SLOC WITH(NOLOCK)

		WHERE  1=1

			AND	(@Param1 = '' OR DIVISION_ID = @Param1)

			AND (@Param2 = '' OR PLANT_ID = @Param2)

		                                                                                     

		UNION 

		SELECT distinct STORAGE_ID CODE

		  ,(STORAGE_ID + '  ' + STORAGE_DESCRIPTION) NAME

		FROM SCM_MST_SLOC WITH(NOLOCK)

		WHERE  1=1

		AND DIVISION_ID = @Param1

		AND PLANT_ID IN (

			SELECT SEGMENT3 FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE LOOKUP_TYPE = 'PLANT_SLOC_REF'

			AND SEGMENT2 = @Param2

		)



	END





	IF @CODE = 'Location'

	BEGIN

		                                               

		                                         

		                                                                                  

		                                        

		                                            

		                        



		SELECT B.SEGMENT1 CODE, B.SEGMENT2 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE

		WHERE A.LOOKUP_TYPE = 'LOCATION_GROUP'

			AND (@Param1 = '' OR B.SEGMENT3 = @Param1)

		ORDER BY B.DISPLAY_SEQ



	END





	IF @CODE = 'TeambyDivision'

	BEGIN



		DEClARE @TeambyDivision_Lang NVARCHAR(200)

		SELECT @TeambyDivision_Lang = Language

		FROM dbo.TB_FX_User

		WHERE UserID = @Param3



		SET @TeambyDivision_Lang = ISNULL(@TeambyDivision_Lang, 'KO')



		IF @Param1 = ''

			SET @Param1 = 'ALL';



		IF (@Param1 <> '40')                            

		BEGIN

			SELECT DISTINCT

				B.DEPT_ID       AS CODE

				                          

				, CASE @TeambyDivision_Lang WHEN 'EN' THEN B.DEPT_NAME_EN

				                            WHEN 'CN' THEN B.DEPT_NAME_CN

											ELSE B.DEPT_NAME_KO

											END

				AS NAME

				                                                                                               

			FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

				, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

			WHERE  A.SITE_TYPE = 'SALES'

			AND    A.DEPT_ID  = B.DEPT_ID

			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

				ELSE A.DIVISION_ID

				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

				                                         

			                                                                                                        

			                                                  

					)

			AND    A.DIVISION_ID IN (SELECT CODE

					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					WHERE  GroupID LIKE '%'+ @Param2 + '%'

					AND    UserID  LIKE '%'+ @Param3 + '%'

					AND    AuthType = 'D')

			ORDER BY  NAME,CODE		          

		END

		ELSE

		BEGIN

			                              

			select distinct c.dept_id AS CODE

				, CASE @TeambyDivision_Lang WHEN 'EN' THEN C.DEPT_NAME_EN

				            WHEN 'CN' THEN C.DEPT_NAME_CN

							ELSE C.DEPT_NAME_KO

							END AS NAME

			  from scm_mst_site_item a  WITH(NOLOCK)

			      ,[SCM_MST_SSO_USER_INFO] b  WITH(NOLOCK)

				  ,[SCM_MST_SSO_DEPT_INFO] c  WITH(NOLOCK)

			 where                       

			   b.user_id = (SELECT top 1 token FROM dbo.String_Split(a.owner,',') )

			   and b.dept_id = c.dept_id

			   and a.division_id = '40'

			  order by NAME



              

                  

                           

                             

                                             

                                                         

                                                                           

                                                         

                                                                 

                 

                        

                                           

                                  

        

        

                               

                                              

                      

                                                             

      

                                       

                                                          

                                           

                                           

                           

                      

     



		END

	END



	IF @CODE = 'ItemType'

	BEGIN



		SET @Param1 = 'ITEM_TYPE_CODE';



	    DECLARE @tITC TABLE (CODE NVARCHAR(100), NAME NVARCHAR(100))

	    INSERT @tITC EXEC SCM0001_GET_LOOKUP_VALUES @Param1

		SELECT * FROM @tITC



	END



	IF @CODE = 'PlantSitebyEndCustomer'

	BEGIN

	    SELECT DISTINCT

	           SCM_SITE_ID AS CODE

		     , SCM_SITE_ID AS NAME

		FROM   SCM_MST_SITE A

		WHERE  1 = 1

		AND    A.SITE_TYPE = 'PLANT'

		AND CASE	  WHEN @Param1 = 'ALL'	OR @Param1 = ''THEN @Param1

					  ELSE A.DIVISION_ID

            END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

					                                          

                                                                                                                                                      

                                                        

                    )

		AND CASE	  WHEN @Param2 = 'ALL'	OR @Param2 = ''THEN @Param2

					  ELSE A.END_CUSTOMER

            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

					                                          

                                                                                                                                                      

                                                        

                    )

        AND    A.DIVISION_ID IN (SELECT CODE

	                             FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

							     WHERE  GroupID LIKE @Param3 + '%'

						    	 AND    UserID  LIKE @Param4 + '%'

								 AND    AuthType = 'D')



	END;



	IF @CODE = 'Module'

	BEGIN

		SELECT DISTINCT B.SEGMENT1 CODE

				,B.SEGMENT3 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                          

			AND A.VALID_YN = 'Y'

	END;



	IF @CODE = 'SubModule'

	BEGIN

	    SELECT B.SEGMENT2 CODE

				,B.SEGMENT4 NAME

				,B.SEGMENT1 SYSTEM_CODE

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                         

		    AND (ISNULL(@Param2,'') = '' OR B.SEGMENT1 = @Param2)

			AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ



	END;







	IF @CODE = 'Cycle'

	BEGIN

	    SELECT B.SEGMENT1 CODE

				,B.SEGMENT3 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                    

			AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ



	END;



	IF @CODE = 'CycleSub1'

	BEGIN

	    SELECT B.SEGMENT2 CODE

				,B.SEGMENT3 NAME

				,B.SEGMENT1 CYCLE_CODE

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                           

			AND A.VALID_YN = 'Y'

		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ



	END;



	IF @CODE = 'CycleSub2'

	BEGIN

	    SELECT B.SEGMENT2 CODE

				,B.SEGMENT3 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                           

			AND A.VALID_YN = 'Y'

			AND B.SEGMENT1 = 'DAY'

		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ



	END;





	IF @CODE = 'CycleSub2_v2'

	BEGIN

	    SELECT B.SEGMENT2 CODE

				,B.SEGMENT3 NAME

				,B.SEGMENT1 CYCLE_CODE

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                           

			AND A.VALID_YN = 'Y'

			AND B.SEGMENT1 IN ('DAY','HOUR')

		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ



	END;



	IF @CODE = 'CycleSub3'

	BEGIN

	    SELECT B.SEGMENT2 CODE

				,B.SEGMENT3 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK)  ON A.LOOKUP_TYPE = B.LOOKUP_TYPE AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1                           

			AND A.VALID_YN = 'Y'

			AND B.SEGMENT1 = 'HOUR'

		ORDER BY B.SEGMENT1, B.DISPLAY_SEQ



	END;



	                              

	       

	                            

	                     

	                           

	                               

	                                                                                                  

	                                                   

	                        

	                                     



	      



	                              

	       

	                            

	                     

	                               

	                                                                                                  

	                                                   

	                        

	                          

	                                     



	      





		                                                 

                                

                                          

                                         

                                                   

            

          

          

                        

                    

                                   

                                                   

	IF @CODE = 'Measure'

	BEGIN

	    SELECT A.COLUMN_NAME        AS CODE

             , CASE WHEN  A.COLUMN_NAME IN ('CUST_FCST_EDI_ORG')

			        THEN  N' └ ' + 'EDI[Org.]'

					WHEN  A.COLUMN_NAME IN ('CUST_FCST_EDI') AND @Param1 IN ( 'DMF0053')

			        THEN  N' └ ' + 'EDI'

					WHEN  A.COLUMN_NAME IN ('CUST_FCST_EDI')

			        THEN  N' └ ' + 'EDI'

					ELSE A.COLUMN_LABEL_NAME

			   END AS NAME

        FROM [dbo].[SCM_MST_SHEET_MEASURE] A WITH(NOLOCK)

        WHERE 1 = 1

        AND   PROGRAM_ID = @Param1

        AND   SHEET_NAME = @Param2

		AND    VALID_YN = 'Y'               

		UNION ALL

		SELECT                                                          

		       MEASURE AS CODE

			 , concat(N' └ ',MEASURE) AS NAME                             

		FROM   [dbo].[DM_MST_CUSTOMER_FCST] WITH(NOLOCK)

		WHERE  1 = 1

		AND  VALID_YN = 'Y'

		AND    MEASURE <> ''

		AND    MEASURE_GROUP = 'CUST_FCST'

		AND   @Param1 IN ( 'DMF0003', 'DMF0035','DMF0003_TEST' )

		GROUP BY MEASURE               

		                                                                                                 

		UNION ALL

		SELECT	'Immidiate'				AS CODE	, N'    └ ' + 'Immidiate'				AS NAME



		UNION ALL

		SELECT	'Planning_Forecast'		AS CODE	, N'    └ ' + 'Planning_Forecast'		AS NAME



		UNION ALL

		SELECT	'Commercial_Agreement'	AS CODE	, N'    └ ' + 'Commercial_Agreement'	AS NAME



		UNION ALL

		SELECT 'Firm_Temp'    AS CODE , N'    └ ' + 'Firm_Temp'    AS NAME



		UNION ALL

		SELECT 'Manumacturing_Material_Temp'  AS CODE , N'    └ ' + 'Manumacturing_Material_Temp'  AS NAME



		UNION ALL

		SELECT 'Material_Temp' AS CODE , N'    └ ' + 'Material_Temp' AS NAME



		UNION ALL

		SELECT 'Backorder' AS CODE , N'    └ ' + 'Backorder' AS NAME



		UNION ALL

		SELECT 'Cust.FCST_EXCEL[P+P]' AS CODE , N' └ ' + 'EXCEL' AS NAME



		UNION ALL

		SELECT 'Cust.FCST_RPA[P+P]' AS CODE , N' └ ' + 'RPA' AS NAME



		UNION ALL

		SELECT 'Immidiate[Org.]'    AS CODE , N'    └ ' + 'Immidiate[Org.]'    AS NAME



		UNION ALL

		SELECT 'Planning_Forecast[Org.]'  AS CODE , N'    └ ' + 'Planning_Forecast[Org.]'  AS NAME



		UNION ALL

		SELECT 'Commercial_Agreement[Org.]' AS CODE , N'    └ ' + 'Commercial_Agreement[Org.]' AS NAME



		UNION ALL

		SELECT 'Firm_Temp[Org.]'    AS CODE , N'    └ ' + 'Firm_Temp[Org.]'    AS NAME



		UNION ALL

		SELECT 'Manumacturing_Material_Temp[Org.]'  AS CODE , N'    └ ' + 'Manumacturing_Material_Temp[Org.]'  AS NAME



		UNION ALL

		SELECT 'Material_Temp[Org.]' AS CODE , N'    └ ' + 'Material_Temp[Org.]' AS NAME



		UNION ALL

		SELECT 'Backorder[Org.]' AS CODE , N'    └ ' + 'Backorder[Org.]' AS NAME



		UNION ALL

		SELECT 'Cust.FCST_EXCEL[Org.]' AS CODE , N' └ ' + 'EXCEL[Org.]' AS NAME



		UNION ALL

		SELECT 'Cust.FCST_RPA[Org.]' AS CODE , N' └ ' + 'RPA[Org.]' AS NAME



		UNION ALL

		SELECT 'Cust.FCST_EXCEL' AS CODE , N' └ ' + 'EXCEL' AS NAME



		UNION ALL

		SELECT 'Cust.FCST_RPA' AS CODE , N' └ ' + 'RPA' AS NAME



		UNION ALL

		SELECT	'Ship Plan'	AS CODE	, N'Ship Plan'	AS NAME		                     

		                                                             

		UNION ALL

		SELECT	'CUST_FCST_EDI'	AS CODE	, N' └ ' + 'EDI' AS NAME	

		                                                           

		                                                                                               

	END;





	IF @CODE = 'MeasureGroup'

	BEGIN

	    SELECT DISTINCT

		       A.SMALL_CLASS_LABEL_NAME  AS CODE

             , A.SMALL_CLASS_LABEL_NAME  AS NAME

        FROM [dbo].[SCM_MST_SHEET_MEASURE] A WITH(NOLOCK)

        WHERE 1 = 1

        AND   PROGRAM_ID = @Param1

        AND   SHEET_NAME = @Param2



	END;





	                                                 

                                                          

                                                                 

                

                        

                    

                        

                    

                       

                                                            

                                                   

	IF @Code = 'SoldCustomer'

	BEGIN

		SELECT SEGMENT2 AS CODE

		     , SEGMENT3 AS NAME

		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE  LOOKUP_TYPE = 'SOLD_CUSTOMER'

		AND    (@Param1 = '' OR SEGMENT1    = @Param1)

		ORDER BY SEGMENT2

	END



	IF @Code = 'DeptId'

	BEGIN

		  SELECT DISTINCT

				 B.DEPT_ID       AS CODE

			   , B.DEPT_NAME_KO  AS NAME

		  FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

			   , [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

		  WHERE  A.DEPT_ID  = B.DEPT_ID

				AND A.SITE_TYPE = 'SALES'



		                

		  UNION ALL



		  SELECT DISTINCT

				B.DEPT_ID       AS CODE

			, B.DEPT_NAME_KO  AS NAME

		  FROM   [dbo].[SCM_MST_SITE_ITEM]          A WITH(NOLOCK)

		  join [dbo].[SCM_MST_SSO_DEPT_INFO] B  WITH(NOLOCK)

		  ON B.DEPT_ID  = (

					SELECT SU.DEPT_ID

					FROM [dbo].[SCM_MST_SSO_USER_INFO] su

					WHERE SU.USER_ID = A.OWNER

				)

		                

	END



	IF @Code = 'UpperDeptId'

	BEGIN

		  SELECT DISTINCT

				 D.DEPT_ID       AS CODE

			   , D.DEPT_NAME_KO  AS NAME

		  FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

			   , [dbo].[SCM_MST_SSO_DEPT_INFO] D WITH(NOLOCK)

			   , [dbo].[SCM_MST_SSO_DEPT_INFO] T WITH(NOLOCK)

		  WHERE  A.DEPT_ID  = T.DEPT_ID

		  AND    D.DEPT_ID  = T.UPPER_DEPT_ID

		  AND    A.SITE_TYPE = 'SALES'

	END



	IF @Code = 'DivisionByUser'

	BEGIN

		SELECT DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME

		FROM   [dbo].[SCM_MST_DIVISION]

		WHERE  1 = 1

		                                                                                                                                 

		AND    DIVISION_ID IN ( SELECT CODE

		                        FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

								WHERE  1 = 1

								AND    ( GroupID LIKE '%' + @Param2 + '%' )

								AND    ( UserID  LIKE '%' + @Param3 + '%' )

								AND    AuthType = 'D')

		GROUP BY DIVISION_ID

		ORDER BY DIVISION_ID

	END



	IF @Code = 'MeasureGroupByUser'

	BEGIN

	    SELECT DISTINCT

               C.SMALL_CLASS_LABEL_NAME AS CODE

             , C.SMALL_CLASS_LABEL_NAME AS NAME

        FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)

             , [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)

        WHERE  1 = 1

        AND    U.PROGRAM_ID  = C.PROGRAM_ID

        AND    U.SHEET_NAME  = C.SHEET_NAME

        AND    U.COLUMN_NAME = C.COLUMN_NAME

        AND    U.PROGRAM_ID  = @Param1

        AND    U.SHEET_NAME  = @Param2

        AND    U.USER_ID     = @Param3

     AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'

	END



	IF @Code = 'MeasureByUser'

	BEGIN

	    SELECT U.COLUMN_NAME       AS CODE

             , C.COLUMN_LABEL_NAME AS NAME

        FROM   [dbo].[SCM_MST_TITLESET_USER] U WITH(NOLOCK)

             , [dbo].[SCM_MST_SHEET_MEASURE] C WITH(NOLOCK)

        WHERE  1 = 1

     AND    U.PROGRAM_ID  = C.PROGRAM_ID

        AND    U.SHEET_NAME  = C.SHEET_NAME

        AND    U.COLUMN_NAME = C.COLUMN_NAME

        AND    U.PROGRAM_ID  = @Param1

        AND    U.SHEET_NAME  = @Param2

        AND    U.USER_ID     = @Param3

		AND    C.SMALL_CLASS_LABEL_NAME LIKE @Param4 + '%'

        AND    U.USER_INQUIRY_COLUMN_TYPE_CODE = 'M'

	END



	IF @Code = 'VersionNo'

	BEGIN

	   SELECT 'CURRENT' AS CODE, 'Current' AS NAME

	   UNION ALL

	   SELECT [VERSION_NO] AS CODE

		     ,[VERSION_NO] AS NAME

		 FROM [dbo].[DM_MST_VERSION] WITH(NOLOCK)

		where 1=1

		  and ( (@Param1 IS NULL OR @Param1 = '') OR DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )

		  and [VERSION_NO] like 'MF_%'

                                      

                             

                                

                                 

                

                                                                                                                   

                                                                                                                   

                                                                                                                   

                                                                                                                   

                                                                                                                   

                                                                                                                         

                                                                                                                         

                                                                                                                         

                                                                                                                         

                                                                                                                   

                                     

      

       ORDER BY NAME;



	END



		IF @Code = 'VersionNo_SalesPlan'

	BEGIN

	   SELECT 'SP_Z_CURRENT' AS CODE, 'Current' AS NAME

	   UNION ALL

	   SELECT [VERSION_NO] AS CODE

		     ,[VERSION_NO] AS NAME

		 FROM [dbo].[DM_MST_VERSION] WITH(NOLOCK)

		where 1=1

		                                                                                                                    

		  and DIVISION_ID   IN (SELECT token FROM dbo.String_Split(@Param1	,','))

		  and [VERSION_NO] like 'SP_%'

                                     

                             

                                

                                   

                

                                                                                                                         

                                             

                          

             

                                                                         

                                                                           

                   

                                            

                            

             

                                                                         

                                                                             

                   

                                                                                                                            

                                                                                                                            

                                                                                                                

                                                                                                                   

                                     

      

       ORDER BY CODE DESC;



	END



	IF @Code = 'BizTypeByDivision'

	BEGIN

	   		select

			SEGMENT1 as code ,

			SEGMENT2 as name

		from SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		where LOOKUP_TYPE ='BIZ_TYPE_BPMS'

		order by DISPLAY_SEQ

                                                                  



                                                                      

                                                

                                                                                                                                                       

                                                         

	                   )

        AND    DIVISION_ID IN (SELECT CODE

		                       FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

							   WHERE  GroupID LIKE @Param2 + '%'

							   AND   UserID  LIKE @Param3 + '%'

							   AND    AuthType = 'D')

*/

	END



	IF @CODE = 'TeambyAll'

	BEGIN

	    IF @Param1 = ''

		    SET @Param1 = 'ALL';



		SELECT DISTINCT

               B.DEPT_ID       AS CODE

             , B.DEPT_NAME_KO  AS NAME

        FROM   [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)



	END



	                                                 

                                                           

                                                                 

                

                        

                    

                        

                    

                       

                                                   

	IF @Code = 'EndCustomer'

	BEGIN

		SELECT SEGMENT2 AS CODE

		     , SEGMENT3 AS NAME

		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE  LOOKUP_TYPE = 'END_CUSTOMER'

		AND    (@Param1 = '' OR SEGMENT1    = @Param1)

		AND VALID_YN = 'Y'               

		ORDER BY DISPLAY_SEQ

	END



	IF @Code = 'UpperDept_DeptByScmSiteID'

	BEGIN

		SELECT

			C.SCM_SITE_ID

			,isnull(DEPRTMENT.DEPT_ID,'')AS UPPER_DEPT_ID

			,isnull(TEAM.DEPT_ID,'')AS DEPT_ID



		FROM (SELECT * FROM SCM_MST_SITE WITH(NOLOCK) WHERE VALID_YN = 'Y' AND SITE_TYPE = 'SALES') AS C

		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y') AS TEAM

			ON C.DEPT_ID = TEAM.DEPT_ID

		LEFT JOIN (SELECT * FROM SCM_MST_SSO_DEPT_INFO WITH(NOLOCK) WHERE VALID_YN = 'Y') AS DEPRTMENT

			ON TEAM.UPPER_DEPT_ID = DEPRTMENT.DEPT_ID

		WHERE

		C.SCM_SITE_ID = @Param1                

	END



	                                                 

                                

                                                      

                

                        

                      

                        

           

          

                                                   

	IF @Code = 'System'

	BEGIN

		SELECT B.SEGMENT1 CODE

			  ,B.SEGMENT2 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = 'SYSTEM'

		  AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ

	END



	                                                 

                                     

          

                

                        

                      

                        

           

          

                                                   

	IF @Code = 'LookupCommon'

	BEGIN

		SELECT B.SEGMENT1 CODE

			  ,B.SEGMENT2 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1

		  AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ

	END



	                                                 

                                    

                                                

                                            

               

                        

                  

             

              

          

                                                   

	IF @Code = 'FCST_TYPE'

	BEGIN

		SELECT SEGMENT1 AS CODE,

		SEGMENT2 AS NAME,

		DISPLAY_SEQ

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE VALID_YN = 'Y'

		AND LOOKUP_TYPE = 'SALES_TYPE_CODE'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                                  

                                                

                                            

               

                        

                  

             

              

          

                                                   



	IF @Code = 'DOM_EXP'

	BEGIN

		SELECT B.SEGMENT1 CODE

			  ,B.SEGMENT2 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = 'DOM/EXP'

		  AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ

	END



	                                                 

                                   

                               

               

                        

                  

                        

                  

                            

                                                   



	IF @Code = 'PlanDate'

	BEGIN

		SELECT plan_start_yyyymmdd AS code

	  	 	  ,CONVERT(char(10), dbo.FN_CHAR_TO_DATE(plan_start_yyyymmdd),121) AS name

		  FROM SCP_PLAN_VERSION_V WITH(NOLOCK)

		WHERE division_id=@Param1

		  AND (( @Param2 IS NULL OR  @Param2='' ) OR version_id = @Param2 )

		GROUP BY plan_start_yyyymmdd

		ORDER BY plan_start_yyyymmdd DESC

	END



	                                                 

                                   

                               

               

                        

                  

                        

                  

                            

                                                   



	IF @Code = 'PlanType'

	BEGIN

		SELECT plan_type as code

			 , plan_type as name

			 ,max(plan_type_order) as plan_type_order

		FROM SCP_PLAN_VERSION_V WITH(NOLOCK)

		WHERE 1=1

		  and division_id         = @Param1

		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )

		  AND ( ( @Param3 IS NULL OR  @Param3='' ) OR version_id		  = @Param3 )

		GROUP BY plan_type

		order by plan_type_order

	END;

	                                                 

                                  

                              

               

                        

                  

                        

                  

                            

                                                   

	IF @Code = 'PlanSeq'

	BEGIN

		SELECT plan_seq as CODE

	  		                                                                          

			    ,( convert(varchar, plan_seq)+ ' - ' + (case when confirm_flag is null or confirm_flag ='' then 'N'

														  when confirm_flag = 'Y' then 'Confirm' end) )AS NAME

		 FROM SCP_PLAN_VERSION_V WITH(NOLOCK)

		WHERE 1=1

		  and division_id  = @Param1

		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )

		  and ( ( @Param3 IS NULL OR  @Param3='' ) OR plan_type           = @Param3 )

		  AND ( ( @Param4 IS NULL OR  @Param4='' ) OR version_id		  = @Param4 )

		GROUP BY plan_seq,confirm_flag

		ORDER BY plan_seq DESC

	END;

	                                                    

                           

                               

               

                        

                  

             

              

          

                                                   



	IF @Code = 'PlanDateShip'

	BEGIN



	  IF @Param2 = 'P'

			BEGIN

				SELECT DISTINCT TOP 20 A.PLAN_START_YYYYMMDD AS CODE , convert(VARCHAR(10), convert(DATETIME, A.PLAN_START_YYYYMMDD),121) name

				FROM

				(

					SELECT CONVERT(CHAR(8), DATEADD(DD, 1, CONVERT(VARCHAR, ATTRIBUTE1, 121)), 112)   as PLAN_START_YYYYMMDD

					FROM [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL]

					WHERE LOOKUP_TYPE = 'SSP_ANL_SHIP_PLAN_P'



					UNION ALL



					SELECT DISTINCT PLAN_START_YYYYMMDD

					FROM [DBO].[SSP_ANL_SHIP_PLAN_P] WITH(NOLOCK)

					WHERE DIVISION_ID = '40'

				) A

				ORDER BY 1 DESC

			END

		ELSE

			BEGIN

				 SELECT TOP 20 plan_start_yyyymmdd code

				,convert(VARCHAR(10), convert(DATETIME, plan_start_yyyymmdd),121) name

				FROM [dbo].[SSP_PLAN_VERSION_V] WITH(NOLOCK)

				WHERE CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

								ELSE division_id

 						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )

				GROUP BY plan_start_yyyymmdd

				ORDER BY plan_start_yyyymmdd DESC;

			END



	    

                    

                                        

                                                                         

                                      

                                                              

                                        

                                                                            

                              

                                    

     



	END



                                                 

                                       

                           

               

                        

                  

             

              

          

                                                   



	IF @Code = 'PlanTypeShip'

	BEGIN

		SELECT plan_type as code

			 , plan_type as name

			                                           

			 ,'1' as plan_type_order

		FROM SSP_PLAN_VERSION_V WITH(NOLOCK)

		WHERE 1=1

		  and division_id   = @Param1

		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )

		GROUP BY plan_type

		order by plan_type_order

	END;

	                                                 

                                  

                          

               

                        

                  

             

           

          

                                                   

	IF @Code = 'PlanSeqShip'

	BEGIN

		SELECT plan_seq as CODE

	  		                                                                          

			    ,( convert(varchar, plan_seq)+ ' - ' + (case when confirm_flag is null or confirm_flag ='' then 'N'

														 when confirm_flag = 'Y' then 'Confirm' end) )AS NAME

		 FROM SSP_PLAN_VERSION_V WITH(NOLOCK)

		WHERE 1=1

		  and division_id  = @Param1

		  and ( ( @Param2 IS NULL OR  @Param2='' ) OR plan_start_yyyymmdd = @Param2 )

		  and ( ( @Param3 IS NULL OR  @Param3='' ) OR plan_type           = @Param3 )

		GROUP BY plan_seq,confirm_flag

		ORDER BY plan_seq DESC

	END;



	                                                 

                                                   

                                

               

                        

                  

             

              

          

                                                   

	IF @Code = 'PlantByDivisionOperation'

	BEGIN

		 SELECT A.SCM_SITE_ID AS CODE

			                                

			   ,A.SCM_SITE_ID + '   '+A.SITE_DESCRIPTION AS NAME

		  FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)

		 WHERE  1 = 1

		   AND  A.VALID_YN ='Y'

		   AND  A.SITE_TYPE = 'PLANT'

		   AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )

		   AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )

		                                          

		   AND  ( ( @Param3 <> 'JV Planner' ) OR  A.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param4,',')) )

          ORDER BY CODE

	END;

	                                                 

                                  

                                     

               

                        

                  

             

              

          

                                                   

	IF @Code = 'PlanYear'

	BEGIN

		SELECT DISTINCT SUBSTRING(plan_version_id,1,4 ) AS code

			   ,SUBSTRING(plan_version_id,1,4 ) AS name

		FROM dbo.[FN_SCP_PLAN_VERSION_V](@Param1,'','','')

		ORDER BY code DESC

	END;



	                                                 

                                        

                                     

               

                        

                  

             

              

          

                                                   

	IF @Code = 'PlanWeek'

	BEGIN

		SELECT   B.WEEK_NAME AS CODE

				,plan_start_yyyymmdd +'-' + B.WEEK_NAME AS name

		FROM  dbo.[FN_SCP_PLAN_VERSION_V](@Param1,'', @Param2,'') a  JOIN

				 scm_sys_calendar_m b  WITH(NOLOCK) ON  a.plan_start_yyyymmdd = b.basis_yyyymmdd

		WHERE    1=1

		                                                                          

		GROUP BY plan_start_yyyymmdd

			   , b.WEEK_NAME

		ORDER BY name DESC ;

	END;



                                                     

                                       

                                               

               

                        

                   

             

              

          

                                                   

	IF @Code = 'CustomerMeasure'

	    BEGIN

		    SELECT DISTINCT

			       CF.MEASURE  AS CODE

			     , CF.MEASURE  AS NAME

			FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)

			WHERE  1 = 1

			AND    CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

                        ELSE CF.DIVISION_ID

 	               END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )

			AND    CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

          ELSE CF.CUSTOMER_CODE

 	               END  IN ( SELECT token FROM dbo.String_Split(@Param2,',') )

            AND    CASE WHEN @Param3 = 'ALL' OR @Param3 = '' THEN @Param3

      ELSE CF.SCM_SITE_ID

 	               END  IN ( SELECT token FROM dbo.String_Split(@Param3,',') )

            AND    CASE WHEN @Param4 = 'ALL' OR @Param4 = '' THEN @Param4

                        ELSE CF.UPLOAD_BUCKET_TYPE

 	               END  IN ( SELECT token FROM dbo.String_Split(@Param4,',') )

			AND    CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5

                        ELSE CF.MEASURE_GROUP

 	               END  IN ( SELECT token FROM dbo.String_Split(@Param5,',') )

			AND    CF.MEASURE <> ''

			AND    CF.VALID_YN = 'Y'

		END;



	                                                 

                                     

                                              

              

                       

                  

            

             

         

                                                  

	IF @Code = 'CustomerPSI'

	    BEGIN

		    SELECT L.SEGMENT1  AS CODE

			     , L.SEGMENT2  AS NAME

			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

			WHERE  1 = 1

			AND    L.LOOKUP_TYPE = 'CUSTOMER_PSI_TYPE'

			ORDER BY L.DISPLAY_SEQ

		END;





	                                                 

                   

                                     

                                  

                                                           

                       

                  

                       

                     

                                                                                            

                                                                                  

                                                                                                                  

                                                  



	                                                                          

	                    

	                                                                                                              

	IF @Code = 'MktFcstEditMeasure'

	    BEGIN

			DECLARE @MKT_FCST_MEASURE_VMI_YN NCHAR(1) = N'N'	              



			                                

			                                      

			IF ( @PARAM1 = '82' AND ISNULL(@PARAM5,'') <> '')

			BEGIN

				SELECT SEGMENT2 AS CODE, SEGMENT3 AS NAME

				FROM [SCM_ADM_LOOKUP_MASTER_DETAIL]

				WHERE LOOKUP_TYPE = 'MKT_FCST_MEASURE'

					AND SEGMENT1 = @PARAM1

					AND SEGMENT2 = @PARAM5



			END

			ELSE

			BEGIN

				SELECT @MKT_FCST_MEASURE_VMI_YN = VMI_YN

				FROM scm_mst_site

				WHERE DIVISION_ID =@PARAM1

					AND SCM_SITE_ID = @PARAM2

					                                           



				                       

				SELECT

				  L.SEGMENT2  AS CODE              

				, L.SEGMENT3  AS NAME                    

				, L.DISPLAY_SEQ

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

					WHERE 1=1

					AND L.LOOKUP_TYPE	= 'MKT_FCST_MEASURE'

					AND L.VALID_YN		= 'Y'

					AND L.ATTRIBUTE2   <> 'Y'                       

					AND L.SEGMENT1		= @Param1                 

					AND SEGMENT4		= 'Y'                      

					                    

					AND (( @MKT_FCST_MEASURE_VMI_YN = 'N' AND L.ATTRIBUTE1  <> 'Y' ) OR ( @MKT_FCST_MEASURE_VMI_YN = 'Y' ))

					                                                                                     

					                                                                                                                                                       

					                                                                                                                                

					    

					                                                  

					                                                                                                                                                                                                                

				          

				UNION ALL

				          



				                      

				SELECT T.CODE              

					 , T.NAME                    

					 , ROW_NUMBER() OVER (ORDER BY T.CODE) + 900 AS DISPLAY_SEQ

				FROM   (SELECT DISTINCT

							   CF.MEASURE              AS CODE

							 , CONCAT(N' └ ',MEASURE) AS NAME

						FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)

						WHERE  1 = 1

						AND    CF.VALID_YN      = 'Y'

						AND   CF.MEASURE_GROUP = 'CUST_FCST'

						AND    CF.DIVISION_ID   = @Param1

						AND    CF.SCM_SITE_ID   = @Param2

					   ) T

				          

				UNION ALL

				          



				                

				SELECT

					  L.SEGMENT2  AS CODE              

					, L.SEGMENT3  AS NAME                    

					, L.DISPLAY_SEQ

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

					INNER JOIN (SELECT TOP 1 VALID_YN,SEGMENT1,SEGMENT2,SEGMENT4 FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK) WHERE 1=1

									AND LOOKUP_TYPE	= 'TMM_MEASURE_ADMIN'

									AND VALID_YN	= 'Y'

									AND SEGMENT1	= @Param1	                        

									AND SEGMENT2	= @Param3	                         

									AND SEGMENT4	= @Param4	                   

									) T

						ON

						(

							L.SEGMENT1 = T.SEGMENT1                

						AND L.VALID_YN = T.VALID_YN

						AND L.LOOKUP_TYPE	= 'MKT_FCST_MEASURE'

						AND L.VALID_YN		= 'Y'

						AND L.SEGMENT1		= @Param1	                        

						AND L.ATTRIBUTE2    = 'Y'	                

						AND L.SEGMENT4	  = 'Y'	               

						)



				ORDER BY DISPLAY_SEQ

			END



		END;

	                                                 

                              

                    

              

                       

                          

            

             

         

                                                  

	IF @Code = 'SALES_PLAN_AMOUNT_KRW'

	    BEGIN

			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE VALID_YN = 'Y'

			AND LOOKUP_TYPE = 'SALES_PLAN_AMOUNT_KRW'

			ORDER BY DISPLAY_SEQ

		END;

	                                                 

                              

                    

              

                       

                          

            

             

         

                                                  

	IF @Code = 'SALES_PLAN_AMOUNT_USD'

	    BEGIN

			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE VALID_YN = 'Y'

			AND LOOKUP_TYPE = 'SALES_PLAN_AMOUNT_USD'

			ORDER BY DISPLAY_SEQ

		END;

	                                                 

                              

                    

              

                       

                          

            

             

         

                                                  

	IF @Code = 'SALES_PLAN_AMOUNT_LOC'

	    BEGIN

			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE VALID_YN = 'Y'

			AND LOOKUP_TYPE = 'SALES_PLAN_AMOUNT_LOC'

			ORDER BY DISPLAY_SEQ

		END;

	                                                 

                   

                    

              

                       

                          

            

             

         

                                                  

	IF @Code = 'SALES_PLAN_ITEM_ID'

	    BEGIN

			                                                                

			                                    

			                      

			                                        

			                      

			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME,

					SEGMENT3 AS GUBUN

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE VALID_YN = 'Y'

			AND LOOKUP_TYPE = 'SALES_PLAN_ITEM_ID'

			ORDER BY DISPLAY_SEQ

		END;

                                                     

                                    

                 

              

                       

                  

            

             

         

                                                  

	IF @Code = 'ESS_DIVISION_ID'

	    BEGIN

		    SELECT D.DIVISION_ID    AS CODE

			     , D.DIVISION_NAME  AS NAME

			FROM   [dbo].[SCM_MST_DIVISION] D WITH(NOLOCK)

			WHERE  1 = 1

			AND    D.DIVISION_ID = '82'

			AND    DIVISION_ID IN (SELECT CODE

			                       FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

								   WHERE  GroupID = @Param1 AND UserID = @Param2 AND AuthType = 'D')



		END;



	                                                 

                                    

                 

              

                       

                  

            

             

         

                                                  

	IF @Code = 'ESS_SCM_SITE_ID'

	    BEGIN

		    SELECT DISTINCT

			       EC.SCM_SITE_ID  AS CODE

			     , EC.SCM_SITE_ID  AS NAME

			FROM   [dbo].[DM_PLN_ESS_CHANNEL_PSI] EC WITH(NOLOCK)

			WHERE  1 = 1

			AND    EC.DIVISION_ID = '82'



		END;



	                                                 

                                

                 

              

                       

                  

            

             

         

                                                  

	IF @Code = 'ESS_ITEM_ID'

	    BEGIN

		    SELECT DISTINCT

			       EC.ITEM_ID  AS CODE

			     , EC.ITEM_ID  AS NAME

			FROM   [dbo].[DM_PLN_ESS_CHANNEL_PSI] EC WITH(NOLOCK)

			WHERE  1 = 1

			AND    EC.DIVISION_ID = '82'



		END;

                                                     

                                   

                                              

              

                       

                  

            

             

         

                                                  

	IF @Code = 'ESS_PSI_TYPE'

	    BEGIN

		    SELECT L.SEGMENT1  AS CODE

			     , L.SEGMENT2  AS NAME

			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

			WHERE  1 = 1

			AND    L.LOOKUP_TYPE = 'ESS_PSI_TYPE'

			ORDER BY L.DISPLAY_SEQ

		END;



                                                   

                

                  

              

                       

               

            

             

         

                                                  

	IF @Code = 'COUNTRY_MST'

	    BEGIN

		  SELECT A.COUNTRY CODE

			   , A.COUNTRY_NAME NAME

		  FROM   [dbo].[SCM_MST_COUNTRY] A WITH(NOLOCK)

		  WHERE  1=1

		  AND    A.VALID_YN = 'Y'

		  ORDER BY A.COUNTRY_NAME

		END;



                                                   

                     

                  

              

                       

               

            

             

         

                                                  

	IF @Code = 'CITY_MST'

	    BEGIN

			SELECT B.CITY CODE

			     , B.CITY_NAME NAME

			 FROM  [dbo].[SCM_MST_CITY]    B WITH(NOLOCK)

			WHERE B.VALID_YN = 'Y'

			                       

			  AND ( (@Param1 IS NULL OR @Param1 = '') OR B.COUNTRY IN (SELECT token FROM dbo.String_Split(@Param1	,',')) )

			ORDER BY  B.CITY_NAME

		END;

                                                   

                      

                                       

              

                       

               

            

                                                                    

          

                                                  

	IF @Code = 'CURRENCY_LIST'

	    BEGIN

			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE  (LOOKUP_TYPE = 'CURRENCY_LIST')

			AND  VALID_YN = 'Y'                                    

			ORDER BY  DISPLAY_SEQ

		END;

                                                   

                          

                            

              

                       

               

            

             

         

                                                  

	IF @Code = 'MULTITIMEZONECODE'

	    BEGIN

			select dbo.FN_MULTY_TIME(@Param1)

		END;

	                                                 

                                    

                                                      

              

                       

               

            

             

         

                                                  

	IF @Code = 'CUST_FCST_UPLOAD_UOM'

	    BEGIN

			SELECT CF.UPLOAD_UOM

            FROM   [dbo].[DM_MST_CUSTOMER_FCST] CF WITH(NOLOCK)

         WHERE  1 = 1

            AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

                     ELSE CF.DIVISION_ID

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param1,',') )

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

                     ELSE CF.SCM_SITE_ID

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',') )

            AND CASE WHEN @Param3 = 'ALL' OR @Param3 = '' THEN @Param3

                ELSE CF.MEASURE_GROUP

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param3,',') )

            AND CASE WHEN @Param4 = 'ALL' OR @Param4 = '' THEN @Param4

                     ELSE CF.MEASURE

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param4,',') )

			AND CASE WHEN @Param5 = 'ALL' OR @Param5 = '' THEN @Param5

                     ELSE CF.UPLOAD_BUCKET_TYPE

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param5,',') )

		END;



	                                                 

                                  

                          

              

                       

                 

            

             

         

                                                  

	IF @Code = 'DIVISION_COD_NAME'

		BEGIN

			SELECT DIVISION_ID AS CODE, MIN([DIVISION_NAME]) AS NAME FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)

			WHERE (@Param1 IS NULL OR DIVISION_ID LIKE '%' + @Param1 + '%') OR (@Param1 IS NULL OR DIVISION_NAME LIKE '%' + @Param1 + '%')

			GROUP BY DIVISION_ID

			ORDER BY DIVISION_ID

		END

	                                                 

                                                                              

                

              

                       

                           

            

             

         

                                                  

	IF @Code = 'SiteByEndCustomerAuth'

		BEGIN



			SELECT @v_dept_id = U.DEPT_ID

			FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

			WHERE  U.UserID = @Param4



			SELECT DISTINCT

			       SCM_SITE_ID AS CODE

			     , SCM_SITE_ID AS NAME

			FROM   SCM_MST_SITE A WITH(NOLOCK)

			WHERE  1 = 1

			AND A.VALID_YN = 'Y'

			AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

                        ELSE A.DIVISION_ID

	               END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')

	 )

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

                    ELSE A.END_CUSTOMER

 	            END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

	                    )

            AND    A.DIVISION_ID IN (SELECT CODE

		                          FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    	 AND    UserID  LIKE '%'+ @Param4 + '%'

								     AND    AuthType = 'D')

			              

			                                                     

				                                                                                          



				AND   ( @v_group_id = 'ADMIN'  OR  A.DEPT_ID IN  (

								SELECT  SEGMENT3

								FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

								WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

								AND SEGMENT1     =   @v_dept_id AND VALID_YN = 'Y'

								UNION

								SELECT U.DEPT_ID

								FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

								WHERE  U.UserID = @Param4 )     )

			ORDER BY SCM_SITE_ID ASC;

		END

	                                                 

                                                                                

                

              

                       

                           

            

             

                                                                                          

                                                  

	IF @Code = 'EndCustomerByDivisionDeptAuth'

		BEGIN



			SELECT @V_DEPT_ID = U.DEPT_ID

			FROM   [DBO].[TB_FX_USER] U WITH(NOLOCK)

			WHERE  U.USERID = @PARAM4



			SELECT DISTINCT

					A.END_CUSTOMER AS CODE

					, ISNULL(D.SEGMENT3, A.END_CUSTOMER) AS NAME

			FROM   SCM_MST_SITE A WITH(NOLOCK)

			LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)

				ON A.DIVISION_ID = D.SEGMENT1 AND A.END_CUSTOMER = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'

			WHERE  1 = 1

			AND    CASE WHEN @PARAM1 = 'ALL'  OR   @PARAM1 ='' THEN @PARAM1

						ELSE A.DIVISION_ID

					END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM1,',')

							)

			AND    CASE WHEN @PARAM2 = 'ALL'  OR  @PARAM2 ='' THEN @PARAM2

						ELSE A.DEPT_ID

					END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM2,',')

							)

			AND    A.DIVISION_ID IN (SELECT CODE

										FROM   TB_FX_USERGROUPAUTHEXTENTION AS A WITH(NOLOCK)

					    				WHERE  GROUPID LIKE '%'+ @PARAM3 + '%'

										AND    USERID  LIKE '%'+ @PARAM4 + '%'

										AND    AUTHTYPE = 'D')

			AND    END_CUSTOMER IS NOT NULL

			              

			                                                     

					                                                                                       

			AND   ( @V_GROUP_ID = 'ADMIN'  OR  A.DEPT_ID IN  (

								SELECT  SEGMENT3

								FROM  [DBO].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

								WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

								AND SEGMENT1     =   @V_DEPT_ID AND VALID_YN = 'Y'

								UNION

								SELECT U.DEPT_ID

								FROM   [DBO].[TB_FX_USER] U WITH(NOLOCK)

								WHERE  U.USERID = @PARAM4 )     )

			ORDER BY A.END_CUSTOMER

		END

	                                                 

                                                                        

                

              

                       

                           

            

             

         

                                                  



IF @Code = 'TeambyDivisionAuth'

		BEGIN

			                       

			DECLARE @v_team_cnt int=0;           



			                                                                                              

			                                                                      

			                                                                                              



												                                       

												                                                         

												                                         

												                    

												                                                                                                      

			SELECT  @v_team_cnt = COUNT(DEPT_ID)

				FROM

					(

					SELECT SEGMENT3 AS DEPT_ID

						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

							WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

								AND VALID_YN = 'Y'

								AND SEGMENT1 = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK)  WHERE UserID = @Param4)

					UNION



					SELECT DEPT_ID FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

						WHERE  U.UserID = @Param4

					) A

			                                                                                              

			                                                                      

			                                                                                              





			IF (@v_team_cnt <= 1)                

			BEGIN



				IF (@Param1 <> '40')

				BEGIN

					SELECT DISTINCT

						B.DEPT_ID       AS CODE

						                          

						, B.DEPT_NAME_KO  AS NAME

						                                                                                               

					FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

						, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

					WHERE  A.SITE_TYPE = 'SALES'

					AND    A.DEPT_ID  = B.DEPT_ID

					AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

						ELSE A.DIVISION_ID

						END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

						                                         

					                                                                                                        

					                                                  

							)

					AND    A.DIVISION_ID IN (SELECT CODE

							FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

							WHERE  GroupID LIKE '%'+ @Param3 + '%'

							AND    UserID  LIKE '%'+ @Param4 + '%'

							AND    AuthType = 'D')

					and B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	           

					ORDER BY CODE, NAME





					                  

					                 

					                            

					                             

					                                                      

					                                                         

					                           

					                              

					                                                                 

					                       

					                                                               

					         

				                   

					                                                       

					                                                                                             



					                                                                                                

				END

				ELSE

				BEGIN



					SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME

					  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

						  ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

						  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

					 WHERE A.OWNER = B.USER_ID

					 AND B.DEPT_ID = C.DEPT_ID

					   AND A.DIVISION_ID = '40'

					   AND B.DEPT_ID = CASE WHEN @v_group_id = 'ADMIN' THEN B.DEPT_ID ELSE @v_dept_id END	           

					  ORDER BY NAME

					                  

					                 

					                            

					                             

					                                                      

					                      

					                                                       

					                                                                           

					                                                        

					                                                                 

					               

					                      

					                                         

					                                

					      

					      

					                    

					                              

					                                              

					                                                                 

					                       

					                                                               

					         

				                   

					                                                       

					                                                                                             



					                                                                                                

				END

			END

			ELSE

			BEGIN

				IF (@Param1 <> '40')

				BEGIN

					             

					SELECT DISTINCT

					   B.DEPT_ID       AS CODE

					  , B.DEPT_NAME_KO  AS NAME

					FROM   [dbo].[SCM_MST_SITE]          A  WITH(NOLOCK)

						 , [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

					WHERE  A.SITE_TYPE = 'SALES'

					AND    A.DEPT_ID  = B.DEPT_ID

					AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

								ELSE A.DIVISION_ID

						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

								   )

					AND B.DEPT_ID IN (

						SELECT  SEGMENT3

						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

						WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

						AND VALID_YN = 'Y'

						AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @Param4)

						                           

						UNION

						SELECT U.DEPT_ID

						FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

						WHERE  U.UserID = @Param4

						                         

					)

				END

				ELSE

				BEGIN

					             

					SELECT DISTINCT

					   B.DEPT_ID       AS CODE

					  , B.DEPT_NAME_KO  AS NAME

					FROM   [dbo].[SCM_MST_SITE]       A  WITH(NOLOCK)

					                    

					LEFT JOIN [dbo].[SCM_MST_SITE_ITEM] ITEM WITH(NOLOCK)

						ON A.DIVISION_ID = ITEM.DIVISION_ID AND A.SCM_SITE_ID = ITEM.SCM_SITE_ID

					LEFT JOIN [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

						ON B.DEPT_ID  = CASE WHEN A.DIVISION_ID <> '40' THEN A.DEPT_ID

												ELSE (

								SELECT SU.DEPT_ID

							FROM [dbo].[SCM_MST_SSO_USER_INFO] su

						WHERE SU.USER_ID = ITEM.OWNER

								)

						END

					                  

					WHERE  A.SITE_TYPE = 'SALES'

					                                            

					AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

								ELSE A.DIVISION_ID

						   END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

								  )

					AND B.DEPT_ID IN (

						SELECT  SEGMENT3

						FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

						WHERE LOOKUP_TYPE   = 'PM_TEAM_MAPPING'

						AND VALID_YN = 'Y'

						AND SEGMENT1         = (SELECT DEPT_ID FROM [DBO].[TB_FX_USER] WITH(NOLOCK) WHERE UserID = @Param4)

						                           

						UNION

						SELECT U.DEPT_ID

						FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

						WHERE  U.UserID = @Param4

						                         

					)

				END

			END

		END



	IF 	@Code = 'Auth_Dept'



	    BEGIN

			DECLARE @v_admin  NVARCHAR(50);

			SET @v_admin = @Param2;



			                                                                                 

			                                                                     

			                                                                                 

			DECLARE @v_admin_group_id  NVARCHAR(50);

			IF ISNULL((

						SELECT COUNT(1) FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

							where LOOKUP_TYPE = 'GET_ADMIN_GROUP'

								AND VALID_YN = 'Y'

								AND SEGMENT2 = 'ALL'                                    

								AND SEGMENT1 = @v_admin

					  ),0) > 0

				BEGIN

					SET @v_admin_group_id = 'ADMIN'

				END

			                                                                                 

			                                                                   

			                                                                                 



			SELECT CASE WHEN @v_admin_group_id = 'ADMIN' THEN 'ADMIN'

			            ELSE @v_dept_id END AS CODE

				 , CASE WHEN @v_admin_group_id = 'ADMIN' THEN 'ADMIN'

			            ELSE @v_dept_id END AS NAME

	        FROM   [dbo].[TB_FX_User] U WITH(NOLOCK)

	        WHERE  U.USERID = @Param1

	    END;



	      

                              

       

                                  



                          



                                                                             

                                          

                                                                         

                                          

                                    

                                  

         

    



	                                                 

                                    

                                                

               

                        

                     

             

              

          

                                                   

	IF @Code = 'FCST_TYPE_NOT_ETC'

	BEGIN

		SELECT SEGMENT1 AS CODE

		     , SEGMENT2 AS NAME

		     , DISPLAY_SEQ

		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE  1 = 1

		AND    VALID_YN    = 'Y'

		AND    LOOKUP_TYPE = 'SALES_TYPE_CODE'

		AND    SEGMENT1  <> 'ETC'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                                                 

          

                

                        

                  

                        

           

          

                                                   

	IF @Code = 'LookupCommon2'

	BEGIN

		SELECT B.SEGMENT1 CODE

			  ,B.SEGMENT1 + ' : ' + B.SEGMENT2 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = @Param1

		  AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ

	END



	                                                 

                                    

          

                

                        

                  

                        

           

          

                                                   

	        

		                       

		IF @Code = 'PlantAll'



			BEGIN

				SELECT distinct S.PLANT_ID      AS CODE

					, (CASE

					   WHEN A.PLANT_NAME IS NULL

					        THEN V.VENDOR_NAME

					   ELSE A.PLANT_NAME

					   END )		   AS NAME

				FROM  SCM_MST_SITE S WITH(NOLOCK)

				LEFT OUTER JOIN  SCM_MST_PLANT_SN A  WITH(NOLOCK) ON A.DIVISION_ID = S.DIVISION_ID AND A.PLANT_ID = S.PLANT_ID                                           

				LEFT OUTER JOIN  SCM_MST_VENDOR V  WITH(NOLOCK) ON V.VENDOR_CODE = S.PLANT_ID

				WHERE (@Param1 = '' OR S.DIVISION_ID = @Param1)

					  AND

					  (

						(@Param2 IS NULL OR S.PLANT_ID LIKE '%' + @Param2 + '%') OR (@Param2 IS NULL OR PLANT_NAME LIKE '%' + @Param2 + '%')

					  )

				AND   S.VALID_YN ='Y'

				ORDER BY S.PLANT_ID

			END

                                                     

                                                 

                    

                                                         

                        

                   

                        

           

            

                                                             

                                                   

		IF @Code = 'DefaultBucketDay'

	    BEGIN

		    SELECT L.SEGMENT3  AS DEFAULTBUCKETDAY

            FROM  [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

            WHERE  1 = 1

            AND    L.LOOKUP_TYPE = 'DEFAULT_BUCKET_DAY'

            AND    L.VALID_YN    = 'Y'

            AND    L.SEGMENT1    = @Param1

            AND    L.SEGMENT2    = CASE WHEN @Param2 = 'DAILY' 

										THEN 'MONTHLY'

										ELSE @Param2 

									END                                                                                 

	    END



		                                                 

                             

                                              

                                                           

                        

               

                        

           

          

                                                   

		IF @Code = 'WaterfallVer'

	    BEGIN

			SELECT TOP 10 version_no AS code

			          ,version_no AS name

			FROM scp_anl_production_plan_c WITH(NOLOCK)

			WHERE division_id    = @Param1

			  AND ( (@Param2 IS NULL OR @Param2 = '') OR operation_group IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )

			GROUP BY version_no

			ORDER BY version_no DESC



	    END



		                                                 

                              

                                           

                                                    

                        

                

                        

           

          

                                                   

		IF @Code = 'WaterfallVer_FG'

		BEGIN

			SELECT TOP 10 version_no AS code

			             ,version_no AS name

			from SCP_ANL_SHIPMENT_PLAN_FG_C WITH(NOLOCK)

			WHERE division_id     = @Param1

			  AND ( (@Param2 IS NULL OR @Param2 = '') OR biz_type IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )

			GROUP BY version_no

			ORDER BY version_no DESC



	    END



		                                                 

                    

                                      

            

                        

                  

                        

           

          

                                                   

		IF @Code = 'Company'

		BEGIN

			SELECT A.COMPANY_ID CODE

				  ,A.COMPANY_NAME NAME

			FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)

	    END



		                                                 

                              

                                             

                                                           

                        

                

                        

           

          

                                                   

		IF @Code = 'WaterfallVer_SEMI'

		BEGIN

			SELECT TOP 10 version_no AS code

			             ,version_no AS name

			from SCP_ANL_SHIPMENT_PLAN_SEMI_C WITH(NOLOCK)

			WHERE division_id     = @Param1

			  AND ( (@Param2 IS NULL OR @Param2 = '') OR OPERATION_GROUP IN (SELECT token FROM dbo.String_Split(@Param2	,',')) )

			GROUP BY version_no

			ORDER BY version_no DESC

	    END



		                                                 

                           

                                         

                                                                                             

                        

                  

                        

           

                                         

                                                               

                                                   

		IF @Code = 'TransMode'

		BEGIN

			SELECT TRANSPORT_MODE CODE

			     ,TRANSPORT_MODE NAME

				 ,BOD_ID

				,ROUTE_ID

				                                                  

				            

				,SSP_INCOTERMS         AS INCOTERMS

				,D_COUNTRY

				,D_PORT_CODE

				,A_COUNTRY

				,A_PORT_CODE

				,LT_TOTAL

				,LT_TOTAL_ORIGIN	                   

				,TO_COUNTRY

				,TO_CITY

			FROM [DBO].[SCP_MST_BOD_V]  WITH(NOLOCK)                                 

			WHERE 1=1			

			AND division_id = @Param1

			AND from_site = @Param2

			AND to_site = @Param3

			                                                  

			                         

			AND ssp_incoterms = @Param4

			AND bod_valid_yn = 'Y'			

			order by priority

	    END	



		                                                 

                                                                       

          

                                            

                        

                  

                        

           

          

                                                   

		IF @Code = 'LookupCommon3'

		BEGIN

			SELECT B.SEGMENT1 CODE

				  ,B.SEGMENT1 + ' : ' + CASE WHEN U.Language = 'KO' THEN B.SEGMENT2 ELSE B.SEGMENT3 END NAME

			FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

			LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON U.UserID = @Param2 AND U.UseYN = 'Y'

			WHERE A.LOOKUP_TYPE = @Param1

				AND A.VALID_YN = 'Y'

			ORDER BY B.DISPLAY_SEQ

	    END





		                                                 

                                                                            

                                                                     

                                                                                          

                      

                

          

           

                                                                                          

                                                   



		IF @Code = 'EndCustomerByDivision40'

		BEGIN

		      

                                                             

                                       

                                                 

                                                                         

                        

                                                         

                                                                   

                 

                        

                                           

                                

        

        

                      

            

                             



                                                                  

                                    

                     

                                                                

         

                                         

                                                                

                                                    

                                                 

                                 

                                                

                                      

     



 			SELECT DISTINCT A.PROJECT_CODE AS CODE

				, ISNULL(D.SEGMENT3, A.PROJECT_CODE) AS NAME

			FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

				INNER JOIN [SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK) ON A.OWNER = B.USER_ID

				INNER JOIN [SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK) ON B.DEPT_ID = C.DEPT_ID

				LEFT OUTER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL D WITH(NOLOCK)

					ON A.DIVISION_ID = D.SEGMENT1 AND A.PROJECT_CODE = D.SEGMENT2 AND D.LOOKUP_TYPE = 'END_CUSTOMER' AND D.VALID_YN = 'Y'

			WHERE                      

			B.USER_ID = (SELECT TOP 1 TOKEN FROM DBO.STRING_SPLIT(A.OWNER,',') )             

			AND B.DEPT_ID = C.DEPT_ID

			AND A.DIVISION_ID = '40'

			AND CASE WHEN @PARAM2 = 'ALL'  OR  @PARAM2 ='' THEN @PARAM2

						                             

					ELSE B.DEPT_ID

					END  IN (  SELECT TOKEN FROM DBO.STRING_SPLIT(@PARAM2,',') )

			                        

			AND A.VALID_YN = 'Y'		                

			UNION

			SELECT SEGMENT2 AS CODE , SEGMENT3 AS NAME

			FROM  [SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

			WHERE  LOOKUP_TYPE = 'END_CUSTOMER'

			AND (@PARAM2 = 'ALL' OR  @PARAM2 =''  )

			AND SEGMENT2 <> '-'

			AND SEGMENT1  = CASE WHEN @PARAM1 = '' THEN SEGMENT1 ELSE @PARAM1 END                          

			AND VALID_YN = 'Y'		                

			AND SEGMENT1 = '40'                                      

			ORDER BY CODE





		END





		                                                 

                                                                                       

                                                                     

            

                      

                

          

           

          

                                                   



		IF @Code = 'ScmSitebyEndCustomer40'

		BEGIN



			SELECT DISTINCT ST.SCM_SITE_ID AS CODE, SITE_DESCRIPTION AS NAME

			FROM SCM_MST_SITE AS ST WITH(NOLOCK)

			                             

			                                                                                  

			                          

			                                                               

			        

			WHERE  1 = 1

			AND    ST.DIVISION_ID = '40'

			AND    ST.SITE_TYPE = 'SALES'

			                                                            

                                          

 	                                                                        



			                                                                    

                                                   

 	                                                                               

	                                                                      

            AND    ST.DIVISION_ID IN (SELECT CODE

		                             FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			 WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    	 AND    UserID  LIKE '%'+ @Param4 + '%'

								     AND    AuthType = 'D')

			ORDER BY ST.SCM_SITE_ID ASC;



		END





	                                                 

                   

                                          

              

                       

               

            

                        

                                                         

                                                  

	IF @Code = 'CUST_GROUP'

	    BEGIN



			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE  (LOOKUP_TYPE = 'CUST_GROUP')

				AND VALID_YN = 'Y'	                                                 

			ORDER BY  SEGMENT1                              

		END;



	                                                 

                          

                                          

              

                       

               

            

                        

                                                         

                                                  

	IF @Code = 'CUST_GROUP_DTL'

	    BEGIN



			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE  (LOOKUP_TYPE = 'CUST_GROUP_DTL')

				AND VALID_YN = 'Y'	                                                 

			ORDER BY  SEGMENT1                              

		END;



	                                                 

                          

                                          

              

                       

               

            

             

         

                                                  

	IF @Code = 'APPLICATION'

	  BEGIN



			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE  (LOOKUP_TYPE = 'APPLICATION')

			                       

			ORDER BY  SEGMENT1                              

		END;







	                                                 

                          

                                          

              

                       

               

            

             

         

                                                  

	IF @Code = 'ROUTE'

	    BEGIN



			SELECT SEGMENT1 AS CODE,

					SEGMENT2 AS NAME

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			WHERE  (LOOKUP_TYPE = 'ROUTE')

			                       

			ORDER BY  SEGMENT1                              

		END;





		                                                 

                                          

                                                                     

            

                      

                

          

           

          

                                                   



		IF @Code = 'EndCustomerByDivisionSml'

		BEGIN

		    SELECT

				   segment2 AS CODE

				  ,segment3 AS NAME

			 FROM dbo.SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			 WHERE LOOKUP_TYPE = 'END_CUSTOMER'

			 AND SEGMENT1 = '40'

			 AND VALID_YN = 'Y'                

			 ORDER BY segment2 ASC;

		END



	                                                 

                                

                               

              

                       

               

            

             

                                                                                   

                                                  

	IF @Code = 'PlantByDivisionOperationItem'

	BEGIN

		SELECT DISTINCT

			A.SCM_SITE_ID AS CODE ,

			A.SCM_SITE_ID + '   '+ A.SITE_DESCRIPTION +

			CASE WHEN B.PLANT_SITE_ID IS NOT NULL THEN ' Y' ELSE ' N' END	AS NAME

		FROM  [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)

		LEFT JOIN (

			SELECT DISTINCT ITEM_ID, PLANT_SITE_ID

			FROM (

				SELECT T.ITEM_ID , T.PLANT_SITE_ID

				FROM SCP_MST_TACT_TIME T WITH(NOLOCK)

				JOIN SCM_MST_SITE S  WITH(NOLOCK) ON S.SCM_SITE_ID=T.PLANT_SITE_ID

				JOIN SCM_MST_LINE_SN LS  WITH(NOLOCK) ON LS.COMPANY_ID=S.COMPANY_ID AND LS.DIVISION_ID=T.DIVISION_ID AND LS.SITE_ID=S.SITE_ID AND LS.PLANT_ID=S.PLANT_ID

										AND LS.OPERATION_ID=T.OPERATION_ID AND LS.LINE_ID=T.LINE_ID AND LS.ACTIVE_FLAG='Y'

				WHERE T.DIVISION_ID = @Param1

					AND T.ITEM_ID = @Param3

					AND T.VALID_YN='Y'

				GROUP BY T.ITEM_ID , T.PLANT_SITE_ID

				                                          

				UNION ALL

				SELECT T.ITEM_ID , T.PLANT_SITE_ID

				FROM SCP_MST_TACT_TIME_OSP T WITH(NOLOCK)

				JOIN SCM_MST_SITE S  WITH(NOLOCK) ON S.SCM_SITE_ID=T.PLANT_SITE_ID

				JOIN SCM_MST_LINE_OSP LS  WITH(NOLOCK) ON LS.DIVISION_ID=T.DIVISION_ID AND LS.SCM_SITE_ID=T.PLANT_SITE_ID AND LS.LINE_ID=T.LINE_ID AND LS.VALID_YN='Y'

				WHERE T.DIVISION_ID = @Param1

				AND T.ITEM_ID = @Param3

				AND T.VALID_YN='Y'

				GROUP BY T.ITEM_ID , T.PLANT_SITE_ID

			) A

		) B ON A.SCM_SITE_ID=B.PLANT_SITE_ID

		WHERE  1 = 1

		AND  A.VALID_YN ='Y'

		AND  A.SITE_TYPE = 'PLANT'

		AND  ( ( @Param1 IS NULL OR  @Param1='' ) OR  A.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,',')) )

		AND  ( ( @Param2 IS NULL OR  @Param2='' ) OR  A.OPERATION_GROUP IN ( SELECT token FROM dbo.String_Split(@Param2,',')) )

		ORDER BY CODE

		  

                 

                          

                                              

                                                                        

                                            

             

                                     

                           

                                                       

                                                                                                                                             

                                                                                           

                                

                           

                      

                                       

                                      

              

                      

                            

                                                                                                                     

                                                                                                                         

               

    

	END;



	                                                 

                              

         

              

                       

               

                       

          

         

                                                  



	IF @CODE = 'TeambyDivision2'

	BEGIN



		IF @Param1 = ''

			SET @Param1 = 'ALL';



		IF (@Param1 = 'ALL')                            

		BEGIN

			SELECT CODE, NAME FROM (

				SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME

				  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

					  ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

					  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

				 WHERE A.OWNER = B.USER_ID

				   AND B.DEPT_ID = C.DEPT_ID

				   AND A.DIVISION_ID IN ('40', '42', '44')		           

				UNION ALL

				SELECT DISTINCT

					B.DEPT_ID       AS CODE

					                          

					, B.DEPT_NAME_KO  AS NAME

					                                                                                               

				FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

					, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

				WHERE  A.SITE_TYPE = 'SALES'

				AND    A.DEPT_ID  = B.DEPT_ID

				AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

					ELSE A.DIVISION_ID

					END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

					                                         

				                                                                                                        

				                                                  

						)

				AND    A.DIVISION_ID IN (SELECT CODE

						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

						WHERE  GroupID LIKE '%'+ @Param2 + '%'

						AND    UserID  LIKE '%'+ @Param3 + '%'

						AND    AuthType = 'D')

			) MA

			ORDER BY NAME, CODE

		END

		ELSE IF (@Param1 = '40')

		BEGIN

			                              

			SELECT DISTINCT C.DEPT_ID AS CODE , C.DEPT_NAME_KO AS NAME

			  FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

			      ,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

				  ,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

			 WHERE A.OWNER = B.USER_ID

			   AND B.DEPT_ID = C.DEPT_ID

			   AND A.DIVISION_ID = '40'



		END

		ELSE

		BEGIN

			SELECT DISTINCT

				B.DEPT_ID       AS CODE

				                          

				, B.DEPT_NAME_KO  AS NAME

				                                                                                               

			FROM   [dbo].[SCM_MST_SITE]          A WITH(NOLOCK)

				, [dbo].[SCM_MST_SSO_DEPT_INFO] B WITH(NOLOCK)

			WHERE  A.SITE_TYPE = 'SALES'

			AND    A.DEPT_ID  = B.DEPT_ID

			AND    CASE WHEN @Param1 = 'ALL' THEN 'ALL'

				ELSE A.DIVISION_ID

				END  IN ( SELECT token FROM dbo.String_Split(@Param1,',')

				                                         

			                                                                                             

			                                                  

					)

			AND    A.DIVISION_ID IN (SELECT CODE

					FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					WHERE  GroupID LIKE '%'+ @Param2 + '%'

					AND    UserID  LIKE '%'+ @Param3 + '%'

					AND    AuthType = 'D')

			ORDER BY CODE, NAME

		END

	END







	                                                 

       

         

              

         

               

            

             

         

                                                  

	IF @Code = 'LineProdPlanLine'

	BEGIN

		SELECT

		DISTINCT

				A.LINE_ID						  AS CODE

				,A.LINE_ID + '   ' + A.LINE_NAME  AS NAME

		FROM [dbo].SCM_MST_LINE_SN A  WITH(NOLOCK)

		JOIN [dbo].SCM_MST_SITE B  WITH(NOLOCK) ON A.COMPANY_ID = B.COMPANY_ID AND A.SITE_ID = B.SITE_ID AND  A.DIVISION_ID = B.DIVISION_ID AND A.PLANT_ID = B.PLANT_ID

		JOIN [dbo].SCP_ANL_PRODUCTION_PLAN C  WITH(NOLOCK) ON C.DIVISION_ID = @Param1

												AND C.OPERATION_GROUP=@Param2

												AND ( (@Param3 IS NULL OR @Param3 ='') OR C.SCM_SITE_ID IN ( SELECT token FROM dbo.String_Split(@Param3,','))   )

		INNER JOIN  (SELECT DISTINCT b.segment4, b.segment1

						FROM   scm_adm_lookup_master_detail b WITH(NOLOCK)

						WHERE  b.lookup_type = 'LOCATION_GROUP_ROUTE'

						AND    b.valid_yn    = 'Y'

						AND    b.segment3    = 'Y'                 

					) f ON a.operation_id = f.segment4                                                                                    

		WHERE 1=1

		AND A.ACTIVE_FLAG ='Y'

		AND A.DIVISION_ID = C.ORIGIN_DIVISION_ID

		AND A.LINE_ID = C.LINE_ID

		UNION ALL

		SELECT

			'-'  AS CODE

			,'-'  AS NAME

		ORDER BY NAME

	END;



	                                                 

                    

         

              

                       

               

                       

          

         

                                                  

	IF @CODE = 'DM_Biz_Type'

	BEGIN

		SELECT L.SEGMENT1  AS CODE

			, L.SEGMENT2  AS NAME

		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

		WHERE  1 = 1

		AND    L.LOOKUP_TYPE = 'DM_BIZ_TYPE'

		ORDER BY L.DISPLAY_SEQ

	END



	                                                 

                                                                 

         

              

                       

               

                       

          

         

                                                  

	IF @Code = 'SiteByEndCustomer_InnerCode'



	BEGIN



		IF (@Param1 <> '40')

		BEGIN

			SELECT DISTINCT

					SCM_SITE_ID AS CODE

					, SCM_SITE_ID AS NAME

			FROM   SCM_MST_SITE A WITH(NOLOCK)

			WHERE  1 = 1

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1			                 

						ELSE A.DIVISION_ID

 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2			                 

						ELSE A.END_CUSTOMER

 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

						                                          

                                                                                                                                      

                                         				                 

						)

			AND    A.DIVISION_ID IN (SELECT CODE

										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		AND    UserID  LIKE '%'+ @Param4 + '%'

										AND    AuthType = 'D')

			AND A.VALID_YN = 'Y'	              



			UNION ALL	           



			                                       

			                          

			                                                   

			                                                      



			                                                                      



										                          

										                       

										                                                        

										                                    



			SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)



			                                                                      



			ORDER BY SCM_SITE_ID ASC;



		END

		ELSE

		BEGIN

			                 

			SELECT DISTINCT

					A.SCM_SITE_ID AS CODE

					, A.SCM_SITE_ID AS NAME

			FROM   SCM_MST_SITE AS A WITH(NOLOCK)

				LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK)

				ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID

			WHERE  1 = 1

			AND    A.SITE_TYPE = 'SALES'

			AND CASE WHEN @Param1 = 'ALL' OR @Param1 = '' THEN @Param1

						ELSE A.DIVISION_ID

 				END  IN ( SELECT token FROM dbo.String_Split(@Param1,','))

			AND CASE WHEN @Param2 = 'ALL' OR @Param2 = '' THEN @Param2

						ELSE B.PROJECT_CODE

 				END  IN ( SELECT token FROM dbo.String_Split(@Param2,',')

						)

			AND    A.DIVISION_ID IN (SELECT CODE

										FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    				WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    		AND    UserID  LIKE '%'+ @Param4 + '%'

										AND    AuthType = 'D')

			AND A.VALID_YN = 'Y'



			UNION ALL	           



			                                       

			                          

			                                                   

			                                                      



			                                                                      

											                          

											                       

											                                                        

											                                    



			SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)



			                                                                      





			ORDER BY A.SCM_SITE_ID ASC;

		END

	END



	                                                 

                                                

                            

              

                       

                         

                       

          

         

                                                  

	IF @Code = 'COMPANY_ID_INTERNAL_TXN'



	BEGIN



		                                                                      

										                          

										                       

										                                                        

										                                    

		SELECT COMPANY_ID AS CODE,COMPANY_ID AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)

		                                                                      





	END





		                                                 

                           

                      

              

                       

               

                       

          

         

                                                  

	IF @Code = 'EOL_ReasonCode'

	BEGIN



		SELECT SEGMENT1  AS CODE

				, SEGMENT2  AS NAME

		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'EOL_REASON'



	END





	                                                 

                           

                      

              

                       

               

                       

          

         

                                                  

	IF @Code = 'EOL_ReasonStatus'

	BEGIN



		SELECT SEGMENT1  AS CODE

				, SEGMENT2  AS NAME

		FROM [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'EOL_STATUS'



	END



	                                                 

                              

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0041_MDF_Team'

	BEGIN



		SELECT

			DEPT_ID	AS CODE

			, DEPT_NAME_KO		AS NAME

		FROM[DBO].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)

		WHERE DEPT_NAME_KO LIKE N'%소형%마케팅%담당'

		  AND VALID_YN = 'Y'



	END



	                                                 

                                   

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0041_MDF_Measure'

	BEGIN



		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME		           

		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

		WHERE PROGRAM_ID = 'DMF0041' AND SHEET_NAME = 'MDFSimulator'

		ORDER BY SORT_ORDER_NO



		                                            

		                                           

		                                        

		                      



	END





	                                                 

                                    

                 

              

                       

               

         

          

                                             

                                                  

	IF @Code = 'dtlocToSite'

	BEGIN



		SELECT DISTINCT PROJECT_CODE AS CODE, PROJECT_CODE AS NAME

		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)

		WHERE DIVISION_ID = @Param1

		AND   ITEM_ID = @Param2

		AND   SCM_SITE_ID = @Param3

		ORDER BY PROJECT_CODE



	END



	                                                 

                                    

                  

              

                       

               

         

          

                                             

                                                  

	IF @Code = 'dtlocBodTotal'

	BEGIN



		SELECT TRANSPORT_MODE+':'+BOD_ID+':'+convert(nvarchar,ROUTE_ID)+':'+convert(nvarchar,LT_TOTAL) AS CODE

				, TRANSPORT_MODE NAME

		FROM   SCP_MST_BOD_V WITH(NOLOCK)

		WHERE  DIVISION_ID = @Param1

		AND    FROM_SITE   = @Param2



	END

	                                                 

                                 

                  

              

                       

                  

         

          

                                             

                                                  

	IF @Code = 'OWMS_STOCK_STATUS'

	BEGIN



		SELECT

			SEGMENT1 AS CODE,

			NAME =	CASE @Param2

						WHEN 'KO' THEN SEGMENT2

						WHEN 'EN' THEN SEGMENT3

						WHEN 'CN' THEN SEGMENT4

					END



		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE  LOOKUP_TYPE = @Param1

	END



	                                                 

                                

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0005_REPORT_GROUP1'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP1'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP2'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP2'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP3'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP3'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP4'

	BEGIN



	  SELECT

			DISTINCT

			L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP4'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP5'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP5'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP6'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP6'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP7'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP7'

	  AND    L.VALID_YN    = 'Y'



	END

	IF @Code = 'DMF0005_REPORT_GROUP8'

	BEGIN



	  SELECT L.SEGMENT1  AS CODE

		   , L.SEGMENT2  AS NAME

	  FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

	  WHERE  1 = 1

	  AND    L.LOOKUP_TYPE = 'REPORT_GROUP8'

	  AND    L.VALID_YN    = 'Y'



	END



	                                                 

                                   

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0042_BP_Measure'

	BEGIN



		IF (@Param1 = '') BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan'

			ORDER BY SORT_ORDER_NO

		END ELSE BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0042' AND SHEET_NAME = 'Biz Plan'

				                                                                        

				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

			ORDER BY SORT_ORDER_NO

		END



	END



	                                                 

                                    

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0041_MDF_Currency'

	BEGIN



		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

		WHERE PROGRAM_ID = 'DMF0041' AND SHEET_NAME = 'MDF_Unit'

		ORDER BY SORT_ORDER_NO

	END



	                                                 

                                  

                               

                                  

                       

                  

                       

          

         

                                                  

	ELSE IF @Code = 'ProductionPlanOSP'

		BEGIN

			SELECT

				SCM_SITE_ID AS CODE,

				SITE_DESCRIPTION + ' ('+ SCM_SITE_ID + ')' AS NAME

			FROM SCM_MST_SITE WITH(NOLOCK)

			WHERE DIVISION_ID = '40'                

			  AND   SITE_TYPE  = 'PLANT'

			  AND   OSP_YN  = 'Y'

			  AND   VALID_YN = 'Y'

			ORDER BY SITE_DESCRIPTION

		END



	                                                 

                                  

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_Name'



	BEGIN

		SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'MDF_NAME'

			AND VALID_YN = 'Y'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                                           

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_PRODUCT_GROUP'



	BEGIN

		SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'MDF_MODEL_TYPE'

			AND VALID_YN = 'Y'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                                 

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_MEASURE'

	BEGIN



		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

		WHERE PROGRAM_ID = 'DMF0044' AND SHEET_NAME = 'MDF Reports'

		ORDER BY SORT_ORDER_NO

	END

	                                                 

                                 

                  

              

                       

                   

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_MEASURE_ETC'

	BEGIN



		SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

		FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

		WHERE PROGRAM_ID = 'DMF0044' AND SHEET_NAME = 'MDF Reports'

			AND COLUMN_NAME IN ('SalesAmt_KRW', 'SalesAmt_LOC')

		ORDER BY SORT_ORDER_NO

	END



	                                                 

                            

          

                                            

                        

                   

                        

           

          

                                                   

		IF @Code = 'CHANGE_REASON_CODE_ALL'

		BEGIN

			SELECT

				T0.CODE

				, T0.NAME

			FROM

			(

				  

                           

                  

                        

             

                        

                                                                  

                            

                           

      

				SELECT '-' AS CODE, NULL AS NAME, 0 AS DISPLAY_SEQ

				UNION ALL

				SELECT B.SEGMENT1 CODE

						,B.SEGMENT1 + ' : ' + CASE WHEN U.Language = 'KO' THEN B.SEGMENT2 ELSE B.SEGMENT3 END NAME

						,B.DISPLAY_SEQ AS DISPLAY_SEQ

				FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

				LEFT OUTER JOIN TB_FX_User U WITH(NOLOCK) ON U.UserID = @Param2 AND U.UseYN = 'Y'

				WHERE A.LOOKUP_TYPE = @Param1

					AND A.VALID_YN = 'Y'

			) T0

			ORDER BY T0.DISPLAY_SEQ



	    END



	                                                 

                                           

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_ENDCUST_REPORT'

	BEGIN



		                               

		SELECT DISTINCT T1.ATTRIBUTE2 AS CODE

			,T1.ATTRIBUTE2 AS NAME

		FROM	SCM_MST_SITE_ITEM		T1  WITH(NOLOCK)

		JOIN 	DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)

		ON	T1.DIVISION_ID = T2.DIVISION_ID

		AND	T1.ITEM_ID   = T2.ITEM_ID

		WHERE (T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'H' END

			OR	 T2.ITEM_TYPE  = CASE WHEN T1.DIVISION_ID = '40' THEN T2.ITEM_TYPE ELSE 'P' END)

			AND T1.ATTRIBUTE2 IS NOT NULL AND T1.ATTRIBUTE2 <> ''

		ORDER BY T1.ATTRIBUTE2

	END



	                                                 

                                        

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_CUST_REPORT'

	BEGIN



		                               

		SELECT DISTINCT T1.REPORT_GROUP2 AS CODE

			,T1.REPORT_GROUP2 AS NAME

		FROM	SCM_MST_SITE_ITEM		T1  WITH(NOLOCK)

		JOIN 	DM_MST_ITEM_SINGLE_V	T2  WITH(NOLOCK)

		ON	T1.DIVISION_ID = T2.DIVISION_ID

		AND	T1.ITEM_ID   = T2.ITEM_ID

		WHERE T1.REPORT_GROUP2 IS NOT NULL AND T1.REPORT_GROUP2 <> ''

	END



	                                                 

                                  

                  

              

                       

               

         

         

         

                                                  

	IF @Code = 'DMF0044_MDF_Team'

	BEGIN



		SELECT

			DEPT_ID	AS CODE

			, DEPT_NAME_KO		AS NAME

		FROM[DBO].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)

		WHERE DEPT_NAME_KO LIKE N'%소형%마케팅%담당'

		  AND VALID_YN = 'Y'

	END





	                                                 

                                      

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_ETC_SALE_RESULT_TYPE_40'

	BEGIN



		SELECT L.SEGMENT1  AS CODE

			, L.SEGMENT2  AS NAME

		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

		WHERE  1 = 1

		AND    L.LOOKUP_TYPE = 'DMF0044_ETC_SALE_RESULT_TYPE_40'

		AND    L.VALID_YN    = 'Y'



	END



	                                                 

                                            

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_DEPARTMENT_TEAM'

	BEGIN



		                            

		      

		   

		                                      

		            

		                                                                             

		                                          

		                                                                  

		            

		                                                                             

		                        

		                                                                  

		      



		                                     

		           

		SELECT DEPT_ID	AS CODE, DEPT_NAME_KO	AS NAME

		FROM [DBO].[SCM_MST_SSO_DEPT_INFO] WITH(NOLOCK)

		                                         

		WHERE UPPER_DEPT_ID = @Param1 AND VALID_YN = 'Y'



	END



	                                                 

                                                      

                                 

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_DEPARTMENT_TEAM2'

	BEGIN



		IF @Param1 <> ''

		BEGIN

			IF @Param1 = '40'

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'

				AND    L.VALID_YN    = 'Y'

				                                                                          

				ORDER BY DISPLAY_SEQ

			END

			ELSE

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2_' + RTRIM(@Param1)

				AND    L.VALID_YN    = 'Y'

				                                                                          

				ORDER BY DISPLAY_SEQ

			END

		END

		ELSE

		BEGIN

			SELECT L.SEGMENT1  AS CODE

				, L.SEGMENT2  AS NAME

			FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

			WHERE  1 = 1

			AND    L.LOOKUP_TYPE = 'DMF0044_DEPARTMENT_TEAM2'

			AND    L.VALID_YN    = 'Y'

			                                                                          

			ORDER BY DISPLAY_SEQ

		END



		                            

		      

		   

		                                      

		        

		                    

		         

		                                                                                            

		          

		                                                                            

		                                                         

		                                            

		                            

		                                                                                 

		                                

		        

		       

		                    

		        

		                    

		         

		                                                                                            

		          

		                                                                            

		                                              

		                                            

		                            

		                                                                                 

		                                

		        

		       

		                    

		      

		               

	END





	                                                 

                                                

                  

             

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0044_MDF_DEPARTMENT'

	BEGIN



		IF @Param1 <> ''

		BEGIN

			IF @Param1  = '40'

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT'

				AND    L.VALID_YN    = 'Y'

				ORDER BY DISPLAY_SEQ

			END

			ELSE

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT_' + RTRIM(@Param1)

				AND    L.VALID_YN    = 'Y'

				ORDER BY DISPLAY_SEQ

			END

		END

		ELSE	                        

		BEGIN

				SELECT L.SEGMENT1  AS CODE

					, L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'MDF_DEPARTMENT'

				AND    L.VALID_YN    = 'Y'

				ORDER BY DISPLAY_SEQ

		END



	END



	                                                 

                             

                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0005_DM_OS_CORP_CD'

	BEGIN



		SELECT L.SEGMENT1  AS CODE

			, L.SEGMENT2  AS NAME

		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

		WHERE  1 = 1

		AND    L.LOOKUP_TYPE = 'DM_OS_CORP_CD'

		AND    L.VALID_YN    = 'Y'



	END



	                                                 

                                           

                  

         

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0005_DM_CONTRIBUTION_TYPE_CD'

	BEGIN



		SELECT L.SEGMENT1  AS CODE

			, L.SEGMENT2  AS NAME

		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L  WITH(NOLOCK)

		WHERE  1 = 1

		AND    L.LOOKUP_TYPE = 'DM_CONTRIBUTION_TYPE_CD'

		AND    L.VALID_YN    = 'Y'



	END



	                                                 

                       

                                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0043_UPPER_DEPT'

	BEGIN

		SELECT

			DEPT_INFO.DEPT_ID AS CODE

			,DEPT_INFO.DEPT_NAME_KO AS NAME

			                         

		FROM (

			SELECT

				                                                     

				DISTINCT C.UPPER_DEPT_ID

			FROM SCM_MST_SITE_ITEM A  WITH(NOLOCK)

				,[SCM_MST_SSO_USER_INFO] B  WITH(NOLOCK)

				,[SCM_MST_SSO_DEPT_INFO] C  WITH(NOLOCK)

			WHERE A.OWNER = B.USER_ID

				AND B.DEPT_ID = C.DEPT_ID

				AND A.DIVISION_ID = '40'

		) MA

		JOIN SCM_MST_SSO_DEPT_INFO AS DEPT_INFO

		ON DEPT_INFO.DEPT_ID = MA.UPPER_DEPT_ID

		ORDER BY DEPT_NAME_KO

	END



	                                                 

                       

                                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0043_COMPANT_ID'

	BEGIN

		SELECT

			DISTINCT

			MA.CODE

			,MA.NAME

		FROM (

		                                                                      

										                            

										                        

										                                                             

										              

										                                       

										                           

		SELECT COMPANY_ID AS CODE,COMPANY_NAME AS NAME  FROM SCM_MST_COMPANY_SN WITH(NOLOCK)

		                                                                      



		) MA

		JOIN SCM_MST_SITE AS SITE

		ON MA.CODE = SITE.COMPANY_ID

	END



	                                                 

                        

                                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0043_END_CUST_REPORT'

	BEGIN

		SELECT DISTINCT ATTRIBUTE2 COLLATE Korean_Wansung_CS_AS AS CODE, ATTRIBUTE2 COLLATE Korean_Wansung_CS_AS AS NAME

		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)

		WHERE ATTRIBUTE2 IS NOT NULL AND ATTRIBUTE2 <> ''

		ORDER BY CODE

	END



	                                                 

                         

                                  

              

                       

               

         

          

         

                                                  

	IF @Code = 'DMF0043_CUST_GROUP_DTL'

	BEGIN

		SELECT DISTINCT ATTRIBUTE1 COLLATE Korean_Wansung_CS_AS AS CODE, ATTRIBUTE1 COLLATE Korean_Wansung_CS_AS AS NAME

		FROM SCM_MST_SITE_ITEM WITH(NOLOCK)

		WHERE ATTRIBUTE1 IS NOT NULL AND ATTRIBUTE1 <> ''

		ORDER BY CODE

	END



	                                                 

                                                  

                                               

              

                       

               

            

             

         

                                                  

	IF @Code = 'FCST_TYPE_NOT_ETC2'

	BEGIN

		SELECT SEGMENT1 AS CODE

		     , SEGMENT2 AS NAME

		     , DISPLAY_SEQ

		FROM   SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE  1 = 1

		AND    VALID_YN    = 'Y'

		AND    LOOKUP_TYPE = 'SALES_TYPE_CODE2'

		AND    SEGMENT1   <> 'ETC'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                     

                      

               

                        

                  

              

              

          

                                                  

	 ELSE IF @Code = 'LineByOperationOsp'

		BEGIN

			SELECT LINE_ID AS CODE

					, LINE_NAME AS NAME

					, DIVISION_ID

					, SCM_SITE_ID

			FROM SCM_MST_LINE_OSP WITH(NOLOCK)

			WHERE 1=1

			AND ISNULL(VALID_YN,'Y')='Y'

		END;

	                                                 

                                       

                              

               

                        

                    

              

              

          

                                                  

	 ELSE IF @Code = 'DM_COMPANY'

		BEGIN



		SELECT B.SEGMENT1 CODE

			  ,B.SEGMENT2 NAME

		FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

		INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

		WHERE A.LOOKUP_TYPE = 'DM_COMPANY'

		  AND A.VALID_YN = 'Y'

		ORDER BY B.DISPLAY_SEQ

		END;

	                                                 

                                                                   

                                           

              

                       

                 

              

              

          

                                                  

	 ELSE IF @Code = 'EndCustReport'

		BEGIN

			SELECT B.SEGMENT1 CODE

				  ,B.SEGMENT2 NAME

			FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

			WHERE A.LOOKUP_TYPE = 'END_CUST_REPORT'

			  AND A.VALID_YN = 'Y'

			ORDER BY B.DISPLAY_SEQ

		END;



	                                                 

                                                                      

                                           

              

                       

                 

              

              

                                                                   

                                                  

	 ELSE IF @Code = 'SoldToCustReport'

		BEGIN

			SELECT B.SEGMENT1 CODE

				  ,B.SEGMENT2 NAME

			FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

			INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

			WHERE A.LOOKUP_TYPE = 'SOLD_TO_CUST_REPORT'

			  AND A.VALID_YN = 'Y'

			ORDER BY B.SEGMENT1

		END;

	                                                 

                              

                   

                                

                            

                                                                

                        

                  

                        

                  

          

                                                   

		ELSE IF @Code = 'DM_LOOKUP_DIV'

			BEGIN

				SELECT B.SEGMENT2 CODE

					 ,B.SEGMENT3 NAME

				FROM SCM_ADM_LOOKUP_MASTER A WITH(NOLOCK)

				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B WITH(NOLOCK) ON A.LOOKUP_TYPE = B.LOOKUP_TYPE  AND B.VALID_YN = 'Y'

				WHERE A.LOOKUP_TYPE = @param2

				  AND B.SEGMENT1 = @param1

				  AND A.VALID_YN = 'Y'

				ORDER BY B.DISPLAY_SEQ

			END;

		                                                 

                       

                   

                                   

                        

                  

                        

           

          

                                                   

		ELSE IF @Code = 'PlantSiteByFactoryEEOperation'

		BEGIN

			 SELECT DISTINCT

			        A.SCM_SITE_ID      AS CODE

				  , A.SITE_DESCRIPTION AS NAME

				  , A.DIVISION_ID      AS DIVISION_ID

				  , A.PLANT_ID         AS PLANT_ID

			   FROM [dbo].[SCM_MST_SITE] A WITH(NOLOCK)

			   JOIN [dbo].[SCM_MST_FACTORY_SN] F WITH(NOLOCK)

				 ON A.COMPANY_ID  = F.COMPANY_ID

				AND A.PLANT_ID    = F.PLANT_ID

				AND A.DIVISION_ID = F.DIVISION_ID

			  WHERE 1 = 1

			    AND A.SITE_TYPE = 'PLANT'

				AND A.VALID_YN  = 'Y'

				AND A.OPERATION_GROUP = 'E'

			    AND A.DIVISION_ID  IN ( SELECT token FROM dbo.String_Split(@Param1,','))



		END

		                                                 

                 

                   

                                   

                         

                        

                  

                        

                  

                                          

                                                   

		ELSE IF @Code = 'BuildingForShipMasterElec'

			BEGIN

				SELECT

				  DISTINCT

						  F.FACTORY_NAME  AS CODE

						, F.FACTORY_ID    AS NAME

						, F.DIVISION_ID   AS DIVISION_ID

						, F.PLANT_ID      AS PLANT_ID

						, F.COMPANY_ID    AS COMPANY_ID

						, S.SCM_SITE_ID   AS SCM_SITE_ID

				     FROM [dbo].[SCM_MST_FACTORY_SN] F WITH(NOLOCK)

				     JOIN [dbo].[SCM_MST_SITE] S WITH(NOLOCK)

					   ON S.DIVISION_ID = F.DIVISION_ID

					  AND S.PLANT_ID    = F.PLANT_ID

				 WHERE 1=1

					AND ( (@Param1 IS NULL or @Param1='') OR F.DIVISION_ID IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )

					AND ( (@Param2 IS NULL or @Param2='') OR F.PLANT_ID IN ( SELECT token FROM dbo.String_Split(@Param2,','))  )

			END

		                                                 

                         

                   

                                   

                        

                  

          

           

          

                                                   

		ELSE IF @Code = 'ElectrodePostOperCode'

			BEGIN

				SELECT  SEGMENT2 AS CODE                            

					 , SEGMENT4 AS NAME              

					 , SEGMENT5 AS POST_OPER_LT                      

					 , SEGMENT1 AS DIVISION_ID

				  FROM  SCM_ADM_LOOKUP_MASTER_DETAIL LP WITH(NOLOCK)

				 WHERE LP.LOOKUP_TYPE = 'ELECTRODE_POST_OPER_CODE'

				   AND LP.VALID_YN    = 'Y'

				   AND ( (@Param1 IS NULL or @Param1='') OR LP.SEGMENT1 IN ( SELECT token FROM dbo.String_Split(@Param1,','))  )

			END;

		                                                 

                   

                   

            

                        

                  

                        

           

          

                                                   

		ELSE IF @Code = 'DomExpTypeCode'

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					 , L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'DOM_EXP_TYPE_CODE'

				ORDER BY L.DISPLAY_SEQ

			END;

		                                                 

                   

                   

            

                        

                  

                        

           

          

                                                   

		ELSE IF @Code = 'ElectrodePackageType'

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					 , L.SEGMENT2 AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

				WHERE  1 = 1

				AND    L.LOOKUP_TYPE = 'ELECTRODE_PACKAGE_TYPE'

				ORDER BY L.DISPLAY_SEQ

			END;

		                                                 

                     

                   

            

                        

                      

                        

           

          

                                                   

		ELSE IF @Code = 'PlantEE'

			BEGIN

				SELECT DISTINCT

					  LOGISTIC_PLANT_ID      AS CODE

					, LOGISTIC_PLANT_ID      AS NAME

				FROM SCM_MST_SITE S

				WHERE (@Param1 IS NULL OR @Param1='' OR DIVISION_ID=@Param1)

					AND (@Param2 IS NULL OR @Param2='' OR COMPANY_ID=@Param2)

					AND SITE_TYPE = 'PLANT'

					AND OPERATION_GROUP  ='E'

					AND OSP_YN = 'N'

				ORDER  BY S.LOGISTIC_PLANT_ID DESC

			END;

		ELSE IF @Code = 'PlantByElectordeShipFromSite'

			BEGIN

				SELECT SEGMENT3  AS CODE

					, SEGMENT3  AS NAME

				fROM SCM_ADM_LOOKUP_MASTER_DETAIL

				WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'

				AND VALID_YN = 'Y'

				AND (@Param1 IS NULL OR @Param1='' OR SEGMENT5=@Param1)

				AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)

				                                                         

				                                                          

				GROUP BY SEGMENT3

			END;

		ELSE IF @Code = 'PlantByElectordeShipToSite'

			BEGIN

				SELECT ATTRIBUTE1  AS CODE

					, ATTRIBUTE1  AS NAME

				fROM SCM_ADM_LOOKUP_MASTER_DETAIL

				WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'

				AND VALID_YN = 'Y'

				AND (@Param1 IS NULL OR @Param1='' OR SEGMENT5=@Param1)

				AND (@Param2 IS NULL OR @Param2='' OR SEGMENT4=@Param2)

				                                                         

				                                                         



				GROUP BY  ATTRIBUTE1

			END;

		ELSE IF @Code = 'PlantByElectordeShipToSite_EE'

			BEGIN

				SELECT ATTRIBUTE1  AS CODE

					, ATTRIBUTE1  AS NAME

				fROM SCM_ADM_LOOKUP_MASTER_DETAIL

				WHERE LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'

				AND VALID_YN = 'Y'

				AND (@Param1 IS NULL OR @Param1='' OR SEGMENT2=@Param1)

				AND (@Param2 IS NULL OR @Param2='' OR SEGMENT3=@Param2)

				                                                         

				                                                         



				GROUP BY  ATTRIBUTE1

			END;

		                                                 

                       

                   

            

                        

                  

                        

           

          

                                                   

		ELSE IF @Code = 'TransModeCode'

			BEGIN

				SELECT L.SEGMENT1  AS CODE

					 , L.SEGMENT2  AS NAME

				FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

				WHERE  1 = 1

				AND   L.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'

				ORDER BY L.DISPLAY_SEQ

			END;



		                                                 

                                             

                   

            

                        

                  

                        

           

                                                                                       

                                                              

                                                                   

                                             

                                                                             

                                                                                      

                                                                           

                                                                                  

                             

                                                   

		ELSE IF @Code = 'SalesCompany'

			BEGIN

				IF ( @Param4 = '')

				BEGIN

					SELECT DISTINCT

						   S.COMPANY_ID AS CODE

						 , S.COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE SITE_TYPE = 'PLANT'

						AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

						AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					UNION ALL

					SELECT DISTINCT

						   COMPANY_ID AS CODE

						 , COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

						AND    SITE_TYPE = 'CORP'

						AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

						AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					ORDER BY 1,2



				END

				ELSE

				BEGIN

					SELECT DISTINCT

						   S.COMPANY_ID AS CODE

						 , S.COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP                                                                                       

								from   scm_mst_project_item SI with(nolock)

								inner join SCM_MST_ITEM_SN I with(nolock)

								on     SI.ITEM_ID = I.ITEM_ID

								                                                                                                                               

								WHERE  1=1                                                                                                  

								AND    i.active_flag = 'Y'

								AND    (i.division_id LIKE '81%' OR i.division_id = '82')

								AND    i.item_type is not null                                                                          

								AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)

								AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)

								AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)



								UNION ALL

								SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP                                                                                       

								from   SCM_MST_ITEM_SN I with(nolock)

								WHERE  1=1

								AND    i.active_flag = 'Y'                                                                              

								AND    i.division_id in ('40')

								AND    i.item_type is not null                                                                            

								AND    (@Param2 IS NULL OR @Param2='' OR I.DIVISION_ID=@Param2)

								AND    (@Param4 IS NULL OR @Param4='' OR I.ITEM_ID=@Param4)

								) SS

					ON  S.DIVISION_ID = SS.DIVISION_ID

					AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)

					AND S.COMPANY_ID = SS.COMPANY_ID                                                                                       

					WHERE  1 = 1

					AND    SITE_TYPE = 'PLANT'

					                         

					AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					UNION ALL

					SELECT DISTINCT

						   COMPANY_ID AS CODE

						 , COMPANY_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

					AND    SITE_TYPE = 'CORP'

					AND    (@Param1 IS NULL OR @Param1='' OR PLANT_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					ORDER BY 1,2

				END



			END;

		                                                 

                                           

                   

            

                        

                  

                        

           

                                                                                       

                                                              

                                                                   

                                             

                                                                   

                                                                                     

                                                                           

                                                                                  

                             

                                                   

		ELSE IF @Code = 'SalesPlant'

			BEGIN

				IF ( ISNULL(@Param4,'') = '')

				BEGIN

					SELECT DISTINCT

						   CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS CODE

						 , CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

					AND    SITE_TYPE = 'PLANT'

					                         

					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					UNION ALL

					SELECT DISTINCT

						   PLANT_ID AS CODE

						 , PLANT_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

					AND    SITE_TYPE = 'CORP'

					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					ORDER BY 1,2

				END

				ELSE

				BEGIN

					SELECT DISTINCT

						   CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS CODE

						 , CASE WHEN OSP_YN = 'Y' THEN LOGISTIC_PLANT_ID ELSE PLANT_ID END AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP                                                                                       

								from   scm_mst_project_item SI with(nolock)

								inner join SCM_MST_ITEM_SN I with(nolock)

								on     SI.ITEM_ID = I.ITEM_ID

								                                                                                                                               

								WHERE  1=1                                                                                                  

								AND    i.active_flag = 'Y'

								AND    (i.division_id LIKE '81%' OR i.division_id = '82')

								AND    i.item_type is not null                                                                            

								AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)

								AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)

								AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)

								UNION ALL

								SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP                                                                                       

								from   SCM_MST_ITEM_SN I with(nolock)

								WHERE  1=1

								AND    i.active_flag = 'Y'                                                                              

								AND    i.division_id in ('40')

								AND    i.item_type is not null                                                                            

								AND    (@Param2 IS NULL OR @Param2='' OR I.DIVISION_ID=@Param2)

								AND    (@Param4 IS NULL OR @Param4='' OR I.ITEM_ID=@Param4)

								) SS

					ON  S.DIVISION_ID = SS.DIVISION_ID

					AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)

					AND S.COMPANY_ID = SS.COMPANY_ID                                                                                     

					WHERE  1 = 1

					AND    SITE_TYPE = 'PLANT'

					                         

					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					UNION ALL

					SELECT DISTINCT

						   PLANT_ID AS CODE

						 , PLANT_ID AS NAME

					FROM   SCM_MST_SITE S WITH(NOLOCK)

					WHERE  1 = 1

					AND    SITE_TYPE = 'CORP'

					AND    (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID=@Param1)

					AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

					ORDER BY 1,2

				END



			END;



		                                                 

                                                                      

                   

        

                        

                  

                        

           

          

                                                                                               

                                                                                        

                                                   

		ELSE IF @Code = 'PlantSiteByItem'

			BEGIN



				SELECT DISTINCT

						SCM_SITE_ID AS CODE

					  , SCM_SITE_ID AS NAME

				FROM   SCM_MST_SITE S WITH(NOLOCK)

				INNER join (SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID                                                                                       

						 , (CASE WHEN I.SCP_OPERATION_GROUP = 'E' THEN 'A' ELSE I.SCP_OPERATION_GROUP END) AS SCP_OPERATION_GROUP                                         

							from   scm_mst_project_item SI with(nolock)

							inner join SCM_MST_ITEM_SN I with(nolock)

							on     SI.ITEM_ID = I.ITEM_ID

							WHERE  1=1                                                                         

							AND    i.item_type is not null

							AND    (@Param2 IS NULL OR @Param2='' OR SI.DIVISION_ID=@Param2)

							AND    (@Param3 IS NULL OR @Param3='' OR SI.PROJECT_CODE=@Param3)

							AND    (@Param4 IS NULL OR @Param4='' OR SI.ITEM_ID=@Param4)

							) SS

				ON  S.DIVISION_ID = SS.DIVISION_ID

				AND S.OPERATION_GROUP = ISNULL(SS.SCP_OPERATION_GROUP, S.OPERATION_GROUP)

				AND S.COMPANY_ID = SS.COMPANY_ID                                                                                       

				WHERE  1 = 1

				AND    SITE_TYPE = 'PLANT'

				AND    (@Param2 IS NULL OR @Param2='' OR S.DIVISION_ID=@Param2)

				ORDER BY 1,2



			END;

		                                                 

                                                                

                   

            

                        

                  

                        

           

          

                                                   

		ELSE IF @Code = 'PlantCell'

			BEGIN

				SELECT DISTINCT

				       S.SCM_SITE_ID		AS CODE

				     , S.SITE_DESCRIPTION	AS NAME

				  FROM SCM_MST_SITE S WITH(NOLOCK)

				 WHERE (@Param1 IS NULL OR @Param1='' OR S.DIVISION_ID = @Param1)

				   AND S.OPERATION_GROUP    =  'A'	       

				   AND ISNULL(S.OSP_YN,'Y') <> 'Y'

				ORDER BY S.SITE_DESCRIPTION

			END;

		                                                 

                                                                          

                   

            

                        

                  

                        

           

          

                                                   

		ELSE IF @Code = 'FromSiteByAssembly'

			BEGIN

				SELECT DISTINCT

					   S.SCM_SITE_ID		AS CODE

					 , S.SITE_DESCRIPTION	AS NAME

					 , S.DIVISION_ID		AS DIVISION_ID

					                                    

					                                      

				  FROM SCM_ADM_LOOKUP_MASTER_DETAIL L WITH(NOLOCK)

				  JOIN SCM_MST_SITE S WITH(NOLOCK)

					ON S.DIVISION_ID = L.SEGMENT2      

				   AND S.SCM_SITE_ID = L.SEGMENT3

				 WHERE L.LOOKUP_TYPE = 'ELECTRODE_SHIP_FROM_TO'

				 AND (@Param1 IS NULL OR @Param1='' OR L.SEGMENT5   = @Param1)                    

				   AND (@Param2 IS NULL OR @Param2='' OR L.ATTRIBUTE1 = @Param2)                  

			END;

	                                                 

                       

                                     

         

                        

                  

           

          

                                                   

		ELSE IF @Code = 'SiteFP'

			BEGIN

				SELECT distinct

					   S.SITE_ID	AS CODE

					 , S.SITE_NAME	AS NAME

				  FROM SCM_MST_SITE_SN S WITH(NOLOCK)

				 WHERE 1 = 1

				   AND (@Param1 IS NULL OR @Param1='' OR S.COMPANY_ID = @Param1)

				 ORDER BY S.SITE_ID

			END

		                                                 

                                  

                             

            

                        

                  

                  

                       

                                                   

		ELSE IF @Code = 'MDMCategoryId'

			BEGIN

				SELECT DISTINCT

					   ATTRIBUTE1 AS CODE

					 , ATTRIBUTE1 AS NAME

				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)

				 WHERE 1=1

				   AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'

				   AND ACTIVE_FLAG = 'Y'

				                                            

				   AND ATTRIBUTE7 = 'Y'

			END

		                                                 

                             

                             

       

                        

                  

                  

                       

                                                   

		ELSE IF @Code = 'MDMKeyId'

			BEGIN

				SELECT SEGMENT1   AS CODE

					 , CASE WHEN SEGMENT1 IN ('LA001', 'LA002','LA003' ) THEN ATTRIBUTE1

							ELSE ATTRIBUTE2

					   END        AS NAME

					 , SEGMENT1   AS LOSS_CODE

					 , ATTRIBUTE1 AS CATEGORY_ID

					 , ATTRIBUTE3 AS DATA_TABLE

					 , ATTRIBUTE4 AS OFF_CAL

					 , ATTRIBUTE5 AS FP_UTIL_CAL

					 , ATTRIBUTE6 AS SCP_UTIL_CAL

					 , SORT_ORDER

				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)

				 WHERE 1=1

				   AND LOOKUP_TYPE_CODE = 'CAPA_UI_LOSS_TYPE_DEFINIT'                                                        

				   AND ACTIVE_FLAG = 'Y'

				                                            

				   AND ATTRIBUTE7 = 'Y'

				   AND (@Param1 IS NULL OR @Param1='' OR LV.ATTRIBUTE1 = @Param1)

			END

		                                                 

                       

                                              

            

                        

                  

                  

                                              

                                                   

		ELSE IF @Code = 'SysLookup'

			BEGIN

				SELECT ATTRIBUTE1			AS CODE

					 , CASE WHEN LOOKUP_TYPE_CODE = 'SHOP_GROUP_ID' THEN SEGMENT2 + '(' + SEGMENT1 + ')'

					   ELSE  SEGMENT2

					   END				AS NAME

				  FROM SCM_SYS_LOOKUP_VALUE_SN LV WITH(NOLOCK)

				 WHERE 1=1

				   AND LOOKUP_TYPE_CODE = @Param1

				   AND ACTIVE_FLAG = 'Y'

				   AND (@Param2 IS NULL OR @Param2='' OR LV.ATTRIBUTE1 = @Param2)

			END

		                                                 

                      

                                     

            

                        

                  

           

          

                                                   

		ELSE IF @Code = 'OperationByLine'

			BEGIN

				 SELECT DISTINCT

						A.OPERATION_ID    AS CODE

						, (A.OPERATION_ID + ' ' + B.OPERATION_NAME)  AS NAME, A.OPERATION_ID

					 FROM [dbo].SCM_line_HIERARCHY_V_SN A  WITH(NOLOCK)

					 JOIN (SELECT DISTINCT OPERATION_ID , OPERATION_NAME

					        FROM [dbo].SCM_MST_OPERATION_SN B  WITH(NOLOCK)

						  ) B

					     ON  A.OPERATION_ID = B.OPERATION_ID

					 WHERE 1=1

					 AND ( (@Param1 IS NULL or @Param1='') OR A.DIVISION_ID			IN ( SELECT token FROM dbo.String_Split(@Param1,',')))

					 AND ( (@Param2 IS NULL or @Param2='') OR A.PLANT_ID			IN ( SELECT token FROM dbo.String_Split(@Param2,',')))

					 AND ( (@Param3 IS NULL or @Param3='') OR A.FACTORY_ID			IN ( SELECT token FROM dbo.String_Split(@Param3,',')))

					 AND ( (@Param4 IS NULL or @Param4='') OR A.LINE_ID				IN ( SELECT token FROM dbo.String_Split(@Param4,',')))

					 AND ( (@Param5 IS NULL or @Param5='') OR A.OPERATION_GROUP_ID	IN ( SELECT token FROM dbo.String_Split(@Param5,',')))

			ORDER BY A.OPERATION_ID

			END

	                                                 



                                    

                                                

                                            

               

                        

                  

             

              

          

                                                   

	IF @Code = 'FCST_TYPE_NOT_FREE'

	BEGIN

		SELECT SEGMENT1 AS CODE,

		SEGMENT2 AS NAME,

		DISPLAY_SEQ

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE VALID_YN = 'Y'

		AND LOOKUP_TYPE = 'SALES_TYPE_CODE'

		AND SEGMENT4 <> 'FREE'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                                            

                  

                                                                                         

                    

                     

                     

                     

         

                                                  

	IF @Code = 'SoldToCustomerByDivisionDept'



		BEGIN



		SELECT DISTINCT

			  SOLDTO_CUSTOMER AS CODE

			, SOLDTO_CUSTOMER AS NAME

		FROM   SCM_MST_SITE A WITH(NOLOCK)

		WHERE  1 = 1

		AND    CASE WHEN @Param1 = 'ALL'  OR   @Param1 ='' THEN @Param1

                    ELSE A.DIVISION_ID

	          END  IN (  SELECT token FROM dbo.String_Split(@Param1,','))

		                                                                

		                                  

		                                                                      

		AND    A.DIVISION_ID IN (SELECT CODE

		       FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

					    			WHERE  GroupID LIKE '%'+ @Param3 + '%'

							    	AND    UserID  LIKE '%'+ @Param4 + '%'

								AND    AuthType = 'D')

		AND    SOLDTO_CUSTOMER IS NOT NULL



	END



	IF @Code = 'FromSiteByDivisionOspPack'



		BEGIN

		                                                 

                              

                   

                                                                     

                    

                    

                        

                      

          

                                                   

		                                            

		INSERT INTO @exception_company (company_id) select SEGMENT1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL with(nolock) 

			WHERE 1=1

			AND LOOKUP_TYPE = 'SSP_UI_EXCEPT_COMPANY' and VALID_YN='Y'

		                                          





		SELECT	SCM_SITE_ID        AS CODE

		,	   SITE_DESCRIPTION	   AS NAME

		,     COMPANY_ID                                         

		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)

		WHERE SITE_TYPE = 'PLANT'

		AND    A.VALID_YN  = 'Y'

		AND    A.OSP_YN  = 'Y'

		AND    A.OPERATION_GROUP = 'P'

		AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1

				ELSE A.DIVISION_ID

		END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')	 )

		AND    A.DIVISION_ID IN (SELECT CODE

						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

							WHERE  GroupID LIKE '%'+ @Param2 + '%'

							AND    UserID  LIKE '%'+ @Param3 + '%'

							AND    AuthType = 'D')

		AND not exists (select 1 from @exception_company K where a.COMPANY_ID = K.company_id)                                        

	END





	IF @Code = 'FromSiteByDivisionNoOspPack'



		BEGIN



		SELECT	SCM_SITE_ID        AS CODE

		,	   SITE_DESCRIPTION	   AS NAME

		FROM [dbo].[SCM_MST_SITE] AS A WITH(NOLOCK)

		WHERE SITE_TYPE = 'PLANT'

		AND    A.VALID_YN  = 'Y'

		AND    A.OSP_YN  = 'N'

		AND    A.OPERATION_GROUP = 'P'

		AND CASE WHEN @Param1 = 'ALL' OR @Param1 ='' THEN @Param1

				ELSE A.DIVISION_ID

		END  IN (  SELECT token FROM dbo.String_Split(@Param1,',')	 )

		AND    A.DIVISION_ID IN (SELECT CODE

						FROM   TB_FX_UserGroupAuthExtention AS A WITH(NOLOCK)

							WHERE  GroupID LIKE '%'+ @Param2 + '%'

							AND    UserID  LIKE '%'+ @Param3 + '%'

							AND    AuthType = 'D')



	END







	IF @Code = 'ShipToCodeByDivision'



		BEGIN

		                                                 

                       

                   

                                                      

                    

                    

                        

                      

          

                                                   



		SELECT

		   C.SHIPTO_CODE AS CODE,

		                                 

		   C.SHIPTO_CODE AS NAME

		FROM SCM_MST_CUSTOMER       C WITH(NOLOCK)

			,SCM_MST_SITE_CUSTOMER SC WITH(NOLOCK)

			,SCM_MST_SITE           S WITH(NOLOCK)

		WHERE 1=1

		AND S.DIVISION_ID    = SC.DIVISION_ID

		AND S.SCM_SITE_ID    = SC.SCM_SITE_ID

		                            

		                                                       

                        

    

		AND SC.DIVISION_ID   = C.DIVISION_ID

		AND SC.SOLDTO_CODE   = C.SOLDTO_CODE

		AND SC.SHIPTO_CODE   = C.SHIPTO_CODE

		AND S.DIVISION_ID    = @param1

		AND S.SCM_SITE_ID    = @param2

		;

	END

	else if @Code = 'DM_VMI_YN'



		BEGIN

		                                                 

                                                          

                   

                                                       

                  

                  

                      

           

          

                                                   



		SELECT  RTRIM(ISNULL(A.VMI_YN,'')) + '^' + LTRIM(ISNULL(ATTRIBUTE5,'')) AS VMI_VAL

		FROM SCM_MST_SITE A WITH(NOLOCK)

		WHERE A.DIVISION_ID    = @param1

			AND A.SCM_SITE_ID    = @param2

		;

	END

	else if @Code = 'JV_Plant'



		BEGIN

		                                                 

                           

                                             

                                          

                  

                  

                      

           

          

                                                   





		SELECT md.segment1 as DIVISION_ID, md.segment2 as PLANT_ID, md.DESCRIPTION

		FROM [dbo].[scm_adm_lookup_master_detail] md WITH(NOLOCK)

		WHERE md.lookup_type = 'JV_PLANT'

		  AND md.valid_yn    = 'Y'

		  AND (@Param1 IS NULL OR md.segment1 LIKE '%' + @Param1 + '%')

		  AND (@Param2 = md.segment1 OR md.segment2 LIKE '%' + @Param2 + '%')

		;

	END

	else if @Code = 'CELL_TYPE_81'



		BEGIN

		                                                 

                                   

                                   

                                  

                     

                      

                     

           

                                                      

                                                   



		SELECT

			SEGMENT2 AS CODE,

			SEGMENT3 AS NAME

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)

		WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO'

			AND SEGMENT1 = '81'

		;

	END

	else if @Code = 'CELL_TYPE_82'



		BEGIN

		                                                 

                                   

                                   

                                  

                     

                      

                     

           

                                                      

                                                   



		SELECT

			SEGMENT2 AS CODE,

			SEGMENT3 AS NAME

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)

		WHERE LOOKUP_TYPE = 'CELL_TYPE_INFO'

			AND SEGMENT1 = '82'

		;

	END

	else if @Code = 'PRODUCTION_PROCESS'



		BEGIN

		                                                 

                                           

                                   

                                  

                  

                   

                     

           

                                                                              

                                                   





		SELECT

			SEGMENT1 AS CODE

			, ATTRIBUTE1 AS NAME

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH (NOLOCK)

		WHERE LOOKUP_TYPE = 'DM_PROD_PROCESS'

			AND VALID_YN = 'Y'

		;

	END

	                                                 

                           

         

              

                       

                   

         

                       

                     

                                                  

	ELSE IF @Code = 'DATE_WEEKLY'

	BEGIN



		SELECT A.plan_start_yyyymmdd AS code

 	  		                                                                                                          

 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'

 	  		 		ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END name

  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)

  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd

  		 LEFT JOIN

  		 (

  		 	SELECT DIVISION_ID

		 		, PLAN_START_YYYYMMDD

		 		, FP_TARGET_YN

		 		, MRP_TARGET_YN

		 		, DM_RTF_YN

	  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)

			WHERE 1=1

			                                                                

	   		  AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,','))

  		 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD

		    AND A.DIVISION_ID         = C.DIVISION_ID 

		 WHERE 1=1

		   AND (( @Param1 IS NULL OR  @Param1='' ) OR A.division_id= @Param1 )

  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.version_id = @Param2 )

		 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN

		 ORDER BY A.plan_start_yyyymmdd DESC

		;

	END



	ELSE IF @Code = 'DATE_WEEKLY2'

	BEGIN



		SELECT A.plan_start_yyyymmdd AS code

 	  		                                                                                                          

 	  		 , CASE WHEN FP_TARGET_YN = 'Y' THEN CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')'

 	  		 		ELSE CONVERT(char(10), dbo.FN_CHAR_TO_DATE(A.plan_start_yyyymmdd),121) + ' (' + B.WEEK_NAME + ')' + ' (No Plan)' END name

             , A.DIVISION_ID

  		  FROM SCP_PLAN_VERSION_V A WITH(NOLOCK)

  		 INNER JOIN SCM_SYS_CALENDAR_M B WITH(NOLOCK) ON A.plan_start_yyyymmdd = B.basis_yyyymmdd

  		 LEFT JOIN

  		 (

  		 	SELECT DIVISION_ID

		 		, PLAN_START_YYYYMMDD

		 		, FP_TARGET_YN

		 		, MRP_TARGET_YN

		 		, DM_RTF_YN

	  		 FROM [dbo].[SCP_PLN_INTERFACE_YN] WITH(NOLOCK)

			WHERE 1=1

			                                                                

	   		  AND DIVISION_ID IN (SELECT Value FROM dbo.FN_SplitString(@Param1,','))

  		 ) C ON A.plan_start_yyyymmdd = C.PLAN_START_YYYYMMDD

		    AND A.DIVISION_ID         = C.DIVISION_ID 

		 WHERE 1=1

		   AND (( @Param1 IS NULL OR  @Param1='' ) OR A.division_id= @Param1 )

  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.version_id = @Param2 )

		 GROUP BY A.plan_start_yyyymmdd, B.WEEK_NAME, C.FP_TARGET_YN  ,A.DIVISION_ID

		 ORDER BY A.plan_start_yyyymmdd DESC

		;

	END



	                                                 



                                             

                  

              

                       

                   

         

          

         

                                                  

	ELSE IF @Code = 'DMF0051_BP_Measure'

	BEGIN



		IF (@Param1 = '') BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0051' AND SHEET_NAME = 'Biz Plan Waterfall'

			ORDER BY SORT_ORDER_NO

		END ELSE BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0051' AND SHEET_NAME = 'Biz Plan Waterfall'

				                                                                        

				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

			ORDER BY SORT_ORDER_NO

		END



	END



	ELSE IF @Code = 'DMF0051_1_BP_Measure'

	BEGIN



		IF (@Param1 = '')

		BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0051_1' AND SHEET_NAME = 'Biz Plan Waterfall'

			ORDER BY SORT_ORDER_NO

		END ELSE BEGIN

			SELECT COLUMN_NAME AS CODE, COLUMN_LABEL_NAME AS NAME

			FROM SCM_MST_SHEET_MEASURE WITH(NOLOCK)

			WHERE PROGRAM_ID = 'DMF0051_1' AND SHEET_NAME = 'Biz Plan Waterfall'

				                                                                        

				AND @Param1 IN (SELECT token FROM dbo.String_Split(DIVISION_ID ,',') )

			ORDER BY SORT_ORDER_NO

		END



	END



	                                                 

                          

         

              

                       

                   

         

          

         

                                                  

	ELSE IF @CODE = 'DM_CELL_PROD_SITE'

	BEGIN

		SELECT L.SEGMENT1	AS CODE

			 , L.ATTRIBUTE1	AS NAME

		FROM   [dbo].[SCM_ADM_LOOKUP_MASTER_DETAIL] L WITH(NOLOCK)

		WHERE  1 = 1

		AND    L.LOOKUP_TYPE = 'DM_CELL_PROD_SITE'

		ORDER BY L.DISPLAY_SEQ

	END



	                                                 

                              

         

              

                       

                   

         

         

         

                                                  

	ELSE IF @Code = 'CELL_GROUP'

	BEGIN



		SELECT DISTINCT ISNULL(G.CELL_GROUP, '') AS CODE

		     , ISNULL(G.CELL_GROUP, '') AS NAME

		  FROM SCP_XLS_PSI_GLOBAL_TG G WITH(NOLOCK),

			   SCP_MST_FINAL_ITEM F WITH(NOLOCK)

		 WHERE 0 = 0

		   AND G.OPERATION_GROUP ='A'

		   AND G.DIVISION_ID     = @Param1

		   AND G.DIVISION_ID     = F.DIVISION_ID

		   AND G.CELL_ITEM_ID    = F.ITEM_ID

		   AND ISNULL(G.CELL_GROUP, '') <> ''

		 ORDER BY ISNULL(G.CELL_GROUP, '') DESC

		;

	END



	                                                 

                 

                             

                             

                       

                   

         

         

         

                                                  

	ELSE IF @Code = 'SEQ_NUMBER'

	BEGIN



		WITH SEQ AS

		     (

		        SELECT 1 AS NUM

		         UNION ALL

		        SELECT NUM + 1

		          FROM SEQ

		         WHERE NUM < @Param1 )

	  SELECT NUM AS CODE

	       , NUM AS NAME

	    FROM SEQ

		;

	END



	                                                 

                       

                          

           

                       

                   

         

          

         

                                                  

	ELSE IF @Code = 'DIVISION_EE'

		BEGIN

			SELECT DIVISION_ID AS CODE

			     , DIVISION_ID AS NAME

			  FROM [dbo].[SCM_MST_DIVISION] WITH(NOLOCK)

			 WHERE DIVISION_ID IN ('EE', 'EE_UC')

			 GROUP BY DIVISION_ID

			 ORDER BY DIVISION_ID

		END



	                                                 

                   

                          

           

                       

                    

         

          

         

                                                  

	ELSE IF @Code = 'COMPANY_EE'

		BEGIN

			SELECT A.COMPANY_NAME CODE

				 , A.COMPANY_ID NAME

			FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)

	    END



	                                                 

               

                                

           

                       

                    

         

          

         

                                                  

	ELSE IF @Code = 'ALL_Y_TYPE'

		BEGIN

			SELECT SEGMENT2 AS CODE

			     , SEGMENT1 AS NAME

			  FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

			 WHERE 1=1

			   AND LOOKUP_TYPE = 'ALL_Y_TYPE'

			   AND SEGMENT1 <> 'ALL'

	    END



	                                                 

                          

                                

           

                       

                    

         

          

         

                                                  

	ELSE IF @Code = 'FINISHED_YN'

		BEGIN

			SELECT 1 AS CODE

			     , 'Y' AS NAME

			UNION

			SELECT 2 AS CODE

				, 'N' AS NAME

			UNION

			SELECT '3' AS CODE

				, 'Both' AS NAME

	    END



                                                  

                

                                

        

                       

                    

         

          

         

                                                  

 ELSE IF @Code = 'ALL_V_TYPE'

  BEGIN

   SELECT SEGMENT2 AS CODE

		   , SEGMENT1 AS NAME

		FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

    WHERE 1=1

		 AND LOOKUP_TYPE = 'ALL_V_TYPE'

		 AND SEGMENT1 <> 'ALL'

		END



                                                 

                   

                                

        

                       

                 

         

          

         

                                                  

ELSE IF @Code = 'ESS_CATEGORY'

BEGIN

    SELECT    SEGMENT1 AS CODE

            , SEGMENT1 AS NAME

    FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

    WHERE   1=1

        AND LOOKUP_TYPE = 'ESS_CATEGORY'

END



                                                 

                                            

                                

        

                       

                 

         

          

         

                                                  

ELSE IF @Code = 'GLOBAL_PSI_ELEC_DATE'

BEGIN

    SELECT    A.PLAN_START_YYYYMMDD                                                                     AS CODE

            , CONVERT(VARCHAR, CONVERT(DATE, A.PLAN_START_YYYYMMDD), 121) + ' (' + B.WEEK_NAME + ')'    AS NAME

    FROM    (

                SELECT DISTINCT

                        PLAN_START_YYYYMMDD

                FROM    SCP_RPT_ELEC_PSI A

                WHERE   1=1

                    AND ((@Param1 IS NULL OR  @Param1 = '') OR A.division_id= @Param1)

            ) A

            INNER JOIN

            (

                SELECT DISTINCT

                          BASIS_YYYYMMDD

                        , WEEK_NAME

                FROM    SCM_SYS_CALENDAR_M WITH(NOLOCK)

            ) B ON A.PLAN_START_YYYYMMDD = B.BASIS_YYYYMMDD

    GROUP BY A.PLAN_START_YYYYMMDD, B.WEEK_NAME

    ORDER BY A.PLAN_START_YYYYMMDD DESC

END



	                                                 

                                                  

                  

              

                       

                  

         

          

         

                                                  

	ELSE IF @Code = 'PROJECT_MODEL_MAPPING'

	BEGIN

		SELECT  SEGMENT1 AS CODE

			,	SEGMENT1 AS NAME

		FROM    SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK)

		WHERE   1=1

			AND LOOKUP_TYPE = 'PROJECT_MODEL_MAPPING'

		ORDER BY DISPLAY_SEQ

	END



	                                                 

                                                                    

                  

              

                       

                 

         

          

         

                                                                          

                                                  

	ELSE IF @Code = 'CELL_PROD_SITE_ID'

	BEGIN

	  	                                                                                     

		                                                                   

		                                

		                              

		

		IF @PARAM1 IS NULL OR LEN(@PARAM1) = 0 OR @PARAM1 = '' 	                                         

		BEGIN

				                               

				                                                  

				                                       

				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 

				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'

				                                    

				UNION ALL

				                                   

				SELECT DISTINCT

					   S.SCM_SITE_ID  AS CODE

					 , M.ATTRIBUTE1    AS NAME

				FROM   SCM_MST_SITE S WITH(NOLOCK)

				INNER JOIN (

							SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP 

							                                                                                      

							FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)

							WHERE  1=1

							AND    I.ACTIVE_FLAG = 'Y'

							AND    I.ITEM_TYPE IS NOT NULL 

							                                

							                                                                                          

							AND    I.FORECAST_INFO_BIZ_TYPE = 'CELL'

							) SS

				ON  S.DIVISION_ID = SS.DIVISION_ID

				AND S.OPERATION_GROUP = SS.SCP_OPERATION_GROUP

				AND S.COMPANY_ID = SS.COMPANY_ID 

				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)

				ON  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'

				AND S.SCM_SITE_ID = M.SEGMENT1

				AND M.VALID_YN  = 'Y'

				WHERE  1 = 1

				AND    S.SITE_TYPE = 'PLANT'

				AND    S.OPERATION_GROUP = 'A'

				AND    S.OSP_YN = 'N' 

				                                 

		END

		ELSE	                                                            

		BEGIN

			DECLARE @BIZ_TYPE NVARCHAR(100) = '';



			IF (SELECT COUNT(1) 

				FROM [SCM_ITEM_M_SN] T1 WITH (NOLOCK) 

				WHERE DIVISION_ID = @PARAM1 

				AND ACTIVE_FLAG = 'Y'	

				AND ITEM_ID = @PARAM2 

				AND FORECAST_INFO_BIZ_TYPE = 'CELL') > 0                                            

			BEGIN

				SET @BIZ_TYPE = 'CELL'	

			END



			IF @BIZ_TYPE <> 'CELL'

			BEGIN

				                               

				                                                  

				                                       

				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 

				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'	                                                 

				                                    

			END

			ELSE

			BEGIN

				                                                         

				                                                  

				                                       

				SELECT SEGMENT1 AS CODE, ATTRIBUTE1 AS [NAME]

				FROM SCM_ADM_LOOKUP_MASTER_DETAIL WITH(NOLOCK) 

				WHERE LOOKUP_TYPE = 'SP_CELL_PROD_SITE' AND SEGMENT1 = '-' AND VALID_YN  = 'Y'	                                             

				AND @BIZ_TYPE <> 'CELL'															                                          

				                                                                                                    

				UNION ALL

				SELECT DISTINCT																	

					   S.SCM_SITE_ID  AS CODE

					 , M.ATTRIBUTE1    AS NAME

				FROM   SCM_MST_SITE S WITH(NOLOCK)

				INNER JOIN (

							SELECT DISTINCT I.DIVISION_ID, I.COMPANY_ID, I.SCP_OPERATION_GROUP 

							                                                                                      

							FROM   SCM_MST_ITEM_SN I WITH(NOLOCK)

							WHERE  1=1

							AND    I.ACTIVE_FLAG = 'Y'

							AND    I.ITEM_TYPE IS NOT NULL 

							AND    I.DIVISION_ID = @PARAM1

							AND    I.ITEM_ID = CASE WHEN TRIM(@PARAM2) IN( '','ALL') THEN I.ITEM_ID ELSE @PARAM2 END                                   

							AND    I.FORECAST_INFO_BIZ_TYPE = 'CELL'

							) SS

				ON  S.DIVISION_ID = SS.DIVISION_ID

				AND S.OPERATION_GROUP = SS.SCP_OPERATION_GROUP

				AND S.COMPANY_ID = SS.COMPANY_ID 

				INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL M WITH(NOLOCK)

				ON  M.LOOKUP_TYPE = 'SP_CELL_PROD_SITE'

				AND S.SCM_SITE_ID = M.SEGMENT1

				AND M.VALID_YN  = 'Y'

				WHERE  1 = 1

				AND    S.SITE_TYPE = 'PLANT'

				AND    S.OPERATION_GROUP = 'A'

				AND    S.OSP_YN = 'N' 

			END

		END

	END



	                                                                                                

                                                                                   

                 

                                                       

                    

                 

         

          

         

                                                                                                 

	ELSE IF @Code = 'PlantByDivisionCompany'

	BEGIN

		SELECT A.PLANT_ID      AS CODE

			 , A.PLANT_ID      AS NAME

		  FROM SCM_MST_PLANT_SN A WITH(NOLOCK)

		 WHERE (( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID = @Param1 ) 

  		   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.COMPANY_ID = @Param2 )

	END

	

	                                                                                                

                                                                                      

                 

                                                        

                    

                 

         

          

         

                                                                                                 

	ELSE IF @Code = 'CompanySalesSite'

	BEGIN	

		IF @PARAM2 IS NULL OR LEN(@PARAM2) = 0 OR @PARAM2 = '' 	                                         

		BEGIN

			SELECT A.COMPANY_ID AS CODE

				 , A.COMPANY_ID AS NAME  

			  FROM SCM_MST_COMPANY_SN A WITH(NOLOCK)

		END

		ELSE	                                           

		BEGIN

			SELECT A.COMPANY_ID AS CODE

				 , A.COMPANY_ID AS NAME  

			  FROM SCM_MST_SITE A WITH(NOLOCK)

			 WHERE (( @Param1 IS NULL OR  @Param1='' ) OR A.DIVISION_ID = @Param1 ) 

			   AND (( @Param2 IS NULL OR  @Param2='' ) OR A.SCM_SITE_ID = @Param2 )

		END

	END	

	                                                                                                                 

                                                     

                          

            

                    

                 

         

          

         

                                                                                                                     

	ELSE IF @CODE = 'incotermsEdit'

	BEGIN		

		SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

		WHERE LOOKUP_TYPE = 'INCOTERMS'

		AND   VALID_YN = 'Y'

		AND   ATTRIBUTE2 = 'Y'

		ORDER BY DISPLAY_SEQ

	END

	                                                                                                                 

                                                           

                 

                                 

                    

                 

         

          

         

                                                                                                                     

	ELSE IF @CODE = 'AS_FROM_SITE'

	BEGIN		

		IF @PARAM1 IS NULL OR LEN(@PARAM1) = 0 OR @PARAM1 = '' 	                                         

		BEGIN

			SELECT SEGMENT2 AS CODE, SEGMENT1 AS NAME 

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

			WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'

			AND VALID_YN = 'Y'

			ORDER BY DISPLAY_SEQ

		END

		ELSE

		BEGIN

			SELECT SEGMENT2 AS CODE, SEGMENT1 AS NAME 

			FROM SCM_ADM_LOOKUP_MASTER_DETAIL  WITH(NOLOCK)

			WHERE LOOKUP_TYPE = 'AS_SITE_PLANT'

			AND VALID_YN = 'Y'

			AND SEGMENT3 = @PARAM1

			ORDER BY DISPLAY_SEQ

		END

	END

END


