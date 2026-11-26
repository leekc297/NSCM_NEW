SELECT A.*
            ,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG99 = '' THEN '' ELSE MSG99 END)
                  ELSE (CASE WHEN MSG99 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG99 END)
                  END AS _MSG
            ,CASE WHEN __MSG = ' Not Found' AND MSG99 = '' THEN 'Y' ELSE 'N' END AS _VALID
      FROM (
          SELECT TT.*
                ,MSG1
                +(CASE WHEN (MSG1 = '')                                                                                                                                 THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                                                                                                   THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                                                                                                     THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')                                                                                       THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '')                                                                         THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '')                                                           THEN MSG7 ELSE (CASE WHEN MSG7 = '' THEN '' ELSE ',' + MSG7 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '')                                             THEN MSG8 ELSE (CASE WHEN MSG8 = '' THEN '' ELSE ',' + MSG8 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '')                               THEN MSG9 ELSE (CASE WHEN MSG9 = '' THEN '' ELSE ',' + MSG9 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '')                 THEN MSG10 ELSE (CASE WHEN MSG10 = '' THEN '' ELSE ',' + MSG10 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '')  THEN MSG11 ELSE (CASE WHEN MSG11 = '' THEN '' ELSE ',' + MSG11 END) END)
                +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '' AND MSG6 = '' AND MSG7 = '' AND MSG8 = '' AND MSG9 = '' AND MSG10 = '' AND MSG11 = '')  THEN MSG12 ELSE (CASE WHEN MSG12 = '' THEN '' ELSE ',' + MSG12 END) END)
                + ' Not Found' AS __MSG
          FROM (
              SELECT DISTINCT
                     A.INSTANCE_ID, A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                    ,A.ITEM_ID, B.NICK_NAME, B.ITEM_TYPE, A.TOP_ITEM_ID
                    ,A.OPERATION_ID, A.FACTORY_ID
                    ,A.PRODUCTION_TYPE, A.MARKET
                    ,A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION
                    ,A.PLAN_DATE, A.QTY, A.PLM_EC_NO, A.VERSION
                    ,A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                    ,CASE WHEN A.COMPANY_ID IS NULL THEN 'Building' ELSE '' END AS MSG1
                    ,CASE WHEN B.ITEM_ID IS NULL THEN 'Material' ELSE '' END AS MSG2
                    ,CASE WHEN C.OPERATION_ID IS NULL THEN 'Operation' ELSE '' END AS MSG3
                    ,CASE WHEN D.LINE_ID IS NULL THEN 'Line - Electrode Type - Location' ELSE '' END AS MSG4
                    ,CASE WHEN E.CODE_ID IS NULL THEN 'Production Type' ELSE '' END AS MSG5
                    ,CASE WHEN F.CODE_ID IS NULL THEN 'Market' ELSE '' END AS MSG6
                    ,(CASE WHEN @CONFIRM_AREA = 'BUILDING' THEN (CASE WHEN A.FACTORY_ID <> @RELEASE_VALUE THEN 'Release - Unacceptable Building' ELSE '' END)
        			                                          ELSE (CASE WHEN D.MODEL_TYPE <> @RELEASE_VALUE THEN 'Release - Unacceptable Plan Group' ELSE '' END) END) AS MSG7
            		    --,'' AS MSG8
            		    , (CASE WHEN O.IS_CELL_ASSY = 'Y' AND A.OPERATION_ID IN ('A3000','A9000') AND A.TOP_ITEM_ID = A.ITEM_ID THEN 'not allowed cell product material' ELSE '' END) AS MSG8 -- cell product/assy check... 20230704
            		    --,'' AS MSG9
            		    , (CASE WHEN E._4MCC_TARGET_FLAG = 'Y' AND P.VERSION IS NULL THEN 'Version'
            		            WHEN E._4MCC_TARGET_FLAG <> 'Y' AND A.VERSION <> '-' THEN ' - Version'
            		            ELSE '' END) AS MSG9
                    ,'' AS MSG10
                    ,'' AS MSG11
                    ,CASE WHEN R.FACTORY_ID IS NULL THEN 'Permissions' ELSE '' END AS MSG12
                    ,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE, A.PLM_EC_NO, A.VERSION
            				                             ORDER BY     A.FACTORY_ID, A.ITEM_ID, A.TOP_ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE, A.LOCATION, A.PRODUCTION_TYPE, A.MARKET, A.PLAN_DATE, A.PLM_EC_NO, A.VERSION )>1 THEN 'Data Overlap'
            				      ELSE '' END AS MSG99
              FROM (
                  SELECT A.INSTANCE_ID
                       , B.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID
                       , A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID, A.LOCATION
                       , A.PRODUCTION_TYPE, A.MARKET
                       , A.LINE_ID, A.ELECTRODE_TYPE
                       , A.TOP_ITEM_ID, A.ITEM_TYPE 
                       , CONVERT(VARCHAR, A.PLAN_DATE, 112) AS PLAN_DATE, A.OUT_QTY AS QTY
                       , A.PLM_EC_NO, A.VERSION
                       , A.JOB_USER_ID, A.JOB_TIME, A.JOB_TYPE, A.JOB_ORDER
                  FROM   BUF_AMEND_PLAN_CELL_R A WITH(NOLOCK)
                  LEFT OUTER JOIN SCM_FACTORY_M B WITH(NOLOCK)
                  ON    A.DIVISION_ID = B.DIVISION_ID
                  AND   A.SITE_ID     = B.SITE_ID
                  AND   A.PLANT_ID    = B.PLANT_ID
                  AND 	A.FACTORY_ID  = B.FACTORY_ID
                  AND   B.ACTIVE_FLAG = 'Y'
                  WHERE A.JOB_SAVE_SEQ = @NEW_SEQ
              ) A
              LEFT OUTER JOIN (
                  SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, B.PLANT_ID, B.MODEL_ID, A.ITEM_ID
                        , ISNULL(A.NICK_NAME,'-') AS NICK_NAME,
                         (CASE WHEN LEFT(A.FLOW_ID,5) = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN C.LEVEL_3_NAME
                         	     WHEN LEFT(A.FLOW_ID,5) = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
                         	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE
                  FROM	 SCM_ITEM_M A WITH(NOLOCK),
                    		 SCM_MODEL_COMP_EFFECTIVE_DATE B WITH(NOLOCK),
                    		 SCM_ITEM_CLASS_M C WITH(NOLOCK),
                         (
                            SELECT DISTINCT B.COMPANY_ID, B.DIVISION_ID, B.SITE_ID, B.OPERATION_ID
                            FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK), SCM_OPERATION_M B WITH(NOLOCK)
                            WHERE  A.COMPANY_ID   = B.COMPANY_ID
                            AND    A.DIVISION_ID  = B.DIVISION_ID
                            AND    A.SITE_ID      = B.SITE_ID
                            AND    A.OPERATION_ID = B.OPERATION_ID
                            AND    A.INSTANCE_ID  = @MASTER_ID
                            AND    A.AMEND_FLAG   = 'Y'
                            AND    B.ACTIVE_FLAG  = 'Y'
                         ) D
                  WHERE	 A.COMPANY_ID  = B.COMPANY_ID
                  AND	 A.DIVISION_ID = B.DIVISION_ID
                  AND	 A.SITE_ID     = B.SITE_ID
                  AND	 A.ITEM_ID     = B.CHILD_ITEM_ID
                  AND	 A.ITEM_CLASS  = C.CLASS_ID
                  AND    A.COMPANY_ID  = D.COMPANY_ID
                  AND    A.DIVISION_ID = D.DIVISION_ID
                  AND    A.SITE_ID     = D.SITE_ID
                  AND    A.FLOW_ID LIKE '%' + D.OPERATION_ID + '%'
                  AND    A.ACTIVE_FLAG = 'Y'
                  AND    C.USE_FLAG = 'Y'
                  AND    B.EFF_END_DATE >= GETDATE()
              ) B
              ON  A.COMPANY_ID      = B.COMPANY_ID
              AND A.DIVISION_ID     = B.DIVISION_ID
              AND A.SITE_ID         = B.SITE_ID
              AND A.PLANT_ID        = B.PLANT_ID
              AND A.TOP_ITEM_ID     = B.MODEL_ID
              AND A.ITEM_ID         = B.ITEM_ID
              --AND A.PLAN_DATE >= B.EFF_START_DATE AND A.PLAN_DATE < B.EFF_END_DATE
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
              AND A.LOCATION        = ISNULL(D.LOCATION,'-')
              AND A.ELECTRODE_TYPE  = D.ELECTRODE_TYPE
              AND D.ACTIVE_FLAG     = 'Y'
              LEFT OUTER JOIN (
                  SELECT DISTINCT  A.SEGMENT1, A.ATTRIBUTE2 AS CODE_ID, (CASE WHEN ATTRIBUTE5 = 'Y' AND ATTRIBUTE6 = 'Y' THEN 'Y' ELSE 'N' END) AS _4MCC_TARGET_FLAG
                  FROM   SCM_SYS_LOOKUP_VALUE A WITH(NOLOCK)
                  WHERE  A.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
                  AND    A.ACTIVE_FLAG = 'Y'
                  @INSTANCE_COND

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
              -- cell product/assy check... 20230704
              LEFT OUTER JOIN (
            			SELECT (CASE WHEN MAX(B.SEGMENT1) IS NULL THEN 'N' ELSE 'Y' END) AS IS_CELL_ASSY
            			FROM   SCM_SYS_LOOKUP_VALUE  B WITH(NOLOCK)
            			WHERE  B.ACTIVE_FLAG = 'Y'
            			AND    B.ATTRIBUTE1 = 'Y'
            			AND    B.LOOKUP_TYPE_CODE = 'CELL_PRODUCT_ASSY'
                  AND B.SEGMENT1 IN (
            				SELECT MAX(SITE_ID)
            				FROM   BUF_AMEND_PLAN_CELL_R A WITH(NOLOCK)
            				WHERE  A.JOB_SAVE_SEQ = @NEW_SEQ
            			)                  
              ) O
              ON 1=1
          		LEFT OUTER JOIN (
          			SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
          				 , B.OPERATION_ID
          				 , A.MARKET, A.PRODUCTION_TYPE , A.VERSION 
          			FROM (
          				SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
          					 , A.OPERATION_ID, A.LINE_ID
          					 , A.MARKET, A.PRODUCTION_TYPE, A.PLM_EC_NO, A.VERSION
          				FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK)
          				, (
          					SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
          					FROM   FP_INSTANCE_LINE_V A WITH(NOLOCK)
          					WHERE  A.INSTANCE_ID  = @MASTER_ID
          					AND    A.OPERATION_ID IN ('A3000','A9000')
          					GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID
          				) B
          				WHERE  1=1
          				AND    A.MFG_WEEK >= (SELECT (ISO_YYYYWW) FROM TH_UIS_CAL B WITH(NOLOCK) WHERE YYYYMMDD = CONVERT(VARCHAR,GETDATE(),112))
          				AND    A.OPERATION_ID IN ('A3000','A9000')
          				GROUP BY A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
          					   , A.OPERATION_ID, A.LINE_ID
          					   , A.MARKET, A.PRODUCTION_TYPE, A.PLM_EC_NO, A.VERSION
          			) A
          			LEFT OUTER JOIN (
          				SELECT A.OPERATION_ID
          				FROM   FP_INSTANCE_OPERATION_V A WITH(NOLOCK)
          				WHERE  A.INSTANCE_ID  = @MASTER_ID
          				AND    A.AMEND_FLAG   = 'Y'
          				GROUP BY A.OPERATION_ID
          			) B
          			ON  1=1
          		) P
          		ON  1=1
          		AND A.COMPANY_ID      = P.COMPANY_ID
          		AND A.DIVISION_ID     = P.DIVISION_ID
          		AND A.SITE_ID         = P.SITE_ID
          		AND A.PLANT_ID        = P.PLANT_ID
          		AND A.FACTORY_ID      = P.FACTORY_ID
          		AND A.OPERATION_ID    = P.OPERATION_ID
          		AND A.MARKET          = P.MARKET
          		AND A.PRODUCTION_TYPE = P.PRODUCTION_TYPE
          		AND A.VERSION         = P.VERSION
              LEFT OUTER JOIN (
						SELECT	DISTINCT R.COMPANY_ID, R.DIVISION_ID, R.SITE_ID, R.PLANT_ID, R.FACTORY_ID, R.OPERATION_ID, R.LINE_ID
						FROM	FP_USER_ROLE_INFO_V R WITH(NOLOCK)
						WHERE	1=1
						AND		R.USER_ID	= @USER_ID
						AND		R.SAVE_FLAG	= 'Y'
						AND		R.INSTANCE_ID = @MASTER_ID
				) R
				ON		1=1
				AND		A.COMPANY_ID		= R.COMPANY_ID
				AND		A.DIVISION_ID		= R.DIVISION_ID
				AND		A.SITE_ID			= R.SITE_ID
				AND		A.PLANT_ID			= R.PLANT_ID
				AND		A.FACTORY_ID		= R.FACTORY_ID
				AND		A.OPERATION_ID		= R.OPERATION_ID
				AND		A.LINE_ID			= R.LINE_ID
          ) TT
      ) A
      ORDER BY A.JOB_ORDER