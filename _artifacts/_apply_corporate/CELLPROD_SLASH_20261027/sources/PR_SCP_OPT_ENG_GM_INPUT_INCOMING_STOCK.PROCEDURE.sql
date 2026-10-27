PROCEDURE PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK
(
     P_PLAN_ID              VARCHAR2
    ,P_DIVISION_ID          VARCHAR2
    ,P_GROUP_ID             VARCHAR2
    ,P_PLAN_START_YYYYMMDD  VARCHAR2
    ,P_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK
 * Description  : GM Optimization Engine 입력용 Incoming Stock 생성
 *                (창고재고 WH / 활성화재고 FOR / 해상재고 INT / 재고보정 Workbench / 자재 입고예정 MC / TRAY 제약)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.07.07    Philsu Park    Initial Release
 * 2026.07.30    ZIONEX         [PJ202650304]  NextSCM Migration
 *                              (MSSQL 임시테이블/테이블변수 -> Oracle GTT (GM INCOMING STOCK 전용 신규 GT_OPT_ENG_GMIS_x):
 *                                 @MAT_CONST_TEMP    -> GT_OPT_ENG_GMIS_MAT
 *                                 SCP_INVENTORY_I    -> GT_OPT_ENG_GMIS_INV
 *                                 SCP_INTRANSIT_I    -> GT_OPT_ENG_GMIS_INT
 * ============================================================ */
AS
    /* 2025.07.07 Philsu Park: Initial Release */
    /* Set Prameter */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK';
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
    V_D_PLAN_NAME         DATE;
    V_MAX_TUESDAY         VARCHAR2(8 CHAR);
BEGIN
    /* Procedure 기본조건.PA
       SET XACT_ABORT ON / SET NOCOUNT ON / SET TRANSACTION ISOLATION LEVEL READ COMMITTED */

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);

    /* Transaction (START) */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    BEGIN
        /* Get Param Info
           MSSQL 대입형 SELECT 는 0행이면 변수 미변경 / 넓은 컬럼은 무음 절단. */
        BEGIN
            SELECT
                   SUBSTR(ATTRIBUTE1, 1, 20)
                 , SUBSTR(ATTRIBUTE2, 1, 20)
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
         WHERE BASIS_YYYYMMDD <= V_PLAN_START_YYYYMMDD
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

        V_P_PLAN_NAME  := V_PLAN_START_YYYYMMDD;
        V_D_PLAN_NAME  := TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD');

        V_CUTOFF_DAY   := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');
        V_D_CUTOFF_DAY := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');

        SELECT
               MAX(A.CUTOFF_YYYYMMDD)
          INTO V_DEMAND_CUTOFF_DAY
          FROM DM_PLN_NET_DEMAND A
         WHERE A.DIVISION_ID       = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD  <= V_PLAN_START_YYYYMMDD
           AND A.CUTOFF_YYYYMMDD  >= TO_CHAR(TO_DATE(V_MAX_TUESDAY, 'YYYYMMDD') - 28, 'YYYYMMDD');

        /* 자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용 */
        /* SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
           FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
           WHERE  PLAN_ID = @V_PLAN_ID */

        DELETE
          FROM GT_OPT_ENG_GMIS_MAT;

        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
        INSERT
          INTO GT_OPT_ENG_GMIS_MAT
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
        /* BLOCKED 2025.11.19 jongykim2
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
          FROM GT_OPT_ENG_GMIS_OCV;

        INSERT
          INTO GT_OPT_ENG_GMIS_OCV
             ( SCM_SITE_ID
             , ITEM_ID )
        SELECT B.SCM_SITE_ID
             , A.CHILD_ITEM_ID
          FROM SCM_MST_BOM_SN_V                A
             , SCM_MST_SITE                    B
             , SCP_OPMZ_LOOKUP_MASTER_DETAIL   C
         WHERE A.PLANT_ID       = B.PLANT_ID
           AND C.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
           AND C.VALID_YN       = 'Y'
           AND C.SEGMENT2       = V_DIVISION_ID
           AND C.SEGMENT3       = V_GROUP_ID
           AND C.ATTRIBUTE1     = 'B'
           AND B.SCM_SITE_ID    = C.SEGMENT4
           AND A.PARENT_ITEM_ID = C.SEGMENT5
         GROUP BY B.SCM_SITE_ID, A.CHILD_ITEM_ID;

        /* 셀 생산지 버퍼 추가 */
        DELETE
          FROM GT_OPT_ENG_GMIS_CPS;

        INSERT
          INTO GT_OPT_ENG_GMIS_CPS
             ( SALES_SITE_ID
             , ITEM_ID
             , OPERATION_GROUP )
        SELECT A.SEGMENT3 AS SALES_SITE_ID
             , A.SEGMENT4 AS ITEM_ID

             , CASE WHEN B.OPERATION_GROUP IS NULL THEN NULL ELSE '_'||B.OPERATION_GROUP END AS OPERATION_GROUP
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             , SCP_MST_FINAL_ITEM            B
         WHERE A.SEGMENT1    = B.DIVISION_ID
           AND A.SEGMENT4    = B.ITEM_ID
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND A.SEGMENT1    = V_DIVISION_ID
           AND A.SEGMENT2    = V_GROUP_ID;

        /* 테스트를 위해 25년07주차로 고정
           SELECT @P_PLAN_NAME         = '20250210'; 당주 월요일 YYYYMMDD
           SELECT @V_CUTOFF_DAY        = '20250209'; 지난주 일요일 YYYYMMDD
           SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
           SELECT @MAX_TUESDAY         = '20250211'
           SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; 당주 화요일 YYYYMMDD */

        /* Data Insert Start */

        DELETE
          FROM GT_OPT_ENG_GMIS_INV;

        DELETE
          FROM GT_OPT_ENG_GMIS_INT;

        DELETE
          FROM GT_OPT_ENG_GMIS_CP;

        DELETE
          FROM GT_OPT_ENG_GMIS_ADJ;

        DELETE
          FROM GT_OPT_ENG_GMIS_DM;

        DELETE
          FROM GT_OPT_ENG_GMIS_DG;

        /* 재고 / 해상재고 INPUT 생성 전 중간 정보 생성 PROC 참고
             PR_SCP_ENG_IN_PRE_SET_INVENTORY
             PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS */

        /* 1. 창고 재고 : WH */
        /* 1.1 SALES 재고 */
        INSERT
          INTO GT_OPT_ENG_GMIS_INV
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
             , OPERATION_ID
             , LINE_ID
             , B_DEGAS_YN
             , FLAG )
        SELECT A.DIVISION_ID AS DIVISION_ID   /* DISTINCT */
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS     /* 뒤에서 별도 UPDATE */
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
                CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전
                     WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전 */
             , CASE WHEN A.WIPHOLD_YN IS NULL                                  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                    THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                            TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY               /* SCP 사용 QTY */
             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
             , B.SITE_TYPE
             , '-' AS LOCATION_CODE           /* PLANT 재고 구분용 정보 */
             , '-' AS PROJECT_CODE            /* 뒤에서 별도 UPDATE */
             , E.SCM_SITE_ID AS CELL_PROD_SITE_ID   /* ISNULL(..., '') : Oracle 빈문자열은 NULL 이므로 NULL 저장(하위 문자열병합은 IS NULL 로 처리) */
             , NULL    AS OPERATION_ID
             , NULL    AS LINE_ID
             , NULL    AS B_DEGAS_YN
             , 'SALES' AS FLAG
          FROM SCM_DNM_STOCK A
               /* SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음
                  ,(SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                     FROM   SCM_MST_SITE  WITH(NOLOCK)
                     WHERE  1=1
                     AND    SITE_TYPE        = 'SALES'
                    ) B */
               /* 소형 생산지 구분을 위한 분리 */
               INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                             FROM SCM_MST_SITE
                            WHERE 1 = 1
                              AND SITE_TYPE = 'SALES'
                          ) B
                  ON A.DIVISION_ID = B.DIVISION_ID
                 AND A.SCM_SITE_ID = B.SCM_SITE_ID
               /* INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                      ON A.PLANT_ID = MS.PLANT_ID */
               LEFT OUTER JOIN GT_OPT_ENG_GMIS_OCV C
                  ON A.SCM_SITE_ID = C.SCM_SITE_ID
                 AND A.MES_ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN GT_OPT_ENG_GMIS_CPS D
                  ON 1 = 1
                 AND A.SCM_SITE_ID = D.SALES_SITE_ID
                 AND A.ITEM_ID     = D.ITEM_ID
               LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                  FROM SCM_MST_SITE
                                 WHERE 1 = 1
                                   AND PLANT_ID IS NOT NULL
                               ) E
                  ON 1 = 1
                 AND A.DIVISION_ID = E.DIVISION_ID
                 /* MSSQL A.PLANT_ID + CPS.OPERATION_GROUP : 피연산자 NULL 이면 결과 NULL(무매칭). Oracle 문자열병합은 NULL 무시하므로 CASE 가드. */
                 AND CASE WHEN A.PLANT_ID IS NULL OR D.OPERATION_GROUP IS NULL THEN NULL
                          ELSE A.PLANT_ID||D.OPERATION_GROUP
                     END = E.SCM_SITE_ID
         WHERE 1 = 1
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND C.ITEM_ID IS NULL
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND (   (A.DIVISION_ID  = '40' AND NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') <> 'P')
                OR (A.DIVISION_ID <> '40')
               )
           /* 대상 프로젝트 ITEM 필터링
              AND    A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                   WHERE   PLAN_ID = @V_PLAN_ID
                                   ) */
           AND (   (A.DIVISION_ID  = '40' AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
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

        /* Oracle : ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN (INCOTERMS/LOCATION_CODE/PROJECT_CODE/LINE_ID/OPERATION_ID/B_DEGAS_YN VARCHAR(100)) */

        /* 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리 */
        INSERT
          INTO GT_OPT_ENG_GMIS_INV
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
             , OPERATION_ID
             , LINE_ID
             , B_DEGAS_YN
             , FLAG )
        SELECT A.DIVISION_ID    AS DIVISION_ID   /* DISTINCT */
             , A.TO_SCM_SITE_ID AS SCM_SITE_ID
             , '-'              AS INCOTERMS     /* 뒤에서 별도 UPDATE */
             , 'SO'             AS STOCK_TYPE
             , A.ITEM_ID        AS ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전
                엔진 오류로 Plan 구간 안으로 처리
                CONVERT(DATETIME, @V_CUTOFF_DAY) AS AVAILABLE_DATE */
             , TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') AS AVAILABLE_DATE
             , A.DELIVERY_QTY AS QTY
             , 'N'            AS WIPHOLD_YN
             , B.SITE_TYPE
             , '-'            AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN C.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END AS CELL_PROD_SITE_ID
             , NULL    AS OPERATION_ID
             , NULL    AS LINE_ID
             , NULL    AS B_DEGAS_YN
             , 'SALES' AS FLAG
          FROM SCM_DNM_INTRANSIT_C A
             , (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND SITE_TYPE = 'SALES'
               ) B
             , GT_OPT_ENG_GMIS_CPS C
         WHERE A.DIVISION_ID       = B.DIVISION_ID
           AND A.TO_SCM_SITE_ID    = B.SCM_SITE_ID
           AND A.TO_SCM_SITE_ID    = C.SALES_SITE_ID(+)
           AND A.ITEM_ID           = C.ITEM_ID(+)
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND A.RESULT_DATE       = V_CUTOFF_DAY
           /* SO Reserve Stock : result_type = 'B' 는 재고로 처리 */
           AND A.RESULT_TYPE       = 'B'
           AND A.VALID_YN          = 'Y'   /* 해상재고 */
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND (   (A.DIVISION_ID  = '40' AND NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') <> 'P')
                OR (A.DIVISION_ID <> '40')
               )
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           AND (   (A.DIVISION_ID  = '40' AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
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
               GT_OPT_ENG_GMIS_INV A
           SET A.INCOTERMS = NVL(NVL(
                             (SELECT MAX(CASE WHEN D.VMI_YN = 'Y' THEN 'DAP'
                                              ELSE B.INCOTERMS
                                         END) AS MAX_INCOTERMS
                                     /* VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) */
                                FROM DM_PLN_NET_DEMAND B
                                   , (SELECT SCM_SITE_ID, MAX(VERSION_NO) AS MAX_VERSION_NO
                                        FROM DM_PLN_NET_DEMAND
                                       WHERE DIVISION_ID     = V_DIVISION_ID
                                         AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                       GROUP BY SCM_SITE_ID
                                     ) C
                                   , (SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                        FROM SCM_MST_SITE
                                       WHERE DIVISION_ID = V_DIVISION_ID
                                         AND VMI_YN      = 'Y'
                                     ) D
                               WHERE B.SCM_SITE_ID     = C.SCM_SITE_ID
                                 AND B.VERSION_NO      = C.MAX_VERSION_NO
                                 AND B.DIVISION_ID     = D.DIVISION_ID(+)
                                 AND B.SCM_SITE_ID     = D.SCM_SITE_ID(+)
                                 AND B.DIVISION_ID     = V_DIVISION_ID
                                 AND B.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                 AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                                 AND B.ITEM_ID         = A.ITEM_ID
                             )
                           , (SELECT MAX(CASE WHEN D.VMI_YN = 'Y' THEN 'DAP'
                                              ELSE B.INCOTERMS
                                         END) AS MAX_INCOTERMS
                                     /* VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) */
                                FROM DM_PLN_NET_DEMAND B
                                   , (SELECT SCM_SITE_ID, MAX(VERSION_NO) AS MAX_VERSION_NO
                                        FROM DM_PLN_NET_DEMAND
                                       WHERE DIVISION_ID     = V_DIVISION_ID
                                         AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                       GROUP BY SCM_SITE_ID
                                     ) C
                                   , (SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                        FROM SCM_MST_SITE
                                       WHERE DIVISION_ID = V_DIVISION_ID
                                         AND VMI_YN      = 'Y'
                                     ) D
                               WHERE B.SCM_SITE_ID     = C.SCM_SITE_ID
                                 AND B.VERSION_NO      = C.MAX_VERSION_NO
                                 AND B.DIVISION_ID     = D.DIVISION_ID(+)
                                 AND B.SCM_SITE_ID     = D.SCM_SITE_ID(+)
                                 AND B.DIVISION_ID     = V_DIVISION_ID
                                 AND B.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                 AND B.SCM_SITE_ID     = A.SCM_SITE_ID
                             )), 'DAP')   /* DEMAND 없는 경우 DAP 처리 */
         WHERE 1 = 1
           AND A.SITE_TYPE = 'SALES';

        /* 1.4 PLANT 재고 */
        INSERT
          INTO GT_OPT_ENG_GMIS_INV
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
             , OPERATION_ID
             , LINE_ID
             , B_DEGAS_YN
             , FLAG )
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
                CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전
                     WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전 */
             , CASE WHEN A.WIPHOLD_YN IS NULL                                  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                    THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                            TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY
             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
             , B.SITE_TYPE
             , CASE WHEN C.LOCATION_CODE IS NOT NULL OR D.LOCATION_CODE IS NOT NULL THEN 'ASSY'
                    ELSE '-'
               END AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , ''            AS PROJECT_CODE
             , ''            AS CELL_PROD_SITE_ID
             , A.OPERATION_ID AS OPERATION_ID
             , A.LINE_ID      AS LINE_ID
             , NULL           AS B_DEGAS_YN
             , 'PLANT'        AS FLAG
          FROM SCM_DNM_STOCK A
             , (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND SITE_TYPE   = 'PLANT'
                   /* AND    OPERATION_GROUP IN ('A', 'P') */
                   AND (   (DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A'))        /* 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외 */
                        OR (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P'))
                       )
               ) B
             , (SELECT DISTINCT X.OPERATION_ID
                     , X.LOCATION_CODE
                     , X.SCM_SITE_ID
                  FROM SCM_MST_LOCATION X
                     , (SELECT SCM_SITE_ID
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID     = V_DIVISION_ID
                           AND VALID_YN        = 'Y'
                           AND OPERATION_GROUP IN ('A')
                       ) Y
                 WHERE X.SCM_SITE_ID   = Y.SCM_SITE_ID
                   AND X.DIVISION_ID   = V_DIVISION_ID   /* '81' */
                   AND X.VALID_YN      = 'Y'
                   AND X.LOCATION_CODE = 'PACKAGING'     /* 활성화 전 재고 */
                   AND (X.OPERATION_ID IS NOT NULL AND RTRIM(X.OPERATION_ID) IS NOT NULL)
               ) C   /* 셀의 operation_id 별 사용대상 조회 */
             , (SELECT DISTINCT X.STORAGE_ID
                     , X.LOCATION_CODE
                     , X.SCM_SITE_ID
                  FROM SCM_MST_LOCATION X
                     , (SELECT SCM_SITE_ID
                          FROM SCM_MST_SITE
                         WHERE DIVISION_ID     = V_DIVISION_ID
                           AND VALID_YN        = 'Y'
                           AND OPERATION_GROUP IN ('A')
                       ) Y
                 WHERE X.SCM_SITE_ID   = Y.SCM_SITE_ID
                   AND X.DIVISION_ID   = V_DIVISION_ID   /* '81' */
                   AND X.VALID_YN      = 'Y'
                   AND X.LOCATION_CODE = 'PACKAGING'     /* 활성화 전 재고 */
                   AND (X.STORAGE_ID IS NOT NULL AND RTRIM(X.STORAGE_ID) IS NOT NULL)
               ) D   /* 셀의 storage_id 별 사용대상 조회 */
             , GT_OPT_ENG_GMIS_OCV E
         WHERE A.DIVISION_ID  = B.DIVISION_ID
           AND A.SCM_SITE_ID  = B.SCM_SITE_ID
           AND A.OPERATION_ID = C.OPERATION_ID(+)
           AND A.SCM_SITE_ID  = C.SCM_SITE_ID(+)
           AND A.STORAGE_ID   = D.STORAGE_ID(+)
           AND A.SCM_SITE_ID  = D.SCM_SITE_ID(+)
           /* 소형 생산지 구분을 위한 분리
              INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                  ON A.PLANT_ID = MS.PLANT_ID */
           AND A.SCM_SITE_ID  = E.SCM_SITE_ID(+)
           AND A.MES_ITEM_ID  = E.ITEM_ID(+)
           AND A.CUTOFF_DATE  = V_CUTOFF_DAY
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND E.ITEM_ID IS NULL
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           AND (   (A.DIVISION_ID  = '40' AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
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

        /* 2. 활성화 재고 : FOR
           2026.05.08 Minyong Lee : 활성화 재고 뷰 중복 스캔 제거 (쿼리 수행 시간 단축) */
        INSERT
          INTO GT_OPT_ENG_GMIS_INV
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
             , OPERATION_ID
             , LINE_ID
             , B_DEGAS_YN
             , FLAG )
        SELECT A.DIVISION_ID AS DIVISION_ID
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS
             , 'FOR'         AS STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN A.BEFORE_DEGAS != 'Y' AND TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD')  < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    WHEN A.BEFORE_DEGAS  = 'Y' AND TO_CHAR(A.DEGAS_END_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* BEFORE DEGAS인 경우 DEGAS_END_DATE를 찍어줌 */
                    WHEN A.BEFORE_DEGAS  = 'Y' THEN TRUNC(A.DEGAS_END_DATE)
                    ELSE A.AVAILABLE_DATE
               END AS AVAILABLE_DATE
             , A.QTY AS QTY
             , NVL(A.WIPHOLD_YN, 'N') AS WIPHOLD_YN
             , 'PLANT'       AS SITE_TYPE
             , '-'           AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , ''            AS PROJECT_CODE
             , ''            AS CELL_PROD_SITE_ID
             , NULL          AS OPERATION_ID
             , A.LINE_ID     AS LINE_ID
             , A.BEFORE_DEGAS AS B_DEGAS_YN
             , 'PLANT'        AS FLAG
          FROM (SELECT Y.*
                  FROM (SELECT X.*
                             , MAX(X.CUTOFF_DATE) OVER (PARTITION BY X.DIVISION_ID, X.SITE_ID) AS MAX_CUTOFF_DATE
                          FROM SCM_DNM_STOCK_AGING_V X
                         WHERE X.DIVISION_ID  = V_DIVISION_ID
                           AND X.CUTOFF_DATE  > V_D_CUTOFF_DAY - 7    /* C의 조건을 여기서 한번에 처리 */
                           AND X.CUTOFF_DATE <= V_D_CUTOFF_DAY
                       ) Y
                 WHERE Y.CUTOFF_DATE = Y.MAX_CUTOFF_DATE
                   AND Y.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                       FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                      WHERE PLAN_ID = V_PLAN_ID
                                    )
               ) A
             /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경 */
             , (SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND SITE_TYPE   = 'PLANT'
                   AND NVL(OSP_YN, 'N') = 'N'   /* 20180822 추가 */
               ) B
             , SCP_MST_FORMATION_V C
         WHERE A.SCM_SITE_ID = B.SCM_SITE_ID(+)
           AND A.DIVISION_ID = C.DIVISION_ID(+)
           AND A.SCM_SITE_ID = C.PLANT_SITE_ID(+)
           AND A.ITEM_ID     = C.ITEM_ID(+)
           AND B.DIVISION_ID IS NOT NULL   /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함 */
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 ) */
           ;

        /* 3. 해상 재고 : INT */
        /* 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고
               - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
        INSERT
          INTO GT_OPT_ENG_GMIS_INT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SCM_SITE_ID
             , INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
             , CELL_PROD_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , B_DEGAS_YN
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
             /* IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN D.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-'   /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                    WHEN D.SITE_TYPE = 'SALES' THEN CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END
                    WHEN D.SITE_TYPE = 'PLANT' THEN ''   /* Plant 도착은 NULL 처리 */
                    ELSE CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END
               END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN E.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END AS CELL_PROD_SITE_ID
             , NULL AS OPERATION_ID
             , NULL AS LINE_ID
             , NULL AS B_DEGAS_YN
             , D.SITE_TYPE AS FLAG
          FROM INTRANSIT_MAT A
             , (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID
                  FROM SCM_MST_FINAL_ITEM_V
               ) B
             , (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID     = V_DIVISION_ID
                   AND SITE_TYPE       = 'PLANT'
                   AND OPERATION_GROUP IN ('A', 'P')   /* FROM_SITE 가 전극인 정보 제외 */
                   AND VALID_YN        = 'Y'
               ) C
             , SCM_MST_SITE          D
             , GT_OPT_ENG_GMIS_CPS   E
         WHERE A.DIVISION_ID         = B.DIVISION_ID
           AND A.ITEM_ID             = B.ITEM_ID
           AND B.OPERATION_GROUP_ID <> 'E'   /* 전극 모델은 제외 */
           AND A.DIVISION_ID         = C.DIVISION_ID
           AND A.FROM_SCM_SITE_ID    = C.SCM_SITE_ID
           AND (   (C.DIVISION_ID  = '40' AND C.OPERATION_GROUP = 'A')   /* 소형은 CEll Biz 용 Demand 만 처리 */
                OR (C.DIVISION_ID <> '40')
               )
           AND A.DIVISION_ID         = D.DIVISION_ID
           AND A.TO_SCM_SITE_ID      = D.SCM_SITE_ID
           /* AND TS.SITE_TYPE      = 'SALES' */
           AND D.VALID_YN            = 'Y'
           AND (   (D.DIVISION_ID  = '40' AND D.SITE_TYPE = 'SALES')     /* 소형은 CEll Biz 용 Demand 만 처리 */
                OR (D.DIVISION_ID <> '40')
               )
           AND A.TO_SCM_SITE_ID      = E.SALES_SITE_ID(+)
           AND A.ITEM_ID             = E.ITEM_ID(+)
           AND A.DIVISION_ID         = V_DIVISION_ID
           AND A.RESULT_DATE         = V_CUTOFF_DAY
           AND A.RESULT_TYPE IN ('I', 'C')   /* ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           AND (   (A.DIVISION_ID  = '40' AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
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

        /* Oracle : ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN (PROJECT_CODE/OPERATION_ID/LINE_ID/B_DEGAS_YN VARCHAR(100)) */

        /* 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
               - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함 */
        INSERT
          INTO GT_OPT_ENG_GMIS_INT
             ( DIVISION_ID
             , ITEM_ID
             , TO_SCM_SITE_ID
             , INCOTERMS
             , ETA_DATE
             , DELIVERY_QTY
             , PROJECT_CODE
             , CELL_PROD_SITE_ID
             , OPERATION_ID
             , LINE_ID
             , B_DEGAS_YN
             , FLAG )
        SELECT A.DIVISION_ID
             , A.ITEM_ID
             , B.SCM_SITE_ID AS TO_SCM_SITE_ID
             , 'DAP'         AS INCOTERMS   /* VMI 임 */
             /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD') AS ETA_DATE   /* PLAN 시작일자로 처리 */
             , NVL(A.SCM_QTY, 0) AS DELIVERY_QTY
             , '-'               AS PROJECT_CODE
             , F.SCM_SITE_ID     AS CELL_PROD_SITE_ID   /* ISNULL(..., '') : Oracle 빈문자열은 NULL */
             , NULL    AS OPERATION_ID
             , NULL    AS LINE_ID
             , NULL    AS B_DEGAS_YN
             , 'SALES' AS FLAG
          FROM SCM_DNM_STOCK A
               INNER JOIN SCM_MST_VMI_INT_SLOC B
                  ON A.DIVISION_ID = B.DIVISION_ID
                 AND A.PLANT_ID    = B.PLANT_ID
                 AND A.STORAGE_ID  = B.STORAGE_ID
                 AND B.VALID_YN    = 'Y'
               /* 소형 생산지 구분을 위한 분리 */
               INNER JOIN SCM_MST_SITE C
                  ON A.PLANT_ID = C.PLANT_ID
               LEFT OUTER JOIN GT_OPT_ENG_GMIS_OCV D
                  ON A.SCM_SITE_ID = D.SCM_SITE_ID
                 AND A.MES_ITEM_ID = D.ITEM_ID
               LEFT OUTER JOIN GT_OPT_ENG_GMIS_CPS E
                  ON 1 = 1
                 AND A.SCM_SITE_ID = E.SALES_SITE_ID
                 AND A.ITEM_ID     = E.ITEM_ID
               LEFT OUTER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                  FROM SCM_MST_SITE
                                 WHERE 1 = 1
                                   AND PLANT_ID IS NOT NULL
                               ) F
                  ON 1 = 1
                 AND A.DIVISION_ID = F.DIVISION_ID
                 /* MSSQL A.PLANT_ID + CPS.OPERATION_GROUP : 피연산자 NULL 이면 결과 NULL(무매칭). Oracle 문자열병합은 NULL 무시하므로 CASE 가드. */
                 AND CASE WHEN A.PLANT_ID IS NULL OR E.OPERATION_GROUP IS NULL THEN NULL
                          ELSE A.PLANT_ID||E.OPERATION_GROUP
                     END = F.SCM_SITE_ID
         WHERE 1 = 1
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND D.ITEM_ID IS NULL
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND (   (A.DIVISION_ID  = '40' AND NVL(FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID), '-') <> 'P')
                OR (A.DIVISION_ID <> '40')
               )
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           AND (   (A.DIVISION_ID  = '40' AND C.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
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
        INSERT
          INTO GT_OPT_ENG_GMIS_DM
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
                         WHERE PLAN_ID = V_PLAN_ID
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
                             , CAST(NULL AS VARCHAR2(150 CHAR)) AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL
                           AND ATTRIBUTE4 IS NULL
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
                       ) C
               ) D
         WHERE ROW_NUM = 1;

        /* #SCP_INVENTORY_I 프로젝트 UPDATE */
        /* START 2025-12-15 jongykim2: Demand Group Master */
        INSERT
          INTO GT_OPT_ENG_GMIS_DG
             ( DIVISION_ID
             , ITEM_ID
             , DEMAND_GROUP
             , PROJECT_CODE )
        SELECT B.DIVISION_ID
             , B.ITEM_ID
             , A.GROUP_NAME AS DEMAND_GROUP
             , B.PROJECT_CODE
          FROM SCP_MST_ITEM_GROUP        A
             , SCP_MST_ITEM_GROUP_DETAIL B
         WHERE B.DIVISION_ID = A.DIVISION_ID
           AND B.GROUP_ID    = A.GROUP_ID
           AND A.DIVISION_ID = V_DIVISION_ID
           AND A.VALID_YN    = 'Y'
           AND NVL(A.ATTRIBUTE1, 'N') <> 'Y'
           AND B.VALID_YN    = 'Y';
        /* END 2025-12-15 jongykim2: */

        /* (UPDATE..FROM INNER JOIN -> MERGE. 다중매치 ORA-30926 회피 위해 파생 B 를 조인키로 GROUP BY + MAX(PROJECT_CODE) 결정화. */
        MERGE
         INTO GT_OPT_ENG_GMIS_INV A
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
                       SELECT C.DIVISION_ID
                            , C.SCM_SITE_ID
                            , C.INCOTERMS
                            , C.STOCK_TYPE
                            , C.ITEM_ID
                            , C.MDF_ITEM_ID
                            , C.AVAILABLE_DATE
                            , C.QTY
                            , C.WIPHOLD_YN
                            , C.SITE_TYPE
                            , C.LOCATION_CODE
                            , D.PROJECT_CODE
                         FROM (
                               SELECT E.DIVISION_ID
                                    , E.SCM_SITE_ID
                                    , E.INCOTERMS
                                    , E.STOCK_TYPE
                                    , E.ITEM_ID
                                    /* IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID */
                                    , CASE WHEN F.ITEM_ID IS NULL THEN E.ITEM_ID ELSE F.DEMAND_GROUP END AS MDF_ITEM_ID
                                    , E.AVAILABLE_DATE
                                    , E.QTY
                                    , E.WIPHOLD_YN
                                    , E.SITE_TYPE
                                    , E.LOCATION_CODE
                                 FROM GT_OPT_ENG_GMIS_INV E
                                    /* LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                           ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                           AND LU.SEGMENT2 = @V_DIVISION_ID
                                           AND INV.ITEM_ID = LU.SEGMENT3
                                           AND LU.VALID_YN = 'Y' blocked 2025-12-15 jongykim2
                                       Added 2025-12-15 jongykim2: Demand Group Master */
                                    , GT_OPT_ENG_GMIS_DG F
                                WHERE E.ITEM_ID      = F.ITEM_ID(+)
                                  AND E.FLAG         = 'SALES'
                                  AND E.PROJECT_CODE = '-'
                                  AND E.QTY          > 0
                              ) C
                            , GT_OPT_ENG_GMIS_DM D
                        WHERE C.SCM_SITE_ID = D.SITE_ID
                          AND C.MDF_ITEM_ID = D.ITEM_ID
                          AND (   (C.INCOTERMS IS NULL AND D.INCOTERMS IS NULL)
                               OR (C.INCOTERMS = D.INCOTERMS)
                               OR (C.INCOTERMS IS NOT NULL AND D.INCOTERMS IS NULL)
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
        WHEN MATCHED THEN UPDATE
             SET A.PROJECT_CODE = B.PROJECT_CODE;

        /* #SCP_INTRANSIT_I 프로젝트 UPDATE
           (UPDATE..FROM INNER JOIN -> MERGE. 다중매치 ORA-30926 회피 위해 조인키 GROUP BY + MAX(PROJECT_CODE) 결정화.) */
        MERGE
         INTO GT_OPT_ENG_GMIS_INT A
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
                       SELECT C.DIVISION_ID
                            , C.ITEM_ID
                            , C.TO_SCM_SITE_ID
                            , C.INCOTERMS
                            , C.ETA_DATE
                            , C.DELIVERY_QTY
                            , C.FLAG
                            , D.PROJECT_CODE
                         FROM (
                               SELECT E.DIVISION_ID
                                    , E.ITEM_ID
                                    /* IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID */
                                    , CASE WHEN F.ITEM_ID IS NULL THEN E.ITEM_ID ELSE F.DEMAND_GROUP END AS MDF_ITEM_ID
                                    , E.TO_SCM_SITE_ID
                                    , E.INCOTERMS
                                    , E.ETA_DATE
                                    , E.DELIVERY_QTY
                                    , E.PROJECT_CODE
                                    , E.FLAG
                                 FROM GT_OPT_ENG_GMIS_INT E   /* WHERE PROJECT_CODE = '-' AND FLAG ='SALES' */
                                    /* LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                           ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                           AND LU.SEGMENT2 = @V_DIVISION_ID
                                           AND INV.ITEM_ID = LU.SEGMENT3
                                           AND LU.VALID_YN = 'Y' blocked 2025-12-15 jongykim2
                                       Added 2025-12-15 jongykim2: Demand Group Master */
                                    , GT_OPT_ENG_GMIS_DG F
                                WHERE E.ITEM_ID      = F.ITEM_ID(+)
                                  AND E.FLAG         = 'SALES'
                                  AND E.PROJECT_CODE = '-'
                                  AND E.DELIVERY_QTY > 0
                              ) C
                            , GT_OPT_ENG_GMIS_DM D
                        WHERE C.TO_SCM_SITE_ID = D.SITE_ID
                          AND C.MDF_ITEM_ID    = D.ITEM_ID
                          AND (   (C.INCOTERMS IS NULL AND D.INCOTERMS IS NULL)
                               OR (C.INCOTERMS = D.INCOTERMS)
                               OR (C.INCOTERMS IS NOT NULL AND D.INCOTERMS IS NULL)
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
        WHEN MATCHED THEN UPDATE
             SET A.PROJECT_CODE = B.PROJECT_CODE;

        /* CA별 CP 정보 */
        INSERT
          INTO GT_OPT_ENG_GMIS_CP
             ( DIVISION_ID
             , PLANT_ID
             , ITEM_ID_ASSY
             , ITEM_ID_PROD
             , PRIORITY_1ST
             , PRIORITY_2ND
             , PRIORITY_3RD )
        SELECT A.DIVISION_ID
             , A.PLANT_ID
             , A.ITEM_ID_ASSY
             , A.ITEM_ID_PROD
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.ITEM_ID_ASSY, A.PLANT_ID ORDER BY A.VALID_YN DESC, A.ITEM_ID_PROD) AS PRIORITY_1ST
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID, A.ITEM_ID_ASSY ORDER BY A.VALID_YN DESC, A.ITEM_ID_PROD) AS PRIORITY_2ND
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID_ASSY ORDER BY A.VALID_YN DESC, A.ITEM_ID_PROD) AS PRIORITY_3RD
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
         WHERE 1 = 1
           AND A.VALID_YN = 'Y';

        /* 2025.09.23 Philsu Park: 재고 보정값 반영을 위한 TEMP Input.
           MSSQL 'ASSY@' + LS.LINE_SIDE 등은 피연산자 NULL 이면 결과 NULL(하위 NOT EXISTS 매칭 및 STOCK_ID 생성에 영향). */
        INSERT
          INTO GT_OPT_ENG_GMIS_ADJ
             ( SCM_SITE_ID
             , ITEM_ID
             , STAGE_BUFFER
             , STAGE
             , EFFECTIVE_DATE
             , TYPE
             , QTY
             , INCOTERMS
             , PROJECT_CODE )
        SELECT A.SCM_SITE_ID
             , A.ITEM_ID
             , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' THEN 'CHAR'
                    WHEN C.OPERATION_ID IS NOT NULL                      THEN 'CHAR'
                    WHEN B.FLOW_ID = 'A9000'                             THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'ASSY@'||E.LINE_SIDE END
                    WHEN D.SCP_FLOW_ID = 'A8000'                         THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'STK@'||E.LINE_SIDE END
                    WHEN A.BEFORE_DEGAS = 'Y'                            THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'B_DEGAS@'||E.LINE_SIDE END
                    WHEN A.BEFORE_DEGAS = 'N'                            THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'A_DEGAS@'||E.LINE_SIDE END
                    ELSE '-'
               END AS STAGE_BUFFER
             , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' THEN 'CHAR'
                    WHEN C.OPERATION_ID IS NOT NULL                      THEN 'CHAR'
                    WHEN B.FLOW_ID = 'A9000'                             THEN 'ASSY'
                    WHEN D.SCP_FLOW_ID = 'A8000'                         THEN 'STK'
                    WHEN A.BEFORE_DEGAS = 'Y'                            THEN 'B_DEGAS'
                    WHEN A.BEFORE_DEGAS = 'N'                            THEN 'A_DEGAS'
                    ELSE '-'
               END AS STAGE
             , A.INV_DATE        AS EFFECTIVE_DATE
             , A.STOCK_TYPE      AS TYPE
             , SUM(A.CHG_QTY)    AS QTY
             , A.INCOTERMS       AS INCOTERMS
             , A.PROJECT_CODE    AS PROJECT_CODE
             /* , ADJ.LINE_ID         AS LINE_ID
                , ADJ.BEFORE_DEGAS    AS B_DEGAS_YN
                , 'ADJUST'            AS FLAG
                , ADJ.QTY */
          FROM SCP_OPMZ_INV_ADJ A
             , (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                  FROM SCP_MST_FINAL_ITEM
                 WHERE DIVISION_ID     = V_DIVISION_ID
                   AND OPERATION_GROUP IN ('A', 'P')
               ) B
             , (SELECT DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID
                  FROM SCM_LINE_M_SN X
                 WHERE X.DIVISION_ID  = V_DIVISION_ID
                   AND X.OPERATION_ID = 'B1000'
                   AND X.ACTIVE_FLAG  = 'Y'
               ) C
             , (SELECT DIVISION_ID, ITEM_ID, SCP_FLOW_ID
                  FROM SCM_ITEM_M_SN
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND SCP_FLOW_ID IS NOT NULL
                 GROUP BY DIVISION_ID, ITEM_ID, SCP_FLOW_ID
               ) D
             , (SELECT SEGMENT3   AS SITE_ID
                     , SEGMENT4   AS LINE_ID
                     , ATTRIBUTE1 AS LINE_SIDE
                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL X
                 WHERE X.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_LINE'
                   AND X.SEGMENT1    = V_DIVISION_ID
                   AND X.SEGMENT2    = V_GROUP_ID
               ) E
         WHERE B.ITEM_ID(+)     = A.ITEM_ID
           AND B.DIVISION_ID(+) = A.DIVISION_ID
           AND C.DIVISION_ID(+) = A.DIVISION_ID
           AND C.PLANT_ID(+)    = A.FROM_SITE_ID
           AND C.LINE_ID(+)     = A.LINE_ID
           AND D.DIVISION_ID    = A.DIVISION_ID
           AND D.ITEM_ID        = A.ITEM_ID
           AND E.SITE_ID(+)     = A.SCM_SITE_ID
           AND E.LINE_ID(+)     = A.LINE_ID
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_PLAN_START_YYYYMMDD
           /* AND     ADJ.CHG_QTY         > 0 */
           AND A.LINE_ID        != '-'
           AND A.INV_DATE       >= V_PLAN_START_YYYYMMDD
           AND A.INV_DATE        < V_PLAN_END_YYYYMMDD
         GROUP BY A.SCM_SITE_ID
                , A.ITEM_ID
                , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' THEN 'CHAR'
                       WHEN C.OPERATION_ID IS NOT NULL THEN 'CHAR'
                       WHEN B.FLOW_ID = 'A9000' THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'ASSY@'||E.LINE_SIDE END
                       WHEN D.SCP_FLOW_ID = 'A8000' THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'STK@'||E.LINE_SIDE END
                       WHEN A.BEFORE_DEGAS = 'Y' THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'B_DEGAS@'||E.LINE_SIDE END
                       WHEN A.BEFORE_DEGAS = 'N' THEN CASE WHEN E.LINE_SIDE IS NULL THEN NULL ELSE 'A_DEGAS@'||E.LINE_SIDE END
                       ELSE '-'
                  END
                , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' THEN 'CHAR'
                       WHEN C.OPERATION_ID IS NOT NULL THEN 'CHAR'
                       WHEN B.FLOW_ID = 'A9000' THEN 'ASSY'
                       WHEN D.SCP_FLOW_ID = 'A8000' THEN 'STK'
                       WHEN A.BEFORE_DEGAS = 'Y' THEN 'B_DEGAS'
                       WHEN A.BEFORE_DEGAS = 'N' THEN 'A_DEGAS'
                       ELSE '-'
                  END
                , A.INV_DATE
                , A.STOCK_TYPE
                , A.INCOTERMS
                , A.PROJECT_CODE;

        /* INCOMING STOCK INSERT
           2025.09.16 Philsu Park: Stage 판정 안되는 재고 제외. */
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
             , ATTRIBUTE6 )
        SELECT A.PLAN_ID
             , A.STOCK_ID
             , A.BUFFER_ID
             , A.EFECTIVE_DATE
             , A.TYPE
             , SUM(A.QUANTITY) AS QUANTITY
             , A.SITE_ID
             , A.ITEM_ID
             , A.STAGE
             , A.INCOTERMS
             , A.PROJECT_CODE
             , A.STAGE_BUFFER
          FROM (
                SELECT V_PLAN_ID AS PLAN_ID
                     , TYPE||'::'||SITE_ID||'::'||ITEM_ID||'::'||STAGE_BUFFER||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||'::'||EFECTIVE_DATE||CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::'||CELL_PROD_SITE_ID END AS STOCK_ID
                     , SITE_ID||'::'||ITEM_ID||'::'||STAGE_BUFFER||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::'||CELL_PROD_SITE_ID END AS BUFFER_ID
                     , EFECTIVE_DATE AS EFECTIVE_DATE
                     , TYPE          AS TYPE
                     , QTY           AS QUANTITY
                     , SITE_ID       AS SITE_ID
                     , ITEM_ID       AS ITEM_ID
                     , STAGE         AS STAGE
                     , STAGE_BUFFER  AS STAGE_BUFFER
                     , INCOTERMS     AS INCOTERMS
                     , PROJECT_CODE  AS PROJECT_CODE
                  FROM (

                        SELECT A.SCM_SITE_ID AS SITE_ID
                             /* , A.ITEM_ID AS ITEM_ID */
                             , CASE   /* 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함 */
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-'
                                         THEN NVL(NVL(NVL(D.ITEM_ID_PROD, E.ITEM_ID_PROD), F.ITEM_ID_PROD), A.ITEM_ID)
                                    ELSE A.ITEM_ID
                               END AS ITEM_ID

                             , CASE WHEN A.OPERATION_ID = 'A8000' THEN CASE WHEN G.ATTRIBUTE1 IS NULL THEN NULL ELSE 'STK@'||G.ATTRIBUTE1 END
                                    WHEN A.OPERATION_ID = 'A9000' THEN CASE WHEN G.ATTRIBUTE1 IS NULL THEN NULL ELSE 'ASSY@'||G.ATTRIBUTE1 END
                                    WHEN A.OPERATION_ID = 'F6000' THEN CASE WHEN G.ATTRIBUTE1 IS NULL THEN NULL ELSE 'EOL@'||G.ATTRIBUTE1 END
                                    WHEN A.B_DEGAS_YN   = 'Y'     THEN CASE WHEN G.ATTRIBUTE1 IS NULL THEN NULL ELSE 'B_DEGAS@'||G.ATTRIBUTE1 END
                                    WHEN A.B_DEGAS_YN   = 'N'     THEN CASE WHEN G.ATTRIBUTE1 IS NULL THEN NULL ELSE 'A_DEGAS@'||G.ATTRIBUTE1 END
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                    WHEN A.OPERATION_ID = 'B1000' THEN 'CHAR'
                                    ELSE '-'
                               END AS STAGE_BUFFER
                             , CASE WHEN A.OPERATION_ID = 'A8000' THEN 'STK'
                                    WHEN A.OPERATION_ID = 'A9000' THEN 'ASSY'
                                    WHEN A.OPERATION_ID = 'F6000' THEN 'EOL'
                                    WHEN A.B_DEGAS_YN   = 'Y'     THEN 'B_DEGAS'
                                    WHEN A.B_DEGAS_YN   = 'N'     THEN 'A_DEGAS'
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                    WHEN A.OPERATION_ID = 'B1000' THEN 'CHAR'
                                    ELSE '-'
                               END AS STAGE
                             /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성
                                , CASE
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'
                                            THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'PACK' ELSE 'PACKBIZ' END)
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'
                                            THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'MDLE' ELSE 'MDLEBIZ' END)
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500')
                                            THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'SUBMDLE' ELSE 'SUBMDLEBIZ' END)
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'PLANT' THEN 'PACK'
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'SALES' THEN 'PACKBIZ'
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'PLANT' THEN 'MDLE'
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'SALES' THEN 'MDLEBIZ'
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                                       WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'SALES' THEN 'CELLBIZ'
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND a.DESCR LIKE 'FOR%' THEN 'ASY_AGING' 활성화 재고
                                       활성화 완료 재고 : 'CHAR' 버퍼 재고로 처리하고 ASSY Item 인 경우 CHAR Item 으로 Update 처리함
                                       활성화 전 재고 : 'ASSY'
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'ASY_AGING' ELSE 'ASSY' END)
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END)
                                       SUBMDLE는 FINAL ITEM에 없으므로 다른 TABLE에서 확인
                                       WHEN SMC.SCP_FLOW_ID = 'A8000' THEN 'STK'
                                       ELSE '-' END STAGE */
                             , TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                             , A.DESCR AS TYPE
                             , A.QTY   AS QTY
                             , A.INCOTERMS
                             , A.PROJECT_CODE
                             , A.CELL_PROD_SITE_ID
                          FROM (
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     /* MSSQL GROUP BY CONVERT(CHAR(8),AVAILABLE_DATE,112) 는 일 단위 그룹핑 -> Oracle TRUNC 로 동치 표현 */
                                     , TRUNC(AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(QTY) AS QTY
                                     , CASE WHEN NVL(A.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                            ELSE 'WH_HOLD'
                                       END AS DESCR
                                     , LOCATION_CODE
                                     , PROJECT_CODE
                                     , CELL_PROD_SITE_ID
                                     , OPERATION_ID
                                     , LINE_ID
                                     , B_DEGAS_YN
                                     , FLAG
                                  FROM GT_OPT_ENG_GMIS_INV A
                                 WHERE 1 = 1
                                   AND A.STOCK_TYPE <> 'FOR'
                                 GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, TRUNC(AVAILABLE_DATE), NVL(A.WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, OPERATION_ID, LINE_ID, B_DEGAS_YN
                                HAVING SUM(A.QTY) > 0
                                UNION ALL
                                /* 활성화 재고 : FOR 로 처리 */
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TRUNC(AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(QTY) AS QTY
                                     , CASE WHEN NVL(A.WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
                                            ELSE 'FOR_HOLD'
                                       END AS DESCR
                                     , LOCATION_CODE
                                     , PROJECT_CODE
                                     , CELL_PROD_SITE_ID
                                     , OPERATION_ID
                                     , LINE_ID
                                     , B_DEGAS_YN
                                     , FLAG
                                  FROM GT_OPT_ENG_GMIS_INV A
                                 WHERE 1 = 1
                                   AND A.STOCK_TYPE = 'FOR'   /* 활성화 재고 */
                                   AND A.QTY        > 0
                                 GROUP BY DIVISION_ID, ITEM_ID, SCM_SITE_ID, TRUNC(AVAILABLE_DATE), NVL(A.WIPHOLD_YN, 'N'), INCOTERMS, LOCATION_CODE, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, OPERATION_ID, LINE_ID, B_DEGAS_YN
                                UNION ALL
                                /* INTRANSIT SHIPMENT 재고 */
                                SELECT DIVISION_ID
                                     , ITEM_ID
                                     , TO_SCM_SITE_ID AS SCM_SITE_ID
                                     , INCOTERMS
                                     , TO_DATE(ETA_DATE, 'YYYYMMDD') AS EFFSTARTDATE
                                     , SUM(DELIVERY_QTY) AS QTY
                                     , 'INT' AS DESCR
                                     , '-'   AS LOCATION_CODE
                                     , PROJECT_CODE
                                     , CELL_PROD_SITE_ID
                                     , OPERATION_ID
                                     , LINE_ID
                                     , B_DEGAS_YN
                                     , FLAG
                                  FROM GT_OPT_ENG_GMIS_INT A
                                 WHERE 1 = 1
                                   AND A.DELIVERY_QTY > 0

                                   AND (A.ETA_DATE IS NOT NULL)
                                 GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, ETA_DATE, INCOTERMS, PROJECT_CODE, FLAG, CELL_PROD_SITE_ID, OPERATION_ID, LINE_ID, B_DEGAS_YN
                               ) A
                               LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                            FROM SCP_MST_FINAL_ITEM
                                           WHERE DIVISION_ID     = V_DIVISION_ID
                                             AND OPERATION_GROUP IN ('A', 'P')
                                         ) B
                                  ON A.ITEM_ID     = B.ITEM_ID
                                 AND A.DIVISION_ID = B.DIVISION_ID
                               LEFT JOIN SCM_MST_SITE C
                                  ON C.DIVISION_ID = A.DIVISION_ID
                                 AND C.SCM_SITE_ID = A.SCM_SITE_ID
                                 AND C.SITE_TYPE   = 'PLANT'
                               LEFT JOIN GT_OPT_ENG_GMIS_CP D
                                  ON D.DIVISION_ID  = A.DIVISION_ID
                                 AND D.PLANT_ID     = C.PLANT_ID
                                 AND D.ITEM_ID_ASSY = A.ITEM_ID
                                 AND D.PRIORITY_1ST = 1
                               LEFT JOIN GT_OPT_ENG_GMIS_CP E
                                  ON E.DIVISION_ID  = A.DIVISION_ID
                                 AND E.ITEM_ID_ASSY = A.ITEM_ID
                                 AND E.PRIORITY_2ND = 1
                               LEFT JOIN GT_OPT_ENG_GMIS_CP F
                                  ON F.ITEM_ID_ASSY = A.ITEM_ID
                                 AND F.PRIORITY_3RD = 1
                               LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL G
                                  ON G.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_LINE'
                                 AND A.DIVISION_ID = G.SEGMENT1
                                 AND G.SEGMENT2    = V_GROUP_ID
                                 AND A.SCM_SITE_ID = G.SEGMENT3
                                 AND A.LINE_ID     = G.SEGMENT4
                               /* SUBMDLE의 STAGE를 찾기 위해 추가
                                  LEFT  JOIN (
                                              SELECT  SM.DIVISION_ID
                                                     ,SM.SCM_SITE_ID
                                                     ,IM.ITEM_ID
                                                     ,IM.SCP_FLOW_ID
                                                     ,IM.SCP_OPERATION_GROUP
                                              FROM    SCM_ITEM_M_SN IM WITH(NOLOCK)
                                                  INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
                                                      ON  IM.COMPANY_ID = SM.COMPANY_ID
                                                      AND IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                                              WHERE   1=1
                                              AND     CONCAT (SM.SCM_SITE_ID,IM.ITEM_ID) IN(
                                                                   SELECT  DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                                                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                   WHERE   PLAN_ID = @V_PLAN_ID
                                                                   )
                                              AND     IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500') SUBMDLE만 걸리도록
                                              AND     IM.SCP_OPERATION_GROUP = 'P'             SUBMDLE만 걸리도록
                                              ) SMC
                                       ON  A.DIVISION_ID = SMC.DIVISION_ID
                                       AND A.SCM_SITE_ID = SMC.SCM_SITE_ID
                                       AND A.ITEM_ID     = SMC.ITEM_ID */
                         WHERE 1 = 1
                           /* AND    A.ITEM_ID = B.ITEM_ID
                              AND    B.ITEM_TYPE <> 'R' R TYPE의 재고는 올리지 않음 */
                           /* 대상 프로젝트 ITEM 필터링 */
                           AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                               FROM SCP_OPT_ENG_MODEL_LIST_N_SN
                                              WHERE PLAN_ID = V_PLAN_ID
                                            )
                       ) A
                 WHERE 1 = 1
                   AND STAGE != '-'
                   AND EFECTIVE_DATE < V_PLAN_END_YYYYMMDD
                   AND NOT EXISTS (SELECT 1
                                     FROM GT_OPT_ENG_GMIS_ADJ B
                                    WHERE B.SCM_SITE_ID    = A.SITE_ID
                                      AND B.ITEM_ID        = A.ITEM_ID
                                      AND B.STAGE_BUFFER   = A.STAGE_BUFFER
                                      AND B.STAGE          = A.STAGE
                                      AND B.TYPE           = A.TYPE
                                      AND B.EFFECTIVE_DATE = A.EFECTIVE_DATE
                                      AND B.INCOTERMS      = A.INCOTERMS
                                      AND B.PROJECT_CODE   = A.PROJECT_CODE
                                  )
                /* 자재/포장재의 입고 예정정보
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
                     , STAGE       AS STAGE_BUFFER
                     , '-'         AS INCOTERMS
                     , '-'         AS PROJECT_CODE
                  FROM (
                        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
                        SELECT A.PLANT_SITE_ID AS SCM_SITE_ID
                             , A.ITEM_ID_CHILD AS MAT_ID
                             , 'MATERIAL_CONST' AS STAGE
                             , A.TO_YYYYMMDD    AS ARR_DATE

                             , TO_NUMBER(A.TO_EXPC_QTY) AS QTY
                             , 'MC' AS TYPE
                          FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION A
                             , SCP_OPMZ_PLAN_GR_M                     B
                             , GT_OPT_ENG_GMIS_MAT                    C
                         WHERE A.OPMZ_PLAN_GR_ID   = B.OPMZ_PLAN_GR_ID
                           AND A.ITEM_ID_CHILD     = C.MAT_ID
                           AND 1 = 1
                           AND A.DIVISION_ID       = V_DIVISION_ID
                           AND B.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                           AND A.VALID_YN          = 'Y'
                           AND B.VALID_YN          = 'Y'
                           AND A.TO_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND C.EFF_END_DATE
                        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
                        /* SELECT  LU.SEGMENT4      AS SCM_SITE_ID
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
                       ) A
                 WHERE ARR_DATE < V_PLAN_END_YYYYMMDD
                /* 2025.09.30 Philsu Park: Workbench 재고 추가 */
                UNION ALL
                SELECT V_PLAN_ID AS PLAN_ID
                     , TYPE||'::'||SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE_BUFFER||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END||'::'||EFFECTIVE_DATE AS STOCK_ID
                     , SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE_BUFFER||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END AS BUFFER_ID
                     , EFFECTIVE_DATE AS EFFECTIVE_DATE
                     , TYPE           AS TYPE
                     , QTY            AS QUANTITY
                     , SCM_SITE_ID    AS SITE_ID
                     , ITEM_ID        AS ITEM_ID
                     , STAGE          AS STAGE
                     , STAGE_BUFFER   AS STAGE_BUFFER
                     , INCOTERMS      AS INCOTERMS
                     , PROJECT_CODE   AS PROJECT_CODE
                  FROM GT_OPT_ENG_GMIS_ADJ A
                 WHERE QTY > 0
               ) A
               /* INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                      ON  ML.PLAN_ID      = @V_PLAN_ID
                      AND AA.SITE_ID      = ML.SCM_SITE_ID
                      AND AA.ITEM_ID      = ML.ITEM_ID
                      AND AA.STAGE_BUFFER = ML.STAGE */
         GROUP BY A.PLAN_ID, A.STOCK_ID, A.BUFFER_ID, A.EFECTIVE_DATE, A.TYPE, A.SITE_ID, A.ITEM_ID, A.STAGE, A.STAGE_BUFFER, A.INCOTERMS, A.PROJECT_CODE;

        /* TRAY 제약을 위한 데이터 추가
           2025-07-30 THK */
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
             , ATTRIBUTE6 )
        SELECT V_PLAN_ID AS PLAN_ID
             , 'TRAY'||'::'||A.SEGMENT4||'::'||A.SEGMENT5||'::'||A.SEGMENT6||CASE WHEN RTRIM(A.SEGMENT3) IS NULL THEN '' ELSE '@'||A.SEGMENT3 END AS STOCK_ID
             , A.SEGMENT4||'::'||A.SEGMENT5||'::'||A.SEGMENT6||CASE WHEN RTRIM(A.SEGMENT3) IS NULL THEN '' ELSE '@'||A.SEGMENT3 END AS BUFFER_ID
             , V_PLAN_START_YYYYMMDD AS EFFECTIVE_DATE
             , 'TRAY' AS TYPE
             , TO_NUMBER(A.ATTRIBUTE1) - NVL(B.QUANTITY, 0) AS QUANTITY   /* changed 2025-12-02 ISNULL 처리 */
             , A.SEGMENT4 AS ATTRIBUTE1
             , A.SEGMENT5 AS ATTRIBUTE2
             , A.SEGMENT6 AS ATTRIBUTE3
             , A.SEGMENT6||CASE WHEN RTRIM(A.SEGMENT3) IS NULL THEN '' ELSE '@'||A.SEGMENT3 END AS ATTRIBUTE6
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             /* INNER JOIN( blocked 2025-12-02 jongykim2
                changed 2025-12-02 jongykim2: left join으로 변경 */
             , (SELECT ITEM_ID
                     , EW_FLAG
                     , SUM(QUANTITY) AS QUANTITY
                  FROM (
                        SELECT 'B_TRAY' AS ITEM_ID
                             , SUBSTR(X.ATTRIBUTE6, -1) AS EW_FLAG
                             , X.QUANTITY AS QUANTITY
                          FROM SCP_OPT_ENG_INCOMING_STOCK_SN X
                         WHERE X.PLAN_ID = V_PLAN_ID
                           AND (   (X.ATTRIBUTE3 = 'ASSY' AND X.EFFECTIVE_DATE <= V_PLAN_START_YYYYMMDD)
                                OR X.ATTRIBUTE3 = 'B_DEGAS')
                       ) Y
                 GROUP BY ITEM_ID, EW_FLAG
                UNION ALL
                SELECT ITEM_ID
                     , EW_FLAG
                     , SUM(QUANTITY) AS QUANTITY
                  FROM (
                        SELECT 'A_TRAY' AS ITEM_ID
                             , SUBSTR(X.ATTRIBUTE6, -1) AS EW_FLAG
                             , X.QUANTITY AS QUANTITY
                          FROM SCP_OPT_ENG_INCOMING_STOCK_SN X
                         WHERE X.PLAN_ID = V_PLAN_ID
                           AND X.ATTRIBUTE3 = 'A_DEGAS'
                       ) Y
                 GROUP BY ITEM_ID, EW_FLAG
               ) B
         WHERE A.SEGMENT5    = B.ITEM_ID(+)
           AND A.SEGMENT3    = B.EW_FLAG(+)
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
           AND A.VALID_YN    = 'Y'
           AND A.SEGMENT1    = V_DIVISION_ID
           AND A.SEGMENT2    = V_GROUP_ID;

        /* 2025.09.08 Philsu Park: Hold 재고의 Release를 룩업 기반으로 반영. (PSD + n)
           조립은 동편, 서편 구분이 있으므로 Attribute6(Stage+Side) 와 Join.
           (UPDATE..FROM INNER JOIN -> MERGE. 다중매치 ORA-30926 회피 위해 B 를 조인키로 GROUP BY + MAX(ADD_DAYS) 결정화. */
        MERGE
         INTO SCP_OPT_ENG_INCOMING_STOCK_SN A
        USING (
               SELECT SEGMENT3 AS SITE_ID
                    , CASE WHEN SEGMENT5 = '-' THEN SEGMENT4 ELSE SEGMENT4||'@'||SEGMENT5 END AS EW_STAGE
                    , MAX(TO_NUMBER(ATTRIBUTE1)) AS ADD_DAYS
                 FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL
                WHERE LOOKUP_TYPE = 'SCP_OPT_ENG_GM_RELEASE_HOLD'
                  AND VALID_YN    = 'Y'
                  AND SEGMENT1    = V_DIVISION_ID
                  AND SEGMENT2    = V_GROUP_ID
                GROUP BY SEGMENT3, CASE WHEN SEGMENT5 = '-' THEN SEGMENT4 ELSE SEGMENT4||'@'||SEGMENT5 END
              ) B
           ON (    B.SITE_ID  = A.ATTRIBUTE1
               AND B.EW_STAGE = A.ATTRIBUTE6
               AND A.PLAN_ID  = V_PLAN_ID
               AND INSTR(A.TYPE, 'HOLD') > 0 )
        WHEN MATCHED THEN UPDATE
             SET A.EFFECTIVE_DATE = TO_CHAR(V_D_PLAN_NAME + B.ADD_DAYS, 'YYYYMMDD')
               , A.UPDATE_ID      = 'HOLD_UPDATE'
               , A.UPDATE_TIME    = SYSDATE;

        /* 2nd OCV 재고는 INSP로 UPDATE
           UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
           SET     SCP_OPT_ENG_INCOMING_STOCK_SN.STOCK_ID   = INC.TYPE+'::'+INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+OCV.TO_BE_STAGE+'::'+INC.EFFECTIVE_DATE
                  ,SCP_OPT_ENG_INCOMING_STOCK_SN.BUFFER_ID  = INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+OCV.TO_BE_STAGE
                  ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE3 = OCV.TO_BE_STAGE
           FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INC WITH(NOLOCK)
               INNER JOIN (
                          SELECT  ATTRIBUTE2 AS AS_IS_STAGE
                                 ,ATTRIBUTE3 AS TO_BE_STAGE
                                 ,SEGMENT4   AS SCM_SITE_ID
                                 ,SEGMENT5   AS ITEM_ID
                          FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                          WHERE   1=1
                          AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                          AND     LU.VALID_YN    = 'Y'
                          AND     LU.SEGMENT2    = @V_DIVISION_ID
                          AND     LU.SEGMENT3    = @V_GROUP_ID
                          GROUP BY ATTRIBUTE2, ATTRIBUTE3, SEGMENT4, SEGMENT5
                          ) OCV
                   ON  INC.ATTRIBUTE1 = OCV.SCM_SITE_ID
                   AND INC.ATTRIBUTE2 = OCV.ITEM_ID
                   AND INC.ATTRIBUTE3 = OCV.AS_IS_STAGE
           WHERE   INC.PLAN_ID = @V_PLAN_ID */

        /* Data Insert End */


        DELETE
          FROM GT_OPT_ENG_GMIS_INV;

        DELETE
          FROM GT_OPT_ENG_GMIS_INT;

        DELETE
          FROM GT_OPT_ENG_GMIS_CP;

        DELETE
          FROM GT_OPT_ENG_GMIS_ADJ;

        DELETE
          FROM GT_OPT_ENG_GMIS_DM;

        DELETE
          FROM GT_OPT_ENG_GMIS_DG;

        DELETE
          FROM GT_OPT_ENG_GMIS_OCV;

        DELETE
          FROM GT_OPT_ENG_GMIS_CPS;

        DELETE
          FROM GT_OPT_ENG_GMIS_MAT;

    /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ERROR LOG */
    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR(SQLERRM, 1, 1000);
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'ERROR', NULL, V_MESSAGE_TEXT, NULL, V_PLAN_ID);
            V_DETAIL_DATE := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, V_DETAIL_DATE, NULL, V_MESSAGE_TEXT, 'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* 종료 LOG */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
    END IF;
END PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK;