SELECT 	A.*
			            ,CASE WHEN __MSG = ' Not Found' THEN '' ELSE __MSG END AS _MSG
			            ,CASE WHEN __MSG = ' Not Found' THEN 'Y' ELSE 'N' END AS _VALID
			    FROM	(
					        SELECT A.* 
					              ,MSG1
					              +(CASE WHEN (MSG1 = '')                             THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
					              +(CASE WHEN (MSG1 = '' AND MSG2 = '')               THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
					              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '') THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
					              + ' Not Found' AS __MSG
					        FROM (
							          SELECT A.*
							                ,CASE WHEN B.PLANT_ID IS NULL THEN 'From Site-Plant' ELSE '' END AS MSG1
							                ,CASE WHEN C.PLANT_ID IS NULL THEN 'To Site-Plant' ELSE '' END AS MSG2
							                ,CASE WHEN R.PLANT_ID IS NULL THEN 'Permissions(From)' ELSE '' END AS MSG3
							                ,CASE WHEN R2.PLANT_ID IS NULL THEN 'Permissions(To)' ELSE '' END AS MSG4
							          FROM   BUF_SHIPMENT_M A WITH(NOLOCK)
									          LEFT OUTER JOIN (
									              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
									              FROM   SCM_PLANT_M A WITH(NOLOCK)
									          ) B
									          ON  A.COMPANY_ID  = B.COMPANY_ID
									          AND A.DIVISION_ID = B.DIVISION_ID
									          AND A.SITE_ID     = B.SITE_ID
									          AND A.PLANT_ID    = B.PLANT_ID
									          LEFT OUTER JOIN (
									              SELECT DISTINCT A.SITE_ID, A.PLANT_ID
									              FROM   SCM_PLANT_M A WITH(NOLOCK)
									          ) C
									          ON  A.TO_SITE_ID  = C.SITE_ID
									          AND A.TO_PLANT_ID = C.PLANT_ID
									          LEFT OUTER JOIN (
									               SELECT DISTINCT R.SITE_ID, R.PLANT_ID
									               FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
									               WHERE  R.USER_ID   = @USER_ID
									               AND    R.SAVE_FLAG = 'Y'
									          ) R
									          ON   A.SITE_ID      = R.SITE_ID
									          AND  A.PLANT_ID     = R.PLANT_ID
									          LEFT OUTER JOIN (
									               SELECT DISTINCT R.SITE_ID, R.PLANT_ID
									               FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
									               WHERE  R.USER_ID   = @USER_ID
									               AND    R.SAVE_FLAG = 'Y'
									          ) R2
									          ON   A.TO_SITE_ID   = R2.SITE_ID
									          AND  A.TO_PLANT_ID  = R2.PLANT_ID
							          WHERE A.JOB_USER_ID = @USER_ID
								) A
			      		) A
				ORDER BY A.JOB_ORDER