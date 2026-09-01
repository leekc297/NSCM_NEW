        INSERT INTO GT_DMF0053_ITEM_SINGLE_V
             ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME
             , ITEM_TYPE, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
             , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC
             , FORECAST_INFOR_VERSION, ENERGE, CELL_QUANTITY, MDM_PROJECT_NAME
             , CELL_TYPE, SCP_EXTRA_SPEC )
        SELECT DISTINCT A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS
             , A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MIN_CAPACITY
             , A.FORECAST_INFO_BIZ_TYPE, A.FORECAST_INFO_CELL_PACK_COUNT
             , A.FORECAST_INFO_PRODUCT_GROUP, A.FORECAST_INFO_CELL_MODEL
             , A.FORECAST_INFO_SPEC, A.FORECAST_INFOR_VERSION
             , A.ENERGE, A.CELL_QUANTITY, A.MDM_PROJECT_NAME, A.CELL_TYPE, A.SCP_EXTRA_SPEC
          FROM ( SELECT T1.DIVISION_ID
                      , T1.ITEM_ID
                      , MAX(T1.ITEM_NAME)       AS ITEM_NAME
                      , MAX(T1.ITEM_CLASS)      AS ITEM_CLASS
                      , MAX(T1.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
                      , MAX(T1.NICK_NAME)       AS NICK_NAME
                      , CASE MIN( CASE WHEN T1.ITEM_TYPE = 'P' THEN 1
                                       WHEN T1.ITEM_TYPE = 'H' THEN 2
                                       WHEN T1.ITEM_TYPE = 'Q' THEN 3
                                       ELSE 4 END )
                             WHEN 1 THEN 'P' WHEN 2 THEN 'H' WHEN 3 THEN 'Q' ELSE 'R' END AS ITEM_TYPE
                      , MAX(T1.MDM_PROJECT_NAME) AS MDM_PROJECT_NAME
                      , MAX(T1.MIN_CAPACITY)     AS MIN_CAPACITY
                      , MAX(T2.FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                      , MAX(T2.FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
                      , MAX(T2.FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
                      , MAX(T2.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                      , MAX(T2.FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
                      , MAX(T2.FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
                      , MAX(T2.CELL_TYPE)        AS CELL_TYPE
                      , MAX(T1.ENERGE)           AS ENERGE
                      , MAX(T1.CELL_QUANTITY)    AS CELL_QUANTITY
                      , MAX(T1.SCP_EXTRA_SPEC)   AS SCP_EXTRA_SPEC
                   FROM SCM_MST_ITEM_SN T1
                   JOIN ( SELECT DIVISION_ID, SUBSTR(ITEM_ID, 1, 12) AS ITEM_ID
                               , MAX(FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                               , MAX(FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
                               , MAX(FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
                               , MAX(FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                               , MAX(FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
                               , MAX(FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
                               , MAX(CELL_TYPE)                     AS CELL_TYPE
                            FROM SCM_MST_ITEM_SN S2
                           WHERE S2.DIVISION_ID = P_DIVISION_ID
                             AND EXISTS ( SELECT 1
                                            FROM GT_DMF0053_RAW_DATA R
                                           WHERE R.DIVISION_ID = S2.DIVISION_ID
                                             AND SUBSTR(R.ITEM_ID, 1, 12) = SUBSTR(S2.ITEM_ID, 1, 12) )
                           GROUP BY DIVISION_ID, SUBSTR(ITEM_ID, 1, 12)
                        ) T2
                     ON T1.DIVISION_ID = T2.DIVISION_ID
                    AND SUBSTR(T1.ITEM_ID, 1, 12) = T2.ITEM_ID
                  WHERE T1.DIVISION_ID = P_DIVISION_ID
                    AND EXISTS ( SELECT 1
                                   FROM GT_DMF0053_RAW_DATA R
                                  WHERE R.DIVISION_ID = T1.DIVISION_ID
                                    AND R.ITEM_ID     = T1.ITEM_ID )
                  GROUP BY T1.DIVISION_ID, T1.ITEM_ID
               ) A
          JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID FROM GT_DMF0053_RAW_DATA ) B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND A.ITEM_ID     = B.ITEM_ID
         WHERE A.DIVISION_ID = P_DIVISION_ID;
