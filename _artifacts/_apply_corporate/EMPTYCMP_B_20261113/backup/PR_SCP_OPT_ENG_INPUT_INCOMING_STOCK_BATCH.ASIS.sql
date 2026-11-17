CREATE OR REPLACE PROCEDURE         PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH
(
    P_PLAN_ID               IN VARCHAR2
  , P_DIVISION_ID           IN VARCHAR2
  , P_GROUP_ID              IN VARCHAR2
  , P_PLAN_START_YYYYMMDD   IN VARCHAR2
  , P_PLAN_END_YYYYMMDD     IN VARCHAR2
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH
 * Description  : SCP 최적화 엔진 입력용 입고 재고(Incoming Stock) 데이터를 생성한다.
 *                - 창고 재고(WH) / 활성화 재고(FOR) / 해상 재고(INT) / 자재 입고 예정 정보를 모아
 *                  SCP_OPT_ENG_INCOMING_STOCK 테이블에 적재한다.
 *                - 소형(40) 사업부는 Cell Biz 대상만 처리하고, INCOTERMS / Project Code 보정과
 *                  2nd OCV 재고 계산, 법인간 이동 재고 재구성을 함께 수행한다.
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.02.05     Y.S.H       Initial Release
 * 2026.10.07     JCH         MSSQL -> Oracle 전환
 * 2026.10.20     JCH         해상재고(INT) 적재 성능 힌트(NO_MERGE·NO_PUSH_PRED) — 뷰 조건 밀어넣기(JPPD)로 1,204초가 되던 계획 고정, 로직 불변
 */
    V_PROGRAM_NAME         VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_INPUT_INCOMING_STOCK_BATCH';
    V_PLAN_ID              VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_DIVISION_ID          VARCHAR2(20 CHAR)  := P_DIVISION_ID;
    V_GROUP_ID             VARCHAR2(20 CHAR)  := P_GROUP_ID;
    V_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)   := P_PLAN_START_YYYYMMDD;
    V_PLAN_END_YYYYMMDD    VARCHAR2(8 CHAR)   := P_PLAN_END_YYYYMMDD;
    V_MESSAGE_TEXT         VARCHAR2(1000 CHAR);
    V_DETAIL_DATE          DATE;

    /* 업무용 변수 */
    V_PLAN_NAME            VARCHAR2(8 CHAR);
    V_D_PLAN_NAME          DATE;
    V_PLAN_TYPE            VARCHAR2(4000 CHAR);
    V_SEQ                  VARCHAR2(4000 CHAR);
    V_MODELING_ID          VARCHAR2(4000 CHAR);
    V_CUTOFF_DAY           VARCHAR2(8 CHAR);
    V_D_CUTOFF_DAY         DATE;
    V_DEMAND_CUTOFF_DAY    VARCHAR2(8 CHAR);
    V_MAX_TUESDAY          VARCHAR2(8 CHAR);
    V_FP_INV_CUTOFF_DATE   VARCHAR2(8 CHAR);

    /* 2nd OCV 재고 계산 루프 변수 (1ST OCV) */
    V_1ST_PREV_CHILD         VARCHAR2(50 CHAR) := NULL;
    V_1ST_CUM_FAIL_RATIO     NUMBER := 1;
    V_1ST_CUM_LT             NUMBER := 0;
    V_1ST_ROW_NUM            NUMBER := 1;
    V_1ST_MAX_ROW_NUM        NUMBER;
    V_1ST_SCM_SITE_ID        VARCHAR2(50 CHAR);
    V_1ST_PLANT_ID           VARCHAR2(50 CHAR);
    V_1ST_ORI_ITEM_ID        VARCHAR2(50 CHAR);
    V_1ST_CHILD_ITEM_ID      VARCHAR2(50 CHAR);
    V_1ST_STAGE              VARCHAR2(20 CHAR);
    V_1ST_LT                 NUMBER(20,0);
    V_1ST_YIELD              NUMBER(20,10);
    V_1ST_FAIL_RATIO         NUMBER(20,10);
    V_1ST_OCV_NUMBER         VARCHAR2(20 CHAR);
    V_1ST_SECOND_OCV_TIME    VARCHAR2(20 CHAR);
    V_1ST_CUR_CUM_FAIL_RATIO NUMBER;
    V_1ST_FINAL_VALUE        NUMBER;

    /* 2nd OCV 재고 계산 루프 변수 (2ND OCV) */
    V_2ND_PREV_CHILD         VARCHAR2(50 CHAR) := NULL;
    V_2ND_CUM_FAIL_RATIO     NUMBER := 1;
    V_2ND_CUM_LT             NUMBER := 0;
    V_2ND_ROW_NUM            NUMBER := 1;
    V_2ND_MAX_ROW_NUM        NUMBER;
    V_2ND_SCM_SITE_ID        VARCHAR2(50 CHAR);
    V_2ND_PLANT_ID           VARCHAR2(50 CHAR);
    V_2ND_ORI_ITEM_ID        VARCHAR2(50 CHAR);
    V_2ND_CHILD_ITEM_ID      VARCHAR2(50 CHAR);
    V_2ND_STAGE              VARCHAR2(20 CHAR);
    V_2ND_LT                 NUMBER(20,0);
    V_2ND_YIELD              NUMBER(20,10);
    V_2ND_FAIL_RATIO         NUMBER(20,10);
    V_2ND_OCV_NUMBER         VARCHAR2(20 CHAR);
    V_2ND_SECOND_OCV_TIME    VARCHAR2(20 CHAR);
    V_2ND_CUR_CUM_FAIL_RATIO NUMBER;
    V_2ND_FINAL_VALUE        NUMBER;
    V_2ND_INS_NUM            NUMBER;
    V_2ND_MAX_INS_NUM        NUMBER;
    V_2ND_SUB_ROW_NUM        NUMBER;
BEGIN

    /* 시작 로그 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    BEGIN

        /* GTT 초기화 (TRUNCATE 대신 DELETE 로 비운다) */
        DELETE FROM GT_INCS_MAT_CONST;
        DELETE FROM GT_INCS_DM;
        DELETE FROM GT_INCS_OCV_EXCEPT;
        DELETE FROM GT_INCS_CELL_PROD;
        DELETE FROM GT_INCS_INC;
        DELETE FROM GT_INCS_INC_DEL;
        DELETE FROM GT_INCS_OCV_ALL_SUB;
        DELETE FROM GT_INCS_OCV_2ND_SUB;
        DELETE FROM GT_INCS_OCV_INV_MST;
        DELETE FROM GT_INCS_OCV_INV;
        DELETE FROM GT_INCS_SCP_INV;
        DELETE FROM GT_INCS_SCP_INT;
        DELETE FROM GT_INCS_CP_INFO;
        DELETE FROM GT_INCS_DEMAND_GROUP;
        DELETE FROM GT_INCS_COMPANY_INT;

        ------------------------------------------------------------------------
        -- Get Param Info
        ------------------------------------------------------------------------
        SELECT  MAX(ATTRIBUTE1)
              , MAX(ATTRIBUTE2)
          INTO  V_DIVISION_ID
              , V_GROUP_ID
          FROM  SCP_OPT_ENG_PLAN_MASTER_SN
         WHERE  PLAN_ID = V_PLAN_ID;
        ------------------------------------------------------------------------
        SELECT  MAX(BASIS_YYYYMMDD)
          INTO  V_MAX_TUESDAY
          FROM  SCM_SYS_CALENDAR_M
         WHERE  BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND  DAYOFWEEK = 'TUE';

        SELECT  MAX(MODELING_ID) INTO V_MODELING_ID FROM SCM_MST_MODELING WHERE PLAN_CYCLE = 'WEEKLY' AND DIVISION_ID = V_DIVISION_ID;

        V_PLAN_NAME   := V_PLAN_START_YYYYMMDD;                                             -- 당주 월요일 YYYYMMDD
        V_D_PLAN_NAME := TO_DATE(V_PLAN_NAME, 'YYYYMMDD');
        V_CUTOFF_DAY  := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'); -- 지난주 일요일 YYYYMMDD
        V_D_CUTOFF_DAY := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');
        -- V_DEMAND_CUTOFF_DAY := V_MAX_TUESDAY; -- 당주 화요일 YYYYMMDD
        SELECT  NVL(MAX(P.CUTOFF_YYYYMMDD), V_MAX_TUESDAY)
          INTO  V_DEMAND_CUTOFF_DAY
          FROM  DM_PLN_NET_DEMAND P
         WHERE  P.DIVISION_ID      = V_DIVISION_ID
           AND  P.CUTOFF_YYYYMMDD >= TO_CHAR(V_D_PLAN_NAME - 3, 'YYYYMMDD') -- 월요일 기준 최근 3일 이내
           AND  P.CUTOFF_YYYYMMDD <= TO_CHAR(V_D_PLAN_NAME + 6, 'YYYYMMDD'); -- 해당 주차 일요일 이전

        ------------------------------------------------------------------------
        -- 자재 제약 적용을 위한 변수 설정 (SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약)
        ------------------------------------------------------------------------
        INSERT INTO GT_INCS_MAT_CONST
        (
            MAT_ID
          , EFF_END_DATE
        )
        -- START 2025.11.19 jongykim2: Schelduled Reciept Information
        SELECT  LU.ITEM_ID_CHILD                                                       AS MAT_ID
              , TO_CHAR(TO_DATE(MAX(LU.TO_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD')       AS EFF_END_DATE
          FROM  SCP_OPMZ_VIRTUAL_BOM LU
         WHERE  LU.DIVISION_ID = V_DIVISION_ID
           AND  1 = 1 /* _BATCH T3: 계획그룹 필터 제거(사업부 전체) */
           AND  LU.VALID_YN    = 'Y'
         GROUP BY LU.ITEM_ID_CHILD;
        -- END 2025.11.19 jongykim2: Schelduled Reciept Information

        --------------------------------------------------------
        -- 1. 창고 재고 : WH
        --------------------------------------------------------
        -- 1.1 SALES 재고
        INSERT INTO GT_INCS_SCP_INV
        (
            DIVISION_ID
          , SCM_SITE_ID
          , INCOTERMS
          , STOCK_TYPE
          , ITEM_ID
          , AVAILABLE_DATE
          , QTY
          , WIPHOLD_YN
          , SITE_TYPE
          , LOCATION_CODE
          , PROJECT_CODE
          , CELL_PROD_SITE_ID
          , FLAG
        )
        SELECT  A.DIVISION_ID                                                                  AS DIVISION_ID
              , A.SCM_SITE_ID                                                                  AS SCM_SITE_ID
              , '-'                                                                            AS INCOTERMS -- 뒤에서 별도 UPDATE
              , A.STOCK_TYPE
              , A.ITEM_ID
              -- Plan Start 이전 일자는 Plan Start Date 로 입력 요청 (엔진 오류로 Plan 구간 안으로 처리)
              , CASE WHEN A.WIPHOLD_YN IS NULL                                     THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     WHEN A.WIPHOLD_YN = 'N'                                       THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME      THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     ELSE                                                               TRUNC(A.AVAILABLE_DATE)
                END                                                                            AS AVAILABLE_DATE
              , A.SCM_QTY                                                                      AS QTY -- SCP 사용 QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N' ELSE A.WIPHOLD_YN END                  AS WIPHOLD_YN
              , B.SITE_TYPE
              , '-'                                                                            AS LOCATION_CODE -- PLANT 재고 구분용 정보
              , '-'                                                                            AS PROJECT_CODE  -- 뒤에서 별도 UPDATE
              , NVL(MSP.SCM_SITE_ID, '')                                                       AS CELL_PROD_SITE_ID
              , 'SALES'                                                                        AS FLAG
          FROM  SCM_DNM_STOCK A
                -- 소형 생산지 구분을 위한 분리
                INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM SCM_MST_SITE
                             WHERE 1 = 1
                               AND SITE_TYPE = 'SALES'
                           ) B
                        ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
                LEFT OUTER JOIN GT_INCS_OCV_EXCEPT OCV
                        ON A.SCM_SITE_ID = OCV.SCM_SITE_ID
                       AND A.MES_ITEM_ID = OCV.ITEM_ID
                LEFT OUTER JOIN GT_INCS_CELL_PROD CPS
                        ON 1 = 1
                       AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
                       AND A.ITEM_ID     = CPS.ITEM_ID
                LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                   FROM SCM_MST_SITE
                                  WHERE 1 = 1
                                    AND PLANT_ID IS NOT NULL
                                ) MSP
                        ON 1 = 1
                       AND A.DIVISION_ID                   = MSP.DIVISION_ID
                       AND A.PLANT_ID || CPS.OPERATION_GROUP = MSP.SCM_SITE_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE = V_CUTOFF_DAY
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  OCV.ITEM_ID   IS NULL
           -- 소형은 Cell Biz 용 Demand 만 처리
           AND  ((A.DIVISION_ID = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                 OR (A.DIVISION_ID <> '40'))
           /* 대상 프로젝트 ITEM 필터링 */
--           AND  ((A.DIVISION_ID = '40' AND B.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
--                                                                            FROM SCP_OPT_ENG_MODEL_LIST_N_SN
--                                                                           WHERE PLAN_ID = V_PLAN_ID))
--                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
--                                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
--                                                              WHERE PLAN_ID = V_PLAN_ID)))
        ;

        -- 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE 의 재고로 처리
        INSERT INTO GT_INCS_SCP_INV
        (
            DIVISION_ID
          , SCM_SITE_ID
          , INCOTERMS
          , STOCK_TYPE
          , ITEM_ID
          , AVAILABLE_DATE
          , QTY
          , WIPHOLD_YN
          , SITE_TYPE
          , LOCATION_CODE
          , PROJECT_CODE
          , CELL_PROD_SITE_ID
          , FLAG
        )
        SELECT  A.DIVISION_ID                                                                  AS DIVISION_ID
              , A.TO_SCM_SITE_ID                                                               AS SCM_SITE_ID
              , '-'                                                                            AS INCOTERMS -- 뒤에서 별도 UPDATE
              , 'SO'                                                                           AS STOCK_TYPE
              , A.ITEM_ID                                                                      AS ITEM_ID
              -- Plan Start 이전 일자는 Plan Start Date 로 입력 요청 (엔진 오류로 Plan 구간 안으로 처리)
              , TO_DATE(V_PLAN_NAME, 'YYYYMMDD')                                               AS AVAILABLE_DATE
              , A.DELIVERY_QTY                                                                 AS QTY
              , 'N'                                                                            AS WIPHOLD_YN
              , B.SITE_TYPE
              , '-'                                                                            AS LOCATION_CODE -- PLANT 재고 구분용 정보
              , CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END              AS PROJECT_CODE -- 없는 건 '-' 처리, 있는건 그대로
              , CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END              AS CELL_PROD_SITE_ID
              , 'SALES'                                                                        AS FLAG
          FROM  SCM_DNM_INTRANSIT_C A
                INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM SCM_MST_SITE
                             WHERE 1 = 1
                               AND SITE_TYPE = 'SALES'
                           ) B
                        ON 1 = 1
                       AND A.DIVISION_ID    = B.DIVISION_ID
                       AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID
                LEFT OUTER JOIN GT_INCS_CELL_PROD CPS
                        ON 1 = 1
                       AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                       AND A.ITEM_ID        = CPS.ITEM_ID
         WHERE  1 = 1
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  A.RESULT_DATE = V_CUTOFF_DAY
           -- SO Reserve Stock : result_type = 'B' 는 재고로 처리
           AND  A.RESULT_TYPE = 'B'
           AND  A.VALID_YN    = 'Y'   -- 해상재고
           -- 소형은 Cell Biz 용 Demand 만 처리
           AND  ((A.DIVISION_ID = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                 OR (A.DIVISION_ID <> '40'))
           /* 대상 프로젝트 ITEM 필터링 (소형 생산지 구분을 위한 분리) */
           /*AND  ((A.DIVISION_ID = '40' AND A.FROM_SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                 FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                WHERE PLAN_ID = V_PLAN_ID))
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE PLAN_ID = V_PLAN_ID)))*/
        ;

        -- 1.3 SALES 재고 : INCOTERMS UPDATE (DEMAND 없는 경우 'DAP')
        MERGE INTO GT_INCS_SCP_INV A
        USING (
                SELECT  A2.ROWID                                                            AS RID
                      , NVL(NVL(B.MAX_INCOTERMS, C.MAX_INCOTERMS), 'DAP')                   AS NEW_INCOTERMS
                  FROM  GT_INCS_SCP_INV A2
                        LEFT JOIN (SELECT  AA.SCM_SITE_ID, AA.ITEM_ID
                                         --  VMI 는 'DAP' 로 처리
                                         , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP' ELSE AA.INCOTERMS END) MAX_INCOTERMS
                                     FROM  DM_PLN_NET_DEMAND AA
                                           INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                         FROM DM_PLN_NET_DEMAND
                                                        WHERE DIVISION_ID     = V_DIVISION_ID
                                                          AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                                        GROUP BY SCM_SITE_ID
                                                      ) BB
                                                   ON AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                                                  AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                                                  AND AA.DIVISION_ID     = V_DIVISION_ID
                                                  AND AA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                           LEFT JOIN (SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                        FROM SCM_MST_SITE
                                                       WHERE DIVISION_ID = V_DIVISION_ID
                                                         AND VMI_YN      = 'Y') CC
                                                   ON AA.DIVISION_ID = CC.DIVISION_ID
                                                  AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
                                    GROUP BY AA.SCM_SITE_ID, AA.ITEM_ID
                                  ) B
                               ON A2.SCM_SITE_ID = B.SCM_SITE_ID
                              AND A2.ITEM_ID     = B.ITEM_ID
                        LEFT JOIN (SELECT  AA.SCM_SITE_ID
                                         , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP' ELSE AA.INCOTERMS END) MAX_INCOTERMS
                                     FROM  DM_PLN_NET_DEMAND AA
                                           INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                         FROM DM_PLN_NET_DEMAND
                                                        WHERE DIVISION_ID     = V_DIVISION_ID
                                                          AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                                        GROUP BY SCM_SITE_ID
                                                      ) BB
                                                   ON AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                                                  AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                                                  AND AA.DIVISION_ID     = V_DIVISION_ID
                                                  AND AA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                           LEFT JOIN (SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                        FROM SCM_MST_SITE
                                                       WHERE DIVISION_ID = V_DIVISION_ID
                                                         AND VMI_YN      = 'Y') CC
                                                   ON AA.DIVISION_ID = CC.DIVISION_ID
                                                  AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
                                    GROUP BY AA.SCM_SITE_ID
                                  ) C
                               ON A2.SCM_SITE_ID = C.SCM_SITE_ID
                 WHERE  1 = 1
                   AND  A2.SITE_TYPE = 'SALES'
              ) SRC
           ON (A.ROWID = SRC.RID)
        WHEN MATCHED THEN
            UPDATE SET A.INCOTERMS = SRC.NEW_INCOTERMS;

        -- 1.4 PLANT 재고
        INSERT INTO GT_INCS_SCP_INV
        (
            DIVISION_ID
          , SCM_SITE_ID
          , INCOTERMS
          , STOCK_TYPE
          , ITEM_ID
          , AVAILABLE_DATE
          , QTY
          , WIPHOLD_YN
          , SITE_TYPE
          , LOCATION_CODE
          , PROJECT_CODE
          , CELL_PROD_SITE_ID
          , FLAG
        )
        SELECT  A.DIVISION_ID                                                                  AS DIVISION_ID
              , A.SCM_SITE_ID                                                                  AS SCM_SITE_ID
              , '-'                                                                            AS INCOTERMS
              , A.STOCK_TYPE
              , A.ITEM_ID
              , CASE WHEN A.WIPHOLD_YN IS NULL                                     THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     WHEN A.WIPHOLD_YN = 'N'                                       THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME      THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     ELSE                                                               TRUNC(A.AVAILABLE_DATE)
                END                                                                            AS AVAILABLE_DATE
              , A.SCM_QTY                                                                      AS QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N' ELSE A.WIPHOLD_YN END                  AS WIPHOLD_YN
              , B.SITE_TYPE
              , CASE WHEN OP.LOCATION_CODE IS NOT NULL OR ST.LOCATION_CODE IS NOT NULL THEN 'ASSY'
                     ELSE '-'
                END                                                                            AS LOCATION_CODE -- PLANT 재고 구분용 정보
              , ''                                                                             AS PROJECT_CODE
              , ''                                                                             AS CELL_PROD_SITE_ID
              , 'PLANT'                                                                        AS FLAG
          FROM  SCM_DNM_STOCK A
                INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM SCM_MST_SITE
                             WHERE 1 = 1
                               AND DIVISION_ID = V_DIVISION_ID
                               AND SITE_TYPE   = 'PLANT'
                               -- 소형은 Cell Biz 용 Demand 만 처리 : 소형 Pack 제외
                               AND ((DIVISION_ID = '40' AND OPERATION_GROUP IN ('A'))
                                    OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P')))
                           ) B
                        ON A.DIVISION_ID = B.DIVISION_ID
                       AND A.SCM_SITE_ID = B.SCM_SITE_ID
                LEFT JOIN (SELECT DISTINCT A.OPERATION_ID, A.LOCATION_CODE, A.SCM_SITE_ID
                             FROM SCM_MST_LOCATION A
                                  INNER JOIN (SELECT SCM_SITE_ID
                                                FROM SCM_MST_SITE
                                               WHERE DIVISION_ID     = V_DIVISION_ID
                                                 AND VALID_YN        = 'Y'
                                                 AND OPERATION_GROUP IN ('A')
                                             ) B
                                          ON A.SCM_SITE_ID = B.SCM_SITE_ID
                            WHERE A.DIVISION_ID = V_DIVISION_ID
                              AND A.VALID_YN    = 'Y'
                              AND A.LOCATION_CODE = 'PACKAGING' -- 활성화 전 재고
                              AND A.OPERATION_ID IS NOT NULL
                          ) OP -- 셀의 operation_id 별 사용대상 조회
                        ON A.OPERATION_ID = OP.OPERATION_ID
                       AND A.SCM_SITE_ID  = OP.SCM_SITE_ID
                LEFT JOIN (SELECT DISTINCT A.STORAGE_ID, A.LOCATION_CODE, A.SCM_SITE_ID
                             FROM SCM_MST_LOCATION A
                                  INNER JOIN (SELECT SCM_SITE_ID
                                                FROM SCM_MST_SITE
                                               WHERE DIVISION_ID     = V_DIVISION_ID
                                                 AND VALID_YN        = 'Y'
                                                 AND OPERATION_GROUP IN ('A')
                                             ) B
                                          ON A.SCM_SITE_ID = B.SCM_SITE_ID
                            WHERE A.DIVISION_ID = V_DIVISION_ID
                              AND A.VALID_YN    = 'Y'
                              AND A.LOCATION_CODE = 'PACKAGING' -- 활성화 전 재고
                              AND A.STORAGE_ID IS NOT NULL
                          ) ST -- 셀의 storage_id 별 사용대상 조회
                        ON A.STORAGE_ID  = ST.STORAGE_ID
                       AND A.SCM_SITE_ID = ST.SCM_SITE_ID
                LEFT OUTER JOIN GT_INCS_OCV_EXCEPT OCV
                        ON A.SCM_SITE_ID = OCV.SCM_SITE_ID
                       AND A.MES_ITEM_ID = OCV.ITEM_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE = V_CUTOFF_DAY
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  OCV.ITEM_ID   IS NULL;

        --------------------------------------------------------
        -- 2. 활성화 재고 : FOR
        --------------------------------------------------------
        INSERT INTO GT_INCS_SCP_INV
        (
            DIVISION_ID
          , SCM_SITE_ID
          , INCOTERMS
          , STOCK_TYPE
          , ITEM_ID
          , AVAILABLE_DATE
          , QTY
          , WIPHOLD_YN
          , SITE_TYPE
          , LOCATION_CODE
          , PROJECT_CODE
          , CELL_PROD_SITE_ID
          , FLAG
        )
        SELECT  A.DIVISION_ID                                                                  AS DIVISION_ID
              , A.SCM_SITE_ID                                                                  AS SCM_SITE_ID
              , '-'                                                                            AS INCOTERMS
              , 'FOR'                                                                          AS STOCK_TYPE
              , A.ITEM_ID
              -- 2026.04.16 Minyong Lee : 소형에서 ADD_FORMATION_LT 더해진 AVAILABLE_DATE 가 PSD 이전일 때 PSD 에 수량 합산되도록 로직 개선
              , CASE
                   WHEN A.DIVISION_ID = '40' AND MF.ADD_LT_FORMATION IS NOT NULL THEN
                        CASE WHEN TO_CHAR(A.AVAILABLE_DATE + MF.ADD_LT_FORMATION, 'YYYYMMDD') < V_PLAN_NAME THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                             ELSE A.AVAILABLE_DATE + MF.ADD_LT_FORMATION
                        END
                   ELSE
                        CASE WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                             ELSE A.AVAILABLE_DATE
                        END
                END                                                                            AS AVAILABLE_DATE
              , A.QTY                                                                          AS QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N' ELSE A.WIPHOLD_YN END                  AS WIPHOLD_YN
              , 'PLANT'                                                                        AS SITE_TYPE
              , '-'                                                                            AS LOCATION_CODE -- PLANT 재고 구분용 정보
              , ''                                                                             AS PROJECT_CODE
              , ''                                                                             AS CELL_PROD_SITE_ID
              , 'PLANT'                                                                        AS FLAG
          FROM  (SELECT A.*
                   FROM  SCM_DNM_STOCK_AGING_V A
                         -- 속도개선을 위해서 INNER JOIN => LEFT JOIN 으로 변경
                         LEFT JOIN (SELECT DIVISION_ID, SITE_ID, MAX(CUTOFF_DATE) MAX_CUTOFF_DATE
                                      FROM SCM_DNM_STOCK_AGING_V A
                                     WHERE A.DIVISION_ID = V_DIVISION_ID
                                       AND A.CUTOFF_DATE > V_D_CUTOFF_DAY - 7
                                       AND A.CUTOFF_DATE <= V_D_CUTOFF_DAY
                                     GROUP BY DIVISION_ID, SITE_ID
                                   ) C -- DIVISION_ID / SITE_ID 별 최근 일주일 이내의 MAX(CUTOFF_DATE)
                                ON A.DIVISION_ID = C.DIVISION_ID
                               AND A.SITE_ID     = C.SITE_ID
                               AND A.CUTOFF_DATE = C.MAX_CUTOFF_DATE
                  WHERE  A.DIVISION_ID = V_DIVISION_ID
                    AND  C.DIVISION_ID IS NOT NULL -- LEFT JOIN 변경에 따른 조건 추가
                    -- 소형 생산지 구분을 위한 분리
                    /*AND  ((A.DIVISION_ID = '40' AND A.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                     FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                    WHERE PLAN_ID = V_PLAN_ID))
                          OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                                        FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                       WHERE PLAN_ID = V_PLAN_ID)))*/
                 ) A
                -- 속도개선을 위해서 INNER JOIN => LEFT JOIN 으로 변경
                LEFT JOIN (SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                             FROM SCM_MST_SITE
                            WHERE 1 = 1
                              AND DIVISION_ID = V_DIVISION_ID
                              AND SITE_TYPE   = 'PLANT'
                              AND NVL(OSP_YN, 'N') = 'N' -- 20180822 추가
                          ) B
                        ON A.SCM_SITE_ID = B.SCM_SITE_ID
                LEFT OUTER JOIN SCP_MST_FORMATION_V MF
                        ON A.DIVISION_ID = MF.DIVISION_ID
                       AND A.SCM_SITE_ID = MF.PLANT_SITE_ID
                       AND A.ITEM_ID     = MF.ITEM_ID
         WHERE  B.DIVISION_ID IS NOT NULL; -- LEFT JOIN 변경에 따른 조건 추가

        --------------------------------------------------------
        -- 3. 해상 재고 : INT
        --------------------------------------------------------
        -- 3.1 RESULT_TYPE IN ('I','C') : ERP 해상재고, 법인간 재고
        INSERT INTO GT_INCS_SCP_INT
        (
            DIVISION_ID
          , ITEM_ID
          , TO_SCM_SITE_ID
          , INCOTERMS
          , ETA_DATE
          , DELIVERY_QTY
          , PROJECT_CODE
          , CELL_PROD_SITE_ID
          , FLAG
        )
        SELECT  /*+ NO_MERGE(A) NO_PUSH_PRED(A) */ A.DIVISION_ID                                                                  AS DIVISION_ID
              , A.ITEM_ID
              , A.TO_SCM_SITE_ID                                                               AS TO_SCM_SITE_ID
              , A.FINAL_INCOTERMS                                                              AS INCOTERMS
              -- 도착 예정일자 : Plan Start 이전 일자는 Plan Start Date 로 입력 요청
              , CASE WHEN A.ETA_DATE < V_PLAN_NAME THEN V_PLAN_NAME ELSE A.ETA_DATE END        AS ETA_DATE
              , A.DELIVERY_QTY
              , CASE WHEN TS.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-' -- 법인간 이동 재고엔 Project Code 없음
                     WHEN TS.SITE_TYPE = 'SALES' THEN CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END
                     WHEN TS.SITE_TYPE = 'PLANT' THEN '' -- Plant 도착은 NULL 처리
                     ELSE CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END
                END                                                                            AS PROJECT_CODE
              , CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END              AS CELL_PROD_SITE_ID
              , TS.SITE_TYPE                                                                   AS FLAG
          FROM  SCM_DNM_INTRANSIT_V A
                INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V) FI
                        ON A.DIVISION_ID          = FI.DIVISION_ID
                       AND A.ITEM_ID              = FI.ITEM_ID
                       AND FI.OPERATION_GROUP_ID <> 'E' -- 전극 모델 제외
                INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                              FROM SCM_MST_SITE
                             WHERE DIVISION_ID = V_DIVISION_ID
                               AND SITE_TYPE   = 'PLANT'
                               AND OPERATION_GROUP IN ('A', 'P') -- FROM_SITE 가 전극인 정보 제외
                               AND VALID_YN    = 'Y'
                           ) FS
                        ON A.DIVISION_ID      = FS.DIVISION_ID
                       AND A.FROM_SCM_SITE_ID = FS.SCM_SITE_ID
                       AND ((FS.DIVISION_ID = '40' AND FS.OPERATION_GROUP = 'A') -- 소형은 Cell Biz 용 Demand 만 처리
                            OR (FS.DIVISION_ID <> '40'))
                INNER JOIN SCM_MST_SITE TS
                        ON A.DIVISION_ID    = TS.DIVISION_ID
                       AND A.TO_SCM_SITE_ID = TS.SCM_SITE_ID
                       AND TS.VALID_YN      = 'Y'
                       AND ((TS.DIVISION_ID = '40' AND TS.SITE_TYPE = 'SALES') -- 소형은 Cell Biz 용 Demand 만 처리
                            OR (TS.DIVISION_ID <> '40'))
                LEFT OUTER JOIN GT_INCS_CELL_PROD CPS
                        ON 1 = 1
                       AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                       AND A.ITEM_ID        = CPS.ITEM_ID
         WHERE  1 = 1
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  A.RESULT_DATE = V_CUTOFF_DAY
           AND  A.RESULT_TYPE IN ('I', 'C') -- ERP 해상재고, 법인간 재고
           /* 대상 프로젝트 ITEM 필터링 (소형 생산지 구분을 위한 분리) */
           /*AND  ((A.DIVISION_ID = '40' AND A.FROM_SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                 FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                WHERE PLAN_ID = V_PLAN_ID))
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE PLAN_ID = V_PLAN_ID)))*/
        ;

        -- 3.2 TO SITE 가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것 (동일 로직으로 별도 처리)
        INSERT INTO GT_INCS_SCP_INT
        (
            DIVISION_ID
          , ITEM_ID
          , TO_SCM_SITE_ID
          , INCOTERMS
          , ETA_DATE
          , DELIVERY_QTY
          , PROJECT_CODE
          , CELL_PROD_SITE_ID
          , FLAG
        )
        SELECT  A.DIVISION_ID
              , A.ITEM_ID
              , MS.SCM_SITE_ID                                                                 AS TO_SCM_SITE_ID
              , 'DAP'                                                                          AS INCOTERMS -- VMI 임
              -- 도착 예정일자 : Plan 시작일자로 처리
              , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')                     AS ETA_DATE
              , NVL(A.SCM_QTY, 0)                                                              AS DELIVERY_QTY
              , '-'                                                                            AS PROJECT_CODE
              , NVL(MSP.SCM_SITE_ID, '')                                                       AS CELL_PROD_SITE_ID
              , 'SALES'                                                                        AS FLAG
          FROM  SCM_DNM_STOCK A
                INNER JOIN SCM_MST_VMI_INT_SLOC MS
                        ON A.DIVISION_ID = MS.DIVISION_ID
                       AND A.PLANT_ID    = MS.PLANT_ID
                       AND A.STORAGE_ID  = MS.STORAGE_ID
                       AND MS.VALID_YN   = 'Y'
                -- 소형 생산지 구분을 위한 분리
                INNER JOIN SCM_MST_SITE MSS
                        ON A.PLANT_ID = MSS.PLANT_ID
                LEFT OUTER JOIN GT_INCS_OCV_EXCEPT OCV
                        ON A.SCM_SITE_ID = OCV.SCM_SITE_ID
                       AND A.MES_ITEM_ID = OCV.ITEM_ID
                LEFT OUTER JOIN GT_INCS_CELL_PROD CPS
                        ON 1 = 1
                       AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
                       AND A.ITEM_ID     = CPS.ITEM_ID
                LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                   FROM SCM_MST_SITE
                                  WHERE 1 = 1
                                    AND PLANT_ID IS NOT NULL
                                ) MSP
                        ON 1 = 1
                       AND A.DIVISION_ID                     = MSP.DIVISION_ID
                       AND A.PLANT_ID || CPS.OPERATION_GROUP = MSP.SCM_SITE_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE = V_CUTOFF_DAY
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  OCV.ITEM_ID   IS NULL
           -- 소형은 Cell Biz 용 Demand 만 처리
           AND  ((A.DIVISION_ID = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                 OR (A.DIVISION_ID <> '40'))
           /* 대상 프로젝트 ITEM 필터링 (소형 생산지 구분을 위한 분리) */
           /*AND  ((A.DIVISION_ID = '40' AND MSS.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                              FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                             WHERE PLAN_ID = V_PLAN_ID))
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE PLAN_ID = V_PLAN_ID)))*/
        ;

        --------------------------------------------------------
        -- UPDATE PROJECT
        -- INCOTERMS 가 있는 DM 정보와 없는 DM 정보를 각각 가져옴 (DUE DATE 가 가장 빠른 날짜 기준)
        --------------------------------------------------------
        INSERT INTO GT_INCS_DM
        (
            SITE_ID
          , ITEM_ID
          , INCOTERMS
          , PROJECT_CODE
        )
        SELECT  SITE_ID
              , ITEM_ID
              , INCOTERMS
              , PROJECT_CODE
          FROM  (SELECT  SITE_ID
                       , ITEM_ID
                       , INCOTERMS
                       , PROJECT_CODE
                       , ROW_NUMBER() OVER (PARTITION BY SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE ORDER BY MIN_DUE) AS ROW_NUM
                   FROM  (SELECT  ATTRIBUTE1    AS SITE_ID
                                , ATTRIBUTE2    AS ITEM_ID
                                , ATTRIBUTE4    AS INCOTERMS
                                , ATTRIBUTE5    AS PROJECT_CODE
                                , MIN(DUE_DATE) AS MIN_DUE
                            FROM  SCP_OPT_ENG_DEMAND_SN
                           WHERE  PLAN_ID = V_PLAN_ID
                             AND  ATTRIBUTE5 IS NOT NULL -- PROJECT_CODE
                             AND  ATTRIBUTE4 IS NOT NULL -- INCOTERMS
                           GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5
                         ) DM
                 ) RM
         WHERE  ROW_NUM = 1
        UNION ALL
        SELECT  SITE_ID
              , ITEM_ID
              , INCOTERMS
              , PROJECT_CODE
          FROM  (SELECT  SITE_ID
                       , ITEM_ID
                       , INCOTERMS
                       , PROJECT_CODE
                       , ROW_NUMBER() OVER (PARTITION BY SITE_ID, ITEM_ID, PROJECT_CODE ORDER BY MIN_DUE) AS ROW_NUM
                   FROM  (SELECT  ATTRIBUTE1    AS SITE_ID
                                , ATTRIBUTE2    AS ITEM_ID
                                , NULL          AS INCOTERMS
                                , ATTRIBUTE5    AS PROJECT_CODE
                                , MIN(DUE_DATE) AS MIN_DUE
                            FROM  SCP_OPT_ENG_DEMAND_SN
                           WHERE  PLAN_ID = V_PLAN_ID
                             AND  ATTRIBUTE5 IS NOT NULL
                             AND  ATTRIBUTE4 IS NULL
                           GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
                         ) DM
                 ) RM
         WHERE  ROW_NUM = 1;

        --------------------------------------------------------
        -- #DEMAND_GROUP_T : Demand Group Master  (2025-12-15 jongykim2)
        --------------------------------------------------------
        INSERT INTO GT_INCS_DEMAND_GROUP
        (
            DIVISION_ID
          , ITEM_ID
          , DEMAND_GROUP
          , PROJECT_CODE
        )
        SELECT  T2.DIVISION_ID
              , T2.ITEM_ID
              , T.GROUP_NAME AS DEMAND_GROUP
              , T2.PROJECT_CODE
          FROM  SCP_MST_ITEM_GROUP T
                INNER JOIN SCP_MST_ITEM_GROUP_DETAIL T2
                        ON T2.DIVISION_ID = T.DIVISION_ID
                       AND T2.GROUP_ID    = T.GROUP_ID
         WHERE  1 = 1
           AND  T.DIVISION_ID = V_DIVISION_ID
           AND  T.VALID_YN    = 'Y'
           AND  NVL(T.ATTRIBUTE1, 'N') <> 'Y'
           AND  T2.VALID_YN   = 'Y';

        --------------------------------------------------------
        -- #SCP_INVENTORY_I 프로젝트 UPDATE
        --------------------------------------------------------
        MERGE INTO GT_INCS_SCP_INV TGT
        USING (
                SELECT  RID
                      , PROJECT_CODE
                  FROM  (SELECT  INV.ROWID                                                           AS RID
                               , DJ.PROJECT_CODE
                               , ROW_NUMBER() OVER (PARTITION BY INV.ROWID ORDER BY DJ.PROJECT_CODE) AS RN
                           FROM  GT_INCS_SCP_INV INV
                                 INNER JOIN (
                                             SELECT  INV.DIVISION_ID
                                                   , INV.SCM_SITE_ID
                                                   , INV.INCOTERMS
                                                   , INV.STOCK_TYPE
                                                   , INV.ITEM_ID
                                                   , INV.MDF_ITEM_ID
                                                   , INV.AVAILABLE_DATE
                                                   , INV.QTY
                                                   , INV.WIPHOLD_YN
                                                   , INV.SITE_TYPE
                                                   , INV.LOCATION_CODE
                                                   , DT.PROJECT_CODE
                                               FROM  (SELECT  INV.DIVISION_ID
                                                            , INV.SCM_SITE_ID
                                                            , INV.INCOTERMS
                                                            , INV.STOCK_TYPE
                                                            , INV.ITEM_ID
                                                            , CASE WHEN LU.ITEM_ID IS NULL THEN INV.ITEM_ID ELSE LU.DEMAND_GROUP END AS MDF_ITEM_ID
                                                            , INV.AVAILABLE_DATE
                                                            , INV.QTY
                                                            , INV.WIPHOLD_YN
                                                            , INV.SITE_TYPE
                                                            , INV.LOCATION_CODE
                                                        FROM  GT_INCS_SCP_INV INV
                                                              LEFT OUTER JOIN GT_INCS_DEMAND_GROUP LU
                                                                      ON INV.ITEM_ID = LU.ITEM_ID
                                                       WHERE  INV.FLAG         = 'SALES'
                                                         AND  INV.PROJECT_CODE = '-'
                                                         AND  INV.QTY > 0
                                                     ) INV
                                                   INNER JOIN GT_INCS_DM DT
                                                           ON INV.SCM_SITE_ID  = DT.SITE_ID
                                                          AND INV.MDF_ITEM_ID  = DT.ITEM_ID
                                                          AND ((INV.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                                               OR (INV.INCOTERMS = DT.INCOTERMS)
                                                               OR (INV.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL))
                                            ) DJ
                                         ON INV.DIVISION_ID    = DJ.DIVISION_ID
                                        AND INV.SCM_SITE_ID    = DJ.SCM_SITE_ID
                                        AND INV.INCOTERMS      = DJ.INCOTERMS
                                        AND INV.STOCK_TYPE     = DJ.STOCK_TYPE
                                        AND INV.ITEM_ID        = DJ.ITEM_ID
                                        AND INV.AVAILABLE_DATE = DJ.AVAILABLE_DATE
                                        AND INV.QTY            = DJ.QTY
                                        AND INV.WIPHOLD_YN     = DJ.WIPHOLD_YN
                                        AND INV.SITE_TYPE      = DJ.SITE_TYPE
                                        AND INV.LOCATION_CODE  = DJ.LOCATION_CODE
                         )
                 WHERE  RN = 1
              ) SRC
           ON (TGT.ROWID = SRC.RID)
        WHEN MATCHED THEN
            UPDATE SET TGT.PROJECT_CODE = SRC.PROJECT_CODE;

        --------------------------------------------------------
        -- #SCP_INTRANSIT_I 프로젝트 UPDATE
        --------------------------------------------------------
        MERGE INTO GT_INCS_SCP_INT TGT
        USING (
                SELECT  RID
                      , PROJECT_CODE
                  FROM  (SELECT  INV.ROWID                                                           AS RID
                               , DJ.PROJECT_CODE
                               , ROW_NUMBER() OVER (PARTITION BY INV.ROWID ORDER BY DJ.PROJECT_CODE) AS RN
                           FROM  GT_INCS_SCP_INT INV
                                 INNER JOIN (
                                             SELECT  INV.DIVISION_ID
                                                   , INV.ITEM_ID
                                                   , INV.TO_SCM_SITE_ID
                                                   , INV.INCOTERMS
                                                   , INV.ETA_DATE
                                                   , INV.DELIVERY_QTY
                                                   , INV.FLAG
                                                   , DT.PROJECT_CODE
                                               FROM  (SELECT  INV.DIVISION_ID
                                                            , INV.ITEM_ID
                                                            , CASE WHEN LU.ITEM_ID IS NULL THEN INV.ITEM_ID ELSE LU.DEMAND_GROUP END AS MDF_ITEM_ID
                                                            , INV.TO_SCM_SITE_ID
                                                            , INV.INCOTERMS
                                                            , INV.ETA_DATE
                                                            , INV.DELIVERY_QTY
                                                            , INV.PROJECT_CODE
                                                            , INV.FLAG
                                                        FROM  GT_INCS_SCP_INT INV
                                                              LEFT OUTER JOIN GT_INCS_DEMAND_GROUP LU
                                                                      ON INV.ITEM_ID = LU.ITEM_ID
                                                       WHERE  INV.FLAG         = 'SALES'
                                                         AND  INV.PROJECT_CODE = '-'
                                                         AND  INV.DELIVERY_QTY > 0
                                                     ) INV
                                                   INNER JOIN GT_INCS_DM DT
                                                           ON INV.TO_SCM_SITE_ID = DT.SITE_ID
                                                          AND INV.MDF_ITEM_ID    = DT.ITEM_ID
                                                          AND ((INV.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                                               OR (INV.INCOTERMS = DT.INCOTERMS)
                                                               OR (INV.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL))
                                            ) DJ
                                         ON INV.DIVISION_ID    = DJ.DIVISION_ID
                                        AND INV.ITEM_ID        = DJ.ITEM_ID
                                        AND INV.TO_SCM_SITE_ID = DJ.TO_SCM_SITE_ID
                                        AND INV.INCOTERMS      = DJ.INCOTERMS
                                        AND INV.ETA_DATE       = DJ.ETA_DATE
                                        AND INV.DELIVERY_QTY   = DJ.DELIVERY_QTY
                                        AND INV.FLAG           = DJ.FLAG
                         )
                 WHERE  RN = 1
              ) SRC
           ON (TGT.ROWID = SRC.RID)
        WHEN MATCHED THEN
            UPDATE SET TGT.PROJECT_CODE = SRC.PROJECT_CODE;

        -- CA 별 CP 정보
        INSERT INTO GT_INCS_CP_INFO
        (
            DIVISION_ID
          , PLANT_ID
          , ITEM_ID_ASSY
          , ITEM_ID_PROD
          , PRIORITY_1ST
          , PRIORITY_2ND
          , PRIORITY_3RD
        )
        SELECT  M.DIVISION_ID
              , M.PLANT_ID
              , M.ITEM_ID_ASSY
              , M.ITEM_ID_PROD
              , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY, M.PLANT_ID ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_1ST
              , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY            ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_2ND
              , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY                           ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_3RD
          FROM  SCP_MST_CELL_PROD_ASSY_MAP M
         WHERE  1 = 1
           AND  M.VALID_YN = 'Y';

        --------------------------------------------------------
        -- INCOMING STOCK INSERT
        -- 2025.07.10 Philsu Park: 재고 보정 대상 데이터는 별도 Insert 하기 때문에 제외 처리.
        --------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
        (
            PLAN_ID
          , STOCK_ID
          , BUFFER_ID
          , EFFECTIVE_DATE
          , TYPE
          , QUANTITY
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE4
          , ATTRIBUTE5
        )
        SELECT  PLAN_ID
              , STOCK_ID
              , BUFFER_ID
              , EFECTIVE_DATE
              , TYPE
              , SUM(QUANTITY) AS QUANTITY
              , SITE_ID
              , ITEM_ID
              , STAGE
              , INCOTERMS
              , PROJECT_CODE
          FROM  (
                 SELECT  V_PLAN_ID                                                                                         AS PLAN_ID
                       , TYPE || '::' || SITE_ID || '::' || ITEM_ID || '::' || STAGE
                         || CASE WHEN INCOTERMS = '-' THEN '' ELSE '@' || INCOTERMS END
                         || CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@' || PROJECT_CODE END
                         || '::' || EFECTIVE_DATE
                         || CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::' || CELL_PROD_SITE_ID END                 AS STOCK_ID
                       , SITE_ID || '::' || ITEM_ID || '::' || STAGE
                         || CASE WHEN INCOTERMS = '-' THEN '' ELSE '@' || INCOTERMS END
                         || CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@' || PROJECT_CODE END
                         || CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::' || CELL_PROD_SITE_ID END                 AS BUFFER_ID
                       , EFECTIVE_DATE                                                                                     AS EFECTIVE_DATE
                       , TYPE                                                                                              AS TYPE
                       , QTY                                                                                               AS QUANTITY
                       , SITE_ID                                                                                           AS SITE_ID
                       , ITEM_ID                                                                                           AS ITEM_ID
                       , STAGE                                                                                             AS STAGE
                       , INCOTERMS                                                                                         AS INCOTERMS
                       , PROJECT_CODE                                                                                      AS PROJECT_CODE
                   FROM  (
                          SELECT  A.DIVISION_ID
                                , A.SCM_SITE_ID AS SITE_ID
                                -- 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update
                                -- MA 재고는 AGING 으로 두고 MU, MJ... 는 CHAR 로 변환
                                , CASE
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-' AND A.ITEM_ID NOT LIKE 'MA%'
                                          THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), A.ITEM_ID)
                                     ELSE A.ITEM_ID
                                  END AS ITEM_ID
                                /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인 경우는 **** BIZ 로 STAGE 생성 */
                                , CASE
                                     WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'PLANT' THEN 'PACK'
                                     WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'SALES' THEN 'PACKBIZ'
                                     WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'PLANT' THEN 'MDLE'
                                     WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'SALES' THEN 'MDLEBIZ'
                                     WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                                     WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' AND A.FLAG = 'SALES' THEN 'CELLBIZ'
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'FOR%' THEN 'ASY_AGING' -- 활성화 재고
                                     -- 활성화 완료 재고 : CHAR 버퍼 재고로 처리(ASSY Item 은 CHAR Item 으로 Update), 활성화 전 재고 : ASSY
                                     -- MA 재고는 ASY_AGING, MU/MJ... 는 CHAR 로 변환
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' AND A.ITEM_ID NOT LIKE 'MA%' THEN 'CHAR' WHEN A.LOCATION_CODE = '-' AND A.ITEM_ID LIKE 'MA%' THEN 'ASY_AGING' ELSE 'ASSY' END)
                                     -- SUBMDLE 는 FINAL ITEM 에 없으므로 다른 TABLE 에서 확인
                                     WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                                     WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                     ELSE '-'
                                  END AS STAGE
                                , TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                                , A.DESCR AS TYPE
                                , QTY AS QTY
                                , INCOTERMS
                                , PROJECT_CODE
                                , CELL_PROD_SITE_ID
                            FROM  (
                                   SELECT  T.DIVISION_ID
                                         , T.ITEM_ID
                                         , T.SCM_SITE_ID AS SCM_SITE_ID
                                         , T.INCOTERMS
                                         , TO_DATE(TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), 'YYYYMMDD') AS EFFSTARTDATE
                                         , SUM(T.QTY)    AS QTY
                                         , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH' ELSE 'WH_HOLD' END AS DESCR
                                         , T.LOCATION_CODE
                                         , T.PROJECT_CODE
                                         , T.CELL_PROD_SITE_ID
                                         , T.FLAG
                                     FROM  GT_INCS_SCP_INV T
                                    WHERE  1 = 1
                                      AND  T.STOCK_TYPE <> 'FOR'
                                    GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                   HAVING SUM(T.QTY) > 0
                                   UNION ALL
                                   -- 활성화 재고 : FOR 로 처리
                                   SELECT  T.DIVISION_ID
                                         , T.ITEM_ID
                                         , T.SCM_SITE_ID AS SCM_SITE_ID
                                         , T.INCOTERMS
                                         , TO_DATE(TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), 'YYYYMMDD') AS EFFSTARTDATE
                                         , SUM(T.QTY)    AS QTY
                                         , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'FOR' ELSE 'FOR_HOLD' END AS DESCR
                                         , T.LOCATION_CODE
                                         , T.PROJECT_CODE
                                         , T.CELL_PROD_SITE_ID
                                         , T.FLAG
                                     FROM  GT_INCS_SCP_INV T
                                    WHERE  1 = 1
                                      AND  T.STOCK_TYPE = 'FOR' -- 활성화 재고
                                      AND  T.QTY > 0
                                    GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                   UNION ALL
                                   -- INTRANSIT SHIPMENT 재고
                                   SELECT  T.DIVISION_ID
                                         , T.ITEM_ID
                                         , T.TO_SCM_SITE_ID AS SCM_SITE_ID
                                         , T.INCOTERMS
                                         , TO_DATE(T.ETA_DATE, 'YYYYMMDD') AS EFFSTARTDATE
                                         , SUM(T.DELIVERY_QTY) AS QTY
                                         , 'INT'  AS DESCR
                                         , '-'    AS LOCATION_CODE
                                         , T.PROJECT_CODE
                                         , T.CELL_PROD_SITE_ID
                                         , T.FLAG
                                     FROM  GT_INCS_SCP_INT T
                                    WHERE  1 = 1
                                      AND  T.DELIVERY_QTY > 0
                                      AND  (T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')
                                    GROUP BY T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID, T.ETA_DATE, T.INCOTERMS, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                  ) A
                                  LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                               FROM SCP_MST_FINAL_ITEM
                                              WHERE DIVISION_ID = V_DIVISION_ID
                                                AND OPERATION_GROUP IN ('A', 'P')
                                            ) B
                                          ON A.ITEM_ID     = B.ITEM_ID
                                         AND A.DIVISION_ID = B.DIVISION_ID
                                  LEFT JOIN SCM_MST_SITE FS
                                          ON FS.DIVISION_ID = A.DIVISION_ID
                                         AND FS.SCM_SITE_ID = A.SCM_SITE_ID
                                         AND FS.SITE_TYPE   = 'PLANT'
                                  LEFT JOIN GT_INCS_CP_INFO C1
                                          ON C1.DIVISION_ID  = A.DIVISION_ID
                                         AND C1.PLANT_ID     = FS.PLANT_ID
                                         AND C1.ITEM_ID_ASSY = A.ITEM_ID
                                         AND C1.PRIORITY_1ST = 1
                                  LEFT JOIN GT_INCS_CP_INFO C2
                                          ON C2.DIVISION_ID  = A.DIVISION_ID
                                         AND C2.ITEM_ID_ASSY = A.ITEM_ID
                                         AND C2.PRIORITY_2ND = 1
                                  LEFT JOIN GT_INCS_CP_INFO C3
                                          ON C3.ITEM_ID_ASSY = A.ITEM_ID
                                         AND C3.PRIORITY_3RD = 1
                                  -- SUBMDLE 의 STAGE 를 찾기 위해 추가
                                  LEFT JOIN (
                                             SELECT  SM.DIVISION_ID
                                                   , SM.SCM_SITE_ID
                                                   , IM.ITEM_ID
                                                   , IM.SCP_FLOW_ID
                                                   , IM.SCP_OPERATION_GROUP
                                               FROM  SCM_ITEM_M_SN IM
                                                     INNER JOIN SCM_MST_SITE SM
                                                             ON IM.COMPANY_ID          = SM.COMPANY_ID
                                                            AND IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                                              WHERE  1 = 1
                                                /*AND  SM.SCM_SITE_ID || IM.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                        FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                       WHERE PLAN_ID = V_PLAN_ID)*/
                                                AND  IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500') -- SUBMDLE 만
                                                AND  IM.SCP_OPERATION_GROUP = 'P'             -- SUBMDLE 만
                                            ) SMC
                                          ON A.DIVISION_ID = SMC.DIVISION_ID
                                         AND A.SCM_SITE_ID = SMC.SCM_SITE_ID
                                         AND A.ITEM_ID     = SMC.ITEM_ID
                           WHERE  1 = 1
                         ) A
                  WHERE  1 = 1
                    /*AND  ((A.DIVISION_ID = '40' AND A.SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                 FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                WHERE PLAN_ID = V_PLAN_ID))
                          OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                                        FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                       WHERE PLAN_ID = V_PLAN_ID)))*/
                    AND  EFECTIVE_DATE < V_PLAN_END_YYYYMMDD
                 UNION ALL
                 --------------------------------------------------------
                 -- 자재 / 포장재의 입고 예정정보
                 -- 2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용.
                 --------------------------------------------------------
                 SELECT  V_PLAN_ID                                                             AS PLAN_ID
                       , TYPE || '::' || SCM_SITE_ID || '::' || MAT_ID || '::' || STAGE || '::' || ARR_DATE AS STOCK_ID
                       , SCM_SITE_ID || '::' || MAT_ID || '::' || STAGE                        AS BUFFER_ID
                       , ARR_DATE                                                              AS EFFECTIVE_DATE
                       , TYPE                                                                  AS TYPE
                       , QTY                                                                   AS QUANTITY
                       , SCM_SITE_ID                                                           AS SITE_ID
                       , MAT_ID                                                                AS ITEM_ID
                       , STAGE                                                                 AS STAGE
                       , '-'                                                                   AS INCOTERMS
                       , '-'                                                                   AS PROJECT_CODE
                   FROM  (
                          -- START 2025.11.19 jongykim2: Schelduled Reciept Information
                          SELECT  LU.PLANT_SITE_ID        AS SCM_SITE_ID
                                , LU.ITEM_ID_CHILD         AS MAT_ID
                                , 'MATERIAL_CONST'         AS STAGE
                                , LU.TO_YYYYMMDD           AS ARR_DATE
                                , TO_NUMBER(LU.TO_EXPC_QTY) AS QTY
                                , 'MC'                     AS TYPE
                            FROM  SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION LU
                                  INNER JOIN GT_INCS_MAT_CONST MAT
                                          ON LU.ITEM_ID_CHILD = MAT.MAT_ID
                           WHERE  1 = 1
                             AND  LU.DIVISION_ID = V_DIVISION_ID
                             AND  1 = 1 /* _BATCH T3: 계획그룹 필터 제거(사업부 전체) */
                             AND  LU.VALID_YN    = 'Y'
                             AND  LU.TO_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE
                          -- END 2025.11.19 jongykim2: Schelduled Reciept Information
                         ) MC
                  WHERE  ARR_DATE < V_PLAN_END_YYYYMMDD
                ) AA
         GROUP BY PLAN_ID, STOCK_ID, BUFFER_ID, EFECTIVE_DATE, TYPE, SITE_ID, ITEM_ID, STAGE, INCOTERMS, PROJECT_CODE;

        --------------------------------------------------------
        -- INCOMING STOCK INSERT #2 : 재고 보정 데이터 Insert (현재 미사용 - 원본 주석 유지)
        -- 2025.07.10 Philsu Park
        --------------------------------------------------------
        /* INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN(PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY,
                                                     ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15, INSERT_ID)
        SELECT @V_PLAN_ID, ADJ.STOCK_TYPE + '::' + ... (재고보정 #INVENTORY_ADJUST 기반, 현재 미사용) */

        --------------------------------------------------------
        -- 2nd OCV 재고는 INSP 로 UPDATE (현재 미사용 - 원본 주석 유지)
        --------------------------------------------------------
        /* UPDATE SCP_OPT_ENG_INCOMING_STOCK_SN ... SCP_OPT_ENG_CONST_SECOND_OCV_MASTER 기준 STAGE 치환 (현재 미사용) */

        --------------------------------------------------------
        -- INTRANSIT 재고 중 SITE_ID, ITEM_ID 를 DEMAND 와 비교하여 INCOTERMS 만 다른 경우 INCOTERMS 변경 (소형 전용)
        -- THK / 20250724 / 상현 책임님 요청
        --------------------------------------------------------
        IF V_DIVISION_ID = '40' THEN
            -- DUE DATE 가 재고 EFFECTIVE DATE 보다 느린 것 중 DUE 의 MIN 값을 먼저 넣어 줌
            INSERT INTO GT_INCS_INC
            (
                PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15
            )
            SELECT  PLAN_ID
                  , STOCK_ID
                  , BUFFER_ID
                  , EFFECTIVE_DATE
                  , TYPE
                  , SUM(QUANTITY) AS QUANTITY
                  , ATTRIBUTE1
                  , ATTRIBUTE2
                  , ATTRIBUTE3
                  , ATTRIBUTE4
                  , ATTRIBUTE5
                  , ATTRIBUTE15
              FROM  (
                     SELECT  NI.PLAN_ID
                           , NI.STOCK_ID
                           , NI.BUFFER_ID
                           , NI.EFFECTIVE_DATE
                           , NI.TYPE
                           , CAST(NI.QUANTITY AS NUMBER(20,10)) + CAST(NVL(INC.QUANTITY, 0) AS NUMBER(20,10)) AS QUANTITY
                           , NI.ATTRIBUTE1
                           , NI.ATTRIBUTE2
                           , NI.ATTRIBUTE3
                           , NI.ATTRIBUTE4
                           , NI.ATTRIBUTE5
                           , NI.ATTRIBUTE15
                       FROM  (
                              SELECT  INC.PLAN_ID                                                                                                                  AS PLAN_ID
                                    , INC.TYPE || '::' || INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || DM1.ATTRIBUTE4 || '@' || DM1.ATTRIBUTE5 || '::' || INC.EFFECTIVE_DATE AS STOCK_ID
                                    , INC.STOCK_ID                                                                                                                 AS BF_STOCK_ID
                                    , INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || DM1.ATTRIBUTE4 || '@' || DM1.ATTRIBUTE5         AS BUFFER_ID
                                    , INC.EFFECTIVE_DATE  AS EFFECTIVE_DATE
                                    , INC.TYPE            AS TYPE
                                    , INC.QUANTITY        AS QUANTITY
                                    , INC.ATTRIBUTE1      AS ATTRIBUTE1
                                    , INC.ATTRIBUTE2      AS ATTRIBUTE2
                                    , INC.ATTRIBUTE3      AS ATTRIBUTE3
                                    , DM1.ATTRIBUTE4      AS ATTRIBUTE4
                                    , DM1.ATTRIBUTE5      AS ATTRIBUTE5
                                    , 'INCOTERMS_ADJUST'  AS ATTRIBUTE15
                                FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                      LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM1
                                              ON INC.PLAN_ID    = DM1.PLAN_ID
                                             AND INC.ATTRIBUTE1 = DM1.ATTRIBUTE1
                                             AND INC.ATTRIBUTE2 = DM1.ATTRIBUTE2
                                             AND INC.ATTRIBUTE4 <> DM1.ATTRIBUTE4
                                             AND INC.EFFECTIVE_DATE <= DM1.DUE_DATE
                                      INNER JOIN (
                                                  SELECT  DM.PLAN_ID
                                                        , DM.ATTRIBUTE1
                                                        , DM.ATTRIBUTE2
                                                        , DM.ATTRIBUTE4
                                                        , DM.ATTRIBUTE5
                                                        , MIN(DUE_DATE) AS DUE_DATE
                                                    FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                                          LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM
                                                                  ON INC.PLAN_ID    = DM.PLAN_ID
                                                                 AND INC.ATTRIBUTE1 = DM.ATTRIBUTE1
                                                                 AND INC.ATTRIBUTE2 = DM.ATTRIBUTE2
                                                                 AND INC.ATTRIBUTE4 <> DM.ATTRIBUTE4
                                                                 AND INC.EFFECTIVE_DATE <= DM.DUE_DATE
                                                   WHERE  DM.PLAN_ID = V_PLAN_ID
                                                   GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                                 ) DM2
                                              ON DM1.PLAN_ID    = DM2.PLAN_ID
                                             AND DM1.ATTRIBUTE1 = DM2.ATTRIBUTE1
                                             AND DM1.ATTRIBUTE2 = DM2.ATTRIBUTE2
                                             AND DM1.ATTRIBUTE4 = DM2.ATTRIBUTE4
                                             AND DM1.ATTRIBUTE5 = DM2.ATTRIBUTE5
                                             AND DM1.DUE_DATE   = DM2.DUE_DATE
                               WHERE  INC.PLAN_ID = V_PLAN_ID
                                 AND  INC.TYPE    = 'INT'
                                 AND  DM1.DEMAND_ID IS NOT NULL
                                 AND  NOT EXISTS (SELECT 1
                                                    FROM SCP_OPT_ENG_DEMAND_SN DMD
                                                   WHERE DMD.PLAN_ID    = V_PLAN_ID
                                                     AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                                     AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                                     AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                                     AND INC.EFFECTIVE_DATE <= DMD.DUE_DATE)
                             ) NI
                             LEFT OUTER JOIN SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                     ON NI.PLAN_ID  = INC.PLAN_ID
                                    AND NI.STOCK_ID = INC.STOCK_ID
                    ) NI
             GROUP BY PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15;

            -- DUE DATE 가 재고 EFFECTIVE DATE 보다 빠른 것 중, 위에서 넣지 않은 것만 한 번 더 넣어 줌
            INSERT INTO GT_INCS_INC
            (
                PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15
            )
            SELECT  NI.PLAN_ID
                  , NI.STOCK_ID
                  , NI.BUFFER_ID
                  , NI.EFFECTIVE_DATE
                  , NI.TYPE
                  , SUM(NI.QUANTITY) AS QUANTITY
                  , NI.ATTRIBUTE1
                  , NI.ATTRIBUTE2
                  , NI.ATTRIBUTE3
                  , NI.ATTRIBUTE4
                  , NI.ATTRIBUTE5
                  , NI.ATTRIBUTE15
              FROM  (
                     SELECT  NI.PLAN_ID
                           , NI.STOCK_ID
                           , NI.BUFFER_ID
                           , NI.EFFECTIVE_DATE
                           , NI.TYPE
                           , CAST(NI.QUANTITY AS NUMBER(20,10)) + CAST(NVL(INC.QUANTITY, 0) AS NUMBER(20,10)) AS QUANTITY
                           , NI.ATTRIBUTE1
                           , NI.ATTRIBUTE2
                           , NI.ATTRIBUTE3
                           , NI.ATTRIBUTE4
                           , NI.ATTRIBUTE5
                           , NI.ATTRIBUTE15
                       FROM  (
                              SELECT  INC.PLAN_ID                                                                                                                  AS PLAN_ID
                                    , INC.TYPE || '::' || INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || DM1.ATTRIBUTE4 || '@' || DM1.ATTRIBUTE5 || '::' || INC.EFFECTIVE_DATE AS STOCK_ID
                                    , INC.STOCK_ID                                                                                                                 AS BF_STOCK_ID
                                    , INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || DM1.ATTRIBUTE4 || '@' || DM1.ATTRIBUTE5         AS BUFFER_ID
                                    , INC.EFFECTIVE_DATE  AS EFFECTIVE_DATE
                                    , INC.TYPE            AS TYPE
                                    , INC.QUANTITY        AS QUANTITY
                                    , INC.ATTRIBUTE1      AS ATTRIBUTE1
                                    , INC.ATTRIBUTE2      AS ATTRIBUTE2
                                    , INC.ATTRIBUTE3      AS ATTRIBUTE3
                                    , DM1.ATTRIBUTE4      AS ATTRIBUTE4
                                    , DM1.ATTRIBUTE5      AS ATTRIBUTE5
                                    , 'INCOTERMS_ADJUST'  AS ATTRIBUTE15
                                FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                      LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM1
                                              ON INC.PLAN_ID    = DM1.PLAN_ID
                                             AND INC.ATTRIBUTE1 = DM1.ATTRIBUTE1
                                             AND INC.ATTRIBUTE2 = DM1.ATTRIBUTE2
                                             AND INC.ATTRIBUTE4 <> DM1.ATTRIBUTE4
                                             AND INC.EFFECTIVE_DATE > DM1.DUE_DATE
                                      INNER JOIN (
                                                  SELECT  DM.PLAN_ID
                                                        , DM.ATTRIBUTE1
                                                        , DM.ATTRIBUTE2
                                                        , DM.ATTRIBUTE4
                                                        , DM.ATTRIBUTE5
                                                        , MIN(DUE_DATE) AS DUE_DATE
                                                    FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                                          LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM
                                                                  ON INC.PLAN_ID    = DM.PLAN_ID
                                                                 AND INC.ATTRIBUTE1 = DM.ATTRIBUTE1
                                                                 AND INC.ATTRIBUTE2 = DM.ATTRIBUTE2
                                                                 AND INC.ATTRIBUTE4 <> DM.ATTRIBUTE4
                                                                 AND INC.EFFECTIVE_DATE > DM.DUE_DATE
                                                   WHERE  DM.PLAN_ID = V_PLAN_ID
                                                   GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                                 ) DM2
                                              ON DM1.PLAN_ID    = DM2.PLAN_ID
                                             AND DM1.ATTRIBUTE1 = DM2.ATTRIBUTE1
                                             AND DM1.ATTRIBUTE2 = DM2.ATTRIBUTE2
                                             AND DM1.ATTRIBUTE4 = DM2.ATTRIBUTE4
                                             AND DM1.ATTRIBUTE5 = DM2.ATTRIBUTE5
                                             AND DM1.DUE_DATE   = DM2.DUE_DATE
                               WHERE  INC.PLAN_ID = V_PLAN_ID
                                 AND  INC.TYPE    = 'INT'
                                 AND  DM1.DEMAND_ID IS NOT NULL
                                 AND  NOT EXISTS (SELECT 1
                                                    FROM SCP_OPT_ENG_DEMAND_SN DMD
                                                   WHERE DMD.PLAN_ID    = V_PLAN_ID
                                                     AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                                     AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                                     AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                                     AND INC.EFFECTIVE_DATE > DMD.DUE_DATE)
                             ) NI
                             LEFT OUTER JOIN SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                     ON NI.PLAN_ID  = INC.PLAN_ID
                                    AND NI.STOCK_ID = INC.STOCK_ID
                             -- DUE 가 EFFECTIVE 보다 느린 것이 없는 것만 넣음
                             LEFT OUTER JOIN GT_INCS_INC IT
                                     ON NI.PLAN_ID  = IT.PLAN_ID
                                    AND NI.STOCK_ID = IT.STOCK_ID
                      WHERE  IT.PLAN_ID IS NULL
                    ) NI
             GROUP BY NI.PLAN_ID, NI.STOCK_ID, NI.BUFFER_ID, NI.EFFECTIVE_DATE, NI.TYPE, NI.ATTRIBUTE1, NI.ATTRIBUTE2, NI.ATTRIBUTE3, NI.ATTRIBUTE4, NI.ATTRIBUTE5, NI.ATTRIBUTE15;

            -- 기존 STOCK_ID 삭제 대상 수집
            INSERT INTO GT_INCS_INC_DEL
            (
                PLAN_ID, BF_STOCK_ID
            )
            SELECT  NI.PLAN_ID
                  , NI.BF_STOCK_ID
              FROM  (
                     SELECT  INC.PLAN_ID                                                                                                                  AS PLAN_ID
                           , INC.TYPE || '::' || INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || INC.ATTRIBUTE4 || '@' || INC.ATTRIBUTE5 || '::' || INC.EFFECTIVE_DATE AS STOCK_ID
                           , INC.STOCK_ID                                                                                                                 AS BF_STOCK_ID
                           , INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || INC.ATTRIBUTE4 || '@' || INC.ATTRIBUTE5         AS BUFFER_ID
                           , INC.EFFECTIVE_DATE  AS EFFECTIVE_DATE
                           , INC.TYPE            AS TYPE
                           , INC.QUANTITY        AS QUANTITY
                           , INC.ATTRIBUTE1      AS ATTRIBUTE1
                           , INC.ATTRIBUTE2      AS ATTRIBUTE2
                           , INC.ATTRIBUTE3      AS ATTRIBUTE3
                           , DM1.ATTRIBUTE4      AS ATTRIBUTE4
                           , DM1.ATTRIBUTE5      AS ATTRIBUTE5
                           , 'INCOTERMS_ADJUST'  AS ATTRIBUTE15
                       FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                             LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM1
                                     ON INC.PLAN_ID    = DM1.PLAN_ID
                                    AND INC.ATTRIBUTE1 = DM1.ATTRIBUTE1
                                    AND INC.ATTRIBUTE2 = DM1.ATTRIBUTE2
                                    AND INC.ATTRIBUTE4 <> DM1.ATTRIBUTE4
                                    AND INC.EFFECTIVE_DATE <= DM1.DUE_DATE
                             INNER JOIN (
                                         SELECT  DM.PLAN_ID
                                               , DM.ATTRIBUTE1
                                               , DM.ATTRIBUTE2
                                               , DM.ATTRIBUTE4
                                               , DM.ATTRIBUTE5
                                               , MIN(DUE_DATE) AS DUE_DATE
                                           FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                                 LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM
                                                         ON INC.PLAN_ID    = DM.PLAN_ID
                                                        AND INC.ATTRIBUTE1 = DM.ATTRIBUTE1
                                                        AND INC.ATTRIBUTE2 = DM.ATTRIBUTE2
                                                        AND INC.ATTRIBUTE4 <> DM.ATTRIBUTE4
                                                        AND INC.EFFECTIVE_DATE <= DM.DUE_DATE
                                          WHERE  DM.PLAN_ID = V_PLAN_ID
                                          GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                        ) DM2
                                     ON DM1.PLAN_ID    = DM2.PLAN_ID
                                    AND DM1.ATTRIBUTE1 = DM2.ATTRIBUTE1
                                    AND DM1.ATTRIBUTE2 = DM2.ATTRIBUTE2
                                    AND DM1.ATTRIBUTE4 = DM2.ATTRIBUTE4
                                    AND DM1.ATTRIBUTE5 = DM2.ATTRIBUTE5
                                    AND DM1.DUE_DATE   = DM2.DUE_DATE
                      WHERE  INC.PLAN_ID = V_PLAN_ID
                        AND  INC.TYPE    = 'INT'
                        AND  DM1.DEMAND_ID IS NOT NULL
                        AND  NOT EXISTS (SELECT 1
                                           FROM SCP_OPT_ENG_DEMAND_SN DMD
                                          WHERE DMD.PLAN_ID    = V_PLAN_ID
                                            AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                            AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                            AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                            AND INC.EFFECTIVE_DATE <= DMD.DUE_DATE)
                     ) NI
                     LEFT OUTER JOIN SCP_OPT_ENG_INCOMING_STOCK_SN INC
                             ON NI.PLAN_ID  = INC.PLAN_ID
                            AND NI.STOCK_ID = INC.STOCK_ID;

            -- DUE DATE 가 재고 EFFECTIVE DATE 보다 빠른 것을 한 번 더 확인하여 넣어 줌
            INSERT INTO GT_INCS_INC_DEL
            (
                PLAN_ID, BF_STOCK_ID
            )
            SELECT  NI.PLAN_ID
                  , NI.BF_STOCK_ID
              FROM  (
                     SELECT  INC.PLAN_ID                                                                                                                  AS PLAN_ID
                           , INC.TYPE || '::' || INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || INC.ATTRIBUTE4 || '@' || INC.ATTRIBUTE5 || '::' || INC.EFFECTIVE_DATE AS STOCK_ID
                           , INC.STOCK_ID                                                                                                                 AS BF_STOCK_ID
                           , INC.ATTRIBUTE1 || '::' || INC.ATTRIBUTE2 || '::' || INC.ATTRIBUTE3 || '@' || INC.ATTRIBUTE4 || '@' || INC.ATTRIBUTE5         AS BUFFER_ID
                           , INC.EFFECTIVE_DATE  AS EFFECTIVE_DATE
                           , INC.TYPE            AS TYPE
                           , INC.QUANTITY        AS QUANTITY
                           , INC.ATTRIBUTE1      AS ATTRIBUTE1
                           , INC.ATTRIBUTE2      AS ATTRIBUTE2
                           , INC.ATTRIBUTE3      AS ATTRIBUTE3
                           , DM1.ATTRIBUTE4      AS ATTRIBUTE4
                           , DM1.ATTRIBUTE5      AS ATTRIBUTE5
                           , 'INCOTERMS_ADJUST'  AS ATTRIBUTE15
                       FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                             LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM1
                                     ON INC.PLAN_ID    = DM1.PLAN_ID
                                    AND INC.ATTRIBUTE1 = DM1.ATTRIBUTE1
                                    AND INC.ATTRIBUTE2 = DM1.ATTRIBUTE2
                                    AND INC.ATTRIBUTE4 <> DM1.ATTRIBUTE4
                                    AND INC.EFFECTIVE_DATE > DM1.DUE_DATE
                             INNER JOIN (
                                         SELECT  DM.PLAN_ID
                                               , DM.ATTRIBUTE1
                                               , DM.ATTRIBUTE2
                                               , DM.ATTRIBUTE4
                                               , DM.ATTRIBUTE5
                                               , MIN(DUE_DATE) AS DUE_DATE
                                           FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                                 LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM
                                                         ON INC.PLAN_ID    = DM.PLAN_ID
                                                        AND INC.ATTRIBUTE1 = DM.ATTRIBUTE1
                                                        AND INC.ATTRIBUTE2 = DM.ATTRIBUTE2
                                                        AND INC.ATTRIBUTE4 <> DM.ATTRIBUTE4
                                                        AND INC.EFFECTIVE_DATE > DM.DUE_DATE
                                          WHERE  DM.PLAN_ID = V_PLAN_ID
                                          GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                        ) DM2
                                     ON DM1.PLAN_ID    = DM2.PLAN_ID
                                    AND DM1.ATTRIBUTE1 = DM2.ATTRIBUTE1
                                    AND DM1.ATTRIBUTE2 = DM2.ATTRIBUTE2
                                    AND DM1.ATTRIBUTE4 = DM2.ATTRIBUTE4
                                    AND DM1.ATTRIBUTE5 = DM2.ATTRIBUTE5
                                    AND DM1.DUE_DATE   = DM2.DUE_DATE
                      WHERE  INC.PLAN_ID = V_PLAN_ID
                        AND  INC.TYPE    = 'INT'
                        AND  DM1.DEMAND_ID IS NOT NULL
                        AND  NOT EXISTS (SELECT 1
                                           FROM SCP_OPT_ENG_DEMAND_SN DMD
                                          WHERE DMD.PLAN_ID    = V_PLAN_ID
                                            AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                            AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                            AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                            AND INC.EFFECTIVE_DATE > DMD.DUE_DATE)
                     ) NI
                     LEFT OUTER JOIN SCP_OPT_ENG_INCOMING_STOCK_SN INC
                             ON NI.PLAN_ID  = INC.PLAN_ID
                            AND NI.STOCK_ID = INC.STOCK_ID
                     -- DUE 가 EFFECTIVE 보다 느린 것이 없는 것만 넣음
                     LEFT OUTER JOIN GT_INCS_INC_DEL IT
                             ON NI.PLAN_ID     = IT.PLAN_ID
                            AND NI.BF_STOCK_ID = IT.BF_STOCK_ID
              WHERE  IT.PLAN_ID IS NULL;

            -- KEY 중복 방지를 위해 MERGE 사용
            MERGE INTO SCP_OPT_ENG_INCOMING_STOCK_SN INC
            USING GT_INCS_INC IT
               ON (    INC.PLAN_ID  = IT.PLAN_ID
                   AND INC.STOCK_ID = IT.STOCK_ID)
            WHEN MATCHED THEN
                UPDATE SET INC.QUANTITY    = IT.QUANTITY
                         , INC.ATTRIBUTE15 = IT.ATTRIBUTE15
            WHEN NOT MATCHED THEN
                INSERT (PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15)
                VALUES (IT.PLAN_ID, IT.STOCK_ID, IT.BUFFER_ID, IT.EFFECTIVE_DATE, IT.TYPE, IT.QUANTITY, IT.ATTRIBUTE1, IT.ATTRIBUTE2, IT.ATTRIBUTE3, IT.ATTRIBUTE4, IT.ATTRIBUTE5, IT.ATTRIBUTE15);

            -- 기존 STOCK_ID 삭제
            DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_SN
             WHERE EXISTS (SELECT 1
                             FROM GT_INCS_INC_DEL IT
                            WHERE IT.PLAN_ID     = SCP_OPT_ENG_INCOMING_STOCK_SN.PLAN_ID
                              AND IT.BF_STOCK_ID = SCP_OPT_ENG_INCOMING_STOCK_SN.STOCK_ID);
        END IF;

        ----------------------------------------------------
        -- 2nd OCV 재고 계산
        -- 20251028 / T.H.KIM / HOLD 재고 반영을 위해 10/27 주차는 계산 로직 주석처리
        ----------------------------------------------------
        V_FP_INV_CUTOFF_DATE := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

        -- 1ST OCV, 2ND OCV 를 모두 하는 경우 계산 (현재 미사용 - 원본 주석 유지)
        /* INSERT INTO @OCV_ALL_SUB_TEMP
           SELECT MS.SCM_SITE_ID, MS.PLANT_ID, LU.SEGMENT5, BOM.CHILD_ITEM_ID, LU.ATTRIBUTE3, LU.ATTRIBUTE6, LU.ATTRIBUTE7, LU.ATTRIBUTE8, LU.ATTRIBUTE4, LU.ATTRIBUTE9
             FROM SCM_MST_BOM_SN_V BOM INNER JOIN SCM_MST_SITE MS ... INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU ...
            WHERE LU.ATTRIBUTE1='B' AND LU.ATTRIBUTE9!='' ... (SCP_OPT_ENG_CONST_SECOND_OCV_MASTER 기준) */

        SELECT MAX(ROW_NUM) INTO V_1ST_MAX_ROW_NUM FROM GT_INCS_OCV_ALL_SUB;

        WHILE V_1ST_ROW_NUM <= V_1ST_MAX_ROW_NUM
        LOOP
            -- 현재 행 데이터 읽기
            SELECT  SCM_SITE_ID
                  , PLANT_ID
                  , ORI_ITEM_ID
                  , CHILD_ITEM_ID
                  , STAGE
                  , LT
                  , YIELD
                  , FAIL_RATIO
                  , OCV_NUMBER
                  , SECOND_OCV_TIME
              INTO  V_1ST_SCM_SITE_ID
                  , V_1ST_PLANT_ID
                  , V_1ST_ORI_ITEM_ID
                  , V_1ST_CHILD_ITEM_ID
                  , V_1ST_STAGE
                  , V_1ST_LT
                  , V_1ST_YIELD
                  , V_1ST_FAIL_RATIO
                  , V_1ST_OCV_NUMBER
                  , V_1ST_SECOND_OCV_TIME
              FROM  GT_INCS_OCV_ALL_SUB
             WHERE  ROW_NUM = V_1ST_ROW_NUM;

            -- CHILD_ITEM_ID 가 바뀌면 누적 FAIL_RATIO 초기화
            -- 1ST OCV 는 LT 와 합격률만 먹이고 실제 MDLE 제품이 만들어지진 않음
            IF V_1ST_PREV_CHILD IS NULL OR V_1ST_PREV_CHILD <> V_1ST_CHILD_ITEM_ID THEN
                V_1ST_CUR_CUM_FAIL_RATIO := V_1ST_YIELD;
                V_1ST_CUM_FAIL_RATIO     := V_1ST_YIELD;
                V_1ST_CUM_LT             := V_1ST_LT;
            -- 2ND OCV 적용
            ELSE
                V_1ST_CUR_CUM_FAIL_RATIO := V_1ST_CUM_FAIL_RATIO;
                V_1ST_FINAL_VALUE        := V_1ST_YIELD * V_1ST_CUR_CUM_FAIL_RATIO;
                V_1ST_CUM_LT             := V_1ST_CUM_LT + V_1ST_LT;
                -- 결과 저장
                INSERT INTO GT_INCS_OCV_INV_MST
                (
                    SCM_SITE_ID, PLANT_ID, ORI_ITEM_ID, CHILD_ITEM_ID, STAGE, LT, YIELD, FAIL_RATIO, OCV_NUMBER, SECOND_OCV_TIME, CUM_FAIL_RATIO_BEFORE, CUM_LT, FINAL_VALUE, NUM_DIV, INS_NUM
                )
                VALUES (V_1ST_SCM_SITE_ID
                      , V_1ST_PLANT_ID
                      , V_1ST_ORI_ITEM_ID
                      , V_1ST_CHILD_ITEM_ID
                      , V_1ST_STAGE
                      , V_1ST_LT
                      , V_1ST_YIELD
                      , V_1ST_FAIL_RATIO
                      , V_1ST_OCV_NUMBER
                      , 0 -- 1ST OCV 대상은 SECOND_OCV_TIME 무조건 0
                      , V_1ST_CUR_CUM_FAIL_RATIO
                      , V_1ST_CUM_LT
                      , V_1ST_FINAL_VALUE
                      , '1'
                      , V_1ST_SECOND_OCV_TIME
                       );
                -- 누적 FAIL_RATIO 갱신 (다음 행을 위해)
                V_1ST_CUM_FAIL_RATIO := V_1ST_CUM_FAIL_RATIO * V_1ST_FAIL_RATIO;
            END IF;
            V_1ST_PREV_CHILD := V_1ST_CHILD_ITEM_ID;
            V_1ST_ROW_NUM    := V_1ST_ROW_NUM + 1;
        END LOOP;

        -- 2ND OCV 만 하는 경우 계산 (현재 미사용 - 원본 주석 유지)
        /* INSERT INTO @OCV_2ND_SUB_TEMP
           SELECT ... FROM SCM_MST_BOM_SN_V BOM INNER JOIN SCM_MST_SITE MS ... INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU ...
            WHERE LU.ATTRIBUTE1='B' AND LU.ATTRIBUTE4!='1' AND LU.ATTRIBUTE9!='' ... */

        SELECT MAX(ROW_NUM) INTO V_2ND_MAX_ROW_NUM FROM GT_INCS_OCV_2ND_SUB;

        -- 1차 루프 시작
        WHILE V_2ND_ROW_NUM <= V_2ND_MAX_ROW_NUM
        LOOP
            -- 2차 루프 돌리기 위한 SUB ROW NUM
            V_2ND_SUB_ROW_NUM := V_2ND_ROW_NUM;

            -- 2차 루프 시작
            WHILE V_2ND_INS_NUM <= V_2ND_MAX_INS_NUM
            LOOP
                -- 현재 행 데이터 읽기
                SELECT  SCM_SITE_ID
                      , PLANT_ID
                      , ORI_ITEM_ID
                      , CHILD_ITEM_ID
                      , STAGE
                      , LT
                      , YIELD
                      , FAIL_RATIO
                      , OCV_NUMBER
                      , SECOND_OCV_TIME
                  INTO  V_2ND_SCM_SITE_ID
                      , V_2ND_PLANT_ID
                      , V_2ND_ORI_ITEM_ID
                      , V_2ND_CHILD_ITEM_ID
                      , V_2ND_STAGE
                      , V_2ND_LT
                      , V_2ND_YIELD
                      , V_2ND_FAIL_RATIO
                      , V_2ND_OCV_NUMBER
                      , V_2ND_INS_NUM
                  FROM  GT_INCS_OCV_2ND_SUB
                 WHERE  ROW_NUM = V_2ND_SUB_ROW_NUM;

                IF V_2ND_PREV_CHILD IS NULL OR V_2ND_PREV_CHILD <> V_2ND_CHILD_ITEM_ID OR V_2ND_INS_NUM = V_2ND_SECOND_OCV_TIME THEN
                    V_2ND_CUM_FAIL_RATIO := 1;
                    V_2ND_CUM_LT         := 0;
                END IF;

                V_2ND_CUR_CUM_FAIL_RATIO := V_2ND_CUM_FAIL_RATIO;
                V_2ND_FINAL_VALUE        := V_2ND_YIELD * V_2ND_CUR_CUM_FAIL_RATIO;
                V_2ND_CUM_LT             := V_2ND_CUM_LT + V_2ND_LT;

                -- 결과 저장
                INSERT INTO GT_INCS_OCV_INV_MST
                (
                    SCM_SITE_ID, PLANT_ID, ORI_ITEM_ID, CHILD_ITEM_ID, STAGE, LT, YIELD, FAIL_RATIO, OCV_NUMBER, SECOND_OCV_TIME, CUM_FAIL_RATIO_BEFORE, CUM_LT, FINAL_VALUE, NUM_DIV, INS_NUM
                )
                VALUES (V_2ND_SCM_SITE_ID
                      , V_2ND_PLANT_ID
                      , V_2ND_ORI_ITEM_ID
                      , V_2ND_CHILD_ITEM_ID
                      , V_2ND_STAGE
                      , V_2ND_LT
                      , V_2ND_YIELD
                      , V_2ND_FAIL_RATIO
                      , V_2ND_OCV_NUMBER
                      , V_2ND_SECOND_OCV_TIME
                      , V_2ND_CUR_CUM_FAIL_RATIO
                      , V_2ND_CUM_LT
                      , V_2ND_FINAL_VALUE
                      , '2'
                      , V_2ND_INS_NUM
                       );
                -- 누적 FAIL_RATIO 갱신 (다음 행을 위해)
                V_2ND_CUM_FAIL_RATIO := V_2ND_CUM_FAIL_RATIO * V_2ND_FAIL_RATIO;
                V_2ND_PREV_CHILD     := V_2ND_CHILD_ITEM_ID;
                V_2ND_INS_NUM        := V_2ND_INS_NUM + 1;
                V_2ND_SUB_ROW_NUM    := V_2ND_SUB_ROW_NUM + 1;
            END LOOP;
            -- 2차 루프 끝
            V_2ND_ROW_NUM := V_2ND_ROW_NUM + 1;
        END LOOP;
        -- 1차 루프 끝

        -- FP 재고 계산  (2025.11.04 Minyong Lee : 2ND OCV WORKBENCH 적용)
        INSERT INTO GT_INCS_OCV_INV
        (
            PLANT_ID
          , ITEM_ID
          , AVAILABLE_DATE
          , QTY
          , NUM_DIV
          , SECOND_OCV_TIME
          , STOCK_TYPE
        )
        SELECT  PLANT_ID
              , ITEM_ID
              , AVAILABLE_DATE
              , SUM(QTY) AS QTY
              , NUM_DIV
              , SECOND_OCV_TIME
              , MAX(STOCK_TYPE)
          FROM  (
                 SELECT  FI.PLANT_ID        AS PLANT_ID
                       , FI.MES_ITEM_ID     AS ITEM_ID
                       , TO_CHAR(NVL(FI.SECOND_OCV_EXP_DATE, TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')), 'YYYYMMDD') AS AVAILABLE_DATE
                       , SUM(NVL(WB.CHG_QTY, FI.QTY)) AS QTY -- 2ND OCV WORKBENCH 적용
                       , FI.MES_OPERATION_ID  AS OPERATION_ID
                       , CASE WHEN FI.MES_OPERATION_ID = 'P5000'                                                                        THEN '0' -- P5000 이면 즉가용 재고
                              WHEN FI.MES_OPERATION_ID != 'P5000' AND (FI.MES_OPERATION_ID <= 'P5300' OR FI.MES_OPERATION_ID = 'PR000')  THEN '1' -- P5300 이하 OR PR000 공정은 1ST OCV 부터 계산
                              WHEN FI.MES_OPERATION_ID = 'P5400'                                                                        THEN '2' -- P5400 공정만 2ND OCV 재고 계산
                              ELSE '0' -- 상기 케이스가 아니면 즉가용 재고
                         END AS NUM_DIV
                       , NVL(FI.SECOND_OCV_TIME, 0) AS SECOND_OCV_TIME
                       , MAX(WB.STOCK_TYPE)   AS STOCK_TYPE
                   FROM  SCM_DNM_STOCK_SN FI
                         INNER JOIN (SELECT  PLANT_ID
                                           , CHILD_ITEM_ID
                                       FROM  GT_INCS_OCV_INV_MST
                                      GROUP BY PLANT_ID, CHILD_ITEM_ID
                                    ) IM
                                 ON FI.PLANT_ID    = IM.PLANT_ID
                                AND FI.MES_ITEM_ID = IM.CHILD_ITEM_ID
                         -- 2ND OCV WORKBENCH 적용
                         LEFT JOIN SCP_OPMZ_INV_SECOND_OCV WB
                                 ON 1 = 1
                                AND FI.DIVISION_ID = WB.DIVISION_ID
                                AND TO_CHAR(FI.CUTOFF_DATE, 'YYYYMMDD') = WB.CUTOFF_YYYYMMDD
                                AND FI.PLANT_ID = WB.PLANT_ID
                                AND FI.ITEM_ID  = WB.ITEM_ID
                                AND FI.MES_OPERATION_ID = WB.OPERATION_ID
                                AND NVL(TO_CHAR(FI.SECOND_OCV_TIME), '') = WB.SECOND_OCV_TIME
                                AND NVL(TO_CHAR(FI.SECOND_OCV_EXP_DATE, 'YYYYMMDD'), '') = WB.SECOND_OCV_DATE
                  WHERE  FI.CUTOFF_DATE       = TO_DATE(V_FP_INV_CUTOFF_DATE, 'YYYYMMDD')
                    AND  FI.PRODUCTION_TYPE  != 'D-SAMPLE'
                    AND  FI.MES_OPERATION_ID != 'PS000'
                  GROUP BY FI.PLANT_ID, FI.MES_ITEM_ID, FI.SECOND_OCV_EXP_DATE, FI.MES_OPERATION_ID, FI.SECOND_OCV_TIME
                ) FI
         GROUP BY PLANT_ID, ITEM_ID, AVAILABLE_DATE, NUM_DIV, SECOND_OCV_TIME;

        -- 기존에 있던 MDLE 재고도 반영해야 하기 때문에 MERGE 사용
        MERGE INTO SCP_OPT_ENG_INCOMING_STOCK_SN INC
        USING (
                SELECT  V_PLAN_ID                                                               AS PLAN_ID
                      , 'WH' || '::' || SCM_SITE_ID || '::' || ORI_ITEM_ID || '::' || STAGE || '::' || EFFECTIVE_DATE AS STOCK_ID
                      , SCM_SITE_ID || '::' || ORI_ITEM_ID || '::' || STAGE                     AS BUFFER_ID
                      , EFFECTIVE_DATE                                                          AS EFFECTIVE_DATE
                      , TYPE                                                                    AS TYPE
                      , SUM(QTY)                                                                AS QUANTITY
                      , ATTRIBUTE1                                                              AS ATTRIBUTE1
                      , ATTRIBUTE2                                                              AS ATTRIBUTE2
                      , ATTRIBUTE3                                                              AS ATTRIBUTE3
                  FROM  (
                         SELECT  CASE WHEN EFFECTIVE_DATE < V_PLAN_START_YYYYMMDD THEN V_PLAN_START_YYYYMMDD
                                      WHEN EFFECTIVE_DATE > V_PLAN_END_YYYYMMDD   THEN V_PLAN_END_YYYYMMDD
                                      ELSE EFFECTIVE_DATE
                                 END AS EFFECTIVE_DATE
                               , SCM_SITE_ID
                               , ORI_ITEM_ID
                               , STAGE
                               , TYPE
                               , SUM(QTY) AS QTY
                               , ATTRIBUTE1
                               , ATTRIBUTE2
                               , ATTRIBUTE3
                           FROM  (
                                  SELECT  TO_CHAR(TO_DATE(AVAILABLE_DATE, 'YYYYMMDD') + CUM_LT, 'YYYYMMDD') AS EFFECTIVE_DATE
                                        , NVL(IT.STOCK_TYPE, 'WH')                               AS TYPE -- 2ND OCV WORKBENCH 적용
                                        , CAST(ROUND(QTY * FINAL_VALUE, 5) AS NUMBER(20,5))      AS QTY
                                        , MT.SCM_SITE_ID                                         AS SCM_SITE_ID
                                        , MT.ORI_ITEM_ID                                         AS ORI_ITEM_ID
                                        , MT.STAGE                                               AS STAGE
                                        , MT.SCM_SITE_ID                                         AS ATTRIBUTE1
                                        , MT.ORI_ITEM_ID                                         AS ATTRIBUTE2
                                        , MT.STAGE                                               AS ATTRIBUTE3
                                    FROM  GT_INCS_OCV_INV IT
                                          INNER JOIN GT_INCS_OCV_INV_MST MT
                                                  ON IT.PLANT_ID = MT.PLANT_ID
                                                 AND IT.ITEM_ID  = MT.CHILD_ITEM_ID
                                                 AND IT.NUM_DIV  = MT.NUM_DIV
                                                 AND IT.SECOND_OCV_TIME = MT.SECOND_OCV_TIME
                                                 AND IT.SECOND_OCV_TIME <= MT.INS_NUM
                                   WHERE  1 = 1
                                     AND  CAST(ROUND(QTY * FINAL_VALUE, 5) AS NUMBER(20,5)) > 0
                                  -- NUM_DIV 가 0 인 경우 즉가용 재고로 INSERT
                                  UNION ALL
                                  SELECT  V_PLAN_START_YYYYMMDD                                  AS EFFECTIVE_DATE
                                        , 'WH'                                                   AS TYPE
                                        , CAST(IT.QTY AS NUMBER(20,5))                           AS QTY
                                        , MT.SCM_SITE_ID                                         AS SCM_SITE_ID
                                        , MT.ORI_ITEM_ID                                         AS ORI_ITEM_ID
                                        , MT.STAGE                                               AS STAGE
                                        , MT.SCM_SITE_ID                                         AS ATTRIBUTE1
                                        , MT.ORI_ITEM_ID                                         AS ATTRIBUTE2
                                        , MT.STAGE                                               AS ATTRIBUTE3
                                    FROM  GT_INCS_OCV_INV IT
                                          INNER JOIN (SELECT  SCM_SITE_ID
                                                            , PLANT_ID
                                                            , ORI_ITEM_ID
                                                            , CHILD_ITEM_ID
                                                            , STAGE
                                                        FROM  GT_INCS_OCV_INV_MST
                                                       GROUP BY SCM_SITE_ID, PLANT_ID, ORI_ITEM_ID, CHILD_ITEM_ID, STAGE
                                                     ) MT
                                                  ON IT.PLANT_ID = MT.PLANT_ID
                                                 AND IT.ITEM_ID  = MT.CHILD_ITEM_ID
                                   WHERE  IT.NUM_DIV = 0
                                 ) OCV
                          WHERE  OCV.EFFECTIVE_DATE < V_PLAN_END_YYYYMMDD -- 2nd OCV 계획구간 내 재고만
                          GROUP BY SCM_SITE_ID, ORI_ITEM_ID, STAGE, EFFECTIVE_DATE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
                        ) OCV
                 GROUP BY SCM_SITE_ID, ORI_ITEM_ID, STAGE, EFFECTIVE_DATE, TYPE, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3
              ) OCV
           ON (    INC.PLAN_ID  = OCV.PLAN_ID
               AND INC.STOCK_ID = OCV.STOCK_ID)
        WHEN MATCHED THEN
            UPDATE SET INC.QUANTITY = INC.QUANTITY + OCV.QUANTITY
        WHEN NOT MATCHED THEN
            INSERT (PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3)
            VALUES (OCV.PLAN_ID, OCV.STOCK_ID, OCV.BUFFER_ID, OCV.EFFECTIVE_DATE, OCV.TYPE, OCV.QUANTITY, OCV.ATTRIBUTE1, OCV.ATTRIBUTE2, OCV.ATTRIBUTE3);

        -- 2026.04.08 Minyong Lee : 법인간 이동 재고 BUFFER_ID, STOCK_ID 생성 규칙 수정, INCOTERMS / PROJECT_CODE 제거
        INSERT INTO GT_INCS_COMPANY_INT
        (
            PLAN_ID, STOCK_ID, BUFFER_ID, EFFECTIVE_DATE, TYPE, QUANTITY, ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE15
        )
        SELECT  A.PLAN_ID
              , A.TYPE || '::' || A.ATTRIBUTE1 || '::' || A.ATTRIBUTE2 || '::' || A.ATTRIBUTE3 || '::' || A.EFFECTIVE_DATE AS STOCK_ID
              , A.ATTRIBUTE1 || '::' || A.ATTRIBUTE2 || '::' || A.ATTRIBUTE3                     AS BUFFER_ID
              , A.EFFECTIVE_DATE
              , A.TYPE
              , SUM(A.QUANTITY) AS QUANTITY
              , A.ATTRIBUTE1
              , A.ATTRIBUTE2
              , A.ATTRIBUTE3
              , '-'  AS ATTRIBUTE4
              , ''   AS ATTRIBUTE5
              , A.ATTRIBUTE15
          FROM  (
                 SELECT  PLAN_ID
                       , EFFECTIVE_DATE
                       , TYPE
                       , QUANTITY
                       , ATTRIBUTE1
                       , ATTRIBUTE2
                       , ATTRIBUTE3
                       , ATTRIBUTE15
                   FROM  SCP_OPT_ENG_INCOMING_STOCK_SN
                  WHERE  PLAN_ID = V_PLAN_ID
                    AND  STOCK_ID LIKE 'INT%'
                    AND  ATTRIBUTE3 NOT LIKE '%BIZ'
                ) A
         GROUP BY A.PLAN_ID, A.EFFECTIVE_DATE, A.TYPE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE15;

        DELETE FROM SCP_OPT_ENG_INCOMING_STOCK_SN
         WHERE PLAN_ID = V_PLAN_ID
           AND STOCK_ID LIKE 'INT%'
           AND ATTRIBUTE3 NOT LIKE '%BIZ';

        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN
        (
            PLAN_ID
          , STOCK_ID
          , BUFFER_ID
          , EFFECTIVE_DATE
          , TYPE
          , QUANTITY
          , ATTRIBUTE1
          , ATTRIBUTE2
          , ATTRIBUTE3
          , ATTRIBUTE4
          , ATTRIBUTE5
          , ATTRIBUTE15
        )
        SELECT  PLAN_ID
              , STOCK_ID
              , BUFFER_ID
              , EFFECTIVE_DATE
              , TYPE
              , QUANTITY
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3
              , ATTRIBUTE4
              , ATTRIBUTE5
              , ATTRIBUTE15
          FROM  GT_INCS_COMPANY_INT;

        ------------------------------------------------------------------------
        -- Data Insert End / 임시 데이터 정리
        ------------------------------------------------------------------------
        DELETE FROM GT_INCS_SCP_INV;
        DELETE FROM GT_INCS_SCP_INT;
        DELETE FROM GT_INCS_CP_INFO;
        DELETE FROM GT_INCS_COMPANY_INT;

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
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
    END IF;

END;
