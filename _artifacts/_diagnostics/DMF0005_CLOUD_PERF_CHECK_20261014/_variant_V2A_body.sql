-- SOURCE-FRESH: SCM_MGR.PKG_DMF0005 PACKAGE BODY LAST_DDL=2026-10-14 10:15:49 FETCHED=2026-10-14 11:34 DB=ZIOUI1
CREATE OR REPLACE PACKAGE BODY         "PKG_DMF0005" IS
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
 * 2026.10.08   POJ            모델 · 프로젝트 · 사이트 코드 대소문자 · 끝 공백 무시 연결(AS-IS 와 같은 비교 규칙) · 40 Report 4칸 추가
 * 2026.10.09   POJ            Owner 한글 이름 조회 · 40 Destination 사이트 국가명 · VMI LT 빈 값 0 · 빈 팀 ID H · P 연결(AS-IS 와 같음)
 */
IS
    V_GROUP_ID VARCHAR2(50) := '';
    V_ROW_CNT  NUMBER := 0;
BEGIN
    --[2026-07-31 클라우드 대응] GTT 동적샘플링 강제 — 클라우드 세션 기본값 0(GTT 무통계 파국계획, 사내 12초/클라우드 16분+ 실증) 방지.
    --  Oracle 기본값 2 복원. 트랜잭션 무관 세션 파라미터(ENABLE PARALLEL DML 계열 아님 — ORA-12841 리스크 없음).
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
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
               , FN_GET_MULTI_OWNER_NAME(O.OWNER, ',', '2') AS OWNER_NAME_KO    -- 2026.10.09 POJ Owner 한글 이름(AS-IS 조회조건 비교 대상)
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
            , CU.SOLDTO_DESCRIPTION                                                  -- 2026.09.11 AJS
            , SC.SHIPTO_CODE
            , CU.SHIPTO_DESCRIPTION                                                  -- 2026.09.11 AJS
            , ST.SOLDTO_CUSTOMER
            , SI.OWNER
            , ONM.OWNER_NAME AS OWNER_NAME -- [PERF-DMF0005 20260722] P3: 행별 함수 -> OWNER_NM 조인
            , ONM.OWNER_NAME_KO    -- 2026.10.09 POJ Owner 한글 이름(조회조건 비교용)
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
            -- , SI.SCP_VMI_LT AS VMI_LT    -- 2026.10.09 POJ 원본
            , NVL(SI.SCP_VMI_LT, 0) AS VMI_LT    -- 2026.10.09 POJ VMI LT 빈 값은 0 으로 표시(AS-IS 와 같음)
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
            , SI.ATTRIBUTE1 -- 2026.9.17 Sold-To Cust.(Report) 추가
            , SI.ATTRIBUTE2        -- 2026.10.08 POJ 40 End Cust.(Report) 추가
            , SI.CUST_GROUP_DTL    -- 2026.10.08 POJ 40 Cust Group Detail 추가
            , SI.APPLICATION       -- 2026.10.08 POJ 40 Application 추가
            , SI.ROUTE             -- 2026.10.08 POJ 40 Channel 추가
            , SI.ATTRIBUTE9
            -- , SI.ATTRIBUTE4    -- 2026.10.09 POJ 원본
            , CASE WHEN SI.DIVISION_ID = '40' THEN (SELECT CO.COUNTRY_NAME FROM SCM_MST_COUNTRY CO WHERE CO.COUNTRY = ST.COUNTRY) ELSE SI.ATTRIBUTE4 END AS ATTRIBUTE4    -- 2026.10.09 POJ 40 Destination 은 사이트 국가명(AS-IS 와 같음)
            , SI.CELL_S_OP_REPORT                                                    -- 2026.09.11 AJS
            , CM.CUSTOMER_MODEL
            , SI.PARTIAL_PLAN_YN    -- 2026.10.14 [E20261014-DMF0005PARTIALGET] Partial Plan YN 조회 추가(AS-IS 와 같이 원장 값 그대로)
        FROM SCM_MST_SITE_ITEM SI
        JOIN SCM_MST_SITE ST
          ON ST.DIVISION_ID = SI.DIVISION_ID
         AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
         AND ST.SITE_TYPE = 'SALES'
        LEFT JOIN SCM_MST_SITE_CUSTOMER SC
          ON SC.DIVISION_ID = SI.DIVISION_ID
         --AND SC.SCM_SITE_ID = SI.SCM_SITE_ID
         AND UPPER(SC.SCM_SITE_ID) = UPPER(SI.SCM_SITE_ID)    -- 2026.10.08 POJ 사이트 코드 대소문자 무시 연결
         AND SC.REP_YN = 'Y'
         AND SC.VALID_YN = 'Y'
--       AND (P_DIVISION_ID = '82' OR NVL(SC.VALID_YN, 'Y') = 'Y')
        /* [PERF-DMF0005 20260722] P6c: DM_MST_ITEM_SINGLE_V 조인 제거 — ITEM_AGG(IA) 등가 대체 */
        LEFT JOIN SCM_MST_CUSTOMER CU                                                 -- 2026.09.11 AJS
          ON CU.DIVISION_ID = SC.DIVISION_ID                                         -- 2026.09.11 AJS
         AND CU.SOLDTO_CODE = SC.SOLDTO_CODE                                         -- 2026.09.11 AJS
         AND CU.SHIPTO_CODE = SC.SHIPTO_CODE                                         -- 2026.09.11 AJS
        LEFT JOIN SCM_MST_PROJECT PRJ
          ON PRJ.DIVISION_ID = SI.DIVISION_ID
         --AND PRJ.PROJECT_CODE = SI.PROJECT_CODE
         AND UPPER(PRJ.PROJECT_CODE) = UPPER(SI.PROJECT_CODE)    -- 2026.10.08 POJ 프로젝트 코드 대소문자 무시 연결
        LEFT JOIN SCM_MST_SSO_DEPT_INFO DI
          ON DI.DEPT_ID = SI.DEPT_ID
        LEFT JOIN ITEM_AGG IA
               ON IA.DIVISION_ID = SI.DIVISION_ID
              --AND IA.ITEM_ID = SI.ITEM_ID
              AND UPPER(RTRIM(IA.ITEM_ID, ' ' || UNISTR('\3000'))) = UPPER(RTRIM(SI.ITEM_ID, ' ' || UNISTR('\3000')))    -- 2026.10.08 POJ 모델 대소문자 · 끝 공백 무시 연결
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
             , CASE WHEN (NVL(D.DEPT_FLAG, 'N') = 'Y' OR V_GROUP_ID = 'ADMIN')
                    THEN 'Y' ELSE 'N' END AS EDIT_FLAG
        FROM BASE B         LEFT OUTER JOIN
             (
                SELECT MA.DEPT_ID, CASE WHEN COUNT(*) = 0 THEN 'N' ELSE 'Y' END DEPT_FLAG
                  FROM (
                        /* 매핑 데이터가 있는 경우 */
                        SELECT LOOK.SEGMENT3 DEPT_ID
                          FROM SCM_ADM_USER_M                USR
                             , SCM_ADM_LOOKUP_MASTER_DETAIL  LOOK
                         WHERE USR.DEPT_ID = LOOK.SEGMENT1
                           AND LOOK.LOOKUP_TYPE = 'PM_TEAM_MAPPING'
                           AND LOOK.VALID_YN = 'Y'
                           AND UPPER(USR.USER_ID) = UPPER(P_USER_ID)
                        UNION ALL
                        /* 매핑이 없는 경우 자기 부서 */
                        SELECT DEPT_ID
                          FROM SCM_ADM_USER_M
                         WHERE UPPER(USER_ID) = UPPER(P_USER_ID)
                       ) MA
                 GROUP BY MA.DEPT_ID
             ) D          ON B.DEPT_ID = D.DEPT_ID
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
                      WHERE NVL(UPPER(B.ITEM_ID), '')   LIKE '%' || UPPER(X.TOK) || '%'
                         OR NVL(UPPER(B.NICK_NAME), '') LIKE '%' || UPPER(X.TOK) || '%'
                ) --260820 조회조건 Upper 처리
          )
          AND (
                NVL(NULLIF(TRIM(P_PROJECT_CODE), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_PROJECT_CODE X
                      WHERE NVL(UPPER(B.PROJECT_CODE), '') LIKE '%' || UPPER(X.TOK) || '%'
                         OR NVL(UPPER(B.PROJECT_NAME), '') LIKE '%' || UPPER(X.TOK) || '%'
                ) --260820 조회조건 Upper 처리
          )
          AND (
                NVL(NULLIF(TRIM(P_OWNER), ''), 'ALL') = 'ALL'
                OR EXISTS (
                      SELECT 1
                      FROM SCM_MGR.GT_GGET_SPLIT_OWNER X
                      WHERE NVL(UPPER(B.OWNER), '')      LIKE '%' || UPPER(X.TOK) || '%'
                         OR NVL(UPPER(B.OWNER_NAME), '') LIKE '%' || UPPER(X.TOK) || '%'
                         OR NVL(UPPER(B.OWNER_NAME_KO), '') LIKE '%' || UPPER(X.TOK) || '%'    -- 2026.10.09 POJ Owner 한글 이름 비교(AS-IS 와 같음)
                ) --260820 조회조건 Upper 처리
          )
    ),
    /* 4) 81% 분기: ITEM_TYPE IN ('H','P') OR CNT=0 데이터만 결과 리스트에 포함 */
    SITE_CNT AS (
--        SELECT DIVISION_ID
--             , SCM_SITE_ID
--             , PROJECT_CODE
--             , SUM(CASE WHEN ITEM_TYPE IN ('H', 'P') THEN 1 ELSE 0 END) AS CNT
--        FROM BF
--        GROUP BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE
        SELECT   SI9.DIVISION_ID                                                     -- 2026.09.08 AJS
               , SI9.SCM_SITE_ID                                                     -- 2026.09.08 AJS
               , SI9.PROJECT_CODE                                                    -- 2026.09.08 AJS
               , NVL(SI9.DEPT_ID, '/') AS DEPT_ID    -- 2026.10.09 POJ 빈 팀 ID 행 묶음(결과 연결 키와 같게)
               , SUM(CASE WHEN IA9.ITEM_TYPE IN ('H', 'P') THEN 1 ELSE 0 END) AS CNT -- 2026.09.08 AJS
          FROM   SCM_MST_SITE_ITEM SI9                                               -- 2026.09.08 AJS
               , ITEM_AGG          IA9                                               -- 2026.09.08 AJS
         WHERE   SI9.DIVISION_ID = P_DIVISION_ID                                     -- 2026.09.08 AJS
           AND   IA9.DIVISION_ID (+) = SI9.DIVISION_ID                               -- 2026.09.08 AJS
           --AND   IA9.ITEM_ID (+) = SI9.ITEM_ID                                       -- 2026.09.08 AJS
           AND   UPPER(RTRIM(IA9.ITEM_ID (+), ' ' || UNISTR('\3000'))) = UPPER(RTRIM(SI9.ITEM_ID, ' ' || UNISTR('\3000')))    -- 2026.10.08 POJ 모델 대소문자 · 끝 공백 무시 연결
         GROUP BY SI9.DIVISION_ID , SI9.SCM_SITE_ID , SI9.PROJECT_CODE , NVL(SI9.DEPT_ID, '/')    -- 2026.10.09 POJ 빈 팀 ID 행 묶음
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
        , BF.SOLDTO_DESCRIPTION                                                      -- 2026.09.11 AJS
        , BF.SHIPTO_CODE
        , BF.SHIPTO_DESCRIPTION                                                      -- 2026.09.11 AJS
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
        , BF.ATTRIBUTE1 --2026.9.17 Sold-To Cust.(Report) 추가
        , BF.ATTRIBUTE2        -- 2026.10.08 POJ 40 End Cust.(Report) 추가
        , BF.CUST_GROUP_DTL    -- 2026.10.08 POJ 40 Cust Group Detail 추가
        , BF.APPLICATION       -- 2026.10.08 POJ 40 Application 추가
        , BF.ROUTE             -- 2026.10.08 POJ 40 Channel 추가
        , BF.ATTRIBUTE9
        , BF.ATTRIBUTE4
        , BF.MODULE_PER_CAR
        , BF.ATTRIBUTE6
        , BF.KWH
        , BF.CUSTOMER_MODEL
        , BF.CELL_S_OP_REPORT                                                        -- 2026.09.11 AJS
        , BF.EDIT_FLAG
        , BF.PARTIAL_PLAN_YN    -- 2026.10.14 [E20261014-DMF0005PARTIALGET] Partial Plan YN 조회 추가
    FROM (
        SELECT /*+ NO_PUSH_PRED(SC) */    -- 2026.10.14 [E20261014-DMF0005NOPUSH] SITE_CNT 를 행마다 다시 실행하지 않고 한 번 계산해 붙인다(클라우드 QA 조회 미종료 대응 · 힌트 사용자 승인)
              B.*
            , NVL(SC.CNT, 0) AS SC_CNT
        FROM BF B
           , SITE_CNT SC
        WHERE SC.DIVISION_ID(+) = B.DIVISION_ID
          AND SC.SCM_SITE_ID(+) = B.SCM_SITE_ID
          AND SC.PROJECT_CODE(+) = B.PROJECT_CODE
          AND SC.DEPT_ID(+) = NVL(B.DEPT_ID, '/')    -- 2026.10.09 POJ 빈 팀 ID 행도 H · P 건수와 연결
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
-- 2026.10.08 POJ 모델 · 프로젝트 코드를 대소문자 · 끝 공백 무시로 연결(AS-IS 와 같은 비교 규칙)
    V_GROUP_ID   VARCHAR2(50) := '';
    V_ROW_CNT	      NUMBER := 0;
BEGIN
    -- 2026.09.30 AJS 클라우드 동적샘플링 강제 — 상단 조회와 같은 조치 (START)
    --  클라우드 세션 기본값 0 에서는 통계 없는 대상(JSON_TABLE · FN_SPLITSTRING)이
    --  파국계획을 타 조회가 분 단위로 늘어난다(사내 12초 대 클라우드 16분+ 실증).
    --  Oracle 기본값 2 복원. 암묵적 커밋이 없어 롤백에 영향 없다.
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
    -- 2026.09.30 AJS 클라우드 동적샘플링 강제 — 상단 조회와 같은 조치 (END)
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
          --AND PJ.PROJECT_CODE = SI.PROJECT_CODE
          AND UPPER(PJ.PROJECT_CODE) = UPPER(SI.PROJECT_CODE)    -- 2026.10.08 POJ 프로젝트 코드 대소문자 무시 연결
    LEFT JOIN SCM_MST_SITE ST
           ON ST.DIVISION_ID = SI.DIVISION_ID
          AND ST.SCM_SITE_ID = SI.SCM_SITE_ID
    LEFT JOIN ITEM_AGG IA
           ON IA.DIVISION_ID = SI.DIVISION_ID
          --AND IA.ITEM_ID = SI.ITEM_ID
          AND UPPER(RTRIM(IA.ITEM_ID, ' ' || UNISTR('\3000'))) = UPPER(RTRIM(SI.ITEM_ID, ' ' || UNISTR('\3000')))    -- 2026.10.08 POJ 모델 대소문자 · 끝 공백 무시 연결
    LEFT JOIN CUST_ITEM CI
           ON CI.DIVISION_ID = SI.DIVISION_ID
          AND CI.SCM_SITE_ID = SI.SCM_SITE_ID
          AND CI.PROJECT_CODE = SI.PROJECT_CODE
          AND CI.ITEM_ID = SI.ITEM_ID
    WHERE IA.ITEM_TYPE IN ('R', 'Q')
      AND SI.DIVISION_ID = P_DIVISION_ID
      AND SI.PROJECT_CODE = P_PROJECT_CODE
      AND SI.SCM_SITE_ID = P_SCM_SITE_ID
      AND ( P_ACTIVE_FLAG IS NULL
         OR P_ACTIVE_FLAG = 'ALL'
         OR SI.VALID_YN = P_ACTIVE_FLAG )   /* AS-IS 는 'ALL'·빈값이면 조건 미적용 */
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
-- 2026.10.08 POJ 81 EDI Leadtime 재배치 · 같은 모델 VMI LT 맞춤 · 대소문자 · 끝 공백 무시 비교 · 40 Report 4칸 저장(AS-IS 와 같은 처리)
-- 2026.10.09 POJ Partial Plan 보존 · 비운 칸 저장 · 40 행 추가 ATTRIBUTE8 제외 · 저장 오류 다국어 · 81 ERP 인터페이스 전송 · 신규 등록 칸 · 변경 이력(AS-IS 와 같은 처리)
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_ROW_CNT       NUMBER := 0;
    V_CNT           NUMBER := 0;
    V_DUP_ITEM_ID   VARCHAR2(50);
    V_DEPT_ID       VARCHAR2(50);                                   -- 2026.09.17 AJS
    V_DEPT_ID_MAX   VARCHAR2(50);                                   -- 2026.09.17 AJS
    V_KEY_PROJECT   SCM_MST_SITE_ITEM.PROJECT_CODE%TYPE;            -- 2026.10.08 POJ 기존 행 철자(대소문자 · 끝 공백 무시로 찾은 4키)
    V_KEY_SITE      SCM_MST_SITE_ITEM.SCM_SITE_ID%TYPE;             -- 2026.10.08 POJ 기존 행 철자
    V_KEY_ITEM      SCM_MST_SITE_ITEM.ITEM_ID%TYPE;                 -- 2026.10.08 POJ 기존 행 철자
    V_W0_MONDAY     VARCHAR2(8);                                    -- 2026.10.08 POJ EDI 재배치 기준 당주 월요일
    V_EDI_LT        NUMBER;                                         -- 2026.10.08 POJ EDI 재배치 Leadtime
    V_IDX           PLS_INTEGER;                                    -- 2026.10.08 POJ EDI 재배치 대상 키 순번
    TYPE T_EDI_KEY_REC IS RECORD (                                  -- 2026.10.08 POJ EDI 재배치 대상 키
          DIVISION_ID   SCM_MST_SITE_ITEM.DIVISION_ID%TYPE
        , PROJECT_CODE  SCM_MST_SITE_ITEM.PROJECT_CODE%TYPE
        , SCM_SITE_ID   SCM_MST_SITE_ITEM.SCM_SITE_ID%TYPE
        , ITEM_ID       SCM_MST_SITE_ITEM.ITEM_ID%TYPE
        , EDI_LT        NUMBER );
    TYPE T_EDI_KEY_TAB IS TABLE OF T_EDI_KEY_REC INDEX BY PLS_INTEGER;          -- 2026.10.08 POJ
    TYPE T_EDI_FCST_TAB IS TABLE OF DM_PLN_MKT_FCST%ROWTYPE INDEX BY PLS_INTEGER; -- 2026.10.08 POJ
    V_EDI_KEY       T_EDI_KEY_TAB;                                  -- 2026.10.08 POJ
    V_EDI_ROW       T_EDI_FCST_TAB;                                 -- 2026.10.08 POJ 원래 행(이력용)
    V_EDI_GRP       T_EDI_FCST_TAB;                                 -- 2026.10.08 POJ 옮길 일자 기준 합산 행
    V_LANG_CD       SCM_ADM_USER_M.LANG_CD%TYPE;                    -- 2026.10.09 POJ 저장 오류 문구 언어
    V_XIF_CURSOR    SYS_REFCURSOR;                                  -- 2026.10.09 POJ ERP 인터페이스 호출 결과(사용 안 함)
    V_CURRENCY      SCM_MST_SITE_ITEM.CURRENCY%TYPE;                -- 2026.10.09 POJ 81 · 82 신규 Currency(프로젝트 통화)
    V_CHG_BEFORE    VARCHAR2(4000);                                 -- 2026.10.09 POJ 저장 전 Inventory Days 문자열(이력 변경 표시)
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG := P_MSG;
        RAISE EX_BIZ_EX;
    END;
BEGIN
    -- 2026.09.30 AJS 클라우드 동적샘플링 강제 — 상단 조회와 같은 조치 (START)
    --  클라우드 세션 기본값 0 에서는 통계 없는 대상(JSON_TABLE · FN_SPLITSTRING)이
    --  파국계획을 타 저장이 분 단위로 늘어난다(사내 12초 대 클라우드 16분+ 실증).
    --  Oracle 기본값 2 복원. 암묵적 커밋이 없어 롤백에 영향 없다.
    EXECUTE IMMEDIATE 'ALTER SESSION SET optimizer_dynamic_sampling = 2';
    -- 2026.09.30 AJS 클라우드 동적샘플링 강제 — 상단 조회와 같은 조치 (END)
    -- 2026.10.09 POJ 저장 오류 문구 언어 · 인터페이스 임시 테이블 준비 (START)
    SELECT NVL(MAX(LANG_CD), 'KO')
      INTO V_LANG_CD
      FROM SCM_ADM_USER_M
     WHERE UPPER(USER_ID) = UPPER(P_USER_ID);
    DELETE FROM GT_DXES_XIF_ERP_SITE_ITEM;    /* 세션 유지 임시 테이블 — 이전 저장 잔여 행 제거(DELETE : 확정 없음) */
    -- 2026.10.09 POJ 저장 오류 문구 언어 · 인터페이스 임시 테이블 준비 (END)
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
            , TRIM(J.TEAM_NAME) AS TEAM_NAME                                           -- 2026.09.17 AJS
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
            -- , NVL(NULLIF(TRIM(J.PARTIAL_PLAN_YN), ''), 'N') AS PARTIAL_PLAN_YN    -- 2026.10.09 POJ 원본
            , TRIM(J.PARTIAL_PLAN_YN) AS PARTIAL_PLAN_YN    -- 2026.10.09 POJ Partial Plan 키가 없으면 빈 값 — 수정 때 기존 값 유지(AS-IS 와 같음)
            , TRIM(J.ENERGE_WH) AS ENERGE_WH
            , TO_CHAR(TRIM(J.KWH), 'TM9', 'NLS_NUMERIC_CHARACTERS=.,') AS KWH -- number
            , TRIM(J.ATTRIBUTE1) AS ATTRIBUTE1 --2026.9.17 Sold-To Cust.(Report) 추가
            , TRIM(J.ATTRIBUTE2) AS ATTRIBUTE2    -- 2026.10.08 POJ 40 End Cust.(Report) 추가
            , TRIM(J.CUST_GROUP_DTL) AS CUST_GROUP_DTL    -- 2026.10.08 POJ 40 Cust Group Detail 추가
            , TRIM(J.APPLICATION) AS APPLICATION    -- 2026.10.08 POJ 40 Application 추가
            , TRIM(J.ROUTE) AS ROUTE    -- 2026.10.08 POJ 40 Channel 추가
            , TRIM(J.ATTRIBUTE6) AS ATTRIBUTE6
            , TRIM(J.ATTRIBUTE9) AS ATTRIBUTE9
            , TRIM(J.PROJECT_INFO) AS PROJECT_INFO
            , J.CELL_PER_CAR AS CELL_PER_CAR
            , J.CELL_PER_MODULE AS CELL_PER_MODULE
            , TRIM(J.PRJ_OWNR_ID) AS PRJ_OWNR_ID
            -- 2026.10.09 POJ 화면이 보낸 칸인지(키 존재) (START)
            , J.ATTRIBUTE1_EX
            , J.ATTRIBUTE2_EX
            , J.CUST_GROUP_DTL_EX
            , J.APPLICATION_EX
            , J.ROUTE_EX
            , J.PROJECT_INFO_EX
            , J.ATTRIBUTE6_EX
            , J.EDI_LT_EX
            , J.CELL_PER_CAR_EX
            , J.CELL_PER_MODULE_EX
            -- 2026.10.09 POJ 화면이 보낸 칸인지(키 존재) (END)
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
                , TEAM_NAME             VARCHAR2(600)  PATH '$.TEAM_NAME'   NULL ON EMPTY -- 2026.09.17 AJS
                , CUST_GROUP            VARCHAR2(100)  PATH '$.CUST_GROUP'
                , OWNER                 VARCHAR2(1000) PATH '$.OWNER'
                , EDI_LT                NUMBER         PATH '$.EDI_LT'
                , VMI_LT                VARCHAR2(300)  PATH '$.VMI_LT'
                , SALES_COMPANY         VARCHAR2(300)  PATH '$.SALES_COMPANY'
                , SALES_PLANT           VARCHAR2(300)  PATH '$.SALES_PLANT'
                , PARTIAL_PLAN_YN       VARCHAR2(1)    PATH '$.PARTIAL_PLAN_YN'
                , ENERGE_WH             VARCHAR2(300)  PATH '$.ENERGE_WH'   NULL ON EMPTY
                , KWH                   NUMBER         PATH '$.KWH'         NULL ON EMPTY
                , ATTRIBUTE1            VARCHAR2(300)  PATH '$.ATTRIBUTE1'  NULL ON EMPTY --2026.9.17 Sold-To Cust.(Report) 추가
                , ATTRIBUTE2            VARCHAR2(600)  PATH '$.ATTRIBUTE2'  NULL ON EMPTY    -- 2026.10.08 POJ 40 End Cust.(Report) 추가
                , CUST_GROUP_DTL        VARCHAR2(400)  PATH '$.CUST_GROUP_DTL'  NULL ON EMPTY    -- 2026.10.08 POJ 40 Cust Group Detail 추가
                , APPLICATION           VARCHAR2(400)  PATH '$.APPLICATION'  NULL ON EMPTY    -- 2026.10.08 POJ 40 Application 추가
                , ROUTE                 VARCHAR2(160)  PATH '$.ROUTE'  NULL ON EMPTY    -- 2026.10.08 POJ 40 Channel 추가
                , ATTRIBUTE6            VARCHAR2(300)  PATH '$.ATTRIBUTE6'  NULL ON EMPTY
                , ATTRIBUTE9            VARCHAR2(300)  PATH '$.ATTRIBUTE9'  NULL ON EMPTY
                , PROJECT_INFO          VARCHAR2(300)  PATH '$.PROJECT_INFO' NULL ON EMPTY
                , CELL_PER_CAR          NUMBER         PATH '$.CELL_PER_CAR' NULL ON EMPTY
                , CELL_PER_MODULE       NUMBER         PATH '$.CELL_PER_MODULE' NULL ON EMPTY
                , PRJ_OWNR_ID           VARCHAR2(200)  PATH '$.PRJ_OWNR_ID' NULL ON EMPTY
                -- 2026.10.09 POJ 화면이 보낸 칸인지(키 존재) — 수정 저장에서 비운 칸 구분 (START)
                , ATTRIBUTE1_EX         VARCHAR2(5)    EXISTS PATH '$.ATTRIBUTE1'
                , ATTRIBUTE2_EX         VARCHAR2(5)    EXISTS PATH '$.ATTRIBUTE2'
                , CUST_GROUP_DTL_EX     VARCHAR2(5)    EXISTS PATH '$.CUST_GROUP_DTL'
                , APPLICATION_EX        VARCHAR2(5)    EXISTS PATH '$.APPLICATION'
                , ROUTE_EX              VARCHAR2(5)    EXISTS PATH '$.ROUTE'
                , PROJECT_INFO_EX       VARCHAR2(5)    EXISTS PATH '$.PROJECT_INFO'
                , ATTRIBUTE6_EX         VARCHAR2(5)    EXISTS PATH '$.ATTRIBUTE6'
                , EDI_LT_EX             VARCHAR2(5)    EXISTS PATH '$.EDI_LT'
                , CELL_PER_CAR_EX       VARCHAR2(5)    EXISTS PATH '$.CELL_PER_CAR'
                , CELL_PER_MODULE_EX    VARCHAR2(5)    EXISTS PATH '$.CELL_PER_MODULE'
                -- 2026.10.09 POJ 화면이 보낸 칸인지(키 존재) — 수정 저장에서 비운 칸 구분 (END)
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
          -- 2026.09.17 AJS Team 명으로 Team ID 확인 (START)
          V_DEPT_ID := R.DEPT_ID;
          IF R.TEAM_NAME IS NOT NULL THEN
              /* 넘어온 Team ID 와 Team 명이 짝이면 그대로 사용 */
              SELECT MAX(DEPT_ID)
                INTO V_DEPT_ID
                FROM SCM_MST_SSO_DEPT_INFO
               WHERE DEPT_ID = R.DEPT_ID
                 AND TRIM(DEPT_NAME_KO) = R.TEAM_NAME;
              /* 짝이 아니면 Team 명으로 Team ID 확인 */
              IF V_DEPT_ID IS NULL THEN
                  SELECT MIN(DEPT_ID)
                       , MAX(DEPT_ID)
                    INTO V_DEPT_ID
                       , V_DEPT_ID_MAX
                    FROM SCM_MST_SSO_DEPT_INFO
                   WHERE VALID_YN = 'Y'
                     AND TRIM(DEPT_NAME_KO) = R.TEAM_NAME;
                  IF V_DEPT_ID IS NULL THEN
                      RAISE_INVALID('Team 정보가 존재하지 않습니다. Team 팝업에서 선택해 주세요. Team=' || R.TEAM_NAME);
                  END IF;
                  /* 같은 Team 명이 여럿이면 이 사업부에서 쓰는 Team ID 로 확인 */
                  IF V_DEPT_ID <> V_DEPT_ID_MAX THEN
                      SELECT MIN(A.DEPT_ID)
                           , MAX(A.DEPT_ID)
                        INTO V_DEPT_ID
                           , V_DEPT_ID_MAX
                        FROM SCM_MST_SSO_DEPT_INFO A
                       WHERE EXISTS (SELECT 1
                                       FROM SCM_MST_SITE_ITEM B
                                      WHERE B.DIVISION_ID = R.DIVISION_ID
                                        AND B.DEPT_ID = A.DEPT_ID)
                         AND A.VALID_YN = 'Y'
                         AND TRIM(A.DEPT_NAME_KO) = R.TEAM_NAME;
                      IF V_DEPT_ID IS NULL OR V_DEPT_ID <> V_DEPT_ID_MAX THEN
                          RAISE_INVALID('같은 이름의 Team 이 여럿입니다. Team 팝업에서 선택해 주세요. Team=' || R.TEAM_NAME);
                      END IF;
                  END IF;
              END IF;
          END IF;
          -- 2026.09.17 AJS Team 명으로 Team ID 확인 (END)
          /* =========================
             OWNER 검증
             ========================= */
          IF TRIM(R.OWNER) IS NOT NULL THEN
              SELECT COUNT(*)
                INTO V_CNT
                FROM (
                      SELECT UPPER(TRIM(S.VALUE)) AS TOKEN
                      FROM TABLE(FN_SPLITSTRING(R.OWNER, ',')) S
                      WHERE TRIM(S.VALUE) IS NOT NULL
                ) O
               WHERE NOT EXISTS (
                      SELECT 1
                      FROM SCM_ADM_USER_M U
                      WHERE UPPER(U.USER_ID) = O.TOKEN
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
                      SELECT UPPER(TRIM(S.VALUE)) AS TOKEN
                      FROM TABLE(FN_SPLITSTRING(R.PRJ_OWNR_ID, ',')) S
                      WHERE TRIM(S.VALUE) IS NOT NULL
                ) O
               WHERE NOT EXISTS (
                      SELECT 1
                      FROM SCM_ADM_USER_M U
                      WHERE UPPER(U.USER_ID) = O.TOKEN
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
        V_KEY_PROJECT := R.PROJECT_CODE;    -- 2026.10.08 POJ 기존 행 철자 기본값(화면 값)
        V_KEY_SITE    := R.SCM_SITE_ID;     -- 2026.10.08 POJ 기존 행 철자 기본값(화면 값)
        V_KEY_ITEM    := R.ITEM_ID;         -- 2026.10.08 POJ 기존 행 철자 기본값(화면 값)
        V_CHG_BEFORE  := NULL;               -- 2026.10.09 POJ 저장 전 Inventory Days 문자열(신규는 없음)
          /* ============================================================
            DML
            ============================================================ */
        IF R.CRUD_TYPE = 'I' THEN
            IF R.DIVISION_ID = '40' THEN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM DM_MST_ITEM_SINGLE_V
                 WHERE DIVISION_ID = R.DIVISION_ID
                   --AND ITEM_ID = R.ITEM_ID
                   AND UPPER(RTRIM(ITEM_ID, ' ' || UNISTR('\3000'))) = UPPER(RTRIM(R.ITEM_ID, ' ' || UNISTR('\3000')))    -- 2026.10.08 POJ 모델 대소문자 · 끝 공백 무시
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
                       --AND SUBSTR(A.ITEM_ID, 1, 12) = SUBSTR(R.ITEM_ID, 1, 12)   /* E20260325-001071 : 11 자리 -> 12 자리 */
                       AND SUBSTR(UPPER(A.ITEM_ID), 1, 12) = SUBSTR(UPPER(R.ITEM_ID), 1, 12)   /* E20260325-001071 : 11 자리 -> 12 자리 */    -- 2026.10.08 POJ Pack Model 대소문자 무시
                       --AND A.ITEM_ID <> R.ITEM_ID
                       AND UPPER(RTRIM(A.ITEM_ID, ' ' || UNISTR('\3000'))) <> UPPER(RTRIM(R.ITEM_ID, ' ' || UNISTR('\3000')))    -- 2026.10.08 POJ 모델 대소문자 · 끝 공백 무시
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
                   --AND PROJECT_CODE = R.PROJECT_CODE
                   AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)    -- 2026.10.08 POJ 프로젝트 코드 대소문자 무시(중복 검사)
                   --AND SCM_SITE_ID = R.SCM_SITE_ID
                   AND UPPER(SCM_SITE_ID) = UPPER(R.SCM_SITE_ID)    -- 2026.10.08 POJ 사이트 코드 대소문자 무시(중복 검사)
                   --AND ITEM_ID = R.ITEM_ID;
                   AND UPPER(RTRIM(ITEM_ID, ' ' || UNISTR('\3000'))) = UPPER(RTRIM(R.ITEM_ID, ' ' || UNISTR('\3000')));    -- 2026.10.08 POJ 모델 대소문자 · 끝 공백 무시(중복 검사)
                IF V_CNT > 0 THEN
                    -- RAISE_INVALID('동일한 EndCustomer, SalesSite, Model에 대하여 중복저장이 불가합니다.');    -- 2026.10.09 POJ 원본
                    RAISE_INVALID(NVL(FN_GET_MSG_LANG('MSG00210', V_LANG_CD), 'MSG00210'));    -- 2026.10.09 POJ AS-IS 와 같은 MSG00210 문구를 사용자 언어로
                END IF;
                INSERT INTO SCM_MST_SITE_ITEM (
                    DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                    DEPT_ID,
                    SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
                    CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                    EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
                    --ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO, PRJ_OWNR_ID, ATTRIBUTE1 --2026.9.17 Sold-To Cust.(Report) 추가
                    ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO, PRJ_OWNR_ID, ATTRIBUTE1, ATTRIBUTE2, CUST_GROUP_DTL, APPLICATION, ROUTE    -- 2026.10.08 POJ 40 End Cust.(Report) · Cust Group Detail · Application · Channel 추가
                    , LIABILITY_PERIOD    -- 2026.10.09 POJ 신규 저장 Liability
                ) VALUES (
                    R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID,
--                  R.DEPT_ID,
                    V_DEPT_ID,                                                             -- 2026.09.17 AJS
                    R.SALES_PLAN_ADJUST_YN,
                    R.VALID_YN  --260828 : 'Y' Hard Coding 수정
                    , R.BPMS_EXIST, R.CUST_GROUP, R.OWNER,
                    R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
                    -- R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,    -- 2026.10.09 POJ 원본
                    R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, NVL(R.PARTIAL_PLAN_YN, 'N'),    -- 2026.10.09 POJ Partial Plan 신규 기본값 N
                    --R.ENERGE_WH, R.ATTRIBUTE9, R.PROJECT_INFO, R.PRJ_OWNR_ID, R.ATTRIBUTE1 --2026.9.17 Sold-To Cust.(Report) 추가
                    -- R.ENERGE_WH, R.ATTRIBUTE9, R.PROJECT_INFO, R.PRJ_OWNR_ID, R.ATTRIBUTE1, R.ATTRIBUTE2, R.CUST_GROUP_DTL, R.APPLICATION, R.ROUTE    -- 2026.10.08 POJ 40 End Cust.(Report) · Cust Group Detail · Application · Channel 추가    -- 2026.10.09 POJ 원본
                    NULL, R.ATTRIBUTE9, R.PROJECT_INFO, R.PRJ_OWNR_ID, R.ATTRIBUTE1, R.ATTRIBUTE2, R.CUST_GROUP_DTL, R.APPLICATION, R.ROUTE    -- 2026.10.09 POJ 40 행 추가 시 ATTRIBUTE8(Energy) 기록 안 함(AS-IS 와 같음 · 2026.09.30 수정 저장과 같게)
                    , 0    -- 2026.10.09 POJ 신규 저장 Liability 0(AS-IS 빈 값 → 0)
                );
                V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
            ELSIF R.DIVISION_ID LIKE '81%' OR R.DIVISION_ID = '82' THEN
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_PROJECT_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   --AND PROJECT_CODE = R.PROJECT_CODE
                   AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)    -- 2026.10.08 POJ 프로젝트 코드 대소문자 무시
                   AND VALID_YN = 'Y';
                IF V_CNT = 0 THEN
                    -- RAISE_INVALID('해당 프로젝트에 등록된 모델이 없습니다. 프로젝트 및 모델 정보를 확인해 주세요.');    -- 2026.10.09 POJ 원본
                    RAISE_INVALID(NVL(FN_GET_MSG_LANG('MSG00156', V_LANG_CD), 'MSG00156'));    -- 2026.10.09 POJ AS-IS 와 같은 MSG00156 문구를 사용자 언어로
                END IF;
                SELECT COUNT(*)
                  INTO V_CNT
                  FROM SCM_MST_SITE_ITEM
                 WHERE DIVISION_ID = R.DIVISION_ID
                   --AND PROJECT_CODE = R.PROJECT_CODE
                   AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)    -- 2026.10.08 POJ 프로젝트 코드 대소문자 무시(중복 검사)
                   --AND SCM_SITE_ID = R.SCM_SITE_ID;
                   AND UPPER(SCM_SITE_ID) = UPPER(R.SCM_SITE_ID);    -- 2026.10.08 POJ 사이트 코드 대소문자 무시(중복 검사)
                IF V_CNT > 0 THEN
                    RAISE_INVALID('동일한 Sales Site, Project Code 가 이미 존재합니다.');
                END IF;
                -- 2026.10.09 POJ 81 · 82 신규 Currency = 프로젝트 통화(AS-IS 프로젝트 팝업 반환값) (START)
                SELECT MAX(CURRENCY)
                  INTO V_CURRENCY
                  FROM SCM_MST_PROJECT
                 WHERE DIVISION_ID = R.DIVISION_ID
                   AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)
                   AND DROP_YN = 'N';
                -- 2026.10.09 POJ 81 · 82 신규 Currency = 프로젝트 통화(AS-IS 프로젝트 팝업 반환값) (END)
                FOR PI IN (
                    SELECT DISTINCT ITEM_ID
                    FROM SCM_MST_PROJECT_ITEM
                    WHERE DIVISION_ID = R.DIVISION_ID
                      --AND PROJECT_CODE = R.PROJECT_CODE
                      AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)    -- 2026.10.08 POJ 프로젝트 코드 대소문자 무시
                      AND VALID_YN = 'Y'
                ) LOOP
                    INSERT INTO SCM_MST_SITE_ITEM (
                        DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
                        DEPT_ID,
                        SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
                        CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
                        EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
                        ATTRIBUTE6, ATTRIBUTE8, CELL_PER_CAR, CELL_PER_MODULE, PRJ_OWNR_ID
                        -- 2026.10.09 POJ 신규 저장 칸 추가 (START)
                        , CURRENCY, ATTRIBUTE9, ATTRIBUTE10, LIABILITY_PERIOD
                        -- 2026.10.09 POJ 신규 저장 칸 추가 (END)
                    ) VALUES (
                        R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, PI.ITEM_ID,
--                      R.DEPT_ID,
                        V_DEPT_ID,                                                         -- 2026.09.17 AJS
                        R.SALES_PLAN_ADJUST_YN, NVL(R.VALID_YN, 'Y'), R.BPMS_EXIST, R.CUST_GROUP, R.OWNER,
                        R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
                        -- R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,    -- 2026.10.09 POJ 원본
                        R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, NVL(R.PARTIAL_PLAN_YN, 'N'),    -- 2026.10.09 POJ Partial Plan 신규 기본값 N
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.ATTRIBUTE6 ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_CAR ELSE NULL END,
                        CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_MODULE ELSE NULL END,
                        CASE WHEN R.DIVISION_ID = '82' THEN R.PRJ_OWNR_ID ELSE NULL END
                        -- 2026.10.09 POJ 신규 저장 Currency · Cell Name · Cell Type · Liability(AS-IS 와 같음) (START)
                        , V_CURRENCY
                        , NVL((SELECT MAX(X.ATTRIBUTE9) FROM SCM_MST_SITE_ITEM X WHERE X.DIVISION_ID = R.DIVISION_ID AND X.ITEM_ID = PI.ITEM_ID), R.ATTRIBUTE9)
                        , 'CELL_TYPE_00'
                        , 0
                        -- 2026.10.09 POJ 신규 저장 Currency · Cell Name · Cell Type · Liability(AS-IS 와 같음) (END)
                    );
                    V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
                END LOOP;
                -- 2026.10.09 POJ 81 신규 등록 모델 ERP 인터페이스 대상 적재(AS-IS 와 같음) (START)
                IF R.DIVISION_ID LIKE '81%' THEN
                    INSERT INTO GT_DXES_XIF_ERP_SITE_ITEM
                         ( DIVISION_ID
                         , SCM_SITE_ID
                         , PROJECT_CODE
                         , ITEM_ID
                         , CREATED_BY
                         , CREATION_DATE
                         , LAST_UPDATED_BY
                         , LAST_UPDATE_DATE )
                    SELECT DISTINCT
                           R.DIVISION_ID
                         , R.SCM_SITE_ID
                         , R.PROJECT_CODE
                         , ITEM_ID
                         , R.USER_ID
                         , SYSDATE
                         , R.USER_ID
                         , SYSDATE
                      FROM SCM_MST_PROJECT_ITEM
                     WHERE DIVISION_ID = R.DIVISION_ID
                       AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)
                       AND VALID_YN = 'Y';
                END IF;
                -- 2026.10.09 POJ 81 신규 등록 모델 ERP 인터페이스 대상 적재(AS-IS 와 같음) (END)
            END IF;
        ELSE
          -- 2026.10.08 POJ 기존 행을 대소문자 · 끝 공백 무시로 찾기(AS-IS 와 같은 비교 규칙 · 철자만 다른 새 행 방지) (START)
          SELECT COUNT(*)
            INTO V_CNT
            FROM SCM_MST_SITE_ITEM
           WHERE DIVISION_ID  = R.DIVISION_ID
             AND PROJECT_CODE = R.PROJECT_CODE
             AND SCM_SITE_ID  = R.SCM_SITE_ID
             AND ITEM_ID      = R.ITEM_ID;
          IF V_CNT = 0 THEN
              SELECT NVL(MAX(PROJECT_CODE), R.PROJECT_CODE)
                   , NVL(MAX(SCM_SITE_ID), R.SCM_SITE_ID)
                   , NVL(MAX(ITEM_ID), R.ITEM_ID)
                INTO V_KEY_PROJECT
                   , V_KEY_SITE
                   , V_KEY_ITEM
                FROM SCM_MST_SITE_ITEM
               WHERE DIVISION_ID = R.DIVISION_ID
                 AND UPPER(PROJECT_CODE) = UPPER(R.PROJECT_CODE)
                 AND UPPER(SCM_SITE_ID) = UPPER(R.SCM_SITE_ID)
                 AND UPPER(RTRIM(ITEM_ID, ' ' || UNISTR('\3000'))) = UPPER(RTRIM(R.ITEM_ID, ' ' || UNISTR('\3000')));
          END IF;
          -- 2026.10.08 POJ 기존 행을 대소문자 · 끝 공백 무시로 찾기(AS-IS 와 같은 비교 규칙 · 철자만 다른 새 행 방지) (END)
          -- 2026.10.09 POJ 저장 전 Inventory Days 문자열(이력 변경 표시용 · AS-IS Change_String) (START)
          SELECT MAX(CASE WHEN INVENTORY_DAY IS NOT NULL THEN CONSENSUS_MKT || CONSENSUS_ESS || CONSENSUS_SCM || INVENTORY_DAY || CHANGE_REASON END)
            INTO V_CHG_BEFORE
            FROM SCM_MST_SITE_ITEM
           WHERE DIVISION_ID  = R.DIVISION_ID
             AND PROJECT_CODE = V_KEY_PROJECT
             AND SCM_SITE_ID  = V_KEY_SITE
             AND ITEM_ID      = V_KEY_ITEM;
          -- 2026.10.09 POJ 저장 전 Inventory Days 문자열(이력 변경 표시용 · AS-IS Change_String) (END)
          UPDATE SCM_MST_SITE_ITEM A
             SET A.LAST_UPDATED_BY = R.USER_ID
             , A.LAST_UPDATE_DATE = SYSDATE
             , A.OWNER = NVL(R.OWNER, A.OWNER)
--           , A.DEPT_ID = NVL(R.DEPT_ID, A.DEPT_ID)
             , A.DEPT_ID = NVL(V_DEPT_ID, A.DEPT_ID)                                  -- 2026.09.17 AJS
             , A.SALES_COMPANY = NVL(R.SALES_COMPANY, A.SALES_COMPANY)
             , A.SALES_PLANT = NVL(R.SALES_PLANT, A.SALES_PLANT)
             , A.PARTIAL_PLAN_YN = NVL(R.PARTIAL_PLAN_YN, A.PARTIAL_PLAN_YN)
             , A.CUST_GROUP = NVL(R.CUST_GROUP, A.CUST_GROUP)
             , A.SALES_PLAN_ADJUST_YN = NVL(R.SALES_PLAN_ADJUST_YN, A.SALES_PLAN_ADJUST_YN)
             -- 2026.09.30 AJS F-24 40 사업부는 ATTRIBUTE8 을 기록하지 않는다 (START)
             -- , A.ATTRIBUTE8 = CASE
             --            WHEN R.DIVISION_ID = '40' THEN NVL(R.ENERGE_WH, A.ATTRIBUTE8)
             --            WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.KWH, A.ATTRIBUTE8)
             --            ELSE A.ATTRIBUTE8
             --          END
             , A.ATTRIBUTE8 = CASE
                        WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.KWH, A.ATTRIBUTE8)
                        ELSE A.ATTRIBUTE8
                      END
             -- 2026.09.30 AJS F-24 40 사업부는 ATTRIBUTE8 을 기록하지 않는다 (END)
             , A.ATTRIBUTE9 = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.ATTRIBUTE9, A.ATTRIBUTE9) ELSE A.ATTRIBUTE9 END
             -- 2026.10.09 POJ 화면이 보낸 칸이면 비운 값도 그대로 저장(AS-IS 와 같음) (START)
             -- , A.ATTRIBUTE1 = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.ATTRIBUTE1, A.ATTRIBUTE1) ELSE A.ATTRIBUTE1 END  --2026.9.17 Sold-To Cust.(Report) 추가
             -- , A.ATTRIBUTE2 = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.ATTRIBUTE2, A.ATTRIBUTE2) ELSE A.ATTRIBUTE2 END    -- 2026.10.08 POJ 40 End Cust.(Report) 추가
             -- , A.CUST_GROUP_DTL = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.CUST_GROUP_DTL, A.CUST_GROUP_DTL) ELSE A.CUST_GROUP_DTL END    -- 2026.10.08 POJ 40 Cust Group Detail 추가
             -- , A.APPLICATION = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.APPLICATION, A.APPLICATION) ELSE A.APPLICATION END    -- 2026.10.08 POJ 40 Application 추가
             -- , A.ROUTE = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.ROUTE, A.ROUTE) ELSE A.ROUTE END    -- 2026.10.08 POJ 40 Channel 추가
             -- , A.PROJECT_INFO = CASE WHEN R.DIVISION_ID = '40' THEN NVL(R.PROJECT_INFO, A.PROJECT_INFO) ELSE A.PROJECT_INFO END
             -- , A.ATTRIBUTE6 = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.ATTRIBUTE6, A.ATTRIBUTE6) ELSE A.ATTRIBUTE6 END
             -- , A.EDI_LT = NVL(R.EDI_LT, A.EDI_LT)
             , A.ATTRIBUTE1 = CASE WHEN R.DIVISION_ID = '40' THEN CASE WHEN R.ATTRIBUTE1_EX = 'true' THEN R.ATTRIBUTE1 ELSE A.ATTRIBUTE1 END ELSE A.ATTRIBUTE1 END
             , A.ATTRIBUTE2 = CASE WHEN R.DIVISION_ID = '40' THEN CASE WHEN R.ATTRIBUTE2_EX = 'true' THEN R.ATTRIBUTE2 ELSE A.ATTRIBUTE2 END ELSE A.ATTRIBUTE2 END
             , A.CUST_GROUP_DTL = CASE WHEN R.DIVISION_ID = '40' THEN CASE WHEN R.CUST_GROUP_DTL_EX = 'true' THEN R.CUST_GROUP_DTL ELSE A.CUST_GROUP_DTL END ELSE A.CUST_GROUP_DTL END
             , A.APPLICATION = CASE WHEN R.DIVISION_ID = '40' THEN CASE WHEN R.APPLICATION_EX = 'true' THEN R.APPLICATION ELSE A.APPLICATION END ELSE A.APPLICATION END
             , A.ROUTE = CASE WHEN R.DIVISION_ID = '40' THEN CASE WHEN R.ROUTE_EX = 'true' THEN R.ROUTE ELSE A.ROUTE END ELSE A.ROUTE END
             , A.PROJECT_INFO = CASE WHEN R.DIVISION_ID = '40' THEN CASE WHEN R.PROJECT_INFO_EX = 'true' THEN R.PROJECT_INFO ELSE A.PROJECT_INFO END ELSE A.PROJECT_INFO END
             , A.ATTRIBUTE6 = CASE WHEN R.DIVISION_ID LIKE '81%' THEN CASE WHEN R.ATTRIBUTE6_EX = 'true' THEN R.ATTRIBUTE6 ELSE A.ATTRIBUTE6 END ELSE A.ATTRIBUTE6 END
             , A.EDI_LT = CASE WHEN R.EDI_LT_EX = 'true' THEN R.EDI_LT ELSE A.EDI_LT END
             -- 2026.10.09 POJ 화면이 보낸 칸이면 비운 값도 그대로 저장(AS-IS 와 같음) (END)
             , A.SCP_VMI_LT = NVL(R.VMI_LT_NUM, A.SCP_VMI_LT)
             -- 2026.10.09 POJ 화면이 보낸 칸이면 비운 값도 그대로 저장(AS-IS 와 같음) (START)
             -- , A.CELL_PER_CAR = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.CELL_PER_CAR, A.CELL_PER_CAR) ELSE A.CELL_PER_CAR END
             -- , A.CELL_PER_MODULE = CASE WHEN R.DIVISION_ID LIKE '81%' THEN NVL(R.CELL_PER_MODULE, A.CELL_PER_MODULE) ELSE A.CELL_PER_MODULE END
             , A.CELL_PER_CAR = CASE WHEN R.DIVISION_ID LIKE '81%' THEN CASE WHEN R.CELL_PER_CAR_EX = 'true' THEN R.CELL_PER_CAR ELSE A.CELL_PER_CAR END ELSE A.CELL_PER_CAR END
             , A.CELL_PER_MODULE = CASE WHEN R.DIVISION_ID LIKE '81%' THEN CASE WHEN R.CELL_PER_MODULE_EX = 'true' THEN R.CELL_PER_MODULE ELSE A.CELL_PER_MODULE END ELSE A.CELL_PER_MODULE END
             -- 2026.10.09 POJ 화면이 보낸 칸이면 비운 값도 그대로 저장(AS-IS 와 같음) (END)
             , A.PRJ_OWNR_ID = CASE WHEN R.DIVISION_ID = '82' THEN NVL(R.PRJ_OWNR_ID, A.PRJ_OWNR_ID) ELSE A.PRJ_OWNR_ID END
             , A.VALID_YN = NVL(R.VALID_YN, A.VALID_YN)
             , A.BPMS_EXIST = NVL(R.BPMS_EXIST, A.BPMS_EXIST)
           WHERE A.DIVISION_ID = R.DIVISION_ID
             --AND A.PROJECT_CODE = R.PROJECT_CODE
             AND A.PROJECT_CODE = V_KEY_PROJECT    -- 2026.10.08 POJ 대소문자 · 끝 공백 무시로 찾은 기존 행 철자
             --AND A.SCM_SITE_ID = R.SCM_SITE_ID
             AND A.SCM_SITE_ID = V_KEY_SITE    -- 2026.10.08 POJ 대소문자 · 끝 공백 무시로 찾은 기존 행 철자
             --AND A.ITEM_ID = R.ITEM_ID;
             AND A.ITEM_ID = V_KEY_ITEM;    -- 2026.10.08 POJ 대소문자 · 끝 공백 무시로 찾은 기존 행 철자
          IF SQL%ROWCOUNT = 0 THEN
            INSERT INTO SCM_MST_SITE_ITEM (
              DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID,
              DEPT_ID,
              SALES_PLAN_ADJUST_YN, VALID_YN, BPMS_EXIST, CUST_GROUP, OWNER,
              CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE,
              EDI_LT, SCP_VMI_LT, SALES_COMPANY, SALES_PLANT, PARTIAL_PLAN_YN,
              --ATTRIBUTE6, ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO, ATTRIBUTE1, --2026.9.17 Sold-To Cust.(Report) 추가
              ATTRIBUTE6, ATTRIBUTE8, ATTRIBUTE9, PROJECT_INFO, ATTRIBUTE1, ATTRIBUTE2, CUST_GROUP_DTL, APPLICATION, ROUTE,    -- 2026.10.08 POJ 40 End Cust.(Report) · Cust Group Detail · Application · Channel 추가
              CELL_PER_CAR, CELL_PER_MODULE, PRJ_OWNR_ID
              -- 2026.10.09 POJ 신규 저장 Currency · Liability (START)
              , CURRENCY, LIABILITY_PERIOD
              -- 2026.10.09 POJ 신규 저장 Currency · Liability (END)
            ) VALUES (
              R.DIVISION_ID, R.PROJECT_CODE, R.SCM_SITE_ID, R.ITEM_ID,
--            R.DEPT_ID,
              V_DEPT_ID,                                                               -- 2026.09.17 AJS
              NVL(R.SALES_PLAN_ADJUST_YN, 'N'),
              NVL(R.VALID_YN, 'Y'),
              NVL(R.BPMS_EXIST, 'N'),
              R.CUST_GROUP,
              R.OWNER,
              R.USER_ID, SYSDATE, R.USER_ID, SYSDATE,
              -- R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, R.PARTIAL_PLAN_YN,    -- 2026.10.09 POJ 원본
              R.EDI_LT, R.VMI_LT_NUM, R.SALES_COMPANY, R.SALES_PLANT, NVL(R.PARTIAL_PLAN_YN, 'N'),    -- 2026.10.09 POJ Partial Plan 신규 기본값 N
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.ATTRIBUTE6 ELSE NULL END,
              -- 2026.09.30 AJS F-24 40 사업부는 ATTRIBUTE8 을 기록하지 않는다 (START)
              -- CASE
              --   WHEN R.DIVISION_ID = '40' THEN R.ENERGE_WH
              --   WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH
              --   ELSE NULL
              -- END,
              CASE
                WHEN R.DIVISION_ID LIKE '81%' THEN R.KWH
                ELSE NULL
              END,
              -- 2026.09.30 AJS F-24 40 사업부는 ATTRIBUTE8 을 기록하지 않는다 (END)
              CASE WHEN R.DIVISION_ID = '40' THEN R.ATTRIBUTE9 ELSE NULL END,
              CASE WHEN R.DIVISION_ID = '40' THEN R.PROJECT_INFO ELSE NULL END,
              --CASE WHEN R.DIVISION_ID = '40' THEN R.ATTRIBUTE1 ELSE NULL END, --2026.9.17 Sold-To Cust.(Report) 추가
              CASE WHEN R.DIVISION_ID = '40' THEN R.ATTRIBUTE1 ELSE NULL END, CASE WHEN R.DIVISION_ID = '40' THEN R.ATTRIBUTE2 ELSE NULL END, CASE WHEN R.DIVISION_ID = '40' THEN R.CUST_GROUP_DTL ELSE NULL END, CASE WHEN R.DIVISION_ID = '40' THEN R.APPLICATION ELSE NULL END, CASE WHEN R.DIVISION_ID = '40' THEN R.ROUTE ELSE NULL END,    -- 2026.10.08 POJ 40 End Cust.(Report) · Cust Group Detail · Application · Channel 추가
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_CAR ELSE NULL END,
              CASE WHEN R.DIVISION_ID LIKE '81%' THEN R.CELL_PER_MODULE ELSE NULL END,
              CASE WHEN R.DIVISION_ID = '82' THEN R.PRJ_OWNR_ID ELSE NULL END
              -- 2026.10.09 POJ 신규 저장 Currency(81 · 82 프로젝트 통화) · Liability(0) (START)
              , CASE WHEN R.DIVISION_ID = '40' THEN NULL ELSE (SELECT MAX(B.CURRENCY) FROM SCM_MST_PROJECT B WHERE B.DIVISION_ID = R.DIVISION_ID AND UPPER(B.PROJECT_CODE) = UPPER(R.PROJECT_CODE) AND B.DROP_YN = 'N') END
              , 0
              -- 2026.10.09 POJ 신규 저장 Currency(81 · 82 프로젝트 통화) · Liability(0) (END)
            );
          END IF;
            V_ROW_CNT := V_ROW_CNT + SQL%ROWCOUNT;
        END IF;
        -- 2026.10.08 POJ 같은 사업부 · 사이트 · 모델 VMI LT 맞춤(프로젝트 무관 · AS-IS 와 같은 처리) (START)
        /* AS-IS 와 같이 VMI LT 값만 맞춤(최종 변경자 · 일시는 그 행 저장 때만 기록) */
        UPDATE SCM_MST_SITE_ITEM
           SET SCP_VMI_LT = NVL(R.VMI_LT_NUM, 0)
         WHERE DIVISION_ID = R.DIVISION_ID
           AND UPPER(SCM_SITE_ID) = UPPER(V_KEY_SITE)
           AND UPPER(RTRIM(ITEM_ID, ' ' || UNISTR('\3000'))) = UPPER(RTRIM(V_KEY_ITEM, ' ' || UNISTR('\3000')))
           AND (SCP_VMI_LT IS NULL OR SCP_VMI_LT <> NVL(R.VMI_LT_NUM, 0));
        -- 2026.10.08 POJ 같은 사업부 · 사이트 · 모델 VMI LT 맞춤(프로젝트 무관 · AS-IS 와 같은 처리) (END)
        -- 2026.10.09 POJ 변경 이력 기록(AS-IS 와 같이 화면 1행당 1행) (START)
        INSERT INTO SCM_MST_SITE_ITEM_H
             ( HISTORY_SEQ
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , ITEM_ID
             , CURRENCY
             , CELL_PER_CAR
             , CELL_PER_MODULE
             , LIABILITY_PERIOD
             , SALES_PLAN_ADJUST_YN
             , ITEM_HRCY_ID
             , VALID_YN
             , BPMS_EXIST
             , CUST_GROUP
             , CUST_GROUP_DTL
             , DEPT_ID
             , OWNER
             , APPLICATION
             , ROUTE
             , EDI_LT
             , SCP_VMI_LT
             , SALES_COMPANY
             , SALES_PLANT
             , PARTIAL_PLAN_YN
             , PROJECT_INFO
             , PRJ_OWNR_ID
             , CREATED_BY
             , CREATION_DATE
             , LAST_UPDATED_BY
             , LAST_UPDATE_DATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE6
             , ATTRIBUTE8
             , ATTRIBUTE9
             , ATTRIBUTE10
             , REPORT_GROUP1
             , REPORT_GROUP2
             , REPORT_GROUP3
             , REPORT_GROUP4
             , REPORT_GROUP6
             , REPORT_GROUP7
             , REPORT_GROUP8
             , CONSENSUS_MKT
             , CONSENSUS_ESS
             , CONSENSUS_SCM
             , INVENTORY_DAY
             , CHANGE_REASON
             , ALT_SIM_YN
             , DESCRIPTION
             , PROJECT_S_OP_REPORT
             , CELL_S_OP_REPORT
             , CRGE_ORG_NM
             , CUST_ENG_NM )
        SELECT SEQ1_SCM_MST_SITE_ITEM_H.NEXTVAL
             , DIVISION_ID
             , PROJECT_CODE
             , SCM_SITE_ID
             , CASE WHEN R.CRUD_TYPE = 'I' AND (R.DIVISION_ID LIKE '81%' OR R.DIVISION_ID = '82') THEN NULL ELSE ITEM_ID END    /* 81 · 82 신규는 프로젝트 단위 1행 */
             , CURRENCY
             , CELL_PER_CAR
             , CELL_PER_MODULE
             , LIABILITY_PERIOD
             , SALES_PLAN_ADJUST_YN
             , ITEM_HRCY_ID
             , VALID_YN
             , BPMS_EXIST
             , CUST_GROUP
             , CUST_GROUP_DTL
             , DEPT_ID
             , OWNER
             , APPLICATION
             , ROUTE
             , EDI_LT
             , SCP_VMI_LT
             , SALES_COMPANY
             , SALES_PLANT
             , PARTIAL_PLAN_YN
             , PROJECT_INFO
             , PRJ_OWNR_ID
             , P_USER_ID
             , SYSDATE
             , P_USER_ID
             , SYSDATE
             , ATTRIBUTE1
             , ATTRIBUTE2
             , CASE WHEN NVL(V_CHG_BEFORE, '~') <> NVL(CONSENSUS_MKT || CONSENSUS_ESS || CONSENSUS_SCM || INVENTORY_DAY || CHANGE_REASON, '~') THEN 'Y' END    /* Inventory Days 변경 표시 */
             , ATTRIBUTE4
             , ATTRIBUTE6
             , ATTRIBUTE8
             , CASE WHEN R.CRUD_TYPE = 'I' AND (R.DIVISION_ID LIKE '81%' OR R.DIVISION_ID = '82') THEN R.ATTRIBUTE9 ELSE ATTRIBUTE9 END    /* 81 · 82 신규는 입력 Cell Name */
             , ATTRIBUTE10
             , REPORT_GROUP1
             , REPORT_GROUP2
             , REPORT_GROUP3
             , REPORT_GROUP4
             , REPORT_GROUP6
             , REPORT_GROUP7
             , REPORT_GROUP8
             , CONSENSUS_MKT
             , CONSENSUS_ESS
             , CONSENSUS_SCM
             , INVENTORY_DAY
             , CHANGE_REASON
             , ALT_SIM_YN
             , DESCRIPTION
             , PROJECT_S_OP_REPORT
             , CELL_S_OP_REPORT
             , CRGE_ORG_NM
             , CUST_ENG_NM
          FROM SCM_MST_SITE_ITEM
         WHERE DIVISION_ID  = R.DIVISION_ID
           AND PROJECT_CODE = V_KEY_PROJECT
           AND SCM_SITE_ID  = V_KEY_SITE
           AND (   ITEM_ID = V_KEY_ITEM
                OR (R.CRUD_TYPE = 'I' AND (R.DIVISION_ID LIKE '81%' OR R.DIVISION_ID = '82')) )
           AND ROWNUM = 1;
        -- 2026.10.09 POJ 변경 이력 기록(AS-IS 와 같이 화면 1행당 1행) (END)
        -- 2026.10.08 POJ 81 EDI Leadtime 재배치 대상 키 수집 (START)
        IF R.DIVISION_ID LIKE '81%' THEN
            V_IDX := V_EDI_KEY.COUNT + 1;
            V_EDI_KEY(V_IDX).DIVISION_ID  := R.DIVISION_ID;
            V_EDI_KEY(V_IDX).PROJECT_CODE := V_KEY_PROJECT;
            V_EDI_KEY(V_IDX).SCM_SITE_ID  := V_KEY_SITE;
            V_EDI_KEY(V_IDX).ITEM_ID      := V_KEY_ITEM;
            V_EDI_KEY(V_IDX).EDI_LT       := R.EDI_LT;
        END IF;
        -- 2026.10.08 POJ 81 EDI Leadtime 재배치 대상 키 수집 (END)
    END LOOP;
    -- 2026.10.08 POJ 81 EDI Leadtime 변경 시 MKT FCST EDI 측정 일자 재배치(AS-IS 와 같은 처리) (START)
    /* 저장한 81 행의 4키 중 당주 월요일 이후 EDI 측정의 기록 Leadtime(ATTRIBUTE8)이 새 Leadtime 과 다른 키만 대상
       대상 키는 EDI 측정 전체를 원래 일자(ATTRIBUTE7)에서 Leadtime 만큼 앞당긴 영업일로 옮기고, 같은 일자는 합산, 이력 기록 */
    V_W0_MONDAY := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');
    FOR K IN 1 .. V_EDI_KEY.COUNT LOOP
        SELECT NVL(V_EDI_KEY(K).EDI_LT, NVL(MAX(EDI_LT), 0))
          INTO V_EDI_LT
          FROM SCM_MST_SITE_ITEM
         WHERE DIVISION_ID  = V_EDI_KEY(K).DIVISION_ID
           AND PROJECT_CODE = V_EDI_KEY(K).PROJECT_CODE
           AND SCM_SITE_ID  = V_EDI_KEY(K).SCM_SITE_ID
           AND ITEM_ID      = V_EDI_KEY(K).ITEM_ID;
        SELECT COUNT(*)
          INTO V_CNT
          FROM DM_PLN_MKT_FCST
         WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
           AND DIVISION_ID       = V_EDI_KEY(K).DIVISION_ID
           AND PROJECT_CODE      = V_EDI_KEY(K).PROJECT_CODE
           AND SCM_SITE_ID       = V_EDI_KEY(K).SCM_SITE_ID
           AND ITEM_ID           = V_EDI_KEY(K).ITEM_ID
           AND YYYYMMDD         >= V_W0_MONDAY
           AND TO_NUMBER(ATTRIBUTE8) <> V_EDI_LT;
        IF V_CNT > 0 THEN
            /* 원래 행(이력용) — 일자는 옮길 일자 */
            SELECT DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , TO_CHAR(FN_NEXT_WORK_DAY(TO_DATE(NVL(ATTRIBUTE7, YYYYMMDD), 'YYYYMMDD'), V_EDI_LT * -1), 'YYYYMMDD')
                 , QTY
                 , CREATED_BY
                 , CREATION_DATE
                 , P_USER_ID
                 , SYSDATE
                 , ATTRIBUTE1
                 , ATTRIBUTE2
                 , ATTRIBUTE3
                 , ATTRIBUTE4
                 , ATTRIBUTE5
                 , ATTRIBUTE6
                 , ATTRIBUTE7
                 , TO_CHAR(V_EDI_LT)
                 , ATTRIBUTE9
                 , ATTRIBUTE10
              BULK COLLECT INTO V_EDI_ROW
              FROM DM_PLN_MKT_FCST
             WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
               AND DIVISION_ID   = V_EDI_KEY(K).DIVISION_ID
               AND PROJECT_CODE  = V_EDI_KEY(K).PROJECT_CODE
               AND SCM_SITE_ID   = V_EDI_KEY(K).SCM_SITE_ID
               AND ITEM_ID       = V_EDI_KEY(K).ITEM_ID
               AND YYYYMMDD     >= V_W0_MONDAY;
            /* 옮길 일자 기준 합산 행(토 · 일 수요가 같은 평일로 모이면 합산) */
            SELECT DIVISION_ID
                 , PROJECT_CODE
                 , SCM_SITE_ID
                 , ITEM_ID
                 , DOM_EXP
                 , FCST_TYPE
                 , INCOTERMS
                 , MEASURE
                 , PLANT_SITE_ID
                 , TO_CHAR(FN_NEXT_WORK_DAY(TO_DATE(NVL(ATTRIBUTE7, YYYYMMDD), 'YYYYMMDD'), V_EDI_LT * -1), 'YYYYMMDD')
                 , SUM(QTY)
                 , MAX(CREATED_BY)
                 , MAX(CREATION_DATE)
                 , P_USER_ID
                 , SYSDATE
                 , MAX(ATTRIBUTE1)
                 , MAX(ATTRIBUTE2)
                 , MAX(ATTRIBUTE3)
                 , MAX(ATTRIBUTE4)
                 , MAX(ATTRIBUTE5)
                 , MAX(ATTRIBUTE6)
                 , MAX(ATTRIBUTE7)
                 , TO_CHAR(V_EDI_LT)
                 , MAX(ATTRIBUTE9)
                 , MAX(ATTRIBUTE10)
              BULK COLLECT INTO V_EDI_GRP
              FROM DM_PLN_MKT_FCST
             WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
               AND DIVISION_ID   = V_EDI_KEY(K).DIVISION_ID
               AND PROJECT_CODE  = V_EDI_KEY(K).PROJECT_CODE
               AND SCM_SITE_ID   = V_EDI_KEY(K).SCM_SITE_ID
               AND ITEM_ID       = V_EDI_KEY(K).ITEM_ID
               AND YYYYMMDD     >= V_W0_MONDAY
             GROUP BY DIVISION_ID
                    , PROJECT_CODE
                    , SCM_SITE_ID
                    , ITEM_ID
                    , DOM_EXP
                    , FCST_TYPE
                    , INCOTERMS
                    , MEASURE
                    , PLANT_SITE_ID
                    , TO_CHAR(FN_NEXT_WORK_DAY(TO_DATE(NVL(ATTRIBUTE7, YYYYMMDD), 'YYYYMMDD'), V_EDI_LT * -1), 'YYYYMMDD');
            /* 원래 일자 삭제 */
            DELETE
              FROM DM_PLN_MKT_FCST
             WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
               AND DIVISION_ID   = V_EDI_KEY(K).DIVISION_ID
               AND PROJECT_CODE  = V_EDI_KEY(K).PROJECT_CODE
               AND SCM_SITE_ID   = V_EDI_KEY(K).SCM_SITE_ID
               AND ITEM_ID       = V_EDI_KEY(K).ITEM_ID
               AND YYYYMMDD     >= V_W0_MONDAY;
            /* 옮길 일자에 이미 있는 EDI 측정 삭제(기본키 충돌 방지) */
            FORALL I IN 1 .. V_EDI_GRP.COUNT
                DELETE
                  FROM DM_PLN_MKT_FCST
                 WHERE MEASURE IN ('CUST_FCST_EDI', 'Immidiate', 'Planning_Forecast', 'Commercial_Agreement', 'Firm_Temp', 'Manumacturing_Material_Temp', 'Material_Temp', 'Backorder')
                   AND DIVISION_ID   = V_EDI_GRP(I).DIVISION_ID
                   AND PROJECT_CODE  = V_EDI_GRP(I).PROJECT_CODE
                   AND SCM_SITE_ID   = V_EDI_GRP(I).SCM_SITE_ID
                   AND ITEM_ID       = V_EDI_GRP(I).ITEM_ID
                   AND DOM_EXP       = V_EDI_GRP(I).DOM_EXP
                   AND FCST_TYPE     = V_EDI_GRP(I).FCST_TYPE
                   AND INCOTERMS     = V_EDI_GRP(I).INCOTERMS
                   AND PLANT_SITE_ID = V_EDI_GRP(I).PLANT_SITE_ID
                   AND YYYYMMDD      = V_EDI_GRP(I).YYYYMMDD;
            FORALL I IN 1 .. V_EDI_GRP.COUNT
                INSERT INTO DM_PLN_MKT_FCST
                     ( DIVISION_ID
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , QTY
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
                     , ATTRIBUTE10 )
                VALUES
                     ( V_EDI_GRP(I).DIVISION_ID
                     , V_EDI_GRP(I).PROJECT_CODE
                     , V_EDI_GRP(I).SCM_SITE_ID
                     , V_EDI_GRP(I).ITEM_ID
                     , V_EDI_GRP(I).DOM_EXP
                     , V_EDI_GRP(I).FCST_TYPE
                     , V_EDI_GRP(I).INCOTERMS
                     , V_EDI_GRP(I).MEASURE
                     , V_EDI_GRP(I).PLANT_SITE_ID
                     , V_EDI_GRP(I).YYYYMMDD
                     , V_EDI_GRP(I).QTY
                     , V_EDI_GRP(I).CREATED_BY
                     , V_EDI_GRP(I).CREATION_DATE
                     , V_EDI_GRP(I).LAST_UPDATED_BY
                     , V_EDI_GRP(I).LAST_UPDATE_DATE
                     , V_EDI_GRP(I).ATTRIBUTE1
                     , V_EDI_GRP(I).ATTRIBUTE2
                     , V_EDI_GRP(I).ATTRIBUTE3
                     , V_EDI_GRP(I).ATTRIBUTE4
                     , V_EDI_GRP(I).ATTRIBUTE5
                     , V_EDI_GRP(I).ATTRIBUTE6
                     , V_EDI_GRP(I).ATTRIBUTE7
                     , V_EDI_GRP(I).ATTRIBUTE8
                     , V_EDI_GRP(I).ATTRIBUTE9
                     , V_EDI_GRP(I).ATTRIBUTE10 );
            /* MKT FCST 이력 — 원래 행마다 1행 */
            FORALL I IN 1 .. V_EDI_ROW.COUNT
                INSERT INTO DM_PLN_MKT_FCST_H
                     ( DIVISION_ID
                     , HISTORY_SEQ
                     , PROJECT_CODE
                     , SCM_SITE_ID
                     , ITEM_ID
                     , DOM_EXP
                     , FCST_TYPE
                     , INCOTERMS
                     , MEASURE
                     , PLANT_SITE_ID
                     , YYYYMMDD
                     , QTY
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
                     , ATTRIBUTE10 )
                VALUES
                     ( V_EDI_ROW(I).DIVISION_ID
                     , SEQ1_DM_PLN_MKT_FCST_H.NEXTVAL
                     , V_EDI_ROW(I).PROJECT_CODE
                     , V_EDI_ROW(I).SCM_SITE_ID
                     , V_EDI_ROW(I).ITEM_ID
                     , V_EDI_ROW(I).DOM_EXP
                     , V_EDI_ROW(I).FCST_TYPE
                     , V_EDI_ROW(I).INCOTERMS
                     , V_EDI_ROW(I).MEASURE
                     , V_EDI_ROW(I).PLANT_SITE_ID
                     , V_EDI_ROW(I).YYYYMMDD
                     , V_EDI_ROW(I).QTY
                     , V_EDI_ROW(I).CREATED_BY
                     , V_EDI_ROW(I).CREATION_DATE
                     , V_EDI_ROW(I).LAST_UPDATED_BY
                     , V_EDI_ROW(I).LAST_UPDATE_DATE
                     , V_EDI_ROW(I).ATTRIBUTE1
                     , V_EDI_ROW(I).ATTRIBUTE2
                     , V_EDI_ROW(I).ATTRIBUTE3
                     , V_EDI_ROW(I).ATTRIBUTE4
                     , V_EDI_ROW(I).ATTRIBUTE5
                     , V_EDI_ROW(I).ATTRIBUTE6
                     , V_EDI_ROW(I).ATTRIBUTE7
                     , V_EDI_ROW(I).ATTRIBUTE8
                     , V_EDI_ROW(I).ATTRIBUTE9
                     , V_EDI_ROW(I).ATTRIBUTE10 );
        END IF;
    END LOOP;
    -- 2026.10.08 POJ 81 EDI Leadtime 변경 시 MKT FCST EDI 측정 일자 재배치(AS-IS 와 같은 처리) (END)
    -- [2026-09-30 / POJ] 최종 부서를 SCM_MST_SITE.ETL_DEPT_ID 에 반영 — 이번 저장이 다룬 사이트만
    UPDATE SCM_MST_SITE A
       SET A.ETL_DEPT_ID      = ( SELECT MAX(B.DEPT_ID)
                                    FROM SCM_MST_SITE_ITEM B
                                   WHERE B.DIVISION_ID = A.DIVISION_ID
                                     AND B.SCM_SITE_ID = A.SCM_SITE_ID
                                     AND B.VALID_YN    = 'Y'
                                     AND B.DEPT_ID IS NOT NULL )
         , A.LAST_UPDATED_BY  = P_USER_ID
         , A.LAST_UPDATE_DATE = SYSDATE
     WHERE EXISTS ( SELECT 1
                      FROM SCM_MST_SITE_ITEM B
                     WHERE B.DIVISION_ID = A.DIVISION_ID
                       AND B.SCM_SITE_ID = A.SCM_SITE_ID
                       AND B.VALID_YN    = 'Y'
                       AND B.DEPT_ID IS NOT NULL )
       AND ( A.DIVISION_ID, A.SCM_SITE_ID ) IN
           ( SELECT TRIM(C.DIVISION_ID), TRIM(C.SCM_SITE_ID)
               FROM JSON_TABLE( P_DATA, '$[*]'
                      COLUMNS ( DIVISION_ID VARCHAR2(30) PATH '$.DIVISION_ID'
                              , SCM_SITE_ID VARCHAR2(30) PATH '$.SCM_SITE_ID' ) ) C );
    -- 2026.10.09 POJ 81 저장분 ERP 사이트 · 모델 인터페이스 전송(AS-IS 와 같음) (START)
    /* AS-IS : 저장한 행에 81 이 있으면 저장 트랜잭션 안에서 전송 프로시저 호출 — 전송 프로시저가 확정까지 하므로 마지막 확정 바로 앞 */
    IF V_EDI_KEY.COUNT > 0 THEN
        PR_DM_XIF_ERP_SITE_ITEM_S(V_XIF_CURSOR);
        DELETE FROM GT_DXES_XIF_ERP_SITE_ITEM;
    END IF;
    -- 2026.10.09 POJ 81 저장분 ERP 사이트 · 모델 인터페이스 전송(AS-IS 와 같음) (END)
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
/*
 * ==========================================================================================================
 * P_DMF0005_SAVE_MODEL_CHANGE_POPUP — Model Code Change 팝업 저장 (40 사업부 ITEM_ID 일괄 변경)
 * ----------------------------------------------------------------------------------------------------------
 * AS-IS : LGCE_SCMDEV dbo.DMF0005_SAVE_MODEL_CHANGE_POPUP (1,502줄, modify 2023-08-23)
 *         호출 = GSCM.DM.Plan.UIL.POPUP.DMF0005_ModelCodeChange.SaveData
 *         [C20220103-000584] 소형 패커 코드 변경 관리 / [C20220121-000372] 소형사업부 Model Code Change
 * 입력  : P_DATA = JSON 배열 [{ "ITEM_ID_BEFORE": "...", "ITEM_ID_AFTER": "..." }, ...]
 *         (AS-IS '^' 구분 3배열 → PKG 형제 SAVE SP 의 JSON CLOB 관례로 통일. 키 = AS-IS 컬럼명)
 *         P_USER_ID = LAST_UPDATED_BY / CREATED_BY
 * 출력  : O_RESULT_CURSOR (CODE, MSG, EVENT)
 *           성공   '0'  / 'SUCCESS' / 처리한 변경쌍 수 (AS-IS 화면 "{0}개의 데이터가 저장되었습니다" 의 {0})
 *           검증   '-1' / AS-IS 검증 문구 원문 / '0'
 *           예외   RAISE_APPLICATION_ERROR(-20001) — 전체 ROLLBACK
 * 변환 메모
 *   1) 검증 7종은 AS-IS 순서·문구 그대로 (검증 종류 순서대로, 종류 안에서는 입력 순서 첫 위반 1건)
 *      - MSSQL LEN('')=0 → Oracle ''=NULL 이므로 NVL(LENGTH(x),0) 로 동등 처리
 *      - MSSQL CI 비교 동등 — 입력값 UPPER(TRIM()) (DM_MST_ITEM_SINGLE_V 40 사업부 소문자 ITEM_ID 0건 실측 2026-10-01)
 *   2) 38 테이블 갱신 = 테이블별 대상 ROWID 선수집 → ROWID UPDATE (AS-IS UPDATE..FROM JOIN 동시 평가와 동등 —
 *      A→B, B→C 가 같은 배치여도 연쇄 변환되지 않음). 같은 BEFORE 가 여러 AFTER 면 MAX(AFTER) 로 결정화.
 *      DIVISION_ID='40' 필터 = 37 테이블 / DM_MST_EDI_CUST_MATERIAL_INFO 1 테이블은 AS-IS 대로 필터 없음
 *   3) 이력 DM_DNM_ITEM_CODE_CHANGE_HISTORY — (BEFORE,AFTER) 별 DATA_SEQ = 갱신 전 기존 MAX+1 (전 테이블 공통),
 *      갱신 건수 > 0 인 (쌍, 테이블) 만 1행
 *   4) 입력 중복 쌍은 DISTINCT (AS-IS 는 중복 쌍이 COUNT 를 배로 집계해 이력 건수가 부풀었다)
 * 2026.10.01   Claude(Code)   [DMF0005] AS-IS DMF0005_SAVE_MODEL_CHANGE_POPUP 변환 신규
 * 2026.10.13   Claude(Code)   [E20261013-DMF0005MCDUP] 키 중복 사전 검증 추가 (ORA-00001 대신 검증 메시지)
 * ==========================================================================================================
 */
PROCEDURE P_DMF0005_SAVE_MODEL_CHANGE_POPUP (
      P_DATA            IN CLOB
    , P_USER_ID         IN VARCHAR2
    , O_RESULT_CURSOR   OUT SYS_REFCURSOR
)
AS
    EX_BIZ_EX       EXCEPTION;
    V_ERR_MSG       VARCHAR2(4000);
    V_CNT           NUMBER := 0;
    V_TOT_ROWS      NUMBER := 0;
    TYPE T_VC_TAB   IS TABLE OF VARCHAR2(200) INDEX BY PLS_INTEGER;
    TYPE T_RID_TAB  IS TABLE OF UROWID        INDEX BY PLS_INTEGER;
    TYPE T_SEQ_MAP  IS TABLE OF NUMBER        INDEX BY VARCHAR2(401);
    TYPE T_STR_MAP  IS TABLE OF VARCHAR2(200) INDEX BY VARCHAR2(200);
    TYPE T_CNT_MAP  IS TABLE OF NUMBER        INDEX BY VARCHAR2(200);
    V_BEFORE        T_VC_TAB;      -- 변경 전 ITEM_ID (입력 순서, 중복 쌍 제거)
    V_AFTER         T_VC_TAB;      -- 변경 후 ITEM_ID
    V_SEQ           T_SEQ_MAP;     -- (BEFORE || CHR(1) || AFTER) → 이력 DATA_SEQ
    V_MAP           T_STR_MAP;     -- BEFORE → AFTER (같은 BEFORE 가 여러 AFTER 면 MAX — AS-IS UPDATE..FROM 비결정 → 결정화)
    V_BEF_LIST      SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();   -- 갱신 대상 BEFORE 목록 (SQL 바인드용)
    PROCEDURE RAISE_INVALID(P_MSG IN VARCHAR2) IS
    BEGIN
        V_ERR_MSG := P_MSG;
        RAISE EX_BIZ_EX;
    END;
    --[E20261013-DMF0005MCDUP] 키 중복 사전 검증 (START)
    --   ITEM_ID 를 포함한 유일 인덱스가 있는 테이블은, 변경 전 Model 행의 ITEM_ID 를 바꾸면 키가 겹칠 수 있다
    --   (같은 키에 변경 후 Model 이 이미 등록된 경우). 종전에는 ORA-00001 로 실패해 화면에 SQL ERROR 만 보였다.
    --   AS-IS 도 사전 검사 없이 실패(전체 ROLLBACK)하므로 저장 불가 결과는 같다 — 안내 문구만 더한다.
    --   ① 유일 인덱스·키 컬럼은 딕셔너리에서 읽는다 (환경마다 키 구성이 달라도 동작)
    --   ② 판정 = 갱신 뒤 키가 겹치는가. 상대 행이 같은 배치에서 다른 코드로 옮겨가면 겹치지 않고,
    --      서로 다른 변경 전 Model 두 개가 같은 변경 후 Model 로 모여도 겹친다.
    PROCEDURE CHECK_DUP(P_TABLE IN VARCHAR2, P_DIV40 IN BOOLEAN) IS
        V_PAIRS   SYS.ODCIVARCHAR2LIST := SYS.ODCIVARCHAR2LIST();   -- BEFORE(12) || AFTER(12)
        V_XF      VARCHAR2(100) := CASE WHEN P_DIV40 THEN ' AND X.DIVISION_ID = ''40''' END;
        V_YF      VARCHAR2(100) := CASE WHEN P_DIV40 THEN ' AND Y.DIVISION_ID = ''40''' END;
        V_JOIN    VARCHAR2(8000);
        V_KEYTXT  VARCHAR2(8000);
        V_B       VARCHAR2(200);
        V_A       VARCHAR2(200);
        V_KEY     VARCHAR2(4000);
        V_FOUND   BOOLEAN;
    BEGIN
        FOR I IN 1 .. V_BEF_LIST.COUNT LOOP
            V_PAIRS.EXTEND;
            V_PAIRS(I) := V_BEF_LIST(I) || V_MAP(V_BEF_LIST(I));
        END LOOP;
        FOR IX IN ( SELECT I.INDEX_NAME
                      FROM USER_INDEXES I
                     WHERE I.TABLE_NAME = P_TABLE
                       AND I.UNIQUENESS = 'UNIQUE'
                       AND EXISTS ( SELECT 1 FROM USER_IND_COLUMNS C
                                     WHERE C.INDEX_NAME = I.INDEX_NAME AND C.COLUMN_NAME = 'ITEM_ID' )
                       AND NOT EXISTS ( SELECT 1 FROM USER_IND_COLUMNS C
                                         WHERE C.INDEX_NAME = I.INDEX_NAME
                                           AND NOT EXISTS ( SELECT 1 FROM USER_TAB_COLUMNS T
                                                             WHERE T.TABLE_NAME = P_TABLE AND T.COLUMN_NAME = C.COLUMN_NAME ) )
                     ORDER BY I.INDEX_NAME ) LOOP
            V_JOIN   := NULL;
            V_KEYTXT := NULL;
            FOR C IN ( SELECT IC.COLUMN_NAME, TC.DATA_TYPE, TC.NULLABLE
                         FROM USER_IND_COLUMNS IC
                         JOIN USER_TAB_COLUMNS TC ON TC.TABLE_NAME = P_TABLE AND TC.COLUMN_NAME = IC.COLUMN_NAME
                        WHERE IC.INDEX_NAME  = IX.INDEX_NAME
                          AND IC.COLUMN_NAME <> 'ITEM_ID'
                        ORDER BY IC.COLUMN_POSITION ) LOOP
                -- NOT NULL 컬럼은 등호(인덱스 사용), NULL 허용 컬럼은 NULL 끼리도 같은 값으로 본다(유일 인덱스 규칙)
                V_JOIN := V_JOIN || CASE WHEN C.NULLABLE = 'N'
                                         THEN ' AND Y.' || C.COLUMN_NAME || ' = X.' || C.COLUMN_NAME
                                         ELSE ' AND DECODE(Y.' || C.COLUMN_NAME || ', X.' || C.COLUMN_NAME || ', 1, 0) = 1' END;
                -- 날짜는 형식을 명시해 문자로 바꾼다 (세션 날짜 형식에 기대지 않는다)
                V_KEYTXT := V_KEYTXT || CASE WHEN V_KEYTXT IS NOT NULL THEN ' || '', '' || ' END
                         || '''' || C.COLUMN_NAME || '='' || '
                         || CASE WHEN C.DATA_TYPE = 'DATE' OR C.DATA_TYPE LIKE 'TIMESTAMP%'
                                 THEN 'TO_CHAR(X.' || C.COLUMN_NAME || ', ''YYYY-MM-DD HH24:MI:SS'')'
                                 ELSE 'TO_CHAR(X.' || C.COLUMN_NAME || ')' END;
            END LOOP;
            BEGIN
                EXECUTE IMMEDIATE
                       'SELECT B, A, K FROM ('
                    || ' SELECT SUBSTR(L.COLUMN_VALUE, 1, 12) AS B, SUBSTR(L.COLUMN_VALUE, 13, 12) AS A'
                    || '      , SUBSTR(' || NVL(V_KEYTXT, '''-''') || ', 1, 500) AS K'
                    || '   FROM TABLE(:L1) L JOIN ' || P_TABLE || ' X ON X.ITEM_ID = SUBSTR(L.COLUMN_VALUE, 1, 12)'
                    || '  WHERE 1 = 1' || V_XF
                    || '    AND EXISTS ( SELECT 1 FROM ' || P_TABLE || ' Y'
                    || '                  WHERE Y.ROWID <> X.ROWID' || V_JOIN
                    || '                    AND ( ( Y.ITEM_ID = SUBSTR(L.COLUMN_VALUE, 13, 12)'
                    || '                            AND NOT ( Y.ITEM_ID IN (SELECT SUBSTR(L2.COLUMN_VALUE, 1, 12) FROM TABLE(:L2) L2)' || V_YF || ' ) )'
                    || '                       OR ( Y.ITEM_ID IN (SELECT SUBSTR(L3.COLUMN_VALUE, 1, 12) FROM TABLE(:L3) L3'
                    || '                                           WHERE SUBSTR(L3.COLUMN_VALUE, 13, 12) = SUBSTR(L.COLUMN_VALUE, 13, 12))' || V_YF || ' ) ) )'
                    || ' ) WHERE ROWNUM = 1'
                    INTO V_B, V_A, V_KEY
                    USING V_PAIRS, V_PAIRS, V_PAIRS;
                V_FOUND := TRUE;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    V_FOUND := FALSE;
            END;
            IF V_FOUND THEN
                RAISE_INVALID('변경 후 Model 코드가 같은 키로 이미 등록되어 있어 변경할 수 없습니다.' || CHR(10)
                           || 'MODEL : ' || V_B || ' -> ' || V_A || CHR(10)
                           || 'TABLE : ' || P_TABLE || CHR(10)
                           || 'KEY : ' || V_KEY);
            END IF;
        END LOOP;
    END CHECK_DUP;
    --[E20261013-DMF0005MCDUP] 키 중복 사전 검증 (END)
    -- 테이블 1개 갱신
    --   ① 대상 ROWID 를 먼저 모두 수집 (BEFORE 목록 IN — 컬렉션 건수 힌트로 ITEM_ID 인덱스 사용 / 무인덱스 테이블은 1회 스캔)
    --   ② 수집한 ROWID 로 UPDATE — 수집 후 갱신이라 AS-IS UPDATE..FROM 동시 평가와 같다 (A→B, B→C 연쇄 없음)
    --   ③ BEFORE 별 건수(= AS-IS #RESULTS_INSERT COUNT) 로 이력 1행씩
    --   [2026-10-01 성능] 1차본은 테이블마다 JSON_TABLE(:P_DATA) 를 조인 원천으로 써서 건수 오추정(8168)
    --   → 대형 테이블에서 문장당 수 분. 변경쌍은 JSON 1회 파싱 후 컬렉션으로만 전달한다.
    PROCEDURE CHANGE_TABLE(P_TABLE IN VARCHAR2, P_DIV40 IN BOOLEAN) IS
        V_FILTER  VARCHAR2(100) := CASE WHEN P_DIV40 THEN ' AND X.DIVISION_ID = ''40''' END;
        V_RIDS    T_RID_TAB;
        V_ITEMS   T_VC_TAB;
        V_NEWS    T_VC_TAB;
        V_N       T_CNT_MAP;
        V_K       VARCHAR2(200);
    BEGIN
        EXECUTE IMMEDIATE
               'SELECT X.ROWID, X.ITEM_ID FROM ' || P_TABLE || ' X'
            || ' WHERE X.ITEM_ID IN (SELECT /*+ CARDINALITY(L 10) */ L.COLUMN_VALUE FROM TABLE(:L) L)' || V_FILTER
            BULK COLLECT INTO V_RIDS, V_ITEMS
            USING V_BEF_LIST;
        IF V_RIDS.COUNT = 0 THEN
            RETURN;
        END IF;
        CHECK_DUP(P_TABLE, P_DIV40);   --[E20261013-DMF0005MCDUP] 갱신 직전 키 중복 검증 — 겹치면 검증 메시지로 차단(전체 ROLLBACK)
        FOR I IN 1 .. V_RIDS.COUNT LOOP
            V_NEWS(I) := V_MAP(V_ITEMS(I));
            V_N(V_ITEMS(I)) := NVL(CASE WHEN V_N.EXISTS(V_ITEMS(I)) THEN V_N(V_ITEMS(I)) END, 0) + 1;
        END LOOP;
        FORALL I IN 1 .. V_RIDS.COUNT
            EXECUTE IMMEDIATE
                   'UPDATE ' || P_TABLE
                || '   SET ITEM_ID = :A, LAST_UPDATED_BY = :U, LAST_UPDATE_DATE = SYSDATE'
                || ' WHERE ROWID = :R'
                USING V_NEWS(I), P_USER_ID, V_RIDS(I);
        V_K := V_N.FIRST;
        WHILE V_K IS NOT NULL LOOP
            INSERT INTO DM_DNM_ITEM_CODE_CHANGE_HISTORY (
                  BEFORE_CODE, AFTER_CODE, DATA_SEQ, TABLE_NAME, ROW_COUNT
                , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            ) VALUES (
                  V_K, V_MAP(V_K), V_SEQ(V_K || CHR(1) || V_MAP(V_K)), P_TABLE, V_N(V_K)
                , P_USER_ID, SYSDATE, P_USER_ID, SYSDATE
            );
            V_TOT_ROWS := V_TOT_ROWS + V_N(V_K);
            V_K := V_N.NEXT(V_K);
        END LOOP;
    END CHANGE_TABLE;
BEGIN
    SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'START', 0, '########## Start of procedure ##########', NULL, SYSDATE);
    /* =========================
       변경쌍 적재 (입력 순서 보존, 중복 쌍 제거)
       ========================= */
    SELECT B, A
      BULK COLLECT INTO V_BEFORE, V_AFTER
      FROM (
            SELECT UPPER(TRIM(J.ITEM_ID_BEFORE)) AS B
                 , UPPER(TRIM(J.ITEM_ID_AFTER))  AS A
                 , MIN(J.RN)                     AS RN
              FROM JSON_TABLE(P_DATA, '$[*]' COLUMNS (
                         RN             FOR ORDINALITY
                       , ITEM_ID_BEFORE VARCHAR2(200) PATH '$.ITEM_ID_BEFORE'
                       , ITEM_ID_AFTER  VARCHAR2(200) PATH '$.ITEM_ID_AFTER')) J
             GROUP BY UPPER(TRIM(J.ITEM_ID_BEFORE)), UPPER(TRIM(J.ITEM_ID_AFTER))
           )
     ORDER BY RN;
    IF V_BEFORE.COUNT = 0 THEN
        OPEN O_RESULT_CURSOR FOR
            SELECT '0' AS CODE, 'SUCCESS' AS MSG, '0' AS EVENT FROM DUAL;
        RETURN;
    END IF;
    /* =========================
       VALIDATION (AS-IS 순서·문구 원문)
       ========================= */
    -- 문자 길이가 12자리인지 (BEFORE)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF NVL(LENGTH(V_BEFORE(I)), 0) <> 12 THEN
            RAISE_INVALID('Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.' || CHR(10) || 'MODEL : ' || V_BEFORE(I));
        END IF;
    END LOOP;
    -- 문자 길이가 12자리인지 (AFTER)
    FOR I IN 1 .. V_AFTER.COUNT LOOP
        IF NVL(LENGTH(V_AFTER(I)), 0) <> 12 THEN
            RAISE_INVALID('Model 코드의 자리수가 12자리가 아니므로 변경할 수 없습니다.' || CHR(10) || 'MODEL : ' || V_AFTER(I));
        END IF;
    END LOOP;
    -- 앞의 11자리가 같은지
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF SUBSTR(V_BEFORE(I), 1, 11) <> SUBSTR(V_AFTER(I), 1, 11) THEN
            RAISE_INVALID('Model 코드의 앞 11자리가 서로 다르므로 변경할 수 없습니다.' || 'MODEL : ' || V_BEFORE(I) || ', ' || V_AFTER(I));
        END IF;
    END LOOP;
    -- 맨 앞 두 글자가 MP 인지 (BEFORE)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF SUBSTR(V_BEFORE(I), 1, 2) <> 'MP' THEN
            RAISE_INVALID('Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.' || 'MODEL : ' || V_BEFORE(I));
        END IF;
    END LOOP;
    -- 맨 앞 두 글자가 MP 인지 (AFTER)
    FOR I IN 1 .. V_AFTER.COUNT LOOP
        IF SUBSTR(V_AFTER(I), 1, 2) <> 'MP' THEN
            RAISE_INVALID('Model 코드가 ''MP''로 시작하지 않는 코드는 변경할 수 없습니다.' || 'MODEL : ' || V_AFTER(I));
        END IF;
    END LOOP;
    -- 변경 전·후 모델코드가 동일한지 (12번째 글자가 다른지)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF V_BEFORE(I) = V_AFTER(I) THEN
            RAISE_INVALID('변경전 후의 모델코드가 동일합니다.' || 'MODEL : ' || V_BEFORE(I));
        END IF;
    END LOOP;
    -- 40 사업부 품목 마스터 존재 여부 (BEFORE 우선 표기)
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        SELECT COUNT(*) INTO V_CNT FROM DM_MST_ITEM_SINGLE_V WHERE ITEM_ID = V_BEFORE(I) AND DIVISION_ID = '40';
        IF V_CNT = 0 THEN
            RAISE_INVALID(V_BEFORE(I) || '은 존재하지 않는 코드입니다.');
        END IF;
        SELECT COUNT(*) INTO V_CNT FROM DM_MST_ITEM_SINGLE_V WHERE ITEM_ID = V_AFTER(I) AND DIVISION_ID = '40';
        IF V_CNT = 0 THEN
            RAISE_INVALID(V_AFTER(I) || '은 존재하지 않는 코드입니다.');
        END IF;
    END LOOP;
    /* =========================
       BEFORE → AFTER 매핑 / 갱신 대상 BEFORE 목록 (같은 BEFORE 다중 AFTER = MAX 채택)
       ========================= */
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        IF NOT V_MAP.EXISTS(V_BEFORE(I)) THEN
            V_MAP(V_BEFORE(I)) := V_AFTER(I);
            V_BEF_LIST.EXTEND;
            V_BEF_LIST(V_BEF_LIST.COUNT) := V_BEFORE(I);
        ELSIF V_AFTER(I) > V_MAP(V_BEFORE(I)) THEN
            V_MAP(V_BEFORE(I)) := V_AFTER(I);
        END IF;
    END LOOP;
    /* =========================
       이력 DATA_SEQ — (BEFORE, AFTER) 별 기존 MAX + 1 (갱신 전 산정, 전 테이블 공통)
       ========================= */
    FOR I IN 1 .. V_BEFORE.COUNT LOOP
        SELECT NVL(MAX(DATA_SEQ), 0) + 1
          INTO V_CNT
          FROM DM_DNM_ITEM_CODE_CHANGE_HISTORY
         WHERE BEFORE_CODE = V_BEFORE(I)
           AND AFTER_CODE  = V_AFTER(I);
        V_SEQ(V_BEFORE(I) || CHR(1) || V_AFTER(I)) := V_CNT;
    END LOOP;
    /* =========================
       TABLE UPDATE — AS-IS 38 테이블 (순서 동일)
       ========================= */
    CHANGE_TABLE('DM_ANL_KPI_RTF_DEMAND',            TRUE);
    CHANGE_TABLE('DM_ANL_KPI_RTF_SALES',             TRUE);
    CHANGE_TABLE('DM_ANL_KPI_SALES_ACCURACY',        TRUE);
    CHANGE_TABLE('DM_ANL_KPI_SUMMARY',               TRUE);
    CHANGE_TABLE('DM_DNM_EDI_CALLOFF_ITEM',          TRUE);
    CHANGE_TABLE('DM_DNM_SALES_RESULT_IF',           TRUE);
    CHANGE_TABLE('DM_HI_CUST_FCST_INPUT',            TRUE);
    CHANGE_TABLE('DM_HI_MKT_FCST_CHANGE',            TRUE);
    CHANGE_TABLE('DM_HI_SALES_INPUT',                TRUE);
    CHANGE_TABLE('DM_HI_SITE_ITEM_MAPPING',          TRUE);
    CHANGE_TABLE('DM_HI_SITE_ITEM_MAPPING_ROWDATA',  TRUE);
    CHANGE_TABLE('DM_MST_BUCKET_CONVERSION',         TRUE);
    CHANGE_TABLE('DM_MST_BUCKET_CONVERSION_H',       TRUE);
    CHANGE_TABLE('DM_MST_CAPACITY_ALLOCATION',       TRUE);
    CHANGE_TABLE('DM_MST_CAPACITY_ALLOCATION_H',     TRUE);
    CHANGE_TABLE('DM_MST_CUSTOMER_MODEL',            TRUE);
    CHANGE_TABLE('DM_MST_CUSTOMER_MODEL_H',          TRUE);
    CHANGE_TABLE('DM_MST_EDI_CUST_MATERIAL_INFO',    FALSE);   -- AS-IS: DIVISION_ID 필터 없음 (원문 유지)
    CHANGE_TABLE('DM_PLN_BP_FCST',                   TRUE);
    CHANGE_TABLE('DM_PLN_BP_FCST_H',                 TRUE);
    CHANGE_TABLE('DM_PLN_CUSTOMER_PSI',              TRUE);
    CHANGE_TABLE('DM_PLN_CUSTOMER_PSI_H',            TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST',                  TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_CONFIRM',          TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_H',                TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_PK_DATA_UPDATE_H', TRUE);
    CHANGE_TABLE('DM_PLN_MKT_FCST_RESULT',           TRUE);
    CHANGE_TABLE('DM_PLN_PR_DETAIL',                 TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN',                TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN_H',              TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN_REPORT_H',       TRUE);
    CHANGE_TABLE('DM_PLN_SALES_PLAN_RESULT',         TRUE);
    CHANGE_TABLE('SCM_MST_FUTURE_PRICE',             TRUE);
    CHANGE_TABLE('SCM_MST_FUTURE_PRICE_H',           TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM',                TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM_H',              TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM_PRIORITY',       TRUE);
    CHANGE_TABLE('SCM_MST_SITE_ITEM_PRIORITY_H',     TRUE);
    COMMIT;
    SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'END', V_TOT_ROWS, '########## END of procedure ##########', NULL, SYSDATE);
    V_CNT := V_BEFORE.COUNT;   -- 컬렉션 속성은 SQL 안에서 직접 참조 불가 (ORA-00904)
    OPEN O_RESULT_CURSOR FOR
        SELECT '0' AS CODE, 'SUCCESS' AS MSG, TO_CHAR(V_CNT) AS EVENT FROM DUAL;
EXCEPTION
    WHEN EX_BIZ_EX THEN
        ROLLBACK;
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'INVALID', 0, '########## END of procedure ##########', SUBSTR(V_ERR_MSG, 1, 500), SYSDATE);
        OPEN O_RESULT_CURSOR FOR
            SELECT '-1' AS CODE, V_ERR_MSG AS MSG, '0' AS EVENT FROM DUAL;
    WHEN OTHERS THEN
        ROLLBACK;
        SCM_MGR.PR_SCM_SYS_LOG_BATCH($$PLSQL_UNIT, 'ERROR', 0, SUBSTR(SQLERRM, 1, 1000)
                                   , SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500), SYSDATE);
        RAISE_APPLICATION_ERROR(
            -20001,
            '[' || $$PLSQL_UNIT || '] SQLCODE=' || TO_CHAR(SQLCODE) ||
            ' / SQLERRM=' || SQLERRM ||
            ' / BACKTRACE=' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE ||
            ' / PARAMS=' || '-'
        );
END P_DMF0005_SAVE_MODEL_CHANGE_POPUP;
END PKG_DMF0005;
/
