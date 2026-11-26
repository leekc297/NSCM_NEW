SELECT  P.DIVISION_ID               AS DIVISION_ID
        ,       NVL(IM.APPLIED_MODEL, P.CELL_ITEM_ID) AS ITEM_ID
        ,       P.SCM_SITE_ID               AS FROM_SITE
        ,       '-'                         AS TO_SITE
        ,       'POSTP_PLAN'                AS MEASURE
        ,       P.PLAN_DATE                 AS YYYYMMDD
        ,       '-'                         AS BOD_ID
        ,       P.PLAN_QTY                  AS QTY
        ,       '-'                         AS INCOTERMS
        ,       '-'                         AS TRANSPORT_MODE
        ,       '-'                         AS PROJECT_CODE
        ,       '-'                         AS FCST_TYPE
        ,       '-'                         AS CONFIRM_ID
        ,       P.DIVISION_ID               AS ORIGIN_FROM_DIVISION_ID
        ,       P.DIVISION_ID               AS ORIGIN_TO_DIVISION_ID
          FROM  SSP_FORMATION_POST_CELL_V P
                JOIN SCM_MST_SITE E
             ON E.DIVISION_ID = :V_DIVISION_ID
            AND NVL(E.COMPANY_ID, '-') = NVL(:V_COMPANY_ID, '-')
            AND E.DIVISION_ID = P.DIVISION_ID
            AND E.SCM_SITE_ID = P.SCM_SITE_ID
                LEFT OUTER JOIN SCM_MST_ITEM_SN IM
             ON IM.DIVISION_ID = P.DIVISION_ID
            AND IM.COMPANY_ID = :V_COMPANY_ID
            AND IM.SITE_ID = P.SITE_ID
            AND IM.ITEM_ID = P.CELL_ITEM_ID
            AND IM.ITEM_CLASS IN ('ES1901', 'ES2001','ES2002', 'ES2003', 'ES2004')
         WHERE  P.DIVISION_ID = :V_DIVISION_ID