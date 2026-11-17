-- SOURCE-FRESH: SCM_MGR.PKG_SCP0128 PACKAGE BODY LAST_DDL=2026-11-05 10:22:44 FETCHED=2026-11-13 10:45:14 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY PKG_SCP0128
IS
    /*
     * Program ID   : PKG_SCP0128
     * Description  : SCP0128 Precede / Safety Stock Day 화면 — 안전재고 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

/* Program ID  : P_SCP0128_GET_SEARCH_INFO                                                          */
/* Description : 조회조건 초기값 (계획그룹 · 사이트 · 공정 · 구분 · 사용여부 · 품목 · 공정2)        */
PROCEDURE P_SCP0128_GET_SEARCH_INFO
(
    P_DIVISION_ID       IN  CLOB
  , P_SITE_ID           IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RC2               OUT SYS_REFCURSOR
  , O_RC3               OUT SYS_REFCURSOR
  , O_RC4               OUT SYS_REFCURSOR
  , O_RC5               OUT SYS_REFCURSOR
  , O_RC6               OUT SYS_REFCURSOR
  , O_RC7               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0128_GET_SEARCH_INFO
 * Description  : 안전재고(SCP0128), 수요제외(SCP0129) 조회, 콤보용 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/25   kh    			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/11/14   mrchois    		PJ20257329	최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 수요제외(SCP0129)용은 Attribute3 = 'Y'인 것으로 가져오도록 변경
 * 2025/11/24   mrchois    		PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN
 * 2025/12/17   mrchois    		PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Scheduled Reciept Information-Virtual BOM에 등록한 ITEM도 입력 가능하도록 변경
 *
 */
    V_DIVISION_ID       VARCHAR2(200 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 200));   /* 원문이 NVARCHAR(200) 변수로 받아 200자에서 자른다 */
BEGIN

    /* 1. 계획 그룹 */
    -- 참조 기간 및 기준일자 정보 변수
    -- 당주 월요일 (plan_start_yyyymmdd) 
    OPEN O_RC1 FOR
        -- horizon_end_date ?
        --1. Plan Group 정보 
        SELECT OPMZ_PLAN_GR_ID AS CODE
             , OPMZ_PLAN_GR_NAME AS NAME
             , DIVISION_ID
          FROM SCP_OPMZ_PLAN_GR_M
         WHERE VALID_YN = 'Y'
         ORDER BY FN_ASIS_SORT_KEY(OPMZ_PLAN_GR_NAME) NULLS FIRST;

    /* 2. 사이트 — 판매 사이트(사업부 40 은 사이트 품목 기준) + 공장 사이트 */
    OPEN O_RC2 FOR
        --2. 재고 SCM SITE ID 
        SELECT IA.DIVISION_ID
             , IA.CODE
             , IA.NAME
          FROM (SELECT DISTINCT A.DIVISION_ID
                     , A.SCM_SITE_ID AS CODE
                     , A.SCM_SITE_ID AS NAME
                     , A.SITE_TYPE
                  FROM SCM_MST_SITE A
                 WHERE A.SITE_TYPE   = 'SALES'
                   AND A.DIVISION_ID <> '40'
                   AND A.VALID_YN    = 'Y'
                 UNION ALL
                SELECT DISTINCT A.DIVISION_ID
                     , A.SCM_SITE_ID AS CODE
                     , A.SCM_SITE_ID AS NAME
                     , A.SITE_TYPE
                  FROM SCM_MST_SITE A
                     , SCM_MST_SITE_ITEM B
                 WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                   AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
                   AND A.SITE_TYPE   = 'SALES'
                   AND A.DIVISION_ID = '40'
                   AND A.VALID_YN    = 'Y'
                 UNION ALL
                SELECT DISTINCT A.DIVISION_ID
                     , A.SCM_SITE_ID AS CODE
                     , A.SCM_SITE_ID AS NAME
                     , A.SITE_TYPE
                  FROM SCM_MST_SITE A
                 WHERE A.SITE_TYPE = 'PLANT') IA
         ORDER BY FN_ASIS_SORT_KEY(IA.SITE_TYPE) NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.NAME) NULLS FIRST;    -- A.DIVISION_ID

    /* 3. 공정 — 안전재고용 */
    OPEN O_RC3 FOR
        -- 3. STAGE 최적화 (안전재고(SCP0128) 용)
        SELECT SEGMENT1 AS DIVISION_ID
             , SEGMENT3 AS CODE
             , ATTRIBUTE1 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE LIKE 'OPMZ_STAGE_CD'
           AND VALID_YN = 'Y'
         ORDER BY FN_ASIS_SORT_KEY(SEGMENT1) NULLS FIRST /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 저장 순서와 같게 고정 */
                , FN_ASIS_SORT_KEY(SEGMENT3) NULLS FIRST;

    /* 4. 구분 (MIN / MAX) */
    OPEN O_RC4 FOR
        -- 4. TYPE (COVER_DAY_TYPE : MIN/MAX) 호출
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'COVER_DAY_TYPE'
         ORDER BY DISPLAY_SEQ;

    /* 5. 사용여부 */
    OPEN O_RC5 FOR
        -- 5. valid YN
        SELECT SEGMENT1 AS CODE
             , SEGMENT2 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE = 'DM_YN' /* 'DEFAULT_FLAG' */
         ORDER BY DISPLAY_SEQ;

    /* 6. 품목 — 품목 원장 + 가상 BOM 에 등록한 품목 */
    OPEN O_RC6 FOR
        SELECT IA.DIVISION_ID
             , IA.ITEM_ID
               --6.ITEM_ID 조회
          FROM (SELECT DISTINCT A.DIVISION_ID
                     , A.ITEM_ID
                  FROM SCM_MST_ITEM_SN A --[PJ20257329]ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN (2025-11-24)
                 WHERE CASE WHEN V_DIVISION_ID = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END IN (SELECT COLUMN_VALUE
                                                                                               FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ',')))
                       --[PJ20257329] Scheduled Reciept Information-Virtual BOM에 등록한 ITEM도 입력 가능하도록 변경 (2025-12-17) START
                 UNION
                SELECT DISTINCT A.DIVISION_ID
                     , A.ITEM_ID_CHILD AS ITEM_ID
                  FROM SCP_OPMZ_VIRTUAL_BOM A
                 WHERE CASE WHEN V_DIVISION_ID = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END IN (SELECT COLUMN_VALUE
                                                                                               FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ',')))) IA
         ORDER BY FN_ASIS_SORT_KEY(IA.ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(IA.DIVISION_ID) NULLS FIRST;

    /* 7. 공정 — 수요제외용 (2025-11-14 추가분) */
    OPEN O_RC7 FOR
        --[PJ20257329] Scheduled Reciept Information-Virtual BOM에 등록한 ITEM도 입력 가능하도록 변경 (2025-12-17) END
        --[PJ20257329]수요제외(SCP0129)용은 Attribute3 = 'Y' 인 것으로 가져오도록 변경 (2025-11-14) START
        -- 7. STAGE 최적화 (수요제외(SCP0129) 용)
        SELECT SEGMENT1 AS DIVISION_ID
             , SEGMENT3 AS CODE
             , ATTRIBUTE1 AS NAME
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
         WHERE LOOKUP_TYPE LIKE 'OPMZ_STAGE_CD'
           AND VALID_YN   = 'Y'
           AND ATTRIBUTE3 = 'Y'
         ORDER BY FN_ASIS_SORT_KEY(SEGMENT1) NULLS FIRST /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 저장 순서와 같게 고정 */
                , FN_ASIS_SORT_KEY(SEGMENT3) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE
             , 'SUCCESS' AS RESULT_MESSAGE
          FROM DUAL;

--[PJ20257329]수요제외(SCP0129)용은 Attribute3 = 'Y' 인 것으로 가져오도록 변경 (2025-11-14) END
END P_SCP0128_GET_SEARCH_INFO;

/* Program ID  : P_SCP0128_GET_SAFETY_STOCK                                             */
/* Description : 안전재고 조회                                                      */
PROCEDURE P_SCP0128_GET_SAFETY_STOCK
(
    P_DIVISION_ID       IN  CLOB
  , P_PLAN_GROUP_ID     IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_STAGE             IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_VALUE_TYPE        IN  CLOB
  , P_PERIOD_FROM       IN  CLOB
  , P_PERIOD_TO         IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0128_GET_SAFETY_STOCK
 * Description  : CAPA - No Work 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 * 2025/12/17   mrchois			PJ20257329 최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - 조회 정렬 변경
 *
 */
    /* 원문이 조회조건을 NVARCHAR(200) 변수로 받아 200자에서 자른다 */
    V_DIVISION_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID,   1, 200));
    V_PLAN_GROUP_ID     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PLAN_GROUP_ID, 1, 200));
    -- 2026.11.03 AJS SCM Site 전체 선택 200자 잘림 조치 (START)
    V_SCM_SITE_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_SCM_SITE_ID,   1, 200));
    /* AS-IS 화면은 전체 선택이면 빈 값을 보낸다. TO-BE 화면은 전체 목록을 보내므로 목록 전체로 비교한다 */
    V_SCM_SITE_LIST     CLOB                 := ',' || REPLACE(UPPER(P_SCM_SITE_ID), ' ', '') || ',';
    -- 2026.11.03 AJS SCM Site 전체 선택 200자 잘림 조치 (END)
    V_STAGE             VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_STAGE,         1, 200));
    V_VALID_YN          VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_VALID_YN,      1, 200));
    V_VALUE_TYPE        VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_VALUE_TYPE,    1, 200));
    V_PERIOD_FROM       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PERIOD_FROM,   1, 200));
    V_PERIOD_TO         VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PERIOD_TO,     1, 200));
    /* 품목만 원문이 자르지 않은 값을 쓴다 */
    V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,       1, 32767));
BEGIN

    -- 파라미터로 받을 값 변수  
    --[PJ20257329] 조회 정렬 변경 (2025-12-17) START
    --[PJ20257329] 조회 정렬 변경 (2025-12-17) END
    OPEN O_RC1 FOR
        SELECT A.VALUE_TYPE
             , A.DIVISION_ID
             , A.OPMZ_PLAN_GR_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.STAGE
             , TO_DATE(A.FROM_YYYYMMDD, 'YYYYMMDD') AS FROM_YYYYMMDD
             , TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD') AS TO_YYYYMMDD
             , A.APL_QTY
             , A.VALUE_DESCRIPTION
             , A.VALID_YN
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
             , A.VALUE_TYPE||'|'||A.DIVISION_ID||'|'||A.OPMZ_PLAN_GR_ID||'|'||A.SCM_SITE_ID||'|'||A.ITEM_ID||'|'||A.STAGE||'|'||A.FROM_YYYYMMDD||'|'||A.TO_YYYYMMDD AS PRE_KEY_VALUES
          FROM SCP_OPMZ_SAFETY_STOCK A
           /* 2026.11.05 AJS 조회조건 Model/Nickname : 품목 코드 또는 닉네임 검색 (START) : 입력값 하나라도 품목 코드 또는 닉네임에 부분일치하면 조회. 같은 행은 한 번만 표시 */
--             , (SELECT DISTINCT '%'||UPPER(COLUMN_VALUE)||'%' AS TST
--                  FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))) IA
             , SCP_OPMZ_PLAN_GR_M C
--         WHERE A.ITEM_ID LIKE IA.TST
--           AND C.DIVISION_ID(+) = A.DIVISION_ID
         WHERE C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.OPMZ_PLAN_GR_ID(+) = A.OPMZ_PLAN_GR_ID
           AND EXISTS (SELECT 1
                         FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA
                        WHERE UPPER(A.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'   /* 2026.11.13 조회조건 대소문자 무시 */
                           OR EXISTS (SELECT 1
                                        FROM SCM_ITEM_M_SN SB
                                       WHERE SB.ITEM_ID = A.ITEM_ID
                                         AND UPPER(SB.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'))
           /* 2026.11.05 AJS 조회조건 Model/Nickname : 품목 코드 또는 닉네임 검색 (END) */
               /* ★AS-IS 는 대소문자를 가리지 않는다. 원장 실측상 소문자가 섞인 칸은 사이트 하나뿐이라
                 사이트만 칸과 입력값을 함께, 나머지는 입력값만 대문자로 맞춘다 */
               -- 2026.09.30 AJS 조회조건 ALL 처리 (START)
               -- AND (TRIM(V_DIVISION_ID) IS NULL
           AND (TRIM(V_DIVISION_ID) IS NULL OR UPPER(TRIM(V_DIVISION_ID)) = 'ALL'
               -- 2026.09.30 AJS 조회조건 ALL 처리 (END)
                   OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                          FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
               -- 2026.09.30 AJS 조회조건 ALL 처리 (START)
               -- AND (TRIM(V_SCM_SITE_ID) IS NULL
           AND (TRIM(V_SCM_SITE_ID) IS NULL OR UPPER(TRIM(V_SCM_SITE_ID)) = 'ALL'
               -- 2026.09.30 AJS 조회조건 ALL 처리 (END)
                   -- 2026.11.03 AJS SCM Site 전체 선택 200자 잘림 조치 (START)
                   -- OR UPPER(A.SCM_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE)
                   --                               FROM TABLE(STRING_SPLIT(V_SCM_SITE_ID, ','))))
                   OR DBMS_LOB.INSTR(V_SCM_SITE_LIST, ',' || REPLACE(UPPER(A.SCM_SITE_ID), ' ', '') || ',') > 0)
                   -- 2026.11.03 AJS SCM Site 전체 선택 200자 잘림 조치 (END)
               -- 2026.09.30 AJS 조회조건 ALL 처리 (START)
               -- AND (TRIM(V_VALUE_TYPE) IS NULL
           AND (TRIM(V_VALUE_TYPE) IS NULL OR UPPER(TRIM(V_VALUE_TYPE)) = 'ALL'
               -- 2026.09.30 AJS 조회조건 ALL 처리 (END)
                   OR A.VALUE_TYPE IN (SELECT UPPER(COLUMN_VALUE)
                                         FROM TABLE(STRING_SPLIT(V_VALUE_TYPE, ','))))
               -- 2026.09.30 AJS 조회조건 ALL 처리 (START)
               -- AND (TRIM(V_VALID_YN) IS NULL
           AND (TRIM(V_VALID_YN) IS NULL OR UPPER(TRIM(V_VALID_YN)) = 'ALL'
               -- 2026.09.30 AJS 조회조건 ALL 처리 (END)
                   OR A.VALID_YN IN (SELECT UPPER(COLUMN_VALUE)
                                       FROM TABLE(STRING_SPLIT(V_VALID_YN, ','))))
               -- 2026.09.30 AJS 조회조건 ALL 처리 (START)
               -- AND (TRIM(V_PLAN_GROUP_ID) IS NULL
           AND (TRIM(V_PLAN_GROUP_ID) IS NULL OR UPPER(TRIM(V_PLAN_GROUP_ID)) = 'ALL'
               -- 2026.09.30 AJS 조회조건 ALL 처리 (END)
                   OR A.OPMZ_PLAN_GR_ID IN (SELECT UPPER(COLUMN_VALUE)
                                              FROM TABLE(STRING_SPLIT(V_PLAN_GROUP_ID, ','))))
               -- 2026.09.30 AJS 조회조건 ALL 처리 (START)
               -- AND (TRIM(V_STAGE) IS NULL
           AND (TRIM(V_STAGE) IS NULL OR UPPER(TRIM(V_STAGE)) = 'ALL'
               -- 2026.09.30 AJS 조회조건 ALL 처리 (END)
                   OR A.STAGE IN (SELECT UPPER(COLUMN_VALUE)
                                    FROM TABLE(STRING_SPLIT(V_STAGE, ','))))
           AND A.FROM_YYYYMMDD <= V_PERIOD_TO
           AND A.TO_YYYYMMDD   >= V_PERIOD_FROM
         ORDER BY FN_ASIS_SORT_KEY(A.VALUE_TYPE) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(C.OPMZ_PLAN_GR_NAME) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.SCM_SITE_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.STAGE) NULLS FIRST
                , TO_DATE(A.FROM_YYYYMMDD, 'YYYYMMDD')
                , TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD');    --[PJ20257329] 조회 정렬 변경 (2025-12-17)

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE
             , 'SUCCESS' AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0128_GET_SAFETY_STOCK;

/* Program ID  : P_SCP0128_SAVE_SAFETY_STOCK                                            */
/* Description : 안전재고 등록 · 수정 · 삭제                                        */
PROCEDURE P_SCP0128_SAVE_SAFETY_STOCK
(
    -- Add the parameters for the stored procedure here
    P_ACTIVE_FLAG       IN  CLOB
  , P_VALUE_TYPE        IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_OPMZ_PLAN_GR_ID   IN  CLOB
  , P_SCM_SITE_ID       IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_STAGE             IN  CLOB
  , P_FROM_YYYYMMDD     IN  CLOB
  , P_TO_YYYYMMDD       IN  CLOB
  , P_APL_QTY    IN  CLOB
  , P_VALUE_DESCRIPTION IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_PRE_VALUE_TYPE    IN  CLOB
  , P_PRE_DIVISION_ID   IN  CLOB
  , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
  , P_PRE_SCM_SITE_ID   IN  CLOB
  , P_PRE_ITEM_ID       IN  CLOB
  , P_PRE_STAGE         IN  CLOB
  , P_PRE_FROM_YYYYMMDD IN  CLOB
  , P_PRE_TO_YYYYMMDD   IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0128_SAVE_SAFETY_STOCK
 * Description  : STOCK 조정 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ20257329    최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - Initial Release
 *
 */
    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';
    /* 원문은 빈 문자와 견준다. Oracle 에서 빈 문자는 값이 없는 것이라 그대로 두면 판정이 뒤집힌다.
       값이 없을 때 원장 값과 절대 같아지지 않는 글자를 세워 원문과 같게 만든다 */
    C_NOMATCH           CONSTANT VARCHAR2(1 CHAR) := CHR(1);

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_VALUE_TYPE        VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_OPMZ_PLAN_GR_ID   VARCHAR2(4000 CHAR);
    V_SCM_SITE_ID       VARCHAR2(4000 CHAR);
    V_ITEM_ID           VARCHAR2(4000 CHAR);
    V_STAGE             VARCHAR2(4000 CHAR);
    V_FROM_YYYYMMDD     VARCHAR2(4000 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(4000 CHAR);
    V_APL_QTY    VARCHAR2(4000 CHAR);
    V_VALUE_DESCRIPTION VARCHAR2(4000 CHAR);
    V_VALID_YN          VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_USER_ID, 1, 4000));

    V_PRE_VALUE_TYPE    VARCHAR2(4000 CHAR);
    V_PRE_DIVISION_ID   VARCHAR2(4000 CHAR);
    V_PRE_PLAN_GR_ID    VARCHAR2(4000 CHAR);
    V_PRE_SCM_SITE_ID   VARCHAR2(4000 CHAR);
    V_PRE_ITEM_ID       VARCHAR2(4000 CHAR);
    V_PRE_STAGE         VARCHAR2(4000 CHAR);
    V_PRE_FROM_YYYYMMDD VARCHAR2(4000 CHAR);
    V_PRE_TO_YYYYMMDD   VARCHAR2(4000 CHAR);

    V_MAX_LOOP_CNT      NUMBER(10) := 0;
    V_MST_LOOP_CNT      NUMBER(10) := 0;
    V_CNT               NUMBER(10) := 0;

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0128_SAVE_SAFETY_STOCK';
    V_LOG_TYPE          VARCHAR2(30 CHAR);
    N_LOG_COUNT         NUMBER(10) := 0;
    V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
    V_DESCRIPTION       VARCHAR2(500 CHAR);
    D_EVENT_DATE        DATE;
    V_SQLERRM           VARCHAR2(4000 CHAR);
BEGIN

    -- LOG 용 변수 설정
    -- START/END/ERROR/...
    -- 예외처리 변수 설정
    -- 트렌젝션 시작
    -- 시작 LOG
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    /* 넘어온 줄 수 */
    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, C_DELIMITER);

    WHILE LENGTH(P_ACTIVE_FLAG) > 0
      AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP

        V_MST_LOOP_CNT      := V_MST_LOOP_CNT + 1;

        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        V_ACTIVE_FLAG       := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         C_DELIMITER, V_MST_LOOP_CNT);
        V_VALUE_TYPE        := SCM_ARR_SPL_VAL(P_VALUE_TYPE,          C_DELIMITER, V_MST_LOOP_CNT);
        V_DIVISION_ID       := SCM_ARR_SPL_VAL(P_DIVISION_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_OPMZ_PLAN_GR_ID   := SCM_ARR_SPL_VAL(P_OPMZ_PLAN_GR_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_SCM_SITE_ID       := SCM_ARR_SPL_VAL(P_SCM_SITE_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID           := SCM_ARR_SPL_VAL(P_ITEM_ID,             C_DELIMITER, V_MST_LOOP_CNT);
        V_STAGE             := SCM_ARR_SPL_VAL(P_STAGE,               C_DELIMITER, V_MST_LOOP_CNT);
        V_FROM_YYYYMMDD     := SCM_ARR_SPL_VAL(P_FROM_YYYYMMDD,       C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_YYYYMMDD       := SCM_ARR_SPL_VAL(P_TO_YYYYMMDD,         C_DELIMITER, V_MST_LOOP_CNT);
        V_APL_QTY    := SCM_ARR_SPL_VAL(P_APL_QTY,      C_DELIMITER, V_MST_LOOP_CNT);
        V_VALUE_DESCRIPTION := SCM_ARR_SPL_VAL(P_VALUE_DESCRIPTION,   C_DELIMITER, V_MST_LOOP_CNT);
        V_VALID_YN          := SCM_ARR_SPL_VAL(P_VALID_YN,            C_DELIMITER, V_MST_LOOP_CNT);

        V_PRE_VALUE_TYPE    := SCM_ARR_SPL_VAL(P_PRE_VALUE_TYPE,      C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_DIVISION_ID   := SCM_ARR_SPL_VAL(P_PRE_DIVISION_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLAN_GR_ID    := SCM_ARR_SPL_VAL(P_PRE_OPMZ_PLAN_GR_ID, C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_SCM_SITE_ID   := SCM_ARR_SPL_VAL(P_PRE_SCM_SITE_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_ITEM_ID       := SCM_ARR_SPL_VAL(P_PRE_ITEM_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_STAGE         := SCM_ARR_SPL_VAL(P_PRE_STAGE,           C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_FROM_YYYYMMDD := SCM_ARR_SPL_VAL(P_PRE_FROM_YYYYMMDD,   C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_TO_YYYYMMDD   := SCM_ARR_SPL_VAL(P_PRE_TO_YYYYMMDD,     C_DELIMITER, V_MST_LOOP_CNT);

        /* 삭제가 아닌 경우 중복 확인 */
        --삭제가 아닌 경우, 중복체크
        IF V_ACTIVE_FLAG <> 'D'
        THEN

            /***** 중복체크 *****/
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCP_OPMZ_SAFETY_STOCK
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND SCM_SITE_ID     = V_SCM_SITE_ID
               AND STAGE           = V_STAGE
               AND VALUE_TYPE      = V_VALUE_TYPE
               AND ITEM_ID         = V_ITEM_ID
               AND FROM_YYYYMMDD   = V_FROM_YYYYMMDD
               AND TO_YYYYMMDD     = V_TO_YYYYMMDD
               AND NOT (DIVISION_ID = NVL(V_PRE_DIVISION_ID, C_NOMATCH) AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH) AND SCM_SITE_ID = NVL(V_PRE_SCM_SITE_ID, C_NOMATCH) AND STAGE = NVL(V_PRE_STAGE, C_NOMATCH) AND VALUE_TYPE = NVL(V_PRE_VALUE_TYPE, C_NOMATCH) AND ITEM_ID = NVL(V_PRE_ITEM_ID, C_NOMATCH) AND FROM_YYYYMMDD = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH) AND TO_YYYYMMDD = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH));

            IF V_CNT > 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, ' 신규 입력 데이터 중 중복된 데이터가 있습니다.');    --예외발생
            END IF;

            /**** 날짜 중복 체크 ****/
            SELECT COUNT(1)
              INTO V_CNT
              FROM SCP_OPMZ_SAFETY_STOCK X
             WHERE X.DIVISION_ID     = V_DIVISION_ID
               AND X.OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND X.SCM_SITE_ID     = V_SCM_SITE_ID
               AND X.STAGE           = V_STAGE
               AND X.VALUE_TYPE      = V_VALUE_TYPE
               AND X.ITEM_ID         = V_ITEM_ID
               AND NOT (V_TO_YYYYMMDD < X.FROM_YYYYMMDD OR V_FROM_YYYYMMDD > X.TO_YYYYMMDD)
               AND NOT (X.FROM_YYYYMMDD = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH) AND X.TO_YYYYMMDD = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH));   /* 기존 값 */

            IF V_CNT > 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, ' 입력 데이터 중 날짜가 중복되는 데이터가 있습니다.');    --예외발생
            END IF;
            /***** 중복체크 *****/

        END IF;

        IF V_ACTIVE_FLAG = 'I'
        THEN

            INSERT
              INTO SCP_OPMZ_SAFETY_STOCK
                 ( DIVISION_ID
                 , OPMZ_PLAN_GR_ID
                 , SCM_SITE_ID
                 , STAGE
                 , ITEM_ID
                 , VALUE_TYPE
                 , FROM_YYYYMMDD
                 , TO_YYYYMMDD
                 , APL_QTY
                 , VALUE_DESCRIPTION
                 , VALID_YN
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE)
            VALUES
                 ( V_DIVISION_ID
                 , V_OPMZ_PLAN_GR_ID
                 , V_SCM_SITE_ID
                 , V_STAGE
                 , V_ITEM_ID
                 , V_VALUE_TYPE
                 , V_FROM_YYYYMMDD
                 , V_TO_YYYYMMDD
                 , TO_NUMBER(V_APL_QTY)
                 , V_VALUE_DESCRIPTION
                 , V_VALID_YN
                 , V_LAST_UPDATED_BY
                 , SYSDATE
                 , V_LAST_UPDATED_BY
                 , SYSDATE);

        ELSIF V_ACTIVE_FLAG = 'M'
        THEN

            UPDATE SCP_OPMZ_SAFETY_STOCK
               SET DIVISION_ID = V_DIVISION_ID
                 , OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
                 , SCM_SITE_ID = V_SCM_SITE_ID
                 , STAGE = V_STAGE
                 , ITEM_ID = V_ITEM_ID
                 , VALUE_TYPE = V_VALUE_TYPE
                 , FROM_YYYYMMDD = V_FROM_YYYYMMDD
                 , TO_YYYYMMDD = V_TO_YYYYMMDD
                 , APL_QTY = TO_NUMBER(V_APL_QTY)
                 , VALUE_DESCRIPTION = V_VALUE_DESCRIPTION
                 , VALID_YN = V_VALID_YN
                 , LAST_UPDATED_BY = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID     = NVL(V_PRE_DIVISION_ID, C_NOMATCH)
               AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH)
               AND SCM_SITE_ID     = NVL(V_PRE_SCM_SITE_ID, C_NOMATCH)
               AND STAGE           = NVL(V_PRE_STAGE, C_NOMATCH)
               AND ITEM_ID         = NVL(V_PRE_ITEM_ID, C_NOMATCH)
               AND VALUE_TYPE      = NVL(V_PRE_VALUE_TYPE, C_NOMATCH)
               AND FROM_YYYYMMDD   = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
               AND TO_YYYYMMDD     = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH);

        ELSIF V_ACTIVE_FLAG = 'D'                               /* 삭제기능 추가 (2025-07-16) */
        THEN

            DELETE
              FROM SCP_OPMZ_SAFETY_STOCK
             WHERE DIVISION_ID     = NVL(V_PRE_DIVISION_ID, C_NOMATCH)
               AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH)
               AND SCM_SITE_ID     = NVL(V_PRE_SCM_SITE_ID, C_NOMATCH)
               AND STAGE           = NVL(V_PRE_STAGE, C_NOMATCH)
               AND ITEM_ID         = NVL(V_PRE_ITEM_ID, C_NOMATCH)
               AND VALUE_TYPE      = NVL(V_PRE_VALUE_TYPE, C_NOMATCH)
               AND FROM_YYYYMMDD   = NVL(V_PRE_FROM_YYYYMMDD, C_NOMATCH)
               AND TO_YYYYMMDD     = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH);

        END IF;

    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

    /* 결과코드 · 결과 건수 반환 */
    OPEN O_RC1 FOR
        -- 결과코드, 결과 카운트 반환
        SELECT 'S' AS RESULT_CODE
             , V_MAX_LOOP_CNT AS RESULT_CNT
          FROM DUAL;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE
             , 'SUCCESS' AS RESULT_MESSAGE
          FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN
        V_SQLERRM := SQLERRM;

        ROLLBACK;    --입력 데이타 롤백 처리

        INSERT
          INTO SCM_SYS_LOG_BATCH
             ( PROGRAM_NAME
             , LOG_TYPE
             , LOG_COUNT
             , LOG_MESSAGE
             , DESCRIPTION
             , EVENT_DATE
             , CREATION_DATE
             , CREATED_BY
             , LAST_UPDATE_DATE
             , LAST_UPDATED_BY)
        VALUES
             ( V_PROGRAM_NAME
             , 'ERROR'
             , NULL
             , V_SQLERRM
             , NULL
             , SYSDATE
             , SYSDATE
             , V_PROGRAM_NAME
             , SYSDATE
             , V_PROGRAM_NAME);

        COMMIT;

        --IF @@TRANCOUNT > 0
        --	COMMIT WORK;
        OPEN O_RC1 FOR
            -- error코드, errror 메시지 반환
            SELECT 'F' AS RESULT_CODE
                 , SUBSTR(V_SQLERRM, 1, 4000) AS RESULT_CNT
              FROM DUAL;

        OPEN O_RESULT_CURSOR FOR
            SELECT '1' AS RESULT_CODE
                 , SUBSTR(V_SQLERRM, 1, 4000) AS RESULT_MESSAGE
              FROM DUAL;

END P_SCP0128_SAVE_SAFETY_STOCK;

END PKG_SCP0128;
/
