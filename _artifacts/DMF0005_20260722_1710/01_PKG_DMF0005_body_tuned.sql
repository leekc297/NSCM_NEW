
  CREATE OR REPLACE EDITIONABLE PACKAGE BODY "SCM_MGR"."PKG_DMF0005" IS

PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION (
      P_DIVISION_ID         IN VARCHAR2
    , P_DEPT_ID             IN VARCHAR2
    , P_END_CUSTOMER        IN VARCHAR2
    , P_SCM_SITE_ID         IN VARCHAR2
    , P_PROJECT_CODE        IN VARCHAR2
    , P_ITEM_ID             IN VARCHAR2
    , P_VALID_YN            IN VARCHAR2
    , P_OWNER               IN VARCHAR2
    , P_USER_ID          IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
)
/*
 * Program ID   : P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION
 * Description  : P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION
 * Program History
 *===========================================================================================================
 *   Date       In Charge      Description
 *===========================================================================================================
 * 2026.03.16   park.choyi     [PJ20264226] NextSCM Pilot 화면 및 메뉴 개발
 */

IS
    V_GROUP_ID VARCHAR2(50) := '';

    V_ROW_CNT  NUMBER := 0;

BEGIN
    SELECT CASE WHEN COUNT(*) > 0 THEN 'ADMIN' ELSE '' END
      INTO V_GROUP_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'
       AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID
                         FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                         WHERE  USER_ID = P_USER_ID
                         AND    UNIT_TP_CD = 'D'
                         AND    EDIT_YN = 'Y'
                         AND    USE_YN = 'Y'
                         AND    UNIT_ID = P_DIVISION_ID )
     ;

    -- [PERF-DMF0005 20260722] P1: 멀티선택 필터 GTT 사전적재 (FN_SPLITSTRING 인라인 제거)
    --  값이 있을 때만 적재. 없음/'ALL' 이면 미적재 -> 쿼리 FILTER 가 GTT 접근 자체를 생략(runtime skip)
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_TEAM_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_CUSTOMER;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_VALID_YN;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE;
    DELETE FROM SCM_MGR.GT_GGET_SPLIT_OWNER;

    IF P_DEPT_ID IS NOT NULL AND P_DEPT_ID <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_TEAM_ID (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_DEPT_ID, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF P_END_CUSTOMER IS NOT NULL AND P_END_CUSTOMER <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_CUSTOMER (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_END_CUSTOMER, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF P_SCM_SITE_ID IS NOT NULL AND P_SCM_SITE_ID <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_SCM_SITE_ID, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF P_VALID_YN IS NOT NULL AND P_VALID_YN <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_VALID_YN (TOK)
        SELECT VALUE FROM TABLE(FN_SPLITSTRING(P_VALID_YN, ',')) WHERE VALUE IS NOT NULL;
    END IF;

    IF NVL(NULLIF(TRIM(P_ITEM_ID), ''), 'ALL') <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_ITEM_ID (TOK)
        SELECT TRIM(VALUE) FROM TABLE(FN_SPLITSTRING(P_ITEM_ID, ',')) WHERE TRIM(VALUE) IS NOT NULL;
    END IF;

    IF NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE (TOK)
        SELECT TRIM(VALUE) FROM TABLE(FN_SPLITSTRING(P_PROJECT_CODE, ',')) WHERE TRIM(VALUE) IS NOT NULL;
    END IF;

    IF NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') <> 'ALL' THEN
        INSERT INTO SCM_MGR.GT_GGET_SPLIT_OWNER (TOK)
        SELECT TRIM(VALUE) FROM TABLE(FN_SPLITSTRING(P_OWNER, ',')) WHERE TRIM(VALUE) IS NOT NULL;
    END IF;

    OPEN O_RC1 FOR
    WITH
      ITEM_AGG AS (
          SELECT
                T.DIVISION_ID
              , T.ITEM_ID
              , MAX(T.ITEM_NAME) AS ITEM_NAME
              , MAX(T.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
              , MAX(T.NICK_NAME) AS NICK_NAME
              , CASE MIN(CASE WHEN T.ITEM_TYPE = 'P' THEN 1
                              WHEN T.ITEM_TYPE = 'H' THEN 2
                              WHEN T.ITEM_TYPE = 'Q' THEN 3
                              ELSE 4 END)
                    WHEN 1 THEN 'P'
                    WHEN 2 THEN 'H'
                    WHEN 3 THEN 'Q'
                    ELSE 'R'
                END AS ITEM_TYPE
              , MAX(T.ENERGE) AS ENERGE_WH
              , MAX(T.CELL_TYPE) AS CELL_TYPE_CD
              , MAX(T.ACTIVE_FLAG) AS MDM_ACTIVE_FLAG -- [PERF-DMF0005 20260722] P6a: ISV.ACTIVE_FLAG 등가
          FROM SCM_MST_ITEM_SN T
          WHERE T.DIVISION_ID = P_DIVISION_ID
          GROUP BY T.DIVISION_ID, T.ITEM_ID
      ),
      CELL_TYPE_LKP AS (
          SELECT SEGMENT1 AS CELL_TYPE_CD
               , SEGMENT2 AS CELL_TYPE_NM
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL
          WHERE LOOKUP_TYPE = 'CELL_TYPE'
            AND VALID_YN = 'Y'
      ),
      CUST_MODEL AS (
          SELECT
                DIVISION_ID
              , SCM_SITE_ID
              , PROJECT_CODE
              , ITEM_ID
              , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
          FROM DM_MST_CUSTOMER_MODEL
          WHERE VALID_YN = 'Y'
          GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
      ),
      /* [PERF-DMF0005 20260722] P2: F_ITEM/F_PROJECT/F_OWNER CTE 제거 (GT_GGET_SPLIT_* 사전적재로 대체)
         + OWNER_NAME 은 행별(52,526회) 함수 호출 대신 DISTINCT OWNER(수백건)만 1회씩 호출 */
      OWNER_NM AS (
          SELECT O.OWNER
               , FN_GET_MULTI_OWNER_NAME(O.OWNER, ',', '1') AS OWNER_NAME
          FROM ( SELECT DISTINCT SI0.OWNER
                 FROM SCM_MST_SITE_ITEM SI0
                 WHERE SI0.DIVISION_ID = P_DIVISION_ID
                   AND SI0.OWNER IS NOT NULL ) O
      ),

    /* 2) BASE */
    BASE AS (
        SELECT
              SI.DIVISION_ID
            , SI.SCM_SITE_ID
            , SI.PROJECT_CODE
            , SI.DEPT_ID AS DEPT_ID
            , DI.DEPT_NAME_KO AS TEAM_NAME
            , SI.ITEM_ID
            , SI.CUST_GROUP
            , CASE WHEN SI.DIVISION_ID = '40' THEN SI.PROJECT_CODE ELSE ST.END_CUSTOMER END AS END_CUSTOMER
            , SC.SOLDTO_CODE
            , SC.SHIPTO_CODE
            , ST.SOLDTO_CUSTOMER
            , SI.OWNER
            , ONM.OWNER_NAME AS OWNER_NAME -- [PERF-DMF0005 20260722] P3: 행별 함수 -> OWNER_NM 조인
            , SI.SALES_PLAN_ADJUST_YN
            , IA.ITEM_TYPE -- [PERF-DMF0005 20260722] P6b
            , IA.ITEM_CLASS_NAME -- [PERF-DMF0005 20260722] P6b
            , IA.ITEM_NAME -- [PERF-DMF0005 20260722] P6b
            , IA.NICK_NAME -- [PERF-DMF0005 20260722] P6b
            , SI.SALES_COMPANY
            , SI.SALES_PLANT
            , SI.BPMS_EXIST
            , SI.CELL_PER_CAR
            , SI.CELL_PER_MODULE
            , CASE
                  WHEN NVL(SI.CELL_PER_MODULE, 0) = 0 THEN NULL
                  ELSE SI.CELL_PER_CAR / SI.CELL_PER_MODULE
              END AS MODULE_PER_CAR
            , SI.ATTRIBUTE6
            , SI.EDI_LT
            , SI.SCP_VMI_LT AS VMI_LT

            , CASE WHEN SI.DIVISION_ID LIKE '81%' THEN TO_NUMBER(SI.ATTRIBUTE8) ELSE 0 END AS KWH
            --, TO_NUMBER(SI.ATTRIBUTE8) AS KWH
            , SI.PROJECT_INFO
            , PRJ.PROJECT_NAME
            , PRJ.PROJECT_STATUS
            , PRJ.PROJECT_OWNER
            , SI.PRJ_OWNR_ID
            , SI.ATTRIBUTE5
            , NVL(SI.VALID_YN, 'Y') AS VALID_YN
            , SI.LAST_UPDATE_DATE
            , SI.LAST_UPDATED_BY
            , IA.MDM_ACTIVE_FLAG AS MDM_ACTIVE -- [PERF-DMF0005 20260722] P6b
            , IA.ENERGE_WH
            , NVL(IA.CELL_TYPE_CD, SI.ATTRIBUTE10) AS CELL_TYPE_CD
            , CT.CELL_TYPE_NM AS CELL_TYPE
            , SI.ATTRIBUTE9
            , SI.ATTRIBUTE4
            , CM.CUSTOMER_MODEL
        FROM SCM_MST_SITE_ITEM SI
        JOIN SCM_MST_SITE ST
          ON ST.DIVISION_ID = SI.DIVISION_ID
         AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
         AND ST.SITE_TYPE = 'SALES'
        LEFT JOIN SCM_MST_SITE_CUSTOMER SC
          ON SC.DIVISION_ID = SI.DIVISION_ID
         AND SC.SCM_SITE_ID = SI.SCM_SITE_ID
         AND SC.REP_YN = 'Y'
         AND SC.VALID_YN = 'Y'
         AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')
        /* [PERF-DMF0005 20260722] P6c: DM_MST_ITEM_SINGLE_V 조인 제거 — ITEM_AGG(IA) 등가 대체 */
        LEFT JOIN SCM_MST_PROJECT PRJ
          ON PRJ.DIVISION_ID = SI.DIVISION_ID
         AND PRJ.PROJECT_CODE = SI.PROJECT_CODE
        LEFT JOIN SCM_MST_SSO_DEPT_INFO DI
          ON DI.DEPT_ID = SI.DEPT_ID
        LEFT JOIN ITEM_AGG IA
               ON IA.DIVISION_ID = SI.DIVISION_ID
              AND IA.ITEM_ID = SI.ITEM_ID
        LEFT JOIN CELL_TYPE_LKP CT                                      -- 추가
               ON CT.CELL_TYPE_CD = NVL(IA.CELL_TYPE_CD, SI.ATTRIBUTE10)
        LEFT JOIN CUST_MODEL CM
          ON CM.DIVISION_ID = SI.DIVISION_ID
         AND CM.SCM_SITE_ID = SI.SCM_SITE_ID
         AND CM.PROJECT_CODE = SI.PROJECT_CODE
         AND CM.ITEM_ID = SI.ITEM_ID
        LEFT JOIN OWNER_NM ONM -- [PERF-DMF0005 20260722] P4
          ON ONM.OWNER = SI.OWNER
        WHERE SI.DIVISION_ID = P_DIVISION_ID
        /*
           , SCM_MST_SITE ST
           , SCM_MST_SITE_CUSTOMER SC
           , DM_MST_ITEM_SINGLE_V ISV
           , SCM_MST_PROJECT PRJ
           , SCM_MST_SSO_DEPT_INFO DI
           , ITEM_AGG IA
           , CELL_TYPE_LKP CT
           , CUST_MODEL CM
        WHERE SI.DIVISION_ID = P_DIVISION_ID
          AND ST.DIVISION_ID = SI.DIVISION_ID
          AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
          AND ST.SITE_TYPE = 'SALES'
          AND SC.DIVISION_ID(+) = SI.DIVISION_ID
          AND SC.SCM_SITE_ID(+) = SI.SCM_SITE_ID
          AND SC.REP_YN(+) = 'Y'
          AND SC.VALID_YN(+) = 'Y'
          AND ISV.DIVISION_ID(+) = SI.DIVISION_ID
          AND ISV.ITEM_ID(+) = SI.ITEM_ID
          AND PRJ.DIVISION_ID(+) = SI.DIVISION_ID
          AND PRJ.PROJECT_CODE(+) = SI.PROJECT_CODE
          AND DI.DEPT_ID(+) = SI.DEPT_ID
          AND IA.DIVISION_ID(+) = SI.DIVISION_ID
          AND IA.ITEM_ID(+) = SI.ITEM_ID
          AND CT.CELL_TYPE_CD(+) = NVL(IA.CELL_TYPE_CD, SI.ATTRIBUTE10)
          AND CM.DIVISION_ID(+) = SI.DIVISION_ID
          AND CM.SCM_SITE_ID(+) = SI.SCM_SITE_ID
          AND CM.PROJECT_CODE(+) = SI.PROJECT_CODE
          AND CM.ITEM_ID(+) = SI.ITEM_ID*/
    ),

    /* 3) COMMON FILTERED */
    BF AS (
        SELECT B.*
             , CASE WHEN (FN_GET_DEPT_LIST(P_USER_ID, B.DEPT_ID) = 'Y' OR V_GROUP_ID = 'ADMIN')
                    THEN 'Y' ELSE 'N' END AS EDIT_FLAG
        FROM BASE B
        /* [PERF-DMF0005 20260722] P5: 인라인 FN_SPLITSTRING -> GT_GGET_SPLIT_* 사전적재 EXISTS.
           없음(NULL)/'ALL' 이면 OR 단락으로 GTT 미접근 (PKG_DMF0003 선례 동일 패턴) */
        WHERE (P_DEPT_ID IS NULL OR P_DEPT_ID = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_TEAM_ID X WHERE B.DEPT_ID = X.TOK))
          AND (P_END_CUSTOMER IS NULL OR P_END_CUSTOMER = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_CUSTOMER X WHERE B.END_CUSTOMER = X.TOK))
          AND (P_SCM_SITE_ID IS NULL OR P_SCM_SITE_ID = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_SCM_SITE_ID X WHERE B.SCM_SITE_ID = X.TOK))
          AND (P_VALID_YN IS NULL OR P_VALID_YN = 'ALL'
               OR EXISTS (SELECT 1 FROM SCM_MGR.GT_GGET_SPLIT_VALID_YN X WHERE B.VALID_YN = X.TOK))
          AND (
                NVL(NULLIF(TRIM(P_ITEM_ID), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_ITEM_ID X
                      WHERE NVL(B.ITEM_ID, '')   LIKE '%' || X.TOK || '%'
                         OR NVL(B.NICK_NAME, '') LIKE '%' || X.TOK || '%'
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE X
                      WHERE NVL(B.PROJECT_CODE, '') LIKE '%' || X.TOK || '%'
                         OR NVL(B.PROJECT_NAME, '') LIKE '%' || X.TOK || '%'
                )
          )
          AND (
                NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_OWNER X
                      WHERE NVL(B.OWNER, '')      LIKE '%' || X.TOK || '%'
                         OR NVL(B.OWNER_NAME, '') LIKE '%' || X.TOK || '%'
                )
          )
    ),

    /* 4) 81% 분기: ITEM_TYPE IN ('H','P') OR CNT=0 데이터만 결과 리스트에 포함 */
    SITE_CNT AS (
        SELECT DIVISION_ID
             , SCM_SITE_ID
             , PROJECT_CODE
             , SUM(CASE WHEN ITEM_TYPE IN ('H', 'P') THEN 1 ELSE 0 END) AS CNT
        FROM BF
        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE
    )

    /* 5) BRANCH PROJECTION */
   SELECT
          BF.DIVISION_ID
        , BF.SCM_SITE_ID
        , BF.PROJECT_CODE
        , BF.DEPT_ID
        , BF.TEAM_NAME
        , BF.ITEM_ID
        , BF.CUST_GROUP
        , BF.END_CUSTOMER
        , BF.SOLDTO_CODE
        , BF.SHIPTO_CODE
        , BF.SOLDTO_CUSTOMER
        , BF.OWNER
        , BF.OWNER_NAME
        , BF.SALES_PLAN_ADJUST_YN
        , BF.ITEM_TYPE
        , BF.ITEM_CLASS_NAME
        , BF.ITEM_NAME
        , BF.NICK_NAME
        , BF.SALES_COMPANY
        , BF.SALES_PLANT
        , BF.BPMS_EXIST
        , BF.CELL_PER_CAR
        , BF.CELL_PER_MODULE
        , BF.EDI_LT
        , BF.VMI_LT
        , BF.PROJECT_INFO
        , BF.PROJECT_NAME
        , BF.PROJECT_STATUS
        , BF.PROJECT_OWNER
        , BF.PRJ_OWNR_ID
        , BF.VALID_YN
        , BF.LAST_UPDATE_DATE
        , BF.LAST_UPDATED_BY
        , BF.MDM_ACTIVE
        , BF.ATTRIBUTE5
        , BF.ENERGE_WH
        , BF.CELL_TYPE
        , BF.ATTRIBUTE9
        , BF.ATTRIBUTE4
        , BF.MODULE_PER_CAR
        , BF.ATTRIBUTE6
        , BF.KWH
        , BF.CUSTOMER_MODEL
        , BF.EDIT_FLAG
    FROM (
        SELECT
              B.*
            , NVL(SC.CNT, 0) AS SC_CNT
        FROM BF B
           , SITE_CNT SC
        WHERE SC.DIVISION_ID(+) = B.DIVISION_ID
          AND SC.SCM_SITE_ID(+) = B.SCM_SITE_ID
          AND SC.PROJECT_CODE(+) = B.PROJECT_CODE
    ) BF
    WHERE (
              P_DIVISION_ID IN ('40', '82')
           OR (
                  P_DIVISION_ID LIKE '81%'
              AND (BF.ITEM_TYPE IN ('H', 'P') OR BF.SC_CNT = 0)
              )
          )
    ORDER BY
          BF.DIVISION_ID
        , BF.TEAM_NAME
        , BF.END_CUSTOMER
        , BF.SOLDTO_CODE
        , BF.SHIPTO_CODE
        , BF.SOLDTO_CUSTOMER
        , BF.SCM_SITE_ID
        , BF.PROJECT_CODE
        , BF.ITEM_ID
    ;

    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

    OPEN O_RESULT_CURSOR FOR
         SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );

END P_DMF0005_GET_SALES_SITE_MODEL_PRODUCTION;


PROCEDURE P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE (
      P_DIVISION_ID       IN VARCHAR2
    , P_SCM_SITE_ID        IN VARCHAR2
    , P_PROJECT_CODE   IN VARCHAR2
    , P_ACTIVE_FLAG    IN VARCHAR2
    , P_USER_ID     IN VARCHAR2
    , O_RC1              OUT SYS_REFCURSOR
    , O_RESULT_CURSOR    OUT SYS_REFCURSOR
) IS
    V_GROUP_ID   VARCHAR2(50) := '';

    V_ROW_CNT	      NUMBER := 0;

BEGIN
    /* ADMIN 그룹 조회 */
    SELECT CASE WHEN COUNT(1) > 0 THEN 'ADMIN' ELSE '' END
      INTO V_GROUP_ID
      FROM SCM_ADM_LOOKUP_MASTER_DETAIL
     WHERE LOOKUP_TYPE = 'GET_ADMIN_GROUP'
       AND VALID_YN = 'Y'
       AND SEGMENT2 = 'ALL'
       AND SEGMENT1 IN ( SELECT DISTINCT USER_GR_ID
                         FROM   SCM_ADM_USER_GR_UNIT_AUTH_MPG_M A
                         WHERE  USER_ID = P_USER_ID
                         AND    UNIT_TP_CD = 'D'
                         AND    UNIT_ID = P_DIVISION_ID )
     ;

    OPEN O_RC1 FOR
    WITH

    ITEM_AGG AS (
        SELECT
              T.DIVISION_ID
            , T.ITEM_ID
            , MAX(T.ITEM_NAME) AS ITEM_NAME
            , MAX(T.ITEM_CLASS_NAME) AS ITEM_CLASS_NAME
            , MAX(T.NICK_NAME) AS NICK_NAME
            , CASE MIN(CASE WHEN T.ITEM_TYPE = 'P' THEN 1
                            WHEN T.ITEM_TYPE = 'H' THEN 2
                            WHEN T.ITEM_TYPE = 'Q' THEN 3
                            ELSE 4 END)
                  WHEN 1 THEN 'P'
                  WHEN 2 THEN 'H'
                  WHEN 3 THEN 'Q'
                  ELSE 'R'
              END AS ITEM_TYPE
        FROM SCM_MST_ITEM_SN T
        WHERE T.DIVISION_ID = P_DIVISION_ID
        GROUP BY T.DIVISION_ID, T.ITEM_ID
    ),
    CUST_ITEM AS (
        SELECT
              DIVISION_ID
            , SCM_SITE_ID
            , PROJECT_CODE
            , ITEM_ID
            , MAX(CUSTOMER_MODEL) AS CUSTOMER_MODEL
        FROM DM_MST_CUSTOMER_MODEL
        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID
    )
    SELECT DISTINCT
          SI.DIVISION_ID
        , SI.SCM_SITE_ID
        , SI.PROJECT_CODE
        , PJ.PROJECT_NAME
        , PJ.PROJECT_STATUS
        , SI.SALES_PLAN_ADJUST_YN
        , IA.ITEM_TYPE
        , IA.ITEM_CLASS_NAME
        , SI.ITEM_ID
        , CASE WHEN SI.DIVISION_ID LIKE '81%' THEN TO_NUMBER(SI.ATTRIBUTE8) ELSE 0 END AS KWH
        , CI.CUSTOMER_MODEL
        , IA.NICK_NAME
        , SI.BPMS_EXIST
        , SI.OWNER
        , FN_GET_MULTI_OWNER_NAME(SI.OWNER, ',', '1') AS OWNER_NAME
        , SI.VALID_YN
        , SI.CELL_PER_CAR
        , SI.CELL_PER_MODULE
        , CASE
              WHEN NVL(SI.CELL_PER_MODULE, 0) = 0 THEN NULL
              ELSE SI.CELL_PER_CAR / SI.CELL_PER_MODULE
          END AS MODULE_PER_CAR
        , SI.SALES_COMPANY
        , SI.SALES_PLANT
        , SI.LAST_UPDATE_DATE
        , SI.LAST_UPDATED_BY
        , CASE WHEN (FN_GET_DEPT_LIST(P_USER_ID, SI.DEPT_ID) = 'Y' OR V_GROUP_ID = 'ADMIN')
               THEN 'Y' ELSE 'N' END AS EDIT_FLAG
        , SI.ATTRIBUTE6
        , SI.EDI_LT
        FROM SCM_MST_SITE_ITEM SI
    LEFT JOIN SCM_MST_PROJECT PJ
           ON PJ.DIVISION_ID = SI.DIVISION_ID
          AND PJ.PROJECT_CODE = SI.PROJECT_CODE
    LEFT JOIN SCM_MST_SITE ST
           ON ST.DIVISION_ID = SI.DIVISION_ID
          AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
    LEFT JOIN ITEM_AGG IA
           ON IA.DIVISION_ID = SI.DIVISION_ID
          AND IA.ITEM_ID = SI.ITEM_ID
    LEFT JOIN CUST_ITEM CI
           ON CI.DIVISION_ID = SI.DIVISION_ID
          AND CI.SCM_SITE_ID = SI.SCM_SITE_ID
          AND CI.PROJECT_CODE = SI.PROJECT_CODE
          AND CI.ITEM_ID = SI.ITEM_ID
    WHERE IA.ITEM_TYPE IN ('R', 'Q')
      AND SI.DIVISION_ID = P_DIVISION_ID
      AND SI.PROJECT_CODE = P_PROJECT_CODE
      AND SI.SCM_SITE_ID = P_SCM_SITE_ID
      AND SI.VALID_YN  = P_ACTIVE_FLAG
    ORDER BY
          SI.DIVISION_ID
        , SI.SCM_SITE_ID
        , SI.PROJECT_CODE
        , SI.ITEM_ID
    ;
        /*
       , SCM_MST_PROJECT PJ
       , SCM_MST_SITE ST
       , ITEM_AGG IA
       , CUST_ITEM CI
    WHERE IA.ITEM_TYPE IN ('R', 'Q')
      AND SI.DIVISION_ID = P_DIVISION_ID
      AND SI.PROJECT_CODE = P_PROJECT_CODE
      AND SI.SCM_SITE_ID = P_SCM_SITE_ID
      AND SI.VALID_YN  = P_ACTIVE_FLAG
      AND PJ.DIVISION_ID(+) = SI.DIVISION_ID
      AND PJ.PROJECT_CODE(+) = SI.PROJECT_CODE
      AND ST.DIVISION_ID(+) = SI.DIVISION_ID
      AND ST.SCM_SITE_ID(+) = SI.SCM_SITE_ID
      AND IA.DIVISION_ID(+) = SI.DIVISION_ID
      AND IA.ITEM_ID(+) = SI.ITEM_ID
      AND CI.DIVISION_ID(+) = SI.DIVISION_ID
      AND CI.SCM_SITE_ID(+) = SI.SCM_SITE_ID
      AND CI.PROJECT_CODE(+) = SI.PROJECT_CODE
      AND CI.ITEM_ID(+) = SI.ITEM_ID*/



     V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

     OPEN O_RESULT_CURSOR FOR
          SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT FROM DUAL;

EXCEPTION
    WHEN OTHERS THEN

        RAISE_APPLICATION_ERROR(-20001,
        '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
        ' / SQLERRM=' || SQLERRM ||
        ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
        ' / PARAMS=' || '-' );

END P_DMF0005_GET_SALES_SITE_MODEL_PURCHASE;

PROCEDURE P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION (
      P_DATA            IN CLOB
    , P_USER_ID         IN VARCHAR2
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_CNT           NUMBER := 0;
    V_DUP_ITEM_ID   VARCHAR2(50);

    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN
    FOR R IN (
        SELECT
              TRIM(J.CRUD_TYPE) AS CRUD_TYPE
            , TRIM(J.DIVISION_ID) AS DIVISION_ID
            , TRIM(J.PROJECT_CODE) AS PROJECT_CODE
            , TRIM(J.SCM_SITE_ID) AS SCM_SITE_ID
            , REGEXP_REPLACE(TRIM(J.ITEM_ID), '[[:space:]]+', '') AS ITEM_ID
            , NVL(TRIM(J.SALES_PLAN_ADJUST_YN), 'N') AS SALES_PLAN_ADJUST_YN
            , NVL(TRIM(J.BPMS_EXIST), 'N') AS BPMS_EXIST
            , NVL(TRIM(J.VALID_YN), 'Y') AS VALID_YN
            , TRIM(J.DEPT_ID) AS DEPT_ID
            , TRIM(J.CUST_GROUP) AS CUST_GROUP
            , REGEXP_REPLACE(
                  REGEXP_REPLACE(NVL(TRIM(J.OWNER), ''), ',+', ','),
                  '(^,|,$)',
                  ''
              ) AS OWNER
            , P_USER_ID AS USER_ID
            , J.EDI_LT AS EDI_LT
            , CASE
                  WHEN REGEXP_LIKE(NVL(TRIM(J.VMI_LT), '0'), '^-?\d+(\.\d+)?$') THEN TO_NUMBER(TRIM(J.VMI_LT))
                  ELSE 0
              END AS VMI_LT_NUM
            , TRIM(J.SALES_COMPANY) AS SALES_COMPANY
            , TRIM(J.SALES_PLANT) AS SALES_PLANT
            , NVL(NULLIF(TRIM(J.PARTIAL_PLAN_YN), ''), 'N') AS PARTIAL_PLAN_YN
            , TRIM(J.ENERGE_WH) AS ENERGE_WH
            , TO_CHAR(TRIM(J.KWH), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,') AS KWH -- number
            , TRIM(J.ATTRIBUTE6) AS ATTRIBUTE6
            , TRIM(J.ATTRIBUTE9) AS ATTRIBUTE9
            , TRIM(J.PROJECT_INFO) AS PROJECT_INFO
            , J.CELL_PER_CAR AS CELL_PER_CAR
            , J.CELL_PER_MODULE AS CELL_PER_MODULE
            , TRIM(J.PRJ_OWNR_ID) AS PRJ_OWNR_ID
        FROM JSON_TABLE(
            P_DATA,
            '$[*]'
            COLUMNS (
                  CRUD_TYPE             VARCHAR2(1)    PATH '$.CRUD_TYPE'
                , DIVISION_ID           VARCHAR2(30)   PATH '$.DIVISION_ID'
                , PROJECT_CODE          VARCHAR2(50)   PATH '$.PROJECT_CODE'
                , SCM_SITE_ID           VARCHAR2(30)   PATH '$.SCM_SITE_ID'
                , ITEM_ID               VARCHAR2(50)   PATH '$.ITEM_ID'
                , SALES_PLAN_ADJUST_YN  VARCHAR2(1)    PATH '$.SALES_PLAN_ADJUST_YN'
                , BPMS_EXIST            VARCHAR2(1)    PATH '$.BPMS_EXIST'
                , VALID_YN              VARCHAR2(1)    PATH '$.VALID_YN'
                , DEPT_ID               VARCHAR2(100)  PATH '$.DEPT_ID'
                , CUST_GROUP            VARCHAR2(100)  PATH '$.CUST_GROUP'
                , OWNER                 VARCHAR2(1000) PATH '$.OWNER'
                , EDI_LT                NUMBER         PATH '$.EDI_LT'
                , VMI_LT                VARCHAR2(300)  PATH '$.VMI_LT'
                , SALES_COMPANY         VARCHAR2(300)  PATH '$.SALES_COMPANY'
                , SALES_PLANT           VARCHAR2(300)  PATH '$.SALES_PLANT'
                , PARTIAL_PLAN_YN       VARCHAR2(1)    PATH '$.PARTIAL_PLAN_YN'
                , ENERGE_WH             VARCHAR2(300)  PATH '$.ENERGE_WH'   NULL ON EMPTY
                , KWH                   NUMBER         PATH '$.KWH'         NULL ON EMPTY
                , ATTRIBUTE6            VARCHAR2(300)  PATH '$.ATTRIBUTE6'  NULL ON EMPTY
                , ATTRIBUTE9            VARCHAR2(300)  PATH '$.ATTRIBUTE9'  NULL ON EMPTY
                , PROJECT_INFO          VARCHAR2(300)  PATH '$.PROJECT_INFO' NULL ON EMPTY
                , CELL_PER_CAR          NUMBER         PATH '$.CELL_PER_CAR' NULL ON EMPTY
                , CELL_PER_MODULE       NUMBER         PATH '$.CELL_PER_MODULE' NULL ON EMPTY
                , PRJ_OWNR_ID           VARCHAR2(200)  PATH '$.PRJ_OWNR_ID' NULL ON EMPTY
            )
        ) J
    ) LOOP
            /* =========================
             필수값 검증 - 화면에서 처리
             ========================= */
             /*
          IF R.DIVISION_ID = '40' THEN
              IF TRIM(R.CUST_GROUP)   IS NULL THEN RAISE_INVALID('[40] CUST_GROUP is required.'); END IF;
              IF TRIM(R.PROJECT_CODE) IS NULL THEN RAISE_INVALID('[40] PROJECT_CODE is required.'); END IF;
              IF TRIM(R.OWNER)        IS NULL THEN RAISE_INVALID('[40] OWNER is required.'); END IF;
              IF TRIM(R.SCM_SITE_ID)  IS NULL THEN RAISE_INVALID('[40] SCM_SITE_ID is required.'); END IF;
              IF TRIM(R.SALES_COMPANY)IS NULL THEN RAISE_INVALID('[40] SALES_COMPANY is required.'); END IF;
              IF TRIM(R.SALES_PLANT)  IS NULL THEN RAISE_INVALID('[40] SALES_PLANT is required.'); END IF;
              IF TRIM(R.ITEM_ID)      IS NULL THEN RAISE_INVALID('[40] ITEM_ID is required.'); END IF;
              IF TRIM(R.ATTRIBUTE9)   IS NULL THEN RAISE_INVALID('[40] ATTRIBUTE9(Production Process) is required.'); END IF;

          ELSIF R.DIVISION_ID LIKE '81%' THEN
              IF TRIM(R.OWNER)        IS NULL THEN RAISE_INVALID('[81] OWNER is required.'); END IF;
              IF TRIM(R.SCM_SITE_ID)  IS NULL THEN RAISE_INVALID('[81] SCM_SITE_ID is required.'); END IF;
              IF TRIM(R.SALES_COMPANY)IS NULL THEN RAISE_INVALID('[81] SALES_COMPANY is required.'); END IF;
              IF TRIM(R.SALES_PLANT)  IS NULL THEN RAISE_INVALID('[81] SALES_PLANT is required.'); END IF;
              IF TRIM(R.PROJECT_CODE) IS NULL THEN RAISE_INVALID('[81] PROJECT_CODE is required.'); END IF;
              IF TRIM(R.KWH)          IS NULL THEN RAISE_INVALID('[81] KWH is required.'); END IF;
              IF TRIM(R.VALID_YN)     IS NULL THEN RAISE_INVALID('[81] VALID_YN is required.'); END IF;

          ELSIF R.DIVISION_ID = '82' THEN
              IF TRIM(R.OWNER)        IS NULL THEN RAISE_INVALID('[82] OWNER(Sales) is required.'); END IF;
              IF TRIM(R.PRJ_OWNR_ID)  IS NULL THEN RAISE_INVALID('[82] PRJ_OWNR_ID(Owner PM) is required.'); END IF;
              IF TRIM(R.SALES_COMPANY)IS NULL THEN RAISE_INVALID('[82] SALES_COMPANY is required.'); END IF;
              IF TRIM(R.SALES_PLANT)  IS NULL THEN RAISE_INVALID('[82] SALES_PLANT is required.'); END IF;
              IF TRIM(R.PROJECT_CODE) IS NULL THEN RAISE_INVALID('[82] PROJECT_CODE is required.'); END IF;
              IF TRIM(R.VALID_YN)     IS NULL THEN RAISE_INVALID('[82] VALID_YN is required.'); END IF;
          END IF;
          */
          /* =========================
             OWNER 검증
             ========================= */
          IF TRIM(R.OWNER) IS NOT NULL THEN
              SELECT COUNT(*)
                INTO V_CNT
                FROM (
                      SELECT TRIM(S.VALUE) AS TOKEN
                      FROM TABLE(FN_SPLITSTRING(R.OWNER, ',')) S
                      WHERE TRIM(S.VALUE) IS NOT NULL
                ) O
               WHERE NOT EXISTS (
                      SELECT 1
                      FROM SCM_ADM_USER_M U
                      WHERE U.USER_ID = O.TOKEN
                        --AND U.USE_YN = 'Y'
               );

              IF V_CNT > 0 THEN
                  RAISE_INVALID('Owner정보가 존재하지 않습니다. Owner=' || R.OWNER);
              END IF;
          END IF;

          /* =========================
             OWNER(PM) 검증
             ========================= */
          IF R.DIVISION_ID = '82'
             AND TRIM(R.PRJ_OWNR_ID) IS NOT NULL
          THEN
              SELECT COUNT(*)
                INTO V_CNT
                FROM (
                      SELECT TRIM(S.VALUE) AS TOKEN
                      FROM TABLE(FN_SPLITSTRING(R.PRJ_OWNR_ID, ',')) S
                      WHERE TRIM(S.VALUE) IS NOT NULL
                ) O
               WHERE NOT EXISTS (
                      SELECT 1
                      FROM SCM_ADM_USER_M U
                      WHERE U.USER_ID = O.TOKEN
                        --AND U.USE_YN = 'Y'
               );

              IF V_CNT > 0 THEN
                  RAISE_INVALID('Owner(PM)정보가 존재하지 않습니다. Owner(PM)=' || R.PRJ_OWNR_ID);
              END IF;
          END IF;
        /* 40 division: Active=N blocking validation */
        IF R.DIVISION_ID = '40' AND R.VALID_YN = 'N' THEN
            SELECT COUNT(*)
              INTO V_CNT
              FROM DM_PLN_MKT_FCST
             WHERE YYYYMMDD >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
               AND DIVISION_ID = R.DIVISION_ID
               AND PROJECT_CODE = R.PROJECT_CODE
               AND SCM_SITE_ID = R.SCM_SITE_ID
               AND ITEM_ID = R.ITEM_ID
               AND QTY <> 0
               AND MEASURE IN ('MKT_FCST', 'RTF_SCP', 'RTF', 'VMI_In_Req', 'VMI_In_Plan', 'AS_In_Req');

            IF V_CNT > 0 THEN
                RAISE_INVALID('당주 월요일 이후의 MKT FCST 정보가 존재하므로 Active=''N'' 처리가 불가합니다. Sales Site=' || R.SCM_SITE_ID || ', Model=' || R.ITEM_ID);
            END IF;

            SELECT COUNT(*)
              INTO V_CNT
              FROM DM_PLN_BP_FCST
             WHERE YYYYMM >= TO_CHAR(SYSDATE, 'YYYYMM')
               AND DIVISION_ID = R.DIVISION_ID
               AND PROJECT_CODE = R.PROJECT_CODE
               AND SCM_SITE_ID = R.SCM_SITE_ID
               AND ITEM_ID = R.ITEM_ID
               AND QTY <> 0;

            IF V_CNT > 0 THEN
                RAISE_INVALID('계획구간의 Business Plan 정보가 존재하므로 Active=''N'' 처리가 불가합니다. Sales Site=' || R.SCM_SITE_ID || ', Model=' || R.ITEM_ID);
            END IF;
        END IF;

          /* ============================================================
            DML
            ============================================================ */
        IF R.CRUD_TYPE = 'I' THEN
            IF R.DIVISION_ID = '40' THEN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM DM_MST_ITEM_SINGLE_V
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND ITEM_ID = R.ITEM_ID
                   AND ACTIVE_FLAG = 'Y';

                IF V_CNT = 0 THEN
                    RAISE_INVALID('[' || R.ITEM_ID || '] Invalid Item ID !');
                END IF;

                BEGIN
                    SELECT A.ITEM_ID
                      INTO V_DUP_ITEM_ID
                      FROM SCM_MST_SITE_ITEM A
                      JOIN SCM_MST_SITE B
                        ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
                     WHERE A.DIVISION_ID = R.DIVISION_ID
                       AND SUBSTR(UPPER(R.ITEM_ID), 1, 2) = 'MP'
                       AND SUBSTR(A.ITEM_ID, 1, 11) = SUBSTR(R.ITEM_ID, 1, 11)
                       AND A.ITEM_ID <> R.ITEM_ID
                       AND A.VALID_YN = 'Y'
                       AND B.SITE_TYPE = 'SALES'
                       AND ROWNUM = 1;
                EXCEPTION
                    WHEN NO_DATA_FOUND THEN
                        V_DUP_ITEM_ID := NULL;
                END;

                IF V_DUP_ITEM_ID IS NOT NULL THEN
                    RAISE_INVALID('동일 Pack Model이 존재합니다. Model=' || V_DUP_ITEM_ID);
                END IF;

                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SITE_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND PROJECT_CODE = R.PROJECT_CODE
                   AND SCM_SITE_ID = R.SCM_SITE_ID
                   AND ITEM_ID = R.ITEM_ID;

                IF V_CNT > 0 THEN
                    RAISE_INVALID('동일한 EndCustomer, SalesSite, Model에 대하여 중복저장이 불가합니다.');
                END IF;

                INSERT INTO SCM_MST_SITE_ITEM (
                    DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                    DEPT_ID,
                    SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                    EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
                    ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO, PRJ_OWNR_ID
                ) VALUES (
                    R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID,
                    R.DEPT_ID,
                    R.SALES_PLAN_ADJUST_YN, 'Y', R.BPMS_EXIST, R.CUST_GROUP, R.OWNER,
                    R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
                    R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,
                    R.ENERGE_WH, R.ATTRIBUTE9, R.PROJECT_INFO, R.PRJ_OWNR_ID
                );

                V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;

            ELSIF R.DIVISION_ID LIKE '81%' OR R.DIVISION_ID = '82' THEN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_PROJECT_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND PROJECT_CODE = R.PROJECT_CODE
                   AND VALID_YN = 'Y';

                IF V_CNT = 0 THEN
                    RAISE_INVALID('해당 프로젝트에 등록된 모델이 없습니다. 프로젝트 및 모델 정보를 확인해 주세요.');
                END IF;

                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SITE_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND PROJECT_CODE = R.PROJECT_CODE
                   AND SCM_SITE_ID = R.SCM_SITE_ID;

                IF V_CNT > 0 THEN
                    RAISE_INVALID('동일한 Sales Site, Project Code 가 이미 존재합니다.');
                END IF;

                FOR PI IN (
                    SELECT DISTINCT ITEM_ID
                    FROM SCM_MST_PROJECT_ITEM
                    WHERE DIVISION_ID = R.DIVISION_ID
                      AND PROJECT_CODE = R.PROJECT_CODE
                      AND VALID_YN = 'Y'
                ) LOOP
                    INSERT INTO SCM_MST_SITE_ITEM (
                        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                        DEPT_ID,
                        SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
                        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                        EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
                        ATTRIBUTE6, ATTRIBUTE8, CELL_PER_CAR, CELL_PER_MODULE, PRJ_OWNR_ID
                    ) VALUES (
                        R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, PI.ITEM_ID,
                        R.DEPT_ID,
                        R.SALES_PLAN_ADJUST_YN, NVL(R.VALID_YN, 'Y'), R.BPMS_EXIST, R.CUST_GROUP, R.OWNER,
                        R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
                        R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.ATTRIBUTE6 ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_CAR ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_MODULE ELSE NULL END,
                        CASE WHEN R.DIVISION_ID = '82' THEN R.PRJ_OWNR_ID ELSE NULL END
                    );

                    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
                END LOOP;
            END IF;

        ELSE
          UPDATE SCM_MST_SITE_ITEM A
             SET A.LAST_UPDATED_BY = R.USER_ID
             , A.LAST_UPDATE_DATE = SYSDATE
             , A.OWNER = NVL(R.OWNER, A.OWNER)
             , A.DEPT_ID = NVL(R.DEPT_ID, A.DEPT_ID)
             , A.SALES_COMPANY = NVL(R.SALES_COMPANY, A.SALES_COMPANY)
             , A.SALES_PLANT = NVL(R.SALES_PLANT, A.SALES_PLANT)
             , A.PARTIAL_PLAN_YN = NVL(R.PARTIAL_PLAN_YN, A.PARTIAL_PLAN_YN)
             , A.CUST_GROUP = NVL(R.CUST_GROUP, A.CUST_GROUP)
             , A.SALES_PLAN_ADJUST_YN = NVL(R.SALES_PLAN_ADJUST_YN, A.SALES_PLAN_ADJUST_YN)
             , A.ATTRIBUTE8 = CASE
                        WHEN R.DIVISION_ID = '40' THEN NVL(R.ENERGE_WH, A.ATTRIBUTE8)
                        WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.KWH, A.ATTRIBUTE8)
                        ELSE A.ATTRIBUTE8
                      END
             , A.ATTRIBUTE9 = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.ATTRIBUTE9, A.ATTRIBUTE9) ELSE A.ATTRIBUTE9 END
             , A.PROJECT_INFO = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.PROJECT_INFO, A.PROJECT_INFO) ELSE A.PROJECT_INFO END
             , A.ATTRIBUTE6 = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.ATTRIBUTE6, A.ATTRIBUTE6) ELSE A.ATTRIBUTE6 END
             , A.EDI_LT = NVL(R.EDI_LT, A.EDI_LT)
             , A.SCP_VMI_LT = NVL(R.VMI_LT_NUM, A.SCP_VMI_LT)
             , A.CELL_PER_CAR = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.CELL_PER_CAR, A.CELL_PER_CAR) ELSE A.CELL_PER_CAR END
             , A.CELL_PER_MODULE = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.CELL_PER_MODULE, A.CELL_PER_MODULE) ELSE A.CELL_PER_MODULE END
             , A.PRJ_OWNR_ID = CASE WHEN R.DIVISION_ID = '82' THEN NVL(R.PRJ_OWNR_ID, A.PRJ_OWNR_ID) ELSE A.PRJ_OWNR_ID END
             , A.VALID_YN = NVL(R.VALID_YN, A.VALID_YN)
             , A.BPMS_EXIST = NVL(R.BPMS_EXIST, A.BPMS_EXIST)
           WHERE A.DIVISION_ID = R.DIVISION_ID
             AND A.PROJECT_CODE = R.PROJECT_CODE
             AND A.SCM_SITE_ID = R.SCM_SITE_ID
             AND A.ITEM_ID = R.ITEM_ID;

          IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO SCM_MST_SITE_ITEM (
              DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
              DEPT_ID,
              SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
              EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
              ATTRIBUTE6, ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO,
              CELL_PER_CAR, CELL_PER_MODULE, PRJ_OWNR_ID
            ) VALUES (
              R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID,
              R.DEPT_ID,
              NVL(R.SALES_PLAN_ADJUST_YN, 'N'),
              NVL(R.VALID_YN, 'Y'),
              NVL(R.BPMS_EXIST, 'N'),
              R.CUST_GROUP,
              R.OWNER,
              R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
              R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.ATTRIBUTE6 ELSE NULL END,
              CASE
                WHEN R.DIVISION_ID = '40' THEN R.ENERGE_WH
                WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH
                ELSE NULL
              END,
              CASE WHEN R.DIVISION_ID = '40' THEN R.ATTRIBUTE9 ELSE NULL END,
              CASE WHEN R.DIVISION_ID = '40' THEN R.PROJECT_INFO ELSE NULL END,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_CAR ELSE NULL END,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_MODULE ELSE NULL END,
              CASE WHEN R.DIVISION_ID = '82' THEN R.PRJ_OWNR_ID ELSE NULL END
            );
          END IF;

            V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
        END IF;
    END LOOP;

    COMMIT;

    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_ROW_CNT) AS EVENT
        FROM DUAL;

EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '0' AS EVENT
            FROM DUAL;

    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-'
        );
END P_DMF0005_SAVE_SALES_SITE_MODEL_PRODUCTION;

END PKG_DMF0005;