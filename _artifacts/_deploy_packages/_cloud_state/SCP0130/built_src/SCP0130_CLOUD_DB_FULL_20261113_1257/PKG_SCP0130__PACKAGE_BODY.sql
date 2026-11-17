PACKAGE BODY PKG_SCP0130
IS
    /*
     * Program ID   : PKG_SCP0130
     * Description  : SCP0130 Scheduled Reciept Information 화면 — 입고예정 · 가상 BOM 조회 · 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
     */

/* Program ID  : P_SCP0130_GET_SEARCH_INFO                                                          */
/* Description : 조회조건 초기값 (결과 아홉 묶음)                                                   */
PROCEDURE P_SCP0130_GET_SEARCH_INFO
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
  , O_RC8               OUT SYS_REFCURSOR
  , O_RC9               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
/*
 * Program ID   : SCP0130_GET_SEARCH_INFO
 * Description  : 자재/포장재 입고예정 조회 및 콤보박스 정보
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/25   kh    			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */
BEGIN

    /* 1. 계획 그룹 */
    OPEN O_RC1 FOR
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

    /* 3. 공정 */
    OPEN O_RC3 FOR
        --SELECT DISTINCT A.DIVISION_ID
        --	, SCM_SITE_ID AS CODE 
        --	, SCM_SITE_ID AS NAME
        --FROM   SCM_MST_SITE A WITH(NOLOCK) 
        --WHERE  1 = 1
        --AND A.SITE_TYPE = 'SALES'	
        --AND A.DIVISION_ID != '40'
        --AND A.VALID_YN = 'Y'	
        --UNION ALL
        --SELECT DISTINCT A.DIVISION_ID
        --	, A.SCM_SITE_ID AS CODE 
        --	, A.SCM_SITE_ID AS NAME
        --FROM   SCM_MST_SITE AS A WITH(NOLOCK) 
        --LEFT JOIN SCM_MST_SITE_ITEM AS B WITH(NOLOCK) 
        --	ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID
        --WHERE  1 = 1
        --AND A.SITE_TYPE = 'SALES'
        --AND  A.DIVISION_ID = '40'
        --AND A.VALID_YN = 'Y'
        --UNION ALL
        --SELECT DISTINCT A.DIVISION_ID
        --	, SCM_SITE_ID AS CODE 
        --	, SCM_SITE_ID AS NAME
        --FROM   [dbo].[SCM_MST_SITE] A
        --WHERE  1 = 1
        --AND    A.SITE_TYPE = 'PLANT'
        --ORDER BY A.DIVISION_ID
        -- 3. STAGE 최적화 
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

    /* 6. 자재 — 가상 BOM 에 등록한 하위 품목 */
    OPEN O_RC6 FOR
        -- 6. MATERIAL ID/ Vitual BOM에서 생성한 Child ID
        SELECT DISTINCT A.ITEM_ID_CHILD AS CODE
             , A.ITEM_ID_CHILD AS NAME
             , A.DIVISION_ID
             , A.OPMZ_PLAN_GR_ID
             , A.PLANT_SITE_ID
             , A.TO_YYYYMMDD
          FROM SCP_OPMZ_VIRTUAL_BOM A
         WHERE A.VALID_YN = 'Y'
         ORDER BY FN_ASIS_SORT_KEY(A.ITEM_ID_CHILD) NULLS FIRST;

    /* 7. 품목 공정그룹 */
    OPEN O_RC7 FOR
        -- 7.Item정보 Operation Group 조회용
        SELECT DIVISION_ID
             , ITEM_ID
             , OPERATION_GROUP
          FROM SCP_MST_FINAL_ITEM
         ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정 */
                , FN_ASIS_SORT_KEY(ITEM_ID) NULLS FIRST;

    /* 8. 사업부별 공장 사이트 */
    OPEN O_RC8 FOR
        -- 8.PLANT_SITE_BY_DIVISION
        SELECT DISTINCT A.DIVISION_ID
             , A.SCM_SITE_ID AS CODE
             , A.SCM_SITE_ID AS NAME
             , B.OPMZ_PLAN_GR_ID
          FROM SCM_MST_SITE A
             , SCP_OPMZ_VIRTUAL_BOM B
         WHERE B.PLANT_SITE_ID(+) = A.SCM_SITE_ID
           AND A.SITE_TYPE = 'PLANT'
           AND A.VALID_YN  = 'Y'
         ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.SCM_SITE_ID) NULLS FIRST;

    /* 9. 가상 BOM 에 등록된 계획 그룹 */
    OPEN O_RC9 FOR
        --SELECT DISTINCT A.DIVISION_ID
        --	, SCM_SITE_ID AS CODE 
        --	, SCM_SITE_ID AS NAME
        --FROM   [dbo].[SCM_MST_SITE] A  WITH(NOLOCK)
        --WHERE  1 = 1
        --AND    A.SITE_TYPE = 'PLANT'
        --AND    A.VALID_YN  = 'Y'
        --ORDER BY A.DIVISION_ID
        -- 9.vIRTUAL등록된 PLANG Group
        SELECT DISTINCT A.OPMZ_PLAN_GR_ID AS CODE
             , B.OPMZ_PLAN_GR_NAME AS NAME
             , A.DIVISION_ID
          FROM SCP_OPMZ_VIRTUAL_BOM A
             , SCP_OPMZ_PLAN_GR_M B
         WHERE B.OPMZ_PLAN_GR_ID = A.OPMZ_PLAN_GR_ID
           AND B.DIVISION_ID     = A.DIVISION_ID
         ORDER BY FN_ASIS_SORT_KEY(B.OPMZ_PLAN_GR_NAME) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE
             , 'SUCCESS' AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0130_GET_SEARCH_INFO;

/* Program ID  : P_SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION                                        */
/* Description : 입고예정 조회                                                                      */
PROCEDURE P_SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION
(
    P_DIVISION_ID       IN  CLOB
  , P_PLAN_GROUP_ID     IN  CLOB
  , P_PLANT_SITE_ID     IN  CLOB
  , P_ITEM_ID_CHILD     IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_FROM_DATE         IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION
 * Description  : 자재/포장재 입고예정 정보  SCHEDULED_RECIEPT_INFORMATION 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */
    /* 원문이 조회조건을 NVARCHAR(200) 변수로 받아 200자에서 자른다 */
    V_DIVISION_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID,   1, 200));
    V_PLAN_GROUP_ID     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PLAN_GROUP_ID, 1, 200));
    V_PLANT_SITE_ID     VARCHAR2(4000 CHAR)  := TO_CHAR(SUBSTR(P_PLANT_SITE_ID, 1, 4000));  --  2026.11.09 AJS
    V_ITEM_ID_CHILD     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_ITEM_ID_CHILD, 1, 200));
    V_VALID_YN          VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_VALID_YN,      1, 200));
    /* 부분일치 조건과 기간 조건은 원문이 자르지 않은 값을 쓴다 */
    V_ITEM_ID_CHILD_ALL VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID_CHILD, 1, 32767));
    V_FROM_DATE         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_FROM_DATE,     1, 32767));
BEGIN

    -- 파라미터로 받을 값 변수  
    OPEN O_RC1 FOR
        SELECT IB.DIVISION_ID
             , IB.OPMZ_PLAN_GR_ID
             , IB.PLANT_SITE_ID
             , IB.ITEM_ID_CHILD
             , IB.TO_YYYYMMDD_DT AS TO_YYYYMMDD
             , IB.TO_EXPC_QTY
             , IB.VALUE_DESCRIPTION
             , IB.VALID_YN
             , IB.CREATED_BY
             , IB.CREATION_DATE
             , IB.LAST_UPDATED_BY
             , IB.LAST_UPDATE_DATE
             , IB.PRE_KEY_VALUES
          FROM (SELECT DISTINCT A.DIVISION_ID
                     , A.OPMZ_PLAN_GR_ID
                     , A.PLANT_SITE_ID
                     , A.ITEM_ID_CHILD
                     , A.TO_YYYYMMDD
                     , TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD') AS TO_YYYYMMDD_DT
                     , A.TO_EXPC_QTY
                     , A.VALUE_DESCRIPTION
                     , A.VALID_YN
                     , A.CREATED_BY
                     , A.CREATION_DATE
                     , A.LAST_UPDATED_BY
                     , A.LAST_UPDATE_DATE
                       /* ★하위 품목이 두 번 들어가는 것은 원문 그대로다.
                           원문은 값이 없는 칸이 섞이면 결과 전체가 빈 값이 되지만, 원장 실측상 값이 없는 행은
                           없고 빈 문자만 있어(설명 18/20행) 그대로 이어 붙이면 원문과 같다 */
                     , A.DIVISION_ID||'|'||A.OPMZ_PLAN_GR_ID||'|'||A.PLANT_SITE_ID||'|'||A.ITEM_ID_CHILD||'|'||A.ITEM_ID_CHILD||'|'||A.TO_YYYYMMDD||'|'||A.TO_EXPC_QTY||'|'||A.VALID_YN||'|'||A.VALUE_DESCRIPTION AS PRE_KEY_VALUES
                  FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION A
                     , SCP_OPMZ_VIRTUAL_BOM C
                     , (SELECT DISTINCT '%'||UPPER(COLUMN_VALUE)||'%' AS TST
                          FROM TABLE(STRING_SPLIT(V_ITEM_ID_CHILD_ALL, ','))) IA
                 WHERE C.DIVISION_ID     = A.DIVISION_ID
                   AND C.OPMZ_PLAN_GR_ID = A.OPMZ_PLAN_GR_ID
                   AND C.PLANT_SITE_ID   = A.PLANT_SITE_ID
                   AND C.ITEM_ID_CHILD   = A.ITEM_ID_CHILD
                   AND C.VALID_YN        = 'Y'
                   AND (UPPER(V_ITEM_ID_CHILD) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.ITEM_ID_CHILD LIKE IA.TST)
                   AND A.TO_YYYYMMDD >= V_FROM_DATE
                       /* AS-IS 는 대소문자를 가리지 않는다. 원장 실측상 소문자가 섞인 칸은 사이트 하나뿐이라
                      사이트만 칸과 입력값을 함께, 나머지는 입력값만 대문자로 맞춘다 */
                   AND (TRIM(V_DIVISION_ID) IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                  FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                   AND (TRIM(V_PLANT_SITE_ID) IS NULL OR UPPER(V_PLANT_SITE_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR UPPER(A.PLANT_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                               FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))
                   AND (TRIM(V_VALID_YN) IS NULL OR UPPER(V_VALID_YN) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.VALID_YN IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                         FROM TABLE(STRING_SPLIT(V_VALID_YN, ','))))
                   AND (TRIM(V_PLAN_GROUP_ID) IS NULL OR UPPER(V_PLAN_GROUP_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.OPMZ_PLAN_GR_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                          FROM TABLE(STRING_SPLIT(V_PLAN_GROUP_ID, ','))))
                   AND (TRIM(V_ITEM_ID_CHILD) IS NULL OR UPPER(V_ITEM_ID_CHILD) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.ITEM_ID_CHILD IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                        FROM TABLE(STRING_SPLIT(V_ITEM_ID_CHILD, ','))))) IB
               /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정.
            ★안쪽에 DISTINCT 가 있어 정렬 열쇠를 바깥으로 빼야 한다(함께 쓰면 ORA-01791) */
         ORDER BY FN_ASIS_SORT_KEY(IB.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(IB.PLANT_SITE_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(IB.OPMZ_PLAN_GR_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(IB.ITEM_ID_CHILD) NULLS FIRST
                , FN_ASIS_SORT_KEY(IB.TO_YYYYMMDD) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE
             , 'SUCCESS' AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0130_GET_SCHEDULED_RECIEPT_INFORMATION;

/* Program ID  : P_SCP0130_GET_VIRTUAL_BOM                                                          */
/* Description : 가상 BOM 조회                                                                      */
PROCEDURE P_SCP0130_GET_VIRTUAL_BOM
(
    P_DIVISION_ID       IN  CLOB
  , P_PLAN_GROUP_ID     IN  CLOB
  , P_PLANT_SITE_ID     IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_ITEM_ID_CHILD     IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_FROM_DATE         IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0130_GET_VIRTUAL_BOM
 * Description  : 자재/포장재 입고예정 정보 VIRTUAL_BOM 조회
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */
    /* 원문이 조회조건을 NVARCHAR(200) 변수로 받아 200자에서 자른다 */
    V_DIVISION_ID       VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_DIVISION_ID,   1, 200));
    V_PLAN_GROUP_ID     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_PLAN_GROUP_ID, 1, 200));
    V_PLANT_SITE_ID     VARCHAR2(4000 CHAR)  := TO_CHAR(SUBSTR(P_PLANT_SITE_ID, 1, 4000));  --  2026.11.09 AJS
    V_ITEM_ID           VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_ITEM_ID,       1, 200));
    V_ITEM_ID_CHILD     VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_ITEM_ID_CHILD, 1, 200));
    V_VALID_YN          VARCHAR2(200 CHAR)   := TO_CHAR(SUBSTR(P_VALID_YN,      1, 200));
    /* 부분일치 조건과 기간 조건은 원문이 자르지 않은 값을 쓴다 */
    V_ITEM_ID_ALL       VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID,       1, 32767));
    V_FROM_DATE         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_FROM_DATE,     1, 32767));
BEGIN

    -- 파라미터로 받을 값 변수  
    OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.OPMZ_PLAN_GR_ID
             , A.PLANT_SITE_ID
             , A.ITEM_ID
             , A.ITEM_ID_CHILD
               /* ★입고예정 조회는 날짜형으로, 이 조회는 하이픈을 넣은 문자로 돌려준다(원문 그대로) */
             , CASE WHEN A.TO_YYYYMMDD IS NULL THEN '' ELSE TO_CHAR(TO_DATE(A.TO_YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS TO_YYYYMMDD
             , A.TO_EXPC_QTY
             , A.VALUE_DESCRIPTION
             , A.VALID_YN
             , A.CREATED_BY
             , A.CREATION_DATE
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
               /* ★원문은 값이 없는 칸이 섞이면 결과 전체가 빈 값이 되지만, 원장 실측상 값이 없는 행은
                   없고 빈 문자만 있어(설명 10/13행) 그대로 이어 붙이면 원문과 같다 */
             , A.DIVISION_ID||'|'||A.OPMZ_PLAN_GR_ID||'|'||A.PLANT_SITE_ID||'|'||A.ITEM_ID||'|'||A.ITEM_ID_CHILD||'|'||A.TO_YYYYMMDD||'|'||A.TO_EXPC_QTY||'|'||A.VALID_YN||'|'||A.VALUE_DESCRIPTION AS PRE_KEY_VALUES
          FROM SCP_OPMZ_VIRTUAL_BOM A
             , (SELECT DISTINCT '%'||UPPER(COLUMN_VALUE)||'%' AS TST
                  FROM TABLE(STRING_SPLIT(V_ITEM_ID_ALL, ','))) IA
         WHERE (UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR UPPER(A.ITEM_ID) LIKE IA.TST)   /* 2026.11.13 조회조건 대소문자 무시 */
           AND CASE WHEN A.TO_YYYYMMDD IS NULL THEN '99991231' ELSE A.TO_YYYYMMDD END >= V_FROM_DATE
               /* AS-IS 는 대소문자를 가리지 않는다 */
           AND (TRIM(V_DIVISION_ID) IS NULL OR UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.DIVISION_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                          FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
           AND (TRIM(V_PLANT_SITE_ID) IS NULL OR UPPER(V_PLANT_SITE_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR UPPER(A.PLANT_SITE_ID) IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                       FROM TABLE(STRING_SPLIT(V_PLANT_SITE_ID, ','))))
           AND (TRIM(V_VALID_YN) IS NULL OR UPPER(V_VALID_YN) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.VALID_YN IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                 FROM TABLE(STRING_SPLIT(V_VALID_YN, ','))))
           AND (TRIM(V_PLAN_GROUP_ID) IS NULL OR UPPER(V_PLAN_GROUP_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.OPMZ_PLAN_GR_ID IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                  FROM TABLE(STRING_SPLIT(V_PLAN_GROUP_ID, ','))))
           AND (TRIM(V_ITEM_ID) IS NULL OR UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)   /* 2026.11.13 조회조건 대소문자 무시 */
                                                                                                              FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
           AND (TRIM(V_ITEM_ID_CHILD) IS NULL OR UPPER(V_ITEM_ID_CHILD) = 'ALL' /* 조회조건 ALL 은 조건 없음 */ OR A.ITEM_ID_CHILD IN (SELECT UPPER(COLUMN_VALUE)
                                                                                                                                FROM TABLE(STRING_SPLIT(V_ITEM_ID_CHILD, ','))))
               /* 원문에 정렬이 없어 화면 순서가 흔들린다 — 원장 열쇠 순서와 같게 고정 */
         ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.PLANT_SITE_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.OPMZ_PLAN_GR_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST
                , FN_ASIS_SORT_KEY(A.ITEM_ID_CHILD) NULLS FIRST;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS RESULT_CODE
             , 'SUCCESS' AS RESULT_MESSAGE
          FROM DUAL;

END P_SCP0130_GET_VIRTUAL_BOM;
/* Program ID  : P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION                                       */
/* Description : 입고예정 등록 · 수정 · 삭제                                                        */
PROCEDURE P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION
(
    -- Add the parameters for the stored procedure here
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_OPMZ_PLAN_GR_ID   IN  CLOB
  , P_PLANT_SITE_ID     IN  CLOB
  , P_ITEM_ID_CHILD     IN  CLOB
  , P_TO_YYYYMMDD       IN  CLOB
  , P_TO_EXPC_QTY       IN  CLOB
  , P_VALUE_DESCRIPTION IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_PRE_DIVISION_ID   IN  CLOB
  , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
  , P_PRE_PLANT_SITE_ID IN  CLOB
  , P_PRE_ITEM_ID_CHILD IN  CLOB
  , P_PRE_TO_YYYYMMDD   IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION
 * Description  : 자재/포장재 입고예정 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 *
 */
    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';
    /* 원문은 빈 문자와 견준다. Oracle 에서 빈 문자는 값이 없는 것이라 그대로 두면 판정이 뒤집힌다.
       값이 없을 때 원장 값과 절대 같아지지 않는 글자를 세워 원문과 같게 만든다 */
    C_NOMATCH           CONSTANT VARCHAR2(1 CHAR) := CHR(1);

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_OPMZ_PLAN_GR_ID   VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID     VARCHAR2(4000 CHAR);
    V_ITEM_ID_CHILD     VARCHAR2(4000 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(4000 CHAR);
    V_TO_EXPC_QTY       VARCHAR2(4000 CHAR);
    V_VALUE_DESCRIPTION VARCHAR2(4000 CHAR);
    V_VALID_YN          VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_USER_ID, 1, 4000));

    V_PRE_DIVISION_ID   VARCHAR2(4000 CHAR);
    V_PRE_PLAN_GR_ID    VARCHAR2(4000 CHAR);
    V_PRE_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    V_PRE_ITEM_ID_CHILD VARCHAR2(4000 CHAR);
    V_PRE_TO_YYYYMMDD   VARCHAR2(4000 CHAR);

    V_MAX_LOOP_CNT      NUMBER(10) := 0;
    V_MST_LOOP_CNT      NUMBER(10) := 0;
    V_CNT               NUMBER(10) := 0;

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION';
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

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, C_DELIMITER);

    WHILE LENGTH(P_ACTIVE_FLAG) > 0
      AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP

        V_MST_LOOP_CNT      := V_MST_LOOP_CNT + 1;

        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        V_ACTIVE_FLAG       := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         C_DELIMITER, V_MST_LOOP_CNT);
        V_DIVISION_ID       := SCM_ARR_SPL_VAL(P_DIVISION_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_OPMZ_PLAN_GR_ID   := SCM_ARR_SPL_VAL(P_OPMZ_PLAN_GR_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PLANT_SITE_ID     := SCM_ARR_SPL_VAL(P_PLANT_SITE_ID,       C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID_CHILD     := SCM_ARR_SPL_VAL(P_ITEM_ID_CHILD,       C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_YYYYMMDD       := SCM_ARR_SPL_VAL(P_TO_YYYYMMDD,         C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_EXPC_QTY       := SCM_ARR_SPL_VAL(P_TO_EXPC_QTY,         C_DELIMITER, V_MST_LOOP_CNT);
        V_VALUE_DESCRIPTION := SCM_ARR_SPL_VAL(P_VALUE_DESCRIPTION,   C_DELIMITER, V_MST_LOOP_CNT);
        V_VALID_YN          := SCM_ARR_SPL_VAL(P_VALID_YN,            C_DELIMITER, V_MST_LOOP_CNT);

        V_PRE_DIVISION_ID   := SCM_ARR_SPL_VAL(P_PRE_DIVISION_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLAN_GR_ID    := SCM_ARR_SPL_VAL(P_PRE_OPMZ_PLAN_GR_ID, C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLANT_SITE_ID := SCM_ARR_SPL_VAL(P_PRE_PLANT_SITE_ID,   C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_ITEM_ID_CHILD := SCM_ARR_SPL_VAL(P_PRE_ITEM_ID_CHILD,   C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_TO_YYYYMMDD   := SCM_ARR_SPL_VAL(P_PRE_TO_YYYYMMDD,     C_DELIMITER, V_MST_LOOP_CNT);

        /* 삭제가 아닌 경우 중복 확인 */
        --삭제가 아닌 경우, 중복체크
        IF V_ACTIVE_FLAG <> 'D'
        THEN

            /***** 중복체크 *****/
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND PLANT_SITE_ID   = V_PLANT_SITE_ID
               AND ITEM_ID_CHILD   = V_ITEM_ID_CHILD
               AND TO_YYYYMMDD     = V_TO_YYYYMMDD
               AND NOT (DIVISION_ID = NVL(V_PRE_DIVISION_ID, C_NOMATCH) AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH) AND PLANT_SITE_ID = NVL(V_PRE_PLANT_SITE_ID, C_NOMATCH) AND ITEM_ID_CHILD = NVL(V_PRE_ITEM_ID_CHILD, C_NOMATCH) AND TO_YYYYMMDD = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH));

            IF V_CNT > 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, ' 신규 입력 데이터 중 중복된 데이터가 있습니다.');    --예외발생
            END IF;
            /***** 중복체크 *****/

        END IF;

        IF V_ACTIVE_FLAG = 'I'
        THEN

            INSERT
              INTO SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION
                 ( DIVISION_ID
                 , OPMZ_PLAN_GR_ID
                 , PLANT_SITE_ID
                 , ITEM_ID_CHILD
                 , TO_YYYYMMDD
                 , TO_EXPC_QTY
                 , VALUE_DESCRIPTION
                 , VALID_YN
                 , CREATED_BY
                 , CREATION_DATE
                 , LAST_UPDATED_BY
                 , LAST_UPDATE_DATE)
            VALUES
                 ( V_DIVISION_ID
                 , V_OPMZ_PLAN_GR_ID
                 , V_PLANT_SITE_ID
                 , V_ITEM_ID_CHILD
                 , V_TO_YYYYMMDD
                 , V_TO_EXPC_QTY
                 , V_VALUE_DESCRIPTION
                 , V_VALID_YN
                 , V_LAST_UPDATED_BY
                 , SYSDATE
                 , V_LAST_UPDATED_BY
                 , SYSDATE);

        ELSIF V_ACTIVE_FLAG = 'M'
        THEN

            UPDATE SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION
               SET DIVISION_ID = V_DIVISION_ID
                 , OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
                 , PLANT_SITE_ID = V_PLANT_SITE_ID
                 , ITEM_ID_CHILD = V_ITEM_ID_CHILD
                 , TO_YYYYMMDD = V_TO_YYYYMMDD
                 , TO_EXPC_QTY = V_TO_EXPC_QTY
                 , VALUE_DESCRIPTION = V_VALUE_DESCRIPTION
                 , VALID_YN = V_VALID_YN
                 , LAST_UPDATED_BY = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID     = NVL(V_PRE_DIVISION_ID, C_NOMATCH)
               AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH)
               AND PLANT_SITE_ID   = NVL(V_PRE_PLANT_SITE_ID, C_NOMATCH)
               AND ITEM_ID_CHILD   = NVL(V_PRE_ITEM_ID_CHILD, C_NOMATCH)
               AND TO_YYYYMMDD     = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH);

        ELSIF V_ACTIVE_FLAG = 'D'                               /* 삭제기능 추가 (2025-07-16) */
        THEN

            DELETE
              FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION
             WHERE DIVISION_ID     = NVL(V_PRE_DIVISION_ID, C_NOMATCH)
               AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH)
               AND PLANT_SITE_ID   = NVL(V_PRE_PLANT_SITE_ID, C_NOMATCH)
               AND ITEM_ID_CHILD   = NVL(V_PRE_ITEM_ID_CHILD, C_NOMATCH)
               AND TO_YYYYMMDD     = NVL(V_PRE_TO_YYYYMMDD, C_NOMATCH);

        END IF;

    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

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

END P_SCP0130_SAVE_SCHEDULED_RECIEPT_INFORMATION;

/* Program ID  : P_SCP0130_SVAE_VIRTUAL_BOM                                                         */
/* Description : 가상 BOM 등록 · 수정 · 삭제 (원문 이름의 오타를 그대로 둔다)                       */
PROCEDURE P_SCP0130_SVAE_VIRTUAL_BOM
(
    -- Add the parameters for the stored procedure here
    P_ACTIVE_FLAG       IN  CLOB
  , P_DIVISION_ID       IN  CLOB
  , P_OPMZ_PLAN_GR_ID   IN  CLOB
  , P_PLANT_SITE_ID     IN  CLOB
  , P_ITEM_ID           IN  CLOB
  , P_ITEM_ID_CHILD     IN  CLOB
  , P_TO_YYYYMMDD       IN  CLOB
  , P_TO_EXPC_QTY       IN  CLOB
  , P_VALUE_DESCRIPTION IN  CLOB
  , P_VALID_YN          IN  CLOB
  , P_USER_ID           IN  CLOB
  , P_PRE_DIVISION_ID   IN  CLOB
  , P_PRE_OPMZ_PLAN_GR_ID IN CLOB
  , P_PRE_PLANT_SITE_ID IN  CLOB
  , P_PRE_ITEM_ID       IN  CLOB
  , P_PRE_ITEM_ID_CHILD IN  CLOB
  , O_RC1               OUT SYS_REFCURSOR
  , O_RESULT_CURSOR     OUT SYS_REFCURSOR
)
IS
    /*
 * Program ID   : SCP0130_SVAE_VIRTUAL_BOM
 * Description  : VIRTUAL_BOM 등록,수정 
 * Program History
 *===================================================================================================
 *   Date       In Charge		Description
 *===================================================================================================
 * 2025/07/24   kh   			PJ2024A332R 독립적 Planning 체계 및 Master Validation UI 구축 - Initial Release
 * 2025/11/24   mrchois    		PJ20257329  최적화 Planning Input Constraint UI 개발 및 Master Validation 확산 - ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN
 *
 */
    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';
    C_NOMATCH           CONSTANT VARCHAR2(1 CHAR) := CHR(1);

    V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
    V_DIVISION_ID       VARCHAR2(4000 CHAR);
    V_OPMZ_PLAN_GR_ID   VARCHAR2(4000 CHAR);
    V_PLANT_SITE_ID     VARCHAR2(4000 CHAR);
    V_ITEM_ID           VARCHAR2(4000 CHAR);
    V_ITEM_ID_CHILD     VARCHAR2(4000 CHAR);
    V_TO_YYYYMMDD       VARCHAR2(4000 CHAR);
    V_TO_EXPC_QTY       VARCHAR2(4000 CHAR);
    V_VALUE_DESCRIPTION VARCHAR2(4000 CHAR);
    V_VALID_YN          VARCHAR2(4000 CHAR);
    V_LAST_UPDATED_BY   VARCHAR2(4000 CHAR) := TO_CHAR(SUBSTR(P_USER_ID, 1, 4000));

    V_PRE_DIVISION_ID   VARCHAR2(4000 CHAR);
    V_PRE_PLAN_GR_ID    VARCHAR2(4000 CHAR);
    V_PRE_PLANT_SITE_ID VARCHAR2(4000 CHAR);
    V_PRE_ITEM_ID       VARCHAR2(4000 CHAR);
    V_PRE_ITEM_ID_CHILD VARCHAR2(4000 CHAR);

    V_MAX_LOOP_CNT      NUMBER(10) := 0;
    V_MST_LOOP_CNT      NUMBER(10) := 0;
    V_CNT               NUMBER(10) := 0;

    V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SCP0130_SVAE_VIRTUAL_BOM';
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

    -- 프로시저 LOOP 길이를 판단
    V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, C_DELIMITER);

    WHILE LENGTH(P_ACTIVE_FLAG) > 0
      AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
    LOOP

        V_MST_LOOP_CNT      := V_MST_LOOP_CNT + 1;

        -- 각 컬럼들에 대한 스플릿처리로직 스타트
        V_ACTIVE_FLAG       := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         C_DELIMITER, V_MST_LOOP_CNT);
        V_DIVISION_ID       := SCM_ARR_SPL_VAL(P_DIVISION_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_OPMZ_PLAN_GR_ID   := SCM_ARR_SPL_VAL(P_OPMZ_PLAN_GR_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PLANT_SITE_ID     := SCM_ARR_SPL_VAL(P_PLANT_SITE_ID,       C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID           := SCM_ARR_SPL_VAL(P_ITEM_ID,             C_DELIMITER, V_MST_LOOP_CNT);
        V_ITEM_ID_CHILD     := SCM_ARR_SPL_VAL(P_ITEM_ID_CHILD,       C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_YYYYMMDD       := SCM_ARR_SPL_VAL(P_TO_YYYYMMDD,         C_DELIMITER, V_MST_LOOP_CNT);
        V_TO_EXPC_QTY       := SCM_ARR_SPL_VAL(P_TO_EXPC_QTY,         C_DELIMITER, V_MST_LOOP_CNT);
        V_VALUE_DESCRIPTION := SCM_ARR_SPL_VAL(P_VALUE_DESCRIPTION,   C_DELIMITER, V_MST_LOOP_CNT);
        V_VALID_YN          := SCM_ARR_SPL_VAL(P_VALID_YN,            C_DELIMITER, V_MST_LOOP_CNT);

        V_PRE_DIVISION_ID   := SCM_ARR_SPL_VAL(P_PRE_DIVISION_ID,     C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLAN_GR_ID    := SCM_ARR_SPL_VAL(P_PRE_OPMZ_PLAN_GR_ID, C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_PLANT_SITE_ID := SCM_ARR_SPL_VAL(P_PRE_PLANT_SITE_ID,   C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_ITEM_ID       := SCM_ARR_SPL_VAL(P_PRE_ITEM_ID,         C_DELIMITER, V_MST_LOOP_CNT);
        V_PRE_ITEM_ID_CHILD := SCM_ARR_SPL_VAL(P_PRE_ITEM_ID_CHILD,   C_DELIMITER, V_MST_LOOP_CNT);

        /* 삭제가 아닌 경우 자재가 있는지 확인 */
        --삭제가 아닌 경우, 중복체크
        IF V_ACTIVE_FLAG <> 'D'
        THEN

            /*** Material 유효한 확인  START*****/
            /***** 중복체크 *****/
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCM_MST_ITEM_SN I
             WHERE I.ITEM_ID = V_ITEM_ID
               AND I.DIVISION_ID IN (SELECT XA.DIVISION_ID
                                       FROM (SELECT 1 AS ORD
                                                  , '81' AS ORG_DIVISION
                                                  , '81' AS DIVISION_ID
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 2
                                                  , '40'
                                                  , '40'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 3
                                                  , '82'
                                                  , '82'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 4
                                                  , 'EE'
                                                  , '81'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 4
                                                  , 'EE'
                                                  , '40'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 4
                                                  , 'EE'
                                                  , '82'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 5
                                                  , '81_UC'
                                                  , '81_UC'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 6
                                                  , 'EE_UC'
                                                  , '81_UC'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 7
                                                  , '81_HM'
                                                  , '81_HM'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 8
                                                  , 'EE_HM'
                                                  , '81_HM'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 9
                                                  , '81_ST'
                                                  , '81_ST'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 10
                                                  , 'EE_ST'
                                                  , '81_ST'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 11
                                                  , '81_HD'
                                                  , '81_HD'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 12
                                                  , 'EE_HD'
                                                  , '81_HD'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 13
                                                  , '81_HG'
                                                  , '81_HG'
                                               FROM DUAL
                                              UNION ALL
                                             SELECT 14
                                                  , 'EE_HG'
                                                  , '81_HG'
                                               FROM DUAL) XA --[PJ20257329]ITEM 유효성 체크 마스터 테이블 변경, SCP_MST_FINAL_ITEM -> SCM_MST_ITEM_SN (2025-11-24)
                                      WHERE XA.ORG_DIVISION = V_DIVISION_ID);

            IF V_CNT = 0
            THEN
                RAISE_APPLICATION_ERROR(-20020, ' Material 를 확인할 수 없습니다. (' || V_ITEM_ID || ')');
            END IF;
            /*** Material 유효한 확인  END *****/

        END IF;

        IF V_ACTIVE_FLAG = 'I'
        THEN

            /* ★원문은 열쇠가 있으면 고치고 없으면 넣는 한 문장을 쓴다.
                  온라인 조회 · 저장에서는 그 문장을 쓰지 않으므로 고치기와 넣기로 나눈다 */
            UPDATE SCP_OPMZ_VIRTUAL_BOM
               SET TO_YYYYMMDD = V_TO_YYYYMMDD
                 , TO_EXPC_QTY = V_TO_EXPC_QTY
                 , VALUE_DESCRIPTION = V_VALUE_DESCRIPTION
                 , VALID_YN = V_VALID_YN
                 , LAST_UPDATED_BY = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND PLANT_SITE_ID   = V_PLANT_SITE_ID
               AND ITEM_ID         = V_ITEM_ID
               AND ITEM_ID_CHILD   = V_ITEM_ID_CHILD;

            IF SQL%ROWCOUNT = 0
            THEN

                --예외발생
                INSERT
                  INTO SCP_OPMZ_VIRTUAL_BOM
                     ( DIVISION_ID
                     , OPMZ_PLAN_GR_ID
                     , PLANT_SITE_ID
                     , ITEM_ID
                     , ITEM_ID_CHILD
                     , TO_YYYYMMDD
                     , TO_EXPC_QTY
                     , VALUE_DESCRIPTION
                     , VALID_YN
                     , CREATED_BY
                     , CREATION_DATE
                     , LAST_UPDATED_BY
                     , LAST_UPDATE_DATE)
                VALUES
                     ( V_DIVISION_ID
                     , V_OPMZ_PLAN_GR_ID
                     , V_PLANT_SITE_ID
                     , V_ITEM_ID
                     , V_ITEM_ID_CHILD
                     , V_TO_YYYYMMDD
                     , V_TO_EXPC_QTY
                     , V_VALUE_DESCRIPTION
                     , V_VALID_YN
                     , V_LAST_UPDATED_BY
                     , SYSDATE
                     , V_LAST_UPDATED_BY
                     , SYSDATE);

            END IF;

        ELSIF V_ACTIVE_FLAG = 'M'
        THEN

            /* 변경하려는 데이타가 key 중복일 경우 체크 */
            SELECT COUNT(*)
              INTO V_CNT
              FROM SCP_OPMZ_VIRTUAL_BOM
             WHERE DIVISION_ID     = V_DIVISION_ID
               AND OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
               AND PLANT_SITE_ID   = V_PLANT_SITE_ID
               AND ITEM_ID         = V_ITEM_ID
               AND ITEM_ID_CHILD   = V_ITEM_ID_CHILD
               AND NOT (DIVISION_ID = NVL(V_PRE_DIVISION_ID, C_NOMATCH) AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH) AND PLANT_SITE_ID = NVL(V_PRE_PLANT_SITE_ID, C_NOMATCH) AND ITEM_ID = NVL(V_PRE_ITEM_ID, C_NOMATCH) AND ITEM_ID_CHILD = NVL(V_PRE_ITEM_ID_CHILD, C_NOMATCH));

            IF V_CNT > 0
            THEN
                RAISE_APPLICATION_ERROR(-20010, ' 입력 데이터 중 중복된 데이터가 있습니다.');    --예외발생
            END IF;

            UPDATE SCP_OPMZ_VIRTUAL_BOM
               SET DIVISION_ID = V_DIVISION_ID
                 , OPMZ_PLAN_GR_ID = V_OPMZ_PLAN_GR_ID
                 , PLANT_SITE_ID = V_PLANT_SITE_ID
                 , ITEM_ID = V_ITEM_ID
                 , ITEM_ID_CHILD = V_ITEM_ID_CHILD
                 , TO_YYYYMMDD = V_TO_YYYYMMDD
                 , TO_EXPC_QTY = V_TO_EXPC_QTY
                 , VALUE_DESCRIPTION = V_VALUE_DESCRIPTION
                 , VALID_YN = V_VALID_YN
                 , LAST_UPDATED_BY = V_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = SYSDATE
             WHERE DIVISION_ID     = NVL(V_PRE_DIVISION_ID, C_NOMATCH)
               AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH)
               AND PLANT_SITE_ID   = NVL(V_PRE_PLANT_SITE_ID, C_NOMATCH)
               AND ITEM_ID         = NVL(V_PRE_ITEM_ID, C_NOMATCH)
               AND ITEM_ID_CHILD   = NVL(V_PRE_ITEM_ID_CHILD, C_NOMATCH);

        ELSIF V_ACTIVE_FLAG = 'D'                               /* 삭제기능 추가 (2025-07-16) */
        THEN

            DELETE
              FROM SCP_OPMZ_VIRTUAL_BOM
             WHERE DIVISION_ID     = NVL(V_PRE_DIVISION_ID, C_NOMATCH)
               AND OPMZ_PLAN_GR_ID = NVL(V_PRE_PLAN_GR_ID, C_NOMATCH)
               AND PLANT_SITE_ID   = NVL(V_PRE_PLANT_SITE_ID, C_NOMATCH)
               AND ITEM_ID         = NVL(V_PRE_ITEM_ID, C_NOMATCH)
               AND ITEM_ID_CHILD   = NVL(V_PRE_ITEM_ID_CHILD, C_NOMATCH);

        END IF;

    END LOOP;

    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';
    V_DESCRIPTION := '';
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

    COMMIT;

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

END P_SCP0130_SVAE_VIRTUAL_BOM;

END PKG_SCP0130;