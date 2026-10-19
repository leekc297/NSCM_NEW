PACKAGE BODY PKG_SCP0125
IS
    /*
     * Package ID   : PKG_SCP0125
     * Description  : SCP0125 Workbench
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026/09/17   AJS            MSSQL -> Oracle 전환 (AS-IS 프로시저 12 개 편입)
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     *
     * 전환 규칙 (AS-IS 와 결과를 맞추기 위한 자리)
     *   1. 정렬 : AS-IS 정렬규칙(Latin1_General_CI_AS)은 대소문자 무시 · 하이픈 무시 · 밑줄이 글자 앞.
     *            문자 정렬 키는 UPPER(TRANSLATE(x, '_-', '/')) NULLS FIRST, 같은 값 안에서는 하이픈을 살린
     *            UPPER(TRANSLATE(x, '_', '/')) NULLS FIRST 로 둔다 (빈 문자가 '-' 보다 앞).
     *   2. 검색 : AS-IS LIKE 는 대소문자 무시. 품목 · 닉네임 원장에 소문자가 없어 입력값만 UPPER.
     *   3. 빈 문자 : 기준 데이터베이스는 이관 시 NOT NULL 칸의 빈 문자를 '-' 로 채웠다.
     *            저장은 빈 토큰을 '-' 로 넣고, 조회의 조정 테이블 조인은 계산값이 빈 값이면 '-' 로 맞춘다.
     *   4. 저장 키 비교는 AS-IS 처럼 대소문자를 무시한다. 대소문자만 다른 키의 등록은 기본키 중복으로 막는다.
     *   5. GTT 통계 수집은 트랜잭션을 확정하므로 두지 않는다.
     *   6. AS-IS 에서 값을 넣기만 하고 쓰지 않는 변수 · 테이블변수(@P_MODELING_ID · @MAT_CONST_TEMP 등)는 옮기지 않았다.
     */

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(4000 CHAR) INDEX BY PLS_INTEGER;

    E_BIZ EXCEPTION;


    /* ------------------------------------------------------------
       오류 로그
       ------------------------------------------------------------ */
    PROCEDURE P_LOG_ERROR
    (
        P_PROGRAM_NAME  IN  VARCHAR2,
        P_IN_PARA_DATA  IN  VARCHAR2,
        P_SQLCODE       IN  VARCHAR2,
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
                           , P_SQLCODE
                           , SUBSTR(P_SQLERRM, 1, 2000)
                           , SUBSTR(P_BACKTRACE, 1, 4000));
    END P_LOG_ERROR;


    /* ------------------------------------------------------------
       ^ 구분 CLOB 분리 (AS-IS SCM_ARR_SPL_VAL · SCM_ARR_SPL_CNT 대응)
       - 토큰 앞뒤 공백 제거, 순번 1 부터
       - O_CNT : AS-IS SCM_ARR_SPL_CNT (구분자 수 + 1, 입력이 비어 있어도 1)
       - 빈 토큰(a^^b · 끝의 a^ · 빈 입력)도 순번을 차지한다(값 NULL). 순번이 없으면 없는 토큰
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
            O_TAB(1) := NULL;                          /* AS-IS 빈 입력의 1 번 토큰은 빈 문자 */
            O_CNT := 1;
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
        ELSE
            O_TAB(V_NR) := NULL;                       /* 끝 구분자 뒤 빈 토큰 */
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


    /* NOT NULL 문자 칸용 토큰 - 빈 토큰은 이관 규칙과 같게 '-', 없는 토큰은 NULL (AS-IS 필수값 오류 재현) */
    FUNCTION F_KEY
    (
        P_TAB       IN  T_TOKEN_TAB,
        P_IDX       IN  PLS_INTEGER
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF P_TAB.EXISTS(P_IDX) THEN
            RETURN NVL(P_TAB(P_IDX), '-');
        END IF;

        RETURN NULL;
    END F_KEY;


    /* ==================================================================================================
       Workbench 조회조건 및 콤보박스 정보
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_SEARCH_INFO
    (
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR,
        O_RC4                   OUT SYS_REFCURSOR,
        O_RC5                   OUT SYS_REFCURSOR,
        O_RC6                   OUT SYS_REFCURSOR,
        O_RC7                   OUT SYS_REFCURSOR,
        O_RC8                   OUT SYS_REFCURSOR,
        O_RC9                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    BEGIN

        /* 1. MKT FCST Version 정보(60일전 버전까지 ) */
        OPEN O_RC1 FOR
        SELECT VERSION_NO AS CODE
             , VERSION_NO AS NAME
             , DIVISION_ID
             , YYYYMMDD
          FROM DM_MST_VERSION
         WHERE VERSION_TYPE IN ('MF_W', 'SF_W')
           AND YYYYMMDD >= TO_CHAR(SYSDATE - 60, 'YYYYMMDD')      /* 20260101 YMH NERP 5차 점검리스트 대응 */
         ORDER BY UPPER(TRANSLATE(VERSION_NO, '_-', '/')) DESC NULLS LAST
                , UPPER(TRANSLATE(VERSION_NO, '_', '/')) DESC NULLS LAST;

        /* 2. Sale Site */
        /* 40 사업부 갈래의 LEFT JOIN SCM_MST_SITE_ITEM 은 DISTINCT 로 결과에 영향이 없어 옮기지 않았다 */
        OPEN O_RC2 FOR
        SELECT IA.DIVISION_ID
             , IA.CODE
             , IA.NAME
          FROM (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID AS CODE
                     , SCM_SITE_ID AS NAME
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES'
                   AND DIVISION_ID <> '40'
                   AND VALID_YN = 'Y'
                 UNION ALL
                SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SCM_SITE_ID
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES'
                   AND DIVISION_ID = '40'
                   AND VALID_YN = 'Y') IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST;

        /* 3. Plant Site */
        OPEN O_RC3 FOR
        SELECT DISTINCT DIVISION_ID
             , SCM_SITE_ID AS CODE
             , SCM_SITE_ID AS NAME
             , PLANT_ID
          FROM SCM_MST_SITE
         WHERE SITE_TYPE = 'PLANT'
           AND VALID_YN = 'Y';                                     /* [PJ20257329] Stock(2nd OCV) 탭 추가 (2025-10-29) */

        /* 4. 재고 SCM SITE ID */
        OPEN O_RC4 FOR
        SELECT IA.DIVISION_ID
             , IA.CODE
             , IA.NAME
          FROM (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID AS CODE
                     , SCM_SITE_ID AS NAME
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES'
                   AND DIVISION_ID <> '40'
                   AND VALID_YN = 'Y'
                 UNION ALL
                SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SCM_SITE_ID
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES'
                   AND DIVISION_ID = '40'
                   AND VALID_YN = 'Y'
                 UNION ALL
                SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SCM_SITE_ID
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'PLANT') IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST;

        /* 5.Item 정보(Validation 체크용) */
        OPEN O_RC5 FOR
        SELECT DISTINCT DIVISION_ID
             , ITEM_ID
          FROM SCM_MST_ITEM_SN;

        /* 6.Project code 정보(Validation 체크용) */
        OPEN O_RC6 FOR
        SELECT DISTINCT DIVISION_ID
             , PROJECT_CODE
          FROM SCM_MST_PROJECT;

        /* 7.소형 Project code 정보(Validation 체크용) --소형 Project code 정보(2025-07-14) */
        OPEN O_RC7 FOR
        SELECT IA.CODE
             , IA.NAME
          FROM (SELECT DISTINCT A.PROJECT_CODE AS CODE
                     , NVL(D.SEGMENT3, A.PROJECT_CODE) AS NAME
                  FROM SCM_MST_SITE_ITEM A
                     , SCM_MST_SSO_USER_INFO B
                     , SCM_MST_SSO_DEPT_INFO C
                     , SCM_ADM_LOOKUP_MASTER_DETAIL D
                 WHERE UPPER(B.USER_ID) = UPPER(A.OWNER)                                            /* AS-IS 대소문자 무시 비교 */
                   AND C.DEPT_ID = B.DEPT_ID
                   AND D.SEGMENT1(+) = A.DIVISION_ID
                   AND D.SEGMENT2(+) = A.PROJECT_CODE
                   AND UPPER(B.USER_ID) = UPPER(TRIM(SUBSTR(A.OWNER, 1, INSTR(A.OWNER || ',', ',') - 1)))   /* STRING_SPLIT 첫 토큰 */
                   AND D.LOOKUP_TYPE(+) = 'END_CUSTOMER'
                   AND D.VALID_YN(+) = 'Y'
                   AND A.DIVISION_ID = '40'
                   AND A.VALID_YN = 'Y'
                 UNION
                SELECT SEGMENT2 AS CODE
                     , SEGMENT3 AS NAME
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'END_CUSTOMER'
                   AND SEGMENT2 <> '-'
                   AND VALID_YN = 'Y'
                   AND SEGMENT1 = '40') IA
         ORDER BY UPPER(TRANSLATE(IA.CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.CODE, '_', '/')) NULLS FIRST
                , IA.CODE NULLS FIRST;

        /* [PJ20257329] 재고(Elec.) 탭 추가 (2025-09-17) STRAT */
        /* 8.Location Code 정보(combo용) */
        OPEN O_RC8 FOR
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
             , SEGMENT3 AS ELEC_YN
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'OPMZ_LOCATION_CODE'
           AND SEGMENT3 = 'Y'
           AND VALID_YN = 'Y'
         ORDER BY DISPLAY_SEQ NULLS FIRST;

        /* 9.Line 정보(combo용) */
        OPEN O_RC9 FOR
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.OPERATION_ID
             , A.LINE_ID AS CODE
             , A.LINE_ID AS NAME
             , MAX(A.LINE_NAME) AS LINE_NAME
          FROM SCM_MST_LINE_SN A
             , SCM_MST_FACTORY_SN B
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.FACTORY_ID = A.FACTORY_ID
           AND EXISTS (SELECT 1
                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL XA
                        WHERE XA.SEGMENT1 = A.OPERATION_ID
                          AND XA.SEGMENT4 LIKE '%' || A.DIVISION_ID || '%'
                          AND XA.LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                          AND XA.VALID_YN = 'Y')
           AND A.ACTIVE_FLAG = 'Y'
         GROUP BY A.DIVISION_ID
                , A.PLANT_ID
                , A.OPERATION_ID
                , A.LINE_ID;
        /* [PJ20257329] 재고(Elec.) 탭 추가 (2025-09-17) END */

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_SEARCH_INFO'
                      , NULL
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_SEARCH_INFO;


    /* ==================================================================================================
       MKT FCST 조회
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_MKT_FCST_ADJ
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    BEGIN

        OPEN O_RC1 FOR
        SELECT IA.*
             , IA.CHG_QTY AS PRE_CHG_QTY
             , IA.CHG_RSN AS PRE_CHG_RSN
          FROM (SELECT IB.DIVISION_ID
                     , IB.VERSION_NO
                     , IB.CUTOFF_YYYYMMDD
                     , IB.PROJECT_CODE
                     , IB.PROJECT_CODE AS PROJECT_CODE_40               /* 소형(40)의 Project Code ==> End Customer 적용 (2025-07-14) */
                     , IB.SCM_SITE_ID
                     , IB.NICK_NAME                                     /* Nick Name 추가 (2025-07-14) */
                     , IB.ITEM_ID
                     , IB.FCST_TYPE
                     , C.SEGMENT2 AS FCST_TYPE_NAME
                     , IB.INCOTERMS
                     , IB.PLANT_SITE_ID
                     , IB.CELL_PROD_SITE_ID
                     , TO_DATE(IB.YYYYMMDD, 'YYYYMMDD') AS DUE_DATE     /* 기준일자 */
                     , IB.QTY
                     , B.CHG_QTY
                     , B.CHG_RSN
                     , B.CHG_TYPE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                  FROM (SELECT A.DIVISION_ID
                             , A.VERSION_NO
                             , A.CUTOFF_YYYYMMDD
                             , A.PROJECT_CODE
                             , A.SCM_SITE_ID
                             , IC.NICK_NAME
                             , A.ITEM_ID
                             , A.FCST_TYPE
                             , A.INCOTERMS
                             , A.PLANT_SITE_ID
                             , A.CELL_PROD_SITE_ID
                             , A.ATTRIBUTE1 AS YYYYMMDD                 /* 기준일자 , DUE DATE 변경 (2025-08-06 요청) */
                             , SUM(A.QTY) AS QTY
                          FROM DM_PLN_NET_DEMAND A
                             , (SELECT DIVISION_ID
                                     , ITEM_ID
                                     , MAX(NICK_NAME) AS NICK_NAME
                                  FROM SCM_MST_ITEM_SN
                                 WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                                 GROUP BY DIVISION_ID
                                        , ITEM_ID) IC
                         WHERE IC.DIVISION_ID(+) = A.DIVISION_ID
                           AND IC.ITEM_ID(+) = A.ITEM_ID
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.VERSION_NO = P_VERSION_NO
                           /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                           AND (RTRIM(P_ITEM_ID) IS NULL OR A.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                           AND (RTRIM(P_ITEM_ID) IS NULL
                            OR  EXISTS (SELECT 1
                                          FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                         WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                           AND (UPPER(A.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                            OR  UPPER(IC.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                           /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                           AND (RTRIM(P_NICK_NAME) IS NULL OR IC.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                         GROUP BY A.DIVISION_ID
                                , A.VERSION_NO
                                , A.CUTOFF_YYYYMMDD
                                , A.PROJECT_CODE
                                , A.SCM_SITE_ID
                                , IC.NICK_NAME
                                , A.ITEM_ID
                                , A.FCST_TYPE
                                , A.INCOTERMS
                                , A.PLANT_SITE_ID
                                , A.CELL_PROD_SITE_ID
                                , A.ATTRIBUTE1) IB
                     , SCP_OPMZ_DMD_ADJ B
                     , SCM_ADM_LOOKUP_MASTER_DETAIL C
                 WHERE B.DIVISION_ID(+) = IB.DIVISION_ID
                   AND B.VERSION_NO(+) = IB.VERSION_NO
                   AND B.CUTOFF_YYYYMMDD(+) = IB.CUTOFF_YYYYMMDD
                   AND B.PROJECT_CODE(+) = IB.PROJECT_CODE
                   AND B.SCM_SITE_ID(+) = IB.SCM_SITE_ID
                   AND B.ITEM_ID(+) = IB.ITEM_ID
                   AND B.FCST_TYPE(+) = IB.FCST_TYPE
                   AND B.INCOTERMS(+) = IB.INCOTERMS
                   AND B.PLANT_SITE_ID(+) = IB.PLANT_SITE_ID
                   AND B.CELL_PROD_SITE_ID(+) = IB.CELL_PROD_SITE_ID
                   AND B.DUE_DATE(+) = NVL(IB.YYYYMMDD, '-')
                   AND C.SEGMENT1(+) = IB.FCST_TYPE
                   AND C.LOOKUP_TYPE(+) = 'SALES_TYPE_CODE'
                /* Insert 된 정보 */
                 UNION ALL
                SELECT D.DIVISION_ID
                     , D.VERSION_NO
                     , D.CUTOFF_YYYYMMDD
                     , D.PROJECT_CODE
                     , D.PROJECT_CODE
                     , D.SCM_SITE_ID
                     , ID.NICK_NAME
                     , D.ITEM_ID
                     , D.FCST_TYPE
                     , E.SEGMENT2
                     , D.INCOTERMS
                     , D.PLANT_SITE_ID
                     , D.CELL_PROD_SITE_ID
                     , TO_DATE(D.DUE_DATE, 'YYYYMMDD')
                     , D.QTY
                     , D.CHG_QTY
                     , D.CHG_RSN
                     , D.CHG_TYPE
                     , D.LAST_UPDATED_BY
                     , D.LAST_UPDATE_DATE
                  FROM SCP_OPMZ_DMD_ADJ D
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) ID
                     , SCM_ADM_LOOKUP_MASTER_DETAIL E
                 WHERE ID.DIVISION_ID(+) = D.DIVISION_ID
                   AND ID.ITEM_ID(+) = D.ITEM_ID
                   AND E.SEGMENT1(+) = D.FCST_TYPE
                   AND E.LOOKUP_TYPE(+) = 'SALES_TYPE_CODE'
                   AND UPPER(D.CHG_TYPE) = 'NEW'
                   AND D.DIVISION_ID = P_DIVISION_ID
                   AND D.VERSION_NO = P_VERSION_NO
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR D.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(D.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(ID.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR ID.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.VERSION_NO, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.VERSION_NO, '_', '/')) NULLS FIRST
                , IA.CUTOFF_YYYYMMDD NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.NICK_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.NICK_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.FCST_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.FCST_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLANT_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLANT_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.CELL_PROD_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.CELL_PROD_SITE_ID, '_', '/')) NULLS FIRST
                , IA.DUE_DATE NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_MKT_FCST_ADJ'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_VERSION_NO=' || P_VERSION_NO || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_MKT_FCST_ADJ;


    /* ==================================================================================================
       Elec. Demand 조회
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_ELEC_DEMAND
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    BEGIN

        OPEN O_RC1 FOR
        SELECT IA.*
          FROM (SELECT IB.DIVISION_ID
                     , IB.PLAN_START_YYYYMMDD
                     , IB.PLAN_TYPE
                     , IB.SEQ
                     , IB.SCM_SITE_ID AS PLANT_SITE_ID
                     , IC.NICK_NAME
                     , IB.ITEM_ID
                     , IB.LINE_ID
                     , IB.OPERATION_ID
                     , TO_DATE(IB.YYYYMMDD, 'YYYYMMDD') AS YYYYMMDD     /* 아래 갈래가 날짜라 AS-IS 도 날짜로 바뀐다 */
                     , IB.QTY
                     , B.CHG_QTY
                     , B.CHG_RSN
                     , B.CHG_TYPE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                     , B.CHG_QTY AS PRE_CHG_QTY
                     , B.CHG_RSN AS PRE_CHG_RSN
                  FROM (SELECT A.DIVISION_ID
                             , A.PLAN_START_YYYYMMDD
                             , A.PLAN_TYPE
                             , MAX(A.SEQ) AS SEQ
                             , A.SCM_SITE_ID
                             , A.ITEM_ID
                             , A.LINE_ID
                             , A.OPERATION_ID
                             , A.YYYYMMDD
                             , SUM(A.QTY) AS QTY
                             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SCM_SITE_ID
                                                             , A.ITEM_ID, A.LINE_ID, A.OPERATION_ID, A.YYYYMMDD
                                                      ORDER BY A.SEQ DESC) AS RN
                          FROM SCP_ANL_PRODUCTION_PLAN A
                         WHERE A.PLAN_TYPE = 'FN'
                           AND A.MEASURE = 'PROD_PLAN_AMEND'
                           AND A.OPERATION_GROUP = 'A'
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND A.PLAN_START_YYYYMMDD_DATE = TO_DATE(P_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')  /* 파티션 키 */
                         GROUP BY A.DIVISION_ID
                                , A.PLAN_START_YYYYMMDD
                                , A.PLAN_TYPE
                                , A.SCM_SITE_ID
                                , A.ITEM_ID
                                , A.LINE_ID
                                , A.OPERATION_ID
                                , A.YYYYMMDD
                                , A.QTY
                                , A.SEQ
                        HAVING SUM(A.QTY) > 0) IB
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IC
                     , SCP_OPMZ_DMD_ELEC B
                 WHERE IC.DIVISION_ID(+) = IB.DIVISION_ID
                   AND IC.ITEM_ID(+) = IB.ITEM_ID
                   AND B.DIVISION_ID(+) = IB.DIVISION_ID
                   AND B.PLAN_START_YYYYMMDD(+) = IB.PLAN_START_YYYYMMDD
                   AND B.PLAN_TYPE(+) = IB.PLAN_TYPE
                   AND B.PLANT_SITE_ID(+) = IB.SCM_SITE_ID
                   AND B.ITEM_ID(+) = IB.ITEM_ID
                   AND B.LINE_ID(+) = IB.LINE_ID
                   AND B.OPERATION_ID(+) = IB.OPERATION_ID
                   AND B.YYYYMMDD(+) = IB.YYYYMMDD
                   AND IB.RN = 1
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR IB.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                 WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(IB.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IC.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IC.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                /* Insert 된 정보 */
                 UNION ALL
                SELECT C.DIVISION_ID
                     , C.PLAN_START_YYYYMMDD
                     , C.PLAN_TYPE
                     , TO_NUMBER(C.SEQ)
                     , C.PLANT_SITE_ID
                     , ID.NICK_NAME
                     , C.ITEM_ID
                     , C.LINE_ID
                     , C.OPERATION_ID
                     , TO_DATE(C.YYYYMMDD, 'YYYYMMDD')
                     , C.QTY
                     , C.CHG_QTY
                     , C.CHG_RSN
                     , C.CHG_TYPE
                     , C.LAST_UPDATED_BY
                     , C.LAST_UPDATE_DATE
                     , C.CHG_QTY
                     , C.CHG_RSN
                  FROM SCP_OPMZ_DMD_ELEC C
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) ID
                 WHERE ID.DIVISION_ID(+) = C.DIVISION_ID
                   AND ID.ITEM_ID(+) = C.ITEM_ID
                   AND UPPER(C.CHG_TYPE) = 'NEW'
                   AND C.DIVISION_ID = P_DIVISION_ID
                   AND C.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR C.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(C.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(ID.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR ID.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST
                , IA.PLAN_START_YYYYMMDD NULLS FIRST
                , UPPER(TRANSLATE(IA.PLAN_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLAN_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLANT_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLANT_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.NICK_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.NICK_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LINE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LINE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.OPERATION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.OPERATION_ID, '_', '/')) NULLS FIRST
                , IA.YYYYMMDD NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_ELEC_DEMAND'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_ELEC_DEMAND;


    /* ==================================================================================================
       Stock 조회용 적재 (AS-IS SCP0125_GET_STOCK_ADJ · _UC 의 결과 SELECT 앞부분)
       P_UC_YN = 'Y' : 81_UC 갈래 (LINE_ID · BEFORE_DEGAS 를 함께 싣고, Plant 재고 제외 공정이 3 개)
       ================================================================================================== */
    PROCEDURE P_LOAD_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_UC_YN                 IN  VARCHAR2
    )
    IS
        V_PLAN_NAME             VARCHAR2(8 CHAR);
        V_D_PLAN_NAME           DATE;
        V_CUTOFF_DAY            VARCHAR2(8 CHAR);
        V_D_CUTOFF_DAY          DATE;
        V_DEMAND_CUTOFF_DAY     VARCHAR2(8 CHAR);
        V_MAX_TUESDAY           VARCHAR2(8 CHAR);
    BEGIN

        /* GTT 초기화 - TRUNCATE 는 암묵적 커밋이라 쓰지 않는다 */
        DELETE FROM GT_0125_NET_DEMAND;
        DELETE FROM GT_0125_INVENTORY_ORG;
        DELETE FROM GT_0125_INVENTORY_AGE;
        DELETE FROM GT_0125_SCP_INVENTORY;
        DELETE FROM GT_0125_SCP_INTRANSIT;
        DELETE FROM GT_0125_CP_INFO;
        DELETE FROM GT_0125_OCV_EXCEPT;
        DELETE FROM GT_0125_CELL_PROD;
        DELETE FROM GT_0125_DM_TEMP;
        DELETE FROM GT_0125_PJT_MAP;
        DELETE FROM GT_0125_INTRANSIT_V;

        /* ------------------------------------------------------------------------
           Set Param for Biz
           ------------------------------------------------------------------------ */
        SELECT MAX(BASIS_YYYYMMDD)
          INTO V_MAX_TUESDAY
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND DAYOFWEEK = 'TUE';

        V_PLAN_NAME    := P_PLAN_START_YYYYMMDD;                                              /* 당주 월요일 YYYYMMDD */
        V_D_PLAN_NAME  := TO_DATE(V_PLAN_NAME, 'YYYYMMDD');                                   /* [PJ20257329] CUTOFF DAY 재설정 (2025-09-16) */
        V_CUTOFF_DAY   := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'); /* 지난주 일요일 YYYYMMDD */
        V_D_CUTOFF_DAY := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');

        /* [PJ20257329] CUTOFF DAY 재설정 (2025-09-16) */
        SELECT NVL(MAX(CUTOFF_YYYYMMDD), V_MAX_TUESDAY)
          INTO V_DEMAND_CUTOFF_DAY
          FROM DM_PLN_NET_DEMAND
         WHERE DIVISION_ID = P_DIVISION_ID
           AND CUTOFF_YYYYMMDD >= TO_CHAR(V_D_PLAN_NAME - 3, 'YYYYMMDD')                     /* 월요일 기준 최근 3일 이내 */
           AND CUTOFF_YYYYMMDD <= TO_CHAR(V_D_PLAN_NAME + 6, 'YYYYMMDD');                    /* 해당 주차 일요일 이전 */

        /* ------------------------------------------------------------------------
           2nd OCV에 활용된 SUB MDLE 재고는 제외하기 위해서
           ------------------------------------------------------------------------ */
        INSERT INTO GT_0125_OCV_EXCEPT
                    (
                      SCM_SITE_ID
                    , ITEM_ID
                    )
        SELECT B.SCM_SITE_ID
             , C.CHILD_ITEM_ID
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             , SCM_MST_SITE B
             , SCM_MST_BOM_SN_V C
         WHERE B.SCM_SITE_ID = A.SEGMENT4
           AND C.PLANT_ID = B.PLANT_ID
           AND C.PARENT_ITEM_ID = A.SEGMENT5
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
           AND A.VALID_YN = 'Y'
           AND A.ATTRIBUTE1 = 'B'
           AND A.SEGMENT2 = P_DIVISION_ID
         GROUP BY B.SCM_SITE_ID
                , C.CHILD_ITEM_ID;

        /* ------------------------------------------------------------------------
           셀 생산지 버퍼 추가
           ------------------------------------------------------------------------ */
        INSERT INTO GT_0125_CELL_PROD
                    (
                      SALES_SITE_ID
                    , ITEM_ID
                    , OPERATION_GROUP
                    )
        SELECT A.SEGMENT3
             , A.SEGMENT4
             , CASE WHEN B.OPERATION_GROUP IS NULL THEN NULL
                    ELSE '_' || B.OPERATION_GROUP
               END                                  /* AS-IS '_'+NULL 은 NULL */
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             , SCP_MST_FINAL_ITEM B
         WHERE B.DIVISION_ID = A.SEGMENT1
           AND B.ITEM_ID = A.SEGMENT4
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND A.SEGMENT1 = P_DIVISION_ID;

        /* --------------------------------------------------------
           속도개선을 위한 DEMAND 참조 TEMP 처리.
           -------------------------------------------------------- */
        INSERT INTO GT_0125_NET_DEMAND
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , ITEM_ID
                    , INCOTERMS
                    , PROJECT_CODE
                    , YYYYMMDD
                    )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
             , MIN(A.YYYYMMDD)
          FROM DM_PLN_NET_DEMAND A
         WHERE A.VERSION_NO = (SELECT MAX(XA.VERSION_NO)
                                 FROM DM_MST_VERSION XA
                                WHERE XA.VERSION_TYPE IN ('MF_W', 'SF_W')
                                  AND XA.DIVISION_ID = P_DIVISION_ID
                                  AND XA.YYYYMMDD = V_DEMAND_CUTOFF_DAY)
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.ITEM_ID
                , A.INCOTERMS
                , A.PROJECT_CODE;

        INSERT INTO GT_0125_INVENTORY_ORG
                    (
                      DIVISION_ID
                    , CUTOFF_DATE
                    , PLANT_ID
                    , SITE_ID
                    , SCM_SITE_ID
                    , LOCATION_CODE
                    , LINE_ID
                    , STOCK_TYPE
                    , ITEM_ID
                    , MES_ITEM_ID
                    , WIPHOLD_YN
                    , AVAILABLE_DATE
                    , OPERATION_ID
                    , STORAGE_ID
                    , SCM_QTY
                    )
        SELECT IA.DIVISION_ID
             , IA.CUTOFF_DATE
             , IA.PLANT_ID
             , IA.SITE_ID
             , IA.SCM_SITE_ID
             , IA.LOCATION_CODE                     /* [PJ2025732]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-23) */
             , IA.K_LINE_ID
             , IA.STOCK_TYPE
             , IA.ITEM_ID
             , IA.MES_ITEM_ID
             , IA.WIPHOLD_YN
             , IA.AVAILABLE_DATE
             , IA.OPERATION_ID
             , IA.STORAGE_ID
             , SUM(IA.SCM_QTY)
          FROM (SELECT A.DIVISION_ID
                     , A.CUTOFF_DATE
                     , A.PLANT_ID
                     , A.SITE_ID
                     , A.SCM_SITE_ID
                     , A.LOCATION_CODE
                     , CASE WHEN P_UC_YN = 'Y' THEN A.LINE_ID END AS K_LINE_ID   /* 81_UC 갈래만 LINE_ID 로 묶는다 */
                     , A.STOCK_TYPE
                     , A.ITEM_ID
                     , A.MES_ITEM_ID
                     , A.WIPHOLD_YN
                     , A.AVAILABLE_DATE
                     , A.OPERATION_ID
                     , A.STORAGE_ID
                     , A.SCM_QTY
                  FROM SCM_DNM_STOCK A
                     , SCM_ITEM_M_SN B
                 WHERE B.COMPANY_ID = A.COMPANY_ID
                   AND B.DIVISION_ID = A.DIVISION_ID
                   AND B.SITE_ID = A.SITE_ID
                   AND B.ITEM_ID = A.ITEM_ID
                   AND A.SCM_SITE_ID IS NOT NULL
                   AND B.SCP_FLOW_ID IS NOT NULL
                   AND A.DIVISION_ID = P_DIVISION_ID
                   AND A.CUTOFF_DATE = V_CUTOFF_DAY) IA
         GROUP BY IA.DIVISION_ID
                , IA.CUTOFF_DATE
                , IA.PLANT_ID
                , IA.SITE_ID
                , IA.SCM_SITE_ID
                , IA.LOCATION_CODE
                , IA.K_LINE_ID
                , IA.STOCK_TYPE
                , IA.ITEM_ID
                , IA.MES_ITEM_ID
                , IA.WIPHOLD_YN
                , IA.AVAILABLE_DATE
                , IA.OPERATION_ID
                , IA.STORAGE_ID;

        INSERT INTO GT_0125_INVENTORY_AGE
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , WIPHOLD_YN
                    , CUTOFF_DATE
                    , SITE_ID
                    , LINE_ID
                    , BEFORE_DEGAS
                    , QTY
                    )
        SELECT IA.DIVISION_ID
             , IA.SCM_SITE_ID
             , IA.PLANT_ID
             , IA.ITEM_ID
             , IA.AVAILABLE_DATE
             , IA.WIPHOLD_YN
             , IA.CUTOFF_DATE
             , IA.SITE_ID
             , IA.K_LINE_ID
             , IA.K_BEFORE_DEGAS
             , SUM(IA.QTY)
          FROM (SELECT A.DIVISION_ID
                     , A.SCM_SITE_ID
                     , A.PLANT_ID
                     , A.ITEM_ID
                     , A.AVAILABLE_DATE
                     , A.WIPHOLD_YN
                     , A.CUTOFF_DATE
                     , A.SITE_ID
                     , CASE WHEN P_UC_YN = 'Y' THEN A.LINE_ID END AS K_LINE_ID
                     , CASE WHEN P_UC_YN = 'Y' THEN A.BEFORE_DEGAS END AS K_BEFORE_DEGAS
                     , A.QTY
                     /* 재고 경과 뷰를 두 번 읽던 것을 한 번으로 : 사이트별 마지막 마감일을 분석 함수로   -- 2026.09.25 AJS */
                     , MAX(CASE WHEN A.CUTOFF_DATE >  V_D_CUTOFF_DAY - 7
                                 AND A.CUTOFF_DATE <= V_D_CUTOFF_DAY
                                THEN A.CUTOFF_DATE
                           END) OVER (PARTITION BY A.DIVISION_ID
                                                 , A.SITE_ID)                    AS MAX_CUTOFF_DATE
                  FROM SCM_DNM_STOCK_AGING_V A
--               WHERE EXISTS (SELECT 1
--                               FROM (SELECT XA.DIVISION_ID
--                                          , XA.SITE_ID
--                                          , MAX(XA.CUTOFF_DATE) AS MAX_CUTOFF_DATE
--                                       FROM SCM_DNM_STOCK_AGING_V XA
--                                      WHERE XA.DIVISION_ID = P_DIVISION_ID
--                                        AND XA.CUTOFF_DATE > V_D_CUTOFF_DAY - 7
--                                        AND XA.CUTOFF_DATE <= V_D_CUTOFF_DAY
--                                      GROUP BY XA.DIVISION_ID
--                                             , XA.SITE_ID) XB
--                              WHERE XB.DIVISION_ID = A.DIVISION_ID
--                                AND XB.SITE_ID = A.SITE_ID
--                                AND XB.MAX_CUTOFF_DATE = A.CUTOFF_DATE)
                 WHERE A.SITE_ID IS NOT NULL
                   AND A.DIVISION_ID = P_DIVISION_ID) IA
         WHERE IA.CUTOFF_DATE = IA.MAX_CUTOFF_DATE                               -- 2026.09.25 AJS
         GROUP BY IA.DIVISION_ID
                , IA.SCM_SITE_ID
                , IA.PLANT_ID
                , IA.ITEM_ID
                , IA.AVAILABLE_DATE
                , IA.WIPHOLD_YN
                , IA.CUTOFF_DATE
                , IA.SITE_ID
                , IA.K_LINE_ID
                , IA.K_BEFORE_DEGAS;

        /* --------------------------------------------------------
           1. 창고 재고 : WH
           -------------------------------------------------------- */
        /* 1.1 SALES 재고 */
        INSERT INTO GT_0125_SCP_INVENTORY
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , PROJECT_CODE
                    , CELL_PROD_SITE_ID
                    , FLAG
                    , LINE_ID
                    , BEFORE_DEGAS
                    )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.PLANT_ID
             , '-'                                                      /* 뒤에서 별도 UPDATE */
             , A.STOCK_TYPE
             , A.ITEM_ID
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN V_D_PLAN_NAME                    /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N' THEN V_D_PLAN_NAME                             /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME THEN V_D_PLAN_NAME
                    ELSE TRUNC(A.AVAILABLE_DATE)
               END
             , A.SCM_QTY                                                /* SCP 사용 QTY */
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END
             , IB.SITE_TYPE
             , '-'                                                      /* PLANT 재고 구분용 정보 */
             , '-'                                                      /* 뒤에서 별도 UPDATE */
             , IE.SCM_SITE_ID
             , 'SALES'
             , CASE WHEN P_UC_YN = 'Y' THEN '-' END
             , CASE WHEN P_UC_YN = 'Y' THEN '-' END
          FROM GT_0125_INVENTORY_ORG A
             , (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES') IB                        /* 소형 생산지 구분을 위한 분리 */
             , GT_0125_OCV_EXCEPT C
             , GT_0125_CELL_PROD D
             , (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , PLANT_ID
                  FROM SCM_MST_SITE
                 WHERE PLANT_ID IS NOT NULL) IE
         WHERE IB.DIVISION_ID = A.DIVISION_ID
           AND IB.SCM_SITE_ID = A.SCM_SITE_ID
           AND C.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND C.ITEM_ID(+) = A.MES_ITEM_ID
           AND D.SALES_SITE_ID(+) = A.SCM_SITE_ID
           AND D.ITEM_ID(+) = A.ITEM_ID
           AND IE.DIVISION_ID(+) = A.DIVISION_ID
           AND IE.SCM_SITE_ID(+) = CASE WHEN A.PLANT_ID IS NOT NULL AND D.OPERATION_GROUP IS NOT NULL THEN A.PLANT_ID || D.OPERATION_GROUP END
           AND C.ITEM_ID IS NULL
           AND A.SCM_SITE_ID IS NOT NULL
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = P_DIVISION_ID
           AND (   (A.DIVISION_ID = '40' AND (SELECT NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') FROM DUAL) <> 'P')   /* 소형은 CEll Biz 용 Demand 만 처리 · AS-IS 함수는 못 찾으면 빈 문자(Oracle NULL) */
                OR (A.DIVISION_ID <> '40'));

        /* 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리 */
        INSERT INTO GT_0125_SCP_INVENTORY
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , PROJECT_CODE
                    , CELL_PROD_SITE_ID
                    , FLAG
                    , LINE_ID
                    , BEFORE_DEGAS
                    )
        SELECT A.DIVISION_ID
             , A.TO_SCM_SITE_ID
             , A.PLANT_ID
             , '-'                                                      /* 뒤에서 별도 UPDATE */
             , 'SO'
             , A.ITEM_ID
             , V_D_PLAN_NAME                                            /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , A.DELIVERY_QTY
             , 'N'
             , IB.SITE_TYPE
             , '-'
             , CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-'
                    ELSE A.PROJECT_CODE
               END                                                      /* 없는 건 '-'처리 후 뒤에서 별도 없데이트 */
             , CASE WHEN C.ITEM_ID IS NULL THEN NULL
                    ELSE A.FROM_SCM_SITE_ID
               END
             , 'SALES'
             , CASE WHEN P_UC_YN = 'Y' THEN '-' END
             , CASE WHEN P_UC_YN = 'Y' THEN '-' END
          FROM SCM_DNM_INTRANSIT_C A
             , (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE SITE_TYPE = 'SALES') IB
             , GT_0125_CELL_PROD C
         WHERE IB.DIVISION_ID = A.DIVISION_ID
           AND IB.SCM_SITE_ID = A.TO_SCM_SITE_ID
           AND C.SALES_SITE_ID(+) = A.TO_SCM_SITE_ID
           AND C.ITEM_ID(+) = A.ITEM_ID
           AND A.RESULT_TYPE = 'B'                                      /* SO Reserve Stock : result_type = 'B' 는 재고로 처리 */
           AND A.VALID_YN = 'Y'
           AND A.TO_SCM_SITE_ID IS NOT NULL
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.RESULT_DATE = V_CUTOFF_DAY
           AND (   (A.DIVISION_ID = '40' AND (SELECT NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') FROM DUAL) <> 'P')
                OR (A.DIVISION_ID <> '40'));

        /* 1.3 SALES 재고 : INCOTERMS UPDATE (DEMAND 없는 경우 DAP 처리, VMI 는 'DAP') */
        UPDATE GT_0125_SCP_INVENTORY A
           SET A.INCOTERMS = NVL(NVL((SELECT MAX(CASE WHEN XB.VMI_YN = 'Y' THEN 'DAP' ELSE XA.INCOTERMS END)
                                        FROM GT_0125_NET_DEMAND XA
                                           , (SELECT DIVISION_ID
                                                   , SCM_SITE_ID
                                                   , VMI_YN
                                                FROM SCM_MST_SITE
                                               WHERE DIVISION_ID = P_DIVISION_ID
                                                 AND VMI_YN = 'Y') XB
                                       WHERE XB.DIVISION_ID(+) = XA.DIVISION_ID
                                         AND XB.SCM_SITE_ID(+) = XA.SCM_SITE_ID
                                         AND XA.SCM_SITE_ID = A.SCM_SITE_ID
                                         AND XA.ITEM_ID = A.ITEM_ID)
                                   , (SELECT MAX(CASE WHEN XD.VMI_YN = 'Y' THEN 'DAP' ELSE XC.INCOTERMS END)
                                        FROM GT_0125_NET_DEMAND XC
                                           , (SELECT DIVISION_ID
                                                   , SCM_SITE_ID
                                                   , VMI_YN
                                                FROM SCM_MST_SITE
                                               WHERE DIVISION_ID = P_DIVISION_ID
                                                 AND VMI_YN = 'Y') XD
                                       WHERE XD.DIVISION_ID(+) = XC.DIVISION_ID
                                         AND XD.SCM_SITE_ID(+) = XC.SCM_SITE_ID
                                         AND XC.SCM_SITE_ID = A.SCM_SITE_ID))
                               , 'DAP')
         WHERE A.SITE_TYPE = 'SALES';

        /* 1.4 PLANT 재고 */
        INSERT INTO GT_0125_SCP_INVENTORY
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , PROJECT_CODE
                    , CELL_PROD_SITE_ID
                    , FLAG
                    , LINE_ID
                    , BEFORE_DEGAS
                    )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.PLANT_ID
             , '-'
             , A.STOCK_TYPE
             , A.ITEM_ID
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN V_D_PLAN_NAME
                    WHEN A.WIPHOLD_YN = 'N' THEN V_D_PLAN_NAME
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME THEN V_D_PLAN_NAME
                    ELSE TRUNC(A.AVAILABLE_DATE)
               END
             , A.SCM_QTY
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END
             , IB.SITE_TYPE
             , CASE WHEN RTRIM(IC.LOCATION_CODE) IS NOT NULL OR RTRIM(ID.LOCATION_CODE) IS NOT NULL THEN 'ASSY'
                    ELSE '-'
               END                                                      /* PLANT 재고 구분용 정보 */
             , NULL
             , NULL
             , 'PLANT'
             , CASE WHEN P_UC_YN = 'Y' THEN NVL(A.LINE_ID, '-') END
             , CASE WHEN P_UC_YN = 'Y' THEN '-' END
          FROM GT_0125_INVENTORY_ORG A
             , (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND SITE_TYPE = 'PLANT'
                   AND (   (DIVISION_ID = '40' AND OPERATION_GROUP IN ('A'))             /* 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외 */
                        OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P')))) IB
             , (SELECT DISTINCT XA.OPERATION_ID
                     , XA.LOCATION_CODE
                     , XA.SCM_SITE_ID
                  FROM SCM_MST_LOCATION XA
                     , (SELECT SCM_SITE_ID
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID = P_DIVISION_ID
                           AND VALID_YN = 'Y'
                           AND OPERATION_GROUP IN ('A')) XB
                 WHERE XB.SCM_SITE_ID = XA.SCM_SITE_ID
                   AND XA.VALID_YN = 'Y'
                   AND XA.LOCATION_CODE = 'PACKAGING'                          /* 활성화 전 재고 */
                   AND XA.OPERATION_ID IS NOT NULL
                   AND XA.DIVISION_ID = P_DIVISION_ID) IC                     /* 셀의 operation_id 별 사용대상 조회 */
             , (SELECT DISTINCT XC.STORAGE_ID
                     , XC.LOCATION_CODE
                     , XC.SCM_SITE_ID
                  FROM SCM_MST_LOCATION XC
                     , (SELECT SCM_SITE_ID
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID = P_DIVISION_ID
                           AND VALID_YN = 'Y'
                           AND OPERATION_GROUP IN ('A')) XD
                 WHERE XD.SCM_SITE_ID = XC.SCM_SITE_ID
                   AND XC.VALID_YN = 'Y'
                   AND XC.LOCATION_CODE = 'PACKAGING'
                   AND XC.STORAGE_ID IS NOT NULL
                   AND XC.DIVISION_ID = P_DIVISION_ID) ID                     /* 셀의 storage_id 별 사용대상 조회 */
             , GT_0125_OCV_EXCEPT E
         WHERE IB.DIVISION_ID = A.DIVISION_ID
           AND IB.SCM_SITE_ID = A.SCM_SITE_ID
           AND IC.OPERATION_ID(+) = A.OPERATION_ID
           AND IC.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND ID.STORAGE_ID(+) = A.STORAGE_ID
           AND ID.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND E.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND E.ITEM_ID(+) = A.MES_ITEM_ID
           AND E.ITEM_ID IS NULL
           AND A.SCM_SITE_ID IS NOT NULL
           AND NVL(A.LOCATION_CODE, '-') NOT IN ('COATING', 'SLITTING', 'NOTCHING')                /* 전극 공정 · 셀공정 : PACKAGING 이전 */
           AND (   P_UC_YN = 'Y'
                OR NVL(A.LOCATION_CODE, '-') NOT IN ('PANCAKE_INV', 'WINDER', 'LAMINATION', 'FOLDING'))
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = P_DIVISION_ID;

        /* --------------------------------------------------------
           2. 활성화 재고 : FOR
           -------------------------------------------------------- */
        INSERT INTO GT_0125_SCP_INVENTORY
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , PROJECT_CODE
                    , CELL_PROD_SITE_ID
                    , FLAG
                    , LINE_ID
                    , BEFORE_DEGAS
                    )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.PLANT_ID
             , '-'
             , 'FOR'
             , A.ITEM_ID
             , CASE WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME THEN V_D_PLAN_NAME
                    ELSE A.AVAILABLE_DATE
               END
             , A.QTY
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END
             , 'PLANT'
             , '-'
             , NULL
             , NULL
             , 'PLANT'
             , A.LINE_ID
             , A.BEFORE_DEGAS
          FROM GT_0125_INVENTORY_AGE A
             , (SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND SITE_TYPE = 'PLANT'
                   AND NVL(OSP_YN, 'N') = 'N') IB
         WHERE IB.SCM_SITE_ID = A.SCM_SITE_ID;                            /* AS-IS LEFT JOIN + B.DIVISION_ID IS NOT NULL */

        /* --------------------------------------------------------
           3. 해상 재고 : INT
           -------------------------------------------------------- */
        /* 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 */
        /* 해상재고 뷰를 사업부 · 기준일로 먼저 내려받는다 - 조인과 함께 읽으면 뷰 조건 밀어넣기 계획으로 수십 분이 걸린다 */
        INSERT INTO GT_0125_INTRANSIT_V
                    (
                      DIVISION_ID
                    , RESULT_TYPE
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , FROM_SCM_SITE_ID
                    , FINAL_INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , PROJECT_CODE
                    )
        SELECT DIVISION_ID
             , RESULT_TYPE
             , ITEM_ID
             , TO_SCM_SITE_ID
             , FROM_SCM_SITE_ID
             , FINAL_INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
          FROM SCM_DNM_INTRANSIT_V
         WHERE RESULT_TYPE IN ('I', 'C')
           AND TO_SCM_SITE_ID IS NOT NULL
           AND DIVISION_ID = P_DIVISION_ID
           AND RESULT_DATE = V_CUTOFF_DAY;

        INSERT INTO GT_0125_SCP_INTRANSIT
                    (
                      DIVISION_ID
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , FROM_SCM_SITE_ID
                    , INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , PROJECT_CODE
                    , CELL_PROD_SITE_ID
                    , FLAG
                    )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.TO_SCM_SITE_ID
             , A.FROM_SCM_SITE_ID
             , A.FINAL_INCOTERMS
             , CASE WHEN A.ETA_DATE < V_PLAN_NAME THEN V_PLAN_NAME
                    ELSE A.ETA_DATE
               END                                                      /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE */
             , A.DELIVERY_QTY
             , CASE WHEN D.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-'      /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                    WHEN D.SITE_TYPE = 'SALES' THEN CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END
                    WHEN D.SITE_TYPE = 'PLANT' THEN NULL                             /* Plant 도착은 NULL 처리 */
                    ELSE CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END
               END
             , CASE WHEN E.ITEM_ID IS NULL THEN NULL
                    ELSE A.FROM_SCM_SITE_ID
               END
             , D.SITE_TYPE
          FROM GT_0125_INTRANSIT_V A
             , (SELECT DISTINCT DIVISION_ID
                     , ITEM_ID
                     , OPERATION_GROUP_ID
                  FROM SCM_MST_FINAL_ITEM_V
                 WHERE DIVISION_ID = P_DIVISION_ID) IB
             , (SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_GROUP
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID = P_DIVISION_ID
                   AND SITE_TYPE = 'PLANT'
                   AND OPERATION_GROUP IN ('A', 'P')                            /* FROM_SITE 가 전극인 정보 제외 */
                   AND VALID_YN = 'Y') IC
             , SCM_MST_SITE D
             , GT_0125_CELL_PROD E
         WHERE IB.DIVISION_ID = A.DIVISION_ID
           AND IB.ITEM_ID = A.ITEM_ID
           AND IC.DIVISION_ID = A.DIVISION_ID
           AND IC.SCM_SITE_ID = A.FROM_SCM_SITE_ID
           AND D.DIVISION_ID = A.DIVISION_ID
           AND D.SCM_SITE_ID = A.TO_SCM_SITE_ID
           AND E.SALES_SITE_ID(+) = A.TO_SCM_SITE_ID
           AND E.ITEM_ID(+) = A.ITEM_ID
           AND IB.OPERATION_GROUP_ID <> 'E'                                      /* 전극 모델은 제외 */
           AND (   (IC.DIVISION_ID = '40' AND IC.OPERATION_GROUP = 'A')          /* 소형은 CEll Biz 용 Demand 만 처리 */
                OR (IC.DIVISION_ID <> '40'))
           AND D.VALID_YN = 'Y'
           AND (   (D.DIVISION_ID = '40' AND D.SITE_TYPE = 'SALES')
                OR (D.DIVISION_ID <> '40'))
           AND A.RESULT_TYPE IN ('I', 'C')
           AND A.TO_SCM_SITE_ID IS NOT NULL
           AND A.DIVISION_ID = P_DIVISION_ID;                           /* 기준일 조건은 적재 시 적용 */

        /* 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것 */
        INSERT INTO GT_0125_SCP_INTRANSIT
                    (
                      DIVISION_ID
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , FROM_SCM_SITE_ID
                    , INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , PROJECT_CODE
                    , CELL_PROD_SITE_ID
                    , FLAG
                    )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.SCM_SITE_ID
             , B.PLANT_ID
             , 'DAP'                                                    /* VMI 임 */
             , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')         /* PLAN 시작일자로 처리 */
             , NVL(A.SCM_QTY, 0)
             , '-'
             , IA.SCM_SITE_ID
             , 'SALES'
          FROM GT_0125_INVENTORY_ORG A
             , SCM_MST_VMI_INT_SLOC B
             , SCM_MST_SITE C                                           /* 소형 생산지 구분을 위한 분리 */
             , GT_0125_OCV_EXCEPT D
             , GT_0125_CELL_PROD E
             , (SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , PLANT_ID
                  FROM SCM_MST_SITE
                 WHERE PLANT_ID IS NOT NULL) IA
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.PLANT_ID = A.PLANT_ID
           AND B.STORAGE_ID = A.STORAGE_ID
           AND C.PLANT_ID = A.PLANT_ID
           AND D.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND D.ITEM_ID(+) = A.MES_ITEM_ID
           AND E.SALES_SITE_ID(+) = A.SCM_SITE_ID
           AND E.ITEM_ID(+) = A.ITEM_ID
           AND IA.DIVISION_ID(+) = A.DIVISION_ID
           AND IA.SCM_SITE_ID(+) = CASE WHEN A.PLANT_ID IS NOT NULL AND E.OPERATION_GROUP IS NOT NULL THEN A.PLANT_ID || E.OPERATION_GROUP END
           AND B.VALID_YN = 'Y'
           AND B.SCM_SITE_ID IS NOT NULL
           AND D.ITEM_ID IS NULL
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = P_DIVISION_ID
           AND (   (A.DIVISION_ID = '40' AND (SELECT NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') FROM DUAL) <> 'P')
                OR (A.DIVISION_ID <> '40'));

        /* --------------------------------------------------------
           INCOTERMS가 있는 DM정보 -> DUE DATE가 가장 빠른 날짜 기준
           2025.06.26 Philsu Park: 엔진 Input 사용하지 않고 NET Demand 참조.
           -------------------------------------------------------- */
        INSERT INTO GT_0125_DM_TEMP
                    (
                      SITE_ID
                    , ITEM_ID
                    , INCOTERMS
                    , PROJECT_CODE
                    )
        SELECT IA.SITE_ID
             , IA.ITEM_ID
             , IA.INCOTERMS
             , IA.PROJECT_CODE
          FROM (SELECT IB.SITE_ID
                     , IB.ITEM_ID
                     , IB.INCOTERMS
                     , IB.PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY IB.SITE_ID, IB.ITEM_ID, IB.INCOTERMS, IB.PROJECT_CODE ORDER BY IB.MIN_DUE) AS ROW_NUM
                  FROM (SELECT A.SCM_SITE_ID AS SITE_ID
                             , A.ITEM_ID
                             , A.INCOTERMS
                             , A.PROJECT_CODE
                             , MIN(A.YYYYMMDD) AS MIN_DUE
                          FROM GT_0125_NET_DEMAND A
                         WHERE A.PROJECT_CODE IS NOT NULL
                           AND A.INCOTERMS IS NOT NULL
                         GROUP BY A.SCM_SITE_ID
                                , A.ITEM_ID
                                , A.INCOTERMS
                                , A.PROJECT_CODE) IB) IA
         WHERE IA.ROW_NUM = 1;

        /* --------------------------------------------------------
           프로젝트 코드 채움 대상 (AS-IS UPDATE ... FROM 의 조인 결과)
           - 수요 쪽 INCOTERMS 는 NULL 이 없어 AS-IS 의 세 조건 중 같음 조건만 성립한다.
           - 한 행에 수요가 여러 건 걸리면 AS-IS 는 그중 하나를 임의로 쓴다. 여기서는 최솟값으로 고정한다.
           -------------------------------------------------------- */
        INSERT INTO GT_0125_PJT_MAP
                    (
                      MAP_TYPE
                    , DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , LINE_ID
                    , BEFORE_DEGAS
                    , PROJECT_CODE
                    )
        SELECT 'INV'
             , A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.PLANT_ID
             , A.INCOTERMS
             , A.STOCK_TYPE
             , A.ITEM_ID
             , A.AVAILABLE_DATE
             , A.QTY
             , A.WIPHOLD_YN
             , A.SITE_TYPE
             , A.LOCATION_CODE
             , A.LINE_ID
             , A.BEFORE_DEGAS
             , MIN(C.PROJECT_CODE)
          FROM GT_0125_SCP_INVENTORY A
             , SCP_OPMZ_LOOKUP_MASTER_DETAIL B
             , GT_0125_DM_TEMP C
         WHERE B.SEGMENT3(+) = A.ITEM_ID
           AND C.SITE_ID = A.SCM_SITE_ID
           AND C.ITEM_ID = CASE WHEN B.SEGMENT3 IS NULL THEN A.ITEM_ID ELSE B.SEGMENT4 END
           AND C.INCOTERMS = A.INCOTERMS
           AND B.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
           AND B.VALID_YN(+) = 'Y'
           AND B.SEGMENT2(+) = P_DIVISION_ID
           AND A.FLAG = 'SALES'
           AND A.PROJECT_CODE = '-'
           AND A.QTY > 0
         GROUP BY A.DIVISION_ID
                , A.SCM_SITE_ID
                , A.PLANT_ID
                , A.INCOTERMS
                , A.STOCK_TYPE
                , A.ITEM_ID
                , A.AVAILABLE_DATE
                , A.QTY
                , A.WIPHOLD_YN
                , A.SITE_TYPE
                , A.LOCATION_CODE
                , A.LINE_ID
                , A.BEFORE_DEGAS;

        INSERT INTO GT_0125_PJT_MAP
                    (
                      MAP_TYPE
                    , DIVISION_ID
                    , SCM_SITE_ID
                    , FROM_SCM_SITE_ID
                    , INCOTERMS
                    , ITEM_ID
                    , ETA_DATE
                    , QTY
                    , FLAG
                    , PROJECT_CODE
                    )
        SELECT 'INT'
             , A.DIVISION_ID
             , A.TO_SCM_SITE_ID
             , A.FROM_SCM_SITE_ID
             , A.INCOTERMS
             , A.ITEM_ID
             , A.ETA_DATE
             , A.DELIVERY_QTY
             , A.FLAG
             , MIN(C.PROJECT_CODE)
          FROM GT_0125_SCP_INTRANSIT A
             , SCP_OPMZ_LOOKUP_MASTER_DETAIL B
             , GT_0125_DM_TEMP C
         WHERE B.SEGMENT3(+) = A.ITEM_ID
           AND C.SITE_ID = A.TO_SCM_SITE_ID
           AND C.ITEM_ID = CASE WHEN B.SEGMENT3 IS NULL THEN A.ITEM_ID ELSE B.SEGMENT4 END
           AND C.INCOTERMS = A.INCOTERMS
           AND B.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
           AND B.VALID_YN(+) = 'Y'
           AND B.SEGMENT2(+) = P_DIVISION_ID
           AND A.FLAG = 'SALES'
           AND A.PROJECT_CODE = '-'
           AND A.DELIVERY_QTY > 0
         GROUP BY A.DIVISION_ID
                , A.TO_SCM_SITE_ID
                , A.FROM_SCM_SITE_ID
                , A.INCOTERMS
                , A.ITEM_ID
                , A.ETA_DATE
                , A.DELIVERY_QTY
                , A.FLAG;

        /* #SCP_INVENTORY_I 프로젝트 UPDATE */
        UPDATE GT_0125_SCP_INVENTORY A
           SET A.PROJECT_CODE = (SELECT MIN(XA.PROJECT_CODE)
                                   FROM GT_0125_PJT_MAP XA
                                  WHERE XA.MAP_TYPE = 'INV'
                                    AND XA.SCM_SITE_ID = A.SCM_SITE_ID
                                    AND XA.ITEM_ID = A.ITEM_ID
                                    AND XA.DIVISION_ID = A.DIVISION_ID
                                    AND XA.PLANT_ID = A.PLANT_ID
                                    AND XA.INCOTERMS = A.INCOTERMS
                                    AND XA.STOCK_TYPE = A.STOCK_TYPE
                                    AND XA.AVAILABLE_DATE = A.AVAILABLE_DATE
                                    AND XA.QTY = A.QTY
                                    AND XA.WIPHOLD_YN = A.WIPHOLD_YN
                                    AND XA.SITE_TYPE = A.SITE_TYPE
                                    AND XA.LOCATION_CODE = A.LOCATION_CODE
                                    AND (   P_UC_YN = 'N'
                                         OR (XA.LINE_ID = A.LINE_ID AND XA.BEFORE_DEGAS = A.BEFORE_DEGAS)))
         WHERE EXISTS (SELECT 1
                         FROM GT_0125_PJT_MAP XB
                        WHERE XB.MAP_TYPE = 'INV'
                          AND XB.SCM_SITE_ID = A.SCM_SITE_ID
                          AND XB.ITEM_ID = A.ITEM_ID
                          AND XB.DIVISION_ID = A.DIVISION_ID
                          AND XB.PLANT_ID = A.PLANT_ID
                          AND XB.INCOTERMS = A.INCOTERMS
                          AND XB.STOCK_TYPE = A.STOCK_TYPE
                          AND XB.AVAILABLE_DATE = A.AVAILABLE_DATE
                          AND XB.QTY = A.QTY
                          AND XB.WIPHOLD_YN = A.WIPHOLD_YN
                          AND XB.SITE_TYPE = A.SITE_TYPE
                          AND XB.LOCATION_CODE = A.LOCATION_CODE
                          AND (   P_UC_YN = 'N'
                               OR (XB.LINE_ID = A.LINE_ID AND XB.BEFORE_DEGAS = A.BEFORE_DEGAS)));

        /* #SCP_INTRANSIT_I 프로젝트 UPDATE */
        UPDATE GT_0125_SCP_INTRANSIT A
           SET A.PROJECT_CODE = (SELECT MIN(XA.PROJECT_CODE)
                                   FROM GT_0125_PJT_MAP XA
                                  WHERE XA.MAP_TYPE = 'INT'
                                    AND XA.SCM_SITE_ID = A.TO_SCM_SITE_ID
                                    AND XA.ITEM_ID = A.ITEM_ID
                                    AND XA.DIVISION_ID = A.DIVISION_ID
                                    AND XA.FROM_SCM_SITE_ID = A.FROM_SCM_SITE_ID
                                    AND XA.INCOTERMS = A.INCOTERMS
                                    AND XA.ETA_DATE = A.ETA_DATE
                                    AND XA.QTY = A.DELIVERY_QTY
                                    AND XA.FLAG = A.FLAG)
         WHERE EXISTS (SELECT 1
                         FROM GT_0125_PJT_MAP XB
                        WHERE XB.MAP_TYPE = 'INT'
                          AND XB.SCM_SITE_ID = A.TO_SCM_SITE_ID
                          AND XB.ITEM_ID = A.ITEM_ID
                          AND XB.DIVISION_ID = A.DIVISION_ID
                          AND XB.FROM_SCM_SITE_ID = A.FROM_SCM_SITE_ID
                          AND XB.INCOTERMS = A.INCOTERMS
                          AND XB.ETA_DATE = A.ETA_DATE
                          AND XB.QTY = A.DELIVERY_QTY
                          AND XB.FLAG = A.FLAG);

        /* CA별 CP 정보 */
        INSERT INTO GT_0125_CP_INFO
                    (
                      DIVISION_ID
                    , PLANT_ID
                    , ITEM_ID_ASSY
                    , ITEM_ID_PROD
                    , PRIORITY_1ST
                    , PRIORITY_2ND
                    , PRIORITY_3RD
                    )
        SELECT DIVISION_ID
             , PLANT_ID
             , ITEM_ID_ASSY
             , ITEM_ID_PROD
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID_ASSY, PLANT_ID
                                      ORDER BY VALID_YN DESC, UPPER(TRANSLATE(ITEM_ID_PROD, '_-', '/')) NULLS FIRST, ITEM_ID_PROD NULLS FIRST)
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, ITEM_ID_ASSY
                                      ORDER BY VALID_YN DESC, UPPER(TRANSLATE(ITEM_ID_PROD, '_-', '/')) NULLS FIRST, ITEM_ID_PROD NULLS FIRST)
             , ROW_NUMBER() OVER (PARTITION BY ITEM_ID_ASSY
                                      ORDER BY VALID_YN DESC, UPPER(TRANSLATE(ITEM_ID_PROD, '_-', '/')) NULLS FIRST, ITEM_ID_PROD NULLS FIRST)
          FROM SCP_MST_CELL_PROD_ASSY_MAP
         WHERE VALID_YN = 'Y';

    END P_LOAD_STOCK;


    /* ==================================================================================================
       Stock 조회 - 81_UC 외 사업부
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_STOCK_ADJ
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_D_PLAN_NAME           DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');
    BEGIN

        P_LOAD_STOCK(P_DIVISION_ID, P_PLAN_START_YYYYMMDD, 'N');

        OPEN O_RC1 FOR
        SELECT IA.*
             , IA.CHG_QTY AS PRE_CHG_QTY
             , IA.CHG_RSN AS PRE_CHG_RSN
          FROM (SELECT P_DIVISION_ID AS DIVISION_ID
                     , P_PLAN_START_YYYYMMDD AS CUTOFF_YYYYMMDD
                     , IB.STOCK_TYPE AS SRCE_DIVS_CD
                     , IB.STOCK_TYPE
                     , D.SEGMENT2 AS STOCK_TYPE_NAME
                     , IB.PROJECT_CODE
                     , IC.NICK_NAME                                     /* Nick Name 추가 (2025-07-14) */
                     , IB.ITEM_ID
                     , IB.INCOTERMS
                     , IB.PLANT_ID AS FROM_SITE_ID
                     , IB.SITE_ID AS SCM_SITE_ID
                     , TO_DATE(IB.EFECTIVE_DATE, 'YYYYMMDD') AS INV_DATE
                     , IB.QTY
                     , B.CHG_QTY
                     , B.CHG_RSN
                     , B.CHG_TYPE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                  FROM (SELECT ID.SITE_ID
                             , ID.PLANT_ID
                             , ID.ITEM_ID
                             , ID.EFECTIVE_DATE
                             , ID.STOCK_TYPE
                             , SUM(ID.QTY) AS QTY
                             , ID.INCOTERMS
                             , ID.PROJECT_CODE
                             , ID.CELL_PROD_SITE_ID
                          FROM (SELECT IE.SCM_SITE_ID AS SITE_ID
                                     , IE.PLANT_ID
                                     , CASE WHEN IG.OPERATION_GROUP = 'A'           /* 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함 */
                                             AND NVL(IG.ATTRIBUTE8, '-') <> 'CP'   /* AS-IS 빈 문자 (기준 DB 는 NULL) 도 참 */
                                             AND IE.DESCR LIKE 'WH%'
                                             AND IE.LOCATION_CODE = '-'
                                             AND IE.ITEM_ID NOT LIKE 'MA%'          /* [PJ20257329]MA 재고에 대해서는 AGING으로 놔두고 MU, MJ...에 대해서는 CHAR로 변환 (2025-10-21) */
                                            THEN NVL(NVL(NVL(F.ITEM_ID_PROD, G.ITEM_ID_PROD), H.ITEM_ID_PROD), IE.ITEM_ID)
                                            ELSE IE.ITEM_ID
                                       END AS ITEM_ID
                                     , TO_CHAR(NVL(IE.EFFSTARTDATE, V_D_PLAN_NAME), 'YYYYMMDD') AS EFECTIVE_DATE
                                     , IE.DESCR AS STOCK_TYPE
                                     , IE.LOCATION_CODE
                                     , IE.QTY
                                     , IE.INCOTERMS
                                     , IE.PROJECT_CODE
                                     , IE.CELL_PROD_SITE_ID
                                  FROM (SELECT XA.DIVISION_ID
                                             , XA.ITEM_ID
                                             , XA.SCM_SITE_ID
                                             , XA.PLANT_ID
                                             , XA.INCOTERMS
                                             , TRUNC(XA.AVAILABLE_DATE) AS EFFSTARTDATE
                                             , SUM(XA.QTY) AS QTY
                                             , CASE WHEN NVL(XA.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END AS DESCR
                                             , XA.LOCATION_CODE
                                             , XA.PROJECT_CODE
                                             , XA.CELL_PROD_SITE_ID
                                             , XA.FLAG
                                          FROM GT_0125_SCP_INVENTORY XA
                                         WHERE XA.STOCK_TYPE <> 'FOR'
                                         GROUP BY XA.DIVISION_ID
                                                , XA.ITEM_ID
                                                , XA.SCM_SITE_ID
                                                , TRUNC(XA.AVAILABLE_DATE)
                                                , NVL(XA.WIPHOLD_YN, 'N')
                                                , XA.INCOTERMS
                                                , XA.LOCATION_CODE
                                                , XA.PROJECT_CODE
                                                , XA.FLAG
                                                , XA.CELL_PROD_SITE_ID
                                                , XA.PLANT_ID
                                        HAVING SUM(XA.QTY) > 0
                                        /* 활성화 재고 : FOR 로 처리 */
                                         UNION ALL
                                        SELECT XB.DIVISION_ID
                                             , XB.ITEM_ID
                                             , XB.SCM_SITE_ID
                                             , XB.PLANT_ID
                                             , XB.INCOTERMS
                                             , TRUNC(XB.AVAILABLE_DATE)
                                             , SUM(XB.QTY)
                                             , CASE WHEN NVL(XB.WIPHOLD_YN, 'N') = 'N' THEN 'FOR' ELSE 'FOR_HOLD' END
                                             , XB.LOCATION_CODE
                                             , XB.PROJECT_CODE
                                             , XB.CELL_PROD_SITE_ID
                                             , XB.FLAG
                                          FROM GT_0125_SCP_INVENTORY XB
                                         WHERE XB.STOCK_TYPE = 'FOR'
                                           AND XB.QTY > 0
                                         GROUP BY XB.DIVISION_ID
                                                , XB.ITEM_ID
                                                , XB.SCM_SITE_ID
                                                , TRUNC(XB.AVAILABLE_DATE)
                                                , NVL(XB.WIPHOLD_YN, 'N')
                                                , XB.INCOTERMS
                                                , XB.LOCATION_CODE
                                                , XB.PROJECT_CODE
                                                , XB.FLAG
                                                , XB.CELL_PROD_SITE_ID
                                                , XB.PLANT_ID
                                        /* INTRANSIT SHIPMENT 재고 */
                                         UNION ALL
                                        SELECT XC.DIVISION_ID
                                             , XC.ITEM_ID
                                             , XC.TO_SCM_SITE_ID
                                             , XC.FROM_SCM_SITE_ID
                                             , XC.INCOTERMS
                                             , TO_DATE(XC.ETA_DATE, 'YYYYMMDD')
                                             , SUM(XC.DELIVERY_QTY)
                                             , 'INT'
                                             , '-'
                                             , XC.PROJECT_CODE
                                             , XC.CELL_PROD_SITE_ID
                                             , XC.FLAG
                                          FROM GT_0125_SCP_INTRANSIT XC
                                         WHERE XC.DELIVERY_QTY > 0
                                           AND XC.ETA_DATE IS NOT NULL
                                         GROUP BY XC.DIVISION_ID
                                                , XC.ITEM_ID
                                                , XC.TO_SCM_SITE_ID
                                                , XC.ETA_DATE
                                                , XC.INCOTERMS
                                                , XC.PROJECT_CODE
                                                , XC.FLAG
                                                , XC.CELL_PROD_SITE_ID
                                                , XC.FROM_SCM_SITE_ID) IE
                                     , (SELECT DISTINCT DIVISION_ID
                                             , ITEM_ID
                                             , OPERATION_GROUP
                                             , FLOW_ID
                                             , ATTRIBUTE8
                                          FROM SCP_MST_FINAL_ITEM
                                         WHERE DIVISION_ID = P_DIVISION_ID
                                           AND OPERATION_GROUP IN ('A', 'P')) IG
                                     , SCM_MST_SITE E
                                     , GT_0125_CP_INFO F
                                     , GT_0125_CP_INFO G
                                     , GT_0125_CP_INFO H
                                     , (SELECT XE.DIVISION_ID
                                             , XE.SCM_SITE_ID
                                             , XD.ITEM_ID
                                          FROM SCM_ITEM_M_SN XD
                                             , SCM_MST_SITE XE
                                         WHERE XE.COMPANY_ID = XD.COMPANY_ID
                                           AND XE.OPERATION_GROUP = XD.SCP_OPERATION_GROUP
                                           AND XD.SCP_FLOW_ID NOT IN ('P5500', 'P9500')     /* SUBMDLE만 걸리도록 */
                                           AND XD.SCP_OPERATION_GROUP = 'P') IH             /* SUBMDLE의 STAGE를 찾기 위해 추가 */
                                 WHERE IG.ITEM_ID(+) = IE.ITEM_ID
                                   AND IG.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND E.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND E.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND F.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND F.PLANT_ID(+) = E.PLANT_ID
                                   AND F.ITEM_ID_ASSY(+) = IE.ITEM_ID
                                   AND G.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND G.ITEM_ID_ASSY(+) = IE.ITEM_ID
                                   AND H.ITEM_ID_ASSY(+) = IE.ITEM_ID
                                   AND IH.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND IH.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND IH.ITEM_ID(+) = IE.ITEM_ID
                                   AND E.SITE_TYPE(+) = 'PLANT'
                                   AND F.PRIORITY_1ST(+) = 1
                                   AND G.PRIORITY_2ND(+) = 1
                                   AND H.PRIORITY_3RD(+) = 1) ID              /* 최종 ITEM_ID 별 GROUP BY */
                         GROUP BY ID.SITE_ID
                                , ID.PLANT_ID
                                , ID.ITEM_ID
                                , ID.EFECTIVE_DATE
                                , ID.STOCK_TYPE
                                , ID.INCOTERMS
                                , ID.PROJECT_CODE
                                , ID.CELL_PROD_SITE_ID) IB
                     , SCP_OPMZ_INV_ADJ B
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IC
                     , SCM_ADM_LOOKUP_MASTER_DETAIL D
                 WHERE B.STOCK_TYPE(+) = IB.STOCK_TYPE
                   AND B.PROJECT_CODE(+) = NVL(IB.PROJECT_CODE, '-')
                   AND B.SCM_SITE_ID(+) = IB.SITE_ID
                   AND B.ITEM_ID(+) = IB.ITEM_ID
                   AND B.INCOTERMS(+) = NVL(IB.INCOTERMS, '-')
                   AND B.INV_DATE(+) = IB.EFECTIVE_DATE
                   AND IC.ITEM_ID(+) = IB.ITEM_ID
                   AND D.SEGMENT1(+) = IB.STOCK_TYPE
                   AND D.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND B.DIVISION_ID(+) = P_DIVISION_ID
                   AND B.CUTOFF_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                   AND IC.DIVISION_ID(+) = P_DIVISION_ID
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR IB.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                 WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(IB.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IC.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IC.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                /* Insert 된 정보 */
                 UNION ALL
                SELECT J.DIVISION_ID
                     , J.CUTOFF_YYYYMMDD
                     , J.SRCE_DIVS_CD
                     , J.STOCK_TYPE
                     , L.SEGMENT2
                     , J.PROJECT_CODE
                     , IJ.NICK_NAME
                     , J.ITEM_ID
                     , J.INCOTERMS
                     , J.FROM_SITE_ID
                     , J.SCM_SITE_ID
                     , TO_DATE(J.INV_DATE, 'YYYYMMDD')                  /* 기준일자 */
                     , J.QTY
                     , J.CHG_QTY
                     , J.CHG_RSN
                     , J.CHG_TYPE
                     , J.LAST_UPDATED_BY
                     , J.LAST_UPDATE_DATE
                  FROM SCP_OPMZ_INV_ADJ J
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IJ
                     , SCM_ADM_LOOKUP_MASTER_DETAIL L
                 WHERE IJ.DIVISION_ID(+) = J.DIVISION_ID
                   AND IJ.ITEM_ID(+) = J.ITEM_ID
                   AND L.SEGMENT1(+) = J.STOCK_TYPE
                   AND L.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND UPPER(J.CHG_TYPE) = 'NEW'
                   AND J.LOCATION_CODE NOT IN ('COATING', 'SLITTING'                                        /* 전극 공정 */
                                             , 'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING') /* 셀공정 : PACKAGING 이전 */
                   AND J.DIVISION_ID = P_DIVISION_ID
                   AND J.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR J.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(J.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IJ.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IJ.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST
                , IA.CUTOFF_YYYYMMDD NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_', '/')) NULLS FIRST
                , IA.INV_DATE NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_STOCK_ADJ;


    /* ==================================================================================================
       Stock 조회 - 81_UC 사업부 (LINE_ID · BEFORE_DEGAS 단위)
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_STOCK_ADJ_UC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_D_PLAN_NAME           DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');
    BEGIN

        P_LOAD_STOCK(P_DIVISION_ID, P_PLAN_START_YYYYMMDD, 'Y');

        OPEN O_RC1 FOR
        SELECT IA.*
             , IA.CHG_QTY AS PRE_CHG_QTY
             , IA.CHG_RSN AS PRE_CHG_RSN
          FROM (SELECT P_DIVISION_ID AS DIVISION_ID
                     , P_PLAN_START_YYYYMMDD AS CUTOFF_YYYYMMDD
                     , IB.STOCK_TYPE AS SRCE_DIVS_CD
                     , IB.STOCK_TYPE
                     , D.SEGMENT2 AS STOCK_TYPE_NAME
                     , IB.PROJECT_CODE
                     , IC.NICK_NAME
                     , IB.ITEM_ID
                     , IB.INCOTERMS
                     , IB.PLANT_ID AS FROM_SITE_ID
                     , IB.SITE_ID AS SCM_SITE_ID
                     , IB.LINE_ID
                     , IB.BEFORE_DEGAS
                     , TO_DATE(IB.EFECTIVE_DATE, 'YYYYMMDD') AS INV_DATE
                     , IB.QTY
                     , B.CHG_QTY
                     , B.CHG_RSN
                     , B.CHG_TYPE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                  FROM (SELECT ID.SITE_ID
                             , ID.PLANT_ID
                             , ID.ITEM_ID
                             , ID.EFECTIVE_DATE
                             , ID.STOCK_TYPE
                             , ID.LINE_ID
                             , ID.BEFORE_DEGAS
                             , SUM(ID.QTY) AS QTY
                             , ID.INCOTERMS
                             , ID.PROJECT_CODE
                             , ID.CELL_PROD_SITE_ID
                          FROM (SELECT IE.SCM_SITE_ID AS SITE_ID
                                     , IE.PLANT_ID
                                     , CASE WHEN IG.OPERATION_GROUP = 'A'           /* 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함 */
                                             AND NVL(IG.ATTRIBUTE8, '-') <> 'CP'   /* AS-IS 빈 문자 (기준 DB 는 NULL) 도 참 */
                                             AND IE.DESCR LIKE 'WH%'
                                             AND IE.LOCATION_CODE = '-'
                                            THEN NVL(NVL(NVL(F.ITEM_ID_PROD, G.ITEM_ID_PROD), H.ITEM_ID_PROD), IE.ITEM_ID)
                                            ELSE IE.ITEM_ID
                                       END AS ITEM_ID
                                     , TO_CHAR(NVL(IE.EFFSTARTDATE, V_D_PLAN_NAME), 'YYYYMMDD') AS EFECTIVE_DATE
                                     , IE.DESCR AS STOCK_TYPE
                                     , IE.LOCATION_CODE
                                     , CASE WHEN IG.OPERATION_GROUP = 'A'
                                             AND NVL(IG.ATTRIBUTE8, '-') <> 'CP'   /* AS-IS 빈 문자 (기준 DB 는 NULL) 도 참 */
                                             AND IE.DESCR LIKE 'WH%'
                                             AND IE.LOCATION_CODE = '-'
                                            THEN '-'
                                            ELSE IE.LINE_ID
                                       END AS LINE_ID
                                     , IE.BEFORE_DEGAS
                                     , IE.QTY
                                     , IE.INCOTERMS
                                     , IE.PROJECT_CODE
                                     , IE.CELL_PROD_SITE_ID
                                  FROM (SELECT XA.DIVISION_ID
                                             , XA.ITEM_ID
                                             , XA.SCM_SITE_ID
                                             , XA.PLANT_ID
                                             , XA.INCOTERMS
                                             , TRUNC(XA.AVAILABLE_DATE) AS EFFSTARTDATE
                                             , SUM(XA.QTY) AS QTY
                                             , CASE WHEN NVL(XA.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END AS DESCR
                                             , XA.LOCATION_CODE
                                             , XA.PROJECT_CODE
                                             , XA.CELL_PROD_SITE_ID
                                             , XA.FLAG
                                             , XA.LINE_ID
                                             , XA.BEFORE_DEGAS
                                          FROM GT_0125_SCP_INVENTORY XA
                                         WHERE XA.STOCK_TYPE <> 'FOR'
                                         GROUP BY XA.DIVISION_ID
                                                , XA.ITEM_ID
                                                , XA.SCM_SITE_ID
                                                , TRUNC(XA.AVAILABLE_DATE)
                                                , NVL(XA.WIPHOLD_YN, 'N')
                                                , XA.INCOTERMS
                                                , XA.LOCATION_CODE
                                                , XA.PROJECT_CODE
                                                , XA.FLAG
                                                , XA.CELL_PROD_SITE_ID
                                                , XA.PLANT_ID
                                                , XA.LINE_ID
                                                , XA.BEFORE_DEGAS
                                        HAVING SUM(XA.QTY) > 0
                                        /* 활성화 재고 : FOR 로 처리 */
                                         UNION ALL
                                        SELECT XB.DIVISION_ID
                                             , XB.ITEM_ID
                                             , XB.SCM_SITE_ID
                                             , XB.PLANT_ID
                                             , XB.INCOTERMS
                                             , TRUNC(XB.AVAILABLE_DATE)
                                             , SUM(XB.QTY)
                                             , CASE WHEN NVL(XB.WIPHOLD_YN, 'N') = 'N' THEN 'FOR' ELSE 'FOR_HOLD' END
                                             , XB.LOCATION_CODE
                                             , XB.PROJECT_CODE
                                             , XB.CELL_PROD_SITE_ID
                                             , XB.FLAG
                                             , XB.LINE_ID
                                             , XB.BEFORE_DEGAS
                                          FROM GT_0125_SCP_INVENTORY XB
                                         WHERE XB.STOCK_TYPE = 'FOR'
                                           AND XB.QTY > 0
                                         GROUP BY XB.DIVISION_ID
                                                , XB.ITEM_ID
                                                , XB.SCM_SITE_ID
                                                , TRUNC(XB.AVAILABLE_DATE)
                                                , NVL(XB.WIPHOLD_YN, 'N')
                                                , XB.INCOTERMS
                                                , XB.LOCATION_CODE
                                                , XB.PROJECT_CODE
                                                , XB.FLAG
                                                , XB.CELL_PROD_SITE_ID
                                                , XB.PLANT_ID
                                                , XB.LINE_ID
                                                , XB.BEFORE_DEGAS
                                        /* INTRANSIT SHIPMENT 재고 */
                                         UNION ALL
                                        SELECT XC.DIVISION_ID
                                             , XC.ITEM_ID
                                             , XC.TO_SCM_SITE_ID
                                             , XC.FROM_SCM_SITE_ID
                                             , XC.INCOTERMS
                                             , TO_DATE(XC.ETA_DATE, 'YYYYMMDD')
                                             , SUM(XC.DELIVERY_QTY)
                                             , 'INT'
                                             , '-'
                                             , XC.PROJECT_CODE
                                             , XC.CELL_PROD_SITE_ID
                                             , XC.FLAG
                                             , '-'
                                             , '-'
                                          FROM GT_0125_SCP_INTRANSIT XC
                                         WHERE XC.DELIVERY_QTY > 0
                                           AND XC.ETA_DATE IS NOT NULL
                                         GROUP BY XC.DIVISION_ID
                                                , XC.ITEM_ID
                                                , XC.TO_SCM_SITE_ID
                                                , XC.ETA_DATE
                                                , XC.INCOTERMS
                                                , XC.PROJECT_CODE
                                                , XC.FLAG
                                                , XC.CELL_PROD_SITE_ID
                                                , XC.FROM_SCM_SITE_ID) IE
                                     , (SELECT DISTINCT DIVISION_ID
                                             , ITEM_ID
                                             , OPERATION_GROUP
                                             , FLOW_ID
                                             , ATTRIBUTE8
                                          FROM SCP_MST_FINAL_ITEM
                                         WHERE DIVISION_ID = P_DIVISION_ID
                                           AND OPERATION_GROUP IN ('A', 'P')) IG
                                     , SCM_MST_SITE E
                                     , GT_0125_CP_INFO F
                                     , GT_0125_CP_INFO G
                                     , GT_0125_CP_INFO H
                                     , (SELECT XE.DIVISION_ID
                                             , XE.SCM_SITE_ID
                                             , XD.ITEM_ID
                                          FROM SCM_ITEM_M_SN XD
                                             , SCM_MST_SITE XE
                                         WHERE XE.COMPANY_ID = XD.COMPANY_ID
                                           AND XE.OPERATION_GROUP = XD.SCP_OPERATION_GROUP
                                           AND XD.SCP_FLOW_ID NOT IN ('P5500', 'P9500')
                                           AND XD.SCP_OPERATION_GROUP = 'P') IH
                                 WHERE IG.ITEM_ID(+) = IE.ITEM_ID
                                   AND IG.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND E.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND E.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND F.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND F.PLANT_ID(+) = E.PLANT_ID
                                   AND F.ITEM_ID_ASSY(+) = IE.ITEM_ID
                                   AND G.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND G.ITEM_ID_ASSY(+) = IE.ITEM_ID
                                   AND H.ITEM_ID_ASSY(+) = IE.ITEM_ID
                                   AND IH.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND IH.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND IH.ITEM_ID(+) = IE.ITEM_ID
                                   AND E.SITE_TYPE(+) = 'PLANT'
                                   AND F.PRIORITY_1ST(+) = 1
                                   AND G.PRIORITY_2ND(+) = 1
                                   AND H.PRIORITY_3RD(+) = 1) ID
                         GROUP BY ID.SITE_ID
                                , ID.PLANT_ID
                                , ID.ITEM_ID
                                , ID.EFECTIVE_DATE
                                , ID.STOCK_TYPE
                                , ID.INCOTERMS
                                , ID.PROJECT_CODE
                                , ID.CELL_PROD_SITE_ID
                                , ID.LINE_ID
                                , ID.BEFORE_DEGAS) IB
                     , SCP_OPMZ_INV_ADJ B
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IC
                     , SCM_ADM_LOOKUP_MASTER_DETAIL D
                 WHERE B.STOCK_TYPE(+) = IB.STOCK_TYPE
                   AND B.PROJECT_CODE(+) = NVL(IB.PROJECT_CODE, '-')
                   AND B.SCM_SITE_ID(+) = IB.SITE_ID
                   AND B.ITEM_ID(+) = IB.ITEM_ID
                   AND B.INCOTERMS(+) = NVL(IB.INCOTERMS, '-')
                   AND B.INV_DATE(+) = IB.EFECTIVE_DATE
                   AND B.LINE_ID(+) = NVL(IB.LINE_ID, '-')
                   AND B.BEFORE_DEGAS(+) = NVL(IB.BEFORE_DEGAS, '-')
                   AND IC.ITEM_ID(+) = IB.ITEM_ID
                   AND D.SEGMENT1(+) = IB.STOCK_TYPE
                   AND D.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND B.DIVISION_ID(+) = P_DIVISION_ID
                   AND B.CUTOFF_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                   AND IC.DIVISION_ID(+) = P_DIVISION_ID
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR IB.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                 WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(IB.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IC.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IC.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                /* Insert 된 정보 */
                 UNION ALL
                SELECT J.DIVISION_ID
                     , J.CUTOFF_YYYYMMDD
                     , J.SRCE_DIVS_CD
                     , J.STOCK_TYPE
                     , L.SEGMENT2
                     , J.PROJECT_CODE
                     , IJ.NICK_NAME
                     , J.ITEM_ID
                     , J.INCOTERMS
                     , J.FROM_SITE_ID
                     , J.SCM_SITE_ID
                     , J.LINE_ID
                     , J.BEFORE_DEGAS
                     , TO_DATE(J.INV_DATE, 'YYYYMMDD')
                     , J.QTY
                     , J.CHG_QTY
                     , J.CHG_RSN
                     , J.CHG_TYPE
                     , J.LAST_UPDATED_BY
                     , J.LAST_UPDATE_DATE
                  FROM SCP_OPMZ_INV_ADJ J
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IJ
                     , SCM_ADM_LOOKUP_MASTER_DETAIL L
                 WHERE IJ.DIVISION_ID(+) = J.DIVISION_ID
                   AND IJ.ITEM_ID(+) = J.ITEM_ID
                   AND L.SEGMENT1(+) = J.STOCK_TYPE
                   AND L.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND UPPER(J.CHG_TYPE) = 'NEW'
                   AND J.LOCATION_CODE NOT IN ('COATING', 'SLITTING'      /* 전극 공정 */
                                             , 'NOTCHING')                /* 셀공정 : PACKAGING 이전 */
                   AND J.DIVISION_ID = P_DIVISION_ID
                   AND J.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR J.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(J.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IJ.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IJ.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST
                , IA.CUTOFF_YYYYMMDD NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LINE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LINE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.BEFORE_DEGAS, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.BEFORE_DEGAS, '_', '/')) NULLS FIRST
                , IA.INV_DATE NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_STOCK_ADJ_UC'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_STOCK_ADJ_UC;


    /* ==================================================================================================
       Stock(Elec. Plant) 조회용 적재 (AS-IS SCP0125_GET_STOCK_ELEC_PLNT · _UC 의 결과 SELECT 앞부분)
       - AS-IS 의 @V_DEMAND_CUTOFF_DAY · @MAT_CONST_TEMP 는 값을 넣기만 하고 쓰지 않아 옮기지 않았다.
       - AS-IS 의 @DM_TEMP 적재와 프로젝트 UPDATE 는 대상 조건이 FLAG = 'SALES' 인데
         적재 행이 전부 FLAG = 'PLANT' 라 항상 0 행이므로 옮기지 않았다.
       ================================================================================================== */
    PROCEDURE P_LOAD_STOCK_ELEC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_UC_YN                 IN  VARCHAR2
    )
    IS
        V_PLAN_NAME             VARCHAR2(8 CHAR);
        V_D_PLAN_NAME           DATE;
        V_CUTOFF_DAY            VARCHAR2(8 CHAR);
    BEGIN

        DELETE FROM GT_0125_INVENTORY_ORG;
        DELETE FROM GT_0125_SCP_INVENTORY;

        V_PLAN_NAME   := P_PLAN_START_YYYYMMDD;                                               /* 당주 월요일 YYYYMMDD */
        V_D_PLAN_NAME := TO_DATE(V_PLAN_NAME, 'YYYYMMDD');
        V_CUTOFF_DAY  := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'); /* 지난주 일요일 YYYYMMDD */

        INSERT INTO GT_0125_INVENTORY_ORG
                    (
                      DIVISION_ID
                    , CUTOFF_DATE
                    , PLANT_ID
                    , SITE_ID
                    , SCM_SITE_ID
                    , LOCATION_CODE
                    , PRODUCTION_TYPE
                    , STOCK_TYPE
                    , ITEM_ID
                    , MES_ITEM_ID
                    , WIPHOLD_YN
                    , AVAILABLE_DATE
                    , OPERATION_ID
                    , STORAGE_ID
                    , SCM_QTY
                    )
        SELECT A.DIVISION_ID
             , A.CUTOFF_DATE
             , A.PLANT_ID
             , A.SITE_ID
             , A.SCM_SITE_ID
             , A.LOCATION_CODE
             , A.PRODUCTION_TYPE
             , A.STOCK_TYPE
             , A.ITEM_ID
             , A.MES_ITEM_ID
             , A.WIPHOLD_YN
             , A.AVAILABLE_DATE
             , A.OPERATION_ID
             , A.STORAGE_ID
             , SUM(A.SCM_QTY)
          FROM SCM_DNM_STOCK A
             , SCM_ITEM_M_SN B
         WHERE B.COMPANY_ID = A.COMPANY_ID
           AND B.DIVISION_ID = A.DIVISION_ID
           AND B.SITE_ID = A.SITE_ID
           AND B.ITEM_ID = A.ITEM_ID
           AND (   (A.DIVISION_ID = '40' AND (A.PRODUCTION_TYPE IS NULL OR A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')))
                OR (A.DIVISION_ID <> '40'))                            /* div 40일 경우 production_type : 'MASS', 'C-MASS', 'M-SAMPLE' 만 조회(NULL 포함) */
           AND A.SCM_SITE_ID IS NOT NULL
           AND B.SCP_FLOW_ID IS NOT NULL
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
         GROUP BY A.DIVISION_ID
                , A.CUTOFF_DATE
                , A.PLANT_ID
                , A.SITE_ID
                , A.SCM_SITE_ID
                , A.LOCATION_CODE
                , A.PRODUCTION_TYPE
                , A.STOCK_TYPE
                , A.ITEM_ID
                , A.MES_ITEM_ID
                , A.WIPHOLD_YN
                , A.AVAILABLE_DATE
                , A.OPERATION_ID
                , A.STORAGE_ID;

        /* 1.4 PLANT 재고 */
        INSERT INTO GT_0125_SCP_INVENTORY
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , PROJECT_CODE
                    , FLAG
                    )
        SELECT A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.PLANT_ID
             , CASE WHEN IB.OPERATION_GROUP = 'E' THEN '-'
                    ELSE 'DAP'
               END
             , A.STOCK_TYPE
             , A.ITEM_ID
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN V_D_PLAN_NAME                    /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N' THEN V_D_PLAN_NAME
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME THEN V_D_PLAN_NAME
                    ELSE TRUNC(A.AVAILABLE_DATE)
               END
             , A.SCM_QTY
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END
             , IB.SITE_TYPE
             , A.LOCATION_CODE                                          /* PLANT 재고 구분용 정보 */
             , CASE WHEN IB.OPERATION_GROUP = 'E' THEN NULL
                    ELSE '-'
               END
             , 'PLANT'
          FROM GT_0125_INVENTORY_ORG A
             , (SELECT DISTINCT XA.DIVISION_ID
                     , XA.SCM_SITE_ID
                     , XA.SITE_TYPE
                     , XA.OPERATION_GROUP
                  FROM SCM_MST_SITE XA
                     , (SELECT XC.DIVISION_ID
                          FROM SCM_MST_DIVISION XC
                         WHERE XC.ATTRIBUTE4 = (SELECT XD.ATTRIBUTE4
                                                  FROM SCM_MST_DIVISION XD
                                                 WHERE XD.DIVISION_ID = P_DIVISION_ID)   /* 전극 Division 변수 */
                           AND XC.VALID_YN = 'Y'
                           AND XC.ATTRIBUTE3 <> 'EE') XB                   /* AS-IS #DIVISION */
                 WHERE XB.DIVISION_ID = XA.DIVISION_ID
                   AND XA.SITE_TYPE = 'PLANT'
                   AND XA.OPERATION_GROUP IN ('E', 'A')) IB
         WHERE IB.DIVISION_ID = A.DIVISION_ID
           AND IB.SCM_SITE_ID = A.SCM_SITE_ID
           AND (   A.LOCATION_CODE IN ('COATING', 'SLITTING', 'NOTCHING')                                   /* 전극 공정 · 셀공정 */
                OR (P_UC_YN = 'N' AND A.LOCATION_CODE IN ('PANCAKE_INV', 'WINDER', 'LAMINATION', 'FOLDING')))  /* 셀공정 : PACKAGING 이전 (81_UC 제외) */
           AND (   (A.DIVISION_ID = '40' AND (A.PRODUCTION_TYPE IS NULL OR A.PRODUCTION_TYPE IN ('MASS', 'C-MASS', 'M-SAMPLE')))
                OR (A.DIVISION_ID <> '40'))
           AND A.CUTOFF_DATE = V_CUTOFF_DAY;

    END P_LOAD_STOCK_ELEC;


    /* ==================================================================================================
       Stock(Elec. Plant) 조회 - 81_UC 외 사업부
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_STOCK_ELEC_PLNT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_D_PLAN_NAME           DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');
    BEGIN

        P_LOAD_STOCK_ELEC(P_DIVISION_ID, P_PLAN_START_YYYYMMDD, 'N');

        OPEN O_RC1 FOR
        SELECT IA.*
             , IA.CHG_QTY AS PRE_CHG_QTY
             , IA.CHG_RSN AS PRE_CHG_RSN
          FROM (SELECT P_DIVISION_ID AS DIVISION_ID
                     , P_PLAN_START_YYYYMMDD AS CUTOFF_YYYYMMDD
                     , IB.STOCK_TYPE AS SRCE_DIVS_CD
                     , IB.STOCK_TYPE
                     , D.SEGMENT2 AS STOCK_TYPE_NAME
                     , IB.PROJECT_CODE
                     , IC.NICK_NAME
                     , IB.ITEM_ID
                     , IB.INCOTERMS
                     , IB.PLANT_ID AS FROM_SITE_ID
                     , IB.SITE_ID AS SCM_SITE_ID
                     , IB.LOCATION_CODE
                     , TO_DATE(IB.EFECTIVE_DATE, 'YYYYMMDD') AS INV_DATE
                     , IB.QTY
                     , B.CHG_QTY
                     , B.CHG_RSN
                     , B.CHG_TYPE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                  FROM (SELECT ID.SITE_ID
                             , ID.PLANT_ID
                             , ID.ITEM_ID
                             , ID.EFECTIVE_DATE
                             , ID.STOCK_TYPE
                             , SUM(ID.QTY) AS QTY
                             , ID.INCOTERMS
                             , ID.LOCATION_CODE
                             , ID.PROJECT_CODE
                          FROM (SELECT IE.SCM_SITE_ID AS SITE_ID
                                     , IE.PLANT_ID
                                     , CASE WHEN RTRIM(IG.CHILD_ITEM_ID) IS NULL THEN IE.ITEM_ID
                                            ELSE IG.CHILD_ITEM_ID
                                       END AS ITEM_ID
                                     /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
                                     , CASE WHEN IE.FLAG = 'SALES' THEN 'ELECBIZ'
                                            WHEN IE.FLAG = 'INT' THEN 'TARGETBIZ'                                 /* 전극은 Cell PKG 를 Demand로 처리하므로 Cell 도착은 Sales SIte 로 취급 */
                                            WHEN IE.LOCATION_CODE NOT IN ('COATING', 'SLITTING') THEN 'TARGETBIZ' /* Cell Plant 재고 Sales SIte 로 취급 */
                                            WHEN IE.LOCATION_CODE = 'SLITTING' THEN 'ELEC_POST'
                                            WHEN IE.LOCATION_CODE = 'COATING' THEN 'COATING'
                                            ELSE '-'
                                       END AS STAGE
                                     , TO_CHAR(NVL(IE.EFFSTARTDATE, V_D_PLAN_NAME), 'YYYYMMDD') AS EFECTIVE_DATE
                                     , IE.DESCR AS STOCK_TYPE
                                     , CASE WHEN RTRIM(IG.CHILD_ITEM_ID) IS NULL THEN IE.QTY
                                            ELSE IE.QTY * NVL(TO_NUMBER(IG.USAGE), 1)
                                       END AS QTY                               /* CELL 재고를 전극으로 전환 */
                                     , IE.INCOTERMS
                                     , IE.LOCATION_CODE
                                     , IE.PROJECT_CODE
                                  FROM (SELECT XA.DIVISION_ID
                                             , XA.ITEM_ID
                                             , XA.SCM_SITE_ID
                                             , XA.PLANT_ID
                                             , XA.INCOTERMS
                                             , TRUNC(XA.AVAILABLE_DATE) AS EFFSTARTDATE
                                             , SUM(XA.QTY) AS QTY
                                             , CASE WHEN NVL(XA.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END AS DESCR
                                             , XA.LOCATION_CODE
                                             , XA.PROJECT_CODE
                                             , XA.FLAG
                                          FROM GT_0125_SCP_INVENTORY XA
                                         GROUP BY XA.DIVISION_ID
                                                , XA.ITEM_ID
                                                , XA.SCM_SITE_ID
                                                , TRUNC(XA.AVAILABLE_DATE)
                                                , NVL(XA.WIPHOLD_YN, 'N')
                                                , XA.INCOTERMS
                                                , XA.LOCATION_CODE
                                                , XA.PROJECT_CODE
                                                , XA.FLAG
                                                , XA.PLANT_ID
                                        HAVING SUM(XA.QTY) > 0) IE
                                     , (SELECT XB.PARENT_ITEM_ID
                                             , XB.CHILD_ITEM_ID
                                             , MAX(XB.USAGE) AS USAGE
                                          FROM SCP_OPT_ENG_BOM_ELEC_SN XB
                                         WHERE XB.SCP_YN = 'Y'
                                         GROUP BY XB.PARENT_ITEM_ID
                                                , XB.CHILD_ITEM_ID) IG            /* CELL 재고를 전극으로 전환하기 위한 정보 */
                                     , SCM_MST_SITE E
                                 WHERE IG.PARENT_ITEM_ID(+) = IE.ITEM_ID
                                   AND E.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND E.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND E.VALID_YN(+) = 'Y') ID                /* 최종 ITEM_ID 별 GROUP BY */
                         GROUP BY ID.SITE_ID
                                , ID.PLANT_ID
                                , ID.ITEM_ID
                                , ID.EFECTIVE_DATE
                                , ID.STOCK_TYPE
                                , ID.INCOTERMS
                                , ID.PROJECT_CODE
                                , ID.LOCATION_CODE) IB
                     , SCP_OPMZ_INV_ADJ B
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IC
                     , SCM_ADM_LOOKUP_MASTER_DETAIL D
                 WHERE B.STOCK_TYPE(+) = IB.STOCK_TYPE
                   AND B.PROJECT_CODE(+) = NVL(IB.PROJECT_CODE, '-')
                   AND B.SCM_SITE_ID(+) = IB.SITE_ID
                   AND B.ITEM_ID(+) = IB.ITEM_ID
                   AND B.INCOTERMS(+) = NVL(IB.INCOTERMS, '-')
                   AND B.INV_DATE(+) = IB.EFECTIVE_DATE
                   AND B.LOCATION_CODE(+) = IB.LOCATION_CODE
                   AND IC.ITEM_ID(+) = IB.ITEM_ID
                   AND D.SEGMENT1(+) = IB.STOCK_TYPE
                   AND D.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND B.DIVISION_ID(+) = P_DIVISION_ID
                   AND B.CUTOFF_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                   AND IC.DIVISION_ID(+) = P_DIVISION_ID
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR IB.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                 WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(IB.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IC.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IC.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                /* Insert 된 정보 */
                 UNION ALL
                SELECT J.DIVISION_ID
                     , J.CUTOFF_YYYYMMDD
                     , J.SRCE_DIVS_CD
                     , J.STOCK_TYPE
                     , L.SEGMENT2
                     , J.PROJECT_CODE
                     , IJ.NICK_NAME
                     , J.ITEM_ID
                     , J.INCOTERMS
                     , J.FROM_SITE_ID
                     , J.SCM_SITE_ID
                     , J.LOCATION_CODE
                     , TO_DATE(J.INV_DATE, 'YYYYMMDD')                  /* 기준일자 */
                     , J.QTY
                     , J.CHG_QTY
                     , J.CHG_RSN
                     , J.CHG_TYPE
                     , J.LAST_UPDATED_BY
                     , J.LAST_UPDATE_DATE
                  FROM SCP_OPMZ_INV_ADJ J
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IJ
                     , SCM_ADM_LOOKUP_MASTER_DETAIL L
                 WHERE IJ.DIVISION_ID(+) = J.DIVISION_ID
                   AND IJ.ITEM_ID(+) = J.ITEM_ID
                   AND L.SEGMENT1(+) = J.STOCK_TYPE
                   AND L.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND UPPER(J.CHG_TYPE) = 'NEW'
                   AND J.LOCATION_CODE IN ('COATING', 'SLITTING'                                        /* 전극 공정 */
                                         , 'PANCAKE_INV', 'WINDER', 'NOTCHING', 'LAMINATION', 'FOLDING') /* 셀공정 : PACKAGING 이전 */
                   AND J.DIVISION_ID = P_DIVISION_ID
                   AND J.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR J.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(J.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IJ.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IJ.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST
                , IA.CUTOFF_YYYYMMDD NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LOCATION_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LOCATION_CODE, '_', '/')) NULLS FIRST
                , IA.INV_DATE NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_PLNT'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_STOCK_ELEC_PLNT;


    /* ==================================================================================================
       Stock(Elec. Plant) 조회 - 81_UC 사업부
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_STOCK_ELEC_UC
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        V_D_PLAN_NAME           DATE := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');
    BEGIN

        P_LOAD_STOCK_ELEC(P_DIVISION_ID, P_PLAN_START_YYYYMMDD, 'Y');

        OPEN O_RC1 FOR
        SELECT IA.*
             , IA.CHG_QTY AS PRE_CHG_QTY
             , IA.CHG_RSN AS PRE_CHG_RSN
          FROM (SELECT P_DIVISION_ID AS DIVISION_ID
                     , P_PLAN_START_YYYYMMDD AS CUTOFF_YYYYMMDD
                     , IB.STOCK_TYPE AS SRCE_DIVS_CD
                     , IB.STOCK_TYPE
                     , D.SEGMENT2 AS STOCK_TYPE_NAME
                     , IB.PROJECT_CODE
                     , IC.NICK_NAME
                     , IB.ITEM_ID
                     , IB.INCOTERMS
                     , IB.PLANT_ID AS FROM_SITE_ID
                     , IB.SITE_ID AS SCM_SITE_ID
                     , IB.LOCATION_CODE
                     , TO_DATE(IB.EFECTIVE_DATE, 'YYYYMMDD') AS INV_DATE
                     , IB.QTY
                     , B.CHG_QTY
                     , B.CHG_RSN
                     , B.CHG_TYPE
                     , B.LAST_UPDATED_BY
                     , B.LAST_UPDATE_DATE
                  FROM (SELECT ID.SITE_ID
                             , ID.PLANT_ID
                             , ID.ITEM_ID
                             , ID.EFECTIVE_DATE
                             , ID.STOCK_TYPE
                             , SUM(ID.QTY) AS QTY
                             , ID.INCOTERMS
                             , ID.LOCATION_CODE
                             , ID.PROJECT_CODE
                          FROM (SELECT IE.SCM_SITE_ID AS SITE_ID
                                     , IE.PLANT_ID
                                     , IE.ITEM_ID
                                     , CASE WHEN RTRIM(IG.STAGE) IS NULL AND IE.LOCATION_CODE = 'SLITTING' THEN 'COATING'
                                            WHEN RTRIM(IG.STAGE) IS NULL AND IE.LOCATION_CODE = 'COATING' THEN 'COATING'
                                            WHEN RTRIM(IG.STAGE) IS NULL AND IE.LOCATION_CODE = 'NOTCHING' THEN 'NND'
                                            WHEN RTRIM(IG.STAGE) IS NOT NULL THEN IG.STAGE
                                            WHEN IE.LOCATION_CODE NOT IN ('COATING', 'NOTCHING') THEN 'TARGETBIZ'   /* Cell Plant 재고 Sales SIte 로 취급 */
                                            ELSE '-'
                                       END AS STAGE
                                     , TO_CHAR(NVL(IE.EFFSTARTDATE, V_D_PLAN_NAME), 'YYYYMMDD') AS EFECTIVE_DATE
                                     , IE.DESCR AS STOCK_TYPE
                                     , IE.QTY                                   /* CELL 재고를 전극으로 전환 */
                                     , IE.INCOTERMS
                                     , IE.LOCATION_CODE
                                     , IE.PROJECT_CODE
                                  FROM (SELECT XA.DIVISION_ID
                                             , XA.ITEM_ID
                                             , XA.SCM_SITE_ID
                                             , XA.PLANT_ID
                                             , XA.INCOTERMS
                                             , TRUNC(XA.AVAILABLE_DATE) AS EFFSTARTDATE
                                             , SUM(XA.QTY) AS QTY
                                             , CASE WHEN NVL(XA.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END AS DESCR
                                             , XA.LOCATION_CODE
                                             , XA.PROJECT_CODE
                                             , XA.FLAG
                                          FROM GT_0125_SCP_INVENTORY XA
                                         GROUP BY XA.DIVISION_ID
                                                , XA.ITEM_ID
                                                , XA.SCM_SITE_ID
                                                , TRUNC(XA.AVAILABLE_DATE)
                                                , NVL(XA.WIPHOLD_YN, 'N')
                                                , XA.INCOTERMS
                                                , XA.LOCATION_CODE
                                                , XA.PROJECT_CODE
                                                , XA.FLAG
                                                , XA.PLANT_ID
                                        HAVING SUM(XA.QTY) > 0) IE
                                     , SCM_MST_SITE E
                                     , (SELECT XB.SEGMENT4 AS SCM_SITE_ID
                                             , XB.SEGMENT5 AS ITEM_ID
                                             , XB.ATTRIBUTE3 AS STAGE
                                          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL XB
                                         WHERE XB.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                           AND XB.VALID_YN = 'Y'
                                           AND XB.SEGMENT2 = P_DIVISION_ID
                                         GROUP BY XB.SEGMENT4
                                                , XB.SEGMENT5
                                                , XB.ATTRIBUTE3) IG
                                 WHERE E.DIVISION_ID(+) = IE.DIVISION_ID
                                   AND E.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND IG.SCM_SITE_ID(+) = IE.SCM_SITE_ID
                                   AND IG.ITEM_ID(+) = IE.ITEM_ID
                                   AND E.VALID_YN(+) = 'Y') ID
                         GROUP BY ID.SITE_ID
                                , ID.PLANT_ID
                                , ID.ITEM_ID
                                , ID.EFECTIVE_DATE
                                , ID.STOCK_TYPE
                                , ID.INCOTERMS
                                , ID.PROJECT_CODE
                                , ID.LOCATION_CODE) IB
                     , SCP_OPMZ_INV_ADJ B
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IC
                     , SCM_ADM_LOOKUP_MASTER_DETAIL D
                 WHERE B.STOCK_TYPE(+) = IB.STOCK_TYPE
                   AND B.PROJECT_CODE(+) = NVL(IB.PROJECT_CODE, '-')
                   AND B.SCM_SITE_ID(+) = IB.SITE_ID
                   AND B.ITEM_ID(+) = IB.ITEM_ID
                   AND B.INCOTERMS(+) = NVL(IB.INCOTERMS, '-')
                   AND B.INV_DATE(+) = IB.EFECTIVE_DATE
                   AND B.LOCATION_CODE(+) = IB.LOCATION_CODE
                   AND IC.ITEM_ID(+) = IB.ITEM_ID
                   AND D.SEGMENT1(+) = IB.STOCK_TYPE
                   AND D.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND B.DIVISION_ID(+) = P_DIVISION_ID
                   AND B.CUTOFF_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                   AND IC.DIVISION_ID(+) = P_DIVISION_ID
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR IB.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                 WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(IB.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IC.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IC.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                /* Insert 된 정보 */
                 UNION ALL
                SELECT J.DIVISION_ID
                     , J.CUTOFF_YYYYMMDD
                     , J.SRCE_DIVS_CD
                     , J.STOCK_TYPE
                     , L.SEGMENT2
                     , J.PROJECT_CODE
                     , IJ.NICK_NAME
                     , J.ITEM_ID
                     , J.INCOTERMS
                     , J.FROM_SITE_ID
                     , J.SCM_SITE_ID
                     , J.LOCATION_CODE
                     , TO_DATE(J.INV_DATE, 'YYYYMMDD')
                     , J.QTY
                     , J.CHG_QTY
                     , J.CHG_RSN
                     , J.CHG_TYPE
                     , J.LAST_UPDATED_BY
                     , J.LAST_UPDATE_DATE
                  FROM SCP_OPMZ_INV_ADJ J
                     , (SELECT DIVISION_ID
                             , ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE DIVISION_ID = P_DIVISION_ID          /* 조인 조건과 같은 사업부로 한정 (속도) */
                         GROUP BY DIVISION_ID
                                , ITEM_ID) IJ
                     , SCM_ADM_LOOKUP_MASTER_DETAIL L
                 WHERE IJ.DIVISION_ID(+) = J.DIVISION_ID
                   AND IJ.ITEM_ID(+) = J.ITEM_ID
                   AND L.SEGMENT1(+) = J.STOCK_TYPE
                   AND L.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND UPPER(J.CHG_TYPE) = 'NEW'
                   AND J.LOCATION_CODE IN ('COATING', 'SLITTING'      /* 전극 공정 */
                                         , 'NOTCHING')                /* 셀공정 : PACKAGING 이전 */
                   AND J.DIVISION_ID = P_DIVISION_ID
                   AND J.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR J.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(J.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IJ.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IJ.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.DIVISION_ID, '_', '/')) NULLS FIRST
                , IA.CUTOFF_YYYYMMDD NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PROJECT_CODE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SCM_SITE_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.INCOTERMS, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LOCATION_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.LOCATION_CODE, '_', '/')) NULLS FIRST
                , IA.INV_DATE NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_STOCK_ELEC_UC'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_STOCK_ELEC_UC;


    /* ==================================================================================================
       Stock(2nd OCV) 조회
       ================================================================================================== */
    PROCEDURE P_SCP0125_GET_STOCK_SECOND_OCV
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_VERSION_NO            IN  VARCHAR2,
        P_NICK_NAME             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
    BEGIN

        DELETE FROM GT_0125_NICK_NAME;
        DELETE FROM GT_0125_OCV_EXCEPT;

        INSERT INTO GT_0125_NICK_NAME
                    (
                      DIVISION_ID
                    , ITEM_ID
                    , NICK_NAME
                    )
        SELECT DIVISION_ID
             , ITEM_ID
             , MAX(NICK_NAME)
          FROM SCM_MST_ITEM_SN
         WHERE RTRIM(NICK_NAME) IS NOT NULL
           AND DIVISION_ID = P_DIVISION_ID
         GROUP BY DIVISION_ID
                , ITEM_ID;

        INSERT INTO GT_0125_OCV_EXCEPT
                    (
                      DIVISION_ID
                    , SCM_SITE_ID
                    , PLANT_ID
                    , ITEM_ID
                    )
        SELECT C.DIVISION_ID
             , B.SCM_SITE_ID
             , B.PLANT_ID
             , C.CHILD_ITEM_ID
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             , SCM_MST_SITE B
             , SCM_MST_BOM_SN_V C
         WHERE B.SCM_SITE_ID = A.SEGMENT4
           AND C.PLANT_ID = B.PLANT_ID
           AND C.PARENT_ITEM_ID = A.SEGMENT5
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
           AND A.VALID_YN = 'Y'
           AND A.ATTRIBUTE1 = 'B'
           AND A.SEGMENT2 = P_DIVISION_ID
         GROUP BY B.SCM_SITE_ID
                , C.CHILD_ITEM_ID
                , B.PLANT_ID
                , C.DIVISION_ID;

        OPEN O_RC1 FOR
        SELECT IA.*
          FROM (SELECT IB.DIVISION_ID
                     , IB.CUTOFF_YYYYMMDD
                     , IB.STOCK_TYPE
                     , IB.STOCK_TYPE_NAME
                     , IB.NICK_NAME
                     , IB.ITEM_ID
                     , IB.PLANT_ID
                     , IB.OPERATION_ID
                     , IB.OPERATION_NAME
                     , IB.SECOND_OCV_TIME
                     , IB.SECOND_OCV_DATE
                     , IB.QTY
                     , F.CHG_QTY
                     , F.CHG_RSN
                     , F.CHG_TYPE
                     , F.LAST_UPDATED_BY
                     , F.LAST_UPDATE_DATE
                     , F.CHG_QTY AS PRE_CHG_QTY
                     , F.CHG_RSN AS PRE_CHG_RSN
                  FROM (SELECT A.DIVISION_ID
                             , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_YYYYMMDD
                             , CASE WHEN NVL(A.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END AS STOCK_TYPE
                             , E.SEGMENT2 AS STOCK_TYPE_NAME
                             , D.NICK_NAME
                             , A.MES_ITEM_ID AS ITEM_ID
                             , A.PLANT_ID
                             , A.MES_OPERATION_ID AS OPERATION_ID
                             , CAST(NULL AS VARCHAR2(200 CHAR)) AS OPERATION_NAME /* 공정명 : SCM_MST_MMD_OPERATION_SN 직접 권한 부여(02 파일) 후 원복 - 2026.09.17 AJS */
                             , TO_CHAR(A.SECOND_OCV_TIME) AS SECOND_OCV_TIME
                             , TRUNC(A.SECOND_OCV_EXP_DATE) AS SECOND_OCV_DATE
                             , SUM(A.QTY) AS QTY
                          FROM SCM_DNM_STOCK_SN A
                             , GT_0125_OCV_EXCEPT B
                          /* , SCM_MST_MMD_OPERATION_SN C */
                             , GT_0125_NICK_NAME D
                             , SCM_ADM_LOOKUP_MASTER_DETAIL E
                         WHERE B.DIVISION_ID = A.DIVISION_ID
                           AND B.PLANT_ID = A.PLANT_ID
                           AND B.ITEM_ID = A.MES_ITEM_ID
                        /* AND C.OPERATION_ID(+) = A.MES_OPERATION_ID */
                           AND D.DIVISION_ID(+) = A.DIVISION_ID
                           AND D.ITEM_ID(+) = A.MES_ITEM_ID
                           AND E.SEGMENT1(+) = CASE WHEN NVL(A.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END
                           AND E.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                           AND A.MES_ITEM_ID IS NOT NULL
                           AND A.DIVISION_ID = P_DIVISION_ID
                           AND A.CUTOFF_DATE >= TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                           AND A.CUTOFF_DATE < TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1
                         GROUP BY A.DIVISION_ID
                                , A.CUTOFF_DATE
                                , A.WIPHOLD_YN
                                , A.STOCK_TYPE
                                , A.MES_ITEM_ID
                                , A.PLANT_ID
                                , A.MES_OPERATION_ID
                             /* , C.OPERATION_NAME */
                                , A.SECOND_OCV_TIME
                                , A.SECOND_OCV_EXP_DATE
                                , E.SEGMENT2
                                , D.NICK_NAME) IB
                     , SCP_OPMZ_INV_SECOND_OCV F
                 WHERE F.STOCK_TYPE(+) = IB.STOCK_TYPE
                   AND F.ITEM_ID(+) = IB.ITEM_ID
                   AND F.PLANT_ID(+) = IB.PLANT_ID
                   AND F.OPERATION_ID(+) = NVL(IB.OPERATION_ID, '-')
                   AND F.SECOND_OCV_TIME(+) = NVL(IB.SECOND_OCV_TIME, '-')
                   AND F.SECOND_OCV_DATE(+) = TO_CHAR(IB.SECOND_OCV_DATE, 'YYYYMMDD')
                   AND F.DIVISION_ID(+) = P_DIVISION_ID
                   AND F.CUTOFF_YYYYMMDD(+) = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR IB.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XS
                                 WHERE TRIM(XS.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(IB.ITEM_ID) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%'
                                    OR  UPPER(IB.NICK_NAME) LIKE '%' || UPPER(TRIM(XS.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR IB.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')
                /* Insert 된 정보 */
                 UNION ALL
                SELECT G.DIVISION_ID
                     , G.CUTOFF_YYYYMMDD
                     , G.STOCK_TYPE
                     , K.SEGMENT2
                     , J.NICK_NAME
                     , G.ITEM_ID
                     , G.PLANT_ID
                     , G.OPERATION_ID
                     , CAST(NULL AS VARCHAR2(200 CHAR)) /* 공정명 : SCM_MST_MMD_OPERATION_SN 직접 권한 부여(02 파일) 후 원복 - 2026.09.17 AJS */
                     , G.SECOND_OCV_TIME
                     , TO_DATE(CASE WHEN G.SECOND_OCV_DATE = '-' THEN NULL ELSE G.SECOND_OCV_DATE END, 'YYYYMMDD')  /* AS-IS 빈 문자는 이관 시 '-' */
                     , G.QTY
                     , G.CHG_QTY
                     , G.CHG_RSN
                     , G.CHG_TYPE
                     , G.LAST_UPDATED_BY
                     , G.LAST_UPDATE_DATE
                     , G.CHG_QTY
                     , G.CHG_RSN
                  FROM SCP_OPMZ_INV_SECOND_OCV G
                     , GT_0125_OCV_EXCEPT H
                  /* , SCM_MST_MMD_OPERATION_SN I */
                     , GT_0125_NICK_NAME J
                     , SCM_ADM_LOOKUP_MASTER_DETAIL K
                 WHERE H.DIVISION_ID = G.DIVISION_ID
                   AND H.PLANT_ID = G.PLANT_ID
                   AND H.ITEM_ID = G.ITEM_ID
                /* AND I.OPERATION_ID(+) = G.OPERATION_ID */
                   AND J.DIVISION_ID(+) = G.DIVISION_ID
                   AND J.ITEM_ID(+) = G.ITEM_ID
                   AND K.SEGMENT1(+) = G.STOCK_TYPE
                   AND K.LOOKUP_TYPE(+) = 'STOCK_TYPE'
                   AND UPPER(G.CHG_TYPE) = 'NEW'
                   AND G.DIVISION_ID = P_DIVISION_ID
                   AND G.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                   AND (RTRIM(P_ITEM_ID) IS NULL OR G.ITEM_ID LIKE '%' || UPPER(P_ITEM_ID) || '%')
                   AND (RTRIM(P_ITEM_ID) IS NULL
                    OR  EXISTS (SELECT 1
                                  FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) XT
                                 WHERE TRIM(XT.COLUMN_VALUE) IS NOT NULL
                                   AND (UPPER(G.ITEM_ID) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%'
                                    OR  UPPER(J.NICK_NAME) LIKE '%' || UPPER(TRIM(XT.COLUMN_VALUE)) || '%')))    /* 코드 또는 닉네임 부분일치 */
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (RTRIM(P_NICK_NAME) IS NULL OR J.NICK_NAME LIKE '%' || UPPER(P_NICK_NAME) || '%')) IA
         ORDER BY UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.STOCK_TYPE_NAME, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLANT_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.PLANT_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.OPERATION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.OPERATION_ID, '_', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SECOND_OCV_TIME, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.SECOND_OCV_TIME, '_', '/')) NULLS FIRST
                , IA.SECOND_OCV_DATE NULLS FIRST;

        O_RESULT_CODE := 'S';
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            O_RESULT_CODE := 'F';
            O_RESULT_MSG  := '[' || TO_CHAR(SQLCODE) || ']' || SQLERRM;

            P_LOG_ERROR('PKG_SCP0125.P_SCP0125_GET_STOCK_SECOND_OCV'
                      , 'P_DIVISION_ID=' || P_DIVISION_ID || ', P_PLAN_START_YYYYMMDD=' || P_PLAN_START_YYYYMMDD
                     || ', P_NICK_NAME=' || P_NICK_NAME || ', P_ITEM_ID=' || P_ITEM_ID
                      , TO_CHAR(SQLCODE)
                      , SQLERRM
                      , DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
    END P_SCP0125_GET_STOCK_SECOND_OCV;


    /* ==================================================================================================
       MKT FCST 등록 · 수정 · 삭제
       ================================================================================================== */
    PROCEDURE P_SCP0125_SAVE_MKT_FCST_ADJ
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_VERSION_NO            IN  CLOB,
        P_CUTOFF_YYYYMMDD       IN  CLOB,
        P_PROJECT_CODE          IN  CLOB,
        P_SALES_SITE_ID         IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_FCST_TYPE             IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_PLANT_SITE_ID         IN  CLOB,
        P_CELL_PROD_SITE_ID     IN  CLOB,
        P_DUE_DATE              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        C_DELIM                 CONSTANT VARCHAR2(1 CHAR) := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SCP0125.P_SCP0125_SAVE_MKT_FCST_ADJ';

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_VERSION_NO            T_TOKEN_TAB;
        T_CUTOFF_YYYYMMDD       T_TOKEN_TAB;
        T_PROJECT_CODE          T_TOKEN_TAB;
        T_SALES_SITE_ID         T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_FCST_TYPE             T_TOKEN_TAB;
        T_INCOTERMS             T_TOKEN_TAB;
        T_PLANT_SITE_ID         T_TOKEN_TAB;
        T_CELL_PROD_SITE_ID     T_TOKEN_TAB;
        T_DUE_DATE              T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_CHG_QTY               T_TOKEN_TAB;
        T_CHG_RSN               T_TOKEN_TAB;
        T_CHG_TYPE              T_TOKEN_TAB;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_DUMMY_CNT             PLS_INTEGER;
        V_EXISTS                PLS_INTEGER;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_VERSION_NO            VARCHAR2(4000 CHAR);
        V_CUTOFF_YYYYMMDD       VARCHAR2(4000 CHAR);
        V_PROJECT_CODE          VARCHAR2(4000 CHAR);
        V_SALES_SITE_ID         VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_FCST_TYPE             VARCHAR2(4000 CHAR);
        V_INCOTERMS             VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID         VARCHAR2(4000 CHAR);
        V_CELL_PROD_SITE_ID     VARCHAR2(4000 CHAR);
        V_DUE_DATE              VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_CHG_QTY               VARCHAR2(4000 CHAR);
        V_CHG_RSN               VARCHAR2(4000 CHAR);
        V_CHG_TYPE              VARCHAR2(4000 CHAR);

        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        /* 트렌젝션 시작 - 오류 시 이 지점으로 되돌린다 */
        SAVEPOINT SP_SCP0125_SAVE;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        /* 각 컬럼들에 대한 스플릿처리 · 프로시저 LOOP 길이를 판단 */
        P_SPLIT_TOKEN(P_ACTIVE_FLAG      , C_DELIM, T_ACTIVE_FLAG      , V_MAX_LOOP_CNT);
        P_SPLIT_TOKEN(P_DIVISION_ID      , C_DELIM, T_DIVISION_ID      , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_VERSION_NO       , C_DELIM, T_VERSION_NO       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CUTOFF_YYYYMMDD  , C_DELIM, T_CUTOFF_YYYYMMDD  , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PROJECT_CODE     , C_DELIM, T_PROJECT_CODE     , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SALES_SITE_ID    , C_DELIM, T_SALES_SITE_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID          , C_DELIM, T_ITEM_ID          , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_FCST_TYPE        , C_DELIM, T_FCST_TYPE        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_INCOTERMS        , C_DELIM, T_INCOTERMS        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLANT_SITE_ID    , C_DELIM, T_PLANT_SITE_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CELL_PROD_SITE_ID, C_DELIM, T_CELL_PROD_SITE_ID, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_DUE_DATE         , C_DELIM, T_DUE_DATE         , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_QTY              , C_DELIM, T_QTY              , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_QTY          , C_DELIM, T_CHG_QTY          , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_RSN          , C_DELIM, T_CHG_RSN          , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_TYPE         , C_DELIM, T_CHG_TYPE         , V_DUMMY_CNT);

        /* AS-IS WHILE LEN(@recv_active_flag) > 0 AND @mst_loop_cnt < @max_loop_cnt */
        IF NVL(LENGTH(RTRIM(DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 4000, 1))), 0) > 0 THEN

            WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
            LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                V_ACTIVE_FLAG       := F_TOKEN(T_ACTIVE_FLAG      , V_MST_LOOP_CNT);
                V_DIVISION_ID       := F_KEY  (T_DIVISION_ID      , V_MST_LOOP_CNT);
                V_VERSION_NO        := F_KEY  (T_VERSION_NO       , V_MST_LOOP_CNT);
                V_CUTOFF_YYYYMMDD   := F_KEY  (T_CUTOFF_YYYYMMDD  , V_MST_LOOP_CNT);
                V_PROJECT_CODE      := F_KEY  (T_PROJECT_CODE     , V_MST_LOOP_CNT);
                V_SALES_SITE_ID     := F_KEY  (T_SALES_SITE_ID    , V_MST_LOOP_CNT);
                V_ITEM_ID           := F_KEY  (T_ITEM_ID          , V_MST_LOOP_CNT);
                V_FCST_TYPE         := F_KEY  (T_FCST_TYPE        , V_MST_LOOP_CNT);
                V_INCOTERMS         := F_KEY  (T_INCOTERMS        , V_MST_LOOP_CNT);
                V_PLANT_SITE_ID     := F_KEY  (T_PLANT_SITE_ID    , V_MST_LOOP_CNT);
                V_CELL_PROD_SITE_ID := F_KEY  (T_CELL_PROD_SITE_ID, V_MST_LOOP_CNT);
                V_DUE_DATE          := F_KEY  (T_DUE_DATE         , V_MST_LOOP_CNT);
                V_QTY               := F_TOKEN(T_QTY              , V_MST_LOOP_CNT);
                V_CHG_QTY           := F_TOKEN(T_CHG_QTY          , V_MST_LOOP_CNT);
                V_CHG_RSN           := F_KEY  (T_CHG_RSN          , V_MST_LOOP_CNT);
                V_CHG_TYPE          := F_KEY  (T_CHG_TYPE         , V_MST_LOOP_CNT);

                IF UPPER(V_ACTIVE_FLAG) = 'I' THEN

                    /* AS-IS 는 CHG_RSN 이 'New' 일 때 중복체크한다 (원문 그대로) */
                    IF UPPER(V_CHG_RSN) = 'NEW' THEN
                        /***** 중복체크 *****/
                        BEGIN
                            SELECT 1
                              INTO V_EXISTS
                              FROM DM_PLN_NET_DEMAND
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND VERSION_NO = UPPER(V_VERSION_NO)
                               AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                               AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                               AND UPPER(SCM_SITE_ID) = UPPER(V_SALES_SITE_ID)
                               AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                               AND UPPER(FCST_TYPE) = UPPER(V_FCST_TYPE)
                               AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                               AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                               AND UPPER(CELL_PROD_SITE_ID) = UPPER(V_CELL_PROD_SITE_ID)
                               AND YYYYMMDD = V_DUE_DATE
                               AND ROWNUM = 1;

                            V_ERR_CODE := '99010';
                            V_ERR_MSG  := ' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
                            RAISE E_BIZ;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;
                        /***** 중복체크 *****/
                    END IF;

                    /* 대소문자만 다른 같은 키가 있으면 AS-IS 처럼 기본키 중복 (Oracle 기본키는 대소문자 구분) */
                    BEGIN
                        SELECT 1
                          INTO V_EXISTS
                          FROM SCP_OPMZ_DMD_ADJ
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND UPPER(VERSION_NO) = UPPER(V_VERSION_NO)
                               AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                               AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                               AND UPPER(SCM_SITE_ID) = UPPER(V_SALES_SITE_ID)
                               AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                               AND UPPER(FCST_TYPE) = UPPER(V_FCST_TYPE)
                               AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                               AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                               AND UPPER(CELL_PROD_SITE_ID) = UPPER(V_CELL_PROD_SITE_ID)
                               AND DUE_DATE = V_DUE_DATE
                           AND ROWNUM = 1;

                        RAISE DUP_VAL_ON_INDEX;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    INSERT INTO SCP_OPMZ_DMD_ADJ
                                (
                                  DIVISION_ID
                                , VERSION_NO
                                , CUTOFF_YYYYMMDD
                                , PROJECT_CODE
                                , SCM_SITE_ID
                                , ITEM_ID
                                , FCST_TYPE
                                , INCOTERMS
                                , PLANT_SITE_ID
                                , CELL_PROD_SITE_ID
                                , DUE_DATE
                                , QTY
                                , CHG_QTY
                                , CHG_RSN
                                , CHG_TYPE
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                                )
                         VALUES (
                                  V_DIVISION_ID
                                , V_VERSION_NO
                                , V_CUTOFF_YYYYMMDD
                                , V_PROJECT_CODE
                                , V_SALES_SITE_ID
                                , V_ITEM_ID
                                , V_FCST_TYPE
                                , V_INCOTERMS
                                , V_PLANT_SITE_ID
                                , V_CELL_PROD_SITE_ID
                                , V_DUE_DATE
                                , TO_NUMBER(V_QTY)
                                , TO_NUMBER(V_CHG_QTY)
                                , V_CHG_RSN
                                , V_CHG_TYPE
                                , P_USER_ID
                                , SYSDATE
                                , P_USER_ID
                                , SYSDATE
                                );

                ELSIF UPPER(V_ACTIVE_FLAG) = 'M' THEN

                    UPDATE SCP_OPMZ_DMD_ADJ
                       SET CHG_QTY = TO_NUMBER(V_CHG_QTY)
                         , CHG_RSN = V_CHG_RSN
                         , LAST_UPDATED_BY = P_USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND UPPER(VERSION_NO) = UPPER(V_VERSION_NO)
                       AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                       AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                       AND UPPER(SCM_SITE_ID) = UPPER(V_SALES_SITE_ID)
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND UPPER(FCST_TYPE) = UPPER(V_FCST_TYPE)
                       AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                       AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                       AND UPPER(CELL_PROD_SITE_ID) = UPPER(V_CELL_PROD_SITE_ID)
                       AND DUE_DATE = V_DUE_DATE;

                /* 삭제기능 추가 (2025-07-16) */
                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_OPMZ_DMD_ADJ
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND UPPER(VERSION_NO) = UPPER(V_VERSION_NO)
                       AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                       AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                       AND UPPER(SCM_SITE_ID) = UPPER(V_SALES_SITE_ID)
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND UPPER(FCST_TYPE) = UPPER(V_FCST_TYPE)
                       AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                       AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                       AND UPPER(CELL_PROD_SITE_ID) = UPPER(V_CELL_PROD_SITE_ID)
                       AND DUE_DATE = V_DUE_DATE;

                END IF;
            END LOOP;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_MAX_LOOP_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN E_BIZ THEN
            ROLLBACK TO SAVEPOINT SP_SCP0125_SAVE;     /* 입력 데이타 롤백 처리 */

            P_LOG_ERROR(V_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, NULL);

            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;

        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MSG  := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SAVEPOINT SP_SCP0125_SAVE;

            P_LOG_ERROR(V_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;
    END P_SCP0125_SAVE_MKT_FCST_ADJ;


    /* ==================================================================================================
       Elec. Demand 등록 · 수정 · 삭제
       ================================================================================================== */
    PROCEDURE P_SCP0125_SAVE_ELEC_DEMAND
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_PLAN_START_YYYYMMDD   IN  CLOB,
        P_PLAN_TYPE             IN  CLOB,
        P_SEQ                   IN  CLOB,
        P_PLANT_SITE_ID         IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_YYYYMMDD              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        C_DELIM                 CONSTANT VARCHAR2(1 CHAR) := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SCP0125.P_SCP0125_SAVE_ELEC_DEMAND';

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_PLAN_START_YYYYMMDD   T_TOKEN_TAB;
        T_PLAN_TYPE             T_TOKEN_TAB;
        T_SEQ                   T_TOKEN_TAB;
        T_PLANT_SITE_ID         T_TOKEN_TAB;
        T_LINE_ID               T_TOKEN_TAB;
        T_OPERATION_ID          T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_YYYYMMDD              T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_CHG_QTY               T_TOKEN_TAB;
        T_CHG_RSN               T_TOKEN_TAB;
        T_CHG_TYPE              T_TOKEN_TAB;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_DUMMY_CNT             PLS_INTEGER;
        V_EXISTS                PLS_INTEGER;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_PLAN_TYPE             VARCHAR2(4000 CHAR);
        V_SEQ                   VARCHAR2(4000 CHAR);
        V_PLANT_SITE_ID         VARCHAR2(4000 CHAR);
        V_LINE_ID               VARCHAR2(4000 CHAR);
        V_OPERATION_ID          VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_YYYYMMDD              VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_CHG_QTY               VARCHAR2(4000 CHAR);
        V_CHG_RSN               VARCHAR2(4000 CHAR);
        V_CHG_TYPE              VARCHAR2(4000 CHAR);

        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SCP0125_SAVE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT_TOKEN(P_ACTIVE_FLAG        , C_DELIM, T_ACTIVE_FLAG        , V_MAX_LOOP_CNT);
        P_SPLIT_TOKEN(P_DIVISION_ID        , C_DELIM, T_DIVISION_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLAN_START_YYYYMMDD, C_DELIM, T_PLAN_START_YYYYMMDD, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLAN_TYPE          , C_DELIM, T_PLAN_TYPE          , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SEQ                , C_DELIM, T_SEQ                , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLANT_SITE_ID      , C_DELIM, T_PLANT_SITE_ID      , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_LINE_ID            , C_DELIM, T_LINE_ID            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_OPERATION_ID       , C_DELIM, T_OPERATION_ID       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID            , C_DELIM, T_ITEM_ID            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_YYYYMMDD           , C_DELIM, T_YYYYMMDD           , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_QTY                , C_DELIM, T_QTY                , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_QTY            , C_DELIM, T_CHG_QTY            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_RSN            , C_DELIM, T_CHG_RSN            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_TYPE           , C_DELIM, T_CHG_TYPE           , V_DUMMY_CNT);

        IF NVL(LENGTH(RTRIM(DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 4000, 1))), 0) > 0 THEN

            WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
            LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                V_ACTIVE_FLAG         := F_TOKEN(T_ACTIVE_FLAG        , V_MST_LOOP_CNT);
                V_DIVISION_ID         := F_KEY  (T_DIVISION_ID        , V_MST_LOOP_CNT);
                V_PLAN_START_YYYYMMDD := F_KEY  (T_PLAN_START_YYYYMMDD, V_MST_LOOP_CNT);
                V_PLAN_TYPE           := F_KEY  (T_PLAN_TYPE          , V_MST_LOOP_CNT);
                V_SEQ                 := F_KEY  (T_SEQ                , V_MST_LOOP_CNT);
                V_PLANT_SITE_ID       := F_KEY  (T_PLANT_SITE_ID      , V_MST_LOOP_CNT);
                V_LINE_ID             := F_KEY  (T_LINE_ID            , V_MST_LOOP_CNT);
                V_OPERATION_ID        := F_KEY  (T_OPERATION_ID       , V_MST_LOOP_CNT);
                V_ITEM_ID             := F_KEY  (T_ITEM_ID            , V_MST_LOOP_CNT);
                V_YYYYMMDD            := F_KEY  (T_YYYYMMDD           , V_MST_LOOP_CNT);
                V_QTY                 := F_TOKEN(T_QTY                , V_MST_LOOP_CNT);
                V_CHG_QTY             := F_TOKEN(T_CHG_QTY            , V_MST_LOOP_CNT);
                V_CHG_RSN             := F_KEY  (T_CHG_RSN            , V_MST_LOOP_CNT);
                V_CHG_TYPE            := F_KEY  (T_CHG_TYPE           , V_MST_LOOP_CNT);

                IF UPPER(V_ACTIVE_FLAG) = 'I' THEN

                    IF UPPER(V_CHG_TYPE) = 'NEW' THEN

                        /* 최신 SEQ 구하기 - 없으면 '1' */
                        BEGIN
                            SELECT TO_CHAR(NVL(MAX(SEQ), 1))
                              INTO V_SEQ
                              FROM SCP_ANL_PRODUCTION_PLAN
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND PLAN_START_YYYYMMDD_DATE = TO_DATE(V_PLAN_START_YYYYMMDD DEFAULT NULL ON CONVERSION ERROR, 'YYYYMMDD')  /* 파티션 키 */
                               AND PLAN_TYPE = 'FN'
                             GROUP BY DIVISION_ID
                                    , PLAN_TYPE
                                    , PLAN_START_YYYYMMDD;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                V_SEQ := '1';
                        END;

                        /***** 중복체크 *****/
                        BEGIN
                            SELECT 1
                              INTO V_EXISTS
                              FROM SCP_OPMZ_DMD_ELEC
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND UPPER(PLAN_TYPE) = UPPER(V_PLAN_TYPE)
                               AND SEQ = V_SEQ
                               AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                               AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                               AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                               AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                               AND YYYYMMDD = V_YYYYMMDD
                               AND ROWNUM = 1;

                            V_ERR_CODE := '99010';
                            V_ERR_MSG  := ' 신규 입력 데이터 중 중복된 데이터가 있습니다.';
                            RAISE E_BIZ;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;
                        /***** 중복체크 *****/

                    END IF;

                    /* 대소문자만 다른 같은 키가 있으면 AS-IS 처럼 기본키 중복 (Oracle 기본키는 대소문자 구분) */
                    BEGIN
                        SELECT 1
                          INTO V_EXISTS
                          FROM SCP_OPMZ_DMD_ELEC
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND UPPER(PLAN_TYPE) = UPPER(V_PLAN_TYPE)
                               AND SEQ = V_SEQ
                               AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                               AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                               AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                               AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                               AND YYYYMMDD = V_YYYYMMDD
                           AND ROWNUM = 1;

                        RAISE DUP_VAL_ON_INDEX;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    INSERT INTO SCP_OPMZ_DMD_ELEC
                                (
                                  DIVISION_ID
                                , PLAN_START_YYYYMMDD
                                , PLAN_TYPE
                                , SEQ
                                , PLANT_SITE_ID
                                , LINE_ID
                                , OPERATION_ID
                                , ITEM_ID
                                , YYYYMMDD
                                , QTY
                                , CHG_QTY
                                , CHG_RSN
                                , CHG_TYPE
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                                )
                         VALUES (
                                  V_DIVISION_ID
                                , V_PLAN_START_YYYYMMDD
                                , V_PLAN_TYPE
                                , V_SEQ
                                , V_PLANT_SITE_ID
                                , V_LINE_ID
                                , V_OPERATION_ID
                                , V_ITEM_ID
                                , V_YYYYMMDD
                                , TO_NUMBER(V_QTY)
                                , TO_NUMBER(V_CHG_QTY)
                                , V_CHG_RSN
                                , V_CHG_TYPE
                                , P_USER_ID
                                , SYSDATE
                                , P_USER_ID
                                , SYSDATE
                                );

                ELSIF UPPER(V_ACTIVE_FLAG) = 'M' THEN

                    UPDATE SCP_OPMZ_DMD_ELEC
                       SET CHG_QTY = TO_NUMBER(V_CHG_QTY)
                         , CHG_RSN = V_CHG_RSN
                         , LAST_UPDATED_BY = P_USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND UPPER(PLAN_TYPE) = UPPER(V_PLAN_TYPE)
                       AND SEQ = V_SEQ
                       AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                       AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                       AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND YYYYMMDD = V_YYYYMMDD;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_OPMZ_DMD_ELEC
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND UPPER(PLAN_TYPE) = UPPER(V_PLAN_TYPE)
                       AND SEQ = V_SEQ
                       AND UPPER(PLANT_SITE_ID) = UPPER(V_PLANT_SITE_ID)
                       AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                       AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND YYYYMMDD = V_YYYYMMDD;

                END IF;
            END LOOP;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_MAX_LOOP_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN E_BIZ THEN
            ROLLBACK TO SAVEPOINT SP_SCP0125_SAVE;

            P_LOG_ERROR(V_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, NULL);

            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;

        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MSG  := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SAVEPOINT SP_SCP0125_SAVE;

            P_LOG_ERROR(V_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;
    END P_SCP0125_SAVE_ELEC_DEMAND;


    /* ==================================================================================================
       Stock 조정 등록 · 수정 · 삭제
       ================================================================================================== */
    PROCEDURE P_SCP0125_SAVE_STOCK_ADJ
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_STOCK_TYPE            IN  CLOB,
        P_CUTOFF_YYYYMMDD       IN  CLOB,
        P_PROJECT_CODE          IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_INCOTERMS             IN  CLOB,
        P_FROM_SITE_ID          IN  CLOB,
        P_SCM_SITE_ID           IN  CLOB,
        P_LOCATION_CODE         IN  CLOB,
        P_LINE_ID               IN  CLOB,
        P_BEFORE_DEGAS          IN  CLOB,
        P_INV_DATE              IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        C_DELIM                 CONSTANT VARCHAR2(1 CHAR) := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SCP0125.P_SCP0125_SAVE_STOCK_ADJ';

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_STOCK_TYPE            T_TOKEN_TAB;
        T_CUTOFF_YYYYMMDD       T_TOKEN_TAB;
        T_PROJECT_CODE          T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_INCOTERMS             T_TOKEN_TAB;
        T_FROM_SITE_ID          T_TOKEN_TAB;
        T_SCM_SITE_ID           T_TOKEN_TAB;
        T_LOCATION_CODE         T_TOKEN_TAB;
        T_LINE_ID               T_TOKEN_TAB;
        T_BEFORE_DEGAS          T_TOKEN_TAB;
        T_INV_DATE              T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_CHG_QTY               T_TOKEN_TAB;
        T_CHG_RSN               T_TOKEN_TAB;
        T_CHG_TYPE              T_TOKEN_TAB;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_DUMMY_CNT             PLS_INTEGER;
        V_EXISTS                PLS_INTEGER;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_STOCK_TYPE            VARCHAR2(4000 CHAR);
        V_CUTOFF_YYYYMMDD       VARCHAR2(4000 CHAR);
        V_PROJECT_CODE          VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_INCOTERMS             VARCHAR2(4000 CHAR);
        V_FROM_SITE_ID          VARCHAR2(4000 CHAR);
        V_SCM_SITE_ID           VARCHAR2(4000 CHAR);
        V_LOCATION_CODE         VARCHAR2(4000 CHAR);   /* [PJ20257329]Plant 재고 조회에 전극Plant 대상 LOCATION_CODE 제외 처리(2025-09-24) */
        V_LINE_ID               VARCHAR2(4000 CHAR);
        V_BEFORE_DEGAS          VARCHAR2(4000 CHAR);
        V_INV_DATE              VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_CHG_QTY               VARCHAR2(4000 CHAR);
        V_CHG_RSN               VARCHAR2(4000 CHAR);
        V_CHG_TYPE              VARCHAR2(4000 CHAR);

        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SCP0125_SAVE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT_TOKEN(P_ACTIVE_FLAG    , C_DELIM, T_ACTIVE_FLAG    , V_MAX_LOOP_CNT);
        P_SPLIT_TOKEN(P_DIVISION_ID    , C_DELIM, T_DIVISION_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_STOCK_TYPE     , C_DELIM, T_STOCK_TYPE     , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CUTOFF_YYYYMMDD, C_DELIM, T_CUTOFF_YYYYMMDD, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PROJECT_CODE   , C_DELIM, T_PROJECT_CODE   , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID        , C_DELIM, T_ITEM_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_INCOTERMS      , C_DELIM, T_INCOTERMS      , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_FROM_SITE_ID   , C_DELIM, T_FROM_SITE_ID   , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SCM_SITE_ID    , C_DELIM, T_SCM_SITE_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_LOCATION_CODE  , C_DELIM, T_LOCATION_CODE  , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_LINE_ID        , C_DELIM, T_LINE_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_BEFORE_DEGAS   , C_DELIM, T_BEFORE_DEGAS   , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_INV_DATE       , C_DELIM, T_INV_DATE       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_QTY            , C_DELIM, T_QTY            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_QTY        , C_DELIM, T_CHG_QTY        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_RSN        , C_DELIM, T_CHG_RSN        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_TYPE       , C_DELIM, T_CHG_TYPE       , V_DUMMY_CNT);

        IF NVL(LENGTH(RTRIM(DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 4000, 1))), 0) > 0 THEN

            WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
            LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                V_ACTIVE_FLAG     := F_TOKEN(T_ACTIVE_FLAG    , V_MST_LOOP_CNT);
                V_DIVISION_ID     := F_KEY  (T_DIVISION_ID    , V_MST_LOOP_CNT);
                V_STOCK_TYPE      := F_KEY  (T_STOCK_TYPE     , V_MST_LOOP_CNT);
                V_CUTOFF_YYYYMMDD := F_KEY  (T_CUTOFF_YYYYMMDD, V_MST_LOOP_CNT);
                V_PROJECT_CODE    := F_KEY  (T_PROJECT_CODE   , V_MST_LOOP_CNT);
                V_ITEM_ID         := F_KEY  (T_ITEM_ID        , V_MST_LOOP_CNT);
                V_INCOTERMS       := F_KEY  (T_INCOTERMS      , V_MST_LOOP_CNT);
                V_FROM_SITE_ID    := F_KEY  (T_FROM_SITE_ID   , V_MST_LOOP_CNT);
                V_SCM_SITE_ID     := F_KEY  (T_SCM_SITE_ID    , V_MST_LOOP_CNT);
                V_LOCATION_CODE   := F_KEY  (T_LOCATION_CODE  , V_MST_LOOP_CNT);
                V_LINE_ID         := F_KEY  (T_LINE_ID        , V_MST_LOOP_CNT);
                V_BEFORE_DEGAS    := F_KEY  (T_BEFORE_DEGAS   , V_MST_LOOP_CNT);
                V_INV_DATE        := F_KEY  (T_INV_DATE       , V_MST_LOOP_CNT);
                V_QTY             := F_TOKEN(T_QTY            , V_MST_LOOP_CNT);
                V_CHG_QTY         := F_TOKEN(T_CHG_QTY        , V_MST_LOOP_CNT);
                V_CHG_RSN         := F_KEY  (T_CHG_RSN        , V_MST_LOOP_CNT);
                V_CHG_TYPE        := F_KEY  (T_CHG_TYPE       , V_MST_LOOP_CNT);

                IF UPPER(V_ACTIVE_FLAG) = 'I' THEN

                    /* 대소문자만 다른 같은 키가 있으면 AS-IS 처럼 기본키 중복 (Oracle 기본키는 대소문자 구분) */
                    BEGIN
                        SELECT 1
                          INTO V_EXISTS
                          FROM SCP_OPMZ_INV_ADJ
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND UPPER(STOCK_TYPE) = UPPER(V_STOCK_TYPE)
                               AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                               AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                               AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                               AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                               AND UPPER(FROM_SITE_ID) = UPPER(V_FROM_SITE_ID)
                               AND UPPER(SCM_SITE_ID) = UPPER(V_SCM_SITE_ID)
                               AND UPPER(LOCATION_CODE) = UPPER(V_LOCATION_CODE)
                               AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                               AND UPPER(BEFORE_DEGAS) = UPPER(V_BEFORE_DEGAS)
                               AND INV_DATE = V_INV_DATE
                           AND ROWNUM = 1;

                        RAISE DUP_VAL_ON_INDEX;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    INSERT INTO SCP_OPMZ_INV_ADJ
                                (
                                  DIVISION_ID
                                , SRCE_DIVS_CD
                                , CUTOFF_YYYYMMDD
                                , STOCK_TYPE
                                , PROJECT_CODE
                                , ITEM_ID
                                , FCST_TYPE
                                , INCOTERMS
                                , FROM_SITE_ID
                                , SCM_SITE_ID
                                , LOCATION_CODE
                                , LINE_ID
                                , BEFORE_DEGAS
                                , INV_DATE
                                , QTY
                                , CHG_QTY
                                , CHG_RSN
                                , CHG_TYPE
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                                )
                         VALUES (
                                  V_DIVISION_ID
                                , V_STOCK_TYPE              /* SRCE_DIVS_CD */
                                , V_CUTOFF_YYYYMMDD
                                , V_STOCK_TYPE
                                , V_PROJECT_CODE
                                , V_ITEM_ID
                                , '-'                       /* FCST_TYPE */
                                , V_INCOTERMS
                                , V_FROM_SITE_ID
                                , V_SCM_SITE_ID
                                , V_LOCATION_CODE
                                , V_LINE_ID
                                , V_BEFORE_DEGAS
                                , V_INV_DATE
                                , TO_NUMBER(V_QTY)
                                , TO_NUMBER(V_CHG_QTY)
                                , V_CHG_RSN
                                , V_CHG_TYPE
                                , P_USER_ID
                                , SYSDATE
                                , P_USER_ID
                                , SYSDATE
                                );

                ELSIF UPPER(V_ACTIVE_FLAG) = 'M' THEN

                    UPDATE SCP_OPMZ_INV_ADJ
                       SET CHG_QTY = TO_NUMBER(V_CHG_QTY)
                         , CHG_RSN = V_CHG_RSN
                         , LAST_UPDATED_BY = P_USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND UPPER(STOCK_TYPE) = UPPER(V_STOCK_TYPE)
                       AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                       AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                       AND UPPER(FROM_SITE_ID) = UPPER(V_FROM_SITE_ID)
                       AND UPPER(SCM_SITE_ID) = UPPER(V_SCM_SITE_ID)
                       AND UPPER(LOCATION_CODE) = UPPER(V_LOCATION_CODE)
                       AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                       AND UPPER(BEFORE_DEGAS) = UPPER(V_BEFORE_DEGAS)
                       AND INV_DATE = V_INV_DATE;

                /* 삭제기능 추가 (2025-07-16) */
                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_OPMZ_INV_ADJ
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND UPPER(STOCK_TYPE) = UPPER(V_STOCK_TYPE)
                       AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                       AND UPPER(PROJECT_CODE) = UPPER(V_PROJECT_CODE)
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND UPPER(INCOTERMS) = UPPER(V_INCOTERMS)
                       AND UPPER(FROM_SITE_ID) = UPPER(V_FROM_SITE_ID)
                       AND UPPER(SCM_SITE_ID) = UPPER(V_SCM_SITE_ID)
                       AND UPPER(LOCATION_CODE) = UPPER(V_LOCATION_CODE)
                       AND UPPER(LINE_ID) = UPPER(V_LINE_ID)
                       AND UPPER(BEFORE_DEGAS) = UPPER(V_BEFORE_DEGAS)
                       AND INV_DATE = V_INV_DATE;

                END IF;
            END LOOP;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_MAX_LOOP_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MSG  := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SAVEPOINT SP_SCP0125_SAVE;

            P_LOG_ERROR(V_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;
    END P_SCP0125_SAVE_STOCK_ADJ;


    /* ==================================================================================================
       Stock(2nd OCV) 등록 · 수정 · 삭제
       ================================================================================================== */
    PROCEDURE P_SCP0125_SAVE_STOCK_2ND_OCV
    (
        P_ACTIVE_FLAG           IN  CLOB,
        P_DIVISION_ID           IN  CLOB,
        P_STOCK_TYPE            IN  CLOB,
        P_CUTOFF_YYYYMMDD       IN  CLOB,
        P_ITEM_ID               IN  CLOB,
        P_PLANT_ID              IN  CLOB,
        P_OPERATION_ID          IN  CLOB,
        P_SECOND_OCV_TIME       IN  CLOB,
        P_SECOND_OCV_DATE       IN  CLOB,
        P_QTY                   IN  CLOB,
        P_CHG_QTY               IN  CLOB,
        P_CHG_RSN               IN  CLOB,
        P_CHG_TYPE              IN  CLOB,
        P_USER_ID               IN  VARCHAR2,
        O_RESULT_CODE           OUT VARCHAR2,
        O_RESULT_CNT            OUT NUMBER,
        O_RESULT_MSG            OUT VARCHAR2
    )
    IS
        C_DELIM                 CONSTANT VARCHAR2(1 CHAR) := '^';
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SCP0125.P_SCP0125_SAVE_STOCK_2ND_OCV';

        T_ACTIVE_FLAG           T_TOKEN_TAB;
        T_DIVISION_ID           T_TOKEN_TAB;
        T_STOCK_TYPE            T_TOKEN_TAB;
        T_CUTOFF_YYYYMMDD       T_TOKEN_TAB;
        T_ITEM_ID               T_TOKEN_TAB;
        T_PLANT_ID              T_TOKEN_TAB;
        T_OPERATION_ID          T_TOKEN_TAB;
        T_SECOND_OCV_TIME       T_TOKEN_TAB;
        T_SECOND_OCV_DATE       T_TOKEN_TAB;
        T_QTY                   T_TOKEN_TAB;
        T_CHG_QTY               T_TOKEN_TAB;
        T_CHG_RSN               T_TOKEN_TAB;
        T_CHG_TYPE              T_TOKEN_TAB;

        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_DUMMY_CNT             PLS_INTEGER;
        V_EXISTS                PLS_INTEGER;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_STOCK_TYPE            VARCHAR2(4000 CHAR);
        V_CUTOFF_YYYYMMDD       VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_PLANT_ID              VARCHAR2(4000 CHAR);
        V_OPERATION_ID          VARCHAR2(4000 CHAR);
        V_SECOND_OCV_TIME       VARCHAR2(4000 CHAR);
        V_SECOND_OCV_DATE       VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_CHG_QTY               VARCHAR2(4000 CHAR);
        V_CHG_RSN               VARCHAR2(4000 CHAR);
        V_CHG_TYPE              VARCHAR2(4000 CHAR);

        V_ERR_CODE              VARCHAR2(100 CHAR);
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SCP0125_SAVE;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);

        P_SPLIT_TOKEN(P_ACTIVE_FLAG    , C_DELIM, T_ACTIVE_FLAG    , V_MAX_LOOP_CNT);
        P_SPLIT_TOKEN(P_DIVISION_ID    , C_DELIM, T_DIVISION_ID    , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_STOCK_TYPE     , C_DELIM, T_STOCK_TYPE     , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CUTOFF_YYYYMMDD, C_DELIM, T_CUTOFF_YYYYMMDD, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_ITEM_ID        , C_DELIM, T_ITEM_ID        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_PLANT_ID       , C_DELIM, T_PLANT_ID       , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_OPERATION_ID   , C_DELIM, T_OPERATION_ID   , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SECOND_OCV_TIME, C_DELIM, T_SECOND_OCV_TIME, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_SECOND_OCV_DATE, C_DELIM, T_SECOND_OCV_DATE, V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_QTY            , C_DELIM, T_QTY            , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_QTY        , C_DELIM, T_CHG_QTY        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_RSN        , C_DELIM, T_CHG_RSN        , V_DUMMY_CNT);
        P_SPLIT_TOKEN(P_CHG_TYPE       , C_DELIM, T_CHG_TYPE       , V_DUMMY_CNT);

        IF NVL(LENGTH(RTRIM(DBMS_LOB.SUBSTR(P_ACTIVE_FLAG, 4000, 1))), 0) > 0 THEN

            WHILE V_MST_LOOP_CNT < V_MAX_LOOP_CNT
            LOOP
                V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

                V_ACTIVE_FLAG     := F_TOKEN(T_ACTIVE_FLAG    , V_MST_LOOP_CNT);
                V_DIVISION_ID     := F_KEY  (T_DIVISION_ID    , V_MST_LOOP_CNT);
                V_STOCK_TYPE      := F_KEY  (T_STOCK_TYPE     , V_MST_LOOP_CNT);
                V_CUTOFF_YYYYMMDD := F_KEY  (T_CUTOFF_YYYYMMDD, V_MST_LOOP_CNT);
                V_ITEM_ID         := F_KEY  (T_ITEM_ID        , V_MST_LOOP_CNT);
                V_PLANT_ID        := F_KEY  (T_PLANT_ID       , V_MST_LOOP_CNT);
                V_OPERATION_ID    := F_KEY  (T_OPERATION_ID   , V_MST_LOOP_CNT);
                V_SECOND_OCV_TIME := F_KEY  (T_SECOND_OCV_TIME, V_MST_LOOP_CNT);
                V_SECOND_OCV_DATE := F_KEY  (T_SECOND_OCV_DATE, V_MST_LOOP_CNT);
                V_QTY             := F_TOKEN(T_QTY            , V_MST_LOOP_CNT);
                V_CHG_QTY         := F_TOKEN(T_CHG_QTY        , V_MST_LOOP_CNT);
                V_CHG_RSN         := F_KEY  (T_CHG_RSN        , V_MST_LOOP_CNT);
                V_CHG_TYPE        := F_KEY  (T_CHG_TYPE       , V_MST_LOOP_CNT);

                IF UPPER(V_ACTIVE_FLAG) = 'I' THEN

                    /* 대소문자만 다른 같은 키가 있으면 AS-IS 처럼 기본키 중복 (Oracle 기본키는 대소문자 구분) */
                    BEGIN
                        SELECT 1
                          INTO V_EXISTS
                          FROM SCP_OPMZ_INV_SECOND_OCV
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND UPPER(STOCK_TYPE) = UPPER(V_STOCK_TYPE)
                               AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                               AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                               AND UPPER(PLANT_ID) = UPPER(V_PLANT_ID)
                               AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                               AND UPPER(SECOND_OCV_TIME) = UPPER(V_SECOND_OCV_TIME)
                               AND SECOND_OCV_DATE = V_SECOND_OCV_DATE
                           AND ROWNUM = 1;

                        RAISE DUP_VAL_ON_INDEX;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    INSERT INTO SCP_OPMZ_INV_SECOND_OCV
                                (
                                  DIVISION_ID
                                , CUTOFF_YYYYMMDD
                                , STOCK_TYPE
                                , ITEM_ID
                                , PLANT_ID
                                , OPERATION_ID
                                , SECOND_OCV_TIME
                                , SECOND_OCV_DATE
                                , QTY
                                , CHG_QTY
                                , CHG_RSN
                                , CHG_TYPE
                                , CREATED_BY
                                , CREATION_DATE
                                , LAST_UPDATED_BY
                                , LAST_UPDATE_DATE
                                )
                         VALUES (
                                  V_DIVISION_ID
                                , V_CUTOFF_YYYYMMDD
                                , V_STOCK_TYPE
                                , V_ITEM_ID
                                , V_PLANT_ID
                                , V_OPERATION_ID
                                , V_SECOND_OCV_TIME
                                , V_SECOND_OCV_DATE
                                , TO_NUMBER(V_QTY)
                                , TO_NUMBER(V_CHG_QTY)
                                , V_CHG_RSN
                                , V_CHG_TYPE
                                , P_USER_ID
                                , SYSDATE
                                , P_USER_ID
                                , SYSDATE
                                );

                ELSIF UPPER(V_ACTIVE_FLAG) = 'M' THEN

                    UPDATE SCP_OPMZ_INV_SECOND_OCV
                       SET CHG_QTY = TO_NUMBER(V_CHG_QTY)
                         , CHG_RSN = V_CHG_RSN
                         , LAST_UPDATED_BY = P_USER_ID
                         , LAST_UPDATE_DATE = SYSDATE
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND UPPER(STOCK_TYPE) = UPPER(V_STOCK_TYPE)
                       AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND UPPER(PLANT_ID) = UPPER(V_PLANT_ID)
                       AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                       AND UPPER(SECOND_OCV_TIME) = UPPER(V_SECOND_OCV_TIME)
                       AND SECOND_OCV_DATE = V_SECOND_OCV_DATE;

                ELSIF UPPER(V_ACTIVE_FLAG) = 'D' THEN

                    DELETE
                      FROM SCP_OPMZ_INV_SECOND_OCV
                     WHERE DIVISION_ID = V_DIVISION_ID
                       AND UPPER(STOCK_TYPE) = UPPER(V_STOCK_TYPE)
                       AND CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                       AND UPPER(ITEM_ID) = UPPER(V_ITEM_ID)
                       AND UPPER(PLANT_ID) = UPPER(V_PLANT_ID)
                       AND UPPER(OPERATION_ID) = UPPER(V_OPERATION_ID)
                       AND UPPER(SECOND_OCV_TIME) = UPPER(V_SECOND_OCV_TIME)
                       AND SECOND_OCV_DATE = V_SECOND_OCV_DATE;

                END IF;
            END LOOP;

        END IF;

        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', NULL, SYSDATE);

        COMMIT;

        O_RESULT_CODE := 'S';
        O_RESULT_CNT  := V_MAX_LOOP_CNT;
        O_RESULT_MSG  := NULL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_CODE := TO_CHAR(SQLCODE);
            V_ERR_MSG  := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SAVEPOINT SP_SCP0125_SAVE;

            P_LOG_ERROR(V_PROGRAM_NAME, 'P_USER_ID=' || P_USER_ID || ', ROW=' || V_MST_LOOP_CNT, V_ERR_CODE, V_ERR_MSG, DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);

            O_RESULT_CODE := 'F';
            O_RESULT_CNT  := NULL;
            O_RESULT_MSG  := '[' || V_ERR_CODE || ']' || V_ERR_MSG;
    END P_SCP0125_SAVE_STOCK_2ND_OCV;

END PKG_SCP0125;