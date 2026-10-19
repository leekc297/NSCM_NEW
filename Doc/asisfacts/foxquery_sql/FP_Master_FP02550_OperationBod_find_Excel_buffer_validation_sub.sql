SELECT A.*
						    ,CASE WHEN __MSG = ' Not Found' THEN '' ELSE __MSG END AS _MSG
						    ,CASE WHEN __MSG = ' Not Found' THEN 'Y' ELSE 'N' END AS _VALID
						FROM (
								SELECT A.*
								      ,MSG1
								      +(CASE WHEN (MSG1 = '')                                                         THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
								      +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                           THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
								      +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                             THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
								      +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')               THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
								      +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '') THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
								      + ' Not Found' AS __MSG
								FROM (
										  SELECT A.*, ISNULL(B.NICK_NAME,'-') AS NICK_NAME
										        ,case when B.ITEM_ID is null then 'Material' else '' end as msg1
										        ,case when C.FACTORY_ID is null then 'Factory' else '' end as msg2
										        ,case when D.OPERATION_ID is null then 'Operation' else '' end as msg3
										        ,CASE WHEN E.CODE_ID IS NULL THEN 'Model Type' ELSE '' END AS MSG4
										        ,CASE WHEN F.CODE_ID IS NULL THEN 'Line Attribute' ELSE '' END AS MSG5
										        ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG6
										  FROM   BUF_ITEM_FLOW_EXCEPT_M A WITH(NOLOCK)
										  LEFT OUTER JOIN (
										      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME
										      FROM   SCM_ITEM_M A WITH(NOLOCK), SCM_ITEM_CLASS_M IC WITH(NOLOCK)
										      WHERE  A.ITEM_CLASS=IC.CLASS_ID
										      AND    IC.USE_FLAG='Y'
										      AND    A.ACTIVE_FLAG='Y'
										  ) B
										  ON  A.COMPANY_ID  = B.COMPANY_ID
										  AND A.DIVISION_ID = B.DIVISION_ID
										  AND A.SITE_ID     = B.SITE_ID
										  AND A.ITEM_ID     = B.ITEM_ID
										  LEFT OUTER JOIN (
										    SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
										    FROM   SCM_FACTORY_M CCC(NOLOCK)
										    WHERE  ACTIVE_FLAG='Y'
										  )C
										  ON  A.COMPANY_ID  = C.COMPANY_ID
										  AND A.DIVISION_ID = C.DIVISION_ID
										  AND A.SITE_ID     = C.SITE_ID
										  AND A.PLANT_ID    = C.PLANT_ID
										  AND A.FACTORY_ID  = C.FACTORY_ID
										  LEFT OUTER JOIN (
										    SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
										    FROM   SCM_OPERATION_M DDD(NOLOCK)
										    WHERE  ACTIVE_FLAG='Y'
										  ) D
										  ON  A.COMPANY_ID   = D.COMPANY_ID
										  AND A.DIVISION_ID  = D.DIVISION_ID
										  AND A.SITE_ID      = D.SITE_ID
										  AND A.OPERATION_ID = D.OPERATION_ID
										  LEFT OUTER JOIN (
										      SELECT A.SEGMENT1 AS SITE_ID
										           , A.SEGMENT2 AS DIVISION_ID
										           , A.SEGMENT3 AS PLANT_ID
										           , A.SEGMENT4 AS FACTORY_ID
										           , A.SEGMENT5 AS CODE_ID
										      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
										      WHERE  A.LOOKUP_TYPE_CODE = 'LINE_MODEL_TYPE'
										      AND    A.ACTIVE_FLAG      = 'Y'
										  ) E
										  ON  A.DIVISION_ID = E.DIVISION_ID
										  AND A.SITE_ID     = E.SITE_ID
										  AND A.PLANT_ID    = E.PLANT_ID
										  AND A.FACTORY_ID  = E.FACTORY_ID
										  AND A.MODEL_TYPE  = E.CODE_ID
										  LEFT OUTER JOIN (
										      SELECT A.SEGMENT1 AS SITE_ID
										           , A.SEGMENT2 AS DIVISION_ID
										           , A.SEGMENT3 AS PLANT_ID
										           , A.SEGMENT4 AS FACTORY_ID
										           , A.SEGMENT5 AS CODE_ID
										      FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
										      WHERE  A.LOOKUP_TYPE_CODE = 'LINE_ATTRIBUTE'
										      AND    A.ACTIVE_FLAG      = 'Y'
										  ) F
										  ON  A.DIVISION_ID = F.DIVISION_ID
										  AND A.SITE_ID     = F.SITE_ID
										  AND A.PLANT_ID    = F.PLANT_ID
										  AND A.FACTORY_ID  = F.FACTORY_ID
										  AND A.LINE_ATTR_1 = F.CODE_ID
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