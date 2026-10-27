PROCEDURE PR_SCP_OPT_ENG_ESS_INPUT_DEMAND
(
     P_PLAN_ID              VARCHAR2
    ,V_DIVISION_ID          VARCHAR2
    ,V_GROUP_ID             VARCHAR2
    ,V_PLAN_START_YYYYMMDD   VARCHAR2
    ,V_PLAN_END_YYYYMMDD     VARCHAR2
)
/* ============================================================
 * Program ID   : PR_SCP_OPT_ENG_ESS_INPUT_DEMAND
 * Description  : SCP OPT ENG ESS 엔진 입력 - Demand 생성
 *                (UI 조정수요와 DM Net Demand 를 Demand 로 적재하고, TARGETBIZ 계획이면 생산계획 BOM 전개분을 추가한다.
 *                 이어서 Demand 뭉치기(A/B/C Type) 마킹과 A Type 재귀 그룹핑을 반영하고,
 *                 Demand Group Master 기준 Group Demand 를 생성한 뒤 Demand Target Date 를 갱신해
 *                 SCP_OPT_ENG_DEMAND_SN 에 반영한다. 원본은 SCP_OPT_ENG_DEMAND_ORIGIN_SN 에 백업)
 * Program History
 *------------------------------------------------------------
 * Date          In Charge      Description
 *------------------------------------------------------------
 * 2025.02.07    Taehyun        Initial Release
 * 2025.03.24                   Bloack Target Date & Add Monlty Block for Speed
 * 2025.05.07    Philsu Park    소형 Demand Input 분기 추가를 위한 Snapshot data count.
 * 2025.05.19    Philsu Park    Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
 * 2025.06.09    Philsu Park    A Type은 별도 처리. 나머지는 기존대로 넣어줌.
 * 2025.06.10    Philsu Park    원본 DEMAND 를 백업한다.(동일 PLAN_ID로 삭제 후 INSERT)
 * 2025.06.19    김태현         DEMAND에 필요한 SEMI 정보는 최신 SCP 계획을 가져오는 것이 맞음
 * 2025.07.09    김태현선임     UI에서 수정한 수요 데이터 선 반영
 * 2025.07.15    Philsu Park    소형 Shipment SEMI 에도 Priority 값 반영.
 * 2025.07.24    Philsu Park    DemandTargetDate LOOKUP 관리형태를 YMD 로 변경.
 * 2025.08.12    Philsu Park    Workbench에서 0으로 들어온 케이스 제외.
 * 2025.08.25    Philsu Park    A Type의 value 기준을 주차가 아닌 일로 변경.
 * 2025.08.27    Philsu Park    C Type 추가.
 * 2025.09.24    THKIM          ESS 특정 케이스의 경우 DEMAND 추가 생성
 * 2025.10.13    T.K.KIM        워크벤치에서 0으로 들어온 데이터는 NET DEMAND에서 안 가져오게하고 삭제
 * 2025.10.15    Philsu Park    Demand 뭉치기 대상 마킹을 위한 Temp Update.
 * 2025.11.13                   TARGETBIZ 계획 분기 추가
 * 2025.11.17    Minyong Lee    Demand Exception Lookup -> UI 전환
 * 2025.11.18    Minyong Lee    Sales Site Priority Lookup -> UI 전환
 * 2026.04.08    Minyong Lee    DEMAND_GROUP을 위한 DUMMY 생성 시 ESS Stage 판정 로직 오류 수정
 * 2026.05.26    Minyong Lee    ESS LINK 사내 공장 신설 대응
 * 2026.07.06    ZIONEX         [PJ202650304] NextSCM Migration
 *------------------------------------------------------------
 *   - MSSQL 임시테이블(#) -> Oracle GTT (ESS DEMAND 전용 GT_OPT_ENG_ESSD_ 접두)
 *     전부 ON COMMIT PRESERVE ROWS + 진입부 DELETE 초기화(로깅 프로시저 내부 COMMIT 대비, TRUNCATE 금지).
 *   - MSSQL 대입형 SELECT(@v = col FROM ...)는 0행이면 변수 미변경이므로
 *     SELECT INTO + NO_DATA_FOUND / TOO_MANY_ROWS 흡수로 등가 재현한다.
 *       IIF(x = '', ...) -> RTRIM(x) IS NULL 로 변환한다.
 *   - UPDATE .. FROM JOIN 은 Oracle 미지원 -> MERGE 로 변환. Demand Target Date 갱신은
 *     한 DEMAND_ID 가 여러 TG 행과 매칭될 수 있어(MSSQL 은 비결정 임의 1건) ORA-30926 회피를 위해
 *     USING 을 DEMAND_ID 단위로 유일화(MAX)한다.
 *   - WITH(NOLOCK) 제거(Oracle 읽기일관성), BEGIN TRY/CATCH -> BEGIN .. EXCEPTION,
 *   - 상위 RUN_MAIN_PROC 가 호출하는 하위 단계이므로 내부 COMMIT 없음(부모 트랜잭션 소유).
 * ============================================================ */
AS
    /* Set Param for Log */
    V_PROGRAM_NAME       VARCHAR2(150 CHAR) := 'PR_SCP_OPT_ENG_ESS_INPUT_DEMAND';
    V_PLAN_ID            VARCHAR2(50 CHAR)  := P_PLAN_ID;
    V_MESSAGE_TEXT       VARCHAR2(1000 CHAR);
    MAX_TUESDAY          VARCHAR2(8 CHAR);
    /* Set Param for Biz */
    V_DETAIL_DATE        DATE;
    P_PLAN_NAME          VARCHAR2(8 CHAR);
    D_PLAN_NAME          DATE;
    V_DEMAND_CUTOFF_DAY  VARCHAR2(8 CHAR);
    V_DM_MAX_VERSION     VARCHAR2(200 CHAR);

    V_START_WEEK             NUMBER;
    V_PLAN_TYPE              VARCHAR2(20 CHAR);
    V_SHIP_FROZEN            NUMBER;
    V_SHIP_FROZEN_DAY        VARCHAR2(8 CHAR);
    V_PROD_FROZEN_END_YMD    VARCHAR2(8 CHAR);

    V_SCP_PLAN_DATE          VARCHAR2(8 CHAR);
    V_SCP_PLAN_TYPE          VARCHAR2(8 CHAR);
    V_SCP_PLAN_SEQ           VARCHAR2(8 CHAR);
    V_CNT                    NUMBER;

    V_PLAN_END_YYYYMMDD_ORI  VARCHAR2(20 CHAR) := TO_CHAR(TO_DATE(V_PLAN_END_YYYYMMDD,'YYYYMMDD') - 1,'YYYYMMDD');

    V_SHIPMENT_SNAP_CNT  NUMBER;

    /* START 2025-11-13 */
    V_TBZ_YN VARCHAR2(1 CHAR) := CASE WHEN SUBSTR(V_PLAN_ID, INSTR(V_PLAN_ID,'_',-1) + 1) = 'TARGETBIZ' THEN 'Y' ELSE 'N' END;
BEGIN

    DELETE FROM GT_OPT_ENG_ESSD_ROUTING;

    INSERT INTO GT_OPT_ENG_ESSD_ROUTING (DIVISION_ID, PLANT_ID, LINE_ID, ITEM_ID, MONTH, LT, YIELD, STAGE)
    SELECT  DIVISION_ID, PLANT_ID, LINE_ID, ITEM_ID, MONTH, 0 AS LT, YIELD
           ,CASE WHEN OPERATION_ID IN ('A3000', 'A9000') THEN 'ASSY'
                 WHEN OPERATION_ID IN ('P5500') THEN 'MDLE'
                 WHEN OPERATION_ID IN ('P9500') THEN 'PACK'
                 WHEN OPERATION_ID IN ('PL450') THEN 'LINK' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
            END AS STAGE
    FROM    SCM_MST_YIELD_SN
    WHERE   DIVISION_ID  = V_DIVISION_ID
    AND     OPERATION_ID IN ('A3000', 'A9000', 'P5500', 'P9500', 'PL450') /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
    AND     MONTH BETWEEN V_PLAN_START_YYYYMMDD AND V_PLAN_END_YYYYMMDD;


    DELETE FROM GT_OPT_ENG_ESSD_BOM_S;

    INSERT INTO GT_OPT_ENG_ESSD_BOM_S (COMPANY_ID, DIVISION_ID, PARENT_ITEM_ID, CHILD_ITEM_ID, M_KEY_DATE)
    SELECT COMPANY_ID
         , DIVISION_ID
         , PARENT_ITEM_ID
         , CHILD_ITEM_ID
         , MAX(KEY_DATE) M_KEY_DATE /* 계획구간별 유효 BOM이 달라 이방식을 사용!!! */
    FROM SCM_MST_BOM_ENG_SN
    WHERE DIVISION_ID = V_DIVISION_ID
    AND   ACTIVE_FLAG = 'Y'
    GROUP BY COMPANY_ID, DIVISION_ID, PARENT_ITEM_ID, CHILD_ITEM_ID;
    /* END 2025-11-13 */

    /* Step 3. SCP_OPT_ENG_ENGINE_DATA_CREATE_L_N 생성 */
    PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'START',NULL,NULL,NULL,V_PLAN_ID);

    /* Transaction (START)  -- 원본 BEGIN TRANSACTION 주석처리(명시TRAN 없음) → 하위단계라 COMMIT/ROLLBACK 신설 안함 */
    BEGIN
        /* Get Plan Master Info */
        /* 2025.06.19 김태현 : DEMAND에 필요한 SEMI 정보는 FROZEN 계획을 SSP로 선택하거나 SCP 다른 버전을 선택했더라도, 최신 SCP 계획을 가져오는 것이 맞음/재욱 책임님 확인 사항 */
        BEGIN
            SELECT   A.PLAN_START_YYYYMMDD
                    ,A.PLAN_TYPE
                    ,A.PLAN_SEQ
              INTO   V_SCP_PLAN_DATE, V_SCP_PLAN_TYPE, V_SCP_PLAN_SEQ
            FROM  (SELECT DIVISION_ID, PLAN_START_YYYYMMDD, PLAN_TYPE, PLAN_SEQ, PLAN_TYPE_ORDER, CONFIRM_FLAG
                    FROM   SCP_PLAN_VERSION_V
                    WHERE  DIVISION_ID          = V_DIVISION_ID
                    AND    PLAN_START_YYYYMMDD  = TO_CHAR(FN_NEXT_DAY(TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD'), 'MON') - 7, 'YYYYMMDD') /* 해당 주 월요일 YYYYMMDD */
                    ORDER BY PLAN_TYPE_ORDER DESC, CONFIRM_FLAG DESC, PLAN_SEQ DESC
                    ) A
            WHERE ROWNUM = 1;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        BEGIN
            SELECT  TO_NUMBER(ISO_WEEK)
              INTO  V_START_WEEK
            FROM    SCM_SYS_CALENDAR_M
            WHERE   BASIS_YYYYMMDD = V_PLAN_START_YYYYMMDD;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        BEGIN
            SELECT  SEGMENT4
              INTO  V_SHIP_FROZEN
            FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
            WHERE   LOOKUP_TYPE = 'SCP_OPT_SHIP_FROZEN'
            AND     VALID_YN    = 'Y'
            AND     SEGMENT1    = V_DIVISION_ID
            AND     SEGMENT2    = V_GROUP_ID
            /* AND     SEGMENT3    = 'PR' --임시 */
            AND     SEGMENT3    = V_SCP_PLAN_TYPE;
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        V_SHIP_FROZEN_DAY := TO_CHAR(TO_DATE(V_SCP_PLAN_DATE,'YYYYMMDD') + NVL(V_SHIP_FROZEN, 0),'YYYYMMDD');

        BEGIN
            SELECT  FROZEN_END_DATE
              INTO  V_PROD_FROZEN_END_YMD
            FROM    SCP_OPT_ENG_FROZEN_MASTER_SN M
            WHERE   M.PLAN_ID  = V_PLAN_ID
            AND     M.STAGE = 'ASSY';
        EXCEPTION WHEN NO_DATA_FOUND THEN NULL; WHEN TOO_MANY_ROWS THEN NULL;
        END;

        /* Set Param for Demand */
        SELECT  MAX(BASIS_YYYYMMDD)
          INTO  MAX_TUESDAY
        FROM    SCM_SYS_CALENDAR_M
        WHERE   BASIS_YYYYMMDD <= TO_CHAR(SYSDATE,'YYYYMMDD')
        AND     DAYOFWEEK = 'TUE';

        P_PLAN_NAME := V_PLAN_START_YYYYMMDD; /* CONVERT(CHAR(8), DATEADD(DD, -7, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 월요일 YYYYMMDD */
        D_PLAN_NAME := TO_DATE(P_PLAN_NAME,'YYYYMMDD'); /* = CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112); -- 당주 화요일 YYYYMMDD */

        SELECT NVL(MAX(P.CUTOFF_YYYYMMDD), MAX_TUESDAY)
          INTO V_DEMAND_CUTOFF_DAY
                /* , CONVERT(CHAR(8), DATEADD(DD, -6, DBO.FN_NEXT_DAY(GETDATE(), 'MON')), 112)) -- 당주 화요일 YYYYMMDD */
        FROM   DM_PLN_NET_DEMAND P
        WHERE  P.DIVISION_ID      = V_DIVISION_ID
        AND    P.CUTOFF_YYYYMMDD >= TO_CHAR(D_PLAN_NAME - 3, 'YYYYMMDD') /* 월요일 기준 최근 3일 이내 */
        AND    P.CUTOFF_YYYYMMDD <= TO_CHAR(D_PLAN_NAME + 6, 'YYYYMMDD'); /* 해당 주차 일요일 이전 */
        SELECT MAX(P.VERSION_NO)
          INTO V_DM_MAX_VERSION
        FROM    DM_PLN_NET_DEMAND P
        WHERE   P.DIVISION_ID      = V_DIVISION_ID
        AND     P.CUTOFF_YYYYMMDD  = V_DEMAND_CUTOFF_DAY;
        /* 셀 생산지 버퍼 추가 */
        DELETE FROM GT_OPT_ENG_ESSD_CPS;

        INSERT INTO GT_OPT_ENG_ESSD_CPS (SALES_SITE_ID, ITEM_ID)
        SELECT  SEGMENT3 AS SALES_SITE_ID
               ,SEGMENT4 AS ITEM_ID
        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL
        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_CELL_PROD_SITE'
        AND     SEGMENT1 = V_DIVISION_ID
        AND     SEGMENT2 = V_GROUP_ID;
        /* 임시 */
        /* SET @P_PLAN_NAME          = '20250310' */
        /* SET @V_DEMAND_CUTOFF_DAY  = '20250311' */
        /* SET @V_DM_MAX_VERSION     = 'MF_W_20250313_V001'     --3월 2주차 고정, 임시 */
        /* SET @V_DM_MAX_VERSION     = 'MF_W_20250311_V001'     --3월 2주차 고정, 임시 */
        /* 2025.05.07 Philsu Park. */
        /* 소형 Demand Input 분기 추가를 위한 Snapshot data count. */
        /* 1. 동 주차의 Snapshot Data가 존재하는 경우 Snapshot 사용. */
        /* 2. 동 주차의 Snapshot Data가 존재하지 않는 경우 기존 Rule 적용(Shipment Plan Semi) */
        BEGIN
            SELECT  COUNT(*)
              INTO  V_SHIPMENT_SNAP_CNT
            FROM    SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN S
            WHERE   S.DIVISION_ID           = V_DIVISION_ID
            AND     S.PLAN_START_YYYYMMDD   = V_PLAN_START_YYYYMMDD;
        END;
        /* Data Insert Start */
        /* 0. UI에서 수정한 수요 데이터 선 반영/김태현 선임/20250709 */
        INSERT INTO GT_OPT_ENG_ESSD_DM_INS
            (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
            ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
            ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
        SELECT  V_PLAN_ID
               ,SCM_SITE_ID||'::'||AD.ITEM_ID||'::'||STAGE||'@'||INCOTERMS||'@'||PROJECT_CODE||'::'||DUE_DATE||'::'||'-'||'::'||FCST_TYPE||CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE '::'||AD.CELL_PROD_SITE_ID END AS DEMAND_ID
               ,SCM_SITE_ID||'::'||AD.ITEM_ID||'::'||STAGE||'@'||INCOTERMS||'@'||PROJECT_CODE||CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE '::'||AD.CELL_PROD_SITE_ID END                                       AS BUFFER_ID
               ,INCOTERMS || '@' || STAGE                                                    AS DEMAND_GROUP
            /* ,INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP */
               ,DUE_DATE                                                                   AS DUE_DATE
               ,NULL                                                                       AS TARGET_DATE
               ,NULL                                                                       AS SALES_CUTOFF_DATE
               ,NULL                                                                       AS EXPIRY_DATE
            /* ,1                                                                          AS PRIORITY */
               ,PRIORITY                                                                   AS PRIORITY
               ,QTY                                                                        AS QUANTITY
               ,STAGE                                                                      AS PRIORITY_GROUP
            /* ,'D'+PRIORITY                                                               AS PRIORITY_GROUP */
               ,NULL                                                                       AS CUSTOMER_ID
               ,NULL                                                                       AS ALLOW_SHORT
               ,SCM_SITE_ID                                                                AS ATTRIBUTE1
               ,AD.ITEM_ID                                                                 AS ATTRIBUTE2
               ,STAGE                                                                      AS ATTRIBUTE3
               ,INCOTERMS                                                                  AS ATTRIBUTE4
               ,PROJECT_CODE                                                               AS ATTRIBUTE5
               ,NULL                                                                       AS ATTRIBUTE6
               ,NULL                                                                       AS ATTRIBUTE7
               ,FCST_TYPE                                                                  AS ATTRIBUTE8
               ,NULL                                                                       AS ATTRIBUTE9
               ,NULL                                                                       AS ATTRIBUTE10
               ,NULL                                                                       AS ATTRIBUTE11
               ,NULL                                                                       AS ATTRIBUTE12
               ,NULL                                                                       AS ATTRIBUTE13
               ,NULL                                                                       AS ATTRIBUTE14
               ,NULL                                                                       AS ATTRIBUTE15
        FROM(
            SELECT  DA.DIVISION_ID       AS DIVISION_ID
                   ,DA.PROJECT_CODE      AS PROJECT_CODE
                   ,DA.SCM_SITE_ID       AS SCM_SITE_ID
                   ,DA.ITEM_ID           AS ITEM_ID
                   ,DA.FCST_TYPE         AS FCST_TYPE
                   ,CASE WHEN NVL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE DA.INCOTERMS END AS INCOTERMS
                   ,DA.CELL_PROD_SITE_ID AS CELL_PROD_SITE_ID
                   ,DA.DUE_DATE          AS DUE_DATE
                   ,SUM(DA.CHG_QTY)      AS QTY
                /* ,ISNULL(TP.PRIORITY, 3)          AS PRIORITY */
                   ,NVL(TP.PRIORITY, CASE   WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   IN ('P9500','PL450')    THEN 4 /* 'LINKBIZ' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                            WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   = 'R5500'    THEN 5 /* 'RACKBIZ' */
                                            /* WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID   = 'P9500'    THEN 'PACKBIZ' */
                                            /* WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID   = 'P5500'    THEN 'PACKBIZ' */
                                            /* WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID   = 'P9500'    THEN 'PACKBIZ' */
                                            /* WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID   = 'P5000'    AND DA.ITEM_ID NOT LIKE 'EP%'  THEN 'PACKBIZ' */
                                            /* WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID   = 'P5000'    AND DA.ITEM_ID LIKE 'EP%'      THEN 'PACKBIZ' */
                                            /* WHEN FI.OPERATION_GROUP_ID = 'A' AND FI.FLOW_ID   = 'A9000'    THEN 'CELLBIZ' */
                                            ELSE 6
                                            END)        AS PRIORITY
                   , CASE   WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   = 'P9500'    THEN 'LINKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   = 'PL450'    THEN 'LINKBIZ' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                            WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   = 'R5500'    THEN 'RACKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID   = 'P9500'    THEN 'PACKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'B' AND FI.FLOW_ID   = 'P5500'    THEN 'PACKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID   = 'P9500'    THEN 'PACKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID   = 'P5000'    AND DA.ITEM_ID NOT LIKE 'EP%'  THEN 'PACKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'M' AND FI.FLOW_ID   = 'P5000'    AND DA.ITEM_ID LIKE 'EP%'      THEN 'PACKBIZ'
                            WHEN FI.OPERATION_GROUP_ID = 'A' AND FI.FLOW_ID   = 'A9000'    THEN 'CELLBIZ'
                            ELSE '-'
                        END              AS STAGE
            FROM    SCP_OPMZ_DMD_ADJ DA
                   ,(SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
                            FROM   SCP_MST_FINAL_ITEM
                            WHERE  DIVISION_ID = V_DIVISION_ID
                            AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') ) /* 소형은 CEll Biz 용 Demand 만 처리 */
                                     OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                  )
                           ) FI
                   ,( /* VMI 대상 SITE 조회 */
                            SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                            FROM   SCM_MST_SITE
                            WHERE  DIVISION_ID = V_DIVISION_ID
                                AND SITE_TYPE   = 'SALES'
                                AND  VALID_YN    = 'Y'
                                AND  VMI_YN      = 'Y'
                            ) MSE
                   ,( /* TOSITE PRIORITY CONSTRAINT */
                                    /* 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                    SELECT  P.ITEM_ID       AS ITEM_ID
                                          , P.SCM_SITE_ID   AS TO_SITE
                                          , TO_CHAR(P.PRIO_RANK)     AS PRIORITY
                                          , FROM_YYYYMMDD   AS FROM_DATE
                                          , TO_YYYYMMDD     AS TO_DATE
                                    FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                           ,SCP_OPMZ_PLAN_GR_M PG
                                    WHERE   1=1
                                    AND     P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                                    AND     PG.VALID_YN(+) = 'Y'
                                    AND     P.VALID_YN = 'Y'
                                    AND     P.DIVISION_ID = V_DIVISION_ID
                                    AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                ) TP
                /* DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리 */
                /* 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
                   ,(
                            /* 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                            SELECT  D.DIVISION_ID           AS DIVISION_ID
                                  , D.SCM_SITE_ID           AS SCM_SITE_ID
                                  , D.ITEM_ID               AS ITEM_ID
                                  , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                  , CASE
                                        WHEN D.FROM_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                                        ELSE D.FROM_YYYYMMDD
                                    END                     AS START_DATE
                                  , CASE
                                        WHEN D.TO_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                                        ELSE D.TO_YYYYMMDD
                                    END                     AS END_DATE
                            FROM    SCP_OPMZ_DEMAND_EXCEPTION D
                                       ,SCP_OPMZ_PLAN_GR_M PG
                            WHERE   1=1
                            AND     D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                            AND     PG.VALID_YN(+) = 'Y'
                            AND     D.VALID_YN = 'Y'
                            AND     D.DIVISION_ID = V_DIVISION_ID
                            AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                            ) DE
            /* ③FMT: ANSI OUTER JOIN -> 콤마 + (+) (포맷표준 §4.72 / FM-015). 아우터측 조건은 상수필터까지 전부 (+) — 누락 시 조용히 INNER 화된다. */
            WHERE   DA.ITEM_ID         = FI.ITEM_ID
            AND     DA.DIVISION_ID     = FI.DIVISION_ID
            AND     DA.DIVISION_ID     = MSE.DIVISION_ID(+)
            AND     DA.SCM_SITE_ID     = MSE.SCM_SITE_ID(+)
            AND     DA.SCM_SITE_ID     = TP.TO_SITE(+)
            AND     DA.ITEM_ID         = TP.ITEM_ID(+)
            AND     DA.DUE_DATE BETWEEN TP.FROM_DATE(+) AND TP.TO_DATE(+)
            AND     DA.SCM_SITE_ID     = DE.SCM_SITE_ID(+)
            AND     DA.ITEM_ID         = DE.ITEM_ID(+)
            AND     DA.VERSION_NO      = V_DM_MAX_VERSION
            AND     DA.DIVISION_ID     = V_DIVISION_ID
            AND     DA.CUTOFF_YYYYMMDD = V_DEMAND_CUTOFF_DAY
            AND     DA.DUE_DATE        >= P_PLAN_NAME
            AND     DA.DUE_DATE        <  V_PLAN_END_YYYYMMDD
            /* 남혁선임님 요청으로 워크벤치에서 0으로 들어온거 일단 넣어놓고 삭제 */
            AND     DA.CHG_QTY         >= 0
            /* AND     DA.CHG_QTY          > 0 */
            /* DEMAND 제외 대상 처리 */
            /* 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영. */
            AND (DE.ITEM_ID IS NULL /* LOOKUP 에 등록되어 있지 않은 정보 */
                OR (DE.ITEM_ID IS NOT NULL AND (DA.DUE_DATE < DE.START_DATE OR DA.DUE_DATE > DE.END_DATE)) /* LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보 */
                )
            AND (   (V_DIVISION_ID = '40'
                                           AND (DA.CELL_PROD_SITE_ID||DA.ITEM_ID) IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                                         FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                         WHERE   PLAN_ID = V_PLAN_ID
                                                                                         )
                    )
                 OR (V_DIVISION_ID != '40' AND  DA.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                               FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                               WHERE   PLAN_ID = V_PLAN_ID
                                                              )
                    )
               )
            GROUP BY DA.DIVISION_ID, DA.SCM_SITE_ID, DA.ITEM_ID, DA.INCOTERMS, DA.DUE_DATE, FI.FLOW_ID, FI.OPERATION_GROUP, FI.OPERATION_GROUP_ID
                    ,NVL(TP.PRIORITY, CASE   WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   IN ('P9500', 'PL450')    THEN 4 /* 'LINKBIZ' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                            WHEN FI.OPERATION_GROUP_ID = 'P' AND FI.FLOW_ID   = 'R5500'    THEN 5 /* 'RACKBIZ' */
                                            ELSE 6
                                        END)
                    , DA.FCST_TYPE, DA.PROJECT_CODE, DA.CELL_PROD_SITE_ID, MSE.VMI_YN
            )AD
                   ,GT_OPT_ENG_ESSD_CPS CPS
        WHERE   1=1
        AND     AD.SCM_SITE_ID = CPS.SALES_SITE_ID(+)
        AND     AD.ITEM_ID     = CPS.ITEM_ID(+);
        /* 1. DM Demand Insert */
        INSERT INTO GT_OPT_ENG_ESSD_DM_INS
            (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
            ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
            ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
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
        FROM(
            SELECT   V_PLAN_ID                                                                 AS PLAN_ID
                    ,SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||STAGE||'@'||INCOTERMS||'@'||PROJECT_CODE||'::'||DUE_DATE||'::'||'-'||'::'||FCST_TYPE||CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE '::'||DEMAND.CELL_PROD_SITE_ID END AS DEMAND_ID
                    ,SCM_SITE_ID||'::'||DEMAND.ITEM_ID||'::'||STAGE||'@'||INCOTERMS||'@'||PROJECT_CODE||CASE WHEN CPS.ITEM_ID IS NULL THEN '' ELSE '::'||DEMAND.CELL_PROD_SITE_ID END                                       AS BUFFER_ID
                    ,INCOTERMS || '@' || STAGE                                                  AS DEMAND_GROUP
                    /* ,INCOTERMS+'@'+'D'+PRIORITY                                                 AS DEMAND_GROUP */
                    ,DUE_DATE                                                                   AS DUE_DATE
                    ,NULL                                                                       AS TARGET_DATE
                    ,NULL                                                                       AS SALES_CUTOFF_DATE
                    ,NULL                                                                       AS EXPIRY_DATE
                    /* ,1                                                                             AS PRIORITY */
                    ,PRIORITY                                                                   AS PRIORITY
                    ,QUANTITY                                                                   AS QUANTITY
                    ,STAGE                                                                      AS PRIORITY_GROUP
                    /* ,'D'+PRIORITY                                                               AS PRIORITY_GROUP */
                    ,NULL                                                                       AS CUSTOMER_ID
                    ,NULL                                                                       AS ALLOW_SHORT
                    ,SCM_SITE_ID                                                                AS ATTRIBUTE1
                    ,DEMAND.ITEM_ID                                                             AS ATTRIBUTE2
                    ,STAGE                                                                      AS ATTRIBUTE3
                    ,INCOTERMS                                                                  AS ATTRIBUTE4
                    ,PROJECT_CODE                                                               AS ATTRIBUTE5
                    ,NULL                                                                       AS ATTRIBUTE6
                    ,NULL                                                                       AS ATTRIBUTE7
                    ,FCST_TYPE                                                                  AS ATTRIBUTE8
                    ,NULL                                                                       AS ATTRIBUTE9
                    ,NULL                                                                       AS ATTRIBUTE10
                    ,NULL                                                                       AS ATTRIBUTE11
                    ,NULL                                                                       AS ATTRIBUTE12
                    ,NULL                                                                       AS ATTRIBUTE13
                    ,NULL                                                                       AS ATTRIBUTE14
                    ,NULL                                                                       AS ATTRIBUTE15
            FROM   (
            SELECT   A.SCM_SITE_ID  AS SCM_SITE_ID
                    ,A.ITEM_ID      AS ITEM_ID
                    ,CASE   WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID   = 'P9500'    THEN 'LINKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID   = 'PL450'    THEN 'LINKBIZ' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                            WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID  = 'R5500'    THEN 'RACKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID   = 'P9500'    THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'B' AND B.FLOW_ID   = 'P5500'    THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID  = 'P9500'    THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID  = 'P5000'    AND A.ITEM_ID NOT LIKE 'EP%'  THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'M' AND B.FLOW_ID   = 'P5000'    AND A.ITEM_ID LIKE 'EP%'      THEN 'PACKBIZ'
                            WHEN B.OPERATION_GROUP_ID = 'A' AND B.FLOW_ID   = 'A9000'    THEN 'CELLBIZ'
                            ELSE '-'
                        END              AS STAGE
                    ,CASE WHEN NVL(MSE.VMI_YN, 'N' ) = 'Y' THEN 'DAP' ELSE A.INCOTERMS END   AS INCOTERMS
                  ,A.ATTRIBUTE1                                                                 AS DUE_DATE
                  ,SUM(A.QTY)                                                                   AS QUANTITY
                /* ,ISNULL(TP.PRIORITY, 3)                                                                  AS PRIORITY */
                  ,NVL(TP.PRIORITY, CASE WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID   IN ('P9500', 'PL450')    THEN 4 /* 'LINKBIZ' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                        WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID   = 'R5500'    THEN 5 /* 'RACKBIZ' */
                                        ELSE 6 /* PACK, CELL */
                                    END)                                                    AS PRIORITY
                  ,A.FCST_TYPE                                                                  AS FCST_TYPE
                  ,A.PROJECT_CODE                                                               AS PROJECT_CODE
                  ,A.CELL_PROD_SITE_ID                                                          AS CELL_PROD_SITE_ID
            FROM DM_PLN_NET_DEMAND A
                   ,(SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, OPERATION_GROUP_ID, FLOW_ID, ATTRIBUTE8
                                FROM   SCP_MST_FINAL_ITEM
                                WHERE  DIVISION_ID = V_DIVISION_ID
                                AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') ) /* 소형은 CEll Biz 용 Demand 만 처리 */
                                   OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                      )
                               ) B
                   ,( /* VMI 대상 SITE 조회 */
                                SELECT DIVISION_ID, SCM_SITE_ID, VMI_YN
                                FROM   SCM_MST_SITE
                                WHERE  DIVISION_ID = V_DIVISION_ID
                                    AND SITE_TYPE   = 'SALES'
                                    AND  VALID_YN    = 'Y'
                                    AND  VMI_YN      = 'Y'
                                ) MSE
                   ,( /* TOSITE PRIORITY CONSTRAINT */
                                        /* 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                        SELECT  P.ITEM_ID       AS ITEM_ID
                                              , P.SCM_SITE_ID   AS TO_SITE
                                              , TO_CHAR(P.PRIO_RANK)     AS PRIORITY
                                              , FROM_YYYYMMDD   AS FROM_DATE
                                              , TO_YYYYMMDD     AS TO_DATE
                                        FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                               ,SCP_OPMZ_PLAN_GR_M PG
                                        WHERE   1=1
                                        AND     P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                                        AND     PG.VALID_YN(+) = 'Y'
                                        AND     P.VALID_YN = 'Y'
                                        AND     P.DIVISION_ID = V_DIVISION_ID
                                        AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                    ) TP
                    /* DEMAND 제외 대상 CELL ITEM 정보 : WHERE 절에서 제외 조건 처리 */
                    /* 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3) */
                   ,(
                                /* 2025.11.17 Minyong Lee : Demand Exception Lookup -> UI 전환 */
                                SELECT  D.DIVISION_ID           AS DIVISION_ID
                                      , D.SCM_SITE_ID           AS SCM_SITE_ID
                                      , D.ITEM_ID               AS ITEM_ID
                                      , PG.OPMZ_PLAN_GR_NAME    AS GROUP_ID
                                      , CASE
                                            WHEN D.FROM_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                                            ELSE D.FROM_YYYYMMDD
                                        END                     AS START_DATE
                                      , CASE
                                            WHEN D.TO_YYYYMMDD IS NULL THEN V_PLAN_END_YYYYMMDD
                                            ELSE D.TO_YYYYMMDD
                                        END                     AS END_DATE
                                FROM    SCP_OPMZ_DEMAND_EXCEPTION D
                                           ,SCP_OPMZ_PLAN_GR_M PG
                                WHERE   1=1
                                AND     D.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                                AND     PG.VALID_YN(+) = 'Y'
                                AND     D.VALID_YN = 'Y'
                                AND     D.DIVISION_ID = V_DIVISION_ID
                                AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                                ) DE
            /* ③FMT: ANSI OUTER JOIN -> 콤마 + (+) (포맷표준 §4.72 / FM-015). 아우터측 조건은 상수필터까지 전부 (+) — 누락 시 조용히 INNER 화된다. */
            WHERE A.ITEM_ID         =  B.ITEM_ID
            AND   A.DIVISION_ID     =  B.DIVISION_ID
            AND   A.DIVISION_ID     =  MSE.DIVISION_ID(+)
            AND   A.SCM_SITE_ID     =  MSE.SCM_SITE_ID(+)
            AND   A.SCM_SITE_ID     =  TP.TO_SITE(+)
            AND   A.ITEM_ID         =  TP.ITEM_ID(+)
            AND   A.ATTRIBUTE1 BETWEEN TP.FROM_DATE(+) AND TP.TO_DATE(+)
            AND   A.SCM_SITE_ID     =  DE.SCM_SITE_ID(+)
            AND   A.ITEM_ID         =  DE.ITEM_ID(+)
            AND   A.DIVISION_ID     =  V_DIVISION_ID
            AND A.CUTOFF_YYYYMMDD   =  V_DEMAND_CUTOFF_DAY
            AND A.VERSION_NO        =  V_DM_MAX_VERSION
            AND A.ATTRIBUTE1        >= P_PLAN_NAME
            AND A.ATTRIBUTE1        <  V_PLAN_END_YYYYMMDD
            AND A.QTY               >  0
            /* DEMAND 제외 대상 처리 */
            /* 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영. */
            AND (DE.ITEM_ID IS NULL /* LOOKUP 에 등록되어 있지 않은 정보 */
                OR (DE.ITEM_ID IS NOT NULL AND (A.ATTRIBUTE1 < DE.START_DATE OR A.ATTRIBUTE1 > DE.END_DATE)) /* LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보 */
                )
            /* 소형 생산지 구분을 위한 분리 */
            AND (   (V_DIVISION_ID = '40'
                                           AND (A.CELL_PROD_SITE_ID||A.ITEM_ID) IN (SELECT DISTINCT SCM_SITE_ID||ITEM_ID
                                                                                         FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                                                         WHERE   PLAN_ID = V_PLAN_ID
                                                                                         )
                    )
                 OR (V_DIVISION_ID != '40' AND  A.ITEM_ID IN (SELECT DISTINCT ITEM_ID
                                                               FROM    SCP_OPT_ENG_MODEL_LIST_N_SN
                                                               WHERE   PLAN_ID = V_PLAN_ID
                                                              )
                    )
               )
            GROUP BY A.SCM_SITE_ID, A.ITEM_ID, MSE.VMI_YN, A.INCOTERMS, A.ATTRIBUTE1
                   , B.FLOW_ID, B.OPERATION_GROUP, B.OPERATION_GROUP_ID
                   ,NVL(TP.PRIORITY, CASE    WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID   IN ('P9500', 'PL450')    THEN 4 /* 'LINKBIZ' -- 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                            WHEN B.OPERATION_GROUP_ID = 'P' AND B.FLOW_ID   = 'R5500'    THEN 5 /* 'RACKBIZ' */
                                            ELSE 6 /* PACK, CELL */
                                    END)
                   , A.FCST_TYPE,A.PROJECT_CODE,A.CELL_PROD_SITE_ID
            ) DEMAND
                   ,GT_OPT_ENG_ESSD_CPS CPS
            WHERE   1=1
            AND     DEMAND.SCM_SITE_ID = CPS.SALES_SITE_ID(+)
            AND     DEMAND.ITEM_ID     = CPS.ITEM_ID(+)
        ) DM
               ,GT_OPT_ENG_ESSD_DM_INS DT
        /* 원본 LEFT OUTER JOIN + WHERE DT.PLAN_ID IS NULL = 안티조인. (+) 형태로 등가 재현한다. */
        WHERE   DM.PLAN_ID   = DT.PLAN_ID(+)
        AND     DM.DEMAND_ID = DT.DEMAND_ID(+)
        AND     DT.PLAN_ID IS NULL;

        /* START 2025-11-13 */
        IF V_TBZ_YN = 'Y' THEN
            DELETE FROM GT_OPT_ENG_ESSD_TGTBIZ;

            INSERT INTO GT_OPT_ENG_ESSD_TGTBIZ (SCM_SITE_ID, ITEM_ID, STAGE, INCOTERMS, DUE_DATE, QUANTITY, PRIORITY, FCST_TYPE, PROJECT_CODE, PLAN_VERSION, QTY, YIELD, CHILD_QTY, PARENT_QTY, PQTY)
            SELECT AP.SCM_SITE_ID
                  ,BOM.CHILD_ITEM_ID AS ITEM_ID
                  ,'TARGETBIZ'     AS STAGE
                  ,'DAP'                AS INCOTERMS
                  ,AP.YYYYMMDD           AS DUE_DATE
                  ,(AP.QTY/NVL(RT.YIELD,1)) * (BOM.CHILD_QTY/BOM.PARENT_QTY) AS QUANTITY
                  ,1  AS PRIORITY
                  ,'-'                  AS FCST_TYPE
                  ,'-'                  AS PROJECT_CODE
                  ,'PROD_PLAN'          AS PLAN_VERSION
                  ,AP.QTY, RT.YIELD, BOM.CHILD_QTY, BOM.PARENT_QTY, BOM.CHILD_QTY/BOM.PARENT_QTY AS PQTY
            FROM   SCP_ANL_PRODUCTION_PLAN AP
                  ,SCP_OPT_ENG_MODEL_LIST_N_SN ML
                  ,SCM_MST_SITE MS
                  ,SCM_MST_BOM_ENG_SN BOM
                  ,GT_OPT_ENG_ESSD_BOM_S BOM_S
                  ,(SELECT R.DIVISION_ID
                                      , R.PLANT_ID
                                      , R.LINE_ID
                                      , R.ITEM_ID
                                      , R.MONTH
                                      , R.YIELD
                                      , R.STAGE
                                 FROM   GT_OPT_ENG_ESSD_ROUTING R
                                 WHERE  1 = 1
                                 /* AND    R.STAGE = 'ASSY' */
                                 ) RT
            /* ③FMT: ANSI OUTER JOIN -> 콤마 + (+) (포맷표준 §4.72 / FM-015). 아우터측 조건은 상수필터까지 전부 (+) — 누락 시 조용히 INNER 화된다. */
            WHERE   1 = 1
            AND     ML.PLAN_ID     = V_PLAN_ID||'_PACK'
            AND     AP.SCM_SITE_ID = ML.SCM_SITE_ID
            AND     AP.ITEM_ID     = ML.ITEM_ID
            AND     AP.DIVISION_ID = MS.DIVISION_ID
            AND     AP.SCM_SITE_ID = MS.SCM_SITE_ID
            AND     MS.SITE_TYPE = 'PLANT'
            AND     MS.DIVISION_ID = BOM.DIVISION_ID
            /* AND MS.PLANT_ID    = BOM.PLANT_ID -- BOM과 MST_SITE의 PLANT_ID가 다름 */
            AND     MS.COMPANY_ID  = BOM.COMPANY_ID
            AND     AP.ITEM_ID   = BOM.PARENT_ITEM_ID
            /* 원본 MSSQL: BOM.EFF_END_DATE > @V_PLAN_START_YYYYMMDD */


            /* MSSQL 은 'YYYYMMDD' 를 datetime 으로 변환해 비교하므로 TO_DATE 로 명시한다(결과 동일). */
            AND     BOM.EFF_END_DATE > TO_DATE(V_PLAN_START_YYYYMMDD,'YYYYMMDD')
            AND     BOM.CHILD_ITEM_ID IN (
                                          SELECT DISTINCT ITEM_ID
                                          FROM  SCP_OPT_ENG_MODEL_LIST_N_SN
                                          WHERE PLAN_ID = V_PLAN_ID
                                          )
            AND     BOM.COMPANY_ID     = BOM_S.COMPANY_ID
            AND     BOM.DIVISION_ID    = BOM_S.DIVISION_ID
            AND     BOM.PARENT_ITEM_ID = BOM_S.PARENT_ITEM_ID
            AND     BOM.CHILD_ITEM_ID  = BOM_S.CHILD_ITEM_ID
            AND     BOM.KEY_DATE       = BOM_S.M_KEY_DATE
            AND     RT.DIVISION_ID(+) = AP.DIVISION_ID
            /* AND  RT.PLANT_ID = MS.PLANT_ID -- BOM과 MST_SITE의 PLANT_ID가 다름 */
            /* AND RT.LINE_ID = AP.LINE_ID */
            AND     RT.ITEM_ID(+) = BOM.CHILD_ITEM_ID
            AND     RT.MONTH(+) = SUBSTR(AP.YYYYMMDD,1,6)
            AND     AP.DIVISION_ID         = V_DIVISION_ID
            AND     AP.PLAN_START_YYYYMMDD = V_SCP_PLAN_DATE
            AND     AP.PLAN_TYPE           = V_SCP_PLAN_TYPE
            AND     AP.SEQ                 = V_SCP_PLAN_SEQ
            AND     AP.QTY                 > 0
            AND     AP.MEASURE             = 'PROD_PLAN_AMEND'
            AND     AP.YYYYMMDD            <  V_PLAN_END_YYYYMMDD;

            INSERT INTO GT_OPT_ENG_ESSD_DM_INS
                (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
            WITH T AS (
                    SELECT T.SCM_SITE_ID
                         , T.ITEM_ID
                         , T.STAGE
                         , T.INCOTERMS
                         , T.DUE_DATE
                         , T.PRIORITY
                         , T.FCST_TYPE
                         , T.PROJECT_CODE
                         , T.PLAN_VERSION
                         , SUM(QUANTITY) AS QUANTITY
                    FROM   GT_OPT_ENG_ESSD_TGTBIZ T
                    GROUP BY T.SCM_SITE_ID, T.ITEM_ID, T.STAGE, T.INCOTERMS, T.DUE_DATE, T.PRIORITY, T.FCST_TYPE, T.PROJECT_CODE, T.PLAN_VERSION
                  )
            SELECT   V_PLAN_ID AS PLAN_ID
                    ,SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE||'@'||INCOTERMS||'@'||PROJECT_CODE||'::'||DUE_DATE||'::'||'-'||'::'||FCST_TYPE AS DEMAND_ID
                    ,SCM_SITE_ID||'::'||ITEM_ID||'::'||STAGE||'@'||INCOTERMS||'@'||PROJECT_CODE         AS BUFFER_ID
                    /* ,INCOTERMS+'@'+'D'+CONVERT(NVARCHAR,PRIORITY)                               AS DEMAND_GROUP */
                    ,INCOTERMS||'@'||STAGE                                                      AS DEMAND_GROUP
                    ,DUE_DATE                                                                   AS DUE_DATE
                    ,NULL                                                                       AS TARGET_DATE
                    ,NULL                                                                       AS SALES_CUTOFF_DATE
                    ,NULL                                                                       AS EXPIRY_DATE
                    ,PRIORITY                                                                   AS PRIORITY
                    ,QUANTITY                                                                   AS QUANTITY
                    /* ,'D'+CONVERT(NVARCHAR,PRIORITY)                                             AS PRIORITY_GROUP */
                    ,STAGE                                                                      AS PRIORITY_GROUP
                    ,NULL                                                                       AS CUSTOMER_ID
                    ,NULL                                                                       AS ALLOW_SHORT
                    ,SCM_SITE_ID                                                                AS ATTRIBUTE1
                    ,ITEM_ID                                                                    AS ATTRIBUTE2
                    ,STAGE                                                                      AS ATTRIBUTE3
                    ,INCOTERMS                                                                  AS ATTRIBUTE4
                    ,PROJECT_CODE                                                               AS ATTRIBUTE5
                    ,NULL                                                                       AS ATTRIBUTE6
                    ,NULL                                                                       AS ATTRIBUTE7
                    ,FCST_TYPE                                                                  AS ATTRIBUTE8
                    ,NULL                                                                       AS ATTRIBUTE9
                    ,NULL                                                                       AS ATTRIBUTE10
                    ,NULL                                                                       AS ATTRIBUTE11
                    ,NULL                                                                       AS ATTRIBUTE12
                    ,NULL                                                                       AS ATTRIBUTE13
                    ,PLAN_VERSION                                                               AS ATTRIBUTE14
                    ,NULL                                                                       AS ATTRIBUTE15
            FROM     T;
        END IF;
        /* END 2025-11-13 */

        /* 2. Shipment Plan Semi => Demand Insert : 소형 - Cell Plant 의 CHAR Stage에 Demand 처리 */
        /* 2025.05.07 Philsu Park: SHIPTMENT_SNAPSHOT_COUNT > 0 일 때는 해당 데이터 사용, 아닐때는 기존 로직으로 분기. */
        /* IF @V_DIVISION_ID = '40'
            IF @V_SHIPMENT_SNAP_CNT > 0
                BEGIN
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
                    SELECT   @V_PLAN_ID
                            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+DUE_DATE+'::'+TO_SITE+'::'+INCOTERMS+'::'+TRANSPORT_MODE+'::'+'REQ' AS DEMAND_ID
                            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE                                AS BUFFER_ID
                            --,TO_SITE                                                            AS DEMAND_GROUP
                            -- Ship Frozen 내인 경우 'SF'
                            ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                            END                                                                AS DEMAND_GROUP
                            ,DUE_DATE                                                           AS DUE_DATE
                            ,NULL                                                               AS TARGET_DATE
                            ,NULL                                                               AS SALES_CUTOFF_DATE
                            ,NULL                                                               AS EXPIRY_DATE
                            ,PRIORITY                                                           AS PRIORITY
                            -- Ship Frozen 내인 경우 ''
                            --,CASE WHEN SHIP_FROZEN = 'Y' THEN ''
                            --      ELSE NULL
                            -- END                                                                AS PRIORITY
                            ,QUANTITY                                                           AS QUANTITY
                            --,NULL                                                               AS PRIORITY_GROUP
                            -- Ship Frozen 내인 경우 'SF'
                            ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                            END                                                                AS PRIORITY_GROUP
                            ,NULL                                                               AS CUSTOMER_ID
                            ,NULL                                                               AS ALLOW_SHORT
                            ,SCM_SITE_ID                                                        AS ATTRIBUTE1
                            ,ITEM_ID                                                            AS ATTRIBUTE2
                            ,STAGE                                                              AS ATTRIBUTE3
                            ,INCOTERMS                                                          AS ATTRIBUTE4
                            ,NULL                                                               AS ATTRIBUTE5
                            ,TO_SITE                                                            AS ATTRIBUTE6
                            ,TRANSPORT_MODE                                                     AS ATTRIBUTE7
                            ,NULL                                                               AS ATTRIBUTE8
                            ,NULL                                                               AS ATTRIBUTE9
                            ,NULL                                                               AS ATTRIBUTE10
                            ,NULL                                                               AS ATTRIBUTE11
                            ,NULL                                                               AS ATTRIBUTE12
                            ,NULL                                                               AS ATTRIBUTE13
                            ,NULL                                                               AS ATTRIBUTE14
                            ,'SNAPSHOT'                                                         AS ATTRIBUTE15  --Snapshot 사용 마킹.
                    FROM   (
                            SELECT A.FROM_SITE          AS SCM_SITE_ID
                                ,A.TO_SITE              AS TO_SITE
                                ,A.ITEM_ID              AS ITEM_ID
                                ,'CHAR'                 AS STAGE
                                --,'EXW'          AS INCOTERMS
                                ,BOD.INCOTERMS          AS INCOTERMS
                                ,BOD.TRANSPORT_MODE     AS TRANSPORT_MODE
                                ,A.YYYYMMDD             AS DUE_DATE
                                ,CASE WHEN A.YYYYMMDD < @V_SHIP_FROZEN_DAY THEN 'Y'
                                      ELSE 'N'
                                      END               AS SHIP_FROZEN
                                ,SUM(A.QTY)             AS QUANTITY
                                ,TP.PRIORITY            AS PRIORITY
                            FROM SCP_OPT_ENG_SHIPMENT_PLAN_SEMI_SNAPSHOT_SN A WITH (NOLOCK)
                            ------------------------------------------------------------------------
                            INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                                        FROM   SCM_MST_SITE WITH(NOLOCK)
                                        WHERE  DIVISION_ID     = @V_DIVISION_ID
                                        AND    SITE_TYPE       = 'PLANT'
                                        AND    OPERATION_GROUP = 'A' -- 소형은 Cell 출하를 CEll Biz 용 Demand 만 처리
                                        AND    VALID_YN        = 'Y'
                                    ) B
                                ON    A.FROM_SITE   = B.SCM_SITE_ID
                                AND   A.DIVISION_ID = B.DIVISION_ID
                            ------------------------------------------------------------------------
                            INNER JOIN SCP_MST_BOD_N_V BOD WITH(NOLOCK)
                                ON    A.DIVISION_ID = BOD.DIVISION_ID
                                AND   A.BOD_ID      = BOD.BOD_ID
                            ------------------------------------------------------------------------
                            -- DEMAND 제외 대상 ITEM 정보 : WHERE 절에서 제외 조건 처리
                            -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                            ------------------------------------------------------------------------
                            LEFT JOIN ( SELECT  SEGMENT2   AS DIVISION_ID
                                                , SEGMENT3   AS SCM_SITE_ID
                                                , SEGMENT4   AS ITEM_ID
                                                , SEGMENT5   AS GROUP_ID
                                                , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                                    ELSE ATTRIBUTE2
                                                END AS START_DATE  -- PLAN 제외 시작일자
                                                , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                                    ELSE ATTRIBUTE3
                                                END AS END_DATE  -- PLAN 제외 끝일자
                                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                        WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                        AND    VALID_YN    = 'Y'
                                        AND    SEGMENT2    = @V_DIVISION_ID
                                        AND    SEGMENT5    = @V_GROUP_ID
                                        ) DE
                                ON  A.FROM_SITE = DE.SCM_SITE_ID
                                AND A.ITEM_ID   = DE.ITEM_ID
                            ------------------------------------------------------------------------
                            -- 2025.07.15 Philsu Park: 소형 Shipment SEMI 에도 Priority 값 반영.
                            ------------------------------------------------------------------------
                            LEFT OUTER JOIN ( --TOSITE PRIORITY CONSTRAINT
                                                SELECT   SEGMENT4   AS ITEM_ID
                                                        ,SEGMENT5   AS TO_SITE
                                                        ,SEGMENT6   AS PRIORITY
                                                        ,ATTRIBUTE1 AS FROM_DATE
                                                        ,ATTRIBUTE2 AS TO_DATE
                                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                                AND     SEGMENT2    = @V_DIVISION_ID
                                                AND     SEGMENT3    = @V_GROUP_ID
                                                AND     VALID_YN    = 'Y'
                                            ) TP
                                ON  A.FROM_SITE     = TP.TO_SITE
                                AND A.ITEM_ID       = TP.ITEM_ID
                                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
                            ------------------------------------------------------------------------
                            WHERE   A.DIVISION_ID           = @V_DIVISION_ID
                            AND     A.plan_start_yyyymmdd   = @V_SCP_PLAN_DATE
                            -- AND   A.plan_type           = @V_SCP_PLAN_TYPE
                            -- AND   A.seq                 = @V_SCP_PLAN_SEQ
                            AND     A.measure               = 'SHIP_PLAN_AMEND'
                            AND     A.QTY                   > 0
                            AND     A.YYYYMMDD             >= @P_PLAN_NAME
                            AND     A.YYYYMMDD              < @V_PLAN_END_YYYYMMDD
                            -- DEMAND 제외 대상 처리
                            -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
                            AND     (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                                OR  (ISNULL(DE.ITEM_ID, '') <> '' AND (A.YYYYMMDD < DE.START_DATE OR A.YYYYMMDD > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                                    )
                            AND     A.ITEM_ID              IN ( SELECT  DISTINCT ITEM_ID
                                                                FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                                                WHERE   PLAN_ID = @V_PLAN_ID
                                                                )
                            GROUP BY A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE, TP.PRIORITY
                            ) DEMAND
                END
            ELSE
                BEGIN

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
                    SELECT   @V_PLAN_ID
                            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE+'::'+DUE_DATE+'::'+TO_SITE+'::'+INCOTERMS+'::'+TRANSPORT_MODE+'::'+'REQ' AS DEMAND_ID
                            ,SCM_SITE_ID+'::'+ITEM_ID+'::'+STAGE                                AS BUFFER_ID
                            --,TO_SITE                                                            AS DEMAND_GROUP
                            -- Ship Frozen 내인 경우 'SF'
                            ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                            END                                                                AS DEMAND_GROUP
                            ,DUE_DATE                                                           AS DUE_DATE
                            ,NULL                                                               AS TARGET_DATE
                            ,NULL                                                               AS SALES_CUTOFF_DATE
                            ,NULL                                                               AS EXPIRY_DATE
                            ,PRIORITY                                                           AS PRIORITY
                            -- Ship Frozen 내인 경우 ''
                            --,CASE WHEN SHIP_FROZEN = 'Y' THEN ''
                            --      ELSE NULL
                            -- END                                                                AS PRIORITY
                            ,QUANTITY                                                           AS QUANTITY
                            --,NULL                                                               AS PRIORITY_GROUP
                            -- Ship Frozen 내인 경우 'SF'
                            ,CASE WHEN SHIP_FROZEN = 'Y' THEN 'SF'
                                ELSE IIF(ISNULL(PRIORITY, '') = '', NULL, 'D'+PRIORITY)
                            END                                                                AS PRIORITY_GROUP
                            ,NULL                                                               AS CUSTOMER_ID
                            ,NULL                                                               AS ALLOW_SHORT
                            ,SCM_SITE_ID                                                        AS ATTRIBUTE1
                            ,ITEM_ID                                                            AS ATTRIBUTE2
                            ,STAGE                                                              AS ATTRIBUTE3
                            ,INCOTERMS                                                          AS ATTRIBUTE4
                            ,NULL                                                               AS ATTRIBUTE5
                            ,TO_SITE                                                            AS ATTRIBUTE6
                            ,TRANSPORT_MODE                                                     AS ATTRIBUTE7
                            ,NULL                                                               AS ATTRIBUTE8
                            ,NULL                                                               AS ATTRIBUTE9
                            ,NULL                                                               AS ATTRIBUTE10
                            ,NULL                                                               AS ATTRIBUTE11
                            ,NULL                                                               AS ATTRIBUTE12
                            ,NULL                                                               AS ATTRIBUTE13
                            ,NULL                                                               AS ATTRIBUTE14
                            ,NULL                                                               AS ATTRIBUTE15
                    FROM   (
                            SELECT A.FROM_SITE          AS SCM_SITE_ID
                                ,A.TO_SITE              AS TO_SITE
                                ,A.ITEM_ID              AS ITEM_ID
                                ,'CHAR'                 AS STAGE
                                --,'EXW'          AS INCOTERMS
                                ,BOD.INCOTERMS          AS INCOTERMS
                                ,BOD.TRANSPORT_MODE     AS TRANSPORT_MODE
                                ,A.YYYYMMDD             AS DUE_DATE
                                ,CASE WHEN A.YYYYMMDD < @V_SHIP_FROZEN_DAY THEN 'Y'
                                      ELSE 'N'
                                      END               AS SHIP_FROZEN
                                ,SUM(A.QTY)             AS QUANTITY
                                ,TP.PRIORITY            AS PRIORITY
                            FROM SCP_ANL_SHIPMENT_PLAN_SEMI A WITH (NOLOCK)
                            ------------------------------------------------------------------------
                            INNER JOIN (SELECT DISTINCT DIVISION_ID, SCM_SITE_ID
                                        FROM   SCM_MST_SITE WITH (NOLOCK)
                                        WHERE  DIVISION_ID     = @V_DIVISION_ID
                                        AND    SITE_TYPE       = 'PLANT'
                                        AND    OPERATION_GROUP = 'A' -- 소형은 Cell 출하를 CEll Biz 용 Demand 만 처리
                                        AND    VALID_YN        = 'Y'

                                    ) B
                                ON    A.FROM_SITE   = B.SCM_SITE_ID
                                AND   A.DIVISION_ID = B.DIVISION_ID
                            ------------------------------------------------------------------------
                            INNER JOIN SCP_MST_BOD_N_V BOD WITH (NOLOCK)
                                ON    A.DIVISION_ID = BOD.DIVISION_ID
                                AND   A.BOD_ID      = BOD.BOD_ID
                            ------------------------------------------------------------------------
                            -- DEMAND 제외 대상 ITEM 정보 : WHERE 절에서 제외 조건 처리
                            -- 2025.05.19 Philsu Park: Demand 제외 처리 시 To 구간 제약 추가 적용.(ATT3)
                            ------------------------------------------------------------------------
                            LEFT JOIN ( SELECT  SEGMENT2   AS DIVISION_ID
                                                , SEGMENT3   AS SCM_SITE_ID
                                                , SEGMENT4   AS ITEM_ID
                                                , SEGMENT5   AS GROUP_ID
                                                , CASE WHEN ISNULL(ATTRIBUTE2, '') = '' THEN @V_PLAN_START_YYYYMMDD -- NULL 이면 전 구간 제외
                                                    ELSE ATTRIBUTE2
                                                END AS START_DATE  -- PLAN 제외 시작일자
                                                , CASE WHEN ISNULL(ATTRIBUTE3, '') = '' THEN @V_PLAN_END_YYYYMMDD -- NULL 이면 전 구간 제외
                                                    ELSE ATTRIBUTE3
                                                END AS END_DATE  -- PLAN 제외 끝일자
                                        FROM   SCP_OPMZ_LOOKUP_MASTER_DETAIL LV WITH(NOLOCK)
                                        WHERE  LOOKUP_TYPE = 'SCP_OPT_ENG_DEMAND_EXCEPTION'
                                        AND    VALID_YN    = 'Y'
                                        AND    SEGMENT2    = @V_DIVISION_ID
                                        AND    SEGMENT5    = @V_GROUP_ID
                                        ) DE
                                ON  A.FROM_SITE = DE.SCM_SITE_ID
                                AND A.ITEM_ID   = DE.ITEM_ID
                            ------------------------------------------------------------------------
                            -- 2025.07.15 Philsu Park: 소형 Shipment SEMI 에도 Priority 값 반영.
                            ------------------------------------------------------------------------
                            LEFT OUTER JOIN ( --TOSITE PRIORITY CONSTRAINT
                                                SELECT   SEGMENT4   AS ITEM_ID
                                                        ,SEGMENT5   AS TO_SITE
                                                        ,SEGMENT6   AS PRIORITY
                                                        ,ATTRIBUTE1 AS FROM_DATE
                                                        ,ATTRIBUTE2 AS TO_DATE
                                                FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL WITH(NOLOCK)
                                                WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_TOSITE_PRIORITY_NEW'
                                                AND     SEGMENT2    = @V_DIVISION_ID
                                                AND     SEGMENT3    = @V_GROUP_ID
                                                AND     VALID_YN    = 'Y'
                                            ) TP
                                ON  A.FROM_SITE     = TP.TO_SITE
                                AND A.ITEM_ID       = TP.ITEM_ID
                                AND A.YYYYMMDD BETWEEN TP.FROM_DATE AND TP.TO_DATE
                            ------------------------------------------------------------------------
                            WHERE A.DIVISION_ID         = @V_DIVISION_ID
                            AND   A.plan_start_yyyymmdd = @V_SCP_PLAN_DATE
                            AND   A.plan_type           = @V_SCP_PLAN_TYPE
                            AND   A.seq                 = @V_SCP_PLAN_SEQ
                            AND   A.measure             = 'SHIP_PLAN_AMEND'
                            AND   A.QTY                 > 0
                            AND   A.YYYYMMDD            >= @P_PLAN_NAME
                            AND   A.YYYYMMDD            < @V_PLAN_END_YYYYMMDD
                            -- DEMAND 제외 대상 처리
                            -- 2025.05.19 Philsu Park: (Demand YMD < Except FROM YMD OR Demand YMD > Except End YMD) 형태로 반영.
                            AND     (ISNULL(DE.ITEM_ID, '') = '' -- LOOKUP 에 등록되어 있지 않은 정보
                                OR  (ISNULL(DE.ITEM_ID, '') <> '' AND (A.YYYYMMDD < DE.START_DATE OR A.YYYYMMDD > DE.END_DATE)) -- LOOKUP 에 등록되어 있는 경우 START_DATE 이전 정보
                                    )
                            AND   A.ITEM_ID IN ( SELECT DISTINCT ITEM_ID
                                            FROM    SCP_OPT_ENG_MODEL_LIST_N_SN WITH(NOLOCK)
                                            WHERE   PLAN_ID = @V_PLAN_ID
                                            )
                            GROUP BY A.FROM_SITE, A.TO_SITE, A.ITEM_ID, A.YYYYMMDD, BOD.INCOTERMS, BOD.TRANSPORT_MODE, TP.PRIORITY

                            ) DEMAND

                END -- IF @V_DIVISION_ID = '40'
        */

        /* 2025.10.15 Philsu Park */
        /* Demand 뭉치기 대상 마킹을 위한 Temp Update. */
        UPDATE  GT_OPT_ENG_ESSD_DM_INS DM
        SET     DM.ATTRIBUTE15 = NVL( (SELECT MAX(LK.ATTRIBUTE1)
                                       FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LK
                                       WHERE   LK.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
                                       AND     LK.VALID_YN      = 'Y'
                                       AND     LK.SEGMENT2      = V_DIVISION_ID
                                       AND     LK.SEGMENT3      = V_GROUP_ID
                                       AND     LK.SEGMENT4      = DM.ATTRIBUTE1
                                       AND     LK.SEGMENT7      = DM.ATTRIBUTE2
                                       AND     LK.SEGMENT5      = DM.ATTRIBUTE3
                                       AND     DM.DUE_DATE     >= V_PROD_FROZEN_END_YMD), 'X')
        WHERE   DM.PLAN_ID      = V_PLAN_ID;

        /* 20251013/T.K.KIM/워크벤치에서 0으로 들어온 데이터는 NET DEMAND에서 안 가져오게하고 삭제 */
        DELETE FROM GT_OPT_ENG_ESSD_DM_INS
        WHERE PLAN_ID = V_PLAN_ID
        AND   QUANTITY = 0;

        DBMS_OUTPUT.PUT_LINE('5. Demand Origin Backup: ' || TO_CHAR(SYSTIMESTAMP, 'DD Mon YYYY HH24:MI:SS'));
        /* 1.3 Demand Origin Backup */
        /* 2025.06.10 Philsu Park: 원본 DEMAND 를 백업한다.(동일 PLAN_ID로 삭제 후 INSERT) */
        DELETE
        FROM    SCP_OPT_ENG_DEMAND_ORIGIN_SN
        WHERE   PLAN_ID = V_PLAN_ID;

        INSERT INTO SCP_OPT_ENG_DEMAND_ORIGIN_SN
            (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
            ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
            ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
            SELECT   PLAN_ID
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
            FROM    GT_OPT_ENG_ESSD_DM_INS DM
            WHERE   1=1
            AND     DM.PLAN_ID  = V_PLAN_ID;

        /* 1.4 Demand Insert */
        /* 2025.06.09 Philsu Park: A Type은 별도 처리. 나머지는 기존대로 넣어줌. */
        /* 2025.08.27 Philsu Park: C Type 추가. */
        INSERT INTO SCP_OPT_ENG_DEMAND_SN
            (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
            ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
            ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
            ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
            SELECT PLAN_ID
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
            FROM    GT_OPT_ENG_ESSD_DM_INS DM
            WHERE   1=1
            AND     DM.PLAN_ID  = V_PLAN_ID
            AND     DM.ATTRIBUTE15 NOT IN ('A', 'B', 'C'); /* 수요묶음에 해당하지 않는 대상만 처리. */

        /* 1.4 Demand Insert */
        /* 2025.06.09 Philsu Park: A Type 별도 처리. */
        /* 2025.08.25 Philsu Park: A Type의 value 기준을 주차가 아닌 일로 변경.(Due Date를 포함해야되서 Minus 1) */
        SELECT COUNT(*)
          INTO V_CNT
        FROM   GT_OPT_ENG_ESSD_DM_INS S
        WHERE 1=1
        AND S.PLAN_ID       = V_PLAN_ID
        AND S.ATTRIBUTE15   = 'A'
        AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD;

        IF V_CNT > 0 THEN
            DELETE FROM GT_OPT_ENG_ESSD_DMD_A;

            INSERT INTO GT_OPT_ENG_ESSD_DMD_A
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
            FROM    GT_OPT_ENG_ESSD_DM_INS S
                   ,SCM_SYS_CALENDAR_M CM
                   ,(SELECT    SEGMENT2                          AS DIVISION_ID
                                , SEGMENT3                          AS PLAN_GROUP_ID
                                , SEGMENT4                          AS SITE_ID
                                , SEGMENT5                          AS STAGE
                                , SEGMENT6                          AS LINE_ID
                                , SEGMENT7                          AS ITEM_ID
                                , ATTRIBUTE1                        AS DEMAND_MERGE_TYPE
                                , TO_NUMBER(ATTRIBUTE2) - 1         AS MERGE_VAL
                                /* , CAST(ATTRIBUTE2 AS INT) * 7       AS MERGE_VAL */
                                , ATTRIBUTE3                        AS DIO_VAL
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL D
                        WHERE   D.LOOKUP_TYPE   = 'SCP_OPT_ELEC_DEMAND_BUNDLE'
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
            AND S.DUE_DATE     >= V_PROD_FROZEN_END_YMD;

            INSERT INTO SCP_OPT_ENG_DEMAND_SN
                (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
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
                        FROM    GT_OPT_ENG_ESSD_DMD_A DM
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
                        FROM    GT_OPT_ENG_ESSD_DMD_A DM
                               ,RECURSIVE_DEMAND PREV
                        WHERE   1=1
                        AND     DM.ATTRIBUTE1 = PREV.ATTRIBUTE1
                        AND     DM.ATTRIBUTE2 = PREV.ATTRIBUTE2
                        AND     DM.ATTRIBUTE3 = PREV.ATTRIBUTE3
                        AND     DM.R_NUM      = PREV.R_NUM + 1
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
            GROUP BY FDM.PLAN_ID, FDM.ATTRIBUTE1, FDM.ATTRIBUTE2, FDM.ATTRIBUTE3, FDM.GROUP_NO, FDM.GROUP_START_DATE;
        END IF;

        /* 2. DEMAND GROUP */
            /* 2-1. DEMAND GROUP에 제품이 있고, 최소 하나 이상 등록된 SITE에 대해 모든 ITEM의 BUFFER를추가함 */
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
            SELECT V_PLAN_ID                                                                                       AS PLAN_ID
                   ,'DUMMY'||'::'||DG.SCM_SITE_ID||'::'||DG.ITEM_ID||'::'||DG.STAGE||'@'||DG.INCOTERMS||'@'||DG.PROJECT_CODE  AS DEMAND_ID
                   ,DG.SCM_SITE_ID||'::'||DG.ITEM_ID||'::'||DG.STAGE||'@'||DG.INCOTERMS||'@'||DG.PROJECT_CODE               AS BUFFER_ID
                   ,'GROUP_DEMAND'                                                                                  AS ATTRIBUTE13 /* 추후에 삭제를 위해 */
                   ,DG.SCM_SITE_ID                                                                                  AS SCM_SITE_ID
                   ,DG.ITEM_ID                                                                                      AS ITEM_ID
                   ,DG.STAGE                                                                                        AS STAGE
                   ,DG.INCOTERMS                                                                                    AS INCOTERMS
                   ,DG.PROJECT_CODE                                                                                 AS PROJECT_CODE
            FROM(
                SELECT  DG.DEMAND_GROUP                                        AS DEMAND_GROUP
                       ,DG.SCM_SITE_ID                                         AS SCM_SITE_ID
                       ,DG.INCOTERMS                                           AS INCOTERMS
                       ,LU.SEGMENT3                                            AS ITEM_ID
                       /* 2026.04.08 Minyong Lee : DEMAND_GROUP을 위한 DUMMY 생성 시 ESS Stage 판정 로직 오류 수정 */
                       ,CASE    WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID   = 'P9500'    THEN 'LINKBIZ'
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID   = 'PL450'    THEN 'LINKBIZ' /* 2026.05.26 Minyong Lee : ESS LINK 사내 공장 신설 대응 */
                                WHEN B.OPERATION_GROUP = 'P' AND B.FLOW_ID   = 'R5500'    THEN 'RACKBIZ'
                                WHEN B.OPERATION_GROUP = 'B' AND B.FLOW_ID   = 'P9500'    THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'B' AND B.FLOW_ID   = 'P5500'    THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'M' AND B.FLOW_ID   = 'P9500'    THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'M' AND B.FLOW_ID   = 'P5000'    AND LU.SEGMENT3 NOT LIKE 'EP%'  THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'M' AND B.FLOW_ID   = 'P5000'    AND LU.SEGMENT3 LIKE 'EP%'      THEN 'PACKBIZ'
                                WHEN B.OPERATION_GROUP = 'A' AND B.FLOW_ID   = 'A9000'    THEN 'CELLBIZ'
                                ELSE '-'
                            END                                                    AS STAGE
                      ,DG.PROJECT_CODE                                         AS PROJECT_CODE
                FROM(
                    SELECT  LU.SEGMENT4   AS DEMAND_GROUP
                           ,DM.ATTRIBUTE1 AS SCM_SITE_ID
                           ,DM.ATTRIBUTE4 AS INCOTERMS
                           ,DM.ATTRIBUTE5 AS PROJECT_CODE
                    FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU
                           ,SCP_OPT_ENG_DEMAND_SN DM
                    /* ③FMT: ANSI OUTER JOIN -> 콤마 + (+) (포맷표준 §4.72 / FM-015). 아우터측 조건은 상수필터까지 전부 (+) — 누락 시 조용히 INNER 화된다. */
                    WHERE   DM.PLAN_ID(+) = V_PLAN_ID
                    AND     DM.ATTRIBUTE2(+) = LU.SEGMENT3
                    AND     DM.ATTRIBUTE5(+) = LU.SEGMENT5
                    AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                    AND     LU.VALID_YN = 'Y'
                    AND     LU.SEGMENT2 = V_DIVISION_ID
                    GROUP BY DM.ATTRIBUTE1, LU.SEGMENT4, DM.ATTRIBUTE4, DM.ATTRIBUTE5
                    ) DG
                       ,SCP_OPMZ_LOOKUP_MASTER_DETAIL  LU
                       ,(SELECT DISTINCT DIVISION_ID, ITEM_ID, OPERATION_GROUP, FLOW_ID, ATTRIBUTE8
                                    FROM   SCP_MST_FINAL_ITEM
                                    WHERE  DIVISION_ID = V_DIVISION_ID
                                    AND   ((DIVISION_ID  = '40' AND OPERATION_GROUP IN ('A') ) /* 소형은 CEll Biz 용 Demand 만 처리 */
                                       OR  (DIVISION_ID <> '40' AND OPERATION_GROUP IN ('A', 'P') )
                                          )
                                   ) B
                WHERE   DG.DEMAND_GROUP = LU.SEGMENT4
                AND     LU.VALID_YN     = 'Y'
                AND     DG.PROJECT_CODE = LU.SEGMENT5 /* PROJECT추가 */
                AND     LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                AND     LU.SEGMENT2     = V_DIVISION_ID
                AND     LU.SEGMENT3     = B.ITEM_ID
                AND     V_DIVISION_ID   = B.DIVISION_ID
                )DG
            ) A
        WHERE DEMAND_ID IS NOT NULL;

            /* 2-2. 기존 DEMAND GROUP에 속한 DEMAND를 TEMP TABLE에 넣음 */
            DELETE FROM GT_OPT_ENG_ESSD_DM_TMP;

            INSERT INTO GT_OPT_ENG_ESSD_DM_TMP
                (PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15, GROUP_ID)
            SELECT  PLAN_ID
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
                   ,SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
            WHERE   DM.PLAN_ID = V_PLAN_ID
            AND     DM.ATTRIBUTE2 = LU.SEGMENT3
            AND     DM.ATTRIBUTE5 = LU.SEGMENT5
            AND     LU.LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
            AND     LU.VALID_YN = 'Y'
            AND     LU.SEGMENT2 = V_DIVISION_ID;
            /* 2-3. 기존 DEMAND GROUP에 속한 DEMAND위 키중복 방지와 추후 삭제를 위한 UPDATE */
            UPDATE SCP_OPT_ENG_DEMAND_SN D
            SET D.DEMAND_ID = 'D_'||D.DEMAND_ID, D.ATTRIBUTE13 = 'GROUP_DEMAND'
            WHERE EXISTS ( SELECT 1 FROM GT_OPT_ENG_ESSD_DM_TMP TMP
                           WHERE D.PLAN_ID   = TMP.PLAN_ID
                           AND   D.DEMAND_ID = TMP.DEMAND_ID );
            /* 2-4. 추가로 만든 GROUP에 대한 DEMAND INSERT */
            INSERT INTO SCP_OPT_ENG_DEMAND_SN(
                   PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
                  ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
                  ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
                  ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
            SELECT PLAN_ID             AS PLAN_ID
                  ,DEMAND_ID           AS DEMAND_ID
                  ,ATTRIBUTE1||'::'||GROUP_ID||'::'||ATTRIBUTE3||'@'||ATTRIBUTE4||'@'||ATTRIBUTE5 AS BUFFER_ID /* INCOTERMS 제외 */
                  ,DEMAND_GROUP        AS DEMAND_GROUP
                  ,DUE_DATE            AS DUE_DATE
                  ,TARGET_DATE         AS TARGET_DATE
                  ,SALES_CUTOFF_DATE   AS SALES_CUTOFF_DATE
                  ,EXPIRY_DATE         AS EXPIRY_DATE
                  ,PRIORITY            AS PRIORITY
                  ,QUANTITY            AS QUANTITY
                  ,PRIORITY_GROUP      AS PRIORITY_GROUP
                  ,CUSTOMER_ID         AS CUSTOMER_ID
                  ,ALLOW_SHORT         AS ALLOW_SHORT
                  ,ATTRIBUTE1          AS ATTRIBUTE1
                  ,GROUP_ID            AS ATTRIBUTE2
                  ,ATTRIBUTE3          AS ATTRIBUTE3
                  ,ATTRIBUTE4          AS ATTRIBUTE4
                  ,ATTRIBUTE5          AS ATTRIBUTE5
                  ,ATTRIBUTE6          AS ATTRIBUTE6
                  ,ATTRIBUTE7          AS ATTRIBUTE7
                  ,ATTRIBUTE8          AS ATTRIBUTE8
                  ,ATTRIBUTE9          AS ATTRIBUTE9
                  ,ATTRIBUTE10         AS ATTRIBUTE10
                  ,ATTRIBUTE11         AS ATTRIBUTE11
                  ,'DEMAND_GROUP'      AS ATTRIBUTE12
                  ,ATTRIBUTE13         AS ATTRIBUTE13
                  ,ATTRIBUTE14         AS ATTRIBUTE14
                  ,ATTRIBUTE15         AS ATTRIBUTE15
            FROM GT_OPT_ENG_ESSD_DM_TMP;

        /* 2. DEMAND Target Date Update */
        /* 2025.03.24 Bloack Target Date & Add Monlty Block for Speed */
        /* 2025.07.24 Philsu Park: DemandTargetDate LOOKUP 관리형태를 YMD 로 변경. */
        MERGE INTO SCP_OPT_ENG_DEMAND_SN D
        USING (
                SELECT DEMAND_ID, MAX(TARGET_DATE) AS TARGET_DATE
                FROM (
                        SELECT DM.DEMAND_ID
                              /* ,CASE WHEN TG.TYPE = 'MONTH' THEN CAL.LAST_MM_DAY */
                              /* WHEN TG.TYPE = 'WEEK'  THEN CAL.LAST_WW_DAY */
                              /* END AS TARGET_DATE */
                              ,CASE WHEN DM.DEMAND_GROUP = 'SF' THEN NULL
                                    WHEN TG.TYPE = 'MONTH' THEN CASE WHEN CAL.LAST_MM_DAY>V_PLAN_END_YYYYMMDD_ORI THEN V_PLAN_END_YYYYMMDD_ORI ELSE CAL.LAST_MM_DAY END
                                    WHEN TG.TYPE = 'WEEK'  THEN CASE WHEN CAL.LAST_WW_DAY>V_PLAN_END_YYYYMMDD_ORI THEN V_PLAN_END_YYYYMMDD_ORI ELSE CAL.LAST_WW_DAY END
                               END AS TARGET_DATE
                        FROM SCP_OPT_ENG_DEMAND_SN DM
                            ,(
                                    SELECT SITE_ID
                                          ,ITEM_ID
                                          ,FROM_YMD
                                          ,TO_YMD
                                          ,TYPE
                                    FROM(
                                        /* 원본 MSSQL: IIF(LU.ATTRIBUTE1 = '', @V_PLAN_START_YYYYMMDD, LU.ATTRIBUTE1) */
                                        /* Oracle 에서 x = '' 는 항상 UNKNOWN(死코드)이므로 RTRIM(..) IS NULL 로 변환한다. */
                                        /* LOOKUP_TYPE='SCP_OPT_ENG_CONST_DEMAND_TARGETDATE' 의 ATTRIBUTE1/2 는 */

                                        SELECT LU.SEGMENT3   AS SITE_ID
                                              ,LU.SEGMENT4   AS ITEM_ID
                                              ,CASE WHEN RTRIM(LU.ATTRIBUTE1) IS NULL THEN V_PLAN_START_YYYYMMDD ELSE LU.ATTRIBUTE1 END AS FROM_YMD
                                              ,CASE WHEN RTRIM(LU.ATTRIBUTE2) IS NULL THEN V_PLAN_END_YYYYMMDD_ORI ELSE LU.ATTRIBUTE2 END AS TO_YMD
                                              ,LU.SEGMENT5   AS TYPE

                                        FROM SCP_OPMZ_LOOKUP_MASTER_DETAIL LU
                                            ,SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2
                                        WHERE LU2.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND   LU.SEGMENT1 = LU2.SEGMENT2(+)
                                        AND   LU.SEGMENT4 = LU2.SEGMENT3(+)
                                        AND   LU2.VALID_YN(+) ='Y'
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
                                            ,SCP_OPMZ_LOOKUP_MASTER_DETAIL LU2
                                        WHERE LU2.LOOKUP_TYPE(+) = 'SCP_OPT_ENG_CONST_DEMAND_GROUP'
                                        AND   LU.SEGMENT1 = LU2.SEGMENT2(+)
                                        AND   LU.SEGMENT4 = LU2.SEGMENT3(+)
                                        AND   LU2.VALID_YN(+) ='Y'
                                        AND   LU.LOOKUP_TYPE  = 'SCP_OPT_ENG_CONST_DEMAND_TARGETDATE'
                                        AND   LU.SEGMENT1 = V_DIVISION_ID
                                        AND   LU.SEGMENT2 = V_GROUP_ID
                                        AND   LU.VALID_YN  ='Y'
                                        ) TG
                                    WHERE SITE_ID IS NOT NULL
                                    GROUP BY SITE_ID, ITEM_ID, FROM_YMD, TO_YMD, TYPE
                                    ) TG
                            ,(
                                    SELECT   CAL.BASIS_YYYYMMDD
                                            ,CASE WHEN TO_NUMBER(CAL.ISO_WEEK) - V_START_WEEK <0 THEN TO_NUMBER(CAL.ISO_WEEK)+52 - V_START_WEEK
                                             ELSE TO_NUMBER(CAL.ISO_WEEK) - V_START_WEEK
                                             END                                                                         AS PLAN_WEEK
                                            ,CAL.BASIS_END_DATE                                                          AS LAST_WW_DAY
                                            ,TO_CHAR(ADD_MONTHS(TO_DATE(BASIS_YYYYMM||'01','YYYYMMDD'),1) - 1,'YYYYMMDD') AS LAST_MM_DAY
                                    FROM    SCM_SYS_CALENDAR_M CAL
                                    WHERE   CAL.BASIS_YYYYMMDD >= V_PLAN_START_YYYYMMDD
                                    AND     CAL.BASIS_YYYYMMDD <=  V_PLAN_END_YYYYMMDD_ORI
                                    ) CAL
                        /* ③FMT: ANSI OUTER JOIN -> 콤마 + (+) (포맷표준 §4.72 / FM-015). 아우터측 조건은 상수필터까지 전부 (+) — 누락 시 조용히 INNER 화된다. */
                        WHERE DM.PLAN_ID = V_PLAN_ID
                        AND   DM.ATTRIBUTE1 = TG.SITE_ID
                        AND   DM.ATTRIBUTE2 = TG.ITEM_ID
                        AND   DM.DUE_DATE = CAL.BASIS_YYYYMMDD
                        AND   CAL.BASIS_YYYYMMDD BETWEEN TG.FROM_YMD AND TG.TO_YMD
                        AND   DM.PLAN_ID = V_PLAN_ID
                     )
                GROUP BY DEMAND_ID
              ) TD
        ON  ( D.PLAN_ID = V_PLAN_ID AND D.DEMAND_ID = TD.DEMAND_ID )
        WHEN MATCHED THEN UPDATE SET D.TARGET_DATE = TD.TARGET_DATE;

        /* Data Delete */
        /* 2025.08.12 Philsu Park: Workbench에서 0으로 들어온 케이스 제외. */
        DELETE FROM SCP_OPT_ENG_DEMAND_SN DT
        WHERE   DT.PLAN_ID  = V_PLAN_ID
        AND     DT.QUANTITY = 0;

        /* 2025.09.24/THKIM/ ESS 특정 케이스의 경우 DEMAND 추가 생성 */
        INSERT INTO SCP_OPT_ENG_DEMAND_SN(
               PLAN_ID, DEMAND_ID, BUFFER_ID, DEMAND_GROUP, DUE_DATE, TARGET_DATE, SALES_CUTOFF_DATE, EXPIRY_DATE
              ,PRIORITY, QUANTITY, PRIORITY_GROUP, CUSTOMER_ID, ALLOW_SHORT
              ,ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5, ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8
              ,ATTRIBUTE9, ATTRIBUTE10, ATTRIBUTE11, ATTRIBUTE12, ATTRIBUTE13, ATTRIBUTE14, ATTRIBUTE15)
        SELECT   V_PLAN_ID                                                                   AS PLAN_ID
                ,DA.TO_SITE_ID||'::'||DA.CHG_ITEM_ID||'::'||DA.STAGE||'@'||BOD.INCOTERMS||'@'||'-'||'::'||TO_CHAR(TO_DATE(DM.ATTRIBUTE1,'YYYYMMDD') - TO_NUMBER(BOD2.LT_TOTAL),'YYYYMMDD')||'::'||'-'||'::'||'-'||'::DA' AS DEMAND_ID
                ,DA.TO_SITE_ID||'::'||DA.CHG_ITEM_ID||'::'||DA.STAGE||'@'||BOD.INCOTERMS||'@'||'-'                                                      AS BUFFER_ID
                ,BOD.INCOTERMS || '@' || DA.STAGE                                                 AS DEMAND_GROUP
                ,TO_CHAR(TO_DATE(DM.ATTRIBUTE1,'YYYYMMDD') - TO_NUMBER(BOD2.LT_TOTAL),'YYYYMMDD') AS DUE_DATE
                ,NULL                                                                           AS TARGET_DATE
                ,NULL                                                                           AS SALES_CUTOFF_DATE
                ,NULL                                                                           AS EXPIRY_DATE
                ,NVL(TP.PRIORITY, CASE WHEN DA.STAGE = 'LINKBIZ' THEN 4
                                 WHEN DA.STAGE = 'RACKBIZ' THEN 5
                                 ELSE 6
                                 END
                   )                                                                        AS PRIORITY
                ,SUM(DM.QTY)*BOM.CHILD_QTY/BOM.PARENT_QTY                                       AS QUANTITY
                ,DA.STAGE                                                                       AS PRIORITY_GROUP
                ,NULL                                                                           AS CUSTOMER_ID
                ,NULL                                                                           AS ALLOW_SHORT
                ,DA.TO_SITE_ID                                                                  AS ATTRIBUTE1
                ,DA.CHG_ITEM_ID                                                                 AS ATTRIBUTE2
                ,DA.STAGE                                                                       AS ATTRIBUTE3
                ,BOD.INCOTERMS                                                                  AS ATTRIBUTE4
                ,'-'                                                                            AS ATTRIBUTE5
                ,NULL                                                                           AS ATTRIBUTE6
                ,NULL                                                                           AS ATTRIBUTE7
                ,'-'                                                                            AS ATTRIBUTE8
                ,NULL                                                                           AS ATTRIBUTE9
                ,NULL                                                                           AS ATTRIBUTE10
                ,NULL                                                                           AS ATTRIBUTE11
                ,NULL                                                                           AS ATTRIBUTE12
                ,NULL                                                                           AS ATTRIBUTE13
                ,NULL                                                                           AS ATTRIBUTE14
                ,NULL                                                                           AS ATTRIBUTE15
        FROM    DM_PLN_NET_DEMAND DM
               ,(
                        SELECT  SEGMENT3 AS ORIGIN_ITEM_ID
                               ,SEGMENT4 AS STAGE
                               ,SEGMENT5 AS CHG_ITEM_ID
                               ,SEGMENT6 AS FROM_SITE_ID
                               ,SEGMENT7 AS TO_SITE_ID
                               ,SEGMENT8 AS BOD_ID
                               ,SEGMENT9 AS ORIGIN_BOD_ID
                               ,CASE WHEN ATTRIBUTE1 IS NULL THEN V_PLAN_START_YYYYMMDD ELSE ATTRIBUTE1 END AS FROM_YYYYMMDD
                               ,CASE WHEN ATTRIBUTE2 IS NULL THEN V_PLAN_END_YYYYMMDD ELSE ATTRIBUTE1 END   AS TO_YYYYMMDD
                        FROM    SCP_OPMZ_LOOKUP_MASTER_DETAIL LV
                        WHERE   LOOKUP_TYPE = 'SCP_OPT_ENG_CONST_DEMAND_ADD'
                        AND     VALID_YN    = 'Y'
                        AND     SEGMENT1    = V_DIVISION_ID
                        AND     SEGMENT2    = V_GROUP_ID
                   ) DA
               ,SCM_MST_BOM_ENG_SN BOM
               ,( /* TOSITE PRIORITY CONSTRAINT */
                                /* 2025.11.18 Minyong Lee : Sales Site Priority Lookup -> UI 전환 */
                                SELECT  P.ITEM_ID       AS ITEM_ID
                                      , P.SCM_SITE_ID   AS TO_SITE
                                      , P.PRIO_RANK     AS PRIORITY
                                      , FROM_YYYYMMDD   AS FROM_DATE
                                      , TO_YYYYMMDD     AS TO_DATE
                                FROM    SCP_OPMZ_SALES_SITE_PRIORITY P
                                       ,SCP_OPMZ_PLAN_GR_M PG
                                WHERE   1=1
                                AND     P.OPMZ_PLAN_GR_ID = PG.OPMZ_PLAN_GR_ID(+)
                                AND     PG.VALID_YN(+) = 'Y'
                                AND     P.VALID_YN = 'Y'
                                AND     P.DIVISION_ID = V_DIVISION_ID
                                AND     PG.OPMZ_PLAN_GR_NAME = V_GROUP_ID
                            ) TP
               ,SCP_MST_BOD_N_V BOD
               ,SCP_MST_BOD_N_V BOD2
        /* ③FMT: ANSI OUTER JOIN -> 콤마 + (+) (포맷표준 §4.72 / FM-015). 아우터측 조건은 상수필터까지 전부 (+) — 누락 시 조용히 INNER 화된다. */
        WHERE   1=1
        AND     DM.ITEM_ID = DA.ORIGIN_ITEM_ID
        AND     DM.ATTRIBUTE1 >= DA.FROM_YYYYMMDD
        AND     DM.ATTRIBUTE1 <  DA.TO_YYYYMMDD
        AND     BOM.DIVISION_ID = V_DIVISION_ID
        AND     BOM.PARENT_ITEM_ID = DA.ORIGIN_ITEM_ID
        AND     BOM.CHILD_ITEM_ID  = DA.CHG_ITEM_ID
        AND     DM.SCM_SITE_ID = TP.TO_SITE(+)
        AND     DM.ITEM_ID     = TP.ITEM_ID(+)
        AND     DM.ATTRIBUTE1 BETWEEN TP.FROM_DATE(+) AND TP.TO_DATE(+)
        AND     BOD.DIVISION_ID = V_DIVISION_ID
        AND     BOD.BOD_ID      = DA.BOD_ID
        AND     BOD2.DIVISION_ID = V_DIVISION_ID
        AND     BOD2.BOD_ID      = DA.ORIGIN_BOD_ID
        AND     DM.DIVISION_ID     =  V_DIVISION_ID
        AND     DM.CUTOFF_YYYYMMDD =  V_DEMAND_CUTOFF_DAY
        AND     DM.VERSION_NO      =  V_DM_MAX_VERSION
        AND     DM.QTY             >  0
        AND     V_TBZ_YN            = 'N' /* Added 2025-11-13 */
        GROUP BY DA.TO_SITE_ID, DA.CHG_ITEM_ID, DA.STAGE, BOD.INCOTERMS, DM.PROJECT_CODE, DM.FCST_TYPE, DM.ATTRIBUTE1, TP.PRIORITY, BOM.CHILD_QTY, BOM.PARENT_QTY,BOD2.LT_TOTAL;

        /* Data Insert End */
    EXCEPTION
        /* ERROR LOG */
        WHEN OTHERS THEN
            V_MESSAGE_TEXT := SUBSTR('ERR_LINE : '||DBMS_UTILITY.FORMAT_ERROR_BACKTRACE||', ERR_MSG : '||SQLERRM, 1, 1000);
            PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'ERROR',NULL,V_MESSAGE_TEXT,NULL,V_PLAN_ID);
            V_DETAIL_DATE := SYSDATE;
            PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,V_DETAIL_DATE,NULL,V_MESSAGE_TEXT,'ERROR');
            RAISE_APPLICATION_ERROR(-20001, V_PROGRAM_NAME);
    END;

    /* 종료 LOG */
    IF V_MESSAGE_TEXT IS NULL THEN
        PR_SCP_OPT_ENG_LOG_CRE_PROC('I','INPUT',V_PLAN_ID,V_PROGRAM_NAME,'END',NULL,NULL,NULL,V_PLAN_ID);
        PR_SCP_OPT_ENG_LOG_DTL_PROC('U',V_PLAN_ID,'STEP01',NULL,NULL,NULL,NULL,NULL,NULL);
    END IF;
END PR_SCP_OPT_ENG_ESS_INPUT_DEMAND;