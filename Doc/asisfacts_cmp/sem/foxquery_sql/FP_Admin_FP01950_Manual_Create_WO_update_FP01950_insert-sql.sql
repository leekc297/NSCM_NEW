BEGIN
              BEGIN TRAN
              
                INSERT INTO SCM_MANUAL_WO_CREATE (
                       SEQ
                      ,STATUS
                      ,WO_BASE_DATE
                      ,FACTORY_ID
                      ,LINE_ID
                      ,OPERATION_ID
                      ,EQUIPMENT_ID
                      ,ITEM_ID
                      ,WORK_CENTER_ID
                      ,WO_ID
                      ,MO_ID
                      ,ORDER_TYPE
                      ,WO_TYPE
                      ,START_TIME, END_TIME
                      ,IN_QTY
                      ,OUT_QTY
                      ,LANE_QTY
                      ,BATCH_QTY
                      ,MARKET
                      ,PROCESSING_YN
                      ,ORDER_CREAT_DATE
                      ,CREATE_DATE, CREATE_PSN_ID
                      ,UPDATE_DATE, UPDATE_PSN_ID
                      ,ERROR_MSG
                      ,REQUESTER, REQUEST_REASON
                      ,TOP_ITEM_ID
                      ,REQUEST_TYPE
                      ,CSR_ID
                      ,WORK_REQUEST_MODEL_ID, VERSION, PROD_SEQ, PLM_EC_NO
                )
                SELECT A.SEQ
                      ,A.STATUS
                      ,A.WO_BASE_DATE
                      ,A.FACTORY_ID
                      ,A.LINE_ID
                      ,A.OPERATION_ID
                      ,A.EQUIPMENT_ID
                      ,A.ITEM_ID
                      ,A.WORK_CENTER_ID
                      ,A.WO_ID
                      ,A.MO_ID
                      ,A.ORDER_TYPE
                      ,A.WO_TYPE
                      ,A.START_TIME, A.END_TIME
                      ,A.IN_QTY
                      ,A.OUT_QTY
                      ,A.LANE_QTY
                      ,(CASE WHEN B.ITEM_ID IS NULL THEN NULL ELSE 
                                (CASE WHEN B.BATCH_LOT_SIZE = 0 OR B.BATCH_LOT_SIZE IS NULL THEN NULL ELSE ROUND((CONVERT(NUMERIC,RTRIM(LTRIM( @IN_QTY )))/B.BATCH_LOT_SIZE), 2) END) END) AS BATCH_QTY
                      ,A.MARKET
                      ,A.PROCESSING_YN
                      ,A.ORDER_CREAT_DATE
                      ,A.CREATE_DATE, A.CREATE_PSN_ID
                      ,A.UPDATE_DATE, A.UPDATE_PSN_ID
                      ,A.ERROR_MSG
                      ,A.REQUESTER, A.REQUEST_REASON
                      ,A.TOP_ITEM_ID
                      ,A.REQUEST_TYPE
                      ,A.CSR_ID
                      ,A.WORK_REQUEST_MODEL_ID, A.VERSION, A.PROD_SEQ, A.PLM_EC_NO
                FROM (
                    SELECT (SELECT (ISNULL(MAX(SEQ),0)+1) FROM SCM_MANUAL_WO_CREATE WHERE WO_BASE_DATE = RTRIM(LTRIM( @WO_BASE_DATE ))) AS SEQ
                          ,RTRIM(LTRIM(@STATUS)) AS STATUS
                          ,RTRIM(LTRIM(@WO_BASE_DATE)) AS WO_BASE_DATE
                          ,RTRIM(LTRIM(@FACTORY_ID)) AS FACTORY_ID
                          ,RTRIM(LTRIM(@LINE_ID)) AS LINE_ID
                          ,RTRIM(LTRIM(@OPERATION_ID)) AS OPERATION_ID
                          ,RTRIM(LTRIM(@EQUIPMENT_ID)) AS EQUIPMENT_ID
                          ,RTRIM(LTRIM(@ITEM_ID)) AS ITEM_ID
                          ,RTRIM(LTRIM(@WORK_CENTER_ID)) AS WORK_CENTER_ID
                          ,RTRIM(LTRIM(@WO_ID)) AS WO_ID
                          ,RTRIM(LTRIM(@MO_ID)) AS MO_ID
                          ,RTRIM(LTRIM(@ORDER_TYPE)) AS ORDER_TYPE
                          ,RTRIM(LTRIM(@WO_TYPE)) AS WO_TYPE
                          ,RTRIM(LTRIM(@START_TIME)) AS START_TIME, RTRIM(LTRIM(@END_TIME)) AS END_TIME
                          ,RTRIM(LTRIM(@IN_QTY)) AS IN_QTY
                          ,RTRIM(LTRIM(@OUT_QTY)) AS OUT_QTY
                          ,RTRIM(LTRIM(@LANE_QTY)) AS LANE_QTY
                          ,RTRIM(LTRIM(@MARKET)) AS MARKET
                          ,'N' AS PROCESSING_YN
                          ,dbo.sysdate1() AS ORDER_CREAT_DATE
                          ,dbo.sysdate1() AS CREATE_DATE, @USER_ID AS CREATE_PSN_ID
                          ,dbo.sysdate1() AS UPDATE_DATE, @USER_ID AS UPDATE_PSN_ID
                          ,@ERROR_MSG AS ERROR_MSG
                          ,@REQUESTER AS REQUESTER, @REQUEST_REASON AS REQUEST_REASON
                          ,@TOP_ITEM_ID AS TOP_ITEM_ID
                          ,@REQUEST_TYPE AS REQUEST_TYPE
                          ,@CSR_ID AS CSR_ID
                          ,@WORK_REQUEST_MODEL_ID AS WORK_REQUEST_MODEL_ID, @VERSION as VERSION, @PROD_SEQ as PROD_SEQ, @PLM_EC_NO as PLM_EC_NO
                ) A
                LEFT JOIN SCM_ITEM_EQUIP_RATE_BATCH_M B
                ON     A.FACTORY_ID   = B.FACTORY_ID
                AND    A.OPERATION_ID = B.OPERATION_ID
                AND    A.ITEM_ID      = B.ITEM_ID
                ;
              
              COMMIT;
            
            END;