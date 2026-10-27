PROCEDURE PR_SCP_ANL_PSI_INTEGRATION
(
      P_DIVISION_ID          IN VARCHAR2
    , P_PLAN_START_YYYYMMDD  IN VARCHAR2     /* plan_name */
)
/*******************************************************************************************************************
 * Program ID   : PR_SCP_ANL_PSI_INTEGRATION
 * Description  : 재료비 TASK
 * OutTable     : SCP_ANL_PSI_INTEGRATION
 * Execute      :
                  EXEC PR_SCP_ANL_PSI_INTEGRATION @p_division_id         = '81'
                     , @p_plan_start_yyyymmdd = '20240624'

 * Program History
 *===================================================================================================
 *   Date       In Charge      Description
 *===================================================================================================
 * 2024.05.08                  Initial 재료비 TASK PJ20244573 LGES SCM SCP 생산모델 기반 공급계획 수립체계 구성 : 통합 PSI용 정보 구성
 * 2024.08.13                  ESST 출하물량 연동
 * 2024.08.23                  모듈반제품 BOH로 PROD_PLAN 및 셀제품 IN_HOUSE_MOVING 연동
 * 2024.11.11                  EV2020 대치 투입 추가
 * 2025.02.12                  cell/전극 plant 매핑 로직 수정
 *								- 1순위 : division, company, plant 정보로 매핑
 *								- 2순위 : division, company, city, country 정보로 매핑
 *								- 3순위 : division, company 정보로 매핑
 *								- 4순위 : company 정보로 매핑
 * 2025.03.13   hrkim          PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선
 *								- 빈월 수량 0 데이터 생성 반영
 *								- 비대상 measure : MKT_FCST, SHIP_PLAN_RTF
 *								- plan 시작월 부터 lookup 설정한 개월수 만큼만 (lookup type : INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD)
 *								- attribute2 : PLAN_TYPE
 *								- attribute3 : INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD lookup 설정 값
 * 2025.05.22   hrkim          	E20250521-001029 통합 PSI 화면 From site 불일치 건 오류 수정
 *								Ship plan RTF - delivery order 참조시 조인 컬럼 변경
 *								- 변경전 : demand_id
 *								- 변경후 : org_demand_id
 * 2025.06.05	hrkim			PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *								SHip Plan RTF - plant 매핑 로직 보완 : 매핑 안된 데이터에 대해서 Project Route 기준 매핑
 * 2025.06.12	hrkim			PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *								- Project Route 기준 재고 plant 매핑 로직 추가
 * 2025.07.09	hrkim			PJ2024A332 독립적 Planning 체계 및 Master Validation UI 구축
 *								- 기초재고 project route 기준 매핑 우선 순위 변경
 *								  (RTF에 plant 매핑 로직 적용전에 Project Route 기준 매핑 로직 적용 -> 해당 아이템의 가장 빠른 생산계획이 있는 Plant로 매핑 후)
 * 2025.08.19	YMH				CSR : E20250814-001139 통합 PSI 오류 수정 요청건
 * 2025.08.29	YMH				CSR E20250829-001508 실행계획개선 (속도개선)
 * 2026.01.14	YMH				E20260109-002382 ESS JV 혼용생산 관련 통합 PSI 레포트 구성
 * 2026.07.06   ZIONEX  [PJ202650304]  NextSCM Migration
 * 2026.10.27    ZIONEX      [PJ202650304] 티라엔진 제거 - SCP_PLN_SALES_ONHAND -> 통합 Dataset 기반 뷰(SCP_PLN_SALES_ONHAND_V) 교체
 *******************************************************************************************************************/
/* 운영 이관시 1. 운영 IP 지우기, 2. ITEM_ID 를 FROM_ITEM_ID로 변경하기, 3. TEMP에서 SCP_ANL_PSI_INTEGRATION 에 넣을때 조건 지우기 */
/* 운영 DB Link : select * from [SCM_MST_SITE_item]  with(nolock) */
/* exec PR_SCP_ANL_PSI_INTEGRATION '81', '20241028' */
/* exec PR_SCP_ANL_PSI_INTEGRATION '81', '20240923' */
/* exec PR_SCP_ANL_PSI_INTEGRATION '81_UC', '20240819' */
/* exec PR_SCP_ANL_PSI_INTEGRATION '81_HM', '20240819' */
/* exec PR_SCP_ANL_PSI_INTEGRATION '81_ST', '20240819' */
AS
    /* ============================================================================
     *   (b) ON 절 OR 술어 존재 - SCM_MST_BOM_EFFECTIVE_SN_V A.ALT_ID IS NULL OR ... (ORA-01719)
     *   (c) SHIP_PLAN_RTF 의 ON 절 스칼라 서브쿼리는 19c ORA-01799 회피 위해 구동테이블(SCP_PLN_RTF_ALLOCATION_V)
     * ============================================================================ */
    /* LOG 용 변수 설정 */
    V_BATCH_USER   VARCHAR2(150 CHAR) := 'scp_batch';
    V_PROGRAM_NAME VARCHAR2(150 CHAR) := 'PR_SCP_ANL_PSI_INTEGRATION';
    V_LOG_TYPE     VARCHAR2(30 CHAR);   /* START/END/ERROR/... */
    N_LOG_COUNT    NUMBER := 0;
    V_LOG_MESSAGE  VARCHAR2(1000 CHAR);
    V_DESCRIPTION  VARCHAR2(500 CHAR);
    V_TABLE_ID     VARCHAR2(150 CHAR) := 'SCP_ANL_PSI_INTEGRATION';
    D_EVENT_DATE   DATE;

    V_STATUS_DESC  VARCHAR2(1000 CHAR) := 'START';

    /* 임시 실행시간 확인용 */
    V_START_TIME   DATE;
    V_EXEC_TIME    VARCHAR2(10 CHAR) := '';  /* '00:00' */

    /* SCP 계힉 참조를 위한 변수 */
    V_DIVISION_ID          VARCHAR2(10 CHAR)  := NVL(P_DIVISION_ID, '81');
    V_PLAN_START_YYYYMMDD  VARCHAR2(8 CHAR)   := NULL;
    V_PLAN_START_DATE      DATE               := NULL;
    V_PLAN_TYPE            VARCHAR2(100 CHAR) := 'FN';
    V_PLAN_SEQ             NUMBER             := 1;
    V_HORIZON_END_YYYYMMDD VARCHAR2(8 CHAR)   := NULL;
    V_PLAN_START_YYYYMM    VARCHAR2(6 CHAR)   := NULL;   /* 계획 구간 시작월 */
    V_MASTER_ID            VARCHAR2(100 CHAR) := NULL;
    V_ENG_PLAN_ID          VARCHAR2(100 CHAR) := NULL;

    /* 전극용 구하기 */
    V_EE_DIVISION_ID         VARCHAR2(10 CHAR)  := 'EE';
    V_EE_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR)   := NULL;
    V_EE_PLAN_TYPE           VARCHAR2(100 CHAR) := 'FN';
    V_EE_PLAN_SEQ            NUMBER             := 1;
    V_EE_MASTER_ID           VARCHAR2(100 CHAR) := NULL;
    V_EE_ENG_PLAN_ID         VARCHAR2(100 CHAR) := NULL;

    /* 4.Semi WH-IN CUR_ESST_ALLOC 변수 */
    V_FROM_DIV      VARCHAR2(200 CHAR);
    V_FROM_TO_SITE  VARCHAR2(200 CHAR);
    V_TO_DIV        VARCHAR2(200 CHAR);
    V_TO_TO_SITE    VARCHAR2(200 CHAR);
    V_FROM_PLAN_SEQ VARCHAR2(200 CHAR);

    /* 360 BOH 차감 Cursor 변수 (CUR_BOH_ALLOC / CUR_BOH_ALLOC_ITEM) */
    V_CUR_SEQ_FLAG            VARCHAR2(5 CHAR);
    V_CUR_DIVISION_ID        VARCHAR2(10 CHAR);
    V_CUR_OPERATION_GROOUP   VARCHAR2(1 CHAR);
    V_CUR_COMPANY_ID         VARCHAR2(10 CHAR);
    V_CUR_PLANT_ID           VARCHAR2(10 CHAR);
    V_CUR_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CUR_CELL_ITEM_ID       VARCHAR2(40 CHAR);
    V_CUR_ITEM_ID            VARCHAR2(40 CHAR);
    V_CUR_QTY                NUMBER(20,10);   /* 死변수(원본 SELECT 미포함, 미사용) */
    V_CUR_REMAIN_QTY         NUMBER(20,10);

    V_CUR2_DIVISION_ID        VARCHAR2(10 CHAR);
    V_CUR2_OPERATION_GROOUP   VARCHAR2(1 CHAR);
    V_CUR2_COMPANY_ID         VARCHAR2(10 CHAR);
    V_CUR2_PLANT_ID           VARCHAR2(10 CHAR);
    V_CUR2_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CUR2_CELL_ITEM_ID       VARCHAR2(40 CHAR);
    V_CUR2_ITEM_ID            VARCHAR2(40 CHAR);
    V_CUR2_YYYYMM             VARCHAR2(6 CHAR);
    V_CUR2_QTY                NUMBER(20,10);
    V_CUR2_MEASURE            VARCHAR2(40 CHAR);
    V_CUR2_SEQ_FLAG           VARCHAR2(5 CHAR);
    V_CUR2_VALUE_TYPE         VARCHAR2(10 CHAR);
    V_CUR2_TO_PRODUCT         VARCHAR2(100 CHAR);
    V_CUR2_LINE_ID            VARCHAR2(10 CHAR);
    V_CUR2_TO_SITE            VARCHAR2(30 CHAR);
    V_CUR2_INCOTERMS          VARCHAR2(5 CHAR);

    V_PROD_PLAN_TOTAL_QTY NUMBER(20,10);
    V_SHIP_PLAN_TOTAL_QTY NUMBER(20,10);

    /* 260 BOH 차감 Cursor 변수 (CUR_260_BOH_ALLOC / _ITEM / _330) */
    V_CUR1ST_SEQ_FLAG            VARCHAR2(5 CHAR);
    V_CUR1ST_DIVISION_ID        VARCHAR2(10 CHAR);
    V_CUR1ST_OPERATION_GROOUP   VARCHAR2(1 CHAR);
    V_CUR1ST_COMPANY_ID         VARCHAR2(10 CHAR);
    V_CUR1ST_PLANT_ID           VARCHAR2(10 CHAR);
    V_CUR1ST_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CUR1ST_CELL_ITEM_ID       VARCHAR2(40 CHAR);
    V_CUR1ST_ITEM_ID            VARCHAR2(40 CHAR);
    V_CUR1ST_BOH_QTY            NUMBER(20,10);
    V_CUR1ST_REMAIN_QTY         NUMBER(20,10);

    V_CUR2ND_DIVISION_ID        VARCHAR2(10 CHAR);
    V_CUR2ND_OPERATION_GROOUP   VARCHAR2(1 CHAR);
    V_CUR2ND_COMPANY_ID         VARCHAR2(10 CHAR);
    V_CUR2ND_PLANT_ID           VARCHAR2(10 CHAR);
    V_CUR2ND_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CUR2ND_CELL_ITEM_ID       VARCHAR2(40 CHAR);
    V_CUR2ND_ITEM_ID            VARCHAR2(40 CHAR);
    V_CUR2ND_YYYYMM             VARCHAR2(6 CHAR);
    V_CUR2ND_QTY                NUMBER(20,10);
    V_CUR2ND_MEASURE            VARCHAR2(40 CHAR);
    V_CUR2ND_SEQ_FLAG           VARCHAR2(5 CHAR);
    V_CUR2ND_VALUE_TYPE         VARCHAR2(10 CHAR);
    V_CUR2ND_TO_PRODUCT         VARCHAR2(100 CHAR);
    V_CUR2ND_LINE_ID            VARCHAR2(10 CHAR);
    V_CUR2ND_TO_SITE            VARCHAR2(30 CHAR);
    V_CUR2ND_INCOTERMS          VARCHAR2(5 CHAR);
    V_CUR2ND_MIN_MONTH          VARCHAR2(6 CHAR);

    V_260BOH_MODEL_ITEM_ID VARCHAR2(40 CHAR);  /* 150 의 pack 제품 id */
    V_260BOH_CHILD_ITEM_ID VARCHAR2(40 CHAR);  /* 330 의 cell 제품 id */
    V_260BOH_YIELD         NUMBER(18,6);
    V_260BOH_CHILD_QTY     NUMBER(20,10);
    V_CUR330_BOH_QTY        NUMBER(20,10);
    V_CUR330_BOH_REMAIN_QTY NUMBER(20,10);

    V_CUR330_DIVISION_ID        VARCHAR2(10 CHAR);
    V_CUR330_OPERATION_GROOUP   VARCHAR2(1 CHAR);
    V_CUR330_COMPANY_ID         VARCHAR2(10 CHAR);
    V_CUR330_PLANT_ID           VARCHAR2(10 CHAR);
    V_CUR330_PLAN_START_YYYYMMDD VARCHAR2(8 CHAR);
    V_CUR330_CELL_ITEM_ID       VARCHAR2(40 CHAR);
    V_CUR330_ITEM_ID            VARCHAR2(40 CHAR);
    V_CUR330_YYYYMM             VARCHAR2(6 CHAR);
    V_CUR330_QTY                NUMBER(20,10);
    V_CUR330_MEASURE            VARCHAR2(40 CHAR);
    V_CUR330_SEQ_FLAG           VARCHAR2(5 CHAR);
    V_CUR330_VALUE_TYPE         VARCHAR2(10 CHAR);
    V_CUR330_TO_PRODUCT         VARCHAR2(100 CHAR);
    V_CUR330_LINE_ID            VARCHAR2(10 CHAR);
    V_CUR330_TO_SITE            VARCHAR2(30 CHAR);
    V_CUR330_INCOTERMS          VARCHAR2(5 CHAR);

    /* 월_INVentory 생성용 */
    V_MIN_YYYYMM   VARCHAR2(6 CHAR);
    V_MAX_YYYYMM   VARCHAR2(6 CHAR);
    V_PRE_YYYYMM   VARCHAR2(6 CHAR);
    V_PROC_YYYYMM  VARCHAR2(6 CHAR);
    V_PROC_YYYYMMDD VARCHAR2(8 CHAR);
    V_I            NUMBER := 0;


    V_FROM_DIVISION_ID VARCHAR2(30 CHAR);

    /* 빈월 0 채우기 대상 기간 */
    V_FILL_0_TARGET_PERIOD            NUMBER := -1;
    V_FILL_0_TARGET_PERIOD_END_YYYYMM VARCHAR2(6 CHAR);


    V_JJGV_LOG_MESSAGE VARCHAR2(1000 CHAR);

    /* -------------------------------------------- */
    /* 커서 선언 (원본 DECLARE CURSOR 대응) */
    /* -------------------------------------------- */
    CURSOR CUR_ESST_ALLOC IS
        SELECT SEGMENT1, SEGMENT2, SEGMENT3, SEGMENT4
          FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
         WHERE LM.LOOKUP_TYPE = 'ESST_DIV_SITE_CHANGE'
           AND LM.SEGMENT3 = V_DIVISION_ID
           AND LM.VALID_YN = 'Y';

    /* BOH Cursor (360) */
    CURSOR CUR_BOH_ALLOC IS
        SELECT A.SEQ_FLAG, A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, A.BOH_QTY
          FROM GT_PIB_MAIN A
         WHERE A.BOH_QTY > 0
           AND A.MEASURE = 'INV'
           AND A.SEQ_FLAG = '360'
           AND A.YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD,1,6)
           AND NOT EXISTS (SELECT 1
                             FROM GT_PIB_MAIN B
                            WHERE B.DIVISION_ID = A.DIVISION_ID
                              AND B.OPERATION_GROUP = A.OPERATION_GROUP
                              AND B.COMPANY_ID = A.COMPANY_ID
                              AND B.PLANT_ID = A.PLANT_ID
                              AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                              AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                              AND B.ITEM_ID = A.ITEM_ID
                              AND B.MEASURE = 'IN_HOUSE_MOVING'
                              AND B.SEQ_FLAG = '330'
                              AND B.QTY > 0)
         ORDER BY A.SEQ_FLAG, A.ITEM_ID;

    CURSOR CUR_BOH_ALLOC_ITEM IS
        SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG
             , VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
          FROM GT_PIB_MAIN
         WHERE DIVISION_ID = V_CUR_DIVISION_ID
           AND OPERATION_GROUP = V_CUR_OPERATION_GROOUP
           AND COMPANY_ID = V_CUR_COMPANY_ID
           AND PLANT_ID = V_CUR_PLANT_ID
           AND PLAN_START_YYYYMMDD = V_CUR_PLAN_START_YYYYMMDD
           AND CELL_ITEM_ID = V_CUR_CELL_ITEM_ID
           AND ITEM_ID = V_CUR_ITEM_ID
           AND MEASURE = 'PROD_PLAN'
           AND SEQ_FLAG = '350'
           AND QTY > 0
         ORDER BY YYYYMM;

    /* BOH Cursor (260) */
    CURSOR CUR_260_BOH_ALLOC IS
        SELECT A.SEQ_FLAG, A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, A.BOH_QTY, A.BOH_QTY
          FROM GT_PIB_MAIN A
         WHERE A.BOH_QTY > 0
           AND A.MEASURE = 'INV'
           AND A.SEQ_FLAG = '260'
           AND A.YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD,1,6)
         ORDER BY A.SEQ_FLAG, A.ITEM_ID;

    CURSOR CUR_260_BOH_ALLOC_ITEM IS
        SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG
             , VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
          FROM GT_PIB_MAIN
         WHERE DIVISION_ID = V_CUR1ST_DIVISION_ID
           AND OPERATION_GROUP = V_CUR1ST_OPERATION_GROOUP
           AND COMPANY_ID = V_CUR1ST_COMPANY_ID
           AND PLANT_ID = V_CUR1ST_PLANT_ID
           AND PLAN_START_YYYYMMDD = V_CUR1ST_PLAN_START_YYYYMMDD
           AND CELL_ITEM_ID = V_CUR1ST_CELL_ITEM_ID
           AND ITEM_ID = V_CUR1ST_ITEM_ID
           AND MEASURE = 'PROD_PLAN'
           AND SEQ_FLAG = '250'
           AND QTY > 0
         ORDER BY YYYYMM;

    CURSOR CUR_260_330_BOH_ALLOC_ITEM IS
        SELECT DIVISION_ID, OPERATION_GROUP, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, CELL_ITEM_ID, ITEM_ID, YYYYMM, QTY, MEASURE, SEQ_FLAG
             , VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS
          FROM GT_PIB_MAIN
         WHERE DIVISION_ID = V_CUR1ST_DIVISION_ID
           AND OPERATION_GROUP = 'A'  /* @CUR1st_OPERATION_GROOUP */
           AND COMPANY_ID = V_CUR1ST_COMPANY_ID
           AND PLANT_ID = V_CUR1ST_PLANT_ID
           AND PLAN_START_YYYYMMDD = V_CUR1ST_PLAN_START_YYYYMMDD
           AND CELL_ITEM_ID = V_CUR1ST_CELL_ITEM_ID
           AND ITEM_ID = V_260BOH_CHILD_ITEM_ID
           AND TO_SITE = V_CUR1ST_PLANT_ID
           AND MEASURE = 'IN_HOUSE_MOVING'
           AND SEQ_FLAG = '330'
           AND QTY > 0
           AND YYYYMM >= V_CUR2ND_MIN_MONTH /* 최소 반영월 이상만 반영함. */
         ORDER BY YYYYMM;

BEGIN


    /* ------------------------------------------------------------------------------------------------- */

    /* ------------------------------------------------------------------------------------------------- */
    DELETE FROM GT_PIB_ELEC_PLANT;
    DELETE FROM GT_PIB_CELL_ELEC_MAP;
    DELETE FROM GT_PIB_SITE_ITEM_PRIO;
    DELETE FROM GT_PIB_SITE_ITEM_PRIO_INV;
    DELETE FROM GT_PIB_YIELD_A;
    DELETE FROM GT_PIB_ITEM_BOM;
    DELETE FROM GT_PIB_MM_LIST;
    DELETE FROM GT_PIB_TARGET_MM_0;
    DELETE FROM GT_PIB_INV;
    DELETE FROM GT_PIB_320_340;
    DELETE FROM GT_PIB_330_YIELD;
    DELETE FROM GT_PIB_350;
    DELETE FROM GT_PIB_230_250;
    DELETE FROM GT_PIB_MAIN;
    DELETE FROM GT_PIB_GROUPBY;

    /* 시작 LOG */
    V_LOG_TYPE    := 'START';
    V_LOG_MESSAGE := '########## Start of procedure ##########';
    V_DESCRIPTION := P_DIVISION_ID || ':' || V_PROGRAM_NAME || ':' || V_TABLE_ID || ' INSERT LOGIC';
    D_EVENT_DATE  := SYSDATE;
    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );

    /* 임시 실행시간 확인용 */
    V_START_TIME := SYSDATE;

    BEGIN
        BEGIN

            /* ------------------------------------------------------------------------------------------------- */
            /* SCP PLAN 버전 정보 (PRODUCTION) */
            /* ------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'Plan seq';

            BEGIN
                SELECT PLAN_SEQ, PLAN_NAME, PLAN_START_DATE, PLAN_START_YYYYMM, HORIZON_END_YYYYMMDD, MASTER_ID, ENG_PLAN_ID
                  INTO V_PLAN_SEQ, V_PLAN_START_YYYYMMDD, V_PLAN_START_DATE, V_PLAN_START_YYYYMM, V_HORIZON_END_YYYYMMDD, V_MASTER_ID, V_ENG_PLAN_ID
                  FROM ( SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ        /* 1 */
                              , P.PLAN_NAME                                                      AS PLAN_NAME       /* 20240527 */
                              , TO_DATE(P.PLAN_NAME, 'YYYYMMDD')                                 AS PLAN_START_DATE
                              , SUBSTR(P.PLAN_NAME, 1, 6)                                        AS PLAN_START_YYYYMM     /* 202405 */
                              , SUBSTR(P.HORIZON_END_DATE, 1, 8)                                 AS HORIZON_END_YYYYMMDD  /* 20250525 */
                              , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID       /* 81::WEEKLY */
                              , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID     /* 1341::FN::1 */
                           FROM SCM_MST_PLAN P
                                INNER JOIN SCM_MST_PLAN_DETAIL D
                                        ON D.DIVISION_ID  = P.DIVISION_ID
                                       AND D.PLAN_ID      = P.PLAN_ID
                                       AND D.PLAN_TYPE    = V_PLAN_TYPE  /* FN */
                                       AND D.PLAN_STATUS  = '1'   /* 정상 완료 */
                                       AND D.CONFIRM_FLAG = 'Y'   /* 최종 Confirm */
                          WHERE 1 = 1
                            AND P.DIVISION_ID = V_DIVISION_ID
                            AND P.PLAN_NAME   = P_PLAN_START_YYYYMMDD
                            AND P.PLAN_CYCLE  = 'WEEKLY'
                          ORDER BY P.PLAN_NAME DESC
                                 , D.PLAN_SEQ )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            V_STATUS_DESC := 'division EE ';
            /* 전극 V_EE_DIVISION_ID 구하기. */
            BEGIN
                SELECT DIVISION_ID
                  INTO V_EE_DIVISION_ID
                  FROM ( SELECT B.DIVISION_ID AS DIVISION_ID
                           FROM SCM_MST_DIVISION A
                                INNER JOIN SCM_MST_DIVISION B
                                        ON B.ATTRIBUTE4 = A.ATTRIBUTE4
                                       AND B.ATTRIBUTE3 = 'EE'
                          WHERE A.DIVISION_ID = V_DIVISION_ID )   /* '81_HM' */
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            V_STATUS_DESC := ' plan EE';
            /* ------------------------------------------------------------------------------------------------- */
            /* 'EE'추가  SCP PLAN 버전 정보 (PRODUCTION) */
            /* ------------------------------------------------------------------------------------------------- */
            BEGIN
                SELECT PLAN_SEQ, PLAN_NAME, MASTER_ID, ENG_PLAN_ID
                  INTO V_EE_PLAN_SEQ, V_EE_PLAN_START_YYYYMMDD, V_EE_MASTER_ID, V_EE_ENG_PLAN_ID
                  FROM ( SELECT D.PLAN_SEQ                                                       AS PLAN_SEQ
                              , P.PLAN_NAME                                                      AS PLAN_NAME
                              , P.DIVISION_ID || '::' || P.PLAN_CYCLE                            AS MASTER_ID
                              , P.PLAN_ID || '::' || D.PLAN_TYPE || '::' || TO_CHAR(D.PLAN_SEQ)  AS ENG_PLAN_ID
                           FROM SCM_MST_PLAN P
                                INNER JOIN SCM_MST_PLAN_DETAIL D
                                        ON D.DIVISION_ID  = P.DIVISION_ID
                                       AND D.PLAN_ID      = P.PLAN_ID
                                       AND D.PLAN_TYPE    = V_PLAN_TYPE  /* FN */
                                       AND D.PLAN_STATUS  = '1'   /* 정상 완료 */
                                       AND D.CONFIRM_FLAG = 'Y'   /* 최종 Confirm */
                          WHERE 1 = 1
                            AND P.DIVISION_ID = V_EE_DIVISION_ID
                            AND P.PLAN_NAME   = P_PLAN_START_YYYYMMDD
                            AND P.PLAN_CYCLE  = 'WEEKLY'
                          ORDER BY P.PLAN_NAME DESC
                                 , D.PLAN_SEQ )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_PLAN_START_YYYYMMDD		: ' || V_PLAN_START_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_PLAN_TYPE				: ' || V_PLAN_TYPE);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_PLAN_SEQ				: ' || TO_CHAR(V_PLAN_SEQ));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_HORIZON_END_YYYYMMDD	: ' || V_HORIZON_END_YYYYMMDD);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_MASTER_ID				: ' || V_MASTER_ID);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_ENG_PLAN_ID				: ' || V_ENG_PLAN_ID);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_EE_DIVISION_ID			: ' || V_EE_DIVISION_ID);
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' @V_EE_ENG_PLAN_ID			: ' || V_EE_ENG_PLAN_ID);

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' 전극 plant 사이트 정보 추출 - #elec_plant');
            /* 2025.02.12 cell/전극 plant 매핑 로직 수정 */
            /* 1순위 : division, company, plant 정보로 매핑 */
            /* 2순위 : division, company, city, country 정보로 매핑 */
            /* 3순위 : division, company 정보로 매핑 */
            /* 4순위 : company 정보로 매핑 */
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIB_ELEC_PLANT;

            INSERT INTO GT_PIB_ELEC_PLANT
            SELECT ES.COMPANY_ID
                 , ES.DIVISION_ID
                 , NVL(ES.CITY,   'Z') AS CITY
                 , NVL(ES.COUNTRY,'Z') AS COUNTRY
                 , ES.PLANT_ID
                 , ES.SITE_DESCRIPTION
                 , ES.SCM_SITE_ID
                 , ES.SITE_ID
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                                 , ES.PLANT_ID
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_1ST
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                                 , NVL(ES.CITY,   'Z')
                                                 , NVL(ES.COUNTRY,'Z')
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_2ND
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                                 , ES.DIVISION_ID
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_3RD
                 , ROW_NUMBER() OVER (PARTITION BY ES.COMPANY_ID
                                          ORDER BY ES.PLANT_ID) AS ELEC_PLANT_PRIORITY_4TH
              FROM SCM_MST_SITE ES
             WHERE 1 = 1
               AND ES.VALID_YN        = 'Y'
               AND ES.OPERATION_GROUP = 'E'   /* 전극 Plant */
               AND ES.SITE_TYPE       = 'PLANT';

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Cell/전극 plant 매핑 - #cell_elec_plant_mapping');
            /* 2025.02.12 cell/전극 plant 매핑 로직 수정 */
            /* 1순위 : division, company, plant 정보로 매핑 */
            /* 2순위 : division, company, city, country 정보로 매핑 */
            /* 3순위 : division, company 정보로 매핑 */
            /* 4순위 : company 정보로 매핑 */
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIB_CELL_ELEC_MAP;

            INSERT INTO GT_PIB_CELL_ELEC_MAP
            SELECT CS.DIVISION_ID  AS DIVISION_ID_CS
                 , CS.COMPANY_ID   AS COMPANY_ID_CS
                 , CS.PLANT_ID     AS PLANT_ID_CS
                 , ROW_NUMBER() OVER (PARTITION BY CS.DIVISION_ID
                                                 , CS.COMPANY_ID
                                                 , CS.PLANT_ID
                                          ORDER BY CS.SCM_SITE_ID) AS CELL_PLANT_PRIORITY
                 , CS.SITE_DESCRIPTION AS SITE_DESCRIPTION_CS
                 , CS.SCM_SITE_ID      AS SCM_SITE_ID_CS
                 , NVL(E1.PLANT_ID,         NVL(E2.PLANT_ID,         NVL(E3.PLANT_ID,         E4.PLANT_ID)))         AS PLANT_ID_ES
                 , NVL(E1.SITE_DESCRIPTION, NVL(E2.SITE_DESCRIPTION, NVL(E3.SITE_DESCRIPTION, E4.SITE_DESCRIPTION))) AS SITE_DESCRIPTION_ES
                 , E1.PLANT_ID         AS PLANT_E1
                 , E2.PLANT_ID         AS PLANT_E2
                 , E3.PLANT_ID         AS PLANT_E3
                 , E4.PLANT_ID         AS PLANT_E4
                 , E1.SITE_DESCRIPTION AS SITE_DESC_E1
                 , E2.SITE_DESCRIPTION AS SITE_DESC_E2
                 , E3.SITE_DESCRIPTION AS SITE_DESC_E3
                 , E4.SITE_DESCRIPTION AS SITE_DESC_E4
              FROM SCM_MST_SITE CS
                   LEFT JOIN GT_PIB_ELEC_PLANT E1
                          ON E1.ELEC_PLANT_PRIORITY_1ST = 1
                         AND E1.DIVISION_ID = CS.DIVISION_ID
                         AND E1.COMPANY_ID  = CS.COMPANY_ID
                         AND E1.PLANT_ID    = CS.PLANT_ID
                   LEFT JOIN GT_PIB_ELEC_PLANT E2
                          ON E2.ELEC_PLANT_PRIORITY_2ND = 1
                         AND E2.DIVISION_ID = CS.DIVISION_ID
                         AND E2.COMPANY_ID  = CS.COMPANY_ID
                         AND E2.CITY        = NVL(CS.CITY,'Z')
                         AND E2.COUNTRY     = NVL(CS.COUNTRY,'Z')
                   LEFT JOIN GT_PIB_ELEC_PLANT E3
                          ON E3.ELEC_PLANT_PRIORITY_3RD = 1
                         AND E3.DIVISION_ID = CS.DIVISION_ID
                         AND E3.COMPANY_ID  = CS.COMPANY_ID
                   LEFT JOIN GT_PIB_ELEC_PLANT E4
                          ON E4.ELEC_PLANT_PRIORITY_4TH = 1
                         AND E4.COMPANY_ID  = CS.COMPANY_ID
             WHERE 1 = 1
               AND CS.VALID_YN        = 'Y'
               AND CS.OPERATION_GROUP = 'A'   /* Cell Plant */
               AND CS.SITE_TYPE       = 'PLANT'
               AND CS.OSP_YN          = 'N';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 0. temp 테이블 생성 : Measure까지 생성후 마지막에 한번에 입력하기 위해서 */

            /* ----------------------------------------------------------------------------------------------------------- */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) */
            /* 0.MKT FCST 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '0.MKT FCST ';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , '-' AS COMPANY_ID
                 , '-' AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP
                 , '-' AS FROM_SITE,
                   '-' AS CELL_ITEM_ID,  /* temp 테이블 전체를 마지막에서 한꺼번에 반영함. */
                   A.ITEM_ID
                 , 'MKT_FCST' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT,
                   '-' AS LINE_ID,   /* shipment 에는 Line_id 없으므로 공백처리함. */
                   0 AS BOH_QTY
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                         WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                         ELSE '-'
                    END ) AS TO_SITE
                 , A.INCOTERMS
                 , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '100'
                         WHEN A.OPERATION_GROUP = 'A' THEN '300'
                    END ) AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM SCP_ANL_PSI_GLOBAL A
                   LEFT JOIN SCM_MST_SITE X
                          ON X.DIVISION_ID = A.DIVISION_ID
                         AND X.SCM_SITE_ID = A.TO_SITE
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'MKT_FCST'
               AND A.OPERATION_GROUP IN ('A','P')
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.OPERATION_GROUP
                    , A.ITEM_ID
                    , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                            WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                            ELSE '-'
                       END )
                    , A.INCOTERMS
                    , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '100'
                            WHEN A.OPERATION_GROUP = 'A' THEN '300'
                       END )
                    , SUBSTR(A.YYYYMMDD,1,6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) */
            /* 1.Ship. Plan(RTF) 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '1.Ship. Plan(RTF)  ';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , NVL(B.COMPANY_ID,'-') AS COMPANY_ID
                 , NVL((CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                             ELSE B.PLANT_ID
                        END ),'-') AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID,
                   A.FROM_ITEM_ID AS ITEM_ID, /* Group 에 의해 실제 제공된 Item 표시 */
                   'SHIP_PLAN_RTF' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.SALES_SITE_ID
                         WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                         ELSE '-'
                    END ) AS TO_SITE
                 , A.INCOTERMS
                 , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '110'
                         WHEN A.OPERATION_GROUP = 'A' THEN '310'
                    END ) AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(ALLOCATION_QTY,1)),1) AS QTY
              FROM ( SELECT A0.*
                          , (CASE WHEN NVL(A0.DELIVERY_ORDER_ID,'-') < '0' THEN
                                       (SELECT MAX(K.FROM_SITE)
                                          FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                         WHERE K.ITEM_ID = A0.FROM_ITEM_ID /* Group 에 의해 실제 제공된 Item 표시 */
                                           AND K.PROJECT_CODE = A0.PROJECT_CODE
                                           AND K.TO_SITE = A0.SALES_SITE_ID
                                           /* and k.incoterms = a.incoterms */
                                           AND K.INCOTERMS = A0.SCP_INCOTERMS
                                           AND K.DIVISION_ID = V_DIVISION_ID
                                           AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                           AND K.PLAN_TYPE = V_PLAN_TYPE
                                           AND K.SEQ = V_PLAN_SEQ
                                           AND K.QTY <> 0
                                           AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                               WHERE M.ITEM_ID = A0.FROM_ITEM_ID /* Group 에 의해 실제 제공된 Item 표시 */
                                                                 AND M.PROJECT_CODE = A0.PROJECT_CODE
                                                                 AND M.TO_SITE = A0.SALES_SITE_ID
                                                                 /* and m.incoterms = a.incoterms */
                                                                 AND M.INCOTERMS = A0.SCP_INCOTERMS
                                                                 AND M.DIVISION_ID = V_DIVISION_ID
                                                                 AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                 AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                 AND M.SEQ = V_PLAN_SEQ
                                                                 AND M.QTY <> 0
                                                                 AND M.MEASURE = 'WH_IN' )
                                           AND K.MEASURE = 'WH_IN')
                                     ELSE
                                       (SELECT MAX(SUBSTR(DE.FROM_SITE_ID,1,(CASE WHEN INSTR(DE.FROM_SITE_ID,'~') = 0 THEN LENGTH(DE.FROM_SITE_ID) ELSE INSTR(DE.FROM_SITE_ID,'~') - 1 END)))
                                          FROM TH_EXP_DELIVERY_SN DE
                                         WHERE DE.MASTER_ID = A0.MASTER_ID
                                           AND DE.PLAN_ID = A0.OUT_VERSION_ID
                                           AND DE.ITEM_ID = A0.FROM_ITEM_ID /* Group 에 의해 실제 제공된 Item 표시 */
                                           AND DE.OUT_VERSION_ID = A0.OUT_VERSION_ID
                                           AND DE.ORDER_ID = A0.DELIVERY_ORDER_ID
                                           AND DE.ORG_DEMAND_ID = A0.ENG_DEMAND_ID ) /* 2025.05.22 조인 컬럼 변경 : de.demand_id -> de.org_demand_id */
                                           /* 5/22 조인 컬럼 변경 and de.demand_id = a.eng_demand_id  ) */
                                  END ) AS RESOLVED_SCM_SITE_ID
                       FROM SCP_PLN_RTF_ALLOCATION_V A0 ) A
                   LEFT OUTER JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = A.DIVISION_ID
                         AND B.SCM_SITE_ID = A.RESOLVED_SCM_SITE_ID
                   LEFT JOIN SCM_MST_SITE X
                          ON X.DIVISION_ID = A.DIVISION_ID
                         AND X.SCM_SITE_ID = A.SALES_SITE_ID
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.OPERATION_GROUP IN ('A','P')
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , A.PLAN_START_YYYYMMDD
                    , A.OPERATION_GROUP,
                      A.FROM_ITEM_ID, /* Group 에 의해 실제 제공된 Item 표시 */
                      (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.SALES_SITE_ID
                            WHEN X.SITE_TYPE = 'PLANT' THEN X.PLANT_ID
                            ELSE '-'
                       END )
                    , A.INCOTERMS
                    , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '110'
                            WHEN A.OPERATION_GROUP = 'A' THEN '310'
                       END )
                    , SUBSTR(A.YYYYMMDD,1,6);

            /* --- ESST1 반영 START */
            /* 원본 DELETE A FROM #tmp A INNER JOIN LM → 상관 DELETE + EXISTS */
            DELETE FROM GT_PIB_MAIN A
             WHERE A.SEQ_FLAG = '310'
               AND EXISTS ( SELECT 1
                              FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
                             WHERE LM.LOOKUP_TYPE = 'ESST_DIV_SITE_CHANGE'
                               AND LM.SEGMENT1 = A.DIVISION_ID
                               AND LM.SEGMENT2 = A.TO_SITE
                               AND LM.VALID_YN = 'Y' );
            /* --- ESST1 반영 END */

/* 2번(기존) : 원본 UPDATE...FROM LEFT JOIN → 상관 UPDATE. company_id 는 ELSE 없이 b.company_id(무매칭 NULL)=무가드 MAX, */
/* plant_id 는 CASE ELSE '-' 리터럴 → COUNT(*)=0 분기로 무매칭('-') 재현. */
            UPDATE GT_PIB_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.FROM_SITE)
                                               FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                              WHERE K.TO_SITE = A.TO_SITE  /* a.from_site */
                                                AND K.ITEM_ID = A.ITEM_ID
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                    WHERE M.TO_SITE = A.TO_SITE /* a.from_site */
                                                                      AND M.ITEM_ID = A.ITEM_ID
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'SHIP_PLAN_AMEND' )
                                                AND K.MEASURE = 'SHIP_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID,'-') < '0'
               AND A.SEQ_FLAG IN ('110','310');

/* 3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant */
            UPDATE GT_PIB_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.SCM_SITE_ID)
                                               FROM SCP_ANL_PRODUCTION_PLAN K
                                              WHERE 1 = 1
                                                AND K.ITEM_ID = A.ITEM_ID
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_PRODUCTION_PLAN M
                                                                    WHERE 1 = 1
                                                                      AND M.ITEM_ID = NVL((SELECT MAX(Z.ITEM_ID_ASSY) FROM SCP_MST_CELL_PROD_ASSY_MAP Z WHERE Z.DIVISION_ID = A.DIVISION_ID AND Z.ITEM_ID_PROD = A.ITEM_ID AND Z.CELL_TYPE = 'CA1' AND Z.VALID_YN = 'Y'), A.ITEM_ID)
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'PROD_PLAN_AMEND' )
                                                AND K.MEASURE = 'PROD_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID,'-') < '0'
               AND A.SEQ_FLAG IN ('110','310');

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' RTF plant 매핑을 위한 Project Route 정보 추출');  /* 2025.06.05 */
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIB_SITE_ITEM_PRIO;

            INSERT INTO GT_PIB_SITE_ITEM_PRIO
            SELECT PR.DIVISION_ID
                  ,PR.PROJECT_CODE
                  ,PR.PLANT_SITE_ID
                  ,PR.SALES_SITE_ID
                  ,PR.ITEM_ID
                  ,PR.FROM_YYYYMMDD
                  ,PR.TO_YYYYMMDD
                  ,PS.COMPANY_ID
                  ,CASE WHEN PS.OSP_YN = 'Y'
                        THEN PS.LOGISTIC_PLANT_ID
                        ELSE PS.PLANT_ID
                   END AS PLANT_ID
                  ,ROW_NUMBER() OVER (PARTITION BY PR.DIVISION_ID
                                                 , PR.ITEM_ID
                                                 , PR.SALES_SITE_ID
                                          ORDER BY PR.PLANT_SITE_ID) AS PLANT_PRIORITY
              FROM SCM_MST_SITE_ITEM_PRIORITY_V PR
                   INNER JOIN SCM_MST_SITE PS
                           ON PS.DIVISION_ID = PR.DIVISION_ID
                          AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
                          AND PS.VALID_YN    = 'Y'
                          AND PS.SITE_TYPE   = 'PLANT'
                   INNER JOIN GT_PIB_MAIN A
                           ON PR.DIVISION_ID    = A.DIVISION_ID
                          AND PR.ITEM_ID        = A.ITEM_ID
                          AND PR.SALES_SITE_ID  = A.TO_SITE
                          AND PR.FROM_YYYYMMDD <= A.YYYYMM || '01'
                          AND PR.TO_YYYYMMDD   >= TO_CHAR(LAST_DAY(TO_DATE(A.YYYYMM || '01', 'YYYYMMDD')), 'YYYYMMDD')  /* select convert(nvarchar(8), eomonth(convert(date, concat('202506','01') , 112)) , 112) */
             WHERE PR.DIVISION_ID = V_DIVISION_ID
               AND PR.TO_YYYYMMDD > V_PLAN_START_YYYYMMDD
               AND NVL(A.PLANT_ID,'-') < '0'
               AND A.SEQ_FLAG IN ('110','210','310');

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 RTF plant 매핑 '); /* 2025.06.05 */
            /* ---------------------------------------------------------------------------------------------------------------- */
            /* 원본 UPDATE...FROM INNER JOIN → 상관 UPDATE + EXISTS (plant_priority=1 은 파티션당 유일) */
            UPDATE GT_PIB_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(P.COMPANY_ID), MAX(P.PLANT_ID)
                       FROM GT_PIB_SITE_ITEM_PRIO P
                      WHERE P.DIVISION_ID    = A.DIVISION_ID
                        AND P.ITEM_ID        = A.ITEM_ID
                        AND P.SALES_SITE_ID  = A.TO_SITE
                        AND P.PLANT_PRIORITY = 1 )
             WHERE NVL(A.PLANT_ID,'-') < '0'
               AND A.SEQ_FLAG IN ('110','210','310')
               AND EXISTS ( SELECT 1
                              FROM GT_PIB_SITE_ITEM_PRIO P
                             WHERE P.DIVISION_ID    = A.DIVISION_ID
                               AND P.ITEM_ID        = A.ITEM_ID
                               AND P.SALES_SITE_ID  = A.TO_SITE
                               AND P.PLANT_PRIORITY = 1 );

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 RTF plant 매핑 ENd'); /* 2025.06.05 */
            /* ---------------------------------------------------------------------------------------------------------------- */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) */
            /* 5.PROD_PLAN 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN ';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         ELSE B.PLANT_ID
                    END ) AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , A.OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , A.LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '150'
                         WHEN A.OPERATION_GROUP = 'A' THEN '450'
                    END ) AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM SCP_ANL_PRODUCTION_PLAN A
                   LEFT OUTER JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = A.DIVISION_ID
                         AND B.SCM_SITE_ID = A.SCM_SITE_ID
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'PROD_PLAN_AMEND'
               AND A.OPERATION_GROUP IN ('A','P')
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , A.PLAN_START_YYYYMMDD
                    , A.OPERATION_GROUP
                    , A.ITEM_ID
                    , A.LINE_ID
                    , (CASE WHEN A.OPERATION_GROUP = 'P' THEN '150'
                            WHEN A.OPERATION_GROUP = 'A' THEN '450'
                       END )
                    , SUBSTR(A.YYYYMMDD,1,6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 1. 팩/모듈 제품 ( N/A : 1.2, 1.3, 1.4 ) inv start */
            /* 6.BOH 입력 */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '6.BOH ';
            INSERT INTO GT_PIB_INV
            SELECT   SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID,'::') - 1) AS DIVISION_ID
                    ,'-' AS COMPANY_ID
                    ,'-' AS PLANT_ID
                    ,SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID,'~') - 1)  AS FROM_SITE
                    ,A.ITEM_ID
                    ,V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                    ,SUM(NVL(A.QTY,0))   AS QTY
                    ,A.DESCR
                    ,C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP
              FROM SCP_PLN_TH_ENG_STOCK_PLAN A
                   INNER JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = V_DIVISION_ID
                         AND B.SCM_SITE_ID = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID,'~') - 1)
                         AND NOT (A.DESCR = 'WH' AND B.SITE_TYPE = 'SALES')
                   INNER JOIN SCP_MST_FINAL_ITEM C
                          ON C.ITEM_ID = A.ITEM_ID
                         AND C.DIVISION_ID = SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID,'::') - 1)
                         AND C.DIVISION_ID = V_DIVISION_ID
                         AND C.FLOW_ID <> 'P5000'
             WHERE 1 = 1
               AND A.MASTER_ID   = V_MASTER_ID
               AND A.PLAN_ID     = V_ENG_PLAN_ID
               AND TO_CHAR(A.RECEIVING_DTTM,'YYYYMMDD') <= V_HORIZON_END_YYYYMMDD
             GROUP BY
                      SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID,'::') - 1)
                     ,SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID,'~') - 1)
                     ,A.ITEM_ID
                     ,A.DESCR
                     ,C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP;

/* <> 'P5000' :  (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES') + onHand,  qty 0 제외 */
/* SALES_ONHAND 추가 */
            INSERT INTO GT_PIB_INV
            SELECT   A.DIVISION_ID AS DIVISION_ID
                    ,'-' AS COMPANY_ID
                    ,'-' AS PLANT_ID
                    ,A.SITE_ID  AS FROM_SITE
                    ,A.ITEM_ID
                    ,V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                    ,SUM(NVL(A.PSI_BOH_QTY,0))   AS QTY
                    ,'WH' AS DESCR
                    ,C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP
              FROM SCP_PLN_SALES_ONHAND_V A
                   INNER JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = V_DIVISION_ID
                         AND B.SCM_SITE_ID = A.SITE_ID
                   INNER JOIN SCP_MST_FINAL_ITEM C
                          ON C.ITEM_ID = A.ITEM_ID
                         AND C.DIVISION_ID = A.DIVISION_ID
                         AND C.DIVISION_ID = V_DIVISION_ID
                         AND C.FLOW_ID <> 'P5000'
             WHERE A.DIVISION_ID = V_DIVISION_ID
               AND A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE = V_PLAN_TYPE
               AND A.SEQ = V_PLAN_SEQ
               AND A.YYYYMMDD = V_PLAN_START_YYYYMMDD  /* > 이부분 맞나요? */
               AND A.PSI_BOH_QTY <> 0
             GROUP BY  A.DIVISION_ID
                      ,A.SITE_ID
                      ,A.ITEM_ID
                      ,C.ATTRIBUTE8, C.FLOW_ID, C.OPERATION_GROUP;

            /*****************************************
                #tmp_psi_integration_inv  'P5000'을 추가.
            ******************************************/
            V_STATUS_DESC := '6.BOH P5000';
/* = 'P5000' : not (a.DESCR = 'WH' and b.SITE_TYPE = 'SALES') */
            INSERT INTO GT_PIB_INV
            SELECT   SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID,'::') - 1) AS DIVISION_ID
                    ,'-' AS COMPANY_ID
                    ,'-' AS PLANT_ID
                    ,SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID,'~') - 1)  AS FROM_SITE
                    ,A.ITEM_ID
                    ,V_PLAN_START_YYYYMMDD  AS YYYYMMDD
                    ,SUM(NVL(A.QTY,0))   AS QTY
                    ,A.DESCR
                    ,'-' AS ATTRIBUTE8, C.FLOW_ID, 'P' AS OPERATION_GROUP
              FROM SCP_PLN_TH_ENG_STOCK_PLAN A
                   INNER JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = V_DIVISION_ID
                         AND B.SCM_SITE_ID = SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID,'~') - 1)
                         AND NOT (A.DESCR = 'WH' AND B.SITE_TYPE = 'SALES')
                   INNER JOIN (SELECT DISTINCT DIVISION_ID, ITEM_ID, NVL(SCP_FLOW_ID, FLOW_ID) FLOW_ID
                                 FROM SCM_MST_ITEM_SN
                                WHERE DIVISION_ID = V_DIVISION_ID
                                  AND NVL(SCP_FLOW_ID, FLOW_ID) = 'P5000'
                              ) C
                          ON C.DIVISION_ID = SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID,'::') - 1)
                         AND C.ITEM_ID = A.ITEM_ID
             WHERE 1 = 1
               AND A.MASTER_ID   = V_MASTER_ID
               AND A.PLAN_ID     = V_ENG_PLAN_ID
               AND TO_CHAR(A.RECEIVING_DTTM,'YYYYMMDD') <= V_HORIZON_END_YYYYMMDD
             GROUP BY
                      SUBSTR(A.MASTER_ID, 1, INSTR(A.MASTER_ID,'::') - 1)
                     ,SUBSTR(A.SITE_ID, 1, INSTR(A.SITE_ID,'~') - 1)
                     ,A.ITEM_ID
                     ,A.DESCR
                     ,C.FLOW_ID;

            /****************************************************
            EE 재고('560')를 #tmp_psi_integration_inv 에 추가로 insert 해야함.
            ****************************************************/
            V_STATUS_DESC := '6.BOH EE';

            /* 재고의 COMPANY_ID, PLANT_ID 반영.  (원본 UPDATE...FROM b LEFT JOIN cs → 상관 UPDATE) */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN NULL
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                               WHEN B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N' AND A.OPERATION_GROUP = 'E' AND B.OPERATION_GROUP = 'A' AND CS.PLANT_ID_ES IS NOT NULL THEN CS.PLANT_ID_ES  /* 2025.02.13 전극 plant 매핑 로직 수정 */
                                            /* 2025.02.13 변경전 로직  when (b.SITE_TYPE = 'PLANT' and b.osp_yn= 'N'  and A.operation_group = 'E' and b.operation_group = 'A') THEN 	-- 셀사이트에 있는 전극 재고는 전극 PLANT로 처리 */
                                            /* 2025.02.13 변경전 로직		  substring(b.plant_id,1, len(b.plant_id)-1) + convert(nvarchar(1),convert(int, right(b.plant_id,1)) + 1) */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                            LEFT JOIN GT_PIB_CELL_ELEC_MAP CS  /* 2025.02.13 전극 plant 매핑 로직 수정 */
                                   ON CS.CELL_PLANT_PRIORITY = 1
                                  AND CS.DIVISION_ID_CS = B.DIVISION_ID
                                  AND CS.PLANT_ID_CS    = B.PLANT_ID
                                  AND CS.COMPANY_ID_CS  = B.COMPANY_ID
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = A.FROM_SITE );

/* 1번(추가) : 가장 빠른 WH_IN이 있는 Plant */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.FROM_SITE)
                                               FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                              WHERE K.TO_SITE = A.FROM_SITE
                                                AND K.ITEM_ID = A.ITEM_ID
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                    WHERE M.TO_SITE = A.FROM_SITE
                                                                      AND M.ITEM_ID = A.ITEM_ID
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'WH_IN' )  /* WH_IN을 봄 */
                                                AND K.MEASURE = 'WH_IN') ) /* WH_IN */
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* 2번(기존) */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.FROM_SITE)
                                               FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                              WHERE K.TO_SITE = A.FROM_SITE
                                                AND K.ITEM_ID = A.ITEM_ID
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                    WHERE M.TO_SITE = A.FROM_SITE
                                                                      AND M.ITEM_ID = A.ITEM_ID
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'SHIP_PLAN_AMEND' )
                                                AND K.MEASURE = 'SHIP_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* 3번(추가) : 해당 아이템의 가장 빠른 생산계획이 있는 Plant */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.SCM_SITE_ID)
                                               FROM SCP_ANL_PRODUCTION_PLAN K
                                              WHERE 1 = 1
                                                AND K.ITEM_ID = A.ITEM_ID
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_PRODUCTION_PLAN M
                                                                    WHERE 1 = 1
                                                                      AND M.ITEM_ID = NVL((SELECT MAX(Z.ITEM_ID_ASSY) FROM SCP_MST_CELL_PROD_ASSY_MAP Z WHERE Z.DIVISION_ID = A.DIVISION_ID AND Z.ITEM_ID_PROD = A.ITEM_ID AND Z.CELL_TYPE = 'CA1' AND Z.VALID_YN = 'Y'), A.ITEM_ID)
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'PROD_PLAN_AMEND' )
                                                AND K.MEASURE = 'PROD_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* 3-2번(2025.07.09 RTF에 맞춰 매핑 우선순위 변경) : Project Route 생산 Plant 기준으로 매핑 */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' 재고 plant 매핑을 위한 Project Route 정보 추출');  /* 2025.06.12 */
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIB_SITE_ITEM_PRIO_INV;

            INSERT INTO GT_PIB_SITE_ITEM_PRIO_INV
            SELECT PR.DIVISION_ID
                  ,PR.PROJECT_CODE
                  ,PR.PLANT_SITE_ID
                  ,PR.SALES_SITE_ID
                  ,PR.ITEM_ID
                  ,PR.FROM_YYYYMMDD
                  ,PR.TO_YYYYMMDD
                  ,PS.COMPANY_ID
                  ,CASE WHEN PS.OSP_YN = 'Y'
                        THEN PS.LOGISTIC_PLANT_ID
                        ELSE PS.PLANT_ID
                   END AS PLANT_ID
                  ,ROW_NUMBER() OVER (PARTITION BY PR.DIVISION_ID
                                                 , PR.ITEM_ID
                                          ORDER BY PR.PLANT_SITE_ID) AS PLANT_PRIORITY
              FROM SCM_MST_SITE_ITEM_PRIORITY_V PR
                   INNER JOIN SCM_MST_SITE PS
                           ON PS.DIVISION_ID = PR.DIVISION_ID
                          AND PS.SCM_SITE_ID = PR.PLANT_SITE_ID
                          AND PS.VALID_YN    = 'Y'
                          AND PS.SITE_TYPE   = 'PLANT'
                   INNER JOIN GT_PIB_INV A
                           ON PR.DIVISION_ID    = A.DIVISION_ID
                          AND PR.ITEM_ID        = A.ITEM_ID
                          AND PR.FROM_YYYYMMDD <= A.YYYYMMDD
                          AND PR.TO_YYYYMMDD   >= A.YYYYMMDD
             WHERE PR.DIVISION_ID = V_DIVISION_ID
               AND PR.TO_YYYYMMDD > V_PLAN_START_YYYYMMDD
               AND NVL(A.PLANT_ID,'-') < '0';

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 재고 plant 매핑 '); /* 2025.06.12 */
            /* ---------------------------------------------------------------------------------------------------------------- */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(P.COMPANY_ID), MAX(P.PLANT_ID)
                       FROM GT_PIB_SITE_ITEM_PRIO_INV P
                      WHERE P.DIVISION_ID    = A.DIVISION_ID
                        AND P.ITEM_ID        = A.ITEM_ID
                        AND P.PLANT_PRIORITY = 1 )
             WHERE NVL(A.PLANT_ID,'-') < '0'
               AND EXISTS ( SELECT 1
                              FROM GT_PIB_SITE_ITEM_PRIO_INV P
                             WHERE P.DIVISION_ID    = A.DIVISION_ID
                               AND P.ITEM_ID        = A.ITEM_ID
                               AND P.PLANT_PRIORITY = 1 );

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || ' Project Route 기준 재고 plant 매핑 ENd'); /* 2025.06.12 */
            /* ---------------------------------------------------------------------------------------------------------------- */

/* 4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정 */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT FROM_SITE FROM (
                                                SELECT K.FROM_SITE
                                                  FROM GT_PIB_INV K
                                                       INNER JOIN SCM_MST_SITE M
                                                               ON M.DIVISION_ID = K.DIVISION_ID
                                                              AND M.SCM_SITE_ID = K.FROM_SITE
                                                              AND M.SITE_TYPE = 'PLANT'
                                                 WHERE K.DIVISION_ID = A.DIVISION_ID
                                                   AND (K.ITEM_ID = A.ITEM_ID OR K.ITEM_ID = NVL((SELECT MAX(Z.ITEM_ID_ASSY) FROM SCP_MST_CELL_PROD_ASSY_MAP Z WHERE Z.DIVISION_ID = A.DIVISION_ID AND Z.ITEM_ID_PROD = A.ITEM_ID AND Z.CELL_TYPE = 'CA1' AND Z.VALID_YN = 'Y'), A.ITEM_ID))
                                                   AND K.QTY <> 0
                                                 GROUP BY K.FROM_SITE, K.ITEM_ID
                                                 ORDER BY SUM(K.QTY) DESC )
                                              WHERE ROWNUM = 1) )
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* 5번(기존) */
            UPDATE GT_PIB_INV A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.FROM_SITE)
                                               FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                              WHERE K.TO_SITE = A.FROM_SITE
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                    WHERE M.TO_SITE = A.FROM_SITE
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'SHIP_PLAN_AMEND' )
                                                AND K.MEASURE = 'SHIP_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID,'-') < '0';

/* -- plant do 3, 4 작업 수행. start */
/* 4번(추가) : 해당 아이템의 BOH가 가장 큰 Plant로 지정 */
            UPDATE GT_PIB_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'  /* a.TO_SITE */
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT FROM_SITE FROM (
                                                SELECT K.FROM_SITE
                                                  FROM GT_PIB_INV K
                                                       INNER JOIN SCM_MST_SITE M
                                                               ON M.DIVISION_ID = K.DIVISION_ID
                                                              AND M.SCM_SITE_ID = K.FROM_SITE
                                                              AND M.SITE_TYPE = 'PLANT'
                                                 WHERE K.DIVISION_ID = A.DIVISION_ID
                                                   AND (K.ITEM_ID = A.ITEM_ID OR K.ITEM_ID = NVL((SELECT MAX(Z.ITEM_ID_ASSY) FROM SCP_MST_CELL_PROD_ASSY_MAP Z WHERE Z.DIVISION_ID = A.DIVISION_ID AND Z.ITEM_ID_PROD = A.ITEM_ID AND Z.CELL_TYPE = 'CA1' AND Z.VALID_YN = 'Y'), A.ITEM_ID))
                                                   AND K.QTY <> 0
                                                 GROUP BY K.FROM_SITE, K.ITEM_ID
                                                 ORDER BY SUM(K.QTY) DESC )
                                              WHERE ROWNUM = 1) )
             WHERE NVL(A.PLANT_ID,'-') < '0'
               AND A.SEQ_FLAG IN ('110','310');

/* 5번(기존) */
            UPDATE GT_PIB_MAIN A
               SET (A.COMPANY_ID, A.PLANT_ID) =
                   ( SELECT MAX(B.COMPANY_ID)
                          , CASE WHEN COUNT(*) = 0 THEN '-'
                                 ELSE MAX(CASE WHEN B.SITE_TYPE = 'SALES' THEN '-'
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'N') THEN B.PLANT_ID
                                               WHEN (B.SITE_TYPE = 'PLANT' AND B.OSP_YN = 'Y') THEN B.LOGISTIC_PLANT_ID
                                               ELSE '-'
                                          END )
                            END
                       FROM SCM_MST_SITE B
                      WHERE B.DIVISION_ID = A.DIVISION_ID
                        AND B.SCM_SITE_ID = (SELECT MAX(K.FROM_SITE)
                                               FROM SCP_ANL_SHIPMENT_PLAN_FG K
                                              WHERE K.TO_SITE = A.TO_SITE /* a.from_site */
                                                AND K.DIVISION_ID = A.DIVISION_ID
                                                AND K.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                AND K.PLAN_TYPE = V_PLAN_TYPE
                                                AND K.SEQ = V_PLAN_SEQ
                                                AND K.QTY <> 0
                                                AND K.YYYYMMDD = ( SELECT MIN(M.YYYYMMDD)
                                                                     FROM SCP_ANL_SHIPMENT_PLAN_FG M
                                                                    WHERE M.TO_SITE = A.TO_SITE /* a.from_site */
                                                                      AND M.DIVISION_ID = A.DIVISION_ID
                                                                      AND M.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                                                                      AND M.PLAN_TYPE = V_PLAN_TYPE
                                                                      AND M.SEQ = V_PLAN_SEQ
                                                                      AND M.QTY <> 0
                                                                      AND M.MEASURE = 'SHIP_PLAN_AMEND' )
                                                AND K.MEASURE = 'SHIP_PLAN_AMEND') )
             WHERE NVL(A.PLANT_ID,'-') < '0'
               AND A.SEQ_FLAG IN ('110','310');
/* -- plant do 3, 4 작업 수행. end ---- */

            V_STATUS_DESC := '6.BOH inv';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT   A.DIVISION_ID AS DIVISION_ID
                    ,NVL(A.COMPANY_ID,'-')
                    ,NVL(A.PLANT_ID,'-')
                    ,V_PLAN_START_YYYYMMDD AS PLAN_START_YYYYMMDD
                    ,1 AS SEQ
                    ,A.OPERATION_GROUP AS OPERATION_GROUP
                    ,'-'  AS FROM_SITE
                    ,'-' AS CELL_ITEM_ID
                    ,A.ITEM_ID
                    ,'INV' AS MEASURE
                    ,'-' AS VALUE_TYPE
                    ,'-' AS TO_PRODUCT
                    ,'-' AS LINE_ID
                    ,NVL(SUM(NVL(A.QTY,0)),0)   AS BOH_QTY
                    ,'-' AS TO_SITE
                    ,'-' AS INCOTERMS
                    ,(CASE WHEN A.OPERATION_GROUP='P' AND A.FLOW_ID IN ('P5500','P9500')      THEN '160'
                           WHEN A.OPERATION_GROUP='P' AND A.FLOW_ID NOT IN ('P5500','P9500')  THEN '260'
                           WHEN A.OPERATION_GROUP='A' AND SUBSTR(A.ATTRIBUTE8,1,2) = 'CP'  THEN '360'
                           WHEN A.OPERATION_GROUP='A' AND SUBSTR(A.ATTRIBUTE8,1,2) = 'CA'  THEN '460'
                      END ) AS SEQ_FLAG
                    ,SUBSTR(V_PLAN_START_YYYYMMDD,1,6) AS YYYYMM
                    ,0
              FROM GT_PIB_INV A
             WHERE A.OPERATION_GROUP IN ('A','P')
             GROUP BY A.DIVISION_ID
                     ,A.COMPANY_ID
                     ,A.PLANT_ID
                     ,A.OPERATION_GROUP
                     ,A.ITEM_ID
                     ,(CASE WHEN A.OPERATION_GROUP='P' AND A.FLOW_ID IN ('P5500','P9500')      THEN '160'
                            WHEN A.OPERATION_GROUP='P' AND A.FLOW_ID NOT IN ('P5500','P9500')  THEN '260'
                            WHEN A.OPERATION_GROUP='A' AND SUBSTR(A.ATTRIBUTE8,1,2) = 'CP'  THEN '360'
                            WHEN A.OPERATION_GROUP='A' AND SUBSTR(A.ATTRIBUTE8,1,2) = 'CA'  THEN '460'
                       END );

            V_STATUS_DESC := '6.BOH inv E';
            V_STATUS_DESC := 'bbb  1';

            INSERT INTO GT_PIB_320_340
            SELECT  A.DIVISION_ID
                  , B.COMPANY_ID
                  , X.COMPANY_ID AS TO_COMPANY_ID
                  , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                          ELSE B.PLANT_ID
                     END ) AS PLANT_ID
                  , (CASE WHEN X.SITE_TYPE = 'SALES' THEN A.TO_SITE
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'N') THEN X.PLANT_ID
                          WHEN (X.SITE_TYPE = 'PLANT' AND X.OSP_YN = 'Y') THEN X.LOGISTIC_PLANT_ID
                          ELSE '-'
                     END ) AS TO_PLANT_ID
                  , A.BOD_ID
                  , A.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'A' AS OPERATION_GROUP
                  , A.FROM_SITE
                  , A.ITEM_ID
                  , A.TO_SITE
                  , C.SSP_INCOTERMS AS INCOTERMS
                  , A.QTY
                  , C.LT_TOTAL_SSP
                  , A.YYYYMMDD AS DEPARTURE_YYYYMMDD
                  , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                   LEFT JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = A.DIVISION_ID
                         AND B.SCM_SITE_ID = A.FROM_SITE
                   LEFT JOIN SCM_MST_SITE X
                          ON X.DIVISION_ID = A.DIVISION_ID
                         AND X.SCM_SITE_ID = A.TO_SITE
                   LEFT JOIN SCP_MST_BOD_N_V C
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.BOD_ID = C.BOD_ID
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD;

            /* --- ESST2 반영 START */
            INSERT INTO GT_PIB_320_340
            SELECT  A.DIVISION_ID
                  , B.COMPANY_ID,
                    X.COMPANY_ID AS TO_COMPANY_ID, /* FRIM_DIV에 나오는 부분에선 필요 없음. */
                    (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                          ELSE B.PLANT_ID
                     END ) AS PLANT_ID
                  , RTRIM(LTRIM(LM.SEGMENT4)) AS TO_PLANT_ID
                  , A.BOD_ID
                  , A.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'A' AS OPERATION_GROUP
                  , 'ESST_OUT'  AS FROM_SITE
                  , A.ITEM_ID,
                    RTRIM(LTRIM(LM.SEGMENT4)) AS TO_SITE,   /* To site는 G821로 지정 한다. */
                    C.SSP_INCOTERMS AS INCOTERMS
                  , NVL(SUM(NVL(A.QTY,0)),0) AS QTY
                  , C.LT_TOTAL_SSP
                  , A.YYYYMMDD AS DEPARTURE_YYYYMMDD
                  , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
              FROM SCP_ANL_SHIPMENT_PLAN_FG A
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
                          ON LM.LOOKUP_TYPE = 'ESST_DIV_SITE_CHANGE'
                         AND LM.SEGMENT1 = A.DIVISION_ID
                         AND LM.SEGMENT2 = A.TO_SITE
                         AND LM.VALID_YN = 'Y'
                   LEFT JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = A.DIVISION_ID
                         AND B.SCM_SITE_ID = A.FROM_SITE
                   LEFT JOIN SCM_MST_SITE X
                          ON X.DIVISION_ID = LM.SEGMENT3
                         AND X.PLANT_ID = LM.SEGMENT4
                         AND X.OPERATION_GROUP = 'A'
                   LEFT JOIN SCP_MST_BOD_N_V C
                          ON A.DIVISION_ID = C.DIVISION_ID
                         AND A.BOD_ID = C.BOD_ID
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.BIZ_TYPE = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , X.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , RTRIM(LTRIM(LM.SEGMENT4))
                    , A.BOD_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , RTRIM(LTRIM(LM.SEGMENT4))
                    , C.SSP_INCOTERMS
                    , C.LT_TOTAL_SSP
                    , A.YYYYMMDD
                    , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD');
            /* --- ESST2 반영 END */

            V_STATUS_DESC := 'bbb  320';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , COMPANY_ID
                 , PLANT_ID
                 , PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , ITEM_ID
                 , 'SHIP_PLAN_SEMI' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , TO_PLANT_ID AS TO_SITE
                 , INCOTERMS
                 , '320' AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM GT_PIB_320_340 A
             WHERE PLANT_ID <> TO_PLANT_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY DIVISION_ID
                    , COMPANY_ID
                    , PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , TO_PLANT_ID
                    , INCOTERMS
                    , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 3. 셀 제품 ( N/A : 없음) */
            /* 4.Semi WH-IN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '4.Semi WH-IN';

            OPEN CUR_ESST_ALLOC;
            LOOP
                FETCH CUR_ESST_ALLOC INTO V_FROM_DIV, V_FROM_TO_SITE, V_TO_DIV, V_TO_TO_SITE;
                EXIT WHEN CUR_ESST_ALLOC%NOTFOUND;

                IF (V_DIVISION_ID = V_TO_DIV) THEN

                    /* seq 도출. */
                    BEGIN
                        SELECT PLAN_SEQ
                          INTO V_FROM_PLAN_SEQ
                          FROM ( SELECT D.PLAN_SEQ AS PLAN_SEQ  /* 1 */
                                   FROM SCM_MST_PLAN P
                                        INNER JOIN SCM_MST_PLAN_DETAIL D
                                                ON D.DIVISION_ID  = P.DIVISION_ID
                                               AND D.PLAN_ID      = P.PLAN_ID
                                               AND D.PLAN_TYPE    = V_PLAN_TYPE /* FN */
                                               AND D.PLAN_STATUS  = '1'  /* 정상 완료 */
                                               AND D.CONFIRM_FLAG = 'Y'  /* 최종 Confirm */
                                  WHERE 1 = 1
                                    AND P.DIVISION_ID = V_FROM_DIV
                                    AND P.PLAN_NAME   = V_PLAN_START_YYYYMMDD
                                    AND P.PLAN_CYCLE  = 'WEEKLY'
                                  ORDER BY P.PLAN_NAME DESC
                                         , D.PLAN_SEQ )
                         WHERE ROWNUM = 1;
                    EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
                    END;

                    /* '320' 의 형태로 입력함. */
                    INSERT INTO GT_PIB_320_340
                    SELECT  V_DIVISION_ID
                          , B.COMPANY_ID
                          , X.COMPANY_ID AS TO_COMPANY_ID
                          , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                                  ELSE B.PLANT_ID
                             END ) AS PLANT_ID
                          , V_TO_TO_SITE AS TO_PLANT_ID
                          , A.BOD_ID
                          , A.PLAN_START_YYYYMMDD
                          , 1 AS SEQ
                          , 'A' AS OPERATION_GROUP
                          , 'ESST_WH_IN'  AS FROM_SITE
                          , A.ITEM_ID
                          , V_TO_TO_SITE AS TO_SITE
                          , C.SSP_INCOTERMS AS INCOTERMS
                          , NVL(SUM(NVL(A.QTY,0)),0) AS QTY
                          , C.LT_TOTAL_SSP
                          , A.YYYYMMDD AS DEPARTURE_YYYYMMDD
                          , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD') AS ARRIVAL_YYYYMMDD
                      FROM SCP_ANL_SHIPMENT_PLAN_FG A
                           LEFT JOIN SCM_MST_SITE B
                                  ON B.DIVISION_ID = A.DIVISION_ID
                                 AND B.SCM_SITE_ID = A.FROM_SITE
                           LEFT JOIN SCM_MST_SITE X
                                  ON X.DIVISION_ID = V_TO_DIV
                                 AND X.PLANT_ID = V_TO_TO_SITE
                                 AND X.OPERATION_GROUP = 'A'
                           LEFT JOIN SCP_MST_BOD_N_V C
                                  ON A.DIVISION_ID = C.DIVISION_ID
                                 AND A.BOD_ID = C.BOD_ID
                     WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
                       AND A.PLAN_TYPE           = V_PLAN_TYPE
                       AND A.SEQ                 = V_FROM_PLAN_SEQ
                       AND A.DIVISION_ID         = V_FROM_DIV
                       AND A.TO_SITE             = V_FROM_TO_SITE
                       AND A.MEASURE = 'SHIP_PLAN_AMEND'
                       AND A.BIZ_TYPE = 'A'
                       AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
                     GROUP BY B.COMPANY_ID
                            , X.COMPANY_ID
                            , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                                    ELSE B.PLANT_ID
                               END )
                            , A.BOD_ID
                            , A.PLAN_START_YYYYMMDD
                            , A.ITEM_ID
                            , C.SSP_INCOTERMS
                            , C.LT_TOTAL_SSP
                            , A.YYYYMMDD
                            , TO_CHAR(TO_DATE(A.YYYYMMDD,'YYYYMMDD') + TRUNC(C.LT_TOTAL_SSP), 'YYYYMMDD');

                END IF;
            END LOOP; /* OPEN CUR_ESST_ALLOC */
            CLOSE CUR_ESST_ALLOC;

            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID
                 , TO_COMPANY_ID
                 , TO_PLANT_ID
                 , PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , ITEM_ID
                 , 'SEMI_WH_IN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '340' AS SEQ_FLAG
                 , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(QTY,0)),0) AS QTY
              FROM GT_PIB_320_340 A
             WHERE PLANT_ID <> TO_PLANT_ID
               AND A.ARRIVAL_YYYYMMDD <= V_HORIZON_END_YYYYMMDD
               AND A.FROM_SITE <> 'ESST_OUT'
             GROUP BY DIVISION_ID
                    , TO_COMPANY_ID
                    , TO_PLANT_ID
                    , PLAN_START_YYYYMMDD
                    , ITEM_ID
                    , SUBSTR(A.ARRIVAL_YYYYMMDD,1,6);

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 3. 셀 제품 ( N/A : 없음) */
            /* 3.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING';

            /* yield 보관 start -- */
            INSERT INTO GT_PIB_330_YIELD   /* Pack제품(150) --> Cell제품(330)의 수율 가져올 목적. */
            SELECT DISTINCT A.DIVISION_ID, A.OPERATION_GROUP, A.COMPANY_ID, A.PLANT_ID, A.PLAN_START_YYYYMMDD, A.CELL_ITEM_ID, A.ITEM_ID, B.CHILD_ITEM_ID, A.LINE_ID, A.YYYYMM, Y.YIELD  /* ,	 isnull(b.accumulated_child_qty,1), a.QTY  -- a.boh_qty, */
              FROM GT_PIB_MAIN A
                   INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                           ON B.DIVISION_ID = A.DIVISION_ID
                          AND B.PLANT_ID = A.PLANT_ID
                          AND B.MODEL_ID = A.ITEM_ID
                          AND A.PLAN_START_YYYYMMDD BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
                   INNER JOIN SCP_MST_FINAL_ITEM C
                           ON C.ITEM_ID = B.CHILD_ITEM_ID
                          AND C.DIVISION_ID = A.DIVISION_ID
                          AND C.OPERATION_GROUP_ID = 'A'
                          AND C.ATTRIBUTE8 = 'CP'
                   /* pack, cell 수율반영 가져 오기 */
                   LEFT JOIN (SELECT Y.OPERATION_GROUP, A.*
                                FROM SCM_MST_YIELD_VER_H_V A
                                     INNER JOIN (
                                                SELECT DISTINCT SEGMENT4 AS OPERATION_ID, SEGMENT5 AS OPERATION_GROUP
                                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                                                 WHERE B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                                   AND B.VALID_YN = 'Y'
                                                   AND B.SEGMENT3 = 'Y'
                                                   AND B.SEGMENT5 = 'P'   /* 'P':Pack, 'A':Cell */
                                                ) Y
                                             ON A.OPERATION_ID = Y.OPERATION_ID
                               WHERE 1 = 1
                                 AND A.DIVISION_ID = V_DIVISION_ID ) Y
                          ON Y.DIVISION_ID = A.DIVISION_ID
                         AND Y.OPERATION_GROUP = A.OPERATION_GROUP
                         AND Y.COMPANY_ID = A.COMPANY_ID
                         AND Y.PLANT_ID = A.PLANT_ID
                         AND Y.LINE_ID = A.LINE_ID
                         AND Y.MONTH = A.YYYYMM
                         AND Y.ITEM_ID = A.ITEM_ID
             WHERE A.SEQ_FLAG = '150'
               AND A.YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD,1,6);
            /* yield 보관 end -- */

            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , A.CELL_ITEM_ID
                 , B.CHILD_ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '330' AS SEQ_FLAG
                 , A.YYYYMM,
                   NVL(SUM(NVL(A.QTY,0) * NVL(B.ACCUMULATED_CHILD_QTY,1) / NVL(Y.YIELD,1)),0) AS QTY  /* pack, cell 수율반영 */
              FROM GT_PIB_MAIN A
                   INNER JOIN SCM_MST_MODEL_FINAL_ITEM_BOM_V B
                           ON B.DIVISION_ID = A.DIVISION_ID
                          AND B.PLANT_ID = A.PLANT_ID
                          AND B.MODEL_ID = A.ITEM_ID
                          AND A.PLAN_START_YYYYMMDD BETWEEN B.EFF_START_DATE AND B.EFF_END_DATE
                   INNER JOIN SCP_MST_FINAL_ITEM C
                           ON C.ITEM_ID = B.CHILD_ITEM_ID
                          AND C.DIVISION_ID = A.DIVISION_ID
                          AND C.OPERATION_GROUP_ID = 'A'
                          AND C.ATTRIBUTE8 = 'CP'
                   /* pack, cell 수율반영 가져 오기 */
                   LEFT JOIN (SELECT Y.OPERATION_GROUP, A.*
                                FROM SCM_MST_YIELD_VER_H_V A
                                     INNER JOIN (
                                                SELECT DISTINCT SEGMENT4 AS OPERATION_ID, SEGMENT5 AS OPERATION_GROUP
                                                  FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                                                 WHERE B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                                   AND B.VALID_YN = 'Y'
                                                   AND B.SEGMENT3 = 'Y'
                                                   AND B.SEGMENT5 = 'P'   /* 'P':Pack, 'A':Cell */
                                                ) Y
                                             ON A.OPERATION_ID = Y.OPERATION_ID
                               WHERE 1 = 1
                                 AND A.DIVISION_ID = V_DIVISION_ID ) Y
                          ON Y.DIVISION_ID = A.DIVISION_ID
                         AND Y.OPERATION_GROUP = A.OPERATION_GROUP
                         AND Y.COMPANY_ID = A.COMPANY_ID
                         AND Y.PLANT_ID = A.PLANT_ID
                         AND Y.LINE_ID = A.LINE_ID
                         AND Y.MONTH = A.YYYYMM
                         AND Y.ITEM_ID = A.ITEM_ID
             WHERE A.SEQ_FLAG = '150'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.CELL_ITEM_ID
                    , B.CHILD_ITEM_ID
                    , A.YYYYMM;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 3. 셀 제품 ( N/A : 없음) */
            /* 5.PROD_PLAN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN';

            /* -  이하 shipment_plan_semi 입력 */
            INSERT INTO GT_PIB_350
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         ELSE B.PLANT_ID
                    END ) AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '350' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY,0)),0) AS QTY
              FROM SCP_ANL_SHIPMENT_PLAN_SEMI A
                   LEFT JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = A.DIVISION_ID
                         AND B.SCM_SITE_ID = A.FROM_SITE
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.OPERATION_GROUP = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , SUBSTR(A.YYYYMMDD,1,6);

            /* 이하 shipment_plan_fg 입력 */
            INSERT INTO GT_PIB_350
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , B.COMPANY_ID
                 , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                         ELSE B.PLANT_ID
                    END ) AS PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '350' AS SEQ_FLAG
                 , SUBSTR(A.YYYYMMDD,1,6) AS YYYYMM
                 , NVL(SUM(NVL(A.QTY,0)),0) AS QTY
              FROM SCP_ANL_SHIPMENT_PLAN_FG A
                   LEFT JOIN SCM_MST_SITE B
                          ON B.DIVISION_ID = A.DIVISION_ID
                         AND B.SCM_SITE_ID = A.FROM_SITE
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.PLAN_TYPE           = V_PLAN_TYPE
               AND A.SEQ                 = V_PLAN_SEQ
               AND A.DIVISION_ID         = V_DIVISION_ID
               AND A.MEASURE = 'SHIP_PLAN_AMEND'
               AND A.BIZ_TYPE = 'A'
               AND A.YYYYMMDD <= V_HORIZON_END_YYYYMMDD
             GROUP BY A.DIVISION_ID
                    , B.COMPANY_ID
                    , (CASE WHEN B.OSP_YN = 'Y' THEN B.LOGISTIC_PLANT_ID
                            ELSE B.PLANT_ID
                       END )
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , SUBSTR(A.YYYYMMDD,1,6);

            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , A.ITEM_ID
                 , 'PROD_PLAN' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , '-' AS TO_SITE
                 , '-' AS INCOTERMS
                 , '350' AS SEQ_FLAG
                 , A.YYYYMM
                 , NVL(SUM(NVL(A.QTY,0)),0) AS QTY
              FROM GT_PIB_350 A
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , A.ITEM_ID
                    , A.YYYYMM;

/* 360boh차감, 360차감, #차감360 */
/* BOH로 PROD 차감 START */
/* ------------------------------------------ */
/* 셀 제품의 BOH로 셀 제품의 PROD_PLAN 차감. */
/* ------------------------------------------ */
            BEGIN
                OPEN CUR_BOH_ALLOC;
                LOOP
                    FETCH CUR_BOH_ALLOC INTO V_CUR_SEQ_FLAG, V_CUR_DIVISION_ID, V_CUR_OPERATION_GROOUP, V_CUR_COMPANY_ID, V_CUR_PLANT_ID, V_CUR_PLAN_START_YYYYMMDD, V_CUR_CELL_ITEM_ID, V_CUR_ITEM_ID, V_CUR_REMAIN_QTY;
                    EXIT WHEN CUR_BOH_ALLOC%NOTFOUND;

                    SELECT NVL(SUM(NVL(QTY,0)),0)
                      INTO V_PROD_PLAN_TOTAL_QTY
                      FROM GT_PIB_MAIN A
                     WHERE A.OPERATION_GROUP = V_CUR_OPERATION_GROOUP
                       AND A.COMPANY_ID = V_CUR_COMPANY_ID
                       AND A.PLANT_ID = V_CUR_PLANT_ID
                       AND A.PLAN_START_YYYYMMDD = V_CUR_PLAN_START_YYYYMMDD
                       AND A.CELL_ITEM_ID = V_CUR_CELL_ITEM_ID
                       AND A.ITEM_ID = V_CUR_ITEM_ID
                       AND A.MEASURE = 'PROD_PLAN'
                       AND A.SEQ_FLAG = '350';

                    SELECT NVL(SUM(NVL(QTY,0)),0)
                      INTO V_SHIP_PLAN_TOTAL_QTY
                      FROM GT_PIB_MAIN A
                     WHERE A.OPERATION_GROUP = V_CUR_OPERATION_GROOUP
                       AND A.COMPANY_ID = V_CUR_COMPANY_ID
                       AND A.PLANT_ID = V_CUR_PLANT_ID
                       AND A.PLAN_START_YYYYMMDD = V_CUR_PLAN_START_YYYYMMDD
                       AND A.CELL_ITEM_ID = V_CUR_CELL_ITEM_ID
                       AND A.ITEM_ID = V_CUR_ITEM_ID
                       AND A.MEASURE IN ('SHIP_PLAN_RTF','SHIP_PLAN_SEMI')
                       AND A.SEQ_FLAG IN ('310','320');

                    IF ((V_CUR_REMAIN_QTY + V_PROD_PLAN_TOTAL_QTY) - V_SHIP_PLAN_TOTAL_QTY > 0) THEN

                        IF (V_CUR_REMAIN_QTY > ((V_CUR_REMAIN_QTY + V_PROD_PLAN_TOTAL_QTY) - V_SHIP_PLAN_TOTAL_QTY)) THEN
                            V_CUR_REMAIN_QTY := ((V_CUR_REMAIN_QTY + V_PROD_PLAN_TOTAL_QTY) - V_SHIP_PLAN_TOTAL_QTY);
                        END IF;

                        OPEN CUR_BOH_ALLOC_ITEM;
                        LOOP
                            FETCH CUR_BOH_ALLOC_ITEM INTO V_CUR2_DIVISION_ID, V_CUR2_OPERATION_GROOUP, V_CUR2_COMPANY_ID, V_CUR2_PLANT_ID, V_CUR2_PLAN_START_YYYYMMDD, V_CUR2_CELL_ITEM_ID, V_CUR2_ITEM_ID, V_CUR2_YYYYMM, V_CUR2_QTY, V_CUR2_MEASURE, V_CUR2_SEQ_FLAG
                                                        , V_CUR2_VALUE_TYPE, V_CUR2_TO_PRODUCT, V_CUR2_LINE_ID, V_CUR2_TO_SITE, V_CUR2_INCOTERMS;
                            EXIT WHEN CUR_BOH_ALLOC_ITEM%NOTFOUND;

                            IF V_CUR_REMAIN_QTY > V_CUR2_QTY THEN
                                UPDATE GT_PIB_MAIN A SET QTY = 0
                                 WHERE DIVISION_ID = V_CUR2_DIVISION_ID
                                   AND OPERATION_GROUP = V_CUR2_OPERATION_GROOUP
                                   AND COMPANY_ID = V_CUR2_COMPANY_ID
                                   AND PLANT_ID = V_CUR2_PLANT_ID
                                   AND PLAN_START_YYYYMMDD = V_CUR2_PLAN_START_YYYYMMDD
                                   AND CELL_ITEM_ID = V_CUR2_CELL_ITEM_ID
                                   AND ITEM_ID = V_CUR2_ITEM_ID
                                   AND YYYYMM = V_CUR2_YYYYMM
                                   AND MEASURE = V_CUR2_MEASURE
                                   AND SEQ_FLAG = V_CUR2_SEQ_FLAG
                                   AND VALUE_TYPE = V_CUR2_VALUE_TYPE
                                   AND TO_PRODUCT = V_CUR2_TO_PRODUCT
                                   AND LINE_ID = V_CUR2_LINE_ID
                                   AND TO_SITE = V_CUR2_TO_SITE
                                   AND INCOTERMS = V_CUR2_INCOTERMS;

                                V_CUR_REMAIN_QTY := V_CUR_REMAIN_QTY - V_CUR2_QTY;

                            ELSIF V_CUR_REMAIN_QTY <= V_CUR2_QTY THEN
                                UPDATE GT_PIB_MAIN A SET QTY = QTY - V_CUR_REMAIN_QTY
                                 WHERE DIVISION_ID = V_CUR2_DIVISION_ID
                                   AND OPERATION_GROUP = V_CUR2_OPERATION_GROOUP
                                   AND COMPANY_ID = V_CUR2_COMPANY_ID
                                   AND PLANT_ID = V_CUR2_PLANT_ID
                                   AND PLAN_START_YYYYMMDD = V_CUR2_PLAN_START_YYYYMMDD
                                   AND CELL_ITEM_ID = V_CUR2_CELL_ITEM_ID
                                   AND ITEM_ID = V_CUR2_ITEM_ID
                                   AND YYYYMM = V_CUR2_YYYYMM
                                   AND MEASURE = V_CUR2_MEASURE
                                   AND SEQ_FLAG = V_CUR2_SEQ_FLAG
                                   AND VALUE_TYPE = V_CUR2_VALUE_TYPE
                                   AND TO_PRODUCT = V_CUR2_TO_PRODUCT
                                   AND LINE_ID = V_CUR2_LINE_ID
                                   AND TO_SITE = V_CUR2_TO_SITE
                                   AND INCOTERMS = V_CUR2_INCOTERMS;

                                EXIT;  /* set @CUR_REMAIN_QTY = 0 이 됨. */
                            END IF;
                        END LOOP;
                        CLOSE CUR_BOH_ALLOC_ITEM;
                        /* -------------------------------------- */
                        /* PROD_PLAN Cursor : END */
                        /* -------------------------------------- */
                    END IF;
                END LOOP; /* OPEN CUR_BOH_ALLOC */
                CLOSE CUR_BOH_ALLOC;
            END;   /* BOH로 PROD 차감 END */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 4. 셀 반제품 ( N/A : 4.1, 4.2, 4.4) */
            /* 3.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID
                 , A.PLANT_ID
                 , A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'A' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , X.ITEM_ID_ASSY AS ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , A.ITEM_ID AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '430' AS SEQ_FLAG
                 , A.YYYYMM AS YYYYMM
                 , NVL(SUM(NVL(A.QTY,0) / NVL(Y.SCP_FROMATION_YIELD,1)),0) AS QTY
              FROM GT_PIB_MAIN A
                   INNER JOIN (SELECT C.DIVISION_ID, C.ITEM_ID_ASSY, MIN(C.ITEM_ID_PROD) AS ITEM_ID_PROD
                                 FROM SCP_MST_CELL_PROD_ASSY_MAP C
                                      INNER JOIN SCP_MST_FINAL_ITEM F
                                              ON C.DIVISION_ID  = F.DIVISION_ID
                                             AND C.ITEM_ID_PROD = F.ITEM_ID
                                             AND F.ATTRIBUTE8   = 'CP'
                                WHERE C.CELL_TYPE = 'CA1'
                                  AND C.VALID_YN  = 'Y'
                                GROUP BY C.DIVISION_ID, C.ITEM_ID_ASSY) X
                           ON X.DIVISION_ID = A.DIVISION_ID
                          AND X.ITEM_ID_PROD = A.ITEM_ID
                   /* 활성화 수율 가져오기 */
                   LEFT JOIN ( SELECT A.DIVISION_ID, ITEM_ID, X.PLANT_ID
                                     , CASE WHEN NVL(A.SSP_MODIFY_YIELD, -99) = -99 THEN
                                                 CASE WHEN FORMATION_TOTAL_YIELD = 0 THEN 1
                                                      WHEN FORMATION_TOTAL_YIELD > 1 THEN 1
                                                      ELSE NVL(FORMATION_TOTAL_YIELD, 1)
                                                 END
                                            ELSE
                                                 CASE WHEN SSP_MODIFY_YIELD = 0 THEN 1
                                                      WHEN SSP_MODIFY_YIELD > 1 THEN 1
                                                      ELSE NVL(SSP_MODIFY_YIELD, 1)
                                                 END
                                       END AS SCP_FROMATION_YIELD
                                 FROM SCP_MST_FORMATION A
                                      LEFT JOIN SCM_MST_SITE X
                                             ON X.DIVISION_ID = A.DIVISION_ID
                                            AND X.SCM_SITE_ID = A.PLANT_SITE_ID
                                WHERE 1 = 1
                                  AND A.DIVISION_ID = V_DIVISION_ID
                               ) Y
                          ON Y.DIVISION_ID = A.DIVISION_ID
                         AND Y.PLANT_ID = A.PLANT_ID
                         AND Y.ITEM_ID = X.ITEM_ID_ASSY
             WHERE A.SEQ_FLAG = '350'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , A.PLANT_ID
                    , A.PLAN_START_YYYYMMDD
                    , X.ITEM_ID_ASSY
                    , A.ITEM_ID
                    , A.YYYYMM;

            V_STATUS_DESC := '0.  MKT_FCST EE';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /* 1.Ship. Plan(RTF) */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '1.Ship. Plan(RTF) EE';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /* 2.Ship. Plan(Semi) */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '2.Ship. Plan(Semi) EE';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /* 3.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING  EE';

            /* 원본: select ... into #tmp_YIELD_VER_H_V_A ...  create index i_tmp_YIELD_VER_H_V_A_01 → GTT(IX_PIB_YIELD_A_01) 선반영 */
            DELETE FROM GT_PIB_YIELD_A;
            INSERT INTO GT_PIB_YIELD_A
            SELECT Y.OPERATION_GROUP, A.VERSION_ID, A.DIVISION_ID, A.COMPANY_ID, A.SITE_ID, A.PLANT_ID, A.FACTORY_ID, A.PLANT_SITE_ID, A.ITEM_ID, A.OPERATION_ID, A.LINE_ID, A.MONTH, A.YIELD
              FROM SCM_MST_YIELD_VER_H_V A
                   INNER JOIN (    SELECT DISTINCT SEGMENT4 AS OPERATION_ID, SEGMENT5 AS OPERATION_GROUP
                                     FROM SCM_ADM_LOOKUP_MASTER_DETAIL B
                                    WHERE B.LOOKUP_TYPE = 'LOCATION_GROUP_ROUTE'
                                      AND B.VALID_YN = 'Y'
                                      AND B.SEGMENT3 = 'Y'
                                      AND B.SEGMENT5 = 'A' ) Y
                          ON A.OPERATION_ID = Y.OPERATION_ID
             WHERE 1 = 1
               AND A.DIVISION_ID = V_DIVISION_ID;

            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT A.DIVISION_ID
                 , A.COMPANY_ID,
/* substring(a.plant_id,1, len(a.plant_id)-1) + convert(nvarchar(1),convert(int, right(a.plant_id,1)) + 1) as plant_id,  -- 전극 Plant  -- 아래로 대체. */
/* 1,2,3순위 조건 추가(2024.12.31) start */
                   /* 2025.02.12 변경전 (case  when exists (select 'y' */
                   /* 2025.02.12 변경전 		            from scm_mst_site x with(nolock) */
                   /* 2025.02.12 변경전 				    where x.site_type = 'PLANT' */
                   /* 2025.02.12 변경전 					and x.valid_yn = 'Y' */
                   /* 2025.02.12 변경전 					and x.company_id = a.company_id */
                   /* 2025.02.12 변경전 					and x.division_id = a.division_id */
                   /* 2025.02.12 변경전 					and x.plant_id = a.plant_id */
                   /* 2025.02.12 변경전 					and x.operation_group = 'E')  then	(select top 1 plant_id */
                   /* 2025.02.12 변경전 														 from scm_mst_site k with(nolock) */
                   /* 2025.02.12 변경전 														 where k.site_type = 'PLANT' */
                   /* 2025.02.12 변경전 														 and k.valid_yn = 'Y' */
                   /* 2025.02.12 변경전 														 and k.company_id = a.company_id */
                   /* 2025.02.12 변경전 														 and k.division_id = a.division_id */
                   /* 2025.02.12 변경전 														 and k.plant_id = a.plant_id */
                   /* 2025.02.12 변경전 														 and k.operation_group = 'E' ) */
                   /* 2025.02.12 변경전 		when exists (select 'y' */
                   /* 2025.02.12 변경전 		             from scm_mst_site x with(nolock) */
                   /* 2025.02.12 변경전 				     where x.site_type = 'PLANT' */
                   /* 2025.02.12 변경전 					 and x.valid_yn = 'Y' */
                   /* 2025.02.12 변경전 					 and x.company_id = a.company_id */
                   /* 2025.02.12 변경전 					 and x.division_id = a.division_id */
                   /* 2025.02.12 변경전 					 and x.operation_group = 'E')  then	(select top 1 plant_id */
                   /* 2025.02.12 변경전 														 from scm_mst_site k with(nolock) */
                   /* 2025.02.12 변경전 														 where k.site_type = 'PLANT' */
                   /* 2025.02.12 변경전 														 and k.valid_yn = 'Y' */
                   /* 2025.02.12 변경전 														 and k.company_id = a.company_id */
                   /* 2025.02.12 변경전 														 and k.division_id = a.division_id */
                   /* 2025.02.12 변경전 														 and k.operation_group = 'E' ) */
                   (CASE WHEN EP.PLANT_ID_ES IS NOT NULL THEN EP.PLANT_ID_ES   /* - 2025.02.14 전극 plant 매핑 로직 수정 */
                         ELSE
                                                        (SELECT PLANT_ID FROM (
                                                             SELECT PLANT_ID
                                                               FROM SCM_MST_SITE K
                                                              WHERE K.SITE_TYPE = 'PLANT'
                                                                AND K.VALID_YN = 'Y'
                                                                AND K.COMPANY_ID = A.COMPANY_ID
                                                                AND K.OPERATION_GROUP = 'E' )
                                                         WHERE ROWNUM = 1)
                    END) AS PLANT_ID,  /* 전극 Plant */
/* 1,2,3순위 조건 추가(2024.12.31) end */
                   A.PLAN_START_YYYYMMDD
                 , 1 AS SEQ
                 , 'E' AS OPERATION_GROUP
                 , '-' AS FROM_SITE
                 , '-' AS CELL_ITEM_ID
                 , B.CHILD_ITEM_ID AS ITEM_ID
                 , 'IN_HOUSE_MOVING' AS MEASURE
                 , '-' AS VALUE_TYPE
                 , '-' AS TO_PRODUCT
                 , '-' AS LINE_ID
                 , 0 AS BOH_QTY
                 , A.PLANT_ID AS TO_SITE
                 , '-' AS INCOTERMS
                 , '530' AS SEQ_FLAG
                 , A.YYYYMM
                 , NVL(SUM(A.QTY * NVL(B.USAGE,1) / NVL(Y.YIELD,1)),0) AS QTY
              FROM GT_PIB_MAIN A
                   INNER JOIN SCP_MST_BOM_ELEC B
                           ON B.DIVISION_ID = V_DIVISION_ID
                          AND B.PARENT_ITEM_ID = A.ITEM_ID
                          AND B.SCP_YN = 'Y'
                   /* pack/cell 수율 반영 start */
                   LEFT JOIN GT_PIB_YIELD_A Y
                          ON Y.DIVISION_ID = A.DIVISION_ID
                         AND Y.OPERATION_GROUP = A.OPERATION_GROUP
                         AND Y.COMPANY_ID = A.COMPANY_ID
                         AND Y.LINE_ID = A.LINE_ID
                         AND Y.MONTH = A.YYYYMM
                         AND Y.ITEM_ID = A.ITEM_ID
                   LEFT JOIN GT_PIB_CELL_ELEC_MAP EP   /* 2025.02.12 cell/전극 plant 매핑 로직 수정 (2순위 적용) */
                          ON EP.CELL_PLANT_PRIORITY = 1
                         AND EP.DIVISION_ID_CS = A.DIVISION_ID
                         AND EP.COMPANY_ID_CS  = A.COMPANY_ID
                         AND EP.PLANT_ID_CS    = A.PLANT_ID
             WHERE A.SEQ_FLAG = '450'
             GROUP BY A.DIVISION_ID
                    , A.COMPANY_ID
                    , SUBSTR(A.PLANT_ID,1, LENGTH(A.PLANT_ID)-1) || TO_CHAR(TO_NUMBER(SUBSTR(A.PLANT_ID,-1,1)) + 1),
                      EP.PLANT_ID_ES,  /* 2025.02.12 전극 plant 매핑 로직 수정 */
                      A.PLAN_START_YYYYMMDD
                    , B.CHILD_ITEM_ID
                    , A.PLANT_ID
                    , A.YYYYMM;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 5. 전극 ( N/A : 없음) */
            /* 5.PROD_PLAN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN  EE';

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 9.1  CELL_ITEM_ID UPDATE */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'CELL_ITEM_ID Pack';

            /* 원본: select model_id, child_item_id into #tmp_FINAL_ITEM_BOM_V ...  create index → GTT(IX_PIB_ITEM_BOM_01) 선반영 */
            DELETE FROM GT_PIB_ITEM_BOM;
            INSERT INTO GT_PIB_ITEM_BOM
            SELECT MODEL_ID, CHILD_ITEM_ID
              FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Y
             WHERE Y.CELL_TYPE          = 'CP'
               AND Y.OPERATION_GROUP_ID = 'A'
               AND Y.DIVISION_ID        = V_DIVISION_ID;  /* 3742 */

            /* PACK 일경우 */
            /* CELL_ITEM_ID 적용 */
            UPDATE GT_PIB_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT Y.CHILD_ITEM_ID
                                            FROM GT_PIB_ITEM_BOM Y
                                           WHERE Y.MODEL_ID = X.ITEM_ID
                                             AND ROWNUM = 1),'-')
             WHERE X.OPERATION_GROUP = 'P'
               AND SUBSTR(X.SEQ_FLAG,1,1) <> '5'  /* 전극 제외 */
               AND NVL(X.CELL_ITEM_ID,'-') < '0';

            /* 상위 모델 이용하여 CELL_ITEM_ID 적용 */
            UPDATE GT_PIB_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT Y.CHILD_ITEM_ID
                                            FROM GT_PIB_ITEM_BOM Y
                                           WHERE Y.MODEL_ID = ( SELECT Y2.MODEL_ID
                                                                  FROM SCM_MST_MODEL_ONE_LEVEL_BOM_V Y2
                                                                 WHERE Y2.DIVISION_ID   = X.DIVISION_ID
                                                                   AND Y2.CHILD_ITEM_ID = X.ITEM_ID
                                                                   AND Y2.PLANT_ID      = X.PLANT_ID
                                                                   AND ROWNUM = 1)
                                             AND ROWNUM = 1),'-')
             WHERE X.OPERATION_GROUP = 'P'
               AND SUBSTR(X.SEQ_FLAG,1,1) <> '5'
               AND NVL(X.CELL_ITEM_ID,'-') < '0';

            V_STATUS_DESC := 'CELL_ITEM_ID Cell';

            /* CELL 일경우 -- 2023.06.08 활성화코드 분리 대응 - 변경후 쿼리 */
            /* 원본 WITH CP_INFO AS(...) UPDATE X ... FROM X INNER JOIN F LEFT JOIN CP_INFO C1/C2/C3 */
            /* → 상관 UPDATE. F 매칭(INNER)이라 EXISTS 가드, CP_INFO 는 인라인뷰 3회. */
            UPDATE GT_PIB_MAIN X
               SET X.CELL_ITEM_ID = NVL((
                    SELECT CASE WHEN F.CELL_TYPE LIKE 'CA%'
                                THEN NVL(NVL(NVL(C1.ITEM_ID_PROD, C2.ITEM_ID_PROD), C3.ITEM_ID_PROD), X.ITEM_ID)
                                ELSE X.ITEM_ID
                           END
                      FROM SCP_MST_FINAL_ITEM_V F
                           LEFT JOIN ( SELECT M.DIVISION_ID, M.PLANT_ID, M.ITEM_ID_ASSY, M.ITEM_ID_PROD
                                            , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY, M.PLANT_ID
                                                                     ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_1ST
                                         FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                        WHERE M.VALID_YN = 'Y' ) C1
                                  ON C1.DIVISION_ID   = X.DIVISION_ID
                                 AND C1.PLANT_ID      = X.PLANT_ID
                                 AND C1.ITEM_ID_ASSY  = X.ITEM_ID
                                 AND C1.PRIORITY_1ST  = 1
                           LEFT JOIN ( SELECT M.DIVISION_ID, M.ITEM_ID_ASSY, M.ITEM_ID_PROD
                                            , ROW_NUMBER() OVER (PARTITION BY M.DIVISION_ID, M.ITEM_ID_ASSY
                                                                     ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_2ND
                                         FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                        WHERE M.VALID_YN = 'Y' ) C2
                                  ON C2.DIVISION_ID   = X.DIVISION_ID
                                 AND C2.ITEM_ID_ASSY  = X.ITEM_ID
                                 AND C2.PRIORITY_2ND  = 1
                           LEFT JOIN ( SELECT M.ITEM_ID_ASSY, M.ITEM_ID_PROD
                                            , ROW_NUMBER() OVER (PARTITION BY M.ITEM_ID_ASSY
                                                                     ORDER BY M.VALID_YN DESC, M.ITEM_ID_PROD) PRIORITY_3RD
                                         FROM SCP_MST_CELL_PROD_ASSY_MAP M
                                        WHERE M.VALID_YN = 'Y' ) C3
                                  ON C3.ITEM_ID_ASSY  = X.ITEM_ID
                                 AND C3.PRIORITY_3RD  = 1
                     WHERE F.ITEM_ID = X.ITEM_ID
                       AND ROWNUM = 1 ),'-')
             WHERE 0 = 0
               AND X.OPERATION_GROUP = 'A'
               AND SUBSTR(X.SEQ_FLAG,1,1) <> '5'
               AND NVL(X.CELL_ITEM_ID,'-') < '0'
               AND EXISTS ( SELECT 1 FROM SCP_MST_FINAL_ITEM_V F WHERE F.ITEM_ID = X.ITEM_ID );

            V_STATUS_DESC := 'CELL_ITEM_ID MEB';

            /* -------------------------------------------------- */
            /* PJ20214997 LGES SCP 신규 Biz, 공정 추가에 따른 모델링 개선 - MEB biz. 적용 - CELL_ITEM_ID update - start */
            /* -------------------------------------------------- */
            /* 원본 UPDATE X ... FROM X INNER JOIN (Z) ON X.ITEM_ID=Z.MODULE_ID → 상관 UPDATE + EXISTS */
            UPDATE GT_PIB_MAIN X
               SET X.CELL_ITEM_ID = NVL(( SELECT MAX(Z.CELL_ITEM_ID)
                                            FROM (SELECT DISTINCT Z.MODEL_ID AS ITEM_ID, Z.CHILD_ITEM_ID AS CELL_ITEM_ID, Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK, Y.MODULE_ID, Y.MODULE_QTY_PACK
                                                    FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                                                       , ( SELECT X2.DIVISION_ID, X2.MODEL_ID, X2.CHILD_ITEM_ID AS MODULE_ID, X2.CHILD_QTY AS MODULE_QTY_PACK
                                                             FROM SCM_MST_BOM_SN_V X2   /* 2021-03-09	SCP 대치 BOM 적용 */
                                                                  INNER JOIN SCM_MST_ITEM_SN I
                                                                          ON X2.CHILD_DIVISION_ID = I.DIVISION_ID
                                                                         AND X2.CHILD_ITEM_ID     = I.ITEM_ID
                                                                         AND I.FLOW_ID = 'P5200'
                                                                         AND X2.CHILD_COMPANY_ID  = I.COMPANY_ID /* A002 빈강 추가 따른 조건 추가 */
                                                                         AND X2.CHILD_SITE_ID     = I.SITE_ID
                                                                         AND I.ACTIVE_FLAG        = 'Y'
                                                                         AND X2.DIVISION_ID       = P_DIVISION_ID /* CSR E20250829-001508 로직 속도개선 */
                                                            WHERE 1 = 1
                                                         ) Y
                                                   WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                                                     AND Z.MODEL_ID           = Y.MODEL_ID
                                                     AND Z.CELL_TYPE          = 'CP' /* 2023.06.08 활성화코드 분리 대응(Cell Product 조건 추가) */
                                                     AND Z.OPERATION_GROUP_ID = 'A'
                                                     AND Z.DIVISION_ID        = P_DIVISION_ID /* CSR E20250829-001508 로직 속도개선 */
                                                 ) Z
                                           WHERE Z.MODULE_ID = X.ITEM_ID ),'-')
             WHERE X.ATTRIBUTE9 = 'P5200'
               AND SUBSTR(X.SEQ_FLAG,1,1) <> '5'
               AND NVL(X.CELL_ITEM_ID,'-') < '0'
               AND EXISTS ( SELECT 1
                              FROM (SELECT DISTINCT Z.MODEL_ID AS ITEM_ID, Z.CHILD_ITEM_ID AS CELL_ITEM_ID, Z.ACCUMULATED_CHILD_QTY AS CELL_QTY_PACK, Y.MODULE_ID, Y.MODULE_QTY_PACK
                                       FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V Z
                                          , ( SELECT X2.DIVISION_ID, X2.MODEL_ID, X2.CHILD_ITEM_ID AS MODULE_ID, X2.CHILD_QTY AS MODULE_QTY_PACK
                                                FROM SCM_MST_BOM_SN_V X2
                                                     INNER JOIN SCM_MST_ITEM_SN I
                                                             ON X2.CHILD_DIVISION_ID = I.DIVISION_ID
                                                            AND X2.CHILD_ITEM_ID     = I.ITEM_ID
                                                            AND I.FLOW_ID = 'P5200'
                                                            AND X2.CHILD_COMPANY_ID  = I.COMPANY_ID
                                                            AND X2.CHILD_SITE_ID     = I.SITE_ID
                                                            AND I.ACTIVE_FLAG        = 'Y'
                                                            AND X2.DIVISION_ID       = P_DIVISION_ID
                                               WHERE 1 = 1
                                            ) Y
                                      WHERE Z.DIVISION_ID        = Y.DIVISION_ID
                                        AND Z.MODEL_ID           = Y.MODEL_ID
                                        AND Z.CELL_TYPE          = 'CP'
                                        AND Z.OPERATION_GROUP_ID = 'A'
                                        AND Z.DIVISION_ID        = P_DIVISION_ID
                                    ) Z
                             WHERE Z.MODULE_ID = X.ITEM_ID );

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4) */
            /* 3.IN_HOUSE_MOVING */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '3.IN_HOUSE_MOVING 222';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT  I.DIVISION_ID
                  , I.COMPANY_ID
                  , I.PLANT_ID
                  , I.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'P' AS OPERATION_GROUP
                  , '-' AS FROM_SITE
                  , I.CELL_ITEM_ID AS CELL_ITEM_ID
                  , A.CHILD_ITEM_ID AS ITEM_ID
                  , I.MEASURE
                  , '-' AS VALUE_TYPE
                  , '-' AS TO_PRODUCT
                  , I.LINE_ID
                  , 0 AS BOH_QTY
                  , I.TO_SITE
                  , '-' AS INCOTERMS
                  , '250' AS SEQ_FLAG
                  , I.YYYYMM
                  , NVL(SUM(NVL(I.QTY,0) * NVL(A.ACCUMULATED_CHILD_QTY,1) ),0) AS QTY
              FROM GT_PIB_MAIN I
                   LEFT JOIN SCM_MST_BOM_EFFECTIVE_SN_V A
                          ON A.MODEL_ID = I.ITEM_ID
                         AND A.PARENT_ITEM_ID = I.ITEM_ID
                         AND A.DIVISION_ID = I.DIVISION_ID
                         AND A.COMPANY_ID = I.COMPANY_ID
                         AND A.PLANT_ID = I.PLANT_ID
                         AND I.PLAN_START_YYYYMMDD BETWEEN A.EFF_START_DATE AND A.EFF_END_DATE
                         AND (A.ALT_ID IS NULL
                             OR (A.ALT_ID IS NOT NULL AND A.SCP_PLAN_YN IS NULL AND NVL(A.ALT_PRIORITY, '1') = 'Y')
                             OR (A.ALT_ID IS NOT NULL AND A.SCP_PLAN_YN IS NOT NULL AND A.SCP_PLAN_YN = 'Y'))
                   INNER JOIN SCM_MST_ITEM_SN B
                          ON A.DIVISION_ID = B.DIVISION_ID
                         AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.CHILD_ITEM_ID = B.ITEM_ID
                         AND NVL(B.SCP_FLOW_ID, B.FLOW_ID) = 'P5000'
             WHERE I.SEQ_FLAG IN ('150')
             GROUP BY I.DIVISION_ID
                    , I.COMPANY_ID
                    , I.PLANT_ID
                    , I.PLAN_START_YYYYMMDD
                    , I.CELL_ITEM_ID
                    , A.CHILD_ITEM_ID
                    , I.MEASURE
                    , I.LINE_ID
                    , I.TO_SITE
                    , I.YYYYMM;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 2. 팩/모듈 반제품 ( N/A : 2.1, 2.2, 2.4) */
            /* 5.PROD_PLAN */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := '5.PROD_PLAN 222';
            INSERT INTO GT_PIB_MAIN
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT  I.DIVISION_ID
                  , I.COMPANY_ID
                  , I.PLANT_ID
                  , I.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'P' AS OPERATION_GROUP
                  , '-' AS FROM_SITE
                  , I.CELL_ITEM_ID AS CELL_ITEM_ID
                  , A.CHILD_ITEM_ID AS ITEM_ID
                  , 'IN_HOUSE_MOVING' AS MEASURE
                  , '-' AS VALUE_TYPE
                  , I.ITEM_ID AS TO_PRODUCT
                  , '-' AS LINE_ID
                  , 0 AS BOH_QTY
                  , I.PLANT_ID AS TO_SITE,
                    '-' AS INCOTERMS,  /* - 250에서 '-' 를 넣었으므로 모두 '-' 임. */
                    '230' AS SEQ_FLAG
                  , I.YYYYMM
                  , NVL(SUM(NVL(I.QTY,0) * NVL(A.ACCUMULATED_CHILD_QTY,1) ),0) AS QTY
              FROM GT_PIB_MAIN I
                   LEFT JOIN SCM_MST_BOM_EFFECTIVE_SN_V A
                          ON A.MODEL_ID = I.ITEM_ID
                         AND A.PARENT_ITEM_ID = I.ITEM_ID
                         AND A.DIVISION_ID = I.DIVISION_ID
                         AND A.COMPANY_ID = I.COMPANY_ID
                         AND A.PLANT_ID = I.PLANT_ID
                         AND I.PLAN_START_YYYYMMDD BETWEEN A.EFF_START_DATE AND A.EFF_END_DATE
                         AND (A.ALT_ID IS NULL
                             OR (A.ALT_ID IS NOT NULL AND A.SCP_PLAN_YN IS NULL AND NVL(A.ALT_PRIORITY, '1') = 'Y')
                             OR (A.ALT_ID IS NOT NULL AND A.SCP_PLAN_YN IS NOT NULL AND A.SCP_PLAN_YN = 'Y'))
                   INNER JOIN SCM_MST_ITEM_SN B
                          ON A.DIVISION_ID = B.DIVISION_ID
                         AND A.COMPANY_ID = B.COMPANY_ID
                         AND A.CHILD_ITEM_ID = B.ITEM_ID
                         AND NVL(B.SCP_FLOW_ID, B.FLOW_ID) = 'P5000'
             WHERE I.SEQ_FLAG IN ('150')
             GROUP BY I.DIVISION_ID
                    , I.COMPANY_ID
                    , I.PLANT_ID
                    , I.PLAN_START_YYYYMMDD
                    , I.CELL_ITEM_ID
                    , A.CHILD_ITEM_ID
                    , I.ITEM_ID
                    , I.YYYYMM;

/* multi_child_item 반영 start */
/* multi_child_item : 250 */
            INSERT INTO GT_PIB_230_250
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT  I.DIVISION_ID
                  , I.COMPANY_ID
                  , I.PLANT_ID
                  , I.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'P' AS OPERATION_GROUP
                  , '-' AS FROM_SITE
                  , A.CHILD_ITEM_ID AS CELL_ITEM_ID
                  , LM.SEGMENT2 AS ITEM_ID
                  , I.MEASURE
                  , '-' AS VALUE_TYPE
                  , '-' AS TO_PRODUCT
                  , I.LINE_ID
                  , 0 AS BOH_QTY
                  , I.TO_SITE
                  , '-' AS INCOTERMS
                  , '250' AS SEQ_FLAG
                  , I.YYYYMM
                  , 0 AS QTY
              FROM GT_PIB_MAIN I
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
                          ON LM.LOOKUP_TYPE = 'MULTI_CHILD_ITEM'
                         AND LM.SEGMENT1 = I.ITEM_ID
                         AND LM.VALID_YN = 'Y'
                   INNER JOIN SCM_MST_BOM_EFFECTIVE_SN_V A
                          ON A.PARENT_ITEM_ID = LM.SEGMENT2  /* 'AMDAU0629B' */
                         AND A.MODEL_ID = LM.SEGMENT1  /* 'AMRSAEV20-B2' */
                         AND A.PLANT_ID = I.PLANT_ID  /* 'G481' */
                         AND A.DIVISION_ID = I.DIVISION_ID /* '81' */
                         AND A.COMPANY_ID = I.COMPANY_ID  /* 'G480' */
                   INNER JOIN SCP_MST_FINAL_ITEM B
                          ON B.DIVISION_ID = I.DIVISION_ID  /* '81' */
                         AND B.ITEM_ID = A.CHILD_ITEM_ID /* 'ACEN4060I-A1-401' */
                         AND B.ATTRIBUTE8 = 'CP'
                         AND B.OPERATION_GROUP = 'A'
             WHERE I.SEQ_FLAG = '150'
             GROUP BY I.DIVISION_ID
                    , I.COMPANY_ID
                    , I.PLANT_ID
                    , I.PLAN_START_YYYYMMDD
                    , A.CHILD_ITEM_ID
                    , LM.SEGMENT2
                    , I.MEASURE
                    , I.LINE_ID
                    , I.TO_SITE
                    , I.YYYYMM;

            /* multi_child_item : 230 */
            INSERT INTO GT_PIB_230_250
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT  I.DIVISION_ID
                  , I.COMPANY_ID
                  , I.PLANT_ID
                  , I.PLAN_START_YYYYMMDD
                  , 1 AS SEQ
                  , 'P' AS OPERATION_GROUP
                  , '-' AS FROM_SITE
                  , A.CHILD_ITEM_ID AS CELL_ITEM_ID
                  , LM.SEGMENT2 AS ITEM_ID
                  , 'IN_HOUSE_MOVING' AS MEASURE
                  , '-' AS VALUE_TYPE
                  , I.ITEM_ID AS TO_PRODUCT
                  , '-' AS LINE_ID
                  , 0 AS BOH_QTY
                  , I.PLANT_ID AS TO_SITE,
                    '-' AS INCOTERMS,  /* - 250에서 '-' 를 넣었으므로 모두 '-' 임. */
                    '230' AS SEQ_FLAG
                  , I.YYYYMM
                  , 0 AS QTY
              FROM GT_PIB_MAIN I
                   INNER JOIN SCM_ADM_LOOKUP_MASTER_DETAIL LM
                          ON LM.LOOKUP_TYPE = 'MULTI_CHILD_ITEM'
                         AND LM.SEGMENT1 = I.ITEM_ID
                         AND LM.VALID_YN = 'Y'
                   INNER JOIN SCM_MST_BOM_EFFECTIVE_SN_V A
                          ON A.PARENT_ITEM_ID = LM.SEGMENT2  /* 'AMDAU0629B' */
                         AND A.MODEL_ID = LM.SEGMENT1  /* 'AMRSAEV20-B2' */
                         AND A.PLANT_ID = I.PLANT_ID  /* 'G481' */
                         AND A.DIVISION_ID = I.DIVISION_ID /* '81' */
                         AND A.COMPANY_ID = I.COMPANY_ID  /* 'G480' */
                   INNER JOIN SCP_MST_FINAL_ITEM B
                          ON B.DIVISION_ID = I.DIVISION_ID  /* '81' */
                         AND B.ITEM_ID = A.CHILD_ITEM_ID /* 'ACEN4060I-A1-401' */
                         AND B.ATTRIBUTE8 = 'CP'
                         AND B.OPERATION_GROUP = 'A'
             WHERE I.SEQ_FLAG IN ('150')
             GROUP BY I.DIVISION_ID
                    , I.COMPANY_ID
                    , I.PLANT_ID
                    , I.PLAN_START_YYYYMMDD
                    , A.CHILD_ITEM_ID,
                      LM.SEGMENT2,  /* a.child_item_id, */
                      I.ITEM_ID
                    , I.YYYYMM;

            INSERT INTO GT_PIB_MAIN
            SELECT A.*
              FROM GT_PIB_230_250 A
             WHERE NOT EXISTS ( SELECT 1
                                  FROM GT_PIB_MAIN B
                                 WHERE B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                   AND B.SEQ = A.SEQ
                                   AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                   AND B.COMPANY_ID = A.COMPANY_ID
                                   AND B.PLANT_ID = A.PLANT_ID
                                   AND B.DIVISION_ID = A.DIVISION_ID
                                   AND B.FROM_SITE = A.FROM_SITE
                                   AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                   AND B.ITEM_ID = A.ITEM_ID
                                   AND B.MEASURE = A.MEASURE
                                   AND B.VALUE_TYPE = A.VALUE_TYPE
                                   AND B.TO_PRODUCT = A.TO_PRODUCT
                                   AND B.LINE_ID = A.LINE_ID
                                   AND B.TO_SITE = A.TO_SITE
                                   AND B.INCOTERMS = A.INCOTERMS
                                   AND B.YYYYMM = A.YYYYMM );
/* multi_child_item 반영 end */

/* 260boh차감, 260차감, #차감260 START */
/* === 260 boh 차감 start */
/* '260' BOH로 '250' PROD 차감 START */
/* ------------------------------------------ */
/* 셀 제품의 BOH로 셀 제품의 PROD_PLAN 차감. */
/* ------------------------------------------ */
            BEGIN
                OPEN CUR_260_BOH_ALLOC;
                LOOP
                    FETCH CUR_260_BOH_ALLOC INTO V_CUR1ST_SEQ_FLAG, V_CUR1ST_DIVISION_ID, V_CUR1ST_OPERATION_GROOUP, V_CUR1ST_COMPANY_ID, V_CUR1ST_PLANT_ID, V_CUR1ST_PLAN_START_YYYYMMDD, V_CUR1ST_CELL_ITEM_ID, V_CUR1ST_ITEM_ID, V_CUR1ST_BOH_QTY, V_CUR1ST_REMAIN_QTY;
                    EXIT WHEN CUR_260_BOH_ALLOC%NOTFOUND;

/* - 최소월 찾기 START --- */
                    SELECT MIN(YYYYMM)
                      INTO V_CUR2ND_MIN_MONTH
                      FROM GT_PIB_MAIN
                     WHERE DIVISION_ID = V_CUR1ST_DIVISION_ID
                       AND OPERATION_GROUP = V_CUR1ST_OPERATION_GROOUP
                       AND COMPANY_ID = V_CUR1ST_COMPANY_ID
                       AND PLANT_ID = V_CUR1ST_PLANT_ID
                       AND PLAN_START_YYYYMMDD = V_CUR1ST_PLAN_START_YYYYMMDD
                       AND CELL_ITEM_ID = V_CUR1ST_CELL_ITEM_ID
                       AND ITEM_ID = V_CUR1ST_ITEM_ID
                       AND MEASURE = 'PROD_PLAN'
                       AND SEQ_FLAG = '250'
                       AND QTY > 0;
/* - 최소월 찾기 END --- */

                    /* PROD_PLAN Cursor */
                    OPEN CUR_260_BOH_ALLOC_ITEM;
                    LOOP
                        FETCH CUR_260_BOH_ALLOC_ITEM INTO V_CUR2ND_DIVISION_ID, V_CUR2ND_OPERATION_GROOUP, V_CUR2ND_COMPANY_ID, V_CUR2ND_PLANT_ID, V_CUR2ND_PLAN_START_YYYYMMDD, V_CUR2ND_CELL_ITEM_ID, V_CUR2ND_ITEM_ID, V_CUR2ND_YYYYMM, V_CUR2ND_QTY, V_CUR2ND_MEASURE, V_CUR2ND_SEQ_FLAG
                                                           , V_CUR2ND_VALUE_TYPE, V_CUR2ND_TO_PRODUCT, V_CUR2ND_LINE_ID, V_CUR2ND_TO_SITE, V_CUR2ND_INCOTERMS;
                        EXIT WHEN CUR_260_BOH_ALLOC_ITEM%NOTFOUND;

                        IF V_CUR1ST_REMAIN_QTY > V_CUR2ND_QTY THEN
                            UPDATE GT_PIB_MAIN A SET QTY = 0
                             WHERE DIVISION_ID = V_CUR2ND_DIVISION_ID
                               AND OPERATION_GROUP = V_CUR2ND_OPERATION_GROOUP
                               AND COMPANY_ID = V_CUR2ND_COMPANY_ID
                               AND PLANT_ID = V_CUR2ND_PLANT_ID
                               AND PLAN_START_YYYYMMDD = V_CUR2ND_PLAN_START_YYYYMMDD
                               AND CELL_ITEM_ID = V_CUR2ND_CELL_ITEM_ID
                               AND ITEM_ID = V_CUR2ND_ITEM_ID
                               AND YYYYMM = V_CUR2ND_YYYYMM
                               AND MEASURE = V_CUR2ND_MEASURE
                               AND SEQ_FLAG = V_CUR2ND_SEQ_FLAG
                               AND VALUE_TYPE = V_CUR2ND_VALUE_TYPE
                               AND TO_PRODUCT = V_CUR2ND_TO_PRODUCT
                               AND LINE_ID = V_CUR2ND_LINE_ID
                               AND TO_SITE = V_CUR2ND_TO_SITE
                               AND INCOTERMS = V_CUR2ND_INCOTERMS;

                            V_CUR1ST_REMAIN_QTY := V_CUR1ST_REMAIN_QTY - V_CUR2ND_QTY;

                        ELSIF V_CUR1ST_REMAIN_QTY <= V_CUR2ND_QTY THEN
                            UPDATE GT_PIB_MAIN A SET QTY = QTY - V_CUR1ST_REMAIN_QTY
                             WHERE DIVISION_ID = V_CUR2ND_DIVISION_ID
                               AND OPERATION_GROUP = V_CUR2ND_OPERATION_GROOUP
                               AND COMPANY_ID = V_CUR2ND_COMPANY_ID
                               AND PLANT_ID = V_CUR2ND_PLANT_ID
                               AND PLAN_START_YYYYMMDD = V_CUR2ND_PLAN_START_YYYYMMDD
                               AND CELL_ITEM_ID = V_CUR2ND_CELL_ITEM_ID
                               AND ITEM_ID = V_CUR2ND_ITEM_ID
                               AND YYYYMM = V_CUR2ND_YYYYMM
                               AND MEASURE = V_CUR2ND_MEASURE
                               AND SEQ_FLAG = V_CUR2ND_SEQ_FLAG
                               AND VALUE_TYPE = V_CUR2ND_VALUE_TYPE
                               AND TO_PRODUCT = V_CUR2ND_TO_PRODUCT
                               AND LINE_ID = V_CUR2ND_LINE_ID
                               AND TO_SITE = V_CUR2ND_TO_SITE
                               AND INCOTERMS = V_CUR2ND_INCOTERMS;

                            V_CUR1ST_REMAIN_QTY := 0;
                            EXIT;  /* set @CUR1st_REMAIN_QTY = 0 이 됨. */
                        END IF;
                    END LOOP;
                    CLOSE CUR_260_BOH_ALLOC_ITEM;
                    /* -------------------------------------- */
                    /* PROD_PLAN Cursor : END */
                    /* -------------------------------------- */

/* =========== in-house-moving 대상 찾기 start */
                    IF ( V_CUR1ST_BOH_QTY <> V_CUR1ST_REMAIN_QTY ) THEN

                        /* 1. child_item 수량 가져오기 (150의 item_id 를 가져오는 부분. 원본 isnull(to_product,'') → '' = NULL 이라 직접참조) */
                        SELECT ( SELECT TO_PRODUCT FROM (
                                     SELECT TO_PRODUCT
                                       FROM GT_PIB_MAIN
                                      WHERE ITEM_ID = V_CUR1ST_ITEM_ID /* 'AMDAU0032A' */
                                        AND DIVISION_ID = V_CUR1ST_DIVISION_ID /* '81' */
                                        AND PLAN_START_YYYYMMDD = V_CUR1ST_PLAN_START_YYYYMMDD /* '20240722' */
                                        AND COMPANY_ID = V_CUR1ST_COMPANY_ID  /* 'C100' */
                                        AND PLANT_ID = V_CUR1ST_PLANT_ID  /* 'a040' */
                                        AND YYYYMM = SUBSTR(V_PLAN_START_YYYYMMDD,1,6)   /* '202407' */
                                        AND SEQ_FLAG = '230' )
                                  WHERE ROWNUM = 1 )
                          INTO V_260BOH_MODEL_ITEM_ID
                          FROM DUAL;

                        /* 2. child_item_id 찾기 (330의 child_item 찾기) */
                        SELECT ( SELECT CHILD_ITEM_ID FROM (
                                     SELECT A.CHILD_ITEM_ID
                                       FROM SCM_MST_MODEL_FINAL_ITEM_BOM_V A
                                            INNER JOIN SCP_MST_FINAL_ITEM B
                                                    ON B.ITEM_ID = A.CHILD_ITEM_ID
                                                   AND B.DIVISION_ID = A.DIVISION_ID
                                                   AND B.OPERATION_GROUP_ID = 'A'
                                                   AND B.ATTRIBUTE8 = 'CP'
                                      WHERE A.DIVISION_ID = V_CUR1ST_DIVISION_ID /* '81' */
                                        AND A.PLANT_ID = V_CUR1ST_PLANT_ID  /* 'a040' */
                                        AND A.MODEL_ID = V_260BOH_MODEL_ITEM_ID  /* 'APRSAL38L-A2'  --a.item_id */
                                        AND V_PLAN_START_YYYYMMDD BETWEEN A.EFF_START_DATE AND A.EFF_END_DATE )
                                  WHERE ROWNUM = 1 )
                          INTO V_260BOH_CHILD_ITEM_ID
                          FROM DUAL;

                        /* 3. 수율을 가져오기 */
                        SELECT NVL(( SELECT YIELD FROM (
                                         SELECT NVL(YIELD,1) AS YIELD
                                           FROM GT_PIB_330_YIELD
                                          WHERE ITEM_ID = V_260BOH_MODEL_ITEM_ID  /* 'APRSAL38L-A2' */
                                            AND DIVISION_ID = V_CUR1ST_DIVISION_ID /* '81' */
                                            AND COMPANY_ID = V_CUR1ST_COMPANY_ID  /* 'C100' */
                                            AND PLANT_ID = V_CUR1ST_PLANT_ID  /* 'A040' */
                                            AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD  /* '20240722' */
                                            AND CHILD_ITEM_ID = V_260BOH_CHILD_ITEM_ID )   /* 'ACEN1057I-A1' */
                                      WHERE ROWNUM = 1 ),1)
                          INTO V_260BOH_YIELD
                          FROM DUAL;

                        /* 4. @260boh_CHILD_QTY */
                        SELECT NVL(( SELECT CHILD_QTY FROM (
                                         SELECT NVL(CHILD_QTY,1) AS CHILD_QTY  /* child_qty 를 가져오는 부분. */
                                           FROM SCM_MST_BOM_EFFECTIVE_SN_V
                                          WHERE MODEL_ID = V_260BOH_MODEL_ITEM_ID  /* 'APRSAL38L-A2' */
                                            AND PARENT_ITEM_ID = V_CUR1ST_ITEM_ID /* 'AMDAU0032A' */
                                            AND CHILD_ITEM_ID = V_260BOH_CHILD_ITEM_ID /* 'ACEN1057I-A1' */
                                            AND DIVISION_ID = V_CUR1ST_DIVISION_ID /* '81' */
                                            AND PLANT_ID = V_CUR1ST_PLANT_ID )
                                      WHERE ROWNUM = 1 ),1)
                          INTO V_260BOH_CHILD_QTY
                          FROM DUAL;

                        /* 5. */
                        V_CUR330_BOH_QTY := V_CUR1ST_BOH_QTY * V_260BOH_CHILD_QTY / V_260BOH_YIELD;
                        V_CUR330_BOH_REMAIN_QTY := V_CUR330_BOH_QTY;

/* =========== in-house-moving 대상 찾기 end */
/* 330 cursor start */
                        /* PROD_PLAN Cursor */
                        OPEN CUR_260_330_BOH_ALLOC_ITEM;
                        LOOP
                            FETCH CUR_260_330_BOH_ALLOC_ITEM INTO V_CUR330_DIVISION_ID, V_CUR330_OPERATION_GROOUP, V_CUR330_COMPANY_ID, V_CUR330_PLANT_ID, V_CUR330_PLAN_START_YYYYMMDD, V_CUR330_CELL_ITEM_ID, V_CUR330_ITEM_ID, V_CUR330_YYYYMM, V_CUR330_QTY, V_CUR330_MEASURE, V_CUR330_SEQ_FLAG
                                                                  , V_CUR330_VALUE_TYPE, V_CUR330_TO_PRODUCT, V_CUR330_LINE_ID, V_CUR330_TO_SITE, V_CUR330_INCOTERMS;
                            EXIT WHEN CUR_260_330_BOH_ALLOC_ITEM%NOTFOUND;

                            IF V_CUR330_BOH_REMAIN_QTY > V_CUR330_QTY THEN
                                UPDATE GT_PIB_MAIN A SET QTY = 0
                                 WHERE DIVISION_ID = V_CUR330_DIVISION_ID
                                   AND OPERATION_GROUP = V_CUR330_OPERATION_GROOUP
                                   AND COMPANY_ID = V_CUR330_COMPANY_ID
                                   AND PLANT_ID = V_CUR330_PLANT_ID
                                   AND PLAN_START_YYYYMMDD = V_CUR330_PLAN_START_YYYYMMDD
                                   AND CELL_ITEM_ID = V_CUR330_CELL_ITEM_ID
                                   AND ITEM_ID = V_CUR330_ITEM_ID
                                   AND YYYYMM = V_CUR330_YYYYMM
                                   AND MEASURE = V_CUR330_MEASURE
                                   AND SEQ_FLAG = V_CUR330_SEQ_FLAG
                                   AND VALUE_TYPE = V_CUR330_VALUE_TYPE
                                   AND TO_PRODUCT = V_CUR330_TO_PRODUCT
                                   AND LINE_ID = V_CUR330_LINE_ID
                                   AND TO_SITE = V_CUR330_TO_SITE
                                   AND INCOTERMS = V_CUR330_INCOTERMS;

                                V_CUR330_BOH_REMAIN_QTY := V_CUR330_BOH_REMAIN_QTY - V_CUR330_QTY;

                            ELSIF V_CUR330_BOH_REMAIN_QTY <= V_CUR330_QTY THEN
                                UPDATE GT_PIB_MAIN A SET QTY = QTY - V_CUR330_BOH_REMAIN_QTY
                                 WHERE DIVISION_ID = V_CUR330_DIVISION_ID
                                   AND OPERATION_GROUP = V_CUR330_OPERATION_GROOUP
                                   AND COMPANY_ID = V_CUR330_COMPANY_ID
                                   AND PLANT_ID = V_CUR330_PLANT_ID
                                   AND PLAN_START_YYYYMMDD = V_CUR330_PLAN_START_YYYYMMDD
                                   AND CELL_ITEM_ID = V_CUR330_CELL_ITEM_ID
                                   AND ITEM_ID = V_CUR330_ITEM_ID
                                   AND YYYYMM = V_CUR330_YYYYMM
                                   AND MEASURE = V_CUR330_MEASURE
                                   AND SEQ_FLAG = V_CUR330_SEQ_FLAG
                                   AND VALUE_TYPE = V_CUR330_VALUE_TYPE
                                   AND TO_PRODUCT = V_CUR330_TO_PRODUCT
                                   AND LINE_ID = V_CUR330_LINE_ID
                                   AND TO_SITE = V_CUR330_TO_SITE
                                   AND INCOTERMS = V_CUR330_INCOTERMS;

                                V_CUR330_BOH_REMAIN_QTY := 0;
                                EXIT;  /* set @CUR330_Boh_REMAIN_QTY = 0 이 됨. */
                            END IF;
                        END LOOP;
                        CLOSE CUR_260_330_BOH_ALLOC_ITEM;

                    END IF;
/* 330 cursor end */
                END LOOP; /* OPEN CUR_260_BOH_ALLOC */
                CLOSE CUR_260_BOH_ALLOC;
            END;   /* BOH로 PROD 차감 END */
/* === 260 boh 차감 end */

            INSERT INTO GT_PIB_GROUPBY
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY )
            SELECT DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, SUM(BOH_QTY), TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, SUM(QTY)
              FROM GT_PIB_MAIN
             /* WHERE DIVISION_ID = '40' */
             /* AND PLAN_START_YYYYMMDD = '20240902' */
             GROUP BY DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE, CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM;

            UPDATE GT_PIB_GROUPBY A SET A.ATTRIBUTE1 = A.TO_PRODUCT
             WHERE A.TO_PRODUCT IN ( SELECT DISTINCT LM.SEGMENT1
                                       FROM SCM_ADM_LOOKUP_MASTER_DETAIL LM
                                      WHERE LM.LOOKUP_TYPE = 'MULTI_CHILD_ITEM'
                                        AND LM.VALID_YN = 'Y');

/* 소숫점 없애기 */
            UPDATE GT_PIB_GROUPBY A SET BOH_QTY = ROUND(NVL(BOH_QTY,0),0)
                                      , QTY     = ROUND(NVL(QTY,0),0);

/* 월_INVentory 생성 START */
            V_STATUS_DESC := 'INV';
            V_MIN_YYYYMM := SUBSTR(V_PLAN_START_YYYYMMDD,1,6);   /* 원본 SELECT @MIN_YYYYMM = substring(...) (FROM 없음 → 직접 대입) */

            SELECT MAX(YYYYMM)
              INTO V_MAX_YYYYMM
              FROM GT_PIB_GROUPBY A
             WHERE DIVISION_ID = V_DIVISION_ID
               AND PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD;

            V_PROC_YYYYMM := V_MIN_YYYYMM;
            V_PROC_YYYYMMDD := V_PROC_YYYYMM || '01';
            V_I := 0;

            WHILE (V_PROC_YYYYMM <= V_MAX_YYYYMM) LOOP

                IF (V_I > 50) THEN
                    EXIT;
                END IF;

                IF ( V_PROC_YYYYMM = V_MIN_YYYYMM ) THEN
                    /* 재고가 없는 경우 첫번째 월을 QTY=0 으로 생성함. */
                    INSERT INTO GT_PIB_GROUPBY
                        ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                        , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                    SELECT   DISTINCT A.DIVISION_ID
                            ,A.COMPANY_ID
                            ,A.PLANT_ID
                            ,A.PLAN_START_YYYYMMDD
                            ,1 AS SEQ /* a.SEQ */
                            ,A.OPERATION_GROUP
                            ,A.FROM_SITE
                            ,A.CELL_ITEM_ID
                            ,A.ITEM_ID
                            ,'INV' AS MEASURE
                            ,'-' AS VALUE_TYPE
                            ,'-' AS TO_PRODUCT
                            ,'-' AS LINE_ID
                            ,0 AS BOH_QTY
                            ,'-' AS TO_SITE
                            ,'-' AS INCOTERMS
                            ,SUBSTR(SEQ_FLAG,1,1) || '60' AS SEQ_FLAG
                            ,V_PROC_YYYYMM AS YYYYMM
                            ,0 AS QTY
                            ,'SCP BATCH' AS CREATED_BY
                            ,SYSDATE AS CREATION_DATE
                            ,'SCP BATCH' AS LAST_UPDATED_BY
                            ,SYSDATE AS LAST_UPDATE_DATE
                      FROM GT_PIB_GROUPBY A
                     WHERE NOT EXISTS (  SELECT 1
                                           FROM GT_PIB_GROUPBY B
                                          WHERE B.DIVISION_ID = A.DIVISION_ID
                                            AND B.COMPANY_ID = A.COMPANY_ID
                                            AND B.PLANT_ID = A.PLANT_ID
                                            AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                            AND B.SEQ = A.SEQ
                                            AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                            /* and b.FROM_SITE = a.FROM_SITE */
                                            AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                            AND B.ITEM_ID = A.ITEM_ID
                                            AND B.MEASURE = 'INV')
                       AND A.MEASURE <> 'MKT_FCST'
                       AND A.OPERATION_GROUP <> 'E';  /* 전극 제외 */

                    /* 첫번째 월의 재고(QTY) 반영 */
                    UPDATE GT_PIB_GROUPBY A
                       SET QTY = NVL(( SELECT SUM(CASE WHEN B.MEASURE = 'INV' THEN  B.BOH_QTY
                                                       WHEN B.MEASURE = 'SHIP_PLAN_SEMI' THEN  B.QTY * -1
                                                       WHEN B.MEASURE = 'SHIP_PLAN_RTF' THEN  B.QTY * -1
                                                       WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN  B.QTY * -1
                                                       WHEN B.MEASURE = 'SEMI_WH_IN' THEN  B.QTY
                                                       WHEN B.MEASURE = 'PROD_PLAN' THEN  B.QTY
                                                  END) QTY
                                         FROM GT_PIB_GROUPBY B
                                        WHERE B.DIVISION_ID = A.DIVISION_ID
                                          AND B.COMPANY_ID = A.COMPANY_ID
                                          AND B.PLANT_ID = A.PLANT_ID
                                          AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                          AND B.SEQ = A.SEQ
                                          AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                          AND B.FROM_SITE = A.FROM_SITE
                                          AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                          AND B.ITEM_ID = A.ITEM_ID
                                          AND SUBSTR(B.SEQ_FLAG,1,1) = SUBSTR(A.SEQ_FLAG,1,1)
                                          AND B.YYYYMM = A.YYYYMM ),0)
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM = V_PROC_YYYYMM
                       AND A.OPERATION_GROUP <> 'E';  /* 전극은 사실상 없음. */

                ELSE /* 두번째 월부터 마지막 월까지 재고 생성. */
                    INSERT INTO GT_PIB_GROUPBY
                        ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                        , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY
                        , CREATED_BY, CREATION_DATE, LAST_UPDATED_BY, LAST_UPDATE_DATE )
                    SELECT   DISTINCT A.DIVISION_ID
                            ,A.COMPANY_ID
                            ,A.PLANT_ID
                            ,A.PLAN_START_YYYYMMDD
                            ,1 AS SEQ /* a.SEQ */
                            ,A.OPERATION_GROUP
                            ,A.FROM_SITE
                            ,A.CELL_ITEM_ID
                            ,A.ITEM_ID
                            ,'INV' AS MEASURE
                            ,'-' AS VALUE_TYPE
                            ,'-' AS TO_PRODUCT
                            ,'-' AS LINE_ID
                            ,A.BOH_QTY AS BOH_QTY
                            ,'-' AS TO_SITE
                            ,'-' AS INCOTERMS
                            ,SUBSTR(A.SEQ_FLAG,1,1) || '60' AS SEQ_FLAG
                            ,V_PROC_YYYYMM AS YYYYMM
                            ,NVL(A.QTY,0) + NVL(( SELECT SUM(CASE  WHEN B.MEASURE = 'SHIP_PLAN_SEMI' THEN  B.QTY * -1
                                                                   WHEN B.MEASURE = 'SHIP_PLAN_RTF' THEN  B.QTY * -1
                                                                   WHEN B.MEASURE = 'IN_HOUSE_MOVING' THEN  B.QTY * -1
                                                                   WHEN B.MEASURE = 'SEMI_WH_IN' THEN  B.QTY
                                                                   WHEN B.MEASURE = 'PROD_PLAN' THEN  B.QTY
                                                              END) QTY
                                                    FROM GT_PIB_GROUPBY B
                                                   WHERE B.DIVISION_ID = A.DIVISION_ID
                                                     AND B.COMPANY_ID = A.COMPANY_ID
                                                     AND B.PLANT_ID = A.PLANT_ID
                                                     AND B.PLAN_START_YYYYMMDD = A.PLAN_START_YYYYMMDD
                                                     AND B.SEQ = A.SEQ
                                                     AND B.OPERATION_GROUP = A.OPERATION_GROUP
                                                     AND B.FROM_SITE = A.FROM_SITE
                                                     AND B.CELL_ITEM_ID = A.CELL_ITEM_ID
                                                     AND B.ITEM_ID = A.ITEM_ID
                                                     AND SUBSTR(B.SEQ_FLAG,1,1) = SUBSTR(A.SEQ_FLAG,1,1)
                                                     AND B.YYYYMM = V_PROC_YYYYMM
                                                   ),0) AS QTY
                            ,'SCP BATCH' AS CREATED_BY
                            ,SYSDATE AS CREATION_DATE
                            ,'SCP BATCH' AS LAST_UPDATED_BY
                            ,SYSDATE AS LAST_UPDATE_DATE
                      FROM GT_PIB_GROUPBY A
                     WHERE A.MEASURE = 'INV'
                       AND A.YYYYMM = V_PRE_YYYYMM
                       AND A.OPERATION_GROUP <> 'E';  /* 전극은 사실상 없음. */
                END IF;

                V_I := V_I + 1;

                V_PROC_YYYYMMDD := TO_CHAR(ADD_MONTHS(TO_DATE(V_PROC_YYYYMMDD,'YYYYMMDD'), 1), 'YYYYMMDD');
                V_PRE_YYYYMM := V_PROC_YYYYMM;
                V_PROC_YYYYMM := SUBSTR(V_PROC_YYYYMMDD,1,6);

            END LOOP;

            /* ----------------------------------------------------------------------------------------------------------- */
            /* ESS 용 전극 Item 정보 삭제 처리 : 81 전극에서 ESS 전극 일부 생산 */
            /* ----------------------------------------------------------------------------------------------------------- */
            /* CSR : E20250814-001139 2) ESS 셀에 대한 전극 계획 삭제하는 로직은 81 사업부에서만 수행하고, JV 법인은 삭제하지 않는 것으로 수정해서, 개발에서 새로 계획 수립 */
            /* CSR : E20260109-002382 ESS JV 혼용생산 관련 통합 PSI 레포트 구성 */
            /* 20260123  81도 삭제처리하기로 함. */
            BEGIN
                SELECT MS2.DIVISION_ID
                  INTO V_FROM_DIVISION_ID
                  FROM SCM_MST_SITE MS
                       INNER JOIN SCM_MST_SITE MS2
                               ON MS.SCM_SITE_ID = MS2.ATTRIBUTE9
                 WHERE MS.DIVISION_ID  = P_DIVISION_ID
                   AND MS.SITE_TYPE    = 'PLANT'
                   AND MS.VALID_YN     = 'Y'
                   AND MS2.DIVISION_ID = '82'
                   AND ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            IF V_FROM_DIVISION_ID = '82' OR V_DIVISION_ID = '81' THEN /* E20260109-002382 81도 삭제하기로 함 차후 82에 가상추가예정. */
                DELETE FROM GT_PIB_GROUPBY
                 WHERE 1 = 1
                   AND OPERATION_GROUP != 'E'
                   AND CELL_ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_MST_FINAL_ITEM
                                         WHERE DIVISION_ID = V_DIVISION_ID
                                           AND FLOW_ID NOT LIKE 'E2000%'
                                           AND ATTRIBUTE1  LIKE 'EC%'
                                        );
            END IF;

            IF V_DIVISION_ID = '81' OR V_FROM_DIVISION_ID = '82' THEN
                DELETE FROM GT_PIB_GROUPBY
                 WHERE 1 = 1
                   AND OPERATION_GROUP = 'E'
                   AND ITEM_ID IN (SELECT DISTINCT ITEM_ID FROM SCP_MST_FINAL_ITEM
                                    WHERE DIVISION_ID = V_DIVISION_ID
                                      AND FLOW_ID LIKE 'E2000%'
                                      AND CELL_ITEM_ID LIKE 'EC%'
                                   );
            END IF;

    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
    /* 2025.03.013  Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'Begin   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 기간 정보');
            /* ---------------------------------------------------------------------------------------------------------------- */
            V_FILL_0_TARGET_PERIOD := -1;
            V_FILL_0_TARGET_PERIOD_END_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);

            BEGIN
                SELECT SEGMENT1, FILL_END
                  INTO V_FILL_0_TARGET_PERIOD, V_FILL_0_TARGET_PERIOD_END_YYYYMM
                  FROM ( SELECT L.SEGMENT1 AS SEGMENT1
                              , CASE WHEN TO_NUMBER(L.SEGMENT1) > 0
                                     THEN TO_CHAR(LAST_DAY(ADD_MONTHS(V_PLAN_START_DATE, TO_NUMBER(L.SEGMENT1) - 1)), 'YYYYMM')
                                     ELSE V_FILL_0_TARGET_PERIOD_END_YYYYMM
                                END AS FILL_END
                           FROM SCM_ADM_LOOKUP_MASTER_DETAIL L
                          WHERE 1 = 1
                            AND L.LOOKUP_TYPE = 'INTEGRATION_PSI_FIFO_NEED_PRE_PERIOD' /* ESS 선입선출 선점 차감 기간 (0 채우기 대상 기간 - 개월수) */
                            AND L.VALID_YN = 'Y'
                            AND NVL(L.SEGMENT1, '0') IS NOT NULL
                            AND L.SEGMENT1 IS NOT NULL AND VALIDATE_CONVERSION(L.SEGMENT1 AS NUMBER) = 1
                          ORDER BY L.LAST_UPDATE_DATE DESC )
                 WHERE ROWNUM = 1;
            EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
            END;

            IF V_FILL_0_TARGET_PERIOD_END_YYYYMM > SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6) THEN
                V_FILL_0_TARGET_PERIOD_END_YYYYMM := SUBSTR(V_HORIZON_END_YYYYMMDD, 1, 6);
            END IF;

            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD : ' || TO_CHAR(V_FILL_0_TARGET_PERIOD));
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '@V_FILL_0_TARGET_PERIOD_END_YYYYMM : ' || V_FILL_0_TARGET_PERIOD_END_YYYYMM);

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 기간 월 목록');
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIB_MM_LIST;
            INSERT INTO GT_PIB_MM_LIST
            SELECT DISTINCT YYYYMM
              FROM SCM_MST_BUCKET B
             WHERE 1 = 1
               AND B.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM;

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure');
            /* ---------------------------------------------------------------------------------------------------------------- */

            DELETE FROM GT_PIB_TARGET_MM_0;
            INSERT INTO GT_PIB_TARGET_MM_0
                ( DIVISION_ID, COMPANY_ID, PLANT_ID, PLAN_START_YYYYMMDD, SEQ, OPERATION_GROUP, FROM_SITE
                , CELL_ITEM_ID, ITEM_ID, MEASURE, VALUE_TYPE, TO_PRODUCT, LINE_ID, BOH_QTY, TO_SITE, INCOTERMS, SEQ_FLAG, YYYYMM, QTY, ATTRIBUTE1 )
            SELECT T.DIVISION_ID
                  ,T.COMPANY_ID
                  ,T.PLANT_ID
                  ,T.PLAN_START_YYYYMMDD
                  ,T.SEQ
                  ,T.OPERATION_GROUP
                  ,T.FROM_SITE
                  ,T.CELL_ITEM_ID
                  ,T.ITEM_ID
                  ,T.MEASURE
                  ,T.VALUE_TYPE
                  ,T.TO_PRODUCT
                  ,T.LINE_ID
                  ,T.BOH_QTY
                  ,T.TO_SITE
                  ,T.INCOTERMS
                  ,T.SEQ_FLAG
                  ,M.YYYYMM
                  ,NVL(MAX(CASE WHEN T.YYYYMM = M.YYYYMM THEN T.QTY ELSE NULL END),0)	AS QTY	/* 재고를 제외하고 음수가 없기 떄문에 MAX처리 문제 없음 ?! */
                  ,MAX(T.ATTRIBUTE1)														AS ATTRIBUTE1
              FROM GT_PIB_GROUPBY T
                   INNER JOIN GT_PIB_MM_LIST M
                           ON 1 = 1
             WHERE 1 = 1
               AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV')
               AND T.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM
             GROUP BY T.DIVISION_ID
                     ,T.COMPANY_ID
                     ,T.PLANT_ID
                     ,T.PLAN_START_YYYYMMDD
                     ,T.SEQ
                     ,T.OPERATION_GROUP
                     ,T.FROM_SITE
                     ,T.CELL_ITEM_ID
                     ,T.ITEM_ID
                     ,T.MEASURE
                     ,T.VALUE_TYPE
                     ,T.TO_PRODUCT
                     ,T.LINE_ID
                     ,T.BOH_QTY
                     ,T.TO_SITE
                     ,T.INCOTERMS
                     ,T.SEQ_FLAG
                     ,M.YYYYMM;

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 채우기 전 데이터 삭제 (해당 기간)');
            /* ---------------------------------------------------------------------------------------------------------------- */
            DELETE FROM GT_PIB_GROUPBY T
             WHERE 1 = 1
               AND T.YYYYMM BETWEEN V_PLAN_START_YYYYMM
                                AND V_FILL_0_TARGET_PERIOD_END_YYYYMM
               AND T.MEASURE NOT IN ('SHIP_PLAN_RTF', 'MKT_FCST', 'INV');

            /* ---------------------------------------------------------------------------------------------------------------- */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || '빈월 0 채우기 대상 Measure - 0 채운 데이터 Insert - Start ');
            /* ---------------------------------------------------------------------------------------------------------------- */
            INSERT INTO GT_PIB_GROUPBY (
                   DIVISION_ID
                  ,COMPANY_ID
                  ,PLANT_ID
                  ,PLAN_START_YYYYMMDD
                  ,SEQ
                  ,OPERATION_GROUP
                  ,FROM_SITE
                  ,CELL_ITEM_ID
                  ,ITEM_ID
                  ,MEASURE
                  ,VALUE_TYPE
                  ,TO_PRODUCT
                  ,LINE_ID
                  ,BOH_QTY
                  ,TO_SITE
                  ,INCOTERMS
                  ,SEQ_FLAG
                  ,YYYYMM
                  ,QTY
                  ,ATTRIBUTE1)
            SELECT T.DIVISION_ID
                  ,T.COMPANY_ID
                  ,T.PLANT_ID
                  ,T.PLAN_START_YYYYMMDD
                  ,T.SEQ
                  ,T.OPERATION_GROUP
                  ,T.FROM_SITE
                  ,T.CELL_ITEM_ID
                  ,T.ITEM_ID
                  ,T.MEASURE
                  ,T.VALUE_TYPE
                  ,T.TO_PRODUCT
                  ,T.LINE_ID
                  ,T.BOH_QTY
                  ,T.TO_SITE
                  ,T.INCOTERMS
                  ,T.SEQ_FLAG
                  ,T.YYYYMM
                  ,T.QTY
                  ,T.ATTRIBUTE1
              FROM GT_PIB_TARGET_MM_0 T;

    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */
    /* 2025.03.013  End   PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영 */
            DBMS_OUTPUT.PUT_LINE(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS".000"') || 'End	 PJ20249548R  LGES SCP역량 강화를 위한 기준정보PSI엔진 기능개선 : 빈월 수량 0 데이터 생성 반영');
    /* -------------------------------------------------------------------------------------------------------------------------------------------------------- */

            /* ----------------------------------------------------------------------------------------------------------- */
            /* 이전 동일 수행건 삭제 후 수행내역 Insert */
            /* 삭제 & insert */
            /* ----------------------------------------------------------------------------------------------------------- */
            V_STATUS_DESC := 'Delete';
            DELETE FROM SCP_ANL_PSI_INTEGRATION A
             WHERE A.PLAN_START_YYYYMMDD = V_PLAN_START_YYYYMMDD
               AND A.DIVISION_ID         = V_DIVISION_ID;

            V_STATUS_DESC := 'insert';
            INSERT INTO SCP_ANL_PSI_INTEGRATION
                    (  DIVISION_ID
                      ,COMPANY_ID
                      ,PLANT_ID
                      ,PLAN_START_YYYYMMDD
                      ,SEQ
                      ,OPERATION_GROUP
                      ,FROM_SITE
                      ,CELL_ITEM_ID
                      ,ITEM_ID
                      ,MEASURE   /* 10 */
                      ,VALUE_TYPE
                      ,TO_PRODUCT
                      ,LINE_ID
                      ,BOH_QTY
                      ,TO_SITE
                      ,INCOTERMS
                      ,SEQ_FLAG
                      ,YYYYMM
                      ,QTY
                      ,CREATED_BY
                      ,CREATION_DATE
                      ,LAST_UPDATED_BY     /* 10 */
                      ,LAST_UPDATE_DATE
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
                    )
            SELECT   DIVISION_ID
                    ,NVL(COMPANY_ID,'-')
                    ,NVL(PLANT_ID,'-')
                    ,PLAN_START_YYYYMMDD
                    ,SEQ
                    ,OPERATION_GROUP
                    ,FROM_SITE
                    ,CELL_ITEM_ID
                    ,ITEM_ID
                    ,MEASURE
                    ,VALUE_TYPE
                    ,TO_PRODUCT
                    ,LINE_ID
                    /* ,BOH_QTY */
                    ,ROUND(NVL(BOH_QTY,0),0)
                    ,TO_SITE
                    ,NVL(INCOTERMS,'-')
                    ,SEQ_FLAG
                    ,YYYYMM
                    /* ,QTY */
                    ,ROUND(NVL(QTY,0),0)
                    ,'SCP BATCH' AS CREATED_BY
                    ,SYSDATE AS CREATION_DATE
                    ,'SCP BATCH' AS LAST_UPDATED_BY
                    ,SYSDATE AS LAST_UPDATE_DATE
                    ,ATTRIBUTE1
                    ,V_PLAN_TYPE									AS	ATTRIBUTE2	/* 2025.03.13 수정 */
                    ,TO_CHAR(V_FILL_0_TARGET_PERIOD)                AS	ATTRIBUTE3	/* 2025.03.13 수정 */
                    ,ATTRIBUTE4
                    ,ATTRIBUTE5
                    ,ATTRIBUTE6
                    ,ATTRIBUTE7
                    ,ATTRIBUTE8
                    ,ATTRIBUTE9
                    ,ATTRIBUTE10
              FROM GT_PIB_GROUPBY;


            DELETE FROM GT_PIB_MAIN;
            DELETE FROM GT_PIB_GROUPBY;
            DELETE FROM GT_PIB_INV;
            DELETE FROM GT_PIB_320_340;
            DELETE FROM GT_PIB_350;
            DELETE FROM GT_PIB_YIELD_A;
            DELETE FROM GT_PIB_ITEM_BOM;
            DELETE FROM GT_PIB_230_250;
            DELETE FROM GT_PIB_ELEC_PLANT;
            DELETE FROM GT_PIB_CELL_ELEC_MAP;
            DELETE FROM GT_PIB_MM_LIST;
            DELETE FROM GT_PIB_TARGET_MM_0;

            /* TXN LOG */
            V_LOG_TYPE    := 'TXN';

            N_LOG_COUNT   := 1;
            V_LOG_MESSAGE := 'INSERT INTO ' || V_TABLE_ID;
            D_EVENT_DATE  := SYSDATE;
            V_DESCRIPTION := 'Process Complete...' || ':' || TO_CHAR(D_EVENT_DATE,'YYYYMMDD') || ':' || V_DIVISION_ID;

            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );


            COMMIT;

        END;
    EXCEPTION
        WHEN OTHERS THEN


            ROLLBACK;
            V_JJGV_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            DBMS_OUTPUT.PUT_LINE('ERROR JJG-Catch');
            DBMS_OUTPUT.PUT_LINE(V_JJGV_LOG_MESSAGE);

            /* ERROR LOG */
            V_LOG_TYPE    := 'ERROR';
            V_LOG_MESSAGE := SUBSTR(SQLERRM, 1, 1000);
            V_DESCRIPTION := SUBSTR(V_STATUS_DESC || '  ERROR_LINE : ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE, 1, 500);
            D_EVENT_DATE  := SYSDATE;
            PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                                , P_LOG_TYPE     => V_LOG_TYPE
                                , P_LOG_COUNT    => N_LOG_COUNT
                                , P_LOG_MESSAGE  => V_LOG_MESSAGE
                                , P_DESCRIPTION  => V_DESCRIPTION
                                , P_EVENT_DATE   => D_EVENT_DATE
                                , P_USER_ID      => V_BATCH_USER
                                );
            RETURN;
    END;

    /* 임시 운영반영시에 주석처리 할것. */

    V_EXEC_TIME := CASE WHEN LENGTH(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60))) > 2 THEN NULL
                        ELSE LPAD(TO_CHAR(TRUNC(ROUND((SYSDATE - V_START_TIME) * 86400) / 60)), 2, '0') || ':' ||
                             LPAD(TO_CHAR(MOD(ROUND((SYSDATE - V_START_TIME) * 86400), 60)), 2, '0')
                   END;

    /* 종료 LOG */
    V_LOG_TYPE    := 'END';
    V_LOG_MESSAGE := '########## END of procedure ##########';

    V_DESCRIPTION := '['||V_STATUS_DESC||']['||V_PLAN_START_YYYYMMDD||'][' || V_EXEC_TIME || ']';
    D_EVENT_DATE  := SYSDATE;

    PR_SCP_SYS_LOG_BATCH( P_PROGRAM_NAME => V_PROGRAM_NAME
                        , P_LOG_TYPE     => V_LOG_TYPE
                        , P_LOG_COUNT    => N_LOG_COUNT
                        , P_LOG_MESSAGE  => V_LOG_MESSAGE
                        , P_DESCRIPTION  => V_DESCRIPTION
                        , P_EVENT_DATE   => D_EVENT_DATE
                        , P_USER_ID      => V_BATCH_USER
                        );
    RETURN;

END;