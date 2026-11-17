-- SOURCE-FRESH: SCM_MGR.PKG_SCP0129 PACKAGE BODY LAST_DDL=2026-11-12 10:36:41 FETCHED=2026-11-13 10:01:43 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY PKG_SCP0129
IS
    /*
     * Program ID   : PKG_SCP0129
     * Description  : SCP0129 Demand Exception 화면 — 수요제외 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.11.12   AJS          조회조건 목록 길이 제한 해소 · Model/Nickname 검색(품목코드 또는 닉네임 부분 일치)
     */

/* 2026.11.12 AJS 조회조건 목록 분리 내부 함수 (START) */
/****************************************************************************************************/
/* Program ID  : F_SPLIT_CLOB_LIST                                                                  */
/* Description : 쉼표 목록 CLOB 을 길이 제한 없이 나눠 대문자 목록으로 반환 (빈 값은 제외)          */
/****************************************************************************************************/
FUNCTION F_SPLIT_CLOB_LIST
(
    P_LIST              IN  CLOB
)
RETURN T_STR_TAB
IS
    V_TAB               T_STR_TAB   := T_STR_TAB();
    V_LEN               PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_LIST), 0);
    V_POS               PLS_INTEGER := 1;
    V_IDX               PLS_INTEGER;
    V_TOKEN             VARCHAR2(4000);
BEGIN

    WHILE V_POS <= V_LEN
    LOOP

        V_IDX := DBMS_LOB.INSTR(P_LIST, ',', V_POS);

        IF NVL(V_IDX, 0) = 0
        THEN
            V_IDX := V_LEN + 1;
        END IF;

        IF V_IDX > V_POS
        THEN
            /* 코드 한 개는 1,000자를 넘지 않는다 — 목록 원소(VARCHAR2 4000 바이트) 한도 안에서 자른다 */
            V_TOKEN := UPPER(TRIM(DBMS_LOB.SUBSTR(P_LIST, LEAST(V_IDX - V_POS, 1000), V_POS)));

            IF V_TOKEN IS NOT NULL
            THEN
                V_TAB.EXTEND;
                V_TAB(V_TAB.COUNT) := V_TOKEN;
            END IF;
        END IF;

        V_POS := V_IDX + 1;

    END LOOP;

    RETURN V_TAB;

END F_SPLIT_CLOB_LIST;

/****************************************************************************************************/
/* Program ID  : F_LIST_USE_YN                                                                      */
/* Description : 목록 조건 적용 여부 — 값이 없거나 ALL 이 들어 있으면 N (조건 없음)                 */
/****************************************************************************************************/
FUNCTION F_LIST_USE_YN
(
    P_TAB               IN  T_STR_TAB
)
RETURN VARCHAR2
IS
BEGIN

    IF P_TAB IS NULL
    OR P_TAB.COUNT = 0
    OR 'ALL' MEMBER OF P_TAB
    THEN
        RETURN 'N';
    END IF;

    RETURN 'Y';

END F_LIST_USE_YN;
/* 2026.11.12 AJS (END) */

/****************************************************************************************************/
/* Program ID  : P_SCP0129_GET_DEMAND_EXCEPTION                                                     */
/* Description : 수요제외 조회                                                                      */
/****************************************************************************************************/
PROCEDURE P_SCP0129_GET_DEMAND_EXCEPTION
(
    P_DIVISION_ID       IN  CLOB
  , P_PLAN_GROUP_ID     IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_STAGE             IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_PERIOD_FROM       IN  CLOB
  , P_PERIOD_TO         IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /* 원문이 조회조건을 NVARCHAR(200) 변수로 받아 200자에서 자른다 */
    /* 2026.11.12 AJS 목록 조건은 200자에서 자르지 않고 CLOB 그대로 나눠 목록으로 비교 — SELECT ALL 때 마지막 코드가 깨져 0건 (START) */
--    V_DIVISION_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID,   1, 200));
--    V_PLAN_GROUP_ID     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PLAN_GROUP_ID, 1, 200));
--    V_SCM_SITE_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_SCM_SITE_ID,   1, 200));
--    V_STAGE             VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_STAGE,         1, 200));
--    V_VALID_YN          VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_VALID_YN,      1, 200));
    V_DIVISION_TAB      T_STR_TAB            := F_SPLIT_CLOB_LIST(P_DIVISION_ID);
    V_PLAN_GROUP_TAB    T_STR_TAB            := F_SPLIT_CLOB_LIST(P_PLAN_GROUP_ID);
    V_SCM_SITE_TAB      T_STR_TAB            := F_SPLIT_CLOB_LIST(P_SCM_SITE_ID);
    V_STAGE_TAB         T_STR_TAB            := F_SPLIT_CLOB_LIST(P_STAGE);
    V_VALID_YN_TAB      T_STR_TAB            := F_SPLIT_CLOB_LIST(P_VALID_YN);
    V_DIVISION_USE      VARCHAR2(1 CHAR)     := F_LIST_USE_YN(V_DIVISION_TAB);
    V_PLAN_GROUP_USE    VARCHAR2(1 CHAR)     := F_LIST_USE_YN(V_PLAN_GROUP_TAB);
    V_SCM_SITE_USE      VARCHAR2(1 CHAR)     := F_LIST_USE_YN(V_SCM_SITE_TAB);
    V_STAGE_USE         VARCHAR2(1 CHAR)     := F_LIST_USE_YN(V_STAGE_TAB);
    V_VALID_YN_USE      VARCHAR2(1 CHAR)     := F_LIST_USE_YN(V_VALID_YN_TAB);
    /* 2026.11.12 AJS (END) */
    V_PERIOD_FROM       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PERIOD_FROM,   1, 200));
    V_PERIOD_TO         VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PERIOD_TO,     1, 200));
    /* 품목만 원문이 자르지 않은 값을 쓴다 */
    /* 2026.11.12 AJS Model/Nickname 칸 값도 CLOB 그대로 나눠 목록으로 비교 (START) */
--    V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,       1, 32767));
    V_ITEM_TAB          T_STR_TAB            := F_SPLIT_CLOB_LIST(P_ITEM_ID);
    V_ITEM_USE          VARCHAR2(1 CHAR)     := F_LIST_USE_YN(V_ITEM_TAB);
    /* 2026.11.12 AJS (END) */
BEGIN

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.OPMZ_PLAN_GR_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.STAGE
             , TO_DATE(A.FROM_YYYYMMDD, 'YYYYMMDD')                 AS FROM_YYYYMMDD
             , TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD')                   AS TO_YYYYMMDD
             , A.ATTRIBUTE1                                         AS STOCK_EXCEPTION
             , A.VALUE_DESCRIPTION
             , A.VALID_YN
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.DIVISION_ID || '|' || A.OPMZ_PLAN_GR_ID || '|' || A.SCM_SITE_ID || '|' || A.ITEM_ID || '|' || A.FROM_YYYYMMDD || '|' || A.TO_YYYYMMDD || '|' || A.STAGE AS PRE_KEY_VALUES
          FROM SCP_OPMZ_DEMAND_EXCEPTION A
        /* 2026.11.12 AJS Model/Nickname : 값마다 품목코드 또는 닉네임 부분 일치 · 목록 조건은 나눠 둔 목록과 비교 (START) */
--             , (SELECT DISTINCT '%' || UPPER(COLUMN_VALUE) || '%'   AS TST
--                  FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))) IA
--         WHERE (UPPER(V_ITEM_ID) = 'ALL'      /* 조회조건 ALL 은 조건 없음 */
--                OR  A.ITEM_ID LIKE IA.TST)
         WHERE (V_ITEM_USE = 'N'                                  /* 값이 없거나 ALL 은 조건 없음 */
            OR  EXISTS (SELECT 1
                          FROM TABLE(V_ITEM_TAB) XA
                         WHERE UPPER(A.ITEM_ID) LIKE '%' || XA.COLUMN_VALUE || '%'   /* 2026.11.13 조회조건 대소문자 무시 : 컬럼도 대문자로 비교 */
                            OR EXISTS (SELECT 1
                                         FROM SCM_MST_ITEM_SN XB
                                        WHERE XB.ITEM_ID = A.ITEM_ID
                                          AND UPPER(XB.NICK_NAME) LIKE '%' || XA.COLUMN_VALUE || '%')))   /* 2026.11.13 조회조건 대소문자 무시 : 컬럼도 대문자로 비교 */
           /* AS-IS 는 대소문자를 가리지 않는다. 원장 실측상 소문자가 섞인 칸은 사이트 하나뿐이라
              사이트만 칸과 입력값을 함께, 나머지는 입력값만 대문자로 맞춘다 */
--           AND (TRIM(V_DIVISION_ID) IS NULL
--            OR  UPPER(V_DIVISION_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
--            OR  A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
--           AND (TRIM(V_SCM_SITE_ID) IS NULL
--            OR  UPPER(V_SCM_SITE_ID) = 'ALL'                     /* 조회조건 ALL 은 조건 없음 */
--            OR  UPPER(A.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE)
--                                           FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))))
--           AND (TRIM(V_VALID_YN) IS NULL
--            OR  UPPER(V_VALID_YN) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
--            OR  A.VALID_YN IN (SELECT UPPER(COLUMN_VALUE)
--                                 FROM TABLE(STRING_SPLIT(V_VALID_YN, ','))))
--           AND (TRIM(V_PLAN_GROUP_ID) IS NULL
--            OR  UPPER(V_PLAN_GROUP_ID) = 'ALL'                   /* 조회조건 ALL 은 조건 없음 */
--            OR  A.OPMZ_PLAN_GR_ID IN (SELECT UPPER(COLUMN_VALUE)
--                                        FROM TABLE(STRING_SPLIT(V_PLAN_GROUP_ID, ','))))
--           AND (TRIM(V_STAGE) IS NULL
--            OR  UPPER(V_STAGE) = 'ALL'                           /* 조회조건 ALL 은 조건 없음 */
--            OR  A.STAGE IN (SELECT UPPER(COLUMN_VALUE)
--                              FROM TABLE(STRING_SPLIT(V_STAGE, ','))))
           AND (V_DIVISION_USE = 'N'                              /* 값이 없거나 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                    FROM TABLE(V_DIVISION_TAB)))
           AND (V_SCM_SITE_USE = 'N'                              /* 값이 없거나 ALL 은 조건 없음 */
            OR  UPPER(A.SCM_SITE_ID) IN (SELECT COLUMN_VALUE
                                           FROM TABLE(V_SCM_SITE_TAB)))
           AND (V_VALID_YN_USE = 'N'                              /* 값이 없거나 ALL 은 조건 없음 */
            OR  A.VALID_YN IN (SELECT COLUMN_VALUE
                                 FROM TABLE(V_VALID_YN_TAB)))
           AND (V_PLAN_GROUP_USE = 'N'                            /* 값이 없거나 ALL 은 조건 없음 */
            OR  A.OPMZ_PLAN_GR_ID IN (SELECT COLUMN_VALUE
                                        FROM TABLE(V_PLAN_GROUP_TAB)))
           AND (V_STAGE_USE = 'N'                                 /* 값이 없거나 ALL 은 조건 없음 */
            OR  A.STAGE IN (SELECT COLUMN_VALUE
                              FROM TABLE(V_STAGE_TAB)))
        /* 2026.11.12 AJS (END) */
           AND A.FROM_YYYYMMDD     <= V_PERIOD_TO
           AND A.TO_YYYYMMDD       >= V_PERIOD_FROM
         /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(A.SCM_SITE_ID)     NULLS FIRST
                , FN_ASIS_SORT_KEY(A.OPMZ_PLAN_GR_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID)         NULLS FIRST
                , FN_ASIS_SORT_KEY(A.STAGE)           NULLS FIRST
                , FN_ASIS_SORT_KEY(A.FROM_YYYYMMDD)   NULLS FIRST
                , FN_ASIS_SORT_KEY(A.TO_YYYYMMDD)     NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0129_GET_DEMAND_EXCEPTION;

/****************************************************************************************************/
/* Program ID  : P_SCP0129_SAVE_DEMAND_EXCEPTION                                                    */
/* Description : 수요제외 등록 · 수정 · 삭제                                                        */
/****************************************************************************************************/
PROCEDURE P_SCP0129_SAVE_DEMAND_EXCEPTION
(
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_OPMZ_PLAN_GR_ID   IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_STAGE             IN  CLOB
  , P_FROM_YYYYMMDD     IN  CLOB
  , P_TO_YYYYMMDD       IN  CLOB
  , P_STOCK_EXCEPTION   IN  CLOB
  , P_VALUE_DESCRIPTION IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_PRE_DIVISION_ID   IN  CLOB
  , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
  , P_PRE_SCM_SITE_ID   IN  CLOB
  , P_PRE_ITEM_ID       IN  CLOB
  , P_PRE_STAGE         IN  CLOB
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
    V_STAGE             VARCHAR2(4000 CHAR);
    V_FROM_YYYYMMDD     VARCHAR2(4000 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(4000 CHAR);
    V_STOCK_EXCEPTION   VARCHAR2(4000 CHAR);
    V_VALUE_DESCRIPTION VARCHAR2(4000 CHAR);
    V_VALID_YN          VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_USER_ID, 1, 4000));

    V_PRE_DIVISION_ID   VARCHAR2(4000 CHAR);
    V_PRE_PLAN_GR_ID    VARCHAR2(4000 CHAR);
    V_PRE_SCM_SITE_ID   VARCHAR2(4000 CHAR);
    V_PRE_ITEM_ID       VARCHAR2(4000 CHAR);
    V_PRE_STAGE         VARCHAR2(4000 CHAR);
    V_PRE_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
    V_PRE_TO_YYYYMMDD   VARCHAR2(4000 CHAR);

    V_MAX_LOOP_CNT      NUMBER(10) := 0;
    V_MST_LOOP_CNT      NUMBER(10) := 0;
    V_CNT               NUMBER(10) := 0;

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0129_SAVE_DEMAND_EXCEPTION';
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
        V_STAGE             := SCM_ARR_SPL_VAL(P_STAGE,               C_DELIMITER, V_MST_LOOP_CNT);
        V_FROM_YYYYMMDD     := SCM_ARR_SPL_VAL(P_FROM_YYYYMMDD,       C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_YYYYMMDD       := SCM_ARR_SPL_VAL(P_TO_YYYYMMDD,         C_DELIMITER, V_MST_LOOP_CNT);
        V_STOCK_EXCEPTION   := SCM_ARR_SPL_VAL(P_STOCK_EXCEPTION,     C_DELIMITER, V_MST_LOOP_CNT);
        V_VALUE_DESCRIPTION := SCM_ARR_SPL_VAL(P_VALUE_DESCRIPTION,   C_DELIMITER, V_MST_LOOP_CNT);
        V_VALID_YN          := SCM_ARR_SPL_VAL(P_VALID_YN,            C_DELIMITER, V_MST_LOOP_CNT);

        V_PRE_DIVISION_ID   := SCM_ARR_SPL_VAL(P_PRE_DIVISION_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLAN_GR_ID    := SCM_ARR_SPL_VAL(P_PRE_OPMZ_PLAN_GR_ID, C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_SCM_SITE_ID   := SCM_ARR_SPL_VAL(P_PRE_SCM_SITE_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_ITEM_ID       := SCM_ARR_SPL_VAL(P_PRE_ITEM_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_STAGE         := SCM_ARR_SPL_VAL(P_PRE_STAGE,           C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_FROM_YYYYMMDD := SCM_ARR_SPL_VAL(P_PRE_FROM_YYYYMMDD,   C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_TO_YYYYMMDD   := SCM_ARR_SPL_VAL(P_PRE_TO_YYYYMMDD,     C_DELIMITER, V_MST_LOOP_CNT);

        /* 삭제가 아닌 경우 중복 확인 */
        IF V_ACTIVE_FLAG <> 'D'
        THEN

            /***** 중복체크 *****/
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCP_OPMZ_DEMAND_EXCEPTION
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND SCM_SITE_ID     = V_SCM_SITE_ID
               AND STAGE           = V_STAGE
               AND ITEM_ID         = V_ITEM_ID
               AND FROM_YYYYMMDD   = V_FROM_YYYYMMDD
               AND TO_YYYYMMDD     = V_TO_YYYYMMDD
               AND NOT (
                            DIVISION_ID     = NVL(V_PRE_DIVISION_ID,   C_NOMATCH)
                        AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID,    C_NOMATCH)
                        AND SCM_SITE_ID     = NVL(V_PRE_SCM_SITE_ID,   C_NOMATCH)
                        AND STAGE           = NVL(V_PRE_STAGE,         C_NOMATCH)
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
              FROM SCP_OPMZ_DEMAND_EXCEPTION X
             WHERE X.DIVISION_ID     = V_DIVISION_ID
               AND X.OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND X.SCM_SITE_ID     = V_SCM_SITE_ID
               AND X.STAGE           = V_STAGE
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

            INSERT INTO SCP_OPMZ_DEMAND_EXCEPTION
                        (
                          DIVISION_ID
                        , OPMZ_PLAN_GR_ID
                        , SCM_SITE_ID
                        , STAGE
                        , ITEM_ID
                        , FROM_YYYYMMDD
                        , TO_YYYYMMDD
                        , ATTRIBUTE1                                    /* STOCK_EXCEPTION */
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
                        , V_STAGE
                        , V_ITEM_ID
                        , V_FROM_YYYYMMDD
                        , V_TO_YYYYMMDD
                        , V_STOCK_EXCEPTION
                        , V_VALUE_DESCRIPTION
                        , V_VALID_YN
                        , V_LAST_UPDATED_BY
                        , SYSDATE
                        , V_LAST_UPDATED_BY
                        , SYSDATE
                        );

        ELSIF V_ACTIVE_FLAG = 'M'
        THEN

            UPDATE SCP_OPMZ_DEMAND_EXCEPTION
               SET DIVISION_ID       = V_DIVISION_ID
                 , OPMZ_PLAN_GR_ID   = V_OPMZ_PLAN_GR_ID
                 , SCM_SITE_ID       = V_SCM_SITE_ID
                 , STAGE             = V_STAGE
                 , ITEM_ID           = V_ITEM_ID
                 , FROM_YYYYMMDD     = V_FROM_YYYYMMDD
                 , TO_YYYYMMDD       = V_TO_YYYYMMDD
                 , ATTRIBUTE1        = V_STOCK_EXCEPTION                /* STOCK_EXCEPTION */
                 , VALUE_DESCRIPTION = V_VALUE_DESCRIPTION
                 , VALID_YN          = V_VALID_YN
                 , LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE  = SYSDATE
             WHERE DIVISION_ID       = NVL(V_PRE_DIVISION_ID,   C_NOMATCH)
               AND OPMZ_PLAN_GR_ID   = NVL(V_PRE_PLAN_GR_ID,    C_NOMATCH)
               AND SCM_SITE_ID       = NVL(V_PRE_SCM_SITE_ID,   C_NOMATCH)
               AND STAGE             = NVL(V_PRE_STAGE,         C_NOMATCH)
               AND ITEM_ID           = NVL(V_PRE_ITEM_ID,       C_NOMATCH)
               AND FROM_YYYYMMDD     = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
               AND TO_YYYYMMDD       = NVL(V_PRE_TO_YYYYMMDD,   C_NOMATCH);

        ELSIF V_ACTIVE_FLAG = 'D'
        THEN

            DELETE FROM SCP_OPMZ_DEMAND_EXCEPTION
             WHERE DIVISION_ID       = NVL(V_PRE_DIVISION_ID,   C_NOMATCH)
               AND OPMZ_PLAN_GR_ID   = NVL(V_PRE_PLAN_GR_ID,    C_NOMATCH)
               AND SCM_SITE_ID       = NVL(V_PRE_SCM_SITE_ID,   C_NOMATCH)
               AND STAGE             = NVL(V_PRE_STAGE,         C_NOMATCH)
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

END P_SCP0129_SAVE_DEMAND_EXCEPTION;

END PKG_SCP0129;
/
