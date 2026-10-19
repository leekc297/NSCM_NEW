SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG6 = '' THEN '' ELSE MSG6 END)
                  ELSE (CASE WHEN MSG6 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG6 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG6 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
        SELECT A.* 
              ,MSG1
              +(CASE WHEN (MSG1 = '')                                           THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '')                             THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')               THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '') THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
              + ' Not Found' 
              AS __MSG
        FROM (
          SELECT A.*
                ,case when B.PLANT_ID is null then 'Plant' else '' end as msg1
                ,case when C.OPERATION_ID is null then 'Operation' else '' end as msg2
                ,case when D.LINE_SETUP_GROUP_ID is null then 'Line Setup Group' else '' end as msg3
                ,case when E.SETUP_CATEGORY_ID is null then 'Category' else '' end as msg4
                ,case when F.SETUP_KEY_ID is null then 'Class' else '' end as msg5
        				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.OPERATION_ID,A.LINE_SETUP_GROUP_ID,A.SETUP_CATEGORY_ID,A.SETUP_KEY_ID,A.SETUP_CONDITION_ID
        				                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.OPERATION_ID,A.LINE_SETUP_GROUP_ID,A.SETUP_CATEGORY_ID,A.SETUP_KEY_ID,A.SETUP_CONDITION_ID)>1 THEN 'Data Overlap'
        				      ELSE '' end as msg6
          FROM   BUF_SETUP_CONDITION_M A(NOLOCK)
          LEFT OUTER JOIN SCM_PLANT_M B(NOLOCK)
          ON  A.COMPANY_ID  = B.COMPANY_ID
          AND A.DIVISION_ID = B.DIVISION_ID
          AND A.SITE_ID     = B.SITE_ID
          AND A.PLANT_ID    = B.PLANT_ID
          LEFT OUTER JOIN (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
              FROM   SCM_OPERATION_M A(NOLOCK)
              WHERE  A.ACTIVE_FLAG='Y'
          ) C
          ON  A.COMPANY_ID    = C.COMPANY_ID
          AND A.DIVISION_ID   = C.DIVISION_ID
          AND A.SITE_ID       = C.SITE_ID
          AND A.OPERATION_ID  = C.OPERATION_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT 
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID
              FROM   SCM_LINE_SETUP_GROUP_M A(NOLOCK)
          ) D
          ON  A.COMPANY_ID    = D.COMPANY_ID
          AND A.DIVISION_ID   = D.DIVISION_ID
          AND A.SITE_ID       = D.SITE_ID
          AND A.PLANT_ID      = D.PLANT_ID
          AND A.OPERATION_ID  = D.OPERATION_ID
          AND A.LINE_SETUP_GROUP_ID = D.LINE_SETUP_GROUP_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, SETUP_CATEGORY_ID
              FROM   SCM_ITEM_SETUP_GROUP_M(NOLOCK)
          ) E
          ON  A.COMPANY_ID    = E.COMPANY_ID
          AND A.DIVISION_ID   = E.DIVISION_ID
          AND A.SITE_ID       = E.SITE_ID
          AND A.OPERATION_ID  = E.OPERATION_ID
          AND A.SETUP_CATEGORY_ID   = E.SETUP_CATEGORY_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID
              FROM   SCM_ITEM_SETUP_GROUP_M(NOLOCK)
          ) F
          ON  A.COMPANY_ID    = F.COMPANY_ID
          AND A.DIVISION_ID   = F.DIVISION_ID
          AND A.SITE_ID       = F.SITE_ID
          AND A.OPERATION_ID  = F.OPERATION_ID
          AND A.SETUP_CATEGORY_ID   = F.SETUP_CATEGORY_ID
          AND A.SETUP_KEY_ID        = F.SETUP_KEY_ID
          WHERE A.JOB_USER_ID = @USER_ID
        ) A
      ) A
      ORDER BY A.JOB_ORDER