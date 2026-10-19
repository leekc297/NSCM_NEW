    IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
    NULL;  --[E20260930-DMF0082ONEREAD] 81/82 T_LAST_DATA_SETUP_PRICE 적재 제거 — 소비처(판가 INSERT)가 원장 1회 읽기 윈도 MAX 로 대체 (타임아웃 3d2xnx839ksnt · IDX02 힌트 철회)
--    INSERT INTO SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
--        (DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, CREATE_DATE, LAST_UPDATED_BY)
--    SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
--         , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE
--         , MAX(A.CREATION_DATE) AS CREATE_DATE
--         , MAX(A.LAST_UPDATED_BY) AS LAST_UPDATED_BY
--    FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
--    INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
--        ON  C.DIVISION_ID  = A.DIVISION_ID
--        AND C.PROJECT_CODE = A.PROJECT_CODE
--        AND C.SCM_SITE_ID  = A.SCM_SITE_ID
--        AND C.ITEM_ID      = A.ITEM_ID
--    WHERE  A.DIVISION_ID = p_division_id
--    AND    A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd
--    GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID
--           , A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE;
    ELSE

...
        -- 판가 (DM_PLN_CFM_SELLING_PRICE)
        IF (p_division_id LIKE '81%' OR p_division_id = '82') THEN  --[DIV81] 81 테이블 분기 (하단 ELSE=40 원문 무수정)
        INSERT INTO SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
        ( DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
        , MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD, QTY, MEASURE_GROUP
        , CELL_MODEL, NICK_NAME, DMS_SALES, DMS_CUSTOMER, OWNER, DEPT_ID, DEPT_NAME_KO
        , FORECAST_INFO_CELL_PACK_COUNT, ITEM_TYPE, PROJECT_NAME, PROJECT_OWNER, BIZ_TYPE
        , SOLDTO_CUSTOMER, COUNTRY_NAME, CITY_NAME, PROJECT_STATUS, ITEM_NAME, VMI_YN
        , CUST_GROUP, CUST_GROUP_DTL, APPLICATION, ROUTE, MDM_PROJECT_NAME, MIN_CAPACITY
        , FORECAST_INFO_BIZ_TYPE, CELL_TYPE, FORECAST_INFO_ALL, FORECAST_INFO_SPEC
        , FORECAST_INFOR_VERSION, CELL_MODEL_NICK_NAME, CELL_PER_CAR, CELL_PER_MODULE
        , MODULE_PER_CAR, SORT_ORDER_NO, ENERGE, CELL_QUANTITY, AS_FROM_SITE
        , CREATE_DATE, LAST_UPDATED_BY, SENDER_CODE, SENDER_NAME, PROJECT_S_OP_REPORT
        , CURRENCY, VERSION_NO, CUTOFF_YYYYMMDD, NOTATION)
        --[E20260930-DMF0082ONEREAD] 구본 (IDX02 힌트 + T_LAST_DATA_SETUP_PRICE LD 조인) — 아래 신 SELECT 로 대체
--        SELECT /*+ INDEX(A IDX02_SCM_MST_FUTURE_PRICE) */ A.DIVISION_ID
--             , A.PROJECT_CODE
--             , A.PROJECT_CODE AS END_CUSTOMER  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
--             , A.SCM_SITE_ID
--             , A.ITEM_ID
--             , A.DOM_EXP
--             , A.FCST_TYPE
--             , A.INCOTERMS
--             , A.MEASURE
--             , A.PLANT_SITE_ID
--             , '-' AS CELL_PROD_SITE_ID  --[DIV81] 컬럼 부재
--             , A.YYYYMMDD
--             , NVL(A.PRICE, 0)
--             , B.MEASURE_GROUP
--             , C.CELL_MODEL
--             , C.NICK_NAME
--             , C.DMS_SALES
--             , C.DMS_CUSTOMER
--             , C.OWNER
--             , C.DEPT_ID
--             , C.DEPT_NAME_KO
--             , C.FORECAST_INFO_CELL_PACK_COUNT
--             , C.ITEM_TYPE
--             , C.PROJECT_NAME
--             , C.PROJECT_OWNER
--             , C.BIZ_TYPE
--             , C.SOLDTO_CUSTOMER
--             , C.COUNTRY_NAME
--             , C.CITY_NAME
--             , C.PROJECT_STATUS
--             , C.ITEM_NAME
--             , C.VMI_YN
--             , C.CUST_GROUP
--             , C.CUST_GROUP_DTL
--             , C.APPLICATION
--             , C.ROUTE
--             , C.MDM_PROJECT_NAME
--             , C.MIN_CAPACITY
--             , C.FORECAST_INFO_BIZ_TYPE
--             , C.CELL_TYPE
--             , C.FORECAST_INFO_ALL
--             , C.FORECAST_INFO_SPEC
--             , C.FORECAST_INFOR_VERSION
--             , C.CELL_MODEL_NICK_NAME
--             , C.CELL_PER_CAR
--             , C.CELL_PER_MODULE
--             , C.MODULE_PER_CAR
--             , B.SORT_ORDER_NO
--             , C.ENERGE
--             , C.CELL_QUANTITY
--             , ' ' AS AS_FROM_SITE  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
--             , LD.CREATE_DATE
--             , LD.LAST_UPDATED_BY
--             , '' AS SENDER_CODE
--             , '' AS SENDER_NAME
--             , C.PROJECT_S_OP_REPORT
--             , A.CURRENCY
--             , 'Current' AS VERSION_NO
--             , NULL AS CUTOFF_YYYYMMDD
--             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS NOTATION
--        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
--        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
--            ON  B.MEASURE = A.MEASURE
--        LEFT JOIN ( -- [FIX 2026-07-13] 행별 LATERAL(FETCH FIRST 1) → set-based GROUP BY (키별 최신 CREATE_DATE+짝 LAST_UPDATED_BY). 의미동일.
--                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
--                     , MAX(CREATE_DATE) AS CREATE_DATE
--                     , MAX(LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY CREATE_DATE) AS LAST_UPDATED_BY
--                FROM   SCM_MGR.GT_DMF0082_T_LAST_DATA_SETUP_PRICE
--                GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
--            ) LD
--                ON  LD.DIVISION_ID  = A.DIVISION_ID
--                AND LD.PROJECT_CODE = A.PROJECT_CODE
--                AND LD.SCM_SITE_ID  = A.SCM_SITE_ID
--                AND LD.ITEM_ID      = A.ITEM_ID
--                AND LD.DOM_EXP      = A.DOM_EXP
--                AND LD.FCST_TYPE    = A.FCST_TYPE
--                AND LD.INCOTERMS    = A.INCOTERMS
--                AND LD.MEASURE      = A.MEASURE
--        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
--            ON  C.DIVISION_ID  = A.DIVISION_ID
--            AND C.PROJECT_CODE = A.PROJECT_CODE
--            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
--            AND C.ITEM_ID      = A.ITEM_ID
--            AND C.ITEM_VALID_YN = 'Y'
--        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
--            ON  D.FCST_TYPE = A.FCST_TYPE
--        WHERE  1 = 1
--        AND    A.DIVISION_ID = p_division_id
--        AND    A.YYYYMMDD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413)
        /*[E20260930-DMF0082ONEREAD] 판가 원장 1회 읽기 — 구 L1249(T_LAST_DATA_SETUP_PRICE 적재) 제거분의 최신 수정일자·수정자를
           키 8개 PARTITION 윈도 MAX 로 여기서 계산 (구 LD 조인과 등가 · IDX02 힌트 철회). 출력 범위는 바깥 WHERE (구 조건 그대로)*/
        SELECT C01, C02, C03, C04, C05, C06, C07, C08, C09, C10, C11, C12, C13, C14, C15, C16, C17, C18, C19, C20, C21, C22, C23, C24, C25, C26, C27, C28, C29, C30, C31, C32, C33, C34, C35, C36, C37, C38, C39, C40, C41, C42, C43, C44, C45, C46, C47, C48, C49, C50, C51, C52, C53, C54, C55, C56, C57, C58, C59, C60
        FROM (
        SELECT A.DIVISION_ID AS C01
             , A.PROJECT_CODE AS C02
             , A.PROJECT_CODE AS C03  --[DIV81] 81 규약: END_CUSTOMER=PROJECT_CODE
             , A.SCM_SITE_ID AS C04
             , A.ITEM_ID AS C05
             , A.DOM_EXP AS C06
             , A.FCST_TYPE AS C07
             , A.INCOTERMS AS C08
             , A.MEASURE AS C09
             , A.PLANT_SITE_ID AS C10
             , '-' AS C11  --[DIV81] 컬럼 부재
             , A.YYYYMMDD AS C12
             , NVL(A.PRICE, 0) AS C13
             , B.MEASURE_GROUP AS C14
             , C.CELL_MODEL AS C15
             , C.NICK_NAME AS C16
             , C.DMS_SALES AS C17
             , C.DMS_CUSTOMER AS C18
             , C.OWNER AS C19
             , C.DEPT_ID AS C20
             , C.DEPT_NAME_KO AS C21
             , C.FORECAST_INFO_CELL_PACK_COUNT AS C22
             , C.ITEM_TYPE AS C23
             , C.PROJECT_NAME AS C24
             , C.PROJECT_OWNER AS C25
             , C.BIZ_TYPE AS C26
             , C.SOLDTO_CUSTOMER AS C27
             , C.COUNTRY_NAME AS C28
             , C.CITY_NAME AS C29
             , C.PROJECT_STATUS AS C30
             , C.ITEM_NAME AS C31
             , C.VMI_YN AS C32
             , C.CUST_GROUP AS C33
             , C.CUST_GROUP_DTL AS C34
             , C.APPLICATION AS C35
             , C.ROUTE AS C36
             , C.MDM_PROJECT_NAME AS C37
             , C.MIN_CAPACITY AS C38
             , C.FORECAST_INFO_BIZ_TYPE AS C39
             , C.CELL_TYPE AS C40
             , C.FORECAST_INFO_ALL AS C41
             , C.FORECAST_INFO_SPEC AS C42
             , C.FORECAST_INFOR_VERSION AS C43
             , C.CELL_MODEL_NICK_NAME AS C44
             , C.CELL_PER_CAR AS C45
             , C.CELL_PER_MODULE AS C46
             , C.MODULE_PER_CAR AS C47
             , B.SORT_ORDER_NO AS C48
             , C.ENERGE AS C49
             , C.CELL_QUANTITY AS C50
             , ' ' AS C51  --[E20260820-AFSNULL] 판가 행 '-' 표기 폐지(사용자 지시)
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.CREATION_DATE END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS C52
             , MAX(CASE WHEN A.YYYYMMDD BETWEEN p_from_yyyymmdd AND p_to_yyyymmdd THEN A.LAST_UPDATED_BY END) OVER (PARTITION BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE) AS C53
             , '' AS C54
             , '' AS C55
             , C.PROJECT_S_OP_REPORT AS C56
             , A.CURRENCY AS C57
             , 'Current' AS C58
             , NULL AS C59
             , CASE WHEN A.MEASURE IN ('KRW','USD','LOC','MKT_AMT_LOC','MKT_AMT_KRW') THEN 'POINT3' ELSE 'INTEGER' END AS C60
             , A.YYYYMMDD AS X_ONEREAD_YMD
        FROM   SCM_MGR.SCM_MST_FUTURE_PRICE A
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SELECT_MEASURE B
            ON  B.MEASURE = A.MEASURE
        INNER JOIN SCM_MGR.GT_DMF0082_TEMP_SITE_ITEM C
            ON  C.DIVISION_ID  = A.DIVISION_ID
            AND C.PROJECT_CODE = A.PROJECT_CODE
            AND C.SCM_SITE_ID  = A.SCM_SITE_ID
            AND C.ITEM_ID      = A.ITEM_ID
            AND C.ITEM_VALID_YN = 'Y'
        INNER JOIN SCM_MGR.GT_DMF0082_T_WS_FCST D
            ON  D.FCST_TYPE = A.FCST_TYPE
        WHERE  1 = 1
        AND    A.DIVISION_ID = p_division_id
        AND    A.YYYYMMDD BETWEEN LEAST(V_TO_RESULT, p_from_yyyymmdd) AND GREATEST(V_TO_YYYYMMDD, p_to_yyyymmdd)
        ) WHERE X_ONEREAD_YMD BETWEEN V_TO_RESULT AND V_TO_YYYYMMDD;  -- [DATE ROOT FIX 2026-07-12] 판가=계획구간만(AS-IS 2086/3413) — 구 조건 그대로
        ELSE
