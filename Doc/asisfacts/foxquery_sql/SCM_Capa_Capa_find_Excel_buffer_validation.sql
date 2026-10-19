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
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '') THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
              + ' Not Found' AS __MSG
        FROM (
          SELECT A.*
                ,case when B.FACTORY_ID is null then 'Factory' else '' end as msg1
                ,case when C.OPERATION_ID is null then 'Operation' else '' end as msg2
                ,case when D.LINE_ID is null then 'Line' else '' end as msg3
                ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG4
        				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.EQUIPMENT_ID,A.OPERATION_ID
        				                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.EQUIPMENT_ID,A.OPERATION_ID)>1 THEN 'Data Overlap'
        				      ELSE '' end as msg99
          FROM   BUF_EQUIPMENT_M A(NOLOCK)
          LEFT OUTER JOIN (
            SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
            FROM   SCM_FACTORY_M(NOLOCK)
            WHERE  ACTIVE_FLAG = 'Y'
          ) B
          ON  A.COMPANY_ID  = B.COMPANY_ID
          AND A.DIVISION_ID = B.DIVISION_ID
          AND A.SITE_ID     = B.SITE_ID
          AND A.PLANT_ID    = B.PLANT_ID
          AND A.FACTORY_ID  = B.FACTORY_ID
          LEFT OUTER JOIN (
            SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
            FROM   SCM_OPERATION_M(NOLOCK)
            WHERE  ACTIVE_FLAG = 'Y'
          ) C
          ON  A.COMPANY_ID   = C.COMPANY_ID
          AND A.DIVISION_ID  = C.DIVISION_ID
          AND A.SITE_ID      = C.SITE_ID
          AND A.OPERATION_ID = C.OPERATION_ID
          LEFT OUTER JOIN (
            SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID, LINE_ID
            FROM   SCM_LINE_M(NOLOCK)
            WHERE  ACTIVE_FLAG = 'Y'
          ) D
          ON  A.COMPANY_ID   = D.COMPANY_ID
          AND A.DIVISION_ID  = D.DIVISION_ID
          AND A.SITE_ID      = D.SITE_ID
          AND A.PLANT_ID     = D.PLANT_ID
          AND A.FACTORY_ID   = D.FACTORY_ID
          AND A.OPERATION_ID = D.OPERATION_ID
          AND A.LINE_ID      = D.LINE_ID
          	LEFT OUTER JOIN (
					SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID
					FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)
					WHERE	1=1
					AND		R.USER_ID	= @USER_ID
					AND		R.SAVE_FLAG	= 'Y'
			) R
			ON		1=1
			AND		A.COMPANY_ID		= R.COMPANY_ID
			AND		A.DIVISION_ID		= R.DIVISION_ID
			AND		A.SITE_ID			= R.SITE_ID
			AND		A.PLANT_ID			= R.PLANT_ID
			AND		A.FACTORY_ID		= R.FACTORY_ID
			AND		A.OPERATION_ID		= R.OPERATION_ID
          WHERE A.JOB_USER_ID = @USER_ID
        ) A
      ) A
      ORDER BY A.JOB_ORDER