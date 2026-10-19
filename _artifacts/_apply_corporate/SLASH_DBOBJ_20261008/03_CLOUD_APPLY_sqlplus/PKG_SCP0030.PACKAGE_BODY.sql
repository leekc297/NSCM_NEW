-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SCP0030 — 사내 현재 원문(적용본, 사내 LAST_DDL 2026-10-08 16:50:55, 975줄)
CREATE OR REPLACE PACKAGE BODY PKG_SCP0030
IS

    /* =========================================================================================
     * 쉼표 목록 분리 (AS-IS dbo.String_Split : 토큰 앞뒤 공백 제거, 빈 토큰 유지)
     *   P_KEEP_EMPTY = 'Y' : 빈 토큰도 원소로 남김(NULL). 입력이 NULL 이면 빈 토큰 1개
     *   P_KEEP_EMPTY = 'N' : 빈 토큰 제외 (IN 목록 비교용 — 빈 문자열과 같은 값이 원장에 없음)
     *   대소문자 무시 비교(AS-IS 정렬 규칙 Latin1_General_CI_AS)를 위해 대문자로 반환
     * ========================================================================================= */
    FUNCTION F_SPLIT_LIST
    (
        P_STR         IN VARCHAR2
      , P_KEEP_EMPTY  IN VARCHAR2
    )
    RETURN T_STR_TAB
    IS
        V_TAB    T_STR_TAB := T_STR_TAB();
        V_POS    PLS_INTEGER := 1;
        V_IDX    PLS_INTEGER;
        V_TOKEN  VARCHAR2(4000);
    BEGIN
        IF P_STR IS NULL THEN
            IF P_KEEP_EMPTY = 'Y' THEN
                V_TAB.EXTEND;
                V_TAB(V_TAB.COUNT) := NULL;
            END IF;
            RETURN V_TAB;
        END IF;

        LOOP
            V_IDX := INSTR(P_STR, ',', V_POS);
            IF V_IDX = 0 THEN
                V_TOKEN := SUBSTR(P_STR, V_POS);
            ELSE
                V_TOKEN := SUBSTR(P_STR, V_POS, V_IDX - V_POS);
            END IF;
            V_TOKEN := UPPER(TRIM(V_TOKEN));

            IF V_TOKEN IS NOT NULL OR P_KEEP_EMPTY = 'Y' THEN
                V_TAB.EXTEND;
                V_TAB(V_TAB.COUNT) := V_TOKEN;
            END IF;

            EXIT WHEN V_IDX = 0;
            V_POS := V_IDX + 1;
        END LOOP;

        RETURN V_TAB;
    END F_SPLIT_LIST;

    /* =========================================================================================
     * 목록 조건 사용 여부 : AS-IS IF NOT(@p IS NULL OR @p = '') — 공백만 입력도 조건 없음
     *   화면 전체 선택값 'ALL' 도 조건 없음 (AS-IS 화면은 전체 선택 시 목록 전체 코드를 전달)
     * ========================================================================================= */
    FUNCTION F_USE_LIST
    (
        P_STR  IN VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF TRIM(P_STR) IS NULL OR UPPER(TRIM(P_STR)) = 'ALL' THEN
            RETURN 'N';
        END IF;
        RETURN 'Y';
    END F_USE_LIST;

    /* =========================================================================================
     * 저장 날짜 값 정리 : AS-IS 화면이 그리드 날짜를 Replace("-","").Substring(0,8) 로 보냄
     *   조회 결과(DATE)가 문자열로 되돌아오는 형식(YYYY-MM-DD …)과 YYYYMMDD 를 모두 받음
     * ========================================================================================= */
    FUNCTION F_TO_YYYYMMDD
    (
        P_VAL  IN VARCHAR2
    )
    RETURN VARCHAR2
    IS
    BEGIN
        IF REGEXP_LIKE(P_VAL, '^[0-9]{4}-[0-9]{2}-[0-9]{2}') THEN
            RETURN SUBSTR(REPLACE(P_VAL, '-', ''), 1, 8);
        END IF;
        RETURN P_VAL;
    END F_TO_YYYYMMDD;

    /* =========================================================================================
     * 정수 칸 형변환 : AS-IS nvarchar → int 암묵 변환 (빈 문자열 = 0, 정수 형식 아니면 오류)
     * ========================================================================================= */
    FUNCTION F_TO_INT
    (
        P_VAL  IN VARCHAR2
    )
    RETURN NUMBER
    IS
    BEGIN
        IF P_VAL IS NULL THEN
            RETURN 0;
        END IF;
        IF NOT REGEXP_LIKE(P_VAL, '^[+-]?[0-9]+$') THEN
            RAISE_APPLICATION_ERROR(-20245, 'Conversion failed when converting the nvarchar value ''' || P_VAL || ''' to data type int.');
        END IF;
        RETURN TO_NUMBER(P_VAL);
    END F_TO_INT;

    /* =========================================================================================
     * 소수 칸 형변환 : AS-IS nvarchar → numeric 암묵 변환 (빈 문자열·숫자 형식 아니면 오류)
     *   P_EXISTS = 'N' (값 자체가 없음) 이면 NULL — AS-IS SCM_ARR_SPL_VAL 토큰 부족과 같음
     * ========================================================================================= */
    FUNCTION F_TO_DEC
    (
        P_VAL     IN VARCHAR2
      , P_EXISTS  IN VARCHAR2
    )
    RETURN NUMBER
    IS
    BEGIN
        IF P_EXISTS = 'N' THEN
            RETURN NULL;
        END IF;
        IF P_VAL IS NULL OR NOT REGEXP_LIKE(P_VAL, '^[+-]?([0-9]+\.?[0-9]*|\.[0-9]+)$') THEN
            RAISE_APPLICATION_ERROR(-20814, 'Error converting data type nvarchar to numeric.');
        END IF;
        RETURN TO_NUMBER(P_VAL);
    END F_TO_DEC;

    /* =========================================================================================
     * BOD ITEM 이력 적재 (AS-IS PR_SCP_MST_BOD_ITEM_HIST — SCP0030 저장 전용, 패키지 내부 흡수)
     * ========================================================================================= */
    PROCEDURE P_SCP_MST_BOD_ITEM_HIST
    (
        P_SEQ               IN NUMBER
      , P_BOD_ID            IN VARCHAR2
      , P_DIVISION_ID       IN VARCHAR2
      , P_ITEM_ID           IN VARCHAR2
      , P_PRIORITY          IN NUMBER
      , P_FROM_YYYYMMDD     IN VARCHAR2
      , P_TO_YYYYMMDD       IN VARCHAR2
      , P_SAFETY_STOCK      IN NUMBER
      , P_VALID_YN          IN VARCHAR2
      , P_CREATED_BY        IN VARCHAR2
      , P_CREATION_DATE     IN DATE
      , P_LAST_UPDATED_BY   IN VARCHAR2
      , P_LAST_UPDATE_DATE  IN DATE
    )
    IS
    BEGIN
        INSERT
          INTO SCP_MST_BOD_ITEM_H
             ( HISTORY_SEQ
             , SEQ
             , DIVISION_ID
             , BOD_ID
             , ITEM_ID
             , PRIORITY
             , FROM_YYYYMMDD
             , TO_YYYYMMDD
             , SAFETY_STOCK
             , VALID_YN
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , HISTORY_CREATION_DATE
             )
        VALUES
             ( SEQ1_SCP_MST_BOD_ITEM_H.NEXTVAL
             , P_SEQ
             , P_DIVISION_ID
             , P_BOD_ID
             , P_ITEM_ID
             , P_PRIORITY
             , P_FROM_YYYYMMDD
             , P_TO_YYYYMMDD
             , P_SAFETY_STOCK
             , P_VALID_YN
             , P_CREATED_BY
             , P_CREATION_DATE
             , P_LAST_UPDATED_BY
             , P_LAST_UPDATE_DATE
             , SYSDATE
             );
    END P_SCP_MST_BOD_ITEM_HIST;

    /* =========================================================================================
     * BOD ITEM 조회 (AS-IS SCP0030_GET_BOD_ITEM)
     *   AS-IS 동적 SQL(조건별 문자열 조립) → 조건 사용 여부 변수로 정적 SQL
     *   AS-IS #TblDynamicPivot_SCP0030_Inactive(dbo.FN_GET_SCP_ITEM_INACTIVE) →
     *     조회 사업부의 (사업부, 품목) 중 ACTIVE_FLAG 가 N 만 있는 품목을 NOT EXISTS 로 제외
     *     2026.10.06 AJS NOT EXISTS → 외부조인 + IS NULL 로 변경(품목마다 반복 조회 제거, 결과 동일)
     *     (AS-IS 함수는 품목 인자를 쓰지 않음 · 사업부 인자가 비면 제외 대상 없음)
     *   사이트 키 비교는 대문자로(AS-IS 대소문자 무시 — 대소문자만 다른 사이트 ID 3쌍 존재)
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * ========================================================================================= */
    PROCEDURE P_SCP0030_GET_BOD_ITEM
    (
        P_DIVISION_ID     IN  VARCHAR2
      , P_FROM_SITE       IN  VARCHAR2
      , P_TO_SITE         IN  VARCHAR2
      , P_INCOTERMS       IN  VARCHAR2
      , P_TRANS_MODE      IN  VARCHAR2
      , P_ITEM_ID         IN  VARCHAR2
      , P_NICK_NAME       IN  VARCHAR2
      , P_VALID           IN  VARCHAR2
      , P_USER_ID         IN  VARCHAR2
      , P_MENU_ID         IN  VARCHAR2
      , O_RC1             OUT SYS_REFCURSOR
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_DIV_USE      VARCHAR2(1)   := F_USE_LIST(P_DIVISION_ID);
        V_FROM_USE     VARCHAR2(1)   := F_USE_LIST(P_FROM_SITE);
        V_TO_USE       VARCHAR2(1)   := F_USE_LIST(P_TO_SITE);
        V_INCO_USE     VARCHAR2(1)   := F_USE_LIST(P_INCOTERMS);
        V_TRANS_USE    VARCHAR2(1)   := F_USE_LIST(P_TRANS_MODE);
        V_ITEM_USE     VARCHAR2(1)   := F_USE_LIST(P_ITEM_ID);
        V_DIV_TAB      T_STR_TAB     := F_SPLIT_LIST(P_DIVISION_ID, 'N');
        V_FROM_TAB     T_STR_TAB     := F_SPLIT_LIST(P_FROM_SITE, 'N');
        V_TO_TAB       T_STR_TAB     := F_SPLIT_LIST(P_TO_SITE, 'N');
        V_INCO_TAB     T_STR_TAB     := F_SPLIT_LIST(P_INCOTERMS, 'N');
        V_TRANS_TAB    T_STR_TAB     := F_SPLIT_LIST(P_TRANS_MODE, 'N');
        V_ITEM_TAB     T_STR_TAB     := F_SPLIT_LIST(P_ITEM_ID, 'N');
        V_EXC_MODE     VARCHAR2(1);
        V_VALID        VARCHAR2(4 CHAR);
        V_NICK_NAME    VARCHAR2(4000);
    BEGIN
        /* 비활성 품목 제외 범위 : N = 없음(사업부 미입력) · A = 전체 사업부('ALL') · L = 입력 사업부 */
        V_EXC_MODE := CASE WHEN TRIM(P_DIVISION_ID) IS NULL THEN 'N'
                           WHEN UPPER(TRIM(P_DIVISION_ID)) = 'ALL' THEN 'A'
                           ELSE 'L'
                      END;

        /* AS-IS @p_valid NVARCHAR(1) — 첫 글자만 비교 */
        V_VALID := CASE WHEN UPPER(TRIM(P_VALID)) = 'ALL' THEN NULL
                        ELSE UPPER(TRIM(SUBSTR(P_VALID, 1, 1)))
                   END;

        /* AS-IS LIKE '%' + @p_nick_name + '%' (공백만 입력이면 조건 없음) */
        V_NICK_NAME := CASE WHEN TRIM(P_NICK_NAME) IS NULL
                              OR UPPER(TRIM(P_NICK_NAME)) = 'ALL' THEN NULL   /* 조회조건 ALL 은 조건 없음 */
                            ELSE UPPER(P_NICK_NAME)
                       END;

        OPEN O_RC1 FOR
        SELECT IA.SEQ
             , IA.DIVISION_ID
             , IA.CUSTOMER
             , IA.FROM_SITE_CODE
             , IA.FROM_CITY
             , IA.TO_SITE_CODE
             , IA.TO_CITY
             , IA.INCOTERMS
             , IA.SAFETY_STOCK
             , IA.TRANSPORT_MODE
             , IA.ITEM_ID
             , IA.NICK_NAME
             , IA.FROM_YYYYMMDD
             , IA.TO_YYYYMMDD
             , IA.PRIORITY
             , IA.BOD_ITEM_VALID
             , IA.BOD_VALID
             , IA.ROUTE_VALID
             , IA.ROUTE_ID
             , IA.DAYS_MON
             , IA.DAYS_TUE
             , IA.DAYS_WED
             , IA.DAYS_THU
             , IA.DAYS_FRI
             , IA.DAYS_SAT
             , IA.DAYS_SUN
             , IA.LEAD_TIME
             , IA.CREATED_BY
             , IA.CREATION_DATE
             , IA.LAST_UPDATED_BY
             , IA.LAST_UPDATE_DATE
             , IA.BOD_ID
             , IA.ORG_FROM_YYYYMMDD
             , IA.ORG_TO_YYYYMMDD
             , IA.MERGE_DATE
             , CAST(NULL AS VARCHAR2(1000 CHAR)) AS Y          /* AS-IS W.ACTIVE_FLAG — 제외 조건상 항상 NULL */
             , IA.COMPANY_ID
          FROM (SELECT DISTINCT
                       A.SEQ
                     , A.DIVISION_ID
                     , NVL(D.END_CUSTOMER, '-') AS CUSTOMER
                     , B.FROM_SITE AS FROM_SITE_CODE
                     , XB.COMPANY_ID
                     , E.CITY AS FROM_CITY
                     , B.TO_SITE AS TO_SITE_CODE
                     , XA.CITY AS TO_CITY
                     , B.INCOTERMS
                     , A.SAFETY_STOCK
                     , C.TRANSPORT_MODE
                     , A.ITEM_ID
                     , NVL(XC.NICK_NAME, '-') AS NICK_NAME
                     , TO_DATE(A.FROM_YYYYMMDD, 'YYYYMMDD') AS FROM_YYYYMMDD
                     , TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD') AS TO_YYYYMMDD
                     , A.PRIORITY
                     , A.VALID_YN AS BOD_ITEM_VALID
                     , B.VALID_YN AS BOD_VALID
                     , C.VALID_YN AS ROUTE_VALID
                     , C.ROUTE_ID
                     , C.DAYS_MON
                     , C.DAYS_TUE
                     , C.DAYS_WED
                     , C.DAYS_THU
                     , C.DAYS_FRI
                     , C.DAYS_SAT
                     , C.DAYS_SUN
                     , XD.LT_TOTAL AS LEAD_TIME
                    -- 2025.04.07 kimcd PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 - LEAD TIME 조회 안 되어서 SCP_MST_BOD_V를 SCP_MST_BOD_N_V 로 변경
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , B.BOD_ID
                     , A.FROM_YYYYMMDD AS ORG_FROM_YYYYMMDD
                     , A.TO_YYYYMMDD AS ORG_TO_YYYYMMDD
                     , A.FROM_YYYYMMDD || A.TO_YYYYMMDD AS MERGE_DATE
                  FROM SCP_MST_BOD_ITEM A
                     , SCP_MST_BOD B
                     , SCP_MST_DISTRIBUTION_ROUTE C
                     , SCM_MST_SITE D                                  /* 고객 : 품목 사업부 + 도착 사이트 */
                     , SCM_MST_SITE E                                  /* 출발 도시 : 품목 사업부 + 출발 사이트 */
                     , (SELECT DISTINCT
                               UPPER(SCM_SITE_ID) AS SITE_KEY
                             , CITY
                          FROM SCM_MST_SITE
                       ) XA                                            /* 도착 도시 */
                     , (SELECT UPPER(SCM_SITE_ID) AS SITE_KEY
                             , MAX(COMPANY_ID) AS COMPANY_ID
                          FROM SCM_MST_SITE
                         GROUP BY UPPER(SCM_SITE_ID)
                       ) XB                                            /* 출발 사이트 법인 */
                     , (SELECT ITEM_ID
                             , MAX(NICK_NAME) AS NICK_NAME
                          FROM SCM_MST_ITEM_SN
                         WHERE NICK_NAME IS NOT NULL
                         GROUP BY ITEM_ID
                       ) XC                                            /* 품목 별칭 (품목별 별칭 1종) */
                     , (SELECT DIVISION_ID
                             , BOD_ID
                             , LT_TOTAL
                             , ROWNUM AS RN
                          FROM SCP_MST_BOD_N_V
                       ) XD                                            /* 리드타임 (사업부 + BOD 유일) — 행마다 뷰 재계산 방지(ROWNUM) */
                 WHERE A.BOD_ID = B.BOD_ID
                   AND B.ROUTE_ID = C.ROUTE_ID(+)
                   AND A.DIVISION_ID = D.DIVISION_ID(+)
                   AND UPPER(B.TO_SITE) = UPPER(D.SCM_SITE_ID(+))
                   AND A.DIVISION_ID = E.DIVISION_ID(+)
                   AND UPPER(B.FROM_SITE) = UPPER(E.SCM_SITE_ID(+))
                   AND UPPER(B.TO_SITE) = XA.SITE_KEY(+)
                   AND UPPER(B.FROM_SITE) = XB.SITE_KEY(+)
                   AND A.ITEM_ID = XC.ITEM_ID(+)
                   AND B.DIVISION_ID = XD.DIVISION_ID(+)
                   AND B.BOD_ID = XD.BOD_ID(+)
                   AND (V_DIV_USE = 'N' OR A.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_DIV_TAB)))
                   AND (V_FROM_USE = 'N' OR UPPER(B.FROM_SITE) IN (SELECT COLUMN_VALUE FROM TABLE(V_FROM_TAB)))
                   AND (V_TO_USE = 'N' OR UPPER(B.TO_SITE) IN (SELECT COLUMN_VALUE FROM TABLE(V_TO_TAB)))
                   AND (V_INCO_USE = 'N' OR UPPER(B.INCOTERMS) IN (SELECT COLUMN_VALUE FROM TABLE(V_INCO_TAB)))
                   AND (V_TRANS_USE = 'N' OR UPPER(C.TRANSPORT_MODE) IN (SELECT COLUMN_VALUE FROM TABLE(V_TRANS_TAB)))
                   /* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                 AND (V_ITEM_USE = 'N' OR UPPER(A.ITEM_ID) IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                   AND (V_ITEM_USE = 'N'
                        OR EXISTS (SELECT 1
                                     FROM TABLE(V_ITEM_TAB) SA
                                    WHERE UPPER(A.ITEM_ID)   LIKE '%' || SA.COLUMN_VALUE || '%'
                                       OR UPPER(XC.NICK_NAME) LIKE '%' || SA.COLUMN_VALUE || '%'))
                   /* 2026.10.07 AJS Model/Nickname 검색 (END) */
                   AND (V_VALID IS NULL OR UPPER(A.VALID_YN) = V_VALID)
               ) IA
         /* 2026.10.06 AJS 비활성 품목 제외 성능 개선 (START) : 품목마다 반복하던 NOT EXISTS → AS-IS 와 같은 외부조인 + IS NULL (결과 동일) */
--         WHERE NOT EXISTS (SELECT 1
--                             FROM (SELECT SA.DIVISION_ID
--                                        , SA.ITEM_ID
--                                     FROM SCM_MST_ITEM_SN SA
--                                        , SCM_MST_ITEM_CLASS_SN SB
--                                    WHERE SA.ITEM_CLASS = SB.CLASS_ID
--                                      AND SB.USE_FLAG = 'Y'
--                                      AND V_EXC_MODE <> 'N'
--                                      AND (V_EXC_MODE = 'A' OR SA.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_DIV_TAB)))
--                                    GROUP BY SA.DIVISION_ID
--                                           , SA.ITEM_ID
--                                   HAVING MAX(DECODE(SA.ACTIVE_FLAG, 'N', 1, 0)) = 1
--                                      AND MAX(DECODE(SA.ACTIVE_FLAG, 'Y', 1, 0)) = 0
--                                  ) SC
--                            WHERE SC.ITEM_ID = IA.ITEM_ID)
             , (SELECT SC.ITEM_ID
                  FROM (SELECT SA.DIVISION_ID
                                        , SA.ITEM_ID
                                     FROM SCM_MST_ITEM_SN SA
                                        , SCM_MST_ITEM_CLASS_SN SB
                                    WHERE SA.ITEM_CLASS = SB.CLASS_ID
                                      AND SB.USE_FLAG = 'Y'
                                      AND V_EXC_MODE <> 'N'
                                      AND (V_EXC_MODE = 'A' OR SA.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_DIV_TAB)))
                                    GROUP BY SA.DIVISION_ID
                                           , SA.ITEM_ID
                                   HAVING MAX(DECODE(SA.ACTIVE_FLAG, 'N', 1, 0)) = 1
                                      AND MAX(DECODE(SA.ACTIVE_FLAG, 'Y', 1, 0)) = 0
                                  ) SC
                 GROUP BY SC.ITEM_ID
               ) XE                                            /* 비활성 품목 (AS-IS #TblDynamicPivot_SCP0030_Inactive) */
         WHERE IA.ITEM_ID = XE.ITEM_ID(+)
           AND XE.ITEM_ID IS NULL
         /* 2026.10.06 AJS 비활성 품목 제외 성능 개선 (END) */
           AND (V_NICK_NAME IS NULL OR UPPER(IA.NICK_NAME) LIKE '%' || V_NICK_NAME || '%')
         ORDER BY UPPER(TRANSLATE(IA.DIVISION_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.ITEM_ID, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.FROM_SITE_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.TO_SITE_CODE, '_-', '/')) NULLS FIRST
                , UPPER(TRANSLATE(IA.TRANSPORT_MODE, '_-', '/')) NULLS FIRST
                , IA.SEQ;

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , '0' AS EVENT
          FROM DUAL;
    END P_SCP0030_GET_BOD_ITEM;

    /* =========================================================================================
     * Excluded Item 조회 (AS-IS SCP0030_GET_BOD_EXCLUDED_ITEM)
     *   품목·별칭은 쉼표 토큰마다 부분 일치 조인(AS-IS 와 같이 토큰 여러 개에 걸리면 행이 늘어남,
     *   빈 토큰은 전체 일치). Plan Group 조건은 AS-IS 가 항상 빈 값으로 덮어써 사용하지 않음.
     *   AS-IS 는 정렬 없음.
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * ========================================================================================= */
    PROCEDURE P_SCP0030_GET_BOD_EXCLUDED_ITEM
    (
        P_DIVISION_ID     IN  VARCHAR2
      , P_FROM_SITE       IN  VARCHAR2
      , P_TO_SITE         IN  VARCHAR2
      , P_INCOTERMS       IN  VARCHAR2
      , P_TRANS_MODE      IN  VARCHAR2
      , P_ITEM_ID         IN  VARCHAR2
      , P_NICK_NAME       IN  VARCHAR2
      , P_VALID           IN  VARCHAR2
      , P_PLAN_GROUP_ID   IN  VARCHAR2
      , P_USER_ID         IN  VARCHAR2
      , P_MENU_ID         IN  VARCHAR2
      , O_RC1             OUT SYS_REFCURSOR
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_DIV_USE      VARCHAR2(1)   := F_USE_LIST(P_DIVISION_ID);
        V_FROM_USE     VARCHAR2(1)   := F_USE_LIST(P_FROM_SITE);
        V_TO_USE       VARCHAR2(1)   := F_USE_LIST(P_TO_SITE);
        V_INCO_USE     VARCHAR2(1)   := F_USE_LIST(P_INCOTERMS);
        V_TRANS_USE    VARCHAR2(1)   := F_USE_LIST(P_TRANS_MODE);
        V_DIV_TAB      T_STR_TAB     := F_SPLIT_LIST(P_DIVISION_ID, 'N');
        V_FROM_TAB     T_STR_TAB     := F_SPLIT_LIST(P_FROM_SITE, 'N');
        V_TO_TAB       T_STR_TAB     := F_SPLIT_LIST(P_TO_SITE, 'N');
        V_INCO_TAB     T_STR_TAB     := F_SPLIT_LIST(P_INCOTERMS, 'N');
        V_TRANS_TAB    T_STR_TAB     := F_SPLIT_LIST(P_TRANS_MODE, 'N');
        V_ITEM_TAB     T_STR_TAB     := F_SPLIT_LIST(P_ITEM_ID, 'Y');
        V_NICK_TAB     T_STR_TAB     := F_SPLIT_LIST(P_NICK_NAME, 'Y');
        V_VALID        VARCHAR2(4 CHAR);
    BEGIN
        /* AS-IS @p_valid NVARCHAR(1) — 첫 글자만 비교 */
        V_VALID := CASE WHEN UPPER(TRIM(P_VALID)) = 'ALL' THEN NULL
                        ELSE UPPER(TRIM(SUBSTR(P_VALID, 1, 1)))
                   END;

        OPEN O_RC1 FOR
        SELECT IA.DIVISION_ID
             , IA.OPMZ_PLAN_GR_NAME
             , IA.ITEM_ID
             , IA.NICK_NAME
             , IA.BOD_ID
             , IA.FROM_SITE_NAME
             , IA.TO_SITE_NAME
             , IA.INCOTERMS
             , IA.TRANSPORT_MODE
             , IA.BOD_EX_FROM_YYYYMMDD
             , IA.BOD_EX_TO_YYYYMMDD
             , IA.VALID_YN
             , IA.LAST_UPDATED_BY
             , IA.LAST_UPDATE_DATE
             , IA.DIVISION_ID || '|' || IA.ITEM_ID || '|' || IA.BOD_ID || '|' || IA.ORG_BOD_EX_FROM_YYYYMMDD || '|' || IA.ORG_BOD_EX_TO_YYYYMMDD AS PRE_KEY_VALUES
          FROM (SELECT XC.DIVISION_ID
                     , XC.OPMZ_PLAN_GR_NAME
                     , XC.ITEM_ID
                     , XC.NICK_NAME
                     , XC.BOD_ID
                     , XC.FROM_SITE_NAME
                     , XC.TO_SITE_NAME
                     , XC.INCOTERMS
                     , XC.TRANSPORT_MODE
                     , XC.BOD_EX_FROM_YYYYMMDD
                     , XC.BOD_EX_TO_YYYYMMDD
                     , XC.VALID_YN
                     , XC.LAST_UPDATED_BY
                     , XC.LAST_UPDATE_DATE
                     , XC.ORG_BOD_EX_FROM_YYYYMMDD
                     , XC.ORG_BOD_EX_TO_YYYYMMDD
                     , XC.FROM_SITE
                     , XC.TO_SITE
                  FROM (
                /* AS-IS SELECT DISTINCT — 대소문자만 다른 행(사이트 ID 가 대소문자만 다른 사이트 이름)은 한 행으로.
                   대표값은 품목 사업부의 사이트 이름 우선(AS-IS 는 임의 선택) */
                SELECT A.DIVISION_ID
                     , ' ' AS OPMZ_PLAN_GR_NAME
                     , A.ITEM_ID
                     , G.NICK_NAME
                     , A.BOD_ID
                     , D.SITE_DESCRIPTION AS FROM_SITE_NAME
                     , E.SITE_DESCRIPTION AS TO_SITE_NAME
                     , C.INCOTERMS
                     , F.TRANSPORT_MODE
                     , TO_DATE(A.BOD_EX_FROM_YYYYMMDD, 'YYYYMMDD') AS BOD_EX_FROM_YYYYMMDD
                     , TO_DATE(A.BOD_EX_TO_YYYYMMDD, 'YYYYMMDD') AS BOD_EX_TO_YYYYMMDD
                     , A.VALID_YN
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                     , A.BOD_EX_FROM_YYYYMMDD AS ORG_BOD_EX_FROM_YYYYMMDD
                     , A.BOD_EX_TO_YYYYMMDD AS ORG_BOD_EX_TO_YYYYMMDD
                     , C.FROM_SITE
                     , C.TO_SITE
                     , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                                     , A.ITEM_ID
                                                     , A.BOD_ID
                                                     , A.BOD_EX_FROM_YYYYMMDD
                                                     , A.BOD_EX_TO_YYYYMMDD
                                                     , UPPER(G.NICK_NAME)
                                                     , UPPER(D.SITE_DESCRIPTION)
                                                     , UPPER(E.SITE_DESCRIPTION)
                                                     , UPPER(C.INCOTERMS)
                                                     , UPPER(F.TRANSPORT_MODE)
                                                     , UPPER(C.FROM_SITE)
                                                     , UPPER(C.TO_SITE)
                                              ORDER BY DECODE(E.DIVISION_ID, A.DIVISION_ID, 0, 1)
                                                     , E.SITE_DESCRIPTION
                                                     , D.SITE_DESCRIPTION
                                                     , C.TO_SITE
                                                     , C.FROM_SITE) AS RN
                  FROM SCP_OPMZ_BOD_EXCLUDED_ITEM A
                     , SCP_MST_BOD_ITEM B
                     , SCP_MST_BOD C
                     , SCM_MST_SITE D                                  /* 출발 사이트 (PLANT, 품목 사업부) */
                     , SCM_MST_SITE E                                  /* 도착 사이트 (사업부 조건 없음 — AS-IS 동일) */
                     , SCP_MST_DISTRIBUTION_ROUTE F
                     , SCP_MST_FINAL_ITEM G
                 WHERE B.DIVISION_ID = A.DIVISION_ID
                   AND B.ITEM_ID = A.ITEM_ID
                   AND B.BOD_ID = A.BOD_ID
                   AND C.BOD_ID = B.BOD_ID
                   AND UPPER(D.SCM_SITE_ID) = UPPER(C.FROM_SITE)
                   AND D.DIVISION_ID = B.DIVISION_ID
                   AND UPPER(E.SCM_SITE_ID) = UPPER(C.TO_SITE)
                   -- E20260511-000181 BOD ITEM-Excluded Item Tab 조회저장 로직 수정요청 주석처리.
                   --AND ST.SITE_TYPE ='SALES'
                   AND F.ROUTE_ID = C.ROUTE_ID
                   AND G.DIVISION_ID = A.DIVISION_ID
                   AND G.ITEM_ID = A.ITEM_ID
                   AND D.SITE_TYPE = 'PLANT'
                       ) XC
                 WHERE XC.RN = 1
               ) IA
             , (SELECT DISTINCT
                       /* 조회조건 ALL 은 조건 없음 — 부분일치라 무늬를 '%%' 로 만든다 */
                       '%' || CASE WHEN UPPER(TRIM(COLUMN_VALUE)) = 'ALL' THEN NULL
                                   ELSE COLUMN_VALUE END || '%' AS TST
                  FROM TABLE(V_ITEM_TAB)
               ) XA
             , (SELECT DISTINCT
                       /* 조회조건 ALL 은 조건 없음 — 부분일치라 무늬를 '%%' 로 만든다 */
                       '%' || CASE WHEN UPPER(TRIM(COLUMN_VALUE)) = 'ALL' THEN NULL
                                   ELSE COLUMN_VALUE END || '%' AS TST
                  FROM TABLE(V_NICK_TAB)
               ) XB
--       WHERE UPPER(IA.ITEM_ID) LIKE XA.TST   --  2026.10.07 AJS
         WHERE (UPPER(IA.ITEM_ID) LIKE XA.TST OR UPPER(IA.NICK_NAME) LIKE XA.TST)   --  2026.10.07 AJS
           AND UPPER(IA.NICK_NAME) LIKE XB.TST
           AND (V_DIV_USE = 'N' OR IA.DIVISION_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_DIV_TAB)))
           AND (V_INCO_USE = 'N' OR UPPER(IA.INCOTERMS) IN (SELECT COLUMN_VALUE FROM TABLE(V_INCO_TAB)))
           AND (V_TRANS_USE = 'N' OR UPPER(IA.TRANSPORT_MODE) IN (SELECT COLUMN_VALUE FROM TABLE(V_TRANS_TAB)))
           AND (V_FROM_USE = 'N' OR UPPER(IA.FROM_SITE) IN (SELECT COLUMN_VALUE FROM TABLE(V_FROM_TAB)))
           AND (V_TO_USE = 'N' OR UPPER(IA.TO_SITE) IN (SELECT COLUMN_VALUE FROM TABLE(V_TO_TAB)))
           AND (V_VALID IS NULL OR UPPER(IA.VALID_YN) = V_VALID);

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , '0' AS EVENT
          FROM DUAL;
    END P_SCP0030_GET_BOD_EXCLUDED_ITEM;

    /* =========================================================================================
     * BOD ITEM 등록·수정 (AS-IS SCP0030_SAVE_BOD_ITEM)
     *   화면 저장 규격 : P_DATA = 그리드 행 JSON 배열(조회 칸 이름 + CRUD_TYPE)
     *   I·M 행만 처리(D 는 AS-IS 도 처리하지 않음) — 행마다 순번 채번 → 이력 적재 → 수정, 없으면 등록
     *   값은 AS-IS SCM_ARR_SPL_VAL 과 같이 앞뒤 공백 제거, 빈 값은 필수 칸 '-' · 선택 칸 NULL
     *   오류 시 이 프로시저에서 바꾼 내용만 되돌림(SAVEPOINT)
     * ========================================================================================= */
    PROCEDURE P_SCP0030_SAVE_BOD_ITEM
    (
        P_DATA            IN  CLOB
      , P_USER_ID         IN  VARCHAR2
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME   VARCHAR2(150)  := 'SCP0030_SAVE_BOM_ITEM';
        V_UNIT_NAME      VARCHAR2(150)  := 'PKG_SCP0030.P_SCP0030_SAVE_BOD_ITEM';
        V_WORKING_TIME   DATE;
        V_LOOP_CNT       PLS_INTEGER    := 0;
        V_SEQ            NUMBER(19);
        V_PRIORITY       NUMBER;
        V_SAFETY_STOCK   NUMBER;
        V_DIVISION_ID    VARCHAR2(4000);
        V_BOD_ID         VARCHAR2(4000);
        V_ITEM_ID        VARCHAR2(4000);
        V_FROM_YYYYMMDD  VARCHAR2(4000);
        V_TO_YYYYMMDD    VARCHAR2(4000);
        V_COMMITTED      VARCHAR2(1)    := 'N';
        V_ERR_MSG        VARCHAR2(4000);
    BEGIN
        SAVEPOINT SP_SCP0030_SAVE_BOD_ITEM;
        V_WORKING_TIME := SYSDATE;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', SYSDATE);

        FOR R IN (SELECT UPPER(TRIM(JT.CRUD_TYPE)) AS CRUD_TYPE
                       , TRIM(JT.SEQ) AS SEQ
                       , TRIM(JT.BOD_ID) AS BOD_ID
                       , TRIM(JT.DIVISION_ID) AS DIVISION_ID
                       , TRIM(JT.ITEM_ID) AS ITEM_ID
                       , TRIM(JT.PRIORITY) AS PRIORITY
                       , TRIM(JT.FROM_YYYYMMDD) AS FROM_YYYYMMDD
                       , TRIM(JT.TO_YYYYMMDD) AS TO_YYYYMMDD
                       , TRIM(JT.SAFETY_STOCK) AS SAFETY_STOCK
                       , DECODE(JT.SAFETY_STOCK_EXISTS, 'true', 'Y', 'N') AS SAFETY_STOCK_EXISTS
                       , TRIM(JT.BOD_ITEM_VALID) AS BOD_ITEM_VALID
                    FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR
                             COLUMNS ( CRUD_TYPE            VARCHAR2(4000) PATH '$."CRUD_TYPE"'
                                     , SEQ                  VARCHAR2(4000) PATH '$."SEQ"'
                                     , BOD_ID               VARCHAR2(4000) PATH '$."BOD_ID"'
                                     , DIVISION_ID          VARCHAR2(4000) PATH '$."DIVISION_ID"'
                                     , ITEM_ID              VARCHAR2(4000) PATH '$."ITEM_ID"'
                                     , PRIORITY             VARCHAR2(4000) PATH '$."PRIORITY"'
                                     , FROM_YYYYMMDD        VARCHAR2(4000) PATH '$."FROM_YYYYMMDD"'
                                     , TO_YYYYMMDD          VARCHAR2(4000) PATH '$."TO_YYYYMMDD"'
                                     , SAFETY_STOCK         VARCHAR2(4000) PATH '$."SAFETY_STOCK"'
                                     , SAFETY_STOCK_EXISTS  VARCHAR2(5)    EXISTS PATH '$."SAFETY_STOCK"'
                                     , BOD_ITEM_VALID       VARCHAR2(4000) PATH '$."BOD_ITEM_VALID"'
                                     )
                                    ) JT
                   WHERE UPPER(TRIM(JT.CRUD_TYPE)) IN ('I', 'M', 'D'))
        LOOP
            V_LOOP_CNT := V_LOOP_CNT + 1;

            IF R.CRUD_TYPE IN ('M', 'I') THEN
                IF R.SEQ IS NULL THEN
                    V_SEQ := SEQ1_SCP_MST_BOD_ITEM.NEXTVAL;
                ELSE
                    V_SEQ := F_TO_INT(R.SEQ);
                END IF;

                V_DIVISION_ID   := NVL(R.DIVISION_ID, '/');
                V_BOD_ID        := NVL(R.BOD_ID, '/');
                V_ITEM_ID       := NVL(R.ITEM_ID, '/');
                V_FROM_YYYYMMDD := NVL(F_TO_YYYYMMDD(R.FROM_YYYYMMDD), '-');
                V_TO_YYYYMMDD   := NVL(F_TO_YYYYMMDD(R.TO_YYYYMMDD), '-');
                V_PRIORITY      := F_TO_INT(R.PRIORITY);
                V_SAFETY_STOCK  := F_TO_DEC(R.SAFETY_STOCK, R.SAFETY_STOCK_EXISTS);

                /* 이력저장 */
                P_SCP_MST_BOD_ITEM_HIST(V_SEQ
                                      , V_BOD_ID
                                      , V_DIVISION_ID
                                      , V_ITEM_ID
                                      , V_PRIORITY
                                      , V_FROM_YYYYMMDD
                                      , V_TO_YYYYMMDD
                                      , V_SAFETY_STOCK
                                      , R.BOD_ITEM_VALID
                                      , P_USER_ID
                                      , V_WORKING_TIME
                                      , P_USER_ID
                                      , V_WORKING_TIME);

                /* AS-IS MERGE (WHEN MATCHED UPDATE / NOT MATCHED INSERT) */
                UPDATE SCP_MST_BOD_ITEM
                   SET DIVISION_ID      = V_DIVISION_ID
                     , FROM_YYYYMMDD    = V_FROM_YYYYMMDD
                     , TO_YYYYMMDD      = V_TO_YYYYMMDD
                     , PRIORITY         = V_PRIORITY
                     , SAFETY_STOCK     = V_SAFETY_STOCK
                     , VALID_YN         = R.BOD_ITEM_VALID
                     , LAST_UPDATED_BY  = P_USER_ID
                     , LAST_UPDATE_DATE = V_WORKING_TIME
                 WHERE SEQ = V_SEQ;

                IF SQL%ROWCOUNT = 0 THEN
                    INSERT
                      INTO SCP_MST_BOD_ITEM
                         ( SEQ
                         , DIVISION_ID
                         , BOD_ID
                         , ITEM_ID
                         , PRIORITY
                         , FROM_YYYYMMDD
                         , TO_YYYYMMDD
                         , SAFETY_STOCK
                         , VALID_YN
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE
                         )
                    VALUES
                         ( V_SEQ
                         , V_DIVISION_ID
                         , V_BOD_ID
                         , V_ITEM_ID
                         , V_PRIORITY
                         , V_FROM_YYYYMMDD
                         , V_TO_YYYYMMDD
                         , V_SAFETY_STOCK
                         , R.BOD_ITEM_VALID
                         , P_USER_ID
                         , V_WORKING_TIME
                         , P_USER_ID
                         , V_WORKING_TIME
                         );
                END IF;
            END IF;
        END LOOP;

        /* 종료 LOG */
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', SYSDATE);

        COMMIT;
        V_COMMITTED := 'Y';

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , TO_CHAR(V_LOOP_CNT) AS EVENT
             , 'S' AS RESULT_CODE
             , V_LOOP_CNT AS RESULT_CNT
          FROM DUAL;
    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SUBSTR(SQLERRM, 1, 4000);
            IF V_COMMITTED = 'N' THEN
                ROLLBACK TO SAVEPOINT SP_SCP0030_SAVE_BOD_ITEM;
            END IF;
            PR_SCM_SYS_LOG_BATCH(V_UNIT_NAME, 'ERROR', NULL, V_ERR_MSG, NULL, SYSDATE);

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , '0' AS EVENT
                 , 'F' AS RESULT_CODE
                 , 0 AS RESULT_CNT
              FROM DUAL;
    END P_SCP0030_SAVE_BOD_ITEM;

    /* =========================================================================================
     * Excluded Item 등록·수정·삭제 (AS-IS SCP0030_SAVE_BOD_EXCLUDED_ITEM)
     *   변경 전 키 = PRE_KEY_VALUES (사업부|품목|BOD|시작일|종료일, 조회 결과 그대로)
     *   AS-IS 는 신규 행의 변경 전 키가 빈 문자열이라 「자기 자신 제외」 조건이 항상 거짓 →
     *   중복·기간 겹침 검사가 신규 행에도 적용됨. 빈 값은 비교 불가 값으로 바꿔 같은 결과를 냄.
     *   오류 시 이 프로시저에서 바꾼 내용만 되돌림(SAVEPOINT)
     * ========================================================================================= */
    PROCEDURE P_SCP0030_SAVE_BOD_EXCLUDED_ITEM
    (
        P_DATA            IN  CLOB
      , P_USER_ID         IN  VARCHAR2
      , O_RESULT_CURSOR   OUT SYS_REFCURSOR
    )
    IS
        V_PROGRAM_NAME          VARCHAR2(150)  := 'SCP0030_SAVE_BOD_EXCLUDED_ITEM';
        V_UNIT_NAME             VARCHAR2(150)  := 'PKG_SCP0030.P_SCP0030_SAVE_BOD_EXCLUDED_ITEM';
        V_NONE                  VARCHAR2(1)    := CHR(0);          /* AS-IS 빈 문자열 비교(항상 거짓) 대용 */
        V_LOOP_CNT              PLS_INTEGER    := 0;
        V_CNT                   PLS_INTEGER    := 0;
        V_DIVISION_ID           VARCHAR2(4000);
        V_ITEM_ID               VARCHAR2(4000);
        V_BOD_ID                VARCHAR2(4000);
        V_FROM_YYYYMMDD         VARCHAR2(4000);
        V_TO_YYYYMMDD           VARCHAR2(4000);
        V_PRE_DIVISION_ID       VARCHAR2(4000);
        V_PRE_ITEM_ID           VARCHAR2(4000);
        V_PRE_BOD_ID            VARCHAR2(4000);
        V_PRE_FROM_YYYYMMDD     VARCHAR2(4000);
        V_PRE_TO_YYYYMMDD       VARCHAR2(4000);
        V_COMMITTED             VARCHAR2(1)    := 'N';
        V_ERR_MSG               VARCHAR2(4000);
        EX_BIZ                  EXCEPTION;
    BEGIN
        SAVEPOINT SP_SCP0030_SAVE_BOD_EX_ITEM;

        /* 시작 LOG */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', SYSDATE);

        FOR R IN (SELECT UPPER(TRIM(JT.CRUD_TYPE)) AS CRUD_TYPE
                       , TRIM(JT.DIVISION_ID) AS DIVISION_ID
                       , TRIM(JT.ITEM_ID) AS ITEM_ID
                       , TRIM(JT.BOD_ID) AS BOD_ID
                       , TRIM(JT.BOD_EX_FROM_YYYYMMDD) AS BOD_EX_FROM_YYYYMMDD
                       , TRIM(JT.BOD_EX_TO_YYYYMMDD) AS BOD_EX_TO_YYYYMMDD
                       , TRIM(JT.VALID_YN) AS VALID_YN
                       , JT.PRE_KEY_VALUES
                    FROM JSON_TABLE(P_DATA, '$[*]' ERROR ON ERROR
                             COLUMNS ( CRUD_TYPE             VARCHAR2(4000) PATH '$."CRUD_TYPE"'
                                     , DIVISION_ID           VARCHAR2(4000) PATH '$."DIVISION_ID"'
                                     , ITEM_ID               VARCHAR2(4000) PATH '$."ITEM_ID"'
                                     , BOD_ID                VARCHAR2(4000) PATH '$."BOD_ID"'
                                     , BOD_EX_FROM_YYYYMMDD  VARCHAR2(4000) PATH '$."BOD_EX_FROM_YYYYMMDD"'
                                     , BOD_EX_TO_YYYYMMDD    VARCHAR2(4000) PATH '$."BOD_EX_TO_YYYYMMDD"'
                                     , VALID_YN              VARCHAR2(4000) PATH '$."VALID_YN"'
                                     , PRE_KEY_VALUES        VARCHAR2(4000) PATH '$."PRE_KEY_VALUES"'
                                     )
                                    ) JT
                   WHERE UPPER(TRIM(JT.CRUD_TYPE)) IN ('I', 'M', 'D'))
        LOOP
            V_LOOP_CNT := V_LOOP_CNT + 1;

            V_DIVISION_ID   := NVL(R.DIVISION_ID, '/');
            V_ITEM_ID       := NVL(R.ITEM_ID, '/');
            V_BOD_ID        := NVL(R.BOD_ID, '/');
            V_FROM_YYYYMMDD := NVL(F_TO_YYYYMMDD(R.BOD_EX_FROM_YYYYMMDD), '-');
            V_TO_YYYYMMDD   := NVL(F_TO_YYYYMMDD(R.BOD_EX_TO_YYYYMMDD), '-');

            /* 변경 전 키 (AS-IS 화면 : 신규 행은 빈 값, 그 외 PRE_KEY_VALUES 를 '|' 로 분리) */
            IF R.CRUD_TYPE = 'I' OR R.PRE_KEY_VALUES IS NULL THEN
                V_PRE_DIVISION_ID   := V_NONE;
                V_PRE_ITEM_ID       := V_NONE;
                V_PRE_BOD_ID        := V_NONE;
                V_PRE_FROM_YYYYMMDD := V_NONE;
                V_PRE_TO_YYYYMMDD   := V_NONE;
            ELSE
                V_PRE_DIVISION_ID   := NVL(TRIM(REGEXP_SUBSTR(R.PRE_KEY_VALUES, '([^|]*)(\||$)', 1, 1, NULL, 1)), V_NONE);
                V_PRE_ITEM_ID       := NVL(TRIM(REGEXP_SUBSTR(R.PRE_KEY_VALUES, '([^|]*)(\||$)', 1, 2, NULL, 1)), V_NONE);
                V_PRE_BOD_ID        := NVL(TRIM(REGEXP_SUBSTR(R.PRE_KEY_VALUES, '([^|]*)(\||$)', 1, 3, NULL, 1)), V_NONE);
                V_PRE_FROM_YYYYMMDD := NVL(TRIM(REGEXP_SUBSTR(R.PRE_KEY_VALUES, '([^|]*)(\||$)', 1, 4, NULL, 1)), V_NONE);
                V_PRE_TO_YYYYMMDD   := NVL(TRIM(REGEXP_SUBSTR(R.PRE_KEY_VALUES, '([^|]*)(\||$)', 1, 5, NULL, 1)), V_NONE);
            END IF;

            /* 삭제가 아닌 경우, 중복체크 */
            IF R.CRUD_TYPE <> 'D' THEN
                /***** 중복체크 *****/
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCP_OPMZ_BOD_EXCLUDED_ITEM
                 WHERE UPPER(DIVISION_ID)   = UPPER(V_DIVISION_ID)
                   AND UPPER(ITEM_ID)       = UPPER(V_ITEM_ID)
                   AND UPPER(BOD_ID)        = UPPER(V_BOD_ID)
                   AND BOD_EX_FROM_YYYYMMDD = V_FROM_YYYYMMDD
                   AND BOD_EX_TO_YYYYMMDD   = V_TO_YYYYMMDD
                   AND NOT (    UPPER(DIVISION_ID)   = UPPER(V_PRE_DIVISION_ID)
                            AND UPPER(ITEM_ID)       = UPPER(V_PRE_ITEM_ID)
                            AND UPPER(BOD_ID)        = UPPER(V_PRE_BOD_ID)
                            AND BOD_EX_FROM_YYYYMMDD = V_PRE_FROM_YYYYMMDD
                            AND BOD_EX_TO_YYYYMMDD   = V_PRE_TO_YYYYMMDD
                           );

                IF V_CNT > 0 THEN
                    V_ERR_MSG := '[99010] 입력 데이터 중 중복된 데이터가 있습니다.';
                    RAISE EX_BIZ;
                END IF;

                /**** 날짜 중복 체크 ****/
                SELECT COUNT(1)
                  INTO V_CNT
                  FROM SCP_OPMZ_BOD_EXCLUDED_ITEM X
                 WHERE UPPER(X.DIVISION_ID) = UPPER(V_DIVISION_ID)
                   AND UPPER(X.ITEM_ID)     = UPPER(V_ITEM_ID)
                   AND UPPER(X.BOD_ID)      = UPPER(V_BOD_ID)
                   AND NOT (V_TO_YYYYMMDD < X.BOD_EX_FROM_YYYYMMDD OR V_FROM_YYYYMMDD > X.BOD_EX_TO_YYYYMMDD)
                   AND NOT (X.BOD_EX_FROM_YYYYMMDD = V_PRE_FROM_YYYYMMDD AND X.BOD_EX_TO_YYYYMMDD = V_PRE_TO_YYYYMMDD);   /* 기존 값 */

                IF V_CNT > 0 THEN
                    V_ERR_MSG := '[99010] 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.';
                    RAISE EX_BIZ;
                END IF;
            END IF;

            IF R.CRUD_TYPE = 'I' THEN
                INSERT
                  INTO SCP_OPMZ_BOD_EXCLUDED_ITEM
                     ( DIVISION_ID
                     , ITEM_ID
                     , BOD_ID
                     , BOD_EX_FROM_YYYYMMDD
                     , BOD_EX_TO_YYYYMMDD
                     , VALID_YN
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE
                     )
                VALUES
                     ( V_DIVISION_ID
                     , V_ITEM_ID
                     , V_BOD_ID
                     , V_FROM_YYYYMMDD
                     , V_TO_YYYYMMDD
                     , R.VALID_YN
                     , P_USER_ID
                     , SYSDATE
                     , P_USER_ID
                     , SYSDATE
                     );
            ELSIF R.CRUD_TYPE = 'M' THEN
                UPDATE SCP_OPMZ_BOD_EXCLUDED_ITEM
                   SET DIVISION_ID          = V_DIVISION_ID
                     , ITEM_ID              = V_ITEM_ID
                     , BOD_ID               = V_BOD_ID
                     , BOD_EX_FROM_YYYYMMDD = V_FROM_YYYYMMDD
                     , BOD_EX_TO_YYYYMMDD   = V_TO_YYYYMMDD
                     , VALID_YN             = R.VALID_YN
                     , LAST_UPDATED_BY      = P_USER_ID
                     , LAST_UPDATE_DATE     = SYSDATE
                 WHERE UPPER(DIVISION_ID)   = UPPER(V_PRE_DIVISION_ID)
                   AND UPPER(ITEM_ID)       = UPPER(V_PRE_ITEM_ID)
                   AND UPPER(BOD_ID)        = UPPER(V_PRE_BOD_ID)
                   AND BOD_EX_FROM_YYYYMMDD = V_PRE_FROM_YYYYMMDD
                   AND BOD_EX_TO_YYYYMMDD   = V_PRE_TO_YYYYMMDD;
            /* 삭제기능 추가 (2025-07-16) */
            ELSIF R.CRUD_TYPE = 'D' THEN
                DELETE
                  FROM SCP_OPMZ_BOD_EXCLUDED_ITEM
                 WHERE UPPER(DIVISION_ID)   = UPPER(V_PRE_DIVISION_ID)
                   AND UPPER(ITEM_ID)       = UPPER(V_PRE_ITEM_ID)
                   AND UPPER(BOD_ID)        = UPPER(V_PRE_BOD_ID)
                   AND BOD_EX_FROM_YYYYMMDD = V_PRE_FROM_YYYYMMDD
                   AND BOD_EX_TO_YYYYMMDD   = V_PRE_TO_YYYYMMDD;
            END IF;
        END LOOP;

        /* 종료 LOG */
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', SYSDATE);

        COMMIT;
        V_COMMITTED := 'Y';

        OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE
             , 'SUCCESS' AS MSG
             , TO_CHAR(V_LOOP_CNT) AS EVENT
             , 'S' AS RESULT_CODE
             , V_LOOP_CNT AS RESULT_CNT
          FROM DUAL;
    EXCEPTION
        WHEN EX_BIZ THEN
            ROLLBACK TO SAVEPOINT SP_SCP0030_SAVE_BOD_EX_ITEM;
            PR_SCM_SYS_LOG_BATCH(V_UNIT_NAME, 'ERROR', NULL, V_ERR_MSG, NULL, SYSDATE);

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , '0' AS EVENT
                 , 'F' AS RESULT_CODE
                 , 0 AS RESULT_CNT
              FROM DUAL;
        WHEN OTHERS THEN
            V_ERR_MSG := SUBSTR(SQLERRM, 1, 4000);
            IF V_COMMITTED = 'N' THEN
                ROLLBACK TO SAVEPOINT SP_SCP0030_SAVE_BOD_EX_ITEM;
            END IF;
            PR_SCM_SYS_LOG_BATCH(V_UNIT_NAME, 'ERROR', NULL, V_ERR_MSG, NULL, SYSDATE);

            OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE
                 , V_ERR_MSG AS MSG
                 , '0' AS EVENT
                 , 'F' AS RESULT_CODE
                 , 0 AS RESULT_CNT
              FROM DUAL;
    END P_SCP0030_SAVE_BOD_EXCLUDED_ITEM;

END PKG_SCP0030;
/
SHOW ERRORS PACKAGE BODY PKG_SCP0030
