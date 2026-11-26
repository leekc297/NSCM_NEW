SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
        SELECT A.* 
              ,MSG1
              +(CASE WHEN (MSG1 = '')               THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '') THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
              + ' Not Found' AS __MSG
        FROM (
          SELECT A.*
                ,CASE WHEN C.DIVISION_ID IS NULL THEN 'Division' ELSE '' END AS MSG1
                ,CASE WHEN B.SITE_ID IS NULL THEN 'Site' ELSE '' END AS MSG2
                ,CASE WHEN D.SITE_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG3
        				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.ITEM_ID
        				                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.ITEM_ID)>1 THEN 'Data Overlap'
        				      ELSE '' END AS MSG99
          FROM   BUF_ITEM_M A WITH(NOLOCK)
          LEFT OUTER JOIN SCM_SITE_M B WITH(NOLOCK)
          ON    A.COMPANY_ID  = B.COMPANY_ID
          AND   A.SITE_ID     = B.SITE_ID
          LEFT OUTER JOIN SCM_DIVISION_M C WITH(NOLOCK)
          ON    A.COMPANY_ID  = C.COMPANY_ID
          AND   A.DIVISION_ID = C.DIVISION_ID
    		  LEFT OUTER JOIN (
      				SELECT DISTINCT D.COMPANY_ID, D.DIVISION_ID, D.SITE_ID
      				FROM   FP_USER_ROLE_INFO_V D WITH(NOLOCK)
      				WHERE  D.USER_ID   = @USER_ID
      				AND    D.SAVE_FLAG = 'Y'
    		  ) D
          ON    A.COMPANY_ID  = D.COMPANY_ID
          AND   A.DIVISION_ID = D.DIVISION_ID
          AND   A.SITE_ID     = D.SITE_ID
          WHERE A.JOB_USER_ID = @USER_ID
        ) A
      ) A
      ORDER BY A.JOB_ORDER