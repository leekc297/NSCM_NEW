-- [E20261008-SLASHOBJ] PACKAGE BODY PKG_SSP0019 — 원복(사내 적용 전 원문)
CREATE OR REPLACE PACKAGE BODY PKG_SSP0019
IS
    /*
     * Program ID   : PKG_SSP0019
     * Description  : SSP0019 Shipment Change History 화면 - 출하계획 변경 이력 조회
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.26   ZIONEX         [PJ202650304] MSSQL -> Oracle 전환
     * 2026.10.07   AJS            P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY 조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     * 2026.10.08   AJS            P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY Model/Nickname 품목 목록 비교 MEMBER OF → IN (SELECT COLUMN_VALUE FROM TABLE(목록)) 2자리 (결과 동일 · 후보가 많을 때 행마다 목록 전체 비교 방지)
     *
     * [전환 공통 규칙]
     * - ★AS-IS 는 조회문 전체를 문자열로 이어 붙여 실행한다(조회조건에 따라 IN 절만 붙인다).
     *   조건마다 붙이고 빼는 것뿐이라 정적 조회문 한 문장으로 옮겼다.
     * - AS-IS WITH 절(CONFIRM_LIST)은 한 번만 참조해 인라인 뷰로 옮겼다.
     * - AS-IS 가 조회조건을 `FN_GET_IN_STR` 로 `'A','B'` 꼴로 만들어 IN 절에 넣던 것은
     *   STRING_SPLIT 로 나눠 견주도록 옮겼다.
     * - AS-IS TOP 1 은 ROWNUM 으로, ISNULL 은 NVL 로, 문자 이어붙이기는 || 로 옮겼다.
     * - ★빈 값과 값 없음을 함께 견주는 자리(`ISNULL(A,'') <> ISNULL(B,'')`)는 DECODE 로 옮겼다.
     *   Oracle 은 빈 문자가 값 없음이라 NVL 로는 AS-IS 와 같아지지 않는다.
     * - ★품목 팝업은 공용(SCM0002)을 그대로 쓴다. 이 패키지에 넣지 않는다(03 등록문 참고).
     */

    C_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SSP0019_GET_SHIPMENT_CHANGE_HISTORY';

    /* ==============================================================================================
       내부 : 결과 커서 (정상)
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
       SSP0019_GET_SHIPMENT_CHANGE_HISTORY
       ============================================================================================== */
    PROCEDURE P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY
    (
        P_DIVISION_ID       IN  CLOB
      , P_FROM_SITE         IN  CLOB
      , P_TO_SITE           IN  CLOB
      , P_INCOTERMS         IN  CLOB
      , P_FROM_YYYYMMDD     IN  VARCHAR2
      , P_TO_YYYYMMDD       IN  VARCHAR2
      , P_ITEM_ID           IN  CLOB
      , P_SONO              IN  CLOB
      , P_TRANS_MODE        IN  CLOB
      , P_CONFIRM_ID        IN  CLOB
      , P_LANGUAGE          IN  VARCHAR2
      , P_DEBUG_MODE        IN  VARCHAR2
      , O_RC1               OUT SYS_REFCURSOR
      , O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
        V_DIVISION_ID       VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_DIVISION_ID, 1, 32767));
        V_FROM_SITE         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_FROM_SITE, 1, 32767));
        V_TO_SITE           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_TO_SITE, 1, 32767));
        V_INCOTERMS         VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_INCOTERMS, 1, 32767));
        V_ITEM_ID           VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_ITEM_ID, 1, 32767));
        V_SONO              VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_SONO, 1, 32767));
        V_TRANS_MODE        VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_TRANS_MODE, 1, 32767));
        V_CONFIRM_ID        VARCHAR2(32767 CHAR) := TO_CHAR(SUBSTR(P_CONFIRM_ID, 1, 32767));
        V_FROM_YYYYMMDD     VARCHAR2(32 CHAR)    := TRIM(P_FROM_YYYYMMDD);
        V_TO_YYYYMMDD       VARCHAR2(32 CHAR)    := TRIM(P_TO_YYYYMMDD);
        V_LANGUAGE          VARCHAR2(32 CHAR)    := UPPER(TRIM(P_LANGUAGE));
        V_ITEM_TAB          T_STR_TAB            := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력 값(쉼표 구분)이 코드 또는 닉네임에 부분일치하는 품목을 먼저 고른다
           대상 품목 = 조회 기간 확정 이력 품목 + 입력 값 자체(기존 정확일치 결과가 빠지지 않게) */
        IF TRIM(V_ITEM_ID) IS NOT NULL AND UPPER(V_ITEM_ID) <> 'ALL' THEN
            SELECT DISTINCT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT XA.ITEM_ID
                      FROM SSP_ANL_SHIP_CONFIRM_H XA
                     WHERE XA.YYYYMMDD >= V_FROM_YYYYMMDD
                       AND XA.YYYYMMDD <= V_TO_YYYYMMDD
                    UNION
                    SELECT XB.COLUMN_VALUE
                      FROM TABLE(STRING_SPLIT(V_ITEM_ID, ',')) XB) IA
                 , TABLE(STRING_SPLIT(V_ITEM_ID, ',')) SA
             WHERE SA.COLUMN_VALUE IS NOT NULL
               AND IA.ITEM_ID IS NOT NULL
               AND (   UPPER(IA.ITEM_ID) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'
                    OR EXISTS (SELECT 1
                                 FROM SCM_MST_ITEM_SN XC
                                WHERE XC.ITEM_ID = IA.ITEM_ID
                                  AND UPPER(XC.NICK_NAME) LIKE '%' || UPPER(SA.COLUMN_VALUE) || '%'));
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.FROM_SITE
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID
                                             ELSE A.DIVISION_ID
                                        END, A.ITEM_ID)                 AS NICK_NAME
                 , A.TO_SITE
                 , NVL(CASE WHEN A.DIVISION_ID = '40'
                            THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE <> '-'
                                      THEN A.PROJECT_CODE
                                      ELSE I.PROJECT_CODE
                                 END
                            WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                            THEN I.PROJECT_CODE
                            ELSE J.END_CUSTOMER
                       END, '-')                                        AS END_CUSTOMER
                 , A.CONFIRM_ID
                 , A.H_SEQ                                              AS SEQ
                 , A.SHIPMENT_DATE
                 , A.QTY
                 , A.TRANSPORT_MODE
                 , A.INCOTERMS
                 , A.CUSTOMER_LT
                 , A.ERP_SO_NO
                 , A.TYPE
                 , A.CHANGE_TYPE
                 , A.CHANGE_REASON_CODE
                 , A.CHANGE_REASON_DETAIL
                 /* ★AS-IS 는 이어붙이기에 값 없음이 섞이면 결과 전체가 값 없음이다.
                      Oracle 은 값 없음을 빈 값으로 보므로 이름이 없을 때를 따로 가른다. */
                 , CASE WHEN A.REQUEST_USER IS NULL THEN ''
/* 2026.09.30 AJS 수정 (START) */
--                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN B.USERNAME
--                                  ELSE B.USERNAME_E
                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN B.USER_NM
                                  ELSE B.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END IS NULL THEN NULL
/* 2026.09.30 AJS 수정 (START) */
--                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN B.USERNAME
--                                  ELSE B.USERNAME_E
                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN B.USER_NM
                                  ELSE B.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END || '(' || A.REQUEST_USER || ')'
                   END                                                  AS REQUESTOR
                 , CASE WHEN V_LANGUAGE = 'KO' THEN C.DEPT_NAME_KO
                        ELSE C.DEPT_NAME_EN
                   END                                                  AS REQUESTOR_DEPT_NAME
                 , A.REQUEST_TIME                                       AS REQUEST_DATE
                 , CASE WHEN A.APPROVAL_USER IS NULL THEN ''
/* 2026.09.30 AJS 수정 (START) */
--                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN D.USERNAME
--                                  ELSE D.USERNAME_E
                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN D.USER_NM
                                  ELSE D.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END IS NULL THEN NULL
/* 2026.09.30 AJS 수정 (START) */
--                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN D.USERNAME
--                                  ELSE D.USERNAME_E
                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN D.USER_NM
                                  ELSE D.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END || '(' || A.APPROVAL_USER || ')'
                   END                                                  AS APPROVAL
                 , CASE WHEN V_LANGUAGE = 'KO' THEN F.DEPT_NAME_KO
                        ELSE F.DEPT_NAME_EN
                   END                                                  AS APPROVAL_DEPT_NAME
                 , A.APPROVAL_TIME                                      AS APPROVAL_DATE
                 , A.CHANGE_REQ_NO                                      AS REQUEST_NO
                 , A.REMARKS2                                           AS BUILDING
                 , A.REMARKS                                            AS REMARKS
                 , CASE WHEN A.REQUESTOR IS NULL THEN ''
/* 2026.09.30 AJS 수정 (START) */
--                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN E.USERNAME
--                                  ELSE E.USERNAME_E
                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM
                                  ELSE E.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END IS NULL THEN NULL
/* 2026.09.30 AJS 수정 (START) */
--                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN E.USERNAME
--                                  ELSE E.USERNAME_E
                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM
                                  ELSE E.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END || '(' || A.REQUESTOR || ')'
                   END                                                  AS SHIPMENT_REQUESTOR
                 , A.REMARKS3                                           AS CUSTOMER_REQUIRMENT
                 , (SELECT XA.SOLDTO_DESCRIPTION
                      FROM (SELECT NVL(XB.SOLDTO_DESCRIPTION, '-')      AS SOLDTO_DESCRIPTION
                              FROM SCM_MST_CUSTOMER      XB
                                 , SCM_MST_SITE_CUSTOMER XC
                             /* ★AS-IS 문자 비교는 뒤 공백을 무시한다(도착지 코드 뒤 공백 4행) */
                             WHERE XC.DIVISION_ID   = XB.DIVISION_ID
                               AND RTRIM(XC.SOLDTO_CODE) = RTRIM(XB.SOLDTO_CODE)
                               AND RTRIM(XC.SHIPTO_CODE) = RTRIM(XB.SHIPTO_CODE)
                               AND XC.REP_YN        = 'Y'
                               AND XB.DIVISION_ID   = A.DIVISION_ID
                               AND XC.SCM_SITE_ID   = A.TO_SITE) XA
                     WHERE ROWNUM = 1)                                  AS SOLD_TO_PARTY
                 , (SELECT XA.SHIPTO_DESCRIPTION
                      FROM (SELECT NVL(XB.SHIPTO_DESCRIPTION, '-')      AS SHIPTO_DESCRIPTION
                              FROM SCM_MST_CUSTOMER      XB
                                 , SCM_MST_SITE_CUSTOMER XC
                             /* ★AS-IS 문자 비교는 뒤 공백을 무시한다(도착지 코드 뒤 공백 4행) */
                             WHERE XC.DIVISION_ID   = XB.DIVISION_ID
                               AND RTRIM(XC.SOLDTO_CODE) = RTRIM(XB.SOLDTO_CODE)
                               AND RTRIM(XC.SHIPTO_CODE) = RTRIM(XB.SHIPTO_CODE)
                               AND XC.REP_YN        = 'Y'
                               AND XB.DIVISION_ID   = A.DIVISION_ID
                               AND XC.SCM_SITE_ID   = A.TO_SITE) XA
                     WHERE ROWNUM = 1)                                  AS SHIP_TO_PARTY
                 , CASE WHEN G.USER_ID IS NULL THEN ''
/* 2026.09.30 AJS 수정 (START) */
--                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN H.USERNAME
--                                  ELSE H.USERNAME_E
                        WHEN CASE WHEN V_LANGUAGE = 'KO' THEN H.USER_NM
                                  ELSE H.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END IS NULL THEN NULL
/* 2026.09.30 AJS 수정 (START) */
--                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN H.USERNAME
--                                  ELSE H.USERNAME_E
                        ELSE CASE WHEN V_LANGUAGE = 'KO' THEN H.USER_NM
                                  ELSE H.USER_ENG_NM
/* 2026.09.30 AJS 수정 (END) */
                             END || '(' || G.USER_ID || ')'
                   END                                                  AS MODEL_PIC
                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE
                        ELSE FN_GET_PROJECT_NAME(A.DIVISION_ID, A.PROJECT_CODE)
                   END                                                  AS PROJECT_NAME
                 , A.FCST_TYPE
                 , FN_GET_SSP_MKT_OWNER_NAME(I.OWNER, ',', V_LANGUAGE)  AS MTK_OWNER
                 , A.LAST_UPDATE_DATE
                 , CASE WHEN A.H_SEQ = 1 THEN NULL
                        ELSE TO_DATE(A.BEFORE_SHIPMENT_DATE, 'YYYYMMDD')
                   END                                                  AS BEFORE_SHIPMENT_DATE
                 , CASE WHEN A.H_SEQ = 1 THEN NULL
                        ELSE NVL(A.BEFORE_QTY, 0)
                   END                                                  AS BEFORE_QTY
                 , CASE WHEN A.H_SEQ = 1 THEN NULL
                        ELSE A.BEFORE_TRANSPORT_MODE
                   END                                                  AS BEFORE_TRANSPORT_MODE
                 , CASE WHEN A.H_SEQ = 1 THEN NULL
                        ELSE A.BEFORE_INCOTERMS
                   END                                                  AS BEFORE_INCOTERMS
                 /* ★빈 값과 값 없음을 함께 견주는 자리 — DECODE 는 값 없음끼리도 같게 본다 */
                 , CASE WHEN DECODE(A.BEFORE_SHIPMENT_DATE, A.NEW_YYYYMMDD, 0, 1) = 1 THEN 'Y'
                        ELSE 'N'
                   END                                                  AS SHIPMENT_DATE_CHANGE
                 , CASE WHEN A.BEFORE_SHIPMENT_DATE IS NULL THEN '-'
                        WHEN A.NEW_YYYYMMDD         IS NULL THEN '-'
                        ELSE CASE WHEN DECODE(A.BEFORE_SHIPMENT_DATE, A.NEW_YYYYMMDD, 0, 1) = 1
                                  THEN TO_CHAR(TO_DATE(A.NEW_YYYYMMDD, 'YYYYMMDD') - TO_DATE(A.BEFORE_SHIPMENT_DATE, 'YYYYMMDD'))
                                  ELSE '-'
                             END
                   END                                                  AS VARIABLE_DATE
                 , CASE WHEN NVL(A.BEFORE_QTY, 0) <> NVL(A.NEW_QTY, 0) THEN 'Y'
                        ELSE 'N'
                   END                                                  AS QTY_CHANGE
                 , ABS(NVL(A.BEFORE_QTY, 0) - NVL(A.NEW_QTY, 0))        AS VARIABLE_QTY
                 , CASE WHEN DECODE(A.BEFORE_TRANSPORT_MODE, A.NEW_TRANSPORT_MODE, 0, 1) = 1 THEN 'Y'
                        ELSE 'N'
                   END                                                  AS TRANS_MODE_CHANGE
                 , CASE WHEN A.BEFORE_SHIPMENT_DATE   = A.NEW_YYYYMMDD
                         AND A.BEFORE_QTY             = A.NEW_QTY
                         AND A.BEFORE_TRANSPORT_MODE  = A.NEW_TRANSPORT_MODE THEN 'Y'
                        ELSE 'N'
                   END                                                  AS REMARKS_CHANGE
                 , A.LAST_SEQ
              FROM (SELECT IA.DIVISION_ID
                         , IA.ORIGIN_FROM_DIVISION_ID
                         , IA.ORIGIN_TO_DIVISION_ID
                         , IA.FROM_SITE
                         , IA.ITEM_ID
                         , IA.TO_SITE
                         , IA.CONFIRM_ID
                         , ROW_NUMBER() OVER (PARTITION BY IA.H_CONFIRM_ID ORDER BY IA.HISTORY_SEQ) AS H_SEQ
                         , IA.YYYYMMDD
                         , TO_DATE(IA.H_YYYYMMDD, 'YYYYMMDD')           AS SHIPMENT_DATE
                         , NVL(IA.H_QTY, 0)                             AS QTY
                         , IA.H_TRANSPORT_MODE                          AS TRANSPORT_MODE
                         , IA.H_INCOTERMS                               AS INCOTERMS
                         , IA.CUSTOMER_LT
                         , IA.H_ERP_SO_NO                               AS ERP_SO_NO
                         , CASE WHEN IA.CHANGE_REQ_NO IS NULL THEN 'New'
                                ELSE CASE WHEN IA.NEW_YN = 'Y' THEN 'New'
                                          ELSE 'Change'
                                     END
                           END                                          AS TYPE
                         , CASE WHEN NVL(IA.REQ_CHANGE_TYPE, 'System Create') = 'A' THEN 'Adjustment'
                                WHEN NVL(IA.REQ_CHANGE_TYPE, 'System Create') IN ('N', 'C', 'P') THEN 'Change Request'
                                ELSE 'System Create'
                           END                                          AS CHANGE_TYPE
                         , IA.CHANGE_REASON_CODE
                         , IA.CHANGE_REASON_DETAIL
                         , IA.REQUEST_USER
                         , IA.REQUEST_DEPT
                         , IA.REQUEST_TIME
                         , IA.APPROVAL_USER
                         , IA.APPROVAL_DEPT
                         , IA.APPROVAL_TIME
                         , IA.CHANGE_REQ_NO
                         , IA.REMARKS2
                         , IA.REMARKS
                         , IA.REQUESTOR
                         , IA.REMARKS3
                         , IA.PROJECT_CODE
                         , IA.FCST_TYPE
                         , NVL(IA.APPROVAL_TIME, IA.CREATION_DATE)      AS LAST_UPDATE_DATE
                         , IA.DE_YYYYMMDD                               AS BEFORE_SHIPMENT_DATE
                         , IA.DE_QTY                                    AS BEFORE_QTY
                         , IA.DE_TRANSPORT_MODE                         AS BEFORE_TRANSPORT_MODE
                         , IA.DE_INCOTERMS                              AS BEFORE_INCOTERMS
                         , IA.NEW_YYYYMMDD
                         , IA.NEW_QTY
                         , IA.NEW_TRANSPORT_MODE
                         , CASE WHEN IA.HISTORY_SEQ = IA.MAX_SEQ THEN 'C'
                                ELSE 'H'
                           END                                          AS LAST_SEQ
                      FROM (SELECT A.DIVISION_ID
                                 , A.ORIGIN_FROM_DIVISION_ID
                                 , A.ORIGIN_TO_DIVISION_ID
                                 , A.FROM_SITE
                                 , A.ITEM_ID
                                 , A.TO_SITE
                                 , A.CONFIRM_ID
                                 , A.PROJECT_CODE
                                 , A.FCST_TYPE
                                 , A.REQUESTOR
                                 , A.CREATION_DATE
                                 , B.YYYYMMDD
                                 , B.MAX_SEQ
                                 , C.CONFIRM_ID                         AS H_CONFIRM_ID
                                 , C.HISTORY_SEQ
                                 , C.YYYYMMDD                           AS H_YYYYMMDD
                                 , C.QTY                                AS H_QTY
                                 , C.TRANSPORT_MODE                     AS H_TRANSPORT_MODE
                                 , C.INCOTERMS                          AS H_INCOTERMS
                                 , C.CUSTOMER_LT
                                 , C.ERP_SO_NO                          AS H_ERP_SO_NO
                                 , C.CHANGE_REQ_NO
                                 , C.REMARKS
                                 , C.REMARKS2
                                 , C.REMARKS3
                                 , D.CHANGE_TYPE                        AS REQ_CHANGE_TYPE
                                 , D.CHANGE_REASON_CODE
                                 , D.CHANGE_REASON_DETAIL
                                 , D.REQUEST_USER
                                 , D.REQUEST_DEPT
                                 , D.REQUEST_TIME
                                 , D.APPROVAL_USER
                                 , D.APPROVAL_DEPT
                                 , D.APPROVAL_TIME
                                 , E.NEW_YN
                                 , E.YYYYMMDD                           AS DE_YYYYMMDD
                                 , E.QTY                                AS DE_QTY
                                 , E.TRANSPORT_MODE                     AS DE_TRANSPORT_MODE
                                 , E.INCOTERMS                          AS DE_INCOTERMS
                                 , E.NEW_YYYYMMDD
                                 , E.NEW_QTY
                                 , E.NEW_TRANSPORT_MODE
                              FROM SSP_ANL_SHIP_CONFIRM               A
                                 , (SELECT IB.DIVISION_ID
                                         , IB.CONFIRM_ID
                                         , MAX(IB.SUBMAX_SEQ)           AS MAX_SEQ
                                         , IB.YYYYMMDD
                                      FROM (SELECT XA.DIVISION_ID
                                                 , XA.CONFIRM_ID
                                                 , MAX(XA.HISTORY_SEQ)  AS SUBMAX_SEQ
                                                 , XA.YYYYMMDD
                                              FROM SSP_ANL_SHIP_CONFIRM_H XA
                                             WHERE XA.YYYYMMDD >= V_FROM_YYYYMMDD
                                               AND XA.YYYYMMDD <= V_TO_YYYYMMDD
                                               AND (TRIM(V_DIVISION_ID) IS NULL
                                                OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                                OR  XA.DIVISION_ID IN (SELECT COLUMN_VALUE
                                                                         FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                                               AND (TRIM(V_FROM_SITE) IS NULL
                                                OR  UPPER(V_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                                OR  XA.FROM_SITE IN (SELECT COLUMN_VALUE
                                                                       FROM TABLE(STRING_SPLIT(V_FROM_SITE, ','))))
                                               AND (TRIM(V_TO_SITE) IS NULL
                                                OR  UPPER(V_TO_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                                OR  XA.TO_SITE IN (SELECT COLUMN_VALUE
                                                                     FROM TABLE(STRING_SPLIT(V_TO_SITE, ','))))
                                               AND (TRIM(V_INCOTERMS) IS NULL
                                                OR  UPPER(V_INCOTERMS) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                                OR  XA.INCOTERMS IN (SELECT COLUMN_VALUE
                                                                       FROM TABLE(STRING_SPLIT(V_INCOTERMS, ','))))
                                               AND (TRIM(V_ITEM_ID) IS NULL
                                                OR  UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                                              OR  XA.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                                   FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
/*                                              OR  XA.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                                OR  XA.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                                               AND (TRIM(V_TRANS_MODE) IS NULL
                                                OR  XA.TRANSPORT_MODE IN (SELECT COLUMN_VALUE
                                                                            FROM TABLE(STRING_SPLIT(V_TRANS_MODE, ','))))
                                               AND (TRIM(V_SONO) IS NULL
                                                OR  XA.ERP_SO_NO IN (SELECT COLUMN_VALUE
                                                                       FROM TABLE(STRING_SPLIT(V_SONO, ','))))
                                               /* [C20210722-000075] 조회 조건 추가 */
                                               AND (TRIM(V_CONFIRM_ID) IS NULL
                                                OR  XA.CONFIRM_ID IN (SELECT COLUMN_VALUE
                                                                        FROM TABLE(STRING_SPLIT(V_CONFIRM_ID, ','))))
                                             GROUP BY XA.DIVISION_ID
                                                    , XA.CONFIRM_ID
                                                    , XA.YYYYMMDD) IB
                                         /* ★AS-IS 는 회차 최대값을 상관 조회로 견준다.
                                              이력 원장(105만 행)에 확정번호 인덱스가 없어 묶음마다 전체를 훑는다.
                                              확정번호별 최대 회차를 한 번에 구해 견주도록 바꿨다(171초 -> 아래 7항). */
                                       , (SELECT XB.CONFIRM_ID
                                               , MAX(XB.HISTORY_SEQ)    AS ALL_MAX_SEQ
                                            FROM SSP_ANL_SHIP_CONFIRM_H XB
                                           GROUP BY XB.CONFIRM_ID) IC
                                     WHERE IC.CONFIRM_ID  = IB.CONFIRM_ID
                                       AND IB.SUBMAX_SEQ  = IC.ALL_MAX_SEQ
                                     GROUP BY IB.DIVISION_ID
                                            , IB.CONFIRM_ID
                                            , IB.YYYYMMDD) B
                                 , SSP_ANL_SHIP_CONFIRM_H              C
                                 , SSP_ANL_SHIP_CONFIRM_CHG_REQ        D
                                 , SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE     E
                             WHERE B.DIVISION_ID          = A.DIVISION_ID
                               AND B.CONFIRM_ID           = A.CONFIRM_ID
                               AND C.DIVISION_ID          = A.DIVISION_ID
                               AND C.CONFIRM_ID           = A.CONFIRM_ID
                               AND D.CHANGE_REQ_NO(+)     = C.CHANGE_REQ_NO
                               AND D.CHANGE_REQ_STATUS(+) = 'A'
                               AND D.VALID_YN(+)          = 'Y'
                               AND E.CHANGE_REQ_NO(+)     = C.CHANGE_REQ_NO
                               AND E.CONFIRM_ID(+)        = C.CONFIRM_ID
                               AND E.VALID_YN(+)          = 'Y'
                               AND A.CHANGE_TYPE          = 'C'
                               AND (TRIM(V_DIVISION_ID) IS NULL
                                OR  UPPER(V_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                                        FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                               AND (TRIM(V_FROM_SITE) IS NULL
                                OR  UPPER(V_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                OR  A.FROM_SITE IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(STRING_SPLIT(V_FROM_SITE, ','))))
                               AND (TRIM(V_TO_SITE) IS NULL
                                OR  UPPER(V_TO_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                OR  A.TO_SITE IN (SELECT COLUMN_VALUE
                                                    FROM TABLE(STRING_SPLIT(V_TO_SITE, ','))))
                               AND (TRIM(V_INCOTERMS) IS NULL
                                OR  UPPER(V_INCOTERMS) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                OR  A.INCOTERMS IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(STRING_SPLIT(V_INCOTERMS, ','))))
                               AND (TRIM(V_ITEM_ID) IS NULL
                                OR  UPPER(V_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
/* 2026.10.07 AJS Model/Nickname 검색 (START) */
--                              OR  A.ITEM_ID IN (SELECT COLUMN_VALUE
--                                                  FROM TABLE(STRING_SPLIT(V_ITEM_ID, ','))))
/*                              OR  A.ITEM_ID MEMBER OF V_ITEM_TAB) */
                                OR  A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   /* AJS 20261008 Model/Nickname */
/* 2026.10.07 AJS Model/Nickname 검색 (END) */
                               AND (TRIM(V_TRANS_MODE) IS NULL
                                OR  A.TRANSPORT_MODE IN (SELECT COLUMN_VALUE
                                                           FROM TABLE(STRING_SPLIT(V_TRANS_MODE, ','))))
                               AND (TRIM(V_SONO) IS NULL
                                OR  A.ERP_SO_NO IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(STRING_SPLIT(V_SONO, ','))))) IA) A
/* 2026.09.30 AJS 수정 (START) */
--                 , TB_FX_USER              B
                 , SCM_ADM_USER_M          B
/* 2026.09.30 AJS 수정 (END) */
                 , SCM_MST_SSO_DEPT_INFO   C
/* 2026.09.30 AJS 수정 (START) */
--                 , TB_FX_USER              D
--                 , TB_FX_USER              E
                 , SCM_ADM_USER_M          D
                 , SCM_ADM_USER_M          E
/* 2026.09.30 AJS 수정 (END) */
                 , SCM_MST_SSO_DEPT_INFO   F
                 , SSP_MST_MODEL_USER      G
/* 2026.09.30 AJS 수정 (START) */
--                 , TB_FX_USER              H
                 , SCM_ADM_USER_M          H
/* 2026.09.30 AJS 수정 (END) */
                 , SCM_MST_SITE_ITEM       I
                 , SCM_MST_SITE            J
/* 2026.09.30 AJS 수정 (START) */
--             WHERE B.USERID(+)        = A.REQUEST_USER
--               AND B.USEYN(+)         = 'Y'
             WHERE B.USER_ID(+)       = A.REQUEST_USER
               AND B.USE_YN(+)        = 'Y'
/* 2026.09.30 AJS 수정 (END) */
               AND C.DEPT_ID(+)       = A.REQUEST_DEPT
/* 2026.09.30 AJS 수정 (START) */
--               AND D.USERID(+)        = A.APPROVAL_USER
--               AND D.USEYN(+)         = 'Y'
--               AND E.USERID(+)        = A.REQUESTOR
--               AND E.USEYN(+)         = 'Y'
               AND D.USER_ID(+)       = A.APPROVAL_USER
               AND D.USE_YN(+)        = 'Y'
               AND E.USER_ID(+)       = A.REQUESTOR
               AND E.USE_YN(+)        = 'Y'
/* 2026.09.30 AJS 수정 (END) */
               AND F.DEPT_ID(+)       = A.APPROVAL_DEPT
               AND G.DIVISION_ID(+)   = A.DIVISION_ID
               AND G.FROM_SITE(+)     = A.FROM_SITE
               AND G.ITEM_ID(+)       = A.ITEM_ID
               AND G.VALID_YN(+)      = 'Y'
/* 2026.09.30 AJS 수정 (START) */
--               AND H.USERID(+)        = G.USER_ID
--               AND H.USEYN(+)         = 'Y'
               AND H.USER_ID(+)       = G.USER_ID
               AND H.USE_YN(+)        = 'Y'
/* 2026.09.30 AJS 수정 (END) */
               AND I.DIVISION_ID(+)   = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID
                                             ELSE A.DIVISION_ID
                                        END
               AND I.SCM_SITE_ID(+)   = A.TO_SITE
               AND I.ITEM_ID(+)       = A.ITEM_ID
               AND I.PROJECT_CODE(+)  = A.PROJECT_CODE
               AND J.DIVISION_ID(+)   = A.ORIGIN_TO_DIVISION_ID
               AND J.SCM_SITE_ID(+)   = A.TO_SITE
               /* AS-IS : 회차가 1이고 수량이 0인 행은 뺀다 */
               AND A.H_SEQ = CASE WHEN A.H_SEQ = 1 AND A.QTY = 0 THEN 0
                                  ELSE A.H_SEQ
                             END
             /* ★AS-IS 정렬 순서로 맞춘다(FN_ASIS_SORT_KEY).
                  하이픈을 빼고 견주며 구두점이 숫자·문자보다 앞이고 대소문자를 가리지 않는다.
                  이 화면은 출발사이트(밑줄·하이픈 섞임)와 최종고객(대소문자 섞임)에서 갈린다. */
             ORDER BY FN_ASIS_SORT_KEY(A.DIVISION_ID) NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.FROM_SITE) NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.ITEM_ID) NULLS FIRST
                    , FN_ASIS_SORT_KEY(NVL(CASE WHEN A.DIVISION_ID = '40'
                                                THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE <> '-'
                                                          THEN A.PROJECT_CODE
                                                          ELSE I.PROJECT_CODE
                                                     END
                                                WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                                                THEN I.PROJECT_CODE
                                                ELSE J.END_CUSTOMER
                                           END, '-')) NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.YYYYMMDD) NULLS FIRST
                    , FN_ASIS_SORT_KEY(A.CONFIRM_ID) NULLS FIRST
                    , A.H_SEQ DESC
                    , A.SHIPMENT_DATE;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG(C_PROGRAM_NAME, SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0019_GET_SHIPMENT_CHANGE_HISTORY;

END PKG_SSP0019;
/
SHOW ERRORS PACKAGE BODY PKG_SSP0019
