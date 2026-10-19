PACKAGE BODY PKG_SSP0015
IS

    /* ============================================================
       P_SSP0015_GET_ERP_SO_NO_CNT
       AS-IS SSP0015_GET_ERP_SO_NO_CNT
       ============================================================ */
    PROCEDURE P_SSP0015_GET_ERP_SO_NO_CNT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_ERP_SO_NO             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_ERP_SO_NO_CNT
         * Description  : Shipment Change Request
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
         * 2024/06/04   jilee          UI 수량 표기 안되는 정보에 대한 제외 처리
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
    BEGIN

        OPEN O_RC1 FOR
        SELECT COUNT(*) AS CNT
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE DIVISION_ID = P_DIVISION_ID
           AND ERP_SO_NO   = P_ERP_SO_NO
           AND QTY        <> 0;

    END P_SSP0015_GET_ERP_SO_NO_CNT;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_STATUS
       AS-IS SSP0015_GET_SHIPMENT_STATUS - 결과셋 3벌
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_STATUS
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_STATUS
         * Description  : Shipment Change Request
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2018/10/12   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
         * 2020/07/15   khj79          ERP_STATUS 가 'C' 인 경우 수정 못하도록 추가
         * 2026.09.16   AJS            MSSQL -> Oracle 전환 (String_Split -> FN_STRING_SPLIT)
         * 2026.10.06   AJS            조회 속도 개선 : 확정 ID 목록으로 기본키 조회(분리 함수 건수 추정으로 확정 원장 전체 읽기 3회 반복 제거)
         *
         ex) EXEC PKG_SSP0015.P_SSP0015_GET_SHIPMENT_STATUS('40^40', 'C20181001068349^C20181005074232', ...)
         */
    BEGIN

        OPEN O_RC1 FOR
--      SELECT CONFIRM_ID   --  2026.10.06 AJS
        SELECT /*+ INDEX(SSP_ANL_SHIP_CONFIRM PK_SSP_ANL_SHIP_CONFIRM) */ CONFIRM_ID   /* 확정 ID 기본키 조회 */   --  2026.10.06 AJS
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE 1 = 1
           AND DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, '^')))
           AND CONFIRM_ID  IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))
           AND SHIPMENT_STATUS != 'C';

        OPEN O_RC2 FOR
--      SELECT CONFIRM_ID   --  2026.10.06 AJS
        SELECT /*+ INDEX(SSP_ANL_SHIP_CONFIRM PK_SSP_ANL_SHIP_CONFIRM) */ CONFIRM_ID   /* 확정 ID 기본키 조회 */   --  2026.10.06 AJS
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE 1 = 1
           AND DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, '^')))
           AND CONFIRM_ID  IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))
           AND QTY = 0;

        OPEN O_RC3 FOR
--      SELECT CONFIRM_ID   --  2026.10.06 AJS
        SELECT /*+ INDEX(SSP_ANL_SHIP_CONFIRM PK_SSP_ANL_SHIP_CONFIRM) */ CONFIRM_ID   /* 확정 ID 기본키 조회 */   --  2026.10.06 AJS
          FROM SSP_ANL_SHIP_CONFIRM
         WHERE 1 = 1
           AND DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, '^')))
           AND CONFIRM_ID  IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_CONFIRM_ID, '^')))
           AND ERP_STATUS = 'C';

    END P_SSP0015_GET_SHIPMENT_STATUS;


    /* ============================================================
       P_SSP0015_GET_SCS_STOCK
       AS-IS SSP0015_GET_SCS_STOCK
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SCS_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   @ PKG_SSP0015.P_SSP0015_GET_SCS_STOCK
         * Description  @ MES Stock
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021-10-20   KIMYONGHO		신규추가
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         * 2026.10.07   AJS             조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_CUTOFF_DATE   VARCHAR2(8 CHAR);
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* AS-IS : CONVERT(CHAR(8), DATEADD(DD, -2, ...), 112) - 계획기준일 -2일 */
        V_CUTOFF_DATE := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2, 'YYYYMMDD');

        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.CUTOFF_DATE
             , A.SCM_SITE_ID                        AS PLANT_ID
             , B.SITE_DESCRIPTION                   AS PLANT_NAME
             , A.ITEM_ID                            AS MODEL_ID
             , TO_CHAR(TO_DATE(A.STOCK_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') AS PROD_DATE
             , '-'                                  AS HOLD_YN
             , A.STOCK_QTY                          AS QTY
             , A.LAST_UPDATE_DATE
          FROM SCM_DNM_SCS_STOCK A
             , SCM_MST_SITE B
             , SSP_MST_MODEL_USER M
         WHERE A.DIVISION_ID   = B.DIVISION_ID
           AND A.SCM_SITE_ID   = B.SCM_SITE_ID
           AND M.DIVISION_ID(+) = A.DIVISION_ID
           AND M.FROM_SITE(+)   = A.SCM_SITE_ID
           AND M.ITEM_ID(+)     = A.ITEM_ID
           AND M.VALID_YN(+)    = 'Y'
           AND A.DIVISION_ID   = '40'
           AND A.CUTOFF_DATE   = V_CUTOFF_DATE
           AND A.CELL_PACK     = 'P'
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                   UNION
                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                    FROM SSP_MST_DELEGATE
                                   WHERE VALID_YN = 'Y'
                                     AND DELEGATEE_ID = P_USER_ID
                                   GROUP BY USER_ID)
                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
           /* 체크박스 체크 여부 조회 끝 */
         ORDER BY A.SCM_SITE_ID
             , A.ITEM_ID;

    END P_SSP0015_GET_SCS_STOCK;


    /* ============================================================
       P_SSP0015_GET_BLOCK_STOCK
       AS-IS SSP0015_GET_BLOCK_STOCK - 결과셋 2벌(본문 · 상세)
       ※ AS-IS 는 두 결과셋의 SELECT 문이 완전히 같다. 조회조건만 P_SEARCH_YN 으로 갈린다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_BLOCK_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_SEARCH_YN             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_BLOCK_STOCK
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/03/05   AYJ 			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/06/17	AYJ				조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/28	AYJ			    조회 조건 추가(p_delegateeChk)
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         * 2026.10.07   AJS             조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_BASE_YYYYMMDD VARCHAR2(8 CHAR);
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* AS-IS : convert(varchar(8), convert(datetime, @p_plan_start_yyyymmdd) +1, 112) */
        V_BASE_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD');

        IF P_SEARCH_YN != 'Y' THEN

            /* 1. 셀 더블클릭 */
            OPEN O_RC1 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                   /* MSSQL 은 UserName 이 NULL 이면 결합 결과도 NULL 이다 - 판정을 유지한다 */
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
--                 , TB_FX_USER U
--             WHERE A.LAST_UPDATED_BY = U.USERID(+)
--               AND U.USEYN(+)        = 'Y'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 , SCM_ADM_USER_M U
                 , SSP_MST_MODEL_USER M
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)       = 'Y'
                 /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.FROM_SITE           = P_FROM_SITE
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               AND A.ITEM_ID             = P_ITEM_ID
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

            /* Block Stock Detail - AS-IS 는 위와 같은 문장이다 */
            OPEN O_RC2 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
--                 , TB_FX_USER U
--             WHERE A.LAST_UPDATED_BY = U.USERID(+)
--               AND U.USEYN(+)        = 'Y'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 , SCM_ADM_USER_M U
                 , SSP_MST_MODEL_USER M
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)       = 'Y'
                 /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.FROM_SITE           = P_FROM_SITE
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               AND A.ITEM_ID             = P_ITEM_ID
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

        ELSE

            /* 2. btnSearch */
            OPEN O_RC1 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
--                 , TB_FX_USER U
--             WHERE A.LAST_UPDATED_BY = U.USERID(+)
--               AND U.USEYN(+)        = 'Y'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 , SCM_ADM_USER_M U
                 , SSP_MST_MODEL_USER M
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)       = 'Y'
                 /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                     OR  UPPER(P_FROM_SITE) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
                     OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                     OR  UPPER(P_ITEM_ID) = 'ALL'     /* 조회조건 ALL 은 조건 없음 */
--                   OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
               /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
               AND ((P_NONCHK = 'Y' AND 1 = 1)
                     OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                       UNION
                                      SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                        FROM SSP_MST_DELEGATE
                                       WHERE VALID_YN = 'Y'
                                         AND DELEGATEE_ID = P_USER_ID
                                       GROUP BY USER_ID)
                     OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                     OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
               /* 체크박스 체크 여부 조회 끝 */
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

            OPEN O_RC2 FOR
            SELECT A.HOLD_ID
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-') AS FROM_SITE_NM
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , TO_CHAR(FN_CHAR_TO_DATE(A.HOLD_YYYYMMDD), 'YYYY-MM-DD')    AS HOLD_YYYYMMDD
                 , TO_CHAR(FN_CHAR_TO_DATE(A.RELEASE_YYYYMMDD), 'YYYY-MM-DD') AS RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
--                 , TB_FX_USER U
--             WHERE A.LAST_UPDATED_BY = U.USERID(+)
--               AND U.USEYN(+)        = 'Y'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                   END AS LAST_UPDATED_BY
                 , A.LAST_UPDATE_DATE
              FROM SSP_ANL_HOLD_STOCK A
                 , SCM_ADM_USER_M U
                 , SSP_MST_MODEL_USER M
             WHERE A.LAST_UPDATED_BY = U.USER_ID(+)
               AND U.USE_YN(+)       = 'Y'
                 /* 2026.09.30 AJS 수정 (END) */
               AND M.DIVISION_ID(+)  = A.DIVISION_ID
               AND M.FROM_SITE(+)    = A.FROM_SITE
               AND M.ITEM_ID(+)      = A.ITEM_ID
               AND M.VALID_YN(+)     = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                     OR  UPPER(P_FROM_SITE) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
                     OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
               AND A.HOLD_YYYYMMDD      <= V_BASE_YYYYMMDD
               AND A.RELEASE_YYYYMMDD   >= V_BASE_YYYYMMDD
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_SEQ
               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                     OR  UPPER(P_ITEM_ID) = 'ALL'     /* 조회조건 ALL 은 조건 없음 */
--                   OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
               AND ((P_NONCHK = 'Y' AND 1 = 1)
                     OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                       UNION
                                      SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                        FROM SSP_MST_DELEGATE
                                       WHERE VALID_YN = 'Y'
                                         AND DELEGATEE_ID = P_USER_ID
                                       GROUP BY USER_ID)
                     OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                     OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
             GROUP BY A.HOLD_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.DIVISION_ID
                 , A.FROM_SITE
                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')
                 , A.HOLD_YYYYMMDD
                 , A.RELEASE_YYYYMMDD
                 , A.HOLD_QTY
                 , A.REMARKS
                 , A.LAST_UPDATE_DATE
                 /* 2026.09.30 AJS 수정 (START) */
--                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                 /* 2026.09.30 AJS 수정 (END) */
                   END
             ORDER BY A.HOLD_ID;

        END IF;

    END P_SSP0015_GET_BLOCK_STOCK;


    /* ============================================================
       P_SSP0015_GET_WH_STOCK
       AS-IS SSP0015_GET_WH_STOCK - 결과셋 2벌(본문 · 상세)
       ============================================================ */
    PROCEDURE P_SSP0015_GET_WH_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_PLAN_SEQ              IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_WH_STOCK
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/03/05   AYJ			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/06/17	AYJ			조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/28	AYJ			조회 조건 추가(p_delegateeChk)
         * 2026.09.16   AJS         MSSQL -> Oracle 전환
         * 2026.10.07   AJS         조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        IF P_SEARCH_YN != 'Y' THEN

            /* 1. 셀 더블클릭 - W/H Stock */
            OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE          AS CAPA_GRADE
                 , A.SOC
                 , SUM(A.STOCK_QTY)          AS STOCK_QTY
                 , SUM(A.AVAILABLE_QTY)      AS AVAILABLE_QTY
                 , SUM(A.NON_QC_QTY)         AS UNDECIDED_QTY
                 , SUM(A.ALLOCATION_QTY)     AS ALLOCATION_QTY
                 , SUM(A.BLOCK_QTY)          AS HOLD_QTY
                 , SUM(A.PACKING_QTY)        AS PACKING_QTY
                 , SUM(A.MOVING_QTY)         AS MOVING_QTY
                 , SUM(A.RCVLOC_QTY)         AS RECEIVING_QTY
                 , SUM(A.EXPIRATION_QTY)     AS EXPIRATION_QTY
                 , SUM(A.LONG_QTY)           AS LONG_TERM_QTY
              FROM SSP_ANL_OWMS_STOCK_C A
                 , SCM_MST_SLOC B
                 , SSP_MST_MODEL_USER M
             WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
               AND B.STORAGE_ID(+)  = A.STORAGE_ID
               AND B.PLANT_ID(+)    = A.PLANT_ID
               AND M.DIVISION_ID(+) = A.DIVISION_ID
               AND M.FROM_SITE(+)   = A.FROM_SITE
               AND M.ITEM_ID(+)     = A.ITEM_ID
               AND M.VALID_YN(+)    = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_PLAN_SEQ
               AND A.FROM_SITE           = P_FROM_SITE
               AND A.ITEM_ID             = P_ITEM_ID
             GROUP BY A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC
                 , A.PLANT_ID
                 , A.DIVISION_ID
                 , A.STORAGE_ID
                 , B.STORAGE_DESCRIPTION
             ORDER BY A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID
                 , A.ITEM_ID
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC;

            /* 1. 셀 더블클릭 - W/H Stock Detail */
            OPEN O_RC2 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , A.GRADE
                         , A.CAPACITY_GRADE     AS CAPA_GRADE
                         , A.SOC
                         , A.LOT_ID
                         , A.PALLET_ID
                         , A.STOCK_QTY
                         , A.AVAILABLE_QTY
                         , A.NON_QC_QTY         AS UNDECIDED_QTY
                         , A.ALLOCATION_QTY
                         , A.BLOCK_QTY          AS HOLD_QTY
                         , A.PACKING_QTY
                         , A.MOVING_QTY
                         , A.RCVLOC_QTY         AS RECEIVING_QTY
                         , A.EXPIRATION_QTY
                         , A.LONG_QTY           AS LONG_TERM_QTY
                         , A.PLANT_ID
                         , A.PACKING_STATUS
                         , A.STOCK_STATUS
                         , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                         , A.CUSTOMER_CODE
                         , A.CUSTOMER_NAME
                         , CASE WHEN REGEXP_LIKE(A.LOT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.LOT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                           END AS LOT_ISSUE_DATE
                      FROM SSP_ANL_OWMS_STOCK_C A
                         , SCM_MST_SLOC B
                         , SSP_MST_MODEL_USER M
                     WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND B.STORAGE_ID(+)  = A.STORAGE_ID
                       AND B.PLANT_ID(+)    = A.PLANT_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.FROM_SITE
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID         = P_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = P_PLAN_TYPE
                       AND A.SEQ                 = P_PLAN_SEQ
                       AND A.FROM_SITE           = P_FROM_SITE
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                             OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                           OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                             OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                   ) IA
             ORDER BY IA.DIVISION_ID
                 , IA.PLANT_ID
                 , IA.STORAGE_ID
                 , IA.ITEM_ID
                 , IA.GRADE
                 , IA.CAPA_GRADE
                 , IA.SOC
                 , IA.LOT_ID
                 , IA.PALLET_ID;

        ELSE

            /* 2. btnSearch - W/H Stock */
            OPEN O_RC1 FOR
            SELECT A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                 , A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE          AS CAPA_GRADE
                 , A.SOC
                 , SUM(A.STOCK_QTY)          AS STOCK_QTY
                 , SUM(A.AVAILABLE_QTY)      AS AVAILABLE_QTY
                 , SUM(A.NON_QC_QTY)         AS UNDECIDED_QTY
                 , SUM(A.ALLOCATION_QTY)     AS ALLOCATION_QTY
                 , SUM(A.BLOCK_QTY)          AS HOLD_QTY
                 , SUM(A.PACKING_QTY)        AS PACKING_QTY
                 , SUM(A.MOVING_QTY)         AS MOVING_QTY
                 , SUM(A.RCVLOC_QTY)         AS RECEIVING_QTY
                 , SUM(A.EXPIRATION_QTY)     AS EXPIRATION_QTY
                 , SUM(A.LONG_QTY)           AS LONG_TERM_QTY
              FROM SSP_ANL_OWMS_STOCK_C A
                 , SCM_MST_SLOC B
                 , SSP_MST_MODEL_USER M
             WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
               AND B.STORAGE_ID(+)  = A.STORAGE_ID
               AND B.PLANT_ID(+)    = A.PLANT_ID
               AND M.DIVISION_ID(+) = A.DIVISION_ID
               AND M.FROM_SITE(+)   = A.FROM_SITE
               AND M.ITEM_ID(+)     = A.ITEM_ID
               AND M.VALID_YN(+)    = 'Y'
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = P_PLAN_SEQ
               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                     OR  UPPER(P_FROM_SITE) = 'ALL'   /* 조회조건 ALL 은 조건 없음 */
                     OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                     OR  UPPER(P_ITEM_ID) = 'ALL'     /* 조회조건 ALL 은 조건 없음 */
--                   OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                     OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
               /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
               AND ((P_NONCHK = 'Y' AND 1 = 1)
                     OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                       UNION
                                      SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                        FROM SSP_MST_DELEGATE
                                       WHERE VALID_YN = 'Y'
                                         AND DELEGATEE_ID = P_USER_ID
                                       GROUP BY USER_ID)
                     OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                     OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
               /* 체크박스 체크 여부 조회 끝 */
             GROUP BY A.ITEM_ID
                 , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID)
                 , A.STOCK_STATUS
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC
                 , A.PLANT_ID
                 , A.DIVISION_ID
                 , A.STORAGE_ID
                 , B.STORAGE_DESCRIPTION
             ORDER BY A.DIVISION_ID
                 , A.PLANT_ID
                 , A.STORAGE_ID
                 , A.ITEM_ID
                 , A.GRADE
                 , A.CAPACITY_GRADE
                 , A.SOC;

            /* 2. btnSearch - W/H Stock Detail */
            OPEN O_RC2 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , A.GRADE
                         , A.CAPACITY_GRADE     AS CAPA_GRADE
                         , A.SOC
                         , A.LOT_ID
                         , A.PALLET_ID
                         , A.STOCK_QTY
                         , A.AVAILABLE_QTY
                         , A.NON_QC_QTY         AS UNDECIDED_QTY
                         , A.ALLOCATION_QTY
                         , A.BLOCK_QTY          AS HOLD_QTY
                         , A.PACKING_QTY
                         , A.MOVING_QTY
                         , A.RCVLOC_QTY         AS RECEIVING_QTY
                         , A.EXPIRATION_QTY
                         , A.LONG_QTY           AS LONG_TERM_QTY
                         , A.PLANT_ID
                         , A.PACKING_STATUS
                         , A.STOCK_STATUS
                         , A.STORAGE_ID || ' ' || B.STORAGE_DESCRIPTION AS STORAGE_ID
                         , A.CUSTOMER_CODE
                         , A.CUSTOMER_NAME
                         , CASE WHEN REGEXP_LIKE(A.LOT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.LOT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                           END AS LOT_ISSUE_DATE
                      FROM SSP_ANL_OWMS_STOCK_C A
                         , SCM_MST_SLOC B
                         , SSP_MST_MODEL_USER M
                     WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND B.STORAGE_ID(+)  = A.STORAGE_ID
                       AND B.PLANT_ID(+)    = A.PLANT_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.FROM_SITE
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID         = P_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = P_PLAN_TYPE
                       AND A.SEQ                 = P_PLAN_SEQ
                       AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                             OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                             OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                             OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                           OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                             OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                               UNION
                                              SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                FROM SSP_MST_DELEGATE
                                               WHERE VALID_YN = 'Y'
                                                 AND DELEGATEE_ID = P_USER_ID
                                               GROUP BY USER_ID)
                             OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                       /* 체크박스 체크 여부 조회 끝 */
                   ) IA
             ORDER BY IA.DIVISION_ID
                 , IA.PLANT_ID
                 , IA.STORAGE_ID
                 , IA.ITEM_ID
                 , IA.GRADE
                 , IA.CAPA_GRADE
                 , IA.SOC
                 , IA.LOT_ID
                 , IA.PALLET_ID;

        END IF;

    END P_SSP0015_GET_WH_STOCK;


    /* ============================================================
       P_SSP0015_GET_MES_STOCK
       AS-IS SSP0015_GET_MES_STOCK
       ※ AS-IS SUBSTRING(LOT_ID, 0, 9) 는 8자다. Oracle SUBSTR(x,0,9) 는 9자라
          SUBSTR(LOT_ID, 1, 8) 로 옮긴다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_MES_STOCK
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_LOT_ID                IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   @ PKG_SSP0015.P_SSP0015_GET_MES_STOCK
         * Description  @ MES Stock
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/10/24   AYJ				MES Stock 시트 조회
         * 2019/01/06   KIMYHONGHO		[]MES Sotck 시트 운영 신규 적용
         * 2020/01/20   KIMYHONGHO		[C20200115-000414] MES Stock Detail 화면 개선 요청건
         * 2020/03/18   KIMYONGHO		[C20200303-000163] LONGTERM_HOLD_YN 컬럼 추가
         * 2021/07/26	KIMYONGHO       C20210708-000537 : [SCM PI팀] 재고 정합성 관련 GMES 불량 수량 GSCM 전송 요청
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         * 2026.10.07   AJS             조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        OPEN O_RC1 FOR
        SELECT XA.ROW_NO AS "ROWNUM"   /* AS-IS 칸 이름이 ROWNUM 이라 그대로 내보낸다(Oracle 예약어라 인용부호) */
             , XA.DIVISION_ID
             , XA.FROM_SITE
             , XA.ITEM_ID
             , XA.NICK_NAME
             , XA.LOT_ID
             , XA.YYYYMMDD_LOT_ID_APPLIED_LT
             , XA.MES_CHANGE_STATUS
             , XA.LOT_TYPE
             , XA.LOT_QTY_MES
             , XA.LOT_QTY_MES_NG
             , XA.LOT_QTY_FCS
             , XA.FCS_SPECIAL_QTY
             , XA.OWMS_STOCK_QTY
             , XA.LOT_QTY_TOT
             , XA.AVAILABLE_YN
             , XA.MES_HOLD_YN
             , XA.QMS_HOLD_YN
             , XA.FCS_HOLD_YN
             , XA.LONGTERM_HOLD_YN
             , XA.JUDG_VLD_DATE
             , XA.MES_HOLD_RELEASE
             , XA.QMS_HOLD_RELEASE
             , XA.USER_MOD_RELEASE_DATE
             , XA.REMARKS
             , XA.LAST_UPDATED_BY
             , XA.LAST_UPDATE_DATE
          FROM (
                SELECT ROW_NUMBER() OVER (PARTITION BY IA.DIVISION_ID, IA.FROM_SITE, IA.ITEM_ID, IA.LOT_ID
                                              /* AS-IS MSSQL 은 내림차순에서 값 없음을 뒤에 둔다 — 대표 행 선택이 뒤집히지 않게 NULLS LAST */
                                              ORDER BY IA.LOT_TYPE DESC NULLS LAST, IA.MES_CHANGE_STATUS DESC NULLS LAST) AS ROW_NO
                     , IA.DIVISION_ID
                     , IA.FROM_SITE
                     , IA.ITEM_ID
                     , IA.NICK_NAME
                     , IA.LOT_ID
                     , IA.YYYYMMDD_LOT_ID_APPLIED_LT
                     , IA.MES_CHANGE_STATUS
                     , IA.LOT_TYPE
                     , IA.LOT_QTY_MES
                       /* C20210708-000537 */
                     , IA.LOT_QTY_MES_NG
                     , IA.LOT_QTY_FCS
                     , IA.FCS_SPECIAL_QTY
                     , IA.OWMS_STOCK_QTY
                     , IA.LOT_QTY_TOT
                     , IA.AVAILABLE_YN
                     , IA.MES_HOLD_YN
                     , IA.QMS_HOLD_YN
                     , IA.FCS_HOLD_YN
                     , IA.LONGTERM_HOLD_YN
                     , IA.JUDG_VLD_DATE
                     , IA.MES_HOLD_RELEASE
                     , IA.QMS_HOLD_RELEASE
                     , IA.USER_MOD_RELEASE_DATE
                     , IA.REMARKS
                     , IA.LAST_UPDATED_BY
                     , IA.LAST_UPDATE_DATE
                  FROM (
                        SELECT X.DIVISION_ID
                             , X.FROM_SITE
                             , X.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
                             , X.LOT_ID                             AS LOT_ID
                             , CASE WHEN REGEXP_LIKE(X.YYYYMMDD_LOT_ID_APPLIED_LT, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.YYYYMMDD_LOT_ID_APPLIED_LT, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS YYYYMMDD_LOT_ID_APPLIED_LT
                             , X.CHANGE_STATUS                      AS MES_CHANGE_STATUS
                             , X.LOT_TYPE
                             , X.LOT_QTY_MES
                               /* C20210708-000537 */
                               /* ATTRIBUTE4 는 VARCHAR2 다. AS-IS 는 UNION 타입 우선순위로 정수가 되므로 숫자로 맞춘다.
                                  원장 칸이라 이관 채움값이 섞여도 조회가 끊기지 않게 방어 변환을 둔다. */
                             , NVL(TO_NUMBER(X.ATTRIBUTE4 DEFAULT NULL ON CONVERSION ERROR), 0) AS LOT_QTY_MES_NG   /* 불량수량 */
                             , X.LOT_QTY_FCS
                             , X.FCS_SPECIAL_QTY
                             , X.OWMS_STOCK_QTY
                             , X.LOT_QTY_TOT                        AS LOT_QTY_TOT
                             , X.AVAILABLE_YN
                             , X.MES_HOLD_YN
                             , X.QMS_HOLD_YN
                             , X.FCS_HOLD_YN
                             , X.LONGTERM_HOLD_YN
                             , CASE WHEN REGEXP_LIKE(X.JUDG_VLD_DATE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.JUDG_VLD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS JUDG_VLD_DATE
                             , CASE WHEN REGEXP_LIKE(X.MES_HOLD_RELEASE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.MES_HOLD_RELEASE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS MES_HOLD_RELEASE
                             , CASE WHEN REGEXP_LIKE(X.QMS_HOLD_RELEASE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.QMS_HOLD_RELEASE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS QMS_HOLD_RELEASE
                             , CASE WHEN REGEXP_LIKE(X.USER_MOD_RELEASE_DATE, '^[0-9]{8}$')
                                    THEN TO_CHAR(TO_DATE(X.USER_MOD_RELEASE_DATE, 'YYYYMMDD'), 'YYYY-MM-DD')
                               END                                  AS USER_MOD_RELEASE_DATE
                             , X.REMARKS
                             /* 2026.09.30 AJS 수정 (START) */
--                             , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                                    ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || X.LAST_UPDATED_BY || ')'
--                             , TB_FX_USER U
--                         WHERE X.LAST_UPDATED_BY = U.USERID(+)
--                           AND U.USEYN(+)        = 'Y'
                             , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                                    ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || X.LAST_UPDATED_BY || ')'
                               END                                  AS LAST_UPDATED_BY
                             , X.LAST_UPDATE_DATE
                          FROM SSP_ANL_MES_FCS_STOCK_40_C X
                             , SCM_ADM_USER_M U
                             , SSP_MST_MODEL_USER M
                         WHERE X.LAST_UPDATED_BY = U.USER_ID(+)
                           AND U.USE_YN(+)       = 'Y'
                             /* 2026.09.30 AJS 수정 (END) */
                           AND M.DIVISION_ID(+)  = X.DIVISION_ID
                           AND M.FROM_SITE(+)    = X.FROM_SITE
                           AND M.ITEM_ID(+)      = X.ITEM_ID
                           AND M.VALID_YN(+)     = 'Y'
                           AND X.DIVISION_ID         = P_DIVISION_ID
                           AND X.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND X.PLAN_TYPE           = 'SP'
                           AND X.SEQ                 = 1
                           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                 OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                 OR X.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                                 OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                               OR X.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                                 OR X.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                           AND ((P_LOT_ID IS NULL OR P_LOT_ID = '')
                                 OR X.LOT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_LOT_ID, ','))))
                           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' @ 체크박스 선택 안한 상태) */
                           AND ((P_NONCHK = 'Y' AND 1 = 1)
                                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                   UNION
                                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                    FROM SSP_MST_DELEGATE
                                                   WHERE VALID_YN = 'Y'
                                                     AND DELEGATEE_ID = P_USER_ID
                                                   GROUP BY USER_ID)
                                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                        /* [C20200115-000414] OWMS 조회 부분 추가 */
                        UNION ALL
                        SELECT A.DIVISION_ID
                             , A.FROM_SITE
                             , A.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                             , SUBSTR(A.LOT_ID, 1, 8)   AS LOT_ID
                             , NULL                     AS YYYYMMDD_LOT_ID_APPLIED_LT
                             , NULL                     AS MES_CHANGE_STATUS
                             , NULL                     AS LOT_TYPE
                             , 0                        AS LOT_QTY_MES
                               /* C20210708-000537 */
                             , 0                        AS LOT_QTY_MES_NG
                             , 0                        AS LOT_QTY_FCS
                             , 0                        AS FCS_SPECIAL_QTY
                             , SUM(A.STOCK_QTY)         AS OWMS_STOCK_QTY
                             , 0                        AS LOT_QTY_TOT
                             , '-'                      AS AVAILABLE_YN
                             , '-'                      AS MES_HOLD_YN
                             , '-'                      AS QMS_HOLD_YN
                             , '-'                      AS FCS_HOLD_YN
                             , '-'                      AS LONGTERM_HOLD_YN
                             , NULL                     AS JUDG_VLD_DATE
                             , NULL                     AS MES_HOLD_RELEASE
                             , NULL                     AS QMS_HOLD_RELEASE
                             , NULL                     AS USER_MOD_RELEASE_DATE
                             , NULL                     AS REMARKS
                             , NULL                     AS LAST_UPDATED_BY
                             , NULL                     AS LAST_UPDATE_DATE
                          FROM SSP_ANL_OWMS_STOCK_C A
                             , SCM_MST_SLOC B
                             , SSP_MST_MODEL_USER M
                         WHERE B.DIVISION_ID(+) = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                           AND B.STORAGE_ID(+)  = A.STORAGE_ID
                           AND B.PLANT_ID(+)    = A.PLANT_ID
                           AND M.DIVISION_ID(+) = A.DIVISION_ID
                           AND M.FROM_SITE(+)   = A.FROM_SITE
                           AND M.ITEM_ID(+)     = A.ITEM_ID
                           AND M.VALID_YN(+)    = 'Y'
                           AND A.DIVISION_ID         = P_DIVISION_ID
                           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                 OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                                 OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                           AND ((P_LOT_ID IS NULL OR P_LOT_ID = '')
                                 OR A.LOT_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_LOT_ID, ','))))
                           AND ((P_NONCHK = 'Y' AND 1 = 1)
                                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                   UNION
                                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                    FROM SSP_MST_DELEGATE
                                                   WHERE VALID_YN = 'Y'
                                                     AND DELEGATEE_ID = P_USER_ID
                                                   GROUP BY USER_ID)
                                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                         GROUP BY A.DIVISION_ID
                             , A.ORIGIN_FROM_DIVISION_ID
                             , A.FROM_SITE
                             , A.ITEM_ID
                             , SUBSTR(A.LOT_ID, 1, 8)
                       ) IA
               ) XA
         WHERE XA.ROW_NO = 1
         ORDER BY XA.DIVISION_ID
             , XA.ITEM_ID
             , XA.LOT_ID
             , XA.MES_CHANGE_STATUS DESC;

    END P_SSP0015_GET_MES_STOCK;


    /* ============================================================
       P_SSP0015_GET_STOCK_LOCATION_DETAIL
       AS-IS SSP0015_GET_STOCK_LOCATION_DETAIL
       ※ AS-IS 의 @MST_LOCATION 테이블변수는 채우기만 하고 조인이 전부 주석 처리돼 있어
          결과에 영향을 주지 않는다. 옮기지 않는다.
       ※ SCM_DNM_STOCK_V.CUTOFF_DATE 는 Oracle 에서 DATE 다. 암시적 형변환을 막기 위해
          비교값을 TO_DATE 로 맞추고, 결과 칸은 AS-IS 표기(YYYYMMDD)로 돌려준다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_STOCK_LOCATION_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_DBL_FLAG              IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_PROGRAM_ID            IN  VARCHAR2 DEFAULT 'SSP0015',
        P_SHEET_NAME            IN  VARCHAR2 DEFAULT 'Stock Location Detail',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_STOCK_LOCATION_DETAIL
         * Description  : 소형 외주 Packer
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021-09-28   KIMYONGHO	    최초작성
         * 2024-10-01   KHJ             NERP_SSP
         * 2026.09.16   AJS             MSSQL -> Oracle 전환
         * 2026.10.07   AJS             조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_A010              VARCHAR2(10 CHAR);   /* NERP 매핑코드 */
        V_BOH_YYYYMMDD      VARCHAR2(8 CHAR);
        V_STOCK_YYYYMMDD    VARCHAR2(8 CHAR);
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        V_A010 := FN_GET_LOOKUP_VALUE('SSP0015_GET_STOCK_LOCATION_DETAIL', 'A010');   /* A010 */

        V_BOH_YYYYMMDD   := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');   /* FROM -1일 */
        V_STOCK_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 3, 'YYYYMMDD');   /* FROM -3일 */

        IF P_DBL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.COMPANY_ID
                         , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD')   AS CUTOFF_DATE
                         , A.SCM_SITE_ID                        AS FROM_SITE
                         , A.PLANT_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                         , A.STOCK_TYPE
                         , A.STORAGE_ID
                         , NVL(B.STORAGE_DESCRIPTION,
                               (SELECT MIN(SA.STORAGE_DESCRIPTION)
                                  FROM SCM_MST_SLOC SA
                                 WHERE SA.PLANT_ID   = A.PLANT_ID
                                   AND SA.STORAGE_ID = A.STORAGE_ID
                                   AND SA.VALID_YN   = 'Y')) AS STORAGE_DESCRIPTION
                         , NVL(A.SCM_QTY, 0)                    AS TOTAL_QTY
                         , NVL(A.SSP_QTY, 0)                    AS AVAILABLE_QTY
                         , A.DEFECT_QTY
                         , A.MOVING_QTY
                         , A.QTY_UOM
                         , NVL(A.WIPHOLD_YN, 'N')               AS WIPHOLD_YN
                         , A.HOLDING_DATE
                         , A.AVAILABLE_DATE
                         , A.OUTSOURCING_FLAG
                         , A.OUTSOURCING_FACTORY
                      FROM SCM_DNM_STOCK_V A
                         , SCM_MST_SLOC B
                         , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME
                              FROM SCM_MST_ITEM_SN
                             WHERE DIVISION_ID = P_DIVISION_ID
                               AND ACTIVE_FLAG = 'Y'
                               AND SCP_OPERATION_GROUP = 'P'   /* CELL/PACK 구분 */
                           ) C
                         , SSP_MST_MODEL_USER M
                     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
                       AND A.PLANT_ID      = B.PLANT_ID(+)
                       AND A.STORAGE_ID    = B.STORAGE_ID(+)
                       AND A.DIVISION_ID   = C.DIVISION_ID
                       AND A.ITEM_ID       = C.ITEM_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.SCM_SITE_ID
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND A.COMPANY_ID  = P_COMPANY_ID
                       AND A.SCM_SITE_ID = P_FROM_SITE
                       AND A.ITEM_ID     = P_ITEM_ID
                       AND A.CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
                       AND A.ORG_CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD') + 1 /* AJS 20261007 속도 : 원장 마감일 조건(뷰 마감일 + 1 과 같은 값) */
                       AND A.CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')   /* 현재일 - 3 */
                       AND A.STOCK_TYPE  = 'INVENTORY'
                       AND A.PLANT_ID    = V_A010   /* 'A010' */
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                               UNION
                                              SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                FROM SSP_MST_DELEGATE
                                               WHERE VALID_YN = 'Y'
                                                 AND DELEGATEE_ID = P_USER_ID
                                               GROUP BY USER_ID)
                             OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                   ) IA
             ORDER BY IA.COMPANY_ID
                 , IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.PLANT_ID
                 , IA.ITEM_ID
                 , IA.STOCK_TYPE
                 , IA.STORAGE_ID;

        ELSE

            OPEN O_RC1 FOR
            SELECT IA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.COMPANY_ID
                         , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD')   AS CUTOFF_DATE
                         , A.SCM_SITE_ID                        AS FROM_SITE
                         , A.PLANT_ID
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME
                         , A.STOCK_TYPE
                         , A.STORAGE_ID
                         , NVL(B.STORAGE_DESCRIPTION,
                               (SELECT MIN(SA.STORAGE_DESCRIPTION)
                                  FROM SCM_MST_SLOC SA
                                 WHERE SA.PLANT_ID   = A.PLANT_ID
                                   AND SA.STORAGE_ID = A.STORAGE_ID
                                   AND SA.VALID_YN   = 'Y')) AS STORAGE_DESCRIPTION
                         , NVL(A.SCM_QTY, 0)                    AS TOTAL_QTY
                         , NVL(A.SSP_QTY, 0)                    AS AVAILABLE_QTY
                         , A.DEFECT_QTY
                         , A.MOVING_QTY
                         , A.QTY_UOM
                         , NVL(A.WIPHOLD_YN, 'N')               AS WIPHOLD_YN
                         , A.HOLDING_DATE
                         , A.AVAILABLE_DATE
                         , A.OUTSOURCING_FLAG
                         , A.OUTSOURCING_FACTORY
                      FROM SCM_DNM_STOCK_V A
                         , SCM_MST_SLOC B
                         , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME
                              FROM SCM_MST_ITEM_SN
                             WHERE DIVISION_ID = P_DIVISION_ID
                               AND ACTIVE_FLAG = 'Y'
                               AND SCP_OPERATION_GROUP = 'P'   /* CELL/PACK 구분 */
                           ) C
                         , SSP_MST_MODEL_USER M
                     WHERE A.DIVISION_ID   = B.DIVISION_ID(+)
                       AND A.PLANT_ID      = B.PLANT_ID(+)
                       AND A.STORAGE_ID    = B.STORAGE_ID(+)
                       AND A.DIVISION_ID   = C.DIVISION_ID
                       AND A.ITEM_ID       = C.ITEM_ID
                       AND M.DIVISION_ID(+) = A.DIVISION_ID
                       AND M.FROM_SITE(+)   = A.SCM_SITE_ID
                       AND M.ITEM_ID(+)     = A.ITEM_ID
                       AND M.VALID_YN(+)    = 'Y'
                       AND A.DIVISION_ID = P_DIVISION_ID
                       AND A.COMPANY_ID  = P_COMPANY_ID
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                             OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                           OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                             OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND A.CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
                       AND A.ORG_CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD') + 1 /* AJS 20261007 속도 : 원장 마감일 조건(뷰 마감일 + 1 과 같은 값) */
                       AND A.CUTOFF_DATE > TO_DATE(V_STOCK_YYYYMMDD, 'YYYYMMDD')   /* 현재일 - 3 */
                       AND A.STOCK_TYPE  = 'INVENTORY'
                       AND A.PLANT_ID    = V_A010   /* 'A010' */
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                               UNION
                                              SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                FROM SSP_MST_DELEGATE
                                               WHERE VALID_YN = 'Y'
                                                 AND DELEGATEE_ID = P_USER_ID
                                               GROUP BY USER_ID)
                             OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                   ) IA
             ORDER BY IA.COMPANY_ID
                 , IA.DIVISION_ID
                 , IA.FROM_SITE
                 , IA.PLANT_ID
                 , IA.ITEM_ID
                 , IA.STOCK_TYPE
                 , IA.STORAGE_ID;

        END IF;

    END P_SSP0015_GET_STOCK_LOCATION_DETAIL;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
       AS-IS SSP0015_GET_SHIPMENT_PSI_COMMENTS - 결과셋 2벌(NOTE · Prod Qty)
       ※ AS-IS 는 FN_GET_IN_STR 로 IN 리스트를 만들어 EXEC 로 돌린다.
          선택조건 조립뿐이라 정적 SQL 로 옮겼다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS
         * Description  : Shipment Plan Confrim COMMENTS LOAD
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/08/09   MCTHEJ		   [CSR ID:4061695] SSP 시스템 개선 요청건(Shipment Plan)
         * 2023/08/03   jilee          AS BEFORE_QTY, AS GAP 조건 변경
         * 2026.09.16   AJS            MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         *
         ex) EXEC PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_COMMENTS('40','20190811','','','20190809','20191031', ...)
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* Note Load */
        OPEN O_RC1 FOR
        SELECT A.DIVISION_ID
             , A.FROM_SITE                                                              AS SITE
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), '-')        AS FROM_SITE_NM
             , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN B.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
             , A.ITEM_ID
             , SUBSTR(A.YYYYMMDD, 1, 4) || '-' || SUBSTR(A.YYYYMMDD, 5, 2) || '-' || SUBSTR(A.YYYYMMDD, 7, 2) AS YYYYMMDD
             , CEIL(NVL(SUM(A.USER_ADD_QTY), 0))                                        AS USER_ADD_QTY
             , NVL(SUM(B.QTY), 0)                                                       AS QTY
             , CEIL(NVL(SUM(TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR)), 0)) AS BEFORE_QTY
             , NVL(SUM(B.QTY), 0) - CEIL(NVL(SUM(TO_NUMBER(A.ATTRIBUTE1 DEFAULT NULL ON CONVERSION ERROR)), 0)) AS GAP
             , NVL(A.COMMENTS, '')                                                      AS COMMENTS
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE
          FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT A
             , SSP_ANL_SHIP_PLAN_40 B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.FROM_SITE   = B.FROM_SITE
           AND A.ITEM_ID     = B.ITEM_ID
           AND A.YYYYMMDD    = B.YYYYMMDD
           AND B.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND B.MEASURE             = 'WH_IN'
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                 OR  UPPER(P_DIVISION_ID) = 'ALL'     /* 조회조건 ALL 은 조건 없음 */
                 OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
         GROUP BY A.DIVISION_ID
             , B.ORIGIN_FROM_DIVISION_ID
             , A.FROM_SITE
             , A.ITEM_ID
             , A.YYYYMMDD
             , A.COMMENTS
             , A.LAST_UPDATED_BY
             , A.LAST_UPDATE_DATE;

        /* Prod Qty Load */
        OPEN O_RC2 FOR
        SELECT DIVISION_ID
             , FROM_SITE                                                                AS SITE
             , ITEM_ID
             , SUBSTR(YYYYMMDD, 1, 4) || '-' || SUBSTR(YYYYMMDD, 5, 2) || '-' || SUBSTR(YYYYMMDD, 7, 2) AS YYYYMMDD
             , NVL(ATTRIBUTE3, '')                                                      AS PRODUCT_QTY
          FROM SSP_ANL_SHIP_PLAN_40
         WHERE 1 = 1
           /* AS-IS : (ATTRIBUTE3 IS NOT NULL OR ATTRIBUTE3 != '') - 뒷항은 Oracle 에서 늘 거짓이라 앞항만 남긴다 */
           AND ATTRIBUTE3 IS NOT NULL
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND MEASURE             = 'PROD_PLAN'
           AND YYYYMMDD >= P_FROM_YYYYMMDD
           AND YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                 OR  UPPER(P_DIVISION_ID) = 'ALL'     /* 조회조건 ALL 은 조건 없음 */
                 OR DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
         GROUP BY DIVISION_ID
             , FROM_SITE
             , ITEM_ID
             , YYYYMMDD
             , ATTRIBUTE3;

    END P_SSP0015_GET_SHIPMENT_PSI_COMMENTS;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_RESULT
       AS-IS SSP0015_GET_SHIPMENT_RESULT
       ※ AS-IS WITH 절 5벌은 각각 1회만 참조하므로 인라인 뷰로 펼쳤다(온라인 SQL WITH 금지).
       ※ STUFF(... FOR XML PATH('')) 는 LISTAGG 로 옮겼다. AS-IS 는 정렬이 없으나
          LISTAGG 는 WITHIN GROUP 이 필수라 DEPT_NAME_KO 로 정렬한다.
       ※ AS-IS 의 CASE WHEN DIVISION_ID = '4O' 는 알파벳 O 다(숫자 0 아님).
          결과 동일성을 위해 원형을 그대로 둔다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_RESULT
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_TYPE                  IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_REAL_FLAG             IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT
         * Description  : Shipment Shipment Result
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2019/09/26   AYJ			[CSR ID:4037234] 출하계획 대비 실적 Report 개발
         * 2019/12/04   juhlee      [C20191205-000132]  OWMS 출하실적에 반품 내용 적용
         * 2020/01/21   juhlee      [C20200121-000352]  ESS Packer출하 적용
         * 2020/02/12   KIMYONGHO   [C20200218-000135]  SHIP_TYPE 컬럼추가 및 FROM_STIE, TO_SITE Display 변경
         * 2020.05.06	KIMYONGHO   [C20200403-000062] [GSCM PI] SSP 출하 실적 집계 중 사외 창고 제외 로직 추가 건
         * 2020.09.18	KIMYONGHO   ERP_ORDER_TYPE 주석 처리 Request by 김광희 책임
         * 2021.02.17	KIMYONGHO   실적 조회시 TRNSPORT_MODE, INCOTERMS, ERP_SO_NO, ETA_DATE, ETD_DATE ERP 실적 기준으로 조회
         * 2021.04.05   KIMYONGHO   [C20210330-000402] Shipment Plan화면의 실적 조회시 Sales site Mapping 안되는건 전수 표시
         * 2021.05.03   SSP Pjt.    SSP_SHIP_RESULT_EXCEPT_ERP_ORDER_TYPE LOOKUP적용
         * 2021.11.15   KIMYONGHO   Confirm Data Plan Date 기준 조회 처리
         * 2024.10.18   SSP         소형 Team 컬럼 추가
         * 2024.10.29   KHJ         NERP_SSP
         * 2026.09.16   AJS         MSSQL -> Oracle 전환 (WITH -> 인라인 뷰, XML PATH -> LISTAGG)
         * 2026.10.07   AJS         조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        OPEN O_RC1 FOR
        SELECT X.DIVISION_ID
             , B.COMPANY_ID    AS COMPANY_ID
             , C.SEGMENT2      AS TYPE
             , X.ERP_SO_NO
             , X.CONFIRM_ID
             , X.ITEM_ID
             , FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.FROM_SITE), X.FROM_SITE) AS FROM_SITE
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.TO_SITE), X.TO_SITE)     AS TO_SITE
             , X.TEAM
             , X.END_CUSTOMER
             , X.QTY
             , CASE WHEN REGEXP_LIKE(X.YYYYMMDD, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS YYYYMMDD
             , X.TRANSPORT_MODE
             , X.INCOTERMS
             , CASE WHEN REGEXP_LIKE(X.ETD_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD_DATE
             , CASE WHEN REGEXP_LIKE(X.ETA_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA_DATE
             , X.SHIP_TYPE
          FROM (
                /* CONFIRM_ID, 날짜동일한 기준으로 계획정보의 FROM, TO SITE기준으로 실적 집계 */
                SELECT IA.DIVISION_ID     AS DIVISION_ID
                     , 'E'                AS TYPE
                     , IA.ERP_SO_NO       AS ERP_SO_NO
                     , IA.CONFIRM_ID      AS CONFIRM_ID
                     , IA.ITEM_ID         AS ITEM_ID
                     , IA.FROM_SITE       AS FROM_SITE
                     , IA.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , IA.TEAM            AS TEAM
                     , SUM(IA.RESULT_QTY) AS QTY
                     , IA.YYYYMMDD        AS YYYYMMDD
                     , IA.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , IA.INCOTERMS       AS INCOTERMS
                     , IA.ETD_DATE        AS ETD_DATE
                     , IA.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                  FROM (
                        /* ERP 출하실적에서 CONFIRM_ID 존재, SSP_TYPE 대상 */
                        SELECT E.DIVISION_ID          AS DIVISION_ID
                             , E.CONFIRM_ID           AS CONFIRM_ID
                             , E.ORDER_NO             AS ERP_SO_NO
                             , E.EXFACTORY_DATE       AS YYYYMMDD
                             , E.TRANSPORT_MODE       AS TRANSPORT_MODE
                             , E.INCOTERMS            AS INCOTERMS
                             , E.ETA_DATE             AS ETA_DATE
                             , E.ETD_DATE             AS ETD_DATE
                             , E.FROM_SCM_SITE_ID     AS FROM_SITE
                             , E.TO_SCM_SITE_ID       AS TO_SITE
                             , E.ITEM_ID              AS ITEM_ID
                             , (SELECT LISTAGG(NVL(SA.DEPT_NAME_KO, '-'), ',' ON OVERFLOW TRUNCATE)
                                       WITHIN GROUP (ORDER BY SA.DEPT_NAME_KO)
                                  FROM SCM_MST_SSO_DEPT_INFO SA
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     , TB_FX_USER SB
--                                   AND SB.USERID IN (SELECT OWNER
                                     , SCM_ADM_USER_M SB
                                 WHERE SA.DEPT_ID = SB.DEPT_ID
                                   AND SB.USER_ID IN (SELECT OWNER
                                     /* 2026.09.30 AJS 수정 (END) */
                                                       FROM SCM_MST_SITE_ITEM
                                                      WHERE 1 = 1
                                                        AND DIVISION_ID  = E.DIVISION_ID
                                                        AND SCM_SITE_ID  = E.TO_SCM_SITE_ID
                                                        AND ITEM_ID      = E.ITEM_ID
                                                        AND PROJECT_CODE = (SELECT MIN(SC.PROJECT_CODE)
                                                                              FROM SSP_ANL_SHIP_CONFIRM SC
                                                                             WHERE SC.CONFIRM_ID = E.CONFIRM_ID)
                                                        AND VALID_YN     = 'Y'
                                                        AND OWNER IS NOT NULL)) AS TEAM
                             , SUM(E.EXFACTORY_QTY)   AS RESULT_QTY
                          FROM SCM_DNM_EXFACTORY_RESULT E
                             , SCM_ADM_LOOKUP_MASTER_DETAIL L
                         WHERE L.LOOKUP_TYPE = 'ERP_SSP_TYPE'   /* LOOKUP에 등록된 공정만 */
                           AND L.VALID_YN    = 'Y'
                           AND L.SEGMENT1    = E.SSP_TYPE
                           AND NVL(E.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')   /* D90: DO삭제 , D10:DO생성 */
                           AND E.CONFIRM_ID LIKE 'C%'
                           AND E.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY E.DIVISION_ID
                             , E.CONFIRM_ID
                             , E.ORDER_NO
                             , E.EXFACTORY_DATE
                             , E.TRANSPORT_MODE
                             , E.INCOTERMS
                             , E.ETA_DATE
                             , E.ETD_DATE
                             , E.FROM_SCM_SITE_ID
                             , E.TO_SCM_SITE_ID
                             , E.ITEM_ID
                       ) IA
                 GROUP BY IA.DIVISION_ID
                     , IA.ERP_SO_NO
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.ITEM_ID
                     , IA.TRANSPORT_MODE
                     , IA.INCOTERMS
                     , IA.ETD_DATE
                     , IA.ETA_DATE
                     , IA.YYYYMMDD
                     , IA.CONFIRM_ID
                     , IA.TEAM
                UNION ALL
                /* CONFIRM_ID 없는 실적 */
                SELECT XB.DIVISION_ID     AS DIVISION_ID
                     , 'E'                AS TYPE
                     , XB.ERP_SO_NO       AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XB.ITEM_ID         AS ITEM_ID
                     , XB.FROM_SITE       AS FROM_SITE
                     , XB.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , XB.TEAM            AS TEAM
                     , XB.QTY             AS QTY
                     , XB.YYYYMMDD        AS YYYYMMDD
                     , XB.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XB.INCOTERMS       AS INCOTERMS
                     , XB.ETD_DATE        AS ETD_DATE
                     , XB.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                  FROM (
                        SELECT E.DIVISION_ID          AS DIVISION_ID
                             , '-'                    AS CONFIRM_ID
                             , E.ORDER_NO             AS ERP_SO_NO
                             , E.FROM_SCM_SITE_ID     AS FROM_SITE
                             , NVL(L3.SEGMENT4, E.TO_SCM_SITE_ID) AS TO_SITE
                             , E.ITEM_ID              AS ITEM_ID
                             , E.EXFACTORY_DATE       AS YYYYMMDD
                             , E.TRANSPORT_MODE       AS TRANSPORT_MODE
                             , E.INCOTERMS            AS INCOTERMS
                             , E.ETA_DATE             AS ETA_DATE
                             , E.ETD_DATE             AS ETD_DATE
                             , (SELECT LISTAGG(NVL(SA.DEPT_NAME_KO, '-'), ',' ON OVERFLOW TRUNCATE)
                                       WITHIN GROUP (ORDER BY SA.DEPT_NAME_KO)
                                  FROM SCM_MST_SSO_DEPT_INFO SA
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     , TB_FX_USER SB
--                                   AND SB.USERID IN (SELECT OWNER
                                     , SCM_ADM_USER_M SB
                                 WHERE SA.DEPT_ID = SB.DEPT_ID
                                   AND SB.USER_ID IN (SELECT OWNER
                                     /* 2026.09.30 AJS 수정 (END) */
                                                       FROM SCM_MST_SITE_ITEM
                                                      WHERE 1 = 1
                                                        AND DIVISION_ID = E.DIVISION_ID
                                                        AND SCM_SITE_ID = E.TO_SCM_SITE_ID
                                                        AND ITEM_ID     = E.ITEM_ID
                                                        AND VALID_YN    = 'Y'
                                                        AND OWNER IS NOT NULL)) AS TEAM
                             , SUM(E.EXFACTORY_QTY)   AS QTY
                          FROM SCM_DNM_EXFACTORY_RESULT E
                             , SCP_MST_FINAL_ITEM F
                             , SCM_MST_SITE S
                             , SCM_ADM_LOOKUP_MASTER_DETAIL L
                             , SCM_ADM_LOOKUP_MASTER_DETAIL L3
                         WHERE F.ITEM_ID     = E.ITEM_ID       /* SCP 대상 ITEM만 */
                           AND F.DIVISION_ID = E.DIVISION_ID
                           AND S.SCM_SITE_ID = E.FROM_SCM_SITE_ID
                           AND S.DIVISION_ID = E.DIVISION_ID
                           AND L.LOOKUP_TYPE = 'ERP_ORDER_TYPE'   /* LOOKUP에 등록된 ORDER_TYPE만 대상으로 함 */
                           AND L.VALID_YN    = 'Y'
                           AND L.SEGMENT1    = E.ORDER_TYPE_CODE
                           AND L3.LOOKUP_TYPE(+) = 'SHIP_RESULT_TO_SITE_MAPPING'   /* SOLDTO, SHIPTO 과 MAPPING되는 TO_SITE */
                           AND L3.SEGMENT1(+)    = E.DIVISION_ID
                           AND L3.SEGMENT2(+)    = E.SOLDTO_CODE
                           AND L3.SEGMENT3(+)    = E.SHIPTO_CODE
                           AND NVL(E.EXFACTORY_STATUS, 'D90') NOT IN ('D90', 'D10')   /* D90: DO삭제 , D10:DO생성 */
                           AND NVL(E.CONFIRM_ID, '-') NOT LIKE 'C%'
                           AND E.EXFACTORY_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND E.STORAGE_ID NOT IN (SELECT COLUMN_VALUE
                                                      FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_RESULT', 'PRODUCT_STORAGE')))   /* 상품창고제외 */
                           /* [C20200403-000062] 사외 창고 제외 LOOKUP 관리 */
                           AND NOT EXISTS (SELECT 1
                                             FROM SCM_ADM_LOOKUP_MASTER_DETAIL SB
                                            WHERE SB.LOOKUP_TYPE = 'SSP_SHIP_RESULT_EXCEPT_STORAGE'
                                              AND SB.VALID_YN    = 'Y'
                                              AND SB.SEGMENT1    = E.STORAGE_ID)
                         GROUP BY E.DIVISION_ID
                             , E.ORDER_NO
                             , E.FROM_SCM_SITE_ID
                             , NVL(L3.SEGMENT4, E.TO_SCM_SITE_ID)
                             , E.ITEM_ID
                             , E.EXFACTORY_DATE
                             , E.TRANSPORT_MODE
                             , E.INCOTERMS
                             , E.ETA_DATE
                             , E.ETD_DATE
                             , E.TO_SCM_SITE_ID
                       ) XB
                UNION ALL
                /* SSP출하계획 ( confirm된 계획) */
                SELECT XC.DIVISION_ID     AS DIVISION_ID
                     , 'P'                AS TYPE
                     , XC.ERP_SO_NO       AS ERP_SO_NO
                     , XC.CONFIRM_ID      AS CONFIRM_ID
                     , XC.ITEM_ID         AS ITEM_ID
                     , XC.FROM_SITE       AS FROM_SITE
                     , XC.TO_SITE         AS TO_SITE
                     , XC.END_CUSTOMER    AS END_CUSTOMER
                     , '-'                AS TEAM
                     , XC.QTY             AS QTY
                     , XC.YYYYMMDD        AS YYYYMMDD
                     , XC.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XC.INCOTERMS       AS INCOTERMS
                     , XC.ETD_DATE        AS ETD_DATE
                     , XC.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                  FROM (
                        /* Current Version */
                        SELECT C.DIVISION_ID     AS DIVISION_ID
                             , C.ERP_SO_NO       AS ERP_SO_NO
                             , C.CONFIRM_ID      AS CONFIRM_ID
                             , C.ITEM_ID         AS ITEM_ID
                             , C.FROM_SITE       AS FROM_SITE
                             , C.TO_SITE         AS TO_SITE
                               /* AS-IS 원형 유지 : '4O' 는 알파벳 O 다 */
                             , CASE WHEN C.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , C.QTY             AS QTY
                             , C.YYYYMMDD        AS YYYYMMDD
                             , C.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , C.INCOTERMS       AS INCOTERMS
                             , C.ETD_DATE        AS ETD_DATE
                             , C.ETA_DATE        AS ETA_DATE
                          FROM SSP_ANL_SHIP_CONFIRM C
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE SI.DIVISION_ID(+)  = C.DIVISION_ID
                           AND SI.ITEM_ID(+)      = C.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = C.TO_SITE
                           AND SI.PROJECT_CODE(+) = C.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = C.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = C.TO_SITE
                           AND C.CHANGE_TYPE = 'C'
                           AND C.QTY > 0
                           AND C.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND C.CONFIRM_ID LIKE 'C%'
                           AND P_REAL_FLAG = 'Y'
                        UNION ALL
                        /* OLD Version */
                        SELECT D.DIVISION_ID     AS DIVISION_ID
                             , D.ERP_SO_NO       AS ERP_SO_NO
                             , D.CONFIRM_ID      AS CONFIRM_ID
                             , D.ITEM_ID         AS ITEM_ID
                             , D.FROM_SITE       AS FROM_SITE
                             , D.TO_SITE         AS TO_SITE
                             , CASE WHEN D.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , D.SHIPMENT_CONFIRM_QTY AS QTY
                             , D.YYYYMMDD        AS YYYYMMDD
                             , D.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , D.INCOTERMS       AS INCOTERMS
                             , D.ETD             AS ETD_DATE
                             , D.ETA             AS ETA_DATE
                          FROM SSP_ANL_SHIP_PLAN_ALL D
                             , SCM_MST_SITE MS
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE D.DIVISION_ID = MS.DIVISION_ID
                           AND D.FROM_SITE   = MS.SCM_SITE_ID
                           AND MS.SITE_TYPE  = 'PLANT'
                           AND D.DIVISION_ID = '40'
                           AND MS.OPERATION_GROUP = 'A'
                           AND SI.DIVISION_ID(+)  = D.DIVISION_ID
                           AND SI.ITEM_ID(+)      = D.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = D.TO_SITE
                           AND SI.PROJECT_CODE(+) = D.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = D.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = D.TO_SITE
                           AND D.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND D.SHIPMENT_STATUS     = 'C'
                           AND D.SHIPMENT_CONFIRM_QTY > 0
                           AND D.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND P_REAL_FLAG = 'N'
                       ) XC
                UNION ALL
                /* OWMS 실적 */
                SELECT XD.DIVISION_ID     AS DIVISION_ID
                     , 'O'                AS TYPE
                     , NULL               AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XD.ITEM_ID         AS ITEM_ID
                     , XD.FROM_SITE       AS FROM_SITE
                     , XD.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , XD.TEAM            AS TEAM
                     , XD.QTY             AS QTY
                     , XD.YYYYMMDD        AS YYYYMMDD
                     , NULL               AS TRANSPORT_MODE
                     , NULL               AS INCOTERMS
                     , NULL               AS ETD_DATE
                     , NULL               AS ETA_DATE
                     , XD.SHIP_TYPE       AS SHIP_TYPE
                  FROM (
                        SELECT A.DIVISION_ID      AS DIVISION_ID
                             , A.ITEM_ID          AS ITEM_ID
                             , A.FROM_SITE        AS FROM_SITE
                             , CASE WHEN A.TO_SITE = '-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE END AS TO_SITE
                             , SUM(A.LOT_QTY)     AS QTY
                             , A.PLANT_ISSUE_DATE AS YYYYMMDD
                             , A.SHIP_TYPE        AS SHIP_TYPE
                             , (SELECT LISTAGG(NVL(SA.DEPT_NAME_KO, '-'), ',' ON OVERFLOW TRUNCATE)
                                       WITHIN GROUP (ORDER BY SA.DEPT_NAME_KO)
                                  FROM SCM_MST_SSO_DEPT_INFO SA
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     , TB_FX_USER SB
--                                   AND SB.USERID IN (SELECT OWNER
                                     , SCM_ADM_USER_M SB
                                 WHERE SA.DEPT_ID = SB.DEPT_ID
                                   AND SB.USER_ID IN (SELECT OWNER
                                     /* 2026.09.30 AJS 수정 (END) */
                                                       FROM SCM_MST_SITE_ITEM
                                                      WHERE 1 = 1
                                                        AND DIVISION_ID = A.DIVISION_ID
                                                        AND SCM_SITE_ID = A.TO_SITE
                                                        AND ITEM_ID     = A.ITEM_ID
                                                        AND VALID_YN    = 'Y'
                                                        AND OWNER IS NOT NULL)) AS TEAM
                          FROM SSP_DNM_SHIP_RESULT_OWMS A
                         WHERE A.PLANT_ISSUE_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY A.DIVISION_ID
                             , A.ITEM_ID
                             , A.FROM_SITE
                             , CASE WHEN A.TO_SITE = '-' THEN A.CUSTOMER_CODE ELSE A.TO_SITE END
                             , A.PLANT_ISSUE_DATE
                             , A.SHIP_TYPE
                             , A.TO_SITE
                       ) XD
                UNION ALL
                /* OWMS 반품실적 */
                SELECT XE.DIVISION_ID     AS DIVISION_ID
                     , 'R'                AS TYPE
                     , NULL               AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XE.ITEM_ID         AS ITEM_ID
                     , XE.FROM_SITE       AS FROM_SITE
                     , XE.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , '-'                AS TEAM
                     , XE.QTY             AS QTY
                     , XE.YYYYMMDD        AS YYYYMMDD
                     , NULL               AS TRANSPORT_MODE
                     , NULL               AS INCOTERMS
                     , NULL               AS ETD_DATE
                     , NULL               AS ETA_DATE
                     , XE.SHIP_TYPE       AS SHIP_TYPE
                  FROM (
                        SELECT B.DIVISION_ID      AS DIVISION_ID
                             , B.ITEM_ID          AS ITEM_ID
                             , B.FROM_SITE        AS FROM_SITE
                             , '*'                AS TO_SITE
                             , SUM(B.RECIEPT_QTY) AS QTY
                             , B.RECIEPT_DATE     AS YYYYMMDD
                             , NULL               AS SHIP_TYPE
                          FROM SSP_DNM_SHIP_RETURN_OWMS B
                         WHERE B.RECIEPT_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY B.DIVISION_ID
                             , B.ITEM_ID
                             , B.FROM_SITE
                             , B.RECIEPT_DATE
                       ) XE
               ) X
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
             , SSP_MST_MODEL_USER M
         WHERE B.DIVISION_ID = X.DIVISION_ID
           AND B.SCM_SITE_ID = X.FROM_SITE
           AND B.OPERATION_GROUP <> 'E'
           AND C.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE'   /* LOOKUP에 등록된 공정만 */
           AND C.SEGMENT1    = X.TYPE
           AND C.VALID_YN    = 'Y'
           AND M.DIVISION_ID(+) = X.DIVISION_ID
           AND M.FROM_SITE(+)   = X.FROM_SITE
           AND M.ITEM_ID(+)     = X.ITEM_ID
           AND M.VALID_YN(+)    = 'Y'
           AND X.DIVISION_ID = P_DIVISION_ID
           AND ((P_COMPANY_ID IS NULL OR P_COMPANY_ID = '') OR B.COMPANY_ID = P_COMPANY_ID)
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR X.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR X.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR X.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_TYPE IS NULL OR P_TYPE = '')
                 OR X.TYPE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_TYPE, ','))))
           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                   UNION
                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                    FROM SSP_MST_DELEGATE
                                   WHERE VALID_YN = 'Y'
                                     AND DELEGATEE_ID = P_USER_ID
                                   GROUP BY USER_ID)
                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
           /* 체크박스 체크 여부 조회 끝 */
         ORDER BY X.DIVISION_ID
             , X.FROM_SITE
             , X.YYYYMMDD
             , X.ITEM_ID
             , X.TO_SITE
             , C.DISPLAY_SEQ
             , X.CONFIRM_ID;

    END P_SSP0015_GET_SHIPMENT_RESULT;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_RESULT_PACKER
       AS-IS SSP0015_GET_SHIPMENT_RESULT_PACKER
       ※ AS-IS WITH 절 3벌은 각각 1회만 참조하므로 인라인 뷰로 펼쳤다.
       ※ AS-IS 의 CASE WHEN DIVISION_ID = '4O' 는 알파벳 O 다. 원형 유지.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_RESULT_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_TYPE                  IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_COMPANY_ID            IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_REAL_FLAG             IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_RESULT_PACKER
         * Description  : Shipment Shipment Result
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021/10/05   KIMYONGHO		신규추가
         * 2021/11/26   SMS		        Ship to 추가
         * 2026.09.16   AJS             MSSQL -> Oracle 전환 (WITH -> 인라인 뷰)
         * 2026.10.07   AJS             조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        OPEN O_RC1 FOR
        SELECT X.DIVISION_ID
             , B.COMPANY_ID    AS COMPANY_ID
             , C.SEGMENT2      AS TYPE
             , X.ERP_SO_NO
             , X.CONFIRM_ID
             , X.ITEM_ID
             , FN_GET_ITEM_NICKNAME(X.DIVISION_ID, X.ITEM_ID) AS NICK_NAME
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.FROM_SITE), X.FROM_SITE) AS FROM_SITE
             , NVL(FN_GET_SCM_SITE_DESCRIPTION(X.DIVISION_ID, X.TO_SITE), X.TO_SITE)     AS TO_SITE
             , X.END_CUSTOMER
             , X.QTY
             , CASE WHEN REGEXP_LIKE(X.YYYYMMDD, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS YYYYMMDD
             , X.TRANSPORT_MODE
             , X.INCOTERMS
             , CASE WHEN REGEXP_LIKE(X.ETD_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD_DATE
             , CASE WHEN REGEXP_LIKE(X.ETA_DATE, '^[0-9]{8}$')
                    THEN TO_CHAR(TO_DATE(X.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA_DATE
             , X.SHIP_TYPE
               /* 20211126  SMS  추가 Ship to, Shipto description */
             , X.SHIP_TO
             , D.SHIPTO_DESCRIPTION
          FROM (
                /* SCS 출하실적에서 CONFIRM_ID 존재 */
                SELECT IA.DIVISION_ID     AS DIVISION_ID
                     , 'S'                AS TYPE
                     , IA.ERP_SO_NO       AS ERP_SO_NO
                     , IA.CONFIRM_ID      AS CONFIRM_ID
                     , IA.ITEM_ID         AS ITEM_ID
                     , IA.FROM_SITE       AS FROM_SITE
                     , IA.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , SUM(IA.RESULT_QTY) AS QTY
                     , IA.YYYYMMDD        AS YYYYMMDD
                     , IA.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , IA.INCOTERMS       AS INCOTERMS
                     , IA.ETD_DATE        AS ETD_DATE
                     , IA.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                     , IA.SHIP_TO         AS SHIP_TO
                  FROM (
                        SELECT E.DIVISION_ID      AS DIVISION_ID
                             , E.ATTRIBUTE5       AS CONFIRM_ID
                             , C.ERP_SO_NO        AS ERP_SO_NO
                             , E.SHIP_DATE        AS YYYYMMDD
                             , C.TRANSPORT_MODE   AS TRANSPORT_MODE
                             , C.INCOTERMS        AS INCOTERMS
                             , C.ETA_DATE         AS ETA_DATE
                             , C.ETD_DATE         AS ETD_DATE
                             , E.SCM_SITE_ID      AS FROM_SITE
                             , E.TO_SITE          AS TO_SITE
                             , E.ITEM_ID          AS ITEM_ID
                               /* 20211126  SMS  추가  Ship to */
                             , E.ATTRIBUTE4       AS SHIP_TO
                             , SUM(E.SHIP_QTY)    AS RESULT_QTY
                          FROM SCM_DNM_SCS_SHIP_RESULT E
                             , SSP_ANL_SHIP_CONFIRM C
                         WHERE E.DIVISION_ID = C.DIVISION_ID(+)
                           AND E.ATTRIBUTE5  = C.CONFIRM_ID(+)
                           AND E.SHIP_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                         GROUP BY E.DIVISION_ID
                             , E.ATTRIBUTE5
                             , C.ERP_SO_NO
                             , E.SHIP_DATE
                             , C.TRANSPORT_MODE
                             , C.INCOTERMS
                             , C.ETA_DATE
                             , C.ETD_DATE
                             , E.SCM_SITE_ID
                             , E.TO_SITE
                             , E.ITEM_ID
                             , E.ATTRIBUTE4
                       ) IA
                 GROUP BY IA.DIVISION_ID
                     , IA.ERP_SO_NO
                     , IA.FROM_SITE
                     , IA.TO_SITE
                     , IA.ITEM_ID
                     , IA.TRANSPORT_MODE
                     , IA.INCOTERMS
                     , IA.ETD_DATE
                     , IA.ETA_DATE
                     , IA.YYYYMMDD
                     , IA.CONFIRM_ID
                     , IA.SHIP_TO
                UNION ALL
                /* SCS 출하실적에서 CONFIRM_ID 없는 실적 */
                SELECT XB.DIVISION_ID     AS DIVISION_ID
                     , 'S'                AS TYPE
                     , XB.ERP_SO_NO       AS ERP_SO_NO
                     , NULL               AS CONFIRM_ID
                     , XB.ITEM_ID         AS ITEM_ID
                     , XB.FROM_SITE       AS FROM_SITE
                     , XB.TO_SITE         AS TO_SITE
                     , NULL               AS END_CUSTOMER
                     , XB.RESULT_QTY      AS QTY
                     , XB.YYYYMMDD        AS YYYYMMDD
                     , XB.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XB.INCOTERMS       AS INCOTERMS
                     , NULL               AS ETD_DATE
                     , NULL               AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                     , XB.SHIP_TO         AS SHIP_TO
                  FROM (
                        SELECT E.DIVISION_ID      AS DIVISION_ID
                             , E.ATTRIBUTE5       AS CONFIRM_ID
                             , '-'                AS ERP_SO_NO
                             , E.SHIP_DATE        AS YYYYMMDD
                             , '-'                AS TRANSPORT_MODE
                             , '-'                AS INCOTERMS
                             , '-'                AS ETA_DATE
                             , '-'                AS ETD_DATE
                             , E.SCM_SITE_ID      AS FROM_SITE
                             , E.TO_SITE          AS TO_SITE
                             , E.ITEM_ID          AS ITEM_ID
                             , E.ATTRIBUTE4       AS SHIP_TO
                             , SUM(E.SHIP_QTY)    AS RESULT_QTY
                          FROM SCM_DNM_SCS_SHIP_RESULT E
                         WHERE E.SHIP_DATE BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND NVL(E.ATTRIBUTE5, '-') = '-'
                         GROUP BY E.DIVISION_ID
                             , E.ATTRIBUTE5
                             , E.SHIP_DATE
                             , E.ITEM_ID
                             , E.SCM_SITE_ID
                             , E.TO_SITE
                             , E.ATTRIBUTE4
                       ) XB
                UNION ALL
                /* SSP출하계획 ( confirm된 계획) */
                SELECT XC.DIVISION_ID     AS DIVISION_ID
                     , 'P'                AS TYPE
                     , XC.ERP_SO_NO       AS ERP_SO_NO
                     , XC.CONFIRM_ID      AS CONFIRM_ID
                     , XC.ITEM_ID         AS ITEM_ID
                     , XC.FROM_SITE       AS FROM_SITE
                     , XC.TO_SITE         AS TO_SITE
                     , XC.END_CUSTOMER    AS END_CUSTOMER
                     , XC.QTY             AS QTY
                     , XC.YYYYMMDD        AS YYYYMMDD
                     , XC.TRANSPORT_MODE  AS TRANSPORT_MODE
                     , XC.INCOTERMS       AS INCOTERMS
                     , XC.ETD_DATE        AS ETD_DATE
                     , XC.ETA_DATE        AS ETA_DATE
                     , NULL               AS SHIP_TYPE
                     , XC.SHIP_TO         AS SHIP_TO
                  FROM (
                        /* Current Version */
                        SELECT C.DIVISION_ID     AS DIVISION_ID
                             , C.ERP_SO_NO       AS ERP_SO_NO
                             , C.CONFIRM_ID      AS CONFIRM_ID
                             , C.ITEM_ID         AS ITEM_ID
                             , C.FROM_SITE       AS FROM_SITE
                             , C.TO_SITE         AS TO_SITE
                             , CASE WHEN C.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , C.QTY             AS QTY
                             , C.YYYYMMDD        AS YYYYMMDD
                             , C.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , C.INCOTERMS       AS INCOTERMS
                             , C.ETD_DATE        AS ETD_DATE
                             , C.ETA_DATE        AS ETA_DATE
                             , C.TO_SITE_SHIPTO_CODE AS SHIP_TO
                          FROM SSP_ANL_SHIP_CONFIRM C
                             , SCM_MST_SITE MS
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE C.DIVISION_ID = MS.DIVISION_ID
                           AND C.FROM_SITE   = MS.SCM_SITE_ID
                           AND MS.SITE_TYPE  = 'PLANT'
                           AND C.DIVISION_ID = '40'
                           AND MS.OPERATION_GROUP = 'P'
                           AND SI.DIVISION_ID(+)  = C.DIVISION_ID
                           AND SI.ITEM_ID(+)      = C.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = C.TO_SITE
                           AND SI.PROJECT_CODE(+) = C.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = C.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = C.TO_SITE
                           AND TS.VALID_YN(+)     = 'Y'   /* NERP 추가 */
                           AND C.CHANGE_TYPE = 'C'
                           AND C.QTY > 0
                           AND C.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND P_REAL_FLAG = 'Y'
                        UNION ALL
                        /* OLD Version */
                        SELECT D.DIVISION_ID     AS DIVISION_ID
                             , NULL              AS ERP_SO_NO
                             , D.CONFIRM_ID      AS CONFIRM_ID
                             , D.ITEM_ID         AS ITEM_ID
                             , D.FROM_SITE       AS FROM_SITE
                             , V.TO_SITE         AS TO_SITE
                             , CASE WHEN D.DIVISION_ID = '4O' THEN NVL(SI.PROJECT_CODE, '/')
                                    ELSE NVL(TS.END_CUSTOMER, '-') END AS END_CUSTOMER
                             , D.QTY             AS QTY
                             , D.YYYYMMDD        AS YYYYMMDD
                             , V.TRANSPORT_MODE  AS TRANSPORT_MODE
                             , V.INCOTERMS       AS INCOTERMS
                             , D.ETD_DATE        AS ETD_DATE
                             , D.ETA_DATE        AS ETA_DATE
                             , D.SHIPTO_CODE     AS SHIP_TO
                          FROM SSP_ANL_SHIP_PLAN_P D
                             , SCP_MST_BOD_N_V V
                             , SCM_MST_SITE_ITEM SI
                             , SCM_MST_SITE TS
                         WHERE D.BOD_ID = V.BOD_ID
                           AND SI.DIVISION_ID(+)  = D.DIVISION_ID
                           AND SI.ITEM_ID(+)      = D.ITEM_ID
                           AND SI.SCM_SITE_ID(+)  = V.TO_SITE
                           AND SI.PROJECT_CODE(+) = D.PROJECT_CODE
                           AND TS.DIVISION_ID(+)  = D.DIVISION_ID
                           AND TS.SCM_SITE_ID(+)  = V.TO_SITE
                           AND TS.VALID_YN(+)     = 'Y'   /* NERP 추가 */
                           AND D.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                           AND D.MEASURE      = 'SHIP_CONFIRM'
                           AND D.CONFIRM_FLAG = 'Y'
                           AND D.QTY > 0
                           AND D.YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                           AND P_REAL_FLAG = 'N'
                       ) XC
               ) X
             , SCM_MST_SITE B
             , SCM_ADM_LOOKUP_MASTER_DETAIL C
             , SSP_MST_MODEL_USER M
               /* 20211126  SMS  추가  Shipto Description */
             , (SELECT DIVISION_ID, SHIPTO_CODE, MAX(SHIPTO_DESCRIPTION) AS SHIPTO_DESCRIPTION
                  FROM SCM_MST_CUSTOMER
                 WHERE DIVISION_ID = '40'
                 GROUP BY DIVISION_ID, SHIPTO_CODE) D
         WHERE B.DIVISION_ID = X.DIVISION_ID
           AND B.SCM_SITE_ID = X.FROM_SITE
           AND B.OPERATION_GROUP <> 'E'
           AND C.LOOKUP_TYPE = 'SSP_SHIPMENT_RESULT_TYPE_PACKER'   /* LOOKUP에 등록된 공정만 */
           AND C.SEGMENT1    = X.TYPE
           AND C.VALID_YN    = 'Y'
           AND M.DIVISION_ID(+) = X.DIVISION_ID
           AND M.FROM_SITE(+)   = X.FROM_SITE
           AND M.ITEM_ID(+)     = X.ITEM_ID
           AND M.VALID_YN(+)    = 'Y'
           AND X.DIVISION_ID = D.DIVISION_ID(+)
           AND X.SHIP_TO     = D.SHIPTO_CODE(+)
           AND X.DIVISION_ID = P_DIVISION_ID
           AND ((P_COMPANY_ID IS NULL OR P_COMPANY_ID = '') OR B.COMPANY_ID = P_COMPANY_ID)
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR X.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR X.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR X.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_TYPE IS NULL OR P_TYPE = '')
                 OR X.TYPE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_TYPE, ','))))
           /* 체크박스 체크 여부 조회 시작(P_NONCHK = 'Y' : 체크박스 선택 안한 상태) */
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR M.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                   UNION
                                  SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                    FROM SSP_MST_DELEGATE
                                   WHERE VALID_YN = 'Y'
                                     AND DELEGATEE_ID = P_USER_ID
                                   GROUP BY USER_ID)
                 OR M.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR M.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
           /* 체크박스 체크 여부 조회 끝 */
         ORDER BY X.DIVISION_ID
             , X.FROM_SITE
             , X.YYYYMMDD
             , X.ITEM_ID
             , X.TO_SITE
             , C.DISPLAY_SEQ
             , X.CONFIRM_ID;

    END P_SSP0015_GET_SHIPMENT_RESULT_PACKER;


    /* ============================================================
       P_SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING
       AS-IS SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING
       ※ 오류 시 되돌리기를 커서 OPEN 앞에 둔다(ROLLBACK 이 뒤에 오면 커서가 닫힌다).
       ============================================================ */
    PROCEDURE P_SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING
    (
        P_CHANGE_REQUEST_NO     IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING
         * Description  : Shipment Plan Change 작성중 삭제
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_PROGRAM_NAME      VARCHAR2(150 CHAR) := 'SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING';
        V_LOG_TYPE          VARCHAR2(30 CHAR);
        N_LOG_COUNT         NUMBER := 0;
        V_LOG_MESSAGE       VARCHAR2(1000 CHAR);
        V_DESCRIPTION       VARCHAR2(500 CHAR);
        D_EVENT_DATE        DATE;
        V_LAST_UPDATE_DATE  DATE := SYSDATE;
        V_ERR_CODE          NUMBER;
        V_ERR_MESSAGE       VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_DEL_DRAFT;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := V_LAST_UPDATE_DATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ
           SET VALID_YN         = 'N'
             , LAST_UPDATED_BY  = P_USER_ID
             , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;

        UPDATE SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
           SET VALID_YN         = 'N'
             , LAST_UPDATED_BY  = P_USER_ID
             , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
         WHERE CHANGE_REQ_NO = P_CHANGE_REQUEST_NO;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드 반환 */
        OPEN O_RC1 FOR SELECT 'S' AS RESULT_CODE FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_DEL_DRAFT;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE FROM DUAL;
            OPEN O_RC2 FOR SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0015_DELETE_SHIPMENT_REQUEST_DRAFTING;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
       AS-IS SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
       ※ AS-IS 는 문자열을 조립해 EXEC 로 돌리지만 만드는 것은 선택조건뿐이다.
          날짜 칸을 만드는 피벗이 아니므로 정적 SQL 로 옮겼다.
       ※ P_REAL_FLAG 갈래에 따라 결과셋의 칸 구성이 다르다(AS-IS 동일).
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_REQUESTOR             IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_REAL_FLAG             IN  VARCHAR2 DEFAULT 'N',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/03/11   AYJ 			Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/05/09   AYJ 			MyModel 체크여부에 따른 조회조건 분기처리
         * 2019/05/20	AYJ				[CSR ID:3994743] REQUESTOR 컬럼 추가
         * 2019/06/17	AYJ			    조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/28	AYJ			    조회 조건 추가(p_delegateeChk)
         * 2019/12/17	KIMYONGHO		[C20191216-000311] Expected Shipping Date 컬럼 추가
         * 2020/09/21   KIMYONHHO      SSP INCOTERMS 변경 작업
         * 2021/02/04   KIMYONGHO	    ETA_DATE 조회 시 항차를 고려한 LT 적용되도록 함수 적용 FN_GET_SSP_ETA_DATE
         * 2021/10/05   SHINMYUNGSU	    SSP_ANL_SHIP_CONFIRM 의 Attribute3,6 항목 추가
         * 2021/10/12   KIMYONGHO	    [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가
         * 2023/09/21   jilee          G182-P (Group='P',OSP='N')조회 추가
         * 2024/09/03   SSP            Team 컬럼 추가
         * 2024/10/01   KHJ            NERP_SSP
         * 2026.09.16   AJS            MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        IF P_REAL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
            SELECT AA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ERP_SO_NO
                         , A.SHIPMENT_STATUS
                         , A.PROJECT_CODE
                         , FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.PROJECT_CODE) AS PROJECT_NAME
                         , A.FCST_TYPE
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , CASE WHEN REGEXP_LIKE(A.YYYYMMDD, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                         , A.BEFORE_QTY                      AS BEFORE_QTY
                         , TRUNC(A.QTY)                      AS SHIPMENT_CONFIRM_QTY
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
                         , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                         , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                         , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                                ELSE (SELECT CASE WHEN REGEXP_LIKE(SA.V, '^[0-9]{8}$')
                                                  THEN TO_CHAR(TO_DATE(SA.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                        FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) AS V FROM DUAL) SA)
                           END                               AS EXPECTED_SHIPPING_DATE
                         , A.CONFIRM_ID
                         /* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
--                         , CASE WHEN U.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                           END                               AS UPDATED_BY
                         , CASE WHEN U.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                         /* 2026.09.30 AJS 수정 (END) */
                         , A.ERP_STATUS
                         , A.CHANGE_TYPE
                           /* AS-IS 는 UNION 반대편이 '-' 라 문자로 쓰인다. Oracle 은 NUMBER 라 문자로 맞춘다. */
                         , TO_CHAR(A.ROUTE_ID)               AS NEW_ROUTE_ID
                         , A.BOD_ID                          AS NEW_BOD_ID
                         , B.SSP_INCOTERMS                   AS NEW_INCOTERMS
                         , A.D_COUNTRY                       AS NEW_D_COUNTRY
                         , A.D_PORT_CODE                     AS NEW_D_PORT_CODE
                         , A.A_COUNTRY                       AS NEW_A_COUNTRY
                         , A.A_PORT_CODE                     AS NEW_A_PORT_CODE
                         , TO_CHAR(A.CUSTOMER_LT)            AS NEW_CUSTOMER_LT
                         , A.TO_COUNTRY                      AS NEW_TO_COUNTRY
                         , A.TO_CITY                         AS NEW_TO_CITY
                         , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_ETA
                         , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_ETD
                         , TO_CHAR(B.LT_TOTAL)               AS NEW_LT_DAY
                         , B.TRANSPORT_MODE                  AS NEW_TRANSPORT_MODE
                         , CASE WHEN REGEXP_LIKE(A.YYYYMMDD, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_SHIPMENT_DATE
                         , 'N'                               AS EDIT_REMARKS
                         , 'N'                               AS EDIT_MAIN
                         , NVL(A.CHECK_NEED_YN, 'N')         AS CHECK_NEED_YN
                         , NVL(CASE WHEN A.DIVISION_ID = '40'
                                    THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE != '-'
                                              THEN A.PROJECT_CODE ELSE G.PROJECT_CODE END
                                    WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                                    THEN G.PROJECT_CODE
                                    ELSE F.END_CUSTOMER END, '/') AS END_CUSTOMER
                         , A.ELECTRODE_YN
                         , A.ELECTRODE_TYPE
                         , A.ORIGIN_FROM_DIVISION_ID
                         , A.ORIGIN_TO_DIVISION_ID
                         , H.CHANGE_REQ_NO
                         /* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
                         /* 2026.09.30 AJS 수정 (END) */
                           END                               AS MODEL_USER
                         , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, ',', P_LANGUAGE) AS MTK_OWNER
                         , (SELECT NVL(MIN(SA.DEPT_NAME_KO), '-')
                              FROM SCM_MST_SSO_DEPT_INFO SA
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER SB
--                               AND SB.USERID  = SI.OWNER)    AS TEAM
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END) || '(' || A.REQUESTOR || ')'
                                 , SCM_ADM_USER_M SB
                             WHERE SA.DEPT_ID = SB.DEPT_ID(+)
                               AND SB.USER_ID = SI.OWNER)    AS TEAM
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) || '(' || A.REQUESTOR || ')'
                                 /* 2026.09.30 AJS 수정 (END) */
                           END                               AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , ''                                AS CHANGE_REASON_DETAIL
                           /* [C20211001-000241] Confirm 복사하여 신규 생성 기능 추가 */
                         , NVL(A.ATTRIBUTE10, '-')           AS ATTRIBUTE10
                           /* 2021/10/05 SHINMYUNGSU 열람 항목추가 */
                         , NVL(A.ATTRIBUTE3, '-')            AS ATTRIBUTE3
                         , NVL(A.ATTRIBUTE6, '-')            AS ATTRIBUTE6
                      FROM SSP_ANL_SHIP_CONFIRM A
                         , SCM_MST_SITE MS
                         , SCP_MST_BOD_N_V B
                         /* 2026.09.30 AJS 수정 (START) */
--                         , TB_FX_USER U
                         , SCM_ADM_USER_M U
                         /* 2026.09.30 AJS 수정 (END) */
                         , SCM_MST_SITE F
                         , (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                              FROM (SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID
                                         , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) AS NUM
                                      FROM SCM_MST_SITE_ITEM)
                             WHERE NUM = 1) G
                         , (SELECT CONFIRM_ID, CHANGE_REQ_NO
                              FROM (SELECT CONFIRM_ID, CHANGE_REQ_NO
                                         , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) AS NUM
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                     WHERE VALID_YN = 'Y')
                             WHERE NUM = 1) H
                         , SSP_MST_MODEL_USER MU
                         /* 2026.09.30 AJS 수정 (START) */
--                         , TB_FX_USER U2
--                         , TB_FX_USER U3
                         , SCM_ADM_USER_M U2
                         , SCM_ADM_USER_M U3
                         /* 2026.09.30 AJS 수정 (END) */
                         , SCM_MST_SITE_ITEM SI
                         , SSP_ANL_SHIP_CONFIRM_CHG_REQ T1
                     WHERE A.DIVISION_ID = MS.DIVISION_ID
                       AND A.FROM_SITE   = MS.SCM_SITE_ID
                       AND MS.SITE_TYPE  = 'PLANT'
                       AND A.DIVISION_ID = '40'
                       AND (MS.OPERATION_GROUP = 'A' OR MS.OSP_YN = 'N')
                       AND CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END = B.DIVISION_ID
                       AND A.BOD_ID      = B.BOD_ID
                       /* 2026.09.30 AJS 수정 (START) */
--                       AND A.LAST_UPDATED_BY = U.USERID(+)
--                       AND U.USEYN(+)        = 'Y'
                       AND A.LAST_UPDATED_BY = U.USER_ID(+)
                       AND U.USE_YN(+)       = 'Y'
                       /* 2026.09.30 AJS 수정 (END) */
                       AND F.DIVISION_ID(+)  = A.ORIGIN_TO_DIVISION_ID
                       AND F.SCM_SITE_ID(+)  = A.TO_SITE
                       AND F.VALID_YN(+)     = 'Y'
                       AND G.DIVISION_ID(+)  = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND G.SCM_SITE_ID(+)  = A.TO_SITE
                       AND G.ITEM_ID(+)      = A.ITEM_ID
                       AND H.CONFIRM_ID(+)   = A.CONFIRM_ID
                       AND MU.DIVISION_ID(+) = A.ORIGIN_FROM_DIVISION_ID
                       AND MU.FROM_SITE(+)   = A.FROM_SITE
                       AND MU.ITEM_ID(+)     = A.ITEM_ID
                       AND MU.VALID_YN(+)    = 'Y'
                       /* 2026.09.30 AJS 수정 (START) */
--                       AND MU.USER_ID        = U2.USERID(+)
--                       AND U2.USEYN(+)       = 'Y'
--                       AND A.REQUESTOR       = U3.USERID(+)
--                       AND U3.USEYN(+)       = 'Y'
                       AND MU.USER_ID        = U2.USER_ID(+)
                       AND U2.USE_YN(+)      = 'Y'
                       AND A.REQUESTOR       = U3.USER_ID(+)
                       AND U3.USE_YN(+)      = 'Y'
                       /* 2026.09.30 AJS 수정 (END) */
                       AND SI.DIVISION_ID(+)  = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND SI.SCM_SITE_ID(+)  = A.TO_SITE
                       AND SI.ITEM_ID(+)      = A.ITEM_ID
                       AND SI.PROJECT_CODE(+) = A.PROJECT_CODE
                       AND H.CHANGE_REQ_NO    = T1.CHANGE_REQ_NO(+)
                       /* Search 버튼으로 조회(체크박스 체크 여부에 따라 조회) */
                       AND (P_SEARCH_YN != 'Y'
                             OR ((P_NONCHK = 'Y' AND 1 = 1)
                                  OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                     UNION
                                                    SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                      FROM SSP_MST_DELEGATE
                                                     WHERE VALID_YN = 'Y'
                                                       AND DELEGATEE_ID = P_USER_ID
                                                     GROUP BY USER_ID)
                                  OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                  OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                       AND A.YYYYMMDD >= P_FROM_YYYYMMDD
                       AND A.YYYYMMDD <= P_TO_YYYYMMDD
                       AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                             OR  UPPER(P_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                             OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                             OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                           OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                             OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                             OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                             OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                             /* 2026.09.30 AJS 수정 (START) */
--                             OR A.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                  FROM TB_FX_USER SA
--                                                 WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                    OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                             OR A.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                  FROM SCM_ADM_USER_M SA
                                                 WHERE SA.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                    OR SA.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                             /* 2026.09.30 AJS 수정 (END) */
                       AND A.SHIPMENT_STATUS IS NOT NULL
                       AND A.QTY > 0
                       AND A.CHANGE_TYPE <> 'N'
                       AND A.BIZ_TYPE    <> 'E'
                    UNION ALL
                    SELECT T.DIVISION_ID
                         , T.ERP_SO_NO
                         , T.SHIPMENT_STATUS
                         , T.PROJECT_CODE
                         , T.PROJECT_NAME
                         , T.FCST_TYPE
                         , T.ITEM_ID
                         , T.NICK_NAME
                         , CASE WHEN REGEXP_LIKE(T.SHIPMENT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(T.SHIPMENT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                         , 0                                 AS BEFORE_QTY
                         , T.QTY                             AS SHIPMENT_CONFIRM_QTY
                         , T.REMARKS
                         , T.REMARKS2
                         , T.REMARKS3
                         , T.FROM_SITE
                         , T.FROM_SITE_DESCRIPTION
                         , T.TO_SITE
                         , T.TO_SITE_DESCRIPTION
                         , T.TO_SITE_SOLDTO_CODE
                         , T.TO_SITE_SHIPTO_CODE
                         , T.SOLDTO_DESCRIPTION
                         , T.SHIPTO_DESCRIPTION
                         , T.BOD_ID
                         , T.INCOTERMS
                         , T.TRANSPORT_MODE
                         , T.LT_TOTAL                        AS LT_DAY
                         , T.ETD
                         , T.ETA
                         , T.EXPECTED_SHIPPING_DATE
                         , T.CONFIRM_ID
                         , T.LAST_UPDATED_BY                 AS UPDATED_BY
                         , T.LAST_UPDATE_DATE                AS UPDATED_DATE
                         , '-'                               AS ERP_STATUS
                         , '-'                               AS CHANGE_TYPE
                         , '-'                               AS NEW_ROUTE_ID
                         , '-'                               AS NEW_BOD_ID
                         , '-'                               AS NEW_INCOTERMS
                         , '-'                               AS NEW_D_COUNTRY
                         , '-'                               AS NEW_D_PORT_CODE
                         , '-'                               AS NEW_A_COUNTRY
                         , '-'                               AS NEW_A_PORT_CODE
                         , '-'                               AS NEW_CUSTOMER_LT
                         , '-'                               AS NEW_TO_COUNTRY
                         , '-'                               AS NEW_TO_CITY
                         , '-'                               AS NEW_ETA
                         , '-'                               AS NEW_ETD
                         , '-'                               AS NEW_LT_DAY
                         , '-'                               AS NEW_TRANSPORT_MODE
                         , '-'                               AS NEW_SHIPMENT_DATE
                         , '-'                               AS EDIT_REMARKS
                         , '-'                               AS EDIT_MAIN
                         , '-'                               AS CHECK_NEED_YN
                         , '-'                               AS END_CUSTOMER
                         , '-'                               AS ELECTRODE_YN
                         , '-'                               AS ELECTRODE_TYPE
                         , '-'                               AS ORIGIN_FROM_DIVISION_ID
                         , '-'                               AS ORIGIN_TO_DIVISION_ID
                         , '-'                               AS CHANGE_REQ_NO
                         , '-'                               AS MODEL_USER
                         , TO_CLOB('-')                      AS MTK_OWNER
                         , '-'                               AS TEAM
                         , '-'                               AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , '-'                               AS CHANGE_REASON_DETAIL
                         , '-'                               AS ATTRIBUTE10
                         , '-'                               AS ATTRIBUTE3
                         , '-'                               AS ATTRIBUTE6
                      FROM (
                            SELECT TT0.DIVISION_ID
                                 , NULL                       AS ERP_SO_NO
                                 , 'P'                        AS SHIPMENT_STATUS
                                 , TT0.ITEM_ID
                                 , FN_GET_ITEM_NICKNAME(TT0.DIVISION_ID, TT0.ITEM_ID) AS NICK_NAME
                                 , TT0.DIVISION_ID            AS ORIGIN_FROM_DIVISION_ID
                                 , TT0.DIVISION_ID            AS ORIGIN_TO_DIVISION_ID
                                 , TT0.PLANT_SITE_ID          AS FROM_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT0.PLANT_SITE_ID), '-') AS FROM_SITE_DESCRIPTION
                                 , TT0.SCM_SITE_ID            AS TO_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT0.SCM_SITE_ID), '-')   AS TO_SITE_DESCRIPTION
                                 , TT0.PROJECT_CODE
                                 , FN_GET_PROJECT_NAME(TT0.DIVISION_ID, TT0.PROJECT_CODE) AS PROJECT_NAME
                                 , '-'                        AS REQUESTOR
                                 , TT0.QTY
                                 , TT0.YYYYMMDD               AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT0.INCOTERMS
                                 , TT0.TRANSPORT_MODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SOLDTO_CODE')        AS TO_SITE_SOLDTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SHIPTO_CODE')        AS TO_SITE_SHIPTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT0.SCM_SITE_ID, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                                 , '-'                        AS REMARKS2
                                 , '-'                        AS REMARKS
                                 , '-'                        AS CHANGE_REQ_NO
                                 , '-'                        AS REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                                 , (SELECT CASE WHEN REGEXP_LIKE(SA.V, '^[0-9]{8}$')
                                                THEN TO_CHAR(TO_DATE(SA.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                      FROM (SELECT FN_GET_SSP_ETA_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SA) AS ETA
                                 , CASE WHEN TT0.TRANSPORT_MODE = 'TRK' THEN '-'
                                        ELSE (SELECT CASE WHEN REGEXP_LIKE(SB.V, '^[0-9]{8}$')
                                                          THEN TO_CHAR(TO_DATE(SB.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                                FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SB)
                                   END                        AS EXPECTED_SHIPPING_DATE
                                 , TT1.LT_TOTAL
                                 , TT0.LAST_UPDATED_BY
                                 , TT0.LAST_UPDATE_DATE
                                 , '-'                        AS CONFIRM_ID
                                 , TT0.FCST_TYPE
                                 , CASE WHEN NVL(TT2.SHIP_FROZEN, 0) > 0
                                        THEN TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(TT2.SHIP_FROZEN, 0), 'YYYYMMDD')
                                        ELSE P_PLAN_START_YYYYMMDD END AS FROZEN_YYYYMMDD
                              FROM DM_PLN_SHIPMENT_REQ TT0
                                 , SCP_MST_BOD_N_V TT1
                                 , SCM_MST_SITE TT2
                                 , SSP_MST_MODEL_USER MU
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER U2
                                 , SCM_ADM_USER_M U2
                                 /* 2026.09.30 AJS 수정 (END) */
                             WHERE TT0.DIVISION_ID = TT1.DIVISION_ID
                               AND TT0.BOD_ID      = TT1.BOD_ID
                               AND TT0.DIVISION_ID = TT2.DIVISION_ID
                               AND TT0.PLANT_SITE_ID = TT2.SCM_SITE_ID
                               AND TT2.SITE_TYPE   = 'PLANT'
                               AND TT2.VALID_YN    = 'Y'
                               AND MU.DIVISION_ID(+) = TT0.DIVISION_ID
                               AND MU.FROM_SITE(+)   = TT0.PLANT_SITE_ID
                               AND MU.ITEM_ID(+)     = TT0.ITEM_ID
                               AND MU.VALID_YN(+)    = 'Y'
                               /* 2026.09.30 AJS 수정 (START) */
--                               AND MU.USER_ID        = U2.USERID(+)
--                               AND U2.USEYN(+)       = 'Y'
                               AND MU.USER_ID        = U2.USER_ID(+)
                               AND U2.USE_YN(+)      = 'Y'
                               /* 2026.09.30 AJS 수정 (END) */
                               AND TT0.DIVISION_ID   = P_DIVISION_ID
                               AND (P_SEARCH_YN != 'Y'
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                             UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN = 'Y'
                                                               AND DELEGATEE_ID = P_USER_ID
                                                             GROUP BY USER_ID)
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                           ) T
                     WHERE 1 = 1
                       AND T.SHIPMENT_DATE >= T.FROZEN_YYYYMMDD
                       AND T.SHIPMENT_DATE >= P_FROM_YYYYMMDD
                       AND T.SHIPMENT_DATE <= P_TO_YYYYMMDD
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                             OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                           OR T.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                             OR T.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                             OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                             OR T.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                             /* 2026.09.30 AJS 수정 (START) */
--                             OR T.LAST_UPDATED_BY IN (SELECT DISTINCT SA.USERID
--                                                        FROM TB_FX_USER SA
--                                                       WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                          OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                             OR T.LAST_UPDATED_BY IN (SELECT DISTINCT SA.USER_ID
                                                        FROM SCM_ADM_USER_M SA
                                                       WHERE SA.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                          OR SA.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                             /* 2026.09.30 AJS 수정 (END) */
                   ) AA
             ORDER BY AA.DIVISION_ID
                 , AA.SHIPMENT_STATUS
                 , AA.SHIPMENT_DATE
                 , AA.ITEM_ID
                 , AA.ERP_SO_NO DESC
                 , AA.FROM_SITE
                 , AA.TO_SITE
                 , AA.PROJECT_CODE
                 , AA.FCST_TYPE;

        ELSE

            OPEN O_RC1 FOR
            SELECT AA.*
              FROM (
                    SELECT T0.DIVISION_ID
                         , T0.ERP_SO_NO
                         , T0.SHIPMENT_STATUS
                         , T0.PROJECT_CODE
                         , T0.PROJECT_NAME
                         , T0.FCST_TYPE
                         , T0.ITEM_ID
                         , T0.NICK_NAME
                         , T0.SHIPMENT_DATE
                         , T0.SHIPMENT_CONFIRM_QTY
                         , T0.REMARKS
                         , T0.REMARKS2
                         , T0.REMARKS3
                         , T0.FROM_SITE
                         , T0.FROM_SITE_DESCRIPTION
                         , T0.TO_SITE
                         , T0.TO_SITE_DESCRIPTION
                         , T0.TO_SITE_SOLDTO_CODE
                         , T0.TO_SITE_SHIPTO_CODE
                         , T0.SOLDTO_DESCRIPTION
                         , T0.SHIPTO_DESCRIPTION
                         , T0.BOD_ID
                         , T0.INCOTERMS
                         , T0.TRANSPORT_MODE
                         , T0.LT_DAY
                         , T0.ETD
                         , T0.ETA
                         , T0.EXPECTED_SHIPPING_DATE
                         , T0.CONFIRM_ID
                         , T0.UPDATED_BY
                         , T0.UPDATED_DATE
                         , '-'                               AS ERP_STATUS
                         , '-'                               AS CHANGE_TYPE
                         , '-'                               AS NEW_ROUTE_ID
                         , '-'                               AS NEW_BOD_ID
                         , '-'                               AS NEW_INCOTERMS
                         , '-'                               AS NEW_D_COUNTRY
                         , '-'                               AS NEW_D_PORT_CODE
                         , '-'                               AS NEW_A_COUNTRY
                         , '-'                               AS NEW_A_PORT_CODE
                         , '-'                               AS NEW_CUSTOMER_LT
                         , '-'                               AS NEW_TO_COUNTRY
                         , '-'                               AS NEW_TO_CITY
                         , '-'                               AS NEW_ETA
                         , '-'                               AS NEW_ETD
                         , '-'                               AS NEW_LT_DAY
                         , '-'                               AS NEW_TRANSPORT_MODE
                         , '-'                               AS NEW_SHIPMENT_DATE
                         , '-'                               AS EDIT_REMARKS
                         , '-'                               AS EDIT_MAIN
                         , '-'                               AS CHECK_NEED_YN
                         , T0.END_CUSTOMER                   AS END_CUSTOMER
                         , '-'                               AS ELECTRODE_YN
                         , '-'                               AS ELECTRODE_TYPE
                         , '-'                               AS ORIGIN_FROM_DIVISION_ID
                         , '-'                               AS ORIGIN_TO_DIVISION_ID
                         , T0.CHANGE_REQ_NO                  AS CHANGE_REQ_NO
                         , T0.MODEL_USER                     AS MODEL_USER
                         , T0.MTK_OWNER                      AS MTK_OWNER
                         , T0.REQUESTOR                      AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , '-'                               AS CHANGE_REASON_DETAIL
                         , '-'                               AS ATTRIBUTE10
                         , T0.ATTRIBUTE3
                         , T0.ATTRIBUTE6
                      FROM (
                            SELECT TT0.DIVISION_ID
                                 , TT0.ERP_SO_NO
                                 , TT0.SHIPMENT_STATUS
                                 , TT0.ITEM_ID
                                 , TT0.NICK_NAME
                                 , TT0.ORIGIN_FROM_DIVISION_ID
                                 , TT0.ORIGIN_TO_DIVISION_ID
                                 , TT0.FROM_SITE
                                 , TT0.FROM_SITE_DESCRIPTION
                                 , TT0.TO_SITE
                                 , TT0.TO_SITE_DESCRIPTION
                                 , TT0.PROJECT_CODE
                                 , TT0.PROJECT_NAME
                                 , TT0.REQUESTOR
                                 , TT0.SHIPMENT_CONFIRM_QTY
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT0.INCOTERMS
                                 , TT0.TRANSPORT_MODE
                                 , TT0.TO_SITE_SOLDTO_CODE
                                 , TT0.TO_SITE_SHIPTO_CODE
                                 , TT0.SOLDTO_DESCRIPTION
                                 , TT0.SHIPTO_DESCRIPTION
                                 , TT0.REMARKS2
                                 , TT0.REMARKS
                                 , TT0.CHANGE_REQ_NO
                                 , TT0.REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.ETD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                                 , CASE WHEN REGEXP_LIKE(TT0.ETA, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETA, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                                 , TT0.EXPECTED_SHIPPING_DATE
                                 , TT0.LT_DAY                AS LT_DAY
                                 , TT0.UPDATED_BY            AS UPDATED_BY
                                 , TT0.UPDATED_DATE          AS UPDATED_DATE
                                 , TT0.CONFIRM_ID            AS CONFIRM_ID
                                 , TT0.FCST_TYPE
                                 , TT0.END_CUSTOMER
                                 , TT0.MTK_OWNER
                                 , TT0.MODEL_USER
                                   /* 2021/10/05 SHINMYUNGSU 열람 항목추가 */
                                 , '-'                       AS ATTRIBUTE3
                                 , '-'                       AS ATTRIBUTE6
                              FROM SSP_ANL_SHIP_PLAN_ALL TT0
                                 , SSP_MST_MODEL_USER MU
                             WHERE MU.DIVISION_ID(+) = TT0.ORIGIN_FROM_DIVISION_ID
                               AND MU.FROM_SITE(+)   = TT0.FROM_SITE
                               AND MU.ITEM_ID(+)     = TT0.ITEM_ID
                               AND MU.VALID_YN(+)    = 'Y'
                               AND TT0.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                               AND TT0.DIVISION_ID         = P_DIVISION_ID
                               AND TT0.SHIPMENT_CONFIRM_QTY > 0
                               AND TT0.OPERATION_GROUP     <> 'E'
                               AND TT0.YYYYMMDD >= P_FROM_YYYYMMDD
                               AND TT0.YYYYMMDD <= P_TO_YYYYMMDD
                               AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                                     OR  UPPER(P_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT0.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                                     OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                   OR TT0.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                                     OR TT0.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                     OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT0.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                               AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                            FROM TB_FX_USER SA
--                                                           WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                              OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                            FROM SCM_ADM_USER_M SA
                                                           WHERE SA.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                              OR SA.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     /* 2026.09.30 AJS 수정 (END) */
                               AND (P_SEARCH_YN != 'Y'
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                             UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN = 'Y'
                                                               AND DELEGATEE_ID = P_USER_ID
                                                             GROUP BY USER_ID)
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                           ) T0
                   ) AA
             ORDER BY AA.DIVISION_ID
                 , AA.SHIPMENT_STATUS
                 , AA.SHIPMENT_DATE
                 , AA.ITEM_ID
                 , AA.ERP_SO_NO DESC
                 , AA.FROM_SITE
                 , AA.TO_SITE
                 , AA.PROJECT_CODE
                 , AA.FCST_TYPE;

        END IF;

    END P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL;


    /* ============================================================
       P_SSP0015_SAVE_SHIPMENT_PSI
       AS-IS SSP0015_SAVE_SHIPMENT_PSI
       ※ '^' 로 이어 붙인 여러 행을 SCM_ARR_SPL_VAL 로 잘라 한 행씩 처리한다(AS-IS 동일).
       ※ 저장 시작에 SAVEPOINT 를 두어 중간 오류 시 앞 행 저장분까지 되돌린다.
       ※ AS-IS 의 @debug_mode PRINT 구간은 옮기지 않는다.
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_PSI
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_PSI
         * Description  : Shipment PSI 수량 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := '[SSP0015_SAVE_SHIPMENT_PSI]';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        V_DELIMITER             VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_FROM_SITE             VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_YYYYMMDD              VARCHAR2(4000 CHAR);
        V_PLAN_TYPE             VARCHAR2(4000 CHAR);
        V_SEQ                   VARCHAR2(4000 CHAR);
        V_MEASURE               VARCHAR2(4000 CHAR);
        V_QTY                   VARCHAR2(4000 CHAR);
        V_LAST_UPDATED_BY       VARCHAR2(150 CHAR) := P_USER_ID;
        V_LAST_UPDATE_DATE      DATE := SYSDATE;

        V_COMMENTS_CNT          PLS_INTEGER := 0;
        V_OLD_QTY               NUMBER;
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_PSI;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE LENGTH(RTRIM(P_ACTIVE_FLAG)) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG         := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID         := SCM_ARR_SPL_VAL(P_DIVISION_ID,         V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE           := SCM_ARR_SPL_VAL(P_FROM_SITE,           V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID             := SCM_ARR_SPL_VAL(P_ITEM_ID,             V_DELIMITER, V_MST_LOOP_CNT);
            V_PLAN_START_YYYYMMDD := SCM_ARR_SPL_VAL(P_PLAN_START_YYYYMMDD, V_DELIMITER, V_MST_LOOP_CNT);
            V_YYYYMMDD            := SCM_ARR_SPL_VAL(P_YYYYMMDD,            V_DELIMITER, V_MST_LOOP_CNT);
            V_PLAN_TYPE           := SCM_ARR_SPL_VAL(P_PLAN_TYPE,           V_DELIMITER, V_MST_LOOP_CNT);
            V_SEQ                 := SCM_ARR_SPL_VAL(P_SEQ,                 V_DELIMITER, V_MST_LOOP_CNT);
            V_MEASURE             := SCM_ARR_SPL_VAL(P_MEASURE,             V_DELIMITER, V_MST_LOOP_CNT);
            V_QTY                 := SCM_ARR_SPL_VAL(P_QTY,                 V_DELIMITER, V_MST_LOOP_CNT);

            /* 데이터 저장 - 수정 */
            IF V_ACTIVE_FLAG = 'M' OR V_ACTIVE_FLAG = 'I' THEN

                V_OLD_QTY := NULL;

                BEGIN
                    SELECT QTY
                      INTO V_OLD_QTY
                      FROM SSP_ANL_SHIP_PLAN_40
                     WHERE DIVISION_ID         = V_DIVISION_ID
                       AND FROM_SITE           = V_FROM_SITE
                       AND ITEM_ID             = V_ITEM_ID
                       AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND YYYYMMDD            = V_YYYYMMDD
                       AND PLAN_TYPE           = V_PLAN_TYPE
                       AND SEQ                 = V_SEQ
                       AND MEASURE             = V_MEASURE
                       AND ROWNUM              = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_OLD_QTY := NULL;
                END;

                /*//COMMENTS 변경 내용 저장 Start*/
                SELECT COUNT(*)
                  INTO V_COMMENTS_CNT
                  FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
                 WHERE 1 = 1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND FROM_SITE   = V_FROM_SITE
                   AND ITEM_ID     = V_ITEM_ID
                   AND YYYYMMDD    = V_YYYYMMDD;

                IF V_COMMENTS_CNT > 0 THEN
                    /*//COMMENTS UPDATE*/
                    UPDATE SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
                       SET COMMENTS         = NULL
                         , USER_ADD_QTY     = V_QTY
                         , LAST_UPDATED_BY  = P_USER_ID
                         , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                         , ATTRIBUTE1       = V_OLD_QTY
                     WHERE 1 = 1
                       AND DIVISION_ID = V_DIVISION_ID
                       AND FROM_SITE   = V_FROM_SITE
                       AND ITEM_ID     = V_ITEM_ID
                       AND YYYYMMDD    = V_YYYYMMDD;
                ELSE
                    /*//COMMENTS INSERT*/
                    INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
                           (DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, USER_ADD_QTY
                          , COMMENTS, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                          , ATTRIBUTE1)
                    VALUES (V_DIVISION_ID, V_FROM_SITE, V_ITEM_ID, V_YYYYMMDD, V_QTY
                          , NULL, V_LAST_UPDATE_DATE, P_USER_ID, V_LAST_UPDATE_DATE
                          , V_OLD_QTY);
                END IF;

                /*//HISTORY INSERT*/
                INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H
                       (HISTORY_SEQ
                      , DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, USER_ADD_QTY
                      , COMMENTS, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                      , HISTORY_CREATION_DATE, ATTRIBUTE1)
                SELECT SEQ1_SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H.NEXTVAL
                      , DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, USER_ADD_QTY
                      , COMMENTS, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                      , SYSDATE, ATTRIBUTE1
                  FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
                 WHERE 1 = 1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND FROM_SITE   = V_FROM_SITE
                   AND ITEM_ID     = V_ITEM_ID
                   AND YYYYMMDD    = V_YYYYMMDD;
                /*//COMMENTS 내용 저장 End*/

                UPDATE SSP_ANL_SHIP_PLAN_40
                   SET QTY              = V_QTY
                     , LAST_UPDATED_BY  = V_LAST_UPDATED_BY
                     , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                 WHERE DIVISION_ID         = V_DIVISION_ID
                   AND FROM_SITE           = V_FROM_SITE
                   AND ITEM_ID             = V_ITEM_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND YYYYMMDD            = V_YYYYMMDD
                   AND PLAN_TYPE           = V_PLAN_TYPE
                   AND SEQ                 = V_SEQ
                   AND MEASURE             = V_MEASURE;

                /* EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 - AS-IS 주석 처리 상태 유지 */

                INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_H
                       (HISTORY_SEQ
                      , DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                      , ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                      , YYYYMMDD, BOD_ID, QTY, ROUTE_ID
                      , INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                      , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                      , ETA_DATE, CONFIRM_FLAG, CONFIRM_ID, CREATED_BY
                      , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ELECTRODE_YN
                      , ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, HISTORY_CREATION_DATE)
                SELECT SEQ1_SSP_ANL_SHIP_PLAN_40_WH_IN_H.NEXTVAL
                      , DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                      , ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                      , YYYYMMDD, BOD_ID, QTY, ROUTE_ID
                      , INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                      , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                      , ETA_DATE, CONFIRM_FLAG, CONFIRM_ID, CREATED_BY
                      , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ELECTRODE_YN
                      , ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SYSDATE
                  FROM SSP_ANL_SHIP_PLAN_40
                 WHERE DIVISION_ID         = V_DIVISION_ID
                   AND FROM_SITE           = V_FROM_SITE
                   AND ITEM_ID             = V_ITEM_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND YYYYMMDD            = V_YYYYMMDD
                   AND PLAN_TYPE           = V_PLAN_TYPE
                   AND SEQ                 = V_SEQ
                   AND MEASURE             = V_MEASURE;

            END IF;

        END LOOP;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S' AS RESULT_CODE, V_MST_LOOP_CNT AS RESULT_CNT FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_CODE, NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_PSI;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE, 0 AS RESULT_CNT FROM DUAL;
            OPEN O_RC2 FOR SELECT V_ERR_CODE AS ERR_CODE, V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0015_SAVE_SHIPMENT_PSI;


    /* ============================================================
       P_SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
       AS-IS SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
       ※ 오류 시 되돌리기를 커서 OPEN 앞에 둔다.
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
    (
        P_CHANGE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_YYYYMMDD              IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_MEASURE               IN  VARCHAR2,
        P_QTY                   IN  VARCHAR2,
        P_PRODQTY               IN  VARCHAR2,
        P_COMMENTS              IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_PSI_COMMENTS
         * Description  : Shipment PSI Comments 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := '[SSP0015_SAVE_SHIPMENT_PSI_COMMENTS]';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        V_LAST_UPDATE_DATE      DATE := SYSDATE;
        V_COMMENTS_CNT          PLS_INTEGER := 0;
        V_OLD_QTY               NUMBER;
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_PSI_CMT;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        IF P_CHANGE_FLAG = 'Y' THEN

            V_OLD_QTY := NULL;

            BEGIN
                SELECT QTY
                  INTO V_OLD_QTY
                  FROM SSP_ANL_SHIP_PLAN_40
                 WHERE DIVISION_ID         = P_DIVISION_ID
                   AND FROM_SITE           = P_FROM_SITE
                   AND ITEM_ID             = P_ITEM_ID
                   AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                   AND YYYYMMDD            = P_YYYYMMDD
                   AND PLAN_TYPE           = P_PLAN_TYPE
                   AND SEQ                 = P_SEQ
                   AND MEASURE             = P_MEASURE
                   AND ROWNUM              = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_OLD_QTY := NULL;
            END;

            /*//PSI 변경 내용 저장 Start*/
            /* [C20200506-000210] USER_ADD_QTY 추가 - Change Qty + Prod Qty로 변경. Change Qty 음수 가능 */
            UPDATE SSP_ANL_SHIP_PLAN_40
               SET QTY              = CEIL(TO_NUMBER(P_QTY)) + CEIL(TO_NUMBER(P_PRODQTY))
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
             WHERE 1 = 1
               AND DIVISION_ID         = P_DIVISION_ID
               AND FROM_SITE           = P_FROM_SITE
               AND ITEM_ID             = P_ITEM_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND YYYYMMDD            = P_YYYYMMDD
               AND PLAN_TYPE           = P_PLAN_TYPE
               AND SEQ                 = P_SEQ
               AND MEASURE             = P_MEASURE;

            /* [C20200506-000210] USER_ADD_QTY 추가 */
            INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_H
                   (HISTORY_SEQ
                  , DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                  , ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, USER_ADD_QTY, BOD_ID, QTY, ROUTE_ID
                  , INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                  , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                  , ETA_DATE, CONFIRM_FLAG, CONFIRM_ID, CREATED_BY
                  , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ELECTRODE_YN
                  , ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, HISTORY_CREATION_DATE)
            SELECT SEQ1_SSP_ANL_SHIP_PLAN_40_WH_IN_H.NEXTVAL
                  , DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                  , ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, P_QTY, BOD_ID, QTY, ROUTE_ID
                  , INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                  , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE
                  , ETA_DATE, CONFIRM_FLAG, CONFIRM_ID, CREATED_BY
                  , CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE, ELECTRODE_YN
                  , ELECTRODE_TYPE, ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID, SYSDATE
              FROM SSP_ANL_SHIP_PLAN_40
             WHERE 1 = 1
               AND DIVISION_ID         = P_DIVISION_ID
               AND FROM_SITE           = P_FROM_SITE
               AND ITEM_ID             = P_ITEM_ID
               AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND YYYYMMDD            = P_YYYYMMDD
               AND PLAN_TYPE           = P_PLAN_TYPE
               AND SEQ                 = P_SEQ
               AND MEASURE             = P_MEASURE;
            /*//PSI 변경 내용 저장 End*/

        END IF;

        SELECT COUNT(*)
          INTO V_COMMENTS_CNT
          FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
         WHERE 1 = 1
           AND DIVISION_ID = P_DIVISION_ID
           AND FROM_SITE   = P_FROM_SITE
           AND ITEM_ID     = P_ITEM_ID
           AND YYYYMMDD    = P_YYYYMMDD;

        /*//COMMENTS 변경 내용 저장 Start*/
        IF V_COMMENTS_CNT > 0 THEN
            /*//COMMENTS UPDATE*/
            UPDATE SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
               SET COMMENTS         = P_COMMENTS
                 , USER_ADD_QTY     = P_QTY
                 , LAST_UPDATED_BY  = P_USER_ID
                 , LAST_UPDATE_DATE = V_LAST_UPDATE_DATE
                 , ATTRIBUTE1       = V_OLD_QTY
             WHERE 1 = 1
               AND DIVISION_ID = P_DIVISION_ID
               AND FROM_SITE   = P_FROM_SITE
               AND ITEM_ID     = P_ITEM_ID
               AND YYYYMMDD    = P_YYYYMMDD;
        ELSE
            /*//COMMENTS INSERT*/
            INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
                   (DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, USER_ADD_QTY
                  , COMMENTS, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                  , ATTRIBUTE1)
            VALUES (P_DIVISION_ID, P_FROM_SITE, P_ITEM_ID, P_YYYYMMDD, P_QTY
                  , P_COMMENTS, V_LAST_UPDATE_DATE, P_USER_ID, V_LAST_UPDATE_DATE
                  , V_OLD_QTY);
        END IF;

        /*//HISTORY INSERT*/
        INSERT INTO SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H
               (HISTORY_SEQ
              , DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, USER_ADD_QTY
              , COMMENTS, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              , HISTORY_CREATION_DATE, ATTRIBUTE1)
        SELECT SEQ1_SSP_ANL_SHIP_PLAN_40_WH_IN_CMT_H.NEXTVAL
              , DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD, USER_ADD_QTY
              , COMMENTS, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
              , SYSDATE, ATTRIBUTE1
          FROM SSP_ANL_SHIP_PLAN_40_WH_IN_CMT
         WHERE 1 = 1
           AND DIVISION_ID = P_DIVISION_ID
           AND FROM_SITE   = P_FROM_SITE
           AND ITEM_ID     = P_ITEM_ID
           AND YYYYMMDD    = P_YYYYMMDD;
        /*//COMMENTS 내용 저장 End*/

        COMMIT;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* 결과코드 반환 */
        OPEN O_RC1 FOR SELECT 'S' AS RESULT_CODE FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_CODE, NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_PSI_CMT;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE FROM DUAL;
            OPEN O_RC2 FOR SELECT V_ERR_CODE AS ERR_CODE, V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0015_SAVE_SHIPMENT_PSI_COMMENTS;


    /* ============================================================
       P_SSP0015_SAVE_BLOCK_STOCK_DATA
       AS-IS SSP0015_SAVE_BLOCK_STOCK_DATA
       ※ AS-IS 의 「단일 ROW 일때」 ELSE 갈래는 WHILE 안의 IF @mst_loop_cnt > 0 에 달려 있어
          도달할 수 없다(루프 안에서는 항상 1 이상). 옮기지 않는다.
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_BLOCK_STOCK_DATA
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_HOLD_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_SEQ                   IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_HOLD_YYYYMMDD         IN  VARCHAR2,
        P_RELEASE_YYYYMMDD      IN  VARCHAR2,
        P_HOLD_QTY              IN  VARCHAR2,
        P_REMARKS               IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_BLOCK_STOCK_DATA
         * Description  : Block Stock 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0015_SAVE_BLOCK STOCK_DATA';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        V_DELIMITER             VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_HOLD_ID               VARCHAR2(4000 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_PLAN_TYPE             VARCHAR2(4000 CHAR);
        V_SEQ                   VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_FROM_SITE             VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_HOLD_YYYYMMDD         VARCHAR2(4000 CHAR);
        V_RELEASE_YYYYMMDD      VARCHAR2(4000 CHAR);
        V_HOLD_QTY              VARCHAR2(4000 CHAR);
        V_REMARKS               VARCHAR2(4000 CHAR);
        V_USER_ID               VARCHAR2(4000 CHAR);
        V_EXISTS                PLS_INTEGER;
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_BLOCK;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE LENGTH(RTRIM(P_ACTIVE_FLAG)) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG         := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,         V_DELIMITER, V_MST_LOOP_CNT);
            V_HOLD_ID             := SCM_ARR_SPL_VAL(P_HOLD_ID,             V_DELIMITER, V_MST_LOOP_CNT);
            V_PLAN_START_YYYYMMDD := SCM_ARR_SPL_VAL(P_PLAN_START_YYYYMMDD, V_DELIMITER, V_MST_LOOP_CNT);
            V_PLAN_TYPE           := SCM_ARR_SPL_VAL(P_PLAN_TYPE,           V_DELIMITER, V_MST_LOOP_CNT);
            V_SEQ                 := SCM_ARR_SPL_VAL(P_SEQ,                 V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID         := SCM_ARR_SPL_VAL(P_DIVISION_ID,         V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE           := SCM_ARR_SPL_VAL(P_FROM_SITE,           V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID             := SCM_ARR_SPL_VAL(P_ITEM_ID,             V_DELIMITER, V_MST_LOOP_CNT);
            V_HOLD_YYYYMMDD       := SCM_ARR_SPL_VAL(P_HOLD_YYYYMMDD,       V_DELIMITER, V_MST_LOOP_CNT);
            V_RELEASE_YYYYMMDD    := SCM_ARR_SPL_VAL(P_RELEASE_YYYYMMDD,    V_DELIMITER, V_MST_LOOP_CNT);
            V_HOLD_YYYYMMDD    := CASE WHEN REGEXP_LIKE(V_HOLD_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                  THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_HOLD_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                  ELSE V_HOLD_YYYYMMDD END;   -- 2026.09.22 AJS
            V_RELEASE_YYYYMMDD := CASE WHEN REGEXP_LIKE(V_RELEASE_YYYYMMDD, '^[0-9]{4}[-/.][0-9]{2}[-/.][0-9]{2}')
                                  THEN SUBSTR(REPLACE(REPLACE(REPLACE(V_RELEASE_YYYYMMDD, '-'), '/'), '.'), 1, 8)
                                  ELSE V_RELEASE_YYYYMMDD END;   -- 2026.09.22 AJS
            V_HOLD_QTY            := SCM_ARR_SPL_VAL(P_HOLD_QTY,            V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS             := SCM_ARR_SPL_VAL(P_REMARKS,             V_DELIMITER, V_MST_LOOP_CNT);
            V_USER_ID             := SCM_ARR_SPL_VAL(P_USER_ID,             V_DELIMITER, V_MST_LOOP_CNT);

            /* SSP_ANL_HOLD_STOCK SAVE LOGIC */
            V_EXISTS := 0;

            BEGIN
                SELECT 1
                  INTO V_EXISTS
                  FROM SSP_ANL_HOLD_STOCK
                 WHERE HOLD_ID             = V_HOLD_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND PLAN_TYPE           = V_PLAN_TYPE
                   AND SEQ                 = V_SEQ
                   AND ROWNUM              = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_EXISTS := 0;
            END;

            IF V_EXISTS = 1 THEN

                UPDATE SSP_ANL_HOLD_STOCK
                   SET RELEASE_YYYYMMDD  = V_RELEASE_YYYYMMDD
                     , HOLD_QTY          = V_HOLD_QTY
                     , REMARKS           = V_REMARKS
                     , LAST_UPDATED_BY   = V_USER_ID
                     , LAST_UPDATE_DATE  = SYSDATE
                 WHERE HOLD_ID             = V_HOLD_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND PLAN_TYPE           = V_PLAN_TYPE
                   AND SEQ                 = V_SEQ;

            ELSE

                INSERT INTO SSP_ANL_HOLD_STOCK
                       (HOLD_ID
                      , PLAN_START_YYYYMMDD
                      , PLAN_TYPE
                      , SEQ
                      , DIVISION_ID
                      , FROM_SITE
                      , ITEM_ID
                      , HOLD_YYYYMMDD
                      , RELEASE_YYYYMMDD
                      , HOLD_QTY
                      , REMARKS
                      , ORIGIN_FROM_DIVISION_ID
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE)
                VALUES ('H' || TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR('0000' || TO_CHAR(SEQ1_SSP_ANL_HOLD_ID.NEXTVAL), -6)
                      , V_PLAN_START_YYYYMMDD
                      , V_PLAN_TYPE
                      , V_SEQ
                      , V_DIVISION_ID
                      , V_FROM_SITE
                      , V_ITEM_ID
                      , V_HOLD_YYYYMMDD
                      , V_RELEASE_YYYYMMDD
                      , V_HOLD_QTY
                      , V_REMARKS
                      , V_DIVISION_ID   /* origin_from_division_id */
                      , V_USER_ID
                      , SYSDATE
                      , V_USER_ID
                      , SYSDATE);

            END IF;

        END LOOP;

        /* EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 - AS-IS 주석 처리 상태 유지 */

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S' AS RESULT_CODE, V_MAX_LOOP_CNT AS RESULT_CNT FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_BLOCK;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE, 0 AS RESULT_CNT FROM DUAL;
            OPEN O_RC2 FOR SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0015_SAVE_BLOCK_STOCK_DATA;


    /* ============================================================
       P_SSP0015_SAVE_MES_STOCK
       AS-IS SSP0015_SAVE_MES_STOCK
       ※ #TMP_SSP_ANL_MES_FCS_STOCK_40_C_TEMP -> GT_SSP0015_MES_STOCK_UPD
       ※ AS-IS 의 MERGE 2벌은 WHEN MATCHED THEN UPDATE 뿐이라
          상관 UPDATE ... WHERE EXISTS 로 옮겼다(온라인 SQL MERGE 금지 · ORA-01779 회피).
       ※ 두 번째 갱신의 ITEM_ID 조건은 AS-IS 가 루프 마지막 값 하나만 쓴다.
          결과 동일성을 위해 원형을 유지한다(V_ITEM_ID 는 루프 종료 후 마지막 값).
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_MES_STOCK
    (
        P_ACTIVE_FLAG              IN  VARCHAR2,
        P_DIVISION_ID              IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD      IN  VARCHAR2,
        P_PLAN_TYPE                IN  VARCHAR2,
        P_SEQ                      IN  VARCHAR2,
        P_FROM_SITE                IN  VARCHAR2,
        P_ITEM_ID                  IN  VARCHAR2,
        P_LOT_ID                   IN  VARCHAR2,
        P_USER_MOD_RELEASE_DATE    IN  VARCHAR2,
        P_REMARKS                  IN  VARCHAR2,
        P_USER_ID                  IN  VARCHAR2,
        O_RC1                      OUT SYS_REFCURSOR,
        O_RC2                      OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_MES_STOCK
         * Description  : MES Stock 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         */
        V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'SSP0015_SAVE_MES_STOCK';
        V_LOG_TYPE              VARCHAR2(30 CHAR);
        N_LOG_COUNT             NUMBER := 0;
        V_LOG_MESSAGE           VARCHAR2(1000 CHAR);
        V_DESCRIPTION           VARCHAR2(500 CHAR);
        D_EVENT_DATE            DATE;

        V_DELIMITER             VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT          PLS_INTEGER := 0;
        V_MST_LOOP_CNT          PLS_INTEGER := 0;

        V_ACTIVE_FLAG           VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(4000 CHAR);
        V_PLAN_TYPE             VARCHAR2(4000 CHAR);
        V_SEQ                   VARCHAR2(4000 CHAR);
        V_FROM_SITE             VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_LOT_ID                VARCHAR2(4000 CHAR);
        V_USER_MOD_RELEASE_DATE VARCHAR2(4000 CHAR);
        V_REMARKS               VARCHAR2(4000 CHAR);
        V_USER_ID               VARCHAR2(4000 CHAR);
        V_ERR_CODE              NUMBER;
        V_ERR_MESSAGE           VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_MES;

        /* GTT 초기화 - TRUNCATE 금지(암묵적 커밋으로 롤백이 깨진다) */
        DELETE FROM GT_SSP0015_MES_STOCK_UPD;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        /* 프로시저 LOOP 길이를 판단 */
        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE LENGTH(RTRIM(P_ACTIVE_FLAG)) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG           := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,           V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID           := SCM_ARR_SPL_VAL(P_DIVISION_ID,           V_DELIMITER, V_MST_LOOP_CNT);
            V_PLAN_START_YYYYMMDD   := SCM_ARR_SPL_VAL(P_PLAN_START_YYYYMMDD,   V_DELIMITER, V_MST_LOOP_CNT);
            V_PLAN_TYPE             := SCM_ARR_SPL_VAL(P_PLAN_TYPE,             V_DELIMITER, V_MST_LOOP_CNT);
            V_SEQ                   := SCM_ARR_SPL_VAL(P_SEQ,                   V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE             := SCM_ARR_SPL_VAL(P_FROM_SITE,             V_DELIMITER, V_MST_LOOP_CNT);
            V_ITEM_ID               := SCM_ARR_SPL_VAL(P_ITEM_ID,               V_DELIMITER, V_MST_LOOP_CNT);
            V_LOT_ID                := SCM_ARR_SPL_VAL(P_LOT_ID,                V_DELIMITER, V_MST_LOOP_CNT);
            V_USER_MOD_RELEASE_DATE := SCM_ARR_SPL_VAL(P_USER_MOD_RELEASE_DATE, V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS               := SCM_ARR_SPL_VAL(P_REMARKS,               V_DELIMITER, V_MST_LOOP_CNT);
            V_USER_ID               := SCM_ARR_SPL_VAL(P_USER_ID,               V_DELIMITER, V_MST_LOOP_CNT);

            /* UPDATE 대상 TEMP 테이블 만들기 */
            INSERT INTO GT_SSP0015_MES_STOCK_UPD
                   (ACTIVE_FLAG, DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ
                  , FROM_SITE, ITEM_ID, LOT_ID, USER_MOD_RELEASE_DATE, REMARKS, USER_ID)
            VALUES (V_ACTIVE_FLAG, V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_PLAN_TYPE, V_SEQ
                  , V_FROM_SITE, V_ITEM_ID, V_LOT_ID, REPLACE(V_USER_MOD_RELEASE_DATE, '-', ''), V_REMARKS, V_USER_ID);

        END LOOP;

        /* 1) SSP_ANL_MES_FCS_STOCK_40_C 갱신 (AS-IS MERGE 1번째) */
        UPDATE SSP_ANL_MES_FCS_STOCK_40_C A
           SET (A.USER_MOD_RELEASE_DATE, A.REMARKS, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
               = (SELECT MAX(B.USER_MOD_RELEASE_DATE), MAX(B.REMARKS), MAX(B.USER_ID), SYSDATE
                    FROM GT_SSP0015_MES_STOCK_UPD B
                   WHERE B.DIVISION_ID         = A.DIVISION_ID
                     AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                     AND B.PLAN_TYPE           = A.PLAN_TYPE
                     AND B.SEQ                 = TO_CHAR(A.SEQ)
                     AND B.ITEM_ID             = A.ITEM_ID
                     AND B.LOT_ID              = A.LOT_ID
                     AND B.FROM_SITE           = A.FROM_SITE)
         WHERE A.CHANGE_STATUS <> 'D'
           AND EXISTS (SELECT 1
                         FROM GT_SSP0015_MES_STOCK_UPD B
                        WHERE B.DIVISION_ID         = A.DIVISION_ID
                          AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                          AND B.PLAN_TYPE           = A.PLAN_TYPE
                          AND B.SEQ                 = TO_CHAR(A.SEQ)
                          AND B.ITEM_ID             = A.ITEM_ID
                          AND B.LOT_ID              = A.LOT_ID
                          AND B.FROM_SITE           = A.FROM_SITE);

        /* SSP_ANL_MES_FCS_STOCK_40_C 테이블 UPDATE 완료 후 초기화 */
        V_MST_LOOP_CNT := 0;

        /* 2) SSP_ANL_SHIP_PLAN_40 의 MES_FCS_RELEASE 수량 재집계 (AS-IS MERGE 2번째) */
        UPDATE SSP_ANL_SHIP_PLAN_40 A
           SET (A.QTY, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE)
               = (SELECT NVL(SUM(B.LOT_QTY_TOT), 0), MAX(C.USER_ID), SYSDATE
                    FROM GT_SSP0015_MES_STOCK_UPD C
                       , SSP_ANL_MES_FCS_STOCK_40_C B
                   WHERE A.DIVISION_ID         = C.DIVISION_ID
                     AND A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
                     AND A.PLAN_TYPE           = C.PLAN_TYPE
                     AND TO_CHAR(A.SEQ)        = C.SEQ
                     AND A.FROM_SITE           = C.FROM_SITE
                     AND A.ITEM_ID             = C.ITEM_ID
                     AND B.DIVISION_ID(+)         = A.DIVISION_ID
                     AND B.PLAN_START_YYYYMMDD(+) = A.PLAN_START_YYYYMMDD
                     AND B.PLAN_TYPE(+)           = A.PLAN_TYPE
                     AND B.SEQ(+)                 = A.SEQ
                     AND B.LOT_ID(+)              = C.LOT_ID
                     AND B.FROM_SITE(+)           = A.FROM_SITE
                     AND B.ITEM_ID(+)             = A.ITEM_ID
                     AND A.YYYYMMDD = (CASE WHEN NVL(B.USER_MOD_RELEASE_DATE, '-') <> '29991231'
                                             AND NVL(B.USER_MOD_RELEASE_DATE, '-') <> '-'
                                            THEN B.USER_MOD_RELEASE_DATE
                                            WHEN NVL(B.USER_MOD_RELEASE_DATE, '-') = '29991231'
                                             AND NVL(B.QMS_HOLD_RELEASE, '-') > NVL(B.MES_HOLD_RELEASE, '-')
                                            THEN B.QMS_HOLD_RELEASE
                                            ELSE B.MES_HOLD_RELEASE END))
         WHERE A.MEASURE     = 'MES_FCS_RELEASE'
           AND A.DIVISION_ID = '40'
           AND A.PLAN_TYPE   = 'SP'
           /* AS-IS 원형 유지 : 루프 마지막 ITEM_ID 값 하나만 조건으로 쓴다 */
           AND (V_ITEM_ID IS NOT NULL AND V_ITEM_ID <> '-')
           AND A.ITEM_ID = V_ITEM_ID
           AND EXISTS (SELECT 1
                         FROM GT_SSP0015_MES_STOCK_UPD C
                        WHERE A.DIVISION_ID         = C.DIVISION_ID
                          AND A.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
                          AND A.PLAN_TYPE           = C.PLAN_TYPE
                          AND TO_CHAR(A.SEQ)        = C.SEQ
                          AND A.FROM_SITE           = C.FROM_SITE
                          AND A.ITEM_ID             = C.ITEM_ID);

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE, NULL, NULL, NULL, NULL);

        DELETE FROM GT_SSP0015_MES_STOCK_UPD;

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S' AS RESULT_CODE, V_MAX_LOOP_CNT AS RESULT_CNT FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_MES;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE, 0 AS RESULT_CNT FROM DUAL;
            OPEN O_RC2 FOR SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0015_SAVE_MES_STOCK;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
       AS-IS SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
       ※ 과거 버전 조회라 계산하지 않고 SSP_ANL_SHIP_PLAN_P 스냅샷을 그대로 읽는다.
       ※ 마지막 피벗은 조회기간만큼 날짜 칸을 만들므로 정적 SQL 로 옮길 수 없다.
          OPEN 커서 FOR 문자열 로 두고 조립 문자열은 CLOB 로 둔다.
          (CNS 전환가이드 8항 Dynamic SQL 금지의 예외 - 2항 결과 동일성을 우선한 자리)
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST
         * Description  : Shipment PSI (Packer) - 과거 버전
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/11/10   KIMYONGHO      SSP0015_GET_SHIPMENT_PSI 복사 신규추가
         * 2022/02/21   SMS            SHIP_FROZEN 추가 (scm_mst_site(ship_frozen))
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_CNT_USR_MEASURE   PLS_INTEGER := 0;
        V_CUTOFF_DATE       VARCHAR2(8 CHAR);
        V_MQRY_SUM          CLOB := EMPTY_CLOB();
        V_MEXEC             CLOB;
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* GTT 초기화 - TRUNCATE 금지 */
        DELETE FROM GT_SSP0015_PK_ROWDATA;
        DELETE FROM GT_SSP0015_PK_RESULT;
        DELETE FROM GT_SSP0015_PK_RESULT_PIVOT;
        DELETE FROM GT_SSP0015_PK_WH_STOCK;
        DELETE FROM GT_SSP0015_PK_ERP_STOCK;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        V_CUTOFF_DATE := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2, 'YYYYMMDD');

        /* //4. WH_STOCK - SCS 재고 */
        INSERT INTO GT_SSP0015_PK_WH_STOCK
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , 'WH_STOCK'
             , A.STOCK_DATE
             , SUM(NVL(A.STOCK_QTY, 0))
          FROM SCM_DNM_SCS_STOCK A
         WHERE 1 = 1
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.CUTOFF_DATE = V_CUTOFF_DATE
           AND A.CELL_PACK   = 'P'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID
             , A.SCM_SITE_ID
             , A.ITEM_ID
             , A.STOCK_DATE;

        /* //ERP 재고 데이터 */
        INSERT INTO GT_SSP0015_PK_ERP_STOCK
               (DIVISION_ID, PLANT_ID, ITEM_ID, BOH_TYPE, YYYYMMDD, QTY)
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.ITEM_ID
             , 'ERP'
             , IA.CUTOFF_DATE
             , SUM(IA.SCM_QTY)
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.ITEM_ID
                     , A.SCM_QTY
                     , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_DATE
                     , A.PLANT_ID
                     , A.STOCK_TYPE
                  FROM SCM_DNM_STOCK_V A
                 WHERE 1 = 1
                   AND A.DIVISION_ID = '40'
                   AND A.COMPANY_ID  = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER_PAST', 'ESOC')   /* C100 */
                   AND A.CUTOFF_DATE = TO_DATE(TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'), 'YYYYMMDD')
                   AND A.ORG_CUTOFF_DATE = TO_DATE(TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'), 'YYYYMMDD') + 1 /* AJS 20261007 속도 : 원장 마감일 조건(뷰 마감일 + 1 과 같은 값) */
                   AND A.PLANT_ID    = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER_PAST', 'A010')   /* A010 */
                   AND A.STOCK_TYPE  = 'INVENTORY'
               ) IA
         WHERE IA.STOCK_TYPE = 'INVENTORY'
         GROUP BY IA.DIVISION_ID
             , IA.COMPANY_ID
             , IA.ITEM_ID
             , IA.CUTOFF_DATE
             , IA.PLANT_ID
             , IA.STOCK_TYPE;

        /* //TMP_ROWDATA - 과거 버전은 SSP_ANL_SHIP_PLAN_P 스냅샷을 그대로 읽는다 */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.MEASURE
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_PLAN_P A
         WHERE A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE')   /* PACK FP = PROD_PLAN */
         GROUP BY A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , A.MEASURE
             , A.YYYYMMDD;

        /* //TMP_RESULT_TABLE */
        INSERT INTO GT_SSP0015_PK_RESULT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY, SEQ)
        SELECT DISTINCT
               X.DIVISION_ID
             , X.ITEM_ID
             , X.FROM_SITE
             , X.MEASURE
             , X.YYYYMMDD
             , NVL(R.QTY, 0)
             , X.SEQ
          FROM (
                SELECT T.DIVISION_ID
                     , T.ITEM_ID
                     , NVL(T.FROM_SITE, '/')    AS FROM_SITE
                     , T.QTY
                     , TT1.COLUMN_NAME          AS MEASURE
                     , TT1.COLUMN_LABEL_NAME    AS MEASURE_NAME
                     , TT1.ATTRIBUTE3           AS BACK_COLOR
                     , TT1.SORT_ORDER_NO        AS SEQ
                     , T.YYYYMMDD
                  FROM GT_SSP0015_PK_ROWDATA T
                     , SCM_MST_SHEET_MEASURE TT1
                     , SCM_MST_TITLESET_USER T3
                 WHERE TT1.PROGRAM_ID = P_PROGRAM_ID
                   AND TT1.SHEET_NAME = P_SHEET_NAME
                   AND T3.PROGRAM_ID(+)  = TT1.PROGRAM_ID
                   AND T3.SHEET_NAME(+)  = TT1.SHEET_NAME
                   AND T3.COLUMN_NAME(+) = TT1.COLUMN_NAME
                   AND T3.USER_ID(+)     = P_USER_ID
               ) X
             , GT_SSP0015_PK_ROWDATA R
         WHERE R.DIVISION_ID(+) = X.DIVISION_ID
           AND R.ITEM_ID(+)     = X.ITEM_ID
           AND R.MEASURE(+)     = X.MEASURE
           AND R.YYYYMMDD(+)    = X.YYYYMMDD
           AND R.FROM_SITE(+)   = X.FROM_SITE
           AND X.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE');   /* PACK FP = PROD_PLAN */

        /* //PIVOT 대상 */
        INSERT INTO GT_SSP0015_PK_RESULT_PIVOT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ)
        SELECT DISTINCT
               T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.MEASURE
             , 'D_' || T0.YYYYMMDD
             , T1.BASIS_YYYYMM
             , SUBSTR(T1.BASIS_YYYYMM, -4) || T1.ISO_WEEK
             , T0.QTY
             , T0.SEQ
          FROM GT_SSP0015_PK_RESULT T0
             , SCM_SYS_CALENDAR_M T1
         WHERE T0.YYYYMMDD = T1.BASIS_YYYYMMDD(+);

        /* PIVOT 대상 날짜문자열 생성 */
        DBMS_LOB.CREATETEMPORARY(V_MQRY_SUM, TRUE);

        FOR C IN (
            SELECT IA.YYYYMMDD
              FROM (
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'           AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO)
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMMDD = SUBSTR(''' || C.YYYYMMDD || ''', -10) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            END IF;
        END LOOP;

        V_MEXEC := 'SELECT DISTINCT TTT.* FROM ( ' || CHR(10)
                || '  SELECT T0.DIVISION_ID' || CHR(10)
                || '       , T0.ITEM_ID' || CHR(10)
                || '       , NVL(IT.NICK_NAME, ''-'')      AS NICK_NAME' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN ''SCS'' WHEN T0.MEASURE = ''BALANCE'' THEN ''ERP'' ELSE '' '' END) AS TYPE' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN NVL(T5.QTY, 0)' || CHR(10)
                || '               WHEN T0.MEASURE = ''BALANCE''  THEN NVL(T6.QTY, 0)' || CHR(10)
                || '          ELSE NULL END)               AS FIGURE' || CHR(10)
                || '       , NVL(T0.FROM_SITE, ''/'')      AS FROM_SITE' || CHR(10)
                || '       , NVL(T4.SITE_DESCRIPTION, ''/'') AS FROM_SITE_NM' || CHR(10)
                || '       , T0.MEASURE                    AS MEASURE' || CHR(10)
                || '       , T2.ATTRIBUTE1                 AS PSI_NAME' || CHR(10)
                || '       , T0.SEQ' || CHR(10)
                || '       , CASE WHEN NVL(T4.SHIP_FROZEN, 0) - 1 > 0 THEN T4.SHIP_FROZEN - 1 ELSE 0 END AS SHIP_FROZEN' || CHR(10)
                || V_MQRY_SUM
                || '    FROM GT_SSP0015_PK_RESULT_PIVOT T0' || CHR(10)
                || '       , SCM_MST_SHEET_MEASURE T2' || CHR(10)
                || '       , SCM_MST_TITLESET_USER T3' || CHR(10)
                || '       , SCM_MST_SITE T4' || CHR(10)
                || '       , GT_SSP0015_PK_WH_STOCK T5' || CHR(10)
                || '       , GT_SSP0015_PK_ERP_STOCK T6' || CHR(10)
                || '       , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME FROM SCM_MST_ITEM_SN' || CHR(10)
                || '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || '''' || CHR(10)
                || '             AND ACTIVE_FLAG = ''Y''' || CHR(10)
                || '             AND SCP_OPERATION_GROUP = ''P'') IT' || CHR(10)
                || '       , SSP_MST_MODEL_USER TT3' || CHR(10)
                || '   WHERE T0.MEASURE = T2.COLUMN_NAME' || CHR(10)
                || '     AND T2.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '     AND T2.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '     AND T3.PROGRAM_ID(+)  = T2.PROGRAM_ID' || CHR(10)
                || '     AND T3.SHEET_NAME(+)  = T2.SHEET_NAME' || CHR(10)
                || '     AND T3.COLUMN_NAME(+) = T2.COLUMN_NAME' || CHR(10)
                || '     AND T3.USER_ID(+)     = ''' || P_USER_ID || '''' || CHR(10)
                || '     AND T0.DIVISION_ID = T4.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T4.SCM_SITE_ID(+)' || CHR(10)
                || '     AND T4.VALID_YN(+) = ''Y''' || CHR(10)
                || '     AND T0.DIVISION_ID = T5.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T5.FROM_SITE(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T5.ITEM_ID(+)' || CHR(10)
                || '     AND T5.YYYYMMDD(+) = ''' || V_CUTOFF_DATE || '''' || CHR(10)
                || '     AND T5.MEASURE(+)  = ''WH_STOCK''' || CHR(10)
                || '     AND T0.DIVISION_ID = T6.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T6.ITEM_ID(+)' || CHR(10)
                || '     AND T0.DIVISION_ID = IT.DIVISION_ID' || CHR(10)
                || '     AND T0.ITEM_ID     = IT.ITEM_ID' || CHR(10)
                || '     AND TT3.DIVISION_ID(+) = T0.DIVISION_ID' || CHR(10)
                || '     AND TT3.FROM_SITE(+)   = T0.FROM_SITE' || CHR(10)
                || '     AND TT3.ITEM_ID(+)     = T0.ITEM_ID' || CHR(10)
                || '     AND TT3.VALID_YN(+)    = ''Y''' || CHR(10)
                || '     AND T2.VALID_YN = ''Y''' || CHR(10)
                /* 체크박스 체크 여부 조회 */
                || '     AND ((''' || P_NONCHK || ''' = ''Y'' AND 1 = 1)' || CHR(10)
                || '           OR TT3.USER_ID IN (SELECT CASE WHEN ''' || P_MYMODELCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END FROM DUAL' || CHR(10)
                || '                               UNION' || CHR(10)
                || '                              SELECT CASE WHEN ''' || P_DELEGATEECHK || ''' = ''Y'' THEN USER_ID ELSE ''X'' END' || CHR(10)
                || '                                FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' || P_USER_ID || ''' GROUP BY USER_ID)' || CHR(10)
                || '           OR TT3.PART_LEADER = CASE WHEN ''' || P_PARTLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END' || CHR(10)
                || '           OR TT3.TEAM_LEADER = CASE WHEN ''' || P_TEAMLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END)' || CHR(10);

        IF P_FROM_SITE IS NOT NULL THEN
            V_MEXEC := V_MEXEC
                || '     AND T0.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(''' || P_FROM_SITE || ''', '','')))' || CHR(10);
        END IF;

        V_MEXEC := V_MEXEC
                || '     AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
                || '           OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SA' || CHR(10)
                || '                       WHERE SA.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '                         AND SA.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '                         AND SA.USER_ID    = ''' || P_USER_ID || '''' || CHR(10)
                || '                         AND SA.COLUMN_NAME = T2.COLUMN_NAME))' || CHR(10)
                || '     AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND T2.DEFAULT_FLAG = ''Y'')' || CHR(10)
                || '           OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
                || '   GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.FROM_SITE, T4.SITE_DESCRIPTION' || CHR(10)
                || '          , T0.MEASURE, T0.SEQ, T2.ATTRIBUTE1, T5.QTY, T6.QTY, T4.SHIP_FROZEN' || CHR(10)
                || ') TTT' || CHR(10)
                || ' ORDER BY TTT.DIVISION_ID, TTT.ITEM_ID, TTT.FROM_SITE DESC, TTT.SEQ ASC';

        OPEN O_RC1 FOR V_MEXEC;

        DBMS_LOB.FREETEMPORARY(V_MQRY_SUM);

    END P_SSP0015_GET_SHIPMENT_PSI_PACKER_PAST;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI_PACKER
       AS-IS SSP0015_GET_SHIPMENT_PSI_PACKER
       ※ #TEMP 9벌 -> GT_SSP0015_PK_* 9벌
       ※ 마지막 피벗은 조회기간만큼 날짜 칸을 만들므로 정적 SQL 로 옮길 수 없다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI_PACKER
         * Description  : Shipment PSI (Packer)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020/11/10   KIMYONGHO      SSP0015_GET_SHIPMENT_PSI 복사 신규추가
         * 2022/02/21   SMS            @v_confirm_date 일자 scm_mst_site(ship_frozen)로 설정
         * 2023/09/19   jilee          G182-P (Group='P',OSP='N')인 사이트 화면에서 제외
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_CUTOFF_DATE           VARCHAR2(8 CHAR);
        V_BOH_YYYYMMDD          VARCHAR2(8 CHAR);
        V_PLAN_CUTOFF_DATE_TIME DATE;
        V_MQRY_SUM              CLOB := EMPTY_CLOB();
        V_MEXEC                 CLOB;
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* GTT 초기화 - TRUNCATE 금지 */
        DELETE FROM GT_SSP0015_PK_SHIP_REQ;
        DELETE FROM GT_SSP0015_PK_PACK_RTF;
        DELETE FROM GT_SSP0015_PK_SHIP_CONFIRM;
        DELETE FROM GT_SSP0015_PK_PROD_PLAN;
        DELETE FROM GT_SSP0015_PK_WH_STOCK;
        DELETE FROM GT_SSP0015_PK_ERP_STOCK;
        DELETE FROM GT_SSP0015_PK_ROWDATA;
        DELETE FROM GT_SSP0015_PK_RESULT;
        DELETE FROM GT_SSP0015_PK_RESULT_PIVOT;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        V_CUTOFF_DATE  := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 2, 'YYYYMMDD');
        V_BOH_YYYYMMDD := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

        /* AS-IS : datepart(DW, ...) = 2 는 월요일. Oracle 은 NLS 에 좌우되지 않도록 TO_CHAR(,'D','NLS_DATE_LANGUAGE=AMERICAN') 대신
           고정 기준일과의 차로 요일을 구한다(1900-01-01 은 월요일). */
        IF MOD(TRUNC(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD')) - TO_DATE('19000101', 'YYYYMMDD'), 7) = 0 THEN
            V_PLAN_CUTOFF_DATE_TIME := TO_DATE(P_PLAN_START_YYYYMMDD || ' 15:30:00', 'YYYYMMDD HH24:MI:SS');
        ELSE
            V_PLAN_CUTOFF_DATE_TIME := TO_DATE(P_PLAN_START_YYYYMMDD || ' 07:15:00', 'YYYYMMDD HH24:MI:SS');
        END IF;

        /* //SHIP_REQ Measure 추가 */
        INSERT INTO GT_SSP0015_PK_SHIP_REQ
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.FROM_SITE
             , 'SHIP_REQ'
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_REQ_P A
             , SCP_MST_BOD_N_V B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.BOD_ID      = B.BOD_ID
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR B.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.ITEM_ID, B.FROM_SITE, A.YYYYMMDD;

        /* //PACK_RTF Measure 추가 */
        INSERT INTO GT_SSP0015_PK_PACK_RTF
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.FROM_SITE
             , 'PACK_RTF'
             , A.ATTRIBUTE3
             , SUM(TO_NUMBER(A.ATTRIBUTE4 DEFAULT NULL ON CONVERSION ERROR))
          FROM SSP_ANL_SHIP_REQ_P A
             , SCP_MST_BOD_N_V B
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.BOD_ID      = B.BOD_ID
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.ATTRIBUTE2 <> 'N'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR B.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.ITEM_ID, B.FROM_SITE, A.ATTRIBUTE3, A.ATTRIBUTE4;

        /* //SHIP_CONFIRM Measure 추가 */
        INSERT INTO GT_SSP0015_PK_SHIP_CONFIRM
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.FROM_SITE
             , 'SHIP_CONFIRM'
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_CONFIRM A
             , SCM_MST_SITE S
         WHERE S.DIVISION_ID = A.DIVISION_ID
           AND S.SCM_SITE_ID = A.FROM_SITE
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND A.BIZ_TYPE  = 'P'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
           /* jilee 230919 */
           AND S.OSP_YN = 'Y'
         GROUP BY A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.YYYYMMDD
        UNION ALL
        /* 20220221 SMS @v_confirm_date 일자 scm_mst_site(ship_frozen)로 설정 */
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.FROM_SITE
             , 'SHIP_CONFIRM'
             , A.YYYYMMDD
             , SUM(A.QTY)
          FROM SSP_ANL_SHIP_REQ_P A
             , SCP_MST_BOD_N_V B
             , SCM_MST_SITE FS
         WHERE A.DIVISION_ID = B.DIVISION_ID
           AND A.BOD_ID      = B.BOD_ID
           AND A.DIVISION_ID = FS.DIVISION_ID
           AND B.FROM_SITE   = FS.SCM_SITE_ID
           AND FS.VALID_YN   = 'Y'
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(FS.SHIP_FROZEN, 0), 'YYYYMMDD')
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR B.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.ITEM_ID, B.FROM_SITE, A.YYYYMMDD;

        /* //PROD_PLAN Measure 추가 */
        INSERT INTO GT_SSP0015_PK_PROD_PLAN
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.PACK_MODEL_CODE
             , A.SCM_SITE_ID
             , 'PROD_PLAN'
             , A.PROD_DATE
             , NVL(A.PROD_QTY, 0)
          FROM SCM_DNM_SCS_PROD_PLAN A
             , (SELECT DIVISION_ID, MAX(CUTOFF_DATE) AS CUTOFF_DATE, PACK_MODEL_CODE, SCM_SITE_ID, PROD_DATE
                  FROM SCM_DNM_SCS_PROD_PLAN
                 GROUP BY DIVISION_ID, PACK_MODEL_CODE, SCM_SITE_ID, PROD_DATE) B
         WHERE A.DIVISION_ID     = B.DIVISION_ID
           AND A.CUTOFF_DATE     = B.CUTOFF_DATE
           AND A.PACK_MODEL_CODE = B.PACK_MODEL_CODE
           AND A.SCM_SITE_ID     = B.SCM_SITE_ID
           AND A.PROD_DATE       = B.PROD_DATE
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.PROD_DATE >= P_FROM_YYYYMMDD
           AND A.PROD_DATE <= P_TO_YYYYMMDD
           AND NVL(A.PROD_QTY, 0) > 0
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.PACK_MODEL_CODE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.PACK_MODEL_CODE IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))));

        /* //WH_STOCK Measure 추가 */
        INSERT INTO GT_SSP0015_PK_WH_STOCK
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , A.SCM_SITE_ID
             , 'WH_STOCK'
             , A.STOCK_DATE
             , SUM(NVL(A.STOCK_QTY, 0))
          FROM SCM_DNM_SCS_STOCK A
         WHERE 1 = 1
           AND A.DIVISION_ID      = P_DIVISION_ID
           AND A.CUTOFF_DATE      = V_CUTOFF_DATE
           AND A.LAST_UPDATE_DATE <= V_PLAN_CUTOFF_DATE_TIME
           AND A.CELL_PACK        = 'P'
           AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                 OR  UPPER(P_ITEM_ID) = 'ALL'         /* 조회조건 ALL 은 조건 없음 */
--               OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                 OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                 OR  UPPER(P_FROM_SITE) = 'ALL'       /* 조회조건 ALL 은 조건 없음 */
                 OR A.SCM_SITE_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
         GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, A.STOCK_DATE;

        /* //ERP 재고 데이터 */
        INSERT INTO GT_SSP0015_PK_ERP_STOCK
               (DIVISION_ID, PLANT_ID, ITEM_ID, BOH_TYPE, YYYYMMDD, QTY)
        SELECT IA.DIVISION_ID
             , IA.PLANT_ID
             , IA.ITEM_ID
             , 'ERP'
             , IA.CUTOFF_DATE
             , SUM(IA.SCM_QTY)
          FROM (
                SELECT DISTINCT
                       A.DIVISION_ID
                     , A.COMPANY_ID
                     , A.ITEM_ID
                     , A.SCM_QTY
                     , TO_CHAR(A.CUTOFF_DATE, 'YYYYMMDD') AS CUTOFF_DATE
                     , A.PLANT_ID
                     , A.STOCK_TYPE
                  FROM SCM_DNM_STOCK_V A
                 WHERE 1 = 1
                   AND A.DIVISION_ID = '40'
                   AND A.COMPANY_ID  = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER', 'ESOC')   /* C100 */
                   AND A.CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD')
                   AND A.ORG_CUTOFF_DATE = TO_DATE(V_BOH_YYYYMMDD, 'YYYYMMDD') + 1 /* AJS 20261007 속도 : 원장 마감일 조건(뷰 마감일 + 1 과 같은 값) */
                   AND A.PLANT_ID    = FN_GET_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI_PACKER', 'A010')   /* A010 */
                   AND A.STOCK_TYPE  = 'INVENTORY'
               ) IA
         WHERE IA.STOCK_TYPE = 'INVENTORY'
         GROUP BY IA.DIVISION_ID, IA.COMPANY_ID, IA.ITEM_ID, IA.CUTOFF_DATE, IA.PLANT_ID, IA.STOCK_TYPE;

        /* //TMP_ROWDATA */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.MEASURE
             , T0.YYYYMMDD
             , SUM(T0.QTY)
          FROM (
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_SHIP_REQ
                UNION
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_PACK_RTF
                UNION
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_SHIP_CONFIRM
                UNION
                SELECT DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY FROM GT_SSP0015_PK_PROD_PLAN
               ) T0
         GROUP BY T0.DIVISION_ID, T0.ITEM_ID, T0.FROM_SITE, T0.MEASURE, T0.YYYYMMDD;

        /* //4. WH_STOCK - 전일 WH_STOCK + PROD_PLAN - SHIP_CONFIRM 누적 + SCS 재고 */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , 'WH_STOCK'
             , T0.YYYYMMDD
             , (SELECT NVL(SUM(CASE WHEN TT0.MEASURE = 'SHIP_CONFIRM' THEN -1 * NVL(TT0.QTY, 0)
                                    WHEN TT0.MEASURE = 'PROD_PLAN'    THEN      NVL(TT0.QTY, 0)
                                    ELSE 0 END), 0)
                  FROM GT_SSP0015_PK_ROWDATA TT0
                 WHERE 1 = 1
                   AND TT0.DIVISION_ID = T0.DIVISION_ID
                   AND TT0.FROM_SITE   = T0.FROM_SITE
                   AND TT0.ITEM_ID     = T0.ITEM_ID
                   AND TT0.MEASURE IN ('SHIP_CONFIRM', 'PROD_PLAN')
                   AND TT0.YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                   AND TT0.YYYYMMDD <= T0.YYYYMMDD)
               + NVL(T1.QTY, 0)
          FROM (
                /* Deduplication */
                SELECT R.DIVISION_ID
                     , R.FROM_SITE
                     , R.ITEM_ID
                     , C.YYYYMMDD
                  FROM GT_SSP0015_PK_ROWDATA R
                     , (SELECT BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M
                         WHERE BASIS_YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                           AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD) C
                 WHERE C.YYYYMMDD(+) >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                 GROUP BY R.DIVISION_ID, R.FROM_SITE, R.ITEM_ID, C.YYYYMMDD
               ) T0
             , (SELECT A.DIVISION_ID, A.ITEM_ID, A.FROM_SITE, A.QTY
                  FROM GT_SSP0015_PK_WH_STOCK A
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.YYYYMMDD    = V_CUTOFF_DATE
                   AND A.MEASURE     = 'WH_STOCK'
                   AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                         OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                       OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                         OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                   AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                         OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                         OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))) T1
         WHERE T0.DIVISION_ID = T1.DIVISION_ID(+)
           AND T0.FROM_SITE   = T1.FROM_SITE(+)
           AND T0.ITEM_ID     = T1.ITEM_ID(+)
           AND T0.YYYYMMDD   <= P_TO_YYYYMMDD;

        /* //BALANCE Measure 추가 */
        INSERT INTO GT_SSP0015_PK_ROWDATA
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY)
        SELECT DIVISION_ID
             , ITEM_ID
             , FROM_SITE
             , 'BALANCE'
             , YYYYMMDD
             , NVL(SUM(CASE WHEN MEASURE = 'SHIP_CONFIRM' THEN -1 * NVL(QTY, 0)
                            WHEN MEASURE = 'WH_STOCK'     THEN      NVL(QTY, 0)
                            ELSE 0 END), 0)
          FROM GT_SSP0015_PK_ROWDATA
         WHERE 1 = 1
           AND MEASURE IN ('SHIP_CONFIRM', 'WH_STOCK', 'PROD_PLAN')
           AND YYYYMMDD >= TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
         GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID, YYYYMMDD;

        /* //TMP_RESULT_TABLE */
        INSERT INTO GT_SSP0015_PK_RESULT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, QTY, SEQ)
        SELECT DISTINCT
               X.DIVISION_ID
             , X.ITEM_ID
             , X.FROM_SITE
             , X.MEASURE
             , X.YYYYMMDD
             , NVL(R.QTY, 0)
             , X.SEQ
          FROM (
                SELECT T.DIVISION_ID
                     , T.ITEM_ID
                     , NVL(T.FROM_SITE, '/')    AS FROM_SITE
                     , T.QTY
                     , TT1.COLUMN_NAME          AS MEASURE
                     , TT1.COLUMN_LABEL_NAME    AS MEASURE_NAME
                     , TT1.ATTRIBUTE3           AS BACK_COLOR
                     , TT1.SORT_ORDER_NO        AS SEQ
                     , T.YYYYMMDD
                  FROM GT_SSP0015_PK_ROWDATA T
                     , SCM_MST_SHEET_MEASURE TT1
                     , SCM_MST_TITLESET_USER T3
                 WHERE TT1.PROGRAM_ID = P_PROGRAM_ID
                   AND TT1.SHEET_NAME = P_SHEET_NAME
                   AND T3.PROGRAM_ID(+)  = TT1.PROGRAM_ID
                   AND T3.SHEET_NAME(+)  = TT1.SHEET_NAME
                   AND T3.COLUMN_NAME(+) = TT1.COLUMN_NAME
                   AND T3.USER_ID(+)     = P_USER_ID
               ) X
             , GT_SSP0015_PK_ROWDATA R
         WHERE R.DIVISION_ID(+) = X.DIVISION_ID
           AND R.ITEM_ID(+)     = X.ITEM_ID
           AND R.MEASURE(+)     = X.MEASURE
           AND R.YYYYMMDD(+)    = X.YYYYMMDD
           AND R.FROM_SITE(+)   = X.FROM_SITE
           AND X.MEASURE IN ('SHIP_REQ', 'SHIP_CONFIRM', 'PACK_RTF', 'PROD_PLAN', 'WH_STOCK', 'BALANCE');

        /* //PIVOT 대상 */
        INSERT INTO GT_SSP0015_PK_RESULT_PIVOT
               (DIVISION_ID, ITEM_ID, FROM_SITE, MEASURE, YYYYMMDD, YYYYMM, ISO_WEEK, QTY, SEQ)
        SELECT DISTINCT
               T0.DIVISION_ID
             , T0.ITEM_ID
             , T0.FROM_SITE
             , T0.MEASURE
             , 'D_' || T0.YYYYMMDD
             , T1.BASIS_YYYYMM
             , SUBSTR(T1.BASIS_YYYYMM, -4) || T1.ISO_WEEK
             , T0.QTY
             , T0.SEQ
          FROM GT_SSP0015_PK_RESULT T0
             , SCM_SYS_CALENDAR_M T1
         WHERE T0.YYYYMMDD = T1.BASIS_YYYYMMDD(+);

        /* PIVOT 대상 날짜문자열 생성 */
        DBMS_LOB.CREATETEMPORARY(V_MQRY_SUM, TRUE);

        FOR C IN (
            SELECT IA.YYYYMMDD
              FROM (
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'           AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO)
        LOOP
            IF SUBSTR(C.YYYYMMDD, 1, 2) = 'M_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMM = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSIF SUBSTR(C.YYYYMMDD, 1, 2) = 'W_' THEN
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.ISO_WEEK = SUBSTR(''' || C.YYYYMMDD || ''', -6) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            ELSE
                DBMS_LOB.APPEND(V_MQRY_SUM, ', CEIL(SUM(CASE WHEN T0.YYYYMMDD = SUBSTR(''' || C.YYYYMMDD || ''', -10) THEN NVL(T0.QTY, 0) ELSE 0 END)) AS ' || C.YYYYMMDD || CHR(10));
            END IF;
        END LOOP;

        V_MEXEC := 'SELECT DISTINCT TTT.* FROM ( ' || CHR(10)
                || '  SELECT T0.DIVISION_ID' || CHR(10)
                || '       , T0.ITEM_ID' || CHR(10)
                || '       , NVL(IT.NICK_NAME, ''-'')      AS NICK_NAME' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN ''SCS'' WHEN T0.MEASURE = ''BALANCE'' THEN ''ERP'' ELSE '' '' END) AS TYPE' || CHR(10)
                || '       , (CASE WHEN T0.MEASURE = ''WH_STOCK'' THEN NVL(T5.QTY, 0)' || CHR(10)
                || '               WHEN T0.MEASURE = ''BALANCE''  THEN NVL(T6.QTY, 0)' || CHR(10)
                || '          ELSE NULL END)               AS FIGURE' || CHR(10)
                || '       , NVL(T0.FROM_SITE, ''/'')      AS FROM_SITE' || CHR(10)
                || '       , NVL(T4.SITE_DESCRIPTION, ''/'') AS FROM_SITE_NM' || CHR(10)
                || '       , T0.MEASURE                    AS MEASURE' || CHR(10)
                || '       , T2.ATTRIBUTE1                 AS PSI_NAME' || CHR(10)
                || '       , T0.SEQ' || CHR(10)
                || '       , CASE WHEN NVL(T4.SHIP_FROZEN, 0) - 1 > 0 THEN T4.SHIP_FROZEN - 1 ELSE 0 END AS SHIP_FROZEN' || CHR(10)
                || V_MQRY_SUM
                || '    FROM GT_SSP0015_PK_RESULT_PIVOT T0' || CHR(10)
                || '       , SCM_MST_SHEET_MEASURE T2' || CHR(10)
                || '       , SCM_MST_TITLESET_USER T3' || CHR(10)
                || '       , SCM_MST_SITE T4' || CHR(10)
                || '       , GT_SSP0015_PK_WH_STOCK T5' || CHR(10)
                || '       , GT_SSP0015_PK_ERP_STOCK T6' || CHR(10)
                || '       , (SELECT DISTINCT DIVISION_ID, ITEM_ID, NICK_NAME FROM SCM_MST_ITEM_SN' || CHR(10)
                || '           WHERE DIVISION_ID = ''' || P_DIVISION_ID || '''' || CHR(10)
                || '             AND ACTIVE_FLAG = ''Y''' || CHR(10)
                || '             AND SCP_OPERATION_GROUP = ''P'') IT' || CHR(10)
                || '       , SSP_MST_MODEL_USER TT3' || CHR(10)
                || '   WHERE T0.MEASURE = T2.COLUMN_NAME' || CHR(10)
                || '     AND T2.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '     AND T2.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '     AND T3.PROGRAM_ID(+)  = T2.PROGRAM_ID' || CHR(10)
                || '     AND T3.SHEET_NAME(+)  = T2.SHEET_NAME' || CHR(10)
                || '     AND T3.COLUMN_NAME(+) = T2.COLUMN_NAME' || CHR(10)
                || '     AND T3.USER_ID(+)     = ''' || P_USER_ID || '''' || CHR(10)
                || '     AND T0.DIVISION_ID = T4.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T4.SCM_SITE_ID(+)' || CHR(10)
                || '     AND T4.VALID_YN(+) = ''Y''' || CHR(10)
                || '     AND T0.DIVISION_ID = T5.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.FROM_SITE   = T5.FROM_SITE(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T5.ITEM_ID(+)' || CHR(10)
                || '     AND T5.YYYYMMDD(+) = ''' || V_CUTOFF_DATE || '''' || CHR(10)
                || '     AND T5.MEASURE(+)  = ''WH_STOCK''' || CHR(10)
                || '     AND T0.DIVISION_ID = T6.DIVISION_ID(+)' || CHR(10)
                || '     AND T0.ITEM_ID     = T6.ITEM_ID(+)' || CHR(10)
                || '     AND T0.DIVISION_ID = IT.DIVISION_ID' || CHR(10)
                || '     AND T0.ITEM_ID     = IT.ITEM_ID' || CHR(10)
                || '     AND TT3.DIVISION_ID(+) = T0.DIVISION_ID' || CHR(10)
                || '     AND TT3.FROM_SITE(+)   = T0.FROM_SITE' || CHR(10)
                || '     AND TT3.ITEM_ID(+)     = T0.ITEM_ID' || CHR(10)
                || '     AND TT3.VALID_YN(+)    = ''Y''' || CHR(10)
                || '     AND T2.VALID_YN = ''Y''' || CHR(10)
                || '     AND ((''' || P_NONCHK || ''' = ''Y'' AND 1 = 1)' || CHR(10)
                || '           OR TT3.USER_ID IN (SELECT CASE WHEN ''' || P_MYMODELCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END FROM DUAL' || CHR(10)
                || '                               UNION' || CHR(10)
                || '                              SELECT CASE WHEN ''' || P_DELEGATEECHK || ''' = ''Y'' THEN USER_ID ELSE ''X'' END' || CHR(10)
                || '                                FROM SSP_MST_DELEGATE WHERE VALID_YN = ''Y'' AND DELEGATEE_ID = ''' || P_USER_ID || ''' GROUP BY USER_ID)' || CHR(10)
                || '           OR TT3.PART_LEADER = CASE WHEN ''' || P_PARTLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END' || CHR(10)
                || '           OR TT3.TEAM_LEADER = CASE WHEN ''' || P_TEAMLEADERCHK || ''' = ''Y'' THEN ''' || P_USER_ID || ''' ELSE ''X'' END)' || CHR(10);

        IF P_FROM_SITE IS NOT NULL THEN
            V_MEXEC := V_MEXEC
                || '     AND T0.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(''' || P_FROM_SITE || ''', '','')))' || CHR(10);
        END IF;

        V_MEXEC := V_MEXEC
                || '     AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
                || '           OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SA' || CHR(10)
                || '                       WHERE SA.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                || '                         AND SA.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                || '                         AND SA.USER_ID    = ''' || P_USER_ID || '''' || CHR(10)
                || '                         AND SA.COLUMN_NAME = T2.COLUMN_NAME))' || CHR(10)
                || '     AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND T2.DEFAULT_FLAG = ''Y'')' || CHR(10)
                || '           OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
                || '   GROUP BY T0.DIVISION_ID, T0.ITEM_ID, IT.NICK_NAME, T0.FROM_SITE, T4.SITE_DESCRIPTION' || CHR(10)
                || '          , T0.MEASURE, T0.SEQ, T2.ATTRIBUTE1, T5.QTY, T6.QTY, T4.SHIP_FROZEN' || CHR(10)
                || ') TTT' || CHR(10)
                || ' ORDER BY TTT.DIVISION_ID, TTT.FROM_SITE DESC, TTT.ITEM_ID, TTT.SEQ ASC';

        OPEN O_RC1 FOR V_MEXEC;

        DBMS_LOB.FREETEMPORARY(V_MQRY_SUM);

    END P_SSP0015_GET_SHIPMENT_PSI_PACKER;


    /* ============================================================
       P_SSP0015_GET_SHIPMENT_PSI
       AS-IS SSP0015_GET_SHIPMENT_PSI - 화면 본체
       ※ #Tmp_RowData -> GT_SSP0015_ROWDATA
       ※ #TblDynamicTitlest_SSP0015 는 SCM_MST_TITLESET_USER 를 같은 조건으로 다시 읽는 것과
          결과가 같아 GTT 를 두지 않고 원본 테이블을 직접 참조한다.
       ※ 마지막 피벗은 조회기간만큼 날짜 칸을 만들므로 정적 SQL 로 옮길 수 없다.
          AS-IS 는 SUM 피벗(수치)과 MAX 피벗(LOT 문자)을 UNION ALL 로 합친다. 형태를 유지한다.
       ※ NOTE · Prod Qty 는 AS-IS 가 SSP0015_GET_SHIPMENT_PSI_COMMENTS 를 호출해 결과셋 2벌을 덧붙인다.
          O_RC2 · O_RC3 로 같은 벌 수를 맞춘다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_PSI
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_PLAN_TYPE             IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_PROGRAM_ID            IN  VARCHAR2,
        P_SHEET_NAME            IN  VARCHAR2,
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'F',
        P_SEQ                   IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2,
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR,
        O_RC3                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_PSI
         * Description  : Shipment PSI(Small)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/03/05   AYJ            Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/05/16   AYJ            [CSR:] MST_MEASURE DEFAULT_FLAG='N', 유져 셋팅 없을 시 화면에 노출되지 않도록 수정
         * 2019/06/17   AYJ            조회 조건 추가(p_partLeaderChk, p_teamLeaderChk)
         * 2019/08/05   MCTHEJ         [CSR ID:4045693] measure 'LOT'의 문자값에 대한 PIVOT 처리 추가
         * 2019/08/09   MCTHEJ         [CSR ID:4061695] SSP 시스템 개선 요청건(Shipment Plan) - NOTE 추가
         * 2019/08/28   AYJ            조회 조건 추가(p_delegateeChk)
         * 2019/12/17   KIMYONGHO      BOH 조정 (이름 변경 및 추가) EX) TOTAL -> oWMS
         * 2020/09/23   KIMYONGHO      WH_STOCK BOH 수량에서 CHANGE_STATUS 'Delete' 제외 ('D')
         * 2020/10/22   KIMYONGHO      POUCH_WH_IN_DAY LOOKUP에 해당하는 내용은 L/T = LOOKUP의 SEGMENT2 값 적용
         * 2021/11/01   KIMYONGHO      @p_real_flag 구분 조회
         * 2022/11/14   jilee          DM_PLN_SHIPMENT_REQ -> SITE_TYPE ='SALES' 주석처리
         * 2023/09/21   jilee          G182-P (Group='P',OSP='N')조회 추가
         * 2026.09.16   AJS            MSSQL -> Oracle 전환
         * 2026.10.07   AJS            조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         * 2026.10.07   AJS            속도 2차 : 출하 확정 구간 함수 DUAL 캐시 · HOLD 재고 한 번 집계 외부조인
         *                             · 빈 칸 0 채우기 DISTINCT 뷰 유지(NO_MERGE) · 결과 문장 재고 뷰 조건 밀어넣기 차단(NO_PUSH_PRED)
         *                             · 결과 문장 확정 버전 EXISTS 필터 고정(NO_UNNEST) · 사이트 설명 함수 DUAL 캐시
         * 2026.10.08   AJS            조회조건 Model/Nickname : 'ALL'(대소문자 무시 · 앞뒤 공백 무시) 은 조건 없음 (품목 목록 만들기 전에 판정 · 메모·생산수량 조회에도 판정 후 값 전달)
         */
        V_PLAN_VERSION_DATE     VARCHAR2(8 CHAR);
        V_REAL_FLAG             VARCHAR2(1 CHAR);
        V_PLAN_START_YYYYMMDD   VARCHAR2(8 CHAR) := P_PLAN_START_YYYYMMDD;
        V_CNT_USR_MEASURE       PLS_INTEGER := 0;
        V_PLAN_TYPE             VARCHAR2(30 CHAR) := 'SP';
        V_SEQ                   PLS_INTEGER := 1;
        V_FROM_SITE             VARCHAR2(4000 CHAR);
        V_DIVISION_ID           VARCHAR2(4000 CHAR);
        V_ITEM_ID               VARCHAR2(4000 CHAR);
        V_DATA_START_YYYYMMDD   VARCHAR2(8 CHAR);
        V_DATA_END_YYYYMMDD     VARCHAR2(8 CHAR);
        V_MQUERY                CLOB := EMPTY_CLOB();   /* SUM 피벗 칸 */
        V_MQUERY1               CLOB := EMPTY_CLOB();   /* MAX 피벗 칸(LOT) */
        V_MEXEC                 CLOB;
        V_LT_SUB                VARCHAR2(4000 CHAR);
        V_YIELD_SUB             VARCHAR2(4000 CHAR);
        V_LTYN_SUB              VARCHAR2(4000 CHAR);
        V_FIGURE_EXP            VARCHAR2(4000 CHAR);
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
/*      IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN */
        IF TRIM(P_ITEM_ID) IS NOT NULL AND UPPER(TRIM(P_ITEM_ID)) <> 'ALL' THEN   /* AJS 20261008 Model/Nickname */
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        /* GTT 초기화 - TRUNCATE 금지 */
        DELETE FROM GT_SSP0015_ROWDATA;

        SELECT COUNT(*)
          INTO V_CNT_USR_MEASURE
          FROM SCM_MST_TITLESET_USER
         WHERE 1 = 1
           AND PROGRAM_ID = P_PROGRAM_ID
           AND SHEET_NAME = P_SHEET_NAME
           AND USER_ID    = P_USER_ID;

        BEGIN
            SELECT PLAN_START_YYYYMMDD
              INTO V_PLAN_VERSION_DATE
              FROM (SELECT PLAN_START_YYYYMMDD
                      FROM SSP_PLAN_VERSION_V
                     WHERE DIVISION_ID = '40'
                     GROUP BY PLAN_START_YYYYMMDD
                     ORDER BY PLAN_START_YYYYMMDD DESC)
             WHERE ROWNUM = 1;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_PLAN_VERSION_DATE := NULL;
        END;

        IF V_PLAN_VERSION_DATE = V_PLAN_START_YYYYMMDD THEN
            V_REAL_FLAG := 'Y';
        ELSE
            V_REAL_FLAG := 'N';
        END IF;

        V_DIVISION_ID := P_DIVISION_ID;
/*      V_ITEM_ID     := P_ITEM_ID; */
        V_ITEM_ID     := CASE WHEN TRIM(P_ITEM_ID) IS NULL OR UPPER(TRIM(P_ITEM_ID)) = 'ALL' THEN NULL ELSE P_ITEM_ID END;   /* AJS 20261008 Model/Nickname : 조회조건 ALL 은 조건 없음 */
        V_FROM_SITE   := P_FROM_SITE;

        /* AS-IS : IF LEN(@p_from_site) > 6 SET @p_from_site = ''; */
        IF LENGTH(RTRIM(NVL(V_FROM_SITE, ''))) > 6 THEN
            V_FROM_SITE := '';
        END IF;

        /* DATA 생성 시작 일자 (당일) · 마지막 일자 12주(84일) */
        V_DATA_START_YYYYMMDD := V_PLAN_START_YYYYMMDD;
        V_DATA_END_YYYYMMDD   := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 84, 'YYYYMMDD');

        /* -------------1------------ 기준 원장 적재 */
        INSERT INTO GT_SSP0015_ROWDATA
               (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
              , YYYYMMDD, BOD_ID, QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
              , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_ID
              , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
              , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10)
        SELECT A.DIVISION_ID
             , A.PLAN_START_YYYYMMDD
             , A.PLAN_TYPE
             , A.SEQ
             , A.ITEM_ID
             , A.FROM_SITE
             , A.TO_SITE
             , A.MEASURE
             , A.YYYYMMDD
             , A.BOD_ID
             , A.QTY
             , A.ROUTE_ID
             , A.INCOTERMS
             , A.TRANSPORT_MODE
             , A.BIZ_TYPE
             , A.PROJECT_CODE
             , A.FCST_TYPE
             , A.FCST_ETD_DATE
             , A.FCST_ETA_DATE
             , A.ETD_DATE
             , A.ETA_DATE
             , A.CONFIRM_ID
             , A.ORIGIN_FROM_DIVISION_ID
             , A.ORIGIN_TO_DIVISION_ID
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , A.ATTRIBUTE4
             , A.ATTRIBUTE5
             , A.ATTRIBUTE6
             , A.ATTRIBUTE10
          FROM SSP_ANL_SHIP_PLAN_40 A
             , SSP_MST_MODEL_USER TT3
         WHERE TT3.DIVISION_ID(+) = A.DIVISION_ID
           AND TT3.FROM_SITE(+)   = A.FROM_SITE
           AND TT3.ITEM_ID(+)     = A.ITEM_ID
           AND TT3.VALID_YN(+)    = 'Y'
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = P_SEQ
--         AND (V_ITEM_ID IS NULL OR A.ITEM_ID = V_ITEM_ID)   --  2026.10.07 AJS
           AND (V_ITEM_ID IS NULL OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
           AND (V_FROM_SITE IS NULL
                 AND A.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                 OR A.FROM_SITE = V_FROM_SITE)
           AND ((V_REAL_FLAG = 'Y' AND A.MEASURE NOT IN ('SHIP_REQ', 'SHIP_CONFIRM', 'WH_STOCK', 'BALANCE'))
                 OR (V_REAL_FLAG = 'N' AND A.MEASURE IN ('BALANCE', 'INCO_WIP', 'INSP_WIP', 'LOT', 'MES_FCS_HOLD'
                                                       , 'MES_FCS_RELEASE', 'POSTP_PLAN', 'PROD_DATE', 'PROD_PLAN'
                                                       , 'SHIP_CONFIRM', 'SHIP_REQ', 'WH_IN', 'WH_STOCK')))
           AND A.YYYYMMDD >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD <= P_TO_YYYYMMDD
           AND EXISTS (SELECT 1
                         FROM (SELECT Z.DIVISION_ID, Z.SEQ, Z.ITEM_ID, Z.FROM_SITE, SUM(Z.QTY) AS QTY
                                 FROM SSP_ANL_SHIP_PLAN_40 Z
                                WHERE Z.DIVISION_ID         = P_DIVISION_ID
                                  AND Z.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
                                GROUP BY Z.DIVISION_ID, Z.SEQ, Z.ITEM_ID, Z.FROM_SITE) B
                        WHERE A.DIVISION_ID = B.DIVISION_ID
                          AND A.SEQ         = B.SEQ
                          AND A.ITEM_ID     = B.ITEM_ID
                          AND A.FROM_SITE   = B.FROM_SITE
                          AND B.QTY        <> 0)
           AND ((P_NONCHK = 'Y' AND 1 = 1)
                 OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                     UNION
                                    SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                      FROM SSP_MST_DELEGATE
                                     WHERE VALID_YN = 'Y'
                                       AND DELEGATEE_ID = P_USER_ID
                                     GROUP BY USER_ID)
                 OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                 OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END);

        IF V_REAL_FLAG = 'Y' THEN

            /* -------------2------------ [S]SHIP_REQ : MKT 담당자가 출하요청한 수량 */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                  , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
                  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10)
            SELECT R.DIVISION_ID
                 , V_PLAN_START_YYYYMMDD
                 , V_PLAN_TYPE
                 , V_SEQ
                 , R.ITEM_ID
                 , R.FROM_SITE
                 , R.TO_SITE
                 , 'SHIP_REQ'
                 , R.YYYYMMDD
                 , R.BOD_ID
                 , SUM(R.QTY)
                   /* AS-IS ISNULL(S.ROUTE_ID,'-') - 적재 칸이 숫자라 '-' 는 넣을 수 없다. NULL 그대로 둔다. */
                 , S.ROUTE_ID
                 , NVL(S.SSP_INCOTERMS, R.INCOTERMS)
                 , R.TRANSPORT_MODE
                 , R.BIZ_TYPE
                 , R.PROJECT_CODE
                 , R.FCST_TYPE
                 , R.FCST_ETD_DATE
                 , R.FCST_ETA_DATE
                 , R.ETD_DATE
                 , R.ETA_DATE
                 , R.CONFIRM_ID
                 , R.DIVISION_ID
                 , R.DIVISION_ID
                 , NULL   /* ATTRIBUTE1 - PROD_DATE */
                 , R.CREATED_BY   /* ATTRIBUTE2 - REQUESTOR */
                 , NULL, NULL, NULL, NULL, NULL
              FROM (
                    SELECT R.DIVISION_ID
                         , R.ITEM_ID
                         , R.PLANT_SITE_ID  AS FROM_SITE
                         , R.SCM_SITE_ID    AS TO_SITE
                         , R.MEASURE
                         , R.YYYYMMDD
                         , R.BOD_ID
                         , R.QTY
                         , R.INCOTERMS
                         , R.TRANSPORT_MODE
                         , CASE WHEN INSTR(R.PLANT_SITE_ID, '-') = 0 THEN 'A'
                                ELSE SUBSTR(R.PLANT_SITE_ID, INSTR(R.PLANT_SITE_ID, '-') + 1, 1) END AS BIZ_TYPE
                         , R.PROJECT_CODE
                         , R.FCST_TYPE
                         , R.YYYYMMDD       AS FCST_ETD_DATE
                         , NULL             AS FCST_ETA_DATE
                         , R.YYYYMMDD       AS ETD_DATE
                         , NULL             AS ETA_DATE
                         , R.ATTRIBUTE10    AS CONFIRM_ID
                         , R.CREATED_BY
                      FROM DM_PLN_SHIPMENT_REQ R
                         , SSP_MST_MODEL_USER TT3
                     WHERE TT3.DIVISION_ID(+) = R.DIVISION_ID
                       AND TT3.FROM_SITE(+)   = R.PLANT_SITE_ID
                       AND TT3.ITEM_ID(+)     = R.ITEM_ID
                       AND TT3.VALID_YN(+)    = 'Y'
                       AND R.DIVISION_ID = V_DIVISION_ID
--                     AND (V_ITEM_ID IS NULL OR R.ITEM_ID = V_ITEM_ID)   --  2026.10.07 AJS
                       AND (V_ITEM_ID IS NULL OR R.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND R.MEASURE     = 'SHIP_REQ'
                       AND (V_FROM_SITE IS NULL
                             AND R.PLANT_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                             OR R.PLANT_SITE_ID = V_FROM_SITE)
                       AND R.YYYYMMDD >= V_DATA_START_YYYYMMDD
                       AND R.YYYYMMDD <= P_TO_YYYYMMDD
                       AND R.QTY > 0
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                 UNION
                                                SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE
                                                 WHERE VALID_YN = 'Y'
                                                   AND DELEGATEE_ID = P_USER_ID
                                                 GROUP BY USER_ID)
                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                   ) R
                   /* AS-IS 의 ON S.INCOTERMS <> S.SSP_INCOTERMS 는 외부조인 대상 자체에 대한 조건이라
                      (+) 표기로는 ORA-01416 이 난다. 인라인 뷰로 먼저 걸러 같은 결과를 만든다. */
                 , (SELECT DIVISION_ID, FROM_SITE, BOD_ID, ROUTE_ID, SSP_INCOTERMS
                      FROM SCP_MST_BOD_N_V
                     WHERE INCOTERMS <> SSP_INCOTERMS) S
             WHERE S.DIVISION_ID(+)  = R.DIVISION_ID
               AND S.FROM_SITE(+)    = R.FROM_SITE
               AND S.BOD_ID(+)       = R.BOD_ID
               AND R.DIVISION_ID = V_DIVISION_ID
               AND R.MEASURE     = 'SHIP_REQ'
               AND (V_FROM_SITE IS NULL
                     AND R.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                     OR R.FROM_SITE = V_FROM_SITE)
               AND R.YYYYMMDD >= V_DATA_START_YYYYMMDD
               AND R.YYYYMMDD <= P_TO_YYYYMMDD
             GROUP BY R.DIVISION_ID
                 , R.ITEM_ID
                 , R.FROM_SITE
                 , R.TO_SITE
                 , R.YYYYMMDD
                 , R.BOD_ID
                   /* AS-IS ISNULL(S.ROUTE_ID,'-') - 적재 칸이 숫자라 '-' 는 넣을 수 없다. NULL 그대로 둔다. */
                 , S.ROUTE_ID
                 , NVL(S.SSP_INCOTERMS, R.INCOTERMS)
                 , R.TRANSPORT_MODE
                 , R.BIZ_TYPE
                 , R.PROJECT_CODE
                 , R.FCST_TYPE
                 , R.FCST_ETD_DATE
                 , R.FCST_ETA_DATE
                 , R.ETD_DATE
                 , R.ETA_DATE
                 , R.CONFIRM_ID
                 , R.CREATED_BY;

            /* -------------3------------ [S]SHIP_CONFIRM : 출하 확정 수량 */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, ROUTE_ID, INCOTERMS, TRANSPORT_MODE, BIZ_TYPE, PROJECT_CODE
                  , FCST_TYPE, FCST_ETD_DATE, FCST_ETA_DATE, ETD_DATE, ETA_DATE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID
                  , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE10)
            SELECT A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , SUM(A.QTY)
                 , A.ROUTE_ID
                 , A.INCOTERMS
                 , A.TRANSPORT_MODE
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.FCST_TYPE
                 , A.FCST_ETD_DATE
                 , MAX(A.FCST_ETA_DATE)
                 , A.ETD_DATE
                 , MAX(A.ETA_DATE)
                 , MAX(A.CONFIRM_ID)
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID
                 , NULL
                 , MAX(A.ATTRIBUTE2)
                 , NULL, NULL, NULL, NULL, NULL
              FROM (
                    SELECT C.DIVISION_ID                        AS DIVISION_ID
                         , V_PLAN_START_YYYYMMDD                AS PLAN_START_YYYYMMDD
                         , V_PLAN_TYPE                          AS PLAN_TYPE
                         , V_SEQ                                AS SEQ
                         , C.ITEM_ID                            AS ITEM_ID
                         , C.FROM_SITE                          AS FROM_SITE
                         , C.TO_SITE                            AS TO_SITE
                         , 'SHIP_CONFIRM'                       AS MEASURE
                         , C.YYYYMMDD                           AS YYYYMMDD
                         , C.BOD_ID                             AS BOD_ID
                         , C.QTY                                AS QTY
                         , C.ROUTE_ID                           AS ROUTE_ID
                         , NVL(S.SSP_INCOTERMS, C.INCOTERMS)    AS INCOTERMS
                         , C.TRANSPORT_MODE                     AS TRANSPORT_MODE
                         , C.BIZ_TYPE                           AS BIZ_TYPE
                         , C.PROJECT_CODE                       AS PROJECT_CODE
                         , C.FCST_TYPE                          AS FCST_TYPE
                         , C.FCST_ETD_DATE                      AS FCST_ETD_DATE
                         , C.FCST_ETA_DATE                      AS FCST_ETA_DATE
                         , C.ETD_DATE                           AS ETD_DATE
                         , C.ETA_DATE                           AS ETA_DATE
                         , C.CONFIRM_ID                         AS CONFIRM_ID
                         , C.DIVISION_ID                        AS ORIGIN_FROM_DIVISION_ID
                         , C.DIVISION_ID                        AS ORIGIN_TO_DIVISION_ID
                         , C.REQUESTOR                          AS ATTRIBUTE2
                      FROM SSP_ANL_SHIP_CONFIRM C
                         , (SELECT DIVISION_ID, FROM_SITE, BOD_ID, SSP_INCOTERMS
                              FROM SCP_MST_BOD_N_V
                             WHERE INCOTERMS <> SSP_INCOTERMS) S
                         , SSP_MST_MODEL_USER TT3
                     WHERE S.DIVISION_ID(+)  = C.DIVISION_ID
                       AND S.FROM_SITE(+)    = C.FROM_SITE
                       AND S.BOD_ID(+)       = C.BOD_ID
                       AND TT3.DIVISION_ID(+) = C.DIVISION_ID
                       AND TT3.FROM_SITE(+)   = C.FROM_SITE
                       AND TT3.ITEM_ID(+)     = C.ITEM_ID
                       AND TT3.VALID_YN(+)    = 'Y'
                       AND C.DIVISION_ID = V_DIVISION_ID
                       AND (V_FROM_SITE IS NULL
                             AND C.FROM_SITE IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                             OR C.FROM_SITE = V_FROM_SITE)
--                     AND (V_ITEM_ID IS NULL OR C.ITEM_ID = V_ITEM_ID)   --  2026.10.07 AJS
                       AND (V_ITEM_ID IS NULL OR C.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND C.CHANGE_TYPE = 'C'
                       AND C.BIZ_TYPE   <> 'E'   /* 전극제외 */
                       AND C.QTY > 0
                       AND C.YYYYMMDD >= V_DATA_START_YYYYMMDD
                       AND C.YYYYMMDD <= P_TO_YYYYMMDD
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                 UNION
                                                SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE
                                                 WHERE VALID_YN = 'Y'
                                                   AND DELEGATEE_ID = P_USER_ID
                                                 GROUP BY USER_ID)
                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                    UNION ALL
                    SELECT R.DIVISION_ID
                         , V_PLAN_START_YYYYMMDD
                         , V_PLAN_TYPE
                         , V_SEQ
                         , R.ITEM_ID
                         , R.PLANT_SITE_ID
                         , R.SCM_SITE_ID
                         , 'SHIP_CONFIRM'
                         , R.YYYYMMDD
                         , R.BOD_ID
                         , R.QTY
                         , S.ROUTE_ID
                         , R.INCOTERMS
                         , R.TRANSPORT_MODE
                         , CASE WHEN INSTR(R.PLANT_SITE_ID, '-') = 0 THEN 'A'
                                ELSE SUBSTR(R.PLANT_SITE_ID, INSTR(R.PLANT_SITE_ID, '-') + 1, 1) END
                         , R.PROJECT_CODE
                         , R.FCST_TYPE
                         , R.YYYYMMDD
                         , NULL
                         , R.YYYYMMDD
                         , NULL
                         , R.ATTRIBUTE10
                         , R.DIVISION_ID
                         , R.DIVISION_ID
                         , NULL
                      FROM DM_PLN_SHIPMENT_REQ R
                         , SCP_MST_BOD_N_V S
                         , SSP_MST_MODEL_USER TT3
                     WHERE S.DIVISION_ID = R.DIVISION_ID
                       AND S.FROM_SITE   = R.PLANT_SITE_ID
                       AND S.BOD_ID      = R.BOD_ID
                       AND TT3.DIVISION_ID(+) = R.DIVISION_ID
                       AND TT3.FROM_SITE(+)   = R.PLANT_SITE_ID
                       AND TT3.ITEM_ID(+)     = R.ITEM_ID
                       AND TT3.VALID_YN(+)    = 'Y'
                       AND R.DIVISION_ID = V_DIVISION_ID
--                     AND (V_ITEM_ID IS NULL OR R.ITEM_ID = V_ITEM_ID)   --  2026.10.07 AJS
                       AND (V_ITEM_ID IS NULL OR R.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND R.MEASURE     = 'SHIP_REQ'
                       AND (V_FROM_SITE IS NULL
                             AND R.PLANT_SITE_ID IN (SELECT COLUMN_VALUE FROM TABLE(FN_LIST_LOOKUP_VALUE('SSP0015_GET_SHIPMENT_PSI', 'A010A_G182A_G182P')))
                             OR R.PLANT_SITE_ID = V_FROM_SITE)
/* 2026.10.07 AJS 속도 2차 (START) : 출하 확정 구간 함수를 행마다 부르지 않고 사업부 · 사이트별 한 번 (DUAL 캐시) */
--                     AND R.YYYYMMDD > (CASE WHEN NVL(FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID), 0) = 0
--                                            THEN V_PLAN_START_YYYYMMDD
--                                            ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')
--                                                         + FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID) - 1, 'YYYYMMDD') END)
                       AND R.YYYYMMDD > (CASE WHEN NVL((SELECT FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID) FROM DUAL), 0) = 0 /* AJS 20261007 속도 */
                                              THEN V_PLAN_START_YYYYMMDD /* AJS 20261007 속도 */
                                              ELSE TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') /* AJS 20261007 속도 */
                                                           + (SELECT FN_GET_SSP_ANL_SHIP_FROZEN(R.DIVISION_ID, R.PLANT_SITE_ID) FROM DUAL) - 1, 'YYYYMMDD') END) /* AJS 20261007 속도 */
/* 2026.10.07 AJS 속도 2차 (END) */
                       AND R.YYYYMMDD <= P_TO_YYYYMMDD
                       AND R.QTY > 0
                       AND R.ATTRIBUTE10 IS NULL
                       AND ((P_NONCHK = 'Y' AND 1 = 1)
                             OR TT3.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                 UNION
                                                SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                  FROM SSP_MST_DELEGATE
                                                 WHERE VALID_YN = 'Y'
                                                   AND DELEGATEE_ID = P_USER_ID
                                                 GROUP BY USER_ID)
                             OR TT3.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                             OR TT3.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END)
                   ) A
             WHERE 1 = 1
             GROUP BY A.DIVISION_ID
                 , A.PLAN_START_YYYYMMDD
                 , A.PLAN_TYPE
                 , A.SEQ
                 , A.ITEM_ID
                 , A.FROM_SITE
                 , A.TO_SITE
                 , A.MEASURE
                 , A.YYYYMMDD
                 , A.BOD_ID
                 , A.ROUTE_ID
                 , A.INCOTERMS
                 , A.TRANSPORT_MODE
                 , A.BIZ_TYPE
                 , A.PROJECT_CODE
                 , A.FCST_TYPE
                 , A.FCST_ETD_DATE
                 , A.ETD_DATE
                 , A.ORIGIN_FROM_DIVISION_ID
                 , A.ORIGIN_TO_DIVISION_ID;

            /* -------------4------------ [I]WH_STOCK */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID)
            SELECT Z.DIVISION_ID
                 , Z.PLAN_START_YYYYMMDD
                 , Z.PLAN_TYPE
                 , Z.SEQ
                 , Z.ITEM_ID
                 , Z.FROM_SITE
                 , '-'
                 , 'WH_STOCK'
                 , Z.YYYYMMDD
                 , '-'
                   /* 전일 WH_IN , 전일 SHIP_CONFIRM 누적 */
                 , (CASE WHEN V_PLAN_START_YYYYMMDD < Z.YYYYMMDD
                         THEN (SELECT NVL(SUM(CASE X.MEASURE WHEN 'SHIP_CONFIRM'    THEN -1 * NVL(X.QTY, 0)
                                                             WHEN 'POSTP_PLAN'      THEN -1 * NVL(X.QTY, 0)
                                                             WHEN 'MES_FCS_HOLD'    THEN -1 * NVL(X.QTY, 0)
                                                             WHEN 'WH_IN'           THEN      NVL(X.QTY, 0)
                                                             WHEN 'MES_FCS_RELEASE' THEN      NVL(X.QTY, 0)
                                                        ELSE 0.0 END), 0)
                                 FROM GT_SSP0015_ROWDATA X
                                WHERE 1 = 1
                                  AND X.DIVISION_ID         = Z.DIVISION_ID
                                  AND X.PLAN_START_YYYYMMDD = Z.PLAN_START_YYYYMMDD
                                  AND X.PLAN_TYPE           = Z.PLAN_TYPE
                                  AND X.SEQ                 = Z.SEQ
                                  AND X.ITEM_ID             = Z.ITEM_ID
                                  AND X.FROM_SITE           = Z.FROM_SITE
                                  AND X.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                                  AND X.YYYYMMDD >= V_DATA_START_YYYYMMDD
                                  AND X.YYYYMMDD  < Z.YYYYMMDD)
                         ELSE 0 END)
                   /* 당일 OWMS 재고 */
                   + NVL(BOH.QTY, 0)
                   /* 2020.09.09 KBK : POUCH_WH_IN_DAY 처리 */
                   - (CASE WHEN V_PLAN_START_YYYYMMDD <= Z.YYYYMMDD
                           THEN CASE WHEN NVL(B.SEGMENT3, '/') = 'P' THEN NVL(B.WH_IN_QTY2, 0) ELSE 0 END
                           ELSE 0 END)
                   /* HOLD 재고 제외 */
/* 2026.10.07 AJS 속도 2차 (START) : HOLD 재고를 행마다 다시 읽지 않고 한 번 집계해 외부조인 (아래 IA) */
--                 - NVL((SELECT SUM(H.HOLD_QTY)
--                          FROM SSP_ANL_HOLD_STOCK H
--                             , SCM_SYS_CALENDAR_M C
--                         WHERE H.DIVISION_ID         = V_DIVISION_ID
--                           AND H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
--                           AND H.PLAN_TYPE           = V_PLAN_TYPE
--                           AND H.SEQ                 = V_SEQ
--                           AND C.BASIS_YYYYMMDD >= H.HOLD_YYYYMMDD
--                           AND C.BASIS_YYYYMMDD <= H.RELEASE_YYYYMMDD
--                           AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD
--                           AND C.BASIS_YYYYMMDD  < V_DATA_END_YYYYMMDD
--                           AND H.DIVISION_ID = Z.DIVISION_ID
--                           AND H.FROM_SITE   = Z.FROM_SITE
--                           AND H.ITEM_ID     = Z.ITEM_ID
--                           AND C.BASIS_YYYYMMDD = Z.YYYYMMDD
--                         GROUP BY H.DIVISION_ID, H.FROM_SITE, H.ITEM_ID, C.BASIS_YYYYMMDD), 0) AS QTY
                   - NVL(IA.HOLD_QTY, 0) AS QTY /* AJS 20261007 속도 */
/* 2026.10.07 AJS 속도 2차 (END) */
                 , '/'
                 , '-'
                 , '/'
                 , '/'
                 , '-'
                 , Z.DIVISION_ID
                 , Z.DIVISION_ID
              FROM (
                    SELECT DISTINCT
                           P.DIVISION_ID
                         , P.PLAN_START_YYYYMMDD
                         , P.PLAN_TYPE
                         , P.SEQ
                         , P.ITEM_ID
                         , P.FROM_SITE
                         , P.YYYYMMDD
                      FROM GT_SSP0015_ROWDATA P
                     WHERE 1 = 1
                       AND P.DIVISION_ID         = V_DIVISION_ID
                       AND P.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND P.PLAN_TYPE           = V_PLAN_TYPE
                       AND P.SEQ                 = V_SEQ
                       AND P.MEASURE IN ('SHIP_CONFIRM', 'WH_IN', 'POSTP_PLAN', 'MES_FCS_HOLD', 'MES_FCS_RELEASE')
                       AND P.YYYYMMDD >= V_DATA_START_YYYYMMDD
                       AND P.YYYYMMDD <= P_TO_YYYYMMDD
                   ) Z
                 , (SELECT XA.DIVISION_ID
                         , XA.PLAN_START_YYYYMMDD
                         , XA.PLAN_TYPE
                         , XA.SEQ
                         , XA.FROM_SITE
                         , XA.ITEM_ID
                         , SUM(XA.QTY) AS QTY
                      FROM (
                            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID
                                 , (CASE WHEN NVL(C.SEGMENT3, '/') = 'P' THEN SUM(A.LOT_QTY_MES) ELSE 0 END) AS QTY
                              FROM SSP_ANL_MES_FCS_STOCK_40_C A
                                 , SCP_MST_FINAL_ITEM B
                                 , SCM_ADM_LOOKUP_MASTER_DETAIL C
                             WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                               AND B.ITEM_ID(+)     = A.ITEM_ID
                               AND C.LOOKUP_TYPE(+) = 'CELL_TYPE_CODE'
                               AND C.VALID_YN(+)    = 'Y'
                               AND C.SEGMENT1(+)    = B.CELL_TYPE_GROUP_CODE
                               AND A.DIVISION_ID         = V_DIVISION_ID
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND A.PLAN_TYPE           = V_PLAN_TYPE
                               AND A.SEQ                 = V_SEQ
                               AND A.AVAILABLE_YN       <> 'N'
                               AND NVL(A.CHANGE_STATUS, '-') <> 'D'
                             GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID, C.SEGMENT3
                            UNION ALL
                            SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID
                                 , SUM(A.AVAILABLE_QTY) AS QTY
                              FROM SSP_ANL_OWMS_STOCK_C A
                             WHERE 1 = 1
                               AND A.DIVISION_ID         = V_DIVISION_ID
                               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND A.PLAN_TYPE           = V_PLAN_TYPE
                               AND A.SEQ                 = V_SEQ
                             GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.FROM_SITE, A.ITEM_ID
                            UNION ALL
                            /* STORAGE ID : B100(TCO Ass.BS D/F), R100(TCO Ass.SW D/F) 외주 재고 */
                            SELECT T.DIVISION_ID, T.PLAN_START_YYYYMMDD, T.PLAN_TYPE, T.SEQ, T.SCM_SITE_ID, T.ITEM_ID
                                 , ROUND(SUM(T.QTY), 0) AS QTY
                              FROM SSP_ANL_TCO_STOCK_C T
                             WHERE 1 = 1
                               AND T.DIVISION_ID         = V_DIVISION_ID
                               AND T.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                               AND T.PLAN_TYPE           = V_PLAN_TYPE
                               AND T.SEQ                 = V_SEQ
                             GROUP BY T.DIVISION_ID, T.PLAN_START_YYYYMMDD, T.PLAN_TYPE, T.SEQ, T.ITEM_ID, T.SCM_SITE_ID
                           ) XA
                     GROUP BY XA.DIVISION_ID, XA.PLAN_START_YYYYMMDD, XA.PLAN_TYPE, XA.SEQ, XA.FROM_SITE, XA.ITEM_ID) BOH
                 , (SELECT A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.FROM_SITE
                         , SUM(A.QTY) AS WH_IN_QTY2, C.SEGMENT3
                      FROM GT_SSP0015_ROWDATA A
                         , SCP_MST_FINAL_ITEM B
                         , SCM_ADM_LOOKUP_MASTER_DETAIL C
                         , SCM_ADM_LOOKUP_MASTER_DETAIL D
                     WHERE B.DIVISION_ID(+) = A.DIVISION_ID
                       AND B.ITEM_ID(+)     = A.ITEM_ID
                       AND C.LOOKUP_TYPE = 'CELL_TYPE_CODE'
                       AND C.VALID_YN    = 'Y'
                       AND C.SEGMENT3    = 'P'
                       AND C.SEGMENT1    = B.CELL_TYPE_GROUP_CODE
                       AND D.LOOKUP_TYPE = 'POUCH_WH_IN_DAY'
                       AND D.SEGMENT1    = SUBSTR(A.ITEM_ID, 1, 3)
                       AND D.VALID_YN    = 'Y'
                       AND A.DIVISION_ID         = V_DIVISION_ID
                       AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = V_PLAN_TYPE
                       AND A.SEQ                 = V_SEQ
                       AND A.MEASURE  = 'WH_IN'
                       AND A.YYYYMMDD > V_DATA_START_YYYYMMDD
                       AND A.YYYYMMDD <= TO_CHAR(TO_DATE(V_DATA_START_YYYYMMDD, 'YYYYMMDD')
                                                 + TO_NUMBER(D.SEGMENT2 DEFAULT NULL ON CONVERSION ERROR), 'YYYYMMDD')
                       AND V_REAL_FLAG = 'Y'
                     GROUP BY A.DIVISION_ID, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.SEQ, A.ITEM_ID, A.FROM_SITE, C.SEGMENT3) B
/* 2026.10.07 AJS 속도 2차 (START) : HOLD 재고 사업부 · 사이트 · 품목 · 일자별 한 번 집계 */
                 , (SELECT /*+ INDEX_SS(H PK_SSP_ANL_HOLD_STOCK_C) */ /* AJS 20261007 속도 */
                           H.DIVISION_ID /* AJS 20261007 속도 */
                         , H.FROM_SITE /* AJS 20261007 속도 */
                         , H.ITEM_ID /* AJS 20261007 속도 */
                         , C.BASIS_YYYYMMDD /* AJS 20261007 속도 */
                         , SUM(H.HOLD_QTY) AS HOLD_QTY /* AJS 20261007 속도 */
                      FROM SSP_ANL_HOLD_STOCK H /* AJS 20261007 속도 */
                         , SCM_SYS_CALENDAR_M C /* AJS 20261007 속도 */
                     WHERE C.BASIS_YYYYMMDD >= H.HOLD_YYYYMMDD /* AJS 20261007 속도 */
                       AND C.BASIS_YYYYMMDD <= H.RELEASE_YYYYMMDD /* AJS 20261007 속도 */
                       AND H.DIVISION_ID         = V_DIVISION_ID /* AJS 20261007 속도 */
                       AND H.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD /* AJS 20261007 속도 */
                       AND H.PLAN_TYPE           = V_PLAN_TYPE /* AJS 20261007 속도 */
                       AND H.SEQ                 = V_SEQ /* AJS 20261007 속도 */
                       AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD /* AJS 20261007 속도 */
                       AND C.BASIS_YYYYMMDD  < V_DATA_END_YYYYMMDD /* AJS 20261007 속도 */
                     GROUP BY H.DIVISION_ID, H.FROM_SITE, H.ITEM_ID, C.BASIS_YYYYMMDD) IA /* AJS 20261007 속도 */
/* 2026.10.07 AJS 속도 2차 (END) */
             WHERE Z.DIVISION_ID         = BOH.DIVISION_ID(+)
               AND Z.PLAN_START_YYYYMMDD = BOH.PLAN_START_YYYYMMDD(+)
               AND Z.PLAN_TYPE           = BOH.PLAN_TYPE(+)
               AND Z.SEQ                 = BOH.SEQ(+)
               AND Z.ITEM_ID             = BOH.ITEM_ID(+)
               AND Z.FROM_SITE           = BOH.FROM_SITE(+)
               AND Z.DIVISION_ID         = B.DIVISION_ID(+)
               AND Z.PLAN_START_YYYYMMDD = B.PLAN_START_YYYYMMDD(+)
               AND Z.PLAN_TYPE           = B.PLAN_TYPE(+)
               AND Z.SEQ                 = B.SEQ(+)
               AND Z.ITEM_ID             = B.ITEM_ID(+)
--             AND Z.FROM_SITE           = B.FROM_SITE(+);
               AND Z.FROM_SITE           = B.FROM_SITE(+) /* AJS 20261007 속도 */
               AND Z.DIVISION_ID         = IA.DIVISION_ID(+) /* AJS 20261007 속도 */
               AND Z.FROM_SITE           = IA.FROM_SITE(+) /* AJS 20261007 속도 */
               AND Z.ITEM_ID             = IA.ITEM_ID(+) /* AJS 20261007 속도 */
               AND Z.YYYYMMDD            = IA.BASIS_YYYYMMDD(+); /* AJS 20261007 속도 */

            /* -------------5------------ [I]BALANCE : 당일 WH_STOCK - 당일 SHIP_CONFIRM - 당일 POSTP_PLAN */
            INSERT INTO GT_SSP0015_ROWDATA
                   (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
                  , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, CONFIRM_ID
                  , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID)
            SELECT B.DIVISION_ID
                 , B.PLAN_START_YYYYMMDD
                 , B.PLAN_TYPE
                 , B.SEQ
                 , B.ITEM_ID
                 , B.FROM_SITE
                 , B.TO_SITE
                 , 'BALANCE'
                 , B.YYYYMMDD
                 , B.BOD_ID
                 , B.QTY - (SELECT SUM(C.QTY)
                              FROM GT_SSP0015_ROWDATA C
                             WHERE 1 = 1
                               AND B.DIVISION_ID         = C.DIVISION_ID
                               AND B.PLAN_START_YYYYMMDD = C.PLAN_START_YYYYMMDD
                               AND B.PLAN_TYPE           = C.PLAN_TYPE
                               AND B.SEQ                 = C.SEQ
                               AND B.ITEM_ID             = C.ITEM_ID
                               AND B.FROM_SITE           = C.FROM_SITE
                               AND B.YYYYMMDD            = C.YYYYMMDD
                               AND C.MEASURE IN ('SHIP_CONFIRM', 'POSTP_PLAN')
                             GROUP BY C.DIVISION_ID, C.PLAN_START_YYYYMMDD, C.PLAN_TYPE, C.SEQ
                                    , C.ITEM_ID, C.FROM_SITE, C.YYYYMMDD) AS QTY
                 , B.INCOTERMS
                 , B.TRANSPORT_MODE
                 , B.PROJECT_CODE
                 , B.FCST_TYPE
                 , '-'
                 , B.DIVISION_ID
                 , B.DIVISION_ID
              FROM GT_SSP0015_ROWDATA B
             WHERE 1 = 1
               AND B.DIVISION_ID         = V_DIVISION_ID
               AND B.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND B.PLAN_TYPE           = V_PLAN_TYPE
               AND B.SEQ                 = V_SEQ
               AND B.MEASURE = 'WH_STOCK';

        END IF;

        /* 빈 칸(측정항목 x 날짜) 을 0 으로 채운다 */
        INSERT INTO GT_SSP0015_ROWDATA
               (DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE, TO_SITE, MEASURE
              , YYYYMMDD, BOD_ID, QTY, INCOTERMS, TRANSPORT_MODE, PROJECT_CODE, FCST_TYPE, CONFIRM_ID
              , ORIGIN_FROM_DIVISION_ID, ORIGIN_TO_DIVISION_ID)
        SELECT SUB.DIVISION_ID
             , SUB.PLAN_START_YYYYMMDD
             , SUB.PLAN_TYPE
             , SUB.SEQ
             , SUB.ITEM_ID
             , SUB.FROM_SITE
             , SUB.TO_SITE
             , SUB.MEASURE
             , SUB.YYYYMMDD
             , SUB.BOD_ID
             , 0
             , SUB.INCOTERMS
             , SUB.TRANSPORT_MODE
             , SUB.PROJECT_CODE
             , SUB.FCST_TYPE
             , SUB.CONFIRM_ID
             , SUB.DIVISION_ID
             , SUB.DIVISION_ID
          FROM (
                SELECT B.DIVISION_ID
                     , B.PLAN_START_YYYYMMDD
                     , B.PLAN_TYPE
                     , B.SEQ
                     , B.ITEM_ID
                     , B.FROM_SITE
                     , '-'          AS TO_SITE
                     , C.MEASURE    AS MEASURE
                     , A.YYYYMMDD
                     , '-'          AS BOD_ID
                     , '-'          AS INCOTERMS
                     , '-'          AS TRANSPORT_MODE
                     , '-'          AS PROJECT_CODE
                     , '-'          AS FCST_TYPE
                     , '-'          AS CONFIRM_ID
                  FROM (SELECT C.BASIS_YYYYMMDD AS YYYYMMDD
                          FROM SCM_SYS_CALENDAR_M C
                         WHERE 1 = 1
                           AND C.BASIS_YYYYMMDD >= V_DATA_START_YYYYMMDD
                           AND C.BASIS_YYYYMMDD <= P_TO_YYYYMMDD) A
--                   , (SELECT DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE
                     , (SELECT /*+ NO_MERGE */ DISTINCT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, SEQ, ITEM_ID, FROM_SITE /* AJS 20261007 속도 */
                          FROM GT_SSP0015_ROWDATA) B
                     , (SELECT COLUMN_NAME AS MEASURE
                          FROM SCM_MST_SHEET_MEASURE
                         WHERE 1 = 1
                           AND PROGRAM_ID = P_PROGRAM_ID
                           AND SHEET_NAME = P_SHEET_NAME
                           AND VALID_YN   = 'Y') C
               ) SUB
         WHERE 1 = 1
           AND NOT EXISTS (SELECT 1
                             FROM GT_SSP0015_ROWDATA Z
                            WHERE 1 = 1
                              AND Z.DIVISION_ID         = SUB.DIVISION_ID
                              AND Z.PLAN_START_YYYYMMDD = SUB.PLAN_START_YYYYMMDD
                              AND Z.PLAN_TYPE           = SUB.PLAN_TYPE
                              AND Z.SEQ                 = SUB.SEQ
                              AND Z.ITEM_ID             = SUB.ITEM_ID
                              AND Z.FROM_SITE           = SUB.FROM_SITE
                              AND Z.MEASURE             = SUB.MEASURE
                              AND Z.YYYYMMDD            = SUB.YYYYMMDD);

        /* PIVOT 대상 날짜문자열 생성 (AS-IS 는 수치 SUM 피벗과 LOT 문자 MAX 피벗 두 벌을 UNION ALL 한다) */
        DBMS_LOB.CREATETEMPORARY(V_MQUERY, TRUE);
        DBMS_LOB.CREATETEMPORARY(V_MQUERY1, TRUE);

        FOR C IN (
            SELECT IA.YYYYMMDD
              FROM (
                    SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                         , A.BASIS_START_DATE || '21'           AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.ISO_WEEK, A.BASIS_START_DATE
                    UNION ALL
                    SELECT 'M_' || A.BASIS_YYYYMM                AS YYYYMMDD
                         , MIN(A.BASIS_START_DATE) || '01'       AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMM, A.MONTH_NAME
                    UNION ALL
                    SELECT 'D_' || A.BASIS_YYYYMMDD              AS YYYYMMDD
                         , A.BASIS_YYYYMMDD || '31'              AS SORT_ORDER_NO
                      FROM SCM_SYS_CALENDAR_M A
                     WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                     GROUP BY A.BASIS_YYYYMMDD
                   ) IA
             ORDER BY IA.SORT_ORDER_NO)
        LOOP
            /* 수치 SUM 피벗 - 결과는 문자로 돌려준다(AS-IS CONVERT(NVARCHAR(100), ...)) */
            DBMS_LOB.APPEND(V_MQUERY,
                ', TO_CHAR(TRUNC(SUM(CASE WHEN A.PIVOT_KEY = ''' || C.YYYYMMDD || ''' THEN NVL(A.QTY_NUM, 0) ELSE 0 END))) AS ' || C.YYYYMMDD || CHR(10));
            /* LOT 문자 MAX 피벗 */
            DBMS_LOB.APPEND(V_MQUERY1,
                ', MAX(CASE WHEN A.PIVOT_KEY = ''' || C.YYYYMMDD || ''' THEN A.QTY_STR END) AS ' || C.YYYYMMDD || CHR(10));
        END LOOP;

        /* LT_DAY · YEILD · LT_UPDATE_YN 스칼라 서브쿼리 */
        V_LT_SUB := '(SELECT NVL(TO_CHAR(CASE WHEN XB.SEGMENT2 IS NULL THEN XA.LT_FORMATION + NVL(XA.ATTRIBUTE1, 0)'
                 || ' ELSE TO_NUMBER(XB.SEGMENT2 DEFAULT NULL ON CONVERSION ERROR) END), '' '')'
                 || ' FROM SSP_ANL_FORMATION_C XA, SCM_ADM_LOOKUP_MASTER_DETAIL XB'
                 || ' WHERE XB.LOOKUP_TYPE(+) = ''POUCH_WH_IN_DAY'' AND XB.VALID_YN(+) = ''Y'''
                 || ' AND XB.SEGMENT1(+) = SUBSTR(XA.ITEM_ID, 1, 3) AND XB.SEGMENT3(+) = ''-'''
                 || ' AND XB.SEGMENT4(+) = ''-'' AND XB.SEGMENT5(+) = ''-'''
                 || ' AND XA.DIVISION_ID = A.DIVISION_ID AND XA.PLANT_SITE_ID = A.FROM_SITE AND XA.ITEM_ID = A.ITEM_ID'
                 || ' AND XA.PLAN_START_YYYYMMDD = ''' || P_PLAN_START_YYYYMMDD || ''''
                 || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''' AND ROWNUM = 1)';

        V_YIELD_SUB := '(SELECT NVL(TO_CHAR(ROUND(XA.SSP_MODIFY_YIELD * 100, 2)), '' '')'
                    || ' FROM SSP_ANL_FORMATION_C XA'
                    || ' WHERE XA.DIVISION_ID = A.DIVISION_ID AND XA.PLANT_SITE_ID = A.FROM_SITE AND XA.ITEM_ID = A.ITEM_ID'
                    || ' AND XA.PLAN_START_YYYYMMDD = ''' || P_PLAN_START_YYYYMMDD || ''''
                    || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''' AND ROWNUM = 1)';

        V_LTYN_SUB := '(SELECT NVL(MIN(XA.ATTRIBUTE2), '' '')'
                   || ' FROM SSP_ANL_FORMATION_C XA'
                   || ' WHERE XA.DIVISION_ID = A.DIVISION_ID AND XA.PLANT_SITE_ID = A.FROM_SITE AND XA.ITEM_ID = A.ITEM_ID'
                   || ' AND XA.PLAN_START_YYYYMMDD = ''' || P_PLAN_START_YYYYMMDD || ''''
                   || ' AND XA.PLAN_TYPE = ''' || P_PLAN_TYPE || ''' AND XA.SEQ = ''' || P_SEQ || ''')';

        V_FIGURE_EXP := 'TO_CHAR(CEIL(CASE WHEN A.MEASURE = ''MES_FCS_HOLD''    THEN NVL(W.TOTAL_QTY, 0)'
                     || ' WHEN A.MEASURE = ''MES_FCS_RELEASE'' THEN NVL(X.HOLD_QTY, 0)'
                     || ' WHEN A.MEASURE = ''WH_STOCK''        THEN NVL(Y.MES_QTY, 0)'
                     || ' WHEN A.MEASURE = ''BALANCE''         THEN NVL(Y.FCS_QTY, 0)'
                     || ' ELSE 0 END), ''FM999,999,999,999,990'')';

        DECLARE
            V_SEL_HEAD  CLOB;
            V_FROM_PART CLOB;
            V_JOIN_PART CLOB;
            V_GRP_PART  CLOB;
        BEGIN

--          V_SEL_HEAD := ' SELECT A.DIVISION_ID' || CHR(10)
            V_SEL_HEAD := ' SELECT /*+ NO_PUSH_PRED(W) */ A.DIVISION_ID' || CHR(10) /* AJS 20261007 속도 */
                       || '      , A.FROM_SITE' || CHR(10)
--                     || '      , NVL(FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE), ''-'') AS FROM_SITE_NM' || CHR(10)
                       || '      , NVL((SELECT FN_GET_SCM_SITE_DESCRIPTION(A.DIVISION_ID, A.FROM_SITE) FROM DUAL), ''-'') AS FROM_SITE_NM' || CHR(10) /* AJS 20261007 속도 */
                       || '      , A.PLAN_START_YYYYMMDD' || CHR(10)
                       || '      , A.PLAN_TYPE' || CHR(10)
                       || '      , A.ITEM_ID' || CHR(10)
                       || '      , NVL(A.SHIP_FROZEN, 0) AS SHIP_FROZEN' || CHR(10)
                       || '      , A.SEQ' || CHR(10)
                       || '      , FN_GET_ITEM_NICKNAME(A.DIVISION_ID, A.ITEM_ID) AS NICK_NAME' || CHR(10)
                       || '      , A.MEASURE' || CHR(10)
                       || '      , A.MEASURE_NAME' || CHR(10)
                       || '      , A.USER_SORT_ORDER_NO' || CHR(10)
                       || '      , A.PSI_NAME' || CHR(10)
                       || '      , A.FROM_YYYYMMDD' || CHR(10)
                       || '      , A.TO_YYYYMMDD' || CHR(10)
                       || '      , ' || V_LT_SUB || ' AS LT_DAY' || CHR(10)
                       || '      , ' || V_YIELD_SUB || ' AS YEILD' || CHR(10)
                       || '      , ' || V_LTYN_SUB || ' AS LT_UPDATE_YN' || CHR(10)
                       || '      , (CASE WHEN A.MEASURE = ''MES_FCS_HOLD'' THEN ''oWMS'' WHEN A.MEASURE = ''MES_FCS_RELEASE'' THEN ''Hold'''
                       || '              WHEN A.MEASURE = ''WH_STOCK'' THEN ''MES'' WHEN A.MEASURE = ''BALANCE'' THEN ''FCS'' ELSE '' '' END) AS TYPE' || CHR(10)
                       || '      , ' || V_FIGURE_EXP || ' AS FIGURE' || CHR(10);

            V_FROM_PART := '   FROM (SELECT T3.DIVISION_ID, T3.PLAN_START_YYYYMMDD, T3.PLAN_TYPE, T3.FROM_SITE' || CHR(10)
                        || '              , T3.ITEM_ID, T3.SEQ, T3.SHIP_FROZEN, T3.PIVOT_KEY' || CHR(10)
                        || '              , CASE WHEN T0.COLUMN_NAME = ''PROD_DATE''' || CHR(10)
                        || '                     THEN TO_NUMBER(T3.QTY_STR DEFAULT NULL ON CONVERSION ERROR)' || CHR(10)
                        || '                     ELSE T3.QTY_NUM END AS QTY_NUM' || CHR(10)
                        || '              , CASE WHEN T0.COLUMN_NAME = ''LOT'' THEN T3.QTY_STR' || CHR(10)
                        || '                     ELSE TO_CHAR(T3.QTY_NUM) END AS QTY_STR' || CHR(10)
                        || '              , T0.COLUMN_NAME       AS MEASURE' || CHR(10)
                        || '              , T0.COLUMN_LABEL_NAME AS MEASURE_NAME' || CHR(10)
                        || '              , T0.ATTRIBUTE1        AS PSI_NAME' || CHR(10)
                        || '              , NVL(T1.SORT_ORDER_NO, T0.SORT_ORDER_NO) AS USER_SORT_ORDER_NO' || CHR(10)
                        || '              , ''' || P_FROM_YYYYMMDD || ''' AS FROM_YYYYMMDD' || CHR(10)
                        || '              , ''' || P_TO_YYYYMMDD || ''' AS TO_YYYYMMDD' || CHR(10)
                        || '           FROM SCM_MST_SHEET_MEASURE T0' || CHR(10)
                        || '              , SCM_MST_TITLESET_USER T1' || CHR(10)
                        || '              , (SELECT TT0.DIVISION_ID, TT0.PLAN_START_YYYYMMDD, TT0.PLAN_TYPE, TT0.FROM_SITE' || CHR(10)
                        || '                      , TT0.ITEM_ID, ''D_'' || TT0.YYYYMMDD AS PIVOT_KEY, TT0.MEASURE AS MEASURE_KEY' || CHR(10)
                        || '                      , SUM(TT0.QTY) AS QTY_NUM, MAX(TT0.ATTRIBUTE1) AS QTY_STR' || CHR(10)
                        || '                      , MAX(TT0.SEQ) AS SEQ, TT2.SHIP_FROZEN' || CHR(10)
                        || '                   FROM GT_SSP0015_ROWDATA TT0, SCM_MST_SITE TT2' || CHR(10)
                        || '                  WHERE (CASE WHEN TT0.DIVISION_ID = ''EE'' THEN TT0.ORIGIN_FROM_DIVISION_ID ELSE TT0.DIVISION_ID END) = TT2.DIVISION_ID(+)' || CHR(10)
                        || '                    AND TT0.FROM_SITE = TT2.SCM_SITE_ID(+)' || CHR(10)
                        || '                    AND TT2.VALID_YN(+) = ''Y''' || CHR(10)
                        || '                    AND TT0.YYYYMMDD >= ''' || P_FROM_YYYYMMDD || '''' || CHR(10)
                        || '                    AND TT0.YYYYMMDD <= ''' || P_TO_YYYYMMDD || '''' || CHR(10)
--                      || '                    AND EXISTS (SELECT 1 FROM (SELECT DIVISION_ID, MAX(PLAN_SEQ) AS PLAN_SEQ' || CHR(10)
                        || '                    AND EXISTS (SELECT /*+ NO_UNNEST */ 1 FROM (SELECT DIVISION_ID, MAX(PLAN_SEQ) AS PLAN_SEQ' || CHR(10) /* AJS 20261007 속도 */
                        || '                                                 FROM SSP_PLAN_VERSION_V' || CHR(10)
                        || '                                                WHERE PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '                                                  AND CONFIRM_FLAG = ''Y''' || CHR(10)
                        || '                                                  AND PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '                                                GROUP BY DIVISION_ID) SA' || CHR(10)
                        || '                                 WHERE SA.DIVISION_ID = TT0.DIVISION_ID AND SA.PLAN_SEQ = TT0.SEQ)' || CHR(10)
                        || '                  GROUP BY TT0.DIVISION_ID, TT0.PLAN_START_YYYYMMDD, TT0.PLAN_TYPE, TT0.FROM_SITE' || CHR(10)
                        || '                         , TT0.ITEM_ID, TT0.YYYYMMDD, TT2.SHIP_FROZEN, TT0.MEASURE) T3' || CHR(10)
                        || '          WHERE T1.PROGRAM_ID(+)  = T0.PROGRAM_ID' || CHR(10)
                        || '            AND T1.SHEET_NAME(+)  = T0.SHEET_NAME' || CHR(10)
                        || '            AND T1.COLUMN_NAME(+) = T0.COLUMN_NAME' || CHR(10)
                        || '            AND T1.USER_ID(+)     = ''' || P_USER_ID || '''' || CHR(10)
                        || '            AND T0.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                        || '            AND T0.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                        || '            AND T0.VALID_YN   = ''Y''' || CHR(10)
                        || '            AND (' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0' || CHR(10)
                        || '                  OR EXISTS (SELECT 1 FROM SCM_MST_TITLESET_USER SB' || CHR(10)
                        || '                              WHERE SB.PROGRAM_ID = ''' || P_PROGRAM_ID || '''' || CHR(10)
                        || '                                AND SB.SHEET_NAME = ''' || P_SHEET_NAME || '''' || CHR(10)
                        || '                                AND SB.USER_ID    = ''' || P_USER_ID || '''' || CHR(10)
                        || '                                AND SB.COLUMN_NAME = T0.COLUMN_NAME))' || CHR(10)
                        || '            AND ((' || TO_CHAR(V_CNT_USR_MEASURE) || ' = 0 AND T0.DEFAULT_FLAG = ''Y'')' || CHR(10)
                        || '                  OR (' || TO_CHAR(V_CNT_USR_MEASURE) || ' != 0))' || CHR(10)
                        || '            AND T0.COLUMN_NAME = T3.MEASURE_KEY' || CHR(10);

            V_JOIN_PART := '        ) A' || CHR(10)
                        || '      , (SELECT S.DIVISION_ID, S.PLAN_START_YYYYMMDD, S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID, SUM(S.QTY) AS TOTAL_QTY' || CHR(10)
                        || '           FROM SSP_ANL_WH_STOCK_V S' || CHR(10)
                        || '          WHERE S.PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '            AND S.PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '            AND S.DIVISION_ID = ''' || V_DIVISION_ID || '''' || CHR(10)
                        || '            AND S.SEQ = ''' || P_SEQ || '''' || CHR(10)
                        || '          GROUP BY S.DIVISION_ID, S.PLAN_START_YYYYMMDD, S.PLAN_TYPE, S.SEQ, S.FROM_SITE, S.ITEM_ID) W' || CHR(10)
                        || '      , (SELECT K.DIVISION_ID, K.FROM_SITE, K.ITEM_ID, SUM(K.HOLD_QTY) AS HOLD_QTY' || CHR(10)
                        || '           FROM SSP_ANL_HOLD_STOCK K' || CHR(10)
                        || '          WHERE K.HOLD_YYYYMMDD <= ''' || TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') || '''' || CHR(10)
                        || '            AND K.RELEASE_YYYYMMDD >= ''' || TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') + 1, 'YYYYMMDD') || '''' || CHR(10)
                        || '            AND K.PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '            AND K.PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '            AND K.SEQ = ''' || P_SEQ || '''' || CHR(10)
                        || '          GROUP BY K.DIVISION_ID, K.FROM_SITE, K.ITEM_ID) X' || CHR(10)
                        || '      , (SELECT M.DIVISION_ID, M.PLAN_START_YYYYMMDD, M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID' || CHR(10)
                        || '              , SUM(M.LOT_QTY_MES) AS MES_QTY, SUM(M.LOT_QTY_FCS) AS FCS_QTY' || CHR(10)
                        || '           FROM SSP_ANL_MES_FCS_STOCK_40_C M' || CHR(10)
                        || '          WHERE M.PLAN_START_YYYYMMDD = ''' || V_PLAN_START_YYYYMMDD || '''' || CHR(10)
                        || '            AND M.PLAN_TYPE = ''' || P_PLAN_TYPE || '''' || CHR(10)
                        || '            AND M.DIVISION_ID = ''' || V_DIVISION_ID || '''' || CHR(10)
                        || '            AND M.AVAILABLE_YN <> ''N''' || CHR(10)
                        || '            AND M.CHANGE_STATUS <> ''D''' || CHR(10)
                        || '            AND M.SEQ = ''' || P_SEQ || '''' || CHR(10)
                        || '            AND M.AVAILABLE_YN = ''Y''' || CHR(10)
                        || '          GROUP BY M.DIVISION_ID, M.PLAN_START_YYYYMMDD, M.PLAN_TYPE, M.SEQ, M.FROM_SITE, M.ITEM_ID) Y' || CHR(10)
                        || '  WHERE A.DIVISION_ID = W.DIVISION_ID(+) AND A.PLAN_START_YYYYMMDD = W.PLAN_START_YYYYMMDD(+)' || CHR(10)
                        || '    AND A.FROM_SITE = W.FROM_SITE(+) AND A.ITEM_ID = W.ITEM_ID(+)' || CHR(10)
                        || '    AND A.DIVISION_ID = X.DIVISION_ID(+) AND A.FROM_SITE = X.FROM_SITE(+) AND A.ITEM_ID = X.ITEM_ID(+)' || CHR(10)
                        || '    AND A.DIVISION_ID = Y.DIVISION_ID(+) AND A.PLAN_START_YYYYMMDD = Y.PLAN_START_YYYYMMDD(+)' || CHR(10)
                        || '    AND A.FROM_SITE = Y.FROM_SITE(+) AND A.ITEM_ID = Y.ITEM_ID(+)' || CHR(10);

            V_GRP_PART := '  GROUP BY A.DIVISION_ID, A.FROM_SITE, A.PLAN_START_YYYYMMDD, A.PLAN_TYPE, A.ITEM_ID' || CHR(10)
                       || '         , A.SHIP_FROZEN, A.SEQ, A.MEASURE, A.MEASURE_NAME, A.USER_SORT_ORDER_NO, A.PSI_NAME' || CHR(10)
                       || '         , A.FROM_YYYYMMDD, A.TO_YYYYMMDD, W.TOTAL_QTY, X.HOLD_QTY, Y.MES_QTY, Y.FCS_QTY' || CHR(10);

            V_MEXEC := 'SELECT * FROM (' || CHR(10)
                    || V_SEL_HEAD || V_MQUERY || V_FROM_PART
                    || '            AND T3.MEASURE_KEY != ''LOT''' || CHR(10)
                    || V_JOIN_PART || V_GRP_PART
                    || ' UNION ALL' || CHR(10)
                    || V_SEL_HEAD || V_MQUERY1 || V_FROM_PART
                    || '            AND T3.MEASURE_KEY = ''LOT''' || CHR(10)
                    || V_JOIN_PART || V_GRP_PART
                    || ') TTTT ORDER BY DIVISION_ID, FROM_SITE, ITEM_ID, USER_SORT_ORDER_NO';

        END;

        OPEN O_RC1 FOR V_MEXEC;

        /* NOTE, Prod_Qty Load */
/*      P_SSP0015_GET_SHIPMENT_PSI_COMMENTS(V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_FROM_SITE, P_ITEM_ID */
        P_SSP0015_GET_SHIPMENT_PSI_COMMENTS(V_DIVISION_ID, V_PLAN_START_YYYYMMDD, V_FROM_SITE, V_ITEM_ID   /* AJS 20261008 Model/Nickname : ALL 판정 후 값(ALL 이면 빈 값) */
                                          , P_FROM_YYYYMMDD, P_TO_YYYYMMDD, O_RC2, O_RC3);

        DBMS_LOB.FREETEMPORARY(V_MQUERY);
        DBMS_LOB.FREETEMPORARY(V_MQUERY1);

    END P_SSP0015_GET_SHIPMENT_PSI;

    /* ============================================================
       P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40
       AS-IS SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40
       ※ '^' 로 이어 붙인 여러 행을 SCM_ARR_SPL_VAL 로 잘라 한 행씩 처리한다(AS-IS 동일).
       ※ 행 구분(ACTIVE_FLAG) : 'I' = 신규 출하확정 생성, 'I' 가 아닌 값(M·D) = 기존 출하확정 수정(AS-IS 동일, 삭제 갈래 없음).
       ※ AS-IS #TblDynamic_SSP0015_40_STD → GT_SSP0015_40_STD(ON COMMIT PRESERVE ROWS, 시작 시 DELETE).
       ※ 저장 시작에 SAVEPOINT 를 두어 BOD 없음('X')·오류('F') 시 앞 행 저장분까지 되돌린다.
          (AS-IS 는 트랜잭션이 없어 앞 행 저장분이 남고, 오류 시 CATCH 에서 COMMIT 한다)
       ※ AS-IS 가 부르는 하위 프로시저 3개는 Oracle 에 없다(2026.09.17 기준) — 호출 자리를 주석으로 남긴다.
          PR_DM_SSP_CONFIRM_SYNC · PR_SSP_ANL_SHIP_CONFIRM_HIST · PR_SSP_MAIL_SEND_ADJUST_MST
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        P_SHIPMENT_QTY          IN  VARCHAR2,
        P_SHIPMENT_DATE         IN  VARCHAR2,
        P_NEW_BOD_ID            IN  VARCHAR2,
        P_NEW_ROUTE_ID          IN  VARCHAR2,
        P_NEW_ETD_DATE          IN  VARCHAR2,
        P_NEW_ETA_DATE          IN  VARCHAR2,
        P_NEW_INCOTERMS         IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE    IN  VARCHAR2,
        P_NEW_D_CONTRY          IN  VARCHAR2,
        P_NEW_D_PORT_CODE       IN  VARCHAR2,
        P_NEW_A_COUNTRY         IN  VARCHAR2,
        P_NEW_A_PORT_CODE       IN  VARCHAR2,
        P_NEW_CUSTOMER_LT       IN  VARCHAR2,
        P_NEW_TO_COUNTRY        IN  VARCHAR2,
        P_NEW_TO_CITY           IN  VARCHAR2,
        P_REMARKS               IN  VARCHAR2,
        P_REMARKS2              IN  VARCHAR2,
        P_REMARKS3              IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_CHECK_NEED_YN         IN  VARCHAR2,
        P_EDIT_MAIN             IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40
         * Description  : Shipment Request Confirm 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2019/03/12   AYJ            Initial Release [PJ20189106] 전지.GSCM 고도화 이행 PROJECT
         * 2019/04/30   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 제거
         * 2019/05/07   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
         * 2019/05/30   mcTheJ         [PJ20189106] 전지.GSCM 고도화 이행  CHANGE_REASON 추가로 인한 메일 SEND 수정
         * 2019/09/04   AYJ            etd:shipdate, eta:etd+lt_day로 셋팅
         * 2019/10/29   ayj            FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
         * 2019/11/26   KIMYONGHO      메일 전송 변경 JOB.SCM_SSP_ADJUST_MAIL_SEND_BATCH -> PR_SSP_MAIL_SEND_ADJUST_MST
         * 2020/06/23   khj79          ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정
         * 2021/01/07   KIMYONGHO      [C20201223-000448] MKT FCST - SSP Sync
         * 2021/01/12   KIMYONGHO      [C20201223-000448] MKT FCST - SSP Sync 운영이관 검증 단계에서 처리 지연 현상으로 END LOG 이후 호출로 조정함.
         * 2021/11/15   KIMYONGHO      PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 제외 처리
         * 2024/06/10   jilee          Plan 하단 신규 건 Change Req 정보 입력
         * 2024/10/01   KHJ            NERP_SSP
         * 2026.09.17   AJS            MSSQL -> Oracle 전환
         */
        V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40';
        V_LOG_TYPE                  VARCHAR2(30 CHAR);
        N_LOG_COUNT                 NUMBER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
        V_DESCRIPTION               VARCHAR2(500 CHAR);
        D_EVENT_DATE                DATE;

        V_DELIMITER                 VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT              PLS_INTEGER := 0;
        V_MST_LOOP_CNT              PLS_INTEGER := 0;

        V_ACTIVE_FLAG               VARCHAR2(4000 CHAR);
        V_DIVISION_ID               VARCHAR2(4000 CHAR);
        V_CONFIRM_ID                VARCHAR2(4000 CHAR);
        V_SHIPMENT_QTY              VARCHAR2(4000 CHAR);
        V_SHIPMENT_DATE             VARCHAR2(4000 CHAR);
        V_BOD_SHIPMENT_DATE         VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID                VARCHAR2(4000 CHAR);
        V_NEW_ETD_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ETA_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS             VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE        VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY              VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY             VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT           VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY            VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY               VARCHAR2(4000 CHAR);
        V_REMARKS                   VARCHAR2(4000 CHAR);
        V_REMARKS2                  VARCHAR2(4000 CHAR);
        V_REMARKS3                  VARCHAR2(4000 CHAR);
        V_CHECK_NEED_YN             VARCHAR2(4000 CHAR);
        V_EDIT_MAIN                 VARCHAR2(4000 CHAR);
        V_CREATE_DATE               DATE := SYSDATE;
        V_BEFORE_QTY                NUMBER;         /* AS-IS INT */
        V_QTY                       NUMBER;         /* AS-IS INT */

        N_DIVISION_ID               SSP_ANL_SHIP_CONFIRM.DIVISION_ID%TYPE;
        N_ITEM_ID                   SSP_ANL_SHIP_CONFIRM.ITEM_ID%TYPE;
        N_FROM_SITE                 SSP_ANL_SHIP_CONFIRM.FROM_SITE%TYPE;
        N_TO_SITE                   SSP_ANL_SHIP_CONFIRM.TO_SITE%TYPE;
        N_YYYYMMDD                  SSP_ANL_SHIP_CONFIRM.YYYYMMDD%TYPE;
        N_BOD_ID                    SSP_ANL_SHIP_CONFIRM.BOD_ID%TYPE;
        N_PROJECT_CODE              SSP_ANL_SHIP_CONFIRM.PROJECT_CODE%TYPE;
        N_FCST_TYPE                 SSP_ANL_SHIP_CONFIRM.FCST_TYPE%TYPE;
        N_INCOTERMS                 SSP_ANL_SHIP_CONFIRM.INCOTERMS%TYPE;
        N_TRANSPORT_MODE            SSP_ANL_SHIP_CONFIRM.TRANSPORT_MODE%TYPE;
        N_CONFIRM_ID                SSP_ANL_SHIP_CONFIRM.CONFIRM_ID%TYPE;
        V_PLAN_START_YYYYMMDD       VARCHAR2(4000 CHAR);
        V_SEQ                       NUMBER;
        V_CHK                       PLS_INTEGER := 0;
        V_CHK_REQ                   PLS_INTEGER := 0;

        N_ORI_DIVISION_ID           SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.DIVISION_ID%TYPE;
        N_ORI_ITEM_ID               SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.ITEM_ID%TYPE;
        N_ORI_FROM_SITE             SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.FROM_SITE%TYPE;
        N_ORI_TO_SITE               SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.TO_SITE%TYPE;
        N_ORI_YYYYMMDD              SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.YYYYMMDD%TYPE;
        N_ORI_BOD_ID                SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.BOD_ID%TYPE;
        N_ORI_PROJECT_CODE          SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.PROJECT_CODE%TYPE;
        N_ORI_FCST_TYPE             SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.FCST_TYPE%TYPE;
        N_ORI_INCOTERMS             SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.INCOTERMS%TYPE;
        N_ORI_TRANSPORT_MODE        SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.TRANSPORT_MODE%TYPE;
        N_ORI_CONFIRM_ID            SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.CONFIRM_ID%TYPE;
        V_CHANGE_REQ_NO             SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE.CHANGE_REQ_NO%TYPE;

        V_DIVISION_ID_TEMP          SCP_MST_BOD_N_V.DIVISION_ID%TYPE;
        V_NEW_BOD_ID_TEMP           SCP_MST_BOD_N_V.BOD_ID%TYPE;
        V_FROM_SITE_TEMP            SCP_MST_BOD_N_V.FROM_SITE%TYPE;
        V_TO_SITE_TEMP              SCP_MST_BOD_N_V.TO_SITE%TYPE;
        V_ITEM_ID_TEMP              SSP_ANL_SHIP_CONFIRM.ITEM_ID%TYPE;
        V_NEW_INCOTERMS_TEMP        SCP_MST_BOD_N_V.SSP_INCOTERMS%TYPE;
        V_NEW_TRANSPORT_MODE_TEMP   SCP_MST_BOD_N_V.TRANSPORT_MODE%TYPE;
        V_NEW_ROUTE_ID_TEMP         SCP_MST_BOD_N_V.ROUTE_ID%TYPE;
        V_NEW_D_CONTRY_TEMP         SCP_MST_BOD_N_V.D_COUNTRY%TYPE;
        V_NEW_D_PORT_CODE_TEMP      SCP_MST_BOD_N_V.D_PORT_CODE%TYPE;
        V_NEW_A_COUNTRY_TEMP        SCP_MST_BOD_N_V.A_COUNTRY%TYPE;
        V_NEW_A_PORT_CODE_TEMP      SCP_MST_BOD_N_V.A_PORT_CODE%TYPE;
        V_NEW_CUSTOMER_LT_TEMP      SCP_MST_BOD_N_V.LT_TOTAL%TYPE;
        V_NEW_TO_COUNTRY_TEMP       SCP_MST_BOD_N_V.TO_COUNTRY%TYPE;
        V_NEW_TO_CITY_TEMP          SCP_MST_BOD_N_V.TO_CITY%TYPE;

        V_NEW_CONFIRM_ID            VARCHAR2(4000 CHAR);
        V_INFSEQNO                  VARCHAR2(14 CHAR);
        V_LAST_CONFIRM_DATE         VARCHAR2(8 CHAR);
        V_TMP_FN_TIME_ZONE          VARCHAR2(8 CHAR);

        V_MAX_REQ_NO                VARCHAR2(40 CHAR);
        V_USER_DEPT_ID              VARCHAR2(50 CHAR);

        V_ELECTRODE_YN              SSP_ANL_SHIP_CONFIRM.ELECTRODE_YN%TYPE;
        V_ELECTRODE_TYPE            SSP_ANL_SHIP_CONFIRM.ELECTRODE_TYPE%TYPE;
        V_ORIGIN_FROM_DIVISION_ID   SSP_ANL_SHIP_CONFIRM.ORIGIN_FROM_DIVISION_ID%TYPE;
        V_ORIGION_TO_DIVISION_ID    SSP_ANL_SHIP_CONFIRM.ORIGIN_TO_DIVISION_ID%TYPE;

        /*//메일관련 변수////////////////////////////////*/
        V_GRP_CHANGE_REQ            VARCHAR2(20 CHAR);
        V_MAIL_FLAG                 PLS_INTEGER := 0;
        V_MAIL_CHK                  PLS_INTEGER := 0;

        V_ERR_CODE                  NUMBER;
        V_ERR_MESSAGE               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_CONFIRM_40;

        V_GRP_CHANGE_REQ := 'G' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF3');

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        DELETE FROM GT_SSP0015_40_STD;

        /* SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다. */
        INSERT INTO GT_SSP0015_40_STD         /* 기준 데이터 저장 */
               (DIVISION_ID
              , FROM_SITE
              , PLAN_START_YYYYMMDD
              , COMPANY_ID)
        SELECT DISTINCT
               IA.DIVISION_ID
             , IA.FROM_SITE
             , IA.PLAN_START_YYYYMMDD
             , B.COMPANY_ID
          FROM (SELECT SP.DIVISION_ID
                     , SP.FROM_SITE
                     , SP.PLAN_START_YYYYMMDD
                     , RANK() OVER(PARTITION BY SP.FROM_SITE ORDER BY SP.PLAN_START_YYYYMMDD DESC) AS RNK
                  FROM SSP_ANL_SHIP_PLAN_40 SP
                 WHERE SP.DIVISION_ID          = '40'
                   AND SP.PLAN_START_YYYYMMDD >= TO_CHAR(SYSDATE - 3, 'YYYYMMDD')  /* 전일 */
                   AND SP.PLAN_START_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')      /* 당일 */
                   AND SP.QTY                  > 0) IA
             , SCM_MST_SITE B
         WHERE B.DIVISION_ID = IA.DIVISION_ID
           AND B.SCM_SITE_ID = IA.FROM_SITE
           AND IA.RNK        = 1;

        V_MAX_LOOP_CNT := SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER);

        WHILE LENGTH(RTRIM(P_ACTIVE_FLAG)) > 0 AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            /* @mst_loop_cnt 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG        := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,        V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID        := SCM_ARR_SPL_VAL(P_DIVISION_ID,        V_DELIMITER, V_MST_LOOP_CNT);
            V_CONFIRM_ID         := SCM_ARR_SPL_VAL(P_CONFIRM_ID,         V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_QTY       := SCM_ARR_SPL_VAL(P_SHIPMENT_QTY,       V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_DATE      := SCM_ARR_SPL_VAL(P_SHIPMENT_DATE,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_BOD_ID         := SCM_ARR_SPL_VAL(P_NEW_BOD_ID,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETD_DATE       := SCM_ARR_SPL_VAL(P_NEW_ETD_DATE,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETA_DATE       := SCM_ARR_SPL_VAL(P_NEW_ETA_DATE,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ROUTE_ID       := SCM_ARR_SPL_VAL(P_NEW_ROUTE_ID,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_INCOTERMS      := SCM_ARR_SPL_VAL(P_NEW_INCOTERMS,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TRANSPORT_MODE := SCM_ARR_SPL_VAL(P_NEW_TRANSPORT_MODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_CONTRY       := SCM_ARR_SPL_VAL(P_NEW_D_CONTRY,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_PORT_CODE    := SCM_ARR_SPL_VAL(P_NEW_D_PORT_CODE,    V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_COUNTRY      := SCM_ARR_SPL_VAL(P_NEW_A_COUNTRY,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_PORT_CODE    := SCM_ARR_SPL_VAL(P_NEW_A_PORT_CODE,    V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_CUSTOMER_LT    := SCM_ARR_SPL_VAL(P_NEW_CUSTOMER_LT,    V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_COUNTRY     := SCM_ARR_SPL_VAL(P_NEW_TO_COUNTRY,     V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_CITY        := SCM_ARR_SPL_VAL(P_NEW_TO_CITY,        V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS            := SCM_ARR_SPL_VAL(P_REMARKS,            V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS2           := SCM_ARR_SPL_VAL(P_REMARKS2,           V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS3           := SCM_ARR_SPL_VAL(P_REMARKS3,           V_DELIMITER, V_MST_LOOP_CNT);
            V_CHECK_NEED_YN      := SCM_ARR_SPL_VAL(P_CHECK_NEED_YN,      V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_MAIN          := SCM_ARR_SPL_VAL(P_EDIT_MAIN,          V_DELIMITER, V_MST_LOOP_CNT);

            /* 출하확정 행이 없으면 앞 행 값 유지(AS-IS 변수 대입 SELECT 동일) */
            BEGIN
                SELECT FROM_SITE
                     , TO_SITE
                     , ITEM_ID
                  INTO V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_ITEM_ID_TEMP
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            /* AS-IS 는 BOD 적용일 비교에 변환 전 출하일('YYYY-MM-DD HH:MI:SS.FFF')을 그대로 쓴다.
               AS-IS 정렬 규칙(Latin1_General_CI_AS)은 하이픈을 무시하므로 하이픈만 뺀 값으로 비교한다.
               (결과 : 적용 시작일 <= 출하일, 적용 종료일 > 출하일 — 종료일 당일 출하는 BOD 없음) */
            V_BOD_SHIPMENT_DATE := REPLACE(V_SHIPMENT_DATE, '-', '');

            /* BOD 가 없으면 앞 행 값 유지(AS-IS 변수 대입 SELECT TOP 1 동일) */
            BEGIN
                SELECT XA.DIVISION_ID
                     , XA.BOD_ID
                     , XA.FROM_SITE
                     , XA.TO_SITE
                     , XA.SSP_INCOTERMS
                     , XA.TRANSPORT_MODE
                     , XA.ROUTE_ID
                     , XA.D_COUNTRY
                     , XA.D_PORT_CODE
                     , XA.A_COUNTRY
                     , XA.A_PORT_CODE
                     , XA.LT_TOTAL
                     , XA.TO_COUNTRY
                     , XA.TO_CITY
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
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
                          FROM (SELECT DISTINCT
                                       B.DIVISION_ID
                                     , B.BOD_ID
                                     , B.FROM_SITE
                                     , B.TO_SITE
                                     , B.SSP_INCOTERMS
                                     , B.TRANSPORT_MODE
                                     , B.ROUTE_ID
                                     , B.D_COUNTRY
                                     , B.D_PORT_CODE
                                     , B.A_COUNTRY
                                     , B.A_PORT_CODE
                                     , B.LT_TOTAL
                                     , B.LT_TOTAL_ORIGIN
                                     , B.TO_COUNTRY
                                     , B.TO_CITY
                                     , B.PRIORITY
                                     , B.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V B
                                 WHERE B.BOD_VALID_YN        = 'Y'
                                   AND B.DIVISION_ID         = V_DIVISION_ID
                                   AND B.FROM_SITE           = V_FROM_SITE_TEMP
                                   AND B.TO_SITE             = V_TO_SITE_TEMP
                                   AND UPPER(B.TRANSPORT_MODE) = UPPER(V_NEW_TRANSPORT_MODE)
                                   AND UPPER(B.SSP_INCOTERMS)  = UPPER(V_NEW_INCOTERMS)
                                   AND B.FROM_YYYYMMDD      <= V_BOD_SHIPMENT_DATE
                                   AND B.TO_YYYYMMDD        >= V_BOD_SHIPMENT_DATE) IA
                             , (SELECT DISTINCT
                                       DIVISION_ID
                                     , ITEM_ID
                                     , BOD_ID
                                  FROM SCP_MST_BOD_ITEM
                                 WHERE DIVISION_ID = V_DIVISION_ID
                                   AND ITEM_ID     = V_ITEM_ID_TEMP) IB
                         WHERE IB.DIVISION_ID = IA.DIVISION_ID
                           AND IB.BOD_ID      = IA.BOD_ID
                         ORDER BY IA.PRIORITY NULLS FIRST
                                , IA.BOD_ID) XA
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            IF (   V_DIVISION_ID_TEMP        IS NULL
                OR V_NEW_BOD_ID_TEMP         IS NULL
                OR V_FROM_SITE_TEMP          IS NULL
                OR V_TO_SITE_TEMP            IS NULL
                OR V_NEW_INCOTERMS_TEMP      IS NULL
                OR V_NEW_TRANSPORT_MODE_TEMP IS NULL
                OR V_NEW_ROUTE_ID_TEMP       IS NULL
                OR V_NEW_D_CONTRY_TEMP       IS NULL
                OR V_NEW_D_PORT_CODE_TEMP    IS NULL
                OR V_NEW_A_COUNTRY_TEMP      IS NULL
                OR V_NEW_A_PORT_CODE_TEMP    IS NULL
                OR V_NEW_CUSTOMER_LT_TEMP    IS NULL
                OR V_NEW_TO_COUNTRY_TEMP     IS NULL
                OR V_NEW_TO_CITY_TEMP        IS NULL
               ) THEN

                /* 앞 행 저장분까지 되돌린 뒤 결과 반환 */
                ROLLBACK TO SP_SSP0015_SAVE_CONFIRM_40;

                V_LOG_TYPE    := 'FIND';
                V_LOG_MESSAGE := '########## END of procedure ##########';
                V_DESCRIPTION := '';
                D_EVENT_DATE  := SYSDATE;
                PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, 0, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                OPEN O_RC1 FOR SELECT 'X' AS RESULT_CODE, NULL AS "Request_no" FROM DUAL;
                OPEN O_RC2 FOR SELECT NULL AS ERR_CODE, NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

                RETURN;

            END IF;

            IF V_ACTIVE_FLAG <> 'I' THEN

                V_QTY        := 0;
                V_BEFORE_QTY := 0;

                BEGIN
                    SELECT TRUNC(QTY)                 /* AS-IS INT 변수 대입(소수 절삭) */
                         , TRUNC(BEFORE_QTY)
                      INTO V_QTY
                         , V_BEFORE_QTY
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                /* AS-IS CEILING('') = 0 */
                IF V_QTY <> NVL(CEIL(TO_NUMBER(V_SHIPMENT_QTY)), 0) THEN
                    V_BEFORE_QTY := V_QTY;
                END IF;

                IF V_SHIPMENT_QTY IS NULL THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL THEN
                    V_SHIPMENT_DATE := NULL;
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(SUBSTR(V_DIVISION_ID, 1, 30), V_NEW_BOD_ID_TEMP, SUBSTR(V_SHIPMENT_DATE, 1, 8));

                IF V_EDIT_MAIN = 'Y' THEN
                    V_CHECK_NEED_YN := 'Y';
                END IF;

                /* 2020.06.23 ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정 */
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET YYYYMMDD         = V_SHIPMENT_DATE
                     , QTY              = CEIL(TO_NUMBER(V_SHIPMENT_QTY))
                     , BEFORE_QTY       = V_BEFORE_QTY
                     , BOD_ID           = V_NEW_BOD_ID_TEMP
                     , ROUTE_ID         = V_NEW_ROUTE_ID_TEMP
                     , INCOTERMS        = V_NEW_INCOTERMS_TEMP
                     , D_COUNTRY        = V_NEW_D_CONTRY_TEMP
                     , D_PORT_CODE      = V_NEW_D_PORT_CODE_TEMP
                     , A_COUNTRY        = V_NEW_A_COUNTRY_TEMP
                     , A_PORT_CODE      = V_NEW_A_PORT_CODE_TEMP
                     , TO_COUNTRY       = V_NEW_TO_COUNTRY_TEMP
                     , TO_CITY          = V_NEW_TO_CITY_TEMP
                     , TRANSPORT_MODE   = V_NEW_TRANSPORT_MODE_TEMP
                     , ETD_DATE         = V_SHIPMENT_DATE          /* @v_new_etd_date */
                     , ETA_DATE         = V_NEW_ETA_DATE
                     , FCST_ETD_DATE    = V_SHIPMENT_DATE          /* @v_new_etd_date */
                     , FCST_ETA_DATE    = V_NEW_ETA_DATE
                     , CUSTOMER_LT      = V_NEW_CUSTOMER_LT_TEMP
                     , REMARKS          = V_REMARKS
                     , REMARKS2         = V_REMARKS2
                     , REMARKS3         = V_REMARKS3
                     , CHECK_NEED_YN    = V_CHECK_NEED_YN
                     , LAST_UPDATED_BY  = P_USER_ID
                     , LAST_UPDATE_DATE = V_CREATE_DATE
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

            END IF;

            /*2020-07-24 KIMYONGHO 신규생성 기능 추가*/
            IF V_ACTIVE_FLAG = 'I' THEN

                V_INFSEQNO := TO_CHAR(SYSDATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(SEQ1_XIF_ERP_IFSEQNO.NEXTVAL), -6);

                /* 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10) */
                V_LAST_CONFIRM_DATE := TO_CHAR(SYSDATE + 9, 'YYYYMMDD');

                V_DESCRIPTION := '';
                V_LOG_TYPE    := 'HIST';
                D_EVENT_DATE  := SYSDATE;
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                /* NEW CONFIRM 생성 CHECK 확인========================================================================================== */
                V_TMP_FN_TIME_ZONE := TO_CHAR(FN_MULTY_TIME(NULL), 'YYYYMMDD');
                V_NEW_CONFIRM_ID   := 'C' || V_TMP_FN_TIME_ZONE || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_CONFIRM_ID.NEXTVAL), -6);

                SELECT MAX(PLAN_START_YYYYMMDD)
                     , MAX(PLAN_SEQ)
                  INTO V_PLAN_START_YYYYMMDD
                     , V_SEQ
                  FROM SSP_PLAN_VERSION_V
                 WHERE PLAN_TYPE           = 'SP'
                   AND CONFIRM_FLAG        = 'Y'
                   AND DIVISION_ID         = V_DIVISION_ID
                   AND PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
                                                FROM SSP_PLAN_VERSION_V
                                               WHERE PLAN_TYPE    = 'SP'
                                                 AND CONFIRM_FLAG = 'Y'
                                                 AND DIVISION_ID  = V_DIVISION_ID);

                V_QTY        := 0;
                V_BEFORE_QTY := 0;

                BEGIN
                    SELECT TRUNC(QTY)                 /* AS-IS INT 변수 대입(소수 절삭) */
                         , TRUNC(BEFORE_QTY)
                      INTO V_QTY
                         , V_BEFORE_QTY
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                /* AS-IS 는 INT 와 문자열 비교로 수량을 정수로 바꾼다 — 정수가 아니면 AS-IS 처럼 오류 */
                IF V_SHIPMENT_QTY IS NOT NULL
                   AND NOT REGEXP_LIKE(V_SHIPMENT_QTY, '^[[:space:]]*[-+]?[0-9]+[[:space:]]*$') THEN
                    RAISE_APPLICATION_ERROR(-20245, 'Conversion failed when converting the nvarchar value ''' || V_SHIPMENT_QTY || ''' to data type int.');
                END IF;

                IF V_QTY <> NVL(TO_NUMBER(V_SHIPMENT_QTY), 0) THEN
                    V_BEFORE_QTY := V_QTY;
                END IF;

                IF V_SHIPMENT_QTY IS NULL THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL THEN
                    V_SHIPMENT_DATE := NULL;
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산*/
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(SUBSTR(V_DIVISION_ID, 1, 30), V_NEW_BOD_ID_TEMP, SUBSTR(V_SHIPMENT_DATE, 1, 8));

                IF V_EDIT_MAIN = 'Y' THEN
                    V_CHECK_NEED_YN := 'Y';
                END IF;

                /* -------------------------------------------------------------------------------------------------------------
                   1. SHIP_CONFIRM 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM
                   신규 건만 생성
                   ------------------------------------------------------------------------------------------------------------- */
                INSERT INTO SSP_ANL_SHIP_CONFIRM
                       (CONFIRM_ID
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
                      , ELECTRODE_YN
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                      , REQUESTOR
                      , BEFORE_QTY
                      , CHECK_NEED_YN
                      , PACKAGE_TYPE_CODE
                      , FACTORY_ID
                      , ELECTRODE_TYPE
                      , PACKAGE_QTY
                      , DOM_EXP
                      , REMARKS
                      , REMARKS2
                      , REMARKS3
                      , ATTRIBUTE10)
                SELECT V_NEW_CONFIRM_ID
                     , 'C'
                     , A.DIVISION_ID
                     , V_PLAN_START_YYYYMMDD
                     , 'SP'
                     , V_SEQ
                     , A.ITEM_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , V_SHIPMENT_DATE
                     , 0
                     , TO_NUMBER(V_SHIPMENT_QTY)
                     , V_NEW_BOD_ID_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , A.BIZ_TYPE
                     , A.PROJECT_CODE
                     , A.FCST_TYPE
                     , V_SHIPMENT_DATE
                     , V_NEW_ETA_DATE
                     , V_SHIPMENT_DATE
                     , V_NEW_ETA_DATE
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
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
                     , A.TO_SITE_SHIPTO_CODE
                     , A.TO_SITE_COMPANY_ID
                     , 'C'
                     , P_USER_ID
                     , V_CREATE_DATE
                     , P_USER_ID
                     , V_CREATE_DATE
                     , A.ELECTRODE_YN
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , P_USER_ID
                     , 0
                     , 'Y'
                     , A.PACKAGE_TYPE_CODE
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                     , CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                 WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                 WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                                 ELSE NULL
                            END) AS PACKAGE_QTY
                     , A.DOM_EXP
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , NULL
                  FROM SSP_ANL_SHIP_CONFIRM A
                     , SSP_MST_SITE_ITEM_EE_V B
                 WHERE CASE WHEN A.BIZ_TYPE = 'E' THEN B.DIVISION_ID(+) ELSE B.ASSY_DIVISION_ID(+) END = A.DIVISION_ID
                   AND CASE WHEN A.BIZ_TYPE = 'E' THEN B.SCM_SITE_ID(+) ELSE B.ASSY_SCM_SITE_ID(+) END = A.FROM_SITE
                   AND B.ITEM_ID(+) = A.ITEM_ID
                   AND A.CONFIRM_ID = V_CONFIRM_ID;

                /* -------------------------------------------------------------------------------------------------------------
                   2. SHIP_CONFIRM HISTORY 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM_H
                   신규 건만 생성
                   ------------------------------------------------------------------------------------------------------------- */
                INSERT INTO SSP_ANL_SHIP_CONFIRM_H
                       (HISTORY_SEQ
                      , CONFIRM_ID
                      , CHANGE_TYPE
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
                      , CHANGE_REQ_NO
                      , ERP_SO_NO
                      , ERP_SO_ITEM_NO
                      , ERP_DO_NO
                      , ERP_STATUS
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , HISTORY_CREATION_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                      , BEFORE_QTY
                      , REMARKS
                      , CHECK_NEED_YN)
                SELECT SEQ1_SSP_ANL_SHIP_CONFIRM_H.NEXTVAL   /* HISTORY_SEQ */
                     , CONFIRM_ID
                     , CHANGE_TYPE
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
                     , NULL              /* CHANGE_REQ_NO */
                     , NULL              /* ERP_SO_NO */
                     , NULL              /* ERP_SO_ITEM_NO */
                     , NULL              /* ERP_DO_NO */
                     , NULL              /* ERP_STATUS */
                     , P_USER_ID         /* CREATED_BY */
                     , V_CREATE_DATE     /* CREATION_DATE */
                     , P_USER_ID         /* LAST_UPDATED_BY */
                     , V_CREATE_DATE     /* LAST_UPDATE_DATE */
                     , V_CREATE_DATE     /* HISTORY_CREATION_DATE */
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , BEFORE_QTY
                     , REMARKS
                     , CHECK_NEED_YN
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE 1 = 1
                   AND CONFIRM_ID = V_NEW_CONFIRM_ID;

                INSERT INTO XIF_ERP_SHIP_PLAN_CONFIRM_S_SN
                       (IFSEQNO
                      , CONFIRM_ID
                      , SHIPMENT_STATUS
                      , LAST_CONFIRM_DATE
                      , VERSION_TYPE
                      , SALES_COMPANY_ID
                      , DIVISION_ID
                      , ITEM_ID
                      , FROM_SITE
                      , TO_SITE
                      , YYYYMMDD
                      , QTY
                      , BOD_ID
                      , ROUTE_ID
                      , OPERATION_GROUP
                      , BIZ_TYPE
                      , PROJECT_CODE
                      , FCST_TYPE
                      , FCST_ETD_DATE
                      , FCST_ETA_DATE
                      , ETD_DATE
                      , ETA_DATE
                      , INCOTERMS
                      , INCOTERMS2
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
                      , BUILDING
                      , REMARK
                      , CUSTOMER_REQ
                      , CHANGE_CODE
                      , CHANGE_CODE_NAME
                      , REQUESTOR
                      , TRANSFER_FLAG
                      , TRANSFER_DATE
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , ATTRIBUTE1
                      , ATTRIBUTE2
                      , ATTRIBUTE3
                      , ATTRIBUTE4
                      , ATTRIBUTE5
                      , ATTRIBUTE6
                      , ATTRIBUTE7
                      , ATTRIBUTE8
                      , ATTRIBUTE9
                      , ATTRIBUTE10
                      /*----------------------------------------------------------------------------------------
                          2020.06.30 : KBK
                          I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                      ------------------------------------------------------------------------------------------*/
                      , PACKAGE_TYPE
                      , FACTORY_ID
                      , PACKAGE_QTY
                      , DOM_EXP
                      , ERP_ATTR1
                      , ERP_ATTR2
                      , ERP_ATTR3
                      , ERP_ATTR4
                      , ERP_ATTR5)
                SELECT IA.IFSEQNO
                     , IA.CONFIRM_ID
                     , IA.SHIPMENT_STATUS
                     , IA.LAST_CONFIRM_DATE
                     , IA.VERSION_TYPE
                     , NVL(E.NEW_VALUE1, IA.SALES_COMPANY_ID)         AS SALES_COMPANY_ID
                     , IA.DIVISION_ID
                     , IA.ITEM_ID
                     , NVL(F.NEW_VALUE1, IA.FROM_SITE)                AS FROM_SITE
                     , NVL(G.NEW_VALUE1, IA.TO_SITE)                  AS TO_SITE
                     , IA.YYYYMMDD
                     , IA.QTY
                     , IA.BOD_ID
                     , IA.ROUTE_ID
                     , IA.OPERATION_GROUP
                     , IA.BIZ_TYPE
                     , IA.PROJECT_CODE
                     , IA.FCST_TYPE
                     , IA.FCST_ETD_DATE
                     , IA.FCST_ETA_DATE
                     , IA.ETD_DATE
                     , IA.ETA_DATE
                     , IA.INCOTERMS
                     , IA.INCOTERMS2
                     , IA.TRANSPORT_MODE
                     , IA.D_COUNTRY
                     , IA.D_PORT_CODE
                     , IA.A_COUNTRY
                     , IA.A_PORT_CODE
                     , IA.CUSTOMER_LT
                     , IA.TO_COUNTRY
                     , IA.TO_CITY
                     , IA.FROM_SITE_TYPE
                     , NVL(H.NEW_VALUE1, IA.FROM_SITE_PLANT_ID)       AS FROM_SITE_PLANT_ID
                     , NVL(I.NEW_VALUE1, IA.FROM_SITE_VENDOR_ID)      AS FROM_SITE_VENDOR_ID
                     , NVL(J.NEW_VALUE1, IA.FROM_SITE_SOLDTO_CODE)    AS FROM_SITE_SOLDTO_CODE
                     , NVL(K.NEW_VALUE1, IA.FROM_SITE_SHIPTO_CODE)    AS FROM_SITE_SHIPTO_CODE
                     , NVL(L.NEW_VALUE1, IA.FROM_SITE_COMPANY_ID)     AS FROM_SITE_COMPANY_ID
                     , IA.TO_SITE_TYPE
                     , NVL(M.NEW_VALUE1, IA.TO_SITE_PLANT_ID)         AS TO_SITE_PLANT_ID
                     , NVL(N.NEW_VALUE1, IA.TO_SITE_VENDOR_ID)        AS TO_SITE_VENDOR_ID
                     , NVL(O.NEW_VALUE1, IA.TO_SITE_SOLDTO_CODE)      AS TO_SITE_SOLDTO_CODE
                     , NVL(P.NEW_VALUE1, IA.TO_SITE_SHIPTO_CODE)      AS TO_SITE_SHIPTO_CODE
                     , NVL(Q.NEW_VALUE1, IA.TO_SITE_COMPANY_ID)       AS TO_SITE_COMPANY_ID
                     , IA.BUILDING
                     , IA.REMARK
                     , IA.CUSTOMER_REQ
                     , IA.CHANGE_CODE
                     , IA.CHANGE_CODE_NAME
                     , IA.REQUESTOR
                     , IA.TRANSFER_FLAG
                     , IA.TRANSFER_DATE
                     , IA.CREATED_BY
                     , IA.CREATION_DATE
                     , IA.LAST_UPDATED_BY
                     , IA.LAST_UPDATE_DATE
                     , IA.ATTRIBUTE1
                     , IA.ATTRIBUTE2
                     , IA.ATTRIBUTE3
                     , IA.ATTRIBUTE4
                     , IA.ATTRIBUTE5
                     , IA.ATTRIBUTE6
                     , IA.ATTRIBUTE7
                     , IA.ATTRIBUTE8
                     , IA.ATTRIBUTE9
                     , IA.ATTRIBUTE10
                     /*----------------------------------------------------------------------------------------
                         2020.06.30 : KBK
                         I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                     ------------------------------------------------------------------------------------------*/
                     , IA.PACKAGE_TYPE_CODE
                     , IA.FACTORY_ID
                     , IA.PACKAGE_QTY
                     , IA.DOM_EXP
                     , NULL                  AS ERP_ATTR1
                     , NULL                  AS ERP_ATTR2
                     , NULL                  AS ERP_ATTR3
                     , IA.TO_SITE_PLANT_ID   AS ERP_ATTR4   /* ERP_ATTR4-- NERP에서 원본 정보 참고용 (2025-04-23) */
                     , NULL                  AS ERP_ATTR5
                  FROM (SELECT IB.IFSEQNO
                             , IB.CONFIRM_ID
                             , IB.SHIPMENT_STATUS
                             , IB.LAST_CONFIRM_DATE
                             , IB.VERSION_TYPE
                             , IB.SALES_COMPANY_ID
                             , IB.DIVISION_ID
                             , IB.ITEM_ID
                             , IB.FROM_SITE
                             , IB.TO_SITE
                             , IB.YYYYMMDD
                             , IB.QTY
                             , IB.BOD_ID
                             , IB.ROUTE_ID
                             , IB.OPERATION_GROUP
                             , IB.BIZ_TYPE
                             , IB.PROJECT_CODE
                             , IB.FCST_TYPE
                             , IB.FCST_ETD_DATE
                             , IB.FCST_ETA_DATE
                             , IB.ETD_DATE
                             , IB.ETA_DATE
                             , IB.INCOTERMS
                             , IB.INCOTERMS2
                             , IB.TRANSPORT_MODE
                             , IB.D_COUNTRY
                             , IB.D_PORT_CODE
                             , IB.A_COUNTRY
                             , IB.A_PORT_CODE
                             , IB.CUSTOMER_LT
                             , IB.TO_COUNTRY
                             , IB.TO_CITY
                             , IB.FROM_SITE_TYPE
                             , IB.FROM_SITE_PLANT_ID
                             , IB.FROM_SITE_VENDOR_ID
                             , IB.FROM_SITE_SOLDTO_CODE
                             , IB.FROM_SITE_SHIPTO_CODE
                             , IB.FROM_SITE_COMPANY_ID
                             , IB.TO_SITE_TYPE
                             , IB.TO_SITE_PLANT_ID
                             , IB.TO_SITE_VENDOR_ID
                             , IB.TO_SITE_SOLDTO_CODE
                             , IB.TO_SITE_SHIPTO_CODE
                             , IB.TO_SITE_COMPANY_ID
                             , IB.BUILDING
                             , IB.REMARK
                             , IB.CUSTOMER_REQ
                             , IB.CHANGE_CODE
                             , IB.CHANGE_CODE_NAME
                             , IB.REQUESTOR
                             , IB.TRANSFER_FLAG
                             , IB.TRANSFER_DATE
                             , IB.CREATED_BY
                             , IB.CREATION_DATE
                             , IB.LAST_UPDATED_BY
                             , IB.LAST_UPDATE_DATE
                             , IB.ATTRIBUTE1
                             , IB.ATTRIBUTE2
                             , IB.ATTRIBUTE3
                             , IB.ATTRIBUTE4
                             , IB.ATTRIBUTE5
                             , IB.ATTRIBUTE6
                             , IB.ATTRIBUTE7
                             , IB.ATTRIBUTE8
                             , IB.ATTRIBUTE9
                             , IB.ATTRIBUTE10
                             /*----------------------------------------------------------------------------------------
                                 2020.06.30 : KBK
                                 I/F 추가요청으로 인하여 컬럼 추가 전극에서만 사용. DDL 표준을 맞추기 위하여 추가함
                             ------------------------------------------------------------------------------------------*/
                             , D.PACKAGE_TYPE_CODE
                             , D.FACTORY_ID
                             , CEIL(CASE WHEN D.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(IB.QTY * NVL(D.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(D.BOX_PER_CUT, 1)
                                         WHEN D.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(IB.QTY * NVL(D.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(D.STEELCRATE_PER_CUT, 1)
                                         WHEN D.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(IB.QTY * NVL(D.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(D.STEELRACK_PER_CUT, 1)
                                         ELSE NVL(IB.QTY, 0)
                                    END)                  AS PACKAGE_QTY
                             , D.DOM_EXP_TYPE             AS DOM_EXP
                          FROM (SELECT V_INFSEQNO                 AS IFSEQNO               /* IFSEQNO */
                                     , A.CONFIRM_ID
                                     , 'A'                        AS SHIPMENT_STATUS       /* I_PLGB  A: 확정 */
                                     , V_LAST_CONFIRM_DATE        AS LAST_CONFIRM_DATE     /* I_DATE  확정구간 마지막 일자 */
                                     , 'B'                        AS VERSION_TYPE          /* B:NEW/A:OLD */
                                     , NVL(C.ATTRIBUTE2, B.ATTRIBUTE2) AS SALES_COMPANY_ID
                                     , CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END AS DIVISION_ID
                                     , A.ITEM_ID
                                     , A.FROM_SITE
                                     , A.TO_SITE
                                     , A.YYYYMMDD
                                     , A.QTY
                                     , A.BOD_ID
                                     , A.ROUTE_ID
                                     , A.BIZ_TYPE                 AS OPERATION_GROUP
                                     , A.BIZ_TYPE
                                     , CASE WHEN TRIM(A.PROJECT_CODE) IS NULL OR A.PROJECT_CODE = '-' THEN 'TBD' ELSE A.PROJECT_CODE END AS PROJECT_CODE
                                     , A.FCST_TYPE
                                     , A.FCST_ETD_DATE
                                     , A.FCST_ETA_DATE
                                     , A.ETD_DATE
                                     , A.ETA_DATE
                                     , A.INCOTERMS
                                     , NULL                       AS INCOTERMS2
                                     , A.TRANSPORT_MODE
                                     , A.D_COUNTRY
                                     , A.D_PORT_CODE
                                     , A.A_COUNTRY
                                     , A.A_PORT_CODE
                                     , A.CUSTOMER_LT
                                     , A.TO_COUNTRY
                                     , A.TO_CITY
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
                                     , A.TO_SITE_SHIPTO_CODE
                                     , A.TO_SITE_COMPANY_ID
                                     , A.REMARKS2                 AS BUILDING
                                     , A.REMARKS                  AS REMARK
                                     , A.REMARKS3                 AS CUSTOMER_REQ
                                     , NULL                       AS CHANGE_CODE
                                     , NULL                       AS CHANGE_CODE_NAME
                                     , A.REQUESTOR
                                     , 'N'                        AS TRANSFER_FLAG
                                     , SYSDATE                    AS TRANSFER_DATE
                                     , A.LAST_UPDATED_BY          AS CREATED_BY
                                     , SYSDATE                    AS CREATION_DATE
                                     , A.LAST_UPDATED_BY
                                     , SYSDATE                    AS LAST_UPDATE_DATE
                                     , NULL                       AS ATTRIBUTE1
                                     , NULL                       AS ATTRIBUTE2
                                     , NULL                       AS ATTRIBUTE3
                                     , NULL                       AS ATTRIBUTE4
                                     , NULL                       AS ATTRIBUTE5
                                     , NULL                       AS ATTRIBUTE6
                                     , NULL                       AS ATTRIBUTE7
                                     , NULL                       AS ATTRIBUTE8
                                     , NULL                       AS ATTRIBUTE9
                                     , A.ELECTRODE_YN             AS ATTRIBUTE10
                                  FROM SSP_ANL_SHIP_CONFIRM A
                                     , SCM_ADM_LOOKUP_MASTER_DETAIL B
                                     , SCM_ADM_LOOKUP_MASTER_DETAIL C
                                 WHERE B.SEGMENT1(+)    = A.FROM_SITE_COMPANY_ID
                                   AND B.SEGMENT3(+)    = A.FROM_SITE
                                   AND B.SEGMENT4(+)    = A.TO_SITE_COMPANY_ID
                                   AND B.SEGMENT5(+)    = A.TO_SITE
                                   AND C.SEGMENT1(+)    = A.FROM_SITE_COMPANY_ID
                                   AND C.SEGMENT3(+)    = A.FROM_SITE
                                   AND C.SEGMENT4(+)    = A.TO_SITE_COMPANY_ID
                                   AND C.ATTRIBUTE1(+)  = A.TO_SITE
                                   AND B.LOOKUP_TYPE(+) = 'CELL_SHIP_FROM_TO'
                                   AND B.VALID_YN(+)    = 'Y'
                                   AND C.LOOKUP_TYPE(+) = 'ELECTRODE_SHIP_FROM_TO'
                                   AND C.VALID_YN(+)    = 'Y'
                                   AND NVL(A.QTY, 0)   <> 0                  /* 0은IF 제외 */
                                   AND A.CONFIRM_ID     = V_NEW_CONFIRM_ID) IB
                             , SSP_MST_SITE_ITEM_EE_V D
                         WHERE CASE WHEN IB.BIZ_TYPE = 'E' THEN D.DIVISION_ID(+) ELSE D.ASSY_DIVISION_ID(+) END = IB.DIVISION_ID
                           AND CASE WHEN IB.BIZ_TYPE = 'E' THEN D.SCM_SITE_ID(+) ELSE D.ASSY_SCM_SITE_ID(+) END = IB.FROM_SITE
                           AND D.ITEM_ID(+) = IB.ITEM_ID) IA
                     , NERP_CONV_MASTER E
                     , NERP_CONV_MASTER F
                     , NERP_CONV_MASTER G
                     , NERP_CONV_MASTER H
                     , NERP_CONV_MASTER I
                     , NERP_CONV_MASTER J
                     , NERP_CONV_MASTER K
                     , NERP_CONV_MASTER L
                     , NERP_CONV_MASTER M
                     , NERP_CONV_MASTER N
                     , NERP_CONV_MASTER O
                     , NERP_CONV_MASTER P
                     , NERP_CONV_MASTER Q
                 WHERE E.OLD_VALUE1(+) = IA.SALES_COMPANY_ID
                   AND F.OLD_VALUE1(+) = IA.FROM_SITE
                   AND G.OLD_VALUE1(+) = IA.TO_SITE
                   AND H.OLD_VALUE1(+) = IA.FROM_SITE_PLANT_ID
                   AND I.OLD_VALUE1(+) = IA.FROM_SITE_VENDOR_ID
                   AND J.OLD_VALUE1(+) = IA.FROM_SITE_SOLDTO_CODE
                   AND K.OLD_VALUE1(+) = IA.FROM_SITE_SHIPTO_CODE
                   AND L.OLD_VALUE1(+) = IA.FROM_SITE_COMPANY_ID
                   AND M.OLD_VALUE1(+) = IA.TO_SITE_PLANT_ID
                   AND N.OLD_VALUE1(+) = IA.TO_SITE_VENDOR_ID
                   AND O.OLD_VALUE1(+) = IA.TO_SITE_SOLDTO_CODE
                   AND P.OLD_VALUE1(+) = IA.TO_SITE_SHIPTO_CODE
                   AND Q.OLD_VALUE1(+) = IA.TO_SITE_COMPANY_ID
                   AND E.CODETYPE(+)   = 'COMPANY_ID'
                   AND F.CODETYPE(+)   = 'SCP_SITE_ID'
                   AND G.CODETYPE(+)   = 'SCP_SITE_ID'
                   AND H.CODETYPE(+)   = 'PLANT_ID'
                   AND I.CODETYPE(+)   = 'VENDOR_ID'
                   AND J.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND K.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND L.CODETYPE(+)   = 'COMPANY_ID'
                   AND M.CODETYPE(+)   = 'PLANT_ID'
                   AND N.CODETYPE(+)   = 'VENDOR_ID'
                   AND O.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND P.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND Q.CODETYPE(+)   = 'COMPANY_ID';

                /* MKT FCST - SSP Sync 신규 생성 건 대상
                   ※ PR_DM_SSP_CONFIRM_SYNC 는 Oracle 미이관(2026.09.17) — 이관 후 아래 호출 연결
                   PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, V_NEW_CONFIRM_ID); */

                V_CONFIRM_ID := V_NEW_CONFIRM_ID;

                /* 240610 jilee 신규 건 Change Req 정보 입력 */
                IF V_CHK_REQ = 0 THEN

                    V_MAX_REQ_NO := 'R' || TO_CHAR(V_CREATE_DATE, 'YYYYMMDD') || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL), -6);

                    /* 사용자 행이 없으면 앞 값 유지 · 여러 행이면 AS-IS 처럼 한 값 */
                    BEGIN
                        SELECT DEPT_ID
                          INTO V_USER_DEPT_ID
                          /* 2026.09.30 AJS 수정 (START) */
--                          FROM TB_FX_USER
--                         WHERE UPPER(USERID) = UPPER(P_USER_ID)
                          FROM SCM_ADM_USER_M
                         WHERE UPPER(USER_ID) = UPPER(P_USER_ID)
                          /* 2026.09.30 AJS 수정 (END) */
                           AND ROWNUM        = 1;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    BEGIN
                        SELECT ELECTRODE_YN
                             , ELECTRODE_TYPE
                             , ORIGIN_FROM_DIVISION_ID
                             , ORIGIN_TO_DIVISION_ID
                          INTO V_ELECTRODE_YN
                             , V_ELECTRODE_TYPE
                             , V_ORIGIN_FROM_DIVISION_ID
                             , V_ORIGION_TO_DIVISION_ID
                          FROM SSP_ANL_SHIP_CONFIRM
                         WHERE CONFIRM_ID = V_CONFIRM_ID;
                    EXCEPTION
                        WHEN NO_DATA_FOUND THEN
                            NULL;
                    END;

                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                           (CHANGE_REQ_NO
                          , CHANGE_TYPE
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
                          , CREATED_BY
                          , CREATION_DATE
                          , LAST_UPDATED_BY
                          , LAST_UPDATE_DATE
                          , ELECTRODE_YN
                          , ELECTRODE_TYPE
                          , ORIGIN_FROM_DIVISION_ID
                          , ORIGIN_TO_DIVISION_ID)
                    VALUES (V_MAX_REQ_NO
                          , 'A'
                          , 'A'
                          , V_DIVISION_ID
                          , V_FROM_SITE_TEMP
                          , 'New Adjustment'
                          , P_USER_ID
                          , V_USER_DEPT_ID
                          , V_CREATE_DATE
                          , P_USER_ID
                          , V_USER_DEPT_ID
                          , V_CREATE_DATE
                          , 'T07'
                          , 'T07'
                          , NULL
                          , 'Y'
                          , P_USER_ID
                          , V_CREATE_DATE
                          , P_USER_ID
                          , V_CREATE_DATE
                          , V_ELECTRODE_YN
                          , V_ELECTRODE_TYPE
                          , V_ORIGIN_FROM_DIVISION_ID
                          , V_ORIGION_TO_DIVISION_ID);

                    /* Request_No값 각기(단일) 생성 */
                    V_CHK_REQ := 1;

                END IF;

                IF V_SHIPMENT_QTY IS NULL THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL THEN
                    V_SHIPMENT_DATE := NULL;
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅*/
                IF     RTRIM(V_SHIPMENT_DATE) IS NOT NULL
                   AND LENGTH(RTRIM(V_SHIPMENT_DATE)) = 8
                   AND RTRIM(V_NEW_CUSTOMER_LT) IS NOT NULL
                   AND LENGTH(RTRIM(V_NEW_CUSTOMER_LT)) > 0 THEN
                    V_NEW_ETD_DATE := V_SHIPMENT_DATE;
                END IF;

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산
                   ※ AS-IS 는 여기서만 전체 인자 @p_division_id 를 넘긴다(함수 인자 NVARCHAR(30) 로 잘림) */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(SUBSTR(P_DIVISION_ID, 1, 30), V_NEW_BOD_ID_TEMP, SUBSTR(V_SHIPMENT_DATE, 1, 8));

                INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                       (CHANGE_REQ_NO
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
                      , ATTRIBUTE2)
                SELECT V_MAX_REQ_NO                   AS CHANGE_REQ_NO
                     , CONFIRM_ID
                     , 'Y'                            AS NEW_YN
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
                     , V_SHIPMENT_DATE                AS NEW_YYYYMMDD
                     , TO_NUMBER(V_SHIPMENT_QTY)      AS NEW_QTY
                     , V_NEW_BOD_ID_TEMP              AS NEW_BOD_ID
                     , V_NEW_ROUTE_ID_TEMP            AS NEW_ROUTE_ID
                     , V_NEW_ETD_DATE                 AS NEW_ETD_DATE
                     , V_NEW_ETA_DATE                 AS NEW_ETA_DATE
                     , V_NEW_INCOTERMS                AS NEW_INCOTERMS
                     , V_NEW_TRANSPORT_MODE           AS NEW_TRANSPORT_MODE
                     , V_NEW_D_CONTRY                 AS NEW_D_COUNTRY
                     , V_NEW_D_PORT_CODE_TEMP         AS NEW_D_PORT_CODE
                     , V_NEW_A_COUNTRY_TEMP           AS NEW_A_COUNTRY
                     , V_NEW_A_PORT_CODE_TEMP         AS NEW_A_PORT_CODE
                     , V_NEW_CUSTOMER_LT_TEMP         AS NEW_CUSTOMER_LT
                     , V_NEW_TO_COUNTRY_TEMP          AS NEW_TO_COUNTRY
                     , V_NEW_TO_CITY_TEMP             AS NEW_TO_CITY
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
                     , 'Y'
                     , 'N'
                     , P_USER_ID                      AS CREATED_BY
                     , V_CREATE_DATE
                     , P_USER_ID                      AS LAST_UPDATED_BY
                     , V_CREATE_DATE
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , REQUESTOR
                     , 'A'
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

            END IF; /* @v_active_flag = 'I' END */

            IF V_EDIT_MAIN = 'Y' THEN

                BEGIN
                    SELECT DIVISION_ID
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE
                         , YYYYMMDD
                         , BOD_ID
                         , PROJECT_CODE
                         , FCST_TYPE
                         , INCOTERMS
                         , TRANSPORT_MODE
                         , CONFIRM_ID
                      INTO N_DIVISION_ID
                         , N_ITEM_ID
                         , N_FROM_SITE
                         , N_TO_SITE
                         , N_YYYYMMDD
                         , N_BOD_ID
                         , N_PROJECT_CODE
                         , N_FCST_TYPE
                         , N_INCOTERMS
                         , N_TRANSPORT_MODE
                         , N_CONFIRM_ID
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                /* SSP_ANL_SHIP_PLAN_40 의 데이터 생성 시점이 달라 최신 생성 날짜를 조회한다. */
                SELECT MAX(PLAN_START_YYYYMMDD)
                  INTO V_PLAN_START_YYYYMMDD
                  FROM GT_SSP0015_40_STD
                 WHERE 1 = 1
                   AND DIVISION_ID = N_DIVISION_ID
                   AND FROM_SITE   = N_FROM_SITE;

                V_SEQ := 1;

                /* 220905 jilee FromSite 제외하고 다시 조회 */
                IF V_PLAN_START_YYYYMMDD IS NULL THEN

                    SELECT MAX(PLAN_START_YYYYMMDD)
                      INTO V_PLAN_START_YYYYMMDD
                      FROM GT_SSP0015_40_STD
                     WHERE COMPANY_ID IN (SELECT COMPANY_ID
                                            FROM SCM_MST_SITE
                                           WHERE 1 = 1
                                             AND DIVISION_ID = N_DIVISION_ID
                                             AND SCM_SITE_ID = N_FROM_SITE)
                       AND DIVISION_ID = N_DIVISION_ID;

                    V_SEQ := 1;

                END IF;

                /* SSP_ANL_SHIP_PLAN_40 MEASURE SHIP_CONFIRM 이 있을 경우 Delete, Insert
                   ※ AS-IS 는 건수(COUNT) 확인 후 삭제 — 삭제 대상이 없으면 0건 삭제와 같으므로 바로 삭제한다. */
                DELETE FROM SSP_ANL_SHIP_PLAN_40
                 WHERE PLAN_TYPE           = 'SP'
                   AND MEASURE             = 'SHIP_CONFIRM'
                   AND CONFIRM_FLAG        = 'Y'
                   AND DIVISION_ID         = N_DIVISION_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND SEQ                 = V_SEQ
                   AND ITEM_ID             = N_ITEM_ID
                   AND FROM_SITE           = N_FROM_SITE
                   AND TO_SITE             = N_TO_SITE
                   AND YYYYMMDD            = N_YYYYMMDD;

                /* 변경요청 상세가 없으면 앞 값 유지(AS-IS 변수 대입 SELECT TOP 1 동일)
                   ※ 수정일시 동률(Oracle DATE 는 밀리초 절삭)은 요청번호 역순으로 고정 */
                BEGIN
                    SELECT XA.DIVISION_ID
                         , XA.ITEM_ID
                         , XA.FROM_SITE
                         , XA.TO_SITE
                         , XA.YYYYMMDD
                         , XA.BOD_ID
                         , XA.PROJECT_CODE
                         , XA.FCST_TYPE
                         , XA.INCOTERMS
                         , XA.TRANSPORT_MODE
                         , XA.CONFIRM_ID
                         , XA.CHANGE_REQ_NO
                      INTO N_ORI_DIVISION_ID
                         , N_ORI_ITEM_ID
                         , N_ORI_FROM_SITE
                         , N_ORI_TO_SITE
                         , N_ORI_YYYYMMDD
                         , N_ORI_BOD_ID
                         , N_ORI_PROJECT_CODE
                         , N_ORI_FCST_TYPE
                         , N_ORI_INCOTERMS
                         , N_ORI_TRANSPORT_MODE
                         , N_ORI_CONFIRM_ID
                         , V_CHANGE_REQ_NO
                      FROM (SELECT DIVISION_ID
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , BOD_ID
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , CONFIRM_ID
                                 , CHANGE_REQ_NO
                              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                             WHERE VALID_YN   = 'Y'
                               AND CONFIRM_ID = V_CONFIRM_ID
                             ORDER BY LAST_UPDATE_DATE DESC
                                    , CHANGE_REQ_NO DESC) XA
                     WHERE ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                V_CHK := 0;

                SELECT COUNT(*)
                  INTO V_CHK
                  FROM SSP_ANL_SHIP_PLAN_40
                 WHERE PLAN_TYPE           = 'SP'
                   AND MEASURE             = 'SHIP_CONFIRM'
                   AND CONFIRM_FLAG        = 'Y'       /* Confrim ID가 없는건 삭제하지 않음 */
                   AND DIVISION_ID         = N_ORI_DIVISION_ID
                   AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                   AND SEQ                 = V_SEQ
                   AND ITEM_ID             = N_ORI_ITEM_ID
                   AND FROM_SITE           = N_ORI_FROM_SITE
                   AND TO_SITE             = N_ORI_TO_SITE
                   AND YYYYMMDD            = N_ORI_YYYYMMDD
                   AND ROWNUM              = 1;

                IF V_CHK > 0 AND N_YYYYMMDD <> N_ORI_YYYYMMDD THEN

                    DELETE FROM SSP_ANL_SHIP_PLAN_40
                     WHERE PLAN_TYPE           = 'SP'
                       AND MEASURE             = 'SHIP_CONFIRM'
                       AND CONFIRM_FLAG        = 'Y'   /* Confrim ID가 없는건 삭제하지 않음 */
                       AND DIVISION_ID         = N_ORI_DIVISION_ID
                       AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND SEQ                 = V_SEQ
                       AND ITEM_ID             = N_ORI_ITEM_ID
                       AND FROM_SITE           = N_ORI_FROM_SITE
                       AND TO_SITE             = N_ORI_TO_SITE
                       AND YYYYMMDD            = N_ORI_YYYYMMDD;

                    /* AS-IS 의 CONFIRM_ID IN (같은 테이블 같은 조건) 은 같은 조건의 직접 조회와 같다 */
                    INSERT INTO SSP_ANL_SHIP_PLAN_40
                           (DIVISION_ID
                          , PLAN_START_YYYYMMDD
                          , PLAN_TYPE
                          , SEQ
                          , ITEM_ID
                          , FROM_SITE
                          , TO_SITE
                          , MEASURE
                          , YYYYMMDD
                          , BOD_ID
                          , QTY
                          , ROUTE_ID
                          , INCOTERMS
                          , TRANSPORT_MODE
                          , BIZ_TYPE
                          , PROJECT_CODE
                          , FCST_TYPE
                          , FCST_ETD_DATE
                          , FCST_ETA_DATE
                          , ETD_DATE
                          , ETA_DATE
                          , CONFIRM_FLAG
                          , CONFIRM_ID
                          , CREATED_BY
                          , CREATION_DATE
                          , LAST_UPDATED_BY
                          , LAST_UPDATE_DATE
                          , ELECTRODE_YN
                          , ELECTRODE_TYPE
                          , ORIGIN_FROM_DIVISION_ID
                          , ORIGIN_TO_DIVISION_ID)
                    SELECT DIVISION_ID
                         , V_PLAN_START_YYYYMMDD      AS PLAN_START_YYYYMMDD
                         , PLAN_TYPE
                         , V_SEQ                      AS SEQ
                         , ITEM_ID
                         , FROM_SITE
                         , TO_SITE
                         , 'SHIP_CONFIRM'             AS MEASURE
                         , YYYYMMDD
                         , BOD_ID
                         , QTY
                         , ROUTE_ID
                         , INCOTERMS
                         , TRANSPORT_MODE
                         , BIZ_TYPE
                         , PROJECT_CODE
                         , FCST_TYPE
                         , FCST_ETD_DATE
                         , FCST_ETA_DATE
                         , ETD_DATE
                         , ETA_DATE
                         , 'Y'                        AS CONFIRM_FLAG
                         , CONFIRM_ID
                         , P_USER_ID                  AS CREATED_BY
                         , V_CREATE_DATE              AS CREATION_DATE
                         , P_USER_ID                  AS LAST_UPDATED_BY
                         , V_CREATE_DATE              AS LAST_UPDATE_DATE
                         , ELECTRODE_YN
                         , ELECTRODE_TYPE
                         , ORIGIN_FROM_DIVISION_ID
                         , ORIGIN_TO_DIVISION_ID
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CHANGE_TYPE = 'C'
                       AND DIVISION_ID = N_ORI_DIVISION_ID
                       AND ITEM_ID     = N_ORI_ITEM_ID
                       AND FROM_SITE   = N_ORI_FROM_SITE
                       AND TO_SITE     = N_ORI_TO_SITE
                       AND YYYYMMDD    = N_ORI_YYYYMMDD;

                END IF;

                /* MEASURE SHIP_CONFIRM INSERT */
                INSERT INTO SSP_ANL_SHIP_PLAN_40
                       (DIVISION_ID
                      , PLAN_START_YYYYMMDD
                      , PLAN_TYPE
                      , SEQ
                      , ITEM_ID
                      , FROM_SITE
                      , TO_SITE
                      , MEASURE
                      , YYYYMMDD
                      , BOD_ID
                      , QTY
                      , ROUTE_ID
                      , INCOTERMS
                      , TRANSPORT_MODE
                      , BIZ_TYPE
                      , PROJECT_CODE
                      , FCST_TYPE
                      , FCST_ETD_DATE
                      , FCST_ETA_DATE
                      , ETD_DATE
                      , ETA_DATE
                      , CONFIRM_FLAG
                      , CONFIRM_ID
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID)
                SELECT DIVISION_ID
                     , V_PLAN_START_YYYYMMDD          AS PLAN_START_YYYYMMDD
                     , PLAN_TYPE
                     , V_SEQ                          AS SEQ
                     , ITEM_ID
                     , FROM_SITE
                     , TO_SITE
                     , 'SHIP_CONFIRM'                 AS MEASURE
                     , YYYYMMDD
                     , BOD_ID
                     , QTY
                     , ROUTE_ID
                     , INCOTERMS
                     , TRANSPORT_MODE
                     , BIZ_TYPE
                     , PROJECT_CODE
                     , FCST_TYPE
                     , FCST_ETD_DATE
                     , FCST_ETA_DATE
                     , ETD_DATE
                     , ETA_DATE
                     , 'Y'                            AS CONFIRM_FLAG
                     , CONFIRM_ID
                     , P_USER_ID                      AS CREATED_BY
                     , V_CREATE_DATE                  AS CREATION_DATE
                     , P_USER_ID                      AS LAST_UPDATED_BY
                     , V_CREATE_DATE                  AS LAST_UPDATE_DATE
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CHANGE_TYPE = 'C'
                   AND DIVISION_ID = N_DIVISION_ID
                   AND ITEM_ID     = N_ITEM_ID
                   AND FROM_SITE   = N_FROM_SITE
                   AND TO_SITE     = N_TO_SITE
                   AND YYYYMMDD    = V_SHIPMENT_DATE;

                /* EXEC PR_SSP_ANL_SHIP_UPDATE_BOH_VAL_40 - AS-IS 주석 처리 상태 유지 */

            END IF;

            IF LENGTH(RTRIM(V_CHANGE_REQ_NO)) > 0 THEN

                /* 이력저장
                   ※ PR_SSP_ANL_SHIP_CONFIRM_HIST 는 Oracle 미이관(2026.09.17) — 이관 후 아래 호출 연결
                   PR_SSP_ANL_SHIP_CONFIRM_HIST(V_CHANGE_REQ_NO, P_USER_ID, ''); */

                SELECT COUNT(*)
                  INTO V_MAIL_CHK
                  FROM SSP_MST_SEND_MAIL_REQ
                 WHERE CHANGE_REQ_NO = V_CHANGE_REQ_NO;

                IF V_MAIL_CHK = 0 THEN

                    /* 메일전송 */
                    INSERT INTO SSP_MST_SEND_MAIL_REQ
                           (CHANGE_REQ_NO
                          , TRANSFER_FLAG
                          , GRP_CHANGE_REQ)
                    VALUES (V_CHANGE_REQ_NO
                          , 'N'
                          , V_GRP_CHANGE_REQ);

                    V_MAIL_FLAG := 1;

                END IF;

            END IF;

        END LOOP; /* end of while loop */

        IF V_MAIL_FLAG = 1 THEN
            /* ※ PR_SSP_MAIL_SEND_ADJUST_MST 는 Oracle 미이관(2026.09.17) — 이관 후 아래 호출 연결
               PR_SSP_MAIL_SEND_ADJUST_MST(V_GRP_CHANGE_REQ); */
            NULL;
        END IF;

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        /* [C20201223-000448] MKT FCST - SSP Sync
           ※ PR_DM_SSP_CONFIRM_SYNC 는 Oracle 미이관(2026.09.17) — 이관 후 아래 호출 연결
           PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, P_CONFIRM_ID); */

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S' AS RESULT_CODE, V_MAX_LOOP_CNT AS RESULT_CNT, V_CHANGE_REQ_NO AS CHANGE_REQ_NO FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_CODE, NULL AS ERR_MESSAGE FROM DUAL WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_CONFIRM_40;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME
                  , LOG_TYPE
                  , LOG_COUNT
                  , LOG_MESSAGE
                  , DESCRIPTION
                  , EVENT_DATE
                  , CREATION_DATE
                  , CREATED_BY
                  , LAST_UPDATE_DATE
                  , LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME
                  , 'END'
                  , NULL
                  , V_ERR_MESSAGE
                  , NULL
                  , SYSDATE
                  , SYSDATE
                  , V_PROGRAM_NAME
                  , SYSDATE
                  , V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE, '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;
            OPEN O_RC2 FOR SELECT V_ERR_CODE AS ERR_CODE, V_ERR_MESSAGE AS ERR_MESSAGE FROM DUAL;

    END P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_40;

    /* ============================================================
       P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
       AS-IS SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
       ※ '^' 로 이어 붙인 여러 행을 SCM_ARR_SPL_VAL 로 잘라 한 행씩 처리한다(AS-IS 동일).
       ※ 행 구분(ACTIVE_FLAG) : 'I' = 신규 출하확정 생성, 'I' 가 아닌 값 = 기존 출하확정 수정(AS-IS 동일).
       ※ Packer 는 BOD ITEM 을 사이트 접미사(PACKER_ITEM_ID_SUFFIX)로 12번째 자리를 바꿔 맞춘다(AS-IS 동일).
          품목 길이가 12 미만이면 원래 품목을 쓴다(AS-IS STUFF 가 NULL 을 돌려주는 자리).
       ※ 저장 시작에 SAVEPOINT 를 두어 BOD 없음('X')·오류('F') 시 앞 행 저장분까지 되돌린다.
          (AS-IS 는 트랜잭션이 없어 앞 행 저장분이 남고, 오류 시 CATCH 에서 COMMIT 한다)
       ※ AS-IS 가 부르는 이력 프로시저는 Oracle 에 없다(2026.09.22 기준) — 호출 자리를 주석으로 남긴다.
          PR_SSP_ANL_SHIP_CONFIRM_HIST
       ※ AS-IS 에서 이미 주석 처리된 호출(PR_DM_SSP_CONFIRM_SYNC · PR_SSP_MAIL_SEND_ADJUST_MST)은 주석 그대로 둔다.
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
    (
        P_ACTIVE_FLAG           IN  VARCHAR2,
        P_DIVISION_ID           IN  VARCHAR2,
        P_CONFIRM_ID            IN  VARCHAR2,
        P_SHIPMENT_QTY          IN  VARCHAR2,
        P_SHIPMENT_DATE         IN  VARCHAR2,
        P_NEW_BOD_ID            IN  VARCHAR2,
        P_NEW_ROUTE_ID          IN  VARCHAR2,
        P_NEW_ETD_DATE          IN  VARCHAR2,
        P_NEW_ETA_DATE          IN  VARCHAR2,
        P_NEW_INCOTERMS         IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE    IN  VARCHAR2,
        P_NEW_D_CONTRY          IN  VARCHAR2,
        P_NEW_D_PORT_CODE       IN  VARCHAR2,
        P_NEW_A_COUNTRY         IN  VARCHAR2,
        P_NEW_A_PORT_CODE       IN  VARCHAR2,
        P_NEW_CUSTOMER_LT       IN  VARCHAR2,
        P_NEW_TO_COUNTRY        IN  VARCHAR2,
        P_NEW_TO_CITY           IN  VARCHAR2,
        P_REMARKS               IN  VARCHAR2,
        P_REMARKS2              IN  VARCHAR2,
        P_REMARKS3              IN  VARCHAR2,
        P_USER_ID               IN  VARCHAR2,
        P_CHECK_NEED_YN         IN  VARCHAR2,
        P_EDIT_MAIN             IN  VARCHAR2,
        P_SHIPTO_CODE           IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR,
        O_RC2                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER
         * Description  : Shipment Request Confirm 저장
         * Program History
         *===================================================================================================
         *   Date       In Charge		Description
         *===================================================================================================
         * 2021/09/22   KIMYONGHO		최초작성
         * 2022/01/04   KIMYONGHO	    ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
         * 2024/10/01   KHJ             NERP_SSP
         * 2026.09.22                   MSSQL -> Oracle 변환
         */
        V_RECV_ACTIVE_FLAG          VARCHAR2(4000 CHAR);
        V_ACTIVE_FLAG               VARCHAR2(4000 CHAR);
        V_DIVISION_ID               VARCHAR2(4000 CHAR);
        V_CONFIRM_ID                VARCHAR2(4000 CHAR);
        V_SHIPMENT_QTY              VARCHAR2(4000 CHAR);
        V_SHIPMENT_DATE             VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID                VARCHAR2(4000 CHAR);
        V_NEW_ETD_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ETA_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS             VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE        VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY              VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY             VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT           VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY            VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY               VARCHAR2(4000 CHAR);
        V_CREATE_DATE               DATE;
        V_BEFORE_QTY                NUMBER;
        V_QTY                       NUMBER;
        V_REMARKS                   VARCHAR2(4000 CHAR);
        V_REMARKS2                  VARCHAR2(4000 CHAR);
        V_REMARKS3                  VARCHAR2(4000 CHAR);
        V_CHECK_NEED_YN             VARCHAR2(4000 CHAR);

        V_PLAN_START_YYYYMMDD       VARCHAR2(4000 CHAR);
        V_SEQ                       VARCHAR2(4000 CHAR);
        V_EDIT_MAIN                 VARCHAR2(4000 CHAR);
        V_SHIPTO_CODE               VARCHAR2(4000 CHAR);

        N_ORI_DIVISION_ID           VARCHAR2(4000 CHAR);
        N_ORI_ITEM_ID               VARCHAR2(4000 CHAR);
        N_ORI_FROM_SITE             VARCHAR2(4000 CHAR);
        N_ORI_TO_SITE               VARCHAR2(4000 CHAR);
        N_ORI_YYYYMMDD              VARCHAR2(4000 CHAR);
        N_ORI_BOD_ID                VARCHAR2(4000 CHAR);
        N_ORI_PROJECT_CODE          VARCHAR2(4000 CHAR);
        N_ORI_FCST_TYPE             VARCHAR2(4000 CHAR);
        N_ORI_INCOTERMS             VARCHAR2(4000 CHAR);
        N_ORI_TRANSPORT_MODE        VARCHAR2(4000 CHAR);
        N_ORI_CONFIRM_ID            VARCHAR2(4000 CHAR);
        V_CHANGE_REQ_NO             VARCHAR2(4000 CHAR);

        V_DIVISION_ID_TEMP          VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000 CHAR);
        V_FROM_SITE_TEMP            VARCHAR2(4000 CHAR);
        V_TO_SITE_TEMP              VARCHAR2(4000 CHAR);
        V_ITEM_ID_TEMP              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000 CHAR);

        V_IF_GROUP_NO               VARCHAR2(50 CHAR) := TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISS');

        V_NEW_CONFIRM_ID            VARCHAR2(4000 CHAR);
        V_INFSEQNO                  VARCHAR2(20 CHAR);
        V_LAST_CONFIRM_DATE         VARCHAR2(8 CHAR);

        /* //메일관련 변수//////////////////////////////// */
        V_GRP_CHANGE_REQ            VARCHAR2(20 CHAR);
        V_MAIL_FLAG                 NUMBER := 0;
        V_MAIL_CHK                  NUMBER := 0;

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER';
        V_LOG_TYPE                  VARCHAR2(30 CHAR);
        N_LOG_COUNT                 NUMBER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
        V_DESCRIPTION               VARCHAR2(500 CHAR);
        D_EVENT_DATE                DATE;

        V_DELIMITER                 VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT              NUMBER := 0;
        V_MST_LOOP_CNT              NUMBER := 0;

        V_BOD_NOT_FOUND             VARCHAR2(1 CHAR) := 'N';
        V_ERR_CODE                  NUMBER;
        V_ERR_MESSAGE               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_CONF_PK;

        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
        V_CREATE_DATE      := SYSDATE;
        V_GRP_CHANGE_REQ   := 'G' || TO_CHAR(SYSTIMESTAMP, 'YYYYMMDDHH24MISSFF2');

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER));

        WHILE LENGTH(RTRIM(V_RECV_ACTIVE_FLAG)) > 0
          AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            /* V_MST_LOOP_CNT 1증가 */
            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG        := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,        V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID        := SCM_ARR_SPL_VAL(P_DIVISION_ID,        V_DELIMITER, V_MST_LOOP_CNT);
            V_CONFIRM_ID         := SCM_ARR_SPL_VAL(P_CONFIRM_ID,         V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_QTY       := SCM_ARR_SPL_VAL(P_SHIPMENT_QTY,       V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_DATE      := SCM_ARR_SPL_VAL(P_SHIPMENT_DATE,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_BOD_ID         := SCM_ARR_SPL_VAL(P_NEW_BOD_ID,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETD_DATE       := SCM_ARR_SPL_VAL(P_NEW_ETD_DATE,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETA_DATE       := SCM_ARR_SPL_VAL(P_NEW_ETA_DATE,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ROUTE_ID       := SCM_ARR_SPL_VAL(P_NEW_ROUTE_ID,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_INCOTERMS      := SCM_ARR_SPL_VAL(P_NEW_INCOTERMS,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TRANSPORT_MODE := SCM_ARR_SPL_VAL(P_NEW_TRANSPORT_MODE, V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_CONTRY       := SCM_ARR_SPL_VAL(P_NEW_D_CONTRY,       V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_PORT_CODE    := SCM_ARR_SPL_VAL(P_NEW_D_PORT_CODE,    V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_COUNTRY      := SCM_ARR_SPL_VAL(P_NEW_A_COUNTRY,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_PORT_CODE    := SCM_ARR_SPL_VAL(P_NEW_A_PORT_CODE,    V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_CUSTOMER_LT    := SCM_ARR_SPL_VAL(P_NEW_CUSTOMER_LT,    V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_COUNTRY     := SCM_ARR_SPL_VAL(P_NEW_TO_COUNTRY,     V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_CITY        := SCM_ARR_SPL_VAL(P_NEW_TO_CITY,        V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS            := SCM_ARR_SPL_VAL(P_REMARKS,            V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS2           := SCM_ARR_SPL_VAL(P_REMARKS2,           V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS3           := SCM_ARR_SPL_VAL(P_REMARKS3,           V_DELIMITER, V_MST_LOOP_CNT);
            V_CHECK_NEED_YN      := SCM_ARR_SPL_VAL(P_CHECK_NEED_YN,      V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_MAIN          := SCM_ARR_SPL_VAL(P_EDIT_MAIN,          V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPTO_CODE        := SCM_ARR_SPL_VAL(P_SHIPTO_CODE,        V_DELIMITER, V_MST_LOOP_CNT);

            BEGIN
                SELECT FROM_SITE
                     , TO_SITE
                     , ITEM_ID
                  INTO V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_ITEM_ID_TEMP
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;
            END;

            BEGIN
                SELECT IA.DIVISION_ID
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
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM (SELECT A.DIVISION_ID
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
                             , A.TO_COUNTRY
                             , A.TO_CITY
                          FROM (SELECT DISTINCT XA.DIVISION_ID
                                     , XA.BOD_ID
                                     , XA.FROM_SITE
                                     , XA.TO_SITE
                                     , XA.SSP_INCOTERMS
                                     , XA.TRANSPORT_MODE
                                     , XA.ROUTE_ID
                                     , XA.D_COUNTRY
                                     , XA.D_PORT_CODE
                                     , XA.A_COUNTRY
                                     , XA.A_PORT_CODE
                                     , XA.LT_TOTAL
                                     , XA.LT_TOTAL_ORIGIN
                                     , XA.TO_COUNTRY
                                     , XA.TO_CITY
                                     , XA.PRIORITY
                                     , XA.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V XA
                                 WHERE XA.DIVISION_ID    = V_DIVISION_ID
                                   AND XA.FROM_SITE      = V_FROM_SITE_TEMP
                                   AND XA.TO_SITE        = V_TO_SITE_TEMP
                                   AND XA.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                   AND XA.SSP_INCOTERMS  = V_NEW_INCOTERMS
                                   AND XA.BOD_VALID_YN   = 'Y'
                                   AND XA.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND XA.TO_YYYYMMDD   >= V_SHIPMENT_DATE
                               ) A
                             , (SELECT DISTINCT SA.DIVISION_ID
                                     , SB.FROM_SITE
                                     , CASE WHEN TRIM(SC.PACKER_ITEM_ID_SUFFIX) IS NULL
                                            THEN SA.ITEM_ID
                                            ELSE NVL(CASE WHEN LENGTH(SA.ITEM_ID) >= 12
                                                          THEN SUBSTR(SA.ITEM_ID, 1, 11) || SC.PACKER_ITEM_ID_SUFFIX || SUBSTR(SA.ITEM_ID, 13)
                                                     END, SA.ITEM_ID)
                                       END AS ITEM_ID
                                     , SA.BOD_ID
                                  FROM SCP_MST_BOD_ITEM SA
                                     , SCP_MST_BOD_N_V SB
                                     , SCM_MST_SITE SC
                                 WHERE SA.DIVISION_ID = SB.DIVISION_ID
                                   AND SA.BOD_ID      = SB.BOD_ID
                                   AND SC.DIVISION_ID = SB.DIVISION_ID
                                   AND SC.SCM_SITE_ID = SB.FROM_SITE
                                   AND SC.OSP_YN      = 'Y'
                                   AND SA.DIVISION_ID = V_DIVISION_ID
                                   AND CASE WHEN TRIM(SC.PACKER_ITEM_ID_SUFFIX) IS NULL
                                            THEN SA.ITEM_ID
                                            ELSE NVL(CASE WHEN LENGTH(SA.ITEM_ID) >= 12
                                                          THEN SUBSTR(SA.ITEM_ID, 1, 11) || SC.PACKER_ITEM_ID_SUFFIX || SUBSTR(SA.ITEM_ID, 13)
                                                     END, SA.ITEM_ID)
                                       END = V_ITEM_ID_TEMP
                               ) B
                         WHERE B.DIVISION_ID    = A.DIVISION_ID
                           AND B.BOD_ID         = A.BOD_ID
                           AND A.DIVISION_ID    = V_DIVISION_ID
                           AND A.FROM_SITE      = V_FROM_SITE_TEMP
                           AND A.TO_SITE        = V_TO_SITE_TEMP
                           AND A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                           AND A.SSP_INCOTERMS  = V_NEW_INCOTERMS
                           AND A.BOD_VALID_YN   = 'Y'
                         ORDER BY A.PRIORITY
                       ) IA
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;   /* AS-IS TOP 1 이 0 행이면 앞 행 값이 그대로 남는다 */
            END;

            IF (   V_DIVISION_ID_TEMP        IS NULL
                OR V_NEW_BOD_ID_TEMP         IS NULL
                OR V_FROM_SITE_TEMP          IS NULL
                OR V_TO_SITE_TEMP            IS NULL
                OR V_NEW_INCOTERMS_TEMP      IS NULL
                OR V_NEW_TRANSPORT_MODE_TEMP IS NULL
                OR V_NEW_ROUTE_ID_TEMP       IS NULL
                OR V_NEW_D_CONTRY_TEMP       IS NULL
                OR V_NEW_D_PORT_CODE_TEMP    IS NULL
                OR V_NEW_A_COUNTRY_TEMP      IS NULL
                OR V_NEW_A_PORT_CODE_TEMP    IS NULL
                OR V_NEW_CUSTOMER_LT_TEMP    IS NULL
                OR V_NEW_TO_COUNTRY_TEMP     IS NULL
                OR V_NEW_TO_CITY_TEMP        IS NULL
               )
            THEN
                V_BOD_NOT_FOUND := 'Y';
                EXIT;
            END IF;

            IF V_ACTIVE_FLAG <> 'I'
            THEN

                V_QTY        := 0;
                V_BEFORE_QTY := 0;

                BEGIN
                    SELECT QTY
                         , BEFORE_QTY
                      INTO V_QTY
                         , V_BEFORE_QTY
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                IF V_QTY <> NVL(CEIL(TO_NUMBER(V_SHIPMENT_QTY)), 0)
                THEN
                    V_BEFORE_QTY := V_QTY;
                END IF;

                IF V_SHIPMENT_QTY IS NULL
                THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL
                THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                IF V_EDIT_MAIN = 'Y'
                THEN
                    V_CHECK_NEED_YN := 'Y';
                END IF;

                /* 2020.06.23 ETD_DATE, FCST_ETD_DATE 를 YYYYMMDD 와 같은 날짜로 변경 되도록 수정 */
                UPDATE SSP_ANL_SHIP_CONFIRM
                   SET YYYYMMDD             = V_SHIPMENT_DATE
                     , QTY                  = CEIL(TO_NUMBER(V_SHIPMENT_QTY))
                     , BEFORE_QTY           = V_BEFORE_QTY
                     , BOD_ID               = V_NEW_BOD_ID_TEMP
                     , ROUTE_ID             = TO_NUMBER(V_NEW_ROUTE_ID_TEMP)
                     , INCOTERMS            = V_NEW_INCOTERMS_TEMP
                     , D_COUNTRY            = V_NEW_D_CONTRY_TEMP
                     , D_PORT_CODE          = V_NEW_D_PORT_CODE_TEMP
                     , A_COUNTRY            = V_NEW_A_COUNTRY_TEMP
                     , A_PORT_CODE          = V_NEW_A_PORT_CODE_TEMP
                     , TO_COUNTRY           = V_NEW_TO_COUNTRY_TEMP
                     , TO_CITY              = V_NEW_TO_CITY_TEMP
                     , TRANSPORT_MODE       = V_NEW_TRANSPORT_MODE_TEMP
                     , ETD_DATE             = V_SHIPMENT_DATE            /* V_NEW_ETD_DATE */
                     , ETA_DATE             = V_NEW_ETA_DATE
                     , FCST_ETD_DATE        = V_SHIPMENT_DATE            /* V_NEW_ETD_DATE */
                     , FCST_ETA_DATE        = V_NEW_ETA_DATE
                     , CUSTOMER_LT          = TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)
                     , REMARKS              = V_REMARKS
                     , REMARKS2             = V_REMARKS2
                     , REMARKS3             = V_REMARKS3
                     , TO_SITE_SHIPTO_CODE  = V_SHIPTO_CODE
                     , CHECK_NEED_YN        = V_CHECK_NEED_YN
                     , LAST_UPDATED_BY      = P_USER_ID
                     , LAST_UPDATE_DATE     = V_CREATE_DATE
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

            END IF;

            /* 2020-07-24 KIMYONGHO 신규생성 기능 추가 */
            IF V_ACTIVE_FLAG = 'I'
            THEN

                V_INFSEQNO := TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10);

                /* 확정구간 마지막 일자( 현재일 기준 + 9 = PLANS_START_YYYYMMDD + 10) */
                V_LAST_CONFIRM_DATE := TO_CHAR(SYSDATE + 9, 'YYYYMMDD');
                V_DESCRIPTION       := '';
                D_EVENT_DATE        := SYSDATE;
                PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

                /* NEW CONFIRM 생성 CHECK 확인 */
                V_NEW_CONFIRM_ID := 'R' || TO_CHAR(SYSDATE, 'YYYYMMDD')
                                        || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_PACKER_REQ_ID.NEXTVAL), -6);

                BEGIN
                    SELECT MAX(PLAN_START_YYYYMMDD)
                         , MAX(PLAN_SEQ)
                      INTO V_PLAN_START_YYYYMMDD
                         , V_SEQ
                      FROM SSP_PLAN_VERSION_V
                     WHERE PLAN_TYPE           = 'SP'
                       AND DIVISION_ID         = V_DIVISION_ID
                       AND CONFIRM_FLAG        = 'Y'
                       AND PLAN_START_YYYYMMDD = (SELECT MAX(PLAN_START_YYYYMMDD)
                                                    FROM SSP_PLAN_VERSION_V
                                                   WHERE DIVISION_ID  = V_DIVISION_ID
                                                     AND PLAN_TYPE    = 'SP'
                                                     AND CONFIRM_FLAG = 'Y');
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                V_QTY        := 0;
                V_BEFORE_QTY := 0;

                BEGIN
                    SELECT QTY
                         , BEFORE_QTY
                      INTO V_QTY
                         , V_BEFORE_QTY
                      FROM SSP_ANL_SHIP_CONFIRM
                     WHERE CONFIRM_ID = V_CONFIRM_ID;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

                IF V_QTY <> NVL(TO_NUMBER(V_SHIPMENT_QTY), 0)
                THEN
                    V_BEFORE_QTY := V_QTY;
                END IF;

                IF V_SHIPMENT_QTY IS NULL
                THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL
                THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(V_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                IF V_EDIT_MAIN = 'Y'
                THEN
                    V_CHECK_NEED_YN := 'Y';
                END IF;

                /* -------------------------------------------------------------------------------------------------------------
                   1. SHIP_CONFIRM 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM
                   신규 건만 생성
                   ------------------------------------------------------------------------------------------------------------- */
                INSERT INTO SSP_ANL_SHIP_CONFIRM
                       (CONFIRM_ID
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
                      , ELECTRODE_YN
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                      , REQUESTOR
                      , BEFORE_QTY
                      , CHECK_NEED_YN
                      , PACKAGE_TYPE_CODE
                      , FACTORY_ID
                      , ELECTRODE_TYPE
                      , PACKAGE_QTY
                      , DOM_EXP
                      , REMARKS
                      , REMARKS2
                      , REMARKS3
                      , ATTRIBUTE10
                       )
                SELECT V_NEW_CONFIRM_ID
                     , 'C'
                     , A.DIVISION_ID
                     , V_PLAN_START_YYYYMMDD
                     , 'SP'
                     , V_SEQ
                     , A.ITEM_ID
                     , A.FROM_SITE
                     , A.TO_SITE
                     , V_SHIPMENT_DATE
                     , 0
                     , TO_NUMBER(V_SHIPMENT_QTY)
                     , V_NEW_BOD_ID_TEMP
                     , TO_NUMBER(V_NEW_ROUTE_ID_TEMP)
                     , A.BIZ_TYPE
                     , A.PROJECT_CODE
                     , A.FCST_TYPE
                     , V_SHIPMENT_DATE
                     , V_NEW_ETA_DATE
                     , V_SHIPMENT_DATE
                     , V_NEW_ETA_DATE
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
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
                     , A.TO_SITE_SHIPTO_CODE
                     , A.TO_SITE_COMPANY_ID
                     , 'C'
                     , P_USER_ID
                     , V_CREATE_DATE
                     , P_USER_ID
                     , V_CREATE_DATE
                     , A.ELECTRODE_YN
                     , A.ORIGIN_FROM_DIVISION_ID
                     , A.ORIGIN_TO_DIVISION_ID
                     , P_USER_ID
                     , 0
                     , 'Y'
                     , A.PACKAGE_TYPE_CODE
                     , A.FACTORY_ID
                     , A.ELECTRODE_TYPE
                     , CEIL(CASE WHEN B.PACKAGE_TYPE_CODE = 'BX' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.BOX_PER_CUT, 1)
                                 WHEN B.PACKAGE_TYPE_CODE = 'SC' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELCRATE_PER_CUT, 1)
                                 WHEN B.PACKAGE_TYPE_CODE = 'SR' THEN CEIL(TO_NUMBER(V_SHIPMENT_QTY) * NVL(B.CONVERT_TO_PC_ROLL_LENGTH, 1)) * NVL(B.STEELRACK_PER_CUT, 1)
                            END)
                     , A.DOM_EXP
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , NULL
                  FROM SSP_ANL_SHIP_CONFIRM A
                     , SSP_MST_SITE_ITEM_EE_V B
                 WHERE A.DIVISION_ID = (CASE WHEN A.BIZ_TYPE = 'E' THEN B.DIVISION_ID(+) ELSE B.ASSY_DIVISION_ID(+) END)
                   AND A.FROM_SITE   = (CASE WHEN A.BIZ_TYPE = 'E' THEN B.SCM_SITE_ID(+) ELSE B.ASSY_SCM_SITE_ID(+) END)
                   AND A.ITEM_ID     = B.ITEM_ID(+)
                   AND A.CONFIRM_ID  = V_CONFIRM_ID;

                /* -------------------------------------------------------------------------------------------------------------
                   2. SHIP_CONFIRM HISTORY 입력 : 출하확정 SSP_ANL_SHIP_CONFIRM_H
                   신규 건만 생성
                   ------------------------------------------------------------------------------------------------------------- */
                INSERT INTO SSP_ANL_SHIP_CONFIRM_H
                       (HISTORY_SEQ
                      , CONFIRM_ID
                      , CHANGE_TYPE
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
                      , CHANGE_REQ_NO
                      , ERP_SO_NO
                      , ERP_SO_ITEM_NO
                      , ERP_DO_NO
                      , ERP_STATUS
                      , CREATED_BY
                      , CREATION_DATE
                      , LAST_UPDATED_BY
                      , LAST_UPDATE_DATE
                      , HISTORY_CREATION_DATE
                      , ELECTRODE_YN
                      , ELECTRODE_TYPE
                      , ORIGIN_FROM_DIVISION_ID
                      , ORIGIN_TO_DIVISION_ID
                      , BEFORE_QTY
                      , REMARKS
                      , CHECK_NEED_YN)
                SELECT SEQ1_SSP_ANL_SHIP_CONFIRM_H.NEXTVAL   /* HISTORY_SEQ */
                     , CONFIRM_ID
                     , CHANGE_TYPE
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
                     , NULL              /* CHANGE_REQ_NO */
                     , NULL              /* ERP_SO_NO */
                     , NULL              /* ERP_SO_ITEM_NO */
                     , NULL              /* ERP_DO_NO */
                     , NULL              /* ERP_STATUS */
                     , P_USER_ID         /* CREATED_BY */
                     , V_CREATE_DATE     /* CREATION_DATE */
                     , P_USER_ID         /* LAST_UPDATED_BY */
                     , V_CREATE_DATE     /* LAST_UPDATE_DATE */
                     , V_CREATE_DATE     /* HISTORY_CREATION_DATE */
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , BEFORE_QTY
                     , REMARKS
                     , CHECK_NEED_YN
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE 1 = 1
                   AND CONFIRM_ID = V_NEW_CONFIRM_ID;

                /* ERP전송 Table(XIF_ERP_PACK_SHIP_PLAN_S_SN) Insert */
                INSERT INTO XIF_ERP_PACK_SHIP_PLAN_S_SN
                       (IF_SEQ
                      , IF_TYPE
                      , IF_ID
                      , IF_INS_DATE
                      , IF_FLAG
                      , IF_SND_DATE
                      , IFSEQNO
                      , PACKER_CODE
                      , DIVISION_ID
                      , PACK_MODEL_CODE
                      , NICK_NAME
                      , SSP_CNFM
                      , SOLD_TO
                      , SALES_SITE
                      , SHIP_TO
                      , TRANSPORT_MODE
                      , INCOTERMS
                      , SHIP_PLAN_DATE
                      , SHIP_PLAN_QTY
                      , "COMMENT"
                      , ORDER_TYPE_DETAIL
                        /*  20211125 */
                      , ATTRIBUTE1
                      , ATTRIBUTE2
                      , ATTRIBUTE3
                      , ATTRIBUTE4
                      , ATTRIBUTE5
                      , ATTRIBUTE6
                      , ATTRIBUTE7
                      , ATTRIBUTE8
                      , ATTRIBUTE9
                      , ATTRIBUTE10
                       )
                SELECT 'OERP' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10) AS IF_SEQ
                     , 'I'
                     , 'OSCM_OERP_PACK_SHIP_PLAN'
                     , SYSDATE
                     , 'N'
                     , NULL
                     , V_INFSEQNO
                     , NVL(X1.NEW_VALUE1, A.FROM_SITE)             AS FROM_SITE
                     , A.DIVISION_ID
                     , A.ITEM_ID
                     , A.NICK_NAME
                     , A.CONFIRM_ID
                     , NVL(X3.NEW_VALUE1, A.TO_SITE_SOLDTO_CODE)   AS TO_SITE_SOLDTO_CODE
                     , NVL(X2.NEW_VALUE1, A.TO_SITE)               AS TO_SITE
                     , NVL(X4.NEW_VALUE1, A.TO_SITE_SHIPTO_CODE)   AS TO_SITE_SHIPTO_CODE
                     , A.TRANSPORT_MODE
                     , A.INCOTERMS
                     , A.YYYYMMDD
                     , A.QTY
                     , A.REMARK
                     , A.ORDER_TYPE_DETAIL
                     , NULL              /* ATTRIBUTE1 */
                     , NULL              /* ATTRIBUTE2 */
                     , A.ATTR_03         /* Model PIC */
                     , A.ATTR_04         /* MTK_OWNER */
                     , NULL              /* ATTRIBUTE5 */
                     , NULL              /* ATTRIBUTE6 */
                     , NULL              /* ATTRIBUTE7 */
                     , NULL              /* ATTRIBUTE8 */
                     , NULL              /* ATTRIBUTE9 */
                     , NULL              /* ATTRIBUTE10 */
                  FROM (SELECT IA.FROM_SITE
                             , IA.DIVISION_ID
                             , IA.ITEM_ID
                             , FN_GET_ITEM_NICKNAME(IA.DIVISION_ID, IA.ITEM_ID) AS NICK_NAME
                             , IA.CONFIRM_ID
                             , IA.TO_SITE_SOLDTO_CODE
                             , IA.TO_SITE
                             , IA.TO_SITE_SHIPTO_CODE
                             , IA.TRANSPORT_MODE
                             , IA.INCOTERMS
                             , IA.YYYYMMDD
                             , IA.QTY
                             , IA.REMARK
                             , IA.ORDER_TYPE_DETAIL
                             , IA.ATTR_03        /* Model PIC */
                             , IA.ATTR_04        /* MTK_OWNER */
                          FROM (SELECT   /* NEW */
                                       XA.CONFIRM_ID
                                     , 'B'               AS VERSION_TYPE   /* B:NEW/A:OLD */
                                     , XA.DIVISION_ID
                                     , XA.ITEM_ID
                                     , XA.FROM_SITE
                                     , XA.TO_SITE
                                     , XA.YYYYMMDD       AS YYYYMMDD
                                     , XA.YYYYMMDD       AS YYYYMMDD_LAST
                                     , NVL(XA.QTY, 0)    AS QTY
                                     , XA.BOD_ID         AS BOD_ID
                                     , XA.TRANSPORT_MODE
                                     , XA.INCOTERMS
                                     , XA.ROUTE_ID       AS ROUTE_ID
                                     , 'P'               AS OPERATION_GROUP
                                     , XA.BIZ_TYPE
                                     , XA.PROJECT_CODE
                                     , NVL(XD.SEGMENT2, XA.FCST_TYPE) AS ORDER_TYPE_DETAIL
                                     , XA.TO_SITE_SOLDTO_CODE
                                     , XA.TO_SITE_SHIPTO_CODE
                                       /* ERP I/F 추가(BUILDING, REMARK, CUSTOMER_REQ, CHANGE_CODE, CHANGE_CODE_NAME, REQUESTOR ) */
                                     , XA.REMARKS        AS BUILDING
                                     , XA.REMARKS2       AS REMARK
                                     , XA.REMARKS3       AS CUSTOMER_REQ
                                     , NULL              AS CHANGE_CODE
                                       /* 20211125 */
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     , CASE WHEN XC.USERNAME IS NULL THEN NULL
--                                            ELSE XC.USERNAME || '(' || XB.USER_ID || ')'
                                     , CASE WHEN XC.USER_NM IS NULL THEN NULL
                                            ELSE XC.USER_NM || '(' || XB.USER_ID || ')'
                                     /* 2026.09.30 AJS 수정 (END) */
                                       END                                        AS ATTR_03   /* Model PIC */
                                     , FN_GET_SSP_MKT_OWNER_NAME(XE.OWNER, '', 'KO') AS ATTR_04   /* MTK_OWNER */
                                  FROM SSP_ANL_SHIP_CONFIRM XA
                                     , SCM_MST_SITE_ITEM XE
                                     , SSP_MST_MODEL_USER XB
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     , TB_FX_USER XC
                                     , SCM_ADM_USER_M XC
                                     /* 2026.09.30 AJS 수정 (END) */
                                     , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                                 WHERE XE.DIVISION_ID(+)  = XA.DIVISION_ID
                                   AND XE.SCM_SITE_ID(+)  = XA.TO_SITE
                                   AND XE.ITEM_ID(+)      = XA.ITEM_ID
                                   AND XE.PROJECT_CODE(+) = XA.PROJECT_CODE
                                   AND XB.DIVISION_ID(+)  = XA.DIVISION_ID
                                   AND XB.FROM_SITE(+)    = XA.FROM_SITE
                                   AND XB.ITEM_ID(+)      = XA.ITEM_ID
                                   AND XB.VALID_YN(+)     = 'Y'
                                   /* 2026.09.30 AJS 수정 (START) */
--                                   AND XC.USERID(+)       = XB.USER_ID
--                                   AND XC.USEYN(+)        = 'Y'
                                   AND XC.USER_ID(+)      = XB.USER_ID
                                   AND XC.USE_YN(+)       = 'Y'
                                   /* 2026.09.30 AJS 수정 (END) */
                                   AND XD.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                                   AND XD.VALID_YN(+)     = 'Y'
                                   AND XD.SEGMENT1(+)     = XA.FCST_TYPE
                                   AND XA.CONFIRM_ID      = V_NEW_CONFIRM_ID
                                   AND NVL(XA.QTY, 0)    <> 0   /* 신규생성경우 0은 제외 */
                               ) IA
                             , SCM_MST_SITE IB
                             , SCM_MST_SITE IC
                         WHERE IB.DIVISION_ID(+) = IA.DIVISION_ID
                           AND IB.SCM_SITE_ID(+) = IA.FROM_SITE
                           AND IB.VALID_YN(+)    = 'Y'
                           AND IC.DIVISION_ID(+) = IA.DIVISION_ID
                           AND IC.SCM_SITE_ID(+) = IA.TO_SITE
                           AND IC.VALID_YN(+)    = 'Y'
                       ) A
                     , NERP_CONV_MASTER X1
                     , NERP_CONV_MASTER X2
                     , NERP_CONV_MASTER X3
                     , NERP_CONV_MASTER X4
                 WHERE X1.CODETYPE(+)   = 'SCP_SITE_ID'
                   AND X1.OLD_VALUE1(+) = A.FROM_SITE
                   AND X2.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND X2.OLD_VALUE1(+) = A.TO_SITE
                   AND X3.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND X3.OLD_VALUE1(+) = A.TO_SITE_SOLDTO_CODE
                   AND X4.CODETYPE(+)   = 'END_CUSTOMER_ID'
                   AND X4.OLD_VALUE1(+) = A.TO_SITE_SHIPTO_CODE;

                INSERT INTO XIF_SCS_PACK_SHIP_PLAN_S_SN
                       (IF_SEQ
                      , IF_TYPE
                      , IF_ID
                      , IF_INS_DATE
                      , IF_FLAG
                      , PACKER_CODE
                      , DIVISION_ID
                      , PLAN_VERSION
                      , PACK_MODEL_CODE
                      , NICK_NAME
                      , TARGET_ORDER
                      , SSP_CNFM
                      , SALES_SITE
                      , SHIP_TO
                      , SHIP_TO_NAME
                      , TRANSPORT_MODE
                      , INCOTERMS
                      , SHIP_PLAN_DATE
                      , SHIP_PLAN_QTY
                      , "COMMENT"
                      , ATTR_01
                      , ATTR_02
                      , ATTR_03
                      , ATTR_04
                      , ATTR_05
                      , ATTR_06
                      , ATTR_07
                      , ATTR_08
                      , ATTR_09
                      , ATTR_10
                      , ORDER_TYPE_DETAIL
                       )
                SELECT 'OSCM' || TO_CHAR(SYSDATE, 'YYMMDD') || FN_ZERO_LPAD(TO_CHAR(SEQ1_XIF_SCS.NEXTVAL), 10) AS IF_SEQ
                     , 'I'                                 AS IF_TYPE
                     , 'OSCM_OSCS_SCS_PACK_SHIP_PLAN'       AS IF_ID
                     , SYSDATE                              AS IF_INS_DATE
                     , 'N'                                  AS IF_FLAG
                     , NVL(X1.NEW_VALUE1, A.PACKER_CODE)    AS PACKER_CODE
                     , A.DIVISION_ID
                     , A.PLAN_VERSION
                     , A.PACK_MODEL_CODE
                     , A.NICK_NAME
                     , 'O'                                  AS TARGET_ORDER
                     , A.SSP_CNFM
                     , A.SALES_SITE
                     , A.SHIP_TO
                     , A.SHIP_TO_NAME
                     , A.TRANSPORT_MODE
                     , A.INCOTERMS
                     , A.SHIP_PLAN_DATE
                     , A.SHIP_PLAN_QTY
                       /* 20211102  SMS  수정 */
                     , A."COMMENT"
                     , A.ATTR_01
                     , NULL                                 AS ATTR_02
                       /* 20211102  SMS  수정 */
                     , A.ATTR_03                            /* Model PIC */
                     , A.ATTR_04                            /* MTK_OWNER */
                     , NULL                                 AS ATTR_05
                     , NULL                                 AS ATTR_06
                     , NULL                                 AS ATTR_07
                     , NULL                                 AS ATTR_08
                     , NULL                                 AS ATTR_09
                     , A.ATTR_10
                     , A.FCST_TYPE                          /* ORDER_TYPE_DETAIL */
                  FROM (SELECT XA.FROM_SITE                              AS PACKER_CODE
                             , XA.DIVISION_ID                            AS DIVISION_ID
                             , TO_CHAR(SYSDATE, 'YYYYMMDD')              AS PLAN_VERSION
                             , XA.ITEM_ID                                AS PACK_MODEL_CODE
                             , FN_GET_ITEM_NICKNAME(XA.DIVISION_ID, XA.ITEM_ID) AS NICK_NAME
                             , XA.CONFIRM_ID                             AS SSP_CNFM
                             , XA.TO_SITE                                AS SALES_SITE
                             , XA.TO_SITE_SHIPTO_CODE                    AS SHIP_TO
                             , FN_GET_SITE_CUSTOMER_INFO(XA.DIVISION_ID, XA.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIP_TO_NAME
                             , XA.TRANSPORT_MODE                         AS TRANSPORT_MODE
                             , XA.INCOTERMS                              AS INCOTERMS
                             , XA.YYYYMMDD                               AS SHIP_PLAN_DATE
                             , XA.QTY                                    AS SHIP_PLAN_QTY
                               /* 20211102  SMS  수정 */
                             , XA.REMARKS                                AS "COMMENT"
                             , XA.DIVISION_ID || '_' || V_PLAN_START_YYYYMMDD || '_' || V_IF_GROUP_NO AS ATTR_01
                               /* 20211102  SMS  수정 */
                             /* 2026.09.30 AJS 수정 (START) */
--                             , CASE WHEN XC.USERNAME IS NULL THEN NULL
--                                    ELSE XC.USERNAME || '(' || XB.USER_ID || ')'
                             , CASE WHEN XC.USER_NM IS NULL THEN NULL
                                    ELSE XC.USER_NM || '(' || XB.USER_ID || ')'
                             /* 2026.09.30 AJS 수정 (END) */
                               END                                       AS ATTR_03   /* Model PIC */
                             , FN_GET_SSP_MKT_OWNER_NAME(XE.OWNER, '', 'KO') AS ATTR_04   /* MTK_OWNER */
                             , XA.CONFIRM_ID                             AS ATTR_10
                               /* 20211102  SMS  수정 */
                             , NVL(XD.SEGMENT2, XA.FCST_TYPE)            AS FCST_TYPE   /* ORDER_TYPE_DETAIL */
                          FROM SSP_ANL_SHIP_CONFIRM XA
                             , (SELECT SA.DIVISION_ID
                                     , SA.PROJECT_CODE
                                     , SA.SCM_SITE_ID
                                     , SA.ITEM_ID
                                  FROM (SELECT DIVISION_ID
                                             , PROJECT_CODE
                                             , SCM_SITE_ID
                                             , ITEM_ID
                                             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) AS NUM
                                          FROM SCM_MST_SITE_ITEM
                                       ) SA
                                 WHERE SA.NUM = 1
                               ) XG
                             , SCM_MST_SITE_ITEM XE
                             , SSP_MST_MODEL_USER XB
                             /* 2026.09.30 AJS 수정 (START) */
--                             , TB_FX_USER XC
                             , SCM_ADM_USER_M XC
                             /* 2026.09.30 AJS 수정 (END) */
                             , SCM_ADM_LOOKUP_MASTER_DETAIL XD
                         WHERE XG.DIVISION_ID(+)  = (CASE WHEN XA.DIVISION_ID = 'EE' THEN XA.ORIGIN_TO_DIVISION_ID ELSE XA.DIVISION_ID END)
                           AND XG.SCM_SITE_ID(+)  = XA.TO_SITE
                           AND XG.ITEM_ID(+)      = XA.ITEM_ID
                           AND XE.DIVISION_ID(+)  = XA.DIVISION_ID
                           AND XE.SCM_SITE_ID(+)  = XA.TO_SITE
                           AND XE.ITEM_ID(+)      = XA.ITEM_ID
                           AND XE.PROJECT_CODE(+) = XG.PROJECT_CODE
                           AND XB.DIVISION_ID(+)  = XA.DIVISION_ID
                           AND XB.FROM_SITE(+)    = XA.FROM_SITE
                           AND XB.ITEM_ID(+)      = XA.ITEM_ID
                           AND XB.VALID_YN(+)     = 'Y'
                           /* 2026.09.30 AJS 수정 (START) */
--                           AND XC.USERID(+)       = XB.USER_ID
--                           AND XC.USEYN(+)        = 'Y'
                           AND XC.USER_ID(+)      = XB.USER_ID
                           AND XC.USE_YN(+)       = 'Y'
                           /* 2026.09.30 AJS 수정 (END) */
                           AND XD.LOOKUP_TYPE(+)  = 'SALES_TYPE_CODE'
                           AND XD.VALID_YN(+)     = 'Y'
                           AND XD.SEGMENT1(+)     = XA.FCST_TYPE
                           AND XA.CONFIRM_ID      = V_NEW_CONFIRM_ID
                           AND NVL(XA.QTY, 0)    <> 0   /* 신규생성경우 0은 제외 */
                       ) A
                     , NERP_CONV_MASTER X1
                 WHERE X1.CODETYPE(+)   = 'SCP_SITE_ID'
                   AND X1.OLD_VALUE1(+) = A.PACKER_CODE;

                /* MKT FCST - SSP Sync 신규 생성 건 대상 */
                /* PR_DM_SSP_CONFIRM_SYNC(P_DIVISION_ID, V_NEW_CONFIRM_ID); */
                /* V_CONFIRM_ID := V_NEW_CONFIRM_ID; */

            END IF;

            IF V_EDIT_MAIN = 'Y'
            THEN

                BEGIN
                    SELECT IA.DIVISION_ID
                         , IA.ITEM_ID
                         , IA.FROM_SITE
                         , IA.TO_SITE
                         , IA.YYYYMMDD
                         , IA.BOD_ID
                         , IA.PROJECT_CODE
                         , IA.FCST_TYPE
                         , IA.INCOTERMS
                         , IA.TRANSPORT_MODE
                         , IA.CONFIRM_ID
                         , IA.CHANGE_REQ_NO
                      INTO N_ORI_DIVISION_ID
                         , N_ORI_ITEM_ID
                         , N_ORI_FROM_SITE
                         , N_ORI_TO_SITE
                         , N_ORI_YYYYMMDD
                         , N_ORI_BOD_ID
                         , N_ORI_PROJECT_CODE
                         , N_ORI_FCST_TYPE
                         , N_ORI_INCOTERMS
                         , N_ORI_TRANSPORT_MODE
                         , N_ORI_CONFIRM_ID
                         , V_CHANGE_REQ_NO
                      FROM (SELECT DIVISION_ID
                                 , ITEM_ID
                                 , FROM_SITE
                                 , TO_SITE
                                 , YYYYMMDD
                                 , BOD_ID
                                 , PROJECT_CODE
                                 , FCST_TYPE
                                 , INCOTERMS
                                 , TRANSPORT_MODE
                                 , CONFIRM_ID
                                 , CHANGE_REQ_NO
                              FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                             WHERE CONFIRM_ID = V_CONFIRM_ID
                               AND VALID_YN   = 'Y'
                             ORDER BY LAST_UPDATE_DATE DESC
                           ) IA
                     WHERE ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        NULL;
                END;

            END IF;

            IF LENGTH(RTRIM(V_CHANGE_REQ_NO)) > 0
            THEN

                /* 이력저장 */
                /* PR_SSP_ANL_SHIP_CONFIRM_HIST 는 Oracle 미이관(2026.09.22 기준) */
                /* PR_SSP_ANL_SHIP_CONFIRM_HIST(V_CHANGE_REQ_NO, P_USER_ID, ''); */

                SELECT COUNT(*)
                  INTO V_MAIL_CHK
                  FROM SSP_MST_SEND_MAIL_REQ
                 WHERE CHANGE_REQ_NO = V_CHANGE_REQ_NO;

                IF V_MAIL_CHK = 0
                THEN

                    /* 메일전송 */
                    INSERT INTO SSP_MST_SEND_MAIL_REQ
                           (CHANGE_REQ_NO
                          , TRANSFER_FLAG
                          , GRP_CHANGE_REQ)
                    VALUES (V_CHANGE_REQ_NO
                          , 'N'
                          , V_GRP_CHANGE_REQ);

                    V_MAIL_FLAG := 1;

                END IF;

            END IF;

        END LOOP;

        IF V_BOD_NOT_FOUND = 'Y'
        THEN

            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            COMMIT;

            OPEN O_RC1 FOR SELECT 'X'  AS RESULT_CODE
                                , NULL AS "Request_no"
                             FROM DUAL;
            OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                             FROM DUAL
                            WHERE 1 = 0;

            RETURN;

        END IF;

        /* IF V_MAIL_FLAG = 1 THEN */
        /*     PR_SSP_MAIL_SEND_ADJUST_MST(V_GRP_CHANGE_REQ); */
        /* END IF; */

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S'                       AS RESULT_CODE
                            , V_MAX_LOOP_CNT            AS RESULT_CNT
                            , NVL(V_CHANGE_REQ_NO, '')  AS CHANGE_REQ_NO
                         FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                         FROM DUAL
                        WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_CONF_PK;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE
                                , '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                             FROM DUAL;
            OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                             FROM DUAL
                            WHERE 1 = 0;

    END P_SSP0015_SAVE_SHIPMENT_REQUEST_CONFIRM_PACKER;

    /* ============================================================
       P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING
       AS-IS SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING
       ※ '^' 로 이어 붙인 여러 행을 SCM_ARR_SPL_VAL 로 잘라 한 행씩 처리한다(AS-IS 동일).
       ※ BOD 조회(SELECT TOP 1 … ORDER BY PRIORITY)는 인라인 뷰 + ROWNUM 으로 옮긴다.
          0 행이면 AS-IS 처럼 앞 행 값이 남는다(AS-IS 는 루프마다 초기화하지 않는다).
       ※ 저장 시작에 SAVEPOINT 를 두어 오류('F') 시 앞 행 저장분까지 되돌린다.
          (AS-IS 는 트랜잭션이 없어 앞 행 저장분이 남고, 오류 시 CATCH 에서 COMMIT 한다)
       ※ AS-IS 가 부르는 ERP 전송 프로시저는 Oracle 에 없다(2026.09.22 기준) — 호출 자리를 주석으로 남긴다.
          PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING
    (
        P_ACTIVE_FLAG               IN  VARCHAR2,
        P_DIVISION_ID               IN  VARCHAR2,
        P_CONFIRM_ID                IN  VARCHAR2,
        P_SHIPMENT_QTY              IN  VARCHAR2,
        P_SHIPMENT_DATE             IN  VARCHAR2,
        P_FROM_SITE                 IN  VARCHAR2,
        P_NEW_BOD_ID                IN  VARCHAR2,
        P_NEW_ROUTE_ID              IN  VARCHAR2,
        P_NEW_ETD_DATE              IN  VARCHAR2,
        P_NEW_ETA_DATE              IN  VARCHAR2,
        P_NEW_INCOTERMS             IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE        IN  VARCHAR2,
        P_NEW_D_CONTRY              IN  VARCHAR2,
        P_NEW_D_PORT_CODE           IN  VARCHAR2,
        P_NEW_A_COUNTRY             IN  VARCHAR2,
        P_NEW_A_PORT_CODE           IN  VARCHAR2,
        P_NEW_CUSTOMER_LT           IN  VARCHAR2,
        P_NEW_TO_COUNTRY            IN  VARCHAR2,
        P_NEW_TO_CITY               IN  VARCHAR2,
        P_EDIT_MAIN                 IN  VARCHAR2,
        P_EDIT_REMARK               IN  VARCHAR2,
        P_USER_ID                   IN  VARCHAR2,
        P_USER_DEPT_ID              IN  VARCHAR2,
        P_ELECTRODE_YN              IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE            IN  VARCHAR2 DEFAULT '',
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2 DEFAULT '',
        P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2 DEFAULT '',
        P_REMARKS                   IN  VARCHAR2,
        P_REMARKS2                  IN  VARCHAR2,
        P_REMARKS3                  IN  VARCHAR2,
        P_CHANGE_REASON_CODE        IN  VARCHAR2,
        P_CHANGE_REASON_DETAIL      IN  VARCHAR2,
        P_TITLE                     IN  VARCHAR2,
        P_PROGRAM_ID                IN  VARCHAR2,
        P_SHIPTO_CODE               IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR,
        O_RC2                       OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING
         * Description  : Shipment Plan Change 작성중 저장
         * 호출         : SSP0015
         * 관련 Table   : SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
         * 관련 프로시저 : PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN - ERP 관련 Table)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2018/10/10   ygkim          Initial Release [PJ20182279] 전지본부 출하계획 시스템 구축 프로젝트
         * 2019/04/03   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REMARKS, REMARKS 컬럼 추가
         * 2019/04/30   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REQUESTOR 컬럼 변경
         * 2019/05/07   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  REMARKS3 컬럼 추가
         * 2019/05/15   AYJ            [PJ20189106] 전지.GSCM 고도화 이행  CHAGE_REASON_CODE, CHAGE_REASON_DETAIL PARAM추가
         * 2019/05/28   mcTheJ         [PJ20189106] 전지.GSCM 고도화 이행  CHANGE_TITLE 수정
         * 2019/05/29   mcTheJ         [PJ20189106] 전지.GSCM 고도화 이행  CHANGE_REASON 추가로 인한 CS코드에서 반복 호출(단. SONo의 경우 통으로 Parameter 넘김)
         * 2019/09/04   AYJ            etd:shipdate, eta:etd+lt_day로 셋팅
         * 2019/10/29   ayj            FCST_ETA_DATE, ETA_DATE 저장 값 수정(출발일 기준 항차를 고려한 ETA_DATE 계산)
         * 2020-02-26   KIMYONGHO      [C20200224-000318]출하변경사유 코드 변경   R01 - > T07
         * 2020-07-08   KBK            [C20200630-000480] : Shipment Plan (IT& Mobile) 화면에서 SSP Planner 가 Data를 수정 할경우 Change reason / reason detail Tap을 화면상에 보여주지 않고, Data상으로 T07: 외부 요인으로 Default 설정 필요.
         * 2021/09/02   KIMYONGHO      SCP_MST_BOD_v -> SCP_MST_BOD_N_V 변경
         * 2024/05/08   jilee          PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH  'C' 변경요청, 저장시 ATTRIBUTE2 'A' 추가
         * 2026.09.22                  MSSQL -> Oracle 변환
         */
        V_RECV_ACTIVE_FLAG          VARCHAR2(4000 CHAR);
        V_MAX_REQ_NO                VARCHAR2(40 CHAR);
        V_ACTIVE_FLAG               VARCHAR2(4000 CHAR);
        V_DIVISION_ID               VARCHAR2(4000 CHAR);
        V_CONFIRM_ID                VARCHAR2(4000 CHAR);
        V_SHIPMENT_QTY              VARCHAR2(4000 CHAR);
        V_SHIPMENT_DATE             VARCHAR2(4000 CHAR);
        V_FROM_SITE                 VARCHAR2(4000 CHAR);
        V_TO_SITE                   VARCHAR2(4000 CHAR);
        V_ITEM_ID                   VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID                VARCHAR2(4000 CHAR);
        V_NEW_ETD_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ETA_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS             VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE        VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY              VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY             VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT           VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY            VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY               VARCHAR2(4000 CHAR);
        V_EDIT_MAIN                 VARCHAR2(4000 CHAR);
        V_EDIT_REMARK               VARCHAR2(4000 CHAR);
        V_CREATE_DATE               DATE;
        V_CHK                       NUMBER := 0;
        V_TITLE                     VARCHAR2(4000 CHAR);
        V_ELECTRODE_YN              VARCHAR2(4000 CHAR);
        V_ELECTRODE_TYPE            VARCHAR2(4000 CHAR);
        V_ORIGIN_FROM_DIVISION_ID   VARCHAR2(4000 CHAR);
        V_ORIGION_TO_DIVISION_ID    VARCHAR2(4000 CHAR);
        V_REMARKS                   VARCHAR2(4000 CHAR);
        V_REMARKS2                  VARCHAR2(4000 CHAR);
        V_REMARKS3                  VARCHAR2(4000 CHAR);
        V_CHANGE_REASON_CODE        VARCHAR2(4000 CHAR);
        V_CHANGE_REASON_DETAIL      VARCHAR2(4000 CHAR);

        V_DIVISION_ID_TEMP          VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000 CHAR);
        V_FROM_SITE_TEMP            VARCHAR2(4000 CHAR);
        V_TO_SITE_TEMP              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000 CHAR);

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING';
        V_LOG_TYPE                  VARCHAR2(30 CHAR);
        N_LOG_COUNT                 NUMBER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
        V_DESCRIPTION               VARCHAR2(500 CHAR);
        D_EVENT_DATE                DATE;

        V_DELIMITER                 VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT              NUMBER := 0;
        V_MST_LOOP_CNT              NUMBER := 0;

        V_BOD_NOT_FOUND             VARCHAR2(1 CHAR) := 'N';
        V_ERR_CODE                  NUMBER;
        V_ERR_MESSAGE               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_DRAFT;

        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
        V_CREATE_DATE      := SYSDATE;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER));

        WHILE LENGTH(RTRIM(V_RECV_ACTIVE_FLAG)) > 0
          AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG             := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,             V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID             := SCM_ARR_SPL_VAL(P_DIVISION_ID,             V_DELIMITER, V_MST_LOOP_CNT);
            V_CONFIRM_ID              := SCM_ARR_SPL_VAL(P_CONFIRM_ID,              V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_QTY            := SCM_ARR_SPL_VAL(P_SHIPMENT_QTY,            V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_DATE           := SCM_ARR_SPL_VAL(P_SHIPMENT_DATE,           V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE               := SCM_ARR_SPL_VAL(P_FROM_SITE,               V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_BOD_ID              := SCM_ARR_SPL_VAL(P_NEW_BOD_ID,              V_DELIMITER, V_MST_LOOP_CNT);
            V_TITLE                   := 'Change on ' || SCM_ARR_SPL_VAL(P_TITLE,   V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETD_DATE            := SCM_ARR_SPL_VAL(P_NEW_ETD_DATE,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETA_DATE            := SCM_ARR_SPL_VAL(P_NEW_ETA_DATE,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ROUTE_ID            := SCM_ARR_SPL_VAL(P_NEW_ROUTE_ID,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_INCOTERMS           := SCM_ARR_SPL_VAL(P_NEW_INCOTERMS,           V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TRANSPORT_MODE      := SCM_ARR_SPL_VAL(P_NEW_TRANSPORT_MODE,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_CONTRY            := SCM_ARR_SPL_VAL(P_NEW_D_CONTRY,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_PORT_CODE         := SCM_ARR_SPL_VAL(P_NEW_D_PORT_CODE,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_COUNTRY           := SCM_ARR_SPL_VAL(P_NEW_A_COUNTRY,           V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_PORT_CODE         := SCM_ARR_SPL_VAL(P_NEW_A_PORT_CODE,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_CUSTOMER_LT         := SCM_ARR_SPL_VAL(P_NEW_CUSTOMER_LT,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_COUNTRY          := SCM_ARR_SPL_VAL(P_NEW_TO_COUNTRY,          V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_CITY             := SCM_ARR_SPL_VAL(P_NEW_TO_CITY,             V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_MAIN               := SCM_ARR_SPL_VAL(P_EDIT_MAIN,               V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_REMARK             := SCM_ARR_SPL_VAL(P_EDIT_REMARK,             V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_YN            := SCM_ARR_SPL_VAL(P_ELECTRODE_YN,            V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_TYPE          := SCM_ARR_SPL_VAL(P_ELECTRODE_TYPE,          V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGIN_FROM_DIVISION_ID := SCM_ARR_SPL_VAL(P_ORIGIN_FROM_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGION_TO_DIVISION_ID  := SCM_ARR_SPL_VAL(P_ORIGION_TO_DIVISION_ID,  V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS                 := SCM_ARR_SPL_VAL(P_REMARKS,                 V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS2                := SCM_ARR_SPL_VAL(P_REMARKS2,                V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS3                := SCM_ARR_SPL_VAL(P_REMARKS3,                V_DELIMITER, V_MST_LOOP_CNT);
            V_CHANGE_REASON_CODE      := SCM_ARR_SPL_VAL(P_CHANGE_REASON_CODE,      V_DELIMITER, V_MST_LOOP_CNT);
            V_CHANGE_REASON_DETAIL    := SCM_ARR_SPL_VAL(P_CHANGE_REASON_DETAIL,    V_DELIMITER, V_MST_LOOP_CNT);

            IF V_CHANGE_REASON_CODE IS NULL
            THEN
                V_CHANGE_REASON_CODE := 'T07';
            END IF;

            IF V_CHANGE_REASON_DETAIL IS NULL
            THEN
                V_CHANGE_REASON_DETAIL := NULL;
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
                    NULL;
            END;

            BEGIN
                SELECT IA.DIVISION_ID
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
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM (SELECT A.DIVISION_ID
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
                             , A.TO_COUNTRY
                             , A.TO_CITY
                          FROM (SELECT DISTINCT XA.DIVISION_ID
                                     , XA.BOD_ID
                                     , XA.FROM_SITE
                                     , XA.TO_SITE
                                     , XA.SSP_INCOTERMS
                                     , XA.TRANSPORT_MODE
                                     , XA.ROUTE_ID
                                     , XA.D_COUNTRY
                                     , XA.D_PORT_CODE
                                     , XA.A_COUNTRY
                                     , XA.A_PORT_CODE
                                     , XA.LT_TOTAL
                                     , XA.LT_TOTAL_ORIGIN
                                     , XA.TO_COUNTRY
                                     , XA.TO_CITY
                                     , XA.PRIORITY
                                     , XA.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V XA
                                 WHERE XA.DIVISION_ID    = V_DIVISION_ID
                                   AND XA.FROM_SITE      = V_FROM_SITE
                                   AND XA.TO_SITE        = V_TO_SITE
                                   AND XA.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                   AND XA.SSP_INCOTERMS  = V_NEW_INCOTERMS
                                   AND XA.BOD_VALID_YN   = 'Y'
                                   AND XA.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND XA.TO_YYYYMMDD   >= V_SHIPMENT_DATE
                               ) A
                             , (SELECT DISTINCT SA.DIVISION_ID
                                     , SA.ITEM_ID
                                     , SA.BOD_ID
                                  FROM SCP_MST_BOD_ITEM SA
                                 WHERE SA.DIVISION_ID = V_DIVISION_ID
                                   AND SA.ITEM_ID     = V_ITEM_ID
                               ) B
                         WHERE B.DIVISION_ID    = A.DIVISION_ID
                           AND B.BOD_ID         = A.BOD_ID
                           AND A.DIVISION_ID    = V_DIVISION_ID
                           AND A.FROM_SITE      = V_FROM_SITE
                           AND A.TO_SITE        = V_TO_SITE
                           AND A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                           AND A.SSP_INCOTERMS  = V_NEW_INCOTERMS
                           AND A.BOD_VALID_YN   = 'Y'
                         ORDER BY A.PRIORITY
                       ) IA
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;   /* AS-IS TOP 1 이 0 행이면 앞 행 값이 그대로 남는다 */
            END;

            IF (   V_DIVISION_ID_TEMP        IS NULL
                OR V_NEW_BOD_ID_TEMP         IS NULL
                OR V_FROM_SITE_TEMP          IS NULL
                OR V_TO_SITE_TEMP            IS NULL
                OR V_NEW_INCOTERMS_TEMP      IS NULL
                OR V_NEW_TRANSPORT_MODE_TEMP IS NULL
                OR V_NEW_ROUTE_ID_TEMP       IS NULL
                OR V_NEW_D_CONTRY_TEMP       IS NULL
                OR V_NEW_D_PORT_CODE_TEMP    IS NULL
                OR V_NEW_A_COUNTRY_TEMP      IS NULL
                OR V_NEW_A_PORT_CODE_TEMP    IS NULL
                OR V_NEW_CUSTOMER_LT_TEMP    IS NULL
                OR V_NEW_TO_COUNTRY_TEMP     IS NULL
                OR V_NEW_TO_CITY_TEMP        IS NULL
               )
            THEN
                V_BOD_NOT_FOUND := 'Y';
                EXIT;
            END IF;

            IF V_EDIT_MAIN = 'Y'
            THEN

                IF V_CHK = 0
                THEN

                    V_MAX_REQ_NO := 'R' || TO_CHAR(V_CREATE_DATE, 'YYYYMMDD')
                                        || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL), -6);

                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                           (CHANGE_REQ_NO
                          , CHANGE_TYPE
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
                          , CREATED_BY
                          , CREATION_DATE
                          , LAST_UPDATED_BY
                          , LAST_UPDATE_DATE
                          , ELECTRODE_YN
                          , ELECTRODE_TYPE
                          , ORIGIN_FROM_DIVISION_ID
                          , ORIGIN_TO_DIVISION_ID
                           )
                    VALUES (V_MAX_REQ_NO
                          , 'A'
                          , 'A'
                          , V_DIVISION_ID
                          , V_FROM_SITE
                          , V_TITLE
                          , P_USER_ID
                          , P_USER_DEPT_ID
                          , V_CREATE_DATE
                          , P_USER_ID
                          , P_USER_DEPT_ID
                          , V_CREATE_DATE
                            /* [C20200630-000480] : Shipment Plan (IT& Mobile) 화면에서 SSP Planner 가 Data를 수정 할경우 Change reason / reason detail Tap을 화면상에 보여주지 않고, Data상으로 T07: 외부 요인으로 Default 설정 필요. */
                            /* 요청에 따라 CHANGE_REASON_CODE, CHANGE_REASON_DETAIL 을 Default 'T07' 로 설정 */
                          , 'T07'
                          , 'T07'
                          , NULL
                          , 'Y'
                          , P_USER_ID
                          , V_CREATE_DATE
                          , P_USER_ID
                          , V_CREATE_DATE
                          , V_ELECTRODE_YN
                          , V_ELECTRODE_TYPE
                          , V_ORIGIN_FROM_DIVISION_ID
                          , V_ORIGION_TO_DIVISION_ID
                           );

                    /* Request_No값 각기(단일) 생성 */
                    V_CHK := 1;

                END IF;

                IF V_SHIPMENT_QTY IS NULL
                THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL
                THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅 */
                IF V_SHIPMENT_DATE   IS NOT NULL
                   AND LENGTH(RTRIM(V_SHIPMENT_DATE)) = 8
                   AND V_NEW_CUSTOMER_LT IS NOT NULL
                   AND LENGTH(RTRIM(V_NEW_CUSTOMER_LT)) > 0
                THEN
                    V_NEW_ETD_DATE := V_SHIPMENT_DATE;
                END IF;

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(P_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                       (CHANGE_REQ_NO
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
                      , ATTRIBUTE2
                       )
                SELECT V_MAX_REQ_NO
                     , CONFIRM_ID
                     , 'N'
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
                     , V_SHIPMENT_DATE
                     , TO_NUMBER(V_SHIPMENT_QTY)
                     , V_NEW_BOD_ID_TEMP
                     , TO_NUMBER(V_NEW_ROUTE_ID_TEMP)
                     , V_NEW_ETD_DATE
                     , V_NEW_ETA_DATE
                     , V_NEW_INCOTERMS
                     , V_NEW_TRANSPORT_MODE
                     , V_NEW_D_CONTRY
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
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
                     , 'Y'
                     , 'N'
                     , P_USER_ID
                     , V_CREATE_DATE
                     , P_USER_ID
                     , V_CREATE_DATE
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , REQUESTOR
                     , 'A'
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

            END IF;  /* V_EDIT_MAIN = 'Y' End */

        END LOOP;    /* While End */

        IF V_BOD_NOT_FOUND = 'Y'
        THEN

            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            COMMIT;

            OPEN O_RC1 FOR SELECT 'X'  AS RESULT_CODE
                                , NULL AS REQUEST_NO
                             FROM DUAL;
            OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                             FROM DUAL
                            WHERE 1 = 0;

            RETURN;

        END IF;

        /* ERP전송 Table(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN) Insert */
        /* 출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정 */
        /* PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH 는 Oracle 미이관(2026.09.22 기준) */
        /* PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH('C', V_MAX_REQ_NO); */

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S'          AS RESULT_CODE
                            , V_MAX_REQ_NO AS REQUEST_NO
                         FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                         FROM DUAL
                        WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_DRAFT;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE
                             FROM DUAL;
            OPEN O_RC2 FOR SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                             FROM DUAL;

    END P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING;

    /* ============================================================
       P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER
       AS-IS SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER
       ※ '^' 로 이어 붙인 여러 행을 SCM_ARR_SPL_VAL 로 잘라 한 행씩 처리한다(AS-IS 동일).
       ※ BOD 조회(SELECT TOP 1 … ORDER BY PRIORITY)는 인라인 뷰 + ROWNUM 으로 옮긴다.
          0 행이면 AS-IS 처럼 앞 행 값이 남는다(AS-IS 는 루프마다 초기화하지 않는다).
       ※ 저장 시작에 SAVEPOINT 를 두어 오류('F') 시 앞 행 저장분까지 되돌린다.
          (AS-IS 는 트랜잭션이 없어 앞 행 저장분이 남고, 오류 시 CATCH 에서 COMMIT 한다)
       ※ AS-IS 가 부르는 ERP 전송 프로시저는 Oracle 에 없다(2026.09.22 기준) — 호출 자리를 주석으로 남긴다.
          PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER
       ※ Packer 는 BOD ITEM 을 사이트 접미사(PACKER_ITEM_ID_SUFFIX)로 12번째 자리를 바꿔 맞춘다(AS-IS 동일).
          품목 길이가 12 미만이면 원래 품목을 쓴다(AS-IS STUFF 가 NULL 을 돌려주는 자리).
       ============================================================ */
    PROCEDURE P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER
    (
        P_ACTIVE_FLAG               IN  VARCHAR2,
        P_DIVISION_ID               IN  VARCHAR2,
        P_CONFIRM_ID                IN  VARCHAR2,
        P_SHIPMENT_QTY              IN  VARCHAR2,
        P_SHIPMENT_DATE             IN  VARCHAR2,
        P_FROM_SITE                 IN  VARCHAR2,
        P_NEW_BOD_ID                IN  VARCHAR2,
        P_NEW_ROUTE_ID              IN  VARCHAR2,
        P_NEW_ETD_DATE              IN  VARCHAR2,
        P_NEW_ETA_DATE              IN  VARCHAR2,
        P_NEW_INCOTERMS             IN  VARCHAR2,
        P_NEW_TRANSPORT_MODE        IN  VARCHAR2,
        P_NEW_D_CONTRY              IN  VARCHAR2,
        P_NEW_D_PORT_CODE           IN  VARCHAR2,
        P_NEW_A_COUNTRY             IN  VARCHAR2,
        P_NEW_A_PORT_CODE           IN  VARCHAR2,
        P_NEW_CUSTOMER_LT           IN  VARCHAR2,
        P_NEW_TO_COUNTRY            IN  VARCHAR2,
        P_NEW_TO_CITY               IN  VARCHAR2,
        P_EDIT_MAIN                 IN  VARCHAR2,
        P_EDIT_REMARK               IN  VARCHAR2,
        P_USER_ID                   IN  VARCHAR2,
        P_USER_DEPT_ID              IN  VARCHAR2,
        P_ELECTRODE_YN              IN  VARCHAR2 DEFAULT '',
        P_ELECTRODE_TYPE            IN  VARCHAR2 DEFAULT '',
        P_ORIGIN_FROM_DIVISION_ID   IN  VARCHAR2 DEFAULT '',
        P_ORIGION_TO_DIVISION_ID    IN  VARCHAR2 DEFAULT '',
        P_REMARKS                   IN  VARCHAR2,
        P_REMARKS2                  IN  VARCHAR2,
        P_REMARKS3                  IN  VARCHAR2,
        P_CHANGE_REASON_CODE        IN  VARCHAR2,
        P_CHANGE_REASON_DETAIL      IN  VARCHAR2,
        P_TITLE                     IN  VARCHAR2,
        P_PROGRAM_ID                IN  VARCHAR2,
        P_SHIPTO_CODE               IN  VARCHAR2,
        O_RC1                       OUT SYS_REFCURSOR,
        O_RC2                       OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER
         * Description  : Shipment Plan Change 작성중 저장
         * 호출         : SSP0015
         * 관련 Table   : SSP_ANL_SHIP_CONFIRM_CHG_REQ, SSP_ANL_SHIP_CONFIRM_CHG_REQ_de
         * 관련 프로시저 : PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH(XIF_ERP_SHIP_PLAN_CONFIRM_S_SN - ERP 관련 Table)
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2021/09/22   KIMYONGHO      최초작성
         * 2022/01/04   KIMYONGHO      ITEM 코드 11자리까지 동일하면 유효한 BOD ITEM
         * 2026.09.22                  MSSQL -> Oracle 변환
         */
        V_RECV_ACTIVE_FLAG          VARCHAR2(4000 CHAR);
        V_MAX_REQ_NO                VARCHAR2(40 CHAR);
        V_ACTIVE_FLAG               VARCHAR2(4000 CHAR);
        V_DIVISION_ID               VARCHAR2(4000 CHAR);
        V_CONFIRM_ID                VARCHAR2(4000 CHAR);
        V_SHIPMENT_QTY              VARCHAR2(4000 CHAR);
        V_SHIPMENT_DATE             VARCHAR2(4000 CHAR);
        V_FROM_SITE                 VARCHAR2(4000 CHAR);
        V_TO_SITE                   VARCHAR2(4000 CHAR);
        V_ITEM_ID                   VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID                VARCHAR2(4000 CHAR);
        V_NEW_ETD_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ETA_DATE              VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS             VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE        VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY              VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY             VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE           VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT           VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY            VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY               VARCHAR2(4000 CHAR);
        V_EDIT_MAIN                 VARCHAR2(4000 CHAR);
        V_EDIT_REMARK               VARCHAR2(4000 CHAR);
        V_CREATE_DATE               DATE;
        V_CHK                       NUMBER := 0;
        V_TITLE                     VARCHAR2(4000 CHAR);
        V_ELECTRODE_YN              VARCHAR2(4000 CHAR);
        V_ELECTRODE_TYPE            VARCHAR2(4000 CHAR);
        V_ORIGIN_FROM_DIVISION_ID   VARCHAR2(4000 CHAR);
        V_ORIGION_TO_DIVISION_ID    VARCHAR2(4000 CHAR);
        V_REMARKS                   VARCHAR2(4000 CHAR);
        V_REMARKS2                  VARCHAR2(4000 CHAR);
        V_REMARKS3                  VARCHAR2(4000 CHAR);
        V_CHANGE_REASON_CODE        VARCHAR2(4000 CHAR);
        V_CHANGE_REASON_DETAIL      VARCHAR2(4000 CHAR);
        V_SHIPTO_CODE               VARCHAR2(4000 CHAR);

        V_DIVISION_ID_TEMP          VARCHAR2(4000 CHAR);
        V_NEW_BOD_ID_TEMP           VARCHAR2(4000 CHAR);
        V_FROM_SITE_TEMP            VARCHAR2(4000 CHAR);
        V_TO_SITE_TEMP              VARCHAR2(4000 CHAR);
        V_NEW_INCOTERMS_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_TRANSPORT_MODE_TEMP   VARCHAR2(4000 CHAR);
        V_NEW_ROUTE_ID_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_CONTRY_TEMP         VARCHAR2(4000 CHAR);
        V_NEW_D_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_A_COUNTRY_TEMP        VARCHAR2(4000 CHAR);
        V_NEW_A_PORT_CODE_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_CUSTOMER_LT_TEMP      VARCHAR2(4000 CHAR);
        V_NEW_TO_COUNTRY_TEMP       VARCHAR2(4000 CHAR);
        V_NEW_TO_CITY_TEMP          VARCHAR2(4000 CHAR);

        /* LOG 용 변수 설정 */
        V_PROGRAM_NAME              VARCHAR2(150 CHAR) := 'SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER';
        V_LOG_TYPE                  VARCHAR2(30 CHAR);
        N_LOG_COUNT                 NUMBER := 0;
        V_LOG_MESSAGE               VARCHAR2(1000 CHAR);
        V_DESCRIPTION               VARCHAR2(500 CHAR);
        D_EVENT_DATE                DATE;

        V_DELIMITER                 VARCHAR2(1 CHAR) := '^';
        V_MAX_LOOP_CNT              NUMBER := 0;
        V_MST_LOOP_CNT              NUMBER := 0;

        V_BOD_NOT_FOUND             VARCHAR2(1 CHAR) := 'N';
        V_ERR_CODE                  NUMBER;
        V_ERR_MESSAGE               VARCHAR2(4000 CHAR);
    BEGIN

        SAVEPOINT SP_SSP0015_SAVE_DRAFT_PK;

        V_RECV_ACTIVE_FLAG := P_ACTIVE_FLAG;
        V_CREATE_DATE      := SYSDATE;

        /* 시작 LOG */
        V_LOG_TYPE    := 'START';
        V_LOG_MESSAGE := '########## Start of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        V_MAX_LOOP_CNT := TO_NUMBER(SCM_ARR_SPL_CNT(P_ACTIVE_FLAG, V_DELIMITER));

        WHILE LENGTH(RTRIM(V_RECV_ACTIVE_FLAG)) > 0
          AND V_MST_LOOP_CNT < V_MAX_LOOP_CNT
        LOOP

            V_MST_LOOP_CNT := V_MST_LOOP_CNT + 1;

            /* 각 컬럼들에 대한 스플릿처리로직 스타트 */
            V_ACTIVE_FLAG             := SCM_ARR_SPL_VAL(P_ACTIVE_FLAG,             V_DELIMITER, V_MST_LOOP_CNT);
            V_DIVISION_ID             := SCM_ARR_SPL_VAL(P_DIVISION_ID,             V_DELIMITER, V_MST_LOOP_CNT);
            V_CONFIRM_ID              := SCM_ARR_SPL_VAL(P_CONFIRM_ID,              V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_QTY            := SCM_ARR_SPL_VAL(P_SHIPMENT_QTY,            V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPMENT_DATE           := SCM_ARR_SPL_VAL(P_SHIPMENT_DATE,           V_DELIMITER, V_MST_LOOP_CNT);
            V_FROM_SITE               := SCM_ARR_SPL_VAL(P_FROM_SITE,               V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_BOD_ID              := SCM_ARR_SPL_VAL(P_NEW_BOD_ID,              V_DELIMITER, V_MST_LOOP_CNT);
            V_TITLE                   := 'Change on ' || SCM_ARR_SPL_VAL(P_TITLE,   V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETD_DATE            := SCM_ARR_SPL_VAL(P_NEW_ETD_DATE,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ETA_DATE            := SCM_ARR_SPL_VAL(P_NEW_ETA_DATE,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_ROUTE_ID            := SCM_ARR_SPL_VAL(P_NEW_ROUTE_ID,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_INCOTERMS           := SCM_ARR_SPL_VAL(P_NEW_INCOTERMS,           V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TRANSPORT_MODE      := SCM_ARR_SPL_VAL(P_NEW_TRANSPORT_MODE,      V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_CONTRY            := SCM_ARR_SPL_VAL(P_NEW_D_CONTRY,            V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_D_PORT_CODE         := SCM_ARR_SPL_VAL(P_NEW_D_PORT_CODE,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_COUNTRY           := SCM_ARR_SPL_VAL(P_NEW_A_COUNTRY,           V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_A_PORT_CODE         := SCM_ARR_SPL_VAL(P_NEW_A_PORT_CODE,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_CUSTOMER_LT         := SCM_ARR_SPL_VAL(P_NEW_CUSTOMER_LT,         V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_COUNTRY          := SCM_ARR_SPL_VAL(P_NEW_TO_COUNTRY,          V_DELIMITER, V_MST_LOOP_CNT);
            V_NEW_TO_CITY             := SCM_ARR_SPL_VAL(P_NEW_TO_CITY,             V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_MAIN               := SCM_ARR_SPL_VAL(P_EDIT_MAIN,               V_DELIMITER, V_MST_LOOP_CNT);
            V_EDIT_REMARK             := SCM_ARR_SPL_VAL(P_EDIT_REMARK,             V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_YN            := SCM_ARR_SPL_VAL(P_ELECTRODE_YN,            V_DELIMITER, V_MST_LOOP_CNT);
            V_ELECTRODE_TYPE          := SCM_ARR_SPL_VAL(P_ELECTRODE_TYPE,          V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGIN_FROM_DIVISION_ID := SCM_ARR_SPL_VAL(P_ORIGIN_FROM_DIVISION_ID, V_DELIMITER, V_MST_LOOP_CNT);
            V_ORIGION_TO_DIVISION_ID  := SCM_ARR_SPL_VAL(P_ORIGION_TO_DIVISION_ID,  V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS                 := SCM_ARR_SPL_VAL(P_REMARKS,                 V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS2                := SCM_ARR_SPL_VAL(P_REMARKS2,                V_DELIMITER, V_MST_LOOP_CNT);
            V_REMARKS3                := SCM_ARR_SPL_VAL(P_REMARKS3,                V_DELIMITER, V_MST_LOOP_CNT);
            V_CHANGE_REASON_CODE      := SCM_ARR_SPL_VAL(P_CHANGE_REASON_CODE,      V_DELIMITER, V_MST_LOOP_CNT);
            V_CHANGE_REASON_DETAIL    := SCM_ARR_SPL_VAL(P_CHANGE_REASON_DETAIL,    V_DELIMITER, V_MST_LOOP_CNT);
            V_SHIPTO_CODE             := SCM_ARR_SPL_VAL(P_SHIPTO_CODE,             V_DELIMITER, V_MST_LOOP_CNT);

            IF V_CHANGE_REASON_CODE IS NULL
            THEN
                V_CHANGE_REASON_CODE := 'T07';
            END IF;

            IF V_CHANGE_REASON_DETAIL IS NULL
            THEN
                V_CHANGE_REASON_DETAIL := NULL;
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
                    NULL;
            END;

            BEGIN
                SELECT IA.DIVISION_ID
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
                  INTO V_DIVISION_ID_TEMP
                     , V_NEW_BOD_ID_TEMP
                     , V_FROM_SITE_TEMP
                     , V_TO_SITE_TEMP
                     , V_NEW_INCOTERMS_TEMP
                     , V_NEW_TRANSPORT_MODE_TEMP
                     , V_NEW_ROUTE_ID_TEMP
                     , V_NEW_D_CONTRY_TEMP
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , V_NEW_CUSTOMER_LT_TEMP
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
                  FROM (SELECT A.DIVISION_ID
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
                             , A.TO_COUNTRY
                             , A.TO_CITY
                          FROM (SELECT DISTINCT XA.DIVISION_ID
                                     , XA.BOD_ID
                                     , XA.FROM_SITE
                                     , XA.TO_SITE
                                     , XA.SSP_INCOTERMS
                                     , XA.TRANSPORT_MODE
                                     , XA.ROUTE_ID
                                     , XA.D_COUNTRY
                                     , XA.D_PORT_CODE
                                     , XA.A_COUNTRY
                                     , XA.A_PORT_CODE
                                     , XA.LT_TOTAL
                                     , XA.LT_TOTAL_ORIGIN
                                     , XA.TO_COUNTRY
                                     , XA.TO_CITY
                                     , XA.PRIORITY
                                     , XA.BOD_VALID_YN
                                  FROM SCP_MST_BOD_N_V XA
                                 WHERE XA.DIVISION_ID    = V_DIVISION_ID
                                   AND XA.FROM_SITE      = V_FROM_SITE
                                   AND XA.TO_SITE        = V_TO_SITE
                                   AND XA.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                                   AND XA.SSP_INCOTERMS  = V_NEW_INCOTERMS
                                   AND XA.BOD_VALID_YN   = 'Y'
                                   AND XA.FROM_YYYYMMDD <= V_SHIPMENT_DATE
                                   AND XA.TO_YYYYMMDD   >= V_SHIPMENT_DATE
                               ) A
                             , (SELECT DISTINCT SA.DIVISION_ID
                                     , SB.FROM_SITE
                                     , CASE WHEN TRIM(SC.PACKER_ITEM_ID_SUFFIX) IS NULL
                                            THEN SA.ITEM_ID
                                            ELSE NVL(CASE WHEN LENGTH(SA.ITEM_ID) >= 12
                                                          THEN SUBSTR(SA.ITEM_ID, 1, 11) || SC.PACKER_ITEM_ID_SUFFIX || SUBSTR(SA.ITEM_ID, 13)
                                                     END, SA.ITEM_ID)
                                       END AS ITEM_ID
                                     , SA.BOD_ID
                                  FROM SCP_MST_BOD_ITEM SA
                                     , SCP_MST_BOD_N_V SB
                                     , SCM_MST_SITE SC
                                 WHERE SA.DIVISION_ID = SB.DIVISION_ID
                                   AND SA.BOD_ID      = SB.BOD_ID
                                   AND SC.DIVISION_ID = SB.DIVISION_ID
                                   AND SC.SCM_SITE_ID = SB.FROM_SITE
                                   AND SC.OSP_YN      = 'Y'
                                   AND SA.DIVISION_ID = V_DIVISION_ID
                                   AND CASE WHEN TRIM(SC.PACKER_ITEM_ID_SUFFIX) IS NULL
                                            THEN SA.ITEM_ID
                                            ELSE NVL(CASE WHEN LENGTH(SA.ITEM_ID) >= 12
                                                          THEN SUBSTR(SA.ITEM_ID, 1, 11) || SC.PACKER_ITEM_ID_SUFFIX || SUBSTR(SA.ITEM_ID, 13)
                                                     END, SA.ITEM_ID)
                                       END = V_ITEM_ID
                               ) B
                         WHERE B.DIVISION_ID    = A.DIVISION_ID
                           AND B.BOD_ID         = A.BOD_ID
                           AND A.DIVISION_ID    = V_DIVISION_ID
                           AND A.FROM_SITE      = V_FROM_SITE
                           AND A.TO_SITE        = V_TO_SITE
                           AND A.TRANSPORT_MODE = V_NEW_TRANSPORT_MODE
                           AND A.SSP_INCOTERMS  = V_NEW_INCOTERMS
                           AND A.BOD_VALID_YN   = 'Y'
                         ORDER BY A.PRIORITY
                       ) IA
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    NULL;   /* AS-IS TOP 1 이 0 행이면 앞 행 값이 그대로 남는다 */
            END;

            IF (   V_DIVISION_ID_TEMP        IS NULL
                OR V_NEW_BOD_ID_TEMP         IS NULL
                OR V_FROM_SITE_TEMP          IS NULL
                OR V_TO_SITE_TEMP            IS NULL
                OR V_NEW_INCOTERMS_TEMP      IS NULL
                OR V_NEW_TRANSPORT_MODE_TEMP IS NULL
                OR V_NEW_ROUTE_ID_TEMP       IS NULL
                OR V_NEW_D_CONTRY_TEMP       IS NULL
                OR V_NEW_D_PORT_CODE_TEMP    IS NULL
                OR V_NEW_A_COUNTRY_TEMP      IS NULL
                OR V_NEW_A_PORT_CODE_TEMP    IS NULL
                OR V_NEW_CUSTOMER_LT_TEMP    IS NULL
                OR V_NEW_TO_COUNTRY_TEMP     IS NULL
                OR V_NEW_TO_CITY_TEMP        IS NULL
               )
            THEN
                V_BOD_NOT_FOUND := 'Y';
                EXIT;
            END IF;

            IF V_EDIT_MAIN = 'Y'
            THEN

                IF V_CHK = 0
                THEN

                    V_MAX_REQ_NO := 'R' || TO_CHAR(V_CREATE_DATE, 'YYYYMMDD')
                                        || SUBSTR('000000' || TO_CHAR(SEQ1_SSP_ANL_SHIP_CHG_REQ_NO.NEXTVAL), -6);

                    INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ
                           (CHANGE_REQ_NO
                          , CHANGE_TYPE
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
                          , CREATED_BY
                          , CREATION_DATE
                          , LAST_UPDATED_BY
                          , LAST_UPDATE_DATE
                          , ELECTRODE_YN
                          , ELECTRODE_TYPE
                          , ORIGIN_FROM_DIVISION_ID
                          , ORIGIN_TO_DIVISION_ID
                           )
                    VALUES (V_MAX_REQ_NO
                          , 'A'
                          , 'A'
                          , V_DIVISION_ID
                          , V_FROM_SITE
                          , V_TITLE
                          , P_USER_ID
                          , P_USER_DEPT_ID
                          , V_CREATE_DATE
                          , P_USER_ID
                          , P_USER_DEPT_ID
                          , V_CREATE_DATE
                            /* [C20200630-000480] : Shipment Plan (IT& Mobile) 화면에서 SSP Planner 가 Data를 수정 할경우 Change reason / reason detail Tap을 화면상에 보여주지 않고, Data상으로 T07: 외부 요인으로 Default 설정 필요. */
                            /* 요청에 따라 CHANGE_REASON_CODE, CHANGE_REASON_DETAIL 을 Default 'T07' 로 설정 */
                          , 'T07'
                          , 'T07'
                          , NULL
                          , 'Y'
                          , P_USER_ID
                          , V_CREATE_DATE
                          , P_USER_ID
                          , V_CREATE_DATE
                          , V_ELECTRODE_YN
                          , V_ELECTRODE_TYPE
                          , V_ORIGIN_FROM_DIVISION_ID
                          , V_ORIGION_TO_DIVISION_ID
                           );

                    /* Request_No값 각기(단일) 생성 */
                    V_CHK := 1;

                END IF;

                IF V_SHIPMENT_QTY IS NULL
                THEN
                    V_SHIPMENT_QTY := NULL;
                END IF;

                IF V_SHIPMENT_DATE IS NULL
                THEN
                    V_SHIPMENT_DATE := '';
                END IF;

                V_NEW_ETD_DATE  := REPLACE(SUBSTR(V_NEW_ETD_DATE, 1, 10), '-', '');
                V_SHIPMENT_DATE := REPLACE(SUBSTR(V_SHIPMENT_DATE, 1, 10), '-', '');

                /* 2019.09.04 etd:shipdate, eta:etd+lt_day로 셋팅 */
                IF V_SHIPMENT_DATE   IS NOT NULL
                   AND LENGTH(RTRIM(V_SHIPMENT_DATE)) = 8
                   AND V_NEW_CUSTOMER_LT IS NOT NULL
                   AND LENGTH(RTRIM(V_NEW_CUSTOMER_LT)) > 0
                THEN
                    V_NEW_ETD_DATE := V_SHIPMENT_DATE;
                END IF;

                /* 2019.10.29 출발일 기준 항차를 고려한 ETA_DATE 계산 */
                V_NEW_ETA_DATE := FN_GET_SSP_ETA_DATE(P_DIVISION_ID, V_NEW_BOD_ID_TEMP, V_SHIPMENT_DATE);

                INSERT INTO SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                       (CHANGE_REQ_NO
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
                       )
                SELECT V_MAX_REQ_NO
                     , CONFIRM_ID
                     , 'N'
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
                     , V_SHIPMENT_DATE
                     , TO_NUMBER(V_SHIPMENT_QTY)
                     , V_NEW_BOD_ID_TEMP
                     , TO_NUMBER(V_NEW_ROUTE_ID_TEMP)
                     , V_NEW_ETD_DATE
                     , V_NEW_ETA_DATE
                     , V_NEW_INCOTERMS
                     , V_NEW_TRANSPORT_MODE
                     , V_NEW_D_CONTRY
                     , V_NEW_D_PORT_CODE_TEMP
                     , V_NEW_A_COUNTRY_TEMP
                     , V_NEW_A_PORT_CODE_TEMP
                     , TO_NUMBER(V_NEW_CUSTOMER_LT_TEMP)
                     , V_NEW_TO_COUNTRY_TEMP
                     , V_NEW_TO_CITY_TEMP
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
                     , V_SHIPTO_CODE
                     , TO_SITE_COMPANY_ID
                     , ERP_SO_NO
                     , ERP_SO_ITEM_NO
                     , ERP_DO_NO
                     , ERP_STATUS
                     , 'Y'
                     , 'N'
                     , P_USER_ID
                     , V_CREATE_DATE
                     , P_USER_ID
                     , V_CREATE_DATE
                     , ELECTRODE_YN
                     , ELECTRODE_TYPE
                     , ORIGIN_FROM_DIVISION_ID
                     , ORIGIN_TO_DIVISION_ID
                     , V_REMARKS
                     , V_REMARKS2
                     , V_REMARKS3
                     , REQUESTOR
                  FROM SSP_ANL_SHIP_CONFIRM
                 WHERE CONFIRM_ID = V_CONFIRM_ID;

            END IF;  /* V_EDIT_MAIN = 'Y' End */

        END LOOP;    /* While End */

        IF V_BOD_NOT_FOUND = 'Y'
        THEN

            V_LOG_TYPE    := 'END';
            V_LOG_MESSAGE := '########## END of procedure ##########';
            V_DESCRIPTION := '';
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

            COMMIT;

            OPEN O_RC1 FOR SELECT 'X'  AS RESULT_CODE
                                , NULL AS REQUEST_NO
                             FROM DUAL;
            OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                             FROM DUAL
                            WHERE 1 = 0;

            RETURN;

        END IF;

        /* ERP전송 Table(XIF_ERP_PACK_SHIP_PLAN_S_SN) Insert */
        /* 출하확정변경시 ERP 전송 이터 테이블 저장 B: 변경확정 */
        /* PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER 는 Oracle 미이관(2026.09.22 기준) */
        /* PR_SSP_ANL_SHIP_CONFIRM_CHG_BATCH_PACKER('B', V_MAX_REQ_NO); */

        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END of procedure ##########';
        V_DESCRIPTION := '';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH_CALL_TRAN(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);

        COMMIT;

        /* 결과코드, 결과 카운트 반환 */
        OPEN O_RC1 FOR SELECT 'S'          AS RESULT_CODE
                            , V_MAX_REQ_NO AS REQUEST_NO
                         FROM DUAL;
        OPEN O_RC2 FOR SELECT NULL AS ERR_MESSAGE
                         FROM DUAL
                        WHERE 1 = 0;

    EXCEPTION
        WHEN OTHERS THEN

            V_ERR_CODE    := SQLCODE;
            V_ERR_MESSAGE := SQLERRM;

            ROLLBACK TO SP_SSP0015_SAVE_DRAFT_PK;

            INSERT INTO SCM_SYS_LOG_BATCH
                   (PROGRAM_NAME, LOG_TYPE, LOG_COUNT, LOG_MESSAGE, DESCRIPTION
                  , EVENT_DATE, CREATION_DATE, CREATED_BY, LAST_UPDATE_DATE, LAST_UPDATED_BY)
            VALUES (V_PROGRAM_NAME, 'ERROR', NULL, V_ERR_MESSAGE, NULL
                  , SYSDATE, SYSDATE, V_PROGRAM_NAME, SYSDATE, V_PROGRAM_NAME);
            COMMIT;

            /* error코드, errror 메시지 반환 */
            OPEN O_RC1 FOR SELECT 'F' AS RESULT_CODE
                             FROM DUAL;
            OPEN O_RC2 FOR SELECT '[' || TO_CHAR(V_ERR_CODE) || ']' || V_ERR_MESSAGE AS ERR_MESSAGE
                             FROM DUAL;

    END P_SSP0015_SAVE_SHIPMENT_REQUEST_DRAFTING_PACKER;

    /* ============================================================
       P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER
       AS-IS SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER
       ※ AS-IS 는 문자열을 조립해 EXEC 로 실행하지만 결과는 고정 조회다.
          조립되는 조건 갈래가 정해져 있으므로 정적 SQL 로 옮긴다.
       ※ P_REAL_FLAG 값에 따라 결과 칸 구성이 다르다(AS-IS 동일).
          'Y' : 출하확정(SSP_ANL_SHIP_CONFIRM) + 요청(SSP_ANL_SHIP_REQ_P) — 68 칸
          그 외 : 계획(SSP_ANL_SHIP_PLAN_P) 요청분 + 확정분 — 63 칸
       ※ AS-IS FN_GET_IN_STR 로 만든 IN 목록은 FN_STRING_SPLIT 로 옮긴다.
       ※ 숫자 칸(NEW_ROUTE_ID · NEW_CUSTOMER_LT · NEW_LT_DAY)은 AS-IS 에서 UNION ALL 이 숫자로 통일되어
          반대편 '-' 가 0 으로 바뀐다. 같은 값이 되게 숫자로 두고 반대편을 0 으로 맞춘다.
       ※ 고객 조인은 뒤 공백을 떼고 맞춘다 — 출하확정 원장 TO_SITE_SHIPTO_CODE 에 뒤 공백이 있고
          (2026.09.22 기준 사업부 40 에 40건) AS-IS 는 뒤 공백을 무시해 이어지지만 Oracle 은 끊긴다.
       ============================================================ */
    PROCEDURE P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER
    (
        P_DIVISION_ID           IN  VARCHAR2,
        P_FROM_SITE             IN  VARCHAR2,
        P_ITEM_ID               IN  VARCHAR2,
        P_FROM_YYYYMMDD         IN  VARCHAR2,
        P_TO_YYYYMMDD           IN  VARCHAR2,
        P_PLAN_START_YYYYMMDD   IN  VARCHAR2,
        P_LANGUAGE              IN  VARCHAR2 DEFAULT 'KO',
        P_USER_ID               IN  VARCHAR2,
        P_MYMODELCHK            IN  VARCHAR2 DEFAULT 'N',
        P_REQUESTOR             IN  VARCHAR2,
        P_PARTLEADERCHK         IN  VARCHAR2,
        P_TEAMLEADERCHK         IN  VARCHAR2,
        P_SEARCH_YN             IN  VARCHAR2,
        P_NONCHK                IN  VARCHAR2 DEFAULT 'N',
        P_DEBUG_MODE            IN  VARCHAR2 DEFAULT 'T',
        P_REAL_FLAG             IN  VARCHAR2 DEFAULT 'N',
        P_DELEGATEECHK          IN  VARCHAR2,
        O_RC1                   OUT SYS_REFCURSOR
    )
    IS
        /*
         * Program ID   : PKG_SSP0015.P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER
         * Description  :
         * Program History
         *===================================================================================================
         *   Date       In Charge      Description
         *===================================================================================================
         * 2020-11-13   KIMYONGHO 	   신규추가
         * 2024-10-01   KHJ            NERP_SSP
         * 2026.09.22                  MSSQL -> Oracle 전환 (동적 SQL -> 정적 SQL)
         * 2026.10.07                  AJS 조회조건 Model/Nickname : 코드 또는 닉네임 부분일치·대소문자 무시
         */
        V_ITEM_TAB              T_STR_TAB := T_STR_TAB();   /* 2026.10.07 AJS Model/Nickname 검색 : 코드 또는 닉네임이 부분일치하는 품목 */
    BEGIN
        /* 2026.10.07 AJS Model/Nickname 검색 (START) : 입력값(쉼표 구분)이 코드 또는 닉네임에 부분일치(대소문자 무시)하는 품목을 먼저 고른다
           조회 문장 안에서 분리 함수를 행마다 부르지 않도록 문장 밖에서 한 번 판정 · 입력 코드 자체도 담아 기존 정확일치 품목 유지 · 닉네임 출처 = SCM_MST_ITEM_SN */
        IF P_ITEM_ID IS NOT NULL AND UPPER(P_ITEM_ID) <> 'ALL' THEN
            SELECT IA.ITEM_ID
              BULK COLLECT INTO V_ITEM_TAB
              FROM (SELECT SA.COLUMN_VALUE AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SA
                     WHERE SA.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT UPPER(SB.COLUMN_VALUE) AS ITEM_ID
                      FROM TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SB
                     WHERE SB.COLUMN_VALUE IS NOT NULL
                    UNION
                    SELECT XA.ITEM_ID
                      FROM SCM_MST_ITEM_SN XA
                         , TABLE(STRING_SPLIT(P_ITEM_ID, ',')) SC
                     WHERE SC.COLUMN_VALUE IS NOT NULL
                       AND (   UPPER(XA.ITEM_ID)   LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%'
                            OR UPPER(XA.NICK_NAME) LIKE '%' || UPPER(SC.COLUMN_VALUE) || '%')) IA;
        END IF;
        /* 2026.10.07 AJS Model/Nickname 검색 (END) */

        IF P_REAL_FLAG = 'Y' THEN

            OPEN O_RC1 FOR
            SELECT AA.*
              FROM (
                    SELECT A.DIVISION_ID
                         , A.ERP_SO_NO
                         , A.SHIPMENT_STATUS
                         , F.SOLDTO_CUSTOMER                 AS PROJECT_CODE
                         , FN_GET_PROJECT_NAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, F.SOLDTO_CUSTOMER) AS PROJECT_NAME
                         , A.FCST_TYPE
                         , A.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END, A.ITEM_ID) AS NICK_NAME
                         , CASE WHEN REGEXP_LIKE(A.YYYYMMDD, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                         , A.BEFORE_QTY                      AS BEFORE_QTY
                         , TRUNC(A.QTY)                      AS SHIPMENT_CONFIRM_QTY
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
                         , TC.SHIPTO_DESCRIPTION             AS SHIPTO_DESCRIPTION
                         , A.BOD_ID
                         , B.SSP_INCOTERMS                   AS INCOTERMS
                         , B.TRANSPORT_MODE
                         , B.LT_TOTAL                        AS LT_DAY
                         , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                         , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                         , CASE WHEN B.TRANSPORT_MODE = 'TRK' THEN '-'
                                ELSE (SELECT CASE WHEN REGEXP_LIKE(SA.V, '^[0-9]{8}$')
                                                  THEN TO_CHAR(TO_DATE(SA.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                        FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(A.DIVISION_ID, A.BOD_ID, A.YYYYMMDD) AS V FROM DUAL) SA)
                           END                               AS EXPECTED_SHIPPING_DATE
                         , A.CONFIRM_ID
                         /* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USERNAME ELSE U.USERNAME_E END) || '(' || A.LAST_UPDATED_BY || ')'
--                         , CASE WHEN U.USERNAME IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U.USER_NM ELSE U.USER_ENG_NM END) || '(' || A.LAST_UPDATED_BY || ')'
                           END                               AS UPDATED_BY
                         , CASE WHEN U.USER_NM IS NOT NULL THEN A.LAST_UPDATE_DATE END AS UPDATED_DATE
                         /* 2026.09.30 AJS 수정 (END) */
                         , CASE WHEN NVL(TE.ATTRIBUTE5, '-') = '-' THEN '-' ELSE 'C' END AS ERP_STATUS
                         , A.CHANGE_TYPE
                           /* AS-IS 는 UNION ALL 이 숫자로 통일되어 반대편 '-' 가 0 으로 바뀐다. 같은 값이 되게 숫자로 둔다. */
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
                         , CASE WHEN REGEXP_LIKE(A.ETA_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_ETA
                         , CASE WHEN REGEXP_LIKE(A.ETD_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_ETD
                         , B.LT_TOTAL                        AS NEW_LT_DAY
                         , B.TRANSPORT_MODE                  AS NEW_TRANSPORT_MODE
                         , CASE WHEN REGEXP_LIKE(A.YYYYMMDD, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(A.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS NEW_SHIPMENT_DATE
                         , 'N'                               AS EDIT_REMARKS
                         , 'N'                               AS EDIT_MAIN
                         , NVL(A.CHECK_NEED_YN, 'N')         AS CHECK_NEED_YN
                         , NVL(CASE WHEN A.DIVISION_ID = '40'
                                    THEN CASE WHEN A.PROJECT_CODE IS NOT NULL AND A.PROJECT_CODE != '-' THEN A.PROJECT_CODE ELSE G.PROJECT_CODE END
                                    WHEN A.DIVISION_ID = 'EE' AND A.ORIGIN_TO_DIVISION_ID = '40'
                                    THEN G.PROJECT_CODE
                                    ELSE F.END_CUSTOMER
                               END, '/')                     AS END_CUSTOMER
                         , A.ELECTRODE_YN
                         , A.ELECTRODE_TYPE
                         , A.ORIGIN_FROM_DIVISION_ID
                         , A.ORIGIN_TO_DIVISION_ID
                         , H.CHANGE_REQ_NO
                         /* 2026.09.30 AJS 수정 (START) */
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
--                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END) IS NULL THEN NULL
--                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USERNAME ELSE U3.USERNAME_E END) || '(' || A.REQUESTOR || ')'
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
                           END                               AS MODEL_USER
                         , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, ',', P_LANGUAGE) AS MTK_OWNER
                         , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) IS NULL THEN NULL
                                ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U3.USER_NM ELSE U3.USER_ENG_NM END) || '(' || A.REQUESTOR || ')'
                         /* 2026.09.30 AJS 수정 (END) */
                           END                               AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , NULL                              AS CHANGE_REASON_DETAIL
                         , TT1.ATTRIBUTE3                    AS RTF3
                         , TT1.ATTRIBUTE4                    AS RTF4
                         , TT1.ATTRIBUTE5                    AS RTF5
                         , TT1.ATTRIBUTE6                    AS RTF6
                         , A.ATTRIBUTE10                     AS ATTRIBUTE10
                      FROM SSP_ANL_SHIP_CONFIRM A
                         , SCM_MST_SITE MS
                         , SCP_MST_BOD_N_V B
                         , SCM_MST_SITE_CUSTOMER TD
                         , SCM_MST_CUSTOMER TC
                         , SCM_DNM_SCS_SHIP_RESULT TE
                         /* 2026.09.30 AJS 수정 (START) */
--                         , TB_FX_USER U
                         , SCM_ADM_USER_M U
                         /* 2026.09.30 AJS 수정 (END) */
                         , SCM_MST_SITE F
                         , (SELECT IA.DIVISION_ID
                                 , IA.PROJECT_CODE
                                 , IA.SCM_SITE_ID
                                 , IA.ITEM_ID
                              FROM (SELECT DIVISION_ID
                                         , PROJECT_CODE
                                         , SCM_SITE_ID
                                         , ITEM_ID
                                         , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY PROJECT_CODE) AS NUM
                                      FROM SCM_MST_SITE_ITEM
                                   ) IA
                             WHERE IA.NUM = 1
                           ) G
                         , (SELECT XA.CONFIRM_ID
                                 , XA.CHANGE_REQ_NO
                              FROM (SELECT CONFIRM_ID
                                         , CHANGE_REQ_NO
                                         , ROW_NUMBER() OVER (PARTITION BY CONFIRM_ID ORDER BY CHANGE_REQ_NO DESC) AS NUM
                                      FROM SSP_ANL_SHIP_CONFIRM_CHG_REQ_DE
                                     WHERE VALID_YN = 'Y'
                                   ) XA
                             WHERE XA.NUM = 1
                           ) H
                         , SSP_MST_MODEL_USER MU
                         /* 2026.09.30 AJS 수정 (START) */
--                         , TB_FX_USER U2
--                         , TB_FX_USER U3
                         , SCM_ADM_USER_M U2
                         , SCM_ADM_USER_M U3
                         /* 2026.09.30 AJS 수정 (END) */
                         , SCM_MST_SITE_ITEM SI
                         , SSP_ANL_SHIP_CONFIRM_CHG_REQ T1
                         , SSP_ANL_SHIP_REQ_P TT1
                     WHERE MS.DIVISION_ID       = A.DIVISION_ID
                       AND MS.SCM_SITE_ID       = A.FROM_SITE
                       AND MS.SITE_TYPE         = 'PLANT'
                       AND MS.OPERATION_GROUP   = 'P'
                       AND MS.OSP_YN            = 'Y'
                       AND B.DIVISION_ID        = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_FROM_DIVISION_ID ELSE A.DIVISION_ID END
                       AND B.BOD_ID             = A.BOD_ID
                       AND TD.DIVISION_ID(+)    = A.DIVISION_ID
                       AND TD.SCM_SITE_ID(+)    = A.TO_SITE
                       AND RTRIM(TD.SHIPTO_CODE(+)) = RTRIM(A.TO_SITE_SHIPTO_CODE)
                       AND TD.VALID_YN(+)       = 'Y'
                       AND TD.REP_YN(+)         = 'Y'
                       AND TC.DIVISION_ID(+)    = A.DIVISION_ID
                       AND TC.SOLDTO_CODE(+)    = TD.SOLDTO_CODE
                       AND TC.SHIPTO_CODE(+)    = RTRIM(A.TO_SITE_SHIPTO_CODE)
                       AND TC.VALID_YN(+)       = 'Y'
                       AND TE.DIVISION_ID(+)    = A.DIVISION_ID
                       AND TE.SCM_SITE_ID(+)    = A.FROM_SITE
                       AND TE.PACK_MODEL_CODE(+) = A.ITEM_ID
                       AND TE.ATTRIBUTE5(+)     = A.CONFIRM_ID
                       /* 2026.09.30 AJS 수정 (START) */
--                       AND U.USERID(+)          = A.LAST_UPDATED_BY
--                       AND U.USEYN(+)           = 'Y'
                       AND U.USER_ID(+)         = A.LAST_UPDATED_BY
                       AND U.USE_YN(+)          = 'Y'
                       /* 2026.09.30 AJS 수정 (END) */
                       AND F.DIVISION_ID(+)     = A.ORIGIN_TO_DIVISION_ID
                       AND F.SCM_SITE_ID(+)     = A.TO_SITE
                       AND F.VALID_YN(+)        = 'Y'
                       AND G.DIVISION_ID(+)     = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND G.SCM_SITE_ID(+)     = A.TO_SITE
                       AND G.ITEM_ID(+)         = A.ITEM_ID
                       AND H.CONFIRM_ID(+)      = A.CONFIRM_ID
                       AND MU.DIVISION_ID(+)    = A.ORIGIN_FROM_DIVISION_ID
                       AND MU.FROM_SITE(+)      = A.FROM_SITE
                       AND MU.ITEM_ID(+)        = A.ITEM_ID
                       AND MU.VALID_YN(+)       = 'Y'
                       /* 2026.09.30 AJS 수정 (START) */
--                       AND U2.USERID(+)         = MU.USER_ID
--                       AND U2.USEYN(+)          = 'Y'
--                       AND U3.USERID(+)         = A.REQUESTOR
--                       AND U3.USEYN(+)          = 'Y'
                       AND U2.USER_ID(+)        = MU.USER_ID
                       AND U2.USE_YN(+)         = 'Y'
                       AND U3.USER_ID(+)        = A.REQUESTOR
                       AND U3.USE_YN(+)         = 'Y'
                       /* 2026.09.30 AJS 수정 (END) */
                       AND SI.DIVISION_ID(+)    = CASE WHEN A.DIVISION_ID = 'EE' THEN A.ORIGIN_TO_DIVISION_ID ELSE A.DIVISION_ID END
                       AND SI.SCM_SITE_ID(+)    = A.TO_SITE
                       AND SI.ITEM_ID(+)        = A.ITEM_ID
                       AND SI.PROJECT_CODE(+)   = G.PROJECT_CODE
                       AND T1.CHANGE_REQ_NO(+)  = H.CHANGE_REQ_NO
                       AND TT1.DIVISION_ID(+)   = A.DIVISION_ID
                       AND TT1.REQUEST_ID(+)    = A.CONFIRM_ID
                       AND A.DIVISION_ID        = '40'
                       AND (P_SEARCH_YN != 'Y'
                             OR ((P_NONCHK = 'Y' AND 1 = 1)
                                  OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                    UNION
                                                    SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                      FROM SSP_MST_DELEGATE
                                                     WHERE VALID_YN    = 'Y'
                                                       AND DELEGATEE_ID = P_USER_ID
                                                     GROUP BY USER_ID)
                                  OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                  OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                       AND A.YYYYMMDD          >= P_FROM_YYYYMMDD
                       AND A.YYYYMMDD          <= P_TO_YYYYMMDD
                       AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                             OR  UPPER(P_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                             OR A.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                       AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                             OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                           OR A.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                             OR A.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                       AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                             OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                             OR A.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                       AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                             /* 2026.09.30 AJS 수정 (START) */
--                             OR A.REQUESTOR IN (SELECT DISTINCT SA.USERID
--                                                  FROM TB_FX_USER SA
--                                                 WHERE SA.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                    OR SA.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                             OR A.REQUESTOR IN (SELECT DISTINCT SA.USER_ID
                                                  FROM SCM_ADM_USER_M SA
                                                 WHERE SA.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                    OR SA.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                             /* 2026.09.30 AJS 수정 (END) */
                       AND A.SHIPMENT_STATUS IS NOT NULL
                       AND A.QTY                > 0
                       AND A.CHANGE_TYPE       != 'N'
                       AND A.BIZ_TYPE          != 'E'
                    UNION ALL
                    SELECT T.DIVISION_ID
                         , T.ERP_SO_NO
                         , T.SHIPMENT_STATUS
                         , T.PROJECT_CODE
                         , T.PROJECT_NAME
                         , T.FCST_TYPE
                         , T.ITEM_ID
                         , T.NICK_NAME
                         , CASE WHEN REGEXP_LIKE(T.SHIPMENT_DATE, '^[0-9]{8}$')
                                THEN TO_CHAR(TO_DATE(T.SHIPMENT_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                         , 0                                 AS BEFORE_QTY
                         , T.QTY
                         , T.REMARKS
                         , T.REMARKS2
                         , T.REMARKS3
                         , T.FROM_SITE
                         , T.FROM_SITE_DESCRIPTION
                         , T.TO_SITE
                         , T.TO_SITE_DESCRIPTION
                         , T.TO_SITE_SOLDTO_CODE
                         , T.TO_SITE_SHIPTO_CODE
                         , T.SOLDTO_DESCRIPTION
                         , T.SHIPTO_DESCRIPTION
                         , T.BOD_ID
                         , T.INCOTERMS
                         , T.TRANSPORT_MODE
                         , T.LT_TOTAL
                         , T.ETD_DATE
                         , T.ETA_DATE
                         , T.EXPECTED_SHIPPING_DATE
                         , T.CONFIRM_ID
                         , T.LAST_UPDATED_BY
                         , T.LAST_UPDATE_DATE
                         , '-'                               AS ERP_STATUS
                         , '-'                               AS CHANGE_TYPE
                         , 0                                 AS NEW_ROUTE_ID
                         , '-'                               AS NEW_BOD_ID
                         , '-'                               AS NEW_INCOTERMS
                         , '-'                               AS NEW_D_COUNTRY
                         , '-'                               AS NEW_D_PORT_CODE
                         , '-'                               AS NEW_A_COUNTRY
                         , '-'                               AS NEW_A_PORT_CODE
                         , 0                                 AS NEW_CUSTOMER_LT
                         , '-'                               AS NEW_TO_COUNTRY
                         , '-'                               AS NEW_TO_CITY
                         , '-'                               AS NEW_ETA
                         , '-'                               AS NEW_ETD
                         , 0                                 AS NEW_LT_DAY
                         , '-'                               AS NEW_TRANSPORT_MODE
                         , '-'                               AS NEW_SHIPMENT_DATE
                         , '-'                               AS EDIT_REMARKS
                         , '-'                               AS EDIT_MAIN
                         , '-'                               AS CHECK_NEED_YN
                         , T.PROJECT_CODE                    AS END_CUSTOMER
                         , '-'                               AS ELECTRODE_YN
                         , '-'                               AS ELECTRODE_TYPE
                         , '-'                               AS ORIGIN_FROM_DIVISION_ID
                         , '-'                               AS ORIGIN_TO_DIVISION_ID
                         , '-'                               AS CHANGE_REQ_NO
                         , '-'                               AS MODEL_USER
                         , T.MTK_OWNER
                         , T.REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , '-'                               AS CHANGE_REASON_DETAIL
                         , T.RTF3
                         , T.RTF4
                         , T.RTF5
                         , T.RTF6
                         , '-'                               AS ATTRIBUTE10
                      FROM (SELECT TT0.DIVISION_ID
                                 , NULL                      AS ERP_SO_NO
                                 , 'P'                       AS SHIPMENT_STATUS
                                 , F.SOLDTO_CUSTOMER          AS PROJECT_CODE
                                 , TT0.ITEM_ID                AS ITEM_ID
                                 , FN_GET_ITEM_NICKNAME(TT0.DIVISION_ID, TT0.ITEM_ID) AS NICK_NAME
                                 , TT0.DIVISION_ID            AS ORIGIN_FROM_DIVISION_ID
                                 , TT0.DIVISION_ID            AS ORIGIN_TO_DIVISION_ID
                                 , TT1.FROM_SITE              AS FROM_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT1.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                                 , TT1.TO_SITE                AS TO_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT1.TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                                 , FN_GET_PROJECT_NAME(TT0.DIVISION_ID, F.SOLDTO_CUSTOMER) AS PROJECT_NAME
                                 , TT0.LAST_UPDATED_BY        AS REQUESTOR
                                 , TT0.QTY
                                 , TT0.YYYYMMDD               AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT1.INCOTERMS
                                 , TT1.TRANSPORT_MODE
                                 , TD.SOLDTO_CODE             AS TO_SITE_SOLDTO_CODE
                                 , TT0.SHIPTO_CODE            AS TO_SITE_SHIPTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT1.FROM_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                                 , TC.SHIPTO_DESCRIPTION      AS SHIPTO_DESCRIPTION
                                 , '-'                        AS REMARKS2
                                 , '-'                        AS REMARKS
                                 , '-'                        AS CHANGE_REQ_NO
                                 , '-'                        AS REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD_DATE
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD') + NVL(TT1.LT_TOTAL, 0), 'YYYY-MM-DD') END AS ETA_DATE
                                 , CASE WHEN TT1.TRANSPORT_MODE = 'TRK' THEN '-'
                                        ELSE (SELECT CASE WHEN REGEXP_LIKE(SB.V, '^[0-9]{8}$')
                                                          THEN TO_CHAR(TO_DATE(SB.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                                FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SB)
                                   END                        AS EXPECTED_SHIPPING_DATE
                                 , TT1.LT_TOTAL
                                 , TT0.LAST_UPDATED_BY
                                 , TT0.LAST_UPDATE_DATE
                                 , '-'                        AS CONFIRM_ID
                                 , TT0.FCST_TYPE              AS FCST_TYPE
                                 , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, ',', P_LANGUAGE) AS MTK_OWNER
                                 , CASE WHEN NVL(TT2.SHIP_FROZEN, 0) > 0
                                        THEN CASE WHEN REGEXP_LIKE(P_PLAN_START_YYYYMMDD, '^[0-9]{8}$')
                                                  THEN TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') + NVL(TT2.SHIP_FROZEN, 0), 'YYYYMMDD') END
                                        ELSE P_PLAN_START_YYYYMMDD
                                   END                        AS FROZEN_YYYYMMDD
                                 , TT0.ATTRIBUTE3             AS RTF3
                                 , TT0.ATTRIBUTE4             AS RTF4
                                 , TT0.ATTRIBUTE5             AS RTF5
                                 , TT0.ATTRIBUTE6             AS RTF6
                              FROM SSP_ANL_SHIP_REQ_P TT0
                                 , SCP_MST_BOD_N_V TT1
                                 , SCM_MST_SITE TT2
                                 , SCM_MST_SITE_CUSTOMER TD
                                 , SCM_MST_CUSTOMER TC
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER U3
                                 , SCM_ADM_USER_M U3
                                 /* 2026.09.30 AJS 수정 (END) */
                                 , SCM_MST_SITE F
                                 , SSP_MST_MODEL_USER MU
                                 , SCM_MST_SITE_ITEM SI
                             WHERE TT1.DIVISION_ID      = TT0.DIVISION_ID
                               AND TT1.BOD_ID           = TT0.BOD_ID
                               AND TT2.DIVISION_ID      = TT0.DIVISION_ID
                               AND TT2.SCM_SITE_ID      = TT1.FROM_SITE
                               AND TT2.SITE_TYPE        = 'PLANT'
                               AND TT2.VALID_YN         = 'Y'
                               AND TD.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND TD.SCM_SITE_ID(+)    = TT1.TO_SITE
                               AND RTRIM(TD.SHIPTO_CODE(+)) = RTRIM(TT0.SHIPTO_CODE)
                               AND TD.VALID_YN(+)       = 'Y'
                               AND TD.REP_YN(+)         = 'Y'
                               AND TC.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND TC.SOLDTO_CODE(+)    = TD.SOLDTO_CODE
                               AND TC.SHIPTO_CODE(+)    = RTRIM(TT0.SHIPTO_CODE)
                               AND TC.VALID_YN(+)       = 'Y'
                               /* 2026.09.30 AJS 수정 (START) */
--                               AND U3.USERID(+)         = TT0.LAST_UPDATED_BY
--                               AND U3.USEYN(+)          = 'Y'
                               AND U3.USER_ID(+)        = TT0.LAST_UPDATED_BY
                               AND U3.USE_YN(+)         = 'Y'
                               /* 2026.09.30 AJS 수정 (END) */
                               AND F.DIVISION_ID(+)     = TT0.DIVISION_ID
                               AND F.SCM_SITE_ID(+)     = TT1.TO_SITE
                               AND F.VALID_YN(+)        = 'Y'
                               AND MU.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND MU.FROM_SITE(+)      = TT1.FROM_SITE
                               AND MU.ITEM_ID(+)        = TT0.ITEM_ID
                               AND MU.VALID_YN(+)       = 'Y'
                               AND SI.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND SI.SCM_SITE_ID(+)    = TT1.TO_SITE
                               AND SI.ITEM_ID(+)        = TT0.ITEM_ID
                               AND SI.PROJECT_CODE(+)   = F.SOLDTO_CUSTOMER
                               AND TT0.DIVISION_ID      = P_DIVISION_ID
                               AND TT1.BOD_TYPE         = 'SALES'
                               AND TT0.QTY              > 0
                               AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                                     OR  UPPER(P_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT0.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                                     OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                   OR TT0.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                                     OR TT0.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                     OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT1.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                               AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     OR TT0.LAST_UPDATED_BY IN (SELECT DISTINCT SC.USERID
--                                                                  FROM TB_FX_USER SC
--                                                                 WHERE SC.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                                    OR SC.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     OR TT0.LAST_UPDATED_BY IN (SELECT DISTINCT SC.USER_ID
                                                                  FROM SCM_ADM_USER_M SC
                                                                 WHERE SC.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                                    OR SC.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     /* 2026.09.30 AJS 수정 (END) */
                               AND (P_SEARCH_YN != 'Y'
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                            UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN     = 'Y'
                                                               AND DELEGATEE_ID = P_USER_ID
                                                             GROUP BY USER_ID)
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                           ) T
                     WHERE T.SHIPMENT_DATE >= T.FROZEN_YYYYMMDD
                       AND T.SHIPMENT_DATE <= P_TO_YYYYMMDD
                   ) AA
             ORDER BY AA.DIVISION_ID
                    , AA.SHIPMENT_DATE
                    , AA.SHIPMENT_STATUS
                    , AA.FROM_SITE
                    , AA.ITEM_ID
                    , AA.ERP_SO_NO DESC
                    , AA.TO_SITE
                    , AA.PROJECT_CODE
                    , AA.FCST_TYPE;

        ELSE

            OPEN O_RC1 FOR
            SELECT AA.*
              FROM (
                    SELECT T0.DIVISION_ID
                         , T0.ERP_SO_NO
                         , T0.SHIPMENT_STATUS
                         , T0.PROJECT_CODE
                         , T0.PROJECT_NAME
                         , T0.FCST_TYPE
                         , T0.ITEM_ID
                         , FN_GET_ITEM_NICKNAME(T0.DIVISION_ID, T0.ITEM_ID) AS NICK_NAME
                         , T0.SHIPMENT_DATE
                         , T0.SHIPMENT_CONFIRM_QTY
                         , T0.REMARKS
                         , T0.REMARKS2
                         , T0.REMARKS3
                         , T0.FROM_SITE
                         , T0.FROM_SITE_DESCRIPTION
                         , T0.TO_SITE
                         , T0.TO_SITE_DESCRIPTION
                         , T0.TO_SITE_SOLDTO_CODE
                         , T0.TO_SITE_SHIPTO_CODE
                         , T0.SOLDTO_DESCRIPTION
                         , T0.SHIPTO_DESCRIPTION
                         , T0.BOD_ID
                         , T0.INCOTERMS
                         , T0.TRANSPORT_MODE
                         , T0.LT_DAY
                         , T0.ETD
                         , T0.ETA
                         , T0.EXPECTED_SHIPPING_DATE
                         , T0.CONFIRM_ID
                         , T0.UPDATED_BY
                         , T0.UPDATED_DATE
                         , '-'                               AS ERP_STATUS
                         , '-'                               AS CHANGE_TYPE
                         , '-'                               AS NEW_ROUTE_ID
                         , '-'                               AS NEW_BOD_ID
                         , '-'                               AS NEW_INCOTERMS
                         , '-'                               AS NEW_D_COUNTRY
                         , '-'                               AS NEW_D_PORT_CODE
                         , '-'                               AS NEW_A_COUNTRY
                         , '-'                               AS NEW_A_PORT_CODE
                         , '-'                               AS NEW_CUSTOMER_LT
                         , '-'                               AS NEW_TO_COUNTRY
                         , '-'                               AS NEW_TO_CITY
                         , '-'                               AS NEW_ETA
                         , '-'                               AS NEW_ETD
                         , '-'                               AS NEW_LT_DAY
                         , '-'                               AS NEW_TRANSPORT_MODE
                         , '-'                               AS NEW_SHIPMENT_DATE
                         , '-'                               AS EDIT_REMARKS
                         , '-'                               AS EDIT_MAIN
                         , '-'                               AS CHECK_NEED_YN
                         , T0.END_CUSTOMER                   AS END_CUSTOMER
                         , '-'                               AS ELECTRODE_YN
                         , '-'                               AS ELECTRODE_TYPE
                         , '-'                               AS ORIGIN_FROM_DIVISION_ID
                         , '-'                               AS ORIGIN_TO_DIVISION_ID
                         , T0.CHANGE_REQ_NO                  AS CHANGE_REQ_NO
                         , T0.MODEL_USER                     AS MODEL_USER
                         , T0.MTK_OWNER                      AS MTK_OWNER
                         , T0.REQUESTOR                      AS REQUESTOR
                         , '-'                               AS CHANGE_REASON_CODE
                         , '-'                               AS CHANGE_REASON_DETAIL
                      FROM (SELECT TT0.DIVISION_ID
                                 , '-'                       AS ERP_SO_NO
                                 , 'P'                       AS SHIPMENT_STATUS
                                 , TT0.ITEM_ID               AS ITEM_ID
                                 , '-'                       AS NICK_NAME
                                 , TT4.FROM_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT4.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                                 , TT4.TO_SITE               AS TO_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT4.TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                                 , TT0.PROJECT_CODE
                                 , '-'                       AS PROJECT_NAME
                                 , TT0.REQUESTOR             AS REQUESTOR
                                 , TT0.QTY                   AS SHIPMENT_CONFIRM_QTY
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT4.SSP_INCOTERMS         AS INCOTERMS
                                 , TT4.TRANSPORT_MODE        AS TRANSPORT_MODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT4.TO_SITE, 'SOLDTO_CODE')        AS TO_SITE_SOLDTO_CODE
                                 , TT0.SHIPTO_CODE           AS TO_SITE_SHIPTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT4.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT4.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                                 , '-'                       AS REMARKS2
                                 , '-'                       AS REMARKS
                                 , '-'                       AS CHANGE_REQ_NO
                                 , '-'                       AS REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.ETD_DATE, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                                 , CASE WHEN REGEXP_LIKE(TT0.ETA_DATE, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                                 , CASE WHEN TT4.TRANSPORT_MODE = 'TRK' THEN '-'
                                        ELSE (SELECT CASE WHEN REGEXP_LIKE(SD.V, '^[0-9]{8}$')
                                                          THEN TO_CHAR(TO_DATE(SD.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                                FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SD)
                                   END                       AS EXPECTED_SHIPPING_DATE
                                 , TT4.LT_TOTAL              AS LT_DAY
                                 , TT1.LAST_UPDATED_BY       AS UPDATED_BY
                                 , TO_CHAR(TT1.LAST_UPDATE_DATE, 'YYYY-MM-DD') AS UPDATED_DATE
                                 , TT1.REQUEST_ID            AS CONFIRM_ID
                                 , TT0.FCST_TYPE             AS FCST_TYPE
                                 , TT2.SOLDTO_CUSTOMER       AS END_CUSTOMER
                                 , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, ',', P_LANGUAGE) AS MTK_OWNER
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NULL THEN NULL
--                                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
                                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NULL THEN NULL
                                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
                                 /* 2026.09.30 AJS 수정 (END) */
                                   END                       AS MODEL_USER
                              FROM SSP_ANL_SHIP_PLAN_P TT0
                                 , SSP_ANL_SHIP_REQ_P TT1
                                 , SCP_MST_BOD_N_V TT4
                                 , SCM_MST_SITE TT2
                                 , SSP_MST_MODEL_USER MU
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER U2
                                 , SCM_ADM_USER_M U2
                                 /* 2026.09.30 AJS 수정 (END) */
                                 , SCM_MST_SITE_ITEM SI
                             WHERE TT1.DIVISION_ID(+)   = TT0.DIVISION_ID
                               AND TT1.ITEM_ID(+)       = TT0.ITEM_ID
                               AND TT1.REQUEST_ID(+)    = TT0.REQUEST_ID
                               AND TT4.DIVISION_ID(+)   = TT0.DIVISION_ID
                               AND TT4.BOD_ID(+)        = TT0.BOD_ID
                               AND TT2.DIVISION_ID(+)   = TT1.DIVISION_ID
                               AND TT2.SCM_SITE_ID(+)   = TT4.TO_SITE
                               AND MU.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND MU.FROM_SITE(+)      = TT4.FROM_SITE
                               AND MU.ITEM_ID(+)        = TT0.ITEM_ID
                               AND MU.VALID_YN(+)       = 'Y'
                               /* 2026.09.30 AJS 수정 (START) */
--                               AND U2.USERID(+)         = MU.USER_ID
--                               AND U2.USEYN(+)          = 'Y'
                               AND U2.USER_ID(+)        = MU.USER_ID
                               AND U2.USE_YN(+)         = 'Y'
                               /* 2026.09.30 AJS 수정 (END) */
                               AND SI.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND SI.SCM_SITE_ID(+)    = TT4.TO_SITE
                               AND SI.ITEM_ID(+)        = TT0.ITEM_ID
                               AND SI.PROJECT_CODE(+)   = TT0.PROJECT_CODE
                               AND TT0.DIVISION_ID            = P_DIVISION_ID
                               AND TT0.PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
                               AND TT0.MEASURE                = 'SHIP_REQ'
                               AND NVL(TT0.CONFIRM_FLAG, 'N') = 'N'
                               AND TT0.QTY                    > 0
                               AND TT0.YYYYMMDD              >= P_FROM_YYYYMMDD
                               AND TT0.YYYYMMDD              <= P_TO_YYYYMMDD
                               AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                                     OR  UPPER(P_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT0.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                                     OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                   OR TT0.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                                     OR TT0.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                     OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT4.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                               AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SE.USERID
--                                                            FROM TB_FX_USER SE
--                                                           WHERE SE.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                              OR SE.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SE.USER_ID
                                                            FROM SCM_ADM_USER_M SE
                                                           WHERE SE.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                              OR SE.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     /* 2026.09.30 AJS 수정 (END) */
                               AND (P_SEARCH_YN != 'Y'
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                            UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN     = 'Y'
                                                               AND DELEGATEE_ID = P_USER_ID
                                                             GROUP BY USER_ID)
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                            UNION ALL
                            SELECT TT0.DIVISION_ID
                                 , '-'                       AS ERP_SO_NO
                                 , 'C'                       AS SHIPMENT_STATUS
                                 , TT0.ITEM_ID               AS ITEM_ID
                                 , '-'                       AS NICK_NAME
                                 , TT4.FROM_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT0.FROM_SITE), '-') AS FROM_SITE_DESCRIPTION
                                 , TT4.TO_SITE               AS TO_SITE
                                 , NVL(FN_GET_SCM_SITE_DESCRIPTION(TT0.DIVISION_ID, TT4.TO_SITE), '-')   AS TO_SITE_DESCRIPTION
                                 , TT0.PROJECT_CODE
                                 , '-'                       AS PROJECT_NAME
                                 , TT0.REQUESTOR             AS REQUESTOR
                                 , TT0.QTY                   AS SHIPMENT_CONFIRM_QTY
                                 , CASE WHEN REGEXP_LIKE(TT0.YYYYMMDD, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.YYYYMMDD, 'YYYYMMDD'), 'YYYY-MM-DD') END AS SHIPMENT_DATE
                                 , TT0.BOD_ID
                                 , TT4.SSP_INCOTERMS         AS INCOTERMS
                                 , TT4.TRANSPORT_MODE        AS TRANSPORT_MODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT4.TO_SITE, 'SOLDTO_CODE')        AS TO_SITE_SOLDTO_CODE
                                 , TT0.SHIPTO_CODE           AS TO_SITE_SHIPTO_CODE
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT4.TO_SITE, 'SOLDTO_DESCRIPTION') AS SOLDTO_DESCRIPTION
                                 , FN_GET_SITE_CUSTOMER_INFO(TT0.DIVISION_ID, TT4.TO_SITE, 'SHIPTO_DESCRIPTION') AS SHIPTO_DESCRIPTION
                                 , '-'                       AS REMARKS2
                                 , '-'                       AS REMARKS
                                 , '-'                       AS CHANGE_REQ_NO
                                 , '-'                       AS REMARKS3
                                 , CASE WHEN REGEXP_LIKE(TT0.ETD_DATE, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETD_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETD
                                 , CASE WHEN REGEXP_LIKE(TT0.ETA_DATE, '^[0-9]{8}$')
                                        THEN TO_CHAR(TO_DATE(TT0.ETA_DATE, 'YYYYMMDD'), 'YYYY-MM-DD') END AS ETA
                                 , CASE WHEN TT4.TRANSPORT_MODE = 'TRK' THEN '-'
                                        ELSE (SELECT CASE WHEN REGEXP_LIKE(SF.V, '^[0-9]{8}$')
                                                          THEN TO_CHAR(TO_DATE(SF.V, 'YYYYMMDD'), 'YYYY-MM-DD') END
                                                FROM (SELECT FN_GET_SSP_EXPECTED_SHIP_DATE(TT0.DIVISION_ID, TT0.BOD_ID, TT0.YYYYMMDD) AS V FROM DUAL) SF)
                                   END                       AS EXPECTED_SHIPPING_DATE
                                 , TT4.LT_TOTAL              AS LT_DAY
                                 , TT1.LAST_UPDATED_BY       AS UPDATED_BY
                                 , TO_CHAR(TT1.LAST_UPDATE_DATE, 'YYYY-MM-DD') AS UPDATED_DATE
                                 , TT0.CONFIRM_ID
                                 , TT0.FCST_TYPE             AS FCST_TYPE
                                 , TT2.SOLDTO_CUSTOMER       AS END_CUSTOMER
                                 , FN_GET_SSP_MKT_OWNER_NAME(SI.OWNER, ',', P_LANGUAGE) AS MTK_OWNER
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) IS NULL THEN NULL
--                                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USERNAME ELSE U2.USERNAME_E END) || '(' || MU.USER_ID || ')'
                                 , CASE WHEN (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) IS NULL THEN NULL
                                        ELSE (CASE WHEN P_LANGUAGE = 'KO' THEN U2.USER_NM ELSE U2.USER_ENG_NM END) || '(' || MU.USER_ID || ')'
                                 /* 2026.09.30 AJS 수정 (END) */
                                   END                       AS MODEL_USER
                              FROM SSP_ANL_SHIP_PLAN_P TT0
                                 , SSP_ANL_SHIP_REQ_P TT1
                                 , SCP_MST_BOD_N_V TT4
                                 , SCM_MST_SITE TT2
                                 , SSP_MST_MODEL_USER MU
                                 /* 2026.09.30 AJS 수정 (START) */
--                                 , TB_FX_USER U2
                                 , SCM_ADM_USER_M U2
                                 /* 2026.09.30 AJS 수정 (END) */
                                 , SCM_MST_SITE_ITEM SI
                             WHERE TT1.DIVISION_ID(+)   = TT0.DIVISION_ID
                               AND TT1.ITEM_ID(+)       = TT0.ITEM_ID
                               AND TT1.CONFIRM_ID(+)    = TT0.REQUEST_ID
                               AND TT4.DIVISION_ID(+)   = TT0.DIVISION_ID
                               AND TT4.BOD_ID(+)        = TT0.BOD_ID
                               AND TT2.DIVISION_ID(+)   = TT1.DIVISION_ID
                               AND TT2.SCM_SITE_ID(+)   = TT4.TO_SITE
                               AND MU.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND MU.FROM_SITE(+)      = TT4.FROM_SITE
                               AND MU.ITEM_ID(+)        = TT0.ITEM_ID
                               AND MU.VALID_YN(+)       = 'Y'
                               /* 2026.09.30 AJS 수정 (START) */
--                               AND U2.USERID(+)         = MU.USER_ID
--                               AND U2.USEYN(+)          = 'Y'
                               AND U2.USER_ID(+)        = MU.USER_ID
                               AND U2.USE_YN(+)         = 'Y'
                               /* 2026.09.30 AJS 수정 (END) */
                               AND SI.DIVISION_ID(+)    = TT0.DIVISION_ID
                               AND SI.SCM_SITE_ID(+)    = TT4.TO_SITE
                               AND SI.ITEM_ID(+)        = TT0.ITEM_ID
                               AND SI.PROJECT_CODE(+)   = TT0.PROJECT_CODE
                               AND TT0.DIVISION_ID            = P_DIVISION_ID
                               AND TT0.PLAN_START_YYYYMMDD    = P_PLAN_START_YYYYMMDD
                               AND TT0.MEASURE                = 'SHIP_CONFIRM'
                               AND NVL(TT0.CONFIRM_FLAG, 'N') = 'Y'
                               AND TT0.QTY                    > 0
                               AND TT0.YYYYMMDD              >= P_FROM_YYYYMMDD
                               AND TT0.YYYYMMDD              <= P_TO_YYYYMMDD
                               AND ((P_DIVISION_ID IS NULL OR P_DIVISION_ID = '')
                                     OR  UPPER(P_DIVISION_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT0.DIVISION_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_DIVISION_ID, ','))))
                               AND ((P_ITEM_ID IS NULL OR P_ITEM_ID = '')
                                     OR  UPPER(P_ITEM_ID) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
--                                   OR TT0.ITEM_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_ITEM_ID, ','))))   --  2026.10.07 AJS
                                     OR TT0.ITEM_ID IN (SELECT COLUMN_VALUE FROM TABLE(V_ITEM_TAB)))   --  2026.10.07 AJS
                               AND ((P_FROM_SITE IS NULL OR P_FROM_SITE = '')
                                     OR  UPPER(P_FROM_SITE) = 'ALL' /* 조회조건 ALL 은 조건 없음 */
                                     OR TT4.FROM_SITE IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_FROM_SITE, ','))))
                               AND ((P_REQUESTOR IS NULL OR P_REQUESTOR = '')
                                     /* 2026.09.30 AJS 수정 (START) */
--                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SG.USERID
--                                                            FROM TB_FX_USER SG
--                                                           WHERE SG.USERNAME IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
--                                                              OR SG.USERID   IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     OR TT0.REQUESTOR IN (SELECT DISTINCT SG.USER_ID
                                                            FROM SCM_ADM_USER_M SG
                                                           WHERE SG.USER_NM IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))
                                                              OR SG.USER_ID IN (SELECT TOKEN FROM TABLE(FN_STRING_SPLIT(P_REQUESTOR, ',')))))
                                     /* 2026.09.30 AJS 수정 (END) */
                               AND (P_SEARCH_YN != 'Y'
                                     OR ((P_NONCHK = 'Y' AND 1 = 1)
                                          OR MU.USER_ID IN (SELECT CASE WHEN P_MYMODELCHK = 'Y' THEN P_USER_ID ELSE 'X' END FROM DUAL
                                                            UNION
                                                            SELECT CASE WHEN P_DELEGATEECHK = 'Y' THEN USER_ID ELSE 'X' END
                                                              FROM SSP_MST_DELEGATE
                                                             WHERE VALID_YN     = 'Y'
                                                               AND DELEGATEE_ID = P_USER_ID
                                                             GROUP BY USER_ID)
                                          OR MU.PART_LEADER = CASE WHEN P_PARTLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END
                                          OR MU.TEAM_LEADER = CASE WHEN P_TEAMLEADERCHK = 'Y' THEN P_USER_ID ELSE 'X' END))
                           ) T0
                   ) AA
             ORDER BY AA.DIVISION_ID
                    , AA.SHIPMENT_DATE
                    , AA.SHIPMENT_STATUS
                    , AA.FROM_SITE
                    , AA.ITEM_ID
                    , AA.ERP_SO_NO DESC
                    , AA.TO_SITE
                    , AA.PROJECT_CODE
                    , AA.FCST_TYPE;

        END IF;

    END P_SSP0015_GET_SHIPMENT_CONFIRM_DETAIL_PACKER;

END PKG_SSP0015;