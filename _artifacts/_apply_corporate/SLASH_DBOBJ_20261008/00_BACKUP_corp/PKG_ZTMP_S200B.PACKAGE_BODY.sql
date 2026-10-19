PACKAGE BODY PKG_ZTMP_S200B
IS
    FUNCTION FN_MKT_OWNER_FIX
(
    P_OWNER     IN VARCHAR2,
    P_DELIM     IN VARCHAR2,
    P_LANGUAGE  IN VARCHAR2
)
RETURN CLOB
IS
    /*
     * Program ID   : FN_GET_SSP_MKT_OWNER_NAME
     * Description  : PROJECT OWNER
     *
     *
     * Program History
     *===================================================================================================
     *   Date       In Charge      Description
     *===================================================================================================
     * 2018.11.01   juhlee     Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
     * 2026.03.06   jcnam          [PJ20264226] NextSCM Pilot 설계 및 개발
     * 2026.09.17   AJS            AS-IS 결과 일치 보정 (대소문자 무시 조회 · 미존재 처리 · NULL 전파 · 인덱스 조회)
     */
    V_OWNER     VARCHAR2(32767) := P_OWNER;
    V_DELIM     VARCHAR2(1)     := SUBSTR(P_DELIM, 1, 1);          /* AS-IS @p_delim VARCHAR(1) */
    /* AS-IS @p_language NVARCHAR(2) : 앞 2자만, 대소문자·뒤 공백 무시 비교 */
    V_KO_YN     VARCHAR2(1)     := CASE WHEN UPPER(RTRIM(SUBSTR(P_LANGUAGE, 1, 2))) = 'KO' THEN 'Y' ELSE 'N' END;
    V_RESTR     VARCHAR2(32767);                                   /* AS-IS @ReStr = '' */
    V_NULL_YN   VARCHAR2(1)     := 'N';                            /* AS-IS @ReStr 가 NULL 이 됨 (NULL + 문자 = NULL) */
    V_USERNAME  VARCHAR2(4000);                                    /* AS-IS @UserName (조회 실패 시 앞 값 유지) */
    V_UNAME_YN  VARCHAR2(1)     := 'N';                            /* AS-IS @UserName 이 한 번이라도 채워졌는지 */
    V_NAME      VARCHAR2(4000);
    V_CNT       PLS_INTEGER;
    V_POS       PLS_INTEGER;

    /* AS-IS : SELECT @x = USER_NAME + '(' + USER_ID + ')' FROM SCM_MST_SSO_USER_INFO WHERE USER_ID = @id (대소문자 무시) */
    PROCEDURE P_FIND(P_ID IN VARCHAR2)
    IS
    BEGIN
        SELECT MAX(CASE WHEN V_KO_YN = 'Y' THEN USER_NAME ELSE USER_NAME_EN END || '(' || USER_ID || ')')
             , COUNT(*)
          INTO V_NAME
             , V_CNT
          FROM SCM_MST_SSO_USER_INFO
         WHERE UPPER(USER_ID) = UPPER(P_ID);
    END P_FIND;

BEGIN

    V_POS := INSTR(V_OWNER, V_DELIM);

    IF V_POS <> 0 THEN

        WHILE V_POS > 0 LOOP

            P_FIND(TRIM(SUBSTR(V_OWNER, 1, V_POS - 1)));

            IF V_CNT > 0 THEN
                V_USERNAME := V_NAME;
                V_UNAME_YN := 'Y';
            END IF;

            /* AS-IS : SET @ReStr = LTRIM(RTRIM(@ReStr)) + @UserName + ',' */
            IF V_UNAME_YN = 'N' THEN
                V_NULL_YN := 'Y';
            ELSE
                V_RESTR := TRIM(V_RESTR) || V_USERNAME || ',';
            END IF;

            /* AS-IS : SUBSTRING(@p_owner, @FoundIdx + 1, LEN(@p_owner) - @FoundIdx) - LEN 은 뒤 공백 제외 */
            V_OWNER := SUBSTR(V_OWNER, V_POS + 1, LENGTH(RTRIM(V_OWNER)) - V_POS);
            V_POS   := NVL(INSTR(V_OWNER, V_DELIM), 0);

        END LOOP;

        P_FIND(TRIM(V_OWNER));

        IF V_CNT > 0 THEN
            V_RESTR := V_RESTR || V_NAME;
        END IF;

    ELSE

        P_FIND(TRIM(V_OWNER));

        IF V_CNT > 0 THEN
            V_RESTR := V_NAME;
        END IF;

    END IF;

    IF V_NULL_YN = 'Y' THEN
        RETURN NULL;
    END IF;

    RETURN TO_CLOB(V_RESTR);

END FN_MKT_OWNER_FIX;

    /* ==== P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST / SSP0200_GET_SHIPMENT_CHANGE_REQUEST ==== */
    /* ============================================================
       ※ AS-IS 는 FN_GET_IN_STR 로 IN 리스트를 만들어 EXEC 로 돌린다.
          선택조건 조립뿐이라 정적 SQL 로 옮겼다.
       ※ IN 리스트는 FN_GET_IN_STR 규칙을 그대로 옮긴 내부 함수(FN_IN_LIST)로 나눈다.
          (줄바꿈 → 쉼표, 조각 앞뒤 공백 제거, 조각 100자 절삭, 1,000조각 한도,
           AS-IS FN_SCM_SPLIT 의 「조각 번호 위치부터 구분자 탐색」 규칙 포함)
       ※ MSSQL 정렬(Latin1_General_CI_AS) : 비교는 대소문자 무시, 정렬은 대소문자·하이픈 무시
          · 밑줄은 글자·숫자보다 앞 → 조건·조인·정렬에 UPPER / TRANSLATE 반영
       ============================================================ */
    PROCEDURE P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ERP_SO_NO             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_STATUS                IN  VARCHAR2,
        P_CHANGE_TYPE           IN  VARCHAR2 DEFAULT 'C',
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_TO_SITE               IN  VARCHAR2 DEFAULT NULL,
        P_CONFIRM_ID            IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : SSP0200_GET_SHIPMENT_CHANGE_REQUEST
         * Description  : Shipment Change Request
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2021/05/25   KIMYONGHO      최초작성
         * 2021/10/18   SHINMYUNGSU	   SSP_ANL_SHIP_CONFIRM의 ERP_ATTR1~3 항목 추가
         * 2021/11/11   SHINMYUNGSU    조회조건 CONFIRM_ID 추가
         * 2024/10/01   KHJ            NERP_SSP
         * 2025/12/11   chkim.68       E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
         * 2026.09.17   AJS            MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         *
         ex) PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST('40', '', '', '', '20260801', '20260831', '', 'C', 'KO', 'F', '', '', :RC)
         */
        V_DIV_TAB       T_STR_TAB;
        V_FROM_TAB      T_STR_TAB;
        V_ITEM_TAB      T_STR_TAB;
        V_TO_TAB        T_STR_TAB;
        V_SO_TAB        T_STR_TAB;
        V_CONFIRM_TAB   T_STR_TAB;

        V_DIV_CNT       PLS_INTEGER;
        V_FROM_CNT      PLS_INTEGER;
        V_ITEM_CNT      PLS_INTEGER;
        V_TO_CNT        PLS_INTEGER;
        V_SO_CNT        PLS_INTEGER;
        V_CONFIRM_CNT   PLS_INTEGER;

        V_LANG_KO       VARCHAR2(1);
        V_OWNER_LANG    VARCHAR2(2);
        V_RUN_YN        VARCHAR2(1);

        /* AS-IS FN_GET_IN_STR 대응 : 결과 조각을 대문자로 담는다(조각 0개 = 조건 없음) */
        FUNCTION FN_IN_LIST(P_STR IN VARCHAR2) RETURN T_STR_TAB
        IS
            V_LIST      VARCHAR2(32767);
            V_TAB       T_STR_TAB := T_STR_TAB();
            V_NODE      PLS_INTEGER := 1;
            V_START     PLS_INTEGER;
            V_END       PLS_INTEGER;
        BEGIN
            /* AS-IS : IF @p_csv_text_list = '' RETURN('') - MSSQL 비교는 뒤 공백 무시 */
            IF TRIM(P_STR) IS NULL THEN
                RETURN V_TAB;
            END IF;

            V_LIST := REPLACE(REPLACE(P_STR, CHR(13), ''), CHR(10), ',');

            /* AS-IS FN_SCM_SPLIT : 빈 문자열이면 조각 없음 */
            IF V_LIST IS NULL THEN
                RETURN V_TAB;
            END IF;

            WHILE V_NODE <= 1000 LOOP
                IF V_NODE = 1 THEN
                    V_START := 1;
                ELSE
                    /* AS-IS FN_SCM_SPLIT : CHARINDEX(구분자, 문자열, 조각번호) = 0 이면 끝 */
                    EXIT WHEN INSTR(V_LIST, ',', V_NODE) = 0;
                    V_START := INSTR(V_LIST, ',', 1, V_NODE - 1);
                    EXIT WHEN V_START = 0;
                    V_START := V_START + 1;
                END IF;

                V_END := INSTR(V_LIST, ',', V_START);
                IF V_END = 0 THEN
                    V_END := LENGTH(V_LIST) + 1;
                END IF;

                /* 빈 조각은 AS-IS '' → Oracle NULL (어느 값과도 같지 않음 - AS-IS 와 결과 동일) */
                V_TAB.EXTEND;
                V_TAB(V_TAB.COUNT) := UPPER(SUBSTR(TRIM(SUBSTR(V_LIST, V_START, V_END - V_START)), 1, 100));
                V_NODE := V_NODE + 1;
            END LOOP;

            RETURN V_TAB;
        END FN_IN_LIST;

    BEGIN

        /* IN 조건으로 데이터를 가져옴 */
        V_DIV_TAB     := FN_IN_LIST(P_DIVISION_ID);
        V_FROM_TAB    := FN_IN_LIST(P_FROM_SITE);
        V_ITEM_TAB    := FN_IN_LIST(P_ITEM_ID);
        V_TO_TAB      := FN_IN_LIST(P_TO_SITE);
        V_SO_TAB      := FN_IN_LIST(P_ERP_SO_NO);
        /* 20211111 SHINMYUNGSU  추가 */
        V_CONFIRM_TAB := FN_IN_LIST(P_CONFIRM_ID);

        V_DIV_CNT     := V_DIV_TAB.COUNT;
        V_FROM_CNT    := V_FROM_TAB.COUNT;
        V_ITEM_CNT    := V_ITEM_TAB.COUNT;
        V_TO_CNT      := V_TO_TAB.COUNT;
        V_SO_CNT      := V_SO_TAB.COUNT;
        V_CONFIRM_CNT := V_CONFIRM_TAB.COUNT;

        /* AS-IS : CASE WHEN '<@p_language>' = 'KO' (대소문자·뒤 공백 무시) */
        V_LANG_KO    := CASE WHEN UPPER(RTRIM(P_LANGUAGE)) = 'KO' THEN 'Y' ELSE 'N' END;
        /* AS-IS FN_GET_SSP_MKT_OWNER_NAME 의 @p_language 는 NVARCHAR(2) - 앞 2자만, 대소문자 무시 */
        V_OWNER_LANG := UPPER(SUBSTR(P_LANGUAGE, 1, 2));
        /* AS-IS : 기간이 NULL 이면 조립 문장 전체가 NULL 이 되어 결과 없음 */
        V_RUN_YN     := CASE WHEN P_FROM_YYYYMMDD IS NULL OR P_TO_YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END;

        OPEN O_RC1 FOR
        SELECT AA.*
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
                     , ROUND(A.QTY, 3)                   AS SHIPMENT_CONFIRM_QTY    /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     , A.REMARKS
                     , A.REMARKS2
                     , A.REMARKS3
                     , A.FROM_SITE
                     , SMF.OPERATION_GROUP                                          /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                     , A.TO_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                     , A.TO_SITE_SOLDTO_CODE
                     , A.TO_SITE_SHIPTO_CODE
                     , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                     , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                     , A.BOD_ID
                     , B.SSP_INCOTERMS                   AS INCOTERMS
                     , B.TRANSPORT_MODE
                     , B.LT_TOTAL                        AS LT_DAY
                     , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                     , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                            ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')
                       END                               AS "Expected_Shipping_Date"
                     , A.CONFIRM_ID
                       /* AS-IS : 이름 + '(' + ID + ')' - 어느 한쪽이 NULL 이면 NULL */
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USERNAME ELSE U.USERNAME_E END) IS NOT NULL
                     , CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NOT NULL
                     /* 2026.09.30 AJS 수정 (END) */
                             AND A.LAST_UPDATED_BY IS NOT NULL
                            /* 2026.09.30 AJS 수정 (START) */
                          --THEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                            THEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                            /* 2026.09.30 AJS 수정 (END) */
                       END                               AS UPDATED_BY
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN U.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                     , CASE WHEN U.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                     /* 2026.09.30 AJS 수정 (END) */
                     , A.ERP_STATUS
                     , A.CHANGE_TYPE
                     , A.ROUTE_ID                        AS NEW_ROUTE_ID
                     , A.BOD_ID                          AS NEW_BOD_ID
                     , B.SSP_INCOTERMS                   AS NEW_INCOTERMS
                     , A.D_COUNTRY                       AS NEW_D_COUNTRY
                     , A.D_PORT_CODE                     AS NEW_D_PORT_CODE
                     , A.A_COUNTRY                       AS NEW_A_COUNTRY
                     , A.A_PORT_CODE                     AS NEW_A_PORT_CODE
                     , A.CUSTOMER_LT                     AS NEW_CUSTOMER_LT
                     , A.TO_COUNTRY                      AS NEW_TO_COUNTRY
                     , A.TO_CITY                         AS NEW_TO_CITY
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                     , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                     , B.LT_TOTAL                        AS NEW_LT_DAY
                     , B.TRANSPORT_MODE                  AS NEW_TRANSPORT_MODE
                     , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_SHIPMENT_DATE
                     , 'N'                               AS EDIT_REMARKS
                     , 'N'                               AS EDIT_MAIN
                     , NVL(A.CHECK_NEED_YN, 'N')         AS CHECK_NEED_YN
                     , NVL(CASE WHEN A.DIVISION_ID = '40'
                                THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE != '-'
                                          THEN A.PROJECT_CODE ELSE G.PROJECT_CODE END
                                WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                                THEN G.PROJECT_CODE
                                ELSE F.END_CUSTOMER END, '-') AS END_CUSTOMER
                     , A.ELECTRODE_YN
                     , A.ELECTRODE_TYPE
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , H.CHANGE_REQ_NO
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NOT NULL
                     , CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NOT NULL
                     /* 2026.09.30 AJS 수정 (END) */
                             AND MU.USER_ID IS NOT NULL
                            /* 2026.09.30 AJS 수정 (START) */
                          --THEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
                            THEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
                            /* 2026.09.30 AJS 수정 (END) */
                       END                               AS MODEL_USER
                       /* 같은 담당자 반복 호출은 스칼라 서브쿼리 캐시로 줄인다 */
                     , (SELECT PKG_ZTMP_S200B.FN_MKT_OWNER_FIX(SI.OWNER, ',', V_OWNER_LANG) FROM DUAL) AS MTK_OWNER
                       /* AS-IS : a.LAST_UPDATED_BY = 'ssp_batch' (대소문자·뒤 공백 무시) */
                     , CASE WHEN UPPER(RTRIM(A.LAST_UPDATED_BY)) = 'SSP_BATCH' THEN 'System'
                            /* 2026.09.30 AJS 수정 (START) */
                          --WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USERNAME ELSE U3.USERNAME_E END) IS NOT NULL
                            WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) IS NOT NULL
                            /* 2026.09.30 AJS 수정 (END) */
                             AND A.LAST_UPDATED_BY IS NOT NULL
                            /* 2026.09.30 AJS 수정 (START) */
                          --THEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USERNAME ELSE U3.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                            THEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                            /* 2026.09.30 AJS 수정 (END) */
                       END                               AS REQUESTOR
                     , '-'                               AS CHANGE_REASON_CODE
                     , ''                                AS CHANGE_REASON_DETAIL
                     , A.ATTRIBUTE10
                     , A.LAST_UPDATE_DATE                AS REQUEST_DATE
                       /**** 20211018   SHINMYUNGSU   열람항목추가   ******************************************************/
                     , A.ERP_ATTR1
                     , A.ERP_ATTR2
                     , A.ERP_ATTR3
                       /***********************************************************************************/
                  FROM SSP_ANL_SHIP_CONFIRM A
                     , SCM_MST_ITEM_SN T                /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     , SCM_MST_SITE MS
                     , SCP_MST_BOD_N_V B
                     /* 2026.09.30 AJS 수정 (START) */
                   --, TB_FX_USER U
                     , SCM_ADM_USER_M U
                     /* 2026.09.30 AJS 수정 (END) */
                     , SCM_MST_SITE F
                     , (SELECT XA.DIVISION_ID
                             , XA.PROJECT_CODE
                             , XA.SCM_SITE_ID
                             , XA.ITEM_ID_U
                          FROM (SELECT DIVISION_ID
                                     , PROJECT_CODE
                                     , SCM_SITE_ID
                                     , UPPER(ITEM_ID) AS ITEM_ID_U
                                       /* AS-IS 정렬 규칙(대소문자·하이픈 무시)으로 첫 PROJECT_CODE */
                                     , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, UPPER(ITEM_ID)
                                                              ORDER BY UPPER(TRANSLATE(PROJECT_CODE, '_-', '/')) NULLS FIRST
                                                                     , PROJECT_CODE NULLS FIRST) AS NUM
                                  FROM SCM_MST_SITE_ITEM) XA
                         WHERE XA.NUM = 1) G
                     , (SELECT IA.CONFIRM_ID
                             , IA.CHANGE_REQ_NO
                          FROM (SELECT CONFIRM_ID
                                     , CHANGE_REQ_NO
                                     , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC NULLS LAST) AS NUM
                                  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                 WHERE VALID_YN = 'Y') IA
                         WHERE IA.NUM = 1) H
                     , SSP_MST_MODEL_USER MU
                     /* 2026.09.30 AJS 수정 (START) */
                   --, TB_FX_USER U2
                   --, TB_FX_USER U3
                     , SCM_ADM_USER_M U2
                     , SCM_ADM_USER_M U3
                     /* 2026.09.30 AJS 수정 (END) */
                     , SCM_MST_SITE_ITEM SI
                     , SSP_ANL_SHIP_CONFIRM_CHG_REQ T1
                     , SCP_MST_FINAL_ITEM_V SMF         /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     /* NERP 적용시 GERP COMPANY_ID에 해당하는 것은 제외 필요함 */
                 WHERE UPPER(A.ITEM_ID)       = UPPER(T.ITEM_ID)      /* MSSQL 대소문자 무시 조인 */
                   AND A.DIVISION_ID          = T.DIVISION_ID
                   AND A.FROM_SITE_COMPANY_ID = T.COMPANY_ID
                   AND A.DIVISION_ID          = MS.DIVISION_ID
                   AND A.FROM_SITE            = MS.SCM_SITE_ID
                   AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END = B.DIVISION_ID
                   AND A.BOD_ID               = B.BOD_ID
                   /* 2026.09.30 AJS 수정 (START) */
                 --AND A.LAST_UPDATED_BY      = U.USERID(+)
                 --AND U.USEYN(+)             = 'Y'
                   AND A.LAST_UPDATED_BY      = U.USER_ID(+)
                   AND U.USE_YN(+)             = 'Y'
                   /* 2026.09.30 AJS 수정 (END) */
                   AND A.ORIGIN_TO_DIVISION_ID = F.DIVISION_ID(+)
                   AND A.TO_SITE              = F.SCM_SITE_ID(+)
                   AND F.VALID_YN(+)          = 'Y'
                   AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END = G.DIVISION_ID(+)
                   AND A.TO_SITE              = G.SCM_SITE_ID(+)
                   AND UPPER(A.ITEM_ID)       = G.ITEM_ID_U(+)
                   AND A.CONFIRM_ID           = H.CONFIRM_ID(+)
                   AND A.ORIGIN_FROM_DIVISION_ID = MU.DIVISION_ID(+)
                   AND A.FROM_SITE            = MU.FROM_SITE(+)
                   AND UPPER(A.ITEM_ID)       = UPPER(MU.ITEM_ID(+))
                   AND MU.VALID_YN(+)         = 'Y'
                   /* 2026.09.30 AJS 수정 (START) */
                 --AND MU.USER_ID             = U2.USERID(+)
                 --AND U2.USEYN(+)            = 'Y'
                 --AND A.LAST_UPDATED_BY      = U3.USERID(+)
                 --AND U3.USEYN(+)            = 'Y'
                   AND MU.USER_ID             = U2.USER_ID(+)
                   AND U2.USE_YN(+)            = 'Y'
                   AND A.LAST_UPDATED_BY      = U3.USER_ID(+)
                   AND U3.USE_YN(+)            = 'Y'
                   /* 2026.09.30 AJS 수정 (END) */
                   AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END = SI.DIVISION_ID(+)
                   AND A.TO_SITE              = SI.SCM_SITE_ID(+)
                   AND UPPER(A.ITEM_ID)       = UPPER(SI.ITEM_ID(+))
                   AND UPPER(A.PROJECT_CODE)  = UPPER(SI.PROJECT_CODE(+))
                   AND H.CHANGE_REQ_NO        = T1.CHANGE_REQ_NO(+)
                   AND UPPER(A.ITEM_ID)       = UPPER(SMF.ITEM_ID(+))
                   /* --SET @mDqry = @mDQry + '		   AND T.ITEM_TYPE		NOT IN (''Q'',''R'')			 ' + char(10); */
                   AND T.ITEM_TYPE            <> 'R'                  /* 2025-05-15 'Q'인 경우도 화면에서 조회되어야 함 */
                   AND MS.SITE_TYPE           = 'PLANT'
                   AND A.SHIPMENT_STATUS IS NOT NULL                  /* AS-IS : shipment_status IS NOT NULL AND isnull(shipment_status,'') != '' */
                   AND A.QTY > 0
                   /* --SET @mDqry = @mDQry + ' 		  AND A.ATTRIBUTE10 <> N''I'' '+char(10); */
                   AND A.CHANGE_TYPE          <> 'N'
                   AND A.CONFIRM_ID LIKE 'C%'
                   AND V_RUN_YN               = 'Y'
                   AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD            <= P_TO_YYYYMMDD
                   AND (V_DIV_CNT = 0
                        OR A.DIVISION_ID IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_DIV_TAB) SA))
                   AND (V_ITEM_CNT = 0
                        OR UPPER(A.ITEM_ID) IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_ITEM_TAB) SA))
                   AND (V_FROM_CNT = 0
                        OR A.FROM_SITE IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_FROM_TAB) SA))
                   AND (V_TO_CNT = 0
                        OR UPPER(A.TO_SITE) IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_TO_TAB) SA))
                   AND (V_SO_CNT = 0
                        OR A.ERP_SO_NO IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_SO_TAB) SA))
                   /* 20211111 SHINMYUNGSU  추가   CONFIRM_ID 조회조건 추가 */
                   AND (V_CONFIRM_CNT = 0
                        OR A.CONFIRM_ID IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_CONFIRM_TAB) SA))
                   /* --SET @mDqry = @mDQry + ' 	  AND a.CHANGE_TYPE = ''' + @p_change_type + '''	 ' + char(10); */
                   /* --SET @mDqry = @mDQry + ' 		  AND a.biz_type <> ''E''  '+char(10); */
               ) AA
         /* AS-IS 정렬 규칙(Latin1_General_CI_AS : 대소문자·하이픈 무시, 밑줄은 글자·숫자보다 앞) */
         ORDER BY UPPER(TRANSLATE(AA.DIVISION_ID, '_-', '/')) NULLS FIRST
             , AA.DIVISION_ID NULLS FIRST
             , UPPER(AA.SHIPMENT_STATUS) NULLS FIRST
             , AA.SHIPMENT_DATE NULLS FIRST
             , UPPER(TRANSLATE(AA.ITEM_ID, '_-', '/')) NULLS FIRST
             , AA.ITEM_ID NULLS FIRST
             , UPPER(TRANSLATE(AA.ERP_SO_NO, '_-', '/')) DESC NULLS LAST
             , AA.ERP_SO_NO DESC NULLS LAST
             , UPPER(TRANSLATE(AA.FROM_SITE, '_-', '/')) NULLS FIRST
             , AA.FROM_SITE NULLS FIRST
             , UPPER(TRANSLATE(AA.TO_SITE, '_-', '/')) NULLS FIRST
             , AA.TO_SITE NULLS FIRST
             , UPPER(TRANSLATE(AA.PROJECT_CODE, '_-', '/')) NULLS FIRST
             , AA.PROJECT_CODE NULLS FIRST
             , UPPER(TRANSLATE(AA.FCST_TYPE, '_-', '/')) NULLS FIRST
             , AA.FCST_TYPE NULLS FIRST;

    END P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST;

    /* ==== P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N / SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N ==== */
    /* ============================================================
       ※ AS-IS 는 FN_GET_IN_STR 로 IN 리스트를 만들어 EXEC 로 돌린다.
          선택조건 조립뿐이라 정적 SQL 로 옮겼다.
       ※ IN 리스트는 FN_GET_IN_STR 규칙을 그대로 옮긴 내부 함수(FN_IN_LIST)로 나눈다.
       ※ MSSQL 정렬(Latin1_General_CI_AS) : 비교는 대소문자 무시, 정렬은 대소문자·하이픈 무시
          · 밑줄은 글자·숫자보다 앞 → 조건·조인·정렬에 UPPER / TRANSLATE 반영
       ※ P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST 와의 차이(AS-IS 원문 그대로)
          · SCM_MST_ITEM_SN 조인 · SCP_MST_FINAL_ITEM_V 조인 · OPERATION_GROUP · REQUEST_DATE 칸 없음
          · REQUESTOR = A.REQUESTOR 의 사용자명(ssp_batch → System 치환 없음)
          · 조건 : CHANGE_TYPE = 'N' AND SHIPMENT_STATUS = 'C'
          · 사업부 외 선택조건(ITEM · FROM SITE · TO SITE · SO NO)은 AS-IS 에서 적용하지 않음
          · P_CONFIRM_ID 인자 없음
       ============================================================ */
    PROCEDURE P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ERP_SO_NO             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_STATUS                IN  VARCHAR2,
        P_CHANGE_TYPE           IN  VARCHAR2 DEFAULT 'C',
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_TO_SITE               IN  VARCHAR2 DEFAULT NULL,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N
         * Description  : Shipment Change Request
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2021/05/25   KIMYONGHO      최초작성
         * 2021/10/18   SHINMYUNGSU	   SSP_ANL_SHIP_CONFIRM의 ERP_ATTR1~3 항목 추가
         * 2025/12/11   chkim.68        E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능
         * 2026.09.17   AJS            MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         *
         ex) PKG_SSP0200.P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N('40', '', '', '', '20260801', '20260831', '', 'C', 'KO', 'F', '', :RC)
         */
        V_DIV_TAB       T_STR_TAB;
        V_DIV_CNT       PLS_INTEGER;

        V_LANG_KO       VARCHAR2(1);
        V_OWNER_LANG    VARCHAR2(2);
        V_RUN_YN        VARCHAR2(1);

        /* AS-IS FN_GET_IN_STR 대응 : 결과 조각을 대문자로 담는다(조각 0개 = 조건 없음) */
        FUNCTION FN_IN_LIST(P_STR IN VARCHAR2) RETURN T_STR_TAB
        IS
            V_LIST      VARCHAR2(32767);
            V_TAB       T_STR_TAB := T_STR_TAB();
            V_NODE      PLS_INTEGER := 1;
            V_START     PLS_INTEGER;
            V_END       PLS_INTEGER;
        BEGIN
            /* AS-IS : IF @p_csv_text_list = '' RETURN('') - MSSQL 비교는 뒤 공백 무시 */
            IF TRIM(P_STR) IS NULL THEN
                RETURN V_TAB;
            END IF;

            V_LIST := REPLACE(REPLACE(P_STR, CHR(13), ''), CHR(10), ',');

            /* AS-IS FN_SCM_SPLIT : 빈 문자열이면 조각 없음 */
            IF V_LIST IS NULL THEN
                RETURN V_TAB;
            END IF;

            WHILE V_NODE <= 1000 LOOP
                IF V_NODE = 1 THEN
                    V_START := 1;
                ELSE
                    /* AS-IS FN_SCM_SPLIT : CHARINDEX(구분자, 문자열, 조각번호) = 0 이면 끝 */
                    EXIT WHEN INSTR(V_LIST, ',', V_NODE) = 0;
                    V_START := INSTR(V_LIST, ',', 1, V_NODE - 1);
                    EXIT WHEN V_START = 0;
                    V_START := V_START + 1;
                END IF;

                V_END := INSTR(V_LIST, ',', V_START);
                IF V_END = 0 THEN
                    V_END := LENGTH(V_LIST) + 1;
                END IF;

                /* 빈 조각은 AS-IS '' → Oracle NULL (어느 값과도 같지 않음 - AS-IS 와 결과 동일) */
                V_TAB.EXTEND;
                V_TAB(V_TAB.COUNT) := UPPER(SUBSTR(TRIM(SUBSTR(V_LIST, V_START, V_END - V_START)), 1, 100));
                V_NODE := V_NODE + 1;
            END LOOP;

            RETURN V_TAB;
        END FN_IN_LIST;

    BEGIN

        /* IN 조건으로 데이터를 가져옴 (AS-IS 는 FROM SITE · ITEM · TO SITE · SO NO 목록도 만들지만 조건에 쓰지 않는다) */
        V_DIV_TAB    := FN_IN_LIST(P_DIVISION_ID);
        V_DIV_CNT    := V_DIV_TAB.COUNT;

        /* AS-IS : CASE WHEN '<@p_language>' = 'KO' (대소문자·뒤 공백 무시) */
        V_LANG_KO    := CASE WHEN UPPER(RTRIM(P_LANGUAGE)) = 'KO' THEN 'Y' ELSE 'N' END;
        /* AS-IS FN_GET_SSP_MKT_OWNER_NAME 의 @p_language 는 NVARCHAR(2) - 앞 2자만, 대소문자 무시 */
        V_OWNER_LANG := UPPER(SUBSTR(P_LANGUAGE, 1, 2));
        /* AS-IS : 기간이 NULL 이면 조립 문장 전체가 NULL 이 되어 결과 없음 */
        V_RUN_YN     := CASE WHEN P_FROM_YYYYMMDD IS NULL OR P_TO_YYYYMMDD IS NULL THEN 'N' ELSE 'Y' END;

        OPEN O_RC1 FOR
        SELECT AA.*
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
                     , ROUND(A.QTY, 3)                   AS SHIPMENT_CONFIRM_QTY    /* E20250922-000093 SSP시스템의 전극출하를 위한 출하계획 소수점 입력 기능 */
                     , A.REMARKS
                     , A.REMARKS2
                     , A.REMARKS3
                     , A.FROM_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                     , A.TO_SITE
                     , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                     , A.TO_SITE_SOLDTO_CODE
                     , A.TO_SITE_SHIPTO_CODE
                     , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                     , FN_GET_SITE_CUSTOMER_INFO(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                     , A.BOD_ID
                     , B.SSP_INCOTERMS                   AS INCOTERMS
                     , B.TRANSPORT_MODE
                     , B.LT_TOTAL                        AS LT_DAY
                     , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETD
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS ETA
                     , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                            ELSE TO_CHAR(TO_DATE(FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD), 'YYYYMMDD'), 'YYYY-MM-DD')
                       END                               AS "Expected_Shipping_Date"
                     , A.CONFIRM_ID
                       /* AS-IS : 이름 + '(' + ID + ')' - 어느 한쪽이 NULL 이면 NULL */
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USERNAME ELSE U.USERNAME_E END) IS NOT NULL
                     , CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NOT NULL
                     /* 2026.09.30 AJS 수정 (END) */
                             AND A.LAST_UPDATED_BY IS NOT NULL
                            /* 2026.09.30 AJS 수정 (START) */
                          --THEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                            THEN (CASE WHEN V_LANG_KO = 'Y' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                            /* 2026.09.30 AJS 수정 (END) */
                       END                               AS UPDATED_BY
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN U.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                     , CASE WHEN U.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                     /* 2026.09.30 AJS 수정 (END) */
                     , A.ERP_STATUS
                     , A.CHANGE_TYPE
                     , A.ROUTE_ID                        AS NEW_ROUTE_ID
                     , A.BOD_ID                          AS NEW_BOD_ID
                     , B.SSP_INCOTERMS                   AS NEW_INCOTERMS
                     , A.D_COUNTRY                       AS NEW_D_COUNTRY
                     , A.D_PORT_CODE                     AS NEW_D_PORT_CODE
                     , A.A_COUNTRY                       AS NEW_A_COUNTRY
                     , A.A_PORT_CODE                     AS NEW_A_PORT_CODE
                     , A.CUSTOMER_LT                     AS NEW_CUSTOMER_LT
                     , A.TO_COUNTRY                      AS NEW_TO_COUNTRY
                     , A.TO_CITY                         AS NEW_TO_CITY
                     , TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETA
                     , TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_ETD
                     , B.LT_TOTAL                        AS NEW_LT_DAY
                     , B.TRANSPORT_MODE                  AS NEW_TRANSPORT_MODE
                     , TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') AS NEW_SHIPMENT_DATE
                     , 'N'                               AS EDIT_REMARKS
                     , 'N'                               AS EDIT_MAIN
                     , NVL(A.CHECK_NEED_YN, 'N')         AS CHECK_NEED_YN
                     , NVL(CASE WHEN A.DIVISION_ID = '40'
                                THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE != '-'
                                          THEN A.PROJECT_CODE ELSE G.PROJECT_CODE END
                                WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                                THEN G.PROJECT_CODE
                                ELSE F.END_CUSTOMER END, '-') AS END_CUSTOMER
                     , A.ELECTRODE_YN
                     , A.ELECTRODE_TYPE
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , H.CHANGE_REQ_NO
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NOT NULL
                     , CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NOT NULL
                     /* 2026.09.30 AJS 수정 (END) */
                             AND MU.USER_ID IS NOT NULL
                            /* 2026.09.30 AJS 수정 (START) */
                          --THEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
                            THEN (CASE WHEN V_LANG_KO = 'Y' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
                            /* 2026.09.30 AJS 수정 (END) */
                       END                               AS MODEL_USER
                       /* 같은 담당자 반복 호출은 스칼라 서브쿼리 캐시로 줄인다 */
                     , (SELECT PKG_ZTMP_S200B.FN_MKT_OWNER_FIX(SI.OWNER, ',', V_OWNER_LANG) FROM DUAL) AS MTK_OWNER
                     /* 2026.09.30 AJS 수정 (START) */
                   --, CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USERNAME ELSE U3.USERNAME_E END) IS NOT NULL
                     , CASE WHEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) IS NOT NULL
                     /* 2026.09.30 AJS 수정 (END) */
                             AND A.REQUESTOR IS NOT NULL
                            /* 2026.09.30 AJS 수정 (START) */
                          --THEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USERNAME ELSE U3.USERNAME_E END) || '(' || A.REQUESTOR || ')'
                            THEN (CASE WHEN V_LANG_KO = 'Y' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) || '(' || A.REQUESTOR || ')'
                            /* 2026.09.30 AJS 수정 (END) */
                       END                               AS REQUESTOR
                     , '-'                               AS CHANGE_REASON_CODE
                     , ''                                AS CHANGE_REASON_DETAIL
                     , A.ATTRIBUTE10
                       /**** 20211018   SHINMYUNGSU   열람항목추가   ******************************************************/
                     , A.ERP_ATTR1
                     , A.ERP_ATTR2
                     , A.ERP_ATTR3
                       /***********************************************************************************/
                  FROM SSP_ANL_SHIP_CONFIRM A
                     , SCM_MST_SITE MS
                     , SCP_MST_BOD_N_V B
                     /* 2026.09.30 AJS 수정 (START) */
                   --, TB_FX_USER U
                     , SCM_ADM_USER_M U
                     /* 2026.09.30 AJS 수정 (END) */
                     , SCM_MST_SITE F
                     , (SELECT XA.DIVISION_ID
                             , XA.PROJECT_CODE
                             , XA.SCM_SITE_ID
                             , XA.ITEM_ID_U
                          FROM (SELECT DIVISION_ID
                                     , PROJECT_CODE
                                     , SCM_SITE_ID
                                     , UPPER(ITEM_ID) AS ITEM_ID_U
                                       /* AS-IS 정렬 규칙(대소문자·하이픈 무시)으로 첫 PROJECT_CODE */
                                     , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, UPPER(ITEM_ID)
                                                              ORDER BY UPPER(TRANSLATE(PROJECT_CODE, '_-', '/')) NULLS FIRST
                                                                     , PROJECT_CODE NULLS FIRST) AS NUM
                                  FROM SCM_MST_SITE_ITEM) XA
                         WHERE XA.NUM = 1) G
                     , (SELECT IA.CONFIRM_ID
                             , IA.CHANGE_REQ_NO
                          FROM (SELECT CONFIRM_ID
                                     , CHANGE_REQ_NO
                                     , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC NULLS LAST) AS NUM
                                  FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                 WHERE VALID_YN = 'Y') IA
                         WHERE IA.NUM = 1) H
                     , SSP_MST_MODEL_USER MU
                     /* 2026.09.30 AJS 수정 (START) */
                   --, TB_FX_USER U2
                   --, TB_FX_USER U3
                     , SCM_ADM_USER_M U2
                     , SCM_ADM_USER_M U3
                     /* 2026.09.30 AJS 수정 (END) */
                     , SCM_MST_SITE_ITEM SI
                     , SSP_ANL_SHIP_CONFIRM_CHG_REQ T1
                     /* NERP 적용시 GERP COMPANY_ID에 해당하는 것은 제외 필요함 */
                 WHERE A.DIVISION_ID          = MS.DIVISION_ID
                   AND A.FROM_SITE            = MS.SCM_SITE_ID
                   AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END = B.DIVISION_ID
                   AND A.BOD_ID               = B.BOD_ID
                   /* 2026.09.30 AJS 수정 (START) */
                 --AND A.LAST_UPDATED_BY      = U.USERID(+)
                 --AND U.USEYN(+)             = 'Y'
                   AND A.LAST_UPDATED_BY      = U.USER_ID(+)
                   AND U.USE_YN(+)             = 'Y'
                   /* 2026.09.30 AJS 수정 (END) */
                   AND A.ORIGIN_TO_DIVISION_ID = F.DIVISION_ID(+)
                   AND A.TO_SITE              = F.SCM_SITE_ID(+)
                   AND F.VALID_YN(+)          = 'Y'
                   AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END = G.DIVISION_ID(+)
                   AND A.TO_SITE              = G.SCM_SITE_ID(+)
                   AND UPPER(A.ITEM_ID)       = G.ITEM_ID_U(+)
                   AND A.CONFIRM_ID           = H.CONFIRM_ID(+)
                   AND A.ORIGIN_FROM_DIVISION_ID = MU.DIVISION_ID(+)
                   AND A.FROM_SITE            = MU.FROM_SITE(+)
                   AND UPPER(A.ITEM_ID)       = UPPER(MU.ITEM_ID(+))
                   AND MU.VALID_YN(+)         = 'Y'
                   /* 2026.09.30 AJS 수정 (START) */
                 --AND MU.USER_ID             = U2.USERID(+)
                 --AND U2.USEYN(+)            = 'Y'
                 --AND A.REQUESTOR            = U3.USERID(+)
                 --AND U3.USEYN(+)            = 'Y'
                   AND MU.USER_ID             = U2.USER_ID(+)
                   AND U2.USE_YN(+)            = 'Y'
                   AND A.REQUESTOR            = U3.USER_ID(+)
                   AND U3.USE_YN(+)            = 'Y'
                   /* 2026.09.30 AJS 수정 (END) */
                   AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END = SI.DIVISION_ID(+)
                   AND A.TO_SITE              = SI.SCM_SITE_ID(+)
                   AND UPPER(A.ITEM_ID)       = UPPER(SI.ITEM_ID(+))
                   AND UPPER(A.PROJECT_CODE)  = UPPER(SI.PROJECT_CODE(+))
                   AND H.CHANGE_REQ_NO        = T1.CHANGE_REQ_NO(+)
                   AND MS.SITE_TYPE           = 'PLANT'
                   AND A.SHIPMENT_STATUS IS NOT NULL                  /* AS-IS : shipment_status IS NOT NULL AND isnull(shipment_status,'') != '' */
                   AND A.QTY > 0
                   AND A.CHANGE_TYPE          = 'N'
                   AND A.SHIPMENT_STATUS      = 'C'
                   AND A.CONFIRM_ID LIKE 'C%'
                   /* --SET @mDqry = @mDQry + ' 	  AND a.CHANGE_TYPE = ''' + @p_change_type + '''	 ' + char(10); */
                   /* --SET @mDqry = @mDQry + ' 		  AND a.biz_type <> ''E''  '+char(10); */
                   AND V_RUN_YN               = 'Y'
                   AND A.YYYYMMDD            >= P_FROM_YYYYMMDD
                   AND A.YYYYMMDD            <= P_TO_YYYYMMDD
                   AND (V_DIV_CNT = 0
                        OR A.DIVISION_ID IN (SELECT SA.COLUMN_VALUE FROM TABLE(V_DIV_TAB) SA))
                   /* --IF ( @v_item_id     IS NOT NULL AND @v_item_id    != ''  ) SET @mDQry = @mDQry + ' 					AND  a.item_id       IN ('+ @v_item_id     +')'+char(10); */
                   /* --IF ( @v_from_site   IS NOT NULL AND @v_from_site    != '') SET @mDQry = @mDQry + ' 					AND  a.from_site     IN ('+ @v_from_site   +')'+char(10); */
               ) AA
         /* AS-IS 정렬 규칙(Latin1_General_CI_AS : 대소문자·하이픈 무시, 밑줄은 글자·숫자보다 앞) */
         ORDER BY UPPER(TRANSLATE(AA.DIVISION_ID, '_-', '/')) NULLS FIRST
             , AA.DIVISION_ID NULLS FIRST
             , UPPER(AA.SHIPMENT_STATUS) NULLS FIRST
             , AA.SHIPMENT_DATE NULLS FIRST
             , UPPER(TRANSLATE(AA.ITEM_ID, '_-', '/')) NULLS FIRST
             , AA.ITEM_ID NULLS FIRST
             , UPPER(TRANSLATE(AA.ERP_SO_NO, '_-', '/')) DESC NULLS LAST
             , AA.ERP_SO_NO DESC NULLS LAST
             , UPPER(TRANSLATE(AA.FROM_SITE, '_-', '/')) NULLS FIRST
             , AA.FROM_SITE NULLS FIRST
             , UPPER(TRANSLATE(AA.TO_SITE, '_-', '/')) NULLS FIRST
             , AA.TO_SITE NULLS FIRST
             , UPPER(TRANSLATE(AA.PROJECT_CODE, '_-', '/')) NULLS FIRST
             , AA.PROJECT_CODE NULLS FIRST
             , UPPER(TRANSLATE(AA.FCST_TYPE, '_-', '/')) NULLS FIRST
             , AA.FCST_TYPE NULLS FIRST;

    END P_SSP0200_GET_SHIPMENT_CHANGE_REQUEST_N;

END PKG_ZTMP_S200B;