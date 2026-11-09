-- SOURCE-FRESH: SCM_MGR 화면 SCP0016 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-06 22:30:22
/* 20_PKG PKG_SCP0016 — 사내 최신 원문 전체(CREATE OR REPLACE · 이 화면 전용 객체)
 * 패키지 SCP0016_CLOUD_DB_MOD_20261106_2230 · 생성 tools/CloudPkg/cloud_pkg.py 1.1.0 · 2026-11-06 22:30
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 되돌리기 = 05_BACKUP 을 먼저 실행해 두면 99_ROLLBACK 이 이 객체를 실행 전 원문으로 복원
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PACKAGE         PKG_SCP0016
IS
    /*
     * Program ID   : PKG_SCP0016
     * Description  : SCP0016 Waterfall Shipment Plan FG 화면
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     */

    /* 출하계획 워터폴 조회 (값) */
    PROCEDURE P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , P_PROJECT_CODE      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VERSION_NO        IN  CLOB
      , P_ELECTYPE          IN  CLOB
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 출하계획 워터폴 조회 (머리) */
    PROCEDURE P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , P_PROJECT_CODE      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VERSION_NO        IN  CLOB
      , P_ELECTYPE          IN  CLOB
      , P_ISO               IN  VARCHAR2
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCP0016;
/

CREATE OR REPLACE PACKAGE BODY         PKG_SCP0016
IS
    /*
     * Program ID   : PKG_SCP0016
     * Description  : SCP0016 Waterfall Shipment Plan FG 화면 - 출하계획 워터폴 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     * 2026.11.04   AJS          동적 SQL 문자열 안의 주석 제거(변경 표시 · 옛 문장 · 설명). 실행 문장 동일
     * 2026.11.04   AJS          본문 조회 기간 칸 — 칸마다 SUM(CASE) 를 PIVOT 으로 변경(기간 칸 이름 · 순서 · 값 동일)
     * 2026.11.04   AJS          모델 조회조건 — 품목 함수를 행마다 실행하던 것을 시작할 때 한 번 실행해 컬렉션으로 비교
     * 2026.11.03   AJS          PJT 조회조건 대소문자 무시(AS-IS MSSQL 과 같은 동작)
     * 2026.11.03   AJS          [E20261020-000662] 머리 조회 — BOD 뷰를 임시 테이블(GT_SCP0016_BOD)에 받아 조인(운영 조치와 같은 구조)
     * 2026.10.07   AJS          [속도] 값 조회 — 원장→임시 테이블 2단 적재(DATA1·PIVOT)를 없애고 피벗 조회가 원장을 바로 읽음,
     * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
     */

    C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL';

    /* ==============================================================================================
       내부 : 결과 커서 (정상)
       ============================================================================================== */
    PROCEDURE P_OPEN_SUCCESS
    (
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;
    END P_OPEN_SUCCESS;

    /* ==============================================================================================
       내부 : 결과 커서 (오류)
       ============================================================================================== */
    PROCEDURE P_OPEN_ERROR
    (
        P_MESSAGE           IN  VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1'      AS CODE
                 , P_MESSAGE AS MSG
              FROM DUAL;
    END P_OPEN_ERROR;

    /* ==============================================================================================
       내부 : 오류 이력 기록
       ============================================================================================== */
    PROCEDURE P_WRITE_ERROR_LOG
    (
        P_PROGRAM_NAME      IN  VARCHAR2,
        P_MESSAGE           IN  VARCHAR2
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO SCM_SYS_LOG_BATCH
        (
            PROGRAM_NAME
          , LOG_TYPE
          , LOG_COUNT
          , LOG_MESSAGE
          , DESCRIPTION
          , EVENT_DATE
          , CREATION_DATE
          , CREATED_BY
          , LAST_UPDATE_DATE
          , LAST_UPDATED_BY
        )
        VALUES
        (
            P_PROGRAM_NAME
          , 'ERROR'
          , NULL
          , SUBSTR(P_MESSAGE, 1, 1000)
          , NULL
          , SYSDATE
          , SYSDATE
          , P_PROGRAM_NAME
          , SYSDATE
          , P_PROGRAM_NAME
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END P_WRITE_ERROR_LOG;

    /* ==============================================================================================
       내부 : 사용자가 고른 측정값 개수
       ============================================================================================== */
    FUNCTION F_CNT_USR_MEASURE
    (
        P_PROGRAM_ID        IN  VARCHAR2,
        P_SHEET_NAME        IN  VARCHAR2,
        P_USER_ID           IN  VARCHAR2
    )
    RETURN PLS_INTEGER
    IS
        V_CNT               PLS_INTEGER;
    BEGIN
        SELECT COUNT(*)
          INTO V_CNT
          FROM SCM_MST_TITLESET_USER
         WHERE PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        RETURN V_CNT;
    END F_CNT_USR_MEASURE;

    /* ==============================================================================================
       내부 : 피벗 칸 문자열 만들기
              P_MODE = 'QTY'    이면 PIVOT IN 목록 (본문 조회)   --  2026.11.04 AJS
                     = 'COL'    이면 기간 칸 이름 목록 (본문 조회)   --  2026.11.04 AJS
                     = 'TITLE'  이면 빈 값 칸        (머리 조회)
              P_ISO  = 'F' 이면 일반 주 · 그 밖이면 ISO 주 (머리 조회에서만 가른다)
       ============================================================================================== */
    FUNCTION F_PIVOT_COLUMNS
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_MODE              IN  VARCHAR2,
        P_ISO               IN  VARCHAR2 DEFAULT NULL
    )
    RETURN CLOB
    IS
        V_SQL               CLOB := EMPTY_CLOB();
    BEGIN
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        FOR C IN (SELECT IA.YYYYMMDD
                    FROM (/* 월 */
                          SELECT 'M_' || A.BASIS_YYYYMM                             AS YYYYMMDD
                               , MIN(A.BASIS_START_DATE) || '01'                    AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMM
                                  , A.MONTH_NAME
                          UNION ALL
                          /* 일반 주 */
                          SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK               AS YYYYMMDD
                               , A.BASIS_START_DATE || '21'                         AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND (P_MODE IN ('QTY', 'COL') OR P_ISO = 'F')   --  2026.11.04 AJS
                           GROUP BY A.BASIS_YYYYMM
                                  , A.ISO_WEEK
                                  , A.BASIS_START_DATE
                          UNION ALL
                          /* ISO 주 */
                          SELECT 'W_' || A.ISO_YYYYMM || A.ISO_WEEK || '_ISO'       AS YYYYMMDD
                               , MIN(A.BASIS_START_DATE) || '21'                    AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND (P_MODE IN ('QTY', 'COL') OR P_ISO <> 'F')   --  2026.11.04 AJS
                           GROUP BY A.ISO_YYYYMM
                                  , A.ISO_WEEK
                          UNION ALL
                          /* 일 */
                          SELECT 'D_' || A.BASIS_YYYYMMDD                           AS YYYYMMDD
                               , A.BASIS_YYYYMMDD || '31'                            AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           GROUP BY A.BASIS_YYYYMMDD) IA
                   ORDER BY IA.SORT_ORDER_NO
                          , IA.YYYYMMDD)
        LOOP
            IF P_MODE = 'TITLE' THEN
                /* 머리 조회 — 칸 이름만 만들고 값은 비운다 */
                DBMS_LOB.WRITEAPPEND(V_SQL, LENGTH(', '''' AS "' || C.YYYYMMDD || '"' || CHR(10))
                                          , ', '''' AS "' || C.YYYYMMDD || '"' || CHR(10));
--            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
--                DBMS_LOB.WRITEAPPEND(V_SQL
--                  , LENGTH(', SUM(CASE WHEN YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
--                  , ', SUM(CASE WHEN YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
--            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' AND SUBSTR(C.YYYYMMDD, -4) <> '_ISO' THEN
--                DBMS_LOB.WRITEAPPEND(V_SQL
--                  , LENGTH(', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
--                  , ', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
--            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
--                /* ISO 주 — AS-IS 는 칸 이름의 3번째부터 6자리를 쓴다 */
--                DBMS_LOB.WRITEAPPEND(V_SQL
--                  , LENGTH(', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', 3, 6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
--                  , ', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', 3, 6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
--            ELSE
--                DBMS_LOB.WRITEAPPEND(V_SQL
--                  , LENGTH(', SUM(CASE WHEN YYYYMMDD = ''' || C.YYYYMMDD || ''' THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
--                  , ', SUM(CASE WHEN YYYYMMDD = ''' || C.YYYYMMDD || ''' THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
            /* 2026.11.04 AJS 칸마다 SUM(CASE) → PIVOT (START) : 값은 원천의 구분 + 일자 칸과 맞춘다 */
            ELSIF P_MODE = 'COL' THEN
                DBMS_LOB.WRITEAPPEND(V_SQL, LENGTH(', "' || C.YYYYMMDD || '"' || CHR(10))
                                          , ', "' || C.YYYYMMDD || '"' || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' AND SUBSTR(C.YYYYMMDD, -4) <> '_ISO' THEN
                DBMS_LOB.WRITEAPPEND(V_SQL
                  , LENGTH(', ''W' || SUBSTR(C.YYYYMMDD, -6) || ''' AS "' || C.YYYYMMDD || '"' || CHR(10))
                  , ', ''W' || SUBSTR(C.YYYYMMDD, -6) || ''' AS "' || C.YYYYMMDD || '"' || CHR(10));
            ELSE
                /* 월 · 일 = 칸 이름과 같은 값 · ISO 주 = 원천 값과 일치하지 않아 빈 칸(변경 전 비교식과 같은 결과) */
                DBMS_LOB.WRITEAPPEND(V_SQL
                  , LENGTH(', ''' || C.YYYYMMDD || ''' AS "' || C.YYYYMMDD || '"' || CHR(10))
                  , ', ''' || C.YYYYMMDD || ''' AS "' || C.YYYYMMDD || '"' || CHR(10));
            /* 2026.11.04 AJS 칸마다 SUM(CASE) → PIVOT (END) */
            END IF;
        END LOOP;

        RETURN V_SQL;
    END F_PIVOT_COLUMNS;

    /* ==============================================================================================
       SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL — 값
       ============================================================================================== */
    PROCEDURE P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , P_PROJECT_CODE      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VERSION_NO        IN  CLOB
      , P_ELECTYPE          IN  CLOB
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_PROJECT_CODE      VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PROJECT_CODE, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
        V_ITEM_TAB          T_STR_TAB            := T_STR_TAB();   --  2026.11.04 AJS
        V_VERSION_NO        VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_VERSION_NO, 1, 32767));
        V_CUTOFF            DATE;
        V_NEXT_CUTOFF       DATE;
        V_ELECTYPE          VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ELECTYPE, 1, 32767));
        V_PROGRAM_ID        VARCHAR2(200 CHAR)   := NVL(P_PROGRAM_ID, 'SCP0016');
        V_SHEET_NAME        VARCHAR2(200 CHAR)   := NVL(P_SHEET_NAME, 'Shipment Plan FG');
        V_CNT_USR_MEASURE   PLS_INTEGER;
        V_IS_EE             PLS_INTEGER;
        V_PIVOT             CLOB;
        V_PIVOT_COL         CLOB;                   --  2026.11.04 AJS
        V_SQL               CLOB;
        V_SRC               CLOB;                   --  2026.10.07 AJS
    BEGIN
        /* 2026.11.04 AJS 모델 조회조건 품목 목록 사전 적재 (START) */
        IF TRIM(V_ITEM_ID) IS NOT NULL
       AND UPPER(V_ITEM_ID) <> 'ALL' THEN
            SELECT COLUMN_VALUE
              BULK COLLECT INTO V_ITEM_TAB
              FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''));
        END IF;
        /* 2026.11.04 AJS 모델 조회조건 품목 목록 사전 적재 (END) */

        V_CNT_USR_MEASURE := F_CNT_USR_MEASURE(V_PROGRAM_ID, V_SHEET_NAME, P_USER_ID);

        /* 전극 사업부 갈래 판정 — AS-IS : @p_division_id NOT IN (FN_GET_DIVISION_DIV('EE')) */
        SELECT COUNT(*)
          INTO V_IS_EE
          FROM TABLE(FN_GET_DIVISION_DIV('EE'))
         WHERE COLUMN_VALUE = P_DIVISION_ID;

        DELETE FROM GT_SCP0016_DATA1;
        DELETE FROM GT_SCP0016_BOD;
        DELETE FROM GT_SCP0016_PIVOT;

        /* ==========================================================================================
           0. 고른 차수 목록 — ★원장이 사업부·차수 열쇠로 바로 찾아가게 한다.
              차수를 고르지 않았으면 비어 있고, 그때는 아래에서 차수 조건 없는 문장을 쓴다
           ========================================================================================== */
        DELETE FROM GT_SCP0016_VER;

        /* ★마감일시를 하나씩 올려 가며 모은다. 한 번에 DISTINCT 로 뽑으면 그 차수의 전 행을
              훑어 20초가 넘지만, 최솟값 조회는 열쇠만 보고 끝난다 */
        FOR C IN (SELECT DISTINCT COLUMN_VALUE AS VERSION_NO
                    FROM TABLE(STRING_SPLIT(V_VERSION_NO, ',')))
        LOOP
            V_CUTOFF := NULL;

            LOOP
                IF V_CUTOFF IS NULL THEN
                    SELECT MIN(A.CUTOFF_DATE)
                      INTO V_NEXT_CUTOFF
                      FROM SCP_ANL_SHIPMENT_PLAN_FG_C A
                     WHERE A.DIVISION_ID = P_DIVISION_ID
                       AND A.VERSION_NO  = C.VERSION_NO;
                ELSE
                    SELECT MIN(A.CUTOFF_DATE)
                      INTO V_NEXT_CUTOFF
                      FROM SCP_ANL_SHIPMENT_PLAN_FG_C A
                     WHERE A.DIVISION_ID = P_DIVISION_ID
                       AND A.VERSION_NO  = C.VERSION_NO
                       AND A.CUTOFF_DATE > V_CUTOFF;
                END IF;

                EXIT WHEN V_NEXT_CUTOFF IS NULL;

                INSERT INTO GT_SCP0016_VER
                (
                    VERSION_NO
                  , CUTOFF_DATE
                )
                VALUES (C.VERSION_NO, V_NEXT_CUTOFF);

                V_CUTOFF := V_NEXT_CUTOFF;
            END LOOP;
        END LOOP;

--  2026.10.07 AJS (START) 임시 테이블 DATA1 적재 제거 — 4-0 피벗 원천에서 원장을 바로 읽는다
--        /* ==========================================================================================
--           1. 출하계획 원장에서 조회조건에 맞는 것만
--           ========================================================================================== */
--        /* ★차수를 고르지 않았으면 조건을 붙이지 않는다 — 원문과 같다 */
--        IF TRIM(V_VERSION_NO) IS NULL THEN
--
--        INSERT INTO GT_SCP0016_DATA1
--        (
--            VERSION_NO
--          , DIVISION_ID
--          , BIZ_TYPE
--          , PROJECT_CODE
--          , ITEM_ID
--          , ELECTRODE_TYPE
--          , ORIGIN_TO_DIVISION_ID
--          , TO_SITE
--          , INCOTERMS
--          , ORIGIN_FROM_DIVISION_ID
--          , FROM_SITE
--          , MEASURE
--          , BOD_ID
--          , QTY
--          , PLAN_START_YYYYMMDD
--          , PLAN_TYPE
--          , SEQ
--          , BIZ_TYPE_NAME
--          , NICK_NAME
--          , TO_SITE_NAME
--          , FROM_SITE_NAME
--          , YYYYMMDD
--        )
--        SELECT B.VERSION_NO
--             , B.DIVISION_ID
--             , B.BIZ_TYPE
--             , B.PROJECT_CODE
--             , B.ITEM_ID
--             , B.ELECTRODE_TYPE
--             , B.ORIGIN_TO_DIVISION_ID
--             , B.TO_SITE
--             , B.INCOTERMS
--             , B.ORIGIN_FROM_DIVISION_ID
--             , B.FROM_SITE
--             , B.MEASURE
--             , B.BOD_ID
--             , B.QTY
--             , B.PLAN_START_YYYYMMDD
--             , B.PLAN_TYPE
--             , B.SEQ
--             , B.BIZ_TYPE_NAME
--             , B.NICK_NAME
--             , B.TO_SITE_NAME
--             , B.FROM_SITE_NAME
--             , B.YYYYMMDD
--          FROM SCP_ANL_SHIPMENT_PLAN_FG_C B
--         WHERE B.YYYYMMDD    >= P_FROM_YYYYMMDD
--           AND B.YYYYMMDD    <= P_TO_YYYYMMDD
--           AND B.DIVISION_ID  = P_DIVISION_ID
--           AND B.BIZ_TYPE     = P_BIZ_TYPE
--           AND (TRIM(V_PROJECT_CODE) IS NULL
--            OR  UPPER(V_PROJECT_CODE) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
--            OR  B.PROJECT_CODE IN (SELECT COLUMN_VALUE
--                                     FROM TABLE(STRING_SPLIT(V_PROJECT_CODE, ','))))
--           AND (TRIM(V_ITEM_ID) IS NULL
--            OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
--            OR  B.ITEM_ID IN (SELECT COLUMN_VALUE
--                                FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''))))
--           AND (TRIM(V_ELECTYPE) IS NULL
--            OR  UPPER(V_ELECTYPE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
--            OR  B.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
--                                       FROM TABLE(STRING_SPLIT(V_ELECTYPE, ','))));
--
--        ELSE
--
--        INSERT INTO GT_SCP0016_DATA1
--        (
--            VERSION_NO
--          , DIVISION_ID
--          , BIZ_TYPE
--          , PROJECT_CODE
--          , ITEM_ID
--          , ELECTRODE_TYPE
--          , ORIGIN_TO_DIVISION_ID
--          , TO_SITE
--          , INCOTERMS
--          , ORIGIN_FROM_DIVISION_ID
--          , FROM_SITE
--          , MEASURE
--          , BOD_ID
--          , QTY
--          , PLAN_START_YYYYMMDD
--          , PLAN_TYPE
--          , SEQ
--          , BIZ_TYPE_NAME
--          , NICK_NAME
--          , TO_SITE_NAME
--          , FROM_SITE_NAME
--          , YYYYMMDD
--        )
--        /* ★차수 목록(A)을 Driving 으로 두어 원장을 차수 열쇠로 찾아간다.
--              지정하지 않으면 해시 조인으로 풀려 사업부·유형만으로 77만 행을 훑는다 */
--        SELECT /*+ LEADING(A B) USE_NL(B) */
--               B.VERSION_NO
--             , B.DIVISION_ID
--             , B.BIZ_TYPE
--             , B.PROJECT_CODE
--             , B.ITEM_ID
--             , B.ELECTRODE_TYPE
--             , B.ORIGIN_TO_DIVISION_ID
--             , B.TO_SITE
--             , B.INCOTERMS
--             , B.ORIGIN_FROM_DIVISION_ID
--             , B.FROM_SITE
--             , B.MEASURE
--             , B.BOD_ID
--             , B.QTY
--             , B.PLAN_START_YYYYMMDD
--             , B.PLAN_TYPE
--             , B.SEQ
--             , B.BIZ_TYPE_NAME
--             , B.NICK_NAME
--             , B.TO_SITE_NAME
--             , B.FROM_SITE_NAME
--             , B.YYYYMMDD
--          FROM GT_SCP0016_VER             A
--             , SCP_ANL_SHIPMENT_PLAN_FG_C B
--         WHERE B.VERSION_NO   = A.VERSION_NO
--           AND B.CUTOFF_DATE  = A.CUTOFF_DATE
--           AND B.YYYYMMDD    >= P_FROM_YYYYMMDD
--           AND B.YYYYMMDD    <= P_TO_YYYYMMDD
--           AND B.DIVISION_ID  = P_DIVISION_ID
--           AND B.BIZ_TYPE     = P_BIZ_TYPE
--           AND (TRIM(V_PROJECT_CODE) IS NULL
--            OR  UPPER(V_PROJECT_CODE) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
--            OR  B.PROJECT_CODE IN (SELECT COLUMN_VALUE
--                                     FROM TABLE(STRING_SPLIT(V_PROJECT_CODE, ','))))
--           AND (TRIM(V_ITEM_ID) IS NULL
--            OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
--            OR  B.ITEM_ID IN (SELECT COLUMN_VALUE
--                                FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''))))
--           AND (TRIM(V_ELECTYPE) IS NULL
--            OR  UPPER(V_ELECTYPE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
--            OR  B.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
--                                       FROM TABLE(STRING_SPLIT(V_ELECTYPE, ','))));
--
--        END IF;
--  2026.10.07 AJS (END)

        /* ==========================================================================================
           2. BOD 뷰에서 필요한 칸만
           ========================================================================================== */
        INSERT INTO GT_SCP0016_BOD
        (
            DIVISION_ID
          , BOD_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , LT_TOTAL
        )
        SELECT DIVISION_ID
             , BOD_ID
             , FROM_SITE
             , TRANSPORT_MODE
             , LT_TOTAL
          FROM SCP_MST_BOD_N_V;

--  2026.10.07 AJS (START) 임시 테이블 PIVOT 적재 제거 — 4-0 피벗 원천에서 원장을 바로 읽는다
--        /* ==========================================================================================
--           3. 피벗 대상 만들기
--              ★전극 갈래는 BOD 를 잇는 칸이 갈린다(AS-IS 분기). CASE 로 합쳤다.
--           ========================================================================================== */
--        INSERT INTO GT_SCP0016_PIVOT
--        (
--            KEY_IDX
--          , VERSION_NO
--          , DIVISION_ID
--          , BIZ_TYPE
--          , PROJECT_CODE
--          , ITEM_ID
--          , ELECTRODE_TYPE
--          , ORIGIN_TO_DIVISION_ID
--          , TO_SITE
--          , INCOTERMS
--          , ORIGIN_FROM_DIVISION_ID
--          , FROM_SITE
--          , TRANSPORT_MODE
--          , LT_DAY
--          , MEASURE
--          , MEASURE_LABEL
--          , MEASURE_ORDER_NO
--          , BOD_ID
--          , QTY
--          , PLAN_START_YYYYMMDD
--          , PLAN_TYPE
--          , SEQ
--          , BIZ_TYPE_NAME
--          , NICK_NAME
--          , TO_SITE_NAME
--          , FROM_SITE_NAME
--          , FROM_YYYYMMDD
--          , TO_YYYYMMDD
--          , YYYYMMDD
--          , YYYYMM
--          , ISO_WEEK
--        )
--        SELECT DISTINCT A.DIVISION_ID || A.BIZ_TYPE || A.PROJECT_CODE || A.ITEM_ID || A.TO_SITE || A.INCOTERMS AS KEY_IDX
--             , A.VERSION_NO
--             , A.DIVISION_ID
--             , A.BIZ_TYPE
--             , A.PROJECT_CODE
--             , A.ITEM_ID
--             , NVL(NULLIF(A.ELECTRODE_TYPE, ''), '-')          AS ELECTRODE_TYPE
--             , NVL(NULLIF(A.ORIGIN_TO_DIVISION_ID, ''), '-')   AS ORIGIN_TO_DIVISION_ID
--             , A.TO_SITE
--             , A.INCOTERMS
--             , NVL(NULLIF(A.ORIGIN_FROM_DIVISION_ID, ''), '-') AS ORIGIN_FROM_DIVISION_ID
--             , A.FROM_SITE
--             , C.TRANSPORT_MODE
--             , C.LT_TOTAL                                      AS LT_DAY
--             , A.MEASURE
--             , B.COLUMN_LABEL_NAME                             AS MEASURE_LABEL
--             , NVL(D.SORT_ORDER_NO, B.SORT_ORDER_NO)            AS MEASURE_ORDER_NO
--             , A.BOD_ID
--             , A.QTY
--             , A.PLAN_START_YYYYMMDD
--             , A.PLAN_TYPE
--             , A.SEQ
--             , A.BIZ_TYPE_NAME
--             , A.NICK_NAME
--             , A.TO_SITE_NAME
--             , A.FROM_SITE_NAME
--             , P_FROM_YYYYMMDD                                 AS FROM_YYYYMMDD
--             , P_TO_YYYYMMDD                                   AS TO_YYYYMMDD
--             , 'D_' || A.YYYYMMDD                              AS YYYYMMDD
--             , E.BASIS_YYYYMM                                  AS YYYYMM
--             , SUBSTR(E.BASIS_YYYYMM, -4) || E.ISO_WEEK        AS ISO_WEEK
--          FROM GT_SCP0016_DATA1        A
--             , SCM_MST_SHEET_MEASURE   B
--             , GT_SCP0016_BOD          C
--             , SCM_MST_TITLESET_USER   D
--             , SCM_SYS_CALENDAR_M      E
--         WHERE E.BASIS_YYYYMMDD  = A.YYYYMMDD
--           AND B.COLUMN_NAME     = A.MEASURE
--           /* ★전극 갈래는 BOD 를 원사업부로 잇는다 */
--           AND C.DIVISION_ID(+)  = CASE WHEN V_IS_EE > 0 THEN A.ORIGIN_FROM_DIVISION_ID
--                                        ELSE A.DIVISION_ID
--                                   END
--           AND C.BOD_ID(+)       = A.BOD_ID
--           AND C.FROM_SITE(+)    = A.FROM_SITE
--           AND D.PROGRAM_ID(+)   = B.PROGRAM_ID
--           AND D.SHEET_NAME(+)   = B.SHEET_NAME
--           AND D.COLUMN_NAME(+)  = B.COLUMN_NAME
--           AND D.USER_ID(+)      = P_USER_ID
--           AND B.PROGRAM_ID      = V_PROGRAM_ID
--           AND B.SHEET_NAME      = V_SHEET_NAME
--           AND B.VALID_YN        = 'Y'
--           AND (V_CNT_USR_MEASURE = 0
--            OR  EXISTS (SELECT 1
--                          FROM SCM_MST_TITLESET_USER XA
--                         WHERE XA.PROGRAM_ID  = V_PROGRAM_ID
--                           AND XA.SHEET_NAME  = V_SHEET_NAME
--                           AND XA.USER_ID     = P_USER_ID
--                           AND XA.COLUMN_NAME = B.COLUMN_NAME));
--  2026.10.07 AJS (END)

        /* ==========================================================================================
           4. 피벗 — ★조회 기간에 따라 결과 칸이 달라져 동적으로 둔다
           ========================================================================================== */
        /* 2026.11.04 AJS PIVOT IN 목록 · 기간 칸 목록 (START) */
        V_PIVOT     := F_PIVOT_COLUMNS(P_FROM_YYYYMMDD, P_TO_YYYYMMDD, 'QTY');
        V_PIVOT_COL := F_PIVOT_COLUMNS(P_FROM_YYYYMMDD, P_TO_YYYYMMDD, 'COL');
        IF DBMS_LOB.GETLENGTH(V_PIVOT) > 0 THEN
            V_PIVOT := SUBSTR(V_PIVOT, 3);
        ELSE
            V_PIVOT := '''-'' AS "NO_PERIOD"';   /* 기간 칸이 없는 조건 : PIVOT 문법용 · 바깥 칸 목록에 나오지 않음 */
        END IF;
        /* 2026.11.04 AJS PIVOT IN 목록 · 기간 칸 목록 (END) */

--  2026.10.07 AJS (START) 피벗 원천 조회문
        /* ==========================================================================================
           4-0. 피벗 원천 — ★출하계획 원장을 피벗 조회에서 바로 읽는다(중간 임시 테이블 적재 없음).
                칸·조건은 원래 1·3 적재문과 같다. 차수를 고르지 않았으면 차수 조건을 붙이지 않는다.
                전극 갈래는 BOD 를 원사업부로 잇는다.
           ========================================================================================== */
        /* LT_DAY 는 문자형으로 받음 · 조회조건 ALL 은 조건 없음 */
        V_SRC := 'SELECT ' || CASE WHEN TRIM(V_VERSION_NO) IS NULL THEN NULL
                                   ELSE '/*+ LEADING(SA SB) USE_NL(SB) USE_HASH(SF SC SD) SWAP_JOIN_INPUTS(SF) SWAP_JOIN_INPUTS(SC) SWAP_JOIN_INPUTS(SD) */ '
                              END || 'DISTINCT SB.DIVISION_ID || SB.BIZ_TYPE || SB.PROJECT_CODE || SB.ITEM_ID || SB.TO_SITE || SB.INCOTERMS AS KEY_IDX
                     , SB.VERSION_NO
                     , SB.DIVISION_ID
                     , SB.BIZ_TYPE
                     , SB.PROJECT_CODE
                     , SB.ITEM_ID
                     , NVL(NULLIF(SB.ELECTRODE_TYPE, ''''), ''-'')          AS ELECTRODE_TYPE
                     , NVL(NULLIF(SB.ORIGIN_TO_DIVISION_ID, ''''), ''-'')   AS ORIGIN_TO_DIVISION_ID
                     , SB.TO_SITE
                     , SB.INCOTERMS
                     , NVL(NULLIF(SB.ORIGIN_FROM_DIVISION_ID, ''''), ''-'') AS ORIGIN_FROM_DIVISION_ID
                     , SB.FROM_SITE
                     , SD.TRANSPORT_MODE
                     , TO_CHAR(SD.LT_TOTAL)                                 AS LT_DAY
                     , SB.MEASURE
                     , SC.COLUMN_LABEL_NAME                                 AS MEASURE_LABEL
                     , NVL(SE.SORT_ORDER_NO, SC.SORT_ORDER_NO)              AS MEASURE_ORDER_NO
                     , SB.BOD_ID
                     , SB.QTY
                     , SB.PLAN_START_YYYYMMDD
                     , SB.PLAN_TYPE
                     , SB.SEQ
                     , SB.BIZ_TYPE_NAME
                     , SB.NICK_NAME
                     , SB.TO_SITE_NAME
                     , SB.FROM_SITE_NAME
                     , :P_FROM_YYYYMMDD                                     AS FROM_YYYYMMDD
                     , :P_TO_YYYYMMDD                                       AS TO_YYYYMMDD
                     , ''D_'' || SB.YYYYMMDD                                AS YYYYMMDD
                     , SF.BASIS_YYYYMM                                      AS YYYYMM
                     , SUBSTR(SF.BASIS_YYYYMM, -4) || SF.ISO_WEEK           AS ISO_WEEK
                  FROM ' || CASE WHEN TRIM(V_VERSION_NO) IS NULL THEN NULL
                                 ELSE 'GT_SCP0016_VER             SA
                     , '
                            END || 'SCP_ANL_SHIPMENT_PLAN_FG_C SB
                     , SCM_MST_SHEET_MEASURE      SC
                     , GT_SCP0016_BOD             SD
                     , SCM_MST_TITLESET_USER      SE
                     , SCM_SYS_CALENDAR_M         SF
                 WHERE ' || CASE WHEN TRIM(V_VERSION_NO) IS NULL THEN NULL
                                 ELSE 'SB.VERSION_NO      = SA.VERSION_NO
                   AND SB.CUTOFF_DATE     = SA.CUTOFF_DATE
                   AND '
                            END || 'SF.BASIS_YYYYMMDD  = SB.YYYYMMDD
                   AND SC.COLUMN_NAME     = SB.MEASURE
                   AND SD.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'SB.ORIGIN_FROM_DIVISION_ID' ELSE 'SB.DIVISION_ID' END || '
                   AND SD.BOD_ID(+)       = SB.BOD_ID
                   AND SD.FROM_SITE(+)    = SB.FROM_SITE
                   AND SE.PROGRAM_ID(+)   = SC.PROGRAM_ID
                   AND SE.SHEET_NAME(+)   = SC.SHEET_NAME
                   AND SE.COLUMN_NAME(+)  = SC.COLUMN_NAME
                   AND SE.USER_ID(+)      = :P_USER_ID
                   AND SC.PROGRAM_ID      = :V_PROGRAM_ID
                   AND SC.SHEET_NAME      = :V_SHEET_NAME
                   AND SC.VALID_YN        = ''Y''
                   AND (:V_CNT_USR_MEASURE = 0
                    OR  EXISTS (SELECT 1
                                  FROM SCM_MST_TITLESET_USER XA
                                 WHERE XA.PROGRAM_ID  = :V_PROGRAM_ID
                                   AND XA.SHEET_NAME  = :V_SHEET_NAME
                                   AND XA.USER_ID     = :P_USER_ID
                                   AND XA.COLUMN_NAME = SC.COLUMN_NAME))
                   AND SB.YYYYMMDD       >= :P_FROM_YYYYMMDD
                   AND SB.YYYYMMDD       <= :P_TO_YYYYMMDD
                   AND SB.DIVISION_ID     = :P_DIVISION_ID
                   AND SB.BIZ_TYPE        = :P_BIZ_TYPE
                   AND (TRIM(:V_PROJECT_CODE) IS NULL
                    OR  UPPER(:V_PROJECT_CODE) = ''ALL''
                    OR  UPPER(SB.PROJECT_CODE) IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(:V_PROJECT_CODE, '',''))))
                   AND (TRIM(:V_ITEM_ID) IS NULL
                    OR  UPPER(:V_ITEM_ID) = ''ALL''
                    OR  SB.ITEM_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(:V_ITEM_TAB)))
                   AND (TRIM(:V_ELECTYPE) IS NULL
                    OR  UPPER(:V_ELECTYPE) = ''ALL''
                    OR  SB.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(:V_ELECTYPE, '','')))) ';
--  2026.10.07 AJS (END)

        /* 재고(BOH) : 공용 함수 FN_GET_SCP_ANL_BOH_QTY 와 같은 규칙을 조회문 안에서 계산
           사이트 유형이 PLANT 이면 공장 재고(활성화 이후 재고 유형 제외), 아니면 판매 재고
           같은 KEY 는 한 번만 읽고, 파티션 KEY(계획시작일)로 해당 분할만 읽음 */
        V_SQL := 'SELECT IA.*
     , NVL(B.PROJECT_NAME, ''-'')                                            AS PROJECT_NAME
     , NVL(B.PROJECT_OWNER, ''-'')                                           AS PROJECT_OWNER
     , NVL(FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', C.ITEM_TYPE), ''-'')  AS ITEM_TYPE
     , NVL(E.DEPT_NAME_KO, ''-'')                                            AS DEPT_NAME_KO
  FROM (SELECT KEY_IDX
             , DIVISION_ID
             , BIZ_TYPE                              AS "BIZ_TYPE"
             , BIZ_TYPE_NAME                         AS "BIZ_TYPE_NAME"
             , PROJECT_CODE                          AS "PROJECT_CODE"
             , ITEM_ID                               AS "ITEM_ID"
             , CASE WHEN NICK_NAME IS NULL THEN ''-''
                    ELSE NICK_NAME
               END                                   AS "NICK_NAME"
             , ELECTRODE_TYPE
             , ORIGIN_TO_DIVISION_ID
             , TO_SITE                               AS "TO_SITE"
             , TO_SITE_NAME                          AS "TO_SITE_NAME"
             , INCOTERMS                             AS "INCOTERMS"
             , ORIGIN_FROM_DIVISION_ID
             , FROM_SITE                             AS "FROM_SITE"
             , NVL(FROM_SITE_NAME, ''-'')            AS "FROM_SITE_NAME"
             , BOD_ID                                AS "BOD_ID"
             , NVL(TRANSPORT_MODE, ''-'')            AS "TRANSPORT_MODE"
             , NVL(LT_DAY, 0)                        AS "LT_DAY"
             , PLAN_START_YYYYMMDD                   AS "PLAN_START_YYYYMMDD"
             , PLAN_TYPE                             AS "PLAN_TYPE"
             , SEQ                                   AS "SEQ"
             , CAST(ROUND(NVL(CASE WHEN (SELECT XD.SITE_TYPE
                                           FROM SCM_MST_SITE XD
                                          WHERE XD.SCM_SITE_ID = IB.TO_SITE
                                            AND ROWNUM         = 1) = ''PLANT''
                                   THEN (SELECT SUM(NVL(XB.PSI_BOH_QTY, 0))
                                           FROM SCP_OPT_PLANT_ONHAND_V XB
                                          WHERE XB.DIVISION_ID              = IB.DIVISION_ID
                                            AND XB.STOCK_TYPE NOT IN (''FOR_STOCKPLAN'', ''FORMING'', ''FORMED'', ''CHARING'', ''CHAR'', ''A_MOVE_WH'', ''A_OUT_WH'')
                                            AND XB.PLAN_START_YYYYMMDD      = IB.PLAN_START_YYYYMMDD
                                            AND XB.PLAN_START_YYYYMMDD_DATE = TO_DATE(IB.PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, ''YYYYMMDD'')
                                            AND XB.PLAN_TYPE                = IB.PLAN_TYPE
                                            AND XB.SEQ                      = IB.SEQ
                                            AND XB.SITE_ID                  = IB.TO_SITE
                                            AND XB.ITEM_ID                  = IB.ITEM_ID
                                            AND XB.YYYYMMDD                 = IB.FROM_YYYYMMDD)
                                   ELSE (SELECT SUM(NVL(XC.PSI_BOH_QTY, 0))
                                           FROM SCP_PLN_SALES_ONHAND_V XC
                                          WHERE XC.DIVISION_ID              = IB.DIVISION_ID
                                            AND XC.PLAN_START_YYYYMMDD      = IB.PLAN_START_YYYYMMDD
                                            AND XC.PLAN_START_YYYYMMDD_DATE = TO_DATE(IB.PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, ''YYYYMMDD'')
                                            AND XC.PLAN_TYPE                = IB.PLAN_TYPE
                                            AND XC.SEQ                      = IB.SEQ
                                            AND XC.SITE_ID                  = IB.TO_SITE
                                            AND XC.ITEM_ID                  = IB.ITEM_ID
                                            AND XC.YYYYMMDD                 = IB.FROM_YYYYMMDD)
                              END, 0), 1) AS NUMBER(10, 0)) AS "BOH"
             , VERSION_NO                            AS "VERSION_NO"
             , MEASURE                               AS "MEASURE"
             , MEASURE_ORDER_NO                      AS "MEASURE_ORDER_NO"
             , MEASURE_LABEL                         AS "MEASURE_LABEL"
             , FROM_YYYYMMDD                         AS "FROM_YYYYMMDD"
             , TO_YYYYMMDD                           AS "TO_YYYYMMDD"
             ' || V_PIVOT_COL || '
          FROM (SELECT IC.KEY_IDX
                     , IC.DIVISION_ID
                     , IC.BIZ_TYPE
                     , IC.BIZ_TYPE_NAME
                     , IC.PROJECT_CODE
                     , IC.ITEM_ID
                     , IC.NICK_NAME
                     , IC.ELECTRODE_TYPE
                     , IC.ORIGIN_TO_DIVISION_ID
                     , IC.TO_SITE
                     , IC.TO_SITE_NAME
                     , IC.INCOTERMS
                     , IC.ORIGIN_FROM_DIVISION_ID
                     , IC.FROM_SITE
                     , IC.FROM_SITE_NAME
                     , IC.BOD_ID
                     , IC.TRANSPORT_MODE
                     , IC.LT_DAY
                     , IC.PLAN_START_YYYYMMDD
                     , IC.PLAN_TYPE
                     , IC.SEQ
                     , IC.VERSION_NO
                     , IC.MEASURE
                     , IC.MEASURE_ORDER_NO
                     , IC.MEASURE_LABEL
                     , IC.FROM_YYYYMMDD
                     , IC.TO_YYYYMMDD
                     , IC.QTY
                     , CASE ID.PVT_TYPE WHEN 1 THEN ''M_'' || IC.YYYYMM
                                        WHEN 2 THEN ''W''  || IC.ISO_WEEK
                                        ELSE IC.YYYYMMDD
                       END AS PVT_KEY
                  FROM (' || V_SRC || ') IC
                     , (SELECT 1 AS PVT_TYPE FROM DUAL
                        UNION ALL
                        SELECT 2 FROM DUAL
                        UNION ALL
                        SELECT 3 FROM DUAL) ID)
         PIVOT (SUM(QTY) FOR PVT_KEY IN (' || V_PIVOT || ')) IB
                ) IA
     , (SELECT DIVISION_ID
             , PROJECT_CODE
             , PROJECT_NAME
             , PROJECT_OWNER
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC) AS NUMS
          FROM SCM_MST_PROJECT) B
     , (SELECT DIVISION_ID
             , ITEM_ID
             , ITEM_NAME
             , NICK_NAME
             , ITEM_TYPE
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID
                                      ORDER BY CASE ITEM_TYPE WHEN ''P'' THEN 999
                                                              WHEN ''H'' THEN 888
                                                              WHEN ''R'' THEN 777
                                                              WHEN ''Q'' THEN 666
                                                              ELSE 0
                                               END DESC) AS NUMS
          FROM SCM_MST_ITEM_SN) C
     , SCM_MST_SITE_DEPT_REP_V D
     , SCM_MST_SSO_DEPT_INFO  E
 WHERE B.PROJECT_CODE(+) = IA."PROJECT_CODE"
   AND B.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND B.NUMS(+)         = 1
   AND C.ITEM_ID(+)      = IA."ITEM_ID"
   AND C.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND C.NUMS(+)         = 1
   ' || CASE WHEN V_IS_EE > 0
             THEN 'AND D.DIVISION_ID(+) = IA.ORIGIN_FROM_DIVISION_ID
   AND D.SCM_SITE_ID(+) = FN_GET_SITE_NAME_SHIPMENT(IA."TO_SITE")'   --  2026.10.08 AJS
--   AND D.SCM_SITE_ID(+) = FN_GET_SITE_NAME_SHIPMENT(IA."to_site")'   --  2026.10.08 AJS
             ELSE 'AND D.DIVISION_ID(+) = IA.DIVISION_ID
   AND D.SCM_SITE_ID(+) = IA."TO_SITE"'   --  2026.10.08 AJS
--   AND D.SCM_SITE_ID(+) = IA."to_site"'   --  2026.10.08 AJS
        END || '
   AND E.DEPT_ID(+)      = D.DEPT_ID
 ORDER BY FN_ASIS_SORT_KEY(IA.DIVISION_ID)          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."BIZ_TYPE")           NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."ITEM_ID")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."TO_SITE")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."PROJECT_CODE")       NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."INCOTERMS")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."FROM_SITE")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."BOD_ID")             NULLS FIRST
        , IA."MEASURE_ORDER_NO"
        , FN_ASIS_SORT_KEY(IA."VERSION_NO")         NULLS FIRST';   --  2026.10.08 AJS
--        , FN_ASIS_SORT_KEY(IA."version_no")         NULLS FIRST';   --  2026.10.08 AJS

--  2026.10.07 AJS (START) 피벗 원천 조회조건 값 전달
--        OPEN O_RC1 FOR V_SQL;
        OPEN O_RC1 FOR V_SQL
            USING P_FROM_YYYYMMDD
                , P_TO_YYYYMMDD
                , P_USER_ID
                , V_PROGRAM_ID
                , V_SHEET_NAME
                , V_CNT_USR_MEASURE
                , V_PROGRAM_ID
                , V_SHEET_NAME
                , P_USER_ID
                , P_FROM_YYYYMMDD
                , P_TO_YYYYMMDD
                , P_DIVISION_ID
                , P_BIZ_TYPE
                , V_PROJECT_CODE
                , V_PROJECT_CODE
                , V_PROJECT_CODE
                , V_ITEM_ID
                , V_ITEM_ID
                , V_ITEM_TAB   --  2026.11.04 AJS
                , V_ELECTYPE
                , V_ELECTYPE
                , V_ELECTYPE;
--  2026.10.07 AJS (END)

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG(C_PROGRAM_NAME, SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL;

    /* ==============================================================================================
       SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL — 머리
       ★값을 채우지 않고 칸 이름만 만든다. AS-IS 화면이 기간을 넉 달씩 잘라 병렬로 부르고
         마지막 차례에 이 결과로 그리드 칸을 세운다.
       ============================================================================================== */
    PROCEDURE P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL
    (
        P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_DIVISION_ID       IN  VARCHAR2
      , P_BIZ_TYPE          IN  VARCHAR2
      , P_PROJECT_CODE      IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VERSION_NO        IN  CLOB
      , P_ELECTYPE          IN  CLOB
      , P_ISO               IN  VARCHAR2
      , P_PROGRAM_ID        IN  VARCHAR2
      , P_SHEET_NAME        IN  VARCHAR2
      , P_USER_ID           IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_PROJECT_CODE      VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_PROJECT_CODE, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
        V_ITEM_TAB          T_STR_TAB            := T_STR_TAB();   --  2026.11.04 AJS
        V_VERSION_NO        VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_VERSION_NO, 1, 32767));
        V_CUTOFF            DATE;
        V_NEXT_CUTOFF       DATE;
        V_ELECTYPE          VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ELECTYPE, 1, 32767));
        V_PROGRAM_ID        VARCHAR2(200 CHAR)   := NVL(P_PROGRAM_ID, 'SCP0016');
        V_SHEET_NAME        VARCHAR2(200 CHAR)   := NVL(P_SHEET_NAME, 'Shipment Plan FG');
        V_ISO               VARCHAR2(4 CHAR)     := NVL(P_ISO, 'F');
        V_CNT_USR_MEASURE   PLS_INTEGER;
        V_IS_EE             PLS_INTEGER;
        V_PIVOT             CLOB;
        V_SQL               CLOB;
    BEGIN
        /* 2026.11.04 AJS 모델 조회조건 품목 목록 사전 적재 (START) */
        IF TRIM(V_ITEM_ID) IS NOT NULL
       AND UPPER(V_ITEM_ID) <> 'ALL' THEN
            SELECT COLUMN_VALUE
              BULK COLLECT INTO V_ITEM_TAB
              FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''));
        END IF;
        /* 2026.11.04 AJS 모델 조회조건 품목 목록 사전 적재 (END) */

        V_CNT_USR_MEASURE := F_CNT_USR_MEASURE(V_PROGRAM_ID, V_SHEET_NAME, P_USER_ID);

        SELECT COUNT(*)
          INTO V_IS_EE
          FROM TABLE(FN_GET_DIVISION_DIV('EE'))
         WHERE COLUMN_VALUE = P_DIVISION_ID;

        DELETE FROM GT_SCP0016_PIVOT;
--  2026.11.03 AJS (START) E20261020-000662 BOD 뷰를 임시 테이블에 받아 조인
        DELETE FROM GT_SCP0016_BOD;

        INSERT INTO GT_SCP0016_BOD
        (
            DIVISION_ID
          , BOD_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , LT_TOTAL
        )
        SELECT DIVISION_ID
             , BOD_ID
             , FROM_SITE
             , TRANSPORT_MODE
             , LT_TOTAL
          FROM SCP_MST_BOD_N_V;
--  2026.11.03 AJS (END)

        /* ==========================================================================================
           0. 고른 차수 목록 — ★원장이 사업부·차수 열쇠로 바로 찾아가게 한다.
              차수를 고르지 않았으면 비어 있고, 그때는 아래에서 차수 조건 없는 문장을 쓴다
           ========================================================================================== */
        DELETE FROM GT_SCP0016_VER;

        /* ★마감일시를 하나씩 올려 가며 모은다. 한 번에 DISTINCT 로 뽑으면 그 차수의 전 행을
              훑어 20초가 넘지만, 최솟값 조회는 열쇠만 보고 끝난다 */
        FOR C IN (SELECT DISTINCT COLUMN_VALUE AS VERSION_NO
                    FROM TABLE(STRING_SPLIT(V_VERSION_NO, ',')))
        LOOP
            V_CUTOFF := NULL;

            LOOP
                IF V_CUTOFF IS NULL THEN
                    SELECT MIN(A.CUTOFF_DATE)
                      INTO V_NEXT_CUTOFF
                      FROM SCP_ANL_SHIPMENT_PLAN_FG_C A
                     WHERE A.DIVISION_ID = P_DIVISION_ID
                       AND A.VERSION_NO  = C.VERSION_NO;
                ELSE
                    SELECT MIN(A.CUTOFF_DATE)
                      INTO V_NEXT_CUTOFF
                      FROM SCP_ANL_SHIPMENT_PLAN_FG_C A
                     WHERE A.DIVISION_ID = P_DIVISION_ID
                       AND A.VERSION_NO  = C.VERSION_NO
                       AND A.CUTOFF_DATE > V_CUTOFF;
                END IF;

                EXIT WHEN V_NEXT_CUTOFF IS NULL;

                INSERT INTO GT_SCP0016_VER
                (
                    VERSION_NO
                  , CUTOFF_DATE
                )
                VALUES (C.VERSION_NO, V_NEXT_CUTOFF);

                V_CUTOFF := V_NEXT_CUTOFF;
            END LOOP;
        END LOOP;

        /* ==========================================================================================
           1. 피벗 대상 만들기 — ★머리 조회는 원장에서 바로 읽는다(중간 임시 자료를 거치지 않는다)
              수량 · 일자 · 월 · 주 칸은 채우지 않는다.
           ========================================================================================== */
        /* ★차수를 고르지 않았으면 조건을 붙이지 않는다 — 원문과 같다 */
        IF TRIM(V_VERSION_NO) IS NULL THEN

        INSERT INTO GT_SCP0016_PIVOT
        (
            KEY_IDX
          , VERSION_NO
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , INCOTERMS
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , LT_DAY
          , MEASURE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , BOD_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , BIZ_TYPE_NAME
          , NICK_NAME
          , TO_SITE_NAME
          , FROM_SITE_NAME
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        SELECT DISTINCT A.DIVISION_ID || A.BIZ_TYPE || A.PROJECT_CODE || A.ITEM_ID || A.TO_SITE || A.INCOTERMS AS KEY_IDX
             , A.VERSION_NO
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , NVL(NULLIF(A.ELECTRODE_TYPE, ''), '-')          AS ELECTRODE_TYPE
             , NVL(NULLIF(A.ORIGIN_TO_DIVISION_ID, ''), '-')   AS ORIGIN_TO_DIVISION_ID
             , A.TO_SITE
             , A.INCOTERMS
             , NVL(NULLIF(A.ORIGIN_FROM_DIVISION_ID, ''), '-') AS ORIGIN_FROM_DIVISION_ID
             , A.FROM_SITE
             , C.TRANSPORT_MODE
             , C.LT_TOTAL                                      AS LT_DAY
             , A.MEASURE
             , B.COLUMN_LABEL_NAME                             AS MEASURE_LABEL
             , NVL(D.SORT_ORDER_NO, B.SORT_ORDER_NO)            AS MEASURE_ORDER_NO
             , A.BOD_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.BIZ_TYPE_NAME
             , A.NICK_NAME
             , A.TO_SITE_NAME
             , A.FROM_SITE_NAME
             , P_FROM_YYYYMMDD                                 AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                                   AS TO_YYYYMMDD
          FROM SCP_ANL_SHIPMENT_PLAN_FG_C A
             , SCM_MST_SHEET_MEASURE      B
--             , SCP_MST_BOD_N_V            C   --  2026.11.03 AJS
             , GT_SCP0016_BOD             C   --  2026.11.03 AJS
             , SCM_MST_TITLESET_USER      D
             , SCM_SYS_CALENDAR_M         E
         WHERE E.BASIS_YYYYMMDD  = A.YYYYMMDD
           AND B.COLUMN_NAME     = A.MEASURE
           AND C.DIVISION_ID(+)  = CASE WHEN V_IS_EE > 0 THEN A.ORIGIN_FROM_DIVISION_ID
                                        ELSE A.DIVISION_ID
                                   END
           AND C.BOD_ID(+)       = A.BOD_ID
           AND C.FROM_SITE(+)    = A.FROM_SITE
           AND D.PROGRAM_ID(+)   = B.PROGRAM_ID
           AND D.SHEET_NAME(+)   = B.SHEET_NAME
           AND D.COLUMN_NAME(+)  = B.COLUMN_NAME
           AND D.USER_ID(+)      = P_USER_ID
           AND B.PROGRAM_ID      = V_PROGRAM_ID
           AND B.SHEET_NAME      = V_SHEET_NAME
           AND B.VALID_YN        = 'Y'
           AND (V_CNT_USR_MEASURE = 0
            OR  EXISTS (SELECT 1
                          FROM SCM_MST_TITLESET_USER XA
                         WHERE XA.PROGRAM_ID  = V_PROGRAM_ID
                           AND XA.SHEET_NAME  = V_SHEET_NAME
                           AND XA.USER_ID     = P_USER_ID
                           AND XA.COLUMN_NAME = B.COLUMN_NAME))
           AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD       <= P_TO_YYYYMMDD
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.BIZ_TYPE        = P_BIZ_TYPE
           AND (TRIM(V_PROJECT_CODE) IS NULL
            OR  UPPER(V_PROJECT_CODE) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
--            OR  A.PROJECT_CODE IN (SELECT COLUMN_VALUE   --  2026.11.03 AJS
            OR  UPPER(A.PROJECT_CODE) IN (SELECT UPPER(COLUMN_VALUE)   --  2026.11.03 AJS
                                     FROM TABLE(STRING_SPLIT(V_PROJECT_CODE, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''))))   --  2026.11.04 AJS
                                FROM TABLE(V_ITEM_TAB)))   --  2026.11.04 AJS
           AND (TRIM(V_ELECTYPE) IS NULL
            OR  UPPER(V_ELECTYPE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(V_ELECTYPE, ','))));

        ELSE

        INSERT INTO GT_SCP0016_PIVOT
        (
            KEY_IDX
          , VERSION_NO
          , DIVISION_ID
          , BIZ_TYPE
          , PROJECT_CODE
          , ITEM_ID
          , ELECTRODE_TYPE
          , ORIGIN_TO_DIVISION_ID
          , TO_SITE
          , INCOTERMS
          , ORIGIN_FROM_DIVISION_ID
          , FROM_SITE
          , TRANSPORT_MODE
          , LT_DAY
          , MEASURE
          , MEASURE_LABEL
          , MEASURE_ORDER_NO
          , BOD_ID
          , PLAN_START_YYYYMMDD
          , PLAN_TYPE
          , SEQ
          , BIZ_TYPE_NAME
          , NICK_NAME
          , TO_SITE_NAME
          , FROM_SITE_NAME
          , FROM_YYYYMMDD
          , TO_YYYYMMDD
        )
        /* ★차수 목록(F)을 Driving 으로 두어 원장을 열쇠(사업부·차수)로 찾아간다 */
        SELECT /*+ LEADING(F A) USE_NL(A) */
               DISTINCT A.DIVISION_ID || A.BIZ_TYPE || A.PROJECT_CODE || A.ITEM_ID || A.TO_SITE || A.INCOTERMS AS KEY_IDX
             , A.VERSION_NO
             , A.DIVISION_ID
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.ITEM_ID
             , NVL(NULLIF(A.ELECTRODE_TYPE, ''), '-')          AS ELECTRODE_TYPE
             , NVL(NULLIF(A.ORIGIN_TO_DIVISION_ID, ''), '-')   AS ORIGIN_TO_DIVISION_ID
             , A.TO_SITE
             , A.INCOTERMS
             , NVL(NULLIF(A.ORIGIN_FROM_DIVISION_ID, ''), '-') AS ORIGIN_FROM_DIVISION_ID
             , A.FROM_SITE
             , C.TRANSPORT_MODE
             , C.LT_TOTAL                                      AS LT_DAY
             , A.MEASURE
             , B.COLUMN_LABEL_NAME                             AS MEASURE_LABEL
             , NVL(D.SORT_ORDER_NO, B.SORT_ORDER_NO)            AS MEASURE_ORDER_NO
             , A.BOD_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.BIZ_TYPE_NAME
             , A.NICK_NAME
             , A.TO_SITE_NAME
             , A.FROM_SITE_NAME
             , P_FROM_YYYYMMDD                                 AS FROM_YYYYMMDD
             , P_TO_YYYYMMDD                                   AS TO_YYYYMMDD
          FROM GT_SCP0016_VER             F
             , SCP_ANL_SHIPMENT_PLAN_FG_C A
             , SCM_MST_SHEET_MEASURE      B
--             , SCP_MST_BOD_N_V            C   --  2026.11.03 AJS
             , GT_SCP0016_BOD             C   --  2026.11.03 AJS
             , SCM_MST_TITLESET_USER      D
             , SCM_SYS_CALENDAR_M         E
         WHERE A.VERSION_NO      = F.VERSION_NO
           AND A.CUTOFF_DATE     = F.CUTOFF_DATE
           AND E.BASIS_YYYYMMDD  = A.YYYYMMDD
           AND B.COLUMN_NAME     = A.MEASURE
           AND C.DIVISION_ID(+)  = CASE WHEN V_IS_EE > 0 THEN A.ORIGIN_FROM_DIVISION_ID
                                        ELSE A.DIVISION_ID
                                   END
           AND C.BOD_ID(+)       = A.BOD_ID
           AND C.FROM_SITE(+)    = A.FROM_SITE
           AND D.PROGRAM_ID(+)   = B.PROGRAM_ID
           AND D.SHEET_NAME(+)   = B.SHEET_NAME
           AND D.COLUMN_NAME(+)  = B.COLUMN_NAME
           AND D.USER_ID(+)      = P_USER_ID
           AND B.PROGRAM_ID      = V_PROGRAM_ID
           AND B.SHEET_NAME      = V_SHEET_NAME
           AND B.VALID_YN        = 'Y'
           AND (V_CNT_USR_MEASURE = 0
            OR  EXISTS (SELECT 1
                          FROM SCM_MST_TITLESET_USER XA
                         WHERE XA.PROGRAM_ID  = V_PROGRAM_ID
                           AND XA.SHEET_NAME  = V_SHEET_NAME
                           AND XA.USER_ID     = P_USER_ID
                           AND XA.COLUMN_NAME = B.COLUMN_NAME))
           AND A.YYYYMMDD       >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD       <= P_TO_YYYYMMDD
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.BIZ_TYPE        = P_BIZ_TYPE
           AND (TRIM(V_PROJECT_CODE) IS NULL
            OR  UPPER(V_PROJECT_CODE) = 'ALL'                    /* 조회조건 ALL 은 조건 없음 */
--            OR  A.PROJECT_CODE IN (SELECT COLUMN_VALUE   --  2026.11.03 AJS
            OR  UPPER(A.PROJECT_CODE) IN (SELECT UPPER(COLUMN_VALUE)   --  2026.11.03 AJS
                                     FROM TABLE(STRING_SPLIT(V_PROJECT_CODE, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''))))   --  2026.11.04 AJS
                                FROM TABLE(V_ITEM_TAB)))   --  2026.11.04 AJS
           AND (TRIM(V_ELECTYPE) IS NULL
            OR  UPPER(V_ELECTYPE) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                       FROM TABLE(STRING_SPLIT(V_ELECTYPE, ','))));

        END IF;

        /* ==========================================================================================
           2. 머리 — 칸 이름만 만든다. 주 칸은 P_ISO 로 가른다.
           ========================================================================================== */
        V_PIVOT := F_PIVOT_COLUMNS(P_FROM_YYYYMMDD, P_TO_YYYYMMDD, 'TITLE', V_ISO);

        V_SQL := 'SELECT IA.*
     , NVL(B.PROJECT_NAME, ''-'')                                            AS PROJECT_NAME
     , NVL(B.PROJECT_OWNER, ''-'')                                           AS PROJECT_OWNER
     , NVL(FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', C.ITEM_TYPE), ''-'')  AS ITEM_TYPE
     , NVL(E.DEPT_NAME_KO, ''-'')                                            AS DEPT_NAME_KO
  FROM (SELECT KEY_IDX
             , DIVISION_ID
             , BIZ_TYPE                              AS "BIZ_TYPE"
             , BIZ_TYPE_NAME                         AS "BIZ_TYPE_NAME"
             , PROJECT_CODE                          AS "PROJECT_CODE"
             , ITEM_ID                               AS "ITEM_ID"
             , CASE WHEN NICK_NAME IS NULL THEN ''-''
                    ELSE NICK_NAME
               END                                   AS "NICK_NAME"
             , ELECTRODE_TYPE
             , ORIGIN_TO_DIVISION_ID
             , TO_SITE                               AS "TO_SITE"
             , TO_SITE_NAME                          AS "TO_SITE_NAME"
             , INCOTERMS                             AS "INCOTERMS"
             , ORIGIN_FROM_DIVISION_ID
             , FROM_SITE                             AS "FROM_SITE"
             , NVL(FROM_SITE_NAME, ''-'')            AS "FROM_SITE_NAME"
             , BOD_ID                                AS "BOD_ID"
             , NVL(TRANSPORT_MODE, ''-'')            AS "TRANSPORT_MODE"
             , NVL(LT_DAY, 0)                        AS "LT_DAY"
             , PLAN_START_YYYYMMDD                   AS "PLAN_START_YYYYMMDD"
             , PLAN_TYPE                             AS "PLAN_TYPE"
             , SEQ                                   AS "SEQ"
             , CAST(ROUND(FN_GET_SCP_ANL_BOH_QTY(DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, TO_SITE, ITEM_ID, FROM_YYYYMMDD), 1) AS NUMBER(10, 0)) AS "BOH"
             , VERSION_NO                            AS "VERSION_NO"
             , MEASURE                               AS "MEASURE"
             , MEASURE_ORDER_NO                      AS "MEASURE_ORDER_NO"
             , MEASURE_LABEL                         AS "MEASURE_LABEL"
             , FROM_YYYYMMDD                         AS "FROM_YYYYMMDD"
             , TO_YYYYMMDD                           AS "TO_YYYYMMDD"
             ' || V_PIVOT || '
          FROM GT_SCP0016_PIVOT) IA
     , (SELECT DIVISION_ID
             , PROJECT_CODE
             , PROJECT_NAME
             , PROJECT_OWNER
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, PROJECT_CODE ORDER BY PROJECT_VER_SEQ ASC) AS NUMS
          FROM SCM_MST_PROJECT) B
     , (SELECT DIVISION_ID
             , ITEM_ID
             , ITEM_TYPE
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID
                                      ORDER BY CASE ITEM_TYPE WHEN ''P'' THEN 999
                                                              WHEN ''H'' THEN 888
                                                              WHEN ''R'' THEN 777
                                                              WHEN ''Q'' THEN 666
                                                              ELSE 0
                                               END DESC) AS NUMS
          FROM SCM_MST_ITEM_SN) C
     , SCM_MST_SITE_DEPT_REP_V D
     , SCM_MST_SSO_DEPT_INFO  E
 WHERE B.PROJECT_CODE(+) = IA."PROJECT_CODE"
   AND B.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND B.NUMS(+)         = 1
   AND C.ITEM_ID(+)      = IA."ITEM_ID"
   AND C.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND C.NUMS(+)         = 1
   ' || CASE WHEN V_IS_EE > 0
             THEN 'AND D.DIVISION_ID(+) = IA.ORIGIN_FROM_DIVISION_ID
   AND D.SCM_SITE_ID(+) = FN_GET_SITE_NAME_SHIPMENT(IA."TO_SITE")'   --  2026.10.08 AJS
--   AND D.SCM_SITE_ID(+) = FN_GET_SITE_NAME_SHIPMENT(IA."to_site")'   --  2026.10.08 AJS
             ELSE 'AND D.DIVISION_ID(+) = IA.DIVISION_ID
   AND D.SCM_SITE_ID(+) = IA."TO_SITE"'   --  2026.10.08 AJS
--   AND D.SCM_SITE_ID(+) = IA."to_site"'   --  2026.10.08 AJS
        END || '
   AND E.DEPT_ID(+)      = D.DEPT_ID
 ORDER BY FN_ASIS_SORT_KEY(IA.DIVISION_ID)          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."BIZ_TYPE")           NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."ITEM_ID")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."TO_SITE")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."PROJECT_CODE")       NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."INCOTERMS")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."FROM_SITE")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."BOD_ID")             NULLS FIRST
        , IA."MEASURE_ORDER_NO"
        , FN_ASIS_SORT_KEY(IA."VERSION_NO")         NULLS FIRST';   --  2026.10.08 AJS
--        , FN_ASIS_SORT_KEY(IA."version_no")         NULLS FIRST';   --  2026.10.08 AJS

        OPEN O_RC1 FOR V_SQL;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL;

END PKG_SCP0016;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SCP0016' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0016' ORDER BY TYPE, SEQUENCE;
