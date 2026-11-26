BEGIN
              BEGIN TRAN
          			UPDATE SCM_MANUAL_WO_CREATE SET
          			       PROCESSING_YN  = RTRIM(LTRIM(@PROCESSING_YN))
          			      ,WO_ID          = RTRIM(LTRIM(@WO_ID))
          			      ,STATUS         = RTRIM(LTRIM(@STATUS))
          			      ,FACTORY_ID     = RTRIM(LTRIM(@FACTORY_ID))
          			      ,LINE_ID        = RTRIM(LTRIM(@LINE_ID))
          			      ,OPERATION_ID   = RTRIM(LTRIM(@OPERATION_ID))
          			      ,EQUIPMENT_ID   = RTRIM(LTRIM(@EQUIPMENT_ID))
          			      ,ITEM_ID        = RTRIM(LTRIM(@ITEM_ID))
          			      ,ORDER_TYPE     = RTRIM(LTRIM(@ORDER_TYPE))
          			      ,START_TIME     = RTRIM(LTRIM(@START_TIME))
          			      ,END_TIME       = RTRIM(LTRIM(@END_TIME))
          			      ,IN_QTY         = RTRIM(LTRIM(@IN_QTY))
          			      ,OUT_QTY        = RTRIM(LTRIM(@OUT_QTY))
          			      ,LANE_QTY       = RTRIM(LTRIM(@LANE_QTY))
          			      ,REQUESTER      = RTRIM(LTRIM(@REQUESTER))
          			      ,REQUEST_REASON = RTRIM(LTRIM(@REQUEST_REASON))
          			      ,TOP_ITEM_ID    = RTRIM(LTRIM(@TOP_ITEM_ID))
          			      ,REQUEST_TYPE   = RTRIM(LTRIM(@REQUEST_TYPE))
          			      ,CSR_ID         = RTRIM(LTRIM(@CSR_ID))

                      ,WORK_REQUEST_MODEL_ID         = RTRIM(LTRIM(@WORK_REQUEST_MODEL_ID))
                      ,VERSION         = RTRIM(LTRIM(@VERSION))
                      ,PROD_SEQ         = RTRIM(LTRIM(@PROD_SEQ))
                      ,PLM_EC_NO         = RTRIM(LTRIM(@PLM_EC_NO))
                      
          			WHERE  SEQ            = @SEQ
          			AND    WO_BASE_DATE   = @WO_BASE_DATE
                ;
              
              COMMIT;
              
              
              BEGIN TRAN
          			UPDATE SCM_MANUAL_WO_CREATE SET
                       BATCH_QTY      = (CASE WHEN B.ITEM_ID IS NULL THEN NULL ELSE 
                                                (CASE WHEN B.BATCH_LOT_SIZE = 0 OR B.BATCH_LOT_SIZE IS NULL THEN NULL ELSE ROUND((CONVERT(NUMERIC,RTRIM(LTRIM(@IN_QTY)))/B.BATCH_LOT_SIZE), 2) END) END)
          			      ,MARKET         = RTRIM(LTRIM(@MARKET))
          			      ,UPDATE_DATE    = dbo.SYSDATE1()
          			      ,UPDATE_PSN_ID  = @USER_ID
                FROM   SCM_MANUAL_WO_CREATE A
                LEFT JOIN SCM_ITEM_EQUIP_RATE_BATCH_M B
                ON     A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.ITEM_ID      = B.ITEM_ID
          			WHERE  A.SEQ          = @SEQ
          			AND    A.WO_BASE_DATE = @WO_BASE_DATE
          			;
                
              COMMIT;
            
            END;