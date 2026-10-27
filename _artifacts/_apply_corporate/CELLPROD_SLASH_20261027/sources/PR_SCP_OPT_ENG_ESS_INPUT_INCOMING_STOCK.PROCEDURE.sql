PROCEDURE PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK
(
     P_PLAN_ID              VARCHAR2
    ,P_DIVISION_ID          VARCHAR2
    ,P_GROUP_ID             VARCHAR2
    ,P_PLAN_START_YYYYMMDD  VARCHAR2
    ,P_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK
 * Description  : ESS Optimization Engine 입력용 Incoming Stock(창고/해상/활성화/자재 입고예정) 생성
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.05    Y.S.H          Initial Release
 * 2026.07.06    ZIONEX         [PJ202650304]  NextSCM Migration
 * ============================================================ */
AS
    /* Set Prameter */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK';
    V_PLAN_ID             VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_DIVISION_ID         VARCHAR2(20 CHAR)   := P_DIVISION_ID;
    V_GROUP_ID            VARCHAR2(20 CHAR)   := P_GROUP_ID;
    V_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR)    := P_PLAN_START_YYYYMMDD;
    V_PLAN_END_YYYYMMDD   VARCHAR2(8 CHAR)    := P_PLAN_END_YYYYMMDD;
    V_MESSAGE_TEXT        VARCHAR2(1000 CHAR);
    V_DETAIL_DATE         DATE;
    /* Set Param for Biz */
    V_P_PLAN_NAME         VARCHAR2(8 CHAR);
    V_P_PLAN_TYPE         VARCHAR2(4000 CHAR);
    V_P_SEQ               VARCHAR2(4000 CHAR);
    V_P_MODELING_ID       VARCHAR2(4000 CHAR);
    V_CUTOFF_DAY          VARCHAR2(8 CHAR);
    V_D_CUTOFF_DAY        DATE;
    V_DEMAND_CUTOFF_DAY   VARCHAR2(8 CHAR);
    V_MAX_TUESDAY         VARCHAR2(8 CHAR);

BEGIN
    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    /* Transaction (START) */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    BEGIN
        /* Get Param Info */
        BEGIN
            SELECT
                   ATTRIBUTE1
                 , ATTRIBUTE2
              INTO V_DIVISION_ID
                 , V_GROUP_ID
              FROM SCP_OPT_ENG_PLAN_MASTER_SN
             WHERE PLAN_ID = V_PLAN_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        SELECT
               MAX(BASIS_YYYYMMDD)
          INTO V_MAX_TUESDAY
          FROM SCM_SYS_CALENDAR_M
         WHERE BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND DAYOFWEEK        = 'TUE';

        BEGIN
            SELECT
                   MODELING_ID
              INTO V_P_MODELING_ID
              FROM SCM_MST_MODELING
             WHERE PLAN_CYCLE  = 'WEEKLY'
               AND DIVISION_ID = V_DIVISION_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        V_P_PLAN_NAME       := V_PLAN_START_YYYYMMDD;                                                  /* 당주 월요일 YYYYMMDD */
        V_CUTOFF_DAY        := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');    /* 지난주 일요일 YYYYMMDD */
        V_D_CUTOFF_DAY      := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');
        V_DEMAND_CUTOFF_DAY := V_MAX_TUESDAY;                                                          /* 당주 화요일 YYYYMMDD */

        /* 자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용 */
        /* SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
           FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
           WHERE  PLAN_ID = @V_PLAN_ID */

        DELETE
          FROM GT_OPTENG_ESSIS_MAT;

        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
        INSERT
          INTO GT_OPTENG_ESSIS_MAT
             ( MAT_ID
             , EFF_END_DATE )
        SELECT ITEM_ID_CHILD AS MAT_ID
             , TO_CHAR(MAX(TO_DATE(TO_YYYYMMDD, 'YYYYMMDD')) + 1, 'YYYYMMDD') AS EFF_END_DATE
          FROM SCP_OPMZ_VIRTUAL_BOM A
             , SCP_OPMZ_PLAN_GR_M   B
         WHERE A.OPMZ_PLAN_GR_ID   = B.OPMZ_PLAN_GR_ID
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND B.OPMZ_PLAN_GR_NAME = V_GROUP_ID
           AND A.VALID_YN          = 'Y'
           AND B.VALID_YN          = 'Y'
         GROUP BY ITEM_ID_CHILD;
        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
        /* -- BLOCKED 2025.11.19 jongykim2
        SELECT   ATTRIBUTE1 AS MAT_ID
                ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
        FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
        AND      LU.VALID_YN    = 'Y'
        AND      LU.SEGMENT2    = @V_DIVISION_ID
        AND      LU.SEGMENT3    = @V_GROUP_ID
        GROUP BY ATTRIBUTE1 */

        /* 2nd OCV에 활용된 SUB MDLE 재고는 제외하기 위해서 */
        DELETE
          FROM GT_OPTENG_ESSIS_OCV;

        INSERT
          INTO GT_OPTENG_ESSIS_OCV
             ( SCM_SITE_ID
             , ITEM_ID )
        SELECT B.SCM_SITE_ID
             , CHILD_ITEM_ID
          FROM SCM_MST_BOM_SN_V             A
             , SCM_MST_SITE                 B
             , SCP_OPMZ_LOOKUP_MASTER_DETAIL C
         WHERE 1 = 1
           AND A.PLANT_ID       = B.PLANT_ID
           AND B.SCM_SITE_ID    = C.SEGMENT4
           AND A.PARENT_ITEM_ID = C.SEGMENT5
           AND C.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
           AND C.VALID_YN       = 'Y'
           AND C.ATTRIBUTE1     = 'B'
           AND C.SEGMENT2       = V_DIVISION_ID
           AND C.SEGMENT3       = V_GROUP_ID
         GROUP BY B.SCM_SITE_ID, CHILD_ITEM_ID;

        /* 셀 생산지 버퍼 추가 */
        DELETE
          FROM GT_OPTENG_ESSIS_CPS;

        INSERT
          INTO GT_OPTENG_ESSIS_CPS
             ( SALES_SITE_ID
             , ITEM_ID
             , OPERATION_GROUP )
        SELECT A.SEGMENT3              AS SALES_SITE_ID
             , A.SEGMENT4              AS ITEM_ID
             , '_'||B.OPERATION_GROUP  AS OPERATION_GROUP
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             , SCP_MST_FINAL_ITEM            B
         WHERE A.SEGMENT1    = B.DIVISION_ID
           AND A.SEGMENT4    = B.ITEM_ID
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND A.SEGMENT1    = V_DIVISION_ID
           AND A.SEGMENT2    = V_GROUP_ID;

        /* 테스트를 위해 25년07주차로 고정 */
        /* SELECT @P_PLAN_NAME         = '20250210'; -- 당주 월요일 YYYYMMDD
           SELECT @V_CUTOFF_DAY        = '20250209'; -- 지난주 일요일 YYYYMMDD
           SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
           SELECT @MAX_TUESDAY         = '20250211'
           SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD */

        /* Data Insert Start */
        /* MSSQL #temp DROP-IF-EXISTS -> Oracle GTT 초기화 DELETE */
        DELETE
          FROM GT_OPTENG_ESSIS_INV;

        DELETE
          FROM GT_OPTENG_ESSIS_INT;

        DELETE
          FROM GT_OPTENG_ESSIS_CP;

        DELETE
          FROM GT_OPTENG_ESSIS_ADJ;

        /* 2025.07.10 Philsu Park: 재고 보정값 반영을 위한 TEMP Input. */
        INSERT
          INTO GT_OPTENG_ESSIS_ADJ
             ( SCM_SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
             , STOCK_TYPE
             , INV_DATE
             , STAGE
             , QTY )
        SELECT A.SCM_SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
             , A.STOCK_TYPE
             , A.INV_DATE
             , CASE WHEN SUBSTR(A.STOCK_TYPE, 1, 3) = 'FOR' THEN 'ASY_AGING'
                    ELSE NVL(C.STAGE, CASE WHEN B.OSP_YN = 'Y' THEN 'CHAR' ELSE NULL END)
               END AS STAGE
             /* , ADJ.QTY */
             , A.CHG_QTY AS QTY
          FROM SCP_OPMZ_INV_ADJ A
             , SCM_MST_SITE     B
             , (
                SELECT SCM_SITE_ID
                     , ITEM_ID
                     , STAGE
                     /* , MIN(STAGE) AS STAGE  -- ASSY, ASY_AGING 이 ITEM 이 겹치므로 하나만 나오게 처리. */
                     /* , IIF(STAGE = 'ASY_AGING', 'FOR', 'X') AS INV_TYPE */
                  FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                 WHERE PLAN_ID = V_PLAN_ID
                   AND STAGE  != 'ASY_AGING'
                 GROUP BY SCM_SITE_ID
                        , ITEM_ID
                        , STAGE
               ) C
         WHERE B.DIVISION_ID(+) = A.DIVISION_ID
           AND B.SCM_SITE_ID(+) = A.SCM_SITE_ID
           AND B.VALID_YN(+)    = 'Y'
           AND A.SCM_SITE_ID    = C.SCM_SITE_ID(+)
           AND A.ITEM_ID        = C.ITEM_ID(+)
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_PLAN_START_YYYYMMDD   /* PLAN 주차 기준. */
           AND A.INV_DATE       >= V_PLAN_START_YYYYMMDD
           AND A.INV_DATE       <  V_PLAN_END_YYYYMMDD;

        /* 재고 / 해상재고 INPUT 생성 전 중간 정보 생성 PROC 참고
               PR_SCP_ENG_IN_PRE_SET_INVENTORY
               PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS */

        /* 1. 창고 재고 : WH */
        /* 1.1 SALES 재고 */
        /*           E(MSP) 아우터 조인의 ON 절에 (a) 보존측 A.PLANT_ID IS NOT NULL 과
           (b) 또 다른 아우터 테이블 D(CPS)의 D.OPERATION_GROUP IS NOT NULL 술어가 있다. */
        INSERT
          INTO GT_OPTENG_ESSIS_INV
             ( DIVISION_ID
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
             , FLAG )
        SELECT /* DISTINCT */
               A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS   /* 뒤에서 별도 UPDATE */
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             /* , CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
                       WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전 */
             , CASE WHEN A.WIPHOLD_YN IS NULL                                   THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                     THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                             TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY   /* SCP 사용 QTY */
             , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
             , B.SITE_TYPE
             , '-'           AS LOCATION_CODE       /* PLANT 재고 구분용 정보 */
             , '-'           AS PROJECT_CODE        /* 뒤에서 별도 UPDATE */
             , E.SCM_SITE_ID AS CELL_PROD_SITE_ID   /* ISNULL(...,'') : Oracle 빈문자열=NULL 이므로 NULL 저장(하위 concat 은 IS NULL 로 처리) */
             , 'SALES'       AS FLAG
          FROM SCM_DNM_STOCK A
               /* 소형 생산지 구분을 위한 분리 */
               INNER JOIN (
                           SELECT DISTINCT DIVISION_ID
                                , SCM_SITE_ID
                                , SITE_TYPE
                             FROM SCM_MST_SITE
                            WHERE 1 = 1
                              AND SITE_TYPE = 'SALES'
                          ) B
                  ON  A.DIVISION_ID = B.DIVISION_ID
                  AND A.SCM_SITE_ID = B.SCM_SITE_ID
               /* INNER JOIN SCM_MST_SITE MS
                      ON A.PLANT_ID = MS.PLANT_ID */
               LEFT OUTER JOIN GT_OPTENG_ESSIS_OCV C
                  ON  A.SCM_SITE_ID = C.SCM_SITE_ID
                  AND A.MES_ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN GT_OPTENG_ESSIS_CPS D
                  ON  1 = 1
                  AND A.SCM_SITE_ID = D.SALES_SITE_ID
                  AND A.ITEM_ID     = D.ITEM_ID
               LEFT OUTER JOIN (
                                SELECT DISTINCT DIVISION_ID
                                     , SCM_SITE_ID
                                     , PLANT_ID
                                  FROM SCM_MST_SITE
                                 WHERE 1 = 1
                                   AND PLANT_ID IS NOT NULL
                               ) E
                  ON  1 = 1
                  AND A.DIVISION_ID = E.DIVISION_ID

                  AND A.PLANT_ID IS NOT NULL
                  AND D.OPERATION_GROUP IS NOT NULL
                  AND A.PLANT_ID||D.OPERATION_GROUP = E.SCM_SITE_ID
         WHERE 1 = 1
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND C.ITEM_ID    IS NULL
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND ((A.DIVISION_ID  = '40' AND NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') <> 'P')
             OR (A.DIVISION_ID <> '40')
               )
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           /* AND    A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                   WHERE   PLAN_ID = @V_PLAN_ID
                                   ) */
           AND ((A.DIVISION_ID  = '40' AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                          FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                         WHERE PLAN_ID = V_PLAN_ID
                                                                       )
                )
             OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                          WHERE PLAN_ID = V_PLAN_ID
                                                        )
                )
               );

        /* Oracle : ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN (INCOTERMS/LOCATION_CODE/PROJECT_CODE VARCHAR(100)) -> GTT 정의 폭(100)에 선반영(불필요) */

        /* 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리 */
        INSERT
          INTO GT_OPTENG_ESSIS_INV
             ( DIVISION_ID
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
             , FLAG )
        SELECT /* DISTINCT */
               A.DIVISION_ID    AS DIVISION_ID
             , A.TO_SCM_SITE_ID AS SCM_SITE_ID
             , '-'              AS INCOTERMS   /* 뒤에서 별도 UPDATE */
             , 'SO'             AS STOCK_TYPE
             , A.ITEM_ID        AS ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전 */
             /* 엔진 오류로 Plan 구간 안으로 처리 */
             /* , CONVERT(DATETIME, @V_CUTOFF_DAY) AS AVAILABLE_DATE */
             , TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') AS AVAILABLE_DATE
             , A.DELIVERY_QTY AS QTY
             , 'N'            AS WIPHOLD_YN
             , B.SITE_TYPE
             , '-'            AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN C.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END AS CELL_PROD_SITE_ID
             , 'SALES'        AS FLAG
          FROM SCM_DNM_INTRANSIT_C A
             , (
                SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND SITE_TYPE = 'SALES'
               ) B
             , GT_OPTENG_ESSIS_CPS C
         WHERE 1 = 1
           AND A.DIVISION_ID    = B.DIVISION_ID
           AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID
           AND A.TO_SCM_SITE_ID = C.SALES_SITE_ID(+)
           AND A.ITEM_ID        = C.ITEM_ID(+)
           AND A.DIVISION_ID    = V_DIVISION_ID
           AND A.RESULT_DATE    = V_CUTOFF_DAY
           /* SO Reserve Stock : result_type = 'B' 는 재고로 처리 */
           AND A.RESULT_TYPE    = 'B'
           AND A.VALID_YN       = 'Y'   /* 해상재고 */
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND ((A.DIVISION_ID  = '40' AND NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') <> 'P')
             OR (A.DIVISION_ID <> '40')
               )
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           /* AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 ) */
           /* 소형 생산지 구분을 위한 분리 */
           AND ((A.DIVISION_ID  = '40' AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                              FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                             WHERE PLAN_ID = V_PLAN_ID
                                                                           )
                )
             OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                          WHERE PLAN_ID = V_PLAN_ID
                                                        )
                )
               );

        /* 1.3 SALES 재고 : INCOTERMS UPDATE  (UPDATE..FROM 2 LEFT JOIN -> 상관 스칼라 서브쿼리) */
        UPDATE
               GT_OPTENG_ESSIS_INV A
           SET A.INCOTERMS = NVL(NVL(
                             (SELECT MAX(CASE WHEN D.VMI_YN = 'Y' THEN 'DAP' ELSE B.INCOTERMS END) MAX_INCOTERMS
                                FROM DM_PLN_NET_DEMAND B
                                   , (
                                      SELECT SCM_SITE_ID
                                           , MAX(VERSION_NO) MAX_VERSION_NO
                                        FROM DM_PLN_NET_DEMAND
                                       WHERE DIVISION_ID     = V_DIVISION_ID
                                         AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                       GROUP BY SCM_SITE_ID
                                     ) C
                                   , (
                                      SELECT DIVISION_ID
                                           , SCM_SITE_ID
                                           , VMI_YN
                                        FROM SCM_MST_SITE
                                       WHERE DIVISION_ID = V_DIVISION_ID
                                         AND VMI_YN      = 'Y'
                                     ) D
                               WHERE B.SCM_SITE_ID     = C.SCM_SITE_ID
                                 AND B.VERSION_NO      = C.MAX_VERSION_NO
                                 AND B.DIVISION_ID     = D.DIVISION_ID(+)
                                 AND B.SCM_SITE_ID     = D.SCM_SITE_ID(+)
                                 AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                                 AND B.ITEM_ID         = A.ITEM_ID
                                 AND B.DIVISION_ID     = V_DIVISION_ID
                                 AND B.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY)
                           , (SELECT MAX(CASE WHEN G.VMI_YN = 'Y' THEN 'DAP' ELSE E.INCOTERMS END) MAX_INCOTERMS
                                FROM DM_PLN_NET_DEMAND E
                                   , (
                                      SELECT SCM_SITE_ID
                                           , MAX(VERSION_NO) MAX_VERSION_NO
                                        FROM DM_PLN_NET_DEMAND
                                       WHERE DIVISION_ID     = V_DIVISION_ID
                                         AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                       GROUP BY SCM_SITE_ID
                                     ) F
                                   , (
                                      SELECT DIVISION_ID
                                           , SCM_SITE_ID
                                           , VMI_YN
                                        FROM SCM_MST_SITE
                                       WHERE DIVISION_ID = V_DIVISION_ID
                                         AND VMI_YN      = 'Y'
                                     ) G
                               WHERE E.SCM_SITE_ID     = F.SCM_SITE_ID
                                 AND E.VERSION_NO      = F.MAX_VERSION_NO
                                 AND E.DIVISION_ID     = G.DIVISION_ID(+)
                                 AND E.SCM_SITE_ID     = G.SCM_SITE_ID(+)
                                 AND E.SCM_SITE_ID     = A.SCM_SITE_ID
                                 AND E.DIVISION_ID     = V_DIVISION_ID
                                 AND E.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY) ),
                             'DAP')   /* DEMAND 없는 경우 DAP 처리 */
         WHERE 1 = 1
           AND A.SITE_TYPE = 'SALES';

        /* 1.4 PLANT 재고 */
        INSERT
          INTO GT_OPTENG_ESSIS_INV
             ( DIVISION_ID
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
             , FLAG )
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             /* , CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
                       WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전 */
             , CASE WHEN A.WIPHOLD_YN IS NULL                                   THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                     THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                             TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY
             , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
             , B.SITE_TYPE
             , CASE WHEN C.LOCATION_CODE IS NOT NULL OR D.LOCATION_CODE IS NOT NULL THEN 'ASSY'
                    ELSE '-'
               END AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , ''      AS PROJECT_CODE
             , ''      AS CELL_PROD_SITE_ID
             , 'PLANT' AS FLAG
          FROM SCM_DNM_STOCK A
             , (
                SELECT DISTINCT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND SITE_TYPE   = 'PLANT'
                   /* AND    OPERATION_GROUP IN ('A', 'P') */
                   AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))        /* 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외 */
                     OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P'))
                       )
               ) B
             , (   /* 셀의 operation_id 별 사용대상 조회 */
                SELECT DISTINCT F.OPERATION_ID
                     , F.LOCATION_CODE
                     , F.SCM_SITE_ID
                  FROM SCM_MST_LOCATION F
                     , (
                        SELECT SCM_SITE_ID
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID     = V_DIVISION_ID
                           AND VALID_YN        = 'Y'
                           AND OPERATION_GROUP IN ('A')
                       ) G
                 WHERE F.SCM_SITE_ID  = G.SCM_SITE_ID
                   AND F.DIVISION_ID  = V_DIVISION_ID   /* '81' */
                   AND F.VALID_YN     = 'Y'
                   AND F.LOCATION_CODE = 'PACKAGING'    /* 활성화 전 재고 */
                   AND (F.OPERATION_ID IS NOT NULL AND RTRIM(F.OPERATION_ID) IS NOT NULL)
               ) C
             , (   /* 셀의 storage_id 별 사용대상 조회 */
                SELECT DISTINCT H.STORAGE_ID
                     , H.LOCATION_CODE
                     , H.SCM_SITE_ID
                  FROM SCM_MST_LOCATION H
                     , (
                        SELECT SCM_SITE_ID
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID     = V_DIVISION_ID
                           AND VALID_YN        = 'Y'
                           AND OPERATION_GROUP IN ('A')
                       ) I
                 WHERE H.SCM_SITE_ID  = I.SCM_SITE_ID
                   AND H.DIVISION_ID  = V_DIVISION_ID   /* '81' */
                   AND H.VALID_YN     = 'Y'
                   AND H.LOCATION_CODE = 'PACKAGING'    /* 활성화 전 재고 */
                   AND (H.STORAGE_ID IS NOT NULL AND RTRIM(H.STORAGE_ID) IS NOT NULL)
               ) D
             , GT_OPTENG_ESSIS_OCV E
         WHERE 1 = 1
           AND A.DIVISION_ID  = B.DIVISION_ID
           AND A.SCM_SITE_ID  = B.SCM_SITE_ID
           AND A.OPERATION_ID = C.OPERATION_ID(+)
           AND A.SCM_SITE_ID  = C.SCM_SITE_ID(+)
           AND A.STORAGE_ID   = D.STORAGE_ID(+)
           AND A.SCM_SITE_ID  = D.SCM_SITE_ID(+)
           /* 소형 생산지 구분을 위한 분리 */
           /* INNER JOIN SCM_MST_SITE MS
                  ON A.PLANT_ID = MS.PLANT_ID */
           AND A.SCM_SITE_ID  = E.SCM_SITE_ID(+)
           AND A.MES_ITEM_ID  = E.ITEM_ID(+)
           AND A.CUTOFF_DATE  = V_CUTOFF_DAY
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND E.ITEM_ID     IS NULL
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           /* AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 ) */
           /* 소형 생산지 구분을 위한 분리 */
           AND ((A.DIVISION_ID  = '40' AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                          FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                         WHERE PLAN_ID = V_PLAN_ID
                                                                       )
                )
             OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                          WHERE PLAN_ID = V_PLAN_ID
                                                        )
                )
               );

        /* 2. 활성화 재고 : FOR */
        /* 2026.05.08 Minyong Lee : 활성화 재고 뷰 중복 스캔 제거 (쿼리 수행 시간 단축) */
        INSERT
          INTO GT_OPTENG_ESSIS_INV
             ( DIVISION_ID
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
             , FLAG )
        WITH BASE_STOCK AS (
             SELECT D.*
                  , MAX(CUTOFF_DATE) OVER (PARTITION BY DIVISION_ID, SITE_ID) AS MAX_CUTOFF_DATE
               FROM SCM_DNM_STOCK_AGING_V D
              WHERE DIVISION_ID = V_DIVISION_ID
                AND CUTOFF_DATE >  TO_CHAR(V_D_CUTOFF_DAY - 7, 'YYYYMMDD')   /* C의 조건을 여기서 한번에 처리 */
                AND CUTOFF_DATE <= TO_CHAR(V_D_CUTOFF_DAY, 'YYYYMMDD')
             )
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS
             , 'FOR'         AS STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    WHEN A.DIVISION_ID = '40' AND C.ADD_LT_FORMATION IS NOT NULL THEN A.AVAILABLE_DATE + C.ADD_LT_FORMATION   /* 소형인 경우 ADD_FORMATION_LT를 재고 일수에 추가 */
                    ELSE A.AVAILABLE_DATE
               END AS AVAILABLE_DATE
             , A.QTY AS QTY
             , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
             , 'PLANT' AS SITE_TYPE
             , '-'     AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , ''      AS PROJECT_CODE
             , ''      AS CELL_PROD_SITE_ID
             , 'PLANT' AS FLAG
          FROM (
                SELECT E.*
                  FROM BASE_STOCK E
                 WHERE E.CUTOFF_DATE = E.MAX_CUTOFF_DATE
                   AND E.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                       FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                      WHERE PLAN_ID = V_PLAN_ID
                                    )
               ) A
             /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경 */
             , (
                SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND DIVISION_ID      = V_DIVISION_ID
                   AND SITE_TYPE        = 'PLANT'
                   AND NVL(OSP_YN, 'N') = 'N'   /* 20180822 추가 */
               ) B
             , SCP_MST_FORMATION_V C
         WHERE A.SCM_SITE_ID = B.SCM_SITE_ID(+)
           AND A.DIVISION_ID = C.DIVISION_ID(+)
           AND A.SCM_SITE_ID = C.PLANT_SITE_ID(+)
           AND A.ITEM_ID     = C.ITEM_ID(+)
           AND B.DIVISION_ID IS NOT NULL;   /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함 */

        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        /* AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                              FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                              WHERE   PLAN_ID = @V_PLAN_ID
                              ) */

        /* 3. 해상 재고 : INT */
        /* 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
        INSERT
          INTO GT_OPTENG_ESSIS_INT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SCM_SITE_ID
             , INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
             , CELL_PROD_SITE_ID
             , FLAG )
        /*           ※되돌리지 말 것 - 되돌리면 이 INSERT 가 결과 0행이어도 36~48분 걸리는 상태로 회귀한다. */
        WITH INTRANSIT_MAT AS
           ( SELECT  *
               FROM SCM_DNM_INTRANSIT_V
              WHERE DIVISION_ID = V_DIVISION_ID
                AND RESULT_DATE = V_CUTOFF_DAY
                AND RESULT_TYPE IN ('I', 'C')
           )
        SELECT A.DIVISION_ID     AS DIVISION_ID
             , A.ITEM_ID
             , A.TO_SCM_SITE_ID  AS TO_SCM_SITE_ID
             , A.FINAL_INCOTERMS AS INCOTERMS
             /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN A.ETA_DATE < V_P_PLAN_NAME THEN V_P_PLAN_NAME
                    ELSE A.ETA_DATE
               END AS ETA_DATE
             , A.DELIVERY_QTY
             /* ,IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN D.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-'   /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                    WHEN D.SITE_TYPE = 'SALES' THEN CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END
                    WHEN D.SITE_TYPE = 'PLANT' THEN ''   /* Plant 도착은 NULL 처리 */
                    ELSE CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END
               END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN E.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END AS CELL_PROD_SITE_ID
             , D.SITE_TYPE AS FLAG
          FROM INTRANSIT_MAT A
             , (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V) B
             , (
                SELECT DIVISION_ID
                     , SCM_SITE_ID
                     , OPERATION_GROUP
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID     = V_DIVISION_ID
                   AND SITE_TYPE       = 'PLANT'
                   AND OPERATION_GROUP IN ('A', 'P')   /* FROM_SITE 가 전극인 정보 제외 */
                   AND VALID_YN        = 'Y'
               ) C
             , SCM_MST_SITE D
             , GT_OPTENG_ESSIS_CPS E
         WHERE 1 = 1
           AND A.DIVISION_ID      = B.DIVISION_ID
           AND A.ITEM_ID          = B.ITEM_ID
           AND A.DIVISION_ID      = C.DIVISION_ID
           AND A.FROM_SCM_SITE_ID = C.SCM_SITE_ID
           AND A.DIVISION_ID      = D.DIVISION_ID
           AND A.TO_SCM_SITE_ID   = D.SCM_SITE_ID
           AND A.TO_SCM_SITE_ID   = E.SALES_SITE_ID(+)
           AND A.ITEM_ID          = E.ITEM_ID(+)
           AND B.OPERATION_GROUP_ID <> 'E'   /* 전극 모델은 제외 */
           AND ((C.DIVISION_ID  = '40' AND C.OPERATION_GROUP = 'A')       /* 소형은 CEll Biz 용 Demand 만 처리 */
             OR (C.DIVISION_ID <> '40')
               )
           /* AND TS.SITE_TYPE      = 'SALES' */
           AND D.VALID_YN = 'Y'
           AND ((D.DIVISION_ID  = '40' AND D.SITE_TYPE = 'SALES')         /* 소형은 CEll Biz 용 Demand 만 처리 */
             OR (D.DIVISION_ID <> '40')
               )
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.RESULT_DATE = V_CUTOFF_DAY
           AND A.RESULT_TYPE IN ('I', 'C')   /* ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           /* AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                               ) */
           /* 소형 생산지 구분을 위한 분리 */
           AND ((A.DIVISION_ID  = '40' AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                              FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                             WHERE PLAN_ID = V_PLAN_ID
                                                                           )
                )
             OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                          WHERE PLAN_ID = V_PLAN_ID
                                                        )
                )
               );

        /* Oracle : ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) -> GTT 정의 폭(100)에 선반영(불필요) */

        /* 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함 */
        /*           F(MSP) 아우터 조인의 ON 절에 보존측 A.PLANT_ID IS NOT NULL 과 또 다른 아우터 테이블 */
        INSERT
          INTO GT_OPTENG_ESSIS_INT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SCM_SITE_ID
             , INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
             , CELL_PROD_SITE_ID
             , FLAG )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.SCM_SITE_ID AS TO_SCM_SITE_ID
             , 'DAP'         AS INCOTERMS   /* VMI 임 */
             /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD') AS ETA_DATE   /* PLAN 시작일자로 처리 */
             , NVL(A.SCM_QTY, 0) AS DELIVERY_QTY
             , '-'               AS PROJECT_CODE
             , F.SCM_SITE_ID     AS CELL_PROD_SITE_ID   /* ISNULL(...,'') : Oracle 빈문자열=NULL */
             , 'SALES'           AS FLAG
          FROM SCM_DNM_STOCK A
               INNER JOIN SCM_MST_VMI_INT_SLOC B
                  ON  A.DIVISION_ID = B.DIVISION_ID
                  AND A.PLANT_ID    = B.PLANT_ID
                  AND A.STORAGE_ID  = B.STORAGE_ID
                  AND B.VALID_YN    = 'Y'
               /* 소형 생산지 구분을 위한 분리 */
               INNER JOIN SCM_MST_SITE C
                  ON A.PLANT_ID = C.PLANT_ID
               LEFT OUTER JOIN GT_OPTENG_ESSIS_OCV D
                  ON  A.SCM_SITE_ID = D.SCM_SITE_ID
                  AND A.MES_ITEM_ID = D.ITEM_ID
               LEFT OUTER JOIN GT_OPTENG_ESSIS_CPS E
                  ON  1 = 1
                  AND A.SCM_SITE_ID = E.SALES_SITE_ID
                  AND A.ITEM_ID     = E.ITEM_ID
               LEFT OUTER JOIN (
                                SELECT DISTINCT DIVISION_ID
                                     , SCM_SITE_ID
                                     , PLANT_ID
                                  FROM SCM_MST_SITE
                                 WHERE 1 = 1
                                   AND PLANT_ID IS NOT NULL
                               ) F
                  ON  1 = 1
                  AND A.DIVISION_ID = F.DIVISION_ID

                  AND A.PLANT_ID IS NOT NULL
                  AND E.OPERATION_GROUP IS NOT NULL
                  AND A.PLANT_ID||E.OPERATION_GROUP = F.SCM_SITE_ID
         WHERE 1 = 1
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND D.ITEM_ID    IS NULL
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND ((A.DIVISION_ID  = '40' AND NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') <> 'P')
             OR (A.DIVISION_ID <> '40')
               )
           /*************************
           대상 프로젝트 ITEM 필터링
           *************************/
           /* AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 ) */
           /* 소형 생산지 구분을 위한 분리 */
           AND ((A.DIVISION_ID  = '40' AND C.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                        WHERE PLAN_ID = V_PLAN_ID
                                                                      )
                )
             OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                           FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                          WHERE PLAN_ID = V_PLAN_ID
                                                        )
                )
               );

        /* UPDATE PROJECT */
        /* INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준 */
        DELETE
          FROM GT_OPTENG_ESSIS_DM;

        INSERT
          INTO GT_OPTENG_ESSIS_DM
             ( SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE )
        SELECT SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
          FROM (
                SELECT SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE ORDER BY MIN_DUE) AS ROW_NUM
                  FROM (
                        SELECT ATTRIBUTE1    AS SITE_ID
                             , ATTRIBUTE2    AS ITEM_ID
                             , ATTRIBUTE4    AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID    = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL   /* PROJECT_CODE */
                           AND ATTRIBUTE4 IS NOT NULL   /* INCOTERMS */
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5
                       ) A
               ) B
         WHERE ROW_NUM = 1
        UNION ALL
        SELECT SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE
          FROM (
                SELECT SITE_ID
                     , ITEM_ID
                     , INCOTERMS
                     , PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY SITE_ID, ITEM_ID, PROJECT_CODE ORDER BY MIN_DUE) AS ROW_NUM
                  FROM (
                        SELECT ATTRIBUTE1    AS SITE_ID
                             , ATTRIBUTE2    AS ITEM_ID
                             , NULL          AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID    = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL
                           AND ATTRIBUTE4 IS NULL
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
                       ) C
               ) D
         WHERE ROW_NUM = 1;

        /* #SCP_INVENTORY_I 프로젝트 UPDATE  (UPDATE..FROM INNER JOIN -> MERGE, 파생 MAX 결정화) */
        MERGE INTO GT_OPTENG_ESSIS_INV A
        USING (
               SELECT DIVISION_ID
                    , SCM_SITE_ID
                    , INCOTERMS
                    , STOCK_TYPE
                    , ITEM_ID
                    , AVAILABLE_DATE
                    , QTY
                    , WIPHOLD_YN
                    , SITE_TYPE
                    , LOCATION_CODE
                    , MAX(PROJECT_CODE) AS PROJECT_CODE
                 FROM (
                       SELECT E.DIVISION_ID
                            , E.SCM_SITE_ID
                            , E.INCOTERMS
                            , E.STOCK_TYPE
                            , E.ITEM_ID
                            , E.AVAILABLE_DATE
                            , E.QTY
                            , E.WIPHOLD_YN
                            , E.SITE_TYPE
                            , E.LOCATION_CODE
                            , F.PROJECT_CODE
                         FROM (
                               SELECT C.DIVISION_ID
                                    , C.SCM_SITE_ID
                                    , C.INCOTERMS
                                    , C.STOCK_TYPE
                                    , C.ITEM_ID
                                    , CASE WHEN D.SEGMENT3 IS NULL THEN C.ITEM_ID ELSE D.SEGMENT4 END AS MDF_ITEM_ID
                                    , C.AVAILABLE_DATE
                                    , C.QTY
                                    , C.WIPHOLD_YN
                                    , C.SITE_TYPE
                                    , C.LOCATION_CODE
                                 FROM GT_OPTENG_ESSIS_INV          C
                                    , SCP_OPMZ_LOOKUP_MASTER_DETAIL D
                                WHERE C.ITEM_ID       = D.SEGMENT3(+)
                                  AND D.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                  AND D.SEGMENT2(+)    = V_DIVISION_ID
                                  AND D.VALID_YN(+)    = 'Y'
                                  AND C.FLAG         = 'SALES'
                                  AND C.PROJECT_CODE = '-'
                                  AND C.QTY          > 0
                              ) E
                            , GT_OPTENG_ESSIS_DM F
                        WHERE E.SCM_SITE_ID = F.SITE_ID
                          AND E.MDF_ITEM_ID = F.ITEM_ID
                          AND (   (E.INCOTERMS IS NULL AND F.INCOTERMS IS NULL)
                               OR (E.INCOTERMS = F.INCOTERMS)
                               OR (E.INCOTERMS IS NOT NULL AND F.INCOTERMS IS NULL)
                              )
                      )
                GROUP BY DIVISION_ID, SCM_SITE_ID, INCOTERMS, STOCK_TYPE, ITEM_ID, AVAILABLE_DATE, QTY, WIPHOLD_YN, SITE_TYPE, LOCATION_CODE
              ) B
           ON (    A.DIVISION_ID    = B.DIVISION_ID
               AND A.SCM_SITE_ID    = B.SCM_SITE_ID
               AND A.INCOTERMS      = B.INCOTERMS
               AND A.STOCK_TYPE     = B.STOCK_TYPE
               AND A.ITEM_ID        = B.ITEM_ID
               AND A.AVAILABLE_DATE = B.AVAILABLE_DATE
               AND A.QTY            = B.QTY
               AND A.WIPHOLD_YN     = B.WIPHOLD_YN
               AND A.SITE_TYPE      = B.SITE_TYPE
               AND A.LOCATION_CODE  = B.LOCATION_CODE )
         WHEN MATCHED THEN UPDATE SET A.PROJECT_CODE = B.PROJECT_CODE;

        /* #SCP_INTRANSIT_I 프로젝트 UPDATE  (UPDATE..FROM INNER JOIN -> MERGE, 파생 MAX 결정화) */
        MERGE INTO GT_OPTENG_ESSIS_INT A
        USING (
               SELECT DIVISION_ID
                    , ITEM_ID
                    , TO_SCM_SITE_ID
                    , INCOTERMS
                    , ETA_DATE
                    , DELIVERY_QTY
                    , FLAG
                    , MAX(PROJECT_CODE) AS PROJECT_CODE
                 FROM (
                       SELECT E.DIVISION_ID
                            , E.ITEM_ID
                            , E.TO_SCM_SITE_ID
                            , E.INCOTERMS
                            , E.ETA_DATE
                            , E.DELIVERY_QTY
                            , E.FLAG
                            , F.PROJECT_CODE
                         FROM (
                               SELECT C.DIVISION_ID
                                    , C.ITEM_ID
                                    , CASE WHEN D.SEGMENT3 IS NULL THEN C.ITEM_ID ELSE D.SEGMENT4 END AS MDF_ITEM_ID
                                    , C.TO_SCM_SITE_ID
                                    , C.INCOTERMS
                                    , C.ETA_DATE
                                    , C.DELIVERY_QTY
                                    , C.PROJECT_CODE
                                    , C.FLAG
                                 FROM GT_OPTENG_ESSIS_INT          C   /* WHERE PROJECT_CODE = '-' AND FLAG ='SALES' */
                                    , SCP_OPMZ_LOOKUP_MASTER_DETAIL D
                                WHERE C.ITEM_ID        = D.SEGMENT3(+)
                                  AND D.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                  AND D.SEGMENT2(+)    = V_DIVISION_ID
                                  AND D.VALID_YN(+)    = 'Y'
                                  AND C.FLAG         = 'SALES'
                                  AND C.PROJECT_CODE = '-'
                                  AND C.DELIVERY_QTY > 0
                              ) E
                            , GT_OPTENG_ESSIS_DM F
                        WHERE E.TO_SCM_SITE_ID = F.SITE_ID
                          AND E.MDF_ITEM_ID    = F.ITEM_ID
                          AND (   (E.INCOTERMS IS NULL AND F.INCOTERMS IS NULL)
                               OR (E.INCOTERMS = F.INCOTERMS)
                               OR (E.INCOTERMS IS NOT NULL AND F.INCOTERMS IS NULL)
                              )
                      )
                GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, INCOTERMS, ETA_DATE, DELIVERY_QTY, FLAG
              ) B
           ON (    A.DIVISION_ID    = B.DIVISION_ID
               AND A.ITEM_ID        = B.ITEM_ID
               AND A.TO_SCM_SITE_ID = B.TO_SCM_SITE_ID
               AND A.INCOTERMS      = B.INCOTERMS
               AND A.ETA_DATE       = B.ETA_DATE
               AND A.DELIVERY_QTY   = B.DELIVERY_QTY
               AND A.FLAG           = B.FLAG )
         WHEN MATCHED THEN UPDATE SET A.PROJECT_CODE = B.PROJECT_CODE;

        /* CA별 CP 정보 */
        DELETE
          FROM GT_OPTENG_ESSIS_CP;

        INSERT
          INTO GT_OPTENG_ESSIS_CP
             ( DIVISION_ID
             , PLANT_ID
             , ITEM_ID_ASSY
             , ITEM_ID_PROD
             , PRIORITY_1ST
             , PRIORITY_2ND
             , PRIORITY_3RD )
        SELECT DIVISION_ID
             , PLANT_ID
             , ITEM_ID_ASSY
             , ITEM_ID_PROD
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                             , ITEM_ID_ASSY
                                             , PLANT_ID
                                     ORDER BY VALID_YN DESC
                                             , ITEM_ID_PROD) PRIORITY_1ST
             , ROW_NUMBER() OVER (PARTITION BY DIVISION_ID
                                             , ITEM_ID_ASSY
                                     ORDER BY VALID_YN DESC
                                             , ITEM_ID_PROD) PRIORITY_2ND
             , ROW_NUMBER() OVER (PARTITION BY ITEM_ID_ASSY
                                     ORDER BY VALID_YN DESC
                                             , ITEM_ID_PROD) PRIORITY_3RD
          FROM SCP_MST_CELL_PROD_ASSY_MAP
         WHERE 1 = 1
           AND VALID_YN = 'Y';

        /* INCOMING STOCK INSERT */
        /* 2025.07.10 Philsu Park: 재고 보정 대상 데이터는 별도 Insert 하기 때문에 제외 처리. */
        INSERT
          INTO SCP_OPT_ENG_INCOMING_STOCK_SN
             ( PLAN_ID
             , STOCK_ID
             , BUFFER_ID
             , EFFECTIVE_DATE
             , TYPE
             , QUANTITY
             , ATTRIBUTE1
             , ATTRIBUTE2
             , ATTRIBUTE3
             , ATTRIBUTE4
             , ATTRIBUTE5 )
        SELECT PLAN_ID
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
          FROM (
                SELECT V_PLAN_ID AS PLAN_ID
                     , TYPE||'::'||SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS='-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||'::'||EFECTIVE_DATE||CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::'||CELL_PROD_SITE_ID END AS STOCK_ID
                     , SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS='-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::'||CELL_PROD_SITE_ID END AS BUFFER_ID
                     , EFECTIVE_DATE AS EFECTIVE_DATE
                     , TYPE          AS TYPE
                     , QTY           AS QUANTITY
                     , SITE_ID       AS SITE_ID
                     , ITEM_ID       AS ITEM_ID
                     , STAGE         AS STAGE
                     , INCOTERMS     AS INCOTERMS
                     , PROJECT_CODE  AS PROJECT_CODE
                  FROM (
                        SELECT C.SCM_SITE_ID AS SITE_ID
                             /* , A.ITEM_ID AS ITEM_ID */
                             , CASE   /* 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함 */
                                    WHEN D.OPERATION_GROUP = 'A' AND D.ATTRIBUTE8 <> 'CP' AND C.DESCR LIKE 'WH%' AND C.LOCATION_CODE = '-'
                                         THEN NVL(NVL(NVL(F.ITEM_ID_PROD, G.ITEM_ID_PROD), H.ITEM_ID_PROD), C.ITEM_ID)
                                    ELSE C.ITEM_ID
                               END ITEM_ID
                             , CASE
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'P' AND D.FLOW_ID = 'P9500' AND C.FLAG = 'PLANT' THEN 'LINK'
                                    WHEN D.OPERATION_GROUP_ID = 'P' AND D.FLOW_ID = 'PL450' AND C.FLAG = 'PLANT' THEN 'LINK'       /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                    WHEN D.OPERATION_GROUP_ID = 'P' AND D.FLOW_ID = 'P9500' AND C.FLAG = 'SALES' THEN 'LINKBIZ'
                                    WHEN D.OPERATION_GROUP_ID = 'P' AND D.FLOW_ID = 'PL450' AND C.FLAG = 'SALES' THEN 'LINKBIZ'    /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'P' AND D.FLOW_ID = 'R5500' AND C.FLAG = 'PLANT' THEN 'RACK'
                                    WHEN D.OPERATION_GROUP_ID = 'P' AND D.FLOW_ID = 'R5500' AND C.FLAG = 'SALES' THEN 'RACKBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'B' AND D.FLOW_ID = 'P9500' AND C.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN D.OPERATION_GROUP_ID = 'B' AND D.FLOW_ID = 'P9500' AND C.FLAG = 'SALES' THEN 'PACKBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'B' AND D.FLOW_ID = 'P5500' AND C.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN D.OPERATION_GROUP_ID = 'B' AND D.FLOW_ID = 'P5500' AND C.FLAG = 'SALES' THEN 'PACKBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'M' AND D.FLOW_ID = 'P9500' AND C.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN D.OPERATION_GROUP_ID = 'M' AND D.FLOW_ID = 'P9500' AND C.FLAG = 'PLANT' THEN 'PACKBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP = 'A' AND D.ATTRIBUTE8 <> 'CP' AND C.DESCR LIKE 'FOR%' THEN 'ASY_AGING'
                                    WHEN D.OPERATION_GROUP = 'A' AND D.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN C.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END)
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'A' AND D.FLOW_ID = 'A9000' AND C.FLAG = 'PLANT' THEN 'CHAR'
                                    WHEN D.OPERATION_GROUP_ID = 'A' AND D.FLOW_ID = 'A9000' AND C.FLAG = 'SALES' THEN 'CELLBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'M' AND D.FLOW_ID = 'P5000' AND C.ITEM_ID NOT LIKE 'EP%' AND C.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN D.OPERATION_GROUP_ID = 'M' AND D.FLOW_ID = 'P5000' AND C.ITEM_ID NOT LIKE 'EP%' AND C.FLAG = 'SALES' THEN 'PACKBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    WHEN D.OPERATION_GROUP_ID = 'M' AND D.FLOW_ID = 'P5000' AND C.ITEM_ID LIKE 'EP%' AND C.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN D.OPERATION_GROUP_ID = 'M' AND D.FLOW_ID = 'P5000' AND C.ITEM_ID LIKE 'EP%' AND C.FLAG = 'SALES' THEN 'PACKBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                                    /* 2026.05.27 Minyong Lee ESS 사내 Pack Plant 추가로 SUBMDLE 관리 되도록 원복 */
                                    WHEN I.SCP_OPERATION_GROUP = 'P' AND I.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND C.FLAG = 'PLANT' THEN 'SUBMDLE'
                                    WHEN I.SCP_OPERATION_GROUP = 'P' AND I.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND C.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                    /*--------------------------------------------------------------------------------------------------------------------------- */
                               ELSE '-' END AS STAGE
                             , TO_CHAR(NVL(C.EFFSTARTDATE, TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                             , C.DESCR AS TYPE
                             , C.QTY   AS QTY
                             , C.INCOTERMS
                             , C.PROJECT_CODE
                             , C.CELL_PROD_SITE_ID
                          FROM (
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TRUNC(AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(QTY)              AS QTY
                                     , CASE WHEN NVL(WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                            ELSE 'WH_HOLD'
                                       END AS DESCR
                                     , LOCATION_CODE
                                     , PROJECT_CODE
                                     , CELL_PROD_SITE_ID
                                     , FLAG
                                  FROM GT_OPTENG_ESSIS_INV
                                 WHERE 1 = 1
                                   AND STOCK_TYPE <> 'FOR'
                                 GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, TRUNC(AVAILABLE_DATE), NVL(WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID
                                HAVING SUM(QTY) > 0
                                UNION ALL
                                /* 활성화 재고 : FOR 로 처리 */
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TRUNC(AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(QTY)              AS QTY
                                     , CASE WHEN NVL(WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
                                            ELSE 'FOR_HOLD'
                                       END AS DESCR
                                     , LOCATION_CODE
                                     , PROJECT_CODE
                                     , CELL_PROD_SITE_ID
                                     , FLAG
                                  FROM GT_OPTENG_ESSIS_INV
                                 WHERE 1 = 1
                                   AND STOCK_TYPE = 'FOR'   /* 활성화 재고 */
                                   AND QTY        > 0
                                 GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, TRUNC(AVAILABLE_DATE), NVL(WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID
                                UNION ALL
                                /* INTRANSIT SHIPMENT 재고 */
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , TO_SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TO_DATE(ETA_DATE, 'YYYYMMDD') AS EFFSTARTDATE
                                     , SUM(DELIVERY_QTY)             AS QTY
                                     , 'INT'                         AS DESCR
                                     , '-'                           AS LOCATION_CODE
                                     , PROJECT_CODE
                                     , CELL_PROD_SITE_ID
                                     , FLAG
                                  FROM GT_OPTENG_ESSIS_INT
                                 WHERE 1 = 1
                                   AND DELIVERY_QTY > 0
                                   AND (ETA_DATE IS NOT NULL OR ETA_DATE <> '')
                                 GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, ETA_DATE, INCOTERMS, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID
                               ) C
                             , (
                                SELECT DISTINCT DIVISION_ID
                                     , ITEM_ID
                                     , OPERATION_GROUP
                                     , OPERATION_GROUP_ID
                                     , FLOW_ID
                                     , ATTRIBUTE8
                                     /* , * */
                                  FROM SCP_MST_FINAL_ITEM
                                 WHERE DIVISION_ID     = V_DIVISION_ID
                                   AND OPERATION_GROUP IN ('A', 'P')
                               ) D
                             , SCM_MST_SITE        E
                             , GT_OPTENG_ESSIS_CP  F
                             , GT_OPTENG_ESSIS_CP  G
                             , GT_OPTENG_ESSIS_CP  H
                             /* SUBMDLE의 STAGE를 찾기 위해 추가 */
                             /* 2025.08.12 Philsu Park - ESS 불필요 로직으로 주석처리. */
                             /* 2026.05.27 Minyong Lee ESS 사내 Pack Plant 추가로 SUBMDLE 관리 되도록 원복 */
                             , (
                                SELECT K.DIVISION_ID
                                     , K.SCM_SITE_ID
                                     , J.ITEM_ID
                                     , J.SCP_FLOW_ID
                                     , J.SCP_OPERATION_GROUP
                                  FROM SCM_ITEM_M_SN J
                                     , SCM_MST_SITE  K
                                 WHERE J.COMPANY_ID          = K.COMPANY_ID
                                   AND J.SCP_OPERATION_GROUP = K.OPERATION_GROUP
                                   AND K.SCM_SITE_ID||J.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                      FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                     WHERE PLAN_ID = V_PLAN_ID
                                                                   )
                                   AND J.SCP_FLOW_ID NOT IN ('P5500', 'P9500')   /* SUBMDLE만 걸리도록 */
                                   AND J.SCP_OPERATION_GROUP = 'P'               /* SUBMDLE만 걸리도록 */
                               ) I
                         WHERE 1 = 1
                           AND C.ITEM_ID        = D.ITEM_ID(+)
                           AND C.DIVISION_ID    = D.DIVISION_ID(+)
                           AND E.DIVISION_ID(+) = C.DIVISION_ID
                           AND E.SCM_SITE_ID(+) = C.SCM_SITE_ID
                           AND E.SITE_TYPE(+)   = 'PLANT'
                           AND E.VALID_YN(+)    = 'Y'
                           AND F.DIVISION_ID(+)  = C.DIVISION_ID
                           AND F.PLANT_ID(+)     = E.PLANT_ID
                           AND F.ITEM_ID_ASSY(+) = C.ITEM_ID
                           AND F.PRIORITY_1ST(+) = 1
                           AND G.DIVISION_ID(+)  = C.DIVISION_ID
                           AND G.ITEM_ID_ASSY(+) = C.ITEM_ID
                           AND G.PRIORITY_2ND(+) = 1
                           AND H.ITEM_ID_ASSY(+) = C.ITEM_ID
                           AND H.PRIORITY_3RD(+) = 1
                           AND C.DIVISION_ID = I.DIVISION_ID(+)
                           AND C.SCM_SITE_ID = I.SCM_SITE_ID(+)
                           AND C.ITEM_ID     = I.ITEM_ID(+)
                           /* AND    A.ITEM_ID = B.ITEM_ID */
                           /* AND    B.ITEM_TYPE <> 'R' --  R TYPE의 재고는 올리지 않음 */
                           /*************************
                           대상 프로젝트 ITEM 필터링
                           *************************/
                           AND C.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                              WHERE PLAN_ID = V_PLAN_ID
                                            )
                       ) B
                 WHERE 1 = 1
                   AND NOT EXISTS (SELECT 1
                                     FROM GT_OPTENG_ESSIS_ADJ L
                                    WHERE L.SCM_SITE_ID  = B.SITE_ID
                                      AND L.ITEM_ID      = B.ITEM_ID
                                      AND L.STOCK_TYPE   = B.TYPE
                                      AND L.STAGE        = B.STAGE
                                      AND L.INCOTERMS    = B.INCOTERMS
                                      AND L.PROJECT_CODE = B.PROJECT_CODE
                                      AND L.INV_DATE     = B.EFECTIVE_DATE
                                  )
                   AND EFECTIVE_DATE < V_PLAN_END_YYYYMMDD
                /*  자재/포장재의 입고 예정정보
                    2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용. */
                UNION ALL
                SELECT V_PLAN_ID AS PLAN_ID
                     , TYPE||'::'||SCM_SITE_ID||'::'||MAT_ID||'::'||STAGE||'::'||ARR_DATE AS STOCK_ID
                     , SCM_SITE_ID||'::'||MAT_ID||'::'||STAGE AS BUFFER_ID
                     , ARR_DATE    AS EFFECTIVE_DATE
                     , TYPE        AS TYPE
                     , QTY         AS QUANTITY
                     , SCM_SITE_ID AS SITE_ID
                     , MAT_ID      AS ITEM_ID
                     , STAGE       AS STAGE
                     , '-'         AS INCOTERMS
                     , '-'         AS PROJECT_CODE
                  FROM (
                        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
                        SELECT N.PLANT_SITE_ID AS SCM_SITE_ID
                             , N.ITEM_ID_CHILD AS MAT_ID
                             , 'MATERIAL_CONST' AS STAGE
                             , N.TO_YYYYMMDD   AS ARR_DATE
                             , TO_NUMBER(N.TO_EXPC_QTY) AS QTY
                             , 'MC'            AS TYPE
                          FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION N
                             , SCP_OPMZ_PLAN_GR_M                     O
                             , GT_OPTENG_ESSIS_MAT                    P
                         WHERE 1 = 1
                           AND N.OPMZ_PLAN_GR_ID = O.OPMZ_PLAN_GR_ID
                           AND N.ITEM_ID_CHILD   = P.MAT_ID
                           AND N.DIVISION_ID     = V_DIVISION_ID
                           AND O.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                           AND N.VALID_YN        = 'Y'
                           AND O.VALID_YN        = 'Y'
                           AND N.TO_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND P.EFF_END_DATE
                        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
                        /* -- BLOCKED 2025.11.19 jongykim2
                        SELECT  LU.SEGMENT4      AS SCM_SITE_ID
                               ,LU.SEGMENT5      AS MAT_ID
                               ,'MATERIAL_CONST' AS STAGE
                               ,ATTRIBUTE1       AS ARR_DATE
                               ,ATTRIBUTE2       AS QTY
                               ,'MC'             AS TYPE
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                        INNER JOIN @MAT_CONST_TEMP MAT
                            ON  LU.SEGMENT5         = MAT.MAT_ID
                        WHERE   LU.LOOKUP_TYPE      = 'SCP_OPT_ENG_CONST_INCOMMING_MATERIAL'
                        AND     LU.VALID_YN         = 'Y'
                        AND     LU.SEGMENT2         = @V_DIVISION_ID
                        AND     LU.SEGMENT3         = @V_GROUP_ID
                        AND     LU.ATTRIBUTE1 BETWEEN @V_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE */
                       ) M
                 WHERE ARR_DATE < V_PLAN_END_YYYYMMDD
               ) A
         GROUP BY PLAN_ID, STOCK_ID, BUFFER_ID, EFECTIVE_DATE, TYPE, SITE_ID, ITEM_ID, STAGE, INCOTERMS, PROJECT_CODE;

        /* INCOMING STOCK INSERT #2. */
        /* 2025.07.10 Philsu Park: 재고 보정 데이터 Insert. */
        INSERT
          INTO SCP_OPT_ENG_INCOMING_STOCK_SN
             ( PLAN_ID
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
             , INSERT_ID )
        SELECT V_PLAN_ID AS PLAN_ID
             , STOCK_TYPE||'::'||SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS != '-' THEN '@'||INCOTERMS||'@'||PROJECT_CODE ELSE '' END||'::'||INV_DATE AS STOCK_ID
             , SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE||CASE WHEN INCOTERMS != '-' THEN '@'||INCOTERMS||'@'||PROJECT_CODE ELSE '' END AS BUFFER_ID
             , INV_DATE     AS EFFECTIVE_DATE
             , STOCK_TYPE   AS TYPE
             , QTY          AS QUANTITY
             , SCM_SITE_ID  AS ATTRIBUTE1
             , ITEM_ID      AS ATTRIBUTE2
             , STAGE        AS ATTRIBUTE3
             , INCOTERMS    AS ATTRIBUTE4
             , PROJECT_CODE AS ATTRIBUTE5
             , 'INVENTORY_ADJUST' AS ATTRIBUTE15
             , 'INVENTORY_ADJUST' AS INSERT_ID
          FROM GT_OPTENG_ESSIS_ADJ
         WHERE 1 = 1
           AND QTY > 0;

        /* 2nd OCV 재고는 INSP로 UPDATE */
        /* MSSQL UPDATE..FROM INNER JOIN + SET에 ON키(ATTRIBUTE3) 포함 -> MERGE 불가(ORA-38104) -> 상관 UPDATE + EXISTS. */
        UPDATE
               SCP_OPT_ENG_INCOMING_STOCK_SN A
           SET (A.STOCK_ID, A.BUFFER_ID, A.ATTRIBUTE3) =
               (SELECT A.TYPE||'::'||A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||C.TO_BE_STAGE||'::'||A.EFFECTIVE_DATE
                     , A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||C.TO_BE_STAGE
                     , C.TO_BE_STAGE
                  FROM (
                        SELECT SCM_SITE_ID
                             , ITEM_ID
                             , AS_IS_STAGE
                             , MAX(TO_BE_STAGE) AS TO_BE_STAGE
                          FROM (
                                SELECT ATTRIBUTE2 AS AS_IS_STAGE
                                     , ATTRIBUTE3 AS TO_BE_STAGE
                                     , SEGMENT4   AS SCM_SITE_ID
                                     , SEGMENT5   AS ITEM_ID
                                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                                 WHERE 1 = 1
                                   AND LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                   AND VALID_YN    = 'Y'
                                   AND SEGMENT2    = V_DIVISION_ID
                                   AND SEGMENT3    = V_GROUP_ID
                                 GROUP BY ATTRIBUTE2, ATTRIBUTE3, SEGMENT4, SEGMENT5
                               ) B
                         GROUP BY SCM_SITE_ID, ITEM_ID, AS_IS_STAGE
                       ) C
                 WHERE A.ATTRIBUTE1 = C.SCM_SITE_ID
                   AND A.ATTRIBUTE2 = C.ITEM_ID
                   AND A.ATTRIBUTE3 = C.AS_IS_STAGE)
         WHERE A.PLAN_ID = V_PLAN_ID
           AND EXISTS (SELECT 1
                         FROM (
                               SELECT SEGMENT4   AS SCM_SITE_ID
                                    , SEGMENT5   AS ITEM_ID
                                    , ATTRIBUTE2 AS AS_IS_STAGE
                                 FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                                WHERE 1 = 1
                                  AND LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                  AND VALID_YN    = 'Y'
                                  AND SEGMENT2    = V_DIVISION_ID
                                  AND SEGMENT3    = V_GROUP_ID
                                GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE2
                              ) D
                        WHERE A.ATTRIBUTE1 = D.SCM_SITE_ID
                          AND A.ATTRIBUTE2 = D.ITEM_ID
                          AND A.ATTRIBUTE3 = D.AS_IS_STAGE);

        /* 2025.12.01 Minyong Lee : LINKBIZ -> PACKBIZ 수요 변환 모델에 대한 재고 BUFFER_ID 동기화 */
        /* MSSQL UPDATE..FROM 2 INNER JOIN -> 상관 UPDATE + EXISTS. (DA 룩업이 CHG_ITEM_ID 당 다중행 가능성 대비 MAX 결정화) */
        UPDATE
               SCP_OPT_ENG_INCOMING_STOCK_SN A
           SET A.BUFFER_ID =
               (SELECT MAX(B.TO_SITE_ID||'::'||B.CHG_ITEM_ID||'::'||B.STAGE||'@'||C.INCOTERMS||'@'||'-')
                  FROM (
                        SELECT SEGMENT3 AS ORIGIN_ITEM_ID
                             , SEGMENT4 AS STAGE
                             , SEGMENT5 AS CHG_ITEM_ID
                             , SEGMENT6 AS FROM_SITE_ID
                             , SEGMENT7 AS TO_SITE_ID
                             , SEGMENT8 AS BOD_ID
                             , SEGMENT9 AS ORIGIN_BOD_ID
                          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                         WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_ADD'
                           AND VALID_YN    = 'Y'
                           AND SEGMENT1    = V_DIVISION_ID
                           AND SEGMENT2    = V_GROUP_ID
                       ) B
                     , SCP_MST_BOD_N_V C
                 WHERE C.BOD_ID      = B.BOD_ID
                   AND C.DIVISION_ID = V_DIVISION_ID
                   AND B.CHG_ITEM_ID = A.ATTRIBUTE2)
         WHERE 1 = 1
           AND A.PLAN_ID = V_PLAN_ID
           AND A.TYPE    = 'INT'
           AND EXISTS (SELECT 1
                         FROM (
                               SELECT SEGMENT5 AS CHG_ITEM_ID
                                    , SEGMENT8 AS BOD_ID
                                 FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                                WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_ADD'
                                  AND VALID_YN    = 'Y'
                                  AND SEGMENT1    = V_DIVISION_ID
                                  AND SEGMENT2    = V_GROUP_ID
                              ) D
                            , SCP_MST_BOD_N_V E
                        WHERE E.BOD_ID      = D.BOD_ID
                          AND E.DIVISION_ID = V_DIVISION_ID
                          AND D.CHG_ITEM_ID = A.ATTRIBUTE2);

        /* 2026.04.08 Minyong Lee : 법인간 이동 재고 BUFFER_ID, STOCK_ID 생성 규칙 수정, INCOTERMS / PROJECT_CODE 제거 */
        DELETE
          FROM GT_OPTENG_ESSIS_CINT;

        INSERT
          INTO GT_OPTENG_ESSIS_CINT
             ( PLAN_ID
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
             , ATTRIBUTE15 )
        SELECT A.PLAN_ID
             , A.TYPE||'::'||A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||A.ATTRIBUTE3||'::'||A.EFFECTIVE_DATE AS STOCK_ID
             , A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||A.ATTRIBUTE3 AS BUFFER_ID
             , A.EFFECTIVE_DATE
             , A.TYPE
             , SUM(A.QUANTITY) AS QUANTITY
             , A.ATTRIBUTE1
             , A.ATTRIBUTE2
             , A.ATTRIBUTE3
             , '-' AS ATTRIBUTE4
             , ''  AS ATTRIBUTE5
             , A.ATTRIBUTE15
          FROM (
                SELECT PLAN_ID
                     , EFFECTIVE_DATE
                     , TYPE
                     , QUANTITY
                     , ATTRIBUTE1
                     , ATTRIBUTE2
                     , ATTRIBUTE3
                     , ATTRIBUTE15
                  FROM SCP_OPT_ENG_INCOMING_STOCK_SN
                 WHERE PLAN_ID    = V_PLAN_ID
                   AND STOCK_ID   LIKE 'INT%'
                   AND ATTRIBUTE3 NOT LIKE '%BIZ'
               ) A
         GROUP BY A.PLAN_ID, A.EFFECTIVE_DATE, A.TYPE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE15;

        DELETE
          FROM SCP_OPT_ENG_INCOMING_STOCK_SN
         WHERE PLAN_ID    = V_PLAN_ID
           AND STOCK_ID   LIKE 'INT%'
           AND ATTRIBUTE3 NOT LIKE '%BIZ';

        INSERT
          INTO SCP_OPT_ENG_INCOMING_STOCK_SN
             ( PLAN_ID
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
             , ATTRIBUTE15 )
        SELECT PLAN_ID
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
          FROM GT_OPTENG_ESSIS_CINT;

        /* Data Insert End */
        /* MSSQL #temp DROP-IF-EXISTS -> Oracle GTT 정리 DELETE */
        DELETE
          FROM GT_OPTENG_ESSIS_INV;

        DELETE
          FROM GT_OPTENG_ESSIS_INT;

        DELETE
          FROM GT_OPTENG_ESSIS_CP;

        DELETE
          FROM GT_OPTENG_ESSIS_ADJ;

        DELETE
          FROM GT_OPTENG_ESSIS_CINT;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SQLERRM;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'ERROR', NULL, V_MESSAGE_TEXT, NULL, V_PLAN_ID);
            V_DETAIL_DATE  := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, V_DETAIL_DATE, NULL, V_MESSAGE_TEXT, 'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* 종료 LOG */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
    END IF;

END PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK;