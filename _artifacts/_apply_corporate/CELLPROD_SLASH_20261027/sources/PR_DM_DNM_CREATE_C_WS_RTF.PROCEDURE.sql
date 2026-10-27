PROCEDURE           "PR_DM_DNM_CREATE_C_WS_RTF" 
(
      P_DIVISION_ID   IN  VARCHAR2
    , P_VERSION_NO    IN  VARCHAR2
)
/* ==============================================================================================================================================
 * PROGRAM ID   : PR_DM_DNM_CREATE_C_WS_RTF
 * DESCRIPTION  : W/S 의 Sales Site 의 RTF 를 생성 ( Shipment Plan 참조 )
 * PROGRAM HISTORY
 *==============================================================================================================================================
 *   DATE       IN CHARGE      DESCRIPTION
 *==============================================================================================================================================
 * 2021.11.09   hwi1993     [PJ20209643]    INITIAL RELEASE
 * 2021.11.16   HWI1993     룩업에 VALID 조건 추가
 * 2022.01.06   hwi1993     기존 데이터 삭제시 created_by 대신 last_updated_by로 변경
 * 2022.04.05   HWI1993     GM JV 작업
 * 2022.04.12   Hwi1993     확정구간의 ETA 와 미확정구간의 RTF 가 겹쳐서 발생하는 오류 수정
 * 2022.08.30   HWI1993     AS INV PK 오류 수정 ( DISTINCT 추가 )
 * 2022.11.04   HWI1993     [C20220916-000290] [SCM PI] DM 시스템의 AS RTF 정확도 향상을 위한 기능변경 건
 * 2022.11.22   HWI1993     [C20220916-000290] 오류 수정 재배포
 * 2024.02.19   JSSBAE      [E20240214-000835]_[영업마케팅 PI팀] 81번사업부 AS Inv 생성 로직 변경 요청
 * 2024.03.15   JSSBAE      [E20240226-000021]_52주구간 AS INV VIEW 확보
 * 2024.09.26   JSSBAE      [E20240926-001366]_[공급 SCM PI팀] AS 관련 메저 생성 시 SCPSSP RTF간 우선순위 지정(SCP RTF 우선시)
 *                          PR_DM_PLN_MKT_FCST_C_QTY_BALANCE_CREATE에서 기 생성된 RTF_SCP와 SSP_RTF가 겹치는 현상이 발생하여 수정
 * 2024.10.21   JSSBAE      [E20241007-000267]_[공급 SCM PI팀] AS 관련 메저 생성 시 SSP 기존 로직 제거
 *                          81, 81_JV들만 제거하고 다른 사업부는 현행과 동일하게 유지한다.
 * 2024.12.01   KANG_H.J    [PJ2024-50611] BPS 매출(RTF_SYS_RP Measrue) 전송 시 전 사업부 FROM_SITE_ID 추가
 * 2025.01.13   P.C.I       [E20250113-000270]_[공급/생산 SCM PI팀] 운송중 재고 AS RTF 산출시 적용 요청
 * 2025.01.31   JSSBAE      [E20250120-000036]_[공급/생산 SCM PI팀] AS Inv -> RTF 생성로직 개선 (재고 기반 RTF 산출)
 * 2025.02.05   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_CFM_MKT_DEMAND_PLAN 동기화
 * 2025.04.08   KANG.H.J    [PJ2025-50017] 소형 매출계획 동기화 개선 - DM_PLN_RTF_ALLOCATION 삭제처리
 * 2025.09.09   JSSBAE      [E20250909-000795]_Kangoo 모델 AS INV REQ 값 이상[RTF 미산출)
 * 2026.02.12   JSSBAE      [E20260212-001318]_MKT FCST Waterfall - RTF 조회 불가 현상
 * 2026.03.27   JSSBAE      [E20260327-001732]_[긴급] MKT FCST Watefall cut-off(자동차)_AS 물동 관련 오류 수정
 * 2026.05.26   JSSBAE      [E20260402-001736]_AS 관련 기능 개선 건
 * 2026.09.18   AJS         40·82 PLANT_SITE_ID, 81·82 END_CUSTOMER 빈값 채움값 ' '·'' → '-' 통일(14자리)
 *==============================================================================================================================================
 *   USAGE : EXEC PR_DM_DNM_CREATE_C_WS_RTF '82'
 *----------------------------------------------------------------------------------------------------------------------------------------------
 *     - ATTRIBUTE10 <> '' -> IS NOT NULL, V_INV_QTY 는 원본 INT(정수절단) -> TRUNC 적용
 *============================================================================================================================================== */
IS

    V_PROGRAM_NAME        VARCHAR2(150 CHAR) := 'PR_DM_DNM_CREATE_C_WS_RTF';
    V_LOG_TYPE            VARCHAR2(30 CHAR);
    N_LOG_COUNT           NUMBER := 0;
    V_LOG_MESSAGE         VARCHAR2(1000 CHAR);
    V_DESCRIPTION         VARCHAR2(500 CHAR);
    D_EVENT_DATE          DATE;
    N_DELETE_COUNT        NUMBER := 0;
    N_INSERT_COUNT        NUMBER := 0;
    V_CREATED_BY          VARCHAR2(150 CHAR) := 'SYSTEM_WS';

    V_START_YYYYMMDD      VARCHAR2(8 CHAR);
    V_SHIP_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CUTOFF_TYPE         VARCHAR2(50 CHAR);
    V_CUTOFF_YYYYMMDD     VARCHAR2(8 CHAR);


    I                     NUMBER;
    CNT                   NUMBER;
    SUB_I                 NUMBER;
    SUB_CNT               NUMBER;
    V_ALLOC_I             NUMBER;
    V_ALLOC_CNT           NUMBER;
    V_YYYYMMDD            VARCHAR2(8 CHAR);
    V_INV                 NUMBER(20,10);
    V_RTF                 NUMBER(20,10);
    V_SSP_RTF             NUMBER(20,10);
    V_MKT_FCST            NUMBER(20,10);
    V_MKT_FCST_NET        NUMBER(20,10);
    V_SCM_SITE_ID         VARCHAR2(30 CHAR);
    V_PROJECT_CODE        VARCHAR2(50 CHAR);
    V_ITEM_ID             VARCHAR2(50 CHAR);
    V_ALLOC_SUM_RTF       NUMBER(20,10);
    V_ALLOC_RTF           NUMBER(20,10);

    I_SUB                 NUMBER;
    CNT_SUB               NUMBER;
    V_DIVISION_ID         VARCHAR2(30 CHAR);
    V_DOM_EXP             VARCHAR2(3 CHAR);
    V_FCST_TYPE           VARCHAR2(20 CHAR);
    V_INCOTERMS           VARCHAR2(10 CHAR);
    V_PLANT_SITE_ID       VARCHAR2(30 CHAR);
    V_INV_QTY             NUMBER;

    V_SITE_SEQ            NUMBER;
    V_DATE                VARCHAR2(8 CHAR);
    V_MAX_DATE            VARCHAR2(8 CHAR);
    V_FROM_SITE           VARCHAR2(30 CHAR);
    V_FROM_PLANT          VARCHAR2(30 CHAR);

    V_SUM_REQ_QTY         NUMBER(30,10);
    V_REQ_QTY             NUMBER(30,10);
    V_REM_QTY             NUMBER(30,10);
    I_RCV                 NUMBER;
    CNT_RCV               NUMBER;
    V_INV_ADJ_QTY         NUMBER(30,10);
    V_KEY_VAL             NUMBER;

BEGIN

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## START OF PROCEDURE ##########';
    V_DESCRIPTION := '@P_DIVISION_ID: ' || P_DIVISION_ID || ' / @P_VERSION_NO: ' || P_VERSION_NO;
    D_EVENT_DATE  := SYSDATE;
    PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    V_LOG_MESSAGE := NULL;

    BEGIN

        /* 당주 월요일 */
        V_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

        BEGIN
            SELECT VERSION_TYPE
                 , YYYYMMDD
              INTO V_CUTOFF_TYPE
                 , V_CUTOFF_YYYYMMDD
              FROM DM_MST_VERSION A
             WHERE A.DIVISION_ID = P_DIVISION_ID
               AND A.VERSION_NO  = P_VERSION_NO;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
        END;

        V_SHIP_START_YYYYMMDD := TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD');

        /* --------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------- */
        DELETE FROM GT_PRDM_SSP;
        DELETE FROM GT_PRDM_END_RTF_RAW;
        DELETE FROM GT_PRDM_AS_INV;
        DELETE FROM GT_PRDM_END_RTF_LOOP;
        DELETE FROM GT_PRDM_AS_LOOP;
        DELETE FROM GT_PRDM_RTF;
        DELETE FROM GT_PRDM_RCV;
        DELETE FROM GT_PRDM_RTF_SITE;

        /* --------------------------------------------------------------------------------------- */
        /* 1. 기존 RTF 계열 삭제 ( 고객향 / AS Plant향 ) */
        /* --------------------------------------------------------------------------------------- */
        /* 고객향 */
        DELETE FROM DM_PLN_MKT_FCST_C A
         WHERE A.DIVISION_ID     = P_DIVISION_ID
           AND A.VERSION_NO      = P_VERSION_NO
           AND A.LAST_UPDATED_BY = V_CREATED_BY
           AND A.YYYYMMDD       >= V_START_YYYYMMDD
           AND A.MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');

        /* AS Plant향 */
        DELETE FROM DM_PLN_MKT_FCST_C A
         WHERE EXISTS ( SELECT 1
                          FROM SCM_MST_SITE B
                         WHERE A.DIVISION_ID     = B.DIVISION_ID
                           AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                           AND B.OPERATION_GROUP = 'W'
                           AND B.SITE_TYPE       = 'SALES' )
           AND A.DIVISION_ID     = P_DIVISION_ID
           AND A.VERSION_NO      = P_VERSION_NO
           AND A.LAST_UPDATED_BY = V_CREATED_BY
           AND A.YYYYMMDD       >= V_START_YYYYMMDD
           AND A.MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');

        /* [PJ2025-50017] 소형 : 고객향 */
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.CREATED_BY  = V_CREATED_BY
           AND A.YYYYMMDD   >= V_START_YYYYMMDD
           AND A.MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');

        /* [PJ2025-50017] 소형 : AS Plant향 */
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
         WHERE EXISTS ( SELECT 1
                          FROM SCM_MST_SITE B
                         WHERE A.DIVISION_ID     = B.DIVISION_ID
                           AND A.SCM_SITE_ID     = B.SCM_SITE_ID
                           AND B.OPERATION_GROUP = 'W'
                           AND B.SITE_TYPE       = 'SALES' )
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.CREATED_BY  = V_CREATED_BY
           AND A.YYYYMMDD   >= V_START_YYYYMMDD
           AND A.MEASURE IN ('RTF_SYS_RP', 'RTF_SCP', 'RTF', 'AS_SHIP_PLAN', 'RTF_PR');

        /* --------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRDM_SSP ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE
            , INCOTERMS, MEASURE, PLANT_SITE_ID, AS_SITE, ETA_YYYYMMDD, SHIP_YYYYMMDD, QTY, GUBUN, AS_FROM_PLANT )
        SELECT T0.DIVISION_ID
             , T0.PROJECT_CODE
             , T0.TO_SITE
             , T0.ITEM_ID
             , 'E'
             , T0.FCST_TYPE
             , T1.INCOTERMS
             , 'SSP_RTF'
             , CASE WHEN T0.DIVISION_ID LIKE '81%' THEN T0.FROM_SITE_PLANT_ID ELSE '' END
             , T3.SEGMENT1
             , T0.ETA_DATE
             , T0.YYYYMMDD
             , SUM(T0.QTY)
             , 'CONFIRM'
             , T3.SEGMENT2
          FROM SSP_ANL_SHIP_CONFIRM T0
          JOIN SCP_MST_BOD_N_V T1 ON T0.DIVISION_ID = T1.DIVISION_ID AND T0.BOD_ID = T1.BOD_ID
          JOIN SCP_MST_DISTRIBUTION_ROUTE T2 ON T2.ROUTE_ID = T1.ROUTE_ID
          JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T3 ON T0.FROM_SITE = T3.SEGMENT2 AND T3.LOOKUP_TYPE = 'AS_SITE_PLANT' AND T3.SEGMENT2 <> '-' AND T3.SEGMENT3 = P_DIVISION_ID AND T3.VALID_YN = 'Y'
          JOIN SCM_MST_SITE T4 ON T0.TO_SITE = T4.SCM_SITE_ID AND T0.DIVISION_ID = T4.DIVISION_ID AND T4.SITE_TYPE = 'SALES'
          JOIN SCM_ADM_LOOKUP_MASTER_DETAIL T5 ON T0.FCST_TYPE = T5.SEGMENT1 AND T5.LOOKUP_TYPE = 'SALES_TYPE_CODE2' AND T5.VALID_YN = 'Y'
          JOIN SCM_MST_SITE T6 ON T0.FROM_SITE = T6.SCM_SITE_ID AND T0.DIVISION_ID = T6.DIVISION_ID
         WHERE 1 = 1
           AND ( T0.YYYYMMDD BETWEEN V_SHIP_START_YYYYMMDD AND CASE WHEN P_DIVISION_ID LIKE '81%' THEN V_SHIP_START_YYYYMMDD ELSE TO_CHAR(TO_DATE(V_SHIP_START_YYYYMMDD, 'YYYYMMDD') + T6.SHIP_FROZEN, 'YYYYMMDD') END
                 OR ( T0.YYYYMMDD < TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD')
                      AND T0.ETA_DATE >= TO_CHAR(FN_NEXT_DAY(SYSDATE, 'MON') - 7, 'YYYYMMDD') )
               )
           AND T0.QTY <> 0
           AND T0.DIVISION_ID = P_DIVISION_ID
           AND T0.FCST_TYPE <> '-'
           AND T0.SHIPMENT_STATUS = 'C'
           AND T0.CHANGE_TYPE = 'C'
           AND T0.ETA_DATE IS NOT NULL
         GROUP BY T0.DIVISION_ID, T0.PROJECT_CODE, T0.TO_SITE, T0.ITEM_ID, T0.FCST_TYPE, T1.INCOTERMS
             , CASE WHEN T0.DIVISION_ID LIKE '81%' THEN T0.FROM_SITE_PLANT_ID ELSE '' END
             , T3.SEGMENT1, T0.ETA_DATE, T0.YYYYMMDD, T3.SEGMENT2;

        /* 소형 DOM_EXP 보정 1 ( YYYYMMDD 포함 ) */
        MERGE INTO GT_PRDM_SSP A
        USING ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.INCOTERMS, A.YYYYMMDD
                     , MAX(A.DOM_EXP) AS DOM_EXP
                  FROM DM_PLN_MKT_FCST_C A
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO  = P_VERSION_NO
                   AND A.YYYYMMDD BETWEEN V_START_YYYYMMDD AND TO_CHAR(ADD_MONTHS(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD'), 3), 'YYYYMMDD')
                   AND A.MEASURE IN ('RTF_SCP', 'MKT_FCST')
                 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.INCOTERMS, A.YYYYMMDD ) B
        ON (    B.DIVISION_ID  = A.DIVISION_ID
            AND B.PROJECT_CODE = A.PROJECT_CODE
            AND B.SCM_SITE_ID  = A.SCM_SITE_ID
            AND B.ITEM_ID      = A.ITEM_ID
            AND B.FCST_TYPE    = A.FCST_TYPE
            AND B.INCOTERMS    = A.INCOTERMS
            AND B.YYYYMMDD     = A.ETA_YYYYMMDD )
        WHEN MATCHED THEN UPDATE SET A.DOM_EXP = B.DOM_EXP;

        /* 동일 일자 값 없는 건 : YYYYMMDD 제외 재보정 ( DOM_EXP='E' 인 건만 ) */
        MERGE INTO GT_PRDM_SSP A
        USING ( SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.INCOTERMS
                     , MAX(A.DOM_EXP) AS DOM_EXP
                  FROM DM_PLN_MKT_FCST_C A
                 WHERE A.DIVISION_ID = P_DIVISION_ID
                   AND A.VERSION_NO  = P_VERSION_NO
                   AND A.YYYYMMDD BETWEEN V_START_YYYYMMDD AND TO_CHAR(ADD_MONTHS(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD'), 3), 'YYYYMMDD')
                   AND A.MEASURE IN ('RTF_SCP', 'MKT_FCST')
                 GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.FCST_TYPE, A.INCOTERMS ) B
        ON (    B.DIVISION_ID  = A.DIVISION_ID
            AND B.PROJECT_CODE = A.PROJECT_CODE
            AND B.SCM_SITE_ID  = A.SCM_SITE_ID
            AND B.ITEM_ID      = A.ITEM_ID
            AND B.FCST_TYPE    = A.FCST_TYPE
            AND B.INCOTERMS    = A.INCOTERMS )
        WHEN MATCHED THEN UPDATE SET A.DOM_EXP = B.DOM_EXP WHERE A.DOM_EXP = 'E';

        /* --------------------------------------------------------------------------------------- */
        /* 고객향 RTF / MKT FCST -> GT_PRDM_END_RTF_RAW */
        /* [E20241007-000267] 81 사업부는 SSP RTF 미사용. 82/40 만 SSP 구간 생성. */
        /* --------------------------------------------------------------------------------------- */
        IF P_DIVISION_ID IN ('82', '40') THEN
            INSERT INTO GT_PRDM_END_RTF_RAW ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, FROM_SITE, AS_PLANT )
            SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                 , A.FCST_TYPE, A.INCOTERMS, 'SSP_RTF', CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '' END, A.ETA_YYYYMMDD
                 , A.FCST_TYPE, A.INCOTERMS, 'SSP_RTF', CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END, A.ETA_YYYYMMDD
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
                 , SUM(A.QTY)
                 , A.AS_SITE, A.AS_FROM_PLANT
              FROM GT_PRDM_SSP A
             GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                 , A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '' END, A.ETA_YYYYMMDD, A.AS_SITE, A.AS_FROM_PLANT;
                 , A.FCST_TYPE, A.INCOTERMS, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END, A.ETA_YYYYMMDD, A.AS_SITE, A.AS_FROM_PLANT;
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
        END IF;

        /* 고객향 MKT FCST INSERT */
        INSERT INTO GT_PRDM_END_RTF_RAW ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, MF_QTY, RTF_QTY, FROM_SITE, AS_PLANT )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
             , A.FCST_TYPE, A.INCOTERMS, 'MKT_FCST', A.PLANT_SITE_ID, A.YYYYMMDD
             , SUM(A.QTY), SUM(A.QTY), 0, C.SEGMENT1, A.ATTRIBUTE10
          FROM DM_PLN_MKT_FCST_C A
          JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID
                             AND A.ATTRIBUTE10 = B.SCM_SITE_ID
                             AND B.OPERATION_GROUP = 'W'
                             AND B.SITE_TYPE = 'PLANT'
          JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON B.SCM_SITE_ID = C.SEGMENT2 AND B.DIVISION_ID = C.SEGMENT3 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT'
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE IN ('MKT_FCST')
           AND A.YYYYMMDD >= V_START_YYYYMMDD
           AND A.ATTRIBUTE10 IS NOT NULL  /* 원본 ATTRIBUTE10 <> '' */
         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
             , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMMDD, A.ATTRIBUTE10, C.SEGMENT1
        HAVING SUM(A.QTY) <> 0;  /* [E20260327-001732] QTY 0 제외 */

        /* #RAW 에 LT 추가 */
        MERGE INTO GT_PRDM_END_RTF_RAW A
        USING ( SELECT FROM_SITE, TO_SITE, INCOTERMS, LT_TOTAL
                  FROM ( SELECT FROM_SITE, TO_SITE, INCOTERMS, LT_TOTAL
                              , ROW_NUMBER() OVER ( PARTITION BY FROM_SITE, TO_SITE, INCOTERMS ORDER BY PRIORITY ) AS PRT
                           FROM SCP_MST_BOD_V
                          WHERE DIVISION_ID = P_DIVISION_ID
                            AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD )
                 WHERE PRT = 1 ) B
        ON ( A.AS_PLANT = B.FROM_SITE AND A.SCM_SITE_ID = B.TO_SITE AND A.INCOTERMS = B.INCOTERMS )
        WHEN MATCHED THEN UPDATE SET A.LT_DAYS = B.LT_TOTAL;

        /* SEQ ( DENSE_RANK by YYYYMMDD ) */
        MERGE INTO GT_PRDM_END_RTF_RAW A
        USING ( SELECT KEY_VAL
                     , DENSE_RANK() OVER ( PARTITION BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID ORDER BY YYYYMMDD ) AS SEQ
                  FROM GT_PRDM_END_RTF_RAW ) B
        ON ( A.KEY_VAL = B.KEY_VAL )
        WHEN MATCHED THEN UPDATE SET A.SEQ = B.SEQ;

        /* MF_SEQ ( MKT_FCST 한정 DENSE_RANK by YYYYMMDD,QTY ) */
        MERGE INTO GT_PRDM_END_RTF_RAW A
        USING ( SELECT KEY_VAL
                     , DENSE_RANK() OVER ( PARTITION BY DIVISION_ID, SCM_SITE_ID, PROJECT_CODE, ITEM_ID ORDER BY YYYYMMDD, QTY ) AS SEQ
                  FROM GT_PRDM_END_RTF_RAW
                 WHERE MEASURE = 'MKT_FCST' ) B
        ON ( A.KEY_VAL = B.KEY_VAL )
        WHEN MATCHED THEN UPDATE SET A.MF_SEQ = B.SEQ;

        /* --------------------------------------------------------------------------------------- */
        /* 고객향 SITE 재고 루프 ( SEQ 0부터 ROW_NUMBER 채번 ) */
        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRDM_END_RTF_LOOP ( SCM_SITE_ID, PROJECT_CODE, ITEM_ID, SEQ )
        SELECT SCM_SITE_ID, PROJECT_CODE, ITEM_ID
             , ROW_NUMBER() OVER ( ORDER BY SCM_SITE_ID, PROJECT_CODE, ITEM_ID ) - 1
          FROM ( SELECT DISTINCT SCM_SITE_ID, PROJECT_CODE, ITEM_ID FROM GT_PRDM_END_RTF_RAW );

        SELECT 0, MAX(SEQ) INTO I, CNT FROM GT_PRDM_END_RTF_LOOP;
        V_SCM_SITE_ID  := NULL;
        V_PROJECT_CODE := NULL;
        V_ITEM_ID      := NULL;

        WHILE I <= CNT LOOP

            SELECT SCM_SITE_ID, PROJECT_CODE, ITEM_ID
              INTO V_SCM_SITE_ID, V_PROJECT_CODE, V_ITEM_ID
              FROM GT_PRDM_END_RTF_LOOP
             WHERE SEQ = I;

            SELECT 1, NVL(MAX(A.SEQ), 0), 0, 0, 0, 0, 0, NULL
              INTO SUB_I, SUB_CNT, V_INV, V_RTF, V_SSP_RTF, V_MKT_FCST, V_MKT_FCST_NET, V_YYYYMMDD
              FROM GT_PRDM_END_RTF_RAW A
             WHERE A.SCM_SITE_ID  = V_SCM_SITE_ID
               AND A.PROJECT_CODE = V_PROJECT_CODE
               AND A.ITEM_ID      = V_ITEM_ID
               AND A.MEASURE IN ('SSP_RTF', 'MKT_FCST');

            WHILE ( SUB_I <= SUB_CNT ) LOOP

                SELECT SUM(CASE WHEN A.MEASURE = 'SSP_RTF' THEN A.QTY ELSE 0 END)
                     , SUM(CASE WHEN A.MEASURE = 'MKT_FCST' THEN A.QTY ELSE 0 END)
                     , MAX(A.YYYYMMDD)
                  INTO V_SSP_RTF, V_MKT_FCST, V_YYYYMMDD
                  FROM GT_PRDM_END_RTF_RAW A
                 WHERE A.SCM_SITE_ID  = V_SCM_SITE_ID
                   AND A.PROJECT_CODE = V_PROJECT_CODE
                   AND A.ITEM_ID      = V_ITEM_ID
                   AND A.MEASURE IN ('SSP_RTF', 'MKT_FCST')
                   AND A.SEQ = SUB_I;

                /* 당일의 기초재고 및 요청총량 계산 */
                V_INV          := V_INV + NVL(V_SSP_RTF, 0);
                V_MKT_FCST_NET := V_MKT_FCST_NET + NVL(V_MKT_FCST, 0);

                IF V_INV >= V_MKT_FCST_NET THEN
                    V_INV          := V_INV - V_MKT_FCST_NET;
                    V_RTF          := V_MKT_FCST_NET;
                    V_MKT_FCST_NET := 0;
                ELSE
                    V_RTF          := V_INV;
                    V_MKT_FCST_NET := V_MKT_FCST_NET - V_INV;
                    V_INV          := 0;
                END IF;

                IF ( V_RTF > 0 ) THEN

                    SELECT 0, 0, MIN(A.SEQ)
                      INTO V_ALLOC_SUM_RTF, V_ALLOC_RTF, V_ALLOC_I
                      FROM GT_PRDM_END_RTF_RAW A
                     WHERE A.SCM_SITE_ID  = V_SCM_SITE_ID
                       AND A.PROJECT_CODE = V_PROJECT_CODE
                       AND A.ITEM_ID      = V_ITEM_ID
                       AND A.MEASURE IN ('MKT_FCST')
                       AND A.SEQ <= SUB_I
                       AND A.RTF_QTY < A.MF_QTY;

                    /* 하나씩 풀면서 V_RTF 숫자에 도달할때까지 넣어준다. */
                    WHILE ( V_ALLOC_SUM_RTF < V_RTF ) LOOP

                        V_ALLOC_RTF := 0;

                        BEGIN
                            SELECT CASE WHEN A.QTY - NVL(A.RTF_QTY, 0) < V_RTF - V_ALLOC_SUM_RTF THEN A.QTY - NVL(A.RTF_QTY, 0)
                                        ELSE V_RTF - V_ALLOC_SUM_RTF END
                              INTO V_ALLOC_RTF
                              FROM GT_PRDM_END_RTF_RAW A
                             WHERE A.SCM_SITE_ID  = V_SCM_SITE_ID
                               AND A.PROJECT_CODE = V_PROJECT_CODE
                               AND A.ITEM_ID      = V_ITEM_ID
                               AND A.MEASURE IN ('MKT_FCST')
                               AND A.SEQ = V_ALLOC_I
                               AND ROWNUM = 1;
                        EXCEPTION
                            WHEN NO_DATA_FOUND THEN EXIT;
                        END;

                        INSERT INTO GT_PRDM_END_RTF_RAW ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD, QTY, FROM_SITE, AS_PLANT )
                        SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, 'RTF', PLANT_SITE_ID, V_YYYYMMDD
                             , V_ALLOC_RTF, FROM_SITE, AS_PLANT
                          FROM GT_PRDM_END_RTF_RAW A
                         WHERE A.SCM_SITE_ID  = V_SCM_SITE_ID
                           AND A.PROJECT_CODE = V_PROJECT_CODE
                           AND A.ITEM_ID      = V_ITEM_ID
                           AND A.MEASURE IN ('MKT_FCST')
                           AND A.SEQ = V_ALLOC_I;

                        UPDATE GT_PRDM_END_RTF_RAW
                           SET RTF_QTY = NVL(RTF_QTY, 0) + V_ALLOC_RTF
                         WHERE SCM_SITE_ID  = V_SCM_SITE_ID
                           AND PROJECT_CODE = V_PROJECT_CODE
                           AND ITEM_ID      = V_ITEM_ID
                           AND MEASURE IN ('MKT_FCST')
                           AND SEQ = V_ALLOC_I;

                        V_ALLOC_SUM_RTF := V_ALLOC_SUM_RTF + V_ALLOC_RTF;
                        V_ALLOC_I       := V_ALLOC_I + 1;
                    END LOOP;

                END IF;

                SUB_I := SUB_I + 1;
            END LOOP;

            I := I + 1;
        END LOOP;

        /* --------------------------------------------------------------------------------------- */
        /* [E20240926-001366] SCP RTF 우선 : 겹치는 SSP RTF 제거 */
        /* --------------------------------------------------------------------------------------- */
        DELETE FROM GT_PRDM_END_RTF_RAW R
         WHERE EXISTS ( SELECT 1
                          FROM DM_PLN_MKT_FCST_C M
                         WHERE M.DIVISION_ID     = R.DIVISION_ID
                           AND M.VERSION_NO      = P_VERSION_NO
                           AND M.CUTOFF_TYPE     = V_CUTOFF_TYPE
                           AND M.CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
                           AND M.PROJECT_CODE    = R.PROJECT_CODE
                           AND M.SCM_SITE_ID     = R.SCM_SITE_ID
                           AND M.ITEM_ID         = R.ITEM_ID
                           AND M.DOM_EXP         = R.DOM_EXP
                           AND M.FCST_TYPE       = R.FCST_TYPE
                           AND M.INCOTERMS       = R.INCOTERMS
                           AND M.PLANT_SITE_ID   = R.PLANT_SITE_ID
                           AND M.YYYYMMDD        = R.YYYYMMDD
                           AND M.MEASURE IN ('RTF', 'RTF_SCP', 'RTF_SYS_RP', 'RTF_PR') );

        /* --------------------------------------------------------------------------------------- */
        /* 계산된 RTF / 소형 동기화 INSERT ( 82, 40 ) */
        /* --------------------------------------------------------------------------------------- */
        IF P_DIVISION_ID IN ('82', '40') THEN

            INSERT INTO DM_PLN_MKT_FCST_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
                , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID, P_VERSION_NO, V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
                 , SUM(A.QTY)
                 , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                 , '', '', '', '', ''
                 , '', '', '', '', A.AS_PLANT
              FROM GT_PRDM_END_RTF_RAW A
              JOIN ( SELECT 'RTF' AS MEASURE FROM DUAL
                     UNION ALL SELECT 'RTF_SCP' FROM DUAL
                     UNION ALL SELECT 'RTF_SYS_RP' FROM DUAL
                     UNION ALL SELECT 'RTF_PR' FROM DUAL ) B ON 1 = 1
             WHERE A.MEASURE = 'RTF'
             GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMMDD, B.MEASURE, A.AS_PLANT;

            /* [PJ2025-50017] 소형 동기화 */
            INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, END_CUSTOMER
                , SCM_SITE_ID, ITEM_ID, DOM_EXP
                , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
                , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID, P_VERSION_NO, V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE
                 -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (START)
--                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE ' ' END
                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '/' END
                 -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (END)
                 , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, A.PLANT_SITE_ID, '-', A.YYYYMMDD
                 , SUM(A.QTY)
                 , V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                 , '', NULL, '', '', ''
                 , '', '', '', '', A.AS_PLANT
              FROM GT_PRDM_END_RTF_RAW A
              JOIN ( SELECT 'RTF' AS MEASURE FROM DUAL
                     UNION ALL SELECT 'RTF_SCP' FROM DUAL
                     UNION ALL SELECT 'RTF_SYS_RP' FROM DUAL
                     UNION ALL SELECT 'RTF_PR' FROM DUAL ) B ON 1 = 1
             WHERE A.MEASURE = 'RTF'
             GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                 , A.FCST_TYPE, A.INCOTERMS, A.PLANT_SITE_ID, A.YYYYMMDD, B.MEASURE, A.AS_PLANT;

        END IF;

        /* --------------------------------------------------------------------------------------- */
        /* AS SITE( PLANT )에 SHIPMENT_PLAN 생성 ( 82, 40 ) */
        /* --------------------------------------------------------------------------------------- */
        IF P_DIVISION_ID IN ('82', '40') THEN

            INSERT INTO DM_PLN_MKT_FCST_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
                , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
                , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID, P_VERSION_NO, V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE, A.AS_SITE, A.ITEM_ID, MAX(A.DOM_EXP)
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                 , MAX(A.FCST_TYPE), MAX(A.INCOTERMS), 'AS_SHIP_PLAN', MAX(CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END), A.SHIP_YYYYMMDD
                 , MAX(A.FCST_TYPE), MAX(A.INCOTERMS), 'AS_SHIP_PLAN', MAX(CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END), A.SHIP_YYYYMMDD
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
                 , SUM(A.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                 , '', '', '', '', ''
                 , '', '', '', '', ''
              FROM GT_PRDM_SSP A
             WHERE A.SHIP_YYYYMMDD >= V_START_YYYYMMDD
             GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.AS_SITE, A.ITEM_ID, A.SHIP_YYYYMMDD;

            /* [PJ2025-50017] 소형 동기화 */
            INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
                ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
                , PROJECT_CODE, END_CUSTOMER
                , SCM_SITE_ID, ITEM_ID, DOM_EXP
                , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
                , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
                , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
                , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
            SELECT A.DIVISION_ID, P_VERSION_NO, V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
                 , A.PROJECT_CODE
                 -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (START)
--                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE ' ' END
                 , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '/' END
                 -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (END)
                 , A.AS_SITE, A.ITEM_ID, MAX(A.DOM_EXP)
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                 , MAX(A.FCST_TYPE), MAX(A.INCOTERMS), 'AS_SHIP_PLAN', MAX(CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END), '-', A.SHIP_YYYYMMDD
                 , MAX(A.FCST_TYPE), MAX(A.INCOTERMS), 'AS_SHIP_PLAN', MAX(CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END), '-', A.SHIP_YYYYMMDD
                 -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
                 , SUM(A.QTY), V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
                 , '', NULL, '', '', ''
                 , '', '', '', '', ''
              FROM GT_PRDM_SSP A
             WHERE A.SHIP_YYYYMMDD >= V_START_YYYYMMDD
             GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.AS_SITE, A.ITEM_ID, A.SHIP_YYYYMMDD;

        END IF;

        /* --------------------------------------------------------------------------------------- */
        /* AS SITE( PLANT )에서 SHIPMENT_PLAN 이용 AS_INV 재계산 -> GT_PRDM_AS_INV */
        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY )
        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.YYYYMMDD, A.PLANT_SITE_ID, A.QTY
          FROM DM_PLN_MKT_FCST_C A
          JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND B.OPERATION_GROUP = 'W' AND B.SITE_TYPE = 'SALES'
         WHERE A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE IN ('AS_In_Plan', 'AS_SHIP_PLAN')
           AND A.YYYYMMDD >= V_START_YYYYMMDD;

        /* 기존 AS_INV 메저 보유행에 SITE_SEQ=1 */
        MERGE INTO GT_PRDM_AS_INV A
        USING ( SELECT DISTINCT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                  FROM DM_PLN_MKT_FCST_C
                 WHERE YYYYMMDD = TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
--                 AND MEASURE = 'AS_INV'   --  2026.10.08 AJS
                   AND MEASURE = 'AS_Inv'   --  2026.10.08 AJS
                   AND DIVISION_ID = P_DIVISION_ID
                   AND VERSION_NO  = P_VERSION_NO ) B
        ON (    A.DIVISION_ID   = B.DIVISION_ID
            AND A.PROJECT_CODE  = B.PROJECT_CODE
            AND A.SCM_SITE_ID   = B.SCM_SITE_ID
            AND A.ITEM_ID       = B.ITEM_ID
            AND A.DOM_EXP       = B.DOM_EXP
            AND A.FCST_TYPE     = B.FCST_TYPE
            AND A.INCOTERMS     = B.INCOTERMS
            AND A.PLANT_SITE_ID = B.PLANT_SITE_ID )
        WHEN MATCHED THEN UPDATE SET A.SITE_SEQ = 1;

        /* 한 SITE,ITEM 에 SITE_SEQ=1 여러개면 조정( NULL ) */
        MERGE INTO GT_PRDM_AS_INV A
        USING ( SELECT KEY_VAL
                  FROM ( SELECT KEY_VAL
                              , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY KEY_VAL ) AS SUB_SEQ
                           FROM GT_PRDM_AS_INV
                          WHERE SITE_SEQ = 1 )
                 WHERE SUB_SEQ <> 1 ) B
        ON ( A.KEY_VAL = B.KEY_VAL )
        WHEN MATCHED THEN UPDATE SET A.SITE_SEQ = NULL;

        /* SITE_SEQ 없는 SITE 조정 */
        MERGE INTO GT_PRDM_AS_INV A
        USING ( SELECT C.KEY_VAL
                  FROM ( SELECT KEY_VAL, DIVISION_ID, SCM_SITE_ID, ITEM_ID
                              , ROW_NUMBER() OVER ( PARTITION BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ORDER BY KEY_VAL DESC ) AS ROW_NUM
                           FROM GT_PRDM_AS_INV ) C
                  JOIN ( SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, MIN(SITE_SEQ) AS SITE_SEQ
                           FROM GT_PRDM_AS_INV
                          GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ) D
                    ON C.DIVISION_ID = D.DIVISION_ID AND C.SCM_SITE_ID = D.SCM_SITE_ID AND C.ITEM_ID = D.ITEM_ID
                 WHERE D.SITE_SEQ IS NULL
                   AND C.ROW_NUM = 1 ) B
        ON ( A.KEY_VAL = B.KEY_VAL )
        WHEN MATCHED THEN UPDATE SET A.SITE_SEQ = 1;

        /* --------------------------------------------------------------------------------------- */
        /* [E20240214-000835] 기초재고 추가 ( 81 / 그 외 분기 ) */
        /* --------------------------------------------------------------------------------------- */
        IF P_DIVISION_ID = '81' THEN

            /* 81 : AS_STORAGE_YN='Y' 인 행의 재고만 사용, MKT FCST 기준 데이터로 생성 */
            INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, SITE_SEQ, AS_PLANT )
            SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, 'AS_Inv'
                 , TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'), B.PLANT_SITE_ID
                 , SUM(A.QTY)
                 , B.SEQ
                 , A.AS_PLANT
              FROM ( SELECT A.DIVISION_ID, C.SEGMENT1 AS AS_SITE, A.ITEM_ID, SUM(SCM_QTY) AS QTY, C.SEGMENT2 AS AS_PLANT
                       FROM SSP_DNM_STOCK_C A
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                         ON B.SEGMENT1 = A.DIVISION_ID AND B.SEGMENT3 = A.PLANT_ID AND B.SEGMENT4 = A.STORAGE_ID
                        AND B.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC' AND B.VALID_YN = 'Y' AND B.SEGMENT5 = 'Y'
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON B.SEGMENT1 = C.SEGMENT3 AND B.SEGMENT2 = C.SEGMENT2 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT' AND C.VALID_YN = 'Y'
                      /* [E20260402-001736] SSP CUTOFF_DATE = 일요일(당주 월요일 -1). DATE 컬럼 = DATE 로 비교. */
                      WHERE A.CUTOFF_DATE = TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1
                        AND A.STOCK_TYPE = 'INVENTORY'
                      GROUP BY A.DIVISION_ID, C.SEGMENT1, A.ITEM_ID, C.SEGMENT2
                     UNION ALL
                     /* [E20250113-000270] 운송중(INTRANSIT) 재고 적용 */
                     SELECT A.DIVISION_ID, C.SEGMENT1 AS AS_SITE, A.ITEM_ID, SUM(DELIVERY_QTY) AS QTY, C.SEGMENT2 AS AS_PLANT
                       FROM SCM_DNM_INTRANSIT_C A
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B
                         ON B.SEGMENT1 = A.DIVISION_ID AND B.SEGMENT3 = A.PLANT_ID AND B.SEGMENT4 = A.ATTRIBUTE2
                        AND B.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC' AND B.VALID_YN = 'Y' AND B.SEGMENT5 = 'Y'
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON B.SEGMENT1 = C.SEGMENT3 AND B.SEGMENT2 = C.SEGMENT2 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT' AND C.VALID_YN = 'Y'
                      WHERE A.RESULT_DATE = TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                        AND A.RESULT_TYPE = 'I'
                      GROUP BY A.DIVISION_ID, C.SEGMENT1, A.ITEM_ID, C.SEGMENT2 ) A
              JOIN ( SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.FROM_SITE AS SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID, B.SEQ
                       FROM ( SELECT DIVISION_ID, FROM_SITE, ITEM_ID, MIN(SEQ) AS MIN_SEQ
                                FROM GT_PRDM_END_RTF_RAW
                               GROUP BY DIVISION_ID, FROM_SITE, ITEM_ID ) A
                       JOIN GT_PRDM_END_RTF_RAW B ON A.DIVISION_ID = B.DIVISION_ID AND A.FROM_SITE = B.FROM_SITE AND A.ITEM_ID = B.ITEM_ID AND A.MIN_SEQ = B.SEQ
                      UNION ALL
                      SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID, B.SITE_SEQ
                       FROM ( SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, MIN(SITE_SEQ) AS MIN_SEQ
                                FROM GT_PRDM_AS_INV
                               GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ) A
                       JOIN GT_PRDM_AS_INV B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.MIN_SEQ = B.SITE_SEQ
                    ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.AS_SITE = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
             GROUP BY B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID, B.SEQ, A.AS_PLANT;

        ELSE

            INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, SITE_SEQ, AS_PLANT )
            SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, 'AS_Inv'
                 , TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD'), B.PLANT_SITE_ID
                 , SUM(A.QTY)
                 , B.SITE_SEQ, A.AS_PLANT
              FROM ( SELECT A.DIVISION_ID, C.SEGMENT1 AS AS_SITE, A.ITEM_ID, SUM(SCM_QTY) AS QTY, C.SEGMENT2 AS AS_PLANT
                       FROM SSP_DNM_STOCK_C A
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON B.SEGMENT1 = A.DIVISION_ID AND B.SEGMENT3 = A.PLANT_ID AND B.SEGMENT4 = A.STORAGE_ID AND B.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC' AND B.VALID_YN = 'Y'
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON B.SEGMENT1 = C.SEGMENT3 AND B.SEGMENT2 = C.SEGMENT2 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT' AND C.VALID_YN = 'Y'
                      /* [E20260402-001736] SSP CUTOFF_DATE = 일요일. DATE 컬럼 = DATE 로 비교. */
                      WHERE A.CUTOFF_DATE = TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1
                        AND A.STOCK_TYPE = 'INVENTORY'
                      GROUP BY A.DIVISION_ID, C.SEGMENT1, A.ITEM_ID, C.SEGMENT2
                     UNION ALL
                     /* [E20250113-000270] 운송중(INTRANSIT) 재고 적용 */
                     SELECT A.DIVISION_ID, C.SEGMENT1 AS AS_SITE, A.ITEM_ID, SUM(DELIVERY_QTY) AS QTY, C.SEGMENT2 AS AS_PLANT
                       FROM SCM_DNM_INTRANSIT_C A
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON B.SEGMENT1 = A.DIVISION_ID AND B.SEGMENT3 = A.PLANT_ID AND B.SEGMENT4 = A.ATTRIBUTE2 AND B.LOOKUP_TYPE = 'SSP_AS_DIV_SLOC' AND B.VALID_YN = 'Y'
                       JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON B.SEGMENT1 = C.SEGMENT3 AND B.SEGMENT2 = C.SEGMENT2 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT' AND C.VALID_YN = 'Y'
                      WHERE A.RESULT_DATE = TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                        AND A.RESULT_TYPE = 'I'
                      GROUP BY A.DIVISION_ID, C.SEGMENT1, A.ITEM_ID, C.SEGMENT2 ) A
              JOIN ( SELECT DISTINCT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID, B.SITE_SEQ
                       FROM ( SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID, MIN(SITE_SEQ) AS MIN_SEQ
                                FROM GT_PRDM_AS_INV
                               GROUP BY DIVISION_ID, SCM_SITE_ID, ITEM_ID ) A
                       JOIN GT_PRDM_AS_INV B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID AND A.MIN_SEQ = B.SITE_SEQ
                    ) B ON A.DIVISION_ID = B.DIVISION_ID AND A.AS_SITE = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
             GROUP BY B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.PLANT_SITE_ID, B.SITE_SEQ, A.AS_PLANT;

        END IF;

        /* AS_PLANT 일괄 업데이트 */
        MERGE INTO GT_PRDM_AS_INV A
        USING ( SELECT SEGMENT3, SEGMENT1, MAX(SEGMENT2) AS SEGMENT2
                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL
                 WHERE LOOKUP_TYPE = 'AS_SITE_PLANT' AND VALID_YN = 'Y'
                 GROUP BY SEGMENT3, SEGMENT1 ) B
        ON ( A.DIVISION_ID = B.SEGMENT3 AND A.SCM_SITE_ID = B.SEGMENT1 )
        WHEN MATCHED THEN UPDATE SET A.AS_PLANT = B.SEGMENT2;

        /* --------------------------------------------------------------------------------------- */
        /* AS PLANT 기준 모델 적재 -> GT_PRDM_AS_LOOP ( SEQ 1부터 연속채번 ) */
        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRDM_AS_LOOP ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, CALC_START_DATE, FROM_PLANT, SEQ )
        SELECT X.DIVISION_ID, X.SCM_SITE_ID, X.ITEM_ID, X.CALC_START_DATE, X.FROM_PLANT
             , ROW_NUMBER() OVER ( ORDER BY X.DIVISION_ID, X.SCM_SITE_ID, X.ITEM_ID )
          FROM ( SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID
                      , CASE WHEN P_DIVISION_ID LIKE '81%' THEN V_SHIP_START_YYYYMMDD ELSE TO_CHAR(TO_DATE(V_SHIP_START_YYYYMMDD, 'YYYYMMDD') + B.SHIP_FROZEN, 'YYYYMMDD') END AS CALC_START_DATE
                      , C.SEGMENT2 AS FROM_PLANT
                   FROM GT_PRDM_AS_INV A
                   JOIN SCM_MST_SITE B ON A.DIVISION_ID = B.DIVISION_ID AND A.AS_PLANT = B.SCM_SITE_ID
                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON A.DIVISION_ID = C.SEGMENT3 AND A.SCM_SITE_ID = C.SEGMENT1 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT' AND C.VALID_YN = 'Y'
                  WHERE A.SITE_SEQ = 1 ) X;

        INSERT INTO GT_PRDM_AS_LOOP ( DIVISION_ID, SCM_SITE_ID, ITEM_ID, CALC_START_DATE, FROM_PLANT, SEQ )
        SELECT X.DIVISION_ID, X.SCM_SITE_ID, X.ITEM_ID, X.CALC_START_DATE, X.FROM_PLANT
             , ( SELECT NVL(MAX(SEQ), 0) FROM GT_PRDM_AS_LOOP ) + ROW_NUMBER() OVER ( ORDER BY X.DIVISION_ID, X.SCM_SITE_ID, X.ITEM_ID )
          FROM ( SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID
                      , CASE WHEN P_DIVISION_ID LIKE '81%' THEN V_SHIP_START_YYYYMMDD ELSE TO_CHAR(TO_DATE(V_SHIP_START_YYYYMMDD, 'YYYYMMDD') + C.SHIP_FROZEN, 'YYYYMMDD') END AS CALC_START_DATE
                      , B.SEGMENT2 AS FROM_PLANT
                   FROM DM_PLN_MKT_FCST_C A
                   JOIN SCM_ADM_LOOKUP_MASTER_DETAIL B ON A.DIVISION_ID = B.SEGMENT3 AND A.SCM_SITE_ID = B.SEGMENT1 AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.VALID_YN = 'Y'
                   JOIN SCM_MST_SITE C ON A.DIVISION_ID = C.DIVISION_ID AND B.SEGMENT2 = C.SCM_SITE_ID
                   LEFT OUTER JOIN GT_PRDM_AS_LOOP E ON A.DIVISION_ID = E.DIVISION_ID AND A.SCM_SITE_ID = E.SCM_SITE_ID AND A.ITEM_ID = E.ITEM_ID
                   JOIN ( SELECT DISTINCT A.DIVISION_ID, A.SCM_SITE_ID, A.ITEM_ID, C.SEGMENT2
                            FROM GT_PRDM_AS_INV A
                            JOIN SCM_ADM_LOOKUP_MASTER_DETAIL C ON A.DIVISION_ID = C.SEGMENT3 AND A.SCM_SITE_ID = C.SEGMENT1 AND C.LOOKUP_TYPE = 'AS_SITE_PLANT' AND C.VALID_YN = 'Y'
                         ) F ON A.DIVISION_ID = F.DIVISION_ID AND A.SCM_SITE_ID = F.SCM_SITE_ID AND A.ITEM_ID = F.ITEM_ID
                  WHERE A.DIVISION_ID = P_DIVISION_ID
                    AND A.VERSION_NO  = P_VERSION_NO
                    AND A.YYYYMMDD >= V_SHIP_START_YYYYMMDD
                    AND E.DIVISION_ID IS NULL ) X;

        /* --------------------------------------------------------------------------------------- */
        /* #T_AS_INV 일자별 재고 생성 루프 ( 첫 AS_LOOP WHILE ) */
        /* --------------------------------------------------------------------------------------- */
        SELECT 1, COUNT(*) INTO I, CNT FROM GT_PRDM_AS_LOOP;

        WHILE ( I <= CNT ) LOOP

            SELECT DIVISION_ID, SCM_SITE_ID, ITEM_ID
              INTO V_DIVISION_ID, V_SCM_SITE_ID, V_ITEM_ID
              FROM GT_PRDM_AS_LOOP
             WHERE SEQ = I;

            BEGIN
                SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                  INTO V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, V_PLANT_SITE_ID
                  FROM ( SELECT PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID
                           FROM GT_PRDM_AS_INV
                          WHERE DIVISION_ID = V_DIVISION_ID
                            AND SCM_SITE_ID = V_SCM_SITE_ID
                            AND ITEM_ID = V_ITEM_ID
                            AND SITE_SEQ = 1 )
                 WHERE ROWNUM = 1;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN NULL;
            END;

            INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, SITE_SEQ )
            SELECT DISTINCT V_DIVISION_ID, V_PROJECT_CODE, V_SCM_SITE_ID, V_ITEM_ID, V_DOM_EXP, V_FCST_TYPE, V_INCOTERMS, 'AS_Inv', A.BASIS_YYYYMMDD, V_PLANT_SITE_ID
--               , SUM( CASE WHEN B.MEASURE IN ('AS_In_Plan', 'AS_INV') THEN NVL(B.QTY, 0) ELSE NVL(-B.QTY, 0) END ) OVER ( ORDER BY A.BASIS_YYYYMMDD )   --  2026.10.08 AJS
                 , SUM( CASE WHEN B.MEASURE IN ('AS_In_Plan', 'AS_Inv') THEN NVL(B.QTY, 0) ELSE NVL(-B.QTY, 0) END ) OVER ( ORDER BY A.BASIS_YYYYMMDD )   --  2026.10.08 AJS
                 , B.SITE_SEQ
              FROM SCM_SYS_CALENDAR_M A
              LEFT OUTER JOIN GT_PRDM_AS_INV B ON A.BASIS_YYYYMMDD = B.YYYYMMDD
                                              AND B.DIVISION_ID = V_DIVISION_ID
                                              AND B.SCM_SITE_ID = V_SCM_SITE_ID
                                              AND B.ITEM_ID = V_ITEM_ID
             WHERE A.BASIS_YYYYMMDD BETWEEN TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
                                        AND TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + 7*16, 'YYYYMMDD');

            /* 기초재고 일자 중복행 삭제 ( 나중에 넣은 데이터 ) */
            DELETE FROM GT_PRDM_AS_INV A
             WHERE A.YYYYMMDD = TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') - 1, 'YYYYMMDD')
               AND A.AS_PLANT IS NULL;

            I := I + 1;
        END LOOP;

        /* --------------------------------------------------------------------------------------- */
        /* [E20240226-000021] 54주 보완 : SITE_SEQ 없는 AS_Inv 최초일자에 SITE_SEQ=1 */
        /* --------------------------------------------------------------------------------------- */
        MERGE INTO GT_PRDM_AS_INV A
        USING ( SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID, MIN(YYYYMMDD) AS YYYYMMDD
                  FROM GT_PRDM_AS_INV C
                 WHERE SITE_SEQ IS NULL
                   AND MEASURE = 'AS_Inv'
                   AND NOT EXISTS ( SELECT 1 FROM GT_PRDM_AS_INV D
                                     WHERE D.MEASURE = 'AS_Inv' AND D.SITE_SEQ = 1
                                       AND C.DIVISION_ID = D.DIVISION_ID AND C.SCM_SITE_ID = D.SCM_SITE_ID AND C.ITEM_ID = D.ITEM_ID )
                 GROUP BY DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, PLANT_SITE_ID ) B
        ON (    A.DIVISION_ID   = B.DIVISION_ID
            AND A.PROJECT_CODE  = B.PROJECT_CODE
            AND A.SCM_SITE_ID   = B.SCM_SITE_ID
            AND A.ITEM_ID       = B.ITEM_ID
            AND A.DOM_EXP       = B.DOM_EXP
            AND A.FCST_TYPE     = B.FCST_TYPE
            AND A.INCOTERMS     = B.INCOTERMS
            AND A.PLANT_SITE_ID = B.PLANT_SITE_ID
            AND A.YYYYMMDD      = B.YYYYMMDD )
        WHEN MATCHED THEN UPDATE SET A.SITE_SEQ = 1 WHERE A.MEASURE = 'AS_Inv';

        /* --------------------------------------------------------------------------------------- */
        /* 받는 Site 들에 RTF 생성 ( SSP 확정구간 이후 ) : MKT FCST 취합 -> GT_PRDM_RTF */
        /* --------------------------------------------------------------------------------------- */
        INSERT INTO GT_PRDM_RTF ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, FROM_PLANT, ETD_DATE, SITE_SEQ )
        SELECT B.DIVISION_ID, B.PROJECT_CODE, B.SCM_SITE_ID, B.ITEM_ID, B.DOM_EXP, B.FCST_TYPE, B.INCOTERMS, B.MEASURE, B.YYYYMMDD, B.PLANT_SITE_ID, B.QTY
             , A.FROM_SITE, TO_CHAR(TO_DATE(B.YYYYMMDD, 'YYYYMMDD') - A.LT_TOTAL, 'YYYYMMDD')
             , ROW_NUMBER() OVER ( PARTITION BY B.DIVISION_ID, A.FROM_SITE, B.ITEM_ID, B.YYYYMMDD ORDER BY B.SCM_SITE_ID )
          FROM ( SELECT A.SEGMENT2 AS FROM_SITE, B.TO_SITE, B.LT_TOTAL, ROW_NUMBER() OVER ( PARTITION BY B.DIVISION_ID, B.FROM_SITE, B.TO_SITE ORDER BY B.PRIORITY ) AS BOD_SEQ
                   FROM SCM_ADM_LOOKUP_MASTER_DETAIL A
                   JOIN SCP_MST_BOD_N_V B ON A.SEGMENT2 = B.FROM_SITE AND B.DIVISION_ID = P_DIVISION_ID AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN B.FROM_YYYYMMDD AND B.TO_YYYYMMDD
                   JOIN SCM_MST_SITE C ON B.TO_SITE = C.SCM_SITE_ID AND C.SITE_TYPE = 'SALES' AND C.VALID_YN = 'Y' AND C.DIVISION_ID = P_DIVISION_ID
                  WHERE A.LOOKUP_TYPE = 'AS_SITE_PLANT' AND A.SEGMENT3 = P_DIVISION_ID AND A.VALID_YN = 'Y' ) A
          JOIN DM_PLN_MKT_FCST_C B ON A.TO_SITE = B.SCM_SITE_ID AND B.MEASURE = 'MKT_FCST' AND B.YYYYMMDD >= V_START_YYYYMMDD
                                  AND A.FROM_SITE = B.ATTRIBUTE10 AND B.DIVISION_ID = P_DIVISION_ID AND B.VERSION_NO = P_VERSION_NO
          JOIN SCM_MST_SITE C ON A.FROM_SITE = C.SCM_SITE_ID AND C.DIVISION_ID = P_DIVISION_ID
         WHERE A.BOD_SEQ = 1
           AND B.YYYYMMDD > CASE WHEN P_DIVISION_ID LIKE '81%' THEN V_SHIP_START_YYYYMMDD ELSE TO_CHAR(TO_DATE(V_SHIP_START_YYYYMMDD, 'YYYYMMDD') + C.SHIP_FROZEN, 'YYYYMMDD') END
           AND B.QTY <> 0;

        UPDATE GT_PRDM_RTF A
           SET A.ALLOC_SCD_RTF = CASE WHEN A.YYYYMMDD > NVL( ( SELECT MAX(YYYYMMDD)
                                                                 FROM GT_PRDM_END_RTF_RAW E
                                                                WHERE E.MEASURE IN ('RTF', 'SSP_RTF')
                                                                  AND E.DIVISION_ID = A.DIVISION_ID
                                                                  AND E.SCM_SITE_ID = A.SCM_SITE_ID ), '19000101' )
                                      THEN 'Y' ELSE 'N' END;


        INSERT INTO GT_PRDM_RTF_SITE ( FROM_SITE, SCM_SITE_ID, MAX_YMD )
        SELECT A.FROM_SITE, A.SCM_SITE_ID
             , CASE WHEN NVL(D.MAX_YMD, '19000101') > CASE WHEN P_DIVISION_ID LIKE '81%' THEN TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + NVL(C.LT_TOTAL, 0), 'YYYYMMDD')
                                                           ELSE TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + NVL(B.SHIP_FROZEN, 0) + NVL(C.LT_TOTAL, 0), 'YYYYMMDD') END
                    THEN D.MAX_YMD
                    ELSE CASE WHEN P_DIVISION_ID LIKE '81%' THEN TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + NVL(C.LT_TOTAL, 0), 'YYYYMMDD')
                              ELSE TO_CHAR(TO_DATE(V_START_YYYYMMDD, 'YYYYMMDD') + NVL(B.SHIP_FROZEN, 0) + NVL(C.LT_TOTAL, 0), 'YYYYMMDD') END
               END
          FROM ( SELECT DISTINCT FROM_SITE, SCM_SITE_ID, AS_PLANT FROM GT_PRDM_END_RTF_RAW ) A
          JOIN SCM_MST_SITE B ON A.AS_PLANT = B.SCM_SITE_ID AND B.DIVISION_ID = P_DIVISION_ID
          JOIN ( SELECT FROM_SITE, TO_SITE, LT_TOTAL, ROW_NUMBER() OVER ( PARTITION BY FROM_SITE, TO_SITE, INCOTERMS ORDER BY PRIORITY ) AS PRT
                   FROM SCP_MST_BOD_N_V
                  WHERE DIVISION_ID = P_DIVISION_ID AND TO_CHAR(SYSDATE, 'YYYYMMDD') BETWEEN FROM_YYYYMMDD AND TO_YYYYMMDD ) C
            ON A.AS_PLANT = C.FROM_SITE AND A.SCM_SITE_ID = C.TO_SITE AND C.PRT = 1
          LEFT OUTER JOIN ( SELECT FROM_SITE, SCM_SITE_ID, MAX(YYYYMMDD) AS MAX_YMD
                              FROM GT_PRDM_END_RTF_RAW
                             WHERE MEASURE = 'RTF'
                             GROUP BY FROM_SITE, SCM_SITE_ID ) D
            ON A.FROM_SITE = D.FROM_SITE AND A.SCM_SITE_ID = D.SCM_SITE_ID;

        MERGE INTO GT_PRDM_END_RTF_RAW A
        USING ( SELECT FROM_SITE, SCM_SITE_ID, MAX(MAX_YMD) AS MAX_YMD
                  FROM GT_PRDM_RTF_SITE
                 GROUP BY FROM_SITE, SCM_SITE_ID ) B
        ON ( A.SCM_SITE_ID = B.SCM_SITE_ID AND A.FROM_SITE = B.FROM_SITE )
        WHEN MATCHED THEN UPDATE SET A.SCD_ALLOC_START_DATE = B.MAX_YMD;

        UPDATE GT_PRDM_END_RTF_RAW
           SET LT_YYYYMMDD = TO_CHAR(TO_DATE(YYYYMMDD, 'YYYYMMDD') - NVL(LT_DAYS, 0), 'YYYYMMDD')
         WHERE MEASURE = 'MKT_FCST';

        /* --------------------------------------------------------------------------------------- */

        /* --------------------------------------------------------------------------------------- */
        SELECT 1, COUNT(*) INTO I, CNT FROM GT_PRDM_AS_LOOP;

        WHILE ( I <= CNT ) LOOP

            SELECT A.DIVISION_ID, A.FROM_PLANT, A.SCM_SITE_ID, A.ITEM_ID, TRUNC(NVL(B.QTY, 0)), A.CALC_START_DATE
                 , 0
                 , TO_CHAR(TO_DATE(V_SHIP_START_YYYYMMDD, 'YYYYMMDD') + 7*82, 'YYYYMMDD')
                 , 0, 0
              INTO V_DIVISION_ID, V_FROM_PLANT, V_FROM_SITE, V_ITEM_ID, V_INV_QTY, V_DATE
                 , V_SUM_REQ_QTY
                 , V_MAX_DATE
                 , V_INV_ADJ_QTY, V_SUM_REQ_QTY
              FROM GT_PRDM_AS_LOOP A
              LEFT OUTER JOIN GT_PRDM_AS_INV B ON A.DIVISION_ID = B.DIVISION_ID AND A.SCM_SITE_ID = B.SCM_SITE_ID AND A.ITEM_ID = B.ITEM_ID
                   AND B.YYYYMMDD = TO_CHAR(TO_DATE(A.CALC_START_DATE, 'YYYYMMDD') - 1, 'YYYYMMDD')
--                 AND B.MEASURE = 'AS_INV'   --  2026.10.08 AJS
                   AND B.MEASURE = 'AS_Inv'   --  2026.10.08 AJS
             WHERE A.SEQ = I;

            WHILE ( V_DATE <= V_MAX_DATE ) LOOP


                SELECT V_INV_QTY + NVL(SUM(QTY), 0)
                  INTO V_INV_QTY
                  FROM GT_PRDM_AS_INV
                 WHERE MEASURE = 'AS_In_Plan'
                   AND DIVISION_ID = V_DIVISION_ID
                   AND SCM_SITE_ID = V_FROM_SITE
                   AND ITEM_ID = V_ITEM_ID
                   AND YYYYMMDD = V_DATE;
                V_INV_QTY := TRUNC(V_INV_QTY);

                SELECT NVL(SUM(NVL(MF_QTY, 0) - NVL(RTF_QTY, 0)), 0)
                  INTO V_SUM_REQ_QTY
                  FROM GT_PRDM_END_RTF_RAW
                 WHERE AS_PLANT = V_FROM_PLANT
                   AND ITEM_ID = V_ITEM_ID
                   AND DIVISION_ID = V_DIVISION_ID
                   AND LT_YYYYMMDD <= V_DATE
                   AND MEASURE = 'MKT_FCST'
                   AND NVL(MF_QTY, 0) > NVL(RTF_QTY, 0);

                /* 재고보다 요청수량이 적으면 요청만큼 생성 */
                IF ( V_SUM_REQ_QTY <= V_INV_QTY ) THEN

                    INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, SITE_SEQ, FROM_SITE, ADD_YN )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'RTF_SCP'
                         , TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') + NVL(LT_DAYS, 0), 'YYYYMMDD'), A.PLANT_SITE_ID, SUM(NVL(MF_QTY, 0) - NVL(RTF_QTY, 0)), NULL, A.AS_PLANT, 'Y'
                      FROM GT_PRDM_END_RTF_RAW A
                     WHERE A.AS_PLANT = V_FROM_PLANT
                       AND A.ITEM_ID = V_ITEM_ID
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND LT_YYYYMMDD <= V_DATE
                       AND MEASURE = 'MKT_FCST'
                       AND NVL(MF_QTY, 0) > NVL(RTF_QTY, 0)
                     GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                         , A.PLANT_SITE_ID, A.AS_PLANT, TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') + NVL(LT_DAYS, 0), 'YYYYMMDD');

                    UPDATE GT_PRDM_END_RTF_RAW A
                       SET RTF_QTY = MF_QTY
                     WHERE A.AS_PLANT = V_FROM_PLANT
                       AND A.ITEM_ID = V_ITEM_ID
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND LT_YYYYMMDD <= V_DATE
                       AND MEASURE = 'MKT_FCST'
                       AND NVL(MF_QTY, 0) > NVL(RTF_QTY, 0);

                    V_INV_QTY := TRUNC(V_INV_QTY - V_SUM_REQ_QTY);

                ELSE  /* 재고가 적으면 배분 */

                    DELETE FROM GT_PRDM_RCV;

                    INSERT INTO GT_PRDM_RCV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, FROM_SITE, ETD_DATE, SITE_SEQ, RTF_RAW_KEY_VAL )
                    SELECT DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE
                         , TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') + NVL(LT_DAYS, 0), 'YYYYMMDD'), PLANT_SITE_ID
                         , NVL(MF_QTY, 0) - NVL(RTF_QTY, 0)
                         , AS_PLANT, V_DATE
                         , ROW_NUMBER() OVER ( ORDER BY A.YYYYMMDD, A.SCM_SITE_ID )
                         , KEY_VAL
                      FROM GT_PRDM_END_RTF_RAW A
                     WHERE A.AS_PLANT = V_FROM_PLANT
                       AND A.ITEM_ID = V_ITEM_ID
                       AND A.DIVISION_ID = V_DIVISION_ID
                       AND LT_YYYYMMDD <= V_DATE
                       AND MEASURE = 'MKT_FCST'
                       AND NVL(MF_QTY, 0) > NVL(RTF_QTY, 0);

                    SELECT 1, COUNT(*) INTO I_RCV, CNT_RCV FROM GT_PRDM_RCV;

                    WHILE ( I_RCV <= CNT_RCV AND V_INV_QTY > 0 ) LOOP

                        SELECT QTY, RTF_RAW_KEY_VAL INTO V_REQ_QTY, V_KEY_VAL
                          FROM GT_PRDM_RCV
                         WHERE SITE_SEQ = I_RCV;

                        INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, SITE_SEQ, FROM_SITE, ADD_YN )
                        SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'RTF_SCP'
                             , A.YYYYMMDD, A.PLANT_SITE_ID
                             , SUM( CASE WHEN V_REQ_QTY <= V_INV_QTY THEN V_REQ_QTY ELSE V_INV_QTY END )
                             , A.SITE_SEQ, A.FROM_SITE, 'Y'
                          FROM GT_PRDM_RCV A
                         WHERE SITE_SEQ = I_RCV
                         GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS
                             , A.YYYYMMDD, A.PLANT_SITE_ID, A.SITE_SEQ, A.FROM_SITE;

                        UPDATE GT_PRDM_END_RTF_RAW
                           SET RTF_QTY = RTF_QTY + CASE WHEN V_REQ_QTY <= V_INV_QTY THEN V_REQ_QTY ELSE V_INV_QTY END
                         WHERE KEY_VAL = V_KEY_VAL;

                        V_INV_QTY := TRUNC( CASE WHEN V_REQ_QTY <= V_INV_QTY THEN V_INV_QTY - V_REQ_QTY ELSE 0 END );

                        I_RCV := I_RCV + 1;
                    END LOOP;

                END IF;

                /* Inv Insert / Update */
                UPDATE GT_PRDM_AS_INV
                   SET QTY = V_INV_QTY
                 WHERE DIVISION_ID = V_DIVISION_ID
                   AND SCM_SITE_ID = V_FROM_SITE
                   AND ITEM_ID = V_ITEM_ID
                   AND YYYYMMDD = V_DATE
                   AND MEASURE = 'AS_Inv';

                IF SQL%ROWCOUNT = 0 THEN
                    INSERT INTO GT_PRDM_AS_INV ( DIVISION_ID, PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP, FCST_TYPE, INCOTERMS, MEASURE, YYYYMMDD, PLANT_SITE_ID, QTY, SITE_SEQ )
                    SELECT A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP, A.FCST_TYPE, A.INCOTERMS, 'AS_Inv', V_DATE, A.PLANT_SITE_ID
                         , V_INV_QTY, 1
                      FROM GT_PRDM_AS_INV A
                     WHERE A.DIVISION_ID = V_DIVISION_ID
                       AND A.SCM_SITE_ID = V_FROM_SITE
                       AND A.ITEM_ID = V_ITEM_ID
                       AND A.MEASURE = 'AS_Inv'
                       AND A.SITE_SEQ = 1
                       AND ROWNUM = 1;
                END IF;

                V_DATE := TO_CHAR(TO_DATE(V_DATE, 'YYYYMMDD') + 1, 'YYYYMMDD');

            END LOOP;

            I := I + 1;
        END LOOP;


        DELETE FROM GT_PRDM_AS_INV WHERE YYYYMMDD < V_START_YYYYMMDD;

        /* --------------------------------------------------------------------------------------- */
        /* 결과 INSERT : DM_PLN_MKT_FCST_C ( AS_Inv + 8주 이후 RTF ) */
        /* --------------------------------------------------------------------------------------- */
        DELETE FROM DM_PLN_MKT_FCST_C A
         WHERE EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                         WHERE A.DIVISION_ID = B.SEGMENT3 AND A.SCM_SITE_ID = B.SEGMENT1
                           AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.VALID_YN = 'Y' )
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE = 'AS_Inv'
           AND A.YYYYMMDD >= V_START_YYYYMMDD;

        INSERT INTO DM_PLN_MKT_FCST_C
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
            , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
            , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
            , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DISTINCT A.DIVISION_ID, P_VERSION_NO, V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
             , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
             -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--             , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END, A.YYYYMMDD
             , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END, A.YYYYMMDD
             -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
             , A.QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
             , '', '', '', '', ''
             , '', '', '', '', ''
          FROM GT_PRDM_AS_INV A
         WHERE MEASURE = 'AS_Inv';


        INSERT INTO DM_PLN_MKT_FCST_C
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
            , PROJECT_CODE, SCM_SITE_ID, ITEM_ID, DOM_EXP
            , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, YYYYMMDD
            , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
             , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.YYYYMMDD
             , A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
             , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
          FROM ( SELECT A.DIVISION_ID, P_VERSION_NO AS VERSION_NO, V_CUTOFF_TYPE AS CUTOFF_TYPE, V_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                      , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END AS PLANT_SITE_ID, A.YYYYMMDD
                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END AS PLANT_SITE_ID, A.YYYYMMDD
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
                      , SUM(A.QTY) AS QTY, V_CREATED_BY AS CREATED_BY, SYSDATE AS CREATION_DATE, V_CREATED_BY AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
                      , '' AS ATTRIBUTE1, '' AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
                      , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, A.FROM_SITE AS ATTRIBUTE10
                   FROM GT_PRDM_AS_INV A
                   JOIN ( SELECT 'RTF' AS MEASURE FROM DUAL
                          UNION ALL SELECT 'RTF_SCP' FROM DUAL
                          UNION ALL SELECT 'RTF_SYS_RP' FROM DUAL
                          UNION ALL SELECT 'RTF_PR' FROM DUAL ) B ON 1 = 1
                  WHERE A.ADD_YN = 'Y' AND A.MEASURE = 'RTF_SCP'
                  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END, A.YYYYMMDD, A.FROM_SITE ) A
                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END, A.YYYYMMDD, A.FROM_SITE ) A
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
          LEFT OUTER JOIN DM_PLN_MKT_FCST_C B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND NVL(A.PROJECT_CODE, '@') = NVL(B.PROJECT_CODE, '@')
           AND A.SCM_SITE_ID = B.SCM_SITE_ID
           AND A.ITEM_ID = B.ITEM_ID
           AND NVL(A.DOM_EXP, '@') = NVL(B.DOM_EXP, '@')
           AND NVL(A.FCST_TYPE, '@') = NVL(B.FCST_TYPE, '@')
           AND NVL(A.INCOTERMS, '@') = NVL(B.INCOTERMS, '@')
           AND A.MEASURE = B.MEASURE
           AND NVL(A.PLANT_SITE_ID, '@') = NVL(B.PLANT_SITE_ID, '@')
           AND A.YYYYMMDD = B.YYYYMMDD
           AND B.VERSION_NO = P_VERSION_NO
           AND B.CUTOFF_TYPE = V_CUTOFF_TYPE
           AND B.CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
         WHERE B.DIVISION_ID IS NULL;

        /* --------------------------------------------------------------------------------------- */
        /* [PJ2025-50017] 결과 INSERT : DM_PLN_CFM_MKT_DEMAND_PLAN_C ( AS_Inv + 8주 이후 RTF ) */
        /* --------------------------------------------------------------------------------------- */
        DELETE FROM DM_PLN_CFM_MKT_DEMAND_PLAN_C A
         WHERE EXISTS ( SELECT 1 FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                         WHERE A.DIVISION_ID = B.SEGMENT3 AND A.SCM_SITE_ID = B.SEGMENT1
                           AND B.LOOKUP_TYPE = 'AS_SITE_PLANT' AND B.VALID_YN = 'Y' )
           AND A.DIVISION_ID = P_DIVISION_ID
           AND A.VERSION_NO  = P_VERSION_NO
           AND A.MEASURE = 'AS_Inv'
           AND A.YYYYMMDD >= V_START_YYYYMMDD;

        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
            , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
            , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
            , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT DISTINCT A.DIVISION_ID, P_VERSION_NO, V_CUTOFF_TYPE, V_CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (START)
--             , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE ' ' END
             , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '/' END
             -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (END)
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
             -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--             , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END, '-', A.YYYYMMDD
             , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END, '-', A.YYYYMMDD
             -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
             , A.QTY, V_CREATED_BY, SYSDATE, V_CREATED_BY, SYSDATE
             , '', NULL, '', '', ''
             , '', '', '', '', ''
          FROM GT_PRDM_AS_INV A
         WHERE MEASURE = 'AS_Inv';


        INSERT INTO DM_PLN_CFM_MKT_DEMAND_PLAN_C
            ( DIVISION_ID, VERSION_NO, CUTOFF_TYPE, CUTOFF_YYYYMMDD
            , PROJECT_CODE, END_CUSTOMER, SCM_SITE_ID, ITEM_ID, DOM_EXP
            , FCST_TYPE, INCOTERMS, MEASURE, PLANT_SITE_ID, CELL_PROD_SITE_ID, YYYYMMDD
            , QTY, CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE
            , ATTRIBUTE1, ATTRIBUTE2, ATTRIBUTE3, ATTRIBUTE4, ATTRIBUTE5
            , ATTRIBUTE6, ATTRIBUTE7, ATTRIBUTE8, ATTRIBUTE9, ATTRIBUTE10 )
        SELECT A.DIVISION_ID, A.VERSION_NO, A.CUTOFF_TYPE, A.CUTOFF_YYYYMMDD
             , A.PROJECT_CODE
             -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (START)
--             , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE ' ' END
             , CASE WHEN A.DIVISION_ID = '40' THEN A.PROJECT_CODE ELSE '/' END
             -- 2026.09.18 AJS END_CUSTOMER 빈값 채움값 '-' 로 통일 (END)
             , A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
             , A.FCST_TYPE, A.INCOTERMS, A.MEASURE, A.PLANT_SITE_ID, A.FROM_SITE_ID, A.YYYYMMDD
             , A.QTY, A.CREATED_BY, A.CREATION_DATE, A.LAST_UPDATED_BY, A.LAST_UPDATE_DATE
             , A.ATTRIBUTE1, A.ATTRIBUTE2, A.ATTRIBUTE3, A.ATTRIBUTE4, A.ATTRIBUTE5
             , A.ATTRIBUTE6, A.ATTRIBUTE7, A.ATTRIBUTE8, A.ATTRIBUTE9, A.ATTRIBUTE10
          FROM ( SELECT A.DIVISION_ID, P_VERSION_NO AS VERSION_NO, V_CUTOFF_TYPE AS CUTOFF_TYPE, V_CUTOFF_YYYYMMDD AS CUTOFF_YYYYMMDD
                      , A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END AS PLANT_SITE_ID
                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END AS PLANT_SITE_ID
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
                      , '-' AS FROM_SITE_ID, A.YYYYMMDD
                      , SUM(A.QTY) AS QTY, V_CREATED_BY AS CREATED_BY, SYSDATE AS CREATION_DATE, V_CREATED_BY AS LAST_UPDATED_BY, SYSDATE AS LAST_UPDATE_DATE
                      , '' AS ATTRIBUTE1, NULL AS ATTRIBUTE2, '' AS ATTRIBUTE3, '' AS ATTRIBUTE4, '' AS ATTRIBUTE5
                      , '' AS ATTRIBUTE6, '' AS ATTRIBUTE7, '' AS ATTRIBUTE8, '' AS ATTRIBUTE9, A.FROM_SITE AS ATTRIBUTE10
                   FROM GT_PRDM_AS_INV A
                   JOIN ( SELECT 'RTF' AS MEASURE FROM DUAL
                          UNION ALL SELECT 'RTF_SCP' FROM DUAL
                          UNION ALL SELECT 'RTF_SYS_RP' FROM DUAL
                          UNION ALL SELECT 'RTF_PR' FROM DUAL ) B ON 1 = 1
                  WHERE A.ADD_YN = 'Y' AND A.MEASURE = 'RTF_SCP'
                  GROUP BY A.DIVISION_ID, A.PROJECT_CODE, A.SCM_SITE_ID, A.ITEM_ID, A.DOM_EXP
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (START)
--                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE ' ' END, A.YYYYMMDD, A.FROM_SITE ) A
                      , A.FCST_TYPE, A.INCOTERMS, B.MEASURE, CASE WHEN A.DIVISION_ID LIKE '81%' THEN A.PLANT_SITE_ID ELSE '/' END, A.YYYYMMDD, A.FROM_SITE ) A
                      -- 2026.09.18 AJS PLANT_SITE_ID 빈값 채움값 '-' 로 통일 (END)
          LEFT OUTER JOIN DM_PLN_CFM_MKT_DEMAND_PLAN_C B
            ON A.DIVISION_ID = B.DIVISION_ID
           AND NVL(A.PROJECT_CODE, '@') = NVL( CASE WHEN B.DIVISION_ID = '40' THEN B.END_CUSTOMER ELSE B.PROJECT_CODE END, '@')
           AND A.SCM_SITE_ID = B.SCM_SITE_ID
           AND A.ITEM_ID = B.ITEM_ID
           AND NVL(A.DOM_EXP, '@') = NVL(B.DOM_EXP, '@')
           AND NVL(A.FCST_TYPE, '@') = NVL(B.FCST_TYPE, '@')
           AND NVL(A.INCOTERMS, '@') = NVL(B.INCOTERMS, '@')
           AND A.MEASURE = B.MEASURE
           AND NVL(A.PLANT_SITE_ID, '@') = NVL(B.PLANT_SITE_ID, '@')
           AND A.YYYYMMDD = B.YYYYMMDD
           AND B.VERSION_NO = P_VERSION_NO
           AND B.CUTOFF_TYPE = V_CUTOFF_TYPE
           AND B.CUTOFF_YYYYMMDD = V_CUTOFF_YYYYMMDD
         WHERE B.DIVISION_ID IS NULL;

        COMMIT;

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := '@P_DIVISION_ID: ' || P_DIVISION_ID || ' / @P_VERSION_NO: ' || P_VERSION_NO
                             || '/ ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE;
            D_EVENT_DATE  := SYSDATE;
            PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE
                , V_DESCRIPTION, TO_CHAR(SQLCODE), SUBSTR(SQLERRM, 1, 1000), SUBSTR(DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 1000));
    END;


    IF V_LOG_TYPE IS NULL OR V_LOG_TYPE <> 'ERROR' THEN
        V_LOG_TYPE    := 'END';
        V_LOG_MESSAGE := '########## END OF PROCEDURE ##########';
        D_EVENT_DATE  := SYSDATE;
        PR_SCM_SYS_LOG_BATCH(V_PROGRAM_NAME, V_LOG_TYPE, N_LOG_COUNT, V_LOG_MESSAGE, V_DESCRIPTION, D_EVENT_DATE);
    END IF;

END PR_DM_DNM_CREATE_C_WS_RTF;