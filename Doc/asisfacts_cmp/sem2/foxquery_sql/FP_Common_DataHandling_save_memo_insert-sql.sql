BEGIN
		        BEGIN TRAN
		          MERGE INTO FP_AMEND_MEMO_M A
		          USING (	  SELECT A.*, B.YYYYMMDD AS PLAN_DATE
                      	FROM (
  		          					SELECT @INSTANCE_ID AS INSTANCE_ID,
  				                       @DIVISION_ID AS DIVISION_ID, @SITE_ID AS SITE_ID,@PLANT_ID AS PLANT_ID, @FACTORY_ID AS FACTORY_ID, 
  				                       @OPERATION_ID AS OPERATION_ID, @LINE_ID AS LINE_ID, @ELECTRODE_TYPE AS ELECTRODE_TYPE,
  				                       (CASE WHEN @EQUIPMENT_ID IS NULL OR @EQUIPMENT_ID = '' THEN '-' ELSE @EQUIPMENT_ID END) AS EQUIPMENT_ID,
  				                       @TOP_ITEM_ID AS TOP_ITEM_ID, @ITEM_ID AS ITEM_ID, 
  				                       @PRODUCTION_TYPE AS PRODUCTION_TYPE, @MARKET AS MARKET,
                                 CASE @MEMO_TYPE WHEN '' THEN 'DPP'
                                 ELSE ISNULL(@MEMO_TYPE, 'DPP') END   AS MEMO_TYPE
					              ) A
	                      INNER JOIN TH_UIS_CAL B WITH(NOLOCK)
	                      ON  B.DT BETWEEN @BUCKET_FROM AND @BUCKET_TO
		                 ) B
		          ON (    A.INSTANCE_ID = B.INSTANCE_ID
		              AND A.FACTORY_ID = B.FACTORY_ID
		              AND A.OPERATION_ID = B.OPERATION_ID AND A.LINE_ID = B.LINE_ID AND A.ELECTRODE_TYPE = B.ELECTRODE_TYPE
		              AND ISNULL(A.EQUIPMENT_ID,'-') = B.EQUIPMENT_ID 
		              AND CONVERT(VARCHAR,A.PLAN_DATE,112) = B.PLAN_DATE
		              AND A.TOP_ITEM_ID = B.TOP_ITEM_ID AND A.ITEM_ID = B.ITEM_ID
		              AND A.PRODUCTION_TYPE = B.PRODUCTION_TYPE AND A.MARKET = B.MARKET 
		              AND A.MEMO_TYPE = B.MEMO_TYPE )
		          WHEN MATCHED THEN
		            UPDATE SET MEMO = @MEMO
		                 , UPDATE_ID = @USER_ID, UPDATE_TIME = dbo.FN_SITE_TIME(B.SITE_ID)
		                 , IF_TIME = GETDATE()
		          WHEN NOT MATCHED THEN
		            INSERT (
		               INSTANCE_ID
		              ,COMPANY_ID
		              ,DIVISION_ID, SITE_ID, PLANT_ID, FACTORY_ID
		              ,OPERATION_ID, LINE_ID, ELECTRODE_TYPE
		              ,EQUIPMENT_ID, PLAN_DATE
		              ,TOP_ITEM_ID, ITEM_ID
		              ,PRODUCTION_TYPE, MARKET
		              ,MEMO
		              ,MEMO_TYPE
		              ,INSERT_ID, INSERT_TIME
		              ,UPDATE_ID, UPDATE_TIME
		              ,IF_TIME
		            )
		            VALUES (
		               B.INSTANCE_ID
		              ,(SELECT MAX(COMPANY_ID) AS COMPANY_ID FROM SCM_FACTORY_M WHERE FACTORY_ID = B.FACTORY_ID AND ACTIVE_FLAG = 'Y')
		              ,B.DIVISION_ID, B.SITE_ID, B.PLANT_ID, B.FACTORY_ID
		              ,B.OPERATION_ID, B.LINE_ID, B.ELECTRODE_TYPE
		              ,B.EQUIPMENT_ID ,CONVERT(DATETIME,B.PLAN_DATE)
		              ,B.TOP_ITEM_ID, B.ITEM_ID
		              ,B.PRODUCTION_TYPE, B.MARKET
		              ,@MEMO
		              ,B.MEMO_TYPE
		              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
		              ,@USER_ID, dbo.FN_SITE_TIME(B.SITE_ID)
		              ,GETDATE()
		            )
		          ;
		        
		        COMMIT;
		        
		        BEGIN TRAN
		            INSERT INTO HIS_AMEND_MEMO_M (
		                   INSTANCE_ID
		                  ,COMPANY_ID
		                  ,DIVISION_ID
		                  ,SITE_ID
		                  ,PLANT_ID
		                  ,FACTORY_ID
		                  ,OPERATION_ID
		                  ,LINE_ID
		                  ,ELECTRODE_TYPE
		                  ,EQUIPMENT_ID
		                  ,PLAN_DATE
		                  ,TOP_ITEM_ID
		                  ,ITEM_ID
		                  ,PRODUCTION_TYPE
		                  ,MARKET
		                  ,MEMO
		                  ,MEMO_TYPE
		                  ,INSERT_ID, INSERT_TIME
		                  ,UPDATE_ID, UPDATE_TIME
		                  ,JOB_USER_ID, JOB_TIME, JOB_TYPE
		            )
		            SELECT INSTANCE_ID
		                  ,COMPANY_ID
		                  ,DIVISION_ID
		                  ,SITE_ID
		                  ,PLANT_ID
		                  ,FACTORY_ID
		                  ,OPERATION_ID
		                  ,LINE_ID
		                  ,ELECTRODE_TYPE
		                  ,EQUIPMENT_ID
		                  ,PLAN_DATE
		                  ,TOP_ITEM_ID
		                  ,ITEM_ID
		                  ,PRODUCTION_TYPE
		                  ,MARKET
		                  ,MEMO
		                  ,MEMO_TYPE
		                  ,INSERT_ID, INSERT_TIME
		                  ,UPDATE_ID, UPDATE_TIME
		                  ,@USER_ID AS JOB_USER_ID, GETDATE() AS JOB_TIME, 'MERGE' AS JOB_TYPE
		            FROM   FP_AMEND_MEMO_M A WITH(NOLOCK)
		            WHERE  A.INSTANCE_ID      = @INSTANCE_ID
		            AND    A.DIVISION_ID      = @DIVISION_ID
		            AND    A.SITE_ID       	  = @SITE_ID
		            AND    A.PLANT_ID         = @PLANT_ID
		            AND    A.FACTORY_ID       = @FACTORY_ID
		            AND    A.OPERATION_ID     = @OPERATION_ID
		            AND    A.LINE_ID          = @LINE_ID
		            AND    A.TOP_ITEM_ID      = @TOP_ITEM_ID
		            AND    A.ITEM_ID          = @ITEM_ID
		            AND    A.ELECTRODE_TYPE   = @ELECTRODE_TYPE
		            AND    ISNULL(A.EQUIPMENT_ID,'-') = (CASE WHEN @EQUIPMENT_ID IS NULL OR @EQUIPMENT_ID = '' THEN '-' ELSE @EQUIPMENT_ID END)
		            AND    A.PLAN_DATE BETWEEN CONVERT(DATETIME,@BUCKET_FROM) AND CONVERT(DATETIME,@BUCKET_TO)
		            AND    A.PRODUCTION_TYPE  = @PRODUCTION_TYPE
		            AND    A.MARKET           = @MARKET
                AND         ((ISNULL(@MEMO_TYPE,'')='' AND A.MEMO_TYPE = @MEMO_TYPE)
			OR (ISNULL(@MEMO_TYPE,'')='' AND A.MEMO_TYPE = 'DPP'))
			AND	A.MEMO IS NOT NULL
		            ;
		          
		        COMMIT;
		        
		      END;