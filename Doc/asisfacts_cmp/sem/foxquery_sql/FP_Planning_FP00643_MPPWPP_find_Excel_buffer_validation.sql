SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
          SELECT TT.*
                ,MSG1
                +(CASE WHEN (MSG1 = '')                                                                                                                                                                             THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                                                                               THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                                                                                 THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                                                                                   THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                                                                                     THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                                                                                                       THEN MSG7 ELSE (CASE WHEN MSG7 = '' THEN '' ELSE ',' + MSG7 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')                                                                                         THEN MSG8 ELSE (CASE WHEN MSG8 = '' THEN '' ELSE ',' + MSG8 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')                                                                           THEN MSG9 ELSE (CASE WHEN MSG9 = '' THEN '' ELSE ',' + MSG9 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '')                                                             THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '')                                              THEN MSG11 ELSE (CASE WHEN MSG11 = '' THEN '' ELSE ',' + MSG11 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '')                               THEN MSG12 ELSE (CASE WHEN MSG12 = '' THEN '' ELSE ',' + MSG12 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '' AND MSG12 = '')				THEN MSG13 ELSE (CASE WHEN MSG13 = '' THEN '' ELSE ',' + MSG13 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '' AND MSG12 = '' AND MSG13 = '')	THEN MSG14 ELSE (CASE WHEN MSG14 = '' THEN '' ELSE ',' + MSG14 END) END)
                + ' Not Found' AS __MSG
          FROM (
              SELECT DISTINCT A.INSTANCE_ID, A.FP_PLAN_ID
                    ,A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                    ,A.FACTORY_ID, A.LOCATION
                    ,A.OPERATION_ID, A.LINE_ID, D.LINE_NAME, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
                    ,A.PLAN_DATE
                    ,A.TOP_ITEM_ID, A.ITEM_ID, B.NICK_NAME
                    ,A.PRODUCTION_TYPE, A.MARKET
                    ,A.SEQ, A.QTY
                    ,A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR
                    ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                    ,CASE WHEN A.COMPANY_ID IS NULL THEN 'Building' ELSE '' END AS MSG1
                    ,CASE WHEN B.ITEM_ID IS NULL THEN 'Material' ELSE '' END AS MSG2
                    ,CASE WHEN C.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG3
                    ,CASE WHEN D.LINE_ID IS NULL THEN 'Line - Electrode Type' ELSE '' END AS MSG4
                    ,CASE WHEN E.CODE_ID IS NULL THEN 'Production Type' ELSE '' END AS MSG5
                    ,CASE WHEN F.CODE_ID IS NULL THEN 'Market' ELSE '' END AS MSG6
                    ,CASE WHEN L.EQUIPMENT_ID IS NULL THEN 'Equipment' ELSE '' END AS MSG7
                    ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN A.OPERATION_ID='A9000' THEN ( CASE WHEN G.ITEM_ID IS NULL THEN 'RCCP or Test Target' ELSE '' END ) ELSE '' END ) ELSE '' END AS MSG8
                    --,CASE WHEN A.QTY > 0 THEN ( CASE WHEN H.MARKET IS NULL THEN 'SCP or Test Target-Market' ELSE '' END ) ELSE '' END AS MSG9
                    ,'' AS MSG9
                    ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN I.LINE_ID IS NULL THEN 'Line Assign' ELSE '' END ) ELSE '' END AS MSG10
                    ,CASE WHEN A.QTY > 0 THEN ( CASE WHEN K.KEY_VALUE = 'DAILY_CAPA' THEN (CASE WHEN (J.DAILY_CAPA IS NULL OR J.DAILY_CAPA = 0) THEN 'Daily Capa' ELSE '' END)
                                                     ELSE (CASE WHEN (J.TACT_TIME IS NULL OR J.TACT_TIME = 0) THEN 'Tact Time' ELSE '' END) END ) ELSE '' END AS MSG11
                    ,CASE WHEN N.ITEM_ID IS NULL THEN 'Model Measure Conversion' ELSE '' END AS MSG12
                    ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG13
                    ,(CASE WHEN @CONFIRM_AREA = 'BUILDING' THEN (CASE WHEN A.FACTORY_ID <> @RELEASE_VALUE THEN 'Release - Unacceptable Building' ELSE '' END)
        			                                          ELSE (CASE WHEN D.MODEL_TYPE <> @RELEASE_VALUE THEN 'Release - Unacceptable Plan Group' ELSE '' END) END) AS MSG14
                    ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE
            				                             ORDER BY     A.FACTORY_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.EQUIPMENT_ID, A.ELECTRODE_TYPE, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE)>1 THEN 'Data Overlap'
            				      ELSE '' END AS MSG99
                    , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO
              FROM (
                  SELECT A.INSTANCE_ID, A.FP_PLAN_ID
                       , ISNULL(B.COMPANY_ID,'-') AS COMPANY_ID, ISNULL(B.DIVISION_ID,'-') AS DIVISION_ID, ISNULL(B.SITE_ID,'-') AS SITE_ID, ISNULL(B.PLANT_ID,'-') AS PLANT_ID
                       , A.FACTORY_ID, A.LOCATION
                       , A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.EQUIPMENT_ID
                       , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE
                       , A.TOP_ITEM_ID, A.ITEM_ID
                       , A.PRODUCTION_TYPE, A.MARKET
                       , A.SEQ, A.QTY
                       , A.ADJUST_IN_QTY_BATCH, A.ADJUST_IN_QTY_M, A.ADJUST_IN_QTY_CELL, A.ADJUST_IN_QTY_JR
                       , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                       , A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO
                  FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
                  LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)
                  ON    A.DIVISION_ID = B.DIVISION_ID
                  AND	  A.SITE_ID	    = B.SITE_ID
                  AND	  A.PLANT_ID	  = B.PLANT_ID
                  AND 	A.FACTORY_ID  = B.FACTORY_ID
                  AND   B.ACTIVE_FLAG = 'Y'
                  WHERE A.JOB_USER_ID = @USER_ID
                  AND		A.INSTANCE_ID = @INSTANCE_ID
              ) A
              LEFT OUTER JOIN (
                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,
                         A.ITEM_ID, ISNULL(A.NICK_NAME,'-') AS NICK_NAME,
                         A.APPLIED_MODEL
                  FROM	 SCM_ITEM_M A WITH(NOLOCK),
                    		 SCM_ITEM_CLASS_M C WITH(NOLOCK)
                  WHERE	 A.ITEM_CLASS  = C.CLASS_ID
              ) B
              ON  A.COMPANY_ID      = B.COMPANY_ID
              AND A.DIVISION_ID     = B.DIVISION_ID
              AND A.SITE_ID         = B.SITE_ID
              AND A.ITEM_ID         = B.ITEM_ID
              LEFT OUTER JOIN SCM_OPERATION_M C WITH(NOLOCK)
              ON  A.COMPANY_ID      = C.COMPANY_ID
              AND A.DIVISION_ID     = C.DIVISION_ID
              AND A.SITE_ID         = C.SITE_ID
              AND A.OPERATION_ID    = C.OPERATION_ID
              AND C.ACTIVE_FLAG     = 'Y'
              LEFT OUTER JOIN SCM_LINE_M D WITH(NOLOCK)
              ON  A.COMPANY_ID      = D.COMPANY_ID
              AND A.DIVISION_ID     = D.DIVISION_ID
              AND A.SITE_ID         = D.SITE_ID
              AND A.PLANT_ID        = D.PLANT_ID
              AND A.FACTORY_ID      = D.FACTORY_ID
              AND A.OPERATION_ID    = D.OPERATION_ID
              AND A.LINE_ID         = D.LINE_ID
              AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE
              AND D.ACTIVE_FLAG     = 'Y'
              LEFT OUTER JOIN (
                  SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID
                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                  WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                  AND    A.ACTIVE_FLAG = 'Y'
              ) E
              ON  A.PRODUCTION_TYPE = E.CODE_ID
              AND A.DIVISION_ID = E.SEGMENT1
              AND (CASE WHEN A.SITE_ID <> 'A004' AND A.PRODUCTION_TYPE IN ('E-TEST','D-TEST') THEN 'XX' ELSE A.PRODUCTION_TYPE END ) = E.CODE_ID
              LEFT OUTER JOIN (
                  SELECT A.SEGMENT1 AS CODE_ID
                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                  WHERE  A.LOOKUP_TYPE_CODE = 'DEMAND_MARKET_TYPE'
                  AND    A.ACTIVE_FLAG = 'Y'
              ) F
              ON  A.MARKET = F.CODE_ID
              LEFT OUTER JOIN (
                  SELECT DISTINCT INSTANCE_ID, COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, ITEM_ID
                  FROM   FP_INSTANCE_ITEM_V
              ) G
              ON  A.INSTANCE_ID = G.INSTANCE_ID
              AND A.COMPANY_ID  = G.COMPANY_ID
              AND A.DIVISION_ID = G.DIVISION_ID
              AND A.SITE_ID     = G.SITE_ID
              AND A.PLANT_ID    = G.PLANT_ID
              AND A.ITEM_ID     = G.ITEM_ID
              LEFT OUTER JOIN SCM_ITEM_LINE_ASSIGN_M I WITH(NOLOCK)
              ON  A.COMPANY_ID     = I.COMPANY_ID
              AND A.DIVISION_ID    = I.DIVISION_ID
              AND A.SITE_ID        = I.SITE_ID
              AND A.PLANT_ID       = I.PLANT_ID
              AND A.FACTORY_ID     = I.FACTORY_ID
              AND A.ITEM_ID        = I.ITEM_ID
              AND A.OPERATION_ID   = I.OPERATION_ID
              AND A.LINE_ID        = I.LINE_ID
              AND A.ELECTRODE_TYPE = I.ELECTRODE_TYPE
              AND SUBSTRING(A.PLAN_DATE,1,6) = I.MONTH
              AND I.ACTIVE_FLAG    = 'Y'
              AND I.PRIORITY NOT IN ('0','9')
              LEFT OUTER JOIN SCM_TACT_TIME_M J WITH(NOLOCK)
              ON  A.COMPANY_ID      = J.COMPANY_ID
              AND A.DIVISION_ID     = J.DIVISION_ID
              AND A.SITE_ID         = J.SITE_ID
              AND A.PLANT_ID        = J.PLANT_ID
              AND A.FACTORY_ID      = J.FACTORY_ID
              AND A.ITEM_ID         = J.ITEM_ID
              AND A.OPERATION_ID    = J.OPERATION_ID
              AND A.LINE_ID         = J.LINE_ID
              AND A.ELECTRODE_TYPE  = J.ELECTRODE_TYPE
              AND SUBSTRING(A.PLAN_DATE,1,6) = J.MONTH
              LEFT OUTER JOIN FP_INSTANCE_CONFIG_M K WITH(NOLOCK)
              ON  A.INSTANCE_ID     = K.INSTANCE_ID
              AND K.KEY_ID          = 'FINAL_OP_CAPA'
              LEFT OUTER JOIN SCM_EQUIPMENT_M L WITH(NOLOCK)
              ON  A.COMPANY_ID      = L.COMPANY_ID
              AND A.DIVISION_ID     = L.DIVISION_ID
              AND A.SITE_ID         = L.SITE_ID
              AND A.PLANT_ID        = L.PLANT_ID
              AND A.FACTORY_ID      = L.FACTORY_ID
              AND A.OPERATION_ID    = L.OPERATION_ID
              AND A.LINE_ID		      = L.LINE_ID
              AND A.EQUIPMENT_ID    = L.EQUIPMENT_ID
              AND L.ACTIVE_FLAG 	  = 'Y'
              LEFT OUTER HASH JOIN (
                  SELECT DISTINCT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, VERSION
                  FROM (
                      SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, VERSION
                      FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
                      WHERE  A.OPERATION = 'E2000'
                      AND    A.VALUE > 0
                      AND    A.CATEGORY IN (  'Jumbo Roll (cell/m)'
                                            , 'Lane Number'
                                            , 'Pancake (m/batch)'
                                            , 'cell/batch'
                                            , 'Jumbo Roll (m/batch)'
                                            , 'Pancake (cell/m)' )
                      GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, MODEL_ID, OPERATION, ITEM_ID, VERSION
                      HAVING COUNT(1) = 6
                  ) A
              ) N
              ON  A.COMPANY_ID    = N.COMPANY_ID
              AND A.DIVISION_ID   = N.DIVISION_ID
              AND A.SITE_ID       = N.SITE_ID
              AND A.PLANT_ID      = N.PLANT_ID
              AND A.FACTORY_ID    = N.FACTORY_ID
              AND A.OPERATION_ID  = N.OPERATION
              AND A.ITEM_ID       = N.ITEM_ID
              AND A.WORK_REQUEST_MODEL_ID = N.MODEL_ID
              AND A.VERSION       = N.VERSION
              LEFT OUTER JOIN (
      						SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
      						FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)
      						WHERE	1=1
      						AND		R.USER_ID	= @USER_ID
      						AND		R.SAVE_FLAG	= 'Y'
      						AND		R.INSTANCE_ID = @INSTANCE_ID
      				) R
      				ON		1=1
      				AND		A.COMPANY_ID   = R.COMPANY_ID
      				AND		A.DIVISION_ID  = R.DIVISION_ID
      				AND		A.SITE_ID      = R.SITE_ID
      				AND		A.PLANT_ID     = R.PLANT_ID
      				AND		A.FACTORY_ID   = R.FACTORY_ID
      				AND		A.OPERATION_ID = R.OPERATION_ID
      				AND		A.LINE_ID      = R.LINE_ID
          ) TT
      ) A
      ORDER BY A.JOB_ORDER