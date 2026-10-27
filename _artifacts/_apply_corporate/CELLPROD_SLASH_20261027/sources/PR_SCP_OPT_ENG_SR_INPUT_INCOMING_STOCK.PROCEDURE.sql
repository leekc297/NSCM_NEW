PROCEDURE PR_SCP_OPT_ENG_SR_INPUT_INCOMING_STOCK
(
     P_PLAN_ID              VARCHAR2
    ,P_DIVISION_ID          VARCHAR2
    ,P_GROUP_ID             VARCHAR2
    ,P_PLAN_START_YYYYMMDD  VARCHAR2
    ,P_PLAN_END_YYYYMMDD    VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_SR_INPUT_INCOMING_STOCK
 * Description  : Optimization Engine(SR) 입력용 Incoming Stock 생성
 *                (창고재고 WH / 활성화재고 FOR / 해상재고 INT / 재고보정 INVENTORY_ADJUST /
 *                 자재 입고예정 MC / 소형 INCOTERMS 보정 / 2nd OCV 재고 계산)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.05    Y.S.H          Initial Release
 * 2026.10.19    ZIONEX         [PJ202650304]  MSSQL -> Oracle 전환
 *                                 @MAT_CONST_TEMP     -> GT_OPT_SR_IS_MAT
 *                                 @DM_TEMP            -> GT_OPT_SR_IS_DM
 *                                 @OCV_EXCEPT_LIST    -> GT_OPT_SR_IS_OCVEX
 *                                 @CELL_PROD_SITE     -> GT_OPT_SR_IS_CPS
 *                                 @INC_TEMP           -> GT_OPT_SR_IS_INC
 *                                 @INC_DEL_TEMP       -> GT_OPT_SR_IS_INCDEL
 *                                 @OCV_ALL_SUB_TEMP   -> GT_OPT_SR_IS_OCVA
 *                                 @OCV_2ND_SUB_TEMP   -> GT_OPT_SR_IS_OCV2
 *                                 @OCV_INV_MST_TEMP   -> GT_OPT_SR_IS_OCVM
 *                                 @OCV_INV_TEMP       -> GT_OPT_SR_IS_OCVI
 *                                 #SCP_INVENTORY_I    -> GT_OPT_SR_IS_INV
 *                                 #SCP_INTRANSIT_I    -> GT_OPT_SR_IS_INT
 *                                 #CP_INFO            -> GT_OPT_SR_IS_CP
 *                                 #INVENTORY_ADJUST   -> GT_OPT_SR_IS_ADJ
 *                               상위 RUN_MAIN_PROC 가 호출하는 하위 단계이므로 내부 COMMIT 없음(부모 트랜잭션 소유).
 * ============================================================ */
AS
    /* 2025.02.05 Y.S.H Initial Release */
    /* Set Prameter */
    V_PROGRAM_NAME        VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_SR_INPUT_INCOMING_STOCK';
    V_PLAN_ID             VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_DIVISION_ID         VARCHAR2(20 CHAR)   := P_DIVISION_ID;
    V_GROUP_ID            VARCHAR2(20 CHAR)   := P_GROUP_ID;
    V_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR)    := P_PLAN_START_YYYYMMDD;
    V_PLAN_END_YYYYMMDD   VARCHAR2(8 CHAR)    := P_PLAN_END_YYYYMMDD;
    V_MESSAGE_TEXT        VARCHAR2(1000 CHAR);
    V_DETAIL_DATE         DATE;
    /* Set Param for Biz */
    V_P_PLAN_NAME         VARCHAR2(8 CHAR);
    V_D_PLAN_NAME         DATE;
    V_P_PLAN_TYPE         VARCHAR2(4000 CHAR);
    V_P_SEQ               VARCHAR2(4000 CHAR);
    V_P_MODELING_ID       VARCHAR2(4000 CHAR);
    V_CUTOFF_DAY          VARCHAR2(8 CHAR);
    V_D_CUTOFF_DAY        DATE;
    V_DEMAND_CUTOFF_DAY   VARCHAR2(8 CHAR);
    V_MAX_TUESDAY         VARCHAR2(8 CHAR);
    /* 2nd OCV 재고 계산을 위한 변수 선언 */
    V_FP_INV_CUTOFF_DATE  VARCHAR2(8 CHAR);
    V_1ST_PREV_CHILD      VARCHAR2(50 CHAR)   := NULL;
    V_1ST_CUM_FAIL_RATIO  NUMBER              := 1;
    V_1ST_CUM_LT          NUMBER(10)          := 0;
    V_1ST_ROW_NUM         NUMBER(10)          := 1;
    V_1ST_MAX_ROW_NUM     NUMBER(10);
    V_2ND_PREV_CHILD      VARCHAR2(50 CHAR)   := NULL;
    V_2ND_CUM_FAIL_RATIO  NUMBER              := 1;
    V_2ND_CUM_LT          NUMBER(10)          := 0;
    V_2ND_ROW_NUM         NUMBER(10)          := 1;
    V_2ND_MAX_ROW_NUM     NUMBER(10);

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
    V_2ND_INS_NUM            NUMBER(10);
    V_2ND_MAX_INS_NUM        NUMBER(10);
    V_2ND_SUB_ROW_NUM        NUMBER(10);
BEGIN
    /* Procedure 기본조건.
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
         WHERE BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND DAYOFWEEK       = 'TUE';

        BEGIN
            SELECT
                   MODELING_ID
              INTO V_P_MODELING_ID
              FROM SCM_MST_MODELING
             WHERE PLAN_CYCLE  = 'WEEKLY'
               AND DIVISION_ID = V_DIVISION_ID;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        /* CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); 당주 월요일 YYYYMMDD */
        V_P_PLAN_NAME  := V_PLAN_START_YYYYMMDD;
        V_D_PLAN_NAME  := TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD');
        /* CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); 지난주 일요일 YYYYMMDD */
        V_CUTOFF_DAY   := TO_CHAR(TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');
        V_D_CUTOFF_DAY := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');

        /* SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; 당주 화요일 YYYYMMDD
           , CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) 당주 화요일 YYYYMMDD */
        SELECT
               NVL(MAX(A.CUTOFF_YYYYMMDD), V_MAX_TUESDAY)
          INTO V_DEMAND_CUTOFF_DAY
          FROM DM_PLN_NET_DEMAND A
         WHERE A.DIVISION_ID      = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD >= TO_CHAR(V_D_PLAN_NAME - 3, 'YYYYMMDD')   /* 월요일 기준 최근 3일 이내 */
           AND A.CUTOFF_YYYYMMDD <= TO_CHAR(V_D_PLAN_NAME + 6, 'YYYYMMDD');  /* 해당 주차 일요일 이전 */

        /* 자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용 */
        /* SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
           FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
           WHERE  PLAN_ID = @V_PLAN_ID */
        DELETE
          FROM GT_OPT_SR_IS_MAT;

        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
        INSERT
          INTO GT_OPT_SR_IS_MAT
             ( MAT_ID
             , EFF_END_DATE )
        SELECT A.ITEM_ID_CHILD AS MAT_ID
             , TO_CHAR(TO_DATE(MAX(A.TO_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD') AS EFF_END_DATE
          FROM SCP_OPMZ_VIRTUAL_BOM   A
             , SCP_OPMZ_PLAN_GR_M     B
         WHERE A.OPMZ_PLAN_GR_ID   = B.OPMZ_PLAN_GR_ID
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND B.OPMZ_PLAN_GR_NAME = V_GROUP_ID
           AND A.VALID_YN          = 'Y'
           AND B.VALID_YN          = 'Y'
         GROUP BY A.ITEM_ID_CHILD;
        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
        /* SELECT   ATTRIBUTE1 AS MAT_ID
                   ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
           FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
           WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
           AND      LU.VALID_YN    = 'Y'
           AND      LU.SEGMENT2    = @V_DIVISION_ID
           AND      LU.SEGMENT3    = @V_GROUP_ID
           GROUP BY ATTRIBUTE1 */

        /* 2nd OCV에 활용된 SUB MDLE 재고는 제외하기 위해서 */
        DELETE
          FROM GT_OPT_SR_IS_OCVEX;

        INSERT
          INTO GT_OPT_SR_IS_OCVEX
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
           AND 1 = 2   /* 2026-03-10, 제약제거 */
           AND B.SCM_SITE_ID    = C.SEGMENT4
           AND A.PARENT_ITEM_ID = C.SEGMENT5
         GROUP BY B.SCM_SITE_ID, A.CHILD_ITEM_ID;

        /* 셀 생산지 버퍼 추가 */
        DELETE
          FROM GT_OPT_SR_IS_CPS;

        INSERT
          INTO GT_OPT_SR_IS_CPS
             ( SALES_SITE_ID
             , ITEM_ID
             , OPERATION_GROUP )
        SELECT DISTINCT
               A.SEGMENT3 AS SALES_SITE_ID
             , A.SEGMENT4 AS ITEM_ID
             , CASE WHEN B.OPERATION_GROUP IS NULL THEN NULL ELSE '_'||B.OPERATION_GROUP END AS OPERATION_GROUP
          FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL   A
             , SCP_MST_FINAL_ITEM              B
         WHERE A.SEGMENT1    = B.DIVISION_ID
           AND A.SEGMENT4    = B.ITEM_ID
           AND 1 = 1
           AND A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND A.SEGMENT1    = V_DIVISION_ID;
           /* AND LU.SEGMENT2 = @V_GROUP_ID -- 2026-03-10, 그룹조건 막고 셀 생산지 버퍼 추가 + DISTINCT 처리 */

        /* 테스트를 위해 25년07주차로 고정
           SELECT @P_PLAN_NAME         = '20250210'; 당주 월요일 YYYYMMDD
           SELECT @V_CUTOFF_DAY        = '20250209'; 지난주 일요일 YYYYMMDD
           SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
           SELECT @MAX_TUESDAY         = '20250211'
           SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; 당주 화요일 YYYYMMDD */

        /* Data Insert Start */
        /* MSSQL DROP-IF-EXISTS(#SCP_INVENTORY_I / #SCP_INTRANSIT_I / #CP_INFO / #INVENTORY_ADJUST)
           -> Oracle GTT 는 세션 영속이므로 진입부 DELETE 로 초기화(TRUNCATE 금지 : 단일 트랜잭션 원자성 보존). */
        DELETE
          FROM GT_OPT_SR_IS_INV;

        DELETE
          FROM GT_OPT_SR_IS_INT;

        DELETE
          FROM GT_OPT_SR_IS_CP;

        DELETE
          FROM GT_OPT_SR_IS_ADJ;

        /* 2025.07.10 Philsu Park: 재고 보정값 반영을 위한 TEMP Input. */
        INSERT
          INTO GT_OPT_SR_IS_ADJ
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
                    ELSE B.STAGE
               END AS STAGE
             /* , ADJ.QTY */
             , A.CHG_QTY AS QTY
          FROM SCP_OPMZ_INV_ADJ   A
             , (SELECT S.SCM_SITE_ID
                     , S.ITEM_ID
                     , MIN(S.STAGE) AS STAGE   /* ASSY, ASY_AGING 이 ITEM 이 겹치므로 하나만 나오게 처리. */
                     /* , IIF(STAGE = 'ASY_AGING', 'FOR', 'X') AS INV_TYPE */
                  FROM SCP_OPT_ENG_MODEL_LIST_N_SN S
                 WHERE S.PLAN_ID = V_PLAN_ID
                   /* AND     STAGE  != 'ASY_AGING' */
                 GROUP BY S.SCM_SITE_ID
                        , S.ITEM_ID
               ) B
         WHERE A.SCM_SITE_ID     = B.SCM_SITE_ID
           AND A.ITEM_ID         = B.ITEM_ID
           AND 1 = 2   /* 2026-03-10, 제약제거 */
           AND A.DIVISION_ID     = V_DIVISION_ID
           AND A.CUTOFF_YYYYMMDD = V_PLAN_START_YYYYMMDD   /* PLAN 주차 기준. */
           AND A.INV_DATE       >= V_PLAN_START_YYYYMMDD
           AND A.INV_DATE        < V_PLAN_END_YYYYMMDD;

        /* 재고 / 해상재고 INPUT 생성 전 중간 정보 생성 PROC 참고
             PR_SCP_ENG_IN_PRE_SET_INVENTORY
             PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS */

        /* 1. 창고 재고 : WH */
        /* 1.1 SALES 재고 */
        INSERT
          INTO GT_OPT_SR_IS_INV
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
        SELECT A.DIVISION_ID AS DIVISION_ID   /* DISTINCT */
             , A.SCM_SITE_ID AS SCM_SITE_ID
             , '-'           AS INCOTERMS     /* 뒤에서 별도 UPDATE */
             , A.STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
                CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전
                     WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전
                MSSQL ISNULL(col, '') = '' 는 Oracle 에서 항상 UNKNOWN(死분기) 이므로 RTRIM(col) IS NULL 로 변환(CV-028). */
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL                            THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                     THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                             TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY               /* SCP 사용 QTY */
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
             , B.SITE_TYPE
             , '-' AS LOCATION_CODE           /* PLANT 재고 구분용 정보 */
             , '-' AS PROJECT_CODE            /* 뒤에서 별도 UPDATE */

             , E.SCM_SITE_ID AS CELL_PROD_SITE_ID
             , 'SALES'       AS FLAG
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
               LEFT OUTER JOIN GT_OPT_SR_IS_OCVEX C
                  ON A.SCM_SITE_ID = C.SCM_SITE_ID
                 AND A.MES_ITEM_ID = C.ITEM_ID
               LEFT OUTER JOIN GT_OPT_SR_IS_CPS D
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
                 /* MSSQL A.PLANT_ID + CPS.OPERATION_GROUP : 피연산자 NULL 이면 결과 NULL(무매칭). */
                 AND CASE WHEN A.PLANT_ID IS NULL OR D.OPERATION_GROUP IS NULL THEN NULL
                          ELSE A.PLANT_ID||D.OPERATION_GROUP
                     END = E.SCM_SITE_ID
         WHERE 1 = 1
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND C.ITEM_ID IS NULL
           /* 2026-03-10, 소형 특화제거, 소형은 CEll Biz 용 Demand 만 처리
              AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                  OR  (A.DIVISION_ID <> '40' )
                  ) */
           /* 대상 프로젝트 ITEM 필터링
              AND    A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                   WHERE   PLAN_ID = @V_PLAN_ID
                                   )
              MSSQL CONCAT() 은 NULL 을 빈문자열로 취급(전파 없음) -> Oracle 문자열병합과 동치이므로 가드 불필요. */
           /* COMMENT: 소형 생산지 사이트 구분 로직은 유지 */
           AND ( (A.DIVISION_ID = '40'
                  AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT X.SCM_SITE_ID||X.ITEM_ID
                                                     FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                                    WHERE X.PLAN_ID = V_PLAN_ID) )
              OR (A.DIVISION_ID != '40'
                  AND A.ITEM_ID IN (SELECT DISTINCT X.ITEM_ID
                                      FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                     WHERE X.PLAN_ID = V_PLAN_ID) ) );

        /* MSSQL ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN INCOTERMS / location_code / PROJECT_CODE VARCHAR(100) NULL */

        /* 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리 */
        INSERT
          INTO GT_OPT_SR_IS_INV
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
        SELECT A.DIVISION_ID    AS DIVISION_ID   /* DISTINCT */
             , A.TO_SCM_SITE_ID AS SCM_SITE_ID
             , '-'              AS INCOTERMS     /* 뒤에서 별도 UPDATE */
             , 'SO'             AS STOCK_TYPE
             , A.ITEM_ID        AS ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전
                엔진 오류로 Plan 구간 안으로 처리
                CONVERT(DATETIME, @V_CUTOFF_DAY) AS AVAILABLE_DATE */
             , TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') AS AVAILABLE_DATE
             , A.DELIVERY_QTY   AS QTY
             , 'N'              AS WIPHOLD_YN
             , B.SITE_TYPE
             , '-'              AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END AS PROJECT_CODE
             , CASE WHEN C.ITEM_ID IS NULL THEN NULL ELSE A.FROM_SCM_SITE_ID END        AS CELL_PROD_SITE_ID
             , 'SALES'          AS FLAG
          FROM SCM_DNM_INTRANSIT_C A
             , (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND SITE_TYPE = 'SALES'
               ) B
             , GT_OPT_SR_IS_CPS C
         WHERE A.DIVISION_ID       = B.DIVISION_ID
           AND A.TO_SCM_SITE_ID    = B.SCM_SITE_ID
           AND A.TO_SCM_SITE_ID    = C.SALES_SITE_ID(+)
           AND A.ITEM_ID           = C.ITEM_ID(+)
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND A.RESULT_DATE       = V_CUTOFF_DAY
           /* SO Reserve Stock : result_type = 'B' 는 재고로 처리 */
           AND A.RESULT_TYPE       = 'B'
           AND A.VALID_YN          = 'Y'   /* 해상재고 */
           /* 2026-03-10, 소형 특화제거 -- 소형은 CEll Biz 용 Demand 만 처리
              AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                  OR  (A.DIVISION_ID <> '40' )
                  ) */
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           /* COMMENT: 소형 생산지 사이트 구분 로직은 유지 */
           AND ( (A.DIVISION_ID = '40'
                  AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT X.SCM_SITE_ID||X.ITEM_ID
                                                          FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                                         WHERE X.PLAN_ID = V_PLAN_ID) )
              OR (A.DIVISION_ID != '40'
                  AND A.ITEM_ID IN (SELECT DISTINCT X.ITEM_ID
                                      FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                     WHERE X.PLAN_ID = V_PLAN_ID) ) );

        /* 1.3 SALES 재고 : INCOTERMS UPDATE
           MSSQL UPDATE..FROM LEFT JOIN 2건 -> 상관 스칼라 서브쿼리 2건.
           두 인라인뷰 모두 GROUP BY 로 조인키당 1행이 보장되므로 결정적이다(다중매치 없음). */
        UPDATE
               GT_OPT_SR_IS_INV A
           SET A.INCOTERMS = NVL(NVL((SELECT B.MAX_INCOTERMS
                                        FROM (SELECT C.SCM_SITE_ID
                                                   , C.ITEM_ID
                                                   /* VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) */
                                                   , MAX(CASE WHEN E.VMI_YN = 'Y' THEN 'DAP'
                                                              ELSE C.INCOTERMS
                                                         END) MAX_INCOTERMS
                                                FROM DM_PLN_NET_DEMAND C
                                                   , (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                        FROM DM_PLN_NET_DEMAND
                                                       WHERE DIVISION_ID     = V_DIVISION_ID
                                                         AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                                       GROUP BY SCM_SITE_ID
                                                     ) D
                                                   , (SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                        FROM SCM_MST_SITE
                                                       WHERE DIVISION_ID = V_DIVISION_ID
                                                         AND VMI_YN      = 'Y'
                                                     ) E
                                               WHERE C.SCM_SITE_ID     = D.SCM_SITE_ID
                                                 AND C.VERSION_NO      = D.MAX_VERSION_NO
                                                 AND C.DIVISION_ID     = V_DIVISION_ID
                                                 AND C.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                                 AND C.DIVISION_ID     = E.DIVISION_ID(+)
                                                 AND C.SCM_SITE_ID     = E.SCM_SITE_ID(+)
                                               GROUP BY C.SCM_SITE_ID, C.ITEM_ID
                                             ) B
                                       WHERE A.SCM_SITE_ID = B.SCM_SITE_ID
                                         AND A.ITEM_ID     = B.ITEM_ID)
                                   , (SELECT F.MAX_INCOTERMS
                                        FROM (SELECT G.SCM_SITE_ID
                                                   /* VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) */
                                                   , MAX(CASE WHEN I.VMI_YN = 'Y' THEN 'DAP'
                                                              ELSE G.INCOTERMS
                                                         END) MAX_INCOTERMS
                                                FROM DM_PLN_NET_DEMAND G
                                                   , (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                        FROM DM_PLN_NET_DEMAND
                                                       WHERE DIVISION_ID     = V_DIVISION_ID
                                                         AND CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                                       GROUP BY SCM_SITE_ID
                                                     ) H
                                                   , (SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                        FROM SCM_MST_SITE
                                                       WHERE DIVISION_ID = V_DIVISION_ID
                                                         AND VMI_YN      = 'Y'
                                                     ) I
                                               WHERE G.SCM_SITE_ID     = H.SCM_SITE_ID
                                                 AND G.VERSION_NO      = H.MAX_VERSION_NO
                                                 AND G.DIVISION_ID     = V_DIVISION_ID
                                                 AND G.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                                 AND G.DIVISION_ID     = I.DIVISION_ID(+)
                                                 AND G.SCM_SITE_ID     = I.SCM_SITE_ID(+)
                                               GROUP BY G.SCM_SITE_ID
                                             ) F
                                       WHERE A.SCM_SITE_ID = F.SCM_SITE_ID)
                                 ), 'DAP')   /* DEMAND 없는 경우 DAP 처리 */
         WHERE 1 = 1
           AND A.SITE_TYPE = 'SALES';

        /* 1.4 PLANT 재고 */
        INSERT
          INTO GT_OPT_SR_IS_INV
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
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
                CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전
                     WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) BOH 처리용 1일 전 */
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL                            THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN A.WIPHOLD_YN = 'N'                                     THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                    WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    ELSE                                                             TRUNC(A.AVAILABLE_DATE)
               END AS AVAILABLE_DATE
             , A.SCM_QTY AS QTY
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
             , B.SITE_TYPE
             , CASE WHEN RTRIM(C.LOCATION_CODE) IS NOT NULL OR RTRIM(D.LOCATION_CODE) IS NOT NULL THEN 'ASSY'
                    ELSE '-'
               END AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */

             , NULL    AS PROJECT_CODE
             , NULL    AS CELL_PROD_SITE_ID
             , 'PLANT' AS FLAG
          FROM SCM_DNM_STOCK A
             , (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                  FROM SCM_MST_SITE
                 WHERE 1 = 1
                   AND DIVISION_ID = V_DIVISION_ID
                   AND SITE_TYPE   = 'PLANT'
                   AND OPERATION_GROUP IN ('A', 'P')   /* 2026-03-10, 소형 특화제거에 따른 추가 */
                   /* 2026-03-10, 소형 특화제거
                      AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외
                          OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                          ) */
               ) B
             , (SELECT DISTINCT
                       X.OPERATION_ID
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
             , (SELECT DISTINCT
                       X.STORAGE_ID
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
             , GT_OPT_SR_IS_OCVEX E
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
           AND 1 = 1
           AND A.CUTOFF_DATE  = V_CUTOFF_DAY
           AND A.DIVISION_ID  = V_DIVISION_ID
           AND E.ITEM_ID IS NULL;
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리
              AND (    (A.DIVISION_ID = '40' AND   CONCAT(B.SCM_SITE_ID,A.ITEM_ID) IN (SELECT DISTINCT CONCAT(SCM_SITE_ID,ITEM_ID)
                                                                                       FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                                       WHERE   PLAN_ID = @V_PLAN_ID
                                                                                       )
                      )
                   OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                WHERE   PLAN_ID = @V_PLAN_ID
                                                                )
                      )
                  ) */

        /* 2. 활성화 재고 : FOR */
        INSERT
          INTO GT_OPT_SR_IS_INV
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
             , 'FOR'         AS STOCK_TYPE
             , A.ITEM_ID
             /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
             , CASE WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                    WHEN A.DIVISION_ID = '40' AND MF.ADD_LT_FORMATION IS NOT NULL THEN A.AVAILABLE_DATE + MF.ADD_LT_FORMATION   /* 소형인 경우 ADD_FORMATION_LT를 재고 일수에 추가 */
                    ELSE A.AVAILABLE_DATE
               END AS AVAILABLE_DATE
             , A.QTY AS QTY
             , CASE WHEN RTRIM(A.WIPHOLD_YN) IS NULL THEN 'N'
                    ELSE A.WIPHOLD_YN
               END AS WIPHOLD_YN
             , 'PLANT' AS SITE_TYPE
             , '-'     AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
             , NULL    AS PROJECT_CODE
             , NULL    AS CELL_PROD_SITE_ID
             , 'PLANT' AS FLAG
          FROM (SELECT A.*
                  FROM SCM_DNM_STOCK_AGING_V A
                       /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경 */
                       LEFT JOIN (SELECT DIVISION_ID, SITE_ID, MAX(CUTOFF_DATE) MAX_CUTOFF_DATE
                                    FROM SCM_DNM_STOCK_AGING_V A
                                   WHERE A.DIVISION_ID  = V_DIVISION_ID
                                     AND A.CUTOFF_DATE  > V_D_CUTOFF_DAY - 7
                                     AND A.CUTOFF_DATE <= V_D_CUTOFF_DAY
                                   GROUP BY DIVISION_ID, SITE_ID
                                 ) C   /* DIVISION_ID / SITE_ID 별로 최근 일주일이내의 MAX(CUTOFF_DATE) 값 */
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.SITE_ID     = C.SITE_ID
                         AND A.CUTOFF_DATE = C.MAX_CUTOFF_DATE
                 WHERE A.DIVISION_ID = V_DIVISION_ID
                   AND C.DIVISION_ID IS NOT NULL   /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함 */
                   /* AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                         FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                         WHERE   PLAN_ID = @V_PLAN_ID
                                         ) */
                   /* 소형 생산지 구분을 위한 분리 */
                   /* COMMENT: 소형 생산지 사이트 구분 로직은 유지 */
                   AND ( (A.DIVISION_ID = '40'
                          AND A.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT Z.SCM_SITE_ID||Z.ITEM_ID
                                                             FROM SCP_OPT_ENG_MODEL_LIST_N_SN Z
                                                            WHERE Z.PLAN_ID = V_PLAN_ID) )
                      OR (A.DIVISION_ID != '40'
                          AND A.ITEM_ID IN (SELECT DISTINCT Z.ITEM_ID
                                              FROM SCP_OPT_ENG_MODEL_LIST_N_SN Z
                                             WHERE Z.PLAN_ID = V_PLAN_ID) ) )
               ) A
               /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경 */
               LEFT JOIN (SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                            FROM SCM_MST_SITE
                           WHERE 1 = 1
                             AND DIVISION_ID     = V_DIVISION_ID
                             AND SITE_TYPE       = 'PLANT'
                             AND NVL(OSP_YN, 'N') = 'N'   /* 20180822 추가 */
                         ) B
                  ON A.SCM_SITE_ID = B.SCM_SITE_ID
               LEFT OUTER JOIN SCP_MST_FORMATION_V MF
                  ON A.DIVISION_ID = MF.DIVISION_ID
                 AND A.SCM_SITE_ID = MF.PLANT_SITE_ID
                 AND A.ITEM_ID     = MF.ITEM_ID
         WHERE B.DIVISION_ID IS NOT NULL;   /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함 */
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 ) */

        /* 3. 해상 재고 : INT */
        /* 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
        INSERT
          INTO GT_OPT_SR_IS_INT
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
             /* IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN D.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-'   /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                    WHEN D.SITE_TYPE = 'SALES' THEN CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END
                    WHEN D.SITE_TYPE = 'PLANT' THEN NULL   /* Plant 도착은 NULL 처리 */
                    ELSE CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '-' ELSE A.PROJECT_CODE END
               END AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
             , CASE WHEN E.ITEM_ID IS NULL THEN NULL ELSE A.FROM_SCM_SITE_ID END AS CELL_PROD_SITE_ID
             , D.SITE_TYPE AS FLAG
          FROM INTRANSIT_MAT A
             , (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V) B
             , (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                  FROM SCM_MST_SITE
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND SITE_TYPE   = 'PLANT'
                   AND OPERATION_GROUP IN ('A', 'P')   /* FROM_SITE 가 전극인 정보 제외 */
                   AND VALID_YN    = 'Y'
               ) C
             , SCM_MST_SITE D
             , GT_OPT_SR_IS_CPS E
         WHERE A.DIVISION_ID       = B.DIVISION_ID
           AND A.ITEM_ID           = B.ITEM_ID
           AND B.OPERATION_GROUP_ID <> 'E'   /* 전극 모델은 제외 */
           AND A.DIVISION_ID       = C.DIVISION_ID
           AND A.FROM_SCM_SITE_ID  = C.SCM_SITE_ID
           /* BLOCKED 2026-03-10, 소형 특화제거
              AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' )      소형은 CEll Biz 용 Demand 만 처리
                  OR  (FS.DIVISION_ID <> '40' )
                  ) */
           AND A.DIVISION_ID       = D.DIVISION_ID
           AND A.TO_SCM_SITE_ID    = D.SCM_SITE_ID
           /* AND TS.SITE_TYPE      = 'SALES' */
           AND D.VALID_YN          = 'Y'
           /* BLOCKED 2026-03-10, 소형 특화제거
              AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE = 'SALES' )      소형은 CEll Biz 용 Demand 만 처리
                  OR  (TS.DIVISION_ID <> '40' )
                  ) */
           AND A.TO_SCM_SITE_ID    = E.SALES_SITE_ID(+)
           AND A.ITEM_ID           = E.ITEM_ID(+)
           AND 1 = 1
           AND A.DIVISION_ID       = V_DIVISION_ID
           AND A.RESULT_DATE       = V_CUTOFF_DAY
           AND A.RESULT_TYPE IN ('I', 'C')   /* ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           /* COMMENT: 소형 생산지 사이트 구분 로직은 유지 */
           AND ( (A.DIVISION_ID = '40'
                  AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT X.SCM_SITE_ID||X.ITEM_ID
                                                          FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                                         WHERE X.PLAN_ID = V_PLAN_ID) )
              OR (A.DIVISION_ID != '40'
                  AND A.ITEM_ID IN (SELECT DISTINCT X.ITEM_ID
                                      FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                     WHERE X.PLAN_ID = V_PLAN_ID) ) );

        /* MSSQL ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL */
        /* 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함 */
        INSERT
          INTO GT_OPT_SR_IS_INT
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

             , F.SCM_SITE_ID     AS CELL_PROD_SITE_ID
             , 'SALES'           AS FLAG
          FROM SCM_DNM_STOCK A
               INNER JOIN SCM_MST_VMI_INT_SLOC B
                  ON A.DIVISION_ID = B.DIVISION_ID
                 AND A.PLANT_ID    = B.PLANT_ID
                 AND A.STORAGE_ID  = B.STORAGE_ID
                 AND B.VALID_YN    = 'Y'
               /* 소형 생산지 구분을 위한 분리 */
               INNER JOIN SCM_MST_SITE C
                  ON A.PLANT_ID = C.PLANT_ID
               LEFT OUTER JOIN GT_OPT_SR_IS_OCVEX D
                  ON A.SCM_SITE_ID = D.SCM_SITE_ID
                 AND A.MES_ITEM_ID = D.ITEM_ID
               LEFT OUTER JOIN GT_OPT_SR_IS_CPS E
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
                 /* MSSQL A.PLANT_ID + CPS.OPERATION_GROUP : 피연산자 NULL 이면 결과 NULL(무매칭). */
                 AND CASE WHEN A.PLANT_ID IS NULL OR E.OPERATION_GROUP IS NULL THEN NULL
                          ELSE A.PLANT_ID||E.OPERATION_GROUP
                     END = F.SCM_SITE_ID
         WHERE 1 = 1
           AND A.CUTOFF_DATE = V_CUTOFF_DAY
           AND A.DIVISION_ID = V_DIVISION_ID
           AND D.ITEM_ID IS NULL
           /* BLOCKED 2026-03-10, 소형 특화제거 --소형은 CEll Biz 용 Demand 만 처리
              AND ((A.DIVISION_ID  = '40' AND DBO.FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                  OR  (A.DIVISION_ID <> '40' )
                  ) */
           /* 대상 프로젝트 ITEM 필터링
              AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                 WHERE   PLAN_ID = @V_PLAN_ID
                                 )
              소형 생산지 구분을 위한 분리 */
           /* COMMENT: 소형 생산지 사이트 구분 로직은 유지 */
           AND ( (A.DIVISION_ID = '40'
                  AND C.SCM_SITE_ID||A.ITEM_ID IN (SELECT DISTINCT X.SCM_SITE_ID||X.ITEM_ID
                                                     FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                                    WHERE X.PLAN_ID = V_PLAN_ID) )
              OR (A.DIVISION_ID != '40'
                  AND A.ITEM_ID IN (SELECT DISTINCT X.ITEM_ID
                                      FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                     WHERE X.PLAN_ID = V_PLAN_ID) ) );

        /* UPDATE PROJECT */
        /* INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준 */
        DELETE
          FROM GT_OPT_SR_IS_DM;

        INSERT
          INTO GT_OPT_SR_IS_DM
             ( SITE_ID
             , ITEM_ID
             , INCOTERMS
             , PROJECT_CODE )
        SELECT A.SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
          FROM (SELECT B.SITE_ID
                     , B.ITEM_ID
                     , B.INCOTERMS
                     , B.PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY B.SITE_ID, B.ITEM_ID, B.INCOTERMS, B.PROJECT_CODE ORDER BY B.MIN_DUE) AS ROW_NUM
                  FROM (SELECT ATTRIBUTE1    AS SITE_ID
                             , ATTRIBUTE2    AS ITEM_ID
                             , ATTRIBUTE4    AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL   /* PROJECT_CODE */
                           AND ATTRIBUTE4 IS NOT NULL   /* INCOTERMS */
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5
                       ) B
               ) A
         WHERE A.ROW_NUM = 1
         UNION ALL
        SELECT A.SITE_ID
             , A.ITEM_ID
             , A.INCOTERMS
             , A.PROJECT_CODE
          FROM (SELECT B.SITE_ID
                     , B.ITEM_ID
                     , B.INCOTERMS
                     , B.PROJECT_CODE
                     , ROW_NUMBER() OVER (PARTITION BY B.SITE_ID, B.ITEM_ID, B.PROJECT_CODE ORDER BY B.MIN_DUE) AS ROW_NUM
                  FROM (SELECT ATTRIBUTE1    AS SITE_ID
                             , ATTRIBUTE2    AS ITEM_ID
                             /* UNION ALL 양쪽 타입 일치(ORA-01790 회피) : 위 브랜치의 ATTRIBUTE4 와 동일 타입으로 명시. */
                             , CAST(NULL AS VARCHAR2(150 CHAR)) AS INCOTERMS
                             , ATTRIBUTE5    AS PROJECT_CODE
                             , MIN(DUE_DATE) AS MIN_DUE
                          FROM SCP_OPT_ENG_DEMAND_SN
                         WHERE PLAN_ID = V_PLAN_ID
                           AND ATTRIBUTE5 IS NOT NULL
                           AND ATTRIBUTE4 IS NULL
                         GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
                       ) B
               ) A
         WHERE A.ROW_NUM = 1;

        /* #SCP_INVENTORY_I 프로젝트 UPDATE
           MSSQL UPDATE..FROM INNER JOIN -> MERGE. 다중매치(ORA-30926) 회피 위해 조인키로 GROUP BY + MAX(PROJECT_CODE) 결정화. */
        MERGE
         INTO GT_OPT_SR_IS_INV A
        USING (
               SELECT C.DIVISION_ID
                    , C.SCM_SITE_ID
                    , C.INCOTERMS
                    , C.STOCK_TYPE
                    , C.ITEM_ID
                    , C.AVAILABLE_DATE
                    , C.QTY
                    , C.WIPHOLD_YN
                    , C.SITE_TYPE
                    , C.LOCATION_CODE
                    , MAX(C.PROJECT_CODE) AS PROJECT_CODE
                 FROM (
                       SELECT D.DIVISION_ID
                            , D.SCM_SITE_ID
                            , D.INCOTERMS
                            , D.STOCK_TYPE
                            , D.ITEM_ID
                            , D.MDF_ITEM_ID
                            , D.AVAILABLE_DATE
                            , D.QTY
                            , D.WIPHOLD_YN
                            , D.SITE_TYPE
                            , D.LOCATION_CODE
                            , E.PROJECT_CODE
                         FROM (
                               SELECT F.DIVISION_ID
                                    , F.SCM_SITE_ID
                                    , F.INCOTERMS
                                    , F.STOCK_TYPE
                                    , F.ITEM_ID
                                    /* IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID */
                                    , CASE WHEN G.SEGMENT3 IS NULL THEN F.ITEM_ID ELSE G.SEGMENT4 END AS MDF_ITEM_ID
                                    , F.AVAILABLE_DATE
                                    , F.QTY
                                    , F.WIPHOLD_YN
                                    , F.SITE_TYPE
                                    , F.LOCATION_CODE
                                 FROM GT_OPT_SR_IS_INV F
                                      LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL G
                                         ON 1 = 2   /* 2026-03-10, 제약제거 */
                                        AND G.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND G.SEGMENT2    = V_DIVISION_ID
                                        AND F.ITEM_ID     = G.SEGMENT3
                                        AND G.VALID_YN    = 'Y'
                                WHERE F.FLAG           = 'SALES'
                                  AND F.PROJECT_CODE   = '-'
                                  AND F.QTY            > 0
                              ) D
                            , GT_OPT_SR_IS_DM E
                        WHERE D.SCM_SITE_ID = E.SITE_ID
                          AND D.MDF_ITEM_ID = E.ITEM_ID
                          AND ( (D.INCOTERMS IS NULL AND E.INCOTERMS IS NULL)
                             OR (D.INCOTERMS = E.INCOTERMS)
                             OR (D.INCOTERMS IS NOT NULL AND E.INCOTERMS IS NULL) )
                      ) C
                GROUP BY C.DIVISION_ID
                       , C.SCM_SITE_ID
                       , C.INCOTERMS
                       , C.STOCK_TYPE
                       , C.ITEM_ID
                       , C.AVAILABLE_DATE
                       , C.QTY
                       , C.WIPHOLD_YN
                       , C.SITE_TYPE
                       , C.LOCATION_CODE
              ) B
           ON ( A.DIVISION_ID    = B.DIVISION_ID
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

        /* #SCP_INTRANSIT_I 프로젝트 UPDATE */
        MERGE
         INTO GT_OPT_SR_IS_INT A
        USING (
               SELECT C.DIVISION_ID
                    , C.ITEM_ID
                    , C.TO_SCM_SITE_ID
                    , C.INCOTERMS
                    , C.ETA_DATE
                    , C.DELIVERY_QTY
                    , C.FLAG
                    , MAX(C.PROJECT_CODE) AS PROJECT_CODE
                 FROM (
                       SELECT D.DIVISION_ID
                            , D.ITEM_ID
                            , D.TO_SCM_SITE_ID
                            , D.INCOTERMS
                            , D.ETA_DATE
                            , D.DELIVERY_QTY
                            , D.FLAG
                            , E.PROJECT_CODE
                         FROM (
                               SELECT F.DIVISION_ID
                                    , F.ITEM_ID
                                    , CASE WHEN G.SEGMENT3 IS NULL THEN F.ITEM_ID ELSE G.SEGMENT4 END AS MDF_ITEM_ID
                                    , F.TO_SCM_SITE_ID
                                    , F.INCOTERMS
                                    , F.ETA_DATE
                                    , F.DELIVERY_QTY
                                    , F.PROJECT_CODE
                                    , F.FLAG
                                 FROM GT_OPT_SR_IS_INT F   /* WHERE PROJECT_CODE = '-' AND FLAG ='SALES' */
                                      LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL G
                                         ON 1 = 2   /* 2026-03-10, 제약제거 */
                                        AND G.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND G.SEGMENT2    = V_DIVISION_ID
                                        AND F.ITEM_ID     = G.SEGMENT3
                                        AND G.VALID_YN    = 'Y'
                                WHERE F.FLAG           = 'SALES'
                                  AND F.PROJECT_CODE   = '-'
                                  AND F.DELIVERY_QTY   > 0
                              ) D
                            , GT_OPT_SR_IS_DM E
                        WHERE D.TO_SCM_SITE_ID = E.SITE_ID
                          AND D.MDF_ITEM_ID    = E.ITEM_ID
                          AND ( (D.INCOTERMS IS NULL AND E.INCOTERMS IS NULL)
                             OR (D.INCOTERMS = E.INCOTERMS)
                             OR (D.INCOTERMS IS NOT NULL AND E.INCOTERMS IS NULL) )
                      ) C
                GROUP BY C.DIVISION_ID
                       , C.ITEM_ID
                       , C.TO_SCM_SITE_ID
                       , C.INCOTERMS
                       , C.ETA_DATE
                       , C.DELIVERY_QTY
                       , C.FLAG
              ) B
           ON ( A.DIVISION_ID    = B.DIVISION_ID
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
          INTO GT_OPT_SR_IS_CP
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
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.ITEM_ID_ASSY
                                             , A.PLANT_ID
                                      ORDER BY A.VALID_YN DESC
                                             , A.ITEM_ID_PROD) PRIORITY_1ST
             , ROW_NUMBER() OVER (PARTITION BY A.DIVISION_ID
                                             , A.ITEM_ID_ASSY
                                      ORDER BY A.VALID_YN DESC
                                             , A.ITEM_ID_PROD) PRIORITY_2ND
             , ROW_NUMBER() OVER (PARTITION BY A.ITEM_ID_ASSY
                                      ORDER BY A.VALID_YN DESC
                                             , A.ITEM_ID_PROD) PRIORITY_3RD
          FROM SCP_MST_CELL_PROD_ASSY_MAP A
         WHERE 1 = 1
           AND A.VALID_YN = 'Y';

        /* INCOMING STOCK INSERT
           2025.07.10 Philsu Park: 재고 보정 대상 데이터는 별도 Insert 하기 때문에 제외 처리. */
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
        SELECT AA.PLAN_ID
             , AA.STOCK_ID
             , AA.BUFFER_ID
             , AA.EFECTIVE_DATE
             , AA.TYPE
             , SUM(AA.QUANTITY) AS QUANTITY
             , AA.SITE_ID
             , AA.ITEM_ID
             , AA.STAGE
             , AA.INCOTERMS
             , AA.PROJECT_CODE
          FROM (
                SELECT V_PLAN_ID AS PLAN_ID
                     /* MSSQL IIF(col = '' ...) 는 Oracle 에서 항상 UNKNOWN(死분기) -> RTRIM(col) IS NULL 로 변환(CV-028). */
                     , A.TYPE||'::'||A.SITE_ID||'::'||A.ITEM_ID||'::'||A.STAGE||CASE WHEN A.INCOTERMS = '-' THEN '' ELSE '@'||A.INCOTERMS END||CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '' ELSE '@'||A.PROJECT_CODE END||'::'||A.EFECTIVE_DATE||CASE WHEN RTRIM(A.CELL_PROD_SITE_ID) IS NULL THEN '' ELSE '::'||A.CELL_PROD_SITE_ID END AS STOCK_ID
                     , A.SITE_ID||'::'||A.ITEM_ID||'::'||A.STAGE||CASE WHEN A.INCOTERMS = '-' THEN '' ELSE '@'||A.INCOTERMS END||CASE WHEN RTRIM(A.PROJECT_CODE) IS NULL THEN '' ELSE '@'||A.PROJECT_CODE END||CASE WHEN RTRIM(A.CELL_PROD_SITE_ID) IS NULL THEN '' ELSE '::'||A.CELL_PROD_SITE_ID END AS BUFFER_ID
                     , A.EFECTIVE_DATE AS EFECTIVE_DATE
                     , A.TYPE          AS TYPE
                     , A.QTY           AS QUANTITY
                     , A.SITE_ID       AS SITE_ID
                     , A.ITEM_ID       AS ITEM_ID
                     , A.STAGE         AS STAGE
                     , A.INCOTERMS     AS INCOTERMS
                     , A.PROJECT_CODE  AS PROJECT_CODE
                  FROM (

                        SELECT A.DIVISION_ID
                             , A.SCM_SITE_ID AS SITE_ID
                             /* , A.ITEM_ID AS ITEM_ID */
                             /* 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함
                                MA 재고에 대해서는 AGING으로 놔두고 MU, MJ...에 대해서는 CHAR로 변환 */
                             , CASE WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-' AND A.ITEM_ID NOT LIKE 'MA%'
                                         THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), A.ITEM_ID)
                                    ELSE A.ITEM_ID
                               END ITEM_ID
                             /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'
                                     THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'PACK' ELSE 'PACKBIZ' END)
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'
                                     THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'MDLE' ELSE 'MDLEBIZ' END)
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500')
                                     THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'SUBMDLE' ELSE 'SUBMDLEBIZ' END) */
                             , CASE
                                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'SALES' THEN 'PACKBIZ'
                                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'PLANT' THEN 'MDLE'
                                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'SALES' THEN 'MDLEBIZ'
                                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                                    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'SALES' THEN 'CELLBIZ'
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'FOR%' THEN 'ASY_AGING'   /* 활성화 재고 */
                                    /* 활성화 완료 재고 : 'CHAR' 버퍼 재고로 처리하고 ASSY Item 인 경우 CHAR Item 으로 Update 처리함
                                       활성화 전 재고 : 'ASSY'
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'ASY_AGING' ELSE 'ASSY' END)
                                       WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END)
                                       활성화 완료 ASSY ITEM 재고는 ASY_AGING 재고로 변환함 -> CHAR로 변환하면 MA 상위에 CHAR가 여러개 있는 경우 대응이 안됨.
                                       MA 재고에 대해서는 AGING으로 놔두고 MU, MJ...에 대해서는 CHAR로 변환 */
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' AND A.ITEM_ID NOT LIKE 'MA%' THEN 'CHAR' WHEN A.LOCATION_CODE = '-' AND A.ITEM_ID LIKE 'MA%' THEN 'ASY_AGING' ELSE 'ASSY' END)
                                    /* SUBMDLE는 FINAL ITEM에 없으므로 다른 TABLE에서 확인 */
                                    WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                                    WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                    ELSE '-'
                               END STAGE
                             , TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                             , A.DESCR AS TYPE
                             , A.QTY   AS QTY
                             , A.INCOTERMS
                             , A.PROJECT_CODE
                             , A.CELL_PROD_SITE_ID
                          FROM (
                                SELECT T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID AS SCM_SITE_ID
                                     , T.INCOTERMS
                                     , TRUNC(T.AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(T.QTY)              AS QTY
                                     , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                            ELSE 'WH_HOLD'
                                       END AS DESCR
                                     , T.LOCATION_CODE
                                     , T.PROJECT_CODE
                                     , T.CELL_PROD_SITE_ID
                                     , T.FLAG
                                  FROM GT_OPT_SR_IS_INV T
                                 WHERE 1 = 1
                                   AND T.STOCK_TYPE <> 'FOR'
                                 GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TRUNC(T.AVAILABLE_DATE), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                HAVING SUM(T.QTY) > 0
                                 UNION ALL
                                /* 활성화 재고 : FOR 로 처리 */
                                SELECT T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID AS SCM_SITE_ID
                                     , T.INCOTERMS
                                     , TRUNC(T.AVAILABLE_DATE) AS EFFSTARTDATE
                                     , SUM(T.QTY)              AS QTY
                                     , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
                                            ELSE 'FOR_HOLD'
                                       END AS DESCR
                                     , T.LOCATION_CODE
                                     , T.PROJECT_CODE
                                     , T.CELL_PROD_SITE_ID
                                     , T.FLAG
                                  FROM GT_OPT_SR_IS_INV T
                                 WHERE 1 = 1
                                   AND T.STOCK_TYPE = 'FOR'   /* 활성화 재고 */
                                   AND T.QTY        > 0
                                 GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TRUNC(T.AVAILABLE_DATE), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                 UNION ALL
                                /* INTRANSIT SHIPMENT 재고
                                   VARCHAR2(YYYYMMDD) 인 ETA_DATE 는 TO_DATE 로 명시 변환(MSSQL CONVERT(DATETIME, ETA_DATE) 대응). */
                                SELECT T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID AS SCM_SITE_ID
                                     , T.INCOTERMS
                                     , TO_DATE(T.ETA_DATE, 'YYYYMMDD') AS EFFSTARTDATE
                                     , SUM(T.DELIVERY_QTY)             AS QTY
                                     , 'INT'                           AS DESCR
                                     , '-'                             AS LOCATION_CODE
                                     , T.PROJECT_CODE
                                     , T.CELL_PROD_SITE_ID
                                     , T.FLAG
                                  FROM GT_OPT_SR_IS_INT T
                                 WHERE 1 = 1
                                   AND T.DELIVERY_QTY > 0
                                   AND (T.ETA_DATE IS NOT NULL OR RTRIM(T.ETA_DATE) IS NOT NULL)
                                 GROUP BY T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID, T.ETA_DATE, T.INCOTERMS, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                               ) A
                               LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                            /* , * */
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
                               LEFT JOIN GT_OPT_SR_IS_CP C1
                                  ON C1.DIVISION_ID  = A.DIVISION_ID
                                 AND C1.PLANT_ID     = FS.PLANT_ID
                                 AND C1.ITEM_ID_ASSY = A.ITEM_ID
                                 AND C1.PRIORITY_1ST = 1
                               LEFT JOIN GT_OPT_SR_IS_CP C2
                                  ON C2.DIVISION_ID  = A.DIVISION_ID
                                 AND C2.ITEM_ID_ASSY = A.ITEM_ID
                                 AND C2.PRIORITY_2ND = 1
                               LEFT JOIN GT_OPT_SR_IS_CP C3
                                  ON C3.ITEM_ID_ASSY = A.ITEM_ID
                                 AND C3.PRIORITY_3RD = 1
                               /* SUBMDLE의 STAGE를 찾기 위해 추가 */
                               LEFT JOIN (SELECT SM.DIVISION_ID
                                               , SM.SCM_SITE_ID
                                               , IM.ITEM_ID
                                               , IM.SCP_FLOW_ID
                                               , IM.SCP_OPERATION_GROUP
                                            FROM SCM_ITEM_M_SN   IM
                                               , SCM_MST_SITE    SM
                                           WHERE IM.COMPANY_ID          = SM.COMPANY_ID
                                             AND IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                                             AND 1 = 1
                                             AND SM.SCM_SITE_ID||IM.ITEM_ID IN (SELECT DISTINCT X.SCM_SITE_ID||X.ITEM_ID
                                                                                  FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                                                                 WHERE X.PLAN_ID = V_PLAN_ID)
                                             AND IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500')   /* SUBMDLE만 걸리도록 */
                                             AND IM.SCP_OPERATION_GROUP = 'P'               /* SUBMDLE만 걸리도록 */
                                         ) SMC
                                  ON A.DIVISION_ID = SMC.DIVISION_ID
                                 AND A.SCM_SITE_ID = SMC.SCM_SITE_ID
                                 AND A.ITEM_ID     = SMC.ITEM_ID
                         WHERE 1 = 1
                               /* AND    A.ITEM_ID = B.ITEM_ID
                                  AND    B.ITEM_TYPE <> 'R' R TYPE의 재고는 올리지 않음
                                  대상 프로젝트 ITEM 필터링
                                  2025.10.13 Philsu Park: ITEM_ID 변환 후 조건을 걸어줘야 누락되는 케이스가 없어지기 때문에 FROM 절 바깥으로 빼줌.
                                  AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                                     FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                     WHERE   PLAN_ID = @V_PLAN_ID
                                                   ) */
                       ) A
                 WHERE 1 = 1
                   AND ( (A.DIVISION_ID = '40'
                          AND A.SITE_ID||A.ITEM_ID IN (SELECT DISTINCT X.SCM_SITE_ID||X.ITEM_ID
                                                         FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                                        WHERE X.PLAN_ID = V_PLAN_ID) )
                      OR (A.DIVISION_ID != '40'
                          AND A.ITEM_ID IN (SELECT DISTINCT X.ITEM_ID
                                              FROM SCP_OPT_ENG_MODEL_LIST_N_SN X
                                             WHERE X.PLAN_ID = V_PLAN_ID) ) )
                   AND NOT EXISTS (SELECT 1
                                     FROM GT_OPT_SR_IS_ADJ ADJ
                                    WHERE ADJ.SCM_SITE_ID  = A.SITE_ID
                                      AND ADJ.ITEM_ID      = A.ITEM_ID
                                      AND ADJ.STOCK_TYPE   = A.TYPE
                                      AND ADJ.STAGE        = A.STAGE
                                      AND ADJ.INCOTERMS    = A.INCOTERMS
                                      AND ADJ.PROJECT_CODE = A.PROJECT_CODE
                                      AND ADJ.INV_DATE     = A.EFECTIVE_DATE)
                   AND A.EFECTIVE_DATE < V_PLAN_END_YYYYMMDD
                 UNION ALL
                /* 자재/포장재의 입고 예정정보
                   2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용. */
                SELECT V_PLAN_ID AS PLAN_ID
                     , MC.TYPE||'::'||MC.SCM_SITE_ID||'::'||MC.MAT_ID||'::'||MC.STAGE||'::'||MC.ARR_DATE AS STOCK_ID
                     , MC.SCM_SITE_ID||'::'||MC.MAT_ID||'::'||MC.STAGE AS BUFFER_ID
                     , MC.ARR_DATE    AS EFFECTIVE_DATE
                     , MC.TYPE        AS TYPE
                     , MC.QTY         AS QUANTITY
                     , MC.SCM_SITE_ID AS SITE_ID
                     , MC.MAT_ID      AS ITEM_ID
                     , MC.STAGE       AS STAGE
                     , '-'            AS INCOTERMS
                     , '-'            AS PROJECT_CODE
                  FROM (
                        /* START 2025.11.19 jongykim2: Schelduled Reciept Information
                           UNION ALL 브랜치 간 QUANTITY 타입 일치(ORA-01790 회피) : */
                        SELECT A.PLANT_SITE_ID AS SCM_SITE_ID
                             , A.ITEM_ID_CHILD AS MAT_ID
                             , 'MATERIAL_CONST' AS STAGE
                             , A.TO_YYYYMMDD   AS ARR_DATE
                             , TO_NUMBER(A.TO_EXPC_QTY) AS QTY
                             , 'MC'            AS TYPE
                          FROM SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION   A
                             , SCP_OPMZ_PLAN_GR_M                       B
                             , GT_OPT_SR_IS_MAT                        C
                         WHERE A.OPMZ_PLAN_GR_ID   = B.OPMZ_PLAN_GR_ID
                           AND A.ITEM_ID_CHILD     = C.MAT_ID
                           AND 1 = 2   /* 2026-03-10, 제약제거 */
                           AND A.DIVISION_ID       = V_DIVISION_ID
                           AND B.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                           AND A.VALID_YN          = 'Y'
                           AND B.VALID_YN          = 'Y'
                           AND A.TO_YYYYMMDD BETWEEN V_PLAN_START_YYYYMMDD AND C.EFF_END_DATE
                        /* END 2025.11.19 jongykim2: Schelduled Reciept Information */
                        /* BLOCKED 2025.11.19 jongykim2
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
                       ) MC
                 WHERE MC.ARR_DATE < V_PLAN_END_YYYYMMDD
               ) AA
         GROUP BY AA.PLAN_ID, AA.STOCK_ID, AA.BUFFER_ID, AA.EFECTIVE_DATE, AA.TYPE, AA.SITE_ID, AA.ITEM_ID, AA.STAGE, AA.INCOTERMS, AA.PROJECT_CODE;

        /* INCOMING STOCK INSERT #2.
           2025.07.10 Philsu Park: 재고 보정 데이터 Insert. */
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
             , A.STOCK_TYPE||'::'||A.SCM_SITE_ID||'::'||A.ITEM_ID||'::'||A.STAGE||CASE WHEN A.INCOTERMS != '-' THEN '@'||A.INCOTERMS||'@'||A.PROJECT_CODE ELSE '' END||'::'||A.INV_DATE AS STOCK_ID
             , A.SCM_SITE_ID||'::'||A.ITEM_ID||'::'||A.STAGE||CASE WHEN A.INCOTERMS != '-' THEN '@'||A.INCOTERMS||'@'||A.PROJECT_CODE ELSE '' END AS BUFFER_ID
             , A.INV_DATE     AS EFFECTIVE_DATE
             , A.STOCK_TYPE   AS TYPE
             , A.QTY          AS QUANTITY
             , A.SCM_SITE_ID  AS ATTRIBUTE1
             , A.ITEM_ID      AS ATTRIBUTE2
             , A.STAGE        AS ATTRIBUTE3
             , A.INCOTERMS    AS ATTRIBUTE4
             , A.PROJECT_CODE AS ATTRIBUTE5
             , 'INVENTORY_ADJUST' AS ATTRIBUTE15
             , 'INVENTORY_ADJUST' AS INSERT_ID
          FROM GT_OPT_SR_IS_ADJ A
         WHERE 1 = 1
           AND A.QTY > 0;

        /* 2nd OCV 재고는 INSP로 UPDATE
           MSSQL UPDATE..FROM INNER JOIN + SET 에 ON키(ATTRIBUTE3) 포함 -> MERGE 불가(ORA-38104) -> 상관 UPDATE + EXISTS.
           OCV 룩업이 (site, item, as_is_stage) 당 다중 TO_BE_STAGE 가능성 대비 MAX(TO_BE_STAGE) 결정화(단일행). */
        UPDATE
               SCP_OPT_ENG_INCOMING_STOCK_SN INC
           SET (INC.STOCK_ID, INC.BUFFER_ID, INC.ATTRIBUTE3) =
               (SELECT INC.TYPE||'::'||INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||OCV.TO_BE_STAGE||'::'||INC.EFFECTIVE_DATE
                     , INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||OCV.TO_BE_STAGE
                     , OCV.TO_BE_STAGE
                  FROM (SELECT L.SCM_SITE_ID
                             , L.ITEM_ID
                             , L.AS_IS_STAGE
                             , MAX(L.TO_BE_STAGE) AS TO_BE_STAGE
                          FROM (SELECT ATTRIBUTE2 AS AS_IS_STAGE
                                     , ATTRIBUTE3 AS TO_BE_STAGE
                                     , SEGMENT4   AS SCM_SITE_ID
                                     , SEGMENT5   AS ITEM_ID
                                  FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                 WHERE 1 = 2   /* 2026-03-10, 제약제거 */
                                   AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                   AND LU.VALID_YN    = 'Y'
                                   AND LU.SEGMENT2    = V_DIVISION_ID
                                   AND LU.SEGMENT3    = V_GROUP_ID
                                 GROUP BY ATTRIBUTE2, ATTRIBUTE3, SEGMENT4, SEGMENT5
                               ) L
                         GROUP BY L.SCM_SITE_ID, L.ITEM_ID, L.AS_IS_STAGE
                       ) OCV
                 WHERE INC.ATTRIBUTE1 = OCV.SCM_SITE_ID
                   AND INC.ATTRIBUTE2 = OCV.ITEM_ID
                   AND INC.ATTRIBUTE3 = OCV.AS_IS_STAGE)
         WHERE INC.PLAN_ID = V_PLAN_ID
           AND EXISTS (SELECT 1
                         FROM (SELECT SEGMENT4 AS SCM_SITE_ID, SEGMENT5 AS ITEM_ID, ATTRIBUTE2 AS AS_IS_STAGE
                                 FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                WHERE 1 = 2   /* 2026-03-10, 제약제거 */
                                  AND LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                  AND LU.VALID_YN    = 'Y'
                                  AND LU.SEGMENT2    = V_DIVISION_ID
                                  AND LU.SEGMENT3    = V_GROUP_ID
                                GROUP BY SEGMENT4, SEGMENT5, ATTRIBUTE2
                              ) OCV
                        WHERE INC.ATTRIBUTE1 = OCV.SCM_SITE_ID
                          AND INC.ATTRIBUTE2 = OCV.ITEM_ID
                          AND INC.ATTRIBUTE3 = OCV.AS_IS_STAGE);

        /* INTRANSIT 재고 중 SITE_ID, ITEM_ID를 DEMAND와 비교하여 INCOTERMS만 다른 경우가 있다면 INCOTERMS를 변경해서 사용할 수 있도록 UPDATE
           THK/20250724/상현 책임님 요청
           [FMT 별칭 예외] 아래 4개 INSERT 는 SCP_OPT_ENG_INCOMING_STOCK_SN / SCP_OPT_ENG_DEMAND_SN 을 4중 중첩에서 */
        IF V_DIVISION_ID = 'XX' THEN   /* '40' -- 2026-03-10, 소형 특화제거 */

            DELETE
              FROM GT_OPT_SR_IS_INC;

            DELETE
              FROM GT_OPT_SR_IS_INCDEL;

            /* DUE DATE가 재고 EFFECTIVE DATE보다 느린 애들 중 DUE의 MIN값을 먼저 찾아서 넣어 줌 */
            INSERT
              INTO GT_OPT_SR_IS_INC
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
            SELECT NI.PLAN_ID
                 , NI.STOCK_ID
                 /* BF_STOCK_ID */
                 , NI.BUFFER_ID
                 , NI.EFFECTIVE_DATE
                 , NI.TYPE
                 , SUM(NI.QUANTITY) AS SUM_QUANTITY
                 , NI.ATTRIBUTE1
                 , NI.ATTRIBUTE2
                 , NI.ATTRIBUTE3
                 , NI.ATTRIBUTE4
                 , NI.ATTRIBUTE5
                 , NI.ATTRIBUTE15
              FROM (
                    SELECT NI.PLAN_ID
                         , NI.STOCK_ID
                         /* , NI.BF_STOCK_ID */
                         , NI.BUFFER_ID
                         , NI.EFFECTIVE_DATE
                         , NI.TYPE
                         , NI.QUANTITY + NVL(INC.QUANTITY, 0) AS QUANTITY
                         , NI.ATTRIBUTE1
                         , NI.ATTRIBUTE2
                         , NI.ATTRIBUTE3
                         , NI.ATTRIBUTE4
                         , NI.ATTRIBUTE5
                         , NI.ATTRIBUTE15
                      FROM (
                            /*                               DM1 은 원본이 LEFT OUTER JOIN 이나 WHERE DM1.DEMAND_ID IS NOT NULL 로 실질 INNER 붕괴 -> 콤마 INNER(FM-015). */
                            SELECT INC.PLAN_ID AS PLAN_ID
                                 , CASE WHEN DM1.ATTRIBUTE4 IS NULL OR DM1.ATTRIBUTE5 IS NULL THEN NULL
                                        ELSE INC.TYPE||'::'||INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||DM1.ATTRIBUTE4||'@'||DM1.ATTRIBUTE5||'::'||INC.EFFECTIVE_DATE
                                   END AS STOCK_ID
                                 , INC.STOCK_ID AS BF_STOCK_ID
                                 , CASE WHEN DM1.ATTRIBUTE4 IS NULL OR DM1.ATTRIBUTE5 IS NULL THEN NULL
                                        ELSE INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||DM1.ATTRIBUTE4||'@'||DM1.ATTRIBUTE5
                                   END AS BUFFER_ID
                                 , INC.EFFECTIVE_DATE AS EFFECTIVE_DATE
                                 , INC.TYPE           AS TYPE
                                 , INC.QUANTITY       AS QUANTITY
                                 , INC.ATTRIBUTE1     AS ATTRIBUTE1
                                 , INC.ATTRIBUTE2     AS ATTRIBUTE2
                                 , INC.ATTRIBUTE3     AS ATTRIBUTE3
                                 , DM1.ATTRIBUTE4     AS ATTRIBUTE4
                                 , DM1.ATTRIBUTE5     AS ATTRIBUTE5
                                 , 'INCOTERMS_ADJUST' AS ATTRIBUTE15
                              FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                                 , SCP_OPT_ENG_DEMAND_SN           DM1
                                 , (SELECT DM.PLAN_ID
                                         , DM.ATTRIBUTE1
                                         , DM.ATTRIBUTE2
                                         , DM.ATTRIBUTE4
                                         , DM.ATTRIBUTE5
                                         , MIN(DM.DUE_DATE) AS DUE_DATE
                                      FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                                         , SCP_OPT_ENG_DEMAND_SN           DM
                                     WHERE INC.PLAN_ID         = DM.PLAN_ID(+)
                                       AND INC.ATTRIBUTE1      = DM.ATTRIBUTE1(+)
                                       AND INC.ATTRIBUTE2      = DM.ATTRIBUTE2(+)
                                       AND INC.ATTRIBUTE4     != DM.ATTRIBUTE4(+)
                                       AND INC.EFFECTIVE_DATE <= DM.DUE_DATE(+)
                                       AND DM.PLAN_ID = V_PLAN_ID
                                     GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                   ) DM2
                             WHERE INC.PLAN_ID         = DM1.PLAN_ID
                               AND INC.ATTRIBUTE1      = DM1.ATTRIBUTE1
                               AND INC.ATTRIBUTE2      = DM1.ATTRIBUTE2
                               AND INC.ATTRIBUTE4     != DM1.ATTRIBUTE4
                               AND INC.EFFECTIVE_DATE <= DM1.DUE_DATE
                               AND DM1.PLAN_ID         = DM2.PLAN_ID
                               AND DM1.ATTRIBUTE1      = DM2.ATTRIBUTE1
                               AND DM1.ATTRIBUTE2      = DM2.ATTRIBUTE2
                               AND DM1.ATTRIBUTE4      = DM2.ATTRIBUTE4
                               AND DM1.ATTRIBUTE5      = DM2.ATTRIBUTE5
                               AND DM1.DUE_DATE        = DM2.DUE_DATE
                               AND INC.PLAN_ID         = V_PLAN_ID
                               AND INC.TYPE            = 'INT'
                               AND DM1.DEMAND_ID IS NOT NULL
                               AND NOT EXISTS (SELECT 1
                                                 FROM SCP_OPT_ENG_DEMAND_SN DMD
                                                WHERE DMD.PLAN_ID    = V_PLAN_ID
                                                  AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                                  AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                                  AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                                  AND INC.EFFECTIVE_DATE <= DMD.DUE_DATE)
                           ) NI
                         , SCP_OPT_ENG_INCOMING_STOCK_SN INC
                     WHERE NI.PLAN_ID  = INC.PLAN_ID(+)
                       AND NI.STOCK_ID = INC.STOCK_ID(+)
                   ) NI
             GROUP BY NI.PLAN_ID, NI.STOCK_ID, NI.BUFFER_ID, NI.EFFECTIVE_DATE, NI.TYPE, NI.ATTRIBUTE1, NI.ATTRIBUTE2, NI.ATTRIBUTE3, NI.ATTRIBUTE4, NI.ATTRIBUTE5, NI.ATTRIBUTE15;

            /* DUE DATE가 재고 EFFECTIVE DATE보다 빠른 애들을 한 번 더 확인해서 넣어줌 -> DUE가 EFFECTIVE보다 느린 애들이 없는 애들만 찾아서 넣음 */
            INSERT
              INTO GT_OPT_SR_IS_INC
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
            SELECT NI.PLAN_ID
                 , NI.STOCK_ID
                 , NI.BUFFER_ID
                 , NI.EFFECTIVE_DATE
                 , NI.TYPE
                 , SUM(NI.QUANTITY) AS SUM_QUANTITY
                 , NI.ATTRIBUTE1
                 , NI.ATTRIBUTE2
                 , NI.ATTRIBUTE3
                 , NI.ATTRIBUTE4
                 , NI.ATTRIBUTE5
                 , NI.ATTRIBUTE15
              FROM (
                    SELECT NI.PLAN_ID
                         , NI.STOCK_ID
                         /* , NI.BF_STOCK_ID */
                         , NI.BUFFER_ID
                         , NI.EFFECTIVE_DATE
                         , NI.TYPE
                         , NI.QUANTITY + NVL(INC.QUANTITY, 0) AS QUANTITY
                         , NI.ATTRIBUTE1
                         , NI.ATTRIBUTE2
                         , NI.ATTRIBUTE3
                         , NI.ATTRIBUTE4
                         , NI.ATTRIBUTE5
                         , NI.ATTRIBUTE15
                      FROM (
                            SELECT INC.PLAN_ID AS PLAN_ID
                                 , CASE WHEN DM1.ATTRIBUTE4 IS NULL OR DM1.ATTRIBUTE5 IS NULL THEN NULL
                                        ELSE INC.TYPE||'::'||INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||DM1.ATTRIBUTE4||'@'||DM1.ATTRIBUTE5||'::'||INC.EFFECTIVE_DATE
                                   END AS STOCK_ID
                                 , INC.STOCK_ID AS BF_STOCK_ID
                                 , CASE WHEN DM1.ATTRIBUTE4 IS NULL OR DM1.ATTRIBUTE5 IS NULL THEN NULL
                                        ELSE INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||DM1.ATTRIBUTE4||'@'||DM1.ATTRIBUTE5
                                   END AS BUFFER_ID
                                 , INC.EFFECTIVE_DATE AS EFFECTIVE_DATE
                                 , INC.TYPE           AS TYPE
                                 , INC.QUANTITY       AS QUANTITY
                                 , INC.ATTRIBUTE1     AS ATTRIBUTE1
                                 , INC.ATTRIBUTE2     AS ATTRIBUTE2
                                 , INC.ATTRIBUTE3     AS ATTRIBUTE3
                                 , DM1.ATTRIBUTE4     AS ATTRIBUTE4
                                 , DM1.ATTRIBUTE5     AS ATTRIBUTE5
                                 , 'INCOTERMS_ADJUST' AS ATTRIBUTE15
                              FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                                 , SCP_OPT_ENG_DEMAND_SN           DM1
                                 , (SELECT DM.PLAN_ID
                                         , DM.ATTRIBUTE1
                                         , DM.ATTRIBUTE2
                                         , DM.ATTRIBUTE4
                                         , DM.ATTRIBUTE5
                                         , MIN(DM.DUE_DATE) AS DUE_DATE
                                      FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                                         , SCP_OPT_ENG_DEMAND_SN           DM
                                     WHERE INC.PLAN_ID        = DM.PLAN_ID(+)
                                       AND INC.ATTRIBUTE1     = DM.ATTRIBUTE1(+)
                                       AND INC.ATTRIBUTE2     = DM.ATTRIBUTE2(+)
                                       AND INC.ATTRIBUTE4    != DM.ATTRIBUTE4(+)
                                       AND INC.EFFECTIVE_DATE > DM.DUE_DATE(+)
                                       AND DM.PLAN_ID = V_PLAN_ID
                                     GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                   ) DM2
                             WHERE INC.PLAN_ID        = DM1.PLAN_ID
                               AND INC.ATTRIBUTE1     = DM1.ATTRIBUTE1
                               AND INC.ATTRIBUTE2     = DM1.ATTRIBUTE2
                               AND INC.ATTRIBUTE4    != DM1.ATTRIBUTE4
                               AND INC.EFFECTIVE_DATE > DM1.DUE_DATE
                               AND DM1.PLAN_ID        = DM2.PLAN_ID
                               AND DM1.ATTRIBUTE1     = DM2.ATTRIBUTE1
                               AND DM1.ATTRIBUTE2     = DM2.ATTRIBUTE2
                               AND DM1.ATTRIBUTE4     = DM2.ATTRIBUTE4
                               AND DM1.ATTRIBUTE5     = DM2.ATTRIBUTE5
                               AND DM1.DUE_DATE       = DM2.DUE_DATE
                               AND INC.PLAN_ID        = V_PLAN_ID
                               AND INC.TYPE           = 'INT'
                               AND DM1.DEMAND_ID IS NOT NULL
                               AND NOT EXISTS (SELECT 1
                                                 FROM SCP_OPT_ENG_DEMAND_SN DMD
                                                WHERE DMD.PLAN_ID    = V_PLAN_ID
                                                  AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                                  AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                                  AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                                  AND INC.EFFECTIVE_DATE > DMD.DUE_DATE)
                           ) NI
                         , SCP_OPT_ENG_INCOMING_STOCK_SN INC
                     WHERE NI.PLAN_ID  = INC.PLAN_ID(+)
                       AND NI.STOCK_ID = INC.STOCK_ID(+)
                   ) NI
                 , GT_OPT_SR_IS_INC IT
             /* DUE가 EFFECTIVE보다 느린 애들이 없는 애들만 찾아서 넣음 */
             WHERE NI.PLAN_ID  = IT.PLAN_ID(+)
               AND NI.STOCK_ID = IT.STOCK_ID(+)
               AND IT.PLAN_ID IS NULL
             GROUP BY NI.PLAN_ID, NI.STOCK_ID, NI.BUFFER_ID, NI.EFFECTIVE_DATE, NI.TYPE, NI.ATTRIBUTE1, NI.ATTRIBUTE2, NI.ATTRIBUTE3, NI.ATTRIBUTE4, NI.ATTRIBUTE5, NI.ATTRIBUTE15;

            INSERT
              INTO GT_OPT_SR_IS_INCDEL
                 ( PLAN_ID
                 , BF_STOCK_ID )
            SELECT NI.PLAN_ID
                 , NI.BF_STOCK_ID
              FROM (
                    SELECT INC.PLAN_ID AS PLAN_ID
                         , INC.TYPE||'::'||INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||INC.ATTRIBUTE4||'@'||INC.ATTRIBUTE5||'::'||INC.EFFECTIVE_DATE AS STOCK_ID
                         , INC.STOCK_ID AS BF_STOCK_ID
                         , INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||INC.ATTRIBUTE4||'@'||INC.ATTRIBUTE5 AS BUFFER_ID
                         , INC.EFFECTIVE_DATE AS EFFECTIVE_DATE
                         , INC.TYPE           AS TYPE
                         , INC.QUANTITY       AS QUANTITY
                         , INC.ATTRIBUTE1     AS ATTRIBUTE1
                         , INC.ATTRIBUTE2     AS ATTRIBUTE2
                         , INC.ATTRIBUTE3     AS ATTRIBUTE3
                         , DM1.ATTRIBUTE4     AS ATTRIBUTE4
                         , DM1.ATTRIBUTE5     AS ATTRIBUTE5
                         , 'INCOTERMS_ADJUST' AS ATTRIBUTE15
                      FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                         , SCP_OPT_ENG_DEMAND_SN           DM1
                         , (SELECT DM.PLAN_ID
                                 , DM.ATTRIBUTE1
                                 , DM.ATTRIBUTE2
                                 , DM.ATTRIBUTE4
                                 , DM.ATTRIBUTE5
                                 , MIN(DM.DUE_DATE) AS DUE_DATE
                              FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                                 , SCP_OPT_ENG_DEMAND_SN           DM
                             WHERE INC.PLAN_ID         = DM.PLAN_ID(+)
                               AND INC.ATTRIBUTE1      = DM.ATTRIBUTE1(+)
                               AND INC.ATTRIBUTE2      = DM.ATTRIBUTE2(+)
                               AND INC.ATTRIBUTE4     != DM.ATTRIBUTE4(+)
                               AND INC.EFFECTIVE_DATE <= DM.DUE_DATE(+)
                               AND DM.PLAN_ID = V_PLAN_ID
                             GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                           ) DM2
                     WHERE INC.PLAN_ID         = DM1.PLAN_ID
                       AND INC.ATTRIBUTE1      = DM1.ATTRIBUTE1
                       AND INC.ATTRIBUTE2      = DM1.ATTRIBUTE2
                       AND INC.ATTRIBUTE4     != DM1.ATTRIBUTE4
                       AND INC.EFFECTIVE_DATE <= DM1.DUE_DATE
                       AND DM1.PLAN_ID         = DM2.PLAN_ID
                       AND DM1.ATTRIBUTE1      = DM2.ATTRIBUTE1
                       AND DM1.ATTRIBUTE2      = DM2.ATTRIBUTE2
                       AND DM1.ATTRIBUTE4      = DM2.ATTRIBUTE4
                       AND DM1.ATTRIBUTE5      = DM2.ATTRIBUTE5
                       AND DM1.DUE_DATE        = DM2.DUE_DATE
                       AND INC.PLAN_ID         = V_PLAN_ID
                       AND INC.TYPE            = 'INT'
                       AND DM1.DEMAND_ID IS NOT NULL
                       AND NOT EXISTS (SELECT 1
                                         FROM SCP_OPT_ENG_DEMAND_SN DMD
                                        WHERE DMD.PLAN_ID    = V_PLAN_ID
                                          AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                          AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                          AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                          AND INC.EFFECTIVE_DATE <= DMD.DUE_DATE)
                   ) NI
                 , SCP_OPT_ENG_INCOMING_STOCK_SN INC
             WHERE NI.PLAN_ID  = INC.PLAN_ID(+)
               AND NI.STOCK_ID = INC.STOCK_ID(+);

            /* DUE DATE가 재고 EFFECTIVE DATE보다 빠른 애들을 한번 더 확인해서 넣어줌 */
            INSERT
              INTO GT_OPT_SR_IS_INCDEL
                 ( PLAN_ID
                 , BF_STOCK_ID )
            SELECT NI.PLAN_ID
                 , NI.BF_STOCK_ID
              FROM (
                    SELECT INC.PLAN_ID AS PLAN_ID
                         , INC.TYPE||'::'||INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||INC.ATTRIBUTE4||'@'||INC.ATTRIBUTE5||'::'||INC.EFFECTIVE_DATE AS STOCK_ID
                         , INC.STOCK_ID AS BF_STOCK_ID
                         , INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||INC.ATTRIBUTE3||'@'||INC.ATTRIBUTE4||'@'||INC.ATTRIBUTE5 AS BUFFER_ID
                         , INC.EFFECTIVE_DATE AS EFFECTIVE_DATE
                         , INC.TYPE           AS TYPE
                         , INC.QUANTITY       AS QUANTITY
                         , INC.ATTRIBUTE1     AS ATTRIBUTE1
                         , INC.ATTRIBUTE2     AS ATTRIBUTE2
                         , INC.ATTRIBUTE3     AS ATTRIBUTE3
                         , DM1.ATTRIBUTE4     AS ATTRIBUTE4
                         , DM1.ATTRIBUTE5     AS ATTRIBUTE5
                         , 'INCOTERMS_ADJUST' AS ATTRIBUTE15
                      FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                         , SCP_OPT_ENG_DEMAND_SN           DM1
                         , (SELECT DM.PLAN_ID
                                 , DM.ATTRIBUTE1
                                 , DM.ATTRIBUTE2
                                 , DM.ATTRIBUTE4
                                 , DM.ATTRIBUTE5
                                 , MIN(DM.DUE_DATE) AS DUE_DATE
                              FROM SCP_OPT_ENG_INCOMING_STOCK_SN   INC
                                 , SCP_OPT_ENG_DEMAND_SN           DM
                             WHERE INC.PLAN_ID        = DM.PLAN_ID(+)
                               AND INC.ATTRIBUTE1     = DM.ATTRIBUTE1(+)
                               AND INC.ATTRIBUTE2     = DM.ATTRIBUTE2(+)
                               AND INC.ATTRIBUTE4    != DM.ATTRIBUTE4(+)
                               AND INC.EFFECTIVE_DATE > DM.DUE_DATE(+)
                               AND DM.PLAN_ID = V_PLAN_ID
                             GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                           ) DM2
                     WHERE INC.PLAN_ID        = DM1.PLAN_ID
                       AND INC.ATTRIBUTE1     = DM1.ATTRIBUTE1
                       AND INC.ATTRIBUTE2     = DM1.ATTRIBUTE2
                       AND INC.ATTRIBUTE4    != DM1.ATTRIBUTE4
                       AND INC.EFFECTIVE_DATE > DM1.DUE_DATE
                       AND DM1.PLAN_ID        = DM2.PLAN_ID
                       AND DM1.ATTRIBUTE1     = DM2.ATTRIBUTE1
                       AND DM1.ATTRIBUTE2     = DM2.ATTRIBUTE2
                       AND DM1.ATTRIBUTE4     = DM2.ATTRIBUTE4
                       AND DM1.ATTRIBUTE5     = DM2.ATTRIBUTE5
                       AND DM1.DUE_DATE       = DM2.DUE_DATE
                       AND INC.PLAN_ID        = V_PLAN_ID
                       AND INC.TYPE           = 'INT'
                       AND DM1.DEMAND_ID IS NOT NULL
                       AND NOT EXISTS (SELECT 1
                                         FROM SCP_OPT_ENG_DEMAND_SN DMD
                                        WHERE DMD.PLAN_ID    = V_PLAN_ID
                                          AND DMD.ATTRIBUTE1 = INC.ATTRIBUTE1
                                          AND DMD.ATTRIBUTE2 = INC.ATTRIBUTE2
                                          AND DMD.ATTRIBUTE4 = INC.ATTRIBUTE4
                                          AND INC.EFFECTIVE_DATE > DMD.DUE_DATE)
                   ) NI
                 , SCP_OPT_ENG_INCOMING_STOCK_SN INC
                 , GT_OPT_SR_IS_INCDEL IT
             WHERE NI.PLAN_ID     = INC.PLAN_ID(+)
               AND NI.STOCK_ID    = INC.STOCK_ID(+)
               /* DUE가 EFFECTIVE보다 느린 애들이 없는 애들만 찾아서 넣음 */
               AND NI.PLAN_ID     = IT.PLAN_ID(+)
               AND NI.BF_STOCK_ID = IT.BF_STOCK_ID(+)
               AND IT.PLAN_ID IS NULL;

            /* KEY 중복을 방지하기 위해 MERGE INTO 사용 */
            MERGE
             INTO SCP_OPT_ENG_INCOMING_STOCK_SN INC
            USING GT_OPT_SR_IS_INC IT
               ON ( INC.PLAN_ID  = IT.PLAN_ID
                AND INC.STOCK_ID = IT.STOCK_ID )
             WHEN MATCHED THEN UPDATE
                  SET INC.QUANTITY    = IT.QUANTITY
                    , INC.ATTRIBUTE15 = IT.ATTRIBUTE15
             WHEN NOT MATCHED THEN
           INSERT ( PLAN_ID
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
           VALUES ( IT.PLAN_ID
                  , IT.STOCK_ID
                  , IT.BUFFER_ID
                  , IT.EFFECTIVE_DATE
                  , IT.TYPE
                  , IT.QUANTITY
                  , IT.ATTRIBUTE1
                  , IT.ATTRIBUTE2
                  , IT.ATTRIBUTE3
                  , IT.ATTRIBUTE4
                  , IT.ATTRIBUTE5
                  , IT.ATTRIBUTE15 );

            /* 기존 STOCK_ID는 삭제 */
            DELETE
              FROM SCP_OPT_ENG_INCOMING_STOCK_SN S
             WHERE EXISTS (SELECT 1
                             FROM GT_OPT_SR_IS_INCDEL IT
                            WHERE S.PLAN_ID  = IT.PLAN_ID
                              AND S.STOCK_ID = IT.BF_STOCK_ID);

            /* UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
               SET     SCP_OPT_ENG_INCOMING_STOCK_SN.STOCK_ID       = NI.STOCK_ID
               SET     SCP_OPT_ENG_INCOMING_STOCK_SN.BUFFER_ID      = NI.BUFFER_ID
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.EFFECTIVE_DATE = NI.EFFECTIVE_DATE
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.TYPE           = NI.TYPE
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.QUANTITY       = NI.QUANTITY
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE1     = NI.ATTRIBUTE1
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE2     = NI.ATTRIBUTE2
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE3     = NI.ATTRIBUTE3
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE4     = NI.ATTRIBUTE4
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE5     = NI.ATTRIBUTE5
                      ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE15    = NI.ATTRIBUTE15
               FROM(
                   SELECT  INC.PLAN_ID                                                                                                                          AS PLAN_ID
                          ,INC.TYPE+'::'+INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+INC.ATTRIBUTE3+'::'+DM1.ATTRIBUTE4+'::'+DM1.ATTRIBUTE5+'::'+INC.EFFECTIVE_DATE AS STOCK_ID
                          ,INC.STOCK_ID                                                                                                                         AS BF_STOCK_ID
                          ,INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+INC.ATTRIBUTE3+'::'+DM1.ATTRIBUTE4+'::'+DM1.ATTRIBUTE5                                       AS BUFFER_ID
                          ,INC.EFFECTIVE_DATE  AS EFFECTIVE_DATE
                          ,INC.TYPE            AS TYPE
                          ,INC.QUANTITY        AS QUANTITY
                          ,INC.ATTRIBUTE1      AS ATTRIBUTE1
                          ,INC.ATTRIBUTE2      AS ATTRIBUTE2
                          ,INC.ATTRIBUTE3      AS ATTRIBUTE3
                          ,DM1.ATTRIBUTE4      AS ATTRIBUTE4
                          ,DM1.ATTRIBUTE5      AS ATTRIBUTE5
                          ,'INCOTERMS_ADJUST'  AS ATTRIBUTE15
                   FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INC WITH(NOLOCK)
                       LEFT OUTER JOIN SCP_OPT_ENG_DEMAND_SN DM1 WITH(NOLOCK)
                           ON  INC.PLAN_ID    = DM1.PLAN_ID
                           AND INC.ATTRIBUTE1 = DM1.ATTRIBUTE1
                           AND INC.ATTRIBUTE2 = DM1.ATTRIBUTE2
                           AND INC.ATTRIBUTE4!= DM1.ATTRIBUTE4
                       INNER JOIN(
                                  SELECT  DM.PLAN_ID
                                         ,DM.ATTRIBUTE1
                                         ,DM.ATTRIBUTE2
                                         ,DM.ATTRIBUTE4
                                         ,DM.ATTRIBUTE5
                                         ,MIN(DUE_DATE) AS DUE_DATE
                                  FROM    SCP_OPT_ENG_DEMAND_SN DM WITH(NOLOCK)
                                  WHERE   DM.PLAN_ID = @V_PLAN_ID
                                  GROUP BY DM.PLAN_ID, DM.ATTRIBUTE1, DM.ATTRIBUTE2, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                                 ) DM2
                           ON  DM1.PLAN_ID    = DM2.PLAN_ID
                           AND DM1.ATTRIBUTE1 = DM2.ATTRIBUTE1
                           AND DM1.ATTRIBUTE2 = DM2.ATTRIBUTE2
                           AND DM1.ATTRIBUTE4 = DM2.ATTRIBUTE4
                           AND DM1.ATTRIBUTE5 = DM2.ATTRIBUTE5
                           AND DM1.DUE_DATE   = DM2.DUE_DATE
                   WHERE   INC.PLAN_ID = @V_PLAN_ID
                   AND     INC.TYPE    = 'INT'
                   AND     DM1.DEMAND_ID IS NOT NULL
                   ) NI
               WHERE  SCP_OPT_ENG_INCOMING_STOCK_SN.PLAN_ID  = NI.PLAN_ID
               AND    SCP_OPT_ENG_INCOMING_STOCK_SN.STOCK_ID = NI.BF_STOCK_ID */

        END IF;

        /* 2nd OCV 재고 계산
           20251028/T.H.KIM/HOLD 재고 반영을 위해 10/27주차는 계산 로직 주석처리 */
        V_FP_INV_CUTOFF_DATE := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

        /* 1ST OCV, 2ND OCV를 모두 하는 경우 계산 */
        DELETE
          FROM GT_OPT_SR_IS_OCVA;

        DELETE
          FROM GT_OPT_SR_IS_OCV2;

        DELETE
          FROM GT_OPT_SR_IS_OCVM;

        DELETE
          FROM GT_OPT_SR_IS_OCVI;

        /*           GTT 로 옮길 때 시퀀스를 쓰면 세션 간 값이 이어져 2회차부터 WHERE ROW_NUM = n 이 0건이 되므로 */
        INSERT
          INTO GT_OPT_SR_IS_OCVA
             ( ROW_NUM
             , SCM_SITE_ID
             , PLANT_ID
             , ORI_ITEM_ID
             , CHILD_ITEM_ID
             , STAGE
             , LT
             , YIELD
             , FAIL_RATIO
             , OCV_NUMBER
             , SECOND_OCV_TIME )
        SELECT ROW_NUMBER() OVER (ORDER BY B.SCM_SITE_ID, B.PLANT_ID, A.CHILD_ITEM_ID, C.ATTRIBUTE4, C.ATTRIBUTE9) AS ROW_NUM
             , B.SCM_SITE_ID   AS SCM_SITE_ID
             , B.PLANT_ID      AS PLANT_ID
             , C.SEGMENT5      AS ORI_ITEM_ID
             , A.CHILD_ITEM_ID AS CHILD_ITEM_ID
             , C.ATTRIBUTE3    AS STAGE
             , TO_NUMBER(C.ATTRIBUTE6) AS LT
             , TO_NUMBER(C.ATTRIBUTE7) AS YIELD
             , TO_NUMBER(C.ATTRIBUTE8) AS FAIL_RATIO
             , C.ATTRIBUTE4    AS OCV_NUMBER
             , C.ATTRIBUTE9    AS SECOND_OCV_TIME
          FROM SCM_MST_BOM_SN_V                A
             , SCM_MST_SITE                    B
             , SCP_OPMZ_LOOKUP_MASTER_DETAIL   C
         WHERE A.PLANT_ID       = B.PLANT_ID
           AND C.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
           AND C.VALID_YN       = 'Y'
           AND C.SEGMENT2       = V_DIVISION_ID
           AND C.SEGMENT3       = V_GROUP_ID
           AND C.ATTRIBUTE1     = 'B'
           /* MSSQL col != '' 는 Oracle 에서 항상 UNKNOWN(死조건) -> RTRIM(col) IS NOT NULL 로 변환(CV-028). */
           AND RTRIM(C.ATTRIBUTE9) IS NOT NULL
           AND 1 = 2   /* 2026-03-10, 제약제거 */
           AND B.SCM_SITE_ID    = C.SEGMENT4
           AND A.PARENT_ITEM_ID = C.SEGMENT5
         GROUP BY B.SCM_SITE_ID, B.PLANT_ID, A.CHILD_ITEM_ID, C.SEGMENT5, C.ATTRIBUTE4, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE3;

        SELECT
               MAX(ROW_NUM)
          INTO V_1ST_MAX_ROW_NUM
          FROM GT_OPT_SR_IS_OCVA;

        WHILE V_1ST_ROW_NUM <= V_1ST_MAX_ROW_NUM LOOP
            /* 현재 행 데이터 읽기
               MSSQL 대입형 SELECT 는 0행이면 변수값을 유지한다 -> NO_DATA_FOUND 흡수로 동일 거동. */
            BEGIN
                SELECT
                       SCM_SITE_ID
                     , PLANT_ID
                     , ORI_ITEM_ID
                     , CHILD_ITEM_ID
                     , STAGE
                     , LT
                     , YIELD
                     , FAIL_RATIO
                     , OCV_NUMBER
                     , SECOND_OCV_TIME
                  INTO V_1ST_SCM_SITE_ID
                     , V_1ST_PLANT_ID
                     , V_1ST_ORI_ITEM_ID
                     , V_1ST_CHILD_ITEM_ID
                     , V_1ST_STAGE
                     , V_1ST_LT
                     , V_1ST_YIELD
                     , V_1ST_FAIL_RATIO
                     , V_1ST_OCV_NUMBER
                     , V_1ST_SECOND_OCV_TIME
                  FROM GT_OPT_SR_IS_OCVA
                 WHERE ROW_NUM = V_1ST_ROW_NUM;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            /* CHILD_ITEM_ID가 바뀌면 누적 FAIL_RATIO 초기화
               1ST OCV는  LT와 합격률만 먹여야하고 실제 MDLE 제품이 만들어지짖는 않음
               따라서 1ST OCV는 제품이 바꼈을 때 LT를 더하고 FAIL_RATIO에 YIELD를 곱하기만 해 줌 */
            IF V_1ST_PREV_CHILD IS NULL OR V_1ST_PREV_CHILD <> V_1ST_CHILD_ITEM_ID THEN
                /* SET @1ST_CUM_FAIL_RATIO = 1
                   SET @1ST_CUM_LT = 0
                   SET @1ST_CUR_CUM_FAIL_RATIO = @1ST_CUM_FAIL_RATIO*@1ST_YIELD;
                   SET @1ST_CUM_LT      = @1ST_CUM_LT + @1ST_LT */
                V_1ST_CUR_CUM_FAIL_RATIO := V_1ST_YIELD;
                V_1ST_CUM_FAIL_RATIO     := V_1ST_YIELD;
                V_1ST_CUM_LT             := V_1ST_LT;

            /* 2ND OCV 적용 */
            ELSE
                V_1ST_CUR_CUM_FAIL_RATIO := V_1ST_CUM_FAIL_RATIO;
                V_1ST_FINAL_VALUE        := V_1ST_YIELD * V_1ST_CUR_CUM_FAIL_RATIO;
                V_1ST_CUM_LT             := V_1ST_CUM_LT + V_1ST_LT;

                /* 결과 저장 */
                INSERT
                  INTO GT_OPT_SR_IS_OCVM
                     ( SCM_SITE_ID
                     , PLANT_ID
                     , ORI_ITEM_ID
                     , CHILD_ITEM_ID
                     , STAGE
                     , LT
                     , YIELD
                     , FAIL_RATIO
                     , OCV_NUMBER
                     , SECOND_OCV_TIME
                     , CUM_FAIL_RATIO_BEFORE
                     , CUM_LT
                     , FINAL_VALUE
                     , NUM_DIV
                     , INS_NUM )
                VALUES ( V_1ST_SCM_SITE_ID
                       , V_1ST_PLANT_ID
                       , V_1ST_ORI_ITEM_ID
                       , V_1ST_CHILD_ITEM_ID
                       , V_1ST_STAGE
                       , V_1ST_LT
                       , V_1ST_YIELD
                       , V_1ST_FAIL_RATIO
                       , V_1ST_OCV_NUMBER
                       , '0'   /* 1ST OCV 적용 대상은 INS_NUM으로 계산하고 SECOND_OCV_TIME은 무조건 0 -> SECOND_OCV_TIME이 1이상인 것들은 2ND OCV만 하는 경우에만 있을 것이기 때문에 (원본은 숫자 0 을 NVARCHAR(20) 컬럼에 대입 -> '0') */
                       , V_1ST_CUR_CUM_FAIL_RATIO
                       , V_1ST_CUM_LT
                       , V_1ST_FINAL_VALUE
                       , '1'
                       , TO_NUMBER(V_1ST_SECOND_OCV_TIME)
                       );
                /* 누적 FAIL_RATIO 갱신 (다음 행을 위해) */
                V_1ST_CUM_FAIL_RATIO := V_1ST_CUM_FAIL_RATIO * V_1ST_FAIL_RATIO;

            END IF;
            V_1ST_PREV_CHILD := V_1ST_CHILD_ITEM_ID;
            V_1ST_ROW_NUM    := V_1ST_ROW_NUM + 1;
        END LOOP;

        /* 2ND OCV만 하는 경우 계산 */
        INSERT
          INTO GT_OPT_SR_IS_OCV2
             ( ROW_NUM
             , SCM_SITE_ID
             , PLANT_ID
             , ORI_ITEM_ID
             , CHILD_ITEM_ID
             , STAGE
             , LT
             , YIELD
             , FAIL_RATIO
             , OCV_NUMBER
             , SECOND_OCV_TIME )
        SELECT ROW_NUMBER() OVER (ORDER BY B.SCM_SITE_ID, B.PLANT_ID, A.CHILD_ITEM_ID, C.ATTRIBUTE4, C.ATTRIBUTE9) AS ROW_NUM
             , B.SCM_SITE_ID   AS SCM_SITE_ID
             , B.PLANT_ID      AS PLANT_ID
             , C.SEGMENT5      AS ORI_ITEM_ID
             , A.CHILD_ITEM_ID AS CHILD_ITEM_ID
             , C.ATTRIBUTE3    AS STAGE
             , TO_NUMBER(C.ATTRIBUTE6) AS LT
             , TO_NUMBER(C.ATTRIBUTE7) AS YIELD
             , TO_NUMBER(C.ATTRIBUTE8) AS FAIL_RATIO
             , C.ATTRIBUTE4    AS OCV_NUMBER
             , C.ATTRIBUTE9    AS SECOND_OCV_TIME
          FROM SCM_MST_BOM_SN_V                A
             , SCM_MST_SITE                    B
             , SCP_OPMZ_LOOKUP_MASTER_DETAIL   C
         WHERE A.PLANT_ID       = B.PLANT_ID
           AND C.LOOKUP_TYPE    = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
           AND C.VALID_YN       = 'Y'
           AND C.SEGMENT2       = V_DIVISION_ID
           AND C.SEGMENT3       = V_GROUP_ID
           AND C.ATTRIBUTE1     = 'B'
           AND C.ATTRIBUTE4    != '1'
           AND RTRIM(C.ATTRIBUTE9) IS NOT NULL
           AND 1 = 2   /* 2026-03-10, 제약제거 */
           AND B.SCM_SITE_ID    = C.SEGMENT4
           AND A.PARENT_ITEM_ID = C.SEGMENT5
         GROUP BY B.SCM_SITE_ID, B.PLANT_ID, A.CHILD_ITEM_ID, C.SEGMENT5, C.ATTRIBUTE4, C.ATTRIBUTE6, C.ATTRIBUTE7, C.ATTRIBUTE8, C.ATTRIBUTE9, C.ATTRIBUTE3;

        SELECT
               MAX(ROW_NUM)
          INTO V_2ND_MAX_ROW_NUM
          FROM GT_OPT_SR_IS_OCV2;

        /* 1차 루프 시작 */
        WHILE V_2ND_ROW_NUM <= V_2ND_MAX_ROW_NUM LOOP
            /* 현재 행 데이터 읽기 */
            BEGIN
                SELECT
                       SCM_SITE_ID
                     , PLANT_ID
                     , ORI_ITEM_ID
                     , CHILD_ITEM_ID
                     , STAGE
                     , LT
                     , YIELD
                     , FAIL_RATIO
                     , OCV_NUMBER
                     , SECOND_OCV_TIME
                     , TO_NUMBER(SECOND_OCV_TIME)
                  INTO V_2ND_SCM_SITE_ID
                     , V_2ND_PLANT_ID
                     , V_2ND_ORI_ITEM_ID
                     , V_2ND_CHILD_ITEM_ID
                     , V_2ND_STAGE
                     , V_2ND_LT
                     , V_2ND_YIELD
                     , V_2ND_FAIL_RATIO
                     , V_2ND_OCV_NUMBER
                     , V_2ND_SECOND_OCV_TIME
                     , V_2ND_INS_NUM
                  FROM GT_OPT_SR_IS_OCV2
                 WHERE ROW_NUM = V_2ND_ROW_NUM;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            /* SITE+ITEM_ID 별 최대 2ND OCV 검사 차수 설정 -> 2차 루프를 돌리기 위해 */
            SELECT
                   TO_NUMBER(MAX(A.ATTRIBUTE9))
              INTO V_2ND_MAX_INS_NUM
              FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL A
             WHERE A.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
               AND A.VALID_YN    = 'Y'
               AND A.SEGMENT2    = V_DIVISION_ID
               AND A.SEGMENT3    = V_GROUP_ID
               AND A.SEGMENT4    = V_2ND_SCM_SITE_ID
               AND A.SEGMENT5    = V_2ND_ORI_ITEM_ID;
            /* 2차 루프 돌리기 위한 SUB ROW NUM */
            V_2ND_SUB_ROW_NUM := V_2ND_ROW_NUM;

            /* 2차 루프 시작 */
            WHILE V_2ND_INS_NUM <= V_2ND_MAX_INS_NUM LOOP
                /* 현재 행 데이터 읽기 */
                BEGIN
                    SELECT
                           SCM_SITE_ID
                         , PLANT_ID
                         , ORI_ITEM_ID
                         , CHILD_ITEM_ID
                         , STAGE
                         , LT
                         , YIELD
                         , FAIL_RATIO
                         , OCV_NUMBER
                         /* , SECOND_OCV_TIME */
                         , TO_NUMBER(SECOND_OCV_TIME)
                      INTO V_2ND_SCM_SITE_ID
                         , V_2ND_PLANT_ID
                         , V_2ND_ORI_ITEM_ID
                         , V_2ND_CHILD_ITEM_ID
                         , V_2ND_STAGE
                         , V_2ND_LT
                         , V_2ND_YIELD
                         , V_2ND_FAIL_RATIO
                         , V_2ND_OCV_NUMBER
                         , V_2ND_INS_NUM
                      FROM GT_OPT_SR_IS_OCV2
                     WHERE ROW_NUM = V_2ND_SUB_ROW_NUM;
                EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
                END;

                IF V_2ND_PREV_CHILD IS NULL OR V_2ND_PREV_CHILD <> V_2ND_CHILD_ITEM_ID OR V_2ND_INS_NUM = TO_NUMBER(V_2ND_SECOND_OCV_TIME) THEN
                    V_2ND_CUM_FAIL_RATIO := 1;
                    V_2ND_CUM_LT         := 0;
                END IF;

                V_2ND_CUR_CUM_FAIL_RATIO := V_2ND_CUM_FAIL_RATIO;
                V_2ND_FINAL_VALUE        := V_2ND_YIELD * V_2ND_CUR_CUM_FAIL_RATIO;
                V_2ND_CUM_LT             := V_2ND_CUM_LT + V_2ND_LT;

                /* 결과 저장 */
                INSERT
                  INTO GT_OPT_SR_IS_OCVM
                     ( SCM_SITE_ID
                     , PLANT_ID
                     , ORI_ITEM_ID
                     , CHILD_ITEM_ID
                     , STAGE
                     , LT
                     , YIELD
                     , FAIL_RATIO
                     , OCV_NUMBER
                     , SECOND_OCV_TIME
                     , CUM_FAIL_RATIO_BEFORE
                     , CUM_LT
                     , FINAL_VALUE
                     , NUM_DIV
                     , INS_NUM )
                VALUES ( V_2ND_SCM_SITE_ID
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
                /* 누적 FAIL_RATIO 갱신 (다음 행을 위해) */
                V_2ND_CUM_FAIL_RATIO := V_2ND_CUM_FAIL_RATIO * V_2ND_FAIL_RATIO;
                V_2ND_PREV_CHILD     := V_2ND_CHILD_ITEM_ID;
                V_2ND_INS_NUM        := V_2ND_INS_NUM + 1;
                V_2ND_SUB_ROW_NUM    := V_2ND_SUB_ROW_NUM + 1;
            END LOOP;
            /* 2차 루프 끝 */
            V_2ND_ROW_NUM := V_2ND_ROW_NUM + 1;
        END LOOP;
        /* 1차 루프 끝 */

        /* FP 재고 계산
           2025.11.04 Minyong Lee : 2ND OCV WORKBENCH 적용 */
        INSERT
          INTO GT_OPT_SR_IS_OCVI
             ( PLANT_ID
             , ITEM_ID
             , AVAILABLE_DATE
             , QTY
             , NUM_DIV
             , SECOND_OCV_TIME
             , STOCK_TYPE )
        SELECT A.PLANT_ID
             , A.ITEM_ID
             , A.AVAILABLE_DATE
             , SUM(A.QTY) AS QTY
             , TO_NUMBER(A.NUM_DIV)
             , A.SECOND_OCV_TIME
             , MAX(A.STOCK_TYPE)
          FROM (
                SELECT B.PLANT_ID    AS PLANT_ID
                     , B.MES_ITEM_ID AS ITEM_ID
                     , TO_CHAR(NVL(B.SECOND_OCV_EXP_DATE, TO_DATE(V_PLAN_START_YYYYMMDD, 'YYYYMMDD')), 'YYYYMMDD') AS AVAILABLE_DATE
                     , SUM(NVL(D.CHG_QTY, B.QTY)) AS QTY   /* 2025.11.04 Minyong Lee : 2ND OCV WORKBENCH 적용 */
                     /* , FI.OPERATION_ID    AS OPERATION_ID
                        , IIF((FI.OPERATION_ID < 'P5200' OR FI.OPERATION_ID = 'PR000') AND ISNULL(FI.SECOND_OCV_TIME,0) = 0,'1','2') AS NUM_DIV OPERATION_ID가 P5200보다 작거나 PR000이고 SECOND_OCV_TIME이 0인 경우에만 NUM_DIV를 1로 설정 -> 해당 경우에만 1차 OCV 적용 */
                     , B.MES_OPERATION_ID AS OPERATION_ID
                     /* , CASE WHEN FI.MES_OPERATION_ID <= 'P5300' OR FI.MES_OPERATION_ID ='PR000'   THEN '1' P5300이하 OR PR000공정은 1ST OCV부터 계산
                              WHEN FI.MES_OPERATION_ID =  'P5400'                                   THEN '2' P5400공정에 대해서만 2ND OCV 재고 계산
                          ELSE '0' 위 두가지 케이스가 아닌 경우 즉가용 재고로 판단 */
                     , CASE WHEN B.MES_OPERATION_ID = 'P5000'                                                                     THEN '0'   /* P5000이면 즉가용 재고 */
                            WHEN B.MES_OPERATION_ID != 'P5000' AND (B.MES_OPERATION_ID <= 'P5300' OR B.MES_OPERATION_ID = 'PR000') THEN '1'  /* P5300이하 OR PR000공정은 1ST OCV부터 계산 */
                            WHEN B.MES_OPERATION_ID = 'P5400'                                                                     THEN '2'   /* P5400공정에 대해서만 2ND OCV 재고 계산 */
                            ELSE '0'   /* 상기 케이스가 아닌 경우 즉가용 재고로 판단 */
                       END AS NUM_DIV
                     , NVL(B.SECOND_OCV_TIME, 0) AS SECOND_OCV_TIME
                     , MAX(D.STOCK_TYPE)         AS STOCK_TYPE
                  FROM SCM_DNM_STOCK_SN B
                       INNER JOIN (SELECT PLANT_ID
                                        , CHILD_ITEM_ID
                                     FROM GT_OPT_SR_IS_OCVM
                                    GROUP BY PLANT_ID, CHILD_ITEM_ID
                                  ) C
                          ON B.PLANT_ID    = C.PLANT_ID
                         AND B.MES_ITEM_ID = C.CHILD_ITEM_ID
                       /* 2025.11.04 Minyong Lee : 2ND OCV WORKBENCH 적용 */
                       LEFT JOIN SCP_OPMZ_INV_SECOND_OCV D
                          ON 1 = 2   /* 2026-03-10, 제약제거 */
                         AND B.DIVISION_ID = D.DIVISION_ID
                         AND TO_CHAR(B.CUTOFF_DATE, 'YYYYMMDD') = D.CUTOFF_YYYYMMDD
                         AND B.PLANT_ID    = D.PLANT_ID
                         AND B.ITEM_ID     = D.ITEM_ID
                         AND B.MES_OPERATION_ID = D.OPERATION_ID
                         AND NVL(TO_CHAR(B.SECOND_OCV_TIME), ' ')             = NVL(D.SECOND_OCV_TIME, ' ')
                         AND NVL(TO_CHAR(B.SECOND_OCV_EXP_DATE, 'YYYYMMDD'), ' ') = NVL(D.SECOND_OCV_DATE, ' ')
                 WHERE TO_CHAR(B.CUTOFF_DATE, 'YYYYMMDD') = V_FP_INV_CUTOFF_DATE
                   AND B.PRODUCTION_TYPE  != 'D-SAMPLE'
                   AND B.MES_OPERATION_ID != 'PS000'
                 GROUP BY B.PLANT_ID, B.MES_ITEM_ID, B.SECOND_OCV_EXP_DATE, B.MES_OPERATION_ID, B.SECOND_OCV_TIME
               ) A
         GROUP BY A.PLANT_ID, A.ITEM_ID, A.AVAILABLE_DATE, A.NUM_DIV, A.SECOND_OCV_TIME;

        /* 기존에 있던 MDLE 재고도 반영해야하기 때문에 MERGE사용 */
        MERGE
         INTO SCP_OPT_ENG_INCOMING_STOCK_SN INC
        USING (
               SELECT V_PLAN_ID AS PLAN_ID
                    , 'WH'||'::'||A.SCM_SITE_ID||'::'||A.ORI_ITEM_ID||'::'||A.STAGE||'::'||A.EFFECTIVE_DATE AS STOCK_ID
                    , A.SCM_SITE_ID||'::'||A.ORI_ITEM_ID||'::'||A.STAGE AS BUFFER_ID
                    , A.EFFECTIVE_DATE AS EFFECTIVE_DATE
                    , A.TYPE           AS TYPE
                    , SUM(A.QTY)       AS QUANTITY
                    , A.ATTRIBUTE1     AS ATTRIBUTE1
                    , A.ATTRIBUTE2     AS ATTRIBUTE2
                    , A.ATTRIBUTE3     AS ATTRIBUTE3
                 FROM (
                       SELECT CASE WHEN B.EFFECTIVE_DATE < V_PLAN_START_YYYYMMDD THEN V_PLAN_START_YYYYMMDD
                                   WHEN B.EFFECTIVE_DATE > V_PLAN_END_YYYYMMDD   THEN V_PLAN_END_YYYYMMDD
                                   ELSE B.EFFECTIVE_DATE
                              END AS EFFECTIVE_DATE
                            , B.SCM_SITE_ID
                            , B.ORI_ITEM_ID
                            , B.STAGE
                            , B.TYPE
                            , SUM(B.QTY) AS QTY
                            , B.ATTRIBUTE1
                            , B.ATTRIBUTE2
                            , B.ATTRIBUTE3
                         FROM (
                               SELECT TO_CHAR(TO_DATE(C.AVAILABLE_DATE, 'YYYYMMDD') + D.CUM_LT, 'YYYYMMDD') AS EFFECTIVE_DATE
                                    , NVL(C.STOCK_TYPE, 'WH')          AS TYPE   /* 2025.11.04 Minyong Lee : 2ND OCV WORKBENCH 적용 */
                                    , ROUND(C.QTY * D.FINAL_VALUE, 5)  AS QTY
                                    , D.SCM_SITE_ID                    AS SCM_SITE_ID
                                    , D.ORI_ITEM_ID                    AS ORI_ITEM_ID
                                    , D.STAGE                          AS STAGE
                                    , D.SCM_SITE_ID                    AS ATTRIBUTE1
                                    , D.ORI_ITEM_ID                    AS ATTRIBUTE2
                                    , D.STAGE                          AS ATTRIBUTE3
                                 FROM GT_OPT_SR_IS_OCVI   C
                                    , GT_OPT_SR_IS_OCVM   D
                                WHERE C.PLANT_ID        = D.PLANT_ID
                                  AND C.ITEM_ID         = D.CHILD_ITEM_ID
                                  AND C.NUM_DIV         = TO_NUMBER(D.NUM_DIV)
                                  AND C.SECOND_OCV_TIME = TO_NUMBER(D.SECOND_OCV_TIME)
                                  AND C.SECOND_OCV_TIME <= D.INS_NUM
                                  AND 1 = 1
                                  AND ROUND(C.QTY * D.FINAL_VALUE, 5) > 0
                                UNION ALL
                               /* NUM_DIV가 0인 경우 즉가용 재고로 INSERT */
                               SELECT V_PLAN_START_YYYYMMDD   AS EFFECTIVE_DATE
                                    , 'WH'                    AS TYPE
                                    , ROUND(C.QTY, 5)         AS QTY
                                    , D.SCM_SITE_ID           AS SCM_SITE_ID
                                    , D.ORI_ITEM_ID           AS ORI_ITEM_ID
                                    , D.STAGE                 AS STAGE
                                    , D.SCM_SITE_ID           AS ATTRIBUTE1
                                    , D.ORI_ITEM_ID           AS ATTRIBUTE2
                                    , D.STAGE                 AS ATTRIBUTE3
                                 FROM GT_OPT_SR_IS_OCVI C
                                    , (SELECT SCM_SITE_ID
                                            , PLANT_ID
                                            , ORI_ITEM_ID
                                            , CHILD_ITEM_ID
                                            , STAGE
                                         FROM GT_OPT_SR_IS_OCVM
                                        GROUP BY SCM_SITE_ID, PLANT_ID, ORI_ITEM_ID, CHILD_ITEM_ID, STAGE
                                      ) D
                                WHERE C.PLANT_ID = D.PLANT_ID
                                  AND C.ITEM_ID  = D.CHILD_ITEM_ID
                                  AND C.NUM_DIV  = 0
                              ) B
                        WHERE B.EFFECTIVE_DATE < V_PLAN_END_YYYYMMDD   /* 2025.11.05 Minyong Lee : 2nd OCV 계획구간 내 재고만 */
                        GROUP BY B.SCM_SITE_ID, B.ORI_ITEM_ID, B.STAGE, B.EFFECTIVE_DATE, B.TYPE, B.ATTRIBUTE1, B.ATTRIBUTE2, B.ATTRIBUTE3
                      ) A
                GROUP BY A.SCM_SITE_ID, A.ORI_ITEM_ID, A.STAGE, A.EFFECTIVE_DATE, A.TYPE, A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3
              ) OCV
           ON ( INC.PLAN_ID  = OCV.PLAN_ID
            AND INC.STOCK_ID = OCV.STOCK_ID )
         WHEN MATCHED THEN UPDATE
              SET INC.QUANTITY = INC.QUANTITY + OCV.QUANTITY
         WHEN NOT MATCHED THEN
       INSERT ( PLAN_ID
              , STOCK_ID
              , BUFFER_ID
              , EFFECTIVE_DATE
              , TYPE
              , QUANTITY
              , ATTRIBUTE1
              , ATTRIBUTE2
              , ATTRIBUTE3 )
       VALUES ( OCV.PLAN_ID
              , OCV.STOCK_ID
              , OCV.BUFFER_ID
              , OCV.EFFECTIVE_DATE
              , OCV.TYPE
              , OCV.QUANTITY
              , OCV.ATTRIBUTE1
              , OCV.ATTRIBUTE2
              , OCV.ATTRIBUTE3 );

        /* Data Insert End */
        /* MSSQL 임시테이블 DROP-IF-EXISTS -> Oracle GTT 정리 DELETE (세션 잔존 방지) */
        DELETE
          FROM GT_OPT_SR_IS_INV;

        DELETE
          FROM GT_OPT_SR_IS_INT;

        DELETE
          FROM GT_OPT_SR_IS_CP;

        DELETE
          FROM GT_OPT_SR_IS_ADJ;

        DELETE
          FROM GT_OPT_SR_IS_DM;

        DELETE
          FROM GT_OPT_SR_IS_OCVEX;

        DELETE
          FROM GT_OPT_SR_IS_CPS;

        DELETE
          FROM GT_OPT_SR_IS_MAT;

        DELETE
          FROM GT_OPT_SR_IS_INC;

        DELETE
          FROM GT_OPT_SR_IS_INCDEL;

        DELETE
          FROM GT_OPT_SR_IS_OCVA;

        DELETE
          FROM GT_OPT_SR_IS_OCV2;

        DELETE
          FROM GT_OPT_SR_IS_OCVM;

        DELETE
          FROM GT_OPT_SR_IS_OCVI;

    EXCEPTION
    /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_RUN_MAIN_PROC; */
    /* ERROR LOG */
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
END PR_SCP_OPT_ENG_SR_INPUT_INCOMING_STOCK;