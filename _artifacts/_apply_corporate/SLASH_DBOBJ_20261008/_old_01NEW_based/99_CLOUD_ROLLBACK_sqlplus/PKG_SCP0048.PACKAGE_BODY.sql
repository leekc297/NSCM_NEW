-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0048 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0048
AS
/****************************************************************************************************/
/* Program ID  : PKG_SCP0048                                                                        */
/* Description : ProjectRoute Warranty                                                             */
/* Program History                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/* 2026.10.07  AJS          P_SCP0048_GET_PROJECTROUTE_WARRANTY 조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시 */
/****************************************************************************************************/

    TYPE T_TOK IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    /* ------------------------------------------------------------
       ^ 구분 CLOB 분리 (AS-IS SCM_ARR_SPL_VAL · SCM_ARR_SPL_CNT 대응)
       - 토큰 앞뒤 공백 제거, 순번 1 부터
       - O_CNT : AS-IS SCM_ARR_SPL_CNT (구분자 수 + 1, 입력이 비면 0)
       ------------------------------------------------------------ */
    PROCEDURE P_SPLIT_TOKEN
    (
        P_STR       IN  CLOB
      , P_DELIM     IN  VARCHAR2
      , O_TAB       OUT T_TOK
      , O_CNT       OUT PLS_INTEGER
    )
    IS
        V_POS       PLS_INTEGER;
        V_FROM      PLS_INTEGER := 1;
        V_NR        PLS_INTEGER := 0;
        V_LEN       PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_STR), 0);
    BEGIN

        IF V_LEN = 0
        THEN
            O_CNT := 0;
            RETURN;
        END IF;

        LOOP
            V_POS := DBMS_LOB.INSTR(P_STR, P_DELIM, V_FROM, 1);

            EXIT WHEN V_POS = 0 OR V_POS IS NULL;

            V_NR := V_NR + 1;
            O_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_POS - V_FROM, V_FROM));
            V_FROM := V_POS + 1;
        END LOOP;

        V_NR := V_NR + 1;

        IF V_FROM <= V_LEN
        THEN
            O_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_LEN - V_FROM + 1, V_FROM));
        END IF;

        O_CNT := V_NR;

    END P_SPLIT_TOKEN;

    /* 토큰 꺼내기 - 없는 순번이면 빈 값 (AS-IS SCM_ARR_SPL_VAL 과 같음) */
    FUNCTION F_TOKEN
    (
        P_TAB       IN  T_TOK
      , P_IDX       IN  PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX)
        THEN
            RETURN P_TAB(P_IDX);
        END IF;

        RETURN NULL;
    END F_TOKEN;

    /* ------------------------------------------------------------
       AS-IS 등록일시 문자열 -> DATETIME 암묵 변환 대응
       - 빈 값은 MSSQL 이 1900-01-01 로 바꾼다
       - 바꿀 수 없는 값은 AS-IS 처럼 오류
       ------------------------------------------------------------ */
    FUNCTION F_TO_DATETIME
    (
        P_STR       IN  VARCHAR2
    )
    RETURN DATE
    IS
        V_DATE      DATE;
    BEGIN
        IF RTRIM(P_STR) IS NULL
        THEN
            RETURN DATE '1900-01-01';
        END IF;

        V_DATE := CAST(TO_TIMESTAMP(TRIM(P_STR) DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD HH24:MI:SS.FF') AS DATE);

        IF V_DATE IS NULL
        THEN
            V_DATE := TO_DATE(TRIM(P_STR) DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDDHH24MISS');
        END IF;

        IF V_DATE IS NULL
        THEN
            RAISE_APPLICATION_ERROR(-20001, 'Conversion failed when converting date and/or time from character string. [' || P_STR || ']');
        END IF;

        RETURN V_DATE;
    END F_TO_DATETIME;



/****************************************************************************************************/
/* Program ID  : P_SCP0048_GET_PROJECTROUTE_WARRANTY                                                */
/* Description : Project Route Plant Site(Warranty) 조회                                            */
/****************************************************************************************************/
PROCEDURE P_SCP0048_GET_PROJECTROUTE_WARRANTY
(
    P_DIVISION_ID       IN  VARCHAR2
  , P_PLANT_SITE        IN  VARCHAR2
  , P_OPERATION_GROUP   IN  VARCHAR2
  , P_ITEM_ID           IN  VARCHAR2
  , P_FROM_YYYYMM       IN  VARCHAR2
  , P_TO_YYYYMM         IN  VARCHAR2
  , P_VALID_FLAG        IN  VARCHAR2
  , O_MAIN_LIST         OUT SYS_REFCURSOR
  , O_ALL_LIST          OUT SYS_REFCURSOR
  , O_ITEM_LIST         OUT SYS_REFCURSOR
  , O_RESULT_CODE       OUT VARCHAR2
  , O_RESULT_MSG        OUT VARCHAR2
)
IS
    V_DIVISION_ID       VARCHAR2(4000 CHAR) := P_DIVISION_ID;
    V_PLANT_SITE        VARCHAR2(4000 CHAR) := P_PLANT_SITE;
    V_OPERATION_GROUP   VARCHAR2(4000 CHAR) := P_OPERATION_GROUP;
    V_ITEM_ID           VARCHAR2(200 CHAR)  := P_ITEM_ID;
    V_VALID_FLAG        VARCHAR2(200 CHAR)  := P_VALID_FLAG;
    V_ITEM_TAB          T_STR_TAB           := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */

BEGIN

    /* 조회조건 ALL 은 조건 없음으로 다룬다 */
    IF UPPER(TRIM(V_DIVISION_ID))     = 'ALL' THEN V_DIVISION_ID     := NULL; END IF;
    IF UPPER(TRIM(V_PLANT_SITE))      = 'ALL' THEN V_PLANT_SITE      := NULL; END IF;
    IF UPPER(TRIM(V_OPERATION_GROUP)) = 'ALL' THEN V_OPERATION_GROUP := NULL; END IF;
    IF UPPER(TRIM(V_ITEM_ID))         = 'ALL' THEN V_ITEM_ID         := NULL; END IF;
    IF UPPER(TRIM(V_VALID_FLAG))      = 'ALL' THEN V_VALID_FLAG      := NULL; END IF;

    /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력 토큰(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
       대상 품목 = 결과가 나오는 사이트별 품목 우선순위 원장 품목 · 닉네임은 같은 사업부 품목 원장 */
    IF TRIM(V_ITEM_ID) IS NOT NULL THEN
      SELECT IA.ITEM_ID
        BULK COLLECT INTO V_ITEM_TAB
        FROM SCM_MST_SITE_ITEM_PRIORITY IA
           , TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA
       WHERE SA.COLUMN_VALUE IS NOT NULL
         AND UPPER(IA.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
      UNION
      SELECT XA.ITEM_ID
        FROM SCM_MST_SITE_ITEM_PRIORITY XA
           , SCM_MST_ITEM_SN XB
           , TABLE(STRING_SPLIT(V_ITEM_ID, ',')) XC
       WHERE XB.ITEM_ID     = XA.ITEM_ID
         AND XB.DIVISION_ID = XA.DIVISION_ID
         AND XC.COLUMN_VALUE IS NOT NULL
         AND UPPER(XB.NICK_NAME) LIKE '%' || UPPER(XC.COLUMN_VALUE) || '%';
    END IF;
    /* 2026.10.07 AJS Model/Nickname 검색 (END) */

    /* 1. 주 목록 */
    OPEN O_MAIN_LIST FOR
        SELECT IA.PRIORITY_SEQ
             , IA.DIVISION_ID
             , IA.PROJECT_CODE
             , IA.ITEM_ID
             , IA.SCM_SITE_ID
             , IA.PLANT_SITE_ID                                             AS PLANT_SITE_ID_B
             /* ESS 외주 Pakcer Line 생산 Target 적용 */
             , IA.DIVISION_ID || '   ' || IA.PLANT_SITE_ID || '   ' || IA.SITE_DESCRIPTION
               || CASE WHEN (IA.TACT_CNT > 0 AND IA.OSP_YN = 'N')
                         OR (IA.OUT_CAPA_CNT > 0 AND IA.ATTRIBUTE1 IN ('-', 'N'))
                         OR (IA.OUT_TACT_CNT > 0 AND IA.ATTRIBUTE1 = 'Y')
                       THEN ' Y'
                       ELSE ' N'
                  END                                                       AS PLANT_SITE_ID
             , CASE WHEN (IA.TACT_CNT > 0 AND IA.OSP_YN = 'N')
                      OR (IA.OUT_CAPA_CNT > 0 AND IA.ATTRIBUTE1 IN ('-', 'N'))
                      OR (IA.OUT_TACT_CNT > 0 AND IA.ATTRIBUTE1 = 'Y')
                    THEN ' Y'
                    ELSE ' N'
               END                                                          AS TACT_TIME_FLAG
             , IA.PRIORITY
             , IA.VALID_YN
             , IA.ORG_VALID_YN
             , IA.FROM_YYYYMMDD
             , IA.TO_YYYYMMDD
             , IA.CREATED_BY
             , IA.CREATION_DATE
             , IA.LAST_UPDATED_BY
             , IA.LAST_UPDATE_DATE
             , IA.OPERATION_GROUP
             , IA.ORG_FROM_YYYYMMDD
             , IA.ORG_TO_YYYYMMDD
             , IA.MERGE_DATE
             , IA.IS_PASS_N1
             , IA.IS_PASS_N2
             , IA.IS_PASS_N3
             , IA.IS_PASS_N4
             , IA.IS_PASS_N5
             , IA.IS_PASS_N6
             , IA.IS_PASS_N7
             , IA.NICK_NAME
             , IA.ACTION_FLAG_DIV
             , IA.ROW_COLOR_INDEX
             , IA.SORT_ORDER
          FROM (SELECT TO_CHAR(A.PRIORITY_SEQ)                              AS PRIORITY_SEQ
                     , A.DIVISION_ID
                     , NVL(NULLIF(A.PROJECT_CODE, '-'), '-')                AS PROJECT_CODE
                     , A.ITEM_ID
                     , NVL(NULLIF(A.SALES_SITE_ID, '-'), '-')               AS SCM_SITE_ID
                     , A.PLANT_SITE_ID
                     , A.PRIORITY
                     , A.VALID_YN
                     , A.VALID_YN                                           AS ORG_VALID_YN
                     /* ★원장에 달력에 없는 날짜가 섞여 있다. AS-IS 는 FN_CHAR_TO_DATE 를 쓰지만 그 함수는 오류를 내므로  */
                     /*   같은 형식으로 직접 바꾸되, 바꿀 수 없으면 원래 값을 그대로 보여준다                        */
                     , NVL(TO_CHAR(TO_DATE(A.FROM_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.FROM_YYYYMMDD) AS FROM_YYYYMMDD
                     , NVL(TO_CHAR(TO_DATE(A.TO_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.TO_YYYYMMDD)     AS TO_YYYYMMDD
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , B.OPERATION_GROUP
                     , A.FROM_YYYYMMDD                                      AS ORG_FROM_YYYYMMDD
                     , A.TO_YYYYMMDD                                        AS ORG_TO_YYYYMMDD
                     , A.FROM_YYYYMMDD || A.TO_YYYYMMDD                     AS MERGE_DATE
                     , ''                                                   AS IS_PASS_N1
                     , ''                                                   AS IS_PASS_N2
                     , ''                                                   AS IS_PASS_N3
                     , ''                                                   AS IS_PASS_N4
                     , ''                                                   AS IS_PASS_N5
                     , ''                                                   AS IS_PASS_N6
                     , ''                                                   AS IS_PASS_N7
                     , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)       AS NICK_NAME
                     , '-'                                                  AS ACTION_FLAG_DIV
                     , 0                                                    AS ROW_COLOR_INDEX
                     , 1                                                    AS SORT_ORDER
                     , NVL((SELECT COUNT(X.PLANT_SITE_ID)
                              FROM SCP_MST_TACT_TIME X
                                 , SCM_MST_LINE_SN Y
                             WHERE Y.COMPANY_ID    = B.COMPANY_ID
                               AND Y.DIVISION_ID   = X.DIVISION_ID
                               AND Y.SITE_ID       = B.SITE_ID
                               AND Y.PLANT_ID      = B.PLANT_ID
                               AND Y.OPERATION_ID  = X.OPERATION_ID
                               AND Y.LINE_ID       = X.LINE_ID
                               AND Y.ACTIVE_FLAG   = 'Y'
                               AND X.ITEM_ID       = A.ITEM_ID
                               AND X.VALID_YN      = 'Y'
                               AND X.PLANT_SITE_ID = B.SCM_SITE_ID
                               AND (TRIM(V_DIVISION_ID) IS NULL OR X.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
                             GROUP BY X.ITEM_ID
                                    , X.PLANT_SITE_ID), 0)                  AS TACT_CNT
                     , NVL((SELECT COUNT(X.PLANT_SITE_ID)
                              FROM SCP_MST_OUTSOURCING_CAPA X
                             WHERE X.ITEM_ID       = A.ITEM_ID
                               AND X.VALID_YN      = 'Y'
                               AND X.PLANT_SITE_ID = B.SCM_SITE_ID
                               AND (TRIM(V_DIVISION_ID) IS NULL OR X.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
                             GROUP BY X.PLANT_SITE_ID
                                    , X.ITEM_ID), 0)                        AS OUT_CAPA_CNT
                     , B.SITE_DESCRIPTION
                     /* ESS 외주 Pakcer Line 생산 Target 적용 */
                     , NVL((SELECT COUNT(X.PLANT_SITE_ID)
                              FROM SCP_MST_TACT_TIME_OSP X
                                 , SCM_MST_LINE_OSP Y
                             WHERE Y.DIVISION_ID   = X.DIVISION_ID
                               AND Y.SCM_SITE_ID   = X.PLANT_SITE_ID
                               AND Y.LINE_ID       = X.LINE_ID
                               AND Y.VALID_YN      = 'Y'
                               AND X.ITEM_ID       = A.ITEM_ID
                               AND X.VALID_YN      = 'Y'
                               AND X.PLANT_SITE_ID = B.SCM_SITE_ID
                               AND (TRIM(V_DIVISION_ID) IS NULL OR X.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
                             GROUP BY X.PLANT_SITE_ID
                                    , X.ITEM_ID), 0)                        AS OUT_TACT_CNT
                     , NVL(B.OSP_YN, 'N')                                   AS OSP_YN
                     , NVL(B.ATTRIBUTE1, 'N')                               AS ATTRIBUTE1
                  FROM SCM_MST_SITE_ITEM_PRIORITY A
                     , SCM_MST_SITE B
                 WHERE ((A.DIVISION_ID = B.DIVISION_ID AND B.OPERATION_GROUP <> 'W') OR B.OPERATION_GROUP = 'W')
                   AND A.PLANT_SITE_ID = B.SCM_SITE_ID
                   AND B.SITE_TYPE     = 'PLANT'
                   AND (TRIM(V_DIVISION_ID) IS NULL OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
                   AND (TRIM(V_PLANT_SITE) IS NULL OR A.PLANT_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE, ','))))
--                 AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID LIKE '%' || V_ITEM_ID || '%')   --  2026.10.07 AJS
                   AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID IN (SELECT XT.COLUMN_VALUE FROM TABLE(V_ITEM_TAB) XT))   --  2026.10.07 AJS
                   AND (TRIM(V_VALID_FLAG) IS NULL OR A.VALID_YN = V_VALID_FLAG)
               ) IA
         WHERE EXISTS (SELECT 1
                         FROM SCM_MST_SITE_ITEM_PRIORITY XA
                            , SCM_MST_SITE SA
                        WHERE XA.DIVISION_ID   = SA.DIVISION_ID
                          AND XA.PLANT_SITE_ID = SA.SCM_SITE_ID
                          AND SA.OPERATION_GROUP = 'W'
                          AND XA.ITEM_ID       = IA.ITEM_ID
                          AND (TRIM(V_DIVISION_ID) IS NULL OR XA.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ',')))))
         ORDER BY NLSSORT(IA.DIVISION_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST
                , NLSSORT(IA.ITEM_ID, 'NLS_SORT=BINARY_CI') DESC NULLS LAST;

    /* 2. 전체조회 */
    OPEN O_ALL_LIST FOR
        SELECT TO_CHAR(A.PRIORITY_SEQ)                                      AS PRIORITY_SEQ
             , A.DIVISION_ID
             , NVL(A.PROJECT_CODE, '-')                                     AS PROJECT_CODE
             , A.ITEM_ID
             , NVL(A.SALES_SITE_ID, '-')                                    AS SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.PRIORITY
             , A.VALID_YN
             , A.VALID_YN                                                   AS ORG_VALID_YN
             /* ★원장에 달력에 없는 날짜가 섞여 있다. AS-IS 는 FN_CHAR_TO_DATE 를 쓰지만 그 함수는 오류를 내므로  */
                     /*   같은 형식으로 직접 바꾸되, 바꿀 수 없으면 원래 값을 그대로 보여준다                        */
             , NVL(TO_CHAR(TO_DATE(A.FROM_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.FROM_YYYYMMDD) AS FROM_YYYYMMDD
             , NVL(TO_CHAR(TO_DATE(A.TO_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.TO_YYYYMMDD)     AS TO_YYYYMMDD
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , B.OPERATION_GROUP
             , A.FROM_YYYYMMDD                                              AS ORG_FROM_YYYYMMDD
             , A.TO_YYYYMMDD                                                AS ORG_TO_YYYYMMDD
             , A.FROM_YYYYMMDD || A.TO_YYYYMMDD                             AS MERGE_DATE
             , ''                                                           AS IS_PASS_N1
             , ''                                                           AS IS_PASS_N2
             , ''                                                           AS IS_PASS_N3
             , ''                                                           AS IS_PASS_N4
             , ''                                                           AS IS_PASS_N5
             , ''                                                           AS IS_PASS_N6
             , ''                                                           AS IS_PASS_N7
             , '-'                                                          AS ACTION_FLAG_DIV
             , 0                                                            AS ROW_COLOR_INDEX
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE B
         WHERE ((A.DIVISION_ID = B.DIVISION_ID AND B.OPERATION_GROUP <> 'W') OR B.OPERATION_GROUP = 'W')
           AND A.PLANT_SITE_ID = B.SCM_SITE_ID
           AND B.SITE_TYPE     = 'PLANT'
           AND A.VALID_YN      = 'Y'
           AND (TRIM(V_DIVISION_ID) IS NULL OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
         ORDER BY NLSSORT(A.DIVISION_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST
                , NLSSORT(A.ITEM_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST
                , A.FROM_YYYYMMDD NULLS FIRST
                , A.PRIORITY NULLS FIRST
                , A.VALID_YN DESC NULLS LAST
                , A.TO_YYYYMMDD NULLS FIRST;

    /* 3. 아이템 조회용 */
    OPEN O_ITEM_LIST FOR
        SELECT A.ITEM_ID
             , D.NICK_NAME
          FROM SCM_MST_SITE_ITEM A
             , SCM_MST_DIVISION B
             , SCM_MST_SITE C
             , SCM_MST_ITEM_SN D
             , SCM_MST_PROJECT E
         WHERE A.DIVISION_ID  = B.DIVISION_ID
           AND A.DIVISION_ID  = C.DIVISION_ID
           AND A.SCM_SITE_ID  = C.SCM_SITE_ID
           AND A.DIVISION_ID  = D.DIVISION_ID
           AND A.ITEM_ID      = D.ITEM_ID
           AND A.DIVISION_ID  = E.DIVISION_ID(+)
           AND A.PROJECT_CODE = E.PROJECT_CODE(+)
         GROUP BY A.ITEM_ID
                , D.ITEM_NAME
                , D.ITEM_TYPE
                , D.NICK_NAME
                , D.ITEM_CLASS_NAME
         /* AS-IS 에는 정렬이 없어 화면에서 순서가 흔들린다 — 품목 순으로 고정한다 */
         ORDER BY NLSSORT(A.ITEM_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST;

    O_RESULT_CODE := '0';
    O_RESULT_MSG  := 'SUCCESS';

END P_SCP0048_GET_PROJECTROUTE_WARRANTY;

/****************************************************************************************************/
/* Program ID  : P_SCP0048_SAVE_PROJECTROUTE_WARRANTY                                              */
/* Description : Project Route Plant Site 등록,수정                                                 */
/****************************************************************************************************/
PROCEDURE P_SCP0048_SAVE_PROJECTROUTE_WARRANTY
(
    P_ACTIVE_FLAG       IN  CLOB
  , P_PRIORITY_SEQ      IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_PROJECT_CODE      IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_PLANT_SITE_ID     IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_CREATED_BY        IN  CLOB
  , P_CREATION_DATE     IN  CLOB
  , P_LAST_UPDATED_BY   IN  CLOB
  , P_PRIORITY          IN  CLOB
  , P_FROM_YYYYMMDD     IN  CLOB
  , P_TO_YYYYMMDD       IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_DEBUG_MODE        IN  VARCHAR2 DEFAULT 'F'
  , O_RESULT_CODE       OUT VARCHAR2
  , O_RESULT_CNT        OUT NUMBER
  , O_RESULT_MSG        OUT VARCHAR2
)
IS
    C_DELIM                 CONSTANT VARCHAR2(1 CHAR) := '^';
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SCP0048_SAVE_PROJECTROUTE_WARRANTY';

    T_ACTIVE_FLAG           T_TOK;
    T_PRIORITY_SEQ          T_TOK;
    T_DIVISION_ID           T_TOK;
    T_PROJECT_CODE          T_TOK;
    T_SCM_SITE_ID           T_TOK;
    T_PLANT_SITE_ID         T_TOK;
    T_ITEM_ID               T_TOK;
    T_CREATED_BY            T_TOK;
    T_CREATION_DATE         T_TOK;
    T_LAST_UPDATED_BY       T_TOK;
    T_PRIORITY              T_TOK;
    T_FROM_YYYYMMDD         T_TOK;
    T_TO_YYYYMMDD           T_TOK;
    T_VALID_YN              T_TOK;

    V_LOOP_CNT              PLS_INTEGER := 0;
    V_DUMMY_CNT             PLS_INTEGER := 0;

    V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
    V_PRIORITY_SEQ          VARCHAR2(4000 CHAR);
    V_DIVISION_ID           VARCHAR2(4000 CHAR);
    V_PROJECT_CODE          VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID         VARCHAR2(4000 CHAR);
    V_ITEM_ID               VARCHAR2(4000 CHAR);
    V_S_VALID_YN            VARCHAR2(4000 CHAR);
    V_CREATED_BY            VARCHAR2(4000 CHAR);
    V_CREATION_DATE         DATE;
    V_LAST_UPDATED_BY       VARCHAR2(4000 CHAR);
    V_PRIORITY              VARCHAR2(4000 CHAR);
    V_FROM_YYYYMMDD         VARCHAR2(4000 CHAR);
    V_TO_YYYYMMDD           VARCHAR2(4000 CHAR);
    V_VALID_YN              VARCHAR2(4000 CHAR);

    V_CURRENCY              VARCHAR2(4000 CHAR) := NULL;
    V_LIABILITY_PERIOD      VARCHAR2(4000 CHAR) := NULL;
    V_SALES_PLAN_ADJUST_YN  VARCHAR2(4000 CHAR) := NULL;
    V_ITEM_HRCY_ID          VARCHAR2(4000 CHAR) := NULL;
    V_BPMS_EXIST            VARCHAR2(1 CHAR)    := 'Y';


    V_CNT                   PLS_INTEGER;
    V_SQLERRM               VARCHAR2(4000 CHAR);
    V_SQLCODE               NUMBER;

BEGIN

    /* 시작 LOG */
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

    /* 각 컬럼들에 대한 스플릿처리 */
    P_SPLIT_TOKEN(P_ACTIVE_FLAG     , C_DELIM, T_ACTIVE_FLAG     , V_LOOP_CNT);     /* 프로시저 LOOP 길이를 판단 */
    P_SPLIT_TOKEN(P_PRIORITY_SEQ    , C_DELIM, T_PRIORITY_SEQ    , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_DIVISION_ID     , C_DELIM, T_DIVISION_ID     , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_PROJECT_CODE    , C_DELIM, T_PROJECT_CODE    , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_SCM_SITE_ID     , C_DELIM, T_SCM_SITE_ID     , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_PLANT_SITE_ID   , C_DELIM, T_PLANT_SITE_ID   , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_ITEM_ID         , C_DELIM, T_ITEM_ID         , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_CREATED_BY      , C_DELIM, T_CREATED_BY      , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_CREATION_DATE   , C_DELIM, T_CREATION_DATE   , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_LAST_UPDATED_BY , C_DELIM, T_LAST_UPDATED_BY , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_PRIORITY        , C_DELIM, T_PRIORITY        , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_FROM_YYYYMMDD   , C_DELIM, T_FROM_YYYYMMDD   , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_TO_YYYYMMDD     , C_DELIM, T_TO_YYYYMMDD     , V_DUMMY_CNT);
    P_SPLIT_TOKEN(P_VALID_YN        , C_DELIM, T_VALID_YN        , V_DUMMY_CNT);

    FOR I IN 1 .. V_LOOP_CNT
    LOOP

        V_PRIORITY_SEQ := F_TOKEN(T_PRIORITY_SEQ, I);

        IF V_PRIORITY_SEQ IS NULL
        THEN
            V_PRIORITY_SEQ := TO_CHAR(SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL);
        END IF;

        V_ACTIVE_FLAG     := F_TOKEN(T_ACTIVE_FLAG, I);
        V_DIVISION_ID     := F_TOKEN(T_DIVISION_ID, I);
        V_PROJECT_CODE    := F_TOKEN(T_PROJECT_CODE, I);
        V_SCM_SITE_ID     := F_TOKEN(T_SCM_SITE_ID, I);
        V_PLANT_SITE_ID   := F_TOKEN(T_PLANT_SITE_ID, I);
        V_ITEM_ID         := F_TOKEN(T_ITEM_ID, I);
        V_CREATED_BY      := F_TOKEN(T_CREATED_BY, I);
        V_CREATION_DATE   := F_TO_DATETIME(F_TOKEN(T_CREATION_DATE, I));
        V_LAST_UPDATED_BY := F_TOKEN(T_LAST_UPDATED_BY, I);
        V_PRIORITY        := F_TOKEN(T_PRIORITY, I);
        V_FROM_YYYYMMDD   := F_TOKEN(T_FROM_YYYYMMDD, I);
        V_TO_YYYYMMDD     := F_TOKEN(T_TO_YYYYMMDD, I);
        V_VALID_YN        := F_TOKEN(T_VALID_YN, I);

        BEGIN
            SELECT VALID_YN
              INTO V_S_VALID_YN
              FROM SCM_MST_SITE_ITEM
             WHERE DIVISION_ID  = V_DIVISION_ID
               AND SCM_SITE_ID  = V_SCM_SITE_ID
               AND ITEM_ID      = V_ITEM_ID
               AND PROJECT_CODE = V_PROJECT_CODE;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN V_S_VALID_YN := NULL;
            WHEN TOO_MANY_ROWS THEN V_S_VALID_YN := NULL;
        END;

        /* 이력저장 */
        PR_SCM_MST_SITE_ITEM_HIST(V_DIVISION_ID, V_PROJECT_CODE, V_PLANT_SITE_ID, V_ITEM_ID
                                , V_CURRENCY, V_LIABILITY_PERIOD, V_SALES_PLAN_ADJUST_YN, V_ITEM_HRCY_ID
                                , V_S_VALID_YN, V_BPMS_EXIST, V_CREATED_BY, TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS'), V_LAST_UPDATED_BY);

        PR_SCM_MST_SITE_ITEM_PRIORITY_HIST(V_PRIORITY_SEQ, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID
                                         , V_PLANT_SITE_ID, V_ITEM_ID, V_PRIORITY, V_FROM_YYYYMMDD
                                         , V_TO_YYYYMMDD, V_VALID_YN, V_CREATED_BY
                                         , TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS'), V_LAST_UPDATED_BY);

        /* 데이터 저장 — AS-IS MERGE 를 조회 후 수정 · 넣기로 나눈다 (온라인 SQL 은 MERGE 금지) */
        UPDATE SCM_MST_SITE_ITEM
           SET LAST_UPDATED_BY   = V_LAST_UPDATED_BY
             , LAST_UPDATE_DATE  = SYSDATE
         WHERE DIVISION_ID  = V_DIVISION_ID
           AND PROJECT_CODE = V_PROJECT_CODE
           AND SCM_SITE_ID  = V_PLANT_SITE_ID
           AND ITEM_ID      = V_ITEM_ID;

        IF SQL%ROWCOUNT = 0
        THEN
            INSERT INTO SCM_MST_SITE_ITEM
                        (
                          DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                        , CURRENCY, LIABILITY_PERIOD, SALES_PLAN_ADJUST_YN, ITEM_HRCY_ID
                        , VALID_YN, BPMS_EXIST
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        )
            VALUES      (
                          V_DIVISION_ID, V_PROJECT_CODE, V_PLANT_SITE_ID, V_ITEM_ID
                        , NULL, NULL, NULL, NULL
                        , 'Y', 'Y'
                        , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                        );
        END IF;

        /* SCM_MST_SITE_ITEM_PRIORITY 입력/수정 */
        IF V_ACTIVE_FLAG = 'M'
        THEN
            UPDATE SCM_MST_SITE_ITEM_PRIORITY
               SET SALES_SITE_ID     = V_SCM_SITE_ID
                 , PLANT_SITE_ID     = V_PLANT_SITE_ID
                 , PRIORITY          = V_PRIORITY
                 , FROM_YYYYMMDD     = V_FROM_YYYYMMDD
                 , TO_YYYYMMDD       = V_TO_YYYYMMDD
                 , VALID_YN          = V_VALID_YN
                 , LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE  = SYSDATE
             WHERE PRIORITY_SEQ = TO_NUMBER(V_PRIORITY_SEQ);

        ELSIF V_ACTIVE_FLAG = 'I'
        THEN
            INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                        (
                          PRIORITY_SEQ, DIVISION_ID, PROJECT_CODE, SALES_SITE_ID, PLANT_SITE_ID, ITEM_ID
                        , PRIORITY, FROM_YYYYMMDD, TO_YYYYMMDD, VALID_YN
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                        )
            VALUES      (
                          TO_NUMBER(V_PRIORITY_SEQ), V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
                        , V_PRIORITY, V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_VALID_YN
                        , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                        );
        END IF;


    END LOOP;

    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

    COMMIT;

    /* 결과코드, 결과 카운트 반환 */
    O_RESULT_CODE := 'S';
    O_RESULT_CNT  := V_LOOP_CNT;
    O_RESULT_MSG  := NULL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQLCODE := SQLCODE;
        V_SQLERRM := SQLERRM;

        ROLLBACK;                                                               /* 입력 데이타 롤백 처리 */

        INSERT INTO SCM_SYS_LOG_BATCH
                    (
                      PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                    , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY
                    )
        VALUES      (
                      V_PROGRAM_NAME, 'ERROR', NULL, V_SQLERRM, NULL
                    , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME
                    );
        COMMIT;

        /* error코드, errror 메시지 반환 */
        O_RESULT_CODE := 'F';
        O_RESULT_CNT  := 0;
        O_RESULT_MSG  := '[' || V_SQLCODE || ']' || V_SQLERRM;

END P_SCP0048_SAVE_PROJECTROUTE_WARRANTY;

END PKG_SCP0048;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0048
