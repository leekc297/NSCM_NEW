SELECT A.*
			            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
			                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
			                  END AS _MSG
			            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
			      FROM (
			        SELECT A.* 
			              ,MSG1
			              +(CASE WHEN (MSG1 = '')                                           THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
			              +(CASE WHEN (MSG1 = '' AND MSG2 = '')                             THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
			              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')               THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
			              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '') THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
			              + ' Not Found' AS __MSG
			        FROM (
			          SELECT A.*
			                ,CASE WHEN B.ITEM_ID IS NULL THEN 'Material' ELSE '' END AS MSG1
			                ,CASE WHEN C.FACTORY_ID IS NULL THEN 'Building' ELSE '' END AS MSG2
			                ,CASE WHEN (ISNULL(A.MAIN_LANE_QTY,0) + ISNULL(A.SUB_LANE_QTY,0)) = 0 THEN '<Main and Sub Slitting is not zero>' ELSE '' END AS MSG3
			                ,CASE WHEN A.FACTORY_ID = 'E7' AND D.PROD_VERSION_TYPE IS NULL THEN 'Wide Range' ELSE '' END AS MSG4
			                ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG5
			        				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY,A.PROD_VERSION_TYPE
			        				                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.ITEM_ID,A.LANE_QTY)>1 THEN 'Data Overlap'
			        				      ELSE '' END AS MSG99
			          FROM   BUF_ITEM_LANE_M A WITH(NOLOCK)
			          LEFT OUTER JOIN (
			              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
			              FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M IC WITH(NOLOCK)
			              WHERE  A.ITEM_CLASS=IC.CLASS_ID
			              AND    IC.USE_FLAG='Y'
			              AND    A.ACTIVE_FLAG='Y'
			          ) B
			          ON  A.COMPANY_ID  = B.COMPANY_ID
			          AND A.DIVISION_ID = B.DIVISION_ID
			          AND A.SITE_ID     = B.SITE_ID
			          AND A.ITEM_ID     = B.ITEM_ID
			          LEFT OUTER JOIN SCM_FACTORY_M C WITH(NOLOCK)
			          ON  A.COMPANY_ID  = C.COMPANY_ID
			          AND A.DIVISION_ID = C.DIVISION_ID
			          AND A.SITE_ID     = C.SITE_ID
			          AND A.PLANT_ID    = C.PLANT_ID
			          AND A.FACTORY_ID  = C.FACTORY_ID
			          AND C.ACTIVE_FLAG = 'Y'
			          LEFT OUTER JOIN (
				          SELECT DISTINCT A.SEGMENT2 AS DIVISION_ID, A.SEGMENT1 AS SITE_ID, A.SEGMENT3 AS PLANT_ID, A.SEGMENT4 AS FACTORY_ID, A.ATTRIBUTE1 AS PROD_VERSION_TYPE
				          FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
				          WHERE  A.LOOKUP_TYPE_CODE = 'LINE_PROD_VERSION_TYPE'
				          AND    A.ACTIVE_FLAG = 'Y'
			  	      ) D
			  	      ON  A.DIVISION_ID = D.DIVISION_ID
			  	      AND A.SITE_ID 	= D.SITE_ID
			  	      AND A.PLANT_ID 	= D.PLANT_ID
			  	      AND A.FACTORY_ID 	= D.FACTORY_ID
			  	      AND A.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE
			          LEFT OUTER JOIN (
			               SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID
			               FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
			               WHERE  R.USER_ID   = @USER_ID
			               AND    R.SAVE_FLAG = 'Y'
			          ) R
			          ON   A.COMPANY_ID   = R.COMPANY_ID
			          AND  A.DIVISION_ID  = R.DIVISION_ID
			          AND  A.SITE_ID      = R.SITE_ID
			          AND  A.PLANT_ID     = R.PLANT_ID
			          AND  A.FACTORY_ID   = R.FACTORY_ID
			          WHERE A.JOB_USER_ID = @USER_ID
			        ) A
			      ) A
			      ORDER BY A.JOB_ORDER