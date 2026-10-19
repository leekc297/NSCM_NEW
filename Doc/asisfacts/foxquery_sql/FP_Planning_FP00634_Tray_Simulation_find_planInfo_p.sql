WITH FORM_PLAN AS (
						        	SELECT 'FORM_PLAN' AS PLAN_TYPE, A.*
						        	FROM (
							        		SELECT A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID='-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END) AS RELEASE_VALUE
							                		, RELEASE_PLAN_ID, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, B.INSERT_ID
							                		, ROW_NUMBER() OVER(PARTITION BY A.INSTANCE_ID, (CASE WHEN A.FACTORY_ID='-' THEN A.PLAN_GROUP_ID ELSE A.FACTORY_ID END)
							                						ORDER BY     A.INSERT_TIME DESC ) AS ROW_NUM
							        		FROM   	FP_RELEASE_PLAN_INFO_H A WITH(NOLOCK) ,
							        			   	SCM_FP_PLAN_H B WITH(NOLOCK) 
							        		WHERE  	1=1
							        		AND 	A.INSTANCE_ID = B.INSTANCE_ID
											AND		A.RELEASE_PLAN_ID = B.PLAN_ID
							        		AND	   	A.INSTANCE_DATE <= @PLAN_DATE
						        		) A
						        	WHERE A.ROW_NUM = 1
						        	AND   A.INSTANCE_ID = @INSTANCE_ID
						        	@CTRL_AND
						        	--{
						        	--  var sql = "";
						        	--  var rel = $data.RELEASE_FLAG;
						        	  
						        	--  if(rel == "Y")  sql = "      	AND   1=1\r\n";
						        	--  else            sql = "      	AND   1=0\r\n";
						        	  
						        	--  sql;
						        	--}
						          	UNION ALL
									SELECT  'FORM_PLAN' AS PLAN_TYPE, A.INSTANCE_ID, '-' AS RELEASE_VALUE, A.PLAN_ID AS RELEASE_PLAN_ID
											, CONVERT(CHAR(19), A.INSERT_TIME, 20) AS INSERT_TIME, A.INSERT_ID, 1 AS ROW_NM
									FROM SCM_FP_PLAN_H A WITH(NOLOCK)
									@CTRL_WHERE
									--{
								--		var sql = "";
							--			var rel = $data.RELEASE_FLAG;
										
								--		if(rel == "Y")  sql = "        WHERE  1=0\r\n";
								--		else            sql = "        WHERE  1=1\r\n";
										
							--			sql;
						  --      	}
									AND A.INSTANCE_ID = @INSTANCE_ID
									AND A.PLAN_ID =  @PLAN_ID
						        	
						)
				SELECT *
				FROM	FORM_PLAN