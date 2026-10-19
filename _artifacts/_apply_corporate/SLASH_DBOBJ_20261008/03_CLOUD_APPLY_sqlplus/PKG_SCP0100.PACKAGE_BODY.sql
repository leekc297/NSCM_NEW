-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0100 — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:51:02, 5092줄)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0100
IS
/*
 * Program ID   : PKG_SCP0100
 * Description  : SCP0100 Global PSI Report
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.23   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.07   AJS          [속도] 최종 피벗의 칸별 스칼라 하위질의(칸 수 x 행 수)를 수량 집계 바깥 조인 1회 + CASE 로 변경, 수량 임시 테이블 적재 생략(AUTO · CELL_GROUP_DETAIL 제외 10곳)
 */

    /* 화면 프로그램 · 측정값 시트
       AS-IS 는 측정값 시트명을 'Global PSI NEW' 로 적었고 등록값은 'Global PSI New' 다.
       MSSQL 은 대소문자를 가리지 않아 걸리지만 Oracle 은 갈리므로 견줄 때 UPPER 를 쓴다. */
    C_PROGRAM_ID        CONSTANT VARCHAR2(30)   := 'SCP0100';
    C_SHEET_NAME        CONSTANT VARCHAR2(50)   := 'Global PSI NEW';

    /* 잔량 성격 측정값 : 조회 구간이 모두 0 이어도 행을 남긴다 */
    C_MEASURE_BALANCE   CONSTANT VARCHAR2(400)  :=
        '''AS_INV'',''CELL_CHAR_AVAILABLE'',''CELL_EOH'',''CELL_FORM_PROGRESS'',''INTRANSIT'',''PACK_CELL_EOH'',''PACK_EOH'',''SEMI_INTRANSIT'',''TO_SITE_EOH''';

    /*******************************************************************************
     * FN_ORDER_EXPR
     *   AS-IS 정렬규칙(Latin1_General_CI_AS)은 대소문자와 하이픈을 무시하고
     *   밑줄을 글자·숫자보다 앞에 둔다. Oracle 기본 정렬은 셋 다 다르므로
     *   문자 칸을 UPPER(TRANSLATE(칸,'_-','/')) 로 바꿔 견주고 원본을 2차 키로 둔다.
     *   정렬 칸에 '/' 가 0건인 것을 실측으로 확인했다.
     *   숫자 칸은 바꾸지 않는다.
     *******************************************************************************/
    FUNCTION FN_ORDER_EXPR
    (
        P_COLS  IN VARCHAR2
    )
    RETURN VARCHAR2
    IS

        C_NUMBER_COLS   CONSTANT VARCHAR2(200) := ',SORT_ORDER_NO,CELL_GROUP_SORT_ORDER_NO,DISPLAY_SEQ,INV_SORT,CELL_CF,';

        V_RESULT        VARCHAR2(4000);
        V_TOKEN         VARCHAR2(200);
        V_COL           VARCHAR2(200);
        V_DESC_YN       VARCHAR2(1);
        V_EXPR          VARCHAR2(600);
        V_IDX           PLS_INTEGER := 1;

    BEGIN

        LOOP

            V_TOKEN := TRIM(REGEXP_SUBSTR(P_COLS, '[^,]+', 1, V_IDX));

            EXIT WHEN V_TOKEN IS NULL;

            IF UPPER(V_TOKEN) LIKE '% DESC' THEN
                V_COL     := TRIM(SUBSTR(V_TOKEN, 1, LENGTH(V_TOKEN) - 5));
                V_DESC_YN := 'Y';
            ELSE
                V_COL     := V_TOKEN;
                V_DESC_YN := 'N';
            END IF;

            IF INSTR(C_NUMBER_COLS, ',' || UPPER(V_COL) || ',') > 0 THEN
                /* 숫자 칸 */
                IF V_DESC_YN = 'Y' THEN
                    V_EXPR := V_COL || ' DESC NULLS LAST';
                ELSE
                    V_EXPR := V_COL || ' NULLS FIRST';
                END IF;
            ELSE
                /* 문자 칸 */
                IF V_DESC_YN = 'Y' THEN
                    V_EXPR := 'UPPER(TRANSLATE(' || V_COL || ', ''_-'', ''/'')) DESC NULLS LAST'
                           || ', ' || V_COL || ' DESC NULLS LAST';
                ELSE
                    V_EXPR := 'UPPER(TRANSLATE(' || V_COL || ', ''_-'', ''/'')) NULLS FIRST'
                           || ', ' || V_COL || ' NULLS FIRST';
                END IF;
            END IF;

            IF V_RESULT IS NULL THEN
                V_RESULT := V_EXPR;
            ELSE
                V_RESULT := V_RESULT || CHR(10) || '        , ' || V_EXPR;
            END IF;

            V_IDX := V_IDX + 1;

        END LOOP;

        RETURN V_RESULT;

    END FN_ORDER_EXPR;

    /*******************************************************************************
     * PR_GET_REPORT_TERM_INFO
     *   AS-IS FN_GET_REPORT_TERM_INFO (멀티스테이트먼트 TVF, 한 행 반환)
     *   호출처가 SCP0100 두 프로시저뿐이라 패키지 내부 프로시저로 흡수한다.
     *******************************************************************************/
    PROCEDURE PR_GET_REPORT_TERM_INFO
    (
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , O_PLAN_FROM_YYYYMMDD    OUT VARCHAR2
      , O_PLAN_TO_YYYYMMDD      OUT VARCHAR2
      , O_PLAN_FROM_YYYYMM      OUT VARCHAR2
      , O_PLAN_TO_YYYYMM        OUT VARCHAR2
      , O_RESULT_FROM_YYYYMMDD  OUT VARCHAR2
      , O_RESULT_TO_YYYYMMDD    OUT VARCHAR2
      , O_PLAN_PARTIAL_FROM_WW  OUT VARCHAR2
      , O_PLAN_PARTIAL_TO_WW    OUT VARCHAR2
      , O_PLAN_ISO_FROM_WW      OUT VARCHAR2
      , O_PLAN_ISOL_TO_WW       OUT VARCHAR2
    )
    IS

        V_PLAN_FROM_YYYYMMDD    VARCHAR2(32);
        V_PLAN_TO_YYYYMMDD      VARCHAR2(32);
        V_PLAN_FROM_YYYYMM      VARCHAR2(32);
        V_PLAN_TO_YYYYMM        VARCHAR2(32);
        V_RESULT_FROM_YYYYMMDD  VARCHAR2(32);
        V_RESULT_TO_YYYYMMDD    VARCHAR2(32);
        V_PLAN_FROM_PARTIAL_WW  VARCHAR2(32);
        V_PLAN_TO_PARTIAL_WW    VARCHAR2(32);
        V_PLAN_FROM_ISO_WW      VARCHAR2(32);
        V_PLAN_TO_ISO_WW        VARCHAR2(32);

    BEGIN

        BEGIN
            SELECT BASIS_START_DATE
              INTO V_PLAN_FROM_YYYYMMDD
              FROM SCM_SYS_CALENDAR_M
             WHERE 1 = 1
               AND BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_PLAN_FROM_YYYYMMDD := NULL;   /* AS-IS 는 대입이 일어나지 않아 초기값 '' 이 남는다 */
        END;

        BEGIN
            SELECT BASIS_START_DATE
              INTO V_RESULT_FROM_YYYYMMDD
              FROM SCM_SYS_CALENDAR_M
             WHERE 1 = 1
               AND BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_RESULT_FROM_YYYYMMDD := NULL;
        END;

        BEGIN
            SELECT BASIS_START_DATE
              INTO V_RESULT_TO_YYYYMMDD
              FROM SCM_SYS_CALENDAR_M
             WHERE 1 = 1
               AND BASIS_YYYYMMDD = P_TO_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_RESULT_TO_YYYYMMDD := NULL;
        END;

        /* AS-IS 분기 그대로. 첫 두 갈래가 전 구간을 덮어 뒤 두 갈래는 타지 않는다 */
        IF V_PLAN_FROM_YYYYMMDD > V_RESULT_FROM_YYYYMMDD THEN

            /* 실적 보여줌 */
            V_PLAN_TO_YYYYMMDD     := P_TO_YYYYMMDD;
            V_RESULT_TO_YYYYMMDD   := V_PLAN_FROM_YYYYMMDD;

        ELSIF V_PLAN_FROM_YYYYMMDD <= V_RESULT_FROM_YYYYMMDD THEN

            /* 실적 없음 */
            V_PLAN_TO_YYYYMMDD     := P_TO_YYYYMMDD;
            V_RESULT_FROM_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'),  6), 'YYYYMMDD');
            V_RESULT_TO_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');

        ELSIF V_PLAN_FROM_YYYYMMDD > V_RESULT_TO_YYYYMMDD THEN

            V_PLAN_FROM_YYYYMMDD   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_PLAN_TO_YYYYMMDD     := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
            V_RESULT_FROM_YYYYMMDD := P_FROM_YYYYMMDD;
            V_RESULT_TO_YYYYMMDD   := P_TO_YYYYMMDD;

        ELSIF V_PLAN_FROM_YYYYMMDD = V_RESULT_TO_YYYYMMDD THEN

            V_PLAN_TO_YYYYMMDD     := V_PLAN_FROM_YYYYMMDD;
            V_RESULT_FROM_YYYYMMDD := P_FROM_YYYYMMDD;
            V_RESULT_TO_YYYYMMDD   := P_TO_YYYYMMDD;

        END IF;

        V_PLAN_FROM_YYYYMM := SUBSTR(P_FROM_YYYYMMDD, 1, 6);
        V_PLAN_TO_YYYYMM   := SUBSTR(P_TO_YYYYMMDD,   1, 6);

        SELECT MIN(WW)
             , MAX(WW)
          INTO V_PLAN_FROM_PARTIAL_WW
             , V_PLAN_TO_PARTIAL_WW
          FROM ( SELECT SUBSTR(ISO_YYYYWW, 1, 4) || SUBSTR(PARTIAL_WEEK_NAME, 2, 3) AS WW
                   FROM SCM_SYS_CALENDAR_M
                  WHERE 1 = 1
                    AND BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                    AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                  GROUP BY SUBSTR(ISO_YYYYWW, 1, 4) || SUBSTR(PARTIAL_WEEK_NAME, 2, 3)
               )  IA;

        SELECT MIN(ISO_YYYYWW)
             , MAX(ISO_YYYYWW)
          INTO V_PLAN_FROM_ISO_WW
             , V_PLAN_TO_ISO_WW
          FROM ( SELECT ISO_YYYYWW
                   FROM SCM_SYS_CALENDAR_M
                  WHERE 1 = 1
                    AND BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                    AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                  GROUP BY ISO_YYYYWW
               )  IA;

        O_PLAN_FROM_YYYYMMDD   := V_PLAN_FROM_YYYYMMDD;
        O_PLAN_TO_YYYYMMDD     := V_PLAN_TO_YYYYMMDD;
        O_PLAN_FROM_YYYYMM     := V_PLAN_FROM_YYYYMM;
        O_PLAN_TO_YYYYMM       := V_PLAN_TO_YYYYMM;
        O_RESULT_FROM_YYYYMMDD := V_RESULT_FROM_YYYYMMDD;
        O_RESULT_TO_YYYYMMDD   := V_RESULT_TO_YYYYMMDD;
        O_PLAN_PARTIAL_FROM_WW := V_PLAN_FROM_PARTIAL_WW;
        O_PLAN_PARTIAL_TO_WW   := V_PLAN_TO_PARTIAL_WW;
        O_PLAN_ISO_FROM_WW     := V_PLAN_FROM_ISO_WW;
        O_PLAN_ISOL_TO_WW      := V_PLAN_TO_ISO_WW;

    END PR_GET_REPORT_TERM_INFO;

    /*******************************************************************************
     * PR_SET_FINAL_COLS
     *   AS-IS 가 FN_GET_REPORT_USER_COLUMNS 결과로 조회 칸 목록과 정렬 칸 목록을
     *   문자열로 조립하고 치환하는 구간. WW · MM 이 같아 내부 프로시저로 둔다.
     *******************************************************************************/
    PROCEDURE PR_SET_FINAL_COLS
    (
        P_USER_ID           IN  VARCHAR2
      , P_SEARCH_LEVEL      IN  VARCHAR2
      , O_SHEET_NAME        OUT VARCHAR2
      , O_FINAL_COLS        OUT VARCHAR2
      , O_FINAL_ORDER_COLS  OUT VARCHAR2
    )
    IS

        V_SHEET_NAME        VARCHAR2(50);
        V_FINAL_COLS        VARCHAR2(4000);
        V_FINAL_ORDER_COLS  VARCHAR2(4000);

    BEGIN

        IF UPPER(P_SEARCH_LEVEL) IN ('DETAIL', 'AUTO') THEN
            V_SHEET_NAME := 'REPORT';
        ELSE
            V_SHEET_NAME := 'SEARCH_LEVEL';
        END IF;

        /* AS-IS 는 누적 대입 SELECT 로 ',' 를 앞에 붙여 이어 붙인다 */
        FOR R IN ( SELECT COLUMN_NAME
                     FROM TABLE(FN_GET_REPORT_USER_COLUMNS(C_PROGRAM_ID, V_SHEET_NAME, P_USER_ID))
                    ORDER BY USER_SORT_ORDER_NO
                 )
        LOOP
            V_FINAL_COLS       := V_FINAL_COLS       || ',' || R.COLUMN_NAME;
            V_FINAL_ORDER_COLS := V_FINAL_ORDER_COLS || ',' || R.COLUMN_NAME;
        END LOOP;

        /* 맨 앞 ',' 제거 */
        V_FINAL_COLS       := SUBSTR(V_FINAL_COLS,       2, LENGTH(V_FINAL_COLS)       - 1);
        V_FINAL_ORDER_COLS := SUBSTR(V_FINAL_ORDER_COLS, 2, LENGTH(V_FINAL_ORDER_COLS) - 1);

        V_FINAL_COLS := REPLACE(V_FINAL_COLS, 'MEASURE_NAME', 'SORT_ORDER_NO,MEASURE_NAME');
        V_FINAL_COLS := REPLACE(V_FINAL_COLS, ',CELL_GROUP',  ',CELL_GROUP_SORT_ORDER_NO,CELL_GROUP');

        V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, ',MEASURE_GROUP',  '');
        V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, 'MEASURE_NAME',    'SORT_ORDER_NO,MEASURE_NAME');
        V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, 'OPERATION_GROUP', 'OPERATION_GROUP DESC');
        V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, 'OPERATION_ID',    'OPERATION_ID DESC');
        V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, ',CELL_GROUP',     ',CELL_GROUP_SORT_ORDER_NO,CELL_GROUP');

        IF UPPER(P_SEARCH_LEVEL) IN ('CELL_GROUP', 'CELL_GROUP_DETAIL') THEN
            V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, 'DIVISION_ID', 'DIVISION_ID,INV_SORT');
            /* INV_SORT 가 추가되어 필요없어짐 */
            V_FINAL_ORDER_COLS := REPLACE(V_FINAL_ORDER_COLS, ',CELL_GROUP_SORT_ORDER_NO', '');
        END IF;

        IF UPPER(P_SEARCH_LEVEL) IN ('DETAIL', 'AUTO') THEN
            V_FINAL_COLS       := V_FINAL_COLS       || ',DISPLAY_SEQ';
            V_FINAL_ORDER_COLS := V_FINAL_ORDER_COLS || ',DISPLAY_SEQ';
        END IF;

        O_SHEET_NAME       := V_SHEET_NAME;
        O_FINAL_COLS       := V_FINAL_COLS;
        O_FINAL_ORDER_COLS := V_FINAL_ORDER_COLS;

    END PR_SET_FINAL_COLS;

    /*******************************************************************************
     * P_SCP0100_GET_PLAN_DATE
     *   AS-IS SCP0100_GET_PLAN_DATE
     *   AS-IS 는 #TMP_PLAN 을 만든 뒤 버킷 갈래에서 한 번만 참조하므로 인라인 뷰로 옮긴다.
     *******************************************************************************/
    PROCEDURE P_SCP0100_GET_PLAN_DATE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_ERR_MSG   VARCHAR2(4000);

    BEGIN

        IF UPPER(P_PROGRAM_ID) = 'SCP0100' THEN

            IF UPPER(P_BUCKET) = 'MONTHLY' THEN

                OPEN O_RC1 FOR
                    SELECT CODE
                         , NAME
                      FROM ( SELECT A.PLAN_START_YYYYMMDD AS CODE
                                  , CASE
                                      WHEN XA.FP_TARGET_YN = 'Y'
                                      THEN TO_CHAR(FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD), 'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')'
                                      ELSE TO_CHAR(FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD), 'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')' || ' (No Plan)'
                                    END AS NAME
                               FROM SCP_PLAN_VERSION_V          A
                                  , SCM_SYS_CALENDAR_M          B
                                  , ( SELECT DIVISION_ID                    /* 고도화 */
                                           , PLAN_START_YYYYMMDD
                                           , FP_TARGET_YN
                                           , MRP_TARGET_YN
                                           , DM_RTF_YN
                                        FROM SCP_PLN_INTERFACE_YN
                                       WHERE 1 = 1
                                         AND ( TRIM(P_DIVISION_ID) IS NULL
                                               OR UPPER(DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
                                             )
                                         AND DIVISION_ID LIKE '81%'
                                    )  XA
                              WHERE B.BASIS_YYYYMMDD            = A.PLAN_START_YYYYMMDD
                                AND XA.PLAN_START_YYYYMMDD(+)   = A.PLAN_START_YYYYMMDD
                                AND XA.FP_TARGET_YN             = 'Y'
                                AND ( TRIM(P_DIVISION_ID) IS NULL OR UPPER(A.DIVISION_ID) = UPPER(P_DIVISION_ID) )
                              GROUP BY A.PLAN_START_YYYYMMDD
                                     , B.WEEK_NAME
                                     , XA.FP_TARGET_YN
                           )  IA
                     WHERE CODE IN ( SELECT DISTINCT PLAN_START_YYYYMMDD
                                       FROM SCP_RPT_GLOBAL_PSI_MD_MM )
                     ORDER BY CODE DESC;

            ELSIF UPPER(P_BUCKET) = 'WEEKLY' THEN

                OPEN O_RC1 FOR
                    SELECT CODE
                         , NAME
                      FROM ( SELECT A.PLAN_START_YYYYMMDD AS CODE
                                  , CASE
                                      WHEN XA.FP_TARGET_YN = 'Y'
                                      THEN TO_CHAR(FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD), 'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')'
                                      ELSE TO_CHAR(FN_CHAR_TO_DATE(A.PLAN_START_YYYYMMDD), 'YYYY-MM-DD') || ' (' || B.WEEK_NAME || ')' || ' (No Plan)'
                                    END AS NAME
                               FROM SCP_PLAN_VERSION_V          A
                                  , SCM_SYS_CALENDAR_M          B
                                  , ( SELECT DIVISION_ID                    /* 고도화 */
                                           , PLAN_START_YYYYMMDD
                                           , FP_TARGET_YN
                                           , MRP_TARGET_YN
                                           , DM_RTF_YN
                                        FROM SCP_PLN_INTERFACE_YN
                                       WHERE 1 = 1
                                         AND ( TRIM(P_DIVISION_ID) IS NULL
                                               OR UPPER(DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
                                             )
                                         AND DIVISION_ID LIKE '81%'
                                    )  XA
                              WHERE B.BASIS_YYYYMMDD            = A.PLAN_START_YYYYMMDD
                                AND XA.PLAN_START_YYYYMMDD(+)   = A.PLAN_START_YYYYMMDD
                                AND XA.FP_TARGET_YN             = 'Y'
                                AND ( TRIM(P_DIVISION_ID) IS NULL OR UPPER(A.DIVISION_ID) = UPPER(P_DIVISION_ID) )
                              GROUP BY A.PLAN_START_YYYYMMDD
                                     , B.WEEK_NAME
                                     , XA.FP_TARGET_YN
                           )  IA
                     WHERE CODE IN ( SELECT DISTINCT PLAN_START_YYYYMMDD
                                       FROM SCP_RPT_GLOBAL_PSI_MD_WW )
                     ORDER BY CODE DESC;

            END IF;

        END IF;

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0100_GET_PLAN_DATE;

    /*******************************************************************************
     * P_SCP0100_GET_SHEET_CALENDAR_3SPAN
     *   AS-IS SCP0100_GET_SHEET_CALENDAR_3SPAN
     *   AS-IS 본문 앞부분의 주석 구간(DEFAULT · 1차 · 2차 · 3차 적용)은 옮기지 않고
     *   실제로 실행되는 마지막 문장만 옮긴다.
     *******************************************************************************/
    PROCEDURE P_SCP0100_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_ERR_MSG   VARCHAR2(4000);

    BEGIN

        OPEN O_RC1 FOR
            SELECT COLUMN_NAME
                 , COLUMN_LABEL_NAME
                 , SMALL_CLASS_LABEL_NAME
                 , LARGE_CLASS_LABEL_NAME
                 , DAY_CODE
                 , SORT_ORDER_NO
              FROM ( SELECT 'W_' || WEEK_KEY   AS COLUMN_NAME
                          , WEEK_KEY           AS COLUMN_LABEL_NAME
                          , SMALL_CLASS_LABEL_NAME
                          , LARGE_CLASS_LABEL_NAME
                          , DAY_CODE
                          , SORT_ORDER_NO
                       FROM ( SELECT SUBSTR(ISO_YYYYWW, 1, 4) || SUBSTR(PARTIAL_WEEK_NAME, 2, 3)  AS WEEK_KEY
                                   , CASE
                                       WHEN MAX(SUBSTR(PARTIAL_WEEK_NAME, 4, 1)) IS NOT NULL
                                       THEN MAX(SUBSTR(PARTIAL_WEEK_NAME, 1, 3) || '_' || SUBSTR(PARTIAL_WEEK_NAME, 4, 1))
                                       ELSE MAX(PARTIAL_WEEK_NAME)
                                     END                                                          AS SMALL_CLASS_LABEL_NAME
                                   , MAX(MONTH_NAME)                                              AS LARGE_CLASS_LABEL_NAME
                                   , MIN(BASIS_START_DATE)                                        AS DAY_CODE
                                   , MIN(BASIS_START_DATE) || '21'                                AS SORT_ORDER_NO
                                FROM SCM_SYS_CALENDAR_M
                               WHERE BASIS_YYYYMMDD >= P_START_YYYYMMDD
                                 AND BASIS_YYYYMMDD <= P_END_YYYYMMDD
                               GROUP BY SUBSTR(ISO_YYYYWW, 1, 4) || SUBSTR(PARTIAL_WEEK_NAME, 2, 3)
                            )  XA
                     UNION ALL
                     SELECT 'M_' || BASIS_YYYYMM                                                  AS COLUMN_NAME
                          , MONTH_NAME                                                            AS COLUMN_LABEL_NAME
                          , MONTH_NAME                                                            AS SMALL_CLASS_LABEL_NAME
                          , MONTH_NAME                                                            AS LARGE_CLASS_LABEL_NAME
                          , MIN(BASIS_START_DATE)                                                 AS DAY_CODE
                          , MIN(BASIS_START_DATE) || '02'                                         AS SORT_ORDER_NO
                       FROM SCM_SYS_CALENDAR_M
                      WHERE BASIS_YYYYMMDD >= P_START_YYYYMMDD
                        AND BASIS_YYYYMMDD <= P_END_YYYYMMDD
                      GROUP BY BASIS_YYYYMM
                             , MONTH_NAME
                   )  IA
             ORDER BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0100_GET_SHEET_CALENDAR_3SPAN;

    /*******************************************************************************
     * P_SCP0100_GET_SITE
     *   AS-IS SCP0100_GET_SITE
     *   TO_SITE 는 소문자가 섞인 칸이라(실측 9.1%) 정렬을 AS-IS 규칙으로 맞춘다.
     *   FROM_SITE 는 소문자 0건이지만 하이픈·밑줄이 있어 정렬식은 같게 둔다.
     *******************************************************************************/
    PROCEDURE P_SCP0100_GET_SITE
    (
        P_SITE_TPYE             IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_ERR_MSG   VARCHAR2(4000);

    BEGIN

        IF UPPER(P_SITE_TPYE) = 'FROM_SITE' THEN

            IF UPPER(P_BUCKET) = 'MONTHLY' THEN

                OPEN O_RC1 FOR
                    SELECT FROM_SITE AS CODE
                         , FROM_SITE AS NAME
                      FROM SCP_RPT_GLOBAL_PSI_MD_MM
                     WHERE 1 = 1
                       AND ( TRIM(P_DIVISION_ID) IS NULL OR DIVISION_ID IN ( SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) ) )
                       AND DIVISION_ID LIKE '81%'
                     GROUP BY FROM_SITE
                     ORDER BY UPPER(TRANSLATE(FROM_SITE, '_-', '/')) NULLS FIRST
                            , FROM_SITE NULLS FIRST;

            ELSIF UPPER(P_BUCKET) = 'WEEKLY' THEN

                OPEN O_RC1 FOR
                    SELECT FROM_SITE AS CODE
                         , FROM_SITE AS NAME
                      FROM SCP_RPT_GLOBAL_PSI_MD_WW
                     WHERE 1 = 1
                       AND ( TRIM(P_DIVISION_ID) IS NULL OR DIVISION_ID IN ( SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) ) )
                       AND DIVISION_ID LIKE '81%'
                     GROUP BY FROM_SITE
                     ORDER BY UPPER(TRANSLATE(FROM_SITE, '_-', '/')) NULLS FIRST
                            , FROM_SITE NULLS FIRST;

            END IF;

        ELSIF UPPER(P_SITE_TPYE) = 'TO_SITE' THEN

            IF UPPER(P_BUCKET) = 'MONTHLY' THEN

                OPEN O_RC1 FOR
                    SELECT TO_SITE AS CODE
                         , TO_SITE AS NAME
                      FROM SCP_RPT_GLOBAL_PSI_MD_MM
                     WHERE 1 = 1
                       AND ( TRIM(P_DIVISION_ID) IS NULL OR DIVISION_ID IN ( SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) ) )
                       AND DIVISION_ID LIKE '81%'
                     GROUP BY TO_SITE
                     ORDER BY UPPER(TRANSLATE(TO_SITE, '_-', '/')) NULLS FIRST
                            , TO_SITE NULLS FIRST;

            ELSIF UPPER(P_BUCKET) = 'WEEKLY' THEN

                OPEN O_RC1 FOR
                    SELECT TO_SITE AS CODE
                         , TO_SITE AS NAME
                      FROM SCP_RPT_GLOBAL_PSI_MD_WW
                     WHERE 1 = 1
                       AND ( TRIM(P_DIVISION_ID) IS NULL OR DIVISION_ID IN ( SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) ) )
                       AND DIVISION_ID LIKE '81%'
                     GROUP BY TO_SITE
                     ORDER BY UPPER(TRANSLATE(TO_SITE, '_-', '/')) NULLS FIRST
                            , TO_SITE NULLS FIRST;

            END IF;

        END IF;

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0100_GET_SITE;

    /*******************************************************************************
     * P_SCP0100_GET_GLOBAL_PSI_REPORT
     *   AS-IS SCP0100_GET_GLOBAL_PSI_REPORT (버킷에 따라 갈라 부르는 프로시저)
     *   AS-IS 는 V1.2.1 에서 only data 옵션을 없애 _WW · _MM 이 아니라
     *   _WW_DATAONLY · _MM_DATAONLY 를 부른다.
     *******************************************************************************/
    PROCEDURE P_SCP0100_GET_GLOBAL_PSI_REPORT
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CELL_GROUP            IN  VARCHAR2
      , P_PROJECT               IN  VARCHAR2
      , P_SEARCH_LEVEL          IN  VARCHAR2
      , P_CHK_CELL_QTY          IN  VARCHAR2
      , P_CHK_AS                IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
    BEGIN

        IF UPPER(P_BUCKET) = 'WEEKLY' THEN

            P_SCP0100_GET_GLOBAL_PSI_REPORT_WW_DATAONLY
            (
                P_FROM_YYYYMMDD         => P_FROM_YYYYMMDD
              , P_TO_YYYYMMDD           => P_TO_YYYYMMDD
              , P_DIVISION_ID           => P_DIVISION_ID
              , P_ITEM_ID               => P_ITEM_ID
              , P_NICK_NAME             => P_NICK_NAME
              , P_FROM_SITE             => P_FROM_SITE
              , P_TO_SITE               => P_TO_SITE
              , P_PLAN_START_YYYYMMDD   => P_PLAN_START_YYYYMMDD
              , P_PLAN_TYPE             => P_PLAN_TYPE
              , P_USER_ID               => P_USER_ID
              , P_BUCKET                => P_BUCKET
              , P_CELL_GROUP            => P_CELL_GROUP
              , P_PROJECT               => P_PROJECT
              , P_SEARCH_LEVEL          => P_SEARCH_LEVEL
              , P_CHK_CELL_QTY          => P_CHK_CELL_QTY
              , P_CHK_AS                => P_CHK_AS
              , DEBUG_MODE              => DEBUG_MODE
              , O_RC1                   => O_RC1
              , O_RESULT_CURSOR         => O_RESULT_CURSOR
            );

        ELSIF UPPER(P_BUCKET) = 'MONTHLY' THEN

            P_SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY
            (
                P_FROM_YYYYMMDD         => P_FROM_YYYYMMDD
              , P_TO_YYYYMMDD           => P_TO_YYYYMMDD
              , P_DIVISION_ID           => P_DIVISION_ID
              , P_ITEM_ID               => P_ITEM_ID
              , P_NICK_NAME             => P_NICK_NAME
              , P_FROM_SITE             => P_FROM_SITE
              , P_TO_SITE               => P_TO_SITE
              , P_PLAN_START_YYYYMMDD   => P_PLAN_START_YYYYMMDD
              , P_PLAN_TYPE             => P_PLAN_TYPE
              , P_USER_ID               => P_USER_ID
              , P_BUCKET                => P_BUCKET
              , P_CELL_GROUP            => P_CELL_GROUP
              , P_PROJECT               => P_PROJECT
              , P_SEARCH_LEVEL          => P_SEARCH_LEVEL
              , P_CHK_CELL_QTY          => P_CHK_CELL_QTY
              , P_CHK_AS                => P_CHK_AS
              , DEBUG_MODE              => DEBUG_MODE
              , O_RC1                   => O_RC1
              , O_RESULT_CURSOR         => O_RESULT_CURSOR
            );

        ELSE

            /* AS-IS 는 두 갈래 밖에서는 아무것도 돌려주지 않는다 */
            OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

        END IF;

    END P_SCP0100_GET_GLOBAL_PSI_REPORT;

    /*******************************************************************************
     * P_SCP0100_GET_GLOBAL_PSI_REPORT_WW_DATAONLY
     *   AS-IS SCP0100_GET_GLOBAL_PSI_REPORT_WW_DATAONLY (주단위)
     *
     *   [동적 SQL 을 남긴 사유]
     *     최종 결과의 수량 칸이 조회 구간의 주차 수만큼 생기는 피벗이라(W_202401 …)
     *     컬럼 자체가 가변이다. 이 구간만 동적 SQL 로 두고 나머지는 정적 SQL 로 옮겼다.
     *
     *   [AS-IS 대비 조치]
     *     1. 측정값 시트명 : 코드 'Global PSI NEW' ↔ 등록값 'Global PSI New'.
     *        MSSQL 은 대소문자를 가리지 않아 걸리지만 Oracle 은 갈려 측정값이 0건이 된다. UPPER 로 견준다.
     *     2. MEASURE_GROUP LIKE 'SALES%' · 'PACK%' · 'CELL%' (CELL_GROUP_DETAIL 정렬) :
     *        등록값이 'Sales PSI' · 'Pack PSI' · 'Cell PSI' 라 Oracle 에서는 하나도 걸리지 않는다. UPPER 로 견준다.
     *     3. VARIOUS_KEY != '' (LINE 적재 조건) : Oracle 에서 빈 문자는 NULL 이라 전건이 빠진다. TRIM(…) IS NOT NULL 로 바꾼다.
     *     4. 정렬 : AS-IS 정렬규칙 Latin1_General_CI_AS 는 대소문자·하이픈을 무시하고 밑줄을 앞에 둔다.
     *        FN_ORDER_EXPR 로 UPPER(TRANSLATE(칸,'_-/','/')) 를 1차 키, 원본을 2차 키로 둔다.
     *     5. 조회조건 대소문자 : AS-IS 는 CI 라 입력값 대소문자를 가리지 않는다. 칸·파라미터 모두 UPPER 로 견준다.
     *     6. 선택 조건 빈값 판정 : (@p IS NULL OR @p = '') 를 TRIM(P) IS NULL 로 바꿔 공백만 입력도 조건 없음으로 본다.
     *
     *   [AS-IS 에 그대로 남긴 결함 — 원문 보존]
     *     1. CHARINDEX(OPERATION_GROUP,'Lv1') 은 인자 순서가 뒤바뀌어 항상 0 이다(CELL_GROUP_DETAIL 정렬).
     *     2. IIF(MAX(SCP_OPERATION_GROUP)='P9500','PACK','MODULE') 은 SCP_OPERATION_GROUP 이 'A'·'P' 라 항상 'MODULE' 이다.
     *     3. AUTO 갈래의 @cntVarious 는 제외 목록에 VARIOUS_KEY 가 있어 항상 0 이므로 운송수단 룩업이 언제나 비워진다.
     *     4. @v_final_sum_wheres 는 조립한 직후 빈 문자로 덮여 최종 SQL 에 쓰이지 않는다. @v_day_cols 도 쓰이지 않는다.
     *        되풀이 문자열 연결만 남는 구간이라 조립을 옮기지 않았다(결과 동일).
     *******************************************************************************/
    PROCEDURE P_SCP0100_GET_GLOBAL_PSI_REPORT_WW_DATAONLY
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CELL_GROUP            IN  VARCHAR2
      , P_PROJECT               IN  VARCHAR2
      , P_SEARCH_LEVEL          IN  VARCHAR2
      , P_CHK_CELL_QTY          IN  VARCHAR2
      , P_CHK_AS                IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_SHEET_NAME            VARCHAR2(50);           /* 조회 칸 시트 (REPORT · SEARCH_LEVEL) */
        V_FINAL_COLS            VARCHAR2(4000);         /* 최종 조회 칸 목록 */
        V_FINAL_ORDER_COLS      VARCHAR2(4000);         /* 최종 정렬 칸 목록 */
        V_FINAL_SUM_COLS        CLOB;                   /* 주차별 수량 칸 집계식 */
        V_QTY_COLS              CLOB;                   /* 주차별 수량 칸 조회식 */
        V_COL_LIST              VARCHAR2(4000);         /* AUTO 갈래 사용자 칸 목록 */
        V_COL_LIST2             VARCHAR2(4000);
        V_COL_LIST_AUTO         VARCHAR2(4000);
        V_COL_WHERE             VARCHAR2(4000);
        V_COL_WHERE_COUNT       VARCHAR2(4000);
        V_CNT_VARIOUS           PLS_INTEGER := 0;

        V_FROM_YYYYMMDD         VARCHAR2(32);
        V_TO_YYYYMMDD           VARCHAR2(32);
        V_FROM_YYYYMM           VARCHAR2(32);
        V_TO_YYYYMM             VARCHAR2(32);
        V_FROM_RESULT           VARCHAR2(32);
        V_TO_RESULT             VARCHAR2(32);
        V_FROM_WW               VARCHAR2(32);
        V_TO_WW                 VARCHAR2(32);
        V_ISO_FROM_WW           VARCHAR2(32);
        V_ISO_TO_WW             VARCHAR2(32);

        V_SQL                   CLOB;
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        /* 세션에 남은 임시 자료 정리 */
        DELETE GT_SCP0100_MEASURE;
        DELETE GT_SCP0100_MEASURE1;
        DELETE GT_SCP0100_MEASURE2;
        DELETE GT_SCP0100_MEASURE3;
        DELETE GT_SCP0100_PRODUCTLEVEL;
        DELETE GT_SCP0100_OPERATION;
        DELETE GT_SCP0100_RAW;
        DELETE GT_SCP0100_CELL_GROUP_SORT_ORDER;
        DELETE GT_SCP0100_DIO_DETAIL_RAW;
        DELETE GT_SCP0100_DAYCOLS;
        DELETE GT_SCP0100_TRANSPORT_MODE_CODE;
        DELETE GT_SCP0100_LINE;
        DELETE GT_SCP0100_USER_COLS;
        DELETE GT_SCP0100_QTY_AUTO;
        DELETE GT_SCP0100_QTY_DETAIL;
        DELETE GT_SCP0100_QTY_CELL_GROUP;
        DELETE GT_SCP0100_QTY_CELL_GROUP_DETAIL;
        DELETE GT_SCP0100_QTY_PRODUCT_LEVEL1;
        DELETE GT_SCP0100_QTY_PRODUCT_LEVEL2;
        DELETE GT_SCP0100_QTY_PRODUCT_LEVEL3;
        DELETE GT_SCP0100_RAW_CELL_CF;
        DELETE GT_SCP0100_ALL_MEASURE_UI;
        DELETE GT_SCP0100_ALL_VARIOUS_KEY;
        DELETE GT_SCP0100_ALL_DISPLAY_SEQ;
        DELETE GT_SCP0100_ALL;

        /* 조회 칸 목록 · 정렬 칸 목록 */
        PR_SET_FINAL_COLS
        (
            P_USER_ID           => P_USER_ID
          , P_SEARCH_LEVEL      => P_SEARCH_LEVEL
          , O_SHEET_NAME        => V_SHEET_NAME
          , O_FINAL_COLS        => V_FINAL_COLS
          , O_FINAL_ORDER_COLS  => V_FINAL_ORDER_COLS
        );

        /* 계획 · 실적 기간정보 */
        PR_GET_REPORT_TERM_INFO
        (
            P_PLAN_START_YYYYMMDD   => P_PLAN_START_YYYYMMDD
          , P_FROM_YYYYMMDD         => P_FROM_YYYYMMDD
          , P_TO_YYYYMMDD           => P_TO_YYYYMMDD
          , O_PLAN_FROM_YYYYMMDD    => V_FROM_YYYYMMDD
          , O_PLAN_TO_YYYYMMDD      => V_TO_YYYYMMDD
          , O_PLAN_FROM_YYYYMM      => V_FROM_YYYYMM
          , O_PLAN_TO_YYYYMM        => V_TO_YYYYMM
          , O_RESULT_FROM_YYYYMMDD  => V_FROM_RESULT
          , O_RESULT_TO_YYYYMMDD    => V_TO_RESULT
          , O_PLAN_PARTIAL_FROM_WW  => V_FROM_WW
          , O_PLAN_PARTIAL_TO_WW    => V_TO_WW
          , O_PLAN_ISO_FROM_WW      => V_ISO_FROM_WW
          , O_PLAN_ISOL_TO_WW       => V_ISO_TO_WW
        );

        /*==============================================================================
         * GT_SCP0100_MEASURE — 조회 대상 측정값
         *   사용자가 지정한 측정값이 있으면 그것, 하나도 없으면 기본 측정값 전체
         *============================================================================*/
        INSERT INTO GT_SCP0100_MEASURE
        (
            MEASURE_UI
          , MEASURE_NAME
          , MEASURE_GROUP
          , SORT_ORDER_NO
        )
        SELECT A.COLUMN_NAME                    /* 사용자별 설정한 조회 대상 measure */
             , B.COLUMN_LABEL_NAME
             , B.SMALL_CLASS_LABEL_NAME
             , A.SORT_ORDER_NO
          FROM SCM_MST_TITLESET_USER    A
             , SCM_MST_SHEET_MEASURE    B
         WHERE UPPER(B.COLUMN_NAME)     = UPPER(A.COLUMN_NAME)
           AND UPPER(B.PROGRAM_ID)      = UPPER(C_PROGRAM_ID)
           AND UPPER(B.SHEET_NAME)      = UPPER(C_SHEET_NAME)
           AND B.VALID_YN               = 'Y'
           AND UPPER(A.PROGRAM_ID)      = UPPER(C_PROGRAM_ID)
           AND UPPER(A.SHEET_NAME)      = UPPER(C_SHEET_NAME)
           AND UPPER(A.USER_ID)         = UPPER(P_USER_ID)
         UNION ALL
        SELECT COLUMN_NAME                      /* 사용자별 설정한 measure 정보가 없을 경우 default measure */
             , COLUMN_LABEL_NAME
             , SMALL_CLASS_LABEL_NAME
             , SORT_ORDER_NO
          FROM SCM_MST_SHEET_MEASURE
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM SCM_MST_TITLESET_USER    XA
                                 , SCM_MST_SHEET_MEASURE    XB
                             WHERE UPPER(XB.COLUMN_NAME)    = UPPER(XA.COLUMN_NAME)
                               AND UPPER(XB.PROGRAM_ID)     = UPPER(C_PROGRAM_ID)
                               AND UPPER(XB.SHEET_NAME)     = UPPER(C_SHEET_NAME)
                               AND XB.VALID_YN              = 'Y'
                               AND UPPER(XA.PROGRAM_ID)     = UPPER(C_PROGRAM_ID)
                               AND UPPER(XA.SHEET_NAME)     = UPPER(C_SHEET_NAME)
                               AND UPPER(XA.USER_ID)        = UPPER(P_USER_ID)
                          )
           AND UPPER(PROGRAM_ID)        = UPPER(C_PROGRAM_ID)
           AND UPPER(SHEET_NAME)        = UPPER(C_SHEET_NAME)
           AND VALID_YN                 = 'Y'
           AND DEFAULT_FLAG             = 'Y';

        IF UPPER(P_CHK_AS) = 'N' THEN
            DELETE GT_SCP0100_MEASURE
             WHERE UPPER(MEASURE_GROUP) = UPPER('AS Sales PSI');
        END IF;

        /*==============================================================================
         * GT_SCP0100_MEASURE1 / 2 / 3 — 측정값 갈래
         *============================================================================*/
        IF UPPER(P_SEARCH_LEVEL) = 'DETAIL' THEN

            INSERT INTO GT_SCP0100_MEASURE1
            (
                MEASURE_UI
              , MEASURE_NAME
              , MEASURE_GROUP
              , SORT_ORDER_NO
            )
            SELECT MEASURE_UI
                 , MEASURE_NAME
                 , MEASURE_GROUP
                 , SORT_ORDER_NO
              FROM GT_SCP0100_MEASURE
             WHERE UPPER(MEASURE_UI) NOT IN ('PACK_PROD', 'CELL_PROD');

        ELSE

            INSERT INTO GT_SCP0100_MEASURE1
            (
                MEASURE_UI
              , MEASURE_NAME
              , MEASURE_GROUP
              , SORT_ORDER_NO
            )
            SELECT MEASURE_UI
                 , MEASURE_NAME
                 , MEASURE_GROUP
                 , SORT_ORDER_NO
              FROM GT_SCP0100_MEASURE
             WHERE UPPER(MEASURE_UI) NOT IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN', 'PACK_PROD', 'CELL_PROD');

        END IF;

        INSERT INTO GT_SCP0100_MEASURE2
        (
            MEASURE_UI
          , MEASURE_NAME
          , MEASURE_GROUP
          , SORT_ORDER_NO
        )
        SELECT MEASURE_UI
             , MEASURE_NAME
             , MEASURE_GROUP
             , SORT_ORDER_NO
          FROM GT_SCP0100_MEASURE
         WHERE UPPER(MEASURE_UI) IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN');

        INSERT INTO GT_SCP0100_MEASURE3
        (
            MEASURE_UI
          , MEASURE_NAME
          , MEASURE_GROUP
          , SORT_ORDER_NO
        )
        SELECT MEASURE_UI
             , MEASURE_NAME
             , MEASURE_GROUP
             , SORT_ORDER_NO
          FROM GT_SCP0100_MEASURE
         WHERE UPPER(MEASURE_UI) IN ('PACK_PROD', 'CELL_PROD');

        /*==============================================================================
         * GT_SCP0100_PRODUCTLEVEL — 제품단계
         *   [PJ20257329] 2025.08.01 공정 하드코딩 변경 반영본
         *============================================================================*/
        INSERT INTO GT_SCP0100_PRODUCTLEVEL
        (
            DIVISION_ID
          , ITEM_ID
          , FLOW_ID
          , BIZ_TYPE
          , GROUP_CODE6
          , GROUP_CODE7
          , GROUP_CODE5
          , BASIC_FINISHED_PRODUCT
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , FLOW_ID
             , CASE WHEN OPERATION_GROUP = 'A' THEN 'CELL'
                    WHEN OPERATION_GROUP = 'P' THEN CASE WHEN FLOW_ID = 'P9500' THEN 'PACK' ELSE 'MODULE' END
                    ELSE ''                     /* AS-IS 빈 문자. Oracle 에서는 NULL 이 된다(쓰이지 않는 칸) */
               END AS BIZ_TYPE
             , GROUP_CODE6
             , GROUP_CODE7
             , GROUP_CODE5
             , FINISHED_PRODUCT
          FROM SCP_MST_FINAL_ITEM
         WHERE 1 = 1
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND DIVISION_ID LIKE '81%';

        /*==============================================================================
         * GT_SCP0100_OPERATION — 공정
         *============================================================================*/
        INSERT INTO GT_SCP0100_OPERATION
        (
            DIVISION_ID
          , ITEM_ID
          , FLOW_ID
          , OPERATION
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , MAX(FLOW_ID) AS FLOW_ID
             , CASE WHEN MAX(SCP_OPERATION_GROUP) = 'A' THEN 'CELL'
                    WHEN MAX(SCP_OPERATION_GROUP) = 'P'
                    /* AS-IS 결함 : SCP_OPERATION_GROUP 은 'A'·'P' 라 'P9500' 이 될 수 없어 언제나 'MODULE' */
                    THEN CASE WHEN MAX(SCP_OPERATION_GROUP) = 'P9500' THEN 'PACK' ELSE 'MODULE' END
                    ELSE ''
               END AS OPERATION
          FROM SCM_MST_ITEM_SN
         WHERE 1 = 1
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND DIVISION_ID LIKE '81%'
           AND ACTIVE_FLAG = 'Y'
           AND SCP_OPERATION_GROUP <> 'E'
         GROUP BY DIVISION_ID
                , ITEM_ID;

        /*==============================================================================
         * GT_SCP0100_RAW — 조회 원천
         *============================================================================*/
        INSERT INTO GT_SCP0100_RAW
        (
            PLAN_START_YYYYMMDD
          , DIVISION_ID
          , PLAN_TYPE
          , YYYYPW
          , ITEM_ID
          , OPERATION_GROUP
          , MEASURE
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , VARIOUS_KEY
          , REP_CELL_ITEM_ID
          , CELL_GROUP
          , CELL_GROUP_SORT_ORDER_NO
          , QTY
          , FROM_BOH_QTY
          , TO_BOH_QTY
          , CELL_CF
          , ATTRIBUTE3
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , FLOW_ID
          , OPERATION_ID
          , OPERATION_NAME
          , CELL_QTY
          , INV_SORT
        )
        SELECT A.PLAN_START_YYYYMMDD
             , A.DIVISION_ID
             , A.PLAN_TYPE                      /* E20260708-000926 */
             , A.YYYYPW
             , A.ITEM_ID
             , CASE WHEN A.MEASURE = 'DIO' THEN 'P'
                    ELSE A.OPERATION_GROUP
               END AS OPERATION_GROUP
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.REP_CELL_ITEM_ID
             , A.CELL_GROUP
             , CASE WHEN A.ATTRIBUTE10 = 'Y' THEN 1 ELSE 2 END AS CELL_GROUP_SORT_ORDER_NO
             , A.QTY
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.CELL_CF
             , A.ATTRIBUTE3
             , CASE WHEN TRIM(B.GROUP_CODE6) IS NULL THEN '-'
                    ELSE B.GROUP_CODE6
               END AS PRODUCT_LEVEL1
             , CASE WHEN TRIM(B.GROUP_CODE7) IS NULL THEN '-'
                    ELSE B.GROUP_CODE7
               END AS PRODUCT_LEVEL2
             , CASE WHEN TRIM(B.GROUP_CODE5) IS NULL THEN '-'
                    ELSE B.GROUP_CODE5
               END AS PRODUCT_LEVEL3
             , NVL(C.FLOW_ID,   '-') AS FLOW_ID
             , NVL(NULLIF(RTRIM(C.FLOW_ID),''), '/') AS OPERATION_ID
             , NVL(C.OPERATION, '-') AS OPERATION_NAME
             , CASE WHEN UPPER(P_CHK_CELL_QTY) = 'Y' AND A.QTY IS NOT NULL AND A.CELL_CF IS NOT NULL
                    THEN NVL(A.QTY, 0) * NVL(A.CELL_CF, 0)
                    ELSE A.QTY
               END AS CELL_QTY
             , TO_NUMBER(NVL(A.ATTRIBUTE8, '999')) AS INV_SORT
          FROM SCP_RPT_GLOBAL_PSI_MD_WW     A
             , GT_SCP0100_PRODUCTLEVEL      B
             , GT_SCP0100_OPERATION         C
         WHERE B.DIVISION_ID(+)             = A.DIVISION_ID
           AND B.ITEM_ID(+)                 = A.ATTRIBUTE3
           AND C.DIVISION_ID(+)             = A.DIVISION_ID
           AND C.ITEM_ID(+)                 = A.ITEM_ID
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(A.DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR UPPER(A.ITEM_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ',')) )
               )
           AND ( TRIM(P_FROM_SITE) IS NULL
                 OR UPPER(A.FROM_SITE) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_FROM_SITE, ',')) )
               )
           AND ( TRIM(P_TO_SITE) IS NULL
                 OR UPPER(A.TO_SITE) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_TO_SITE, ',')) )
               )
           AND ( TRIM(P_PROJECT) IS NULL
                 OR UPPER(A.VARIOUS_KEY) LIKE '%' || UPPER(P_PROJECT) || '%'
               )
           AND ( TRIM(P_CELL_GROUP) IS NULL
                 OR UPPER(A.CELL_GROUP) LIKE '%' || UPPER(P_CELL_GROUP) || '%'
               )
           AND A.DIVISION_ID                LIKE '81%'
           AND A.PLAN_START_YYYYMMDD        = P_PLAN_START_YYYYMMDD
           AND UPPER(A.PLAN_TYPE)           = UPPER(P_PLAN_TYPE)     /* E20260708-000926 */
           AND A.YYYYPW                     BETWEEN V_FROM_WW AND V_TO_WW;

        /*==============================================================================
         * GT_SCP0100_CELL_GROUP_SORT_ORDER — 셀그룹 정렬순서
         *============================================================================*/
        INSERT INTO GT_SCP0100_CELL_GROUP_SORT_ORDER
        (
            DIVISION_ID
          , PLAN_TYPE
          , CELL_GROUP
          , MEASURE
          , CELL_GROUP_SORT_ORDER_NO
          , INV_SORT
        )
        SELECT DIVISION_ID
             , PLAN_TYPE                        /* E20260708-000926 */
             , CELL_GROUP
             , MEASURE
             , CELL_GROUP_SORT_ORDER_NO
             , MAX(INV_SORT) AS INV_SORT
          FROM GT_SCP0100_RAW
         GROUP BY DIVISION_ID
                , PLAN_TYPE
                , CELL_GROUP
                , MEASURE
                , CELL_GROUP_SORT_ORDER_NO;

        /*==============================================================================
         * GT_SCP0100_DIO_DETAIL_RAW — DIO 상세 원천 (고도화)
         *============================================================================*/
        INSERT INTO GT_SCP0100_DIO_DETAIL_RAW
        (
            PLAN_START_YYYYMMDD
          , DIVISION_ID
          , PLAN_TYPE
          , YYYYPW
          , ITEM_ID
          , OPERATION_GROUP
          , MEASURE
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , VARIOUS_KEY
          , REP_CELL_ITEM_ID
          , CELL_GROUP
          , CELL_GROUP_SORT_ORDER_NO
          , QTY
          , FROM_BOH_QTY
          , TO_BOH_QTY
          , CELL_CF
          , ATTRIBUTE3
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , FLOW_ID
          , OPERATION_ID
          , OPERATION_NAME
          , CELL_QTY
          , INV_SORT
        )
        SELECT A.PLAN_START_YYYYMMDD
             , A.DIVISION_ID
             , A.PLAN_TYPE                      /* E20260708-000926 */
             , A.YYYYPW
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.REP_CELL_ITEM_ID
             , A.CELL_GROUP
             , CASE WHEN A.ATTRIBUTE10 = 'Y' THEN 1 ELSE 2 END AS CELL_GROUP_SORT_ORDER_NO
             , A.QTY
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.CELL_CF
             , A.ATTRIBUTE3
             , A.PRODUCT_LEVEL1
             , A.PRODUCT_LEVEL2
             , A.PRODUCT_LEVEL3
             , NVL(B.FLOW_ID,   '-') AS FLOW_ID
             , NVL(NULLIF(RTRIM(B.FLOW_ID),''), '/') AS OPERATION_ID
             , NVL(B.OPERATION, '-') AS OPERATION_NAME
             , CASE WHEN UPPER(P_CHK_CELL_QTY) = 'Y' AND A.QTY IS NOT NULL AND A.CELL_CF IS NOT NULL
                    THEN NVL(A.QTY, 0) * NVL(A.CELL_CF, 0)
                    ELSE A.QTY
               END AS CELL_QTY
             , TO_NUMBER(NVL(A.ATTRIBUTE8, '999')) AS INV_SORT
          FROM SCP_RPT_GLOBAL_PSI_MD_DETAIL_WW  A
             , GT_SCP0100_OPERATION             B
         WHERE B.DIVISION_ID(+)             = A.DIVISION_ID
           AND B.ITEM_ID(+)                 = A.ITEM_ID
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(A.DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND ( TRIM(P_CELL_GROUP) IS NULL
                 OR UPPER(A.CELL_GROUP) LIKE '%' || UPPER(P_CELL_GROUP) || '%'
               )
           AND A.DIVISION_ID                LIKE '81%'
           AND A.PLAN_START_YYYYMMDD        = P_PLAN_START_YYYYMMDD
           AND UPPER(A.PLAN_TYPE)           = UPPER(P_PLAN_TYPE)     /* E20260708-000926 */
           AND A.YYYYPW                     BETWEEN V_FROM_WW AND V_TO_WW;

        INSERT INTO GT_SCP0100_CELL_GROUP_SORT_ORDER
        (
            DIVISION_ID
          , PLAN_TYPE
          , CELL_GROUP
          , MEASURE
          , CELL_GROUP_SORT_ORDER_NO
          , INV_SORT
        )
        SELECT DIVISION_ID
             , PLAN_TYPE                        /* E20260708-000926 */
             , CELL_GROUP
             , MEASURE
             , CELL_GROUP_SORT_ORDER_NO
             , MAX(INV_SORT) AS INV_SORT
          FROM GT_SCP0100_DIO_DETAIL_RAW
         GROUP BY DIVISION_ID
                , PLAN_TYPE
                , CELL_GROUP
                , MEASURE
                , CELL_GROUP_SORT_ORDER_NO;

        /*==============================================================================
         * GT_SCP0100_DAYCOLS — 주차 칸 목록
         *   YYYYPW_NAME : 'W_' || 연도 4자리 || 부분주차(W 제외)  예 W_202405A
         *   YYYYPW      : 원장 YYYYPW 와 견줄 값                   예 202405A
         *============================================================================*/
        INSERT INTO GT_SCP0100_DAYCOLS
        (
            YYYYPW_NAME
          , YYYYPW
          , SORT_ORDER_NO
        )
        SELECT YYYYPW_NAME
             , SUBSTR(YYYYPW_NAME, 3, 7) AS YYYYPW
             , YYYYPW_NAME               AS SORT_ORDER_NO
          FROM ( SELECT 'W_' || SUBSTR(ISO_YYYYWW, 1, 4) || REPLACE(PARTIAL_WEEK_NAME, 'W', '') AS YYYYPW_NAME
                   FROM SCM_SYS_CALENDAR_M
                  WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                    AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
                  GROUP BY 'W_' || SUBSTR(ISO_YYYYWW, 1, 4) || REPLACE(PARTIAL_WEEK_NAME, 'W', '')
               )  IA;

        /*==============================================================================
         * 주차별 수량 칸 집계식
         *   AS-IS 는 @v_day_cols · @v_final_sum_wheres 도 함께 조립하지만
         *   @v_day_cols 는 최종 SQL 에 쓰이지 않고 @v_final_sum_wheres 는 조립 직후 빈 문자로 덮인다.
         *============================================================================*/
        V_FINAL_SUM_COLS := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_FINAL_SUM_COLS, TRUE);

        FOR R IN ( SELECT YYYYPW_NAME
                     FROM GT_SCP0100_DAYCOLS
                    ORDER BY SORT_ORDER_NO
                 )
        LOOP
            IF DBMS_LOB.GETLENGTH(V_FINAL_SUM_COLS) > 0 THEN
                DBMS_LOB.WRITEAPPEND(V_FINAL_SUM_COLS, LENGTH(CHR(10) || '        , '), CHR(10) || '        , ');
            END IF;
            DBMS_LOB.APPEND(V_FINAL_SUM_COLS, TO_CLOB('MAX(' || R.YYYYPW_NAME || ') AS ' || R.YYYYPW_NAME));
        END LOOP;

        /*==============================================================================
         * GT_SCP0100_TRANSPORT_MODE_CODE — 운송수단 룩업
         *============================================================================*/
        INSERT INTO GT_SCP0100_TRANSPORT_MODE_CODE
        (
            CODE
          , NAME
          , DISPLAY_SEQ
        )
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
             , DISPLAY_SEQ
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE 1 = 1
           AND UPPER(LOOKUP_TYPE) = 'TRANSPORT_MODE_CODE'
           AND VALID_YN           = 'Y';

        /*==============================================================================
         * GT_SCP0100_LINE — 생산 라인
         *   AS-IS 는 VARIOUS_KEY != '' 로 빈 문자를 걸러낸다.
         *   Oracle 에서 빈 문자는 NULL 이라 그대로 옮기면 전건이 빠지므로 TRIM(…) IS NOT NULL 로 바꾼다.
         *============================================================================*/
        INSERT INTO GT_SCP0100_LINE
        (
            YYYYPW
          , DIVISION_ID
          , PLAN_TYPE
          , CELL_GROUP
          , OPERATION_GROUP
          , OPERATION_ID
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , ITEM_ID
          , TO_SITE
          , FROM_SITE
          , INCOTERMS
          , MEASURE
          , VARIOUS_KEY
        )
        SELECT YYYYPW
             , DIVISION_ID
             , PLAN_TYPE                        /* E20260708-000926 */
             , CELL_GROUP
             , OPERATION_GROUP
             , OPERATION_ID
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , PRODUCT_LEVEL3
             , ITEM_ID
             , TO_SITE
             , FROM_SITE
             , INCOTERMS
             , MEASURE
             , VARIOUS_KEY
          FROM GT_SCP0100_RAW
         WHERE 1 = 1
           AND UPPER(MEASURE)       IN ('PACK_PROD', 'CELL_PROD')
           AND TRIM(VARIOUS_KEY)    IS NOT NULL
         GROUP BY YYYYPW
                , DIVISION_ID
                , PLAN_TYPE
                , CELL_GROUP
                , OPERATION_GROUP
                , OPERATION_ID
                , PRODUCT_LEVEL1
                , PRODUCT_LEVEL2
                , PRODUCT_LEVEL3
                , ITEM_ID
                , TO_SITE
                , FROM_SITE
                , INCOTERMS
                , MEASURE
                , VARIOUS_KEY;

        V_QTY_COLS := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_QTY_COLS, TRUE);

        V_SQL := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        /*==============================================================================
         * 1. AUTO
         *   AS-IS 는 사용자 지정 칸(SCM_MST_TITLESET_USER)과 REPORT 시트 칸을 내부조인해
         *   조회 칸 목록을 만든다. 사용자 지정 칸이 하나도 없으면 목록이 빈 값이 되어
         *   문장 전체가 빈 값이 되고 결과가 없다(AS-IS 와 같은 동작).
         *============================================================================*/
        IF UPPER(P_SEARCH_LEVEL) = 'AUTO' THEN

            INSERT INTO GT_SCP0100_USER_COLS
            (
                COLUMN_NAME
              , COLUMN_LABEL_NAME
              , SORT_ORDER_NO
            )
            SELECT CASE WHEN UPPER(A.COLUMN_NAME) = 'MEASURE_NAME' THEN 'MEASURE'
                        ELSE A.COLUMN_NAME
                   END AS COLUMN_NAME
                 , A.COLUMN_LABEL_NAME
                 , B.SORT_ORDER_NO
              FROM SCM_MST_SHEET_COLUMNS    A
                 , SCM_MST_TITLESET_USER    B
             WHERE UPPER(B.PROGRAM_ID)          = UPPER(A.PROGRAM_ID)
               AND UPPER(B.SHEET_NAME)          = UPPER(A.SHEET_NAME)
               AND UPPER(B.COLUMN_NAME)         = UPPER(A.COLUMN_NAME)
               AND UPPER(B.USER_ID)             = UPPER(P_USER_ID)
               AND UPPER(A.PROGRAM_ID)          = UPPER(C_PROGRAM_ID)
               AND UPPER(A.SHEET_NAME)          = 'REPORT'
               AND A.VALID_YN                   = 'Y'
               AND A.VISIBLE_FLAG               = 'Y'
               AND NVL(A.ATTRIBUTE6, 'Y')       <> 'N'
               AND UPPER(A.COLUMN_NAME)         NOT IN ('MEASURE_GROUP', 'MEASURE', 'MEASURE_NAME', 'VARIOUS_KEY', 'CELL_CF');

            /* AS-IS 결함 : 위 제외 목록에 VARIOUS_KEY 가 있어 이 건수는 언제나 0 이고
                            그 결과 운송수단 룩업이 늘 비워진다 */
            SELECT COUNT(*)
              INTO V_CNT_VARIOUS
              FROM GT_SCP0100_USER_COLS
             WHERE UPPER(COLUMN_NAME) = 'VARIOUS_KEY';

            IF V_CNT_VARIOUS = 0 THEN
                DELETE GT_SCP0100_TRANSPORT_MODE_CODE;
            END IF;

            SELECT LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG('A.' || COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG(' AND A.' || COLUMN_NAME || ' = D.' || COLUMN_NAME, '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG(' AND SA.' || COLUMN_NAME || ' = A.' || COLUMN_NAME, '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
              INTO V_COL_LIST
                 , V_COL_LIST2
                 , V_COL_WHERE
                 , V_COL_WHERE_COUNT
              FROM GT_SCP0100_USER_COLS;

            SELECT LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
              INTO V_COL_LIST_AUTO
              FROM GT_SCP0100_USER_COLS
             WHERE UPPER(COLUMN_NAME) <> 'OPERATION_GROUP';

            IF V_COL_LIST IS NOT NULL THEN

                /* 주차별 수량 칸 */
                FOR R IN ( SELECT YYYYPW_NAME
                                , YYYYPW
                             FROM GT_SCP0100_DAYCOLS
                            ORDER BY SORT_ORDER_NO
                         )
                LOOP
                    DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
                        CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
                     || '           FROM GT_SCP0100_QTY_AUTO  SA' || CHR(10)
                     || '          WHERE 1 = 1' || CHR(10)
                     || '         ' || V_COL_WHERE_COUNT || CHR(10)
                     || '            AND SA.MEASURE_UI = A.MEASURE_UI' || CHR(10)
                     || '            AND SA.YYYYPW     = ''' || R.YYYYPW || '''' || CHR(10)
                     || '            AND ROWNUM        = 1 )  AS ' || R.YYYYPW_NAME));
                END LOOP;

                /* 수량 집계 */
                EXECUTE IMMEDIATE
                    'INSERT INTO GT_SCP0100_QTY_AUTO ( YYYYPW, ' || V_COL_LIST || ', MEASURE_UI, QTY, FROM_BOH_QTY, TO_BOH_QTY )'
                 || ' SELECT YYYYPW, ' || V_COL_LIST || ', MEASURE, SUM(CELL_QTY), SUM(FROM_BOH_QTY), SUM(TO_BOH_QTY)'
                 || '   FROM GT_SCP0100_RAW'
                 || '  GROUP BY YYYYPW, ' || V_COL_LIST || ', MEASURE';

                /* 셀환산계수 */
                EXECUTE IMMEDIATE
                    'INSERT INTO GT_SCP0100_RAW_CELL_CF ( ' || V_COL_LIST || ', MEASURE, VARIOUS_KEY, CELL_CF )'
                 || ' SELECT ' || V_COL_LIST || ', MEASURE, VARIOUS_KEY, MAX(CELL_CF)'
                 || '   FROM GT_SCP0100_RAW'
                 || '  GROUP BY ' || V_COL_LIST || ', MEASURE, VARIOUS_KEY';

                DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                    'SELECT FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', OPERATION_GROUP) AS OPERATION_GROUP' || CHR(10)
                 || '     , ' || V_COL_LIST_AUTO || CHR(10)
                 || '     , CASE WHEN OPERATION_GROUP = ''A'' AND UPPER(MEASURE_GROUP) = UPPER(''Sales PSI'') THEN ''Cell Sales PSI''' || CHR(10)
                 || '            ELSE MEASURE_GROUP' || CHR(10)
                 || '       END AS MEASURE_GROUP' || CHR(10)
                 || '     , MEASURE_UI' || CHR(10)
                 || '     , MEASURE_NAME' || CHR(10)
                 || '     , CASE WHEN OPERATION_GROUP = ''A'' AND UPPER(MEASURE_GROUP) = UPPER(''Sales PSI'') THEN SORT_ORDER_NO + 20' || CHR(10)
                 || '            ELSE SORT_ORDER_NO' || CHR(10)
                 || '       END AS SORT_ORDER_NO' || CHR(10)
                 || '     , CODE' || CHR(10)
                 || '     , VARIOUS_KEY' || CHR(10)
                 || '     , DISPLAY_SEQ' || CHR(10)
                 || '     , CELL_CF' || CHR(10)));

                DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);

                DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                    CHR(10) || '  FROM ( SELECT ' || V_COL_LIST || CHR(10)
                 || '              , B.MEASURE_GROUP                AS MEASURE_GROUP' || CHR(10)
                 || '              , B.MEASURE_UI                   AS MEASURE_UI' || CHR(10)
                 || '              , B.MEASURE_NAME                 AS MEASURE_NAME' || CHR(10)
                 || '              , B.SORT_ORDER_NO                AS SORT_ORDER_NO' || CHR(10)
                 || '              , CAST(NULL AS VARCHAR2(800))    AS CODE' || CHR(10)
                 || '              , ''-''                          AS VARIOUS_KEY' || CHR(10)
                 || '              , 1                              AS DISPLAY_SEQ' || CHR(10)
                 || '              , CELL_CF' || CHR(10)
                 || '           FROM GT_SCP0100_RAW_CELL_CF  A' || CHR(10)
                 || '              , GT_SCP0100_MEASURE1      B' || CHR(10)
                 || '          WHERE B.MEASURE_UI = A.MEASURE' || CHR(10)
                 || '         UNION' || CHR(10)
                 || '         SELECT ' || V_COL_LIST || CHR(10)
                 || '              , B.MEASURE_GROUP                AS MEASURE_GROUP' || CHR(10)
                 || '              , B.MEASURE_UI                   AS MEASURE_UI' || CHR(10)
                 || '              , B.MEASURE_NAME                 AS MEASURE_NAME' || CHR(10)
                 || '              , B.SORT_ORDER_NO                AS SORT_ORDER_NO' || CHR(10)
                 || '              , C.CODE' || CHR(10)
                 || '              , C.NAME                         AS VARIOUS_KEY' || CHR(10)
                 || '              , C.DISPLAY_SEQ' || CHR(10)
                 || '              , CELL_CF' || CHR(10)
                 || '           FROM GT_SCP0100_RAW_CELL_CF          A' || CHR(10)
                 || '              , GT_SCP0100_MEASURE2             B' || CHR(10)
                 || '              , GT_SCP0100_TRANSPORT_MODE_CODE  C' || CHR(10)
                 || '          WHERE B.MEASURE_UI = A.MEASURE' || CHR(10)
                 || '            AND C.CODE       = A.VARIOUS_KEY' || CHR(10)
                 || '         UNION' || CHR(10)
                 || '         SELECT ' || V_COL_LIST2 || CHR(10)
                 || '              , B.MEASURE_GROUP                AS MEASURE_GROUP' || CHR(10)
                 || '              , B.MEASURE_UI                   AS MEASURE_UI' || CHR(10)
                 || '              , B.MEASURE_NAME                 AS MEASURE_NAME' || CHR(10)
                 || '              , B.SORT_ORDER_NO                AS SORT_ORDER_NO' || CHR(10)
                 || '              , D.VARIOUS_KEY                  AS CODE' || CHR(10)
                 || '              , D.VARIOUS_KEY                  AS VARIOUS_KEY' || CHR(10)
                 || '              , 1                              AS DISPLAY_SEQ' || CHR(10)
                 || '              , CELL_CF' || CHR(10)
                 || '           FROM GT_SCP0100_RAW_CELL_CF  A' || CHR(10)
                 || '              , GT_SCP0100_MEASURE3      B' || CHR(10)
                 || '              , GT_SCP0100_LINE          D' || CHR(10)
                 || '          WHERE 1 = 1' || CHR(10)
                 || '         ' || V_COL_WHERE || CHR(10)
                 || '            AND B.MEASURE_UI = D.MEASURE' || CHR(10)
                 || '       )  IA' || CHR(10)
                 || ' WHERE MEASURE_UI NOT IN (''DIO'')' || CHR(10)
                 || ' ORDER BY ' || FN_ORDER_EXPR(V_COL_LIST) || CHR(10)
                 || '        , SORT_ORDER_NO NULLS FIRST' || CHR(10)
                 || '        , DISPLAY_SEQ NULLS FIRST' || CHR(10)
                 || '        , ' || FN_ORDER_EXPR('VARIOUS_KEY')));

            END IF;

        /*==============================================================================
         * 1. DETAIL
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'DETAIL' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_DETAIL
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , OPERATION_ID
--              , PRODUCT_LEVEL1
--              , PRODUCT_LEVEL2
--              , PRODUCT_LEVEL3
--              , ITEM_ID
--              , TO_SITE
--              , FROM_SITE
--              , VARIOUS_KEY
--              , INCOTERMS
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , OPERATION_GROUP
--                 , OPERATION_ID
--                 , PRODUCT_LEVEL1
--                 , PRODUCT_LEVEL2
--                 , PRODUCT_LEVEL3
--                 , ITEM_ID
--                 , TO_SITE
--                 , FROM_SITE
--                 , VARIOUS_KEY
--                 , INCOTERMS
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , OPERATION_ID
--                    , PRODUCT_LEVEL1
--                    , PRODUCT_LEVEL2
--                    , PRODUCT_LEVEL3
--                    , ITEM_ID
--                    , TO_SITE
--                    , FROM_SITE
--                    , VARIOUS_KEY
--                    , INCOTERMS
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , CELL_GROUP
              , PLAN_TYPE
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MEASURE
              , VARIOUS_KEY
              , CELL_CF
            )
            SELECT DIVISION_ID
                 , CELL_GROUP
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , MEASURE
                 , VARIOUS_KEY
                 , MAX(CELL_CF)                 AS CELL_CF
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , CELL_GROUP
                    , PLAN_TYPE
                    , OPERATION_GROUP
                    , OPERATION_ID
                    , ITEM_ID
                    , TO_SITE
                    , FROM_SITE
                    , INCOTERMS
                    , PRODUCT_LEVEL1
                    , PRODUCT_LEVEL2
                    , PRODUCT_LEVEL3
                    , MEASURE
                    , VARIOUS_KEY;

            INSERT INTO GT_SCP0100_ALL_MEASURE_UI
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_TYPE                  /* E20260708-000926 */
                 , A.CELL_GROUP
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.CELL_CF
                 , B.MEASURE_GROUP              AS MEASURE_GROUP
                 , B.MEASURE_UI                 AS MEASURE_UI
                 , B.MEASURE_NAME               AS MEASURE_NAME
                 , B.SORT_ORDER_NO              AS SORT_ORDER_NO
                 , CAST(NULL AS VARCHAR2(800))  AS CODE
                 , A.VARIOUS_KEY
                 , 1                            AS DISPLAY_SEQ
              FROM GT_SCP0100_RAW_CELL_CF   A
                 , GT_SCP0100_MEASURE1      B
             WHERE B.MEASURE_UI = A.MEASURE;

            INSERT INTO GT_SCP0100_ALL_VARIOUS_KEY
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_TYPE                  /* E20260708-000926 */
                 , A.CELL_GROUP
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.CELL_CF
                 , B.MEASURE_GROUP              AS MEASURE_GROUP
                 , B.MEASURE_UI                 AS MEASURE_UI
                 , B.MEASURE_NAME               AS MEASURE_NAME
                 , B.SORT_ORDER_NO              AS SORT_ORDER_NO
                 , C.CODE
                 , C.CODE                       AS VARIOUS_KEY
                 , C.DISPLAY_SEQ
              FROM GT_SCP0100_RAW_CELL_CF           A
                 , GT_SCP0100_MEASURE2              B
                 , GT_SCP0100_TRANSPORT_MODE_CODE   C
             WHERE B.MEASURE_UI = A.MEASURE
               AND C.CODE       = A.VARIOUS_KEY;

            INSERT INTO GT_SCP0100_ALL_DISPLAY_SEQ
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_TYPE                  /* E20260708-000926 */
                 , A.CELL_GROUP
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.CELL_CF
                 , B.MEASURE_GROUP              AS MEASURE_GROUP
                 , B.MEASURE_UI                 AS MEASURE_UI
                 , B.MEASURE_NAME               AS MEASURE_NAME
                 , B.SORT_ORDER_NO              AS SORT_ORDER_NO
                 , C.VARIOUS_KEY                AS CODE
                 , C.VARIOUS_KEY                AS VARIOUS_KEY
                 , 1                            AS DISPLAY_SEQ
              FROM GT_SCP0100_RAW_CELL_CF   A
                 , GT_SCP0100_MEASURE3      B
                 , GT_SCP0100_LINE          C
             WHERE B.MEASURE_UI      = A.MEASURE
               AND C.DIVISION_ID     = A.DIVISION_ID
               AND C.PLAN_TYPE       = A.PLAN_TYPE           /* E20260708-000926 */
               AND C.CELL_GROUP      = A.CELL_GROUP
               AND C.OPERATION_GROUP = A.OPERATION_GROUP
               AND C.OPERATION_ID    = A.OPERATION_ID
               AND C.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1
               AND C.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2
               AND C.PRODUCT_LEVEL3  = A.PRODUCT_LEVEL3
               AND C.ITEM_ID         = A.ITEM_ID
               AND C.TO_SITE         = A.TO_SITE
               AND C.FROM_SITE       = A.FROM_SITE
               AND C.INCOTERMS       = A.INCOTERMS
               AND C.MEASURE         = B.MEASURE_UI;

            INSERT INTO GT_SCP0100_ALL
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , CELL_CF
                 , MEASURE_GROUP
                 , MEASURE_UI
                 , MEASURE_NAME
                 , SORT_ORDER_NO
                 , CODE
                 , VARIOUS_KEY
                 , DISPLAY_SEQ
              FROM GT_SCP0100_ALL_MEASURE_UI;

            INSERT INTO GT_SCP0100_ALL
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , CELL_CF
                 , MEASURE_GROUP
                 , MEASURE_UI
                 , MEASURE_NAME
                 , SORT_ORDER_NO
                 , CODE
                 , VARIOUS_KEY
                 , DISPLAY_SEQ
              FROM GT_SCP0100_ALL_VARIOUS_KEY;

            INSERT INTO GT_SCP0100_ALL
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , CELL_CF
                 , MEASURE_GROUP
                 , MEASURE_UI
                 , MEASURE_NAME
                 , SORT_ORDER_NO
                 , CODE
                 , VARIOUS_KEY
                 , DISPLAY_SEQ
              FROM GT_SCP0100_ALL_DISPLAY_SEQ;

            /* 주차별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_DETAIL  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_ID    = A.OPERATION_ID' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL3  = A.PRODUCT_LEVEL3' || CHR(10)
--                 || '            AND SA.ITEM_ID         = A.ITEM_ID' || CHR(10)
--                 || '            AND SA.TO_SITE         = A.TO_SITE' || CHR(10)
--                 || '            AND SA.FROM_SITE       = A.FROM_SITE' || CHR(10)
--                 || '            AND SA.VARIOUS_KEY     = A.VARIOUS_KEY' || CHR(10)
--                 || '            AND SA.INCOTERMS       = A.INCOTERMS' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = A.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP) AS OPERATION_GROUP' || CHR(10)
             || '              , A.OPERATION_ID' || CHR(10)
             || '              , A.ITEM_ID' || CHR(10)
             || '              , A.TO_SITE' || CHR(10)
             || '              , A.FROM_SITE' || CHR(10)
             || '              , A.INCOTERMS' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , A.PRODUCT_LEVEL3' || CHR(10)
             || '              , A.CELL_CF' || CHR(10)
             || '              , CASE WHEN A.OPERATION_GROUP = ''A'' AND UPPER(A.MEASURE_GROUP) = UPPER(''Sales PSI'') THEN ''Cell Sales PSI''' || CHR(10)
             || '                     ELSE A.MEASURE_GROUP' || CHR(10)
             || '                END AS MEASURE_GROUP' || CHR(10)
             || '              , A.MEASURE_UI' || CHR(10)
             || '              , A.MEASURE_NAME' || CHR(10)
             || '              , CASE WHEN A.OPERATION_GROUP = ''A'' AND UPPER(A.MEASURE_GROUP) = UPPER(''Sales PSI'') THEN A.SORT_ORDER_NO + 20' || CHR(10)
             || '                     ELSE A.SORT_ORDER_NO' || CHR(10)
             || '                END AS SORT_ORDER_NO' || CHR(10)
             || '              , B.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , A.CODE' || CHR(10)
             || '              , A.VARIOUS_KEY' || CHR(10)
             || '              , A.DISPLAY_SEQ' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_ALL                      A' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER  B' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , OPERATION_GROUP' || CHR(10)
             || '                       , OPERATION_ID' || CHR(10)
             || '                       , PRODUCT_LEVEL1' || CHR(10)
             || '                       , PRODUCT_LEVEL2' || CHR(10)
             || '                       , PRODUCT_LEVEL3' || CHR(10)
             || '                       , ITEM_ID' || CHR(10)
             || '                       , TO_SITE' || CHR(10)
             || '                       , FROM_SITE' || CHR(10)
             || '                       , VARIOUS_KEY' || CHR(10)
             || '                       , INCOTERMS' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , OPERATION_ID' || CHR(10)
             || '                          , PRODUCT_LEVEL1' || CHR(10)
             || '                          , PRODUCT_LEVEL2' || CHR(10)
             || '                          , PRODUCT_LEVEL3' || CHR(10)
             || '                          , ITEM_ID' || CHR(10)
             || '                          , TO_SITE' || CHR(10)
             || '                          , FROM_SITE' || CHR(10)
             || '                          , VARIOUS_KEY' || CHR(10)
             || '                          , INCOTERMS' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND B.MEASURE     = A.MEASURE_UI' || CHR(10)
             || '            AND B.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND B.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND A.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_ID(+) = A.OPERATION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL1(+) = A.PRODUCT_LEVEL1' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL2(+) = A.PRODUCT_LEVEL2' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL3(+) = A.PRODUCT_LEVEL3' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.ITEM_ID(+) = A.ITEM_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.TO_SITE(+) = A.TO_SITE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.FROM_SITE(+) = A.FROM_SITE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.VARIOUS_KEY(+) = A.VARIOUS_KEY' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.INCOTERMS(+) = A.INCOTERMS' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = A.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 1-1. CELL_GROUP
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'CELL_GROUP' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_CELL_GROUP
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , MEASURE;

            /* 주차별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_CELL_GROUP  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.MEASURE_UI  = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW      = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '     , MAX(INV_SORT) AS INV_SORT' || CHR(10)
             || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_GROUP' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL1' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL2' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '              , C.INV_SORT' || CHR(10)
             || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 1-2. CELL_GROUP_DETAIL (고도화)
         *   ORDER BY 를 조회 칸 목록이 아니라 본문에 박아 둔 갈래다.
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'CELL_GROUP_DETAIL' THEN

            INSERT INTO GT_SCP0100_QTY_CELL_GROUP_DETAIL
            (
                YYYYPW
              , DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE_UI
              , QTY
              , FROM_BOH_QTY
              , TO_BOH_QTY
              , CELL_CF
            )
            SELECT YYYYPW
                 , DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE                      AS MEASURE_UI
                 , SUM(CELL_QTY)                AS QTY
                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
                 , MAX(CELL_CF)                 AS CELL_CF
              FROM GT_SCP0100_RAW
             WHERE 1 = 1
               AND UPPER(MEASURE) NOT IN ('DIO_SALES', 'DIO_PACK', 'DIO_CELL')
             GROUP BY YYYYPW
                    , DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            INSERT INTO GT_SCP0100_QTY_CELL_GROUP_DETAIL
            (
                YYYYPW
              , DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE_UI
              , QTY
              , FROM_BOH_QTY
              , TO_BOH_QTY
              , CELL_CF
            )
            SELECT YYYYPW
                 , DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE                      AS MEASURE_UI
                 , SUM(CELL_QTY)                AS QTY
                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
                 , MAX(CELL_CF)                 AS CELL_CF
              FROM GT_SCP0100_DIO_DETAIL_RAW
             GROUP BY YYYYPW
                    , DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE
              FROM GT_SCP0100_DIO_DETAIL_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            /* 주차별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
                 || '           FROM GT_SCP0100_QTY_CELL_GROUP_DETAIL  SA' || CHR(10)
                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '     , MAX(INV_SORT) AS INV_SORT' || CHR(10)
             || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , CASE WHEN INSTR(A.OPERATION_GROUP, ''DIO'') > 0 THEN A.OPERATION_GROUP || ''(Lv1)''' || CHR(10)
             || '                     WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '              , C.INV_SORT' || CHR(10)
             || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT IN (''DIO'')' || CHR(10)
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             /* AS-IS 는 이 갈래만 정렬을 본문에 박아 두었다.
                MEASURE_GROUP 견줌은 등록값이 'Sales PSI' · 'Pack PSI' · 'Cell PSI' 라 UPPER 로 바꾼다.
                OPERATION_GROUP 견줌(INSTR(OPERATION_GROUP,'Lv1'))은 AS-IS 가 인자 순서를 뒤바꿔 놓아
                언제나 0 이다 — 원문 그대로 둔다. */
             || ' ORDER BY ' || FN_ORDER_EXPR('DIVISION_ID') || CHR(10)
             || '        , INV_SORT NULLS FIRST' || CHR(10)
             || '        , CELL_GROUP_SORT_ORDER_NO NULLS FIRST' || CHR(10)
             || '        , ' || FN_ORDER_EXPR('CELL_GROUP') || CHR(10)
             || '        , CASE WHEN PRODUCT_LEVEL1 = ''-'' THEN ''ZZZZ'' ELSE UPPER(TRANSLATE(PRODUCT_LEVEL1, ''_-/'', ''/'')) END' || CHR(10)
             || '        , CASE WHEN PRODUCT_LEVEL1 = ''-'' THEN ''ZZZZ'' ELSE PRODUCT_LEVEL1 END' || CHR(10)
             || '        , ( CASE WHEN UPPER(MEASURE_GROUP) LIKE ''SALES%'' THEN 1' || CHR(10)
             || '                 WHEN UPPER(MEASURE_GROUP) LIKE ''PACK%''  THEN 2' || CHR(10)
             || '                 WHEN UPPER(MEASURE_GROUP) LIKE ''CELL%''  THEN 3' || CHR(10)
             || '                 ELSE 4 END )' || CHR(10)
             || '        , ( CASE WHEN INSTR(''Lv1'', OPERATION_GROUP) > 0 THEN 3' || CHR(10)
             || '                 WHEN UPPER(OPERATION_GROUP) = ''PACK'' THEN 1' || CHR(10)
             || '                 WHEN UPPER(OPERATION_GROUP) = ''CELL'' THEN 2' || CHR(10)
             || '                 ELSE 4 END )' || CHR(10)
             || '        , ' || FN_ORDER_EXPR('PRODUCT_LEVEL2') || CHR(10)
             || '        , SORT_ORDER_NO NULLS FIRST' || CHR(10)
             || '        , ' || FN_ORDER_EXPR('MEASURE_NAME')));

        /*==============================================================================
         * 2. PRODUCT_LEVEL1
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'PRODUCT_LEVEL1' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_PRODUCT_LEVEL1
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , PRODUCT_LEVEL1
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , OPERATION_GROUP
--                 , PRODUCT_LEVEL1
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , PRODUCT_LEVEL1
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , PRODUCT_LEVEL1
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL1
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL1
                    , MEASURE;

            /* 주차별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_PRODUCT_LEVEL1  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , CASE WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL2' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , OPERATION_GROUP' || CHR(10)
             || '                       , PRODUCT_LEVEL1' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , PRODUCT_LEVEL1' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL1(+) = A.PRODUCT_LEVEL1' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 3. PRODUCT_LEVEL2
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'PRODUCT_LEVEL2' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_PRODUCT_LEVEL2
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , PRODUCT_LEVEL2
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , OPERATION_GROUP
--                 , PRODUCT_LEVEL2
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , PRODUCT_LEVEL2
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            /* 주차별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_PRODUCT_LEVEL2  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , CASE WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL1' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , OPERATION_GROUP' || CHR(10)
             || '                       , PRODUCT_LEVEL2' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , PRODUCT_LEVEL2' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL2(+) = A.PRODUCT_LEVEL2' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 4. PRODUCT_LEVEL3
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'PRODUCT_LEVEL3' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_PRODUCT_LEVEL3
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , PRODUCT_LEVEL1
--              , PRODUCT_LEVEL2
--              , PRODUCT_LEVEL3
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT SUBSTR(YYYYPW,          1, 20)  AS YYYYPW      /* AS-IS 는 색인 크기 때문에 자릿수를 줄여 담는다 */
--                 , SUBSTR(DIVISION_ID,     1, 100) AS DIVISION_ID
--                 , SUBSTR(PLAN_TYPE,       1, 100) AS PLAN_TYPE   /* E20260708-000926 */
--                 , SUBSTR(CELL_GROUP,      1, 100) AS CELL_GROUP
--                 , SUBSTR(OPERATION_GROUP, 1, 100) AS OPERATION_GROUP
--                 , SUBSTR(PRODUCT_LEVEL1,  1, 100) AS PRODUCT_LEVEL1
--                 , SUBSTR(PRODUCT_LEVEL2,  1, 100) AS PRODUCT_LEVEL2
--                 , SUBSTR(PRODUCT_LEVEL3,  1, 100) AS PRODUCT_LEVEL3
--                 , SUBSTR(MEASURE,         1, 100) AS MEASURE_UI
--                 , SUM(CELL_QTY)                   AS QTY
--                 , SUM(FROM_BOH_QTY)               AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)                 AS TO_BOH_QTY
--                 , MAX(CELL_CF)                    AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , PRODUCT_LEVEL1
--                    , PRODUCT_LEVEL2
--                    , PRODUCT_LEVEL3
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL1
                    , PRODUCT_LEVEL2
                    , PRODUCT_LEVEL3
                    , MEASURE;

            /* 주차별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_PRODUCT_LEVEL3  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL3  = A.PRODUCT_LEVEL3' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , CASE WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , A.PRODUCT_LEVEL3' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT SUBSTR(YYYYPW,          1, 20)  AS YYYYPW      /* AS-IS 는 색인 크기 때문에 자릿수를 줄여 담는다 */' || CHR(10)
             || '                       , SUBSTR(DIVISION_ID,     1, 100) AS DIVISION_ID' || CHR(10)
             || '                       , SUBSTR(PLAN_TYPE,       1, 100) AS PLAN_TYPE   /* E20260708-000926 */' || CHR(10)
             || '                       , SUBSTR(CELL_GROUP,      1, 100) AS CELL_GROUP' || CHR(10)
             || '                       , SUBSTR(OPERATION_GROUP, 1, 100) AS OPERATION_GROUP' || CHR(10)
             || '                       , SUBSTR(PRODUCT_LEVEL1,  1, 100) AS PRODUCT_LEVEL1' || CHR(10)
             || '                       , SUBSTR(PRODUCT_LEVEL2,  1, 100) AS PRODUCT_LEVEL2' || CHR(10)
             || '                       , SUBSTR(PRODUCT_LEVEL3,  1, 100) AS PRODUCT_LEVEL3' || CHR(10)
             || '                       , SUBSTR(MEASURE,         1, 100) AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                   AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)               AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)                 AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                    AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , PRODUCT_LEVEL1' || CHR(10)
             || '                          , PRODUCT_LEVEL2' || CHR(10)
             || '                          , PRODUCT_LEVEL3' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL1(+) = A.PRODUCT_LEVEL1' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL2(+) = A.PRODUCT_LEVEL2' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL3(+) = A.PRODUCT_LEVEL3' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        END IF;

        /* 되돌리기가 필요한 자리가 없으므로 결과 커서를 바로 연다 */
        IF DBMS_LOB.GETLENGTH(V_SQL) > 0 THEN
            OPEN O_RC1 FOR V_SQL;
        ELSE
            /* AS-IS 는 조립된 문장이 빈 값이면 아무 결과도 돌려주지 않는다 */
            OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
        END IF;

        DBMS_LOB.FREETEMPORARY(V_FINAL_SUM_COLS);
        DBMS_LOB.FREETEMPORARY(V_QTY_COLS);

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0100_GET_GLOBAL_PSI_REPORT_WW_DATAONLY;

    /*******************************************************************************
     * P_SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY
     *   AS-IS SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY (월단위)
     *
     *   [동적 SQL 을 남긴 사유]
     *     최종 결과의 수량 칸이 조회 구간의 월 수만큼 생기는 피벗이라(M_202401 …)
     *     컬럼 자체가 가변이다. 이 구간만 동적 SQL 로 두고 나머지는 정적 SQL 로 옮겼다.
     *
     *   [AS-IS 대비 조치]
     *     1. 측정값 시트명 : 코드 'Global PSI NEW' ↔ 등록값 'Global PSI New'.
     *        MSSQL 은 대소문자를 가리지 않아 걸리지만 Oracle 은 갈려 측정값이 0건이 된다. UPPER 로 견준다.
     *     2. MEASURE_GROUP LIKE 'SALES%' · 'PACK%' · 'CELL%' (CELL_GROUP_DETAIL 정렬) :
     *        등록값이 'Sales PSI' · 'Pack PSI' · 'Cell PSI' 라 Oracle 에서는 하나도 걸리지 않는다. UPPER 로 견준다.
     *     3. VARIOUS_KEY != '' (LINE 적재 조건) : Oracle 에서 빈 문자는 NULL 이라 전건이 빠진다. TRIM(…) IS NOT NULL 로 바꾼다.
     *     4. 정렬 : AS-IS 정렬규칙 Latin1_General_CI_AS 는 대소문자·하이픈을 무시하고 밑줄을 앞에 둔다.
     *        FN_ORDER_EXPR 로 UPPER(TRANSLATE(칸,'_-/','/')) 를 1차 키, 원본을 2차 키로 둔다.
     *     5. 조회조건 대소문자 : AS-IS 는 CI 라 입력값 대소문자를 가리지 않는다. 칸·파라미터 모두 UPPER 로 견준다.
     *     6. 선택 조건 빈값 판정 : (@p IS NULL OR @p = '') 를 TRIM(P) IS NULL 로 바꿔 공백만 입력도 조건 없음으로 본다.
     *
     *   [AS-IS 에 그대로 남긴 결함 — 원문 보존]
     *     1. CHARINDEX(OPERATION_GROUP,'Lv1') 은 인자 순서가 뒤바뀌어 항상 0 이다(CELL_GROUP_DETAIL 정렬).
     *     2. IIF(MAX(SCP_OPERATION_GROUP)='P9500','PACK','MODULE') 은 SCP_OPERATION_GROUP 이 'A'·'P' 라 항상 'MODULE' 이다.
     *     3. AUTO 갈래의 @cntVarious 는 제외 목록에 VARIOUS_KEY 가 있어 항상 0 이므로 운송수단 룩업이 언제나 비워진다.
     *     4. @v_final_sum_wheres 는 조립한 직후 빈 문자로 덮여 최종 SQL 에 쓰이지 않는다. @v_day_cols 도 쓰이지 않는다.
     *        되풀이 문자열 연결만 남는 구간이라 조립을 옮기지 않았다(결과 동일).
     *******************************************************************************/
    PROCEDURE P_SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CELL_GROUP            IN  VARCHAR2
      , P_PROJECT               IN  VARCHAR2
      , P_SEARCH_LEVEL          IN  VARCHAR2
      , P_CHK_CELL_QTY          IN  VARCHAR2
      , P_CHK_AS                IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_SHEET_NAME            VARCHAR2(50);           /* 조회 칸 시트 (REPORT · SEARCH_LEVEL) */
        V_FINAL_COLS            VARCHAR2(4000);         /* 최종 조회 칸 목록 */
        V_FINAL_ORDER_COLS      VARCHAR2(4000);         /* 최종 정렬 칸 목록 */
        V_FINAL_SUM_COLS        CLOB;                   /* 연월별 수량 칸 집계식 */
        V_QTY_COLS              CLOB;                   /* 연월별 수량 칸 조회식 */
        V_COL_LIST              VARCHAR2(4000);         /* AUTO 갈래 사용자 칸 목록 */
        V_COL_LIST2             VARCHAR2(4000);
        V_COL_LIST_AUTO         VARCHAR2(4000);
        V_COL_WHERE             VARCHAR2(4000);
        V_COL_WHERE_COUNT       VARCHAR2(4000);
        V_CNT_VARIOUS           PLS_INTEGER := 0;

        V_FROM_YYYYMMDD         VARCHAR2(32);
        V_TO_YYYYMMDD           VARCHAR2(32);
        V_FROM_YYYYMM           VARCHAR2(32);
        V_TO_YYYYMM             VARCHAR2(32);
        V_FROM_RESULT           VARCHAR2(32);
        V_TO_RESULT             VARCHAR2(32);
        V_FROM_WW               VARCHAR2(32);
        V_TO_WW                 VARCHAR2(32);
        V_ISO_FROM_WW           VARCHAR2(32);
        V_ISO_TO_WW             VARCHAR2(32);

        V_SQL                   CLOB;
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        /* 세션에 남은 임시 자료 정리 */
        DELETE GT_SCP0100_MEASURE;
        DELETE GT_SCP0100_MEASURE1;
        DELETE GT_SCP0100_MEASURE2;
        DELETE GT_SCP0100_MEASURE3;
        DELETE GT_SCP0100_PRODUCTLEVEL;
        DELETE GT_SCP0100_OPERATION;
        DELETE GT_SCP0100_RAW;
        DELETE GT_SCP0100_CELL_GROUP_SORT_ORDER;
        DELETE GT_SCP0100_DIO_DETAIL_RAW;
        DELETE GT_SCP0100_DAYCOLS;
        DELETE GT_SCP0100_TRANSPORT_MODE_CODE;
        DELETE GT_SCP0100_LINE;
        DELETE GT_SCP0100_USER_COLS;
        DELETE GT_SCP0100_QTY_AUTO;
        DELETE GT_SCP0100_QTY_DETAIL;
        DELETE GT_SCP0100_QTY_CELL_GROUP;
        DELETE GT_SCP0100_QTY_CELL_GROUP_DETAIL;
        DELETE GT_SCP0100_QTY_PRODUCT_LEVEL1;
        DELETE GT_SCP0100_QTY_PRODUCT_LEVEL2;
        DELETE GT_SCP0100_QTY_PRODUCT_LEVEL3;
        DELETE GT_SCP0100_RAW_CELL_CF;
        DELETE GT_SCP0100_ALL_MEASURE_UI;
        DELETE GT_SCP0100_ALL_VARIOUS_KEY;
        DELETE GT_SCP0100_ALL_DISPLAY_SEQ;
        DELETE GT_SCP0100_ALL;

        /* 조회 칸 목록 · 정렬 칸 목록 */
        PR_SET_FINAL_COLS
        (
            P_USER_ID           => P_USER_ID
          , P_SEARCH_LEVEL      => P_SEARCH_LEVEL
          , O_SHEET_NAME        => V_SHEET_NAME
          , O_FINAL_COLS        => V_FINAL_COLS
          , O_FINAL_ORDER_COLS  => V_FINAL_ORDER_COLS
        );

        /* 계획 · 실적 기간정보 */
        PR_GET_REPORT_TERM_INFO
        (
            P_PLAN_START_YYYYMMDD   => P_PLAN_START_YYYYMMDD
          , P_FROM_YYYYMMDD         => P_FROM_YYYYMMDD
          , P_TO_YYYYMMDD           => P_TO_YYYYMMDD
          , O_PLAN_FROM_YYYYMMDD    => V_FROM_YYYYMMDD
          , O_PLAN_TO_YYYYMMDD      => V_TO_YYYYMMDD
          , O_PLAN_FROM_YYYYMM      => V_FROM_YYYYMM
          , O_PLAN_TO_YYYYMM        => V_TO_YYYYMM
          , O_RESULT_FROM_YYYYMMDD  => V_FROM_RESULT
          , O_RESULT_TO_YYYYMMDD    => V_TO_RESULT
          , O_PLAN_PARTIAL_FROM_WW  => V_FROM_WW
          , O_PLAN_PARTIAL_TO_WW    => V_TO_WW
          , O_PLAN_ISO_FROM_WW      => V_ISO_FROM_WW
          , O_PLAN_ISOL_TO_WW       => V_ISO_TO_WW
        );

        /*==============================================================================
         * GT_SCP0100_MEASURE — 조회 대상 측정값
         *   사용자가 지정한 측정값이 있으면 그것, 하나도 없으면 기본 측정값 전체
         *============================================================================*/
        INSERT INTO GT_SCP0100_MEASURE
        (
            MEASURE_UI
          , MEASURE_NAME
          , MEASURE_GROUP
          , SORT_ORDER_NO
        )
        SELECT A.COLUMN_NAME                    /* 사용자별 설정한 조회 대상 measure */
             , B.COLUMN_LABEL_NAME
             , B.SMALL_CLASS_LABEL_NAME
             , A.SORT_ORDER_NO
          FROM SCM_MST_TITLESET_USER    A
             , SCM_MST_SHEET_MEASURE    B
         WHERE UPPER(B.COLUMN_NAME)     = UPPER(A.COLUMN_NAME)
           AND UPPER(B.PROGRAM_ID)      = UPPER(C_PROGRAM_ID)
           AND UPPER(B.SHEET_NAME)      = UPPER(C_SHEET_NAME)
           AND B.VALID_YN               = 'Y'
           AND UPPER(A.PROGRAM_ID)      = UPPER(C_PROGRAM_ID)
           AND UPPER(A.SHEET_NAME)      = UPPER(C_SHEET_NAME)
           AND UPPER(A.USER_ID)         = UPPER(P_USER_ID)
         UNION ALL
        SELECT COLUMN_NAME                      /* 사용자별 설정한 measure 정보가 없을 경우 default measure */
             , COLUMN_LABEL_NAME
             , SMALL_CLASS_LABEL_NAME
             , SORT_ORDER_NO
          FROM SCM_MST_SHEET_MEASURE
         WHERE 1 = 1
           AND NOT EXISTS ( SELECT 1
                              FROM SCM_MST_TITLESET_USER    XA
                                 , SCM_MST_SHEET_MEASURE    XB
                             WHERE UPPER(XB.COLUMN_NAME)    = UPPER(XA.COLUMN_NAME)
                               AND UPPER(XB.PROGRAM_ID)     = UPPER(C_PROGRAM_ID)
                               AND UPPER(XB.SHEET_NAME)     = UPPER(C_SHEET_NAME)
                               AND XB.VALID_YN              = 'Y'
                               AND UPPER(XA.PROGRAM_ID)     = UPPER(C_PROGRAM_ID)
                               AND UPPER(XA.SHEET_NAME)     = UPPER(C_SHEET_NAME)
                               AND UPPER(XA.USER_ID)        = UPPER(P_USER_ID)
                          )
           AND UPPER(PROGRAM_ID)        = UPPER(C_PROGRAM_ID)
           AND UPPER(SHEET_NAME)        = UPPER(C_SHEET_NAME)
           AND VALID_YN                 = 'Y'
           AND DEFAULT_FLAG             = 'Y';

        IF UPPER(P_CHK_AS) = 'N' THEN
            DELETE GT_SCP0100_MEASURE
             WHERE UPPER(MEASURE_GROUP) = UPPER('AS Sales PSI');
        END IF;

        /*==============================================================================
         * GT_SCP0100_MEASURE1 / 2 / 3 — 측정값 갈래
         *============================================================================*/
        IF UPPER(P_SEARCH_LEVEL) = 'DETAIL' THEN

            INSERT INTO GT_SCP0100_MEASURE1
            (
                MEASURE_UI
              , MEASURE_NAME
              , MEASURE_GROUP
              , SORT_ORDER_NO
            )
            SELECT MEASURE_UI
                 , MEASURE_NAME
                 , MEASURE_GROUP
                 , SORT_ORDER_NO
              FROM GT_SCP0100_MEASURE
             WHERE UPPER(MEASURE_UI) NOT IN ('PACK_PROD', 'CELL_PROD');

        ELSE

            INSERT INTO GT_SCP0100_MEASURE1
            (
                MEASURE_UI
              , MEASURE_NAME
              , MEASURE_GROUP
              , SORT_ORDER_NO
            )
            SELECT MEASURE_UI
                 , MEASURE_NAME
                 , MEASURE_GROUP
                 , SORT_ORDER_NO
              FROM GT_SCP0100_MEASURE
             WHERE UPPER(MEASURE_UI) NOT IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN', 'PACK_PROD', 'CELL_PROD');

        END IF;

        INSERT INTO GT_SCP0100_MEASURE2
        (
            MEASURE_UI
          , MEASURE_NAME
          , MEASURE_GROUP
          , SORT_ORDER_NO
        )
        SELECT MEASURE_UI
             , MEASURE_NAME
             , MEASURE_GROUP
             , SORT_ORDER_NO
          FROM GT_SCP0100_MEASURE
         WHERE UPPER(MEASURE_UI) IN ('SHIP_PLAN', 'SEMI_SHIP_PLAN');

        INSERT INTO GT_SCP0100_MEASURE3
        (
            MEASURE_UI
          , MEASURE_NAME
          , MEASURE_GROUP
          , SORT_ORDER_NO
        )
        SELECT MEASURE_UI
             , MEASURE_NAME
             , MEASURE_GROUP
             , SORT_ORDER_NO
          FROM GT_SCP0100_MEASURE
         WHERE UPPER(MEASURE_UI) IN ('PACK_PROD', 'CELL_PROD');

        /*==============================================================================
         * GT_SCP0100_PRODUCTLEVEL — 제품단계
         *   [PJ20257329] 2025.08.01 공정 하드코딩 변경 반영본
         *============================================================================*/
        INSERT INTO GT_SCP0100_PRODUCTLEVEL
        (
            DIVISION_ID
          , ITEM_ID
          , FLOW_ID
          , BIZ_TYPE
          , GROUP_CODE6
          , GROUP_CODE7
          , GROUP_CODE5
          , BASIC_FINISHED_PRODUCT
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , FLOW_ID
             , CASE WHEN OPERATION_GROUP = 'A' THEN 'CELL'
                    WHEN OPERATION_GROUP = 'P' THEN CASE WHEN FLOW_ID = 'P9500' THEN 'PACK' ELSE 'MODULE' END
                    ELSE ''                     /* AS-IS 빈 문자. Oracle 에서는 NULL 이 된다(쓰이지 않는 칸) */
               END AS BIZ_TYPE
             , GROUP_CODE6
             , GROUP_CODE7
             , GROUP_CODE5
             , FINISHED_PRODUCT
          FROM SCP_MST_FINAL_ITEM
         WHERE 1 = 1
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND DIVISION_ID LIKE '81%';

        /*==============================================================================
         * GT_SCP0100_OPERATION — 공정
         *============================================================================*/
        INSERT INTO GT_SCP0100_OPERATION
        (
            DIVISION_ID
          , ITEM_ID
          , FLOW_ID
          , OPERATION
        )
        SELECT DIVISION_ID
             , ITEM_ID
             , MAX(FLOW_ID) AS FLOW_ID
             , CASE WHEN MAX(SCP_OPERATION_GROUP) = 'A' THEN 'CELL'
                    WHEN MAX(SCP_OPERATION_GROUP) = 'P'
                    /* AS-IS 결함 : SCP_OPERATION_GROUP 은 'A'·'P' 라 'P9500' 이 될 수 없어 언제나 'MODULE' */
                    THEN CASE WHEN MAX(SCP_OPERATION_GROUP) = 'P9500' THEN 'PACK' ELSE 'MODULE' END
                    ELSE ''
               END AS OPERATION
          FROM SCM_MST_ITEM_SN
         WHERE 1 = 1
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND DIVISION_ID LIKE '81%'
           AND ACTIVE_FLAG = 'Y'
           AND SCP_OPERATION_GROUP <> 'E'
         GROUP BY DIVISION_ID
                , ITEM_ID;

        /*==============================================================================
         * GT_SCP0100_RAW — 조회 원천
         *============================================================================*/
        INSERT INTO GT_SCP0100_RAW
        (
            PLAN_START_YYYYMMDD
          , DIVISION_ID
          , PLAN_TYPE
          , YYYYPW
          , ITEM_ID
          , OPERATION_GROUP
          , MEASURE
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , VARIOUS_KEY
          , REP_CELL_ITEM_ID
          , CELL_GROUP
          , CELL_GROUP_SORT_ORDER_NO
          , QTY
          , FROM_BOH_QTY
          , TO_BOH_QTY
          , CELL_CF
          , ATTRIBUTE3
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , FLOW_ID
          , OPERATION_ID
          , OPERATION_NAME
          , CELL_QTY
          , INV_SORT
        )
        SELECT A.PLAN_START_YYYYMMDD
             , A.DIVISION_ID
             , A.PLAN_TYPE                      /* E20260708-000926 */
             , A.YYYYMM
             , A.ITEM_ID
             , CASE WHEN A.MEASURE = 'DIO' THEN 'P'
                    ELSE A.OPERATION_GROUP
               END AS OPERATION_GROUP
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.REP_CELL_ITEM_ID
             , A.CELL_GROUP
             , CASE WHEN A.ATTRIBUTE10 = 'Y' THEN 1 ELSE 2 END AS CELL_GROUP_SORT_ORDER_NO
             , A.QTY
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.CELL_CF
             , A.ATTRIBUTE3
             , CASE WHEN TRIM(B.GROUP_CODE6) IS NULL THEN '-'
                    ELSE B.GROUP_CODE6
               END AS PRODUCT_LEVEL1
             , CASE WHEN TRIM(B.GROUP_CODE7) IS NULL THEN '-'
                    ELSE B.GROUP_CODE7
               END AS PRODUCT_LEVEL2
             , CASE WHEN TRIM(B.GROUP_CODE5) IS NULL THEN '-'
                    ELSE B.GROUP_CODE5
               END AS PRODUCT_LEVEL3
             , NVL(C.FLOW_ID,   '-') AS FLOW_ID
             , NVL(NULLIF(RTRIM(C.FLOW_ID),''), '/') AS OPERATION_ID
             , NVL(C.OPERATION, '-') AS OPERATION_NAME
             , CASE WHEN UPPER(P_CHK_CELL_QTY) = 'Y' AND A.QTY IS NOT NULL AND A.CELL_CF IS NOT NULL
                    THEN NVL(A.QTY, 0) * NVL(A.CELL_CF, 0)
                    ELSE A.QTY
               END AS CELL_QTY
             , TO_NUMBER(NVL(A.ATTRIBUTE8, '999')) AS INV_SORT
          FROM SCP_RPT_GLOBAL_PSI_MD_MM     A
             , GT_SCP0100_PRODUCTLEVEL      B
             , GT_SCP0100_OPERATION         C
         WHERE B.DIVISION_ID(+)             = A.DIVISION_ID
           AND B.ITEM_ID(+)                 = A.ATTRIBUTE3
           AND C.DIVISION_ID(+)             = A.DIVISION_ID
           AND C.ITEM_ID(+)                 = A.ITEM_ID
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(A.DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND ( TRIM(P_ITEM_ID) IS NULL
                 OR UPPER(A.ITEM_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ',')) )
               )
           AND ( TRIM(P_FROM_SITE) IS NULL
                 OR UPPER(A.FROM_SITE) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_FROM_SITE, ',')) )
               )
           AND ( TRIM(P_TO_SITE) IS NULL
                 OR UPPER(A.TO_SITE) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_TO_SITE, ',')) )
               )
           AND ( TRIM(P_PROJECT) IS NULL
                 OR UPPER(A.VARIOUS_KEY) LIKE '%' || UPPER(P_PROJECT) || '%'
               )
           AND ( TRIM(P_CELL_GROUP) IS NULL
                 OR UPPER(A.CELL_GROUP) LIKE '%' || UPPER(P_CELL_GROUP) || '%'
               )
           AND A.DIVISION_ID                LIKE '81%'
           AND A.PLAN_START_YYYYMMDD        = P_PLAN_START_YYYYMMDD
           AND UPPER(A.PLAN_TYPE)           = UPPER(P_PLAN_TYPE)     /* E20260708-000926 */
           AND A.YYYYMM                     BETWEEN V_FROM_YYYYMM AND V_TO_YYYYMM;

        /*==============================================================================
         * GT_SCP0100_CELL_GROUP_SORT_ORDER — 셀그룹 정렬순서
         *============================================================================*/
        INSERT INTO GT_SCP0100_CELL_GROUP_SORT_ORDER
        (
            DIVISION_ID
          , PLAN_TYPE
          , CELL_GROUP
          , MEASURE
          , CELL_GROUP_SORT_ORDER_NO
          , INV_SORT
        )
        SELECT DIVISION_ID
             , PLAN_TYPE                        /* E20260708-000926 */
             , CELL_GROUP
             , MEASURE
             , CELL_GROUP_SORT_ORDER_NO
             , MAX(INV_SORT) AS INV_SORT
          FROM GT_SCP0100_RAW
         GROUP BY DIVISION_ID
                , PLAN_TYPE
                , CELL_GROUP
                , MEASURE
                , CELL_GROUP_SORT_ORDER_NO;

        /*==============================================================================
         * GT_SCP0100_DIO_DETAIL_RAW — DIO 상세 원천 (고도화)
         *============================================================================*/
        INSERT INTO GT_SCP0100_DIO_DETAIL_RAW
        (
            PLAN_START_YYYYMMDD
          , DIVISION_ID
          , PLAN_TYPE
          , YYYYPW
          , ITEM_ID
          , OPERATION_GROUP
          , MEASURE
          , FROM_SITE
          , TO_SITE
          , INCOTERMS
          , VARIOUS_KEY
          , REP_CELL_ITEM_ID
          , CELL_GROUP
          , CELL_GROUP_SORT_ORDER_NO
          , QTY
          , FROM_BOH_QTY
          , TO_BOH_QTY
          , CELL_CF
          , ATTRIBUTE3
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , FLOW_ID
          , OPERATION_ID
          , OPERATION_NAME
          , CELL_QTY
          , INV_SORT
        )
        SELECT A.PLAN_START_YYYYMMDD
             , A.DIVISION_ID
             , A.PLAN_TYPE                      /* E20260708-000926 */
             , A.YYYYMM
             , A.ITEM_ID
             , A.OPERATION_GROUP
             , A.MEASURE
             , A.FROM_SITE
             , A.TO_SITE
             , A.INCOTERMS
             , A.VARIOUS_KEY
             , A.REP_CELL_ITEM_ID
             , A.CELL_GROUP
             , CASE WHEN A.ATTRIBUTE10 = 'Y' THEN 1 ELSE 2 END AS CELL_GROUP_SORT_ORDER_NO
             , A.QTY
             , A.FROM_BOH_QTY
             , A.TO_BOH_QTY
             , A.CELL_CF
             , A.ATTRIBUTE3
             , A.PRODUCT_LEVEL1
             , A.PRODUCT_LEVEL2
             , A.PRODUCT_LEVEL3
             , NVL(B.FLOW_ID,   '-') AS FLOW_ID
             , NVL(NULLIF(RTRIM(B.FLOW_ID),''), '/') AS OPERATION_ID
             , NVL(B.OPERATION, '-') AS OPERATION_NAME
             , CASE WHEN UPPER(P_CHK_CELL_QTY) = 'Y' AND A.QTY IS NOT NULL AND A.CELL_CF IS NOT NULL
                    THEN NVL(A.QTY, 0) * NVL(A.CELL_CF, 0)
                    ELSE A.QTY
               END AS CELL_QTY
             , TO_NUMBER(NVL(A.ATTRIBUTE8, '999')) AS INV_SORT
          FROM SCP_RPT_GLOBAL_PSI_MD_DETAIL_MM  A
             , GT_SCP0100_OPERATION             B
         WHERE B.DIVISION_ID(+)             = A.DIVISION_ID
           AND B.ITEM_ID(+)                 = A.ITEM_ID
           AND ( TRIM(P_DIVISION_ID) IS NULL
                 OR UPPER(A.DIVISION_ID) IN ( SELECT UPPER(VALUE) FROM TABLE(FN_SPLITSTRING(P_DIVISION_ID, ',')) )
               )
           AND ( TRIM(P_CELL_GROUP) IS NULL
                 OR UPPER(A.CELL_GROUP) LIKE '%' || UPPER(P_CELL_GROUP) || '%'
               )
           AND A.DIVISION_ID                LIKE '81%'
           AND A.PLAN_START_YYYYMMDD        = P_PLAN_START_YYYYMMDD
           AND UPPER(A.PLAN_TYPE)           = UPPER(P_PLAN_TYPE)     /* E20260708-000926 */
           AND A.YYYYMM                     BETWEEN V_FROM_YYYYMM AND V_TO_YYYYMM;

        INSERT INTO GT_SCP0100_CELL_GROUP_SORT_ORDER
        (
            DIVISION_ID
          , PLAN_TYPE
          , CELL_GROUP
          , MEASURE
          , CELL_GROUP_SORT_ORDER_NO
          , INV_SORT
        )
        SELECT DIVISION_ID
             , PLAN_TYPE                        /* E20260708-000926 */
             , CELL_GROUP
             , MEASURE
             , CELL_GROUP_SORT_ORDER_NO
             , MAX(INV_SORT) AS INV_SORT
          FROM GT_SCP0100_DIO_DETAIL_RAW
         GROUP BY DIVISION_ID
                , PLAN_TYPE
                , CELL_GROUP
                , MEASURE
                , CELL_GROUP_SORT_ORDER_NO;

        /*==============================================================================
         * GT_SCP0100_DAYCOLS — 연월 칸 목록
         *   임시 테이블 칸 이름은 주단위와 같이 쓴다(화면에 드러나지 않는 내부 칸).
         *   YYYYPW_NAME : 'M_' || 연월        예 M_202405
         *   YYYYPW      : 원장 YYYYMM 과 견줄 값  예 202405
         *============================================================================*/
        INSERT INTO GT_SCP0100_DAYCOLS
        (
            YYYYPW_NAME
          , YYYYPW
          , SORT_ORDER_NO
        )
        SELECT 'M_' || BASIS_YYYYMM                  AS YYYYPW_NAME
             , MAX(BASIS_YYYYMM)                     AS YYYYPW
             , MIN(BASIS_START_DATE) || '01'         AS SORT_ORDER_NO
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
           AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD
         GROUP BY BASIS_YYYYMM
                , MONTH_NAME;

        /*==============================================================================
         * 연월별 수량 칸 집계식
         *   AS-IS 는 @v_day_cols · @v_final_sum_wheres 도 함께 조립하지만
         *   @v_day_cols 는 최종 SQL 에 쓰이지 않고 @v_final_sum_wheres 는 조립 직후 빈 문자로 덮인다.
         *============================================================================*/
        V_FINAL_SUM_COLS := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_FINAL_SUM_COLS, TRUE);

        FOR R IN ( SELECT YYYYPW_NAME
                     FROM GT_SCP0100_DAYCOLS
                    ORDER BY SORT_ORDER_NO
                 )
        LOOP
            IF DBMS_LOB.GETLENGTH(V_FINAL_SUM_COLS) > 0 THEN
                DBMS_LOB.WRITEAPPEND(V_FINAL_SUM_COLS, LENGTH(CHR(10) || '        , '), CHR(10) || '        , ');
            END IF;
            DBMS_LOB.APPEND(V_FINAL_SUM_COLS, TO_CLOB('MAX(' || R.YYYYPW_NAME || ') AS ' || R.YYYYPW_NAME));
        END LOOP;

        /*==============================================================================
         * GT_SCP0100_TRANSPORT_MODE_CODE — 운송수단 룩업
         *============================================================================*/
        INSERT INTO GT_SCP0100_TRANSPORT_MODE_CODE
        (
            CODE
          , NAME
          , DISPLAY_SEQ
        )
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
             , DISPLAY_SEQ
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE 1 = 1
           AND UPPER(LOOKUP_TYPE) = 'TRANSPORT_MODE_CODE'
           AND VALID_YN           = 'Y';

        /*==============================================================================
         * GT_SCP0100_LINE — 생산 라인
         *   AS-IS 는 VARIOUS_KEY != '' 로 빈 문자를 걸러낸다.
         *   Oracle 에서 빈 문자는 NULL 이라 그대로 옮기면 전건이 빠지므로 TRIM(…) IS NOT NULL 로 바꾼다.
         *============================================================================*/
        INSERT INTO GT_SCP0100_LINE
        (
            YYYYPW
          , DIVISION_ID
          , PLAN_TYPE
          , CELL_GROUP
          , OPERATION_GROUP
          , OPERATION_ID
          , PRODUCT_LEVEL1
          , PRODUCT_LEVEL2
          , PRODUCT_LEVEL3
          , ITEM_ID
          , TO_SITE
          , FROM_SITE
          , INCOTERMS
          , MEASURE
          , VARIOUS_KEY
        )
        SELECT YYYYPW
             , DIVISION_ID
             , PLAN_TYPE                        /* E20260708-000926 */
             , CELL_GROUP
             , OPERATION_GROUP
             , OPERATION_ID
             , PRODUCT_LEVEL1
             , PRODUCT_LEVEL2
             , PRODUCT_LEVEL3
             , ITEM_ID
             , TO_SITE
             , FROM_SITE
             , INCOTERMS
             , MEASURE
             , VARIOUS_KEY
          FROM GT_SCP0100_RAW
         WHERE 1 = 1
           AND UPPER(MEASURE)       IN ('PACK_PROD', 'CELL_PROD')
           AND TRIM(VARIOUS_KEY)    IS NOT NULL
         GROUP BY YYYYPW
                , DIVISION_ID
                , PLAN_TYPE
                , CELL_GROUP
                , OPERATION_GROUP
                , OPERATION_ID
                , PRODUCT_LEVEL1
                , PRODUCT_LEVEL2
                , PRODUCT_LEVEL3
                , ITEM_ID
                , TO_SITE
                , FROM_SITE
                , INCOTERMS
                , MEASURE
                , VARIOUS_KEY;

        V_QTY_COLS := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_QTY_COLS, TRUE);

        V_SQL := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);

        /*==============================================================================
         * 1. AUTO
         *   AS-IS 는 사용자 지정 칸(SCM_MST_TITLESET_USER)과 REPORT 시트 칸을 내부조인해
         *   조회 칸 목록을 만든다. 사용자 지정 칸이 하나도 없으면 목록이 빈 값이 되어
         *   문장 전체가 빈 값이 되고 결과가 없다(AS-IS 와 같은 동작).
         *============================================================================*/
        IF UPPER(P_SEARCH_LEVEL) = 'AUTO' THEN

            INSERT INTO GT_SCP0100_USER_COLS
            (
                COLUMN_NAME
              , COLUMN_LABEL_NAME
              , SORT_ORDER_NO
            )
            SELECT CASE WHEN UPPER(A.COLUMN_NAME) = 'MEASURE_NAME' THEN 'MEASURE'
                        ELSE A.COLUMN_NAME
                   END AS COLUMN_NAME
                 , A.COLUMN_LABEL_NAME
                 , B.SORT_ORDER_NO
              FROM SCM_MST_SHEET_COLUMNS    A
                 , SCM_MST_TITLESET_USER    B
             WHERE UPPER(B.PROGRAM_ID)          = UPPER(A.PROGRAM_ID)
               AND UPPER(B.SHEET_NAME)          = UPPER(A.SHEET_NAME)
               AND UPPER(B.COLUMN_NAME)         = UPPER(A.COLUMN_NAME)
               AND UPPER(B.USER_ID)             = UPPER(P_USER_ID)
               AND UPPER(A.PROGRAM_ID)          = UPPER(C_PROGRAM_ID)
               AND UPPER(A.SHEET_NAME)          = 'REPORT'
               AND A.VALID_YN                   = 'Y'
               AND A.VISIBLE_FLAG               = 'Y'
               AND NVL(A.ATTRIBUTE6, 'Y')       <> 'N'
               AND UPPER(A.COLUMN_NAME)         NOT IN ('MEASURE_GROUP', 'MEASURE', 'MEASURE_NAME', 'VARIOUS_KEY', 'CELL_CF');

            /* AS-IS 결함 : 위 제외 목록에 VARIOUS_KEY 가 있어 이 건수는 언제나 0 이고
                            그 결과 운송수단 룩업이 늘 비워진다 */
            SELECT COUNT(*)
              INTO V_CNT_VARIOUS
              FROM GT_SCP0100_USER_COLS
             WHERE UPPER(COLUMN_NAME) = 'VARIOUS_KEY';

            IF V_CNT_VARIOUS = 0 THEN
                DELETE GT_SCP0100_TRANSPORT_MODE_CODE;
            END IF;

            SELECT LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG('A.' || COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG(' AND A.' || COLUMN_NAME || ' = D.' || COLUMN_NAME, '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
                 , LISTAGG(' AND SA.' || COLUMN_NAME || ' = A.' || COLUMN_NAME, '') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
              INTO V_COL_LIST
                 , V_COL_LIST2
                 , V_COL_WHERE
                 , V_COL_WHERE_COUNT
              FROM GT_SCP0100_USER_COLS;

            SELECT LISTAGG(COLUMN_NAME, ', ') WITHIN GROUP (ORDER BY SORT_ORDER_NO)
              INTO V_COL_LIST_AUTO
              FROM GT_SCP0100_USER_COLS
             WHERE UPPER(COLUMN_NAME) <> 'OPERATION_GROUP';

            IF V_COL_LIST IS NOT NULL THEN

                /* 연월별 수량 칸 */
                FOR R IN ( SELECT YYYYPW_NAME
                                , YYYYPW
                             FROM GT_SCP0100_DAYCOLS
                            ORDER BY SORT_ORDER_NO
                         )
                LOOP
                    DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
                        CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
                     || '           FROM GT_SCP0100_QTY_AUTO  SA' || CHR(10)
                     || '          WHERE 1 = 1' || CHR(10)
                     || '         ' || V_COL_WHERE_COUNT || CHR(10)
                     || '            AND SA.MEASURE_UI = A.MEASURE_UI' || CHR(10)
                     || '            AND SA.YYYYPW     = ''' || R.YYYYPW || '''' || CHR(10)
                     || '            AND ROWNUM        = 1 )  AS ' || R.YYYYPW_NAME));
                END LOOP;

                /* 수량 집계 */
                EXECUTE IMMEDIATE
                    'INSERT INTO GT_SCP0100_QTY_AUTO ( YYYYPW, ' || V_COL_LIST || ', MEASURE_UI, QTY, FROM_BOH_QTY, TO_BOH_QTY )'
                 || ' SELECT YYYYPW, ' || V_COL_LIST || ', MEASURE, SUM(CELL_QTY), SUM(FROM_BOH_QTY), SUM(TO_BOH_QTY)'
                 || '   FROM GT_SCP0100_RAW'
                 || '  GROUP BY YYYYPW, ' || V_COL_LIST || ', MEASURE';

                /* 셀환산계수 */
                EXECUTE IMMEDIATE
                    'INSERT INTO GT_SCP0100_RAW_CELL_CF ( ' || V_COL_LIST || ', MEASURE, VARIOUS_KEY, CELL_CF )'
                 || ' SELECT ' || V_COL_LIST || ', MEASURE, VARIOUS_KEY, MAX(CELL_CF)'
                 || '   FROM GT_SCP0100_RAW'
                 || '  GROUP BY ' || V_COL_LIST || ', MEASURE, VARIOUS_KEY';

                DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                    'SELECT FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', OPERATION_GROUP) AS OPERATION_GROUP' || CHR(10)
                 || '     , ' || V_COL_LIST_AUTO || CHR(10)
                 || '     , CASE WHEN OPERATION_GROUP = ''A'' AND UPPER(MEASURE_GROUP) = UPPER(''Sales PSI'') THEN ''Cell Sales PSI''' || CHR(10)
                 || '            ELSE MEASURE_GROUP' || CHR(10)
                 || '       END AS MEASURE_GROUP' || CHR(10)
                 || '     , MEASURE_UI' || CHR(10)
                 || '     , MEASURE_NAME' || CHR(10)
                 || '     , CASE WHEN OPERATION_GROUP = ''A'' AND UPPER(MEASURE_GROUP) = UPPER(''Sales PSI'') THEN SORT_ORDER_NO + 20' || CHR(10)
                 || '            ELSE SORT_ORDER_NO' || CHR(10)
                 || '       END AS SORT_ORDER_NO' || CHR(10)
                 || '     , CODE' || CHR(10)
                 || '     , VARIOUS_KEY' || CHR(10)
                 || '     , DISPLAY_SEQ' || CHR(10)
                 || '     , CELL_CF' || CHR(10)));

                DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);

                DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                    CHR(10) || '  FROM ( SELECT ' || V_COL_LIST || CHR(10)
                 || '              , B.MEASURE_GROUP                AS MEASURE_GROUP' || CHR(10)
                 || '              , B.MEASURE_UI                   AS MEASURE_UI' || CHR(10)
                 || '              , B.MEASURE_NAME                 AS MEASURE_NAME' || CHR(10)
                 || '              , B.SORT_ORDER_NO                AS SORT_ORDER_NO' || CHR(10)
                 || '              , CAST(NULL AS VARCHAR2(800))    AS CODE' || CHR(10)
                 || '              , ''-''                          AS VARIOUS_KEY' || CHR(10)
                 || '              , 1                              AS DISPLAY_SEQ' || CHR(10)
                 || '              , CELL_CF' || CHR(10)
                 || '           FROM GT_SCP0100_RAW_CELL_CF  A' || CHR(10)
                 || '              , GT_SCP0100_MEASURE1      B' || CHR(10)
                 || '          WHERE B.MEASURE_UI = A.MEASURE' || CHR(10)
                 || '         UNION' || CHR(10)
                 || '         SELECT ' || V_COL_LIST || CHR(10)
                 || '              , B.MEASURE_GROUP                AS MEASURE_GROUP' || CHR(10)
                 || '              , B.MEASURE_UI                   AS MEASURE_UI' || CHR(10)
                 || '              , B.MEASURE_NAME                 AS MEASURE_NAME' || CHR(10)
                 || '              , B.SORT_ORDER_NO                AS SORT_ORDER_NO' || CHR(10)
                 || '              , C.CODE' || CHR(10)
                 || '              , C.NAME                         AS VARIOUS_KEY' || CHR(10)
                 || '              , C.DISPLAY_SEQ' || CHR(10)
                 || '              , CELL_CF' || CHR(10)
                 || '           FROM GT_SCP0100_RAW_CELL_CF          A' || CHR(10)
                 || '              , GT_SCP0100_MEASURE2             B' || CHR(10)
                 || '              , GT_SCP0100_TRANSPORT_MODE_CODE  C' || CHR(10)
                 || '          WHERE B.MEASURE_UI = A.MEASURE' || CHR(10)
                 || '            AND C.CODE       = A.VARIOUS_KEY' || CHR(10)
                 || '         UNION' || CHR(10)
                 || '         SELECT ' || V_COL_LIST2 || CHR(10)
                 || '              , B.MEASURE_GROUP                AS MEASURE_GROUP' || CHR(10)
                 || '              , B.MEASURE_UI                   AS MEASURE_UI' || CHR(10)
                 || '              , B.MEASURE_NAME                 AS MEASURE_NAME' || CHR(10)
                 || '              , B.SORT_ORDER_NO                AS SORT_ORDER_NO' || CHR(10)
                 || '              , D.VARIOUS_KEY                  AS CODE' || CHR(10)
                 || '              , D.VARIOUS_KEY                  AS VARIOUS_KEY' || CHR(10)
                 || '              , 1                              AS DISPLAY_SEQ' || CHR(10)
                 || '              , CELL_CF' || CHR(10)
                 || '           FROM GT_SCP0100_RAW_CELL_CF  A' || CHR(10)
                 || '              , GT_SCP0100_MEASURE3      B' || CHR(10)
                 || '              , GT_SCP0100_LINE          D' || CHR(10)
                 || '          WHERE 1 = 1' || CHR(10)
                 || '         ' || V_COL_WHERE || CHR(10)
                 || '            AND B.MEASURE_UI = D.MEASURE' || CHR(10)
                 || '       )  IA' || CHR(10)
                 || ' WHERE MEASURE_UI NOT IN (''DIO'')' || CHR(10)
                 || ' ORDER BY ' || FN_ORDER_EXPR(V_COL_LIST) || CHR(10)
                 || '        , SORT_ORDER_NO NULLS FIRST' || CHR(10)
                 || '        , DISPLAY_SEQ NULLS FIRST' || CHR(10)
                 || '        , ' || FN_ORDER_EXPR('VARIOUS_KEY')));

            END IF;

        /*==============================================================================
         * 1. DETAIL
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'DETAIL' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_DETAIL
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , OPERATION_ID
--              , PRODUCT_LEVEL1
--              , PRODUCT_LEVEL2
--              , PRODUCT_LEVEL3
--              , ITEM_ID
--              , TO_SITE
--              , FROM_SITE
--              , VARIOUS_KEY
--              , INCOTERMS
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , OPERATION_GROUP
--                 , OPERATION_ID
--                 , PRODUCT_LEVEL1
--                 , PRODUCT_LEVEL2
--                 , PRODUCT_LEVEL3
--                 , ITEM_ID
--                 , TO_SITE
--                 , FROM_SITE
--                 , VARIOUS_KEY
--                 , INCOTERMS
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , OPERATION_ID
--                    , PRODUCT_LEVEL1
--                    , PRODUCT_LEVEL2
--                    , PRODUCT_LEVEL3
--                    , ITEM_ID
--                    , TO_SITE
--                    , FROM_SITE
--                    , VARIOUS_KEY
--                    , INCOTERMS
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , CELL_GROUP
              , PLAN_TYPE
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MEASURE
              , VARIOUS_KEY
              , CELL_CF
            )
            SELECT DIVISION_ID
                 , CELL_GROUP
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , MEASURE
                 , VARIOUS_KEY
                 , MAX(CELL_CF)                 AS CELL_CF
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , CELL_GROUP
                    , PLAN_TYPE
                    , OPERATION_GROUP
                    , OPERATION_ID
                    , ITEM_ID
                    , TO_SITE
                    , FROM_SITE
                    , INCOTERMS
                    , PRODUCT_LEVEL1
                    , PRODUCT_LEVEL2
                    , PRODUCT_LEVEL3
                    , MEASURE
                    , VARIOUS_KEY;

            INSERT INTO GT_SCP0100_ALL_MEASURE_UI
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_TYPE                  /* E20260708-000926 */
                 , A.CELL_GROUP
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.CELL_CF
                 , B.MEASURE_GROUP              AS MEASURE_GROUP
                 , B.MEASURE_UI                 AS MEASURE_UI
                 , B.MEASURE_NAME               AS MEASURE_NAME
                 , B.SORT_ORDER_NO              AS SORT_ORDER_NO
                 , CAST(NULL AS VARCHAR2(800))  AS CODE
                 , A.VARIOUS_KEY
                 , 1                            AS DISPLAY_SEQ
              FROM GT_SCP0100_RAW_CELL_CF   A
                 , GT_SCP0100_MEASURE1      B
             WHERE B.MEASURE_UI = A.MEASURE;

            INSERT INTO GT_SCP0100_ALL_VARIOUS_KEY
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_TYPE                  /* E20260708-000926 */
                 , A.CELL_GROUP
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.CELL_CF
                 , B.MEASURE_GROUP              AS MEASURE_GROUP
                 , B.MEASURE_UI                 AS MEASURE_UI
                 , B.MEASURE_NAME               AS MEASURE_NAME
                 , B.SORT_ORDER_NO              AS SORT_ORDER_NO
                 , C.CODE
                 , C.CODE                       AS VARIOUS_KEY
                 , C.DISPLAY_SEQ
              FROM GT_SCP0100_RAW_CELL_CF           A
                 , GT_SCP0100_MEASURE2              B
                 , GT_SCP0100_TRANSPORT_MODE_CODE   C
             WHERE B.MEASURE_UI = A.MEASURE
               AND C.CODE       = A.VARIOUS_KEY;

            INSERT INTO GT_SCP0100_ALL_DISPLAY_SEQ
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT A.DIVISION_ID
                 , A.PLAN_TYPE                  /* E20260708-000926 */
                 , A.CELL_GROUP
                 , A.OPERATION_GROUP
                 , A.OPERATION_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.FROM_SITE
                 , A.INCOTERMS
                 , A.PRODUCT_LEVEL1
                 , A.PRODUCT_LEVEL2
                 , A.PRODUCT_LEVEL3
                 , A.CELL_CF
                 , B.MEASURE_GROUP              AS MEASURE_GROUP
                 , B.MEASURE_UI                 AS MEASURE_UI
                 , B.MEASURE_NAME               AS MEASURE_NAME
                 , B.SORT_ORDER_NO              AS SORT_ORDER_NO
                 , C.VARIOUS_KEY                AS CODE
                 , C.VARIOUS_KEY                AS VARIOUS_KEY
                 , 1                            AS DISPLAY_SEQ
              FROM GT_SCP0100_RAW_CELL_CF   A
                 , GT_SCP0100_MEASURE3      B
                 , GT_SCP0100_LINE          C
             WHERE B.MEASURE_UI      = A.MEASURE
               AND C.DIVISION_ID     = A.DIVISION_ID
               AND C.PLAN_TYPE       = A.PLAN_TYPE           /* E20260708-000926 */
               AND C.CELL_GROUP      = A.CELL_GROUP
               AND C.OPERATION_GROUP = A.OPERATION_GROUP
               AND C.OPERATION_ID    = A.OPERATION_ID
               AND C.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1
               AND C.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2
               AND C.PRODUCT_LEVEL3  = A.PRODUCT_LEVEL3
               AND C.ITEM_ID         = A.ITEM_ID
               AND C.TO_SITE         = A.TO_SITE
               AND C.FROM_SITE       = A.FROM_SITE
               AND C.INCOTERMS       = A.INCOTERMS
               AND C.MEASURE         = B.MEASURE_UI;

            INSERT INTO GT_SCP0100_ALL
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , CELL_CF
                 , MEASURE_GROUP
                 , MEASURE_UI
                 , MEASURE_NAME
                 , SORT_ORDER_NO
                 , CODE
                 , VARIOUS_KEY
                 , DISPLAY_SEQ
              FROM GT_SCP0100_ALL_MEASURE_UI;

            INSERT INTO GT_SCP0100_ALL
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , CELL_CF
                 , MEASURE_GROUP
                 , MEASURE_UI
                 , MEASURE_NAME
                 , SORT_ORDER_NO
                 , CODE
                 , VARIOUS_KEY
                 , DISPLAY_SEQ
              FROM GT_SCP0100_ALL_VARIOUS_KEY;

            INSERT INTO GT_SCP0100_ALL
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , OPERATION_ID
              , ITEM_ID
              , TO_SITE
              , FROM_SITE
              , INCOTERMS
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , CELL_CF
              , MEASURE_GROUP
              , MEASURE_UI
              , MEASURE_NAME
              , SORT_ORDER_NO
              , CODE
              , VARIOUS_KEY
              , DISPLAY_SEQ
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , OPERATION_ID
                 , ITEM_ID
                 , TO_SITE
                 , FROM_SITE
                 , INCOTERMS
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , CELL_CF
                 , MEASURE_GROUP
                 , MEASURE_UI
                 , MEASURE_NAME
                 , SORT_ORDER_NO
                 , CODE
                 , VARIOUS_KEY
                 , DISPLAY_SEQ
              FROM GT_SCP0100_ALL_DISPLAY_SEQ;

            /* 연월별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_DETAIL  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_ID    = A.OPERATION_ID' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL3  = A.PRODUCT_LEVEL3' || CHR(10)
--                 || '            AND SA.ITEM_ID         = A.ITEM_ID' || CHR(10)
--                 || '            AND SA.TO_SITE         = A.TO_SITE' || CHR(10)
--                 || '            AND SA.FROM_SITE       = A.FROM_SITE' || CHR(10)
--                 || '            AND SA.VARIOUS_KEY     = A.VARIOUS_KEY' || CHR(10)
--                 || '            AND SA.INCOTERMS       = A.INCOTERMS' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = A.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP) AS OPERATION_GROUP' || CHR(10)
             || '              , A.OPERATION_ID' || CHR(10)
             || '              , A.ITEM_ID' || CHR(10)
             || '              , A.TO_SITE' || CHR(10)
             || '              , A.FROM_SITE' || CHR(10)
             || '              , A.INCOTERMS' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , A.PRODUCT_LEVEL3' || CHR(10)
             || '              , A.CELL_CF' || CHR(10)
             || '              , CASE WHEN A.OPERATION_GROUP = ''A'' AND UPPER(A.MEASURE_GROUP) = UPPER(''Sales PSI'') THEN ''Cell Sales PSI''' || CHR(10)
             || '                     ELSE A.MEASURE_GROUP' || CHR(10)
             || '                END AS MEASURE_GROUP' || CHR(10)
             || '              , A.MEASURE_UI' || CHR(10)
             || '              , A.MEASURE_NAME' || CHR(10)
             || '              , CASE WHEN A.OPERATION_GROUP = ''A'' AND UPPER(A.MEASURE_GROUP) = UPPER(''Sales PSI'') THEN A.SORT_ORDER_NO + 20' || CHR(10)
             || '                     ELSE A.SORT_ORDER_NO' || CHR(10)
             || '                END AS SORT_ORDER_NO' || CHR(10)
             || '              , B.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , A.CODE' || CHR(10)
             || '              , A.VARIOUS_KEY' || CHR(10)
             || '              , A.DISPLAY_SEQ' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_ALL                      A' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER  B' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , OPERATION_GROUP' || CHR(10)
             || '                       , OPERATION_ID' || CHR(10)
             || '                       , PRODUCT_LEVEL1' || CHR(10)
             || '                       , PRODUCT_LEVEL2' || CHR(10)
             || '                       , PRODUCT_LEVEL3' || CHR(10)
             || '                       , ITEM_ID' || CHR(10)
             || '                       , TO_SITE' || CHR(10)
             || '                       , FROM_SITE' || CHR(10)
             || '                       , VARIOUS_KEY' || CHR(10)
             || '                       , INCOTERMS' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , OPERATION_ID' || CHR(10)
             || '                          , PRODUCT_LEVEL1' || CHR(10)
             || '                          , PRODUCT_LEVEL2' || CHR(10)
             || '                          , PRODUCT_LEVEL3' || CHR(10)
             || '                          , ITEM_ID' || CHR(10)
             || '                          , TO_SITE' || CHR(10)
             || '                          , FROM_SITE' || CHR(10)
             || '                          , VARIOUS_KEY' || CHR(10)
             || '                          , INCOTERMS' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND B.MEASURE     = A.MEASURE_UI' || CHR(10)
             || '            AND B.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND B.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND A.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_ID(+) = A.OPERATION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL1(+) = A.PRODUCT_LEVEL1' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL2(+) = A.PRODUCT_LEVEL2' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL3(+) = A.PRODUCT_LEVEL3' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.ITEM_ID(+) = A.ITEM_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.TO_SITE(+) = A.TO_SITE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.FROM_SITE(+) = A.FROM_SITE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.VARIOUS_KEY(+) = A.VARIOUS_KEY' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.INCOTERMS(+) = A.INCOTERMS' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = A.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 1-1. CELL_GROUP
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'CELL_GROUP' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_CELL_GROUP
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , MEASURE;

            /* 연월별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_CELL_GROUP  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.MEASURE_UI  = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW      = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '     , MAX(INV_SORT) AS INV_SORT' || CHR(10)
             || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_GROUP' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL1' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL2' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '              , C.INV_SORT' || CHR(10)
             || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 1-2. CELL_GROUP_DETAIL (고도화)
         *   ORDER BY 를 조회 칸 목록이 아니라 본문에 박아 둔 갈래다.
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'CELL_GROUP_DETAIL' THEN

            INSERT INTO GT_SCP0100_QTY_CELL_GROUP_DETAIL
            (
                YYYYPW
              , DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE_UI
              , QTY
              , FROM_BOH_QTY
              , TO_BOH_QTY
              , CELL_CF
            )
            SELECT YYYYPW
                 , DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE                      AS MEASURE_UI
                 , SUM(CELL_QTY)                AS QTY
                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
                 , MAX(CELL_CF)                 AS CELL_CF
              FROM GT_SCP0100_RAW
             WHERE 1 = 1
               AND UPPER(MEASURE) NOT IN ('DIO_SALES', 'DIO_PACK', 'DIO_CELL')
             GROUP BY YYYYPW
                    , DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            INSERT INTO GT_SCP0100_QTY_CELL_GROUP_DETAIL
            (
                YYYYPW
              , DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE_UI
              , QTY
              , FROM_BOH_QTY
              , TO_BOH_QTY
              , CELL_CF
            )
            SELECT YYYYPW
                 , DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE                      AS MEASURE_UI
                 , SUM(CELL_QTY)                AS QTY
                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
                 , MAX(CELL_CF)                 AS CELL_CF
              FROM GT_SCP0100_DIO_DETAIL_RAW
             GROUP BY YYYYPW
                    , DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , PRODUCT_LEVEL1
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , PRODUCT_LEVEL1
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE
              FROM GT_SCP0100_DIO_DETAIL_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , PRODUCT_LEVEL1
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            /* 연월별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
                 || '           FROM GT_SCP0100_QTY_CELL_GROUP_DETAIL  SA' || CHR(10)
                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '     , MAX(INV_SORT) AS INV_SORT' || CHR(10)
             || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , CASE WHEN INSTR(A.OPERATION_GROUP, ''DIO'') > 0 THEN A.OPERATION_GROUP || ''(Lv1)''' || CHR(10)
             || '                     WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '              , C.INV_SORT' || CHR(10)
             || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT IN (''DIO'')' || CHR(10)
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             /* AS-IS 는 이 갈래만 정렬을 본문에 박아 두었다.
                MEASURE_GROUP 견줌은 등록값이 'Sales PSI' · 'Pack PSI' · 'Cell PSI' 라 UPPER 로 바꾼다.
                OPERATION_GROUP 견줌(INSTR(OPERATION_GROUP,'Lv1'))은 AS-IS 가 인자 순서를 뒤바꿔 놓아
                언제나 0 이다 — 원문 그대로 둔다. */
             || ' ORDER BY ' || FN_ORDER_EXPR('DIVISION_ID') || CHR(10)
             || '        , INV_SORT NULLS FIRST' || CHR(10)
             || '        , CELL_GROUP_SORT_ORDER_NO NULLS FIRST' || CHR(10)
             || '        , ' || FN_ORDER_EXPR('CELL_GROUP') || CHR(10)
             || '        , CASE WHEN PRODUCT_LEVEL1 = ''-'' THEN ''ZZZZ'' ELSE UPPER(TRANSLATE(PRODUCT_LEVEL1, ''_-/'', ''/'')) END' || CHR(10)
             || '        , CASE WHEN PRODUCT_LEVEL1 = ''-'' THEN ''ZZZZ'' ELSE PRODUCT_LEVEL1 END' || CHR(10)
             || '        , ( CASE WHEN UPPER(MEASURE_GROUP) LIKE ''SALES%'' THEN 1' || CHR(10)
             || '                 WHEN UPPER(MEASURE_GROUP) LIKE ''PACK%''  THEN 2' || CHR(10)
             || '                 WHEN UPPER(MEASURE_GROUP) LIKE ''CELL%''  THEN 3' || CHR(10)
             || '                 ELSE 4 END )' || CHR(10)
             || '        , ( CASE WHEN INSTR(''Lv1'', OPERATION_GROUP) > 0 THEN 3' || CHR(10)
             || '                 WHEN UPPER(OPERATION_GROUP) = ''PACK'' THEN 1' || CHR(10)
             || '                 WHEN UPPER(OPERATION_GROUP) = ''CELL'' THEN 2' || CHR(10)
             || '                 ELSE 4 END )' || CHR(10)
             || '        , ' || FN_ORDER_EXPR('PRODUCT_LEVEL2') || CHR(10)
             || '        , SORT_ORDER_NO NULLS FIRST' || CHR(10)
             || '        , ' || FN_ORDER_EXPR('MEASURE_NAME')));

        /*==============================================================================
         * 2. PRODUCT_LEVEL1
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'PRODUCT_LEVEL1' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_PRODUCT_LEVEL1
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , PRODUCT_LEVEL1
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , OPERATION_GROUP
--                 , PRODUCT_LEVEL1
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , PRODUCT_LEVEL1
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , PRODUCT_LEVEL1
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL1
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL1
                    , MEASURE;

            /* 연월별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_PRODUCT_LEVEL1  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , CASE WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL2' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , OPERATION_GROUP' || CHR(10)
             || '                       , PRODUCT_LEVEL1' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , PRODUCT_LEVEL1' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL1(+) = A.PRODUCT_LEVEL1' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 3. PRODUCT_LEVEL2
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'PRODUCT_LEVEL2' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_PRODUCT_LEVEL2
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , PRODUCT_LEVEL2
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT YYYYPW
--                 , DIVISION_ID
--                 , PLAN_TYPE                    /* E20260708-000926 */
--                 , CELL_GROUP
--                 , OPERATION_GROUP
--                 , PRODUCT_LEVEL2
--                 , MEASURE                      AS MEASURE_UI
--                 , SUM(CELL_QTY)                AS QTY
--                 , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)              AS TO_BOH_QTY
--                 , MAX(CELL_CF)                 AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , PRODUCT_LEVEL2
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , PRODUCT_LEVEL2
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL2
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL2
                    , MEASURE;

            /* 연월별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_PRODUCT_LEVEL2  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , CASE WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL1' || CHR(10)
             || '              , ''-''  AS PRODUCT_LEVEL3' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT YYYYPW' || CHR(10)
             || '                       , DIVISION_ID' || CHR(10)
             || '                       , PLAN_TYPE                    /* E20260708-000926 */' || CHR(10)
             || '                       , CELL_GROUP' || CHR(10)
             || '                       , OPERATION_GROUP' || CHR(10)
             || '                       , PRODUCT_LEVEL2' || CHR(10)
             || '                       , MEASURE                      AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)            AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)              AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                 AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , PRODUCT_LEVEL2' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL2(+) = A.PRODUCT_LEVEL2' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        /*==============================================================================
         * 4. PRODUCT_LEVEL3
         *============================================================================*/
        ELSIF UPPER(P_SEARCH_LEVEL) = 'PRODUCT_LEVEL3' THEN

--  2026.10.07 AJS (START) 수량 임시 테이블 적재 생략 — 같은 집계를 피벗 조회 안에서 한 번 읽는다
--            INSERT INTO GT_SCP0100_QTY_PRODUCT_LEVEL3
--            (
--                YYYYPW
--              , DIVISION_ID
--              , PLAN_TYPE
--              , CELL_GROUP
--              , OPERATION_GROUP
--              , PRODUCT_LEVEL1
--              , PRODUCT_LEVEL2
--              , PRODUCT_LEVEL3
--              , MEASURE_UI
--              , QTY
--              , FROM_BOH_QTY
--              , TO_BOH_QTY
--              , CELL_CF
--            )
--            SELECT SUBSTR(YYYYPW,          1, 20)  AS YYYYPW      /* AS-IS 는 색인 크기 때문에 자릿수를 줄여 담는다 */
--                 , SUBSTR(DIVISION_ID,     1, 100) AS DIVISION_ID
--                 , SUBSTR(PLAN_TYPE,       1, 100) AS PLAN_TYPE   /* E20260708-000926 */
--                 , SUBSTR(CELL_GROUP,      1, 100) AS CELL_GROUP
--                 , SUBSTR(OPERATION_GROUP, 1, 100) AS OPERATION_GROUP
--                 , SUBSTR(PRODUCT_LEVEL1,  1, 100) AS PRODUCT_LEVEL1
--                 , SUBSTR(PRODUCT_LEVEL2,  1, 100) AS PRODUCT_LEVEL2
--                 , SUBSTR(PRODUCT_LEVEL3,  1, 100) AS PRODUCT_LEVEL3
--                 , SUBSTR(MEASURE,         1, 100) AS MEASURE_UI
--                 , SUM(CELL_QTY)                   AS QTY
--                 , SUM(FROM_BOH_QTY)               AS FROM_BOH_QTY
--                 , SUM(TO_BOH_QTY)                 AS TO_BOH_QTY
--                 , MAX(CELL_CF)                    AS CELL_CF
--              FROM GT_SCP0100_RAW
--             GROUP BY YYYYPW
--                    , DIVISION_ID
--                    , PLAN_TYPE
--                    , CELL_GROUP
--                    , OPERATION_GROUP
--                    , PRODUCT_LEVEL1
--                    , PRODUCT_LEVEL2
--                    , PRODUCT_LEVEL3
--                    , MEASURE;
--  2026.10.07 AJS (END)

            INSERT INTO GT_SCP0100_RAW_CELL_CF
            (
                DIVISION_ID
              , PLAN_TYPE
              , CELL_GROUP
              , OPERATION_GROUP
              , PRODUCT_LEVEL1
              , PRODUCT_LEVEL2
              , PRODUCT_LEVEL3
              , MEASURE
            )
            SELECT DIVISION_ID
                 , PLAN_TYPE                    /* E20260708-000926 */
                 , CELL_GROUP
                 , OPERATION_GROUP
                 , PRODUCT_LEVEL1
                 , PRODUCT_LEVEL2
                 , PRODUCT_LEVEL3
                 , MEASURE
              FROM GT_SCP0100_RAW
             GROUP BY DIVISION_ID
                    , PLAN_TYPE
                    , CELL_GROUP
                    , OPERATION_GROUP
                    , PRODUCT_LEVEL1
                    , PRODUCT_LEVEL2
                    , PRODUCT_LEVEL3
                    , MEASURE;

            /* 연월별 수량 칸 */
            FOR R IN ( SELECT YYYYPW_NAME
                            , YYYYPW
                         FROM GT_SCP0100_DAYCOLS
                        ORDER BY SORT_ORDER_NO
                     )
            LOOP
                DBMS_LOB.APPEND(V_QTY_COLS, TO_CLOB(
--  2026.10.07 AJS (START) 칸별 스칼라 하위질의 -> 수량 집계 한 번 바깥 조인 + CASE
--                    CHR(10) || '     , ( SELECT SA.QTY' || CHR(10)
--                 || '           FROM GT_SCP0100_QTY_PRODUCT_LEVEL3  SA' || CHR(10)
--                 || '          WHERE SA.DIVISION_ID     = A.DIVISION_ID' || CHR(10)
--                 || '            AND SA.PLAN_TYPE       = A.PLAN_TYPE' || CHR(10)
--                 || '            AND SA.CELL_GROUP      = A.CELL_GROUP' || CHR(10)
--                 || '            AND SA.OPERATION_GROUP = A.OPERATION_GROUP' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL1  = A.PRODUCT_LEVEL1' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL2  = A.PRODUCT_LEVEL2' || CHR(10)
--                 || '            AND SA.PRODUCT_LEVEL3  = A.PRODUCT_LEVEL3' || CHR(10)
--                 || '            AND SA.MEASURE_UI      = B.MEASURE_UI' || CHR(10)
--                 || '            AND SA.YYYYPW          = ''' || R.YYYYPW || ''' )  AS ' || R.YYYYPW_NAME));
                    CHR(10) || '              , CASE WHEN SA.YYYYPW = ''' || R.YYYYPW || ''' THEN SA.QTY END  AS ' || R.YYYYPW_NAME));
--  2026.10.07 AJS (END)
            END LOOP;

            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                'SELECT ' || V_FINAL_COLS || CHR(10)
             || '     , '));
            DBMS_LOB.APPEND(V_SQL, V_FINAL_SUM_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
             || '              , A.PLAN_TYPE' || CHR(10)
             || '              , A.CELL_GROUP' || CHR(10)
             || '              , CASE WHEN B.MEASURE_UI = ''DIO''' || CHR(10)
             || '                     THEN FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', ''C'')' || CHR(10)
             || '                     ELSE FN_GET_LOOKUP_CODE_DESC(''OPERATION_GROUP_SCP'', A.OPERATION_GROUP)' || CHR(10)
             || '                END AS OPERATION_GROUP' || CHR(10)
             || '              , A.PRODUCT_LEVEL1' || CHR(10)
             || '              , A.PRODUCT_LEVEL2' || CHR(10)
             || '              , A.PRODUCT_LEVEL3' || CHR(10)
             || '              , B.MEASURE_GROUP' || CHR(10)
             || '              , B.MEASURE_UI' || CHR(10)
             || '              , B.MEASURE_NAME' || CHR(10)
             || '              , B.SORT_ORDER_NO' || CHR(10)
             || '              , C.CELL_GROUP_SORT_ORDER_NO' || CHR(10)
             || '              , ''-''  AS OPERATION_ID' || CHR(10)
             || '              , ''-''  AS ITEM_ID' || CHR(10)
             || '              , ''-''  AS TO_SITE' || CHR(10)
             || '              , ''-''  AS FROM_SITE' || CHR(10)
             || '              , ''-''  AS INCOTERMS' || CHR(10)
             || '              , ''-''  AS VARIOUS_KEY' || CHR(10)
             || '              , 1      AS CELL_CF' || CHR(10)
             || '              , A.MEASURE' || CHR(10)));
            DBMS_LOB.APPEND(V_SQL, V_QTY_COLS);
            DBMS_LOB.APPEND(V_SQL, TO_CLOB(
                CHR(10) || '           FROM GT_SCP0100_RAW_CELL_CF             A' || CHR(10)
             || '              , GT_SCP0100_MEASURE                 B' || CHR(10)
             || '              , GT_SCP0100_CELL_GROUP_SORT_ORDER    C' || CHR(10)
             || '              , (' || CHR(10)    --  2026.10.07 AJS (START) 수량 임시 테이블 대신 같은 집계
             || '                  SELECT SUBSTR(YYYYPW,          1, 20)  AS YYYYPW      /* AS-IS 는 색인 크기 때문에 자릿수를 줄여 담는다 */' || CHR(10)
             || '                       , SUBSTR(DIVISION_ID,     1, 100) AS DIVISION_ID' || CHR(10)
             || '                       , SUBSTR(PLAN_TYPE,       1, 100) AS PLAN_TYPE   /* E20260708-000926 */' || CHR(10)
             || '                       , SUBSTR(CELL_GROUP,      1, 100) AS CELL_GROUP' || CHR(10)
             || '                       , SUBSTR(OPERATION_GROUP, 1, 100) AS OPERATION_GROUP' || CHR(10)
             || '                       , SUBSTR(PRODUCT_LEVEL1,  1, 100) AS PRODUCT_LEVEL1' || CHR(10)
             || '                       , SUBSTR(PRODUCT_LEVEL2,  1, 100) AS PRODUCT_LEVEL2' || CHR(10)
             || '                       , SUBSTR(PRODUCT_LEVEL3,  1, 100) AS PRODUCT_LEVEL3' || CHR(10)
             || '                       , SUBSTR(MEASURE,         1, 100) AS MEASURE_UI' || CHR(10)
             || '                       , SUM(CELL_QTY)                   AS QTY' || CHR(10)
             || '                       , SUM(FROM_BOH_QTY)               AS FROM_BOH_QTY' || CHR(10)
             || '                       , SUM(TO_BOH_QTY)                 AS TO_BOH_QTY' || CHR(10)
             || '                       , MAX(CELL_CF)                    AS CELL_CF' || CHR(10)
             || '                    FROM GT_SCP0100_RAW' || CHR(10)
             || '                   GROUP BY YYYYPW' || CHR(10)
             || '                          , DIVISION_ID' || CHR(10)
             || '                          , PLAN_TYPE' || CHR(10)
             || '                          , CELL_GROUP' || CHR(10)
             || '                          , OPERATION_GROUP' || CHR(10)
             || '                          , PRODUCT_LEVEL1' || CHR(10)
             || '                          , PRODUCT_LEVEL2' || CHR(10)
             || '                          , PRODUCT_LEVEL3' || CHR(10)
             || '                          , MEASURE' || CHR(10)
             || '                )  SA' || CHR(10)    --  2026.10.07 AJS (END)
             || '          WHERE B.MEASURE_UI  = A.MEASURE' || CHR(10)
             || '            AND C.CELL_GROUP  = A.CELL_GROUP' || CHR(10)
             || '            AND C.MEASURE     = A.MEASURE' || CHR(10)
             || '            AND C.DIVISION_ID = A.DIVISION_ID' || CHR(10)
             || '            AND C.PLAN_TYPE   = A.PLAN_TYPE' || CHR(10)
             || '            AND B.MEASURE_UI  NOT LIKE ''%DIO%''' || CHR(10)
             || '            AND SA.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PLAN_TYPE(+) = A.PLAN_TYPE' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.CELL_GROUP(+) = A.CELL_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.OPERATION_GROUP(+) = A.OPERATION_GROUP' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL1(+) = A.PRODUCT_LEVEL1' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL2(+) = A.PRODUCT_LEVEL2' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.PRODUCT_LEVEL3(+) = A.PRODUCT_LEVEL3' || CHR(10)    --  2026.10.07 AJS
             || '            AND SA.MEASURE_UI(+) = B.MEASURE_UI' || CHR(10)    --  2026.10.07 AJS
             || '       )  IA' || CHR(10)
             || ' GROUP BY ' || V_FINAL_COLS || CHR(10)
             || ' ORDER BY ' || FN_ORDER_EXPR(V_FINAL_ORDER_COLS)));

        END IF;

        /* 되돌리기가 필요한 자리가 없으므로 결과 커서를 바로 연다 */
        IF DBMS_LOB.GETLENGTH(V_SQL) > 0 THEN
            OPEN O_RC1 FOR V_SQL;
        ELSE
            /* AS-IS 는 조립된 문장이 빈 값이면 아무 결과도 돌려주지 않는다 */
            OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
        END IF;

        DBMS_LOB.FREETEMPORARY(V_FINAL_SUM_COLS);
        DBMS_LOB.FREETEMPORARY(V_QTY_COLS);

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0100_GET_GLOBAL_PSI_REPORT_MM_DATAONLY;

END PKG_SCP0100;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0100
