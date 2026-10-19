SELECT FP_PLAN_ID
            ,PLANT_ID
            ,FACTORY_ID
            ,OPERATION_ID
            ,WORK_ORDER_ID
            ,PLAN_DATE
            ,PARENT_ITEM_ID
            ,LINE_ID
            ,PLAN_QTY
            ,PLAN_IN_QTY
            ,CHILD_ITEM_ID 
            ,CHILD_ASSIGN_LINE_ID
            ,CHILD_ASSIGN_PRIORITY
            ,CASE WHEN (
               SELECT PRIORITY
               FROM   SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)
               WHERE PLANT_ID   =  A.PLANT_ID
                 AND FACTORY_ID = A.FACTORY_ID
                 AND ITEM_ID    = A.CHILD_ITEM_ID
                 AND LINE_ID    = A.LINE_ID
                 AND START_TIME <= A.PLAN_DATE
                 AND END_TIME   > A.PLAN_DATE
                 AND ACTIVE_FLAG = 'N') IS NULL THEN 'N' ELSE 'Y'END AS CHILD_ASSIGN_EXCEPT
      FROM (
          SELECT A.COMPANY_ID
                 ,A.DIVISION_ID
                 ,A.SITE_ID
                 ,A.PLANT_ID
                 ,A.FACTORY_ID
                 ,A.OPERATION_ID
                 ,A.WORK_ORDER_ID
                 ,PLAN_DATE
                 ,A.FP_PLAN_ID
                 ,A.LINE_ID
                 ,A.PLAN_QTY
                 ,A.PLAN_IN_QTY
                 ,PARENT_ITEM_ID
                 ,CHILD_ITEM_ID
                 ,I.LINE_ID AS CHILD_ASSIGN_LINE_ID
                 ,I.OPERATION_ID  AS CHILD_OPERATION_ID
                 ,I.PRIORITY AS CHILD_ASSIGN_PRIORITY
                 ,CASE WHEN A.ALT_ID IS NULL THEN 1 ELSE ROW_NUMBER() OVER ( PARTITION BY A.PARENT_ITEM_ID, A.WORK_ORDER_ID, A.ALT_ID ORDER BY I.LINE_ID DESC, A.ALT_PRIORITY, A.CHILD_ITEM_ID) END AS ORD_PRIORITY
          FROM (
                SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.PLAN_DATE, A.FP_PLAN_ID, A.WORK_ORDER_ID, A.PLAN_QTY, A.PLAN_IN_QTY, A.LINE_ID 
                      ,B.PARENT_ITEM_ID
                      ,B.CHILD_ITEM_ID
                      ,B.ALT_ID
                      ,B.ALT_PRIORITY
                FROM DBO.FP_PRODUCTION_PLAN_EQUIPMENT_R A WITH(NOLOCK)
                    ,DBO.SCM_BOM_M B WITH(NOLOCK)
                    ,DBO.SCM_FP_PLAN_DETAIL_H C WITH(NOLOCK)
                    ,DBO.SCM_ITEM_M D WITH(NOLOCK)
               WHERE 1=1
                 AND B.PARENT_ITEM_ID = A.ITEM_ID 
                 AND B.PLANT_ID = A.PLANT_ID 
                 AND CHILD_ITEM_ID LIKE 'ASL%' 
                 AND EFF_START_DATE <= A.START_TIME
                 AND EFF_END_DATE > A.START_TIME
                 AND A.FP_PLAN_ID   = C.RELEASE_PLAN_ID
                 AND B.COMPANY_ID    = D.COMPANY_ID
                 AND B.DIVISION_ID   = D.DIVISION_ID
                 AND B.SITE_ID       = D.SITE_ID
                 AND B.CHILD_ITEM_ID = D.ITEM_ID
                 AND D.ACTIVE_FLAG   = 'Y'
                 AND C.RELEASE_FLAG = 'Y'
                 AND C.PLAN_DATE    = @PLAN_DATE
                 AND C.INSTANCE_ID  = @INSTANCE_ID
                 AND C.PLAN_ID IN  (@PLAN_LT)
                 AND ORDER_TYPE = 'W'
                 AND PLAN_IN_QTY > 0.0
                 AND OPERATION_ID IN ( 'E2000', 'S2000')
            ) A
            LEFT OUTER JOIN  DBO.SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)
              ON A.PLANT_ID =  I.PLANT_ID
             AND A.FACTORY_ID  = I.FACTORY_ID
             AND A.CHILD_ITEM_ID = I.ITEM_ID
             AND A.LINE_ID = I.LINE_ID
             AND ACTIVE_FLAG = 'Y'
             AND MONTH = CONVERT(VARCHAR(6),A.PLAN_DATE, 112)
             AND I.PRIORITY != '9'
             AND NOT EXISTS  (
                    SELECT 1
                    FROM   SCM_ITEM_LINE_ASSIGN_EXCEPT_M KK WITH(NOLOCK)
                    WHERE PLANT_ID =  A.PLANT_ID
                    AND FACTORY_ID  = A.FACTORY_ID
                    AND ITEM_ID = A.CHILD_ITEM_ID
                    AND OPERATION_ID = I.OPERATION_ID
                    AND LINE_ID = I.LINE_ID
                    AND START_TIME <= A.PLAN_DATE
                    AND END_TIME >= A.PLAN_DATE
                    AND  ( ACTIVE_FLAG = 'N'
                        OR PRIORITY    = 0
                        OR PRIORITY    = 9 )
              )
      ) A
      WHERE ORD_PRIORITY = 1
      AND NOT EXISTS (
          SELECT 1 FROM DBO.FP_ORDER_PEGGING_R B WITH(NOLOCK)
          WHERE B.FP_PLAN_ID       = A.FP_PLAN_ID
          AND   B.TO_WORK_ORDER_ID = A.WORK_ORDER_ID
          AND   B.FROM_ITEM_ID     = A.CHILD_ITEM_ID
      )