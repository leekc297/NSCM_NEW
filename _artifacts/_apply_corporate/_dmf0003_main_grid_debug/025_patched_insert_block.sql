        -- ⭐ Rank 1~3 patch (2026-06-16): 99% bottleneck 영역 보강.
        --   - Rank 1: INNER JOIN B/C (LIKE cartesian) → WHERE EXISTS + 'ALL' 분기 (LIKE 의미 1:1 보존)
        --   - Rank 2: LISTAGG 의 DISTINCT 제거 (단일 결과라 무의미)
        --   - Rank 3: J/K JOIN 제거 (TEAM 과 동일 user + K 미사용)
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, T3.PROJECT_NAME
             , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
             , T3.BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             , ( SELECT LISTAGG(ZA.USER_NAME_EN,',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN)
                 FROM   SCM_MGR.SCM_MST_SSO_USER_INFO ZA
                 WHERE  ZA.USER_ID IN (
                     SELECT TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(F.OWNER,'[^,]+',1,LEVEL) IS NOT NULL
                 )
               ) AS OWNER
             , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
                    ELSE TEAM.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705 (J → TEAM 통합)
             , TEAM.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , T3.PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             , T2.FORECAST_INFO_BIZ_TYPE, T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE   -- 20180911 LookUp TABLE JOIN
             , T2.FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES    -- 20190213 KHSONG
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER -- 20190213 KHSONG
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM_DEPT.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE  -- [E20260123-001715] 원소스 복원
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        JOIN   SCM_MGR.SCM_MST_PROJECT T3
          ON   F.DIVISION_ID = T3.DIVISION_ID AND F.PROJECT_CODE = T3.PROJECT_CODE
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        -- [PJ2024-50461] Team Mapping (Rank 3 patch: J/K JOIN 제거 — TEAM 으로 통합)
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
          ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   NVL(T2.FORECAST_INFO_CELL_MODEL,'') = T4.ITEM_ID  -- 20190419 KHSONG
        WHERE  F.DIVISION_ID <> '40'   -- hard coding (20190123 KHSONG)
          AND  F.DIVISION_ID = P_DIVISION_ID
          -- [E20260211-001189] SCM_SITE_ID 조건 주석처리
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE S.END_CUSTOMER END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      ELSE T3.BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( ( P_OWNER IS NULL OR P_OWNER = '' )
                   OR F.OWNER IN (SELECT TRIM(REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL))
                                  FROM DUAL CONNECT BY REGEXP_SUBSTR(P_OWNER,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- ⭐ Rank 1 patch: P_ITEM_ID 'ALL' 분기 + EXISTS (LIKE 의미 1:1 보존)
          AND  ( P_ITEM_ID IN ('ALL','%')
                 OR EXISTS (
                       SELECT 1
                       FROM (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL)) AS TOK
                             FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_ID,'[^,]+',1,LEVEL) IS NOT NULL) B
                       WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                          OR T2.NICK_NAME LIKE '%' || B.TOK || '%'
                    ) )
          AND  ( LP_PROJECT_CODE IN ('ALL','%') OR LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE = ''
                 OR EXISTS (
                       SELECT 1
                       FROM (SELECT TRIM(REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL)) AS TOK
                             FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_PROJECT_CODE,'[^,]+',1,LEVEL) IS NOT NULL) C
                       WHERE F.PROJECT_CODE  LIKE '%' || C.TOK || '%'
                          OR T3.PROJECT_NAME LIKE '%' || C.TOK || '%'
                    ) );
