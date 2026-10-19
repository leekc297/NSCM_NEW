PACKAGE BODY PKG_SSP0201
IS
    /*
     * Program ID   : PKG_SSP0201
     * Description  : SSP0201 Shipment Change Request 화면 - 출하 확정 변경 요청 조회 / 작성 / 완료 / 취소
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2026.09.21                  AS-IS 프로시저 11 건 패키지 전환
     *
     * [전환 공통 규칙]
     * - AS-IS 동적 SQL(문자열 조립 후 EXEC)은 칸 구성이 고정이고 조건만 갈리므로 정적 SQL + 선택 조건으로 옮겼다.
     *   AS-IS FN_GET_IN_STR 은 IN 절 리터럴을 만드는 함수라 Oracle 로 옮기지 않고 토큰 분리 조건으로 바꿨다.
     * - 사용자 TB_FX_User -> SCM_ADM_USER_M (UserID -> USER_ID · UserName -> USER_NM · UserName_E -> USER_ENG_NM)
     * - 이름 + '(' + ID + ')' 결합은 MSSQL 에서 이름이 NULL 이면 전체가 NULL 이 되므로 NVL2 로 같은 결과를 만들었다.
     * - 이관 공백(MSSQL NULL/'' 가 Oracle 공백 한 칸) 대상 칸은 TRIM 비교로 AS-IS 판정을 재현한다.
     * - MSSQL 정렬은 하이픈을 무시하고 오름차순 NULL 이 앞이므로 TRANSLATE + NULLS FIRST 로 맞췄다.
     * - 저장 계열의 '^' 구분 문자열 분리 규칙은 AS-IS SCM_ARR_SPL_CNT · SCM_ARR_SPL_VAL 과 같다.
     */

    C_DELIMITER         CONSTANT VARCHAR2(1 CHAR) := '^';

    TYPE T_TOKEN_TAB IS TABLE OF VARCHAR2(32767 CHAR) INDEX BY PLS_INTEGER;
    TYPE T_FOUND_TAB IS TABLE OF VARCHAR2(1 CHAR) INDEX BY PLS_INTEGER;

    /* ==============================================================================================
       내부 : 구분자 개수 + 1 (AS-IS SCM_ARR_SPL_CNT 와 같은 값 · CLOB 대응)
       ============================================================================================== */
    FUNCTION F_SPL_CNT
    (
        P_TEXT              IN  CLOB
    )
    RETURN PLS_INTEGER
    IS
        V_CNT               PLS_INTEGER := 1;
        V_POS               PLS_INTEGER;
    BEGIN
        IF P_TEXT IS NULL THEN
            RETURN V_CNT;
        END IF;

        V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, 1, 1);

        WHILE V_POS > 0 LOOP
            V_CNT := V_CNT + 1;
            V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, V_POS + 1, 1);
        END LOOP;

        RETURN V_CNT;
    END F_SPL_CNT;

    /* ==============================================================================================
       내부 : 앞뒤 공백을 뺀 마지막 글자 위치 (없으면 0)
       ============================================================================================== */
    FUNCTION F_LAST_NON_SPACE
    (
        P_TEXT              IN  CLOB
    )
    RETURN PLS_INTEGER
    IS
        V_POS               PLS_INTEGER;
    BEGIN
        V_POS := NVL(DBMS_LOB.GETLENGTH(P_TEXT), 0);

        WHILE V_POS > 0
          AND DBMS_LOB.SUBSTR(P_TEXT, 1, V_POS) = ' ' LOOP
            V_POS := V_POS - 1;
        END LOOP;

        RETURN V_POS;
    END F_LAST_NON_SPACE;

    /* ==============================================================================================
       내부 : 구분 문자열을 순서대로 한 번에 분리 (AS-IS SCM_ARR_SPL_VAL 과 같은 규칙 · CLOB 대응)
              O_FOUND = 'N' 자리는 AS-IS 가 NULL 을 되돌리는 자리
       ============================================================================================== */
    PROCEDURE P_SPL_ARR
    (
        P_TEXT              IN  CLOB,
        P_CNT               IN  PLS_INTEGER,
        O_TOKEN             OUT T_TOKEN_TAB,
        O_FOUND             OUT T_FOUND_TAB
    )
    IS
        V_END               PLS_INTEGER;
        V_OFF               PLS_INTEGER := 1;
        V_POS               PLS_INTEGER;
        V_WORD              VARCHAR2(32767 CHAR);
    BEGIN
        V_END := F_LAST_NON_SPACE(P_TEXT);

        WHILE V_OFF <= V_END
          AND DBMS_LOB.SUBSTR(P_TEXT, 1, V_OFF) = ' ' LOOP
            V_OFF := V_OFF + 1;
        END LOOP;

        FOR I IN 1 .. P_CNT LOOP
            IF P_TEXT IS NULL
            OR V_OFF > V_END + 1 THEN
                O_TOKEN(I) := NULL;
                O_FOUND(I) := 'N';
            ELSE
                V_POS := DBMS_LOB.INSTR(P_TEXT, C_DELIMITER, V_OFF, 1);

                IF V_POS = 0
                OR V_POS > V_END THEN
                    V_POS := V_END + 1;
                END IF;

                IF V_POS > V_OFF THEN
                    V_WORD := TRIM(DBMS_LOB.SUBSTR(P_TEXT, V_POS - V_OFF, V_OFF));
                ELSE
                    V_WORD := NULL;
                END IF;

                O_TOKEN(I) := V_WORD;
                O_FOUND(I) := 'Y';

                V_OFF := V_OFF + NVL(LENGTH(V_WORD), 0) + 1;

                WHILE V_OFF <= V_END
                  AND DBMS_LOB.SUBSTR(P_TEXT, 1, V_OFF) = ' ' LOOP
                    V_OFF := V_OFF + 1;
                END LOOP;
            END IF;
        END LOOP;
    END P_SPL_ARR;

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
       내부 : 오류 이력 기록 (AS-IS CATCH 의 scm_sys_log_batch INSERT)
              AS-IS 는 CATCH 안에서 바깥 트랜잭션을 확정하지만 Oracle 은 자치 트랜잭션으로 기록만 남긴다
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
       SSP0201_GET_SHIPMENT_CHANGE_REQUEST
       ============================================================================================== */
    PROCEDURE P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST
    (
        P_DIVISION_ID       IN  CLOB,
        P_FROM_SITE         IN  CLOB,
        P_ERP_SO_NO         IN  CLOB,
        P_ITEM_ID           IN  CLOB,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_STATUS            IN  CLOB,
        P_CHANGE_TYPE       IN  VARCHAR2,
        P_LANGUAGE          IN  VARCHAR2,
        P_DEBUG_MODE        IN  VARCHAR2,
        P_TO_SITE           IN  CLOB,
        P_CONFIRM_ID        IN  CLOB,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_GET_SHIPMENT_CHANGE_REQUEST
     * Description  : Shipment Change Request
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/05/25   KIMYONGHO      최초작성
     * 2021/11/11   SHINMYUNGSU    조회조건 CONFIRM_ID 추가
     * 2024/10/01   KHJ            NERP_SSP
     * 2025/12/11   chkim.68       E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     * 2026.10.06   AJS          조회 속도 개선(행마다 부르는 함수 스칼라 하위질의 캐시 · 시장 담당자 이름을 인라인 뷰 IB 로 한 번에 구함 · 출하실적 원장 TE 해시 조인)
     *                             - 동적 SQL(EXEC) -> 정적 SQL + 선택 조건 (칸 구성은 고정이고 조건만 갈린다)
     *                             - 선택 조건은 AS-IS FN_GET_IN_STR 과 같이 쉼표로 자르고 앞뒤 공백을 뺀 값으로 비교
     *                               (값이 없으면 조건 없음 · 줄바꿈은 쉼표로 바꾼 뒤 자른다)
     *                             - 이관 공백 대상 칸(SHIPMENT_STATUS · CHANGE_TYPE · ITEM_TYPE)은 TRIM 비교
     *                             - 조회 기간은 AS-IS 가 따옴표 없이 이어 붙여 숫자로 비교하지만
     *                               자리 수가 8 로 같아 문자 비교와 결과가 같다
     *                             - 이름 + ( + ID + ) 결합은 이름이 없으면 전체가 없는 값 (AS-IS 와 같음)
     * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
     */
        V_LANGUAGE          VARCHAR2(10 CHAR) := NVL(P_LANGUAGE, 'KO');
        V_DIVISION_YN       VARCHAR2(1 CHAR);
        V_FROM_SITE_YN      VARCHAR2(1 CHAR);
        V_ITEM_YN           VARCHAR2(1 CHAR);
        V_TO_SITE_YN        VARCHAR2(1 CHAR);
        V_ERP_SO_NO_YN      VARCHAR2(1 CHAR);
        V_CONFIRM_YN        VARCHAR2(1 CHAR);
        V_DIVISION_ID       VARCHAR2(32767 CHAR);
        V_FROM_SITE         VARCHAR2(32767 CHAR);
        V_ITEM_ID           VARCHAR2(32767 CHAR);
        V_TO_SITE           VARCHAR2(32767 CHAR);
        V_ERP_SO_NO         VARCHAR2(32767 CHAR);
        V_CONFIRM_ID        VARCHAR2(32767 CHAR);
    BEGIN
        /* AS-IS FN_GET_IN_STR : 줄바꿈을 쉼표로 바꾸고 빈 값이면 조건 없음 */
        V_DIVISION_ID := REPLACE(REPLACE(TO_CHAR(P_DIVISION_ID), CHR(13), ''), CHR(10), ',');
        V_FROM_SITE   := REPLACE(REPLACE(TO_CHAR(P_FROM_SITE), CHR(13), ''), CHR(10), ',');
        V_ITEM_ID     := REPLACE(REPLACE(TO_CHAR(P_ITEM_ID), CHR(13), ''), CHR(10), ',');
        V_TO_SITE     := REPLACE(REPLACE(TO_CHAR(P_TO_SITE), CHR(13), ''), CHR(10), ',');
        V_ERP_SO_NO   := REPLACE(REPLACE(TO_CHAR(P_ERP_SO_NO), CHR(13), ''), CHR(10), ',');
        V_CONFIRM_ID  := REPLACE(REPLACE(TO_CHAR(P_CONFIRM_ID), CHR(13), ''), CHR(10), ',');

        V_DIVISION_YN  := CASE WHEN V_DIVISION_ID IS NULL
             OR UPPER(TRIM(V_DIVISION_ID)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;
        V_FROM_SITE_YN := CASE WHEN V_FROM_SITE   IS NULL
             OR UPPER(TRIM(V_FROM_SITE)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;
        V_ITEM_YN      := CASE WHEN V_ITEM_ID     IS NULL
             OR UPPER(TRIM(V_ITEM_ID)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;
        V_TO_SITE_YN   := CASE WHEN V_TO_SITE     IS NULL
             OR UPPER(TRIM(V_TO_SITE)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;
        V_ERP_SO_NO_YN := CASE WHEN V_ERP_SO_NO   IS NULL
             OR UPPER(TRIM(V_ERP_SO_NO)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;
        V_CONFIRM_YN   := CASE WHEN V_CONFIRM_ID  IS NULL
             OR UPPER(TRIM(V_CONFIRM_ID)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;

        OPEN O_RC1 FOR
            SELECT SA.DIVISION_ID
                 , SA.ERP_SO_NO
                 , SA.SHIPMENT_STATUS
                 , SA.PROJECT_CODE
                 , SA.PROJECT_NAME
                 , SA.FCST_TYPE
                 , SA.ITEM_ID
                 , SA.NICK_NAME
                 , SA.SHIPMENT_DATE
                 , SA.BEFORE_QTY
                 , SA.SHIPMENT_CONFIRM_QTY
                 , SA.REMARKS
                 , SA.REMARKS2
                 , SA.REMARKS3
                 , SA.FROM_SITE
                 , SA.FROM_SITE_DESCRIPTION
                 , SA.TO_SITE
                 , SA.TO_SITE_DESCRIPTION
                 , SA.TO_SITE_SOLDTO_CODE
                 , SA.TO_SITE_SHIPTO_CODE
                 , SA.SOLDTO_DESCRIPTION
                 , SA.SHIPTO_DESCRIPTION
                 , SA.BOD_ID
                 , SA.INCOTERMS
                 , SA.TRANSPORT_MODE
                 , SA.LT_DAY
                 , SA.ETD
                 , SA.ETA
                 , SA.EXPECTED_SHIPPING_DATE
                 , SA.CONFIRM_ID
                 , SA.UPDATED_BY
                 , SA.UPDATED_DATE
                 , SA.ERP_STATUS
                 , SA.CHANGE_TYPE
                 , SA.NEW_ROUTE_ID
                 , SA.NEW_BOD_ID
                 , SA.NEW_INCOTERMS
                 , SA.NEW_D_COUNTRY
                 , SA.NEW_D_PORT_CODE
                 , SA.NEW_A_COUNTRY
                 , SA.NEW_A_PORT_CODE
                 , SA.NEW_CUSTOMER_LT
                 , SA.NEW_TO_COUNTRY
                 , SA.NEW_TO_CITY
                 , SA.NEW_ETA
                 , SA.NEW_ETD
                 , SA.NEW_LT_DAY
                 , SA.NEW_TRANSPORT_MODE
                 , SA.NEW_SHIPMENT_DATE
                 , SA.EDIT_REMARKS
                 , SA.EDIT_MAIN
                 , SA.CHECK_NEED_YN
                 , SA.END_CUSTOMER
                 , SA.ELECTRODE_YN
                 , SA.ELECTRODE_TYPE
                 , SA.ORIGIN_FROM_DIVISION_ID
                 , SA.ORIGIN_TO_DIVISION_ID
                 , SA.CHANGE_REQ_NO
                 , SA.MODEL_USER
                 , SA.MTK_OWNER
                 , SA.REQUESTOR
                 , SA.CHANGE_REASON_CODE
                 , SA.CHANGE_REASON_DETAIL
                 , SA.ATTRIBUTE10
                 , SA.REQUEST_DATE
--              FROM (SELECT A.DIVISION_ID   --  2026.10.06 AJS
              FROM (SELECT /*+ USE_HASH(TE) */ A.DIVISION_ID   --  2026.10.06 AJS
                         , A.ERP_SO_NO
                         , A.SHIPMENT_STATUS
                         , A.PROJECT_CODE
--                         , FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.PROJECT_CODE) AS PROJECT_NAME   --  2026.10.06 AJS
                         , (SELECT FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.PROJECT_CODE) FROM DUAL) AS PROJECT_NAME   --  2026.10.06 AJS
                         , A.FCST_TYPE
                         , A.ITEM_ID
--                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME   --  2026.10.06 AJS
                         , (SELECT FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) FROM DUAL) AS NICK_NAME   --  2026.10.06 AJS
                         , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                         , A.BEFORE_QTY
                         , ROUND(A.QTY) AS SHIPMENT_CONFIRM_QTY                       /* ★AS-IS SSP0201 은 정수로 바꾼다(SSP0200 은 소수점 셋째 자리) */
                         , A.REMARKS
                         , A.REMARKS2
                         , A.REMARKS3
                         , A.FROM_SITE
--                         , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION   --  2026.10.06 AJS
                         , NVL((SELECT FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE) FROM DUAL), '-') AS FROM_SITE_DESCRIPTION   --  2026.10.06 AJS
                         , A.TO_SITE
--                         , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-') AS TO_SITE_DESCRIPTION   --  2026.10.06 AJS
                         , NVL((SELECT FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE) FROM DUAL), '-') AS TO_SITE_DESCRIPTION   --  2026.10.06 AJS
                         , A.TO_SITE_SOLDTO_CODE
                         , A.TO_SITE_SHIPTO_CODE
--                         , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION   --  2026.10.06 AJS
                         , (SELECT FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') FROM DUAL) AS SOLDTO_DESCRIPTION   --  2026.10.06 AJS
--                         , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION   --  2026.10.06 AJS
                         , (SELECT FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') FROM DUAL) AS SHIPTO_DESCRIPTION   --  2026.10.06 AJS
                         , A.BOD_ID
                         , D.SSP_INCOTERMS AS INCOTERMS
                         , D.TRANSPORT_MODE
                         , D.LT_TOTAL AS LT_DAY
                         , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                         , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                         , CASE WHEN D.TRANSPORT_MODE = 'TRK' THEN '-'
--                                ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')   --  2026.10.06 AJS
                                ELSE TO_CHAR(TO_DATE((SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) FROM DUAL), 'YYYYMMDD'), 'YYYY-MM-DD')   --  2026.10.06 AJS
                           END AS EXPECTED_SHIPPING_DATE
                         , A.CONFIRM_ID
                         , CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM ELSE E.USER_ENG_NM END
                           || NVL2(CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM ELSE E.USER_ENG_NM END, '(' || A.LAST_UPDATED_BY || ')', NULL) AS UPDATED_BY
                         , CASE WHEN E.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE ELSE NULL END AS UPDATED_DATE
                         , CASE WHEN NVL(TE.ATTRIBUTE5, '-') = '-' THEN '-' ELSE 'C' END AS ERP_STATUS   /* ★SSP0201 은 출하실적 원장으로 만든다(SSP0200 은 원장 칸 그대로) */
                         , A.CHANGE_TYPE
                         , A.ROUTE_ID AS NEW_ROUTE_ID
                         , A.BOD_ID AS NEW_BOD_ID
                         , D.SSP_INCOTERMS AS NEW_INCOTERMS
                         , A.D_COUNTRY AS NEW_D_COUNTRY
                         , A.D_PORT_CODE AS NEW_D_PORT_CODE
                         , A.A_COUNTRY AS NEW_A_COUNTRY
                         , A.A_PORT_CODE AS NEW_A_PORT_CODE
                         , A.CUSTOMER_LT AS NEW_CUSTOMER_LT
                         , A.TO_COUNTRY AS NEW_TO_COUNTRY
                         , A.TO_CITY AS NEW_TO_CITY
                         , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                         , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                         , D.LT_TOTAL AS NEW_LT_DAY
                         , D.TRANSPORT_MODE AS NEW_TRANSPORT_MODE
                         , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_SHIPMENT_DATE
                         , 'N' AS EDIT_REMARKS
                         , 'N' AS EDIT_MAIN
                         , NVL(A.CHECK_NEED_YN, 'N') AS CHECK_NEED_YN
                         , NVL(CASE WHEN A.DIVISION_ID = '40' THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE <> '-' THEN A.PROJECT_CODE ELSE IA.PROJECT_CODE END
                                    WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40' THEN IA.PROJECT_CODE
                                    ELSE F.END_CUSTOMER
                               END, '-') AS END_CUSTOMER
                         , A.ELECTRODE_YN
                         , A.ELECTRODE_TYPE
                         , A.ORIGIN_FROM_DIVISION_ID
                         , A.ORIGIN_TO_DIVISION_ID
                         , XA.CHANGE_REQ_NO
                         , CASE WHEN V_LANGUAGE = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END
                           || NVL2(CASE WHEN V_LANGUAGE = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END, '(' || G.USER_ID || ')', NULL) AS MODEL_USER
--                         , FN_GET_SSP_MKT_OWNER_NAME(J.OWNER, ',', V_LANGUAGE) AS MTK_OWNER   --  2026.10.06 AJS
                         , TO_CLOB(CASE WHEN V_LANGUAGE = 'KO' THEN IB.OWNER_NAME_KO ELSE IB.OWNER_NAME_EN END) AS MTK_OWNER   --  2026.10.06 AJS
                         , CASE WHEN A.LAST_UPDATED_BY = 'ssp_batch' THEN 'System'
                                ELSE CASE WHEN V_LANGUAGE = 'KO' THEN I.USER_NM ELSE I.USER_ENG_NM END
                                     || NVL2(CASE WHEN V_LANGUAGE = 'KO' THEN I.USER_NM ELSE I.USER_ENG_NM END, '(' || A.LAST_UPDATED_BY || ')', NULL)
                           END AS REQUESTOR
                         , '-' AS CHANGE_REASON_CODE
                         , NULL AS CHANGE_REASON_DETAIL                             /* AS-IS 는 빈 문자 */
                         , A.ATTRIBUTE10
                         , A.LAST_UPDATE_DATE AS REQUEST_DATE
                      FROM SSP_ANL_SHIP_CONFIRM           A
                         , SCM_MST_SITE                   C
                         , SCP_MST_BOD_N_V                D
                         , SCM_ADM_USER_M                 E
                         , SCM_MST_SITE                   F
                         , (SELECT DIVISION_ID
                                 , PROJECT_CODE
                                 , SCM_SITE_ID
                                 , ITEM_ID
                              FROM (SELECT DIVISION_ID
                                         , PROJECT_CODE
                                         , SCM_SITE_ID
                                         , ITEM_ID
                                         , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) AS NUM
                                      FROM SCM_MST_SITE_ITEM)
                             WHERE NUM = 1)              IA
                         , (SELECT CONFIRM_ID
                                 , CHANGE_REQ_NO
                              FROM (SELECT CONFIRM_ID
                                         , CHANGE_REQ_NO
                                         , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) AS NUM
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                     WHERE VALID_YN = 'Y')
                             WHERE NUM = 1)              XA
                         , SSP_MST_MODEL_USER             G
                         , SCM_ADM_USER_M                 H
                         , SCM_ADM_USER_M                 I
                         , SCM_MST_SITE_ITEM              J
                         , SSP_ANL_SHIP_CONFIRM_CHG_REQ   K
                         , SCM_DNM_SCS_SHIP_RESULT        TE
-- 2026.10.06 AJS 시장 담당자 이름을 한 번에 구하는 인라인 뷰 (START)
                         , (SELECT XB.OWNER
                                 , LISTAGG(CASE WHEN XB.TOKEN_NO = 1 AND XB.TOKEN_CNT >= 3 THEN LTRIM(XB.NAME_KO) ELSE XB.NAME_KO END, ',') WITHIN GROUP (ORDER BY XB.TOKEN_NO) AS OWNER_NAME_KO
                                 , LISTAGG(CASE WHEN XB.TOKEN_NO = 1 AND XB.TOKEN_CNT >= 3 THEN LTRIM(XB.NAME_EN) ELSE XB.NAME_EN END, ',') WITHIN GROUP (ORDER BY XB.TOKEN_NO) AS OWNER_NAME_EN
                              FROM (SELECT XC.OWNER
                                         , XC.TOKEN_NO
                                         , XC.TOKEN_CNT
                                         , NVL2(M.USER_ID, M.USER_NAME || '(' || M.USER_ID || ')', '(' || XC.TOKEN || ')') AS NAME_KO
                                         , NVL2(M.USER_ID, M.USER_NAME_EN || '(' || M.USER_ID || ')', '(' || XC.TOKEN || ')') AS NAME_EN
                                      FROM (SELECT XD.OWNER
                                                 , XE.TOKEN_NO
                                                 , XD.TOKEN_CNT
                                                 , TRIM(SUBSTR(',' || XD.OWNER || ','
                                                             , INSTR(',' || XD.OWNER || ',', ',', 1, XE.TOKEN_NO) + 1
                                                             , INSTR(',' || XD.OWNER || ',', ',', 1, XE.TOKEN_NO + 1) - INSTR(',' || XD.OWNER || ',', ',', 1, XE.TOKEN_NO) - 1)) AS TOKEN
                                              FROM (SELECT DISTINCT OWNER
                                                         , LENGTH(OWNER) - NVL(LENGTH(REPLACE(OWNER, ',')), 0) + 1 AS TOKEN_CNT
                                                      FROM SCM_MST_SITE_ITEM
                                                     WHERE TRIM(OWNER) IS NOT NULL) XD
                                                 , (SELECT LEVEL AS TOKEN_NO
                                                      FROM DUAL
                                                   CONNECT BY LEVEL <= 101) XE
                                             WHERE XE.TOKEN_NO <= XD.TOKEN_CNT) XC
                                         , SCM_MST_SSO_USER_INFO M
                                     WHERE UPPER(M.USER_ID(+)) = UPPER(XC.TOKEN)) XB
                             GROUP BY XB.OWNER)          IB
-- 2026.10.06 AJS 시장 담당자 이름을 한 번에 구하는 인라인 뷰 (END)
                     WHERE TE.DIVISION_ID(+)     = A.DIVISION_ID
                       AND TE.SCM_SITE_ID(+)     = A.FROM_SITE
                       AND TE.PACK_MODEL_CODE(+) = A.ITEM_ID
                       AND TE.ATTRIBUTE5(+)      = A.CONFIRM_ID
                       AND C.DIVISION_ID         = A.DIVISION_ID
                       AND C.SCM_SITE_ID         = A.FROM_SITE
                       AND C.SITE_TYPE           = 'PLANT'
                       AND D.DIVISION_ID         = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND D.BOD_ID              = A.BOD_ID
                       AND E.USER_ID(+)          = A.LAST_UPDATED_BY
                       AND E.USE_YN(+)           = 'Y'
                       AND F.DIVISION_ID(+)      = A.ORIGIN_TO_DIVISION_ID
                       AND F.SCM_SITE_ID(+)      = A.TO_SITE
                       AND F.VALID_YN(+)         = 'Y'
                       AND IA.DIVISION_ID(+)     = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND IA.SCM_SITE_ID(+)     = A.TO_SITE
                       AND IA.ITEM_ID(+)         = A.ITEM_ID
                       AND XA.CONFIRM_ID(+)      = A.CONFIRM_ID
                       AND G.DIVISION_ID(+)      = A.ORIGIN_FROM_DIVISION_ID
                       AND G.FROM_SITE(+)        = A.FROM_SITE
                       AND G.ITEM_ID(+)          = A.ITEM_ID
                       AND G.VALID_YN(+)         = 'Y'
                       AND H.USER_ID(+)          = G.USER_ID
                       AND H.USE_YN(+)           = 'Y'
                       AND I.USER_ID(+)          = A.LAST_UPDATED_BY
                       AND I.USE_YN(+)           = 'Y'
                       AND J.DIVISION_ID(+)      = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND J.SCM_SITE_ID(+)      = A.TO_SITE
                       AND J.ITEM_ID(+)          = A.ITEM_ID
                       AND J.PROJECT_CODE(+)     = A.PROJECT_CODE
                       AND K.CHANGE_REQ_NO(+)    = XA.CHANGE_REQ_NO
                       AND IB.OWNER(+)           = J.OWNER    --  2026.10.06 AJS
                       AND A.YYYYMMDD           >= P_FROM_YYYYMMDD
                       AND A.YYYYMMDD           <= P_TO_YYYYMMDD
                       AND (V_DIVISION_YN = 'N'
                        OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                       AND (V_ITEM_YN = 'N'
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
                       AND (V_FROM_SITE_YN = 'N'
                        OR  UPPER(A.FROM_SITE) IN (SELECT UPPER(COLUMN_VALUE)
                                                     FROM TABLE(STRING_SPLIT(V_FROM_SITE, ','))))
                       AND (V_TO_SITE_YN = 'N'
                        OR  UPPER(A.TO_SITE) IN (SELECT UPPER(COLUMN_VALUE)
                                                   FROM TABLE(STRING_SPLIT(V_TO_SITE, ','))))
                       AND (V_ERP_SO_NO_YN = 'N'
                        OR  UPPER(A.ERP_SO_NO) IN (SELECT UPPER(COLUMN_VALUE)
                                                     FROM TABLE(STRING_SPLIT(V_ERP_SO_NO, ','))))
                       AND TRIM(A.SHIPMENT_STATUS) IS NOT NULL
                       AND A.QTY                 > 0
                       AND TRIM(A.CHANGE_TYPE)   <> 'N'
                       AND A.CONFIRM_ID          LIKE 'R%'                       /* ★SSP0201(Packer) 은 R 로 시작한다(SSP0200 은 C) */
                       AND (V_CONFIRM_YN = 'N'
                        OR  UPPER(A.CONFIRM_ID) IN (SELECT UPPER(COLUMN_VALUE)
                                                      FROM TABLE(STRING_SPLIT(V_CONFIRM_ID, ','))))) SA
             ORDER BY SA.DIVISION_ID NULLS FIRST
                    , SA.SHIPMENT_STATUS NULLS FIRST
                    , SA.SHIPMENT_DATE NULLS FIRST
                    , UPPER(TRANSLATE(SA.ITEM_ID, '_-', '/')) NULLS FIRST
                    , SA.ITEM_ID NULLS FIRST
                    , SA.ERP_SO_NO DESC NULLS LAST
                    , UPPER(TRANSLATE(SA.FROM_SITE, '_-', '/')) NULLS FIRST
                    , SA.FROM_SITE NULLS FIRST
                    , UPPER(TRANSLATE(SA.TO_SITE, '_-', '/')) NULLS FIRST
                    , SA.TO_SITE NULLS FIRST
                    , UPPER(TRANSLATE(SA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                    , SA.PROJECT_CODE NULLS FIRST
                    , UPPER(TRANSLATE(SA.FCST_TYPE, '_-', '/')) NULLS FIRST
                    , SA.FCST_TYPE NULLS FIRST;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0201_GET_SHIPMENT_CHANGE_REQUEST', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST;

    /* ==============================================================================================
       SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N
       ============================================================================================== */
    PROCEDURE P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N
    (
        P_DIVISION_ID       IN  CLOB,
        P_FROM_SITE         IN  CLOB,
        P_ERP_SO_NO         IN  CLOB,
        P_ITEM_ID           IN  CLOB,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_STATUS            IN  CLOB,
        P_CHANGE_TYPE       IN  VARCHAR2,
        P_LANGUAGE          IN  VARCHAR2,
        P_DEBUG_MODE        IN  VARCHAR2,
        P_TO_SITE           IN  CLOB,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N
     * Description  : Shipment Change Request
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/05/25   KIMYONGHO      최초작성
     * 2025/12/11   chkim.68       E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - 동적 SQL(EXEC) -> 정적 SQL + 선택 조건
     *                             - AS-IS 에서 모델 · 출발지 조건은 주석이라 사업부 조건만 살아 있다
     *                             - 요청자 이름은 REQUESTOR 칸 기준 (변경 요청 조회는 최종변경자 기준)
     */
        V_LANGUAGE          VARCHAR2(10 CHAR) := NVL(P_LANGUAGE, 'KO');
        V_DIVISION_YN       VARCHAR2(1 CHAR);
        V_DIVISION_ID       VARCHAR2(32767 CHAR);
    BEGIN
        V_DIVISION_ID := REPLACE(REPLACE(TO_CHAR(P_DIVISION_ID), CHR(13), ''), CHR(10), ',');
        V_DIVISION_YN := CASE WHEN V_DIVISION_ID IS NULL
             OR UPPER(TRIM(V_DIVISION_ID)) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
             THEN 'N' ELSE 'Y' END;

        OPEN O_RC1 FOR
            SELECT SA.DIVISION_ID
                 , SA.ERP_SO_NO
                 , SA.SHIPMENT_STATUS
                 , SA.PROJECT_CODE
                 , SA.PROJECT_NAME
                 , SA.FCST_TYPE
                 , SA.ITEM_ID
                 , SA.NICK_NAME
                 , SA.SHIPMENT_DATE
                 , SA.BEFORE_QTY
                 , SA.SHIPMENT_CONFIRM_QTY
                 , SA.REMARKS
                 , SA.REMARKS2
                 , SA.REMARKS3
                 , SA.FROM_SITE
                 , SA.FROM_SITE_DESCRIPTION
                 , SA.TO_SITE
                 , SA.TO_SITE_DESCRIPTION
                 , SA.TO_SITE_SOLDTO_CODE
                 , SA.TO_SITE_SHIPTO_CODE
                 , SA.SOLDTO_DESCRIPTION
                 , SA.SHIPTO_DESCRIPTION
                 , SA.BOD_ID
                 , SA.INCOTERMS
                 , SA.TRANSPORT_MODE
                 , SA.LT_DAY
                 , SA.ETD
                 , SA.ETA
                 , SA.EXPECTED_SHIPPING_DATE
                 , SA.CONFIRM_ID
                 , SA.UPDATED_BY
                 , SA.UPDATED_DATE
                 , SA.ERP_STATUS
                 , SA.CHANGE_TYPE
                 , SA.NEW_ROUTE_ID
                 , SA.NEW_BOD_ID
                 , SA.NEW_INCOTERMS
                 , SA.NEW_D_COUNTRY
                 , SA.NEW_D_PORT_CODE
                 , SA.NEW_A_COUNTRY
                 , SA.NEW_A_PORT_CODE
                 , SA.NEW_CUSTOMER_LT
                 , SA.NEW_TO_COUNTRY
                 , SA.NEW_TO_CITY
                 , SA.NEW_ETA
                 , SA.NEW_ETD
                 , SA.NEW_LT_DAY
                 , SA.NEW_TRANSPORT_MODE
                 , SA.NEW_SHIPMENT_DATE
                 , SA.EDIT_REMARKS
                 , SA.EDIT_MAIN
                 , SA.CHECK_NEED_YN
                 , SA.END_CUSTOMER
                 , SA.ELECTRODE_YN
                 , SA.ELECTRODE_TYPE
                 , SA.ORIGIN_FROM_DIVISION_ID
                 , SA.ORIGIN_TO_DIVISION_ID
                 , SA.CHANGE_REQ_NO
                 , SA.MODEL_USER
                 , SA.MTK_OWNER
                 , SA.REQUESTOR
                 , SA.CHANGE_REASON_CODE
                 , SA.CHANGE_REASON_DETAIL
                 , SA.ATTRIBUTE10
              FROM (SELECT A.DIVISION_ID
                         , A.ERP_SO_NO
                         , A.SHIPMENT_STATUS
                         , A.PROJECT_CODE
                         , FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.PROJECT_CODE) AS PROJECT_NAME
                         , A.FCST_TYPE
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS SHIPMENT_DATE
                         , A.BEFORE_QTY
                         , ROUND(A.QTY) AS SHIPMENT_CONFIRM_QTY                       /* ★AS-IS SSP0201 은 정수로 바꾼다(SSP0200 은 소수점 셋째 자리) */
                         , A.REMARKS
                         , A.REMARKS2
                         , A.REMARKS3
                         , A.FROM_SITE
                         , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                         , A.TO_SITE
                         , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-') AS TO_SITE_DESCRIPTION
                         , A.TO_SITE_SOLDTO_CODE
                         , A.TO_SITE_SHIPTO_CODE
                         , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                         , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                         , A.BOD_ID
                         , D.SSP_INCOTERMS AS INCOTERMS
                         , D.TRANSPORT_MODE
                         , D.LT_TOTAL AS LT_DAY
                         , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                         , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                         , CASE WHEN D.TRANSPORT_MODE = 'TRK' THEN '-'
                                ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')
                           END AS EXPECTED_SHIPPING_DATE
                         , A.CONFIRM_ID
                         , CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM ELSE E.USER_ENG_NM END
                           || NVL2(CASE WHEN V_LANGUAGE = 'KO' THEN E.USER_NM ELSE E.USER_ENG_NM END, '(' || A.LAST_UPDATED_BY || ')', NULL) AS UPDATED_BY
                         , CASE WHEN E.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE ELSE NULL END AS UPDATED_DATE
                         , A.ERP_STATUS
                         , A.CHANGE_TYPE
                         , A.ROUTE_ID AS NEW_ROUTE_ID
                         , A.BOD_ID AS NEW_BOD_ID
                         , D.SSP_INCOTERMS AS NEW_INCOTERMS
                         , A.D_COUNTRY AS NEW_D_COUNTRY
                         , A.D_PORT_CODE AS NEW_D_PORT_CODE
                         , A.A_COUNTRY AS NEW_A_COUNTRY
                         , A.A_PORT_CODE AS NEW_A_PORT_CODE
                         , A.CUSTOMER_LT AS NEW_CUSTOMER_LT
                         , A.TO_COUNTRY AS NEW_TO_COUNTRY
                         , A.TO_CITY AS NEW_TO_CITY
                         , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                         , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                         , D.LT_TOTAL AS NEW_LT_DAY
                         , D.TRANSPORT_MODE AS NEW_TRANSPORT_MODE
                         , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_SHIPMENT_DATE
                         , 'N' AS EDIT_REMARKS
                         , 'N' AS EDIT_MAIN
                         , NVL(A.CHECK_NEED_YN, 'N') AS CHECK_NEED_YN
                         , NVL(CASE WHEN A.DIVISION_ID = '40' THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE <> '-' THEN A.PROJECT_CODE ELSE IA.PROJECT_CODE END
                                    WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40' THEN IA.PROJECT_CODE
                                    ELSE F.END_CUSTOMER
                               END, '-') AS END_CUSTOMER
                         , A.ELECTRODE_YN
                         , A.ELECTRODE_TYPE
                         , A.ORIGIN_FROM_DIVISION_ID
                         , A.ORIGIN_TO_DIVISION_ID
                         , XA.CHANGE_REQ_NO
                         , CASE WHEN V_LANGUAGE = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END
                           || NVL2(CASE WHEN V_LANGUAGE = 'KO' THEN H.USER_NM ELSE H.USER_ENG_NM END, '(' || G.USER_ID || ')', NULL) AS MODEL_USER
                         , FN_GET_SSP_MKT_OWNER_NAME(J.OWNER, ',', V_LANGUAGE) AS MTK_OWNER
                         , CASE WHEN V_LANGUAGE = 'KO' THEN I.USER_NM ELSE I.USER_ENG_NM END
                           || NVL2(CASE WHEN V_LANGUAGE = 'KO' THEN I.USER_NM ELSE I.USER_ENG_NM END, '(' || A.REQUESTOR || ')', NULL) AS REQUESTOR
                         , '-' AS CHANGE_REASON_CODE
                         , NULL AS CHANGE_REASON_DETAIL                             /* AS-IS 는 빈 문자 */
                         , A.ATTRIBUTE10
                      FROM SSP_ANL_SHIP_CONFIRM           A
                         , SCM_MST_SITE                   C
                         , SCP_MST_BOD_N_V                D
                         , SCM_ADM_USER_M                 E
                         , SCM_MST_SITE                   F
                         , (SELECT DIVISION_ID
                                 , PROJECT_CODE
                                 , SCM_SITE_ID
                                 , ITEM_ID
                              FROM (SELECT DIVISION_ID
                                         , PROJECT_CODE
                                         , SCM_SITE_ID
                                         , ITEM_ID
                                         , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) AS NUM
                                      FROM SCM_MST_SITE_ITEM)
                             WHERE NUM = 1)              IA
                         , (SELECT CONFIRM_ID
                                 , CHANGE_REQ_NO
                              FROM (SELECT CONFIRM_ID
                                         , CHANGE_REQ_NO
                                         , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) AS NUM
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                     WHERE VALID_YN = 'Y')
                             WHERE NUM = 1)              XA
                         , SSP_MST_MODEL_USER             G
                         , SCM_ADM_USER_M                 H
                         , SCM_ADM_USER_M                 I
                         , SCM_MST_SITE_ITEM              J
                         , SSP_ANL_SHIP_CONFIRM_CHG_REQ   K
                     WHERE C.DIVISION_ID         = A.DIVISION_ID
                       AND C.SCM_SITE_ID         = A.FROM_SITE
                       AND C.SITE_TYPE           = 'PLANT'
                       AND D.DIVISION_ID         = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND D.BOD_ID              = A.BOD_ID
                       AND E.USER_ID(+)          = A.LAST_UPDATED_BY
                       AND E.USE_YN(+)           = 'Y'
                       AND F.DIVISION_ID(+)      = A.ORIGIN_TO_DIVISION_ID
                       AND F.SCM_SITE_ID(+)      = A.TO_SITE
                       AND F.VALID_YN(+)         = 'Y'
                       AND IA.DIVISION_ID(+)     = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND IA.SCM_SITE_ID(+)     = A.TO_SITE
                       AND IA.ITEM_ID(+)         = A.ITEM_ID
                       AND XA.CONFIRM_ID(+)      = A.CONFIRM_ID
                       AND G.DIVISION_ID(+)      = A.ORIGIN_FROM_DIVISION_ID
                       AND G.FROM_SITE(+)        = A.FROM_SITE
                       AND G.ITEM_ID(+)          = A.ITEM_ID
                       AND G.VALID_YN(+)         = 'Y'
                       AND H.USER_ID(+)          = G.USER_ID
                       AND H.USE_YN(+)           = 'Y'
                       AND I.USER_ID(+)          = A.REQUESTOR
                       AND I.USE_YN(+)           = 'Y'
                       AND J.DIVISION_ID(+)      = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND J.SCM_SITE_ID(+)      = A.TO_SITE
                       AND J.ITEM_ID(+)          = A.ITEM_ID
                       AND J.PROJECT_CODE(+)     = A.PROJECT_CODE
                       AND K.CHANGE_REQ_NO(+)    = XA.CHANGE_REQ_NO
                       AND A.YYYYMMDD           >= P_FROM_YYYYMMDD
                       AND A.YYYYMMDD           <= P_TO_YYYYMMDD
                       AND (V_DIVISION_YN = 'N'
                        OR  A.DIVISION_ID IN (SELECT COLUMN_VALUE
                                                FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ','))))
                       AND TRIM(A.SHIPMENT_STATUS) IS NOT NULL
                       AND A.QTY                 > 0
                       AND A.CHANGE_TYPE         = 'N'
                       AND A.SHIPMENT_STATUS     = 'C'
                       AND A.CONFIRM_ID          LIKE 'R%'                       /* ★SSP0201(Packer) 은 R 로 시작한다(SSP0200 은 C) */) SA
             ORDER BY SA.DIVISION_ID NULLS FIRST
                    , SA.SHIPMENT_STATUS NULLS FIRST
                    , SA.SHIPMENT_DATE NULLS FIRST
                    , UPPER(TRANSLATE(SA.ITEM_ID, '_-', '/')) NULLS FIRST
                    , SA.ITEM_ID NULLS FIRST
                    , SA.ERP_SO_NO DESC NULLS LAST
                    , UPPER(TRANSLATE(SA.FROM_SITE, '_-', '/')) NULLS FIRST
                    , SA.FROM_SITE NULLS FIRST
                    , UPPER(TRANSLATE(SA.TO_SITE, '_-', '/')) NULLS FIRST
                    , SA.TO_SITE NULLS FIRST
                    , UPPER(TRANSLATE(SA.PROJECT_CODE, '_-', '/')) NULLS FIRST
                    , SA.PROJECT_CODE NULLS FIRST
                    , UPPER(TRANSLATE(SA.FCST_TYPE, '_-', '/')) NULLS FIRST
                    , SA.FCST_TYPE NULLS FIRST;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0201_GET_SHIPMENT_CHANGE_REQUEST_N;

    /* ==============================================================================================
       SSP0201_GET_SHIPMENT_REQUEST_DRAFTING
       ============================================================================================== */
    PROCEDURE P_SSP0201_GET_SHIPMENT_REQUEST_DRAFTING
    (
        P_DIVISION_ID       IN  CLOB,
        P_FROM_SITE         IN  CLOB,
        P_TO_SITE           IN  CLOB,
        P_ERP_SO_NO         IN  CLOB,
        P_ITEM_ID           IN  CLOB,
        P_BOD_ID            IN  CLOB,
        P_INCOTERMS         IN  CLOB,
        P_TRANSPORT_MODE    IN  CLOB,
        P_PROJECT_CODE      IN  CLOB,
        P_FCST_TYPE         IN  CLOB,
        P_CONFIRM_ID        IN  CLOB,
        P_FROM_YYYYMMDD     IN  VARCHAR2,
        P_TO_YYYYMMDD       IN  VARCHAR2,
        P_CHANGE_REQUEST_NO IN  VARCHAR2,
        P_REQUEST_USER_ID   IN  VARCHAR2,
        P_REQUEST_STATUS    IN  VARCHAR2,
        P_LANGUAGE          IN  VARCHAR2,
        P_CHANGE_TYPE       IN  VARCHAR2,
        P_DEBUG_MODE        IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_GET_SHIPMENT_REQUEST_DRAFTING
     * Description  : Shipment Change Request 작성중
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/05/26  KIMYONGHO       최초작성
     * 2022/03/03  SMS             소형 외주 Packer Item 코드 이중화로 인한 Model PIC 검색 변경
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - 임시 테이블(#Tmp)은 결과 커서와 담당자 조회 두 곳에서만 읽으므로
     *                               같은 인라인 뷰를 두 번 두어 임시 테이블 없이 옮겼다
     *                             - 임시 테이블 INSERT 의 정렬을 결과 커서의 정렬로 옮겼다
     *                             - 담당자 조회 TOP 1 -> ROWNUM = 1 (AS-IS 도 정렬이 없어 임의 1 행)
     *                             - AS-IS 조회 기간 · 요청 번호 · 상태 조건은 주석이라 살아 있지 않다
     * 2026.10.08  AJS             AS-IS 원문 재대조 누락 3건 반영
     *                             - 확정번호 R 조건(CONFIRM_ID LIKE 'R%') 추가 (작성중 결과 · 담당자 조회)
     *                             - SHIPTO_CODE · NEW_SHIPTO_CODE 칸 추가 (TO_SITE_SHIPTO_CODE)
     *                             - 담당자 조회 : 출발 사이트 PACKER_ITEM_ID_SUFFIX 가 있으면 품목 앞 11자리로 비교
     */
        V_LANGUAGE          VARCHAR2(10 CHAR) := NVL(P_LANGUAGE, 'KO');
    BEGIN
        OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.ERP_SO_NO
                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE
                        ELSE FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.PROJECT_CODE)
                   END AS PROJECT_NAME
                 , A.PROJECT_CODE
                 , A.FCST_TYPE
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                 , A.TO_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-') AS TO_SITE_DESCRIPTION
                 , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                 , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                 , A.TO_SITE_SHIPTO_CODE AS SHIPTO_CODE                         --  2026.10.08 AJS
                 , B.SSP_INCOTERMS AS INCOTERMS                                     /* 2020/09/21 KIMYONGHO SSP INCOTERMS 변경 작업 */
                 , CASE WHEN A.NEW_YN = 'Y' THEN '-' ELSE B.TRANSPORT_MODE END AS TRANSPORT_MODE
                 , CASE WHEN A.NEW_YN = 'Y' THEN '-'
                        ELSE CASE WHEN A.YYYYMMDD IS NULL THEN NULL
                                  ELSE TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')
                             END
                   END AS SHIPMENT_DATE
                 , CASE WHEN A.NEW_YN = 'Y' THEN 0 ELSE A.QTY END AS SHIPMENT_CONFIRM_QTY
                 , A.BOD_ID
                 , CASE WHEN A.NEW_YN = 'Y' THEN 0 ELSE B.LT_TOTAL END AS LT_DAY
                 , CASE WHEN A.NEW_YN = 'Y' THEN '-' ELSE TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                 , CASE WHEN A.NEW_YN = 'Y' THEN '-' ELSE TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                 , A.ROUTE_ID
                 , A.NEW_ROUTE_ID
                 , A.NEW_BOD_ID
                 , A.NEW_CUSTOMER_LT AS NEW_LT_DAY
                 , A.NEW_D_COUNTRY
                 , A.NEW_D_PORT_CODE
                 , A.NEW_A_COUNTRY
                 , A.NEW_A_PORT_CODE
                 , A.NEW_TO_COUNTRY
                 , A.NEW_TO_CITY
                 , TO_CHAR(TO_DATE(A.NEW_ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                 , TO_CHAR(TO_DATE(A.NEW_ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                 , A.TO_SITE_SHIPTO_CODE AS NEW_SHIPTO_CODE                     --  2026.10.08 AJS
                 , A.NEW_INCOTERMS
                 , A.NEW_TRANSPORT_MODE
                 , CASE WHEN A.NEW_YYYYMMDD IS NULL THEN NULL
                        ELSE TO_CHAR(TO_DATE(A.NEW_YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')
                   END AS NEW_SHIPMENT_DATE
                 , A.NEW_QTY AS NEW_SHIPMENT_CONFIRM_QTY
                 , A.CONFIRM_ID
                 , A.CHANGE_REQ_NO
                 , A.NEW_YN
                 , C.CONFIRM_ID AS PLAN_CONFIRM_ID
                 , A.ELECTRODE_YN
                 , A.ELECTRODE_TYPE
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID
                 , CASE WHEN C.CONFIRM_ID IS NOT NULL THEN 'Y' ELSE 'N' END AS NEW_BASE_CONFIRM_YN
                 , A.REMARKS
                 , A.REMARKS2
                 , A.REMARKS3
                 , A.REQUESTOR
              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE  A
                 , SCP_MST_BOD_N_V                  B
                 , SSP_ANL_SHIP_CONFIRM             C
             WHERE B.DIVISION_ID     = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
               AND B.BOD_ID          = A.BOD_ID
               AND C.CONFIRM_ID      = A.CONFIRM_ID
               AND C.SHIPMENT_STATUS = 'D'
               AND C.CHANGE_REQ_NO   = A.CHANGE_REQ_NO
               AND A.LAST_UPDATED_BY = P_REQUEST_USER_ID
               AND A.VALID_YN        = 'Y'
               AND A.ATTRIBUTE1      = 'Y'
               AND C.CONFIRM_ID      LIKE 'R%'                                  --  2026.10.08 AJS
             ORDER BY CASE WHEN A.NEW_YYYYMMDD IS NULL THEN NULL
                           ELSE TO_CHAR(TO_DATE(A.NEW_YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD')
                      END NULLS FIRST;

        OPEN O_RC2 FOR
            SELECT SA.USER_ID
                 , SA.USER_NAME
                 , SA.USER_NAME_EN
                 , SA.DEPT_ID
                 , SA.DEPT_NAME_KO
                 , SA.DEPT_NAME_EN
              FROM (SELECT A.USER_ID
                         , B.USER_NAME
                         , B.USER_NAME_EN
                         , B.DEPT_ID
                         , C.DEPT_NAME_KO
                         , C.DEPT_NAME_EN
                      FROM SSP_MST_MODEL_USER      A
                         , SCM_MST_SSO_USER_INFO   B
                         , SCM_MST_SSO_DEPT_INFO   C
                         , SCM_MST_SITE            D                            --  2026.10.08 AJS
                         , (SELECT DISTINCT IA.DIVISION_ID
                                 , IA.FROM_SITE
                                 , IA.ITEM_ID
                              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE  IA
                                 , SCP_MST_BOD_N_V                  XA
                                 , SSP_ANL_SHIP_CONFIRM             SA
                             WHERE XA.DIVISION_ID     = CASE WHEN IA.DIVISION_ID = 'EE' THEN IA.ORIGIN_FROM_DIVISION_ID ELSE IA.DIVISION_ID END
                               AND XA.BOD_ID          = IA.BOD_ID
                               AND SA.CONFIRM_ID      = IA.CONFIRM_ID
                               AND SA.SHIPMENT_STATUS = 'D'
                               AND SA.CHANGE_REQ_NO   = IA.CHANGE_REQ_NO
                               AND IA.LAST_UPDATED_BY = P_REQUEST_USER_ID
                               AND IA.VALID_YN        = 'Y'
                               AND IA.ATTRIBUTE1      = 'Y'
                               AND SA.CONFIRM_ID      LIKE 'R%'                 --  2026.10.08 AJS
                           ) DE
                     WHERE B.USER_ID       = A.USER_ID
                       AND C.DEPT_ID(+)    = B.DEPT_ID
                       AND DE.DIVISION_ID  = A.DIVISION_ID
                       AND DE.FROM_SITE    = A.FROM_SITE
--                     AND DE.ITEM_ID      = A.ITEM_ID                          --  2026.10.08 AJS
                       AND A.VALID_YN      = 'Y'
                       /* 2026.10.08 AJS Packer 품목 코드 이중화 Model PIC 검색 (START) */
                       AND D.DIVISION_ID   = DE.DIVISION_ID
                       AND D.SCM_SITE_ID   = DE.FROM_SITE
                       AND CASE WHEN TRIM(D.PACKER_ITEM_ID_SUFFIX) IS NULL THEN A.ITEM_ID  ELSE SUBSTR(A.ITEM_ID, 1, 11)  END
                         = CASE WHEN TRIM(D.PACKER_ITEM_ID_SUFFIX) IS NULL THEN DE.ITEM_ID ELSE SUBSTR(DE.ITEM_ID, 1, 11) END
                       /* 2026.10.08 AJS Packer 품목 코드 이중화 Model PIC 검색 (END) */
                    ) SA
             WHERE ROWNUM = 1;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0201_GET_SHIPMENT_REQUEST_DRAFTING', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0201_GET_SHIPMENT_REQUEST_DRAFTING;

    /* ==============================================================================================
       SSP0201_GET_CHANGE_REQ_NO
       ============================================================================================== */
    PROCEDURE P_SSP0201_GET_CHANGE_REQ_NO
    (
        P_USER_ID           IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_GET_CHANGE_REQ_NO
     * Description  : Shipment Change Request
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/05/25   KIMYONGHO      최초작성
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - 채번 자리 맞춤 RIGHT(000000 + 순번, 6) -> SUBSTR(..., -6)
     *                               (순번이 6 자리를 넘으면 뒤 6 자리를 쓰는 AS-IS 동작과 같다)
     */
        V_SEQ               NUMBER;
    BEGIN
        SELECT SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL
          INTO V_SEQ
          FROM DUAL;

        OPEN O_RC1 FOR
            SELECT 'S' AS RESULT_CODE
                 , 'R' || TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(V_SEQ), -6) AS CHANGE_REQ_NO
              FROM DUAL;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0201_GET_CHANGE_REQ_NO', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0201_GET_CHANGE_REQ_NO;

    /* ==============================================================================================
       SSP0201_GET_SHIPMENT_STATUS
       ============================================================================================== */
    PROCEDURE P_SSP0201_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID       IN  CLOB,
        P_CONFIRM_ID        IN  CLOB,
        O_RC1               OUT SYS_REFCURSOR,
        O_RC2               OUT SYS_REFCURSOR,
        O_RC3               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_GET_SHIPMENT_STATUS
     * Description  : Shipment Change Request
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/05/21   KIMYONGHO      최초작성
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - 결과 3 벌(확정 아님 · 수량 0 · ERP 전송 완료)을 커서 3 개로 되돌린다
     *                             - 이관 공백 대상 칸(SHIPMENT_STATUS)은 TRIM 비교
     */
        V_DIVISION_ID       VARCHAR2(32767 CHAR) := TO_CHAR(P_DIVISION_ID);
        V_CONFIRM_ID        VARCHAR2(32767 CHAR) := TO_CHAR(P_CONFIRM_ID);
    BEGIN
        OPEN O_RC1 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_DIVISION_ID, '^')))
               AND CONFIRM_ID  IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_CONFIRM_ID, '^')))
               AND TRIM(SHIPMENT_STATUS) <> 'C';

        OPEN O_RC2 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_DIVISION_ID, '^')))
               AND CONFIRM_ID  IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_CONFIRM_ID, '^')))
               AND QTY = 0;

        OPEN O_RC3 FOR
            SELECT CONFIRM_ID
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_DIVISION_ID, '^')))
               AND CONFIRM_ID  IN (SELECT COLUMN_VALUE
                                     FROM TABLE(STRING_SPLIT(V_CONFIRM_ID, '^')))
               AND ERP_STATUS = 'C';

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0201_GET_SHIPMENT_STATUS', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0201_GET_SHIPMENT_STATUS;

    /* ==============================================================================================
       SSP0201_GET_ERP_SO_NO_CNT
       ============================================================================================== */
    PROCEDURE P_SSP0201_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID       IN  VARCHAR2,
        P_ERP_SO_NO         IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_GET_ERP_SO_NO_CNT
     * Description  : Shipment Change Request
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/05/25   KIMYONGHO      최초작성
     * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     */
    BEGIN
        OPEN O_RC1 FOR
            SELECT COUNT(*) AS CNT
              FROM SSP_ANL_SHIP_CONFIRM
             WHERE DIVISION_ID = P_DIVISION_ID
               AND ERP_SO_NO   = P_ERP_SO_NO
               AND QTY        <> 0;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            P_WRITE_ERROR_LOG('SSP0201_GET_ERP_SO_NO_CNT', SQLERRM);
            P_OPEN_ERROR(SUBSTR(SQLERRM, 1, 4000), O_RESULT_CURSOR);
    END P_SSP0201_GET_ERP_SO_NO_CNT;

    /* ==============================================================================================
       SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING
       ============================================================================================== */
    PROCEDURE P_SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING
    (
        P_ACTIVE_FLAG               IN  CLOB,
        P_CHANGE_TYPE               IN  VARCHAR2,
        P_DIVISION_ID               IN  CLOB,
        P_CONFIRM_ID                IN  CLOB,
        P_SHIPMENT_QTY              IN  CLOB,
        P_SHIPMENT_DATE             IN  CLOB,
        P_FROM_SITE                 IN  CLOB,
        P_NEW_BOD_ID                IN  CLOB,
        P_NEW_ROUTE_ID              IN  CLOB,
        P_NEW_ETD_DATE              IN  CLOB,
        P_NEW_ETA_DATE              IN  CLOB,
        P_NEW_INCOTERMS             IN  CLOB,
        P_NEW_TRANSPORT_MODE        IN  CLOB,
        P_NEW_D_CONTRY              IN  CLOB,
        P_NEW_D_PORT_CODE           IN  CLOB,
        P_NEW_A_COUNTRY             IN  CLOB,
        P_NEW_A_PORT_CODE           IN  CLOB,
        P_NEW_CUSTOMER_LT           IN  CLOB,
        P_NEW_TO_COUNTRY            IN  CLOB,
        P_NEW_TO_CITY               IN  CLOB,
        P_EDIT_MAIN                 IN  CLOB,
        P_EDIT_REMARK               IN  CLOB,
        P_USER_ID                   IN  VARCHAR2,
        P_USER_DEPT_ID              IN  VARCHAR2,
        P_ELECTRODE_YN              IN  CLOB,
        P_ELECTRODE_TYPE            IN  CLOB,
        P_ORIGIN_FROM_DIVISION_ID   IN  CLOB,
        P_ORIGION_TO_DIVISION_ID    IN  CLOB,
        P_REMARKS                   IN  CLOB,
        P_REMARKS2                  IN  CLOB,
        P_REMARKS3                  IN  CLOB,
        P_CHANGE_REQ_NO             IN  VARCHAR2,
        P_CHANGE_REASON_CODE        IN  CLOB,
        P_CHANGE_REASON_DETAIL      IN  CLOB,
        P_TITLE                     IN  CLOB,
        P_PROGRAM_ID                IN  VARCHAR2,
        P_SHIPTO_CODE               IN  CLOB,
        O_RC1                       OUT SYS_REFCURSOR,
        O_RESULT_CURSOR             OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING
     * Description  : Shipment Plan Change 작성중 저장
     * 호출         : SSP0201
     * 관련 Table   : SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
     * 관련 프로시저 : PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN - ERP 관련 Table)
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021-05-21  KIMYONGHO       최초작성
     * 2024/05/07  hsbang          테이블 SSP_ANL_SHIP_CONFIRM_CHG_REQ_de에 STATUS_DETAIL 입력(hsbang, 20240507)
     * 2026/05/11  강주용          E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - MERGE 는 온라인 SQL 에서 쓰지 않으므로 UPDATE 후 바뀐 행이 없으면 INSERT 로 나눴다
     *                             - 경로 조회 TOP 1 + ORDER BY PRIORITY -> 인라인 뷰 정렬 후 ROWNUM = 1
     *                             - 저장 시작에 SAVEPOINT 를 두어 중간 오류에서 앞 행 저장분을 되돌린다
     *                             - 되돌리기는 결과 커서를 열기 전에 수행한다
     *                             - AS-IS 는 오류 처리에서 바깥 트랜잭션을 확정(COMMIT WORK)하지만
     *                               되돌아가지 않는 저장이 남으므로 옮기지 않았다
     *                             - AS-IS substring(값, 0, CHARINDEX(구분자, 값)) 은 첫 구분자 앞 값이므로
     *                               SUBSTR(값, 1, INSTR(값, 구분자) - 1) 로 옮겼다
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING';
        V_MAX_LOOP_CNT      PLS_INTEGER;
        V_TOK_ACTIVE_FLAG   T_TOKEN_TAB;
        V_TOK_DIVISION_ID   T_TOKEN_TAB;
        V_TOK_CONFIRM_ID    T_TOKEN_TAB;
        V_TOK_SHIPMENT_QTY  T_TOKEN_TAB;
        V_TOK_SHIPMENT_DATE T_TOKEN_TAB;
        V_TOK_FROM_SITE     T_TOKEN_TAB;
        V_TOK_NEW_BOD_ID    T_TOKEN_TAB;
        V_TOK_TITLE         T_TOKEN_TAB;
        V_TOK_NEW_ETD       T_TOKEN_TAB;
        V_TOK_NEW_ETA       T_TOKEN_TAB;
        V_TOK_NEW_ROUTE_ID  T_TOKEN_TAB;
        V_TOK_NEW_INCOTERMS T_TOKEN_TAB;
        V_TOK_NEW_TRANS     T_TOKEN_TAB;
        V_TOK_NEW_D_CONTRY  T_TOKEN_TAB;
        V_TOK_NEW_D_PORT    T_TOKEN_TAB;
        V_TOK_NEW_A_COUNTRY T_TOKEN_TAB;
        V_TOK_NEW_A_PORT    T_TOKEN_TAB;
        V_TOK_NEW_LT        T_TOKEN_TAB;
        V_TOK_NEW_TO_COUNTRY T_TOKEN_TAB;
        V_TOK_NEW_TO_CITY   T_TOKEN_TAB;
        V_TOK_EDIT_MAIN     T_TOKEN_TAB;
        V_TOK_EDIT_REMARK   T_TOKEN_TAB;
        V_TOK_ELECTRODE_YN  T_TOKEN_TAB;
        V_TOK_ELECTRODE_TP  T_TOKEN_TAB;
        V_TOK_ORG_FROM_DIV  T_TOKEN_TAB;
        V_TOK_ORG_TO_DIV    T_TOKEN_TAB;
        V_TOK_REMARKS       T_TOKEN_TAB;
        V_TOK_REMARKS2      T_TOKEN_TAB;
        V_TOK_REMARKS3      T_TOKEN_TAB;
        V_TOK_REASON_CODE   T_TOKEN_TAB;
        V_TOK_REASON_DETAIL T_TOKEN_TAB;
        V_TOK_SHIPTO_CODE T_TOKEN_TAB;
        V_FOUND             T_FOUND_TAB;

        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_CONFIRM_ID        VARCHAR2(4000 CHAR);
        V_SHIPMENT_QTY      VARCHAR2(4000 CHAR);
        V_SHIPMENT_DATE     VARCHAR2(4000 CHAR);
        V_FROM_SITE         VARCHAR2(4000 CHAR);
        V_TO_SITE           VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID        VARCHAR2(4000 CHAR);
        V_TITLE             VARCHAR2(4000 CHAR);
        V_NEW_ETD_DATE      VARCHAR2(4000 CHAR);
        V_NEW_ETA_DATE      VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID      VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS     VARCHAR2(4000 CHAR);
        V_NEW_TRANS_MODE    VARCHAR2(4000 CHAR);
        V_EDIT_MAIN         VARCHAR2(4000 CHAR);
        V_REMARKS           VARCHAR2(4000 CHAR);
        V_REMARKS2          VARCHAR2(4000 CHAR);
        V_REMARKS3          VARCHAR2(4000 CHAR);
        V_REASON_CODE       VARCHAR2(4000 CHAR);
        V_REASON_DETAIL     VARCHAR2(4000 CHAR);
        V_SCR_SHIPTO_CODE   VARCHAR2(4000 CHAR);                                   /* ★화면에서 받은 도착지 코드 */
        V_USER_ID_TEMP      VARCHAR2(4000 CHAR);

        V_DIV_TEMP          VARCHAR2(4000 CHAR);
        V_BOD_TEMP          VARCHAR2(4000 CHAR);
        V_FROM_TEMP         VARCHAR2(4000 CHAR);
        V_TO_TEMP           VARCHAR2(4000 CHAR);
        V_INCOTERMS_TEMP    VARCHAR2(4000 CHAR);
        V_TRANS_TEMP        VARCHAR2(4000 CHAR);
        V_ROUTE_TEMP        VARCHAR2(4000 CHAR);
        V_D_CONTRY_TEMP     VARCHAR2(4000 CHAR);
        V_D_PORT_TEMP       VARCHAR2(4000 CHAR);
        V_A_COUNTRY_TEMP    VARCHAR2(4000 CHAR);
        V_A_PORT_TEMP       VARCHAR2(4000 CHAR);
        V_CUSTOMER_LT_TEMP  VARCHAR2(4000 CHAR);
        V_TO_COUNTRY_TEMP   VARCHAR2(4000 CHAR);
        V_TO_CITY_TEMP      VARCHAR2(4000 CHAR);

        V_SOLDTO_CODE       VARCHAR2(4000 CHAR);
        V_SHIPTO_CODE       VARCHAR2(4000 CHAR);
        V_MAX_REQ_NO        VARCHAR2(40 CHAR);
        V_CHG_REQ_CHK       PLS_INTEGER := 0;
        V_SEQ               NUMBER;
        V_CREATE_DATE       DATE := SYSDATE;
        V_EVENT_DATE        DATE;
        V_REASON_ID         VARCHAR2(30 CHAR);
        V_RESULT_CODE       VARCHAR2(1 CHAR) := 'S';
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN
        SAVEPOINT SP_SSP0201_SAVE_DRAFT;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', V_EVENT_DATE);

        SELECT COUNT(*)
          INTO V_CHG_REQ_CHK
          FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ
         WHERE CHANGE_REQ_NO = P_CHANGE_REQ_NO;

        IF V_CHG_REQ_CHK = 0 THEN
            SELECT SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL
              INTO V_SEQ
              FROM DUAL;

            V_MAX_REQ_NO := 'R' || TO_CHAR(V_CREATE_DATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(V_SEQ), -6);
        END IF;

        IF P_CHANGE_REQ_NO IS NOT NULL THEN
            V_MAX_REQ_NO := P_CHANGE_REQ_NO;
        END IF;

        V_MAX_LOOP_CNT := F_SPL_CNT(P_ACTIVE_FLAG);

        P_SPL_ARR(P_ACTIVE_FLAG,             V_MAX_LOOP_CNT, V_TOK_ACTIVE_FLAG,    V_FOUND);
        P_SPL_ARR(P_DIVISION_ID,             V_MAX_LOOP_CNT, V_TOK_DIVISION_ID,    V_FOUND);
        P_SPL_ARR(P_CONFIRM_ID,              V_MAX_LOOP_CNT, V_TOK_CONFIRM_ID,     V_FOUND);
        P_SPL_ARR(P_SHIPMENT_QTY,            V_MAX_LOOP_CNT, V_TOK_SHIPMENT_QTY,   V_FOUND);
        P_SPL_ARR(P_SHIPMENT_DATE,           V_MAX_LOOP_CNT, V_TOK_SHIPMENT_DATE,  V_FOUND);
        P_SPL_ARR(P_FROM_SITE,               V_MAX_LOOP_CNT, V_TOK_FROM_SITE,      V_FOUND);
        P_SPL_ARR(P_NEW_BOD_ID,              V_MAX_LOOP_CNT, V_TOK_NEW_BOD_ID,     V_FOUND);
        P_SPL_ARR(P_TITLE,                   V_MAX_LOOP_CNT, V_TOK_TITLE,          V_FOUND);
        P_SPL_ARR(P_NEW_ETD_DATE,            V_MAX_LOOP_CNT, V_TOK_NEW_ETD,        V_FOUND);
        P_SPL_ARR(P_NEW_ETA_DATE,            V_MAX_LOOP_CNT, V_TOK_NEW_ETA,        V_FOUND);
        P_SPL_ARR(P_NEW_ROUTE_ID,            V_MAX_LOOP_CNT, V_TOK_NEW_ROUTE_ID,   V_FOUND);
        P_SPL_ARR(P_NEW_INCOTERMS,           V_MAX_LOOP_CNT, V_TOK_NEW_INCOTERMS,  V_FOUND);
        P_SPL_ARR(P_NEW_TRANSPORT_MODE,      V_MAX_LOOP_CNT, V_TOK_NEW_TRANS,      V_FOUND);
        P_SPL_ARR(P_NEW_D_CONTRY,            V_MAX_LOOP_CNT, V_TOK_NEW_D_CONTRY,   V_FOUND);
        P_SPL_ARR(P_NEW_D_PORT_CODE,         V_MAX_LOOP_CNT, V_TOK_NEW_D_PORT,     V_FOUND);
        P_SPL_ARR(P_NEW_A_COUNTRY,           V_MAX_LOOP_CNT, V_TOK_NEW_A_COUNTRY,  V_FOUND);
        P_SPL_ARR(P_NEW_A_PORT_CODE,         V_MAX_LOOP_CNT, V_TOK_NEW_A_PORT,     V_FOUND);
        P_SPL_ARR(P_NEW_CUSTOMER_LT,         V_MAX_LOOP_CNT, V_TOK_NEW_LT,         V_FOUND);
        P_SPL_ARR(P_NEW_TO_COUNTRY,          V_MAX_LOOP_CNT, V_TOK_NEW_TO_COUNTRY, V_FOUND);
        P_SPL_ARR(P_NEW_TO_CITY,             V_MAX_LOOP_CNT, V_TOK_NEW_TO_CITY,    V_FOUND);
        P_SPL_ARR(P_EDIT_MAIN,               V_MAX_LOOP_CNT, V_TOK_EDIT_MAIN,      V_FOUND);
        P_SPL_ARR(P_EDIT_REMARK,             V_MAX_LOOP_CNT, V_TOK_EDIT_REMARK,    V_FOUND);
        P_SPL_ARR(P_ELECTRODE_YN,            V_MAX_LOOP_CNT, V_TOK_ELECTRODE_YN,   V_FOUND);
        P_SPL_ARR(P_ELECTRODE_TYPE,          V_MAX_LOOP_CNT, V_TOK_ELECTRODE_TP,   V_FOUND);
        P_SPL_ARR(P_ORIGIN_FROM_DIVISION_ID, V_MAX_LOOP_CNT, V_TOK_ORG_FROM_DIV,   V_FOUND);
        P_SPL_ARR(P_ORIGION_TO_DIVISION_ID,  V_MAX_LOOP_CNT, V_TOK_ORG_TO_DIV,     V_FOUND);
        P_SPL_ARR(P_REMARKS,                 V_MAX_LOOP_CNT, V_TOK_REMARKS,        V_FOUND);
        P_SPL_ARR(P_REMARKS2,                V_MAX_LOOP_CNT, V_TOK_REMARKS2,       V_FOUND);
        P_SPL_ARR(P_REMARKS3,                V_MAX_LOOP_CNT, V_TOK_REMARKS3,       V_FOUND);
        P_SPL_ARR(P_CHANGE_REASON_CODE,      V_MAX_LOOP_CNT, V_TOK_REASON_CODE,    V_FOUND);
        P_SPL_ARR(P_CHANGE_REASON_DETAIL,    V_MAX_LOOP_CNT, V_TOK_REASON_DETAIL,  V_FOUND);
        P_SPL_ARR(P_SHIPTO_CODE,             V_MAX_LOOP_CNT, V_TOK_SHIPTO_CODE,    V_FOUND);

        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP
            V_ACTIVE_FLAG    := V_TOK_ACTIVE_FLAG(I);
            V_DIVISION_ID    := V_TOK_DIVISION_ID(I);
            V_CONFIRM_ID     := V_TOK_CONFIRM_ID(I);
            V_SHIPMENT_QTY   := V_TOK_SHIPMENT_QTY(I);
            V_SHIPMENT_DATE  := V_TOK_SHIPMENT_DATE(I);
            V_FROM_SITE      := V_TOK_FROM_SITE(I);
            V_NEW_BOD_ID     := V_TOK_NEW_BOD_ID(I);
            V_TITLE          := 'Change on ' || V_TOK_TITLE(I);
            V_NEW_ETD_DATE   := V_TOK_NEW_ETD(I);
            V_NEW_ETA_DATE   := V_TOK_NEW_ETA(I);
            V_NEW_ROUTE_ID   := V_TOK_NEW_ROUTE_ID(I);
            V_NEW_INCOTERMS  := V_TOK_NEW_INCOTERMS(I);
            V_NEW_TRANS_MODE := V_TOK_NEW_TRANS(I);
            V_EDIT_MAIN      := V_TOK_EDIT_MAIN(I);
            V_REMARKS        := V_TOK_REMARKS(I);
            V_REMARKS2       := V_TOK_REMARKS2(I);
            V_REMARKS3       := V_TOK_REMARKS3(I);
            V_REASON_CODE    := V_TOK_REASON_CODE(I);
            V_REASON_DETAIL  := V_TOK_REASON_DETAIL(I);
            V_SCR_SHIPTO_CODE := V_TOK_SHIPTO_CODE(I);

            /* 요청에 따라 CHANGE_REASON_CODE, CHANGE_REASON_DETAIL 을 Default T07 로 설정 */
            IF V_REASON_CODE IS NULL THEN
                V_REASON_CODE := 'T07';
            END IF;

            IF V_REASON_DETAIL IS NULL THEN
                V_REASON_DETAIL := 'T07';
            END IF;

            BEGIN
                SELECT TO_SITE
                     , ITEM_ID
                  INTO V_TO_SITE
                     , V_ITEM_ID
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_TO_SITE := NULL;
                    V_ITEM_ID := NULL;
            END;

            IF V_ACTIVE_FLAG = 'I' THEN
                BEGIN
                    SELECT REQUESTOR
                      INTO V_USER_ID_TEMP
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_USER_ID_TEMP := NULL;
                END;

                IF V_USER_ID_TEMP <> P_USER_ID THEN
                    CONTINUE;
                END IF;
            END IF;

            /* E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지 */
            V_SOLDTO_CODE := FN_GET_SSP_SITE_INFO(V_DIVISION_ID, V_TO_SITE, 'SOLDTO_CODE');
            V_SHIPTO_CODE := FN_GET_SSP_SITE_INFO(V_DIVISION_ID, V_TO_SITE, 'SHIPTO_CODE');

            IF V_CONFIRM_ID IS NOT NULL THEN
                IF V_SOLDTO_CODE IS NULL
                OR V_SHIPTO_CODE IS NULL THEN
                    IF V_SOLDTO_CODE IS NULL THEN
                        V_REASON_ID := 'no soldto code';
                    ELSE
                        V_REASON_ID := 'no shipto code';
                    END IF;

                    V_EVENT_DATE := SYSDATE;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0,
                                         '########## ' || V_DIVISION_ID || ' ' || V_TO_SITE
                                         || V_SHIPTO_CODE || ' ' || V_SOLDTO_CODE || ' ' || ' Error END of procedure ##########',
                                         '', V_EVENT_DATE);

                    OPEN O_RC1 FOR
                        SELECT 'X'           AS RESULT_CODE
                             , V_REASON_ID   AS REASON_ID
                             , V_DIVISION_ID AS DIVISION_ID
                             , V_TO_SITE     AS TO_SITE
                          FROM DUAL;

                    P_OPEN_SUCCESS(O_RESULT_CURSOR);

                    RETURN;
                END IF;
            END IF;

            V_DIV_TEMP         := NULL;
            V_BOD_TEMP         := NULL;
            V_FROM_TEMP        := NULL;
            V_TO_TEMP          := NULL;
            V_INCOTERMS_TEMP   := NULL;
            V_TRANS_TEMP       := NULL;
            V_ROUTE_TEMP       := NULL;
            V_D_CONTRY_TEMP    := NULL;
            V_D_PORT_TEMP      := NULL;
            V_A_COUNTRY_TEMP   := NULL;
            V_A_PORT_TEMP      := NULL;
            V_CUSTOMER_LT_TEMP := NULL;
            V_TO_COUNTRY_TEMP  := NULL;
            V_TO_CITY_TEMP     := NULL;

            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIV_TEMP
                     , V_BOD_TEMP
                     , V_FROM_TEMP
                     , V_TO_TEMP
                     , V_INCOTERMS_TEMP
                     , V_TRANS_TEMP
                     , V_ROUTE_TEMP
                     , V_D_CONTRY_TEMP
                     , V_D_PORT_TEMP
                     , V_A_COUNTRY_TEMP
                     , V_A_PORT_TEMP
                     , V_CUSTOMER_LT_TEMP
                     , V_TO_COUNTRY_TEMP
                     , V_TO_CITY_TEMP
                  FROM (SELECT IA.DIVISION_ID
                             , IA.BOD_ID
                             , IA.FROM_SITE
                             , IA.TO_SITE
                             , IA.SSP_INCOTERMS
                             , IA.TRANSPORT_MODE
                             , IA.ROUTE_ID
                             , IA.D_COUNTRY
                             , IA.D_PORT_CODE
                             , IA.A_COUNTRY
                             , IA.A_PORT_CODE
                             , IA.LT_TOTAL
                             , IA.TO_COUNTRY
                             , IA.TO_CITY
                          FROM (SELECT DISTINCT A.DIVISION_ID
                                     , A.BOD_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , A.SSP_INCOTERMS
                                     , A.TRANSPORT_MODE
                                     , A.ROUTE_ID
                                     , A.D_COUNTRY
                                     , A.D_PORT_CODE
                                     , A.A_COUNTRY
                                     , A.A_PORT_CODE
                                     , A.LT_TOTAL
                                     , A.LT_TOTAL_ORIGIN
                                     , A.TO_COUNTRY
                                     , A.TO_CITY
                                     , A.PRIORITY
                                     , A.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V A
                                 WHERE A.DIVISION_ID    = V_DIVISION_ID
                                   AND A.FROM_SITE      = V_FROM_SITE
                                   AND A.TO_SITE        = V_TO_SITE
                                   AND A.TRANSPORT_MODE = V_NEW_TRANS_MODE
                                   AND A.SSP_INCOTERMS  = V_NEW_INCOTERMS
                                   AND A.BOD_VALID_YN   = 'Y'
                                   AND A.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND A.TO_YYYYMMDD   >= V_SHIPMENT_DATE) IA
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , BOD_ID
                                  FROM SCP_MST_BOD_ITEM
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                   AND ITEM_ID     = V_ITEM_ID) XA
                         WHERE XA.DIVISION_ID     = IA.DIVISION_ID
                           AND XA.BOD_ID          = IA.BOD_ID
                           AND IA.DIVISION_ID     = V_DIVISION_ID
                           AND IA.FROM_SITE       = V_FROM_SITE
                           AND IA.TO_SITE         = V_TO_SITE
                           AND IA.TRANSPORT_MODE  = V_NEW_TRANS_MODE
                           AND IA.SSP_INCOTERMS   = V_NEW_INCOTERMS
                           AND IA.BOD_VALID_YN    = 'Y'
                         ORDER BY IA.PRIORITY)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_DIV_TEMP := NULL;
            END;

            IF V_DIV_TEMP         IS NULL
            OR V_BOD_TEMP         IS NULL
            OR V_FROM_TEMP        IS NULL
            OR V_TO_TEMP          IS NULL
            OR V_INCOTERMS_TEMP   IS NULL
            OR V_TRANS_TEMP       IS NULL
            OR V_ROUTE_TEMP       IS NULL
            OR V_D_CONTRY_TEMP    IS NULL
            OR V_D_PORT_TEMP      IS NULL
            OR V_A_COUNTRY_TEMP   IS NULL
            OR V_A_PORT_TEMP      IS NULL
            OR V_CUSTOMER_LT_TEMP IS NULL
            OR V_TO_COUNTRY_TEMP  IS NULL
            OR V_TO_CITY_TEMP     IS NULL THEN
                V_EVENT_DATE := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', V_EVENT_DATE);

                OPEN O_RC1 FOR
                    SELECT 'X'  AS RESULT_CODE
                         , NULL AS REQUEST_NO
                      FROM DUAL;

                P_OPEN_SUCCESS(O_RESULT_CURSOR);

                RETURN;
            END IF;

            IF V_EDIT_MAIN IN ('Y', 'N') THEN
                /* AS-IS MERGE : 있으면 고치고 없으면 넣는다 */
                UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
                   SET CHANGE_REQ_STATUS    = 'D'
                     , REQUEST_TITLE        = V_TITLE
                     , APPROVAL_USER        = P_USER_ID
                     , APPROVAL_DEPT        = P_USER_DEPT_ID
                     , CHANGE_REASON_CODE   = V_REASON_CODE
                     , CHANGE_REASON_DETAIL = V_REASON_DETAIL
                     , LAST_UPDATED_BY      = P_USER_ID
                     , LAST_UPDATE_DATE     = V_EVENT_DATE
                     , REQUEST_TIME         = V_EVENT_DATE
                 WHERE CHANGE_REQ_NO        = V_MAX_REQ_NO;

                IF SQL%ROWCOUNT = 0 THEN
                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                    (
                        CHANGE_REQ_NO
                      , CHANGE_REQ_STATUS
                      , DIVISION_ID
                      , FROM_SITE
                      , REQUEST_TITLE
                      , REQUEST_USER
                      , REQUEST_DEPT
                      , REQUEST_TIME
                      , APPROVAL_USER
                      , APPROVAL_DEPT
                      , APPROVAL_TIME
                      , CHANGE_REASON_CODE
                      , CHANGE_REASON_DETAIL
                      , REJECT_REASON
                      , VALID_YN
                      , CHANGE_TYPE
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                    )
                    VALUES
                    (
                        V_MAX_REQ_NO
                      , 'D'
                      , V_DIVISION_ID
                      , V_FROM_SITE
                      , V_TITLE
                      , P_USER_ID
                      , P_USER_DEPT_ID
                      , V_EVENT_DATE
                      , P_USER_ID
                      , P_USER_DEPT_ID
                      , NULL
                      , V_REASON_CODE
                      , V_REASON_DETAIL
                      , NULL
                      , 'Y'
                      , P_CHANGE_TYPE
                      , P_USER_ID
                      , V_EVENT_DATE
                      , P_USER_ID
                      , V_EVENT_DATE
                      , SUBSTR(TO_CHAR(P_ELECTRODE_YN), 1, INSTR(TO_CHAR(P_ELECTRODE_YN), C_DELIMITER) - 1)
                      , SUBSTR(TO_CHAR(P_ELECTRODE_TYPE), 1, INSTR(TO_CHAR(P_ELECTRODE_TYPE), C_DELIMITER) - 1)
                      , SUBSTR(TO_CHAR(P_ORIGIN_FROM_DIVISION_ID), 1, INSTR(TO_CHAR(P_ORIGIN_FROM_DIVISION_ID), C_DELIMITER) - 1)
                      , SUBSTR(TO_CHAR(P_ORIGION_TO_DIVISION_ID), 1, INSTR(TO_CHAR(P_ORIGION_TO_DIVISION_ID), C_DELIMITER) - 1)
                    );
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅 */
                IF V_SHIPMENT_DATE IS NOT NULL
               AND LENGTH(V_SHIPMENT_DATE) = 8
               AND V_TOK_NEW_LT(I) IS NOT NULL THEN
                    V_NEW_ETD_DATE := V_SHIPMENT_DATE;
                END IF;

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(TO_CHAR(P_DIVISION_ID), V_BOD_TEMP, V_SHIPMENT_DATE);

                INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                (
                    CHANGE_REQ_NO
                  , CONFIRM_ID
                  , NEW_YN
                  , DIVISION_ID
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , YYYYMMDD
                  , QTY
                  , BOD_ID
                  , ROUTE_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , FCST_TYPE
                  , FCST_ETD_DATE
                  , FCST_ETA_DATE
                  , ETD_DATE
                  , ETA_DATE
                  , INCOTERMS
                  , TRANSPORT_MODE
                  , D_COUNTRY
                  , D_PORT_CODE
                  , A_COUNTRY
                  , A_PORT_CODE
                  , CUSTOMER_LT
                  , TO_COUNTRY
                  , TO_CITY
                  , NEW_YYYYMMDD
                  , NEW_QTY
                  , NEW_BOD_ID
                  , NEW_ROUTE_ID
                  , NEW_ETD_DATE
                  , NEW_ETA_DATE
                  , NEW_INCOTERMS
                  , NEW_TRANSPORT_MODE
                  , NEW_D_COUNTRY
                  , NEW_D_PORT_CODE
                  , NEW_A_COUNTRY
                  , NEW_A_PORT_CODE
                  , NEW_CUSTOMER_LT
                  , NEW_TO_COUNTRY
                  , NEW_TO_CITY
                  , FROM_SITE_TYPE
                  , FROM_SITE_PLANT_ID
                  , FROM_SITE_VENDOR_ID
                  , FROM_SITE_SOLDTO_CODE
                  , FROM_SITE_SHIPTO_CODE
                  , FROM_SITE_COMPANY_ID
                  , TO_SITE_TYPE
                  , TO_SITE_PLANT_ID
                  , TO_SITE_VENDOR_ID
                  , TO_SITE_SOLDTO_CODE
                  , TO_SITE_SHIPTO_CODE
                  , TO_SITE_COMPANY_ID
                  , ERP_SO_NO
                  , ERP_SO_ITEM_NO
                  , ERP_DO_NO
                  , ERP_STATUS
                  , VALID_YN
                  , ATTRIBUTE1
                  , ATTRIBUTE2
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , ELECTRODE_YN
                  , ELECTRODE_TYPE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , REMARKS
                  , REMARKS2
                  , REMARKS3
                  , REQUESTOR
                  /*----------------------------------------------------------------------------------------
                      2020.06.30 : KBK
                      I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                  ------------------------------------------------------------------------------------------*/
                  , PACKAGE_TYPE
                  , FACTORY_ID
                  , PACKAGE_QTY
                  , DOM_EXP
                  , ERP_ATTR4
                  , ERP_ATTR5
                )
                SELECT V_MAX_REQ_NO
                     , A.CONFIRM_ID
                     , CASE WHEN P_CHANGE_TYPE = 'N' THEN 'Y' ELSE 'N' END
                     , A.DIVISION_ID
                     , A.ITEM_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , A.YYYYMMDD
                     , A.QTY
                     , A.BOD_ID
                     , A.ROUTE_ID
                     , A.BIZ_TYPE
                     , A.PROJECT_CODE
                     , A.FCST_TYPE
                     , A.FCST_ETD_DATE
                     , A.FCST_ETA_DATE
                     , A.ETD_DATE
                     , A.ETA_DATE
                     , A.INCOTERMS
                     , A.TRANSPORT_MODE
                     , A.D_COUNTRY
                     , A.D_PORT_CODE
                     , A.A_COUNTRY
                     , A.A_PORT_CODE
                     , A.CUSTOMER_LT
                     , A.TO_COUNTRY
                     , A.TO_CITY
                     , V_SHIPMENT_DATE
                     , NVL(TO_NUMBER(V_SHIPMENT_QTY), 0)
                     , V_BOD_TEMP
                     , V_ROUTE_TEMP
                     , V_NEW_ETD_DATE
                     , V_NEW_ETA_DATE
                     , V_INCOTERMS_TEMP
                     , V_TRANS_TEMP
                     , V_D_CONTRY_TEMP
                     , V_D_PORT_TEMP
                     , V_TOK_NEW_A_COUNTRY(I)                                       /* AS-IS 도 이 칸만 조회값이 아닌 화면값 */
                     , V_A_PORT_TEMP
                     , V_CUSTOMER_LT_TEMP
                     , V_TO_COUNTRY_TEMP
                     , V_TOK_NEW_TO_CITY(I)                                         /* AS-IS 도 이 칸만 조회값이 아닌 화면값 */
                     , A.FROM_SITE_TYPE
                     , A.FROM_SITE_PLANT_ID
                     , A.FROM_SITE_VENDOR_ID
                     , A.FROM_SITE_SOLDTO_CODE
                     , A.FROM_SITE_SHIPTO_CODE
                     , A.FROM_SITE_COMPANY_ID
                     , A.TO_SITE_TYPE
                     , A.TO_SITE_PLANT_ID
                     , A.TO_SITE_VENDOR_ID
                     , A.TO_SITE_SOLDTO_CODE
                     , V_SCR_SHIPTO_CODE                                             /* ★SSP0201 은 화면에서 받은 값으로 덮어쓴다(SSP0200 은 원장 값) */
                     , A.TO_SITE_COMPANY_ID
                     , A.ERP_SO_NO
                     , A.ERP_SO_ITEM_NO
                     , A.ERP_DO_NO
                     , A.ERP_STATUS
                     , 'Y'
                     , 'Y'
                     , 'D'                                                          /* STATUS_DETAIL에 Drafting 입력(hsbang, 20240507) */
                     , P_USER_ID
                     , V_CREATE_DATE
                     , P_USER_ID
                     , V_CREATE_DATE
                     , A.ELECTRODE_YN
                     , A.ELECTRODE_TYPE
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , A.REQUESTOR
                     , A.PACKAGE_TYPE_CODE
                     , A.FACTORY_ID
                     , CASE WHEN A.ELECTRODE_YN = 'N' THEN NVL(TO_NUMBER(V_SHIPMENT_QTY), 0)
                            ELSE CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(NVL(TO_NUMBER(V_SHIPMENT_QTY), 0) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                           WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(NVL(TO_NUMBER(V_SHIPMENT_QTY), 0) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                           WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(NVL(TO_NUMBER(V_SHIPMENT_QTY), 0) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                      ELSE NULL END)
                       END
                     , B.DOM_EXP_TYPE
                     , A.ERP_ATTR4
                     , A.ERP_ATTR5
                  FROM SSP_ANL_SHIP_CONFIRM      A
                     , SSP_MST_SITE_ITEM_EE_V    B
                 WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                   AND B.SCM_SITE_ID(+) = A.FROM_SITE
                   AND B.ITEM_ID(+)     = A.ITEM_ID
                   AND A.CONFIRM_ID     = V_CONFIRM_ID;
            END IF;

            /* ROUTE_ID 변경 시 ETA_DATE 반영하기 위하여 결재와 별개로 Confirm UPDATE */
            IF V_ROUTE_TEMP <> V_NEW_ROUTE_ID THEN
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET ROUTE_ID   = V_ROUTE_TEMP
                     , ETA_DATE   = V_NEW_ETA_DATE
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

                /* ETA 변경에 대해서 MKT_FSCST 동기화를 위해 호출 */
                PR_DM_SSP_CONFIRM_SYNC(V_DIVISION_ID, V_CONFIRM_ID);
            END IF;

            UPDATE SSP_ANL_SHIP_CONFIRM
               SET SHIPMENT_STATUS  = 'D'
                 , CHANGE_REQ_NO    = V_MAX_REQ_NO
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = V_EVENT_DATE
             WHERE CONFIRM_ID       = V_CONFIRM_ID;

            IF V_ACTIVE_FLAG = 'I' THEN
                /* 신규 대상 건 FLAG ATTRIBUTE10 초기화 */
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET ATTRIBUTE10  = NULL
                 WHERE CONFIRM_ID   = V_CONFIRM_ID;
            /* ERP전송 Table(XIF_ERP_PACK_SHIP_PLAN_S_SN) Insert                                     */
            /* 출하확정변경시 ERP 전송 이터 테이블 저장 C: 변경요청                                   */
            /* ★AS-IS SSP0201 은 이 호출이 주석 처리되어 있다 — 저장(초안)에서는 ERP 전송을 하지 않는다 */
            /* PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER('C', V_MAX_REQ_NO);                          */
            END IF;
        END LOOP;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', V_EVENT_DATE);

        OPEN O_RC1 FOR
            SELECT V_RESULT_CODE AS RESULT_CODE
                 , V_MAX_REQ_NO  AS REQUEST_NO
              FROM DUAL;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SP_SSP0201_SAVE_DRAFT;

            P_WRITE_ERROR_LOG(V_PROGRAM_NAME, V_ERR);

            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                     , NULL AS REQUEST_NO
                  FROM DUAL;

            P_OPEN_ERROR(V_ERR, O_RESULT_CURSOR);
    END P_SSP0201_SAVE_SHIPMENT_REQUEST_DRAFTING;

    /* ==============================================================================================
       SSP0201_SAVE_SHIPMENT_CONFIRM_NEW
       ============================================================================================== */
    PROCEDURE P_SSP0201_SAVE_SHIPMENT_CONFIRM_NEW
    (
        P_ACTIVE_FLAG       IN  CLOB,
        P_DIVISION_ID       IN  CLOB,
        P_FROM_SITE         IN  CLOB,
        P_TO_SITE           IN  CLOB,
        P_PROJECT_CODE40    IN  CLOB,
        P_PROJECT_CODE      IN  CLOB,
        P_FCST_TYPE         IN  CLOB,
        P_ITEM_ID           IN  CLOB,
        P_SHIPMENT_DATE     IN  CLOB,
        P_SHIPMENT_QTY      IN  CLOB,
        P_INCOTERMS         IN  CLOB,
        P_TRANSPORT_MODE    IN  CLOB,
        P_LT                IN  CLOB,
        P_ETD               IN  CLOB,
        P_ETA               IN  CLOB,
        P_ROUTE_ID          IN  CLOB,
        P_BOD_ID            IN  CLOB,
        P_D_COUNTRY         IN  CLOB,
        P_D_PORT_CODE       IN  CLOB,
        P_A_CONUNTRY        IN  CLOB,
        P_A_PORT_CODE       IN  CLOB,
        P_TO_COUNTRY        IN  CLOB,
        P_TO_CITY           IN  CLOB,
        P_REMARKS           IN  CLOB,
        P_REMARKS2          IN  CLOB,
        P_REMARKS3          IN  CLOB,
        P_USER_ID           IN  VARCHAR2,
        P_TIME_ZONE         IN  VARCHAR2,
        P_SHIPTO_CODE       IN  CLOB,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_SAVE_SHIPMENT_CONFIRM_NEW
     * Description  : Shipment Request NEW 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     * 2021/06/07   KIMYONGHO      신규추가
     * 2023/02/06   jilee          PR_DM_SSP_CONFIRM_SYNC 동기화 추가
     * 2023/05/08   jilee          @v_plan_start_yyyymmdd 누락시 현재 날짜로 삽입
     * 2025/08/18   chkim.68       [E20250821-001308] to_company_id를 from_site에 따라 다르게 적용하는 예외를 적용
     * 2026/05/11   강주용         E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - 경로 조회 TOP 1 + ORDER BY PRIORITY -> 인라인 뷰 정렬 후 ROWNUM = 1
     *                             - 모델이 없는 행(N)은 AS-IS 가 결과를 한 벌 더 되돌리므로
     *                               되돌림값에 N 을 남겨 화면이 첫 결과에서 읽는 값과 맞췄다
     *                             - 저장 시작에 SAVEPOINT · 되돌리기는 결과 커서를 열기 전에 수행
     *                             - 판가 확인 기간은 AS-IS 와 같이 당주 월요일부터 12 주 뒤 월요일까지
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SSP0201_SAVE_SHIPMENT_CONFIRM_NEW';
        V_MAX_LOOP_CNT      PLS_INTEGER;
        V_TOK_ACTIVE_FLAG   T_TOKEN_TAB;
        V_TOK_DIVISION_ID   T_TOKEN_TAB;
        V_TOK_FROM_SITE     T_TOKEN_TAB;
        V_TOK_TO_SITE       T_TOKEN_TAB;
        V_TOK_PROJECT40     T_TOKEN_TAB;
        V_TOK_PROJECT       T_TOKEN_TAB;
        V_TOK_FCST_TYPE     T_TOKEN_TAB;
        V_TOK_ITEM_ID       T_TOKEN_TAB;
        V_TOK_SHIP_DATE     T_TOKEN_TAB;
        V_TOK_SHIP_QTY      T_TOKEN_TAB;
        V_TOK_INCOTERMS     T_TOKEN_TAB;
        V_TOK_TRANS_MODE    T_TOKEN_TAB;
        V_TOK_LT            T_TOKEN_TAB;
        V_TOK_ETD           T_TOKEN_TAB;
        V_TOK_ETA           T_TOKEN_TAB;
        V_TOK_ROUTE_ID      T_TOKEN_TAB;
        V_TOK_BOD_ID        T_TOKEN_TAB;
        V_TOK_D_COUNTRY     T_TOKEN_TAB;
        V_TOK_D_PORT        T_TOKEN_TAB;
        V_TOK_A_COUNTRY     T_TOKEN_TAB;
        V_TOK_A_PORT        T_TOKEN_TAB;
        V_TOK_TO_COUNTRY    T_TOKEN_TAB;
        V_TOK_TO_CITY       T_TOKEN_TAB;
        V_TOK_REMARKS       T_TOKEN_TAB;
        V_TOK_REMARKS2      T_TOKEN_TAB;
        V_TOK_REMARKS3      T_TOKEN_TAB;
        V_TOK_SHIPTO_CODE T_TOKEN_TAB;
        V_FOUND             T_FOUND_TAB;

        V_ACTIVE_FLAG       VARCHAR2(4000 CHAR);
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_FROM_SITE         VARCHAR2(4000 CHAR);
        V_TO_SITE           VARCHAR2(4000 CHAR);
        V_PROJECT_CODE_40   VARCHAR2(4000 CHAR);
        V_PROJECT_CODE      VARCHAR2(4000 CHAR);
        V_FCST_TYPE         VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);
        V_SHIPMENT_DATE     VARCHAR2(4000 CHAR);
        V_SHIPMENT_QTY      VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS     VARCHAR2(4000 CHAR);
        V_NEW_TRANS_MODE    VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT   VARCHAR2(4000 CHAR);
        V_NEW_ETD_DATE      VARCHAR2(4000 CHAR);
        V_NEW_ETA_DATE      VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID      VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID        VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY      VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE   VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY     VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE   VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY    VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY       VARCHAR2(4000 CHAR);
        V_REMARKS           VARCHAR2(4000 CHAR);
        V_REMARKS2          VARCHAR2(4000 CHAR);
        V_REMARKS3          VARCHAR2(4000 CHAR);
        V_SHIPTO_CODE       VARCHAR2(4000 CHAR);

        V_DIVISION_ID_OR    VARCHAR2(4000 CHAR);
        V_TO_SITE_OR        VARCHAR2(4000 CHAR);

        V_OPERATION_GROUP   VARCHAR2(4000 CHAR);
        V_ELECTRODE_YN      VARCHAR2(4000 CHAR);
        V_ORIGIN_FROM_DIV   VARCHAR2(4000 CHAR);
        V_ORIGIN_TO_DIV     VARCHAR2(4000 CHAR);

        V_FROM_SITE_TYPE    VARCHAR2(4000 CHAR);
        V_FROM_SITE_PLANT   VARCHAR2(4000 CHAR);
        V_FROM_SITE_VENDOR  VARCHAR2(4000 CHAR);
        V_FROM_SITE_COMPANY VARCHAR2(4000 CHAR);
        V_FROM_SITE_SOLDTO  VARCHAR2(4000 CHAR);
        V_FROM_SITE_SHIPTO  VARCHAR2(4000 CHAR);
        V_TO_SITE_TYPE      VARCHAR2(4000 CHAR);
        V_TO_SITE_PLANT     VARCHAR2(4000 CHAR);
        V_TO_SITE_VENDOR    VARCHAR2(4000 CHAR);
        V_TO_SITE_COMPANY   VARCHAR2(4000 CHAR);
        V_TO_SITE_SOLDTO    VARCHAR2(4000 CHAR);
        V_TO_SITE_SHIPTO    VARCHAR2(4000 CHAR);
        V_TMP_DIVISION_ID   VARCHAR2(4000 CHAR);

        V_CNT_ITEM_ID       PLS_INTEGER := 0;
        V_VAL_CODE          PLS_INTEGER := 0;
        V_PRJ_CNT           PLS_INTEGER := 0;
        V_PRICE_CHECK_CNT   PLS_INTEGER := 0;
        V_MKT_FCST_CHK_CNT  PLS_INTEGER := 0;
        V_PLAN_START        VARCHAR2(8 CHAR);
        V_SEQ_PLAN          VARCHAR2(4000 CHAR);
        V_SEQ               NUMBER;
        V_NEW_CONFIRM_ID    VARCHAR2(4000 CHAR);
        V_TMP_TIME_ZONE     VARCHAR2(8 CHAR);
        V_ETA               VARCHAR2(8 CHAR);
        V_ETD               VARCHAR2(8 CHAR);
        V_LAST_UPDATE_DATE  DATE;
        V_EVENT_DATE        DATE;
        V_REASON_ID         VARCHAR2(30 CHAR);
        V_RESULT_CODE       VARCHAR2(1 CHAR) := 'S';
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN
        SAVEPOINT SP_SSP0201_SAVE_NEW;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', V_EVENT_DATE);

        V_MAX_LOOP_CNT := F_SPL_CNT(P_ACTIVE_FLAG);

        P_SPL_ARR(P_ACTIVE_FLAG,    V_MAX_LOOP_CNT, V_TOK_ACTIVE_FLAG, V_FOUND);
        P_SPL_ARR(P_DIVISION_ID,    V_MAX_LOOP_CNT, V_TOK_DIVISION_ID, V_FOUND);
        P_SPL_ARR(P_FROM_SITE,      V_MAX_LOOP_CNT, V_TOK_FROM_SITE,   V_FOUND);
        P_SPL_ARR(P_TO_SITE,        V_MAX_LOOP_CNT, V_TOK_TO_SITE,     V_FOUND);
        P_SPL_ARR(P_PROJECT_CODE40, V_MAX_LOOP_CNT, V_TOK_PROJECT40,   V_FOUND);
        P_SPL_ARR(P_PROJECT_CODE,   V_MAX_LOOP_CNT, V_TOK_PROJECT,     V_FOUND);
        P_SPL_ARR(P_FCST_TYPE,      V_MAX_LOOP_CNT, V_TOK_FCST_TYPE,   V_FOUND);
        P_SPL_ARR(P_ITEM_ID,        V_MAX_LOOP_CNT, V_TOK_ITEM_ID,     V_FOUND);
        P_SPL_ARR(P_SHIPMENT_DATE,  V_MAX_LOOP_CNT, V_TOK_SHIP_DATE,   V_FOUND);
        P_SPL_ARR(P_SHIPMENT_QTY,   V_MAX_LOOP_CNT, V_TOK_SHIP_QTY,    V_FOUND);
        P_SPL_ARR(P_INCOTERMS,      V_MAX_LOOP_CNT, V_TOK_INCOTERMS,   V_FOUND);
        P_SPL_ARR(P_TRANSPORT_MODE, V_MAX_LOOP_CNT, V_TOK_TRANS_MODE,  V_FOUND);
        P_SPL_ARR(P_LT,             V_MAX_LOOP_CNT, V_TOK_LT,          V_FOUND);
        P_SPL_ARR(P_ETD,            V_MAX_LOOP_CNT, V_TOK_ETD,         V_FOUND);
        P_SPL_ARR(P_ETA,            V_MAX_LOOP_CNT, V_TOK_ETA,         V_FOUND);
        P_SPL_ARR(P_ROUTE_ID,       V_MAX_LOOP_CNT, V_TOK_ROUTE_ID,    V_FOUND);
        P_SPL_ARR(P_BOD_ID,         V_MAX_LOOP_CNT, V_TOK_BOD_ID,      V_FOUND);
        P_SPL_ARR(P_D_COUNTRY,      V_MAX_LOOP_CNT, V_TOK_D_COUNTRY,   V_FOUND);
        P_SPL_ARR(P_D_PORT_CODE,    V_MAX_LOOP_CNT, V_TOK_D_PORT,      V_FOUND);
        P_SPL_ARR(P_A_CONUNTRY,     V_MAX_LOOP_CNT, V_TOK_A_COUNTRY,   V_FOUND);
        P_SPL_ARR(P_A_PORT_CODE,    V_MAX_LOOP_CNT, V_TOK_A_PORT,      V_FOUND);
        P_SPL_ARR(P_TO_COUNTRY,     V_MAX_LOOP_CNT, V_TOK_TO_COUNTRY,  V_FOUND);
        P_SPL_ARR(P_TO_CITY,        V_MAX_LOOP_CNT, V_TOK_TO_CITY,     V_FOUND);
        P_SPL_ARR(P_REMARKS,        V_MAX_LOOP_CNT, V_TOK_REMARKS,     V_FOUND);
        P_SPL_ARR(P_REMARKS2,       V_MAX_LOOP_CNT, V_TOK_REMARKS2,    V_FOUND);
        P_SPL_ARR(P_REMARKS3,       V_MAX_LOOP_CNT, V_TOK_REMARKS3,    V_FOUND);
        P_SPL_ARR(P_SHIPTO_CODE,    V_MAX_LOOP_CNT, V_TOK_SHIPTO_CODE, V_FOUND);

        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP
            V_ACTIVE_FLAG     := V_TOK_ACTIVE_FLAG(I);
            V_DIVISION_ID     := V_TOK_DIVISION_ID(I);
            V_FROM_SITE       := V_TOK_FROM_SITE(I);
            V_TO_SITE         := V_TOK_TO_SITE(I);
            V_PROJECT_CODE_40 := V_TOK_PROJECT40(I);
            V_PROJECT_CODE    := V_TOK_PROJECT(I);
            V_FCST_TYPE       := V_TOK_FCST_TYPE(I);
            V_ITEM_ID         := V_TOK_ITEM_ID(I);
            V_SHIPMENT_DATE   := V_TOK_SHIP_DATE(I);
            V_SHIPMENT_QTY    := V_TOK_SHIP_QTY(I);
            V_NEW_INCOTERMS   := V_TOK_INCOTERMS(I);
            V_NEW_TRANS_MODE  := V_TOK_TRANS_MODE(I);
            V_NEW_CUSTOMER_LT := V_TOK_LT(I);
            V_NEW_ETD_DATE    := V_TOK_ETD(I);
            V_NEW_ETA_DATE    := V_TOK_ETA(I);
            V_NEW_ROUTE_ID    := V_TOK_ROUTE_ID(I);
            V_NEW_BOD_ID      := V_TOK_BOD_ID(I);
            V_NEW_D_CONTRY    := V_TOK_D_COUNTRY(I);
            V_NEW_D_PORT_CODE := V_TOK_D_PORT(I);
            V_NEW_A_COUNTRY   := V_TOK_A_COUNTRY(I);
            V_NEW_A_PORT_CODE := V_TOK_A_PORT(I);
            V_NEW_TO_COUNTRY  := V_TOK_TO_COUNTRY(I);
            V_NEW_TO_CITY     := V_TOK_TO_CITY(I);
            V_REMARKS         := V_TOK_REMARKS(I);
            V_REMARKS2        := V_TOK_REMARKS2(I);
            V_REMARKS3        := V_TOK_REMARKS3(I);
            V_SHIPTO_CODE     := V_TOK_SHIPTO_CODE(I);

            V_DIVISION_ID_OR  := V_DIVISION_ID;
            V_TO_SITE_OR      := V_TO_SITE;

            BEGIN
                SELECT DIVISION_ID
                     , BOD_ID
                     , FROM_SITE
                     , TO_SITE
                     , SSP_INCOTERMS
                     , TRANSPORT_MODE
                     , ROUTE_ID
                     , D_COUNTRY
                     , D_PORT_CODE
                     , A_COUNTRY
                     , A_PORT_CODE
                     , LT_TOTAL
                     , TO_COUNTRY
                     , TO_CITY
                  INTO V_DIVISION_ID
                     , V_NEW_BOD_ID
                     , V_FROM_SITE
                     , V_TO_SITE
                     , V_NEW_INCOTERMS
                     , V_NEW_TRANS_MODE
                     , V_NEW_ROUTE_ID
                     , V_NEW_D_CONTRY
                     , V_NEW_D_PORT_CODE
                     , V_NEW_A_COUNTRY
                     , V_NEW_A_PORT_CODE
                     , V_NEW_CUSTOMER_LT
                     , V_NEW_TO_COUNTRY
                     , V_NEW_TO_CITY
                  FROM (SELECT IA.DIVISION_ID
                             , IA.BOD_ID
                             , IA.FROM_SITE
                             , IA.TO_SITE
                             , IA.SSP_INCOTERMS
                             , IA.TRANSPORT_MODE
                             , IA.ROUTE_ID
                             , IA.D_COUNTRY
                             , IA.D_PORT_CODE
                             , IA.A_COUNTRY
                             , IA.A_PORT_CODE
                             , IA.LT_TOTAL
                             , IA.TO_COUNTRY
                             , IA.TO_CITY
                          FROM (SELECT DISTINCT A.DIVISION_ID
                                     , A.BOD_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , A.SSP_INCOTERMS
                                     , A.TRANSPORT_MODE
                                     , A.ROUTE_ID
                                     , A.D_COUNTRY
                                     , A.D_PORT_CODE
                                     , A.A_COUNTRY
                                     , A.A_PORT_CODE
                                     , A.LT_TOTAL
                                     , A.LT_TOTAL_ORIGIN
                                     , A.TO_COUNTRY
                                     , A.TO_CITY
                                     , A.PRIORITY
                                     , A.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V A
                                 WHERE A.DIVISION_ID    = V_DIVISION_ID
                                   AND A.FROM_SITE      = V_FROM_SITE
                                   AND A.TO_SITE        = V_TO_SITE
                                   AND A.TRANSPORT_MODE = V_NEW_TRANS_MODE
                                   AND A.SSP_INCOTERMS  = V_NEW_INCOTERMS
                                   AND A.BOD_VALID_YN   = 'Y'
                                   AND A.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND A.TO_YYYYMMDD   >= V_SHIPMENT_DATE) IA
                             , (SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , BOD_ID
                                  FROM SCP_MST_BOD_ITEM
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                   AND ITEM_ID     = V_ITEM_ID) XA
                         WHERE XA.DIVISION_ID    = IA.DIVISION_ID
                           AND XA.BOD_ID         = IA.BOD_ID
                           AND IA.DIVISION_ID    = V_DIVISION_ID
                           AND IA.FROM_SITE      = V_FROM_SITE
                           AND IA.TO_SITE        = V_TO_SITE
                           AND IA.TRANSPORT_MODE = V_NEW_TRANS_MODE
                           AND IA.SSP_INCOTERMS  = V_NEW_INCOTERMS
                           AND IA.BOD_VALID_YN   = 'Y'
                         ORDER BY IA.PRIORITY)
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_NEW_BOD_ID := NULL;
            END;

            IF V_DIVISION_ID     IS NULL
            OR V_NEW_BOD_ID      IS NULL
            OR V_FROM_SITE       IS NULL
            OR V_TO_SITE         IS NULL
            OR V_NEW_INCOTERMS   IS NULL
            OR V_NEW_TRANS_MODE  IS NULL
            OR V_NEW_ROUTE_ID    IS NULL
            OR V_NEW_D_CONTRY    IS NULL
            OR V_NEW_D_PORT_CODE IS NULL
            OR V_NEW_A_COUNTRY   IS NULL
            OR V_NEW_A_PORT_CODE IS NULL
            OR V_NEW_CUSTOMER_LT IS NULL
            OR V_NEW_TO_COUNTRY  IS NULL
            OR V_NEW_TO_CITY     IS NULL THEN
                V_EVENT_DATE := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', V_EVENT_DATE);

                OPEN O_RC1 FOR
                    SELECT 'X' AS RESULT_CODE
                      FROM DUAL;

                P_OPEN_SUCCESS(O_RESULT_CURSOR);

                RETURN;
            END IF;

            BEGIN
                SELECT DIVISION_ID
                     , OPERATION_GROUP
                  INTO V_ORIGIN_FROM_DIV
                     , V_OPERATION_GROUP
                  FROM SCM_MST_SITE
                 WHERE SCM_SITE_ID = V_FROM_SITE
                   AND DIVISION_ID = V_DIVISION_ID
                   AND VALID_YN    = 'Y';
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_ORIGIN_FROM_DIV := NULL;
                    V_OPERATION_GROUP := NULL;
                WHEN TOO_MANY_ROWS THEN
                    V_ORIGIN_FROM_DIV := NULL;
                    V_OPERATION_GROUP := NULL;
            END;

            IF V_PROJECT_CODE = '-' THEN
                V_PROJECT_CODE := NULL;
            END IF;

            IF V_OPERATION_GROUP <> 'E'
            OR V_OPERATION_GROUP IS NULL THEN
                V_ELECTRODE_YN  := 'N';
                V_ORIGIN_TO_DIV := V_ORIGIN_FROM_DIV;
            ELSE
                V_ELECTRODE_YN := 'Y';

                BEGIN
                    SELECT DIVISION_ID
                      INTO V_ORIGIN_TO_DIV
                      FROM SCM_MST_SITE
                     WHERE SCM_SITE_ID = V_TO_SITE
                       AND VALID_YN    = 'Y';
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_ORIGIN_TO_DIV := NULL;
                    WHEN TOO_MANY_ROWS THEN
                        V_ORIGIN_TO_DIV := NULL;
                END;
            END IF;

            SELECT NVL(COUNT(*), 0)
              INTO V_CNT_ITEM_ID
              FROM (SELECT DISTINCT B.DIVISION_ID
                      FROM SCM_MST_SITE_ITEM  A
                         , SCM_MST_DIVISION   B
                         , SCM_MST_SITE       C
                         , SCM_MST_ITEM_SN    D
                         , SCM_MST_PROJECT    E
                     WHERE B.DIVISION_ID    = A.DIVISION_ID
                       AND C.DIVISION_ID    = A.DIVISION_ID
                       AND C.SCM_SITE_ID    = A.SCM_SITE_ID
                       AND D.DIVISION_ID    = A.DIVISION_ID
                       AND D.ITEM_ID        = A.ITEM_ID
                       AND E.DIVISION_ID(+) = A.DIVISION_ID
                       AND E.PROJECT_CODE(+)= A.PROJECT_CODE
                       AND CASE WHEN V_DIVISION_ID = 'ALL' THEN 'ALL' ELSE A.DIVISION_ID END
                           IN (SELECT COLUMN_VALUE
                                 FROM TABLE(STRING_SPLIT(V_DIVISION_ID, ',')))
                       AND A.PROJECT_CODE LIKE '%' || V_PROJECT_CODE || '%'
                       AND (A.ITEM_ID   LIKE '%' || V_ITEM_ID || '%'
                         OR D.ITEM_NAME LIKE '%' || V_ITEM_ID || '%'
                         OR D.NICK_NAME LIKE '%' || V_ITEM_ID || '%'));

            /* VALIDATION 체크 - 1:해당 MODEL 있음 / 0:해당 MODEL 없음 */
            IF V_CNT_ITEM_ID > 0 THEN
                V_VAL_CODE := 1;
            ELSE
                V_VAL_CODE := 0;
            END IF;

            IF V_VAL_CODE = 1 THEN
                V_EVENT_DATE    := SYSDATE;
                V_TMP_TIME_ZONE := TO_CHAR(FN_MULTY_TIME(P_TIME_ZONE), 'YYYYMMDD');

                SELECT SEQ1_SSP_ANL_SHIP_CONFIRM_ID.NEXTVAL
                  INTO V_SEQ
                  FROM DUAL;

                V_NEW_CONFIRM_ID := 'C' || V_TMP_TIME_ZONE || SUBSTR('000000' || TO_CHAR(V_SEQ), -6);

                SELECT NVL(MAX(PLAN_START_YYYYMMDD), TO_CHAR(SYSDATE, 'YYYYMMDD'))
                     , NVL(MAX(PLAN_SEQ), '1')
                  INTO V_PLAN_START
                     , V_SEQ_PLAN
                  FROM SSP_PLAN_VERSION_V
                 WHERE PLAN_TYPE    = 'SP'
                   AND DIVISION_ID  = V_DIVISION_ID
                   AND CONFIRM_FLAG = 'Y'
                   AND PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
                                                FROM SSP_PLAN_VERSION_V
                                               WHERE DIVISION_ID  = V_DIVISION_ID
                                                 AND PLAN_TYPE    = 'SP'
                                                 AND CONFIRM_FLAG = 'Y');

                /* [E20250821-001308] TO_COMPANY_ID 를 FROM_SITE 에 따라 다르게 적용하는 예외를 적용 */
                V_TMP_DIVISION_ID   := V_ORIGIN_FROM_DIV;
                V_FROM_SITE_TYPE    := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_FROM_SITE, 'SITE_TYPE');
                V_FROM_SITE_PLANT   := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_FROM_SITE, 'PLANT_ID');
                V_FROM_SITE_VENDOR  := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_FROM_SITE, 'VENDOR_ID');
                V_FROM_SITE_COMPANY := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_FROM_SITE, 'COMPANY_ID');
                V_FROM_SITE_SOLDTO  := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_FROM_SITE, 'SOLDTO_CODE');
                V_FROM_SITE_SHIPTO  := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_FROM_SITE, 'SHIPTO_CODE');

                V_TMP_DIVISION_ID   := CASE WHEN V_DIVISION_ID = 'EE' THEN V_ORIGIN_FROM_DIV ELSE V_ORIGIN_TO_DIV END;
                V_TO_SITE_TYPE      := FN_GET_SSP_SITE_INFO_EXCEPTION(V_TMP_DIVISION_ID, V_FROM_SITE, V_TO_SITE, 'SITE_TYPE');
                V_TO_SITE_PLANT     := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_TO_SITE, 'PLANT_ID');
                V_TO_SITE_VENDOR    := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_TO_SITE, 'VENDOR_ID');
                V_TO_SITE_COMPANY   := FN_GET_SSP_SITE_INFO_EXCEPTION(V_TMP_DIVISION_ID, V_FROM_SITE, V_TO_SITE, 'COMPANY_ID');
                V_TO_SITE_SOLDTO    := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_TO_SITE, 'SOLDTO_CODE');
                V_TO_SITE_SHIPTO    := FN_GET_SSP_SITE_INFO(V_TMP_DIVISION_ID, V_TO_SITE, 'SHIPTO_CODE');

                /* E20260514-001358 TO_ shipto / soldto 없는 경우 출하 금지 */
                IF V_TO_SITE_SOLDTO IS NULL
                OR V_TO_SITE_SHIPTO IS NULL THEN
                    IF V_TO_SITE_SOLDTO IS NULL THEN
                        V_REASON_ID := 'no soldto code';
                    ELSE
                        V_REASON_ID := 'no shipto code';
                    END IF;

                    V_EVENT_DATE := SYSDATE;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0,
                                         '########## ' || V_DIVISION_ID_OR || ' ' || V_TO_SITE_OR
                                         || V_TO_SITE_SHIPTO || ' ' || V_TO_SITE_SOLDTO || ' ' || ' Error END of procedure ##########',
                                         '', V_EVENT_DATE);

                    OPEN O_RC1 FOR
                        SELECT 'X'              AS RESULT_CODE
                             , V_REASON_ID      AS REASON_ID
                             , V_DIVISION_ID_OR AS DIVISION_ID
                             , V_TO_SITE_OR     AS TO_SITE
                          FROM DUAL;

                    P_OPEN_SUCCESS(O_RESULT_CURSOR);

                    RETURN;
                END IF;

                /* mkt owner select */
                IF V_DIVISION_ID = '40' THEN
                    SELECT COUNT(PROJECT_CODE)
                      INTO V_PRJ_CNT
                      FROM SCM_MST_SITE_ITEM
                     WHERE DIVISION_ID  = V_DIVISION_ID
                       AND SCM_SITE_ID  = V_TO_SITE
                       AND ITEM_ID      = V_ITEM_ID
                       AND PROJECT_CODE = V_PROJECT_CODE_40;

                    IF V_PRJ_CNT = 0 THEN
                        BEGIN
                            SELECT PROJECT_CODE
                              INTO V_PROJECT_CODE
                              FROM SCM_MST_SITE_ITEM
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND SCM_SITE_ID = V_TO_SITE
                               AND ITEM_ID     = V_ITEM_ID
                               AND ROWNUM      = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN
                                NULL;
                        END;
                    END IF;
                END IF;

                /*
                판가 입력 정보 조회
                52주 구간 전부에 입력이 안되어있으면 신규 생성 불가
                현재 SSP는 내/외수를 구분하지 않기 때문에 DOM_EXP 타입을 DOM 로 강제로 설정 후 처리하였음(한개로 처리하기 위해서)
                */
                SELECT COUNT(*)
                  INTO V_PRICE_CHECK_CNT
                  FROM (SELECT DISTINCT A.DIVISION_ID
                             , A.PROJECT_CODE
                             , A.SCM_SITE_ID
                             , A.PLANT_SITE_ID
                             , A.ITEM_ID
                             , A.MEASURE
                             , 'DOM' AS DOM_EXP
                             , A.FCST_TYPE
                             , A.INCOTERMS
                             , COUNT(*) AS CNT
                          FROM SCM_MST_FUTURE_PRICE  A
                             , SCM_SYS_CALENDAR_M    B
                             , (SELECT MIN(BASIS_START_DATE) AS BASIS_START_DATE
                                     , MAX(BASIS_END_DATE)   AS BASIS_END_DATE
                                  FROM SCM_SYS_CALENDAR_M
                                 WHERE BASIS_YYYYMMDD BETWEEN TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')                    /* 당주 월요일부터 */
                                                          AND TO_CHAR(TO_DATE(TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD'), 'YYYYMMDD') + 84, 'YYYYMMDD')) IA   /* 12주후 월요일까지 */
                         WHERE B.BASIS_YYYYMMDD = A.YYYYMMDD
                           AND B.DAYOFWEEK      = 'MON'
                           AND A.DIVISION_ID    = V_DIVISION_ID
                           AND A.PROJECT_CODE   = CASE WHEN V_DIVISION_ID = '40' THEN V_PROJECT_CODE_40 ELSE V_PROJECT_CODE END
                           AND A.SCM_SITE_ID    = V_TO_SITE
                           AND A.ITEM_ID        = V_ITEM_ID
                           AND A.FCST_TYPE      = V_FCST_TYPE
                           AND A.INCOTERMS      = V_NEW_INCOTERMS
                           AND A.MEASURE        = 'KRW'
                           AND A.FCST_TYPE NOT IN (SELECT SEGMENT2
                                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                    WHERE LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                                                      AND SEGMENT1    = 'FCST_TYPE'
                                                      AND VALID_YN    = 'Y')
                           AND A.YYYYMMDD BETWEEN IA.BASIS_START_DATE AND IA.BASIS_END_DATE
                         GROUP BY A.DIVISION_ID
                                , A.PROJECT_CODE
                                , A.SCM_SITE_ID
                                , A.PLANT_SITE_ID
                                , A.ITEM_ID
                                , A.MEASURE
                                , A.DOM_EXP
                                , A.FCST_TYPE
                                , A.INCOTERMS
                        HAVING COUNT(*) = 13);

                IF V_PRICE_CHECK_CNT > 1 THEN
                    V_PRICE_CHECK_CNT := 1;
                END IF;

                /* 해당 LOOKUP 등록 정보는 판가입력 정보를 Check 하지 않음 */
                SELECT COUNT(*)
                  INTO V_MKT_FCST_CHK_CNT
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'MKT_FCST_VALIDATION_PRICE'
                   AND SEGMENT1    = 'FCST_TYPE'
                   AND VALID_YN    = 'Y'
                   AND SEGMENT2    = V_FCST_TYPE;

                /* 법인간 거래이면 판가입력 정보를 Check 하지 않음 */
                IF (V_FROM_SITE_TYPE = 'B' AND V_TO_SITE_TYPE = 'B')
                OR (V_FROM_SITE_TYPE = 'B' AND V_TO_SITE_TYPE = 'C')
                OR (V_FROM_SITE_TYPE = 'C' AND V_TO_SITE_TYPE = 'C')
                OR (V_FROM_SITE_TYPE = 'C' AND V_TO_SITE_TYPE = 'B') THEN
                    V_PRICE_CHECK_CNT := 1;
                END IF;

                /* 판가 정보없고, 법인간 거래가 아니거나, LOOKUP에 등록된 FCST_TYPE이 아니면 RETURN */
                IF V_PRICE_CHECK_CNT = 1 THEN
                    V_PRICE_CHECK_CNT := 1;
                ELSIF V_MKT_FCST_CHK_CNT = 1 THEN
                    V_PRICE_CHECK_CNT := 1;
                ELSE
                    V_EVENT_DATE := SYSDATE;
                    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', V_EVENT_DATE);

                    OPEN O_RC1 FOR
                        SELECT 'F' AS RESULT_CODE
                          FROM DUAL;

                    P_OPEN_SUCCESS(O_RESULT_CURSOR);

                    RETURN;
                END IF;

                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');
                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');
                V_ETA           := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID, V_SHIPMENT_DATE);
                V_ETD           := FN_GET_SSP_ETD_DATE(V_DIVISION_ID, V_NEW_BOD_ID, V_SHIPMENT_DATE);

                V_LAST_UPDATE_DATE := SYSDATE;

                IF V_PROJECT_CODE IS NULL THEN
                    V_PROJECT_CODE := '-';
                END IF;

                INSERT INTO SSP_ANL_SHIP_CONFIRM
                (
                    CONFIRM_ID
                  , SHIPMENT_STATUS
                  , DIVISION_ID
                  , PLAN_START_YYYYMMDD
                  , PLAN_TYPE
                  , SEQ
                  , ITEM_ID
                  , FROM_SITE
                  , TO_SITE
                  , YYYYMMDD
                  , PLANNED_QTY
                  , QTY
                  , BOD_ID
                  , ROUTE_ID
                  , BIZ_TYPE
                  , PROJECT_CODE
                  , FCST_TYPE
                  , FCST_ETD_DATE
                  , FCST_ETA_DATE
                  , ETD_DATE
                  , ETA_DATE
                  , INCOTERMS
                  , TRANSPORT_MODE
                  , D_COUNTRY
                  , D_PORT_CODE
                  , A_COUNTRY
                  , A_PORT_CODE
                  , CUSTOMER_LT
                  , TO_COUNTRY
                  , TO_CITY
                  , FROM_SITE_TYPE
                  , FROM_SITE_PLANT_ID
                  , FROM_SITE_VENDOR_ID
                  , FROM_SITE_SOLDTO_CODE
                  , FROM_SITE_SHIPTO_CODE
                  , FROM_SITE_COMPANY_ID
                  , TO_SITE_TYPE
                  , TO_SITE_PLANT_ID
                  , TO_SITE_VENDOR_ID
                  , TO_SITE_SOLDTO_CODE
                  , TO_SITE_SHIPTO_CODE
                  , TO_SITE_COMPANY_ID
                  , CHANGE_TYPE
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , REMARKS
                  , REMARKS2
                  , REMARKS3
                  , ELECTRODE_YN
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                  , BEFORE_QTY
                  , CHECK_NEED_YN
                  , REQUESTOR
                  , ATTRIBUTE10
                )
                VALUES
                (
                    V_NEW_CONFIRM_ID
                  , 'C'
                  , V_DIVISION_ID
                  , V_PLAN_START
                  , 'SP'
                  , V_SEQ_PLAN
                  , V_ITEM_ID
                  , V_FROM_SITE
                  , V_TO_SITE
                  , V_SHIPMENT_DATE
                  , 0
                  , TO_NUMBER(V_SHIPMENT_QTY)
                  , V_NEW_BOD_ID
                  , V_NEW_ROUTE_ID
                  , V_OPERATION_GROUP
                  , CASE WHEN V_DIVISION_ID = '40' THEN V_PROJECT_CODE_40 ELSE V_PROJECT_CODE END
                  , V_FCST_TYPE
                  , V_NEW_ETD_DATE
                  , V_ETA
                  , V_NEW_ETD_DATE
                  , V_ETA
                  , V_NEW_INCOTERMS
                  , V_NEW_TRANS_MODE
                  , V_NEW_D_CONTRY
                  , V_NEW_D_PORT_CODE
                  , V_NEW_A_COUNTRY
                  , V_NEW_A_PORT_CODE
                  , V_NEW_CUSTOMER_LT
                  , V_NEW_TO_COUNTRY
                  , V_NEW_TO_CITY
                  , V_FROM_SITE_TYPE
                  , V_FROM_SITE_PLANT
                  , V_FROM_SITE_VENDOR
                  , V_FROM_SITE_SOLDTO
                  , V_FROM_SITE_SHIPTO
                  , V_FROM_SITE_COMPANY
                  , V_TO_SITE_TYPE
                  , V_TO_SITE_PLANT
                  , V_TO_SITE_VENDOR
                  , V_TO_SITE_SOLDTO
                  , V_SHIPTO_CODE                                                    /* ★SSP0201 은 화면에서 받은 도착지 코드를 넣는다(SSP0200 은 원장에서 구한 값) */
                  , V_TO_SITE_COMPANY
                  , 'N'
                  , P_USER_ID
                  , V_LAST_UPDATE_DATE
                  , P_USER_ID
                  , V_LAST_UPDATE_DATE
                  , V_REMARKS
                  , V_REMARKS2
                  , V_REMARKS3
                  , V_ELECTRODE_YN
                  , V_ORIGIN_FROM_DIV
                  , V_ORIGIN_TO_DIV
                  , 0
                  , 'Y'
                  , P_USER_ID
                  , 'I'
                );

                /* 230226 jilee DM Confirm 동기화 추가 */
                PR_DM_SSP_CONFIRM_SYNC(V_DIVISION_ID, V_NEW_CONFIRM_ID);
            ELSIF V_VAL_CODE = 0 THEN
                V_RESULT_CODE := 'N';
            END IF;
        END LOOP;

        OPEN O_RC1 FOR
            SELECT V_RESULT_CODE    AS RESULT_CODE
                 , V_NEW_CONFIRM_ID AS CONFRIMID
              FROM DUAL;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########',
                             'Confrim_ID : ' || V_NEW_CONFIRM_ID || ' / Time Zone : ' || V_TMP_TIME_ZONE || ' / Seq : ' || TO_CHAR(V_SEQ),
                             V_EVENT_DATE);

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SP_SSP0201_SAVE_NEW;                                        /* 입력 데이타 롤백 처리 */

            P_WRITE_ERROR_LOG(V_PROGRAM_NAME, V_ERR);

            OPEN O_RC1 FOR
                SELECT 'F'  AS RESULT_CODE
                     , NULL AS CONFRIMID
                  FROM DUAL;

            P_OPEN_ERROR(V_ERR, O_RESULT_CURSOR);
    END P_SSP0201_SAVE_SHIPMENT_CONFIRM_NEW;

    /* ==============================================================================================
       SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE
       ============================================================================================== */
    PROCEDURE P_SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE
    (
        P_DIVISION_ID               IN  CLOB,
        P_FROM_SITE                 IN  CLOB,
        P_TITLE                     IN  VARCHAR2,
        P_REQUEST_ID                IN  VARCHAR2,
        P_REQUEST_DEPT_ID           IN  VARCHAR2,
        P_APPROVAL_ID               IN  VARCHAR2,
        P_APPROVAL_DEPT_ID          IN  VARCHAR2,
        P_CHANGE_REASON             IN  VARCHAR2,
        P_REASON_DETAIL             IN  VARCHAR2,
        P_LAST_UPDATED_BY           IN  VARCHAR2,
        P_MAIN_CONFIRM_ID           IN  CLOB,
        P_CONFIRM_ID                IN  CLOB,
        P_NEW_CONFIRM_ID            IN  CLOB,
        P_NEW_BOD_ID                IN  CLOB,
        P_NEW_ROUTE_ID              IN  CLOB,
        P_NEW_INCOTERMS             IN  CLOB,
        P_NEW_D_CONTRY              IN  CLOB,
        P_NEW_D_PORT_CODE           IN  CLOB,
        P_NEW_A_COUNTRY             IN  CLOB,
        P_NEW_A_PORT_CODE           IN  CLOB,
        P_NEW_TO_COUNTRY            IN  CLOB,
        P_NEW_TO_CITY               IN  CLOB,
        P_NEW_LT_DAY                IN  CLOB,
        P_CHANGE_STATUS             IN  VARCHAR2,
        P_NEW_ETD_DATE              IN  CLOB,
        P_NEW_ETA_DATE              IN  CLOB,
        P_NEW_TRANSPORT_MODE        IN  CLOB,
        P_SHIP_STATUS               IN  VARCHAR2,
        P_CHANGE_REQ_NO             IN  CLOB,
        P_NEW_SHIP_DATE             IN  CLOB,
        P_NEW_QTY                   IN  CLOB,
        P_NEW_YN                    IN  CLOB,
        P_TIME_ZONE                 IN  VARCHAR2,
        P_IF_SEND_FLAG              IN  VARCHAR2,
        P_CHANGE_TYPE               IN  VARCHAR2,
        P_PLAN_CONFIRM_ID           IN  CLOB,
        P_ELECTRODE_YN              IN  CLOB,
        P_ELECTRODE_TYPE            IN  CLOB,
        P_ORIGIN_FROM_DIVISION_ID   IN  CLOB,
        P_ORIGION_TO_DIVISION_ID    IN  CLOB,
        P_REMARKS                   IN  CLOB,
        P_REMARKS2                  IN  CLOB,
        P_REMARKS3                  IN  CLOB,
        P_REQUESTOR                 IN  VARCHAR2,
        P_AUTH                      IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR,
        O_RESULT_CURSOR             OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE
     * Description  : Shipment Change Request 작성중 저장
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2021/06/03   KIMYONGHO      최초작성
     * 2024/05/08   hsbang         SSP_ANL_SHIP_CONFIRM_CHG_REQ Status Insert(hsbang, 2024.05.08)
     * 2024/05/09   jilee          Unauthorized 부분 주석
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - MERGE 는 온라인 SQL 에서 쓰지 않으므로 UPDATE 후 바뀐 행이 없으면 INSERT 로 나눴다
     *                             - THROW 60001 -> RAISE_APPLICATION_ERROR(-20001) · 같은 번호는 이력을 남기지 않는다
     *                             - AS-IS 는 갱신을 확정(COMMIT)한 뒤 메일을 보내지만 확정은 호출한 쪽에 맡기고
     *                               순서만 같게 두었다
     *                             - 승인 권한 확인(Unauthorized) 구간은 AS-IS 에서 주석이라 옮기지 않았다
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE';
        V_MAX_LOOP_CNT      PLS_INTEGER;
        V_TOK_MAIN_CONFIRM  T_TOKEN_TAB;
        V_TOK_DIVISION_ID   T_TOKEN_TAB;
        V_TOK_FROM_SITE     T_TOKEN_TAB;
        V_TOK_CHANGE_REQ    T_TOKEN_TAB;
        V_FOUND             T_FOUND_TAB;

        V_MAIN_CONFIRM_ID   VARCHAR2(4000 CHAR);
        V_DIVISION_ID       VARCHAR2(4000 CHAR);
        V_FROM_SITE         VARCHAR2(4000 CHAR);
        V_CHANGE_REQ_NO     VARCHAR2(4000 CHAR);
        V_ITEM_ID           VARCHAR2(4000 CHAR);
        V_MODEL_PIC         VARCHAR2(4000 CHAR);
        V_MODEL_PIC_TEMP    VARCHAR2(4000 CHAR);
        V_MODEL_PIC_TEMP2   VARCHAR2(4000 CHAR);
        V_ITEM_ID_TEMP      VARCHAR2(4000 CHAR);
        V_ITEM_ID_TEMP2     VARCHAR2(4000 CHAR);
        V_DEFAULT_GROUP_ID  VARCHAR2(4000 CHAR);
        V_MY_MODEL_CHK      PLS_INTEGER := 0;
        V_CHK               PLS_INTEGER := 0;
        V_SEQ               NUMBER;
        V_NEW_CONFIRM_ID    VARCHAR2(4000 CHAR) := TO_CHAR(P_NEW_CONFIRM_ID);
        V_LAST_UPDATE_DATE  DATE := SYSDATE;
        V_EVENT_DATE        DATE;
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN
        SAVEPOINT SP_SSP0201_SAVE_COMPLETE;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', V_EVENT_DATE);

        /* AS-IS 사용자 표의 기본 권한 그룹 -> 사용자 · 그룹 연결 표 (2026.09.22 실측 교정)
           사용자 표에 권한 그룹 칸이 없고 한 사람이 여러 그룹에 들 수 있어 1 행만 읽는다 */
        BEGIN
            SELECT USER_GR_ID
              INTO V_DEFAULT_GROUP_ID
              FROM SCM_ADM_USER_GR_MPG_M
             WHERE USER_ID = P_APPROVAL_ID
               AND USE_YN  = 'Y'
               AND ROWNUM  = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_DEFAULT_GROUP_ID := NULL;
        END;

        V_MAX_LOOP_CNT := F_SPL_CNT(P_MAIN_CONFIRM_ID);

        P_SPL_ARR(P_MAIN_CONFIRM_ID, V_MAX_LOOP_CNT, V_TOK_MAIN_CONFIRM, V_FOUND);
        P_SPL_ARR(P_DIVISION_ID,     V_MAX_LOOP_CNT, V_TOK_DIVISION_ID,  V_FOUND);
        P_SPL_ARR(P_FROM_SITE,       V_MAX_LOOP_CNT, V_TOK_FROM_SITE,    V_FOUND);
        P_SPL_ARR(P_CHANGE_REQ_NO,   V_MAX_LOOP_CNT, V_TOK_CHANGE_REQ,   V_FOUND);

        /* 다중 변경 시 동일 PIC · 동일 모델만 변경 가능 · 자가 승인 제한 확인 */
        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP
            V_MAIN_CONFIRM_ID := V_TOK_MAIN_CONFIRM(I);
            V_DIVISION_ID     := V_TOK_DIVISION_ID(I);
            V_FROM_SITE       := V_TOK_FROM_SITE(I);
            V_ITEM_ID         := NULL;

            BEGIN
                SELECT ITEM_ID
                  INTO V_ITEM_ID
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_MAIN_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_ITEM_ID := NULL;
            END;

            BEGIN
                SELECT USER_ID
                  INTO V_MODEL_PIC
                  FROM SSP_MST_MODEL_USER
                 WHERE ITEM_ID   = V_ITEM_ID
                   AND FROM_SITE = V_FROM_SITE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_MODEL_PIC := NULL;
                WHEN TOO_MANY_ROWS THEN
                    V_MODEL_PIC := NULL;
            END;

            V_MODEL_PIC_TEMP := V_MODEL_PIC;
            V_ITEM_ID_TEMP   := V_ITEM_ID;

            IF V_MODEL_PIC_TEMP <> V_MODEL_PIC_TEMP2 THEN
                RAISE_APPLICATION_ERROR(-20001, 'UnModelPic');                      /* ERROR 발생 시켜 UI에서 사용함 */
            END IF;

            IF V_ITEM_ID_TEMP <> V_ITEM_ID_TEMP2 THEN
                RAISE_APPLICATION_ERROR(-20001, 'UnModelItem');                     /* ERROR 발생 시켜 UI에서 사용함 */
            END IF;

            V_MODEL_PIC_TEMP2 := V_MODEL_PIC_TEMP;
            V_ITEM_ID_TEMP2   := V_ITEM_ID_TEMP;

            /* 자가 승인 제한 건 반영 - MY MODEL 확인 */
            SELECT V_MY_MODEL_CHK + COUNT(*)
              INTO V_MY_MODEL_CHK
              FROM SSP_MST_MODEL_USER      A
                 , SCM_MST_SSO_USER_INFO   B
                 , SCM_MST_SSO_DEPT_INFO   C
             WHERE B.USER_ID    = A.USER_ID
               AND C.DEPT_ID(+) = B.DEPT_ID
               AND A.DIVISION_ID = V_DIVISION_ID
               AND A.FROM_SITE   = V_FROM_SITE
               AND A.ITEM_ID     = V_ITEM_ID
               AND A.VALID_YN    = 'Y'
               AND A.USER_ID     = P_APPROVAL_ID;
        END LOOP;

        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP
            V_MAIN_CONFIRM_ID := V_TOK_MAIN_CONFIRM(I);
            V_DIVISION_ID     := V_TOK_DIVISION_ID(I);
            V_FROM_SITE       := V_TOK_FROM_SITE(I);
            V_CHANGE_REQ_NO   := V_TOK_CHANGE_REQ(I);

            IF P_CHANGE_TYPE = 'P' THEN
                V_CHK := 0;

                BEGIN
                    SELECT CASE WHEN ATTRIBUTE1 IS NULL THEN 0 ELSE 1 END
                      INTO V_CHK
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_MAIN_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_CHK := 0;
                END;

                IF V_CHK = 0 THEN
                    SELECT SEQ1_SSP_ANL_SHIP_CONFIRM_ID.NEXTVAL
                      INTO V_SEQ
                      FROM DUAL;

                    V_NEW_CONFIRM_ID := 'C' || TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(V_SEQ), -6);

                    UPDATE SSP_ANL_SHIP_CONFIRM
                       SET SHIPMENT_STATUS  = P_SHIP_STATUS
                         , CHANGE_REQ_NO    = V_CHANGE_REQ_NO
                         , ATTRIBUTE1       = V_NEW_CONFIRM_ID
                         , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                     WHERE CONFIRM_ID       = V_MAIN_CONFIRM_ID;
                ELSE
                    UPDATE SSP_ANL_SHIP_CONFIRM
                       SET SHIPMENT_STATUS  = P_SHIP_STATUS
                         , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                         , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                     WHERE CONFIRM_ID       = V_MAIN_CONFIRM_ID;
                END IF;
            ELSE
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET SHIPMENT_STATUS  = P_SHIP_STATUS
                     , CHANGE_REQ_NO    = V_CHANGE_REQ_NO
                     , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                 WHERE CONFIRM_ID       = V_MAIN_CONFIRM_ID;
            END IF;

            /* SSP_ANL_SHIP_CONFIRM_CHG_REQ Status Insert(hsbang, 2024.05.08) */
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
               SET ATTRIBUTE2       = P_CHANGE_STATUS
                 , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
             WHERE CHANGE_REQ_NO    = V_CHANGE_REQ_NO
               AND CONFIRM_ID       = V_MAIN_CONFIRM_ID;

            /* Shipment Request Info Insert(SSP_ANL_SHIP_CONFIRM_CHG_REQ) */
            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
               SET CHANGE_REQ_STATUS    = P_CHANGE_STATUS
                 , REQUEST_TITLE        = P_TITLE
                 , APPROVAL_USER        = P_APPROVAL_ID
                 , APPROVAL_DEPT        = P_APPROVAL_DEPT_ID
                 , CHANGE_REASON_CODE   = P_CHANGE_REASON
                 , CHANGE_REASON_DETAIL = P_REASON_DETAIL
                 , LAST_UPDATED_BY      = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE     = V_LAST_UPDATE_DATE
                 , REQUEST_TIME         = V_LAST_UPDATE_DATE
             WHERE CHANGE_REQ_NO        = V_CHANGE_REQ_NO;

            IF SQL%ROWCOUNT = 0 THEN
                INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                (
                    CHANGE_REQ_NO
                  , CHANGE_REQ_STATUS
                  , DIVISION_ID
                  , FROM_SITE
                  , REQUEST_TITLE
                  , REQUEST_USER
                  , REQUEST_DEPT
                  , REQUEST_TIME
                  , APPROVAL_USER
                  , APPROVAL_DEPT
                  , APPROVAL_TIME
                  , CHANGE_REASON_CODE
                  , CHANGE_REASON_DETAIL
                  , REJECT_REASON
                  , VALID_YN
                  , CHANGE_TYPE
                  , CREATED_BY
                  , CREATION_DATE
                  , LAST_UPDATED_BY
                  , LAST_UPDATE_DATE
                  , ELECTRODE_YN
                  , ELECTRODE_TYPE
                  , ORIGIN_FROM_DIVISION_ID
                  , ORIGIN_TO_DIVISION_ID
                )
                VALUES
                (
                    V_CHANGE_REQ_NO
                  , P_SHIP_STATUS
                  , TO_CHAR(P_DIVISION_ID)
                  , TO_CHAR(P_FROM_SITE)
                  , P_TITLE
                  , P_REQUEST_ID
                  , P_REQUEST_DEPT_ID
                  , V_LAST_UPDATE_DATE
                  , P_APPROVAL_ID
                  , P_APPROVAL_DEPT_ID
                  , NULL
                  , P_CHANGE_REASON
                  , P_REASON_DETAIL
                  , NULL
                  , 'Y'
                  , P_CHANGE_TYPE
                  , P_LAST_UPDATED_BY
                  , V_LAST_UPDATE_DATE
                  , P_LAST_UPDATED_BY
                  , V_LAST_UPDATE_DATE
                  , SUBSTR(TO_CHAR(P_ELECTRODE_YN), 1, INSTR(TO_CHAR(P_ELECTRODE_YN), C_DELIMITER) - 1)
                  , SUBSTR(TO_CHAR(P_ELECTRODE_TYPE), 1, INSTR(TO_CHAR(P_ELECTRODE_TYPE), C_DELIMITER) - 1)
                  , SUBSTR(TO_CHAR(P_ORIGIN_FROM_DIVISION_ID), 1, INSTR(TO_CHAR(P_ORIGIN_FROM_DIVISION_ID), C_DELIMITER) - 1)
                  , SUBSTR(TO_CHAR(P_ORIGION_TO_DIVISION_ID), 1, INSTR(TO_CHAR(P_ORIGION_TO_DIVISION_ID), C_DELIMITER) - 1)
                );
            END IF;
        END LOOP;

        IF P_CHANGE_STATUS = 'Q' THEN
            /* 메일 발송 */
            SCM_SSP_MAIL_SEND(V_CHANGE_REQ_NO, P_CHANGE_STATUS);
        END IF;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', V_EVENT_DATE);

        OPEN O_RC1 FOR
            SELECT 'S'             AS RESULT_CODE
                 , V_CHANGE_REQ_NO AS REQUEST_NO
              FROM DUAL;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SP_SSP0201_SAVE_COMPLETE;                                   /* 입력 데이타 롤백 처리 */

            IF SQLCODE <> -20001 THEN                                               /* 자가 승인 제한건은 ERROR 로그 처리 안함 */
                P_WRITE_ERROR_LOG(V_PROGRAM_NAME, V_ERR);
            END IF;

            OPEN O_RC1 FOR
                SELECT 'F'  AS RESULT_CODE
                     , NULL AS REQUEST_NO
                  FROM DUAL;

            P_OPEN_ERROR(V_ERR, O_RESULT_CURSOR);
    END P_SSP0201_SAVE_SHIPMENT_REQUEST_COMPLETE;

    /* ==============================================================================================
       SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING
       ============================================================================================== */
    PROCEDURE P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CONFIRM_ID        IN  CLOB,
        P_CHANGE_REQUEST_NO IN  CLOB,
        P_DEL_FLAG          IN  VARCHAR2,
        P_LAST_UPDATED_BY   IN  VARCHAR2,
        P_TIME_ZONE         IN  VARCHAR2,
        P_IF_SEND_FLAG      IN  VARCHAR2,
        P_CHANGE_TYPE       IN  VARCHAR2,
        O_RC1               OUT SYS_REFCURSOR,
        O_RESULT_CURSOR     OUT SYS_REFCURSOR
    )
    IS
    /*
     * Program ID   : SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING
     * Description  : Shipment Plan Change 작성중 삭제
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018/10/10   KIMYONGHO      최초작성
     * 2026.09.21                  [MSSQL -> Oracle 전환]
     *                             - 되돌림값은 마지막 요청 번호 기준으로 확정 원장에 남은 행이 없으면 X
     *                             - 저장 시작에 SAVEPOINT · 되돌리기는 결과 커서를 열기 전에 수행
     */
        V_PROGRAM_NAME      CONSTANT VARCHAR2(150 CHAR) := 'SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING';
        V_MAX_LOOP_CNT      PLS_INTEGER;
        V_TOK_CHANGE_REQ    T_TOKEN_TAB;
        V_TOK_CONFIRM_ID    T_TOKEN_TAB;
        V_FOUND             T_FOUND_TAB;
        V_CHANGE_REQ_NO     VARCHAR2(4000 CHAR);
        V_CONFIRM_ID        VARCHAR2(4000 CHAR);
        V_LAST_UPDATE_DATE  DATE := SYSDATE;
        V_EVENT_DATE        DATE;
        V_CNT               PLS_INTEGER := 0;
        V_ERR               VARCHAR2(4000 CHAR);
    BEGIN
        SAVEPOINT SP_SSP0201_DELETE_DRAFT;

        V_EVENT_DATE := V_LAST_UPDATE_DATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'START', 0, '########## Start of procedure ##########', '', V_EVENT_DATE);

        V_MAX_LOOP_CNT := F_SPL_CNT(P_CHANGE_REQUEST_NO);

        P_SPL_ARR(P_CHANGE_REQUEST_NO, V_MAX_LOOP_CNT, V_TOK_CHANGE_REQ, V_FOUND);
        P_SPL_ARR(P_CONFIRM_ID,        V_MAX_LOOP_CNT, V_TOK_CONFIRM_ID, V_FOUND);

        FOR I IN 1 .. V_MAX_LOOP_CNT LOOP
            V_CHANGE_REQ_NO := V_TOK_CHANGE_REQ(I);
            V_CONFIRM_ID    := V_TOK_CONFIRM_ID(I);

            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
               SET VALID_YN         = 'N'
                 , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
             WHERE CHANGE_REQ_NO    = V_CHANGE_REQ_NO;

            UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
               SET VALID_YN         = 'N'
                 , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
             WHERE CHANGE_REQ_NO    = V_CHANGE_REQ_NO;

            UPDATE SSP_ANL_SHIP_CONFIRM
               SET SHIPMENT_STATUS  = 'C'
                 , CHANGE_REQ_NO    = NULL
                 , ATTRIBUTE1       = NULL
                 , LAST_UPDATED_BY  = P_LAST_UPDATED_BY
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
             WHERE CONFIRM_ID IN (SELECT CONFIRM_ID
                                    FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                   WHERE CHANGE_REQ_NO = V_CHANGE_REQ_NO);

            DELETE FROM SSP_ANL_SHIP_CONFIRM
             WHERE CONFIRM_ID IN (SELECT CONFIRM_ID
                                    FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                   WHERE CHANGE_REQ_NO = V_CHANGE_REQ_NO)
               AND CHANGE_TYPE = 'N';

            IF P_DEL_FLAG = 'D'
           AND P_IF_SEND_FLAG = 'Y' THEN
                PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER('D', V_CHANGE_REQ_NO);   /* ★PACKER 는 인자가 둘이다 */
            END IF;
        END LOOP;

        V_EVENT_DATE := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, 'END', 0, '########## END of procedure ##########', '', V_EVENT_DATE);

        SELECT COUNT(*)
          INTO V_CNT
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE CONFIRM_ID IN (SELECT CONFIRM_ID
                                FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                               WHERE CHANGE_REQ_NO = V_CHANGE_REQ_NO);

        IF V_CNT < 1 THEN                                                           /* 데이터가 존재하지 않는경우 */
            OPEN O_RC1 FOR
                SELECT 'X' AS RESULT_CODE
                  FROM DUAL;
        ELSE
            OPEN O_RC1 FOR
                SELECT 'S' AS RESULT_CODE
                  FROM DUAL;
        END IF;

        P_OPEN_SUCCESS(O_RESULT_CURSOR);
    EXCEPTION
        WHEN OTHERS THEN
            V_ERR := SUBSTR(SQLERRM, 1, 4000);

            ROLLBACK TO SP_SSP0201_DELETE_DRAFT;

            P_WRITE_ERROR_LOG(V_PROGRAM_NAME, V_ERR);

            OPEN O_RC1 FOR
                SELECT 'F' AS RESULT_CODE
                  FROM DUAL;

            P_OPEN_ERROR(V_ERR, O_RESULT_CURSOR);
    END P_SSP0201_DELETE_SHIPMENT_REQUEST_DRAFTING;

    /* ==============================================================================================
       PR_SSP_XIF_ERP_UI_SHIP_PLAN_IFSEQ_MERGE
       ============================================================================================== */

END PKG_SSP0201;