        SELECT DISTINCT
             T.DIVISION_ID
            ,T.PLAN_START_YYYYMMDD
            ,T.PLAN_TYPE
            ,T.SEQ
            ,T.ITEM_ID
            ,T.FROM_SITE
            ,T.TO_SITE
            ,T.MEASURE
            ,T.YYYYMMDD
            ,T.BOD_ID
            ,T.QTY
            ,T.ROUTE_ID
            ,T.INCOTERMS
            ,T.TRANSPORT_MODE
            ,V.OPERATION_GROUP AS BIZ_TYPE
            ,T.PROJECT_CODE
            ,T.FCST_TYPE
            ,T.FCST_ETD_DATE
            ,T.FCST_ETA_DATE
            ,T.ETD_DATE
            ,T.ETA_DATE
            ,CASE WHEN T.CONFIRM_ID LIKE 'C%' THEN 'Y' ELSE 'N' END AS CONFIRM_FLAG
            ,NVL(T.CONFIRM_ID, '-')  AS CONFIRM_ID
            ,V_BATCH_USER AS CREATED_BY
            ,SYSDATE      AS CREATION_DATE
            ,V_BATCH_USER AS LAST_UPDATED_BY
            ,SYSDATE      AS LAST_UPDATED_BY
            ,T.DIVISION_ID /* ORIGIN_FROM_DIVISION_ID */
            ,T.DIVISION_ID /* ORIGIN_TO_DIVISION_ID */
            ,T.ATTRIBUTE1  /* PROD_DATE */
            ,T.ATTRIBUTE2  /* REQUESTOR */
            ,T.ATTRIBUTE3  /* Description */
            ,T.ATTRIBUTE4  /* Prod Qty(MASS) */
            ,T.ATTRIBUTE5  /* Prod Qty(ALL) */
            ,T.ATTRIBUTE6  /* oWMS재고수량 */
            ,E.COMPANY_ID AS ATTRIBUTE10
        FROM GT_SSP_ANL_SHIP_PLAN_40 T
            JOIN SCP_MST_FINAL_ITEM V
            ON V.ITEM_ID = T.ITEM_ID
            AND V.DIVISION_ID = T.DIVISION_ID
            JOIN SCM_MST_SITE E
            ON E.DIVISION_ID = V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
            AND E.DIVISION_ID = T.DIVISION_ID
            AND E.SCM_SITE_ID = T.FROM_SITE
        WHERE 1 = 1
        AND   NVL(E.COMPANY_ID, '-') = NVL(V_COMPANY_ID, '-')
        ;
