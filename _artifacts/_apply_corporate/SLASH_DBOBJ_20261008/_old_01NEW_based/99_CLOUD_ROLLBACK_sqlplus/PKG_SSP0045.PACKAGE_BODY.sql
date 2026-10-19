-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SSP0045 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY PKG_SSP0045
IS
/*
 * Program ID   : PKG_SSP0045
 * Description  : SSP0045 Shipment Request SEMI
 * Program History
 *===================================================================================================
 * Date         In Charge       Description
 *===================================================================================================
 * 2026.09.29   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 : 본표 행 적재의 약칭 묶음(I)을 이번 조회 임시 테이블 품목으로 한정(결과 동일)
 * 2026.10.07   AJS          조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
 * 2026.10.08   AJS          조회조건 ALL : 공장 사이트 · 품목 조건에 ALL 을 조건 없음으로 받음
 * 2026.10.08   AJS          조회조건 Model ALL : 대소문자 · 앞뒤 공백 무시, 후보 목록(V_ITEM_TAB)을 만들지 않고 조건 없음으로 받음
 *
 * 전환 기준
 *   1. AS-IS 임시 테이블 12개는 미리 만들어 둔 GT_SSP0045_* 로 옮기고 프로시저 시작에 DELETE 로 비운다.
 *   2. 피벗 칸 수가 조회 기간에 따라 달라지므로 본표 조회의 마지막 조립만 동적 SQL 을 쓴다.
 *   3. AS-IS 가 CTE(WITH)로 적던 구간은 인라인 뷰로 바꾼다.
 *   4. 정렬은 AS-IS 순서를 내는 공용 함수 FN_ASIS_SORT_KEY 를 쓴다.
 *   5. 원본 MSSQL 주석은 내용을 그대로 두고 블록 주석으로만 옮긴다.
 *   6. MSSQL 이 문자 날짜를 날짜로 바꿔 견주던 자리는 TO_DATE 로 형을 맞춘다.
 */

    /*******************************************************************************
     * P_SSP0045_GET_SHEET_CALENDAR_3SPAN
     *   AS-IS SCP0009_GET_SHEET_CALENDAR_3SPAN
     *   본표 날짜 머리글(일 · 주 · 월 세 단)
     *******************************************************************************/
    PROCEDURE P_SSP0045_GET_SHEET_CALENDAR_3SPAN
    (
        P_START_YYYYMMDD        IN  VARCHAR2
      , P_END_YYYYMMDD          IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG               VARCHAR2(4000 CHAR);
    BEGIN

        OPEN O_RC1 FOR
            SELECT 'D_'||BASIS_YYYYMMDD                       AS COLUMN_NAME
                 , CALENDAR_DAY                               AS COLUMN_LABEL_NAME
                 , WEEK_NAME                                  AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                 AS LARGE_CLASS_LABEL_NAME
                 , DAYOFWEEK                                  AS DAY_CODE
                 , BASIS_YYYYMMDD||'31'                       AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND BASIS_YYYYMMDD <= P_END_YYYYMMDD
             UNION ALL
            SELECT 'W_'||BASIS_YYYYMM||ISO_WEEK               AS COLUMN_NAME
                 , WEEK_NAME                                  AS COLUMN_LABEL_NAME
                 , WEEK_NAME                                  AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                 AS LARGE_CLASS_LABEL_NAME
                 , NULL                                       AS DAY_CODE
                 , BASIS_START_DATE||'21'                     AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY BASIS_YYYYMM
                    , ISO_WEEK
                    , WEEK_NAME
                    , MONTH_NAME
                    , BASIS_START_DATE
             UNION ALL
            SELECT 'M_'||BASIS_YYYYMM                         AS COLUMN_NAME
                 , MONTH_NAME                                 AS COLUMN_LABEL_NAME
                 , MONTH_NAME                                 AS SMALL_CLASS_LABEL_NAME
                 , MONTH_NAME                                 AS LARGE_CLASS_LABEL_NAME
                 , NULL                                       AS DAY_CODE
                 , MIN(BASIS_START_DATE)||'01'                AS SORT_ORDER_NO
              FROM SCM_SYS_CALENDAR_M
             WHERE BASIS_YYYYMMDD >= P_START_YYYYMMDD
               AND BASIS_YYYYMMDD <= P_END_YYYYMMDD
             GROUP BY BASIS_YYYYMM
                    , MONTH_NAME
             ORDER BY SORT_ORDER_NO;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS COLUMN_NAME FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0045_GET_SHEET_CALENDAR_3SPAN;

    /*******************************************************************************
     * P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE
     *   AS-IS SCM0002_GET_BODITEM_FOR_PRJROUTE_POPUP
     *   BOD 선택 팝업 — 품목 하나가 실려 있는 운송 경로 목록
     *
     * ★AS-IS 화면은 이 팝업을 공용 화면(SCM0002)으로 띄우면서 부모 화면 이름을 함께 넘긴다.
     *   TO-BE 기능 등록이 이 화면 이름(P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE)으로 되어 있어 이 패키지에 둔다.
     * ★P_PROGRAM_ID 는 AS-IS 도 선언만 하고 본문에서 쓰지 않는다(호출 이력 구분용).
     *******************************************************************************/
    PROCEDURE P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG               VARCHAR2(4000 CHAR);
        V_TO_SITE_TYPE          VARCHAR2(30 CHAR) := 'PLANT';
    BEGIN

        OPEN O_RC1 FOR
            SELECT DISTINCT
                   A.DIVISION_ID
                 , B.FROM_SITE
                 , SF.DIVISION_ID                             AS FROM_DIVISION_ID
                 , SF.SITE_TYPE                               AS FROM_SITE_TYPE
                 , SF.SITE_DESCRIPTION                        AS FROM_SITE_NAME
                 , B.TO_SITE
                 , ST.DIVISION_ID                             AS TO_DIVISION_ID
                 , ST.SITE_TYPE                               AS TO_SITE_TYPE
                 , ST.SITE_DESCRIPTION                        AS TO_SITE_NAME
                 , A.ITEM_ID
                 , A.PRIORITY
                 , A.BOD_ID
                 , B.INCOTERMS
                 , C.TRANSPORT_MODE
                 /* BOD 2단계 개발 */
                 /* ,(SELECT v.lt_total FROM scp_mst_bod_v v WHERE v.division_id = b.division_id  and v.bod_id = b.bod_id ) AS lead_time */
                 , (SELECT SA.LT_TOTAL
                      FROM SCP_MST_BOD_N_V SA
                     WHERE SA.DIVISION_ID = B.DIVISION_ID
                       AND SA.BOD_ID      = B.BOD_ID)          AS LEAD_TIME
                 , A.VALID_YN                                 AS BOD_ITEM_VALID
                 , C.ROUTE_ID
                 , C.DAYS_MON
                 , C.DAYS_TUE
                 , C.DAYS_WED
                 , C.DAYS_THU
                 , C.DAYS_FRI
                 , C.DAYS_SAT
                 , C.DAYS_SUN
                 /* Ship Frozen구간 다음일자 */
                 , TO_CHAR(TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD') + NVL(FS.SHIP_FROZEN, 0), 'YYYYMMDD') AS FROZEN_YYYYMMDD
                 , TO_DATE(B.ATTRIBUTE2, 'YYYYMMDD')          AS BOD_FROM_YYYYMMDD    /* BOD 2단계 개발 */
                 , TO_DATE(B.ATTRIBUTE3, 'YYYYMMDD')          AS BOD_TO_YYYYMMDD      /* BOD 2단계 개발 */
              FROM SCP_MST_BOD_ITEM              A
                 , SCP_MST_BOD                   B
                 , SCM_MST_SITE                  SF
                 , SCM_MST_SITE                  ST
                 , SCP_MST_DISTRIBUTION_ROUTE    C
                 , SCM_MST_SITE                  FS
             WHERE A.BOD_ID            = B.BOD_ID
               AND SF.SCM_SITE_ID      = B.FROM_SITE
               AND ST.SCM_SITE_ID      = B.TO_SITE
               AND B.ROUTE_ID          = C.ROUTE_ID
               AND FS.DIVISION_ID      = A.DIVISION_ID
               AND FS.SCM_SITE_ID      = B.FROM_SITE
               AND SF.SITE_TYPE        = 'PLANT'
               AND SF.OPERATION_GROUP  = P_OPERATION_GROUP
               AND ST.SITE_TYPE        = V_TO_SITE_TYPE
               AND FS.SITE_TYPE        = 'PLANT'
               AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
               AND FS.OSP_YN           = 'N'
               AND FS.VALID_YN         = 'Y'
               AND B.INCOTERMS         = 'DAP'                 /* Semi 용 DAP 적용 */
               AND SF.PLANT_ID        <> ST.PLANT_ID           /* 동일 Plant 제외(A040-A -> A040-P 등) */
               AND A.DIVISION_ID       = P_DIVISION_ID
               AND A.ITEM_ID           = P_ITEM_ID
             ORDER BY BOD_ITEM_VALID DESC
                    , FN_ASIS_SORT_KEY(DIVISION_ID) NULLS FIRST
                    , FN_ASIS_SORT_KEY(FROM_SITE) NULLS FIRST
                    , FN_ASIS_SORT_KEY(TO_SITE) NULLS FIRST
                    , PRIORITY
                    , FN_ASIS_SORT_KEY(TRANSPORT_MODE) NULLS FIRST;

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0045_GET_BOD_ITEM_PRJ_ROUTE;

    /*******************************************************************************
     * P_SSP0045_GET_SHIPMENT_REQUEST
     *   AS-IS SSP0045_GET_SHIPMENT_REQUEST
     *   Shipment Request 본표 (측정값 9 종 × 일 · 주 · 월 피벗)
     *
     * 측정값
     *   1 SCP_PLAN   SCP 출하계획      2 SHIP_PLAN 출하계획        3 SHIP_REQ  출하지시
     *   4 CUST_PLAN  고객 출하계획     5 CUST_REQ  고객 출하지시   6 INTN_MOVEMENT 사내 이동
     *   7 INSP_PLAN  특성 계획         8 WH_BOH_PLAN 창고 기초재고(계획)
     *   9 WH_BOH_REQ 창고 기초재고(지시)
     *
     * ★소형(40) 사업부는 사내 이동 · 특성 계획 · 재고를 SSP_ANL_SHIP_PLAN_40 에서 읽는다
     *   (AS-IS [C20201016-000147]).
     * ★피벗 칸 수가 조회 기간에 따라 달라지므로 마지막 조립만 동적 SQL 을 쓴다.
     *******************************************************************************/
    PROCEDURE P_SSP0045_GET_SHIPMENT_REQUEST
    (
        P_DIVISION_ID           IN  VARCHAR2
      , P_OPERATION_GROUP       IN  VARCHAR2
      , P_SCM_SITE_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG                   VARCHAR2(4000 CHAR);
        V_STOCK_YYYYMMDD            VARCHAR2(8 CHAR);
        V_PLAN_START_YYYYMMDD       VARCHAR2(8 CHAR);
        V_CUTOFF_START_YYYYMMDD     VARCHAR2(8 CHAR);
        V_SCP_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR);
        V_SCP_PLAN_TYPE             VARCHAR2(10 CHAR);
        V_SCP_SEQ                   NUMBER;
        V_APP_TYPE                  VARCHAR2(8 CHAR) := 'SSP';
        V_BASE_MONDAY_YYYYMMDD      VARCHAR2(8 CHAR);
        V_PIVOT                     CLOB;
        V_SQL                       CLOB;
        V_ITEM_TAB                  T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN

        V_PLAN_START_YYYYMMDD   := TO_CHAR(SYSDATE, 'YYYYMMDD');
        V_CUTOFF_START_YYYYMMDD := TO_CHAR(SYSDATE - 1, 'YYYYMMDD');
        V_STOCK_YYYYMMDD        := TO_CHAR(TO_DATE(P_FROM_YYYYMMDD, 'YYYYMMDD') - 3, 'YYYYMMDD');   /* FROM -3일 */

        /* SCP 계획 기준 주의 월요일에서 4주 앞 */
        V_BASE_MONDAY_YYYYMMDD  := TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 'MON') - 28, 'YYYYMMDD');

        /* 임시 테이블 비우기 (ON COMMIT PRESERVE ROWS 라 앞 호출 자료가 남는다) */
        DELETE FROM GT_SSP0045_SHIPMENT_PLAN_FG;
        DELETE FROM GT_SSP0045_PLAN;
        DELETE FROM GT_SSP0045_PLAN_ERP_RESULT;
        DELETE FROM GT_SSP0045_SHIP_REQ;
        DELETE FROM GT_SSP0045_SHIP_REQ_OWMS;
        DELETE FROM GT_SSP0045_FILTER;
        DELETE FROM GT_SSP0045_40_STD;
        DELETE FROM GT_SSP0045_SHIP_ROW;
        DELETE FROM GT_SSP0045_STOCK;
        DELETE FROM GT_SSP0045_CAL_QTY;
        DELETE FROM GT_SSP0045_REQUESTOR;
        DELETE FROM GT_SSP0045_SHIP_PIVOT;

        /* 2026.10.07 AJS Model/Nickname 검색 (START) */
        /* 입력값(쉼표 구분 · 빈 값 제외)이 품목 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 문장 밖에서 한 번 고른다
           대상 = 사업부 품목 원장(SCM_MST_ITEM_SN) 품목 + 입력값 그대로(기존 정확일치로 나오던 품목 유지) */
        /* IF TRIM(P_ITEM_ID) IS NOT NULL THEN */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN   /* AJS 20261008 Model/Nickname : ALL 은 후보 목록을 만들지 않고 조건 없음 */
            SELECT DISTINCT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM ( SELECT A.ITEM_ID
                       FROM SCM_MST_ITEM_SN                      A
                          , TABLE(STRING_SPLIT(P_ITEM_ID, ','))   SA
                      WHERE SA.COLUMN_VALUE IS NOT NULL
                        AND A.DIVISION_ID   = P_DIVISION_ID
                        AND (    UPPER(A.ITEM_ID)   LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
                              OR UPPER(A.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%' )
                     UNION ALL
                     SELECT UPPER(SB.COLUMN_VALUE)
                       FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))   SB
                      WHERE SB.COLUMN_VALUE IS NOT NULL
                   )  IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* 최신 FN 계획 판 */
        BEGIN
            SELECT PLAN_START_YYYYMMDD
                 , PLAN_TYPE
                 , PLAN_SEQ
              INTO V_SCP_PLAN_START_YYYYMMDD
                 , V_SCP_PLAN_TYPE
                 , V_SCP_SEQ
              FROM ( SELECT PLAN_START_YYYYMMDD
                          , PLAN_TYPE
                          , PLAN_SEQ
                       FROM SCP_PLAN_VERSION_V
                      WHERE DIVISION_ID = P_DIVISION_ID
                        AND PLAN_CYCLE  = 'WEEKLY'
                        AND PLAN_TYPE   = 'FN'
                      ORDER BY PLAN_START_YYYYMMDD DESC
                             , PLAN_TYPE_ORDER DESC
                             , PLAN_SEQ DESC )  IA
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_SCP_PLAN_START_YYYYMMDD := NULL;
        END;

        /*---------------------------------------------
         * 0. SCP 출하계획(FG) 기준 자료
         *   ★AS-IS 는 B 를 LEFT JOIN 으로 적었으나 WHERE 에 B.DIVISION_ID IS NOT NULL 이 있어
         *     결과가 내부 조인과 같다. 조인 조건을 옮길 수 있도록 내부 조인으로 적는다.
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIPMENT_PLAN_FG
        ( DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, BIZ_TYPE, PROJECT_CODE, FCST_TYPE
        , ITEM_ID, TO_SITE, INCOTERMS, FROM_SITE, BOD_ID, TRANSPORT_MODE, MEASURE, YYYYMMDD, QTY )
        SELECT DIVISION_ID
             , PLAN_START_YYYYMMDD            /* plan주의 월요일 */
             , PLAN_TYPE
             , MAX(SEQ)                                       AS SEQ
             , MAX(OPERATION_GROUP)                           AS BIZ_TYPE
             , NVL(PROJECT_CODE, '-')                         AS PROJECT_CODE
             , FCST_TYPE
             , ITEM_ID
             , TO_SITE
             , INCOTERMS
             , FROM_SITE
             , BOD_ID
             , TRANSPORT_MODE
             , MEASURE
             , YYYYMMDD
             , SUM(QTY)                                       AS QTY
          FROM ( SELECT B.DIVISION_ID
                      , B.PLAN_START_YYYYMMDD
                      , B.PLAN_TYPE
                      , B.SEQ
                      , B.OPERATION_GROUP
                      , A.PROJECT_CODE
                      , A.FCST_TYPE
                      , B.ITEM_ID
                      , B.TO_SITE
                      /* 2020.09.18  KBK  법인간 거래 - 실제 매출 Incoterms 적용 */
                      , NVL(C.SSP_INCOTERMS, B.INCOTERMS)     AS INCOTERMS
                      , B.FROM_SITE
                      , B.BOD_ID
                      , B.TRANSPORT_MODE
                      , B.MEASURE
                      , B.YYYYMMDD
                      , A.ALLOCATION_QTY                      AS QTY
                   FROM SCP_PLN_SHIPMENT_PLAN_PEGGING  A
                      , SCP_PLN_SHIPMENT_PLAN          B
                      , SCP_MST_BOD_N_V                C
                  WHERE A.DIVISION_ID           = B.DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD   = B.PLAN_START_YYYYMMDD
                    AND A.PLAN_TYPE             = B.PLAN_TYPE
                    AND A.SEQ                   = B.SEQ
                    AND A.ORDER_ID              = B.ORDER_ID
                    AND C.DIVISION_ID(+)        = B.DIVISION_ID
                    AND C.BOD_ID(+)             = B.BOD_ID
                    AND B.MEASURE               = 'SHIP_PLAN'
                    AND B.SEMI_YN               = 'N'
                    AND B.OPERATION_GROUP       = (CASE WHEN P_DIVISION_ID = '40' THEN 'A' ELSE B.OPERATION_GROUP END)
                    AND A.DIVISION_ID           = P_DIVISION_ID
                    AND A.PLAN_START_YYYYMMDD  >= V_BASE_MONDAY_YYYYMMDD
                    AND A.PLAN_TYPE             = 'FN'
                    AND B.YYYYMMDD             >= P_FROM_YYYYMMDD
                    AND B.YYYYMMDD             <= P_TO_YYYYMMDD
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR B.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR B.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR B.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
               )  XA
         GROUP BY DIVISION_ID
                , PLAN_START_YYYYMMDD
                , PLAN_TYPE
                , NVL(PROJECT_CODE, '-')
                , FCST_TYPE
                , ITEM_ID
                , TO_SITE
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE
                , BOD_ID
                , MEASURE
                , YYYYMMDD;

        /*---------------------------------------------
         * 1. SCP Plan : SCP(Weekly) plant향 Shipment Plan
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_PLAN
        ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID, MEASURE
        , YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE
             , TO_SITE
             , TR_MODE
             , INCOTERMS
             , BOD_ID
             , MEASURE
             , YYYYMMDD
             , QTY
             , PROJECT_CODE
             , FCST_TYPE
             , SEQ
          FROM ( SELECT SP.DIVISION_ID
                      , SP.ITEM_ID
                      , SP.FROM_SITE
                      , SP.TO_SITE
                      , BOD.TRANSPORT_MODE                    AS TR_MODE
                      , BOD.INCOTERMS                         AS INCOTERMS
                      , BOD.BOD_ID                            AS BOD_ID     /* BOD 2단계 개발 */
                      , 'SCP_PLAN'                            AS MEASURE
                      , SP.YYYYMMDD
                      , SP.QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 1                                     AS SEQ
                      , TO_DATE(SP.YYYYMMDD, 'YYYYMMDD') - TO_DATE(PV.PLAN_START_YYYYMMDD, 'YYYYMMDD')   AS DAY_GAP
                      , CASE WHEN V_SCP_PLAN_START_YYYYMMDD = PV.PLAN_START_YYYYMMDD THEN 0 ELSE 1 END   AS FLAG
                   FROM SCP_ANL_SHIPMENT_PLAN_SEMI   SP
                      , ( SELECT DIVISION_ID
                               , PLAN_START_YYYYMMDD
                               , PLAN_TYPE
                               , PLAN_SEQ
                               , PLAN_ID
                               , MODELING_ID
                               , SORT_SEQ
                               , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                                    ORDER BY PLAN_START_YYYYMMDD DESC, SORT_SEQ ASC, PLAN_SEQ DESC) AS ROW_NUM
                            FROM ( SELECT DIVISION_ID
                                        , PLAN_START_YYYYMMDD
                                        , PLAN_TYPE
                                        , PLAN_SEQ
                                        , PLAN_ID
                                        , MODELING_ID
                                        , CASE WHEN PLAN_TYPE = 'PR' THEN 4
                                               WHEN PLAN_TYPE = 'MA' THEN 3
                                               WHEN PLAN_TYPE = 'SE' THEN 2
                                               WHEN PLAN_TYPE = 'FN' THEN 1
                                               ELSE 9
                                          END                                   AS SORT_SEQ
                                     FROM SCP_PLAN_VERSION_V
                                    WHERE DIVISION_ID          = P_DIVISION_ID
                                      AND PLAN_CYCLE           = 'WEEKLY'
                                      /* 191219 FN만 조회 */
                                      AND PLAN_TYPE            = 'FN'
                                      AND PLAN_START_YYYYMMDD >= V_BASE_MONDAY_YYYYMMDD
                                 )  SA
                        )  PV
                      , SCP_MST_BOD_N_V                BOD     /* BOD 2 단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v */
                      , SCM_MST_SITE                   FS
                      , SCM_MST_SITE                   TS
                  WHERE SP.DIVISION_ID          = PV.DIVISION_ID
                    AND SP.PLAN_START_YYYYMMDD  = PV.PLAN_START_YYYYMMDD
                    AND SP.PLAN_TYPE            = PV.PLAN_TYPE
                    AND SP.SEQ                  = PV.PLAN_SEQ
                    AND SP.DIVISION_ID          = BOD.DIVISION_ID
                    AND SP.BOD_ID               = BOD.BOD_ID
                    AND FS.DIVISION_ID          = SP.DIVISION_ID
                    AND FS.SCM_SITE_ID          = SP.FROM_SITE
                    AND TS.DIVISION_ID          = SP.DIVISION_ID
                    AND TS.SCM_SITE_ID          = SP.TO_SITE
                    AND SP.MEASURE              = 'SHIP_PLAN_AMEND'
                    AND SP.QTY                  > 0
                    AND SP.OPERATION_GROUP      = P_OPERATION_GROUP
                    AND SP.YYYYMMDD            >= P_FROM_YYYYMMDD
                    AND SP.YYYYMMDD            <= P_TO_YYYYMMDD
                    AND FS.VALID_YN             = 'Y'
                    AND TS.VALID_YN             = 'Y'
                    AND FS.PLANT_ID            <> TS.PLANT_ID
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR SP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR SP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR SP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                 UNION ALL
                 /* AS(Warranty Service) 적용 */
                 SELECT Y.DIVISION_ID
                      , Y.ITEM_ID
                      , Z.FROM_SITE
                      , Z.TO_SITE
                      , Z.TRANSPORT_MODE                      AS TR_MODE
                      , Z.INCOTERMS
                      , Z.BOD_ID
                      , 'SCP_PLAN'                            AS MEASURE
                      , Y.YYYYMMDD
                      , Y.QTY
                      , Y.PROJECT_CODE
                      , Y.FCST_TYPE
                      , 1                                     AS SEQ
                      , TO_DATE(Y.YYYYMMDD, 'YYYYMMDD') - TO_DATE(Y.PLAN_START_YYYYMMDD, 'YYYYMMDD')     AS DAY_GAP
                      , CASE WHEN V_SCP_PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD THEN 0 ELSE 1 END    AS FLAG
                   FROM ( SELECT X.DIVISION_ID
                               , X.ITEM_ID
                               , X.FROM_SITE
                               , X.TO_SITE
                               , X.PROJECT_CODE
                               , X.FCST_TYPE
                               , ( SELECT BOD_ID
                                     FROM ( SELECT BOD_ID
                                              FROM SCP_MST_BOD_N_V
                                             WHERE DIVISION_ID     = X.DIVISION_ID
                                               AND FROM_SITE       = X.FROM_SITE
                                               AND TO_SITE         = X.TO_SITE
                                               AND INCOTERMS       = X.INCOTERMS
                                               AND TRANSPORT_MODE  = X.TRANSPORT_MODE
                                               AND X.YYYYMMDD      BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD
                                               AND BOD_VALID_YN    = 'Y'
                                             ORDER BY PRIORITY )  SA
                                    WHERE ROWNUM = 1 )         AS BOD_ID   /* new bod for plant type */
                               , X.YYYYMMDD
                               , X.QTY
                               , X.PLAN_START_YYYYMMDD
                            FROM ( SELECT SP.DIVISION_ID
                                        , SP.ITEM_ID
                                        , SP.FROM_SITE
                                        , SP.PROJECT_CODE
                                        , SP.FCST_TYPE
                                        , L.SEGMENT2                        AS TO_SITE
                                        , BOD.TRANSPORT_MODE                AS TRANSPORT_MODE
                                        , BOD.INCOTERMS                     AS INCOTERMS
                                        , CASE WHEN BOD.SEGMENT3 = 'A' THEN SP.YYYYMMDD
                                               ELSE TO_CHAR(TO_DATE(SP.YYYYMMDD, 'YYYYMMDD') + BOD.BEFORE_LT, 'YYYYMMDD')
                                          END                               AS YYYYMMDD
                                        , SP.QTY
                                        , 1                                 AS SEQ
                                        , SP.PLAN_START_YYYYMMDD
                                     FROM GT_SSP0045_SHIPMENT_PLAN_FG       SP
                                        , SCP_MST_BOD_N_V                   BOD
                                        , SCM_MST_SITE                      FS
                                        , SCM_ADM_LOOKUP_MASTER_DETAIL      L
                                        , SCM_MST_SITE                      TS
                                    WHERE SP.DIVISION_ID       = BOD.DIVISION_ID
                                      AND SP.BOD_ID            = BOD.BOD_ID
                                      AND FS.DIVISION_ID       = SP.DIVISION_ID
                                      AND FS.SCM_SITE_ID       = SP.FROM_SITE
                                      AND L.SEGMENT1           = SP.TO_SITE
                                      AND L.SEGMENT3           = SP.DIVISION_ID
                                      AND TS.DIVISION_ID       = SP.DIVISION_ID
                                      AND TS.SCM_SITE_ID       = L.SEGMENT2
                                      AND FS.VALID_YN          = 'Y'
                                      AND FS.SITE_TYPE         = 'PLANT'
                                      AND FS.OPERATION_GROUP   = 'P'
                                      AND L.LOOKUP_TYPE        = 'AS_SITE_PLANT'
                                      AND L.VALID_YN           = 'Y'
                                      AND TS.SITE_TYPE         = 'PLANT'
                                      AND TS.OPERATION_GROUP   = 'W'
                                      AND TS.VALID_YN          = 'Y'
                                      AND VALIDATE_CONVERSION(SP.YYYYMMDD AS DATE, 'YYYYMMDD') = 1
                                 )  X
                        )  Y
                      , SCP_MST_BOD_N_V                Z
                  WHERE Y.BOD_ID = Z.BOD_ID
               )  AA
         WHERE ( AA.FLAG = 0 OR ( AA.FLAG = 1 AND AA.DAY_GAP < 7 ) );

        /*---------------------------------------------
         * 2. Ship Plan : SSP(Daily) Plant향 Shipment Plan
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_PLAN
        ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID, MEASURE
        , YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT SSP.DIVISION_ID
             , SSP.ITEM_ID
             , SSP.FROM_SITE
             , SSP.TO_SITE
             , BOD.TRANSPORT_MODE                             AS TR_MODE
             , BOD.INCOTERMS                                  AS INCOTERMS
             , BOD.BOD_ID                                     AS BOD_ID      /* BOD 2단계 개발 */
             , 'SHIP_PLAN'                                    AS MEASURE
             , SSP.YYYYMMDD
             , SSP.QTY
             , SSP.PROJECT_CODE
             , SSP.FCST_TYPE
             , 2                                              AS SEQ
          FROM SSP_ANL_SHIP_CONFIRM        SSP
             , SCP_MST_BOD_N_V             BOD                /* BOD 2 단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v */
             , SCM_MST_SITE                TS
             , SCM_MST_SITE                FS
         WHERE SSP.DIVISION_ID       = BOD.DIVISION_ID
           AND SSP.BOD_ID            = BOD.BOD_ID
           AND TS.DIVISION_ID        = SSP.DIVISION_ID
           AND TS.SCM_SITE_ID        = SSP.TO_SITE
           AND FS.DIVISION_ID        = SSP.DIVISION_ID
           AND FS.SCM_SITE_ID        = SSP.FROM_SITE
           AND TS.SITE_TYPE          = 'PLANT'
           AND TS.VALID_YN           = 'Y'
           AND FS.VALID_YN           = 'Y'
           AND TS.PLANT_ID          <> FS.PLANT_ID
           AND SSP.DIVISION_ID       = P_DIVISION_ID
           AND SSP.QTY               > 0
           AND SSP.YYYYMMDD         >= V_PLAN_START_YYYYMMDD
           AND SSP.YYYYMMDD         <= P_TO_YYYYMMDD
           AND SSP.BIZ_TYPE          = P_OPERATION_GROUP
           AND SSP.CHANGE_TYPE       = 'C'
           AND ( TRIM(P_SCM_SITE_ID) IS NULL
                 OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR SSP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
--               OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--               OR SSP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );   --  2026.10.07 AJS
                 OR SSP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) );   --  2026.10.07 AJS

        /*---------------------------------------------
         * 2-1. ERP 출하실적
         *   ★AS-IS 가 CTE 두 벌(RESULT_ERP_C_EXIST · RESULT_ERP_C_NON)로 적던 구간을 인라인 뷰로 옮긴다.
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_PLAN_ERP_RESULT
        ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID, MEASURE
        , YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE                                    AS FROM_SITE
             , A.TO_SITE                                      AS TO_SITE
             , B.TR_MODE                                      AS TR_MODE
             , B.INCOTERMS                                    AS INCOTERMS
             , B.BOD_ID                                       AS BOD_ID
             , 'SHIP_PLAN'                                    AS MEASURE
             , A.YYYYMMDD                                     AS YYYYMMDD
             , A.QTY                                          AS QTY
             , B.PROJECT_CODE                                 AS PROJECT_CODE
             , B.FCST_TYPE                                    AS FCST_TYPE
             , 2                                              AS SEQ
          FROM ( /* ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 */
                 SELECT E.DIVISION_ID                         AS DIVISION_ID
                      , E.ITEM_ID                             AS ITEM_ID
                      , E.FROM_SCM_SITE_ID                    AS FROM_SITE
                      , E.TO_SCM_SITE_ID                      AS TO_SITE
                      , E.TRANSPORT_MODE                      AS TRANSPORT_MODE
                      /* E.INCOTERMS 대신 INCOTERMS는 DAP로 통일 */
                      , 'DAP'                                 AS INCOTERMS
                      , P.BOD_ID                              AS BOD_ID
                      , E.EXFACTORY_DATE                      AS YYYYMMDD
                      , SUM(E.EXFACTORY_QTY)                  AS QTY
                      , P.PROJECT_CODE                        AS PROJECT_CODE
                      , P.FCST_TYPE                           AS FCST_TYPE
                   FROM SCM_DNM_EXFACTORY_RESULT       E
                      , SCM_MST_SITE                   TS
                      , SCM_MST_SITE                   FS
                      , SCM_ADM_LOOKUP_MASTER_DETAIL   L
                      , SSP_ANL_SHIP_CONFIRM           P
                  WHERE E.DIVISION_ID          = TS.DIVISION_ID
                    AND E.TO_SCM_SITE_ID       = TS.SCM_SITE_ID
                    AND E.DIVISION_ID          = FS.DIVISION_ID
                    AND E.FROM_SCM_SITE_ID     = FS.SCM_SITE_ID
                    AND L.SEGMENT1             = E.SSP_TYPE
                    AND P.DIVISION_ID          = E.DIVISION_ID
                    AND P.CONFIRM_ID           = E.CONFIRM_ID
                    AND TS.SITE_TYPE           = 'PLANT'
                    AND TS.VALID_YN            = 'Y'
                    AND TS.OPERATION_GROUP    <> 'E'
                    AND FS.VALID_YN            = 'Y'
                    AND FS.OPERATION_GROUP    <> 'E'
                    AND L.LOOKUP_TYPE          = 'ERP_SSP_TYPE'    /* LOOKUP에 등록된 공정만 */
                    AND L.VALID_YN             = 'Y'
                    AND P.YYYYMMDD             BETWEEN P_FROM_YYYYMMDD AND V_CUTOFF_START_YYYYMMDD
                    /* D90: DO삭제 , D10:DO생성 */
                    AND NVL(E.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')
                    AND E.CONFIRM_ID           LIKE 'C%'
                    AND E.EXFACTORY_DATE       BETWEEN P_FROM_YYYYMMDD AND V_CUTOFF_START_YYYYMMDD
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR E.FROM_SCM_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR E.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR E.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  GROUP BY E.DIVISION_ID
                         , E.CONFIRM_ID
                         , E.ORDER_NO
                         , E.EXFACTORY_DATE
                         , E.TRANSPORT_MODE
                         , E.INCOTERMS
                         , P.BOD_ID
                         , P.FCST_TYPE
                         , P.PROJECT_CODE
                         , E.ETA_DATE
                         , E.ETD_DATE
                         , E.FROM_SCM_SITE_ID
                         , E.TO_SCM_SITE_ID
                         , E.ITEM_ID
                 UNION ALL
                 /* ERP 출하실적에서 CONFIRM_ID 없는 실적 */
                 SELECT E.DIVISION_ID                         AS DIVISION_ID
                      , E.ITEM_ID                             AS ITEM_ID
                      , E.FROM_SCM_SITE_ID                    AS FROM_SITE
                      , NVL(L3.SEGMENT4, E.TO_SCM_SITE_ID)    AS TO_SITE
                      , E.TRANSPORT_MODE                      AS TRANSPORT_MODE
                      /* E.INCOTERMS 대신 INCOTERMS는 DAP로 통일 */
                      , 'DAP'                                 AS INCOTERMS
                      , V.BOD_ID                              AS BOD_ID
                      , E.EXFACTORY_DATE                      AS YYYYMMDD
                      , SUM(E.EXFACTORY_QTY)                  AS QTY
                      , E.PROJECT_CODE                        AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                   FROM SCM_DNM_EXFACTORY_RESULT       E
                      , SCM_MST_SITE                   TS
                      , SCM_MST_SITE                   FS
                      , SCP_MST_BOD_N_V                V
                      , SCP_MST_FINAL_ITEM             F
                      , SCM_ADM_LOOKUP_MASTER_DETAIL   L
                      , SCM_ADM_LOOKUP_MASTER_DETAIL   L3
                  WHERE E.DIVISION_ID          = TS.DIVISION_ID
                    AND E.TO_SCM_SITE_ID       = TS.SCM_SITE_ID
                    AND E.DIVISION_ID          = FS.DIVISION_ID
                    AND E.FROM_SCM_SITE_ID     = FS.SCM_SITE_ID
                    AND V.DIVISION_ID          = E.DIVISION_ID
                    AND V.FROM_SITE            = E.FROM_SCM_SITE_ID
                    AND V.TO_SITE              = E.TO_SCM_SITE_ID
                    AND V.INCOTERMS            = E.INCOTERMS
                    AND V.TRANSPORT_MODE       = E.TRANSPORT_MODE
                    AND V.FROM_YYYYMMDD       >= E.EXFACTORY_DATE
                    AND V.TO_YYYYMMDD         <= E.EXFACTORY_DATE
                    AND F.ITEM_ID              = E.ITEM_ID     /* SCP 대상 ITEM만 */
                    AND F.DIVISION_ID          = E.DIVISION_ID
                    AND L.SEGMENT1             = E.ORDER_TYPE_CODE
                    AND L3.SEGMENT1(+)         = E.DIVISION_ID
                    AND L3.SEGMENT2(+)         = E.SOLDTO_CODE
                    AND L3.SEGMENT3(+)         = E.SHIPTO_CODE
                    /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
                    AND L3.LOOKUP_TYPE(+)      = 'SHIP_RESULT_TO_SITE_MAPPING'
                    AND TS.SITE_TYPE           = 'PLANT'
                    AND TS.VALID_YN            = 'Y'
                    AND TS.OPERATION_GROUP    <> 'E'
                    AND FS.VALID_YN            = 'Y'
                    AND FS.OPERATION_GROUP    <> 'E'
                    /* LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 */
                    AND L.LOOKUP_TYPE          = 'ERP_ORDER_TYPE'
                    AND L.VALID_YN             = 'Y'
                    /* D90: DO삭제 , D10:DO생성 */
                    AND NVL(E.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')
                    AND E.EXFACTORY_DATE       BETWEEN P_FROM_YYYYMMDD AND V_CUTOFF_START_YYYYMMDD
                    /* 상품창고제외 */
                    AND E.STORAGE_ID NOT IN (SELECT COLUMN_VALUE
                                               FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0045_GET_SHIPMENT_REQUEST', 'PRODUCT_STORAGE')))
                    /* 사외 창고 제외 LOOKUP 관리 */
                    AND NOT EXISTS (SELECT 1
                                      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                     WHERE LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                       AND VALID_YN    = 'Y'
                                       AND SEGMENT1    = E.STORAGE_ID)
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR E.FROM_SCM_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR E.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR E.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  GROUP BY E.DIVISION_ID
                         , E.ORDER_NO
                         , E.FROM_SCM_SITE_ID
                         , NVL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
                         , E.ITEM_ID
                         , E.EXFACTORY_DATE
                         , E.TRANSPORT_MODE
                         , E.INCOTERMS
                         , V.BOD_ID
                         , E.PROJECT_CODE
                         , E.ETA_DATE
                         , E.ETD_DATE
               )  A
             , ( SELECT DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , TO_SITE
                      , MAX(TR_MODE)                          AS TR_MODE
                      , MAX(INCOTERMS)                        AS INCOTERMS
                      , MAX(BOD_ID)                           AS BOD_ID
                      , MAX(PROJECT_CODE)                     AS PROJECT_CODE
                      , MAX(FCST_TYPE)                        AS FCST_TYPE
                   FROM GT_SSP0045_PLAN
                  GROUP BY DIVISION_ID
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE )  B
         WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
           AND A.FROM_SITE     = B.FROM_SITE(+)
           AND A.TO_SITE       = B.TO_SITE(+)
           AND A.ITEM_ID       = B.ITEM_ID(+);

        /*---------------------------------------------
         * 3. Ship Req : 출하 요청(Plant향 Ship Req)
         *               DM_PLN_SHIPMENT_REQ / MEASURE = 'SHIP_REQ'
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_REQ
        ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID, MEASURE
        , YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, RN, FROZEN_YYYYMMDD )
        SELECT R.DIVISION_ID
             , R.ITEM_ID
             , R.PLANT_SITE_ID                                AS FROM_SITE
             , R.SCM_SITE_ID                                  AS TO_SITE
             , R.TRANSPORT_MODE                               AS TR_MODE
             , R.INCOTERMS                                    AS INCOTERMS
             , R.BOD_ID                                       AS BOD_ID      /* BOD 2단계 개발 */
             , 'SHIP_REQ'                                     AS MEASURE
             , R.YYYYMMDD
             , R.QTY
             , R.PROJECT_CODE
             , R.FCST_TYPE
             , 3                                              AS SEQ
             , R.LAST_UPDATED_BY
             , RANK() OVER (PARTITION BY R.DIVISION_ID, R.ITEM_ID, R.PLANT_SITE_ID, R.SCM_SITE_ID
                                       , R.TRANSPORT_MODE, R.INCOTERMS
                            ORDER BY R.LAST_UPDATE_DATE DESC) AS RN
             /* 확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]) */
             /* Ship Frozen구간 다음일자 */
             , TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                       + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(V_APP_TYPE, R.DIVISION_ID, R.PLANT_SITE_ID, V_PLAN_START_YYYYMMDD)
                       , 'YYYYMMDD')                          AS FROZEN_YYYYMMDD
          FROM DM_PLN_SHIPMENT_REQ         R
             , SCM_MST_SITE                FS
             , SCM_MST_SITE                TS
         WHERE R.DIVISION_ID       = FS.DIVISION_ID
           AND R.PLANT_SITE_ID     = FS.SCM_SITE_ID
           AND R.DIVISION_ID       = TS.DIVISION_ID
           AND R.SCM_SITE_ID       = TS.SCM_SITE_ID
           AND FS.SITE_TYPE        = 'PLANT'
           AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
           /* 2021.10.21 : W/S AS 수정 , OSP_YN 조건 제거 */
           AND FS.VALID_YN         = 'Y'
           AND TS.SITE_TYPE        = 'PLANT'
           AND TS.VALID_YN         = 'Y'
           AND TS.PLANT_ID        <> FS.PLANT_ID
           AND R.DIVISION_ID       = P_DIVISION_ID
           AND R.MEASURE           = 'SHIP_REQ'               /* 확정 후 수정할 것 */
           AND R.YYYYMMDD         >= V_PLAN_START_YYYYMMDD
           AND R.YYYYMMDD         <= P_TO_YYYYMMDD
           AND R.QTY               > 0
           AND ( TRIM(P_SCM_SITE_ID) IS NULL
                 OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR R.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
--               OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--               OR R.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );   --  2026.10.07 AJS
                 OR R.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) );   --  2026.10.07 AJS

        /*---------------------------------------------
         * 3-1. OWMS 출하실적
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_REQ_OWMS
        ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID, MEASURE
        , YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ, LAST_UPDATED_BY, RN, FROZEN_YYYYMMDD )
        SELECT O.DIVISION_ID
             , O.ITEM_ID
             , O.FROM_SITE
             , O.TO_SITE
             , R.TR_MODE
             , R.INCOTERMS
             , R.BOD_ID
             , 'SHIP_REQ'                                     AS MEASURE
             , O.YYYYMMDD
             , O.QTY
             , R.PROJECT_CODE
             , R.FCST_TYPE
             , 3                                              AS SEQ
             , '-'                                            AS LAST_UPDATED_BY
             , '-'                                            AS RN
             /* 확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16 */
             /* Ship Frozen구간 다음일자 */
             , TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                       + FN_GET_ANL_SHIP_FROZEN_DAY_CNT('SSP', MS.DIVISION_ID, MS.SCM_SITE_ID, V_PLAN_START_YYYYMMDD)
                       , 'YYYYMMDD')                          AS FROZEN_YYYYMMDD
          FROM SSP_DNM_SHIP_RESULT_OWMS_V   O
             , SCM_MST_SITE                 MS
             , SCM_ADM_LOOKUP_MASTER_DETAIL L
             , SCM_MST_SITE                 FS
             , SCM_MST_SITE                 TS
             , ( SELECT DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , TO_SITE
                      , MAX(TR_MODE)                          AS TR_MODE
                      , MAX(INCOTERMS)                        AS INCOTERMS
                      , MAX(BOD_ID)                           AS BOD_ID
                      , MAX(PROJECT_CODE)                     AS PROJECT_CODE
                      , MAX(FCST_TYPE)                        AS FCST_TYPE
                   FROM GT_SSP0045_SHIP_REQ
                  GROUP BY DIVISION_ID
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE )  R
         WHERE MS.DIVISION_ID      = O.DIVISION_ID
           AND MS.SCM_SITE_ID      = O.FROM_SITE
           AND O.DIVISION_ID       = FS.DIVISION_ID
           AND O.FROM_SITE         = FS.SCM_SITE_ID
           AND O.DIVISION_ID       = TS.DIVISION_ID
           AND O.TO_SITE           = TS.SCM_SITE_ID
           AND R.DIVISION_ID(+)    = O.DIVISION_ID
           AND R.FROM_SITE(+)      = O.FROM_SITE
           AND R.TO_SITE(+)        = O.TO_SITE
           AND R.ITEM_ID(+)        = O.ITEM_ID
           AND MS.OPERATION_GROUP <> 'E'
           AND L.LOOKUP_TYPE       = 'SSP_SHIPMENT_RESULT_TYPE'   /* LOOKUP에 등록된 공정만 */
           AND L.SEGMENT1          = 'O'
           AND L.VALID_YN          = 'Y'
           AND FS.SITE_TYPE        = 'PLANT'
           AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
           AND FS.VALID_YN         = 'Y'
           AND TS.SITE_TYPE        = 'PLANT'
           AND TS.OPERATION_GROUP <> 'E'
           AND TS.VALID_YN         = 'Y'
           AND O.YYYYMMDD          BETWEEN P_FROM_YYYYMMDD AND V_CUTOFF_START_YYYYMMDD
           AND ( TRIM(P_SCM_SITE_ID) IS NULL
                 OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR O.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
--               OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--               OR O.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );   --  2026.10.07 AJS
                 OR O.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) );   --  2026.10.07 AJS

        /*---------------------------------------------
         * 3-2. 필터
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_FILTER
        ( DIVISION_ID, ITEM_ID, FROM_SITE )
        SELECT DISTINCT
               DIVISION_ID
             , ITEM_ID
             , FROM_SITE
          FROM ( SELECT DISTINCT
                        DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                   FROM GT_SSP0045_PLAN
                  UNION
                 SELECT DISTINCT
                        DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                   FROM GT_SSP0045_SHIP_REQ )  A;

        /*---------------------------------------------
         * 3-3. [C20201016-000147] : 소형(40) 사업부 조회를 위한 기준 테이블 생성
         *      SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다.
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_40_STD
        ( DIVISION_ID, FROM_SITE, PLAN_START_YYYYMMDD )
        SELECT DISTINCT
               DIVISION_ID
             , FROM_SITE
             , PLAN_START_YYYYMMDD
          FROM ( SELECT SP.DIVISION_ID
                      , SP.FROM_SITE
                      , SP.PLAN_START_YYYYMMDD
                      , RANK() OVER (PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC)  AS RANK_NO
                   FROM GT_SSP0045_FILTER         X1
                      , SSP_ANL_SHIP_PLAN_40      SP
                  WHERE X1.DIVISION_ID       = SP.DIVISION_ID
                    AND X1.FROM_SITE         = SP.FROM_SITE
                    AND X1.ITEM_ID           = SP.ITEM_ID
                    AND SP.DIVISION_ID       = P_DIVISION_ID
                    AND SP.PLAN_START_YYYYMMDD >= TO_CHAR(SYSDATE - 1, 'YYYYMMDD')      /* 전일 */
                    AND SP.PLAN_START_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')          /* 당일 */
                    AND SP.MEASURE           IN ('POSTP_PLAN', 'WH_IN', 'WH_STOCK')
                    AND SP.YYYYMMDD         >= V_PLAN_START_YYYYMMDD
                    AND SP.YYYYMMDD         <= P_TO_YYYYMMDD
                    AND SP.QTY               > 0
                    AND SP.DIVISION_ID       = '40'
               )  A
         WHERE RANK_NO = 1;

        /*---------------------------------------------
         * 4. ROW DATA 생성
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_ROW
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
        , LT_DAY, MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT TOT.DIVISION_ID
             , TOT.ITEM_ID
             , MAX(NVL(I.NICK_NAME, ' '))                     AS NICK_NAME
             , TOT.FROM_SITE
             , TOT.TO_SITE
             , TOT.TR_MODE
             , TOT.INCOTERMS
             , TOT.BOD_ID                                     AS BOD_ID      /* BOD 2단계 개발 */
             , TO_CHAR(MAX(NVL(BOD.LT_TOTAL, 0)))             AS LT_DAY
             , TOT.MEASURE
             , TOT.YYYYMMDD
             /* ★AS-IS 는 이 UNION ALL 에 소수 자리가 0 인 특성계획 수량(NUMERIC(38,0))이 섞여 있어
                MSSQL 이 묶음 전체의 소수 자리를 0 으로 정한다. 그 결과 모든 갈래의 수량이
                행 단위로 반올림된 뒤 합산된다(실측 : 24043.41192 -> 24043 · 48086.82336 -> 48087).
                TO-BE 의 NUMBER 에는 그 제약이 없으므로 같은 값을 내려면 반올림을 그대로 둔다 */
             , SUM(ROUND(TOT.QTY, 0))                         AS QTY
             , TOT.PROJECT_CODE
             , TOT.FCST_TYPE
             , TOT.SEQ
          FROM ( /* 1.SCP PLAN & 2.SHIP PLAN 추가 */
                 SELECT DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
                      , MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ
                   FROM GT_SSP0045_PLAN_ERP_RESULT
                  UNION ALL
                 /* 1.SCP PLAN & 2.SHIP PLAN 추가 */
                 SELECT DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
                      , MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ
                   FROM GT_SSP0045_PLAN
                  UNION ALL
                 /* 2.SHIP PLAN 추가 - Ship Frozen 이후 구간은 Ship Req의 수량을 더해준다. */
                 SELECT DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
                      , 'SHIP_PLAN'                           AS MEASURE
                      , YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE
                      , 2                                     AS SEQ
                   FROM GT_SSP0045_SHIP_REQ
                  WHERE YYYYMMDD >= FROZEN_YYYYMMDD
                  UNION ALL
                 /* 3.SHIP REQ 추가 */
                 SELECT DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
                      , MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE
                      , 3                                     AS SEQ
                   FROM GT_SSP0045_SHIP_REQ_OWMS
                  UNION ALL
                 /* 3.SHIP REQ 추가 */
                 SELECT DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
                      , MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE
                      , 3                                     AS SEQ
                   FROM GT_SSP0045_SHIP_REQ
                  UNION ALL
                 /*---------------------------------------------
                  * 4. Customer Plan : SSP(Daily) From Plant 기준 Sales향 Shipment Plan
                  *---------------------------------------------*/
                 SELECT SSP.DIVISION_ID
                      , SSP.ITEM_ID
                      , SSP.FROM_SITE
                      , '-'                                   AS TO_SITE
                      , '-'                                   AS TR_MODE
                      , '-'                                   AS INCOTERMS
                      , '-'                                   AS BOD_ID      /* BOD 2단계 개발 */
                      , 'CUST_PLAN'                           AS MEASURE
                      , SSP.YYYYMMDD
                      , SSP.QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 4                                     AS SEQ
                   FROM SSP_ANL_SHIP_CONFIRM      SSP
                      , SCP_MST_BOD_N_V           BOD         /* BOD 2단계 개발 : scp_mst_bod_v -> scp_mst_bod_n_v */
                      , SCM_MST_SITE              TS
                      , GT_SSP0045_FILTER         F
                  WHERE SSP.DIVISION_ID     = BOD.DIVISION_ID
                    AND SSP.BOD_ID          = BOD.BOD_ID
                    AND SSP.DIVISION_ID     = TS.DIVISION_ID
                    AND SSP.TO_SITE         = TS.SCM_SITE_ID
                    AND SSP.DIVISION_ID     = F.DIVISION_ID
                    AND SSP.ITEM_ID         = F.ITEM_ID
                    AND SSP.FROM_SITE       = F.FROM_SITE
                    AND TS.SITE_TYPE        = 'SALES'
                    AND TS.VALID_YN         = 'Y'
                    AND SSP.DIVISION_ID     = P_DIVISION_ID
                    AND SSP.QTY             > 0
                    AND SSP.YYYYMMDD       >= V_PLAN_START_YYYYMMDD
                    AND SSP.YYYYMMDD       <= P_TO_YYYYMMDD
                    AND SSP.BIZ_TYPE        = P_OPERATION_GROUP
                    AND SSP.CHANGE_TYPE     = 'C'
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR SSP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR SSP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR SSP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  UNION ALL
                 /*---------------------------------------------
                  * 5. Customer Req : 출하 요청(From Plant 기준 Sales향 Ship Req)
                  *                   DM_PLN_SHIPMENT_REQ / MEASURE = 'SHIP_REQ'
                  *---------------------------------------------*/
                 SELECT R.DIVISION_ID
                      , R.ITEM_ID
                      , R.PLANT_SITE_ID                       AS FROM_SITE
                      , '-'                                   AS TO_SITE
                      , '-'                                   AS TR_MODE
                      , '-'                                   AS INCOTERMS
                      , '-'                                   AS BOD_ID      /* BOD 2단계 개발 */
                      , 'CUST_REQ'                            AS MEASURE
                      , R.YYYYMMDD
                      , R.QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 5                                     AS SEQ
                   FROM DM_PLN_SHIPMENT_REQ       R
                      , SCM_MST_SITE              FS
                      , SCM_MST_SITE              TS
                      , GT_SSP0045_FILTER         F
                  WHERE R.DIVISION_ID       = FS.DIVISION_ID
                    AND R.PLANT_SITE_ID     = FS.SCM_SITE_ID
                    AND R.DIVISION_ID       = TS.DIVISION_ID
                    AND R.SCM_SITE_ID       = TS.SCM_SITE_ID
                    AND R.DIVISION_ID       = F.DIVISION_ID
                    AND R.ITEM_ID           = F.ITEM_ID
                    AND R.PLANT_SITE_ID     = F.FROM_SITE
                    AND FS.SITE_TYPE        = 'PLANT'
                    AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
                    /* 2021.10.21 : W/S AS 수정 , OSP_YN 조건 제거 */
                    AND FS.VALID_YN         = 'Y'
                    AND TS.SITE_TYPE        = 'SALES'
                    AND TS.VALID_YN         = 'Y'
                    AND R.DIVISION_ID       = P_DIVISION_ID
                    AND R.MEASURE           = 'SHIP_REQ'
                    AND R.YYYYMMDD         >= V_PLAN_START_YYYYMMDD
                    AND R.YYYYMMDD         <= P_TO_YYYYMMDD
                    AND R.QTY               > 0
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR R.PLANT_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR R.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR R.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  UNION ALL
                 /*---------------------------------------------
                  * 6. Internal movement
                  *---------------------------------------------*/
                 SELECT P.DIVISION_ID
                      , P.ITEM_ID
                      , FS.SCM_SITE_ID                        AS FROM_SITE
                      , '-'                                   AS TO_SITE
                      , '-'                                   AS TR_MODE
                      , '-'                                   AS INCOTERMS
                      , '-'                                   AS BOD_ID      /* BOD 2단계 개발 */
                      , 'INTN_MOVEMENT'                       AS MEASURE
                      , TO_CHAR(P.PLAN_DATE, 'YYYYMMDD')      AS YYYYMMDD
                      , P.QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 6                                     AS SEQ
                   FROM SCM_DNM_CELL_INHOUSE_PLAN_SN   P
                      , SCM_MST_SITE                   FS
                      , GT_SSP0045_FILTER              F
                  WHERE P.DIVISION_ID       = FS.DIVISION_ID
                    AND P.PLANT_ID          = FS.PLANT_ID
                    AND P.DIVISION_ID       = F.DIVISION_ID
                    AND P.ITEM_ID           = F.ITEM_ID
                    AND FS.SCM_SITE_ID      = F.FROM_SITE
                    AND FS.SITE_TYPE        = 'PLANT'
                    AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
                    /* 2021.10.21 : W/S AS 수정 , OSP_YN 조건 제거 */
                    AND FS.VALID_YN         = 'Y'
                    AND P.DIVISION_ID       = P_DIVISION_ID
                    AND P.CATEGORY          = 'MOVING'
                    AND P.PLAN_DATE        >= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                    AND P.PLAN_DATE        <= TO_DATE(P_TO_YYYYMMDD, 'YYYYMMDD')
                    AND P.QTY               > 0
                    AND P.DIVISION_ID      <> '40'            /* [C20201016-000147] : 소형(40) 제외,KHJ79 */
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR FS.SCM_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR P.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR P.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  UNION ALL
                 /* [C20201016-000147] : 소형(40) 사업부 추가, KHJ79 */
                 SELECT SP.DIVISION_ID
                      , SP.ITEM_ID
                      , SP.FROM_SITE
                      , SP.TO_SITE
                      , SP.TRANSPORT_MODE                     AS TR_MODE
                      , SP.INCOTERMS
                      , '-'                                   AS BOD_ID      /* BOD 2단계 개발 */
                      , 'INTN_MOVEMENT'                       AS MEASURE
                      , SP.YYYYMMDD
                      , SP.QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 6                                     AS SEQ
                   FROM SSP_ANL_SHIP_PLAN_40        SP
                      , SCM_MST_SITE                FS
                      , GT_SSP0045_FILTER           F
                      , GT_SSP0045_40_STD           ST
                  WHERE SP.DIVISION_ID          = FS.DIVISION_ID
                    AND SP.FROM_SITE            = FS.SCM_SITE_ID
                    AND SP.DIVISION_ID          = F.DIVISION_ID
                    AND SP.ITEM_ID              = F.ITEM_ID
                    AND SP.FROM_SITE            = F.FROM_SITE
                    AND ST.DIVISION_ID          = SP.DIVISION_ID
                    AND ST.FROM_SITE            = SP.FROM_SITE
                    AND ST.PLAN_START_YYYYMMDD  = SP.PLAN_START_YYYYMMDD
                    AND FS.SITE_TYPE            = 'PLANT'
                    /* 2021.10.21 : W/S AS 수정 , OPERATION_GROUP 파라미터 처리 및 OSP_YN 조건 제거 */
                    AND FS.OPERATION_GROUP      = P_OPERATION_GROUP
                    AND FS.VALID_YN             = 'Y'
                    AND SP.MEASURE              = 'POSTP_PLAN'
                    AND SP.DIVISION_ID          = P_DIVISION_ID
                    AND SP.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
                    AND SP.YYYYMMDD            <= P_TO_YYYYMMDD
                    AND SP.QTY                  > 0
                    AND SP.DIVISION_ID          = '40'        /* 소형(40) 인 경우만 조회 */
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR SP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR SP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR SP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  UNION ALL
                 /*---------------------------------------------
                  * 7. Inspection plan : FP 특성계획
                  *---------------------------------------------*/
                 SELECT FP.DIVISION_ID
                      , FP.ITEM_ID
                      , FP.SCM_SITE_ID                        AS FROM_SITE
                      , '-'                                   AS TO_SITE
                      , '-'                                   AS TR_MODE
                      , '-'                                   AS INCOTERMS
                      , '-'                                   AS BOD_ID      /* BOD 2단계 개발 */
                      , 'INSP_PLAN'                           AS MEASURE
                      , TO_CHAR(FP.PLAN_DATE, 'YYYYMMDD')     AS YYYYMMDD
                      , FP.PLAN_QTY                           AS QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 7                                     AS SEQ
                   FROM SCM_DNM_PLAN_FROZEN_V       FP
                      , SCM_MST_SITE                FS
                      , GT_SSP0045_FILTER           F
                  WHERE FP.DIVISION_ID      = FS.DIVISION_ID
                    AND FP.SCM_SITE_ID      = FS.SCM_SITE_ID
                    AND FP.DIVISION_ID      = F.DIVISION_ID
                    AND FP.ITEM_ID          = F.ITEM_ID
                    AND FP.SCM_SITE_ID      = F.FROM_SITE
                    AND FS.SITE_TYPE        = 'PLANT'
                    AND FS.OPERATION_GROUP  = P_OPERATION_GROUP
                    /* 2021.10.21 : W/S AS 수정 , OSP_YN 조건 제거 */
                    AND FS.VALID_YN         = 'Y'
                    AND FP.DIVISION_ID      = P_DIVISION_ID
                    AND FP.PLAN_DATE       >= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
                    AND FP.PLAN_DATE       <= TO_DATE(P_TO_YYYYMMDD, 'YYYYMMDD')
                    AND FP.PLAN_QTY         > 0
                    AND FP.PLAN_IN_QTY      > 0
                    /* (참고) division_id <> '40' 일때는 'F6000' 데이터만 존재하므로 operation_id 조건에'F5300', 'F5500', 'F5600' 도 포함시켜도 상관없음 */
                    AND FP.OPERATION_ID IN (SELECT SEGMENT1
                                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                             WHERE LOOKUP_TYPE = 'OPERATION_CHAR'
                                               AND VALID_YN    = 'Y')
                    AND FP.DIVISION_ID     <> '40'            /* C20201016-000147 : 소형(40) 제외,KHJ79 */
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR FP.SCM_SITE_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR FP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR FP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                  UNION ALL
                 /* [C20201016-000147] : 소형(40) 사업부 추가, KHJ79 */
                 SELECT SP.DIVISION_ID
                      , SP.ITEM_ID
                      , SP.FROM_SITE
                      , SP.TO_SITE
                      , SP.TRANSPORT_MODE                     AS TR_MODE
                      , SP.INCOTERMS
                      , '-'                                   AS BOD_ID      /* BOD 2단계 개발 */
                      , 'INSP_PLAN'                           AS MEASURE
                      , SP.YYYYMMDD
                      , SP.QTY
                      , '-'                                   AS PROJECT_CODE
                      , '-'                                   AS FCST_TYPE
                      , 7                                     AS SEQ
                   FROM SSP_ANL_SHIP_PLAN_40        SP
                      , SCM_MST_SITE                FS
                      , GT_SSP0045_FILTER           F
                      , GT_SSP0045_40_STD           ST
                  WHERE SP.DIVISION_ID          = FS.DIVISION_ID
                    AND SP.FROM_SITE            = FS.SCM_SITE_ID
                    AND SP.DIVISION_ID          = F.DIVISION_ID
                    AND SP.ITEM_ID              = F.ITEM_ID
                    AND SP.FROM_SITE            = F.FROM_SITE
                    AND ST.DIVISION_ID          = SP.DIVISION_ID
                    AND ST.FROM_SITE            = SP.FROM_SITE
                    AND ST.PLAN_START_YYYYMMDD  = SP.PLAN_START_YYYYMMDD
                    AND FS.SITE_TYPE            = 'PLANT'
                    /* 2021.10.21 : W/S AS 수정 , OPERATION_GROUP 파라미터 처리 및 OSP_YN 조건 제거 */
                    AND FS.OPERATION_GROUP      = P_OPERATION_GROUP
                    AND FS.VALID_YN             = 'Y'
                    AND SP.MEASURE              = 'WH_IN'
                    AND SP.DIVISION_ID          = P_DIVISION_ID
                    AND SP.YYYYMMDD            >= V_PLAN_START_YYYYMMDD
                    AND SP.YYYYMMDD            <= P_TO_YYYYMMDD
                    AND SP.QTY                  > 0
                    AND SP.DIVISION_ID          = '40'        /* 소형(40) 인 경우만 조회 */
                    AND ( TRIM(P_SCM_SITE_ID) IS NULL
                          OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR SP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                    AND ( TRIM(P_ITEM_ID) IS NULL
--                        OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                          OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                        OR SP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                          OR SP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
               )  TOT
             , SCP_MST_BOD_N_V         BOD           /* BOD 2단계 개발 : FROM , TO 조건 추가 */
             -- 2026.10.06 AJS 약칭 묶음을 이번 조회 품목으로 한정 (결과 동일) (START)
--             , ( SELECT ITEM_ID
--                      , MAX(NICK_NAME)                        AS NICK_NAME
--                   FROM SCM_MST_ITEM_SN
--                  WHERE NICK_NAME IS NOT NULL
--                  GROUP BY ITEM_ID )  I
             , ( SELECT ITEM_ID
                      , MAX(NICK_NAME)                        AS NICK_NAME
                   FROM SCM_MST_ITEM_SN
                  WHERE NICK_NAME IS NOT NULL
                    AND ITEM_ID IN (SELECT XA.ITEM_ID
                                      FROM GT_SSP0045_PLAN_ERP_RESULT XA
                                     UNION ALL
                                    SELECT XB.ITEM_ID
                                      FROM GT_SSP0045_PLAN XB
                                     UNION ALL
                                    SELECT XC.ITEM_ID
                                      FROM GT_SSP0045_SHIP_REQ XC
                                     UNION ALL
                                    SELECT XD.ITEM_ID
                                      FROM GT_SSP0045_SHIP_REQ_OWMS XD
                                     UNION ALL
                                    SELECT XE.ITEM_ID
                                      FROM GT_SSP0045_FILTER XE)
                  GROUP BY ITEM_ID )  I
             -- 2026.10.06 AJS 약칭 묶음을 이번 조회 품목으로 한정 (결과 동일) (END)
         WHERE TOT.DIVISION_ID   = BOD.DIVISION_ID(+)
           AND TOT.BOD_ID        = BOD.BOD_ID(+)
           AND TOT.ITEM_ID       = I.ITEM_ID(+)
         GROUP BY TOT.DIVISION_ID
                , TOT.ITEM_ID
                , TOT.FROM_SITE
                , TOT.TO_SITE
                , TOT.TR_MODE
                , TOT.INCOTERMS
                , TOT.MEASURE
                , TOT.YYYYMMDD
                , TOT.PROJECT_CODE
                , TOT.FCST_TYPE
                , TOT.SEQ
                , TOT.BOD_ID;                                  /* BOD 2단계 개발 */

        /* LT DAY 삭제 */
        UPDATE GT_SSP0045_SHIP_ROW
           SET LT_DAY = '-'
         WHERE MEASURE IN ('CUST_PLAN', 'CUST_REQ', 'INTN_MOVEMENT', 'INSP_PLAN');

        /*---------------------------------------------
         * 5. STOCK INV
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_STOCK
        ( DIVISION_ID, ITEM_ID, FROM_SITE, YYYYMMDD, QTY )
        SELECT INV.DIVISION_ID
             , INV.ITEM_ID
             , INV.SCM_SITE_ID                                AS FROM_SITE
             , V_PLAN_START_YYYYMMDD                          AS YYYYMMDD
             , INV.SSP_QTY                                    AS QTY         /* SSP용 dbo.SSP_DNM_STOCK_C */
          FROM SSP_DNM_STOCK_C        INV
             , ( SELECT DIVISION_ID
                      , SITE_ID
                      , MAX(CUTOFF_DATE)                      AS MAX_CUTOFF_DATE
                   FROM SSP_DNM_STOCK_C
                  WHERE DIVISION_ID  = P_DIVISION_ID
                    /* ★AS-IS 는 문자끼리 견주나 TO-BE 의 CUTOFF_DATE 는 날짜 칸이라 형을 맞춘다 */
                    AND CUTOFF_DATE  > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')       /* 현재일 - 3 */
                    AND CUTOFF_DATE <= TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')  /* 변수 : 현재일 */
                  GROUP BY DIVISION_ID
                         , SITE_ID )  MS
             , ( SELECT DIVISION_ID
                      , SCM_SITE_ID
                      , OPERATION_GROUP
                      , SITE_TYPE
                   FROM SCM_MST_SITE
                  WHERE DIVISION_ID      = P_DIVISION_ID
                    AND SITE_TYPE        = 'PLANT'
                    AND OPERATION_GROUP  = P_OPERATION_GROUP                 /* Cell Plant Site */
                    AND VALID_YN         = 'Y' )  B
             , ( SELECT DISTINCT
                        A.STORAGE_ID
                      , A.LOCATION_CODE
                      , A.SCM_SITE_ID
                      , A.DIVISION_ID
                      , A.OPERATION_ID
                   FROM SCM_MST_LOCATION   A
                      , SCM_MST_SITE       SB
                  WHERE A.SCM_SITE_ID      = SB.SCM_SITE_ID
                    AND SB.DIVISION_ID     = P_DIVISION_ID
                    AND SB.VALID_YN        = 'Y'
                    AND SB.OPERATION_GROUP = P_OPERATION_GROUP               /* Cell Plant Site */
                    AND A.DIVISION_ID      = P_DIVISION_ID
                    AND A.VALID_YN         = 'Y'
                    /* 2019.10.31 BOH(STOCK_V) 조회 시 FORMATION_CHECK_PACKAGING 재고 포함 */
                    /* Cell 특성완료 이후 창고 */
                    AND A.LOCATION_CODE IN ('CELL_OWMS', 'FORMATION_CHECK_PACKAGING')
                    AND ( A.STORAGE_ID IS NOT NULL OR A.OPERATION_ID IS NOT NULL ) )  C
         WHERE INV.DIVISION_ID   = MS.DIVISION_ID
           AND INV.SITE_ID       = MS.SITE_ID
           AND INV.CUTOFF_DATE   = MS.MAX_CUTOFF_DATE
           AND INV.DIVISION_ID   = B.DIVISION_ID
           AND INV.SCM_SITE_ID   = B.SCM_SITE_ID
           AND INV.DIVISION_ID   = C.DIVISION_ID
           AND INV.SCM_SITE_ID   = C.SCM_SITE_ID
           AND ( INV.STORAGE_ID  = C.STORAGE_ID OR INV.OPERATION_ID = C.OPERATION_ID )
           AND INV.CUTOFF_DATE   > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')
           AND P_DIVISION_ID    <> '40'                       /* [C20201016-000147] : 소형(40) 사업부 제외 ,khj79 */
         UNION ALL
        /* [C20201016-000147] : 소형(40) 사업부 추가, khj79 */
        SELECT SP.DIVISION_ID
             , SP.ITEM_ID
             , SP.FROM_SITE
             , SP.YYYYMMDD
             , SP.QTY
          FROM SSP_ANL_SHIP_PLAN_40        SP
             , SCM_MST_SITE                FS
             , GT_SSP0045_FILTER           F
             , GT_SSP0045_40_STD           ST
         WHERE SP.DIVISION_ID          = FS.DIVISION_ID
           AND SP.FROM_SITE            = FS.SCM_SITE_ID
           AND SP.DIVISION_ID          = F.DIVISION_ID
           AND SP.ITEM_ID              = F.ITEM_ID
           AND SP.FROM_SITE            = F.FROM_SITE
           AND ST.DIVISION_ID          = SP.DIVISION_ID
           AND ST.FROM_SITE            = SP.FROM_SITE
           AND ST.PLAN_START_YYYYMMDD  = SP.PLAN_START_YYYYMMDD
           AND FS.SITE_TYPE            = 'PLANT'
           /* 2021.10.21 : W/S AS 수정 , OPERATION_GROUP 파라미터 처리 및 OSP_YN 조건 제거 */
           AND FS.OPERATION_GROUP      = P_OPERATION_GROUP
           AND FS.VALID_YN             = 'Y'
           AND SP.MEASURE              = 'WH_STOCK'
           AND SP.DIVISION_ID          = P_DIVISION_ID
           AND SP.YYYYMMDD             = V_PLAN_START_YYYYMMDD
           AND SP.QTY                  > 0
           AND SP.DIVISION_ID          = '40'                 /* 소형(40) 인 경우만 조회 */
           AND ( TRIM(P_SCM_SITE_ID) IS NULL
                 OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR SP.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
           AND ( TRIM(P_ITEM_ID) IS NULL
--               OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                 OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--               OR SP.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) );   --  2026.10.07 AJS
                 OR SP.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) );   --  2026.10.07 AJS

        /*---------------------------------------------
         * 6. 일자별 BOH 계산
         *   ★AS-IS 가 CTE 세 벌(Z · QTY · BOH)로 적던 구간을 인라인 뷰로 옮긴다.
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_CAL_QTY
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, YYYYMMDD, PLAN_QTY, REQ_QTY )
        SELECT Z.DIVISION_ID
             , Z.ITEM_ID
             , Z.NICK_NAME
             , Z.FROM_SITE
             , Z.YYYYMMDD
             , ( SELECT NVL(SUM(X.PLAN_QTY), 0)
                   FROM ( SELECT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                               , YYYYMMDD
                               , NVL(SUM(CASE WHEN MEASURE = 'SHIP_PLAN'     THEN -1 * NVL(QTY, 0)
                                              WHEN MEASURE = 'CUST_PLAN'     THEN -1 * NVL(QTY, 0)
                                              WHEN MEASURE = 'INTN_MOVEMENT' THEN -1 * NVL(QTY, 0)
                                              WHEN MEASURE = 'INSP_PLAN'     THEN NVL(QTY, 0)
                                              ELSE 0.0
                                         END), 0)                            AS PLAN_QTY
                            FROM GT_SSP0045_SHIP_ROW
                           WHERE MEASURE IN ('SHIP_PLAN', 'SHIP_REQ', 'CUST_PLAN', 'CUST_REQ', 'INTN_MOVEMENT', 'INSP_PLAN')
                             AND YYYYMMDD >= V_PLAN_START_YYYYMMDD
                             AND YYYYMMDD <= P_TO_YYYYMMDD
                           GROUP BY DIVISION_ID
                                  , ITEM_ID
                                  , FROM_SITE
                                  , YYYYMMDD )  X
                  WHERE X.DIVISION_ID = Z.DIVISION_ID
                    AND X.ITEM_ID     = Z.ITEM_ID
                    AND X.FROM_SITE   = Z.FROM_SITE
                    AND X.YYYYMMDD    < Z.YYYYMMDD ) + NVL(BOH.QTY, 0)       AS PLAN_QTY
             , ( SELECT NVL(SUM(X.REQ_QTY), 0)
                   FROM ( SELECT DIVISION_ID
                               , ITEM_ID
                               , FROM_SITE
                               , YYYYMMDD
                               , NVL(SUM(CASE WHEN MEASURE = 'SHIP_REQ'      THEN -1 * NVL(QTY, 0)
                                              WHEN MEASURE = 'CUST_REQ'      THEN -1 * NVL(QTY, 0)
                                              WHEN MEASURE = 'INTN_MOVEMENT' THEN -1 * NVL(QTY, 0)
                                              WHEN MEASURE = 'INSP_PLAN'     THEN NVL(QTY, 0)
                                              ELSE 0.0
                                         END), 0)                            AS REQ_QTY
                            FROM GT_SSP0045_SHIP_ROW
                           WHERE MEASURE IN ('SHIP_PLAN', 'SHIP_REQ', 'CUST_PLAN', 'CUST_REQ', 'INTN_MOVEMENT', 'INSP_PLAN')
                             AND YYYYMMDD >= V_PLAN_START_YYYYMMDD
                             AND YYYYMMDD <= P_TO_YYYYMMDD
                           GROUP BY DIVISION_ID
                                  , ITEM_ID
                                  , FROM_SITE
                                  , YYYYMMDD )  X
                  WHERE X.DIVISION_ID = Z.DIVISION_ID
                    AND X.ITEM_ID     = Z.ITEM_ID
                    AND X.FROM_SITE   = Z.FROM_SITE
                    AND X.YYYYMMDD    < Z.YYYYMMDD ) + NVL(BOH.QTY, 0)       AS REQ_QTY
          FROM ( SELECT DISTINCT
                        R.DIVISION_ID
                      , R.ITEM_ID
                      , R.NICK_NAME
                      , R.FROM_SITE
                      , O.BASIS_YYYYMMDD                      AS YYYYMMDD
                   FROM SCM_SYS_CALENDAR_M    O
                      , ( SELECT DISTINCT
                                 DIVISION_ID
                               , ITEM_ID
                               , NICK_NAME
                               , FROM_SITE
                            FROM GT_SSP0045_SHIP_ROW )  R
                  WHERE O.BASIS_YYYYMMDD >= V_PLAN_START_YYYYMMDD
                    AND O.BASIS_YYYYMMDD <= P_TO_YYYYMMDD )  Z
             , ( SELECT V.DIVISION_ID
                      , V.ITEM_ID
                      , V.FROM_SITE
                      , SUM(V.QTY)                            AS QTY
                   FROM ( SELECT INV.DIVISION_ID
                               , INV.ITEM_ID
                               , INV.FROM_SITE
                               , INV.YYYYMMDD
                               , INV.QTY                                     /* SSP용 */
                            FROM GT_SSP0045_STOCK      INV                   /* 20200401 속도개선. TEMP Table 사용. */
                               , SCP_MST_FINAL_ITEM    FI
                           WHERE INV.DIVISION_ID    = FI.DIVISION_ID
                             AND INV.ITEM_ID        = FI.ITEM_ID
                             AND FI.OPERATION_GROUP = P_OPERATION_GROUP
                             AND ( TRIM(P_SCM_SITE_ID) IS NULL
                                   OR UPPER(P_SCM_SITE_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                                   OR INV.FROM_SITE IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_SCM_SITE_ID, ','))) )
                             AND ( TRIM(P_ITEM_ID) IS NULL
--                                 OR UPPER(P_ITEM_ID) = 'ALL'   /* 2026.10.08 AJS 조회조건 ALL */
                                   OR UPPER(TRIM(P_ITEM_ID)) = 'ALL'   /* AJS 20261008 Model/Nickname */
--                                 OR INV.ITEM_ID IN (SELECT UPPER(COLUMN_VALUE) FROM TABLE(STRING_SPLIT(P_ITEM_ID, ','))) )   --  2026.10.07 AJS
                                   OR INV.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)) )   --  2026.10.07 AJS
                        )  V
                  GROUP BY V.DIVISION_ID
                         , V.ITEM_ID
                         , V.FROM_SITE )  BOH
         WHERE Z.DIVISION_ID = BOH.DIVISION_ID(+)
           AND Z.ITEM_ID     = BOH.ITEM_ID(+)
           AND Z.FROM_SITE   = BOH.FROM_SITE(+);

        /*---------------------------------------------
         * 8. W/H BOH(Plan) : Cell Plant의 Cell 재고
         *    일자별 BOH 계산  : BOH(D+1) = BOH(D) - Ship Plan(D) - Customer Plan(D) - Internal movement(D) + Inspection Plan(D)
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_ROW
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
        , LT_DAY, MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT DIVISION_ID
             , ITEM_ID
             , NICK_NAME
             , FROM_SITE
             , '-'                                            AS TO_SITE
             , '-'                                            AS TR_MODE
             , '-'                                            AS INCOTERMS
             , '-'                                            AS BOD_ID      /* BOD 2단계 개발 */
             , '-'                                            AS LT_DAY
             , 'WH_BOH_PLAN'                                  AS MEASURE
             , YYYYMMDD
             , NVL(PLAN_QTY, 0)                               AS QTY
             , '-'                                            AS PROJECT_CODE
             , '-'                                            AS FCST_TYPE
             , 8                                              AS SEQ
          FROM GT_SSP0045_CAL_QTY;

        /*---------------------------------------------
         * 9. W/H BOH(Req) : Cell Plant의 Cell 재고
         *    일자별 BOH 계산  : BOH(D+1) = BOH(D) - Ship Req(D) - Customer Req(D) - Internal movement(D) + Inspection Plan(D)
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_ROW
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
        , LT_DAY, MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT DIVISION_ID
             , ITEM_ID
             , NICK_NAME
             , FROM_SITE
             , '-'                                            AS TO_SITE
             , '-'                                            AS TR_MODE
             , '-'                                            AS INCOTERMS
             , '-'                                            AS BOD_ID      /* BOD 2단계 개발 */
             , '-'                                            AS LT_DAY
             , 'WH_BOH_REQ'                                   AS MEASURE
             , YYYYMMDD
             , NVL(REQ_QTY, 0)                                AS QTY
             , '-'                                            AS PROJECT_CODE
             , '-'                                            AS FCST_TYPE
             , 9                                              AS SEQ
          FROM GT_SSP0045_CAL_QTY;

        /*---------------------------------------------
         * 10. Requestor
         *     2020.01.03  Requestor 조회 시 Last Updated By 가 scp_batch인 것은 제외
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_REQUESTOR
        ( DIVISION_ID, ITEM_ID, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID, MEASURE, LAST_UPDATED_BY )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.TR_MODE
             , A.INCOTERMS
             , A.BOD_ID                                       /* BOD 2단계 개발 */
             , A.MEASURE
             , A.LAST_UPDATED_BY
          FROM GT_SSP0045_SHIP_REQ    A
         WHERE A.RN = (SELECT NVL(MIN(B.RN), 1)
                         FROM GT_SSP0045_SHIP_REQ B
                        WHERE B.DIVISION_ID     = A.DIVISION_ID
                          AND B.ITEM_ID         = A.ITEM_ID
                          AND B.FROM_SITE       = A.FROM_SITE
                          AND B.TO_SITE         = A.TO_SITE
                          AND B.TR_MODE         = A.TR_MODE
                          AND B.INCOTERMS       = A.INCOTERMS
                          AND B.MEASURE         = A.MEASURE
                          AND B.LAST_UPDATED_BY <> 'scp_batch');

        /*---------------------------------------------
         * 11. UI용 Measure 추가
         *     MEASURE : SCP_PLAN, SHIP_PLAN, SHIP_REQ
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_ROW
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
        , LT_DAY, MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , A.FROM_SITE
             , A.TO_SITE
             , A.TR_MODE
             , A.INCOTERMS
             , A.BOD_ID                                       /* BOD 2단계 개발 */
             , A.LT_DAY
             , M.COLUMN_NAME                                  AS MEASURE
             , O.BASIS_YYYYMMDD
             , NULL                                           AS QTY
             , A.PROJECT_CODE                                 AS PROJECT_CODE
             , A.FCST_TYPE                                    AS FCST_TYPE
             , M.SORT_ORDER_NO                                AS SEQ
          FROM GT_SSP0045_SHIP_ROW        A
             , SCM_SYS_CALENDAR_M         O
             , SCM_MST_SHEET_MEASURE      M
         WHERE O.BASIS_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND M.PROGRAM_ID      = P_PROGRAM_ID
           AND M.SHEET_NAME      = P_SHEET_NAME
           AND M.COLUMN_NAME     IN ('SCP_PLAN', 'SHIP_PLAN', 'SHIP_REQ')
           AND A.MEASURE         IN ('SCP_PLAN', 'SHIP_PLAN', 'SHIP_REQ')
           AND NOT EXISTS (SELECT 1
                             FROM GT_SSP0045_SHIP_ROW B
                            WHERE B.DIVISION_ID  = A.DIVISION_ID
                              AND B.ITEM_ID      = A.ITEM_ID
                              AND B.FROM_SITE    = A.FROM_SITE
                              AND B.TO_SITE      = A.TO_SITE
                              AND B.TR_MODE      = A.TR_MODE
                              AND B.INCOTERMS    = A.INCOTERMS
                              AND B.BOD_ID       = A.BOD_ID                  /* BOD 2단계 개발 */
                              AND B.PROJECT_CODE = A.PROJECT_CODE
                              AND B.FCST_TYPE    = A.FCST_TYPE
                              AND B.MEASURE      = M.COLUMN_NAME
                              AND B.YYYYMMDD     = O.BASIS_YYYYMMDD);

        /* MEASURE : CUST_PLAN, CUST_REQ, INTN_MOVEMENT, INSP_PLAN */
        INSERT INTO GT_SSP0045_SHIP_ROW
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
        , LT_DAY, MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT DISTINCT
               A.DIVISION_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , A.FROM_SITE
             , '-'                                            AS TO_SITE
             , '-'                                            AS TR_MODE
             , '-'                                            AS INCOTERMS
             , '-'                                            AS BOD_ID      /* BOD 2단계 개발 */
             , '-'                                            AS LT_DAY
             , M.COLUMN_NAME                                  AS MEASURE
             , O.BASIS_YYYYMMDD
             , NULL                                           AS QTY
             , '-'                                            AS PROJECT_CODE
             , '-'                                            AS FCST_TYPE
             , M.SORT_ORDER_NO                                AS SEQ
          FROM GT_SSP0045_SHIP_ROW        A
             , SCM_SYS_CALENDAR_M         O
             , SCM_MST_SHEET_MEASURE      M
         WHERE O.BASIS_YYYYMMDD  = V_PLAN_START_YYYYMMDD
           AND M.PROGRAM_ID      = P_PROGRAM_ID
           AND M.SHEET_NAME      = P_SHEET_NAME
           AND M.COLUMN_NAME     IN ('CUST_PLAN', 'CUST_REQ', 'INTN_MOVEMENT', 'INSP_PLAN')
           AND A.MEASURE         IN ('SCP_PLAN', 'SHIP_PLAN', 'SHIP_REQ')
           AND NOT EXISTS (SELECT 1
                             FROM GT_SSP0045_SHIP_ROW B
                            WHERE B.DIVISION_ID  = A.DIVISION_ID
                              AND B.ITEM_ID      = A.ITEM_ID
                              AND B.FROM_SITE    = A.FROM_SITE
                              AND B.TO_SITE      = '-'
                              AND B.TR_MODE      = '-'
                              AND B.INCOTERMS    = '-'
                              AND B.BOD_ID       = '-'                       /* BOD 2단계 개발 */
                              AND B.MEASURE      = M.COLUMN_NAME
                              AND B.YYYYMMDD     = O.BASIS_YYYYMMDD);

        /*---------------------------------------------
         * 12. PIVOT용 Data정리
         *---------------------------------------------*/
        INSERT INTO GT_SSP0045_SHIP_PIVOT
        ( DIVISION_ID, ITEM_ID, NICK_NAME, FROM_SITE, TO_SITE, TR_MODE, INCOTERMS, BOD_ID
        , LT_DAY, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, PROJECT_CODE, FCST_TYPE, SEQ )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.NICK_NAME
             , A.FROM_SITE
             , A.TO_SITE
             , A.TR_MODE
             , A.INCOTERMS
             , NVL(A.BOD_ID, '-')                             AS BOD_ID      /* BOD 2단계 개발 */
             , A.LT_DAY
             , A.MEASURE
             , 'D_'||A.YYYYMMDD                               AS YYYYMMDD
             , O.BASIS_YYYYMM                                 AS YYYYMM
             , SUBSTR(O.BASIS_YYYYMM, -4)||O.ISO_WEEK         AS ISO_WEEK
             , A.QTY
             , A.PROJECT_CODE
             , A.FCST_TYPE
             , A.SEQ
          FROM GT_SSP0045_SHIP_ROW     A
             , SCM_SYS_CALENDAR_M      O
         WHERE A.YYYYMMDD = O.BASIS_YYYYMMDD;

        /*---------------------------------------------
         * 13. PIVOIT처리
         *     피벗 대상 날짜 칸 만들기 — 칸 수가 기간에 따라 달라지므로 이 부분만 동적 SQL
         *---------------------------------------------*/
        DBMS_LOB.CREATETEMPORARY(V_PIVOT, TRUE);
        FOR C IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_'||BASIS_YYYYMM||ISO_WEEK          AS YYYYMMDD
                                 , BASIS_START_DATE||'21'                AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMM
                                    , ISO_WEEK
                                    , BASIS_START_DATE
                             UNION ALL
                            SELECT 'M_'||BASIS_YYYYMM                    AS YYYYMMDD
                                 , MIN(BASIS_START_DATE)||'01'           AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMM
                                    , MONTH_NAME
                             UNION ALL
                            SELECT 'D_'||BASIS_YYYYMMDD                  AS YYYYMMDD
                                 , BASIS_YYYYMMDD||'31'                  AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M
                             WHERE BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY BASIS_YYYYMMDD
                          )  IA
                    ORDER BY SORT_ORDER_NO )
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_PIVOT, ', SUM(CASE WHEN P.YYYYMM = '''||SUBSTR(C.YYYYMMDD, -6)
                                || ''' THEN P.QTY END) AS '||C.YYYYMMDD||CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_PIVOT, ', SUM(CASE WHEN P.ISO_WEEK = '''||SUBSTR(C.YYYYMMDD, -6)
                                || ''' THEN P.QTY END) AS '||C.YYYYMMDD||CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_PIVOT, ', SUM(CASE WHEN P.YYYYMMDD = '''||C.YYYYMMDD
                                || ''' THEN P.QTY END) AS '||C.YYYYMMDD||CHR(10));
            END IF;
        END LOOP;

        DBMS_LOB.CREATETEMPORARY(V_SQL, TRUE);
        DBMS_LOB.APPEND(V_SQL,
             'SELECT P.DIVISION_ID'||CHR(10)
          || '     , P.ITEM_ID'||CHR(10)
          || '     , NVL(NULLIF(P.NICK_NAME, '' ''), '' '') AS NICK_NAME'||CHR(10)
          || '     , P.FROM_SITE'||CHR(10)
          || '     , P.TO_SITE'||CHR(10)
          || '     , P.TR_MODE'||CHR(10)
          || '     , P.INCOTERMS'||CHR(10)
          || '     , P.BOD_ID'||CHR(10)                                      /* BOD 2단계 개발 */
          /* 확정구간 조회 일수 펑션 수정([FN_GET_SSP_ANL_SHIP_FROZEN -> FN_GET_ANL_SHIP_FROZEN_DAY_CNT]), HSBANG, 2024.05.16 */
          || '     , TO_CHAR(TO_DATE(:B_PLAN_START1, ''YYYYMMDD'')'||CHR(10)
          || '               + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(:B_APP_TYPE1, P.DIVISION_ID, P.FROM_SITE, :B_PLAN_START2)'||CHR(10)
          || '               , ''YYYYMMDD'') AS BOD_FROM_YYYYMMDD'||CHR(10)
          || '     , :B_TO_YYYYMMDD AS BOD_TO_YYYYMMDD'||CHR(10)             /* BOD 2단계 개발 */
          || '     , P.LT_DAY'||CHR(10)
          /* ★AS-IS 는 이어붙이는 값 하나라도 없으면 문장 전체가 빈 값이 된다. 그 동작을 맞춘다 */
          /* 2026.09.30 AJS 수정 (START) */
--          || '     , CASE WHEN C.USERNAME IS NULL OR C.USERID IS NULL THEN NULL'||CHR(10)
--          || '            ELSE C.USERNAME||''(''||C.USERID||'')'' END AS LAST_UPDATED_BY'||CHR(10)
          || '     , CASE WHEN C.USER_NM IS NULL OR C.USER_ID IS NULL THEN NULL'||CHR(10)
          || '            ELSE C.USER_NM||''(''||C.USER_ID||'')'' END AS LAST_UPDATED_BY'||CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '     , P.SEQ'||CHR(10)
          || '     , P.PROJECT_CODE'||CHR(10)
          || '     , P.FCST_TYPE'||CHR(10)
          || '     , TO_CHAR(TO_DATE(:B_PLAN_START3, ''YYYYMMDD'')'||CHR(10)
          || '               + FN_GET_ANL_SHIP_FROZEN_DAY_CNT(:B_APP_TYPE2, P.DIVISION_ID, P.FROM_SITE, :B_PLAN_START4)'||CHR(10)
          || '               , ''YYYYMMDD'') AS FROZEN_YYYYMMDD'||CHR(10)
          || '     , M.ATTRIBUTE3 AS MEASURE_COLOR'||CHR(10)
          /* [C20201016-000147] : 소형(40) 사업부 추가 - 소형인 경우 MEASURE 명 변경 */
          || '     , CASE WHEN P.DIVISION_ID = ''40'' AND P.MEASURE = ''INSP_PLAN''     THEN ''WH in Plan'''||CHR(10)
          || '            WHEN P.DIVISION_ID = ''40'' AND P.MEASURE = ''INTN_MOVEMENT'' THEN ''Post Process Plan'''||CHR(10)
          || '            ELSE M.COLUMN_LABEL_NAME END AS MEASURE_LABEL'||CHR(10)
          || '     , P.MEASURE'||CHR(10));
        DBMS_LOB.APPEND(V_SQL, V_PIVOT);
        DBMS_LOB.APPEND(V_SQL,
             '  FROM GT_SSP0045_SHIP_PIVOT   P'||CHR(10)
          || '     , GT_SSP0045_REQUESTOR    R'||CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '     , TB_FX_USER              C'||CHR(10)
          || '     , SCM_ADM_USER_M          C'||CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '     , SCP_MST_BOD_N_V         B'||CHR(10)                     /* BOD 2단계 개발 : FROM , TO 추가 */
          || '     , SCM_MST_SHEET_MEASURE   M'||CHR(10)
          || '     , SCM_MST_SITE            S'||CHR(10)
          || ' WHERE R.DIVISION_ID(+)   = P.DIVISION_ID'||CHR(10)
          || '   AND R.ITEM_ID(+)       = P.ITEM_ID'||CHR(10)
          || '   AND R.FROM_SITE(+)     = P.FROM_SITE'||CHR(10)
          || '   AND R.TO_SITE(+)       = P.TO_SITE'||CHR(10)
          || '   AND R.TR_MODE(+)       = P.TR_MODE'||CHR(10)
          || '   AND R.INCOTERMS(+)     = P.INCOTERMS'||CHR(10)
          || '   AND R.BOD_ID(+)        = P.BOD_ID'||CHR(10)                 /* BOD 2단계 개발 */
          || '   AND R.MEASURE(+)       = P.MEASURE'||CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '   AND R.LAST_UPDATED_BY  = C.USERID(+)'||CHR(10)
          || '   AND R.LAST_UPDATED_BY  = C.USER_ID(+)'||CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '   AND P.BOD_ID           = B.BOD_ID(+)'||CHR(10)
          || '   AND M.COLUMN_NAME      = P.MEASURE'||CHR(10)
          || '   AND S.SCM_SITE_ID      = P.FROM_SITE'||CHR(10)
          || '   AND M.PROGRAM_ID       = :B_PGM'||CHR(10)
          || '   AND M.SHEET_NAME       = :B_SHT'||CHR(10)
          || '   AND S.DIVISION_ID      = :B_DIV'||CHR(10)
          || '   AND S.OPERATION_GROUP  = :B_OPGRP'||CHR(10)
          || '   AND S.SITE_TYPE        = ''PLANT'''||CHR(10)
          || '   AND S.VALID_YN         = ''Y'''||CHR(10)
          || ' GROUP BY P.DIVISION_ID, P.ITEM_ID, P.NICK_NAME, P.FROM_SITE, P.TO_SITE, P.TR_MODE, P.INCOTERMS'||CHR(10)
          /* 2026.09.30 AJS 수정 (START) */
--          || '        , P.LT_DAY, P.MEASURE, P.PROJECT_CODE, P.FCST_TYPE, P.SEQ, C.USERID, C.USERNAME'||CHR(10)
          || '        , P.LT_DAY, P.MEASURE, P.PROJECT_CODE, P.FCST_TYPE, P.SEQ, C.USER_ID, C.USER_NM'||CHR(10)
          /* 2026.09.30 AJS 수정 (END) */
          || '        , M.COLUMN_LABEL_NAME, S.SHIP_FROZEN, M.ATTRIBUTE3'||CHR(10)
          || '        , P.BOD_ID, B.TO_YYYYMMDD'||CHR(10)                    /* BOD 2단계 개발 */
          || ' ORDER BY FN_ASIS_SORT_KEY(P.DIVISION_ID) NULLS FIRST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.ITEM_ID) NULLS FIRST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.FROM_SITE) NULLS FIRST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.TO_SITE) DESC NULLS LAST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.TR_MODE) NULLS FIRST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.PROJECT_CODE) NULLS FIRST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.FCST_TYPE) NULLS FIRST'||CHR(10)
          || '        , FN_ASIS_SORT_KEY(P.BOD_ID) NULLS FIRST'||CHR(10)
          || '        , P.SEQ'||CHR(10));

        /* DEBUG QRY 출력 */
        IF DEBUG_MODE = 'T' THEN
            FOR I IN 0 .. TRUNC((DBMS_LOB.GETLENGTH(V_SQL) - 1) / 3000) LOOP
                DBMS_OUTPUT.PUT_LINE(DBMS_LOB.SUBSTR(V_SQL, 3000, I * 3000 + 1));
            END LOOP;
        END IF;

        OPEN O_RC1 FOR V_SQL
          USING V_PLAN_START_YYYYMMDD, V_APP_TYPE, V_PLAN_START_YYYYMMDD
              , P_TO_YYYYMMDD
              , V_PLAN_START_YYYYMMDD, V_APP_TYPE, V_PLAN_START_YYYYMMDD
              , P_PROGRAM_ID, P_SHEET_NAME, P_DIVISION_ID, P_OPERATION_GROUP;

        DBMS_LOB.FREETEMPORARY(V_PIVOT);
        DBMS_LOB.FREETEMPORARY(V_SQL);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR SELECT NULL AS DIVISION_ID FROM DUAL WHERE 1 = 0;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0045_GET_SHIPMENT_REQUEST;

    /*******************************************************************************
     * P_SSP0045_SAVE_SHIPMENT_REQUEST
     *   AS-IS SSP0045_SAVE_SHIPMENT_REQUEST
     *   Shipment Request 입력
     *
     * ★AS-IS 는 삭제 기능이 없어 Active Flag 를 'I' 또는 'M' 으로 보고 입력 · 수정만 한다.
     * ★AS-IS CATCH 는 오류를 기록한 뒤 바깥 트랜잭션을 확정(COMMIT)하고 결과 코드로 알린다.
     *   TO-BE 는 저장 시작에 SAVEPOINT 를 두고 오류 때 그 지점까지만 되돌린다.
     *******************************************************************************/
    PROCEDURE P_SSP0045_SAVE_SHIPMENT_REQUEST
    (
        P_ACTIVE_FLAG           IN  CLOB
      , P_DIVISION_ID           IN  CLOB
      , P_FROM_SITE             IN  CLOB
      , P_ITEM_ID               IN  CLOB
      , P_INCOTERMS             IN  CLOB
      , P_TRANSPORT_MODE        IN  CLOB
      , P_TO_SITE               IN  CLOB
      , P_BOD_ID                IN  CLOB
      , P_MEASURE               IN  CLOB
      , P_YYYYMMDD              IN  CLOB
      , P_QTY                   IN  CLOB
      , P_PROJECT_CODE          IN  CLOB
      , P_FCST_TYPE             IN  CLOB
      , P_CREATED_BY            IN  VARCHAR2
      , DEBUG_MODE              IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS
        V_ERR_MSG               VARCHAR2(4000 CHAR);
        V_DELIMITER             VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;
        V_CNT_NO_BOD            PLS_INTEGER := 0;
        V_STR_NO_BOD            VARCHAR2(150 CHAR);
        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PKG_SSP0045.P_SSP0045_SAVE_SHIPMENT_REQUEST';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;
        /* 예외처리 변수 설정 */
        V_ERR_CODE              PLS_INTEGER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
        V_SQL_CODE              VARCHAR2(30 CHAR);
        E_NO_BOD                EXCEPTION;
    BEGIN

        SAVEPOINT SP_SSP0045_SAVE;

        DELETE FROM GT_SSP0045_SAVE_REQ;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ITEM_ID, V_DELIMITER));

        /*** 1. 신규건 MEASURE별 입력데이터 정리   *****/
        WHILE LENGTH(RTRIM(P_DIVISION_ID)) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            INSERT INTO GT_SSP0045_SAVE_REQ
            ( ACTIVE_FLAG, DIVISION_ID, FROM_SITE, ITEM_ID, INCOTERMS, TRANSPORT_MODE, TO_SITE
            , BOD_ID, MEASURE, YYYYMMDD, QTY, PROJECT_CODE, FCST_TYPE )
            SELECT SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,     V_DELIMITER, V_MST_LOOP_CNT)   AS ACTIVE_FLAG
                 , SCM_ARR_SPL_VAL(P_DIVISION_ID,     V_DELIMITER, V_MST_LOOP_CNT)   AS DIVISION_ID
                 , SCM_ARR_SPL_VAL(P_FROM_SITE,       V_DELIMITER, V_MST_LOOP_CNT)   AS FROM_SITE
                 , SCM_ARR_SPL_VAL(P_ITEM_ID,         V_DELIMITER, V_MST_LOOP_CNT)   AS ITEM_ID
                 , SCM_ARR_SPL_VAL(P_INCOTERMS,       V_DELIMITER, V_MST_LOOP_CNT)   AS INCOTERMS
                 , SCM_ARR_SPL_VAL(P_TRANSPORT_MODE,  V_DELIMITER, V_MST_LOOP_CNT)   AS TRANSPORT_MODE
                 , SCM_ARR_SPL_VAL(P_TO_SITE,         V_DELIMITER, V_MST_LOOP_CNT)   AS TO_SITE
                 , SCM_ARR_SPL_VAL(P_BOD_ID,          V_DELIMITER, V_MST_LOOP_CNT)   AS BOD_ID
                 , 'SHIP_REQ'                                                        AS MEASURE
                 , SCM_ARR_SPL_VAL(P_YYYYMMDD,        V_DELIMITER, V_MST_LOOP_CNT)   AS YYYYMMDD
                 , SCM_ARR_SPL_VAL(P_QTY,             V_DELIMITER, V_MST_LOOP_CNT)   AS QTY
                 , SCM_ARR_SPL_VAL(P_PROJECT_CODE,    V_DELIMITER, V_MST_LOOP_CNT)   AS PROJECT_CODE
                 , SCM_ARR_SPL_VAL(P_FCST_TYPE,       V_DELIMITER, V_MST_LOOP_CNT)   AS FCST_TYPE
              FROM DUAL;

        END LOOP;

        /* BOD 2단계 개발 : BOD ID 를 변경하지 못하도록 주석 처리 함 */

        /* BOD CHECK */
        SELECT COUNT(*)
          INTO V_CNT_NO_BOD
          FROM GT_SSP0045_SAVE_REQ
         WHERE ACTIVE_FLAG = 'M'
           AND TRIM(BOD_ID) IS NULL;

        IF V_CNT_NO_BOD > 0 THEN

            SELECT NO_BOD
              INTO V_STR_NO_BOD
              /* ★AS-IS 는 이어붙이는 값 하나라도 없으면 문구 전체가 빈 값이 된다. 그 동작을 맞춘다 */
              FROM ( SELECT CASE WHEN DIVISION_ID IS NULL OR FROM_SITE IS NULL OR TO_SITE IS NULL
                                       OR INCOTERMS IS NULL OR TRANSPORT_MODE IS NULL THEN NULL
                                  ELSE DIVISION_ID||'/'||FROM_SITE||'/'||TO_SITE||'/'||INCOTERMS||'/'||TRANSPORT_MODE
                             END                                                       AS NO_BOD
                       FROM GT_SSP0045_SAVE_REQ
                      WHERE ACTIVE_FLAG = 'M'
                        AND TRIM(BOD_ID) IS NULL )  IA
             WHERE ROWNUM = 1;

            V_ERR_CODE    := 99111;
            V_ERR_MESSAGE := 'Div, From Site, To Site 에 해당되는 BOD(Trans mode, Incoterms) 정보가 유효하지 않습니다. '||V_STR_NO_BOD;
            RAISE E_NO_BOD;                                    /* 예외발생 */

        END IF;

        D_EVENT_DATE := SYSDATE;

        /* 수정 */
        /* 삭제기능은 없으므로 Active Flag는 'I' 또는 'M'으로 가정하고 입력/수정만 진행 */
        UPDATE DM_PLN_SHIPMENT_REQ A
           SET ( A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE )
               = ( SELECT TO_NUMBER(B.QTY)
                        , P_CREATED_BY
                        , D_EVENT_DATE
                     FROM GT_SSP0045_SAVE_REQ B
                    WHERE A.DIVISION_ID     = B.DIVISION_ID
                      AND A.SCM_SITE_ID     = B.TO_SITE
                      AND A.ITEM_ID         = B.ITEM_ID
                      AND A.INCOTERMS       = B.INCOTERMS
                      AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                      AND A.MEASURE         = B.MEASURE
                      AND A.PLANT_SITE_ID   = B.FROM_SITE
                      AND A.YYYYMMDD        = B.YYYYMMDD
                      AND A.BOD_ID          = B.BOD_ID         /* BOD 2단계 개발 : 추가 */
                      AND A.PROJECT_CODE    = (CASE WHEN B.PROJECT_CODE IS NULL OR B.PROJECT_CODE = '-' THEN '-' ELSE B.PROJECT_CODE END)
                      AND A.FCST_TYPE       = (CASE WHEN B.FCST_TYPE IS NULL OR B.FCST_TYPE = '-' THEN '-' ELSE B.FCST_TYPE END) )
         WHERE EXISTS (SELECT 1
                         FROM GT_SSP0045_SAVE_REQ B
                        WHERE A.DIVISION_ID     = B.DIVISION_ID
                          AND A.SCM_SITE_ID     = B.TO_SITE
                          AND A.ITEM_ID         = B.ITEM_ID
                          AND A.INCOTERMS       = B.INCOTERMS
                          AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                          AND A.MEASURE         = B.MEASURE
                          AND A.PLANT_SITE_ID   = B.FROM_SITE
                          AND A.YYYYMMDD        = B.YYYYMMDD
                          AND A.BOD_ID          = B.BOD_ID     /* BOD 2단계 개발 : 추가 */
                          AND A.PROJECT_CODE    = (CASE WHEN B.PROJECT_CODE IS NULL OR B.PROJECT_CODE = '-' THEN '-' ELSE B.PROJECT_CODE END)
                          AND A.FCST_TYPE       = (CASE WHEN B.FCST_TYPE IS NULL OR B.FCST_TYPE = '-' THEN '-' ELSE B.FCST_TYPE END));

        INSERT INTO DM_PLN_SHIPMENT_REQ
        ( DIVISION_ID,    PROJECT_CODE,   SCM_SITE_ID,        ITEM_ID,            FCST_TYPE
        , INCOTERMS,      TRANSPORT_MODE, MEASURE,            PLANT_SITE_ID,      YYYYMMDD,           QTY
        , BOD_ID,         SITE_TYPE,      CREATED_BY,         CREATION_DATE,      LAST_UPDATED_BY,    LAST_UPDATE_DATE )
        SELECT B.DIVISION_ID
             , B.PROJECT_CODE                                 AS PROJECT_CODE
             , B.TO_SITE
             , B.ITEM_ID
             , B.FCST_TYPE                                    AS FCST_TYPE
             , B.INCOTERMS
             , B.TRANSPORT_MODE
             , B.MEASURE
             , B.FROM_SITE
             , B.YYYYMMDD
             , TO_NUMBER(B.QTY)
             , B.BOD_ID
             , 'PLANT'
             , P_CREATED_BY
             , D_EVENT_DATE
             , P_CREATED_BY
             , D_EVENT_DATE
          FROM GT_SSP0045_SAVE_REQ B
         WHERE NOT EXISTS (SELECT 1
                             FROM DM_PLN_SHIPMENT_REQ A
                            WHERE A.DIVISION_ID     = B.DIVISION_ID
                              AND A.SCM_SITE_ID     = B.TO_SITE
                              AND A.ITEM_ID         = B.ITEM_ID
                              AND A.INCOTERMS       = B.INCOTERMS
                              AND A.TRANSPORT_MODE  = B.TRANSPORT_MODE
                              AND A.MEASURE         = B.MEASURE
                              AND A.PLANT_SITE_ID   = B.FROM_SITE
                              AND A.YYYYMMDD        = B.YYYYMMDD
                              AND A.BOD_ID          = B.BOD_ID /* BOD 2단계 개발 : 추가 */
                              AND A.PROJECT_CODE    = (CASE WHEN B.PROJECT_CODE IS NULL OR B.PROJECT_CODE = '-' THEN '-' ELSE B.PROJECT_CODE END)
                              AND A.FCST_TYPE       = (CASE WHEN B.FCST_TYPE IS NULL OR B.FCST_TYPE = '-' THEN '-' ELSE B.FCST_TYPE END));

        /* History */
        INSERT INTO DM_PLN_SHIPMENT_REQ_H
        ( DIVISION_ID,    PROJECT_CODE,   SCM_SITE_ID,        ITEM_ID,            FCST_TYPE
        , INCOTERMS,      TRANSPORT_MODE, MEASURE,            PLANT_SITE_ID,      YYYYMMDD,           QTY
        , BOD_ID,         SITE_TYPE,      CREATED_BY,         CREATION_DATE,      LAST_UPDATED_BY,    LAST_UPDATE_DATE )
        SELECT B.DIVISION_ID
             , B.PROJECT_CODE                                 AS PROJECT_CODE
             , B.TO_SITE
             , B.ITEM_ID
             , B.FCST_TYPE                                    AS FCST_TYPE
             , B.INCOTERMS
             , B.TRANSPORT_MODE
             , B.MEASURE
             , B.FROM_SITE
             , B.YYYYMMDD
             , TO_NUMBER(B.QTY)
             , B.BOD_ID
             , 'PLANT'
             , P_CREATED_BY
             , D_EVENT_DATE
             , P_CREATED_BY
             , D_EVENT_DATE
          FROM GT_SSP0045_SAVE_REQ B;

        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE, NULL AS MSG FROM DUAL;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := NULL;
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN E_NO_BOD THEN
            ROLLBACK TO SP_SSP0045_SAVE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL, SYSDATE);
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR
                    SELECT 'N' AS RESULT_CODE, V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MESSAGE AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

        WHEN OTHERS THEN
            V_ERR_MSG  := SQLERRM;
            V_SQL_CODE := TO_CHAR(SQLCODE);
            ROLLBACK TO SP_SSP0045_SAVE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MSG, NULL, SYSDATE);
            IF O_RC1%ISOPEN = FALSE THEN
                OPEN O_RC1 FOR
                    SELECT 'F' AS RESULT_CODE, '['||V_SQL_CODE||']'||V_ERR_MSG AS ERR_MESSAGE FROM DUAL;
            END IF;
            OPEN O_RESULT_CURSOR FOR
                SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SSP0045_SAVE_SHIPMENT_REQUEST;

END PKG_SSP0045;
/
SHOW ERRORS PACKAGE BODY PKG_SSP0045
