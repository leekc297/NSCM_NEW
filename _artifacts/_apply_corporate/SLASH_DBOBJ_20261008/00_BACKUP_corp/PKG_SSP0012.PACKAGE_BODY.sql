PACKAGE BODY PKG_SSP0012
IS
    /*
     * Program ID   : PKG_SSP0012
     * Description  : SSP0012 Shipment Plan Detail 화면 - 출하계획 확정 상세
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.25   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.06   AJS            [속도] P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL 확정번호별 마지막 이력을 조회 기간 확정번호만 한 번 읽어 계산 · 행마다 부르는 함수 5곳 스칼라 서브쿼리 캐시
     * 2026.10.07   AJS            P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL 조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     *
     * [전환 공통 규칙]
     * - AS-IS 는 문자열을 이어 붙여 만든 동적 SQL 한 문장을 임시 테이블에 담고 그 임시 테이블을 다시 읽는다.
     *   칸 구성이 고정이고 조건만 갈리므로 정적 SQL 한 문장으로 옮겼다(임시 테이블도 필요 없다).
     *   AS-IS FN_GET_IN_STR 은 IN 절 리터럴을 만드는 함수라 Oracle 로 옮기지 않고 토큰 분리 조건으로 바꿨다.
     * - 사용자 TB_FX_User -> SCM_ADM_USER_M (UserID -> USER_ID · UserName -> USER_NM · UserName_E -> USER_ENG_NM · UseYN -> USE_YN)
     * - 이름 + '(' + ID + ')' 결합은 MSSQL 에서 한쪽이 NULL 이면 전체가 NULL 이 되므로 NVL2 로 같은 결과를 만들었다.
     * - AS-IS TOP 1 은 ORDER BY 가 없어 어느 줄이 뽑힐지 정해지지 않는다. ROWNUM = 1 로 옮겼다.
     * - AS-IS ISNULL(NULLIF(x, ''), '-') 는 값이 없거나 빈 값이면 하이픈이다. 이관 공백을 함께 잡도록 TRIM 을 썼다.
     * - 공용 함수 FN_GET_SSP_MKT_OWNER_NAME 은 언어를 대소문자로 가리므로 넘길 때 대문자로 맞춘다.
     *   ★같은 함수가 담당자 아이디도 대소문자로 가려 원장에 대문자로 든 담당자(58명 · 4,319행)의 이름을
     *   되돌리지 못한다. 공용 함수를 고칠 사항이라 이 화면에서는 원문 그대로 두었다(담당자 전달).
     */

    /* ==============================================================================================
       내부 : 결과 커서 (성공)
       ============================================================================================== */
    PROCEDURE P_OPEN_SUCCESS
    (
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0'       AS CODE
                 , 'SUCCESS' AS MSG
              FROM DUAL;
    END P_OPEN_SUCCESS;

    /* ==============================================================================================
       내부 : 결과 커서 (오류)
       ============================================================================================== */
    PROCEDURE P_OPEN_ERROR
    (
        P_MESSAGE           IN  VARCHAR2,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    BEGIN
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1'      AS CODE
                 , P_MESSAGE AS MSG
              FROM DUAL;
    END P_OPEN_ERROR;

    /* ==============================================================================================
       내부 : 오류 이력 기록
       ============================================================================================== */
    PROCEDURE P_WRITE_ERROR_LOG
    (
        P_PROGRAM_NAME      IN  VARCHAR2,
        P_MESSAGE           IN  VARCHAR2
    )
    IS
        PRAGMA AUTONOMOUS_TRANSACTION;
    BEGIN
        INSERT INTO SCM_SYS_LOG_BATCH
        (
            PROGRAM_NAME
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
        (
            P_PROGRAM_NAME
          , 'ERROR'
          , NULL
          , SUBSTR(P_MESSAGE, 1, 1000)
          , NULL
          , SYSDATE
          , SYSDATE
          , P_PROGRAM_NAME
          , SYSDATE
          , P_PROGRAM_NAME
        );

        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
    END P_WRITE_ERROR_LOG;

    /* ==============================================================================================
       SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
       ============================================================================================== */
    PROCEDURE P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL
    (
        P_DIVISION_ID       IN  CLOB
      , P_FROM_SITE         IN  CLOB
      , P_ITEM_ID           IN  CLOB
      , P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_SOLD_TO_PARTY     IN  VARCHAR2
      , P_SHIP_TO_PARTY     IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , P_LANGUAGE          IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_DIVISION_ID       VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767));
        V_FROM_SITE         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_FROM_SITE, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
    BEGIN
        OPEN O_RC1 FOR
            SELECT IA.DIVISION_ID
                 , IA.PLAN_START_YYYYMMDD
                 , IA.PLAN_TYPE
                 , IA.SEQ
                 , IA.ITEM_ID
                 , IA.FROM_SITE
                 , IA.FROM_SITE_DESCRIPTION
                 , IA.TO_SITE_DESCRIPTION
                 , IA.TO_SITE
                 , IA.YYYYMMDD
                 , IA.BOD_ID
                 , IA.BIZ_TYPE
                 , IA.BIZ_TYPE_NAME
                 , IA.PROJECT_CODE
                 , IA.PROJECT_NAME
                 , IA.NICK_NAME
                 , IA.SOLDTO_DESCRIPTION
                 , IA.SHIPTO_DESCRIPTION
                 , IA.LT_DAY
                 , IA.ETD
                 , IA.ETA
                 , IA.INCOTERMS
                 , IA.TRANSPORT_MODE
                 , IA.PLAN_DATE
--                 , IA.EXPECTED_SHIPPING_DATE     AS "Expected_Shipping_Date"    /* 화면 칸 설정 이름을 그대로 쓴다 */   --  2026.10.08 AJS
                 , IA.EXPECTED_SHIPPING_DATE     AS "EXPECTED_SHIPPING_DATE"    /* 화면 칸 설정 이름을 그대로 쓴다 */   --  2026.10.08 AJS
                 , IA.CONFIRM_FLAG
                 , IA.PLAN_QTY
                 , IA.CONFIRM_QTY
                 , IA.FCST_TYPE
                 , IA.CONFIRM_ID
                 , IA.ERP_SO_NO
                 , IA.LAST_UPDATED_BY
                 , IA.LAST_UPDATE_DATE
                 , IA.CHANGE_REQ_NO
                 , IA.D_PORT_NAME
                 , IA.D_COUNTRY
                 , IA.D_PORT_CODE
                 , IA.A_PORT_NAME
                 , IA.A_COUNTRY
                 , IA.A_PORT_CODE
                 , IA.DAYS_MON
                 , IA.DAYS_TUE
                 , IA.DAYS_WED
                 , IA.DAYS_THU
                 , IA.DAYS_FRI
                 , IA.DAYS_SAT
                 , IA.DAYS_SUN
                 , IA.LT_DEPARTURE_INLAND
                 , IA.LT_WAIT_SHIPPING
                 , IA.LT_VOYAGE
                 , IA.LT_LAY_OFF_CLEARANCE
                 , IA.LT_ARRIVAL_INLAND
                 , IA.LT_SUM
                 , IA.ORIGIN_FROM_DIVISION_ID
                 , IA.MTK_OWNER
                 , IA.LT_TYPE
                 , IA.BUILDING
                 , IA.CUST_REQUIREMENT
                 , IA.REMARKS
              FROM (SELECT A.DIVISION_ID
                         , A.PLAN_START_YYYYMMDD
                         , A.PLAN_TYPE
                         , MAX(A.SEQ)                                       AS SEQ
                         , A.ITEM_ID
                         , A.FROM_SITE
                         , MAX(NVL(B.SITE_DESCRIPTION, '-'))                AS FROM_SITE_DESCRIPTION
                         , MAX(NVL(C.SITE_DESCRIPTION, '-'))                AS TO_SITE_DESCRIPTION
                         , A.TO_SITE
                         , A.YYYYMMDD
                         , A.BOD_ID
                         , A.BIZ_TYPE
                         , (SELECT X.SEGMENT2
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL X
                             WHERE X.VALID_YN    = 'Y'
                               AND X.LOOKUP_TYPE = 'BIZ_TYPE'
                               AND X.SEGMENT1    = A.BIZ_TYPE
                               AND ROWNUM        = 1)                       AS BIZ_TYPE_NAME
                         , A.PROJECT_CODE
                         , MAX(NVL(CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE
                                        ELSE D.PROJECT_NAME
                                   END, '-'))                               AS PROJECT_NAME
                         , (SELECT NVL(X.NICK_NAME, '-')
                              FROM SCM_MST_ITEM_SN X
                             WHERE X.ITEM_ID = A.ITEM_ID
                               AND ROWNUM    = 1)                           AS NICK_NAME
--                         , NVL(NULLIF(TRIM(FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION')), ''), '-') AS SOLDTO_DESCRIPTION    --  2026.10.06 AJS
                         , NVL(NULLIF(TRIM((SELECT FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') FROM DUAL)), ''), '-') AS SOLDTO_DESCRIPTION    --  2026.10.06 AJS
--                         , NVL(NULLIF(TRIM(FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION')), ''), '-') AS SHIPTO_DESCRIPTION    --  2026.10.06 AJS
                         , NVL(NULLIF(TRIM((SELECT FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') FROM DUAL)), ''), '-') AS SHIPTO_DESCRIPTION    --  2026.10.06 AJS
                         , E.LT_TOTAL                                       AS LT_DAY
                         , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')                                     AS ETD
--                         , TO_CHAR(TO_DATE(FN_GET_SSP_ETA_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA    --  2026.10.06 AJS
                         , TO_CHAR(TO_DATE((SELECT FN_GET_SSP_ETA_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) FROM DUAL), 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA    --  2026.10.06 AJS
                         /* 20201223 incoterms 변경 작업 modify KIMYONGHO */
                         , E.SSP_INCOTERMS                                  AS INCOTERMS
                         , E.TRANSPORT_MODE
                         , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')                                     AS PLAN_DATE
                         , CASE WHEN E.TRANSPORT_MODE = 'TRK' THEN '-'
--                                ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')    --  2026.10.06 AJS
                                ELSE TO_CHAR(TO_DATE((SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) FROM DUAL), 'YYYYMMDD'), 'YYYY-MM-DD')    --  2026.10.06 AJS
                           END                                              AS EXPECTED_SHIPPING_DATE
                         , CASE WHEN A.CHANGE_TYPE = 'P' THEN 'N' ELSE 'Y' END                                        AS CONFIRM_FLAG
                         , SUM(A.PLANNED_QTY)                               AS PLAN_QTY
                         , SUM(A.QTY)                                       AS CONFIRM_QTY
                         , A.FCST_TYPE
                         , CASE WHEN SUBSTR(A.CONFIRM_ID, 1, 1) = 'P' THEN '-' ELSE A.CONFIRM_ID END                  AS CONFIRM_ID
                         , F.ERP_SO_NO
                         , CASE WHEN H.USER_NM IS NULL THEN A.LAST_UPDATED_BY
                                ELSE NVL2(G.LAST_UPDATED_BY
                                        , (CASE WHEN UPPER(P_LANGUAGE) = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END) || '(' || G.LAST_UPDATED_BY || ')'
                                        , NULL)
                           END                                              AS LAST_UPDATED_BY
                         , CASE WHEN G.LAST_UPDATE_DATE IS NULL THEN A.LAST_UPDATE_DATE
                                ELSE G.LAST_UPDATE_DATE
                           END                                              AS LAST_UPDATE_DATE
                         , G.CHANGE_REQ_NO
                         , IB.D_PORT_NAME
                         , E.D_COUNTRY
                         , E.D_PORT_CODE
                         , IB.A_PORT_NAME
                         , E.A_COUNTRY
                         , E.A_PORT_CODE
                         , E.DAYS_MON
                         , E.DAYS_TUE
                         , E.DAYS_WED
                         , E.DAYS_THU
                         , E.DAYS_FRI
                         , E.DAYS_SAT
                         , E.DAYS_SUN
                         , E.LT_DEPARTURE_INLAND
                         , E.LT_WAIT_SHIPPING
                         , E.LT_VOYAGE
                         , E.LT_LAY_OFF_CLEARANCE
                         , E.LT_ARRIVAL_INLAND
                         , NVL(E.LT_DEPARTURE_INLAND, 0) + NVL(E.LT_WAIT_SHIPPING, 0) + NVL(E.LT_VOYAGE, 0)
                             + NVL(E.LT_LAY_OFF_CLEARANCE, 0) + NVL(E.LT_ARRIVAL_INLAND, 0)                           AS LT_SUM
                         , A.ORIGIN_FROM_DIVISION_ID
--                         , FN_GET_SSP_MKT_OWNER_NAME(IC.OWNER, ',', UPPER(P_LANGUAGE))    /* 공용 함수는 언어를 대소문자로 가린다 */                                       AS MTK_OWNER    --  2026.10.06 AJS
                         , (SELECT FN_GET_SSP_MKT_OWNER_NAME(IC.OWNER, ',', UPPER(P_LANGUAGE)) FROM DUAL)    /* 공용 함수는 언어를 대소문자로 가린다 */                                       AS MTK_OWNER    --  2026.10.06 AJS
                         , E.LT_TYPE
                         , A.REMARKS2                                       AS BUILDING
                         , A.REMARKS3                                       AS CUST_REQUIREMENT
                         , A.REMARKS
                      FROM SSP_ANL_SHIP_CONFIRM         A
                         , SCM_MST_SITE                 B
                         , SCM_MST_SITE                 C
                         , SCM_MST_PROJECT              D
                         , SCP_MST_BOD_N_V              E
                         , SSP_ANL_SHIP_CONFIRM         F
                         -- 2026.10.06 AJS 확정번호별 마지막 이력을 이력 테이블 한 번 읽기로 계산 (START)
--                         , (SELECT X.CONFIRM_ID                    /* 확정번호별 마지막 이력 */
--                                 , X.LAST_UPDATED_BY
--                                 , X.LAST_UPDATE_DATE
--                                 , X.CHANGE_REQ_NO
--                              FROM SSP_ANL_SHIP_CONFIRM_H X
--                             WHERE X.HISTORY_SEQ = (SELECT MAX(Y.HISTORY_SEQ)
--                                                      FROM SSP_ANL_SHIP_CONFIRM_H Y
--                                                     WHERE Y.CONFIRM_ID = X.CONFIRM_ID))         G
                         , (SELECT X.CONFIRM_ID                    /* 확정번호별 마지막 이력 — HISTORY_SEQ 는 PK(중복 없음)라 확정번호마다 마지막 한 줄 */
                                 , MAX(X.LAST_UPDATED_BY)  KEEP (DENSE_RANK LAST ORDER BY X.HISTORY_SEQ)  AS LAST_UPDATED_BY
                                 , MAX(X.LAST_UPDATE_DATE) KEEP (DENSE_RANK LAST ORDER BY X.HISTORY_SEQ)  AS LAST_UPDATE_DATE
                                 , MAX(X.CHANGE_REQ_NO)    KEEP (DENSE_RANK LAST ORDER BY X.HISTORY_SEQ)  AS CHANGE_REQ_NO
                              FROM SSP_ANL_SHIP_CONFIRM_H X
                             WHERE X.CONFIRM_ID IN (SELECT SA.CONFIRM_ID      /* 이 조회 기간의 확정번호만 — G 는 A 와 확정번호로만 이어진다 */
                                                      FROM SSP_ANL_SHIP_CONFIRM SA
                                                     WHERE SA.YYYYMMDD >= P_FROM_YYYYMMDD
                                                       AND SA.YYYYMMDD <= P_TO_YYYYMMDD
                                                       AND SA.QTY       > 0)
                             GROUP BY X.CONFIRM_ID)                                                   G
                         -- 2026.10.06 AJS 확정번호별 마지막 이력을 이력 테이블 한 번 읽기로 계산 (END)
                         , SCM_ADM_USER_M               H
                         , SCP_MST_DISTRIBUTION_ROUTE   IB
                         , SCM_MST_SITE_ITEM            IC
                     WHERE B.SCM_SITE_ID          = A.FROM_SITE
                       /* 20220420 SMS 가상디비젼관련 추가 — 81, 81_UC 에 같은 SCM_SITE_ID 가 있어 사업부도 견준다 */
                       AND B.DIVISION_ID          = A.DIVISION_ID
                       AND C.SCM_SITE_ID          = A.TO_SITE
                       AND C.DIVISION_ID          = A.DIVISION_ID
                       AND D.PROJECT_CODE(+)      = A.PROJECT_CODE
                       AND D.DIVISION_ID(+)       = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND E.DIVISION_ID          = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND E.BOD_ID               = A.BOD_ID
                       AND F.CONFIRM_ID(+)        = A.CONFIRM_ID
                       AND F.ERP_STATUS(+)       <> 'B'
                       AND G.CONFIRM_ID(+)        = A.CONFIRM_ID
                       AND H.USER_ID(+)           = G.LAST_UPDATED_BY
                       AND H.USE_YN(+)            = 'Y'
                       AND IB.ROUTE_ID            = E.ROUTE_ID
                       AND IC.DIVISION_ID(+)      = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND IC.SCM_SITE_ID(+)      = A.TO_SITE
                       AND IC.ITEM_ID(+)          = A.ITEM_ID
                       AND IC.PROJECT_CODE(+)     = A.PROJECT_CODE
                       AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
                       AND A.YYYYMMDD            <= P_TO_YYYYMMDD
                       AND A.QTY                  > 0                       /* OR A.PLANNED_QTY > 0 */
                       AND (TRIM(V_DIVISION_ID) IS NULL
                        OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                        OR  UPPER(A.DIVISION_ID) IN (SELECT UPPER(COLUMN_VALUE)
                                                       FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                       AND (TRIM(V_FROM_SITE) IS NULL
                        OR  UPPER(V_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                        OR  UPPER(A.FROM_SITE) IN (SELECT UPPER(COLUMN_VALUE)
                                                     FROM TABLE(STRING_SPLIT(V_FROM_SITE, ','))))
                       AND (TRIM(V_ITEM_ID) IS NULL
                        OR  UPPER(V_ITEM_ID) = 'ALL'  /* 조회조건 ALL 은 조건 없음 */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                      OR  UPPER(A.ITEM_ID) IN (SELECT UPPER(COLUMN_VALUE)
--                                                 FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
                        OR  EXISTS (SELECT 1
                                      FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SB
                                     WHERE SB.COLUMN_VALUE IS NOT NULL
                                       AND (   UPPER(A.ITEM_ID) LIKE '%' || UPPER(SB.COLUMN_VALUE) || '%'
                                            OR EXISTS (SELECT 1
                                                         FROM SCM_MST_ITEM_SN XG
                                                        WHERE XG.ITEM_ID = A.ITEM_ID
                                                          AND UPPER(XG.NICK_NAME) LIKE '%' || UPPER(SB.COLUMN_VALUE) || '%'))))
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                     GROUP BY A.DIVISION_ID
                            , A.PLAN_START_YYYYMMDD
                            , A.PLAN_TYPE
                            , A.ITEM_ID
                            , A.FROM_SITE
                            , A.TO_SITE
                            , A.YYYYMMDD
                            , A.BOD_ID
                            , A.PROJECT_CODE
                            , A.BIZ_TYPE
                            , E.LT_TOTAL
                            , E.SSP_INCOTERMS
                            , E.TRANSPORT_MODE
                            , E.LT_DEPARTURE_INLAND
                            , E.LT_WAIT_SHIPPING
                            , A.FCST_TYPE
                            , CASE WHEN SUBSTR(A.CONFIRM_ID, 1, 1) = 'P' THEN '-' ELSE A.CONFIRM_ID END
                            , F.ERP_SO_NO
                            , H.USER_NM
                            , H.USER_ENG_NM
                            , A.LAST_UPDATED_BY
                            , G.LAST_UPDATED_BY
                            , A.LAST_UPDATE_DATE
                            , G.LAST_UPDATE_DATE
                            , CASE WHEN A.CHANGE_TYPE = 'P' THEN 'N' ELSE 'Y' END
                            , G.CHANGE_REQ_NO
                            , IB.D_PORT_NAME
                            , E.D_COUNTRY
                            , E.D_PORT_CODE
                            , IB.A_PORT_NAME
                            , E.A_COUNTRY
                            , E.A_PORT_CODE
                            , E.DAYS_MON
                            , E.DAYS_TUE
                            , E.DAYS_WED
                            , E.DAYS_THU
                            , E.DAYS_FRI
                            , E.DAYS_SAT
                            , E.DAYS_SUN
                            , E.LT_VOYAGE
                            , E.LT_LAY_OFF_CLEARANCE
                            , E.LT_ARRIVAL_INLAND
                            , A.ORIGIN_FROM_DIVISION_ID
                            , A.ORIGIN_TO_DIVISION_ID
                            , IC.OWNER
                            , E.LT_TYPE
                            , A.REMARKS2
                            , A.REMARKS3
                            , A.REMARKS
                            , A.CONFIRM_ID) IA
             WHERE (TRIM(P_SOLD_TO_PARTY) IS NULL
                OR  UPPER(IA.SOLDTO_DESCRIPTION) LIKE '%' || UPPER(TRIM(P_SOLD_TO_PARTY)) || '%')
               AND (TRIM(P_SHIP_TO_PARTY) IS NULL
                OR  UPPER(IA.SHIPTO_DESCRIPTION) LIKE '%' || UPPER(TRIM(P_SHIP_TO_PARTY)) || '%')
             ORDER BY IA.DIVISION_ID
                    , IA.FROM_SITE
                    , IA.ITEM_ID
                    , IA.TO_SITE
                    , IA.YYYYMMDD
                    /* AS-IS 는 정렬 값이 같으면 앞 단계에서 줄을 세운 순서를 따른다 */
                    , IA.PROJECT_CODE
                    , IA.BOD_ID
                    , IA.CONFIRM_ID;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0012_GET_SHIPMENT_PLAN_CONFIRM_DETAIL;

END PKG_SSP0012;