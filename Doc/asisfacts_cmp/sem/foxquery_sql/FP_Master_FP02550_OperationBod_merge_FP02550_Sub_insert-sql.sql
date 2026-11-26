BEGIN
					        MERGE INTO SCM_ITEM_FLOW_EXCEPT_M A
					        USING 
					          (SELECT RTRIM(LTRIM(@COMPANY_ID)) as COMPANY_ID, RTRIM(LTRIM(@DIVISION_ID)) as DIVISION_ID, RTRIM(LTRIM(@SITE_ID)) as SITE_ID, RTRIM(LTRIM(@PLANT_ID)) as PLANT_ID, RTRIM(LTRIM(@FACTORY_ID)) as FACTORY_ID
					                 ,RTRIM(LTRIM(@ITEM_ID)) as ITEM_ID, RTRIM(LTRIM(@OPERATION_ID)) as OPERATION_ID
					                 ,RTRIM(LTRIM(@MODEL_TYPE)) as MODEL_TYPE, RTRIM(LTRIM(@LINE_ATTR_1)) as LINE_ATTR_1) B
					          ON (A.COMPANY_ID    = B.COMPANY_ID
					          AND A.DIVISION_ID   = B.DIVISION_ID
					          AND A.SITE_ID       = B.SITE_ID
					          AND A.PLANT_ID      = B.PLANT_ID
					          AND A.FACTORY_ID    = B.FACTORY_ID
					          AND A.ITEM_ID       = B.ITEM_ID
					          AND A.OPERATION_ID  = B.OPERATION_ID
					          AND A.LINE_ATTR_1   = B.LINE_ATTR_1
					          AND A.MODEL_TYPE    = B.MODEL_TYPE)
					        WHEN MATCHED THEN
					          UPDATE SET 
					              OPERATION_LOT_SIZE          = RTRIM(LTRIM(@OPERATION_LOT_SIZE))
					             ,MIN_LOT_SIZE                = RTRIM(LTRIM(@MIN_LOT_SIZE))
					             ,LOT_SIZE_UOM                = RTRIM(LTRIM(@LOT_SIZE_UOM))
					             ,PRECEDE_PRODUCING_TERM      = RTRIM(LTRIM(@PRECEDE_PRODUCING_TERM))
					             ,PRECEDE_PRODUCING_TERM_UOM  = RTRIM(LTRIM(@PRECEDE_PRODUCING_TERM_UOM))
					             ,BUFFER_TIME                 = RTRIM(LTRIM(@BUFFER_TIME))
					             ,BUFFER_TIME_UOM             = RTRIM(LTRIM(@BUFFER_TIME_UOM))
					             ,TAT                         = RTRIM(LTRIM(@TAT))
					             ,TAT_UOM                     = RTRIM(LTRIM(@TAT_UOM))
					      			 ,TRANSFER_LOT_SIZE           = RTRIM(LTRIM(@TRANSFER_LOT_SIZE))
					      			 ,TRANSFER_LOT_SIZE_UOM       = RTRIM(LTRIM(@TRANSFER_LOT_SIZE_UOM))
					      			 ,TOLERANCE                   = RTRIM(LTRIM(@TOLERANCE))
					      			 ,TOLERANCE_UOM               = RTRIM(LTRIM(@TOLERANCE_UOM))
					      			 ,OPERATION_LEAD_TIME         = RTRIM(LTRIM(@OPERATION_LEAD_TIME))
					      			 ,OPERATION_LEAD_TIME_UOM     = RTRIM(LTRIM(@OPERATION_LEAD_TIME_UOM))
					             ,UPDATE_ID                   = @USER_ID
					             ,UPDATE_TIME                 = dbo.SYSDATE1()
					        WHEN NOT MATCHED THEN
					          INSERT (
					             COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID
					            ,ITEM_ID,OPERATION_ID
					            ,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM
					            ,TAT,TAT_UOM,TAT_FLAG
					            ,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM
					            ,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM
								      ,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM
					            ,ACTIVE_FLAG
					            ,DESCRIPTION
					      			,TOLERANCE, TOLERANCE_UOM
					      			,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM
					      			,MODEL_TYPE, LINE_ATTR_1
					            ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
					          )
					          VALUES(
					             RTRIM(LTRIM(@COMPANY_ID))                 ,RTRIM(LTRIM(@DIVISION_ID))                    ,RTRIM(LTRIM(@SITE_ID))      ,RTRIM(LTRIM(@PLANT_ID))     ,RTRIM(LTRIM(@FACTORY_ID))
					            ,RTRIM(LTRIM(@ITEM_ID))                    ,RTRIM(LTRIM(@OPERATION_ID))
					            ,RTRIM(LTRIM(@OPERATION_LOT_SIZE))         ,RTRIM(LTRIM(@MIN_LOT_SIZE))                   ,RTRIM(LTRIM(@LOT_SIZE_UOM)) ,RTRIM(LTRIM(@BUFFER_TIME))  ,RTRIM(LTRIM(@BUFFER_TIME_UOM))
					            ,RTRIM(LTRIM(@TAT))                        ,RTRIM(LTRIM(@TAT_UOM))                        ,RTRIM(LTRIM(@TAT_FLAG))
					            ,RTRIM(LTRIM(@PRECEDE_PRODUCING_TERM))     ,RTRIM(LTRIM(@PRECEDE_PRODUCING_TERM_UOM))
					            ,RTRIM(LTRIM(@INITIAL_PRODUCING_LEAD_TIME)),RTRIM(LTRIM(@INITIAL_PRODUCING_LEAD_TIME_UOM))
								      ,RTRIM(LTRIM(@TRANSFER_LOT_SIZE))          ,RTRIM(LTRIM(@TRANSFER_LOT_SIZE_UOM))
					            ,ISNULL(RTRIM(LTRIM(@ACTIVE_FLAG)),'Y')
					            ,RTRIM(LTRIM(@DESCRIPTION))
					      			,RTRIM(LTRIM(@TOLERANCE)), RTRIM(LTRIM(@TOLERANCE_UOM))
					      			,RTRIM(LTRIM(@OPERATION_LEAD_TIME)), RTRIM(LTRIM(@OPERATION_LEAD_TIME_UOM))
					      			,RTRIM(LTRIM(@MODEL_TYPE)), RTRIM(LTRIM(@LINE_ATTR_1))
					            ,@USER_ID, dbo.SYSDATE1(), @USER_ID, dbo.SYSDATE1()
					          )
					        ;
					        
					        INSERT INTO HIS_ITEM_FLOW_EXCEPT_M (
					               COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID
					              ,ITEM_ID,OPERATION_ID
					              ,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM
					              ,TAT,TAT_UOM,TAT_FLAG
					              ,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM
					              ,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM
					    		      ,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM
					              ,ACTIVE_FLAG
					              ,DESCRIPTION
					        			,TOLERANCE, TOLERANCE_UOM
					        			,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM
					        			,MODEL_TYPE, LINE_ATTR_1
					              ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
					              ,JOB_USER_ID, JOB_TIME, JOB_TYPE
					        )
					        SELECT COMPANY_ID,DIVISION_ID,SITE_ID,PLANT_ID,FACTORY_ID
					              ,ITEM_ID,OPERATION_ID
					              ,OPERATION_LOT_SIZE,MIN_LOT_SIZE,LOT_SIZE_UOM,BUFFER_TIME,BUFFER_TIME_UOM
					              ,TAT,TAT_UOM,TAT_FLAG
					              ,PRECEDE_PRODUCING_TERM,PRECEDE_PRODUCING_TERM_UOM
					              ,INITIAL_PRODUCING_LEAD_TIME,INITIAL_PRODUCING_LEAD_TIME_UOM
								        ,TRANSFER_LOT_SIZE,TRANSFER_LOT_SIZE_UOM
					              ,ACTIVE_FLAG
					              ,DESCRIPTION
					        			,TOLERANCE, TOLERANCE_UOM
					        			,OPERATION_LEAD_TIME, OPERATION_LEAD_TIME_UOM
					        			,MODEL_TYPE, LINE_ATTR_1
					              ,INSERT_ID, INSERT_TIME, UPDATE_ID, UPDATE_TIME
					              ,@USER_ID, dbo.SYSDATE1(), 'EXCEL'
					        FROM  SCM_ITEM_FLOW_EXCEPT_M A(NOLOCK)
					        WHERE COMPANY_ID    = RTRIM(LTRIM(@COMPANY_ID))
					        AND   DIVISION_ID   = RTRIM(LTRIM(@DIVISION_ID))
					        AND   SITE_ID       = RTRIM(LTRIM(@SITE_ID))
					        AND   PLANT_ID      = RTRIM(LTRIM(@PLANT_ID))
					        AND   FACTORY_ID    = RTRIM(LTRIM(@FACTORY_ID))
					        AND   ITEM_ID       = RTRIM(LTRIM(@ITEM_ID))
					        AND   OPERATION_ID  = RTRIM(LTRIM(@OPERATION_ID))
					        AND   MODEL_TYPE    = RTRIM(LTRIM(@MODEL_TYPE))
					        AND   LINE_ATTR_1   = RTRIM(LTRIM(@LINE_ATTR_1))
					        ;
					        
					      END;