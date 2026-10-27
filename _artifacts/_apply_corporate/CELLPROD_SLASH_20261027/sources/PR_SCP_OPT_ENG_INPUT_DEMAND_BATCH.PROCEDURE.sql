PROCEDURE         PR_SCP_OPT_ENG_INPUT_DEMAND_BATCH 
(
    P_PLAN_ID               IN VARCHAR2
  , V_DIVISION_ID           IN VARCHAR2
  , V_GROUP_ID              IN VARCHAR2
  , V_PLAN_START_YYYYMMDD   IN VARCHAR2
  , V_PLAN_END_YYYYMMDD     IN VARCHAR2
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_INPUT_DEMAND_BATCH
 * Description  : SCP 최적화 엔진 입력용 수요(Demand) 데이터를 생성한다.
 *                - DM Net Demand / 출하계획 Semi 를 기준으로 Demand 를 적재한다.
 *                - 묶음 유형(A/B/C/D) 별로 수요를 재집계하여 엔진 입력 수요를 만든다.
 *                - Demand Group 마스터 기준으로 그룹 수요를 추가하고 Target Date 를 보정한다.
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.02.07     Taehyun     Initial Release
 * 2026.10.07     JCH         MSSQL -> Oracle 전환
 */
    V_PROGRAM_NAME          VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_INPUT_DEMAND_BATCH';
    V_PLAN_ID               VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_MESSAGE_TEXT          VARCHAR2(1000 CHAR);
    MAX_TUESDAY             VARCHAR2(8 CHAR);
    V_DETAIL_DATE           DATE;
    P_PLAN_NAME             VARCHAR2(8 CHAR);
    D_PLAN_NAME             DATE;
    V_DEMAND_CUTOFF_DAY     VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION        VARCHAR2(200 CHAR);

    V_START_WEEK            NUMBER;
    V_PLAN_TYPE             VARCHAR2(20 CHAR);
    V_SHIP_FROZEN           NUMBER;
    V_SHIP_FROZEN_DAY       VARCHAR2(8 CHAR);

    V_PROD_FROZEN_END_YMD   VARCHAR2(8 CHAR);

    V_SCP_PLAN_DATE         VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE         VARCHAR2(8 CHAR);
    V_SCP_PLAN_SEQ          VARCHAR2(8 CHAR);
    V_CNT                   NUMBER;

    V_PLAN_END_YYYYMMDD_ORI VARCHAR2(20 CHAR);

    V_SHIPMENT_SNAP_CNT     NUMBER;
    
    V_POS1                  NUMBER := INSTR(V_PLAN_ID, '-', 1, 1);
    V_POS2                  NUMBER := INSTR(V_PLAN_ID, '-', 1, 2);
    V_POS3                  NUMBER := INSTR(V_PLAN_ID, '-', 1, 3);
BEGIN

    V_PLAN_END_YYYYMMDD_ORI := TO_CHAR(TO_DATE(V_PLAN_END_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');

    /* 이전 작업 잔여 정리 (GTT 는 TRUNCATE 대신 DELETE 로 비운다) */
    DELETE FROM GT_IDB_DM_TEMP;
    DELETE FROM GT_IDB_CELL_PROD_SITE;
    DELETE FROM GT_IDB_DM_INS_TEMP;
    DELETE FROM GT_IDB_DEMAND_GROUP_T;
    DELETE FROM GT_IDB_DEMAND_TYPE_A;
    DELETE FROM GT_IDB_DEMAND_TYPE_C;
    DELETE FROM GT_IDB_DEMAND_TYPE_D;

    ------------------------------------------------------------------------
    -- Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성
    ------------------------------------------------------------------------
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    ------------------------------------------------------------------------
    -- Transaction (START)
    ------------------------------------------------------------------------
    BEGIN
        ------------------------------------------------------------------------
        -- Get Plan Mater Info
        ------------------------------------------------------------------------
         V_SCP_PLAN_DATE      := SUBSTR(V_PLAN_ID, V_POS1 + 1, V_POS2 - V_POS1 - 1);
         V_SCP_PLAN_TYPE      := SUBSTR(V_PLAN_ID, V_POS2 + 1, V_POS3 - V_POS2 - 1);
         V_SCP_PLAN_SEQ       := SUBSTR(V_PLAN_ID, V_POS3 + 1);

        SELECT  MAX(TO_NUMBER(ISO_WEEK))
          INTO  V_START_WEEK
          FROM  SCM_SYS_CALENDAR_M
         WHERE  BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD;

        SELECT  MAX(SEGMENT4)
          INTO  V_SHIP_FROZEN
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
         WHERE  LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
           AND  VALID_YN    = 'Y'
           AND  SEGMENT1    = V_DIVISION_ID
           AND  SEGMENT2    = V_GROUP_ID
        --AND     SEGMENT3    = 'PR' --임시
           AND  SEGMENT3    = V_SCP_PLAN_TYPE;

        V_SHIP_FROZEN_DAY := TO_CHAR(TO_DATE(V_SCP_PLAN_DATE, 'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0), 'YYYYMMDD');

        SELECT  MAX(FROZEN_END_DATE)
          INTO  V_PROD_FROZEN_END_YMD
          FROM  SCP_OPT_ENG_FROZEN_MASTER_SN M
         WHERE  M.PLAN_ID = V_PLAN_ID
           AND  M.STAGE   = 'ASSY';

        ------------------------------------------------------------------------
        -- Set Param for Demand
        ------------------------------------------------------------------------
        SELECT  MAX(BASIS_YYYYMMDD)
          INTO  MAX_TUESDAY
          FROM  SCM_SYS_CALENDAR_M
         WHERE  BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND  DAYOFWEEK = 'TUE';

        P_PLAN_NAME := V_PLAN_START_YYYYMMDD; -- 당주 월요일 YYYYMMDD
        D_PLAN_NAME := TO_DATE(P_PLAN_NAME, 'YYYYMMDD');

        SELECT  NVL(MAX(P.CUTOFF_YYYYMMDD), MAX_TUESDAY)
          INTO  V_DEMAND_CUTOFF_DAY
          FROM  DM_PLN_NET_DEMAND P
         WHERE  P.DIVISION_ID      = V_DIVISION_ID
           AND  P.CUTOFF_YYYYMMDD >= TO_CHAR(D_PLAN_NAME - 3, 'YYYYMMDD') -- 월요일 기준 최근 3일 이내
           AND  P.CUTOFF_YYYYMMDD <= TO_CHAR(D_PLAN_NAME + 6, 'YYYYMMDD'); -- 해당 주차 일요일 이전

        SELECT  MAX(P.VERSION_NO)
          INTO  V_DM_MAX_VERSION
          FROM  DM_PLN_NET_DEMAND P
         WHERE  P.DIVISION_ID     = V_DIVISION_ID
           AND  P.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY;

        
        /* SCP_OPMZ_PLAN_M(계획 마스터 정보)에 Demand Version Update*/
        UPDATE SCP_OPMZ_PLAN_M
           SET DMD_VER_ID   = V_DM_MAX_VERSION
         WHERE OPMZ_PLAN_ID = V_PLAN_ID
        ; 
        
        ------------------------------------------------------------------------
        -- 셀 생산지 버퍼 추가
        ------------------------------------------------------------------------
/*    INSERT INTO @CELL_PROD_SITE
    SELECT  SEGMENT3 AS SALES_SITE_ID
           ,SEGMENT4 AS ITEM_ID
    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
    WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
    AND     SEGMENT1 = @V_DIVISION_ID
    AND     SEGMENT2 = @V_GROUP_ID*/
        ------------------------------------------------------------------------
        -- 임시
        SELECT  COUNT(*)
          INTO  V_SHIPMENT_SNAP_CNT
          FROM  SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN S
         WHERE  S.DIVISION_ID         = V_DIVISION_ID
           AND  S.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD;

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------
        ------------------------------------------------------------------------
        -- 1. DM Demand Insert
        -- 2025.09.30 Philsu Park: 워크벤치 반영 재고와 동일 DEMAND_ID는 제외(@DM_INS_TEMP)
        ------------------------------------------------------------------------
        INSERT INTO GT_OPT_DIV_DM_DM_INS
            (PLAN_ID
            ,DEMAND_ID
            ,BUFFER_ID
            ,DEMAND_GROUP
            ,DUE_DATE
            ,TARGET_DATE
            ,SALES_CUTOFF_DATE
            ,EXPIRY_DATE
            ,PRIORITY
            ,QUANTITY
            ,PRIORITY_GROUP
            ,CUSTOMER_ID
            ,ALLOW_SHORT
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
            ,ATTRIBUTE9
            ,ATTRIBUTE10
            ,ATTRIBUTE11
            ,ATTRIBUTE12
            ,ATTRIBUTE13
            ,ATTRIBUTE14
            ,ATTRIBUTE15
            )
        SELECT   DM.PLAN_ID
                ,DM.DEMAND_ID
                ,DM.BUFFER_ID
                ,DM.DEMAND_GROUP
                ,DM.DUE_DATE
                ,DM.TARGET_DATE
                ,DM.SALES_CUTOFF_DATE
                ,DM.EXPIRY_DATE
                ,DM.PRIORITY
                ,DM.QUANTITY
                ,DM.PRIORITY_GROUP
                ,DM.CUSTOMER_ID
                ,DM.ALLOW_SHORT
                ,DM.ATTRIBUTE1
                ,DM.ATTRIBUTE2
                ,DM.ATTRIBUTE3
                ,DM.ATTRIBUTE4
                ,DM.ATTRIBUTE5
                ,DM.ATTRIBUTE6
                ,DM.ATTRIBUTE7
                ,DM.ATTRIBUTE8
                ,DM.ATTRIBUTE9
                ,DM.ATTRIBUTE10
                ,DM.ATTRIBUTE11
                ,DM.ATTRIBUTE12
                ,DM.ATTRIBUTE13
                ,DM.ATTRIBUTE14
                ,DM.ATTRIBUTE15
        FROM    (
                SELECT  V_PLAN_ID                                                                  AS PLAN_ID
                      , DEMAND.SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||DEMAND.STAGE||'@'||DEMAND.INCOTERMS||'@'||DEMAND.PROJECT_CODE||'::'||DEMAND.DUE_DATE||'::'||'-'||'::'||DEMAND.FCST_TYPE||CASE WHEN NVL(DEMAND.CELL_PROD_SITE_ID,'-') = '-' THEN '' ELSE '::'||DEMAND.CELL_PROD_SITE_ID END AS DEMAND_ID
                      , DEMAND.SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||DEMAND.STAGE||'@'||DEMAND.INCOTERMS||'@'||DEMAND.PROJECT_CODE                                                                                                                        AS BUFFER_ID
                      /*  PRIORITY 는 TOSITE PRIORITY 아우터조인 유래라 NULL 가능 -> MSSQL 결합의 NULL 전파를 CASE 로 재현 */
                      , CASE WHEN DEMAND.PRIORITY IS NULL THEN NULL ELSE DEMAND.INCOTERMS||'@'||'D'||DEMAND.PRIORITY END AS DEMAND_GROUP
                      , DEMAND.DUE_DATE                                                            AS DUE_DATE
                      , NULL                                                                       AS TARGET_DATE
                      , NULL                                                                       AS SALES_CUTOFF_DATE
                      , NULL                                                                       AS EXPIRY_DATE
                      , DEMAND.PRIORITY                                                            AS PRIORITY
                      , DEMAND.QUANTITY                                                            AS QUANTITY
                      , CASE WHEN DEMAND.PRIORITY IS NULL THEN NULL ELSE 'D'||DEMAND.PRIORITY END  AS PRIORITY_GROUP
                      , NULL                                                                       AS CUSTOMER_ID
                      , NULL                                                                       AS ALLOW_SHORT
                      , DEMAND.SCM_SITE_ID                                                         AS ATTRIBUTE1
                      , DEMAND.ITEM_ID                                                             AS ATTRIBUTE2
                      , DEMAND.STAGE                                                               AS ATTRIBUTE3
                      , DEMAND.INCOTERMS                                                           AS ATTRIBUTE4
                      , DEMAND.PROJECT_CODE                                                        AS ATTRIBUTE5
                      , NULL                                                                       AS ATTRIBUTE6
                      , NULL                                                                       AS ATTRIBUTE7
                      , DEMAND.FCST_TYPE                                                           AS ATTRIBUTE8
                      , DEMAND.DEMAND_TYPE                                                         AS ATTRIBUTE9
                      , NULL                                                                       AS ATTRIBUTE10
                      , NULL                                                                       AS ATTRIBUTE11
                      , NULL                                                                       AS ATTRIBUTE12
                      , NULL                                                                       AS ATTRIBUTE13
                      , NULL                                                                       AS ATTRIBUTE14
                      , NULL                                                                       AS ATTRIBUTE15
                FROM   (
                       SELECT  A.DIVISION_ID  AS DIVISION_ID
                             , A.SCM_SITE_ID  AS SCM_SITE_ID
                             , A.ITEM_ID      AS ITEM_ID
                             , CASE
                                   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                                   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                                   WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                                   WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ'
                               ELSE '-' END                                                               AS STAGE
                             , CASE WHEN NVL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END   AS INCOTERMS
                             , A.ATTRIBUTE1                                                                 AS DUE_DATE
                             , SUM(A.QTY)                                                                   AS QUANTITY
                             , TP.PRIORITY                                                                  AS PRIORITY
                             , A.FCST_TYPE                                                                  AS FCST_TYPE
                             , A.PROJECT_CODE                                                               AS PROJECT_CODE
                             , A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
                             , A.DEMAND_TYPE

                       FROM DM_PLN_NET_DEMAND A
                       /* ---------------------------------------------------------------------- */
                           INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                       FROM   SCP_MST_FINAL_ITEM
                                       WHERE  DIVISION_ID = V_DIVISION_ID
                                       AND    OPERATION_GROUP IN ('A', 'P') /*  ADDED 2026-03-10 */
                                    /* BLOCKED 2026-03-10 */
                                    /* AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리 */
                                    /*       OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') ) */
                                    /*          ) */
                                      ) B
                               ON    A.ITEM_ID     = B.ITEM_ID
                               AND   A.DIVISION_ID = B.DIVISION_ID
                       /* ---------------------------------------------------------------------- */
                           LEFT JOIN ( /*  VMI 대상 SITE 조회 */
                                       SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                       FROM   SCM_MST_SITE
                                       WHERE  DIVISION_ID = V_DIVISION_ID
                                           AND SITE_TYPE   = 'SALES'
                                           AND  VALID_YN    = 'Y'
                                           AND  VMI_YN      = 'Y'
                                       ) MSE
                               ON   A.DIVISION_ID      = MSE.DIVISION_ID
                               AND  A.SCM_SITE_ID      = MSE.SCM_SITE_ID
                       /* ---------------------------------------------------------------------- */
                           LEFT OUTER JOIN ( /* TOSITE PRIORITY CONSTRAINT */
                                           /* SELECT   SEGMENT4   AS ITEM_ID */
                                           /*         ,SEGMENT5   AS TO_SITE */
                                           /*         ,SEGMENT6   AS PRIORITY */
                                           /*         ,ATTRIBUTE1 AS FROM_DATE */
                                           /*         ,ATTRIBUTE2 AS TO_DATE */
                                           /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK) */
                                           /* WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW' */
                                           /* AND     SEGMENT2    = @V_DIVISION_ID */
                                           /* AND     SEGMENT3    = @V_GROUP_ID */
                                           /* AND     VALID_YN    = 'Y' */

                                            /*  2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                            SELECT  P.ITEM_ID       AS ITEM_ID
                                                  , P.SCM_SITE_ID   AS TO_SITE
                                                  , TO_CHAR(P.PRIO_RANK)     AS PRIORITY
                                                  , P.FROM_YYYYMMDD   AS FROM_DATE
                                                  , P.TO_YYYYMMDD     AS TO_DATE
                                            FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                                  , SCP_OPMZ_PLAN_GR_M PG
                                            WHERE   1=1
                                            AND     P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                            AND     PG.VALID_YN = 'Y'
                                            AND     P.VALID_YN = 'Y'
                                            AND     P.DIVISION_ID = V_DIVISION_ID
                                            AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                           ) TP
                               ON  A.SCM_SITE_ID = TP.TO_SITE
                               AND A.ITEM_ID     = TP.ITEM_ID
                               AND A.ATTRIBUTE1 BETWEEN TP.FROM_DATE AND TP.TO_DATE
                       WHERE   A.DIVISION_ID     =  V_DIVISION_ID
                       AND     A.CUTOFF_YYYYMMDD   =  V_DEMAND_CUTOFF_DAY
                       AND     A.VERSION_NO        =  V_DM_MAX_VERSION
                       AND     A.ATTRIBUTE1        >= P_PLAN_NAME
                       AND     A.ATTRIBUTE1        <  V_PLAN_END_YYYYMMDD
                       AND     A.QTY               >  0
                       /*  comment2: 소형 생산지 구분 로직 블럭에 따른 추가 */
                       AND     A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                              FROM   SCP_OPT_ENG_MODEL_LIST_N_SN
                                              WHERE  PLAN_ID = V_PLAN_ID
                                            )
                       /* 소형 생산지 구분을 위한 분리 */
                       /*  comment: 소형 생산지 사이트 구분 로직은 유지 */
                       /*  comment2: 소형 생산지 구분 로직으로 PACK, MDL Demand 누락됨 ---- CELL_PROD_SITE_ID 는 ASSY(%-A) 사이트만 존재 */
                       /*AND ((@V_DIVISION_ID = '40'
                                                      --상현 책임님 요청으로 SALES SITE는 MEDEL LIST를 고려하지 않도록 수정/20250526/김태현선임
                                                      --AND CONCAT(A.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT (SCM_SITE_ID,ITEM_ID)
                                                      --                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                      --                                        WHERE   PLAN_ID = @V_PLAN_ID
                                                      --                                       )
                                                      AND CONCAT(A.CELL_PROD_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                                    FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                                    WHERE   PLAN_ID = @V_PLAN_ID
                                                                                                    )
                            )
                            OR (@V_DIVISION_ID != '40' AND  A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                              FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                              WHERE   PLAN_ID = @V_PLAN_ID
                                                             )
                           )
                       ) */
                       /* ------------------------ */
                       GROUP BY A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
                              , B.FLOW_ID, B.OPERATION_GROUP, TP.PRIORITY, A.FCST_TYPE,A.PROJECT_CODE,A.CELL_PROD_SITE_ID
                       ) DEMAND
                    LEFT OUTER JOIN GT_OPT_DIV_DM_CELLPROD CPS
                        ON  1=1
                        AND DEMAND.SCM_SITE_ID = CPS.SALES_SITE_ID
                        AND DEMAND.ITEM_ID     = CPS.ITEM_ID
                    /* ---------------------------------------------------------------------- */
                    /*  DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리 */
                    /*  2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
                    /*  2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용을 위한 JOIN Depth 변경 */
                    /* ---------------------------------------------------------------------- */
                    LEFT JOIN   (
                                /* SELECT  SEGMENT2   AS DIVISION_ID */
                                /*       , SEGMENT3   AS SCM_SITE_ID */
                                /*       , SEGMENT4   AS ITEM_ID */
                                /*       , SEGMENT5   AS GROUP_ID */
                                /*       , ATTRIBUTE1 AS STAGE */
                                /*       , CASE */
                                /*             WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외 */
                                /*             ELSE ATTRIBUTE2 */
                                /*         END AS START_DATE  -- PLAN 제외 시작일자 */
                                /*       , CASE */
                                /*             WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외 */
                                /*             ELSE ATTRIBUTE3 */
                                /*         END AS END_DATE  -- PLAN 제외 끝일자 */
                                /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK) */
                                /* WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION' */
                                /* AND     VALID_YN    = 'Y' */
                                /* AND     SEGMENT2    = @V_DIVISION_ID */
                                /* AND     SEGMENT5    = @V_GROUP_ID */

                                /*  2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                                SELECT  D.DIVISION_ID           AS DIVISION_ID
                                      , D.SCM_SITE_ID           AS SCM_SITE_ID
                                      , D.ITEM_ID               AS ITEM_ID
                                      , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                      , D.STAGE                 AS STAGE
                                      , CASE
                                            WHEN RTRIM(D.FROM_YYYYMMDD) IS NULL THEN V_PLAN_END_YYYYMMDD
                                            ELSE D.FROM_YYYYMMDD
                                        END                     AS START_DATE
                                      , CASE
                                            WHEN RTRIM(D.TO_YYYYMMDD) IS NULL THEN V_PLAN_END_YYYYMMDD
                                            ELSE D.TO_YYYYMMDD
                                        END                     AS END_DATE
                                FROM    SCP_OPMZ_DEMAND_EXCEPTION D
                                      , SCP_OPMZ_PLAN_GR_M PG
                                WHERE   1=1
                                AND     D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                AND     PG.VALID_YN = 'Y'
                                AND     D.VALID_YN = 'Y'
                                AND     D.DIVISION_ID = V_DIVISION_ID
                                AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                ) DE
                        ON  DEMAND.SCM_SITE_ID   = DE.SCM_SITE_ID
                        AND DEMAND.ITEM_ID       = DE.ITEM_ID
                        AND ((DEMAND.DIVISION_ID = '40' AND DEMAND.STAGE = DE.STAGE) OR  /*  소형의 경우 JOIN 조건에 STAGE까지 고려 */
                             DEMAND.DIVISION_ID <> '40')
                /*  DEMAND 제외 대상 처리 */
                WHERE   1=1
                AND     (RTRIM(DE.ITEM_ID) IS NULL OR                                                                         /*  수요 제외 대상이 아니거나 */
                         (RTRIM(DE.ITEM_ID) IS NOT NULL AND (DEMAND.DUE_DATE < DE.START_DATE OR DEMAND.DUE_DATE > DE.END_DATE))) /*  수요 제외 대상이어도 기간 범위 밖인 것 */
                ) DM
              , GT_OPT_DIV_DM_DM_INS DT
        WHERE DM.PLAN_ID = DT.PLAN_ID(+)
        AND   DM.DEMAND_ID = DT.DEMAND_ID(+)
        AND   DT.PLAN_ID IS NULL;
        /* ---------------------------------------------------------------------- */
        /*  2. Shipment Plan Semi => Demand Insert : 소형 - Cell Plant 의 CHAR Stage에 Demand 처리 */
        /*  2025.05.07 Philsu Park: SHIPTMENT_SNAPSHOT_COUNT > 0 일 때는 해당 데이터 사용, 아닐때는 기존 로직으로 분기. */
        /* ---------------------------------------------------------------------- */
        IF V_DIVISION_ID = 'XX' THEN /*  '40' -- 2026-03-10, 소형 특화제거 --소형은 외주 Packer 이후부터는 계획을 수립하지 않으며 CHAR 출하계획(OR 출하계획스넵샷->엔진수행시 계획이 바뀌니 사용자가 수립한 계획을 화면에서 별도 스넵샷한 것) 기준 DEMAND 생성하는 부분으로 SHIP REQ용으로는 불필요 */
            IF V_SHIPMENT_SNAP_CNT > 0 THEN
                    INSERT INTO GT_OPT_DIV_DM_DM_INS
                        (PLAN_ID
                        ,DEMAND_ID 
                        ,BUFFER_ID
                        ,DEMAND_GROUP
                        ,DUE_DATE
                        ,TARGET_DATE
                        ,SALES_CUTOFF_DATE
                        ,EXPIRY_DATE
                        ,PRIORITY
                        ,QUANTITY
                        ,PRIORITY_GROUP
                        ,CUSTOMER_ID
                        ,ALLOW_SHORT
                        ,ATTRIBUTE1
                        ,ATTRIBUTE2
                        ,ATTRIBUTE3
                        ,ATTRIBUTE4
                        ,ATTRIBUTE5
                        ,ATTRIBUTE6
                        ,ATTRIBUTE7
                        ,ATTRIBUTE8
                        ,ATTRIBUTE9
                        ,ATTRIBUTE10
                        ,ATTRIBUTE11
                        ,ATTRIBUTE12
                        ,ATTRIBUTE13
                        ,ATTRIBUTE14
                        ,ATTRIBUTE15
                        )
                    SELECT   V_PLAN_ID
                            /*  TO_SITE / INCOTERMS / TRANSPORT_MODE 는 NULL 가능(원천 널 허용) -> MSSQL 결합의 NULL 전파를 CASE 로 재현 */
                            ,CASE WHEN DEMAND.TO_SITE IS NULL OR DEMAND.INCOTERMS IS NULL OR DEMAND.TRANSPORT_MODE IS NULL THEN NULL
                                  ELSE DEMAND.SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||DEMAND.STAGE||'::'||DEMAND.DUE_DATE||'::'||DEMAND.TO_SITE||'::'||DEMAND.INCOTERMS||'::'||DEMAND.TRANSPORT_MODE||'::'||'REQ'
                             END                                                             AS DEMAND_ID
                            ,DEMAND.SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||DEMAND.STAGE     AS BUFFER_ID
                            /* ,TO_SITE                                                            AS DEMAND_GROUP */
                            /*  Ship Frozen 내인 경우 'SF' */
                            ,CASE WHEN DEMAND.SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE CASE WHEN RTRIM(DEMAND.PRIORITY) IS NULL THEN NULL ELSE 'D'||DEMAND.PRIORITY END
                             END                                                                 AS DEMAND_GROUP
                            ,DEMAND.DUE_DATE                                                     AS DUE_DATE
                            ,NULL                                                                AS TARGET_DATE
                            ,NULL                                                                AS SALES_CUTOFF_DATE
                            ,NULL                                                                AS EXPIRY_DATE
                            ,DEMAND.PRIORITY                                                     AS PRIORITY
                            /*  Ship Frozen 내인 경우 '' */
                            /* ,CASE WHEN SHIP_FROZEN = 'Y' THEN '' */
                            /*       ELSE NULL */
                            /*  END                                                                AS PRIORITY */
                            ,DEMAND.QUANTITY                                                     AS QUANTITY
                            /* ,NULL                                                               AS PRIORITY_GROUP */
                            /*  Ship Frozen 내인 경우 'SF' */
                            ,CASE WHEN DEMAND.SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE CASE WHEN RTRIM(DEMAND.PRIORITY) IS NULL THEN NULL ELSE 'D'||DEMAND.PRIORITY END
                            END                                                                 AS PRIORITY_GROUP
                            ,NULL                                                               AS CUSTOMER_ID
                            ,NULL                                                               AS ALLOW_SHORT
                            ,DEMAND.SCM_SITE_ID                                                 AS ATTRIBUTE1
                            ,DEMAND.ITEM_ID                                                     AS ATTRIBUTE2
                            ,DEMAND.STAGE                                                       AS ATTRIBUTE3
                            ,DEMAND.INCOTERMS                                                   AS ATTRIBUTE4
                            ,NULL                                                               AS ATTRIBUTE5
                            ,DEMAND.TO_SITE                                                     AS ATTRIBUTE6
                            ,DEMAND.TRANSPORT_MODE                                              AS ATTRIBUTE7
                            ,NULL                                                               AS ATTRIBUTE8
                            ,NULL                                                               AS ATTRIBUTE9
                            ,NULL                                                               AS ATTRIBUTE10
                            ,NULL                                                               AS ATTRIBUTE11
                            ,NULL                                                               AS ATTRIBUTE12
                            ,NULL                                                               AS ATTRIBUTE13
                            ,NULL                                                               AS ATTRIBUTE14
                            ,'SNAPSHOT'                                                         AS ATTRIBUTE15  /* Snapshot 사용 마킹. */
                    FROM    (
                            SELECT  A.DIVISION_ID          AS DIVISION_ID
                                   ,A.FROM_SITE            AS SCM_SITE_ID
                                   ,A.TO_SITE              AS TO_SITE
                                   ,A.ITEM_ID              AS ITEM_ID
                                   ,'CHAR'                 AS STAGE
                                   /* ,'EXW'          AS INCOTERMS */
                                   ,BOD.INCOTERMS          AS INCOTERMS
                                   ,BOD.TRANSPORT_MODE     AS TRANSPORT_MODE
                                   ,A.YYYYMMDD             AS DUE_DATE
                                   ,CASE WHEN A.YYYYMMDD < V_SHIP_FROZEN_DAY THEN 'Y'
                                         ELSE 'N'
                                         END               AS SHIP_FROZEN
                                   ,SUM(A.QTY)             AS QUANTITY
                                   ,TP.PRIORITY            AS PRIORITY


                            FROM    SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN A
                                /* ---------------------------------------------------------------------- */
                                INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                                            FROM   SCM_MST_SITE
                                            WHERE  DIVISION_ID     = V_DIVISION_ID
                                            AND    SITE_TYPE       = 'PLANT'
                                            AND    OPERATION_GROUP = 'A' /*  소형은 Cell 출하를 CEll Biz 용 Demand 만 처리 */
                                            AND    VALID_YN        = 'Y'
                                        ) B
                                    ON    A.FROM_SITE   = B.SCM_SITE_ID
                                    AND   A.DIVISION_ID = B.DIVISION_ID
                                /* ---------------------------------------------------------------------- */
                                INNER JOIN SCP_MST_BOD_N_V BOD
                                    ON    A.DIVISION_ID = BOD.DIVISION_ID
                                    AND   A.BOD_ID      = BOD.BOD_ID
                                /* ---------------------------------------------------------------------- */
                                /*  2025.07.15 Philsu Park: 소형 Shipment SEMI 에도 Priority 값 반영. */
                                /* ---------------------------------------------------------------------- */
                                LEFT OUTER JOIN ( /* TOSITE PRIORITY CONSTRAINT */
                                                /* SELECT   SEGMENT4   AS ITEM_ID */
                                                /*         ,SEGMENT5   AS TO_SITE */
                                                /*         ,SEGMENT6   AS PRIORITY */
                                                /*         ,ATTRIBUTE1 AS FROM_DATE */
                                                /*         ,ATTRIBUTE2 AS TO_DATE */
                                                /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK) */
                                                /* WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW' */
                                                /* AND     SEGMENT2    = @V_DIVISION_ID */
                                                /* AND     SEGMENT3    = @V_GROUP_ID */
                                                /* AND     VALID_YN    = 'Y' */

                                                /*  2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                                SELECT  P.ITEM_ID       AS ITEM_ID
                                                      , P.SCM_SITE_ID   AS TO_SITE
                                                      , TO_CHAR(P.PRIO_RANK)     AS PRIORITY
                                                      , P.FROM_YYYYMMDD   AS FROM_DATE
                                                      , P.TO_YYYYMMDD     AS TO_DATE
                                                FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                                      , SCP_OPMZ_PLAN_GR_M PG
                                                WHERE   1=1
                                                AND     P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                AND     PG.VALID_YN = 'Y'
                                                AND     P.VALID_YN = 'Y'
                                                AND     P.DIVISION_ID = V_DIVISION_ID
                                                AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                                ) TP
                                    ON  A.FROM_SITE     = TP.TO_SITE
                                    AND A.ITEM_ID       = TP.ITEM_ID
                                    AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
                            /* ---------------------------------------------------------------------- */
                            WHERE   A.DIVISION_ID           = V_DIVISION_ID
                            AND     A.PLAN_START_YYYYMMDD   = V_SCP_PLAN_DATE
                            /*  AND   A.plan_type           = @V_SCP_PLAN_TYPE */
                            /*  AND   A.seq                 = @V_SCP_PLAN_SEQ */
                            AND     A.MEASURE               = 'SHIP_PLAN_AMEND'
                            AND     A.QTY                   > 0
                            AND     A.YYYYMMDD             >= P_PLAN_NAME
                            AND     A.YYYYMMDD              < V_PLAN_END_YYYYMMDD
                            AND     A.ITEM_ID              IN ( SELECT  DISTINCT ITEM_ID
                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                WHERE   PLAN_ID = V_PLAN_ID
                                                                )
                            GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE, TP.PRIORITY
                            ) DEMAND
                        /* ---------------------------------------------------------------------- */
                        /*  DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리 */
                        /*  2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
                        /*  2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용에 따른 JOIN Depth 변경 */
                        /* ---------------------------------------------------------------------- */
                        LEFT JOIN   (
                                    /* SELECT  SEGMENT2   AS DIVISION_ID */
                                    /*       , SEGMENT3   AS SCM_SITE_ID */
                                    /*       , SEGMENT4   AS ITEM_ID */
                                    /*       , SEGMENT5   AS GROUP_ID */
                                    /*       , ATTRIBUTE1 AS STAGE */
                                    /*       , CASE */
                                    /*             WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외 */
                                    /*             ELSE ATTRIBUTE2 */
                                    /*         END AS START_DATE  -- PLAN 제외 시작일자 */
                                    /*       , CASE */
                                    /*             WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외 */
                                    /*             ELSE ATTRIBUTE3 */
                                    /*         END AS END_DATE  -- PLAN 제외 끝일자 */
                                    /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK) */
                                    /* WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION' */
                                    /* AND     VALID_YN    = 'Y' */
                                    /* AND     SEGMENT2    = @V_DIVISION_ID */
                                    /* AND     SEGMENT5    = @V_GROUP_ID */

                                    /*  2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                                    SELECT  D.DIVISION_ID           AS DIVISION_ID
                                          , D.SCM_SITE_ID           AS SCM_SITE_ID
                                          , D.ITEM_ID               AS ITEM_ID
                                          , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                          , D.STAGE                 AS STAGE
                                          , CASE
                                                WHEN RTRIM(D.FROM_YYYYMMDD) IS NULL THEN V_PLAN_END_YYYYMMDD
                                                ELSE D.FROM_YYYYMMDD
                                            END                     AS START_DATE
                                          , CASE
                                                WHEN RTRIM(D.TO_YYYYMMDD) IS NULL THEN V_PLAN_END_YYYYMMDD
                                                ELSE D.TO_YYYYMMDD
                                            END                     AS END_DATE
                                    FROM    SCP_OPMZ_DEMAND_EXCEPTION D
                                          , SCP_OPMZ_PLAN_GR_M PG
                                    WHERE   1=1
                                    AND     D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                    AND     PG.VALID_YN = 'Y'
                                    AND     D.VALID_YN = 'Y'
                                    AND     D.DIVISION_ID = V_DIVISION_ID
                                    AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                    ) DE
                            ON  DEMAND.SCM_SITE_ID   = DE.SCM_SITE_ID
                            AND DEMAND.ITEM_ID       = DE.ITEM_ID
                            AND ((DEMAND.DIVISION_ID = '40' AND DEMAND.STAGE = DE.STAGE) OR  /*  소형의 경우 JOIN 조건에 STAGE까지 고려 */
                                 DEMAND.DIVISION_ID <> '40')
                    /*  DEMAND 제외 대상 처리 */
                    WHERE   1=1
                    AND     (RTRIM(DE.ITEM_ID) IS NULL OR                                                                         /*  수요 제외 대상이 아니거나 */
                             (RTRIM(DE.ITEM_ID) IS NOT NULL AND (DEMAND.DUE_DATE < DE.START_DATE OR DEMAND.DUE_DATE > DE.END_DATE))); /*  수요 제외 대상이어도 기간 범위 밖인 것 */
            ELSE

                    INSERT INTO GT_OPT_DIV_DM_DM_INS
                        (PLAN_ID
                        ,DEMAND_ID
                        ,BUFFER_ID
                        ,DEMAND_GROUP
                        ,DUE_DATE
                        ,TARGET_DATE
                        ,SALES_CUTOFF_DATE
                        ,EXPIRY_DATE
                        ,PRIORITY
                        ,QUANTITY
                        ,PRIORITY_GROUP
                        ,CUSTOMER_ID
                        ,ALLOW_SHORT
                        ,ATTRIBUTE1
                        ,ATTRIBUTE2
                        ,ATTRIBUTE3
                        ,ATTRIBUTE4
                        ,ATTRIBUTE5
                        ,ATTRIBUTE6
                        ,ATTRIBUTE7
                        ,ATTRIBUTE8
                        ,ATTRIBUTE9
                        ,ATTRIBUTE10
                        ,ATTRIBUTE11
                        ,ATTRIBUTE12
                        ,ATTRIBUTE13
                        ,ATTRIBUTE14
                        ,ATTRIBUTE15
                        )
                    SELECT   V_PLAN_ID
                            /*  TO_SITE / INCOTERMS / TRANSPORT_MODE 는 NULL 가능(원천 널 허용) -> MSSQL 결합의 NULL 전파를 CASE 로 재현 */
                            ,CASE WHEN DEMAND.TO_SITE IS NULL OR DEMAND.INCOTERMS IS NULL OR DEMAND.TRANSPORT_MODE IS NULL THEN NULL
                                  ELSE DEMAND.SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||DEMAND.STAGE||'::'||DEMAND.DUE_DATE||'::'||DEMAND.TO_SITE||'::'||DEMAND.INCOTERMS||'::'||DEMAND.TRANSPORT_MODE||'::'||'REQ'
                             END                                                                AS DEMAND_ID
                            ,DEMAND.SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||DEMAND.STAGE                                AS BUFFER_ID
                            /* ,TO_SITE                                                            AS DEMAND_GROUP */
                            /*  Ship Frozen 내인 경우 'SF' */
                            ,CASE WHEN DEMAND.SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE CASE WHEN RTRIM(DEMAND.PRIORITY) IS NULL THEN NULL ELSE 'D'||DEMAND.PRIORITY END
                            END                                                                AS DEMAND_GROUP
                            ,DEMAND.DUE_DATE                                                    AS DUE_DATE
                            ,NULL                                                               AS TARGET_DATE
                            ,NULL                                                               AS SALES_CUTOFF_DATE
                            ,NULL                                                               AS EXPIRY_DATE
                            ,DEMAND.PRIORITY                                                    AS PRIORITY
                            /*  Ship Frozen 내인 경우 '' */
                            /* ,CASE WHEN SHIP_FROZEN = 'Y' THEN '' */
                            /*       ELSE NULL */
                            /*  END                                                                AS PRIORITY */
                            ,DEMAND.QUANTITY                                                    AS QUANTITY
                            /* ,NULL                                                               AS PRIORITY_GROUP */
                            /*  Ship Frozen 내인 경우 'SF' */
                            ,CASE WHEN DEMAND.SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE CASE WHEN RTRIM(DEMAND.PRIORITY) IS NULL THEN NULL ELSE 'D'||DEMAND.PRIORITY END
                            END                                                                AS PRIORITY_GROUP
                            ,NULL                                                               AS CUSTOMER_ID
                            ,NULL                                                               AS ALLOW_SHORT
                            ,DEMAND.SCM_SITE_ID                                                 AS ATTRIBUTE1
                            ,DEMAND.ITEM_ID                                                     AS ATTRIBUTE2
                            ,DEMAND.STAGE                                                       AS ATTRIBUTE3
                            ,DEMAND.INCOTERMS                                                   AS ATTRIBUTE4
                            ,NULL                                                               AS ATTRIBUTE5
                            ,DEMAND.TO_SITE                                                     AS ATTRIBUTE6
                            ,DEMAND.TRANSPORT_MODE                                              AS ATTRIBUTE7
                            ,NULL                                                               AS ATTRIBUTE8
                            ,NULL                                                               AS ATTRIBUTE9
                            ,NULL                                                               AS ATTRIBUTE10
                            ,NULL                                                               AS ATTRIBUTE11
                            ,NULL                                                               AS ATTRIBUTE12
                            ,NULL                                                               AS ATTRIBUTE13
                            ,NULL                                                               AS ATTRIBUTE14
                            ,NULL                                                               AS ATTRIBUTE15
                    FROM   (
                            SELECT A.DIVISION_ID        AS DIVISION_ID
                                ,A.FROM_SITE            AS SCM_SITE_ID
                                ,A.TO_SITE              AS TO_SITE
                                ,A.ITEM_ID              AS ITEM_ID
                                ,'CHAR'                 AS STAGE
                                /* ,'EXW'          AS INCOTERMS */
                                ,BOD.INCOTERMS          AS INCOTERMS
                                ,BOD.TRANSPORT_MODE     AS TRANSPORT_MODE
                                ,A.YYYYMMDD             AS DUE_DATE
                                ,CASE WHEN A.YYYYMMDD < V_SHIP_FROZEN_DAY THEN 'Y'
                                      ELSE 'N'
                                      END               AS SHIP_FROZEN
                                ,SUM(A.QTY)             AS QUANTITY
                                ,TP.PRIORITY            AS PRIORITY


                            FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                                /* ---------------------------------------------------------------------- */
                                INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                                            FROM   SCM_MST_SITE
                                            WHERE  DIVISION_ID     = V_DIVISION_ID
                                            AND    SITE_TYPE       = 'PLANT'
                                            AND    OPERATION_GROUP = 'A' /*  소형은 Cell 출하를 CEll Biz 용 Demand 만 처리 */
                                            AND    VALID_YN        = 'Y'

                                        ) B
                                    ON    A.FROM_SITE   = B.SCM_SITE_ID
                                    AND   A.DIVISION_ID = B.DIVISION_ID
                                /* ---------------------------------------------------------------------- */
                                INNER JOIN SCP_MST_BOD_N_V BOD
                                    ON    A.DIVISION_ID = BOD.DIVISION_ID
                                    AND   A.BOD_ID      = BOD.BOD_ID
                                /* ---------------------------------------------------------------------- */
                                /*  2025.07.15 Philsu Park: 소형 Shipment SEMI 에도 Priority 값 반영. */
                                /* ---------------------------------------------------------------------- */
                                LEFT OUTER JOIN ( /* TOSITE PRIORITY CONSTRAINT */
                                                /* SELECT   SEGMENT4   AS ITEM_ID */
                                                /*         ,SEGMENT5   AS TO_SITE */
                                                /*         ,SEGMENT6   AS PRIORITY */
                                                /*         ,ATTRIBUTE1 AS FROM_DATE */
                                                /*         ,ATTRIBUTE2 AS TO_DATE */
                                                /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK) */
                                                /* WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW' */
                                                /* AND     SEGMENT2    = @V_DIVISION_ID */
                                                /* AND     SEGMENT3    = @V_GROUP_ID */
                                                /* AND     VALID_YN    = 'Y' */

                                                /*  2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                                SELECT  P.ITEM_ID       AS ITEM_ID
                                                      , P.SCM_SITE_ID   AS TO_SITE
                                                      , TO_CHAR(P.PRIO_RANK)     AS PRIORITY
                                                      , P.FROM_YYYYMMDD   AS FROM_DATE
                                                      , P.TO_YYYYMMDD     AS TO_DATE
                                                FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                                      , SCP_OPMZ_PLAN_GR_M PG
                                                WHERE   1=1
                                                AND     P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                                AND     PG.VALID_YN = 'Y'
                                                AND     P.VALID_YN = 'Y'
                                                AND     P.DIVISION_ID = V_DIVISION_ID
                                                AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                                ) TP
                                    ON  A.FROM_SITE     = TP.TO_SITE
                                    AND A.ITEM_ID       = TP.ITEM_ID
                                    AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
                                /* ---------------------------------------------------------------------- */
                            WHERE A.DIVISION_ID         = V_DIVISION_ID
                            AND   A.PLAN_START_YYYYMMDD = V_SCP_PLAN_DATE
                            AND   A.PLAN_TYPE           = V_SCP_PLAN_TYPE
                            AND   A.SEQ                 = V_SCP_PLAN_SEQ
                            AND   A.MEASURE             = 'SHIP_PLAN_AMEND'
                            AND   A.QTY                 > 0
                            AND   A.YYYYMMDD            >= P_PLAN_NAME
                            AND   A.YYYYMMDD            < V_PLAN_END_YYYYMMDD
                            AND   A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                            WHERE   PLAN_ID = V_PLAN_ID
                                            )
                            GROUP BY A.DIVISION_ID, A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE, TP.PRIORITY
                            ) DEMAND
                        /* ---------------------------------------------------------------------- */
                        /*  DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리 */
                        /*  2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
                        /*  2025.11.10 Minyong Lee : 소형 Demand 제외 조건에 Stage 추가 적용에 따른 JOIN Depth 변경 */
                        /* ---------------------------------------------------------------------- */
                        LEFT JOIN   (
                                    /* SELECT  SEGMENT2   AS DIVISION_ID */
                                    /*       , SEGMENT3   AS SCM_SITE_ID */
                                    /*       , SEGMENT4   AS ITEM_ID */
                                    /*       , SEGMENT5   AS GROUP_ID */
                                    /*       , ATTRIBUTE1 AS STAGE */
                                    /*       , CASE */
                                    /*             WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외 */
                                    /*             ELSE ATTRIBUTE2 */
                                    /*         END AS START_DATE  -- PLAN 제외 시작일자 */
                                    /*       , CASE */
                                    /*             WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외 */
                                    /*             ELSE ATTRIBUTE3 */
                                    /*         END AS END_DATE  -- PLAN 제외 끝일자 */
                                    /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK) */
                                    /* WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION' */
                                    /* AND     VALID_YN    = 'Y' */
                                    /* AND     SEGMENT2    = @V_DIVISION_ID */
                                    /* AND     SEGMENT5    = @V_GROUP_ID */

                                    /*  2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                                    SELECT  D.DIVISION_ID           AS DIVISION_ID
                                          , D.SCM_SITE_ID           AS SCM_SITE_ID
                                          , D.ITEM_ID               AS ITEM_ID
                                          , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                          , D.STAGE                 AS STAGE
                                          , CASE
                                                WHEN RTRIM(D.FROM_YYYYMMDD) IS NULL THEN V_PLAN_END_YYYYMMDD
                                                ELSE D.FROM_YYYYMMDD
                                            END                     AS START_DATE
                                          , CASE
                                                WHEN RTRIM(D.TO_YYYYMMDD) IS NULL THEN V_PLAN_END_YYYYMMDD
                                                ELSE D.TO_YYYYMMDD
                                            END                     AS END_DATE
                                    FROM    SCP_OPMZ_DEMAND_EXCEPTION D
                                          , SCP_OPMZ_PLAN_GR_M PG
                                    WHERE   1=1
                                    AND     D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                    AND     PG.VALID_YN = 'Y'
                                    AND     D.VALID_YN = 'Y'
                                    AND     D.DIVISION_ID = V_DIVISION_ID
                                    AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                    ) DE
                            ON  DEMAND.SCM_SITE_ID   = DE.SCM_SITE_ID
                            AND DEMAND.ITEM_ID       = DE.ITEM_ID
                            AND ((DEMAND.DIVISION_ID = '40' AND DEMAND.STAGE = DE.STAGE) OR  /*  소형의 경우 JOIN 조건에 STAGE까지 고려 */
                                 DEMAND.DIVISION_ID <> '40')
                    /*  DEMAND 제외 대상 처리 */
                    WHERE   1=1
                    AND     (RTRIM(DE.ITEM_ID) IS NULL OR                                                                         /*  수요 제외 대상이 아니거나 */
                             (RTRIM(DE.ITEM_ID) IS NOT NULL AND (DEMAND.DUE_DATE < DE.START_DATE OR DEMAND.DUE_DATE > DE.END_DATE))); /*  수요 제외 대상이어도 기간 범위 밖인 것 */
            END IF;
        END IF; /*  IF @V_DIVISION_ID = '40' */
        /* ---------------------------------------------------------------------- */
        /*  2. 수요 묶음. */
        /* ---------------------------------------------------------------------- */

        DBMS_OUTPUT.PUT_LINE('4. Demand Merge Type Update: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));
        /* -------------------------------------------------------------------------- */
        /*  2025.06.09 Philsu Park */
        /*  Demand 뭉치기 대상 마킹을 위한 Temp Update. */
        /* -------------------------------------------------------------------------- */
        /*  원본 UPDATE .. FROM LEFT OUTER JOIN -> Oracle 미지원. */
        /*    아우터조인이라 PLAN_ID 가 일치하는 전 행이 갱신 대상이고 미매칭 행은 'X' 가 된다. */


        UPDATE  GT_OPT_DIV_DM_DM_INS DM
        SET     DM.ATTRIBUTE15 = NVL(( SELECT MAX(LK.DEMAND_MERGE_TYPE)
                                       FROM (
                                              SELECT    SEGMENT2 AS DIVISION_ID
                                                      , SEGMENT3 AS PLAN_GROUP_ID
                                                      , SEGMENT4 AS SITE_ID
                                                      , SEGMENT5 AS STAGE
                                                      , SEGMENT6 AS LINE_ID
                                                      , SEGMENT7 AS ITEM_ID
                                                      , ATTRIBUTE1 AS DEMAND_MERGE_TYPE
                                                      , TO_NUMBER(ATTRIBUTE2 DEFAULT NULL ON CONVERSION ERROR) * 7 AS MERGE_VAL
                                                      , ATTRIBUTE3 AS DIO_VAL
                                              FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL
                                              WHERE   1=1
                                              AND     LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                                              AND     VALID_YN      = 'Y'
                                              AND     SEGMENT2      = V_DIVISION_ID
                                              AND     SEGMENT3      = V_GROUP_ID
                                              ) LK
                                       WHERE LK.SITE_ID      = DM.ATTRIBUTE1
                                       AND   LK.ITEM_ID      = DM.ATTRIBUTE2
                                       AND   LK.STAGE        = DM.ATTRIBUTE3
                                       AND   DM.DUE_DATE    >= V_PROD_FROZEN_END_YMD
                                     ), 'X')
        WHERE   DM.PLAN_ID      = V_PLAN_ID
        ;


        DBMS_OUTPUT.PUT_LINE('4.1. Delete Item with quantity 0: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));
        /* 20251015/T.K.KIM/워크벤치에서 0으로 들어온 데이터는 원천에서 안 가져오게하고 삭제 */
        DELETE FROM GT_OPT_DIV_DM_DM_INS
        WHERE PLAN_ID = V_PLAN_ID
        AND   QUANTITY = 0;

        DBMS_OUTPUT.PUT_LINE('5. Demand Origin Backup: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));
        /* -------------------------------------------------------------------------- */
        /*  1.3 Demand Origin Backup */
        /*  2025.06.10 Philsu Park: 원본 DEMAND 를 백업한다.(동일 PLAN_ID로 삭제 후 INSERT) */
        /* -------------------------------------------------------------------------- */
        DELETE
        FROM    SCP_OPT_ENG_DEMAND_ORIGIN_SN
        WHERE   PLAN_ID = V_PLAN_ID
        ;

        INSERT INTO SCP_OPT_ENG_DEMAND_ORIGIN_SN
            (PLAN_ID
            ,DEMAND_ID
            ,BUFFER_ID
            ,DEMAND_GROUP
            ,DUE_DATE
            ,TARGET_DATE
            ,SALES_CUTOFF_DATE
            ,EXPIRY_DATE
            ,PRIORITY
            ,QUANTITY
            ,PRIORITY_GROUP
            ,CUSTOMER_ID
            ,ALLOW_SHORT
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
            ,ATTRIBUTE9
            ,ATTRIBUTE10
            ,ATTRIBUTE11
            ,ATTRIBUTE12
            ,ATTRIBUTE13
            ,ATTRIBUTE14
            ,ATTRIBUTE15
            )
            SELECT   DM.PLAN_ID
                    ,DM.DEMAND_ID
                    ,DM.BUFFER_ID
                    ,DM.DEMAND_GROUP
                    ,DM.DUE_DATE
                    ,DM.TARGET_DATE
                    ,DM.SALES_CUTOFF_DATE
                    ,DM.EXPIRY_DATE
                    ,DM.PRIORITY
                    ,DM.QUANTITY
                    ,DM.PRIORITY_GROUP
                    ,DM.CUSTOMER_ID
                    ,DM.ALLOW_SHORT
                    ,DM.ATTRIBUTE1
                    ,DM.ATTRIBUTE2
                    ,DM.ATTRIBUTE3
                    ,DM.ATTRIBUTE4
                    ,DM.ATTRIBUTE5
                    ,DM.ATTRIBUTE6
                    ,DM.ATTRIBUTE7
                    ,DM.ATTRIBUTE8
                    ,DM.ATTRIBUTE9
                    ,DM.ATTRIBUTE10
                    ,DM.ATTRIBUTE11
                    ,DM.ATTRIBUTE12
                    ,DM.ATTRIBUTE13
                    ,DM.ATTRIBUTE14
                    ,DM.ATTRIBUTE15
            FROM GT_OPT_DIV_DM_DM_INS DM
            WHERE 1=1
            AND DM.PLAN_ID  = V_PLAN_ID
            ;


        DBMS_OUTPUT.PUT_LINE('6. Demand Insert NOT IN A, B, C: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));
        /* -------------------------------------------------------------------------- */
        /*  1.4 Demand Insert */
        /*  2025.06.09 Philsu Park: A Type은 별도 처리. 나머지는 기존대로 넣어줌. */
        /*  2025.08.27 Philsu Park: C Type 추가. */
        /* ---------------------------------------------------------------------- */
        INSERT INTO SCP_OPT_ENG_DEMAND_SN
            (PLAN_ID
            ,DEMAND_ID
            ,BUFFER_ID
            ,DEMAND_GROUP
            ,DUE_DATE
            ,TARGET_DATE
            ,SALES_CUTOFF_DATE
            ,EXPIRY_DATE
            ,PRIORITY
            ,QUANTITY
            ,PRIORITY_GROUP
            ,CUSTOMER_ID
            ,ALLOW_SHORT
            ,ATTRIBUTE1
            ,ATTRIBUTE2
            ,ATTRIBUTE3
            ,ATTRIBUTE4
            ,ATTRIBUTE5
            ,ATTRIBUTE6
            ,ATTRIBUTE7
            ,ATTRIBUTE8
            ,ATTRIBUTE9
            ,ATTRIBUTE10
            ,ATTRIBUTE11
            ,ATTRIBUTE12
            ,ATTRIBUTE13
            ,ATTRIBUTE14
            ,ATTRIBUTE15
            )
            SELECT DM.PLAN_ID
                ,DM.DEMAND_ID
                ,DM.BUFFER_ID
                ,DM.DEMAND_GROUP
                ,DM.DUE_DATE
                ,DM.TARGET_DATE
                ,DM.SALES_CUTOFF_DATE
                ,DM.EXPIRY_DATE
                ,DM.PRIORITY
                ,DM.QUANTITY
                ,DM.PRIORITY_GROUP
                ,DM.CUSTOMER_ID
                ,DM.ALLOW_SHORT
                ,DM.ATTRIBUTE1
                ,DM.ATTRIBUTE2
                ,DM.ATTRIBUTE3
                ,DM.ATTRIBUTE4
                ,DM.ATTRIBUTE5
                ,DM.ATTRIBUTE6
                ,DM.ATTRIBUTE7
                ,DM.ATTRIBUTE8
                ,DM.ATTRIBUTE9
                ,DM.ATTRIBUTE10
                ,DM.ATTRIBUTE11
                ,DM.ATTRIBUTE12
                ,DM.ATTRIBUTE13
                ,DM.ATTRIBUTE14
                ,DM.ATTRIBUTE15
            FROM GT_OPT_DIV_DM_DM_INS DM
            WHERE 1=1
            AND DM.PLAN_ID  = V_PLAN_ID
            AND DM.ATTRIBUTE15 NOT IN ('A', 'B', 'C', 'D')
            ;

        DBMS_OUTPUT.PUT_LINE('7. Demand Insert TYpe A: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));


        /* -------------------------------------------------------------------------- */
        /*  1.4 Demand Insert */
        /*  2025.06.09 Philsu Park: A Type 별도 처리. */
        /*  2025.08.25 Philsu Park: A Type의 value 기준을 주차가 아닌 일로 변경.(Due Date를 포함해야되서 Minus 1) */
        /* -------------------------------------------------------------------------- */
        SELECT COUNT(*)
          INTO V_CNT
        FROM   GT_OPT_DIV_DM_DM_INS S
        WHERE 1=1
        AND S.PLAN_ID       = V_PLAN_ID
        AND S.ATTRIBUTE15   = 'A'
        AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD
        ;
        IF V_CNT > 0 THEN

                /*    -> GTT 는 DROP 대신 DELETE 로 정리. */
                DELETE FROM GT_OPT_DIV_DM_TYPE_A;

                INSERT INTO GT_OPT_DIV_DM_TYPE_A
                    (R_NUM, DEMAND_DATE, MERGE_VAL
                    ,PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                    ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                    ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                    ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, GROUP_ID)
                SELECT    ROW_NUMBER()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_DATE) AS R_NUM
                        , CM.BASIS_DATE AS DEMAND_DATE
                        , LK.MERGE_VAL
                        , S.PLAN_ID, S.DEMAND_ID, S.BUFFER_ID, S.DEMAND_GROUP, S.DUE_DATE, S.TARGET_DATE, S.SALES_CUTOFF_DATE, S.EXPIRY_DATE
                        , S.PRIORITY, S.QUANTITY, S.PRIORITY_GROUP, S.CUSTOMER_ID, S.ALLOW_SHORT
                        , S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5, S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8
                        , S.ATTRIBUTE9, S.ATTRIBUTE10, S.ATTRIBUTE11, S.ATTRIBUTE12, S.ATTRIBUTE13, S.ATTRIBUTE14, S.ATTRIBUTE15, S.GROUP_ID
                FROM    GT_OPT_DIV_DM_DM_INS S
                      , SCM_SYS_CALENDAR_M CM
                      , (SELECT    SEGMENT2                          AS DIVISION_ID
                                    , SEGMENT3                          AS PLAN_GROUP_ID
                                    , SEGMENT4                          AS SITE_ID
                                    , SEGMENT5                          AS STAGE
                                    , SEGMENT6                          AS LINE_ID
                                    , SEGMENT7                          AS ITEM_ID
                                    , ATTRIBUTE1                        AS DEMAND_MERGE_TYPE
                                    , TO_NUMBER(ATTRIBUTE2) - 1         AS MERGE_VAL
                                    /*  , CAST(ATTRIBUTE2 AS INT) * 7       AS MERGE_VAL */
                                    , ATTRIBUTE3                        AS DIO_VAL
                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D
                            WHERE   1=1
                            AND     D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                            AND     D.VALID_YN      = 'Y'
                            AND     D.ATTRIBUTE1    = 'A'
                            AND     D.SEGMENT2      = V_DIVISION_ID
                            AND     D.SEGMENT3      = V_GROUP_ID
                            ) LK
                WHERE 1=1
                AND S.DUE_DATE  = CM.BASIS_YYYYMMDD
                AND LK.SITE_ID  = S.ATTRIBUTE1
                AND LK.ITEM_ID  = S.ATTRIBUTE2
                AND LK.STAGE    = S.ATTRIBUTE3
                AND S.PLAN_ID       = V_PLAN_ID
                AND S.ATTRIBUTE15   = 'A'
                AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD
            ;

            INSERT INTO SCP_OPT_ENG_DEMAND_SN
                (PLAN_ID
                ,DEMAND_ID
                ,BUFFER_ID
                ,DEMAND_GROUP
                ,DUE_DATE
                ,TARGET_DATE
                ,SALES_CUTOFF_DATE
                ,EXPIRY_DATE
                ,PRIORITY
                ,QUANTITY
                ,PRIORITY_GROUP
                ,CUSTOMER_ID
                ,ALLOW_SHORT
                ,ATTRIBUTE1
                ,ATTRIBUTE2
                ,ATTRIBUTE3
                ,ATTRIBUTE4
                ,ATTRIBUTE5
                ,ATTRIBUTE6
                ,ATTRIBUTE7
                ,ATTRIBUTE8
                ,ATTRIBUTE9
                ,ATTRIBUTE10
                ,ATTRIBUTE11
                ,ATTRIBUTE12
                ,ATTRIBUTE13
                ,ATTRIBUTE14
                ,ATTRIBUTE15
                )

            WITH RECURSIVE_DEMAND (GROUP_START_DATE, GROUP_NO, DEMAND_DATE, R_NUM, MERGE_VAL, PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP
                                 , DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE, PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                                 , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                                 , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15) AS (
                        SELECT    DM.DEMAND_DATE    AS GROUP_START_DATE
                                , 1                 AS GROUP_NO
                                , DM.DEMAND_DATE    AS DEMAND_DATE
                                , DM.R_NUM
                                , DM.MERGE_VAL
                                , DM.PLAN_ID
                                , DM.DEMAND_ID
                                , DM.BUFFER_ID
                                , DM.DEMAND_GROUP
                                , DM.DUE_DATE
                                , DM.TARGET_DATE
                                , DM.SALES_CUTOFF_DATE
                                , DM.EXPIRY_DATE
                                , DM.PRIORITY
                                , DM.QUANTITY
                                , DM.PRIORITY_GROUP
                                , DM.CUSTOMER_ID
                                , DM.ALLOW_SHORT
                                , DM.ATTRIBUTE1
                                , DM.ATTRIBUTE2
                                , DM.ATTRIBUTE3
                                , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                                , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                        FROM    GT_OPT_DIV_DM_TYPE_A DM
                        WHERE   DM.R_NUM = 1
                        UNION ALL
                        SELECT    CASE WHEN (DM.DEMAND_DATE - PREV.GROUP_START_DATE) > DM.MERGE_VAL THEN DM.DEMAND_DATE
                                    WHEN (DM.DEMAND_DATE - PREV.DEMAND_DATE)     > DM.MERGE_VAL  THEN DM.DEMAND_DATE
                                    ELSE PREV.GROUP_START_DATE
                                        END AS GROUP_START_DATE
                                , CASE WHEN (DM.DEMAND_DATE - PREV.GROUP_START_DATE) > DM.MERGE_VAL THEN PREV.GROUP_NO + 1
                                        WHEN (DM.DEMAND_DATE - PREV.DEMAND_DATE) > DM.MERGE_VAL THEN PREV.GROUP_NO + 1
                                        ELSE PREV.GROUP_NO
                                        END AS GROUP_NO
                                , DM.DEMAND_DATE
                                , DM.R_NUM
                                , DM.MERGE_VAL
                                , DM.PLAN_ID
                                , DM.DEMAND_ID
                                , DM.BUFFER_ID
                                , DM.DEMAND_GROUP
                                , DM.DUE_DATE
                                , DM.TARGET_DATE
                                , DM.SALES_CUTOFF_DATE
                                , DM.EXPIRY_DATE
                                , DM.PRIORITY
                                , DM.QUANTITY
                                , DM.PRIORITY_GROUP
                                , DM.CUSTOMER_ID
                                , DM.ALLOW_SHORT
                                , DM.ATTRIBUTE1
                                , DM.ATTRIBUTE2
                                , DM.ATTRIBUTE3
                                , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                                , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                        FROM    GT_OPT_DIV_DM_TYPE_A DM
                        INNER JOIN RECURSIVE_DEMAND PREV
                            ON DM.ATTRIBUTE1 = PREV.ATTRIBUTE1
                            AND DM.ATTRIBUTE2 = PREV.ATTRIBUTE2
                            AND DM.ATTRIBUTE3 = PREV.ATTRIBUTE3
                            AND DM.R_NUM        = PREV.R_NUM + 1
                        WHERE   1=1
                    )
                SELECT    /* GROUP_NO
                        , GROUP_START_DATE */
                        FDM.PLAN_ID                                   AS PLAN_ID
                        , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID
                        , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID
                        , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP
                        , TO_CHAR(MIN(FDM.DEMAND_DATE), 'YYYYMMDD')     AS DUE_DATE
                        , MIN(FDM.TARGET_DATE)                          AS TARGET_DATE
                        , MIN(FDM.SALES_CUTOFF_DATE)                    AS SALES_CUTOFF_DATE
                        , MIN(FDM.EXPIRY_DATE)                          AS EXPIRY_DATE
                        , MIN(FDM.PRIORITY)                             AS PRIORITY
                        , ROUND(SUM(FDM.QUANTITY), 0)                   AS QUANTITY
                        , MIN(FDM.PRIORITY_GROUP)                       AS PRIORITY_GROUP
                        , MIN(FDM.CUSTOMER_ID)                          AS CUSTOMER_ID
                        , MIN(FDM.ALLOW_SHORT)                          AS ALLOW_SHORT
                        , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
                        , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
                        , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
                        , MIN(FDM.ATTRIBUTE4)                           AS ATTRIBUTE4
                        , MIN(FDM.ATTRIBUTE5)                           AS ATTRIBUTE5
                        , MIN(FDM.ATTRIBUTE6)                           AS ATTRIBUTE6
                        , MIN(FDM.ATTRIBUTE7)                           AS ATTRIBUTE7
                        , MIN(FDM.ATTRIBUTE8)                           AS ATTRIBUTE8
                        , MIN(FDM.ATTRIBUTE9)                           AS ATTRIBUTE9
                        , MIN(FDM.ATTRIBUTE10)                          AS ATTRIBUTE10
                        , MIN(FDM.ATTRIBUTE11)                          AS ATTRIBUTE11
                        , MIN(FDM.ATTRIBUTE12)                          AS ATTRIBUTE12
                        , MIN(FDM.ATTRIBUTE13)                          AS ATTRIBUTE13
                        , MIN(FDM.ATTRIBUTE14)                          AS ATTRIBUTE14
                        , MIN(FDM.ATTRIBUTE15)                          AS ATTRIBUTE15
                FROM    RECURSIVE_DEMAND FDM
                GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_NO, FDM.GROUP_START_DATE

                ;
        END IF;


        DBMS_OUTPUT.PUT_LINE('8. Demand Insert TYpe B: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));

        SELECT COUNT(*)
          INTO V_CNT
        FROM   GT_OPT_DIV_DM_DM_INS S
        WHERE 1=1
        AND S.PLAN_ID       = V_PLAN_ID
        AND S.ATTRIBUTE15   = 'B'
        AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD
        ;
        IF V_CNT > 0 THEN
                /* -------------------------------------------------------------------------- */
                /*  1.4 Demand Insert */
                /*  2025.06.11 Philsu Park: B Type 별도 처리. */
                /*  2025.06.18 Philsu Park: Due Date가 Plan 구간 바깥에 있으면 안되기 때문에 LEAST 처리. */
                /*  2025.08.28 Philsu Park: DIO_QTY를 계산하는 첫달 찾는 로직은 FIRST_ORDER로 찾게 변경.(Frozen End월과 실제 계획 첫달의 Gap이 있는 경우 첫달 계획 차감하는 결함 보완) */
                /* -------------------------------------------------------------------------- */
                INSERT INTO SCP_OPT_ENG_DEMAND_SN
                    (PLAN_ID
                    ,DEMAND_ID
                    ,BUFFER_ID
                    ,DEMAND_GROUP
                    ,DUE_DATE
                    ,TARGET_DATE
                    ,SALES_CUTOFF_DATE
                    ,EXPIRY_DATE
                    ,PRIORITY
                    ,QUANTITY
                    ,PRIORITY_GROUP
                    ,CUSTOMER_ID
                    ,ALLOW_SHORT
                    ,ATTRIBUTE1
                    ,ATTRIBUTE2
                    ,ATTRIBUTE3
                    ,ATTRIBUTE4
                    ,ATTRIBUTE5
                    ,ATTRIBUTE6
                    ,ATTRIBUTE7
                    ,ATTRIBUTE8
                    ,ATTRIBUTE9
                    ,ATTRIBUTE10
                    ,ATTRIBUTE11
                    ,ATTRIBUTE12
                    ,ATTRIBUTE13
                    ,ATTRIBUTE14
                    ,ATTRIBUTE15
                    )
                WITH DEMAND AS (
                        SELECT    DM.PLAN_ID
                                , DM.ATTRIBUTE1||'::'||DM.ATTRIBUTE2||'::'||DM.ATTRIBUTE3||'@'||DM.ATTRIBUTE4||'@'||DM.ATTRIBUTE5||'::'||CASE WHEN SUBSTR(V_PROD_FROZEN_END_YMD, 1, 6)=DM.PLAN_YYYYMM THEN DM.MIN_PLAN_YYYYMMDD ELSE DM.PLAN_YYYYMM||LK.MERGE_VAL END||'::'||'-'||'::'||DM.ATTRIBUTE8 AS DEMAND_ID
                                , DM.BUFFER_ID
                                , MIN(DM.DEMAND_GROUP)      AS DEMAND_GROUP
                                , DM.PLAN_YYYYMM            AS PLAN_YYYYMM
                                , CASE WHEN SUBSTR(V_PROD_FROZEN_END_YMD, 1, 6)=DM.PLAN_YYYYMM THEN DM.MIN_PLAN_YYYYMMDD ELSE DM.PLAN_YYYYMM||LK.MERGE_VAL END AS DUE_DATE
                                , MIN(DM.TARGET_DATE)       AS TARGET_DATE
                                , MIN(DM.SALES_CUTOFF_DATE) AS SALES_CUTOFF_DATE
                                , MIN(DM.EXPIRY_DATE)       AS EXPIRY_DATE
                                , MIN(DM.PRIORITY)          AS PRIORITY
                                , SUM(DM.QUANTITY)          AS QUANTITY
                                , MAX(LK.DIO_VAL)           AS DIO_VAL
                                /*  , ROUND(IIF(LEFT(@V_PROD_FROZEN_END_YMD, 6)=DM.PLAN_YYYYMM, 0, SUM(DM.QUANTITY)/30.42*MAX(DIO_VAL)), 0) AS DIO_QTY */
                                /*  원본 CONVERT(FLOAT, ..) 은 프로젝트 결정(FLOAT -> NUMBER)에 따라 Oracle NUMBER 연산으로 대체한다. */
                                , CASE WHEN DM.MONTH_ORDER = 1 THEN 0 ELSE SUM(DM.QUANTITY)/30.42*MAX(LK.DIO_VAL) END AS DIO_QTY
                                , MIN(DM.PRIORITY_GROUP)    AS PRIORITY_GROUP
                                , MIN(DM.CUSTOMER_ID)       AS CUSTOMER_ID
                                , MIN(DM.ALLOW_SHORT)       AS ALLOW_SHORT
                                , DM.ATTRIBUTE1             AS ATTRIBUTE1
                                , DM.ATTRIBUTE2             AS ATTRIBUTE2
                                , DM.ATTRIBUTE3             AS ATTRIBUTE3
                                , DM.ATTRIBUTE4             AS ATTRIBUTE4
                                , DM.ATTRIBUTE5             AS ATTRIBUTE5
                                , MIN(DM.ATTRIBUTE6)        AS ATTRIBUTE6
                                , MIN(DM.ATTRIBUTE7)        AS ATTRIBUTE7
                                , DM.ATTRIBUTE8             AS ATTRIBUTE8
                                , MIN(DM.ATTRIBUTE9)        AS ATTRIBUTE9
                                , MIN(DM.ATTRIBUTE10)       AS ATTRIBUTE10
                                , MIN(DM.ATTRIBUTE11)       AS ATTRIBUTE11
                                , MIN(DM.ATTRIBUTE12)       AS ATTRIBUTE12
                                , MIN(DM.ATTRIBUTE13)       AS ATTRIBUTE13
                                , MIN(DM.ATTRIBUTE14)       AS ATTRIBUTE14
                                , MIN(DM.ATTRIBUTE15)       AS ATTRIBUTE15
                                , MIN(DM.PLAN_YYYYMM)OVER(PARTITION BY DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3) AS START_YYYYMM
                                , MAX(DM.PLAN_YYYYMM)OVER(PARTITION BY DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3) AS END_YYYYMM
                                , MIN(LK.MERGE_VAL)         AS MERGE_VAL
                        FROM (
                                SELECT    S.PLAN_ID, S.DEMAND_ID, S.BUFFER_ID, S.DEMAND_GROUP, S.DUE_DATE, S.TARGET_DATE, S.SALES_CUTOFF_DATE, S.EXPIRY_DATE
                                        , S.PRIORITY, S.QUANTITY, S.PRIORITY_GROUP, S.CUSTOMER_ID, S.ALLOW_SHORT
                                        , S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5, S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8
                                        , S.ATTRIBUTE9, S.ATTRIBUTE10, S.ATTRIBUTE11, S.ATTRIBUTE12, S.ATTRIBUTE13, S.ATTRIBUTE14, S.ATTRIBUTE15, S.GROUP_ID
                                        , CM.BASIS_YYYYMM AS PLAN_YYYYMM
                                        , CM.BASIS_DATE
                                        , MIN(S.DUE_DATE)OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, CM.BASIS_YYYYMM) MIN_PLAN_YYYYMMDD
                                        , DENSE_RANK()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_YYYYMM) AS MONTH_ORDER
                                        /*  , IIF(LEFT(S.DUE_DATE, 1, 6)='202505', MIN(S.DUE_DATE), LEFT(S.DUE_DATE)+LK.MERGE_VAL) AS DEMAND_DATE */
                                FROM    GT_OPT_DIV_DM_DM_INS S
                                      , SCM_SYS_CALENDAR_M CM
                                WHERE   S.DUE_DATE  = CM.BASIS_YYYYMMDD
                                AND     S.PLAN_ID   = V_PLAN_ID
                                AND     S.DUE_DATE >= V_PROD_FROZEN_END_YMD
                                AND     S.ATTRIBUTE15 = 'B'
                                ) DM
                              , (SELECT    SEGMENT2 AS DIVISION_ID
                                            , SEGMENT3 AS PLAN_GROUP_ID
                                            , SEGMENT4 AS SITE_ID
                                            , SEGMENT5 AS STAGE
                                            , SEGMENT6 AS LINE_ID
                                            , SEGMENT7 AS ITEM_ID
                                            , ATTRIBUTE1 AS DEMAND_MERGE_TYPE
                                            /*  MSSQL RIGHT(REPLICATE('0',1)+ATTRIBUTE2, 2) : ATTRIBUTE2 가 NOT NULL 이면 결합 길이가 2 이상이라 */
                                            /*  SUBSTR 음수 NULL 함정에 걸리지 않고, NULL 이면 양쪽 다 NULL 이라 의미가 같다. */
                                            , SUBSTR('0'||ATTRIBUTE2, -2) AS MERGE_VAL
                                            , CAST(ATTRIBUTE3 AS NUMBER(20,10)) AS DIO_VAL
                                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D
                                    WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                                    AND     D.VALID_YN      = 'Y'
                                    AND     D.ATTRIBUTE1    = 'B'
                                    AND     D.SEGMENT2      = V_DIVISION_ID
                                    AND     D.SEGMENT3      = V_GROUP_ID
                                    ) LK
                        WHERE   1=1
                        AND     LK.SITE_ID  = DM.ATTRIBUTE1
                        AND     LK.ITEM_ID  = DM.ATTRIBUTE2
                        AND     LK.STAGE    = DM.ATTRIBUTE3
                        GROUP BY  DM.PLAN_ID
                                , DM.ATTRIBUTE1||'::'||DM.ATTRIBUTE2||'::'||DM.ATTRIBUTE3||'@'||DM.ATTRIBUTE4||'@'||DM.ATTRIBUTE5||'::'||CASE WHEN SUBSTR(V_PROD_FROZEN_END_YMD, 1, 6)=DM.PLAN_YYYYMM THEN DM.MIN_PLAN_YYYYMMDD ELSE DM.PLAN_YYYYMM||LK.MERGE_VAL END||'::'||'-'||'::'||DM.ATTRIBUTE8
                                , DM.BUFFER_ID
                                , DM.PLAN_YYYYMM
                                , CASE WHEN SUBSTR(V_PROD_FROZEN_END_YMD, 1, 6)=DM.PLAN_YYYYMM THEN DM.MIN_PLAN_YYYYMMDD ELSE DM.PLAN_YYYYMM||LK.MERGE_VAL END
                                , DM.ATTRIBUTE1
                                , DM.ATTRIBUTE2
                                , DM.ATTRIBUTE3
                                , DM.ATTRIBUTE4
                                , DM.ATTRIBUTE5
                                , DM.ATTRIBUTE8
                                , DM.MONTH_ORDER
                    )
                , DEMAND_WITH_CAL AS (
                                SELECT *
                                FROM DEMAND
                                UNION ALL
                                SELECT
                                        DM.PLAN_ID                            AS PLAN_ID
                                        , DM.ATTRIBUTE1||'::'||DM.ATTRIBUTE2||'::'||DM.ATTRIBUTE3||'@'||DM.ATTRIBUTE4||'@'||DM.ATTRIBUTE5||'::'||CM.BASIS_YYYYMM||DM.MERGE_VAL||'::'||'-'||'::'||DM.ATTRIBUTE8 AS DEMAND_ID
                                        , DM.BUFFER_ID                          AS BUFFER_ID
                                        , MIN(DM.DEMAND_GROUP)                  AS DEMAND_GROUP
                                        , CM.BASIS_YYYYMM                       AS PLAN_YYYYMM
                                        , CM.BASIS_YYYYMM||DM.MERGE_VAL         AS DUE_DATE
                                        , MIN(DM.TARGET_DATE)                   AS TARGET_DATE
                                        , MIN(DM.SALES_CUTOFF_DATE)             AS SALES_CUTOFF_DATE
                                        , MIN(DM.EXPIRY_DATE)                   AS EXPIRY_DATE
                                        , MIN(DM.PRIORITY)                      AS PRIORITY
                                        , 0                                     AS QUANTITY
                                        , MAX(DM.DIO_VAL)                       AS DIO_VAL
                                        , 0                                     AS DIO_QTY
                                        , MIN(DM.PRIORITY_GROUP)                AS PRIORITY_GROUP
                                        , MIN(DM.CUSTOMER_ID)                   AS CUSTOMER_ID
                                        , MIN(DM.ALLOW_SHORT)                   AS ALLOW_SHORT
                                        , DM.ATTRIBUTE1                         AS ATTRIBUTE1
                                        , DM.ATTRIBUTE2                         AS ATTRIBUTE2
                                        , DM.ATTRIBUTE3                         AS ATTRIBUTE3
                                        , DM.ATTRIBUTE4                         AS ATTRIBUTE4
                                        , DM.ATTRIBUTE5                         AS ATTRIBUTE5
                                        , MIN(DM.ATTRIBUTE6)                    AS ATTRIBUTE6
                                        , MIN(DM.ATTRIBUTE7)                    AS ATTRIBUTE7
                                        , DM.ATTRIBUTE8                         AS ATTRIBUTE8
                                        , MIN(DM.ATTRIBUTE9)                    AS ATTRIBUTE9
                                        , MIN(DM.ATTRIBUTE10)                   AS ATTRIBUTE10
                                        , MIN(DM.ATTRIBUTE11)                   AS ATTRIBUTE11
                                        , MIN(DM.ATTRIBUTE12)                   AS ATTRIBUTE12
                                        , MIN(DM.ATTRIBUTE13)                   AS ATTRIBUTE13
                                        , MIN(DM.ATTRIBUTE14)                   AS ATTRIBUTE14
                                        , MIN(DM.ATTRIBUTE15)                   AS ATTRIBUTE15
                                        , MIN(DM.START_YYYYMM)                  AS START_YYYYMM
                                        , MIN(DM.END_YYYYMM)                    AS END_YYYYMM
                                        , DM.MERGE_VAL                          AS MERGE_VAL
                                FROM    DEMAND DM
                                      , SCM_SYS_CALENDAR_M CM
                                WHERE   1=1
                                AND     CM.BASIS_YYYYMM  BETWEEN DM.START_YYYYMM AND DM.END_YYYYMM
                                AND     NOT EXISTS ( SELECT 1
                                                    FROM   DEMAND DD
                                                    WHERE  1=1
                                                    AND     DD.PLAN_ID = DM.PLAN_ID
                                                    AND     DD.BUFFER_ID = DM.BUFFER_ID
                                                    AND     DD.PLAN_YYYYMM = CM.BASIS_YYYYMM)
                                GROUP BY DM.PLAN_ID, DM.BUFFER_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE3, DM.ATTRIBUTE4, DM.ATTRIBUTE5, DM.ATTRIBUTE8, CM.BASIS_YYYYMM, DM.MERGE_VAL
                                )
                    SELECT
                        /* DM.QUANTITY AS ORG_QTY
                        , DM.PLAN_YYYYMM
                        , DM2.PLAN_YYYYMM
                        , DM2.DIO_QTY ADD_QTY
                        , DM.DIO_QTY MINUS_QTY
                        , DM.QUANTITY + ISNULL(DM2.DIO_QTY, 0) - ISNULL(DM.DIO_QTY, 0) AS ADJ_QTY
                        , DM.* */
                        FDM.PLAN_ID                                   AS PLAN_ID
                        , FDM.DEMAND_ID                                 AS DEMAND_ID
                        , FDM.BUFFER_ID                                 AS BUFFER_ID
                        , FDM.DEMAND_GROUP                              AS DEMAND_GROUP

                        , CASE WHEN V_PLAN_END_YYYYMMDD_ORI IS NULL THEN FDM.DUE_DATE
                               WHEN FDM.DUE_DATE IS NULL             THEN V_PLAN_END_YYYYMMDD_ORI
                               ELSE LEAST(V_PLAN_END_YYYYMMDD_ORI, FDM.DUE_DATE)
                          END                                           AS DUE_DATE
                        , FDM.TARGET_DATE                               AS TARGET_DATE
                        , FDM.SALES_CUTOFF_DATE                         AS SALES_CUTOFF_DATE
                        , FDM.EXPIRY_DATE                               AS EXPIRY_DATE
                        , FDM.PRIORITY                                  AS PRIORITY
                        , ROUND(FDM.QUANTITY + NVL(DM2.DIO_QTY, 0) - NVL(FDM.DIO_QTY, 0), 0) AS QUANTITY
                        , FDM.PRIORITY_GROUP                            AS PRIORITY_GROUP
                        , FDM.CUSTOMER_ID                               AS CUSTOMER_ID
                        , FDM.ALLOW_SHORT                               AS ALLOW_SHORT
                        , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
                        , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
                        , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
                        , FDM.ATTRIBUTE4                                AS ATTRIBUTE4
                        , FDM.ATTRIBUTE5                                AS ATTRIBUTE5
                        , FDM.ATTRIBUTE6                                AS ATTRIBUTE6
                        , FDM.ATTRIBUTE7                                AS ATTRIBUTE7
                        , FDM.ATTRIBUTE8                                AS ATTRIBUTE8
                        , FDM.ATTRIBUTE9                                AS ATTRIBUTE9
                        , FDM.ATTRIBUTE10                               AS ATTRIBUTE10
                        , FDM.ATTRIBUTE11                               AS ATTRIBUTE11
                        , FDM.ATTRIBUTE12                               AS ATTRIBUTE12
                        , FDM.ATTRIBUTE13                               AS ATTRIBUTE13
                        , FDM.ATTRIBUTE14                               AS ATTRIBUTE14
                        , FDM.ATTRIBUTE15                               AS ATTRIBUTE15
                    FROM    DEMAND_WITH_CAL FDM

                    LEFT OUTER JOIN DEMAND_WITH_CAL DM2
                        ON  FDM.PLAN_ID = DM2.PLAN_ID
                        AND FDM.BUFFER_ID = DM2.BUFFER_ID
                        /*  PLAN_YYYYMM 결합 후 날짜변환은 MSSQL 에서 NULL 전파이므로 CASE 로 재현한다(Oracle 은 ORA-01840). */
                        AND CASE WHEN FDM.PLAN_YYYYMM IS NULL THEN NULL ELSE ADD_MONTHS(TO_DATE(FDM.PLAN_YYYYMM||'01', 'YYYYMMDD'), 1) END
                          = CASE WHEN DM2.PLAN_YYYYMM IS NULL THEN NULL ELSE TO_DATE(DM2.PLAN_YYYYMM||'01', 'YYYYMMDD') END
                    ;
        END IF;
        /* -------------------------------------------------------------------------- */
        /*  1.4 Demand Insert */
        /*  2025.08.25 Philsu Park: C Type 추가. */
        /*  2025.09.15 Philsu Park: Full Capa 입력값이 있으면 해당 값 활용, 없으면 Capa 정보에서 찾아옴. */
        /* -------------------------------------------------------------------------- */

        DBMS_OUTPUT.PUT_LINE('9. Demand Insert TYpe C: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));

        SELECT COUNT(*)
          INTO V_CNT
        FROM   GT_OPT_DIV_DM_DM_INS S
        WHERE 1=1
        AND S.PLAN_ID       = V_PLAN_ID
        AND S.ATTRIBUTE15   = 'C'
        AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD
        ;

        IF V_CNT > 0 THEN


                /*    -> GTT 는 DROP 대신 DELETE 로 정리. */
                DELETE FROM GT_OPT_DIV_DM_TYPE_C;


                INSERT INTO GT_OPT_DIV_DM_TYPE_C
                    (R_NUM, DEMAND_DATE, MERGE_VAL, MAX_DAYS, FULL_CAPA, QTY, DAILY_CAPA
                    ,PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                    ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                    ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                    ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, GROUP_ID)
                SELECT    /*+ USE_HASH(LK) */
                          ROW_NUMBER()OVER(PARTITION BY S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3 ORDER BY CM.BASIS_DATE) AS R_NUM
                        , CM.BASIS_DATE AS DEMAND_DATE
                        , LK.MERGE_VAL
                        , CAST(LK.MAX_DAYS AS NUMBER(18,0)) AS MAX_DAYS
                        , CAST(LK.FULL_CAPA AS NUMBER(30, 10))    AS FULL_CAPA
                        , CAST(S.QUANTITY AS NUMBER(30, 10))      AS QTY
                        , CAST(LK.DAILY_CAPA AS NUMBER(30, 10))   AS DAILY_CAPA
                        , S.PLAN_ID, S.DEMAND_ID, S.BUFFER_ID, S.DEMAND_GROUP, S.DUE_DATE, S.TARGET_DATE, S.SALES_CUTOFF_DATE, S.EXPIRY_DATE
                        , S.PRIORITY, S.QUANTITY, S.PRIORITY_GROUP, S.CUSTOMER_ID, S.ALLOW_SHORT
                        , S.ATTRIBUTE1, S.ATTRIBUTE2, S.ATTRIBUTE3, S.ATTRIBUTE4, S.ATTRIBUTE5, S.ATTRIBUTE6, S.ATTRIBUTE7, S.ATTRIBUTE8
                        , S.ATTRIBUTE9, S.ATTRIBUTE10, S.ATTRIBUTE11, S.ATTRIBUTE12, S.ATTRIBUTE13, S.ATTRIBUTE14, S.ATTRIBUTE15, S.GROUP_ID
                FROM    GT_OPT_DIV_DM_DM_INS S
                      , SCM_SYS_CALENDAR_M CM
                /*  원본 INNER HASH JOIN : MSSQL 조인 힌트(HASH)는 Oracle 대응 구문이 없어 일반 INNER JOIN 으로 변환 */

                /*                         ③FMT 에서 그 INNER JOIN 을 CNS 콤마조인으로 정렬한다. */
                      , (
                            SELECT    SEGMENT2                                  AS DIVISION_ID
                                    , SEGMENT3                                  AS PLAN_GROUP_ID
                                    , SEGMENT4                                  AS SITE_ID
                                    , SEGMENT5                                  AS STAGE
                                    , SEGMENT6                                  AS LINE_ID
                                    , SEGMENT7                                  AS ITEM_ID
                                    , ATTRIBUTE1                                AS DEMAND_MERGE_TYPE
                                    , TO_NUMBER(ATTRIBUTE2) - 1                 AS MERGE_VAL
                                    , TO_NUMBER(ATTRIBUTE4)                     AS MAX_DAYS
                                    , CASE WHEN RTRIM(ATTRIBUTE5) IS NULL THEN CPA.FULL_CAPA * TO_NUMBER(ATTRIBUTE2) ELSE CAST(ATTRIBUTE5 AS NUMBER(20, 10)) * TO_NUMBER(ATTRIBUTE2) END   AS FULL_CAPA
                                    , CASE WHEN RTRIM(ATTRIBUTE5) IS NULL THEN CPA.FULL_CAPA ELSE CAST(ATTRIBUTE5 AS NUMBER(20, 10)) END AS DAILY_CAPA
                            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D
                                  , (
                                    /* SELECT    ATTRIBUTE2    AS ITEM_ID */
                                    /*         -- , SEGMENT4      AS SITE_ID */
                                    /*         , 86400/CONVERT(FLOAT, MAX(ATTRIBUTE4)) AS FULL_CAPA */
                                    /* FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK WITH(NOLOCK) */
                                    /* WHERE   LK.LOOKUP_TYPE  = 'SCP_OPT_MASTER_CAPA_TEMP' */
                                    /* AND     LK.VALID_YN     = 'Y' */
                                    /* AND     LK.SEGMENT2     = @V_DIVISION_ID */
                                    /* GROUP BY  ATTRIBUTE2 */
                                            /*  , SEGMENT4 */

                                    /*  2025.10.21 Minyong Lee : Lookup -> UI Table 전환 */
                                    SELECT  CP.ITEM_ID          AS ITEM_ID
                                          , MIN(CP.CAPA * (NVL(CP.PRDN_OPER_RT, 100) / 100)) AS FULL_CAPA /*  ITEM 별 최소 FULL_CAPA */
                                    FROM    SCP_OPMZ_DDLY_CAPA CP
                                    WHERE   1=1
                                    AND     CP.VALID_YN = 'Y'
                                    AND     CP.DIVISION_ID = V_DIVISION_ID
                                    GROUP BY CP.ITEM_ID
                                    ) CPA
                            /*  AND D.SEGMENT4 = CPA.SITE_ID  -- 전극이랑 조립 사이트로 불일치해서 주석. */
                            WHERE   D.SEGMENT7 = CPA.ITEM_ID
                            AND     D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                            AND     D.VALID_YN      = 'Y'
                            AND     D.ATTRIBUTE1    = 'C'
                            AND     D.SEGMENT2      = V_DIVISION_ID
                            AND     D.SEGMENT3      = V_GROUP_ID
                            ) LK
                WHERE 1=1
                AND S.DUE_DATE  = CM.BASIS_YYYYMMDD
                AND LK.SITE_ID  = S.ATTRIBUTE1
                AND LK.ITEM_ID  = S.ATTRIBUTE2
                AND LK.STAGE    = S.ATTRIBUTE3
                AND S.PLAN_ID       = V_PLAN_ID
                AND S.ATTRIBUTE15   = 'C'
                AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD
                ;

                DBMS_OUTPUT.PUT_LINE('9.1 Temp End. Recursive Start: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));

                INSERT INTO SCP_OPT_ENG_DEMAND_SN
                    (PLAN_ID
                    ,DEMAND_ID
                    ,BUFFER_ID
                    ,DEMAND_GROUP
                    ,DUE_DATE
                    ,TARGET_DATE
                    ,SALES_CUTOFF_DATE
                    ,EXPIRY_DATE
                    ,PRIORITY
                    ,QUANTITY
                    ,PRIORITY_GROUP
                    ,CUSTOMER_ID
                    ,ALLOW_SHORT
                    ,ATTRIBUTE1
                    ,ATTRIBUTE2
                    ,ATTRIBUTE3
                    ,ATTRIBUTE4
                    ,ATTRIBUTE5
                    ,ATTRIBUTE6
                    ,ATTRIBUTE7
                    ,ATTRIBUTE8
                    ,ATTRIBUTE9
                    ,ATTRIBUTE10
                    ,ATTRIBUTE11
                    ,ATTRIBUTE12
                    ,ATTRIBUTE13
                    ,ATTRIBUTE14
                    ,ATTRIBUTE15
                    )

                WITH RECURSIVE_DEMAND (GROUP_START_DATE, GROUP_NO, CUM_QTY, DEMAND_DATE, R_NUM, MERGE_VAL, MAX_DAYS
                                     , PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                                     , PRIORITY, QTY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                                     , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10
                                     , ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, FULL_CAPA, DAILY_CAPA) AS (
                            SELECT    DM.DEMAND_DATE    AS GROUP_START_DATE
                                    , 1                 AS GROUP_NO
                                    , CAST(DM.QTY AS NUMBER(30, 10))            AS CUM_QTY
                                    , DM.DEMAND_DATE    AS DEMAND_DATE
                                    , DM.R_NUM
                                    , DM.MERGE_VAL
                                    , CAST(DM.MAX_DAYS AS NUMBER(18,0)) MAX_DAYS
                                    , DM.PLAN_ID
                                    , DM.DEMAND_ID
                                    , DM.BUFFER_ID
                                    , DM.DEMAND_GROUP
                                    , DM.DUE_DATE
                                    , DM.TARGET_DATE
                                    , DM.SALES_CUTOFF_DATE
                                    , DM.EXPIRY_DATE
                                    , DM.PRIORITY
                                    , CAST(DM.QTY AS NUMBER(30, 10)) AS QTY
                                    , DM.PRIORITY_GROUP
                                    , DM.CUSTOMER_ID
                                    , DM.ALLOW_SHORT
                                    , DM.ATTRIBUTE1
                                    , DM.ATTRIBUTE2
                                    , DM.ATTRIBUTE3
                                    , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                    , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                                    , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                                    , DM.FULL_CAPA  AS FULL_CAPA
                                    , DM.DAILY_CAPA AS DAILY_CAPA
                            FROM    GT_OPT_DIV_DM_TYPE_C DM
                            WHERE   DM.R_NUM = 1
                            UNION ALL
                            SELECT    CASE  WHEN CAST(PREV.CUM_QTY + DM.QTY AS NUMBER(30, 10)) > DM.FULL_CAPA THEN DM.DEMAND_DATE
                                            WHEN (DM.DEMAND_DATE - PREV.GROUP_START_DATE) > DM.MAX_DAYS THEN DM.DEMAND_DATE
                                            WHEN (DM.DEMAND_DATE - PREV.DEMAND_DATE)     > DM.MAX_DAYS  THEN DM.DEMAND_DATE
                                            ELSE PREV.GROUP_START_DATE
                                            END AS GROUP_START_DATE
                                    , CASE  WHEN CAST(PREV.CUM_QTY + DM.QTY AS NUMBER(30, 10)) > DM.FULL_CAPA THEN PREV.GROUP_NO + 1
                                            WHEN (DM.DEMAND_DATE - PREV.GROUP_START_DATE) > DM.MAX_DAYS THEN PREV.GROUP_NO + 1
                                            WHEN (DM.DEMAND_DATE - PREV.DEMAND_DATE) > DM.MAX_DAYS THEN PREV.GROUP_NO + 1
                                            ELSE PREV.GROUP_NO
                                            END AS GROUP_NO
                                    /*  , CONVERT(NUMERIC(30, 10), 1) CUM_QTY */
                                    , CASE WHEN CAST(PREV.CUM_QTY + DM.QTY AS NUMBER(30, 10)) > DM.FULL_CAPA THEN CAST(DM.QTY AS NUMBER(30, 10))
                                            WHEN (DM.DEMAND_DATE - PREV.GROUP_START_DATE) > DM.MAX_DAYS THEN CAST(DM.QTY AS NUMBER(30, 10))
                                            WHEN (DM.DEMAND_DATE - PREV.DEMAND_DATE)     > DM.MAX_DAYS  THEN CAST(DM.QTY AS NUMBER(30, 10))
                                            ELSE CAST(PREV.CUM_QTY + DM.QTY AS NUMBER(30, 10))
                                            END AS CUM_QTY
                                    , DM.DEMAND_DATE
                                    , DM.R_NUM
                                    , DM.MERGE_VAL
                                    , DM.MAX_DAYS
                                    , DM.PLAN_ID
                                    , DM.DEMAND_ID
                                    , DM.BUFFER_ID
                                    , DM.DEMAND_GROUP
                                    , DM.DUE_DATE
                                    , DM.TARGET_DATE
                                    , DM.SALES_CUTOFF_DATE
                                    , DM.EXPIRY_DATE
                                    , DM.PRIORITY
                                    , DM.QTY
                                    , DM.PRIORITY_GROUP
                                    , DM.CUSTOMER_ID
                                    , DM.ALLOW_SHORT
                                    , DM.ATTRIBUTE1
                                    , DM.ATTRIBUTE2
                                    , DM.ATTRIBUTE3
                                    , DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                    , DM.ATTRIBUTE6, DM.ATTRIBUTE7, DM.ATTRIBUTE8, DM.ATTRIBUTE9, DM.ATTRIBUTE10
                                    , DM.ATTRIBUTE11, DM.ATTRIBUTE12, DM.ATTRIBUTE13, DM.ATTRIBUTE14, DM.ATTRIBUTE15
                                    , DM.FULL_CAPA  AS FULL_CAPA
                                    , DM.DAILY_CAPA AS DAILY_CAPA
                            FROM    GT_OPT_DIV_DM_TYPE_C DM
                            INNER JOIN RECURSIVE_DEMAND PREV
                                    ON DM.ATTRIBUTE1 = PREV.ATTRIBUTE1
                                    AND DM.ATTRIBUTE2 = PREV.ATTRIBUTE2
                                    AND DM.ATTRIBUTE3 = PREV.ATTRIBUTE3
                                    AND DM.R_NUM        = PREV.R_NUM + 1
                            WHERE   1=1
                            )
                    , RESULT_TEMP AS
                            (
                                SELECT    /* GROUP_NO
                                    , GROUP_START_DATE
                                    , CM.BASIS_YYYYMMDD AS PLAN_YYYYMMDD
                                    , MAX(CUM_QTY/(MERGE_VAL+1)) AS DAILY_QTY
                                    , MAX(MAX_DAYS) MAX_DAYS
                                    , MAX(MERGE_VAL) MERGE_VAL
                                    , MAX(FULL_CAPA) FULL_CAPA
                                    , MAX(CUM_QTY) CUM_QTY
                                    , MAX(FDM.DAILY_CAPA) DAILY_CAPA
                                    ,  */
                                    FDM.PLAN_ID                                   AS PLAN_ID
                                    , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID
                                    , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID
                                    , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP
                                    , MIN(FDM.GROUP_START_DATE)                     AS DUE_DATE
                                    , MIN(FDM.TARGET_DATE)                          AS TARGET_DATE
                                    , MIN(FDM.SALES_CUTOFF_DATE)                    AS SALES_CUTOFF_DATE
                                    , MIN(FDM.EXPIRY_DATE)                          AS EXPIRY_DATE
                                    , MIN(FDM.PRIORITY)                             AS PRIORITY
                                    /*  , MAX(CUM_QTY/(MERGE_VAL+1))                    AS QUANTITY */

                                    /*    MERGE_VAL 은 LOOKUP.ATTRIBUTE2(널 허용) 유래라 MAX 결과가 NULL 이 될 수 있다. */
                                    , MAX(FDM.CUM_QTY)/CASE WHEN FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA))+1 IS NULL THEN MAX((FDM.MERGE_VAL+1))
                                                            WHEN MAX((FDM.MERGE_VAL+1)) IS NULL                   THEN FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA))+1
                                                            ELSE LEAST(FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA))+1, MAX((FDM.MERGE_VAL+1)))
                                                       END                          AS QUANTITY
                                    , MIN(FDM.PRIORITY_GROUP)                       AS PRIORITY_GROUP
                                    , MIN(FDM.CUSTOMER_ID)                          AS CUSTOMER_ID
                                    , MIN(FDM.ALLOW_SHORT)                          AS ALLOW_SHORT
                                    , FDM.ATTRIBUTE1                                AS ATTRIBUTE1
                                    , FDM.ATTRIBUTE2                                AS ATTRIBUTE2
                                    , FDM.ATTRIBUTE3                                AS ATTRIBUTE3
                                    , MIN(FDM.ATTRIBUTE4)                           AS ATTRIBUTE4
                                    , MIN(FDM.ATTRIBUTE5)                           AS ATTRIBUTE5
                                    , MIN(FDM.ATTRIBUTE6)                           AS ATTRIBUTE6
                                    , MIN(FDM.ATTRIBUTE7)                           AS ATTRIBUTE7
                                    , MIN(FDM.ATTRIBUTE8)                           AS ATTRIBUTE8
                                    , MIN(FDM.ATTRIBUTE9)                           AS ATTRIBUTE9
                                    , MIN(FDM.ATTRIBUTE10)                          AS ATTRIBUTE10
                                    , MIN(FDM.ATTRIBUTE11)                          AS ATTRIBUTE11
                                    , MIN(FDM.ATTRIBUTE12)                          AS ATTRIBUTE12
                                    , MIN(FDM.ATTRIBUTE13)                          AS ATTRIBUTE13
                                    , MIN(FDM.ATTRIBUTE14)                          AS ATTRIBUTE14
                                    , MIN(FDM.ATTRIBUTE15)                          AS ATTRIBUTE15
                                    , FDM.GROUP_START_DATE                          AS GROUP_START_DATE
                                    /*  ★동일 사유의 LEAST NULL 가드. MERGE_VAL2 가 NULL 이면 뒤의 BETWEEN 이 UNKNOWN 이 되어 행이 소실된다. */
                                    , CASE WHEN FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA)) IS NULL THEN MAX((FDM.MERGE_VAL))
                                           WHEN MAX((FDM.MERGE_VAL)) IS NULL                   THEN FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA))
                                           ELSE LEAST(FLOOR(MAX(FDM.CUM_QTY/FDM.DAILY_CAPA)), MAX((FDM.MERGE_VAL)))
                                      END                                           AS MERGE_VAL2
                            FROM    RECURSIVE_DEMAND FDM
                            GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_NO, FDM.GROUP_START_DATE
                            )
                    SELECT    RT.PLAN_ID
                            /*  , RT.DEMAND_ID */
                            , REPLACE(RT.DEMAND_ID, TO_CHAR(RT.GROUP_START_DATE, 'YYYYMMDD'), CM.BASIS_YYYYMMDD) AS DEMAND_ID
                            , RT.BUFFER_ID
                            , RT.DEMAND_GROUP
                            , CM.BASIS_YYYYMMDD AS DUE_DATE
                            , RT.TARGET_DATE
                            , RT.SALES_CUTOFF_DATE
                            , RT.EXPIRY_DATE
                            , RT.PRIORITY
                            , RT.QUANTITY
                            , RT.PRIORITY_GROUP
                            , RT.CUSTOMER_ID
                            , RT.ALLOW_SHORT
                            , RT.ATTRIBUTE1
                            , RT.ATTRIBUTE2
                            , RT.ATTRIBUTE3
                            , RT.ATTRIBUTE4
                            , RT.ATTRIBUTE5
                            , RT.ATTRIBUTE6
                            , RT.ATTRIBUTE7
                            , RT.ATTRIBUTE8
                            , RT.ATTRIBUTE9
                            , RT.ATTRIBUTE10
                            , RT.ATTRIBUTE11
                            , RT.ATTRIBUTE12
                            , RT.ATTRIBUTE13
                            , RT.ATTRIBUTE14
                            , RT.ATTRIBUTE15
                    FROM    RESULT_TEMP RT
                          , SCM_SYS_CALENDAR_M CM
                    WHERE   TO_DATE(CM.BASIS_YYYYMMDD, 'YYYYMMDD') BETWEEN RT.GROUP_START_DATE AND RT.GROUP_START_DATE + RT.MERGE_VAL2

                    ;
        END IF;
        DBMS_OUTPUT.PUT_LINE('9.2 Demand Type C Recursive End: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));
        /* -------------------------------------------------------------------------- */
        /*  1.5 Demand Insert */
        /*  2026.03.09 Minyong Lee: D Type 추가. */
        /* -------------------------------------------------------------------------- */

    /*PRINT ('10. Demand Insert Type D: ' + CONVERT(NVARCHAR, CURRENT_TIMESTAMP, 113)); */

    /*SELECT @V_CNT = COUNT(*) */
    /*FROM   @DM_INS_TEMP S */
    /*WHERE 1=1 */
    /*AND S.PLAN_ID       = @V_PLAN_ID */
    /*AND S.ATTRIBUTE15   = 'D' */
    /*AND S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD */
    /*; */

    /*IF @V_CNT > 0 */
    /*    BEGIN */
    /*        IF OBJECT_ID('TEMPDB..#DEMAND_TYPE_D') IS NOT NULL */
    /*        BEGIN */
    /*            DROP TABLE  #DEMAND_TYPE_D; */
    /*        END; */

    /*        SELECT  CM.DAYOFWEEK */
    /*              , LK.DEMAND_MERGE_DAY */
    /*              , CONVERT(NVARCHAR(8), DBO.FN_NEXT_DAY(DATEADD(DD, -7, CM.BASIS_END_DATE), LK.DEMAND_MERGE_DAY), 112) AS GROUP_START_DATE -- 전주 일요일 기준으로 다음 타겟 요일 = 금주의 타겟 요일 */
    /*              , S.* */
    /*        INTO    #DEMAND_TYPE_D */
    /*        FROM    @DM_INS_TEMP S */
    /*            INNER JOIN SCM_SYS_CALENDAR_M CM WITH(NOLOCK) */
    /*                ON  S.DUE_DATE  = CM.BASIS_YYYYMMDD */
    /*            INNER JOIN ( */
    /*                        SELECT    SEGMENT2 AS DIVISION_ID */
    /*                                , SEGMENT3 AS PLAN_GROUP_ID */
    /*                                , SEGMENT4 AS SITE_ID */
    /*                                , SEGMENT5 AS STAGE */
    /*                                , SEGMENT6 AS LINE_ID */
    /*                                , SEGMENT7 AS ITEM_ID */
    /*                                , ATTRIBUTE1 AS DEMAND_MERGE_TYPE */
    /*                                , ATTRIBUTE2 AS DEMAND_MERGE_DAY */
    /*                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK) */
    /*                        WHERE   LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE' */
    /*                        AND     VALID_YN      = 'Y' */
    /*                        AND     SEGMENT2      = @V_DIVISION_ID */
    /*                        AND     SEGMENT3      = @V_GROUP_ID */
    /*                        AND     ATTRIBUTE1    = 'D' */
    /*                        ) LK */
    /*                ON  LK.SITE_ID  = S.ATTRIBUTE1 */
    /*                AND LK.ITEM_ID  = S.ATTRIBUTE2 */
    /*                AND LK.STAGE    = S.ATTRIBUTE3 */
    /*        WHERE   1=1 */
    /*        AND     S.PLAN_ID       = @V_PLAN_ID */
    /*        AND     S.ATTRIBUTE15   = 'D' */
    /*        AND     S.DUE_DATE     >= @V_PROD_FROZEN_END_YMD */

    /*        -- 묶음 Target 일자가 Frozen 구간 내인 경우, Frozen 이후 일자에 반영 */
    /*        UPDATE #DEMAND_TYPE_D */
    /*        SET GROUP_START_DATE = @V_PROD_FROZEN_END_YMD */
    /*        WHERE GROUP_START_DATE < @V_PROD_FROZEN_END_YMD */

    /*        INSERT INTO SCP_OPT_ENG_DEMAND_SN ( */
    /*             PLAN_ID */
    /*            ,DEMAND_ID */
    /*            ,BUFFER_ID */
    /*            ,DEMAND_GROUP */
    /*            ,DUE_DATE */
    /*            ,TARGET_DATE */
    /*            ,SALES_CUTOFF_DATE */
    /*            ,EXPIRY_DATE */
    /*            ,PRIORITY */
    /*            ,QUANTITY */
    /*            ,PRIORITY_GROUP */
    /*            ,CUSTOMER_ID */
    /*            ,ALLOW_SHORT */
    /*            ,ATTRIBUTE1 */
    /*            ,ATTRIBUTE2 */
    /*            ,ATTRIBUTE3 */
    /*            ,ATTRIBUTE4 */
    /*            ,ATTRIBUTE5 */
    /*            ,ATTRIBUTE6 */
    /*            ,ATTRIBUTE7 */
    /*            ,ATTRIBUTE8 */
    /*            ,ATTRIBUTE9 */
    /*            ,ATTRIBUTE10 */
    /*            ,ATTRIBUTE11 */
    /*            ,ATTRIBUTE12 */
    /*            ,ATTRIBUTE13 */
    /*            ,ATTRIBUTE14 */
    /*            ,ATTRIBUTE15 */
    /*        ) */
    /*        SELECT  FDM.PLAN_ID                                   AS PLAN_ID */
    /*              , MIN(FDM.DEMAND_ID)                            AS DEMAND_ID */
    /*              , MIN(FDM.BUFFER_ID)                            AS BUFFER_ID */
    /*              , MIN(FDM.DEMAND_GROUP)                         AS DEMAND_GROUP */
    /*              , GROUP_START_DATE                              AS DUE_DATE */
    /*              , MIN(FDM.TARGET_DATE)                          AS TARGET_DATE */
    /*              , MIN(FDM.SALES_CUTOFF_DATE)                    AS SALES_CUTOFF_DATE */
    /*              , MIN(FDM.EXPIRY_DATE)                          AS EXPIRY_DATE */
    /*              , MIN(FDM.PRIORITY)                             AS PRIORITY */
    /*              , ROUND(SUM(FDM.QUANTITY), 0)                   AS QUANTITY */
    /*              , MIN(FDM.PRIORITY_GROUP)                       AS PRIORITY_GROUP */
    /*              , MIN(FDM.CUSTOMER_ID)                          AS CUSTOMER_ID */
    /*              , MIN(FDM.ALLOW_SHORT)                          AS ALLOW_SHORT */
    /*              , FDM.ATTRIBUTE1                                AS ATTRIBUTE1 */
    /*              , FDM.ATTRIBUTE2                                AS ATTRIBUTE2 */
    /*              , FDM.ATTRIBUTE3                                AS ATTRIBUTE3 */
    /*              , MIN(FDM.ATTRIBUTE4)                           AS ATTRIBUTE4 */
    /*              , MIN(FDM.ATTRIBUTE5)                           AS ATTRIBUTE5 */
    /*              , MIN(FDM.ATTRIBUTE6)                           AS ATTRIBUTE6 */
    /*              , MIN(FDM.ATTRIBUTE7)                           AS ATTRIBUTE7 */
    /*              , MIN(FDM.ATTRIBUTE8)                           AS ATTRIBUTE8 */
    /*              , MIN(FDM.ATTRIBUTE9)                           AS ATTRIBUTE9 */
    /*              , MIN(FDM.ATTRIBUTE10)                          AS ATTRIBUTE10 */
    /*              , MIN(FDM.ATTRIBUTE11)                          AS ATTRIBUTE11 */
    /*              , MIN(FDM.ATTRIBUTE12)                          AS ATTRIBUTE12 */
    /*              , MIN(FDM.ATTRIBUTE13)                          AS ATTRIBUTE13 */
    /*              , MIN(FDM.ATTRIBUTE14)                          AS ATTRIBUTE14 */
    /*              , MIN(FDM.ATTRIBUTE15)                          AS ATTRIBUTE15 */
    /*        FROM    #DEMAND_TYPE_D FDM */
    /*        GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_START_DATE */
    /*    END */
        /* ---------------------------------------------------------------------- */
        /*  2. DEMAND GROUP */
        /* ---------------------------------------------------------------------- */
            /* ---------------------------------------------------------------------- */
            /*  2-1. DEMAND GROUP에 제품이 있고, 최소 하나 이상 등록된 SITE에 대해 모든 ITEM의 BUFFER를추가함 */
            /* ---------------------------------------------------------------------- */
        /*  MSSQL 결합 연산자는 NULL 을 전파하고 뒤의 DEMAND_ID IS NOT NULL 필터가 그 성질에 의존한다. */
        /*  SCM_SITE_ID / INCOTERMS / PROJECT_CODE 는 SCP_OPT_ENG_DEMAND_SN 아우터조인 유래라 NULL 가능하므로 */

        INSERT INTO SCP_OPT_ENG_DEMAND_SN (PLAN_ID,DEMAND_ID,BUFFER_ID,ATTRIBUTE13,ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE3,ATTRIBUTE4,ATTRIBUTE5)
        SELECT PLAN_ID
              ,DEMAND_ID
              ,BUFFER_ID
              ,ATTRIBUTE13
              ,SCM_SITE_ID
              ,ITEM_ID
              ,STAGE
              ,INCOTERMS
              ,PROJECT_CODE
        FROM(
            SELECT V_PLAN_ID                                                                                            AS PLAN_ID
                   ,CASE WHEN DG.SCM_SITE_ID IS NULL OR DG.ITEM_ID IS NULL OR DG.STAGE IS NULL
                              OR DG.INCOTERMS IS NULL OR DG.PROJECT_CODE IS NULL THEN NULL
                         ELSE 'DUMMY'||'::'||DG.SCM_SITE_ID||'::'||DG.ITEM_ID||'::'||DG.STAGE||'@'||DG.INCOTERMS||'@'||DG.PROJECT_CODE
                    END                                                                                                 AS DEMAND_ID
                   ,CASE WHEN DG.SCM_SITE_ID IS NULL OR DG.ITEM_ID IS NULL OR DG.STAGE IS NULL
                              OR DG.INCOTERMS IS NULL OR DG.PROJECT_CODE IS NULL THEN NULL
                         ELSE DG.SCM_SITE_ID||'::'||DG.ITEM_ID||'::'||DG.STAGE||'@'||DG.INCOTERMS||'@'||DG.PROJECT_CODE
                    END                                                                                                 AS BUFFER_ID
                   ,'GROUP_DEMAND'                                                                                      AS ATTRIBUTE13 /*  추후에 삭제를 위해 */
                   ,DG.SCM_SITE_ID                                                                                      AS SCM_SITE_ID
                   ,DG.ITEM_ID                                                                                          AS ITEM_ID
                   ,DG.STAGE                                                                                            AS STAGE
                   ,DG.INCOTERMS                                                                                        AS INCOTERMS
                   ,DG.PROJECT_CODE                                                                                     AS PROJECT_CODE
            FROM(
                SELECT  DG.DEMAND_GROUP                                        AS DEMAND_GROUP
                       ,DG.SCM_SITE_ID                                         AS SCM_SITE_ID
                       ,DG.INCOTERMS                                           AS INCOTERMS
                       ,LU.SEGMENT3                                            AS ITEM_ID
                       ,CASE    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'        THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'        THEN 'MDLEBIZ'
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') THEN 'SUBMDLEBIZ'
                                WHEN B.OPERATION_GROUP = 'A'    THEN 'CELLBIZ'
                        ELSE '-' END                                           AS STAGE
                      ,DG.PROJECT_CODE                                         AS PROJECT_CODE
                FROM(
                    SELECT  LU.SEGMENT4   AS DEMAND_GROUP
                           ,DM.ATTRIBUTE1 AS SCM_SITE_ID
                           ,DM.ATTRIBUTE4 AS INCOTERMS
                           ,DM.ATTRIBUTE5 AS PROJECT_CODE
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU
                        LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM
                        ON  DM.PLAN_ID = V_PLAN_ID
                        AND DM.ATTRIBUTE2 = LU.SEGMENT3
                        AND DM.ATTRIBUTE5 = LU.SEGMENT5
                    WHERE   1=2 /*  2026-03-10, 제약제거 */
                    AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                    AND     LU.VALID_YN = 'Y'
                    AND     LU.SEGMENT2 = V_DIVISION_ID
                    GROUP BY DM.ATTRIBUTE1, LU.SEGMENT4, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                    ) DG
                        INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU
                        ON  1=2 /*  2026-03-10, 제약제거 */
                        AND DG.DEMAND_GROUP = LU.SEGMENT4
                        AND LU.VALID_YN     = 'Y'
                        AND DG.PROJECT_CODE = LU.SEGMENT5 /* PROJECT추가 */
                        AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                        AND LU.SEGMENT2 = V_DIVISION_ID
                        INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                    FROM   SCP_MST_FINAL_ITEM
                                    WHERE  DIVISION_ID = V_DIVISION_ID
                                    AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      /*  소형은 CEll Biz 용 Demand 만 처리 */
                                       OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                          )
                                   ) B
                        ON    LU.SEGMENT3   = B.ITEM_ID
                        AND   V_DIVISION_ID = B.DIVISION_ID
            )DG
        ) A
        WHERE DEMAND_ID IS NOT NULL;

            /* ---------------------------------------------------------------------- */
            /*  2-2. 기존 DEMAND GROUP에 속한 DEMAND를 TEMP TABLE에 넣음 */
            /* ---------------------------------------------------------------------- */
            INSERT INTO GT_OPT_DIV_DM_DMTMP
                 ( PLAN_ID
                 , DEMAND_ID
                 , BUFFER_ID
                 , DEMAND_GROUP
                 , DUE_DATE
                 , TARGET_DATE
                 , SALES_CUTOFF_DATE
                 , EXPIRY_DATE
                 , PRIORITY
                 , QUANTITY
                 , PRIORITY_GROUP
                 , CUSTOMER_ID
                 , ALLOW_SHORT
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
                 , ATTRIBUTE11
                 , ATTRIBUTE12
                 , ATTRIBUTE13
                 , ATTRIBUTE14
                 , ATTRIBUTE15
                 , GROUP_ID
                 )
            SELECT  DM.PLAN_ID
                   ,DM.DEMAND_ID
                   ,DM.BUFFER_ID
                   ,DM.DEMAND_GROUP
                   ,DM.DUE_DATE
                   ,DM.TARGET_DATE
                   ,DM.SALES_CUTOFF_DATE
                   ,DM.EXPIRY_DATE
                   ,DM.PRIORITY
                   ,DM.QUANTITY
                   ,DM.PRIORITY_GROUP
                   ,DM.CUSTOMER_ID
                   ,DM.ALLOW_SHORT
                   ,DM.ATTRIBUTE1
                   ,DM.ATTRIBUTE2
                   ,DM.ATTRIBUTE3
                   ,DM.ATTRIBUTE4
                   ,DM.ATTRIBUTE5
                   ,DM.ATTRIBUTE6
                   ,DM.ATTRIBUTE7
                   ,DM.ATTRIBUTE8
                   ,DM.ATTRIBUTE9
                   ,DM.ATTRIBUTE10
                   ,DM.ATTRIBUTE11
                   ,DM.ATTRIBUTE12
                   ,DM.ATTRIBUTE13
                   ,DM.ATTRIBUTE14
                   ,DM.ATTRIBUTE15
                   ,LU.SEGMENT4
            FROM    SCP_OPT_ENG_DEMAND_SN DM
                INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                ON  DM.PLAN_ID = V_PLAN_ID
                AND DM.ATTRIBUTE2 = LU.SEGMENT3
                AND DM.ATTRIBUTE5 = LU.SEGMENT5
            WHERE   1=2 /*  2026-03-10, 제약제거 */
            AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
            AND     LU.VALID_YN = 'Y'
            AND     LU.SEGMENT2 = V_DIVISION_ID
            ;
            /* ---------------------------------------------------------------------- */
            /*  2-3. 기존 DEMAND GROUP에 속한 DEMAND위 키중복 방지와 추후 삭제를 위한 UPDATE */
            /*       원본 UPDATE .. FROM JOIN -> SET 값이 조인대상에 의존하지 않으므로 상관 UPDATE + EXISTS 로 변환 */

            /* ---------------------------------------------------------------------- */
            UPDATE SCP_OPT_ENG_DEMAND_SN DT
               SET DT.DEMAND_ID = 'D_'||DT.DEMAND_ID
                 , DT.ATTRIBUTE13 = 'GROUP_DEMAND'
            WHERE EXISTS (SELECT 1
                          FROM   GT_OPT_DIV_DM_DMTMP TMP
                          WHERE  TMP.PLAN_ID   = DT.PLAN_ID
                          AND    TMP.DEMAND_ID = DT.DEMAND_ID);
            /* ---------------------------------------------------------------------- */
            /*  2-4. 추가로 만든 GROUP에 대한 DEMAND INSERT */
            /* ---------------------------------------------------------------------- */
            INSERT INTO SCP_OPT_ENG_DEMAND_SN(
                   PLAN_ID
                  ,DEMAND_ID
                  ,BUFFER_ID
                  ,DEMAND_GROUP
                  ,DUE_DATE
                  ,TARGET_DATE
                  ,SALES_CUTOFF_DATE
                  ,EXPIRY_DATE
                  ,PRIORITY
                  ,QUANTITY
                  ,PRIORITY_GROUP
                  ,CUSTOMER_ID
                  ,ALLOW_SHORT
                  ,ATTRIBUTE1
                  ,ATTRIBUTE2
                  ,ATTRIBUTE3
                  ,ATTRIBUTE4
                  ,ATTRIBUTE5
                  ,ATTRIBUTE6
                  ,ATTRIBUTE7
                  ,ATTRIBUTE8
                  ,ATTRIBUTE9
                  ,ATTRIBUTE10
                  ,ATTRIBUTE11
                  ,ATTRIBUTE12
                  ,ATTRIBUTE13
                  ,ATTRIBUTE14
                  ,ATTRIBUTE15
                  )
            /*  BUFFER_ID 구성요소(ATTRIBUTE1/GROUP_ID/ATTRIBUTE3/4/5)는 모두 널 허용이라 */

            SELECT T.PLAN_ID             AS PLAN_ID
                  ,T.DEMAND_ID           AS DEMAND_ID
                  ,CASE WHEN T.ATTRIBUTE1 IS NULL OR T.GROUP_ID IS NULL OR T.ATTRIBUTE3 IS NULL
                             OR T.ATTRIBUTE4 IS NULL OR T.ATTRIBUTE5 IS NULL THEN NULL
                        ELSE T.ATTRIBUTE1||'::'||T.GROUP_ID||'::'||T.ATTRIBUTE3||'@'||T.ATTRIBUTE4||'@'||T.ATTRIBUTE5
                   END                   AS BUFFER_ID/*  INCOTERMS 제외 */
                  ,T.DEMAND_GROUP        AS DEMAND_GROUP
                  ,T.DUE_DATE            AS DUE_DATE
                  ,T.TARGET_DATE         AS TARGET_DATE
                  ,T.SALES_CUTOFF_DATE   AS SALES_CUTOFF_DATE
                  ,T.EXPIRY_DATE         AS EXPIRY_DATE
                  ,T.PRIORITY            AS PRIORITY
                  ,T.QUANTITY            AS QUANTITY
                  ,T.PRIORITY_GROUP      AS PRIORITY_GROUP
                  ,T.CUSTOMER_ID         AS CUSTOMER_ID
                  ,T.ALLOW_SHORT         AS ALLOW_SHORT
                  ,T.ATTRIBUTE1          AS ATTRIBUTE1
                  ,T.GROUP_ID            AS ATTRIBUTE2
                  ,T.ATTRIBUTE3          AS ATTRIBUTE3
                  ,T.ATTRIBUTE4          AS ATTRIBUTE4
                  ,T.ATTRIBUTE5          AS ATTRIBUTE5
                  ,T.ATTRIBUTE6          AS ATTRIBUTE6
                  ,T.ATTRIBUTE7          AS ATTRIBUTE7
                  ,T.ATTRIBUTE8          AS ATTRIBUTE8
                  ,T.ATTRIBUTE9          AS ATTRIBUTE9
                  ,T.ATTRIBUTE10         AS ATTRIBUTE10
                  ,T.ATTRIBUTE11         AS ATTRIBUTE11
                  ,'DEMAND_GROUP'        AS ATTRIBUTE12
                  ,T.ATTRIBUTE13         AS ATTRIBUTE13
                  ,T.ATTRIBUTE14         AS ATTRIBUTE14
                  ,T.ATTRIBUTE15         AS ATTRIBUTE15
            FROM GT_OPT_DIV_DM_DMTMP T;
        /* ---------------------------------------------------------------------- */
        /*  2. DEMAND Target Date Update */
        /*      2025.03.24 Bloack Target Date & Add Monlty Block for Speed */
        /*  2025.07.24 Philsu Park: DemandTargetDate LOOKUP 관리형태를 YMD 로 변경. */
        /*    원본 UPDATE .. FROM JOIN -> Oracle 미지원이라 MERGE 로 변환. */
        /*    한 DEMAND_ID 가 TG(사이트/아이템/구간/타입) 다중행과 매칭될 수 있어 MSSQL 은 임의 1건(비결정)이다. */
        /*    Oracle MERGE 는 다중매치 시 ORA-30926 이므로 USING 을 DEMAND_ID 단위로 유일화(MAX)한다. */
        /*    LU.ATTRIBUTE1 = '' 는 Oracle 에서 항상 UNKNOWN(死코드)이 되므로 RTRIM(..) IS NULL 로 변환한다. */
        /* ---------------------------------------------------------------------- */

        MERGE INTO SCP_OPT_ENG_DEMAND_SN D
        USING (
                SELECT DEMAND_ID, MAX(TARGET_DATE) AS TARGET_DATE
                FROM (
                    SELECT DM.DEMAND_ID
                          /* ,CASE WHEN TG.TYPE = 'MONTH' THEN CAL.LAST_MM_DAY */
                          /*       WHEN TG.TYPE = 'WEEK'  THEN CAL.LAST_WW_DAY */
                          /*  END AS TARGET_DATE */
                          ,CASE WHEN DM.DEMAND_GROUP = 'SF' THEN NULL
                                WHEN TG.TYPE = 'MONTH' THEN CASE WHEN CAL.LAST_MM_DAY>V_PLAN_END_YYYYMMDD_ORI THEN V_PLAN_END_YYYYMMDD_ORI ELSE CAL.LAST_MM_DAY END
                                WHEN TG.TYPE = 'WEEK'  THEN CASE WHEN CAL.LAST_WW_DAY>V_PLAN_END_YYYYMMDD_ORI THEN V_PLAN_END_YYYYMMDD_ORI ELSE CAL.LAST_WW_DAY END
                           END AS TARGET_DATE
                    FROM SCP_OPT_ENG_DEMAND_SN DM
                       , (
                                SELECT SITE_ID
                                      ,ITEM_ID
                                      ,FROM_YMD
                                      ,TO_YMD
                                      ,TYPE
                                FROM(
                                    SELECT LU.SEGMENT3   AS SITE_ID
                                          ,LU.SEGMENT4   AS ITEM_ID
                                          ,CASE WHEN RTRIM(LU.ATTRIBUTE1) IS NULL THEN V_PLAN_START_YYYYMMDD ELSE LU.ATTRIBUTE1 END AS FROM_YMD
                                          ,CASE WHEN RTRIM(LU.ATTRIBUTE2) IS NULL THEN V_PLAN_END_YYYYMMDD_ORI ELSE LU.ATTRIBUTE2 END AS TO_YMD
                                          ,LU.SEGMENT5   AS TYPE

                                    FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                        LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2
                                            ON  1=2 /*  2026-03-10, 제약제거 */
                                            AND LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                            AND LU.SEGMENT1 = LU2.SEGMENT2
                                            AND LU.SEGMENT4 = LU2.SEGMENT3
                                            AND LU2.VALID_YN ='Y'
                                    WHERE 1=1
                                    AND   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
                                    AND   LU.SEGMENT1 = V_DIVISION_ID
                                    AND   LU.SEGMENT2 = V_GROUP_ID
                                    AND   LU.VALID_YN  ='Y'
                                    UNION ALL
                                    SELECT LU.SEGMENT3   AS SITE_ID
                                          ,LU2.SEGMENT4  AS ITEM_ID
                                          ,CASE WHEN RTRIM(LU.ATTRIBUTE1) IS NULL THEN V_PLAN_START_YYYYMMDD ELSE LU.ATTRIBUTE1 END AS FROM_YMD
                                          ,CASE WHEN RTRIM(LU.ATTRIBUTE2) IS NULL THEN V_PLAN_END_YYYYMMDD_ORI ELSE LU.ATTRIBUTE2 END AS TO_YMD
                                          ,LU.SEGMENT5   AS TYPE
                                    FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                        LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2
                                            ON  1=2 /*  2026-03-10, 제약제거 */
                                            AND LU2.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                            AND LU.SEGMENT1 = LU2.SEGMENT2
                                            AND LU.SEGMENT4 = LU2.SEGMENT3
                                            AND LU2.VALID_YN ='Y'
                                    WHERE 1=1
                                    AND   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
                                    AND   LU.SEGMENT1 = V_DIVISION_ID
                                    AND   LU.SEGMENT2 = V_GROUP_ID
                                    AND   LU.VALID_YN  ='Y'
                                    ) TG
                                WHERE SITE_ID IS NOT NULL
                                GROUP BY SITE_ID, ITEM_ID, FROM_YMD, TO_YMD, TYPE
                                ) TG
                       , (
                                /*  BASIS_YYYYMM 결합 후 날짜변환은 MSSQL 에서 NULL 전파이므로 CASE 로 재현한다(Oracle 은 ORA-01840). */
                                SELECT   CAL.BASIS_YYYYMMDD
                                        ,CASE WHEN TO_NUMBER(CAL.ISO_WEEK) - V_START_WEEK <0 THEN TO_NUMBER(CAL.ISO_WEEK)+52 - V_START_WEEK
                                         ELSE TO_NUMBER(CAL.ISO_WEEK) - V_START_WEEK
                                         END                                                                         AS PLAN_WEEK
                                        ,CAL.BASIS_END_DATE                                                          AS LAST_WW_DAY
                                        ,CASE WHEN CAL.BASIS_YYYYMM IS NULL THEN NULL
                                              ELSE TO_CHAR(ADD_MONTHS(TO_DATE(CAL.BASIS_YYYYMM||'01', 'YYYYMMDD'), 1) - 1, 'YYYYMMDD')
                                         END                                                                         AS LAST_MM_DAY
                                FROM    SCM_SYS_CALENDAR_M CAL
                                WHERE   CAL.BASIS_YYYYMMDD >= V_PLAN_START_YYYYMMDD
                                AND     CAL.BASIS_YYYYMMDD <=  V_PLAN_END_YYYYMMDD_ORI
                                ) CAL
                    WHERE   DM.PLAN_ID = V_PLAN_ID
                    AND     DM.ATTRIBUTE1 = TG.SITE_ID
                    AND     DM.ATTRIBUTE2 = TG.ITEM_ID
                    AND     DM.DUE_DATE = CAL.BASIS_YYYYMMDD
                    AND     CAL.BASIS_YYYYMMDD BETWEEN TG.FROM_YMD AND TG.TO_YMD
                    )
                GROUP BY DEMAND_ID
              ) TD
        ON  (   D.PLAN_ID   = V_PLAN_ID
            AND D.DEMAND_ID = TD.DEMAND_ID
            )
        WHEN MATCHED THEN UPDATE SET D.TARGET_DATE = TD.TARGET_DATE;


        /* ---------------------------------------------------------------------- */
        /*  Data Insert End */
        /* ---------------------------------------------------------------------- */


        /* ---------------------------------------------------------------------- */
        /*  Data Delete */
        /*  2025.08.12 Philsu Park: Workbench에서 0으로 들어온 케이스 제외. */
        /* ---------------------------------------------------------------------- */
        DELETE
        FROM    SCP_OPT_ENG_DEMAND_SN DT
        WHERE   DT.PLAN_ID  = V_PLAN_ID
        AND     DT.QUANTITY = 0
        ;

        COMMIT;

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

    ------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
    END IF;
    ------------------------------------------------------------------------
END;