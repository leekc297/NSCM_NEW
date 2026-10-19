SELECT 	A.*
						,CASE WHEN __MSG = ' Not Found' THEN (CASE WHEN MSG7 = '' THEN '' ELSE MSG7 END)
						      ELSE (CASE WHEN MSG7 = '' THEN __MSG ELSE __MSG + ' AND ' + MSG7 END)
						      END AS _MSG
						,CASE WHEN __MSG = ' Not Found' AND MSG7 = '' THEN 'Y' ELSE 'N' END AS _VALID
				FROM (
						SELECT 	A.* 
							  ,MSG1
							  +(CASE WHEN (MSG1 = '')                                                         THEN MSG2 ELSE (CASE WHEN MSG2 = '' THEN '' ELSE ',' + MSG2 END) END)
							  +(CASE WHEN (MSG1 = '' AND MSG2 = '')                                           THEN MSG3 ELSE (CASE WHEN MSG3 = '' THEN '' ELSE ',' + MSG3 END) END)
							  +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '')                             THEN MSG4 ELSE (CASE WHEN MSG4 = '' THEN '' ELSE ',' + MSG4 END) END)
							  +(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '')               THEN MSG5 ELSE (CASE WHEN MSG5 = '' THEN '' ELSE ',' + MSG5 END) END)
							  --+(CASE WHEN (MSG1 = '' AND MSG2 = '' AND MSG3 = '' AND MSG4 = '' AND MSG5 = '') THEN MSG6 ELSE (CASE WHEN MSG6 = '' THEN '' ELSE ',' + MSG6 END) END)
							  + ' Not Found' AS __MSG
						FROM (
								SELECT a.*
								    ,case when B.ITEM_ID is null then 'Material' else '' end as msg1
								    ,case when C.PLANT_ID is null then 'Plant' else '' end as msg2
								    ,case when D.DT is null then 'Ship Date' else '' end as msg3
								    ,case when ((D.ISO_YYYYWW is null OR D.ISO_YYYYWW<>A.SHIP_WEEK) and A.SHIP_WEEK<>'999999') then 'Ship Week' else '' end as msg4
								    ,case when E.SHOP_GROUP_ID is null then 'Shop Group' else '' end as msg5
								    --,case when F.PLANT_ID is null then 'To Site or To Plant' else '' end as msg6
											,CASE WHEN ROW_NUMBER() OVER(PARTITION BY A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.SHOP_GROUP_ID,A.SCP_PLAN_ID,A.SCP_TARGET_ID,A.FP_TARGET_ID
											                             ORDER BY     A.COMPANY_ID,A.DIVISION_ID,A.SITE_ID,A.PLANT_ID,A.SHOP_GROUP_ID,A.SCP_PLAN_ID,A.SCP_TARGET_ID,A.FP_TARGET_ID)>1 THEN 'Data Overlap'
											      ELSE '' end as msg7
								FROM   	BUF_WEEKLY_DEMAND_SHIPMENT_H A(NOLOCK)
										LEFT OUTER JOIN (
															SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.ITEM_ID
															FROM   SCM_ITEM_M A(NOLOCK), SCM_ITEM_CLASS_M B(NOLOCK)
															WHERE  A.ITEM_CLASS = B.CLASS_ID
															AND    A.ACTIVE_FLAG = 'Y'
															AND    B.USE_FLAG = 'Y'
														) B
										ON  A.COMPANY_ID  = B.COMPANY_ID
										AND A.DIVISION_ID = B.DIVISION_ID
										AND A.SITE_ID     = B.SITE_ID
										AND A.ITEM_ID     = B.ITEM_ID
										LEFT OUTER JOIN SCM_PLANT_M C(NOLOCK)
										ON  A.COMPANY_ID  = C.COMPANY_ID
										AND A.DIVISION_ID = C.DIVISION_ID
										AND A.SITE_ID     = C.SITE_ID
										AND A.PLANT_ID    = C.PLANT_ID
										LEFT OUTER JOIN TH_UIS_CAL D(NOLOCK)
										ON  CONVERT(VARCHAR(8), A.SHIP_DATE, 112) = D.DT
										LEFT OUTER JOIN (
															SELECT COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
															FROM   SCM_FACTORY_M(NOLOCK)
															WHERE 1=1
															AND   ACTIVE_FLAG = 'Y'
															GROUP BY COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, SHOP_GROUP_ID
														) E
										ON  A.COMPANY_ID    = E.COMPANY_ID
										AND A.DIVISION_ID   = E.DIVISION_ID
										AND A.SITE_ID       = E.SITE_ID
										AND A.PLANT_ID      = E.PLANT_ID
										AND A.SHOP_GROUP_ID = E.SHOP_GROUP_ID
										/*
										LEFT OUTER JOIN (
										SELECT DISTINCT SITE_ID, PLANT_ID
										FROM   SCM_PLANT_M(NOLOCK)
										) F
										ON  A.TO_SITE_ID    = F.SITE_ID
										AND A.TO_PLANT_ID   = F.PLANT_ID
										*/
								WHERE A.JOB_USER_ID = @USER_ID
							) A
						) A
				ORDER BY A.JOB_ORDER