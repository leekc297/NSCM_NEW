SELECT A.*
					            ,CASE WHEN __MSG = ' Not Found' THEN '' ELSE __MSG END AS _MSG
					            ,CASE WHEN __MSG = ' Not Found' THEN 'Y' ELSE 'N' END AS _VALID
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
					                ,CASE WHEN B.FACTORY_ID IS NULL THEN 'Factory' ELSE '' END AS MSG1
					                ,CASE WHEN C.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG2
					                ,CASE WHEN D.CODE_ID IS NULL THEN 'Model Type' ELSE '' END AS MSG3
					                ,CASE WHEN E.CODE_ID IS NULL THEN 'Line Attribute' ELSE '' END AS MSG4
					                ,(CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END) AS MSG5
					          FROM   BUF_OPERATION_MOVE_M A(NOLOCK)
					          LEFT OUTER JOIN (
					            SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
					            FROM   SCM_FACTORY_M BBB(NOLOCK)
					            WHERE  ACTIVE_FLAG='Y'
					          ) B
					          ON  A.COMPANY_ID  = B.COMPANY_ID
					          AND A.DIVISION_ID = B.DIVISION_ID
					          AND A.SITE_ID     = B.SITE_ID
					          AND A.PLANT_ID    = B.PLANT_ID
					          AND A.FACTORY_ID  = B.FACTORY_ID
					          LEFT OUTER JOIN (
					            SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
					            FROM   SCM_OPERATION_M CCC(NOLOCK)
					            WHERE  ACTIVE_FLAG='Y'
					          ) C
					          ON  A.COMPANY_ID   = C.COMPANY_ID
					          AND A.DIVISION_ID  = C.DIVISION_ID
					          AND A.SITE_ID      = C.SITE_ID
					          AND A.OPERATION_ID = C.OPERATION_ID
					          LEFT OUTER JOIN (
					              SELECT A.SEGMENT1 AS SITE_ID
					                   , A.SEGMENT2 AS DIVISION_ID
					                   , A.SEGMENT3 AS PLANT_ID
					                   , A.SEGMENT4 AS FACTORY_ID
					                   , A.SEGMENT5 AS CODE_ID
					              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
					              WHERE  A.LOOKUP_TYPE_CODE = 'LINE_MODEL_TYPE'
					              AND    A.ACTIVE_FLAG      = 'Y'
					          ) D
					          ON  A.DIVISION_ID = D.DIVISION_ID
					          AND A.SITE_ID     = D.SITE_ID
					          AND A.PLANT_ID    = D.PLANT_ID
					          AND A.FACTORY_ID  = D.FACTORY_ID
					          AND A.MODEL_TYPE  = D.CODE_ID
					          LEFT OUTER JOIN (
					              SELECT A.SEGMENT1 AS SITE_ID
					                   , A.SEGMENT2 AS DIVISION_ID
					                   , A.SEGMENT3 AS PLANT_ID
					                   , A.SEGMENT4 AS FACTORY_ID
					                   , A.SEGMENT5 AS CODE_ID
					              FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
					              WHERE  A.LOOKUP_TYPE_CODE = 'LINE_ATTRIBUTE'
					              AND    A.ACTIVE_FLAG      = 'Y'
					          ) E
					          ON  A.DIVISION_ID = E.DIVISION_ID
					          AND A.SITE_ID     = E.SITE_ID
					          AND A.PLANT_ID    = E.PLANT_ID
					          AND A.FACTORY_ID  = E.FACTORY_ID
					          AND A.LINE_ATTR_1 = E.CODE_ID
					          LEFT OUTER JOIN (
					               SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID
					               FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
					               WHERE  R.USER_ID   = @USER_ID
					               AND    R.SAVE_FLAG = 'Y'
					          ) R
					          ON   A.COMPANY_ID   = R.COMPANY_ID
					          AND  A.DIVISION_ID  = R.DIVISION_ID
					          AND  A.SITE_ID      = R.SITE_ID
					          AND  A.PLANT_ID     = R.PLANT_ID
					          AND  A.FACTORY_ID   = R.FACTORY_ID
					          AND  A.OPERATION_ID = R.OPERATION_ID
					          WHERE A.JOB_USER_ID = @USER_ID
					        ) A
					      ) A
					      ORDER BY A.JOB_ORDER