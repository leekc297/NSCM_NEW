SELECT A.*
		        	FROM (
			        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID='-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE
			                	 , RELEASE_PLAN_ID, INSERT_TIME
			                	 , ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID='-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)
			                						 ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM
			        		FROM   FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK)
			        		WHERE	1=1
			        		AND   	A.INSTANCE_ID IN (
										        		SELECT A.SEGMENT2 AS ASSY_ID
										        		FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
										        		WHERE  A.LOOKUP_TYPE_CODE = 'ELEC_ASSY_INSTANCE_MAP'
										        		AND    A.SEGMENT1 = @INSTANCE_ID
										          	 ) 
							AND		A.INSERT_TIME > ( 
														SELECT  DISTINCT A.INSERT_TIME
														FROM SCM_FP_PLAN_H A WITH(NOLOCK)
														WHERE  1=1
														AND A.INSTANCE_ID = @INSTANCE_ID
														AND A.PLAN_ID =  @PLAN_ID
														AND CONVERT(VARCHAR,A.INSERT_TIME,112)	= 	
																									( 
																										SELECT CASE WHEN FORMAT(dbo.FN_SITE_TIME(B.SITE_ID) ,'yyyyMMddHHmmss') < CONVERT(VARCHAR,dbo.FN_SITE_TIME(B.SITE_ID),112) + A.BASIS_START_TIME 
																								        				  THEN CONVERT(VARCHAR, DATEADD(DD,-1,dbo.FN_SITE_TIME(B.SITE_ID)), 112)
																								        				  ELSE CONVERT(VARCHAR, dbo.FN_SITE_TIME(B.SITE_ID), 112) END AS CURR_DATE
																								          FROM   FP_INSTANCE_START_TIME_V A, (
																								          		SELECT MAX(B.SITE_ID) AS SITE_ID
																								          		FROM   FP_INSTANCE_FACTORY_M A WITH(NOLOCK), SCM_FACTORY_M B WITH(NOLOCK)
																								          		WHERE  A.FACTORY_ID = B.FACTORY_ID
																								          		AND    A.ACTIVE_FLAG = 'Y'
																								          		AND    B.ACTIVE_FLAG = 'Y'
																								          		AND    A.INSTANCE_ID = @INSTANCE_ID
																								      	  ) B
																								          WHERE  A.INSTANCE_ID = @INSTANCE_ID
																									)
													 )
		        	) A
		        	WHERE A.ROW_NUM = 1