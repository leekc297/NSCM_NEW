PACKAGE BODY         PKG_SCP0041 IS

    /*
     * Program ID   : PKG_SCP0041
     * Description  : Stock OSP 조회 · 보류재고 조회 · 보류재고 저장 · 엑셀 올리기
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.24   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.08   AJS            조회조건 Model/Nickname : 후보 품목 비교를 MEMBER OF 에서 IN (TABLE()) 로 변경(결과 동일·속도)
     */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    V_DELIMITER  CONSTANT VARCHAR2(1 CHAR) := '^';


    /* 내부 : 구분자로 묶여 온 값을 토막낸다 (AS-IS SCM_ARR_SPL_VAL 과 같은 결과) */
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


    /* 내부 : AS-IS nvarchar -> numeric 암시 변환 (빈 값 · 공백 = 0) */
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
     * Stock OSP 조회 (AS-IS SCP0041_GET_STOCK_OSP)
     *
     * AS-IS 는 대문자와 소문자를 가리지 않고 견주므로 조회조건 입력값을 대문자로 맞춘다.
     * 조회조건 목록에서 'ALL' 을 고르면 그 조건을 걸지 않는다(대문자 · 소문자 가리지 않음).
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.08   AJS            조회조건 Model/Nickname : 후보 품목 비교를 MEMBER OF 에서 IN (TABLE()) 로 변경(결과 동일·속도)
     *==================================================================================================*/
    PROCEDURE P_SCP0041_GET_STOCK_OSP
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_PLANT_SITE_ID   IN  VARCHAR2,
        P_ITEM_ID         IN  VARCHAR2,
        P_FROM_YYYYMMDD   IN  VARCHAR2,
        P_TO_YYYYMMDD     IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_ERR_CODE  NUMBER;
        V_ERR_MSG   VARCHAR2(4000 CHAR);
        V_ITEM_TAB  T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 품목 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다 */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT DISTINCT ITEM_ID
                      FROM SCM_DNM_STOCK_OSP
                     WHERE DIVISION_ID = UPPER(P_DIVISION_ID)) IA
             WHERE EXISTS (SELECT 1
                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                            WHERE SA.COLUMN_VALUE IS NOT NULL
                              AND (   UPPER(IA.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
                                   OR EXISTS (SELECT 1
                                                FROM SCM_MST_ITEM_SN XA
                                               WHERE XA.ITEM_ID = IA.ITEM_ID
                                                 AND UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%')));
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */
        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , B.SITE_DESCRIPTION
             , A.ITEM_ID
             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID)                    AS NICK_NAME
             , SUBSTR(A.YYYYMMDD, 1, 4) || '-' || SUBSTR(A.YYYYMMDD, 5, 2)
               || '-' || SUBSTR(A.YYYYMMDD, 7, 2)                                AS YYYYMMDD
             , A.ATTRIBUTE1                                       /* Valuation Type 컬럼추가 */
             , A.QTY
             , A.ATTRIBUTE2                                       /* Cell From Site 컬럼추가 */
             , A."COMMENT"                                      /* COMMENT 는 Oracle 예약어라 따옴표로 감싼다 */
             , A.ATTRIBUTE3                                       /* Box 컬럼추가 */
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SCM_DNM_STOCK_OSP A
             , SCM_MST_SITE B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.SCM_SITE_ID = A.SCM_SITE_ID
           AND A.DIVISION_ID = UPPER(P_DIVISION_ID)
           AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                 OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                 OR UPPER(A.SCM_SITE_ID) IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) --2026.10.20 ssh
                              FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR UPPER(P_ITEM_ID) = 'ALL'
           /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                 OR A.ITEM_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_ITEM_ID), '[^,]+', 1, LEVEL)
--                                    FROM DUAL
--                                 CONNECT BY REGEXP_SUBSTR(UPPER(P_ITEM_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                 /* OR A.ITEM_ID MEMBER OF V_ITEM_TAB ) */
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   /* AJS 20261008 Model/Nickname */
           /* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
         /* 정렬 : AS-IS 는 대문자와 소문자를 가리지 않고 줄을 세운다
          *        (그렇게 하지 않으면 Venture_MY_JHB 와 VN00188600_40-P 의 앞뒤가 뒤바뀐다).
          *        기호를 뺀 값으로 먼저 견주고(띄어쓰기는 남긴다) 같으면 원래 값으로 다시 견준다. */
         ORDER BY NLSSORT(REGEXP_REPLACE(A.DIVISION_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI')
                , NLSSORT(A.DIVISION_ID, 'NLS_SORT=BINARY_CI')
                , NLSSORT(REGEXP_REPLACE(A.SCM_SITE_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI')
                , NLSSORT(A.SCM_SITE_ID, 'NLS_SORT=BINARY_CI')
                , NLSSORT(REGEXP_REPLACE(A.ITEM_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI')
                , NLSSORT(A.ITEM_ID, 'NLS_SORT=BINARY_CI')
                , A.YYYYMMDD                 /* AS-IS 는 여기까지 같으면 순서가 정해지지 않는다 — 날짜로 고정 */
                , A.ATTRIBUTE1;

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
    END P_SCP0041_GET_STOCK_OSP;


    /*==================================================================================================*
     * Pack 보류재고 조회 (AS-IS SCP0041_GET_PACK_HOLD_STOCK)
     *
     * AS-IS 2022.11.29 로 보류 · 해제를 모두 조회한다(DIR 고정 조건 주석 처리).
     * ★기준일 · 보류 시작 · 끝 · 해제일은 여덟 자리 문자 칸이다(날짜 칸이 아니다).
     *  AS-IS 가 날짜로 바꾸어 돌려주므로 같은 형식으로 바꾼다.
     * ★AS-IS 의 상태 조건은 `isnull(@p_status,'ALL') = ''` 라서
     *  상태를 **보내지 않으면 전체**가 나오고, 'ALL' 을 보내면 0행이 된다(값에 'ALL' 이 없으므로).
     *  전환본은 **빈 값도 'ALL' 도 전체**로 다룬다 — 빈 값은 AS-IS 와 같고, 'ALL' 은 조회조건 목록 규칙에 맞춘 것이다.
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.08   AJS            조회조건 Model/Nickname : 후보 품목 비교를 MEMBER OF 에서 IN (TABLE()) 로 변경(결과 동일·속도)
     *==================================================================================================*/
    PROCEDURE P_SCP0041_GET_PACK_HOLD_STOCK
    (
        P_DIVISION_ID            IN  VARCHAR2,
        P_PLANT_SITE_ID          IN  VARCHAR2,
        P_ITEM_ID                IN  VARCHAR2,
        P_FROM_YYYYMMDD          IN  VARCHAR2,
        P_TO_YYYYMMDD            IN  VARCHAR2,
        P_INSPECTION_ID          IN  VARCHAR2,
        P_STATUS                 IN  VARCHAR2,
        P_CUTOFF_FROM_YYYYMMDD   IN  VARCHAR2,
        P_CUTOFF_TO_YYYYMMDD     IN  VARCHAR2,
        O_RC1                    OUT SYS_REFCURSOR,
        O_RESULT_CURSOR          OUT SYS_REFCURSOR
    )
    IS
        V_ERR_CODE  NUMBER;
        V_ERR_MSG   VARCHAR2(4000 CHAR);
        V_ITEM_TAB  T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 품목 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다 */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT DISTINCT ITEM_ID
                      FROM SCM_DNM_STOCK_LOT_CONTROL) IA
             WHERE EXISTS (SELECT 1
                             FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                            WHERE SA.COLUMN_VALUE IS NOT NULL
                              AND (   UPPER(IA.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
                                   OR EXISTS (SELECT 1
                                                FROM SCM_MST_ITEM_SN XA
                                               WHERE XA.ITEM_ID = IA.ITEM_ID
                                                 AND UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%')));
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */
        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID                                                     AS SCM_SITE_ID
             , CASE WHEN A.SCM_SITE_ID <> '-'
                    THEN (SELECT MAX(SA.SITE_DESCRIPTION)
                            FROM SCM_MST_SITE SA
                           WHERE SA.SCM_SITE_ID = A.SCM_SITE_ID
                             AND SA.DIVISION_ID = A.DIVISION_ID)
                    ELSE A.SCM_SITE_ID
               END                                                               AS SITE_DESCRIPTION
             , TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD')                                AS CUTOFF_DATE
             , A.ITEM_ID                                                         AS PROD_ID
             , FN_GET_ITEM_NICKNAME(NULL, A.ITEM_ID)                             AS NICK_NAME
             , A.ORG_ITEM_ID
             , A.QTY                                                             AS QTY
             , TO_DATE(A.RELEASE_DATE, 'YYYYMMDD')                               AS DATE_FINISH_REAL
             , TO_DATE(A.HOLD_START_DATE, 'YYYYMMDD')                            AS DATE_FORECAST_START
             , TO_DATE(A.HOLD_END_DATE, 'YYYYMMDD')                              AS DATE_FORECAST_FINISH
             , A.CHANGE_REQUEST_USER
             , FN_GET_USER_NAME(A.CHANGE_REQUEST_USER)                           AS REQUSET_USER
             , A.DIR
             , A.LOT_ID
             , A.PLANT_ID
             , A.SHOP_ID
             , A.LINE_ID
             , A.APPLY_PSN_ID
             , A.APPLY_DATE
             , A.INSPECTION_ID
             , A.NOTE
             , A.INSP_LCLASS_CODE
             , A.INSP_MCLASS_CODE
             , A.RISK_RANGE_FLAG
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE7
             , A.ATTRIBUTE8
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , CASE WHEN A.CREATED_BY <> A.LAST_UPDATED_BY
                    THEN FN_GET_USER_NAME(A.LAST_UPDATED_BY)
                    ELSE NULL
               END                                                               AS MODIFIER
             , CASE WHEN A.CREATED_BY <> A.LAST_UPDATED_BY
                    THEN A.LAST_UPDATE_DATE
                    ELSE NULL
               END                                                               AS MODIFIER_DATE
          FROM SCM_DNM_STOCK_LOT_CONTROL A
         WHERE ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(P_DIVISION_ID) = 'ALL'
                 OR A.DIVISION_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_DIVISION_ID), '[^,]+', 1, LEVEL)
                                        FROM DUAL
                                     CONNECT BY REGEXP_SUBSTR(UPPER(P_DIVISION_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
           AND ( TRIM(P_PLANT_SITE_ID) IS NULL
                 OR UPPER(P_PLANT_SITE_ID) = 'ALL'
                 OR UPPER(A.SCM_SITE_ID) IN (SELECT REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) --2026.10.20 ssh
                              FROM DUAL
                            CONNECT BY REGEXP_SUBSTR(UPPER(P_PLANT_SITE_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR UPPER(P_ITEM_ID) = 'ALL'
           /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                 OR A.ITEM_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_ITEM_ID), '[^,]+', 1, LEVEL)
--                                    FROM DUAL
--                                 CONNECT BY REGEXP_SUBSTR(UPPER(P_ITEM_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
                 /* OR A.ITEM_ID MEMBER OF V_ITEM_TAB ) */
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   /* AJS 20261008 Model/Nickname */
           /* 2026.10.07 AJS Model/Nickname 검색 (END) */
           AND ( TRIM(P_INSPECTION_ID) IS NULL
                 OR UPPER(P_INSPECTION_ID) = 'ALL'
                 OR A.INSPECTION_ID IN (SELECT REGEXP_SUBSTR(UPPER(P_INSPECTION_ID), '[^,]+', 1, LEVEL)
                                          FROM DUAL
                                       CONNECT BY REGEXP_SUBSTR(UPPER(P_INSPECTION_ID), '[^,]+', 1, LEVEL) IS NOT NULL) )
           AND ( TRIM(P_STATUS) IS NULL
                 OR UPPER(P_STATUS) = 'ALL'
                 OR A.DIR IN (SELECT REGEXP_SUBSTR(UPPER(P_STATUS), '[^,]+', 1, LEVEL)
                                FROM DUAL
                             CONNECT BY REGEXP_SUBSTR(UPPER(P_STATUS), '[^,]+', 1, LEVEL) IS NOT NULL) )
           AND ( ( A.HOLD_START_DATE >= P_FROM_YYYYMMDD AND A.HOLD_START_DATE <= P_TO_YYYYMMDD )
                 OR
                 ( A.HOLD_END_DATE   >= P_FROM_YYYYMMDD AND A.HOLD_END_DATE   <= P_TO_YYYYMMDD ) )
           AND A.CUTOFF_DATE >= P_CUTOFF_FROM_YYYYMMDD
           AND A.CUTOFF_DATE <= P_CUTOFF_TO_YYYYMMDD
         /* 정렬 : 위와 같은 이유로 대문자 · 소문자를 가리지 않고 기호를 뺀 값으로 견준다 */
         ORDER BY NLSSORT(REGEXP_REPLACE(A.INSPECTION_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI')
                , NLSSORT(A.INSPECTION_ID, 'NLS_SORT=BINARY_CI')
                , A.CUTOFF_DATE
                , NLSSORT(A.DIR, 'NLS_SORT=BINARY_CI')
                , NLSSORT(REGEXP_REPLACE(A.PLANT_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI')
                , NLSSORT(A.PLANT_ID, 'NLS_SORT=BINARY_CI')
                , NLSSORT(REGEXP_REPLACE(A.ITEM_ID, '[^[:alnum:] ]', ''), 'NLS_SORT=BINARY_CI')
                , NLSSORT(A.ITEM_ID, 'NLS_SORT=BINARY_CI');

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
    END P_SCP0041_GET_PACK_HOLD_STOCK;


    /*==================================================================================================*
     * Pack 보류재고 저장 (AS-IS SCP0041_SAVE_PACKER_HOLD_STOCK)
     *
     * AS-IS 는 구분값이 'M' 인 행만 고친다(넣기 · 지우기 갈래가 없다).
     * 결과는 성공이면 'S' + 고친 행 수, 실패면 'F' + 오류 문구.
     *==================================================================================================*/
    PROCEDURE P_SCP0041_SAVE_PACKER_HOLD_STOCK
    (
        P_ACTIVE_FLAG            IN  CLOB,
        P_INSPECTION_ID          IN  CLOB,
        P_DIR                    IN  CLOB,
        P_PLANT_ID               IN  CLOB,
        P_PROD_ID                IN  CLOB,
        P_CUTOFF_DATE            IN  CLOB,
        P_QTY                    IN  CLOB,
        P_DATE_FORECAST_START    IN  CLOB,
        P_DATE_FORECAST_FINISH   IN  CLOB,
        P_USER_ID                IN  VARCHAR2,
        O_RESULT_CURSOR          OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME  CONSTANT VARCHAR2(150 CHAR) := 'SCP0041_STOCK_OSP_EXCEL_UPLOAD';

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_INSPECTION_ID         T_TOKEN_TAB;
        T_DIR                   T_TOKEN_TAB;
        T_PLANT_ID              T_TOKEN_TAB;
        T_PROD_ID               T_TOKEN_TAB;
        T_CUTOFF_DATE           T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_DATE_FORECAST_START   T_TOKEN_TAB;
        T_DATE_FORECAST_FINISH  T_TOKEN_TAB;

        V_MAX_LOOP_CNT  PLS_INTEGER := 0;
        V_CNT           PLS_INTEGER;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_INSPECTION_ID         VARCHAR2(4000 CHAR);
        V_DIR                   VARCHAR2(4000 CHAR);
        V_PLANT_ID              VARCHAR2(4000 CHAR);
        V_PROD_ID               VARCHAR2(4000 CHAR);
        V_CUTOFF_DATE           VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_DATE_FORECAST_START   VARCHAR2(4000 CHAR);
        V_DATE_FORECAST_FINISH  VARCHAR2(4000 CHAR);

        V_QTY_NUM       NUMBER;
        V_UPDATE_COUNT  PLS_INTEGER := 0;
        V_ERR_MESSAGE   VARCHAR2(4000 CHAR);
    BEGIN
        SAVEPOINT SP_SCP0041_SAVE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0,
                             '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT(P_ACTIVE_FLAG,          V_DELIMITER, T_ACTIVE_FLAG,          V_CNT);
        V_MAX_LOOP_CNT := GREATEST(V_MAX_LOOP_CNT, V_CNT);
        P_SPLIT(P_INSPECTION_ID,        V_DELIMITER, T_INSPECTION_ID,        V_CNT);
        P_SPLIT(P_DIR,                  V_DELIMITER, T_DIR,                  V_CNT);
        P_SPLIT(P_PLANT_ID,             V_DELIMITER, T_PLANT_ID,             V_CNT);
        P_SPLIT(P_PROD_ID,              V_DELIMITER, T_PROD_ID,              V_CNT);
        P_SPLIT(P_CUTOFF_DATE,          V_DELIMITER, T_CUTOFF_DATE,          V_CNT);
        P_SPLIT(P_QTY,                  V_DELIMITER, T_QTY,                  V_CNT);
        P_SPLIT(P_DATE_FORECAST_START,  V_DELIMITER, T_DATE_FORECAST_START,  V_CNT);
        P_SPLIT(P_DATE_FORECAST_FINISH, V_DELIMITER, T_DATE_FORECAST_FINISH, V_CNT);

        FOR I IN 1 .. V_MAX_LOOP_CNT
        LOOP
            V_ACTIVE_FLAG := F_TK(T_ACTIVE_FLAG, I);

            IF TRIM(V_ACTIVE_FLAG) IS NULL THEN
                CONTINUE;
            END IF;

            IF UPPER(V_ACTIVE_FLAG) = 'M' THEN

                V_INSPECTION_ID        := F_TK(T_INSPECTION_ID,        I);
                V_DIR                  := F_TK(T_DIR,                  I);
                V_PLANT_ID             := F_TK(T_PLANT_ID,             I);
                V_PROD_ID              := F_TK(T_PROD_ID,              I);
                V_CUTOFF_DATE          := F_TK(T_CUTOFF_DATE,          I);
                V_QTY                  := F_TK(T_QTY,                  I);
                V_DATE_FORECAST_START  := F_TK(T_DATE_FORECAST_START,  I);
                V_DATE_FORECAST_FINISH := F_TK(T_DATE_FORECAST_FINISH, I);

                V_QTY_NUM := F_TO_NUM(V_QTY);

                UPDATE SCM_DNM_STOCK_LOT_CONTROL
                   SET QTY              = V_QTY_NUM
                     , HOLD_START_DATE  = V_DATE_FORECAST_START
                     , HOLD_END_DATE    = V_DATE_FORECAST_FINISH
                     , LAST_UPDATED_BY  = P_USER_ID
                     , LAST_UPDATE_DATE = SYSDATE
                 WHERE INSP_MCLASS_CODE = 'ECMM003'
                   AND INSPECTION_ID    = V_INSPECTION_ID
                   AND DIR              = V_DIR
                   AND PLANT_ID         = V_PLANT_ID
                   AND ITEM_ID          = V_PROD_ID
                   AND CUTOFF_DATE      = V_CUTOFF_DATE;

                V_UPDATE_COUNT := V_UPDATE_COUNT + SQL%ROWCOUNT;

            END IF;

        END LOOP;

        COMMIT;

        OPEN O_RESULT_CURSOR FOR
        SELECT 'S'             AS RESULT_CODE
             , V_UPDATE_COUNT  AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SCP0041_SAVE;

            OPEN O_RESULT_CURSOR FOR
            SELECT 'F'            AS RESULT_CODE
                 , V_ERR_MESSAGE  AS ERR_MESSAGE
              FROM DUAL;
    END P_SCP0041_SAVE_PACKER_HOLD_STOCK;


    /*==================================================================================================*
     * Stock OSP 엑셀 올리기 (AS-IS SCP0041_STOCK_OSP_EXCEL_UPLOAD)
     *
     *   P_MODE = 0      : 올린 자료 검증 — 행마다 상태와 안내 문구를 매긴다
     *   P_MODE >= 1     : 오류 행이 하나도 없을 때만 원장에 반영
     *
     * ★AS-IS 는 인자가 둘(모드 · 올린 사람)뿐이라 화면 공통 규약(다섯)과 맞지 않는다.
     *  화면이 부를 수 있도록 화면 아이디 · 시트 이름을 함께 받는다(AS-IS 고정값이 기본값).
     *
     * 올린 자료 칸 배치 (AS-IS 와 같다)
     *   ATTRIBUTE1 사업부 · 2 사이트 · 3 품목 · 4 일자 · 5 Valuation Type
     *   ATTRIBUTE6 수량 · 7 Cell From Site · 8 비고 · 9 Box
     *==================================================================================================*/
    PROCEDURE P_SCP0041_STOCK_OSP_EXCEL_UPLOAD
    (
        P_MODE            IN  NUMBER,
        P_CREATED_BY      IN  VARCHAR2,
        P_PROGRAM_ID      IN  VARCHAR2 DEFAULT 'SCP0041',
        P_SHEET_NAME      IN  VARCHAR2 DEFAULT 'Osp Stock',
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME   CONSTANT VARCHAR2(150 CHAR) := 'SCP0041_STOCK_OSP_EXCEL_UPLOAD';

        V_PROGRAM_ID     VARCHAR2(400 CHAR) := NVL(P_PROGRAM_ID, 'SCP0041');
        V_SHEET_NAME     VARCHAR2(600 CHAR) := NVL(P_SHEET_NAME, 'Osp Stock');
        V_CREATION_DATE  TIMESTAMP(6);
        V_COUNT          PLS_INTEGER := 0;
        V_ERR_CODE       NUMBER;
        V_ERR_MESSAGE    VARCHAR2(4000 CHAR);
    BEGIN
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0,
                             '########## Start of procedure ##########', NULL, SYSDATE);

        /* 이번에 올린 묶음 고르기 — 같은 사람이 같은 시트에 올린 것 가운데 가장 나중 것 */
        SELECT MAX(T.CREATION_DATE)
          INTO V_CREATION_DATE
          FROM SCM_ADM_EXCEL_UPLOAD T
         WHERE T.PROGRAM_ID = V_PROGRAM_ID
           AND T.SHEET_NAME = V_SHEET_NAME
           AND T.CREATED_BY = P_CREATED_BY;

        IF V_CREATION_DATE IS NULL THEN
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0,
                                 '########## END of procedure ##########', 'Data Not Found', SYSDATE);

            OPEN O_RESULT_CURSOR FOR
            SELECT '0'        AS CODE
                 , 'SUCCESS'  AS MSG
              FROM DUAL;
            RETURN;
        END IF;

        /*==============================================================================================*
         * 모드 0 — 올린 자료 검증
         *==============================================================================================*/
        IF NVL(P_MODE, 0) = 0 THEN

            /* 상태 되돌리기 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'UPLOAD'
                 , MESSAGE_TEXT       = NULL
             WHERE PROGRAM_ID    = V_PROGRAM_ID
               AND SHEET_NAME    = V_SHEET_NAME
               AND CREATED_BY    = P_CREATED_BY
               AND CREATION_DATE = V_CREATION_DATE
               AND NVL(UPLOAD_STATUS_CODE, 'X') <> 'UPLOAD';

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '1', SQL%ROWCOUNT,
                                 '########## RESET Status = UPLOAD ##########', NULL, SYSDATE);

            /* 빈 줄은 건너뛴다 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SKIP'
             WHERE PROGRAM_ID    = V_PROGRAM_ID
               AND SHEET_NAME    = V_SHEET_NAME
               AND CREATED_BY    = P_CREATED_BY
               AND CREATION_DATE = V_CREATION_DATE
               AND TRIM(ATTRIBUTE1) IS NULL;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '2', SQL%ROWCOUNT,
                                 '########## SKIP EMPTY LINE ##########', NULL, SYSDATE);

            /* 머리글 줄 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = '@TITLE'
             WHERE PROGRAM_ID    = V_PROGRAM_ID
               AND SHEET_NAME    = V_SHEET_NAME
               AND CREATED_BY    = P_CREATED_BY
               AND CREATION_DATE = V_CREATION_DATE
               AND UPPER(ATTRIBUTE1) IN ('DIV*', 'DIV', 'DIVISION');

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '3', SQL%ROWCOUNT,
                                 '########## TITLE Header Line ##########', NULL, SYSDATE);

            /* 1. 반드시 있어야 하는 칸이 비었는가 (사이트 · 품목 · 일자 · 수량) */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Column Data.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ( TRIM(ATTRIBUTE2) IS NULL
                     OR TRIM(ATTRIBUTE3) IS NULL
                     OR TRIM(ATTRIBUTE4) IS NULL
                     OR TRIM(ATTRIBUTE6) IS NULL );    /* VALUATION TYPE 추가 */

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '4', SQL%ROWCOUNT,
                                 '########## ERROR Invalid Column Data ##########', NULL, SYSDATE);

            /* 2. 파일 안에서 같은 열쇠가 두 번 나오는가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Duplication Key.'
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND EXISTS (SELECT 1
                             FROM (SELECT X.ATTRIBUTE1 AS COL1
                                        , X.ATTRIBUTE2 AS COL2
                                        , X.ATTRIBUTE3 AS COL3
                                        , X.ATTRIBUTE4 AS COL4
                                        , X.ATTRIBUTE5 AS COL5    /* Valuation Type 컬럼추가 */
                                        , X.ATTRIBUTE7 AS COL7    /* Cell From Site 컬럼추가 */
                                     FROM SCM_ADM_EXCEL_UPLOAD X
                                    WHERE X.PROGRAM_ID         = V_PROGRAM_ID
                                      AND X.SHEET_NAME         = V_SHEET_NAME
                                      AND X.CREATED_BY         = P_CREATED_BY
                                      AND X.CREATION_DATE      = V_CREATION_DATE
                                      AND X.UPLOAD_STATUS_CODE = 'UPLOAD'
                                    GROUP BY X.ATTRIBUTE1
                                           , X.ATTRIBUTE2
                                           , X.ATTRIBUTE3
                                           , X.ATTRIBUTE4
                                           , X.ATTRIBUTE5
                                           , X.ATTRIBUTE7
                                   HAVING COUNT(*) > 1) SA
                            WHERE SA.COL1 = A.ATTRIBUTE1
                              AND SA.COL2 = A.ATTRIBUTE2
                              AND SA.COL3 = A.ATTRIBUTE3
                              AND SA.COL4 = A.ATTRIBUTE4
                              AND SA.COL5 = A.ATTRIBUTE5
                              AND SA.COL7 = A.ATTRIBUTE7);

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '5', SQL%ROWCOUNT,
                                 '########## ERROR Key Duplication ##########', NULL, SYSDATE);

            /* 3. 사업부가 원장에 있는가 (코드 또는 이름) */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Division.'
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_DIVISION SA
                                WHERE SA.VALID_YN    = 'Y'
                                  AND ( SA.DIVISION_ID   = A.ATTRIBUTE1
                                        OR SA.DIVISION_NAME = A.ATTRIBUTE1 ));

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '6', SQL%ROWCOUNT,
                                 '########## ERROR Invalid Division ##########', NULL, SYSDATE);

            /* 사업부 이름으로 넣은 것을 코드로 바꾼다 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.ATTRIBUTE1 = (SELECT MAX(SA.DIVISION_ID)
                                     FROM SCM_MST_DIVISION SA
                                    WHERE SA.VALID_YN      = 'Y'
                                      AND SA.DIVISION_NAME = A.ATTRIBUTE1)
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_DIVISION SA
                                WHERE SA.VALID_YN    = 'Y'
                                  AND SA.DIVISION_ID = A.ATTRIBUTE1);

            /* 4. 일자가 여덟 자리인가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Date.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ( TRIM(ATTRIBUTE4) IS NULL
                     OR LENGTH(SUBSTR(REPLACE(REPLACE(NVL(ATTRIBUTE4, ' '), ' ', ''), '-', ''), 1, 8)) <> 8 );

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '7', SQL%ROWCOUNT,
                                 '########## ERROR Invalid Date ##########', NULL, SYSDATE);

            /* 일자를 여덟 자리로 다듬는다 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET ATTRIBUTE4 = SUBSTR(REPLACE(REPLACE(NVL(ATTRIBUTE4, ' '), ' ', ''), '-', ''), 1, 8)
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD';

            /* 5. 사이트가 원장에 있는가 (코드 또는 이름 · 사내 또는 외주) */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Plant/Sales Site.'
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_SITE SA
                                    , SCM_MST_DIVISION SB
                                WHERE SB.DIVISION_ID = SA.DIVISION_ID
                                  AND SA.SITE_TYPE IN ('PLANT', 'SALES')
                                  AND ( SA.SITE_TYPE = 'SALES' OR SA.OSP_YN = 'Y' )
                                  AND ( SA.SCM_SITE_ID     = A.ATTRIBUTE2
                                        OR SA.SITE_DESCRIPTION = A.ATTRIBUTE2 )
                                  AND ( SB.DIVISION_ID   = A.ATTRIBUTE1
                                        OR SB.DIVISION_NAME = A.ATTRIBUTE1 )
                                  AND SA.VALID_YN = 'Y');

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '8', SQL%ROWCOUNT,
                                 '########## ERROR Invalid Plant/Sales Site ##########', NULL, SYSDATE);

            /* 사이트 이름으로 넣은 것을 코드로 바꾼다 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.ATTRIBUTE2 = (SELECT MIN(SA.SCM_SITE_ID)
                                     FROM SCM_MST_SITE SA
                                    WHERE SA.VALID_YN = 'Y'
                                      AND SA.SITE_TYPE IN ('PLANT', 'SALES')
                                      AND SA.SITE_DESCRIPTION = A.ATTRIBUTE2)
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_SITE SA
                                WHERE SA.VALID_YN = 'Y'
                                  AND SA.SITE_TYPE IN ('PLANT', 'SALES')
                                  AND SA.SCM_SITE_ID = A.ATTRIBUTE2);

            /* 6. 품목이 원장에 있는가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Item.'
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_DIVISION SA
                                    , SCP_MST_FINAL_ITEM SB
                                WHERE SB.DIVISION_ID = SA.DIVISION_ID
                                  AND ( SA.DIVISION_ID   = A.ATTRIBUTE1
                                        OR SA.DIVISION_NAME = A.ATTRIBUTE1 )
                                  AND SB.ITEM_ID = A.ATTRIBUTE3);

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '9', SQL%ROWCOUNT,
                                 '########## ERROR Invalid Item ##########', NULL, SYSDATE);

            /* 7. 수량이 숫자인가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Qty.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND NOT REGEXP_LIKE(NVL(TRIM(ATTRIBUTE6), 'X'), '^[+-]?[0-9]+(\.[0-9]+)?$');

            /* 8. 수량에 소수점이 있는가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Qty.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND INSTR(ATTRIBUTE6, '.') > 0;

            /* 9. 수량이 음수인가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Qty.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND TO_NUMBER(ATTRIBUTE6) < 0;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, '10', SQL%ROWCOUNT,
                                 '########## ERROR Invalid Qty ##########', NULL, SYSDATE);

            /* 10. Valuation Type 이 빈 값 · PUR · PRD 가운데 하나인가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Valuation Type.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ATTRIBUTE5 IS NOT NULL
               AND ATTRIBUTE5 NOT IN ('PUR', 'PRD');

            /* 11. Cell From Site 가 사내 사이트인가 (비어 있으면 보지 않는다) */
            UPDATE SCM_ADM_EXCEL_UPLOAD A
               SET A.UPLOAD_STATUS_CODE = 'ERROR'
                 , A.MESSAGE_TEXT       = 'Invalid Cell From Site.'
             WHERE A.PROGRAM_ID         = V_PROGRAM_ID
               AND A.SHEET_NAME         = V_SHEET_NAME
               AND A.CREATED_BY         = P_CREATED_BY
               AND A.CREATION_DATE      = V_CREATION_DATE
               AND A.UPLOAD_STATUS_CODE = 'UPLOAD'
               AND A.ATTRIBUTE7 IS NOT NULL
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_MST_SITE SA
                                    , SCM_MST_DIVISION SB
                                WHERE SB.DIVISION_ID = SA.DIVISION_ID
                                  AND SA.SITE_TYPE = 'PLANT'
                                  AND SA.PLANT_ID  = A.ATTRIBUTE7
                                  AND ( SB.DIVISION_ID   = A.ATTRIBUTE1
                                        OR SB.DIVISION_NAME = A.ATTRIBUTE1 )
                                  AND SA.VALID_YN = 'Y');

            /* 12. Box 가 빈 값 · C · R 가운데 하나인가 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'ERROR'
                 , MESSAGE_TEXT       = 'Invalid Box.'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD'
               AND ATTRIBUTE9 IS NOT NULL
               AND ATTRIBUTE9 NOT IN ('C', 'R');

            /* 남은 행은 통과 */
            UPDATE SCM_ADM_EXCEL_UPLOAD
               SET UPLOAD_STATUS_CODE = 'SUCCESS'
             WHERE PROGRAM_ID         = V_PROGRAM_ID
               AND SHEET_NAME         = V_SHEET_NAME
               AND CREATED_BY         = P_CREATED_BY
               AND CREATION_DATE      = V_CREATION_DATE
               AND UPLOAD_STATUS_CODE = 'UPLOAD';

            COMMIT;

        END IF;

        /* 오류 행 수 세기 */
        SELECT COUNT(1)
          INTO V_COUNT
          FROM SCM_ADM_EXCEL_UPLOAD T
         WHERE T.PROGRAM_ID         = V_PROGRAM_ID
           AND T.SHEET_NAME         = V_SHEET_NAME
           AND T.CREATED_BY         = P_CREATED_BY
           AND T.CREATION_DATE      = V_CREATION_DATE
           AND T.UPLOAD_STATUS_CODE = 'ERROR';

        /*==============================================================================================*
         * 모드 1 이상 — 오류 행이 하나도 없을 때만 원장에 반영
         *==============================================================================================*/
        IF NVL(P_MODE, 0) > 0 AND V_COUNT = 0 THEN

            /* ★AS-IS 와 같이 품목을 가리지 않고 (사업부 · 사이트 · 일자)로 먼저 지운다 —
             *  올린 파일에 들어 있는 날짜의 그 사이트 재고가 파일 내용으로 통째로 바뀐다 */
            DELETE
              FROM SCM_DNM_STOCK_OSP S
             WHERE EXISTS (SELECT 1
                             FROM SCM_ADM_EXCEL_UPLOAD T
                            WHERE T.ATTRIBUTE1         = S.DIVISION_ID
                              AND T.ATTRIBUTE2         = S.SCM_SITE_ID
                              AND REPLACE(REPLACE(NVL(T.ATTRIBUTE4, ' '), ' ', ''), '-', '') = S.YYYYMMDD
                              AND T.PROGRAM_ID         = V_PROGRAM_ID
                              AND T.SHEET_NAME         = V_SHEET_NAME
                              AND T.CREATED_BY         = P_CREATED_BY
                              AND T.CREATION_DATE      = V_CREATION_DATE
                              AND T.UPLOAD_STATUS_CODE = 'SUCCESS');

            INSERT INTO SCM_DNM_STOCK_OSP
                 ( DIVISION_ID
                 , SCM_SITE_ID
                 , ITEM_ID
                 , YYYYMMDD
                 , ATTRIBUTE1                                    /* Valuation Type 추가 */
                 , QTY
                 , ATTRIBUTE2                                    /* Cell From Site 추가 */
                 , "COMMENT"
                 , ATTRIBUTE3                                    /* Box 추가 */
                 , VALID_YN
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 )
            SELECT T.ATTRIBUTE1
                 , T.ATTRIBUTE2
                 , T.ATTRIBUTE3
                 , T.ATTRIBUTE4
                 , T.ATTRIBUTE5
                 , TO_NUMBER(REPLACE(REPLACE(NVL(T.ATTRIBUTE6, '0'), ' ', ''), ',', ''))
                 , T.ATTRIBUTE7
                 , T.ATTRIBUTE8
                 , T.ATTRIBUTE9
                 , 'Y'
                 , P_CREATED_BY
                 , SYSDATE
                 , P_CREATED_BY
                 , SYSDATE
              FROM SCM_ADM_EXCEL_UPLOAD T
             WHERE T.PROGRAM_ID         = V_PROGRAM_ID
               AND T.SHEET_NAME         = V_SHEET_NAME
               AND T.CREATED_BY         = P_CREATED_BY
               AND T.CREATION_DATE      = V_CREATION_DATE
               AND T.UPLOAD_STATUS_CODE = 'SUCCESS'
               AND NOT EXISTS (SELECT 1
                                 FROM SCM_DNM_STOCK_OSP SA
                                WHERE SA.DIVISION_ID = T.ATTRIBUTE1
                                  AND SA.SCM_SITE_ID = T.ATTRIBUTE2
                                  AND SA.ITEM_ID     = T.ATTRIBUTE3
                                  AND SA.YYYYMMDD    = REPLACE(REPLACE(NVL(T.ATTRIBUTE4, ' '), ' ', ''), '-', '')
                                  AND SA.ATTRIBUTE1  = T.ATTRIBUTE5     /* Valuation Type */
                                  AND SA.ATTRIBUTE2  = T.ATTRIBUTE7);   /* Cell From Site */

            COMMIT;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', V_COUNT,
                             '########## END of procedure ##########', TO_CHAR(P_MODE), SYSDATE);

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'        AS CODE
             , 'SUCCESS'  AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK;

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

            OPEN O_RESULT_CURSOR FOR
            SELECT TO_CHAR(V_ERR_CODE)  AS CODE
                 , V_ERR_MESSAGE        AS MSG
              FROM DUAL;
    END P_SCP0041_STOCK_OSP_EXCEL_UPLOAD;


END PKG_SCP0041;