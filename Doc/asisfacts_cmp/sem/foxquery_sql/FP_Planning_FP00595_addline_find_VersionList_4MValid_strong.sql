SELECT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID 
      	 , A.LINE_ID, D.LINE_NAME , A.ELECTRODE_TYPE 
      	 , B.MODEL_ID, C.NICK_NAME 
      	 , B.VERSION_TYPE, B.VERSION 
      	 , A.OPERATION_ID, A.ITEM_ID 
      	 , ISNULL(E.ACTIVE_FLAG, 'Y') AS ACTIVE_FLAG 
      	 , B.PROD_VERSION_TYPE, B.MAX_VER_FLAG, E.DESCRIPTION 
         , ISNULL(E.UPDATE_ID, '') AS UPDATE_ID, ISNULL(CONVERT(VARCHAR,E.UPDATE_TIME,20), '') AS UPDATE_TIME 
         , B.PROD_SEQ
      FROM ( 
      	SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.ITEM_ID, A.LINE_ID, A.ELECTRODE_TYPE 
      	FROM   SCM_ITEM_LINE_ASSIGN_M A WITH(NOLOCK) 
      	WHERE  1=1 
      	AND    A.OPERATION_ID = 'E2000' 
      	AND    A.MONTH = CONVERT(VARCHAR(6), GETDATE(), 112) 
      	AND    A.ACTIVE_FLAG = 'Y' 
      	AND    A.PRIORITY IN (1,2,3,4,5,6,7,8) 
      	AND    A.FACTORY_ID = @FACTORY_ID
      	AND    A.LINE_ID = @LINE_ID
      	AND    A.ITEM_ID = @ITEM_ID
      ) A 
      INNER JOIN ( 
      	            SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION AS OPERATION_ID 
      		                , A.MODEL_ID, A.ITEM_ID, A.VERSION, A.PROD_VERSION_TYPE, A.MAX_VER_FLAG, A.VERSION_TYPE, A.PROD_SEQ
      	            FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) 
      	            WHERE 1= (	-- PDS Target 기준 Prod Type 일 경우 PDS Target 의 Version 을 본다.
									                    SELECT	ISNULL( CASE WHEN COUNT(1) > 0 THEN 0 ELSE 1 END, 1) AS IS_PDS
									                    FROM	FP_INSTANCE_INFO_V IV WITH(NOLOCK)
										                      , SCM_SYS_LOOKUP_VALUE SV WITH(NOLOCK)
									                    WHERE	1=1
									                    AND		SV.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
									                    AND		SV.ACTIVE_FLAG = 'Y'
									                    AND		SV.SEGMENT1 = IV.INSTANCE_ID
									                    AND		IV.INSTANCE_ID = @INSTANCE_ID
									                    AND		EXISTS (
														                          SELECT *
														                          FROM   SCM_SYS_LOOKUP_VALUE SS WITH(NOLOCK)
														                          WHERE 1=1
														                          AND SS.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
														                          AND SS.ACTIVE_FLAG = 'Y'
														                          AND SS.ATTRIBUTE3 = 'N' -- SCP TARGET FLAG
														                          AND SS.ATTRIBUTE5 = 'Y' -- PDA TARGET FLAG
														                          --AND SV.ATTRIBUTE6 = 'Y' -- VERSION ONLY
														                          AND IV.DIVISION_ID =  SS.SEGMENT1
														                          AND SS.SEGMENT2 = @PRODUCTION_TYPE
													                        )
								                  )
      	            AND   A.OPERATION = 'E2000' 
      	            AND   A.CATEGORY IN ( 'cell/batch', 'Jumbo Roll (cell/m)', 'Jumbo Roll (m/batch)', 'Lane Number', 'Pancake (cell/m)', 'Pancake (m/batch)' )
      	            AND   A.FACTORY_ID = @FACTORY_ID
      	            AND   A.ITEM_ID = @ITEM_ID
      	            -- 4M-VALID 강제 처리
      	            AND (
				                 (@PRODUCTION_TYPE = '4M-VALID' AND A.VERSION_TYPE = '4M')
      	              OR (A.VERSION_TYPE IN ('MASS','TEST'))
      	            )
                    UNION ALL
                          SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION AS OPERATION_ID 
      		                      , A.MODEL_ID, A.ITEM_ID, A.VERSION, A.PROD_VERSION_TYPE, A.MAX_VER_FLAG, A.VERSION_TYPE, A.PROD_SEQ
      	                  FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK) 
        	                WHERE 1= (	-- PDS Target 기준 Prod Type 일 경우 PDS Target 의 Version 을 본다.
									                    SELECT	ISNULL( CASE WHEN COUNT(1) > 0 THEN 1 ELSE 0 END, 0) AS IS_PDS
									                    FROM	FP_INSTANCE_INFO_V IV WITH(NOLOCK)
										                      , SCM_SYS_LOOKUP_VALUE SV WITH(NOLOCK)
									                    WHERE	1=1
									                    AND		SV.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
									                    AND		SV.ACTIVE_FLAG = 'Y'
									                    AND		SV.SEGMENT1 = IV.INSTANCE_ID
									                    AND		IV.INSTANCE_ID = @INSTANCE_ID
									                    AND		EXISTS (
														                          SELECT *
														                          FROM   SCM_SYS_LOOKUP_VALUE SS WITH(NOLOCK)
														                          WHERE 1=1
														                          AND SS.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
														                          AND SS.ACTIVE_FLAG = 'Y'
														                          AND SS.ATTRIBUTE3 = 'N' -- SCP TARGET FLAG
														                          AND SS.ATTRIBUTE5 = 'Y' -- PDA TARGET FLAG
														                          --AND SV.ATTRIBUTE6 = 'Y' -- VERSION ONLY
														                          AND IV.DIVISION_ID =  SS.SEGMENT1
														                          AND SS.SEGMENT2 = @PRODUCTION_TYPE
													                        )
								                    )
        	                AND   A.OPERATION = 'E2000' 
      	                  AND   A.CATEGORY IN ( 'cell/batch', 'Jumbo Roll (cell/m)', 'Jumbo Roll (m/batch)', 'Lane Number', 'Pancake (cell/m)', 'Pancake (m/batch)' )
      	                  AND   A.FACTORY_ID = @FACTORY_ID
      	                  AND   A.ITEM_ID = @ITEM_ID
      	                  -- 4M-VALID 강제 처리
      	                  AND (
				                       (@PRODUCTION_TYPE = '4M-VALID' AND A.VERSION_TYPE = '4M')
      	                    OR (A.VERSION_TYPE IN ('MASS','TEST'))
      	                  )
                          AND EXISTS (
										                    SELECT	1
										                    FROM	(
												                          SELECT	DISTINCT WP.COMPANY_ID, WP.DIVISION_ID, WP.SITE_ID, WP.PLANT_ID, WP.ITEM_ID, WP.VERSION, WP.MODEL
												                          FROM		FP_WEEKLY_DEMAND_PRODUCT_PDS_H WP WITH(NOLOCK)
															                        INNER JOIN (
																			                              SELECT	IV.COMPANY_ID, IV.DIVISION_ID, IV.SITE_ID, IV.PLANT_ID
																			                              FROM	FP_INSTANCE_INFO_V IV WITH(NOLOCK)
																				                                , SCM_SYS_LOOKUP_VALUE SV WITH(NOLOCK)
																			                              WHERE	1=1
																			                              AND		SV.LOOKUP_TYPE_CODE = 'PDS_INSTANCE'
																			                              AND		SV.ACTIVE_FLAG = 'Y'
																			                              AND		SV.SEGMENT1 = IV.INSTANCE_ID
																			                              AND		IV.INSTANCE_ID = @INSTANCE_ID
																		                            ) IV
															                        ON 1=1
															                        AND IV.COMPANY_ID	= WP.COMPANY_ID
															                        AND IV.DIVISION_ID	= WP.DIVISION_ID 
															                        AND IV.SITE_ID 		= WP.SITE_ID 
															                        AND IV.PLANT_ID		= WP.PLANT_ID
												                    ) X
										                    WHERE 1=1
										                    AND X.COMPANY_ID	= A.COMPANY_ID
										                    AND X.DIVISION_ID	= A.DIVISION_ID 
										                    AND X.SITE_ID 		= A.SITE_ID 
										                    AND X.PLANT_ID		= A.PLANT_ID
										                    AND X.ITEM_ID		  = A.ITEM_ID
                                        AND X.VERSION		  = A.VERSION
									                  ) 
/*
		AND 
		(
	
			--@PRODUCTION_TYPE 
		(
			not exists (
					SELECT DISTINCT M.SEGMENT1 AS DIVISION_ID
					, M.SEGMENT2 AS PRODUCTION_TYPE
					,M.ATTRIBUTE2 AS FP_PRODUCTION_TYPE
					, (CASE WHEN M.ATTRIBUTE5 IS NULL OR M.ATTRIBUTE5 = '' THEN 'N' ELSE M.ATTRIBUTE5 END) AS _4MCC_TARGET_FLAG
					FROM   SCM_SYS_LOOKUP_VALUE M WITH(NOLOCK)
						WHERE  M.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
						AND ISNULL(M.SEGMENT1,'') =  @DIVISION_ID
						--AND ISNULL(M.ATTRIBUTE2,'') = '4M-VALID'
						AND ISNULL(M.ATTRIBUTE5,'') = 'Y'
						AND ISNULL(M.ATTRIBUTE2,'') = @PRODUCTION_TYPE
				) 
			AND A.VERSION_TYPE  <> '4M'
		)
or
		(
			exists (
					SELECT DISTINCT M.SEGMENT1 AS DIVISION_ID
					, M.SEGMENT2 AS PRODUCTION_TYPE
					,M.ATTRIBUTE2 AS FP_PRODUCTION_TYPE
					, (CASE WHEN M.ATTRIBUTE5 IS NULL OR M.ATTRIBUTE5 = '' THEN 'N' ELSE M.ATTRIBUTE5 END) AS _4MCC_TARGET_FLAG
					FROM   SCM_SYS_LOOKUP_VALUE M WITH(NOLOCK)
						WHERE  M.LOOKUP_TYPE_CODE = 'DIVISION_DEMAND_TYPE'
						AND ISNULL(M.SEGMENT1,'') =  @DIVISION_ID
						--AND ISNULL(M.ATTRIBUTE2,'') = '4M-VALID'
						AND ISNULL(M.ATTRIBUTE5,'') = 'Y'
						AND ISNULL(M.ATTRIBUTE2,'') = @PRODUCTION_TYPE
				) 
			AND A.VERSION_TYPE  = '4M'
		)
    		and exists
		(
		SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.OPERATION_ID, A.LINE_ID, A.ITEM_ID, A.PRODUCTION_TYPE, A.MARKET, A.VERSION
--, A.DUE_DATE
FROM   FP_WEEKLY_DEMAND_PRODUCT_PDS_H A WITH(NOLOCK) 
WHERE  1=1
AND    A.FACTORY_ID      = @FACTORY_ID
AND    A.OPERATION_ID    = @OPERATION_ID
AND    A.LINE_ID         = @LINE_ID
AND    A.ITEM_ID         = @ITEM_ID
AND    A.PRODUCTION_TYPE = @PRODUCTION_TYPE
AND    A.MARKET          = @MARKET
		)

	    
			--(@PRODUCTION_TYPE <> '4M-VALID' AND A.VERSION_TYPE <>  '4M')
			--or
			--(@PRODUCTION_TYPE = '4M-VALID' AND A.VERSION_TYPE =  '4M')
		)  
*/
      ) B 
      ON  1=1 
      AND A.COMPANY_ID   = B.COMPANY_ID 
      AND A.DIVISION_ID  = B.DIVISION_ID 
      AND A.SITE_ID      = B.SITE_ID 
      AND A.PLANT_ID     = B.PLANT_ID 
      AND A.FACTORY_ID   = B.FACTORY_ID 
      AND A.OPERATION_ID = B.OPERATION_ID 
      AND A.ITEM_ID      = B.ITEM_ID 
      LEFT OUTER JOIN SCM_ITEM_M C WITH(NOLOCK) 
      ON  1=1 
      AND B.COMPANY_ID   = C.COMPANY_ID 
      AND B.DIVISION_ID  = C.DIVISION_ID 
      AND B.SITE_ID      = C.SITE_ID 
      AND B.MODEL_ID     = C.ITEM_ID 
      INNER JOIN SCM_LINE_M D WITH(NOLOCK) 
      ON  1=1 
      AND A.COMPANY_ID        = D.COMPANY_ID 
      AND A.DIVISION_ID       = D.DIVISION_ID 
      AND A.SITE_ID           = D.SITE_ID 
      AND A.PLANT_ID          = D.PLANT_ID 
      AND A.FACTORY_ID        = D.FACTORY_ID 
      AND A.OPERATION_ID      = D.OPERATION_ID 
      AND A.LINE_ID           = D.LINE_ID 
      AND A.ELECTRODE_TYPE    = D.ELECTRODE_TYPE 
      AND B.PROD_VERSION_TYPE = D.PROD_VERSION_TYPE 
      LEFT OUTER JOIN SCM_ITEM_CONV_CALC_USE_M E WITH(NOLOCK) 
      ON  1=1 
      AND A.FACTORY_ID     = E.FACTORY_ID 
      AND B.MODEL_ID       = E.MODEL_ID 
      AND A.ITEM_ID        = E.ITEM_ID 
      AND A.LINE_ID        = E.LINE_ID 
      AND A.ELECTRODE_TYPE = E.ELECTRODE_TYPE 
      AND B.VERSION        = E.VERSION 
      WHERE 1=1 
      AND   D.PROD_VERSION_TYPE = @PROD_VERSION_TYPE
      ORDER BY DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID, OPERATION_ID
             , (CASE WHEN @PRODUCTION_TYPE LIKE '%TEST%' THEN (CASE WHEN B.VERSION_TYPE = 'TEST' THEN 1 ELSE 9999 END) ELSE (CASE WHEN B.VERSION_TYPE = 'TEST' THEN 9999 ELSE 1 END) END)
             , MODEL_ID, ITEM_ID, LINE_ID, VERSION DESC