CREATE OR REPLACE PACKAGE BODY         PKG_SCP0006
IS

    /* 구분자 분리 결과 (AS-IS SCM_ARR_SPL_VAL 대응) */
    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;


    /* ------------------------------------------------------------
       오류 로그 (조회 프로시저 공통)
       ------------------------------------------------------------ */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_IN_PARA_DATA  IN  VARCHAR2,
        P_SQLCODE       IN  NUMBER,
        P_SQLERRM       IN  VARCHAR2,
        P_BACKTRACE     IN  VARCHAR2
    )
    IS
    BEGIN
        PR_SCM_SYS_LOG_BATCH(P_PROGRAM_NAME
                           , 'ERROR'
                           , NULL
                           , SUBSTR(P_SQLERRM, 1, 1000)
                           , NULL
                           , SYSDATE
                           , SUBSTR(P_IN_PARA_DATA, 1, 2000)
                           , TO_CHAR(P_SQLCODE)
                           , SUBSTR(P_SQLERRM, 1, 2000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;


    /* ------------------------------------------------------------
       쉼표 목록 분리 (AS-IS dbo.String_Split 대응)
       O_ALL = 'Y' : 목록이 비어 조건을 걸지 않음
                     (AS-IS (@p IS NULL OR @p = '') 갈래 - 공백만 있는 값도 MSSQL 은 빈 값으로 본다)
       ------------------------------------------------------------ */
    PROCEDURE P_SPLIT_LIST
    (
        P_STR       IN  VARCHAR2,
        O_TAB       OUT T_STR_TAB,
        O_ALL       OUT VARCHAR2
    )
    IS
    BEGIN
        IF RTRIM(P_STR) IS NULL THEN
            O_ALL := 'Y';
            O_TAB := T_STR_TAB();
        ELSE
            O_ALL := 'N';

            SELECT COLUMN_VALUE
              BULK COLLECT INTO O_TAB
              FROM TABLE(STRING_SPLIT(P_STR, ','));
        END IF;
    END P_SPLIT_LIST;


    /* ------------------------------------------------------------
       ^ 구분 CLOB 분리 (AS-IS SCM_ARR_SPL_VAL · SCM_ARR_SPL_CNT 대응)
       - 토큰 앞뒤 공백 제거, 순번 1 부터
       - O_CNT : AS-IS SCM_ARR_SPL_CNT (구분자 수 + 1, 입력이 NULL 이면 0)
       ------------------------------------------------------------ */
    PROCEDURE P_SPLIT_TOKEN
    (
        P_STR       IN  CLOB,
        P_DELIM     IN  VARCHAR2,
        O_TAB       OUT T_TOKEN_TAB,
        O_CNT       OUT PLS_INTEGER
    )
    IS
        V_POS       PLS_INTEGER;
        V_FROM      PLS_INTEGER := 1;
        V_NR        PLS_INTEGER := 0;
        V_LEN       PLS_INTEGER := NVL(DBMS_LOB.GETLENGTH(P_STR), 0);
    BEGIN

        IF V_LEN = 0 THEN
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

        IF V_FROM <= V_LEN THEN
            O_TAB(V_NR) := TRIM(DBMS_LOB.SUBSTR(P_STR, V_LEN - V_FROM + 1, V_FROM));
        END IF;

        O_CNT := V_NR;

    END P_SPLIT_TOKEN;


    /* 토큰 꺼내기 - 없는 순번이면 NULL (AS-IS SCM_ARR_SPL_VAL 과 같음) */
    FUNCTION F_TOKEN
    (
        P_TAB       IN  T_TOKEN_TAB,
        P_IDX       IN  PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX) THEN
            RETURN P_TAB(P_IDX);
        END IF;

        RETURN NULL;
    END F_TOKEN;


    /* ------------------------------------------------------------
       MSSQL 빈 문자 비교 대응
       AS-IS 날짜 변수는 '' 로 시작하고 '' 는 어떤 날짜 문자열보다 작다.
       Oracle 은 '' 가 NULL 이라 비교가 거짓이 되므로 CHR(1) 로 바꿔 비교한다.
       ------------------------------------------------------------ */
    FUNCTION F_CMP
    (
        P_STR       IN  VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        RETURN NVL(P_STR, CHR(1));
    END F_CMP;


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
        IF RTRIM(P_STR) IS NULL THEN
            RETURN DATE '1900-01-01';
        END IF;

        V_DATE := CAST(TO_TIMESTAMP(TRIM(P_STR) DEFAULT NULL ON CONVERSION ERROR, 'YYYY-MM-DD HH24:MI:SS.FF') AS DATE);

        IF V_DATE IS NULL THEN
            V_DATE := TO_DATE(TRIM(P_STR) DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDDHH24MISS');
        END IF;

        IF V_DATE IS NULL THEN
            RAISE_APPLICATION_ERROR(-20001, 'Conversion failed when converting date and/or time from character string. [' || P_STR || ']');
        END IF;

        RETURN V_DATE;
    END F_TO_DATETIME;


    /* ------------------------------------------------------------
       조회 기간 계산 (SITE · SITE_82 공통, AS-IS 앞부분 그대로)
       ------------------------------------------------------------ */
    PROCEDURE P_CALC_PERIOD
    (
        P_FROM_YYYYMM       IN  VARCHAR2,
        P_TO_YYYYMM         IN  VARCHAR2,
        O_P_FROM_YYYYMMDD   OUT VARCHAR2,
        O_P_TO_YYYYMMDD     OUT VARCHAR2,
        O_V_FROM_YYYYMMDD   OUT VARCHAR2,
        O_V_TO_YYYYMMDD     OUT VARCHAR2,
        O_V_FROM_RESULT     OUT VARCHAR2,
        O_V_TO_RESULT       OUT VARCHAR2
    )
    IS
        V_UNIT_DATE         VARCHAR2(8 CHAR);   /* 현재일 기준의 주(week)의 시작일자 */
    BEGIN

        O_V_FROM_YYYYMMDD := NULL;
        O_V_TO_YYYYMMDD   := NULL;
        O_V_FROM_RESULT   := NULL;
        O_V_TO_RESULT     := NULL;

        /* 월의 시작일자 설정 - AS-IS 도 바로 아래에서 현재일자의 월요일로 덮어쓴다 */
        IF RTRIM(P_FROM_YYYYMM) IS NULL THEN
            O_P_FROM_YYYYMMDD := NULL;
        ELSE
            O_P_FROM_YYYYMMDD := P_FROM_YYYYMM || '01';
        END IF;

        /* from_yyyymmdd는 현재일자의 월요일로 강제설정 */
        BEGIN
            SELECT TO_CHAR(TO_DATE(IA.BASIS_YYYYMMDD, 'YYYYMMDD') - (IA.DAYOFWEEK_NO - 1), 'YYYYMMDD') AS BASIS_START_DATE
              INTO O_P_FROM_YYYYMMDD
              FROM (SELECT CASE WHEN DAYOFWEEK_NO - 1 = 0 THEN 7
                                ELSE DAYOFWEEK_NO - 1
                           END AS DAYOFWEEK_NO
                         , BASIS_YYYYMMDD
                      FROM SCM_SYS_CALENDAR_M
                     WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD')
                   ) IA;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                O_P_FROM_YYYYMMDD := NULL;
        END;

        /* 월의 마지막일자 설정 */
        IF RTRIM(P_TO_YYYYMM) IS NULL THEN
            O_P_TO_YYYYMMDD := NULL;
        ELSE
            O_P_TO_YYYYMMDD := TO_CHAR(LAST_DAY(TO_DATE(P_TO_YYYYMM || '01', 'YYYYMMDD')), 'YYYYMMDD');
        END IF;

        BEGIN
            SELECT BASIS_START_DATE
              INTO V_UNIT_DATE
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD = TO_CHAR(SYSDATE, 'YYYYMMDD');
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_UNIT_DATE := NULL;
        END;

        IF F_CMP(V_UNIT_DATE) >= F_CMP(O_P_FROM_YYYYMMDD) AND F_CMP(V_UNIT_DATE) <= F_CMP(O_P_TO_YYYYMMDD) THEN
            O_V_FROM_RESULT   := O_P_FROM_YYYYMMDD;
            O_V_TO_RESULT     := V_UNIT_DATE;
            O_V_FROM_YYYYMMDD := V_UNIT_DATE;
            O_V_TO_YYYYMMDD   := O_P_TO_YYYYMMDD;

            IF F_CMP(O_P_FROM_YYYYMMDD) = F_CMP(V_UNIT_DATE) THEN
                O_V_FROM_RESULT := NULL;
                O_V_TO_RESULT   := NULL;
            END IF;
        ELSIF F_CMP(V_UNIT_DATE) < F_CMP(O_P_FROM_YYYYMMDD) AND F_CMP(V_UNIT_DATE) < F_CMP(O_P_TO_YYYYMMDD) THEN
            O_V_FROM_YYYYMMDD := O_P_FROM_YYYYMMDD;
            O_V_TO_YYYYMMDD   := O_P_TO_YYYYMMDD;
            O_V_FROM_RESULT   := NULL;
            O_V_TO_RESULT     := NULL;
        ELSIF F_CMP(V_UNIT_DATE) > F_CMP(O_P_FROM_YYYYMMDD) AND F_CMP(V_UNIT_DATE) > F_CMP(O_P_TO_YYYYMMDD) THEN
            O_V_FROM_YYYYMMDD := NULL;
            O_V_TO_YYYYMMDD   := NULL;
            O_V_FROM_RESULT   := O_P_FROM_YYYYMMDD;
            O_V_TO_RESULT     := O_P_TO_YYYYMMDD;
        END IF;

    END P_CALC_PERIOD;


    /* ------------------------------------------------------------
       월 칸 피벗 조회문 조립 (AS-IS 동적 PIVOT 대응)
       - 월 목록은 달력에서 만든다(사용자 입력이 아니다)
       - 칸 이름은 화면 계약에 맞춰 M_YYYYMM
       - 월 목록이 비면 AS-IS 는 LEFT(@mQuery, LEN(@mQuery) - 1) 에서 오류로 끝난다
       ------------------------------------------------------------ */
    PROCEDURE P_MAKE_PIVOT_SQL
    (
        P_V_FROM_YYYYMMDD   IN  VARCHAR2,
        P_V_TO_YYYYMMDD     IN  VARCHAR2,
        P_82_YN             IN  VARCHAR2,
        O_SQL               OUT CLOB
    )
    IS
        V_COLS      CLOB;
        V_CNT       PLS_INTEGER := 0;
    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_COLS, TRUE);

        /* 날짜 컬럼 생성 */
        FOR R IN (SELECT A.BASIS_YYYYMM AS MONTH
                    FROM SCM_SYS_CALENDAR_M A
                   WHERE A.BASIS_YYYYMMDD BETWEEN P_V_FROM_YYYYMMDD AND P_V_TO_YYYYMMDD
                   GROUP BY A.BASIS_YYYYMM
                          , A.MONTH_NAME
                   ORDER BY A.BASIS_YYYYMM)
        LOOP
            V_CNT := V_CNT + 1;
            DBMS_LOB.APPEND(V_COLS
                          , TO_CLOB('     , SUM(CASE WHEN MONTH = ''' || R.MONTH || ''' THEN QTY END) AS M_' || R.MONTH || CHR(10)));
        END LOOP;

        IF V_CNT = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Invalid length parameter passed to the LEFT or SUBSTRING function.');
        END IF;

        DBMS_LOB.CREATETEMPORARY(O_SQL, TRUE);

        IF P_82_YN = 'N' THEN
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
                   'SELECT DIVISION_ID'                                                             || CHR(10)
                || '     , DIVISION_NAME'                                                           || CHR(10)
                || '     , SCM_SITE_ID'                                                             || CHR(10)
                || '     , FN_GET_SCM_SITE_DESCRIPTION(DIVISION_ID, SCM_SITE_ID) AS SCM_SITE_NAME'  || CHR(10)
                || '     , PROJECT_CODE'                                                            || CHR(10)
                || '     , ITEM_ID'                                                                 || CHR(10)
                || '     , PLANT_PER_ITEM'                                                          || CHR(10)
                || '     , CMPLTD_STATUS'                                                           || CHR(10)
                || '     , FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID) AS NICK_NAME'                 || CHR(10)));
            DBMS_LOB.APPEND(O_SQL, V_COLS);
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
                   '  FROM GT_0006_PIVOT'                                                           || CHR(10)
                || ' GROUP BY DIVISION_ID'                                                          || CHR(10)
                || '        , DIVISION_NAME'                                                        || CHR(10)
                || '        , SCM_SITE_ID'                                                          || CHR(10)
                || '        , PROJECT_CODE'                                                         || CHR(10)
                || '        , ITEM_ID'                                                              || CHR(10)
                || '        , PLANT_PER_ITEM'                                                       || CHR(10)
                || '        , CMPLTD_STATUS'                                                        || CHR(10)
                || ' ORDER BY DIVISION_ID'                                                          || CHR(10)
                || '        , CMPLTD_STATUS'                                                        || CHR(10)
                || '        , PLANT_PER_ITEM'));
        ELSE
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
                   'SELECT DIVISION_ID'                                                             || CHR(10)
                || '     , DIVISION_NAME'                                                           || CHR(10)
                || '     , SCM_SITE_ID'                                                             || CHR(10)
                || '     , ''-'' AS SCM_SITE_NAME'                                                  || CHR(10)
                || '     , ''-'' AS PROJECT_CODE'                                                   || CHR(10)
                || '     , ITEM_ID'                                                                 || CHR(10)
                || '     , PLANT_PER_ITEM'                                                          || CHR(10)
                || '     , CMPLTD_STATUS'                                                           || CHR(10)
                || '     , FN_GET_ITEM_NICKNAME(DIVISION_ID, ITEM_ID) AS NICK_NAME'                 || CHR(10)));
            DBMS_LOB.APPEND(O_SQL, V_COLS);
            DBMS_LOB.APPEND(O_SQL, TO_CLOB(
                   '     , NO_DEMAND'                                                               || CHR(10)
                || '  FROM GT_0006_PIVOT'                                                           || CHR(10)
                || ' GROUP BY DIVISION_ID'                                                          || CHR(10)
                || '        , DIVISION_NAME'                                                        || CHR(10)
                || '        , SCM_SITE_ID'                                                          || CHR(10)
                || '        , PROJECT_CODE'                                                         || CHR(10)
                || '        , ITEM_ID'                                                              || CHR(10)
                || '        , PLANT_PER_ITEM'                                                       || CHR(10)
                || '        , CMPLTD_STATUS'                                                        || CHR(10)
                || '        , NO_DEMAND'                                                            || CHR(10)
                || ' ORDER BY DIVISION_ID'                                                          || CHR(10)
                || '        , CMPLTD_STATUS'                                                        || CHR(10)
                || '        , PLANT_PER_ITEM'));
        END IF;

    END P_MAKE_PIVOT_SQL;


    /* DEBUG 출력 */
    PROCEDURE P_PUT_CLOB
    (
        P_CLOB      IN  CLOB
    )
    IS
    BEGIN
        FOR I IN 0 .. TRUNC((NVL(DBMS_LOB.GETLENGTH(P_CLOB), 0) - 1) / 4000)
        LOOP
            DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(P_CLOB, 4000, I * 4000 + 1));
        END LOOP;
    END P_PUT_CLOB;


    /*==================================================================================================
     * Program ID   : SCP0006_GET_PROJECT_ROUTE_SITE
     * Description  : Project Route Site 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2017/12/28   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/01/16   PJS            피봇쿼리방식으로 변경
     * 2018/03/26   PJS            Sales Site(SCM_SITE_ID) 추가
     * 2018/04/10   PJS            등록수량 카운트 조회조건(날짜) 수정
     * 2018/04/17   PJS            임시테이블 삭제 OBJECT_ID형식으로 변경
     * 2018/05/03   byunghunjung   Alternate Part 제외로직 추가
     * 2018/05/17   byunghunjung   전극 제외
     * 2018/05/23   byunghunjung   전극 제외 로직 추가
     * 2018/05/28   byunghunjung   팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
     * 2018/05/28   byunghunjung   dm_pln_mkt_fcst 테이블 조회시 중복제거
     * 2018/06/11   PJS            시작일자 현재일자의 월요일로 고정
     * 2018/06/21   byunghunjung   BOM을 제거모델 조회안되도록 수정
     * 2018/09/14   hwyoon         Item Type = R 도 보이도록 수정
     * 2018/11/07   hwyoon         vmi에 따라 MKT measure 조절
     * 2021/04/07   PJG            수량 카운트용 쿼리 데이터 별도 임시테이블 저장
     * 2021/10/05   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
     * 2022/11/07   jahn1501       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
     * 2025/06/23   KANG.H.J       [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (강현준)
     * 2026/09/14                  MSSQL -> Oracle 전환
     * 2026/09/17   AJS            40 · 82 사업부는 _82 로직 수행 (화면 단일 호출 대응)
     * 2026/09/17   AJS            조회조건 Sales Site · Status 의 ALL 은 조건 미적용 (AS-IS 화면 변환과 동일)
     * 2026.10.07   AJS          조회 속도 개선 : 우선순위 1 생산지 확인을 한 번 읽기 외부조인으로, 엔지니어링 BOM 확인을 중복 제거 뒤로, MKT FCST 측정값 인덱스 조건 추가
     * 2026.10.08   AJS            조회조건 Model/Nickname : 입력값(쉼표 여러 개)이 코드 또는 닉네임에 부분일치 · 대소문자 무시 · ALL 은 조건 없음
     * 2026.10.13   AJS            조회조건 Project : 대소문자 무시(입력값 대문자 변환 · 원장 프로젝트 코드는 대문자) · ALL 은 조건 없음
     */
    PROCEDURE P_SCP0006_GET_PROJECT_ROUTE_SITE
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_SCM_SITE_ID     IN  VARCHAR2,
        P_PROJECT_CODE    IN  VARCHAR2,
        P_ITEM_ID         IN  VARCHAR2,
        P_FROM_YYYYMM     IN  VARCHAR2,
        P_TO_YYYYMM       IN  VARCHAR2,
        P_STATUS          IN  VARCHAR2,
        P_DEBUG_MODE      IN  VARCHAR2 DEFAULT 'F',
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CODE     OUT VARCHAR2,
        O_RESULT_MSG      OUT VARCHAR2
    )
    IS
        V_P_FROM_YYYYMMDD   VARCHAR2(8 CHAR);
        V_P_TO_YYYYMMDD     VARCHAR2(8 CHAR);
        V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
        V_FROM_RESULT       VARCHAR2(8 CHAR);
        V_TO_RESULT         VARCHAR2(8 CHAR);

        V_SITE_TAB          T_STR_TAB;
        V_SITE_ALL          VARCHAR2(1 CHAR);
        V_PROJECT_TAB       T_STR_TAB;
        V_PROJECT_ALL       VARCHAR2(1 CHAR);
        V_ITEM_TAB          T_STR_TAB;
        V_ITEM_ALL          VARCHAR2(1 CHAR);
        V_STATUS_TAB        T_STR_TAB;
        V_STATUS_ALL        VARCHAR2(1 CHAR);

        V_SQL               CLOB;
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        -- 2026.09.17 AJS 40 · 82 사업부는 _82 로직 수행 - 화면은 사업부 구분 없이 이 프로시저 하나만 호출 (START)
        IF P_DIVISION_ID IN ('82', '40') THEN
            P_SCP0006_GET_PROJECT_ROUTE_SITE_82(P_DIVISION_ID, P_SCM_SITE_ID, P_PROJECT_CODE, P_ITEM_ID
                                              , P_FROM_YYYYMM, P_TO_YYYYMM, P_STATUS, P_DEBUG_MODE
                                              , O_RC1, O_RESULT_CODE, O_RESULT_MSG);
            RETURN;
        END IF;
        -- 2026.09.17 AJS 40 · 82 사업부는 _82 로직 수행 - 화면은 사업부 구분 없이 이 프로시저 하나만 호출 (END)

        P_CALC_PERIOD(P_FROM_YYYYMM, P_TO_YYYYMM
                    , V_P_FROM_YYYYMMDD, V_P_TO_YYYYMMDD
                    , V_FROM_YYYYMMDD, V_TO_YYYYMMDD
                    , V_FROM_RESULT, V_TO_RESULT);

        -- 2026.09.17 AJS 조회조건 ALL 은 조건 미적용 - AS-IS 화면은 ALL 을 빈 값으로 전달 (START)
--        P_SPLIT_LIST(P_SCM_SITE_ID , V_SITE_TAB   , V_SITE_ALL);
        P_SPLIT_LIST(CASE WHEN UPPER(TRIM(P_SCM_SITE_ID)) = 'ALL' THEN NULL ELSE P_SCM_SITE_ID END, V_SITE_TAB, V_SITE_ALL);
        -- 2026.09.17 AJS 조회조건 ALL 은 조건 미적용 - AS-IS 화면은 ALL 을 빈 값으로 전달 (END)
--      P_SPLIT_LIST(P_PROJECT_CODE, V_PROJECT_TAB, V_PROJECT_ALL);   --  2026.10.13 AJS
        P_SPLIT_LIST(CASE WHEN UPPER(TRIM(P_PROJECT_CODE)) = 'ALL' THEN NULL ELSE UPPER(P_PROJECT_CODE) END, V_PROJECT_TAB, V_PROJECT_ALL);   --  2026.10.13 AJS
--      P_SPLIT_LIST(P_ITEM_ID     , V_ITEM_TAB   , V_ITEM_ALL);   --  2026.10.08 AJS
        -- 2026.10.08 AJS 조회조건 Model/Nickname : 입력값 + 코드 또는 닉네임 부분일치 품목으로 목록 확장 · ALL 은 조건 미적용 (START)
        P_SPLIT_LIST(CASE WHEN UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN NULL ELSE P_ITEM_ID END, V_ITEM_TAB, V_ITEM_ALL);
        IF V_ITEM_ALL = 'N' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (
                    SELECT TRIM(SA.COLUMN_VALUE) AS ITEM_ID      /* 완제품 테이블에 없는 품목은 입력한 코드 그대로 */
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE TRIM(SA.COLUMN_VALUE) IS NOT NULL
                     UNION
                    SELECT UPPER(TRIM(SB.COLUMN_VALUE))
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE TRIM(SB.COLUMN_VALUE) IS NOT NULL
                     UNION
                    SELECT XA.COLUMN_VALUE
                      FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, '')) XA
                   ) IA;
        END IF;
        -- 2026.10.08 AJS 조회조건 Model/Nickname (END)
        -- 2026.09.17 AJS 조회조건 ALL 은 조건 미적용 - AS-IS 화면은 ALL 을 빈 값으로 전달 (START)
--        P_SPLIT_LIST(P_STATUS      , V_STATUS_TAB , V_STATUS_ALL);
        P_SPLIT_LIST(CASE WHEN UPPER(TRIM(P_STATUS)) = 'ALL' THEN NULL ELSE P_STATUS END, V_STATUS_TAB, V_STATUS_ALL);
        -- 2026.09.17 AJS 조회조건 ALL 은 조건 미적용 - AS-IS 화면은 ALL 을 빈 값으로 전달 (END)

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('@p_division_id   = ' || P_DIVISION_ID);
            DBMS_OUTPUT.PUT_LINE('@p_scm_site_id   = ' || P_SCM_SITE_ID);
            DBMS_OUTPUT.PUT_LINE('@p_project_code  = ' || P_PROJECT_CODE);
            DBMS_OUTPUT.PUT_LINE('@p_item_id       = ' || P_ITEM_ID);
            DBMS_OUTPUT.PUT_LINE('@p_from_yyyymm   = ' || P_FROM_YYYYMM);
            DBMS_OUTPUT.PUT_LINE('@p_to_yyyymm     = ' || P_TO_YYYYMM);
            DBMS_OUTPUT.PUT_LINE('@p_status        = ' || P_STATUS);
            DBMS_OUTPUT.PUT_LINE('@p_from_yyyymmdd = ' || V_P_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('@v_from_result   = ' || V_FROM_RESULT);
            DBMS_OUTPUT.PUT_LINE('@v_to_result     = ' || V_TO_RESULT);
            DBMS_OUTPUT.PUT_LINE('@v_from_yyyymmdd = ' || V_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('@v_to_yyyymmdd   = ' || V_TO_YYYYMMDD);
        END IF;

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE FROM GT_0006_CNT;
        DELETE FROM GT_0006_PIVOT;
        DELETE FROM GT_0006_FINAL_ITEM;

        /* 최종 아이템 사업부 한정 사본 - 뷰(UNION 전개)를 문장마다 다시 풀면 실행계획이 흔들려 한 번만 받아 둔다 */
        INSERT INTO GT_0006_FINAL_ITEM
             ( DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN                                   /* 2026.09.23 AJS BOM 갈래 공용 */
             , RACK_YN                                 /* 2026.09.23 AJS BOM 갈래 공용 */
             , CELL_TYPE )                             /* 2026.09.23 AJS BOM 갈래 공용 */
        SELECT DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN
             , RACK_YN
             , CELL_TYPE
          FROM SCM_MST_FINAL_ITEM_V
         WHERE DIVISION_ID = P_DIVISION_ID;

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_FINAL_ITEM', NO_INVALIDATE => FALSE);

        /* 수량 카운트용 쿼리 데이터 임시테이블 저장 (AS-IS #TblDynamicPivot_SCP0006_02) */
        INSERT INTO GT_0006_CNT
             ( DIVISION_ID
             , SCM_SITE_ID
             , PROJECT_CODE
             , MODEL_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS )
        SELECT IB.DIVISION_ID
             , IB.SCM_SITE_ID
             , IB.PROJECT_CODE
             , IB.MODEL_ID
             , TO_CHAR(SUM(IB.PLANT_CNT)) || '/' || TO_CHAR(IB.TOT_CNT) AS PLANT_PER_ITEM
             , CASE WHEN SUM(IB.PLANT_CNT) = IB.TOT_CNT THEN 'Y'
                    ELSE 'N'
               END AS CMPLTD_STATUS
          FROM (SELECT IA.DIVISION_ID
                     , IA.SCM_SITE_ID
                     , IA.PROJECT_CODE
                     , IA.MODEL_ID
                     , COUNT(*) OVER (PARTITION BY IA.DIVISION_ID, IA.SCM_SITE_ID, IA.PROJECT_CODE, IA.MODEL_ID) AS TOT_CNT
                     , CASE WHEN IA.PRIMARY_PLANT IS NOT NULL THEN 1
                            ELSE 0
                       END AS PLANT_CNT
                  FROM (SELECT DISTINCT
                               CASE WHEN (SELECT FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) FROM DUAL) = 'E' THEN C.ITEM_ID
                                    ELSE B.MODEL_ID
                               END AS MODEL_ID
                             , CASE /* 전극 제외 20180517 */
                                    WHEN D.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                    WHEN D.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                               END AS OPERATION_GROUP_ID
                             , D.ELECTRODE_TYPE
                             , B.CHILD_ITEM_ID AS ITEM_ID
-- 2026.10.07 AJS 속도 개선 - 우선순위 1 생산지 존재 여부를 행마다 전체 읽기 하지 않고 한 번 읽어 외부조인 (START)
--                             , CASE WHEN EXISTS (SELECT 1
--                                                   FROM SCM_MST_SITE_ITEM_PRIORITY XA
--                                                  WHERE XA.DIVISION_ID   = B.DIVISION_ID
--                                                    AND XA.ITEM_ID       = B.CHILD_ITEM_ID
--                                                    AND XA.PROJECT_CODE  = A.PROJECT_CODE
--                                                    AND XA.SALES_SITE_ID = A.SCM_SITE_ID     /* 20180326 sales site 추가부분 */
--                                                    AND XA.VALID_YN      = 'Y'
--                                                    AND XA.PRIORITY      = 1
--                                                    AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')) THEN 1
--                               END AS PRIMARY_PLANT
                             , CASE WHEN IE.ITEM_ID IS NOT NULL THEN 1
                               END AS PRIMARY_PLANT
-- 2026.10.07 AJS 속도 개선 (END)
                             , B.DIVISION_ID
                             , A.SCM_SITE_ID
                             , A.PROJECT_CODE
                          FROM DM_PLN_MKT_FCST A
                             , SCM_MST_BOM_SN_V B            /* 2021.03.25 대체 BOM 모델링 */
                             , SCM_MST_ITEM_SN C
                             , GT_0006_FINAL_ITEM D            /* SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                             , (SELECT DIVISION_ID
                                     , SCM_SITE_ID
                                     , OPERATION_GROUP
                                     , VMI_YN
                                  FROM SCM_MST_SITE
                                 WHERE VMI_YN = 'Y'
                                    OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W')
                               ) IC                          /* 2021/10/05 : W/S AS */
-- 2026.10.07 AJS 속도 개선 - 우선순위 1 생산지 한 번 읽기 (START)
                             , (SELECT DISTINCT
                                       XA.DIVISION_ID
                                     , XA.ITEM_ID
                                     , XA.PROJECT_CODE
                                     , XA.SALES_SITE_ID
                                  FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                 WHERE XA.VALID_YN      = 'Y'
                                   AND XA.PRIORITY      = 1
                                   AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                   AND XA.DIVISION_ID   = P_DIVISION_ID
                               ) IE                          /* 우선순위 1 생산지 (사업부 한정 한 번 읽기) */
-- 2026.10.07 AJS 속도 개선 (END)
                         WHERE A.DIVISION_ID      = B.DIVISION_ID
                           AND A.ITEM_ID          = B.MODEL_ID
                           AND B.COMPANY_ID       = C.COMPANY_ID
                           AND B.DIVISION_ID      = C.DIVISION_ID
                           AND B.SITE_ID          = C.SITE_ID
                           AND B.CHILD_ITEM_ID    = C.ITEM_ID
                           AND B.DIVISION_ID      = D.DIVISION_ID
                           AND B.CHILD_ITEM_ID    = D.ITEM_ID
                           AND IC.DIVISION_ID(+)  = A.DIVISION_ID
                           AND IC.SCM_SITE_ID(+)  = A.SCM_SITE_ID
-- 2026.10.07 AJS 속도 개선 - 우선순위 1 생산지 외부조인 (START)
                           AND IE.DIVISION_ID(+)   = B.DIVISION_ID
                           AND IE.ITEM_ID(+)       = B.CHILD_ITEM_ID
                           AND IE.PROJECT_CODE(+)  = A.PROJECT_CODE
                           AND IE.SALES_SITE_ID(+) = A.SCM_SITE_ID
-- 2026.10.07 AJS 속도 개선 (END)
                           /* 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정 */
-- 2026.09.23 AJS 성능 - 비상관 인라인뷰는 엔지니어링 BOM 전건(48.5만행)을 읽어 정렬한다. AS-IS 원문과 같은 상관 EXISTS 로 복원 (START)
--                           AND B.CHILD_ITEM_ID IN (SELECT XC.PARENT_ITEM_ID
--                                                     FROM (SELECT XB.PARENT_ITEM_ID
--                                                                , XB.KEY_DATE
--                                                                , XB.EFF_END_DATE
--                                                                , MAX(XB.KEY_DATE) OVER (PARTITION BY XB.PARENT_ITEM_ID) AS MAX_KEY_DATE
--                                                             FROM SCM_MST_BOM_ENG_SN XB
--                                                            WHERE XB.DIVISION_ID = P_DIVISION_ID
--                                                          ) XC
--                                                    WHERE XC.KEY_DATE      = XC.MAX_KEY_DATE
--                                                      AND XC.EFF_END_DATE >= SYSDATE)
-- 2026.10.07 AJS 속도 개선 - 엔지니어링 BOM 최신 KEY_DATE 확인을 중복 제거 뒤(IA)로 옮김 - 같은 품목 조건이라 결과 동일 (START)
--                           AND EXISTS (SELECT 1
--                                         FROM SCM_MST_BOM_ENG_SN XC
--                                        WHERE XC.PARENT_ITEM_ID  = B.CHILD_ITEM_ID
--                                          AND XC.KEY_DATE        = (SELECT MAX(XB.KEY_DATE)
--                                                                      FROM SCM_MST_BOM_ENG_SN XB
--                                                                     WHERE XB.PARENT_ITEM_ID = B.CHILD_ITEM_ID
--                                                                       AND XB.DIVISION_ID     = P_DIVISION_ID)
--                                          AND XC.EFF_END_DATE   >= SYSDATE
--                                          AND XC.DIVISION_ID     = P_DIVISION_ID)     /* 최신 KEY_DATE 기준 BOM 존재 */
-- 2026.10.07 AJS 속도 개선 (END)
-- 2026.09.23 AJS 성능 - 상관 EXISTS 복원 (END)
                           /* 2022/11/07 */
                           AND A.MEASURE          = CASE WHEN IC.OPERATION_GROUP = 'W'     THEN 'AS_In_Req'
                                                         WHEN IC.VMI_YN = 'Y'              THEN 'VMI_In_Req'
                                                         WHEN RTRIM(A.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                                    END
                           AND A.MEASURE         IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST')     /* 위 CASE 결과값 목록 - 인덱스 조건 */    --  2026.10.07 AJS
                           AND B.ALT_PRIORITY     = 'Y'              /* Alternate Part 제외로직 추가 */
                           AND A.QTY              > 0
                           AND D.OPERATION_GROUP_ID <> 'E'
                           /* 실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음 */
                           AND A.YYYYMMDD        >= V_P_FROM_YYYYMMDD
                           AND A.YYYYMMDD        <= V_P_TO_YYYYMMDD
                           AND A.DIVISION_ID      = P_DIVISION_ID
                           AND (V_PROJECT_ALL = 'Y' OR A.PROJECT_CODE IN (SELECT COLUMN_VALUE FROM TABLE(V_PROJECT_TAB)))
                           AND (V_ITEM_ALL    = 'Y' OR B.MODEL_ID     IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                       ) IA
-- 2026.10.07 AJS 속도 개선 - 엔지니어링 BOM 최신 KEY_DATE 확인 (중복 제거 뒤 품목 단위) (START)
                 WHERE EXISTS (SELECT /*+ NO_UNNEST */
                                      1
                                 FROM SCM_MST_BOM_ENG_SN XC
                                WHERE XC.PARENT_ITEM_ID  = IA.ITEM_ID
                                  AND XC.KEY_DATE        = (SELECT MAX(XB.KEY_DATE)
                                                              FROM SCM_MST_BOM_ENG_SN XB
                                                             WHERE XB.PARENT_ITEM_ID = IA.ITEM_ID
                                                               AND XB.DIVISION_ID    = P_DIVISION_ID)
                                  AND XC.EFF_END_DATE   >= SYSDATE
                                  AND XC.DIVISION_ID     = P_DIVISION_ID)     /* 최신 KEY_DATE 기준 BOM 존재 */
-- 2026.10.07 AJS 속도 개선 (END)
               ) IB
         GROUP BY IB.DIVISION_ID
                , IB.SCM_SITE_ID
                , IB.PROJECT_CODE
                , IB.MODEL_ID
                , IB.TOT_CNT;

        /* AS-IS #TblDynamicPivot_SCP0006_01 */
        INSERT INTO GT_0006_PIVOT
             ( DIVISION_ID
             , DIVISION_NAME
             , SCM_SITE_ID
             , PROJECT_CODE
             , ITEM_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS
             , MONTH
             , QTY )
        SELECT IA.DIVISION_ID
             , FN_GET_DIVISION_NAME(IA.DIVISION_ID) AS DIVISION_NAME
             , IA.SCM_SITE_ID
             , IA.PROJECT_CODE
             , IA.ITEM_ID
             , CASE WHEN B.PLANT_PER_ITEM IS NULL THEN 'BOM Not Exists'
                    ELSE B.PLANT_PER_ITEM
               END AS PLANT_PER_ITEM
             , NVL(B.CMPLTD_STATUS, 'N') AS CMPLTD_STATUS
             , SUBSTR(IA.YYYYMMDD, 1, 6) AS MONTH
             , IA.QTY
          FROM (SELECT DISTINCT
                       A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , A.QTY
                  FROM DM_PLN_MKT_FCST A
                     , SCM_MST_ITEM_SN B
                     , (SELECT DIVISION_ID
                             , SCM_SITE_ID
                             , OPERATION_GROUP
                             , VMI_YN
                          FROM SCM_MST_SITE
                         WHERE VMI_YN = 'Y'
                            OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W')
                       ) XA                                  /* 2021/10/05 : W/S AS */
                 WHERE A.DIVISION_ID      = B.DIVISION_ID
                   AND A.ITEM_ID          = B.ITEM_ID
                   AND XA.DIVISION_ID(+)  = A.DIVISION_ID
                   AND XA.SCM_SITE_ID(+)  = A.SCM_SITE_ID
                   /* 2022/11/07 */
                   AND A.MEASURE          = CASE WHEN XA.OPERATION_GROUP = 'W'     THEN 'AS_In_Req'
                                                 WHEN XA.VMI_YN = 'Y'              THEN 'VMI_In_Req'
                                                 WHEN RTRIM(A.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                            END
                   AND B.SCP_OPERATION_GROUP_ID <> 'E'
                   AND A.QTY              > 0
                   AND A.YYYYMMDD IS NOT NULL
                   AND A.YYYYMMDD        >= V_FROM_YYYYMMDD
                   AND A.YYYYMMDD        <= V_TO_YYYYMMDD
                   AND A.DIVISION_ID      = P_DIVISION_ID
                   AND (V_SITE_ALL    = 'Y' OR A.SCM_SITE_ID  IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))     /* 20180326 sale site 추가부분 */
                   AND (V_PROJECT_ALL = 'Y' OR A.PROJECT_CODE IN (SELECT COLUMN_VALUE FROM TABLE(V_PROJECT_TAB)))
                   AND (V_ITEM_ALL    = 'Y' OR A.ITEM_ID      IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                 UNION ALL
                /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DISTINCT 제거, GROUP BY 에 의해 SUM(QTY) 처리) */
                SELECT C.DIVISION_ID
                     , C.PROJECT_CODE
                     , C.SCM_SITE_ID
                     , C.ITEM_ID
                     , C.DOM_EXP
                     , C.FCST_TYPE
                     , C.INCOTERMS
                     , C.MEASURE
                     , C.PLANT_SITE_ID
                     , C.YYYYMMDD
                     , SUM(C.QTY) AS QTY
                  FROM DM_PLN_MKT_FCST_RESULT C
                     , SCM_MST_ITEM_SN D
                     , (SELECT DIVISION_ID
                             , SCM_SITE_ID
                             , OPERATION_GROUP
                             , VMI_YN
                          FROM SCM_MST_SITE
                         WHERE VMI_YN = 'Y'
                            OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W')
                       ) XB
                 WHERE C.DIVISION_ID      = D.DIVISION_ID
                   AND C.ITEM_ID          = D.ITEM_ID
                   AND XB.DIVISION_ID(+)  = C.DIVISION_ID
                   AND XB.SCM_SITE_ID(+)  = C.SCM_SITE_ID
                   AND C.MEASURE          = CASE WHEN XB.OPERATION_GROUP = 'W'     THEN 'AS_In_Req'
                                                 WHEN XB.VMI_YN = 'Y'              THEN 'VMI_In_Req'
                                                 WHEN RTRIM(C.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                            END
                   AND D.SCP_OPERATION_GROUP_ID <> 'E'
                   AND C.QTY              > 0
                   AND C.YYYYMMDD IS NOT NULL
                   AND C.YYYYMMDD        >= V_FROM_RESULT
                   AND C.YYYYMMDD        <= V_TO_RESULT
                   AND C.DIVISION_ID      = P_DIVISION_ID
                   AND (V_SITE_ALL    = 'Y' OR C.SCM_SITE_ID  IN (SELECT COLUMN_VALUE FROM TABLE(V_SITE_TAB)))
                   AND (V_PROJECT_ALL = 'Y' OR C.PROJECT_CODE IN (SELECT COLUMN_VALUE FROM TABLE(V_PROJECT_TAB)))
                   AND (V_ITEM_ALL    = 'Y' OR C.ITEM_ID      IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                 GROUP BY C.DIVISION_ID
                        , C.PROJECT_CODE
                        , C.SCM_SITE_ID
                        , C.ITEM_ID
                        , C.DOM_EXP
                        , C.FCST_TYPE
                        , C.INCOTERMS
                        , C.MEASURE
                        , C.PLANT_SITE_ID
                        , C.YYYYMMDD
               ) IA
             , GT_0006_CNT B
             , SCM_MST_SITE_ITEM E
             , (SELECT F.DIVISION_ID
                     , F.ITEM_ID
                     , F.ITEM_TYPE
                     , ROW_NUMBER() OVER (PARTITION BY F.DIVISION_ID, F.ITEM_ID
                                              ORDER BY CASE F.ITEM_TYPE WHEN 'P' THEN 999
                                                                        WHEN 'H' THEN 888
                                                                        WHEN 'R' THEN 777
                                                                        WHEN 'Q' THEN 666
                                                                        ELSE 0
                                                       END DESC) AS NUMS
                  FROM SCM_MST_ITEM_SN F
-- 2026.09.23 AJS 성능 - 아이템 원장 전건(78.9만행) 읽기를 사업부 범위로 축소. 바깥 조인조건에서 파생되는 필터라 결과는 같다 (START)
                 WHERE F.DIVISION_ID = P_DIVISION_ID
-- 2026.09.23 AJS 성능 - 사업부 한정 (END)
               ) IB
         WHERE IA.DIVISION_ID     = B.DIVISION_ID(+)
           AND IA.SCM_SITE_ID     = B.SCM_SITE_ID(+)
           AND IA.PROJECT_CODE    = B.PROJECT_CODE(+)
           AND IA.ITEM_ID         = B.MODEL_ID(+)
           AND IA.DIVISION_ID     = E.DIVISION_ID
           AND IA.ITEM_ID         = E.ITEM_ID
           AND IA.SCM_SITE_ID     = E.SCM_SITE_ID
           AND IA.PROJECT_CODE    = E.PROJECT_CODE
           AND IA.DIVISION_ID     = IB.DIVISION_ID
           AND IA.ITEM_ID         = IB.ITEM_ID
           AND IB.NUMS            = 1
           AND IB.ITEM_TYPE NOT IN ('Q', 'R')
           AND IA.MEASURE        IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST')      /* 2021/10/05 : W/S AS */
           AND (V_STATUS_ALL = 'Y' OR B.CMPLTD_STATUS IN (SELECT COLUMN_VALUE FROM TABLE(V_STATUS_TAB)));

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_PIVOT', NO_INVALIDATE => FALSE);

        /* PIVOT 쿼리 실행 */
        P_MAKE_PIVOT_SQL(V_FROM_YYYYMMDD, V_TO_YYYYMMDD, 'N', V_SQL);

        IF P_DEBUG_MODE = 'T' THEN
            P_PUT_CLOB(V_SQL);
        END IF;

        OPEN O_RC1 FOR V_SQL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0006_GET_PROJECT_ROUTE_SITE'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_PROJECT_CODE=' || P_PROJECT_CODE
                     || ', P_ITEM_ID=' || P_ITEM_ID
                     || ', P_FROM_YYYYMM=' || P_FROM_YYYYMM
                     || ', P_TO_YYYYMM=' || P_TO_YYYYMM
                     || ', P_STATUS=' || P_STATUS
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0006_GET_PROJECT_ROUTE_SITE;


    /*==================================================================================================
     * Program ID   : SCP0006_GET_PROJECT_ROUTE_SITE_82
     * Description  : Project Route Site 조회(divsion 82전용)
     * Comments     : @p_scm_site_id,@p_project_code 미사용 SCP0006_GET_PROJECT_ROUTE_SITE와 파라미터 호환을 위해 남겨둠
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/04/09   PJS            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/04/17   PJS            임시테이블 삭제 OBJECT_ID형식으로 변경
     * 2018/05/03   byunghunjung   Alternate Part 제외로직 추가
     * 2018/05/17   byunghunjung   전극 제외
     * 2018/05/23   byunghunjung   전극 제외 로직 추가
     * 2018/05/28   byunghunjung   팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
     * 2018/05/28   byunghunjung   dm_pln_mkt_fcst 테이블 조회시 중복제거
     * 2018/06/11   PJS            시작일자 현재일자의 월요일로 고정
     * 2018/06/21   byunghunjung   BOM을 제거모델 조회안되도록 수정
     * 2018/09/14   hwyoon         Item Type = R 도 보이도록 수정
     * 2018/11/07   hwyoon         vmi에 따라 MKT measure 조절
     * 2019/09/02   hwyoon         [CSR ID:4077274] 자체개선 - SCP 3개 메뉴 기능보완(Global PSI, Project Route, Master Validation)
     *                             MKT FCST 수량 조회 쿼리 변경 - 동일 Plant에서 여러 Sales Site로 동일날짜&동일수량 으로 잡히는 경우 수량SUM 계산
     * 2021/04/07   PJG            수량 카운트용 쿼리 데이터 별도 임시테이블 저장
     * 2021/10/05   khj79          [PJ20209643] LGES Digital SCM Level.3 달성을 위한 개선 (Phase.3) - W/S AS UI 변경
     * 2022/11/07   jahn1501       PJ20216994 / LGES Digital SCM 3 Level 가속화를 위한 개선 Phase 2 - MKT FCST 조건 변경
     * 2023/06/29   vadabi3        [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - ACTIVE_FLAG = N Material 조건 적용
     * 2024/01/15   chaan          V1.1.1  PJ20216994 - 조회대상 제외 로직 수정(하나라도 ACTIVE_FLAG = N 이면 제외 => 전체가 N 이면 제외로 변경)
     * 2025/06/23   KANG.H.J       [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (강현준)
     * 2026.07.15   YMH            E20260713-000141 [ESS]Project Route 화면 기능 개선요청드립니다
     * 2026/09/14                  MSSQL -> Oracle 전환
     * 2026/09/17   AJS            조회조건 Status 의 ALL 은 조건 미적용 (AS-IS 화면 변환과 동일)
     * 2026.10.07   AJS          조회 속도 개선 2차 : 우선순위 1 생산지 확인을 한 번 읽기 외부조인으로, 엔지니어링 BOM 확인을 중복 제거 뒤로, MKT FCST 인덱스 읽기, 수요 없는 모델 BOM 의 품목 원장 조회 축소, 사업부명 함수 결과 재사용, 비활성 품목 판정을 조회 품목마다 확인(FN_GET_SCP_ITEM_INACTIVE 와 같은 판정)
     * 2026.10.08   AJS            조회조건 Model/Nickname : 입력값(쉼표 여러 개)이 코드 또는 닉네임에 부분일치 · 대소문자 무시 · ALL 은 조건 없음
     */
    PROCEDURE P_SCP0006_GET_PROJECT_ROUTE_SITE_82
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_SCM_SITE_ID     IN  VARCHAR2,
        P_PROJECT_CODE    IN  VARCHAR2,
        P_ITEM_ID         IN  VARCHAR2,
        P_FROM_YYYYMM     IN  VARCHAR2,
        P_TO_YYYYMM       IN  VARCHAR2,
        P_STATUS          IN  VARCHAR2,
        P_DEBUG_MODE      IN  VARCHAR2 DEFAULT 'F',
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CODE     OUT VARCHAR2,
        O_RESULT_MSG      OUT VARCHAR2
    )
    IS
        V_P_FROM_YYYYMMDD   VARCHAR2(8 CHAR);
        V_P_TO_YYYYMMDD     VARCHAR2(8 CHAR);
        V_FROM_YYYYMMDD     VARCHAR2(8 CHAR);
        V_TO_YYYYMMDD       VARCHAR2(8 CHAR);
        V_FROM_RESULT       VARCHAR2(8 CHAR);
        V_TO_RESULT         VARCHAR2(8 CHAR);

        V_ITEM_TAB          T_STR_TAB;
        V_ITEM_ALL          VARCHAR2(1 CHAR);
        V_STATUS_TAB        T_STR_TAB;
        V_STATUS_ALL        VARCHAR2(1 CHAR);

        V_SQL               CLOB;
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        P_CALC_PERIOD(P_FROM_YYYYMM, P_TO_YYYYMM
                    , V_P_FROM_YYYYMMDD, V_P_TO_YYYYMMDD
                    , V_FROM_YYYYMMDD, V_TO_YYYYMMDD
                    , V_FROM_RESULT, V_TO_RESULT);

--      P_SPLIT_LIST(P_ITEM_ID, V_ITEM_TAB  , V_ITEM_ALL);   --  2026.10.08 AJS
        -- 2026.10.08 AJS 조회조건 Model/Nickname : 입력값 + 코드 또는 닉네임 부분일치 품목으로 목록 확장 · ALL 은 조건 미적용 (START)
        P_SPLIT_LIST(CASE WHEN UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN NULL ELSE P_ITEM_ID END, V_ITEM_TAB, V_ITEM_ALL);
        IF V_ITEM_ALL = 'N' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (
                    SELECT TRIM(SA.COLUMN_VALUE) AS ITEM_ID      /* 완제품 테이블에 없는 품목은 입력한 코드 그대로 */
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE TRIM(SA.COLUMN_VALUE) IS NOT NULL
                     UNION
                    SELECT UPPER(TRIM(SB.COLUMN_VALUE))
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE TRIM(SB.COLUMN_VALUE) IS NOT NULL
                     UNION
                    SELECT XA.COLUMN_VALUE
                      FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, '')) XA
                   ) IA;
        END IF;
        -- 2026.10.08 AJS 조회조건 Model/Nickname (END)
        -- 2026.09.17 AJS 조회조건 ALL 은 조건 미적용 - AS-IS 화면은 ALL 을 빈 값으로 전달 (START)
--        P_SPLIT_LIST(P_STATUS , V_STATUS_TAB, V_STATUS_ALL);
        P_SPLIT_LIST(CASE WHEN UPPER(TRIM(P_STATUS)) = 'ALL' THEN NULL ELSE P_STATUS END, V_STATUS_TAB, V_STATUS_ALL);
        -- 2026.09.17 AJS 조회조건 ALL 은 조건 미적용 - AS-IS 화면은 ALL 을 빈 값으로 전달 (END)

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('==============PARMS INFO================');
            DBMS_OUTPUT.PUT_LINE('@p_division_id   = ' || P_DIVISION_ID);
            DBMS_OUTPUT.PUT_LINE('@p_item_id       = ' || P_ITEM_ID);
            DBMS_OUTPUT.PUT_LINE('@p_from_yyyymm   = ' || P_FROM_YYYYMM);
            DBMS_OUTPUT.PUT_LINE('@p_to_yyyymm     = ' || P_TO_YYYYMM);
            DBMS_OUTPUT.PUT_LINE('@p_status        = ' || P_STATUS);
            DBMS_OUTPUT.PUT_LINE('@p_from_yyyymmdd = ' || V_P_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('@v_from_result   = ' || V_FROM_RESULT);
            DBMS_OUTPUT.PUT_LINE('@v_to_result     = ' || V_TO_RESULT);
            DBMS_OUTPUT.PUT_LINE('@v_from_yyyymmdd = ' || V_FROM_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE('@v_to_yyyymmdd   = ' || V_TO_YYYYMMDD);
        END IF;

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE FROM GT_0006_CNT;
        DELETE FROM GT_0006_DATA;
        DELETE FROM GT_0006_PIVOT;
        DELETE FROM GT_0006_NO_DEMAND;
        DELETE FROM GT_0006_INACTIVE;
        DELETE FROM GT_0006_FINAL_ITEM;

        /* 최종 아이템 사업부 한정 사본 - 뷰(UNION 전개)를 문장마다 다시 풀면 실행계획이 흔들려 한 번만 받아 둔다 */
        INSERT INTO GT_0006_FINAL_ITEM
             ( DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN                                   /* 2026.09.23 AJS BOM 갈래 공용 */
             , RACK_YN                                 /* 2026.09.23 AJS BOM 갈래 공용 */
             , CELL_TYPE )                             /* 2026.09.23 AJS BOM 갈래 공용 */
        SELECT DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN
             , RACK_YN
             , CELL_TYPE
          FROM SCM_MST_FINAL_ITEM_V
         WHERE DIVISION_ID = P_DIVISION_ID;

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_FINAL_ITEM', NO_INVALIDATE => FALSE);

        /* 수량 카운트용 쿼리 데이터 임시테이블 저장 (AS-IS #TblDynamicPivot_SCP0006_03) */
        INSERT INTO GT_0006_CNT
             ( DIVISION_ID
             , SCM_SITE_ID
             , PROJECT_CODE
             , MODEL_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS )
        SELECT IB.DIVISION_ID
             , IB.SCM_SITE_ID
             , IB.PROJECT_CODE
             , IB.MODEL_ID
             , TO_CHAR(SUM(IB.PLANT_CNT)) || '/' || TO_CHAR(IB.TOT_CNT) AS PLANT_PER_ITEM
             , CASE WHEN SUM(IB.PLANT_CNT) = IB.TOT_CNT THEN 'Y'
                    ELSE 'N'
               END AS CMPLTD_STATUS
          FROM (SELECT IA.DIVISION_ID
                     , '-' AS SCM_SITE_ID
                     , '-' AS PROJECT_CODE
                     , IA.MODEL_ID
                     , COUNT(*) OVER (PARTITION BY IA.DIVISION_ID, IA.MODEL_ID) AS TOT_CNT
                     , CASE WHEN IA.PRIMARY_PLANT IS NOT NULL THEN 1
                            ELSE 0
                       END AS PLANT_CNT
--                FROM (SELECT DISTINCT
                  FROM (SELECT /*+ INDEX(A IDX_DM_PLN_MKT_FCST_N1) */ DISTINCT             /* AJS 20261007 속도 : MKT FCST 측정값 · 일자 인덱스 */
                               CASE WHEN (SELECT FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) FROM DUAL) = 'E' THEN C.ITEM_ID
                                    ELSE B.MODEL_ID
                               END AS MODEL_ID
                             , CASE /* 전극 제외 20180517 */
                                    WHEN D.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                    WHEN D.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                               END AS OPERATION_GROUP_ID
                             , D.ELECTRODE_TYPE
                             , B.CHILD_ITEM_ID AS ITEM_ID
--                           , CASE WHEN EXISTS (SELECT 1
--                                                 FROM SCM_MST_SITE_ITEM_PRIORITY XA
--                                                WHERE XA.DIVISION_ID   = B.DIVISION_ID
--                                                  AND XA.ITEM_ID       = B.CHILD_ITEM_ID
--                                                  AND XA.VALID_YN      = 'Y'
--                                                  AND XA.PRIORITY      = 1
--                                                  AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')) THEN 1
--                             END AS PRIMARY_PLANT
                             , CASE WHEN IE.ITEM_ID IS NOT NULL THEN 1 /* AJS 20261007 속도 */
                               END AS PRIMARY_PLANT /* AJS 20261007 속도 */
                             , B.DIVISION_ID
                          FROM DM_PLN_MKT_FCST A
                             , SCM_MST_BOM_SN_V B            /* 2021.03.25 대체 BOM 모델링 */
                             , SCM_MST_ITEM_SN C
                             , GT_0006_FINAL_ITEM D            /* SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                             , (SELECT DIVISION_ID
                                     , SCM_SITE_ID
                                     , OPERATION_GROUP
                                     , VMI_YN
                                  FROM SCM_MST_SITE
                                 WHERE VMI_YN = 'Y'
                                    OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W')
                               ) IC                          /* 2021/10/05 : W/S AS */
                             , (SELECT DISTINCT /* AJS 20261007 속도 */
                                       XA.DIVISION_ID
                                     , XA.ITEM_ID
                                  FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                 WHERE XA.VALID_YN      = 'Y'
                                   AND XA.PRIORITY      = 1
                                   AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                   AND XA.DIVISION_ID   = P_DIVISION_ID
                               ) IE                          /* 우선순위 1 생산지 (사업부 한정 한 번 읽기) - AJS 20261007 속도 */
                         WHERE A.DIVISION_ID      = B.DIVISION_ID
                           AND A.ITEM_ID          = B.MODEL_ID
                           AND B.COMPANY_ID       = C.COMPANY_ID
                           AND B.DIVISION_ID      = C.DIVISION_ID
                           AND B.SITE_ID          = C.SITE_ID
                           AND B.CHILD_ITEM_ID    = C.ITEM_ID
                           AND B.DIVISION_ID      = D.DIVISION_ID
                           AND B.CHILD_ITEM_ID    = D.ITEM_ID
                           AND IC.DIVISION_ID(+)  = A.DIVISION_ID
                           AND IC.SCM_SITE_ID(+)  = A.SCM_SITE_ID
                           AND IE.DIVISION_ID(+)  = B.DIVISION_ID /* AJS 20261007 속도 */
                           AND IE.ITEM_ID(+)      = B.CHILD_ITEM_ID /* AJS 20261007 속도 */
                           /* ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정 */
-- 2026.09.23 AJS 성능 - 비상관 인라인뷰는 엔지니어링 BOM 전건(48.5만행)을 읽어 정렬한다. AS-IS 원문과 같은 상관 EXISTS 로 복원 (START)
--                           AND B.CHILD_ITEM_ID IN (SELECT XC.PARENT_ITEM_ID
--                                                     FROM (SELECT XB.PARENT_ITEM_ID
--                                                                , XB.KEY_DATE
--                                                                , XB.EFF_END_DATE
--                                                                , MAX(XB.KEY_DATE) OVER (PARTITION BY XB.PARENT_ITEM_ID) AS MAX_KEY_DATE
--                                                             FROM SCM_MST_BOM_ENG_SN XB
--                                                            WHERE XB.DIVISION_ID = P_DIVISION_ID
--                                                          ) XC
--                                                    WHERE XC.KEY_DATE      = XC.MAX_KEY_DATE
--                                                      AND XC.EFF_END_DATE >= SYSDATE)
/* AJS 20261007 속도 - 엔지니어링 BOM 최신 KEY_DATE 확인은 중복 제거 뒤(IA)로 옮김 */
--                         AND EXISTS (SELECT 1
--                                       FROM SCM_MST_BOM_ENG_SN XC
--                                      WHERE XC.PARENT_ITEM_ID  = B.CHILD_ITEM_ID
--                                        AND XC.KEY_DATE        = (SELECT MAX(XB.KEY_DATE)
--                                                                    FROM SCM_MST_BOM_ENG_SN XB
--                                                                   WHERE XB.PARENT_ITEM_ID = B.CHILD_ITEM_ID
--                                                                     AND XB.DIVISION_ID     = P_DIVISION_ID)
--                                        AND XC.EFF_END_DATE   >= SYSDATE
--                                        AND XC.DIVISION_ID     = P_DIVISION_ID)     /* 최신 KEY_DATE 기준 BOM 존재 */
-- 2026.09.23 AJS 성능 - 상관 EXISTS 복원 (END)
                           /* 2022/11/07 */
                           AND A.MEASURE          = CASE WHEN IC.OPERATION_GROUP = 'W'     THEN 'AS_In_Req'
                                                         WHEN IC.VMI_YN = 'Y'              THEN 'VMI_In_Req'
                                                         WHEN RTRIM(A.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                                    END
                           AND A.MEASURE         IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST')     /* 위 CASE 결과값 목록 - 인덱스 조건 */ /* AJS 20261007 속도 */
                           AND B.ALT_PRIORITY     = 'Y'              /* Alternate Part 제외로직 추가 */
                           AND A.QTY              > 0
                           AND D.OPERATION_GROUP_ID <> 'E'
                           /* 실적(등록된 카운트)수량은 분기되기 이전 날짜 전체를 사용해야 카운트가 맞음 */
                           AND A.YYYYMMDD        >= V_P_FROM_YYYYMMDD
                           AND A.YYYYMMDD        <= V_P_TO_YYYYMMDD
                           AND A.DIVISION_ID      = P_DIVISION_ID
                           AND (V_ITEM_ALL = 'Y' OR B.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                       ) IA
                 WHERE EXISTS (SELECT /*+ NO_UNNEST */ /* AJS 20261007 속도 */
                                      1
                                 FROM SCM_MST_BOM_ENG_SN XC
                                WHERE XC.PARENT_ITEM_ID  = IA.ITEM_ID
                                  AND XC.KEY_DATE        = (SELECT MAX(XB.KEY_DATE)
                                                              FROM SCM_MST_BOM_ENG_SN XB
                                                             WHERE XB.PARENT_ITEM_ID = IA.ITEM_ID
                                                               AND XB.DIVISION_ID    = P_DIVISION_ID)
                                  AND XC.EFF_END_DATE   >= SYSDATE
                                  AND XC.DIVISION_ID     = P_DIVISION_ID)     /* 최신 KEY_DATE 기준 BOM 존재 - AJS 20261007 속도 */
               ) IB
         GROUP BY IB.DIVISION_ID
                , IB.SCM_SITE_ID
                , IB.PROJECT_CODE
                , IB.MODEL_ID
                , IB.TOT_CNT;

        /* AS-IS #TblDynamicPivot_SCP0006_Inactive                                                      */
        /* AS-IS FN_GET_SCP_ITEM_INACTIVE 는 두 번째 인자(ITEM)를 받기만 하고 조건에 쓰지 않는다.          */
        /* 전환된 Oracle 함수는 ITEM 을 정확일치로 걸러 목록(쉼표) 입력에서 제외가 풀리므로 NULL 로 부른다. */
        /* AJS 20261007 속도 : 사업부 품목 전체를 읽는 공용 함수 적재 대신, 아래 GT_0006_DATA 의 제외 조건에서                   */
        /*                     같은 판정(사용 품목군 · ACTIVE_FLAG N 행만 있고 Y 행은 없는 품목)을 조회 품목마다 확인한다        */
--      INSERT INTO GT_0006_INACTIVE
--           ( DIVISION_ID
--           , ITEM_ID
--           , ACTIVE_FLAG )
--      SELECT A.DIVISION_ID
--           , A.ITEM_ID
--           , A.ACTIVE_FLAG
--        FROM TABLE(FN_GET_SCP_ITEM_INACTIVE(P_DIVISION_ID, NULL)) A;

        /* AS-IS #TblDynamicPivot_SCP0006_02 (E20260713-000141 : PROJECT_CODE 를 받아 둔다) */
        INSERT INTO GT_0006_DATA
             ( DIVISION_ID
             , DIVISION_NAME
             , SCM_SITE_ID
             , PROJECT_CODE
             , ITEM_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS
             , MONTH
             , QTY
             , NO_DEMAND )
        SELECT IA.DIVISION_ID
--           , FN_GET_DIVISION_NAME(IA.DIVISION_ID) AS DIVISION_NAME
             , (SELECT FN_GET_DIVISION_NAME(IA.DIVISION_ID) FROM DUAL) AS DIVISION_NAME   /* AJS 20261007 속도 */
             , '-' AS SCM_SITE_ID
             , IA.PROJECT_CODE
             , IA.ITEM_ID
             , CASE WHEN B.PLANT_PER_ITEM IS NULL THEN 'BOM Not Exists'
                    ELSE B.PLANT_PER_ITEM
               END AS PLANT_PER_ITEM
             , NVL(B.CMPLTD_STATUS, 'N') AS CMPLTD_STATUS
             , SUBSTR(IA.YYYYMMDD, 1, 6) AS MONTH
             , IA.QTY
             , 0 AS NO_DEMAND                                                    /* E20260713-000141 */
--        FROM (SELECT DISTINCT
          FROM (SELECT /*+ LEADING(A) INDEX(A) USE_NL(B) INDEX(B PK_SCM_ITEM_M) */ DISTINCT   /* AJS 20261007 속도 : MKT FCST 인덱스 읽기, 품목 원장은 품목별 인덱스 */
                       A.DIVISION_ID
                     , A.PROJECT_CODE
                     , A.SCM_SITE_ID
                     , A.ITEM_ID
                     , A.DOM_EXP
                     , A.FCST_TYPE
                     , A.INCOTERMS
                     , A.MEASURE
                     , A.PLANT_SITE_ID
                     , A.YYYYMMDD
                     , A.QTY
                  FROM DM_PLN_MKT_FCST A
                     , SCM_MST_ITEM_SN B
                     , (SELECT DIVISION_ID
                             , SCM_SITE_ID
                             , OPERATION_GROUP
                             , VMI_YN
                          FROM SCM_MST_SITE
                         WHERE VMI_YN = 'Y'
                            OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W')
                       ) XA
                 WHERE A.DIVISION_ID      = B.DIVISION_ID
                   AND A.ITEM_ID          = B.ITEM_ID
                   AND XA.DIVISION_ID(+)  = A.DIVISION_ID
                   AND XA.SCM_SITE_ID(+)  = A.SCM_SITE_ID
                   AND A.MEASURE          = CASE WHEN XA.OPERATION_GROUP = 'W'     THEN 'AS_In_Req'
                                                 WHEN XA.VMI_YN = 'Y'              THEN 'VMI_In_Req'
                                                 WHEN RTRIM(A.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                            END
                   AND A.MEASURE         IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST')     /* 바깥 조건(IA.MEASURE IN)과 같은 목록 - 인덱스 조건 */ /* AJS 20261007 속도 */
                   AND B.SCP_OPERATION_GROUP_ID <> 'E'
                   AND A.QTY              > 0
                   AND A.YYYYMMDD IS NOT NULL
                   AND A.YYYYMMDD        >= V_FROM_YYYYMMDD
                   AND A.YYYYMMDD        <= V_TO_YYYYMMDD
                   AND A.DIVISION_ID      = P_DIVISION_ID
                   AND (V_ITEM_ALL = 'Y' OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                 UNION ALL
                /* [PJ2025-50188] 매출실적 CELL_PROD_SITE_ID 추가 (DISTINCT 제거, GROUP BY 에 의해 SUM(QTY) 처리) */
                SELECT C.DIVISION_ID
                     , C.PROJECT_CODE
                     , C.SCM_SITE_ID
                     , C.ITEM_ID
                     , C.DOM_EXP
                     , C.FCST_TYPE
                     , C.INCOTERMS
                     , C.MEASURE
                     , C.PLANT_SITE_ID
                     , C.YYYYMMDD
                     , SUM(C.QTY) AS QTY
                  FROM DM_PLN_MKT_FCST_RESULT C
                     , SCM_MST_ITEM_SN D
                     , (SELECT DIVISION_ID
                             , SCM_SITE_ID
                             , OPERATION_GROUP
                             , VMI_YN
                          FROM SCM_MST_SITE
                         WHERE VMI_YN = 'Y'
                            OR (SITE_TYPE = 'SALES' AND OPERATION_GROUP = 'W')
                       ) XB
                 WHERE C.DIVISION_ID      = D.DIVISION_ID
                   AND C.ITEM_ID          = D.ITEM_ID
                   AND XB.DIVISION_ID(+)  = C.DIVISION_ID
                   AND XB.SCM_SITE_ID(+)  = C.SCM_SITE_ID
                   /* AS-IS 는 IIF 조건과 CASE 조건을 둘 다 건다 (결과는 CASE 조건과 같다) */
                   AND C.MEASURE          = CASE WHEN XB.OPERATION_GROUP = 'W' THEN 'AS_In_Req'
                                                 WHEN XB.VMI_YN = 'Y'          THEN 'VMI_In_Req'
                                                 ELSE 'MKT_FCST'
                                            END
                   AND C.MEASURE          = CASE WHEN XB.OPERATION_GROUP = 'W'     THEN 'AS_In_Req'
                                                 WHEN XB.VMI_YN = 'Y'              THEN 'VMI_In_Req'
                                                 WHEN RTRIM(C.ATTRIBUTE10) IS NULL THEN 'MKT_FCST'
                                            END
                   AND D.SCP_OPERATION_GROUP_ID <> 'E'
                   AND C.QTY              > 0
                   AND C.YYYYMMDD IS NOT NULL
                   AND C.YYYYMMDD        >= V_FROM_RESULT
                   AND C.YYYYMMDD        <= V_TO_RESULT
                   AND C.DIVISION_ID      = P_DIVISION_ID
                   AND (V_ITEM_ALL = 'Y' OR C.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))
                 GROUP BY C.DIVISION_ID
                        , C.PROJECT_CODE
                        , C.SCM_SITE_ID
                        , C.ITEM_ID
                        , C.DOM_EXP
                        , C.FCST_TYPE
                        , C.INCOTERMS
                        , C.MEASURE
                        , C.PLANT_SITE_ID
                        , C.YYYYMMDD
               ) IA
             , GT_0006_CNT B
             , (SELECT F.DIVISION_ID
                     , F.ITEM_ID
                     , ROW_NUMBER() OVER (PARTITION BY F.DIVISION_ID, F.ITEM_ID
                                              ORDER BY CASE F.ITEM_TYPE WHEN 'P' THEN 999
                                                                        WHEN 'H' THEN 888
                                                                        WHEN 'R' THEN 777
                                                                        WHEN 'Q' THEN 666
                                                                        ELSE 0
                                                       END DESC) AS NUMS
                  FROM SCM_MST_ITEM_SN F
-- 2026.09.23 AJS 성능 - 아이템 원장 전건(78.9만행) 읽기를 사업부 범위로 축소. 바깥 조인조건에서 파생되는 필터라 결과는 같다 (START)
                 WHERE F.DIVISION_ID = P_DIVISION_ID
-- 2026.09.23 AJS 성능 - 사업부 한정 (END)
               ) IB
         WHERE IA.DIVISION_ID     = B.DIVISION_ID(+)
           AND IA.ITEM_ID         = B.MODEL_ID(+)
           AND IA.DIVISION_ID     = IB.DIVISION_ID
           AND IA.ITEM_ID         = IB.ITEM_ID
--         AND NOT EXISTS (SELECT 1
--                           FROM GT_0006_INACTIVE XW
--                          WHERE XW.ITEM_ID = IA.ITEM_ID)
           AND NOT EXISTS (SELECT /*+ NO_UNNEST */                                    /* AJS 20261007 속도 : FN_GET_SCP_ITEM_INACTIVE 와 같은 판정 */
                                  1
                             FROM SCM_MST_ITEM_SN       XW
                                , SCM_MST_ITEM_CLASS_SN XV
                            WHERE XV.CLASS_ID     = XW.ITEM_CLASS
                              AND XW.ITEM_ID      = IA.ITEM_ID
                              AND XV.USE_FLAG     = 'Y'
                              AND XW.ACTIVE_FLAG  = 'N'
                              AND XW.DIVISION_ID  = P_DIVISION_ID
                              AND NOT EXISTS (SELECT 1
                                                FROM SCM_MST_ITEM_SN       XU
                                                   , SCM_MST_ITEM_CLASS_SN XT
                                               WHERE XT.CLASS_ID     = XU.ITEM_CLASS
                                                 AND XU.ITEM_ID      = XW.ITEM_ID
                                                 AND XT.USE_FLAG     = 'Y'
                                                 AND XU.ACTIVE_FLAG  = 'Y'
                                                 AND XU.DIVISION_ID  = P_DIVISION_ID))
           AND IB.NUMS            = 1
           AND IA.MEASURE        IN ('AS_In_Req', 'VMI_In_Req', 'MKT_FCST');
           -- 2026.09.28 KBJ Project Route Status 조회조건 미작동 수정;

        /* E20260713-000141 신규로직 시작 - 수요 없는 모델 (AS-IS #TblDynamicPivot_SCP0006_04) */
        INSERT INTO GT_0006_NO_DEMAND
             ( DIVISION_ID
             , ITEM_ID
             , PROJECT_CODE )
        SELECT A.SEGMENT2 AS DIVISION_ID
             , A.SEGMENT3 AS ITEM_ID
             , A.SEGMENT5 AS PROJECT_CODE
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
         WHERE EXISTS (SELECT 1
                         FROM GT_0006_DATA XA
                        WHERE A.SEGMENT2              = XA.DIVISION_ID
                          AND SUBSTR(A.SEGMENT3, 1, 12) = SUBSTR(XA.ITEM_ID, 1, 12)
                          AND A.SEGMENT5              = XA.PROJECT_CODE
                          AND A.SEGMENT3             <> XA.ITEM_ID)
           AND NOT EXISTS (SELECT 1
                             FROM GT_0006_DATA XB
                            WHERE XB.DIVISION_ID = A.SEGMENT2
                              AND XB.ITEM_ID     = A.SEGMENT3)
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
           AND A.VALID_YN    = 'Y';

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_NO_DEMAND', NO_INVALIDATE => FALSE);

        /* project 매핑을 위해 상단에 project code 받아온것 다시 '-' 로 group 처리. */
        INSERT INTO GT_0006_PIVOT
             ( DIVISION_ID
             , DIVISION_NAME
             , SCM_SITE_ID
             , PROJECT_CODE
             , ITEM_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS
             , MONTH
             , QTY
             , NO_DEMAND )
        SELECT DIVISION_ID
             , DIVISION_NAME
             , '-' AS SCM_SITE_ID
             , '-' AS PROJECT_CODE
             , ITEM_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS
             , MONTH
             , SUM(QTY) AS QTY
             , NO_DEMAND
          FROM GT_0006_DATA
         GROUP BY DIVISION_ID
                , DIVISION_NAME
                , ITEM_ID
                , PLANT_PER_ITEM
                , CMPLTD_STATUS
                , MONTH
                , NO_DEMAND;

        INSERT INTO GT_0006_CNT
             ( DIVISION_ID
             , SCM_SITE_ID
             , PROJECT_CODE
             , MODEL_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS )
        SELECT IB.DIVISION_ID
             , IB.SCM_SITE_ID
             , IB.PROJECT_CODE
             , IB.MODEL_ID
             , TO_CHAR(SUM(IB.PLANT_CNT)) || '/' || TO_CHAR(IB.TOT_CNT) AS PLANT_PER_ITEM
             , CASE WHEN SUM(IB.PLANT_CNT) = IB.TOT_CNT THEN 'Y'
                    ELSE 'N'
               END AS CMPLTD_STATUS
          FROM (SELECT IA.DIVISION_ID
                     , '-' AS SCM_SITE_ID
                     , '-' AS PROJECT_CODE
                     , IA.MODEL_ID
                     , COUNT(*) OVER (PARTITION BY IA.DIVISION_ID, IA.MODEL_ID) AS TOT_CNT
                     , CASE WHEN IA.PRIMARY_PLANT IS NOT NULL THEN 1
                            ELSE 0
                       END AS PLANT_CNT
--                FROM (SELECT DISTINCT
                  FROM (SELECT /*+ LEADING(A B D) USE_HASH(D) */ DISTINCT                  /* AJS 20261007 속도 : 최종 품목 사본을 먼저 붙여 품목 원장 조회 건수 축소 */
                               CASE WHEN (SELECT FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) FROM DUAL) = 'E' THEN C.ITEM_ID
                                    ELSE B.MODEL_ID
                               END AS MODEL_ID
                             , CASE /* 전극 제외 20180517 */
                                    WHEN D.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                    WHEN D.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                               END AS OPERATION_GROUP_ID
                             , D.ELECTRODE_TYPE
                             , B.CHILD_ITEM_ID AS ITEM_ID
--                           , CASE WHEN EXISTS (SELECT 1
--                                                 FROM SCM_MST_SITE_ITEM_PRIORITY XA
--                                                WHERE XA.DIVISION_ID   = B.DIVISION_ID
--                                                  AND XA.ITEM_ID       = B.CHILD_ITEM_ID
--                                                  AND XA.VALID_YN      = 'Y'
--                                                  AND XA.PRIORITY      = 1
--                                                  AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')) THEN 1
--                             END AS PRIMARY_PLANT
                             , CASE WHEN IE.ITEM_ID IS NOT NULL THEN 1 /* AJS 20261007 속도 */
                               END AS PRIMARY_PLANT /* AJS 20261007 속도 */
                             , B.DIVISION_ID
                          FROM GT_0006_NO_DEMAND A
                             , SCM_MST_BOM_SN_V B
                             , SCM_MST_ITEM_SN C
                             , GT_0006_FINAL_ITEM D            /* SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                             , (SELECT DISTINCT /* AJS 20261007 속도 */
                                       XA.DIVISION_ID
                                     , XA.ITEM_ID
                                  FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                 WHERE XA.VALID_YN      = 'Y'
                                   AND XA.PRIORITY      = 1
                                   AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                                   AND XA.DIVISION_ID   = P_DIVISION_ID
                               ) IE                          /* 우선순위 1 생산지 (사업부 한정 한 번 읽기) - AJS 20261007 속도 */
                         WHERE A.DIVISION_ID    = B.DIVISION_ID
                           AND A.ITEM_ID        = B.MODEL_ID
                           AND B.COMPANY_ID     = C.COMPANY_ID
                           AND B.DIVISION_ID    = C.DIVISION_ID
                           AND B.SITE_ID        = C.SITE_ID
                           AND B.CHILD_ITEM_ID  = C.ITEM_ID
                           AND B.DIVISION_ID    = D.DIVISION_ID
                           AND B.CHILD_ITEM_ID  = D.ITEM_ID
                           AND IE.DIVISION_ID(+)  = B.DIVISION_ID /* AJS 20261007 속도 */
                           AND IE.ITEM_ID(+)      = B.CHILD_ITEM_ID /* AJS 20261007 속도 */
                           AND D.OPERATION_GROUP_ID <> 'E'
                       ) IA
               ) IB
         GROUP BY IB.DIVISION_ID
                , IB.SCM_SITE_ID
                , IB.PROJECT_CODE
                , IB.MODEL_ID
                , IB.TOT_CNT;

        /* AS-IS 는 LEFT JOIN 의 ON 에 NOT EXISTS(#02 의 같은 DIVISION·ITEM) 를 두나, #04 를 만들 때 같은 */
        /* 조건으로 이미 걸렀고 #02 재집계는 DIVISION·ITEM 조합을 바꾸지 않아 항상 참이므로 옮기지 않는다. */
        INSERT INTO GT_0006_PIVOT
             ( DIVISION_ID
             , DIVISION_NAME
             , SCM_SITE_ID
             , PROJECT_CODE
             , ITEM_ID
             , PLANT_PER_ITEM
             , CMPLTD_STATUS
             , MONTH
             , QTY
             , NO_DEMAND )
        SELECT A.DIVISION_ID
             , FN_GET_DIVISION_NAME(A.DIVISION_ID) AS DIVISION_NAME
             , '-' AS SCM_SITE_ID
             , '-' AS PROJECT_CODE
             , A.ITEM_ID
             , CASE WHEN B.PLANT_PER_ITEM IS NULL THEN 'BOM Not Exists'
                    ELSE B.PLANT_PER_ITEM
               END AS PLANT_PER_ITEM
             , NVL(B.CMPLTD_STATUS, 'N') AS CMPLTD_STATUS
             , SUBSTR(V_P_FROM_YYYYMMDD, 1, 6) AS MONTH
             , NULL AS QTY
             , 1 AS NO_DEMAND
          FROM GT_0006_NO_DEMAND A
             , GT_0006_CNT B
         WHERE A.DIVISION_ID = B.DIVISION_ID(+)
           AND A.ITEM_ID     = B.MODEL_ID(+)
         GROUP BY A.DIVISION_ID
                , A.ITEM_ID
                , B.PLANT_PER_ITEM
                , B.CMPLTD_STATUS;
        /* E20260713-000141 신규로직 끝 */
        
        -- 일반 데이터와 무수요 모델을 모두 구성한 뒤 Status 적용 2026-09-28
		IF V_STATUS_ALL <> 'Y' THEN
		    DELETE FROM GT_0006_PIVOT P
		     WHERE NOT EXISTS (
		         SELECT 1
		           FROM TABLE(V_STATUS_TAB) S
		          WHERE S.COLUMN_VALUE = NVL(P.CMPLTD_STATUS, 'N')
		     );
		END IF;

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_PIVOT', NO_INVALIDATE => FALSE);

        /* PIVOT 쿼리 실행 */
        P_MAKE_PIVOT_SQL(V_FROM_YYYYMMDD, V_TO_YYYYMMDD, 'Y', V_SQL);

        IF P_DEBUG_MODE = 'T' THEN
            P_PUT_CLOB(V_SQL);
        END IF;

        OPEN O_RC1 FOR V_SQL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0006_GET_PROJECT_ROUTE_SITE_82'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_ITEM_ID=' || P_ITEM_ID
                     || ', P_FROM_YYYYMM=' || P_FROM_YYYYMM
                     || ', P_TO_YYYYMM=' || P_TO_YYYYMM
                     || ', P_STATUS=' || P_STATUS
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0006_GET_PROJECT_ROUTE_SITE_82;


    /* ------------------------------------------------------------
       GROUP Model Mapping 정보에 의한 Model 전부 가져오기 (BOM · BOM_82 공통, 2024.06.05 mrchois)
       - GROUP_ID 가 있으면 같은 그룹 ITEM 전부, 없으면 입력 모델 목록
       - O_ALL = 'Y' : 모델 조건을 걸지 않음 (AS-IS @v_model_id 가 빈 값)
       ------------------------------------------------------------ */
    PROCEDURE P_GET_GROUP_MODEL
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_MODEL_ID        IN  VARCHAR2,
        P_PROJECT_CODE    IN  VARCHAR2,
        O_TAB             OUT T_STR_TAB,
        O_ALL             OUT VARCHAR2
    )
    IS
        V_GROUP_ID        VARCHAR2(4000 CHAR);
    BEGIN

        BEGIN
            SELECT GROUP_ID
              INTO V_GROUP_ID
              FROM SCP_MST_ITEM_GROUP_DETAIL
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND PROJECT_CODE = P_PROJECT_CODE
               AND ITEM_ID      = P_MODEL_ID
               AND ROWNUM       = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_GROUP_ID := NULL;
        END;

        /* GROUP_ID 가 있는 경우 */
        IF NVL(LENGTH(RTRIM(V_GROUP_ID)), 0) > 0 THEN
            O_ALL := 'N';

            SELECT TRIM(ITEM_ID)
              BULK COLLECT INTO O_TAB
              FROM SCP_MST_ITEM_GROUP_DETAIL
             WHERE DIVISION_ID  = P_DIVISION_ID
               AND PROJECT_CODE = P_PROJECT_CODE
               AND GROUP_ID     = V_GROUP_ID;
        ELSE
            P_SPLIT_LIST(P_MODEL_ID, O_TAB, O_ALL);
        END IF;

    END P_GET_GROUP_MODEL;


    /*==================================================================================================
     * Program ID   : SCP0006_GET_PROJECT_ROUTE_BOM
     * Description  : Project Route BOM 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2017/12/28   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/03/26   PJS            Sales Site 추가
     * 2018/05/03   byunghunjung   Alternate Part 제외로직 추가
     * 2018/05/17   byunghunjung   전극 제외
     * 2018/05/24   byunghunjung   ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
     * 2018/06/21   byunghunjung   BOM을 제거모델 조회안되도록 수정
     * 2018/09/14   byunghunjung   Item Type = R 도 보이도록 수정
     * 2019/03/26   KSG            [재료본부 전지재료 GSCM 구축 프로젝트] 재료 operation_group 표시 추가 (190415 전지재료 삭제)
     * 2021/03/30   PJG            대체 BOM 모델링 적용
     * 2022/01/20   VADABI3        BOM Explosion > Sort 우선 순위 적용 > P (DC_LINK) ->  P(NOT DC_LINK) -> A -> E
     * 2023/06/07   chaan          V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
     * 2023/07/26   chaan          V1.1.2  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - CA1/CA2 정렬순서 변경(CA2우선)
     * 2024/06/05   mrchois        PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
     * 2026/09/14                  MSSQL -> Oracle 전환
     *                             정렬 : MSSQL 정렬규칙(대소문자 무시·하이픈 무시·밑줄 우선·NULL 앞) 에 맞춘 정렬키 사용
     * 2026/09/17   AJS            40 · 82 사업부는 _82 로직 수행 (화면 단일 호출 대응)
     * 2026.10.07   AJS          조회 속도 개선 : 모델 지정 시 품목 사본(GT_0006_FINAL_ITEM)을 선택 모델의 BOM 하위 품목으로 한정, 엔지니어링 BOM 확인을 AS-IS 와 같은 상관 EXISTS 로
     */
    PROCEDURE P_SCP0006_GET_PROJECT_ROUTE_BOM
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_SCM_SITE_ID     IN  VARCHAR2,
        P_MODEL_ID        IN  VARCHAR2,
        P_PROJECT_CODE    IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CODE     OUT VARCHAR2,
        O_RESULT_MSG      OUT VARCHAR2
    )
    IS
        V_MODEL_TAB       T_STR_TAB;
        V_MODEL_ALL       VARCHAR2(1 CHAR);
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        -- 2026.09.17 AJS 40 · 82 사업부는 _82 로직 수행 - 화면은 사업부 구분 없이 이 프로시저 하나만 호출 (START)
        IF P_DIVISION_ID IN ('82', '40') THEN
            P_SCP0006_GET_PROJECT_ROUTE_BOM_82(P_DIVISION_ID, P_SCM_SITE_ID, P_MODEL_ID, P_PROJECT_CODE
                                             , O_RC1, O_RESULT_CODE, O_RESULT_MSG);
            RETURN;
        END IF;
        -- 2026.09.17 AJS 40 · 82 사업부는 _82 로직 수행 - 화면은 사업부 구분 없이 이 프로시저 하나만 호출 (END)

        P_GET_GROUP_MODEL(P_DIVISION_ID, P_MODEL_ID, P_PROJECT_CODE, V_MODEL_TAB, V_MODEL_ALL);

-- 2026.09.23 AJS 성능 - 최종아이템 뷰(UNION 4 벌 · 하위 뷰 UNION 8 벌)를 조인에서 직접 펼치면 아이템 원장을 여러 번 훑는다.
--                      Site 갈래와 같이 사업부 한정 사본을 한 번만 받아 쓴다 (START)
        DELETE FROM GT_0006_FINAL_ITEM;

-- 2026.10.07 AJS 속도 개선 - 모델을 지정하면 품목 사본을 그 모델의 BOM 하위 품목으로 한정 (START)
        IF V_MODEL_ALL = 'N' THEN
            /* 아래 조회문은 사본을 Sales Site · Project 에 등록된 선택 모델의 BOM 하위 품목(A.CHILD_ITEM_ID)으로만 조인하므로 그 품목만 받아도 결과 동일 */
            /* 모델 목록 조건은 MEMBER OF 로 쓴다 (IN 하위질의 · 목록 조인이면 품목 뷰에 품목 조건이 들어가지 않는다) */
            INSERT INTO GT_0006_FINAL_ITEM
                 ( DIVISION_ID
                 , ITEM_ID
                 , OPERATION_GROUP_ID
                 , ELECTRODE_TYPE
                 , DC_YN
                 , RACK_YN
                 , CELL_TYPE )
            SELECT /*+ LEADING(XA) USE_NL(B) PUSH_PRED(B) */
                   B.DIVISION_ID
                 , B.ITEM_ID
                 , B.OPERATION_GROUP_ID
                 , B.ELECTRODE_TYPE
                 , B.DC_YN
                 , B.RACK_YN
                 , B.CELL_TYPE
              FROM (SELECT DISTINCT
                           A.CHILD_ITEM_ID
                      FROM SCM_MST_SITE_ITEM C
                         , SCM_MST_BOM_SN_V A
                     WHERE A.DIVISION_ID  = C.DIVISION_ID
                       AND A.MODEL_ID     = C.ITEM_ID
                       AND C.PROJECT_CODE = P_PROJECT_CODE
                       AND C.SCM_SITE_ID  = P_SCM_SITE_ID
                       AND C.DIVISION_ID  = P_DIVISION_ID
                       AND A.MODEL_ID MEMBER OF V_MODEL_TAB
                   ) XA
                 , SCM_MST_FINAL_ITEM_V B
             WHERE B.ITEM_ID     = XA.CHILD_ITEM_ID
               AND B.DIVISION_ID = P_DIVISION_ID;
        ELSE
        INSERT INTO GT_0006_FINAL_ITEM
             ( DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN
             , RACK_YN
             , CELL_TYPE )
        SELECT DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN
             , RACK_YN
             , CELL_TYPE
          FROM SCM_MST_FINAL_ITEM_V
         WHERE DIVISION_ID = P_DIVISION_ID;
        END IF;
-- 2026.10.07 AJS 속도 개선 (END)

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_FINAL_ITEM', NO_INVALIDATE => FALSE);
-- 2026.09.23 AJS 성능 - 최종아이템 사본 적재 (END)

-- 2026.10.07 AJS 속도 개선 - 모델 지정 시 엔지니어링 BOM 최신 KEY_DATE 확인을 사업부 전체 분석함수 대신 AS-IS 와 같은 품목별 상관 EXISTS 로 (START)
        IF V_MODEL_ALL = 'N' THEN
            OPEN O_RC1 FOR
                SELECT IB.OPERATION_GROUP
                     , IB.OPERATION_GROUP_ID
                     , IB.ELECTRODE_TYPE
                     , IB.ITEM_ID
                     , IB.ITEM_NAME
                     , IB.PRIMARY_PLANT
                     , IB.DIVISION_ID
                     , IB.SCM_SITE_ID
                     , IB.PROJECT_CODE
                     , IB.MODEL_ID
                     , IB.DISPLAY_SEQ
                     , MAX(IB.ALT_PRIORITY) AS ALT_PRIORITY
                     , IB.DC_YN
                     , IB.RACK_YN
                     , IB.CELL_TYPE
                     , IB.CEL_TYPE_DISPLAY_SEQ
                  FROM (SELECT DISTINCT
                               CASE /* 전극 제외 20180517 */
                                    WHEN E.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                    WHEN E.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                               END AS OPERATION_GROUP
                             , E.OPERATION_GROUP_ID
                             , E.ELECTRODE_TYPE
                             , A.CHILD_ITEM_ID AS ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.CHILD_ITEM_ID) AS ITEM_NAME
                             , (SELECT MAX(XB.SITE_DESCRIPTION) KEEP (DENSE_RANK FIRST ORDER BY XA.FROM_YYYYMMDD)
                                  FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                     , SCM_MST_SITE XB
                                 WHERE XA.DIVISION_ID   = XB.DIVISION_ID
                                   AND XA.PLANT_SITE_ID = XB.SCM_SITE_ID
                                   AND XA.DIVISION_ID   = A.DIVISION_ID
                                   AND XA.SALES_SITE_ID = C.SCM_SITE_ID          /* 20180326 SALES SITE 추가부분 */
                                   AND XA.ITEM_ID       = A.CHILD_ITEM_ID
                                   AND XA.PROJECT_CODE  = C.PROJECT_CODE
                                   AND XA.VALID_YN      = 'Y'
                                   AND XA.PRIORITY      = 1
                                   AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                               ) AS PRIMARY_PLANT
                             , A.DIVISION_ID
                             , C.SCM_SITE_ID                                     /* 20180326 SALES SITE 추가부분 */
                             , C.PROJECT_CODE
                             , A.MODEL_ID                                        /* 화면 정렬 순서를 위해 추가 */
                             , F.DISPLAY_SEQ
                             , A.ALT_PRIORITY
                             , E.DC_YN
                             , E.RACK_YN
                             , E.CELL_TYPE                                       /* 활성화코드 분리->Cell Assy Type */
                             , CASE WHEN RTRIM(E.CELL_TYPE) IS NULL THEN 0
                                    WHEN E.CELL_TYPE = 'CP'  THEN 1
                                    WHEN E.CELL_TYPE = 'CA2' THEN 2
                                    WHEN E.CELL_TYPE = 'CA1' THEN 3
                                    ELSE 4
                               END AS CEL_TYPE_DISPLAY_SEQ
                          FROM SCM_MST_BOM_SN_V A                                /* 2021.03.25 대체 BOM 모델링 */
                             , SCM_MST_ITEM_SN B
                             , SCM_MST_SITE_ITEM C
                             , GT_0006_FINAL_ITEM E                       /* 2026.09.23 AJS 성능 - SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                             , SCM_ADM_LOOKUP_MASTER_DETAIL F
                         WHERE A.COMPANY_ID     = B.COMPANY_ID
                           AND A.DIVISION_ID    = B.DIVISION_ID
                           AND A.SITE_ID        = B.SITE_ID
                           AND A.CHILD_ITEM_ID  = B.ITEM_ID
                           AND A.DIVISION_ID    = C.DIVISION_ID
                           AND A.MODEL_ID       = C.ITEM_ID
                           AND A.DIVISION_ID    = E.DIVISION_ID
                           AND A.CHILD_ITEM_ID  = E.ITEM_ID
                           AND F.SEGMENT1       = E.OPERATION_GROUP_ID
                           AND EXISTS (SELECT 1
                                         FROM SCM_MST_BOM_ENG_SN XC
                                        WHERE XC.PARENT_ITEM_ID  = A.CHILD_ITEM_ID
                                          AND XC.KEY_DATE        = (SELECT MAX(XD.KEY_DATE)
                                                                      FROM SCM_MST_BOM_ENG_SN XD
                                                                     WHERE XD.PARENT_ITEM_ID = A.CHILD_ITEM_ID
                                                                       AND XD.DIVISION_ID    = P_DIVISION_ID)
                                          AND XC.EFF_END_DATE   >= SYSDATE
                                          AND XC.DIVISION_ID     = P_DIVISION_ID)     /* 최신 KEY_DATE 기준 BOM 존재 (AS-IS 상관 EXISTS + MAX) */
                           AND F.LOOKUP_TYPE    = 'OPERATION_GROUP'
                           AND E.OPERATION_GROUP_ID <> 'E'
                           AND C.PROJECT_CODE   = P_PROJECT_CODE
                           AND C.SCM_SITE_ID    = P_SCM_SITE_ID                  /* 20180326 sales site추가 */
                           AND A.DIVISION_ID    = P_DIVISION_ID
                           AND (V_MODEL_ALL = 'Y' OR A.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_MODEL_TAB)))
                       ) IB
                 GROUP BY IB.OPERATION_GROUP
                        , IB.OPERATION_GROUP_ID
                        , IB.ELECTRODE_TYPE
                        , IB.ITEM_ID
                        , IB.ITEM_NAME
                        , IB.PRIMARY_PLANT
                        , IB.DIVISION_ID
                        , IB.SCM_SITE_ID
                        , IB.PROJECT_CODE
                        , IB.MODEL_ID
                        , IB.DISPLAY_SEQ
                        , IB.DC_YN
                        , IB.RACK_YN
                        , IB.CELL_TYPE
                        , IB.CEL_TYPE_DISPLAY_SEQ
                 /* Sort 정책 : rack_yn DESC → DC_YN DESC → Primary Plant 유무 → Model → display_seq → Cell Type → item_id */
                 ORDER BY UPPER(IB.RACK_YN) DESC NULLS LAST
                        , UPPER(IB.DC_YN) DESC NULLS LAST
                        , CASE WHEN RTRIM(IB.PRIMARY_PLANT) IS NULL THEN 1
                               ELSE 0
                          END
                        , REPLACE(REPLACE(UPPER(IB.MODEL_ID), '-', ''), '_', CHR(1)) NULLS FIRST
                        , IB.DISPLAY_SEQ NULLS FIRST
                        , IB.CEL_TYPE_DISPLAY_SEQ
                        , REPLACE(REPLACE(UPPER(IB.ITEM_ID), '-', ''), '_', CHR(1)) NULLS FIRST;
        ELSE
        OPEN O_RC1 FOR
            SELECT IB.OPERATION_GROUP
                 , IB.OPERATION_GROUP_ID
                 , IB.ELECTRODE_TYPE
                 , IB.ITEM_ID
                 , IB.ITEM_NAME
                 , IB.PRIMARY_PLANT
                 , IB.DIVISION_ID
                 , IB.SCM_SITE_ID
                 , IB.PROJECT_CODE
                 , IB.MODEL_ID
                 , IB.DISPLAY_SEQ
                 , MAX(IB.ALT_PRIORITY) AS ALT_PRIORITY
                 , IB.DC_YN
                 , IB.RACK_YN
                 , IB.CELL_TYPE
                 , IB.CEL_TYPE_DISPLAY_SEQ
              FROM (SELECT DISTINCT
                           CASE /* 전극 제외 20180517 */
                                WHEN E.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                WHEN E.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                           END AS OPERATION_GROUP
                         , E.OPERATION_GROUP_ID
                         , E.ELECTRODE_TYPE
                         , A.CHILD_ITEM_ID AS ITEM_ID
                         , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.CHILD_ITEM_ID) AS ITEM_NAME
                         , (SELECT MAX(XB.SITE_DESCRIPTION) KEEP (DENSE_RANK FIRST ORDER BY XA.FROM_YYYYMMDD)
                              FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                 , SCM_MST_SITE XB
                             WHERE XA.DIVISION_ID   = XB.DIVISION_ID
                               AND XA.PLANT_SITE_ID = XB.SCM_SITE_ID
                               AND XA.DIVISION_ID   = A.DIVISION_ID
                               AND XA.SALES_SITE_ID = C.SCM_SITE_ID          /* 20180326 SALES SITE 추가부분 */
                               AND XA.ITEM_ID       = A.CHILD_ITEM_ID
                               AND XA.PROJECT_CODE  = C.PROJECT_CODE
                               AND XA.VALID_YN      = 'Y'
                               AND XA.PRIORITY      = 1
                               AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                           ) AS PRIMARY_PLANT
                         , A.DIVISION_ID
                         , C.SCM_SITE_ID                                     /* 20180326 SALES SITE 추가부분 */
                         , C.PROJECT_CODE
                         , A.MODEL_ID                                        /* 화면 정렬 순서를 위해 추가 */
                         , F.DISPLAY_SEQ
                         , A.ALT_PRIORITY
                         , E.DC_YN
                         , E.RACK_YN
                         , E.CELL_TYPE                                       /* 활성화코드 분리->Cell Assy Type */
                         , CASE WHEN RTRIM(E.CELL_TYPE) IS NULL THEN 0
                                WHEN E.CELL_TYPE = 'CP'  THEN 1
                                WHEN E.CELL_TYPE = 'CA2' THEN 2
                                WHEN E.CELL_TYPE = 'CA1' THEN 3
                                ELSE 4
                           END AS CEL_TYPE_DISPLAY_SEQ
                      FROM SCM_MST_BOM_SN_V A                                /* 2021.03.25 대체 BOM 모델링 */
                         , SCM_MST_ITEM_SN B
                         , SCM_MST_SITE_ITEM C
                         , GT_0006_FINAL_ITEM E                       /* 2026.09.23 AJS 성능 - SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                         , SCM_ADM_LOOKUP_MASTER_DETAIL F
                     WHERE A.COMPANY_ID     = B.COMPANY_ID
                       AND A.DIVISION_ID    = B.DIVISION_ID
                       AND A.SITE_ID        = B.SITE_ID
                       AND A.CHILD_ITEM_ID  = B.ITEM_ID
                       AND A.DIVISION_ID    = C.DIVISION_ID
                       AND A.MODEL_ID       = C.ITEM_ID
                       AND A.DIVISION_ID    = E.DIVISION_ID
                       AND A.CHILD_ITEM_ID  = E.ITEM_ID
                       AND F.SEGMENT1       = E.OPERATION_GROUP_ID
                       AND A.CHILD_ITEM_ID IN (SELECT XD.PARENT_ITEM_ID
                                                 FROM (SELECT XC.PARENT_ITEM_ID
                                                            , XC.KEY_DATE
                                                            , XC.EFF_END_DATE
                                                            , MAX(XC.KEY_DATE) OVER (PARTITION BY XC.PARENT_ITEM_ID) AS MAX_KEY_DATE
                                                         FROM SCM_MST_BOM_ENG_SN XC
                                                        WHERE XC.DIVISION_ID = P_DIVISION_ID
                                                      ) XD
                                                WHERE XD.KEY_DATE      = XD.MAX_KEY_DATE
                                                  AND XD.EFF_END_DATE >= SYSDATE)     /* 최신 KEY_DATE 기준 BOM 존재 (AS-IS 상관 EXISTS + MAX 와 같은 결과) */
                       AND F.LOOKUP_TYPE    = 'OPERATION_GROUP'
                       AND E.OPERATION_GROUP_ID <> 'E'
                       AND C.PROJECT_CODE   = P_PROJECT_CODE
                       AND C.SCM_SITE_ID    = P_SCM_SITE_ID                  /* 20180326 sales site추가 */
                       AND A.DIVISION_ID    = P_DIVISION_ID
                       AND (V_MODEL_ALL = 'Y' OR A.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_MODEL_TAB)))
                   ) IB
             GROUP BY IB.OPERATION_GROUP
                    , IB.OPERATION_GROUP_ID
                    , IB.ELECTRODE_TYPE
                    , IB.ITEM_ID
                    , IB.ITEM_NAME
                    , IB.PRIMARY_PLANT
                    , IB.DIVISION_ID
                    , IB.SCM_SITE_ID
                    , IB.PROJECT_CODE
                    , IB.MODEL_ID
                    , IB.DISPLAY_SEQ
                    , IB.DC_YN
                    , IB.RACK_YN
                    , IB.CELL_TYPE
                    , IB.CEL_TYPE_DISPLAY_SEQ
             /* Sort 정책 : rack_yn DESC → DC_YN DESC → Primary Plant 유무 → Model → display_seq → Cell Type → item_id */
             ORDER BY UPPER(IB.RACK_YN) DESC NULLS LAST
                    , UPPER(IB.DC_YN) DESC NULLS LAST
                    , CASE WHEN RTRIM(IB.PRIMARY_PLANT) IS NULL THEN 1
                           ELSE 0
                      END
                    , REPLACE(REPLACE(UPPER(IB.MODEL_ID), '-', ''), '_', CHR(1)) NULLS FIRST
                    , IB.DISPLAY_SEQ NULLS FIRST
                    , IB.CEL_TYPE_DISPLAY_SEQ
                    , REPLACE(REPLACE(UPPER(IB.ITEM_ID), '-', ''), '_', CHR(1)) NULLS FIRST;
        END IF;
-- 2026.10.07 AJS 속도 개선 (END)

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0006_GET_PROJECT_ROUTE_BOM'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_MODEL_ID=' || P_MODEL_ID
                     || ', P_PROJECT_CODE=' || P_PROJECT_CODE
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0006_GET_PROJECT_ROUTE_BOM;


    /*==================================================================================================
     * Program ID   : SCP0006_GET_PROJECT_ROUTE_BOM_82
     * Description  : Project Route BOM 조회(division 82 전용)
     * Comments     : @p_scm_site_id,@p_project_code는 미사용 SCP0006_GET_PROJECT_ROUTE_BOM과 호환을 위해 남겨둠
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/04/10   PJS            Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/03   byunghunjung   Alternate Part 제외로직 추가
     * 2018/05/17   byunghunjung   전극 제외
     * 2018/05/24   byunghunjung   ESS 팩모델 하위의 CELL중에서 일부가 자동차전지에만 BOM에서 모ITEM으로 존재하지만,PROJECT ROUTE화면에서 ESS에 생산지를 등록하도록 표기되는 오류수정
     * 2018/06/21   byunghunjung   BOM을 제거모델 조회안되도록 수정
     * 2019/03/26   KSG            [재료본부 전지재료 GSCM 구축 프로젝트] 재료 operation_group 표시 추가 (190415 전지재료 삭제)
     * 2020/10/27   khj79          PJ20202001 LG화학 전지. 공급 대응력 향상을 위한 SCM 관리 체계 개선 : RACK
     * 2021/03/30   PJG            대체 BOM 모델링
     * 2022/01/20   VADABI3        BOM Explosion > Sort 우선 순위 적용 > P (DC_LINK) ->  P(NOT DC_LINK) -> A -> E
     * 2023/06/07   chaan          V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
     * 2023/07/26   chaan          V1.1.2  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - CA1/CA2 정렬순서 변경(CA2우선)
     * 2024/06/05   mrchois        PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성
     * 2026/09/14                  MSSQL -> Oracle 전환
     * 2026.10.07   AJS          조회 속도 개선 : 모델 지정 시 품목 사본(GT_0006_FINAL_ITEM)을 선택 모델의 BOM 하위 품목으로 한정, 엔지니어링 BOM 확인을 AS-IS 와 같은 상관 EXISTS 로
     */
    PROCEDURE P_SCP0006_GET_PROJECT_ROUTE_BOM_82
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_SCM_SITE_ID     IN  VARCHAR2,
        P_MODEL_ID        IN  VARCHAR2,
        P_PROJECT_CODE    IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RESULT_CODE     OUT VARCHAR2,
        O_RESULT_MSG      OUT VARCHAR2
    )
    IS
        V_MODEL_TAB       T_STR_TAB;
        V_MODEL_ALL       VARCHAR2(1 CHAR);
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        P_GET_GROUP_MODEL(P_DIVISION_ID, P_MODEL_ID, P_PROJECT_CODE, V_MODEL_TAB, V_MODEL_ALL);

-- 2026.09.23 AJS 성능 - 최종아이템 뷰(UNION 4 벌 · 하위 뷰 UNION 8 벌)를 조인에서 직접 펼치면 아이템 원장을 여러 번 훑는다.
--                      Site 갈래와 같이 사업부 한정 사본을 한 번만 받아 쓴다 (START)
        DELETE FROM GT_0006_FINAL_ITEM;

-- 2026.10.07 AJS 속도 개선 - 모델을 지정하면 품목 사본을 그 모델의 BOM 하위 품목으로 한정 (START)
        IF V_MODEL_ALL = 'N' THEN
            /* 아래 조회문은 사본을 BOM 하위 품목(A.CHILD_ITEM_ID)으로만 조인하므로 선택 모델의 하위 품목만 받아도 결과 동일 */
            /* 모델 목록 조건은 MEMBER OF 로 쓴다 (IN 하위질의 · 목록 조인이면 품목 뷰에 품목 조건이 들어가지 않는다) */
            INSERT INTO GT_0006_FINAL_ITEM
                 ( DIVISION_ID
                 , ITEM_ID
                 , OPERATION_GROUP_ID
                 , ELECTRODE_TYPE
                 , DC_YN
                 , RACK_YN
                 , CELL_TYPE )
            SELECT /*+ LEADING(XA) USE_NL(B) PUSH_PRED(B) */
                   B.DIVISION_ID
                 , B.ITEM_ID
                 , B.OPERATION_GROUP_ID
                 , B.ELECTRODE_TYPE
                 , B.DC_YN
                 , B.RACK_YN
                 , B.CELL_TYPE
              FROM (SELECT /*+ INDEX(A.SCM_MST_MODEL_BOM IX03_SCM_MST_MODEL_BOM) */
                           DISTINCT
                           A.CHILD_ITEM_ID
                      FROM SCM_MST_BOM_SN_V A
                     WHERE A.DIVISION_ID = P_DIVISION_ID
                       AND A.MODEL_ID MEMBER OF V_MODEL_TAB
                   ) XA
                 , SCM_MST_FINAL_ITEM_V B
             WHERE B.ITEM_ID     = XA.CHILD_ITEM_ID
               AND B.DIVISION_ID = P_DIVISION_ID;
        ELSE
        INSERT INTO GT_0006_FINAL_ITEM
             ( DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN
             , RACK_YN
             , CELL_TYPE )
        SELECT DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP_ID
             , ELECTRODE_TYPE
             , DC_YN
             , RACK_YN
             , CELL_TYPE
          FROM SCM_MST_FINAL_ITEM_V
         WHERE DIVISION_ID = P_DIVISION_ID;
        END IF;
-- 2026.10.07 AJS 속도 개선 (END)

        DBMS_STATS.GATHER_TABLE_STATS($$PLSQL_UNIT_OWNER, 'GT_0006_FINAL_ITEM', NO_INVALIDATE => FALSE);
-- 2026.09.23 AJS 성능 - 최종아이템 사본 적재 (END)

-- 2026.10.07 AJS 속도 개선 - 모델 지정 시 엔지니어링 BOM 최신 KEY_DATE 확인을 사업부 전체 분석함수 대신 AS-IS 와 같은 품목별 상관 EXISTS 로 (START)
        IF V_MODEL_ALL = 'N' THEN
            OPEN O_RC1 FOR
                SELECT IB.OPERATION_GROUP
                     , IB.OPERATION_GROUP_ID
                     , IB.ELECTRODE_TYPE
                     , IB.ITEM_ID
                     , IB.ITEM_NAME
                     , IB.PRIMARY_PLANT
                     , IB.DIVISION_ID
                     , IB.SCM_SITE_ID
                     , IB.PROJECT_CODE
                     , IB.MODEL_ID
                     , IB.DISPLAY_SEQ
                     , MAX(IB.ALT_PRIORITY) AS ALT_PRIORITY
                     , IB.DC_YN
                     , IB.RACK_YN
                     , IB.CELL_TYPE
                     , IB.CEL_TYPE_DISPLAY_SEQ
                  FROM (SELECT DISTINCT
                               CASE /* 전극 제외 20180517 */
                                    WHEN E.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                    WHEN E.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                               END AS OPERATION_GROUP
                             , E.OPERATION_GROUP_ID
                             , E.ELECTRODE_TYPE
                             , A.CHILD_ITEM_ID AS ITEM_ID
                             , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.CHILD_ITEM_ID) AS ITEM_NAME
                             , (SELECT MAX(XB.SITE_DESCRIPTION) KEEP (DENSE_RANK FIRST ORDER BY XA.FROM_YYYYMMDD)
                                  FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                     , SCM_MST_SITE XB
                                 WHERE XA.DIVISION_ID   = XB.DIVISION_ID
                                   AND XA.PLANT_SITE_ID = XB.SCM_SITE_ID
                                   AND XA.DIVISION_ID   = A.DIVISION_ID
                                   AND XA.ITEM_ID       = A.CHILD_ITEM_ID
                                   AND XA.VALID_YN      = 'Y'
                                   AND XA.PRIORITY      = 1
                                   AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                               ) AS PRIMARY_PLANT
                             , A.DIVISION_ID
                             , '-' AS SCM_SITE_ID
                             , '- ' AS PROJECT_CODE                              /* AS-IS 문자열 그대로 (뒤 공백 포함) */
                             , A.MODEL_ID                                        /* 화면 정렬 순서를 위해 추가 */
                             , F.DISPLAY_SEQ
                             , E.RACK_YN                                         /* PJ20202001 : RACK 구분, 정열조건 */
                             , A.ALT_PRIORITY
                             , E.DC_YN
                             , E.CELL_TYPE                                       /* 활성화코드 분리->Cell Assy Type */
                             , CASE WHEN RTRIM(E.CELL_TYPE) IS NULL THEN 0
                                    WHEN E.CELL_TYPE = 'CP'  THEN 1
                                    WHEN E.CELL_TYPE = 'CA2' THEN 2
                                    WHEN E.CELL_TYPE = 'CA1' THEN 3
                                    ELSE 4
                               END AS CEL_TYPE_DISPLAY_SEQ
                          FROM SCM_MST_BOM_SN_V A                                /* 2021.03.25 대체 BOM 모델링 */
                             , SCM_MST_ITEM_SN B
                             , GT_0006_FINAL_ITEM E                       /* 2026.09.23 AJS 성능 - SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                             , SCM_ADM_LOOKUP_MASTER_DETAIL F
                         WHERE A.COMPANY_ID     = B.COMPANY_ID
                           AND A.DIVISION_ID    = B.DIVISION_ID
                           AND A.SITE_ID        = B.SITE_ID
                           AND A.CHILD_ITEM_ID  = B.ITEM_ID
                           AND A.DIVISION_ID    = E.DIVISION_ID
                           AND A.CHILD_ITEM_ID  = E.ITEM_ID
                           AND F.SEGMENT1       = E.OPERATION_GROUP_ID
                           AND EXISTS (SELECT 1
                                         FROM SCM_MST_BOM_ENG_SN XC
                                        WHERE XC.PARENT_ITEM_ID  = A.CHILD_ITEM_ID
                                          AND XC.KEY_DATE        = (SELECT MAX(XD.KEY_DATE)
                                                                      FROM SCM_MST_BOM_ENG_SN XD
                                                                     WHERE XD.PARENT_ITEM_ID = A.CHILD_ITEM_ID
                                                                       AND XD.DIVISION_ID    = P_DIVISION_ID)
                                          AND XC.EFF_END_DATE   >= SYSDATE
                                          AND XC.DIVISION_ID     = P_DIVISION_ID)     /* 최신 KEY_DATE 기준 BOM 존재 (AS-IS 상관 EXISTS + MAX) */
                           AND F.LOOKUP_TYPE    = 'OPERATION_GROUP'
                           AND E.OPERATION_GROUP_ID <> 'E'
                           AND A.DIVISION_ID    = P_DIVISION_ID
                           AND (V_MODEL_ALL = 'Y' OR A.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_MODEL_TAB)))
                       ) IB
                 GROUP BY IB.OPERATION_GROUP
                        , IB.OPERATION_GROUP_ID
                        , IB.ELECTRODE_TYPE
                        , IB.ITEM_ID
                        , IB.ITEM_NAME
                        , IB.PRIMARY_PLANT
                        , IB.DIVISION_ID
                        , IB.SCM_SITE_ID
                        , IB.PROJECT_CODE
                        , IB.MODEL_ID
                        , IB.DISPLAY_SEQ
                        , IB.DC_YN
                        , IB.RACK_YN
                        , IB.CELL_TYPE
                        , IB.CEL_TYPE_DISPLAY_SEQ
                 ORDER BY UPPER(IB.RACK_YN) DESC NULLS LAST
                        , UPPER(IB.DC_YN) DESC NULLS LAST
                        , CASE WHEN RTRIM(IB.PRIMARY_PLANT) IS NULL THEN 1
                               ELSE 0
                          END
                        , REPLACE(REPLACE(UPPER(IB.MODEL_ID), '-', ''), '_', CHR(1)) NULLS FIRST
                        , IB.DISPLAY_SEQ NULLS FIRST
                        , IB.CEL_TYPE_DISPLAY_SEQ
                        , REPLACE(REPLACE(UPPER(IB.ITEM_ID), '-', ''), '_', CHR(1)) NULLS FIRST;
        ELSE
        OPEN O_RC1 FOR
            SELECT IB.OPERATION_GROUP
                 , IB.OPERATION_GROUP_ID
                 , IB.ELECTRODE_TYPE
                 , IB.ITEM_ID
                 , IB.ITEM_NAME
                 , IB.PRIMARY_PLANT
                 , IB.DIVISION_ID
                 , IB.SCM_SITE_ID
                 , IB.PROJECT_CODE
                 , IB.MODEL_ID
                 , IB.DISPLAY_SEQ
                 , MAX(IB.ALT_PRIORITY) AS ALT_PRIORITY
                 , IB.DC_YN
                 , IB.RACK_YN
                 , IB.CELL_TYPE
                 , IB.CEL_TYPE_DISPLAY_SEQ
              FROM (SELECT DISTINCT
                           CASE /* 전극 제외 20180517 */
                                WHEN E.OPERATION_GROUP_ID = 'A' THEN 'Cell'
                                WHEN E.OPERATION_GROUP_ID = 'P' THEN 'Pack'
                           END AS OPERATION_GROUP
                         , E.OPERATION_GROUP_ID
                         , E.ELECTRODE_TYPE
                         , A.CHILD_ITEM_ID AS ITEM_ID
                         , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.CHILD_ITEM_ID) AS ITEM_NAME
                         , (SELECT MAX(XB.SITE_DESCRIPTION) KEEP (DENSE_RANK FIRST ORDER BY XA.FROM_YYYYMMDD)
                              FROM SCM_MST_SITE_ITEM_PRIORITY XA
                                 , SCM_MST_SITE XB
                             WHERE XA.DIVISION_ID   = XB.DIVISION_ID
                               AND XA.PLANT_SITE_ID = XB.SCM_SITE_ID
                               AND XA.DIVISION_ID   = A.DIVISION_ID
                               AND XA.ITEM_ID       = A.CHILD_ITEM_ID
                               AND XA.VALID_YN      = 'Y'
                               AND XA.PRIORITY      = 1
                               AND XA.TO_YYYYMMDD  >= TO_CHAR(SYSDATE, 'YYYYMMDD')
                           ) AS PRIMARY_PLANT
                         , A.DIVISION_ID
                         , '-' AS SCM_SITE_ID
                         , '- ' AS PROJECT_CODE                              /* AS-IS 문자열 그대로 (뒤 공백 포함) */
                         , A.MODEL_ID                                        /* 화면 정렬 순서를 위해 추가 */
                         , F.DISPLAY_SEQ
                         , E.RACK_YN                                         /* PJ20202001 : RACK 구분, 정열조건 */
                         , A.ALT_PRIORITY
                         , E.DC_YN
                         , E.CELL_TYPE                                       /* 활성화코드 분리->Cell Assy Type */
                         , CASE WHEN RTRIM(E.CELL_TYPE) IS NULL THEN 0
                                WHEN E.CELL_TYPE = 'CP'  THEN 1
                                WHEN E.CELL_TYPE = 'CA2' THEN 2
                                WHEN E.CELL_TYPE = 'CA1' THEN 3
                                ELSE 4
                           END AS CEL_TYPE_DISPLAY_SEQ
                      FROM SCM_MST_BOM_SN_V A                                /* 2021.03.25 대체 BOM 모델링 */
                         , SCM_MST_ITEM_SN B
                         , GT_0006_FINAL_ITEM E                       /* 2026.09.23 AJS 성능 - SCM_MST_FINAL_ITEM_V 사업부 한정 사본 */
                         , SCM_ADM_LOOKUP_MASTER_DETAIL F
                     WHERE A.COMPANY_ID     = B.COMPANY_ID
                       AND A.DIVISION_ID    = B.DIVISION_ID
                       AND A.SITE_ID        = B.SITE_ID
                       AND A.CHILD_ITEM_ID  = B.ITEM_ID
                       AND A.DIVISION_ID    = E.DIVISION_ID
                       AND A.CHILD_ITEM_ID  = E.ITEM_ID
                       AND F.SEGMENT1       = E.OPERATION_GROUP_ID
                       AND A.CHILD_ITEM_ID IN (SELECT XD.PARENT_ITEM_ID
                                                 FROM (SELECT XC.PARENT_ITEM_ID
                                                            , XC.KEY_DATE
                                                            , XC.EFF_END_DATE
                                                            , MAX(XC.KEY_DATE) OVER (PARTITION BY XC.PARENT_ITEM_ID) AS MAX_KEY_DATE
                                                         FROM SCM_MST_BOM_ENG_SN XC
                                                        WHERE XC.DIVISION_ID = P_DIVISION_ID
                                                      ) XD
                                                WHERE XD.KEY_DATE      = XD.MAX_KEY_DATE
                                                  AND XD.EFF_END_DATE >= SYSDATE)     /* 최신 KEY_DATE 기준 BOM 존재 (AS-IS 상관 EXISTS + MAX 와 같은 결과) */
                       AND F.LOOKUP_TYPE    = 'OPERATION_GROUP'
                       AND E.OPERATION_GROUP_ID <> 'E'
                       AND A.DIVISION_ID    = P_DIVISION_ID
                       AND (V_MODEL_ALL = 'Y' OR A.MODEL_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_MODEL_TAB)))
                   ) IB
             GROUP BY IB.OPERATION_GROUP
                    , IB.OPERATION_GROUP_ID
                    , IB.ELECTRODE_TYPE
                    , IB.ITEM_ID
                    , IB.ITEM_NAME
                    , IB.PRIMARY_PLANT
                    , IB.DIVISION_ID
                    , IB.SCM_SITE_ID
                    , IB.PROJECT_CODE
                    , IB.MODEL_ID
                    , IB.DISPLAY_SEQ
                    , IB.DC_YN
                    , IB.RACK_YN
                    , IB.CELL_TYPE
                    , IB.CEL_TYPE_DISPLAY_SEQ
             ORDER BY UPPER(IB.RACK_YN) DESC NULLS LAST
                    , UPPER(IB.DC_YN) DESC NULLS LAST
                    , CASE WHEN RTRIM(IB.PRIMARY_PLANT) IS NULL THEN 1
                           ELSE 0
                      END
                    , REPLACE(REPLACE(UPPER(IB.MODEL_ID), '-', ''), '_', CHR(1)) NULLS FIRST
                    , IB.DISPLAY_SEQ NULLS FIRST
                    , IB.CEL_TYPE_DISPLAY_SEQ
                    , REPLACE(REPLACE(UPPER(IB.ITEM_ID), '-', ''), '_', CHR(1)) NULLS FIRST;
        END IF;
-- 2026.10.07 AJS 속도 개선 (END)

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0006_GET_PROJECT_ROUTE_BOM_82'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_MODEL_ID=' || P_MODEL_ID
                     || ', P_PROJECT_CODE=' || P_PROJECT_CODE
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0006_GET_PROJECT_ROUTE_BOM_82;


    /*==================================================================================================
     * Program ID   : SCP0006_GET_PROJECT_ROUTE_PLANT
     * Description  : Project Route Plant Site 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2017/12/28   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/09   PJS            입력, 수정 이력 컬럼 조회 추가
     * 2018/08/16   YHW            VALIDATION용 ERP ITEM 조회
     * 2021/09/15   KMJ            [PJ20209642] LGES Digital SCM Level.3 달성을 위한 개선 - PLANT_ID, OPERATION_ID 추가
     * 2023/06/07   chaan          V1.1.1  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - 활성화 코드 분리
     * 2023/06/30   chaan          V1.1.2  PJ20230691R  LGES SCM 역량 강화 위한 SCP 개선과제 이행 - Plant Assign 목록조회시 Warranty 제외
     * 2026/09/14                  MSSQL -> Oracle 전환
     * 2026/09/16   AJS            아이템 미전달 시 검증용 ERP ITEM 0 건 (AS-IS 동일)
     */
    PROCEDURE P_SCP0006_GET_PROJECT_ROUTE_PLANT
    (
        P_DIVISION_ID     IN  VARCHAR2,
        P_SCM_SITE_ID     IN  VARCHAR2,
        P_PROJECT_CODE    IN  VARCHAR2,
        P_ITEM_ID         IN  VARCHAR2,
        O_RC1             OUT SYS_REFCURSOR,
        O_RC2             OUT SYS_REFCURSOR,
        O_RESULT_CODE     OUT VARCHAR2,
        O_RESULT_MSG      OUT VARCHAR2
    )
    IS
    BEGIN

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

        OPEN O_RC1 FOR
            SELECT A.PRIORITY_SEQ
                 , A.DIVISION_ID
                 , A.PROJECT_CODE
                 , A.ITEM_ID
                 , A.SALES_SITE_ID AS SCM_SITE_ID
                 , A.PLANT_SITE_ID
                 , A.PRIORITY
                 , A.VALID_YN
                 , TO_CHAR(FN_CHAR_TO_DATE(A.FROM_YYYYMMDD), 'YYYY-MM-DD') AS FROM_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.TO_YYYYMMDD), 'YYYY-MM-DD') AS TO_YYYYMMDD
                 , A.CREATED_BY
                 , A.CREATION_DATE
                 , A.LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
                 , A.FROM_YYYYMMDD AS ORG_FROM_YYYYMMDD
                 , A.TO_YYYYMMDD AS ORG_TO_YYYYMMDD
                 , A.FROM_YYYYMMDD || A.TO_YYYYMMDD AS MERGE_DATE
                 , '' AS IS_PASS_N1
                 , '' AS IS_PASS_N2
                 , '' AS IS_PASS_N3
                 , '' AS IS_PASS_N4
                 , '' AS IS_PASS_N5
                 , '' AS IS_PASS_N6
                 , '' AS IS_PASS_N7
                 , B.PLANT_ID
                 , IA.OPERATION_ID
                 , IA.OPERATION_GROUP_ID
              FROM SCM_MST_SITE_ITEM_PRIORITY A
                 , SCM_MST_SITE B
                 , (SELECT DISTINCT
                           C.COMPANY_ID
                         , C.DIVISION_ID
                         , C.SITE_ID
                         , C.FLOW_ID AS OPERATION_ID
                         , IB.OPERATION_GROUP_ID
                      FROM SCM_MST_ITEM_SN C
                         , (SELECT DISTINCT
                                   D.COMPANY_ID
                                 , D.DIVISION_ID
                                 , D.SITE_ID
                                 , D.OPERATION_ID
                                 , D.OPERATION_GROUP_ID
                              FROM SCM_LINE_HIERARCHY_V_SN D
                           ) IB
                     WHERE C.COMPANY_ID          = IB.COMPANY_ID
                       AND C.DIVISION_ID         = IB.DIVISION_ID
                       AND C.SITE_ID             = IB.SITE_ID
                       AND SUBSTR(C.FLOW_ID, 1, 5) = IB.OPERATION_ID
                       AND C.FLOW_ID IS NOT NULL
                       AND C.ACTIVE_FLAG         = 'Y'
                       AND C.DIVISION_ID         = P_DIVISION_ID
                       AND C.ITEM_ID             = P_ITEM_ID
                   ) IA
             WHERE A.DIVISION_ID      = B.DIVISION_ID
               AND A.PLANT_SITE_ID    = B.SCM_SITE_ID
               AND B.COMPANY_ID       = IA.COMPANY_ID(+)
               AND B.DIVISION_ID      = IA.DIVISION_ID(+)
               AND B.SITE_ID          = IA.SITE_ID(+)
               AND B.OPERATION_GROUP <> 'W'                    /* Plant Assign 목록조회시 Warranty 제외 */
               AND B.SITE_TYPE        = 'PLANT'
               AND A.DIVISION_ID      = P_DIVISION_ID
               AND A.SALES_SITE_ID    = P_SCM_SITE_ID
               AND A.PROJECT_CODE     = P_PROJECT_CODE
               AND A.ITEM_ID          = P_ITEM_ID
             ORDER BY A.ITEM_ID
                    , A.FROM_YYYYMMDD
                    , A.PRIORITY
                    , A.VALID_YN DESC NULLS LAST
                    , A.TO_YYYYMMDD;

        /* VALIDATION용 ERP ITEM 조회 */
        OPEN O_RC2 FOR
            SELECT COMPANY_ID
                 , DIVISION_ID
                 , ITEM_ID
                 , SITE_ID
              FROM SCM_MST_ITEM_SN
             WHERE ITEM_ID     LIKE SUBSTR(P_ITEM_ID, 1, LENGTH(RTRIM(P_ITEM_ID)) - 1) || '%'
               AND DIVISION_ID = '40'
               -- 2026.09.16 AJS 아이템 미전달 시 0 건 - NULL || '%' 가 '%' 로 바뀌어 전건 조회되던 것 방지 (START)
--             AND ACTIVE_FLAG = 'Y';
               AND ACTIVE_FLAG = 'Y'
               AND P_ITEM_ID IS NOT NULL;
               -- 2026.09.16 AJS 아이템 미전달 시 0 건 - NULL || '%' 가 '%' 로 바뀌어 전건 조회되던 것 방지 (END)

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('SCP0006_GET_PROJECT_ROUTE_PLANT'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_PROJECT_CODE=' || P_PROJECT_CODE
                     || ', P_ITEM_ID=' || P_ITEM_ID
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

    END P_SCP0006_GET_PROJECT_ROUTE_PLANT;


    /* ------------------------------------------------------------
       SCM_MST_SITE_ITEM 입력/수정 (AS-IS MERGE 대응 - 온라인 SQL MERGE 금지)
       ------------------------------------------------------------ */
    PROCEDURE P_UPSERT_SITE_ITEM
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_PROJECT_CODE      IN  VARCHAR2,
        P_SCM_SITE_ID       IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_LAST_UPDATED_BY   IN  VARCHAR2
    )
    IS
    BEGIN
        UPDATE SCM_MST_SITE_ITEM
           SET LAST_UPDATED_BY  = NVL(P_LAST_UPDATED_BY, '-')      /* NOT NULL 칸 - 빈 값은 이관 채움값 '-' */
             , LAST_UPDATE_DATE = SYSDATE
         WHERE DIVISION_ID      = P_DIVISION_ID
           AND PROJECT_CODE     = P_PROJECT_CODE
           AND SCM_SITE_ID      = P_SCM_SITE_ID
           AND ITEM_ID          = P_ITEM_ID;

        IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO SCM_MST_SITE_ITEM
                 ( DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , CURRENCY
                 , LIABILITY_PERIOD
                 , SALES_PLAN_ADJUST_YN
                 , ITEM_HRCY_ID
                 , VALID_YN
                 , BPMS_EXIST
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE )
            VALUES
                 ( P_DIVISION_ID
                 , P_PROJECT_CODE
                 , P_SCM_SITE_ID
                 , P_ITEM_ID
                 , NULL
                 , NULL
                 , NULL
                 , NULL
                 , 'Y'
                 , 'Y'
                 , NVL(P_CREATED_BY, '-')
                 , SYSDATE
                 , NVL(P_CREATED_BY, '-')
                 , SYSDATE );
        END IF;
    END P_UPSERT_SITE_ITEM;


    /* ------------------------------------------------------------
       AS-IS PR_SCM_MST_SITE_ITEM_HIST 본문
       Oracle 전환본 PR_SCM_MST_SITE_ITEM_HIST 는 안에서 COMMIT 을 하므로 부르지 않는다
       (부르면 저장 도중 오류가 나도 앞 행이 확정된다).
       AS-IS 는 CATCH 에서 로그를 남긴 뒤 COMMIT WORK 를 하여 바깥 저장이 트랜잭션 수 불일치로 실패한다
       → 로그를 남기고 오류를 그대로 올린다.
       등록일시는 AS-IS 가 DATETIME → NVARCHAR → DATETIME 암묵 변환을 거쳐 초가 잘리므로 분 단위로 자른다.
       ------------------------------------------------------------ */
    PROCEDURE P_SITE_ITEM_HIST
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_PROJECT_CODE      IN  VARCHAR2,
        P_SCM_SITE_ID       IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_VALID_YN          IN  VARCHAR2,
        P_BPMS_EXIST        IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_CREATION_DATE     IN  DATE,
        P_LAST_UPDATED_BY   IN  VARCHAR2
    )
    IS
    BEGIN
        INSERT INTO SCM_MST_SITE_ITEM_H
             ( DIVISION_ID
             , HISTORY_SEQ
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , CURRENCY
             , LIABILITY_PERIOD
             , SALES_PLAN_ADJUST_YN
             , ITEM_HRCY_ID
             , VALID_YN
             , BPMS_EXIST
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE )
        VALUES
             ( P_DIVISION_ID
             , SEQ1_SCM_MST_SITE_ITEM_H.NEXTVAL
             , P_PROJECT_CODE
             , P_SCM_SITE_ID
             , P_ITEM_ID
             , NULL
             , NULL
             , NULL
             , NULL
             , P_VALID_YN
             , P_BPMS_EXIST
             , NVL(P_CREATED_BY, '-')
             , TRUNC(P_CREATION_DATE, 'MI')
             , NVL(P_LAST_UPDATED_BY, '-')
             , SYSDATE
             , SYSDATE );
    EXCEPTION
        WHEN OTHERS THEN
            P_LOG_ERROR('PR_SCM_MST_SITE_HIST'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID
                     || ', P_PROJECT_CODE=' || P_PROJECT_CODE
                     || ', P_SCM_SITE_ID=' || P_SCM_SITE_ID
                     || ', P_ITEM_ID=' || P_ITEM_ID
                      , SQLCODE
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
            RAISE;
    END P_SITE_ITEM_HIST;


    /* ------------------------------------------------------------
       AS-IS PR_SCM_MST_SITE_ITEM_PRIORITY_HIST 본문
       Oracle 전환본은 자율 트랜잭션이라 저장이 롤백돼도 이력이 남으므로 부르지 않는다.
       AS-IS 는 TRY/CATCH 가 주석이라 오류가 그대로 저장 실패로 이어진다.
       등록일시는 AS-IS 암묵 변환(NVARCHAR 경유)으로 초가 잘리므로 분 단위로 자른다.
       ------------------------------------------------------------ */
    PROCEDURE P_PRIORITY_HIST
    (
        P_PRIORITY_SEQ      IN  VARCHAR2,
        P_DIVISION_ID       IN  VARCHAR2,
        P_PROJECT_CODE      IN  VARCHAR2,
        P_SCM_SITE_ID       IN  VARCHAR2,
        P_PLANT_SITE_ID     IN  VARCHAR2,
        P_ITEM_ID           IN  VARCHAR2,
        P_PRIORITY          IN  VARCHAR2,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_VALID_YN          IN  VARCHAR2,
        P_CREATED_BY        IN  VARCHAR2,
        P_CREATION_DATE     IN  DATE,
        P_LAST_UPDATED_BY   IN  VARCHAR2
    )
    IS
    BEGIN
        INSERT INTO SCM_MST_SITE_ITEM_PRIORITY_H
             ( HISTORY_SEQ
             , PRIORITY_SEQ
             , DIVISION_ID
             , PROJECT_CODE
             , SALES_SITE_ID
             , PLANT_SITE_ID
             , ITEM_ID
             , PRIORITY
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
             , VALID_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE )
        VALUES
             ( SEQ1_SCM_MST_SITE_ITEM_PRIORITY_H.NEXTVAL
             , TO_NUMBER(P_PRIORITY_SEQ)
             , P_DIVISION_ID
             , P_PROJECT_CODE
             , P_SCM_SITE_ID
             , P_PLANT_SITE_ID
             , P_ITEM_ID
             , TO_NUMBER(P_PRIORITY)
             , P_FROM_YYYYMMDD
             , P_TO_YYYYMMDD
             , P_VALID_YN
             , P_CREATED_BY
             , TRUNC(P_CREATION_DATE, 'MI')
             , P_LAST_UPDATED_BY
             , SYSDATE
             , SYSDATE );
    END P_PRIORITY_HIST;


    /*==================================================================================================
     * Program ID   : SCP0006_SAVE_PROJECT_ROUTE_PLANT
     * Description  : Project Route Plant Site 등록,수정
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/01/10   byunghunjung   Initial Release [PJ20170278] 전지본부 자동차 GSCM(DM/SCP) 구축 프로젝트
     * 2018/05/09   PJS            프로지져 주석 현행화
     * 2018/08/23   YHW            이력 저장 호출 변경(PARAM : PLANT_SITE)
     * 2023/06/07   chaan          V1.1.1  PJ20230691R  활성화 코드 분리
     * 2023/10/13   chaan          V1.1.2  PJ20230691R  Plant 수정시 하위 CP1 수정 오류 수정
     * 2023/11/02   chaan          V1.1.3  PJ20230691R  Plant 수정시 하위 CA1 수정 오류 수정
     * 2023/11/06   chaan          V1.1.4  PJ20230691R  Plant 수정시 하위 CA1 수정 오류 수정
     * 2023/11/14   chaan          V1.1.5  PJ20230691R  Plant 수정시 하위 CA 수정 로직 변경(사업부81,82/40 에 따라 키값 상이)
     * 2023/11/21   chaan          V1.1.6  PJ20230691R  Pack 변경시 ca 변경되는 오류 수정 (cp 수정시만 수정되도록)
     * 2023/11/28   chaan          V1.1.7  PJ20230691R  ca 변경 오류 수정 (ca값이 CP 가 아닌 Pack을 따라감)
     * 2024/01/03   chaan          V1.1.8  PJ20230691R  ca 수정시 검색조건의 division_id 오류 수정, @p_division_id -> @v_division_id 으로 변경
     * 2024/01/04   chaan          V1.1.9  PJ20230691R  SCM_MST_SITE_ITEM 저장 오류 패치
     * 2025/08/26   YMH            V1.1.10 CSR : E20250820-000940 CP 수정에 따른 CA변경 오류 수정
     * 2025/10/24   kimcd          V1.1.11 [PJ2025F254]  JV법인 ESS 혼용 생산 시스템 개선
     *                                     JV ESS 생산에 따른 실제 Link scm site id 값을 ATTRIBUTE9에 할당 관리
     * 2026/09/14                  MSSQL -> Oracle 전환
     */
    PROCEDURE P_SCP0006_SAVE_PROJECT_ROUTE_PLANT
    (
        P_ACTIVE_FLAG     IN  CLOB,
        P_PRIORITY_SEQ    IN  CLOB,
        P_DIVISION_ID     IN  CLOB,
        P_PROJECT_CODE    IN  CLOB,
        P_SCM_SITE_ID     IN  CLOB,
        P_PLANT_SITE_ID   IN  CLOB,
        P_ITEM_ID         IN  CLOB,
        P_PRIORITY        IN  CLOB,
        P_FROM_YYYYMMDD   IN  CLOB,
        P_TO_YYYYMMDD     IN  CLOB,
        P_VALID_YN        IN  CLOB,
        P_CREATED_BY      IN  CLOB,
        P_CREATION_DATE   IN  CLOB,
        P_LAST_UPDATED_BY IN  CLOB,
        P_DEBUG_MODE      IN  VARCHAR2 DEFAULT 'F',
        O_RESULT_CODE     OUT VARCHAR2,
        O_RESULT_CNT      OUT NUMBER,
        O_RESULT_MSG      OUT VARCHAR2
    )
    IS
        C_DELIM                 CONSTANT VARCHAR2(1 CHAR) := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SCP0006_SAVE_PROJECT_ROUTE_PLANT';

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_PRIORITY_SEQ          T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_PROJECT_CODE          T_TOKEN_TAB;
        T_SCM_SITE_ID           T_TOKEN_TAB;
        T_PLANT_SITE_ID         T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_PRIORITY              T_TOKEN_TAB;
        T_FROM_YYYYMMDD         T_TOKEN_TAB;
        T_TO_YYYYMMDD           T_TOKEN_TAB;
        T_VALID_YN              T_TOKEN_TAB;
        T_CREATED_BY            T_TOKEN_TAB;
        T_CREATION_DATE         T_TOKEN_TAB;
        T_LAST_UPDATED_BY       T_TOKEN_TAB;
        T_CA_ITEM               T_TOKEN_TAB;
        V_DUMMY_CNT             PLS_INTEGER;

        V_LOOP_CNT              PLS_INTEGER := 0;
        V_CURR_LOOP_CNT         PLS_INTEGER := 0;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_CP_PRIORITY_SEQ       VARCHAR2(4000 CHAR);
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
        V_BPMS_EXIST            VARCHAR2(1 CHAR) := 'Y';

        /* 2025/10/24 kimcd [PJ2025F254] JV법인 ESS 혼용 생산 시스템 개선 */
        V_LINK_PLANT_SITE_ID    VARCHAR2(4000 CHAR);
        V_LINK_DIVISION_ID      VARCHAR2(4000 CHAR);
        V_LINK_CP_PRIORITY_SEQ  NUMBER(19);

        V_CP_OPERATION_GROUP    VARCHAR2(10 CHAR);

        /* E20250820-000940 CA 업데이트 대상 존재유무 체크 */
        V_CA_UPDATE_EXISTS      PLS_INTEGER := 0;
        V_CA_ITEM_CD_LIST       VARCHAR2(500 CHAR);
        V_CA_CNT                PLS_INTEGER := 0;
        V_CA_ITEM_ID_NEW        VARCHAR2(50 CHAR);
        /* AS-IS #TblSCP0006_SAVE_CA_ALL 은 첫 행 처리 때만 만들어진다 */
        V_CA_ALL_CREATED        VARCHAR2(1 CHAR) := 'N';

        V_ERR_MSG               VARCHAR2(4000 CHAR);
        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_BACKTRACE             VARCHAR2(4000 CHAR);
    BEGIN

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE FROM GT_0006_SAVE_CP;
        DELETE FROM GT_0006_SAVE_CA_ITEM;
        DELETE FROM GT_0006_SAVE_CA_CURR;
        DELETE FROM GT_0006_SAVE_CA_ALL;

        /* 각 컬럼들에 대한 스플릿처리 */
        P_SPLIT_TOKEN(P_ACTIVE_FLAG    , C_DELIM, T_ACTIVE_FLAG    , V_LOOP_CNT);   /* 프로시저 LOOP 길이를 판단 */
        P_SPLIT_TOKEN(P_PRIORITY_SEQ   , C_DELIM, T_PRIORITY_SEQ   , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_DIVISION_ID    , C_DELIM, T_DIVISION_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PROJECT_CODE   , C_DELIM, T_PROJECT_CODE   , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SCM_SITE_ID    , C_DELIM, T_SCM_SITE_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLANT_SITE_ID  , C_DELIM, T_PLANT_SITE_ID  , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID        , C_DELIM, T_ITEM_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PRIORITY       , C_DELIM, T_PRIORITY       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_FROM_YYYYMMDD  , C_DELIM, T_FROM_YYYYMMDD  , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_TO_YYYYMMDD    , C_DELIM, T_TO_YYYYMMDD    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_VALID_YN       , C_DELIM, T_VALID_YN       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CREATED_BY     , C_DELIM, T_CREATED_BY     , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CREATION_DATE  , C_DELIM, T_CREATION_DATE  , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_LAST_UPDATED_BY, C_DELIM, T_LAST_UPDATED_BY, V_DUMMY_CNT);

        IF P_DEBUG_MODE = 'T' THEN
            DBMS_OUTPUT.PUT_LINE('@v_loop_cnt : ' || V_LOOP_CNT);
        END IF;

        /* AS-IS WHILE LEN(@recv_active_flag) > 0 AND @v_curr_loop_cnt < @v_loop_cnt */
        IF NVL(LENGTH(RTRIM(DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 4000, 1))), 0) > 0 THEN

            WHILE V_CURR_LOOP_CNT < V_LOOP_CNT
            LOOP
                V_CURR_LOOP_CNT := V_CURR_LOOP_CNT + 1;

                V_CP_PRIORITY_SEQ := F_TOKEN(T_PRIORITY_SEQ, V_CURR_LOOP_CNT);

                IF V_CP_PRIORITY_SEQ IS NULL THEN
                    V_CP_PRIORITY_SEQ := TO_CHAR(SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL);
                END IF;

                V_ACTIVE_FLAG     := F_TOKEN(T_ACTIVE_FLAG    , V_CURR_LOOP_CNT);
                V_DIVISION_ID     := F_TOKEN(T_DIVISION_ID    , V_CURR_LOOP_CNT);
                V_PROJECT_CODE    := F_TOKEN(T_PROJECT_CODE   , V_CURR_LOOP_CNT);
                V_SCM_SITE_ID     := F_TOKEN(T_SCM_SITE_ID    , V_CURR_LOOP_CNT);
                V_PLANT_SITE_ID   := F_TOKEN(T_PLANT_SITE_ID  , V_CURR_LOOP_CNT);
                V_ITEM_ID         := F_TOKEN(T_ITEM_ID        , V_CURR_LOOP_CNT);
                V_CREATED_BY      := F_TOKEN(T_CREATED_BY     , V_CURR_LOOP_CNT);
                V_CREATION_DATE   := F_TO_DATETIME(F_TOKEN(T_CREATION_DATE, V_CURR_LOOP_CNT));
                V_LAST_UPDATED_BY := F_TOKEN(T_LAST_UPDATED_BY, V_CURR_LOOP_CNT);
                V_PRIORITY        := F_TOKEN(T_PRIORITY       , V_CURR_LOOP_CNT);
                V_FROM_YYYYMMDD   := F_TOKEN(T_FROM_YYYYMMDD  , V_CURR_LOOP_CNT);
                V_TO_YYYYMMDD     := F_TOKEN(T_TO_YYYYMMDD    , V_CURR_LOOP_CNT);
                V_FROM_YYYYMMDD   := CASE WHEN REGEXP_LIKE(V_FROM_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                     THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_FROM_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                     ELSE V_FROM_YYYYMMDD END;   -- 2026.09.22 AJS
                V_TO_YYYYMMDD     := CASE WHEN REGEXP_LIKE(V_TO_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                     THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_TO_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                     ELSE V_TO_YYYYMMDD END;   -- 2026.09.22 AJS
                V_VALID_YN        := F_TOKEN(T_VALID_YN       , V_CURR_LOOP_CNT);

                BEGIN
                    SELECT VALID_YN
                      INTO V_S_VALID_YN
                      FROM SCM_MST_SITE_ITEM
                     WHERE DIVISION_ID  = V_DIVISION_ID
                       AND SCM_SITE_ID  = V_SCM_SITE_ID
                       AND ITEM_ID      = V_ITEM_ID
                       AND PROJECT_CODE = V_PROJECT_CODE;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_S_VALID_YN := NULL;
                END;

                /* 2025/10/24 kimcd [PJ2025F254] JV ESS 생산에 따른 실제 Link scm site id 값 설정 시작 */
                V_LINK_PLANT_SITE_ID   := NULL;
                V_LINK_DIVISION_ID     := NULL;
                V_LINK_CP_PRIORITY_SEQ := NULL;

                BEGIN
                    SELECT B.DIVISION_ID
                         , B.SCM_SITE_ID
                      INTO V_LINK_DIVISION_ID
                         , V_LINK_PLANT_SITE_ID
                      FROM SCM_MST_SITE A
                         , SCM_MST_SITE B
                     WHERE B.SCM_SITE_ID = A.ATTRIBUTE9
                       AND A.SCM_SITE_ID = V_PLANT_SITE_ID
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND ROWNUM        = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;
                /* 2025/10/24 kimcd [PJ2025F254] JV ESS 생산에 따른 실제 Link scm site id 값 설정 끝 */

                IF P_DEBUG_MODE = 'T' THEN
                    DBMS_OUTPUT.PUT_LINE('@v_curr_loop_cnt : ' || V_CURR_LOOP_CNT
                                      || ' / flag=' || V_ACTIVE_FLAG || ' / seq=' || V_CP_PRIORITY_SEQ
                                      || ' / div=' || V_DIVISION_ID || ' / project=' || V_PROJECT_CODE
                                      || ' / site=' || V_SCM_SITE_ID || ' / plant=' || V_PLANT_SITE_ID
                                      || ' / item=' || V_ITEM_ID || ' / link=' || V_LINK_DIVISION_ID || ':' || V_LINK_PLANT_SITE_ID);
                END IF;

                /* CP 수정 begin -------------------------------------------------------------------------- */
                P_UPSERT_SITE_ITEM(V_DIVISION_ID, V_PROJECT_CODE, V_PLANT_SITE_ID, V_ITEM_ID, V_CREATED_BY, V_LAST_UPDATED_BY);

                /* SCM_MST_SITE_ITEM_PRIORITY입력/수정 */
                IF V_ACTIVE_FLAG = 'M' THEN
                    UPDATE SCM_MST_SITE_ITEM_PRIORITY
                       SET SALES_SITE_ID    = V_SCM_SITE_ID
                         , PLANT_SITE_ID    = V_PLANT_SITE_ID
                         , PRIORITY         = TO_NUMBER(V_PRIORITY)
                         , FROM_YYYYMMDD    = V_FROM_YYYYMMDD
                         , TO_YYYYMMDD      = V_TO_YYYYMMDD
                         , VALID_YN         = V_VALID_YN
                         , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE PRIORITY_SEQ     = TO_NUMBER(V_CP_PRIORITY_SEQ);
                ELSIF V_ACTIVE_FLAG = 'I' THEN
                    INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                         ( PRIORITY_SEQ
                         , DIVISION_ID
                         , PROJECT_CODE
                         , SALES_SITE_ID
                         , PLANT_SITE_ID
                         , ITEM_ID
                         , PRIORITY
                         , FROM_YYYYMMDD
                         , TO_YYYYMMDD
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    VALUES
                         ( TO_NUMBER(V_CP_PRIORITY_SEQ)
                         , V_DIVISION_ID
                         , V_PROJECT_CODE
                         , V_SCM_SITE_ID
                         , V_PLANT_SITE_ID
                         , V_ITEM_ID
                         , TO_NUMBER(V_PRIORITY)
                         , V_FROM_YYYYMMDD
                         , V_TO_YYYYMMDD
                         , V_VALID_YN
                         , V_CREATED_BY
                         , SYSDATE
                         , V_CREATED_BY
                         , SYSDATE );
                END IF;
                /* CP 수정 end ---------------------------------------------------------------------------- */

                DELETE FROM GT_0006_SAVE_CP;

                INSERT INTO GT_0006_SAVE_CP
                SELECT PRIORITY_SEQ
                     , DIVISION_ID
                     , PLANT_SITE_ID
                     , SALES_SITE_ID
                     , PROJECT_CODE
                     , ITEM_ID
                     , PRIORITY
                     , FROM_YYYYMMDD
                     , TO_YYYYMMDD
                     , VALID_YN
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     , ATTRIBUTE1
                     , ATTRIBUTE2
                     , ATTRIBUTE3
                     , ATTRIBUTE4
                     , ATTRIBUTE5
                     , ATTRIBUTE6
                     , ATTRIBUTE7
                     , ATTRIBUTE8
                     , ATTRIBUTE9
                     , ATTRIBUTE10
                  FROM SCM_MST_SITE_ITEM_PRIORITY
                 WHERE PRIORITY_SEQ = TO_NUMBER(V_CP_PRIORITY_SEQ);

                /* CP에 해당하는 HISTORY UPDATE */
                P_SITE_ITEM_HIST(V_DIVISION_ID, V_PROJECT_CODE, V_PLANT_SITE_ID, V_ITEM_ID
                               , V_S_VALID_YN, V_BPMS_EXIST, V_CREATED_BY, V_CREATION_DATE, V_LAST_UPDATED_BY);

                P_PRIORITY_HIST(V_CP_PRIORITY_SEQ, V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_PLANT_SITE_ID, V_ITEM_ID
                              , V_PRIORITY, V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_VALID_YN
                              , V_CREATED_BY, V_CREATION_DATE, V_LAST_UPDATED_BY);

                /* 2025/10/24 kimcd [PJ2025F254] JV 동기화 설정 시작 */
                IF V_LINK_DIVISION_ID IS NOT NULL AND V_LINK_PLANT_SITE_ID IS NOT NULL THEN

                    P_UPSERT_SITE_ITEM(V_LINK_DIVISION_ID, V_PROJECT_CODE, V_LINK_PLANT_SITE_ID, V_ITEM_ID, V_CREATED_BY, V_LAST_UPDATED_BY);

                    BEGIN
                        SELECT PRIORITY_SEQ
                          INTO V_LINK_CP_PRIORITY_SEQ
                          FROM SCM_MST_SITE_ITEM_PRIORITY
                         WHERE DIVISION_ID    = V_LINK_DIVISION_ID
                           AND PROJECT_CODE   = V_PROJECT_CODE
                           AND SALES_SITE_ID  = V_SCM_SITE_ID
                           AND PLANT_SITE_ID  = V_LINK_PLANT_SITE_ID
                           AND ITEM_ID        = V_ITEM_ID
                           AND FROM_YYYYMMDD <= V_TO_YYYYMMDD
                           AND TO_YYYYMMDD   >= V_FROM_YYYYMMDD
                           AND ROWNUM         = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            V_LINK_CP_PRIORITY_SEQ := NULL;
                    END;

                    IF V_LINK_CP_PRIORITY_SEQ IS NOT NULL THEN
                        UPDATE SCM_MST_SITE_ITEM_PRIORITY
                           SET SALES_SITE_ID    = V_SCM_SITE_ID
                             , PRIORITY         = TO_NUMBER(V_PRIORITY)
                             , FROM_YYYYMMDD    = V_FROM_YYYYMMDD
                             , TO_YYYYMMDD      = V_TO_YYYYMMDD
                             , VALID_YN         = V_VALID_YN
                             , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                             , LAST_UPDATE_DATE = SYSDATE
                         WHERE PRIORITY_SEQ     = V_LINK_CP_PRIORITY_SEQ;
                    ELSE
                        V_LINK_CP_PRIORITY_SEQ := SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL;

                        INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                             ( PRIORITY_SEQ
                             , DIVISION_ID
                             , PROJECT_CODE
                             , SALES_SITE_ID
                             , PLANT_SITE_ID
                             , ITEM_ID
                             , PRIORITY
                             , FROM_YYYYMMDD
                             , TO_YYYYMMDD
                             , VALID_YN
                             , CREATED_BY
                             , CREATION_DATE
                             , LAST_UPDATED_BY
                             , LAST_UPDATE_DATE )
                        VALUES
                             ( V_LINK_CP_PRIORITY_SEQ
                             , V_LINK_DIVISION_ID
                             , V_PROJECT_CODE
                             , V_SCM_SITE_ID
                             , V_LINK_PLANT_SITE_ID
                             , V_ITEM_ID
                             , TO_NUMBER(V_PRIORITY)
                             , V_FROM_YYYYMMDD
                             , V_TO_YYYYMMDD
                             , V_VALID_YN
                             , V_CREATED_BY
                             , SYSDATE
                             , V_CREATED_BY
                             , SYSDATE );
                    END IF;

                    P_SITE_ITEM_HIST(V_LINK_DIVISION_ID, V_PROJECT_CODE, V_LINK_PLANT_SITE_ID, V_ITEM_ID
                                   , V_S_VALID_YN, V_BPMS_EXIST, V_CREATED_BY, V_CREATION_DATE, V_LAST_UPDATED_BY);

                    P_PRIORITY_HIST(TO_CHAR(V_LINK_CP_PRIORITY_SEQ), V_LINK_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_LINK_PLANT_SITE_ID, V_ITEM_ID
                                  , V_PRIORITY, V_FROM_YYYYMMDD, V_TO_YYYYMMDD, V_VALID_YN
                                  , V_CREATED_BY, V_CREATION_DATE, V_LAST_UPDATED_BY);
                END IF;
                /* 2025/10/24 kimcd [PJ2025F254] JV 동기화 설정 끝 */

                /* CA 수정 begin -------------------------------------------------------------------------- */
                V_CP_OPERATION_GROUP := NULL;

                BEGIN
                    SELECT OPERATION_GROUP
                      INTO V_CP_OPERATION_GROUP
                      FROM SCP_MST_FINAL_ITEM
                     WHERE ITEM_ID = V_ITEM_ID
                       AND ROWNUM  = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_CP_OPERATION_GROUP := NULL;
                END;

                /* 현재 수정하는 내용이 Pack 이 아니면(Cell 이면서 CP 입력/수정때만 CA 수정) */
                IF V_CP_OPERATION_GROUP <> 'P' THEN

                    /* BOM에 해당하는 CA ITEMS (AS-IS #TblSCP0006_SAVE_CA_BOM_ITEMS → _FINAL) */
                    DELETE FROM GT_0006_SAVE_CA_ITEM;

                    IF V_DIVISION_ID = '40' OR V_DIVISION_ID = '82' THEN
                        /* 40, 82 사업부는 PROJECT_CODE, SCM_SITE_ID 모두 '-' */
                        INSERT INTO GT_0006_SAVE_CA_ITEM
                             ( ITEM_ID )
                        SELECT A.CHILD_ITEM_ID
                          FROM SCM_MST_BOM_SN_V A
                             , SCM_MST_SITE_ITEM B
                             , SCM_MST_FINAL_ITEM_V C
                         WHERE A.DIVISION_ID   = B.DIVISION_ID
                           AND A.MODEL_ID      = B.ITEM_ID
                           AND A.DIVISION_ID   = C.DIVISION_ID
                           AND A.CHILD_ITEM_ID = C.ITEM_ID
                           AND A.CHILD_ITEM_ID IN (SELECT XB.PARENT_ITEM_ID
                                                     FROM (SELECT XA.PARENT_ITEM_ID
                                                                , XA.KEY_DATE
                                                                , XA.EFF_END_DATE
                                                                , MAX(XA.KEY_DATE) OVER (PARTITION BY XA.PARENT_ITEM_ID) AS MAX_KEY_DATE
                                                             FROM SCM_MST_BOM_ENG_SN XA
                                                            WHERE XA.DIVISION_ID = V_DIVISION_ID
                                                          ) XB
                                                    WHERE XB.KEY_DATE      = XB.MAX_KEY_DATE
                                                      AND XB.EFF_END_DATE >= SYSDATE)     /* 최신 KEY_DATE 기준 BOM 존재 (AS-IS 상관 EXISTS + MAX 와 같은 결과) */
                           AND C.CELL_TYPE  LIKE 'CA%'           /* CSR : E20250820-000940 복수개의 CA를 모두 찾기위해 로직 변경 */
                           AND C.OPERATION_GROUP_ID <> 'E'
                           AND A.DIVISION_ID   = V_DIVISION_ID
                           AND A.MODEL_ID      = V_ITEM_ID
                         GROUP BY A.CHILD_ITEM_ID;
                    ELSE
                        /* 81 사업부는 PROJECT_CODE, SCM_SITE_ID 지정 */
                        INSERT INTO GT_0006_SAVE_CA_ITEM
                             ( ITEM_ID )
                        SELECT A.CHILD_ITEM_ID
                          FROM SCM_MST_BOM_SN_V A
                             , SCM_MST_SITE_ITEM B
                             , SCM_MST_FINAL_ITEM_V C
                         WHERE A.DIVISION_ID   = B.DIVISION_ID
                           AND A.MODEL_ID      = B.ITEM_ID
                           AND A.DIVISION_ID   = C.DIVISION_ID
                           AND A.CHILD_ITEM_ID = C.ITEM_ID
                           AND A.CHILD_ITEM_ID IN (SELECT XB.PARENT_ITEM_ID
                                                     FROM (SELECT XA.PARENT_ITEM_ID
                                                                , XA.KEY_DATE
                                                                , XA.EFF_END_DATE
                                                                , MAX(XA.KEY_DATE) OVER (PARTITION BY XA.PARENT_ITEM_ID) AS MAX_KEY_DATE
                                                             FROM SCM_MST_BOM_ENG_SN XA
                                                            WHERE XA.DIVISION_ID = V_DIVISION_ID
                                                          ) XB
                                                    WHERE XB.KEY_DATE      = XB.MAX_KEY_DATE
                                                      AND XB.EFF_END_DATE >= SYSDATE)     /* 최신 KEY_DATE 기준 BOM 존재 (AS-IS 상관 EXISTS + MAX 와 같은 결과) */
                           AND C.CELL_TYPE  LIKE 'CA%'
                           AND C.OPERATION_GROUP_ID <> 'E'
                           AND A.DIVISION_ID   = V_DIVISION_ID
                           AND A.MODEL_ID      = V_ITEM_ID
                           AND B.PROJECT_CODE  = V_PROJECT_CODE
                           AND B.SCM_SITE_ID   = V_PLANT_SITE_ID
                         GROUP BY A.CHILD_ITEM_ID;
                    END IF;

                    /* CP에 해당하는 CA 목록 */
                    DELETE FROM GT_0006_SAVE_CA_CURR;

                    INSERT INTO GT_0006_SAVE_CA_CURR
                    SELECT SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL AS PRIORITY_SEQ
                         , A.DIVISION_ID
                         , A.PLANT_SITE_ID
                         , A.SALES_SITE_ID
                         , A.PROJECT_CODE
                         , B.ITEM_ID
                         , A.PRIORITY
                         , A.FROM_YYYYMMDD
                         , A.TO_YYYYMMDD
                         , A.VALID_YN
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
                      FROM GT_0006_SAVE_CP A
                         , GT_0006_SAVE_CA_ITEM B;

                    IF V_CURR_LOOP_CNT = 1 THEN
                        V_CA_ALL_CREATED := 'Y';

                        /* E20250820-000940 CA 업데이트 대상 존재유무 체크 */
                        SELECT SUBSTR(LISTAGG(ITEM_ID, C_DELIM ON OVERFLOW TRUNCATE '' WITHOUT COUNT) WITHIN GROUP (ORDER BY ITEM_ID), 1, 500)
                          INTO V_CA_ITEM_CD_LIST
                          FROM GT_0006_SAVE_CA_CURR;

                        IF V_CA_ITEM_CD_LIST IS NOT NULL THEN
                            V_CA_UPDATE_EXISTS := 1;
                        END IF;
                    END IF;

                    /* 2025/10/24 kimcd [PJ2025F254] JV 동기화 설정 시작 */
                    IF V_LINK_DIVISION_ID IS NOT NULL AND V_LINK_PLANT_SITE_ID IS NOT NULL THEN
                        INSERT INTO GT_0006_SAVE_CA_CURR
                        SELECT SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL AS PRIORITY_SEQ
                             , V_LINK_DIVISION_ID AS DIVISION_ID
                             , V_LINK_PLANT_SITE_ID AS PLANT_SITE_ID
                             , A.SALES_SITE_ID
                             , A.PROJECT_CODE
                             , B.ITEM_ID
                             , A.PRIORITY
                             , A.FROM_YYYYMMDD
                             , A.TO_YYYYMMDD
                             , A.VALID_YN
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
                          FROM GT_0006_SAVE_CP A
                             , GT_0006_SAVE_CA_ITEM B;
                    END IF;
                    /* 2025/10/24 kimcd [PJ2025F254] JV 동기화 설정 끝 */

                    /* AS-IS 는 첫 행이 CA 처리 대상이 아니면 #TblSCP0006_SAVE_CA_ALL 이 없어 여기서 오류로 끝난다 */
                    IF V_CA_ALL_CREATED = 'N' THEN
                        RAISE_APPLICATION_ERROR(-20001, 'Invalid object name ''#TblSCP0006_SAVE_CA_ALL''.');
                    END IF;

                    INSERT INTO GT_0006_SAVE_CA_ALL
                    SELECT *
                      FROM GT_0006_SAVE_CA_CURR;

                    /* CA에 해당하는 HISTORY UPDATE - ITEM (AS-IS #TblSCP0006_SAVE_CA_OLD_ITEM : 수정 전 값) */
                    INSERT INTO SCM_MST_SITE_ITEM_H
                         ( DIVISION_ID
                         , HISTORY_SEQ
                         , PROJECT_CODE
                         , SCM_SITE_ID
                         , ITEM_ID
                         , CURRENCY
                         , LIABILITY_PERIOD
                         , SALES_PLAN_ADJUST_YN
                         , ITEM_HRCY_ID
                         , VALID_YN
                         , BPMS_EXIST
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , HISTORY_CREATION_DATE )
                    SELECT A.DIVISION_ID
                         , SEQ1_SCM_MST_SITE_ITEM_H.NEXTVAL
                         , A.PROJECT_CODE
                         , A.SCM_SITE_ID
                         , A.ITEM_ID
                         , A.CURRENCY
                         , A.LIABILITY_PERIOD
                         , A.SALES_PLAN_ADJUST_YN
                         , A.ITEM_HRCY_ID
                         , A.VALID_YN
                         , A.BPMS_EXIST
                         , A.CREATED_BY
                         , A.CREATION_DATE
                         , A.LAST_UPDATED_BY
                         , A.LAST_UPDATE_DATE
                         , SYSDATE
                      FROM SCM_MST_SITE_ITEM A
                         , GT_0006_SAVE_CA_CURR B
                     WHERE A.DIVISION_ID  = B.DIVISION_ID
                       AND A.PROJECT_CODE = B.PROJECT_CODE
                       AND A.SCM_SITE_ID  = B.PLANT_SITE_ID          /* SCM_MST_SITE_ITEM 는 PLANT_SITE_ID 와 비교 */
                       AND A.ITEM_ID      = B.ITEM_ID;

                    /* CA에 해당하는 ITEM UPATE (AS-IS MERGE 대응) */
                    UPDATE SCM_MST_SITE_ITEM A
                       SET A.LAST_UPDATE_DATE = SYSDATE
                     WHERE EXISTS (SELECT 1
                                     FROM GT_0006_SAVE_CA_CURR XA
                                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                                      AND XA.PROJECT_CODE  = A.PROJECT_CODE
                                      AND XA.PLANT_SITE_ID = A.SCM_SITE_ID
                                      AND XA.ITEM_ID       = A.ITEM_ID);

                    INSERT INTO SCM_MST_SITE_ITEM
                         ( DIVISION_ID
                         , PROJECT_CODE
                         , SCM_SITE_ID
                         , ITEM_ID
                         , CURRENCY
                         , LIABILITY_PERIOD
                         , SALES_PLAN_ADJUST_YN
                         , ITEM_HRCY_ID
                         , VALID_YN
                         , BPMS_EXIST
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    SELECT IA.DIVISION_ID
                         , IA.PROJECT_CODE
                         , IA.PLANT_SITE_ID
                         , IA.ITEM_ID
                         , NULL
                         , NULL
                         , NULL
                         , NULL
                         , 'Y'
                         , 'Y'
                         , NVL(V_CREATED_BY, '-')
                         , SYSDATE
                         , NVL(V_CREATED_BY, '-')
                         , SYSDATE
                      FROM (SELECT DISTINCT
                                   A.DIVISION_ID
                                 , A.PROJECT_CODE
                                 , A.PLANT_SITE_ID
                                 , A.ITEM_ID
                              FROM GT_0006_SAVE_CA_CURR A
                           ) IA
                     WHERE NOT EXISTS (SELECT 1
                                         FROM SCM_MST_SITE_ITEM XB
                                        WHERE XB.DIVISION_ID  = IA.DIVISION_ID
                                          AND XB.PROJECT_CODE = IA.PROJECT_CODE
                                          AND XB.SCM_SITE_ID  = IA.PLANT_SITE_ID
                                          AND XB.ITEM_ID      = IA.ITEM_ID);

                END IF;
                /* CA 수정 end ---------------------------------------------------------------------------- */

            END LOOP;

        END IF;

        /* E20250820-000940 CA 업데이트 대상존재시 ca업데이트 */
        IF V_CA_UPDATE_EXISTS = 1 AND V_CA_ITEM_CD_LIST IS NOT NULL THEN

            V_DIVISION_ID  := F_TOKEN(T_DIVISION_ID , 1);
            V_PROJECT_CODE := F_TOKEN(T_PROJECT_CODE, 1);
            V_SCM_SITE_ID  := F_TOKEN(T_SCM_SITE_ID , 1);
            V_ITEM_ID      := F_TOKEN(T_ITEM_ID     , 1);

            P_SPLIT_TOKEN(TO_CLOB(V_CA_ITEM_CD_LIST), C_DELIM, T_CA_ITEM, V_CA_CNT);

            FOR I IN 1 .. V_CA_CNT
            LOOP
                V_CA_ITEM_ID_NEW := SUBSTR(F_TOKEN(T_CA_ITEM, I), 1, 50);

-- 2026.09.22 AJS CA 아이템이 CP 아이템과 같으면 STEP 1-1 삭제가 앞서 등록한 CP 행을 지운다 (START)
--                IF V_ITEM_ID IS NOT NULL AND V_CA_ITEM_ID_NEW IS NOT NULL THEN
                IF V_ITEM_ID IS NOT NULL AND V_CA_ITEM_ID_NEW IS NOT NULL AND V_CA_ITEM_ID_NEW <> V_ITEM_ID THEN
-- 2026.09.22 AJS (END)

                    /* step 1-1 ca delete */
                    DELETE FROM SCM_MST_SITE_ITEM_PRIORITY
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PROJECT_CODE  = V_PROJECT_CODE
                       AND SALES_SITE_ID = V_SCM_SITE_ID
                       AND ITEM_ID       = V_CA_ITEM_ID_NEW;

                    /* STEP 2 CA INSERT. */
                    INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                         ( PRIORITY_SEQ
                         , DIVISION_ID
                         , PLANT_SITE_ID
                         , SALES_SITE_ID
                         , PROJECT_CODE
                         , ITEM_ID
                         , PRIORITY
                         , FROM_YYYYMMDD
                         , TO_YYYYMMDD
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         , ATTRIBUTE4
                         , ATTRIBUTE5
                         , ATTRIBUTE6
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10 )
                    SELECT SEQ1_SCM_MST_SITE_ITEM_PRIORITY.NEXTVAL
                         , DIVISION_ID
                         , PLANT_SITE_ID
                         , SALES_SITE_ID
                         , PROJECT_CODE
                         , V_CA_ITEM_ID_NEW
                         , PRIORITY
                         , FROM_YYYYMMDD
                         , TO_YYYYMMDD
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         , ATTRIBUTE4
                         , ATTRIBUTE5
                         , ATTRIBUTE6
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10
                      FROM SCM_MST_SITE_ITEM_PRIORITY
                     WHERE DIVISION_ID   = V_DIVISION_ID
                       AND PROJECT_CODE  = V_PROJECT_CODE
                       AND SALES_SITE_ID = V_SCM_SITE_ID
                       AND ITEM_ID       = V_ITEM_ID;

                    /* 2025/10/24 kimcd [PJ2025F254] JV 동기화 설정 시작 */
                    DELETE FROM SCM_MST_SITE_ITEM_PRIORITY A
                     WHERE EXISTS (SELECT 1
                                     FROM GT_0006_SAVE_CA_ALL XA
                                    WHERE XA.DIVISION_ID   = A.DIVISION_ID
                                      AND XA.PLANT_SITE_ID = A.PLANT_SITE_ID
                                      AND XA.PROJECT_CODE  = A.PROJECT_CODE
                                      AND XA.SALES_SITE_ID = A.SALES_SITE_ID
                                      AND XA.ITEM_ID       = A.ITEM_ID
                                      AND XA.DIVISION_ID  <> V_DIVISION_ID
                                      AND XA.PROJECT_CODE  = V_PROJECT_CODE
                                      AND XA.SALES_SITE_ID = V_SCM_SITE_ID
                                      AND XA.ITEM_ID       = V_CA_ITEM_ID_NEW);

                    INSERT INTO SCM_MST_SITE_ITEM_PRIORITY
                         ( PRIORITY_SEQ
                         , DIVISION_ID
                         , PLANT_SITE_ID
                         , SALES_SITE_ID
                         , PROJECT_CODE
                         , ITEM_ID
                         , PRIORITY
                         , FROM_YYYYMMDD
                         , TO_YYYYMMDD
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         , ATTRIBUTE4
                         , ATTRIBUTE5
                         , ATTRIBUTE6
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10 )
                    SELECT PRIORITY_SEQ
                         , DIVISION_ID
                         , PLANT_SITE_ID
                         , SALES_SITE_ID
                         , PROJECT_CODE
                         , ITEM_ID
                         , PRIORITY
                         , FROM_YYYYMMDD
                         , TO_YYYYMMDD
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         , ATTRIBUTE1
                         , ATTRIBUTE2
                         , ATTRIBUTE3
                         , ATTRIBUTE4
                         , ATTRIBUTE5
                         , ATTRIBUTE6
                         , ATTRIBUTE7
                         , ATTRIBUTE8
                         , ATTRIBUTE9
                         , ATTRIBUTE10
                      FROM GT_0006_SAVE_CA_ALL
                     WHERE DIVISION_ID  <> V_DIVISION_ID
                       AND PROJECT_CODE  = V_PROJECT_CODE
                       AND SALES_SITE_ID = V_SCM_SITE_ID
                       AND ITEM_ID       = V_CA_ITEM_ID_NEW;
                    /* 2025/10/24 kimcd [PJ2025F254] JV 동기화 설정 끝 */

                END IF;
            END LOOP;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_LOOP_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG   := SUBSTR(SQLERRM, 1, 4000);
            V_ERR_CODE  := TO_CHAR(SQLCODE);
            V_BACKTRACE := SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 4000);

            ROLLBACK;  /* 입력 데이타 롤백 처리 */

            INSERT INTO SCM_SYS_LOG_BATCH
                 ( PROGRAM_NAME
                 , LOG_TYPE
                 , LOG_COUNT
                 , LOG_MESSAGE
                 , DESCRIPTION
                 , SQL_ERR_CODE
                 , SQL_ERR_MSG
                 , SQL_BACKTRACE
                 , EVENT_DATE
                 , CREATION_DATE
                 , CREATED_BY
                 , LAST_UPDATE_DATE
                 , LAST_UPDATED_BY )
            VALUES
                 ( V_PROGRAM_NAME
                 , 'ERROR'
                 , NULL
                 , V_ERR_MSG
                 , NULL
                 , V_ERR_CODE
                 , V_ERR_MSG
                 , V_BACKTRACE
                 , SYSDATE
                 , SYSDATE
                 , V_PROGRAM_NAME
                 , SYSDATE
                 , V_PROGRAM_NAME );

            COMMIT;

            /* error코드, errror 메시지 반환 */
            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;

    END P_SCP0006_SAVE_PROJECT_ROUTE_PLANT;

END PKG_SCP0006;
