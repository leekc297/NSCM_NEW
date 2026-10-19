PACKAGE BODY PKG_SCP0018
IS
/*
 * Program ID   : PKG_SCP0018
 * Description  : SCP0018 Waterfall Shipment Plan Semi
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.26   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          [속도] 적재문 2곳 BOD 공용 뷰(SCP_MST_BOD_N_V)를 행마다 조회하지 않고 한 번 읽어 해시 조인
 */

    /*******************************************************************************
     * P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL
     *   AS-IS SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL
     *
     * 전환 기준
     *   1. AS-IS 임시 자료 한 종은 전역 임시 테이블(GT_0018)로 옮기고 시작할 때 비운다.
     *   2. AS-IS 가 문자열로 조립하던 적재문은 조건 분기가 있는 정적 SQL 로 바꾼다.
     *      조회 기간에 따라 칸 개수가 달라지는 마지막 피벗만 동적으로 둔다.
     *   3. 정렬은 AS-IS 순서를 내는 공용 함수 FN_ASIS_SORT_KEY 를 쓴다.
     *   4. 원본 MSSQL 주석은 형태 그대로 둔다.
     *******************************************************************************/
    PROCEDURE P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_VERSION_NO            IN  VARCHAR2
      , P_ELECTYPE              IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_QRY_SUM               CLOB;
        V_SQL                   CLOB;
        V_ERR_MSG               VARCHAR2(4000);

    BEGIN

        DBMS_LOB.CREATETEMPORARY(V_QRY_SUM, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_SQL,     TRUE);

        DELETE FROM GT_0018;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        /*==========================================================================
         * 임시테이블만들기
         *   AS-IS 는 사업부가 EE · EE_UC 인지에 따라 운송경로 조인 열쇠를 바꾸고,
         *   선택 조건 세 가지(버전 · 품목 · 전극구분)를 문자열로 붙인다.
         *
         *   ★버전을 한 벌씩 나누어 담는 까닭 : 원장 기본키가 (사업부 · 버전 · 마감일자 · …) 순인데
         *     버전을 목록(IN 서브질의)으로 걸면 기본키 선두를 쓰지 못하고
         *     건너뛰기 조회(INDEX SKIP SCAN)가 된다. 실측 253 초 · 버퍼 187 만 블록.
         *     버전을 한 값씩 같다(=)로 걸면 기본키 두 칸을 그대로 쓴다.
         *     AS-IS 는 버전 목록을 값으로 적어 넣어 같은 효과를 낸다.
         *     버전을 안 넘기면 AS-IS 처럼 조건 없이 담는다.
         *========================================================================*/
        IF TRIM(P_VERSION_NO) IS NOT NULL THEN

          FOR V IN (SELECT COLUMN_VALUE AS VER FROM TABLE(STRING_SPLIT(P_VERSION_NO, ',')))
          LOOP

            INSERT INTO GT_0018
            (
                KEY_IDX
              , DIVISION_ID
              , DIVISION_NAME
              , OPERATION_GROUP
              , OPERATION_GROUP_NAME
              , ITEM_ID
              , NICK_NAME
              , ELECTRODE_TYPE
              , ORIGIN_FROM_DIVISION_ID
              , FROM_SITE
              , FROM_SITE_NAME
              , TRANSPORT_MODE
              , LT_DAY
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , MEASURE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , ORIGIN_TO_DIVISION_ID
              , TO_SITE
              , TO_SITE_NAME
              , BOD_ID
              , QTY
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , YYYYMMDD
              , VERSION_NO
              , YYYYMM
              , ISO_WEEK
            )
--            SELECT DISTINCT    --  2026.10.06 AJS
            SELECT /*+ NO_PUSH_PRED(C) USE_HASH(C) */ DISTINCT    --  2026.10.06 AJS
                   (A.DIVISION_ID || A.OPERATION_GROUP || A.ITEM_ID || A.FROM_SITE)  AS KEY_IDX
                 , A.DIVISION_ID
                 , A.DIVISION_NAME
                 , A.OPERATION_GROUP
                 , A.OPERATION_GROUP_NAME
                 , A.ITEM_ID
                 , A.NICK_NAME
                 , CASE WHEN TRIM(A.ELECTRODE_TYPE) IS NULL THEN '/'
                        ELSE A.ELECTRODE_TYPE END                                    AS ELECTRODE_TYPE
                 , CASE WHEN TRIM(A.ORIGIN_FROM_DIVISION_ID) IS NULL THEN '/'
                        ELSE A.ORIGIN_FROM_DIVISION_ID END                           AS ORIGIN_FROM_DIVISION_ID
                 , A.FROM_SITE
                 , A.FROM_SITE_NAME
                 , C.TRANSPORT_MODE
                 , C.LT_TOTAL                                                        AS LT_DAY
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 /* , A.BOH */
                 , A.MEASURE
                 , B.COLUMN_LABEL_NAME                                               AS MEASURE_LABEL
                 , NVL(D.SORT_ORDER_NO, B.SORT_ORDER_NO)                             AS MEASURE_ORDER_NO
                 , CASE WHEN TRIM(A.ORIGIN_TO_DIVISION_ID) IS NULL THEN '-'
                        ELSE A.ORIGIN_TO_DIVISION_ID END                             AS ORIGIN_TO_DIVISION_ID
                 , A.TO_SITE
                 , A.TO_SITE_NAME
                 , A.BOD_ID
                 , A.QTY
                 , P_FROM_YYYYMMDD                                                   AS FROM_YYYYMMDD
                 , P_TO_YYYYMMDD                                                     AS TO_YYYYMMDD
                 , 'D_' || A.YYYYMMDD                                                AS YYYYMMDD
                 , A.VERSION_NO
                 , O.BASIS_YYYYMM                                                    AS YYYYMM
                 , SUBSTR(O.BASIS_YYYYMM, -4) || O.ISO_WEEK                          AS ISO_WEEK
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI_C  A
                 , SCM_SYS_CALENDAR_M            O
                 , SCM_MST_SHEET_MEASURE         B
                 , SCP_MST_BOD_N_V               C
                 , SCM_MST_TITLESET_USER         D
             WHERE A.YYYYMMDD = O.BASIS_YYYYMMDD
               AND A.MEASURE  = B.COLUMN_NAME
               /* BOD 2단계 개발 : 시작
                * AS-IS 는 사업부가 EE · EE_UC 면 원 출발 사업부로, 아니면 사업부로 잇는다. */
               AND CASE WHEN P_DIVISION_ID NOT IN ('EE', 'EE_UC') THEN A.DIVISION_ID
                        ELSE A.ORIGIN_FROM_DIVISION_ID END = C.DIVISION_ID(+)
               AND A.BOD_ID     = C.BOD_ID(+)
               AND A.FROM_SITE  = C.FROM_SITE(+)
               /* BOD 2단계 개발 : 끝 */
               AND D.PROGRAM_ID(+)  = B.PROGRAM_ID
               AND D.SHEET_NAME(+)  = B.SHEET_NAME
               AND D.COLUMN_NAME(+) = B.COLUMN_NAME
               AND D.USER_ID(+)     = P_USER_ID
               AND B.PROGRAM_ID = P_PROGRAM_ID
               AND B.SHEET_NAME = P_SHEET_NAME
               AND B.VALID_YN   = 'Y'
               AND ( V_CNT_USR_MEASURE = 0
                     OR EXISTS (SELECT 1
                                  FROM SCM_MST_TITLESET_USER
                                 WHERE PROGRAM_ID  = P_PROGRAM_ID
                                   AND SHEET_NAME  = P_SHEET_NAME
                                   AND USER_ID     = P_USER_ID
                                   AND COLUMN_NAME = B.COLUMN_NAME)
                   )
               AND A.YYYYMMDD        >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD        <= P_TO_YYYYMMDD
               AND A.DIVISION_ID      = P_DIVISION_ID
               AND A.OPERATION_GROUP  = P_OPERATION_GROUP
               AND A.VERSION_NO = V.VER
               AND ( TRIM(P_ITEM_ID) IS NULL
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))) )
               AND ( TRIM(P_ELECTYPE) IS NULL
                     OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))) );

          END LOOP;

        ELSE

            INSERT INTO GT_0018
            (
                KEY_IDX
              , DIVISION_ID
              , DIVISION_NAME
              , OPERATION_GROUP
              , OPERATION_GROUP_NAME
              , ITEM_ID
              , NICK_NAME
              , ELECTRODE_TYPE
              , ORIGIN_FROM_DIVISION_ID
              , FROM_SITE
              , FROM_SITE_NAME
              , TRANSPORT_MODE
              , LT_DAY
              , PLAN_START_YYYYMMDD
              , PLAN_TYPE
              , SEQ
              , MEASURE
              , MEASURE_LABEL
              , MEASURE_ORDER_NO
              , ORIGIN_TO_DIVISION_ID
              , TO_SITE
              , TO_SITE_NAME
              , BOD_ID
              , QTY
              , FROM_YYYYMMDD
              , TO_YYYYMMDD
              , YYYYMMDD
              , VERSION_NO
              , YYYYMM
              , ISO_WEEK
            )
--            SELECT DISTINCT    --  2026.10.06 AJS
            SELECT /*+ NO_PUSH_PRED(C) USE_HASH(C) */ DISTINCT    --  2026.10.06 AJS
                   (A.DIVISION_ID || A.OPERATION_GROUP || A.ITEM_ID || A.FROM_SITE)  AS KEY_IDX
                 , A.DIVISION_ID
                 , A.DIVISION_NAME
                 , A.OPERATION_GROUP
                 , A.OPERATION_GROUP_NAME
                 , A.ITEM_ID
                 , A.NICK_NAME
                 , CASE WHEN TRIM(A.ELECTRODE_TYPE) IS NULL THEN '/'
                        ELSE A.ELECTRODE_TYPE END                                    AS ELECTRODE_TYPE
                 , CASE WHEN TRIM(A.ORIGIN_FROM_DIVISION_ID) IS NULL THEN '/'
                        ELSE A.ORIGIN_FROM_DIVISION_ID END                           AS ORIGIN_FROM_DIVISION_ID
                 , A.FROM_SITE
                 , A.FROM_SITE_NAME
                 , C.TRANSPORT_MODE
                 , C.LT_TOTAL                                                        AS LT_DAY
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 /* , A.BOH */
                 , A.MEASURE
                 , B.COLUMN_LABEL_NAME                                               AS MEASURE_LABEL
                 , NVL(D.SORT_ORDER_NO, B.SORT_ORDER_NO)                             AS MEASURE_ORDER_NO
                 , CASE WHEN TRIM(A.ORIGIN_TO_DIVISION_ID) IS NULL THEN '-'
                        ELSE A.ORIGIN_TO_DIVISION_ID END                             AS ORIGIN_TO_DIVISION_ID
                 , A.TO_SITE
                 , A.TO_SITE_NAME
                 , A.BOD_ID
                 , A.QTY
                 , P_FROM_YYYYMMDD                                                   AS FROM_YYYYMMDD
                 , P_TO_YYYYMMDD                                                     AS TO_YYYYMMDD
                 , 'D_' || A.YYYYMMDD                                                AS YYYYMMDD
                 , A.VERSION_NO
                 , O.BASIS_YYYYMM                                                    AS YYYYMM
                 , SUBSTR(O.BASIS_YYYYMM, -4) || O.ISO_WEEK                          AS ISO_WEEK
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI_C  A
                 , SCM_SYS_CALENDAR_M            O
                 , SCM_MST_SHEET_MEASURE         B
                 , SCP_MST_BOD_N_V               C
                 , SCM_MST_TITLESET_USER         D
             WHERE A.YYYYMMDD = O.BASIS_YYYYMMDD
               AND A.MEASURE  = B.COLUMN_NAME
               /* BOD 2단계 개발 : 시작
                * AS-IS 는 사업부가 EE · EE_UC 면 원 출발 사업부로, 아니면 사업부로 잇는다. */
               AND CASE WHEN P_DIVISION_ID NOT IN ('EE', 'EE_UC') THEN A.DIVISION_ID
                        ELSE A.ORIGIN_FROM_DIVISION_ID END = C.DIVISION_ID(+)
               AND A.BOD_ID     = C.BOD_ID(+)
               AND A.FROM_SITE  = C.FROM_SITE(+)
               /* BOD 2단계 개발 : 끝 */
               AND D.PROGRAM_ID(+)  = B.PROGRAM_ID
               AND D.SHEET_NAME(+)  = B.SHEET_NAME
               AND D.COLUMN_NAME(+) = B.COLUMN_NAME
               AND D.USER_ID(+)     = P_USER_ID
               AND B.PROGRAM_ID = P_PROGRAM_ID
               AND B.SHEET_NAME = P_SHEET_NAME
               AND B.VALID_YN   = 'Y'
               AND ( V_CNT_USR_MEASURE = 0
                     OR EXISTS (SELECT 1
                                  FROM SCM_MST_TITLESET_USER
                                 WHERE PROGRAM_ID  = P_PROGRAM_ID
                                   AND SHEET_NAME  = P_SHEET_NAME
                                   AND USER_ID     = P_USER_ID
                                   AND COLUMN_NAME = B.COLUMN_NAME)
                   )
               AND A.YYYYMMDD        >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD        <= P_TO_YYYYMMDD
               AND A.DIVISION_ID      = P_DIVISION_ID
               AND A.OPERATION_GROUP  = P_OPERATION_GROUP
               AND ( TRIM(P_ITEM_ID) IS NULL
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_GET_ITEM_LIKE_CONDITION(P_ITEM_ID, ''))) )
               AND ( TRIM(P_ELECTYPE) IS NULL
                     OR A.ELECTRODE_TYPE IN (SELECT COLUMN_VALUE FROM TABLE(STRING_SPLIT(P_ELECTYPE, ','))) );

        END IF;

        /*==========================================================================
         * PIVOIT처리 - PIVOIT 대상 날짜문자열 생성
         *   ★정렬 보조 키(BLK) : AS-IS 는 정렬값이 같은 칸이 있어(같은 주의 주계 칸과
         *     ISO 주계 칸) 순서가 정해지지 않는다. UNION ALL 을 적은 차례를 두 번째 키로 둔다.
         *========================================================================*/
        FOR R IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'M_' || A.BASIS_YYYYMM                        AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '01'               AS SORT_ORDER_NO
                                 , 1                                             AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.MONTH_NAME
                             UNION ALL
                            SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK          AS YYYYMMDD
                                 , A.BASIS_START_DATE || '21'                    AS SORT_ORDER_NO
                                 , 2                                             AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.ISO_WEEK
                                    , A.BASIS_START_DATE
                             UNION ALL
                            SELECT 'W_' || A.ISO_YYYYMM || A.ISO_WEEK || '_ISO'  AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '21'               AS SORT_ORDER_NO
                                 , 3                                             AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.ISO_YYYYMM
                                    , A.ISO_WEEK
                             UNION ALL
                            SELECT 'D_' || A.BASIS_YYYYMMDD                      AS YYYYMMDD
                                 , A.BASIS_YYYYMMDD || '31'                      AS SORT_ORDER_NO
                                 , 4                                             AS BLK
                              FROM SCM_SYS_CALENDAR_M A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMMDD
                          )  A
                    ORDER BY SORT_ORDER_NO
                           , BLK
                 )
        LOOP

            IF SUBSTR(R.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN QTY END)  AS ' || R.YYYYMMDD));
            ELSIF SUBSTR(R.YYYYMMDD, 1, 2) = 'W_' THEN
                IF SUBSTR(R.YYYYMMDD, -4) <> '_ISO' THEN
                    DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) THEN QTY END)  AS ' || R.YYYYMMDD));
                ELSE
                    /* ★AS-IS 원문 그대로 : 견주는 오른쪽이 칸 이름(YYYYMMDD)이고 리터럴이 아니다.
                     *   칸 값은 'D_20260824' 꼴이라 SUBSTR(…,3,6) 은 '202608' 이 되고
                     *   ISO_WEEK 는 '260835' 꼴이라 짝이 맞지 않는다. AS-IS 에서도 이 칸은 늘 빈다. */
                    DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN ISO_WEEK = SUBSTR(YYYYMMDD, 3, 6) THEN QTY END)  AS ' || R.YYYYMMDD));
                END IF;
            ELSE
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(CHR(10) || '     , SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN QTY END)  AS ' || R.YYYYMMDD));
            END IF;

        END LOOP;

        /*==========================================================================
         * 결과
         *   ★기초재고(BOH) : AS-IS 는 소수 첫째 자리에서 반올림한 뒤 정수로 자른다.
         *     MSSQL 의 정수 변환은 버림이고 Oracle 의 CAST 는 반올림이므로 TRUNC 로 옮긴다.
         *========================================================================*/
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            'SELECT KEY_IDX' || CHR(10)
         || '     , DIVISION_ID' || CHR(10)
         || '     , DIVISION_NAME' || CHR(10)
         || '     , OPERATION_GROUP' || CHR(10)
         || '     , OPERATION_GROUP_NAME' || CHR(10)
         || '     , ITEM_ID' || CHR(10)
         || '     , NICK_NAME' || CHR(10)
         || '     , ORIGIN_FROM_DIVISION_ID' || CHR(10)
         || '     , FROM_SITE' || CHR(10)
         || '     , FROM_SITE_NAME' || CHR(10)
         || '     , ORIGIN_TO_DIVISION_ID' || CHR(10)
         || '     , TO_SITE' || CHR(10)
         || '     , CASE WHEN TRIM(TO_SITE_NAME) IS NULL THEN ''-'' ELSE TO_SITE_NAME END  AS TO_SITE_NAME' || CHR(10)
         || '     , BOD_ID' || CHR(10)
         || '     , CASE WHEN TRIM(TRANSPORT_MODE) IS NULL THEN ''-'' ELSE TRANSPORT_MODE END  AS TRANSPORT_MODE' || CHR(10)
         || '     , CASE WHEN TRIM(LT_DAY) IS NULL THEN ''0'' ELSE LT_DAY END  AS LT_DAY' || CHR(10)
         || '     , PLAN_START_YYYYMMDD' || CHR(10)
         || '     , PLAN_TYPE' || CHR(10)
         || '     , SEQ' || CHR(10)
         || '     , TRUNC(ROUND(' || CHR(10)
         || '             CASE' || CHR(10)
         || '               WHEN OPERATION_GROUP = ''E'' THEN FN_GET_SCP_ANL_BOH_QTY(DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, TO_NUMBER(SEQ), FROM_SITE, ITEM_ID, FROM_YYYYMMDD)' || CHR(10)
         || '               WHEN OPERATION_GROUP = ''A'' THEN FN_GET_SCP_ANL_CHAR_BOH_QTY(DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, TO_NUMBER(SEQ), FROM_SITE, ITEM_ID, FROM_YYYYMMDD)' || CHR(10)
         || '             END, 1))                                                AS BOH' || CHR(10)
         || '     , VERSION_NO' || CHR(10)
         || '     , ELECTRODE_TYPE' || CHR(10)
         || '     , MEASURE' || CHR(10)
         || '     , MEASURE_ORDER_NO' || CHR(10)
         || '     , MEASURE_LABEL' || CHR(10)
         || '     , FROM_YYYYMMDD' || CHR(10)
         || '     , TO_YYYYMMDD'));
        DBMS_LOB.APPEND(V_SQL, V_QRY_SUM);
        DBMS_LOB.APPEND(V_SQL, TO_CLOB(
            CHR(10) || '  FROM GT_0018 T' || CHR(10)
         || ' GROUP BY KEY_IDX' || CHR(10)
         || '        , DIVISION_ID' || CHR(10)
         || '        , DIVISION_NAME' || CHR(10)
         || '        , OPERATION_GROUP' || CHR(10)
         || '        , OPERATION_GROUP_NAME' || CHR(10)
         || '        , ITEM_ID' || CHR(10)
         || '        , NICK_NAME' || CHR(10)
         || '        , ORIGIN_FROM_DIVISION_ID' || CHR(10)
         || '        , FROM_SITE' || CHR(10)
         || '        , FROM_SITE_NAME' || CHR(10)
         || '        , ORIGIN_TO_DIVISION_ID' || CHR(10)
         || '        , TO_SITE' || CHR(10)
         || '        , TO_SITE_NAME' || CHR(10)
         || '        , BOD_ID' || CHR(10)
         || '        , TRANSPORT_MODE' || CHR(10)
         || '        , LT_DAY' || CHR(10)
         || '        , PLAN_START_YYYYMMDD' || CHR(10)
         || '        , PLAN_TYPE' || CHR(10)
         || '        , SEQ' || CHR(10)
         || '        , VERSION_NO' || CHR(10)
         || '        , ELECTRODE_TYPE' || CHR(10)
         || '        , MEASURE' || CHR(10)
         || '        , MEASURE_ORDER_NO' || CHR(10)
         || '        , MEASURE_LABEL' || CHR(10)
         || '        , FROM_YYYYMMDD' || CHR(10)
         || '        , TO_YYYYMMDD' || CHR(10)
         || ' ORDER BY FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(OPERATION_GROUP) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(ITEM_ID) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(FROM_SITE) NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(TO_SITE) DESC NULLS LAST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(BOD_ID) NULLS FIRST' || CHR(10)
         || '        , MEASURE_ORDER_NO NULLS FIRST' || CHR(10)
         || '        , FN_ASIS_SORT_KEY(VERSION_NO) NULLS FIRST'));

        OPEN O_RC1 FOR V_SQL;

        DBMS_LOB.FREETEMPORARY(V_QRY_SUM);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;

            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS KEY_IDX FROM DUAL WHERE 1 = 0;
            END IF;

            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0018_GET_SHIPMENT_PLAN_SEMI_WATERFALL;

END PKG_SCP0018;