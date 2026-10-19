BEGIN
						
							MERGE INTO FP_AMEND_PLAN_PACK_R AS A
							USING ( SELECT BB.INSTANCE_ID, BB.FP_PLAN_ID
							             , (SELECT MAX(KK.COMPANY_ID) FROM SCM_FACTORY_M KK WHERE BB.FACTORY_ID = KK.FACTORY_ID) AS COMPANY_ID, BB.DIVISION_ID, 'PLAN' AS CATEGORY_ID
							             , BB.SITE_ID, BB.PLANT_ID, BB.ITEM_ID, BB.OPERATION_ID
							             , BB.FACTORY_ID, BB.LOCATION
							             , BB.PRODUCTION_TYPE, BB.MARKET
							             , BB.LINE_ID, BB.ELECTRODE_TYPE
							             , BB.PLAN_DATE, BB.TOP_ITEM_ID
							             , ISNULL(CC.ITEM_TYPE,'-') AS ITEM_TYPE, BB.CELL_OUT_QTY, BB.OUT_QTY AS QTY, BB.DATE_SEQ AS SEQ
							        FROM   BUF_AMEND_PLAN_PACK_R BB WITH(NOLOCK)
							        LEFT OUTER JOIN (
							            SELECT DISTINCT A.COMPANY_ID, A.DIVISION_ID, A.SITE_ID,
							                   A.ITEM_ID,
							                   (CASE WHEN LEFT(A.FLOW_ID,5) = 'A9000' AND ISNULL(C.LEVEL_4_NAME, '-') = '-' THEN C.LEVEL_3_NAME
							                   	     WHEN LEFT(A.FLOW_ID,5) = 'A9000' THEN ISNULL(C.LEVEL_4_NAME, '-')
							                   	     ELSE C.LEVEL_3_NAME END) AS ITEM_TYPE,
							                   ISNULL(A.NICK_NAME,'-') AS NICK_NAME
							            FROM	 SCM_ITEM_M A WITH(NOLOCK),
							              		 SCM_ITEM_CLASS_M C WITH(NOLOCK)
							            WHERE	 A.ITEM_CLASS  = C.CLASS_ID
							        ) CC
							        ON  (SELECT MAX(KK.COMPANY_ID) FROM SCM_FACTORY_M KK WHERE BB.FACTORY_ID = KK.FACTORY_ID) = CC.COMPANY_ID
							        AND BB.DIVISION_ID    = CC.DIVISION_ID
							        AND BB.SITE_ID        = CC.SITE_ID
							        AND BB.ITEM_ID        = CC.ITEM_ID
							        WHERE BB.JOB_SAVE_SEQ = @NEW_SEQ
								    ) AS B
							      	ON  A.INSTANCE_ID     = B.INSTANCE_ID
							        AND A.FP_PLAN_ID      = B.FP_PLAN_ID
							        AND A.COMPANY_ID      = B.COMPANY_ID
							        AND A.DIVISION_ID     = B.DIVISION_ID
							        AND A.CATEGORY_ID     = B.CATEGORY_ID
							        AND A.SITE_ID         = B.SITE_ID
							        AND A.PLANT_ID        = B.PLANT_ID
							        AND A.ITEM_ID         = B.ITEM_ID
							        AND A.OPERATION_ID    = B.OPERATION_ID
							        AND A.FACTORY_ID      = B.FACTORY_ID
							        AND A.LOCATION        = B.LOCATION
							        AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
							        AND A.MARKET          = B.MARKET
							        AND A.LINE_ID         = B.LINE_ID
							        AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
							        AND A.PLAN_DATE       = B.PLAN_DATE
							        AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID
							        WHEN MATCHED THEN
							      		UPDATE SET OUT_QTY = B.QTY, IN_QTY = FLOOR(B.QTY / (SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
							                                                                FROM   SCM_YIELD_M YYY WITH(NOLOCK)
							                                                                LEFT OUTER JOIN (
							                                                                    SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
							                                                                    FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
							                                                                    WHERE  EE.DIVISION_ID  = B.DIVISION_ID
							                                                                    AND    EE.SITE_ID      = B.SITE_ID
							                                                                    AND    EE.PLANT_ID     = B.PLANT_ID
							                                                                    AND    EE.FACTORY_ID   = B.FACTORY_ID
							                                                                    AND    EE.OPERATION_ID = B.OPERATION_ID
							                                                                    AND    EE.LINE_ID      = B.LINE_ID
							                                                                    AND    EE.ITEM_ID      = B.ITEM_ID
							                                                                    AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
							                                                                ) EEE
							                                                                ON     1=1
							                                                                WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
							                                                                AND    YYY.SITE_ID      = B.SITE_ID
							                                                                AND    YYY.PLANT_ID     = B.PLANT_ID
							                                                                AND    YYY.FACTORY_ID   = B.FACTORY_ID
							                                                                AND    YYY.OPERATION_ID = B.OPERATION_ID
							                                                                AND    YYY.LINE_ID      = B.LINE_ID
							                                                                AND    YYY.ITEM_ID      = B.ITEM_ID
							                                                                AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
							                   , CELL_OUT_QTY = B.CELL_OUT_QTY, CELL_IN_QTY = FLOOR(B.CELL_OUT_QTY / (SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
														                                                                FROM   SCM_YIELD_M YYY WITH(NOLOCK)
														                                                                LEFT OUTER JOIN (
														                                                                    SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
														                                                                    FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
														                                                                    WHERE  EE.DIVISION_ID  = B.DIVISION_ID
														                                                                    AND    EE.SITE_ID      = B.SITE_ID
														                                                                    AND    EE.PLANT_ID     = B.PLANT_ID
														                                                                    AND    EE.FACTORY_ID   = B.FACTORY_ID
														                                                                    AND    EE.OPERATION_ID = B.OPERATION_ID
														                                                                    AND    EE.LINE_ID      = B.LINE_ID
														                                                                    AND    EE.ITEM_ID      = B.ITEM_ID
														                                                                    AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
														                                                                ) EEE
														                                                                ON     1=1
														                                                                WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
														                                                                AND    YYY.SITE_ID      = B.SITE_ID
														                                                                AND    YYY.PLANT_ID     = B.PLANT_ID
														                                                                AND    YYY.FACTORY_ID   = B.FACTORY_ID
														                                                                AND    YYY.OPERATION_ID = B.OPERATION_ID
														                                                                AND    YYY.LINE_ID      = B.LINE_ID
														                                                                AND    YYY.ITEM_ID      = B.ITEM_ID
														                                                                AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
							                   , DATE_SEQ = CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(B.QTY,0)) = 0 THEN 0 ELSE B.SEQ END
							    		           , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)
											   , PRODUCTION_TYPE = B.PRODUCTION_TYPE    		           
						      	WHEN NOT MATCHED BY TARGET THEN
						      		INSERT (
						               INSTANCE_ID, FP_PLAN_ID
						              ,COMPANY_ID
						              ,DIVISION_ID
						              ,CATEGORY_ID
						              ,SITE_ID, PLANT_ID
						              ,ITEM_ID, OPERATION_ID, FACTORY_ID, LOCATION
						              ,PRODUCTION_TYPE, MARKET
						              ,LINE_ID, ELECTRODE_TYPE
						              ,PLAN_DATE
						              ,TOP_ITEM_ID, ITEM_TYPE
						              ,IN_QTY
						              ,OUT_QTY
						              ,CELL_IN_QTY
						              ,CELL_OUT_QTY
						              ,DATE_SEQ
						              ,INSERT_ID, INSERT_TIME
						              ,UPDATE_ID, UPDATE_TIME
						      		)
						      		VALUES (
						               B.INSTANCE_ID, B.FP_PLAN_ID
						              ,B.COMPANY_ID
						              ,B.DIVISION_ID
						              ,B.CATEGORY_ID
						              ,B.SITE_ID, B.PLANT_ID
						              ,B.ITEM_ID, B.OPERATION_ID, B.FACTORY_ID, B.LOCATION
						              ,B.PRODUCTION_TYPE, B.MARKET
						              ,B.LINE_ID, B.ELECTRODE_TYPE
						              ,B.PLAN_DATE
						              ,B.TOP_ITEM_ID, B.ITEM_TYPE
						              ,FLOOR(B.QTY / (SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
						                                FROM   SCM_YIELD_M YYY WITH(NOLOCK)
						                                LEFT OUTER JOIN (
						                                    SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
						                                    FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
						                                    WHERE  EE.DIVISION_ID  = B.DIVISION_ID
						                                    AND    EE.SITE_ID      = B.SITE_ID
						                                    AND    EE.PLANT_ID     = B.PLANT_ID
						                                    AND    EE.FACTORY_ID   = B.FACTORY_ID
						                                    AND    EE.OPERATION_ID = B.OPERATION_ID
						                                    AND    EE.LINE_ID      = B.LINE_ID
						                                    AND    EE.ITEM_ID      = B.ITEM_ID
						                                    AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
						                                ) EEE
						                                ON     1=1
						                                WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
						                                AND    YYY.SITE_ID      = B.SITE_ID
						                                AND    YYY.PLANT_ID     = B.PLANT_ID
						                                AND    YYY.FACTORY_ID   = B.FACTORY_ID
						                                AND    YYY.OPERATION_ID = B.OPERATION_ID
						                                AND    YYY.LINE_ID      = B.LINE_ID
						                                AND    YYY.ITEM_ID      = B.ITEM_ID
						                                AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
						              ,B.QTY
						              ,FLOOR(B.CELL_OUT_QTY / (SELECT ISNULL( ISNULL(MAX(EEE.YIELD),(CASE WHEN MAX(YYY.YIELD) = 0 THEN 1 ELSE MAX(YYY.YIELD) END)) ,1) AS YIELD
								                                FROM   SCM_YIELD_M YYY WITH(NOLOCK)
								                                LEFT OUTER JOIN (
								                                    SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
								                                    FROM   SCM_YIELD_EXCEPT_M EE WITH(NOLOCK)
								                                    WHERE  EE.DIVISION_ID  = B.DIVISION_ID
								                                    AND    EE.SITE_ID      = B.SITE_ID
								                                    AND    EE.PLANT_ID     = B.PLANT_ID
								                                    AND    EE.FACTORY_ID   = B.FACTORY_ID
								                                    AND    EE.OPERATION_ID = B.OPERATION_ID
								                                    AND    EE.LINE_ID      = B.LINE_ID
								                                    AND    EE.ITEM_ID      = B.ITEM_ID
								                                    AND    B.PLAN_DATE BETWEEN EE.START_TIME AND EE.END_TIME
								                                ) EEE
								                                ON     1=1
									                                WHERE  YYY.DIVISION_ID  = B.DIVISION_ID
									                                AND    YYY.SITE_ID      = B.SITE_ID
									                                AND    YYY.PLANT_ID     = B.PLANT_ID
									                                AND    YYY.FACTORY_ID   = B.FACTORY_ID
									                                AND    YYY.OPERATION_ID = B.OPERATION_ID
									                                AND    YYY.LINE_ID      = B.LINE_ID
									                                AND    YYY.ITEM_ID      = B.ITEM_ID
									                                AND    YYY.MONTH        = SUBSTRING((CONVERT(VARCHAR,B.PLAN_DATE,112)),1,6)))
									              ,B.CELL_OUT_QTY 
									              ,CASE WHEN CONVERT(NUMERIC(25,10),ISNULL(B.QTY,0)) = 0 THEN 0 ELSE B.SEQ END
									              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
									              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
									      		)
									          ;
									      	  
					        INSERT INTO HIS_AMEND_PLAN_PACK_R (
					               INSTANCE_ID, FP_PLAN_ID
					              ,COMPANY_ID, DIVISION_ID
					              ,CATEGORY_ID
					              ,SITE_ID, PLANT_ID,ITEM_ID, OPERATION_ID, FACTORY_ID
					              ,LOCATION, PRODUCTION_TYPE, MARKET
					              ,LINE_ID, ELECTRODE_TYPE
					              ,TOP_ITEM_ID, ITEM_TYPE
					              ,PLAN_DATE
					              ,CELL_IN_QTY
					              ,CELL_OUT_QTY
					              ,IN_QTY
					              ,OUT_QTY
					              ,DATE_SEQ
					              ,INSERT_ID, INSERT_TIME
					              ,UPDATE_ID, UPDATE_TIME
					              ,JOB_USER_ID, JOB_TIME,JOB_TYPE
					        )
					        SELECT A.INSTANCE_ID, A.FP_PLAN_ID
					              ,(SELECT MAX(KK.COMPANY_ID) FROM SCM_FACTORY_M KK WHERE A.FACTORY_ID = KK.FACTORY_ID) AS COMPANY_ID, A.DIVISION_ID
					              ,'PLAN' AS CATEGORY_ID
					              ,A.SITE_ID, A.PLANT_ID, A.ITEM_ID, A.OPERATION_ID, A.FACTORY_ID
					              ,A.LOCATION, A.PRODUCTION_TYPE, A.MARKET
					              ,A.LINE_ID, A.ELECTRODE_TYPE
					              ,A.TOP_ITEM_ID, A.ITEM_TYPE
					              ,A.PLAN_DATE
					              ,A.CELL_IN_QTY
					              ,A.CELL_OUT_QTY
					              ,A.IN_QTY
					              ,A.OUT_QTY
					              ,A.DATE_SEQ
					              ,@USER_ID AS INSERT_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME
					              ,@USER_ID AS UPDATE_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME
					              ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'EXCEL2' AS JOB_TYPE
						    FROM   BUF_AMEND_PLAN_PACK_R A WITH(NOLOCK)
        					WHERE  JOB_SAVE_SEQ = @NEW_SEQ
      						;
      	
      				END;