        INSERT INTO GT_DMF0053_ITEM_SINGLE_V
             ( DIVISION_ID, ITEM_ID, ITEM_CLASS, ITEM_NAME, ITEM_CLASS_NAME, NICK_NAME
             , ITEM_TYPE, MIN_CAPACITY, FORECAST_INFO_BIZ_TYPE, FORECAST_INFO_CELL_PACK_COUNT
             , FORECAST_INFO_PRODUCT_GROUP, FORECAST_INFO_CELL_MODEL, FORECAST_INFO_SPEC
             , FORECAST_INFOR_VERSION, ENERGE, CELL_QUANTITY, MDM_PROJECT_NAME
             , CELL_TYPE, SCP_EXTRA_SPEC )
        -- [E20260827-ITEMSTAT] GTT(RAW_DATA) 무통계 → 옵티마이저가 1행으로 보고 NESTED LOOPS + VIEW PUSHED PREDICATE
        --   + MERGE JOIN CARTESIAN 을 택해 SCM_ITEM_M PK 를 조합마다 INDEX SKIP SCAN (사내 실측 81: 25분+ 미완·UGA 폭주,
        --   같은 조건 단독 실행은 0.2초). 상관 EXISTS 를 GTT 선계산 키 집합(MATERIALIZE)과의 HASH JOIN 으로 바꿔
        --   GTT 카디널리티와 무관한 플랜으로 고정한다. 결과 집합은 동일 — 키 집합이 DISTINCT 라 행 배수가 없고,
        --   T2 는 (사업부, 앞 12자리) 유일이라 원본의 MAX(T2.x) 와 T2.x 가 같다.
        WITH RI AS ( SELECT /*+ MATERIALIZE */ DISTINCT R.DIVISION_ID, R.ITEM_ID
                       FROM GT_DMF0053_RAW_DATA R
                      WHERE R.DIVISION_ID = P_DIVISION_ID )
           , RI12 AS ( SELECT /*+ MATERIALIZE */ DISTINCT R.DIVISION_ID, SUBSTR(R.ITEM_ID, 1, 12) AS ITEM12
                         FROM GT_DMF0053_RAW_DATA R
                        WHERE R.DIVISION_ID = P_DIVISION_ID )
           , T2 AS ( SELECT /*+ NO_MERGE LEADING(RI12 S2) USE_HASH(S2) */
                            S2.DIVISION_ID, SUBSTR(S2.ITEM_ID, 1, 12) AS ITEM_ID
                          , MAX(S2.FORECAST_INFO_BIZ_TYPE)        AS FORECAST_INFO_BIZ_TYPE
                          , MAX(S2.FORECAST_INFO_PRODUCT_GROUP)   AS FORECAST_INFO_PRODUCT_GROUP
                          , MAX(S2.FORECAST_INFO_CELL_MODEL)      AS FORECAST_INFO_CELL_MODEL
                          , MAX(S2.FORECAST_INFO_CELL_PACK_COUNT) AS FORECAST_INFO_CELL_PACK_COUNT
                          , MAX(S2.FORECAST_INFO_SPEC)            AS FORECAST_INFO_SPEC
                          , MAX(S2.FORECAST_INFOR_VERSION)        AS FORECAST_INFOR_VERSION
                          , MAX(S2.CELL_TYPE)                     AS CELL_TYPE
                       FROM RI12
                       JOIN SCM_MST_ITEM_SN S2
                         ON S2.DIVISION_ID = RI12.DIVISION_ID
                        AND SUBSTR(S2.ITEM_ID, 1, 12) = RI12.ITEM12
                      WHERE S2.DIVISION_ID = P_DIVISION_ID
                      GROUP BY S2.DIVISION_ID, SUBSTR(S2.ITEM_ID, 1, 12) )
           , T1 AS ( SELECT /*+ NO_MERGE LEADING(RI T1) USE_HASH(T1) */
                            T1.DIVISION_ID
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
                          , MAX(T1.ENERGE)           AS ENERGE
                          , MAX(T1.CELL_QUANTITY)    AS CELL_QUANTITY
                          , MAX(T1.SCP_EXTRA_SPEC)   AS SCP_EXTRA_SPEC
                       FROM RI
                       JOIN SCM_MST_ITEM_SN T1
                         ON T1.DIVISION_ID = RI.DIVISION_ID
                        AND T1.ITEM_ID     = RI.ITEM_ID
                      WHERE T1.DIVISION_ID = P_DIVISION_ID
                      GROUP BY T1.DIVISION_ID, T1.ITEM_ID )
        SELECT /*+ USE_HASH(A T2) */
               A.DIVISION_ID, A.ITEM_ID, A.ITEM_CLASS
             , A.ITEM_NAME, A.ITEM_CLASS_NAME, A.NICK_NAME, A.ITEM_TYPE, A.MIN_CAPACITY
             , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_PRODUCT_GROUP, T2.FORECAST_INFO_CELL_MODEL
             , T2.FORECAST_INFO_SPEC, T2.FORECAST_INFOR_VERSION
             , A.ENERGE, A.CELL_QUANTITY, A.MDM_PROJECT_NAME, T2.CELL_TYPE, A.SCP_EXTRA_SPEC
          FROM T1 A
          JOIN T2
            ON T2.DIVISION_ID = A.DIVISION_ID
           AND T2.ITEM_ID     = SUBSTR(A.ITEM_ID, 1, 12)
         WHERE A.DIVISION_ID = P_DIVISION_ID;
