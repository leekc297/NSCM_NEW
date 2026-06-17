        -- ============================================================
        -- ⭐ Phase 2 (2026-06-16): 6 룰 적용 — DIV='40' (소형 사업부) 분기
        --   Phase 1 과 동일 패턴 + DIV=40 전용 컬럼/JOIN 보존 (LOOKA / TEAM inline / DEPT_NAME_KO 등)
        -- ============================================================
        -- Division 40 (소형) 케이스
        INSERT INTO SCM_MGR.GT_GGET_SITE_ITEM_ALL
        SELECT F.DIVISION_ID, F.PROJECT_CODE, F.SCM_SITE_ID, F.ITEM_ID
             , T2.NICK_NAME, F.PROJECT_CODE  AS PROJECT_NAME
             , F.ATTRIBUTE5  AS CELL_MODEL   -- 20180810 ytchoi 조회속도개선
             , ''  AS BIZ_TYPE
             , S.END_CUSTOMER
             , S.SOLDTO_CUSTOMER
             , I.COUNTRY, I.COUNTRY_NAME
             , H.CITY, H.CITY_NAME
             -- ⭐ 룰 1: FROM 절 OW inline view 의 OWNER_NAME 참조 (correlated 제거)
             , OW.OWNER_NAME  AS OWNER
             , J.USER_NAME_EN  AS PROJECT_OWNER   -- 20180705
             , J.USER_ID
             , T2.ITEM_NAME, T2.ITEM_TYPE
             , ''  AS PROJECT_STATUS
             , F.CUST_GROUP, F.CUST_GROUP_DTL, F.APPLICATION, F.ROUTE
             , T2.MDM_PROJECT_NAME, TO_CHAR(T2.MIN_CAPACITY)
             -- [E20230720-001573] 40번사업부 AMDMO0001A모델의 경우 624로 셋팅요청
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                    ELSE T2.FORECAST_INFO_BIZ_TYPE END  AS FORECAST_INFO_BIZ_TYPE
             , T2.FORECAST_INFO_PRODUCT_GROUP
             , LOOK.NAME  AS CELL_TYPE
             , CASE WHEN F.ITEM_ID = LOOKA.MODEL THEN TO_NUMBER(LOOKA.CELL_PACK_COUNT)
                    ELSE T2.FORECAST_INFO_CELL_PACK_COUNT END  AS FORECAST_INFO_CELL_PACK_COUNT
             , T2.FORECAST_INFO_SPEC || T2.FORECAST_INFOR_VERSION  AS FORECAST_INFO_ALL
             , T2.FORECAST_INFO_SPEC
             , T2.FORECAST_INFOR_VERSION
             , NVL(T4.NICK_NAME,'')  AS CELL_MODEL_NICK_NAME
             , S.VMI_YN
             , NVL(F.ATTRIBUTE1,'')  AS DMS_SALES
             , NVL(F.ATTRIBUTE2,'')  AS DMS_CUSTOMER
             -- [PJ2024-50461] Team Mapping
             , TEAM.DEPT_ID
             , TEAM.DEPT_NAME_KO
             , F.CELL_PER_CAR
             , F.CELL_PER_MODULE
             , F.CELL_PER_CAR / CASE WHEN NVL(F.CELL_PER_MODULE,0) = 0 THEN 1
                                      ELSE F.CELL_PER_MODULE END  AS MODULE_PER_CAR
             , T2.ITEM_CLASS_NAME
             , T2.ENERGE
             , TO_CHAR(T2.CELL_QUANTITY)
             , F.VALID_YN  AS ITEM_VALID_YN
        FROM   SCM_MGR.SCM_MST_SITE_ITEM F
        JOIN   SCM_MGR.GT_GGET_ITEM_SINGLE_V T2
          ON   F.DIVISION_ID = T2.DIVISION_ID AND F.ITEM_ID = T2.ITEM_ID
        -- ⭐ 룰 2: INNER JOIN B/C (LIKE split) 제거 → WHERE EXISTS
        JOIN   SCM_MGR.SCM_MST_SITE S
          ON   F.DIVISION_ID = S.DIVISION_ID AND F.SCM_SITE_ID = S.SCM_SITE_ID
         AND   S.SITE_TYPE   = 'SALES'
        JOIN   SCM_MGR.SCM_MST_CITY H    ON S.CITY    = H.CITY
        JOIN   SCM_MGR.SCM_MST_COUNTRY I ON S.COUNTRY = I.COUNTRY
        LEFT   JOIN (
                        SELECT B.USER_ID, B.USER_NAME, B.USER_NAME_EN, B.DEPT_ID, C.DEPT_NAME_KO
                        FROM   SCM_MGR.SCM_MST_SSO_USER_INFO B
                        JOIN   SCM_MGR.SCM_MST_SSO_DEPT_INFO C ON B.DEPT_ID = C.DEPT_ID
                    ) TEAM
          ON   TEAM.USER_ID = TRIM(REGEXP_SUBSTR(F.OWNER,'[^,]+',1,1))
                                 -- 원본 IN (SELECT ... FROM DUAL) → 단일 row 비교로 변환 (의미 동등)
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_USER_INFO J
          ON   SUBSTR(F.OWNER, 1,
                      CASE WHEN INSTR(F.OWNER,',') = 0 THEN LENGTH(F.OWNER)
                           ELSE INSTR(F.OWNER,',') - 1 END) = J.USER_ID
        LEFT   JOIN SCM_MGR.SCM_MST_SSO_DEPT_INFO K
          ON   CASE WHEN F.DIVISION_ID IN ('40') THEN J.DEPT_ID
                    ELSE F.DEPT_ID END = K.DEPT_ID   -- 20190123 KHSONG
        LEFT   JOIN (
                        SELECT SEGMENT1 AS CODE, SEGMENT2 AS NAME
                        FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                        WHERE  LOOKUP_TYPE = 'CELL_TYPE'
                    ) LOOK ON LOOK.CODE = T2.CELL_TYPE
        -- ⭐ 룰 5: NVL(T2.X,'')=T4.ITEM_ID → 직접 비교
        LEFT   JOIN SCM_MGR.GT_GGET_ITEM_SINGLE_V T4
          ON   T2.DIVISION_ID = T4.DIVISION_ID
         AND   T2.FORECAST_INFO_CELL_MODEL = T4.ITEM_ID
        -- [E20230720-001573] 40번사업부 AMDMO0001A모델 BIZ_TYPE/CELL_PACK_COUNT LOOKUP 적용
        LEFT   JOIN (
                        SELECT A.MODEL, A.BIZ_TYPE, A.CELL_PACK_COUNT
                        FROM (
                            SELECT SEGMENT2 AS MODEL
                                 , SEGMENT3 AS BIZ_TYPE
                                 , SEGMENT4 AS CELL_PACK_COUNT
                                 , RANK() OVER (PARTITION BY SEGMENT2 ORDER BY DISPLAY_SEQ DESC) AS MODEL_RANK
                            FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL
                            WHERE  LOOKUP_TYPE = 'DM_BIZ_TYPE_40' AND SEGMENT1 = '40'
                        ) A WHERE MODEL_RANK = 1
                    ) LOOKA ON LOOKA.MODEL = F.ITEM_ID
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
                            WHERE  FF.DIVISION_ID = '40'
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
        WHERE  F.DIVISION_ID = '40'
          -- ⭐ 룰 2+6: LP_SCM_SITE_ID — CASE 패턴 유지 (Before 의 의미 1:1) — split 은 일반적인 동작 그대로
          AND  ( CASE WHEN LP_SCM_SITE_ID = 'ALL' THEN LP_SCM_SITE_ID
                      ELSE F.SCM_SITE_ID END
                 IN (SELECT TRIM(REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(LP_SCM_SITE_ID,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_CUSTOMER = 'ALL' THEN P_CUSTOMER
                      ELSE F.PROJECT_CODE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_CUSTOMER,'[^,]+',1,LEVEL) IS NOT NULL) )
          AND  ( CASE WHEN P_ITEM_TYPE = 'ALL' THEN P_ITEM_TYPE
                      ELSE T2.ITEM_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_ITEM_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- [E20230720-001573] BIZ_TYPE LOOKUP 우선 적용
          AND  ( CASE WHEN P_BIZ_TYPE = 'ALL' THEN P_BIZ_TYPE
                      WHEN F.ITEM_ID = LOOKA.MODEL THEN LOOKA.BIZ_TYPE
                      ELSE T2.FORECAST_INFO_BIZ_TYPE END
                 IN (SELECT TRIM(REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL))
                     FROM DUAL CONNECT BY REGEXP_SUBSTR(P_BIZ_TYPE,'[^,]+',1,LEVEL) IS NOT NULL) )
          -- ⭐ 룰 6: P_OWNER 'ALL' 분기 추가 + EXISTS GT_GGET_SPLIT_OWNER
          AND  ( P_OWNER IS NULL OR P_OWNER IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_OWNER O WHERE F.OWNER = O.TOK) )
          -- ⭐ 룰 2+6: P_ITEM_ID — INNER JOIN B 제거 + EXISTS + 'ALL' short-circuit
          AND  ( P_ITEM_ID IS NULL OR P_ITEM_ID IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID B
                                WHERE F.ITEM_ID    LIKE '%' || B.TOK || '%'
                                   OR T2.NICK_NAME LIKE '%' || B.TOK || '%') )
          -- ⭐ 룰 2+6: LP_PROJECT_CODE — INNER JOIN C 제거 + EXISTS + 'ALL' short-circuit
          --   원본: JOIN C ON F.PROJECT_CODE LIKE C.TST (PROJECT_NAME LIKE 분기 없음 — DIV=40)
          AND  ( LP_PROJECT_CODE IS NULL OR LP_PROJECT_CODE IN ('ALL','%','')
                   OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE C
                                WHERE F.PROJECT_CODE LIKE '%' || C.TOK || '%') );
