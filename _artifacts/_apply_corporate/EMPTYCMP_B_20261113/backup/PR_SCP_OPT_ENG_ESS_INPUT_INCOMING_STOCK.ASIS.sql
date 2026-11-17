CREATE OR REPLACE PROCEDURE PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK
(
    P_PLAN_ID                IN VARCHAR2
  , P_DIVISION_ID            IN VARCHAR2
  , P_GROUP_ID               IN VARCHAR2
  , P_PLAN_START_YYYYMMDD    IN VARCHAR2
  , P_PLAN_END_YYYYMMDD      IN VARCHAR2
)
IS
/*
 * Program ID   : PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK
 * Description  : ESS 엔진 입력용 입고 재고(Incoming Stock) 정보를 생성한다.
 *                - 창고 재고(WH/WH_HOLD) · 활성화 재고(FOR/FOR_HOLD) · 해상 재고(INT) ·
 *                  자재/포장재 입고 예정(MC) 을 모아 SCP_OPT_ENG_INCOMING_STOCK_SN 에 적재한다.
 *                - SALES 재고는 NET DEMAND 최신 버전에서 INCOTERMS 를 보정하고(VMI 는 DAP),
 *                  DEMAND 의 PROJECT_CODE 를 되찾아 채운다.
 *                - 2nd OCV 에 쓰인 SUB MDLE 재고는 제외하고, 2nd OCV 대상 재고는 전환 STAGE 로 바꾼다.
 *                - 재고 보정값(SCP_OPMZ_INV_ADJ) 은 본 적재에서 빼고 별도 INSERT 로 넣는다.
 *                - 법인간 이동 재고(INT, BIZ 아님) 는 INCOTERMS/PROJECT_CODE 를 떼고 다시 만든다.
 *
 * Program History
 *===================================================================================================
 *   Date         In Charge   Description
 *===================================================================================================
 * 2025.02.05     Y.S.H       Initial Release
 * 2025.05.19     Philsu Park GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용
 * 2025.07.10     Philsu Park 재고 보정값 반영을 위한 TEMP Input / 보정 대상은 별도 Insert
 * 2025.08.12     Philsu Park ESS 불필요 로직으로 주석처리
 * 2025.11.19     jongykim2   Schelduled Reciept Information 반영
 * 2025.12.01     Minyong Lee LINKBIZ -> PACKBIZ 수요 변환 모델에 대한 재고 BUFFER_ID 동기화
 * 2026.04.08     Minyong Lee 법인간 이동 재고 BUFFER_ID, STOCK_ID 생성 규칙 수정, INCOTERMS / PROJECT_CODE 제거
 * 2026.05.08     Minyong Lee 활성화 재고 뷰 중복 스캔 제거 (쿼리 수행 시간 단축)
 * 2026.05.26     Minyong Lee ESS LINK 사내 공장 신설 대응
 * 2026.05.27     Minyong Lee ESS 사내 Pack Plant 추가로 SUBMDLE 관리 되도록 원복
 * 2026.07.02     -           [E20260702-001614] [ODS] ESS Incoming stock stage 판정로직 수정
 * 2026.11.09     JCH         MSSQL -> Oracle 전환
 */
    /* Set Prameter */
    V_PROGRAM_NAME         VARCHAR2(150 CHAR)  := 'PR_SCP_OPT_ENG_ESS_INPUT_INCOMING_STOCK';
    V_PLAN_ID              VARCHAR2(50 CHAR)   := P_PLAN_ID;
    V_DIVISION_ID          VARCHAR2(20 CHAR)   := P_DIVISION_ID;
    V_GROUP_ID             VARCHAR2(20 CHAR)   := P_GROUP_ID;
    V_MESSAGE_TEXT         VARCHAR2(1000 CHAR);
    V_DETAIL_DATE          DATE;

    /* Set Param for Biz */
    V_PLAN_NAME            VARCHAR2(8 CHAR);
    V_PLAN_TYPE            VARCHAR2(4000 CHAR);
    V_SEQ                  VARCHAR2(4000 CHAR);
    V_MODELING_ID          VARCHAR2(4000 CHAR);
    V_CUTOFF_DAY           VARCHAR2(8 CHAR);
    V_D_CUTOFF_DAY         DATE;
    V_DEMAND_CUTOFF_DAY    VARCHAR2(8 CHAR);
    V_MAX_TUESDAY          VARCHAR2(8 CHAR);
    /* 원문 테이블변수 -> 기존 GTT 재사용
       @MAT_CONST_TEMP  -> GT_OPTENG_ESSIS_MAT
       @DM_TEMP         -> GT_OPTENG_ESSIS_DM
       @OCV_EXCEPT_LIST -> GT_OPTENG_ESSIS_OCV
       @CELL_PROD_SITE  -> GT_OPTENG_ESSIS_CPS   (셀 생산지 버퍼 추가)
       @INC_TEMP        -> 원문에서 선언만 하고 쓰지 않는다 (소형 INCOTERMS 변경용)
       @INC_DEL_TEMP    -> 원문에서 선언만 하고 쓰지 않는다 (소형 INCOTERMS 변경 후 DELETE용)
       #SCP_INVENTORY_I -> GT_OPTENG_ESSIS_INV
       #SCP_INTRANSIT_I -> GT_OPTENG_ESSIS_INT
       #CP_INFO         -> GT_OPTENG_ESSIS_CP
       #INVENTORY_ADJUST-> GT_OPTENG_ESSIS_ADJ
       #COMPANY_INT_STK -> GT_OPTENG_ESSIS_CINT */
BEGIN

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'START', NULL, NULL, NULL, V_PLAN_ID);
    COMMIT;     /* 시작 로그 보존 */

    /* Transaction (START) */
    /* BEGIN TRANSACTION SCP_OPT_ENG_RUN_MAIN_PROC; */
    BEGIN

        /* GTT 초기화 (세션 보존 GTT 이므로 반드시 비운다 · TRUNCATE 금지) */
        DELETE FROM GT_OPTENG_ESSIS_MAT;
        DELETE FROM GT_OPTENG_ESSIS_OCV;
        DELETE FROM GT_OPTENG_ESSIS_CPS;
        DELETE FROM GT_OPTENG_ESSIS_DM;
        DELETE FROM GT_OPTENG_ESSIS_INV;
        DELETE FROM GT_OPTENG_ESSIS_INT;
        DELETE FROM GT_OPTENG_ESSIS_CP;
        DELETE FROM GT_OPTENG_ESSIS_ADJ;
        DELETE FROM GT_OPTENG_ESSIS_CINT;

        /* Get Param Info */
        BEGIN
            SELECT  ATTRIBUTE1
                  , ATTRIBUTE2
              INTO  V_DIVISION_ID
                  , V_GROUP_ID
              FROM  SCP_OPT_ENG_PLAN_MASTER_SN
             WHERE  PLAN_ID = V_PLAN_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;   /* 원문 SELECT @v = .. 는 0행이면 변수를 그대로 둔다 */
        END;

        SELECT  MAX(BASIS_YYYYMMDD)
          INTO  V_MAX_TUESDAY
          FROM  SCM_SYS_CALENDAR_M
         WHERE  BASIS_YYYYMMDD <= TO_CHAR(SYSDATE, 'YYYYMMDD')
           AND  DAYOFWEEK       = 'TUE';

        BEGIN
            SELECT  MODELING_ID
              INTO  V_MODELING_ID
              FROM  SCM_MST_MODELING
             WHERE  PLAN_CYCLE  = 'WEEKLY'
               AND  DIVISION_ID = V_DIVISION_ID;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                NULL;   /* 원문 SELECT @v = .. 는 0행이면 변수를 그대로 둔다 */
            WHEN TOO_MANY_ROWS THEN
                NULL;   /* 원문은 마지막 행 값이 남는다 — Oracle 에서는 값을 바꾸지 않는다 */
        END;

        V_PLAN_NAME         := P_PLAN_START_YYYYMMDD;                                                    /* CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD */
        V_CUTOFF_DAY        := TO_CHAR(TO_DATE(P_PLAN_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD');      /* CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'SUN')), 112); -- 지난주 일요일 YYYYMMDD */
        V_D_CUTOFF_DAY      := TO_DATE(V_CUTOFF_DAY, 'YYYYMMDD');
        V_DEMAND_CUTOFF_DAY := V_MAX_TUESDAY;   /* 당주 화요일 YYYYMMDD */

        /* 자재 제약 적용을 위한 변수 설정 -- SCP_OPT_ENG_CONST_INCOMMING_MATERIAL 제약을 위해 사용 */
        --SELECT @V_PLAN_START_YYYYMMDD = PLAN_START_DATE
        --FROM   SCP_OPT_ENG_PLAN_MASTER_SN WITH(NOLOCK)
        --WHERE  PLAN_ID = @V_PLAN_ID

        INSERT INTO GT_OPTENG_ESSIS_MAT
        (
            MAT_ID
          , EFF_END_DATE
        )
        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
        SELECT  LU.ITEM_ID_CHILD                                                            AS MAT_ID
              , TO_CHAR(TO_DATE(MAX(LU.TO_YYYYMMDD), 'YYYYMMDD') + 1, 'YYYYMMDD')           AS EFF_END_DATE
          FROM  SCP_OPMZ_VIRTUAL_BOM LU
                INNER JOIN SCP_OPMZ_PLAN_GR_M PG
                   ON  LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
         WHERE  LU.DIVISION_ID       = V_DIVISION_ID
           AND  PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
           AND  LU.VALID_YN          = 'Y'
           AND  PG.VALID_YN          = 'Y'
         GROUP BY LU.ITEM_ID_CHILD;
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
        INSERT INTO GT_OPTENG_ESSIS_OCV
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
                  AND  LU.VALID_YN    = 'Y'
                  AND  LU.SEGMENT2    = V_DIVISION_ID
                  AND  LU.SEGMENT3    = V_GROUP_ID
                  AND  LU.ATTRIBUTE1  = 'B'
         WHERE  1=1
           AND  MS.SCM_SITE_ID     = LU.SEGMENT4
           AND  BOM.PARENT_ITEM_ID = LU.SEGMENT5
         GROUP BY MS.SCM_SITE_ID, BOM.CHILD_ITEM_ID;

        /* 셀 생산지 버퍼 추가 */
        INSERT INTO GT_OPTENG_ESSIS_CPS
        (
            SALES_SITE_ID
          , ITEM_ID
          , OPERATION_GROUP
        )
        SELECT  LU.SEGMENT3                                                                 AS SALES_SITE_ID
              , LU.SEGMENT4                                                                 AS ITEM_ID
              , CASE WHEN FI.OPERATION_GROUP IS NULL THEN NULL
                     ELSE '_'||FI.OPERATION_GROUP
                END                                                                         AS OPERATION_GROUP   /* 원문 '_'+OPERATION_GROUP 의 NULL 전파 유지 (뒤 조인 열쇠로 쓰인다) */
          FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                INNER JOIN SCP_MST_FINAL_ITEM FI
                   ON  LU.SEGMENT1 = FI.DIVISION_ID
                  AND  LU.SEGMENT4 = FI.ITEM_ID
         WHERE  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
           AND  LU.SEGMENT1    = V_DIVISION_ID
           AND  LU.SEGMENT2    = V_GROUP_ID;

        /* 테스트를 위해 25년07주차로 고정 */
        --SELECT @P_PLAN_NAME         = '20250210'; -- 당주 월요일 YYYYMMDD
        --SELECT @V_CUTOFF_DAY        = '20250209'; -- 지난주 일요일 YYYYMMDD
        --SELECT @D_CUTOFF_DAY        = CONVERT(DATETIME, @V_CUTOFF_DAY)
        --SELECT @MAX_TUESDAY         = '20250211'
        --SELECT @V_DEMAND_CUTOFF_DAY = @MAX_TUESDAY; -- 당주 화요일 YYYYMMDD

        /* Data Insert Start */

        /* 원문의 #SCP_INVENTORY_I · #SCP_INTRANSIT_I · #CP_INFO · #INVENTORY_ADJUST DROP 대응 */
        DELETE FROM GT_OPTENG_ESSIS_INV;
        DELETE FROM GT_OPTENG_ESSIS_INT;
        DELETE FROM GT_OPTENG_ESSIS_CP;
        DELETE FROM GT_OPTENG_ESSIS_ADJ;

        /* 2025.07.10 Philsu Park: 재고 보정값 반영을 위한 TEMP Input. */
        /* 2026.07.02 [E20260702-001614] [ODS] ESS Incoming stock stage 판정로직 수정요청드립니다 */
        --SELECT    ADJ.SCM_SITE_ID
        --        , ADJ.ITEM_ID
        --        , ADJ.INCOTERMS
        --        , ADJ.PROJECT_CODE
        --        , ADJ.STOCK_TYPE
        --        , ADJ.INV_DATE
        --        , CASE  WHEN SUBSTRING(ADJ.STOCK_TYPE, 1, 3) = 'FOR' THEN 'ASY_AGING'
        --                ELSE ISNULL(ST.STAGE, IIF(MST.OSP_YN = 'Y', 'CHAR', NULL))
        --                END AS STAGE
        --        -- , ADJ.QTY
        --        , ADJ.CHG_QTY AS QTY
        --INTO     #INVENTORY_ADJUST
        --FROM    SCP_OPMZ_INV_ADJ ADJ WITH(NOLOCK)
        --LEFT OUTER JOIN SCM_MST_SITE MST WITH(NOLOCK)
        --    ON  MST.DIVISION_ID = ADJ.DIVISION_ID
        --    AND MST.SCM_SITE_ID = ADJ.SCM_SITE_ID
        --    AND MST.VALID_YN    = 'Y'
        --LEFT OUTER JOIN (
        --        SELECT    SCM_SITE_ID
        --                , ITEM_ID
        --                , STAGE
        --                -- , MIN(STAGE) AS STAGE  -- ASSY, ASY_AGING 이 ITEM 이 겹치므로 하나만 나오게 처리.
        --                -- , IIF(STAGE = 'ASY_AGING', 'FOR', 'X') AS INV_TYPE
        --        FROM    SCP_OPT_ENG_MODEL_LIST_N_SN S WITH(NOLOCK)
        --        WHERE   PLAN_ID = @V_PLAN_ID
        --        AND     STAGE  != 'ASY_AGING'
        --        GROUP BY  SCM_SITE_ID
        --                , ITEM_ID
        --                , STAGE
        --        ) ST
        --    ON  ADJ.SCM_SITE_ID = ST.SCM_SITE_ID
        --    AND ADJ.ITEM_ID     = ST.ITEM_ID
        --WHERE   ADJ.DIVISION_ID     = @V_DIVISION_ID
        --AND     ADJ.CUTOFF_YYYYMMDD = @V_PLAN_START_YYYYMMDD  -- PLAN 주차 기준.
        --AND     ADJ.INV_DATE >= @V_PLAN_START_YYYYMMDD
        --AND     ADJ.INV_DATE <  @V_PLAN_END_YYYYMMDD
        --;

        INSERT INTO GT_OPTENG_ESSIS_ADJ
        (
            SCM_SITE_ID
          , ITEM_ID
          , INCOTERMS
          , PROJECT_CODE
          , STOCK_TYPE
          , INV_DATE
          , STAGE
          , QTY
        )
        SELECT  A.SCM_SITE_ID
              , A.ITEM_ID
              , A.INCOTERMS
              , A.PROJECT_CODE
              , A.STOCK_TYPE
              , A.INV_DATE
              , CASE
                    WHEN SUBSTR(A.STOCK_TYPE, 1, 3) = 'FOR' THEN 'ASY_AGING'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'P9500'  AND S.SITE_TYPE = 'PLANT'  THEN 'LINK'
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'PL500'  AND S.SITE_TYPE = 'PLANT'  THEN 'LINK'       /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'P9500'  AND S.SITE_TYPE = 'SALES'  THEN 'LINKBIZ'
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'PL500'  AND S.SITE_TYPE = 'SALES'  THEN 'LINKBIZ'    /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'R5500'  AND S.SITE_TYPE = 'PLANT'  THEN 'RACK'
                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'R5500'  AND S.SITE_TYPE = 'SALES'  THEN 'RACKBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P9500'  AND S.SITE_TYPE = 'PLANT'  THEN 'PACK'
                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P9500'  AND S.SITE_TYPE = 'SALES'  THEN 'PACKBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P5500'  AND S.SITE_TYPE = 'PLANT'  THEN 'PACK'
                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P5500'  AND S.SITE_TYPE = 'SALES'  THEN 'PACKBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P9500'  AND S.SITE_TYPE = 'PLANT'  THEN 'PACK'
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P9500'  AND S.SITE_TYPE = 'PLANT'  THEN 'PACKBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END)
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'A' AND B.FLOW_ID = 'A9000'  AND S.SITE_TYPE = 'PLANT'  THEN 'CHAR'
                    WHEN B.OPERATION_GROUP_ID = 'A' AND B.FLOW_ID = 'A9000'  AND S.SITE_TYPE = 'SALES'  THEN 'CELLBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID NOT LIKE 'EP%'  AND S.SITE_TYPE = 'PLANT' THEN 'PACK'
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID NOT LIKE 'EP%'  AND S.SITE_TYPE = 'SALES' THEN 'PACKBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID LIKE 'EP%'  AND S.SITE_TYPE = 'PLANT'   THEN 'PACK'
                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID LIKE 'EP%'  AND S.SITE_TYPE = 'SALES'   THEN 'PACKBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    /* 2026.05.27 Minyong Lee ESS 사내 Pack Plant 추가로 SUBMDLE 관리 되도록 원복 */
                    WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND S.SITE_TYPE = 'PLANT' THEN 'SUBMDLE'
                    WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND S.SITE_TYPE = 'SALES' THEN 'SUBMDLEBIZ'
                    /*-------------------------------------------------------------------------------------------------------------------*/
                    ELSE '-'
                END                                                                         AS STAGE
              , A.CHG_QTY                                                                   AS QTY
          FROM  SCP_OPMZ_INV_ADJ A
                LEFT JOIN (
                            SELECT  DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
                              FROM  SCP_MST_FINAL_ITEM
                             WHERE  DIVISION_ID = V_DIVISION_ID
                               AND  OPERATION_GROUP IN ('A', 'P')
                          ) B
                   ON  A.ITEM_ID     = B.ITEM_ID
                  AND  A.DIVISION_ID = B.DIVISION_ID
                LEFT JOIN (
                            SELECT  DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM  SCM_MST_SITE
                          ) S
                   ON  A.SCM_SITE_ID = S.SCM_SITE_ID
                LEFT  JOIN (
                            SELECT  SM.DIVISION_ID
                                  , SM.SCM_SITE_ID
                                  , IM.ITEM_ID
                                  , IM.SCP_FLOW_ID
                                  , IM.SCP_OPERATION_GROUP
                              FROM  SCM_ITEM_M_SN IM
                                    INNER JOIN SCM_MST_SITE SM
                                       ON  IM.COMPANY_ID          = SM.COMPANY_ID
                                      AND  IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                             WHERE  1=1
                               AND  SM.SCM_SITE_ID||IM.ITEM_ID IN (
                                                SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                  FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                 WHERE  PLAN_ID = V_PLAN_ID
                                                )
                               AND  IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500')   /* SUBMDLE만 걸리도록 */
                               AND  IM.SCP_OPERATION_GROUP = 'P'               /* SUBMDLE만 걸리도록 */
                          ) SMC
                   ON  A.DIVISION_ID = SMC.DIVISION_ID
                  AND  A.SCM_SITE_ID = SMC.SCM_SITE_ID
                  AND  A.ITEM_ID     = SMC.ITEM_ID
         WHERE  A.DIVISION_ID     = V_DIVISION_ID
           AND  A.CUTOFF_YYYYMMDD = P_PLAN_START_YYYYMMDD   /* PLAN 주차 기준. */
           AND  A.INV_DATE       >= P_PLAN_START_YYYYMMDD
           AND  A.INV_DATE       <  P_PLAN_END_YYYYMMDD;

        /* 재고 / 해상재고 INPUT 생성 전 중간 정보 생성 PROC 참고
               PR_SCP_ENG_IN_PRE_SET_INVENTORY
               PR_SCP_ENG_IN_PRE_SET_INTRANSITSHIPMENTS */

        /* 1. 창고 재고 : WH */
        /* 1.1 SALES 재고 */
        INSERT INTO GT_OPTENG_ESSIS_INV
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
        SELECT  /* DISTINCT */
                A.DIVISION_ID                                                               AS DIVISION_ID
              , A.SCM_SITE_ID                                                               AS SCM_SITE_ID
              , '-'                                                                         AS INCOTERMS   /* 뒤에서 별도 UPDATE */
              , A.STOCK_TYPE
              , A.ITEM_ID
              /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              , CASE WHEN A.WIPHOLD_YN IS NULL                                        THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN A.WIPHOLD_YN = 'N'                                          THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME          THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     ELSE                                                                   TRUNC(A.AVAILABLE_DATE)
                END                                                                         AS AVAILABLE_DATE
              , A.SCM_QTY                                                                   AS QTY   /* SCP 사용 QTY */
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                     ELSE A.WIPHOLD_YN
                END                                                                         AS WIPHOLD_YN
              , B.SITE_TYPE
              , '-'                                                                         AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
              , '-'                                                                         AS PROJECT_CODE    /* 뒤에서 별도 UPDATE */
              , NVL(MSP.SCM_SITE_ID, '')                                                    AS CELL_PROD_SITE_ID
              , 'SALES'                                                                     AS FLAG
          FROM  SCM_DNM_STOCK A

                /* SITE ENG 에는 SALES SITE가 INCOTERMS 단위로 들어가 있어 DISTINCT 없이 SCM_SITE_ID 로 조인하면 뻥튀기 될 수 있음 */
                -- ,(SELECT DISTINCT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                --            FROM   SCM_MST_SITE  WITH(NOLOCK)
                --WHERE  1=1
                --            AND    SITE_TYPE        = 'SALES'
                --           ) B
                /* 소형 생산지 구분을 위한 분리 */
                INNER JOIN (SELECT  DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM  SCM_MST_SITE
                             WHERE  1=1
                               AND  SITE_TYPE = 'SALES'
                           ) B
                   ON  A.DIVISION_ID = B.DIVISION_ID
                  AND  A.SCM_SITE_ID = B.SCM_SITE_ID
                --INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                --    ON A.PLANT_ID = MS.PLANT_ID
                LEFT OUTER JOIN GT_OPTENG_ESSIS_OCV OCV
                   ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                  AND  A.MES_ITEM_ID = OCV.ITEM_ID
                LEFT OUTER JOIN GT_OPTENG_ESSIS_CPS CPS
                   ON  1=1
                  AND  A.SCM_SITE_ID = CPS.SALES_SITE_ID
                  AND  A.ITEM_ID     = CPS.ITEM_ID
                LEFT OUTER JOIN (SELECT  DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                   FROM  SCM_MST_SITE
                                  WHERE  1=1
                                    AND  PLANT_ID IS NOT NULL
                                ) MSP
                   ON  1=1
                  AND  A.DIVISION_ID = MSP.DIVISION_ID
                  AND  CASE WHEN A.PLANT_ID IS NULL OR CPS.OPERATION_GROUP IS NULL THEN NULL
                            ELSE A.PLANT_ID||CPS.OPERATION_GROUP
                       END = MSP.SCM_SITE_ID   /* 원문 A.PLANT_ID+CPS.OPERATION_GROUP 의 NULL 전파 유지 */
         WHERE  1 = 1
           AND  A.CUTOFF_DATE = V_CUTOFF_DAY
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  OCV.ITEM_ID   IS NULL
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND ((A.DIVISION_ID  = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                OR  (A.DIVISION_ID <> '40' )
               )
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND    A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
        --					 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --					 WHERE   PLAN_ID = @V_PLAN_ID
        --					 )
           AND (    (A.DIVISION_ID = '40' AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                                            FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                           WHERE  PLAN_ID = V_PLAN_ID
                                                                          )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT  DISTINCT ITEM_ID
                                                               FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE  PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* 원문 ALTER TABLE #SCP_INVENTORY_I ALTER COLUMN INCOTERMS/location_code/PROJECT_CODE VARCHAR(100) NULL
           -> GTT 가 이미 VARCHAR2(100 CHAR) NULL 이므로 대응 구문 없음 */

        /* 1.2 SO RESERVE STOCK : RESULT_TYPE = 'B' : 해상재고 대신 TO SITE의 재고로 처리 */
        INSERT INTO GT_OPTENG_ESSIS_INV
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
        SELECT  /* DISTINCT */
                A.DIVISION_ID                                                               AS DIVISION_ID
              , A.TO_SCM_SITE_ID                                                            AS SCM_SITE_ID
              , '-'                                                                         AS INCOTERMS   /* 뒤에서 별도 UPDATE */
              , 'SO'                                                                        AS STOCK_TYPE
              , A.ITEM_ID                                                                   AS ITEM_ID
              /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 ; BOH 처리용 1일 전 */
              /* 엔진 오류로 Plan 구간 안으로 처리 */
              --,CONVERT(DATETIME, @V_CUTOFF_DAY) AS AVAILABLE_DATE
              , TO_DATE(V_PLAN_NAME, 'YYYYMMDD')                                            AS AVAILABLE_DATE
              , A.DELIVERY_QTY                                                              AS QTY
              , 'N'                                                                         AS WIPHOLD_YN
              , B.SITE_TYPE
              , '-'                                                                         AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
              , CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END            AS PROJECT_CODE    /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
              , CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END            AS CELL_PROD_SITE_ID
              , 'SALES'                                                                     AS FLAG
          FROM  SCM_DNM_INTRANSIT_C A
                INNER JOIN (SELECT  DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM  SCM_MST_SITE
                             WHERE  1=1
                               AND  SITE_TYPE = 'SALES'
                           ) B
                   ON  1=1
                  AND  A.DIVISION_ID    = B.DIVISION_ID
                  AND  A.TO_SCM_SITE_ID = B.SCM_SITE_ID
                LEFT OUTER JOIN GT_OPTENG_ESSIS_CPS CPS
                   ON  1=1
                  AND  A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                  AND  A.ITEM_ID        = CPS.ITEM_ID
         WHERE  1 = 1
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  A.RESULT_DATE = V_CUTOFF_DAY
           /* SO Reserve Stock : result_type = 'B' 는 재고로 처리 */
           AND  A.RESULT_TYPE = 'B'
           AND  A.VALID_YN    = 'Y'   /* 해상재고 */
           /* 소형은 CEll Biz 용 Demand 만 처리 */
           AND ((A.DIVISION_ID  = '40' AND FN_GET_ITEM_OPERATION_GROUP(A.DIVISION_ID, A.ITEM_ID) <> 'P')
                OR  (A.DIVISION_ID <> '40' )
               )
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --       FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --       WHERE   PLAN_ID = @V_PLAN_ID
        --       )
        /* 소형 생산지 구분을 위한 분리 */
           AND (    (A.DIVISION_ID = '40' AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                                                  FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                 WHERE  PLAN_ID = V_PLAN_ID
                                                                                )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT  DISTINCT ITEM_ID
                                                               FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE  PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* 1.3 SALES 재고 : INCOTERMS UPDATE
           원문 UPDATE..FROM + LEFT JOIN 2개 -> ROWID 기준 MERGE
           (B 는 SCM_SITE_ID+ITEM_ID, C 는 SCM_SITE_ID 단위 집계라 각각 1행만 맞는다) */
        MERGE INTO GT_OPTENG_ESSIS_INV A
        USING (
               SELECT  IA.RID
                     , NVL(NVL(B.MAX_INCOTERMS, C.MAX_INCOTERMS), 'DAP')                    AS NEW_INCOTERMS   /* DEMAND 없는 경우 DAP 처리 */
                 FROM (SELECT  ROWID AS RID
                             , SCM_SITE_ID
                             , ITEM_ID
                         FROM  GT_OPTENG_ESSIS_INV
                        WHERE  1=1
                          AND  SITE_TYPE = 'SALES'
                      ) IA
                      LEFT JOIN ( SELECT  AA.SCM_SITE_ID, AA.ITEM_ID
                                        /* VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) */
                                        , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP'
                                                   ELSE AA.INCOTERMS
                                              END ) MAX_INCOTERMS
                                    FROM  DM_PLN_NET_DEMAND AA
                                          INNER JOIN (SELECT  SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                        FROM  DM_PLN_NET_DEMAND
                                                       WHERE  DIVISION_ID     = V_DIVISION_ID
                                                         AND  CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                                       GROUP BY SCM_SITE_ID
                                                     ) BB
                                             ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                                            AND  AA.VERSION_NO      = BB.MAX_VERSION_NO
                                            AND  AA.DIVISION_ID     = V_DIVISION_ID
                                            AND  AA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                          LEFT JOIN ( SELECT  DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                        FROM  SCM_MST_SITE
                                                       WHERE  DIVISION_ID = V_DIVISION_ID
                                                         AND  VMI_YN      = 'Y'
                                                    ) CC
                                             ON  AA.DIVISION_ID = CC.DIVISION_ID
                                            AND  AA.SCM_SITE_ID = CC.SCM_SITE_ID
                                   GROUP BY AA.SCM_SITE_ID, AA.ITEM_ID
                                ) B
                         ON  IA.SCM_SITE_ID = B.SCM_SITE_ID
                        AND  IA.ITEM_ID     = B.ITEM_ID
                      LEFT JOIN ( SELECT  AA.SCM_SITE_ID
                                        /* VMI 는 'DAP'로 처리 ( 참고 : DAP 처리시 DEMAND  'DAP' 처리 부분도 함께 수정해야 함) */
                                        , MAX(CASE WHEN CC.VMI_YN = 'Y' THEN 'DAP'
                                                   ELSE AA.INCOTERMS
                                              END ) MAX_INCOTERMS
                                    FROM  DM_PLN_NET_DEMAND AA
                                          INNER JOIN (SELECT  SCM_SITE_ID, MAX(VERSION_NO) MAX_VERSION_NO
                                                        FROM  DM_PLN_NET_DEMAND
                                                       WHERE  DIVISION_ID     = V_DIVISION_ID
                                                         AND  CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY   /* @V_DEMAND_CUTOFF_DAY 는 화요일 일자(YYYYMMDD) */
                                                       GROUP BY SCM_SITE_ID
                                                     ) BB
                                             ON  AA.SCM_SITE_ID     = BB.SCM_SITE_ID
                                            AND  AA.VERSION_NO      = BB.MAX_VERSION_NO
                                            AND  AA.DIVISION_ID     = V_DIVISION_ID
                                            AND  AA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
                                          LEFT JOIN ( SELECT  DIVISION_ID, SCM_SITE_ID, VMI_YN
                                                        FROM  SCM_MST_SITE
                                                       WHERE  DIVISION_ID = V_DIVISION_ID
                                                         AND  VMI_YN      = 'Y'
                                                    ) CC
                                             ON  AA.DIVISION_ID = CC.DIVISION_ID
                                            AND  AA.SCM_SITE_ID = CC.SCM_SITE_ID
                                   GROUP BY AA.SCM_SITE_ID
                                ) C
                         ON  IA.SCM_SITE_ID = C.SCM_SITE_ID
              ) XA
           ON (A.ROWID = XA.RID)
        WHEN MATCHED THEN
            UPDATE SET A.INCOTERMS = XA.NEW_INCOTERMS;

        /* 1.4 PLANT 재고 */
        INSERT INTO GT_OPTENG_ESSIS_INV
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
        SELECT  A.DIVISION_ID                                                               AS DIVISION_ID
              , A.SCM_SITE_ID                                                               AS SCM_SITE_ID
              , '-'                                                                         AS INCOTERMS
              , A.STOCK_TYPE
              , A.ITEM_ID
              /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
              --,CASE WHEN ISNULL(A.WIPHOLD_YN, '') = ''                        THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              --      WHEN A.WIPHOLD_YN             = 'N'                       THEN CONVERT(DATETIME, @V_CUTOFF_DAY) -- BOH 처리용 1일 전
              , CASE WHEN A.WIPHOLD_YN IS NULL                                        THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN A.WIPHOLD_YN = 'N'                                          THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')   /* 엔진 오류로 Plan 구간 안으로 처리 */
                     WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME          THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     ELSE                                                                   TRUNC(A.AVAILABLE_DATE)
                END                                                                         AS AVAILABLE_DATE
              , A.SCM_QTY                                                                   AS QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                     ELSE A.WIPHOLD_YN
                END                                                                         AS WIPHOLD_YN
              , B.SITE_TYPE
              , CASE WHEN OP.LOCATION_CODE IS NOT NULL OR ST.LOCATION_CODE IS NOT NULL THEN 'ASSY'
                     ELSE '-'
                END                                                                         AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
              , ''                                                                          AS PROJECT_CODE
              , ''                                                                          AS CELL_PROD_SITE_ID
              , 'PLANT'                                                                     AS FLAG
          FROM  SCM_DNM_STOCK A
                INNER JOIN (SELECT  DISTINCT DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM  SCM_MST_SITE
                             WHERE  1=1
                               AND  DIVISION_ID = V_DIVISION_ID
                               AND  SITE_TYPE   = 'PLANT'
                               --AND    OPERATION_GROUP IN ('A', 'P')
                               AND ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') )      /* 소형은 CEll Biz 용 Demand 만 처리 : 소형 Pack 제외 */
                                    OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                   )
                           ) B
                   ON  A.DIVISION_ID = B.DIVISION_ID
                  AND  A.SCM_SITE_ID = B.SCM_SITE_ID
                LEFT JOIN (  SELECT  DISTINCT
                                     A.OPERATION_ID
                                   , A.LOCATION_CODE
                                   , A.SCM_SITE_ID
                               FROM  SCM_MST_LOCATION A
                                     INNER JOIN (SELECT  SCM_SITE_ID
                                                   FROM  SCM_MST_SITE
                                                  WHERE  DIVISION_ID     = V_DIVISION_ID
                                                    AND  VALID_YN        = 'Y'
                                                    AND  OPERATION_GROUP IN ( 'A' )
                                                ) B
                                        ON  A.SCM_SITE_ID = B.SCM_SITE_ID
                              WHERE  A.DIVISION_ID  = V_DIVISION_ID   --'81'
                                AND  A.VALID_YN     = 'Y'
                                AND  A.LOCATION_CODE = 'PACKAGING'    /* 활성화 전 재고 */
                                AND  A.OPERATION_ID IS NOT NULL       /* 원문 (operation_id IS NOT NULL AND operation_id <> '') — Oracle 은 '' 가 NULL */
                           ) OP   /* 셀의 operation_id 별 사용대상 조회 */
                   ON  A.OPERATION_ID = OP.OPERATION_ID
                  AND  A.SCM_SITE_ID  = OP.SCM_SITE_ID
                LEFT JOIN (  SELECT  DISTINCT
                                     A.STORAGE_ID
                                   , A.LOCATION_CODE
                                   , A.SCM_SITE_ID
                               FROM  SCM_MST_LOCATION A
                                     INNER JOIN (SELECT  SCM_SITE_ID
                                                   FROM  SCM_MST_SITE
                                                  WHERE  DIVISION_ID     = V_DIVISION_ID
                                                    AND  VALID_YN        = 'Y'
                                                    AND  OPERATION_GROUP IN ( 'A' )
                                                ) B
                                        ON  A.SCM_SITE_ID = B.SCM_SITE_ID
                              WHERE  A.DIVISION_ID  = V_DIVISION_ID   --'81'
                                AND  A.VALID_YN     = 'Y'
                                AND  A.LOCATION_CODE = 'PACKAGING'    /* 활성화 전 재고 */
                                AND  A.STORAGE_ID   IS NOT NULL       /* 원문 (storage_id IS NOT NULL AND storage_id <> '') — Oracle 은 '' 가 NULL */
                           ) ST   /* 셀의 storage_id 별 사용대상 조회 */
                   ON  A.STORAGE_ID  = ST.STORAGE_ID
                  AND  A.SCM_SITE_ID = ST.SCM_SITE_ID
                /* 소형 생산지 구분을 위한 분리 */
                --INNER JOIN SCM_MST_SITE MS WITH(NOLOCK)
                --    ON A.PLANT_ID = MS.PLANT_ID
                LEFT OUTER JOIN GT_OPTENG_ESSIS_OCV OCV
                   ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                  AND  A.MES_ITEM_ID = OCV.ITEM_ID
         WHERE  1 = 1
           AND  A.CUTOFF_DATE = V_CUTOFF_DAY
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  OCV.ITEM_ID   IS NULL
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
          --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
          --			 FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
          --			 WHERE   PLAN_ID = @V_PLAN_ID
          --			 )
        /* 소형 생산지 구분을 위한 분리 */
           AND (    (A.DIVISION_ID = '40' AND B.SCM_SITE_ID||A.ITEM_ID IN (SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                                            FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                           WHERE  PLAN_ID = V_PLAN_ID
                                                                          )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT  DISTINCT ITEM_ID
                                                               FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE  PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* 2. 활성화 재고 : FOR */
        /* 2026.05.08 Minyong Lee : 활성화 재고 뷰 중복 스캔 제거 (쿼리 수행 시간 단축) */
        INSERT INTO GT_OPTENG_ESSIS_INV
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
        WITH BASE_STOCK AS (
            SELECT  SA.*
                  , MAX(SA.CUTOFF_DATE) OVER (PARTITION BY SA.DIVISION_ID, SA.SITE_ID)      AS MAX_CUTOFF_DATE
              FROM  SCM_DNM_STOCK_AGING_V SA
             WHERE  SA.DIVISION_ID = V_DIVISION_ID
               AND  SA.CUTOFF_DATE >  V_D_CUTOFF_DAY - 7   /* C의 조건을 여기서 한번에 처리 */
               AND  SA.CUTOFF_DATE <= V_D_CUTOFF_DAY
        )
        SELECT  A.DIVISION_ID                                                               AS DIVISION_ID
              , A.SCM_SITE_ID                                                               AS SCM_SITE_ID
              , '-'                                                                         AS INCOTERMS
              , 'FOR'                                                                       AS STOCK_TYPE
              , A.ITEM_ID
              /* Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
              , CASE WHEN TO_CHAR(A.AVAILABLE_DATE, 'YYYYMMDD') < V_PLAN_NAME                      THEN TO_DATE(V_PLAN_NAME, 'YYYYMMDD')
                     WHEN A.DIVISION_ID = '40' AND MF.ADD_LT_FORMATION IS NOT NULL                 THEN A.AVAILABLE_DATE + MF.ADD_LT_FORMATION   /* 소형인 경우 ADD_FORMATION_LT를 재고 일수에 추가 */
                     ELSE A.AVAILABLE_DATE
                END                                                                         AS AVAILABLE_DATE
              , A.QTY                                                                       AS QTY
              , CASE WHEN A.WIPHOLD_YN IS NULL THEN 'N'
                     ELSE A.WIPHOLD_YN
                END                                                                         AS WIPHOLD_YN
              , 'PLANT'                                                                     AS SITE_TYPE
              , '-'                                                                         AS LOCATION_CODE   /* PLANT 재고 구분용 정보 */
              , ''                                                                          AS PROJECT_CODE
              , ''                                                                          AS CELL_PROD_SITE_ID
              , 'PLANT'                                                                     AS FLAG
          FROM (
                SELECT  A.*
                  FROM  BASE_STOCK A
                 WHERE  A.CUTOFF_DATE = A.MAX_CUTOFF_DATE
                   AND  A.ITEM_ID IN (SELECT  DISTINCT ITEM_ID
                                        FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                       WHERE  PLAN_ID = V_PLAN_ID
                                      )
               ) A
                /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경 */
                LEFT JOIN ( SELECT  DIVISION_ID, SCM_SITE_ID, SITE_TYPE
                              FROM  SCM_MST_SITE
                             WHERE  1=1
                               AND  DIVISION_ID       = V_DIVISION_ID
                               AND  SITE_TYPE         = 'PLANT'
                               AND  NVL(OSP_YN, 'N')  = 'N'   /* 20180822 추가 */
                          ) B
                   ON  A.SCM_SITE_ID = B.SCM_SITE_ID
                LEFT OUTER JOIN SCP_MST_FORMATION_V MF
                   ON  A.DIVISION_ID = MF.DIVISION_ID
                  AND  A.SCM_SITE_ID = MF.PLANT_SITE_ID
                  AND  A.ITEM_ID     = MF.ITEM_ID
         WHERE  B.DIVISION_ID IS NOT NULL;   /* 속도개선을 위해서 INNER JOIN => LEFT JOIN으로 변경때문에 조건추가함 */

        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --                   )

        /* 3. 해상 재고 : INT */
        /* 3.1 RESULT_TYPE  IN ('I', 'C') -- ERP 해상재고, 법인간 재고
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' / 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
        INSERT INTO GT_OPTENG_ESSIS_INT
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
        SELECT  A.DIVISION_ID                                                               AS DIVISION_ID
              , A.ITEM_ID
              , A.TO_SCM_SITE_ID                                                            AS TO_SCM_SITE_ID
              , A.FINAL_INCOTERMS                                                           AS INCOTERMS
                /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
              , CASE WHEN A.ETA_DATE < V_PLAN_NAME THEN V_PLAN_NAME
                     ELSE A.ETA_DATE
                END                                                                         AS ETA_DATE
              , A.DELIVERY_QTY
              --,IIF(A.PROJECT_CODE ='','-',PROJECT_CODE) AS PROJECT_CODE -- 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT
              , CASE WHEN TS.SITE_TYPE = 'SALES' AND A.RESULT_TYPE = 'C' THEN '-'   /* 법인간 이동 재고에는 Project Code 정보가 없음 */
                     WHEN TS.SITE_TYPE = 'SALES' THEN (CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END)
                     WHEN TS.SITE_TYPE = 'PLANT' THEN ''   /* Plant 도착은 NULL 처리 */
                     ELSE (CASE WHEN A.PROJECT_CODE IS NULL THEN '-' ELSE A.PROJECT_CODE END)
                END                                                                         AS PROJECT_CODE   /* 없는 건 '-'처리 후 뒤에서 별도 없데이트, 있는건 그대로 INSERT */
              , CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE A.FROM_SCM_SITE_ID END            AS CELL_PROD_SITE_ID
              , TS.SITE_TYPE                                                                AS FLAG
          FROM  SCM_DNM_INTRANSIT_V A
                INNER JOIN (SELECT  DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP_ID FROM SCM_MST_FINAL_ITEM_V) FI
                   ON  A.DIVISION_ID          = FI.DIVISION_ID
                  AND  A.ITEM_ID              = FI.ITEM_ID
                  AND  FI.OPERATION_GROUP_ID <> 'E'   /* 전극 모델은 제외 */
                INNER JOIN (SELECT  DIVISION_ID, SCM_SITE_ID, OPERATION_GROUP
                              FROM  SCM_MST_SITE
                             WHERE  DIVISION_ID = V_DIVISION_ID
                               AND  SITE_TYPE   = 'PLANT'
                               AND  OPERATION_GROUP IN ('A', 'P')   /* FROM_SITE 가 전극인 정보 제외 */
                               AND  VALID_YN    = 'Y'
                           ) FS
                   ON  A.DIVISION_ID      = FS.DIVISION_ID
                  AND  A.FROM_SCM_SITE_ID = FS.SCM_SITE_ID
                  AND ((FS.DIVISION_ID  = '40' AND FS.OPERATION_GROUP = 'A' )      /* 소형은 CEll Biz 용 Demand 만 처리 */
                       OR  (FS.DIVISION_ID <> '40' )
                      )
                INNER JOIN SCM_MST_SITE TS
                   ON  A.DIVISION_ID    = TS.DIVISION_ID
                  AND  A.TO_SCM_SITE_ID = TS.SCM_SITE_ID
                  --AND TS.SITE_TYPE      = 'SALES'
                  AND  TS.VALID_YN      = 'Y'
                  AND ((TS.DIVISION_ID  = '40' AND TS.SITE_TYPE = 'SALES' )      /* 소형은 CEll Biz 용 Demand 만 처리 */
                       OR  (TS.DIVISION_ID <> '40' )
                      )
                LEFT OUTER JOIN GT_OPTENG_ESSIS_CPS CPS
                   ON  1=1
                  AND  A.TO_SCM_SITE_ID = CPS.SALES_SITE_ID
                  AND  A.ITEM_ID        = CPS.ITEM_ID
         WHERE  1=1
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  A.RESULT_DATE = V_CUTOFF_DAY
           AND  A.RESULT_TYPE IN ('I', 'C')   /* ERP 해상재고, 법인간 재고 - 속도 이슈로 'TO SITE가 VMI 정보 생성 : SCM_MST_VMI_INT_SLOC MAPPING 된 것' 정보는 아래서 별도 처리 */
        /*************************
        대상 프로젝트 ITEM 필터링
        *************************/
        --AND A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
        --                   FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
        --                   WHERE   PLAN_ID = @V_PLAN_ID
        --				 )
        /* 소형 생산지 구분을 위한 분리 */
           AND (    (A.DIVISION_ID = '40' AND A.FROM_SCM_SITE_ID||A.ITEM_ID IN (SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                                                  FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                 WHERE  PLAN_ID = V_PLAN_ID
                                                                                )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT  DISTINCT ITEM_ID
                                                               FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE  PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* 원문 ALTER TABLE #SCP_INTRANSIT_I ALTER COLUMN PROJECT_CODE VARCHAR(100) NULL
           -> GTT 가 이미 VARCHAR2(100 CHAR) NULL 이므로 대응 구문 없음 */

        /* 3.2 TO SITE가 VMI 정보 : SCM_MST_VMI_INT_SLOC MAPPING 된 것
              - 속도 이슈로 VIEW 내의 RESULT_TYPE = 'V' 사용하지 않고 동일 로직으로 별도 처리함 */
        INSERT INTO GT_OPTENG_ESSIS_INT
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
              , MS.SCM_SITE_ID                                                              AS TO_SCM_SITE_ID
              , 'DAP'                                                                       AS INCOTERMS   /* VMI 임 */
              /* 도착 예정일자 : Plan Start 이전 일자는 PLANT START DATE  INPUT 요청 */
              , TO_CHAR(TO_DATE(A.CUTOFF_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD')                 AS ETA_DATE    /* PLAN 시작일자로 처리 */
              , NVL(A.SCM_QTY, 0)                                                           AS DELIVERY_QTY
              , '-'                                                                         AS PROJECT_CODE
              , NVL(MSP.SCM_SITE_ID, '')                                                    AS CELL_PROD_SITE_ID
              , 'SALES'                                                                     AS FLAG
          FROM  SCM_DNM_STOCK A
                INNER JOIN SCM_MST_VMI_INT_SLOC MS
                   ON  A.DIVISION_ID = MS.DIVISION_ID
                  AND  A.PLANT_ID    = MS.PLANT_ID
                  AND  A.STORAGE_ID  = MS.STORAGE_ID
                  AND  MS.VALID_YN   = 'Y'
                /* 소형 생산지 구분을 위한 분리 */
                INNER JOIN SCM_MST_SITE MSS
                   ON  A.PLANT_ID = MSS.PLANT_ID
                LEFT OUTER JOIN GT_OPTENG_ESSIS_OCV OCV
                   ON  A.SCM_SITE_ID = OCV.SCM_SITE_ID
                  AND  A.MES_ITEM_ID = OCV.ITEM_ID
                LEFT OUTER JOIN GT_OPTENG_ESSIS_CPS CPS
                   ON  1=1
                  AND  A.SCM_SITE_ID = CPS.SALES_SITE_ID
                  AND  A.ITEM_ID     = CPS.ITEM_ID
                LEFT OUTER JOIN (SELECT  DISTINCT DIVISION_ID, SCM_SITE_ID, PLANT_ID
                                   FROM  SCM_MST_SITE
                                  WHERE  1=1
                                    AND  PLANT_ID IS NOT NULL
                                ) MSP
                   ON  1=1
                  AND  A.DIVISION_ID = MSP.DIVISION_ID
                  AND  CASE WHEN A.PLANT_ID IS NULL OR CPS.OPERATION_GROUP IS NULL THEN NULL
                            ELSE A.PLANT_ID||CPS.OPERATION_GROUP
                       END = MSP.SCM_SITE_ID   /* 원문 A.PLANT_ID+CPS.OPERATION_GROUP 의 NULL 전파 유지 */
         WHERE  1 = 1
           AND  A.CUTOFF_DATE = V_CUTOFF_DAY
           AND  A.DIVISION_ID = V_DIVISION_ID
           AND  OCV.ITEM_ID   IS NULL
           /* 소형은 CEll Biz 용 Demand 만 처리 */
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
        /* 소형 생산지 구분을 위한 분리 */
           AND (    (A.DIVISION_ID = '40' AND MSS.SCM_SITE_ID||A.ITEM_ID IN (SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                                              FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                             WHERE  PLAN_ID = V_PLAN_ID
                                                                            )
                    )
                 OR (A.DIVISION_ID != '40' AND A.ITEM_ID IN (SELECT  DISTINCT ITEM_ID
                                                               FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                              WHERE  PLAN_ID = V_PLAN_ID
                                                             )
                    )
               );

        /* UPDATE PROJECT */
            /* INCOTERMS가 있는 DM정보와, 없는 DM정보를 각각 가져옴 -> DUE DATE가 가장 빠른 날짜 기준 */
            INSERT INTO GT_OPTENG_ESSIS_DM
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
                          , ROW_NUMBER() OVER( PARTITION BY SITE_ID, ITEM_ID, INCOTERMS, PROJECT_CODE ORDER BY MIN_DUE NULLS FIRST ) AS ROW_NUM
                      FROM (
                            SELECT  ATTRIBUTE1                                              AS SITE_ID
                                  , ATTRIBUTE2                                              AS ITEM_ID
                                  , ATTRIBUTE4                                              AS INCOTERMS
                                  , ATTRIBUTE5                                              AS PROJECT_CODE
                                  , MIN(DUE_DATE)                                           AS MIN_DUE
                              FROM  SCP_OPT_ENG_DEMAND_SN
                             WHERE  PLAN_ID = V_PLAN_ID
                               AND  ATTRIBUTE5 IS NOT NULL   /* PROJECT_CODE */
                               AND  ATTRIBUTE4 IS NOT NULL   /* INCOTERMS */
                             GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE4, ATTRIBUTE5
                           ) DM
                   ) RM
             WHERE  ROW_NUM = 1
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
                          , ROW_NUMBER() OVER( PARTITION BY SITE_ID, ITEM_ID, PROJECT_CODE ORDER BY MIN_DUE NULLS FIRST ) AS ROW_NUM
                      FROM (
                            SELECT  ATTRIBUTE1                                              AS SITE_ID
                                  , ATTRIBUTE2                                              AS ITEM_ID
                                  , NULL                                                    AS INCOTERMS
                                  , ATTRIBUTE5                                              AS PROJECT_CODE
                                  , MIN(DUE_DATE)                                           AS MIN_DUE
                              FROM  SCP_OPT_ENG_DEMAND_SN
                             WHERE  PLAN_ID = V_PLAN_ID
                               AND  ATTRIBUTE5 IS NOT NULL
                               AND  ATTRIBUTE4 IS NULL
                             GROUP BY ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE5
                           ) DM
                   ) RM
             WHERE  ROW_NUM = 1;

            /* #SCP_INVENTORY_I 프로젝트 UPDATE
               원문 UPDATE..FROM + INNER JOIN -> MERGE. 조인 열쇠가 겹쳐 2행 이상 맞을 수 있어 MAX(PROJECT_CODE) 로 한 행으로 좁힌다 */
            MERGE INTO GT_OPTENG_ESSIS_INV INV
            USING (
                   SELECT  DIVISION_ID
                         , SCM_SITE_ID
                         , INCOTERMS
                         , STOCK_TYPE
                         , ITEM_ID
                         , AVAILABLE_DATE
                         , QTY
                         , WIPHOLD_YN
                         , SITE_TYPE
                         , LOCATION_CODE
                         , MAX(PROJECT_CODE)                                                AS PROJECT_CODE
                     FROM (
                           SELECT  IA.DIVISION_ID
                                 , IA.SCM_SITE_ID
                                 , IA.INCOTERMS
                                 , IA.STOCK_TYPE
                                 , IA.ITEM_ID
                                 , IA.MDF_ITEM_ID
                                 , IA.AVAILABLE_DATE
                                 , IA.QTY
                                 , IA.WIPHOLD_YN
                                 , IA.SITE_TYPE
                                 , IA.LOCATION_CODE
                                 , DT.PROJECT_CODE
                             FROM (
                                   SELECT  INV.DIVISION_ID
                                         , INV.SCM_SITE_ID
                                         , INV.INCOTERMS
                                         , INV.STOCK_TYPE
                                         , INV.ITEM_ID
                                         , CASE WHEN LU.SEGMENT3 IS NULL THEN INV.ITEM_ID ELSE LU.SEGMENT4 END AS MDF_ITEM_ID
                                         , INV.AVAILABLE_DATE
                                         , INV.QTY
                                         , INV.WIPHOLD_YN
                                         , INV.SITE_TYPE
                                         , INV.LOCATION_CODE
                                     FROM  GT_OPTENG_ESSIS_INV INV
                                           LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                              ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                             AND  LU.SEGMENT2    = V_DIVISION_ID
                                             AND  INV.ITEM_ID    = LU.SEGMENT3
                                             AND  LU.VALID_YN    = 'Y'
                                    WHERE  INV.FLAG         = 'SALES'
                                      AND  INV.PROJECT_CODE = '-'
                                      AND  INV.QTY          > 0
                                  ) IA
                                  INNER JOIN GT_OPTENG_ESSIS_DM DT
                                     ON  IA.SCM_SITE_ID = DT.SITE_ID
                                    AND  IA.MDF_ITEM_ID = DT.ITEM_ID
                                    AND (   (IA.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                         OR (IA.INCOTERMS = DT.INCOTERMS)
                                         OR (IA.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                        )
                          )
                    GROUP BY DIVISION_ID, SCM_SITE_ID, INCOTERMS, STOCK_TYPE, ITEM_ID, AVAILABLE_DATE, QTY, WIPHOLD_YN, SITE_TYPE, LOCATION_CODE
                  ) DJ
               ON (    INV.DIVISION_ID    = DJ.DIVISION_ID
                   AND INV.SCM_SITE_ID    = DJ.SCM_SITE_ID
                   AND INV.INCOTERMS      = DJ.INCOTERMS
                   AND INV.STOCK_TYPE     = DJ.STOCK_TYPE
                   AND INV.ITEM_ID        = DJ.ITEM_ID
                   AND INV.AVAILABLE_DATE = DJ.AVAILABLE_DATE
                   AND INV.QTY            = DJ.QTY
                   AND INV.WIPHOLD_YN     = DJ.WIPHOLD_YN
                   AND INV.SITE_TYPE      = DJ.SITE_TYPE
                   AND INV.LOCATION_CODE  = DJ.LOCATION_CODE )
            WHEN MATCHED THEN
                UPDATE SET INV.PROJECT_CODE = DJ.PROJECT_CODE;

            /* #SCP_INTRANSIT_I 프로젝트 UPDATE
               원문 UPDATE..FROM + INNER JOIN -> MERGE. 조인 열쇠가 겹쳐 2행 이상 맞을 수 있어 MAX(PROJECT_CODE) 로 한 행으로 좁힌다 */
            MERGE INTO GT_OPTENG_ESSIS_INT INV
            USING (
                   SELECT  DIVISION_ID
                         , ITEM_ID
                         , TO_SCM_SITE_ID
                         , INCOTERMS
                         , ETA_DATE
                         , DELIVERY_QTY
                         , FLAG
                         , MAX(PROJECT_CODE)                                                AS PROJECT_CODE
                     FROM (
                           SELECT  IA.DIVISION_ID
                                 , IA.ITEM_ID
                                 , IA.TO_SCM_SITE_ID
                                 , IA.INCOTERMS
                                 , IA.ETA_DATE
                                 , IA.DELIVERY_QTY
                                 , IA.FLAG
                                 , DT.PROJECT_CODE
                             FROM (
                                   SELECT  INV.DIVISION_ID
                                         , INV.ITEM_ID
                                         , CASE WHEN LU.SEGMENT3 IS NULL THEN INV.ITEM_ID ELSE LU.SEGMENT4 END AS MDF_ITEM_ID
                                         , INV.TO_SCM_SITE_ID
                                         , INV.INCOTERMS
                                         , INV.ETA_DATE
                                         , INV.DELIVERY_QTY
                                         , INV.PROJECT_CODE
                                         , INV.FLAG
                                     FROM  GT_OPTENG_ESSIS_INT INV   /* WHERE PROJECT_CODE = '-' AND FLAG ='SALES' */
                                           LEFT OUTER JOIN SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                              ON  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                             AND  LU.SEGMENT2    = V_DIVISION_ID
                                             AND  INV.ITEM_ID    = LU.SEGMENT3
                                             AND  LU.VALID_YN    = 'Y'
                                    WHERE  INV.FLAG         = 'SALES'
                                      AND  INV.PROJECT_CODE = '-'
                                      AND  INV.DELIVERY_QTY > 0
                                  ) IA
                                  INNER JOIN GT_OPTENG_ESSIS_DM DT
                                     ON  IA.TO_SCM_SITE_ID = DT.SITE_ID
                                    AND  IA.MDF_ITEM_ID    = DT.ITEM_ID
                                    AND (   (IA.INCOTERMS IS NULL AND DT.INCOTERMS IS NULL)
                                         OR (IA.INCOTERMS = DT.INCOTERMS)
                                         OR (IA.INCOTERMS IS NOT NULL AND DT.INCOTERMS IS NULL)
                                        )
                          )
                    GROUP BY DIVISION_ID, ITEM_ID, TO_SCM_SITE_ID, INCOTERMS, ETA_DATE, DELIVERY_QTY, FLAG
                  ) DJ
               ON (    INV.DIVISION_ID    = DJ.DIVISION_ID
                   AND INV.ITEM_ID        = DJ.ITEM_ID
                   AND INV.TO_SCM_SITE_ID = DJ.TO_SCM_SITE_ID
                   AND INV.INCOTERMS      = DJ.INCOTERMS
                   AND INV.ETA_DATE       = DJ.ETA_DATE
                   AND INV.DELIVERY_QTY   = DJ.DELIVERY_QTY
                   AND INV.FLAG           = DJ.FLAG )
            WHEN MATCHED THEN
                UPDATE SET INV.PROJECT_CODE = DJ.PROJECT_CODE;

          /* CA별 CP 정보 */
          INSERT INTO GT_OPTENG_ESSIS_CP
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
                                         ORDER BY M.VALID_YN    DESC NULLS LAST
                                                , M.ITEM_ID_PROD     NULLS FIRST) PRIORITY_1ST
                , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID
                                                , M.ITEM_ID_ASSY
                                         ORDER BY M.VALID_YN    DESC NULLS LAST
                                                , M.ITEM_ID_PROD     NULLS FIRST) PRIORITY_2ND
                , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
                                         ORDER BY M.VALID_YN    DESC NULLS LAST
                                                , M.ITEM_ID_PROD     NULLS FIRST) PRIORITY_3RD
            FROM  SCP_MST_CELL_PROD_ASSY_MAP M
           WHERE  1=1
             AND  M.VALID_YN = 'Y';

        /* INCOMING STOCK INSERT */
        /* 2025.07.10 Philsu Park: 재고 보정 대상 데이터는 별도 Insert 하기 때문에 제외 처리. */
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
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  PLAN_ID
              , STOCK_ID
              , BUFFER_ID
              , EFECTIVE_DATE
              , TYPE
              , SUM(QUANTITY)                                                               AS QUANTITY
              , SITE_ID
              , ITEM_ID
              , STAGE
              , INCOTERMS
              , PROJECT_CODE
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
          FROM (
                SELECT  V_PLAN_ID                                                           AS PLAN_ID
                      , TYPE||'::'||SITE_ID||'::'||ITEM_ID||'::'||STAGE
                        ||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END
                        ||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END
                        ||'::'||EFECTIVE_DATE
                        ||CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::'||CELL_PROD_SITE_ID END  AS STOCK_ID
                      , SITE_ID||'::'||ITEM_ID||'::'||STAGE
                        ||CASE WHEN INCOTERMS = '-' THEN '' ELSE '@'||INCOTERMS END
                        ||CASE WHEN PROJECT_CODE IS NULL THEN '' ELSE '@'||PROJECT_CODE END
                        ||CASE WHEN CELL_PROD_SITE_ID IS NULL THEN '' ELSE '::'||CELL_PROD_SITE_ID END  AS BUFFER_ID
                      , EFECTIVE_DATE                                                       AS EFECTIVE_DATE
                      , TYPE                                                                AS TYPE
                      , QTY                                                                 AS QUANTITY
                      , SITE_ID                                                             AS SITE_ID
                      , ITEM_ID                                                             AS ITEM_ID
                      , STAGE                                                               AS STAGE
                      , INCOTERMS                                                           AS INCOTERMS
                      , PROJECT_CODE                                                        AS PROJECT_CODE
                  FROM (
                        SELECT  A.SCM_SITE_ID                                               AS SITE_ID
                              --, A.ITEM_ID AS ITEM_ID
                              , CASE   /* 활성화 완료 ASSY Item 재고 : 'CHAR' 버퍼 재고로 처리하고 CHAR Item 으로 Update 처리함 */
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'WH%' AND A.LOCATION_CODE = '-'
                                         THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), A.ITEM_ID)
                                    ELSE A.ITEM_ID
                                END ITEM_ID
                              , CASE
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'P9500'  AND A.FLAG = 'PLANT'  THEN 'LINK'
                                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'PL500'  AND A.FLAG = 'PLANT'  THEN 'LINK'       /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'P9500'  AND A.FLAG = 'SALES'  THEN 'LINKBIZ'
                                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'PL500'  AND A.FLAG = 'SALES'  THEN 'LINKBIZ'    /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'R5500'  AND A.FLAG = 'PLANT'  THEN 'RACK'
                                    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID = 'R5500'  AND A.FLAG = 'SALES'  THEN 'RACKBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P9500'  AND A.FLAG = 'PLANT'  THEN 'PACK'
                                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P9500'  AND A.FLAG = 'SALES'  THEN 'PACKBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P5500'  AND A.FLAG = 'PLANT'  THEN 'PACK'
                                    WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID = 'P5500'  AND A.FLAG = 'SALES'  THEN 'PACKBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P9500'  AND A.FLAG = 'PLANT'  THEN 'PACK'
                                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P9500'  AND A.FLAG = 'PLANT'  THEN 'PACKBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' AND A.DESCR LIKE 'FOR%' THEN 'ASY_AGING'
                                    WHEN B.OPERATION_GROUP = 'A' AND B.ATTRIBUTE8 <> 'CP' THEN (CASE WHEN A.LOCATION_CODE = '-' THEN 'CHAR' ELSE 'ASSY' END)
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'A' AND B.FLOW_ID = 'A9000'  AND A.FLAG = 'PLANT'  THEN 'CHAR'
                                    WHEN B.OPERATION_GROUP_ID = 'A' AND B.FLOW_ID = 'A9000'  AND A.FLAG = 'SALES'  THEN 'CELLBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID NOT LIKE 'EP%'  AND A.FLAG = 'PLANT' THEN 'PACK'
                                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID NOT LIKE 'EP%'  AND A.FLAG = 'SALES' THEN 'PACKBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID LIKE 'EP%'  AND A.FLAG = 'PLANT'   THEN 'PACK'
                                    WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID = 'P5000'  AND A.ITEM_ID LIKE 'EP%'  AND A.FLAG = 'SALES'   THEN 'PACKBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    /* 2026.05.27 Minyong Lee ESS 사내 Pack Plant 추가로 SUBMDLE 관리 되도록 원복 */
                                    WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'PLANT' THEN 'SUBMDLE'
                                    WHEN SMC.SCP_OPERATION_GROUP = 'P' AND SMC.SCP_FLOW_ID NOT IN ('P5500', 'P9500') AND A.FLAG = 'SALES' THEN 'SUBMDLEBIZ'
                                    /*-------------------------------------------------------------------------------------------------------------------*/
                                    ELSE '-'
                                END                                                         AS STAGE
                              , TO_CHAR(NVL(A.EFFSTARTDATE, TO_DATE(V_PLAN_NAME, 'YYYYMMDD')), 'YYYYMMDD') AS EFECTIVE_DATE
                              , A.DESCR                                                     AS TYPE
                              , A.QTY                                                       AS QTY
                              , A.INCOTERMS
                              , A.PROJECT_CODE
                              , A.CELL_PROD_SITE_ID
                          FROM (
                                SELECT  T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID             AS SCM_SITE_ID
                                      , T.INCOTERMS
                                      , TO_DATE(TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), 'YYYYMMDD') AS EFFSTARTDATE
                                      , SUM(T.QTY)                                          AS QTY
                                      , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'WH'
                                             ELSE 'WH_HOLD'
                                        END                                                 AS DESCR
                                      , T.LOCATION_CODE
                                      , T.PROJECT_CODE
                                      , T.CELL_PROD_SITE_ID
                                      , T.FLAG
                                  FROM  GT_OPTENG_ESSIS_INV T
                                 WHERE  1=1
                                   AND  T.STOCK_TYPE <> 'FOR'
                                 GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                HAVING SUM(T.QTY) > 0
                                UNION ALL
                                /* 활성화 재고 : FOR 로 처리 */
                                SELECT  T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID             AS SCM_SITE_ID
                                      , T.INCOTERMS
                                      , TO_DATE(TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), 'YYYYMMDD') AS EFFSTARTDATE
                                      , SUM(T.QTY)                                          AS QTY
                                      , CASE WHEN NVL(T.WIPHOLD_YN, 'N') = 'N' THEN 'FOR'
                                             ELSE 'FOR_HOLD'
                                        END                                                 AS DESCR
                                      , T.LOCATION_CODE
                                      , T.PROJECT_CODE
                                      , T.CELL_PROD_SITE_ID
                                      , T.FLAG
                                  FROM  GT_OPTENG_ESSIS_INV T
                                 WHERE  1=1
                                   AND  T.STOCK_TYPE  = 'FOR'   /* 활성화 재고 */
                                   AND  T.QTY         > 0
                                 GROUP BY T.DIVISION_ID, T.ITEM_ID, T.SCM_SITE_ID, TO_CHAR(T.AVAILABLE_DATE, 'YYYYMMDD'), NVL(T.WIPHOLD_YN, 'N'), T.INCOTERMS, T.LOCATION_CODE, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                                UNION ALL
                                /* INTRANSIT SHIPMENT 재고 */
                                SELECT  T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID          AS SCM_SITE_ID
                                      , T.INCOTERMS
                                      , TO_DATE(T.ETA_DATE, 'YYYYMMDD')                     AS EFFSTARTDATE
                                      , SUM(T.DELIVERY_QTY)                                 AS QTY
                                      , 'INT'                                               AS DESCR
                                      , '-'                                                 AS LOCATION_CODE
                                      , T.PROJECT_CODE
                                      , T.CELL_PROD_SITE_ID
                                      , T.FLAG
                                  FROM  GT_OPTENG_ESSIS_INT T
                                 WHERE  1=1
                                   AND  T.DELIVERY_QTY > 0
                                   AND (T.ETA_DATE IS NOT NULL OR T.ETA_DATE <> '')
                                 GROUP BY T.DIVISION_ID, T.ITEM_ID, T.TO_SCM_SITE_ID, T.ETA_DATE, T.INCOTERMS, T.PROJECT_CODE, T.FLAG, T.CELL_PROD_SITE_ID
                               ) A
                               LEFT JOIN (SELECT  DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
                                                --, *
                                            FROM  SCP_MST_FINAL_ITEM
                                           WHERE  DIVISION_ID = V_DIVISION_ID
                                             AND  OPERATION_GROUP IN ('A', 'P')
                                         ) B
                                  ON  A.ITEM_ID     = B.ITEM_ID
                                 AND  A.DIVISION_ID = B.DIVISION_ID
                               LEFT  JOIN SCM_MST_SITE FS
                                  ON  FS.DIVISION_ID = A.DIVISION_ID
                                 AND  FS.SCM_SITE_ID = A.SCM_SITE_ID
                                 AND  FS.SITE_TYPE   = 'PLANT'
                                 AND  FS.VALID_YN    = 'Y'
                               LEFT  JOIN GT_OPTENG_ESSIS_CP C1
                                  ON  C1.DIVISION_ID  = A.DIVISION_ID
                                 AND  C1.PLANT_ID     = FS.PLANT_ID
                                 AND  C1.ITEM_ID_ASSY = A.ITEM_ID
                                 AND  C1.PRIORITY_1ST = 1
                               LEFT  JOIN GT_OPTENG_ESSIS_CP C2
                                  ON  C2.DIVISION_ID  = A.DIVISION_ID
                                 AND  C2.ITEM_ID_ASSY = A.ITEM_ID
                                 AND  C2.PRIORITY_2ND = 1
                               LEFT  JOIN GT_OPTENG_ESSIS_CP C3
                                  ON  C3.ITEM_ID_ASSY = A.ITEM_ID
                                 AND  C3.PRIORITY_3RD = 1
                               /* SUBMDLE의 STAGE를 찾기 위해 추가 */
                               /* 2025.08.12 Philsu Park - ESS 불필요 로직으로 주석처리. */
                               /* 2026.05.27 Minyong Lee ESS 사내 Pack Plant 추가로 SUBMDLE 관리 되도록 원복 */
                               LEFT  JOIN (
                                           SELECT  SM.DIVISION_ID
                                                 , SM.SCM_SITE_ID
                                                 , IM.ITEM_ID
                                                 , IM.SCP_FLOW_ID
                                                 , IM.SCP_OPERATION_GROUP
                                             FROM  SCM_ITEM_M_SN IM
                                                   INNER JOIN SCM_MST_SITE SM
                                                      ON  IM.COMPANY_ID          = SM.COMPANY_ID
                                                     AND  IM.SCP_OPERATION_GROUP = SM.OPERATION_GROUP
                                            WHERE  1=1
                                              AND  SM.SCM_SITE_ID||IM.ITEM_ID IN (
                                                                SELECT  DISTINCT SCM_SITE_ID||ITEM_ID
                                                                  FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                 WHERE  PLAN_ID = V_PLAN_ID
                                                                )
                                              AND  IM.SCP_FLOW_ID NOT IN ('P5500', 'P9500')   /* SUBMDLE만 걸리도록 */
                                              AND  IM.SCP_OPERATION_GROUP = 'P'               /* SUBMDLE만 걸리도록 */
                                          ) SMC
                                  ON  A.DIVISION_ID = SMC.DIVISION_ID
                                 AND  A.SCM_SITE_ID = SMC.SCM_SITE_ID
                                 AND  A.ITEM_ID     = SMC.ITEM_ID
                         WHERE  1=1
                           --AND    A.ITEM_ID = B.ITEM_ID
                           --AND    B.ITEM_TYPE <> 'R' --  R TYPE의 재고는 올리지 않음
                        /*************************
                        대상 프로젝트 ITEM 필터링
                        *************************/
                           AND  A.ITEM_ID IN ( SELECT  DISTINCT ITEM_ID
                                                 FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                                WHERE  PLAN_ID = V_PLAN_ID
                                             )
                       ) A
                 WHERE  1=1
                   AND  NOT EXISTS (SELECT  1
                                      FROM  GT_OPTENG_ESSIS_ADJ ADJ
                                     WHERE  ADJ.SCM_SITE_ID  = A.SITE_ID
                                       AND  ADJ.ITEM_ID      = A.ITEM_ID
                                       AND  ADJ.STOCK_TYPE   = A.TYPE
                                       AND  ADJ.STAGE        = A.STAGE
                                       AND  ADJ.INCOTERMS    = A.INCOTERMS
                                       AND  ADJ.PROJECT_CODE = A.PROJECT_CODE
                                       AND  ADJ.INV_DATE     = A.EFECTIVE_DATE
                                   )
                   AND  EFECTIVE_DATE < P_PLAN_END_YYYYMMDD

                /*  자재/포장재의 입고 예정정보
                    2025.05.19 Philsu Park: GROUP_ID 추가, 컬럼순서 변경정보 반영한 LOOKUP 적용. */
                UNION ALL
                SELECT  V_PLAN_ID                                                           AS PLAN_ID
                      , TYPE||'::'||SCM_SITE_ID||'::'||MAT_ID||'::'||STAGE||'::'||ARR_DATE  AS STOCK_ID
                      , SCM_SITE_ID||'::'||MAT_ID||'::'||STAGE                              AS BUFFER_ID
                      , ARR_DATE                                                            AS EFFECTIVE_DATE
                      , TYPE                                                                AS TYPE
                      , QTY                                                                 AS QUANTITY
                      , SCM_SITE_ID                                                         AS SITE_ID
                      , MAT_ID                                                              AS ITEM_ID
                      , STAGE                                                               AS STAGE
                      , '-'                                                                 AS INCOTERMS
                      , '-'                                                                 AS PROJECT_CODE
                  FROM (
                        /* START 2025.11.19 jongykim2: Schelduled Reciept Information */
                        SELECT  LU.PLANT_SITE_ID                                            AS SCM_SITE_ID
                              , LU.ITEM_ID_CHILD                                            AS MAT_ID
                              , 'MATERIAL_CONST'                                             AS STAGE
                              , LU.TO_YYYYMMDD                                              AS ARR_DATE
                              , TO_NUMBER(LU.TO_EXPC_QTY)                                   AS QTY   /* TO_EXPC_QTY 는 VARCHAR2 — UNION ALL 자료형 통일을 위해 명시 변환 */
                              , 'MC'                                                        AS TYPE
                          FROM  SCP_OPMZ_SCHEDULED_RECIEPT_INFORMATION LU
                                INNER JOIN SCP_OPMZ_PLAN_GR_M PG
                                   ON  LU.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID
                                INNER JOIN GT_OPTENG_ESSIS_MAT MAT
                                   ON  LU.ITEM_ID_CHILD = MAT.MAT_ID
                         WHERE  1 = 1
                           AND  LU.DIVISION_ID       = V_DIVISION_ID
                           AND  PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                           AND  LU.VALID_YN          = 'Y'
                           AND  PG.VALID_YN          = 'Y'
                           AND  LU.TO_YYYYMMDD BETWEEN P_PLAN_START_YYYYMMDD AND MAT.EFF_END_DATE
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
                       ) MC
                 WHERE  ARR_DATE < P_PLAN_END_YYYYMMDD
               ) AA
         GROUP BY PLAN_ID, STOCK_ID, BUFFER_ID, EFECTIVE_DATE, TYPE, SITE_ID, ITEM_ID, STAGE, INCOTERMS, PROJECT_CODE;

        /* INCOMING STOCK INSERT #2. */
        /* 2025.07.10 Philsu Park: 재고 보정 데이터 Insert. */
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
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
        )
        SELECT  V_PLAN_ID                                                                   AS PLAN_ID
              , ADJ.STOCK_TYPE||'::'||ADJ.SCM_SITE_ID||'::'||ADJ.ITEM_ID||'::'||ADJ.STAGE
                ||CASE WHEN ADJ.INCOTERMS != '-' THEN '@'||ADJ.INCOTERMS||'@'||ADJ.PROJECT_CODE ELSE '' END
                ||'::'||ADJ.INV_DATE                                                        AS STOCK_ID
              , ADJ.SCM_SITE_ID||'::'||ADJ.ITEM_ID||'::'||ADJ.STAGE
                ||CASE WHEN ADJ.INCOTERMS != '-' THEN '@'||ADJ.INCOTERMS||'@'||ADJ.PROJECT_CODE ELSE '' END  AS BUFFER_ID
              , ADJ.INV_DATE                                                                AS EFFECTIVE_DATE
              , ADJ.STOCK_TYPE                                                              AS TYPE
              , ADJ.QTY                                                                     AS QUANTITY
              , ADJ.SCM_SITE_ID                                                             AS ATTRIBUTE1
              , ADJ.ITEM_ID                                                                 AS ATTRIBUTE2
              , ADJ.STAGE                                                                   AS ATTRIBUTE3
              , ADJ.INCOTERMS                                                               AS ATTRIBUTE4
              , ADJ.PROJECT_CODE                                                            AS ATTRIBUTE5
              , 'INVENTORY_ADJUST'                                                          AS ATTRIBUTE15
              , 'INVENTORY_ADJUST'                                                          AS INSERT_ID
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
          FROM  GT_OPTENG_ESSIS_ADJ ADJ
         WHERE  1=1
           AND  ADJ.QTY > 0;

        /* 2nd OCV 재고는 INSP로 UPDATE
           원문 UPDATE..FROM + INNER JOIN -> ROWID 기준 MERGE
           (ATTRIBUTE3 이 조인 열쇠이면서 갱신 대상이라 ROWID 로 맞춘다. 같은 열쇠에 TO_BE_STAGE 가 여럿이면 MAX 로 좁힌다) */
        MERGE INTO SCP_OPT_ENG_INCOMING_STOCK_SN STK
        USING (
               SELECT  INC.RID
                     , INC.TYPE||'::'||INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||OCV.TO_BE_STAGE||'::'||INC.EFFECTIVE_DATE AS NEW_STOCK_ID
                     , INC.ATTRIBUTE1||'::'||INC.ATTRIBUTE2||'::'||OCV.TO_BE_STAGE           AS NEW_BUFFER_ID
                     , OCV.TO_BE_STAGE                                                       AS NEW_ATTRIBUTE3
                 FROM (SELECT  ROWID AS RID
                             , TYPE
                             , ATTRIBUTE1
                             , ATTRIBUTE2
                             , ATTRIBUTE3
                             , EFFECTIVE_DATE
                         FROM  SCP_OPT_ENG_INCOMING_STOCK_SN
                        WHERE  PLAN_ID = V_PLAN_ID
                      ) INC
                      INNER JOIN (
                                  SELECT  AS_IS_STAGE
                                        , MAX(TO_BE_STAGE)                                   AS TO_BE_STAGE
                                        , SCM_SITE_ID
                                        , ITEM_ID
                                    FROM (
                                          SELECT  ATTRIBUTE2                                 AS AS_IS_STAGE
                                                , ATTRIBUTE3                                 AS TO_BE_STAGE
                                                , SEGMENT4                                   AS SCM_SITE_ID
                                                , SEGMENT5                                   AS ITEM_ID
                                            FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                           WHERE  1=1
                                             AND  LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_SECOND_OCV_MASTER'
                                             AND  LU.VALID_YN    = 'Y'
                                             AND  LU.ATTRIBUTE1 IN ('A', 'B', 'C')
                                             AND  LU.SEGMENT2    = V_DIVISION_ID
                                             AND  LU.SEGMENT3    = V_GROUP_ID
                                           GROUP BY ATTRIBUTE2, ATTRIBUTE3, SEGMENT4, SEGMENT5
                                         ) SA
                                   GROUP BY AS_IS_STAGE, SCM_SITE_ID, ITEM_ID
                                 ) OCV
                         ON  INC.ATTRIBUTE1 = OCV.SCM_SITE_ID
                        AND  INC.ATTRIBUTE2 = OCV.ITEM_ID
                        AND  INC.ATTRIBUTE3 = OCV.AS_IS_STAGE
              ) XA
           ON (STK.ROWID = XA.RID)
        WHEN MATCHED THEN
            UPDATE SET STK.STOCK_ID    = XA.NEW_STOCK_ID
                     , STK.BUFFER_ID   = XA.NEW_BUFFER_ID
                     , STK.ATTRIBUTE3  = XA.NEW_ATTRIBUTE3
                     , STK.UPDATE_ID   = V_PROGRAM_NAME
                     , STK.UPDATE_TIME = SYSDATE;

        /* 2025.12.01 Minyong Lee : LINKBIZ -> PACKBIZ 수요 변환 모델에 대한 재고 BUFFER_ID 동기화
           원문 UPDATE..FROM + INNER JOIN 2개 -> ROWID 기준 MERGE (같은 ATTRIBUTE2 에 여러 건이 맞으면 MAX 로 좁힌다) */
        MERGE INTO SCP_OPT_ENG_INCOMING_STOCK_SN STK
        USING (
               SELECT  IA.RID
                     , MAX(DA.TO_SITE_ID||'::'||DA.CHG_ITEM_ID||'::'||DA.STAGE||'@'||BOD.INCOTERMS||'@'||'-') AS NEW_BUFFER_ID
                 FROM (SELECT  ROWID AS RID
                             , ATTRIBUTE2
                         FROM  SCP_OPT_ENG_INCOMING_STOCK_SN
                        WHERE  1=1
                          AND  PLAN_ID = V_PLAN_ID
                          AND  TYPE    = 'INT'
                      ) IA
                      INNER JOIN (
                                  SELECT  SEGMENT3                                           AS ORIGIN_ITEM_ID
                                        , SEGMENT4                                           AS STAGE
                                        , SEGMENT5                                           AS CHG_ITEM_ID
                                        , SEGMENT6                                           AS FROM_SITE_ID
                                        , SEGMENT7                                           AS TO_SITE_ID
                                        , SEGMENT8                                           AS BOD_ID
                                        , SEGMENT9                                           AS ORIGIN_BOD_ID
                                    FROM  SCP_OPMZ_LOOKUP_MASTER_DETAIL
                                   WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_ADD'
                                     AND  VALID_YN    = 'Y'
                                     AND  SEGMENT1    = V_DIVISION_ID
                                     AND  SEGMENT2    = V_GROUP_ID
                                 ) DA
                         ON  1=1
                        AND  IA.ATTRIBUTE2 = DA.CHG_ITEM_ID
                      INNER JOIN SCP_MST_BOD_N_V BOD
                         ON  BOD.DIVISION_ID = V_DIVISION_ID
                        AND  BOD.BOD_ID      = DA.BOD_ID
                GROUP BY IA.RID
              ) XA
           ON (STK.ROWID = XA.RID)
        WHEN MATCHED THEN
            UPDATE SET STK.BUFFER_ID   = XA.NEW_BUFFER_ID
                     , STK.UPDATE_ID   = V_PROGRAM_NAME
                     , STK.UPDATE_TIME = SYSDATE;

        /* 2026.04.08 Minyong Lee : 법인간 이동 재고 BUFFER_ID, STOCK_ID 생성 규칙 수정, INCOTERMS / PROJECT_CODE 제거 */
        INSERT INTO GT_OPTENG_ESSIS_CINT
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
        SELECT  A.PLAN_ID
              , A.TYPE||'::'||A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||A.ATTRIBUTE3||'::'||A.EFFECTIVE_DATE AS STOCK_ID
              , A.ATTRIBUTE1||'::'||A.ATTRIBUTE2||'::'||A.ATTRIBUTE3                        AS BUFFER_ID
              , A.EFFECTIVE_DATE
              , A.TYPE
              , SUM(A.QUANTITY)                                                             AS QUANTITY
              , A.ATTRIBUTE1
              , A.ATTRIBUTE2
              , A.ATTRIBUTE3
              , '-'                                                                         AS ATTRIBUTE4
              , ''                                                                          AS ATTRIBUTE5
              , A.ATTRIBUTE15
          FROM (
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

        DELETE
          FROM  SCP_OPT_ENG_INCOMING_STOCK_SN
         WHERE  PLAN_ID = V_PLAN_ID
           AND  STOCK_ID LIKE 'INT%'
           AND  ATTRIBUTE3 NOT LIKE '%BIZ';

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
          , INSERT_ID
          , INSERT_TIME
          , UPDATE_ID
          , UPDATE_TIME
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
              , V_PROGRAM_NAME
              , SYSDATE
              , V_PROGRAM_NAME
              , SYSDATE
          FROM  GT_OPTENG_ESSIS_CINT;

        /* Data Insert End */

        /* 원문 #SCP_INVENTORY_I · #SCP_INTRANSIT_I · #CP_INFO · #INVENTORY_ADJUST · #COMPANY_INT_STK DROP 대응 */
        DELETE FROM GT_OPTENG_ESSIS_INV;
        DELETE FROM GT_OPTENG_ESSIS_INT;
        DELETE FROM GT_OPTENG_ESSIS_CP;
        DELETE FROM GT_OPTENG_ESSIS_ADJ;
        DELETE FROM GT_OPTENG_ESSIS_CINT;

        COMMIT;

    EXCEPTION
        /* ERROR LOG */
        /* ROLLBACK TRANSACTION PR_SCP_OPT_ENG_ESS_RUN_MAIN_PROC; */
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

    /* 종료 LOG */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I', 'INPUT', V_PLAN_ID, V_PROGRAM_NAME, 'END', NULL, NULL, NULL, V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U', V_PLAN_ID, 'STEP01', NULL, NULL, NULL, NULL, NULL, NULL);
        COMMIT;
    END IF;

END;
