PACKAGE BODY PKG_SCP0016
IS
    /*
     * Program ID   : PKG_SCP0016
     * Description  : SCP0016 Waterfall Shipment Plan FG 화면 - 출하계획 워터폴 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.07   AJS          [속도] 값 조회 — 원장→임시 테이블 2단 적재(DATA1·PIVOT)를 없애고 피벗 조회가 원장을 바로 읽음,
     *                           재고(boh) 공용 함수 행마다 호출을 같은 규칙의 조회로 바꾸고 원장 분할 열쇠로 읽음
     *
     * [전환 공통 규칙]
     * - AS-IS #TEMP 3종을 전역 임시 테이블로 옮겼다(00_DDL).
     * - ★AS-IS 는 조회문을 문자열로 이어 붙여 실행하는 자리가 세 곳이다.
     *   그중 둘(조회조건 · 전극 갈래)은 조건을 붙이고 빼는 것뿐이라 정적 조회문으로 옮겼다.
     *   **피벗만 동적으로 남긴다** — 조회 기간에 따라 결과 칸이 달라져 다른 방법이 없다.
     * - AS-IS 가 조회조건을 `FN_GET_IN_STR` 로 `'A','B'` 꼴로 만들어 IN 절에 넣던 것은
     *   STRING_SPLIT 로 나눠 견주도록 옮겼다.
     * - 전극 사업부 갈래는 조인 대상 칸이 갈리므로 CASE 로 합쳤다(AS-IS 분기 4곳).
     * - ★머리 조회는 값을 채우지 않고 칸 이름만 만든다(AS-IS 도 빈 값으로 만든다).
     *   AS-IS 화면이 조회 기간을 넉 달씩 잘라 병렬로 부르고 마지막 차례에 머리를 받는 구조다.
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
              P_MODE = 'QTY'    이면 수량을 더하는 칸 (본문 조회)
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
                             AND (P_MODE = 'QTY' OR P_ISO = 'F')
                           GROUP BY A.BASIS_YYYYMM
                                  , A.ISO_WEEK
                                  , A.BASIS_START_DATE
                          UNION ALL
                          /* ISO 주 */
                          SELECT 'W_' || A.ISO_YYYYMM || A.ISO_WEEK || '_ISO'       AS YYYYMMDD
                               , MIN(A.BASIS_START_DATE) || '21'                    AS SORT_ORDER_NO
                            FROM SCM_SYS_CALENDAR_M A
                           WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             AND (P_MODE = 'QTY' OR P_ISO <> 'F')
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
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.WRITEAPPEND(V_SQL
                  , LENGTH(', SUM(CASE WHEN YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
                  , ', SUM(CASE WHEN YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' AND SUBSTR(C.YYYYMMDD, -4) <> '_ISO' THEN
                DBMS_LOB.WRITEAPPEND(V_SQL
                  , LENGTH(', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
                  , ', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                /* ISO 주 — AS-IS 는 칸 이름의 3번째부터 6자리를 쓴다 */
                DBMS_LOB.WRITEAPPEND(V_SQL
                  , LENGTH(', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', 3, 6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
                  , ', SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', 3, 6) THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
            ELSE
                DBMS_LOB.WRITEAPPEND(V_SQL
                  , LENGTH(', SUM(CASE WHEN YYYYMMDD = ''' || C.YYYYMMDD || ''' THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10))
                  , ', SUM(CASE WHEN YYYYMMDD = ''' || C.YYYYMMDD || ''' THEN QTY END) AS "' || C.YYYYMMDD || '"' || CHR(10));
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
        V_VERSION_NO        VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_VERSION_NO, 1, 32767));
        V_CUTOFF            DATE;
        V_NEXT_CUTOFF       DATE;
        V_ELECTYPE          VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ELECTYPE, 1, 32767));
        V_PROGRAM_ID        VARCHAR2(200 CHAR)   := NVL(P_PROGRAM_ID, 'SCP0016');
        V_SHEET_NAME        VARCHAR2(200 CHAR)   := NVL(P_SHEET_NAME, 'Shipment Plan FG');
        V_CNT_USR_MEASURE   PLS_INTEGER;
        V_IS_EE             PLS_INTEGER;
        V_PIVOT             CLOB;
        V_SQL               CLOB;
        V_SRC               CLOB;                   --  2026.10.07 AJS
    BEGIN
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
        V_PIVOT := F_PIVOT_COLUMNS(P_FROM_YYYYMMDD, P_TO_YYYYMMDD, 'QTY');

--  2026.10.07 AJS (START) 피벗 원천 조회문
        /* ==========================================================================================
           4-0. 피벗 원천 — ★출하계획 원장을 피벗 조회에서 바로 읽는다(중간 임시 테이블 적재 없음).
                칸·조건은 원래 1·3 적재문과 같다. 차수를 고르지 않았으면 차수 조건을 붙이지 않는다.
                전극 갈래는 BOD 를 원사업부로 잇는다.
           ========================================================================================== */
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
                     , TO_CHAR(SD.LT_TOTAL)                                 AS LT_DAY             /* 원래 임시 테이블 칸이 문자형 */
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
                    OR  UPPER(:V_PROJECT_CODE) = ''ALL''                /* 조회조건 ALL 은 조건 없음 */
                    OR  SB.PROJECT_CODE IN (SELECT COLUMN_VALUE
                                              FROM TABLE(STRING_SPLIT(:V_PROJECT_CODE, '',''))))
                   AND (TRIM(:V_ITEM_ID) IS NULL
                    OR  UPPER(:V_ITEM_ID) = ''ALL''                     /* 조회조건 ALL 은 조건 없음 */
                    OR  SB.ITEM_ID IN (SELECT COLUMN_VALUE
                                         FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(:V_ITEM_ID, ''''))))
                   AND (TRIM(:V_ELECTYPE) IS NULL
                    OR  UPPER(:V_ELECTYPE) = ''ALL''                    /* 조회조건 ALL 은 조건 없음 */
                    OR  SB.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(:V_ELECTYPE, '','')))) ';
--  2026.10.07 AJS (END)

        V_SQL := 'SELECT IA.*
     , NVL(B.PROJECT_NAME, ''-'')                                            AS PROJECT_NAME
     , NVL(B.PROJECT_OWNER, ''-'')                                           AS PROJECT_OWNER
     , NVL(FN_GET_LOOKUP_CODE_DESC(''ITEM_TYPE_CODE'', C.ITEM_TYPE), ''-'')  AS ITEM_TYPE
     , NVL(E.DEPT_NAME_KO, ''-'')                                            AS DEPT_NAME_KO
  FROM (SELECT KEY_IDX
             , DIVISION_ID
             , BIZ_TYPE                              AS "biz_type"
             , BIZ_TYPE_NAME                         AS "biz_type_name"
             , PROJECT_CODE                          AS "project_code"
             , ITEM_ID                               AS "item_id"
             , CASE WHEN NICK_NAME IS NULL THEN ''-''
                    ELSE NICK_NAME
               END                                   AS "nick_name"
             , ELECTRODE_TYPE
             , ORIGIN_TO_DIVISION_ID
             , TO_SITE                               AS "to_site"
             , TO_SITE_NAME                          AS "to_site_name"
             , INCOTERMS                             AS "incoterms"
             , ORIGIN_FROM_DIVISION_ID
             , FROM_SITE                             AS "from_site"
             , NVL(FROM_SITE_NAME, ''-'')            AS "from_site_name"
             , BOD_ID                                AS "bod_id"
             , NVL(TRANSPORT_MODE, ''-'')            AS "transport_mode"
             , NVL(LT_DAY, 0)                        AS "lt_day"
             , PLAN_START_YYYYMMDD                   AS "plan_start_yyyymmdd"
             , PLAN_TYPE                             AS "plan_type"
             , SEQ                                   AS "seq"
--  2026.10.07 AJS (START) 재고 공용 함수 행마다 호출 → 같은 규칙의 조회
--             , CAST(ROUND(FN_GET_SCP_ANL_BOH_QTY(DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, TO_SITE, ITEM_ID, FROM_YYYYMMDD), 1) AS NUMBER(10, 0)) AS "boh"
             /* ★재고(boh) — 공용 함수 FN_GET_SCP_ANL_BOH_QTY 와 같은 규칙을 조회문 안에서 계산한다.
                  사이트 유형이 PLANT 이면 공장 재고(활성화 이후 재고 유형 제외), 아니면 판매 재고.
                  같은 열쇠는 한 번만 읽고, 원장 분할 열쇠(계획시작일)로 해당 분할만 읽는다 */
             , CAST(ROUND(NVL(CASE WHEN (SELECT XD.SITE_TYPE
                                           FROM SCM_MST_SITE XD
                                          WHERE XD.SCM_SITE_ID = IB.TO_SITE
                                            AND ROWNUM         = 1) = ''PLANT''
                                   THEN (SELECT SUM(NVL(XB.PSI_BOH_QTY, 0))
                                           FROM SCP_PLN_PLANT_ONHAND XB
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
                                           FROM SCP_PLN_SALES_ONHAND XC
                                          WHERE XC.DIVISION_ID              = IB.DIVISION_ID
                                            AND XC.PLAN_START_YYYYMMDD      = IB.PLAN_START_YYYYMMDD
                                            AND XC.PLAN_START_YYYYMMDD_DATE = TO_DATE(IB.PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, ''YYYYMMDD'')
                                            AND XC.PLAN_TYPE                = IB.PLAN_TYPE
                                            AND XC.SEQ                      = IB.SEQ
                                            AND XC.SITE_ID                  = IB.TO_SITE
                                            AND XC.ITEM_ID                  = IB.ITEM_ID
                                            AND XC.YYYYMMDD                 = IB.FROM_YYYYMMDD)
                              END, 0), 1) AS NUMBER(10, 0)) AS "boh"
--  2026.10.07 AJS (END)
             , VERSION_NO                            AS "version_no"
             , MEASURE                               AS "measure"
             , MEASURE_ORDER_NO                      AS "measure_order_no"
             , MEASURE_LABEL                         AS "measure_label"
             , FROM_YYYYMMDD                         AS "from_yyyymmdd"
             , TO_YYYYMMDD                           AS "to_yyyymmdd"
             ' || V_PIVOT || '
--          FROM GT_SCP0016_PIVOT
          FROM (' || V_SRC || ') IB    --  2026.10.07 AJS
         GROUP BY KEY_IDX
                , DIVISION_ID
                , BIZ_TYPE
                , BIZ_TYPE_NAME
                , PROJECT_CODE
                , ITEM_ID
                , NICK_NAME
                , ELECTRODE_TYPE
                , ORIGIN_TO_DIVISION_ID
                , TO_SITE
                , TO_SITE_NAME
                , INCOTERMS
                , ORIGIN_FROM_DIVISION_ID
                , FROM_SITE
                , FROM_SITE_NAME
                , BOD_ID
                , TRANSPORT_MODE
                , LT_DAY
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , SEQ
                , VERSION_NO
                , MEASURE
                , MEASURE_ORDER_NO
                , MEASURE_LABEL
                , FROM_YYYYMMDD
                , TO_YYYYMMDD) IA
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
     -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰로 변경 (START)
     -- , SCM_MST_SITE           D
     , SCM_MST_SITE_DEPT_REP_V D
     -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰로 변경 (END)
     , SCM_MST_SSO_DEPT_INFO  E
 WHERE B.PROJECT_CODE(+) = IA."project_code"
   AND B.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND B.NUMS(+)         = 1
   AND C.ITEM_ID(+)      = IA."item_id"
   AND C.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND C.NUMS(+)         = 1
   ' || CASE WHEN V_IS_EE > 0
             THEN 'AND D.DIVISION_ID(+) = IA.ORIGIN_FROM_DIVISION_ID
   AND D.SCM_SITE_ID(+) = FN_GET_SITE_NAME_SHIPMENT(IA."to_site")'
             ELSE 'AND D.DIVISION_ID(+) = IA.DIVISION_ID
   AND D.SCM_SITE_ID(+) = IA."to_site"'
        END || '
   AND E.DEPT_ID(+)      = D.DEPT_ID
 ORDER BY FN_ASIS_SORT_KEY(IA.DIVISION_ID)          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."biz_type")           NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."item_id")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."to_site")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."project_code")       NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."incoterms")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."from_site")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."bod_id")             NULLS FIRST
        , IA."measure_order_no"
        , FN_ASIS_SORT_KEY(IA."version_no")         NULLS FIRST';

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
                , V_ITEM_ID
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
        V_CNT_USR_MEASURE := F_CNT_USR_MEASURE(V_PROGRAM_ID, V_SHEET_NAME, P_USER_ID);

        SELECT COUNT(*)
          INTO V_IS_EE
          FROM TABLE(FN_GET_DIVISION_DIV('EE'))
         WHERE COLUMN_VALUE = P_DIVISION_ID;

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
             , SCP_MST_BOD_N_V            C
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
            OR  A.PROJECT_CODE IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_PROJECT_CODE, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''))))
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
             , SCP_MST_BOD_N_V            C
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
            OR  A.PROJECT_CODE IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_PROJECT_CODE, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                         /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
                                FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(V_ITEM_ID, ''))))
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
             , BIZ_TYPE                              AS "biz_type"
             , BIZ_TYPE_NAME                         AS "biz_type_name"
             , PROJECT_CODE                          AS "project_code"
             , ITEM_ID                               AS "item_id"
             , CASE WHEN NICK_NAME IS NULL THEN ''-''
                    ELSE NICK_NAME
               END                                   AS "nick_name"
             , ELECTRODE_TYPE
             , ORIGIN_TO_DIVISION_ID
             , TO_SITE                               AS "to_site"
             , TO_SITE_NAME                          AS "to_site_name"
             , INCOTERMS                             AS "incoterms"
             , ORIGIN_FROM_DIVISION_ID
             , FROM_SITE                             AS "from_site"
             , NVL(FROM_SITE_NAME, ''-'')            AS "from_site_name"
             , BOD_ID                                AS "bod_id"
             , NVL(TRANSPORT_MODE, ''-'')            AS "transport_mode"
             , NVL(LT_DAY, 0)                        AS "lt_day"
             , PLAN_START_YYYYMMDD                   AS "plan_start_yyyymmdd"
             , PLAN_TYPE                             AS "plan_type"
             , SEQ                                   AS "seq"
             , CAST(ROUND(FN_GET_SCP_ANL_BOH_QTY(DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, TO_SITE, ITEM_ID, FROM_YYYYMMDD), 1) AS NUMBER(10, 0)) AS "boh"
             , VERSION_NO                            AS "version_no"
             , MEASURE                               AS "measure"
             , MEASURE_ORDER_NO                      AS "measure_order_no"
             , MEASURE_LABEL                         AS "measure_label"
             , FROM_YYYYMMDD                         AS "from_yyyymmdd"
             , TO_YYYYMMDD                           AS "to_yyyymmdd"
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
     -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰로 변경 (START)
     -- , SCM_MST_SITE           D
     , SCM_MST_SITE_DEPT_REP_V D
     -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰로 변경 (END)
     , SCM_MST_SSO_DEPT_INFO  E
 WHERE B.PROJECT_CODE(+) = IA."project_code"
   AND B.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND B.NUMS(+)         = 1
   AND C.ITEM_ID(+)      = IA."item_id"
   AND C.DIVISION_ID(+)  = ' || CASE WHEN V_IS_EE > 0 THEN 'IA.ORIGIN_TO_DIVISION_ID' ELSE 'IA.DIVISION_ID' END || '
   AND C.NUMS(+)         = 1
   ' || CASE WHEN V_IS_EE > 0
             THEN 'AND D.DIVISION_ID(+) = IA.ORIGIN_FROM_DIVISION_ID
   AND D.SCM_SITE_ID(+) = FN_GET_SITE_NAME_SHIPMENT(IA."to_site")'
             ELSE 'AND D.DIVISION_ID(+) = IA.DIVISION_ID
   AND D.SCM_SITE_ID(+) = IA."to_site"'
        END || '
   AND E.DEPT_ID(+)      = D.DEPT_ID
 ORDER BY FN_ASIS_SORT_KEY(IA.DIVISION_ID)          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."biz_type")           NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."item_id")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."to_site")            NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."project_code")       NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."incoterms")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."from_site")          NULLS FIRST
        , FN_ASIS_SORT_KEY(IA."bod_id")             NULLS FIRST
        , IA."measure_order_no"
        , FN_ASIS_SORT_KEY(IA."version_no")         NULLS FIRST';

        OPEN O_RC1 FOR V_SQL;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SCP0016_GET_SHIPMENT_PLAN_FG_WATERFALL_TITLE_PARAL;

END PKG_SCP0016;