# -*- coding: utf-8 -*-
"""[E20261104-DMF0082ONEQUERY] S3 — 편집권한·MF_SP·후처리·PIVOT 을 동적 SQL 1 문장으로 (PL/SQL 블록 텍스트).
   원문 L4431~4649 (편집권한 GTT 2 + UPDATE 5) · L4657~4675 (달력 GTT 2 — 결과 무영향, 제거) · L4686~4828 (MF_SP INSERT)
   · L4848~4956 (ATTR1 MERGE) · L4972~5036 (후처리 3) · L5076~5226 (숨김 열 대표값 2) · L5235~5262 (LAST_UPD 동적 MERGE)
   · L5273~5332 (O_RC1 5 arm PIVOT) · L5372~5375 (O_RC4).
   사전 그룹핑: G1 = MSP 는 참조 열만 MAX · G2 = 표시키×일 DISP(SUM, COUNT) 1회 집계 후 5 arm (AVG = SUM/COUNT)."""

S3_PLSQL = r"""    /* [E20261104-DMF0082ONEQUERY] S3 — 편집권한·MF_SP·후처리·PIVOT 을 동적 SQL 1 문장으로. 원문 대응은 STEP_MAP.md. */
    DECLARE
        V_Q        CLOB;
        V_ADMQ     CLOB;                              -- INTOG/ADM0/ADM CTE (O_RC1 · O_RC4 공용)
        V_NEEDS    VARCHAR2(32767);                   -- ',COL,' 참조 토큰 (V_COLUMN ∪ V_GROUPBY ∪ V_ORDERBY ∪ LU 키)
        V_COLS     VARCHAR2(32767);                   -- 현재 단계 열 목록 (콤마, 공백 없음)
        V_MSPSEL   CLOB;
        V_GB       VARCHAR2(4000);
        V_PREV     VARCHAR2(30);
        V_HAS_AFS  BOOLEAN := FALSE;
        V_HAS_LU   BOOLEAN := FALSE;
        V_HIDE_CP  BOOLEAN := FALSE;
        V_HIDE_PL  BOOLEAN := FALSE;
        V_MSP_ID   BOOLEAN := FALSE;   -- MSP 집계가 항등(입력 그레인이 이미 11키×일 유일)인지 — 실행 시 실측 판정
        V_DUPK     NUMBER;
        V_DUPC     NUMBER;
        V_AS_YN    VARCHAR2(1) := 'N';
        V_CNT      NUMBER;
        V_LU_KEYS  VARCHAR2(4100 CHAR);
        V_DISPK    VARCHAR2(32767);
        -- [E20261105-DMF0082ONEQUERY-KIDPIVOT] 피벗 그룹 키(V_COLUMN + SORT_ORDER_NO) 를 정수 KID_ 로 압축 — 사용자 제안(2026-11-05 "pivot 전에 pivot 에 맞도록 group")
        V_PK       VARCHAR2(32767);   -- 피벗 그룹 키 열 목록(= V_COLUMN ∪ SORT_ORDER_NO · 중복 제거)
        V_GX       VARCHAR2(32767);   -- arm GROUP BY 에만 있고 PK 에 없는 열(V_GB − PK · 예: EDIT_FLAG)
        V_REST     VARCHAR2(32767);   -- DISPK 가 KID_ 외에 실을 열(GX ∪ NOTATION·MEASURE·YYYYMM·YYYYMMWW·WEEK_END_YN·MONTH_END_YN·BUCKET_KEY)
        V_KJOIN    VARCHAR2(32767);   -- DISP↔KEYS NULL 안전 등가(SYS_OP_MAP_NONNULL · 해시 조인 가능 · NULL↔값 충돌 없음)
        V_QF       CONSTANT VARCHAR2(200) := q'{((X.MEASURE NOT IN ('SCM_FCST','FCST_GAP') AND X.QTY <> 0) OR X.MEASURE IN ('SCM_FCST','FCST_GAP'))}';
        V_K10      CONSTANT VARCHAR2(400) := q'{NVL(X.DIVISION_ID,'/'), NVL(X.PROJECT_CODE,'/'), NVL(X.END_CUSTOMER,'/'), NVL(X.SCM_SITE_ID,'/'), NVL(X.ITEM_ID,'/'), NVL(X.DOM_EXP,'/'), NVL(X.FCST_TYPE,'/'), NVL(X.INCOTERMS,'/'), NVL(X.PLANT_SITE_ID,'/'), NVL(X.CELL_PROD_SITE_ID,'/')}';
        V_K8T      CONSTANT VARCHAR2(400) := q'{NVL(X.DIVISION_ID,'~'), NVL(X.PROJECT_CODE,'~'), NVL(X.END_CUSTOMER,'~'), NVL(X.SCM_SITE_ID,'~'), NVL(X.ITEM_ID,'~'), NVL(X.DOM_EXP,'~'), NVL(X.FCST_TYPE,'~'), NVL(X.INCOTERMS,'~')}';
        V_K10A     CONSTANT VARCHAR2(800) := q'{NVL(X.DIVISION_ID,'/') AS K1, NVL(X.PROJECT_CODE,'/') AS K2, NVL(X.END_CUSTOMER,'/') AS K3, NVL(X.SCM_SITE_ID,'/') AS K4, NVL(X.ITEM_ID,'/') AS K5, NVL(X.DOM_EXP,'/') AS K6, NVL(X.FCST_TYPE,'/') AS K7, NVL(X.INCOTERMS,'/') AS K8, NVL(X.PLANT_SITE_ID,'/') AS K9, NVL(X.CELL_PROD_SITE_ID,'/') AS K10}';
        V_K10J     CONSTANT VARCHAR2(800) := q'{NVL(X.DIVISION_ID,'/') = R.K1 AND NVL(X.PROJECT_CODE,'/') = R.K2 AND NVL(X.END_CUSTOMER,'/') = R.K3 AND NVL(X.SCM_SITE_ID,'/') = R.K4 AND NVL(X.ITEM_ID,'/') = R.K5 AND NVL(X.DOM_EXP,'/') = R.K6 AND NVL(X.FCST_TYPE,'/') = R.K7 AND NVL(X.INCOTERMS,'/') = R.K8 AND NVL(X.PLANT_SITE_ID,'/') = R.K9 AND NVL(X.CELL_PROD_SITE_ID,'/') = R.K10}';
        V_K8A      CONSTANT VARCHAR2(600) := q'{NVL(X.DIVISION_ID,'~') AS K1, NVL(X.PROJECT_CODE,'~') AS K2, NVL(X.END_CUSTOMER,'~') AS K3, NVL(X.SCM_SITE_ID,'~') AS K4, NVL(X.ITEM_ID,'~') AS K5, NVL(X.DOM_EXP,'~') AS K6, NVL(X.FCST_TYPE,'~') AS K7, NVL(X.INCOTERMS,'~') AS K8}';
        V_K8J      CONSTANT VARCHAR2(600) := q'{NVL(X.DIVISION_ID,'~') = R.K1 AND NVL(X.PROJECT_CODE,'~') = R.K2 AND NVL(X.END_CUSTOMER,'~') = R.K3 AND NVL(X.SCM_SITE_ID,'~') = R.K4 AND NVL(X.ITEM_ID,'~') = R.K5 AND NVL(X.DOM_EXP,'~') = R.K6 AND NVL(X.FCST_TYPE,'~') = R.K7 AND NVL(X.INCOTERMS,'~') = R.K8}';

        FUNCTION LIT(p IN VARCHAR2) RETURN VARCHAR2 IS
        BEGIN RETURN '''' || REPLACE(p, '''', '''''') || ''''; END;

        FUNCTION NEED(p IN VARCHAR2) RETURN BOOLEAN IS
        BEGIN RETURN INSTR(V_NEEDS, ',' || p || ',') > 0; END;

        FUNCTION HASCOL(p IN VARCHAR2) RETURN BOOLEAN IS
        BEGIN RETURN INSTR(',' || V_COLS || ',', ',' || p || ',') > 0; END;

        -- 현재 열 목록을 X. 접두로 투영하되 최대 3개 열을 식으로 치환
        FUNCTION PROJ(p_n1 VARCHAR2 DEFAULT NULL, p_e1 VARCHAR2 DEFAULT NULL
                    , p_n2 VARCHAR2 DEFAULT NULL, p_e2 VARCHAR2 DEFAULT NULL
                    , p_n3 VARCHAR2 DEFAULT NULL, p_e3 VARCHAR2 DEFAULT NULL) RETURN CLOB IS
            v   CLOB; tok VARCHAR2(200); n PLS_INTEGER := REGEXP_COUNT(V_COLS, '[^,]+');
        BEGIN
            FOR i IN 1 .. n LOOP
                tok := REGEXP_SUBSTR(V_COLS, '[^,]+', 1, i);
                v := v || CASE WHEN i > 1 THEN ', ' END
                       || CASE WHEN tok = p_n1 THEN p_e1 || ' AS ' || tok
                               WHEN tok = p_n2 THEN p_e2 || ' AS ' || tok
                               WHEN tok = p_n3 THEN p_e3 || ' AS ' || tok
                               ELSE 'X.' || tok END;
            END LOOP;
            RETURN v;
        END;
    BEGIN
        -- 참조 열 토큰 (식별자 경계만 남긴다)
        V_NEEDS := ',' || REGEXP_REPLACE(UPPER(V_COLUMN || ',' || V_GROUPBY || ',' || V_ORDERBY), '[^A-Z0-9_]+', ',') || ',';
        IF NEED('TEAM_ID')                  THEN V_NEEDS := V_NEEDS || 'DEPT_ID,'; END IF;
        IF NEED('TEAM_NAME_KO')             THEN V_NEEDS := V_NEEDS || 'DEPT_NAME_KO,'; END IF;
        IF NEED('FORECAST_INFO_CELL_MODEL') THEN V_NEEDS := V_NEEDS || 'CELL_MODEL,'; END IF;
        IF NEED('LAST_UPDATE_DATE')         THEN V_NEEDS := V_NEEDS || 'CREATE_DATE,'; END IF;
        V_HAS_AFS := INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',AS_FROM_SITE,') > 0;                       -- L4992
        V_HAS_LU  := INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',LAST_UPDATED_BY,') > 0
                  OR INSTR(',' || REPLACE(V_COLUMN, ' ', '') || ',', ',LAST_UPDATE_DATE,') > 0;                   -- L5235
        IF V_HAS_LU THEN V_NEEDS := V_NEEDS || 'CREATE_DATE,LAST_UPDATED_BY,'; END IF;

        -- L5076~5102 CELL_PROD_SITE_ID 숨김 판정 / L5161~5182 PLANT_SITE_ID 숨김 판정 (원문 그대로)
        SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = VA_PROGRAM_ID AND U.SHEET_NAME = VA_SHEET_NAME AND U.USER_ID = p_created_by
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' AND U.COLUMN_NAME = 'CELL_PROD_SITE_ID';
        IF V_CNT = 0 THEN
            SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = VA_PROGRAM_ID AND C.SHEET_NAME = VA_SHEET_NAME AND C.COLUMN_NAME = 'CELL_PROD_SITE_ID'
               AND C.VALID_YN = 'Y' AND C.USER_SELECTABLE_FLAG = 'N' AND C.VISIBLE_FLAG = 'Y'
               AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0);
        END IF;
        V_HIDE_CP := (V_CNT = 0);
        SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_TITLESET_USER U
         WHERE U.PROGRAM_ID = VA_PROGRAM_ID AND U.SHEET_NAME = VA_SHEET_NAME AND U.USER_ID = p_created_by
           AND U.USER_INQUIRY_COLUMN_TYPE_CODE = 'C' AND U.COLUMN_NAME = 'PLANT_SITE_ID';
        IF V_CNT = 0 THEN
            SELECT COUNT(*) INTO V_CNT FROM SCM_MGR.SCM_MST_SHEET_COLUMNS C
             WHERE C.PROGRAM_ID = VA_PROGRAM_ID AND C.SHEET_NAME = VA_SHEET_NAME AND C.COLUMN_NAME = 'PLANT_SITE_ID'
               AND C.VALID_YN = 'Y' AND C.USER_SELECTABLE_FLAG = 'N' AND C.VISIBLE_FLAG = 'Y'
               AND (C.DIVISION_ID IS NULL OR INSTR(',' || C.DIVISION_ID || ',', ',' || p_division_id || ',') > 0);
        END IF;
        V_HIDE_PL := (V_CNT = 0);

        -- [E20261104-DMF0082ONEQUERY] MSP 항등 판정 — 원문 L4686 MF_SP INSERT 의 GROUP BY 키(11키+일+MEASURE_GROUP+SORT_ORDER_NO+달력·PVT 열)는
        --   (a) TEMP_FCST_N_PRICE 가 11키×YYYYMMDD 로 유일하고 (b) 달력이 일자당 1행이면 한 그룹 = 한 행이라 MAX/SUM 이 항등이다.
        --   (PVT·VD 는 GROUP BY 산출이라 구조적으로 키당 1행.) 두 조건을 매 실행 실측해 참일 때만 집계 없이 투영한다
        --   — 82 실측(11-04 19:00) 451,287행 → 451,287행(축소 0)인데 HASH GROUP BY 가 TEMP 1.0GB 를 썼다.
        SELECT COUNT(*) INTO V_DUPK FROM (
            SELECT 1 FROM SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE
            GROUP BY DIVISION_ID, PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
            HAVING COUNT(*) > 1) WHERE ROWNUM = 1;
        SELECT COUNT(*) INTO V_DUPC FROM (
            SELECT 1 FROM SCM_MGR.SCM_SYS_CALENDAR_M
            WHERE BASIS_YYYYMMDD BETWEEN p_from_yyyymmdd AND V_EXP_YYYYMMDD
            GROUP BY BASIS_YYYYMMDD HAVING COUNT(*) > 1) WHERE ROWNUM = 1;
        V_MSP_ID := (V_DUPK = 0 AND V_DUPC = 0);

        -- L4760~4764 AS_YN (비상관 — 1회 판정)
        IF p_scm_site_id IS NULL OR p_scm_site_id = 'ALL' THEN
            V_AS_YN := 'N';
        ELSE
            SELECT CASE WHEN COUNT(*) > 0 THEN 'Y' ELSE 'N' END INTO V_AS_YN
              FROM (SELECT TOKEN FROM SCM_MGR.GT_DMF0082_PARAM_TOKEN WHERE PARAM_NM = 'p_scm_site_id') SA
              JOIN SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL SB
                ON SA.TOKEN = SB.SEGMENT1 AND SB.LOOKUP_TYPE = 'AS_SITE_PLANT';
        END IF;

        -- L5238~5248 LU 키 (원문 그대로)
        IF V_HAS_LU THEN
            DECLARE
                V_LU_SRC  VARCHAR2(4100 CHAR) := REPLACE(V_COLUMN, ' ', '') || ',SORT_ORDER_NO';
                V_LU_COL  VARCHAR2(200 CHAR);
            BEGIN
                FOR I IN 1 .. REGEXP_COUNT(V_LU_SRC, '[^,]+') LOOP
                    V_LU_COL := REGEXP_SUBSTR(V_LU_SRC, '[^,]+', 1, I);
                    IF V_LU_COL NOT IN ('LAST_UPDATED_BY', 'LAST_UPDATE_DATE', 'CREATE_DATE')
                    AND INSTR(',' || V_LU_KEYS || ',', ',' || V_LU_COL || ',') = 0 THEN
                        V_LU_KEYS := CASE WHEN V_LU_KEYS IS NULL THEN V_LU_COL ELSE V_LU_KEYS || ', ' || V_LU_COL END;
                    END IF;
                END LOOP;
            END;
        END IF;

        -- ───────── ADM CTE (L4437~4647) ─────────
        V_ADMQ := q'{INTOG AS (
    SELECT B.USER_GROUP, B.DIVISION_ID, B.MEASURE, B.DAYS, B.FROM_TIME, B.TO_TIME, LM.TOKEN AS LIMIT_MEASURE
    FROM  (SELECT A.SEGMENT1 AS USER_GROUP, A.SEGMENT3 AS DIVISION_ID, A.SEGMENT4 AS MEASURE, DT.TOKEN AS DAYS
                , A.ATTRIBUTE2 AS FROM_TIME, A.ATTRIBUTE3 AS TO_TIME, A.ATTRIBUTE4 AS LIMIT_MEASURE
           FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
           CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(A.ATTRIBUTE1, '[^,]+', 1, LEVEL) AS TOKEN
                               FROM   DUAL
                               CONNECT BY LEVEL <= NVL(REGEXP_COUNT(A.ATTRIBUTE1, ','), 0) + 1) DT
           WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
           AND    A.VALID_YN = 'Y'
           AND (A.SEGMENT1 = [UG]
             OR A.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                             WHERE G.USER_ID IN ([UG], [CB]) AND G.USE_YN = 'Y'))
           AND    A.SEGMENT2 = [PG]
           AND    A.SEGMENT3 = [DV]
          ) B
    CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(B.LIMIT_MEASURE, '[^,]+', 1, LEVEL) AS TOKEN
                        FROM   DUAL
                        CONNECT BY LEVEL <= NVL(REGEXP_COUNT(B.LIMIT_MEASURE, ','), 0) + 1) LM
    WHERE (REPLACE(B.DAYS, ' ', '') IS NULL
           OR B.DAYS = TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH'))
    AND   (REPLACE(B.FROM_TIME, ' ', '') IS NULL
           OR B.FROM_TIME <= TO_CHAR(SYSDATE, 'HH24MI'))
    AND   (REPLACE(B.TO_TIME, ' ', '') IS NULL
           OR B.TO_TIME >= TO_CHAR(SYSDATE, 'HH24MI'))
), ADM0 AS (
    SELECT A.SEGMENT4 AS MEASURE
         , CASE WHEN EXISTS (SELECT 1 FROM INTOG B WHERE B.MEASURE = A.SEGMENT4) THEN 'Y'
                WHEN EXISTS (
                    SELECT 1
                    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL T
                    WHERE  T.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                    AND    T.VALID_YN = 'Y'
                    AND   (T.SEGMENT1 = [UG]
                           OR T.SEGMENT1 IN (SELECT G.USER_GR_ID FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                             WHERE G.USER_ID IN ([UG], [CB]) AND G.USE_YN = 'Y'))
                    AND    T.SEGMENT2 = [PG]
                    AND    T.SEGMENT3 = [DV]
                    AND    T.SEGMENT4 = A.SEGMENT4
                    AND    REPLACE(T.ATTRIBUTE1, ' ', '') IS NOT NULL
               ) THEN 'T'
                ELSE 'N' END AS EDIT_AUTH_YN
         , CASE WHEN A.ATTRIBUTE1 IS NOT NULL THEN 'Y' ELSE 'N' END AS TODAY_LIMIT_YN
         , A.ATTRIBUTE1 AS TODAY_DAY_LIST
    FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL A
    WHERE  A.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
    AND    A.VALID_YN    = 'Y'
    AND    A.SEGMENT2    = [PG]
    GROUP BY A.SEGMENT4, A.ATTRIBUTE1
), ADM AS (
    SELECT A.MEASURE, A.TODAY_LIMIT_YN, A.TODAY_DAY_LIST
         , CASE WHEN A.E4 = 'Y'
                 AND EXISTS (SELECT 1 FROM INTOG B WHERE B.MEASURE = A.MEASURE)
                 AND NOT EXISTS (
                     SELECT 1
                     FROM   INTOG B
                     WHERE  B.MEASURE = A.MEASURE
                     AND    NOT EXISTS (
                              SELECT 1
                              FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L2
                              WHERE  L2.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                              AND    L2.VALID_YN    = 'Y'
                              AND    L2.SEGMENT2    = [PG]
                              AND    L2.SEGMENT3    = [DV]
                              AND    L2.SEGMENT4    = B.MEASURE
                              AND    L2.SEGMENT1    = B.LIMIT_MEASURE
                              AND    REPLACE(L2.ATTRIBUTE1, ' ', '') IS NOT NULL
                              AND    INSTR(',' || REPLACE(L2.ATTRIBUTE1, ' ', '') || ',',
                                           ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0
                              AND    L2.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI')
                              AND    L2.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI')))
                THEN 'N' ELSE A.E4 END AS EDIT_AUTH_YN
    FROM (
        SELECT A.*
             , CASE WHEN EXISTS (SELECT 1
                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                   CROSS JOIN LATERAL (SELECT REGEXP_SUBSTR(L.ATTRIBUTE4, '[^,]+', 1, LEVEL) AS TOKEN
                                       FROM   DUAL
                                       CONNECT BY LEVEL <= NVL(REGEXP_COUNT(L.ATTRIBUTE4, ','), 0) + 1) LM
                   WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                   AND    L.VALID_YN    = 'Y'
                   AND    L.SEGMENT2    = [PG]
                   AND    L.SEGMENT3    = [DV]
                   AND    REPLACE(L.ATTRIBUTE4, ' ', '') IS NOT NULL
                   AND   (REPLACE(L.ATTRIBUTE1, ' ', '') IS NULL
                          OR INSTR(',' || REPLACE(L.ATTRIBUTE1, ' ', '') || ',',
                                   ',' || TO_CHAR(SYSDATE, 'DY', 'NLS_DATE_LANGUAGE=ENGLISH') || ',') > 0)
                   AND   (REPLACE(L.ATTRIBUTE2, ' ', '') IS NULL
                          OR L.ATTRIBUTE2 <= TO_CHAR(SYSDATE, 'HH24MI'))
                   AND   (REPLACE(L.ATTRIBUTE3, ' ', '') IS NULL
                          OR L.ATTRIBUTE3 >= TO_CHAR(SYSDATE, 'HH24MI'))
                   AND    TRIM(LM.TOKEN) = A.MEASURE
                   AND    NOT EXISTS (SELECT 1
                                      FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L3
                                      WHERE  L3.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                                      AND    L3.VALID_YN    = 'Y'
                                      AND    L3.SEGMENT2    = [PG]
                                      AND    L3.SEGMENT3    = [DV]
                                      AND    L3.SEGMENT1    = TRIM(LM.TOKEN)))
                    THEN 'N' ELSE A.E3 END AS E4
        FROM (
            SELECT A.*
                 , CASE WHEN A.MEASURE = 'VMI_In_Req'
                        THEN CASE WHEN [DV] IN ('40', '82')
                                   AND NOT ( ( [UG] IN ('DM Viewer', 'SCP Planner')
                                               OR EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                          WHERE G.USER_ID IN ([UG], [CB])
                                                          AND   G.USER_GR_ID IN ('DM Viewer', 'SCP Planner') AND G.USE_YN = 'Y') )
                                             AND NOT EXISTS (SELECT 1 FROM INTOG B WHERE B.MEASURE = 'VMI_In_Req') )
                                  THEN 'Y' ELSE 'N' END
                        ELSE A.E2 END AS E3
            FROM (
                SELECT A.*
                     , CASE WHEN A.MEASURE = 'AS_In_Req'
                            THEN CASE WHEN ([DV] LIKE '81%' OR [DV] = '82')
                                       AND EXISTS (SELECT 1 FROM SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                   WHERE G.USER_ID IN ([UG], [CB])
                                                   AND   G.USER_GR_ID = 'DM Planner (W/S)' AND G.USE_YN = 'Y')
                                      THEN 'Y' ELSE 'N' END
                            ELSE A.E1 END AS E2
                FROM (
                    SELECT A.*
                         , CASE WHEN A.MEASURE = 'LOC'
                                 AND ( NOT EXISTS (SELECT 1
                                                   FROM   SCM_MGR.SCM_ADM_LOOKUP_MASTER_DETAIL L
                                                   WHERE  L.LOOKUP_TYPE = 'GET_ADMIN_GROUP_MEASURE'
                                                   AND    L.VALID_YN    = 'Y'
                                                   AND    L.SEGMENT2    = [PG]
                                                   AND    L.SEGMENT3    = [DV])
                                       OR ( [DV] NOT LIKE '81%'
                                            AND NOT ( [UG] = 'SCP Planner'
                                                OR EXISTS (SELECT 1
                                                           FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                           WHERE  G.USER_ID    IN ([UG], [CB])
                                                           AND    G.USER_GR_ID = 'SCP Planner'
                                                           AND    G.USE_YN     = 'Y') )
                                            AND NOT ( [UG] = 'DM Viewer'
                                                OR EXISTS (SELECT 1
                                                           FROM   SCM_MGR.SCM_ADM_USER_GR_MPG_M G
                                                           WHERE  G.USER_ID    IN ([UG], [CB])
                                                           AND    G.USER_GR_ID = 'DM Viewer'
                                                           AND    G.USE_YN     = 'Y') ) ) )
                                THEN 'Y' ELSE A.EDIT_AUTH_YN END AS E1
                    FROM ADM0 A
                ) A
            ) A
        ) A
    ) A
)}';
        V_ADMQ := REPLACE(V_ADMQ, '[UG]', LIT(p_user_group));
        V_ADMQ := REPLACE(V_ADMQ, '[CB]', LIT(p_created_by));
        V_ADMQ := REPLACE(V_ADMQ, '[PG]', LIT(VA_PROGRAM_ID));
        V_ADMQ := REPLACE(V_ADMQ, '[DV]', LIT(p_division_id));

        -- ───────── O_RC4 (L5372~5375) ─────────
        OPEN O_RC4 FOR 'WITH ' || V_ADMQ || ' SELECT MEASURE, EDIT_AUTH_YN, TODAY_LIMIT_YN, TODAY_DAY_LIST FROM ADM ORDER BY MEASURE';

        -- ───────── MSP (L4688~4828) — 참조 열만 MAX (G1) ─────────
        V_COLS := 'DIVISION_ID,PROJECT_CODE,END_CUSTOMER,SCM_SITE_ID,ITEM_ID,DOM_EXP,FCST_TYPE,INCOTERMS,MEASURE,PLANT_SITE_ID,CELL_PROD_SITE_ID,BUCKET_TYPE,BUCKET_KEY,QTY,MEASURE_GROUP';
        V_MSPSEL := q'{F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID, F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID, F.CELL_PROD_SITE_ID
         , CAL.BUCKET_TYPE, CAL.BUCKET_KEY, }' || CASE WHEN V_MSP_ID THEN 'F.QTY' ELSE 'SUM(F.QTY)' END || q'{ AS QTY, F.MEASURE_GROUP}';
        FOR R IN (SELECT COLUMN_VALUE AS C FROM TABLE(SYS.ODCIVARCHAR2LIST(
                    'CELL_MODEL','NICK_NAME','DMS_SALES','DMS_CUSTOMER','OWNER','DEPT_ID','DEPT_NAME_KO'
                   ,'FORECAST_INFO_CELL_PACK_COUNT','ITEM_TYPE','PROJECT_NAME','PROJECT_OWNER','BIZ_TYPE'
                   ,'SOLDTO_CUSTOMER','COUNTRY_NAME','CITY_NAME','PROJECT_STATUS','ITEM_NAME','VMI_YN'
                   ,'CUST_GROUP','CUST_GROUP_DTL','APPLICATION','ROUTE','MDM_PROJECT_NAME','MIN_CAPACITY'
                   ,'FORECAST_INFO_BIZ_TYPE','CELL_TYPE','FORECAST_INFO_ALL','FORECAST_INFO_SPEC'
                   ,'FORECAST_INFOR_VERSION','CELL_MODEL_NICK_NAME','CELL_PER_CAR','CELL_PER_MODULE','MODULE_PER_CAR'
                   ,'ENERGE','CELL_QUANTITY','CREATE_DATE','LAST_UPDATED_BY','SENDER_CODE','SENDER_NAME','PROJECT_S_OP_REPORT'
                   ,'VERSION_NO','CUTOFF_YYYYMMDD'))) LOOP
            IF NEED(R.C) THEN
                -- 숫자 속성은 MF_SP 열 타입 NUMBER(20,10) 으로 CAST — 원문 커서가 GTT 열 타입(20,10)을 보고하던 것과 같게 (집계 결과는 타입이 NUMBER 로 풀려 클라이언트 표현이 달라짐 · 11-04 실측 20.0 vs 20)
                IF R.C IN ('FORECAST_INFO_CELL_PACK_COUNT', 'MIN_CAPACITY', 'CELL_PER_CAR', 'CELL_PER_MODULE', 'MODULE_PER_CAR', 'CELL_QUANTITY') THEN
                    V_MSPSEL := V_MSPSEL || CHR(10) || '         , CAST(' || CASE WHEN V_MSP_ID THEN 'F.' || R.C ELSE 'MAX(F.' || R.C || ')' END || ' AS NUMBER(20,10)) AS ' || R.C;
                ELSE
                    V_MSPSEL := V_MSPSEL || CHR(10) || '         , ' || CASE WHEN V_MSP_ID THEN 'F.' || R.C ELSE 'MAX(F.' || R.C || ')' END || ' AS ' || R.C;
                END IF;
                V_COLS   := V_COLS || ',' || R.C;
            END IF;
        END LOOP;
        V_MSPSEL := V_MSPSEL || q'{
         , F.SORT_ORDER_NO
         , NVL(}' || CASE WHEN V_MSP_ID THEN 'F.AS_FROM_SITE' ELSE 'MAX(F.AS_FROM_SITE)' END || q'{, ' ') AS AS_FROM_SITE
         , }' || CASE WHEN V_MSP_ID THEN 'F.CURRENCY' ELSE 'MAX(F.CURRENCY)' END || q'{ AS CURRENCY
         , }' || CASE WHEN V_MSP_ID THEN 'F.NOTATION' ELSE 'MAX(F.NOTATION)' END || q'{ AS NOTATION
         , CASE WHEN [DV] = '82' THEN 'N'
                WHEN [GRP] = 'ADMIN' THEN 'Y'
                WHEN EXISTS (
                    SELECT 1 FROM ADM MA
                    WHERE  MA.MEASURE = F.MEASURE
                    AND    MA.EDIT_AUTH_YN = 'Y'
                    AND   (MA.TODAY_LIMIT_YN = 'N'
                           OR (MA.TODAY_LIMIT_YN = 'Y'
                               AND INSTR(
                                       REPLACE(TRIM(MA.TODAY_DAY_LIST),' ',''),
                                       CASE TO_NUMBER(TO_CHAR(SYSDATE,'D'))
                                           WHEN 1 THEN 'SUN' WHEN 2 THEN 'MON'
                                           WHEN 3 THEN 'TUE' WHEN 4 THEN 'WED'
                                           WHEN 5 THEN 'THU' WHEN 6 THEN 'FRI'
                                           WHEN 7 THEN 'SAT'
                                       END) > 0))
                ) THEN 'Y'
                ELSE 'N'
           END AS EDIT_FLAG
         , '999' AS SORT_KEY
         , CAST(NULL AS VARCHAR2(50)) AS GROUP_ID
         , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
         , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN}';
        V_COLS := V_COLS || ',SORT_ORDER_NO,AS_FROM_SITE,CURRENCY,NOTATION,EDIT_FLAG,SORT_KEY,GROUP_ID,SUN,MON,TUE,WED,THU,FRI,SAT,YYYYMM,YYYYMMWW,WEEK_END_YN,MONTH_END_YN';
        IF NEED('NEW_FLAG')    THEN V_MSPSEL := V_MSPSEL || q'{
         , 'N' AS NEW_FLAG}';                                   V_COLS := V_COLS || ',NEW_FLAG';    END IF;
        IF NEED('AS_YN')       THEN V_MSPSEL := V_MSPSEL || q'{
         , [ASYN] AS AS_YN}';                                   V_COLS := V_COLS || ',AS_YN';       END IF;
        IF NEED('VMI_STD_DIO') THEN V_MSPSEL := V_MSPSEL || CHR(10) || '         , '
            || CASE WHEN V_MSP_ID THEN 'VD.VMI_STD_DIO' ELSE 'MAX(VD.VMI_STD_DIO)' END || ' AS VMI_STD_DIO'; V_COLS := V_COLS || ',VMI_STD_DIO'; END IF;
        IF NEED('ATTR1')       THEN V_MSPSEL := V_MSPSEL || q'{
         , CAST(NULL AS VARCHAR2(4000)) AS ATTR1}';             V_COLS := V_COLS || ',ATTR1';       END IF;
        -- M7 용 행 식별자 (원문 L5257 MERGE 가 MF_SP.ROWID 로 갱신하던 것과 동형) — 두 열 표시 시에만 운반
        IF V_HAS_LU THEN V_MSPSEL := V_MSPSEL || CHR(10) || '         , '
            || CASE WHEN V_MSP_ID THEN 'F.ROWID' ELSE 'MIN(F.ROWID)' END || ' AS RID_'; V_COLS := V_COLS || ',RID_'; END IF;

        DBMS_LOB.CREATETEMPORARY(V_Q, TRUE);
        V_Q := 'WITH ' || V_ADMQ || q'{
, CAL AS (  /* L4768~4797 (주 달력 GTT 조인 WE 는 결과 무영향 — 제거) */
    SELECT D.BASIS_YYYYMMDD
         , TO_CHAR(D.BASIS_YYYYMMDD) AS BUCKET_KEY
         , 'D' AS BUCKET_TYPE
         , D.BASIS_YYYYMM AS YYYYMM
         , D.BASIS_YYYYMM || LPAD(TRIM(D.ISO_WEEK), 2, '0') AS YYYYMMWW
         , CASE WHEN WE2.WEEK_END_DATE  IS NOT NULL THEN 'Y' ELSE 'N' END AS WEEK_END_YN
         , CASE WHEN ME.MONTH_END_DATE IS NOT NULL THEN 'Y' ELSE 'N' END AS MONTH_END_YN
    FROM   SCM_MGR.SCM_SYS_CALENDAR_M D
    LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS WEEK_END_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD BETWEEN [FROM] AND [TO]
               GROUP BY BASIS_YYYYMM, ISO_WEEK) WE2
        ON  WE2.WEEK_END_DATE = D.BASIS_YYYYMMDD
    LEFT JOIN (SELECT MAX(BASIS_YYYYMMDD) AS MONTH_END_DATE
               FROM   SCM_MGR.SCM_SYS_CALENDAR_M
               WHERE  BASIS_YYYYMMDD BETWEEN [FROM] AND [TO]
               GROUP BY BASIS_YYYYMM) ME
        ON  ME.MONTH_END_DATE = D.BASIS_YYYYMMDD
    WHERE  D.BASIS_YYYYMMDD BETWEEN [FROM] AND [EXP]
), PVT AS (  /* L4802~4815 */
    SELECT BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS
         , MAX(CASE WHEN BC.YYYYMMDD = 'SUN' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS SUN
         , MAX(CASE WHEN BC.YYYYMMDD = 'MON' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS MON
         , MAX(CASE WHEN BC.YYYYMMDD = 'TUE' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS TUE
         , MAX(CASE WHEN BC.YYYYMMDD = 'WED' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS WED
         , MAX(CASE WHEN BC.YYYYMMDD = 'THU' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS THU
         , MAX(CASE WHEN BC.YYYYMMDD = 'FRI' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS FRI
         , MAX(CASE WHEN BC.YYYYMMDD = 'SAT' THEN CASE WHEN BC.BUCKET_PER = 'Y' THEN 1 ELSE 0 END END) AS SAT
    FROM   SCM_MGR.DM_MST_BUCKET_CONVERSION BC
    GROUP BY BC.DIVISION_ID, BC.SCM_SITE_ID, BC.INCOTERMS
)}';
        IF NEED('VMI_STD_DIO') THEN
            V_Q := V_Q || q'{
, VD AS (  /* L4816~4822 */
    SELECT S.SCM_SITE_ID, MAX(S.VMI_YN || '^' || NVL(TO_CHAR(S.ATTRIBUTE5),'')) AS VMI_STD_DIO
    FROM   SCM_MGR.SCM_MST_SITE S
    WHERE  S.DIVISION_ID = '82'
    AND    [DV] = '82'
    GROUP BY S.SCM_SITE_ID
)}';
        END IF;
        V_Q := V_Q || q'{
, MSP AS (
    SELECT }' || V_MSPSEL || q'{
    FROM   SCM_MGR.GT_DMF0082_TEMP_FCST_N_PRICE F
    INNER JOIN CAL ON CAL.BASIS_YYYYMMDD = F.YYYYMMDD
    LEFT JOIN PVT ON  PVT.DIVISION_ID = F.DIVISION_ID
                  AND PVT.SCM_SITE_ID = F.SCM_SITE_ID
                  AND PVT.INCOTERMS   = F.INCOTERMS}'
            || CASE WHEN NEED('VMI_STD_DIO') THEN q'{
    LEFT JOIN VD ON VD.SCM_SITE_ID = F.SCM_SITE_ID}' END
            || CASE WHEN V_MSP_ID THEN q'{
    /* MSP 항등 경로: 11키×일 유일 실측 — GROUP BY 생략 */}' ELSE q'{
    GROUP BY F.DIVISION_ID, F.PROJECT_CODE, F.END_CUSTOMER, F.SCM_SITE_ID, F.ITEM_ID
           , F.DOM_EXP, F.FCST_TYPE, F.INCOTERMS, F.MEASURE, F.PLANT_SITE_ID
           , F.CELL_PROD_SITE_ID, CAL.BUCKET_TYPE, CAL.BUCKET_KEY, F.MEASURE_GROUP
           , F.SORT_ORDER_NO
           , PVT.SUN, PVT.MON, PVT.TUE, PVT.WED, PVT.THU, PVT.FRI, PVT.SAT
           , CAL.YYYYMM, CAL.YYYYMMWW, CAL.WEEK_END_YN, CAL.MONTH_END_YN}' END || q'{
)}';
        V_PREV := 'MSP';

        -- M1 (L4972~4983): AS_FROM_SITE 는 이미 NVL ' ' · CELL_PROD '/'·공백 → '-'
        V_Q := V_Q || CHR(10) || ', M1 AS (SELECT ' || PROJ('CELL_PROD_SITE_ID',
                 q'{CASE WHEN X.CELL_PROD_SITE_ID = '/' OR (X.CELL_PROD_SITE_ID IS NOT NULL AND TRIM(X.CELL_PROD_SITE_ID) IS NULL) THEN '-' ELSE X.CELL_PROD_SITE_ID END}')
              || ' FROM ' || V_PREV || ' X)';
        V_PREV := 'M1';

        -- M2 (L4848~4952): ATTR1 — 결과 열에 있을 때만 (40 / 82)
        IF NEED('ATTR1') AND p_division_id IN ('40', '82') THEN
            V_Q := V_Q || CHR(10) || ', ATTR1S AS (' ||
              CASE WHEN p_division_id = '40' THEN q'{
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
                || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
                || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
                || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
                || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
                || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
                || '^' || NVL(A31,'') AS ATTR1
            FROM (
                SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, A.FCST_TYPE, INCOTERMS
                     , YYYYMMDD || '/'
                       || CASE
                              WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                               AND A.QTY >
                                   CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE3,'0'),'^[0-9.]+$')
                                        THEN TO_NUMBER(ATTRIBUTE3) ELSE 0 END
                                 + CASE WHEN REGEXP_LIKE(NVL(ATTRIBUTE2,'0'),'^[0-9.]+$')
                                        THEN TO_NUMBER(ATTRIBUTE2) ELSE 0 END
                              THEN 'P'
                              ELSE 'A'
                          END AS SYNC_YN
                     , 'A' || TO_CHAR(
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                            DOM_EXP, A.FCST_TYPE, INCOTERMS
                               ORDER BY YYYYMMDD
                           )) AS ROW_NUM
                FROM   SCM_MGR.DM_PLN_MKT_FCST A
                WHERE  A.DIVISION_ID = [DV]
                  AND  A.MEASURE     = 'MKT_FCST'
                  AND  A.YYYYMMDD   BETWEEN [VFROM] AND [TO]
                  AND  ( A.ATTRIBUTE4 IS NOT NULL OR A.ATTRIBUTE5 IS NOT NULL )
                  AND  A.QTY <> 0
            ) A
            PIVOT (
                MAX(SYNC_YN) FOR ROW_NUM IN (
                    'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                    'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                    'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                    'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                    'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                    'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                    'A31' A31
                )
            ))}' ELSE q'{
            SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS
                 , NVL(A1,'')  || '^' || NVL(A2,'')  || '^' || NVL(A3,'')  || '^' || NVL(A4,'')  || '^' || NVL(A5,'')
                || '^' || NVL(A6,'')  || '^' || NVL(A7,'')  || '^' || NVL(A8,'')  || '^' || NVL(A9,'')  || '^' || NVL(A10,'')
                || '^' || NVL(A11,'') || '^' || NVL(A12,'') || '^' || NVL(A13,'') || '^' || NVL(A14,'') || '^' || NVL(A15,'')
                || '^' || NVL(A16,'') || '^' || NVL(A17,'') || '^' || NVL(A18,'') || '^' || NVL(A19,'') || '^' || NVL(A20,'')
                || '^' || NVL(A21,'') || '^' || NVL(A22,'') || '^' || NVL(A23,'') || '^' || NVL(A24,'') || '^' || NVL(A25,'')
                || '^' || NVL(A26,'') || '^' || NVL(A27,'') || '^' || NVL(A28,'') || '^' || NVL(A29,'') || '^' || NVL(A30,'')
                || '^' || NVL(A31,'') AS ATTR1
            FROM (
                SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                DOM_EXP, FCST_TYPE, INCOTERMS
                     , YYYYMMDD || '/A' AS SYNC_YN
                     , 'A' || TO_CHAR(
                           ROW_NUMBER() OVER (
                               PARTITION BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                                            DOM_EXP, FCST_TYPE, INCOTERMS
                               ORDER BY YYYYMMDD
                           )) AS ROW_NUM
                FROM   SCM_MGR.DM_PLN_PR_DETAIL A
                WHERE  A.DIVISION_ID = [DV]
                  AND  A.YYYYMMDD   BETWEEN [VFROM] AND [TO]
            ) A
            PIVOT (
                MAX(SYNC_YN) FOR ROW_NUM IN (
                    'A1'  A1,  'A2'  A2,  'A3'  A3,  'A4'  A4,  'A5'  A5,
                    'A6'  A6,  'A7'  A7,  'A8'  A8,  'A9'  A9,  'A10' A10,
                    'A11' A11, 'A12' A12, 'A13' A13, 'A14' A14, 'A15' A15,
                    'A16' A16, 'A17' A17, 'A18' A18, 'A19' A19, 'A20' A20,
                    'A21' A21, 'A22' A22, 'A23' A23, 'A24' A24, 'A25' A25,
                    'A26' A26, 'A27' A27, 'A28' A28, 'A29' A29, 'A30' A30,
                    'A31' A31
                )
            ))}' END;
            V_Q := V_Q || CHR(10) || ', M2 AS (SELECT ' || PROJ('ATTR1', 'S.ATTR1') || ' FROM ' || V_PREV || q'{ X
            LEFT JOIN ATTR1S S
              ON (    X.DIVISION_ID  = S.DIVISION_ID
                  AND X.PROJECT_CODE = S.PROJECT_CODE
                  AND X.SCM_SITE_ID  = S.SCM_SITE_ID
                  AND X.ITEM_ID      = S.ITEM_ID
                  AND X.DOM_EXP      = S.DOM_EXP
                  AND X.FCST_TYPE    = S.FCST_TYPE
                  AND X.INCOTERMS    = S.INCOTERMS))}';
            V_PREV := 'M2';
        END IF;

        -- M3 (L4992~5017): MKT_FCST 의 AS_FROM_SITE 를 같은 10키 타 메저 빈 행에 복사 (결과 열에 AS_FROM_SITE 있을 때만)
        --   원문 MERGE 동형: 10키(NVL '/') 좁은 집계(HAVING COUNT(DISTINCT)=1) + LEFT JOIN (윈도판은 넓은 행 전량 WINDOW SORT · apply #7)
        IF V_HAS_AFS THEN
            V_Q := V_Q || CHR(10) || ', M3R AS (SELECT ' || V_K10A
                || ', MAX(X.AS_FROM_SITE) AS AFS_MX_'
                || ' FROM ' || V_PREV || q'{ X WHERE X.MEASURE = 'MKT_FCST' AND RTRIM(X.AS_FROM_SITE, ' -/') IS NOT NULL}'
                || ' GROUP BY ' || V_K10 || ' HAVING COUNT(DISTINCT X.AS_FROM_SITE) = 1)';
            V_Q := V_Q || CHR(10) || ', M3 AS (SELECT ' || PROJ('AS_FROM_SITE',
                 q'{CASE WHEN X.MEASURE <> 'MKT_FCST' AND RTRIM(X.AS_FROM_SITE, ' -/') IS NULL AND R.AFS_MX_ IS NOT NULL THEN R.AFS_MX_ ELSE X.AS_FROM_SITE END}')
                || ' FROM ' || V_PREV || ' X LEFT JOIN M3R R ON (' || V_K10J || '))';
            V_PREV := 'M3';
        END IF;

        -- M4 (L5025~5036): 수량 메저 CURRENCY 빈값 → ' '
        V_Q := V_Q || CHR(10) || ', M4 AS (SELECT ' || PROJ('CURRENCY',
             q'{CASE WHEN X.MEASURE NOT IN ('LOC', 'KRW', 'USD', 'MKT_AMT_LOC', 'MKT_AMT_KRW') AND (X.CURRENCY IS NULL OR TRIM(X.CURRENCY) IS NULL OR TRIM(X.CURRENCY) = '/') THEN ' ' ELSE X.CURRENCY END}')
            || ' FROM ' || V_PREV || ' X)';
        V_PREV := 'M4';

        -- M5 (L5104~5146): 숨긴 CELL_PROD_SITE_ID 대표값 (10키 NVL '~' · 계획구간 우선 최신 · 2종 이상일 때만)
        --   원문 MERGE 와 같은 형태: 10키(NVL '~') 좁은 집계(HAVING) → LEFT JOIN 으로 대표값 적용.
        --   (윈도 함수판은 넓은 행 전부를 WINDOW SORT 로 TEMP 재기록 — 82 실측 11-04 19:00 각 35,307·33,994 블록, 약 5s 씩)
        IF V_HIDE_CP THEN
            V_Q := V_Q || CHR(10) || ', M5R AS (SELECT ' || V_K8A
                || q'{, NVL(X.PLANT_SITE_ID,'~') AS K9, NVL(X.MEASURE,'~') AS K10}'
                || q'{, MAX(X.CELL_PROD_SITE_ID) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN X.BUCKET_KEY >= [TOR] THEN 1 ELSE 0 END, X.BUCKET_KEY) AS CP_REP_}'
                || ' FROM ' || V_PREV || ' X WHERE X.CELL_PROD_SITE_ID IS NOT NULL'
                || ' GROUP BY ' || V_K8T || q'{, NVL(X.PLANT_SITE_ID,'~'), NVL(X.MEASURE,'~')}'
                || ' HAVING COUNT(DISTINCT X.CELL_PROD_SITE_ID) > 1)';
            V_Q := V_Q || CHR(10) || ', M5 AS (SELECT ' || PROJ('CELL_PROD_SITE_ID', 'CASE WHEN R.CP_REP_ IS NOT NULL THEN R.CP_REP_ ELSE X.CELL_PROD_SITE_ID END')
                || ' FROM ' || V_PREV || ' X LEFT JOIN M5R R ON (' || V_K8J
                || q'{ AND NVL(X.PLANT_SITE_ID,'~') = R.K9 AND NVL(X.MEASURE,'~') = R.K10))}';
            V_PREV := 'M5';
        END IF;

        -- M6 (L5184~5226): 숨긴 PLANT_SITE_ID 대표값 (10키 NVL '~' · 비NULL 1건 이상이면 전 행 대표값) — M5 와 같은 집계+LEFT JOIN 형태
        IF V_HIDE_PL THEN
            V_Q := V_Q || CHR(10) || ', M6R AS (SELECT ' || V_K8A
                || q'{, NVL(X.CELL_PROD_SITE_ID,'~') AS K9, NVL(X.MEASURE,'~') AS K10}'
                || q'{, MAX(X.PLANT_SITE_ID) KEEP (DENSE_RANK LAST ORDER BY CASE WHEN X.BUCKET_KEY >= [TOR] THEN 1 ELSE 0 END, X.BUCKET_KEY) AS PL_REP_}'
                || ' FROM ' || V_PREV || ' X WHERE X.PLANT_SITE_ID IS NOT NULL'
                || ' GROUP BY ' || V_K8T || q'{, NVL(X.CELL_PROD_SITE_ID,'~'), NVL(X.MEASURE,'~')}'
                || q'{ HAVING COUNT(DISTINCT NVL(X.PLANT_SITE_ID,'~')) >= 1)}';
            V_Q := V_Q || CHR(10) || ', M6 AS (SELECT ' || PROJ('PLANT_SITE_ID', 'CASE WHEN R.PL_REP_ IS NOT NULL THEN R.PL_REP_ ELSE X.PLANT_SITE_ID END')
                || ' FROM ' || V_PREV || ' X LEFT JOIN M6R R ON (' || V_K8J
                || q'{ AND NVL(X.CELL_PROD_SITE_ID,'~') = R.K9 AND NVL(X.MEASURE,'~') = R.K10))}';
            V_PREV := 'M6';
        END IF;

        -- SRCA (L5324 SRC0 별칭 투영)
        V_Q := V_Q || CHR(10) || ', SRCA AS (SELECT X.*'
            || CASE WHEN HASCOL('DEPT_ID')      THEN ', X.DEPT_ID AS TEAM_ID' END
            || CASE WHEN HASCOL('DEPT_NAME_KO') THEN ', X.DEPT_NAME_KO AS TEAM_NAME_KO' END
            || CASE WHEN HASCOL('CELL_MODEL')   THEN ', X.CELL_MODEL AS FORECAST_INFO_CELL_MODEL' END
            || CASE WHEN HASCOL('CREATE_DATE')  THEN q'{, NVL(TO_CHAR(X.CREATE_DATE, 'YYYY-MM-DD HH24:MI:SS'), ' ') AS LAST_UPDATE_DATE}' END
            || q'{, NVL(TO_CHAR(X.SUN),'0')||NVL(TO_CHAR(X.MON),'0')||NVL(TO_CHAR(X.TUE),'0')||NVL(TO_CHAR(X.WED),'0')||NVL(TO_CHAR(X.THU),'0')||NVL(TO_CHAR(X.FRI),'0')||NVL(TO_CHAR(X.SAT),'0') AS BUCKET}'
            || ' FROM ' || V_PREV || ' X)';
        IF HASCOL('DEPT_ID')      THEN V_COLS := V_COLS || ',TEAM_ID'; END IF;
        IF HASCOL('DEPT_NAME_KO') THEN V_COLS := V_COLS || ',TEAM_NAME_KO'; END IF;
        IF HASCOL('CELL_MODEL')   THEN V_COLS := V_COLS || ',FORECAST_INFO_CELL_MODEL'; END IF;
        IF HASCOL('CREATE_DATE')  THEN V_COLS := V_COLS || ',LAST_UPDATE_DATE'; END IF;
        V_COLS := V_COLS || ',BUCKET';
        V_PREV := 'SRCA';

        -- M7 (L5235~5262): LAST_UPDATED_BY · LAST_UPDATE_DATE — 행 키(V_LU_KEYS)마다 최신 1쌍 (피벗 대상 행만)
        --   apply #8: 원문 L5257 MERGE 와 동형 — 피벗 대상 행만의 좁은 투영(RID_ · 행 키 · CREATE_DATE · LAST_UPDATED_BY) 위에서
        --   원문과 같은 윈도(PARTITION BY 행 키 원시 열 = NULL 끼리 같은 그룹)를 계산하고 RID_ 단일 키로 되돌려 붙인다.
        --   (apply #7 의 키마다 2식 NULL-안전 등가 조인은 minyonglee1/82 실측 HASH JOIN 450s(쓰기 0) 로 폐기 · 넓은 행 윈도판은 TEMP 300MB)
        IF V_HAS_LU THEN
            -- (11-05 apply #16/#17 실험·원복) 44열 PARTITION 을 길이접두 SHA-256(LUK_) 로 바꿔 봤으나 해시 계산 CPU 8s(SRCA 적재 1.7→9.7s) > 윈도 절감 1s(6.2→5.3s · TEMP 스필 270MB 잔존) 로 폐기.
            V_Q := V_Q || CHR(10) || ', LUW AS (SELECT X.RID_'
                || ', MAX(X.CREATE_DATE) OVER (PARTITION BY ' || V_LU_KEYS || ') AS LU_DATE_'
                || ', MAX(X.LAST_UPDATED_BY) KEEP (DENSE_RANK LAST ORDER BY X.CREATE_DATE NULLS FIRST) OVER (PARTITION BY ' || V_LU_KEYS || ') AS LU_BY_'
                || ' FROM SRCA X WHERE ' || V_QF || ')';
            V_Q := V_Q || CHR(10) || ', SRC0 AS (SELECT ' || PROJ(
                   'CREATE_DATE',      'CASE WHEN ' || V_QF || ' THEN R.LU_DATE_ ELSE X.CREATE_DATE END',
                   'LAST_UPDATED_BY',  'CASE WHEN ' || V_QF || ' THEN R.LU_BY_ ELSE X.LAST_UPDATED_BY END',
                   'LAST_UPDATE_DATE', q'{NVL(TO_CHAR(CASE WHEN }' || V_QF || q'{ THEN R.LU_DATE_ ELSE X.CREATE_DATE END, 'YYYY-MM-DD HH24:MI:SS'), ' ')}')
                || ' FROM SRCA X LEFT JOIN LUW R ON (X.RID_ = R.RID_))';
            V_PREV := 'SRC0';
        END IF;

        -- DISP (G2): 표시키 × 일 사전 집계 — 5 arm 이 각각 전체를 읽던 것을 1회로. QTY 필터는 집계 전.
        V_GB := LTRIM(REPLACE(V_GROUPBY, ' GROUP BY ', ''));
        V_DISPK := ',' || REPLACE(V_COLUMN, ' ', '') || ',' || REPLACE(V_GB, ' ', '') || ',SORT_ORDER_NO,NOTATION,MEASURE,YYYYMM,YYYYMMWW,WEEK_END_YN,MONTH_END_YN,BUCKET_KEY,';
        DECLARE
            v_out VARCHAR2(32767); tok VARCHAR2(200);
        BEGIN
            FOR i IN 1 .. REGEXP_COUNT(V_DISPK, '[^,]+') LOOP
                tok := REGEXP_SUBSTR(V_DISPK, '[^,]+', 1, i);
                IF INSTR(',' || REPLACE(v_out, ' ', '') || ',', ',' || tok || ',') = 0 THEN
                    v_out := CASE WHEN v_out IS NULL THEN tok ELSE v_out || ', ' || tok END;
                END IF;
            END LOOP;
            V_DISPK := v_out;
        END;
        V_Q := V_Q || CHR(10) || ', DISP AS (SELECT ' || V_DISPK || ', SUM(X.QTY) AS QTY, COUNT(*) AS CNT_ FROM ' || V_PREV
            || ' X WHERE ' || V_QF || ' GROUP BY ' || V_DISPK || ')';

        -- [E20261105-DMF0082ONEQUERY-KIDPIVOT] KEYS/DISPK — 피벗 그룹 키 압축 (사용자 제안 2026-11-05 "pivot 전에 pivot 에 맞도록 group 처리")
        --   11-05 실측(minyonglee1/82 trc id 128): SORT GROUP BY PIVOT 입력 990,454행은 이미 (키,버킷) 유일이라 행 수는 못 줄이고, 그룹 키가 표시 44열(≈360B/행)이라
        --   TEMP 355MB(pw 45,378) 스필 정렬 11.6s. 키를 KID_(정수) 로 바꾸면 정렬 행 ≈ 40B. 등가: KID_ ↔ (V_COLUMN ∪ SORT_ORDER_NO) 1:1(DISTINCT + ROWNUM) 이므로
        --   arm GROUP BY(KID_ + V_GB−PK + …)·PIVOT 그룹이 원문과 같은 분할 · 값 식 원문 그대로 · DISP↔KEYS 조인은 SYS_OP_MAP_NONNULL 등가(NULL=NULL · 값 충돌 없음 · 해시 조인).
        --   (apply #9 에서 PIVOT 을 SUM(CASE) 360개로 바꾼 실측은 fetch 악화라 PIVOT 자체는 유지)
        DECLARE
            tok VARCHAR2(200); src VARCHAR2(32767);
            PROCEDURE addtok(p_list IN OUT VARCHAR2, p_tok VARCHAR2) IS
            BEGIN
                IF INSTR(',' || p_list || ',', ',' || p_tok || ',') = 0 THEN
                    p_list := CASE WHEN p_list IS NULL THEN p_tok ELSE p_list || ',' || p_tok END;
                END IF;
            END;
        BEGIN
            src := REPLACE(V_COLUMN, ' ', '') || ',SORT_ORDER_NO';
            FOR i IN 1 .. REGEXP_COUNT(src, '[^,]+') LOOP addtok(V_PK, REGEXP_SUBSTR(src, '[^,]+', 1, i)); END LOOP;
            src := REPLACE(V_GB, ' ', '');
            FOR i IN 1 .. REGEXP_COUNT(src, '[^,]+') LOOP
                tok := REGEXP_SUBSTR(src, '[^,]+', 1, i);
                IF INSTR(',' || V_PK || ',', ',' || tok || ',') = 0 THEN addtok(V_GX, tok); END IF;
            END LOOP;
            V_REST := V_GX;
            src := 'NOTATION,MEASURE,YYYYMM,YYYYMMWW,WEEK_END_YN,MONTH_END_YN,BUCKET_KEY';
            FOR i IN 1 .. REGEXP_COUNT(src, '[^,]+') LOOP addtok(V_REST, REGEXP_SUBSTR(src, '[^,]+', 1, i)); END LOOP;
            FOR i IN 1 .. REGEXP_COUNT(V_PK, '[^,]+') LOOP
                tok := REGEXP_SUBSTR(V_PK, '[^,]+', 1, i);
                V_KJOIN := V_KJOIN || CASE WHEN V_KJOIN IS NULL THEN '' ELSE ' AND ' END || 'SYS_OP_MAP_NONNULL(D.' || tok || ') = SYS_OP_MAP_NONNULL(K.' || tok || ')';
            END LOOP;
        END;
        V_Q := V_Q || CHR(10) || ', KEYS AS (SELECT ROWNUM AS KID_, K.* FROM (SELECT DISTINCT ' || REPLACE(V_PK, ',', ', ') || ' FROM DISP) K)'
            || CHR(10) || ', DISPK AS (SELECT K.KID_, D.' || REPLACE(V_REST, ',', ', D.') || ', D.QTY, D.CNT_ FROM DISP D JOIN KEYS K ON ' || V_KJOIN || ')';

        -- 최종 5 arm + PIVOT (L5273~5321 과 같은 식 · 입력 DISPK · 그룹 키 = KID_ (+ V_GB−PK) · 피벗 뒤 KEYS 로 표시 열 복원)
        V_Q := V_Q || q'{
    SELECT [@V_COLUMN]
    , ([@V_QTY_SUM]) AS QTY
    , [@V_PV_COL_LIST]
    FROM (
        SELECT KID_, 'D_' || BUCKET_KEY AS PIVOT_BUCKET, QTY
        FROM DISPK

        UNION ALL

        SELECT KID_, 'W_' || YYYYMMWW AS PIVOT_BUCKET
             , CASE WHEN MEASURE IN ('BALANCE','VMI_Inv','AS_Inv')
                    THEN CASE WHEN WEEK_END_YN = 'Y' THEN SUM(QTY) ELSE 0 END
                    ELSE SUM(QTY) END AS QTY
        FROM DISPK
        WHERE MEASURE NOT IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMMWW, WEEK_END_YN, MEASURE

        UNION ALL

        SELECT KID_, 'W_' || YYYYMMWW AS PIVOT_BUCKET, SUM(QTY) / SUM(CNT_) AS QTY
        FROM DISPK
        WHERE MEASURE IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMMWW

        UNION ALL

        SELECT KID_, 'M_' || YYYYMM AS PIVOT_BUCKET
             , CASE WHEN MEASURE IN ('BALANCE','VMI_Inv','AS_Inv')
                    THEN CASE WHEN MONTH_END_YN = 'Y' THEN SUM(QTY) ELSE 0 END
                    ELSE SUM(QTY) END AS QTY
        FROM DISPK
        WHERE MEASURE NOT IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMM, MONTH_END_YN, MEASURE

        UNION ALL

        SELECT KID_, 'M_' || YYYYMM AS PIVOT_BUCKET, SUM(QTY) / SUM(CNT_) AS QTY
        FROM DISPK
        WHERE MEASURE IN ('KRW','USD','LOC')
        [@V_GROUPBY], NOTATION, YYYYMM
    ) SRC
    PIVOT (SUM(QTY) FOR PIVOT_BUCKET IN ( [@V_PV_LIST] )) P
    JOIN KEYS K ON K.KID_ = P.KID_
    [@V_ORDERBY]}';

        V_Q := REPLACE(V_Q, '[@V_QTY_SUM]',     V_QTY_SUM);
        V_Q := REPLACE(V_Q, '[@V_PV_COL_LIST]', V_PV_COL_LIST);
        V_Q := REPLACE(V_Q, '[@V_PV_LIST]',     V_PV_LIST);
        V_Q := REPLACE(V_Q, '[@V_GROUPBY]',     ' GROUP BY KID_' || CASE WHEN V_GX IS NOT NULL THEN ', ' || REPLACE(V_GX, ',', ', ') END);
        V_Q := REPLACE(V_Q, '[@V_COLUMN]',      V_COLUMN);
        V_Q := REPLACE(V_Q, '[@V_ORDERBY]',     V_ORDERBY);
        V_Q := REPLACE(V_Q, '[DV]',    LIT(p_division_id));
        V_Q := REPLACE(V_Q, '[GRP]',   LIT(V_GROUP_ID));
        V_Q := REPLACE(V_Q, '[ASYN]',  LIT(V_AS_YN));
        V_Q := REPLACE(V_Q, '[FROM]',  LIT(p_from_yyyymmdd));
        V_Q := REPLACE(V_Q, '[VFROM]', LIT(V_FROM_YYYYMMDD));
        V_Q := REPLACE(V_Q, '[TO]',    LIT(V_TO_YYYYMMDD));
        V_Q := REPLACE(V_Q, '[EXP]',   LIT(V_EXP_YYYYMMDD));
        V_Q := REPLACE(V_Q, '[TOR]',   LIT(V_TO_RESULT));

        -- 진단: 세션 CLIENT_INFO='ONEQ_DEBUG' 일 때만 생성 SQL 을 DBMS_OUTPUT 으로 (운영 경로 무영향)
        IF SYS_CONTEXT('USERENV', 'CLIENT_INFO') = 'ONEQ_DEBUG' THEN
            FOR i IN 0 .. TRUNC(DBMS_LOB.GETLENGTH(V_Q) / 4000) LOOP
                DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_Q, 4000, i * 4000 + 1));
            END LOOP;
        END IF;
        OPEN O_RC1 FOR V_Q;
        DBMS_LOB.FREETEMPORARY(V_Q);
    END;
    DBMS_LOB.FREETEMPORARY(V_PV_LIST);
    DBMS_LOB.FREETEMPORARY(V_PV_COL_LIST);
    DBMS_LOB.FREETEMPORARY(V_QTY_SUM);
"""
