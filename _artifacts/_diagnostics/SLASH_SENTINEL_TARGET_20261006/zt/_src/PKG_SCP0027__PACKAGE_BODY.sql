PACKAGE BODY PKG_SCP0027
AS
/****************************************************************************************************/
/* Program ID  : PKG_SCP0027                                                                        */
/* Description : ProjectRoute Electrode                                                             */
/* Program History                                                                                  */
/*--------------------------------------------------------------------------------------------------*/
/* Date        In Charge    Description                                                             */
/*--------------------------------------------------------------------------------------------------*/
/* 2026.09.24  ZIONEX       [PJ202650304] MSSQL -> Oracle 전환                                      */
/* 2026.10.06  AJS          P_SCP0027_GET_PROJECTROUTE_ELECTRODE 조회 속도 개선(라인 확인 하위질의 IX01_SCM_LINE_M 사용) */
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
/* Program ID  : P_SCP0027_GET_PROJECTROUTE_ELECTRODE                                               */
/* Description : Project Route Plant Site(Electrode) 조회                                           */
/****************************************************************************************************/
PROCEDURE P_SCP0027_GET_PROJECTROUTE_ELECTRODE
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

BEGIN

    /* 조회조건 ALL 은 조건 없음으로 다룬다 */
    IF UPPER(TRIM(V_DIVISION_ID))     = 'ALL' THEN V_DIVISION_ID     := NULL; END IF;
    IF UPPER(TRIM(V_PLANT_SITE))      = 'ALL' THEN V_PLANT_SITE      := NULL; END IF;
    IF UPPER(TRIM(V_OPERATION_GROUP)) = 'ALL' THEN V_OPERATION_GROUP := NULL; END IF;
    IF UPPER(TRIM(V_ITEM_ID))         = 'ALL' THEN V_ITEM_ID         := NULL; END IF;
    IF UPPER(TRIM(V_VALID_FLAG))      = 'ALL' THEN V_VALID_FLAG      := NULL; END IF;

    /* 1. 주 목록 — Cell계획기준 전극미등록 모델 리스트 + 등록분 */
    OPEN O_MAIN_LIST FOR
        SELECT PRIORITY_SEQ
             , DIVISION_ID
             , PROJECT_CODE
             , ITEM_ID
             , SCM_SITE_ID
             , PLANT_SITE_ID_B
             , PLANT_SITE_ID
             , TACT_TIME_FLAG
             , PRIORITY
             , VALID_YN
             , ORG_VALID_YN
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , OPERATION_GROUP
             , ORG_FROM_YYYYMMDD
             , ORG_TO_YYYYMMDD
             , MERGE_DATE
             , IS_PASS_N1
             , IS_PASS_N2
             , IS_PASS_N3
             , IS_PASS_N4
             , IS_PASS_N5
             , IS_PASS_N6
             , IS_PASS_N7
             , NICK_NAME
             , OPERATION_GROUP_NAME
             , ACTION_FLAG_DIV
             , ROW_COLOR_INDEX
             , SORT_ORDER
          FROM (SELECT ''                                                       AS PRIORITY_SEQ
                     , A.DIVISION_ID
                     , '-'                                                      AS PROJECT_CODE
                     , A.CHILD_ITEM_ID                                          AS ITEM_ID
                     , '-'                                                      AS SCM_SITE_ID
                     , ''                                                       AS PLANT_SITE_ID_B
                     , ''                                                       AS PLANT_SITE_ID
                     , ''                                                       AS TACT_TIME_FLAG
                     , 0                                                        AS PRIORITY     /* AS-IS 는 빈 문자를 숫자 칸과 UNION 해 0 이 된다 */
                     , 'Y'                                                      AS VALID_YN
                     , 'Y'                                                      AS ORG_VALID_YN
                     , ''                                                       AS FROM_YYYYMMDD
                     , ''                                                       AS TO_YYYYMMDD
                     , ''                                                       AS CREATED_BY
                     , CAST(NULL AS DATE)                                       AS CREATION_DATE
                     , ''                                                       AS LAST_UPDATED_BY
                     , CAST(NULL AS DATE)                                       AS LAST_UPDATE_DATE
                     , A.OPERATION_GROUP_ID                                     AS OPERATION_GROUP
                     , ''                                                       AS ORG_FROM_YYYYMMDD
                     , ''                                                       AS ORG_TO_YYYYMMDD
                     , ''                                                       AS MERGE_DATE
                     , ''                                                       AS IS_PASS_N1
                     , ''                                                       AS IS_PASS_N2
                     , ''                                                       AS IS_PASS_N3
                     , ''                                                       AS IS_PASS_N4
                     , ''                                                       AS IS_PASS_N5
                     , ''                                                       AS IS_PASS_N6
                     , ''                                                       AS IS_PASS_N7
                     , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.CHILD_ITEM_ID)     AS NICK_NAME
                     , C.SEGMENT2                                               AS OPERATION_GROUP_NAME
                     , '-'                                                      AS ACTION_FLAG_DIV
                     , 0                                                        AS ROW_COLOR_INDEX
                     , 0                                                        AS SORT_ORDER
                  FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                     , SCM_ADM_LOOKUP_MASTER B
                     , SCM_ADM_LOOKUP_MASTER_DETAIL C
                     , (SELECT DISTINCT DIVISION_ID
                             , ITEM_ID
                          FROM SCP_ANL_PRODUCTION_PLAN
                         WHERE DIVISION_ID          IN (SELECT DIVISION_ID
                                                          FROM SCM_MST_DIVISION
                                                         WHERE ATTRIBUTE3  <> 'EE'
                                                           AND DIVISION_ID <> '82')
                           AND PLAN_START_YYYYMMDD  >= FN_GET_BUCKET_YYYYMMDD(-1)
                           AND OPERATION_GROUP       = 'A'
                           AND MEASURE               = 'PROD_PLAN_AMEND'
                       ) IA
                 WHERE B.LOOKUP_TYPE          = 'OPERATION_GROUP'
                   AND B.VALID_YN             = 'Y'
                   AND C.LOOKUP_TYPE          = B.LOOKUP_TYPE
                   AND C.VALID_YN             = 'Y'
                   AND C.SEGMENT1             = 'E'
                   AND IA.DIVISION_ID         = A.DIVISION_ID
                   AND IA.ITEM_ID             = A.MODEL_ID
                   AND A.OPERATION_GROUP_ID   = 'E'
                   AND NOT EXISTS (SELECT 1
                                     FROM SCM_MST_SITE_ITEM_PRIORITY T
                                    WHERE T.DIVISION_ID = A.DIVISION_ID
                                      AND T.ITEM_ID     = A.CHILD_ITEM_ID
                                      AND T.VALID_YN    = 'Y')
                   AND (TRIM(V_OPERATION_GROUP) IS NULL OR A.OPERATION_GROUP_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_OPERATION_GROUP, ','))))
                   AND (TRIM(V_ITEM_ID) IS NULL OR A.CHILD_ITEM_ID LIKE '%' || V_ITEM_ID || '%')
                 UNION ALL
                SELECT IA.PRIORITY_SEQ
                     , IA.DIVISION_ID
                     , IA.PROJECT_CODE
                     , IA.ITEM_ID
                     , IA.SCM_SITE_ID
                     , IA.PLANT_SITE_ID                                         AS PLANT_SITE_ID_B
                     /* ESS 외주 Pakcer Line 생산 Target 적용 */
                     , IA.DIVISION_ID || '   ' || IA.PLANT_SITE_ID || '   ' || IA.SITE_DESCRIPTION
                       || CASE WHEN (IA.TACT_CNT > 0 AND IA.OSP_YN = 'N')
                                 OR (IA.OUT_CAPA_CNT > 0 AND IA.ATTRIBUTE1 IN ('-', 'N'))
                                 OR (IA.OUT_TACT_CNT > 0 AND IA.ATTRIBUTE1 = 'Y')
                               THEN ' Y'
                               ELSE ' N'
                          END                                                   AS PLANT_SITE_ID
                     , CASE WHEN (IA.TACT_CNT > 0 AND IA.OSP_YN = 'N')
                              OR (IA.OUT_CAPA_CNT > 0 AND IA.ATTRIBUTE1 IN ('-', 'N'))
                              OR (IA.OUT_TACT_CNT > 0 AND IA.ATTRIBUTE1 = 'Y')
                            THEN ' Y'
                            ELSE ' N'
                       END                                                      AS TACT_TIME_FLAG
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
                     , IA.OPERATION_GROUP_NAME
                     , IA.ACTION_FLAG_DIV
                     , IA.ROW_COLOR_INDEX
                     , IA.SORT_ORDER
                  FROM (SELECT TO_CHAR(A.PRIORITY_SEQ)                          AS PRIORITY_SEQ
                             , A.DIVISION_ID
                             , NVL(NULLIF(A.PROJECT_CODE, '-'), '-')            AS PROJECT_CODE
                             , A.ITEM_ID
                             , NVL(NULLIF(A.SALES_SITE_ID, '-'), '-')           AS SCM_SITE_ID
                             , A.PLANT_SITE_ID
                             , A.PRIORITY
                             , A.VALID_YN
                             , A.VALID_YN                                       AS ORG_VALID_YN
                             /* ★원장에 달력에 없는 날짜가 섞여 있어 바꿀 수 없으면 원래 값을 그대로 보여준다 */
                             , NVL(TO_CHAR(TO_DATE(A.FROM_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.FROM_YYYYMMDD) AS FROM_YYYYMMDD
                             , NVL(TO_CHAR(TO_DATE(A.TO_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.TO_YYYYMMDD)     AS TO_YYYYMMDD
                             , A.CREATED_BY
                             , A.CREATION_DATE
                             , A.LAST_UPDATED_BY
                             , A.LAST_UPDATE_DATE
                             , B.OPERATION_GROUP
                             , A.FROM_YYYYMMDD                                  AS ORG_FROM_YYYYMMDD
                             , A.TO_YYYYMMDD                                    AS ORG_TO_YYYYMMDD
                             , A.FROM_YYYYMMDD || A.TO_YYYYMMDD                 AS MERGE_DATE
                             , ''                                               AS IS_PASS_N1
                             , ''                                               AS IS_PASS_N2
                             , ''                                               AS IS_PASS_N3
                             , ''                                               AS IS_PASS_N4
                             , ''                                               AS IS_PASS_N5
                             , ''                                               AS IS_PASS_N6
                             , ''                                               AS IS_PASS_N7
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)   AS NICK_NAME
                             , D.SEGMENT2                                       AS OPERATION_GROUP_NAME
                             , '-'                                              AS ACTION_FLAG_DIV
                             , 0                                                AS ROW_COLOR_INDEX
                             , 1                                                AS SORT_ORDER
--                             , NVL((SELECT COUNT(X.PLANT_SITE_ID)   --  2026.10.06 AJS
                             , NVL((SELECT /*+ INDEX(Y IX01_SCM_LINE_M) */ COUNT(X.PLANT_SITE_ID)   --  2026.10.06 AJS
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
                                            , X.PLANT_SITE_ID), 0)              AS TACT_CNT
                             , NVL((SELECT COUNT(X.PLANT_SITE_ID)
                                      FROM SCP_MST_OUTSOURCING_CAPA X
                                     WHERE X.ITEM_ID       = A.ITEM_ID
                                       AND X.VALID_YN      = 'Y'
                                       AND X.PLANT_SITE_ID = B.SCM_SITE_ID
                                       AND (TRIM(V_DIVISION_ID) IS NULL OR X.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
                                     GROUP BY X.PLANT_SITE_ID
                                            , X.ITEM_ID), 0)                    AS OUT_CAPA_CNT
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
                                            , X.ITEM_ID), 0)                    AS OUT_TACT_CNT
                             , NVL(B.OSP_YN, 'N')                               AS OSP_YN
                             , NVL(B.ATTRIBUTE1, 'N')                           AS ATTRIBUTE1
                          FROM SCM_MST_SITE_ITEM_PRIORITY A
                             , SCM_MST_SITE B
                             , SCM_ADM_LOOKUP_MASTER C
                             , SCM_ADM_LOOKUP_MASTER_DETAIL D
                         WHERE ((A.DIVISION_ID = B.DIVISION_ID AND B.OPERATION_GROUP <> 'E') OR B.OPERATION_GROUP = 'E')
                           AND A.PLANT_SITE_ID = B.SCM_SITE_ID
                           AND C.LOOKUP_TYPE   = 'OPERATION_GROUP'
                           AND C.VALID_YN      = 'Y'
                           AND D.LOOKUP_TYPE   = C.LOOKUP_TYPE
                           AND D.VALID_YN      = 'Y'
                           AND D.SEGMENT1      = B.OPERATION_GROUP
                           AND B.SITE_TYPE     = 'PLANT'
                           AND (TRIM(V_DIVISION_ID) IS NULL OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_DIVISION_ID, ','))))
                           AND (TRIM(V_PLANT_SITE) IS NULL OR A.PLANT_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_PLANT_SITE, ','))))
                           AND (TRIM(V_ITEM_ID) IS NULL OR A.ITEM_ID LIKE '%' || V_ITEM_ID || '%')
                           AND (TRIM(V_OPERATION_GROUP) IS NULL OR B.OPERATION_GROUP IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(V_OPERATION_GROUP, ','))))
                           AND (TRIM(V_VALID_FLAG) IS NULL OR A.VALID_YN = V_VALID_FLAG)
                       ) IA
               )
         GROUP BY PRIORITY_SEQ
                , DIVISION_ID
                , PROJECT_CODE
                , ITEM_ID
                , SCM_SITE_ID
                , PLANT_SITE_ID_B
                , PLANT_SITE_ID
                , TACT_TIME_FLAG
                , PRIORITY
                , VALID_YN
                , ORG_VALID_YN
                , FROM_YYYYMMDD
                , TO_YYYYMMDD
                , CREATED_BY
                , CREATION_DATE
                , LAST_UPDATED_BY
                , LAST_UPDATE_DATE
                , OPERATION_GROUP
                , ORG_FROM_YYYYMMDD
                , ORG_TO_YYYYMMDD
                , MERGE_DATE
                , IS_PASS_N1
                , IS_PASS_N2
                , IS_PASS_N3
                , IS_PASS_N4
                , IS_PASS_N5
                , IS_PASS_N6
                , IS_PASS_N7
                , NICK_NAME
                , OPERATION_GROUP_NAME
                , ACTION_FLAG_DIV
                , ROW_COLOR_INDEX
                , SORT_ORDER
         ORDER BY SORT_ORDER
                , NLSSORT(DIVISION_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST
                , NLSSORT(ITEM_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST
                , FROM_YYYYMMDD NULLS FIRST
                , PRIORITY NULLS FIRST
                , VALID_YN DESC NULLS LAST
                , TO_YYYYMMDD NULLS FIRST;

    /* 2. 전체조회 */
    OPEN O_ALL_LIST FOR
        SELECT TO_CHAR(A.PRIORITY_SEQ)                                          AS PRIORITY_SEQ
             , A.DIVISION_ID
             , NVL(A.PROJECT_CODE, '-')                                         AS PROJECT_CODE
             , A.ITEM_ID
             , NVL(A.SALES_SITE_ID, '-')                                        AS SCM_SITE_ID
             , A.PLANT_SITE_ID
             , A.PRIORITY
             , A.VALID_YN
             , A.VALID_YN                                                       AS ORG_VALID_YN
             /* ★원장에 달력에 없는 날짜가 섞여 있어 바꿀 수 없으면 원래 값을 그대로 보여준다 */
             , NVL(TO_CHAR(TO_DATE(A.FROM_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.FROM_YYYYMMDD) AS FROM_YYYYMMDD
             , NVL(TO_CHAR(TO_DATE(A.TO_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD'), 'YYYY-MM-DD'), A.TO_YYYYMMDD)     AS TO_YYYYMMDD
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , B.OPERATION_GROUP
             , A.FROM_YYYYMMDD                                                  AS ORG_FROM_YYYYMMDD
             , A.TO_YYYYMMDD                                                    AS ORG_TO_YYYYMMDD
             , A.FROM_YYYYMMDD || A.TO_YYYYMMDD                                 AS MERGE_DATE
             , ''                                                               AS IS_PASS_N1
             , ''                                                               AS IS_PASS_N2
             , ''                                                               AS IS_PASS_N3
             , ''                                                               AS IS_PASS_N4
             , ''                                                               AS IS_PASS_N5
             , ''                                                               AS IS_PASS_N6
             , ''                                                               AS IS_PASS_N7
             , '-'                                                              AS ACTION_FLAG_DIV
             , 0                                                                AS ROW_COLOR_INDEX
          FROM SCM_MST_SITE_ITEM_PRIORITY A
             , SCM_MST_SITE B
         WHERE ((A.DIVISION_ID = B.DIVISION_ID AND B.OPERATION_GROUP <> 'E') OR B.OPERATION_GROUP = 'E')
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
        SELECT IA.ITEM_ID
             , IA.NICK_NAME
          FROM (SELECT A.ITEM_ID
                     , A.NICK_NAME
                     , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID, A.NICK_NAME ORDER BY A.NICK_NAME ASC) AS NUMS
                  FROM SCP_MST_FINAL_ITEM A
                 WHERE A.OPERATION_GROUP = 'E'
                 GROUP BY A.ITEM_ID
                        , A.NICK_NAME
               ) IA
         WHERE IA.NUMS = 1
         /* AS-IS 에는 정렬이 없어 화면에서 순서가 흔들린다 — 품목 순으로 고정한다 */
         ORDER BY NLSSORT(IA.ITEM_ID, 'NLS_SORT=BINARY_CI') NULLS FIRST;

    O_RESULT_CODE := '0';
    O_RESULT_MSG  := 'SUCCESS';

END P_SCP0027_GET_PROJECTROUTE_ELECTRODE;

/****************************************************************************************************/
/* Program ID  : P_SCP0027_SAVE_PROJECTROUTE_ELECTRODE                                              */
/* Description : Project Route Plant Site 등록,수정                                                 */
/****************************************************************************************************/
PROCEDURE P_SCP0027_SAVE_PROJECTROUTE_ELECTRODE
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
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SCP0027_SAVE_PROJECTROUTE_ELECTRODE';

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

    /* 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 */
    V_LINK_PLANT_SITE_ID    VARCHAR2(4000 CHAR);
    V_LINK_DIVISION_ID      VARCHAR2(4000 CHAR);
    V_LINK_CP_PRIORITY_SEQ  NUMBER(19);

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

        /* 2025/10/31 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 — JV 동기화 시작 */
        V_LINK_PLANT_SITE_ID   := NULL;
        V_LINK_DIVISION_ID     := NULL;
        V_LINK_CP_PRIORITY_SEQ := NULL;

        BEGIN
            SELECT DIVISION_ID
                 , SCM_SITE_ID
              INTO V_LINK_DIVISION_ID
                 , V_LINK_PLANT_SITE_ID
              FROM (SELECT B.DIVISION_ID
                         , B.SCM_SITE_ID
                      FROM SCM_MST_SITE A
                         , SCM_MST_SITE B
                     WHERE B.SCM_SITE_ID = A.ATTRIBUTE9
                       AND A.SCM_SITE_ID = V_PLANT_SITE_ID
                       AND A.DIVISION_ID = V_DIVISION_ID
                   )
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_LINK_DIVISION_ID   := NULL;
                V_LINK_PLANT_SITE_ID := NULL;
        END;

        IF V_LINK_DIVISION_ID IS NOT NULL AND V_LINK_PLANT_SITE_ID IS NOT NULL
        THEN
            UPDATE SCM_MST_SITE_ITEM
               SET LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE  = SYSDATE
             WHERE DIVISION_ID  = V_LINK_DIVISION_ID
               AND PROJECT_CODE = V_PROJECT_CODE
               AND SCM_SITE_ID  = V_LINK_PLANT_SITE_ID
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
                              V_LINK_DIVISION_ID, V_PROJECT_CODE, V_LINK_PLANT_SITE_ID, V_ITEM_ID
                            , NULL, NULL, NULL, NULL
                            , 'Y', 'Y'
                            , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                            );
            END IF;

            /* SCM_MST_SITE_ITEM_PRIORITY 입력/수정 */
            BEGIN
                SELECT PRIORITY_SEQ
                  INTO V_LINK_CP_PRIORITY_SEQ
                  FROM (SELECT PRIORITY_SEQ
                          FROM SCM_MST_SITE_ITEM_PRIORITY
                         WHERE DIVISION_ID    = V_LINK_DIVISION_ID
                           AND PROJECT_CODE   = V_PROJECT_CODE
                           AND SALES_SITE_ID  = V_SCM_SITE_ID
                           AND PLANT_SITE_ID  = V_LINK_PLANT_SITE_ID
                           AND ITEM_ID        = V_ITEM_ID
                           AND FROM_YYYYMMDD <= V_TO_YYYYMMDD
                           AND TO_YYYYMMDD   >= V_FROM_YYYYMMDD
                       )
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN V_LINK_CP_PRIORITY_SEQ := NULL;
            END;

            IF V_LINK_CP_PRIORITY_SEQ IS NOT NULL
            THEN
                UPDATE SCM_MST_SITE_ITEM_PRIORITY
                   SET SALES_SITE_ID     = V_SCM_SITE_ID
                     , PRIORITY          = V_PRIORITY
                     , FROM_YYYYMMDD     = V_FROM_YYYYMMDD
                     , TO_YYYYMMDD       = V_TO_YYYYMMDD
                     , VALID_YN          = V_VALID_YN
                     , LAST_UPDATED_BY   = V_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE  = SYSDATE
                 WHERE PRIORITY_SEQ = V_LINK_CP_PRIORITY_SEQ;
            ELSE
                V_LINK_CP_PRIORITY_SEQ := SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL;

                INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                            (
                              PRIORITY_SEQ, DIVISION_ID, PROJECT_CODE, SALES_SITE_ID, PLANT_SITE_ID, ITEM_ID
                            , PRIORITY, FROM_YYYYMMDD, TO_YYYYMMDD, VALID_YN
                            , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                            )
                VALUES      (
                              V_LINK_CP_PRIORITY_SEQ, V_LINK_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_LINK_PLANT_SITE_ID, V_ITEM_ID
                            , V_PRIORITY, V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_VALID_YN
                            , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                            );
            END IF;

            PR_SCM_MST_SITE_ITEM_HIST(V_LINK_DIVISION_ID, V_PROJECT_CODE, V_LINK_PLANT_SITE_ID, V_ITEM_ID
                                    , V_CURRENCY, V_LIABILITY_PERIOD, V_SALES_PLAN_ADJUST_YN, V_ITEM_HRCY_ID
                                    , V_S_VALID_YN, V_BPMS_EXIST, V_CREATED_BY, TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS'), V_LAST_UPDATED_BY);

            PR_SCM_MST_SITE_ITEM_PRIORITY_HIST(TO_CHAR(V_LINK_CP_PRIORITY_SEQ), V_LINK_DIVISION_ID, V_PROJECT_CODE
                                             , V_SCM_SITE_ID, V_LINK_PLANT_SITE_ID, V_ITEM_ID, V_PRIORITY
                                             , V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_VALID_YN
                                             , V_CREATED_BY, TO_CHAR(V_CREATION_DATE, 'YYYY-MM-DD HH24:MI:SS'), V_LAST_UPDATED_BY);

        END IF;
        /* JV 동기화 끝 */

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

END P_SCP0027_SAVE_PROJECTROUTE_ELECTRODE;

END PKG_SCP0027;