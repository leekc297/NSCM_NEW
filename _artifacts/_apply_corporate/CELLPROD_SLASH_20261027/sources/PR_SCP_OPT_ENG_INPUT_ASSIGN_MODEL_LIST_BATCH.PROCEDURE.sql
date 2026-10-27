PROCEDURE         PR_SCP_OPT_ENG_INPUT_ASSIGN_MODEL_LIST_BATCH
(
    P_PLAN_ID               IN VARCHAR2
  , P_DIVISION_ID           IN VARCHAR2
  , P_GROUP_ID              IN VARCHAR2
  , P_PLAN_START_YYYYMMDD   IN VARCHAR2
  , P_PLAN_END_YYYYMMDD     IN VARCHAR2
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_INPUT_ASSIGN_MODEL_LIST_BATCH
 * Description  : 엔진 입력용 모델 리스트(SCP_OPT_ENG_MODEL_LIST_N)를 생성한다.
 *                스테이지별(ASSY / ASY_AGING / CHAR / BIZ / SUBMDLE)로 모델을 추출한 뒤
 *                중복을 제외(UNION)하여 결과 테이블에 적재한다.
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.05.28     Philsu Park  Initial Release
 * 2025.05.30     Philsu Park  OPT ENG LOOKUP 반영
 * 2025.06.13     Philsu Park  FINAL ITEM 에 미등록된 모델 제외(INNER JOIN 으로 변경)
 * 2025.06.19     Philsu Park  SUBMDLE 불필요 자재 제외 처리(LEAF_LEVEL 조건 추가)
 * 2025.07.07     Philsu Park  Initial Release
 * 2026.10.07     JCH          MSSQL -> Oracle 전환
 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_INPUT_ASSIGN_MODEL_LIST_BATCH';
    V_PLAN_ID               VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT          VARCHAR2(1000 CHAR);
    V_DETAIL_DATE           DATE;

    /* 업무 처리용 변수 */
    V_PLAN_START_YYYYMM     VARCHAR2(6 CHAR)   := SUBSTR(P_PLAN_START_YYYYMMDD, 1, 6);
    V_PLAN_END_YYYYMM       VARCHAR2(6 CHAR)   := SUBSTR(P_PLAN_END_YYYYMMDD, 1, 6);
    V_MAX_TUESDAY           VARCHAR2(8 CHAR);
    D_PLAN_NAME             DATE;
    V_DEMAND_CUTOFF_DAY     VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION        VARCHAR2(50 CHAR); 
BEGIN

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 : 시작 로그 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    /* 최신 수요 버전을 찾기 위한 기준값 설정 */
    SELECT  MAX(BASIS_YYYYMMDD)
      INTO  V_MAX_TUESDAY
      FROM  SCM_SYS_CALENDAR_M
     WHERE  BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
       AND  DAYOFWEEK        = 'TUE';

    D_PLAN_NAME := TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD');

    SELECT  NVL(MAX(P.CUTOFF_YYYYMMDD), V_MAX_TUESDAY)
      INTO  V_DEMAND_CUTOFF_DAY
      FROM  DM_PLN_NET_DEMAND P
     WHERE  P.DIVISION_ID      = P_DIVISION_ID
       AND  P.CUTOFF_YYYYMMDD >= TO_CHAR(D_PLAN_NAME - 3, 'YYYYMMDD')   /* 월요일 기준 최근 3일 이내 */
       AND  P.CUTOFF_YYYYMMDD <= TO_CHAR(D_PLAN_NAME + 6, 'YYYYMMDD');  /* 해당 주차 일요일 이전 */

    SELECT  MAX(P.VERSION_NO)
      INTO  V_DM_MAX_VERSION
      FROM  DM_PLN_NET_DEMAND P
     WHERE  P.DIVISION_ID     = P_DIVISION_ID
       AND  P.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY;

    /* 처리 본문 : 오류가 나면 되돌린 뒤 로그를 남기고 종료한다(원본 MSSQL 과 동일하게 상위로 전파하지 않는다) */
    BEGIN

        /* 임시 테이블(GTT) 재사용 전 초기화 — TRUNCATE 금지(암묵 커밋으로 롤백 깨짐) */
        DELETE FROM GT_IAML_ASSY; 
        DELETE FROM GT_IAML_ASY_AGING;
        DELETE FROM GT_IAML_CHAR;
        DELETE FROM GT_IAML_BIZ;
        DELETE FROM GT_IAML_SUBMDLE;

        /* 1. STAGE : ASSY / ASY_AGING 동일 기준으로 생성
              2025.06.13 Philsu Park : FINAL ITEM 에 미등록된 모델은 제외(INNER JOIN 으로 변경) */
        INSERT INTO GT_IAML_ASSY
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , ITEM_STAGE
          , DIVISION_ID
          , PLANT_ID
        )
        SELECT    V_PLAN_ID         AS PLAN_ID
                , ST.SCM_SITE_ID    AS SCM_SITE_ID
                , ILA.ITEM_ID       AS ITEM_ID
                , CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                        ELSE '-'
                   END              AS ITEM_STAGE
                , ILA.DIVISION_ID   AS DIVISION_ID
                , ILA.PLANT_ID      AS PLANT_ID
          FROM  SCM_MST_ITEM_LINE_ASSIGN_SN ILA
                INNER JOIN (
                            SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                              FROM SCP_MST_FINAL_ITEM
                             WHERE 1 = 1
                               AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))        /* 소형은 Cell Biz 용 Demand 만 처리 */
                                OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P')))
                           ) FNL
                   ON  ILA.DIVISION_ID = FNL.DIVISION_ID
                  AND  ILA.ITEM_ID     = FNL.ITEM_ID
                INNER JOIN SCM_ITEM_M_SN SIM
                   ON  1 = 1
                  AND  ILA.COMPANY_ID  = SIM.COMPANY_ID
                  AND  ILA.DIVISION_ID = SIM.DIVISION_ID
                  AND  ILA.SITE_ID     = SIM.SITE_ID
                  AND  ILA.ITEM_ID     = SIM.ITEM_ID
                  AND  SIM.ACTIVE_FLAG = 'Y'
                LEFT OUTER JOIN SCM_MST_SITE ST
                   ON  ILA.DIVISION_ID     = ST.DIVISION_ID
                  AND  ILA.PLANT_ID        = ST.PLANT_ID
                  AND  FNL.OPERATION_GROUP = ST.OPERATION_GROUP
                  AND  ST.VALID_YN         = 'Y'
         WHERE  1 = 1
           AND  ILA.DIVISION_ID = P_DIVISION_ID
           AND  ILA.MONTH BETWEEN V_PLAN_START_YYYYMM AND V_PLAN_END_YYYYMM
           AND  ILA.ACTIVE_FLAG = 'Y'
           AND  ILA.PRIORITY   <> '9'                       /* 신재욱 책임님 요청. 9순위 제외 */
         GROUP BY  ST.SCM_SITE_ID
                 , ILA.ITEM_ID
                 , CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P9500'    THEN 'PACK'
                         WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID     = 'P5500'    THEN 'MDLE'
                         WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID   NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                         WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  = 'CP'       THEN 'CHAR'
                         WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8 <> 'CP'       THEN 'ASSY'
                         ELSE '-'
                    END
                 , ILA.DIVISION_ID
                 , ILA.PLANT_ID;

        /* 2. STAGE : ASY_AGING — ASSY 를 모델 변경 없이 동일하게 생성 */
        INSERT INTO GT_IAML_ASY_AGING
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , ITEM_STAGE
          , DIVISION_ID
          , PLANT_ID
        )
        SELECT  V_PLAN_ID       AS PLAN_ID
              , SCM_SITE_ID     AS SCM_SITE_ID
              , ITEM_ID         AS ITEM_ID
              , 'ASY_AGING'     AS ITEM_STAGE
              , DIVISION_ID     AS DIVISION_ID
              , PLANT_ID        AS PLANT_ID
          FROM  GT_IAML_ASSY
         WHERE  ITEM_STAGE = 'ASSY';

        /* 3. STAGE : CHAR — ASY_AGING 기준으로 PROD 모델 Mapping 정보를 찾아온다 */
        INSERT INTO GT_IAML_CHAR
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , ITEM_STAGE
          , DIVISION_ID
          , PLANT_ID
        )
        SELECT    V_PLAN_ID             AS PLAN_ID
                , ST.SCM_SITE_ID        AS SCM_SITE_ID
                , PRD.ITEM_ID_PROD      AS ITEM_ID
                , CASE  WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID      = 'P9500'               THEN 'PACK'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID      = 'P5500'               THEN 'MDLE'
                        WHEN FNL.OPERATION_GROUP = 'P' AND FNL.FLOW_ID    NOT IN ('P5500', 'P9500') THEN 'SUBMDLE'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8   = 'CP'                  THEN 'CHAR'
                        WHEN FNL.OPERATION_GROUP = 'A' AND FNL.ATTRIBUTE8  <> 'CP'                  THEN 'ASSY'
                        ELSE '-'
                   END                  AS ITEM_STAGE
                , PRD.DIVISION_ID       AS DIVISION_ID
                , PRD.PLANT_ID          AS PLANT_ID
          FROM  SCP_MST_CELL_PROD_ASSY_MAP PRD
                LEFT OUTER JOIN (
                                 SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                   FROM SCP_MST_FINAL_ITEM
                                  WHERE 1 = 1
                                    AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))        /* 소형은 Cell Biz 용 Demand 만 처리 */
                                     OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P')))
                                ) FNL
                   ON  PRD.DIVISION_ID  = FNL.DIVISION_ID
                  AND  PRD.ITEM_ID_PROD = FNL.ITEM_ID
                LEFT OUTER JOIN SCM_MST_SITE ST
                   ON  PRD.DIVISION_ID     = ST.DIVISION_ID
                  AND  PRD.PLANT_ID        = ST.PLANT_ID
                  AND  FNL.OPERATION_GROUP = ST.OPERATION_GROUP
                  AND  ST.VALID_YN         = 'Y'
         WHERE  EXISTS ( SELECT 1
                           FROM GT_IAML_ASY_AGING AG
                          WHERE AG.DIVISION_ID = PRD.DIVISION_ID
                            AND AG.PLANT_ID    = PRD.PLANT_ID
                            AND AG.ITEM_ID     = PRD.ITEM_ID_ASSY )
           AND  PRD.CELL_TYPE = 'CA1'
           AND  PRD.VALID_YN  = 'Y';

        /* 3. STAGE : BIZ — CHAR 기준으로 NET Demand 에서 각 Site 별 모델 정보를 추출한다 */
        INSERT INTO GT_IAML_BIZ
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , ITEM_STAGE
        )
        SELECT  DISTINCT
                DM.PLAN_ID
              , DM.SCM_SITE_ID
              , DM.ITEM_ID
              , DM.ITEM_STAGE
          FROM  (
                SELECT    V_PLAN_ID                 AS PLAN_ID
                        , A.DIVISION_ID             AS DIVISION_ID
                        , A.SCM_SITE_ID             AS SCM_SITE_ID
                        , A.ITEM_ID                 AS ITEM_ID
                        , CASE  WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'              THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'              THEN 'MDLEBIZ'
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                                WHEN B.OPERATION_GROUP = 'A'                                      THEN 'CELLBIZ'
                                ELSE '-'
                          END                       AS ITEM_STAGE
                        , A.ATTRIBUTE1              AS DUE_DATE
                  FROM  DM_PLN_NET_DEMAND A
                        INNER JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                       FROM GT_IAML_CHAR
                                     UNION
                                     SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
                                       FROM GT_IAML_ASSY
                                      WHERE ITEM_STAGE IN ('MDLE', 'PACK')
                                   ) CM
                           ON  A.DIVISION_ID       = CM.DIVISION_ID
                          AND  A.ITEM_ID           = CM.ITEM_ID
                          AND  A.CELL_PROD_SITE_ID = CASE WHEN P_DIVISION_ID = '40' THEN CM.SCM_SITE_ID ELSE A.CELL_PROD_SITE_ID END
                        INNER JOIN ( SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                       FROM SCP_MST_FINAL_ITEM
                                      WHERE ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))        /* 소형은 Cell Biz 용 Demand 만 처리 */
                                         OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P')))
                                   ) B
                           ON  A.DIVISION_ID = B.DIVISION_ID
                          AND  A.ITEM_ID     = B.ITEM_ID
                        LEFT OUTER JOIN ( /* TOSITE PRIORITY CONSTRAINT */
                                          SELECT  P.ITEM_ID                      AS ITEM_ID
                                                , P.SCM_SITE_ID                  AS TO_SITE
                                                , TO_CHAR(P.PRIO_RANK)           AS PRIORITY
                                                , P.FROM_YYYYMMDD                AS FROM_DATE
                                                , P.TO_YYYYMMDD                  AS TO_DATE
                                            FROM  SCP_OPMZ_SALES_SITE_PRIORITY P
                                                  LEFT JOIN SCP_OPMZ_PLAN_GR_M PG
                                                     ON  P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                    AND  PG.VALID_YN       = 'Y'
                                           WHERE  1 = 1
                                             AND  P.VALID_YN    = 'Y'
                                             AND  P.DIVISION_ID = P_DIVISION_ID
                                             AND  NVL(P.OPMZ_PLAN_GR_ID, '~') =
                                                  ( SELECT NVL(MIN(P2.OPMZ_PLAN_GR_ID)
                                                                 KEEP (DENSE_RANK FIRST ORDER BY P2.PRIO_RANK, P2.OPMZ_PLAN_GR_ID), '~')
                                                      FROM SCP_OPMZ_SALES_SITE_PRIORITY P2
                                                     WHERE P2.VALID_YN    = 'Y'
                                                       AND P2.DIVISION_ID = P.DIVISION_ID
                                                       AND P2.ITEM_ID     = P.ITEM_ID
                                                       AND P2.SCM_SITE_ID = P.SCM_SITE_ID )
                                          /* _BATCH T7 : 계획그룹 필터 제거 시 업무키당 복수행 → 결과행 복제(PK 위반). 최우선순위(PRIO_RANK) 1건 채택 */
                                        ) TP
                           ON  A.SCM_SITE_ID = TP.TO_SITE
                          AND  A.ITEM_ID     = TP.ITEM_ID
                          AND  A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
                 WHERE  A.DIVISION_ID     = P_DIVISION_ID
                   AND  A.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                   AND  A.VERSION_NO      = V_DM_MAX_VERSION
                   AND  A.ATTRIBUTE1     >= P_PLAN_START_YYYYMMDD
                   AND  A.ATTRIBUTE1     <  P_PLAN_END_YYYYMMDD
                   AND  A.QTY            >  0
                ) DM;

        /* 4. STAGE : SUBMDLE — PACK / MDLE 하위의 SUBMDLE 모델 추출
              4-1. 대치(ALTER BOM) 기준 SUBMDLE Model */
        INSERT INTO GT_IAML_SUBMDLE
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , ITEM_STAGE
          , DIVISION_ID
          , PLANT_ID
        )
        SELECT  DISTINCT
                P_PLAN_ID         AS PLAN_ID
              , M.SCM_SITE_ID     AS SCM_SITE_ID
              , A.CHILD_ITEM_ID   AS ITEM_ID
              , 'SUBMDLE'         AS ITEM_STAGE
              , A.DIVISION_ID     AS DIVISION_ID
              , A.PLANT_ID        AS PLANT_ID
          FROM  SCM_MST_ALTER_BOM_V A
                INNER JOIN ( SELECT *
                               FROM GT_IAML_ASSY
                              WHERE ITEM_STAGE IN ('MDLE', 'PACK')
                           ) M
                   ON  A.DIVISION_ID    = M.DIVISION_ID
                  AND  A.PLANT_ID       = M.PLANT_ID
                  AND  A.PARENT_ITEM_ID = M.ITEM_ID
                  AND  A.SCP_PLAN_YN    = 'Y';

        /* 4-2. 대치가 없는 경우도 찾아야 하므로 BOM 기준으로 한 번 더 INSERT
              2025.06.19 Philsu Park : SUBMDLE 불필요 자재 제외 처리(LEAF_LEVEL 조건 추가) */
        INSERT INTO GT_IAML_SUBMDLE
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , ITEM_STAGE
          , DIVISION_ID
          , PLANT_ID
        )
        SELECT  /*+ LEADING(M A) USE_HASH(A) FULL(A) */
                DISTINCT
                P_PLAN_ID         AS PLAN_ID
              , M.SCM_SITE_ID     AS SCM_SITE_ID
              , A.CHILD_ITEM_ID   AS ITEM_ID
              , 'SUBMDLE'         AS ITEM_STAGE
              , A.DIVISION_ID     AS DIVISION_ID
              , A.PLANT_ID        AS PLANT_ID
          FROM  SCM_MST_BOM_SN_V A
                INNER JOIN ( SELECT *
                               FROM GT_IAML_ASSY
                              WHERE ITEM_STAGE IN ('MDLE', 'PACK')
                           ) M
                   ON  A.DIVISION_ID    = M.DIVISION_ID
                  AND  A.PLANT_ID       = M.PLANT_ID
                  AND  A.PARENT_ITEM_ID = M.ITEM_ID
                  AND  A.LEAF_LEVEL    IS NULL
                  AND  NOT EXISTS ( SELECT 'X'
                                      FROM GT_IAML_SUBMDLE LI
                                     WHERE A.DIVISION_ID    = LI.DIVISION_ID
                                       AND A.PLANT_ID       = LI.PLANT_ID
                                       AND A.PARENT_ITEM_ID = LI.ITEM_ID );

        /* 5. 최종 Model List 적재 : 중복 제외를 위해 UNION 적용 */
        INSERT INTO SCP_OPT_ENG_MODEL_LIST_N_SN
        (
            PLAN_ID
          , SCM_SITE_ID
          , ITEM_ID
          , STAGE
        )
        /* Line Assign Model */
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM  GT_IAML_ASSY
        /* ASY_AGING */
        UNION
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM  GT_IAML_ASY_AGING
        /* PACK / MDLE 기준 CHAR Model */
        UNION
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM  GT_IAML_CHAR
        /* BIZ Model */
        UNION
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM  GT_IAML_BIZ
        /* SubModule Model */
        UNION
        SELECT  PLAN_ID, SCM_SITE_ID, ITEM_ID, ITEM_STAGE
          FROM  GT_IAML_SUBMDLE;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR(SQLERRM, 1, 1000);
            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;   /* 실패 스텝의 미완성 데이터 제거 */
            END IF;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,SYSDATE,NULL,V_MESSAGE_TEXT,'ERROR');
            COMMIT;         /* 로그 보존 — 아래 참고 */
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* 종료 로그 : 오류 없이 끝난 경우에만 기록 */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
    END IF;

    COMMIT;

END;