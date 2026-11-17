PACKAGE BODY PKG_SCP0111
IS
/*
 * Program ID   : PKG_SCP0111
 * Description  : SCP0111 화면 (Integration PSI)
 * Program History
 *===========================================================================================================
 *   Date       Description
 *===========================================================================================================
 * 2026.09.23   MSSQL(SCP0111_* 4개) -> Oracle 패키지 전환
 * 2026.10.06   AJS          P_SCP0111_GET_INTEGRATION_PSI 조회 속도 개선(UOM 하위질의 IA 통합 · 복수조건 INSTR 비교 · 해시 조인 고정)
 * 2026.10.19   AJS          조회조건 Model/Nickname : 쉼표 여러 값 중 하나라도 코드 또는 닉네임 부분일치 · 대소문자 무시 · ALL 은 조건 없음
 * 2026.11.04   AJS          동적 SQL 문자열 안의 주석 제거(변경 표시 · 옛 문장). 실행 문장 동일
 */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    C_DELIMITER CONSTANT VARCHAR2(1 CHAR) := '^';

    /*==================================================================================================
     * 내부 : '^' 구분 CLOB 을 토큰 배열로 나눔
     *        AS-IS SCM_ARR_SPL_CNT(토큰 수 = 구분자 수 + 1) ·
     *        SCM_ARR_SPL_VAL(토큰 앞뒤 공백 제거) 과 같은 결과
     *==================================================================================================*/
    PROCEDURE P_SPLIT
    (
        P_TEXT   IN  CLOB,
        P_DELIM  IN  VARCHAR2,
        O_TAB    OUT T_TOKEN_TAB,
        O_CNT    OUT PLS_INTEGER
    )
    IS
        V_LEN   PLS_INTEGER;
        V_POS   PLS_INTEGER := 1;
        V_NEXT  PLS_INTEGER;
    BEGIN
        O_CNT := 0;

        IF P_TEXT IS NULL OR DBMS_LOB.GETLENGTH(P_TEXT) = 0 THEN
            O_CNT    := 1;
            O_TAB(1) := NULL;
            RETURN;
        END IF;

        V_LEN := DBMS_LOB.GETLENGTH(P_TEXT);

        LOOP
            V_NEXT := DBMS_LOB.INSTR(P_TEXT, P_DELIM, V_POS, 1);
            O_CNT  := O_CNT + 1;

            IF V_NEXT = 0 THEN
                O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_LEN - V_POS + 1, V_POS));
                EXIT;
            END IF;

            IF V_NEXT = V_POS THEN
                O_TAB(O_CNT) := NULL;
            ELSE
                O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_NEXT - V_POS, V_POS));
            END IF;

            V_POS := V_NEXT + 1;

            IF V_POS > V_LEN THEN
                O_CNT        := O_CNT + 1;
                O_TAB(O_CNT) := NULL;
                EXIT;
            END IF;
        END LOOP;
    END P_SPLIT;

    /*==================================================================================================
     * 내부 : 배열에서 인덱스 토큰을 꺼냄 (없는 인덱스는 NULL - AS-IS SCM_ARR_SPL_VAL 과 같음)
     *==================================================================================================*/
    FUNCTION F_TOKEN
    (
        P_TAB  IN T_TOKEN_TAB,
        P_IDX  IN PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX) THEN
            RETURN P_TAB(P_IDX);
        END IF;
        RETURN NULL;
    END F_TOKEN;

    /*==================================================================================================
     * 내부 : 처리 로그 기록 (AS-IS EXEC PR_SCM_SYS_LOG_BATCH 와 같음)
     *==================================================================================================*/
    PROCEDURE P_WRITE_LOG
    (
        P_PROGRAM_NAME IN VARCHAR2,
        P_LOG_TYPE     IN VARCHAR2,
        P_LOG_COUNT    IN NUMBER,
        P_LOG_MESSAGE  IN VARCHAR2
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME, P_LOG_TYPE, P_LOG_COUNT, P_LOG_MESSAGE, '', SYSDATE, NULL, NULL, NULL, NULL);
    END P_WRITE_LOG;

    /*==================================================================================================
     * 내부 : 오류 로그 기록 (AS-IS CATCH 의 scm_sys_log_batch INSERT 와 같음)
     *==================================================================================================*/
    PROCEDURE P_WRITE_ERROR_LOG
    (
        P_PROGRAM_NAME IN VARCHAR2,
        P_MESSAGE      IN VARCHAR2
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO SCM_SYS_LOG_BATCH
             ( PROGRAM_NAME
             , LOG_TYPE
             , LOG_COUNT
             , LOG_MESSAGE
             , DESCRIPTION
             , EVENT_DATE
             , CREATION_DATE
             , CREATED_BY
             , LAST_UPDATE_DATE
             , LAST_UPDATED_BY )
        VALUES
             ( P_PROGRAM_NAME
             , 'ERROR'
             , NULL
             , P_MESSAGE
             , NULL
             , SYSDATE
             , SYSDATE
             , P_PROGRAM_NAME
             , SYSDATE
             , P_PROGRAM_NAME );
        COMMIT;
    END P_WRITE_ERROR_LOG;

    /*==================================================================================================
     * ESS 팩 Prod plan Insert 시 Line 정보 표시용
     *   AS-IS : SCP0111_GET_ESS_PACK_LINE
     *==================================================================================================*/
    PROCEDURE P_SCP0111_GET_ESS_PACK_LINE
    (
        O_RC                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
    BEGIN

        OPEN O_RC FOR
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , B.SITE_DESCRIPTION
             , B.COMPANY_ID
             , A.LINE_ID                AS CODE
             , A.LINE_NAME              AS NAME
             , A.OPERATION_ID
          FROM SCM_MST_LINE_OSP A
             , SCM_MST_SITE     B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND A.DIVISION_ID = '82'
           AND A.VALID_YN    = 'Y'
         ORDER BY A.DIVISION_ID
                , UPPER(TRANSLATE(A.SCM_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(A.SCM_SITE_ID)
                , UPPER(TRANSLATE(A.LINE_ID, '_-', '/')) NULLS FIRST
                , UPPER(A.LINE_ID);

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'       AS CODE
             , 'SUCCESS' AS MSG
             , 0         AS EVENT
             , 'S'       AS RESULT_CODE
             , 0         AS RESULT_CNT
          FROM DUAL;

    END P_SCP0111_GET_ESS_PACK_LINE;

    /*==================================================================================================
     * Integration PSI 조회 (월별 PIVOT)
     *   AS-IS : SCP0111_GET_INTEGRATION_PSI
     *   월 컬럼이 조회 기간에 따라 달라지므로 결과 커서만 동적 SQL 로 연다(값은 전부 바인드 변수)
     *==================================================================================================*/
    PROCEDURE P_SCP0111_GET_INTEGRATION_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_FROM_YYYYMM           IN  VARCHAR2,
        P_TO_YYYYMM             IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_CELLITEM_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_QTY_YN                IN  VARCHAR2,
        O_RC                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_DIVISION_ID   VARCHAR2(4000 CHAR)  := UPPER(RTRIM(P_DIVISION_ID));
        V_PLAN_START    VARCHAR2(4000 CHAR)  := UPPER(RTRIM(P_PLAN_START_YYYYMMDD));
        V_FROM_YYYYMM   VARCHAR2(4000 CHAR)  := UPPER(RTRIM(P_FROM_YYYYMM));
        V_TO_YYYYMM     VARCHAR2(4000 CHAR)  := UPPER(RTRIM(P_TO_YYYYMM));
        V_NICK_NAME     VARCHAR2(4000 CHAR)  := UPPER(P_NICK_NAME);
        V_CELLITEM_ID   VARCHAR2(4000 CHAR)  := UPPER(P_CELLITEM_ID);
        V_ITEM_ID       VARCHAR2(4000 CHAR)  := UPPER(P_ITEM_ID);
        V_NICK_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_NICK_NAME)   IS NULL THEN 'N' ELSE 'Y' END;
        V_CELL_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_CELLITEM_ID) IS NULL THEN 'N' ELSE 'Y' END;
        /* 2026.10.19 AJS Model/Nickname ALL 은 조건 없음 (START) */
/*        V_ITEM_YN       VARCHAR2(1 CHAR)     := CASE WHEN RTRIM(P_ITEM_ID)     IS NULL THEN 'N' ELSE 'Y' END; */
        V_ITEM_YN       VARCHAR2(1 CHAR)     := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN 'N' ELSE 'Y' END;
        /* 2026.10.19 AJS Model/Nickname ALL 은 조건 없음 (END) */
        V_QTY_YN        VARCHAR2(1 CHAR)     := UPPER(RTRIM(P_QTY_YN));
        V_COLUMNS       VARCHAR2(32767 CHAR) := '';
        V_SQL           CLOB;
        V_INNER         CLOB;
        V_ORDERBY       CLOB;
    BEGIN

        /* GROUP 조회 - 피벗 대상 월 목록 */
        /* AS-IS 의 SCP_MST_FINAL_ITEM LEFT JOIN 은 사용 칸이 없고 조건이 모두 주석이라 결과에 영향 없음 - 조인 생략 */
        FOR C IN ( SELECT DISTINCT SUBSTR(YYYYMM, 1, 6) AS YYYYMM
                     FROM SCP_ANL_PSI_INTEGRATION
                    WHERE DIVISION_ID         = V_DIVISION_ID
                      AND PLAN_START_YYYYMMDD = V_PLAN_START
                      AND YYYYMM BETWEEN V_FROM_YYYYMM AND V_TO_YYYYMM
                    ORDER BY YYYYMM )
        LOOP
            V_COLUMNS := V_COLUMNS || '''' || C.YYYYMM || ''' AS "' || C.YYYYMM || '",';
        END LOOP;

        IF LENGTH(V_COLUMNS) > 0
        THEN

            V_COLUMNS := SUBSTR(V_COLUMNS, 1, LENGTH(V_COLUMNS) - 1);

            /* 피벗 대상 원본 - AS-IS 동적 SQL 본문과 같은 컬럼·조인·조건 */
            V_INNER := '
            SELECT /*+ LEADING(A) USE_HASH(IA XA F G H C D) NO_PUSH_PRED(IA) NO_PUSH_PRED(XA) */ A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , NVL(G.SITE_DESCRIPTION, A.PLANT_ID)  AS PLANT_ID_DESCRIPTION
                 , C.SEGMENT2                           AS OPERATION_GROUP
                 , NVL(XA.NICK_NAME, ''-'')             AS CELL_MODEL_NICK_NAME
                 , F.CELL_CF
                 , A.INCOTERMS
                 , IA.NICK_NAME
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.MEASURE
                 , D.COLUMN_LABEL_NAME                  AS MEASURE_LABEL
                 , A.VALUE_TYPE
                 , A.TO_PRODUCT
                 , A.LINE_ID
                 , TRUNC(A.BOH_QTY)                     AS BOH_QTY
                 , A.TO_SITE
                 , NVL(H.SITE_DESCRIPTION, A.TO_SITE)   AS TO_SITE_DESCRIPTION
                 , IA.ITEM_UOM                          AS UOM
                 , A.QTY
                 , SUBSTR(A.YYYYMM, 1, 8)               AS YYYYMM
                 , A.SEQ_FLAG
                 , A.ATTRIBUTE2                         AS PLAN_TYPE
              FROM SCP_ANL_PSI_INTEGRATION          A
                 , (SELECT /*+ FULL(SCM_MST_ITEM_SN) */ DIVISION_ID
                         , UPPER(ITEM_ID) AS ITEM_ID
                         , MAX(NICK_NAME) AS NICK_NAME
                         , MAX(ITEM_UOM)  AS ITEM_UOM
                      FROM SCM_MST_ITEM_SN
                     GROUP BY DIVISION_ID, UPPER(ITEM_ID))  IA
                 , SCM_ADM_LOOKUP_MASTER_DETAIL      C
                 , SCM_MST_SHEET_MEASURE             D
                 , (SELECT /*+ FULL(SCM_MST_ITEM_SN) */ DIVISION_ID
                         , UPPER(ITEM_ID) AS ITEM_ID
                         , MAX(NICK_NAME) AS NICK_NAME
                      FROM SCM_MST_ITEM_SN
                     GROUP BY DIVISION_ID, UPPER(ITEM_ID))  XA
                 , SCP_MST_ITEM_CELL_CF              F
                 , SCM_MST_SITE                      G
                 , SCM_MST_SITE                      H
             WHERE IA.DIVISION_ID(+) = A.DIVISION_ID
               AND IA.ITEM_ID(+)     = UPPER(A.ITEM_ID)
               AND C.LOOKUP_TYPE(+)  = ''OPERATION_GROUP''
               AND C.SEGMENT1(+)     = A.OPERATION_GROUP
               AND D.PROGRAM_ID(+)   = ''SCP0111''
               AND D.COLUMN_NAME(+)  = A.MEASURE
               AND XA.DIVISION_ID(+) = A.DIVISION_ID
               AND XA.ITEM_ID(+)     = UPPER(A.CELL_ITEM_ID)
               AND F.ITEM_ID(+)      = UPPER(A.ITEM_ID)
               AND G.DIVISION_ID(+)  = A.DIVISION_ID
               AND G.PLANT_ID(+)     = A.PLANT_ID
               AND G.OSP_YN(+)       = ''Y''
               AND G.VALID_YN(+)     = ''Y''
               AND H.DIVISION_ID(+)  = A.DIVISION_ID
               AND H.PLANT_ID(+)     = UPPER(A.TO_SITE)
               AND H.OSP_YN(+)       = ''Y''
               AND H.VALID_YN(+)     = ''Y''
               AND A.DIVISION_ID         = :B_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = :B_PLAN_START
               AND A.YYYYMM BETWEEN :B_FROM_YYYYMM AND :B_TO_YYYYMM
               AND (:B_NICK_YN = ''N''
                    OR (INSTR('','' || REGEXP_REPLACE(TRIM(UPPER(:B_NICK_NAME)), '' *, *'', '','') || '','', '','' || UPPER(IA.NICK_NAME) || '','') > 0
                        AND INSTR(IA.NICK_NAME, '','') = 0))
               AND (:B_CELL_YN = ''N''
                    OR UPPER(A.CELL_ITEM_ID) LIKE ''%'' || :B_CELLITEM_ID || ''%'')
               AND (:B_ITEM_YN = ''N''
                    OR EXISTS (SELECT 1
                                 FROM TABLE(STRING_SPLIT(:B_ITEM_ID, '','')) SB
                                WHERE TRIM(SB.COLUMN_VALUE) IS NOT NULL
                                  AND (   UPPER(A.ITEM_ID)    LIKE ''%'' || TRIM(SB.COLUMN_VALUE) || ''%''
                                       OR UPPER(IA.NICK_NAME) LIKE ''%'' || TRIM(SB.COLUMN_VALUE) || ''%'')))
';
--               AND (:B_ITEM_YN = ''N''
--                    OR UPPER(A.ITEM_ID) IN (SELECT UPPER(SC.COLUMN_VALUE)
--                                              FROM TABLE(STRING_SPLIT(:B_ITEM_ID, '','')) SC))';
               -- 2026.10.06 AJS 품목 복수조건 STRING_SPLIT 하위질의를 INSTR 비교로 변경 (END)

            /* 자동차 사업부(81)에 대해서 MKT FCST Measure 는 조회 안되도록 */
            IF V_DIVISION_ID = '81'
            THEN
                V_INNER := V_INNER || '
               AND A.MEASURE <> ''MKT_FCST''';
            END IF;

            /* AS-IS 정렬규칙(대소문자 무시 · 하이픈/밑줄 무시)을 UPPER(TRANSLATE(..)) 1차 키로 재현 ·
               MSSQL 오름차순 NULL 앞을 NULLS FIRST 로 재현 */
            IF V_DIVISION_ID = '82'
            THEN
                V_ORDERBY := '
 ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END)
        , (CASE WHEN CELL_ITEM_ID IS NULL THEN 1 ELSE 0 END)
        , UPPER(TRANSLATE(CELL_ITEM_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(CELL_ITEM_ID)
        , (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END)
        , UPPER(TRANSLATE(NICK_NAME, ''_-'', ''/'')) NULLS FIRST
        , UPPER(NICK_NAME)
        , SUBSTR(SEQ_FLAG, 1, 1) NULLS FIRST
        , UPPER(TRANSLATE(ITEM_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(ITEM_ID)
        , UPPER(TRANSLATE(COMPANY_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(COMPANY_ID)
        , UPPER(TRANSLATE(PLANT_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(PLANT_ID)
        , (CASE WHEN MEASURE <> ''INV'' THEN SUBSTR(SEQ_FLAG, 2, 1) ELSE ''6'' END) NULLS FIRST
        , UPPER(TRANSLATE(TO_PRODUCT, ''_-'', ''/'')) NULLS FIRST
        , UPPER(TO_PRODUCT)
        , UPPER(TRANSLATE(VALUE_TYPE, ''_-'', ''/'')) NULLS FIRST
        , UPPER(VALUE_TYPE)
        , UPPER(TRANSLATE(LINE_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(LINE_ID)
        , UPPER(TRANSLATE(TO_SITE, ''_-'', ''/'')) NULLS FIRST
        , UPPER(TO_SITE)
        , UPPER(TRANSLATE(INCOTERMS, ''_-'', ''/'')) NULLS FIRST
        , UPPER(INCOTERMS)';
            ELSIF V_DIVISION_ID = '40'
            THEN
                V_ORDERBY := '
 ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END)
        , (CASE WHEN CELL_ITEM_ID IS NULL THEN 1 ELSE 0 END)
        , UPPER(TRANSLATE(CELL_ITEM_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(CELL_ITEM_ID)
        , (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END)
        , UPPER(TRANSLATE(NICK_NAME, ''_-'', ''/'')) NULLS FIRST
        , UPPER(NICK_NAME)
        , UPPER(TRANSLATE(COMPANY_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(COMPANY_ID)
        , UPPER(TRANSLATE(PLANT_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(PLANT_ID)
        , (CASE WHEN SUBSTR(SEQ_FLAG, 1, 1) = ''1'' THEN 1
                WHEN SUBSTR(SEQ_FLAG, 1, 1) = ''2'' THEN 2
                WHEN SUBSTR(SEQ_FLAG, 1, 1) = ''6'' THEN 3
                WHEN SUBSTR(SEQ_FLAG, 1, 1) = ''7'' THEN 4
                WHEN SUBSTR(SEQ_FLAG, 1, 1) = ''3'' THEN 5
                WHEN SUBSTR(SEQ_FLAG, 1, 1) = ''4'' THEN 6
                ELSE 7 END)
        , UPPER(TRANSLATE(ITEM_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(ITEM_ID)
        , SUBSTR(SEQ_FLAG, 2, 1) NULLS FIRST
        , UPPER(TRANSLATE(TO_PRODUCT, ''_-'', ''/'')) NULLS FIRST
        , UPPER(TO_PRODUCT)
        , UPPER(TRANSLATE(VALUE_TYPE, ''_-'', ''/'')) NULLS FIRST
        , UPPER(VALUE_TYPE)
        , UPPER(TRANSLATE(LINE_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(LINE_ID)
        , UPPER(TRANSLATE(TO_SITE, ''_-'', ''/'')) NULLS FIRST
        , UPPER(TO_SITE)
        , UPPER(TRANSLATE(INCOTERMS, ''_-'', ''/'')) NULLS FIRST
        , UPPER(INCOTERMS)';
            ELSE
                V_ORDERBY := '
 ORDER BY (CASE WHEN OPERATION_GROUP = ''Electrode'' THEN 99 ELSE 1 END)
        , (CASE WHEN CELL_ITEM_ID IS NULL THEN 1 ELSE 0 END)
        , UPPER(TRANSLATE(CELL_ITEM_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(CELL_ITEM_ID)
        , (CASE WHEN OPERATION_GROUP = ''Cell'' THEN 99 ELSE 1 END)
        , UPPER(TRANSLATE(NICK_NAME, ''_-'', ''/'')) NULLS FIRST
        , UPPER(NICK_NAME)
        , UPPER(TRANSLATE(COMPANY_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(COMPANY_ID)
        , UPPER(TRANSLATE(PLANT_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(PLANT_ID)
        , SUBSTR(SEQ_FLAG, 1, 1) NULLS FIRST
        , UPPER(TRANSLATE(ITEM_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(ITEM_ID)
        , SUBSTR(SEQ_FLAG, 2, 1) NULLS FIRST
        , UPPER(TRANSLATE(TO_PRODUCT, ''_-'', ''/'')) NULLS FIRST
        , UPPER(TO_PRODUCT)
        , UPPER(TRANSLATE(VALUE_TYPE, ''_-'', ''/'')) NULLS FIRST
        , UPPER(VALUE_TYPE)
        , UPPER(TRANSLATE(LINE_ID, ''_-'', ''/'')) NULLS FIRST
        , UPPER(LINE_ID)
        , UPPER(TRANSLATE(TO_SITE, ''_-'', ''/'')) NULLS FIRST
        , UPPER(TO_SITE)
        , UPPER(TRANSLATE(INCOTERMS, ''_-'', ''/'')) NULLS FIRST
        , UPPER(INCOTERMS)';
            END IF;

            IF V_QTY_YN = 'Y'
            THEN

                /* 월별 음수 수량이 있는 Item 만 조회 */
                V_SQL := 'SELECT *
  FROM (SELECT *
          FROM (' || V_INNER || ') XB
         PIVOT (SUM(QTY) FOR YYYYMM IN (' || V_COLUMNS || '))) XC
 WHERE UPPER(XC.ITEM_ID) IN (SELECT DISTINCT UPPER(A.ITEM_ID)
                               FROM SCP_ANL_PSI_INTEGRATION A
                                  , (SELECT DIVISION_ID
                                          , UPPER(ITEM_ID) AS ITEM_ID
                                          , MAX(NICK_NAME) AS NICK_NAME
                                       FROM SCM_MST_ITEM_SN
                                      GROUP BY DIVISION_ID, UPPER(ITEM_ID))  IA
                              WHERE IA.DIVISION_ID(+) = A.DIVISION_ID
                                AND IA.ITEM_ID(+)     = UPPER(A.ITEM_ID)
                                AND A.DIVISION_ID         = :C_DIVISION_ID
                                AND A.PLAN_START_YYYYMMDD = :C_PLAN_START
                                AND A.YYYYMM BETWEEN :C_FROM_YYYYMM AND :C_TO_YYYYMM
                                AND (:C_NICK_YN = ''N''
                                     OR UPPER(IA.NICK_NAME) IN (SELECT UPPER(SD.COLUMN_VALUE)
                                                                  FROM TABLE(STRING_SPLIT(:C_NICK_NAME, '','')) SD))
                                AND (:C_CELL_YN = ''N''
                                     OR UPPER(A.CELL_ITEM_ID) LIKE ''%'' || :C_CELLITEM_ID || ''%'')
                                AND (:C_ITEM_YN = ''N''
                                     OR EXISTS (SELECT 1
                                                  FROM TABLE(STRING_SPLIT(:C_ITEM_ID, '','')) SE
                                                 WHERE TRIM(SE.COLUMN_VALUE) IS NOT NULL
                                                   AND (   UPPER(A.ITEM_ID)    LIKE ''%'' || TRIM(SE.COLUMN_VALUE) || ''%''
                                                        OR UPPER(IA.NICK_NAME) LIKE ''%'' || TRIM(SE.COLUMN_VALUE) || ''%'')))
                                AND A.QTY < 0)' || V_ORDERBY;

                OPEN O_RC FOR V_SQL
                USING V_DIVISION_ID, V_PLAN_START, V_FROM_YYYYMM, V_TO_YYYYMM
                    , V_NICK_YN, V_NICK_NAME
                    , V_CELL_YN, V_CELLITEM_ID
                    , V_ITEM_YN, V_ITEM_ID
                    , V_DIVISION_ID, V_PLAN_START, V_FROM_YYYYMM, V_TO_YYYYMM
                    , V_NICK_YN, V_NICK_NAME
                    , V_CELL_YN, V_CELLITEM_ID
                    , V_ITEM_YN, V_ITEM_ID;

            ELSE

                V_SQL := 'SELECT *
  FROM (' || V_INNER || ') XB
 PIVOT (SUM(QTY) FOR YYYYMM IN (' || V_COLUMNS || '))' || V_ORDERBY;

                OPEN O_RC FOR V_SQL
                USING V_DIVISION_ID, V_PLAN_START, V_FROM_YYYYMM, V_TO_YYYYMM
                    , V_NICK_YN, V_NICK_NAME
                    , V_CELL_YN, V_CELLITEM_ID
                    , V_ITEM_YN, V_ITEM_ID;

            END IF;

        ELSE

            /* 조회데이터가 없을 경우 */
            OPEN O_RC FOR
            SELECT *
              FROM SCP_ANL_PSI_INTEGRATION
             WHERE DIVISION_ID         = V_DIVISION_ID
               AND PLAN_START_YYYYMMDD = V_PLAN_START
               AND YYYYMM BETWEEN V_FROM_YYYYMM AND V_TO_YYYYMM;

        END IF;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'       AS CODE
             , 'SUCCESS' AS MSG
             , 0         AS EVENT
             , 'S'       AS RESULT_CODE
             , 0         AS RESULT_CNT
          FROM DUAL;

    END P_SCP0111_GET_INTEGRATION_PSI;

    /*==================================================================================================
     * 통합 PSI 의 월별 수량 수정 (일반 사용자)
     *   AS-IS : SCP0111_SAVE_INTEGRATION_PSI
     *==================================================================================================*/
    PROCEDURE P_SCP0111_SAVE_INTEGRATION_PSI
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_COMPANY_ID            IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_OPERATION_GROUP       IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_SEQ_FLAG              IN  CLOB,
        P_CELLITEM_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_TO_SITE               IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_VALUATION_TYPE        IN  CLOB,
        P_TO_PRODUCT            IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_YYYYMM                IN  CLOB,
        P_MODIQTY               IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'SCP0111_SAVE_INTEGRATION_PSI';

        T_ACTIVE_FLAG       T_TOKEN_TAB;
        T_PLAN_TYPE         T_TOKEN_TAB;
        T_DIVISION_ID       T_TOKEN_TAB;
        T_COMPANY_ID        T_TOKEN_TAB;
        T_PLANT_ID          T_TOKEN_TAB;
        T_OPERATION_GROUP   T_TOKEN_TAB;
        T_SEQ_FLAG          T_TOKEN_TAB;
        T_CELLITEM_ID       T_TOKEN_TAB;
        T_ITEM_ID           T_TOKEN_TAB;
        T_MEASURE           T_TOKEN_TAB;
        T_TO_SITE           T_TOKEN_TAB;
        T_LINE_ID           T_TOKEN_TAB;
        T_VALUATION_TYPE    T_TOKEN_TAB;
        T_TO_PRODUCT        T_TOKEN_TAB;
        T_INCOTERMS         T_TOKEN_TAB;
        T_YYYYMM            T_TOKEN_TAB;
        T_MODIQTY           T_TOKEN_TAB;

        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_PLAN_TYPE         VARCHAR2(4000 CHAR);
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_COMPANY_ID        VARCHAR2(4000 CHAR);
        V_PLANT_ID          VARCHAR2(4000 CHAR);
        V_OPERATION_GROUP   VARCHAR2(4000 CHAR);
        V_SEQ_FLAG          VARCHAR2(4000 CHAR);
        V_CELLITEM_ID       VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);
        V_MEASURE           VARCHAR2(4000 CHAR);
        V_TO_SITE           VARCHAR2(4000 CHAR);
        V_LINE_ID           VARCHAR2(4000 CHAR);
        V_VALUATION_TYPE    VARCHAR2(4000 CHAR);
        V_TO_PRODUCT        VARCHAR2(4000 CHAR);
        V_INCOTERMS         VARCHAR2(4000 CHAR);
        V_YYYYMM            VARCHAR2(4000 CHAR);
        V_MODIQTY           VARCHAR2(4000 CHAR);
        V_MODI_QTY          NUMBER;

        V_PLAN_START        VARCHAR2(4000 CHAR) := UPPER(RTRIM(P_PLAN_START_YYYYMMDD));
        V_LAST_UPDATED_BY   VARCHAR2(600 CHAR)  := P_USER_ID;

        /* NERP 전환 Company/Plant (룩업) */
        V_ESOC              VARCHAR2(100 CHAR);
        V_ESNJ              VARCHAR2(100 CHAR);
        V_ESNJ_PLANT        VARCHAR2(100 CHAR);

        V_MAX_LOOP_CNT      PLS_INTEGER := 0;
        V_MST_LOOP_CNT      PLS_INTEGER := 0;
        V_RECV_LEN          NUMBER      := 0;
        V_DUMMY_CNT         PLS_INTEGER;

        V_CNT               NUMBER      := 0;
        V_MEASURE_COUNT     NUMBER      := 0;
        V_MULTI_TO_PRODUCT      VARCHAR2(4000 CHAR);
        V_MULTI_CELL_ITEM_ID    VARCHAR2(4000 CHAR);
        V_ACCUMULATED_CHILD_QTY NUMBER;
        V_YIELD                 NUMBER;

        V_TMP_VALUATION_TYPE    VARCHAR2(4000 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        /* NERP 전환 plant 값 (AS-IS 와 같은 룩업) */
        V_ESOC       := FN_GET_LOOKUP_VALUE(C_PROGRAM_NAME, 'ESOC');
        V_ESNJ       := FN_GET_LOOKUP_VALUE(C_PROGRAM_NAME, 'ESNJ');
        V_ESNJ_PLANT := FN_GET_LOOKUP_VALUE(C_PROGRAM_NAME, 'ESNJ_PLANT');

        V_RECV_LEN := NVL(DBMS_LOB.GETLENGTH(RTRIM(P_ACTIVE_FLAG)), 0);

        /* 프로시저 LOOP 길이를 판단 */
        P_SPLIT(P_ACTIVE_FLAG     , C_DELIMITER, T_ACTIVE_FLAG    , V_MAX_LOOP_CNT);
        P_SPLIT(P_PLAN_TYPE       , C_DELIMITER, T_PLAN_TYPE      , V_DUMMY_CNT);
        P_SPLIT(P_DIVISION_ID     , C_DELIMITER, T_DIVISION_ID    , V_DUMMY_CNT);
        P_SPLIT(P_COMPANY_ID      , C_DELIMITER, T_COMPANY_ID     , V_DUMMY_CNT);
        P_SPLIT(P_PLANT_ID        , C_DELIMITER, T_PLANT_ID       , V_DUMMY_CNT);
        P_SPLIT(P_OPERATION_GROUP , C_DELIMITER, T_OPERATION_GROUP, V_DUMMY_CNT);
        P_SPLIT(P_SEQ_FLAG        , C_DELIMITER, T_SEQ_FLAG       , V_DUMMY_CNT);
        P_SPLIT(P_CELLITEM_ID     , C_DELIMITER, T_CELLITEM_ID    , V_DUMMY_CNT);
        P_SPLIT(P_ITEM_ID         , C_DELIMITER, T_ITEM_ID        , V_DUMMY_CNT);
        P_SPLIT(P_MEASURE         , C_DELIMITER, T_MEASURE        , V_DUMMY_CNT);
        P_SPLIT(P_TO_SITE         , C_DELIMITER, T_TO_SITE        , V_DUMMY_CNT);
        P_SPLIT(P_LINE_ID         , C_DELIMITER, T_LINE_ID        , V_DUMMY_CNT);
        P_SPLIT(P_VALUATION_TYPE  , C_DELIMITER, T_VALUATION_TYPE , V_DUMMY_CNT);
        P_SPLIT(P_TO_PRODUCT      , C_DELIMITER, T_TO_PRODUCT     , V_DUMMY_CNT);
        P_SPLIT(P_INCOTERMS       , C_DELIMITER, T_INCOTERMS      , V_DUMMY_CNT);
        P_SPLIT(P_YYYYMM          , C_DELIMITER, T_YYYYMM         , V_DUMMY_CNT);
        P_SPLIT(P_MODIQTY         , C_DELIMITER, T_MODIQTY        , V_DUMMY_CNT);

        /* 저장 시작 지점 - 오류 시 앞 행 저장분까지 되돌린다 */
        SAVEPOINT SP_SCP0111_SAVE;

        /* NERP 전환 plant 찾는 로직 (2025-02-18 mrchois)
           1순위 division, company, plant / 2순위 division, company, city, country
           3순위 division, company / 4순위 company */
        DELETE FROM GT_SCP0111_ELEC_PLANT;

        INSERT INTO GT_SCP0111_ELEC_PLANT
             ( COMPANY_ID
             , DIVISION_ID
             , CITY
             , COUNTRY
             , PLANT_ID
             , SITE_DESCRIPTION
             , SCM_SITE_ID
             , SITE_ID
             , PRIORITY_1ST
             , PRIORITY_2ND
             , PRIORITY_3RD
             , PRIORITY_4TH )
        SELECT COMPANY_ID
             , DIVISION_ID
             , NVL(CITY   , 'Z')
             , NVL(COUNTRY, 'Z')
             , PLANT_ID
             , SITE_DESCRIPTION
             , SCM_SITE_ID
             , SITE_ID
             , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID
                                             , DIVISION_ID
                                             , PLANT_ID
                                      ORDER BY PLANT_ID)
             , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID
                                             , DIVISION_ID
                                             , NVL(CITY   , 'Z')
                                             , NVL(COUNTRY, 'Z')
                                      ORDER BY PLANT_ID)
             , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID
                                             , DIVISION_ID
                                      ORDER BY PLANT_ID)
             , ROW_NUMBER() OVER (PARTITION BY COMPANY_ID
                                      ORDER BY PLANT_ID)
          FROM SCM_MST_SITE
         WHERE VALID_YN        = 'Y'
           AND OPERATION_GROUP = 'E'    /* 전극 Plant */
           AND SITE_TYPE       = 'PLANT';

        /* Cell/전극 plant 매핑 */
        DELETE FROM GT_SCP0111_CELL_ELEC_MAP;

        INSERT INTO GT_SCP0111_CELL_ELEC_MAP
             ( DIVISION_ID_CS
             , COMPANY_ID_CS
             , PLANT_ID_CS
             , CELL_PLANT_PRIORITY
             , PLANT_ID_ES
             , SITE_DESCRIPTION_ES )
        SELECT A.DIVISION_ID
             , A.COMPANY_ID
             , A.PLANT_ID
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.COMPANY_ID
                                             , A.PLANT_ID
                                      ORDER BY A.SCM_SITE_ID)
             , NVL(B.PLANT_ID, NVL(C.PLANT_ID, NVL(D.PLANT_ID, E.PLANT_ID)))
             , NVL(B.SITE_DESCRIPTION, NVL(C.SITE_DESCRIPTION, NVL(D.SITE_DESCRIPTION, E.SITE_DESCRIPTION)))
          FROM SCM_MST_SITE           A
             , GT_SCP0111_ELEC_PLANT  B
             , GT_SCP0111_ELEC_PLANT  C
             , GT_SCP0111_ELEC_PLANT  D
             , GT_SCP0111_ELEC_PLANT  E
         WHERE B.PRIORITY_1ST(+) = 1
           AND B.DIVISION_ID(+)  = A.DIVISION_ID
           AND B.COMPANY_ID(+)   = A.COMPANY_ID
           AND B.PLANT_ID(+)     = A.PLANT_ID
           AND C.PRIORITY_2ND(+) = 1
           AND C.DIVISION_ID(+)  = A.DIVISION_ID
           AND C.COMPANY_ID(+)   = A.COMPANY_ID
           AND C.CITY(+)         = NVL(A.CITY   , 'Z')
           AND C.COUNTRY(+)      = NVL(A.COUNTRY, 'Z')
           AND D.PRIORITY_3RD(+) = 1
           AND D.DIVISION_ID(+)  = A.DIVISION_ID
           AND D.COMPANY_ID(+)   = A.COMPANY_ID
           AND E.PRIORITY_4TH(+) = 1
           AND E.COMPANY_ID(+)   = A.COMPANY_ID
           AND A.VALID_YN        = 'Y'
           AND A.OPERATION_GROUP = 'A'    /* Cell Plant */
           AND A.SITE_TYPE       = 'PLANT'
           AND A.OSP_YN          = 'N';

        /* 시작 LOG */
        P_WRITE_LOG(C_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########');

        WHILE V_RECV_LEN > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 */
            V_ACTIVE_FLAG     := F_TOKEN(T_ACTIVE_FLAG    , V_MST_LOOP_CNT);
            V_PLAN_TYPE       := F_TOKEN(T_PLAN_TYPE      , V_MST_LOOP_CNT);
            V_DIVISION_ID     := F_TOKEN(T_DIVISION_ID    , V_MST_LOOP_CNT);
            V_COMPANY_ID      := F_TOKEN(T_COMPANY_ID     , V_MST_LOOP_CNT);
            V_PLANT_ID        := F_TOKEN(T_PLANT_ID       , V_MST_LOOP_CNT);
            V_OPERATION_GROUP := F_TOKEN(T_OPERATION_GROUP, V_MST_LOOP_CNT);
            V_SEQ_FLAG        := F_TOKEN(T_SEQ_FLAG       , V_MST_LOOP_CNT);
            V_CELLITEM_ID     := F_TOKEN(T_CELLITEM_ID    , V_MST_LOOP_CNT);
            V_ITEM_ID         := F_TOKEN(T_ITEM_ID        , V_MST_LOOP_CNT);
            V_MEASURE         := F_TOKEN(T_MEASURE        , V_MST_LOOP_CNT);
            V_TO_SITE         := F_TOKEN(T_TO_SITE        , V_MST_LOOP_CNT);
            V_LINE_ID         := F_TOKEN(T_LINE_ID        , V_MST_LOOP_CNT);
            V_VALUATION_TYPE  := F_TOKEN(T_VALUATION_TYPE , V_MST_LOOP_CNT);
            V_TO_PRODUCT      := F_TOKEN(T_TO_PRODUCT     , V_MST_LOOP_CNT);
            V_INCOTERMS       := F_TOKEN(T_INCOTERMS      , V_MST_LOOP_CNT);
            V_YYYYMM          := F_TOKEN(T_YYYYMM         , V_MST_LOOP_CNT);
            V_MODIQTY         := F_TOKEN(T_MODIQTY        , V_MST_LOOP_CNT);

            /* AS-IS 는 빈 문자열을 0 으로 암묵 변환 - 같은 결과가 되도록 0 으로 둔다 */
            V_MODI_QTY := NVL(TO_NUMBER(V_MODIQTY), 0);

            /* 데이터 저장 */
            IF V_MST_LOOP_CNT > 0
            THEN

                /* 일반 유저 edit모드에서 Electrod, Cell/Pack 의 PROD_PLAN Insert */
                IF V_ACTIVE_FLAG = 'I'
                THEN

                    /* 통합 PSI 신규데이터 입력 */
                    INSERT INTO SCP_ANL_PSI_INTEGRATION
                         ( DIVISION_ID
                         , COMPANY_ID
                         , PLANT_ID
                         , PLAN_START_YYYYMMDD
                         , SEQ
                         , OPERATION_GROUP
                         , FROM_SITE
                         , CELL_ITEM_ID
                         , ITEM_ID
                         , MEASURE
                         , VALUE_TYPE
                         , TO_PRODUCT
                         , LINE_ID
                         , BOH_QTY
                         , TO_SITE
                         , INCOTERMS
                         , SEQ_FLAG
                         , YYYYMM
                         , QTY
                         , ATTRIBUTE2
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    VALUES
                         ( V_DIVISION_ID
                         , V_COMPANY_ID
                         , V_PLANT_ID
                         , P_PLAN_START_YYYYMMDD
                         , 1
                         , (CASE WHEN V_OPERATION_GROUP = 'Pack' THEN 'P'
                                 WHEN V_OPERATION_GROUP = 'Cell' THEN 'A'
                                 ELSE 'E' END)                      /* operation_group */
                         , '-'
                         , V_CELLITEM_ID
                         , V_ITEM_ID
                         , V_MEASURE
                         , V_VALUATION_TYPE
                         , V_TO_PRODUCT
                         , V_LINE_ID
                         , 0                                        /* boh_qty */
                         , V_TO_SITE
                         , V_INCOTERMS
                         , V_SEQ_FLAG
                         , V_YYYYMM
                         , 0                                        /* qty */
                         , V_PLAN_TYPE
                         , V_LAST_UPDATED_BY
                         , SYSDATE
                         , V_LAST_UPDATED_BY
                         , SYSDATE );

                    CONTINUE;   /* Insert 인 경우는 아래 처리 스킵 */

                END IF;

                /* 특정 권한에 따른 BOH_QTY 의 수정 */
                IF UPPER(V_MEASURE) = 'INV'
                THEN

                    /* BOH_QTY 의 변경된 수량만큼 BOH_QTY, QTY 를 가감 */
                    UPDATE SCP_ANL_PSI_INTEGRATION
                       SET BOH_QTY          = ROUND(BOH_QTY + V_MODI_QTY, 0)
                         , QTY              = QTY + V_MODI_QTY
                         , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                       AND PLANT_ID            = UPPER(V_PLANT_ID)
                       AND PLAN_START_YYYYMMDD = V_PLAN_START
                       AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                       AND MEASURE             = 'INV'
                       AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE);   /* 해당 Valuation Type 에 해당하는 값만 변경 */

                    CONTINUE;   /* BOH_QTY 의 변경인 경우는 아래 처리 스킵 */

                END IF;

                /*------------------------------------------------------------------------------------
                 * 소형(40) · ESS(82) 가 아닌 경우
                 *----------------------------------------------------------------------------------*/
                IF UPPER(V_DIVISION_ID) <> '82' AND UPPER(V_DIVISION_ID) <> '40'
                THEN

                    /* SHIP_PLAN_SEMI 수정인 경우 */
                    IF UPPER(V_MEASURE) = 'SHIP_PLAN_SEMI'
                    THEN

                        /* 1. 실제 수정한 값 수정 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID          = UPPER(V_DIVISION_ID)
                           AND PLANT_ID             = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD  = V_PLAN_START
                           AND UPPER(CELL_ITEM_ID)  = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)       = UPPER(V_ITEM_ID)
                           AND MEASURE              = UPPER(V_MEASURE)
                           AND UPPER(LINE_ID)       = UPPER(V_LINE_ID)
                           AND VALUE_TYPE           = UPPER(V_VALUATION_TYPE)
                           AND TO_PRODUCT           = UPPER(V_TO_PRODUCT)
                           AND UPPER(TO_SITE)       = UPPER(V_TO_SITE)
                           AND INCOTERMS            = UPPER(V_INCOTERMS)
                           AND YYYYMM               = UPPER(V_YYYYMM);

                        /* 2. 수정한 Ship plan(SEMI) 에 해당하는 Semi WH In 항목을 찾아서 변경 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_TO_SITE)   /* TO_SITE = Plant_ID 항목 대상 */
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = 'SEMI_WH_IN'
                           AND YYYYMM              = UPPER(V_YYYYMM);

                        /* 3-1. 수정한 Ship plan(SEMI) 의 변경월이후 월의 재고 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY - V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* 3-2. Semi WH In 의 변경월이후 월의 재고 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_TO_SITE)   /* TO_SITE = Plant_ID 항목 대상 */
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                    /* PROD_PLAN 수정인 경우 */
                    ELSIF UPPER(V_MEASURE) = 'PROD_PLAN'
                    THEN

                        /* Prod Plan(전극) : 수정한 Prod Plan 만 저장 */
                        IF V_SEQ_FLAG = '550'
                        THEN

                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = UPPER(V_MEASURE)
                               AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                               AND YYYYMM              = UPPER(V_YYYYMM);

                            /* 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* Prod Plan(셀 반제품) : 해당하는 전극을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '450'
                        THEN

                            /* 1. 수정한 Prod Plan(셀 반제품) 의 변경수량만큼 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = UPPER(V_MEASURE)
                               AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                               AND YYYYMM              = UPPER(V_YYYYMM);

                            /* 2. 수정한 Prod Plan(셀 반제품) 의 전극을 찾아서 가감
                                  (변경수량 X Cell당 전극 소요량 / 수율) */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(NVL(V_MODI_QTY * NVL(IB.USAGE, 1) / NVL(IC.YIELD, 1), 0))
                                                            FROM SCP_ANL_PSI_INTEGRATION IA
                                                               , SCP_MST_BOM_ELEC        IB
                                                               , (SELECT SA.DIVISION_ID
                                                                       , SA.COMPANY_ID
                                                                       , SA.LINE_ID
                                                                       , SA.MONTH
                                                                       , SA.ITEM_ID
                                                                       , SA.YIELD
                                                                       , SB.OPERATION_GROUP
                                                                    FROM SCM_MST_YIELD_VER_H_V SA
                                                                       , (SELECT DISTINCT SEGMENT4 AS OPERATION_ID
                                                                                        , SEGMENT5 AS OPERATION_GROUP
                                                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                                           WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                                                             AND VALID_YN    = 'Y'
                                                                             AND SEGMENT3    = 'Y'
                                                                             AND SEGMENT5    = 'A') SB
                                                                   WHERE SA.OPERATION_ID = SB.OPERATION_ID
                                                                     AND SA.DIVISION_ID  = UPPER(V_DIVISION_ID)) IC
                                                           WHERE IB.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                                             AND UPPER(IB.PARENT_ITEM_ID) = UPPER(IA.ITEM_ID)
                                                             AND IB.SCP_YN               = 'Y'
                                                             AND IC.DIVISION_ID(+)       = IA.DIVISION_ID
                                                             AND IC.OPERATION_GROUP(+)   = IA.OPERATION_GROUP
                                                             AND IC.COMPANY_ID(+)        = IA.COMPANY_ID
                                                             AND IC.LINE_ID(+)           = IA.LINE_ID
                                                             AND IC.MONTH(+)             = IA.YYYYMM
                                                             AND IC.ITEM_ID(+)           = IA.ITEM_ID
                                                             AND IA.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                                             AND IA.PLANT_ID             = UPPER(V_PLANT_ID)
                                                             AND UPPER(IA.ITEM_ID)       = UPPER(V_ITEM_ID)
                                                             AND IA.PLAN_START_YYYYMMDD  = V_PLAN_START
                                                             AND UPPER(IA.LINE_ID)       = UPPER(V_LINE_ID)
                                                             AND IA.YYYYMM               = UPPER(V_YYYYMM)
                                                             AND IA.MEASURE              = 'PROD_PLAN'
                                                             AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = (SELECT MAX(IM.PLANT_ID_ES)
                                                              FROM GT_SCP0111_CELL_ELEC_MAP IM
                                                             WHERE IM.DIVISION_ID_CS      = A.DIVISION_ID
                                                               AND IM.COMPANY_ID_CS       = A.COMPANY_ID
                                                               AND IM.PLANT_ID_CS         = UPPER(V_PLANT_ID)
                                                               AND IM.CELL_PLANT_PRIORITY = 1)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.YYYYMM              = UPPER(V_YYYYMM)
                               AND A.MEASURE             = 'IN_HOUSE_MOVING'
                               AND EXISTS (SELECT 1
                                             FROM SCP_ANL_PSI_INTEGRATION ID
                                                , SCP_MST_BOM_ELEC        IE
                                            WHERE IE.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                              AND UPPER(IE.PARENT_ITEM_ID) = UPPER(ID.ITEM_ID)
                                              AND IE.SCP_YN               = 'Y'
                                              AND ID.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                              AND ID.PLANT_ID             = UPPER(V_PLANT_ID)
                                              AND UPPER(ID.ITEM_ID)       = UPPER(V_ITEM_ID)
                                              AND ID.PLAN_START_YYYYMMDD  = V_PLAN_START
                                              AND UPPER(ID.LINE_ID)       = UPPER(V_LINE_ID)
                                              AND ID.YYYYMM               = UPPER(V_YYYYMM)
                                              AND ID.MEASURE              = 'PROD_PLAN'
                                              AND UPPER(IE.CHILD_ITEM_ID) = UPPER(A.ITEM_ID));

                            /* 3-1. 수정한 Prod Plan(셀 반제품) 의 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 3-2. 전극을 찾아서 변경월이후 월의 재고 재계산
                                    (변경수량 X Cell당 전극 소요량 / 수율) */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(NVL(V_MODI_QTY * NVL(IB.USAGE, 1) / NVL(IC.YIELD, 1), 0))
                                                            FROM SCP_ANL_PSI_INTEGRATION IA
                                                               , SCP_MST_BOM_ELEC        IB
                                                               , (SELECT SA.DIVISION_ID
                                                                       , SA.COMPANY_ID
                                                                       , SA.LINE_ID
                                                                       , SA.MONTH
                                                                       , SA.ITEM_ID
                                                                       , SA.YIELD
                                                                       , SB.OPERATION_GROUP
                                                                    FROM SCM_MST_YIELD_VER_H_V SA
                                                                       , (SELECT DISTINCT SEGMENT4 AS OPERATION_ID
                                                                                        , SEGMENT5 AS OPERATION_GROUP
                                                                            FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                                           WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                                                             AND VALID_YN    = 'Y'
                                                                             AND SEGMENT3    = 'Y'
                                                                             AND SEGMENT5    = 'A') SB
                                                                   WHERE SA.OPERATION_ID = SB.OPERATION_ID
                                                                     AND SA.DIVISION_ID  = UPPER(V_DIVISION_ID)) IC
                                                           WHERE IB.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                                             AND UPPER(IB.PARENT_ITEM_ID) = UPPER(IA.ITEM_ID)
                                                             AND IB.SCP_YN               = 'Y'
                                                             AND IC.DIVISION_ID(+)       = IA.DIVISION_ID
                                                             AND IC.OPERATION_GROUP(+)   = IA.OPERATION_GROUP
                                                             AND IC.COMPANY_ID(+)        = IA.COMPANY_ID
                                                             AND IC.LINE_ID(+)           = IA.LINE_ID
                                                             AND IC.MONTH(+)             = IA.YYYYMM
                                                             AND IC.ITEM_ID(+)           = IA.ITEM_ID
                                                             AND IA.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                                             AND IA.PLANT_ID             = UPPER(V_PLANT_ID)
                                                             AND UPPER(IA.ITEM_ID)       = UPPER(V_ITEM_ID)
                                                             AND IA.PLAN_START_YYYYMMDD  = V_PLAN_START
                                                             AND UPPER(IA.LINE_ID)       = UPPER(V_LINE_ID)
                                                             AND IA.YYYYMM               = UPPER(V_YYYYMM)
                                                             AND IA.MEASURE              = 'PROD_PLAN'
                                                             AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = (SELECT MAX(IM.PLANT_ID_ES)
                                                              FROM GT_SCP0111_CELL_ELEC_MAP IM
                                                             WHERE IM.DIVISION_ID_CS      = A.DIVISION_ID
                                                               AND IM.COMPANY_ID_CS       = A.COMPANY_ID
                                                               AND IM.PLANT_ID_CS         = UPPER(V_PLANT_ID)
                                                               AND IM.CELL_PLANT_PRIORITY = 1)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.YYYYMM             >= UPPER(V_YYYYMM)
                               AND A.MEASURE             = 'INV'
                               AND EXISTS (SELECT 1
                                             FROM SCP_ANL_PSI_INTEGRATION ID
                                                , SCP_MST_BOM_ELEC        IE
                                            WHERE IE.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                              AND UPPER(IE.PARENT_ITEM_ID) = UPPER(ID.ITEM_ID)
                                              AND IE.SCP_YN               = 'Y'
                                              AND ID.DIVISION_ID          = UPPER(V_DIVISION_ID)
                                              AND ID.PLANT_ID             = UPPER(V_PLANT_ID)
                                              AND UPPER(ID.ITEM_ID)       = UPPER(V_ITEM_ID)
                                              AND ID.PLAN_START_YYYYMMDD  = V_PLAN_START
                                              AND UPPER(ID.LINE_ID)       = UPPER(V_LINE_ID)
                                              AND ID.YYYYMM               = UPPER(V_YYYYMM)
                                              AND ID.MEASURE              = 'PROD_PLAN'
                                              AND UPPER(IE.CHILD_ITEM_ID) = UPPER(A.ITEM_ID));

                        /* Prod Plan(셀 제품) : 해당하는 셀 반제품을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '350'
                        THEN

                            /* 1. 수정한 Prod Plan(셀 제품) 의 변경수량만큼 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = UPPER(V_MEASURE)
                               AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                               AND YYYYMM              = UPPER(V_YYYYMM);

                            /* 2. 수정한 Prod Plan(셀 제품) 의 셀 반제품을 찾아서 가감 (변경수량 / 활성화 수율) */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(NVL(V_MODI_QTY / NVL(IY.SCP_FROMATION_YIELD, 1), 0))
                                                            FROM SCP_ANL_PSI_INTEGRATION IA
                                                               , (SELECT SA.DIVISION_ID
                                                                       , SA.ITEM_ID_ASSY
                                                                       , MIN(SA.ITEM_ID_PROD) AS ITEM_ID_PROD
                                                                    FROM SCP_MST_CELL_PROD_ASSY_MAP SA
                                                                       , SCP_MST_FINAL_ITEM        SB
                                                                   WHERE SB.DIVISION_ID    = SA.DIVISION_ID
                                                                     AND UPPER(SB.ITEM_ID) = UPPER(SA.ITEM_ID_PROD)
                                                                     AND SB.ATTRIBUTE8     = 'CP'
                                                                     AND SA.CELL_TYPE      = 'CA1'
                                                                     AND SA.VALID_YN       = 'Y'
                                                                   GROUP BY SA.DIVISION_ID, SA.ITEM_ID_ASSY) IX
                                                               , (SELECT SC.DIVISION_ID
                                                                       , SC.ITEM_ID
                                                                       , SD.PLANT_ID
                                                                       , CASE WHEN NVL(SC.SSP_MODIFY_YIELD, -99) = -99
                                                                              THEN CASE WHEN SC.FORMATION_TOTAL_YIELD = 0 THEN 1
                                                                                        WHEN SC.FORMATION_TOTAL_YIELD > 1 THEN 1
                                                                                        ELSE NVL(SC.FORMATION_TOTAL_YIELD, 1)
                                                                                   END
                                                                              ELSE CASE WHEN SC.SSP_MODIFY_YIELD = 0 THEN 1
                                                                                        WHEN SC.SSP_MODIFY_YIELD > 1 THEN 1
                                                                                        ELSE NVL(SC.SSP_MODIFY_YIELD, 1)
                                                                                   END
                                                                         END AS SCP_FROMATION_YIELD
                                                                    FROM SCP_MST_FORMATION SC
                                                                       , SCM_MST_SITE      SD
                                                                   WHERE SD.DIVISION_ID(+) = SC.DIVISION_ID
                                                                     AND SD.SCM_SITE_ID(+) = SC.PLANT_SITE_ID
                                                                     AND SC.DIVISION_ID    = UPPER(V_DIVISION_ID)) IY
                                                           WHERE IX.DIVISION_ID         = IA.DIVISION_ID
                                                             AND UPPER(IX.ITEM_ID_ASSY) = UPPER(IA.ITEM_ID)
                                                             AND UPPER(IX.ITEM_ID_PROD) = UPPER(V_ITEM_ID)
                                                             AND IY.DIVISION_ID(+)      = IA.DIVISION_ID
                                                             AND IY.PLANT_ID(+)         = IA.PLANT_ID
                                                             AND IY.ITEM_ID(+)          = IX.ITEM_ID_ASSY
                                                             AND IA.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                                             AND IA.PLANT_ID            = UPPER(V_PLANT_ID)
                                                             AND IA.PLAN_START_YYYYMMDD = V_PLAN_START
                                                             AND IA.YYYYMM              = UPPER(V_YYYYMM)
                                                             AND IA.TO_PRODUCT          = UPPER(V_ITEM_ID)
                                                             AND IA.MEASURE             = 'IN_HOUSE_MOVING'
                                                             AND UPPER(IX.ITEM_ID_ASSY) = UPPER(A.ITEM_ID)), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.YYYYMM              = UPPER(V_YYYYMM)
                               AND A.MEASURE             = 'IN_HOUSE_MOVING'
                               AND EXISTS (SELECT 1
                                             FROM SCP_ANL_PSI_INTEGRATION IB
                                                , (SELECT SE.DIVISION_ID
                                                         , SE.ITEM_ID_ASSY
                                                         , MIN(SE.ITEM_ID_PROD) AS ITEM_ID_PROD
                                                      FROM SCP_MST_CELL_PROD_ASSY_MAP SE
                                                         , SCP_MST_FINAL_ITEM        SF
                                                     WHERE SF.DIVISION_ID    = SE.DIVISION_ID
                                                       AND UPPER(SF.ITEM_ID) = UPPER(SE.ITEM_ID_PROD)
                                                       AND SF.ATTRIBUTE8     = 'CP'
                                                       AND SE.CELL_TYPE      = 'CA1'
                                                       AND SE.VALID_YN       = 'Y'
                                                     GROUP BY SE.DIVISION_ID, SE.ITEM_ID_ASSY) IZ
                                            WHERE IZ.DIVISION_ID         = IB.DIVISION_ID
                                              AND UPPER(IZ.ITEM_ID_ASSY) = UPPER(IB.ITEM_ID)
                                              AND UPPER(IZ.ITEM_ID_PROD) = UPPER(V_ITEM_ID)
                                              AND IB.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                              AND IB.PLANT_ID            = UPPER(V_PLANT_ID)
                                              AND IB.PLAN_START_YYYYMMDD = V_PLAN_START
                                              AND IB.YYYYMM              = UPPER(V_YYYYMM)
                                              AND IB.TO_PRODUCT          = UPPER(V_ITEM_ID)
                                              AND IB.MEASURE             = 'IN_HOUSE_MOVING'
                                              AND UPPER(IZ.ITEM_ID_ASSY) = UPPER(A.ITEM_ID));

                            /* 3-1. 수정한 Prod Plan(셀 제품) 의 변경수량만큼 재고 증가 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 3-2. 셀 반제품을 찾아서 변경월이후 월의 재고 재계산 (변경수량 / 활성화 수율) */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(NVL(V_MODI_QTY / NVL(IY.SCP_FROMATION_YIELD, 1), 0))
                                                            FROM SCP_ANL_PSI_INTEGRATION IA
                                                               , (SELECT SA.DIVISION_ID
                                                                       , SA.ITEM_ID_ASSY
                                                                       , MIN(SA.ITEM_ID_PROD) AS ITEM_ID_PROD
                                                                    FROM SCP_MST_CELL_PROD_ASSY_MAP SA
                                                                       , SCP_MST_FINAL_ITEM        SB
                                                                   WHERE SB.DIVISION_ID    = SA.DIVISION_ID
                                                                     AND UPPER(SB.ITEM_ID) = UPPER(SA.ITEM_ID_PROD)
                                                                     AND SB.ATTRIBUTE8     = 'CP'
                                                                     AND SA.CELL_TYPE      = 'CA1'
                                                                     AND SA.VALID_YN       = 'Y'
                                                                   GROUP BY SA.DIVISION_ID, SA.ITEM_ID_ASSY) IX
                                                               , (SELECT SC.DIVISION_ID
                                                                       , SC.ITEM_ID
                                                                       , SD.PLANT_ID
                                                                       , CASE WHEN NVL(SC.SSP_MODIFY_YIELD, -99) = -99
                                                                              THEN CASE WHEN SC.FORMATION_TOTAL_YIELD = 0 THEN 1
                                                                                        WHEN SC.FORMATION_TOTAL_YIELD > 1 THEN 1
                                                                                        ELSE NVL(SC.FORMATION_TOTAL_YIELD, 1)
                                                                                   END
                                                                              ELSE CASE WHEN SC.SSP_MODIFY_YIELD = 0 THEN 1
                                                                                        WHEN SC.SSP_MODIFY_YIELD > 1 THEN 1
                                                                                        ELSE NVL(SC.SSP_MODIFY_YIELD, 1)
                                                                                   END
                                                                         END AS SCP_FROMATION_YIELD
                                                                    FROM SCP_MST_FORMATION SC
                                                                       , SCM_MST_SITE      SD
                                                                   WHERE SD.DIVISION_ID(+) = SC.DIVISION_ID
                                                                     AND SD.SCM_SITE_ID(+) = SC.PLANT_SITE_ID
                                                                     AND SC.DIVISION_ID    = UPPER(V_DIVISION_ID)) IY
                                                           WHERE IX.DIVISION_ID         = IA.DIVISION_ID
                                                             AND UPPER(IX.ITEM_ID_ASSY) = UPPER(IA.ITEM_ID)
                                                             AND UPPER(IX.ITEM_ID_PROD) = UPPER(V_ITEM_ID)
                                                             AND IY.DIVISION_ID(+)      = IA.DIVISION_ID
                                                             AND IY.PLANT_ID(+)         = IA.PLANT_ID
                                                             AND IY.ITEM_ID(+)          = IX.ITEM_ID_ASSY
                                                             AND IA.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                                             AND IA.PLANT_ID            = UPPER(V_PLANT_ID)
                                                             AND IA.PLAN_START_YYYYMMDD = V_PLAN_START
                                                             AND IA.YYYYMM              = UPPER(V_YYYYMM)
                                                             AND IA.MEASURE             = 'INV'
                                                             AND UPPER(IX.ITEM_ID_ASSY) = UPPER(A.ITEM_ID)), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.MEASURE             = 'INV'
                               AND A.YYYYMM             >= UPPER(V_YYYYMM)
                               AND EXISTS (SELECT 1
                                             FROM SCP_ANL_PSI_INTEGRATION IB
                                                , (SELECT SE.DIVISION_ID
                                                         , SE.ITEM_ID_ASSY
                                                         , MIN(SE.ITEM_ID_PROD) AS ITEM_ID_PROD
                                                      FROM SCP_MST_CELL_PROD_ASSY_MAP SE
                                                         , SCP_MST_FINAL_ITEM        SF
                                                     WHERE SF.DIVISION_ID    = SE.DIVISION_ID
                                                       AND UPPER(SF.ITEM_ID) = UPPER(SE.ITEM_ID_PROD)
                                                       AND SF.ATTRIBUTE8     = 'CP'
                                                       AND SE.CELL_TYPE      = 'CA1'
                                                       AND SE.VALID_YN       = 'Y'
                                                     GROUP BY SE.DIVISION_ID, SE.ITEM_ID_ASSY) IZ
                                            WHERE IZ.DIVISION_ID         = IB.DIVISION_ID
                                              AND UPPER(IZ.ITEM_ID_ASSY) = UPPER(IB.ITEM_ID)
                                              AND UPPER(IZ.ITEM_ID_PROD) = UPPER(V_ITEM_ID)
                                              AND IB.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                              AND IB.PLANT_ID            = UPPER(V_PLANT_ID)
                                              AND IB.PLAN_START_YYYYMMDD = V_PLAN_START
                                              AND IB.YYYYMM              = UPPER(V_YYYYMM)
                                              AND IB.MEASURE             = 'INV'
                                              AND UPPER(IZ.ITEM_ID_ASSY) = UPPER(A.ITEM_ID));

                        /* Prod Plan(모듈 반제품) : MULTI_CHILD_ITEM 예외 Case (2024/11/06) */
                        ELSIF V_SEQ_FLAG = '250'
                        THEN

                            V_MULTI_TO_PRODUCT      := NULL;
                            V_MULTI_CELL_ITEM_ID    := NULL;
                            V_ACCUMULATED_CHILD_QTY := 0;
                            V_YIELD                 := 0;

                            /* 1. 수정한 Prod Plan(모듈 반제품) 의 변경수량만큼 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = UPPER(V_MEASURE)
                               AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                               AND YYYYMM              = UPPER(V_YYYYMM);

                            /* 1.2 수정한 item 의 IN_HOUSE_MOVING 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'IN_HOUSE_MOVING'
                               AND YYYYMM              = UPPER(V_YYYYMM);

                            /* LOOKUP 의 to_product, cell_item_id 를 저장
                               AS-IS 는 DISPLAY_SEQ 정렬의 마지막 행 값이 남는다 - 같은 결과가 되도록 KEEP LAST 사용 */
                            BEGIN
                                SELECT MAX(B.SEGMENT1) KEEP (DENSE_RANK LAST ORDER BY B.DISPLAY_SEQ)
                                     , MAX(B.SEGMENT3) KEEP (DENSE_RANK LAST ORDER BY B.DISPLAY_SEQ)
                                  INTO V_MULTI_TO_PRODUCT
                                     , V_MULTI_CELL_ITEM_ID
                                  FROM SCM_ADM_LOOKUP_MASTER        A
                                     , SCM_ADM_LOOKUP_MASTER_DETAIL B
                                 WHERE B.LOOKUP_TYPE = A.LOOKUP_TYPE
                                   AND B.VALID_YN    = 'Y'
                                   AND A.LOOKUP_TYPE = 'MULTI_CHILD_ITEM'
                                   AND A.VALID_YN    = 'Y'
                                   AND UPPER(B.SEGMENT2) = UPPER(V_ITEM_ID);
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    V_MULTI_TO_PRODUCT   := NULL;
                                    V_MULTI_CELL_ITEM_ID := NULL;
                            END;

                            /* 2. 동일 To Product item_id 찾기 */
                            DELETE FROM GT_SCP0111_PSI_230;

                            INSERT INTO GT_SCP0111_PSI_230
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , ITEM_ID
                                 , YYYYMM )
                            SELECT DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , ITEM_ID
                                 , YYYYMM
                              FROM SCP_ANL_PSI_INTEGRATION
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND UPPER(ITEM_ID)     <> UPPER(V_ITEM_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND MEASURE             = 'IN_HOUSE_MOVING'
                               AND YYYYMM              = UPPER(V_YYYYMM)
                               AND TO_PRODUCT          = UPPER(V_MULTI_TO_PRODUCT);

                            /* 2.1 동일 To Product item 의 IN_HOUSE_MOVING 차감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY              = ROUND(A.QTY - V_MODI_QTY, 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE    = 'IN_HOUSE_MOVING'
                               AND A.TO_PRODUCT = UPPER(V_MULTI_TO_PRODUCT)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_230 IA
                                            WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                              AND IA.PLANT_ID            = A.PLANT_ID
                                              AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IA.ITEM_ID)      = UPPER(A.ITEM_ID)
                                              AND IA.YYYYMM              = A.YYYYMM);

                            /* 2.2 동일 To Product item 의 PROD_PLAN 차감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY              = ROUND(A.QTY - V_MODI_QTY, 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE      = 'PROD_PLAN'
                               AND UPPER(A.LINE_ID) = UPPER(V_LINE_ID)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_230 IA
                                            WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                              AND IA.PLANT_ID            = A.PLANT_ID
                                              AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IA.ITEM_ID)      = UPPER(A.ITEM_ID)
                                              AND IA.YYYYMM              = A.YYYYMM);

                            /* 3. 수율 (팩) */
                            DELETE FROM GT_SCP0111_YIELD_P;

                            INSERT INTO GT_SCP0111_YIELD_P
                                 ( DIVISION_ID
                                 , COMPANY_ID
                                 , PLANT_ID
                                 , LINE_ID
                                 , MONTH
                                 , ITEM_ID
                                 , YIELD )
                            SELECT A.DIVISION_ID
                                 , A.COMPANY_ID
                                 , A.PLANT_ID
                                 , A.LINE_ID
                                 , A.MONTH
                                 , A.ITEM_ID
                                 , A.YIELD
                              FROM SCM_MST_YIELD_VER_H_V A
                                 , (SELECT DISTINCT SEGMENT4 AS OPERATION_ID
                                                  , SEGMENT5 AS OPERATION_GROUP
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                       AND VALID_YN    = 'Y'
                                       AND SEGMENT3    = 'Y'
                                       AND SEGMENT5    = 'P') IA
                             WHERE IA.OPERATION_ID = A.OPERATION_ID
                               AND A.DIVISION_ID   = UPPER(V_DIVISION_ID)
                               AND UPPER(A.ITEM_ID) = UPPER(V_MULTI_TO_PRODUCT);

                            /* 4. 셀제품 조회 */
                            DELETE FROM GT_SCP0111_PSI_CELL;

                            INSERT INTO GT_SCP0111_PSI_CELL
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , CHILD_ITEM_ID
                                 , ACCUMULATED_CHILD_QTY
                                 , YIELD
                                 , REAL_MODI_QTY )
                            SELECT A.DIVISION_ID
                                 , A.PLANT_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.YYYYMM
                                 , B.CHILD_ITEM_ID
                                 , NVL(B.ACCUMULATED_CHILD_QTY, 1)
                                 , NVL(D.YIELD, 1)
                                 , NVL(V_MODI_QTY * NVL(B.ACCUMULATED_CHILD_QTY, 1) / NVL(D.YIELD, 1), 0)
                              FROM SCP_ANL_PSI_INTEGRATION        A
                                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                                 , SCP_MST_FINAL_ITEM             C
                                 , GT_SCP0111_YIELD_P             D
                             WHERE B.DIVISION_ID       = A.DIVISION_ID
                               AND B.PLANT_ID          = A.PLANT_ID
                               AND UPPER(B.MODEL_ID)   = UPPER(V_MULTI_TO_PRODUCT)
                               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
                               AND UPPER(C.ITEM_ID)    = UPPER(B.CHILD_ITEM_ID)
                               AND C.DIVISION_ID       = A.DIVISION_ID
                               AND C.OPERATION_GROUP_ID = 'A'
                               AND C.ATTRIBUTE8        = 'CP'
                               AND D.DIVISION_ID(+)    = A.DIVISION_ID
                               AND D.COMPANY_ID(+)     = A.COMPANY_ID
                               AND D.PLANT_ID(+)       = A.PLANT_ID
                               AND D.LINE_ID(+)        = UPPER(V_LINE_ID)
                               AND D.MONTH(+)          = A.YYYYMM
                               AND D.ITEM_ID(+)        = UPPER(V_MULTI_TO_PRODUCT)
                               AND A.DIVISION_ID       = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID          = UPPER(V_PLANT_ID)
                               AND UPPER(A.ITEM_ID)    = UPPER(B.CHILD_ITEM_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.YYYYMM            = UPPER(V_YYYYMM)
                               AND A.MEASURE           = 'IN_HOUSE_MOVING';

                            /* 4.1 팩제품에 대한 셀 제품 투입량 계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CELL IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM              = A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE = 'IN_HOUSE_MOVING'
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CELL IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* 5. LOOKUP 의 MULTI_CHILD_ITEM 에 등록된 셀 제품에 적용할 소요율과 수율 */
                            BEGIN
                                SELECT MAX(ACCUMULATED_CHILD_QTY) KEEP (DENSE_RANK LAST ORDER BY ROWNUM)
                                     , MAX(YIELD)                 KEEP (DENSE_RANK LAST ORDER BY ROWNUM)
                                  INTO V_ACCUMULATED_CHILD_QTY
                                     , V_YIELD
                                  FROM GT_SCP0111_PSI_CELL;
                            EXCEPTION
                                WHEN NO_DATA_FOUND THEN
                                    V_ACCUMULATED_CHILD_QTY := 0;
                                    V_YIELD                 := 0;
                            END;

                            /* 5.0 IN_HOUSE_MOVING 있는지 확인 없으면 insert */
                            SELECT COUNT(*)
                              INTO V_MEASURE_COUNT
                              FROM SCP_ANL_PSI_INTEGRATION
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_MULTI_CELL_ITEM_ID)
                               AND YYYYMM              = UPPER(V_YYYYMM)
                               AND MEASURE             = 'IN_HOUSE_MOVING';

                            IF V_MEASURE_COUNT = 0
                            THEN
                                INSERT INTO SCP_ANL_PSI_INTEGRATION
                                     ( DIVISION_ID
                                     , COMPANY_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , SEQ
                                     , OPERATION_GROUP
                                     , FROM_SITE
                                     , CELL_ITEM_ID
                                     , ITEM_ID
                                     , MEASURE
                                     , VALUE_TYPE
                                     , TO_PRODUCT
                                     , LINE_ID
                                     , BOH_QTY
                                     , TO_SITE
                                     , INCOTERMS
                                     , SEQ_FLAG
                                     , YYYYMM
                                     , QTY
                                     , CREATED_BY
                                     , CREATION_DATE
                                     , LAST_UPDATED_BY
                                     , LAST_UPDATE_DATE )
                                VALUES
                                     ( V_DIVISION_ID
                                     , V_COMPANY_ID
                                     , V_PLANT_ID
                                     , P_PLAN_START_YYYYMMDD
                                     , 1
                                     , 'A'
                                     , '-'
                                     , V_CELLITEM_ID
                                     , V_MULTI_CELL_ITEM_ID
                                     , 'IN_HOUSE_MOVING'
                                     , '-'
                                     , '-'
                                     , '-'
                                     , 0
                                     , '-'
                                     , '-'
                                     , V_SEQ_FLAG
                                     , V_YYYYMM
                                     , 0
                                     , 'SYSTEM'
                                     , SYSDATE
                                     , 'SYSTEM'
                                     , SYSDATE );
                            END IF;

                            /* 5.1 LOOKUP 의 MULTI_CHILD_ITEM 에 등록된 셀 제품 투입량 계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + NVL(V_MODI_QTY * V_ACCUMULATED_CHILD_QTY / V_YIELD, 0), 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_MULTI_CELL_ITEM_ID)
                               AND YYYYMM              = UPPER(V_YYYYMM)
                               AND MEASURE             = 'IN_HOUSE_MOVING';

                            /* 6. 재고 계산
                                  6.1 은 AS-IS 에서 주석 처리(모듈 반제품 재고 변동 없음) */

                            /* 6.2 팩제품에 대한 셀 제품의 투입수량만큼 재고 증가 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CELL IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM             <= A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE = 'INV'
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CELL IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM             <= A.YYYYMM);

                            /* 6.3 LOOKUP 의 MULTI_CHILD_ITEM 에 등록된 셀 제품 투입량만큼 재고 차감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY - NVL(V_MODI_QTY * V_ACCUMULATED_CHILD_QTY / V_YIELD, 0), 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_MULTI_CELL_ITEM_ID)
                               AND YYYYMM             >= UPPER(V_YYYYMM)
                               AND MEASURE             = 'INV';

                        /* Prod Plan(팩/모듈 제품) : 해당하는 팩/모듈 반제품, 셀 제품을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '150'
                        THEN

                            /* 1. 수정한 Prod Plan(팩/모듈) 의 변경수량만큼 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = UPPER(V_MEASURE)
                               AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                               AND YYYYMM              = UPPER(V_YYYYMM);

                            /* 팩/모듈 반제품 소요량을 GTT 에 적재
                               AS-IS 는 BOM_EFFECTIVE_SN_V 를 LEFT JOIN 하지만 뒤의 ITEM_SN INNER JOIN 이
                               그 칸을 조인조건으로 쓰므로 결과는 INNER 와 같다 - 내부조인으로 옮긴다 */
                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , CHILD_ITEM_ID
                                 , REAL_MODI_QTY )
                            SELECT A.DIVISION_ID
                                 , A.PLANT_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.YYYYMM
                                 , B.CHILD_ITEM_ID
                                 , NVL(B.ACCUMULATED_CHILD_QTY, 1)
                              FROM SCP_ANL_PSI_INTEGRATION      A
                                 , SCM_MST_BOM_EFFECTIVE_SN_V   B
                                 , SCM_MST_ITEM_SN              C
                             WHERE UPPER(B.MODEL_ID)       = UPPER(A.ITEM_ID)
                               AND UPPER(B.PARENT_ITEM_ID) = UPPER(A.ITEM_ID)
                               AND B.DIVISION_ID           = A.DIVISION_ID
                               AND B.COMPANY_ID            = A.COMPANY_ID
                               AND B.PLANT_ID              = A.PLANT_ID
                               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
                               AND (B.ALT_ID IS NULL
                                    OR (B.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NULL     AND NVL(B.ALT_PRIORITY, '1') = 'Y')
                                    OR (B.ALT_ID IS NOT NULL AND B.SCP_PLAN_YN IS NOT NULL AND B.SCP_PLAN_YN = 'Y'))
                               AND C.DIVISION_ID           = B.DIVISION_ID
                               AND C.COMPANY_ID            = B.COMPANY_ID
                               AND UPPER(C.ITEM_ID)        = UPPER(B.CHILD_ITEM_ID)
                               AND NVL(C.SCP_FLOW_ID, C.FLOW_ID) = 'P5000'
                               AND A.DIVISION_ID           = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID              = UPPER(V_PLANT_ID)
                               AND UPPER(A.ITEM_ID)        = UPPER(V_ITEM_ID)
                               AND A.PLAN_START_YYYYMMDD   = V_PLAN_START
                               AND A.MEASURE               = UPPER(V_MEASURE)
                               AND A.YYYYMM                = UPPER(V_YYYYMM)
                               AND UPPER(A.LINE_ID)        = UPPER(V_LINE_ID);

                            /* 2.1 In-house Moving(팩/모듈 반제품) 의 변경수량만큼 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (V_MODI_QTY * (SELECT MAX(IA.REAL_MODI_QTY)
                                                                          FROM GT_SCP0111_PSI_CHILD IA
                                                                         WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                                           AND IA.PLANT_ID            = A.PLANT_ID
                                                                           AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                           AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                           AND IA.YYYYMM              = A.YYYYMM)), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE    = 'IN_HOUSE_MOVING'
                               AND A.TO_PRODUCT = UPPER(V_ITEM_ID)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* 2.2 Prod Plan(팩/모듈 반제품) 의 변경수량만큼 가감 (음수로 떨어지지 않도록) */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = (CASE WHEN ROUND(A.QTY + (V_MODI_QTY * (SELECT MAX(IA.REAL_MODI_QTY)
                                                                                     FROM GT_SCP0111_PSI_CHILD IA
                                                                                    WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                                                      AND IA.PLANT_ID            = A.PLANT_ID
                                                                                      AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                                      AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                                      AND IA.YYYYMM              = A.YYYYMM)), 0) >= 0
                                                 THEN ROUND(A.QTY + (V_MODI_QTY * (SELECT MAX(IC.REAL_MODI_QTY)
                                                                                     FROM GT_SCP0111_PSI_CHILD IC
                                                                                    WHERE IC.DIVISION_ID         = A.DIVISION_ID
                                                                                      AND IC.PLANT_ID            = A.PLANT_ID
                                                                                      AND IC.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                                      AND UPPER(IC.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                                      AND IC.YYYYMM              = A.YYYYMM)), 0)
                                                 ELSE 0
                                            END)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE        = 'PROD_PLAN'
                               AND UPPER(A.LINE_ID) = UPPER(V_LINE_ID)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* pack, cell 수율 가져오기 */
                            DELETE FROM GT_SCP0111_YIELD_P;

                            INSERT INTO GT_SCP0111_YIELD_P
                                 ( DIVISION_ID
                                 , COMPANY_ID
                                 , PLANT_ID
                                 , LINE_ID
                                 , MONTH
                                 , ITEM_ID
                                 , YIELD )
                            SELECT A.DIVISION_ID
                                 , A.COMPANY_ID
                                 , A.PLANT_ID
                                 , A.LINE_ID
                                 , A.MONTH
                                 , A.ITEM_ID
                                 , A.YIELD
                              FROM SCM_MST_YIELD_VER_H_V A
                                 , (SELECT DISTINCT SEGMENT4 AS OPERATION_ID
                                                  , SEGMENT5 AS OPERATION_GROUP
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                       AND VALID_YN    = 'Y'
                                       AND SEGMENT3    = 'Y'
                                       AND SEGMENT5    = 'P') IA
                             WHERE IA.OPERATION_ID = A.OPERATION_ID
                               AND A.DIVISION_ID   = UPPER(V_DIVISION_ID)
                               AND A.ITEM_ID       = UPPER(V_ITEM_ID);  -- [E20261112-YIELDP] 2026-11-12 저장 품목만 적재(읽는 3곳이 모두 ITEM_ID(+) = UPPER(V_ITEM_ID)) — Division 전체 적재는 SCM_YIELD_VER_H 전체 읽기로 끝나지 않음

                            /* 3. 팩/모듈 제품의 셀 제품을 찾아서 (변경수량 X 팩당 Cell 소요량 / 수율) 가감
                                  (음수로 떨어지지 않도록) */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = (CASE WHEN ROUND(A.QTY + (SELECT MAX(NVL(V_MODI_QTY * NVL(IB.ACCUMULATED_CHILD_QTY, 1) / NVL(ID.YIELD, 1), 0))
                                                                       FROM SCP_ANL_PSI_INTEGRATION        IA
                                                                          , SCM_MST_MODEL_FINAL_ITEM_BOM_V IB
                                                                          , SCP_MST_FINAL_ITEM             IC
                                                                          , GT_SCP0111_YIELD_P             ID
                                                                      WHERE IB.DIVISION_ID        = IA.DIVISION_ID
                                                                        AND IB.PLANT_ID           = IA.PLANT_ID
                                                                        AND UPPER(IB.MODEL_ID)    = UPPER(V_ITEM_ID)
                                                                        AND TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN IB.EFF_START_DATE AND IB.EFF_END_DATE
                                                                        AND UPPER(IC.ITEM_ID)     = UPPER(IB.CHILD_ITEM_ID)
                                                                        AND IC.DIVISION_ID        = IA.DIVISION_ID
                                                                        AND IC.OPERATION_GROUP_ID = 'A'
                                                                        AND IC.ATTRIBUTE8         = 'CP'
                                                                        AND ID.DIVISION_ID(+)     = IA.DIVISION_ID
                                                                        AND ID.COMPANY_ID(+)      = IA.COMPANY_ID
                                                                        AND ID.PLANT_ID(+)        = IA.PLANT_ID
                                                                        AND ID.LINE_ID(+)         = UPPER(V_LINE_ID)
                                                                        AND ID.MONTH(+)           = IA.YYYYMM
                                                                        AND ID.ITEM_ID(+)         = UPPER(V_ITEM_ID)
                                                                        AND IA.DIVISION_ID        = UPPER(V_DIVISION_ID)
                                                                        AND IA.PLANT_ID           = UPPER(V_PLANT_ID)
                                                                        AND UPPER(IA.ITEM_ID)     = UPPER(IB.CHILD_ITEM_ID)
                                                                        AND IA.PLAN_START_YYYYMMDD = V_PLAN_START
                                                                        AND IA.YYYYMM             = UPPER(V_YYYYMM)
                                                                        AND IA.MEASURE            = 'IN_HOUSE_MOVING'
                                                                        AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)), 0) >= 0
                                                 THEN ROUND(A.QTY + (SELECT MAX(NVL(V_MODI_QTY * NVL(IK.ACCUMULATED_CHILD_QTY, 1) / NVL(IH.YIELD, 1), 0))
                                                                       FROM SCP_ANL_PSI_INTEGRATION        IE
                                                                          , SCM_MST_MODEL_FINAL_ITEM_BOM_V IK
                                                                          , SCP_MST_FINAL_ITEM             IG
                                                                          , GT_SCP0111_YIELD_P             IH
                                                                      WHERE IK.DIVISION_ID        = IE.DIVISION_ID
                                                                        AND IK.PLANT_ID           = IE.PLANT_ID
                                                                        AND UPPER(IK.MODEL_ID)    = UPPER(V_ITEM_ID)
                                                                        AND TO_DATE(IE.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN IK.EFF_START_DATE AND IK.EFF_END_DATE
                                                                        AND UPPER(IG.ITEM_ID)     = UPPER(IK.CHILD_ITEM_ID)
                                                                        AND IG.DIVISION_ID        = IE.DIVISION_ID
                                                                        AND IG.OPERATION_GROUP_ID = 'A'
                                                                        AND IG.ATTRIBUTE8         = 'CP'
                                                                        AND IH.DIVISION_ID(+)     = IE.DIVISION_ID
                                                                        AND IH.COMPANY_ID(+)      = IE.COMPANY_ID
                                                                        AND IH.PLANT_ID(+)        = IE.PLANT_ID
                                                                        AND IH.LINE_ID(+)         = UPPER(V_LINE_ID)
                                                                        AND IH.MONTH(+)           = IE.YYYYMM
                                                                        AND IH.ITEM_ID(+)         = UPPER(V_ITEM_ID)
                                                                        AND IE.DIVISION_ID        = UPPER(V_DIVISION_ID)
                                                                        AND IE.PLANT_ID           = UPPER(V_PLANT_ID)
                                                                        AND UPPER(IE.ITEM_ID)     = UPPER(IK.CHILD_ITEM_ID)
                                                                        AND IE.PLAN_START_YYYYMMDD = V_PLAN_START
                                                                        AND IE.YYYYMM             = UPPER(V_YYYYMM)
                                                                        AND IE.MEASURE            = 'IN_HOUSE_MOVING'
                                                                        AND UPPER(IK.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)), 0)
                                                 ELSE 0
                                            END)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.YYYYMM              = UPPER(V_YYYYMM)
                               AND A.MEASURE             = 'IN_HOUSE_MOVING'
                               AND EXISTS (SELECT 1
                                             FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V II
                                                , SCP_MST_FINAL_ITEM             IJ
                                            WHERE II.DIVISION_ID        = A.DIVISION_ID
                                              AND II.PLANT_ID           = A.PLANT_ID
                                              AND UPPER(II.MODEL_ID)    = UPPER(V_ITEM_ID)
                                              AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN II.EFF_START_DATE AND II.EFF_END_DATE
                                              AND UPPER(IJ.ITEM_ID)     = UPPER(II.CHILD_ITEM_ID)
                                              AND IJ.DIVISION_ID        = A.DIVISION_ID
                                              AND IJ.OPERATION_GROUP_ID = 'A'
                                              AND IJ.ATTRIBUTE8         = 'CP'
                                              AND UPPER(II.CHILD_ITEM_ID) = UPPER(A.ITEM_ID));

                            /* 4.1 수정한 Prod Plan(팩/모듈) 의 변경수량만큼 재고 증가 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 4.2 팩/모듈 제품의 셀 제품을 찾아서 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(NVL(V_MODI_QTY * NVL(IB.ACCUMULATED_CHILD_QTY, 1) / NVL(ID.YIELD, 1), 0))
                                                            FROM SCP_ANL_PSI_INTEGRATION        IA
                                                               , SCM_MST_MODEL_FINAL_ITEM_BOM_V IB
                                                               , SCP_MST_FINAL_ITEM             IC
                                                               , GT_SCP0111_YIELD_P             ID
                                                           WHERE IB.DIVISION_ID        = IA.DIVISION_ID
                                                             AND IB.PLANT_ID           = IA.PLANT_ID
                                                             AND UPPER(IB.MODEL_ID)    = UPPER(V_ITEM_ID)
                                                             AND TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN IB.EFF_START_DATE AND IB.EFF_END_DATE
                                                             AND UPPER(IC.ITEM_ID)     = UPPER(IB.CHILD_ITEM_ID)
                                                             AND IC.DIVISION_ID        = IA.DIVISION_ID
                                                             AND IC.OPERATION_GROUP_ID = 'A'
                                                             AND IC.ATTRIBUTE8         = 'CP'
                                                             AND ID.DIVISION_ID(+)     = IA.DIVISION_ID
                                                             AND ID.COMPANY_ID(+)      = IA.COMPANY_ID
                                                             AND ID.PLANT_ID(+)        = IA.PLANT_ID
                                                             AND ID.LINE_ID(+)         = UPPER(V_LINE_ID)
                                                             AND ID.MONTH(+)           = IA.YYYYMM
                                                             AND ID.ITEM_ID(+)         = UPPER(V_ITEM_ID)
                                                             AND IA.DIVISION_ID        = UPPER(V_DIVISION_ID)
                                                             AND IA.PLANT_ID           = UPPER(V_PLANT_ID)
                                                             AND UPPER(IA.ITEM_ID)     = UPPER(IB.CHILD_ITEM_ID)
                                                             AND IA.PLAN_START_YYYYMMDD = V_PLAN_START
                                                             AND IA.YYYYMM             = UPPER(V_YYYYMM)
                                                             AND IA.MEASURE            = 'INV'
                                                             AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.MEASURE             = 'INV'
                               AND A.YYYYMM             >= UPPER(V_YYYYMM)
                               AND EXISTS (SELECT 1
                                             FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V IE
                                                , SCP_MST_FINAL_ITEM             IG
                                            WHERE IE.DIVISION_ID        = A.DIVISION_ID
                                              AND IE.PLANT_ID           = A.PLANT_ID
                                              AND UPPER(IE.MODEL_ID)    = UPPER(V_ITEM_ID)
                                              AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN IE.EFF_START_DATE AND IE.EFF_END_DATE
                                              AND UPPER(IG.ITEM_ID)     = UPPER(IE.CHILD_ITEM_ID)
                                              AND IG.DIVISION_ID        = A.DIVISION_ID
                                              AND IG.OPERATION_GROUP_ID = 'A'
                                              AND IG.ATTRIBUTE8         = 'CP'
                                              AND UPPER(IE.CHILD_ITEM_ID) = UPPER(A.ITEM_ID));

                        END IF;   /* SEQ_FLAG 분기 */

                    END IF;   /* MEASURE 분기 */

                /*------------------------------------------------------------------------------------
                 * ESS(82) 인 경우
                 *----------------------------------------------------------------------------------*/
                ELSIF UPPER(V_DIVISION_ID) = '82'
                THEN

                    /* 1. 실제 수정한 값 수정 */
                    UPDATE SCP_ANL_PSI_INTEGRATION
                       SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                         , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                       AND PLANT_ID            = UPPER(V_PLANT_ID)
                       AND PLAN_START_YYYYMMDD = V_PLAN_START
                       AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                       AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                       AND MEASURE             = UPPER(V_MEASURE)
                       AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                       AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                       AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                       AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                       AND YYYYMM              = UPPER(V_YYYYMM);

                    /* SHIP_PLAN_SEMI 수정인 경우 */
                    IF UPPER(V_MEASURE) = 'SHIP_PLAN_SEMI'
                    THEN

                        V_TMP_VALUATION_TYPE := '-';

                        IF UPPER(V_VALUATION_TYPE) <> '-'
                        THEN
                            V_TMP_VALUATION_TYPE := 'PUR';
                        END IF;

                        /* 2. 수정한 Ship plan(SEMI) 에 해당하는 Semi WH In 항목을 찾아서 변경 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_TO_SITE)   /* TO_SITE = Plant_ID 항목 대상 */
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND VALUE_TYPE          = V_TMP_VALUATION_TYPE
                           AND MEASURE             = 'SEMI_WH_IN'
                           AND YYYYMM              = UPPER(V_YYYYMM);

                        /* 3. 변경월이후 월의 재고 재계산 */
                        IF UPPER(V_VALUATION_TYPE) <> '-'
                        THEN

                            /* 3-1. 수정한 Ship plan(SEMI) 의 변경월이후 월의 재고 재계산(PRD) */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY - V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 3-2. Semi WH In 의 변경월이후 월의 재고 재계산(PUR) */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_TO_SITE)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND VALUE_TYPE          = V_TMP_VALUATION_TYPE
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                        END IF;

                        /* 3-3. 수정한 Ship plan(SEMI) 의 변경월이후 월의 재고 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY - V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND VALUE_TYPE          = '-'
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* 3-4. Semi WH In 의 변경월이후 월의 재고 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_TO_SITE)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND VALUE_TYPE          = '-'
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                    /* PROD_PLAN 수정인 경우 */
                    ELSIF UPPER(V_MEASURE) = 'PROD_PLAN'
                    THEN

                        /* Prod Plan(전극) : 수정한 Prod Plan 만 저장 */
                        IF V_SEQ_FLAG = '550'
                        THEN

                            /* 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* Prod Plan(셀) : 해당하는 전극을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '350'
                        THEN

                            /* 전극 소요량을 GTT 에 적재
                               ★ AS-IS 의 SITE_TYPE = 'plant' 는 MSSQL 대소문자 무시 비교라 'PLANT' 행에 걸린다.
                                  Oracle 은 구분하므로 칸 값(전건 'PLANT') 에 맞춰 대문자로 바꾼다 - 2026.09.23 AJS */
                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , CHILD_ITEM_ID
                                 , REAL_MODI_QTY )
                            SELECT A.DIVISION_ID
                                 , CASE WHEN A.COMPANY_ID = V_ESOC THEN V_ESNJ_PLANT ELSE B.PLANT_ID END
                                 , A.PLAN_START_YYYYMMDD
                                 , A.YYYYMM
                                 , C.CHILD_ITEM_ID
                                 , NVL(V_MODI_QTY * NVL(C.USAGE, 1) / NVL(D.YIELD, 1), 0)
                              FROM SCP_ANL_PSI_INTEGRATION A
                                 , (SELECT DISTINCT COMPANY_ID
                                                  , PLANT_ID
                                      FROM SCM_MST_SITE
                                     WHERE SITE_TYPE       = 'PLANT'
                                       AND OPERATION_GROUP = 'E'
                                       AND VALID_YN        = 'Y') B
                                 , SCP_MST_BOM_ELEC        C
                                 , (SELECT SA.DIVISION_ID
                                         , SA.COMPANY_ID
                                         , SA.LINE_ID
                                         , SA.MONTH
                                         , SA.ITEM_ID
                                         , SA.YIELD
                                         , SB.OPERATION_GROUP
                                      FROM SCM_MST_YIELD_VER_H_V SA
                                         , (SELECT DISTINCT SEGMENT4 AS OPERATION_ID
                                                          , SEGMENT5 AS OPERATION_GROUP
                                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                             WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                               AND VALID_YN    = 'Y'
                                               AND SEGMENT3    = 'Y'
                                               AND SEGMENT5    = 'A') SB
                                     WHERE SA.OPERATION_ID = SB.OPERATION_ID
                                       AND SA.DIVISION_ID  = UPPER(V_DIVISION_ID)) D
                             WHERE B.COMPANY_ID           = CASE WHEN A.COMPANY_ID = V_ESOC THEN V_ESNJ ELSE A.COMPANY_ID END
                               AND C.DIVISION_ID          = UPPER(V_DIVISION_ID)
                               AND UPPER(C.PARENT_ITEM_ID) = UPPER(A.ITEM_ID)
                               AND C.SCP_YN               = 'Y'
                               AND D.DIVISION_ID(+)       = A.DIVISION_ID
                               AND D.OPERATION_GROUP(+)   = A.OPERATION_GROUP
                               AND D.COMPANY_ID(+)        = A.COMPANY_ID
                               AND D.LINE_ID(+)           = A.LINE_ID
                               AND D.MONTH(+)             = A.YYYYMM
                               AND D.ITEM_ID(+)           = A.ITEM_ID
                               AND A.DIVISION_ID          = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID             = UPPER(V_PLANT_ID)
                               AND UPPER(A.ITEM_ID)       = UPPER(V_ITEM_ID)
                               AND A.PLAN_START_YYYYMMDD  = V_PLAN_START
                               AND A.YYYYMM               = UPPER(V_YYYYMM)
                               AND UPPER(A.LINE_ID)       = UPPER(V_LINE_ID)
                               AND A.MEASURE              = 'PROD_PLAN';

                            /* 2. 수정한 Prod Plan(셀) 의 전극을 찾아서 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM              = A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE         = 'IN_HOUSE_MOVING'
                               AND UPPER(A.TO_SITE)  = UPPER(V_PLANT_ID)   /* 셀의 plant_id 를 전극의 to_site 로 구분 */
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* 3-1. 수정한 Prod Plan(셀) 의 변경월이후 월의 재고 재계산(PRD, - 둘다) */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND (VALUE_TYPE = UPPER(V_VALUATION_TYPE) OR VALUE_TYPE = '-')
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 3-2. 전극을 찾아서 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM             <= A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE = 'INV'
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM             <= A.YYYYMM);

                        /* ESS 팩 Prod Plan 도 수정 가능하도록 2025-03-24 */
                        ELSIF V_SEQ_FLAG = '250'
                        THEN

                            /* 수정한 Prod Plan(팩) 의 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* 링크/렉 : 해당하는 Pack 을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '150'
                        THEN

                            /* Pack 소요량을 GTT 에 적재 */
                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , CHILD_ITEM_ID
                                 , REAL_MODI_QTY )
                            SELECT A.DIVISION_ID
                                 , A.PLANT_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.YYYYMM
                                 , B.CHILD_ITEM_ID
                                 , NVL(V_MODI_QTY * NVL(B.ACCUMULATED_CHILD_QTY, 1) / NVL(C.YIELD, 1), 0)
                              FROM SCP_ANL_PSI_INTEGRATION        A
                                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                                 , SCP_MST_TACT_TIME_OSP          C
                             WHERE B.DIVISION_ID          = A.DIVISION_ID
                               AND B.PLANT_ID             = A.PLANT_ID
                               AND UPPER(B.MODEL_ID)      = UPPER(A.ITEM_ID)
                               AND UPPER(B.MODEL_ID)     <> UPPER(B.CHILD_ITEM_ID)
                               AND B.OPERATION_GROUP_ID   = 'P'
                               AND TO_DATE(A.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
                               AND C.DIVISION_ID(+)       = UPPER(V_DIVISION_ID)
                               AND C.VALID_YN(+)          = 'Y'
                               AND C.PLANT_SITE_ID(+)     = A.PLANT_ID
                               AND C.ITEM_ID(+)           = A.ITEM_ID
                               AND C.LINE_ID(+)           = A.LINE_ID
                               AND A.DIVISION_ID          = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID             = UPPER(V_PLANT_ID)
                               AND UPPER(A.CELL_ITEM_ID)  = UPPER(V_CELLITEM_ID)
                               AND UPPER(A.ITEM_ID)       = UPPER(V_ITEM_ID)
                               AND A.PLAN_START_YYYYMMDD  = V_PLAN_START
                               AND A.YYYYMM               = UPPER(V_YYYYMM)
                               AND A.MEASURE              = 'PROD_PLAN';

                            /* 2. 수정한 링크/렉의 Pack 을 찾아서 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM              = A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE            = 'IN_HOUSE_MOVING'
                               AND UPPER(A.CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* 3-1. 수정한 링크/렉의 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 3-2. 수정한 링크/렉의 Pack 을 찾아서 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM             <= A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE            = 'INV'
                               AND UPPER(A.CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM             <= A.YYYYMM);

                        END IF;   /* SEQ_FLAG 분기 */

                    /* ESS 팩 수정시 페어가 되는 IN_HOUSE_MOVING 을 수정한 경우 */
                    ELSIF UPPER(V_MEASURE) = 'IN_HOUSE_MOVING'
                    THEN

                        /* 1.1 수정한 IN_HOUSE_MOVING 의 VALUE_TYPE 이 '-' 인 변경월의 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                           AND VALUE_TYPE          = '-'
                           AND MEASURE             = 'IN_HOUSE_MOVING'
                           AND YYYYMM              = UPPER(V_YYYYMM);

                        /* 1.2 변경월이후 월의 재고(해당 Value Type, '-') 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY - V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND (VALUE_TYPE = UPPER(V_VALUATION_TYPE) OR VALUE_TYPE = '-')
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                    END IF;   /* MEASURE 분기 */

                /*------------------------------------------------------------------------------------
                 * 소형(40) 인 경우 (20241025)
                 *----------------------------------------------------------------------------------*/
                ELSIF UPPER(V_DIVISION_ID) = '40'
                THEN

                    /* 1. 실제 수정한 값 수정 */
                    UPDATE SCP_ANL_PSI_INTEGRATION
                       SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                         , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                       AND PLANT_ID            = UPPER(V_PLANT_ID)
                       AND PLAN_START_YYYYMMDD = V_PLAN_START
                       AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                       AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                       AND MEASURE             = UPPER(V_MEASURE)
                       AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                       AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                       AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                       AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                       AND INCOTERMS           = UPPER(V_INCOTERMS)
                       AND YYYYMM              = UPPER(V_YYYYMM);

                    /* SHIP_PLAN_SEMI 수정인 경우 */
                    IF UPPER(V_MEASURE) = 'SHIP_PLAN_SEMI'
                    THEN

                        /* 2. 수정한 Ship plan(SEMI) 에 해당하는 Semi WH In 항목을 찾아서 변경 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_TO_SITE)   /* TO_SITE = Plant_ID 항목 대상 */
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = 'SEMI_WH_IN'
                           AND YYYYMM              = UPPER(V_YYYYMM);

                        /* 3-1. 수정한 Ship plan(SEMI) 의 변경월이후 월의 재고 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY - V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* 3-2. Semi WH In 의 변경월이후 월의 재고 재계산 */
                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND PLANT_ID            = UPPER(V_TO_SITE)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = 'INV'
                           AND YYYYMM             >= UPPER(V_YYYYMM);

                    /* PROD_PLAN 수정인 경우 */
                    ELSIF UPPER(V_MEASURE) = 'PROD_PLAN'
                    THEN

                        /* Prod Plan(전극) : 수정한 Prod Plan 만 저장 */
                        IF V_SEQ_FLAG = '550'
                        THEN

                            /* 2. 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                        /* Prod Plan(셀 반제품) : 해당하는 전극을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '450'
                        THEN

                            /* 1.1 전극 소요량을 GTT 에 적재 (전극 수율 반영) */
                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , CHILD_ITEM_ID
                                 , REAL_MODI_QTY )
                            SELECT A.DIVISION_ID
                                 , A.PLANT_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.YYYYMM
                                 , B.CHILD_ITEM_ID
                                 , NVL(V_MODI_QTY * NVL(B.USAGE, 1) / NVL(C.YIELD, 1), 0)
                              FROM SCP_ANL_PSI_INTEGRATION A
                                 , SCP_MST_BOM_ELEC        B
                                 , (SELECT SA.DIVISION_ID
                                         , SA.COMPANY_ID
                                         , SA.LINE_ID
                                         , SA.MONTH
                                         , SA.ITEM_ID
                                         , SA.YIELD
                                         , SB.OPERATION_GROUP
                                      FROM SCM_MST_YIELD_VER_H_V SA
                                         , (SELECT DISTINCT SEGMENT4 AS OPERATION_ID
                                                          , SEGMENT5 AS OPERATION_GROUP
                                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                             WHERE LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                               AND VALID_YN    = 'Y'
                                               AND SEGMENT3    = 'Y'
                                               AND SEGMENT5    = 'A') SB
                                     WHERE SA.OPERATION_ID = SB.OPERATION_ID
                                       AND SA.DIVISION_ID  = UPPER(V_DIVISION_ID)) C
                             WHERE B.DIVISION_ID          = A.DIVISION_ID
                               AND UPPER(B.PARENT_ITEM_ID) = UPPER(A.ITEM_ID)
                               AND B.SCP_YN               = 'Y'
                               AND C.DIVISION_ID(+)       = A.DIVISION_ID
                               AND C.OPERATION_GROUP(+)   = A.OPERATION_GROUP
                               AND C.COMPANY_ID(+)        = A.COMPANY_ID
                               AND C.LINE_ID(+)           = A.LINE_ID
                               AND C.MONTH(+)             = A.YYYYMM
                               AND C.ITEM_ID(+)           = A.ITEM_ID
                               AND A.DIVISION_ID          = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID             = UPPER(V_PLANT_ID)
                               AND UPPER(A.ITEM_ID)       = UPPER(V_ITEM_ID)
                               AND A.PLAN_START_YYYYMMDD  = V_PLAN_START
                               AND A.YYYYMM               = UPPER(V_YYYYMM)
                               AND A.MEASURE              = 'PROD_PLAN'
                               AND UPPER(A.LINE_ID)       = UPPER(V_LINE_ID);

                            /* 1.2 전극 IN_HOUSE_MOVING 의 QTY 갱신 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM              = A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE  = 'IN_HOUSE_MOVING'
                               AND A.PLANT_ID = (SELECT MAX(IM.PLANT_ID_ES)
                                                   FROM GT_SCP0111_CELL_ELEC_MAP IM
                                                  WHERE IM.DIVISION_ID_CS      = A.DIVISION_ID
                                                    AND IM.COMPANY_ID_CS       = A.COMPANY_ID
                                                    AND IM.PLANT_ID_CS         = UPPER(V_PLANT_ID)
                                                    AND IM.CELL_PLANT_PRIORITY = 1)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* 1.3 전극 재고 갱신 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM             <= A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE  = 'INV'
                               AND A.PLANT_ID = (SELECT MAX(IM.PLANT_ID_ES)
                                                   FROM GT_SCP0111_CELL_ELEC_MAP IM
                                                  WHERE IM.DIVISION_ID_CS      = A.DIVISION_ID
                                                    AND IM.COMPANY_ID_CS       = A.COMPANY_ID
                                                    AND IM.PLANT_ID_CS         = UPPER(V_PLANT_ID)
                                                    AND IM.CELL_PLANT_PRIORITY = 1)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM             <= A.YYYYMM);

                            /* 2. 예외케이스 처리 */
                            SELECT COUNT(*)
                              INTO V_CNT
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                             WHERE LOOKUP_TYPE     = 'TCO_NO_CA2_ITEM_PROD'
                               AND VALID_YN        = 'Y'
                               AND UPPER(SEGMENT3) = UPPER(V_ITEM_ID);

                            /* 2.1 예외케이스1 이 존재할 경우 - 셀제품의 Prod plan, INV 만 수정 */
                            IF V_CNT > 0
                            THEN

                                DELETE FROM GT_SCP0111_TCO_ITEM;

                                INSERT INTO GT_SCP0111_TCO_ITEM
                                     ( TCO_ITEM_PROD
                                     , CELL_ITEM_PROD )
                                SELECT SEGMENT1
                                     , SEGMENT2
                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                 WHERE LOOKUP_TYPE     = 'TCO_NO_CA2_ITEM_PROD'
                                   AND VALID_YN        = 'Y'
                                   AND UPPER(SEGMENT3) = UPPER(V_ITEM_ID);

                                /* 셀 제품의 Prod plan(350) */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY              = ROUND(A.QTY + V_MODI_QTY, 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND A.YYYYMM              = UPPER(V_YYYYMM)
                                   AND A.MEASURE             = 'PROD_PLAN'
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_TCO_ITEM IA
                                                WHERE UPPER(IA.CELL_ITEM_PROD) = UPPER(A.ITEM_ID));

                                /* 셀 제품의 INV 갱신 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY              = ROUND(A.QTY + V_MODI_QTY, 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND A.YYYYMM             >= UPPER(V_YYYYMM)
                                   AND A.MEASURE             = 'INV'
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_TCO_ITEM IA
                                                WHERE UPPER(IA.CELL_ITEM_PROD) = UPPER(A.ITEM_ID));

                                /* 변경월이후 월의 재고 재계산 */
                                UPDATE SCP_ANL_PSI_INTEGRATION
                                   SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                     , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , LAST_UPDATE_DATE = SYSDATE
                                 WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND PLANT_ID            = UPPER(V_PLANT_ID)
                                   AND PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                                   AND YYYYMM             >= UPPER(V_YYYYMM)
                                   AND MEASURE             = 'INV';

                                CONTINUE;

                            END IF;

                            /* 2.2 예외케이스2(초소형) 인 경우 - 자동차처럼 전극의 IN_HOUSE_MOVING 만 갱신 */
                            IF UPPER(V_ITEM_ID) = 'MASS20253-A2'
                            THEN

                                UPDATE SCP_ANL_PSI_INTEGRATION
                                   SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                     , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , LAST_UPDATE_DATE = SYSDATE
                                 WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND PLANT_ID            = UPPER(V_PLANT_ID)
                                   AND PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                                   AND YYYYMM             >= UPPER(V_YYYYMM)
                                   AND MEASURE             = 'INV';

                                CONTINUE;

                            END IF;

                            /* 3.1 수정한 Prod Plan(셀 반제품) 의 In-house Moving 의 변경수량만큼 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND YYYYMM              = UPPER(V_YYYYMM)
                               AND MEASURE             = 'IN_HOUSE_MOVING';

                            /* 4.1 셀 후공정 반제품 item 을 GTT 에 적재 */
                            DELETE FROM GT_SCP0111_PSI_TGT;

                            INSERT INTO GT_SCP0111_PSI_TGT
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , ITEM_ID
                                 , TARGET_ITEM_ID
                                 , REAL_MODI_QTY )
                            SELECT A.DIVISION_ID
                                 , A.PLANT_ID
                                 , A.PLAN_START_YYYYMMDD
                                 , A.YYYYMM
                                 , A.ITEM_ID
                                 , C.ITEM_ID_ASSY
                                 , NVL(V_MODI_QTY * NVL(E.FORMATION_TOTAL_YIELD, 1), 0)
                              FROM SCP_ANL_PSI_INTEGRATION     A
                                 , SCP_MST_CELL_PROD_ASSY_MAP  B
                                 , SCP_MST_CELL_PROD_ASSY_MAP  C
                                 , SCP_MST_FINAL_ITEM          D
                                 , SCP_MST_FORMATION_V         E
                             WHERE B.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND UPPER(B.ITEM_ID_ASSY) = UPPER(A.ITEM_ID)
                               AND B.CELL_TYPE           = 'CA1'
                               AND B.PLANT_ID            = A.PLANT_ID
                               AND B.VALID_YN            = 'Y'
                               AND UPPER(B.ITEM_ID_ASSY) NOT IN (SELECT UPPER(SA.SEGMENT1)
                                                                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL SA
                                                                  WHERE SA.LOOKUP_TYPE = 'ULTRA_SMALL_MULTI_TCO_ITEM'
                                                                    AND SA.VALID_YN    = 'Y')
                               AND C.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND UPPER(C.ITEM_ID_PROD) = UPPER(B.ITEM_ID_PROD)
                               AND C.CELL_TYPE           = 'CA2'
                               AND C.PLANT_ID            = B.PLANT_ID
                               AND C.VALID_YN            = 'Y'
                               AND D.DIVISION_ID         = C.DIVISION_ID
                               AND D.OPERATION_GROUP     = 'A'
                               AND UPPER(D.ITEM_ID)      = UPPER(C.ITEM_ID_ASSY)
                               AND D.ATTRIBUTE8          = 'CA2'
                               AND NVL(D.TCO_CELL_YN, 'N') = 'Y'
                               AND E.DIVISION_ID(+)      = A.DIVISION_ID
                               AND E.PLANT_SITE_ID(+) LIKE '%' || A.PLANT_ID || '%'
                               AND E.ITEM_ID(+)          = A.ITEM_ID
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                               AND UPPER(A.ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND A.YYYYMM              = UPPER(V_YYYYMM)
                               AND A.MEASURE             = 'PROD_PLAN'
                               AND UPPER(A.LINE_ID)      = UPPER(V_LINE_ID);

                            SELECT COUNT(ITEM_ID)
                              INTO V_CNT
                              FROM GT_SCP0111_PSI_TGT;

                            /* 셀 후공정반제품이 존재하는 경우 */
                            IF V_CNT > 0
                            THEN

                                /* 4.2 셀 후공정반제품의 PROD_PLAN 의 QTY 갱신 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_TGT IA
                                                               WHERE IA.DIVISION_ID          = A.DIVISION_ID
                                                                 AND IA.PLANT_ID             = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM               = A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE = 'PROD_PLAN'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_TGT IB
                                                WHERE IB.DIVISION_ID          = A.DIVISION_ID
                                                  AND IB.PLANT_ID             = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM               = A.YYYYMM);

                                /* 4.3 셀 후공정반제품의 재고 QTY 갱신 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_TGT IA
                                                               WHERE IA.DIVISION_ID          = A.DIVISION_ID
                                                                 AND IA.PLANT_ID             = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM              <= A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE = 'INV'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_TGT IB
                                                WHERE IB.DIVISION_ID          = A.DIVISION_ID
                                                  AND IB.PLANT_ID             = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM              <= A.YYYYMM);

                            ELSE
                                /* 셀 제품이 존재하는 경우 */

                                /* 4.2 셀 제품 PROD_PLAN 구하기 */
                                DELETE FROM GT_SCP0111_PSI_TGT;

                                INSERT INTO GT_SCP0111_PSI_TGT
                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , ITEM_ID
                                     , TARGET_ITEM_ID
                                     , REAL_MODI_QTY )
                                SELECT A.DIVISION_ID
                                     , A.PLANT_ID
                                     , A.PLAN_START_YYYYMMDD
                                     , A.YYYYMM
                                     , A.ITEM_ID
                                     , B.ITEM_ID_PROD
                                     , NVL(V_MODI_QTY * NVL(D.FORMATION_TOTAL_YIELD, 1), 0)
                                  FROM SCP_ANL_PSI_INTEGRATION     A
                                     , SCP_MST_CELL_PROD_ASSY_MAP  B
                                     , SCP_MST_FINAL_ITEM          C
                                     , SCP_MST_FORMATION_V         D
                                 WHERE B.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND UPPER(B.ITEM_ID_ASSY) = UPPER(A.ITEM_ID)
                                   AND B.CELL_TYPE           = 'CA1'
                                   AND B.PLANT_ID            = A.PLANT_ID
                                   AND B.VALID_YN            = 'Y'
                                   AND C.DIVISION_ID         = A.DIVISION_ID
                                   AND C.OPERATION_GROUP     = 'A'
                                   AND UPPER(C.ITEM_ID)      = UPPER(B.ITEM_ID_PROD)
                                   AND SUBSTR(C.ATTRIBUTE8, 1, 2) = 'CP'
                                   AND NVL(C.TCO_CELL_YN, 'N') <> 'Y'
                                   AND D.DIVISION_ID(+)      = A.DIVISION_ID
                                   AND D.PLANT_SITE_ID(+) LIKE '%' || A.PLANT_ID || '%'
                                   AND D.ITEM_ID(+)          = A.ITEM_ID
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                                   AND UPPER(A.ITEM_ID)      = UPPER(V_ITEM_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND A.YYYYMM              = UPPER(V_YYYYMM)
                                   AND A.MEASURE             = 'PROD_PLAN'
                                   AND UPPER(A.LINE_ID)      = UPPER(V_LINE_ID);

                                /* 4.3 셀 제품의 PROD_PLAN 의 QTY 갱신
                                       AS-IS 에 LAST_UPDATED_BY/DATE 가 없는 문장이라 그대로 둔다 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_TGT IA
                                                               WHERE IA.DIVISION_ID          = A.DIVISION_ID
                                                                 AND IA.PLANT_ID             = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM               = A.YYYYMM), 0)
                                     /* 2026.10.23 AJS 최종 변경자·일시 기록 - CNS 8항 (START) */
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                     /* 2026.10.23 AJS 최종 변경자·일시 기록 - CNS 8항 (END) */
                                 WHERE A.MEASURE = 'PROD_PLAN'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_TGT IB
                                                WHERE IB.DIVISION_ID          = A.DIVISION_ID
                                                  AND IB.PLANT_ID             = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM               = A.YYYYMM);

                                /* 4.4 셀 제품의 재고 갱신 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_TGT IA
                                                               WHERE IA.DIVISION_ID          = A.DIVISION_ID
                                                                 AND IA.PLANT_ID             = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM              <= A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE = 'INV'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_TGT IB
                                                WHERE IB.DIVISION_ID          = A.DIVISION_ID
                                                  AND IB.PLANT_ID             = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD  = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.TARGET_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM              <= A.YYYYMM);

                            END IF;

                        /* Prod Plan(모듈 반제품) : 해당하는 셀 제품을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '250'
                        THEN

                            DELETE FROM GT_SCP0111_PSI_CHILD;

                            INSERT INTO GT_SCP0111_PSI_CHILD
                                 ( DIVISION_ID
                                 , PLANT_ID
                                 , PLAN_START_YYYYMMDD
                                 , YYYYMM
                                 , CHILD_ITEM_ID
                                 , REAL_MODI_QTY )
                            /* AS-IS 는 SITE 를 LEFT JOIN 한 뒤 그 OSP_YN 을 BOM 조인 조건의 분기에 쓴다.
                               Oracle 은 (+) 테이블의 칸이 다른 조건에 (+) 없이 나오면 그 조인을 내부조인으로
                               바꾸어 매칭 없는 행을 지우므로, 원장과 SITE 의 외부조인을 인라인 뷰로 분리한다 - 2026.09.23 AJS */
                            SELECT IA.DIVISION_ID
                                 , IA.PLANT_ID
                                 , IA.PLAN_START_YYYYMMDD
                                 , IA.YYYYMM
                                 , C.CHILD_ITEM_ID
                                 , NVL(V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1) / NVL(E.YIELD, 1), 0)
                              FROM (SELECT A.DIVISION_ID
                                         , A.COMPANY_ID
                                         , A.PLANT_ID
                                         , A.PLAN_START_YYYYMMDD
                                         , A.ITEM_ID
                                         , A.YYYYMM
                                         , A.LINE_ID
                                         , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID ELSE A.PLANT_ID END) AS BOM_PLANT_ID
                                      FROM SCP_ANL_PSI_INTEGRATION A
                                         , SCM_MST_SITE            B
                                     WHERE B.DIVISION_ID     (+) = A.DIVISION_ID
                                       AND B.PLANT_ID        (+) = A.PLANT_ID
                                       AND B.OPERATION_GROUP (+) = 'P'
                                       AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                       AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                                       AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                       AND UPPER(A.ITEM_ID)      = UPPER(V_ITEM_ID)
                                       AND A.YYYYMM              = UPPER(V_YYYYMM)
                                       AND A.MEASURE             = 'PROD_PLAN'
                                       AND UPPER(A.LINE_ID)      = UPPER(V_LINE_ID)) IA
                                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                                 , SCP_MST_FINAL_ITEM             D
                                 , SCM_MST_YIELD_VER_H_V          E
                             WHERE C.DIVISION_ID           = IA.DIVISION_ID
                               AND C.PLANT_ID              = IA.BOM_PLANT_ID
                               AND UPPER(C.MODEL_ID)       = UPPER(IA.ITEM_ID)
                               AND TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN C.EFF_START_DATE AND C.EFF_END_DATE
                               AND UPPER(D.ITEM_ID)        = UPPER(C.CHILD_ITEM_ID)
                               AND D.DIVISION_ID           = IA.DIVISION_ID
                               AND D.OPERATION_GROUP_ID    = 'A'
                               AND D.ATTRIBUTE8            = 'CP'
                               AND NVL(D.TCO_CELL_YN, 'N') <> 'Y'
                               AND E.DIVISION_ID           = IA.DIVISION_ID
                               AND E.COMPANY_ID            = IA.COMPANY_ID
                               AND E.PLANT_ID              = IA.PLANT_ID
                               AND UPPER(E.ITEM_ID)        = UPPER(IA.ITEM_ID)
                               AND UPPER(E.LINE_ID)        = UPPER(IA.LINE_ID)
                               AND E.MONTH                 = IA.YYYYMM;

                            /* 2. 모듈 반제품의 셀 제품을 찾아서 가감 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM              = A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE        = 'IN_HOUSE_MOVING'
                               AND A.TO_PRODUCT     = UPPER(V_ITEM_ID)
                               AND UPPER(A.TO_SITE) = UPPER(V_PLANT_ID)
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM              = A.YYYYMM);

                            /* 3-1. 수정한 Prod Plan(모듈 반제품) 의 변경수량만큼 재고 증가 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                            /* 3.2 모듈 반제품의 셀 제품을 찾아서 변경월이후 월의 재고 재계산 */
                            UPDATE SCP_ANL_PSI_INTEGRATION A
                               SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                            FROM GT_SCP0111_PSI_CHILD IA
                                                           WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                             AND IA.PLANT_ID            = A.PLANT_ID
                                                             AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                             AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                             AND IA.YYYYMM             <= A.YYYYMM), 0)
                                 , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , A.LAST_UPDATE_DATE = SYSDATE
                             WHERE A.MEASURE = 'INV'
                               AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                               AND EXISTS (SELECT 1
                                             FROM GT_SCP0111_PSI_CHILD IB
                                            WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                              AND IB.PLANT_ID            = A.PLANT_ID
                                              AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                              AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                              AND IB.YYYYMM             <= A.YYYYMM);

                        /* Prod Plan(팩(외주)) : 해당하는 모듈 반제품 또는 셀제품을 찾아서 가감 */
                        ELSIF V_SEQ_FLAG = '150'
                        THEN

                            /* 모듈 반제품이 있는 모델인지 확인 */
                            /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 - 2026.09.23 AJS
                               AS-IS 와 같이 사업부 · 계획일자 제한 없이 품목만으로 확인한다 */
                            SELECT COUNT(DISTINCT IA.ITEM_ID)
                              INTO V_CNT
                              FROM (SELECT A.DIVISION_ID
                                         , A.PLANT_ID
                                         , A.PLAN_START_YYYYMMDD
                                         , A.ITEM_ID
                                         , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID ELSE A.PLANT_ID END) AS BOM_PLANT_ID
                                      FROM SCP_ANL_PSI_INTEGRATION A
                                         , SCM_MST_SITE            B
                                     WHERE B.DIVISION_ID     (+) = A.DIVISION_ID
                                       AND B.PLANT_ID        (+) = A.PLANT_ID
                                       AND B.OPERATION_GROUP (+) = 'P'
                                       AND UPPER(A.ITEM_ID)      = UPPER(V_ITEM_ID)) IA
                                 , SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                                 , SCP_MST_FINAL_ITEM             D
                             WHERE C.DIVISION_ID         = IA.DIVISION_ID
                               AND C.PLANT_ID            = IA.BOM_PLANT_ID
                               AND UPPER(C.MODEL_ID)     = UPPER(IA.ITEM_ID)
                               AND TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN C.EFF_START_DATE AND C.EFF_END_DATE
                               AND UPPER(D.ITEM_ID)      = UPPER(C.CHILD_ITEM_ID)
                               AND D.DIVISION_ID         = IA.DIVISION_ID
                               AND D.FLOW_ID             = 'P5000';

                            /* 1) 모듈 반제품이 있는 모델 */
                            IF V_CNT > 0
                            THEN

                                DELETE FROM GT_SCP0111_PSI_CHILD;

                                INSERT INTO GT_SCP0111_PSI_CHILD
                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , CHILD_ITEM_ID
                                     , REAL_MODI_QTY )
                                /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 - 2026.09.23 AJS */
                                SELECT IA.DIVISION_ID
                                     , IA.PLANT_ID
                                     , IA.PLAN_START_YYYYMMDD
                                     , IA.YYYYMM
                                     , C.CHILD_ITEM_ID
                                     , V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1)
                                  FROM (SELECT A.DIVISION_ID
                                             , A.PLANT_ID
                                             , A.PLAN_START_YYYYMMDD
                                             , A.ITEM_ID
                                             , A.YYYYMM
                                             , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID ELSE A.PLANT_ID END) AS BOM_PLANT_ID
                                          FROM SCP_ANL_PSI_INTEGRATION A
                                             , SCM_MST_SITE            B
                                         WHERE B.DIVISION_ID     (+) = A.DIVISION_ID
                                           AND B.PLANT_ID        (+) = A.PLANT_ID
                                           AND B.OPERATION_GROUP (+) = 'P'
                                           AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                           AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                                           AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                           AND UPPER(A.ITEM_ID)      = UPPER(V_ITEM_ID)
                                           AND A.YYYYMM              = UPPER(V_YYYYMM)
                                           AND A.MEASURE             = 'PROD_PLAN') IA
                                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                                     , SCP_MST_FINAL_ITEM             D
                                 WHERE C.DIVISION_ID         = IA.DIVISION_ID
                                   AND C.PLANT_ID            = IA.BOM_PLANT_ID
                                   AND UPPER(C.MODEL_ID)     = UPPER(IA.ITEM_ID)
                                   AND TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN C.EFF_START_DATE AND C.EFF_END_DATE
                                   AND UPPER(D.ITEM_ID)      = UPPER(C.CHILD_ITEM_ID)
                                   AND D.DIVISION_ID         = IA.DIVISION_ID
                                   AND D.OPERATION_GROUP     = 'P'   /* OPERATION_GROUP_ID 에는 'B' 가 들어 있어 OPERATION_GROUP 사용 */
                                   AND D.FLOW_ID             = 'P5000';

                                /* In-house Moving(모듈 반제품) 의 변경수량만큼 가감 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_CHILD IA
                                                               WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                                 AND IA.PLANT_ID            = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM              = A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE    = 'IN_HOUSE_MOVING'
                                   AND A.TO_PRODUCT = UPPER(V_ITEM_ID)
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_CHILD IB
                                                WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                                  AND IB.PLANT_ID            = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM              = A.YYYYMM);

                                /* INV(모듈 반제품) 을 찾아서 변경월이후 월의 재고 재계산 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_CHILD IA
                                                               WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                                 AND IA.PLANT_ID            = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM             <= A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE = 'INV'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_CHILD IB
                                                WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                                  AND IB.PLANT_ID            = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM             <= A.YYYYMM);

                            ELSE
                                /* 2) 모듈 반제품이 없는 모델 */

                                DELETE FROM GT_SCP0111_PSI_CHILD;

                                INSERT INTO GT_SCP0111_PSI_CHILD
                                     ( DIVISION_ID
                                     , PLANT_ID
                                     , PLAN_START_YYYYMMDD
                                     , YYYYMM
                                     , CHILD_ITEM_ID
                                     , REAL_MODI_QTY )
                                /* 원장과 SITE 의 외부조인을 인라인 뷰로 분리 - 2026.09.23 AJS */
                                SELECT IA.DIVISION_ID
                                     , IA.PLANT_ID
                                     , IA.PLAN_START_YYYYMMDD
                                     , IA.YYYYMM
                                     , C.CHILD_ITEM_ID
                                     , NVL(V_MODI_QTY * NVL(C.ACCUMULATED_CHILD_QTY, 1), 0)
                                  FROM (SELECT A.DIVISION_ID
                                             , A.PLANT_ID
                                             , A.PLAN_START_YYYYMMDD
                                             , A.ITEM_ID
                                             , A.YYYYMM
                                             , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID ELSE A.PLANT_ID END) AS BOM_PLANT_ID
                                          FROM SCP_ANL_PSI_INTEGRATION A
                                             , SCM_MST_SITE            B
                                         WHERE B.DIVISION_ID     (+) = A.DIVISION_ID
                                           AND B.PLANT_ID        (+) = A.PLANT_ID
                                           AND B.OPERATION_GROUP (+) = 'P'
                                           AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                           AND A.PLANT_ID            = UPPER(V_PLANT_ID)
                                           AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                           AND UPPER(A.ITEM_ID)      = UPPER(V_ITEM_ID)
                                           AND A.YYYYMM              = UPPER(V_YYYYMM)
                                           AND A.MEASURE             = 'PROD_PLAN') IA
                                     , SCM_MST_MODEL_FINAL_ITEM_BOM_V C
                                     , SCP_MST_FINAL_ITEM             D
                                 WHERE C.DIVISION_ID         = IA.DIVISION_ID
                                   AND C.PLANT_ID            = IA.BOM_PLANT_ID
                                   AND UPPER(C.MODEL_ID)     = UPPER(IA.ITEM_ID)
                                   AND TO_DATE(IA.PLAN_START_YYYYMMDD, 'YYYYMMDD') BETWEEN C.EFF_START_DATE AND C.EFF_END_DATE
                                   AND UPPER(D.ITEM_ID)      = UPPER(C.CHILD_ITEM_ID)
                                   AND D.DIVISION_ID         = IA.DIVISION_ID
                                   AND D.OPERATION_GROUP_ID  = 'A'
                                   AND D.ATTRIBUTE8          = 'CP'
                                   AND NVL(D.TCO_CELL_YN, 'N') <> 'Y';

                                /* 팩(외주) 제품의 셀 제품을 찾아서 (변경수량 X Cell 소요량) 가감 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY + (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_CHILD IA
                                                               WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                                 AND IA.PLANT_ID            = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM              = A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE    = 'IN_HOUSE_MOVING'
                                   AND A.TO_PRODUCT = UPPER(V_ITEM_ID)
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_CHILD IB
                                                WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                                  AND IB.PLANT_ID            = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM              = A.YYYYMM);

                                /* 팩(외주) 제품의 셀 제품을 찾아서 변경월이후 월의 재고 재계산 */
                                UPDATE SCP_ANL_PSI_INTEGRATION A
                                   SET A.QTY = ROUND(A.QTY - (SELECT MAX(IA.REAL_MODI_QTY)
                                                                FROM GT_SCP0111_PSI_CHILD IA
                                                               WHERE IA.DIVISION_ID         = A.DIVISION_ID
                                                                 AND IA.PLANT_ID            = A.PLANT_ID
                                                                 AND IA.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                                 AND UPPER(IA.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                                 AND IA.YYYYMM             <= A.YYYYMM), 0)
                                     , A.LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                     , A.LAST_UPDATE_DATE = SYSDATE
                                 WHERE A.MEASURE = 'INV'
                                   AND A.DIVISION_ID         = UPPER(V_DIVISION_ID)
                                   AND A.PLAN_START_YYYYMMDD = V_PLAN_START
                                   AND EXISTS (SELECT 1
                                                 FROM GT_SCP0111_PSI_CHILD IB
                                                WHERE IB.DIVISION_ID         = A.DIVISION_ID
                                                  AND IB.PLANT_ID            = A.PLANT_ID
                                                  AND IB.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                  AND UPPER(IB.CHILD_ITEM_ID) = UPPER(A.ITEM_ID)
                                                  AND IB.YYYYMM             <= A.YYYYMM);

                            END IF;

                            /* 수정한 Prod Plan(팩(외주)) 의 변경수량만큼 재고 증가 */
                            UPDATE SCP_ANL_PSI_INTEGRATION
                               SET QTY              = ROUND(QTY + V_MODI_QTY, 0)
                                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                                 , LAST_UPDATE_DATE = SYSDATE
                             WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                               AND PLANT_ID            = UPPER(V_PLANT_ID)
                               AND PLAN_START_YYYYMMDD = V_PLAN_START
                               AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                               AND MEASURE             = 'INV'
                               AND YYYYMM             >= UPPER(V_YYYYMM);

                        END IF;   /* SEQ_FLAG 분기 */

                    END IF;   /* MEASURE 분기 */

                END IF;   /* DIVISION 분기 */

            END IF;   /* V_MST_LOOP_CNT > 0 */

        END LOOP;

        P_WRITE_LOG(C_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########');

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT '0'            AS CODE
             , 'SUCCESS'      AS MSG
             , V_MAX_LOOP_CNT AS EVENT
             , 'S'            AS RESULT_CODE
             , V_MAX_LOOP_CNT AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* 되돌리기를 결과 커서 OPEN 앞에 둔다 (ROLLBACK 이 뒤에 열린 커서를 닫으므로) */
            V_ERR_MSG := '[' || TO_CHAR(SQLCODE) || ']' || SUBSTR(SQLERRM, 1, 3900);
            ROLLBACK TO SP_SCP0111_SAVE;
            P_WRITE_ERROR_LOG(C_PROGRAM_NAME, V_ERR_MSG);

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1'                                            AS CODE
                 , V_ERR_MSG                                       AS MSG
                 , 0                                               AS EVENT
                 , 'F'                                             AS RESULT_CODE
                 , 0                                               AS RESULT_CNT
              FROM DUAL;

    END P_SCP0111_SAVE_INTEGRATION_PSI;

    /*==================================================================================================
     * 통합 PSI Admin 사용자 수정/저장
     *   AS-IS : SCP0111_SAVE_INTEGRATION_PSI_ADMIN
     *==================================================================================================*/
    PROCEDURE P_SCP0111_SAVE_PSI_ADMIN
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_COMPANY_ID            IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_OPERATION_GROUP       IN  CLOB,
        P_CELLITEM_ID           IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_MEASURE               IN  CLOB,
        P_VALUATION_TYPE        IN  CLOB,
        P_TO_PRODUCT            IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_TO_SITE               IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_BOH_QTY               IN  CLOB,
        P_SEQ_FLAG              IN  CLOB,
        P_YYYYMM                IN  CLOB,
        P_MODIQTY               IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        C_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'SCP0111_SAVE_INTEGRATION_PSI_ADMIN';
        C_MSG_DUP       CONSTANT VARCHAR2(200 CHAR) := '[99010]동일한 데이터가 존재합니다.';

        T_ACTIVE_FLAG       T_TOKEN_TAB;
        T_PLAN_TYPE         T_TOKEN_TAB;
        T_DIVISION_ID       T_TOKEN_TAB;
        T_COMPANY_ID        T_TOKEN_TAB;
        T_PLANT_ID          T_TOKEN_TAB;
        T_OPERATION_GROUP   T_TOKEN_TAB;
        T_CELLITEM_ID       T_TOKEN_TAB;
        T_ITEM_ID           T_TOKEN_TAB;
        T_MEASURE           T_TOKEN_TAB;
        T_VALUATION_TYPE    T_TOKEN_TAB;
        T_TO_PRODUCT        T_TOKEN_TAB;
        T_LINE_ID           T_TOKEN_TAB;
        T_TO_SITE           T_TOKEN_TAB;
        T_INCOTERMS         T_TOKEN_TAB;
        T_BOH_QTY           T_TOKEN_TAB;
        T_SEQ_FLAG          T_TOKEN_TAB;
        T_YYYYMM            T_TOKEN_TAB;
        T_MODIQTY           T_TOKEN_TAB;

        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_PLAN_TYPE         VARCHAR2(4000 CHAR);
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_COMPANY_ID        VARCHAR2(4000 CHAR);
        V_PLANT_ID          VARCHAR2(4000 CHAR);
        V_OPERATION_GROUP   VARCHAR2(4000 CHAR);
        V_CELLITEM_ID       VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);
        V_MEASURE           VARCHAR2(4000 CHAR);
        V_VALUATION_TYPE    VARCHAR2(4000 CHAR);
        V_TO_PRODUCT        VARCHAR2(4000 CHAR);
        V_LINE_ID           VARCHAR2(4000 CHAR);
        V_TO_SITE           VARCHAR2(4000 CHAR);
        V_INCOTERMS         VARCHAR2(4000 CHAR);
        V_BOH_QTY           VARCHAR2(4000 CHAR);
        V_SEQ_FLAG          VARCHAR2(4000 CHAR);
        V_YYYYMM            VARCHAR2(4000 CHAR);
        V_MODIQTY           VARCHAR2(4000 CHAR);
        V_BOH_QTY_N         NUMBER;
        V_MODI_QTY          NUMBER;

        V_PLAN_START        VARCHAR2(4000 CHAR) := UPPER(RTRIM(P_PLAN_START_YYYYMMDD));
        V_LAST_UPDATED_BY   VARCHAR2(600 CHAR)  := P_USER_ID;

        V_MAX_LOOP_CNT      PLS_INTEGER := 0;
        V_MST_LOOP_CNT      PLS_INTEGER := 0;
        V_RECV_LEN          NUMBER      := 0;
        V_DUMMY_CNT         PLS_INTEGER;
        V_DATA_DUP_CNT      NUMBER      := 0;
        V_ERR_MSG           VARCHAR2(4000 CHAR);
    BEGIN

        V_RECV_LEN := NVL(DBMS_LOB.GETLENGTH(RTRIM(P_ACTIVE_FLAG)), 0);

        P_SPLIT(P_ACTIVE_FLAG     , C_DELIMITER, T_ACTIVE_FLAG    , V_MAX_LOOP_CNT);
        P_SPLIT(P_PLAN_TYPE       , C_DELIMITER, T_PLAN_TYPE      , V_DUMMY_CNT);
        P_SPLIT(P_DIVISION_ID     , C_DELIMITER, T_DIVISION_ID    , V_DUMMY_CNT);
        P_SPLIT(P_COMPANY_ID      , C_DELIMITER, T_COMPANY_ID     , V_DUMMY_CNT);
        P_SPLIT(P_PLANT_ID        , C_DELIMITER, T_PLANT_ID       , V_DUMMY_CNT);
        P_SPLIT(P_OPERATION_GROUP , C_DELIMITER, T_OPERATION_GROUP, V_DUMMY_CNT);
        P_SPLIT(P_CELLITEM_ID     , C_DELIMITER, T_CELLITEM_ID    , V_DUMMY_CNT);
        P_SPLIT(P_ITEM_ID         , C_DELIMITER, T_ITEM_ID        , V_DUMMY_CNT);
        P_SPLIT(P_MEASURE         , C_DELIMITER, T_MEASURE        , V_DUMMY_CNT);
        P_SPLIT(P_VALUATION_TYPE  , C_DELIMITER, T_VALUATION_TYPE , V_DUMMY_CNT);
        P_SPLIT(P_TO_PRODUCT      , C_DELIMITER, T_TO_PRODUCT     , V_DUMMY_CNT);
        P_SPLIT(P_LINE_ID         , C_DELIMITER, T_LINE_ID        , V_DUMMY_CNT);
        P_SPLIT(P_TO_SITE         , C_DELIMITER, T_TO_SITE        , V_DUMMY_CNT);
        P_SPLIT(P_INCOTERMS       , C_DELIMITER, T_INCOTERMS      , V_DUMMY_CNT);
        P_SPLIT(P_BOH_QTY         , C_DELIMITER, T_BOH_QTY        , V_DUMMY_CNT);
        P_SPLIT(P_SEQ_FLAG        , C_DELIMITER, T_SEQ_FLAG       , V_DUMMY_CNT);
        P_SPLIT(P_YYYYMM          , C_DELIMITER, T_YYYYMM         , V_DUMMY_CNT);
        P_SPLIT(P_MODIQTY         , C_DELIMITER, T_MODIQTY        , V_DUMMY_CNT);

        /* 저장 시작 지점 - 오류 시 앞 행 저장분까지 되돌린다 */
        SAVEPOINT SP_SCP0111_ADMIN;

        /* 시작 LOG */
        P_WRITE_LOG(C_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########');

        WHILE V_RECV_LEN > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            V_ACTIVE_FLAG     := F_TOKEN(T_ACTIVE_FLAG    , V_MST_LOOP_CNT);
            V_PLAN_TYPE       := F_TOKEN(T_PLAN_TYPE      , V_MST_LOOP_CNT);
            V_DIVISION_ID     := F_TOKEN(T_DIVISION_ID    , V_MST_LOOP_CNT);
            V_COMPANY_ID      := F_TOKEN(T_COMPANY_ID     , V_MST_LOOP_CNT);
            V_PLANT_ID        := F_TOKEN(T_PLANT_ID       , V_MST_LOOP_CNT);
            V_OPERATION_GROUP := F_TOKEN(T_OPERATION_GROUP, V_MST_LOOP_CNT);
            V_CELLITEM_ID     := F_TOKEN(T_CELLITEM_ID    , V_MST_LOOP_CNT);
            V_ITEM_ID         := F_TOKEN(T_ITEM_ID        , V_MST_LOOP_CNT);
            V_MEASURE         := F_TOKEN(T_MEASURE        , V_MST_LOOP_CNT);
            V_VALUATION_TYPE  := F_TOKEN(T_VALUATION_TYPE , V_MST_LOOP_CNT);
            V_TO_PRODUCT      := F_TOKEN(T_TO_PRODUCT     , V_MST_LOOP_CNT);
            V_LINE_ID         := F_TOKEN(T_LINE_ID        , V_MST_LOOP_CNT);
            V_TO_SITE         := F_TOKEN(T_TO_SITE        , V_MST_LOOP_CNT);
            V_INCOTERMS       := F_TOKEN(T_INCOTERMS      , V_MST_LOOP_CNT);
            V_BOH_QTY         := F_TOKEN(T_BOH_QTY        , V_MST_LOOP_CNT);
            V_SEQ_FLAG        := F_TOKEN(T_SEQ_FLAG       , V_MST_LOOP_CNT);
            V_YYYYMM          := F_TOKEN(T_YYYYMM         , V_MST_LOOP_CNT);
            V_MODIQTY         := F_TOKEN(T_MODIQTY        , V_MST_LOOP_CNT);

            /* AS-IS 는 빈 문자열을 0 으로 암묵 변환 - 같은 결과가 되도록 0 으로 둔다 */
            V_BOH_QTY_N := NVL(TO_NUMBER(V_BOH_QTY), 0);
            V_MODI_QTY  := NVL(TO_NUMBER(V_MODIQTY), 0);

            /* 중복체크 */
            IF V_ACTIVE_FLAG = 'I'
            THEN

                SELECT COUNT(*)
                  INTO V_DATA_DUP_CNT
                  FROM SCP_ANL_PSI_INTEGRATION
                 WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                   AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                   AND PLANT_ID            = UPPER(V_PLANT_ID)
                   AND PLAN_START_YYYYMMDD = V_PLAN_START
                   AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                   AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                   AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                   AND MEASURE             = UPPER(V_MEASURE)
                   AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                   AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                   AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                   AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                   AND INCOTERMS           = UPPER(V_INCOTERMS)
                   AND YYYYMM              = UPPER(V_YYYYMM)
                   AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE);

                IF V_DATA_DUP_CNT > 0
                THEN
                    RAISE_APPLICATION_ERROR(-20010, C_MSG_DUP);
                END IF;

            END IF;

            /* 데이터 저장 */
            IF V_MST_LOOP_CNT > 0
            THEN

                /* 데이터 수정 */
                IF V_ACTIVE_FLAG = 'M'
                THEN

                    /* 2026.11.03 SCP0111 BOH DB-ONLY (START)
                       INV 행 = BOH 셀 : 같은 KEY 전체 월의 BOH 를 맞추고(월마다 다르면 조회 PIVOT 이 2행으로 갈라짐) QTY 도 BOH 변경량만큼 가감
                       그 외 = 월 수량 셀 : V_MODIQTY(가감값) 를 해당 월 QTY 에 더한다 - BOH 는 건드리지 않음 */
                    IF UPPER(V_MEASURE) = 'INV'
                    THEN

                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET BOH_QTY          = ROUND(V_BOH_QTY_N, 0)
                             , QTY              = QTY + (ROUND(V_BOH_QTY_N, 0) - NVL(TRUNC(BOH_QTY), 0))   /* 2026.11.03 SCP0111 BOH INV-QTY : AS-IS BOH 변경량만큼 INV QTY 가감 */
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = UPPER(V_MEASURE)
                           AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                           AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                           AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                           AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                           AND INCOTERMS           = UPPER(V_INCOTERMS)
                           AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE)
                           AND LNNVL(TRUNC(BOH_QTY) = ROUND(V_BOH_QTY_N, 0));

                    ELSE

                        UPDATE SCP_ANL_PSI_INTEGRATION
                           SET QTY              = ROUND(NVL(QTY, 0) + V_MODI_QTY, 0)
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE DIVISION_ID         = UPPER(V_DIVISION_ID)
                           AND COMPANY_ID          = UPPER(V_COMPANY_ID)
                           AND PLANT_ID            = UPPER(V_PLANT_ID)
                           AND PLAN_START_YYYYMMDD = V_PLAN_START
                           AND OPERATION_GROUP     = UPPER(V_OPERATION_GROUP)
                           AND UPPER(CELL_ITEM_ID) = UPPER(V_CELLITEM_ID)
                           AND UPPER(ITEM_ID)      = UPPER(V_ITEM_ID)
                           AND MEASURE             = UPPER(V_MEASURE)
                           AND VALUE_TYPE          = UPPER(V_VALUATION_TYPE)
                           AND TO_PRODUCT          = UPPER(V_TO_PRODUCT)
                           AND UPPER(LINE_ID)      = UPPER(V_LINE_ID)
                           AND UPPER(TO_SITE)      = UPPER(V_TO_SITE)
                           AND INCOTERMS           = UPPER(V_INCOTERMS)
                           AND ATTRIBUTE2          = UPPER(V_PLAN_TYPE)
                           AND YYYYMM              = UPPER(V_YYYYMM);

                    END IF;
                    /* 2026.11.03 SCP0111 BOH DB-ONLY (END) */

                ELSIF V_ACTIVE_FLAG = 'I'
                THEN

                    /* 통합 PSI 신규데이터 입력 */
                    INSERT INTO SCP_ANL_PSI_INTEGRATION
                         ( DIVISION_ID
                         , COMPANY_ID
                         , PLANT_ID
                         , PLAN_START_YYYYMMDD
                         , SEQ
                         , OPERATION_GROUP
                         , FROM_SITE
                         , CELL_ITEM_ID
                         , ITEM_ID
                         , MEASURE
                         , VALUE_TYPE
                         , TO_PRODUCT
                         , LINE_ID
                         , BOH_QTY
                         , TO_SITE
                         , INCOTERMS
                         , SEQ_FLAG
                         , YYYYMM
                         , QTY
                         , ATTRIBUTE2
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    VALUES
                         ( V_DIVISION_ID
                         , V_COMPANY_ID
                         , V_PLANT_ID
                         , P_PLAN_START_YYYYMMDD
                         , 1
                         , V_OPERATION_GROUP
                         , '-'
                         , V_CELLITEM_ID
                         , V_ITEM_ID
                         , V_MEASURE
                         , V_VALUATION_TYPE
                         , V_TO_PRODUCT
                         , V_LINE_ID
                         , V_BOH_QTY_N
                         , V_TO_SITE
                         , V_INCOTERMS
                         , V_SEQ_FLAG
                         , V_YYYYMM
                         , V_MODI_QTY
                         , V_PLAN_TYPE
                         , V_LAST_UPDATED_BY
                         , SYSDATE
                         , V_LAST_UPDATED_BY
                         , SYSDATE );

                END IF;

            END IF;

        END LOOP;

        P_WRITE_LOG(C_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########');

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT '0'            AS CODE
             , 'SUCCESS'      AS MSG
             , V_MAX_LOOP_CNT AS EVENT
             , 'S'            AS RESULT_CODE
             , V_MAX_LOOP_CNT AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            /* 되돌리기를 결과 커서 OPEN 앞에 둔다 */
            V_ERR_MSG := '[' || TO_CHAR(SQLCODE) || ']' || SUBSTR(SQLERRM, 1, 3900);
            ROLLBACK TO SP_SCP0111_ADMIN;
            P_WRITE_ERROR_LOG(C_PROGRAM_NAME, V_ERR_MSG);

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1'                                      AS CODE
                 , V_ERR_MSG                                 AS MSG
                 , 0                                         AS EVENT
                 , 'F'                                       AS RESULT_CODE
                 , 0                                         AS RESULT_CNT
              FROM DUAL;

    END P_SCP0111_SAVE_PSI_ADMIN;

END PKG_SCP0111;