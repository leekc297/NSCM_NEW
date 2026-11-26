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
          SELECT A.COMPANY_ID
		        ,A.DIVISION_ID
		        ,A.SITE_ID
		        ,A.PLANT_ID
		        ,A.FACTORY_ID
		        ,A.LINE_ID
		        ,A.ITEM_ID
		        ,A.OPERATION_ID
		        ,A.SHORTER_LT
            ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE
            ,CASE WHEN B.FACTORY_ID IS NULL THEN 'Factory' ELSE '' END AS MSG1
            ,CASE WHEN C.ITEM_ID IS NULL THEN 'Material' ELSE '' END AS MSG2
            ,CASE WHEN  ( AFTER_DEGAS_LT_DAY * (-1) ) > A.SHORTER_LT THEN 'Shorter L/T' ELSE '' END AS MSG3
            ,CASE WHEN E.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG4
            ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG5
            ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.LINE_ID,A.ITEM_ID
    		                                 ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.LINE_ID,A.ITEM_ID)>1 THEN 'Data Overlap'
    		      ELSE '' END AS MSG99
          FROM   BUF_FORMATION_SHORTER_LT_M A(NOLOCK)
          LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)
          ON  A.COMPANY_ID   = B.COMPANY_ID
          AND A.DIVISION_ID  = B.DIVISION_ID
          AND A.SITE_ID      = B.SITE_ID
          AND A.PLANT_ID     = B.PLANT_ID
          AND A.FACTORY_ID   = B.FACTORY_ID
          AND B.ACTIVE_FLAG = 'Y'
          LEFT OUTER JOIN (
              SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,A.ITEM_ID,
                     (CASE WHEN LEFT(A.FLOW_ID,5) = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN C.LEVEL_3_NAME
                     	     WHEN LEFT(A.FLOW_ID,5) = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
                     	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,
                     ISNULL(A.NICK_NAME,'-') AS NICK_NAME
              FROM	 SCM_ITEM_M A WITH(NOLOCK),
                		 SCM_ITEM_CLASS_M C WITH(NOLOCK)
              WHERE	 A.ITEM_CLASS  = C.CLASS_ID
          ) C
          ON  A.COMPANY_ID      = C.COMPANY_ID
          AND A.DIVISION_ID     = C.DIVISION_ID
          AND A.SITE_ID         = C.SITE_ID
          AND A.ITEM_ID         = C.ITEM_ID
    		  LEFT OUTER JOIN (
    		  		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.SHORTER_OPERATION_ID, A.LINE_ID, A.ITEM_ID, ROUND(ISNULL(A.AFTER_DEGAS_LT,0)/60/24,2) AS AFTER_DEGAS_LT_DAY
    		  		FROM 	 FP_FORMATION_LT_V A WITH(NOLOCK)
              WHERE  SHORTER_OPERATION_ID IS NOT NULL
    		  ) D
    		  ON  A.COMPANY_ID      = D.COMPANY_ID
          AND A.DIVISION_ID     = D.DIVISION_ID
          AND A.SITE_ID         = D.SITE_ID
          AND A.PLANT_ID        = D.PLANT_ID
          AND A.FACTORY_ID      = D.FACTORY_ID
          AND A.LINE_ID	        = D.LINE_ID
          AND A.ITEM_ID         = D.ITEM_ID
          AND A.OPERATION_ID    = D.SHORTER_OPERATION_ID
          LEFT OUTER JOIN SCM_OPERATION_M E WITH(NOLOCK)
          ON  A.COMPANY_ID      = E.COMPANY_ID
          AND A.DIVISION_ID     = E.DIVISION_ID
          AND A.SITE_ID         = E.SITE_ID
          AND A.OPERATION_ID    = E.OPERATION_ID
          AND E.ACTIVE_FLAG     = 'Y'
          LEFT OUTER JOIN (
               SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
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
          AND  A.LINE_ID      = R.LINE_ID
          WHERE A.JOB_USER_ID = @USER_ID
        ) A
      ) A