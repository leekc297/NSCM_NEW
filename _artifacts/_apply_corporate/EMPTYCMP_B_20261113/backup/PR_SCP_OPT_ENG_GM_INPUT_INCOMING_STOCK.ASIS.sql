CREATE OR REPLACE PROCEDURE PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK
(
    P_PLAN_ID                IN VARCHAR2
  , P_DIVISION_ID            IN VARCHAR2
  , P_GROUP_ID               IN VARCHAR2
  , P_PLAN_START_YYYYMMDD    IN VARCHAR2
  , P_PLAN_END_YYYYMMDD      IN VARCHAR2
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK
 * Description  : GM 최적화 엔진 입력용 입고 재고(Incoming Stock) 정보를 만든다.
 *                창고 재고(WH) · SO 예약 재고 · PLANT 재고 · 활성화 재고(FOR) · 해상 재고(INT) 를
 *                모아 INCOTERMS 와 Project Code 를 보정한 뒤, 자재 입고 예정(MC) ·
 *                재고 보정(Workbench) · TRAY 제약 정보를 더해
 *                SCP_OPT_ENG_INCOMING_STOCK 테이블에 적재한다.
 *                Hold 재고는 룩업(SCP_OPT_ENG_GM_RELEASE_HOLD) 의 일수만큼 가용일자를 뒤로 민다.
 *
 *                MSSQL 임시테이블 / 테이블변수 -> Oracle GTT (기존 GTT 재사용)
 *                  @MAT_CONST_TEMP  -> GT_OPT_ENG_GMIS_MAT
 *                  @OCV_EXCEPT_LIST -> GT_OPT_ENG_GMIS_OCV
 *                  @CELL_PROD_SITE  -> GT_OPT_ENG_GMIS_CPS
 *                  @DM_TEMP         -> GT_OPT_ENG_GMIS_DM
 *                  #SCP_INVENTORY_I -> GT_OPT_ENG_GMIS_INV
 *                  #SCP_INTRANSIT_I -> GT_OPT_ENG_GMIS_INT
 *                  #DEMAND_GROUP_T  -> GT_OPT_ENG_GMIS_DG
 *                  #CP_INFO         -> GT_OPT_ENG_GMIS_CP
 *                  #INVENTORY_ADJUST-> GT_OPT_ENG_GMIS_ADJ
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.07.07     Philsu Park Initial Release
 * 2026.11.09     JCH         MSSQL -> Oracle 전환
 */
    V_PROGRAM_NAME         VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_GM_INPUT_INCOMING_STOCK';
    V_PLAN_ID              VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT         VARCHAR2(1000 CHAR);
    V_DETAIL_DATE          DATE;

    /* Set Param for Biz */
    V_DIVISION_ID          VARCHAR2(20 CHAR)  := P_DIVISION_ID;
    V_GROUP_ID             VARCHAR2(20 CHAR)  := P_GROUP_ID;
    V_P_PLAN_NAME          VARCHAR2(8 CHAR);
    V_P_PLAN_TYPE          VARCHAR2(4000 CHAR);
    V_P_SEQ                VARCHAR2(4000 CHAR);
    V_P_MODELING_ID        VARCHAR2(4000 CHAR);
    V_CUTOFF_DAY           VARCHAR2(8 CHAR);
    V_D_CUTOFF_DAY         DATE;
    V_DEMAND_CUTOFF_DAY    VARCHAR2(8 CHAR);
    V_D_PLAN_NAME          DATE;
    V_MAX_TUESDAY          VARCHAR2(8 CHAR);
BEGIN
    /* 2025.07.07 Philsu Park: Initial Release */
    /* Procedure 기본조건.PA */

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);
    COMMIT;     /* 시작 로그 보존 — 핸들러 ROLLBACK 에 지워지지 않게 */

    /* Transaction (START) */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    BEGIN

        ------------------------------------------------------------------------
        -- GTT 초기화 (TRUNCATE 대신 DELETE — 암묵적 커밋으로 롤백이 깨지지 않게)
        ------------------------------------------------------------------------
        DELETE FROM GT_OPT_ENG_GMIS_MAT;
        DELETE FROM GT_OPT_ENG_GMIS_OCV;
        DELETE FROM GT_OPT_ENG_GMIS_CPS;
        DELETE FROM GT_OPT_ENG_GMIS_INV;
        DELETE FROM GT_OPT_ENG_GMIS_INT;
        DELETE FROM GT_OPT_ENG_GMIS_CP;
        DELETE FROM GT_OPT_ENG_GMIS_ADJ;
        DELETE FROM GT_OPT_ENG_GMIS_DM;
        DELETE FROM GT_OPT_ENG_GMIS_DG;

        ------------------------------------------------------------------------
        -- Get Param Info
        ------------------------------------------------------------------------
        BEGIN
            SELECT  ATTRIBUTE1
                  , ATTRIBUTE2
              INTO  V_DIVISION_ID
                  , V_GROUP_ID
              FROM  SCP_OPT_ENG_PLAN_MASTER_SN
             WHERE  PLAN_ID = V_PLAN_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;   /* 원문 대입형 SELECT : 대상이 없으면 파라미터 값을 그대로 쓴다 */
            WHEN TOO_MANY_ROWS THEN NULL;
        END;
        ------------------------------------------------------------------------
        SELECT  MAX(BASIS_YYYYMMDD)
          INTO  V_MAX_TUESDAY
          FROM  SCM_SYS_CALENDAR_M
         WHERE  BASIS_YYYYMMDD <= P_PLAN_START_YYYYMMDD
           AND  DAYOFWEEK        = 'TUE';

        BEGIN
            SELECT  MODELING_ID
              INTO  V_P_MODELING_ID
              FROM  SCM_MST_MODELING
             WHERE  PLAN_CYCLE  = 'WEEKLY'
               AND  DIVISION_ID = V_DIVISION_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
            WHEN TOO_MANY_ROWS THEN NULL;
        END;

        V_P_PLAN_NAME  := P_PLAN_START_YYYYMMDD;
        V_D_PLAN_NAME  := TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD');

        V_CUTOFF_DAY   := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');
        V_D_CUTOFF_DAY := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');

        SELECT  MAX(P.CUTOFF_YYYYMMDD)
          INTO  V_DEMAND_CUTOFF_DAY
          FROM  DM_PLN_NET_DEMAND P
         WHERE  P.DIVISION_ID      = V_DIVISION_ID
           AND  P.CUTOFF_YYYYMMDD <= P_PLAN_START_YYYYMMDD
           AND  P.CUTOFF_YYYYMMDD >= TO_CHAR(TO_DATE(V_MAX_TUESDAY, 'YYYYMMDD') - 28, 'YYYYMMDD');

        ------------------------------------------------------------------------
        /* 자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용 */
        ------------------------------------------------------------------------
        --SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
        --FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        --WHERE  PLAN_ID = @V_PLAN_ID

        -- START 2025.11.19 jongykim2: Schelduled Reciept Information
        INSERT INTO GT_OPT_ENG_GMIS_MAT
        (
            MAT_ID
          , EFF_END_DATE
        )
        SELECT  LU.ITEM_ID_CHILD                                                    AS MAT_ID
              , TO_CHAR(TO_DATE(MAX(LU.TO_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD')   AS EFF_END_DATE
          FROM  SCP_OPMZ_VIRTUAL_BOM LU
                INNER JOIN SCP_OPMZ_PLAN_GR_M PG
                    ON  LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
         WHERE  LU.DIVISION_ID       = V_DIVISION_ID
           AND  PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
           AND  LU.VALID_YN          = 'Y'
           AND  PG.VALID_YN          = 'Y'
         GROUP BY LU.ITEM_ID_CHILD;
        -- END 2025.11.19 jongykim2: Schelduled Reciept Information
        /* -- BLOCKED 2025.11.19 jongykim2
        SELECT   ATTRIBUTE1 AS MAT_ID
                ,CONVERT(NVARCHAR(8),DATEADD(DAY,1,MAX(ATTRIBUTE3)),112) AS EFF_END_DATE
        FROM     SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        WHERE    LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_PACKING_MATERIAL'
        AND      LU.VALID_YN    = 'Y'
        AND      LU.SEGMENT2    = @V_DIVISION_ID
        AND      LU.SEGMENT3    = @V_GROUP_ID
        GROUP BY ATTRIBUTE1
        */
        ------------------------------------------------------------------------
        /* 2nd OCV에 활용된 SUB MDLE 재고는 제외하기 위해서 */
        ------------------------------------------------------------------------
        INSERT INTO GT_OPT_ENG_GMIS_OCV
        (
            SCM_SITE_ID
          , ITEM_ID
        )
        SELECT  MS.SCM_SITE_ID
              , BOM.CHILD_ITEM_ID
          FROM  SCM_MST_BOM_SN_V BOM
                INNER JOIN SCM_MST_SITE MS
                    ON  BOM.PLANT_ID = MS.PLANT_ID
                INNER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                    ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                    AND LU.VALID_YN    = 'Y'
                    AND LU.SEGMENT2    = V_DIVISION_ID
                    AND LU.SEGMENT3    = V_GROUP_ID
                    AND LU.ATTRIBUTE1  = 'B'
         WHERE  1=1
           AND  MS.SCM_SITE_ID     = LU.SEGMENT4
           AND  BOM.PARENT_ITEM_ID = LU.SEGMENT5
         GROUP BY MS.SCM_SITE_ID, BOM.CHILD_ITEM_ID;

        ------------------------------------------------------------------------
        /* 셀 생산지 버퍼 추가 */
        ------------------------------------------------------------------------
        INSERT INTO GT_OPT_ENG_GMIS_CPS
        (
            SALES_SITE_ID
          , ITEM_ID
          , OPERATION_GROUP
        )
        SELECT  LU.SEGMENT3            AS SALES_SITE_ID
              , LU.SEGMENT4            AS ITEM_ID
              /* 원문 '_'+FI.OPERATION_GROUP : 뒤에서 조인 키로 쓰이므로 MSSQL 의 NULL 전파를 살린다 */
              , CASE WHEN FI.OPERATION_GROUP IS NULL THEN NULL
                     ELSE '_' || FI.OPERATION_GROUP
                END                    AS OPERATION_GROUP
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                INNER JOIN SCP_MST_FINAL_ITEM FI
                    ON  LU.SEGMENT1 = FI.DIVISION_ID
                    AND LU.SEGMENT4 = FI.ITEM_ID
         WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND  LU.SEGMENT1    = V_DIVISION_ID
           AND  LU.SEGMENT2    = V_GROUP_ID;
        ------------------------------------------------------------------------
        --테스트를 위해 25년07주차로 고정
        ------------------------------------------------------------------------
        --SELECT @P_PLAN_NAME         = '20250210'; -- 당주 월요일 YYYYMMDD
        --SELECT @V_CUTOFF_DAY        = '20250209'; -- 지난주 일요일 YYYYMMDD
        --SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
        --SELECT @MAX_TUESDAY         = '20250211'
        --SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD

        ------------------------------------------------------------------------
        -- Data Insert Start
        ------------------------------------------------------------------------

        --------------------------------------------------------
        -- 재고 / 해상재고 INPUT 생성 전 중간 정보 생성 PROC 참고
        --     PR_SCP_ENG_IN_PRE_SET_INVENTORY
        --     PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS
        --------------------------------------------------------

        --------------------------------------------------------
        -- 1. 창고 재고 : WH
        --------------------------------------------------------
        -- 1.1 SALES 재고
        INSERT INTO GT_OPT_ENG_GMIS_INV
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
          , OPERATION_ID
          , LINE_ID
          , B_DEGAS_YN
          , FLAG
        )
        SELECT --DISTINCT
                A.DIVISION_ID   AS DIVISION_ID
              , A.SCM_SITE_ID   AS SCM_SITE_ID
              , '-'             AS INCOTERMS /* 뒤에서 별도 UPDATE */
              , A.STOCK_TYPE
              , A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              , CASE WHEN A.WIPHOLD_YN IS NULL                                  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN A.WIPHOLD_YN = 'N'                                    THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                     ELSE                                                            TRUNC(A.AVAILABLE_DATE)
                END AS AVAILABLE_DATE
              , A.SCM_QTY AS QTY /* SCP 사용 QTY */
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                     ELSE A.WIPHOLD_YN
                END AS WIPHOLD_YN
              , B.SITE_TYPE
              , '-'                        AS LOCATION_CODE /* PLANT 재고 구분용 정보 */
              , '-'                        AS PROJECT_CODE  /* 뒤에서 별도 UPDATE */
              , NVL(MSP.SCM_SITE_ID, '')   AS CELL_PROD_SITE_ID
              , NULL                       AS OPERATION_ID
              , NULL                       AS LINE_ID
              , NULL                       AS B_DEGAS_YN
              , 'SALES'                    AS FLAG
          FROM  SCM_DNM_STOCK      A
                -- SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음
                -- ,(SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                --   FROM   SCM_MST_SITE  WITH(NOLOCK)
                --   WHERE  1=1
                --   AND    SITE_TYPE        = 'SALES'
                --  ) B
                --소형 생산지 구분을 위한 분리
                INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                            FROM   SCM_MST_SITE
                            WHERE  1=1
                            AND    SITE_TYPE        = 'SALES'
                           ) B
                    ON  A.DIVISION_ID = B.DIVISION_ID
                    AND A.SCM_SITE_ID = B.SCM_SITE_ID
                --INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                --    ON A.PLANT_ID = MS.PLANT_ID
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_OCV OCV
                    ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                    AND A.MES_ITEM_ID = OCV.ITEM_ID
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_CPS CPS
                    ON  1=1
                    AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
                    AND A.ITEM_ID     = CPS.ITEM_ID
                LEFT OUTER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                 FROM   SCM_MST_SITE
                                 WHERE  1=1
                                 AND    PLANT_ID IS NOT NULL
                                ) MSP
                    ON  1=1
                    AND A.DIVISION_ID = MSP.DIVISION_ID
                    /* 원문 A.PLANT_ID+CPS.OPERATION_GROUP : CPS 미매칭 시 MSSQL 은 NULL 이 되어 조인이 성립하지 않는다 */
                    AND CASE WHEN A.PLANT_ID IS NULL OR CPS.OPERATION_GROUP IS NULL THEN NULL
                             ELSE A.PLANT_ID || CPS.OPERATION_GROUP
                        END = MSP.SCM_SITE_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE      = V_CUTOFF_DAY
           AND  A.DIVISION_ID      = V_DIVISION_ID
           AND  OCV.ITEM_ID        IS NULL
           -- 소형은 CEll Biz 용 Demand 만 처리
           AND ((A.DIVISION_ID  = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                OR  (A.DIVISION_ID <> '40' )
               )
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND    A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
        --                     FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                     WHERE   PLAN_ID = @V_PLAN_ID
        --                     )
           AND (    (A.DIVISION_ID = '40' AND   B.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                              FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                              WHERE   PLAN_ID = V_PLAN_ID
                                                                              )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                             FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                             WHERE   PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* 원문 #SCP_INVENTORY_I 의 ALTER TABLE ALTER COLUMN 6건은 GTT 컬럼 정의로 대체 */

        -- 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리
        INSERT INTO GT_OPT_ENG_GMIS_INV
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
          , OPERATION_ID
          , LINE_ID
          , B_DEGAS_YN
          , FLAG
        )
        SELECT --DISTINCT
                A.DIVISION_ID      AS DIVISION_ID
              , A.TO_SCM_SITE_ID   AS SCM_SITE_ID
              , '-'                AS INCOTERMS /* 뒤에서 별도 UPDATE */
              , 'SO'      AS STOCK_TYPE
              , A.ITEM_ID AS ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전
              -- 엔진 오류로 Plan 구간 안으로 처리
              --,CONVERT(DATETIME, @V_CUTOFF_DAY) AS AVAILABLE_DATE
              , TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') AS AVAILABLE_DATE
              , A.DELIVERY_QTY AS QTY
              , 'N'       AS WIPHOLD_YN
              , B.SITE_TYPE
              , '-'             AS LOCATION_CODE /* PLANT 재고 구분용 정보 */
              , NVL(A.PROJECT_CODE, '-')                                          AS PROJECT_CODE /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
              , CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END  AS CELL_PROD_SITE_ID
              , NULL            AS OPERATION_ID
              , NULL            AS LINE_ID
              , NULL            AS B_DEGAS_YN
              , 'SALES'         AS FLAG
          FROM  SCM_DNM_INTRANSIT_C  A
                INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                            FROM   SCM_MST_SITE
                            WHERE  1=1
                            AND    SITE_TYPE        = 'SALES'
                           ) B
                    ON  1=1
                    AND A.DIVISION_ID    = B.DIVISION_ID
                    AND A.TO_SCM_SITE_ID = B.SCM_SITE_ID
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_CPS CPS
                    ON  1=1
                    AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                    AND A.ITEM_ID        = CPS.ITEM_ID
         WHERE  1 = 1
           AND  A.DIVISION_ID      = V_DIVISION_ID
           AND  A.RESULT_DATE      = V_CUTOFF_DAY
           -- SO Reserve Stock : result_type = 'B' 는 재고로 처리
           AND  A.RESULT_TYPE      = 'B'
           AND  A.VALID_YN         = 'Y'   -- 해상재고
           -- 소형은 CEll Biz 용 Demand 만 처리
           AND ((A.DIVISION_ID  = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                OR  (A.DIVISION_ID <> '40' )
               )
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                   )
        --소형 생산지 구분을 위한 분리
           AND (    (A.DIVISION_ID = '40' AND   A.FROM_SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                   WHERE   PLAN_ID = V_PLAN_ID
                                                                                   )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                             FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                             WHERE   PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        -- 1.3 SALES 재고 : INCOTERMS UPDATE
        MERGE INTO GT_OPT_ENG_GMIS_INV A
        USING (
               SELECT  IA.SCM_SITE_ID
                     , IA.ITEM_ID
                     , NVL(NVL(MAX(IB.MAX_INCOTERMS), MAX(IC.MAX_INCOTERMS)), 'DAP') AS MAX_INCOTERMS /* DEMAND 없는 경우 DAP 처리 */
                 FROM  GT_OPT_ENG_GMIS_INV IA
                       LEFT JOIN ( SELECT  AA.SCM_SITE_ID, AA.ITEM_ID
                                           --  VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함)
                                         , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP'
                                                    ELSE AA.INCOTERMS
                                               END ) MAX_INCOTERMS
                                     FROM  DM_PLN_NET_DEMAND AA
                                           INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                       FROM   DM_PLN_NET_DEMAND
                                                       WHERE  DIVISION_ID     = V_DIVISION_ID
                                                       AND    CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY -- V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                                       GROUP BY  SCM_SITE_ID
                                                      ) BB
                                               ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                                               AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                                               AND AA.DIVISION_ID     = V_DIVISION_ID
                                               AND AA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                           LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                       FROM   SCM_MST_SITE
                                                       WHERE  DIVISION_ID = V_DIVISION_ID
                                                       AND    VMI_YN      = 'Y') CC
                                               ON  AA.DIVISION_ID = CC.DIVISION_ID
                                               AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
                                    GROUP BY AA.SCM_SITE_ID, AA.ITEM_ID
                                 ) IB
                           ON  IA.SCM_SITE_ID = IB.SCM_SITE_ID
                           AND IA.ITEM_ID     = IB.ITEM_ID
                       LEFT JOIN ( SELECT  AA.SCM_SITE_ID
                                           --  VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함)
                                         , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP'
                                                    ELSE AA.INCOTERMS
                                               END ) MAX_INCOTERMS
                                     FROM  DM_PLN_NET_DEMAND AA
                                           INNER JOIN (SELECT SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                       FROM   DM_PLN_NET_DEMAND
                                                       WHERE  DIVISION_ID     = V_DIVISION_ID
                                                       AND    CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY -- V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD)
                                                       GROUP BY  SCM_SITE_ID
                                                      ) BB
                                               ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                                               AND AA.VERSION_NO      = BB.MAX_VERSION_NO
                                               AND AA.DIVISION_ID     = V_DIVISION_ID
                                               AND AA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                           LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                       FROM   SCM_MST_SITE
                                                       WHERE  DIVISION_ID = V_DIVISION_ID
                                                       AND    VMI_YN      = 'Y') CC
                                               ON  AA.DIVISION_ID = CC.DIVISION_ID
                                               AND AA.SCM_SITE_ID = CC.SCM_SITE_ID
                                    GROUP BY AA.SCM_SITE_ID
                                 ) IC
                           ON  IA.SCM_SITE_ID = IC.SCM_SITE_ID
                WHERE  1=1
                  AND  IA.SITE_TYPE       = 'SALES'
                GROUP BY IA.SCM_SITE_ID, IA.ITEM_ID
              ) SA
           ON (    A.SCM_SITE_ID = SA.SCM_SITE_ID
               AND A.ITEM_ID     = SA.ITEM_ID
               AND A.SITE_TYPE   = 'SALES'
              )
        WHEN MATCHED THEN
            UPDATE SET A.INCOTERMS = SA.MAX_INCOTERMS;

        -- 1.4 PLANT 재고
        INSERT INTO GT_OPT_ENG_GMIS_INV
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
          , OPERATION_ID
          , LINE_ID
          , B_DEGAS_YN
          , FLAG
        )
        SELECT  A.DIVISION_ID   AS DIVISION_ID
              , A.SCM_SITE_ID   AS SCM_SITE_ID
              , '-'             AS INCOTERMS
              , A.STOCK_TYPE
              , A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              , CASE WHEN A.WIPHOLD_YN IS NULL                                  THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN A.WIPHOLD_YN = 'N'                                    THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                     ELSE                                                            TRUNC(A.AVAILABLE_DATE)
                END AS AVAILABLE_DATE
              , A.SCM_QTY AS QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                     ELSE A.WIPHOLD_YN
                END AS WIPHOLD_YN
              , B.SITE_TYPE
              , CASE WHEN OP.LOCATION_CODE IS NOT NULL OR ST.LOCATION_CODE IS NOT NULL THEN 'ASSY'
                     ELSE '-'
                END            AS LOCATION_CODE /* PLANT 재고 구분용 정보 */
              , ''             AS PROJECT_CODE
              , ''             AS CELL_PROD_SITE_ID
              , A.OPERATION_ID AS OPERATION_ID
              , A.LINE_ID      AS LINE_ID
              , NULL           AS B_DEGAS_YN
              , 'PLANT' AS FLAG
          FROM  SCM_DNM_STOCK      A
                INNER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                            FROM   SCM_MST_SITE
                            WHERE  1=1
                            AND    DIVISION_ID      = V_DIVISION_ID
                            AND    SITE_TYPE        = 'PLANT'
                            --AND    OPERATION_GROUP IN ('A', 'P')
                            AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      -- 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외
                                 OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                )
                           ) B
                    ON   A.DIVISION_ID      = B.DIVISION_ID
                    AND  A.SCM_SITE_ID      = B.SCM_SITE_ID

                LEFT JOIN (  SELECT DISTINCT
                                    A.OPERATION_ID
                                 ,  A.LOCATION_CODE
                                 ,  A.SCM_SITE_ID
                             FROM   SCM_MST_LOCATION A
                                    INNER JOIN (SELECT SCM_SITE_ID
                                                FROM   SCM_MST_SITE
                                                WHERE  DIVISION_ID     = V_DIVISION_ID
                                                AND    VALID_YN        = 'Y'
                                                AND    OPERATION_GROUP IN ( 'A' )
                                                ) B
                                    ON A.SCM_SITE_ID = B.SCM_SITE_ID
                             WHERE  A.DIVISION_ID = V_DIVISION_ID --'81'
                             AND    A.VALID_YN    = 'Y'
                             AND    A.LOCATION_CODE = 'PACKAGING' --활성화 전 재고
                             AND    (A.OPERATION_ID IS NOT NULL) /* 원문 : operation_id IS NOT NULL AND operation_id <> '' — Oracle 은 '' 가 NULL 이라 뒤 조건이 상시 false */
                          )  OP -- 셀의 operation_id 별 사용대상 조회
                    ON   A.OPERATION_ID = OP.OPERATION_ID
                    AND  A.SCM_SITE_ID  = OP.SCM_SITE_ID

                LEFT JOIN (  SELECT DISTINCT
                                    A.STORAGE_ID
                                 ,  A.LOCATION_CODE
                                 ,  A.SCM_SITE_ID
                             FROM   SCM_MST_LOCATION A
                                    INNER JOIN (SELECT SCM_SITE_ID
                                                FROM   SCM_MST_SITE
                                                WHERE  DIVISION_ID     = V_DIVISION_ID
                                                AND    VALID_YN        = 'Y'
                                                AND    OPERATION_GROUP IN ( 'A' )
                                                ) B
                                    ON A.SCM_SITE_ID = B.SCM_SITE_ID
                             WHERE  A.DIVISION_ID = V_DIVISION_ID --'81'
                             AND    A.VALID_YN    = 'Y'
                             AND    A.LOCATION_CODE = 'PACKAGING' --활성화 전 재고
                             AND    (A.STORAGE_ID IS NOT NULL) /* 원문 : storage_id IS NOT NULL AND storage_id <> '' — Oracle 은 '' 가 NULL 이라 뒤 조건이 상시 false */
                          )  ST -- 셀의 storage_id 별 사용대상 조회
                    ON   A.STORAGE_ID   = ST.STORAGE_ID
                    AND  A.SCM_SITE_ID  = ST.SCM_SITE_ID
                --소형 생산지 구분을 위한 분리
                --INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                --    ON A.PLANT_ID = MS.PLANT_ID
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_OCV OCV
                    ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                    AND A.MES_ITEM_ID = OCV.ITEM_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE      = V_CUTOFF_DAY
           AND  A.DIVISION_ID      = V_DIVISION_ID
           AND  OCV.ITEM_ID        IS NULL
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
          --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
          --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
          --                   WHERE   PLAN_ID = @V_PLAN_ID
          --                   )
        --소형 생산지 구분을 위한 분리
           AND (    (A.DIVISION_ID = '40' AND   B.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                              FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                              WHERE   PLAN_ID = V_PLAN_ID
                                                                              )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                             FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                             WHERE   PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        --------------------------------------------------------
        -- 2. 활성화 재고 : FOR
        -- 2026.05.08 Minyong Lee : 활성화 재고 뷰 중복 스캔 제거 (쿼리 수행 시간 단축)
        --------------------------------------------------------
        INSERT INTO GT_OPT_ENG_GMIS_INV
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
          , OPERATION_ID
          , LINE_ID
          , B_DEGAS_YN
          , FLAG
        )
        WITH BASE_STOCK AS (
            SELECT  SA.*
                  , MAX(SA.CUTOFF_DATE) OVER (PARTITION BY SA.DIVISION_ID, SA.SITE_ID) AS MAX_CUTOFF_DATE
              FROM  SCM_DNM_STOCK_AGING_V SA
             WHERE  SA.DIVISION_ID = V_DIVISION_ID
               AND  SA.CUTOFF_DATE >  V_D_CUTOFF_DAY - 7  -- C의 조건을 여기서 한번에 처리
               AND  SA.CUTOFF_DATE <= V_D_CUTOFF_DAY
        )
        SELECT  A.DIVISION_ID   AS DIVISION_ID
              , A.SCM_SITE_ID   AS SCM_SITE_ID
              , '-'             AS INCOTERMS
              , 'FOR'           AS STOCK_TYPE
              , A.ITEM_ID
              -- Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              , CASE WHEN A.BEFORE_DEGAS != 'Y' AND TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD')  < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')
                     WHEN A.BEFORE_DEGAS  = 'Y' AND TO_CHAR(A.DEGAS_END_DATE, 'YYYYMMDD') < V_P_PLAN_NAME THEN TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD') /* BEFORE DEGAS인 경우 DEGAS_END_DATE를 찍어줌 */
                     WHEN A.BEFORE_DEGAS  = 'Y' THEN TRUNC(A.DEGAS_END_DATE)
                     ELSE A.AVAILABLE_DATE
                END  AS AVAILABLE_DATE
              , A.QTY  AS QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                     ELSE A.WIPHOLD_YN
                END AS WIPHOLD_YN
              , 'PLANT' AS SITE_TYPE
              , '-'             AS LOCATION_CODE /* PLANT 재고 구분용 정보 */
              , ''              AS PROJECT_CODE
              , ''              AS CELL_PROD_SITE_ID
              , NULL            AS OPERATION_ID
              , A.LINE_ID       AS LINE_ID
              , A.BEFORE_DEGAS  AS B_DEGAS_YN
              , 'PLANT'         AS FLAG
          FROM  (
                 SELECT  IA.*
                   FROM  BASE_STOCK IA
                  WHERE  IA.CUTOFF_DATE = IA.MAX_CUTOFF_DATE
                    AND  IA.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                        WHERE   PLAN_ID = V_PLAN_ID
                                        )
                ) A
                -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경
                LEFT JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                            FROM   SCM_MST_SITE
                            WHERE  1=1
                            AND    DIVISION_ID   = V_DIVISION_ID
                            AND    SITE_TYPE     = 'PLANT'
                            AND    NVL(OSP_YN, 'N')  = 'N' --20180822 추가
                          ) B
                    ON   A.SCM_SITE_ID   = B.SCM_SITE_ID
                LEFT OUTER JOIN SCP_MST_FORMATION_V MF
                    ON  A.DIVISION_ID = MF.DIVISION_ID
                    AND A.SCM_SITE_ID = MF.PLANT_SITE_ID
                    AND A.ITEM_ID     = MF.ITEM_ID
         WHERE  B.DIVISION_ID IS NOT NULL -- 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                   )
        ;

        --------------------------------------------------------
        -- 3. 해상 재고 : INT
        --------------------------------------------------------
        -- 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
        INSERT INTO GT_OPT_ENG_GMIS_INT
        (
            DIVISION_ID
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
          , FLAG
        )
        SELECT  A.DIVISION_ID  AS DIVISION_ID
              , A.ITEM_ID
              , A.TO_SCM_SITE_ID   AS TO_SCM_SITE_ID
              , A.FINAL_INCOTERMS  AS INCOTERMS
                /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
              , CASE WHEN A.ETA_DATE < V_P_PLAN_NAME THEN V_P_PLAN_NAME
                     ELSE A.ETA_DATE
                END  AS ETA_DATE
              , A.DELIVERY_QTY
              --,IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
              , CASE WHEN TS.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-' /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                     WHEN TS.SITE_TYPE = 'SALES' THEN NVL(A.PROJECT_CODE, '-')
                     WHEN TS.SITE_TYPE = 'PLANT' THEN '' /* Plant 도착은 NULL 처리 */
                     ELSE NVL(A.PROJECT_CODE, '-')
                END AS PROJECT_CODE /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
              , CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END AS CELL_PROD_SITE_ID
              , NULL            AS OPERATION_ID
              , NULL            AS LINE_ID
              , NULL            AS B_DEGAS_YN
              , TS.SITE_TYPE AS FLAG
          FROM  SCM_DNM_INTRANSIT_V  A
                INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V) FI
                    ON   A.DIVISION_ID          = FI.DIVISION_ID
                    AND  A.ITEM_ID              = FI.ITEM_ID
                    AND  FI.OPERATION_GROUP_ID <> 'E' -- 전극 모델은 제외

                INNER JOIN (SELECT DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                            FROM   SCM_MST_SITE
                            WHERE  DIVISION_ID = V_DIVISION_ID
                            AND    SITE_TYPE   = 'PLANT'
                            AND    OPERATION_GROUP IN ('A', 'P') -- FROM_SITE 가 전극인 정보 제외
                            AND    VALID_YN    = 'Y'
                           )  FS
                    ON   A.DIVISION_ID          = FS.DIVISION_ID
                    AND  A.FROM_SCM_SITE_ID     = FS.SCM_SITE_ID
                    AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' )      -- 소형은 CEll Biz 용 Demand 만 처리
                         OR  (FS.DIVISION_ID <> '40' )
                        )

                INNER JOIN SCM_MST_SITE TS
                    ON  A.DIVISION_ID    = TS.DIVISION_ID
                    AND A.TO_SCM_SITE_ID = TS.SCM_SITE_ID
                    --AND TS.SITE_TYPE      = 'SALES'
                    AND TS.VALID_YN       = 'Y'
                    AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE = 'SALES' )      -- 소형은 CEll Biz 용 Demand 만 처리
                         OR  (TS.DIVISION_ID <> '40' )
                        )
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_CPS CPS
                    ON  1=1
                    AND A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                    AND A.ITEM_ID        = CPS.ITEM_ID
         WHERE  1=1
           AND  A.DIVISION_ID   = V_DIVISION_ID
           AND  A.RESULT_DATE   = V_CUTOFF_DAY
           AND  A.RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                 )
        --소형 생산지 구분을 위한 분리
           AND (    (A.DIVISION_ID = '40' AND   A.FROM_SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                   WHERE   PLAN_ID = V_PLAN_ID
                                                                                   )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                             FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                             WHERE   PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* 원문 #SCP_INTRANSIT_I 의 ALTER TABLE ALTER COLUMN 4건은 GTT 컬럼 정의로 대체 */

        -- 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
        --    - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함
        INSERT INTO GT_OPT_ENG_GMIS_INT
        (
            DIVISION_ID
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
          , FLAG
        )
        SELECT  A.DIVISION_ID
              , A.ITEM_ID
              , MS.SCM_SITE_ID              AS TO_SCM_SITE_ID
              , 'DAP'                       AS INCOTERMS -- VMI 임
              -- 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청
              , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')  AS ETA_DATE -- PLAN 시작일자로 처리
              , NVL(A.SCM_QTY, 0)           AS DELIVERY_QTY
              , '-'                         AS PROJECT_CODE
              , NVL(MSP.SCM_SITE_ID, '')    AS CELL_PROD_SITE_ID
              , NULL                        AS OPERATION_ID
              , NULL                        AS LINE_ID
              , NULL                        AS B_DEGAS_YN
              , 'SALES'                     AS FLAG
          FROM  SCM_DNM_STOCK  A
                INNER JOIN SCM_MST_VMI_INT_SLOC MS
                    ON    A.DIVISION_ID = MS.DIVISION_ID
                    AND   A.PLANT_ID    = MS.PLANT_ID
                    AND   A.STORAGE_ID  = MS.STORAGE_ID
                    AND   MS.VALID_YN   = 'Y'
                --소형 생산지 구분을 위한 분리
                INNER JOIN SCM_MST_SITE MSS
                    ON A.PLANT_ID = MSS.PLANT_ID
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_OCV OCV
                    ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                    AND A.MES_ITEM_ID = OCV.ITEM_ID
                LEFT OUTER JOIN GT_OPT_ENG_GMIS_CPS CPS
                    ON  1=1
                    AND A.SCM_SITE_ID = CPS.SALES_SITE_ID
                    AND A.ITEM_ID     = CPS.ITEM_ID
                LEFT OUTER JOIN (SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                 FROM   SCM_MST_SITE
                                 WHERE  1=1
                                 AND    PLANT_ID IS NOT NULL
                                ) MSP
                    ON  1=1
                    AND A.DIVISION_ID = MSP.DIVISION_ID
                    /* 원문 A.PLANT_ID+CPS.OPERATION_GROUP : CPS 미매칭 시 MSSQL 은 NULL 이 되어 조인이 성립하지 않는다 */
                    AND CASE WHEN A.PLANT_ID IS NULL OR CPS.OPERATION_GROUP IS NULL THEN NULL
                             ELSE A.PLANT_ID || CPS.OPERATION_GROUP
                        END = MSP.SCM_SITE_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE      = V_CUTOFF_DAY
           AND  A.DIVISION_ID      = V_DIVISION_ID
           AND  OCV.ITEM_ID        IS NULL
           -- 소형은 CEll Biz 용 Demand 만 처리
           AND ((A.DIVISION_ID  = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                OR  (A.DIVISION_ID <> '40' )
               )
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                   )
        --소형 생산지 구분을 위한 분리
           AND (    (A.DIVISION_ID = '40' AND   MSS.SCM_SITE_ID || A.ITEM_ID IN (SELECT DISTINCT SCM_SITE_ID || ITEM_ID
                                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                WHERE   PLAN_ID = V_PLAN_ID
                                                                                )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                             FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                             WHERE   PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        --------------------------------------------------------
        -- UPDATE PROJECT
        --------------------------------------------------------
            --------------------------------------------------------
            -- INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준
            --------------------------------------------------------
            INSERT INTO GT_OPT_ENG_GMIS_DM
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
              FROM (
                    SELECT  SITE_ID
                          , ITEM_ID
                          , INCOTERMS
                          , PROJECT_CODE
                          , ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,INCOTERMS,PROJECT_CODE ORDER BY MIN_DUE NULLS FIRST ) AS ROW_NUM
                      FROM (
                            SELECT  ATTRIBUTE1    AS SITE_ID
                                  , ATTRIBUTE2    AS ITEM_ID
                                  , ATTRIBUTE4    AS INCOTERMS
                                  , ATTRIBUTE5    AS PROJECT_CODE
                                  , MIN(DUE_DATE) AS MIN_DUE
                              FROM  SCP_OPT_ENG_DEMAND_SN
                             WHERE  PLAN_ID = V_PLAN_ID
                               AND  ATTRIBUTE5 IS NOT NULL --PROJECT_CODE
                               AND  ATTRIBUTE4 IS NOT NULL --INCOTERMS
                             GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE4,ATTRIBUTE5
                           ) DM
                   ) RM
             WHERE ROW_NUM = 1
            UNION ALL
            SELECT  SITE_ID
                  , ITEM_ID
                  , INCOTERMS
                  , PROJECT_CODE
              FROM (
                    SELECT  SITE_ID
                          , ITEM_ID
                          , INCOTERMS
                          , PROJECT_CODE
                          , ROW_NUMBER() OVER( PARTITION BY SITE_ID,ITEM_ID,PROJECT_CODE ORDER BY MIN_DUE NULLS FIRST ) AS ROW_NUM
                      FROM (
                            SELECT  ATTRIBUTE1    AS SITE_ID
                                  , ATTRIBUTE2    AS ITEM_ID
                                  , NULL          AS INCOTERMS
                                  , ATTRIBUTE5    AS PROJECT_CODE
                                  , MIN(DUE_DATE) AS MIN_DUE
                              FROM  SCP_OPT_ENG_DEMAND_SN
                             WHERE  PLAN_ID = V_PLAN_ID
                               AND  ATTRIBUTE5 IS NOT NULL
                               AND  ATTRIBUTE4 IS NULL
                             GROUP BY ATTRIBUTE1,ATTRIBUTE2,ATTRIBUTE5
                           ) DM
                   ) RM
             WHERE ROW_NUM = 1;

            --------------------------------------------------------
            -- #SCP_INVENTORY_I 프로젝트 UPDATE
            --------------------------------------------------------
            -- START 2025-12-15 jongykim2: Demand Group Master
            INSERT INTO GT_OPT_ENG_GMIS_DG
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
                        ON     T2.DIVISION_ID = T.DIVISION_ID
                        AND    T2.GROUP_ID = T.GROUP_ID
             WHERE  1 = 1
               AND  T.DIVISION_ID = V_DIVISION_ID
               AND  T.VALID_YN = 'Y'
               AND  NVL(T.ATTRIBUTE1, 'N') <> 'Y'
               AND  T2.VALID_YN = 'Y'
            ;
            -- END 2025-12-15 jongykim2:
            MERGE INTO GT_OPT_ENG_GMIS_INV A
            USING (
                   SELECT  IA.DIVISION_ID
                         , IA.SCM_SITE_ID
                         , IA.INCOTERMS
                         , IA.STOCK_TYPE
                         , IA.ITEM_ID
                         , IA.AVAILABLE_DATE
                         , IA.QTY
                         , IA.WIPHOLD_YN
                         , IA.SITE_TYPE
                         , IA.LOCATION_CODE
                         , MIN(DT.PROJECT_CODE) AS PROJECT_CODE /* 원문 UPDATE-FROM 은 다중 일치 시 임의의 한 행 : MIN 으로 좁힌다 */
                     FROM (
                           SELECT  INV.DIVISION_ID
                                 , INV.SCM_SITE_ID
                                 , INV.INCOTERMS
                                 , INV.STOCK_TYPE
                                 , INV.ITEM_ID
                                   --,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                 , CASE WHEN LU.ITEM_ID IS NULL THEN INV.ITEM_ID ELSE LU.DEMAND_GROUP END AS MDF_ITEM_ID
                                 , INV.AVAILABLE_DATE
                                 , INV.QTY
                                 , INV.WIPHOLD_YN
                                 , INV.SITE_TYPE
                                 , INV.LOCATION_CODE
                             FROM  GT_OPT_ENG_GMIS_INV INV
                                   /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                       ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                       AND LU.SEGMENT2 = @V_DIVISION_ID
                                       AND INV.ITEM_ID = LU.SEGMENT3
                                       AND LU.VALID_YN = 'Y'*/ -- blocked 2025-12-15 jongykim2
                                   -- Added 2025-12-15 jongykim2: Demand Group Master
                                   LEFT OUTER JOIN GT_OPT_ENG_GMIS_DG LU
                                       ON  INV.ITEM_ID = LU.ITEM_ID
                            WHERE  INV.FLAG         = 'SALES'
                              AND  INV.PROJECT_CODE = '-'
                              AND  INV.QTY > 0
                          ) IA
                          INNER JOIN GT_OPT_ENG_GMIS_DM DT
                              ON  IA.SCM_SITE_ID  = DT.SITE_ID
                              AND IA.MDF_ITEM_ID  = DT.ITEM_ID
                              AND (   (IA.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                   OR (IA.INCOTERMS = DT.INCOTERMS)
                                   OR (IA.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                  )
                    GROUP BY IA.DIVISION_ID
                           , IA.SCM_SITE_ID
                           , IA.INCOTERMS
                           , IA.STOCK_TYPE
                           , IA.ITEM_ID
                           , IA.AVAILABLE_DATE
                           , IA.QTY
                           , IA.WIPHOLD_YN
                           , IA.SITE_TYPE
                           , IA.LOCATION_CODE
                  ) DJ
               ON (    A.DIVISION_ID    = DJ.DIVISION_ID
                   AND A.SCM_SITE_ID    = DJ.SCM_SITE_ID
                   AND A.INCOTERMS      = DJ.INCOTERMS
                   AND A.STOCK_TYPE     = DJ.STOCK_TYPE
                   AND A.ITEM_ID        = DJ.ITEM_ID
                   AND A.AVAILABLE_DATE = DJ.AVAILABLE_DATE
                   AND A.QTY            = DJ.QTY
                   AND A.WIPHOLD_YN     = DJ.WIPHOLD_YN
                   AND A.SITE_TYPE      = DJ.SITE_TYPE
                   AND A.LOCATION_CODE  = DJ.LOCATION_CODE
                  )
            WHEN MATCHED THEN
                UPDATE SET A.PROJECT_CODE = DJ.PROJECT_CODE;

            --------------------------------------------------------
            -- #SCP_INTRANSIT_I 프로젝트 UPDATE
            --------------------------------------------------------
            MERGE INTO GT_OPT_ENG_GMIS_INT A
            USING (
                   SELECT  IA.DIVISION_ID
                         , IA.ITEM_ID
                         , IA.TO_SCM_SITE_ID
                         , IA.INCOTERMS
                         , IA.ETA_DATE
                         , IA.DELIVERY_QTY
                         , IA.FLAG
                         , MIN(DT.PROJECT_CODE) AS PROJECT_CODE /* 원문 UPDATE-FROM 은 다중 일치 시 임의의 한 행 : MIN 으로 좁힌다 */
                     FROM (
                           SELECT  INV.DIVISION_ID
                                 , INV.ITEM_ID
                                   --,IIF(LU.SEGMENT3 IS NULL, INV.ITEM_ID, LU.SEGMENT4) AS MDF_ITEM_ID
                                 , CASE WHEN LU.ITEM_ID IS NULL THEN INV.ITEM_ID ELSE LU.DEMAND_GROUP END AS MDF_ITEM_ID
                                 , INV.TO_SCM_SITE_ID
                                 , INV.INCOTERMS
                                 , INV.ETA_DATE
                                 , INV.DELIVERY_QTY
                                 , INV.PROJECT_CODE
                                 , INV.FLAG
                             FROM  GT_OPT_ENG_GMIS_INT INV -- WHERE PROJECT_CODE = '-' AND FLAG ='SALES'
                                   /*LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
                                        ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND LU.SEGMENT2 = @V_DIVISION_ID
                                        AND INV.ITEM_ID = LU.SEGMENT3
                                        AND LU.VALID_YN = 'Y'*/ -- blocked 2025-12-15 jongykim2
                                   -- Added 2025-12-15 jongykim2: Demand Group Master
                                   LEFT OUTER JOIN GT_OPT_ENG_GMIS_DG LU
                                       ON  INV.ITEM_ID = LU.ITEM_ID
                            WHERE  INV.FLAG         = 'SALES'
                              AND  INV.PROJECT_CODE = '-'
                              AND  INV.DELIVERY_QTY > 0
                          ) IA
                          INNER JOIN GT_OPT_ENG_GMIS_DM DT
                              ON  IA.TO_SCM_SITE_ID = DT.SITE_ID
                              AND IA.MDF_ITEM_ID    = DT.ITEM_ID
                              AND (   (IA.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                   OR (IA.INCOTERMS = DT.INCOTERMS)
                                   OR (IA.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                  )
                    GROUP BY IA.DIVISION_ID
                           , IA.ITEM_ID
                           , IA.TO_SCM_SITE_ID
                           , IA.INCOTERMS
                           , IA.ETA_DATE
                           , IA.DELIVERY_QTY
                           , IA.FLAG
                  ) DJ
               ON (    A.DIVISION_ID    = DJ.DIVISION_ID
                   AND A.ITEM_ID        = DJ.ITEM_ID
                   AND A.TO_SCM_SITE_ID = DJ.TO_SCM_SITE_ID
                   AND A.INCOTERMS      = DJ.INCOTERMS
                   AND A.ETA_DATE       = DJ.ETA_DATE
                   AND A.DELIVERY_QTY   = DJ.DELIVERY_QTY
                   AND A.FLAG           = DJ.FLAG
                  )
            WHEN MATCHED THEN
                UPDATE SET A.PROJECT_CODE = DJ.PROJECT_CODE;

          -- CA별 CP 정보
        INSERT INTO GT_OPT_ENG_GMIS_CP
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
              , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                              , M.ITEM_ID_ASSY
                                              , M.PLANT_ID
                                       ORDER BY M.VALID_YN DESC NULLS LAST
                                              , M.ITEM_ID_PROD) PRIORITY_1ST
              , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                              , M.ITEM_ID_ASSY
                                       ORDER BY M.VALID_YN DESC NULLS LAST
                                              , M.ITEM_ID_PROD) PRIORITY_2ND
              , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
                                       ORDER BY M.VALID_YN DESC NULLS LAST
                                              , M.ITEM_ID_PROD) PRIORITY_3RD
          FROM  SCP_MST_CELL_PROD_ASSY_MAP M
         WHERE  1=1
           AND  M.VALID_YN = 'Y' ;

        --------------------------------------------------------
        -- 2025.09.23 Philsu Park: 재고 보정값 반영을 위한 TEMP Input.
        --------------------------------------------------------
        INSERT INTO GT_OPT_ENG_GMIS_ADJ
        (
            SCM_SITE_ID
          , ITEM_ID
          , STAGE_BUFFER
          , STAGE
          , EFFECTIVE_DATE
          , TYPE
          , QTY
          , INCOTERMS
          , PROJECT_CODE
        )
        SELECT    ADJ.SCM_SITE_ID
                , ADJ.ITEM_ID
                  /* 'XXX@' + LS.LINE_SIDE : LS 는 LEFT JOIN 이라 LINE_SIDE 가 NULL 이면 MSSQL 결과도 NULL 이다 */
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP'    THEN 'CHAR'
                        WHEN LM.OPERATION_ID IS NOT NULL                        THEN 'CHAR'
                        WHEN B.FLOW_ID = 'A9000'                                THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'ASSY@'    || LS.LINE_SIDE END
                        WHEN ITM.SCP_FLOW_ID = 'A8000'                          THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'STK@'     || LS.LINE_SIDE END
                        WHEN ADJ.BEFORE_DEGAS = 'Y'                             THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'B_DEGAS@' || LS.LINE_SIDE END
                        WHEN ADJ.BEFORE_DEGAS = 'N'                             THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'A_DEGAS@' || LS.LINE_SIDE END
                        ELSE '-' END    AS STAGE_BUFFER
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP'    THEN 'CHAR'
                        WHEN LM.OPERATION_ID IS NOT NULL                        THEN 'CHAR'
                        WHEN B.FLOW_ID = 'A9000'                                THEN 'ASSY'
                        WHEN ITM.SCP_FLOW_ID = 'A8000'                          THEN 'STK'
                        WHEN ADJ.BEFORE_DEGAS = 'Y'                             THEN 'B_DEGAS'
                        WHEN ADJ.BEFORE_DEGAS = 'N'                             THEN 'A_DEGAS'
                        ELSE '-' END    AS STAGE
                , ADJ.INV_DATE          AS EFFECTIVE_DATE
                , ADJ.STOCK_TYPE        AS TYPE
                , SUM(ADJ.CHG_QTY)      AS QTY
                , ADJ.INCOTERMS         AS INCOTERMS
                , ADJ.PROJECT_CODE      AS PROJECT_CODE
                -- , ADJ.LINE_ID         AS LINE_ID
                -- , ADJ.BEFORE_DEGAS    AS B_DEGAS_YN
                -- , 'ADJUST'            AS FLAG
                -- , ADJ.QTY
          FROM  SCP_OPMZ_INV_ADJ ADJ
                LEFT OUTER JOIN (
                                 SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                     --, *
                                 FROM   SCP_MST_FINAL_ITEM
                                 WHERE  DIVISION_ID = V_DIVISION_ID
                                 AND    OPERATION_GROUP IN ('A', 'P')
                                ) B
                    ON    B.ITEM_ID     = ADJ.ITEM_ID
                    AND   B.DIVISION_ID = ADJ.DIVISION_ID
                LEFT OUTER JOIN (
                                 SELECT  DISTINCT DIVISION_ID, PLANT_ID, LINE_ID, OPERATION_ID
                                 FROM    SCM_LINE_M_SN M
                                 WHERE   M.DIVISION_ID   = V_DIVISION_ID
                                 AND     M.OPERATION_ID  = 'B1000'
                                 AND     M.ACTIVE_FLAG   = 'Y'
                                ) LM
                    ON  LM.DIVISION_ID  = ADJ.DIVISION_ID
                    AND LM.PLANT_ID     = ADJ.FROM_SITE_ID
                    AND LM.LINE_ID      = ADJ.LINE_ID
                INNER JOIN (
                            SELECT  DIVISION_ID, ITEM_ID, SCP_FLOW_ID
                            FROM    SCM_ITEM_M_SN
                            WHERE   DIVISION_ID = V_DIVISION_ID
                            AND     SCP_FLOW_ID IS NOT NULL
                            GROUP BY DIVISION_ID, ITEM_ID, SCP_FLOW_ID
                           ) ITM
                    ON  ITM.DIVISION_ID = ADJ.DIVISION_ID
                    AND ITM.ITEM_ID = ADJ.ITEM_ID
                LEFT OUTER JOIN (
                                 SELECT    SEGMENT3      AS SITE_ID
                                         , SEGMENT4      AS LINE_ID
                                         , ATTRIBUTE1    AS LINE_SIDE
                                 FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK
                                 WHERE   LK.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_LINE'
                                 AND     LK.SEGMENT1 = V_DIVISION_ID
                                 AND     LK.SEGMENT2 = V_GROUP_ID
                                ) LS
                    ON  LS.SITE_ID = ADJ.SCM_SITE_ID
                    AND LS.LINE_ID = ADJ.LINE_ID
         WHERE  ADJ.DIVISION_ID     = V_DIVISION_ID
           AND  ADJ.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD
        -- AND     ADJ.CHG_QTY         > 0
           AND  ADJ.LINE_ID        != '-'
           AND  ADJ.INV_DATE >= P_PLAN_START_YYYYMMDD
           AND  ADJ.INV_DATE <  P_PLAN_END_YYYYMMDD
         GROUP BY  ADJ.SCM_SITE_ID
                , ADJ.ITEM_ID
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP'    THEN 'CHAR'
                        WHEN LM.OPERATION_ID IS NOT NULL                        THEN 'CHAR'
                        WHEN B.FLOW_ID = 'A9000'                                THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'ASSY@'    || LS.LINE_SIDE END
                        WHEN ITM.SCP_FLOW_ID = 'A8000'                          THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'STK@'     || LS.LINE_SIDE END
                        WHEN ADJ.BEFORE_DEGAS = 'Y'                             THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'B_DEGAS@' || LS.LINE_SIDE END
                        WHEN ADJ.BEFORE_DEGAS = 'N'                             THEN CASE WHEN LS.LINE_SIDE IS NULL THEN NULL ELSE 'A_DEGAS@' || LS.LINE_SIDE END
                        ELSE '-' END
                , CASE  WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 = 'CP'    THEN 'CHAR'
                        WHEN LM.OPERATION_ID IS NOT NULL                        THEN 'CHAR'
                        WHEN B.FLOW_ID = 'A9000'                                THEN 'ASSY'
                        WHEN ITM.SCP_FLOW_ID = 'A8000'                          THEN 'STK'
                        WHEN ADJ.BEFORE_DEGAS = 'Y'                             THEN 'B_DEGAS'
                        WHEN ADJ.BEFORE_DEGAS = 'N'                             THEN 'A_DEGAS'
                        ELSE '-' END
                , ADJ.INV_DATE
                , ADJ.STOCK_TYPE
                , ADJ.INCOTERMS
                , ADJ.PROJECT_CODE
        ;

        --------------------------------------------------------
        -- INCOMING STOCK INSERT
        -- 2025.09.16 Philsu Park: Stage 판정 안되는 재고 제외.
        --------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN(PLAN_ID
                                                 ,STOCK_ID
                                                 ,BUFFER_ID
                                                 ,EFFECTIVE_DATE
                                                 ,TYPE
                                                 ,QUANTITY
                                                 ,ATTRIBUTE1
                                                 ,ATTRIBUTE2
                                                 ,ATTRIBUTE3
                                                 ,ATTRIBUTE4
                                                 ,ATTRIBUTE5
                                                 ,ATTRIBUTE6
                                                 ,INSERT_ID
                                                 ,INSERT_TIME
                                                 ,UPDATE_ID
                                                 ,UPDATE_TIME
                                                 )
        SELECT  AA.PLAN_ID
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
              , AA.STAGE_BUFFER
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
          FROM (
                SELECT  V_PLAN_ID                                                                 AS PLAN_ID
                        /* 원문 문자 결합 '+' : STAGE_BUFFER · INCOTERMS 가 NULL 이면 MSSQL 은 결과 전체가 NULL 이다.
                           '||' 는 NULL 을 무시하므로 NULL 전파를 CASE 로 살려 둔다. */
                      , CASE WHEN A.STAGE_BUFFER IS NULL OR A.INCOTERMS IS NULL THEN NULL
                             ELSE A.TYPE || '::' || A.SITE_ID || '::' || A.ITEM_ID || '::' || A.STAGE_BUFFER
                                  || CASE WHEN A.INCOTERMS = '-'          THEN '' ELSE '@'  || A.INCOTERMS         END
                                  || CASE WHEN A.PROJECT_CODE IS NULL     THEN '' ELSE '@'  || A.PROJECT_CODE      END
                                  || '::' || A.EFECTIVE_DATE
                                  || CASE WHEN A.CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::' || A.CELL_PROD_SITE_ID END
                        END                                                                       AS STOCK_ID
                      , CASE WHEN A.STAGE_BUFFER IS NULL OR A.INCOTERMS IS NULL THEN NULL
                             ELSE A.SITE_ID || '::' || A.ITEM_ID || '::' || A.STAGE_BUFFER
                                  || CASE WHEN A.INCOTERMS = '-'          THEN '' ELSE '@'  || A.INCOTERMS         END
                                  || CASE WHEN A.PROJECT_CODE IS NULL     THEN '' ELSE '@'  || A.PROJECT_CODE      END
                                  || CASE WHEN A.CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::' || A.CELL_PROD_SITE_ID END
                        END                                                                       AS BUFFER_ID
                      , A.EFECTIVE_DATE                                                           AS EFECTIVE_DATE
                      , A.TYPE                                                                    AS TYPE
                      , A.QTY                                                                     AS QUANTITY
                      , A.SITE_ID                                                                 AS SITE_ID
                      , A.ITEM_ID                                                                 AS ITEM_ID
                      , A.STAGE                                                                   AS STAGE
                      , A.STAGE_BUFFER                                                            AS STAGE_BUFFER
                      , A.INCOTERMS                                                               AS INCOTERMS
                      , A.PROJECT_CODE                                                            AS PROJECT_CODE
                  FROM (
                        SELECT  A.SCM_SITE_ID AS SITE_ID
                             --, A.ITEM_ID AS ITEM_ID
                              , CASE --> 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-'
                                          THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), A.ITEM_ID)
                                     ELSE A.ITEM_ID
                                END ITEM_ID
                                /* 'XXX@' + LD.ATTRIBUTE1 : LD 는 LEFT JOIN 이라 ATTRIBUTE1 이 NULL 이면 MSSQL 결과도 NULL 이다 */
                              , CASE WHEN A.OPERATION_ID = 'A8000' THEN CASE WHEN LD.ATTRIBUTE1 IS NULL THEN NULL ELSE 'STK@'     || LD.ATTRIBUTE1 END
                                     WHEN A.OPERATION_ID = 'A9000' THEN CASE WHEN LD.ATTRIBUTE1 IS NULL THEN NULL ELSE 'ASSY@'    || LD.ATTRIBUTE1 END
                                     WHEN A.OPERATION_ID = 'F6000' THEN CASE WHEN LD.ATTRIBUTE1 IS NULL THEN NULL ELSE 'EOL@'     || LD.ATTRIBUTE1 END
                                     WHEN A.B_DEGAS_YN   = 'Y'     THEN CASE WHEN LD.ATTRIBUTE1 IS NULL THEN NULL ELSE 'B_DEGAS@' || LD.ATTRIBUTE1 END
                                     WHEN A.B_DEGAS_YN   = 'N'     THEN CASE WHEN LD.ATTRIBUTE1 IS NULL THEN NULL ELSE 'A_DEGAS@' || LD.ATTRIBUTE1 END
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                     WHEN A.OPERATION_ID = 'B1000' THEN 'CHAR'
                                     ELSE '-'
                                 END AS STAGE_BUFFER
                              , CASE WHEN A.OPERATION_ID = 'A8000' THEN 'STK'
                                     WHEN A.OPERATION_ID = 'A9000' THEN 'ASSY'
                                     WHEN A.OPERATION_ID = 'F6000' THEN 'EOL'
                                     WHEN A.B_DEGAS_YN   = 'Y'     THEN 'B_DEGAS'
                                     WHEN A.B_DEGAS_YN   = 'N'     THEN 'A_DEGAS'
                                     WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                                     WHEN A.OPERATION_ID = 'B1000' THEN 'CHAR'
                                     ELSE '-'
                                 END AS STAGE
                              /* SITE 가 PLANT SITE 가 아니라 SALES SITE 인경우는 **** BIZ 로 STAGE 생성 */
                              --, CASE
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500'
                              --          THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'PACK' ELSE 'PACKBIZ' END)
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500'
                              --          THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'MDLE' ELSE 'MDLEBIZ' END)
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500')
                              --          THEN (CASE WHEN A.SCM_SITE_ID IN (SELECT SCM_SITE_ID FROM SCM_MST_SITE WITH(NOLOCK) WHERE SITE_TYPE = 'PLANT') THEN 'SUBMDLE' ELSE 'SUBMDLEBIZ' END)
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'PLANT' THEN 'PACK'
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P9500' AND A.FLAG = 'SALES' THEN 'PACKBIZ'
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'PLANT' THEN 'MDLE'
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID = 'P5500' AND A.FLAG = 'SALES' THEN 'MDLEBIZ'
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                              --      WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                              --      WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'PLANT' THEN 'CHAR'
                              --      WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8  = 'CP' AND A.FLAG = 'SALES' THEN 'CELLBIZ'
                              --      WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND a.DESCR LIKE 'FOR%' THEN 'ASY_AGING' -- 활성화 재고
                              --> 활성화 완료 재고 : 'CHAR' 버퍼 재고로 처리하고 ASSY Item 인 경우 CHAR Item 으로 Update 처리함
                              --> 활성화 전 재고 : 'ASSY'
                              --      WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'ASY_AGING' ELSE 'ASSY' END)
                              --      WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END)
                              --> SUBMDLE는 FINAL ITEM에 없으므로 다른 TABLE에서 확인
                              --      WHEN SMC.SCP_FLOW_ID = 'A8000' THEN 'STK'
                              --      ELSE '-' END STAGE
                              , TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_P_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                              , A.DESCR AS TYPE
                              , A.QTY AS QTY
                              , A.INCOTERMS
                              , A.PROJECT_CODE
                              , A.CELL_PROD_SITE_ID
                          FROM   (
                                  SELECT  T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID AS SCM_SITE_ID
                                        , T.INCOTERMS
                                        , TO_DATE(TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), 'YYYYMMDD')   AS EFFSTARTDATE
                                        , SUM(T.QTY)        AS QTY
                                        , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                               ELSE 'WH_HOLD'
                                          END  AS DESCR
                                        , T.LOCATION_CODE
                                        , T.PROJECT_CODE
                                        , T.CELL_PROD_SITE_ID
                                        , T.OPERATION_ID
                                        , T.LINE_ID
                                        , T.B_DEGAS_YN
                                        , T.FLAG
                                    FROM  GT_OPT_ENG_GMIS_INV T
                                   WHERE  1=1
                                     AND  T.STOCK_TYPE <> 'FOR'
                                   GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID, T.OPERATION_ID, T.LINE_ID, T.B_DEGAS_YN
                                  HAVING SUM(T.QTY) > 0
                                  UNION ALL
                                  -- 활성화 재고 : FOR 로 처리
                                  SELECT  T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID AS SCM_SITE_ID
                                        , T.INCOTERMS
                                        , TO_DATE(TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), 'YYYYMMDD')   AS EFFSTARTDATE
                                        , SUM(T.QTY)       AS QTY
                                        , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
                                               ELSE 'FOR_HOLD'
                                          END  AS DESCR
                                        , T.LOCATION_CODE
                                        , T.PROJECT_CODE
                                        , T.CELL_PROD_SITE_ID
                                        , T.OPERATION_ID
                                        , T.LINE_ID
                                        , T.B_DEGAS_YN
                                        , T.FLAG
                                    FROM  GT_OPT_ENG_GMIS_INV T
                                   WHERE  1=1
                                     AND  T.STOCK_TYPE  = 'FOR' -- 활성화 재고
                                     AND  T.QTY         > 0
                                   GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID, T.OPERATION_ID, T.LINE_ID, T.B_DEGAS_YN
                                  UNION ALL
                                  -- INTRANSIT SHIPMENT 재고
                                  SELECT  T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID AS SCM_SITE_ID
                                        , T.INCOTERMS
                                        , TO_DATE(T.ETA_DATE, 'YYYYMMDD')  AS EFFSTARTDATE
                                        , SUM(T.DELIVERY_QTY)              AS QTY
                                        , 'INT'                            AS DESCR
                                        , '-'                              AS LOCATION_CODE
                                        , T.PROJECT_CODE
                                        , T.CELL_PROD_SITE_ID
                                        , T.OPERATION_ID
                                        , T.LINE_ID
                                        , T.B_DEGAS_YN
                                        , T.FLAG
                                    FROM  GT_OPT_ENG_GMIS_INT T
                                   WHERE  1=1
                                     AND  T.DELIVERY_QTY  > 0
                                     AND (T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')
                                   GROUP BY T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID, T.ETA_DATE, T.INCOTERMS, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID, T.OPERATION_ID, T.LINE_ID, T.B_DEGAS_YN
                                 ) A

                                LEFT JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                                --, *
                                           FROM   SCP_MST_FINAL_ITEM
                                           WHERE  DIVISION_ID = V_DIVISION_ID
                                           AND    OPERATION_GROUP IN ('A', 'P')
                                          ) B
                                    ON    A.ITEM_ID     = B.ITEM_ID
                                    AND   A.DIVISION_ID = B.DIVISION_ID

                                LEFT  JOIN SCM_MST_SITE FS
                                    ON  FS.DIVISION_ID = A.DIVISION_ID
                                    AND FS.SCM_SITE_ID = A.SCM_SITE_ID
                                    AND FS.SITE_TYPE   = 'PLANT'
                                LEFT  JOIN GT_OPT_ENG_GMIS_CP C1
                                    ON  C1.DIVISION_ID  = A.DIVISION_ID
                                    AND C1.PLANT_ID     = FS.PLANT_ID
                                    AND C1.ITEM_ID_ASSY = A.ITEM_ID
                                    AND C1.PRIORITY_1ST = 1
                                LEFT  JOIN GT_OPT_ENG_GMIS_CP C2
                                    ON  C2.DIVISION_ID  = A.DIVISION_ID
                                    AND C2.ITEM_ID_ASSY = A.ITEM_ID
                                    AND C2.PRIORITY_2ND = 1
                                LEFT  JOIN GT_OPT_ENG_GMIS_CP C3
                                    ON  C3.ITEM_ID_ASSY = A.ITEM_ID
                                    AND C3.PRIORITY_3RD = 1
                                LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LD
                                    ON  LD.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_LINE'
                                    AND A.DIVISION_ID  = LD.SEGMENT1
                                    AND LD.SEGMENT2    = V_GROUP_ID
                                    AND A.SCM_SITE_ID  = LD.SEGMENT3
                                    AND A.LINE_ID      = LD.SEGMENT4
                                --SUBMDLE의 STAGE를 찾기 위해 추가
                                --LEFT  JOIN (
                                --            SELECT  SM.DIVISION_ID
                                --                   ,SM.SCM_SITE_ID
                                --                   ,IM.ITEM_ID
                                --                   ,IM.SCP_FLOW_ID
                                --                   ,IM.SCP_OPERATION_GROUP
                                --            FROM    SCM_ITEM_M_SN IM WITH(NOLOCK)
                                --                INNER JOIN SCM_MST_SITE SM WITH(NOLOCK)
                                --                    ON  IM.COMPANY_ID = SM.COMPANY_ID
                                --                    AND IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                                --            WHERE   1=1
                                --            AND     CONCAT (SM.SCM_SITE_ID,IM.ITEM_ID) IN(
                                --                                 SELECT  DISTINCT CONCAT (SCM_SITE_ID, ITEM_ID)
                                --                                 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                --                                 WHERE   PLAN_ID = @V_PLAN_ID
                                --                                 )
                                --            AND     IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500') -- SUBMDLE만 걸리도록
                                --            -- AND     IM.SCP_OPERATION_GROUP = 'P'             -- SUBMDLE만 걸리도록
                                --            ) SMC
                                --     ON  A.DIVISION_ID = SMC.DIVISION_ID
                                --     AND A.SCM_SITE_ID = SMC.SCM_SITE_ID
                                --     AND A.ITEM_ID     = SMC.ITEM_ID
                         WHERE  1=1
                           --AND    A.ITEM_ID = B.ITEM_ID
                           --AND    B.ITEM_TYPE <> 'R' --  R TYPE의 재고는 올리지 않음
                        /*************************
                        대상 프로젝트 ITEM 필터링
                        *************************/
                           AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                              FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                              WHERE   PLAN_ID = V_PLAN_ID
                                            )
                       ) A
                 WHERE 1=1
                   AND A.STAGE != '-'
                   AND A.EFECTIVE_DATE < P_PLAN_END_YYYYMMDD
                   AND NOT EXISTS (
                                   SELECT  1
                                   FROM    GT_OPT_ENG_GMIS_ADJ ADJ
                                   WHERE   ADJ.SCM_SITE_ID     = A.SITE_ID
                                   AND     ADJ.ITEM_ID         = A.ITEM_ID
                                   AND     ADJ.STAGE_BUFFER    = A.STAGE_BUFFER
                                   AND     ADJ.STAGE           = A.STAGE
                                   AND     ADJ.TYPE            = A.TYPE
                                   AND     ADJ.EFFECTIVE_DATE  = A.EFECTIVE_DATE
                                   AND     ADJ.INCOTERMS       = A.INCOTERMS
                                   AND     ADJ.PROJECT_CODE    = A.PROJECT_CODE
                                   )

                --------------------------------------------------------
                --  자재/포장재의 입고 예정정보
                --  2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용.
                --------------------------------------------------------
                UNION ALL
                SELECT  V_PLAN_ID                                                                                        AS PLAN_ID
                      , MC.TYPE || '::' || MC.SCM_SITE_ID || '::' || MC.MAT_ID || '::' || MC.STAGE || '::' || MC.ARR_DATE AS STOCK_ID
                      , MC.SCM_SITE_ID || '::' || MC.MAT_ID || '::' || MC.STAGE                                          AS BUFFER_ID
                      , MC.ARR_DATE                                                                                      AS EFFECTIVE_DATE
                      , MC.TYPE                                                                                          AS TYPE
                      , MC.QTY                                                                                           AS QUANTITY
                      , MC.SCM_SITE_ID                                                                                   AS SITE_ID
                      , MC.MAT_ID                                                                                        AS ITEM_ID
                      , MC.STAGE                                                                                         AS STAGE
                      , MC.STAGE                                                                                         AS STAGE_BUFFER
                      , '-'                                                                                              AS INCOTERMS
                      , '-'                                                                                              AS PROJECT_CODE
                  FROM (
                        -- START 2025.11.19 jongykim2: Schelduled Reciept Information
                        SELECT  LU.PLANT_SITE_ID        AS SCM_SITE_ID
                              , LU.ITEM_ID_CHILD        AS MAT_ID
                              , 'MATERIAL_CONST'        AS STAGE
                              , LU.TO_YYYYMMDD          AS ARR_DATE
                              , TO_NUMBER(LU.TO_EXPC_QTY) AS QTY
                              , 'MC'                    AS TYPE
                          FROM  SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION LU
                                INNER JOIN SCP_OPMZ_PLAN_GR_M PG
                                    ON      LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                INNER JOIN GT_OPT_ENG_GMIS_MAT MAT
                                    ON      LU.ITEM_ID_CHILD    = MAT.MAT_ID
                         WHERE  1 = 1
                           AND  LU.DIVISION_ID       = V_DIVISION_ID
                           AND  PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                           AND  LU.VALID_YN          = 'Y'
                           AND  PG.VALID_YN          = 'Y'
                           AND  LU.TO_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE
                        -- END 2025.11.19 jongykim2: Schelduled Reciept Information
                        /*
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
                 WHERE MC.ARR_DATE < P_PLAN_END_YYYYMMDD
                --------------------------------------------------------
                --  2025.09.30 Philsu Park: Workbench 재고 추가
                --------------------------------------------------------
                UNION ALL
                SELECT  V_PLAN_ID                                                                 AS PLAN_ID
                      , CASE WHEN INV.STAGE_BUFFER IS NULL OR INV.INCOTERMS IS NULL THEN NULL
                             ELSE INV.TYPE || '::' || INV.SCM_SITE_ID || '::' || INV.ITEM_ID || '::' || INV.STAGE_BUFFER
                                  || CASE WHEN INV.INCOTERMS = '-'      THEN '' ELSE '@' || INV.INCOTERMS    END
                                  || CASE WHEN INV.PROJECT_CODE IS NULL THEN '' ELSE '@' || INV.PROJECT_CODE END
                                  || '::' || INV.EFFECTIVE_DATE
                        END                                                                       AS STOCK_ID
                      , CASE WHEN INV.STAGE_BUFFER IS NULL OR INV.INCOTERMS IS NULL THEN NULL
                             ELSE INV.SCM_SITE_ID || '::' || INV.ITEM_ID || '::' || INV.STAGE_BUFFER
                                  || CASE WHEN INV.INCOTERMS = '-'      THEN '' ELSE '@' || INV.INCOTERMS    END
                                  || CASE WHEN INV.PROJECT_CODE IS NULL THEN '' ELSE '@' || INV.PROJECT_CODE END
                        END                                                                       AS BUFFER_ID
                      , INV.EFFECTIVE_DATE                                                        AS EFFECTIVE_DATE
                      , INV.TYPE                                                                  AS TYPE
                      , INV.QTY                                                                   AS QUANTITY
                      , INV.SCM_SITE_ID                                                            AS SITE_ID
                      , INV.ITEM_ID                                                                AS ITEM_ID
                      , INV.STAGE                                                                  AS STAGE
                      , INV.STAGE_BUFFER                                                           AS STAGE_BUFFER
                      , INV.INCOTERMS                                                              AS INCOTERMS
                      , INV.PROJECT_CODE                                                            AS PROJECT_CODE
                  FROM  GT_OPT_ENG_GMIS_ADJ INV
                 WHERE INV.QTY > 0
               ) AA
                /* INNER JOIN SCP_OPT_ENG_MODEL_LIST_N_SN ML WITH(NOLOCK)
                    ON  ML.PLAN_ID      = @V_PLAN_ID
                    AND AA.SITE_ID      = ML.SCM_SITE_ID
                    AND AA.ITEM_ID      = ML.ITEM_ID
                    AND AA.STAGE_BUFFER = ML.STAGE */
         GROUP BY AA.PLAN_ID, AA.STOCK_ID, AA.BUFFER_ID, AA.EFECTIVE_DATE, AA.TYPE, AA.SITE_ID, AA.ITEM_ID, AA.STAGE, AA.STAGE_BUFFER, AA.INCOTERMS, AA.PROJECT_CODE;

        ------------------------------------------------------------------------
        -- TRAY 제약을 위한 데이터 추가
        -- 2025-07-30 THK
        ------------------------------------------------------------------------
        INSERT INTO SCP_OPT_ENG_INCOMING_STOCK_SN(PLAN_ID
                                                 ,STOCK_ID
                                                 ,BUFFER_ID
                                                 ,EFFECTIVE_DATE
                                                 ,TYPE
                                                 ,QUANTITY
                                                 ,ATTRIBUTE1
                                                 ,ATTRIBUTE2
                                                 ,ATTRIBUTE3
                                                 ,ATTRIBUTE6
                                                 ,INSERT_ID
                                                 ,INSERT_TIME
                                                 ,UPDATE_ID
                                                 ,UPDATE_TIME
                                                 )
        SELECT  V_PLAN_ID                                                                                                                              AS PLAN_ID
              , 'TRAY' || '::' || LU.SEGMENT4 || '::' || LU.SEGMENT5 || '::' || LU.SEGMENT6 || CASE WHEN LU.SEGMENT3 IS NULL THEN '' ELSE '@' || LU.SEGMENT3 END AS STOCK_ID
              , LU.SEGMENT4 || '::' || LU.SEGMENT5 || '::' || LU.SEGMENT6 || CASE WHEN LU.SEGMENT3 IS NULL THEN '' ELSE '@' || LU.SEGMENT3 END                   AS BUFFER_ID
              , P_PLAN_START_YYYYMMDD                                                                                                                  AS EFFECTIVE_DATE
              , 'TRAY'                                                                                                                                 AS TYPE
              , CAST(TO_NUMBER(LU.ATTRIBUTE1) - NVL(INC.QUANTITY, 0) AS NUMBER(20,10))                                                                 AS QUANTITY -- changed 2025-12-02 ISNULL 처리
              , LU.SEGMENT4                                                                                                                            AS ATTRIBUTE1
              , LU.SEGMENT5                                                                                                                            AS ATTRIBUTE2
              , LU.SEGMENT6                                                                                                                            AS ATTRIBUTE3
              , LU.SEGMENT6 || CASE WHEN LU.SEGMENT3 IS NULL THEN '' ELSE '@' || LU.SEGMENT3 END                                                        AS ATTRIBUTE6
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                --INNER JOIN( -- blocked 2025-12-02 jongykim2
                LEFT OUTER JOIN( -- changed 2025-12-02 jongykim2: left join으로 변경
                                SELECT  ITEM_ID
                                      , EW_FLAG
                                      , SUM(QUANTITY) AS QUANTITY
                                  FROM (
                                        SELECT  'B_TRAY'                   AS ITEM_ID
                                              , SUBSTR(INC.ATTRIBUTE6, -1) AS EW_FLAG
                                              , INC.QUANTITY               AS QUANTITY
                                          FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                         WHERE  INC.PLAN_ID = V_PLAN_ID
                                           AND  (   (INC.ATTRIBUTE3 ='ASSY' AND INC.EFFECTIVE_DATE <= P_PLAN_START_YYYYMMDD)
                                                 OR INC.ATTRIBUTE3 = 'B_DEGAS')
                                       ) INC
                                 GROUP BY ITEM_ID, EW_FLAG
                                 UNION ALL
                                SELECT  ITEM_ID
                                      , EW_FLAG
                                      , SUM(QUANTITY) AS QUANTITY
                                  FROM (
                                        SELECT  'A_TRAY'                   AS ITEM_ID
                                              , SUBSTR(INC.ATTRIBUTE6, -1) AS EW_FLAG
                                              , INC.QUANTITY               AS QUANTITY
                                          FROM  SCP_OPT_ENG_INCOMING_STOCK_SN INC
                                         WHERE  INC.PLAN_ID = V_PLAN_ID
                                           AND  INC.ATTRIBUTE3 = 'A_DEGAS'
                                       ) INC
                                 GROUP BY ITEM_ID, EW_FLAG
                               ) INC
                    ON  LU.SEGMENT5 = INC.ITEM_ID
                    AND LU.SEGMENT3 = INC.EW_FLAG
         WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_GM_TRAY'
           AND  LU.VALID_YN    = 'Y'
           AND  LU.SEGMENT1    = V_DIVISION_ID
           AND  LU.SEGMENT2    = V_GROUP_ID
        ;

        --------------------------------------------------------
        -- 2025.09.08 Philsu Park: Hold 재고의 Release를 룩업 기반으로 반영. (PSD + n)
        -- 조립은 동편, 서편 구분이 있으므로 Attribute6(Stage+Side) 와 Join.
        --------------------------------------------------------
        MERGE INTO SCP_OPT_ENG_INCOMING_STOCK_SN S
        USING (
               SELECT    SEGMENT3 AS SITE_ID
                       , CASE WHEN SEGMENT5 = '-' THEN SEGMENT4 ELSE SEGMENT4 || '@' || SEGMENT5 END AS EW_STAGE
                       , MIN(TO_NUMBER(ATTRIBUTE1)) AS ADD_DAYS /* 원문 UPDATE-FROM 다중 일치 대비 : MIN 으로 좁힌다 */
                 FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL
                WHERE    LOOKUP_TYPE  = 'SCP_OPT_ENG_GM_RELEASE_HOLD'
                  AND    VALID_YN     = 'Y'
                  AND    SEGMENT1     = V_DIVISION_ID
                  AND    SEGMENT2     = V_GROUP_ID
                GROUP BY SEGMENT3
                       , CASE WHEN SEGMENT5 = '-' THEN SEGMENT4 ELSE SEGMENT4 || '@' || SEGMENT5 END
              ) LK
           ON (    LK.SITE_ID  = S.ATTRIBUTE1
               AND LK.EW_STAGE = S.ATTRIBUTE6
               AND S.PLAN_ID   = V_PLAN_ID
               AND INSTR(S.TYPE, 'HOLD') > 0
              )
        WHEN MATCHED THEN
            UPDATE SET S.EFFECTIVE_DATE  = TO_CHAR(V_D_PLAN_NAME + LK.ADD_DAYS, 'YYYYMMDD')
                     , S.UPDATE_ID       = 'HOLD_UPDATE'
                     , S.UPDATE_TIME     = SYSDATE;

        --------------------------------------------------------
        -- 2nd OCV 재고는 INSP로 UPDATE
        --------------------------------------------------------
        --UPDATE  SCP_OPT_ENG_INCOMING_STOCK_SN
        --SET     SCP_OPT_ENG_INCOMING_STOCK_SN.STOCK_ID   = INC.TYPE+'::'+INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+OCV.TO_BE_STAGE+'::'+INC.EFFECTIVE_DATE
        --       ,SCP_OPT_ENG_INCOMING_STOCK_SN.BUFFER_ID  = INC.ATTRIBUTE1+'::'+INC.ATTRIBUTE2+'::'+OCV.TO_BE_STAGE
        --       ,SCP_OPT_ENG_INCOMING_STOCK_SN.ATTRIBUTE3 = OCV.TO_BE_STAGE
        --FROM    SCP_OPT_ENG_INCOMING_STOCK_SN INC WITH(NOLOCK)
        --    INNER JOIN (
        --               SELECT  ATTRIBUTE2 AS AS_IS_STAGE
        --                      ,ATTRIBUTE3 AS TO_BE_STAGE
        --                      ,SEGMENT4   AS SCM_SITE_ID
        --                      ,SEGMENT5   AS ITEM_ID
        --               FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LU WITH(NOLOCK)
        --               WHERE   1=1
        --               AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
        --               AND     LU.VALID_YN    = 'Y'
        --               AND     LU.SEGMENT2    = @V_DIVISION_ID
        --               AND     LU.SEGMENT3    = @V_GROUP_ID
        --               GROUP BY ATTRIBUTE2, ATTRIBUTE3, SEGMENT4, SEGMENT5
        --               ) OCV
        --        ON  INC.ATTRIBUTE1 = OCV.SCM_SITE_ID
        --        AND INC.ATTRIBUTE2 = OCV.ITEM_ID
        --        AND INC.ATTRIBUTE3 = OCV.AS_IS_STAGE
        --WHERE   INC.PLAN_ID = @V_PLAN_ID

        ------------------------------------------------------------------------
        -- Data Insert End
        ------------------------------------------------------------------------
        DELETE FROM GT_OPT_ENG_GMIS_INV;
        DELETE FROM GT_OPT_ENG_GMIS_INT;
        DELETE FROM GT_OPT_ENG_GMIS_CP;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR(SQLERRM, 1, 1000);
            IF DBMS_TRANSACTION.LOCAL_TRANSACTION_ID IS NOT NULL THEN
                ROLLBACK;   /* 실패 스텝의 미완성 데이터 제거 */
            END IF;
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,SYSDATE,NULL,V_MESSAGE_TEXT,'ERROR');
            COMMIT;         /* 로그 보존 */
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    ------------------------------------------------------------------------
    -- 종료 LOG
    ------------------------------------------------------------------------
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
        COMMIT;
    END IF;
END;
