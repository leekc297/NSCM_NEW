BEGIN
		      	MERGE INTO FP_AMEND_DAILY_PLAN_H AS A
		      	USING (
		            SELECT BB.INSTANCE_ID, BB.FP_PLAN_ID
		                 , BB.COMPANY_ID, BB.DIVISION_ID, BB.SITE_ID, BB.PLANT_ID, BB.FACTORY_ID, ISNULL(CC.LOCATION,'-') AS LOCATION
		                 , BB.OPERATION_ID, BB.LINE_ID, CC.ELECTRODE_TYPE, BB.EQUIPMENT_ID
		                 , BB.ITEM_ID AS TOP_ITEM_ID, BB.ITEM_ID
		                 , UPPER(BB.PRODUCTION_TYPE) AS PRODUCTION_TYPE, BB.MARKET
		                 , BB.PLAN_DATE
		                 , ROUND(BB.ADJUST_IN_QTY_BATCH,@ROUND_POINT) AS ADJUST_IN_QTY_BATCH
		                 , BB.ADJUST_IN_QTY_M AS ADJUST_IN_QTY_M
		                 , BB.ADJUST_IN_QTY_CELL AS ADJUST_IN_QTY_CELL
		                 , BB.ADJUST_IN_QTY_JR AS ADJUST_IN_QTY_JR
		                 , ROUND(BB.ADJUST_OUT_QTY_BATCH,@ROUND_POINT) AS ADJUST_OUT_QTY_BATCH
		                 , BB.ADJUST_OUT_QTY_M AS ADJUST_OUT_QTY_M
		                 , BB.ADJUST_OUT_QTY_CELL AS ADJUST_OUT_QTY_CELL
		                 , BB.ADJUST_OUT_QTY_JR AS ADJUST_OUT_QTY_JR
		                 , BB.SEQ
		                 , BB.WORK_REQUEST_MODEL_ID, BB.VERSION, DD.PROD_SEQ, (case when BB.PLM_EC_NO is null or BB.PLM_EC_NO = '' then '-' else BB.PLM_EC_NO end) as PLM_EC_NO
		            FROM   BUF_AMEND_DAILY_PLAN_R BB WITH(NOLOCK)
		            INNER JOIN SCM_LINE_M CC WITH(NOLOCK)
		            ON     BB.DIVISION_ID     = CC.DIVISION_ID
		            AND    BB.SITE_ID         = CC.SITE_ID
		            AND    BB.PLANT_ID        = CC.PLANT_ID
		            AND    BB.FACTORY_ID      = CC.FACTORY_ID
		            AND    BB.OPERATION_ID    = CC.OPERATION_ID
		            AND    BB.LINE_ID         = CC.LINE_ID
		            AND    BB.ELECTRODE_TYPE  = CC.ELECTRODE_TYPE
		            AND    CC.ACTIVE_FLAG     = 'Y'
		            INNER JOIN (
    	            	SELECT FACTORY_ID, MODEL_ID, ITEM_ID, OPERATION AS OPERATION_ID, VERSION, MAX(PROD_SEQ) AS PROD_SEQ
    	            	FROM   SCM_ITEM_CONV_CALC_M A WITH(NOLOCK)
    	            	WHERE  1=1
    	            	AND    A.OPERATION = 'E2000'
    	            	AND    A.CATEGORY IN ( 'JUMBO ROLL (CELL/M)', 'LANE NUMBER', 'PANCAKE (M/BATCH)', 'CELL/BATCH', 'JUMBO ROLL (M/BATCH)', 'PANCAKE (CELL/M)' )
    	            	GROUP BY FACTORY_ID, MODEL_ID, ITEM_ID, OPERATION, VERSION
		            ) DD
		            ON  BB.FACTORY_ID            = DD.FACTORY_ID
		            AND BB.WORK_REQUEST_MODEL_ID = DD.MODEL_ID
		            AND BB.ITEM_ID               = DD.ITEM_ID
		            AND BB.OPERATION_ID          = DD.OPERATION_ID
		            AND BB.VERSION               = DD.VERSION
		            WHERE  BB.JOB_USER_ID     = @USER_ID
		            AND		 BB.INSTANCE_ID			= @INSTANCE_ID
		      	) AS B
		      	ON  A.INSTANCE_ID     = B.INSTANCE_ID
		        AND A.FP_PLAN_ID      = B.FP_PLAN_ID
		        AND A.FACTORY_ID      = B.FACTORY_ID
		        AND A.LOCATION        = B.LOCATION
		        AND A.OPERATION_ID    = B.OPERATION_ID
		        AND A.LINE_ID         = B.LINE_ID
		        AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
		        AND A.EQUIPMENT_ID    = B.EQUIPMENT_ID
		        AND A.PLAN_DATE       = B.PLAN_DATE
		        AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID
		        AND A.ITEM_ID         = B.ITEM_ID
		        AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
		        AND A.MARKET          = B.MARKET
		        AND A.WORK_REQUEST_MODEL_ID = B.WORK_REQUEST_MODEL_ID
		        AND A.VERSION               = B.VERSION
		        AND A.PLM_EC_NO             = B.PLM_EC_NO
		        WHEN MATCHED THEN
		      		UPDATE SET 	  @IN_QTY_BATCH 	= B.ADJUST_IN_QTY_BATCH
      						       	, @IN_QTY_M 		= B.ADJUST_IN_QTY_M
			                    , @IN_QTY_CELL 	= B.ADJUST_IN_QTY_CELL
			                    , @IN_QTY_JR 		= B.ADJUST_IN_QTY_JR
			                    , @OUT_QTY_BATCH 	= B.ADJUST_IN_QTY_BATCH
			                    , @OUT_QTY_M = CEILING(B.ADJUST_IN_QTY_M * (	  SELECT ISNULL( ISNULL(MAX(SB.YIELD),(CASE WHEN MAX(SA.YIELD) = 0 THEN 1 ELSE MAX(SA.YIELD) END)) ,1) AS YIELD
						                                                      FROM   SCM_YIELD_M SA WITH(NOLOCK)
							                                                  LEFT OUTER JOIN (
							                                                      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
							                                                      FROM   SCM_YIELD_EXCEPT_M AA WITH(NOLOCK)
							                                                      WHERE  AA.DIVISION_ID  = B.DIVISION_ID
							                                                      AND    AA.SITE_ID      = B.SITE_ID
							                                                      AND    AA.PLANT_ID     = B.PLANT_ID
							                                                      AND    AA.FACTORY_ID   = B.FACTORY_ID
							                                                      AND    AA.OPERATION_ID = B.OPERATION_ID
							                                                      AND    AA.LINE_ID      = B.LINE_ID
							                                                      AND    AA.ITEM_ID      = B.ITEM_ID
							                                                      AND    B.PLAN_DATE BETWEEN AA.START_TIME AND AA.END_TIME
							                                                  ) SB
							                                                  ON     1=1
							                                                  WHERE  SA.DIVISION_ID  = B.DIVISION_ID
							                                                  AND    SA.SITE_ID      = B.SITE_ID
							                                                  AND    SA.PLANT_ID     = B.PLANT_ID
							                                                  AND    SA.FACTORY_ID   = B.FACTORY_ID
							                                                  AND    SA.OPERATION_ID = B.OPERATION_ID
							                                                  AND    SA.LINE_ID      = B.LINE_ID
							                                                  AND    SA.ITEM_ID      = B.ITEM_ID
							                                                  AND    SA.MONTH        = SUBSTRING(CONVERT(VARCHAR,B.PLAN_DATE,112),1,6)))
					  	, @OUT_QTY_CELL = CEILING(B.ADJUST_IN_QTY_CELL * (	  SELECT ISNULL( ISNULL(MAX(SB.YIELD),(CASE WHEN MAX(SA.YIELD) = 0 THEN 1 ELSE MAX(SA.YIELD) END)) ,1) AS YIELD
						                                                      FROM   SCM_YIELD_M SA WITH(NOLOCK)
							                                                  LEFT OUTER JOIN (
							                                                      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
							                                                      FROM   SCM_YIELD_EXCEPT_M AA WITH(NOLOCK)
							                                                      WHERE  AA.DIVISION_ID  = B.DIVISION_ID
							                                                      AND    AA.SITE_ID      = B.SITE_ID
							                                                      AND    AA.PLANT_ID     = B.PLANT_ID
							                                                      AND    AA.FACTORY_ID   = B.FACTORY_ID
							                                                      AND    AA.OPERATION_ID = B.OPERATION_ID
							                                                      AND    AA.LINE_ID      = B.LINE_ID
							                                                      AND    AA.ITEM_ID      = B.ITEM_ID
							                                                      AND    B.PLAN_DATE BETWEEN AA.START_TIME AND AA.END_TIME
							                                                  ) SB
							                                                  ON     1=1
							                                                  WHERE  SA.DIVISION_ID  = B.DIVISION_ID
							                                                  AND    SA.SITE_ID      = B.SITE_ID
							                                                  AND    SA.PLANT_ID     = B.PLANT_ID
							                                                  AND    SA.FACTORY_ID   = B.FACTORY_ID
							                                                  AND    SA.OPERATION_ID = B.OPERATION_ID
							                                                  AND    SA.LINE_ID      = B.LINE_ID
							                                                  AND    SA.ITEM_ID      = B.ITEM_ID
							                                                  AND    SA.MONTH        = SUBSTRING(CONVERT(VARCHAR,B.PLAN_DATE,112),1,6)))
						, @OUT_QTY_JR = CEILING(B.ADJUST_IN_QTY_JR * (	  SELECT ISNULL( ISNULL(MAX(SB.YIELD),(CASE WHEN MAX(SA.YIELD) = 0 THEN 1 ELSE MAX(SA.YIELD) END)) ,1) AS YIELD
						                                                      FROM   SCM_YIELD_M SA WITH(NOLOCK)
							                                                  LEFT OUTER JOIN (
							                                                      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
							                                                      FROM   SCM_YIELD_EXCEPT_M AA WITH(NOLOCK)
							                                                      WHERE  AA.DIVISION_ID  = B.DIVISION_ID
							                                                      AND    AA.SITE_ID      = B.SITE_ID
							                                                      AND    AA.PLANT_ID     = B.PLANT_ID
							                                                      AND    AA.FACTORY_ID   = B.FACTORY_ID
							                                                      AND    AA.OPERATION_ID = B.OPERATION_ID
							                                                      AND    AA.LINE_ID      = B.LINE_ID
							                                                      AND    AA.ITEM_ID      = B.ITEM_ID
							                                                      AND    B.PLAN_DATE BETWEEN AA.START_TIME AND AA.END_TIME
							                                                  ) SB
							                                                  ON     1=1
							                                                  WHERE  SA.DIVISION_ID  = B.DIVISION_ID
							                                                  AND    SA.SITE_ID      = B.SITE_ID
							                                                  AND    SA.PLANT_ID     = B.PLANT_ID
							                                                  AND    SA.FACTORY_ID   = B.FACTORY_ID
							                                                  AND    SA.OPERATION_ID = B.OPERATION_ID
							                                                  AND    SA.LINE_ID      = B.LINE_ID
							                                                  AND    SA.ITEM_ID      = B.ITEM_ID
							                                                  AND    SA.MONTH        = SUBSTRING(CONVERT(VARCHAR,B.PLAN_DATE,112),1,6))) 
			                    --, SEQ = B.SEQ
			                    , PRODUCTION_TYPE       = B.PRODUCTION_TYPE
		    		            , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)
		      	WHEN NOT MATCHED BY TARGET THEN
		      		INSERT (
		               INSTANCE_ID, FP_PLAN_ID
		              ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
		              ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
		              ,EQUIPMENT_ID, PLAN_DATE
		              ,TOP_ITEM_ID, ITEM_ID
		              ,PRODUCTION_TYPE, MARKET
		              ,SEQ
		              ,@IN_QTY_BATCH
		              ,@IN_QTY
		              ,@IN_QTY_M
		              ,@IN_QTY_CELL
		              ,@IN_QTY_JR
		              ,@OUT_QTY_BATCH
		              ,@OUT_QTY
		              ,@OUT_QTY_M
		              ,@OUT_QTY_CELL
		              ,@OUT_QTY_JR
		              ,INSERT_ID, INSERT_TIME
		              ,UPDATE_ID, UPDATE_TIME
		              ,WORK_REQUEST_MODEL_ID, VERSION, PROD_SEQ, PLM_EC_NO
		      		)
		      		VALUES (
		               B.INSTANCE_ID, B.FP_PLAN_ID
		              ,(SELECT MAX(KK.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M KK WITH(NOLOCK) WHERE KK.FACTORY_ID = B.FACTORY_ID AND KK.ACTIVE_FLAG = 'Y'), B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID
		              ,B.LOCATION, B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE
		              ,B.EQUIPMENT_ID ,B.PLAN_DATE
		              ,B.TOP_ITEM_ID, B.ITEM_ID
		              ,B.PRODUCTION_TYPE, B.MARKET
		              ,B.SEQ
		              ,B.ADJUST_IN_QTY_BATCH
		              ,0
		              ,B.ADJUST_IN_QTY_M
		              ,B.ADJUST_IN_QTY_CELL
		              ,B.ADJUST_IN_QTY_JR
		              ,B.ADJUST_IN_QTY_BATCH
		              ,0
		              , CEILING(B.ADJUST_IN_QTY_M * (	  SELECT ISNULL( ISNULL(MAX(SB.YIELD),(CASE WHEN MAX(SA.YIELD) = 0 THEN 1 ELSE MAX(SA.YIELD) END)) ,1) AS YIELD
					                                                      FROM   SCM_YIELD_M SA WITH(NOLOCK)
						                                                  LEFT OUTER JOIN (
						                                                      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
						                                                      FROM   SCM_YIELD_EXCEPT_M AA WITH(NOLOCK)
						                                                      WHERE  AA.DIVISION_ID  = B.DIVISION_ID
						                                                      AND    AA.SITE_ID      = B.SITE_ID
						                                                      AND    AA.PLANT_ID     = B.PLANT_ID
						                                                      AND    AA.FACTORY_ID   = B.FACTORY_ID
						                                                      AND    AA.OPERATION_ID = B.OPERATION_ID
						                                                      AND    AA.LINE_ID      = B.LINE_ID
						                                                      AND    AA.ITEM_ID      = B.ITEM_ID
						                                                      AND    B.PLAN_DATE BETWEEN AA.START_TIME AND AA.END_TIME
						                                                  ) SB
						                                                  ON     1=1
						                                                  WHERE  SA.DIVISION_ID  = B.DIVISION_ID
						                                                  AND    SA.SITE_ID      = B.SITE_ID
						                                                  AND    SA.PLANT_ID     = B.PLANT_ID
						                                                  AND    SA.FACTORY_ID   = B.FACTORY_ID
						                                                  AND    SA.OPERATION_ID = B.OPERATION_ID
						                                                  AND    SA.LINE_ID      = B.LINE_ID
						                                                  AND    SA.ITEM_ID      = B.ITEM_ID
						                                                  AND    SA.MONTH        = SUBSTRING(CONVERT(VARCHAR,B.PLAN_DATE,112),1,6)))
			 		 , CEILING(B.ADJUST_IN_QTY_CELL * (	  SELECT ISNULL( ISNULL(MAX(SB.YIELD),(CASE WHEN MAX(SA.YIELD) = 0 THEN 1 ELSE MAX(SA.YIELD) END)) ,1) AS YIELD
					                                                      FROM   SCM_YIELD_M SA WITH(NOLOCK)
						                                                  LEFT OUTER JOIN (
						                                                      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
						                                                      FROM   SCM_YIELD_EXCEPT_M AA WITH(NOLOCK)
						                                                      WHERE  AA.DIVISION_ID  = B.DIVISION_ID
						                                                      AND    AA.SITE_ID      = B.SITE_ID
						                                                      AND    AA.PLANT_ID     = B.PLANT_ID
						                                                      AND    AA.FACTORY_ID   = B.FACTORY_ID
						                                                      AND    AA.OPERATION_ID = B.OPERATION_ID
						                                                      AND    AA.LINE_ID      = B.LINE_ID
						                                                      AND    AA.ITEM_ID      = B.ITEM_ID
						                                                      AND    B.PLAN_DATE BETWEEN AA.START_TIME AND AA.END_TIME
						                                                  ) SB
						                                                  ON     1=1
						                                                  WHERE  SA.DIVISION_ID  = B.DIVISION_ID
						                                                  AND    SA.SITE_ID      = B.SITE_ID
						                                                  AND    SA.PLANT_ID     = B.PLANT_ID
						                                                  AND    SA.FACTORY_ID   = B.FACTORY_ID
						                                                  AND    SA.OPERATION_ID = B.OPERATION_ID
						                                                  AND    SA.LINE_ID      = B.LINE_ID
						                                                  AND    SA.ITEM_ID      = B.ITEM_ID
						                                                  AND    SA.MONTH        = SUBSTRING(CONVERT(VARCHAR,B.PLAN_DATE,112),1,6)))
			 		, CEILING(B.ADJUST_IN_QTY_JR * (	  SELECT ISNULL( ISNULL(MAX(SB.YIELD),(CASE WHEN MAX(SA.YIELD) = 0 THEN 1 ELSE MAX(SA.YIELD) END)) ,1) AS YIELD
					                                                      FROM   SCM_YIELD_M SA WITH(NOLOCK)
						                                                  LEFT OUTER JOIN (
						                                                      SELECT (CASE WHEN MAX(YIELD) = 0 THEN 1 ELSE MAX(YIELD) END) AS YIELD
						                                                      FROM   SCM_YIELD_EXCEPT_M AA WITH(NOLOCK)
						                                                      WHERE  AA.DIVISION_ID  = B.DIVISION_ID
						                                                      AND    AA.SITE_ID      = B.SITE_ID
						                                                      AND    AA.PLANT_ID     = B.PLANT_ID
						                                                      AND    AA.FACTORY_ID   = B.FACTORY_ID
						                                                      AND    AA.OPERATION_ID = B.OPERATION_ID
						                                                      AND    AA.LINE_ID      = B.LINE_ID
						                                                      AND    AA.ITEM_ID      = B.ITEM_ID
						                                                      AND    B.PLAN_DATE BETWEEN AA.START_TIME AND AA.END_TIME
						                                                  ) SB
						                                                  ON     1=1
						                                                  WHERE  SA.DIVISION_ID  = B.DIVISION_ID
						                                                  AND    SA.SITE_ID      = B.SITE_ID
						                                                  AND    SA.PLANT_ID     = B.PLANT_ID
						                                                  AND    SA.FACTORY_ID   = B.FACTORY_ID
						                                                  AND    SA.OPERATION_ID = B.OPERATION_ID
						                                                  AND    SA.LINE_ID      = B.LINE_ID
						                                                  AND    SA.ITEM_ID      = B.ITEM_ID
						                                                  AND    SA.MONTH        = SUBSTRING(CONVERT(VARCHAR,B.PLAN_DATE,112),1,6)))
		              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
		              ,@USER_ID, dbo.FN_SITE_TIME(@SITE_ID)
		              ,B.WORK_REQUEST_MODEL_ID, B.VERSION, B.PROD_SEQ, B.PLM_EC_NO
		      		)
		          ;
		      	  
		        INSERT INTO HIS_AMEND_DAILY_PLAN_R (
		               INSTANCE_ID, FP_PLAN_ID
		              ,COMPANY_ID, DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
		              ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
		              ,EQUIPMENT_ID, PLAN_DATE
		              ,TOP_ITEM_ID, ITEM_ID
		              ,PRODUCTION_TYPE, MARKET
		              ,SEQ
		              ,@IN_QTY_BATCH
		              ,@IN_QTY
		              ,@IN_QTY_M
		              ,@IN_QTY_CELL
		              ,@IN_QTY_JR
		              ,@OUT_QTY_BATCH
		              ,@OUT_QTY
		              ,@OUT_QTY_M
		              ,@OUT_QTY_CELL
		              ,@OUT_QTY_JR
		              ,INSERT_ID, INSERT_TIME
		              ,UPDATE_ID, UPDATE_TIME
		              ,JOB_USER_ID, JOB_TIME,JOB_TYPE
		              ,WORK_REQUEST_MODEL_ID, VERSION, PROD_SEQ, PLM_EC_NO
		        )
		        SELECT A.INSTANCE_ID, A.FP_PLAN_ID
		              ,(SELECT MAX(YY.COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M YY WITH(NOLOCK) WHERE A.FACTORY_ID = YY.FACTORY_ID AND YY.ACTIVE_FLAG = 'Y') AS COMPANY_ID, A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID
		              ,ISNULL(C.LOCATION,'-') AS LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE
		              ,A.EQUIPMENT_ID, A.PLAN_DATE
		              ,A.ITEM_ID AS TOP_ITEM_ID, A.ITEM_ID
		              ,UPPER(A.PRODUCTION_TYPE) AS PRODUCTION_TYPE, A.MARKET
		              ,A.SEQ
		              ,A.ADJUST_IN_QTY_BATCH
		              ,0 AS ADJUST_IN_QTY
		              ,A.ADJUST_IN_QTY_M
		              ,A.ADJUST_IN_QTY_CELL
		              ,A.ADJUST_IN_QTY_JR
		              ,A.ADJUST_OUT_QTY_BATCH
		              ,0 AS ADJUST_OUT_QTY
		              --,A.ADJUST_OUT_QTY_M
		              --,A.ADJUST_OUT_QTY_CELL
		              --,A.ADJUST_OUT_QTY_JR
		              ,B.ADJUST_OUT_QTY_M
		              ,B.ADJUST_OUT_QTY_CELL
		              ,B.ADJUST_OUT_QTY_JR
		              ,@USER_ID AS INSERT_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS INSERT_TIME
		              ,@USER_ID AS UPDATE_ID, dbo.FN_SITE_TIME(A.SITE_ID) AS UPDATE_TIME
		              ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'MPP/WPP_EXCEL' AS JOB_TYPE
		              ,B.WORK_REQUEST_MODEL_ID, B.VERSION, B.PROD_SEQ, (case when B.PLM_EC_NO is null or B.PLM_EC_NO = '' then '-' else B.PLM_EC_NO end) as PLM_EC_NO
		        FROM   BUF_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
		        INNER JOIN SCM_LINE_M C WITH(NOLOCK)
		        ON     A.DIVISION_ID     = C.DIVISION_ID
		        AND    A.SITE_ID         = C.SITE_ID
		        AND    A.PLANT_ID        = C.PLANT_ID
		        AND    A.FACTORY_ID      = C.FACTORY_ID
		        AND    A.OPERATION_ID    = C.OPERATION_ID
		        AND    A.LINE_ID         = C.LINE_ID
		        AND    A.ELECTRODE_TYPE  = C.ELECTRODE_TYPE
		        AND    C.ACTIVE_FLAG     = 'Y'
		        INNER JOIN FP_AMEND_DAILY_PLAN_H B WITH(NOLOCK)
		        ON  A.INSTANCE_ID     = B.INSTANCE_ID
		        AND A.FP_PLAN_ID      = B.FP_PLAN_ID
		        AND A.DIVISION_ID 	  = B.DIVISION_ID
		        AND A.FACTORY_ID      = B.FACTORY_ID
		        AND ISNULL(C.LOCATION,'-') = B.LOCATION
		        AND A.OPERATION_ID    = B.OPERATION_ID
		        AND A.LINE_ID         = B.LINE_ID
		        AND A.ELECTRODE_TYPE  = B.ELECTRODE_TYPE
		        AND A.EQUIPMENT_ID    = B.EQUIPMENT_ID
		        AND A.PLAN_DATE       = B.PLAN_DATE
		        AND A.TOP_ITEM_ID     = B.TOP_ITEM_ID
		        AND A.ITEM_ID         = B.ITEM_ID
		        AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE
		        AND A.MARKET          = B.MARKET
		        AND A.WORK_REQUEST_MODEL_ID  = B.WORK_REQUEST_MODEL_ID
		        AND A.VERSION                = B.VERSION
		        AND A.PLM_EC_NO              = B.PLM_EC_NO
		        WHERE  JOB_USER_ID 			 = @USER_ID
		        AND		 A.INSTANCE_ID		 = @INSTANCE_ID
		      	;
		      	
		      END;