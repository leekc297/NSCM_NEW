-- ============================================================================
-- PKG_DMF0015 — BOD Master SP (Phase 6 PoC 보완 7)
--
-- AS-IS 4 SP 의 Oracle 19c 1:1 변환:
-- 1. DM.DM0015_GET_BOD_DATA       → P_GET_BOD_M
-- 2. DM.DM0015_GET_BOD_ITEM_DATA  → P_GET_BOD_ITEM_M
-- 3. DM.DM0015_SAVE_BOD_DATA      → P_SAVE_BOD_M (28 IN ^ csv → CLOB JSON)
-- 4. DM.DM0015_SAVE_BOD_ITEM_DATA → P_SAVE_BOD_ITEM_M (10 IN ^ csv → CLOB JSON)
--
-- 룰: Doc/_rules_v2/_tobe/12_metadata_sql.md §4 (MSSQL → Oracle 변환 표)
--     + 메모리 feedback_asis_to_tobe_sp_no_omission.md (모든 JOIN/WHERE/CASE 1:1 보존)
--
-- ⚠️ PoC scope: SP body 의 skeleton + 핵심 변환 패턴 표시.
--    AS-IS DM.DM0015_GET_BOD_DATA SP body 의 GSCM/04.WSL/.../*.sql 안 정밀 추출은 후속.
-- ============================================================================

CREATE OR REPLACE PACKAGE PKG_DMF0015 AS

    -- 1. Main 조회
    PROCEDURE P_GET_BOD_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_SES_GR_ID    IN VARCHAR2,
        P_DIVISION_ID  IN VARCHAR2,
        P_BOD_TYPE     IN VARCHAR2,
        P_FROM_SITE    IN VARCHAR2,
        P_TO_SITE      IN VARCHAR2,
        P_ACTIVE_FLAG  IN VARCHAR2,
        O_RC1          OUT SYS_REFCURSOR
    );

    -- 2. Sub 조회
    PROCEDURE P_GET_BOD_ITEM_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_DIVISION_ID  IN VARCHAR2,
        P_BOD_ID       IN VARCHAR2,
        O_RC1          OUT SYS_REFCURSOR
    );

    -- 3. Main 저장 (CLOB JSON)
    PROCEDURE P_SAVE_BOD_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_IN_DATA      IN CLOB,
        O_MSG          OUT VARCHAR2,
        O_CD           OUT VARCHAR2
    );

    -- 4. Sub 저장 (CLOB JSON)
    PROCEDURE P_SAVE_BOD_ITEM_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_IN_DATA      IN CLOB,
        O_MSG          OUT VARCHAR2,
        O_CD           OUT VARCHAR2
    );

END PKG_DMF0015;
/

-- ============================================================================
-- PACKAGE BODY
-- ============================================================================

CREATE OR REPLACE PACKAGE BODY PKG_DMF0015 AS

    -- =================================================================
    -- 1. Main 조회 (AS-IS DM.DM0015_GET_BOD_DATA 1:1 변환)
    -- =================================================================
    PROCEDURE P_GET_BOD_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_SES_GR_ID    IN VARCHAR2,
        P_DIVISION_ID  IN VARCHAR2,
        P_BOD_TYPE     IN VARCHAR2,
        P_FROM_SITE    IN VARCHAR2,
        P_TO_SITE      IN VARCHAR2,
        P_ACTIVE_FLAG  IN VARCHAR2,
        O_RC1          OUT SYS_REFCURSOR
    ) AS
    BEGIN
        -- ⚠️ AS-IS SP body 의 GSCM/04.WSL/.../*.sql 안 SELECT JOIN/WHERE 정밀 추출 후 변환.
        --   본 skeleton 은 핵심 join + multi-value filter 패턴만 표시.
        OPEN O_RC1 FOR
            SELECT
                b.BOD_ID,
                b.DIVISION_ID,
                b.BOD_TYPE,
                b.FROM_SITE,
                b.TO_SITE,
                b.END_CUSTOMER,
                b.POL,
                b.POD,
                b.HUB_SLOC,
                b.INCOTERMS,
                b.TRANSPORT_MODE,
                b.PRIORITY,
                b.PERIOD_SHIPSCH_MON,
                b.PERIOD_SHIPSCH_TUE,
                b.PERIOD_SHIPSCH_WED,
                b.PERIOD_SHIPSCH_THU,
                b.PERIOD_SHIPSCH_FRI,
                b.PERIOD_SHIPSCH_SAT,
                b.PERIOD_SHIPSCH_SUN,
                b.FREIGHT_FORWARDER,
                b.SAFETY_STOCK,
                b.PERIOD1_LT,
                b.POL_CLEARANCE_LT,
                b.PERIOD2_LT,
                b.POD_CLEARANCE_LT,
                b.PERIOD3_LT,
                NVL(b.PERIOD1_LT, 0) + NVL(b.POL_CLEARANCE_LT, 0) + NVL(b.PERIOD2_LT, 0)
                    + NVL(b.POD_CLEARANCE_LT, 0) + NVL(b.PERIOD3_LT, 0) AS LT_TOTAL,
                b.CUSTOMER_LT,
                b.VALID_YN,
                b.LAST_UPDATED_BY,
                TO_CHAR(b.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE
            FROM SCM_MST_BOD b
            WHERE 1 = 1
              -- multi-value csv → UF_FX_STRING_SPLIT (AS-IS MSSQL STRING_SPLIT 변환)
              AND (P_DIVISION_ID IS NULL OR P_DIVISION_ID = 'ALL'
                   OR b.DIVISION_ID IN (
                        SELECT COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLIT(P_DIVISION_ID, ','))
                      ))
              AND (P_BOD_TYPE IS NULL OR P_BOD_TYPE = 'ALL'
                   OR b.BOD_TYPE IN (
                        SELECT COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLIT(P_BOD_TYPE, ','))
                      ))
              AND (P_FROM_SITE IS NULL OR P_FROM_SITE = 'ALL'
                   OR b.FROM_SITE IN (
                        SELECT COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))
                      ))
              AND (P_TO_SITE IS NULL OR P_TO_SITE = 'ALL'
                   OR b.TO_SITE IN (
                        SELECT COLUMN_VALUE FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))
                      ))
              AND (P_ACTIVE_FLAG IS NULL OR P_ACTIVE_FLAG = 'ALL'
                   OR b.VALID_YN = P_ACTIVE_FLAG)
              -- 권한 cross-check (메뉴 권한 + Division 권한 — AS-IS p_group/p_user_id 사용)
              AND EXISTS (
                  SELECT 1 FROM SCM_ADM_USER_GR_UNIT_AUTH_MPG_M a
                  WHERE a.USER_ID = P_SES_USER_ID
                    AND a.GR_ID = P_SES_GR_ID
                    AND a.UNIT_VAL = b.DIVISION_ID
              )
            ORDER BY b.DIVISION_ID, b.BOD_ID;
    END P_GET_BOD_M;

    -- =================================================================
    -- 2. Sub 조회 (AS-IS DM.DM0015_GET_BOD_ITEM_DATA 1:1 변환)
    -- =================================================================
    PROCEDURE P_GET_BOD_ITEM_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_DIVISION_ID  IN VARCHAR2,
        P_BOD_ID       IN VARCHAR2,
        O_RC1          OUT SYS_REFCURSOR
    ) AS
    BEGIN
        OPEN O_RC1 FOR
            SELECT
                bi.BOD_ID,
                bi.DIVISION_ID,
                bi.ITEM_ID,
                bi.LOT_SIZE,
                bi.FROZEN_PERIOD,
                TO_CHAR(bi.EFF_START_DATE, 'YYYYMMDD') AS EFF_START_DATE,
                TO_CHAR(bi.EFF_END_DATE,   'YYYYMMDD') AS EFF_END_DATE,
                bi.VALID_YN,
                bi.LAST_UPDATED_BY,
                TO_CHAR(bi.LAST_UPDATE_DATE, 'YYYY-MM-DD HH24:MI:SS') AS LAST_UPDATE_DATE
            FROM SCM_MST_BOD_ITEM bi
            WHERE bi.DIVISION_ID = P_DIVISION_ID
              AND bi.BOD_ID      = P_BOD_ID
            ORDER BY bi.ITEM_ID;
    END P_GET_BOD_ITEM_M;

    -- =================================================================
    -- 3. Main 저장 (AS-IS DM.DM0015_SAVE_BOD_DATA — 28 IN ^ csv → CLOB JSON)
    -- =================================================================
    PROCEDURE P_SAVE_BOD_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_IN_DATA      IN CLOB,    -- JSON array of BOD records
        O_MSG          OUT VARCHAR2,
        O_CD           OUT VARCHAR2
    ) AS
        V_CNT NUMBER := 0;
    BEGIN
        -- CLOB JSON parse + 행 단위 처리
        -- AS-IS ^ csv 의 BE 측 array → JSON CLOB 변환 후 SP 가 JSON_TABLE 로 분해
        FOR r IN (
            SELECT *
            FROM JSON_TABLE(P_IN_DATA, '$[*]' COLUMNS (
                CRUD_TYPE          VARCHAR2(1)   PATH '$.CRUD_TYPE',
                DIVISION_ID        VARCHAR2(20)  PATH '$.DIVISION_ID',
                BOD_ID             VARCHAR2(20)  PATH '$.BOD_ID',
                BOD_TYPE           VARCHAR2(20)  PATH '$.BOD_TYPE',
                FROM_SITE          VARCHAR2(20)  PATH '$.FROM_SITE',
                TO_SITE            VARCHAR2(20)  PATH '$.TO_SITE',
                END_CUSTOMER       VARCHAR2(50)  PATH '$.END_CUSTOMER',
                POL                VARCHAR2(20)  PATH '$.POL',
                POD                VARCHAR2(20)  PATH '$.POD',
                HUB_SLOC           VARCHAR2(20)  PATH '$.HUB_SLOC',
                INCOTERMS          VARCHAR2(10)  PATH '$.INCOTERMS',
                TRANSPORT_MODE     VARCHAR2(10)  PATH '$.TRANSPORT_MODE',
                PRIORITY           NUMBER        PATH '$.PRIORITY',
                PERIOD_SHIPSCH_MON VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_MON',
                PERIOD_SHIPSCH_TUE VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_TUE',
                PERIOD_SHIPSCH_WED VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_WED',
                PERIOD_SHIPSCH_THU VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_THU',
                PERIOD_SHIPSCH_FRI VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_FRI',
                PERIOD_SHIPSCH_SAT VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_SAT',
                PERIOD_SHIPSCH_SUN VARCHAR2(1)   PATH '$.PERIOD_SHIPSCH_SUN',
                FREIGHT_FORWARDER  VARCHAR2(50)  PATH '$.FREIGHT_FORWARDER',
                SAFETY_STOCK       NUMBER        PATH '$.SAFETY_STOCK',
                PERIOD1_LT         NUMBER        PATH '$.PERIOD1_LT',
                POL_CLEARANCE_LT   NUMBER        PATH '$.POL_CLEARANCE_LT',
                PERIOD2_LT         NUMBER        PATH '$.PERIOD2_LT',
                POD_CLEARANCE_LT   NUMBER        PATH '$.POD_CLEARANCE_LT',
                PERIOD3_LT         NUMBER        PATH '$.PERIOD3_LT',
                CUSTOMER_LT        NUMBER        PATH '$.CUSTOMER_LT',
                VALID_YN           VARCHAR2(1)   PATH '$.VALID_YN'
            ))
        ) LOOP
            -- AS-IS CRUD_TYPE 매핑: 'I' (INSERT) / 'M' (MODIFY) / 'D' (DELETE)
            IF r.CRUD_TYPE = 'I' THEN
                INSERT INTO SCM_MST_BOD (
                    BOD_ID, DIVISION_ID, BOD_TYPE, FROM_SITE, TO_SITE, END_CUSTOMER,
                    POL, POD, HUB_SLOC, INCOTERMS, TRANSPORT_MODE, PRIORITY,
                    PERIOD_SHIPSCH_MON, PERIOD_SHIPSCH_TUE, PERIOD_SHIPSCH_WED,
                    PERIOD_SHIPSCH_THU, PERIOD_SHIPSCH_FRI, PERIOD_SHIPSCH_SAT, PERIOD_SHIPSCH_SUN,
                    FREIGHT_FORWARDER, SAFETY_STOCK,
                    PERIOD1_LT, POL_CLEARANCE_LT, PERIOD2_LT, POD_CLEARANCE_LT, PERIOD3_LT,
                    CUSTOMER_LT, VALID_YN,
                    LAST_UPDATED_BY, LAST_UPDATE_DATE
                ) VALUES (
                    NVL(r.BOD_ID, UF_FX_NEXT_BOD_ID()),   -- AS-IS sequence — Oracle UF 함수
                    r.DIVISION_ID, r.BOD_TYPE, r.FROM_SITE, r.TO_SITE, r.END_CUSTOMER,
                    r.POL, r.POD, r.HUB_SLOC, r.INCOTERMS, r.TRANSPORT_MODE, r.PRIORITY,
                    r.PERIOD_SHIPSCH_MON, r.PERIOD_SHIPSCH_TUE, r.PERIOD_SHIPSCH_WED,
                    r.PERIOD_SHIPSCH_THU, r.PERIOD_SHIPSCH_FRI, r.PERIOD_SHIPSCH_SAT, r.PERIOD_SHIPSCH_SUN,
                    r.FREIGHT_FORWARDER, r.SAFETY_STOCK,
                    r.PERIOD1_LT, r.POL_CLEARANCE_LT, r.PERIOD2_LT, r.POD_CLEARANCE_LT, r.PERIOD3_LT,
                    r.CUSTOMER_LT, r.VALID_YN,
                    P_SES_USER_ID, SYSDATE
                );
                V_CNT := V_CNT + 1;

            ELSIF r.CRUD_TYPE = 'M' THEN
                UPDATE SCM_MST_BOD
                SET BOD_TYPE = r.BOD_TYPE,
                    END_CUSTOMER = r.END_CUSTOMER,
                    POL = r.POL, POD = r.POD, HUB_SLOC = r.HUB_SLOC,
                    INCOTERMS = r.INCOTERMS, TRANSPORT_MODE = r.TRANSPORT_MODE,
                    PRIORITY = r.PRIORITY,
                    PERIOD_SHIPSCH_MON = r.PERIOD_SHIPSCH_MON,
                    PERIOD_SHIPSCH_TUE = r.PERIOD_SHIPSCH_TUE,
                    PERIOD_SHIPSCH_WED = r.PERIOD_SHIPSCH_WED,
                    PERIOD_SHIPSCH_THU = r.PERIOD_SHIPSCH_THU,
                    PERIOD_SHIPSCH_FRI = r.PERIOD_SHIPSCH_FRI,
                    PERIOD_SHIPSCH_SAT = r.PERIOD_SHIPSCH_SAT,
                    PERIOD_SHIPSCH_SUN = r.PERIOD_SHIPSCH_SUN,
                    FREIGHT_FORWARDER = r.FREIGHT_FORWARDER,
                    SAFETY_STOCK = r.SAFETY_STOCK,
                    PERIOD1_LT = r.PERIOD1_LT,
                    POL_CLEARANCE_LT = r.POL_CLEARANCE_LT,
                    PERIOD2_LT = r.PERIOD2_LT,
                    POD_CLEARANCE_LT = r.POD_CLEARANCE_LT,
                    PERIOD3_LT = r.PERIOD3_LT,
                    CUSTOMER_LT = r.CUSTOMER_LT,
                    VALID_YN = r.VALID_YN,
                    LAST_UPDATED_BY = P_SES_USER_ID,
                    LAST_UPDATE_DATE = SYSDATE
                WHERE DIVISION_ID = r.DIVISION_ID AND BOD_ID = r.BOD_ID;
                V_CNT := V_CNT + 1;

            ELSIF r.CRUD_TYPE = 'D' THEN
                DELETE FROM SCM_MST_BOD WHERE DIVISION_ID = r.DIVISION_ID AND BOD_ID = r.BOD_ID;
                V_CNT := V_CNT + 1;
            END IF;
        END LOOP;

        O_MSG := 'MSG00004';   -- AS-IS "수정한 내용이 없습니다" / 저장 성공 메시지
        O_CD := '0';
    EXCEPTION WHEN OTHERS THEN
        O_MSG := SQLERRM;
        O_CD := '1';
        ROLLBACK;
    END P_SAVE_BOD_M;

    -- =================================================================
    -- 4. Sub 저장 (AS-IS DM.DM0015_SAVE_BOD_ITEM_DATA 변환)
    -- =================================================================
    PROCEDURE P_SAVE_BOD_ITEM_M (
        P_SES_USER_ID  IN VARCHAR2,
        P_SES_LANG_CD  IN VARCHAR2,
        P_MNU_ID       IN VARCHAR2,
        P_IN_DATA      IN CLOB,
        O_MSG          OUT VARCHAR2,
        O_CD           OUT VARCHAR2
    ) AS
    BEGIN
        -- (Main 과 동등 패턴 — JSON_TABLE + IF CRUD_TYPE branch + 10 column)
        FOR r IN (
            SELECT *
            FROM JSON_TABLE(P_IN_DATA, '$[*]' COLUMNS (
                CRUD_TYPE       VARCHAR2(1)   PATH '$.CRUD_TYPE',
                DIVISION_ID     VARCHAR2(20)  PATH '$.DIVISION_ID',
                BOD_ID          VARCHAR2(20)  PATH '$.BOD_ID',
                ITEM_ID         VARCHAR2(50)  PATH '$.ITEM_ID',
                LOT_SIZE        NUMBER        PATH '$.LOT_SIZE',
                FROZEN_PERIOD   NUMBER        PATH '$.FROZEN_PERIOD',
                EFF_START_DATE  VARCHAR2(8)   PATH '$.EFF_START_DATE',
                EFF_END_DATE    VARCHAR2(8)   PATH '$.EFF_END_DATE',
                VALID_YN        VARCHAR2(1)   PATH '$.VALID_YN'
            ))
        ) LOOP
            IF r.CRUD_TYPE = 'I' THEN
                INSERT INTO SCM_MST_BOD_ITEM (
                    DIVISION_ID, BOD_ID, ITEM_ID, LOT_SIZE, FROZEN_PERIOD,
                    EFF_START_DATE, EFF_END_DATE, VALID_YN,
                    LAST_UPDATED_BY, LAST_UPDATE_DATE
                ) VALUES (
                    r.DIVISION_ID, r.BOD_ID, r.ITEM_ID, r.LOT_SIZE, r.FROZEN_PERIOD,
                    TO_DATE(r.EFF_START_DATE, 'YYYYMMDD'),
                    TO_DATE(r.EFF_END_DATE,   'YYYYMMDD'),
                    r.VALID_YN, P_SES_USER_ID, SYSDATE
                );
            ELSIF r.CRUD_TYPE = 'M' THEN
                UPDATE SCM_MST_BOD_ITEM
                SET LOT_SIZE = r.LOT_SIZE, FROZEN_PERIOD = r.FROZEN_PERIOD,
                    EFF_START_DATE = TO_DATE(r.EFF_START_DATE, 'YYYYMMDD'),
                    EFF_END_DATE   = TO_DATE(r.EFF_END_DATE,   'YYYYMMDD'),
                    VALID_YN = r.VALID_YN,
                    LAST_UPDATED_BY = P_SES_USER_ID,
                    LAST_UPDATE_DATE = SYSDATE
                WHERE DIVISION_ID = r.DIVISION_ID AND BOD_ID = r.BOD_ID AND ITEM_ID = r.ITEM_ID;
            ELSIF r.CRUD_TYPE = 'D' THEN
                DELETE FROM SCM_MST_BOD_ITEM
                WHERE DIVISION_ID = r.DIVISION_ID AND BOD_ID = r.BOD_ID AND ITEM_ID = r.ITEM_ID;
            END IF;
        END LOOP;

        O_MSG := 'MSG00004';
        O_CD := '0';
    EXCEPTION WHEN OTHERS THEN
        O_MSG := SQLERRM;
        O_CD := '1';
        ROLLBACK;
    END P_SAVE_BOD_ITEM_M;

END PKG_DMF0015;
/

-- ============================================================================
-- 적용된 MSSQL → Oracle 변환 (룰 12 §4.1)
-- ============================================================================
-- AS-IS MSSQL                          → TO-BE Oracle
-- ----------------------------------------------------------------------
-- GETDATE()                            → SYSDATE
-- ISNULL(X, Y)                         → NVL(X, Y)
-- STRING_SPLIT(s, ',')                 → UF_FX_STRING_SPLIT(s, ',')
-- CONVERT(VARCHAR, DATE_COL)           → TO_CHAR(DATE_COL, 'YYYY-MM-DD HH24:MI:SS')
-- CAST(X AS DATE)                      → TO_DATE(X, 'YYYYMMDD')
-- 28 IN ^ csv (AS-IS)                  → CLOB JSON + JSON_TABLE (Oracle 12+)
-- BEGIN/END TRANSACTION                → 자동 (PL/SQL)
-- PRINT / RAISERROR                    → DBMS_OUTPUT / RAISE_APPLICATION_ERROR
-- (없음) → EXCEPTION WHEN OTHERS THEN ROLLBACK 의무 추가
-- N'문자열'                            → '문자열' (Oracle 는 N 불필요)
-- ============================================================================

-- ⚠️ 향후 정밀 보강:
-- 1. AS-IS GSCM/04.WSL/.../DM0015_GET_BOD_DATA.sql 본문 정밀 read 후 1:1 변환
--    (본 skeleton 의 SELECT body 는 핵심 column + multi-value filter + 권한 cross-check 만)
-- 2. UF_FX_STRING_SPLIT 함수 등록 (룰 29) — 멱등 INSERT
-- 3. UF_FX_NEXT_BOD_ID 함수 (sequence 기반) — AS-IS 의 BOD_ID 자동 생성 로직 변환
-- 4. GTT 사용 시 DELETE 누락 금지 (룰 12 §4.5)

-- ============================================================================
-- 변경 이력
-- ============================================================================
-- 2026-06-04 — Phase 6 PoC 보완 7 — AS-IS 4 SP Oracle 변환 skeleton
