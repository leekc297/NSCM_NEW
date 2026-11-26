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
          SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
                ,CONVERT(CHAR(8), A.CUTOFF_DATE, 112) AS CUTOFF_DATE, A.WORK_ORDER_ID, A.DEMAND_ID, A.PRODUCTION_TYPE
                ,A.ORDER_TYPE, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, ISNULL(B.NICK_NAME, '-') AS NICK_NAME
                ,A.LINE_ID, A.WORK_CENTER_ID, CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
                ,CONVERT(VARCHAR, A.PLAN_START_TIME, 120) AS PLAN_START_TIME, CONVERT(VARCHAR, A.PLAN_END_TIME, 120) AS PLAN_END_TIME
                ,A.PLAN_QTY
                ,CONVERT(VARCHAR, A.ACTUAL_START_TIME, 120) AS ACTUAL_START_TIME, CONVERT(VARCHAR, A.ACTUAL_END_TIME, 120) AS ACTUAL_END_TIME
                ,A.ACTUAL_QTY, A.ACTUAL_GOOD_QTY, A.ACTUAL_SCRAP_QTY, A.BOM_VERSION_ID, A.WO_STATUS
                ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_SEQ, A.JOB_ORDER
                ,case when B.ITEM_ID is null then 'Material' else '' end as msg1
                ,case when C.FACTORY_ID is null then 'Building' else '' end as msg2
                ,case when D.DT is null then 'CutOff Date' else '' end as msg3
        				,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.CUTOFF_DATE,A.WORK_ORDER_ID
        				                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.FACTORY_ID,A.CUTOFF_DATE,A.WORK_ORDER_ID)>1 THEN 'Data Overlap'
        				      ELSE '' end as msg99
          FROM   BUF_ERP_WORK_ORDER_STATUS_H A(NOLOCK)
          LEFT OUTER JOIN (
            SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID, A.NICK_NAME
            FROM   SCM_ITEM_M A(NOLOCK), SCM_ITEM_CLASS_M B(NOLOCK)
            WHERE  A.ITEM_CLASS = B.CLASS_ID
            AND    A.ACTIVE_FLAG = 'Y'
            AND    B.USE_FLAG = 'Y'
          ) B
          ON  A.COMPANY_ID  = B.COMPANY_ID
          AND A.DIVISION_ID = B.DIVISION_ID
          AND A.SITE_ID     = B.SITE_ID
          AND A.ITEM_ID     = B.ITEM_ID
          LEFT OUTER JOIN (
            SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
            FROM   SCM_FACTORY_M(NOLOCK)
            WHERE  ACTIVE_FLAG = 'Y'
          ) C
          ON  A.COMPANY_ID  = C.COMPANY_ID
          AND A.DIVISION_ID = C.DIVISION_ID
          AND A.SITE_ID     = C.SITE_ID
          AND A.PLANT_ID    = C.PLANT_ID
          AND A.FACTORY_ID  = C.FACTORY_ID
          LEFT OUTER JOIN TH_UIS_CAL D(NOLOCK)
          ON  CONVERT(VARCHAR(8), A.CUTOFF_DATE, 112) = D.DT
          WHERE A.JOB_USER_ID = @USER_ID
        ) A
      ) A
      ORDER BY A.JOB_ORDER