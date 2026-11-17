CREATE OR REPLACE PACKAGE BODY PKG_SCP0037
IS
    /*
     * Program ID   : PKG_SCP0037
     * Description  : SCP0037 Operation LT 화면 — 공정 리드타임 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.27   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS          조회 속도 개선 : 약칭 묶음(IA)을 Operation LT 원장 품목으로 한정(결과 동일)
     */

/****************************************************************************************************/
/* Program ID  : P_SCP0037_GET_OPERATION_LT                                                         */
/* Description : Operation LT 조회                                                                  */
/****************************************************************************************************/
PROCEDURE P_SCP0037_GET_OPERATION_LT
(
    P_DIVISION_ID       IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_SCM_VALID_YN      IN  CLOB
  , P_LT_OPERATION      IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RC2               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    V_DIVISION_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID,   1, 4000));
    V_SCM_SITE_ID       VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SCM_SITE_ID,   1, 4000));
    V_ITEM_ID           VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,       1, 4000));
    V_SCM_VALID_YN      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_SCM_VALID_YN,  1, 4000));
    V_LT_OPERATION      VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_LT_OPERATION,  1, 4000));
BEGIN

    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID                                        AS PLANT_SITE_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , IA.NICK_NAME
             , A.LT_OPERATION
             , B.SEGMENT2                                           AS LT_OPERATION_NM
             , A.LT_DAY
             /* ★원문은 사이트 품목의 사용여부를 한 행만 골라 쓰고 차례를 정하지 않았다.
                   가장 작은 값 · 프로젝트 순으로 맞춰 보았으나 어느 것도 AS-IS 와 같지 않아
                   원문처럼 차례를 정하지 않고 둔다 (재현 대상 아님) */
             , (SELECT XA.VALID_YN
                  FROM SCM_MST_SITE_ITEM XA
                 WHERE XA.DIVISION_ID = A.DIVISION_ID
                   AND XA.SCM_SITE_ID = A.SCM_SITE_ID
                   AND XA.ITEM_ID     = A.ITEM_ID
                   AND ROWNUM         = 1)                          AS SITE_ITEM_VALID_YN
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , NVL(A.ATTRIBUTE1, 'N')                               AS INV_FLAG
          FROM SCP_MST_OPERATION_LT          A
             , SCM_ADM_LOOKUP_MASTER_DETAIL  B
             -- 2026.10.06 AJS 약칭 묶음을 Operation LT 원장 품목으로 한정 (결과 동일) (START)
--             , (SELECT XB.ITEM_ID
--                     , MAX(XB.NICK_NAME)                            AS NICK_NAME
--                  FROM SCM_MST_ITEM_SN XB
--                 GROUP BY XB.ITEM_ID) IA
             , (SELECT /*+ LEADING(XE XB) USE_NL(XB) */
                       XB.ITEM_ID
                     , MAX(XB.NICK_NAME)                            AS NICK_NAME
                  FROM (SELECT DISTINCT
                               XF.ITEM_ID
                          FROM SCP_MST_OPERATION_LT XF) XE
                     , SCM_MST_ITEM_SN XB
                 WHERE XB.ITEM_ID = XE.ITEM_ID
                 GROUP BY XB.ITEM_ID) IA
             -- 2026.10.06 AJS 약칭 묶음을 Operation LT 원장 품목으로 한정 (결과 동일) (END)
         WHERE B.LOOKUP_TYPE  = 'OPERATION_LT'
           AND B.VALID_YN     = 'Y'
           AND B.SEGMENT1     = A.LT_OPERATION
           AND IA.ITEM_ID     = A.ITEM_ID
           AND (TRIM(V_DIVISION_ID) IS NULL
            OR  UPPER(V_DIVISION_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_SCM_SITE_ID) IS NULL
            OR  UPPER(V_SCM_SITE_ID) = 'ALL'                        /* 조회조건 ALL 은 조건 없음 */
            OR  UPPER(A.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE)
                                           FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))))
           AND (TRIM(V_LT_OPERATION) IS NULL
            OR  UPPER(V_LT_OPERATION) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  A.LT_OPERATION IN (SELECT UPPER(COLUMN_VALUE)
                                     FROM TABLE(STRING_SPLIT(V_LT_OPERATION, ','))))
           /* ★품목은 목록에 있거나 별칭이 그 값으로 시작하면 통과한다(원문과 같다) */
           AND (TRIM(V_ITEM_ID) IS NULL
            OR  UPPER(V_ITEM_ID) = 'ALL'                            /* 조회조건 ALL 은 조건 없음 */
            OR  A.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE)
                                FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')))
            OR  EXISTS (SELECT 1
                          FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) XC
                         WHERE IA.NICK_NAME LIKE UPPER(XC.COLUMN_VALUE) || '%'))
           AND (TRIM(V_SCM_VALID_YN) IS NULL
            OR  UPPER(V_SCM_VALID_YN) = 'ALL'                       /* 조회조건 ALL 은 조건 없음 */
            OR  (SELECT XD.VALID_YN
                   FROM SCM_MST_SITE_ITEM XD
                  WHERE XD.DIVISION_ID = A.DIVISION_ID
                    AND XD.SCM_SITE_ID = A.SCM_SITE_ID
                    AND XD.ITEM_ID     = A.ITEM_ID
                    AND ROWNUM         = 1) = V_SCM_VALID_YN)
         /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID)  NULLS FIRST
                , FN_ASIS_SORT_KEY(A.SCM_SITE_ID)  NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID)      NULLS FIRST
                , FN_ASIS_SORT_KEY(A.LT_OPERATION) NULLS FIRST;

    /* validation용 전체조회 */
    OPEN O_RC2 FOR
        SELECT DIVISION_ID
             , SCM_SITE_ID
             , ITEM_ID
             , LT_OPERATION
             , '-'                                                  AS ACTION_FLAG_DIV
          FROM SCP_MST_OPERATION_LT
         /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID)  NULLS FIRST
                , FN_ASIS_SORT_KEY(SCM_SITE_ID)  NULLS FIRST
                , FN_ASIS_SORT_KEY(ITEM_ID)      NULLS FIRST
                , FN_ASIS_SORT_KEY(LT_OPERATION) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0'          AS RESULT_CODE
             , 'SUCCESS'    AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0037_GET_OPERATION_LT;

/****************************************************************************************************/
/* Program ID  : P_SCP0037_SAVE_OPERATION_LT                                                        */
/* Description : Operation LT 등록 · 수정                                                           */
/****************************************************************************************************/
PROCEDURE P_SCP0037_SAVE_OPERATION_LT
(
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_LT_OPERATION      IN  CLOB
  , P_LT_DAY            IN  CLOB
  , P_CREATED_BY        IN  CLOB
  , P_CREATION_DATE     IN  CLOB
  , P_LAST_UPDATED_BY   IN  CLOB
  , P_INV_FLAG          IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID       VARCHAR2(4000 CHAR);
    V_ITEM_ID           VARCHAR2(4000 CHAR);
    V_LT_OPERATION      VARCHAR2(4000 CHAR);
    V_LT_DAY            VARCHAR2(4000 CHAR);
    V_CREATED_BY        VARCHAR2(4000 CHAR);
    V_CREATION_DATE     VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR);
    V_INV_FLAG          VARCHAR2(4000 CHAR);

    /* 값 없음 대체 표시 — 원문이 값 없음을 빈 문자로 다룬다 */
    V_INV_FLAG_SAVE     VARCHAR2(4000 CHAR);

    V_MAX_LOOP_CNT      NUMBER(10) := 0;
    V_MST_LOOP_CNT      NUMBER(10) := 0;
    V_DATA_NO_CNT       NUMBER(10) := 0;
    V_DATA_NO_MSG       VARCHAR2(4000 CHAR);

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0037_SAVE_OPERATION_LT';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    V_SQLERRM           VARCHAR2(4000 CHAR);
    V_SQLCODE           NUMBER;
BEGIN

    /* 시작 시 임시 자료를 비운다 (TRUNCATE 는 암묵 커밋이라 쓰지 않는다) */
    DELETE FROM GT_SCP0037_CHK;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, C_DELIMITER);

    /* 1. Validation 체크(Project Route) */
    WHILE LENGTH(P_ACTIVE_FLAG) > 0
      AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP

        V_MST_LOOP_CNT  := V_MST_LOOP_CNT + 1;

        V_ACTIVE_FLAG   := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,  C_DELIMITER, V_MST_LOOP_CNT);
        V_DIVISION_ID   := SCM_ARR_SPL_VAL(P_DIVISION_ID,  C_DELIMITER, V_MST_LOOP_CNT);
        V_SCM_SITE_ID   := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,  C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID       := SCM_ARR_SPL_VAL(P_ITEM_ID,      C_DELIMITER, V_MST_LOOP_CNT);

        INSERT INTO GT_SCP0037_CHK
                    ( ACTIVE_FLAG, DIVISION_ID, PLANT_SITE_ID, ITEM_ID )
             VALUES ( V_ACTIVE_FLAG, V_DIVISION_ID, V_SCM_SITE_ID, V_ITEM_ID );

    END LOOP;

    IF V_MST_LOOP_CNT > 0
    THEN

        /* project route 체크 */
        V_DATA_NO_CNT := 0;
        V_DATA_NO_MSG := '';

        SELECT COUNT(*)
          INTO V_DATA_NO_CNT
          FROM GT_SCP0037_CHK A
         WHERE A.ACTIVE_FLAG = 'I'
           AND NOT EXISTS (SELECT 1
                             FROM SCM_MST_SITE_ITEM_PRIORITY B
                            WHERE B.DIVISION_ID   = A.DIVISION_ID
                              AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                              AND B.ITEM_ID       = A.ITEM_ID
                              AND B.VALID_YN      = 'Y');

        IF V_DATA_NO_CNT > 0
        THEN

            SELECT IA.NO_MSG
              INTO V_DATA_NO_MSG
              FROM (SELECT A.DIVISION_ID || '/' || A.PLANT_SITE_ID || '/' || A.ITEM_ID AS NO_MSG
                      FROM GT_SCP0037_CHK A
                     WHERE A.ACTIVE_FLAG = 'I'
                       AND NOT EXISTS (SELECT 1
                                         FROM SCM_MST_SITE_ITEM_PRIORITY B
                                        WHERE B.DIVISION_ID   = A.DIVISION_ID
                                          AND B.PLANT_SITE_ID = A.PLANT_SITE_ID
                                          AND B.ITEM_ID       = A.ITEM_ID
                                          AND B.VALID_YN      = 'Y')) IA
             WHERE ROWNUM = 1;

            /* ★원문은 검증 오류를 잡아 결과코드 'N' 과 그 문구를 돌려준다(그 밖 오류는 'F').
                  돌려주는 코드가 달라 여기서 바로 'N' 으로 끝낸다 */
            ROLLBACK;

            OPEN O_RC1 FOR
                SELECT 'N'  AS RESULT_CODE
                     , 'Project Route 정보가 없습니다. ' || V_DATA_NO_MSG AS RESULT_CNT
                  FROM DUAL;

            OPEN O_RESULT_CURSOR FOR
                SELECT 'Project Route 정보가 없습니다. ' || V_DATA_NO_MSG AS ERR_MESSAGE
                  FROM DUAL;

            RETURN;

        END IF;

    END IF;

    V_MST_LOOP_CNT := 0;

    WHILE LENGTH(P_ACTIVE_FLAG) > 0
      AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP

        V_MST_LOOP_CNT      := V_MST_LOOP_CNT + 1;

        V_ACTIVE_FLAG       := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,     C_DELIMITER, V_MST_LOOP_CNT);
        V_DIVISION_ID       := SCM_ARR_SPL_VAL(P_DIVISION_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_SCM_SITE_ID       := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID           := SCM_ARR_SPL_VAL(P_ITEM_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_LT_OPERATION      := SCM_ARR_SPL_VAL(P_LT_OPERATION,    C_DELIMITER, V_MST_LOOP_CNT);
        V_LT_DAY            := SCM_ARR_SPL_VAL(P_LT_DAY,          C_DELIMITER, V_MST_LOOP_CNT);
        V_CREATED_BY        := SCM_ARR_SPL_VAL(P_CREATED_BY,      C_DELIMITER, V_MST_LOOP_CNT);
        V_CREATION_DATE     := SCM_ARR_SPL_VAL(P_CREATION_DATE,   C_DELIMITER, V_MST_LOOP_CNT);
        V_LAST_UPDATED_BY   := SCM_ARR_SPL_VAL(P_LAST_UPDATED_BY, C_DELIMITER, V_MST_LOOP_CNT);
        V_INV_FLAG          := SCM_ARR_SPL_VAL(P_INV_FLAG,        C_DELIMITER, V_MST_LOOP_CNT);

        /* 재고 표시가 N 이면 값을 넣지 않는다(원문 IIF 와 같다) */
        V_INV_FLAG_SAVE := CASE WHEN V_INV_FLAG = 'N' THEN NULL ELSE V_INV_FLAG END;

        /* 이력저장
           ★원문은 `@v_inv_flag = NULL OR @v_inv_flag = ''` 로 견준다. 앞 조건은 MSSQL 에서 늘 거짓이라
             실제로는 값이 없을 때만 선행 프로시저를 부른다. 원문과 같게 옮겼다 */
        IF V_INV_FLAG IS NULL
        THEN

            PR_SCP_MST_OPERATION_LT_HIST(V_DIVISION_ID, V_SCM_SITE_ID, V_ITEM_ID, V_LT_OPERATION
                                       , V_LT_DAY, V_CREATED_BY, V_CREATION_DATE, V_LAST_UPDATED_BY);

        ELSE

            INSERT INTO SCP_MST_OPERATION_LT_H
                        (
                          HISTORY_SEQ
                        , DIVISION_ID
                        , SCM_SITE_ID
                        , ITEM_ID
                        , LT_OPERATION
                        , LT_DAY
                        , CREATED_BY
                        , CREATION_DATE
                        , LAST_UPDATED_BY
                        , LAST_UPDATE_DATE
                        , ATTRIBUTE1
                        , HISTORY_CREATION_DATE
                        )
                 VALUES (
                          SEQ1_SCP_MST_OPERATION_LT_H.NEXTVAL
                        , V_DIVISION_ID
                        , V_SCM_SITE_ID
                        , V_ITEM_ID
                        , V_LT_OPERATION
                        , TO_NUMBER(V_LT_DAY)
                        , V_CREATED_BY
                        /* ★새 행이면 화면이 빈 값을 보내고 MSSQL 은 빈 문자를 1900-01-01 로 바꾼다.
                              기준 데이터베이스는 칸이 값을 요구해 같은 날짜로 맞춘다 */
                        , CASE WHEN TRIM(V_CREATION_DATE) IS NULL
                               THEN DATE '1900-01-01'
                               ELSE TO_DATE(SUBSTR(V_CREATION_DATE, 1, 19), 'YYYY-MM-DD HH24:MI:SS')
                          END
                        , V_LAST_UPDATED_BY
                        , SYSDATE
                        , V_INV_FLAG_SAVE
                        , SYSDATE
                        );

        END IF;

        /* 데이터 저장
           ★원문은 MERGE 한 문장이다. 온라인 SQL 에서 MERGE 를 쓰지 않는 규칙이라
             먼저 고치고 고친 행이 없으면 넣는 두 문장으로 나눴다 */
        IF V_MST_LOOP_CNT > 0
        THEN

            UPDATE SCP_MST_OPERATION_LT
               SET LT_DAY           = TO_NUMBER(V_LT_DAY)
                 , ATTRIBUTE1       = V_INV_FLAG_SAVE
                 , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID      = V_DIVISION_ID
               AND SCM_SITE_ID      = V_SCM_SITE_ID
               AND ITEM_ID          = V_ITEM_ID
               AND LT_OPERATION     = V_LT_OPERATION;

            IF SQL%ROWCOUNT = 0
            THEN

                INSERT INTO SCP_MST_OPERATION_LT
                            (
                              DIVISION_ID
                            , SCM_SITE_ID
                            , ITEM_ID
                            , LT_OPERATION
                            , LT_DAY
                            , CREATED_BY
                            , CREATION_DATE
                            , LAST_UPDATED_BY
                            , LAST_UPDATE_DATE
                            , ATTRIBUTE1
                            )
                     VALUES (
                              V_DIVISION_ID
                            , V_SCM_SITE_ID
                            , V_ITEM_ID
                            , V_LT_OPERATION
                            , TO_NUMBER(V_LT_DAY)
                            , V_CREATED_BY
                            , SYSDATE
                            , V_CREATED_BY
                            , SYSDATE
                            , V_INV_FLAG_SAVE
                            );

            END IF;

        END IF;

    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드, 결과 카운트 반환 */
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
        V_SQLCODE := SQLCODE;

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

        /* 원문은 오류 번호를 대괄호로 감싸 문구 앞에 붙인다 */
        OPEN O_RESULT_CURSOR FOR
            SELECT '[' || TO_CHAR(V_SQLCODE) || ']' || SUBSTR(V_SQLERRM, 1, 4000) AS ERR_MESSAGE
              FROM DUAL;

END P_SCP0037_SAVE_OPERATION_LT;

END PKG_SCP0037;
