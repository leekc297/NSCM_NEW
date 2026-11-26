BEGIN
        BEGIN TRAN
          MERGE INTO FP_AMEND_DAILY_PLAN_R A
          USING (	SELECT 	A.INSTANCE_ID, A.FP_PLAN_ID, A.COMPANY_ID,
                        	A.DIVISION_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, 
                        	A.LOCATION, A.OPERATION_ID, A.LINE_ID, A.ELECTRODE_TYPE,
                        	A.EQUIPMENT_ID, A.PLAN_DATE,
                        	A.TOP_ITEM_ID, A.ITEM_ID, 
                        	A.PRODUCTION_TYPE, A.MARKET
                        	, A.ADJUST_IN_QTY
                        	, A.ADJUST_IN_QTY_BATCH  
		                    , A.ADJUST_IN_QTY_M     
		                    , A.ADJUST_IN_QTY_CELL  
		                    , A.ADJUST_IN_QTY_JR    
		                    , A.ADJUST_OUT_QTY
		                    , A.ADJUST_OUT_QTY_BATCH
		                    , A.ADJUST_OUT_QTY_M    
		                    , A.ADJUST_OUT_QTY_CELL 
		                    , A.ADJUST_OUT_QTY_JR  
		                    , A.SEQ 
                 	FROM	FP_AMEND_DAILY_PLAN_R A
                 	WHERE	A.INSTANCE_ID 	= @INSTANCE_ID 
          			AND 	A.FP_PLAN_ID 	= @FP_PLAN_ID
	              	AND 	A.FACTORY_ID 	= @FACTORY_ID 
	              	AND 	A.OPERATION_ID 	= @OPERATION_ID 
	              	AND 	A.LINE_ID 		= @LINE_ID 
	              	AND 	A.ELECTRODE_TYPE = @ELECTRODE_TYPE
	              	AND 	A.EQUIPMENT_ID 	= @EQUIPMENT_ID 
	              	AND 	CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN @BUCKET_FROM AND @BUCKET_TO
	              	AND 	A.TOP_ITEM_ID 	= @TOP_ITEM_ID
	              	AND 	A.ITEM_ID 		= @ITEM_ID
	              	AND 	A.PRODUCTION_TYPE = @PRODUCTION_TYPE
	              	AND 	A.MARKET 		= @MARKET
	              	AND		ISNULL(A.ADJUST_IN_QTY_BATCH,0) <> 0
                ) B
          ON (      A.INSTANCE_ID 	= B.INSTANCE_ID 
          		AND A.FP_PLAN_ID 	= B.FP_PLAN_ID
              	AND A.FACTORY_ID 	= @COPY_FACTORY_ID
              	AND A.LOCATION 		= B.LOCATION
              	AND A.OPERATION_ID 	= B.OPERATION_ID 
              	AND A.LINE_ID 		= @COPY_LINE_ID
              	AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
              	AND A.EQUIPMENT_ID 	= (	SELECT 	MAX(EQUIPMENT_ID) FROM SCM_EQUIPMENT_M SA 
              							WHERE 	SA.DIVISION_ID 	= B.DIVISION_ID 
              							AND 	SA.SITE_ID 		= B.SITE_ID 
              							AND 	SA.PLANT_ID 	= B.PLANT_ID 
              							AND		SA.FACTORY_ID 	= @COPY_FACTORY_ID	
              							AND 	SA.OPERATION_ID = B.OPERATION_ID 
              							AND		SA.LINE_ID 		= @COPY_LINE_ID
              						  )
              	AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE
              	AND A.TOP_ITEM_ID 	= B.TOP_ITEM_ID 
              	AND A.ITEM_ID 		= B.ITEM_ID
              	AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE 
              	AND A.MARKET 		= B.MARKET 
            )
          WHEN MATCHED THEN
            UPDATE SET SEQ = CASE WHEN CONVERT(NUMERIC(25,10), ISNULL(A.ADJUST_IN_QTY_BATCH,0) + ISNULL(B.ADJUST_IN_QTY_BATCH,0)) = 0 THEN 0 ELSE B.SEQ END 
                     , A.ADJUST_IN_QTY_BATCH  = ISNULL(A.ADJUST_IN_QTY_BATCH,0)  + ISNULL(B.ADJUST_IN_QTY_BATCH,0)
                     , A.ADJUST_IN_QTY_M      = ISNULL(A.ADJUST_IN_QTY_M,0)      + ISNULL(B.ADJUST_IN_QTY_M,0)
                     , A.ADJUST_IN_QTY_CELL   = ISNULL(A.ADJUST_IN_QTY_CELL,0)   + ISNULL(B.ADJUST_IN_QTY_CELL,0)
                     , A.ADJUST_IN_QTY_JR     = ISNULL(A.ADJUST_IN_QTY_JR,0)     + ISNULL(B.ADJUST_IN_QTY_JR,0)
                     , A.ADJUST_OUT_QTY_BATCH = ISNULL(A.ADJUST_OUT_QTY_BATCH,0) + ISNULL(B.ADJUST_OUT_QTY_BATCH,0)
                     , A.ADJUST_OUT_QTY_M     = ISNULL(A.ADJUST_OUT_QTY_M,0)     + ISNULL(B.ADJUST_OUT_QTY_M,0)
                     , A.ADJUST_OUT_QTY_CELL  = ISNULL(A.ADJUST_OUT_QTY_CELL,0)  + ISNULL(B.ADJUST_OUT_QTY_CELL,0)
                     , A.ADJUST_OUT_QTY_JR    = ISNULL(A.ADJUST_OUT_QTY_JR,0)    + ISNULL(B.ADJUST_OUT_QTY_JR,0)
                     , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)
          WHEN NOT MATCHED THEN
            INSERT (
               INSTANCE_ID, FP_PLAN_ID
              ,COMPANY_ID
              ,DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
              ,LOCATION, OPERATION_ID, LINE_ID, ELECTRODE_TYPE
              ,EQUIPMENT_ID
              ,PLAN_DATE
              ,TOP_ITEM_ID, ITEM_ID
              ,PRODUCTION_TYPE, MARKET
              ,SEQ
              ,ADJUST_IN_QTY_BATCH, ADJUST_IN_QTY
              ,ADJUST_IN_QTY_M, ADJUST_IN_QTY_CELL
              ,ADJUST_IN_QTY_JR
              ,ADJUST_OUT_QTY_BATCH, ADJUST_OUT_QTY
              ,ADJUST_OUT_QTY_M, ADJUST_OUT_QTY_CELL
              ,ADJUST_OUT_QTY_JR
              ,INSERT_ID, INSERT_TIME
              ,UPDATE_ID, UPDATE_TIME
            )
            VALUES (
               B.INSTANCE_ID, B.FP_PLAN_ID
              ,B.COMPANY_ID
              ,B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, @COPY_FACTORY_ID
              ,B.LOCATION, B.OPERATION_ID, @COPY_LINE_ID, B.ELECTRODE_TYPE
              ,(	SELECT 	MAX(EQUIPMENT_ID) FROM SCM_EQUIPMENT_M SA 
					WHERE 	SA.DIVISION_ID 	= B.DIVISION_ID 
					AND 	SA.SITE_ID 		= B.SITE_ID 
					AND 	SA.PLANT_ID 	= B.PLANT_ID 
					AND		SA.FACTORY_ID 	= @COPY_FACTORY_ID	
					AND 	SA.OPERATION_ID = B.OPERATION_ID 
					AND		SA.LINE_ID 		= @COPY_LINE_ID
			   )
              ,B.PLAN_DATE
              ,B.TOP_ITEM_ID, B.ITEM_ID
              ,PRODUCTION_TYPE, B.MARKET
              ,B.SEQ
              ,B.ADJUST_IN_QTY_BATCH, B.ADJUST_IN_QTY
              ,B.ADJUST_IN_QTY_M, B.ADJUST_IN_QTY_CELL
              ,B.ADJUST_IN_QTY_JR
              ,B.ADJUST_OUT_QTY_BATCH, B.ADJUST_OUT_QTY
              ,B.ADJUST_OUT_QTY_M, B.ADJUST_OUT_QTY_CELL
              ,B.ADJUST_OUT_QTY_JR
              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
            )
          ;
        
        COMMIT;
        
        BEGIN TRAN
          	UPDATE	FP_AMEND_DAILY_PLAN_R
          	SET 	SEQ = 0
					, ADJUST_IN_QTY_BATCH  = 0
					, ADJUST_IN_QTY_M      = 0
					, ADJUST_IN_QTY_CELL   = 0
					, ADJUST_IN_QTY_JR     = 0
					, ADJUST_OUT_QTY_BATCH = 0
					, ADJUST_OUT_QTY_M     = 0
					, ADJUST_OUT_QTY_CELL  = 0
					, ADJUST_OUT_QTY_JR    = 0
					, UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(@SITE_ID)
	     	WHERE	INSTANCE_ID 	= @INSTANCE_ID 
			AND 	FP_PLAN_ID 		= @FP_PLAN_ID
	      	AND 	FACTORY_ID 		= @FACTORY_ID 
	      	AND 	OPERATION_ID 	= @OPERATION_ID 
	      	AND 	LINE_ID 		= @LINE_ID 
	      	AND 	ELECTRODE_TYPE 	= @ELECTRODE_TYPE
	      	AND 	EQUIPMENT_ID 	= @EQUIPMENT_ID 
	      	AND 	CONVERT(VARCHAR, PLAN_DATE,112) BETWEEN @BUCKET_FROM AND @BUCKET_TO
	      	AND 	TOP_ITEM_ID 	= @TOP_ITEM_ID
	      	AND 	ITEM_ID 		= @ITEM_ID
	      	AND 	PRODUCTION_TYPE = @PRODUCTION_TYPE
	      	AND 	MARKET 			= @MARKET
	      	AND		ISNULL(ADJUST_IN_QTY_BATCH,0) <> 0
	        ;
          
        COMMIT;
        
        BEGIN TRAN
            INSERT INTO HIS_AMEND_DAILY_PLAN_R (
                   INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID
                  ,DIVISION_ID
                  ,SITE_ID
                  ,PLANT_ID
                  ,FACTORY_ID
                  ,LOCATION
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ELECTRODE_TYPE
                  ,EQUIPMENT_ID
                  ,PLAN_DATE
                  ,TOP_ITEM_ID
                  ,ITEM_ID
                  ,PRODUCTION_TYPE
                  ,MARKET
                  ,SEQ
                  ,PLAN_IN_QTY_BATCH
                  ,PLAN_IN_QTY
                  ,PLAN_IN_QTY_M
                  ,PLAN_IN_QTY_CELL
                  ,PLAN_OUT_QTY_BATCH
                  ,PLAN_OUT_QTY
                  ,PLAN_OUT_QTY_M
                  ,PLAN_OUT_QTY_CELL
                  ,ADJUST_IN_QTY_BATCH
                  ,ADJUST_IN_QTY
                  ,ADJUST_IN_QTY_M
                  ,ADJUST_IN_QTY_CELL
                  ,ADJUST_IN_QTY_JR
                  ,ADJUST_OUT_QTY_BATCH
                  ,ADJUST_OUT_QTY
                  ,ADJUST_OUT_QTY_M
                  ,ADJUST_OUT_QTY_CELL
                  ,ADJUST_OUT_QTY_JR
                  ,TOTAL_BATCH
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
            )
            SELECT INSTANCE_ID, FP_PLAN_ID
                  ,COMPANY_ID
                  ,DIVISION_ID
                  ,SITE_ID
                  ,PLANT_ID
                  ,FACTORY_ID
                  ,LOCATION
                  ,OPERATION_ID
                  ,LINE_ID
                  ,ELECTRODE_TYPE
                  ,EQUIPMENT_ID
                  ,PLAN_DATE
                  ,TOP_ITEM_ID
                  ,ITEM_ID
                  ,UPPER(PRODUCTION_TYPE) AS PRODUCTION_TYPE
                  ,MARKET
                  ,SEQ
                  ,PLAN_IN_QTY_BATCH
                  ,PLAN_IN_QTY
                  ,PLAN_IN_QTY_M
                  ,PLAN_IN_QTY_CELL
                  ,PLAN_OUT_QTY_BATCH
                  ,PLAN_OUT_QTY
                  ,PLAN_OUT_QTY_M
                  ,PLAN_OUT_QTY_CELL
                  ,ADJUST_IN_QTY_BATCH
                  ,ADJUST_IN_QTY
                  ,ADJUST_IN_QTY_M
                  ,ADJUST_IN_QTY_CELL
                  ,ADJUST_IN_QTY_JR
                  ,ADJUST_OUT_QTY_BATCH
                  ,ADJUST_OUT_QTY
                  ,ADJUST_OUT_QTY_M
                  ,ADJUST_OUT_QTY_CELL
                  ,ADJUST_OUT_QTY_JR
                  ,TOTAL_BATCH
                  ,INSERT_ID, INSERT_TIME
                  ,UPDATE_ID, UPDATE_TIME
                  ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, @LINE_ID+'_LINE_COPY_UPDATE' AS JOB_TYPE
            FROM   FP_AMEND_DAILY_PLAN_R A WITH(NOLOCK)
            WHERE  A.INSTANCE_ID      = @INSTANCE_ID
            AND    A.FP_PLAN_ID       = @FP_PLAN_ID
            AND    A.FACTORY_ID       = @COPY_FACTORY_ID
            AND    A.OPERATION_ID     = @OPERATION_ID
            AND    A.LINE_ID          = @COPY_LINE_ID
            AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE
            AND    A.EQUIPMENT_ID     = (	SELECT 	MAX(EQUIPMENT_ID) FROM SCM_EQUIPMENT_M SA 
											WHERE 	SA.DIVISION_ID 	= @DIVISION_ID
											[AND 	SA.SITE_ID 		= @SITE_ID] 
											[AND 	SA.PLANT_ID 	= @PLANT_ID]
											AND		SA.FACTORY_ID 	= @COPY_FACTORY_ID	
											[AND 	SA.OPERATION_ID = @OPERATION_ID]
											AND		SA.LINE_ID 		= @COPY_LINE_ID
									    )
            AND    CONVERT(VARCHAR,A.PLAN_DATE,112) BETWEEN @BUCKET_FROM AND @BUCKET_TO
            AND    A.TOP_ITEM_ID      = @ITEM_ID
            AND    A.ITEM_ID          = @ITEM_ID
            AND    A.PRODUCTION_TYPE  = UPPER(@PRODUCTION_TYPE)
            AND    A.MARKET           = @MARKET
            ;
          
        COMMIT;
        
        
      END;