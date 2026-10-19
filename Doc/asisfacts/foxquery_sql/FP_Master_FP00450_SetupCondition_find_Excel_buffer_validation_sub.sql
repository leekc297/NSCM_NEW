SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG9 = '' THEN '' ELSE MSG9 END)
                  ELSE (CASE WHEN MSG9 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG9 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG9 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
        SELECT A.* 
              ,MSG1
              +(CASE WHEN (MSG1 = '')                                                                                                   THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                     THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                       THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                         THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                           THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                             THEN MSG7 ELSE (CASE WHEN MSG7 = '' THEN '' ELSE ',' + MSG7 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')               THEN MSG8 ELSE (CASE WHEN MSG8 = '' THEN '' ELSE ',' + MSG8 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '') THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
              + ' Not Found'
              AS __MSG
        FROM (
          SELECT A.*
                ,case when B.PLANT_ID is null then 'Plant' else '' end as msg1
                ,case when C.OPERATION_ID is null then 'Operation' else '' end as msg2
                ,case when D.LINE_SETUP_GROUP_ID is null then 'Line Setup Group' else '' end as msg3
                ,case when E.SETUP_CATEGORY_ID is null then 'Category' else '' end as msg4
                ,case when F.SETUP_KEY_ID is null then 'Class' else '' end as msg5
                ,case when G.ITEM_SETUP_GROUP_ID is null then 'From Setup Group' else '' end as msg6
                ,case when H.ITEM_SETUP_GROUP_ID is null then 'To Setup Group' else '' end as msg7
                ,case when I.SETUP_CONDITION_ID is null then 'Setup Condition or Setup Time' else '' end as msg8
        				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.LINE_SETUP_GROUP_ID,A.SETUP_CATEGORY_ID,A.SETUP_KEY_ID,A.FROM_ITEM_SETUP_GROUP_ID,A.TO_ITEM_SETUP_GROUP_ID,A.SETUP_CONDITION_ID,A.OPERATION_ID
        				                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.LINE_SETUP_GROUP_ID,A.SETUP_CATEGORY_ID,A.SETUP_KEY_ID,A.FROM_ITEM_SETUP_GROUP_ID,A.TO_ITEM_SETUP_GROUP_ID,A.SETUP_CONDITION_ID,A.OPERATION_ID)>1 THEN 'Data Overlap'
        				      ELSE '' END AS MSG9
                ,CASE WHEN R.PLANT_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG10
          FROM   BUF_SETUP_MATRIX_M A WITH(NOLOCK)
          LEFT OUTER JOIN SCM_PLANT_M B WITH(NOLOCK)
          ON  A.COMPANY_ID  = B.COMPANY_ID
          AND A.DIVISION_ID = B.DIVISION_ID
          AND A.SITE_ID     = B.SITE_ID
          AND A.PLANT_ID    = B.PLANT_ID
          LEFT OUTER JOIN (
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
              FROM   SCM_OPERATION_M A WITH(NOLOCK)
              WHERE  A.ACTIVE_FLAG='Y'
          ) C
          ON  A.COMPANY_ID    = C.COMPANY_ID
          AND A.DIVISION_ID   = C.DIVISION_ID
          AND A.SITE_ID       = C.SITE_ID
          AND A.OPERATION_ID  = C.OPERATION_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT 
                     A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.OPERATION_ID, A.LINE_SETUP_GROUP_ID
              FROM   SCM_LINE_SETUP_GROUP_M A WITH(NOLOCK)
          ) D
          ON  A.COMPANY_ID    = D.COMPANY_ID
          AND A.DIVISION_ID   = D.DIVISION_ID
          AND A.SITE_ID       = D.SITE_ID
          AND A.PLANT_ID      = D.PLANT_ID
          AND A.OPERATION_ID  = D.OPERATION_ID
          AND A.LINE_SETUP_GROUP_ID = D.LINE_SETUP_GROUP_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, SETUP_CATEGORY_ID
              FROM   SCM_ITEM_SETUP_GROUP_M AA WITH(NOLOCK)
          ) E
          ON  A.COMPANY_ID    = E.COMPANY_ID
          AND A.DIVISION_ID   = E.DIVISION_ID
          AND A.SITE_ID       = E.SITE_ID
          AND A.OPERATION_ID  = E.OPERATION_ID
          AND A.SETUP_CATEGORY_ID   = E.SETUP_CATEGORY_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID, SETUP_CATEGORY_ID, SETUP_KEY_ID
              FROM   SCM_ITEM_SETUP_GROUP_M AA WITH(NOLOCK)
          ) F
          ON  A.COMPANY_ID    = F.COMPANY_ID
          AND A.DIVISION_ID   = F.DIVISION_ID
          AND A.SITE_ID       = F.SITE_ID
          AND A.OPERATION_ID  = F.OPERATION_ID
          AND A.SETUP_CATEGORY_ID   = F.SETUP_CATEGORY_ID
          AND A.SETUP_KEY_ID        = F.SETUP_KEY_ID
          LEFT OUTER JOIN (
              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
                    ,SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID
              FROM   SCM_ITEM_SETUP_GROUP_M AA WITH(NOLOCK)
              UNION ALL
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                    ,'Item' AS SETUP_CATEGORY_ID, '-' AS SETUP_KEY_ID, A.ITEM_ID AS ITEM_SETUP_GROUP_ID
              FROM   SCM_ITEM_FLOW_V A
              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.ITEM_ID
          ) G
          ON  A.COMPANY_ID    = G.COMPANY_ID
          AND A.DIVISION_ID   = G.DIVISION_ID
          AND A.SITE_ID       = G.SITE_ID
          AND A.OPERATION_ID  = G.OPERATION_ID
          AND A.SETUP_CATEGORY_ID         = G.SETUP_CATEGORY_ID
          AND A.SETUP_KEY_ID              = G.SETUP_KEY_ID
          AND A.FROM_ITEM_SETUP_GROUP_ID  = G.ITEM_SETUP_GROUP_ID
          LEFT OUTER JOIN (
              SELECT COMPANY_ID, DIVISION_ID, SITE_ID, OPERATION_ID
                    ,SETUP_CATEGORY_ID, SETUP_KEY_ID, ITEM_SETUP_GROUP_ID
              FROM   SCM_ITEM_SETUP_GROUP_M A WITH(NOLOCK)
              UNION ALL
              SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID
                    ,'Item' AS SETUP_CATEGORY_ID, '-' AS SETUP_KEY_ID, A.ITEM_ID AS ITEM_SETUP_GROUP_ID
              FROM   SCM_ITEM_FLOW_V A
              GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.OPERATION_ID, A.ITEM_ID
          ) H
          ON  A.COMPANY_ID    = H.COMPANY_ID
          AND A.DIVISION_ID   = H.DIVISION_ID
          AND A.SITE_ID       = H.SITE_ID
          AND A.OPERATION_ID  = H.OPERATION_ID
          AND A.SETUP_CATEGORY_ID       = H.SETUP_CATEGORY_ID
          AND A.SETUP_KEY_ID            = H.SETUP_KEY_ID
          AND A.TO_ITEM_SETUP_GROUP_ID  = H.ITEM_SETUP_GROUP_ID
          LEFT OUTER JOIN (
              SELECT DISTINCT 
                     COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, OPERATION_ID, LINE_SETUP_GROUP_ID
                    ,SETUP_CATEGORY_ID, SETUP_KEY_ID, SETUP_CONDITION_ID, SETUP_TIME
              FROM   SCM_SETUP_CONDITION_M AA WITH(NOLOCK)
          ) I
          ON  A.COMPANY_ID    = I.COMPANY_ID
          AND A.DIVISION_ID   = I.DIVISION_ID
          AND A.SITE_ID       = I.SITE_ID
          AND A.PLANT_ID      = I.PLANT_ID
          AND A.OPERATION_ID  = I.OPERATION_ID
          AND A.LINE_SETUP_GROUP_ID = I.LINE_SETUP_GROUP_ID
          AND A.SETUP_CATEGORY_ID   = I.SETUP_CATEGORY_ID
          AND A.SETUP_KEY_ID        = I.SETUP_KEY_ID
          AND A.SETUP_CONDITION_ID  = I.SETUP_CONDITION_ID
          AND A.SETUP_TIME          = I.SETUP_TIME
          LEFT OUTER JOIN (
               SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.OPERATION_ID
               FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
               WHERE  R.USER_ID   = @USER_ID
               AND    R.SAVE_FLAG = 'Y'
          ) R
          ON   A.COMPANY_ID   = R.COMPANY_ID
          AND  A.DIVISION_ID  = R.DIVISION_ID
          AND  A.SITE_ID      = R.SITE_ID
          AND  A.PLANT_ID     = R.PLANT_ID
          AND  A.OPERATION_ID = R.OPERATION_ID
          WHERE A.JOB_USER_ID = @USER_ID
        ) A
      ) A
      ORDER BY A.JOB_ORDER