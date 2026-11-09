-- SOURCE-FRESH: SCM_MGR 화면 SCP0131 객체·META (DB=ZIOUI1 SERVER_HOST=localhost) FETCHED=2026-11-07 07:39:04
/* 20_PKG PKG_SCP0131 — 사내 최신 원문 전체(CREATE OR REPLACE · 이 화면 전용 객체)
 * 패키지 SCP0131_CLOUD_DB_MOD_20261107_0739 · 생성 tools/CloudPkg/cloud_pkg.py 1.1.0 · 2026-11-07 07:39
 * 실행 계정 = SCM_MGR (전체 F5 · 반복 실행 안전)
 * 되돌리기 = 05_BACKUP 을 먼저 실행해 두면 99_ROLLBACK 이 이 객체를 실행 전 원문으로 복원
 */
SET DEFINE OFF
SET SERVEROUTPUT ON SIZE UNLIMITED

CREATE OR REPLACE PACKAGE PKG_SCP0131
IS
    /*
     * Program ID   : PKG_SCP0131
     * Description  : SCP0131 Sales Site Priority 화면 — 수요우선순위 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     *
     * 조회조건 초기값은 이 화면 전용 기능이 없다. 같은 계열 화면의 초기값 기능을 함께 쓴다.
     */

    /* 수요우선순위 조회 */
    PROCEDURE P_SCP0131_GET_SALES_SITE_PRIORITY
    (
        P_DIVISION_ID       IN  CLOB
      , P_PLAN_GROUP_ID     IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_PERIOD_FROM       IN  CLOB
      , P_PERIOD_TO         IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

    /* 수요우선순위 저장 */
    PROCEDURE P_SCP0131_SAVE_SALES_SITE_PRIORITY
    (
        P_ACTIVE_FLAG       IN  CLOB
      , P_DIVISION_ID       IN  CLOB
      , P_OPMZ_PLAN_GR_ID   IN  CLOB
      , P_SCM_SITE_ID       IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_PRIO_RANK         IN  CLOB
      , P_FROM_YYYYMMDD     IN  CLOB
      , P_TO_YYYYMMDD       IN  CLOB
      , P_VALUE_DESCRIPTION IN  CLOB
      , P_VALID_YN          IN  CLOB
      , P_USER_ID           IN  CLOB
      , P_PRE_DIVISION_ID   IN  CLOB
      , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
      , P_PRE_SCM_SITE_ID   IN  CLOB
      , P_PRE_ITEM_ID       IN  CLOB
      , P_PRE_PRIO_RANK     IN  CLOB
      , P_PRE_FROM_YYYYMMDD IN  CLOB
      , P_PRE_TO_YYYYMMDD   IN  CLOB
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    );

END PKG_SCP0131;
/

CREATE OR REPLACE PACKAGE BODY PKG_SCP0131
IS
    /*
     * Program ID   : PKG_SCP0131
     * Description  : SCP0131 Sales Site Priority 화면 — 수요우선순위 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

/****************************************************************************************************/
/* Program ID  : P_SCP0131_GET_SALES_SITE_PRIORITY                                                  */
/* Description : 수요우선순위 조회                                                                  */
/****************************************************************************************************/
PROCEDURE P_SCP0131_GET_SALES_SITE_PRIORITY
(
    P_DIVISION_ID       IN  CLOB
  , P_PLAN_GROUP_ID     IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_PERIOD_FROM       IN  CLOB
  , P_PERIOD_TO         IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /* 원문이 조회조건을 NVARCHAR(200) 변수로 받아 200자에서 자른다 */
    V_DIVISION_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID,   1, 200));
    V_PLAN_GROUP_ID     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PLAN_GROUP_ID, 1, 200));
    V_SCM_SITE_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_SCM_SITE_ID,   1, 200));
    V_VALID_YN          VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_VALID_YN,      1, 200));
    V_PERIOD_FROM       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PERIOD_FROM,   1, 200));
    V_PERIOD_TO         VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PERIOD_TO,     1, 200));
    /* 품목만 원문이 자르지 않은 값을 쓴다 */
    V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,       1, 32767));
BEGIN

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.OPMZ_PLAN_GR_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.PRIO_RANK
             , TO_DATE(A.FROM_YYYYMMDD, 'YYYYMMDD')                 AS FROM_YYYYMMDD
             , TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD')                   AS TO_YYYYMMDD
             , A.VALUE_DESCRIPTION
             , A.VALID_YN
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             /* ★원문은 값이 없는 칸이 섞이면 결과 전체가 빈 값이 되지만, 원장 실측상 우선순위에
                   값이 없는 행은 없어 그대로 이어 붙이면 원문과 같다 */
             , A.DIVISION_ID || '|' || A.OPMZ_PLAN_GR_ID || '|' || A.SCM_SITE_ID || '|' || A.ITEM_ID || '|' || A.FROM_YYYYMMDD || '|' || A.TO_YYYYMMDD || '|' || TO_CHAR(A.PRIO_RANK) AS PRE_KEY_VALUES
          FROM SCP_OPMZ_SALES_SITE_PRIORITY A
             , (SELECT DISTINCT '%' || UPPER(COLUMN_VALUE) || '%'   AS TST
                  FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))) IA
         WHERE (UPPER(V_ITEM_ID) = 'ALL'      /* 조회조건 ALL 은 조건 없음 */
                OR  A.ITEM_ID LIKE IA.TST)
           /* AS-IS 는 대소문자를 가리지 않는다. 원장 실측상 소문자가 섞인 칸은 사이트 하나뿐이라
              사이트만 칸과 입력값을 함께, 나머지는 입력값만 대문자로 맞춘다 */
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_SCM_SITE_ID) IS NULL
            OR  UPPER(V_SCM_SITE_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
            OR  UPPER(A.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))))
           AND (TRIM(V_VALID_YN) IS NULL
            OR  UPPER(V_VALID_YN) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.VALID_YN IN (SELECT UPPER(COLUMN_VALUE)
                                 FROM TABLE(STRING_SPLIT(V_VALID_YN, ','))))
           AND (TRIM(V_PLAN_GROUP_ID) IS NULL
            OR  UPPER(V_PLAN_GROUP_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
            OR  A.OPMZ_PLAN_GR_ID IN (SELECT UPPER(COLUMN_VALUE)
                                        FROM TABLE(STRING_SPLIT(V_PLAN_GROUP_ID, ','))))
           AND A.FROM_YYYYMMDD     <= V_PERIOD_TO
           AND A.TO_YYYYMMDD       >= V_PERIOD_FROM
         /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(A.SCM_SITE_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(A.OPMZ_PLAN_GR_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID)         NULLS FIRST
                , FN_ASIS_SORT_KEY(A.FROM_YYYYMMDD)   NULLS FIRST
                , FN_ASIS_SORT_KEY(A.TO_YYYYMMDD)     NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0131_GET_SALES_SITE_PRIORITY;

/****************************************************************************************************/
/* Program ID  : P_SCP0131_SAVE_SALES_SITE_PRIORITY                                                 */
/* Description : 수요우선순위 등록 · 수정 · 삭제                                                    */
/****************************************************************************************************/
PROCEDURE P_SCP0131_SAVE_SALES_SITE_PRIORITY
(
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_OPMZ_PLAN_GR_ID   IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_PRIO_RANK         IN  CLOB
  , P_FROM_YYYYMMDD     IN  CLOB
  , P_TO_YYYYMMDD       IN  CLOB
  , P_VALUE_DESCRIPTION IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_PRE_DIVISION_ID   IN  CLOB
  , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
  , P_PRE_SCM_SITE_ID   IN  CLOB
  , P_PRE_ITEM_ID       IN  CLOB
  , P_PRE_PRIO_RANK     IN  CLOB
  , P_PRE_FROM_YYYYMMDD IN  CLOB
  , P_PRE_TO_YYYYMMDD   IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';
    /* 원문은 빈 문자와 견준다. Oracle 에서 빈 문자는 값이 없는 것이라 그대로 두면 판정이 뒤집힌다.
       값이 없을 때 원장 값과 절대 같아지지 않는 글자를 세워 원문과 같게 만든다 */
    C_NOMATCH           CONSTANT VARCHAR2(1 CHAR) := CHR(1);

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_OPMZ_PLAN_GR_ID   VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID       VARCHAR2(4000 CHAR);
    V_ITEM_ID           VARCHAR2(4000 CHAR);
    V_PRIO_RANK         VARCHAR2(4000 CHAR);
    V_FROM_YYYYMMDD     VARCHAR2(4000 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(4000 CHAR);
    V_VALUE_DESCRIPTION VARCHAR2(4000 CHAR);
    V_VALID_YN          VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_USER_ID, 1, 4000));

    V_PRE_DIVISION_ID   VARCHAR2(4000 CHAR);
    V_PRE_PLAN_GR_ID    VARCHAR2(4000 CHAR);
    V_PRE_SCM_SITE_ID   VARCHAR2(4000 CHAR);
    V_PRE_ITEM_ID       VARCHAR2(4000 CHAR);
    V_PRE_PRIO_RANK     VARCHAR2(4000 CHAR);
    V_PRE_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
    V_PRE_TO_YYYYMMDD   VARCHAR2(4000 CHAR);

    V_MAX_LOOP_CNT      NUMBER(10) := 0;
    V_MST_LOOP_CNT      NUMBER(10) := 0;
    V_CNT               NUMBER(10) := 0;
    V_ITEM_CNT          NUMBER(10) := 0;   /* 2026-11-07 E7 품목 유효성(MSG00458) */

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0131_SAVE_SALES_SITE_PRIORITY';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    V_SQLERRM           VARCHAR2(4000 CHAR);
BEGIN

    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 넘어온 줄 수 */
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, C_DELIMITER);

    WHILE LENGTH(P_ACTIVE_FLAG) > 0
      AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP

        V_MST_LOOP_CNT      := V_MST_LOOP_CNT + 1;

        V_ACTIVE_FLAG       := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         C_DELIMITER, V_MST_LOOP_CNT);
        V_DIVISION_ID       := SCM_ARR_SPL_VAL(P_DIVISION_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_OPMZ_PLAN_GR_ID   := SCM_ARR_SPL_VAL(P_OPMZ_PLAN_GR_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_SCM_SITE_ID       := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID           := SCM_ARR_SPL_VAL(P_ITEM_ID,             C_DELIMITER, V_MST_LOOP_CNT);
        V_PRIO_RANK         := SCM_ARR_SPL_VAL(P_PRIO_RANK,           C_DELIMITER, V_MST_LOOP_CNT);
        V_FROM_YYYYMMDD     := SCM_ARR_SPL_VAL(P_FROM_YYYYMMDD,       C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_YYYYMMDD       := SCM_ARR_SPL_VAL(P_TO_YYYYMMDD,         C_DELIMITER, V_MST_LOOP_CNT);
        V_VALUE_DESCRIPTION := SCM_ARR_SPL_VAL(P_VALUE_DESCRIPTION,   C_DELIMITER, V_MST_LOOP_CNT);
        V_VALID_YN          := SCM_ARR_SPL_VAL(P_VALID_YN,            C_DELIMITER, V_MST_LOOP_CNT);

        V_PRE_DIVISION_ID   := SCM_ARR_SPL_VAL(P_PRE_DIVISION_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLAN_GR_ID    := SCM_ARR_SPL_VAL(P_PRE_OPMZ_PLAN_GR_ID, C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_SCM_SITE_ID   := SCM_ARR_SPL_VAL(P_PRE_SCM_SITE_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_ITEM_ID       := SCM_ARR_SPL_VAL(P_PRE_ITEM_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PRIO_RANK     := SCM_ARR_SPL_VAL(P_PRE_PRIO_RANK,       C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_FROM_YYYYMMDD := SCM_ARR_SPL_VAL(P_PRE_FROM_YYYYMMDD,   C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_TO_YYYYMMDD   := SCM_ARR_SPL_VAL(P_PRE_TO_YYYYMMDD,     C_DELIMITER, V_MST_LOOP_CNT);

        /* 삭제가 아닌 경우 중복 확인 */
        IF V_ACTIVE_FLAG <> 'D'
        THEN

            /* 2026-11-07 E7(AS-IS SaveData .cs:681-697 MSG00458): 품목 유효성 — SEARCH_INFO 6번 커서(품목 원장 ∪ 가상 BOM)에 없는 ITEM_ID 는 저장 거부 (PKG_SCP0127 11-06 동일 블록) */
            SELECT COUNT(*)
              INTO V_ITEM_CNT
              FROM DUAL
             WHERE EXISTS (SELECT 1
                             FROM SCM_MST_ITEM_SN A
                            WHERE A.DIVISION_ID = V_DIVISION_ID
                              AND A.ITEM_ID     = V_ITEM_ID)
                OR EXISTS (SELECT 1
                             FROM SCP_OPMZ_VIRTUAL_BOM A
                            WHERE A.DIVISION_ID   = V_DIVISION_ID
                              AND A.ITEM_ID_CHILD = V_ITEM_ID);

            IF V_ITEM_CNT = 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, 'MODEL: ' || V_ITEM_ID || CHR(10) || '유효하지 않은 모델입니다!');   /* MSG00458 */
            END IF;

            /***** 중복체크 *****/
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCP_OPMZ_SALES_SITE_PRIORITY
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND SCM_SITE_ID     = V_SCM_SITE_ID
               AND ITEM_ID         = V_ITEM_ID
               AND FROM_YYYYMMDD   = V_FROM_YYYYMMDD
               AND TO_YYYYMMDD     = V_TO_YYYYMMDD
               AND NOT (
                            DIVISION_ID     = NVL(V_PRE_DIVISION_ID,   C_NOMATCH)
                        AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID,    C_NOMATCH)
                        AND SCM_SITE_ID     = NVL(V_PRE_SCM_SITE_ID,   C_NOMATCH)
                        AND ITEM_ID         = NVL(V_PRE_ITEM_ID,       C_NOMATCH)
                        AND FROM_YYYYMMDD   = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
                        AND TO_YYYYMMDD     = NVL(V_PRE_TO_YYYYMMDD,   C_NOMATCH)
                       );

            IF V_CNT > 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, ' 신규 입력 데이터 중 중복된 데이터가 있습니다.');
            END IF;

            /**** 날짜 중복 체크 ****/
            SELECT COUNT(1)
              INTO V_CNT
              FROM SCP_OPMZ_SALES_SITE_PRIORITY X
             WHERE X.DIVISION_ID     = V_DIVISION_ID
               AND X.OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND X.SCM_SITE_ID     = V_SCM_SITE_ID
               AND X.ITEM_ID         = V_ITEM_ID
               AND NOT (V_TO_YYYYMMDD < X.FROM_YYYYMMDD OR V_FROM_YYYYMMDD > X.TO_YYYYMMDD)
               AND NOT (X.FROM_YYYYMMDD = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
                        AND X.TO_YYYYMMDD = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH));   /* 기존 값 */

            IF V_CNT > 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, ' 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.');
            END IF;
            /***** 중복체크 *****/

        END IF;

        IF V_ACTIVE_FLAG = 'I'
        THEN

            INSERT INTO SCP_OPMZ_SALES_SITE_PRIORITY
                        (
                          DIVISION_ID
                        , OPMZ_PLAN_GR_ID
                        , SCM_SITE_ID
                        , PRIO_RANK
                        , ITEM_ID
                        , FROM_YYYYMMDD
                        , TO_YYYYMMDD
                        , VALUE_DESCRIPTION
                        , VALID_YN
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE
                        )
                 VALUES (
                          V_DIVISION_ID
                        , V_OPMZ_PLAN_GR_ID
                        , V_SCM_SITE_ID
                        , TO_NUMBER(V_PRIO_RANK)
                        , V_ITEM_ID
                        , V_FROM_YYYYMMDD
                        , V_TO_YYYYMMDD
                        , V_VALUE_DESCRIPTION
                        , V_VALID_YN
                        , V_LAST_UPDATED_BY
                        , SYSDATE
                        , V_LAST_UPDATED_BY
                        , SYSDATE
                        );

        ELSIF V_ACTIVE_FLAG = 'M'
        THEN

            UPDATE SCP_OPMZ_SALES_SITE_PRIORITY
               SET DIVISION_ID       = V_DIVISION_ID
                 , OPMZ_PLAN_GR_ID   = V_OPMZ_PLAN_GR_ID
                 , SCM_SITE_ID       = V_SCM_SITE_ID
                 , PRIO_RANK         = TO_NUMBER(V_PRIO_RANK)
                 , ITEM_ID           = V_ITEM_ID
                 , FROM_YYYYMMDD     = V_FROM_YYYYMMDD
                 , TO_YYYYMMDD       = V_TO_YYYYMMDD
                 , VALUE_DESCRIPTION = V_VALUE_DESCRIPTION
                 , VALID_YN          = V_VALID_YN
                 , LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE  = SYSDATE
             WHERE DIVISION_ID       = NVL(V_PRE_DIVISION_ID,   C_NOMATCH)
               AND OPMZ_PLAN_GR_ID   = NVL(V_PRE_PLAN_GR_ID,    C_NOMATCH)
               AND SCM_SITE_ID       = NVL(V_PRE_SCM_SITE_ID,   C_NOMATCH)
               AND ITEM_ID           = NVL(V_PRE_ITEM_ID,       C_NOMATCH)
               AND FROM_YYYYMMDD     = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
               AND TO_YYYYMMDD       = NVL(V_PRE_TO_YYYYMMDD,   C_NOMATCH);

        ELSIF V_ACTIVE_FLAG = 'D'                               /* 삭제기능 추가 (2025-07-16) */
        THEN

            DELETE FROM SCP_OPMZ_SALES_SITE_PRIORITY
             WHERE DIVISION_ID       = NVL(V_PRE_DIVISION_ID,   C_NOMATCH)
               AND OPMZ_PLAN_GR_ID   = NVL(V_PRE_PLAN_GR_ID,    C_NOMATCH)
               AND SCM_SITE_ID       = NVL(V_PRE_SCM_SITE_ID,   C_NOMATCH)
               AND ITEM_ID           = NVL(V_PRE_ITEM_ID,       C_NOMATCH)
               AND FROM_YYYYMMDD     = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
               AND TO_YYYYMMDD       = NVL(V_PRE_TO_YYYYMMDD,   C_NOMATCH);

        END IF;

    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드 · 결과 건수 반환 */
    OPEN O_RC1 FOR
        SELECT 'S'              AS RESULT_CODE
             , V_MAX_LOOP_CNT   AS RESULT_CNT
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQLERRM := SQLERRM;

        ROLLBACK;

        INSERT INTO SCM_SYS_LOG_BATCH
                    (
                      PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                    , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY
                    )
             VALUES (
                      V_PROGRAM_NAME, 'ERROR', NULL, V_SQLERRM, NULL
                    , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME
                    );

        COMMIT;

        OPEN O_RC1 FOR
            SELECT 'F'                          AS RESULT_CODE
                 , SUBSTR(V_SQLERRM, 1, 4000)   AS RESULT_CNT
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '1'                          AS RESULT_CODE
                 , SUBSTR(V_SQLERRM, 1, 4000)   AS RESULT_MESSAGE
              FROM DUAL;

END P_SCP0131_SAVE_SALES_SITE_PRIORITY;

END PKG_SCP0131;
/

/* 확인 — VALID, 오류 0 */
SELECT OBJECT_NAME, OBJECT_TYPE, STATUS, TO_CHAR(LAST_DDL_TIME, 'YYYY-MM-DD HH24:MI:SS') AS LAST_DDL
  FROM USER_OBJECTS WHERE OBJECT_NAME = 'PKG_SCP0131' ORDER BY OBJECT_TYPE;
SELECT TYPE, LINE, POSITION, TEXT FROM USER_ERRORS WHERE NAME = 'PKG_SCP0131' ORDER BY TYPE, SEQUENCE;
