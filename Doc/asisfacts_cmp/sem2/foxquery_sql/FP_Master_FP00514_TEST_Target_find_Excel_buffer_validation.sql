SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN '' ELSE (CASE WHEN LEFT(__MSG,10)=' Not Found' THEN REPLACE(__MSG,' Not Found, And ','') ELSE __MSG END) END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' THEN 'Y' ELSE 'N' END AS _VALID
      FROM 
      (
        SELECT A.* 
              ,MSG1
              +(CASE WHEN (MSG1 = '')                                                         THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                           THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                             THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')               THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
              +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '') THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
              +(CASE WHEN NROW>1 THEN ' Not Found, And Data Overlap!' ELSE ' Not Found' END) AS __MSG
        FROM 
        (
            SELECT T1.*
                  ,CASE WHEN T2.LINE_ID IS NULL THEN 'Line' else '' END AS MSG1
                  ,CASE WHEN T3.ITEM_ID IS NULL THEN 'Material' else '' END AS MSG2
                  ,'' AS MSG3
                  ,CASE WHEN T6.WO_FLAG = 'Y' THEN (CASE WHEN T5.PARENT_ITEM_ID IS NULL THEN 'BOM' ELSE '' END) ELSE '' END AS MSG4
                  ,CASE WHEN T6.OPERATION_ID IS NULL THEN 'Pack Operation' else '' END AS MSG5
                  ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG6
          				,ROW_NUMBER() OVER(PARTITION BY T1.COMPANY_ID,T1.DIVISION_ID,T1.SITE_ID,T1.PLANT_ID,T1.FACTORY_ID,T1.ITEM_ID,T1.OPERATION_ID,T1.LINE_ID
          				                   ORDER BY T1.COMPANY_ID,T1.DIVISION_ID,T1.SITE_ID,T1.PLANT_ID,T1.FACTORY_ID,T1.ITEM_ID,T1.OPERATION_ID,T1.LINE_ID) AS NROW
            FROM   BUF_PACK_WORKER_M T1(NOLOCK)
                   LEFT OUTER JOIN SCM_LINE_M T2(NOLOCK)
            ON     T1.COMPANY_ID = T2.COMPANY_ID
            AND    T1.DIVISION_ID = T2.DIVISION_ID
            AND    T1.SITE_ID = T2.SITE_ID
            AND    T1.PLANT_ID = T2.PLANT_ID
            AND    T1.FACTORY_ID = T2.FACTORY_ID
            AND    T1.OPERATION_ID = T2.OPERATION_ID
            AND    T1.LINE_ID = T2.LINE_ID
                   LEFT OUTER JOIN
                   (
                      SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
                                    , IC.LEVEL_2_CODE
                      FROM   SCM_ITEM_M A(NOLOCK), SCM_ITEM_CLASS_M IC(NOLOCK)
                      WHERE  A.ITEM_CLASS=IC.CLASS_ID
                      AND    IC.USE_FLAG='Y'
                      AND    A.ACTIVE_FLAG='Y'
                   ) T3
            ON     T1.COMPANY_ID = T3.COMPANY_ID
            AND    T1.DIVISION_ID = T3.DIVISION_ID
            AND    T1.SITE_ID = T3.SITE_ID
            AND    T1.ITEM_ID = T3.ITEM_ID
                   LEFT OUTER JOIN (
                      SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.PARENT_ITEM_ID
                      FROM  SCM_BOM_M B(NOLOCK)
                      WHERE B.ACTIVE_FLAG = 'Y'
                   ) T5
            ON     T1.COMPANY_ID = T5.COMPANY_ID
            AND    T1.DIVISION_ID = T5.DIVISION_ID
            AND    T1.SITE_ID = T5.SITE_ID
            AND    T1.PLANT_ID = T5.PLANT_ID
            AND    T1.ITEM_ID = T5.PARENT_ITEM_ID
                   LEFT OUTER JOIN SCM_OPERATION_M T6
            ON     T1.COMPANY_ID = T6.COMPANY_ID
            AND    T1.DIVISION_ID = T6.DIVISION_ID
            AND    T1.SITE_ID = T6.SITE_ID
            AND    T1.OPERATION_ID = T6.OPERATION_ID
            AND    T6.INSTANCE_TYPE = 'P'
            AND    T6.ACTIVE_FLAG = 'Y'
            LEFT OUTER JOIN (
                 SELECT DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
                 FROM   FP_USER_ROLE_INFO_V R WITH(NOLOCK)
                 WHERE  R.USER_ID   = @USER_ID
                 AND    R.SAVE_FLAG = 'Y'
            ) R
            ON   T1.COMPANY_ID   = R.COMPANY_ID
            AND  T1.DIVISION_ID  = R.DIVISION_ID
            AND  T1.SITE_ID      = R.SITE_ID
            AND  T1.PLANT_ID     = R.PLANT_ID
            AND  T1.FACTORY_ID   = R.FACTORY_ID
            AND  T1.OPERATION_ID = R.OPERATION_ID
            AND  T1.LINE_ID      = R.LINE_ID
            WHERE  T1.JOB_USER_ID = @USER_ID
        ) A
      ) A
      ORDER BY A.JOB_ORDER