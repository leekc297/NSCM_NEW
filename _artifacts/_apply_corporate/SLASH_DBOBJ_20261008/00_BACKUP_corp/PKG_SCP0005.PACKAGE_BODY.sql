PACKAGE BODY         PKG_SCP0005 IS

    -- 2026.09.17 AJS 추가 프로시저용 선언 (START)
    /*==================================================================================================
     * 공통 사항 (2026.09.17 추가분)
     *   - AS-IS 정렬 · 비교 규칙(대소문자 무시) : 원장 키 컬럼은 대문자만 있으므로 입력값만 UPPER
     *   - AS-IS 빈 문자('') 는 Oracle 에서 NULL — 숫자 컬럼 변환은 AS-IS 와 같이 빈 값 = 0
     *   - AS-IS 컬럼 길이(nvarchar) 보다 긴 값은 AS-IS 와 같이 저장 오류
     *   - 저장 실패 시 SAVEPOINT 까지만 되돌림, 성공 시 COMMIT (AS-IS COMMIT TRAN)
     *==================================================================================================*/
    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    TYPE T_ROUTE_ROW IS RECORD
    (
        ROUTE_ID                    VARCHAR2(4000 CHAR)
      , LT_TYPE                     VARCHAR2(4000 CHAR)
      , FROM_COUNTRY                VARCHAR2(4000 CHAR)
      , FROM_CITY                   VARCHAR2(4000 CHAR)
      , FROM_CITY_NAME              VARCHAR2(4000 CHAR)
      , TRANSPORT_MODE              VARCHAR2(4000 CHAR)
      , PRIORITY                    VARCHAR2(4000 CHAR)
      , DAYS_MON                    VARCHAR2(4000 CHAR)
      , DAYS_TUE                    VARCHAR2(4000 CHAR)
      , DAYS_WED                    VARCHAR2(4000 CHAR)
      , DAYS_THU                    VARCHAR2(4000 CHAR)
      , DAYS_FRI                    VARCHAR2(4000 CHAR)
      , DAYS_SAT                    VARCHAR2(4000 CHAR)
      , DAYS_SUN                    VARCHAR2(4000 CHAR)
      , D_COUNTRY                   VARCHAR2(4000 CHAR)
      , D_PORT_CODE                 VARCHAR2(4000 CHAR)
      , D_PORT_NAME                 VARCHAR2(4000 CHAR)
      , A_COUNTRY                   VARCHAR2(4000 CHAR)
      , A_PORT_CODE                 VARCHAR2(4000 CHAR)
      , A_PORT_NAME                 VARCHAR2(4000 CHAR)
      , SHIPPING_COMPANY            VARCHAR2(4000 CHAR)
      , TO_COUNTRY                  VARCHAR2(4000 CHAR)
      , TO_CITY                     VARCHAR2(4000 CHAR)
      , TO_CITY_NAME                VARCHAR2(4000 CHAR)
      , SHIP_DOC_PREPARATION_DATE   VARCHAR2(4000 CHAR)
      , LT_DEPARTURE_INLAND         VARCHAR2(4000 CHAR)
      , LT_WAIT_SHIPPING            VARCHAR2(4000 CHAR)
      , LT_VOYAGE                   VARCHAR2(4000 CHAR)
      , LT_LAY_OFF_CLEARANCE        VARCHAR2(4000 CHAR)
      , LT_ARRIVAL_INLAND           VARCHAR2(4000 CHAR)
      , VALID_YN                    VARCHAR2(4000 CHAR)
      , ONE_SEGMENT_COST            VARCHAR2(4000 CHAR)
      , TWO_SEGMENT_COST            VARCHAR2(4000 CHAR)
      , THREE_SEGMENT_COST          VARCHAR2(4000 CHAR)
    );

    /* 엑셀 업로드 적재 행 (HEADER_CONTENT 순서 = ATTRIBUTE 번호) */
    CURSOR C_UPLOAD
    (
        P_PROGRAM_ID     VARCHAR2
      , P_SHEET_NAME     VARCHAR2
      , P_CREATED_BY     VARCHAR2
      , P_CREATION_DATE  TIMESTAMP
    )
    IS
    SELECT A.UPLOAD_ID
         , A.UPLOAD_STATUS_CODE
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
         , A.ATTRIBUTE11
         , A.ATTRIBUTE12
         , A.ATTRIBUTE13
         , A.ATTRIBUTE14
         , A.ATTRIBUTE15
         , A.ATTRIBUTE16
         , A.ATTRIBUTE17
         , A.ATTRIBUTE18
         , A.ATTRIBUTE19
         , A.ATTRIBUTE20
         , A.ATTRIBUTE21
         , A.ATTRIBUTE22
         , A.ATTRIBUTE23
         , A.ATTRIBUTE24
         , A.ATTRIBUTE25
         , A.ATTRIBUTE26
         , A.ATTRIBUTE27
         , A.ATTRIBUTE28
         , A.ATTRIBUTE29
         , A.ATTRIBUTE30
         , A.ATTRIBUTE31
         , A.ATTRIBUTE32
         , A.ATTRIBUTE33
         , A.ATTRIBUTE34
         , A.ATTRIBUTE35
      FROM SCM_ADM_EXCEL_UPLOAD A
     WHERE A.PROGRAM_ID    = P_PROGRAM_ID
       AND A.SHEET_NAME    = P_SHEET_NAME
       AND A.CREATED_BY    = P_CREATED_BY
       AND A.CREATION_DATE = P_CREATION_DATE
       AND A.UPLOAD_STATUS_CODE IN ('UPLOAD', 'SUCCESS', 'ERROR')
     ORDER BY A.UPLOAD_ID;

    TYPE T_UPLOAD_TAB IS TABLE OF C_UPLOAD%ROWTYPE INDEX BY PLS_INTEGER;
    TYPE T_ROUTE_TAB  IS TABLE OF T_ROUTE_ROW INDEX BY PLS_INTEGER;
    TYPE T_IDX_TAB    IS TABLE OF PLS_INTEGER INDEX BY PLS_INTEGER;
    TYPE T_KEY_MAP    IS TABLE OF T_IDX_TAB INDEX BY VARCHAR2(32767);

    C_PKG_NAME       CONSTANT VARCHAR2(30 CHAR)  := 'PKG_SCP0005';
    C_KEY_DELIM      CONSTANT VARCHAR2(1 CHAR)   := CHR(1);
    C_BLANK          CONSTANT VARCHAR2(1 CHAR)   := CHR(0);
    -- 2026.09.17 AJS 추가 프로시저용 선언 (END)


    -- =========================================================================================
    -- GET: Distribution Route 조회 (AS-IS SCP0005_GET_DISTRIBUTION_ROUTE 1:1)
    --   - 내부 파생 테이블 T: transport_mode/valid_yn 콤마 목록 필터 (comma split)
    --   - 외부 필터: from/to country 는 대문자 완전일치, from/to city 는 대문자 LIKE 전방일치
    --   - FN_GET_LOOKUP_CODE_DESC('TRANSPORT_MODE_CODE', transport_mode) 는 1회성 호출이라
    --     scalar subquery 로 inline (SCM_ADM_LOOKUP_MASTER_DETAIL.SEGMENT2, NVL 센티널 '-' 통일
    --     — 둘 다 NULL 일 때 매칭되는 As-Is ISNULL(x,'')=ISNULL(y,'') 의도를 Oracle 에서 보존)
    --   - days 문자열: 요일별 'Mon, '...'Sun, ' 연결 후 마지막 공백 1글자만 제거 (As-Is LEFT(s,len-1) 그대로)
    -- =========================================================================================
    PROCEDURE P_SCP0005_GET_DISTRIBUTION_ROUTE
    (
        P_FROM_COUNTRY    IN  VARCHAR2,
        P_FROM_CITY       IN  VARCHAR2,
        P_TO_COUNTRY      IN  VARCHAR2,
        P_TO_CITY         IN  VARCHAR2,
        P_TRANSPORT_MODE  IN  VARCHAR2,
        P_VALID_YN        IN  VARCHAR2,
        O_RC              OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RC FOR
            SELECT T.ROUTE_ID,
                   T.FROM_COUNTRY,
                   T.FROM_CITY,
                   (SELECT CITY_NAME FROM SCM_MST_CITY WHERE COUNTRY = T.FROM_COUNTRY AND CITY = T.FROM_CITY) AS FROM_CITY_NAME,
                   T.TRANSPORT_MODE,
                   (SELECT C.SEGMENT2
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL C
                     WHERE C.LOOKUP_TYPE = 'TRANSPORT_MODE_CODE'
                       AND NVL(C.SEGMENT1, '-') = NVL(T.TRANSPORT_MODE, '-')
                       AND ROWNUM = 1) AS TRANSPORT_MODE_NAME,
                   T.PRIORITY,
                   T.DAYS_MON,
                   T.DAYS_TUE,
                   T.DAYS_WED,
                   T.DAYS_THU,
                   T.DAYS_FRI,
                   T.DAYS_SAT,
                   T.DAYS_SUN,
                   CASE WHEN LENGTH(RTRIM(T.DAYS)) > 3 THEN SUBSTR(T.DAYS, 1, LENGTH(RTRIM(T.DAYS)) - 1)
                        ELSE T.DAYS END AS DAYS   /* AS-IS LEN 은 후행 공백을 세지 않음 */,
                   T.D_COUNTRY,
                   T.D_PORT_CODE,
                   T.D_PORT_NAME,
                   T.A_COUNTRY,
                   T.A_PORT_CODE,
                   T.A_PORT_NAME,
                   T.SHIPPING_COMPANY,
                   T.TO_COUNTRY,
                   T.TO_CITY,
                   (SELECT CITY_NAME FROM SCM_MST_CITY WHERE COUNTRY = T.TO_COUNTRY AND CITY = T.TO_CITY) AS TO_CITY_NAME,
                   T.SHIP_DOC_PREPARATION_DATE,
                   T.LT_DEPARTURE_INLAND,
                   T.LT_WAIT_SHIPPING,
                   T.LT_VOYAGE,
                   T.LT_LAY_OFF_CLEARANCE,
                   T.LT_ARRIVAL_INLAND,
                   T.LT_SUM,
                   T.VALID_YN,
                   T.CREATED_BY,
                   T.CREATION_DATE,
                   T.LAST_UPDATED_BY,
                   T.LAST_UPDATE_DATE,
                   T.LT_TYPE,
--                   T.ATTRIBUTE1 AS ONE_SEGMENT_COST,
--                   T.ATTRIBUTE2 AS TWO_SEGMENT_COST,
--                   T.ATTRIBUTE3 AS THREE_SEGMENT_COST
--                   T.ATTRIBUTE1 AS "One_SEGMENT_COST",  -- 2026.09.17 AJS 화면 칸 이름(AS-IS 별칭) 그대로   --  2026.10.08 AJS
                   T.ATTRIBUTE1 AS "ONE_SEGMENT_COST",  -- 2026.09.17 AJS 화면 칸 이름(AS-IS 별칭) 그대로   --  2026.10.08 AJS
--                   T.ATTRIBUTE2 AS "Two_SEGMENT_COST",  -- 2026.09.17 AJS   --  2026.10.08 AJS
                   T.ATTRIBUTE2 AS "TWO_SEGMENT_COST",  -- 2026.09.17 AJS   --  2026.10.08 AJS
--                   T.ATTRIBUTE3 AS "Three_SEGMENT_COST"  -- 2026.09.17 AJS   --  2026.10.08 AJS
                   T.ATTRIBUTE3 AS "THREE_SEGMENT_COST"  -- 2026.09.17 AJS   --  2026.10.08 AJS
              FROM (
                    SELECT A.ROUTE_ID,
                           A.FROM_COUNTRY,
                           A.FROM_CITY,
                           A.TRANSPORT_MODE,
                           A.PRIORITY,
                           A.DAYS_MON,
                           A.DAYS_TUE,
                           A.DAYS_WED,
                           A.DAYS_THU,
                           A.DAYS_FRI,
                           A.DAYS_SAT,
                           A.DAYS_SUN,
                           (CASE WHEN NVL(A.DAYS_MON, '') = 'Y' THEN 'Mon, ' ELSE '' END) ||
                           (CASE WHEN NVL(A.DAYS_TUE, '') = 'Y' THEN 'Tue, ' ELSE '' END) ||
                           (CASE WHEN NVL(A.DAYS_WED, '') = 'Y' THEN 'Wed, ' ELSE '' END) ||
                           (CASE WHEN NVL(A.DAYS_THU, '') = 'Y' THEN 'Thu, ' ELSE '' END) ||
                           (CASE WHEN NVL(A.DAYS_FRI, '') = 'Y' THEN 'Fri, ' ELSE '' END) ||
                           (CASE WHEN NVL(A.DAYS_SAT, '') = 'Y' THEN 'Sat, ' ELSE '' END) ||
                           (CASE WHEN NVL(A.DAYS_SUN, '') = 'Y' THEN 'Sun, ' ELSE '' END) AS DAYS,
                           A.D_COUNTRY,
                           A.D_PORT_CODE,
                           A.D_PORT_NAME,
                           A.A_COUNTRY,
                           A.A_PORT_CODE,
                           A.A_PORT_NAME,
                           A.SHIPPING_COMPANY,
                           A.TO_COUNTRY,
                           A.TO_CITY,
                           A.SHIP_DOC_PREPARATION_DATE,
                           A.LT_DEPARTURE_INLAND,
                           A.LT_WAIT_SHIPPING,
                           A.LT_VOYAGE,
                           A.LT_LAY_OFF_CLEARANCE,
                           A.LT_ARRIVAL_INLAND,
                           NVL(A.LT_DEPARTURE_INLAND, 0) + NVL(A.LT_WAIT_SHIPPING, 0) + NVL(A.LT_VOYAGE, 0) +
                               NVL(A.LT_LAY_OFF_CLEARANCE, 0) + NVL(A.LT_ARRIVAL_INLAND, 0) AS LT_SUM,
                           A.VALID_YN,
                           A.CREATED_BY,
                           A.CREATION_DATE,
                           A.LAST_UPDATED_BY,
                           A.LAST_UPDATE_DATE,
                           A.LT_TYPE,
                           A.ATTRIBUTE1,
                           A.ATTRIBUTE2,
                           A.ATTRIBUTE3
                      FROM SCP_MST_DISTRIBUTION_ROUTE A
--                     WHERE (P_TRANSPORT_MODE IS NULL OR P_TRANSPORT_MODE = ''
--                            OR A.TRANSPORT_MODE IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TRANSPORT_MODE, ','))))
--                       AND (P_VALID_YN IS NULL OR P_VALID_YN = '' OR A.VALID_YN = P_VALID_YN)
                     WHERE (TRIM(P_TRANSPORT_MODE) IS NULL
                            OR UPPER(TRIM(P_TRANSPORT_MODE)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */  -- 2026.09.17 AJS 공백만 입력 = 조건 없음(AS-IS '' 비교)
                            OR A.TRANSPORT_MODE IN (SELECT UPPER(TOKEN) FROM TABLE(UF_FX_STRING_SPLIT(P_TRANSPORT_MODE, ','))))  -- 2026.09.17 AJS 대소문자 무시
                       AND (TRIM(SUBSTR(P_VALID_YN, 1, 1)) IS NULL
                            OR UPPER(TRIM(P_VALID_YN)) = 'ALL'   /* ★한 글자만 잘라 쓰므로 자르기 전에 판정한다 — ALL 이 A 로 잘리면 0행 */ OR A.VALID_YN = UPPER(SUBSTR(P_VALID_YN, 1, 1)))  -- 2026.09.17 AJS AS-IS 인자 nvarchar(1)
                   ) T
--             WHERE (P_FROM_COUNTRY IS NULL OR P_FROM_COUNTRY = '' OR T.FROM_COUNTRY = UPPER(P_FROM_COUNTRY))
--               AND (P_FROM_CITY    IS NULL OR P_FROM_CITY    = '' OR T.FROM_CITY LIKE UPPER(P_FROM_CITY) || '%')
--               AND (P_TO_COUNTRY   IS NULL OR P_TO_COUNTRY   = '' OR T.TO_COUNTRY = UPPER(P_TO_COUNTRY))
--               AND (P_TO_CITY      IS NULL OR P_TO_CITY      = '' OR T.TO_CITY LIKE UPPER(P_TO_CITY) || '%')
--             ORDER BY T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, T.PRIORITY;
             WHERE (TRIM(P_FROM_COUNTRY) IS NULL OR P_FROM_COUNTRY = 'ALL'  OR T.FROM_COUNTRY = UPPER(P_FROM_COUNTRY))  -- 2026.09.17 AJS 공백만 입력 = 조건 없음
               AND (TRIM(P_FROM_CITY)    IS NULL OR P_FROM_CITY    = 'ALL'  OR T.FROM_CITY LIKE UPPER(P_FROM_CITY) || '%')  -- 2026.09.17 AJS
               AND (TRIM(P_TO_COUNTRY)   IS NULL OR P_TO_COUNTRY   = 'ALL'  OR T.TO_COUNTRY = UPPER(P_TO_COUNTRY))  -- 2026.09.17 AJS
               AND (TRIM(P_TO_CITY)      IS NULL OR P_TO_CITY      = 'ALL'  OR T.TO_CITY LIKE UPPER(P_TO_CITY) || '%')  -- 2026.09.17 AJS
             ORDER BY T.FROM_COUNTRY, T.FROM_CITY, T.TO_COUNTRY, T.TO_CITY, T.PRIORITY NULLS FIRST, T.ROUTE_ID;  -- 2026.09.17 AJS 동률 순서 고정

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0005_GET_DISTRIBUTION_ROUTE;

    -- 2026.09.17 AJS 조회 3 · 저장 · 엑셀 업로드 추가 (START)
    /*==================================================================================================
     * 내부 : '^' 구분 CLOB 을 토큰 배열로 나눔
     *        AS-IS SCM_ARR_SPL_CNT(토큰 수 = 구분자 수 + 1) · SCM_ARR_SPL_VAL(토큰 앞뒤 공백 제거) 과 같은 결과
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


    /* 내부 : 토큰 꺼내기 (AS-IS SCM_ARR_SPL_VAL — 범위 밖이면 NULL) */
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


    /* 내부 : AS-IS 반복 조건 WHILE LEN(@p_active_flag) > 0 (공백만 있으면 0) */
    FUNCTION F_HAS_TEXT
    (
        P_TEXT  IN  CLOB
    )
    RETURN BOOLEAN
    IS
    BEGIN
        IF P_TEXT IS NULL OR DBMS_LOB.GETLENGTH(P_TEXT) = 0 THEN
            RETURN FALSE;
        END IF;
        IF DBMS_LOB.GETLENGTH(P_TEXT) > 4000 THEN
            RETURN TRUE;
        END IF;
        RETURN TRIM(DBMS_LOB.SUBSTR(P_TEXT, 4000, 1)) IS NOT NULL;
    END F_HAS_TEXT;


    /* 내부 : AS-IS nvarchar → int / bigint 암시 변환
     *        빈 값·공백 = 0, 부호 있는 정수만 허용(소수점 · 지수 · 쉼표는 변환 오류), 범위 초과는 오류 */
    FUNCTION F_TO_INT
    (
        P_VALUE  IN  VARCHAR2,
        P_BIG    IN  VARCHAR2 DEFAULT 'N'
    )
    RETURN NUMBER
    IS
        V_TXT  VARCHAR2(4000 CHAR) := TRIM(P_VALUE);
        V_NUM  NUMBER;
        V_TP   VARCHAR2(10 CHAR)   := CASE WHEN P_BIG = 'Y' THEN 'bigint' ELSE 'int' END;
    BEGIN
        IF V_TXT IS NULL THEN
            RETURN 0;
        END IF;

        IF NOT REGEXP_LIKE(V_TXT, '^[+-]?[0-9]+$') THEN
            RAISE_APPLICATION_ERROR(-20245, 'Conversion failed when converting the nvarchar value '''
                                            || SUBSTR(P_VALUE, 1, 200) || ''' to data type ' || V_TP || '.');
        END IF;

        V_NUM := TO_NUMBER(V_TXT);

        IF    (P_BIG =  'Y' AND (V_NUM > 9223372036854775807 OR V_NUM < -9223372036854775808))
           OR (P_BIG <> 'Y' AND (V_NUM > 2147483647 OR V_NUM < -2147483648)) THEN
            RAISE_APPLICATION_ERROR(-20248, 'The conversion of the nvarchar value '''
                                            || SUBSTR(P_VALUE, 1, 200) || ''' overflowed an ' || V_TP || ' column.');
        END IF;

        RETURN V_NUM;
    END F_TO_INT;


    /* 내부 : AS-IS 컬럼 길이(nvarchar) 초과 검사 — Oracle 컬럼은 바이트 단위로 넓어져 있어 그대로 들어가므로 따로 막음 */
    PROCEDURE P_CHK_LEN
    (
        P_ROW  IN  T_ROUTE_ROW
    )
    IS
        PROCEDURE P_ONE
        (
            P_VALUE  IN  VARCHAR2,
            P_MAX    IN  PLS_INTEGER,
            P_COL    IN  VARCHAR2
        )
        IS
        BEGIN
            IF LENGTH(RTRIM(P_VALUE)) > P_MAX THEN
                RAISE_APPLICATION_ERROR(-20628, 'String or binary data would be truncated in table ''SCP_MST_DISTRIBUTION_ROUTE_H'', column '''
                                                || P_COL || '''. Truncated value: ''' || SUBSTR(P_VALUE, 1, P_MAX) || '''.');
            END IF;
        END P_ONE;
    BEGIN
        P_ONE(P_ROW.FROM_COUNTRY,              3,   'FROM_COUNTRY');
        P_ONE(P_ROW.FROM_CITY,                 5,   'FROM_CITY');
        P_ONE(P_ROW.TRANSPORT_MODE,            50,  'TRANSPORT_MODE');
        P_ONE(P_ROW.DAYS_MON,                  1,   'DAYS_MON');
        P_ONE(P_ROW.DAYS_TUE,                  1,   'DAYS_TUE');
        P_ONE(P_ROW.DAYS_WED,                  1,   'DAYS_WED');
        P_ONE(P_ROW.DAYS_THU,                  1,   'DAYS_THU');
        P_ONE(P_ROW.DAYS_FRI,                  1,   'DAYS_FRI');
        P_ONE(P_ROW.DAYS_SAT,                  1,   'DAYS_SAT');
        P_ONE(P_ROW.DAYS_SUN,                  1,   'DAYS_SUN');
        P_ONE(P_ROW.D_COUNTRY,                 3,   'D_COUNTRY');
        P_ONE(P_ROW.D_PORT_CODE,               10,  'D_PORT_CODE');
        P_ONE(P_ROW.D_PORT_NAME,               50,  'D_PORT_NAME');
        P_ONE(P_ROW.A_COUNTRY,                 3,   'A_COUNTRY');
        P_ONE(P_ROW.A_PORT_CODE,               10,  'A_PORT_CODE');
        P_ONE(P_ROW.A_PORT_NAME,               50,  'A_PORT_NAME');
        P_ONE(P_ROW.SHIPPING_COMPANY,          30,  'SHIPPING_COMPANY');
        P_ONE(P_ROW.TO_COUNTRY,                3,   'TO_COUNTRY');
        P_ONE(P_ROW.TO_CITY,                   5,   'TO_CITY');
        P_ONE(P_ROW.SHIP_DOC_PREPARATION_DATE, 10,  'SHIP_DOC_PREPARATION_DATE');
        P_ONE(P_ROW.VALID_YN,                  1,   'VALID_YN');
        P_ONE(P_ROW.LT_TYPE,                   100, 'LT_TYPE');
        P_ONE(P_ROW.ONE_SEGMENT_COST,          150, 'ATTRIBUTE1');
        P_ONE(P_ROW.TWO_SEGMENT_COST,          150, 'ATTRIBUTE2');
        P_ONE(P_ROW.THREE_SEGMENT_COST,        150, 'ATTRIBUTE3');
    END P_CHK_LEN;


    /* 내부 : 오류 로그 (AS-IS CATCH 의 scm_sys_log_batch INSERT — 자율 트랜잭션이라 되돌림과 무관하게 남음) */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_MSG           IN  VARCHAR2,
        P_SQL_CODE      IN  VARCHAR2,
        P_BACKTRACE     IN  VARCHAR2
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , 'ERROR'
                           , NULL
                           , SUBSTR(P_MSG, 1, 1000)
                           , NULL
                           , SYSDATE
                           , NULL
                           , P_SQL_CODE
                           , SUBSTR(P_MSG, 1, 1000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;


    /*==================================================================================================
     * Program ID   : PR_SCP_MST_DISTRIBUTION_ROUTE_HIST
     * Description  : Distribution Route Master History
     * Program History
     *===================================================================================================
     *   Date       In Charge			Description
     *===================================================================================================
     * 2018.03.12   byunghunjung		Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2019.02.12	hwyoon				[CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
     * 2026.09.17   AJS                 Oracle 전환 — 기준 DB 에 없는 단독 프로시저를 패키지 내부로 편입
     *
     * AS-IS nvarchar 인자를 이력 테이블 숫자 컬럼에 넣을 때의 암시 변환('' = 0)을 F_TO_INT 로 재현
     *==================================================================================================*/
    PROCEDURE P_ROUTE_HIST
    (
        P_ROW            IN  T_ROUTE_ROW,
        P_USER_ID        IN  VARCHAR2,
        P_CREATION_DATE  IN  DATE
    )
    IS
        N_ROUTE_ID               NUMBER;
        N_PRIORITY               NUMBER;
        N_LT_DEPARTURE_INLAND    NUMBER;
        N_LT_WAIT_SHIPPING       NUMBER;
        N_LT_VOYAGE              NUMBER;
        N_LT_LAY_OFF_CLEARANCE   NUMBER;
        N_LT_ARRIVAL_INLAND      NUMBER;
    BEGIN
        P_CHK_LEN(P_ROW);

        N_ROUTE_ID             := F_TO_INT(P_ROW.ROUTE_ID, 'Y');
        N_PRIORITY             := F_TO_INT(P_ROW.PRIORITY);
        N_LT_DEPARTURE_INLAND  := F_TO_INT(P_ROW.LT_DEPARTURE_INLAND);
        N_LT_WAIT_SHIPPING     := F_TO_INT(P_ROW.LT_WAIT_SHIPPING);
        N_LT_VOYAGE            := F_TO_INT(P_ROW.LT_VOYAGE);
        N_LT_LAY_OFF_CLEARANCE := F_TO_INT(P_ROW.LT_LAY_OFF_CLEARANCE);
        N_LT_ARRIVAL_INLAND    := F_TO_INT(P_ROW.LT_ARRIVAL_INLAND);

        INSERT
          INTO SCP_MST_DISTRIBUTION_ROUTE_H
             ( HISTORY_SEQ
             , ROUTE_ID
             , FROM_COUNTRY
             , FROM_CITY
             /* ,from_city_name */
             , TRANSPORT_MODE
             , PRIORITY
             , DAYS_MON
             , DAYS_TUE
             , DAYS_WED
             , DAYS_THU
             , DAYS_FRI
             , DAYS_SAT
             , DAYS_SUN
             , D_COUNTRY
             , D_PORT_CODE
             , D_PORT_NAME
             , A_COUNTRY
             , A_PORT_CODE
             , A_PORT_NAME
             , SHIPPING_COMPANY
             , TO_COUNTRY
             , TO_CITY
             /* ,to_city_name */
             , SHIP_DOC_PREPARATION_DATE
             , LT_DEPARTURE_INLAND
             , LT_WAIT_SHIPPING
             , LT_VOYAGE
             , LT_LAY_OFF_CLEARANCE
             , LT_ARRIVAL_INLAND
             , VALID_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             , LT_TYPE
             , ATTRIBUTE1                      /* One_SEGMENT_COST */
             , ATTRIBUTE2                      /* Two_SEGMENT_COST */
             , ATTRIBUTE3                      /* Three_SEGMENT_COST */
             )
        VALUES
             ( SEQ1_SCP_MST_DISTRIBUTION_ROUTE_H.NEXTVAL
             , N_ROUTE_ID
             , P_ROW.FROM_COUNTRY
             , P_ROW.FROM_CITY
             , P_ROW.TRANSPORT_MODE
             , N_PRIORITY
             , P_ROW.DAYS_MON
             , P_ROW.DAYS_TUE
             , P_ROW.DAYS_WED
             , P_ROW.DAYS_THU
             , P_ROW.DAYS_FRI
             , P_ROW.DAYS_SAT
             , P_ROW.DAYS_SUN
             , P_ROW.D_COUNTRY
             , P_ROW.D_PORT_CODE
             , P_ROW.D_PORT_NAME
             , P_ROW.A_COUNTRY
             , P_ROW.A_PORT_CODE
             , P_ROW.A_PORT_NAME
             , P_ROW.SHIPPING_COMPANY
             , P_ROW.TO_COUNTRY
             , P_ROW.TO_CITY
             , P_ROW.SHIP_DOC_PREPARATION_DATE
             , N_LT_DEPARTURE_INLAND
             , N_LT_WAIT_SHIPPING
             , N_LT_VOYAGE
             , N_LT_LAY_OFF_CLEARANCE
             , N_LT_ARRIVAL_INLAND
             , NVL(P_ROW.VALID_YN, '-')        /* AS-IS 빈 문자 = 이관 채움값 '-' */
             , P_USER_ID
             , P_CREATION_DATE
             , P_USER_ID
             , SYSDATE
             , SYSDATE
             , P_ROW.LT_TYPE
             , P_ROW.ONE_SEGMENT_COST
             , P_ROW.TWO_SEGMENT_COST
             , P_ROW.THREE_SEGMENT_COST
             );
    END P_ROUTE_HIST;


    /*==================================================================================================
     * Program ID   : [SCP0005_GET_DISTRIBUTION_ROUTEID]
     * Description  : Distribution Route ID 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2023/08/11   vadabi3		Initial Release
     * 2023/08/23   vadabi3		개발DB 이슈로 백업본으로 복구
     * 2026/09/17   AJS             Oracle 전환 (PKG_SCP0005.P_SCP0005_GET_ROUTEID)
     *
     * AS-IS 조건 route_id = @p_route_id 는 nvarchar → bigint 변환(빈 값 = 0, 숫자가 아니면 오류)
     *==================================================================================================*/
    PROCEDURE P_SCP0005_GET_ROUTEID
    (
        P_ROUTE_ID        IN  VARCHAR2,
        O_RC              OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        N_ROUTE_ID  NUMBER;
    BEGIN
        N_ROUTE_ID := F_TO_INT(P_ROUTE_ID, 'Y');      /* AS-IS 빈 값 = 0 */

        /* Distribution Route확인 */
        OPEN O_RC FOR
        SELECT T.ROUTE_ID
             , T.FROM_COUNTRY
             , T.FROM_CITY
             , (SELECT SA.CITY_NAME
                  FROM SCM_MST_CITY SA
                 WHERE SA.COUNTRY = T.FROM_COUNTRY
                   AND SA.CITY    = T.FROM_CITY)                    AS FROM_CITY_NAME
             /* ,transport_mode as transport_mode_code */
             , T.TRANSPORT_MODE
             , (SELECT SB.SEGMENT2
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SB
                 WHERE NVL(SB.SEGMENT1, ' ') = NVL(T.TRANSPORT_MODE, ' ')
                   AND SB.LOOKUP_TYPE       = 'TRANSPORT_MODE_CODE'
                   AND ROWNUM               = 1)                    AS TRANSPORT_MODE_NAME
             , T.PRIORITY
             , T.DAYS_MON
             , T.DAYS_TUE
             , T.DAYS_WED
             , T.DAYS_THU
             , T.DAYS_FRI
             , T.DAYS_SAT
             , T.DAYS_SUN
             , CASE WHEN LENGTH(RTRIM(T.DAYS)) > 3
                    THEN SUBSTR(T.DAYS, 1, LENGTH(RTRIM(T.DAYS)) - 1)
                    ELSE T.DAYS
               END                                                  AS DAYS
             , T.D_COUNTRY
             , T.D_PORT_CODE
             , T.D_PORT_NAME
             , T.A_COUNTRY
             , T.A_PORT_CODE
             , T.A_PORT_NAME
             , T.SHIPPING_COMPANY
             , T.TO_COUNTRY
             , T.TO_CITY
             , (SELECT SC.CITY_NAME
                  FROM SCM_MST_CITY SC
                 WHERE SC.COUNTRY = T.TO_COUNTRY
                   AND SC.CITY    = T.TO_CITY)                      AS TO_CITY_NAME
             , T.SHIP_DOC_PREPARATION_DATE
             , T.LT_DEPARTURE_INLAND
             , T.LT_WAIT_SHIPPING
             , T.LT_VOYAGE
             , T.LT_LAY_OFF_CLEARANCE
             , T.LT_ARRIVAL_INLAND
             , T.LT_SUM
             , T.VALID_YN
             , T.CREATED_BY
             , T.CREATION_DATE
             , T.LAST_UPDATED_BY
             , T.LAST_UPDATE_DATE
             , T.LT_TYPE
--             , T.ATTRIBUTE1                                         AS "One_SEGMENT_COST"   --  2026.10.08 AJS
             , T.ATTRIBUTE1                                         AS "ONE_SEGMENT_COST"   --  2026.10.08 AJS
--             , T.ATTRIBUTE2                                         AS "Two_SEGMENT_COST"   --  2026.10.08 AJS
             , T.ATTRIBUTE2                                         AS "TWO_SEGMENT_COST"   --  2026.10.08 AJS
--             , T.ATTRIBUTE3                                         AS "Three_SEGMENT_COST"   --  2026.10.08 AJS
             , T.ATTRIBUTE3                                         AS "THREE_SEGMENT_COST"   --  2026.10.08 AJS
          FROM (SELECT A.ROUTE_ID
                     , A.FROM_COUNTRY
                     , A.FROM_CITY
                     , A.TRANSPORT_MODE
                     , A.PRIORITY
                     , A.DAYS_MON
                     , A.DAYS_TUE
                     , A.DAYS_WED
                     , A.DAYS_THU
                     , A.DAYS_FRI
                     , A.DAYS_SAT
                     , A.DAYS_SUN
                     , CASE WHEN A.DAYS_MON = 'Y' THEN 'Mon, ' END
                    || CASE WHEN A.DAYS_TUE = 'Y' THEN 'Tue, ' END
                    || CASE WHEN A.DAYS_WED = 'Y' THEN 'Wed, ' END
                    || CASE WHEN A.DAYS_THU = 'Y' THEN 'Thu, ' END
                    || CASE WHEN A.DAYS_FRI = 'Y' THEN 'Fri, ' END
                    || CASE WHEN A.DAYS_SAT = 'Y' THEN 'Sat, ' END
                    || CASE WHEN A.DAYS_SUN = 'Y' THEN 'Sun, ' END  AS DAYS
                     , A.D_COUNTRY
                     , A.D_PORT_CODE
                     , A.D_PORT_NAME
                     , A.A_COUNTRY
                     , A.A_PORT_CODE
                     , A.A_PORT_NAME
                     , A.SHIPPING_COMPANY
                     , A.TO_COUNTRY
                     , A.TO_CITY
                     /* ,a.to_city_name */
                     , A.SHIP_DOC_PREPARATION_DATE
                     , A.LT_DEPARTURE_INLAND
                     , A.LT_WAIT_SHIPPING
                     , A.LT_VOYAGE
                     , A.LT_LAY_OFF_CLEARANCE
                     , A.LT_ARRIVAL_INLAND
                     , NVL(A.LT_DEPARTURE_INLAND, 0)
                     + NVL(A.LT_WAIT_SHIPPING, 0)
                     + NVL(A.LT_VOYAGE, 0)
                     + NVL(A.LT_LAY_OFF_CLEARANCE, 0)
                     + NVL(A.LT_ARRIVAL_INLAND, 0)                  AS LT_SUM
                     , A.VALID_YN
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , A.LT_TYPE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                  FROM SCP_MST_DISTRIBUTION_ROUTE A
                 WHERE A.ROUTE_ID = N_ROUTE_ID) T
         ORDER BY T.FROM_COUNTRY
                , T.FROM_CITY
                , T.TO_COUNTRY
                , T.TO_CITY
                , T.PRIORITY NULLS FIRST;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'       AS CODE
             , 'SUCCESS' AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0005_GET_ROUTEID;


    /*==================================================================================================
     * Program ID   : [SCP0005_GET_DISTRIBUTION_HISTORY_ROUTEID]
     * Description  : Distribution Route ID 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2023/09/02   vadabi3		Initial Release
     * 2026/09/17   AJS             Oracle 전환 (PKG_SCP0005.P_SCP0005_GET_ROUTE_HIST)
     *
     * 정렬 : AS-IS 정렬 키(출발 · 도착 · Priority)가 같은 이력은 순서가 정해지지 않음 → 마지막 키로 HISTORY_SEQ 추가
     * 빈 Route Id 는 AS-IS 와 같이 0 으로 변환(신규 등록 행의 이력 = Route Id 0)
     *==================================================================================================*/
    PROCEDURE P_SCP0005_GET_ROUTE_HIST
    (
        P_ROUTE_ID        IN  VARCHAR2,
        O_RC              OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        N_ROUTE_ID  NUMBER;
    BEGIN
        N_ROUTE_ID := F_TO_INT(P_ROUTE_ID, 'Y');      /* AS-IS 빈 값 = 0 */

        OPEN O_RC FOR
        SELECT T.ROUTE_ID
             , T.FROM_COUNTRY
             , T.FROM_CITY
             , (SELECT SA.CITY_NAME
                  FROM SCM_MST_CITY SA
                 WHERE SA.COUNTRY = T.FROM_COUNTRY
                   AND SA.CITY    = T.FROM_CITY)                    AS FROM_CITY_NAME
             , T.TRANSPORT_MODE
             , (SELECT SB.SEGMENT2
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL SB
                 WHERE NVL(SB.SEGMENT1, ' ') = NVL(T.TRANSPORT_MODE, ' ')
                   AND SB.LOOKUP_TYPE       = 'TRANSPORT_MODE_CODE'
                   AND ROWNUM               = 1)                    AS TRANSPORT_MODE_NAME
             , T.PRIORITY
             , T.DAYS_MON
             , T.DAYS_TUE
             , T.DAYS_WED
             , T.DAYS_THU
             , T.DAYS_FRI
             , T.DAYS_SAT
             , T.DAYS_SUN
             , CASE WHEN LENGTH(RTRIM(T.DAYS)) > 3
                    THEN SUBSTR(T.DAYS, 1, LENGTH(RTRIM(T.DAYS)) - 1)
                    ELSE T.DAYS
               END                                                  AS DAYS
             , T.D_COUNTRY
             , T.D_PORT_CODE
             , T.D_PORT_NAME
             , T.A_COUNTRY
             , T.A_PORT_CODE
             , T.A_PORT_NAME
             , T.SHIPPING_COMPANY
             , T.TO_COUNTRY
             , T.TO_CITY
             , (SELECT SC.CITY_NAME
                  FROM SCM_MST_CITY SC
                 WHERE SC.COUNTRY = T.TO_COUNTRY
                   AND SC.CITY    = T.TO_CITY)                      AS TO_CITY_NAME
             , T.SHIP_DOC_PREPARATION_DATE
             , T.LT_DEPARTURE_INLAND
             , T.LT_WAIT_SHIPPING
             , T.LT_VOYAGE
             , T.LT_LAY_OFF_CLEARANCE
             , T.LT_ARRIVAL_INLAND
             , T.LT_SUM
             , T.VALID_YN
             , T.CREATED_BY
             , T.CREATION_DATE
             , T.LAST_UPDATED_BY
             , T.LAST_UPDATE_DATE
             /* ,t.lt_type */
--             , T.ATTRIBUTE1                                         AS "One_SEGMENT_COST"   --  2026.10.08 AJS
             , T.ATTRIBUTE1                                         AS "ONE_SEGMENT_COST"   --  2026.10.08 AJS
--             , T.ATTRIBUTE2                                         AS "Two_SEGMENT_COST"   --  2026.10.08 AJS
             , T.ATTRIBUTE2                                         AS "TWO_SEGMENT_COST"   --  2026.10.08 AJS
--             , T.ATTRIBUTE3                                         AS "Three_SEGMENT_COST"   --  2026.10.08 AJS
             , T.ATTRIBUTE3                                         AS "THREE_SEGMENT_COST"   --  2026.10.08 AJS
          FROM (SELECT A.HISTORY_SEQ
                     , A.ROUTE_ID
                     , A.FROM_COUNTRY
                     , A.FROM_CITY
                     , A.TRANSPORT_MODE
                     , A.PRIORITY
                     , A.DAYS_MON
                     , A.DAYS_TUE
                     , A.DAYS_WED
                     , A.DAYS_THU
                     , A.DAYS_FRI
                     , A.DAYS_SAT
                     , A.DAYS_SUN
                     , CASE WHEN A.DAYS_MON = 'Y' THEN 'Mon, ' END
                    || CASE WHEN A.DAYS_TUE = 'Y' THEN 'Tue, ' END
                    || CASE WHEN A.DAYS_WED = 'Y' THEN 'Wed, ' END
                    || CASE WHEN A.DAYS_THU = 'Y' THEN 'Thu, ' END
                    || CASE WHEN A.DAYS_FRI = 'Y' THEN 'Fri, ' END
                    || CASE WHEN A.DAYS_SAT = 'Y' THEN 'Sat, ' END
                    || CASE WHEN A.DAYS_SUN = 'Y' THEN 'Sun, ' END  AS DAYS
                     , A.D_COUNTRY
                     , A.D_PORT_CODE
                     , A.D_PORT_NAME
                     , A.A_COUNTRY
                     , A.A_PORT_CODE
                     , A.A_PORT_NAME
                     , A.SHIPPING_COMPANY
                     , A.TO_COUNTRY
                     , A.TO_CITY
                     , A.SHIP_DOC_PREPARATION_DATE
                     , A.LT_DEPARTURE_INLAND
                     , A.LT_WAIT_SHIPPING
                     , A.LT_VOYAGE
                     , A.LT_LAY_OFF_CLEARANCE
                     , A.LT_ARRIVAL_INLAND
                     , NVL(A.LT_DEPARTURE_INLAND, 0)
                     + NVL(A.LT_WAIT_SHIPPING, 0)
                     + NVL(A.LT_VOYAGE, 0)
                     + NVL(A.LT_LAY_OFF_CLEARANCE, 0)
                     + NVL(A.LT_ARRIVAL_INLAND, 0)                  AS LT_SUM
                     , A.VALID_YN
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , A.ATTRIBUTE1
                     , A.ATTRIBUTE2
                     , A.ATTRIBUTE3
                  FROM SCP_MST_DISTRIBUTION_ROUTE_H A
                 WHERE A.ROUTE_ID = N_ROUTE_ID) T
         ORDER BY T.FROM_COUNTRY
                , T.FROM_CITY
                , T.TO_COUNTRY
                , T.TO_CITY
                , T.PRIORITY NULLS FIRST
                , T.HISTORY_SEQ;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'       AS CODE
             , 'SUCCESS' AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0005_GET_ROUTE_HIST;


    /*==================================================================================================
     * Program ID   : [SCP0007_GET_COUNTRY_CITY]
     * Description  : DIVISION, SITE별 국가코드, 도시코드 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/04/05   PJS   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2026/09/17   AJS   Oracle 전환 (PKG_SCP0005.P_SCP0005_GET_COUNTRY_CITY)
     *
     * AS-IS 인자 길이 nvarchar(3) · (5) · (100) 초과분은 잘려서 비교 → SUBSTR 로 재현
     * 도시명 LIKE 는 대소문자 무시 → 컬럼 · 입력 모두 UPPER (국가 · 도시 코드는 원장이 대문자뿐이라 입력만 UPPER)
     *==================================================================================================*/
    PROCEDURE P_SCP0005_GET_COUNTRY_CITY
    (
        P_COUNTRY         IN  VARCHAR2,
        P_CITY            IN  VARCHAR2,
        P_CITY_NAME       IN  VARCHAR2,
        O_RC              OUT SYS_REFCURSOR,
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_COUNTRY    VARCHAR2(3 CHAR)   := UPPER(SUBSTR(P_COUNTRY, 1, 3));
        V_CITY       VARCHAR2(5 CHAR)   := UPPER(SUBSTR(P_CITY, 1, 5));
        V_CITY_NAME  VARCHAR2(100 CHAR) := UPPER(SUBSTR(P_CITY_NAME, 1, 100));
    BEGIN
        OPEN O_RC FOR
        SELECT A.COUNTRY
             , A.CITY
             , A.CITY_NAME
          FROM SCM_MST_CITY A
         WHERE A.VALID_YN = 'Y'
           AND (RTRIM(V_COUNTRY)   IS NULL OR A.COUNTRY LIKE V_COUNTRY || '%')
           AND (RTRIM(V_CITY)      IS NULL OR A.CITY    LIKE V_CITY || '%')
           AND (RTRIM(V_CITY_NAME) IS NULL OR UPPER(A.CITY_NAME) LIKE '%' || V_CITY_NAME || '%')
         ORDER BY A.COUNTRY
                , A.CITY
                , A.CITY_NAME;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'       AS CODE
             , 'SUCCESS' AS MSG
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            DECLARE
                V_ERR VARCHAR2(4000) := SUBSTR(SQLERRM, 1, 4000);
            BEGIN
                OPEN O_RC FOR SELECT NULL AS DUMMY FROM DUAL WHERE 1 = 0;
                OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR AS MSG FROM DUAL;
            END;
    END P_SCP0005_GET_COUNTRY_CITY;


    /*==================================================================================================
     * Program ID   : SCP0005_SAVE_DISTRIBUTION_ROUTE
     * Description  : Distribution Route 등록, 수정, 삭제
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/03/08   pjs   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/04/05   PJS   소문자 입력시 대문자로 변환하여 저장
     * 2019/02/12   YHW   [CSR ID:3907873] SSP Distribution route/BOD상 'L/T TYPE'컬럼 추가요청
     * 2026/09/17   AJS   Oracle 전환 (PKG_SCP0005.P_SCP0005_SAVE_ROUTE)
     *
     * 결과 커서 : CODE(0 / -1) · MSG · EVENT(처리 행 수) · RESULT_CODE(S / F) · RESULT_CNT
     *            실패 시 AS-IS 오류 결과(err_code · err_message · 오류 행 값) 컬럼을 함께 반환
     * 중복 오류 코드 : 99020 DUP PRIORITY. / 99010 DUP DATA. (AS-IS 와 같음 — 화면이 이 코드로 오류 행 표시)
     *==================================================================================================*/
    PROCEDURE P_SCP0005_SAVE_ROUTE
    (
        P_ACTIVE_FLAG                IN  CLOB,
        P_ROUTE_ID                   IN  CLOB,
        P_FROM_COUNTRY               IN  CLOB,
        P_FROM_CITY                  IN  CLOB,
        P_FROM_CITY_NAME             IN  CLOB,
        P_TRANSPORT_MODE             IN  CLOB,
        P_PRIORITY                   IN  CLOB,
        P_DAYS_MON                   IN  CLOB,
        P_DAYS_TUE                   IN  CLOB,
        P_DAYS_WED                   IN  CLOB,
        P_DAYS_THU                   IN  CLOB,
        P_DAYS_FRI                   IN  CLOB,
        P_DAYS_SAT                   IN  CLOB,
        P_DAYS_SUN                   IN  CLOB,
        P_D_COUNTRY                  IN  CLOB,
        P_D_PORT_CODE                IN  CLOB,
        P_D_PORT_NAME                IN  CLOB,
        P_A_COUNTRY                  IN  CLOB,
        P_A_PORT_CODE                IN  CLOB,
        P_A_PORT_NAME                IN  CLOB,
        P_SHIPPING_COMPANY           IN  CLOB,
        P_TO_COUNTRY                 IN  CLOB,
        P_TO_CITY                    IN  CLOB,
        P_TO_CITY_NAME               IN  CLOB,
        P_SHIP_DOC_PREPARATION_DATE  IN  CLOB,
        P_LT_DEPARTURE_INLAND        IN  CLOB,
        P_LT_WAIT_SHIPPING           IN  CLOB,
        P_LT_VOYAGE                  IN  CLOB,
        P_LT_LAY_OFF_CLEARANCE       IN  CLOB,
        P_LT_ARRIVAL_INLAND          IN  CLOB,
        P_VALID_YN                   IN  CLOB,
        P_LT_TYPE                    IN  CLOB,
        P_ONE_SEGMENT_COST           IN  CLOB,
        P_TWO_SEGMENT_COST           IN  CLOB,
        P_THREE_SEGMENT_COST         IN  CLOB,
        P_USER_ID                    IN  VARCHAR2,
        O_RESULT_CURSOR              OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME      VARCHAR2(150 CHAR)  := C_PKG_NAME || '.P_SCP0005_SAVE_ROUTE';
        V_CREATION_DATE     DATE                := SYSDATE;
        V_MAX_LOOP_CNT      PLS_INTEGER         := 0;
        V_MST_LOOP_CNT      PLS_INTEGER         := 0;
        V_N                 PLS_INTEGER;
        V_DATA_DUP_CNT      PLS_INTEGER         := 0;
        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_ROW               T_ROUTE_ROW;
        N_ROUTE_ID          NUMBER;
        N_PRIORITY          NUMBER;
        N_LT_DEP            NUMBER;
        N_LT_WAIT           NUMBER;
        N_LT_VOYAGE         NUMBER;
        N_LT_LAYOFF         NUMBER;
        N_LT_ARR            NUMBER;
        V_ERR_CODE          VARCHAR2(40 CHAR);
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
        V_BACKTRACE         VARCHAR2(4000 CHAR);
        E_DUP               EXCEPTION;

        T_ACTIVE_FLAG       T_TOKEN_TAB;
        T_ROUTE_ID          T_TOKEN_TAB;
        T_FROM_COUNTRY      T_TOKEN_TAB;
        T_FROM_CITY         T_TOKEN_TAB;
        T_FROM_CITY_NAME    T_TOKEN_TAB;
        T_TRANSPORT_MODE    T_TOKEN_TAB;
        T_PRIORITY          T_TOKEN_TAB;
        T_DAYS_MON          T_TOKEN_TAB;
        T_DAYS_TUE          T_TOKEN_TAB;
        T_DAYS_WED          T_TOKEN_TAB;
        T_DAYS_THU          T_TOKEN_TAB;
        T_DAYS_FRI          T_TOKEN_TAB;
        T_DAYS_SAT          T_TOKEN_TAB;
        T_DAYS_SUN          T_TOKEN_TAB;
        T_D_COUNTRY         T_TOKEN_TAB;
        T_D_PORT_CODE       T_TOKEN_TAB;
        T_D_PORT_NAME       T_TOKEN_TAB;
        T_A_COUNTRY         T_TOKEN_TAB;
        T_A_PORT_CODE       T_TOKEN_TAB;
        T_A_PORT_NAME       T_TOKEN_TAB;
        T_SHIPPING_COMPANY  T_TOKEN_TAB;
        T_TO_COUNTRY        T_TOKEN_TAB;
        T_TO_CITY           T_TOKEN_TAB;
        T_TO_CITY_NAME      T_TOKEN_TAB;
        T_SHIP_DOC          T_TOKEN_TAB;
        T_LT_DEP            T_TOKEN_TAB;
        T_LT_WAIT           T_TOKEN_TAB;
        T_LT_VOYAGE         T_TOKEN_TAB;
        T_LT_LAYOFF         T_TOKEN_TAB;
        T_LT_ARR            T_TOKEN_TAB;
        T_VALID_YN          T_TOKEN_TAB;
        T_LT_TYPE           T_TOKEN_TAB;
        T_COST1             T_TOKEN_TAB;
        T_COST2             T_TOKEN_TAB;
        T_COST3             T_TOKEN_TAB;

        /* 각 컬럼들에 대한 스플릿처리 — I 번째 행 */
        PROCEDURE P_READ
        (
            P_IDX  IN  PLS_INTEGER
        )
        IS
        BEGIN
            V_ACTIVE_FLAG                   := F_TK(T_ACTIVE_FLAG, P_IDX);
            V_ROW.ROUTE_ID                  := F_TK(T_ROUTE_ID, P_IDX);
            V_ROW.FROM_COUNTRY              := F_TK(T_FROM_COUNTRY, P_IDX);
            V_ROW.FROM_CITY                 := F_TK(T_FROM_CITY, P_IDX);
            V_ROW.FROM_CITY_NAME            := F_TK(T_FROM_CITY_NAME, P_IDX);
            V_ROW.TRANSPORT_MODE            := F_TK(T_TRANSPORT_MODE, P_IDX);
            V_ROW.PRIORITY                  := F_TK(T_PRIORITY, P_IDX);
            V_ROW.DAYS_MON                  := F_TK(T_DAYS_MON, P_IDX);
            V_ROW.DAYS_TUE                  := F_TK(T_DAYS_TUE, P_IDX);
            V_ROW.DAYS_WED                  := F_TK(T_DAYS_WED, P_IDX);
            V_ROW.DAYS_THU                  := F_TK(T_DAYS_THU, P_IDX);
            V_ROW.DAYS_FRI                  := F_TK(T_DAYS_FRI, P_IDX);
            V_ROW.DAYS_SAT                  := F_TK(T_DAYS_SAT, P_IDX);
            V_ROW.DAYS_SUN                  := F_TK(T_DAYS_SUN, P_IDX);
            V_ROW.D_COUNTRY                 := F_TK(T_D_COUNTRY, P_IDX);
            V_ROW.D_PORT_CODE               := F_TK(T_D_PORT_CODE, P_IDX);
            V_ROW.D_PORT_NAME               := F_TK(T_D_PORT_NAME, P_IDX);
            V_ROW.A_COUNTRY                 := F_TK(T_A_COUNTRY, P_IDX);
            V_ROW.A_PORT_CODE               := F_TK(T_A_PORT_CODE, P_IDX);
            V_ROW.A_PORT_NAME               := F_TK(T_A_PORT_NAME, P_IDX);
            V_ROW.SHIPPING_COMPANY          := F_TK(T_SHIPPING_COMPANY, P_IDX);
            V_ROW.TO_COUNTRY                := F_TK(T_TO_COUNTRY, P_IDX);
            V_ROW.TO_CITY                   := F_TK(T_TO_CITY, P_IDX);
            V_ROW.TO_CITY_NAME              := F_TK(T_TO_CITY_NAME, P_IDX);
            V_ROW.SHIP_DOC_PREPARATION_DATE := F_TK(T_SHIP_DOC, P_IDX);
            V_ROW.LT_DEPARTURE_INLAND       := F_TK(T_LT_DEP, P_IDX);
            V_ROW.LT_WAIT_SHIPPING          := F_TK(T_LT_WAIT, P_IDX);
            V_ROW.LT_VOYAGE                 := F_TK(T_LT_VOYAGE, P_IDX);
            V_ROW.LT_LAY_OFF_CLEARANCE      := F_TK(T_LT_LAYOFF, P_IDX);
            V_ROW.LT_ARRIVAL_INLAND         := F_TK(T_LT_ARR, P_IDX);
            V_ROW.VALID_YN                  := F_TK(T_VALID_YN, P_IDX);
            V_ROW.LT_TYPE                   := F_TK(T_LT_TYPE, P_IDX);
            V_ROW.ONE_SEGMENT_COST          := F_TK(T_COST1, P_IDX);
            V_ROW.TWO_SEGMENT_COST          := F_TK(T_COST2, P_IDX);
            V_ROW.THREE_SEGMENT_COST        := F_TK(T_COST3, P_IDX);
        END P_READ;

    BEGIN

        SAVEPOINT SP_SCP0005_SAVE;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', SYSDATE);

        /* 프로시저 LOOP 길이를 판단 */
        P_SPLIT(P_ACTIVE_FLAG,               '^', T_ACTIVE_FLAG,      V_MAX_LOOP_CNT);
        P_SPLIT(P_ROUTE_ID,                  '^', T_ROUTE_ID,         V_N);
        P_SPLIT(P_FROM_COUNTRY,              '^', T_FROM_COUNTRY,     V_N);
        P_SPLIT(P_FROM_CITY,                 '^', T_FROM_CITY,        V_N);
        P_SPLIT(P_FROM_CITY_NAME,            '^', T_FROM_CITY_NAME,   V_N);
        P_SPLIT(P_TRANSPORT_MODE,            '^', T_TRANSPORT_MODE,   V_N);
        P_SPLIT(P_PRIORITY,                  '^', T_PRIORITY,         V_N);
        P_SPLIT(P_DAYS_MON,                  '^', T_DAYS_MON,         V_N);
        P_SPLIT(P_DAYS_TUE,                  '^', T_DAYS_TUE,         V_N);
        P_SPLIT(P_DAYS_WED,                  '^', T_DAYS_WED,         V_N);
        P_SPLIT(P_DAYS_THU,                  '^', T_DAYS_THU,         V_N);
        P_SPLIT(P_DAYS_FRI,                  '^', T_DAYS_FRI,         V_N);
        P_SPLIT(P_DAYS_SAT,                  '^', T_DAYS_SAT,         V_N);
        P_SPLIT(P_DAYS_SUN,                  '^', T_DAYS_SUN,         V_N);
        P_SPLIT(P_D_COUNTRY,                 '^', T_D_COUNTRY,        V_N);
        P_SPLIT(P_D_PORT_CODE,               '^', T_D_PORT_CODE,      V_N);
        P_SPLIT(P_D_PORT_NAME,               '^', T_D_PORT_NAME,      V_N);
        P_SPLIT(P_A_COUNTRY,                 '^', T_A_COUNTRY,        V_N);
        P_SPLIT(P_A_PORT_CODE,               '^', T_A_PORT_CODE,      V_N);
        P_SPLIT(P_A_PORT_NAME,               '^', T_A_PORT_NAME,      V_N);
        P_SPLIT(P_SHIPPING_COMPANY,          '^', T_SHIPPING_COMPANY, V_N);
        P_SPLIT(P_TO_COUNTRY,                '^', T_TO_COUNTRY,       V_N);
        P_SPLIT(P_TO_CITY,                   '^', T_TO_CITY,          V_N);
        P_SPLIT(P_TO_CITY_NAME,              '^', T_TO_CITY_NAME,     V_N);
        P_SPLIT(P_SHIP_DOC_PREPARATION_DATE, '^', T_SHIP_DOC,         V_N);
        P_SPLIT(P_LT_DEPARTURE_INLAND,       '^', T_LT_DEP,           V_N);
        P_SPLIT(P_LT_WAIT_SHIPPING,          '^', T_LT_WAIT,          V_N);
        P_SPLIT(P_LT_VOYAGE,                 '^', T_LT_VOYAGE,        V_N);
        P_SPLIT(P_LT_LAY_OFF_CLEARANCE,      '^', T_LT_LAYOFF,        V_N);
        P_SPLIT(P_LT_ARRIVAL_INLAND,         '^', T_LT_ARR,           V_N);
        P_SPLIT(P_VALID_YN,                  '^', T_VALID_YN,         V_N);
        P_SPLIT(P_LT_TYPE,                   '^', T_LT_TYPE,          V_N);
        P_SPLIT(P_ONE_SEGMENT_COST,          '^', T_COST1,            V_N);
        P_SPLIT(P_TWO_SEGMENT_COST,          '^', T_COST2,            V_N);
        P_SPLIT(P_THREE_SEGMENT_COST,        '^', T_COST3,            V_N);

        IF F_HAS_TEXT(P_ACTIVE_FLAG) THEN

            WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP

                /* @mst_loop_cnt 1증가 */
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                P_READ(V_MST_LOOP_CNT);

                /* 이력저장 */
                P_ROUTE_HIST(V_ROW, P_USER_ID, V_CREATION_DATE);

                /* nvarchar → int 변환 (AS-IS 암시 변환) */
                IF UPPER(V_ACTIVE_FLAG) IN ('M', 'I') THEN
                    N_PRIORITY  := F_TO_INT(V_ROW.PRIORITY);
                    N_LT_DEP    := F_TO_INT(V_ROW.LT_DEPARTURE_INLAND);
                    N_LT_WAIT   := F_TO_INT(V_ROW.LT_WAIT_SHIPPING);
                    N_LT_VOYAGE := F_TO_INT(V_ROW.LT_VOYAGE);
                    N_LT_LAYOFF := F_TO_INT(V_ROW.LT_LAY_OFF_CLEARANCE);
                    N_LT_ARR    := F_TO_INT(V_ROW.LT_ARRIVAL_INLAND);
                END IF;

                /* 수정 */
                IF UPPER(V_ACTIVE_FLAG) = 'M' THEN

                    N_ROUTE_ID := F_TO_INT(V_ROW.ROUTE_ID, 'Y');

                    UPDATE SCP_MST_DISTRIBUTION_ROUTE
                       SET FROM_COUNTRY              = UPPER(V_ROW.FROM_COUNTRY)
                         , FROM_CITY                 = UPPER(V_ROW.FROM_CITY)
                         /* , from_city_name            = @v_from_city_name */
                         , TRANSPORT_MODE            = V_ROW.TRANSPORT_MODE
                         , PRIORITY                  = N_PRIORITY
                         , DAYS_MON                  = V_ROW.DAYS_MON
                         , DAYS_TUE                  = V_ROW.DAYS_TUE
                         , DAYS_WED                  = V_ROW.DAYS_WED
                         , DAYS_THU                  = V_ROW.DAYS_THU
                         , DAYS_FRI                  = V_ROW.DAYS_FRI
                         , DAYS_SAT                  = V_ROW.DAYS_SAT
                         , DAYS_SUN                  = V_ROW.DAYS_SUN
                         , D_COUNTRY                 = V_ROW.D_COUNTRY
                         , D_PORT_CODE               = V_ROW.D_PORT_CODE
                         , D_PORT_NAME               = V_ROW.D_PORT_NAME
                         , A_COUNTRY                 = V_ROW.A_COUNTRY
                         , A_PORT_CODE               = V_ROW.A_PORT_CODE
                         , A_PORT_NAME               = V_ROW.A_PORT_NAME
                         , SHIPPING_COMPANY          = V_ROW.SHIPPING_COMPANY
                         , TO_COUNTRY                = UPPER(V_ROW.TO_COUNTRY)
                         , TO_CITY                   = UPPER(V_ROW.TO_CITY)
                         /* , to_city_name              = @v_to_city_name */
                         , SHIP_DOC_PREPARATION_DATE = V_ROW.SHIP_DOC_PREPARATION_DATE
                         , LT_DEPARTURE_INLAND       = N_LT_DEP
                         , LT_WAIT_SHIPPING          = N_LT_WAIT
                         , LT_VOYAGE                 = N_LT_VOYAGE
                         , LT_LAY_OFF_CLEARANCE      = N_LT_LAYOFF
                         , LT_ARRIVAL_INLAND         = N_LT_ARR
                         , VALID_YN                  = NVL(V_ROW.VALID_YN, '-')
                         , LAST_UPDATED_BY           = P_USER_ID
                         , LAST_UPDATE_DATE          = SYSDATE
                         , LT_TYPE                   = V_ROW.LT_TYPE
                         , ATTRIBUTE1                = V_ROW.ONE_SEGMENT_COST
                         , ATTRIBUTE2                = V_ROW.TWO_SEGMENT_COST
                         , ATTRIBUTE3                = V_ROW.THREE_SEGMENT_COST
                     WHERE ROUTE_ID = N_ROUTE_ID;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'I' THEN

                    N_ROUTE_ID     := SEQ1_SCP_MST_DISTRIBUTION_ROUTE.NEXTVAL;
                    V_ROW.ROUTE_ID := TO_CHAR(N_ROUTE_ID);

                    INSERT
                      INTO SCP_MST_DISTRIBUTION_ROUTE
                         ( ROUTE_ID
                         , FROM_COUNTRY
                         , FROM_CITY
                         /* ,FROM_CITY_NAME */
                         , TRANSPORT_MODE
                         , PRIORITY
                         , DAYS_MON
                         , DAYS_TUE
                         , DAYS_WED
                         , DAYS_THU
                         , DAYS_FRI
                         , DAYS_SAT
                         , DAYS_SUN
                         , D_COUNTRY
                         , D_PORT_CODE
                         , D_PORT_NAME
                         , A_COUNTRY
                         , A_PORT_CODE
                         , A_PORT_NAME
                         , SHIPPING_COMPANY
                         , TO_COUNTRY
                         , TO_CITY
                         /* ,TO_CITY_NAME */
                         , SHIP_DOC_PREPARATION_DATE
                         , LT_DEPARTURE_INLAND
                         , LT_WAIT_SHIPPING
                         , LT_VOYAGE
                         , LT_LAY_OFF_CLEARANCE
                         , LT_ARRIVAL_INLAND
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , LT_TYPE
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         )
                    VALUES
                         ( N_ROUTE_ID
                         , UPPER(V_ROW.FROM_COUNTRY)
                         , UPPER(V_ROW.FROM_CITY)
                         , V_ROW.TRANSPORT_MODE
                         , N_PRIORITY
                         , V_ROW.DAYS_MON
                         , V_ROW.DAYS_TUE
                         , V_ROW.DAYS_WED
                         , V_ROW.DAYS_THU
                         , V_ROW.DAYS_FRI
                         , V_ROW.DAYS_SAT
                         , V_ROW.DAYS_SUN
                         , V_ROW.D_COUNTRY
                         , V_ROW.D_PORT_CODE
                         , V_ROW.D_PORT_NAME
                         , V_ROW.A_COUNTRY
                         , V_ROW.A_PORT_CODE
                         , V_ROW.A_PORT_NAME
                         , V_ROW.SHIPPING_COMPANY
                         , UPPER(V_ROW.TO_COUNTRY)
                         , UPPER(V_ROW.TO_CITY)
                         , V_ROW.SHIP_DOC_PREPARATION_DATE
                         , N_LT_DEP
                         , N_LT_WAIT
                         , N_LT_VOYAGE
                         , N_LT_LAYOFF
                         , N_LT_ARR
                         , NVL(V_ROW.VALID_YN, '-')
                         , P_USER_ID
                         , SYSDATE
                         , P_USER_ID
                         , SYSDATE
                         , V_ROW.LT_TYPE
                         , V_ROW.ONE_SEGMENT_COST
                         , V_ROW.TWO_SEGMENT_COST
                         , V_ROW.THREE_SEGMENT_COST
                         );

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    N_ROUTE_ID := F_TO_INT(V_ROW.ROUTE_ID, 'Y');

                    DELETE
                      FROM SCP_MST_DISTRIBUTION_ROUTE
                     WHERE ROUTE_ID = N_ROUTE_ID;

                END IF;

            END LOOP;


            /* 중복체크 */
            FOR I IN 1 .. V_MAX_LOOP_CNT LOOP

                P_READ(I);

                /* PRIORITY 중복체크 */
                N_PRIORITY := F_TO_INT(V_ROW.PRIORITY);

                SELECT COUNT(*)
                  INTO V_DATA_DUP_CNT
                  FROM SCP_MST_DISTRIBUTION_ROUTE
                 WHERE FROM_COUNTRY = UPPER(V_ROW.FROM_COUNTRY)
                   AND FROM_CITY    = UPPER(V_ROW.FROM_CITY)
                   AND PRIORITY     = N_PRIORITY
                   AND TO_COUNTRY   = UPPER(V_ROW.TO_COUNTRY)
                   AND TO_CITY      = UPPER(V_ROW.TO_CITY);

                IF V_DATA_DUP_CNT > 1 THEN
                    V_ERR_CODE    := '99020';
                    V_ERR_MESSAGE := 'DUP PRIORITY.';
                    RAISE E_DUP;
                END IF;

                /* 데이타 중복체크 (AS-IS 대소문자 무시 · 빈 문자끼리 같음) */
                SELECT COUNT(*)
                  INTO V_DATA_DUP_CNT
                  FROM SCP_MST_DISTRIBUTION_ROUTE
                 WHERE FROM_COUNTRY                          = UPPER(V_ROW.FROM_COUNTRY)
                   AND FROM_CITY                             = UPPER(V_ROW.FROM_CITY)
                   AND NVL(UPPER(TRANSPORT_MODE), C_BLANK)   = NVL(UPPER(V_ROW.TRANSPORT_MODE), C_BLANK)
                   AND NVL(UPPER(D_COUNTRY), C_BLANK)        = NVL(UPPER(V_ROW.D_COUNTRY), C_BLANK)
                   AND NVL(UPPER(D_PORT_CODE), C_BLANK)      = NVL(UPPER(V_ROW.D_PORT_CODE), C_BLANK)
                   AND NVL(UPPER(D_PORT_NAME), C_BLANK)      = NVL(UPPER(V_ROW.D_PORT_NAME), C_BLANK)
                   AND NVL(UPPER(A_COUNTRY), C_BLANK)        = NVL(UPPER(V_ROW.A_COUNTRY), C_BLANK)
                   AND NVL(UPPER(A_PORT_CODE), C_BLANK)      = NVL(UPPER(V_ROW.A_PORT_CODE), C_BLANK)
                   AND NVL(UPPER(A_PORT_NAME), C_BLANK)      = NVL(UPPER(V_ROW.A_PORT_NAME), C_BLANK)
                   AND NVL(UPPER(SHIPPING_COMPANY), C_BLANK) = NVL(UPPER(V_ROW.SHIPPING_COMPANY), C_BLANK)
                   AND TO_COUNTRY                            = UPPER(V_ROW.TO_COUNTRY)
                   AND TO_CITY                               = UPPER(V_ROW.TO_CITY)
                   AND NVL(UPPER(LT_TYPE), C_BLANK)          = NVL(UPPER(V_ROW.LT_TYPE), C_BLANK);

                IF V_DATA_DUP_CNT > 1 THEN
                    V_ERR_CODE    := '99010';
                    V_ERR_MESSAGE := 'DUP DATA.';
                    RAISE E_DUP;
                END IF;

            END LOOP;

        END IF;

        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RESULT_CURSOR FOR
        SELECT '0'             AS CODE
             , 'SUCCESS'       AS MSG
             , V_MST_LOOP_CNT  AS EVENT
             , 'S'             AS RESULT_CODE
             , V_MST_LOOP_CNT  AS RESULT_CNT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            IF V_ERR_CODE IS NULL THEN
                V_ERR_CODE    := TO_CHAR(SQLCODE);
                V_ERR_MESSAGE := SQLERRM;
            END IF;
            V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

            ROLLBACK TO SP_SCP0005_SAVE;                 /* 입력 데이타 롤백 처리 */
            P_LOG_ERROR(V_PROGRAM_NAME, '[' || V_ERR_CODE || '] ' || V_ERR_MESSAGE, V_ERR_CODE, V_BACKTRACE);

            /* error코드, errror 메시지, 에러 데이터 반환 */
            OPEN O_RESULT_CURSOR FOR
            SELECT '-1'                                   AS CODE
                 , '[' || V_ERR_CODE || '] ' || V_ERR_MESSAGE AS MSG
                 , 0                                      AS EVENT
                 , 'F'                                    AS RESULT_CODE
                 , CAST(NULL AS NUMBER)                   AS RESULT_CNT
                 , V_ERR_CODE                             AS ERR_CODE
                 , V_ERR_MESSAGE                          AS ERR_MESSAGE
                 , V_ROW.ROUTE_ID                         AS ROUTE_ID
                 , V_ROW.FROM_COUNTRY                     AS FROM_COUNTRY
                 , V_ROW.FROM_CITY                        AS FROM_CITY
                 , V_ROW.FROM_CITY_NAME                   AS FROM_CITY_NAME
                 , V_ROW.TRANSPORT_MODE                   AS TRANSPORT_MODE
                 , V_ROW.D_COUNTRY                        AS D_COUNTRY
                 , V_ROW.D_PORT_CODE                      AS D_PORT_CODE
                 , V_ROW.D_PORT_NAME                      AS D_PORT_NAME
                 , V_ROW.A_COUNTRY                        AS A_COUNTRY
                 , V_ROW.A_PORT_CODE                      AS A_PORT_CODE
                 , V_ROW.A_PORT_NAME                      AS A_PORT_NAME
                 , V_ROW.SHIPPING_COMPANY                 AS SHIPPING_COMPANY
                 , V_ROW.TO_COUNTRY                       AS TO_COUNTRY
                 , V_ROW.TO_CITY                          AS TO_CITY
                 , V_ROW.TO_CITY_NAME                     AS TO_CITY_NAME
                 , V_ROW.LT_TYPE                          AS LT_TYPE
                 , V_ROW.ONE_SEGMENT_COST                 AS "OneSegmentCost"
                 , V_ROW.TWO_SEGMENT_COST                 AS "TwoSegmentCost"
                 , V_ROW.THREE_SEGMENT_COST               AS "ThreeSegmentCost"
              FROM DUAL;
    END P_SCP0005_SAVE_ROUTE;


    /*==================================================================================================
     * 내부 : 엑셀 한 행 반영 (AS-IS SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD 본문)
     * Program History
     *===========================================================================================================
     *   Date       In Charge		Description
     *===========================================================================================================
     * 2019.08.01	AYJ				[CSR ID:4030199] SSP Distribution route엑셀 업로드를 통한 신규등록/수정기능 구현
     * 2026.09.17   AJS             Oracle 전환 — 공통 업로드 적재 행을 한 행씩 반영(업로드 결과 기록은 호출부)
     *
     * O_ROUTE_ID : 반영된 Route Id(신규면 채번 값)
     *==================================================================================================*/
    PROCEDURE P_UPLOAD_ROW
    (
        P_ROW            IN  T_ROUTE_ROW,
        P_USER_ID        IN  VARCHAR2,
        P_WORKING_TIME   IN  DATE,
        O_ROUTE_ID       OUT VARCHAR2
    )
    IS
        V_ROW          T_ROUTE_ROW := P_ROW;
        V_CHK          PLS_INTEGER := 0;
        N_ROUTE_ID     NUMBER;
        N_PRIORITY     NUMBER;
        N_LT_DEP       NUMBER;
        N_LT_WAIT      NUMBER;
        N_LT_VOYAGE    NUMBER;
        N_LT_LAYOFF    NUMBER;
        N_LT_ARR       NUMBER;
        V_DATA_DUP_CNT PLS_INTEGER := 0;
    BEGIN
        /* AS-IS IF (@p_transport_mode = 'FERRY') / 'TRUCK' — 대소문자 무시 비교 */
        IF    UPPER(V_ROW.TRANSPORT_MODE) = 'FERRY' THEN V_ROW.TRANSPORT_MODE := 'FRY';
        ELSIF UPPER(V_ROW.TRANSPORT_MODE) = 'TRUCK' THEN V_ROW.TRANSPORT_MODE := 'TRK';
        END IF;

        /* 업로드 화면이 검증 통과 후 숫자 칸으로 바꿔 넘김 → 쉼표 제거 */
        V_ROW.PRIORITY                  := REPLACE(V_ROW.PRIORITY, ',', '');
        V_ROW.SHIP_DOC_PREPARATION_DATE := REPLACE(V_ROW.SHIP_DOC_PREPARATION_DATE, ',', '');
        V_ROW.LT_DEPARTURE_INLAND       := REPLACE(V_ROW.LT_DEPARTURE_INLAND, ',', '');
        V_ROW.LT_WAIT_SHIPPING          := REPLACE(V_ROW.LT_WAIT_SHIPPING, ',', '');
        V_ROW.LT_VOYAGE                 := REPLACE(V_ROW.LT_VOYAGE, ',', '');
        V_ROW.LT_LAY_OFF_CLEARANCE      := REPLACE(V_ROW.LT_LAY_OFF_CLEARANCE, ',', '');
        V_ROW.LT_ARRIVAL_INLAND         := REPLACE(V_ROW.LT_ARRIVAL_INLAND, ',', '');

        IF UPPER(V_ROW.DAYS_MON) = 'N' THEN V_ROW.DAYS_MON := NULL; END IF;
        IF UPPER(V_ROW.DAYS_TUE) = 'N' THEN V_ROW.DAYS_TUE := NULL; END IF;
        IF UPPER(V_ROW.DAYS_WED) = 'N' THEN V_ROW.DAYS_WED := NULL; END IF;
        IF UPPER(V_ROW.DAYS_THU) = 'N' THEN V_ROW.DAYS_THU := NULL; END IF;
        IF UPPER(V_ROW.DAYS_FRI) = 'N' THEN V_ROW.DAYS_FRI := NULL; END IF;
        IF UPPER(V_ROW.DAYS_SAT) = 'N' THEN V_ROW.DAYS_SAT := NULL; END IF;
        IF UPPER(V_ROW.DAYS_SUN) = 'N' THEN V_ROW.DAYS_SUN := NULL; END IF;

        /* from_city_name · v_to_city_name 은 이력 프로시저에서 쓰지 않는 값이라 조회 생략 */

        /* 이력저장 */
        P_ROUTE_HIST(V_ROW, P_USER_ID, P_WORKING_TIME);

        N_ROUTE_ID := F_TO_INT(P_ROW.ROUTE_ID, 'Y');
        N_PRIORITY  := F_TO_INT(V_ROW.PRIORITY);
        N_LT_DEP    := F_TO_INT(V_ROW.LT_DEPARTURE_INLAND);
        N_LT_WAIT   := F_TO_INT(V_ROW.LT_WAIT_SHIPPING);
        N_LT_VOYAGE := F_TO_INT(V_ROW.LT_VOYAGE);
        N_LT_LAYOFF := F_TO_INT(V_ROW.LT_LAY_OFF_CLEARANCE);
        N_LT_ARR    := F_TO_INT(V_ROW.LT_ARRIVAL_INLAND);

        SELECT COUNT(*)
          INTO V_CHK
          FROM SCP_MST_DISTRIBUTION_ROUTE
         WHERE ROUTE_ID = N_ROUTE_ID;

        IF V_CHK > 0 THEN

            UPDATE SCP_MST_DISTRIBUTION_ROUTE
               SET LT_TYPE                   = UPPER(V_ROW.LT_TYPE)
                 , FROM_COUNTRY              = UPPER(V_ROW.FROM_COUNTRY)
                 , FROM_CITY                 = UPPER(V_ROW.FROM_CITY)
                 , TRANSPORT_MODE            = UPPER(V_ROW.TRANSPORT_MODE)
                 , PRIORITY                  = N_PRIORITY
                 , DAYS_MON                  = UPPER(V_ROW.DAYS_MON)
                 , DAYS_TUE                  = UPPER(V_ROW.DAYS_TUE)
                 , DAYS_WED                  = UPPER(V_ROW.DAYS_WED)
                 , DAYS_THU                  = UPPER(V_ROW.DAYS_THU)
                 , DAYS_FRI                  = UPPER(V_ROW.DAYS_FRI)
                 , DAYS_SAT                  = UPPER(V_ROW.DAYS_SAT)
                 , DAYS_SUN                  = UPPER(V_ROW.DAYS_SUN)
                 , D_PORT_NAME               = V_ROW.D_PORT_NAME
                 , D_COUNTRY                 = V_ROW.D_COUNTRY
                 , D_PORT_CODE               = V_ROW.D_PORT_CODE
                 , A_PORT_NAME               = V_ROW.A_PORT_NAME
                 , A_COUNTRY                 = V_ROW.A_COUNTRY
                 , A_PORT_CODE               = V_ROW.A_PORT_CODE
                 , SHIPPING_COMPANY          = V_ROW.SHIPPING_COMPANY
                 , TO_COUNTRY                = UPPER(V_ROW.TO_COUNTRY)
                 , TO_CITY                   = UPPER(V_ROW.TO_CITY)
                 , SHIP_DOC_PREPARATION_DATE = V_ROW.SHIP_DOC_PREPARATION_DATE
                 , LT_DEPARTURE_INLAND       = N_LT_DEP
                 , LT_WAIT_SHIPPING          = N_LT_WAIT
                 , LT_VOYAGE                 = N_LT_VOYAGE
                 , LT_LAY_OFF_CLEARANCE      = N_LT_LAYOFF
                 , LT_ARRIVAL_INLAND         = N_LT_ARR
                 , VALID_YN                  = NVL(UPPER(V_ROW.VALID_YN), '-')
                 , LAST_UPDATED_BY           = P_USER_ID
                 , LAST_UPDATE_DATE          = P_WORKING_TIME
                 , ATTRIBUTE1                = V_ROW.ONE_SEGMENT_COST
                 , ATTRIBUTE2                = V_ROW.TWO_SEGMENT_COST
                 , ATTRIBUTE3                = V_ROW.THREE_SEGMENT_COST
             WHERE ROUTE_ID = N_ROUTE_ID;

            O_ROUTE_ID := P_ROW.ROUTE_ID;

        ELSE

            N_ROUTE_ID := SEQ1_SCP_MST_DISTRIBUTION_ROUTE.NEXTVAL;

            INSERT
              INTO SCP_MST_DISTRIBUTION_ROUTE
                 ( ROUTE_ID
                 , LT_TYPE
                 , FROM_COUNTRY
                 , FROM_CITY
                 , TRANSPORT_MODE
                 , PRIORITY
                 , DAYS_MON
                 , DAYS_TUE
                 , DAYS_WED
                 , DAYS_THU
                 , DAYS_FRI
                 , DAYS_SAT
                 , DAYS_SUN
                 , D_PORT_NAME
                 , D_COUNTRY
                 , D_PORT_CODE
                 , A_PORT_NAME
                 , A_COUNTRY
                 , A_PORT_CODE
                 , SHIPPING_COMPANY
                 , TO_COUNTRY
                 , TO_CITY
                 , SHIP_DOC_PREPARATION_DATE
                 , LT_DEPARTURE_INLAND
                 , LT_WAIT_SHIPPING
                 , LT_VOYAGE
                 , LT_LAY_OFF_CLEARANCE
                 , LT_ARRIVAL_INLAND
                 , VALID_YN
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 )
            VALUES
                 ( N_ROUTE_ID
                 , UPPER(V_ROW.LT_TYPE)
                 , UPPER(V_ROW.FROM_COUNTRY)
                 , UPPER(V_ROW.FROM_CITY)
                 , UPPER(V_ROW.TRANSPORT_MODE)
                 , N_PRIORITY
                 , UPPER(V_ROW.DAYS_MON)
                 , UPPER(V_ROW.DAYS_TUE)
                 , UPPER(V_ROW.DAYS_WED)
                 , UPPER(V_ROW.DAYS_THU)
                 , UPPER(V_ROW.DAYS_FRI)
                 , UPPER(V_ROW.DAYS_SAT)
                 , UPPER(V_ROW.DAYS_SUN)
                 , V_ROW.D_PORT_NAME
                 , V_ROW.D_COUNTRY
                 , V_ROW.D_PORT_CODE
                 , V_ROW.A_PORT_NAME
                 , V_ROW.A_COUNTRY
                 , V_ROW.A_PORT_CODE
                 , V_ROW.SHIPPING_COMPANY
                 , UPPER(V_ROW.TO_COUNTRY)
                 , UPPER(V_ROW.TO_CITY)
                 , V_ROW.SHIP_DOC_PREPARATION_DATE
                 , N_LT_DEP
                 , N_LT_WAIT
                 , N_LT_VOYAGE
                 , N_LT_LAYOFF
                 , N_LT_ARR
                 , NVL(UPPER(V_ROW.VALID_YN), '-')
                 , P_USER_ID
                 , P_WORKING_TIME
                 , P_USER_ID
                 , P_WORKING_TIME
                 , V_ROW.ONE_SEGMENT_COST
                 , V_ROW.TWO_SEGMENT_COST
                 , V_ROW.THREE_SEGMENT_COST
                 );

            O_ROUTE_ID := TO_CHAR(N_ROUTE_ID);

        END IF;

        /* PRIORITY 중복체크 */
        SELECT COUNT(*)
          INTO V_DATA_DUP_CNT
          FROM SCP_MST_DISTRIBUTION_ROUTE
         WHERE FROM_COUNTRY = UPPER(V_ROW.FROM_COUNTRY)
           AND FROM_CITY    = UPPER(V_ROW.FROM_CITY)
           AND PRIORITY     = N_PRIORITY
           AND TO_COUNTRY   = UPPER(V_ROW.TO_COUNTRY)
           AND TO_CITY      = UPPER(V_ROW.TO_CITY);

        IF V_DATA_DUP_CNT > 1 THEN
            RAISE_APPLICATION_ERROR(-20010, 'Priority Duplicate');
        END IF;
    END P_UPLOAD_ROW;


    /*==================================================================================================
     * Program ID   : SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD (+ 업로드 화면 Validation_Check_SCP0005)
     * Description  : SCP0005_DISTRIBUTION_ROUTE_EXCEL_UPLOAD
     * Program History
     *===========================================================================================================
     *   Date       In Charge		Description
     *===========================================================================================================
     * 2019.08.01	AYJ				[CSR ID:4030199] SSP Distribution route엑셀 업로드를 통한 신규등록/수정기능 구현
     * 2026.09.17   AJS             Oracle 전환 (PKG_SCP0005.P_SCP0005_EXCEL_UPLOAD) — 공통 업로드 규약(모드 · 작성자 · 프로그램 · 시트)
     *
     * 엑셀 컬럼(HEADER_CONTENT 순서 = ATTRIBUTE 번호)
     *   1 L/T Type* · 2 Route Id · 3 From City Name · 4 From Country* · 5 From City* · 6 Trans Mode* · 7 Priority* ·
     *   8~14 Mon~Sun · 15 Departure Port* · 16 Departure Country* · 17 Departure Port Code* · 18 Arrival Port* ·
     *   19 Arrival Country* · 20 Arrival Port Code* · 21 Forwarder* · 22 To City Name · 23 To Country* · 24 To City* ·
     *   25 Shipping Document Preparation Date · 26 Departure Inland · 27 Waiting For Shipping · 28 Voyage ·
     *   29 Lay Off/Customs Clearance · 30 Arrival Inland · 31 Total L/T · 32 Pick Up Cost · 33 Freight Cost ·
     *   34 Delivery Cost · 35 Valid*
     *
     * 모드 0 : 행마다 AS-IS 업로드 화면 검증 순서대로 판정 → UPLOAD_STATUS_CODE SUCCESS / ERROR, MESSAGE_TEXT = AS-IS 표시 문구
     *          (값이 하나도 없는 행은 SKIP)
     * 모드 1 : 같은 검증을 다시 수행해 오류 행이 있으면 전체 미반영(AS-IS 와 같음),
     *          없으면 행마다 반영 — 행 오류는 그 행만 되돌리고 ERROR 표시 후 다음 행 계속, 반영 행은 SAVED
     * 결과 커서 : CODE(0 / -1) · MSG · EVENT(모드 0 = 오류 행 수, 모드 1 = 반영 행 수)
     *==================================================================================================*/
    PROCEDURE P_SCP0005_EXCEL_UPLOAD
    (
        P_MODE            IN  NUMBER,
        P_CREATED_BY      IN  VARCHAR2,
        P_PROGRAM_ID      IN  VARCHAR2 DEFAULT 'SCP0005',
        P_SHEET_NAME      IN  VARCHAR2 DEFAULT 'Distribution Route',
        O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME    VARCHAR2(150 CHAR) := C_PKG_NAME || '.P_SCP0005_EXCEL_UPLOAD';
        V_PROGRAM_ID      VARCHAR2(40 CHAR)  := NVL(P_PROGRAM_ID, 'SCP0005');
        V_SHEET_NAME      VARCHAR2(40 CHAR)  := NVL(P_SHEET_NAME, 'Distribution Route');
        V_MODE            NUMBER             := NVL(P_MODE, 0);
        V_CREATION_DATE   TIMESTAMP;
        V_WORKING_TIME    DATE               := SYSDATE;
        T_UP              T_UPLOAD_TAB;
        T_ROW             T_ROUTE_TAB;
        T_STAT            T_TOKEN_TAB;
        T_KEYS            T_KEY_MAP;
        V_KEY             VARCHAR2(32767);
        V_CNT             PLS_INTEGER        := 0;
        V_ERR_CNT         PLS_INTEGER        := 0;
        V_SAVE_CNT        PLS_INTEGER        := 0;
        V_FAIL_CNT        PLS_INTEGER        := 0;
        V_LAST_ERR        VARCHAR2(4000 CHAR);
        V_ROUTE_ID        VARCHAR2(4000 CHAR);
        V_MSG             VARCHAR2(4000 CHAR);
        V_BACKTRACE       VARCHAR2(4000 CHAR);
        V_STEP            VARCHAR2(10 CHAR);

        /* 적재 행 → 이름 있는 행 */
        FUNCTION F_ROW
        (
            P_UP  IN  C_UPLOAD%ROWTYPE
        )
        RETURN T_ROUTE_ROW
        IS
            R  T_ROUTE_ROW;
        BEGIN
            R.LT_TYPE                   := P_UP.ATTRIBUTE1;
            R.ROUTE_ID                  := P_UP.ATTRIBUTE2;
            R.FROM_CITY_NAME            := P_UP.ATTRIBUTE3;
            R.FROM_COUNTRY              := P_UP.ATTRIBUTE4;
            R.FROM_CITY                 := P_UP.ATTRIBUTE5;
            R.TRANSPORT_MODE            := P_UP.ATTRIBUTE6;
            R.PRIORITY                  := P_UP.ATTRIBUTE7;
            R.DAYS_MON                  := P_UP.ATTRIBUTE8;
            R.DAYS_TUE                  := P_UP.ATTRIBUTE9;
            R.DAYS_WED                  := P_UP.ATTRIBUTE10;
            R.DAYS_THU                  := P_UP.ATTRIBUTE11;
            R.DAYS_FRI                  := P_UP.ATTRIBUTE12;
            R.DAYS_SAT                  := P_UP.ATTRIBUTE13;
            R.DAYS_SUN                  := P_UP.ATTRIBUTE14;
            R.D_PORT_NAME               := P_UP.ATTRIBUTE15;
            R.D_COUNTRY                 := P_UP.ATTRIBUTE16;
            R.D_PORT_CODE               := P_UP.ATTRIBUTE17;
            R.A_PORT_NAME               := P_UP.ATTRIBUTE18;
            R.A_COUNTRY                 := P_UP.ATTRIBUTE19;
            R.A_PORT_CODE               := P_UP.ATTRIBUTE20;
            R.SHIPPING_COMPANY          := P_UP.ATTRIBUTE21;
            R.TO_CITY_NAME              := P_UP.ATTRIBUTE22;
            R.TO_COUNTRY                := P_UP.ATTRIBUTE23;
            R.TO_CITY                   := P_UP.ATTRIBUTE24;
            R.SHIP_DOC_PREPARATION_DATE := P_UP.ATTRIBUTE25;
            R.LT_DEPARTURE_INLAND       := P_UP.ATTRIBUTE26;
            R.LT_WAIT_SHIPPING          := P_UP.ATTRIBUTE27;
            R.LT_VOYAGE                 := P_UP.ATTRIBUTE28;
            R.LT_LAY_OFF_CLEARANCE      := P_UP.ATTRIBUTE29;
            R.LT_ARRIVAL_INLAND         := P_UP.ATTRIBUTE30;
            R.ONE_SEGMENT_COST          := P_UP.ATTRIBUTE32;
            R.TWO_SEGMENT_COST          := P_UP.ATTRIBUTE33;
            R.THREE_SEGMENT_COST        := P_UP.ATTRIBUTE34;
            R.VALID_YN                  := P_UP.ATTRIBUTE35;
            RETURN R;
        END F_ROW;

        /* 값이 하나도 없는 행 */
        FUNCTION F_EMPTY
        (
            P_UP  IN  C_UPLOAD%ROWTYPE
        )
        RETURN BOOLEAN
        IS
        BEGIN
            RETURN TRIM(P_UP.ATTRIBUTE1  || P_UP.ATTRIBUTE2  || P_UP.ATTRIBUTE3  || P_UP.ATTRIBUTE4  || P_UP.ATTRIBUTE5
                     || P_UP.ATTRIBUTE6  || P_UP.ATTRIBUTE7  || P_UP.ATTRIBUTE8  || P_UP.ATTRIBUTE9  || P_UP.ATTRIBUTE10
                     || P_UP.ATTRIBUTE11 || P_UP.ATTRIBUTE12 || P_UP.ATTRIBUTE13 || P_UP.ATTRIBUTE14 || P_UP.ATTRIBUTE15
                     || P_UP.ATTRIBUTE16 || P_UP.ATTRIBUTE17 || P_UP.ATTRIBUTE18 || P_UP.ATTRIBUTE19 || P_UP.ATTRIBUTE20
                     || P_UP.ATTRIBUTE21 || P_UP.ATTRIBUTE22 || P_UP.ATTRIBUTE23 || P_UP.ATTRIBUTE24 || P_UP.ATTRIBUTE25
                     || P_UP.ATTRIBUTE26 || P_UP.ATTRIBUTE27 || P_UP.ATTRIBUTE28 || P_UP.ATTRIBUTE29 || P_UP.ATTRIBUTE30
                     || P_UP.ATTRIBUTE31 || P_UP.ATTRIBUTE32 || P_UP.ATTRIBUTE33 || P_UP.ATTRIBUTE34 || P_UP.ATTRIBUTE35) IS NULL;
        END F_EMPTY;

        /* 업로드 화면 숫자 검사 : 쉼표 제거 후 long 정수 (빈 값은 0 으로 통과) */
        FUNCTION F_IS_LONG
        (
            P_VALUE  IN  VARCHAR2
        )
        RETURN BOOLEAN
        IS
            V_TXT  VARCHAR2(4000 CHAR) := TRIM(REPLACE(P_VALUE, ',', ''));
        BEGIN
            IF V_TXT IS NULL THEN
                RETURN TRUE;
            END IF;
            IF NOT REGEXP_LIKE(V_TXT, '^[+-]?[0-9]+$') THEN
                RETURN FALSE;
            END IF;
            RETURN TO_NUMBER(V_TXT) BETWEEN -9223372036854775808 AND 9223372036854775807;
        END F_IS_LONG;

        /* 파일 안 중복 비교 키 (대소문자 구분 · 빈 값끼리 같음) */
        FUNCTION F_FILE_KEY
        (
            P_ROUTE  IN  VARCHAR2,
            P_R      IN  T_ROUTE_ROW
        )
        RETURN VARCHAR2
        IS
        BEGIN
            RETURN P_ROUTE
                || C_KEY_DELIM || P_R.LT_TYPE        || C_KEY_DELIM || P_R.FROM_COUNTRY   || C_KEY_DELIM || P_R.FROM_CITY
                || C_KEY_DELIM || P_R.TRANSPORT_MODE || C_KEY_DELIM || P_R.D_PORT_NAME    || C_KEY_DELIM || P_R.D_COUNTRY
                || C_KEY_DELIM || P_R.D_PORT_CODE    || C_KEY_DELIM || P_R.A_PORT_NAME    || C_KEY_DELIM || P_R.A_COUNTRY
                || C_KEY_DELIM || P_R.A_PORT_CODE    || C_KEY_DELIM || P_R.SHIPPING_COMPANY
                || C_KEY_DELIM || P_R.TO_COUNTRY     || C_KEY_DELIM || P_R.TO_CITY;
        END F_FILE_KEY;

        /* AS-IS Validation_Check_SCP0005 — 행 순서대로 상태 판정, 오류 행 수 반환 */
        FUNCTION F_VALIDATE
        RETURN PLS_INTEGER
        IS
            R            T_ROUTE_ROW;
            V_ROUTE0     VARCHAR2(4000 CHAR);
            V_TMC        VARCHAR2(4000 CHAR);
            N_ROUTE0     NUMBER;
            V_ROUTE_OK   BOOLEAN;
            V_EXISTS     PLS_INTEGER;
            V_UNIQ       PLS_INTEGER;
            V_DUPID      PLS_INTEGER;
            V_ROUTE_EX   PLS_INTEGER;
            V_ERRS       PLS_INTEGER := 0;
            J            PLS_INTEGER;
            L_IDX        T_IDX_TAB;
        BEGIN
            T_STAT.DELETE;
            T_KEYS.DELETE;

            /* 파일 안 중복 비교용 : 각 행의 원래 값 키 → 행 번호 목록 */
            FOR I IN 1 .. T_ROW.COUNT LOOP
                IF T_UP(I).UPLOAD_STATUS_CODE <> 'SKIP' THEN
                    V_KEY := F_FILE_KEY(NVL(T_ROW(I).ROUTE_ID, C_BLANK), T_ROW(I));
                    L_IDX.DELETE;
                    IF T_KEYS.EXISTS(V_KEY) THEN
                        L_IDX := T_KEYS(V_KEY);
                    END IF;
                    L_IDX(L_IDX.COUNT + 1) := I;
                    T_KEYS(V_KEY) := L_IDX;
                END IF;
            END LOOP;

            FOR I IN 1 .. T_ROW.COUNT LOOP

                IF T_UP(I).UPLOAD_STATUS_CODE = 'SKIP' THEN
                    CONTINUE;
                END IF;

                R := T_ROW(I);

                IF NOT T_STAT.EXISTS(I) THEN
                    T_STAT(I) := 'Success';
                END IF;

                V_ROUTE0 := NVL(R.ROUTE_ID, '0');

                /* 1. excel의 TransMode Name -> code값으로 변경 */
                V_TMC := CASE R.TRANSPORT_MODE WHEN 'TRUCK' THEN 'TRK' WHEN 'FERRY' THEN 'FRY' ELSE R.TRANSPORT_MODE END;

                V_ROUTE_OK := REGEXP_LIKE(TRIM(V_ROUTE0), '^[+-]?[0-9]+$');
                IF V_ROUTE_OK THEN
                    N_ROUTE0 := TO_NUMBER(TRIM(V_ROUTE0));
                END IF;

                /* 필수값 검사 */
                IF    R.LT_TYPE IS NULL OR R.FROM_COUNTRY IS NULL OR R.FROM_CITY IS NULL OR R.TRANSPORT_MODE IS NULL
                   OR R.PRIORITY IS NULL OR R.D_PORT_NAME IS NULL OR R.D_COUNTRY IS NULL OR R.D_PORT_CODE IS NULL
                   OR R.A_PORT_NAME IS NULL OR R.A_COUNTRY IS NULL OR R.A_PORT_CODE IS NULL OR R.SHIPPING_COMPANY IS NULL
                   OR R.TO_COUNTRY IS NULL OR R.TO_CITY IS NULL OR R.VALID_YN IS NULL THEN
                    T_STAT(I) := 'Error-Required';
                END IF;

                IF     R.DAYS_MON IS NULL AND R.DAYS_TUE IS NULL AND R.DAYS_WED IS NULL AND R.DAYS_THU IS NULL
                   AND R.DAYS_FRI IS NULL AND R.DAYS_SAT IS NULL AND R.DAYS_SUN IS NULL THEN
                    T_STAT(I) := 'Error-Departure days';
                END IF;

                /* 유효성 검사 */
                IF T_STAT(I) = 'Success' THEN
                    SELECT COUNT(*)
                      INTO V_EXISTS
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE     = 'LT_TYPE'
                       AND VALID_YN        = 'Y'
                       AND UPPER(SEGMENT1) = UPPER(R.LT_TYPE)
                       AND ROWNUM          = 1;
                    IF V_EXISTS = 0 THEN
                        T_STAT(I) := 'Error-L/T Type';
                    END IF;
                END IF;

                IF T_STAT(I) = 'Success' THEN
                    SELECT COUNT(*)
                      INTO V_EXISTS
                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                     WHERE LOOKUP_TYPE     = 'TRANSPORT_MODE_CODE'
                       AND VALID_YN        = 'Y'
                       AND UPPER(SEGMENT1) = UPPER(V_TMC)
                       AND ROWNUM          = 1;
                    IF V_EXISTS = 0 THEN
                        T_STAT(I) := 'Error-TransMode';
                    END IF;
                END IF;

                IF T_STAT(I) = 'Success' THEN
                    SELECT COUNT(*)
                      INTO V_EXISTS
                      FROM SCM_MST_CITY
                     WHERE COUNTRY  = UPPER(R.FROM_COUNTRY)
                       AND CITY     = UPPER(R.FROM_CITY)
                       AND VALID_YN = 'Y'
                       AND ROWNUM   = 1;
                    IF V_EXISTS = 0 THEN
                        T_STAT(I) := 'Error-From Site';
                    END IF;
                END IF;

                IF T_STAT(I) = 'Success' THEN
                    SELECT COUNT(*)
                      INTO V_EXISTS
                      FROM SCM_MST_CITY
                     WHERE COUNTRY  = UPPER(R.TO_COUNTRY)
                       AND CITY     = UPPER(R.TO_CITY)
                       AND VALID_YN = 'Y'
                       AND ROWNUM   = 1;
                    IF V_EXISTS = 0 THEN
                        T_STAT(I) := 'Error-To Site';
                    END IF;
                END IF;

                /* Route Id 가 숫자가 아니면 AS-IS 는 검증 자체가 중단됨 → 해당 행 오류로 표시 */
                IF T_STAT(I) = 'Success' AND NOT V_ROUTE_OK THEN
                    T_STAT(I) := 'Error-Route Id';
                END IF;

                IF T_STAT(I) = 'Success' THEN
                    /* 데이터 중복체크 (Port 이름은 공백 제거 값과 비교) */
                    SELECT COUNT(*)
                         , COUNT(CASE WHEN A.ROUTE_ID = N_ROUTE0 THEN 1 END)
                      INTO V_UNIQ
                         , V_DUPID
                      FROM SCP_MST_DISTRIBUTION_ROUTE A
                     WHERE UPPER(A.LT_TYPE)                      = UPPER(R.LT_TYPE)
                       AND UPPER(A.FROM_COUNTRY)                 = UPPER(R.FROM_COUNTRY)
                       AND UPPER(A.FROM_CITY)                    = UPPER(R.FROM_CITY)
                       AND UPPER(A.TRANSPORT_MODE)               = UPPER(V_TMC)
                       AND UPPER(REPLACE(A.D_PORT_NAME, ' ', '')) = UPPER(R.D_PORT_NAME)
                       AND UPPER(A.D_COUNTRY)                    = UPPER(R.D_COUNTRY)
                       AND UPPER(A.D_PORT_CODE)                  = UPPER(R.D_PORT_CODE)
                       AND UPPER(REPLACE(A.A_PORT_NAME, ' ', '')) = UPPER(R.A_PORT_NAME)
                       AND UPPER(A.A_COUNTRY)                    = UPPER(R.A_COUNTRY)
                       AND UPPER(A.A_PORT_CODE)                  = UPPER(R.A_PORT_CODE)
                       AND UPPER(A.SHIPPING_COMPANY)             = UPPER(R.SHIPPING_COMPANY)
                       AND UPPER(A.TO_COUNTRY)                   = UPPER(R.TO_COUNTRY)
                       AND UPPER(A.TO_CITY)                      = UPPER(R.TO_CITY);

                    SELECT COUNT(*)
                      INTO V_ROUTE_EX
                      FROM SCP_MST_DISTRIBUTION_ROUTE
                     WHERE ROUTE_ID = N_ROUTE0
                       AND ROWNUM   = 1;

                    /* Route_id 미존재 */
                    IF V_ROUTE_EX = 0 AND V_UNIQ <> 0 THEN
                        T_STAT(I) := 'Error-Unique Duplicate';
                    END IF;

                    /* Route_id 존재 */
                    IF T_STAT(I) = 'Success' AND V_ROUTE_EX <> 0 AND V_UNIQ <> 0 AND V_DUPID = 0 THEN
                        T_STAT(I) := 'Error-Unique Duplicate';
                    END IF;
                END IF;

                /* 중복 검사 (파일 안) — 비교 기준 Route Id 는 빈 값이면 '0' */
                IF T_STAT(I) NOT LIKE 'Error%' THEN
                    V_KEY := F_FILE_KEY(V_ROUTE0, R);
                    IF T_KEYS.EXISTS(V_KEY) THEN
                        FOR K IN 1 .. T_KEYS(V_KEY).COUNT LOOP
                            J := T_KEYS(V_KEY)(K);
                            IF J > I THEN
                                T_STAT(I) := 'Error-Duplicate';
                                T_STAT(J) := 'Error-Duplicate';
                            END IF;
                        END LOOP;
                    END IF;
                END IF;

                /* 출발 요일 값 : 빈 값 · Y · N 만 허용 (대소문자 구분) */
                IF    (R.DAYS_MON IS NOT NULL AND R.DAYS_MON NOT IN ('Y', 'N'))
                   OR (R.DAYS_TUE IS NOT NULL AND R.DAYS_TUE NOT IN ('Y', 'N'))
                   OR (R.DAYS_WED IS NOT NULL AND R.DAYS_WED NOT IN ('Y', 'N'))
                   OR (R.DAYS_THU IS NOT NULL AND R.DAYS_THU NOT IN ('Y', 'N'))
                   OR (R.DAYS_FRI IS NOT NULL AND R.DAYS_FRI NOT IN ('Y', 'N'))
                   OR (R.DAYS_SAT IS NOT NULL AND R.DAYS_SAT NOT IN ('Y', 'N'))
                   OR (R.DAYS_SUN IS NOT NULL AND R.DAYS_SUN NOT IN ('Y', 'N')) THEN
                    T_STAT(I) := 'Error-Departure days';
                END IF;

                /* 숫자 유효성 체크 (priority · 서류준비일 · L/T 5개) */
                IF    NOT F_IS_LONG(R.PRIORITY)
                   OR NOT F_IS_LONG(R.SHIP_DOC_PREPARATION_DATE)
                   OR NOT F_IS_LONG(R.LT_DEPARTURE_INLAND)
                   OR NOT F_IS_LONG(R.LT_WAIT_SHIPPING)
                   OR NOT F_IS_LONG(R.LT_VOYAGE)
                   OR NOT F_IS_LONG(R.LT_LAY_OFF_CLEARANCE)
                   OR NOT F_IS_LONG(R.LT_ARRIVAL_INLAND) THEN
                    T_STAT(I) := 'Error-Number';
                END IF;

            END LOOP;

            FOR I IN 1 .. T_ROW.COUNT LOOP
                IF T_STAT.EXISTS(I) AND T_STAT(I) LIKE 'Error%' THEN
                    V_ERRS     := V_ERRS + 1;
                    V_LAST_ERR := T_STAT(I);
                END IF;
            END LOOP;

            RETURN V_ERRS;
        END F_VALIDATE;

        /* 검증 결과를 적재 행에 기록 */
        PROCEDURE P_WRITE_STAT
        IS
        BEGIN
            FOR I IN 1 .. T_ROW.COUNT LOOP
                IF T_UP(I).UPLOAD_STATUS_CODE = 'SKIP' THEN
                    UPDATE SCM_ADM_EXCEL_UPLOAD
                       SET UPLOAD_STATUS_CODE = 'SKIP'
                         , MESSAGE_TEXT       = NULL
                         , LAST_UPDATED_BY    = P_CREATED_BY
                         , LAST_UPDATE_DATE   = SYSDATE
                     WHERE UPLOAD_ID = T_UP(I).UPLOAD_ID;
                ELSE
                    UPDATE SCM_ADM_EXCEL_UPLOAD
                       SET UPLOAD_STATUS_CODE = CASE WHEN T_STAT(I) LIKE 'Error%' THEN 'ERROR' ELSE 'SUCCESS' END
                         , MESSAGE_TEXT       = CASE WHEN T_STAT(I) LIKE 'Error%' THEN T_STAT(I) END
                         , LAST_UPDATED_BY    = P_CREATED_BY
                         , LAST_UPDATE_DATE   = SYSDATE
                     WHERE UPLOAD_ID = T_UP(I).UPLOAD_ID;
                END IF;
            END LOOP;
        END P_WRITE_STAT;

    BEGIN

        SAVEPOINT SP_SCP0005_UPLOAD;

        V_STEP := 'START';
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', TO_CHAR(V_MODE), SYSDATE);

        SELECT MAX(A.CREATION_DATE)
          INTO V_CREATION_DATE
          FROM SCM_ADM_EXCEL_UPLOAD A
         WHERE A.PROGRAM_ID = V_PROGRAM_ID
           AND A.SHEET_NAME = V_SHEET_NAME
           AND A.CREATED_BY = P_CREATED_BY;

        V_STEP := 'LOAD';
        OPEN C_UPLOAD(V_PROGRAM_ID, V_SHEET_NAME, P_CREATED_BY, V_CREATION_DATE);
        FETCH C_UPLOAD BULK COLLECT INTO T_UP;
        CLOSE C_UPLOAD;

        FOR I IN 1 .. T_UP.COUNT LOOP
            IF F_EMPTY(T_UP(I)) THEN
                T_UP(I).UPLOAD_STATUS_CODE := 'SKIP';
            END IF;
            T_ROW(I) := F_ROW(T_UP(I));
        END LOOP;

        V_STEP := 'VALID';
        V_ERR_CNT := F_VALIDATE;
        P_WRITE_STAT;
        COMMIT;

        IF V_MODE > 0 THEN

            IF V_ERR_CNT > 0 THEN
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', V_ERR_CNT, '########## Validation Error — nothing loaded ##########', V_LAST_ERR, SYSDATE);

                OPEN O_RESULT_CURSOR FOR
                SELECT '-1'                                                                        AS CODE
                     , 'Validation errors remain (' || V_ERR_CNT || ' rows) - nothing loaded : { '
                       || REPLACE(V_LAST_ERR, 'Error-', '') || ' }'                                AS MSG
                     , TO_CHAR(V_ERR_CNT)                                                          AS EVENT
                  FROM DUAL;
                RETURN;
            END IF;

            V_STEP := 'SAVE';
            FOR I IN 1 .. T_ROW.COUNT LOOP

                IF T_UP(I).UPLOAD_STATUS_CODE = 'SKIP' THEN
                    CONTINUE;
                END IF;

                SAVEPOINT SP_SCP0005_UPLOAD_ROW;

                BEGIN
                    P_UPLOAD_ROW(T_ROW(I), P_CREATED_BY, V_WORKING_TIME, V_ROUTE_ID);

                    UPDATE SCM_ADM_EXCEL_UPLOAD
                       SET UPLOAD_STATUS_CODE = 'SAVED'
                         , MESSAGE_TEXT       = NULL
                         , ATTRIBUTE2         = V_ROUTE_ID
                         , LAST_UPDATED_BY    = P_CREATED_BY
                         , LAST_UPDATE_DATE   = SYSDATE
                     WHERE UPLOAD_ID = T_UP(I).UPLOAD_ID;

                    V_SAVE_CNT := V_SAVE_CNT + 1;

                EXCEPTION
                    WHEN OTHERS THEN
                        V_MSG       := CASE WHEN SQLCODE = -20010 THEN '[99010] Priority Duplicate'
                                            ELSE '[' || TO_CHAR(SQLCODE) || '] ' || SQLERRM END;
                        V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;

                        ROLLBACK TO SP_SCP0005_UPLOAD_ROW;         /* 입력 데이타 롤백 처리 (해당 행만) */
                        P_LOG_ERROR(V_PROGRAM_NAME, V_MSG, TO_CHAR(SQLCODE), V_BACKTRACE);

                        UPDATE SCM_ADM_EXCEL_UPLOAD
                           SET UPLOAD_STATUS_CODE = 'ERROR'
                             , MESSAGE_TEXT       = SUBSTR(V_MSG, 1, 4000)
                             , LAST_UPDATED_BY    = P_CREATED_BY
                             , LAST_UPDATE_DATE   = SYSDATE
                         WHERE UPLOAD_ID = T_UP(I).UPLOAD_ID;

                        V_FAIL_CNT := V_FAIL_CNT + 1;
                        V_LAST_ERR := V_MSG;
                END;

                COMMIT;

            END LOOP;

            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', V_SAVE_CNT, '########## END of procedure ##########', 'FAIL=' || V_FAIL_CNT, SYSDATE);

            IF V_FAIL_CNT > 0 THEN
                OPEN O_RESULT_CURSOR FOR
                SELECT '-1'                                                              AS CODE
                     , 'Error! (' || V_FAIL_CNT || ' rows) Msg : ' || V_LAST_ERR          AS MSG
                     , TO_CHAR(V_SAVE_CNT)                                               AS EVENT
                  FROM DUAL;
            ELSE
                OPEN O_RESULT_CURSOR FOR
                SELECT '0'                   AS CODE
                     , 'SUCCESS'             AS MSG
                     , TO_CHAR(V_SAVE_CNT)   AS EVENT
                  FROM DUAL;
            END IF;
            RETURN;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', V_ERR_CNT, '########## END of procedure ##########', TO_CHAR(V_MODE), SYSDATE);

        OPEN O_RESULT_CURSOR FOR
        SELECT '0'                  AS CODE
             , 'SUCCESS'            AS MSG
             , TO_CHAR(V_ERR_CNT)   AS EVENT
          FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_MSG       := '[' || TO_CHAR(SQLCODE) || '] ' || SQLERRM || ' (STEP ' || V_STEP || ')';
            V_BACKTRACE := DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            BEGIN
                ROLLBACK TO SP_SCP0005_UPLOAD;       /* 커밋 이후 오류면 SAVEPOINT 가 없어 되돌릴 것 없음 */
            EXCEPTION
                WHEN OTHERS THEN
                    NULL;
            END;
            P_LOG_ERROR(V_PROGRAM_NAME, V_MSG, TO_CHAR(SQLCODE), V_BACKTRACE);
            RAISE;
    END P_SCP0005_EXCEL_UPLOAD;
    -- 2026.09.17 AJS 조회 3 · 저장 · 엑셀 업로드 추가 (END)


END PKG_SCP0005;