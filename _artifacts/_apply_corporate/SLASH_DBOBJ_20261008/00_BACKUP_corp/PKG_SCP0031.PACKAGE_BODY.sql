PACKAGE BODY PKG_SCP0031
IS
/*
 * Program ID   : PKG_SCP0031
 * Description  : SCP0031 Global PSI
 * Program History
 *===================================================================================================
 * Date         In Charge		Description
 *===================================================================================================
 * 2026.09.22   ZIONEX       [PJ202650304] MSSQL -> Oracle 전환
 * 2026.10.06   AJS          조회 속도 개선 : 품목 뷰(SCM_MST_FINAL_ITEM_V) 외부조인에 조회 사업부 조건 추가 - 전 사업부 뷰 전개(약 26만 블록) 제거
 */

    /* AS-IS 피벗 집계에서 되풀이되는 MEASURE 목록 */
    C_MEASURE_BAL    CONSTANT VARCHAR2(200) := '''MODEL_INVENTORY'',''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''SAFETY_STOCK'',''GAP'',''DIO''';
    C_MEASURE_NOTIN  CONSTANT VARCHAR2(240) := '''MODEL_INVENTORY'',''WH_IN_BALANCE'',''BALANCE'',''CHAR_AVAILABLE'',''ACTIVATE_PROGRESS'',''LINE_TOTAL_LOAD_ENGINE'',''SAFETY_STOCK'',''GAP'',''DIO''';

    PROCEDURE P_SCP0031_GET_GLOBAL_PSI
    (
        P_FROM_YYYYMMDD         IN  VARCHAR2
      , P_TO_YYYYMMDD           IN  VARCHAR2
      , P_DIVISION_ID           IN  VARCHAR2
      , P_ITEM_ID               IN  VARCHAR2
      , P_NICK_NAME             IN  VARCHAR2
      , P_FROM_SITE             IN  VARCHAR2
      , P_TO_SITE               IN  VARCHAR2
      , P_PLAN_START_YYYYMMDD   IN  VARCHAR2
      , P_PLAN_TYPE             IN  VARCHAR2
      , P_SEQ                   IN  VARCHAR2
      , P_PROGRAM_ID            IN  VARCHAR2
      , P_SHEET_NAME            IN  VARCHAR2
      , P_USER_ID               IN  VARCHAR2
      , P_BUCKET                IN  VARCHAR2
      , P_CHK_ALL               IN  VARCHAR2
      , P_DEBUG_MODE            IN  VARCHAR2
      , O_RC1                   OUT SYS_REFCURSOR
      , O_RESULT_CURSOR         OUT SYS_REFCURSOR
    )
    IS

        V_CNT_USR_MEASURE    VARCHAR2(1)   := '0';   /* AS-IS 는 NVARCHAR(1) 이라 10 이상이면 앞 한 자리만 남는다 */
        V_FROM_YYYYMMDD      VARCHAR2(32);
        V_TO_YYYYMMDD        VARCHAR2(32);
        V_FROM_RESULT        VARCHAR2(32);
        V_TO_RESULT          VARCHAR2(32);
        V_BUCKET             VARCHAR2(10)  := P_BUCKET;
        V_SEQ                NUMBER        := TO_NUMBER(P_SEQ);
        V_QRY_SUM            CLOB;
        V_EXEC               CLOB;
        V_EE_YN              VARCHAR2(1)   := 'N';   /* 조회 사업부가 EE 계열인지 */
        V_ERR_MSG            VARCHAR2(4000);

    BEGIN

        /* 세션에 남은 임시 자료 정리 */
        DELETE GT_SCP0031_NICKITEM;
        DELETE GT_SCP0031_RANK;
        DELETE GT_SCP0031_ITEM;
        DELETE GT_SCP0031_MEASURE;
        DELETE GT_SCP0031_MAIN;
        DELETE GT_SCP0031_RESULT;
        DELETE GT_SCP0031_LOADBASE;
        DELETE GT_SCP0031_LOAD;
        DELETE GT_SCP0031_FNL;

        SELECT SUBSTR(TO_CHAR(NVL(( SELECT COUNT(*)
                                      FROM SCM_MST_TITLESET_USER
                                     WHERE 1 = 1
                                       AND PROGRAM_ID = P_PROGRAM_ID
                                       AND SHEET_NAME = P_SHEET_NAME
                                       AND USER_ID    = P_USER_ID
                                  ), 0)), 1, 1)
          INTO V_CNT_USR_MEASURE
          FROM DUAL;

        BEGIN
            SELECT C.BASIS_START_DATE
              INTO V_FROM_YYYYMMDD
              FROM SCM_SYS_CALENDAR_M      C
             WHERE 1 = 1
               AND C.BASIS_YYYYMMDD = P_PLAN_START_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_FROM_YYYYMMDD := NULL;
        END;

        BEGIN
            SELECT C.BASIS_START_DATE
              INTO V_FROM_RESULT
              FROM SCM_SYS_CALENDAR_M      C
             WHERE 1 = 1
               AND C.BASIS_YYYYMMDD = P_FROM_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_FROM_RESULT := NULL;
        END;

        BEGIN
            SELECT C.BASIS_START_DATE
              INTO V_TO_RESULT
              FROM SCM_SYS_CALENDAR_M      C
             WHERE 1 = 1
               AND C.BASIS_YYYYMMDD = P_TO_YYYYMMDD;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                V_TO_RESULT := NULL;
        END;

        /* AS-IS 변수 초기값이 빈 문자라 미조회 시에도 비교가 성립한다. NVL 로 같은 분기를 태운다 */
        IF NVL(V_FROM_YYYYMMDD, ' ') > NVL(V_FROM_RESULT, ' ') THEN
            /* 실적 보여줌 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_TO_RESULT   := V_FROM_YYYYMMDD;
        ELSIF NVL(V_FROM_YYYYMMDD, ' ') <= NVL(V_FROM_RESULT, ' ') THEN
            /* 실적 없음 */
            V_TO_YYYYMMDD := P_TO_YYYYMMDD;
            V_FROM_RESULT := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), 6), 'YYYYMMDD');
            V_TO_RESULT   := TO_CHAR(ADD_MONTHS(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD'), -6), 'YYYYMMDD');
        END IF;
        /* AS-IS 의 나머지 두 분기(> v_to_result · = v_to_result)는 위 두 조건이 전 구간을 덮어 도달하지 않는다. 원문 유지 */

        /* 2021/12/14 Start */
        IF P_CHK_ALL = 'Y' THEN
            V_BUCKET := 'DAILY';   /* 2021/12/14 */
        END IF;
        /* 2021/12/14 End */

        SELECT CASE WHEN EXISTS ( SELECT 1
                                    FROM TABLE(FN_GET_DIVISION_DIV('EE'))
                                   WHERE COLUMN_VALUE = P_DIVISION_ID
                                ) THEN 'Y' ELSE 'N' END
          INTO V_EE_YN
          FROM DUAL;

        /* NICK NAME 조회조건으로 ITEM 추출 */
        INSERT INTO GT_SCP0031_NICKITEM
        (
            ITEM_ID
        )
        SELECT DISTINCT ITEM_ID
          FROM SCM_MST_ITEM_SN
         WHERE 1 = 1
           AND NICK_NAME IS NOT NULL
           AND TRIM(P_NICK_NAME) IS NOT NULL
           AND NICK_NAME LIKE P_NICK_NAME || '%';

        /* PSI CELL/PACK ITEM 세트 */
        INSERT INTO GT_SCP0031_RANK
        (
            CELL_ITEM_ID
          , ITEM_ID
          , RANK_NO
        )
        SELECT CELL_ITEM_ID
             , ITEM_ID
             , RANK() OVER (ORDER BY CELL_ITEM_ID ASC) AS RANK_NO
          FROM SCP_ANL_PSI_GLOBAL
         WHERE DIVISION_ID         = P_DIVISION_ID
           AND PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND PLAN_TYPE           = P_PLAN_TYPE
           AND SEQ                 = V_SEQ
           AND YYYYMMDD           >= P_FROM_YYYYMMDD
           AND YYYYMMDD           <= P_TO_YYYYMMDD
         GROUP BY CELL_ITEM_ID
                , ITEM_ID;

        /* 조회조건에 해당하는 세트 모두 추출 */
        INSERT INTO GT_SCP0031_ITEM
        (
            CELL_ITEM_ID
          , ITEM_ID
        )
        SELECT A.CELL_ITEM_ID
             , A.ITEM_ID
          FROM GT_SCP0031_RANK      A
         WHERE A.RANK_NO IN
               (
                 SELECT B.RANK_NO
                   FROM GT_SCP0031_RANK      B
                  WHERE 1 = 1
                    AND (
                          ( B.ITEM_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ','))) )
                          OR
                          ( B.ITEM_ID IN (SELECT ITEM_ID FROM GT_SCP0031_NICKITEM) )
                          OR
                          ( B.CELL_ITEM_ID IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_ITEM_ID, ','))) )
                          OR
                          ( B.CELL_ITEM_ID IN (SELECT ITEM_ID FROM GT_SCP0031_NICKITEM) )
                        )
               );

        /* 유저 MEASURE 세팅값 추출 */ /* 로드율은 PRODUCTION과 동일한 SORT 값을 강제 셋팅 */
        INSERT INTO GT_SCP0031_MEASURE
        (
            COLUMN_NAME
          , COLUMN_LABEL_NAME
          , SORT_ORDER_NO
          , ATTRIBUTE3
        )
        SELECT M.COLUMN_NAME
             , M.COLUMN_LABEL_NAME
             , CASE WHEN M.COLUMN_NAME = 'LINE_TOTAL_LOAD_ENGINE' AND TO_NUMBER(V_CNT_USR_MEASURE) > 0 THEN NVL(( SELECT T.SORT_ORDER_NO
                                                                                                                    FROM SCM_MST_TITLESET_USER      T
                                                                                                                   WHERE T.PROGRAM_ID  = M.PROGRAM_ID
                                                                                                                     AND T.SHEET_NAME  = M.SHEET_NAME
                                                                                                                     AND T.COLUMN_NAME = 'PRODUCTION'
                                                                                                                     AND T.USER_ID     = U.USER_ID
                                                                                                                ), U.SORT_ORDER_NO)
                    WHEN M.COLUMN_NAME = 'LINE_TOTAL_LOAD_ENGINE' AND TO_NUMBER(V_CNT_USR_MEASURE) = 0 THEN P.SORT_ORDER_NO
                    WHEN M.COLUMN_NAME = 'SHIP_PLAN'              AND TO_NUMBER(V_CNT_USR_MEASURE) > 0 THEN NVL(( SELECT T.SORT_ORDER_NO
                                                                                                                    FROM SCM_MST_TITLESET_USER      T
                                                                                                                   WHERE T.PROGRAM_ID  = M.PROGRAM_ID
                                                                                                                     AND T.SHEET_NAME  = M.SHEET_NAME
                                                                                                                     AND T.COLUMN_NAME = 'SHIP_REQ'
                                                                                                                     AND T.USER_ID     = U.USER_ID
                                                                                                                ), U.SORT_ORDER_NO)
                    WHEN M.COLUMN_NAME = 'SHIP_PLAN'              AND TO_NUMBER(V_CNT_USR_MEASURE) = 0 THEN S.SORT_ORDER_NO
                    ELSE NVL(U.SORT_ORDER_NO, M.SORT_ORDER_NO)
               END AS SORT_ORDER_NO
             , M.ATTRIBUTE3   /* MEASURE 별 COLOR RGB코드 */
          FROM SCM_MST_SHEET_MEASURE      M
             , SCM_MST_TITLESET_USER      U
             , SCM_MST_SHEET_MEASURE      P
             , SCM_MST_SHEET_MEASURE      S
         WHERE U.PROGRAM_ID(+)  = M.PROGRAM_ID
           AND U.SHEET_NAME(+)  = M.SHEET_NAME
           AND U.COLUMN_NAME(+) = M.COLUMN_NAME
           AND U.USER_ID(+)     = P_USER_ID
           AND P.PROGRAM_ID(+)  = M.PROGRAM_ID
           AND P.SHEET_NAME(+)  = M.SHEET_NAME
           AND P.COLUMN_NAME(+) = 'PRODUCTION'
           AND S.PROGRAM_ID(+)  = M.PROGRAM_ID
           AND S.SHEET_NAME(+)  = M.SHEET_NAME
           AND S.COLUMN_NAME(+) = 'SHIP_REQ'
           AND M.PROGRAM_ID     = 'SCP0031'
           AND M.VALID_YN       = 'Y'
           AND ( TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(U.SORT_ORDER_NO, 0) > 0 );

        /*******************************************************************************
         * 데이타조회, 임시테이블에 저장
         *   AS-IS 는 조회조건 유무에 따라 문장을 조립했다. 조건별 정적 SQL 로 옮긴다
         *******************************************************************************/
        IF TRIM(P_ITEM_ID) IS NOT NULL OR TRIM(P_NICK_NAME) IS NOT NULL THEN

            INSERT INTO GT_SCP0031_MAIN
            (
                DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , TO_SITE2
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
              , MEASURE
              , B_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , QTY
              , ISO_WEEK
              , SORT_ORDER_NO
              , COLUMN_LABEL_NAME
              , BOD_ID
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE3
            )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , NVL(NULLIF(A.TO_SITE, ''), '-') AS TO_SITE
                 , CASE WHEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), -2) = '-S' THEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), 1, LENGTH(RTRIM(NVL(NULLIF(A.TO_SITE, ''), '-'))) - 2) ELSE NVL(NULLIF(A.TO_SITE, ''), '-') END AS TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , A.YYYYMMDD AS B_YYYYMMDD
                 , 'D_' || A.YYYYMMDD AS YYYYMMDD
                 , O.BASIS_YYYYMM AS YYYYMM
                 , NVL(A.QTY, 0) AS QTY
                 , SUBSTR(O.BASIS_YYYYMM, -4) || O.ISO_WEEK AS ISO_WEEK
                 , M.SORT_ORDER_NO
                 , M.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9    /* OPERATION ID */
                 , A.ATTRIBUTE10   /* P:1, A:2 */
                 , M.ATTRIBUTE3    /* UI용 MEASURE COLOR */
              FROM SCP_ANL_PSI_GLOBAL      A
                 , SCM_SYS_CALENDAR_M      O
                 , GT_SCP0031_MEASURE      M
                 , GT_SCP0031_ITEM         I
             WHERE A.YYYYMMDD            = O.BASIS_YYYYMMDD
               AND M.COLUMN_NAME         = A.MEASURE
               AND A.CELL_ITEM_ID        = I.CELL_ITEM_ID
               AND A.ITEM_ID             = I.ITEM_ID
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = V_SEQ
               AND A.YYYYMMDD           >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD           <= P_TO_YYYYMMDD
               AND ( TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(M.SORT_ORDER_NO, 0) > 0 )
               AND ( TRIM(P_FROM_SITE) IS NULL OR NVL(NULLIF(A.FROM_SITE, ''), '-') IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))) )
               AND ( TRIM(P_TO_SITE)   IS NULL OR NVL(NULLIF(A.TO_SITE, ''), '-')   IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))) );

        ELSE

            INSERT INTO GT_SCP0031_MAIN
            (
                DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , TO_SITE2
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
              , MEASURE
              , B_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , QTY
              , ISO_WEEK
              , SORT_ORDER_NO
              , COLUMN_LABEL_NAME
              , BOD_ID
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE3
            )
            SELECT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , NVL(NULLIF(A.TO_SITE, ''), '-') AS TO_SITE
                 , CASE WHEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), -2) = '-S' THEN SUBSTR(NVL(NULLIF(A.TO_SITE, ''), '-'), 1, LENGTH(RTRIM(NVL(NULLIF(A.TO_SITE, ''), '-'))) - 2) ELSE NVL(NULLIF(A.TO_SITE, ''), '-') END AS TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , A.YYYYMMDD AS B_YYYYMMDD
                 , 'D_' || A.YYYYMMDD AS YYYYMMDD
                 , O.BASIS_YYYYMM AS YYYYMM
                 , NVL(A.QTY, 0) AS QTY
                 , SUBSTR(O.BASIS_YYYYMM, -4) || O.ISO_WEEK AS ISO_WEEK
                 , M.SORT_ORDER_NO
                 , M.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9    /* OPERATION ID */
                 , A.ATTRIBUTE10   /* P:1, A:2 */
                 , M.ATTRIBUTE3    /* UI용 MEASURE COLOR */
              FROM SCP_ANL_PSI_GLOBAL      A
                 , SCM_SYS_CALENDAR_M      O
                 , GT_SCP0031_MEASURE      M
             WHERE A.YYYYMMDD            = O.BASIS_YYYYMMDD
               AND M.COLUMN_NAME         = A.MEASURE
               AND A.DIVISION_ID         = P_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = P_PLAN_TYPE
               AND A.SEQ                 = V_SEQ
               AND A.YYYYMMDD           >= P_FROM_YYYYMMDD
               AND A.YYYYMMDD           <= P_TO_YYYYMMDD
               AND ( TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(M.SORT_ORDER_NO, 0) > 0 )
               AND ( TRIM(P_FROM_SITE) IS NULL OR NVL(NULLIF(A.FROM_SITE, ''), '-') IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_FROM_SITE, ','))) )
               AND ( TRIM(P_TO_SITE)   IS NULL OR NVL(NULLIF(A.TO_SITE, ''), '-')   IN (SELECT TOKEN FROM TABLE(UF_FX_STRING_SPLIT(P_TO_SITE, ','))) );

        END IF;

        /*******************************************************************************
         * 1. Line Load(%) Temp
         *******************************************************************************/
        INSERT INTO GT_SCP0031_LOADBASE
        (
            DIVISION_ID
          , OPERATION_GROUP
          , FROM_SITE
          , ATTRIBUTE9
          , TRANSPORT_MODE_LINE
          , SUM_LOAD_QTY
          , QTY
          , WORKING_TIME
          , B_YYYYMMDD
          , YYYYMM
          , ISO_WEEK
          , WEEK_YYYYMMDD
          , MONTH_YYYYMMDD
        )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.FROM_SITE
             , A.ATTRIBUTE9
             , A.TRANSPORT_MODE_LINE
             , ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) AS SUM_LOAD_QTY
             , CASE WHEN D.WORKING_TIME <= 0.0 THEN 0
                    ELSE NVL(( ( ROUND(SUM(A.QTY * (E.TACT_TIME / 60)), 0) / D.WORKING_TIME ) ), 0) * 100
               END AS QTY
             , D.WORKING_TIME
             , A.YYYYMMDD AS B_YYYYMMDD
             , O.BASIS_YYYYMM AS YYYYMM
             , O.ISO_WEEK
             , 'W_' || O.BASIS_YYYYMM || O.ISO_WEEK AS WEEK_YYYYMMDD
             , 'M_' || O.BASIS_YYYYMM AS MONTH_YYYYMMDD
          FROM SCP_ANL_PSI_GLOBAL          A
             , SCM_SYS_CALENDAR_M          O
             , SCM_MST_SHEET_MEASURE       M
             , SCP_ANL_WORKING_TIME        D
             , SCP_ANL_TACT_TIME           E
         WHERE A.YYYYMMDD            = O.BASIS_YYYYMMDD
           AND M.PROGRAM_ID          = P_PROGRAM_ID
           AND M.COLUMN_NAME         = A.MEASURE
           AND A.DIVISION_ID         = D.DIVISION_ID
           AND A.ATTRIBUTE9          = D.OPERATION_ID
           AND A.FROM_SITE           = D.SCM_SITE_ID
           AND A.TRANSPORT_MODE_LINE = D.LINE_ID
           AND A.YYYYMMDD            = D.YYYYMMDD
           AND A.DIVISION_ID         = E.DIVISION_ID
           AND A.ATTRIBUTE9          = E.OPERATION_ID
           AND A.FROM_SITE           = E.SCM_SITE_ID
           AND A.TRANSPORT_MODE_LINE = E.LINE_ID
           AND (CASE WHEN A.OPERATION_GROUP = 'P' THEN A.ITEM_ID ELSE A.CELL_ITEM_ID END) = E.ITEM_ID
           AND A.YYYYMMDD            = E.YYYYMMDD
           AND A.DIVISION_ID         = P_DIVISION_ID
           AND A.PLAN_START_YYYYMMDD = P_PLAN_START_YYYYMMDD
           AND A.PLAN_TYPE           = P_PLAN_TYPE
           AND A.SEQ                 = V_SEQ
           AND A.YYYYMMDD           >= P_FROM_YYYYMMDD
           AND A.YYYYMMDD           <= P_TO_YYYYMMDD
           AND ( TO_NUMBER(V_CNT_USR_MEASURE) = 0 OR NVL(M.SORT_ORDER_NO, 0) > 0 )
           AND A.MEASURE             = 'PRODUCTION'
         GROUP BY A.DIVISION_ID
                , A.OPERATION_GROUP
                , A.FROM_SITE
                , A.ATTRIBUTE9
                , A.TRANSPORT_MODE_LINE
                , A.YYYYMMDD
                , O.BASIS_YYYYMM
                , O.ISO_WEEK
                , D.WORKING_TIME;

        /*******************************************************************************
         * 2. 과거 실적구간 temp
         *******************************************************************************/
        IF V_FROM_RESULT < V_TO_RESULT THEN

            INSERT INTO GT_SCP0031_RESULT
            (
                DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , TO_SITE2
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
              , MEASURE
              , SORT_ORDER_NO
              , COLUMN_LABEL_NAME
              , BOD_ID
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE3
            )
            SELECT DISTINCT A.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM GT_SCP0031_MAIN      A
             WHERE A.MEASURE IN ('PRODUCTION', 'SHIP_PLAN', 'ALLOCATION');

        END IF;

        /* Line Load(%) Insert */
        INSERT INTO GT_SCP0031_LOAD
        (
            DIVISION_ID
          , OPERATION_GROUP
          , CELL_ITEM_ID
          , ITEM_ID
          , TO_SITE
          , TO_SITE2
          , TO_BOH_QTY
          , FROM_BOH_QTY
          , INCOTERMS
          , FROM_SITE
          , TRANSPORT_MODE_LINE
          , MEASURE
          , B_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , QTY
          , ISO_WEEK
          , SORT_ORDER_NO
          , COLUMN_LABEL_NAME
          , BOD_ID
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE3
          , SUM_LOAD_QTY
          , WORKING_TIME
          , WEEK_YYYYMMDD
          , MONTH_YYYYMMDD
        )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.TO_SITE2
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , 'LINE_TOTAL_LOAD_ENGINE' AS MEASURE
             , A.B_YYYYMMDD
             , A.YYYYMMDD
             , A.YYYYMM
             , B.QTY
             , A.ISO_WEEK
             , M.SORT_ORDER_NO
             , M.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , M.ATTRIBUTE3
             , B.SUM_LOAD_QTY
             , B.WORKING_TIME
             , B.WEEK_YYYYMMDD
             , B.MONTH_YYYYMMDD
          FROM GT_SCP0031_MAIN          A
             , GT_SCP0031_LOADBASE      B
             , GT_SCP0031_MEASURE       M
         WHERE A.DIVISION_ID         = B.DIVISION_ID
           AND A.OPERATION_GROUP     = B.OPERATION_GROUP
           AND A.FROM_SITE           = B.FROM_SITE
           AND A.ATTRIBUTE9          = B.ATTRIBUTE9
           AND A.TRANSPORT_MODE_LINE = B.TRANSPORT_MODE_LINE
           AND A.B_YYYYMMDD          = B.B_YYYYMMDD
           AND M.COLUMN_NAME         = 'LINE_TOTAL_LOAD_ENGINE';

        /* Load율 개선(Daily) */
        INSERT INTO GT_SCP0031_MAIN
        (
            DIVISION_ID
          , OPERATION_GROUP
          , CELL_ITEM_ID
          , ITEM_ID
          , TO_SITE
          , TO_SITE2
          , TO_BOH_QTY
          , FROM_BOH_QTY
          , INCOTERMS
          , FROM_SITE
          , TRANSPORT_MODE_LINE
          , MEASURE
          , B_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , QTY
          , ISO_WEEK
          , SORT_ORDER_NO
          , COLUMN_LABEL_NAME
          , BOD_ID
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE3
        )
        SELECT A.DIVISION_ID
             , A.OPERATION_GROUP
             , A.CELL_ITEM_ID
             , A.ITEM_ID
             , A.TO_SITE
             , A.TO_SITE2
             , A.TO_BOH_QTY
             , A.FROM_BOH_QTY
             , A.INCOTERMS
             , A.FROM_SITE
             , A.TRANSPORT_MODE_LINE
             , A.MEASURE
             , A.B_YYYYMMDD
             , A.YYYYMMDD
             , A.YYYYMM
             , A.QTY
             , A.ISO_WEEK
             , A.SORT_ORDER_NO
             , A.COLUMN_LABEL_NAME
             , A.BOD_ID
             , A.ATTRIBUTE9
             , A.ATTRIBUTE10
             , A.ATTRIBUTE3
          FROM GT_SCP0031_LOAD      A;

        /* Load율 개선(Week) */
        INSERT INTO GT_SCP0031_MAIN
        (
            DIVISION_ID
          , OPERATION_GROUP
          , CELL_ITEM_ID
          , ITEM_ID
          , TO_SITE
          , TO_SITE2
          , TO_BOH_QTY
          , FROM_BOH_QTY
          , INCOTERMS
          , FROM_SITE
          , TRANSPORT_MODE_LINE
          , MEASURE
          , B_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , QTY
          , ISO_WEEK
          , SORT_ORDER_NO
          , COLUMN_LABEL_NAME
          , BOD_ID
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE3
        )
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , '-' AS B_YYYYMMDD
             , WEEK_YYYYMMDD AS YYYYMMDD
             , '-' AS YYYYMM
             , CASE WHEN SUM(WORKING_TIME) <= 0.0 THEN 0
                    ELSE NVL(( SUM(SUM_LOAD_QTY) / SUM(WORKING_TIME) ), 0) * 100
               END AS QTY
             , '-' AS ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
          FROM GT_SCP0031_LOAD
         GROUP BY DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , TO_SITE2
                , TO_BOH_QTY
                , FROM_BOH_QTY
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE_LINE
                , MEASURE
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID
                , ATTRIBUTE9
                , ATTRIBUTE10
                , ATTRIBUTE3
                , WEEK_YYYYMMDD
                , MONTH_YYYYMMDD;

        /* Load율 개선(Month) */
        INSERT INTO GT_SCP0031_MAIN
        (
            DIVISION_ID
          , OPERATION_GROUP
          , CELL_ITEM_ID
          , ITEM_ID
          , TO_SITE
          , TO_SITE2
          , TO_BOH_QTY
          , FROM_BOH_QTY
          , INCOTERMS
          , FROM_SITE
          , TRANSPORT_MODE_LINE
          , MEASURE
          , B_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , QTY
          , ISO_WEEK
          , SORT_ORDER_NO
          , COLUMN_LABEL_NAME
          , BOD_ID
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE3
        )
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , '-' AS B_YYYYMMDD
             , MONTH_YYYYMMDD AS YYYYMMDD
             , '-' AS YYYYMM
             , CASE WHEN SUM(WORKING_TIME) <= 0.0 THEN 0
                    ELSE NVL(( SUM(SUM_LOAD_QTY) / SUM(WORKING_TIME) ), 0) * 100
               END AS QTY
             , '-' AS ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
          FROM GT_SCP0031_LOAD
         GROUP BY DIVISION_ID
                , OPERATION_GROUP
                , CELL_ITEM_ID
                , ITEM_ID
                , TO_SITE
                , TO_SITE2
                , TO_BOH_QTY
                , FROM_BOH_QTY
                , INCOTERMS
                , FROM_SITE
                , TRANSPORT_MODE_LINE
                , MEASURE
                , SORT_ORDER_NO
                , COLUMN_LABEL_NAME
                , BOD_ID
                , ATTRIBUTE9
                , ATTRIBUTE10
                , ATTRIBUTE3
                , MONTH_YYYYMMDD;

        /* 생산/출하/매출 실적 insert */
        IF V_FROM_RESULT < V_TO_RESULT THEN

            /* 1. 생산실적 insert */
            INSERT INTO GT_SCP0031_MAIN
            (
                DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , TO_SITE2
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
              , MEASURE
              , B_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , QTY
              , ISO_WEEK
              , SORT_ORDER_NO
              , COLUMN_LABEL_NAME
              , BOD_ID
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE3
            )
            SELECT DISTINCT R.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') AS B_YYYYMMDD
                 , 'D_' || TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') AS YYYYMMDD
                 , C.BASIS_YYYYMM AS YYYYMM
                 , R.ACTUAL_GOOD_QTY AS QTY
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK AS ISO_WEEK
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM SCM_DNM_PRODUCT_RESULT_V      R
                 , SCM_SYS_CALENDAR_M            C
                 , SCP_MST_FINAL_ITEM            B
                 , GT_SCP0031_RESULT             A
             WHERE TO_CHAR(R.PLAN_DATE, 'YYYYMMDD') = C.BASIS_YYYYMMDD
               AND R.DIVISION_ID          = B.DIVISION_ID(+)
               AND R.ITEM_ID              = B.ITEM_ID(+)
               AND R.SCP_OPERATION_GROUP  = B.OPERATION_GROUP(+)
               AND A.MEASURE              = 'PRODUCTION'
               AND A.DIVISION_ID          = R.DIVISION_ID
               AND A.OPERATION_GROUP      = R.SCP_OPERATION_GROUP
               AND A.FROM_SITE            = R.SCM_SITE_ID
               AND A.ITEM_ID              = R.ITEM_ID
               AND A.ATTRIBUTE9           = R.OPERATION_ID
               AND A.TRANSPORT_MODE_LINE  = R.LINE_ID
               AND R.PLAN_DATE           >= TO_DATE(V_FROM_RESULT, 'YYYYMMDD')
               AND R.PLAN_DATE            < TO_DATE(V_TO_RESULT, 'YYYYMMDD')
               AND R.DIVISION_ID          = P_DIVISION_ID
               AND R.SCP_OPERATION_GROUP IN ('A', 'P')
               AND ( SUBSTR(R.OPERATION_ID, 1, 5) IN ( /* LOOKUP_TYPE 'SCP_PLAN_OPERATION' 에 정의된 공정만 조회 */
                                                       SELECT SEGMENT1 AS OPERATION_ID
                                                         FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                                                        WHERE LOOKUP_TYPE = 'SCP_PLAN_OPERATION'
                                                          AND SEGMENT1   <> 'F6000'
                                                          AND VALID_YN    = 'Y'
                                                     )
                     OR R.OPERATION_ID IN ( /* 외주PACKER의 업체코드 */
                                            SELECT PLANT_ID AS OPERATION_ID
                                              FROM SCM_MST_SITE
                                             WHERE 1 = 1
                                               AND DIVISION_ID = P_DIVISION_ID
                                               AND SITE_TYPE   = 'PLANT'
                                               AND OSP_YN      = 'Y'
                                               AND VALID_YN    = 'Y'
                                          ) );

            /* 2. 출하실적 insert */
            INSERT INTO GT_SCP0031_MAIN
            (
                DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , TO_SITE2
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
              , MEASURE
              , B_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , QTY
              , ISO_WEEK
              , SORT_ORDER_NO
              , COLUMN_LABEL_NAME
              , BOD_ID
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE3
            )
            SELECT R.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , R.EXFACTORY_DATE AS B_YYYYMMDD
                 , 'D_' || R.EXFACTORY_DATE AS YYYYMMDD
                 , C.BASIS_YYYYMM AS YYYYMM
                 , R.EXFACTORY_QTY AS QTY
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK AS ISO_WEEK
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM SCM_DNM_EXFACTORY_RESULT      R
                 , SCM_SYS_CALENDAR_M            C
                 , SCM_MST_SITE                  B
                 , GT_SCP0031_RESULT             A
             WHERE R.EXFACTORY_DATE     = C.BASIS_YYYYMMDD
               AND B.SCM_SITE_ID(+)     = R.TO_SCM_SITE_ID
               AND B.SITE_TYPE(+)       = 'PLANT'
               AND A.MEASURE            = 'SHIP_PLAN'
               AND A.DIVISION_ID        = R.DIVISION_ID
               AND A.ITEM_ID            = R.ITEM_ID
               AND A.FROM_SITE          = R.FROM_SCM_SITE_ID
               AND A.TO_SITE            = R.TO_SCM_SITE_ID
               AND A.TRANSPORT_MODE_LINE = R.TRANSPORT_MODE
               AND R.EXFACTORY_DATE    >= V_FROM_RESULT
               AND R.EXFACTORY_DATE     < V_TO_RESULT
               AND R.DIVISION_ID        = P_DIVISION_ID
               AND ( B.PLANT_ID IS NOT NULL OR (B.PLANT_ID IS NULL AND A.INCOTERMS = R.INCOTERMS) )   /* FG의 경우 incoterms 비교 */
               AND R.EXFACTORY_STATUS IN ('D20', 'D30', 'D40');

            /* 3. 매출실적 insert */
            INSERT INTO GT_SCP0031_MAIN
            (
                DIVISION_ID
              , OPERATION_GROUP
              , CELL_ITEM_ID
              , ITEM_ID
              , TO_SITE
              , TO_SITE2
              , TO_BOH_QTY
              , FROM_BOH_QTY
              , INCOTERMS
              , FROM_SITE
              , TRANSPORT_MODE_LINE
              , MEASURE
              , B_YYYYMMDD
              , YYYYMMDD
              , YYYYMM
              , QTY
              , ISO_WEEK
              , SORT_ORDER_NO
              , COLUMN_LABEL_NAME
              , BOD_ID
              , ATTRIBUTE9
              , ATTRIBUTE10
              , ATTRIBUTE3
            )
            SELECT R.DIVISION_ID
                 , A.OPERATION_GROUP
                 , A.CELL_ITEM_ID
                 , A.ITEM_ID
                 , A.TO_SITE
                 , A.TO_SITE2
                 , A.TO_BOH_QTY
                 , A.FROM_BOH_QTY
                 , A.INCOTERMS
                 , A.FROM_SITE
                 , A.TRANSPORT_MODE_LINE
                 , A.MEASURE
                 , R.YYYYMMDD AS B_YYYYMMDD
                 , 'D_' || R.YYYYMMDD AS YYYYMMDD
                 , C.BASIS_YYYYMM AS YYYYMM
                 , R.QTY AS QTY
                 , SUBSTR(C.BASIS_YYYYMM, -4) || C.ISO_WEEK AS ISO_WEEK
                 , A.SORT_ORDER_NO
                 , A.COLUMN_LABEL_NAME
                 , A.BOD_ID
                 , A.ATTRIBUTE9
                 , A.ATTRIBUTE10
                 , A.ATTRIBUTE3
              FROM DM_PLN_SALES_PLAN_RESULT      R
                 , SCM_SYS_CALENDAR_M            C
                 , GT_SCP0031_RESULT             A
             WHERE R.YYYYMMDD      = C.BASIS_YYYYMMDD
               AND A.MEASURE       = 'ALLOCATION'
               AND A.DIVISION_ID   = R.DIVISION_ID
               AND A.ITEM_ID       = R.ITEM_ID
               AND A.TO_SITE       = R.SCM_SITE_ID
               AND A.INCOTERMS     = R.INCOTERMS
               AND R.YYYYMMDD     >= V_FROM_RESULT
               AND R.YYYYMMDD      < V_TO_RESULT
               AND R.DIVISION_ID   = P_DIVISION_ID
               AND R.MEASURE       = 'RTF';

        END IF;

        /* 2021/11/02 Start UI 속도 개선 */
        INSERT INTO GT_SCP0031_FNL
        (
            DIVISION_ID
          , OPERATION_GROUP
          , CELL_ITEM_ID
          , ITEM_ID
          , TO_SITE
          , TO_SITE2
          , TO_BOH_QTY
          , FROM_BOH_QTY
          , INCOTERMS
          , FROM_SITE
          , TRANSPORT_MODE_LINE
          , MEASURE
          , B_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , QTY
          , ISO_WEEK
          , SORT_ORDER_NO
          , COLUMN_LABEL_NAME
          , BOD_ID
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE3
        )
        SELECT DIVISION_ID
             , OPERATION_GROUP
             , CELL_ITEM_ID
             , ITEM_ID
             , TO_SITE
             , TO_SITE2
             , TO_BOH_QTY
             , FROM_BOH_QTY
             , INCOTERMS
             , FROM_SITE
             , TRANSPORT_MODE_LINE
             , MEASURE
             , B_YYYYMMDD
             , YYYYMMDD
             , YYYYMM
             , QTY
             , ISO_WEEK
             , SORT_ORDER_NO
             , COLUMN_LABEL_NAME
             , BOD_ID
             , ATTRIBUTE9
             , ATTRIBUTE10
             , ATTRIBUTE3
          FROM GT_SCP0031_MAIN;

        /* chaan begin V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경) */
        INSERT INTO GT_SCP0031_FNL
        (
            DIVISION_ID
          , OPERATION_GROUP
          , CELL_ITEM_ID
          , ITEM_ID
          , TO_SITE
          , TO_SITE2
          , TO_BOH_QTY
          , FROM_BOH_QTY
          , INCOTERMS
          , FROM_SITE
          , TRANSPORT_MODE_LINE
          , MEASURE
          , B_YYYYMMDD
          , YYYYMMDD
          , YYYYMM
          , QTY
          , ISO_WEEK
          , SORT_ORDER_NO
          , COLUMN_LABEL_NAME
          , BOD_ID
          , ATTRIBUTE9
          , ATTRIBUTE10
          , ATTRIBUTE3
          , WEEK_YN
          , MONTH_YN
        )
        SELECT F.DIVISION_ID
             , F.OPERATION_GROUP
             , F.CELL_ITEM_ID
             , F.ITEM_ID
             , F.TO_SITE
             , F.TO_SITE2
             , F.TO_BOH_QTY
             , F.FROM_BOH_QTY
             , F.INCOTERMS
             , F.FROM_SITE
             , F.TRANSPORT_MODE_LINE
             , F.MEASURE
             , F.B_YYYYMMDD
             , F.YYYYMMDD
             , F.YYYYMM
             , F.QTY
             , F.ISO_WEEK
             , C.SORT_ORDER_NO
             , C.COLUMN_LABEL_NAME
             , F.BOD_ID
             , F.ATTRIBUTE9
             , F.ATTRIBUTE10
             , C.ATTRIBUTE3
             , F.WEEK_YN
             , F.MONTH_YN
          FROM (
                 SELECT S.DIVISION_ID
                      , S.OPERATION_GROUP
                      , S.CELL_ITEM_ID
                      , S.ITEM_ID
                      , S.TO_SITE
                      , S.TO_SITE2
                      , S.TO_BOH_QTY
                      , S.FROM_BOH_QTY
                      , S.INCOTERMS
                      , S.FROM_SITE
                      , S.TRANSPORT_MODE_LINE
                      , 'GAP' AS MEASURE
                      , S.B_YYYYMMDD
                      , S.YYYYMMDD
                      , S.YYYYMM
                      , (NVL(B.QTY, 0) - NVL(S.QTY, 0)) AS QTY
                      , S.ISO_WEEK
                      , S.SORT_ORDER_NO
                      , S.COLUMN_LABEL_NAME
                      , S.BOD_ID
                      , S.ATTRIBUTE9
                      , S.ATTRIBUTE10
                      , S.ATTRIBUTE3
                      , S.WEEK_YN
                      , S.MONTH_YN
                   FROM ( SELECT *
                            FROM GT_SCP0031_FNL
                           WHERE MEASURE = 'SAFETY_STOCK'
                        )  S
                      , ( SELECT *
                            FROM GT_SCP0031_FNL
                           WHERE MEASURE = 'WH_IN_BALANCE'
                        )  B
                  /* Safet Stocck 을 기준으로 하므로 Safety Stock 행이 없으면 Gap 행도 만들 수 없음 */
                  WHERE S.DIVISION_ID          = B.DIVISION_ID(+)
                    AND S.OPERATION_GROUP      = B.OPERATION_GROUP(+)
                    AND S.CELL_ITEM_ID         = B.CELL_ITEM_ID(+)
                    AND S.ITEM_ID              = B.ITEM_ID(+)
                    AND S.TO_SITE              = B.TO_SITE(+)
                    AND S.TO_SITE2             = B.TO_SITE2(+)
                    AND S.INCOTERMS            = B.INCOTERMS(+)
                    AND S.FROM_SITE            = B.FROM_SITE(+)
                    AND S.TRANSPORT_MODE_LINE  = B.TRANSPORT_MODE_LINE(+)
                    AND S.B_YYYYMMDD           = B.B_YYYYMMDD(+)
                    AND S.YYYYMMDD             = B.YYYYMMDD(+)
                    AND S.YYYYMM               = B.YYYYMM(+)
                    AND S.ISO_WEEK             = B.ISO_WEEK(+)
                    AND S.BOD_ID               = B.BOD_ID(+)
               )  F
             , ( SELECT M.PROGRAM_ID
                      , M.SHEET_NAME
                      , M.COLUMN_NAME
                      , M.COLUMN_LABEL_NAME
                      , T.SORT_ORDER_NO
                      , 'GAP' AS MEASURE
                      , M.ATTRIBUTE9
                      , M.ATTRIBUTE10
                      , M.ATTRIBUTE3
                   FROM SCM_MST_SHEET_MEASURE      M
                      , SCM_MST_TITLESET_USER      T
                  WHERE 1 = 1
                    AND M.PROGRAM_ID  = T.PROGRAM_ID
                    AND M.SHEET_NAME  = T.SHEET_NAME
                    AND M.COLUMN_NAME = T.COLUMN_NAME
                    AND M.COLUMN_NAME = 'GAP'
                    AND T.PROGRAM_ID  = P_PROGRAM_ID
                    AND T.SHEET_NAME  = P_SHEET_NAME
                    AND T.USER_ID     = P_USER_ID
               )  C
         WHERE F.MEASURE = C.MEASURE(+);
        /* chaan end V1.5 VMI 안전재고설정 추가 - Measure가 없는 Gap용 가상행을 추가함(Safety Stock 행 복사후 Measure, ATTRIBUTE3-라인색상 등만 Gap용으로 변경) */

        UPDATE GT_SCP0031_FNL      A
           SET A.WEEK_YN = 'Y'
         WHERE A.MEASURE IN ('MODEL_INVENTORY', 'WH_IN_BALANCE', 'BALANCE', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'SAFETY_STOCK', 'GAP', 'DIO')
           AND EXISTS ( SELECT 1
                          FROM ( SELECT ISO_WEEK
                                      , PARTIAL_WEEK_NAME
                                      , CALENDAR_YYYY
                                      , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
                                   FROM SCM_SYS_CALENDAR_M
                                  WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                    AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD   /* 마지막 구간 오류 발생으로 1개월 더함 */
                                  GROUP BY ISO_WEEK
                                         , PARTIAL_WEEK_NAME
                                         , CALENDAR_YYYY
                               )  XA
                         WHERE SUBSTR(A.YYYYMMDD, -8) = XA.YYYYMMDD
                      );

        UPDATE GT_SCP0031_FNL      A
           SET A.MONTH_YN = 'Y'
         WHERE A.MEASURE IN ('MODEL_INVENTORY', 'WH_IN_BALANCE', 'BALANCE', 'CHAR_AVAILABLE', 'ACTIVATE_PROGRESS', 'SAFETY_STOCK', 'GAP', 'DIO')
           AND EXISTS ( SELECT 1
                          FROM ( SELECT BASIS_YYYYMM
                                      , MAX(BASIS_YYYYMMDD) AS YYYYMMDD
                                   FROM SCM_SYS_CALENDAR_M
                                  WHERE BASIS_YYYYMMDD >= P_FROM_YYYYMMDD
                                    AND BASIS_YYYYMMDD <= P_TO_YYYYMMDD   /* 마지막 구간 오류 발생으로 1개월 더함 */
                                  GROUP BY BASIS_YYYYMM
                               )  XA
                         WHERE SUBSTR(A.YYYYMMDD, -8) = XA.YYYYMMDD
                      );
        /* 2021/11/02 End UI 속도 개선 */

        /*******************************************************************************
         * PIVOIT처리
         *   집계 대상 날짜가 조회 구간에 따라 달라져 컬럼 자체가 가변이므로
         *   이 구간만 동적 SQL 로 둔다(06 보고서 6항)
         *******************************************************************************/
        /* PIVOIT 대상 날짜문자열 생성 */
        V_QRY_SUM := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_QRY_SUM, TRUE);

        FOR R IN ( SELECT YYYYMMDD
                     FROM ( SELECT 'W_' || A.BASIS_YYYYMM || A.ISO_WEEK AS YYYYMMDD
                                 , A.BASIS_START_DATE || '21' AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M      A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND ( V_BUCKET = 'DAILY' OR V_BUCKET = 'WEEKLY' )
                             GROUP BY A.BASIS_YYYYMM
                                    , A.ISO_WEEK
                                    , A.BASIS_START_DATE
                            UNION ALL
                            SELECT 'M_' || A.BASIS_YYYYMM AS YYYYMMDD
                                 , MIN(A.BASIS_START_DATE) || '01' AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M      A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                             GROUP BY A.BASIS_YYYYMM
                                    , A.MONTH_NAME
                            UNION ALL
                            SELECT 'D_' || A.BASIS_YYYYMMDD AS YYYYMMDD
                                 , A.BASIS_YYYYMMDD || '31' AS SORT_ORDER_NO
                              FROM SCM_SYS_CALENDAR_M      A
                             WHERE A.BASIS_YYYYMMDD BETWEEN P_FROM_YYYYMMDD AND P_TO_YYYYMMDD
                               AND V_BUCKET = 'DAILY'
                             GROUP BY A.BASIS_YYYYMMDD
                          )  IA
                    ORDER BY SORT_ORDER_NO
                 )
        LOOP

            IF INSTR(R.YYYYMMDD, 'M_') = 1 THEN
                DBMS_LOB.WRITEAPPEND(V_QRY_SUM, LENGTH(','), ',');
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    'SUM( CASE WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN     (' || C_MEASURE_BAL || ') AND MONTH_YN = ''Y''       THEN CAST(QTY AS NUMBER(15,2)) '
                 || 'WHEN YYYYMM = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE NOT IN (' || C_MEASURE_NOTIN || ') THEN CAST(QTY AS NUMBER(15,2)) ELSE 0 END   ) AS ' || R.YYYYMMDD || CHR(10)));
            ELSIF INSTR(R.YYYYMMDD, 'W_') = 1 THEN
                DBMS_LOB.WRITEAPPEND(V_QRY_SUM, LENGTH(','), ',');
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    'SUM( CASE WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE IN     (' || C_MEASURE_BAL || ') AND WEEK_YN = ''Y''        THEN CAST(QTY AS NUMBER(15,2)) '
                 || 'WHEN ISO_WEEK = SUBSTR(''' || R.YYYYMMDD || ''', -6) AND MEASURE NOT IN (' || C_MEASURE_NOTIN || ') THEN CAST(QTY AS NUMBER(15,2)) ELSE 0 END   ) AS ' || R.YYYYMMDD || CHR(10)));
            ELSIF INSTR(R.YYYYMMDD, 'D_') = 1 THEN
                DBMS_LOB.WRITEAPPEND(V_QRY_SUM, LENGTH(','), ',');
                DBMS_LOB.APPEND(V_QRY_SUM, TO_CLOB(
                    ' SUM(CASE WHEN YYYYMMDD = ''' || R.YYYYMMDD || ''' THEN QTY END ) AS ' || R.YYYYMMDD || CHR(10)));
            END IF;

        END LOOP;

        V_EXEC := EMPTY_CLOB();
        DBMS_LOB.CREATETEMPORARY(V_EXEC, TRUE);

        /* 주의 : 조회항목 변경 시 M_,W_,D_ 컬럼이 항상 뒤에 나와야함
                  UI에서 합계계산 시 COLUMN COUNT INDEX 계산 */
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            'SELECT CASE WHEN A.BOD_ID = ''-'' THEN ''-'' ELSE TO_CHAR(B.LT_TOTAL) END AS LT_DAY' || CHR(10)
         || '     , NVL(NULLIF(A.CELL_QTY_PACK_T, ''''), ''-'') AS CELL_QTY_PACK' || CHR(10)
         || '     , NVL(D.SEGMENT2, ''-'') AS OPERATION_GROUP_NAME' || CHR(10)
         || '     , NVL(( SELECT H.DEPT_NAME_KO' || CHR(10)
         || '               FROM SCM_MST_SSO_DEPT_INFO      H' || CHR(10)
         -- 2026.09.30 AJS 부서 열쇠를 사이트 대표 부서 뷰로 변경 (START)
         -- || '              WHERE H.DEPT_ID = CASE WHEN ' || CASE WHEN V_EE_YN = 'Y' THEN 'A.ORIGIN_TO_DIVISION_ID' ELSE 'A.DIVISION_ID' END || ' = ''40'' THEN G.DEPT_ID ELSE E.DEPT_ID END' || CHR(10)
         || '              WHERE H.DEPT_ID = CASE WHEN ' || CASE WHEN V_EE_YN = 'Y' THEN 'A.ORIGIN_TO_DIVISION_ID' ELSE 'A.DIVISION_ID' END || ' = ''40'' THEN G.DEPT_ID ELSE C.DEPT_ID END' || CHR(10)
         -- 2026.09.30 AJS 부서 열쇠를 사이트 대표 부서 뷰로 변경 (END)
         || '                AND ROWNUM = 1 ), ''-'') AS DEPT_NAME' || CHR(10)
         || '     , A.*' || CHR(10)
         || '     , FN_GET_SCP_CELL_TYPE_SORT(V.CELL_TYPE) AS CELL_TYPE_SORT' || CHR(10)   /* 20230613 Final Item) Cell Type Sort */
         || '  FROM ( SELECT A.DIVISION_ID' || CHR(10)
         || '              , A.OPERATION_GROUP' || CHR(10)
         || '              , A.CELL_ITEM_ID' || CHR(10)
         || '              , A.ITEM_ID' || CHR(10)
         || '              , ( SELECT (CASE WHEN X.NICK_NAME IS NULL THEN ''-''  WHEN X.NICK_NAME = ''''    THEN ''-''  ELSE X.NICK_NAME END) FROM SCM_MST_ITEM_SN X  WHERE  X.ITEM_ID  = A.ITEM_ID AND X.NICK_NAME IS NOT NULL AND ROWNUM = 1 ) AS NICK_NAME' || CHR(10)
         || '              , CASE WHEN A.OPERATION_GROUP = ''A'' THEN ''-'' ELSE ( SELECT TO_CHAR(CEIL(V.ACCUMULATED_CHILD_QTY))' || CHR(10)
         || '                                                                       FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V V' || CHR(10)
         || '                                                                      WHERE V.DIVISION_ID = A.DIVISION_ID AND V.OPERATION_GROUP_ID = ''A''' || CHR(10)
         || '                                                                        AND V.MODEL_ID = A.ITEM_ID AND V.CHILD_ITEM_ID = A.CELL_ITEM_ID' || CHR(10)
         || '                                                                        AND ROWNUM = 1 ) END AS CELL_QTY_PACK_T' || CHR(10)
         || '              , A.TO_SITE' || CHR(10)
         || '              , A.TO_SITE2' || CHR(10)
         || '              , NVL(NULLIF(( SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.TO_SITE AND ROWNUM = 1 ), ''''), ''-'') AS TO_SITE_DESCRIPTION' || CHR(10)
         || '              , A.TO_BOH_QTY' || CHR(10)
         || '              , A.FROM_BOH_QTY' || CHR(10)
         || '              , NVL(NULLIF(A.INCOTERMS, ''''), ''-'') AS INCOTERMS' || CHR(10)
         || '              , A.FROM_SITE' || CHR(10)
         || '              , NVL(NULLIF(( SELECT M.SITE_DESCRIPTION FROM SCM_MST_SITE M WHERE M.SCM_SITE_ID = A.FROM_SITE AND ROWNUM = 1 ), ''''), ''-'') AS FROM_SITE_DESCRIPTION' || CHR(10)
         || '              , NVL(NULLIF(A.TRANSPORT_MODE_LINE, ''''), ''-'') AS TRANSPORT_MODE_LINE' || CHR(10)
         || '              , A.BOD_ID' || CHR(10)
         || '              , A.ATTRIBUTE10' || CHR(10)
         || '              , A.MEASURE' || CHR(10)
         || '              , A.COLUMN_LABEL_NAME AS MEASURE_LABEL' || CHR(10)
         || '              , A.SORT_ORDER_NO' || CHR(10)
         || '              , A.ATTRIBUTE3 AS MEASURE_COLOR' || CHR(10)));

        DBMS_LOB.APPEND(V_EXEC, V_QRY_SUM);

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '           FROM GT_SCP0031_FNL      A' || CHR(10)
         || '          GROUP BY A.DIVISION_ID' || CHR(10)
         || '                 , A.OPERATION_GROUP' || CHR(10)
         || '                 , A.CELL_ITEM_ID' || CHR(10)
         || '                 , A.ITEM_ID' || CHR(10)
         || '                 , A.TO_SITE' || CHR(10)
         || '                 , A.TO_SITE2' || CHR(10)
         || '                 , A.TO_BOH_QTY' || CHR(10)
         || '                 , A.FROM_BOH_QTY' || CHR(10)
         || '                 , A.INCOTERMS' || CHR(10)
         || '                 , A.FROM_SITE' || CHR(10)
         || '                 , A.TRANSPORT_MODE_LINE' || CHR(10)
         || '                 , A.BOD_ID' || CHR(10)
         || '                 , A.ATTRIBUTE10' || CHR(10)
         || '                 , A.MEASURE' || CHR(10)
         || '                 , A.SORT_ORDER_NO' || CHR(10)
         || '                 , A.COLUMN_LABEL_NAME' || CHR(10)
         || '                 , A.ATTRIBUTE3' || CHR(10)
         || '       )  A' || CHR(10)
         || '     , SCP_ANL_BOD_N_V_PLAN_H         B' || CHR(10)
         || '     , SCM_ADM_LOOKUP_MASTER_DETAIL   D' || CHR(10)
         -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰를 덧붙임 (START)
         || '     , SCM_MST_SITE                   E' || CHR(10)
         || '     , SCM_MST_SITE_DEPT_REP_V    C' || CHR(10)
         -- 2026.09.30 AJS SCM_MST_SITE.DEPT_ID 삭제에 따라 사이트 대표 부서 뷰를 덧붙임 (END)
         || '     , ( SELECT XA.*' || CHR(10)
         || '              , ROW_NUMBER() OVER (PARTITION BY XA.DIVISION_ID, XA.SCM_SITE_ID, XA.ITEM_ID ORDER BY XA.PROJECT_CODE) AS RANK_NUMBER' || CHR(10)
         || '           FROM SCM_MST_SITE_ITEM      XA' || CHR(10)
         || '          WHERE XA.VALID_YN = ''Y''' || CHR(10)
         || '       )  F' || CHR(10)
         || '     , SCM_MST_SSO_USER_INFO          G' || CHR(10)
         || '     , SCM_MST_FINAL_ITEM_V           V' || CHR(10)
         || ' WHERE B.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
         || '   AND B.BOD_ID(+)      = A.BOD_ID' || CHR(10)
         || '   AND B.FROM_SITE(+)   = A.FROM_SITE' || CHR(10)
         || '   AND B.PLAN_NAME(+)   = ''' || P_PLAN_START_YYYYMMDD || '''' || CHR(10)
         || '   AND B.PLAN_TYPE(+)   = ''' || P_PLAN_TYPE || '''' || CHR(10)
         /* ★차수가 비면 AS-IS 는 조회문 전체가 값 없음이 되어 결과 0건을 돌려준다.
            Oracle 은 빈 값을 빈 글자로 이어 붙여 끊긴 문장을 만들므로 조건으로 막아 같은 결과가 되게 한다. */
         || CASE WHEN V_SEQ IS NULL
                 THEN '   AND 1 = 0' || CHR(10)
                 ELSE '   AND B.PLAN_SEQ(+)    = ' || TO_CHAR(V_SEQ) || CHR(10)
            END
         || '   AND D.LOOKUP_TYPE(+) = ''OPERATION_GROUP''' || CHR(10)
         || '   AND D.SEGMENT1(+)    = A.OPERATION_GROUP' || CHR(10)));

        /********** DEPT NAME START **********/
        IF V_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND E.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
             || '   AND E.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND E.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
             || '   AND E.SCM_SITE_ID(+) = A.TO_SITE2' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB('   AND E.VALID_YN(+)    = ''Y''' || CHR(10)));

        -- 2026.09.30 AJS 사이트 대표 부서 뷰 조인 추가 (START)
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB('   AND C.DIVISION_ID(+) = E.DIVISION_ID' || CHR(10)
                                      || '   AND C.SCM_SITE_ID(+) = E.SCM_SITE_ID' || CHR(10)));
        -- 2026.09.30 AJS 사이트 대표 부서 뷰 조인 추가 (END)

        IF V_EE_YN = 'N' THEN
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND F.DIVISION_ID(+) = A.DIVISION_ID' || CHR(10)
             || '   AND F.SCM_SITE_ID(+) = A.TO_SITE' || CHR(10)));
        ELSE
            DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
                '   AND F.DIVISION_ID(+) = A.ORIGIN_TO_DIVISION_ID' || CHR(10)
             || '   AND F.SCM_SITE_ID(+) = A.TO_SITE2' || CHR(10)));
        END IF;

        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '   AND F.ITEM_ID(+)     = A.ITEM_ID' || CHR(10)
         || '   AND F.VALID_YN(+)    = ''Y''' || CHR(10)
         || '   AND F.RANK_NUMBER(+) = 1' || CHR(10)   /* PROJECT_CODE 가 없어 1건만 가져오기 위해 처리 */
         || '   AND SUBSTR(F.OWNER, 1, CASE WHEN INSTR(F.OWNER, '','') = 0 THEN LENGTH(RTRIM(F.OWNER)) ELSE INSTR(F.OWNER, '','') - 1 END) = G.USER_ID(+)' || CHR(10)));
        /********** DEPT NAME END **********/

        /* 20220125 vadabi3 DC Link Sort 적용 (Rack_YN, DC_YN Sort 적용) */
        DBMS_LOB.APPEND(V_EXEC, TO_CLOB(
            '   AND V.DIVISION_ID(+)         = A.DIVISION_ID' || CHR(10)
         || '   AND V.ITEM_ID(+)             = A.ITEM_ID' || CHR(10)
         || '   AND V.OPERATION_GROUP_ID(+)  = A.OPERATION_GROUP' || CHR(10)
         || '   AND V.DIVISION_ID(+)         = :B_DIVISION_ID' || CHR(10)   /* 품목 뷰를 조회 사업부로 한정 (적재 자료는 모두 조회 사업부) */   --  2026.10.06 AJS
         || ' ORDER BY A.DIVISION_ID' || CHR(10)
         || '        , A.CELL_ITEM_ID' || CHR(10)
         || '        , A.OPERATION_GROUP DESC NULLS LAST' || CHR(10)
         || '        , V.RACK_YN DESC NULLS LAST' || CHR(10)
         || '        , V.DC_YN DESC NULLS LAST' || CHR(10)
         || '        , CELL_TYPE_SORT' || CHR(10)
         || '        , A.ITEM_ID' || CHR(10)
         || '        , A.ATTRIBUTE10 NULLS FIRST' || CHR(10)
         || '        , NLSSORT(A.TO_SITE, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)
         || '        , A.INCOTERMS' || CHR(10)
         || '        , A.FROM_SITE' || CHR(10)
         || '        , A.SORT_ORDER_NO NULLS FIRST' || CHR(10)
         || '        , A.TRANSPORT_MODE_LINE' || CHR(10)
         || '        , A.BOD_ID' || CHR(10)
         || '        , NLSSORT(A.MEASURE_LABEL, ''NLS_SORT=BINARY_CI'') DESC NULLS LAST' || CHR(10)));

--        OPEN O_RC1 FOR V_EXEC;                                                                   --  2026.10.06 AJS
        OPEN O_RC1 FOR V_EXEC USING P_DIVISION_ID;                                                   --  2026.10.06 AJS

        DBMS_LOB.FREETEMPORARY(V_QRY_SUM);

        OPEN O_RESULT_CURSOR FOR SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    EXCEPTION
        WHEN OTHERS THEN
            V_ERR_MSG := SQLERRM;
            OPEN O_RESULT_CURSOR FOR SELECT '-1' AS CODE, V_ERR_MSG AS MSG, TO_CHAR(0) AS EVENT FROM DUAL;

    END P_SCP0031_GET_GLOBAL_PSI;

END PKG_SCP0031;