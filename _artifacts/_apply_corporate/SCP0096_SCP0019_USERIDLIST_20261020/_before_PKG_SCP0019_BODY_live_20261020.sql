PACKAGE BODY PKG_SCP0019 IS

    /*
     * Program ID   : PKG_SCP0019
     * Description  : Working Time 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS          P_SCP0019_GET_WORKING_TIME 조회 속도 개선(최종 입력일 하위질의를 키 단위 인덱스 조회로 고정)
     */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    V_DELIMITER  CONSTANT VARCHAR2(1 CHAR) := '^';


    /*==================================================================================================*
     * 내부 : 구분자로 묶여 온 값을 토막낸다
     *        AS-IS SCM_ARR_SPL_VAL(토큰 앞뒤 공백 제거) 과 같은 결과
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
                IF V_POS <= V_LEN THEN
                    O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_LEN - V_POS + 1, V_POS));
                ELSE
                    O_TAB(O_CNT) := NULL;
                END IF;
                EXIT;
            END IF;

            IF V_NEXT > V_POS THEN
                O_TAB(O_CNT) := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_NEXT - V_POS, V_POS));
            ELSE
                O_TAB(O_CNT) := NULL;
            END IF;

            V_POS := V_NEXT + 1;
        END LOOP;
    END P_SPLIT;


    /* 내부 : 토막 꺼내기 (범위 밖이면 NULL) */
    FUNCTION F_TK
    (
        P_TAB  IN  T_TOKEN_TAB,
        P_IDX  IN  PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX) THEN
            RETURN P_TAB(P_IDX);
        END IF;
        RETURN NULL;
    END F_TK;


    /* 내부 : AS-IS nvarchar -> numeric 암시 변환
     *        AS-IS 는 빈 값 · 공백을 0 으로 바꾸어 넣는다(문자를 숫자 칸에 넣을 때의 암시 변환).
     *        숫자로 읽을 수 없는 값은 변환 오류. */
    FUNCTION F_TO_NUM
    (
        P_VALUE  IN  VARCHAR2
    )
    RETURN NUMBER
    IS
        V_TXT  VARCHAR2(4000 CHAR) := TRIM(P_VALUE);
    BEGIN
        IF V_TXT IS NULL THEN
            RETURN 0;
        END IF;

        IF NOT REGEXP_LIKE(V_TXT, '^[+-]?([0-9]+)(\.[0-9]*)?$') THEN
            RAISE_APPLICATION_ERROR(-20245, 'Conversion failed when converting the nvarchar value '''
                                            || SUBSTR(P_VALUE, 1, 200) || ''' to data type numeric.');
        END IF;

        RETURN TO_NUMBER(V_TXT);
    END F_TO_NUM;


    /*==================================================================================================*
     * 내부 : Working Time 이력 기록 (AS-IS PR_SCP_MST_WORKING_TIME_HIST)
     *        AS-IS 에서 이 화면의 저장만 부르는 프로시저라 패키지 안으로 들인다.
     *==================================================================================================*/
    PROCEDURE P_WORKING_TIME_HIST
    (
        P_DIVISION_ID      IN  VARCHAR2,
        P_PLANT_SITE_ID    IN  VARCHAR2,
        P_FACTORY_ID       IN  VARCHAR2,
        P_OPERATION_ID     IN  VARCHAR2,
        P_LINE_ID          IN  VARCHAR2,
        P_YYYYMMDD         IN  VARCHAR2,
        P_WORKING_TIME     IN  VARCHAR2,
        P_CREATED_BY       IN  VARCHAR2,
        P_CREATION_DATE    IN  DATE,
        P_LAST_UPDATED_BY  IN  VARCHAR2
    )
    IS
        V_HISTORY_SEQ   NUMBER;
        V_WORKING_TIME  NUMBER := F_TO_NUM(P_WORKING_TIME);
    BEGIN
        SELECT SEQ1_SCP_MST_WORKING_TIME_H.NEXTVAL
          INTO V_HISTORY_SEQ
          FROM DUAL;

        INSERT INTO SCP_MST_WORKING_TIME_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PLANT_SITE_ID
             , FACTORY_ID
             , OPERATION_ID
             , LINE_ID
             , YYYYMMDD
             , WORKING_TIME
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        VALUES
             ( V_HISTORY_SEQ
             , P_DIVISION_ID
             , P_PLANT_SITE_ID
             , P_FACTORY_ID
             , P_OPERATION_ID
             , P_LINE_ID
             , P_YYYYMMDD
             , V_WORKING_TIME
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE
             );
    END P_WORKING_TIME_HIST;


    /*==================================================================================================*
     * Working Time 조회 (AS-IS SCP0019_GET_WORKING_TIME)
     *
     * AS-IS 2021.09.14 [PJ20209643] 로 「외주만 조회/수정 가능하도록 변경」되어
     * 자사 라인 갈래(SCM_MST_LINE_SN 기준)는 주석 처리되어 있다. 살아 있는 갈래는 둘이다.
     *   갈래 1 : 라인을 등록하지 않은 외주사        (SCM_MST_SITE.ATTRIBUTE1 <> 'Y')
     *   갈래 2 : 라인을 등록한 외주사              (SCM_MST_SITE.ATTRIBUTE1  = 'Y' + SCM_MST_LINE_OSP)
     *
     * AS-IS 는 대문자와 소문자를 가리지 않고 견주므로 조회조건 입력값을 대문자로 맞춘다.
     * 조회조건 목록에서 'ALL' 을 고르면 그 조건을 걸지 않는다(대문자 · 소문자 가리지 않음).
     * 원장 칸에는 소문자가 한 건도 없어(사이트 · 라인 · 공정 · 사업부 전건 실측) 칸 쪽은 그대로 둔다.
     *==================================================================================================*/
    PROCEDURE P_SCP0019_GET_WORKING_TIME
    (
        P_FROM_YYYYMMDD   IN  VARCHAR2,
        P_TO_YYYYMMDD     IN  VARCHAR2,
        P_DIVISION_ID     IN  VARCHAR2,
        P_PLANT_SITE_ID   IN  VARCHAR2,
        P_FACTORY_ID      IN  VARCHAR2,
        P_OPERATION_ID    IN  VARCHAR2,
        P_LINE_ID         IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_COL_SQL   CLOB := EMPTY_CLOB();
        V_SQL       CLOB := EMPTY_CLOB();
        V_ERR_CODE  NUMBER;
        V_ERR_MSG   VARCHAR2(4000 CHAR);
    BEGIN
        /* 임시 적재분 비우기 — 같은 접속에서 다시 조회할 때 앞 결과가 남지 않게 한다 */
        DELETE
          FROM GT_SCP0019_PIVOT;

        INSERT INTO GT_SCP0019_PIVOT
             ( DIVISION_ID
             , PLANT_SITE_ID
             , FACTORY_ID
             , FACTORY_NAME
             , OPERATION_ID
             , OPERATION_NAME
             , LINE_ID
             , LINE_NAME
             , WORKING_TIME_DEFAULT
             , LAST_INPUT_DATE
             , MEASURE
             , YYYYMMDD
             , YYYYMM
             , ISO_WEEK
             , QTY
             , OSP_YN
             )
        SELECT IA.DIVISION_ID
             , IA.PLANT_SITE_ID
             , IA.FACTORY_ID
             , IA.FACTORY_NAME
             , IA.OPERATION_ID
             , IA.OPERATION_NAME
             , IA.LINE_ID
             , IA.LINE_NAME
             , C.WORKING_TIME_DEFAULT
--             , (SELECT MAX(SA.YYYYMMDD)   --  2026.10.06 AJS
             , (SELECT /*+ NO_UNNEST INDEX(SA PK_SCP_MST_WORKING_TIME) */ MAX(SA.YYYYMMDD)   --  2026.10.06 AJS
                  FROM SCP_MST_WORKING_TIME SA
                 WHERE SA.DIVISION_ID   = IA.DIVISION_ID
                   AND SA.PLANT_SITE_ID = IA.PLANT_SITE_ID
                   AND SA.FACTORY_ID    = IA.FACTORY_ID
                   AND SA.OPERATION_ID  = IA.OPERATION_ID
                   AND SA.LINE_ID       = IA.LINE_ID
                   AND SA.WORKING_TIME IS NOT NULL)          AS LAST_INPUT_DATE
             , IA.MEASURE
             , 'D_' || IA.YYYYMMDD                           AS YYYYMMDD
             , IA.YYYYMM
             , IA.ISO_WEEK
             , B.WORKING_TIME                                AS QTY
             , IA.OSP_YN
          FROM (
                /* 외주 packer 추가 (2018.04.19) */
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.SCM_SITE_ID                         AS PLANT_SITE_ID
                     , '-'                                   AS FACTORY_ID
                     , A.PLANT_ID                            AS OPERATION_ID
                     , '-'                                   AS LINE_ID
                     , '-'                                   AS LINE_NAME
                     , '-'                                   AS FACTORY_NAME
                     , A.PLANT_ID                            AS OPERATION_NAME
                     , 'Working Time(Min)'                   AS MEASURE
                     , B.BASIS_YYYYMMDD                      AS YYYYMMDD
                     , B.BASIS_YYYYMM                        AS YYYYMM
                     , SUBSTR(B.BASIS_YYYYMM, -2) || B.ISO_WEEK  AS ISO_WEEK
                     , 'VENDOR'                              AS OPERATION
                     , A.OSP_YN
                  FROM SCM_MST_SITE A
                     , SCM_SYS_CALENDAR_M B
                 WHERE B.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND B.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.SITE_TYPE       = 'PLANT'
                   AND A.VALID_YN        = 'Y'
                   AND A.OSP_YN          = 'Y'
                   AND NVL(A.ATTRIBUTE1, 'N') <> 'Y'         /* line 등록 외주사 제외 */
                   AND ( UPPER(P_DIVISION_ID) = 'ALL'
                         OR A.DIVISION_ID = UPPER(P_DIVISION_ID) )
                   AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                         OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                         OR A.SCM_SITE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL)
                                                FROM DUAL
                                             CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                 UNION
                /* line 등록 외주 추가 (2020.02.06) */
                SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID                         AS PLANT_SITE_ID
                     , '-'                                   AS FACTORY_ID
                     , B.OPERATION_ID                        AS OPERATION_ID
                     , B.LINE_ID
                     , B.LINE_NAME
                     , '-'                                   AS FACTORY_NAME
                     , B.OPERATION_ID                        AS OPERATION_NAME
                     , 'Working Time(Min)'                   AS MEASURE
                     , C.BASIS_YYYYMMDD                      AS YYYYMMDD
                     , C.BASIS_YYYYMM                        AS YYYYMM
                     , SUBSTR(C.BASIS_YYYYMM, -2) || C.ISO_WEEK  AS ISO_WEEK
                     , B.OPERATION_ID                        AS OPERATION
                     , A.OSP_YN
                  FROM SCM_MST_SITE A
                     , SCM_MST_LINE_OSP B
                     , SCM_SYS_CALENDAR_M C
                 WHERE B.DIVISION_ID     = A.DIVISION_ID
                   AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                   AND C.BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                   AND C.BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                   AND A.SITE_TYPE       = 'PLANT'
                   AND A.VALID_YN        = 'Y'
                   AND A.OSP_YN          = 'Y'
                   AND NVL(A.ATTRIBUTE1, 'N') = 'Y'
                   AND ( UPPER(P_DIVISION_ID) = 'ALL'
                         OR A.DIVISION_ID = UPPER(P_DIVISION_ID) )
                   AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                         OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                         OR A.SCM_SITE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL)
                                                FROM DUAL
                                             CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                   AND ( TRIM(P_LINE_ID) IS NULL
                         OR UPPER(P_LINE_ID) = 'ALL'
                         OR B.LINE_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_LINE_ID), '[^,]+', 1, LEVEL)
                                            FROM DUAL
                                         CONNECT BY REGEXP_SUBSTR(UPPER(P_LINE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
               ) IA
             , SCP_MST_WORKING_TIME B
             , SCP_MST_WORKING_TIME_DEFAULT C
         WHERE B.DIVISION_ID(+)   = IA.DIVISION_ID
           AND B.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
           AND B.FACTORY_ID(+)    = IA.FACTORY_ID
           AND B.OPERATION_ID(+)  = IA.OPERATION_ID
           AND B.LINE_ID(+)       = IA.LINE_ID
           AND B.YYYYMMDD(+)      = IA.YYYYMMDD
           AND C.DIVISION_ID(+)   = IA.DIVISION_ID
           AND C.PLANT_SITE_ID(+) = IA.PLANT_SITE_ID
           AND C.FACTORY_ID(+)    = IA.FACTORY_ID
           AND C.OPERATION_ID(+)  = IA.OPERATION_ID
           AND C.LINE_ID(+)       = IA.LINE_ID
           AND ( TRIM(P_OPERATION_ID) IS NULL
                 OR UPPER(P_OPERATION_ID) = 'ALL'
                 OR IA.OPERATION IN (SELECT REGEXP_SUBSTR(UPPER(P_OPERATION_ID), '[^,]+', 1, LEVEL)
                                       FROM DUAL
                                    CONNECT BY REGEXP_SUBSTR(UPPER(P_OPERATION_ID), '[^,]+', 1, LEVEL) IS NOT NULL) );

        /*==============================================================================================*
         * 칸 펼치기
         * 기간 안의 일자마다 칸이 하나씩 생기므로 칸 구성을 실행 시점에 만든다.
         * (AS-IS 도 같은 이유로 조회문을 실행 시점에 조립한다)
         *==============================================================================================*/
        FOR C1 IN (SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                     FROM SCM_SYS_CALENDAR_M A
                    WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                    GROUP BY A.BASIS_YYYYMMDD
                    ORDER BY A.BASIS_YYYYMMDD)
        LOOP
            V_COL_SQL := V_COL_SQL || '     , SUM(CASE WHEN YYYYMMDD = ''' || C1.YYYYMMDD
                                   || ''' THEN QTY END) AS ' || C1.YYYYMMDD || CHR(10);
        END LOOP;

        V_SQL := 'SELECT IA.*' || CHR(10)
              || '  FROM (' || CHR(10)
              || 'SELECT DIVISION_ID' || CHR(10)
              || '     , PLANT_SITE_ID' || CHR(10)
              || '     , FACTORY_ID' || CHR(10)
              || '     , FACTORY_NAME' || CHR(10)
              || '     , OPERATION_ID' || CHR(10)
              || '     , OPERATION_NAME' || CHR(10)
              || '     , LINE_ID' || CHR(10)
              || '     , LINE_NAME' || CHR(10)
              || '     , MEASURE' || CHR(10)
              || '     , OSP_YN' || CHR(10)
              || '     , (SELECT SA.DIVISION_NAME FROM SCM_MST_DIVISION SA'
              || ' WHERE SA.DIVISION_ID = A.DIVISION_ID AND ROWNUM = 1) AS DIVISION_NAME' || CHR(10)
              || '     , (SELECT MAX(SA.SITE_DESCRIPTION) FROM SCM_MST_SITE SA'
              || ' WHERE SA.SCM_SITE_ID = A.PLANT_SITE_ID) AS PLANT_SITE_NAME' || CHR(10)
              || '     , WORKING_TIME_DEFAULT' || CHR(10)
              || '     , LAST_INPUT_DATE' || CHR(10)
              || V_COL_SQL
              || '  FROM GT_SCP0019_PIVOT A' || CHR(10)
              || ' GROUP BY DIVISION_ID' || CHR(10)
              || '        , PLANT_SITE_ID' || CHR(10)
              || '        , FACTORY_ID' || CHR(10)
              || '        , FACTORY_NAME' || CHR(10)
              || '        , OPERATION_ID' || CHR(10)
              || '        , OPERATION_NAME' || CHR(10)
              || '        , WORKING_TIME_DEFAULT' || CHR(10)
              || '        , LINE_ID' || CHR(10)
              || '        , LINE_NAME' || CHR(10)
              || '        , LAST_INPUT_DATE' || CHR(10)
              || '        , MEASURE' || CHR(10)
              || '        , OSP_YN' || CHR(10)
              || '       ) IA' || CHR(10)
              /* 정렬 : AS-IS(MSSQL)와 줄 세우는 방식을 맞춘다.
               *        1) 오름차순에서 빈 값이 앞, 내림차순에서 뒤 (Oracle 기본은 반대)
               *        2) 대문자와 소문자를 가리지 않는다
               *        3) 하이픈 · 밑줄 같은 기호를 빼고(띄어쓰기는 남긴다) 먼저 견준 뒤, 같으면 원래 값으로 다시 견준다
               *           (그렇게 하지 않으면 Peopleworks_CN 과 PeopleWorks-KR-1,
               *            PeopleWorks-US CHI 와 PeopleWorks-US-AZ 의 앞뒤가 뒤바뀐다) */
              || ' ORDER BY IA.LAST_INPUT_DATE NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.DIVISION_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.DIVISION_NAME, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.PLANT_SITE_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.PLANT_SITE_NAME, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.FACTORY_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.FACTORY_NAME, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.OPERATION_NAME, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)   /* PJ20202001 : operation_name asc => desc 수정 */
              || '        , NLSSORT(IA.OPERATION_NAME, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
              || '        , NLSSORT(REGEXP_REPLACE(IA.LINE_ID, ''[^[:alnum:] ]'', ''''), ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.LINE_ID, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.MEASURE, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10)
              || '        , NLSSORT(IA.OSP_YN, ''NLS_SORT=BINARY_CI'') NULLS FIRST' || CHR(10);

        OPEN O_RC1 FOR V_SQL;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'        AS CODE
             , 'SUCCESS'  AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := SQLCODE;
            V_ERR_MSG  := SQLERRM;

            OPEN O_RESULT_CURSOR FOR
            SELECT TO_CHAR(V_ERR_CODE)  AS CODE
                 , V_ERR_MSG            AS MSG
              FROM DUAL;
    END P_SCP0019_GET_WORKING_TIME;


    /*==================================================================================================*
     * Working Time 등록 · 수정 · 삭제 (AS-IS SCP0019_SAVE_WORKING_TIME_ROW)
     *
     *   P_IS_SAVE_DEFAULT = 'N' : SCP_MST_WORKING_TIME        (이력도 함께 기록)
     *   P_IS_SAVE_DEFAULT = 'Y' : SCP_MST_WORKING_TIME_DEFAULT (이력 없음 — AS-IS 와 같다)
     *   P_ACTIVE_FLAG     = 'M' 또는 'I' : 있으면 고치고 없으면 넣는다 / 'D' : 지운다
     *==================================================================================================*/
    PROCEDURE P_SCP0019_SAVE_WORKING_TIME_ROW
    (
        P_ACTIVE_FLAG            IN  CLOB,
        P_DIVISION_ID            IN  CLOB,
        P_PLANT_SITE_ID          IN  CLOB,
        P_FACTORY_ID             IN  CLOB,
        P_OPERATION_ID           IN  CLOB,
        P_LINE_ID                IN  CLOB,
        P_YYYYMMDD               IN  CLOB,
        P_WORKING_TIME           IN  CLOB,
        P_IS_SAVE_DEFAULT        IN  CLOB,
        P_WORKING_TIME_DEFAULT   IN  CLOB,
        P_USER_ID                IN  VARCHAR2,
        O_RESULT_CURSOR          OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'PKG_SCP0019.P_SCP0019_SAVE_WORKING_TIME_ROW';

        T_ACTIVE_FLAG          T_TOKEN_TAB;
        T_DIVISION_ID          T_TOKEN_TAB;
        T_PLANT_SITE_ID        T_TOKEN_TAB;
        T_FACTORY_ID           T_TOKEN_TAB;
        T_OPERATION_ID         T_TOKEN_TAB;
        T_LINE_ID              T_TOKEN_TAB;
        T_YYYYMMDD             T_TOKEN_TAB;
        T_WORKING_TIME         T_TOKEN_TAB;
        T_IS_SAVE_DEFAULT      T_TOKEN_TAB;
        T_WORKING_TIME_DEFAULT T_TOKEN_TAB;

        V_MAX_LOOP_CNT  PLS_INTEGER := 0;
        V_CNT           PLS_INTEGER;

        V_ACTIVE_FLAG          VARCHAR2(4000 CHAR);
        V_DIVISION_ID          VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID        VARCHAR2(4000 CHAR);
        V_FACTORY_ID           VARCHAR2(4000 CHAR);
        V_OPERATION_ID         VARCHAR2(4000 CHAR);
        V_LINE_ID              VARCHAR2(4000 CHAR);
        V_YYYYMMDD             VARCHAR2(4000 CHAR);
        V_WORKING_TIME         VARCHAR2(4000 CHAR);
        V_IS_SAVE_DEFAULT      VARCHAR2(4000 CHAR);
        V_WORKING_TIME_DEFAULT VARCHAR2(4000 CHAR);

        V_WT_NUM               NUMBER;
        V_WTD_NUM              NUMBER;

        V_CREATION_DATE  DATE := SYSDATE;
        V_ROW_CNT        PLS_INTEGER := 0;
        V_ERR_CODE       NUMBER;
        V_ERR_MESSAGE    VARCHAR2(4000 CHAR);
    BEGIN
        SAVEPOINT SP_SCP0019_SAVE;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0,
                                       '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT(P_ACTIVE_FLAG,          V_DELIMITER, T_ACTIVE_FLAG,          V_CNT);
        V_MAX_LOOP_CNT := GREATEST(V_MAX_LOOP_CNT, V_CNT);
        P_SPLIT(P_DIVISION_ID,          V_DELIMITER, T_DIVISION_ID,          V_CNT);
        P_SPLIT(P_PLANT_SITE_ID,        V_DELIMITER, T_PLANT_SITE_ID,        V_CNT);
        P_SPLIT(P_FACTORY_ID,           V_DELIMITER, T_FACTORY_ID,           V_CNT);
        P_SPLIT(P_OPERATION_ID,         V_DELIMITER, T_OPERATION_ID,         V_CNT);
        P_SPLIT(P_LINE_ID,              V_DELIMITER, T_LINE_ID,              V_CNT);
        P_SPLIT(P_YYYYMMDD,             V_DELIMITER, T_YYYYMMDD,             V_CNT);
        P_SPLIT(P_WORKING_TIME,         V_DELIMITER, T_WORKING_TIME,         V_CNT);
        P_SPLIT(P_IS_SAVE_DEFAULT,      V_DELIMITER, T_IS_SAVE_DEFAULT,      V_CNT);
        P_SPLIT(P_WORKING_TIME_DEFAULT, V_DELIMITER, T_WORKING_TIME_DEFAULT, V_CNT);

        FOR I IN 1 .. V_MAX_LOOP_CNT
        LOOP
            V_ACTIVE_FLAG          := F_TK(T_ACTIVE_FLAG,          I);

            IF TRIM(V_ACTIVE_FLAG) IS NULL THEN
                CONTINUE;
            END IF;

            V_DIVISION_ID          := F_TK(T_DIVISION_ID,          I);
            V_PLANT_SITE_ID        := F_TK(T_PLANT_SITE_ID,        I);
            V_FACTORY_ID           := F_TK(T_FACTORY_ID,           I);
            V_OPERATION_ID         := F_TK(T_OPERATION_ID,         I);
            V_LINE_ID              := F_TK(T_LINE_ID,              I);
            V_YYYYMMDD             := F_TK(T_YYYYMMDD,             I);
            V_WORKING_TIME         := F_TK(T_WORKING_TIME,         I);
            V_IS_SAVE_DEFAULT      := F_TK(T_IS_SAVE_DEFAULT,      I);
            V_WORKING_TIME_DEFAULT := F_TK(T_WORKING_TIME_DEFAULT, I);

            V_WT_NUM  := F_TO_NUM(V_WORKING_TIME);
            V_WTD_NUM := F_TO_NUM(V_WORKING_TIME_DEFAULT);

            /* WORKING TIME 저장 */
            IF NVL(V_IS_SAVE_DEFAULT, 'N') = 'N' THEN

                /* 이력저장 */
                P_WORKING_TIME_HIST(V_DIVISION_ID, V_PLANT_SITE_ID, V_FACTORY_ID, V_OPERATION_ID,
                                    V_LINE_ID, V_YYYYMMDD, V_WORKING_TIME, P_USER_ID,
                                    V_CREATION_DATE, P_USER_ID);

                IF UPPER(V_ACTIVE_FLAG) IN ('M', 'I') THEN

                    UPDATE SCP_MST_WORKING_TIME
                       SET WORKING_TIME     = V_WT_NUM
                         , LAST_UPDATED_BY  = P_USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID
                       AND YYYYMMDD      = V_YYYYMMDD;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_MST_WORKING_TIME
                             ( DIVISION_ID
                             , PLANT_SITE_ID
                             , FACTORY_ID
                             , OPERATION_ID
                             , LINE_ID
                             , YYYYMMDD
                             , WORKING_TIME
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             )
                        VALUES
                             ( V_DIVISION_ID
                             , V_PLANT_SITE_ID
                             , V_FACTORY_ID
                             , V_OPERATION_ID
                             , V_LINE_ID
                             , V_YYYYMMDD
                             , V_WT_NUM
                             , P_USER_ID
                             , SYSDATE
                             , P_USER_ID
                             , SYSDATE
                             );
                    END IF;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_MST_WORKING_TIME
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID
                       AND YYYYMMDD      = V_YYYYMMDD;

                END IF;

            /* WORKING TIME DEFAULT 저장 */
            ELSE

                IF UPPER(V_ACTIVE_FLAG) IN ('M', 'I') THEN

                    UPDATE SCP_MST_WORKING_TIME_DEFAULT
                       SET WORKING_TIME_DEFAULT = V_WTD_NUM
                         , LAST_UPDATED_BY      = P_USER_ID
                         , LAST_UPDATE_DATE     = SYSDATE
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID;

                    IF SQL%ROWCOUNT = 0 THEN
                        INSERT INTO SCP_MST_WORKING_TIME_DEFAULT
                             ( DIVISION_ID
                             , PLANT_SITE_ID
                             , FACTORY_ID
                             , OPERATION_ID
                             , LINE_ID
                             , WORKING_TIME_DEFAULT
                             , VALID_YN
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE
                             )
                        VALUES
                             ( V_DIVISION_ID
                             , V_PLANT_SITE_ID
                             , V_FACTORY_ID
                             , V_OPERATION_ID
                             , V_LINE_ID
                             , V_WTD_NUM
                             , 'Y'
                             , P_USER_ID
                             , SYSDATE
                             , P_USER_ID
                             , SYSDATE
                             );
                    END IF;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_MST_WORKING_TIME_DEFAULT
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PLANT_SITE_ID = V_PLANT_SITE_ID
                       AND FACTORY_ID    = V_FACTORY_ID
                       AND OPERATION_ID  = V_OPERATION_ID
                       AND LINE_ID       = V_LINE_ID;

                END IF;

            END IF;

            V_ROW_CNT := V_ROW_CNT + 1;

        END LOOP;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', V_ROW_CNT,
                                       '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT 'S'        AS RESULT_CODE
             , V_ROW_CNT  AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SCP0019_SAVE;

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
                 , LAST_UPDATED_BY
                 )
            VALUES
                 ( V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , V_ERR_MESSAGE
                 , NULL
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME
                 );

            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RESULT_CURSOR FOR
            SELECT 'F'            AS RESULT_CODE
                 , V_ERR_CODE     AS ERR_CODE
                 , V_ERR_MESSAGE  AS ERR_MESSAGE
              FROM DUAL;
    END P_SCP0019_SAVE_WORKING_TIME_ROW;

END PKG_SCP0019;