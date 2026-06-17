        -- ============================================================
        -- ⭐ Phase 1 (2026-06-16): 6 룰 적용 — 99% bottleneck 영역
        --   - 룰 1: LISTAGG correlated subquery → FROM 절 OW LEFT JOIN
        --   - 룰 2: INNER JOIN B/C (LIKE split) 제거 → WHERE EXISTS GT_GGET_SPLIT_*
        --   - 룰 5: NVL(T2.FORECAST_INFO_CELL_MODEL,'')=T4.ITEM_ID → 직접 비교 (SARGable)
        --   - 룰 6: 'ALL'/'%'/'' 시 EXISTS skip (P_ITEM_ID / LP_PROJECT_CODE / P_OWNER)
        --
        -- 의미 1:1 보존 검증:
        --   - 'ALL' 시: Before LIKE '%ALL%' 0 row → 전체 제외 (FE 'ALL'=전체 의도 위반)
        --                After OR 분기 → 전체 row 통과 (정합 fix — 이전 사고 root cause)
        --   - 'specific' 시: Before/After 동일 (LIKE 매치 row 만 통과)
        -- ============================================================
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, T3.PROJECT_NAME
             , ''   AS CELL_MODEL      -- 20180809 ytchoi modify
             , T3.BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             -- ⭐ 룰 1: FROM 절 OW inline view 의 OWNER_NAME 참조 (correlated 제거)
             , OW.OWNER_NAME  AS OWNER
             , CASE WHEN F.DIVISION_ID NOT IN ('40') THEN T3.PROJECT_OWNER
                    ELSE J.USER_NAME_EN END AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
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
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME  -- 20190419 KHSONG (SELECT 절 NVL 은 유지 — SARGable 무관)
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
        -- ⭐ 룰 2: INNER JOIN B/C (LIKE split cartesian) 제거 → WHERE EXISTS GT_GGET_SPLIT_*
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES' AND S.VALID_YN = 'Y'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        -- [PJ2024-50461] Team Mapping
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO TEAM_DEPT
          ON   TEAM.DEPT_ID = TEAM_DEPT.DEPT_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K ON J.DEPT_ID = K.DEPT_ID
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        -- ⭐ 룰 5: NVL(T2.X,'')=T4.ITEM_ID → 직접 비교 (T4.ITEM_ID NOT NULL 이라 NULL row 어차피 매치 X)
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID  -- 20190419 KHSONG (NVL 제거)
        -- ⭐ 룰 1: FROM 절 OW inline view — F.OWNER 사전 집계 (correlated 제거)
        LEFT   JOIN (
                        SELECT OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                             , LISTAGG(ZA.USER_NAME_EN, ',') WITHIN GROUP (ORDER BY ZA.USER_NAME_EN) AS OWNER_NAME
                        FROM (
                            SELECT FF.DIVISION_ID, FF.PROJECT_CODE, FF.SCM_SITE_ID, FF.ITEM_ID
                                 , TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) AS TOK
                            FROM   SCM_MGR.SCM_MST_SITE_ITEM FF
                            CROSS JOIN ( SELECT LEVEL AS LV
                                         FROM DUAL CONNECT BY LEVEL <= 30 ) HIER
                            WHERE  FF.DIVISION_ID = P_DIVISION_ID
                              AND  FF.OWNER IS NOT NULL
                              AND  TRIM(REGEXP_SUBSTR(FF.OWNER, '[^,]+', 1, HIER.LV)) IS NOT NULL
                        ) OT
                        JOIN SCM_MGR.SCM_MST_SSO_USER_INFO ZA ON ZA.USER_ID = OT.TOK
                        GROUP BY OT.DIVISION_ID, OT.PROJECT_CODE, OT.SCM_SITE_ID, OT.ITEM_ID
                    ) OW
          ON   F.DIVISION_ID  = OW.DIVISION_ID
         AND   F.PROJECT_CODE = OW.PROJECT_CODE
         AND   F.SCM_SITE_ID  = OW.SCM_SITE_ID
         AND   F.ITEM_ID      = OW.ITEM_ID
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
          -- ⭐ 룰 6: P_OWNER 'ALL' 분기 추가 + EXISTS GT_GGET_SPLIT_OWNER
          AND  ( P_OWNER IS NULL OR P_OWNER IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_OWNER O WHERE F.OWNER = O.TOK) )
          -- ⭐ 룰 2+6: P_ITEM_ID — INNER JOIN B 제거 + EXISTS GT_GGET_SPLIT_ITEM_ID + 'ALL' short-circuit
          AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                                WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                                   OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
          -- ⭐ 룰 2+6: LP_PROJECT_CODE — INNER JOIN C 제거 + EXISTS GT_GGET_SPLIT_PROJECT_CODE + 'ALL' short-circuit
          AND  ( LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE C
                                WHERE F.PROJECT_CODE  LIKE '%' || C.TOK || '%'
                                   OR T3.PROJECT_NAME LIKE '%' || C.TOK || '%') );
